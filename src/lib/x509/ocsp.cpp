/*
* OCSP
* (C) 2012,2013 Jack Lloyd
*
* Botan is released under the Simplified BSD License (see license.txt)
*/

#include <botan/ocsp.h>
#include <botan/certstor.h>
#include <botan/der_enc.h>
#include <botan/ber_dec.h>
#include <botan/x509_ext.h>
#include <botan/oids.h>
#include <botan/base64.h>
#include <botan/pubkey.h>
#include <botan/x509path.h>
#include <botan/http_util.h>

namespace Botan {

namespace OCSP {

namespace {

// TODO: should this be in a header somewhere?
void decode_optional_list(BER_Decoder& ber,
                          ASN1_Tag tag,
                          std::vector<X509_Certificate>& output)
   {
   BER_Object obj = ber.get_next_object();

   if(obj.type_tag != tag || obj.class_tag != (CONTEXT_SPECIFIC | CONSTRUCTED))
      {
      ber.push_back(obj);
      return;
      }

   BER_Decoder list(obj.value);

   while(list.more_items())
      {
      BER_Object certbits = list.get_next_object();
      X509_Certificate cert(unlock(certbits.value));
      output.push_back(std::move(cert));
      }
   }

}

Request::Request(const X509_Certificate& issuer_cert,
                 const X509_Certificate& subject_cert) :
   m_issuer(issuer_cert),
   m_subject(subject_cert),
   m_certid(m_issuer, m_subject)
   {
   }

std::vector<byte> Request::BER_encode() const
   {
   return DER_Encoder().start_cons(SEQUENCE)
        .start_cons(SEQUENCE)
          .start_explicit(0)
            .encode(static_cast<size_t>(0)) // version #
          .end_explicit()
            .start_cons(SEQUENCE)
              .start_cons(SEQUENCE)
                .encode(m_certid)
              .end_cons()
            .end_cons()
          .end_cons()
      .end_cons().get_contents_unlocked();
   }

std::string Request::base64_encode() const
   {
   return Botan::base64_encode(BER_encode());
   }

Response::Response(const Request& request, const std::vector<byte>& response_bits)
   {
   BER_Decoder response_outer = BER_Decoder(response_bits).start_cons(SEQUENCE);

   size_t resp_status = 0;

   response_outer.decode(resp_status, ENUMERATED, UNIVERSAL);

   if(resp_status != 0)
      throw Exception("OCSP response status " + std::to_string(resp_status));

   if(response_outer.more_items())
      {
      BER_Decoder response_bytes =
         response_outer.start_cons(ASN1_Tag(0), CONTEXT_SPECIFIC).start_cons(SEQUENCE);

      response_bytes.decode_and_check(OID("1.3.6.1.5.5.7.48.1.1"),
                                      "Unknown response type in OCSP response");

      BER_Decoder basicresponse =
         BER_Decoder(response_bytes.get_next_octet_string()).start_cons(SEQUENCE);

      basicresponse.start_cons(SEQUENCE)
           .raw_bytes(m_tbs_bits)
         .end_cons()
         .decode(m_sig_algo)
         .decode(m_signature, BIT_STRING);
      decode_optional_list(basicresponse, ASN1_Tag(0), m_certs);

      size_t responsedata_version = 0;
      Extensions extensions;

      BER_Decoder(m_tbs_bits)
         .decode_optional(responsedata_version, ASN1_Tag(0),
                          ASN1_Tag(CONSTRUCTED | CONTEXT_SPECIFIC))

         .decode_optional(m_signer_name, ASN1_Tag(1),
                          ASN1_Tag(CONSTRUCTED | CONTEXT_SPECIFIC))

         .decode_optional_string(m_key_hash, OCTET_STRING, 2,
                                 ASN1_Tag(CONSTRUCTED | CONTEXT_SPECIFIC))

         .decode(m_produced_at)

         .decode_list(m_responses)

         .decode_optional(extensions, ASN1_Tag(1),
                          ASN1_Tag(CONSTRUCTED | CONTEXT_SPECIFIC));

      if(m_key_hash == request.issuer_key_hash() && m_certs.empty())
         {
         m_certs.push_back(request.issuer());
         }
      }

   response_outer.end_cons();
   }

Certificate_Status_Code Response::verify_signature(const X509_Certificate& issuer) const
   {
   try
      {
      std::unique_ptr<Public_Key> pub_key(issuer.subject_public_key());

      const std::vector<std::string> sig_info =
         split_on(OIDS::lookup(m_sig_algo.oid), '/');

      if(sig_info.size() != 2 || sig_info[0] != pub_key->algo_name())
         return Certificate_Status_Code::OCSP_RESPONSE_INVALID;

      std::string padding = sig_info[1];
      Signature_Format format = (pub_key->message_parts() >= 2) ? DER_SEQUENCE : IEEE_1363;

      PK_Verifier verifier(*pub_key, padding, format);

      if(verifier.verify_message(ASN1::put_in_sequence(m_tbs_bits), m_signature))
         return Certificate_Status_Code::OCSP_SIGNATURE_OK;
      else
         return Certificate_Status_Code::OCSP_SIGNATURE_ERROR;
      }
   catch(Exception&)
      {
      return Certificate_Status_Code::OCSP_SIGNATURE_ERROR;
      }
   }

Certificate_Status_Code Response::check_signature(const Certificate_Store& trusted_roots)
   {
   if(m_certs.empty())
      {
      if(auto cert = trusted_roots.find_cert(m_signer_name, std::vector<byte>()))
         m_certs.push_back(*cert);
      }

   if(m_certs.size() < 1)
      return Certificate_Status_Code::OCSP_ISSUER_NOT_FOUND;

   if(trusted_roots.certificate_known(m_certs[0]))
      return this->verify_signature(m_certs[0]);

   // Otherwise attempt to chain the signing cert to a trust root

   if(!m_certs[0].allowed_extended_usage("PKIX.OCSPSigning"))
      return Certificate_Status_Code::OCSP_RESPONSE_MISSING_KEYUSAGE;

   auto result = x509_path_validate(m_certs, Path_Validation_Restrictions(), trusted_roots);

   if(!result.successful_validation())
      return result.result();

   if(!trusted_roots.certificate_known(result.trust_root())) // not needed anymore?
      return Certificate_Status_Code::OCSP_ISSUER_NOT_FOUND;

   if(result.cert_path().size() < 1)
      return Certificate_Status_Code::OCSP_ISSUER_NOT_FOUND;

   return this->verify_signature(*result.cert_path()[0]);
   }

Certificate_Status_Code Response::status_for(const X509_Certificate& issuer,
                                             const X509_Certificate& subject,
                                             std::chrono::system_clock::time_point ref_time) const
   {
   for(const auto& response : m_responses)
      {
      if(response.certid().is_id_for(issuer, subject))
         {
         X509_Time x509_ref_time(ref_time);

         if(response.cert_status() == 1)
            return Certificate_Status_Code::CERT_IS_REVOKED;

         if(response.this_update() > x509_ref_time)
            return Certificate_Status_Code::OCSP_NOT_YET_VALID;

         if(response.next_update().time_is_set() && x509_ref_time > response.next_update())
            return Certificate_Status_Code::OCSP_HAS_EXPIRED;

         if(response.cert_status() == 0)
            return Certificate_Status_Code::OCSP_RESPONSE_GOOD;
         else
            return Certificate_Status_Code::OCSP_BAD_STATUS;
         }
      }

   return Certificate_Status_Code::OCSP_CERT_NOT_LISTED;
   }

Response online_check(const X509_Certificate& issuer,
                      const X509_Certificate& subject,
                      const Certificate_Store* trusted_roots)
   {
   const std::string responder_url = subject.ocsp_responder();

   if(responder_url.empty())
      throw Exception("No OCSP responder specified");

   OCSP::Request req(issuer, subject);

   auto http = HTTP::POST_sync(responder_url,
                               "application/ocsp-request",
                               req.BER_encode());

   http.throw_unless_ok();

   // Check the MIME type?

   OCSP::Response response(req, http.body());

   if(trusted_roots)
      response.check_signature(*trusted_roots);

   return response;
   }

std::shared_ptr<Response>
ocsp_check(const X509_Certificate& issuer,
           const X509_Certificate& subject)
   {
   const std::string responder_url = subject.ocsp_responder();

   if(responder_url.empty())
      throw Exception("No OCSP responder specified");

   OCSP::Request req(issuer, subject);

   auto http = HTTP::POST_sync(responder_url,
                               "application/ocsp-request",
                               req.BER_encode());

   http.throw_unless_ok();
   // Check the MIME type?

   return std::make_shared<OCSP::Response>(req, http.body());
   }

}

}
