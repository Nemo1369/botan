cmake_minimum_required(VERSION 2.8.11)

cmake_policy(SET CMP0042 NEW)
cmake_policy(SET CMP0028 NEW)

set(CURRENT_TARGET aead)

list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
    aead.h
    )

list(APPEND ${CURRENT_TARGET}_UNGROUPED_SOURCES
    aead.cpp
    )

option(BOTAN_MODES_AEAD_CCM "Build with AEAD CCM mode support" TRUE)
option(BOTAN_MODES_AEAD_CHACHA20_POLY1305 "Build with AEAD CHACHA20 Poly1305 mode support" TRUE)
option(BOTAN_MODES_AEAD_EAX "Build with AEAD EAX mode support" TRUE)
option(BOTAN_MODES_AEAD_GCM "Build with AEAD GCM mode support" TRUE)
option(BOTAN_MODES_AEAD_OCB "Build with AEAD ODB mode support" TRUE)
option(BOTAN_MODES_AEAD_SIV "Build with AEAD SIV mode support" TRUE)

if (BOTAN_MODES_AEAD_CCM)
    list(APPEND ${CURRENT_TARGET}_AEAD_CCM_HEADERS
        ccm/ccm.h
        )

    list(APPEND ${CURRENT_TARGET}_AEAD_CCM_SOURCES
        ccm/ccm.cpp
        )

    add_definitions(-DBOTAN_HAS_AEAD_CCM)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_AEAD_CCM_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_AEAD_CCM_SOURCES}
        )
endif()

if (BOTAN_MODES_AEAD_CHACHA20_POLY1305)
    list(APPEND ${CURRENT_TARGET}_AEAD_CHACHA20_POLY1305_HEADERS
        chacha20poly1305/chacha20poly1305.h
        )

    list(APPEND ${CURRENT_TARGET}_AEAD_CHACHA20_POLY1305_SOURCES
        chacha20poly1305/chacha20poly1305.cpp
        )

    list(APPEND ${CURRENT_TARGET}_LIBRARIES
        botan::chacha
        botan::poly1305
        )

    add_definitions(-DBOTAN_HAS_AEAD_CHACHA20_POLY1305)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_AEAD_CHACHA20_POLY1305_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_AEAD_CHACHA20_POLY1305_SOURCES}
        )
endif()

if (BOTAN_MODES_AEAD_EAX)
    list(APPEND ${CURRENT_TARGET}_AEAD_EAX_HEADERS
        eax/eax.h
        )

    list(APPEND ${CURRENT_TARGET}_AEAD_EAX_SOURCES
        eax/eax.cpp
        )

    list(APPEND ${CURRENT_TARGET}_LIBRARIES
        botan::cmac
        botan::ctr
        )

    add_definitions(-DBOTAN_HAS_AEAD_EAX)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_AEAD_EAX_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_AEAD_EAX_SOURCES}
        )
endif()

if (BOTAN_MODES_AEAD_GCM)
    list(APPEND ${CURRENT_TARGET}_AEAD_GCM_HEADERS
        gcm/gcm.h
        )

    list(APPEND ${CURRENT_TARGET}_AEAD_GCM_SOURCES
        gcm/gcm.cpp
        )

    list(APPEND ${CURRENT_TARGET}_LIBRARIES
        botan::ctr
        )

    add_definitions(-DBOTAN_HAS_AEAD_GCM)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_AEAD_GCM_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_AEAD_GCM_SOURCES}
        )
endif()

if (BOTAN_MODES_AEAD_OCB)
    list(APPEND ${CURRENT_TARGET}_AEAD_OCB_HEADERS
        ocb/ocb.h
        )

    list(APPEND ${CURRENT_TARGET}_AEAD_OCB_SOURCES
        ocb/ocb.cpp
        )

    add_definitions(-DBOTAN_HAS_AEAD_OCB)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_AEAD_OCB_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_AEAD_OCB_SOURCES}
        )
endif()

if (BOTAN_MODES_AEAD_SIV)
    list(APPEND ${CURRENT_TARGET}_AEAD_SIV_HEADERS
        siv/siv.h
        )

    list(APPEND ${CURRENT_TARGET}_AEAD_SIV_SOURCES
        siv/siv.cpp
        )

    add_definitions(-DBOTAN_HAS_AEAD_SIV)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_AEAD_SIV_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_AEAD_SIV_SOURCES}
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
    botan::mac
    botan::modes
    botan::utils
    botan
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
