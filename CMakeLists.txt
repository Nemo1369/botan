project(Botan)
cmake_minimum_required(VERSION 2.8)

# Configure for use with CMake
#
#   ./configure.py --with-bzip2 --with-zlib --with-lzma
#

if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=c99")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra -Wformat=2 -Wlogical-op -Wmissing-include-dirs -Wnon-virtual-dtor -Woverloaded-virtual -Wswitch-default -Wuninitialized -std=gnu++11")
endif()

if(${BUILD_FOR_ARMV7_IOS_DEVICE})
    set(IOS_BUILD TRUE)
endif()

if(${BUILD_FOR_ARM64_IOS_DEVICE})
    set(IOS_BUILD TRUE)
endif()

if(${BUILD_FOR_IOS_SIMULATOR})
    set(IOS_BUILD TRUE)
endif()

option(BUILD_FOR_IOS "Build for iOS device" ${IOS_BUILD})
option(BUILD_TESTS "Build unit tests" ${BUILD_UNIT_TESTS})

if(BUILD_FOR_IOS)
    set(IOS TRUE)
endif()

if(BUILD_UNIT_TESTS)
    set(UNIT_TESTS TRUE)
endif()

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/src/cmake")

# libbotan
add_subdirectory("src/lib")

if(UNIT_TESTS)
    # tests
    add_subdirectory("src/tests")

    add_dependencies(botan-tests botan)
endif()

add_subdirectory("src/cli")