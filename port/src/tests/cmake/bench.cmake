# Dungeon floor-1 performance benchmark (optional; needs extracted game data).
find_package(Python3 COMPONENTS Interpreter)
if(NOT Python3_EXECUTABLE)
    return()
endif()

add_test(NAME Bench.DungeonFloor1
    COMMAND "${Python3_EXECUTABLE}" "${CMAKE_SOURCE_DIR}/scripts/port/bench_dungeon.py"
        --exe $<TARGET_FILE:darkchronicle>
        --work "${CMAKE_BINARY_DIR}/bench/dungeon-floor1")
set_tests_properties(Bench.DungeonFloor1 PROPERTIES
    SKIP_RETURN_CODE 77
    TIMEOUT 600
    RUN_SERIAL TRUE
    LABELS "bench;gpu")

add_test(NAME Bench.Runner
    COMMAND "${Python3_EXECUTABLE}" -m unittest discover
        -s "${CMAKE_SOURCE_DIR}/scripts/port" -p test_bench_dungeon.py)
set_tests_properties(Bench.Runner PROPERTIES TIMEOUT 30)
