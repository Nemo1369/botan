cmake_minimum_required(VERSION 2.8.11)

cmake_policy(SET CMP0042 NEW)
cmake_policy(SET CMP0028 NEW)

set(CURRENT_TARGET pubkey)

list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
    blinding.h
    pk_keys.h
    pk_ops.h
    pkcs8.h
    pubkey.h
    x509_key.h
    workfactor.h
    keypair/keypair.h
    dl_group/dl_group.h
    dl_algo/dl_algo.h
    ecies/ecies.h
    ecc_key/ecc_key.h
    )

list(APPEND ${CURRENT_TARGET}_PRIVATE_HEADERS
    pk_algs.h
    pk_utils.h
    pk_ops_impl.h
    )

list(APPEND ${CURRENT_TARGET}_UNGROUPED_SOURCES
    blinding.cpp
    pk_algs.cpp
    pk_keys.cpp
    pk_ops.cpp
    pkcs8.cpp
    pubkey.cpp
    workfactor.cpp
    x509_key.cpp
    keypair/keypair.cpp
    dl_group/dl_group.cpp
    dl_group/named.cpp
    dl_algo/dl_algo.cpp
    ecies/ecies.cpp
    ecc_key/ecc_key.cpp
    )

option(BOTAN_PUBKEY_RSA "Build with RSA pubkey encryption support" TRUE)
option(BOTAN_PUBKEY_DSA "Build with DSA pubkey encryption support" TRUE)
option(BOTAN_PUBKEY_DIFFIE_HELLMAN "Build with Diffie-Hellman pubkey encryption support" TRUE)
option(BOTAN_PUBKEY_ECDSA "Build with ECDSA pubkey encryption support" TRUE)
option(BOTAN_PUBKEY_ECGDSA "Build with ECGDSA pubkey encryption support" TRUE)
option(BOTAN_PUBKEY_ECKCDSA "Build with ECKCDSA pubkey encryption support" TRUE)
option(BOTAN_PUBKEY_GOST_34_10_2001 "Build with GOST 34.10.2001 pubkey encryption support" TRUE)
option(BOTAN_PUBKEY_ELGAMAL "Build with ELGAMAL pubkey encryption support" TRUE)
option(BOTAN_PUBKEY_ECDH "Build with ECDH pubkey encryption support" TRUE)
option(BOTAN_PUBKEY_CURVE_25519 "Build with Curve 25519 pubkey encryption support" TRUE)
option(BOTAN_PUBKEY_MCELIECE "Build with McEliece pubkey encryption support" TRUE)

if (BOTAN_PUBKEY_RSA)
    list(APPEND ${CURRENT_TARGET}_RSA_HEADERS
        rsa/rsa.h    
        )

    list(APPEND ${CURRENT_TARGET}_RSA_SOURCES
        rsa/rsa.cpp
        )

    list(APPEND ${CURRENT_TARGET}_LIBRARIES
        botan::numbertheory
        botan::pk_pad
        botan
        )

    add_definitions(-DBOTAN_HAS_RSA)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_RSA_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_RSA_SOURCES}
        )
endif()

if (BOTAN_PUBKEY_DSA)
    list(APPEND ${CURRENT_TARGET}_DSA_HEADERS
        dsa/dsa.h    
        )

    list(APPEND ${CURRENT_TARGET}_DSA_SOURCES
        dsa/dsa.cpp
        )

    list(APPEND ${CURRENT_TARGET}_LIBRARIES
        botan::numbertheory
        botan::pk_pad
        botan
        )

    add_definitions(-DBOTAN_HAS_DSA)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_DSA_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_DSA_SOURCES}
        )
endif()

if (BOTAN_PUBKEY_DIFFIE_HELLMAN)
    list(APPEND ${CURRENT_TARGET}_DIFFIE_HELLMAN_HEADERS
        dh/dh.h    
        )

    list(APPEND ${CURRENT_TARGET}_DIFFIE_HELLMAN_SOURCES
        dh/dh.cpp
        )

    list(APPEND ${CURRENT_TARGET}_LIBRARIES
        botan::numbertheory
        )

    add_definitions(-DBOTAN_HAS_DIFFIE_HELLMAN)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_DIFFIE_HELLMAN_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_DIFFIE_HELLMAN_SOURCES}
        )
endif()

if (BOTAN_PUBKEY_ECDSA)
    list(APPEND ${CURRENT_TARGET}_ECDSA_HEADERS
        ecdsa/ecdsa.h    
        )

    list(APPEND ${CURRENT_TARGET}_ECDSA_SOURCES
        ecdsa/ecdsa.cpp
        )

    list(APPEND ${CURRENT_TARGET}_LIBRARIES
        botan::asn1
        botan::ec_group
        botan::numbertheory
        botan::entropy_rng
        botan::pk_pad
        botan
        )

    add_definitions(-DBOTAN_HAS_ECDSA)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_ECDSA_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_ECDSA_SOURCES}
        )
endif()

if (BOTAN_PUBKEY_ECGDSA)
    list(APPEND ${CURRENT_TARGET}_ECGDSA_HEADERS
        ecgdsa/ecgdsa.h    
        )

    list(APPEND ${CURRENT_TARGET}_ECGDSA_SOURCES
        ecgdsa/ecgdsa.cpp
        )

    if (NOT TARGET botan::ec_group)
        add_subdirectory(ec_group)
    endif()

    list(APPEND ${CURRENT_TARGET}_LIBRARIES
        botan::asn1
        botan::bigint_mp
        botan::ec_group
        botan::numbertheory
        botan::entropy_rng
        botan::pk_pad
        botan
        )

    add_definitions(-DBOTAN_HAS_ECGDSA)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_ECGDSA_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_ECGDSA_SOURCES}
        )
endif()

if (BOTAN_PUBKEY_GOST_34_10_2001)
    list(APPEND ${CURRENT_TARGET}_GOST_34_10_2001_HEADERS
        gost_3410/gost_3410.h    
        )

    list(APPEND ${CURRENT_TARGET}_GOST_34_10_2001_SOURCES
        gost_3410/gost_3410.cpp
        )

    if (NOT TARGET botan::ec_group)
        add_subdirectory(ec_group)
    endif()

    list(APPEND ${CURRENT_TARGET}_LIBRARIES
        botan::asn1
        botan::ec_group
        botan::numbertheory
        botan::entropy_rng
        )

    add_definitions(-DBOTAN_HAS_GOST_34_10_2001)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_GOST_34_10_2001_HEADERS}
        )

    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_GOST_34_10_2001_SOURCES}
        )
endif()

if (BOTAN_PUBKEY_ELGAMAL)
    list(APPEND ${CURRENT_TARGET}_ELGAMAL_HEADERS
        elgamal/elgamal.h    
        )

    list(APPEND ${CURRENT_TARGET}_ELGAMAL_SOURCES
        elgamal/elgamal.cpp
        )

    list(APPEND ${CURRENT_TARGET}_LIBRARIES
        botan::numbertheory
        )

    add_definitions(-DBOTAN_HAS_ELGAMAL)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_ELGAMAL_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_ELGAMAL_SOURCES}
        )
endif()

if (BOTAN_PUBKEY_ECDH)
    list(APPEND ${CURRENT_TARGET}_ECDH_HEADERS
        ecdh/ecdh.h    
        )

    list(APPEND ${CURRENT_TARGET}_ECDH_SOURCES
        ecdh/ecdh.cpp
        )

    if (NOT TARGET botan::ec_group)
        add_subdirectory(ec_group)
    endif()

    list(APPEND ${CURRENT_TARGET}_LIBRARIES
        botan::asn1
        botan::ec_group
        botan::numbertheory
        )

    add_definitions(-DBOTAN_HAS_ECDH)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_ECDH_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_ECDH_SOURCES}
        )
endif()

if (BOTAN_PUBKEY_CURVE_25519)
    list(APPEND ${CURRENT_TARGET}_CURVE_25519_HEADERS
        curve25519/curve25519.h    
        )

    list(APPEND ${CURRENT_TARGET}_CURVE_25519_SOURCES
        curve25519/curve25519.cpp
        curve25519/donna.cpp
        )

    add_definitions(-DBOTAN_HAS_CURVE_25519)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_CURVE_25519_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_CURVE_25519_SOURCES}
        )
endif()

if (BOTAN_PUBKEY_MCELIECE)
    list(APPEND ${CURRENT_TARGET}_MCELIECE_PUBLIC_HEADERS
        mce/mceliece.h
        mce/polyn_gf2m.h
        mce/gf2m_small_m.h
        )

    list(APPEND ${CURRENT_TARGET}_MCELIECE_INTERNAL_HEADERS
        mce/code_based_util.h
        mce/mce_internal.h
        )

    list(APPEND ${CURRENT_TARGET}_MCELIECE_SOURCES
        mce/code_based_key_gen.cpp
        mce/gf2m_rootfind_dcmp.cpp
        mce/gf2m_small_m.cpp
        mce/goppa_code.cpp
        mce/mceliece.cpp
        mce/mceliece_key.cpp
        mce/polyn_gf2m.cpp
        mce/workfactor.cpp
        )

    list(APPEND ${CURRENT_TARGET}_LIBRARIES
        botan
        )

    add_definitions(-DBOTAN_HAS_MCELIECE)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_MCELIECE_PUBLIC_HEADERS}
        )

    list(APPEND ${CURRENT_TARGET}_PRIVATE_HEADERS
        ${${CURRENT_TARGET}_MCELIECE_INTERNAL_HEADERS}
        )

    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_MCELIECE_SOURCES}
        )
endif()

list(APPEND ${CURRENT_TARGET}_HEADERS
    ${${CURRENT_TARGET}_PUBLIC_HEADERS}
    )

list(APPEND ${CURRENT_TARGET}_SOURCES
    ${${CURRENT_TARGET}_UNGROUPED_SOURCES}
    )

if (BUILD_SHARED_LIBRARIES)
    add_library(botan_${CURRENT_TARGET} SHARED
        ${${CURRENT_TARGET}_HEADERS}
        ${${CURRENT_TARGET}_SOURCES}
        )
else()
    add_library(botan_${CURRENT_TARGET} STATIC
        ${${CURRENT_TARGET}_HEADERS}
        ${${CURRENT_TARGET}_SOURCES}
        )
endif()

target_include_directories(botan_${CURRENT_TARGET} PUBLIC
    "$<BUILD_INTERFACE:${CMAKE_BINARY_DIR}/include>"
    )

target_compile_options(botan_${CURRENT_TARGET} PUBLIC
    $<$<COMPILE_LANGUAGE:C>:${BOTAN_C_COMPILER_FLAGS}>)

target_compile_options(botan_${CURRENT_TARGET} PUBLIC
    $<$<COMPILE_LANGUAGE:CXX>:${BOTAN_CXX_COMPILER_FLAGS}>)

target_compile_options(botan_${CURRENT_TARGET} PUBLIC
    $<$<CONFIG:DEBUG>:${BOTAN_COMPILER_DEBUG_FLAGS}>)

target_compile_options(botan_${CURRENT_TARGET} PUBLIC
    $<$<CONFIG:RELEASE>:${BOTAN_COMPILER_RELEASE_FLAGS}>)

target_link_libraries(botan_${CURRENT_TARGET} PRIVATE
    ${${CURRENT_TARGET}_LIBRARIES}
    botan::asn1
    botan::bigint_mp
    botan::ec_gfp
    botan::kdf
    botan::pbes2
    botan::mac
    botan::pem
    botan::modes
    botan::pk_pad
    botan::numbertheory
    botan::entropy_rng
    botan::utils
    )

add_library(botan::${CURRENT_TARGET} ALIAS botan_${CURRENT_TARGET})
set_property(TARGET botan_${CURRENT_TARGET} PROPERTY EXPORT_NAME ${CURRENT_TARGET})

install(FILES ${${CURRENT_TARGET}_PUBLIC_HEADERS} DESTINATION ${CMAKE_BINARY_DIR}/include/botan)

install(FILES ${${CURRENT_TARGET}_PRIVATE_HEADERS} DESTINATION ${CMAKE_BINARY_DIR}/include/botan/internal)

foreach(ITERATOR ${${CURRENT_TARGET}_PUBLIC_HEADERS})
    file(COPY ${ITERATOR} DESTINATION ${CMAKE_BINARY_DIR}/include/botan)
endforeach()

foreach(ITERATOR ${${CURRENT_TARGET}_PRIVATE_HEADERS})
    file(COPY ${ITERATOR} DESTINATION ${CMAKE_BINARY_DIR}/include/botan/internal)
endforeach()

install(TARGETS botan_${CURRENT_TARGET} EXPORT botan_${CURRENT_TARGET}_targets
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
    )

install(EXPORT botan_${CURRENT_TARGET}_targets
    FILE botan_${CURRENT_TARGET}_targets.cmake
    NAMESPACE botan::
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

export(TARGETS botan_${CURRENT_TARGET}
    NAMESPACE botan::
    FILE ${CMAKE_BINARY_DIR}/lib/cmake/${CURRENT_TARGET}/${CURRENT_TARGET}_targets.cmake)
