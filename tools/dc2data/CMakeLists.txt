# dc2data is a thin CLI over the Rust extractor and converter.
include(${CMAKE_CURRENT_SOURCE_DIR}/../kazarov/cmake/KazarovRust.cmake)

# Direct CMake builds and scripted builds must resolve crates from the same registry paths.
set(CT_WINDOWS_CARGO_HOME "" CACHE PATH "Cargo registry/cache for native Windows builds")
if(WIN32 AND CT_WINDOWS_CARGO_HOME)
    corrosion_set_env_vars(kazarov_core "CARGO_HOME=${CT_WINDOWS_CARGO_HOME}")
endif()

# Corrosion 0.6.1 supports choosing the imported archive's output directory. Reuse Cargo's
# single-config artifact directly, avoiding a full archive comparison after every freshness check.
get_target_property(ct_cargo_profile kazarov_core INTERFACE_CORROSION_CARGO_PROFILE)
if(WIN32 AND CMAKE_GENERATOR STREQUAL "Ninja" AND NOT ct_cargo_profile)
    get_filename_component(ct_workspace ${KZ_RUST_MANIFEST} DIRECTORY)
    get_filename_component(ct_workspace ${ct_workspace} NAME)
    string(SHA1 ct_workspace_hash "${KZ_RUST_MANIFEST}")
    string(SUBSTRING "${ct_workspace_hash}" 0 5 ct_workspace_hash)
    set(ct_cargo_profile release)
    if(NOT CMAKE_BUILD_TYPE OR CMAKE_BUILD_TYPE STREQUAL "Debug")
        set(ct_cargo_profile debug)
    endif()
    set_property(TARGET kazarov_core PROPERTY ARCHIVE_OUTPUT_DIRECTORY
        "${CMAKE_BINARY_DIR}/cargo/${ct_workspace}_${ct_workspace_hash}/${Rust_CARGO_TARGET}/${ct_cargo_profile}")
endif()

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
    include(${CMAKE_CURRENT_SOURCE_DIR}/../kazarov/cmake/KazarovWindowsRuntime.cmake)
    kz_windows_runtime_post_build(dc2data)
    if(TARGET dc2data_bridge_test)
        kz_windows_runtime_post_build(dc2data_bridge_test)
    endif()
    # Rust archive/PNG conversion can have deep call paths; the MinGW default is 1 MiB.
    # Heap-backed I/O buffers remain necessary, but allow ordinary converter frames headroom.
    target_link_options(dc2data PRIVATE -municode -Wl,--stack,16777216)
    if(TARGET dc2data_bridge_test)
        target_link_options(dc2data_bridge_test PRIVATE -Wl,--stack,16777216)
    endif()
endif()
