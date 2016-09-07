include_directories("${CMAKE_SOURCE_DIR}/build/include")

set(CURRENT_TARGET_LIBRARIES)
if(NOT WIN32)
    #    list(APPEND extra_link_libraries dl pthread)
endif()

# botan-tests
add_executable(botan_tests
        main.cpp
        test_aead.cpp
        test_bigint.cpp
        test_block.cpp
        test_c25519.cpp
        test_compression.cpp
        test_cryptobox.cpp
        test_dh.cpp
        test_dlies.cpp
        test_dsa.cpp
        test_ecc_pointmul.cpp
        test_ecdh.cpp
        test_ecdsa.cpp
        test_ecgdsa.cpp
        test_ecies.cpp
        test_eckcdsa.cpp
        test_elg.cpp
        test_entropy.cpp
        test_ffi.cpp
        test_filters.cpp
        test_fuzzer.cpp
        test_gf2m.cpp
        test_gost_3410.cpp
        test_hash.cpp
        test_kdf.cpp
        test_keywrap.cpp
        test_mac.cpp
        test_mceliece.cpp
        test_modes.cpp
        test_mp.cpp
        test_name_constraint.cpp
        test_newhope.cpp
        test_ocb.cpp
        test_octetstring.cpp
        test_oid.cpp
        test_pad.cpp
        test_passhash.cpp
        test_pbkdf.cpp
        test_pubkey.cpp
        test_rfc6979.cpp
        test_rng.cpp
        test_rsa.cpp
        tests.cpp
        test_srp6.cpp
        test_stream.cpp
        test_tss.cpp
        test_utils.cpp
        test_x509_path.cpp
        unit_ecc.cpp
        unit_ecdh.cpp
        unit_ecdsa.cpp
        unit_tls.cpp
        unit_x509.cpp
        )

if(APPLE)
    find_library(SECURITY_LIBRARY Security)

    list(APPEND CURRENT_TARGET_LIBRARIES ${SECURITY_LIBRARY})
endif()


#find_package( LZMA REQUIRED )
#if ( LZMA_FOUND )
#    include_directories(${LZMA_INCLUDE_DIR})
#    target_link_libraries(${PROJECT_NAME}-tests ${LZMA_LIBRARIES})
#endif( LZMA_FOUND )

#find_package( BZip2 REQUIRED )
#if ( BZIP2_FOUND )
#    include_directories(${BZIP_INCLUDE_DIRS})
#    target_link_libraries(${PROJECT_NAME}-tests ${BZIP2_LIBRARIES})
#endif( BZIP2_FOUND )
#
#find_package( ZLIB REQUIRED )
#if ( ZLIB_FOUND )
#    include_directories(${ZLIB_INCLUDE_DIRS})
#    target_link_libraries(${PROJECT_NAME}-tests ${ZLIB_LIBRARIES})
#endif( ZLIB_FOUND )

target_link_libraries(botan_tests botan ${CURRENT_TARGET_LIBRARIES})