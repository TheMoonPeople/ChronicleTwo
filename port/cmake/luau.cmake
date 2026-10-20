# Luau, the language the port runs the game's scripts in (docs/PORT_LUAU.md). The VM, compiler and native code
# generator are linked into the game; luau-analyze and luau-compile are built on request through ct_luau_tools.
include(FetchContent)
set(LUAU_BUILD_CLI ON CACHE BOOL "" FORCE)
set(LUAU_BUILD_TESTS OFF CACHE BOOL "" FORCE)
set(LUAU_BUILD_WEB OFF CACHE BOOL "" FORCE)
FetchContent_Declare(luau
    URL https://codeload.github.com/luau-lang/luau/tar.gz/refs/tags/0.740
    URL_HASH SHA256=419f96e4ecf5a0dd415a2625ea7ea9dc8a407e86d64b25e00936302b25a7afbd
    DOWNLOAD_EXTRACT_TIMESTAMP TRUE)
FetchContent_MakeAvailable(luau)
# Only what the game and the tools depend on is built.
set_property(DIRECTORY ${luau_SOURCE_DIR} PROPERTY EXCLUDE_FROM_ALL TRUE)
configure_file(${luau_SOURCE_DIR}/LICENSE.txt ${CMAKE_BINARY_DIR}/Luau-LICENSE.txt COPYONLY)
install(FILES ${CMAKE_BINARY_DIR}/Luau-LICENSE.txt DESTINATION ${CMAKE_INSTALL_DATADIR}/licenses/chronicletwo)

# ct_options is the interface ct_link_game hands to the game and to darkchronicle_tests.
target_link_libraries(ct_options INTERFACE Luau.VM Luau.Compiler Luau.CodeGen)

# Analysis calls std::abs without including <cstdlib>, which libc++ does not include for it.
target_compile_options(Luau.Analysis PRIVATE -include cstdlib)
add_custom_target(ct_luau_tools DEPENDS Luau.Analyze.CLI Luau.Compile.CLI)

# The native command tables for the kinds Luau runs, generated from the command catalog.
set(CT_LUAU_KINDS action effect monster)
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

# The scripts' Luau sources (port/src/luau), copied to scripts/ beside the executable. Each copy is a declared
# output, so an up-to-date build runs nothing and a deleted copy is restored.
file(GLOB_RECURSE CT_LUAU_SOURCES CONFIGURE_DEPENDS ${CMAKE_SOURCE_DIR}/port/src/luau/*.luau)
list(FILTER CT_LUAU_SOURCES EXCLUDE REGEX "\\.d\\.luau$")
set(CT_LUAU_COPIES "")
foreach(source IN LISTS CT_LUAU_SOURCES)
    file(RELATIVE_PATH relative ${CMAKE_SOURCE_DIR}/port/src/luau ${source})
    set(copy ${CMAKE_BINARY_DIR}/scripts/${relative})
    add_custom_command(OUTPUT ${copy}
        COMMAND ${CMAKE_COMMAND} -E copy ${source} ${copy}
        DEPENDS ${source}
        COMMENT "Copying the script ${relative}"
        VERBATIM)
    list(APPEND CT_LUAU_COPIES ${copy})
endforeach()
add_custom_target(ct_luau_scripts DEPENDS ${CT_LUAU_COPIES})
add_dependencies(darkchronicle ct_luau_scripts)
install(DIRECTORY ${CMAKE_SOURCE_DIR}/port/src/luau/ DESTINATION ${CMAKE_INSTALL_BINDIR}/scripts
    FILES_MATCHING PATTERN "*.luau" PATTERN "*.d.luau" EXCLUDE)
