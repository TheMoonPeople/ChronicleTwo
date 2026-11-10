# Crash reports (docs/CRASH_REPORTS.md): cpptrace symbolises the crashing thread's stack in-process from
# the DWARF line tables every build carries, through libdwarf (and dbghelp on Windows).
# A system libdwarf is used when one is found; otherwise cpptrace builds the pinned libdwarf-lite below
# (the Flatpak passes its source as FETCHCONTENT_SOURCE_DIR_LIBDWARF). The game never compresses its debug sections, so zstd and zlib stay out.
include(FetchContent)

find_package(libdwarf CONFIG QUIET)
if(libdwarf_FOUND)
    set(CPPTRACE_USE_EXTERNAL_LIBDWARF ON CACHE BOOL "" FORCE)
else()
    set(CPPTRACE_USE_EXTERNAL_LIBDWARF OFF CACHE BOOL "" FORCE)
    # Declared first, so cpptrace's own git declaration of the same commit is ignored.
    FetchContent_Declare(libdwarf
        URL https://github.com/jeremy-rifkin/libdwarf-lite/archive/5dfb2cd2aacf2bf473e5bfea79e41289f88b3a5f.tar.gz
        URL_HASH SHA256=ba0f0325e671e5010acbff4a897cedfe29c7f71202a905ca4b10085cbb839e51
        DOWNLOAD_EXTRACT_TIMESTAMP FALSE)
    set(ENABLE_DECOMPRESSION OFF CACHE BOOL "" FORCE)
endif()
set(CPPTRACE_USE_EXTERNAL_ZSTD ON CACHE BOOL "" FORCE)
set(CMAKE_DISABLE_FIND_PACKAGE_zstd ON)
set(CPPTRACE_DISABLE_CXX_20_MODULES ON CACHE BOOL "" FORCE)
set(CPPTRACE_BUILD_SHARED OFF CACHE BOOL "" FORCE)
FetchContent_Declare(cpptrace
    URL https://github.com/jeremy-rifkin/cpptrace/archive/refs/tags/v1.0.4.tar.gz
    URL_HASH SHA256=5c9f5b301e903714a4d01f1057b9543fa540f7bfcc5e3f8bd1748e652e24f9ea
    DOWNLOAD_EXTRACT_TIMESTAMP FALSE
    FIND_PACKAGE_ARGS 1.0.4 EXACT CONFIG)
FetchContent_MakeAvailable(cpptrace)

target_link_libraries(ct_options INTERFACE cpptrace::cpptrace)
if(WIN32)
    target_link_libraries(ct_options INTERFACE dbghelp)
endif()

# The report header names the configuration a crashing build was made with.
set_property(SOURCE ${PORT_DIR}/crash/crash_report.cpp APPEND PROPERTY COMPILE_DEFINITIONS
    "CT_CRASH_BUILD_TYPE=\"$<CONFIG>\"")
