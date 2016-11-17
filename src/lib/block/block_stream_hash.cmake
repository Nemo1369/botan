cmake_minimum_required(VERSION 2.8.11)

cmake_policy(SET CMP0042 NEW)
cmake_policy(SET CMP0028 NEW)

set(CURRENT_TARGET block)

list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
    block_cipher.h
    )

list(APPEND ${CURRENT_TARGET}_UNGROUPED_SOURCES
    block_cipher.cpp
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

if (NOT ${CMAKE_TARGET_ARCHITECTURE} STREQUAL "x86_64" OR NOT
        ${CMAKE_TARGET_ARCHITECTURE} STREQUAL "x86")
    set(BOTAN_BLOCK_AES_NI FALSE)
    set(BOTAN_BLOCK_AES_SSSE3 FALSE)
    set(BOTAN_BLOCK_IDEA_SSE2 FALSE)
    set(BOTAN_BLOCK_THREEFISH_512_AVX2 FALSE)
endif()

if (BOTAN_BLOCK_AES)
    list(APPEND ${CURRENT_TARGET}_AES_HEADERS
        aes/aes.h    
        )

    list(APPEND ${CURRENT_TARGET}_AES_SOURCES
        aes/aes.cpp
        )

    add_definitions(-DBOTAN_HAS_AES)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_AES_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_AES_SOURCES}
        )
endif()

if (BOTAN_BLOCK_AES_SSSE3)
    list(APPEND ${CURRENT_TARGET}_AES_SSSE3_HEADERS
        aes_ssse3/aes_ssse3.h
        )

    list(APPEND ${CURRENT_TARGET}_AES_SSSE3_SOURCES
        aes_ssse3/aes_ssse3.cpp
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

if (BOTAN_BLOCK_AES_NI)
    list(APPEND ${CURRENT_TARGET}_AES_NI_HEADERS
        aes_ni/aes_ni.h    
        )

    list(APPEND ${CURRENT_TARGET}_AES_NI_SOURCES
        aes_ni/aes_ni.cpp
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

if (BOTAN_BLOCK_BLOWFISH)
    list(APPEND ${CURRENT_TARGET}_BLOWFISH_HEADERS
        blowfish/blowfish.h
        )

    list(APPEND ${CURRENT_TARGET}_BLOWFISH_SOURCES
        blowfish/blfs_tab.cpp
        blowfish/blowfish.cpp
        )

    add_definitions(-DBOTAN_HAS_BLOWFISH)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_BLOWFISH_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_BLOWFISH_SOURCES}
        )
endif()

if (BOTAN_BLOCK_CAMELLIA)
    list(APPEND ${CURRENT_TARGET}_CAMELLIA_HEADERS
        camellia/camellia.h
        )

    list(APPEND ${CURRENT_TARGET}_CAMELLIA_SOURCES
        camellia/camellia.cpp
        )

    add_definitions(-DBOTAN_HAS_CAMELLIA)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_CAMELLIA_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_CAMELLIA_SOURCES}
        )
endif()

if (BOTAN_BLOCK_CASCADE)
    list(APPEND ${CURRENT_TARGET}_CASCADE_HEADERS
        cascade/cascade.h
        )

    list(APPEND ${CURRENT_TARGET}_CASCADE_SOURCES
        cascade/cascade.cpp
        )

    add_definitions(-DBOTAN_HAS_CASCADE)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_CASCADE_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_CASCADE_SOURCES}
        )
endif()

if (BOTAN_BLOCK_CAST)
    list(APPEND ${CURRENT_TARGET}_CAST_PRIVATE_HEADERS
        cast/cast_sboxes.h
        )

    list(APPEND ${CURRENT_TARGET}_CAST_PUBLIC_HEADERS
        cast/cast128.h
        cast/cast256.h
        )

    list(APPEND ${CURRENT_TARGET}_CAST_SOURCES
        cast/cast128.cpp
        cast/cast256.cpp
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

if (BOTAN_BLOCK_DES)
    list(APPEND ${CURRENT_TARGET}_DES_HEADERS
        des/des.h
        des/desx.h
        )

    list(APPEND ${CURRENT_TARGET}_DES_SOURCES
        des/des.cpp
        des/desx.cpp
        des/des_tab.cpp
        )

    add_definitions(-DBOTAN_HAS_DES)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_DES_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_DES_SOURCES}
        )
endif()

if (BOTAN_BLOCK_GOST_28147_89)
    list(APPEND ${CURRENT_TARGET}_GOST_28147_89_HEADERS
        gost_28147/gost_28147.h
        )

    list(APPEND ${CURRENT_TARGET}_GOST_28147_89_SOURCES
        gost_28147/gost_28147.cpp
        )

    add_definitions(-DBOTAN_HAS_GOST_28147_89)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_GOST_28147_89_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_GOST_28147_89_SOURCES}
        )
endif()

if (BOTAN_BLOCK_IDEA)
    list(APPEND ${CURRENT_TARGET}_IDEA_HEADERS
        idea/idea.h
        )

    list(APPEND ${CURRENT_TARGET}_IDEA_SOURCES
        idea/idea.cpp
        )

    add_definitions(-DBOTAN_HAS_IDEA)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_IDEA_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_IDEA_SOURCES}
        )
endif()

if (BOTAN_BLOCK_IDEA_SSE2)
    list(APPEND ${CURRENT_TARGET}_IDEA_SSE2_HEADERS
        idea_sse2/idea_sse2.h
        )

    list(APPEND ${CURRENT_TARGET}_IDEA_SSE2_SOURCES
        idea_sse2/idea_sse2.cpp
        )

    add_definitions(-DBOTAN_HAS_IDEA_SSE2)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_IDEA_SSE2_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_IDEA_SSE2_SOURCES}
        )
endif()

if (BOTAN_BLOCK_KASUMI)
    list(APPEND ${CURRENT_TARGET}_KASUMI_HEADERS
        kasumi/kasumi.h
        )

    list(APPEND ${CURRENT_TARGET}_KASUMI_SOURCES
        kasumi/kasumi.cpp
        )

    add_definitions(-DBOTAN_HAS_KASUMI)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_KASUMI_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_KASUMI_SOURCES}
        )
endif()

if (BOTAN_BLOCK_LION)
    list(APPEND ${CURRENT_TARGET}_LION_HEADERS
        lion/lion.h
        )

    list(APPEND ${CURRENT_TARGET}_LION_SOURCES
        lion/lion.cpp
        )

    add_definitions(-DBOTAN_HAS_LION)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_LION_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_LION_SOURCES}
        )
endif()

if (BOTAN_BLOCK_MISTY1)
    list(APPEND ${CURRENT_TARGET}_MISTY1_HEADERS
        misty1/misty1.h
        )

    list(APPEND ${CURRENT_TARGET}_MISTY1_SOURCES
        misty1/misty1.cpp
        )

    add_definitions(-DBOTAN_HAS_MISTY1)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_MISTY1_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_MISTY1_SOURCES}
        )
endif()

if (BOTAN_BLOCK_NOEKEON)
    list(APPEND ${CURRENT_TARGET}_NOEKEON_HEADERS
        noekeon/noekeon.h
        )

    list(APPEND ${CURRENT_TARGET}_NOEKEON_SOURCES
        noekeon/noekeon.cpp
        )

    add_definitions(-DBOTAN_HAS_NOEKEON)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_NOEKEON_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_NOEKEON_SOURCES}
        )
endif()

if (BOTAN_BLOCK_NOEKEON_SIMD)
    list(APPEND ${CURRENT_TARGET}_NOEKEON_SIMD_HEADERS
        noekeon_simd/noekeon_simd.h
        )

    list(APPEND ${CURRENT_TARGET}_NOEKEON_SIMD_SOURCES
        noekeon_simd/noekeon_simd.cpp
        )

    add_definitions(-DBOTAN_HAS_NOEKEON_SIMD)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_NOEKEON_SIMD_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_NOEKEON_SIMD_SOURCES}
        )
endif()

if (BOTAN_BLOCK_SEED)
    list(APPEND ${CURRENT_TARGET}_SEED_HEADERS
        seed/seed.h
        )

    list(APPEND ${CURRENT_TARGET}_SEED_SOURCES
        seed/seed.cpp
        )

    add_definitions(-DBOTAN_HAS_SEED)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_SEED_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_SEED_SOURCES}
        )
endif()

if (BOTAN_BLOCK_SERPENT)
    list(APPEND ${CURRENT_TARGET}_PRIVATE_SERPENT_HEADERS
        serpent/serpent_sbox.h
        )

    list(APPEND ${CURRENT_TARGET}_PUBLIC_SERPENT_HEADERS
        serpent/serpent.h
        )

    list(APPEND ${CURRENT_TARGET}_SERPENT_SOURCES
        serpent/serpent.cpp
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

if (BOTAN_BLOCK_SERPENT_SIMD)
    list(APPEND ${CURRENT_TARGET}_SERPENT_SIMD_HEADERS
        serpent_simd/serp_simd.h
        )

    list(APPEND ${CURRENT_TARGET}_SERPENT_SIMD_SOURCES
        serpent_simd/serp_simd.cpp
        )

    add_definitions(-DBOTAN_HAS_SERPENT_SIMD)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_SERPENT_SIMD_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_SERPENT_SIMD_SOURCES}
        )
endif()

if (BOTAN_BLOCK_THREEFISH)
    list(APPEND ${CURRENT_TARGET}_THREEFISH_HEADERS
        threefish/threefish.h
        )

    list(APPEND ${CURRENT_TARGET}_THREEFISH_SOURCES
        threefish/threefish.cpp
        )

    add_definitions(-DBOTAN_HAS_THREEFISH)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_THREEFISH_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_THREEFISH_SOURCES}
        )
endif()

if (BOTAN_BLOCK_THREEFISH_512_AVX2)
    list(APPEND ${CURRENT_TARGET}_THREEFISH_AVX2_HEADERS
        threefish_avx2/threefish_avx2.h
        )

    list(APPEND ${CURRENT_TARGET}_THREEFISH_AVX2_SOURCES
        threefish_avx2/threefish_avx2.cpp
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

if (BOTAN_BLOCK_TWOFISH)
    list(APPEND ${CURRENT_TARGET}_TWOFISH_HEADERS
        twofish/twofish.h
        )

    list(APPEND ${CURRENT_TARGET}_TWOFISH_SOURCES
        twofish/twofish.cpp
        twofish/two_tab.cpp
        )

    add_definitions(-DBOTAN_HAS_TWOFISH)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_TWOFISH_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_TWOFISH_SOURCES}
        )
endif()

if (BOTAN_BLOCK_XTEA)
    list(APPEND ${CURRENT_TARGET}_XTEA_HEADERS
        xtea/xtea.h
        )

    list(APPEND ${CURRENT_TARGET}_XTEA_SOURCES
        xtea/xtea.cpp
        )

    add_definitions(-DBOTAN_HAS_XTEA)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_XTEA_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_XTEA_SOURCES}
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

if(APPLE)
    set_target_properties(botan_${CURRENT_TARGET} PROPERTIES XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY ${APPLE_SIGN_IDENTITY})
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
    botan::bigint_mp
    #   botan::hash
    #   botan::stream
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
