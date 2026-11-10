# Command-line tools for the Luau script tests: luau-harness runs a driver script
# against the port's Luau runtime, and luau-check strictly type-checks scripts with
# declaration files loaded.
cmake_minimum_required(VERSION 3.25)
project(LuauHarness CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

include(FetchContent)
set(LUAU_BUILD_CLI OFF CACHE BOOL "" FORCE)
set(LUAU_BUILD_TESTS OFF CACHE BOOL "" FORCE)
set(LUAU_BUILD_WEB OFF CACHE BOOL "" FORCE)
FetchContent_Declare(luau
    URL https://codeload.github.com/luau-lang/luau/tar.gz/refs/tags/0.740
    URL_HASH SHA256=419f96e4ecf5a0dd415a2625ea7ea9dc8a407e86d64b25e00936302b25a7afbd
    DOWNLOAD_EXTRACT_TIMESTAMP TRUE)
FetchContent_MakeAvailable(luau)
set_property(DIRECTORY ${luau_SOURCE_DIR} PROPERTY EXCLUDE_FROM_ALL TRUE)

add_executable(luau-harness host.cpp)
target_link_libraries(luau-harness PRIVATE Luau.VM Luau.Compiler)

add_executable(luau-check check.cpp)
target_link_libraries(luau-check PRIVATE Luau.Analysis Luau.Config Luau.CLI.lib)

if(MINGW)
    target_link_options(luau-harness PRIVATE -static)
    target_link_options(luau-check PRIVATE -static)
endif()

# Luau 0.740's Analysis relies on std::abs without including <cstdlib>, which libc++ does not provide transitively.
target_compile_options(Luau.Analysis PRIVATE "SHELL:-include cstdlib")
