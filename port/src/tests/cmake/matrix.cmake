# Resolution and rate matrix per scene. matrix.py reads DC2_DATA from the environment at test time and
# exits 77 when there is no game data, numpy or Pillow.
find_package(Python3 COMPONENTS Interpreter)
if(NOT Python3_EXECUTABLE)
    return()
endif()

function(matrix_scene name input frame)
    string(TOLOWER "${name}" label)
    add_test(NAME Matrix.${name}
        COMMAND "${Python3_EXECUTABLE}" "${CMAKE_SOURCE_DIR}/scripts/port/matrix.py"
            --exe $<TARGET_FILE:darkchronicle> --input "${CMAKE_SOURCE_DIR}/${input}" --frame ${frame}
            --scene ${label} --work "${CMAKE_BINARY_DIR}/matrix/${label}" ${ARGN}
        WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}")
    set_tests_properties(Matrix.${name} PROPERTIES
        SKIP_RETURN_CODE 77 TIMEOUT 900 RUN_SERIAL TRUE LABELS "matrix;gpu")
endfunction()

matrix_scene(Title tools/input/sweep-title.input 2400)
matrix_scene(Costume tools/input/sweep-costume.input 1100 --jump title --fast-load)
set_tests_properties(Matrix.Costume PROPERTIES TIMEOUT 1800)

add_test(NAME Matrix.Runner
    COMMAND "${Python3_EXECUTABLE}" -m unittest discover
        -s "${CMAKE_SOURCE_DIR}/scripts/port" -p test_matrix.py)
set_tests_properties(Matrix.Runner PROPERTIES TIMEOUT 10)
