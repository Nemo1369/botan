cmake_minimum_required(VERSION 2.8.11)

cmake_policy(SET CMP0042 NEW)
cmake_policy(SET CMP0028 NEW)

set(CURRENT_TARGET hash)

list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
    hash.h
    )

list(APPEND ${CURRENT_TARGET}_UNGROUPED_SOURCES
    hash.cpp
    )

if (${CMAKE_TARGET_ARCHITECTURE} STREQUAL "x86_64" OR ${CMAKE_TARGET_ARCHITECTURE} STREQUAL "x86")
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

if (BOTAN_HASH_BLAKE2B)
    list(APPEND ${CURRENT_TARGET}_BLAKE2B_HEADERS
        blake2/blake2b.h
        )

    list(APPEND ${CURRENT_TARGET}_BLAKE2B_SOURCES
        blake2/blake2b.cpp
        )

    add_definitions(-DBOTAN_HAS_BLAKE2B)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_BLAKE2B_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_BLAKE2B_SOURCES}
        )
endif()

if (BOTAN_HASH_CHECKSUM_ADLER32)
    list(APPEND ${CURRENT_TARGET}_ADLER32_HEADERS
        checksum/adler32/adler32.h
        )

    list(APPEND ${CURRENT_TARGET}_ADLER32_SOURCES
        checksum/adler32/adler32.cpp
        )

    add_definitions(-DBOTAN_HAS_ADLER32)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_ADLER32_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_ADLER32_SOURCES}
        )
endif()

if (BOTAN_HASH_CHECKSUM_CRC24)
    list(APPEND ${CURRENT_TARGET}_CRC24_HEADERS
        checksum/crc24/crc24.h
        )

    list(APPEND ${CURRENT_TARGET}_CRC24_SOURCES
        checksum/crc24/crc24.cpp
        )

    add_definitions(-DBOTAN_HAS_CRC24)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_CRC24_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_CRC24_SOURCES}
        )
endif()

if (BOTAN_HASH_CHECKSUM_CRC32)
    list(APPEND ${CURRENT_TARGET}_CRC32_HEADERS
        checksum/crc32/crc32.h
        )

    list(APPEND ${CURRENT_TARGET}_CRC32_SOURCES
        checksum/crc32/crc32.cpp
        )

    add_definitions(-DBOTAN_HAS_CRC32)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_CRC32_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_CRC32_SOURCES}
        )
endif()

if (BOTAN_HASH_COMB4P)
    list(APPEND ${CURRENT_TARGET}_COMB4P_HEADERS
        comb4p/comb4p.h
        )

    list(APPEND ${CURRENT_TARGET}_COMB4P_SOURCES
        comb4p/comb4p.cpp
        )

    add_definitions(-DBOTAN_HAS_COMB4P)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_COMB4P_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_COMB4P_SOURCES}
        )
endif()

if (BOTAN_HASH_GOST_34_11)
    list(APPEND ${CURRENT_TARGET}_GOST_34_11_HEADERS
        gost_3411/gost_3411.h
        )

    list(APPEND ${CURRENT_TARGET}_GOST_34_11_SOURCES
        gost_3411/gost_3411.cpp
        )

    add_definitions(-DBOTAN_HAS_GOST_34_11)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_GOST_34_11_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_GOST_34_11_SOURCES}
        )
endif()

if (BOTAN_HASH_KECCAK)
    list(APPEND ${CURRENT_TARGET}_KECCAK_HEADERS
        keccak/keccak.h
        )

    list(APPEND ${CURRENT_TARGET}_KECCAK_SOURCES
        keccak/keccak.cpp
        )

    add_definitions(-DBOTAN_HAS_KECCAK)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_KECCAK_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_KECCAK_SOURCES}
        )
endif()

if (BOTAN_HASH_MD4)
    list(APPEND ${CURRENT_TARGET}_MD4_HEADERS
        md4/md4.h
        mdx_hash/mdx_hash.h
        )

    list(APPEND ${CURRENT_TARGET}_MD4_SOURCES
        md4/md4.cpp
        mdx_hash/mdx_hash.cpp
        )

    add_definitions(-DBOTAN_HAS_MD4)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_MD4_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_MD4_SOURCES}
        )
endif()

if (BOTAN_HASH_MD5)
    list(APPEND ${CURRENT_TARGET}_MD5_HEADERS
        md5/md5.h
        mdx_hash/mdx_hash.h
        )

    list(APPEND ${CURRENT_TARGET}_MD5_SOURCES
        md5/md5.cpp
        mdx_hash/mdx_hash.cpp
        )

    add_definitions(-DBOTAN_HAS_MD5)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_MD5_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_MD5_SOURCES}
        )
endif()

if (BOTAN_HASH_PARALLEL_HASH)
    list(APPEND ${CURRENT_TARGET}_PARALLEL_HASH_HEADERS
        par_hash/par_hash.h
        )

    list(APPEND ${CURRENT_TARGET}_PARALLEL_HASH_SOURCES
        par_hash/par_hash.cpp
        )

    add_definitions(-DBOTAN_HAS_PARALLEL_HASH)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_PARALLEL_HASH_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_PARALLEL_HASH_SOURCES}
        )
endif()

if (BOTAN_HASH_RIPEMD_160)
    list(APPEND ${CURRENT_TARGET}_RIPEMD_160_HEADERS
        rmd160/rmd160.h
        )

    list(APPEND ${CURRENT_TARGET}_RIPEMD_160_SOURCES
        rmd160/rmd160.cpp
        )

    add_definitions(-DBOTAN_HAS_RIPEMD_160)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_RIPEMD_160_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_RIPEMD_160_SOURCES}
        )
endif()

if (BOTAN_HASH_SHA1)
    list(APPEND ${CURRENT_TARGET}_SHA1_HEADERS
        sha1/sha160.h
        )

    list(APPEND ${CURRENT_TARGET}_SHA1_SOURCES
        sha1/sha160.cpp
        )

    add_definitions(-DBOTAN_HAS_SHA1)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_SHA1_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_SHA1_SOURCES}
        )
endif()

if (BOTAN_HASH_SHA1_SSE2)
    list(APPEND ${CURRENT_TARGET}_SHA1_SSE2_HEADERS
        sha1_sse2/sha1_sse2.h
        )

    list(APPEND ${CURRENT_TARGET}_SHA1_SSE2_SOURCES
        sha1_sse2/sha1_sse2.cpp
        )

    add_definitions(-DBOTAN_HAS_SHA1_SSE2)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_SHA1_SSE2_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_SHA1_SSE2_SOURCES}
        )
endif()

if (BOTAN_HASH_SHA2_32)
    list(APPEND ${CURRENT_TARGET}_SHA2_32_HEADERS
        sha2_32/sha2_32.h
        )

    list(APPEND ${CURRENT_TARGET}_SHA2_32_SOURCES
        sha2_32/sha2_32.cpp
        )

    add_definitions(-DBOTAN_HAS_SHA2_32)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_SHA2_32_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_SHA2_32_SOURCES}
        )
endif()

if (BOTAN_HASH_SHA2_64)
    list(APPEND ${CURRENT_TARGET}_SHA2_64_HEADERS
        sha2_64/sha2_64.h
        )

    list(APPEND ${CURRENT_TARGET}_SHA2_64_SOURCES
        sha2_64/sha2_64.cpp
        )

    add_definitions(-DBOTAN_HAS_SHA2_64)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_SHA2_64_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_SHA2_64_SOURCES}
        )
endif()

if (BOTAN_HASH_SKEIN_512)
    list(APPEND ${CURRENT_TARGET}_SKEIN_512_HEADERS
        skein/skein_512.h
        )

    list(APPEND ${CURRENT_TARGET}_SKEIN_512_SOURCES
        skein/skein_512.cpp
        )

    add_definitions(-DBOTAN_HAS_SKEIN_512)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_SKEIN_512_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_SKEIN_512_SOURCES}
        )
endif()

if (BOTAN_HASH_TIGER)
    list(APPEND ${CURRENT_TARGET}_TIGER_HEADERS
        tiger/tiger.h
        )

    list(APPEND ${CURRENT_TARGET}_TIGER_SOURCES
        tiger/tiger.cpp
        tiger/tig_tab.cpp
        )

    add_definitions(-DBOTAN_HAS_TIGER)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_TIGER_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_TIGER_SOURCES}
        )
endif()

if (BOTAN_HASH_WHIRLPOOL)
    list(APPEND ${CURRENT_TARGET}_WHIRLPOOL_HEADERS
        whirlpool/whrlpool.h
        )

    list(APPEND ${CURRENT_TARGET}_WHIRLPOOL_SOURCES
        whirlpool/whirlpool.cpp
        whirlpool/whrl_tab.cpp
        )

    add_definitions(-DBOTAN_HAS_WHIRLPOOL)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_WHIRLPOOL_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_WHIRLPOOL_SOURCES}
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

target_link_libraries(botan_${CURRENT_TARGET} PRIVATE
    ${${CURRENT_TARGET}_LIBRARIES}
    botan::block
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

if(APPLE AND NOT ${CMAKE_TARGET_ARCHITECTURE} STREQUAL ${CMAKE_HOST_SYSTEM_PROCESSOR})
    set_target_properties(botan_${CURRENT_TARGET} PROPERTIES XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY ${APPLE_CODE_SIGN_IDENTITY})
    set_target_properties(botan_${CURRENT_TARGET} PROPERTIES XCODE_ATTRIBUTE_DEVELOPMENT_TEAM ${CMAKE_XCODE_ATTRIBUTE_DEVELOPMENT_TEAM})
endif()

if(APPLE)
    set_target_properties(botan_${CURRENT_TARGET} PROPERTIES 
        ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}
        BINARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}
        LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}
        )
endif()
