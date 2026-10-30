# dc2data is a thin CLI over the Rust extractor and converter.
include(${CMAKE_CURRENT_SOURCE_DIR}/../kazarov/cmake/KazarovRust.cmake)

add_executable(dc2data ${CMAKE_CURRENT_SOURCE_DIR}/main.cpp)
install(TARGETS dc2data RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
target_link_libraries(dc2data PRIVATE kazarov_bridge kazarov_core)
set_target_properties(dc2data PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}
    CXX_STANDARD 26 CXX_STANDARD_REQUIRED ON)
target_compile_options(dc2data PRIVATE -Weverything)

if(CT_BUILD_TESTS)
    add_executable(dc2data_bridge_test ${CMAKE_CURRENT_SOURCE_DIR}/bridge_test.cpp)
    target_link_libraries(dc2data_bridge_test PRIVATE kazarov_bridge kazarov_core)
    target_compile_options(dc2data_bridge_test PRIVATE -Weverything)
    set_target_properties(dc2data_bridge_test PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}
        CXX_STANDARD 26 CXX_STANDARD_REQUIRED ON)
    add_test(NAME dc2data_bridge COMMAND dc2data_bridge_test)
endif()

if(WIN32)
    # Rust archive/PNG conversion can have deep call paths; the MinGW default is 1 MiB.
    # Heap-backed I/O buffers remain necessary, but allow ordinary converter frames headroom.
    target_link_options(dc2data PRIVATE -municode -Wl,--stack,16777216)
    if(TARGET dc2data_bridge_test)
        target_link_options(dc2data_bridge_test PRIVATE -Wl,--stack,16777216)
    endif()
endif()
