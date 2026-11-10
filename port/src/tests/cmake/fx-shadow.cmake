# PS2-format geometry is a test oracle only: the game runs the native vu1 helpers.
target_sources(darkchronicle_tests PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/vu1_oracle/sdw_oracle.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/vu1_oracle/water_oracle.cpp)
