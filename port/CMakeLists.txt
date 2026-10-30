# The x64 port: native game sources built with clang as C++26 for the host.

if(NOT CMAKE_CXX_COMPILER)
    set(CMAKE_CXX_COMPILER clang++)
endif()
enable_language(CXX)

set(CMAKE_CXX_STANDARD 26)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS ${NINTENDO_SWITCH})
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)
option(CT_BUILD_TESTS "Build darkchronicle_tests" ON)

set(KZ_ROOT ${CMAKE_SOURCE_DIR}/tools/kazarov)
if(NOT EXISTS ${KZ_ROOT}/include/kazarov/port.h)
    message(FATAL_ERROR "${KZ_ROOT} is empty: run git submodule update --init tools/kazarov")
endif()

# One version source is shared by the publisher and native runtime.
file(READ ${KZ_ROOT}/data_version.json KZ_DATA_VERSION_JSON)
set_property(DIRECTORY APPEND PROPERTY CMAKE_CONFIGURE_DEPENDS ${KZ_ROOT}/data_version.json)
string(JSON KZ_DATA_SCHEMA_VERSION GET "${KZ_DATA_VERSION_JSON}" schema_version)
string(JSON KZ_DATA_VERSION GET "${KZ_DATA_VERSION_JSON}" data_version)
if(NOT KZ_DATA_SCHEMA_VERSION EQUAL 1)
    message(FATAL_ERROR "Unsupported tools/kazarov/data_version.json schema")
endif()
file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/generated/include/kazarov)
configure_file(${KZ_ROOT}/include/kazarov/data_version.hpp.in
    ${CMAKE_BINARY_DIR}/generated/include/kazarov/data_version.hpp @ONLY)

# port/assets/icon/chronicletwo-128.rgba, the two moons' raw 128x128 RGBA pixels: the window icon until the game data
# is there to draw Max's wrench from (main.cpp).
set(ICON_RGBA ${CMAKE_SOURCE_DIR}/port/assets/icon/chronicletwo-128.rgba)
set_property(DIRECTORY APPEND PROPERTY CMAKE_CONFIGURE_DEPENDS ${ICON_RGBA})
file(READ ${ICON_RGBA} icon_hex HEX)
string(REGEX REPLACE "(..)" "0x\\1," icon_bytes "${icon_hex}")
file(CONFIGURE OUTPUT ${CMAKE_BINARY_DIR}/generated/include/icon/chronicletwo.hpp
    CONTENT "#pragma once\n#include <cstdint>\ninline constexpr int kIconSize = 128;\ninline constexpr std::uint8_t kIconRgba[] = {${icon_bytes}};\n")

include(${KZ_ROOT}/cmake/KazarovPort.cmake)
if(NINTENDO_SWITCH)
    set(KZ_SWITCH_APPLICATION_NAME "Dark Chronicle")
    set(KZ_SWITCH_LOG_FILE "darkchronicle.log")
    set(KZ_SWITCH_DATA_INSTRUCTIONS "Copy data.zip, data.json, scripts/, glyphs/ and fonts/ beside darkchronicle.nro.")
    include(${KZ_ROOT}/cmake/KazarovSwitch.cmake)
endif()

option(CT_ENABLE_TRACY "Build Tracy support into the native port" ON)
if(CT_ENABLE_TRACY)
    include(FetchContent)
    FetchContent_Declare(tracy
        URL https://codeload.github.com/wolfpld/tracy/tar.gz/30997d5ca6bb632cc10807a1da8a6d3de0aeeb3c
        URL_HASH SHA256=e9d527343623435de954a72ad211a1ae4b205cb877d5cc81b8bd505aac0a2cde
        DOWNLOAD_EXTRACT_TIMESTAMP FALSE)
    set(TRACY_STATIC ON CACHE BOOL "" FORCE)
    set(TRACY_ENABLE ON CACHE BOOL "" FORCE)
    set(TRACY_ON_DEMAND ON CACHE BOOL "" FORCE)
    set(TRACY_ONLY_LOCALHOST ON CACHE BOOL "" FORCE)
    set(TRACY_NO_SAMPLING ON CACHE BOOL "" FORCE)
    set(TRACY_NO_CONTEXT_SWITCH ON CACHE BOOL "" FORCE)
    set(TRACY_NO_SYSTEM_TRACING ON CACHE BOOL "" FORCE)
    set(TRACY_NO_CRASH_HANDLER ON CACHE BOOL "" FORCE)
    FetchContent_MakeAvailable(tracy)
    # The game links the client; its SDK headers and libraries are not installed with the game.
    set_property(DIRECTORY ${tracy_SOURCE_DIR} PROPERTY EXCLUDE_FROM_ALL TRUE)
    configure_file(${tracy_SOURCE_DIR}/LICENSE ${CMAKE_BINARY_DIR}/Tracy-LICENSE.txt COPYONLY)
    set(KZ_PORT_TRACY ON CACHE BOOL "" FORCE)
else()
    set(KZ_PORT_TRACY OFF CACHE BOOL "" FORCE)
endif()

# Retail textures are converted offline; the native executable only loads PNG assets.
set(KZ_PORT_BUILD_TIM2 OFF CACHE BOOL "Build legacy TIM2 decoding into the native runtime" FORCE)

# All Clang diagnostics, except those about compatibility with C++ standards older than the one the port uses.
set(CT_WARNINGS -Weverything
    -Wno-c++98-compat -Wno-c++98-compat-pedantic
    -Wno-pre-c++14-compat -Wno-pre-c++14-compat-pedantic -Wno-pre-c++17-compat -Wno-pre-c++17-compat-pedantic
    -Wno-pre-c++20-compat -Wno-pre-c++20-compat-pedantic -Wno-pre-c++23-compat -Wno-pre-c++23-compat-pedantic
    -Wno-pre-c++26-compat -Wno-pre-c++26-compat-pedantic)

if(NOT CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    set(CT_WARNINGS -Wall -Wextra)
endif()
find_package(Python3 REQUIRED COMPONENTS Interpreter)
kz_port_host_library(ct_host)
if(NINTENDO_SWITCH)
    kz_switch_host(ct_host)
endif()
set_property(SOURCE
    ${KZ_ROOT}/src/cpp/platform/arena.cpp
    ${KZ_ROOT}/src/cpp/platform/input.cpp
    ${KZ_ROOT}/src/cpp/platform/memory.cpp
    ${KZ_ROOT}/src/cpp/sce/eekernel_threads.cpp
    ${KZ_ROOT}/src/cpp/sce/libmc.cpp
    TARGET_DIRECTORY ct_host
    APPEND PROPERTY COMPILE_OPTIONS ${CT_WARNINGS})

# Native game sources and headers are tracked alongside the port. These files contain the
# effective host adaptations of the retail units and require no build-time PS2 source rewriting.
set(PORT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/src)
set(PORT_INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/include)
set(PORT_DEFINITIONS PORT PAL)
# Game units retain their arithmetic options independently of their domain directories.
set(NATIVE_SOURCES
    audio/ezbgm.cpp
    audio/ezmidi.cpp
    audio/scenesnd.cpp
    audio/snd_mngr.cpp
    audio/snd_seseq.cpp
    audio/sndviewlp.cpp
    audio/sound.cpp
    audio/wavetable.cpp
    input/cameracontrol.cpp
    input/gamepad.cpp
    input/padcontrol.cpp
    memory/mg_memory.cpp
    object/character/character.cpp
    object/character/charasetup.cpp
    object/character/charaviewlp.cpp
    object/character/dynamicanime.cpp
    object/character/mdslist.cpp
    object/character/photo.cpp
    object/character/visualmotion.cpp
    object/core/intersection.cpp
    object/core/object.cpp
    object/dun/actionchara.cpp
    object/dun/automap.cpp
    object/dun/collision.cpp
    object/dun/colprim.cpp
    object/dun/dng_debug.cpp
    object/dun/dng_effect.cpp
    object/dun/dng_event.cpp
    object/dun/dng_hud.cpp
    object/dun/dng_main.cpp
    object/dun/dng_object.cpp
    object/dun/dng_status.cpp
    object/dun/dngfloor.cpp
    object/dun/dngmenu.cpp
    object/dun/monster.cpp
    object/dun/occlusion.cpp
    object/dun/savedatadungeon.cpp
    object/dun/sphida.cpp
    object/dun/swordeffect.cpp
    object/event/event.cpp
    object/event/event_func.cpp
    object/event/eventedit.cpp
    object/event/eventsprite.cpp
    object/event/quest.cpp
    object/event/scene.cpp
    object/event/sceneevent.cpp
    object/event/sceneload.cpp
    object/event/sceneseq.cpp
    object/menu/drawwin.cpp
    object/menu/font.cpp
    object/menu/gaiji.cpp
    object/menu/helpmes.cpp
    object/menu/inventmn.cpp
    object/menu/menuaqua.cpp
    object/menu/menucapt.cpp
    object/menu/menuchr.cpp
    object/menu/menucls1.cpp
    object/menu/menucommon.cpp
    object/menu/menudraw.cpp
    object/menu/menumain.cpp
    object/menu/menumap.cpp
    object/menu/menuop.cpp
    object/menu/menushop.cpp
    object/menu/menusys.cpp
    object/menu/menusystemdata.cpp
    object/menu/nameregi.cpp
    object/menu/nd_meswin.cpp
    object/menu/nowload.cpp
    object/menu/prespr.cpp
    object/menu/sysmes.cpp
    object/menu/title.cpp
    object/subgame/fishing.cpp
    object/subgame/fishingobj.cpp
    object/subgame/gyorace.cpp
    object/subgame/gyoracesim.cpp
    object/subgame/subgame.cpp
    object/world/data_packets.cpp
    object/world/editanalyze.cpp
    object/world/editcoll.cpp
    object/world/editctrl.cpp
    object/world/editdata.cpp
    object/world/editdebug.cpp
    object/world/editeff.cpp
    object/world/editevent.cpp
    object/world/editexception.cpp
    object/world/editinfo.cpp
    object/world/editloop.cpp
    object/world/editmap.cpp
    object/world/editmap2.cpp
    object/world/editmapeffect.cpp
    object/world/editmenu.cpp
    object/world/editmode.cpp
    object/world/editparts.cpp
    object/world/editriver.cpp
    object/world/map.cpp
    object/world/mapinfo.cpp
    object/world/mapjump.cpp
    object/world/mapload.cpp
    object/world/mapparts.cpp
    object/world/mapselect.cpp
    object/world/mapsky.cpp
    object/world/mapviewlp.cpp
    object/world/npccfg.cpp
    object/world/pbuggy.cpp
    object/world/pot.cpp
    object/world/scenevillager.cpp
    object/world/villagermngr.cpp
    object/world/vlgr_info.cpp
    object/world/water.cpp
    platform/crandom.cpp
    platform/dataread.cpp
    platform/dbg_font.cpp
    platform/filesocket.cpp
    platform/frame_timing.cpp
    platform/gamedata.cpp
    platform/gameutil.cpp
    platform/hddinstall.cpp
    platform/main.cpp
    platform/mainloop.cpp
    platform/mainloop3.cpp
    platform/memcard.cpp
    platform/savedata.cpp
    platform/userdata.cpp
    render/maintex.cpp
    render/mg_camera.cpp
    render/mg_dataset.cpp
    render/mg_drawenv.cpp
    render/mg_drawprim.cpp
    render/mg_frame.cpp
    render/mg_math.cpp
    render/mg_shadow.cpp
    render/mg_sprite.cpp
    render/mg_tanime.cpp
    render/mg_texture.cpp
    render/mg_visual.cpp
    render/mglib.cpp
    render/outline.cpp
    render/screeneffect.cpp
    render/texviewlp.cpp
    script/actscript.cpp
    script/effect.cpp
    script/effectlist.cpp
    script/effscript.cpp
    script/funcpoint.cpp
    script/runscript.cpp
    script/runscript_opcodes.cpp
    script/scriptinterpreter.cpp
    storage/album.cpp
    storage/password.cpp
    video/convviewlp.cpp
    video/movie.cpp
    video/movieviewlp.cpp
)
list(TRANSFORM NATIVE_SOURCES PREPEND "${PORT_DIR}/")
file(GLOB_RECURSE PORT_SOURCES CONFIGURE_DEPENDS ${PORT_DIR}/*.cpp)
list(FILTER PORT_SOURCES EXCLUDE REGEX "/tests/")
list(REMOVE_ITEM PORT_SOURCES ${NATIVE_SOURCES})
if(NINTENDO_SWITCH)
    list(FILTER PORT_SOURCES EXCLUDE REGEX "/ios/|/crash/(crash|crash_dialog|crash_report|crash_symbols)\\.cpp$")
else()
    list(FILTER PORT_SOURCES EXCLUDE REGEX "/switch/")
endif()

# Some retail units use declarations supplied by a per-unit native compatibility header.
file(GLOB NATIVE_COMPATIBILITY_HEADERS CONFIGURE_DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/include/stubs/*.hpp)
foreach(source IN LISTS NATIVE_SOURCES)
    get_filename_component(unit ${source} NAME_WE)
    set(stub ${CMAKE_CURRENT_SOURCE_DIR}/include/stubs/${unit}.hpp)
    if(stub IN_LIST NATIVE_COMPATIBILITY_HEADERS)
        set_property(SOURCE ${source} APPEND PROPERTY COMPILE_OPTIONS -include ${stub})
    endif()
endforeach()

# Every native game, adapter, executable and test compiles with all Clang diagnostics enabled.
add_library(ct_options INTERFACE)
target_compile_definitions(ct_options INTERFACE ${PORT_DEFINITIONS})
target_include_directories(ct_options INTERFACE
    ${CMAKE_BINARY_DIR}/generated/include ${CMAKE_SOURCE_DIR}/port/include
    ${PORT_INCLUDE_DIR}/sce)
target_include_directories(ct_options SYSTEM INTERFACE ${KZ_ROOT}/include)
target_compile_options(ct_options INTERFACE
    "SHELL:-include \"${CMAKE_SOURCE_DIR}/port/include/port.h\""
    -ffunction-sections -fdata-sections ${CT_WARNINGS})
if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    target_compile_options(ct_options INTERFACE -fms-extensions -fcomment-block-commands=mangled,address,size,unknownret)
endif()
# arm64 clang fuses a*b+c into one rounding by default and x86-64 has no FMA in its baseline; off
# everywhere so the game's arithmetic rounds the same on both.
target_compile_options(ct_options INTERFACE -ffp-contract=off)

if(WIN32 AND (NOT MINGW OR NOT CMAKE_CXX_COMPILER_ID STREQUAL "Clang"))
    message(FATAL_ERROR "The Windows build requires clang/llvm-mingw")
endif()

add_library(ct_native OBJECT ${NATIVE_SOURCES})
target_link_libraries(ct_native PRIVATE ct_options SDL3::SDL3 kz::vulkan nlohmann_json::nlohmann_json kz_port_headers fastgltf::fastgltf)
target_include_directories(ct_native PRIVATE ${PORT_DIR})
if(NOT WIN32)
    target_link_libraries(ct_native PRIVATE Iconv::Iconv)
endif()

# Retained game arithmetic and type punning still rely on signed wrapping and relaxed aliasing.
# Keep zero initialization until the remaining source paths have explicit initialization.
target_compile_options(ct_native PRIVATE -ftrivial-auto-var-init=zero -fno-strict-aliasing -fwrapv)

set(PORT_LIB_SOURCES ${PORT_SOURCES})
list(FILTER PORT_LIB_SOURCES EXCLUDE REGEX "/tests/|/main\\.cpp$")

kz_port_sce_sources(CT_SCE_SOURCES LIBS libvu0 libpad libmc sifdev sifrpc eekernel libcdvd libgraph libdma libpkt
    eekernel_threads libdev libmpeg libsdr modmsin sifdma)
# Linking kazarov_bridge orders every compile of a target after the whole Cargo build, which generates the
# bridge header. Only the sources that include that header go in ct_port_bridge, so the rest of port/src
# compiles alongside Cargo instead of waiting for it.
set(PORT_BRIDGE_SOURCES "")
foreach(source IN LISTS PORT_LIB_SOURCES)
    file(STRINGS ${source} bridge_include REGEX "^[ \t]*#[ \t]*include[ \t]*[<\"](kazarov_bridge/|rust/cxx\\.h)" LIMIT_COUNT 1)
    if(bridge_include)
        list(APPEND PORT_BRIDGE_SOURCES ${source})
    endif()
endforeach()
if(PORT_BRIDGE_SOURCES)
    list(REMOVE_ITEM PORT_LIB_SOURCES ${PORT_BRIDGE_SOURCES})
endif()

find_path(CT_STB_IMAGE_INCLUDE_DIR stb_image.h
    PATHS ${KZ_PORT_VENDOR_DIRS} ${CMAKE_BINARY_DIR}/kz_port/vendor NO_DEFAULT_PATH NO_CMAKE_FIND_ROOT_PATH REQUIRED)
if(NOT WIN32)
    find_package(Iconv REQUIRED)
endif()
add_library(ct_port OBJECT ${PORT_LIB_SOURCES} ${CT_SCE_SOURCES})
add_library(ct_port_bridge OBJECT ${PORT_BRIDGE_SOURCES})
# SDK implementations are dependencies even when they are linked into the port object target.
set_property(SOURCE ${CT_SCE_SOURCES} APPEND PROPERTY COMPILE_OPTIONS -w)
if(NINTENDO_SWITCH)
    kz_switch_runtime(ct_port)
else()
    target_link_libraries(ct_port_bridge PRIVATE kazarov_bridge)
endif()
foreach(target IN ITEMS ct_port ct_port_bridge)
    target_link_libraries(${target} PRIVATE ct_options SDL3::SDL3 kz::vulkan nlohmann_json::nlohmann_json kz_port_headers fastgltf::fastgltf)
    if(NOT WIN32)
        target_link_libraries(${target} PRIVATE Iconv::Iconv)
    endif()
    # Datapack PNGs use the host's decoder with ordinary PNG colour formats.
    target_include_directories(${target} PRIVATE ${PORT_DIR})
    target_include_directories(${target} SYSTEM PRIVATE ${CT_STB_IMAGE_INCLUDE_DIR})
endforeach()
# Single-header dependencies also provide implementations compiled by the host library.
target_include_directories(ct_host SYSTEM PRIVATE ${CT_STB_IMAGE_INCLUDE_DIR} ${KZ_PORT_VENDOR_DIRS})
target_compile_options(ct_host PRIVATE -w)
if(CT_ENABLE_TRACY)
    foreach(target IN ITEMS ct_port ct_port_bridge)
        target_link_libraries(${target} PRIVATE Tracy::TracyClient)
        target_compile_definitions(${target} PRIVATE CT_ENABLE_TRACY)
    endforeach()
endif()

# Opt in for faster replay and test runs while retaining Debug's symbols. Keep the usual
# unoptimised Debug build available for stepping through every local and statement.
# PRIVATE options leave the test sources and GoogleTest at their normal Debug settings.
option(CT_DEBUG_OPT "Optimise game and host code with -Og in Debug builds" OFF)
if(CT_DEBUG_OPT)
    foreach(target IN ITEMS ct_native ct_port ct_port_bridge ct_host)
        target_compile_options(${target} PRIVATE $<$<CONFIG:Debug>:-Og>)
    endforeach()
endif()

# Shared by the game and its tests. The native game sources and host code are linked into
# a position-independent executable; pointer-width conversions are handled in port code.
if(NINTENDO_SWITCH)
    set(CT_LINK_OPTIONS -Wl,--gc-sections)
elseif(WIN32)
    set(CT_LINK_OPTIONS -fuse-ld=lld -Wl,--gc-sections -Wl,--error-limit=0)
elseif(APPLE)
    set(CT_LINK_OPTIONS -Wl,-dead_strip)
else()
    set(CT_LINK_OPTIONS -fuse-ld=lld -pie -Wl,-z,separate-code -Wl,--gc-sections -Wl,--error-limit=0)
endif()

function(ct_link_game target)
    target_sources(${target} PRIVATE $<TARGET_OBJECTS:ct_port> $<TARGET_OBJECTS:ct_port_bridge> $<TARGET_OBJECTS:ct_host> $<TARGET_OBJECTS:ct_native>)
    target_link_libraries(${target} PRIVATE ct_options kz_port_headers SDL3::SDL3 kz::vulkan fastgltf::fastgltf)
    if(NOT NINTENDO_SWITCH)
        target_link_libraries(${target} PRIVATE kazarov_bridge kazarov_core)
    else()
        target_link_libraries(${target} PRIVATE zstd z)
    endif()
    if(CT_ENABLE_TRACY)
        target_link_libraries(${target} PRIVATE Tracy::TracyClient)
        target_compile_definitions(${target} PRIVATE CT_ENABLE_TRACY)
    endif()
    if(NOT WIN32)
        target_link_libraries(${target} PRIVATE Iconv::Iconv)
    endif()
    target_include_directories(${target} PRIVATE ${PORT_DIR})
    target_link_options(${target} PRIVATE ${CT_LINK_OPTIONS})
    if(WIN32)
        # The Rust host UI uses Windows input, theme, OpenGL and desktop-composition APIs.
        target_link_libraries(${target} PRIVATE imm32 uxtheme opengl32 dwmapi)
    elseif(CMAKE_SYSTEM_NAME STREQUAL "iOS")
        target_link_libraries(${target} PRIVATE "-framework UIKit" "-framework Metal" "-framework QuartzCore" "-framework CoreMotion" "-framework CoreGraphics" "-framework IOSurface" "-framework Foundation" "-framework GameController" "-framework CoreHaptics" "-framework UniformTypeIdentifiers")
    endif()
endfunction()

add_executable(darkchronicle ${PORT_DIR}/main.cpp)
set_target_properties(darkchronicle PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})
ct_link_game(darkchronicle)
if(NINTENDO_SWITCH)
    kz_switch_nro(darkchronicle NAME "Dark Chronicle" AUTHOR "ChronicleTwo contributors" VERSION "0.1.0"
        ICON ${CMAKE_CURRENT_SOURCE_DIR}/assets/icon/chronicletwo-switch.jpg)
endif()
if(CMAKE_SYSTEM_NAME STREQUAL "iOS")
    # iOS runs only applications: the executable goes inside darkchronicle.app with a generated Info.plist.
    set_target_properties(darkchronicle PROPERTIES
        MACOSX_BUNDLE TRUE
        MACOSX_BUNDLE_INFO_PLIST ${CMAKE_CURRENT_SOURCE_DIR}/assets/ios/Info.plist.in
        MACOSX_BUNDLE_GUI_IDENTIFIER org.chronicletwo.darkchronicle
        MACOSX_BUNDLE_BUNDLE_NAME "Dark Chronicle"
        MACOSX_BUNDLE_SHORT_VERSION_STRING 0.1
        MACOSX_BUNDLE_BUNDLE_VERSION 1)
    # The launcher, the on-screen gamepad and the DualSense haptics are Swift (port/src/ios), which calls the game
    # through Swift's C++ interoperability: ios/module.modulemap makes ios/bridge.hpp the module ChronicleBridge.
    execute_process(COMMAND xcrun --sdk iphoneos --show-sdk-path OUTPUT_VARIABLE CT_IOS_SDK
        OUTPUT_STRIP_TRAILING_WHITESPACE COMMAND_ERROR_IS_FATAL ANY)
    execute_process(COMMAND xcrun --sdk iphoneos --find swiftc OUTPUT_VARIABLE CMAKE_Swift_COMPILER
        OUTPUT_STRIP_TRAILING_WHITESPACE COMMAND_ERROR_IS_FATAL ANY)
    set(CMAKE_Swift_COMPILER_TARGET arm64-apple-ios${CMAKE_OSX_DEPLOYMENT_TARGET})
    set(CMAKE_Swift_FLAGS "-sdk ${CT_IOS_SDK}")
    set(CMAKE_Swift_LANGUAGE_VERSION 5)
    enable_language(Swift)
    add_library(ct_ios_swift STATIC ${PORT_DIR}/ios/Launcher.swift ${PORT_DIR}/ios/TouchOverlay.swift
        ${PORT_DIR}/ios/Haptics.swift)
    target_compile_options(ct_ios_swift PRIVATE -cxx-interoperability-mode=default "SHELL:-Xcc -std=c++20"
        "SHELL:-I ${PORT_DIR}/ios")
    target_link_libraries(darkchronicle PRIVATE ct_ios_swift)
    # clang++ links, so the C++ flags apply; the Swift runtime is in iOS, its back-deployment and C++ interop
    # libraries in the toolchain.
    set_target_properties(darkchronicle PROPERTIES LINKER_LANGUAGE CXX)
    get_filename_component(CT_SWIFT_LIBRARIES "${CMAKE_Swift_COMPILER}/../../lib/swift/iphoneos" ABSOLUTE)
    target_link_directories(darkchronicle PRIVATE ${CT_IOS_SDK}/usr/lib/swift ${CT_SWIFT_LIBRARIES})
    # iOS 16's libc++ lacks std::to_chars for floating point, which std::format calls; the executable defines it.
    add_library(ct_ios_to_chars OBJECT ${PORT_DIR}/ios/to_chars.cpp)
    set_target_properties(ct_ios_to_chars PROPERTIES CXX_STANDARD 20 CXX_STANDARD_REQUIRED ON)
    target_link_libraries(darkchronicle PRIVATE ct_ios_to_chars)
endif()
if(WIN32)
    target_link_options(darkchronicle PRIVATE -municode)
    enable_language(RC)
    target_sources(darkchronicle PRIVATE ${CMAKE_SOURCE_DIR}/port/assets/icon/chronicletwo.rc)
endif()

include(GNUInstallDirs)
install(TARGETS darkchronicle RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR} BUNDLE DESTINATION .)
if(CT_ENABLE_TRACY)
    install(FILES ${CMAKE_BINARY_DIR}/Tracy-LICENSE.txt
        DESTINATION ${CMAKE_INSTALL_DATADIR}/licenses/chronicletwo)
endif()

# Assets copied beside the executable: the button symbols (docs/GLYPHS.md), the art of TheMoonPeople/Chronicle's
# port/glyphs, to glyphs/; and the text fonts (docs/PC.md "Message font"), with their licences and the notice of what
# was changed, to fonts/.
# Each copy is a declared output, so an up-to-date build runs nothing and a deleted copy is restored.
foreach(asset_dir IN ITEMS glyphs fonts)
    file(GLOB asset_sources CONFIGURE_DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/assets/${asset_dir}/*)
    set(asset_copies "")
    foreach(asset IN LISTS asset_sources)
        get_filename_component(asset_name ${asset} NAME)
        set(asset_copy ${CMAKE_BINARY_DIR}/${asset_dir}/${asset_name})
        add_custom_command(OUTPUT ${asset_copy}
            COMMAND ${CMAKE_COMMAND} -E copy ${asset} ${asset_copy}
            DEPENDS ${asset}
            COMMENT "Copying ${asset_dir}/${asset_name}"
            VERBATIM)
        list(APPEND asset_copies ${asset_copy})
    endforeach()
    add_custom_target(ct_${asset_dir} DEPENDS ${asset_copies})
    add_dependencies(darkchronicle ct_${asset_dir})
    install(DIRECTORY assets/${asset_dir}/ DESTINATION ${CMAKE_INSTALL_BINDIR}/${asset_dir})
endforeach()

if(CT_BUILD_TESTS)
    add_subdirectory(src/tests)
endif()

file(GLOB ct_stream_cmake CONFIGURE_DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/cmake/*.cmake)
foreach(f IN LISTS ct_stream_cmake)
    if(NINTENDO_SWITCH AND f MATCHES "/(crash|data)\\.cmake$")
        continue()
    endif()
    include(${f})
endforeach()

# Third-party projects build without warnings, and their headers are system headers to the port's sources.
function(ct_quiet_dependency_directory directory)
    get_property(targets DIRECTORY ${directory} PROPERTY BUILDSYSTEM_TARGETS)
    foreach(target IN LISTS targets)
        get_target_property(type ${target} TYPE)
        if(type STREQUAL "UTILITY")
            continue()
        endif()
        set_property(TARGET ${target} PROPERTY SYSTEM TRUE)
        if(NOT type STREQUAL "INTERFACE_LIBRARY")
            target_compile_options(${target} PRIVATE -w)
        endif()
    endforeach()
    get_property(subdirectories DIRECTORY ${directory} PROPERTY SUBDIRECTORIES)
    foreach(subdirectory IN LISTS subdirectories)
        ct_quiet_dependency_directory(${subdirectory})
    endforeach()
endfunction()
foreach(dependency IN ITEMS cpptrace fastgltf googletest libdwarf luau nlohmann_json quill simdjson tracy)
    FetchContent_GetProperties(${dependency})
    # Installed packages have no FetchContent source directory.
    if(${dependency}_POPULATED AND IS_DIRECTORY "${${dependency}_SOURCE_DIR}")
        ct_quiet_dependency_directory("${${dependency}_SOURCE_DIR}")
    endif()
endforeach()
# SDL's package marks its headers as non-system.
if(TARGET SDL3::Headers)
    set_property(TARGET SDL3::Headers PROPERTY SYSTEM TRUE)
endif()

if(WIN32)
    include(${KZ_ROOT}/cmake/KazarovWindowsRuntime.cmake)
    kz_windows_runtime(darkchronicle INSTALL EXECUTABLES dc2data)
    kz_windows_runtime(dc2data)
    if(TARGET dc2data_bridge_test)
        kz_windows_runtime(dc2data_bridge_test)
    endif()
    if(TARGET darkchronicle_tests)
        kz_windows_runtime(darkchronicle_tests)
    endif()
endif()
