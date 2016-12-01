cmake_minimum_required(VERSION 2.8.11)

cmake_policy(SET CMP0042 NEW)
cmake_policy(SET CMP0028 NEW)

set(CURRENT_TARGET tls)

list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
    credentials_manager.h
    tls_alert.h
    tls_blocking.h
    tls_callbacks.h
    tls_channel.h
    tls_ciphersuite.h
    tls_client.h
    tls_exceptn.h
    tls_handshake_msg.h
    tls_magic.h
    tls_server_info.h
    tls_policy.h
    tls_server.h
    tls_session.h
    tls_session_manager.h
    tls_version.h

    )

list(APPEND ${CURRENT_TARGET}_PRIVATE_HEADERS
    tls_extensions.h
    tls_handshake_hash.h
    tls_handshake_io.h
    tls_handshake_state.h
    tls_messages.h
    tls_reader.h
    tls_record.h
    tls_seq_numbers.h
    tls_session_key.h
    )

list(APPEND ${CURRENT_TARGET}_UNGROUPED_SOURCES
    credentials_manager.cpp
    msg_cert_req.cpp
    msg_cert_verify.cpp
    msg_certificate.cpp
    msg_client_hello.cpp
    msg_client_kex.cpp
    msg_finished.cpp
    msg_hello_verify.cpp
    msg_server_hello.cpp
    msg_server_kex.cpp
    msg_session_ticket.cpp
    tls_alert.cpp
    tls_blocking.cpp
    tls_channel.cpp
    tls_ciphersuite.cpp
    tls_client.cpp
    tls_extensions.cpp
    tls_handshake_hash.cpp
    tls_handshake_io.cpp
    tls_handshake_state.cpp
    tls_policy.cpp
    tls_record.cpp
    tls_server.cpp
    tls_session.cpp
    tls_session_key.cpp
    tls_session_manager_memory.cpp
    tls_suite_info.cpp
    tls_version.cpp
    )

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

if (${CMAKE_TARGET_ARCHITECTURE} STREQUAL "x86_64" OR
        ${CMAKE_TARGET_ARCHITECTURE} STREQUAL "x86")
    list(APPEND ${CURRENT_TARGET}_LIBRARIES
        #    botan::sha1_sse2
        )
else()
    list(APPEND ${CURRENT_TARGET}_LIBRARIES
        #botan::sha1
        )
endif()

target_link_libraries(botan_${CURRENT_TARGET} PRIVATE
    ${${CURRENT_TARGET}_LIBRARIES}
    botan::aead
    botan
    botan::asn1
    botan::pk_pad
    botan::mac
    botan::kdf
    botan::hex
    botan::utils
    botan::bigint_mp
    botan::pubkey
    botan::ec_group
    botan::entropy_rng
    botan::ec_gfp
    botan::pem
    botan::x509
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
