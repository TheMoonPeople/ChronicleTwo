cmake_minimum_required(VERSION 3.22)
project(chronicletwo NONE)

# PLATFORM picks what is built: PS2 builds and verifies the retail executable
# (ps2/CMakeLists.txt), PC builds the x64 port (port/CMakeLists.txt).
set(PLATFORM PS2 CACHE STRING "Platform to build: PS2, PC or SWITCH")
set_property(CACHE PLATFORM PROPERTY STRINGS PS2 PC SWITCH)
if(PLATFORM STREQUAL "PS2")
    add_subdirectory(ps2)
elseif(PLATFORM STREQUAL "PC" OR PLATFORM STREQUAL "SWITCH")
    if(PLATFORM STREQUAL "SWITCH")
        # The Switch wrapper configures before every build; avoid a second full script-directory scan.
        set(CMAKE_SUPPRESS_REGENERATION ON)
    endif()
    # Here rather than in port so ctest finds the tests from the top of the build tree.
    enable_testing()
    add_subdirectory(port)
else()
    message(FATAL_ERROR "PLATFORM must be PS2, PC or SWITCH, not ${PLATFORM}")
endif()
