/*
* (C) 2016 Jack Lloyd
*
* Botan is released under the Simplified BSD License (see license.txt)
*/

#include <botan/cert_status.h>

namespace Botan {

//static
const char* to_string(Certificate_Status_Code code)
   {
   switch(code)
      {
      case Certificate_Status_Code::VERIFIED:
         return "Verified";
      case Certificate_Status_Code::OCSP_RESPONSE_GOOD:
         return "OCSP response good";
      case Certificate_Status_Code::OCSP_SIGNATURE_OK:
         return "OCSP signature accepted";

      case Certificate_Status_Code::NO_REVOCATION_DATA:
         return "No revocation data";
      case Certificate_Status_Code::SIGNATURE_METHOD_TOO_WEAK:
         return "Signature method too weak";
      case Certificate_Status_Code::UNTRUSTED_HASH:
         return "Untrusted hash";

      case Certificate_Status_Code::CERT_NOT_YET_VALID:
         return "Certificate is not yet valid";
      case Certificate_Status_Code::CERT_HAS_EXPIRED:
         return "Certificate has expired";
      case Certificate_Status_Code::OCSP_NOT_YET_VALID:
         return "OCSP is not yet valid";
      case Certificate_Status_Code::OCSP_HAS_EXPIRED:
         return "OCSP has expired";
      case Certificate_Status_Code::CRL_NOT_YET_VALID:
         return "CRL is not yet valid";
      case Certificate_Status_Code::CRL_HAS_EXPIRED:
         return "CRL has expired";

      case Certificate_Status_Code::CERT_ISSUER_NOT_FOUND:
         return "Certificate issuer not found";
      case Certificate_Status_Code::CANNOT_ESTABLISH_TRUST:
         return "Cannot establish trust";
      case Certificate_Status_Code::CERT_CHAIN_LOOP:
         return "Loop in certificate chain";

      case Certificate_Status_Code::POLICY_ERROR:
         return "Policy error";
      case Certificate_Status_Code::INVALID_USAGE:
         return "Invalid usage";
      case Certificate_Status_Code::CERT_CHAIN_TOO_LONG:
         return "Certificate chain too long";
      case Certificate_Status_Code::CA_CERT_NOT_FOR_CERT_ISSUER:
         return "CA certificate not allowed to issue certs";
      case Certificate_Status_Code::CA_CERT_NOT_FOR_CRL_ISSUER:
         return "CA certificate not allowed to issue CRLs";
      case Certificate_Status_Code::OCSP_CERT_NOT_LISTED:
         return "OCSP cert not listed";
      case Certificate_Status_Code::OCSP_BAD_STATUS:
         return "OCSP bad status";
      case Certificate_Status_Code::CERT_NAME_NOMATCH:
         return "Certificate does not match provided name";
      case Certificate_Status_Code::NAME_CONSTRAINT_ERROR:
         return "Certificate does not pass name constraint";
      case Certificate_Status_Code::UNKNOWN_CRITICAL_EXTENSION:
         return "Unknown critical extension encountered";
      case Certificate_Status_Code::OCSP_SIGNATURE_ERROR:
         return "OCSP signature error";
      case Certificate_Status_Code::OCSP_ISSUER_NOT_FOUND:
         return "OCSP issuer not found";
      case Certificate_Status_Code::OCSP_RESPONSE_MISSING_KEYUSAGE:
         return "OCSP issuer's keyusage prohibits OCSP";
      case Certificate_Status_Code::OCSP_RESPONSE_INVALID:
         return "OCSP parsing valid";
      case Certificate_Status_Code::CERT_IS_REVOKED:
         return "Certificate is revoked";
      case Certificate_Status_Code::CRL_BAD_SIGNATURE:
         return "CRL bad signature";
      case Certificate_Status_Code::SIGNATURE_ERROR:
         return "Signature error";
         // intentionally no default so we are warned
      }

   return nullptr;
   }

}
