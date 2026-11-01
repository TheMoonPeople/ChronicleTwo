# Real-data initialization and delayed title/shop sound playback.
find_package(Python3 COMPONENTS Interpreter)
if(Python3_EXECUTABLE)
    foreach(case title shop costume)
        if(case STREQUAL "title")
            set(test_name TitleStart)
        elseif(case STREQUAL "shop")
            set(test_name ShopTransaction)
        else()
            set(test_name CostumeMusic)
        endif()
        add_test(NAME AudioReplay.${test_name}
            COMMAND "${Python3_EXECUTABLE}" "${CMAKE_SOURCE_DIR}/scripts/port/audio_replay.py"
                --exe $<TARGET_FILE:darkchronicle>
                --work "${CMAKE_BINARY_DIR}/audio-replays" --case "${case}")
        set_tests_properties(AudioReplay.${test_name} PROPERTIES
            SKIP_RETURN_CODE 77 TIMEOUT 630 RUN_SERIAL TRUE LABELS "replay;gpu;audio")
    endforeach()
endif()
