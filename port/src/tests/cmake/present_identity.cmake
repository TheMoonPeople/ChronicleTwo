# The tests CMakeLists includes every cmake/*.cmake at configure time; only the -P run may execute this.
if(NOT CMAKE_SCRIPT_MODE_FILE)
    return()
endif()

# Run with -DEXE=<darkchronicle> -DWORK=<scratch dir>. The canonical image must not depend on display renders.
if(NOT DEFINED EXE OR NOT DEFINED WORK)
    message(FATAL_ERROR "present_identity.cmake needs -DEXE and -DWORK")
endif()

set(DATA "${WORK}/data")
file(REMOVE_RECURSE "${WORK}")
include("${CMAKE_CURRENT_LIST_DIR}/empty_data.cmake")
ct_empty_data_fixture("${WORK}" "${DATA_VERSION_SOURCE}")

function(run_headless name)
    set(save "${WORK}/${name}-save")
    set(png "${WORK}/${name}.png")
    file(MAKE_DIRECTORY "${save}")
    execute_process(COMMAND "${EXE}" --headless --offscreen --data "${DATA}" --save "${save}"
        --frames 3 --screenshot "${png}" ${ARGN}
        RESULT_VARIABLE rc OUTPUT_VARIABLE out ERROR_VARIABLE err TIMEOUT 120)
    message("${out}${err}")
    if(NOT rc EQUAL 0)
        message(FATAL_ERROR "${name}: darkchronicle exited with ${rc}")
    endif()
    if(NOT EXISTS "${png}")
        message(FATAL_ERROR "${name}: no screenshot at ${png}")
    endif()
endfunction()

run_headless(plain)
run_headless(display --display-per-tick 4)

execute_process(COMMAND "${CMAKE_COMMAND}" -E compare_files "${WORK}/plain.png" "${WORK}/display.png"
    RESULT_VARIABLE differ)
if(NOT differ EQUAL 0)
    message(FATAL_ERROR "screenshot with --display-per-tick 4 differs from the plain run")
endif()
message("PRESENT_IDENTITY_OK")
