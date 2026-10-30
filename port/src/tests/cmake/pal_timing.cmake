set(CT_PAL_TIMING_BASE "" CACHE STRING
    "Baseline ref for restoring PAL_TIMING wrappers to the original PS2 source")
if(CT_PAL_TIMING_BASE)
    add_test(NAME PalTiming.Ps2Identity
        COMMAND ${Python3_EXECUTABLE} ${CMAKE_SOURCE_DIR}/scripts/port/pal_timing_identity.py
            ${CT_PAL_TIMING_BASE} --root ${CMAKE_SOURCE_DIR})
    set_tests_properties(PalTiming.Ps2Identity PROPERTIES LABELS cpu TIMEOUT 120)
endif()
add_test(NAME PalTiming.IdentitySelfTest
    COMMAND ${Python3_EXECUTABLE} ${CMAKE_SOURCE_DIR}/scripts/port/pal_timing_identity.py --self-test)
set_tests_properties(PalTiming.IdentitySelfTest PROPERTIES LABELS cpu TIMEOUT 10)
add_test(NAME PalTiming.Sites
    COMMAND ${Python3_EXECUTABLE} ${CMAKE_SOURCE_DIR}/scripts/port/pal_timing_sites.py)
set_tests_properties(PalTiming.Sites PROPERTIES LABELS cpu TIMEOUT 10)
add_test(NAME PalTiming.SitesSelfTest
    COMMAND ${Python3_EXECUTABLE} ${CMAKE_SOURCE_DIR}/scripts/port/pal_timing_sites.py --self-test)
set_tests_properties(PalTiming.SitesSelfTest PROPERTIES LABELS cpu TIMEOUT 10)
