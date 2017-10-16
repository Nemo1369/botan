cmake_minimum_required(VERSION 2.8.11)

cmake_policy(SET CMP0042 NEW)
cmake_policy(SET CMP0028 NEW)

set(CURRENT_TARGET compression)

list(APPEND ${CURRENT_TARGET}_INCLUDES
    ${CMAKE_BINARY_DIR}/include
    )

find_package(ZLIB)
find_package(LIBLZMA)
find_package(BZIP2)

option(BOTAN_COMPRESSION_BZIP2 "Build with bzip2 compression support"
    ${BZIP2_FOUND})
option(BOTAN_COMPRESSION_LZMA "Build with lzma compression support"
    ${LZMA_FOUND})
option(BOTAN_COMPRESSION_ZLIB "Build with zlib compression support"
    ${ ZLIB_FOUND})

if (BOTAN_COMPRESSION_BZIP2)
    list(APPEND ${CURRENT_TARGET}_INCLUDES
        ${BZIP2_INCLUDE_DIRS}
        )

    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        bzip2/bzip2.h
        )

    list(APPEND ${CURRENT_TARGET}_UNGROUPED_SOURCES
        bzip2/bzip2.cpp
        )

    list(APPEND ${CURRENT_TARGET}_LIBRARIES
        ${BZIP2_LIBRARIES}
        )
endif()

if (BOTAN_COMPRESSION_LZMA)
    list(APPEND ${CURRENT_TARGET}_INCLUDES
        ${LIBLZMA_INCLUDE_DIRS}
        )

    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        lzma/lzma.h
        )

    list(APPEND ${CURRENT_TARGET}_UNGROUPED_SOURCES
        lzma/lzma.cpp
        )

    list(APPEND ${CURRENT_TARGET}_LIBRARIES
        ${LIBLZMA_LIBRARIES}
        )
endif()

if (BOTAN_COMPRESSION_ZLIB)
    list(APPEND ${CURRENT_TARGET}_INCLUDES
        ${ZLIB_INCLUDE_DIRS}
        )

    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        zlib/zlib.h
        )

    list(APPEND ${CURRENT_TARGET}_UNGROUPED_SOURCES
        zlib/zlib.cpp
        )

    list(APPEND ${CURRENT_TARGET}_LIBRARIES
        ${ZLIB_LIBRARIES}
        )
endif()

list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
    compression.h
    )

list(APPEND ${CURRENT_TARGET}_PRIVATE_HEADERS
    compress_utils.h
    )

list(APPEND ${CURRENT_TARGET}_UNGROUPED_SOURCES
    compression.cpp
    )

list(APPEND ${CURRENT_TARGET}_HEADERS
    ${${CURRENT_TARGET}_PUBLIC_HEADERS}
    ${${CURRENT_TARGET}_PRIVATE_HEADERS}
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
    set_target_properties(botan_${CURRENT_TARGET} PROPERTIES XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY ${APPLE_CODE_SIGN_IDENTITY})
endif()

target_include_directories(botan_${CURRENT_TARGET} PUBLIC
    "$<BUILD_INTERFACE:${${CURRENT_TARGET}_INCLUDES}>"
    )

target_compile_options(botan_${CURRENT_TARGET} PUBLIC
    $<$<COMPILE_LANGUAGE:C>:${BOTAN_C_COMPILER_FLAGS}>)

target_compile_options(botan_${CURRENT_TARGET} PUBLIC
    $<$<COMPILE_LANGUAGE:CXX>:${BOTAN_CXX_COMPILER_FLAGS}>)

target_compile_options(botan_${CURRENT_TARGET} PUBLIC
    $<$<CONFIG:DEBUG>:${BOTAN_COMPILER_DEBUG_FLAGS}>)

target_link_libraries(botan_${CURRENT_TARGET} PRIVATE
    ${${CURRENT_TARGET}_LIBRARIES}
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
