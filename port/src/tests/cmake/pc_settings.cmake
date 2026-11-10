# Optional real-data replay gates: each run gets its own save root and display captures.
find_package(Python3 COMPONENTS Interpreter)
if(Python3_EXECUTABLE)
    foreach(case pad mouse zoom)
        add_test(NAME PcSettingsReplay.${case}
            COMMAND "${Python3_EXECUTABLE}" "${CMAKE_SOURCE_DIR}/scripts/port/pc_settings_replay.py"
                --exe $<TARGET_FILE:darkchronicle>
                --work "${CMAKE_BINARY_DIR}/pc-settings-replays" --case "${case}")
        set_tests_properties(PcSettingsReplay.${case} PROPERTIES
            SKIP_RETURN_CODE 77 TIMEOUT 120 RUN_SERIAL TRUE LABELS "replay;gpu")
    endforeach()
endif()
