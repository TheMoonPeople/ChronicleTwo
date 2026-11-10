target_include_directories(darkchronicle_tests PRIVATE ${CMAKE_SOURCE_DIR}/tools/dc2data)
target_compile_definitions(darkchronicle_tests PRIVATE "DC2_DISC_DIR=\"${CMAKE_SOURCE_DIR}/rom/pal/extracted/iso\"")
target_compile_definitions(darkchronicle_tests PRIVATE "DC2_ISO_PATH=\"${CMAKE_SOURCE_DIR}/rom/pal/Dark Chronicle (PAL).iso\"")
