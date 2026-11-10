set(one_frame_script ${CMAKE_CURRENT_BINARY_DIR}/screenshot_one_frame.cmake)
file(WRITE ${one_frame_script} [=[
include("${EMPTY_DATA_FIXTURE}")
ct_empty_data_fixture("${ROOT}" "${DATA_VERSION_SOURCE}")
file(MAKE_DIRECTORY "${ROOT}/save")
file(WRITE "${ROOT}/config.json" "{\"video\":{\"interpolation\":false}}")
file(REMOVE "${ROOT}/frame.png" "${ROOT}/frame-display-0.png" "${ROOT}/frame-display-1.png")
execute_process(COMMAND "${EXE}" --headless --offscreen --data "${ROOT}/data" --save "${ROOT}/save"
    --frames 1 --screenshot "${ROOT}/frame.png" --screenshot-display 2
    RESULT_VARIABLE rc OUTPUT_VARIABLE out ERROR_VARIABLE err TIMEOUT 120)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "Capture failed: ${rc}\n${out}${err}")
endif()
foreach(name frame.png frame-display-0.png frame-display-1.png)
    if(NOT EXISTS "${ROOT}/${name}")
        message(FATAL_ERROR "Capture missing: ${name}\n${out}${err}")
    endif()
    file(SHA256 "${ROOT}/${name}" hash)
    if(name STREQUAL "frame.png")
        set(canonical ${hash})
    elseif(NOT hash STREQUAL canonical)
        message(FATAL_ERROR "Display image differs from the only tick: ${name}")
    endif()
endforeach()
message("ONE_FRAME_CAPTURE_OK")
]=])
add_test(NAME Screenshot.OneFrameCommandLine
    COMMAND ${CMAKE_COMMAND} -DEXE=$<TARGET_FILE:darkchronicle>
        -DROOT=${CMAKE_BINARY_DIR}/one-frame-capture
        -DEMPTY_DATA_FIXTURE=${CMAKE_CURRENT_LIST_DIR}/empty_data.cmake
        -DDATA_VERSION_SOURCE=${KZ_ROOT}/data_version.json -P ${one_frame_script})
set_tests_properties(Screenshot.OneFrameCommandLine PROPERTIES TIMEOUT 120 RUN_SERIAL TRUE LABELS gpu)
