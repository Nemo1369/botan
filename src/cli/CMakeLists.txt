set(INCLUDE_DIR "../../build/include")
include_directories(${INCLUDE_DIR})

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
    if(NOT IOS)
        find_package(SQLite3)
        if(SQLITE3_FOUND)
            include_directories(${SQLITE3_INCLUDES})
            list(APPEND CURRENT_TARGET_LIBRARIES ${SQLITE3_LIBRARIES})
        else()

            if(NOT TARGET sqlite3)
                add_subdirectory(${PROJECT_SOURCE_DIR}/lib/frameworks/sqlite3)
            endif()

            include_directories(${PROJECT_SOURCE_DIR}/lib/frameworks/sqlite3)
            list(APPEND CURRENT_TARGET_LIBRARIES sqlite3)
        endif()
    else()
        if(NOT TARGET sqlite3)
            add_subdirectory(${PROJECT_SOURCE_DIR}/lib/frameworks/sqlite3)
        endif()

        include_directories(${PROJECT_SOURCE_DIR}/lib/frameworks/sqlite3)

        list(APPEND CURRENT_TARGET_LIBRARIES sqlite3)
    endif()
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