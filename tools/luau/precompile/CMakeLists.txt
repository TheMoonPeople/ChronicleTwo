# luau-precompile, built for the build machine by port/cmake/luau.cmake when CT_LUAU_PRECOMPILE is on. It compiles
# with the Luau sources the game itself links, whose directory LUAU_SOURCE_DIR names, so the bytecode is the version
# the game's VM reads.
cmake_minimum_required(VERSION 3.25)
project(LuauPrecompile C CXX)

if(NOT IS_DIRECTORY "${LUAU_SOURCE_DIR}" OR NOT IS_DIRECTORY "${CT_PORT_SOURCE_DIR}")
    message(FATAL_ERROR "luau-precompile needs -DLUAU_SOURCE_DIR=<Luau sources> -DCT_PORT_SOURCE_DIR=<port/src>")
endif()

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

set(LUAU_BUILD_CLI OFF CACHE BOOL "" FORCE)
set(LUAU_BUILD_TESTS OFF CACHE BOOL "" FORCE)
set(LUAU_BUILD_WEB OFF CACHE BOOL "" FORCE)
add_subdirectory(${LUAU_SOURCE_DIR} luau EXCLUDE_FROM_ALL)

add_executable(luau-precompile precompile.cpp)
target_include_directories(luau-precompile PRIVATE ${CT_PORT_SOURCE_DIR})
target_link_libraries(luau-precompile PRIVATE Luau.Compiler)
