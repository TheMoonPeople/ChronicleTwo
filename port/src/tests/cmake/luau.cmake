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
