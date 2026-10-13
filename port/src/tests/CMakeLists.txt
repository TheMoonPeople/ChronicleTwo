# darkchronicle_tests links the whole port and game so a test can exercise a replacement unit against the
# real game types. Each *_test.cpp holds GoogleTest cases; ctest runs one process per case, since the
# game's state is global.
include(FetchContent)
FetchContent_Declare(googletest
    GIT_REPOSITORY https://github.com/google/googletest.git
    GIT_TAG v1.18.0
    GIT_SHALLOW TRUE
    FIND_PACKAGE_ARGS NAMES GTest)
set(INSTALL_GTEST OFF CACHE BOOL "" FORCE)
set(BUILD_GMOCK OFF CACHE BOOL "" FORCE)
FetchContent_MakeAvailable(googletest)
include(GoogleTest)

add_test(NAME PalettePaths.Check
    COMMAND ${Python3_EXECUTABLE} ${CMAKE_SOURCE_DIR}/scripts/port/check_palette_paths.py
        ${CMAKE_BINARY_DIR}/ps2_src ${CMAKE_SOURCE_DIR}/port/src)

file(GLOB_RECURSE TEST_SOURCES CONFIGURE_DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/*_test.cpp)
add_executable(darkchronicle_tests ${CMAKE_CURRENT_SOURCE_DIR}/main.cpp ${TEST_SOURCES})
# Decoder fixtures remain available in tests without linking proprietary texture decoding into the game.
target_sources(darkchronicle_tests PRIVATE ${KZ_ROOT}/src/cpp/gfx/tim2.cpp)
set_target_properties(darkchronicle_tests PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})
target_include_directories(darkchronicle_tests PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})
set(LOCAL_LAYOUT_PROBES ${CMAKE_CURRENT_BINARY_DIR}/local_layout_probes.hpp)
add_custom_command(OUTPUT ${LOCAL_LAYOUT_PROBES}
    COMMAND ${Python3_EXECUTABLE} ${CMAKE_SOURCE_DIR}/scripts/port/local_layout_probes.py
        ${CMAKE_SOURCE_DIR} ${LOCAL_LAYOUT_PROBES}
    DEPENDS ${CMAKE_SOURCE_DIR}/scripts/port/local_layout_probes.py
        ${CMAKE_SOURCE_DIR}/ps2/src/character.cpp ${CMAKE_SOURCE_DIR}/ps2/src/menusys.cpp
    VERBATIM)
target_sources(darkchronicle_tests PRIVATE ${LOCAL_LAYOUT_PROBES})
target_include_directories(darkchronicle_tests PRIVATE ${CMAKE_CURRENT_BINARY_DIR})
ct_link_game(darkchronicle_tests)
kz_port_tests(darkchronicle_tests)
target_link_libraries(darkchronicle_tests PRIVATE GTest::gtest nlohmann_json::nlohmann_json)

# A case is a unit test: it finishes in milliseconds, and one that does not is cut off. The clock
# cases measure short sleeps, which the parallel gfx cases skew, so they run on their own. The cases that compile
# pipelines or create a device per case take longer than 5 s under a parallel run, on lavapipe and on Windows, so they get at least 30 s, or CT_TEST_TIMEOUT when it is larger.
# Cases that need a Vulkan device carry the gpu label: hosted runners have none and exclude them with -LE gpu.
set(CT_TEST_TIMEOUT 5 CACHE STRING "Seconds a test case may run before it is cut off")
set(CT_GPU_SLOW_TIMEOUT 30)
if(CT_TEST_TIMEOUT GREATER CT_GPU_SLOW_TIMEOUT)
    set(CT_GPU_SLOW_TIMEOUT ${CT_TEST_TIMEOUT})
endif()
# These cases share renderer suites but only inspect CPU data and must run on hosted CI.
set(CT_CPU_TESTS
    MgVisual.FaceMeshListAndStrip
    MglibProjection.DepthRoundTrip
    ScreenEffect.DepthOfFieldLevelSizesFollowRetailCascade
    Vu1Prog0Shader.MirrorWordVectors
    GfxMeshDc2.MeshConstantsKeepChroniclesSize)
set(CT_GPU_SLOW_TESTS
    CameraFixedMouseGpu.*
    FontPortGpu.*
    Vu1Prog0Shader.*
    GfxGpu*.*
    */GfxGpu*.*
    MgTextureGpu.*
    MenuIconGpu.*
    MgTanimeGpu.*
    GfxMisc.PipelineCache)
set(CT_GPU_TESTS
    TargetPresentation.*
    PickupPresentation.RetailEmissionsTagCoinsAbsAndFloatingItems
    DamagePresentation.RetailDamageInterpolatesProjectedBounceAndOpacity
    DamagePresentation.Score2InterpolatesAndReusedSlotsStayNewest
    DamagePresentation.SpriteHealClippingAndPause
    DamagePresentation.RealAtlasProjectedEndpoints
    MglibAspect.*
    MglibPresent.*
    MglibSeam.*
    MgVisual.*
    ScreenEffect.*
    MgShadow.*
    Water.*
    MglibFrame.*
    MglibState.*
    MglibProjection.*
    MglibFrameDeathTest.*
    Photo.*
    MgDrawPrimRender.*
    MenuDrawGrab.*
    GfxMisc.*
    GfxTim2.UploadRgbaAndIndexed
    GfxValidation.DeliberateMisuseIsCaught
    MovieGlue.ThirtyFramesOfL5LogoThroughTheMovieTexture)
list(JOIN CT_GPU_SLOW_TESTS ":" CT_GPU_SLOW_FILTER)
list(JOIN CT_GPU_TESTS ":" CT_GPU_FILTER)
list(JOIN CT_CPU_TESTS ":" CT_CPU_FILTER)

# Catch direct device helpers and renderer-owning fixtures in new test suites at configure time.
execute_process(COMMAND ${Python3_EXECUTABLE} ${CMAKE_SOURCE_DIR}/scripts/port/gpu_test_labels.py
    ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_SOURCE_DIR}/tools/kazarov/src/cpp/tests
    --filters ${CT_GPU_FILTER}:${CT_GPU_SLOW_FILTER}
    --cpu-filters ${CT_CPU_FILTER}
    RESULT_VARIABLE gpu_label_result OUTPUT_VARIABLE gpu_label_output ERROR_VARIABLE gpu_label_error)
if(NOT gpu_label_result EQUAL 0)
    message(FATAL_ERROR "${gpu_label_output}${gpu_label_error}")
endif()
gtest_discover_tests(darkchronicle_tests
    DISCOVERY_MODE PRE_TEST
    TEST_FILTER -PlatformClock.*:${CT_GPU_FILTER}:${CT_GPU_SLOW_FILTER}:${CT_CPU_FILTER}
    PROPERTIES TIMEOUT ${CT_TEST_TIMEOUT})
gtest_discover_tests(darkchronicle_tests
    DISCOVERY_MODE PRE_TEST
    TEST_FILTER PlatformClock.*
    PROPERTIES TIMEOUT ${CT_TEST_TIMEOUT} RUN_SERIAL TRUE)
gtest_discover_tests(darkchronicle_tests
    DISCOVERY_MODE PRE_TEST
    TEST_FILTER ${CT_CPU_FILTER}
    PROPERTIES TIMEOUT ${CT_TEST_TIMEOUT})

gtest_discover_tests(darkchronicle_tests
    DISCOVERY_MODE PRE_TEST
    TEST_FILTER ${CT_GPU_FILTER}-${CT_GPU_SLOW_FILTER}:${CT_CPU_FILTER}
    PROPERTIES TIMEOUT ${CT_TEST_TIMEOUT} LABELS gpu)
gtest_discover_tests(darkchronicle_tests
    DISCOVERY_MODE PRE_TEST
    TEST_FILTER ${CT_GPU_SLOW_FILTER}-${CT_CPU_FILTER}
    PROPERTIES TIMEOUT ${CT_GPU_SLOW_TIMEOUT} LABELS gpu)

add_dependencies(darkchronicle_tests darkchronicle)
# ctest reports a process that dies by abort() as failed even when PASS_REGULAR_EXPRESSION matches its
# output, so the executable runs under a script that checks the run and the file it writes, and the regex
# judges the script's verdict. Its shader compile loads the CPU, so it runs alone with the clock cases.
# The smoke fixture is coherent empty publisher output at the pinned data version, so the run
# passes the first-run data check and stays in the logo fade without game data.
set(SMOKE_SCRIPT ${CMAKE_CURRENT_BINARY_DIR}/smoke_headless.cmake)
file(WRITE ${SMOKE_SCRIPT} [=[
include("${EMPTY_DATA_FIXTURE}")
ct_empty_data_fixture("${ROOT}" "${DATA_VERSION_SOURCE}")
file(MAKE_DIRECTORY "$ENV{DC2_SAVE}")
file(REMOVE "$ENV{DC2_SAVE}/smoke.png")
execute_process(COMMAND "${EXE}" --headless --offscreen --frames 3 --screenshot "$ENV{DC2_SAVE}/smoke.png"
    RESULT_VARIABLE rc OUTPUT_VARIABLE out ERROR_VARIABLE err TIMEOUT 120)
set(log "${out}${err}")
message("${log}")
set(png "$ENV{DC2_SAVE}/smoke.png")
set(sig "")
if(EXISTS "${png}")
    file(READ "${png}" sig LIMIT 8 HEX)
endif()
string(FIND "${log}" "dataread: indexed " index_at)
string(FIND "${log}" "mglib: frame 3 written to" frame_at)
if(rc EQUAL 0 AND index_at GREATER -1 AND frame_at GREATER -1 AND sig STREQUAL "89504e470d0a1a0a")
    message("SMOKE_OK")
endif()
]=])
add_test(NAME Smoke.HeadlessFramesScreenshot
    COMMAND ${CMAKE_COMMAND} -DEXE=$<TARGET_FILE:darkchronicle>
        -DROOT=${CMAKE_BINARY_DIR}/smoke-fixture
        -DEMPTY_DATA_FIXTURE=${CMAKE_CURRENT_SOURCE_DIR}/cmake/empty_data.cmake
        -DDATA_VERSION_SOURCE=${KZ_ROOT}/data_version.json -P ${SMOKE_SCRIPT})
set_tests_properties(Smoke.HeadlessFramesScreenshot PROPERTIES
    PASS_REGULAR_EXPRESSION "SMOKE_OK"
    ENVIRONMENT "DC2_SAVE=${CMAKE_BINARY_DIR}/smoke-fixture/save;DC2_DATA=${CMAKE_BINARY_DIR}/smoke-fixture/data"
    TIMEOUT 120 RUN_SERIAL TRUE LABELS gpu)

file(GLOB ct_stream_cmake CONFIGURE_DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/cmake/*.cmake)
foreach(f IN LISTS ct_stream_cmake)
    include(${f})
endforeach()
