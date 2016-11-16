/*
* TLS Callbacks
* (C) 2016 Jack Lloyd
*
* Botan is released under the Simplified BSD License (see license.txt)
*/

#include <botan/tls_callbacks.h>
#include <botan/x509path.h>
#include <botan/ocsp.h>
#include <botan/certstor.h>
#include <botan/http_util.h>

namespace Botan {

TLS::Callbacks::~Callbacks() {}

void TLS::Callbacks::tls_inspect_handshake_msg(const Handshake_Message&)
   {
   // default is no op
   }

std::string TLS::Callbacks::tls_server_choose_app_protocol(const std::vector<std::string>&)
   {
   return "";
   }

std::shared_ptr<const OCSP::Response>
TLS::Callbacks::tls_ocsp_request(const X509_Certificate& issuer, const X509_Certificate& subject)
   {
   return std::shared_ptr<const OCSP::Response>(OCSP::online_check(issuer, subject, nullptr));
   }

namespace {

bool cert_in_some_store(const std::vector<Certificate_Store*>& trusted_CAs,
                        const X509_Certificate& trust_root)
   {
   for(auto CAs : trusted_CAs)
      if(CAs->certificate_known(trust_root))
         return true;
   return false;
   }

}

void TLS::Callbacks::tls_verify_cert_chain(
   const std::vector<X509_Certificate>& cert_chain,
   const std::vector<Certificate_Store*>& trusted_roots,
   Usage_Type usage,
   const std::string& hostname)
   {
   if(cert_chain.empty())
      throw Invalid_Argument("Certificate chain was empty");

   Path_Validation_Restrictions restrictions;

   Path_Validation_Result result = x509_path_validate(cert_chain,
                                                      restrictions,
                                                      trusted_roots,
                                                      hostname,
                                                      usage);

   if(!result.successful_validation())
      throw Exception("Certificate validation failure: " + result.result_string());

   if(!cert_in_some_store(trusted_roots, result.trust_root()))
      throw Exception("Certificate chain roots in unknown/untrusted CA");
   }

}
