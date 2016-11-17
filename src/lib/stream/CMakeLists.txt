cmake_minimum_required(VERSION 2.8.11)

cmake_policy(SET CMP0042 NEW)
cmake_policy(SET CMP0028 NEW)

set(CURRENT_TARGET stream)

list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
    stream_cipher.h
    )

list(APPEND ${CURRENT_TARGET}_UNGROUPED_SOURCES
    stream_cipher.cpp
    )

option(BOTAN_STREAM_CHACHA "Build with CHACHA stream encryption support" TRUE)
option(BOTAN_STREAM_SALSA20 "Build with SALSA20 stream encryption support" TRUE)
option(BOTAN_STREAM_CTR_BE "Build with CTR BE stream encryption support" TRUE)
option(BOTAN_STREAM_OFB "Build with OFB stream encryption support" TRUE)
option(BOTAN_STREAM_RC4 "Build with RC4 stream encryption support" TRUE)

if (BOTAN_STREAM_CHACHA)
    list(APPEND ${CURRENT_TARGET}_CHACHA_HEADERS
        chacha/chacha.h    
        )

    if (${CMAKE_TARGET_ARCHITECTURE} STREQUAL "x86_64" OR
            ${CMAKE_TARGET_ARCHITECTURE} STREQUAL "x86")
        add_definitions(-DBOTAN_HAS_CHACHA_SSE2)
        list(APPEND ${CURRENT_TARGET}_CHACHA_SOURCES
            chacha/chacha_sse2/chacha_sse2.cpp
            )
    elseif()
        list(APPEND ${CURRENT_TARGET}_CHACHA_SOURCES
            chacha/chacha.cpp
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

if (BOTAN_STREAM_SALSA20)
    list(APPEND ${CURRENT_TARGET}_SALSA20_HEADERS
        salsa20/salsa20.h    
        )

    list(APPEND ${CURRENT_TARGET}_SALSA20_SOURCES
        salsa20/salsa20.cpp
        )

    add_definitions(-DBOTAN_HAS_SALSA20)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_SALSA20_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_SALSA20_SOURCES}
        )
endif()

if (BOTAN_STREAM_CTR_BE)
    list(APPEND ${CURRENT_TARGET}_CTR_BE_HEADERS
        ctr/ctr.h    
        )

    list(APPEND ${CURRENT_TARGET}_CTR_BE_SOURCES
        ctr/ctr.cpp
        )

    add_definitions(-DBOTAN_HAS_CTR_BE)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_CTR_BE_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_CTR_BE_SOURCES}
        )
endif()

if (BOTAN_STREAM_OFB)
    list(APPEND ${CURRENT_TARGET}_OFB_HEADERS
        ofb/ofb.h    
        )

    list(APPEND ${CURRENT_TARGET}_OFB_SOURCES
        ofb/ofb.cpp
        )

    add_definitions(-DBOTAN_HAS_OFB)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_OFB_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_OFB_SOURCES}
        )
endif()

if (BOTAN_STREAM_RC4)
    list(APPEND ${CURRENT_TARGET}_RC4_HEADERS
        rc4/rc4.h    
        )

    list(APPEND ${CURRENT_TARGET}_RC4_SOURCES
        rc4/rc4.cpp
        )

    add_definitions(-DBOTAN_HAS_RC4)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_RC4_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_RC4_SOURCES}
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
    botan::bigint_mp
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
