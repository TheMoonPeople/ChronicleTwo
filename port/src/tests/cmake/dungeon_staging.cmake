# Headless dungeon entry smoke (needs port/run with extracted data).
find_package(Python3 COMPONENTS Interpreter)
if(NOT Python3_EXECUTABLE)
    return()
endif()

set(DUNGEON_STAGING_SCRIPT ${CMAKE_CURRENT_BINARY_DIR}/dungeon_staging_smoke.cmake)
file(WRITE ${DUNGEON_STAGING_SCRIPT} [=[
if(NOT IS_DIRECTORY "${REPO}/port/run")
    message(FATAL_ERROR "SKIP_NO_RUN_DIR")
endif()
file(MAKE_DIRECTORY "${WORK}/save")
execute_process(
    COMMAND "${EXE}" --headless --offscreen --run-dir "${REPO}/port/run" --save "${WORK}/save"
        --jump dungeon:3:1 --fast-load --frames 1800
    RESULT_VARIABLE rc OUTPUT_VARIABLE out ERROR_VARIABLE err TIMEOUT 300)
message("${out}${err}")
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "dungeon headless smoke failed rc=${rc}")
endif()
message("DUNGEON_STAGING_SMOKE_OK")
]=])
add_test(NAME DungeonStaging.HeadlessDungeonEntry
    COMMAND ${CMAKE_COMMAND}
        -DEXE=$<TARGET_FILE:darkchronicle>
        -DREPO=${CMAKE_SOURCE_DIR}
        -DWORK=${CMAKE_BINARY_DIR}/dungeon-staging-smoke
        -P ${DUNGEON_STAGING_SCRIPT})
set_tests_properties(DungeonStaging.HeadlessDungeonEntry PROPERTIES
    PASS_REGULAR_EXPRESSION "DUNGEON_STAGING_SMOKE_OK"
    FAIL_REGULAR_EXPRESSION "SKIP_NO_RUN_DIR|SIGSEGV|ArenaOverflow|staging overflow"
    TIMEOUT 320
    RUN_SERIAL TRUE
    LABELS "cpu;corpus;gpu")
