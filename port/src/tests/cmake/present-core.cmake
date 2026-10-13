set(PRESENT_IDENTITY_SCRIPT ${CMAKE_CURRENT_LIST_DIR}/present_identity.cmake)
set(PRESENT_IDENTITY_WORK ${CMAKE_BINARY_DIR}/present_identity)

add_test(NAME PresentIdentity.DisplayPerTickScreenshot
    COMMAND ${CMAKE_COMMAND} -DEXE=$<TARGET_FILE:darkchronicle> -DWORK=${PRESENT_IDENTITY_WORK}
        -DDATA_VERSION_SOURCE=${KZ_ROOT}/data_version.json -P ${PRESENT_IDENTITY_SCRIPT})
set_tests_properties(PresentIdentity.DisplayPerTickScreenshot PROPERTIES
    TIMEOUT 240 RUN_SERIAL TRUE LABELS gpu)
