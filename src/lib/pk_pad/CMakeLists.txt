cmake_minimum_required(VERSION 2.8.11)

cmake_policy(SET CMP0042 NEW)
cmake_policy(SET CMP0028 NEW)

set(CURRENT_TARGET pk_pad)

list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
    eme.h
    emsa.h
    )

list(APPEND ${CURRENT_TARGET}_UNGROUPED_SOURCES
    eme.cpp
    emsa.cpp
    )

option(BOTAN_PK_PAD_EME_OAEP "Build with EME OAEP support" TRUE)
option(BOTAN_PK_PAD_EME_OAEP "Build with EME PKCS1 support" TRUE)
option(BOTAN_PK_PAD_EME_OAEP "Build with EME RAW support" TRUE)
option(BOTAN_PK_PAD_EME_OAEP "Build with EMSA1 support" TRUE)
option(BOTAN_PK_PAD_EME_OAEP "Build with EMSA PKCS1 OAEP support" TRUE)
option(BOTAN_PK_PAD_EME_OAEP "Build with EMSA PSSR support" TRUE)
option(BOTAN_PK_PAD_EME_OAEP "Build with EMSA RAW support" TRUE)
option(BOTAN_PK_PAD_EME_OAEP "Build with EMSA x931 support" TRUE)

if (BOTAN_PK_PAD_EME_OAEP)
    list(APPEND ${CURRENT_TARGET}_EME_OAEP_HEADERS
        eme_oaep/oaep.h    
        )

    list(APPEND ${CURRENT_TARGET}_EME_OAEP_SOURCES
        eme_oaep/oaep.cpp
        )

    if (NOT TARGET botan::mgf1)
        add_subdirectory(mgf1)
    endif()

    list(APPEND ${CURRENT_TARGET}_LIBRARIES
        botan::mgf1
        )

    add_definitions(-DBOTAN_HAS_EME_OAEP)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_EME_OAEP_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_EME_OAEP_SOURCES}
        )
endif()

if (BOTAN_PK_PAD_EME_PKCS)
    list(APPEND ${CURRENT_TARGET}_EME_PKCS_HEADERS
        eme_pkcs/eme_pkcs.h    
        )

    list(APPEND ${CURRENT_TARGET}_EME_PKCS_SOURCES
        eme_pkcs/eme_pkcs.cpp
        )

    add_definitions(-DBOTAN_HAS_EME_PKCS)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_EME_PKCS_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_EME_PKCS_SOURCES}
        )
endif()

if (BOTAN_PK_PAD_EME_RAW)
    list(APPEND ${CURRENT_TARGET}_EME_RAW_HEADERS
        eme_raw/eme_raw.h    
        )

    list(APPEND ${CURRENT_TARGET}_EME_RAW_SOURCES
        eme_raw/eme_raw.cpp
        )

    add_definitions(-DBOTAN_HAS_EME_RAW)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_EME_RAW_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_EME_RAW_SOURCES}
        )
endif()

if (BOTAN_PK_PAD_EMSA1)
    list(APPEND ${CURRENT_TARGET}_EMSA1_HEADERS
        emsa1/emsa1.h    
        )

    list(APPEND ${CURRENT_TARGET}_EMSA1_SOURCES
        emsa1/emsa1.cpp
        )

    add_definitions(-DBOTAN_HAS_EMSA1)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_EMSA1_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_EMSA1_SOURCES}
        )
endif()

if (BOTAN_PK_PAD_EMSA_PKCS1)
    list(APPEND ${CURRENT_TARGET}_EMSA_PKCS1_HEADERS
        emsa_pkcs1/emsa_pkcs1.h
        )

    list(APPEND ${CURRENT_TARGET}_EMSA_PKCS1_SOURCES
        emsa_pkcs1/emsa_pkcs1.cpp        
        )

    if (NOT TARGET botan::hash_id)
        add_subdirectory(hash_id)
    endif()

    list(APPEND ${CURRENT_TARGET}_LIBRARIES
        botan::hash_id
        )

    add_definitions(-DBOTAN_HAS_EMSA_PKCS1)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_EMSA_PKCS1_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_EMSA_PKCS1_SOURCES}
        )
endif()

if (BOTAN_PK_PAD_EMSA_PSSR)
    list(APPEND ${CURRENT_TARGET}_EMSA_PSSR_HEADERS
        emsa_pssr/pssr.h    
        )

    list(APPEND ${CURRENT_TARGET}_EMSA_PSSR_SOURCES
        emsa_pssr/pssr.cpp
        )

    if (NOT TARGET botan::mgf1)
        add_subdirectory(mgf1)
    endif()

    list(APPEND ${CURRENT_TARGET}_LIBRARIES
        botan::mgf1
        )


    add_definitions(-DBOTAN_HAS_EMSA_PSSR)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_EMSA_PSSR_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_EMSA_PSSR_SOURCES}
        )
endif()

if (BOTAN_PK_PAD_EMSA_RAW)
    list(APPEND ${CURRENT_TARGET}_EMSA_RAW_HEADERS
        emsa_raw/emsa_raw.h    
        )

    list(APPEND ${CURRENT_TARGET}_EMSA_RAW_SOURCES
        emsa_raw/emsa_raw.cpp
        )

    add_definitions(-DBOTAN_HAS_EMSA_RAW)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_EMSA_RAW_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_EMSA_RAW_SOURCES}
        )
endif()

if (BOTAN_PK_PAD_EMSA_X931)
    list(APPEND ${CURRENT_TARGET}_EMSA_X931_HEADERS
        emsa_x931/emsa_x931.h    
        )

    list(APPEND ${CURRENT_TARGET}_EMSA_X931_SOURCES
        emsa_x931/emsa_x931.cpp
        )

    add_definitions(-DBOTAN_HAS_EMSA_X931)
    list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
        ${${CURRENT_TARGET}_EMSA_X931_HEADERS}
        )
    list(APPEND ${CURRENT_TARGET}_SOURCES
        ${${CURRENT_TARGET}_EMSA_X931_SOURCES}
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
    botan
    botan::mgf1
    botan::utils
    botan::entropy_rng
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
