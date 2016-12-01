if(NOT TARGET botan::asn1)
    add_subdirectory(asn1)
endif()

if(NOT TARGET botan::x509)
    add_subdirectory(cert/x509)
endif()

if(NOT TARGET botan::base64)
    add_subdirectory(codec/base64)
endif()

if(NOT TARGET botan::hex)
    add_subdirectory(codec/hex)
endif()

if(NOT TARGET botan::compression)
    add_subdirectory(compression)
endif()

if(NOT TARGET botan::entropy_rng)
    include(entropy_rng.cmake)
endif()

if(NOT TARGET botan::ffi)
    add_subdirectory(ffi)
endif()

if(NOT TARGET botan::filters)
    add_subdirectory(filters)
endif()

if(NOT TARGET botan::codec_filt)
    add_subdirectory(filters/codec_filt)
endif()

if(UNIX AND NOT TARGET botan::fd_unix)
    add_subdirectory(filters/fd_unix)
endif()

if(NOT TARGET botan::mac)
    add_subdirectory(mac)
endif()

if(NOT TARGET botan::bigint_mp)
    add_subdirectory(math)
endif()

if(NOT TARGET botan::ec_gfp)
    add_subdirectory(math/ec_gfp)
endif()

if(NOT TARGET botan::numbertheory)
    add_subdirectory(math/numbertheory)
endif()

if(NOT TARGET botan::aont)
    add_subdirectory(misc/aont)
endif()

if(NOT TARGET botan::cryptobox)
    add_subdirectory(misc/cryptobox)
endif()

if(NOT TARGET botan::fpe_fe1)
    add_subdirectory(misc/fpe_fe1)
endif()

if(NOT TARGET botan::openpgp)
    add_subdirectory(misc/openpgp)
endif()

if(NOT TARGET botan::pbes2)
    add_subdirectory(misc/pbes2)
endif()

if(NOT TARGET botan::pem)
    add_subdirectory(misc/pem)
endif()

if(NOT TARGET botan::rfc3394)
    add_subdirectory(misc/rfc3394)
endif()

if(NOT TARGET botan::srp6)
    add_subdirectory(misc/srp6)
endif()

if(NOT TARGET botan::tss)
    add_subdirectory(misc/tss)
endif()

if(NOT TARGET botan::modes)
    add_subdirectory(modes)
endif()

if(NOT TARGET botan::aead)
    add_subdirectory(modes/aead)
endif()

if(${CMAKE_TARGET_ARCHITECTURE} STREQUAL "x86_64" OR
        ${CMAKE_TARGET_ARCHITECTURE} STREQUAL "x86" AND NOT TARGET botan::cmul)
    add_subdirectory(modes/aead/gcm/clmul)
endif()

if(NOT TARGET botan::bcrypt)
    add_subdirectory(passhash/bcrypt)
endif()

if(NOT TARGET botan::passhash9)
    add_subdirectory(passhash/passhash9)
endif()

if(NOT TARGET botan::pbkdf)
    add_subdirectory(pbkdf)
endif()

if(NOT TARGET botan::pk_pad)
    add_subdirectory(pk_pad)
endif()

if(${CMAKE_TARGET_ARCHITECTURE} STREQUAL ${CMAKE_HOST_SYSTEM_PROCESSOR})
    find_package(OpenSSL)

    if(NOT TARGET botan::openssl AND OPENSSL_FOUND)
        add_subdirectory(prov/openssl)
    endif()
else()

endif()

if(${CMAKE_TARGET_ARCHITECTURE} STREQUAL ${CMAKE_HOST_SYSTEM_PROCESSOR})
    if(NOT TARGET boost::pkcs11)
        add_subdirectory(prov/pkcs11)
    endif()
endif()

#if (NOT TARGET botan::tpm)
#    add_subdirectory(prov/tpm)
#endif()

if(NOT TARGET botan::pubkey)
    add_subdirectory(pubkey)
endif()

if(NOT TARGET botan::newhope)
    add_subdirectory(pubkey/newhope)
endif()

if(NOT TARGET botan::rfc6979)
    add_subdirectory(pubkey/rfc6979)
endif()

if(NOT TARGET botan::dlies)
    add_subdirectory(pubkey/dlies)
endif()

if(NOT TARGET botan::mceies)
    add_subdirectory(pubkey/mceies)
endif()

if(NOT TARGET botan::x931_rng)
    add_subdirectory(rng/x931_rng)
endif()

if(NOT TARGET botan::tls)
    add_subdirectory(tls)
endif()

if(NOT TARGET botan::sessions_sql)
    add_subdirectory(tls/sessions_sql)
endif()

if(NOT TARGET botan::sessions_sqlite3)
    add_subdirectory(tls/sessions_sqlite3)
endif()

if(NOT TARGET botan::utils)
    add_subdirectory(utils)
endif()

if(NOT TARGET botan::datastor)
    add_subdirectory(utils/datastor)
endif()

if(${CMAKE_TARGET_ARCHITECTURE} STREQUAL "x86_64" OR
        ${CMAKE_TARGET_ARCHITECTURE} STREQUAL "x86" AND NOT TARGET
        botan::dyn_load)
    add_subdirectory(utils/dyn_load)
endif()

if(NOT TARGET botan::http_util)
    add_subdirectory(utils/http_util)
endif()

if(NOT TARGET botan::simd)
    add_subdirectory(utils/simd)
endif()

if(NOT TARGET botan::sqlite3_interface)
    add_subdirectory(utils/sqlite3_interface)
endif()

cmake_policy(SET CMP0042 NEW)
cmake_policy(SET CMP0028 NEW)

set(CURRENT_TARGET botan)

list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        block/block_cipher.h
        )

list(APPEND ${CURRENT_TARGET}_UNGROUPED_SOURCES
        block/block_cipher.cpp
        )

option(BOTAN_BLOCK_AES "Build with AES block encryption support" TRUE)
option(BOTAN_BLOCK_AES_SSSE3 "Build with AES block encryption through SSSE3
instruction set support" TRUE)
option(BOTAN_BLOCK_AES_NI "Build with AES NI block encryption support" TRUE)
option(BOTAN_BLOCK_BLOWFISH "Build with Blowfish block encryption support" TRUE)
option(BOTAN_BLOCK_CAMELLIA "Build with Camellia block encryption support" TRUE)
option(BOTAN_BLOCK_CAST "Build with Cast block encryption support" TRUE)
option(BOTAN_BLOCK_CASCADE "Build with Cascade block encryption support" TRUE)
option(BOTAN_BLOCK_DES "Build with DES block encryption support" TRUE)
option(BOTAN_BLOCK_GOST_28147_89 "Build with GOST.28147.89 block encryption support" TRUE)
option(BOTAN_BLOCK_IDEA "Build with IDEA block encryption support" TRUE)
option(BOTAN_BLOCK_IDEA_SSE2 "Build with IDEA block encryption through SSE2 instruction set support" TRUE)
option(BOTAN_BLOCK_KASUMI "Build with Kasumi block encryption support" TRUE)
option(BOTAN_BLOCK_LION "Build with LION block encryption support" TRUE)
option(BOTAN_BLOCK_MISTY1 "Build with Misty1 block encryption support" TRUE)
option(BOTAN_BLOCK_NOEKEON "Build with Noekeon block encryption support" TRUE)
option(BOTAN_BLOCK_NOEKEON_SIMD "Build with Noekeon block encryption throught SMID instruction set support" TRUE)
option(BOTAN_BLOCK_SEED "Build with Seed block encryption support" TRUE)
option(BOTAN_BLOCK_SERPENT "Build with Serpent block encryption support" TRUE)
option(BOTAN_BLOCK_SERPENT_SMID "Build with Serpent block encryption through SMID instruction set support" TRUE)
option(BOTAN_BLOCK_TWOFISH "Build with Twofish block encryption support" TRUE)
option(BOTAN_BLOCK_THREEFISH_512 "Build with Threefish block encryption support" TRUE)
option(BOTAN_BLOCK_THREEFISH_512_AVX2 "Build with Threefish block encryption through AVX2 instruction set support" TRUE)
option(BOTAN_BLOCK_XTEA "Build with XTEA block encryption support" TRUE)

if(NOT ${CMAKE_TARGET_ARCHITECTURE} STREQUAL "x86_64" OR NOT
        ${CMAKE_TARGET_ARCHITECTURE} STREQUAL "x86")
    set(BOTAN_BLOCK_AES_NI FALSE)
    set(BOTAN_BLOCK_AES_SSSE3 FALSE)
    set(BOTAN_BLOCK_IDEA_SSE2 FALSE)
    set(BOTAN_BLOCK_THREEFISH_512_AVX2 FALSE)
endif()

if(BOTAN_BLOCK_AES)
    list(APPEND ${CURRENT_TARGET}_AES_HEADERS
            block/aes/aes.h
            )

    list(APPEND ${CURRENT_TARGET}_AES_SOURCES
            block/aes/aes.cpp
            )

    add_definitions(-DBOTAN_HAS_AES)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
            ${${CURRENT_TARGET}_AES_HEADERS}
            )
    list(APPEND ${CURRENT_TARGET}_SOURCES
            ${${CURRENT_TARGET}_AES_SOURCES}
            )
endif()

if(BOTAN_BLOCK_AES_SSSE3)
    list(APPEND ${CURRENT_TARGET}_AES_SSSE3_HEADERS
            block/aes_ssse3/aes_ssse3.h
            )

    list(APPEND ${CURRENT_TARGET}_AES_SSSE3_SOURCES
            block/aes_ssse3/aes_ssse3.cpp
            )

    set_source_files_properties(aes_ssse3/aes_ssse3.cpp
            PROPERTIES COMPILE_FLAGS "-mssse3")

    add_definitions(-DBOTAN_HAS_AES_SSSE3)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
            ${${CURRENT_TARGET}_AES_SSSE3_HEADERS}
            )
    list(APPEND ${CURRENT_TARGET}_SOURCES
            ${${CURRENT_TARGET}_AES_SSSE3_SOURCES}
            )
endif()

if(BOTAN_BLOCK_AES_NI)
    list(APPEND ${CURRENT_TARGET}_AES_NI_HEADERS
            block/aes_ni/aes_ni.h
            )

    list(APPEND ${CURRENT_TARGET}_AES_NI_SOURCES
            block/aes_ni/aes_ni.cpp
            )

    set_source_files_properties(aes_ni/aes_ni.cpp
            PROPERTIES COMPILE_FLAGS "-maes -mpclmul -mssse3")

    add_definitions(-DBOTAN_HAS_AES_NI)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
            ${${CURRENT_TARGET}_AES_NI_HEADERS}
            )
    list(APPEND ${CURRENT_TARGET}_SOURCES
            ${${CURRENT_TARGET}_AES_NI_SOURCES}
            )
endif()

if(BOTAN_BLOCK_BLOWFISH)
    list(APPEND ${CURRENT_TARGET}_BLOWFISH_HEADERS
            block/blowfish/blowfish.h
            )

    list(APPEND ${CURRENT_TARGET}_BLOWFISH_SOURCES
            block/blowfish/blfs_tab.cpp
            block/blowfish/blowfish.cpp
            )

    add_definitions(-DBOTAN_HAS_BLOWFISH)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
            ${${CURRENT_TARGET}_BLOWFISH_HEADERS}
            )
    list(APPEND ${CURRENT_TARGET}_SOURCES
            ${${CURRENT_TARGET}_BLOWFISH_SOURCES}
            )
endif()

if(BOTAN_BLOCK_CAMELLIA)
    list(APPEND ${CURRENT_TARGET}_CAMELLIA_HEADERS
            block/camellia/camellia.h
            )

    list(APPEND ${CURRENT_TARGET}_CAMELLIA_SOURCES
            block/camellia/camellia.cpp
            )

    add_definitions(-DBOTAN_HAS_CAMELLIA)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
            ${${CURRENT_TARGET}_CAMELLIA_HEADERS}
            )
    list(APPEND ${CURRENT_TARGET}_SOURCES
            ${${CURRENT_TARGET}_CAMELLIA_SOURCES}
            )
endif()

if(BOTAN_BLOCK_CASCADE)
    list(APPEND ${CURRENT_TARGET}_CASCADE_HEADERS
            block/cascade/cascade.h
            )

    list(APPEND ${CURRENT_TARGET}_CASCADE_SOURCES
            block/cascade/cascade.cpp
            )

    add_definitions(-DBOTAN_HAS_CASCADE)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
            ${${CURRENT_TARGET}_CASCADE_HEADERS}
            )
    list(APPEND ${CURRENT_TARGET}_SOURCES
            ${${CURRENT_TARGET}_CASCADE_SOURCES}
            )
endif()

if(BOTAN_BLOCK_CAST)
    list(APPEND ${CURRENT_TARGET}_CAST_PRIVATE_HEADERS
            block/cast/cast_sboxes.h
            )

    list(APPEND ${CURRENT_TARGET}_CAST_PUBLIC_HEADERS
            block/cast/cast128.h
            block/cast/cast256.h
            )

    list(APPEND ${CURRENT_TARGET}_CAST_SOURCES
            block/cast/cast128.cpp
            block/cast/cast256.cpp
            )

    add_definitions(-DBOTAN_HAS_CAST)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
            ${${CURRENT_TARGET}_CAST_PUBLIC_HEADERS}
            )
    list(APPEND ${CURRENT_TARGET}_PRIVATE_HEADERS
            ${${CURRENT_TARGET}_CAST_PRIVATE_HEADERS}
            )

    list(APPEND ${CURRENT_TARGET}_SOURCES
            ${${CURRENT_TARGET}_CAST_SOURCES}
            )
endif()

if(BOTAN_BLOCK_DES)
    list(APPEND ${CURRENT_TARGET}_DES_HEADERS
            block/des/des.h
            block/des/desx.h
            )

    list(APPEND ${CURRENT_TARGET}_DES_SOURCES
            block/des/des.cpp
            block/des/desx.cpp
            block/des/des_tab.cpp
            )

    add_definitions(-DBOTAN_HAS_DES)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
            ${${CURRENT_TARGET}_DES_HEADERS}
            )
    list(APPEND ${CURRENT_TARGET}_SOURCES
            ${${CURRENT_TARGET}_DES_SOURCES}
            )
endif()

if(BOTAN_BLOCK_GOST_28147_89)
    list(APPEND ${CURRENT_TARGET}_GOST_28147_89_HEADERS
            block/gost_28147/gost_28147.h
            )

    list(APPEND ${CURRENT_TARGET}_GOST_28147_89_SOURCES
            block/gost_28147/gost_28147.cpp
            )

    add_definitions(-DBOTAN_HAS_GOST_28147_89)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
            ${${CURRENT_TARGET}_GOST_28147_89_HEADERS}
            )
    list(APPEND ${CURRENT_TARGET}_SOURCES
            ${${CURRENT_TARGET}_GOST_28147_89_SOURCES}
            )
endif()

if(BOTAN_BLOCK_IDEA)
    list(APPEND ${CURRENT_TARGET}_IDEA_HEADERS
            block/idea/idea.h
            )

    list(APPEND ${CURRENT_TARGET}_IDEA_SOURCES
            block/idea/idea.cpp
            )

    add_definitions(-DBOTAN_HAS_IDEA)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
            ${${CURRENT_TARGET}_IDEA_HEADERS}
            )
    list(APPEND ${CURRENT_TARGET}_SOURCES
            ${${CURRENT_TARGET}_IDEA_SOURCES}
            )
endif()

if(BOTAN_BLOCK_IDEA_SSE2)
    list(APPEND ${CURRENT_TARGET}_IDEA_SSE2_HEADERS
            block/idea_sse2/idea_sse2.h
            )

    list(APPEND ${CURRENT_TARGET}_IDEA_SSE2_SOURCES
            block/idea_sse2/idea_sse2.cpp
            )

    add_definitions(-DBOTAN_HAS_IDEA_SSE2)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
            ${${CURRENT_TARGET}_IDEA_SSE2_HEADERS}
            )
    list(APPEND ${CURRENT_TARGET}_SOURCES
            ${${CURRENT_TARGET}_IDEA_SSE2_SOURCES}
            )
endif()

if(BOTAN_BLOCK_KASUMI)
    list(APPEND ${CURRENT_TARGET}_KASUMI_HEADERS
            block/kasumi/kasumi.h
            )

    list(APPEND ${CURRENT_TARGET}_KASUMI_SOURCES
            block/kasumi/kasumi.cpp
            )

    add_definitions(-DBOTAN_HAS_KASUMI)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
            ${${CURRENT_TARGET}_KASUMI_HEADERS}
            )
    list(APPEND ${CURRENT_TARGET}_SOURCES
            ${${CURRENT_TARGET}_KASUMI_SOURCES}
            )
endif()

if(BOTAN_BLOCK_LION)
    list(APPEND ${CURRENT_TARGET}_LION_HEADERS
            block/lion/lion.h
            )

    list(APPEND ${CURRENT_TARGET}_LION_SOURCES
            block/lion/lion.cpp
            )

    add_definitions(-DBOTAN_HAS_LION)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
            ${${CURRENT_TARGET}_LION_HEADERS}
            )
    list(APPEND ${CURRENT_TARGET}_SOURCES
            ${${CURRENT_TARGET}_LION_SOURCES}
            )
endif()

if(BOTAN_BLOCK_MISTY1)
    list(APPEND ${CURRENT_TARGET}_MISTY1_HEADERS
            block/misty1/misty1.h
            )

    list(APPEND ${CURRENT_TARGET}_MISTY1_SOURCES
            block/misty1/misty1.cpp
            )

    add_definitions(-DBOTAN_HAS_MISTY1)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
            ${${CURRENT_TARGET}_MISTY1_HEADERS}
            )
    list(APPEND ${CURRENT_TARGET}_SOURCES
            ${${CURRENT_TARGET}_MISTY1_SOURCES}
            )
endif()

if(BOTAN_BLOCK_NOEKEON)
    list(APPEND ${CURRENT_TARGET}_NOEKEON_HEADERS
            block/noekeon/noekeon.h
            )

    list(APPEND ${CURRENT_TARGET}_NOEKEON_SOURCES
            block/noekeon/noekeon.cpp
            )

    add_definitions(-DBOTAN_HAS_NOEKEON)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
            ${${CURRENT_TARGET}_NOEKEON_HEADERS}
            )
    list(APPEND ${CURRENT_TARGET}_SOURCES
            ${${CURRENT_TARGET}_NOEKEON_SOURCES}
            )
endif()

if(BOTAN_BLOCK_NOEKEON_SIMD)
    list(APPEND ${CURRENT_TARGET}_NOEKEON_SIMD_HEADERS
            block/noekeon_simd/noekeon_simd.h
            )

    list(APPEND ${CURRENT_TARGET}_NOEKEON_SIMD_SOURCES
            block/noekeon_simd/noekeon_simd.cpp
            )

    add_definitions(-DBOTAN_HAS_NOEKEON_SIMD)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
            ${${CURRENT_TARGET}_NOEKEON_SIMD_HEADERS}
            )
    list(APPEND ${CURRENT_TARGET}_SOURCES
            ${${CURRENT_TARGET}_NOEKEON_SIMD_SOURCES}
            )
endif()

if(BOTAN_BLOCK_SEED)
    list(APPEND ${CURRENT_TARGET}_SEED_HEADERS
            block/seed/seed.h
            )

    list(APPEND ${CURRENT_TARGET}_SEED_SOURCES
            block/seed/seed.cpp
            )

    add_definitions(-DBOTAN_HAS_SEED)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
            ${${CURRENT_TARGET}_SEED_HEADERS}
            )
    list(APPEND ${CURRENT_TARGET}_SOURCES
            ${${CURRENT_TARGET}_SEED_SOURCES}
            )
endif()

if(BOTAN_BLOCK_SERPENT)
    list(APPEND ${CURRENT_TARGET}_PRIVATE_SERPENT_HEADERS
            block/serpent/serpent_sbox.h
            )

    list(APPEND ${CURRENT_TARGET}_PUBLIC_SERPENT_HEADERS
            block/serpent/serpent.h
            )

    list(APPEND ${CURRENT_TARGET}_SERPENT_SOURCES
            block/serpent/serpent.cpp
            )

    add_definitions(-DBOTAN_HAS_SERPENT)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
            ${${CURRENT_TARGET}_PUBLIC_SERPENT_HEADERS}
            )

    list(APPEND ${CURRENT_TARGET}_PRIVATE_HEADERS
            ${${CURRENT_TARGET}_PRIVATE_SERPENT_HEADERS}
            )

    list(APPEND ${CURRENT_TARGET}_SOURCES
            ${${CURRENT_TARGET}_SERPENT_SOURCES}
            )
endif()

if(BOTAN_BLOCK_SERPENT_SIMD)
    list(APPEND ${CURRENT_TARGET}_SERPENT_SIMD_HEADERS
            block/serpent_simd/serp_simd.h
            )

    list(APPEND ${CURRENT_TARGET}_SERPENT_SIMD_SOURCES
            block/serpent_simd/serp_simd.cpp
            )

    add_definitions(-DBOTAN_HAS_SERPENT_SIMD)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
            ${${CURRENT_TARGET}_SERPENT_SIMD_HEADERS}
            )
    list(APPEND ${CURRENT_TARGET}_SOURCES
            ${${CURRENT_TARGET}_SERPENT_SIMD_SOURCES}
            )
endif()

if(BOTAN_BLOCK_THREEFISH)
    list(APPEND ${CURRENT_TARGET}_THREEFISH_HEADERS
            block/threefish/threefish.h
            )

    list(APPEND ${CURRENT_TARGET}_THREEFISH_SOURCES
            block/threefish/threefish.cpp
            )

    add_definitions(-DBOTAN_HAS_THREEFISH)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
            ${${CURRENT_TARGET}_THREEFISH_HEADERS}
            )
    list(APPEND ${CURRENT_TARGET}_SOURCES
            ${${CURRENT_TARGET}_THREEFISH_SOURCES}
            )
endif()

if(BOTAN_BLOCK_THREEFISH_512_AVX2)
    list(APPEND ${CURRENT_TARGET}_THREEFISH_AVX2_HEADERS
            block/threefish_avx2/threefish_avx2.h
            )

    list(APPEND ${CURRENT_TARGET}_THREEFISH_AVX2_SOURCES
            block/threefish_avx2/threefish_avx2.cpp
            )

    set_source_files_properties(threefish_avx2/threefish_avx2.cpp PROPERTIES COMPILE_FLAGS "-mavx2")

    add_definitions(-DBOTAN_HAS_THREEFISH_AVX2)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
            ${${CURRENT_TARGET}_THREEFISH_AVX2_HEADERS}
            )
    list(APPEND ${CURRENT_TARGET}_SOURCES
            ${${CURRENT_TARGET}_THREEFISH_AVX2_SOURCES}
            )
endif()

if(BOTAN_BLOCK_TWOFISH)
    list(APPEND ${CURRENT_TARGET}_TWOFISH_HEADERS
            block/twofish/twofish.h
            )

    list(APPEND ${CURRENT_TARGET}_TWOFISH_SOURCES
            block/twofish/twofish.cpp
            block/twofish/two_tab.cpp
            )

    add_definitions(-DBOTAN_HAS_TWOFISH)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
            ${${CURRENT_TARGET}_TWOFISH_HEADERS}
            )
    list(APPEND ${CURRENT_TARGET}_SOURCES
            ${${CURRENT_TARGET}_TWOFISH_SOURCES}
            )
endif()

if(BOTAN_BLOCK_XTEA)
    list(APPEND ${CURRENT_TARGET}_XTEA_HEADERS
            block/xtea/xtea.h
            )

    list(APPEND ${CURRENT_TARGET}_XTEA_SOURCES
            block/xtea/xtea.cpp
            )

    add_definitions(-DBOTAN_HAS_XTEA)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
            ${${CURRENT_TARGET}_XTEA_HEADERS}
            )
    list(APPEND ${CURRENT_TARGET}_SOURCES
            ${${CURRENT_TARGET}_XTEA_SOURCES}
            )
endif()

list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        stream/stream_cipher.h
        )

list(APPEND ${CURRENT_TARGET}_UNGROUPED_SOURCES
        stream/stream_cipher.cpp
        )

option(BOTAN_STREAM_CHACHA "Build with CHACHA stream encryption support" TRUE)
option(BOTAN_STREAM_SALSA20 "Build with SALSA20 stream encryption support" TRUE)
option(BOTAN_STREAM_CTR_BE "Build with CTR BE stream encryption support" TRUE)
option(BOTAN_STREAM_OFB "Build with OFB stream encryption support" TRUE)
option(BOTAN_STREAM_RC4 "Build with RC4 stream encryption support" TRUE)

if(BOTAN_STREAM_CHACHA)
    list(APPEND ${CURRENT_TARGET}_CHACHA_HEADERS
            stream/chacha/chacha.h
            )

    list(APPEND ${CURRENT_TARGET}_CHACHA_SOURCES
            stream/chacha/chacha.cpp
            )

    if(${CMAKE_TARGET_ARCHITECTURE} STREQUAL "x86_64" OR
            ${CMAKE_TARGET_ARCHITECTURE} STREQUAL "x86")
        add_definitions(-DBOTAN_HAS_CHACHA_SSE2)
        list(APPEND ${CURRENT_TARGET}_CHACHA_SOURCES
                stream/chacha/chacha_sse2/chacha_sse2.cpp
                )
    endif()

    add_definitions(-DBOTAN_HAS_CHACHA)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
            ${${CURRENT_TARGET}_CHACHA_HEADERS}
            )
    list(APPEND ${CURRENT_TARGET}_SOURCES
            ${${CURRENT_TARGET}_CHACHA_SOURCES}
            )
endif()

if(BOTAN_STREAM_SALSA20)
    list(APPEND ${CURRENT_TARGET}_SALSA20_HEADERS
            stream/salsa20/salsa20.h
            )

    list(APPEND ${CURRENT_TARGET}_SALSA20_SOURCES
            stream/salsa20/salsa20.cpp
            )

    add_definitions(-DBOTAN_HAS_SALSA20)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
            ${${CURRENT_TARGET}_SALSA20_HEADERS}
            )
    list(APPEND ${CURRENT_TARGET}_SOURCES
            ${${CURRENT_TARGET}_SALSA20_SOURCES}
            )
endif()

if(BOTAN_STREAM_CTR_BE)
    list(APPEND ${CURRENT_TARGET}_CTR_BE_HEADERS
            stream/ctr/ctr.h
            )

    list(APPEND ${CURRENT_TARGET}_CTR_BE_SOURCES
            stream/ctr/ctr.cpp
            )

    add_definitions(-DBOTAN_HAS_CTR_BE)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
            ${${CURRENT_TARGET}_CTR_BE_HEADERS}
            )
    list(APPEND ${CURRENT_TARGET}_SOURCES
            ${${CURRENT_TARGET}_CTR_BE_SOURCES}
            )
endif()

if(BOTAN_STREAM_OFB)
    list(APPEND ${CURRENT_TARGET}_OFB_HEADERS
            stream/ofb/ofb.h
            )

    list(APPEND ${CURRENT_TARGET}_OFB_SOURCES
            stream/ofb/ofb.cpp
            )

    add_definitions(-DBOTAN_HAS_OFB)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
            ${${CURRENT_TARGET}_OFB_HEADERS}
            )
    list(APPEND ${CURRENT_TARGET}_SOURCES
            ${${CURRENT_TARGET}_OFB_SOURCES}
            )
endif()

if(BOTAN_STREAM_RC4)
    list(APPEND ${CURRENT_TARGET}_RC4_HEADERS
            stream/rc4/rc4.h
            )

    list(APPEND ${CURRENT_TARGET}_RC4_SOURCES
            stream/rc4/rc4.cpp
            )

    add_definitions(-DBOTAN_HAS_RC4)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
            ${${CURRENT_TARGET}_RC4_HEADERS}
            )
    list(APPEND ${CURRENT_TARGET}_SOURCES
            ${${CURRENT_TARGET}_RC4_SOURCES}
            )
endif()

list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        hash/hash.h
        )

list(APPEND ${CURRENT_TARGET}_UNGROUPED_SOURCES
        hash/hash.cpp
        )

if(${CMAKE_TARGET_ARCHITECTURE} STREQUAL "x86_64" OR ${CMAKE_TARGET_ARCHITECTURE} STREQUAL "x86")
    set(CMAKE_TARGET_ARCHITECTURE_SUPPORTS_SSE2 TRUE)
endif()

option(BOTAN_HASH_BLAKE2B "Build with Blake2 hash support" TRUE)
option(BOTAN_HASH_CHECKSUM_ADLER32 "Build with Adler32 hash checksum support" TRUE)
option(BOTAN_HASH_CHECKSUM_CRC24 "Build with CRC24 hash checksum support" TRUE)
option(BOTAN_HASH_CHECKSUM_CRC32 "Build with CRC32 hash checksum support" TRUE)
option(BOTAN_HASH_COMB4P "Build with Comb4p hash support" TRUE)
option(BOTAN_HASH_GOST_34_11 "Build with GOST.34.11 hash support" TRUE)
option(BOTAN_HASH_KECCAK "Build with Keccak hash support" TRUE)
option(BOTAN_HASH_MD4 "Build with MD4 hash support" TRUE)
option(BOTAN_HASH_MD5 "Build with MD5 hash support" TRUE)
option(BOTAN_HASH_PARALLEL_HASH "Build with parallel hash support" TRUE)
option(BOTAN_HASH_RIPEMD_160 "Build with Ripemd160 hash support" TRUE)
option(BOTAN_HASH_SHA1 "Build with SHA1 hash support" TRUE)
option(BOTAN_HASH_SHA1_SSE2 "Build with SHA1 through SSE2 instruction set hash support" ${CMAKE_TARGET_ARCHITECTURE_SUPPORTS_SSE2})
option(BOTAN_HASH_SHA2_32 "Build with SHA2_32 hash support" TRUE)
option(BOTAN_HASH_SHA2_64 "Build with SHA2_64 hash support" TRUE)
option(BOTAN_HASH_SKEIN "Build with Skein hash support" TRUE)
option(BOTAN_HASH_TIGER "Build with Tiger hash support" TRUE)
option(BOTAN_HASH_WHIRLPOOL "Build with Whirlpool hash support" TRUE)

if(BOTAN_HASH_BLAKE2B)
    list(APPEND ${CURRENT_TARGET}_BLAKE2B_HEADERS
            hash/blake2/blake2b.h
            )

    list(APPEND ${CURRENT_TARGET}_BLAKE2B_SOURCES
            hash/blake2/blake2b.cpp
            )

    add_definitions(-DBOTAN_HAS_BLAKE2B)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
            ${${CURRENT_TARGET}_BLAKE2B_HEADERS}
            )
    list(APPEND ${CURRENT_TARGET}_SOURCES
            ${${CURRENT_TARGET}_BLAKE2B_SOURCES}
            )
endif()

if(BOTAN_HASH_CHECKSUM_ADLER32)
    list(APPEND ${CURRENT_TARGET}_ADLER32_HEADERS
            hash/checksum/adler32/adler32.h
            )

    list(APPEND ${CURRENT_TARGET}_ADLER32_SOURCES
            hash/checksum/adler32/adler32.cpp
            )

    add_definitions(-DBOTAN_HAS_ADLER32)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
            ${${CURRENT_TARGET}_ADLER32_HEADERS}
            )
    list(APPEND ${CURRENT_TARGET}_SOURCES
            ${${CURRENT_TARGET}_ADLER32_SOURCES}
            )
endif()

if(BOTAN_HASH_CHECKSUM_CRC24)
    list(APPEND ${CURRENT_TARGET}_CRC24_HEADERS
            hash/checksum/crc24/crc24.h
            )

    list(APPEND ${CURRENT_TARGET}_CRC24_SOURCES
            hash/checksum/crc24/crc24.cpp
            )

    add_definitions(-DBOTAN_HAS_CRC24)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
            ${${CURRENT_TARGET}_CRC24_HEADERS}
            )
    list(APPEND ${CURRENT_TARGET}_SOURCES
            ${${CURRENT_TARGET}_CRC24_SOURCES}
            )
endif()

if(BOTAN_HASH_CHECKSUM_CRC32)
    list(APPEND ${CURRENT_TARGET}_CRC32_HEADERS
            hash/checksum/crc32/crc32.h
            )

    list(APPEND ${CURRENT_TARGET}_CRC32_SOURCES
            hash/checksum/crc32/crc32.cpp
            )

    add_definitions(-DBOTAN_HAS_CRC32)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
            ${${CURRENT_TARGET}_CRC32_HEADERS}
            )
    list(APPEND ${CURRENT_TARGET}_SOURCES
            ${${CURRENT_TARGET}_CRC32_SOURCES}
            )
endif()

if(BOTAN_HASH_COMB4P)
    list(APPEND ${CURRENT_TARGET}_COMB4P_HEADERS
            hash/comb4p/comb4p.h
            )

    list(APPEND ${CURRENT_TARGET}_COMB4P_SOURCES
            hash/comb4p/comb4p.cpp
            )

    add_definitions(-DBOTAN_HAS_COMB4P)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
            ${${CURRENT_TARGET}_COMB4P_HEADERS}
            )
    list(APPEND ${CURRENT_TARGET}_SOURCES
            ${${CURRENT_TARGET}_COMB4P_SOURCES}
            )
endif()

if(BOTAN_HASH_GOST_34_11)
    list(APPEND ${CURRENT_TARGET}_GOST_34_11_HEADERS
            hash/gost_3411/gost_3411.h
            )

    list(APPEND ${CURRENT_TARGET}_GOST_34_11_SOURCES
            hash/gost_3411/gost_3411.cpp
            )

    add_definitions(-DBOTAN_HAS_GOST_34_11)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
            ${${CURRENT_TARGET}_GOST_34_11_HEADERS}
            )
    list(APPEND ${CURRENT_TARGET}_SOURCES
            ${${CURRENT_TARGET}_GOST_34_11_SOURCES}
            )
endif()

if(BOTAN_HASH_KECCAK)
    list(APPEND ${CURRENT_TARGET}_KECCAK_HEADERS
            hash/keccak/keccak.h
            )

    list(APPEND ${CURRENT_TARGET}_KECCAK_SOURCES
            hash/keccak/keccak.cpp
            )

    add_definitions(-DBOTAN_HAS_KECCAK)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
            ${${CURRENT_TARGET}_KECCAK_HEADERS}
            )
    list(APPEND ${CURRENT_TARGET}_SOURCES
            ${${CURRENT_TARGET}_KECCAK_SOURCES}
            )
endif()

if(BOTAN_HASH_MD4)
    list(APPEND ${CURRENT_TARGET}_MD4_HEADERS
            hash/md4/md4.h
            hash/mdx_hash/mdx_hash.h
            )

    list(APPEND ${CURRENT_TARGET}_MD4_SOURCES
            hash/md4/md4.cpp
            hash/mdx_hash/mdx_hash.cpp
            )

    add_definitions(-DBOTAN_HAS_MD4)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
            ${${CURRENT_TARGET}_MD4_HEADERS}
            )
    list(APPEND ${CURRENT_TARGET}_SOURCES
            ${${CURRENT_TARGET}_MD4_SOURCES}
            )
endif()

if(BOTAN_HASH_MD5)
    list(APPEND ${CURRENT_TARGET}_MD5_HEADERS
            hash/md5/md5.h
            hash/mdx_hash/mdx_hash.h
            )

    list(APPEND ${CURRENT_TARGET}_MD5_SOURCES
            hash/md5/md5.cpp
            hash/mdx_hash/mdx_hash.cpp
            )

    add_definitions(-DBOTAN_HAS_MD5)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
            ${${CURRENT_TARGET}_MD5_HEADERS}
            )
    list(APPEND ${CURRENT_TARGET}_SOURCES
            ${${CURRENT_TARGET}_MD5_SOURCES}
            )
endif()

if(BOTAN_HASH_PARALLEL_HASH)
    list(APPEND ${CURRENT_TARGET}_PARALLEL_HASH_HEADERS
            hash/par_hash/par_hash.h
            )

    list(APPEND ${CURRENT_TARGET}_PARALLEL_HASH_SOURCES
            hash/par_hash/par_hash.cpp
            )

    add_definitions(-DBOTAN_HAS_PARALLEL_HASH)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
            ${${CURRENT_TARGET}_PARALLEL_HASH_HEADERS}
            )
    list(APPEND ${CURRENT_TARGET}_SOURCES
            ${${CURRENT_TARGET}_PARALLEL_HASH_SOURCES}
            )
endif()

if(BOTAN_HASH_RIPEMD_160)
    list(APPEND ${CURRENT_TARGET}_RIPEMD_160_HEADERS
            hash/rmd160/rmd160.h
            )

    list(APPEND ${CURRENT_TARGET}_RIPEMD_160_SOURCES
            hash/rmd160/rmd160.cpp
            )

    add_definitions(-DBOTAN_HAS_RIPEMD_160)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
            ${${CURRENT_TARGET}_RIPEMD_160_HEADERS}
            )
    list(APPEND ${CURRENT_TARGET}_SOURCES
            ${${CURRENT_TARGET}_RIPEMD_160_SOURCES}
            )
endif()

if(BOTAN_HASH_SHA1)
    list(APPEND ${CURRENT_TARGET}_SHA1_HEADERS
            hash/sha1/sha160.h
            )

    list(APPEND ${CURRENT_TARGET}_SHA1_SOURCES
            hash/sha1/sha160.cpp
            )

    add_definitions(-DBOTAN_HAS_SHA1)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
            ${${CURRENT_TARGET}_SHA1_HEADERS}
            )
    list(APPEND ${CURRENT_TARGET}_SOURCES
            ${${CURRENT_TARGET}_SHA1_SOURCES}
            )
endif()

if(BOTAN_HASH_SHA1_SSE2)
    list(APPEND ${CURRENT_TARGET}_SHA1_SSE2_HEADERS
            hash/sha1_sse2/sha1_sse2.h
            )

    list(APPEND ${CURRENT_TARGET}_SHA1_SSE2_SOURCES
            hash/sha1_sse2/sha1_sse2.cpp
            )

    add_definitions(-DBOTAN_HAS_SHA1_SSE2)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
            ${${CURRENT_TARGET}_SHA1_SSE2_HEADERS}
            )
    list(APPEND ${CURRENT_TARGET}_SOURCES
            ${${CURRENT_TARGET}_SHA1_SSE2_SOURCES}
            )
endif()

if(BOTAN_HASH_SHA2_32)
    list(APPEND ${CURRENT_TARGET}_SHA2_32_HEADERS
            hash/sha2_32/sha2_32.h
            )

    list(APPEND ${CURRENT_TARGET}_SHA2_32_SOURCES
            hash/sha2_32/sha2_32.cpp
            )

    add_definitions(-DBOTAN_HAS_SHA2_32)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
            ${${CURRENT_TARGET}_SHA2_32_HEADERS}
            )
    list(APPEND ${CURRENT_TARGET}_SOURCES
            ${${CURRENT_TARGET}_SHA2_32_SOURCES}
            )
endif()

if(BOTAN_HASH_SHA2_64)
    list(APPEND ${CURRENT_TARGET}_SHA2_64_HEADERS
            hash/sha2_64/sha2_64.h
            )

    list(APPEND ${CURRENT_TARGET}_SHA2_64_SOURCES
            hash/sha2_64/sha2_64.cpp
            )

    add_definitions(-DBOTAN_HAS_SHA2_64)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
            ${${CURRENT_TARGET}_SHA2_64_HEADERS}
            )
    list(APPEND ${CURRENT_TARGET}_SOURCES
            ${${CURRENT_TARGET}_SHA2_64_SOURCES}
            )
endif()

if(BOTAN_HASH_SKEIN_512)
    list(APPEND ${CURRENT_TARGET}_SKEIN_512_HEADERS
            hash/skein/skein_512.h
            )

    list(APPEND ${CURRENT_TARGET}_SKEIN_512_SOURCES
            hash/skein/skein_512.cpp
            )

    add_definitions(-DBOTAN_HAS_SKEIN_512)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
            ${${CURRENT_TARGET}_SKEIN_512_HEADERS}
            )
    list(APPEND ${CURRENT_TARGET}_SOURCES
            ${${CURRENT_TARGET}_SKEIN_512_SOURCES}
            )
endif()

if(BOTAN_HASH_TIGER)
    list(APPEND ${CURRENT_TARGET}_TIGER_HEADERS
            hash/tiger/tiger.h
            )

    list(APPEND ${CURRENT_TARGET}_TIGER_SOURCES
            hash/tiger/tiger.cpp
            hash/tiger/tig_tab.cpp
            )

    add_definitions(-DBOTAN_HAS_TIGER)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
            ${${CURRENT_TARGET}_TIGER_HEADERS}
            )
    list(APPEND ${CURRENT_TARGET}_SOURCES
            ${${CURRENT_TARGET}_TIGER_SOURCES}
            )
endif()

if(BOTAN_HASH_WHIRLPOOL)
    list(APPEND ${CURRENT_TARGET}_WHIRLPOOL_HEADERS
            hash/whirlpool/whrlpool.h
            )

    list(APPEND ${CURRENT_TARGET}_WHIRLPOOL_SOURCES
            hash/whirlpool/whirlpool.cpp
            hash/whirlpool/whrl_tab.cpp
            )

    add_definitions(-DBOTAN_HAS_WHIRLPOOL)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
            ${${CURRENT_TARGET}_WHIRLPOOL_HEADERS}
            )
    list(APPEND ${CURRENT_TARGET}_SOURCES
            ${${CURRENT_TARGET}_WHIRLPOOL_SOURCES}
            )
endif()

list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        base/botan.h
        base/buf_comp.h
        base/init.h
        base/key_spec.h
        base/lookup.h
        base/secmem.h
        base/scan_name.h
        base/sym_algo.h
        base/symkey.h
        )

list(APPEND ${CURRENT_TARGET}_PRIVATE_HEADERS
        base/algo_registry.h
        )

list(APPEND ${CURRENT_TARGET}_UNGROUPED_SOURCES
        base/init.cpp
        base/scan_name.cpp
        base/symkey.cpp
        )

list(APPEND ${CURRENT_TARGET}_HEADERS
        ${${CURRENT_TARGET}_PUBLIC_HEADERS}
        ${${CURRENT_TARGET}_PRIVATE_HEADERS}
        )

list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_UNGROUPED_SOURCES}
        )

if(BUILD_SHARED_LIBRARIES)
    add_library(${CURRENT_TARGET} SHARED
            ${${CURRENT_TARGET}_HEADERS}
            ${${CURRENT_TARGET}_SOURCES}
            )
else()
    add_library(${CURRENT_TARGET} STATIC
            ${${CURRENT_TARGET}_HEADERS}
            ${${CURRENT_TARGET}_SOURCES}
            )
endif()

target_include_directories(${CURRENT_TARGET} PUBLIC
        "$<BUILD_INTERFACE:${CMAKE_BINARY_DIR}/include>"
        )

target_compile_options(${CURRENT_TARGET} PUBLIC
        $<$<COMPILE_LANGUAGE:C>:${BOTAN_C_COMPILER_FLAGS}>)

target_compile_options(${CURRENT_TARGET} PUBLIC
        $<$<COMPILE_LANGUAGE:CXX>:${BOTAN_CXX_COMPILER_FLAGS}>)

target_compile_options(${CURRENT_TARGET} PUBLIC
        $<$<CONFIG:DEBUG>:${BOTAN_COMPILER_DEBUG_FLAGS}>)

target_compile_options(${CURRENT_TARGET} PUBLIC
        $<$<CONFIG:RELEASE>:${BOTAN_COMPILER_RELEASE_FLAGS}>)

target_link_libraries(${CURRENT_TARGET} PRIVATE
        botan::bigint_mp
        botan::hex
        botan::utils
        )

install(FILES ${${CURRENT_TARGET}_PUBLIC_HEADERS} DESTINATION ${CMAKE_BINARY_DIR}/include/botan)

install(FILES ${${CURRENT_TARGET}_PRIVATE_HEADERS} DESTINATION ${CMAKE_BINARY_DIR}/include/botan/internal)

foreach(ITERATOR ${${CURRENT_TARGET}_PUBLIC_HEADERS})
    file(COPY ${ITERATOR} DESTINATION ${CMAKE_BINARY_DIR}/include/botan)
endforeach()

foreach(ITERATOR ${${CURRENT_TARGET}_PRIVATE_HEADERS})
    file(COPY ${ITERATOR} DESTINATION ${CMAKE_BINARY_DIR}/include/botan/internal)
endforeach()

install(TARGETS ${CURRENT_TARGET} EXPORT ${CURRENT_TARGET}_targets
        RUNTIME DESTINATION bin
        LIBRARY DESTINATION lib
        ARCHIVE DESTINATION lib
        )

install(EXPORT ${CURRENT_TARGET}_targets
        FILE ${CURRENT_TARGET}_targets.cmake
        DESTINATION lib/cmake/${CURRENT_TARGET}
        )

write_config_file("${CMAKE_BINARY_DIR}/lib/cmake/${CURRENT_TARGET}/${CURRENT_TARGET}_config.cmake")
write_basic_package_version_file("${CMAKE_BINARY_DIR}/lib/cmake/${CURRENT_TARGET}/${CURRENT_TARGET}_config_version.cmake"
        VERSION ${BOTAN_VERSION}
        COMPATIBILITY AnyNewerVersion
        )

install(FILES
        "${CMAKE_BINARY_DIR}/lib/cmake/${CURRENT_TARGET}/${CURRENT_TARGET}_config.cmake"
        "${CMAKE_BINARY_DIR}/lib/cmake/${CURRENT_TARGET}/${CURRENT_TARGET}_config_version.cmake"
        DESTINATION lib/cmake/${CURRENT_TARGET}
        )

export(TARGETS ${CURRENT_TARGET}
        FILE ${CMAKE_BINARY_DIR}/lib/cmake/${CURRENT_TARGET}/${CURRENT_TARGET}_targets.cmake)

if(APPLE)
    set_target_properties(${CURRENT_TARGET} PROPERTIES ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})
    set_target_properties(${CURRENT_TARGET} PROPERTIES BINARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})
    set_target_properties(${CURRENT_TARGET} PROPERTIES LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})
endif()

if(APPLE AND NOT ${CMAKE_TARGET_ARCHITECTURE} STREQUAL ${CMAKE_HOST_SYSTEM_PROCESSOR})
    set_target_properties(${CURRENT_TARGET} PROPERTIES XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY ${APPLE_CODE_SIGN_IDENTITY})
    set_target_properties(${CURRENT_TARGET} PROPERTIES XCODE_ATTRIBUTE_DEVELOPMENT_TEAM ${CMAKE_XCODE_ATTRIBUTE_DEVELOPMENT_TEAM})
endif()
