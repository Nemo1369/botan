/*
* Certificate Status
* (C) 2016 Jack Lloyd
*
* Botan is released under the Simplified BSD License (see license.txt)
*/

#include <botan/internal/tls_messages.h>
#include <botan/internal/tls_reader.h>
#include <botan/internal/tls_extensions.h>
#include <botan/internal/tls_handshake_io.h>
#include <botan/der_enc.h>
#include <botan/ber_dec.h>

Certificate_Status::Certificate_Status(const std::vector<byte>& buf)
   {

   }

      Certificate_Status(Handshake_IO& io,
                         Handshake_Hash& hash,
                         std::shared_ptr<const OCSP::Response> response);
