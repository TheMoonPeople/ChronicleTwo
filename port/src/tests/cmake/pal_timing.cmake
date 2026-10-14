set(CT_PAL_TIMING_BASE "" CACHE STRING
    "Baseline ref for restoring PAL_TIMING wrappers to the original PS2 source")
if(CT_PAL_TIMING_BASE)
    add_test(NAME PalTiming.Ps2Identity
        COMMAND ${Python3_EXECUTABLE} ${CMAKE_SOURCE_DIR}/scripts/port/pal_timing_identity.py
            ${CT_PAL_TIMING_BASE} --root ${CMAKE_SOURCE_DIR})
    set_tests_properties(PalTiming.Ps2Identity PROPERTIES LABELS cpu TIMEOUT 120)
endif()
add_test(NAME PalTiming.IdentitySelfTest
    COMMAND ${Python3_EXECUTABLE} ${CMAKE_SOURCE_DIR}/scripts/port/pal_timing_identity.py --self-test)
set_tests_properties(PalTiming.IdentitySelfTest PROPERTIES LABELS cpu TIMEOUT 10)
add_test(NAME PalTiming.Sites
    COMMAND ${Python3_EXECUTABLE} ${CMAKE_SOURCE_DIR}/scripts/port/pal_timing_sites.py)
set_tests_properties(PalTiming.Sites PROPERTIES LABELS cpu TIMEOUT 10)
add_test(NAME PalTiming.SitesSelfTest
    COMMAND ${Python3_EXECUTABLE} ${CMAKE_SOURCE_DIR}/scripts/port/pal_timing_sites.py --self-test)
set_tests_properties(PalTiming.SitesSelfTest PROPERTIES LABELS cpu TIMEOUT 10)

# A scripted NTSC run must fail before renderer startup instead of silently using PAL.
set(SCRIPT_TIMING_REJECT ${CMAKE_CURRENT_BINARY_DIR}/script_timing_reject.cmake)
file(WRITE ${SCRIPT_TIMING_REJECT} [=[
include("${EMPTY_DATA_FIXTURE}")
ct_empty_data_fixture("${ROOT}" "${DATA_VERSION_SOURCE}")
file(MAKE_DIRECTORY "${ROOT}/data/dungeon/eff_script" "${ROOT}/save")
file(WRITE "${ROOT}/data/dungeon/eff_script/m_curse_h.stb" "not-SB2")
if(LEGACY_CONFIG)
    file(WRITE "${ROOT}/save/config.json" "{\"game\":{\"timing\":\"pal\",\"tick_rate\":50}}")
endif()
execute_process(COMMAND "${EXE}" --headless --offscreen --data "${ROOT}/data"
    --save "${ROOT}/save" --frames 1 RESULT_VARIABLE rc OUTPUT_VARIABLE out ERROR_VARIABLE err)
if(NOT rc EQUAL 5 OR NOT err MATCHES "script timing startup: dungeon/eff_script/m_curse_h.stb:")
    message(FATAL_ERROR "Expected exit 5 and the mismatched asset list; exit=${rc}\n${out}${err}")
endif()
message("HEADLESS_NTSC_REJECT_OK: exit=5; mismatched asset listed")
]=])
foreach(policy IN ITEMS Default LegacyPal)
    set(legacy_config OFF)
    if(policy STREQUAL "LegacyPal")
        set(legacy_config ON)
    endif()
    add_test(NAME ScriptTimingStartup.HeadlessMismatchExitStatus${policy}
        COMMAND ${CMAKE_COMMAND} -DEXE=$<TARGET_FILE:darkchronicle>
            -DROOT=${CMAKE_BINARY_DIR}/script-timing-reject-${policy}-fixture
            -DLEGACY_CONFIG=${legacy_config}
            -DEMPTY_DATA_FIXTURE=${CMAKE_CURRENT_LIST_DIR}/empty_data.cmake
            -DDATA_VERSION_SOURCE=${KZ_ROOT}/data_version.json -P ${SCRIPT_TIMING_REJECT})
    set_tests_properties(ScriptTimingStartup.HeadlessMismatchExitStatus${policy} PROPERTIES LABELS cpu TIMEOUT 5)
endforeach()
