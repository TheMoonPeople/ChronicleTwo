# Luau, the language the port runs the game's scripts in (docs/PORT_LUAU.md). The VM, compiler and native code
# generator are linked into the game; luau-analyze and luau-compile are built on request through ct_luau_tools.
include(FetchContent)
set(LUAU_BUILD_CLI ON CACHE BOOL "" FORCE)
set(LUAU_BUILD_TESTS OFF CACHE BOOL "" FORCE)
set(LUAU_BUILD_WEB OFF CACHE BOOL "" FORCE)
FetchContent_Declare(luau
    URL https://codeload.github.com/luau-lang/luau/tar.gz/refs/tags/0.740
    URL_HASH SHA256=419f96e4ecf5a0dd415a2625ea7ea9dc8a407e86d64b25e00936302b25a7afbd
    DOWNLOAD_EXTRACT_TIMESTAMP FALSE)
FetchContent_MakeAvailable(luau)
# Only what the game and the tools depend on is built.
set_property(DIRECTORY ${luau_SOURCE_DIR} PROPERTY EXCLUDE_FROM_ALL TRUE)
configure_file(${luau_SOURCE_DIR}/LICENSE.txt ${CMAKE_BINARY_DIR}/Luau-LICENSE.txt COPYONLY)
install(FILES ${CMAKE_BINARY_DIR}/Luau-LICENSE.txt DESTINATION ${CMAKE_INSTALL_DATADIR}/licenses/chronicletwo)

# ct_options is the interface ct_link_game hands to the game and to darkchronicle_tests.
target_link_libraries(ct_options INTERFACE Luau.VM Luau.Compiler)
if(NOT NINTENDO_SWITCH)
    target_link_libraries(ct_options INTERFACE Luau.CodeGen)
endif()

# Analysis calls std::abs without including <cstdlib>, which libc++ does not include for it.
target_compile_options(Luau.Analysis PRIVATE -include cstdlib)
if(NINTENDO_SWITCH)
    target_compile_options(Luau.VM PRIVATE -include climits)
endif()
add_custom_target(ct_luau_tools DEPENDS Luau.Analyze.CLI Luau.Compile.CLI)

# The native command tables for the kinds Luau runs, generated from the command catalog.
set(CT_LUAU_KINDS action effect monster event event_arg)
list(JOIN CT_LUAU_KINDS "," ct_luau_kinds)
set(CT_LUAU_BINDINGS ${CMAKE_BINARY_DIR}/generated/luau/luau_bindings.cpp)
add_custom_command(OUTPUT ${CT_LUAU_BINDINGS}
    COMMAND ${Python3_EXECUTABLE} ${CMAKE_SOURCE_DIR}/tools/luau/bindings.py
        ${CMAKE_SOURCE_DIR}/tools/luau/commands.json ${CT_LUAU_BINDINGS} --kinds ${ct_luau_kinds}
        --programs ${CMAKE_SOURCE_DIR}/tools/luau/programs.json
    DEPENDS ${CMAKE_SOURCE_DIR}/tools/luau/bindings.py ${CMAKE_SOURCE_DIR}/tools/luau/commands.json
        ${CMAKE_SOURCE_DIR}/tools/luau/programs.json
    COMMENT "Generating the Luau native command tables"
    VERBATIM)
target_sources(ct_port PRIVATE ${CT_LUAU_BINDINGS})

# One publisher copies changed sources across worker threads without a process per script.
# Declared byproducts restore deleted copies; an up-to-date build starts no publisher.
file(GLOB_RECURSE CT_LUAU_SOURCES CONFIGURE_DEPENDS ${CMAKE_SOURCE_DIR}/port/src/luau/*.luau)
list(FILTER CT_LUAU_SOURCES EXCLUDE REGEX "\\.d\\.luau$")
set(CT_LUAU_COPIES "")
set(CT_LUAU_RELATIVES "")
foreach(source IN LISTS CT_LUAU_SOURCES)
    file(RELATIVE_PATH relative ${CMAKE_SOURCE_DIR}/port/src/luau ${source})
    list(APPEND CT_LUAU_RELATIVES ${relative})
    set(copy ${CMAKE_BINARY_DIR}/scripts/${relative})
    list(APPEND CT_LUAU_COPIES ${copy})
endforeach()
# Preserve the expected-list timestamp when CMake regenerates for unrelated changes.
list(JOIN CT_LUAU_RELATIVES "\n" ct_luau_expected)
file(CONFIGURE OUTPUT ${CMAKE_BINARY_DIR}/generated/luau/scripts.txt CONTENT "${ct_luau_expected}\n" @ONLY)
set(ct_luau_stamp ${CMAKE_BINARY_DIR}/generated/luau/copied.stamp)
add_custom_command(OUTPUT ${ct_luau_stamp}
    BYPRODUCTS ${CT_LUAU_COPIES} ${CMAKE_BINARY_DIR}/generated/luau/copied.txt
    COMMAND ${Python3_EXECUTABLE} ${CMAKE_SOURCE_DIR}/tools/luau/sync.py
        --scripts ${CMAKE_BINARY_DIR}/scripts --sources ${CMAKE_SOURCE_DIR}/port/src/luau
        --expected ${CMAKE_BINARY_DIR}/generated/luau/scripts.txt
        --manifest ${CMAKE_BINARY_DIR}/generated/luau/copied.txt --stamp ${ct_luau_stamp}
    DEPENDS ${CT_LUAU_SOURCES} ${CMAKE_BINARY_DIR}/generated/luau/scripts.txt ${CMAKE_SOURCE_DIR}/tools/luau/sync.py
    COMMENT "Publishing changed Luau scripts"
    VERBATIM)

# CT_LUAU_PRECOMPILE also compiles each copy to bytecode, scripts/<module>.luauc, which the game loads instead of
# compiling the source when the module first runs (port/src/luau_bytecode.hpp). It is on for iOS, where the scripts run
# interpreted and the compile would land mid-game on the device. luau-precompile is built for the build machine from
# the same Luau sources, at CT_LUAU_PRECOMPILE_LEVEL (the game compiles at -O1; -O2 adds inlining and loop unrolling).
if(CMAKE_SYSTEM_NAME STREQUAL "iOS" OR NINTENDO_SWITCH)
    set(ct_luau_precompile_default ON)
else()
    set(ct_luau_precompile_default OFF)
endif()
option(CT_LUAU_PRECOMPILE "Ship the Luau scripts compiled to bytecode" ${ct_luau_precompile_default})
set(CT_LUAU_PRECOMPILE_LEVEL 2 CACHE STRING "The Luau optimisation level of precompiled scripts: 0, 1 or 2")
if(NOT CT_LUAU_PRECOMPILE_LEVEL MATCHES "^[012]$")
    message(FATAL_ERROR "CT_LUAU_PRECOMPILE_LEVEL must be 0, 1 or 2")
endif()
if(CT_LUAU_PRECOMPILE)
    if(NOT CMAKE_CROSSCOMPILING)
        # Native builds share the game's compiler library rather than building Luau.Compiler twice.
        add_executable(luau-precompile EXCLUDE_FROM_ALL ${CMAKE_SOURCE_DIR}/tools/luau/precompile/precompile.cpp)
        target_include_directories(luau-precompile PRIVATE ${CMAKE_SOURCE_DIR}/port/src)
        target_link_libraries(luau-precompile PRIVATE Luau.Compiler)
        set(ct_luau_precompiler $<TARGET_FILE:luau-precompile>)
        set(ct_luau_precompiler_target luau-precompile)
    else()
        include(ExternalProject)
        set(ct_luau_host_dir ${CMAKE_BINARY_DIR}/luau-host)
        set(ct_luau_precompiler ${ct_luau_host_dir}/luau-precompile)
        if(CMAKE_HOST_WIN32)
            string(APPEND ct_luau_precompiler .exe)
        endif()
        # The iOS build's environment names a deployment target, which would make the host compiler target iOS too.
        set(ct_luau_host_env ${CMAKE_COMMAND} -E env --unset=IPHONEOS_DEPLOYMENT_TARGET --unset=SDKROOT)
        include(ProcessorCount)
        ProcessorCount(ct_luau_host_jobs)
        if(DEFINED ENV{CMAKE_BUILD_PARALLEL_LEVEL} AND NOT "$ENV{CMAKE_BUILD_PARALLEL_LEVEL}" STREQUAL "")
            set(ct_luau_host_jobs "$ENV{CMAKE_BUILD_PARALLEL_LEVEL}")
        endif()
        if(NOT ct_luau_host_jobs MATCHES "^[1-9][0-9]*$")
            set(ct_luau_host_jobs 1)
        endif()
        ExternalProject_Add(ct_luau_host
            SOURCE_DIR ${CMAKE_SOURCE_DIR}/tools/luau/precompile
            BINARY_DIR ${ct_luau_host_dir}
            CONFIGURE_COMMAND ${ct_luau_host_env} ${CMAKE_COMMAND} -S <SOURCE_DIR> -B <BINARY_DIR> -G ${CMAKE_GENERATOR}
                -DCMAKE_BUILD_TYPE=Release -DLUAU_SOURCE_DIR=${luau_SOURCE_DIR} -DCT_PORT_SOURCE_DIR=${CMAKE_SOURCE_DIR}/port/src
                -DCMAKE_CXX_COMPILER_LAUNCHER=${CMAKE_CXX_COMPILER_LAUNCHER}
            BUILD_COMMAND ${ct_luau_host_env} ${CMAKE_COMMAND} --build <BINARY_DIR> --target luau-precompile --parallel ${ct_luau_host_jobs}
            INSTALL_COMMAND ""
            # The inner build decides what is out of date, and leaves the tool untouched when nothing is.
            BUILD_ALWAYS ON
            BUILD_BYPRODUCTS ${ct_luau_precompiler})
        set(ct_luau_precompiler_target ct_luau_host)
    endif()
    foreach(relative IN LISTS CT_LUAU_RELATIVES)
        set(compiled ${CMAKE_BINARY_DIR}/scripts/${relative}c)
        add_custom_command(OUTPUT ${compiled}
            COMMAND ${ct_luau_precompiler} -O${CT_LUAU_PRECOMPILE_LEVEL} ${CMAKE_BINARY_DIR}/scripts/${relative} ${compiled}
            DEPENDS ${CMAKE_BINARY_DIR}/scripts/${relative} ${ct_luau_precompiler} ${ct_luau_precompiler_target}
            COMMENT "Precompiling the script ${relative}"
            VERBATIM)
        list(APPEND CT_LUAU_COPIES ${compiled})
        get_filename_component(compiled_directory ${relative} DIRECTORY)
        install(FILES ${compiled} DESTINATION ${CMAKE_INSTALL_BINDIR}/scripts/${compiled_directory})
    endforeach()
endif()
add_custom_target(ct_luau_scripts DEPENDS ${ct_luau_stamp} ${CT_LUAU_COPIES} ${CMAKE_BINARY_DIR}/generated/luau/copied.txt)
add_dependencies(darkchronicle ct_luau_scripts)
install(DIRECTORY ${CMAKE_SOURCE_DIR}/port/src/luau/ DESTINATION ${CMAKE_INSTALL_BINDIR}/scripts
    FILES_MATCHING PATTERN "*.luau" PATTERN "*.d.luau" EXCLUDE)
# An install likewise removes the modules an earlier install put there whose sources are gone, recording what it
# installed in scripts/luau-installed.txt.
install(CODE "
    set(ct_luau_installed \"\$ENV{DESTDIR}\${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_BINDIR}/scripts\")
    execute_process(COMMAND \"${CMAKE_COMMAND}\" \"-DSCRIPTS=\${ct_luau_installed}\"
            \"-DSOURCES=${CMAKE_SOURCE_DIR}/port/src/luau\" \"-DEXPECTED=${CMAKE_BINARY_DIR}/generated/luau/scripts.txt\"
            \"-DMANIFEST=\${ct_luau_installed}/luau-installed.txt\" -P \"${CMAKE_SOURCE_DIR}/port/cmake/scripts/luau_prune.cmake\"
        RESULT_VARIABLE ct_luau_result)
    if(NOT ct_luau_result EQUAL 0)
        message(FATAL_ERROR \"Removing obsolete installed scripts failed: \${ct_luau_result}\")
    endif()
")
