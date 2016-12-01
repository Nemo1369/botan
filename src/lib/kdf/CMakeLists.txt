cmake_minimum_required(VERSION 2.8.11)

cmake_policy(SET CMP0042 NEW)
cmake_policy(SET CMP0028 NEW)

set(CURRENT_TARGET kdf)

list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
    kdf.h
    )

list(APPEND ${CURRENT_TARGET}_UNGROUPED_SOURCES
    kdf.cpp
    )

option(BOTAN_KDF_HKDF "Build with HKDF support" TRUE)
option(BOTAN_KDF_KDF1 "Build with HKDF support" TRUE)
option(BOTAN_KDF_KDF1_18033 "Build with HKDF support" TRUE)
option(BOTAN_KDF_KDF2 "Build with HKDF support" TRUE)
option(BOTAN_KDF_TLS_PRF "Build with HKDF support" TRUE)
option(BOTAN_KDF_X942_PRF "Build with HKDF support" TRUE)
option(BOTAN_KDF_SP800_108 "Build with HKDF support" TRUE)
option(BOTAN_KDF_SP800_56C "Build with HKDF support" TRUE)

if (BOTAN_HASH_HKDF)
    list(APPEND ${CURRENT_TARGET}_HKDF_HEADERS
        hkdf/hkdf.h
        )

    list(APPEND ${CURRENT_TARGET}_HKDF_SOURCES
        hkdf/hkdf.cpp
        )

    add_definitions(-DBOTAN_HAS_HKDF)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_HKDF_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_HKDF_SOURCES}
        )
endif()

if (BOTAN_HASH_KDF1)
    list(APPEND ${CURRENT_TARGET}_KDF1_HEADERS
        kdf1/kdf1.h
        )

    list(APPEND ${CURRENT_TARGET}_KDF1_SOURCES
        kdf1/kdf1.cpp
        )

    add_definitions(-DBOTAN_HAS_KDF1)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_KDF1_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_KDF1_SOURCES}
        )
endif()

if (BOTAN_HASH_KDF1_18033)
    list(APPEND ${CURRENT_TARGET}_KDF1_18033_HEADERS
        kdf1_iso18033/kdf1_iso18033.h
        )

    list(APPEND ${CURRENT_TARGET}_KDF1_18033_SOURCES
        kdf1_iso18033/kdf1_iso18033.cpp
        )

    add_definitions(-DBOTAN_HAS_KDF1_18033)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_KDF1_18033_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_KDF1_18033_SOURCES}
        )
endif()

if (BOTAN_HASH_KDF2)
    list(APPEND ${CURRENT_TARGET}_KDF2_HEADERS
        kdf2/kdf2.h
        )

    list(APPEND ${CURRENT_TARGET}_KDF2_SOURCES
        kdf2/kdf2.cpp
        )

    add_definitions(-DBOTAN_HAS_KDF2)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_KDF2_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_KDF2_SOURCES}
        )
endif()

if (BOTAN_HASH_TLS_PRF)
    list(APPEND ${CURRENT_TARGET}_TLS_PRF_HEADERS
        prf_tls/prf_tls.h
        )

    list(APPEND ${CURRENT_TARGET}_TLS_PRF_SOURCES
        prf_tls/prf_tls.cpp
        )

    add_definitions(-DBOTAN_HAS_TLS_V10_PRF)
    add_definitions(-DBOTAN_HAS_TLS_V12_PRF)

    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_TLS_PRF_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_TLS_PRF_SOURCES}
        )
endif()

if (BOTAN_HASH_PRF_X942)
    list(APPEND ${CURRENT_TARGET}_PRF_X942_HEADERS
        prf_x942/prf_x942.h
        )

    list(APPEND ${CURRENT_TARGET}_PRF_X942_SOURCES
        prf_x942/prf_x942.cpp
        )

    add_definitions(-DBOTAN_HAS_X942_PRF)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_PRF_X942_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_PRF_X942_SOURCES}
        )
endif()

if (BOTAN_HASH_SP800_108)
    list(APPEND ${CURRENT_TARGET}_SP800_108_HEADERS
        sp800_108/sp800_108.h
        )

    list(APPEND ${CURRENT_TARGET}_SP800_108_SOURCES
        sp800_108/sp800_108.cpp
        )

    add_definitions(-DBOTAN_HAS_SP800_108)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_SP800_108_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_SP800_108_SOURCES}
        )
endif()

if (BOTAN_HASH_SP800_56C)
    list(APPEND ${CURRENT_TARGET}_SP800_56C_HEADERS
        sp800_56c/sp800_56c.h
        )

    list(APPEND ${CURRENT_TARGET}_SP800_56C_SOURCES
        sp800_56c/sp800_56c.cpp
        )

    add_definitions(-DBOTAN_HAS_SP800_56C)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_SP800_56C_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_SP800_56C_SOURCES}
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

target_link_libraries(botan_${CURRENT_TARGET} PRIVATE botan)

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
