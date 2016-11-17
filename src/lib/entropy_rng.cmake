cmake_minimum_required(VERSION 2.8.11)

cmake_policy(SET CMP0042 NEW)
cmake_policy(SET CMP0028 NEW)

set(CURRENT_TARGET entropy_rng)

list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
    entropy/entropy_src.h
    )

list(APPEND ${CURRENT_TARGET}_UNGROUPED_SOURCES
    entropy/entropy_srcs.cpp
    )

option(BOTAN_ENTROPY_BEOS_STATS "Build with BeOS stats entropy source support"
    FALSE)

if (WIN32)
    option(BOTAN_ENTROPY_CRYPTOAPI_RNG "Build with cryptoapi random generator entropy source support" TRUE)
endif()

if (APPLE)
    option(BOTAN_ENTROPY_DARWIN_SECRANDOM "Build with Darwin secure random entropy source support" TRUE)
endif()

if (UNIX)
    option(BOTAN_ENTROPY_DEV_RANDOM "Build with /dev/random entropy source support" TRUE)
endif()

if (UNIX)
    option(BOTAN_ENTROPY_PROC_WALKER "Build with process walker entropy source support" TRUE)
endif()

if(UNIX)
    option(BOTAN_ENTROPY_EGD "Build with EGD entropy source support" TRUE)
endif()

option(BOTAN_ENTROPY_RDRAND "Build with rdrand entropy source support" TRUE)

if (${CMAKE_TARGET_ARCHITECTURE} STREQUAL "x86_64" OR
        ${CMAKE_TARGET_ARCHITECTURE} STREQUAL "x86")
    if (CMAKE_COMPILER_IS_GNUCC OR CMAKE_COMPILER_IS_GNUCXX OR
            CMAKE_COMPILER_IS_CLANG OR CMAKE_COMPILER_IS_MSVC OR
            CMAKE_COMPILER_IS_ICC)
        option(BOTAN_ENTROPY_RDSEED "Build with rdseed entropy source support" TRUE)
    endif()
else()
    set(BOTAN_ENTROPY_RDRAND FALSE)
endif()

if (UNIX)
    option(BOTAN_ENTROPY_UNIX_PROCESS_RUNNER "Build with UNIX process runner entropy source support" TRUE)
endif()

if (WIN32)
    option(BOTAN_ENTROPY_WINDOWS_STATS "Build with windows stats entropy source support" TRUE)
endif()

if (BOTAN_ENTROPY_BEOS_STATS)
    list(APPEND ${CURRENT_TARGET}_BEOS_HEADERS
        entropy/beos_stats/es_beos.h
        )

    list(APPEND ${CURRENT_TARGET}_BEOS_SOURCES
        entropy/beos_stats/es_beos.cpp
        )

    add_definitions(-DBOTAN_HAS_ENTROPY_SRC_BEOS)
    list(APPEND ${CURRENT_TARGET}_PRIVATE_HEADERS
        ${${CURRENT_TARGET}_BEOS_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_BEOS_SOURCES}
        )
endif()

if (BOTAN_ENTROPY_CRYPTOAPI_RNG AND WIN32)
    list(APPEND ${CURRENT_TARGET}_CRYPTOAPI_RNG_HEADERS
        entropy/cryptoapi_rng/es_capi.h
        )

    list(APPEND ${CURRENT_TARGET}_CRYPTOAPI_RNG_SOURCES
        entropy/cryptoapi_rng/es_capi.h
        )

    add_definitions(-DBOTAN_HAS_ENTROPY_SRC_CAPI)
    list(APPEND ${CURRENT_TARGET}_PRIVATE_HEADERS
        ${${CURRENT_TARGET}_CRYPTOAPI_RNG_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_CRYPTOAPI_RNG_SOURCES}
        )
endif()

if (BOTAN_ENTROPY_DARWIN_SECRANDOM AND APPLE)
    list(APPEND ${CURRENT_TARGET}_DARWIN_SECRANDOM_HEADERS
        entropy/darwin_secrandom/darwin_secrandom.h
        )

    list(APPEND ${CURRENT_TARGET}_DARWIN_SECRANDOM_SOURCES
        entropy/darwin_secrandom/darwin_secrandom.cpp
        )

    find_library(SECURITY_LIBRARY Security)

    list(APPEND ${CURRENT_TARGET}_LIBRARIES ${SECURITY_LIBRARY})

    add_definitions(-DBOTAN_HAS_ENTROPY_SRC_DARWIN_SECRANDOM)
    list(APPEND ${CURRENT_TARGET}_PRIVATE_HEADERS
        ${${CURRENT_TARGET}_DARWIN_SECRANDOM_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_DARWIN_SECRANDOM_SOURCES}
        )
endif()

if (BOTAN_ENTROPY_DEV_RANDOM AND UNIX)
    list(APPEND ${CURRENT_TARGET}_DEV_RANDOM_HEADERS
        entropy/dev_random/dev_random.h
        )

    list(APPEND ${CURRENT_TARGET}_DEV_RANDOM_SOURCES
        entropy/dev_random/dev_random.cpp
        )

    add_definitions(-DBOTAN_HAS_ENTROPY_SRC_DEV_RANDOM)
    list(APPEND ${CURRENT_TARGET}_PRIVATE_HEADERS
        ${${CURRENT_TARGET}_DEV_RANDOM_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_DEV_RANDOM_SOURCES}
        )
endif()

if (BOTAN_ENTROPY_EGD AND UNIX)
    list(APPEND ${CURRENT_TARGET}_EGD_HEADERS
        entropy/egd/es_egd.h
        )

    list(APPEND ${CURRENT_TARGET}_EGD_SOURCES
        entropy/egd/es_egd.cpp
        )

    add_definitions(-DBOTAN_HAS_ENTROPY_SRC_EGD)
    list(APPEND ${CURRENT_TARGET}_PRIVATE_HEADERS
        ${${CURRENT_TARGET}_EGD_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_EGD_SOURCES}
        )
endif()

if (BOTAN_ENTROPY_PROC_WALKER)
    list(APPEND ${CURRENT_TARGET}_PROC_WALKER_HEADERS
        entropy/proc_walk/proc_walk.h
        )

    list(APPEND ${CURRENT_TARGET}_PROC_WALKER_SOURCES
        entropy/proc_walk/proc_walk.cpp
        )

    add_definitions(-DBOTAN_HAS_ENTROPY_SRC_PROC_WALKER)
    list(APPEND ${CURRENT_TARGET}_PRIVATE_HEADERS
        ${${CURRENT_TARGET}_PROC_WALKER_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_PROC_WALKER_SOURCES}
        )
endif()

if (BOTAN_ENTROPY_RDRAND)
    list(APPEND ${CURRENT_TARGET}_RDRAND_HEADERS
        entropy/rdrand/rdrand.h
        )

    list(APPEND ${CURRENT_TARGET}_RDRAND_SOURCES
        entropy/rdrand/rdrand.cpp
        )

    add_definitions(-DBOTAN_HAS_ENTROPY_SRC_RDRAND)
    list(APPEND ${CURRENT_TARGET}_PRIVATE_HEADERS
        ${${CURRENT_TARGET}_RDRAND_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_RDRAND_SOURCES}
        )
endif()

if (BOTAN_ENTROPY_RDSEED)
    list(APPEND ${CURRENT_TARGET}_RDSEED_HEADERS
        entropy/rdseed/rdseed.h
        )

    list(APPEND ${CURRENT_TARGET}_RDSEED_SOURCES
        entropy/rdseed/rdseed.cpp
        )

    add_definitions(-DBOTAN_HAS_ENTROPY_SRC_RDSEED)
    list(APPEND ${CURRENT_TARGET}_PRIVATE_HEADERS
        ${${CURRENT_TARGET}_RDSEED_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_RDSEED_SOURCES}
        )
endif()

if (BOTAN_ENTROPY_UNIX_PROCESS_RUNNER)
    list(APPEND ${CURRENT_TARGET}_UNIX_PROCESS_RUNNER_HEADERS
        entropy/unix_procs/unix_procs.h
        )

    list(APPEND ${CURRENT_TARGET}_UNIX_PROCESS_RUNNER_SOURCES
        entropy/unix_procs/unix_procs.cpp
        entropy/unix_procs/unix_proc_sources.cpp
        )

    add_definitions(-DBOTAN_HAS_ENTROPY_SRC_UNIX_PROCESS_RUNNER)
    list(APPEND ${CURRENT_TARGET}_PRIVATE_HEADERS
        ${${CURRENT_TARGET}_UNIX_PROCESS_RUNNER_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_UNIX_PROCESS_RUNNER_SOURCES}
        )
endif()

if (BOTAN_ENTROPY_WINDOWS_STATS)
    list(APPEND ${CURRENT_TARGET}_WINDOWS_STATS_HEADERS
        entropy/win32_stats/es_win32.h
        )

    list(APPEND ${CURRENT_TARGET}_WINDOWS_STATS_SOURCES
        entropy/win32_stats/es_win32.cpp
        )

    list(APPEND ${CURRENT_TARGET}_LIBRARIES
        user32
        )

    add_definitions(-DBOTAN_HAS_ENTROPY_SRC_WIN32)
    list(APPEND ${CURRENT_TARGET}_PRIVATE_HEADERS
        ${${CURRENT_TARGET}_WINDOWS_STATS_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_WINDOWS_STATS_SOURCES}
        )
endif()

list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
    rng/rng.h
    )

list(APPEND ${CURRENT_TARGET}_UNGROUPED_SOURCES
    rng/rng.cpp
    )

option(BOTAN_AUTO_SEEDING_RNG "Build with auto seeding random generator support" TRUE)
option(BOTAN_HMAC_SEEDING_RNG "Build with auto seeding random generator support" TRUE)
option(BOTAN_HMAC_DRBG_SEEDING_RNG "Build with auto seeding random generator support" TRUE)
option(BOTAN_STATEFUL_SEEDING_RNG "Build with auto seeding random generator support" TRUE)
option(BOTAN_SYSTEM_SEEDING_RNG "Build with auto seeding random generator support" TRUE)

if (CMAKE_COMPILER_IS_CLANG OR CMAKE_COMPILER_IS_GNUC OR
        CMAKE_COMPILER_IS_GNUCXX OR CMAKE_COMPILER_IS_ICC OR
        CMAKE_COMPILER_IS_MSVC)
    if (${CMAKE_TARGET_ARCHITECTURE} STREQUAL "x86_64" OR
            ${CMAKE_TARGET_ARCHITECTURE} STREQUAL "x86")
        option(BOTAN_RDRAND_RNG "Build with auto seeding random generator support" TRUE)
    endif()
endif()

if (BOTAN_AUTO_SEEDING_RNG)
    list(APPEND ${CURRENT_TARGET}_AUTO_SEEDING_RNG_HEADERS
        rng/auto_rng/auto_rng.h    
        )

    list(APPEND ${CURRENT_TARGET}_AUTO_SEEDING_RNG_SOURCES
        rng/auto_rng/auto_rng.cpp
        )

    add_definitions(-DBOTAN_HAS_AUTO_SEEDING_RNG)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_AUTO_SEEDING_RNG_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_AUTO_SEEDING_RNG_SOURCES}
        )
endif()

if (BOTAN_STATEFUL_SEEDING_RNG)
    list(APPEND ${CURRENT_TARGET}_STATEFUL_SEEDING_RNG_HEADERS
        rng/stateful_rng/stateful_rng.h    
        )

    list(APPEND ${CURRENT_TARGET}_STATEFUL_SEEDING_RNG_SOURCES
        rng/stateful_rng/stateful_rng.cpp
        )

    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_STATEFUL_SEEDING_RNG_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_STATEFUL_SEEDING_RNG_SOURCES}
        )
endif()

if (BOTAN_HMAC_SEEDING_RNG)
    list(APPEND ${CURRENT_TARGET}_HMAC_SEEDING_RNG_HEADERS
        rng/hmac_rng/hmac_rng.h    
        )

    list(APPEND ${CURRENT_TARGET}_HMAC_SEEDING_RNG_SOURCES
        rng/hmac_rng/hmac_rng.cpp
        )

    add_definitions(-DBOTAN_HAS_HMAC_RNG)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_HMAC_SEEDING_RNG_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_HMAC_SEEDING_RNG_SOURCES}
        )
endif()

if (BOTAN_HMAC_DRBG_SEEDING_RNG)
    list(APPEND ${CURRENT_TARGET}_HMAC_DRBG_SEEDING_RNG_HEADERS
        rng/hmac_drbg/hmac_drbg.h    
        )

    list(APPEND ${CURRENT_TARGET}_HMAC_DRBG_SEEDING_RNG_SOURCES
        rng/hmac_drbg/hmac_drbg.cpp
        )

    add_definitions(-DBOTAN_HAS_HMAC_DRBG)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_HMAC_DRBG_SEEDING_RNG_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_HMAC_DRBG_SEEDING_RNG_SOURCES}
        )
endif()

if (BOTAN_SYSTEM_SEEDING_RNG)
    list(APPEND ${CURRENT_TARGET}_SYSTEM_SEEDING_RNG_HEADERS
        rng/system_rng/system_rng.h    
        )

    list(APPEND ${CURRENT_TARGET}_SYSTEM_SEEDING_RNG_SOURCES
        rng/system_rng/system_rng.cpp
        )

    add_definitions(-DBOTAN_HAS_SYSTEM_RNG)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_SYSTEM_SEEDING_RNG_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_SYSTEM_SEEDING_RNG_SOURCES}
        )
endif()

if (BOTAN_RDRAND_RNG)
    list(APPEND ${CURRENT_TARGET}_RDRAND_RNG_HEADERS
        rng/rdrand_rng/rdrand_rng.h    
        )

    list(APPEND ${CURRENT_TARGET}_RDRAND_RNG_SOURCES
        rng/rdrand_rng/rdrand_rng.cpp
        )

    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_RDRAND_RNG_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_RDRAND_RNG_SOURCES}
        )
endif()

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

set_target_properties(botan_${CURRENT_TARGET} PROPERTIES LINKER_LANGUAGE CXX)

if(APPLE)
    set_target_properties(botan_${CURRENT_TARGET} PROPERTIES XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY ${APPLE_SIGN_IDENTITY})
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
    ${${CURRENT_TARGET}_LIBRARIES}
    botan::mac
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
    FILE
    ${CMAKE_BINARY_DIR}/lib/cmake/${CURRENT_TARGET}/${CURRENT_TARGET}_targets.cmake)

