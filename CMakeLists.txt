cmake_minimum_required(VERSION 2.8.11)

cmake_policy(SET CMP0042 NEW)
cmake_policy(SET CMP0028 NEW)

project(botan C CXX)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/src/cmake")

include(TargetArchitecture)
include(RypplWriteConfig)
include(CheckTypeSize)

target_architecture(CMAKE_TARGET_ARCHITECTURE)

set(BOTAN_VERSION 1.11.32)
set(BOTAN_VERSION_MAJOR 1)
set(BOTAN_VERSION_MINOR 11)
set(BOTAN_VERSION_PATCH 32)

find_package(Git)
if(GIT_FOUND)
    execute_process(
            COMMAND "${GIT_EXECUTABLE}" log -1 --format=%at HEAD
            WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
            ERROR_VARIABLE stderr
            RESULT_VARIABLE error_code
            OUTPUT_VARIABLE BOTAN_VERSION_DATESTAMP
            OUTPUT_STRIP_TRAILING_WHITESPACE
    )

else()
    set(BOTAN_VERSION_DATESTAMP 1479333131)
endif()

option(BUILD_SHARED_LIBRARIES "Build shared library" TRUE)
option(BUILD_UNIT_TESTS "Build unit tests" FALSE)
set(APPLE_SIGN_IDENTITY "iPhone Developer: nemo1369@gmail.com (S686GL5RJ6)"
        CACHE STRING "Sign identity name")

if(${CMAKE_TARGET_ARCHITECTURE} STREQUAL "x86_64")
    add_definitions(-DBOTAN_TARGET_ARCH_IS_X86_64)
elseif(${CMAKE_TARGET_ARCHITECTURE} STREQUAL "x86")
    add_definitions(-DBOTAN_TARGET_ARCH_IS_X86_32)
endif()

if(NOT ${CMAKE_TARGET_ARCHITECTURE} STREQUAL "PPC")
    add_definitions(-DBOTAN_TARGET_CPU_IS_LITTLE_ENDIAN)
endif()

if(UNIX)
    if(APPLE)
        add_definitions(-DBOTAN_TARGET_OS_HAS_GETTIMEOFDAY)
        add_definitions(-DBOTAN_TARGET_OS_HAS_DLOPEN)
        add_definitions(-DBOTAN_TARGET_OS_HAS_GMTIME_R)
        add_definitions(-DBOTAN_TARGET_OS_HAS_MEMSET_S)
        add_definitions(-DBOTAN_TARGET_OS_HAS_READDIR)
        add_definitions(-DBOTAN_TARGET_OS_HAS_TIMEGM)
        add_definitions(-DBOTAN_TARGET_OS_HAS_SOCKETS)
    else()
        add_definitions(-DBOTAN_TARGET_OS_HAS_CLOCK_GETTIME)
        add_definitions(-DBOTAN_TARGET_OS_HAS_GETTIMEOFDAY)
        add_definitions(-DBOTAN_TARGET_OS_HAS_POSIX_MLOCK)
        add_definitions(-DBOTAN_TARGET_OS_HAS_GMTIME_R)
        add_definitions(-DBOTAN_TARGET_OS_HAS_DLOPEN)
        add_definitions(-DBOTAN_TARGET_OS_HAS_READDIR)
        add_definitions(-DBOTAN_TARGET_OS_HAS_TIMEGM)
        add_definitions(-DBOTAN_TARGET_OS_HAS_SOCKETS)
    endif()

    add_definitions(-DBOTAN_TARGET_OS_TYPE_IS_UNIX)
elseif(WIN32)
    add_definitions(-DBOTAN_TARGET_OS_HAS_CRYPTGENRANDOM)
    add_definitions(-DBOTAN_TARGET_OS_HAS_GMTIME_S)
    add_definitions(-DBOTAN_TARGET_OS_HAS_LOADLIBRARY)
    add_definitions(-DBOTAN_TARGET_OS_HAS_MKGMTIME)
    add_definitions(-DBOTAN_TARGET_OS_HAS_QUERY_PREF_COUNTER)
    add_definitions(-DBOTAN_TARGET_OS_HAS_VIRTUAL_LOCK)
    add_definitions(-DBOTAN_TARGET_OS_HAS_RTLSECUREZEROMEMORY)
    add_definitions(-DBOTAN_TARGET_OS_HAS_STL_FILESYSTEM_MSVC)

    add_definitions(-DBOTAN_TARGET_OS_TYPE_IS_WINDOWS)
endif()

if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
    set(CMAKE_COMPILER_IS_CLANG TRUE)
    set(BOTAN_C_COMPILER_FLAGS -D_REENTRANT -fstack-protector -Wall -Wextra
            -Wpedantic -Wshadow -Wstrict-aliasing -Wstrict-overflow=5 -Wcast-align
            -Wmissing-declarations -Wpointer-arith -Wcast-qual -Wunreachable-code
            -fPIC -fvisibility=hidden --coverage)
    set(BOTAN_CXX_COMPILER_FLAGS -std=c++11 -D_REENTRANT -fstack-protector -Wall
            -Wextra -Wpedantic -Wshadow -Wstrict-aliasing -Wstrict-overflow=5
            -Wcast-align -Wmissing-declarations -Wpointer-arith -Wcast-qual
            -Wunreachable-code -fPIC -fvisibility=hidden)
    set(BOTAN_COMPILER_DEBUG_FLAGS -g -Qunused-arguments
            -Wno-error=unused-parameter -Wno-error=unused-variable
            -Wno-error=unreachable-code -Wno-error=deprecated-declarations)
    set(BOTAN_COMPILER_RELEASE_FLAGS -O3)
elseif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
    set(BOTAN_C_COMPILER_FLAGS -Wall -Wextra -Wpedantic -Wstrict-aliasing
            -Wstrict-overflow=5 -Wcast-align -Wmissing-declarations -Wpointer-arith
            -Wcast-qual -Wzero-as-null-pointer-constant -Wnon-virtual-dtor -fPIC
            --coverage -fvisibility=hidden)
    set(BOTAN_CXX_COMPILER_FLAGS -std=c++11 -D_REENTRANT -Wall -Wextra
            -Wpedantic -Wstrict-aliasing -Wstrict-overflow=5 -Wcast-align
            -Wmissing-declarations -Wpointer-arith -Wcast-qual
            -Wzero-as-null-pointer-constant -Wnon-virtual-dtor -fPIC
            -fvisibility=hidden)
    set(BOTAN_COMPILER_DEBUG_FLAGS -g -Wold-style-cast -Wsuggest-override -Wno-error=old-style-cast
            -Wno-error=zero-as-null-pointer-constant -Wno-error=unused-parameter
            -Wno-error=unused-variable -Wno-error=strict-overflow
            -Wno-error=deprecated-declarations)
    set(BOTAN_COMPILER_RELEASE_FLAGS -O3)
    set(CMAKE_COMPILER_IS_GNUCC TRUE)
    set(CMAKE_COMPILER_IS_GNUCXX TRUE)
elseif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Intel")
    set(CMAKE_COMPILER_IS_ICC TRUE)
elseif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")
    set(CMAKE_COMPILER_IS_MSVC TRUE)
endif()

check_type_size(int CMAKE_TARGET_INTEGER_SIZE_BYTE)
math(EXPR CMAKE_TARGET_INTEGER_SIZE_BITS "${CMAKE_TARGET_INTEGER_SIZE_BYTE} *
8")

if(CMAKE_TARGET_INTEGER_SIZE_BITS EQUAL 64)
    add_definitions(-DTARGET_CPU_HAS_NATIVE_64BIT)
endif()

set(BOTAN_MP_WORD_BITS ${CMAKE_TARGET_INTEGER_SIZE_BITS})

configure_file(${PROJECT_SOURCE_DIR}/src/build-data/build.h.in
        ${CMAKE_BINARY_DIR}/include/botan/build.h)

add_subdirectory("src/lib")

if(BUILD_UNIT_TESTS)
#    add_subdirectory("src/tests")

#    add_dependencies(botan_tests botan)
endif()

# add_subdirectory("src/cli")
