# Script decoder, command catalog and corpus survey that the Luau script replacement is built from.
add_test(NAME Luau.Tools
    COMMAND "${Python3_EXECUTABLE}" -m unittest discover -s "${CMAKE_SOURCE_DIR}/tools/luau" -p "test_*.py")
set_tests_properties(Luau.Tools PROPERTIES LABELS cpu TIMEOUT 60)

# The checked-in catalog and report must match the published corpus; skipped without game data.
add_test(NAME Luau.Survey
    COMMAND "${Python3_EXECUTABLE}" "${CMAKE_SOURCE_DIR}/tools/luau/survey.py" --check --dc2data $<TARGET_FILE:dc2data>)
set_tests_properties(Luau.Survey PROPERTIES LABELS cpu SKIP_RETURN_CODE 77 TIMEOUT 600)

# The runtime tests assemble a scripts directory from their modules and the shared vm library.
target_compile_definitions(darkchronicle_tests PRIVATE
    CT_TEST_LUAU_DIR="${CMAKE_SOURCE_DIR}/port/src/tests/luau"
    CT_LUAU_SOURCE_DIR="${CMAKE_SOURCE_DIR}/port/src/luau")

# The checked-in Luau action, effect and monster modules must match the transpiler's output and replay the reference VM's traces; skipped without game data or the harness tools.
add_test(NAME Luau.Transpile
    COMMAND "${Python3_EXECUTABLE}" "${CMAKE_SOURCE_DIR}/tools/luau/stb2luau/transpile.py" --check --harness
        --kind action --kind effect --kind monster)
set_tests_properties(Luau.Transpile PROPERTIES LABELS cpu SKIP_RETURN_CODE 77 TIMEOUT 900)

# The build and install remove only the module copies they made whose sources are gone, never other files.
add_test(NAME Luau.Prune
    COMMAND ${CMAKE_COMMAND} -DPRUNE=${CMAKE_SOURCE_DIR}/port/cmake/scripts/luau_prune.cmake
        -DROOT=${CMAKE_CURRENT_BINARY_DIR}/luau-prune -P ${CMAKE_SOURCE_DIR}/port/cmake/scripts/luau_prune_test.cmake)
set_tests_properties(Luau.Prune PROPERTIES PASS_REGULAR_EXPRESSION "LUAU_PRUNE_OK" LABELS cpu TIMEOUT 60)

# Every change to a native call argument of the sample modules that the handler would see must fail the harness;
# skipped without game data or the harness tools.
add_test(NAME Luau.Mutate
    COMMAND "${Python3_EXECUTABLE}" "${CMAKE_SOURCE_DIR}/tools/luau/stb2luau/mutate.py")
set_tests_properties(Luau.Mutate PROPERTIES LABELS cpu SKIP_RETURN_CODE 77 TIMEOUT 1800)
