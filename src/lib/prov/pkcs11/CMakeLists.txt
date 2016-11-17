cmake_minimum_required(VERSION 2.8.11)

cmake_policy(SET CMP0042 NEW)
cmake_policy(SET CMP0028 NEW)

set(CURRENT_TARGET pkcs11)

list(APPEND ${CURRENT_TARGET}_PUBLIC_HEADERS
    p11.h
    p11_ecc_key.h
    p11_ecdh.h
    p11_ecdsa.h
    p11_module.h
    p11_object.h
    p11_randomgenerator.h
    p11_rsa.h
    p11_session.h
    p11_slot.h
    p11_x509.h
    )

list(APPEND ${CURRENT_TARGET}_EXTERNAL_HEADERS
    pkcs11.h
    pkcs11f.h
    pkcs11t.h
    )

list(APPEND ${CURRENT_TARGET}_INTERNAL_HEADERS
    p11_mechanism.h
    )

list(APPEND ${CURRENT_TARGET}_UNGROUPED_SOURCES
    p11.cpp
    p11_ecc_key.cpp
    p11_ecdh.cpp
    p11_ecdsa.cpp
    p11_mechanism.cpp
    p11_module.cpp
    p11_object.cpp
    p11_randomgenerator.cpp
    p11_rsa.cpp
    p11_session.cpp
    p11_slot.cpp
    p11_x509.cpp
    )

list(APPEND ${CURRENT_TARGET}_HEADERS
    ${${CURRENT_TARGET}_PUBLIC_HEADERS}
    ${${CURRENT_TARGET}_INTERNAL_HEADERS}
    ${${CURRENT_TARGET}_EXTERNAL_HEADERS}
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
    botan::dyn_load
    botan::entropy_rng
    botan::pk_pad
    botan::utils
    )

add_library(botan::${CURRENT_TARGET} ALIAS botan_${CURRENT_TARGET})
set_property(TARGET botan_${CURRENT_TARGET} PROPERTY EXPORT_NAME ${CURRENT_TARGET})

install(FILES ${${CURRENT_TARGET}_PUBLIC_HEADERS} DESTINATION ${CMAKE_BINARY_DIR}/include/botan)

install(FILES ${${CURRENT_TARGET}_INTERNAL_HEADERS} DESTINATION ${CMAKE_BINARY_DIR}/include/botan/internal)

install(FILES ${${CURRENT_TARGET}_EXTERNAL_HEADERS} DESTINATION
    ${CMAKE_BINARY_DIR}/include/botan)

foreach(ITERATOR ${${CURRENT_TARGET}_PUBLIC_HEADERS})
    file(COPY ${ITERATOR} DESTINATION ${CMAKE_BINARY_DIR}/include/botan)
endforeach()

foreach(ITERATOR ${${CURRENT_TARGET}_INTERNAL_HEADERS})
    file(COPY ${ITERATOR} DESTINATION ${CMAKE_BINARY_DIR}/include/botan/internal)
endforeach()

foreach(ITERATOR ${${CURRENT_TARGET}_EXTERNAL_HEADERS})
    file(COPY ${ITERATOR} DESTINATION ${CMAKE_BINARY_DIR}/include/botan)
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
