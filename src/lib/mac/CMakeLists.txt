cmake_minimum_required(VERSION 2.8.11)

cmake_policy(SET CMP0042 NEW)
cmake_policy(SET CMP0028 NEW)

set(CURRENT_TARGET mac)

list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
    mac.h
    )

list(APPEND ${CURRENT_TARGET}_UNGROUPED_SOURCES
    mac.cpp
    )

option(BOTAN_MAC_CBC "Build with CBC MAC support" TRUE)
option(BOTAN_MAC_CMAC "Build with CMAC support" TRUE)
option(BOTAN_MAC_HMAC "Build with HMAC support" TRUE)
option(BOTAN_MAC_POLY1305 "Build with POLY1305 MAC support" TRUE)
option(BOTAN_MAC_SIPHASH "Build with SIPHASH MAC support" TRUE)
option(BOTAN_MAC_ANSI_X919 "Build with ANSI X919 MAC support" TRUE)

if (BOTAN_MAC_CBC)
    list(APPEND ${CURRENT_TARGET}_CBC_MAC_HEADERS
        cbc_mac/cbc_mac.h
        )

    list(APPEND ${CURRENT_TARGET}_CBC_MAC_SOURCES
        cbc_mac/cbc_mac.cpp
        )

    add_definitions(-DBOTAN_HAS_CBC_MAC)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_CBC_MAC_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_CBC_MAC_SOURCES}
        )
endif()

if (BOTAN_MAC_CMAC)
    list(APPEND ${CURRENT_TARGET}_CMAC_HEADERS
        cmac/cmac.h
        )

    list(APPEND ${CURRENT_TARGET}_CMAC_SOURCES
        cmac/cmac.cpp
        )

    add_definitions(-DBOTAN_HAS_CMAC)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_CMAC_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_CMAC_SOURCES}
        )
endif()

if (BOTAN_MAC_HMAC)
    list(APPEND ${CURRENT_TARGET}_HMAC_HEADERS
        hmac/hmac.h
        )

    list(APPEND ${CURRENT_TARGET}_HMAC_SOURCES
        hmac/hmac.cpp
        )

    add_definitions(-DBOTAN_HAS_HMAC)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_HMAC_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_HMAC_SOURCES}
        )
endif()

if (BOTAN_MAC_POLY1305)
    list(APPEND ${CURRENT_TARGET}_MAC_POLY1305_HEADERS
        poly1305/poly1305.h
        )

    list(APPEND ${CURRENT_TARGET}_MAC_POLY1305_SOURCES
        poly1305/poly1305.cpp
        )

    add_definitions(-DBOTAN_HAS_POLY1305)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_MAC_POLY1305_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_MAC_POLY1305_SOURCES}
        )
endif()

if (BOTAN_MAC_SIPHASH)
    list(APPEND ${CURRENT_TARGET}_SIPHASH_HEADERS
        siphash/siphash.h
        )

    list(APPEND ${CURRENT_TARGET}_SIPHASH_SOURCES
        siphash/siphash.cpp
        )

    add_definitions(-DBOTAN_HAS_SIPHASH)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_SIPHASH_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_SIPHASH_SOURCES}
        )
endif()

if (BOTAN_MAC_ANSI_X919)
    list(APPEND ${CURRENT_TARGET}_X919_HEADERS
        x919_mac/x919_mac.h
        )

    list(APPEND ${CURRENT_TARGET}_X919_SOURCES
        x919_mac/x919_mac.cpp
        )

    add_definitions(-DBOTAN_HAS_ANSI_X919_MAC)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_X919_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_X919_SOURCES}
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
    botan
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
