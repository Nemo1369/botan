/*
* OCSP
* (C) 2012 Jack Lloyd
*
* Botan is released under the Simplified BSD License (see license.txt)
*/

#ifndef BOTAN_OCSP_H__
#define BOTAN_OCSP_H__

#include <botan/cert_status.h>
#include <botan/ocsp_types.h>

namespace Botan {

class Certificate_Store;

namespace OCSP {

/**
* An OCSP request.
*/
class BOTAN_DLL Request
   {
   public:
      /**
      * Create an OCSP request.
      * @param issuer_cert issuer certificate
      * @param subject_cert subject certificate
      */
      Request(const X509_Certificate& issuer_cert,
              const X509_Certificate& subject_cert) :
         m_issuer(issuer_cert),
         m_subject(subject_cert)
         {}

      /**
      * @return BER-encoded OCSP request
      */
      std::vector<byte> BER_encode() const;

      /**
      * @return Base64-encoded OCSP request
      */
      std::string base64_encode() const;

      /**
      * @return issuer certificate
      */
      const X509_Certificate& issuer() const { return m_issuer; }

      /**
      * @return subject certificate
      */
      const X509_Certificate& subject() const { return m_subject; }
   private:
      X509_Certificate m_issuer, m_subject;
   };

/**
* An OCSP response.
*/
class BOTAN_DLL Response
   {
   public:
      /**
      * Creates an empty OCSP response.
      */
      Response() {}

      /**
      * Creates an OCSP response.
      * @param response_bits response bits received
      */
      Response(const std::vector<byte>& response_bits);

      // Throws if validation failed
      void check_signature(const Certificate_Store& trust_roots);

      const X509_Time& produced_at() const { return m_produced_at; }

      /**
       * Searches the OCSP response for issuer and subject certificate.
       * @param issuer issuer certificate
       * @param subject subject certificate
       * @return OCSP status code, possible values:
       *         CERT_IS_REVOKED,
       *         OCSP_NOT_YET_VALID,
       *         OCSP_HAS_EXPIRED,
       *         OCSP_RESPONSE_GOOD,
       *         OCSP_BAD_STATUS,
       *         OCSP_CERT_NOT_LISTED
       */
      Certificate_Status_Code status_for(const X509_Certificate& issuer,
                                         const X509_Certificate& subject) const;

   private:
      X509_Time m_produced_at;
      X509_DN m_signer_name;
      std::vector<byte> m_tbs_bits;
      AlgorithmIdentifier m_sig_algo;
      std::vector<byte> m_signature;
      std::vector<X509_Certificate> m_certs;

      std::vector<SingleResponse> m_responses;
   };

/**
* Makes an online OCSP request via HTTP and returns the OCSP response.
* @param issuer issuer certificate
* @param subject subject certificate
* @param trusted_roots trusted roots for the OCSP response
* @return OCSP response
*/
BOTAN_DLL Response online_check(const X509_Certificate& issuer,
                                const X509_Certificate& subject,
                                const Certificate_Store* trusted_roots);

}

}

#endif
