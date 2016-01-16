project(Botan)
cmake_minimum_required(VERSION 2.8)

# Configure for use with CMake
#
#   ./configure.py --with-bzip2 --with-zlib --with-lzma
#

if(CMAKE_VERSION VERSION_LESS "3.1")
	if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
		set(CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS} "-std=gnu++11")
	endif()
else()
	set(CMAKE_CXX_STANDARD 11)
endif()

if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
	set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=c99")
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra -Wformat=2 -Wlogical-op -Wmissing-include-dirs -Wnon-virtual-dtor -Woverloaded-virtual -Wswitch-default -Wuninitialized")
endif()

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/src/cmake")

# libbotan
add_subdirectory("src/lib")

# cli
add_subdirectory("src/cli")

# tests
add_subdirectory("src/tests")

add_dependencies(botan-tests botan)
