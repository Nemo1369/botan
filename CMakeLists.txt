project(Botan)
cmake_minimum_required(VERSION 2.8)

cmake_policy(SET CMP0042 NEW)

# Configure for use with CMake
#
#   ./configure.py --with-bzip2 --with-zlib --with-lzma
#

set(CMAKE_MODULE_PATH src/cmake)

if(BUILD_FOR_ARMV7_IOS_DEVICE OR BUILD_FOR_ARM64_IOS_DEVICE)
    set(ARM_BUILD TRUE)
endif()

option(BUILD_MODULAR "Build Botan library as a set of independent libraries" FALSE)
option(BUILD_FOR_IOS "Build for iOS device" ${ARM_BUILD})
option(BUILD_UNIT_TESTS "Build unit tests" FALSE)
set(APPLE_SIGN_IDENTITY "iPhone Developer: nemo1369@gmail.com (S686GL5RJ6)" CACHE STRING "Sign identity name")

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/src/cmake")

# libbotan
add_subdirectory("src/lib")

if(BUILD_UNIT_TESTS)
    # tests
    add_subdirectory("src/tests")

    add_dependencies(botan_tests botan)
endif()

add_subdirectory("src/cli")