set(CURRENT_TARGET cli)

include_directories("${CMAKE_BINARY_DIR}/include")

list(APPEND CURRENT_TARGET_LIBRARIES)
if(NOT WIN32)
    #    list(APPEND CURRENT_TARGET_LIBRARIES dl pthread)
endif()

if(APPLE)
    find_library(FOUNDATION_LIBRARY Foundation)
    find_library(SECURITY_LIBRARY Security)

    list(APPEND CURRENT_TARGET_LIBRARIES ${SECURITY_LIBRARY} ${FOUNDATION_LIBRARY})
endif()

if(SQL_SESSIONS_MODULE)
    list(APPEND BOTAN_SRC
            utils/sqlite3_interface/sqlite3_interface.c
            utils/sqlite3_interface/sqlite3_interface.cpp
            tls/sessions_sqlite3/tls_session_manager_sqlite.cpp
            tls/sessions_sql/tls_session_manager_sql.cpp)
endif()

# botan-cli
add_executable(botan_cli
        asn1.cpp
        cc_enc.cpp
        compress.cpp
        main.cpp
        math.cpp
        pubkey.cpp
        speed.cpp
        tls_client.cpp
        tls_proxy.cpp
        tls_server.cpp
        utils.cpp
        x509.cpp
        )

    target_compile_options(botan_${CURRENT_TARGET} PUBLIC
    $<$<COMPILE_LANGUAGE:C>:${BOTAN_C_COMPILER_FLAGS}>)

target_compile_options(botan_${CURRENT_TARGET} PUBLIC
    $<$<COMPILE_LANGUAGE:CXX>:${BOTAN_CXX_COMPILER_FLAGS}>)

target_compile_options(botan_${CURRENT_TARGET} PUBLIC
    $<$<CONFIG:DEBUG>:${BOTAN_COMPILER_DEBUG_FLAGS}>)

target_compile_options(botan_${CURRENT_TARGET} PUBLIC
    $<$<CONFIG:RELEASE>:${BOTAN_COMPILER_RELEASE_FLAGS}>)


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

target_link_libraries(botan_cli botan ${CURRENT_TARGET_LIBRARIES})
