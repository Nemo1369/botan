/*
* X.509 Certificate Path Validation
* (C) 2010,2011,2012,2014,2016 Jack Lloyd
*
* Botan is released under the Simplified BSD License (see license.txt)
*/

#include <botan/x509path.h>
#include <botan/ocsp.h>
#include <botan/http_util.h>
#include <botan/parsing.h>
#include <botan/pubkey.h>
#include <botan/oids.h>
#include <algorithm>
#include <chrono>
#include <vector>
#include <set>
#include <future>

namespace Botan {

namespace {

/*
* PKIX validation
*/
std::vector<std::set<Certificate_Status_Code>>
check_chain(const std::vector<std::shared_ptr<const X509_Certificate>>& cert_path,
            const std::vector<std::shared_ptr<const OCSP::Response>>& ocsp_responses,
            const std::vector<std::shared_ptr<const X509_CRL>>& crls,
            const Path_Validation_Restrictions& restrictions,
            const std::vector<Certificate_Store*>& certstores,
            std::chrono::system_clock::time_point ref_time)
   {
   const bool self_signed_ee_cert = (cert_path.size() == 1);

   X509_Time validation_time(ref_time);

   std::vector<std::set<Certificate_Status_Code>> cert_status(cert_path.size());

   for(size_t i = 0; i != cert_path.size(); ++i)
      {
      std::set<Certificate_Status_Code>& status = cert_status.at(i);

      const bool at_self_signed_root = (i == cert_path.size() - 1);

      const std::shared_ptr<const X509_Certificate>& subject = cert_path[i];

      const std::shared_ptr<const X509_Certificate>& issuer = cert_path[at_self_signed_root ? (i) : (i + 1)];

      // Check all certs for valid time range
      if(validation_time < X509_Time(subject->start_time(), ASN1_Tag::UTC_OR_GENERALIZED_TIME))
         status.insert(Certificate_Status_Code::CERT_NOT_YET_VALID);

      if(validation_time > X509_Time(subject->end_time(), ASN1_Tag::UTC_OR_GENERALIZED_TIME))
         status.insert(Certificate_Status_Code::CERT_HAS_EXPIRED);

      // Check issuer constraints

      if(!issuer->is_CA_cert() && !self_signed_ee_cert)
         status.insert(Certificate_Status_Code::CA_CERT_NOT_FOR_CERT_ISSUER);

      if(issuer->path_limit() < i)
         status.insert(Certificate_Status_Code::CERT_CHAIN_TOO_LONG);

      std::unique_ptr<Public_Key> issuer_key(issuer->subject_public_key());

      if(!issuer_key)
         {
         status.insert(Certificate_Status_Code::SIGNATURE_ERROR);
         }
      else
         {
         if(subject->check_signature(*issuer_key) == false)
            status.insert(Certificate_Status_Code::SIGNATURE_ERROR);

         if(issuer_key->estimated_strength() < restrictions.minimum_key_strength())
            status.insert(Certificate_Status_Code::SIGNATURE_METHOD_TOO_WEAK);
         }

      // Allow untrusted hashes on self-signed roots
      if(!restrictions.trusted_hashes().empty() && !at_self_signed_root)
         {
         if(!restrictions.trusted_hashes().count(subject->hash_used_for_signature()))
            status.insert(Certificate_Status_Code::UNTRUSTED_HASH);
         }

      // Check cert extensions
      Extensions extensions = subject->v3_extensions();
      for(auto& extension : extensions.extensions())
         {
         extension.first->validate(*subject, *issuer, cert_path, cert_status, i);
         }
      }

   // Now process revocation data

   for(size_t i = 0; i != cert_path.size() - 1; ++i)
      {
      std::set<Certificate_Status_Code>& status = cert_status.at(i);

      std::shared_ptr<const X509_Certificate> subject = cert_path.at(i);
      std::shared_ptr<const X509_Certificate> ca = cert_path.at(i+1);

      if(const std::shared_ptr<const OCSP::Response>& ocsp = ocsp_responses[i])
         {
         // FIXME: why only first certstore?
         Certificate_Status_Code ocsp_signature_status = Certificate_Status_Code::OCSP_SIGNATURE_ERROR;
            //ocsp->check_signature(*certstores[0])

         if(ocsp_signature_status != Certificate_Status_Code::OCSP_SIGNATURE_OK)
            {
            // Some signature problem
            status.insert(ocsp_signature_status);
            }
         else
            {
            // Signature ok, so check the claimed status
            status.insert(ocsp->status_for(*ca, *subject, ref_time));
            }
         }
      else if(const std::shared_ptr<const X509_CRL>& crl = crls[i])
         {
         if(!ca->allowed_usage(CRL_SIGN))
            status.insert(Certificate_Status_Code::CA_CERT_NOT_FOR_CRL_ISSUER);

         if(validation_time < X509_Time(crl->this_update()))
            status.insert(Certificate_Status_Code::CRL_NOT_YET_VALID);

         if(validation_time > X509_Time(crl->next_update()))
            status.insert(Certificate_Status_Code::CRL_HAS_EXPIRED);

         if(crl->check_signature(ca->subject_public_key()) == false)
            status.insert(Certificate_Status_Code::CRL_BAD_SIGNATURE);

         if(crl->is_revoked(*subject))
            status.insert(Certificate_Status_Code::CERT_IS_REVOKED);
         }

      else if(restrictions.require_revocation_information())
         {
         status.insert(Certificate_Status_Code::NO_REVOCATION_DATA);
         }
      }

   if(self_signed_ee_cert)
      cert_status.back().insert(Certificate_Status_Code::CANNOT_ESTABLISH_TRUST);

   return cert_status;
   }

}

Path_Validation_Result BOTAN_DLL x509_path_validate(
   const std::vector<X509_Certificate>& end_certs,
   const Path_Validation_Restrictions& restrictions,
   const std::vector<Certificate_Store*>& certstores,
   const std::string& hostname,
   Usage_Type usage,
   std::chrono::system_clock::time_point validation_time)
   {
   if(end_certs.empty())
      throw Invalid_Argument("x509_path_validate called with no subjects");

   std::vector<std::shared_ptr<const X509_Certificate>> cert_path;
   cert_path.push_back(std::make_shared<X509_Certificate>(end_certs[0]));

   /*
   * This is an inelegant but functional way of preventing path loops
   * (where C1 -> C2 -> C3 -> C1). We store a set of all the certificate
   * fingerprints in the path. If there is a duplicate, we error out.
   * TODO: save fingerprints in result struct? Maybe useful for blacklists, etc.
   */
   std::set<std::string> certs_seen;

   cert_path.push_back(end_certs[0]);
   certs_seen.insert(cert_path[0]->fingerprint("SHA-256"));

   Certificate_Store_In_Memory ee_extras;
   for(size_t i = 1; i != end_certs.size(); ++i)
      ee_extras.add_certificate(end_certs[i]);

   // iterate until we reach a root or cannot find the issuer
   for(;;)
      {
      const X509_Certificate& last = *cert_path.back();
      const X509_DN issuer_dn = last.issuer_dn();
      const std::vector<byte> auth_key_id = last.authority_key_id();

      std::shared_ptr<const X509_Certificate> issuer;
      bool trusted_issuer = false;

      for(Certificate_Store* store : certstores)
         {
         issuer = store->find_cert(issuer_dn, auth_key_id);
         if(issuer)
            {
            trusted_issuer = true;
            break;
            }
         }

      if(!issuer)
         {
         issuer = ee_extras.find_cert(issuer_dn, auth_key_id);
         }

      if(!issuer)
         return Path_Validation_Result(Certificate_Status_Code::CERT_ISSUER_NOT_FOUND);

      const std::string fprint = issuer->fingerprint("SHA-256");
      if(certs_seen.count(fprint) > 0)
         return Path_Validation_Result(Certificate_Status_Code::CERT_CHAIN_LOOP);
      certs_seen.insert(fprint);

      cert_path.push_back(issuer);

      if(trusted_issuer)
         {
         break; // reached a trust root
         }
      else if(issuer->is_self_signed())
         {
         break; // can go no further
         }
      // otherwise try to find the issuer of cert in the next loop
      }

   std::vector<std::future<const OCSP::Response>> ocsp;

   if(cert_path.size() >= 2 && end_entity.ocsp_responder())
      {
      ocsp.push_back(
         std::async(std::launch::async, OCSP::online_check, end_entity, subject, nullptr)
         );
      }

   std::vector<std::set<Certificate_Status_Code>> res =
      check_chain(cert_path, ocsp, crls, restrictions, certstores, validation_time);

   if(!hostname.empty() && !cert_path[0]->matches_dns_name(hostname))
      res[0].insert(Certificate_Status_Code::CERT_NAME_NOMATCH);

   if(!cert_path[0]->allowed_usage(usage))
      res[0].insert(Certificate_Status_Code::INVALID_USAGE);

   return Path_Validation_Result(res, std::move(cert_path));
   }

Path_Validation_Result x509_path_validate(
   const X509_Certificate& end_cert,
   const Path_Validation_Restrictions& restrictions,
   const std::vector<Certificate_Store*>& certstores,
   const std::string& hostname,
   Usage_Type usage,
   std::chrono::system_clock::time_point when)
   {
   std::vector<X509_Certificate> certs;
   certs.push_back(end_cert);
   return x509_path_validate(certs, restrictions, certstores, hostname, usage, when);
   }

Path_Validation_Result x509_path_validate(
   const std::vector<X509_Certificate>& end_certs,
   const Path_Validation_Restrictions& restrictions,
   const Certificate_Store& store,
   const std::string& hostname,
   Usage_Type usage,
   std::chrono::system_clock::time_point when)
   {
   std::vector<Certificate_Store*> certstores;
   certstores.push_back(const_cast<Certificate_Store*>(&store));

   return x509_path_validate(end_certs, restrictions, certstores, hostname, usage, when);
   }

Path_Validation_Result x509_path_validate(
   const X509_Certificate& end_cert,
   const Path_Validation_Restrictions& restrictions,
   const Certificate_Store& store,
   const std::string& hostname,
   Usage_Type usage,
   std::chrono::system_clock::time_point when)
   {
   std::vector<X509_Certificate> certs;
   certs.push_back(end_cert);

   std::vector<Certificate_Store*> certstores;
   certstores.push_back(const_cast<Certificate_Store*>(&store));

   return x509_path_validate(certs, restrictions, certstores, hostname, usage, when);
   }

Path_Validation_Restrictions::Path_Validation_Restrictions(bool require_rev,
                                                           size_t key_strength) :
   m_require_revocation_information(require_rev),
   m_minimum_key_strength(key_strength)
   {
   if(key_strength <= 80)
      m_trusted_hashes.insert("SHA-160");

   m_trusted_hashes.insert("SHA-224");
   m_trusted_hashes.insert("SHA-256");
   m_trusted_hashes.insert("SHA-384");
   m_trusted_hashes.insert("SHA-512");
   }

Path_Validation_Result::Path_Validation_Result(std::vector<std::set<Certificate_Status_Code>> status,
                                               std::vector<std::shared_ptr<const X509_Certificate>>&& cert_chain) :
   m_overall(Certificate_Status_Code::VERIFIED),
   m_all_status(status),
   m_cert_path(cert_chain)
   {
   // take the "worst" error as overall
   for(const auto& s : m_all_status)
      {
      if(!s.empty())
         {
         auto worst = *s.rbegin();
         // Leave OCSP confirmations on cert-level status only
         if(worst != Certificate_Status_Code::OCSP_RESPONSE_GOOD)
            m_overall = worst;
         }
      }
   }

const X509_Certificate& Path_Validation_Result::trust_root() const
   {
   if(m_cert_path.empty())
      throw Exception("Path_Validation_Result::trust_root no path set");
   if(result() != Certificate_Status_Code::VERIFIED)
      throw Exception("Path_Validation_Result::trust_root meaningless with invalid status");

   return *m_cert_path[m_cert_path.size()-1];
   }

std::set<std::string> Path_Validation_Result::trusted_hashes() const
   {
   std::set<std::string> hashes;
   for(size_t i = 0; i != m_cert_path.size(); ++i)
      hashes.insert(m_cert_path[i]->hash_used_for_signature());
   return hashes;
   }

bool Path_Validation_Result::successful_validation() const
   {
   if(result() == Certificate_Status_Code::VERIFIED ||
      result() == Certificate_Status_Code::OCSP_RESPONSE_GOOD)
      return true;
   return false;
   }

std::string Path_Validation_Result::result_string() const
   {
   return status_string(result());
   }

const char* Path_Validation_Result::status_string(Certificate_Status_Code code)
   {
   if(const char* s = to_string(code))
      return s;

   return "Unknown error";
   }

}
