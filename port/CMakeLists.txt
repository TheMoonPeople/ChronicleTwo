# The x64 port: the game's code built with clang as C++26 for the host.
#
# ps2/src holds the game's code as the PS2 build compiles it. A definition port/src tags PORT_OVERRIDE
# replaces the one ps2/src gives the same name: each unit of ps2/src is compiled without those
# definitions (tools/kazarov/scripts/build/port_override.py) and linked with port/src. That is how the PS2-only
# parts are replaced: the SDK, the Metrowerks runtime, the functions that touch the hardware and the
# functions written in assembly.

if(NOT CMAKE_CXX_COMPILER)
    set(CMAKE_CXX_COMPILER clang++)
endif()
enable_language(CXX)

set(CMAKE_CXX_STANDARD 26)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

set(KZ_ROOT ${CMAKE_SOURCE_DIR}/tools/kazarov)
if(NOT EXISTS ${KZ_ROOT}/include/kazarov/port.h)
    message(FATAL_ERROR "${KZ_ROOT} is empty: run git submodule update --init tools/kazarov")
endif()

# One version source is shared by the publisher and native runtime.
file(READ ${KZ_ROOT}/data_version.json KZ_DATA_VERSION_JSON)
string(JSON KZ_DATA_SCHEMA_VERSION GET "${KZ_DATA_VERSION_JSON}" schema_version)
string(JSON KZ_DATA_VERSION GET "${KZ_DATA_VERSION_JSON}" data_version)
if(NOT KZ_DATA_SCHEMA_VERSION EQUAL 1)
    message(FATAL_ERROR "Unsupported tools/kazarov/data_version.json schema")
endif()
file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/generated/include/kazarov)
configure_file(${KZ_ROOT}/include/kazarov/data_version.hpp.in
    ${CMAKE_BINARY_DIR}/generated/include/kazarov/data_version.hpp @ONLY)

# port/icon/chronicletwo-128.rgba, the two moons' raw 128x128 RGBA pixels: the window icon until the game data
# is there to draw Max's wrench from (main.cpp).
set(ICON_RGBA ${CMAKE_SOURCE_DIR}/port/icon/chronicletwo-128.rgba)
set_property(DIRECTORY APPEND PROPERTY CMAKE_CONFIGURE_DEPENDS ${ICON_RGBA})
file(READ ${ICON_RGBA} icon_hex HEX)
string(REGEX REPLACE "(..)" "0x\\1," icon_bytes "${icon_hex}")
file(CONFIGURE OUTPUT ${CMAKE_BINARY_DIR}/generated/include/icon/chronicletwo.hpp
    CONTENT "#pragma once\n#include <cstdint>\ninline constexpr int kIconSize = 128;\ninline constexpr std::uint8_t kIconRgba[] = {${icon_bytes}};\n")

include(${KZ_ROOT}/cmake/KazarovPort.cmake)

# Retail textures are converted offline; the native executable only loads PNG assets.
set(KZ_PORT_BUILD_TIM2 OFF CACHE BOOL "Build legacy TIM2 decoding into the native runtime" FORCE)

find_package(Python3 REQUIRED COMPONENTS Interpreter)
kz_port_host_library(ct_host)

# ps2/include is compiled through a mirror in the build tree with the fixups of scripts/port/header_fixups.py
# applied. The mirror is written only where its content changes, so an unchanged header keeps its timestamp.
set(PS2_INCLUDE_SRC ${CMAKE_SOURCE_DIR}/ps2/include)
set(PS2_INCLUDE_DIR ${CMAKE_BINARY_DIR}/ps2_include)
set(PS2_INCLUDE_STAMP ${CMAKE_BINARY_DIR}/ps2_include.stamp)
set(HEADER_FIXUPS_SCRIPT ${CMAKE_SOURCE_DIR}/scripts/port/header_fixups.py)
# The PS2's long is 64-bit and Windows' (LLP64) is not, so game sources and headers are rewritten to long long
# on every host, keeping the types identical everywhere.
set(LONG64_SCRIPT ${CMAKE_SOURCE_DIR}/scripts/port/long64.py)
file(GLOB_RECURSE PS2_INCLUDE_FILES CONFIGURE_DEPENDS LIST_DIRECTORIES false ${PS2_INCLUDE_SRC}/*)
set(PS2_INCLUDE_MIRROR "")
foreach(ps2_header IN LISTS PS2_INCLUDE_FILES)
    file(RELATIVE_PATH ps2_header_rel ${PS2_INCLUDE_SRC} ${ps2_header})
    list(APPEND PS2_INCLUDE_MIRROR ${PS2_INCLUDE_DIR}/${ps2_header_rel})
endforeach()
execute_process(COMMAND ${Python3_EXECUTABLE} ${HEADER_FIXUPS_SCRIPT} ${PS2_INCLUDE_SRC} ${PS2_INCLUDE_DIR} ${PS2_INCLUDE_STAMP}
    RESULT_VARIABLE header_fixups_result
    OUTPUT_VARIABLE header_fixups_output
    ERROR_VARIABLE header_fixups_error)
if(NOT header_fixups_result EQUAL 0)
    message(FATAL_ERROR "header_fixups.py failed (${header_fixups_result}):\n${header_fixups_output}${header_fixups_error}")
endif()
# Objects find these headers through their depfiles. Undeclared, ninja judges the objects before the mirror is
# refreshed, so an edited ps2/include header reaches its dependents only on the second build.
add_custom_command(OUTPUT ${PS2_INCLUDE_STAMP}
    COMMAND ${Python3_EXECUTABLE} ${HEADER_FIXUPS_SCRIPT} ${PS2_INCLUDE_SRC} ${PS2_INCLUDE_DIR} ${PS2_INCLUDE_STAMP}
    DEPENDS ${PS2_INCLUDE_FILES} ${HEADER_FIXUPS_SCRIPT} ${LONG64_SCRIPT}
    BYPRODUCTS ${PS2_INCLUDE_MIRROR}
    COMMENT "Mirroring ps2/include with the header fixups"
    VERBATIM)
add_custom_target(ps2_include DEPENDS ${PS2_INCLUDE_STAMP})

set(PS2_DIR ${CMAKE_SOURCE_DIR}/ps2/src)
set(PORT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/src)
file(GLOB_RECURSE PS2_SOURCES CONFIGURE_DEPENDS RELATIVE ${PS2_DIR} ${PS2_DIR}/*.cpp)
file(GLOB_RECURSE PORT_SOURCES CONFIGURE_DEPENDS ${PORT_DIR}/*.cpp)
list(FILTER PORT_SOURCES EXCLUDE REGEX "/tests/")
# Scratch files left beside a unit are not units.
list(FILTER PS2_SOURCES EXCLUDE REGEX "(^|/)tmp[^/]*$")

set(PS2_UNITS "")
# C2 ships only the PAL release, so PAL is the one region the port is built for.
set(PORT_DEFINITIONS PORT PAL)
list(TRANSFORM PORT_DEFINITIONS PREPEND --define= OUTPUT_VARIABLE port_override_defines)
# ps2/src spells the 64-bit long that long64.py turns into the long long port/src has to spell.
list(APPEND port_override_defines --long-is-64)
# The names port/src's PORT_OVERRIDE definitions link under. PORT_OVERRIDE_SOURCES is written only when
# its content changes, and a unit or stub header appearing or vanishing changes no timestamp, so it is a
# dependency of its own.
set(PORT_OVERRIDE_SCRIPT ${KZ_ROOT}/scripts/build/port_override.py)
set(UNIT_COPY_SCRIPT ${CMAKE_SOURCE_DIR}/scripts/port/unit_copy.py)
set(PORT_OVERRIDES ${CMAKE_BINARY_DIR}/port_overrides.txt)
set(PORT_OVERRIDE_SOURCES ${CMAKE_BINARY_DIR}/port_override_sources.txt)
file(GLOB_RECURSE PORT_OVERRIDE_STUBS CONFIGURE_DEPENDS ${CMAKE_SOURCE_DIR}/port/include/stubs/*.hpp)
string(JOIN "\n" port_override_sources ${PORT_SOURCES} ${PS2_SOURCES} ${PORT_OVERRIDE_STUBS})
file(CONFIGURE OUTPUT ${PORT_OVERRIDE_SOURCES} CONTENT "${port_override_sources}\n" @ONLY)
add_custom_command(OUTPUT ${PORT_OVERRIDES}
    COMMAND ${Python3_EXECUTABLE} ${PORT_OVERRIDE_SCRIPT} list ${PORT_DIR} -o ${PORT_OVERRIDES}
    DEPENDS ${PORT_SOURCES} ${PORT_OVERRIDE_SOURCES} ${PORT_OVERRIDE_SCRIPT}
    COMMENT "Listing port/src's PORT_OVERRIDE definitions"
    VERBATIM)
# port/include/stubs/<unit>.hpp, when it exists, is included ahead of its unit: it declares what the port
# defines in place of code PORT leaves out, and renames what the unit takes from MWCC alone.
# The check writes each unit's own overrides entries to a split file. A unit depends only on that file, so a
# PORT_OVERRIDE edit recopies the units it reaches, not all 149. One process per unit: start-up dominates the copy.
set(PORT_OVERRIDE_SPLITS "")
foreach(unit IN LISTS PS2_SOURCES)
    set(copy ${CMAKE_BINARY_DIR}/ps2_src/${unit})
    set(split ${CMAKE_BINARY_DIR}/port_overrides/${unit}.txt)
    list(APPEND PORT_OVERRIDE_SPLITS ${split})
    string(REGEX REPLACE "\\.cpp$" ".hpp" header ${CMAKE_SOURCE_DIR}/port/include/stubs/${unit})
    if(EXISTS ${header})
        set(stubs --stubs ${header})
    else()
        set(stubs "")
        set(header "")
    endif()
    set(native_bridge "")
    if(unit STREQUAL "character.cpp")
        set(native_bridge ${CMAKE_CURRENT_SOURCE_DIR}/src/character_metadata_bridge.inc)
    elseif(unit STREQUAL "npccfg.cpp")
        set(native_bridge ${CMAKE_CURRENT_SOURCE_DIR}/src/npccfg_config_bridge.inc)
    elseif(unit STREQUAL "vlgr_info.cpp")
        set(native_bridge ${CMAKE_CURRENT_SOURCE_DIR}/src/vlgr_info_config_bridge.inc)
    elseif(unit STREQUAL "movieviewlp.cpp")
        set(native_bridge ${CMAKE_CURRENT_SOURCE_DIR}/src/movieviewlp_config_bridge.inc)
    elseif(unit STREQUAL "editdebug.cpp")
        set(native_bridge ${CMAKE_CURRENT_SOURCE_DIR}/src/editdebug_config_bridge.inc)
    elseif(unit STREQUAL "menuchr.cpp")
        set(native_bridge ${CMAKE_CURRENT_SOURCE_DIR}/src/menu_character_assets.hpp)
    endif()
    add_custom_command(OUTPUT ${copy}
        COMMAND ${Python3_EXECUTABLE} ${UNIT_COPY_SCRIPT} --port-override ${PORT_OVERRIDE_SCRIPT} --overrides ${split}
            ${stubs} ${port_override_defines} ${PS2_DIR}/${unit} ${copy}
        DEPENDS ${PS2_DIR}/${unit} ${split} ${PORT_OVERRIDE_SCRIPT} ${UNIT_COPY_SCRIPT} ${LONG64_SCRIPT} ${HEADER_FIXUPS_SCRIPT} ${CMAKE_SOURCE_DIR}/scripts/port/native_asset_paths.py ${header} ${native_bridge}
        COMMENT "Removing overridden definitions from ps2/src/${unit}"
        VERBATIM)
    list(APPEND PS2_UNITS ${copy})
    list(APPEND PS2_ORIGINALS ${PS2_DIR}/${unit} ${header})
    if(header)
        set_property(SOURCE ${copy} APPEND PROPERTY COMPILE_OPTIONS -include ${header})
        set_property(SOURCE ${copy} APPEND PROPERTY OBJECT_DEPENDS ${header})
    endif()
endforeach()
# A tag that names no definition in ps2/src stops the build: its replacement would be unused wherever
# the two signatures differ.
set(PORT_OVERRIDES_CHECKED ${CMAKE_BINARY_DIR}/port_overrides.checked)
set(PORT_OVERRIDE_CACHE ${CMAKE_BINARY_DIR}/port_overrides.cache.json)
add_custom_command(OUTPUT ${PORT_OVERRIDES_CHECKED}
    COMMAND ${Python3_EXECUTABLE} ${PORT_OVERRIDE_SCRIPT} check --overrides ${PORT_OVERRIDES}
        --private-functions --private-function-unit event_func.cpp --private-function-unit editdebug.cpp
        --stubs ${CMAKE_SOURCE_DIR}/port/include/stubs ${port_override_defines} ${PS2_DIR}
        --split ${CMAKE_BINARY_DIR}/port_overrides --cache ${PORT_OVERRIDE_CACHE}
        -o ${PORT_OVERRIDES_CHECKED}
    DEPENDS ${PS2_ORIGINALS} ${PORT_OVERRIDES} ${PORT_OVERRIDE_SOURCES} ${PORT_OVERRIDE_SCRIPT}
    BYPRODUCTS ${PORT_OVERRIDE_SPLITS} ${PORT_OVERRIDE_CACHE}
    COMMENT "Checking that every PORT_OVERRIDE definition replaces one of ps2/src's"
    VERBATIM)

# The game was written for MWCC, which accepts what clang rejects by default: pointers truncated to
# 32-bit integers, narrowing in braced initialisers and the register keyword.
add_library(ct_options INTERFACE)
target_compile_definitions(ct_options INTERFACE ${PORT_DEFINITIONS})
target_include_directories(ct_options INTERFACE
    ${CMAKE_BINARY_DIR}/generated/include ${CMAKE_SOURCE_DIR}/port/include ${KZ_ROOT}/include
    ${PS2_INCLUDE_DIR} ${PS2_INCLUDE_DIR}/sce)
target_compile_options(ct_options INTERFACE
    "SHELL:-include \"${CMAKE_SOURCE_DIR}/port/include/port.h\""
    -fms-extensions -ffunction-sections -fdata-sections
    -Wno-register -Wno-c++11-narrowing -Wno-return-mismatch)
# arm64 clang fuses a*b+c into one rounding by default and x86-64 has no FMA in its baseline; off
# everywhere so the game's arithmetic rounds the same on both.
target_compile_options(ct_options INTERFACE -ffp-contract=off)
# Constructor aliases would point C1 into a COMDAT section lld discards under --allow-multiple-definition.
if(WIN32)
    target_compile_options(ct_options INTERFACE -Xclang -mno-constructor-aliases)
endif()

if(WIN32 AND (NOT MINGW OR NOT CMAKE_CXX_COMPILER_ID STREQUAL "Clang"))
    message(FATAL_ERROR "The Windows build requires clang/llvm-mingw")
endif()

add_library(ct_ps2 OBJECT ${PS2_UNITS} ${PORT_OVERRIDES_CHECKED})
target_link_libraries(ct_ps2 PRIVATE ct_options)
target_compile_definitions(ct_ps2 PRIVATE CT_PS2_TEXTURE_COPY)
add_dependencies(ct_ps2 ps2_include)
# The game reads locals it never sets and falls off the end of functions that return a value, and
# ps2/src keeps both because the match depends on them. MWCC gave each a defined if arbitrary result;
# these flags give the port a defined one too, with the type punning and wraparound the code assumes.
target_compile_options(ct_ps2 PRIVATE -ftrivial-auto-var-init=zero -fno-strict-return
    -fno-strict-aliasing -fwrapv)
# What is left on warns about behaviour the port may still need to answer for. What is turned off
# describes how MWCC-era source is spelled: string literals as char *, MWCC's pragmas, 32-bit pointer
# casts and the unused names and expressions it leaves behind. ps2/src cannot change those without
# changing what MWCC compiles.
target_compile_options(ct_ps2 PRIVATE -Wall -Wno-writable-strings -Wno-unknown-pragmas
    -Wno-mismatched-tags -Wno-missing-braces -Wno-char-subscripts -Wno-overloaded-virtual
    -Wno-pointer-to-int-cast -Wno-int-to-pointer-cast -Wno-int-to-void-pointer-cast
    -Wno-void-pointer-to-int-cast -Wno-unused-variable -Wno-unused-but-set-variable
    -Wno-unused-local-typedef -Wno-unused-label -Wno-unused-function -Wno-unused-value
    -Wno-unused-const-variable -Wno-undefined-internal -Wno-self-assign -Wno-deprecated-volatile)

set(PORT_LIB_SOURCES ${PORT_SOURCES})
list(FILTER PORT_LIB_SOURCES EXCLUDE REGEX "/tests/|/main\\.cpp$")

kz_port_sce_sources(CT_SCE_SOURCES LIBS libvu0 libpad libmc sifdev sifrpc eekernel libcdvd libgraph libdma libpkt
    eekernel_threads libdev libmpeg libsdr modmsin sifdma)
add_library(ct_port OBJECT ${PORT_LIB_SOURCES} ${CT_SCE_SOURCES})
target_link_libraries(ct_port PRIVATE ct_options SDL3::SDL3 Vulkan::Vulkan nlohmann_json::nlohmann_json kz_port_headers kazarov_bridge fastgltf::fastgltf)
if(NOT WIN32)
    find_package(Iconv REQUIRED)
    target_link_libraries(ct_port PRIVATE Iconv::Iconv)
endif()
add_dependencies(ct_port ps2_include)
target_include_directories(ct_port PRIVATE ${PORT_DIR})
# Datapack PNGs use the host's decoder with ordinary PNG colour formats.
find_path(CT_STB_IMAGE_INCLUDE_DIR stb_image.h
    PATHS ${KZ_PORT_VENDOR_DIRS} ${CMAKE_BINARY_DIR}/kz_port/vendor NO_DEFAULT_PATH REQUIRED)
target_include_directories(ct_port PRIVATE ${CT_STB_IMAGE_INCLUDE_DIR})
target_compile_options(ct_port PRIVATE -Wall -Wno-mismatched-tags -Wno-unused-label
    -Wno-overloaded-virtual -Wno-unused-function)

# Opt in for faster replay and test runs while retaining Debug's symbols. Keep the usual
# unoptimised Debug build available for stepping through every local and statement.
# PRIVATE options leave the test sources and GoogleTest at their normal Debug settings.
option(CT_DEBUG_OPT "Optimise game and host code with -Og in Debug builds" OFF)
if(CT_DEBUG_OPT)
    foreach(target IN ITEMS ct_ps2 ct_port ct_host)
        target_compile_options(${target} PRIVATE $<$<CONFIG:Debug>:-Og>)
    endforeach()
endif()

# Shared by the game and its tests. Names the PS2 build tells apart per object are renamed by
# port/include/stubs, so no symbol is defined twice. The executable is position-independent on every
# platform: no game object has to sit below 4 GiB, because pointer-to-32-bit casts are widened in port/src.
if(WIN32)
    # Guard only: COFF cannot resolve a strong definition against COMDAT copies of a header or unit.
    # header_fixups.py removes the known ones; the flag tolerates any that remain.
    set(CT_LINK_OPTIONS -fuse-ld=lld -Wl,--gc-sections -Wl,--error-limit=0 -Wl,--allow-multiple-definition)
elseif(APPLE)
    set(CT_LINK_OPTIONS -Wl,-dead_strip)
else()
    set(CT_LINK_OPTIONS -fuse-ld=lld -pie -Wl,-z,separate-code -Wl,--gc-sections -Wl,--error-limit=0)
endif()

function(ct_link_game target)
    target_sources(${target} PRIVATE $<TARGET_OBJECTS:ct_port> $<TARGET_OBJECTS:ct_host> $<TARGET_OBJECTS:ct_ps2>)
    add_dependencies(${target} ps2_include)
    target_link_libraries(${target} PRIVATE ct_options kz_port_headers SDL3::SDL3 Vulkan::Vulkan kazarov_bridge kazarov_core fastgltf::fastgltf)
    if(NOT WIN32)
        target_link_libraries(${target} PRIVATE Iconv::Iconv)
    endif()
    target_include_directories(${target} PRIVATE ${PORT_DIR})
    target_compile_options(${target} PRIVATE -Wall -Wno-mismatched-tags -Wno-unused-label
        -Wno-overloaded-virtual -Wno-unused-function)
    target_link_options(${target} PRIVATE ${CT_LINK_OPTIONS})
    if(WIN32)
        # The Rust host UI uses Windows input, theme, OpenGL and desktop-composition APIs.
        target_link_libraries(${target} PRIVATE imm32 uxtheme opengl32 dwmapi)
    endif()
endfunction()

add_executable(darkchronicle ${PORT_DIR}/main.cpp)
set_target_properties(darkchronicle PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})
ct_link_game(darkchronicle)
if(WIN32)
    target_link_options(darkchronicle PRIVATE -municode)
    enable_language(RC)
    target_sources(darkchronicle PRIVATE ${CMAKE_SOURCE_DIR}/port/icon/chronicletwo.rc)
endif()

include(GNUInstallDirs)
install(TARGETS darkchronicle RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})

# The button symbols (docs/GLYPHS.md): glyphs/ beside the executable, the art of TheMoonPeople/Chronicle's port/glyphs.
add_custom_target(ct_glyphs
    COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR}/glyphs $<TARGET_FILE_DIR:darkchronicle>/glyphs
    COMMENT "Copying the button symbols")
add_dependencies(darkchronicle ct_glyphs)
install(DIRECTORY glyphs/ DESTINATION ${CMAKE_INSTALL_BINDIR}/glyphs)

option(CT_BUILD_TESTS "Build darkchronicle_tests" ON)
if(CT_BUILD_TESTS)
    add_subdirectory(src/tests)
endif()

file(GLOB ct_stream_cmake CONFIGURE_DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/cmake/*.cmake)
foreach(f IN LISTS ct_stream_cmake)
    include(${f})
endforeach()

if(WIN32)
    include(${KZ_ROOT}/cmake/KazarovWindowsRuntime.cmake)
    kz_windows_runtime(darkchronicle INSTALL EXECUTABLES dc2data)
    kz_windows_runtime(dc2data)
    kz_windows_runtime(dc2data_bridge_test)
    if(TARGET darkchronicle_tests)
        kz_windows_runtime(darkchronicle_tests)
    endif()
endif()
