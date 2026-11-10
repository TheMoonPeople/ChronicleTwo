if(WIN32 AND TARGET darkchronicle_tests)
    # Linked as darkchronicle is, so a test sees the same above-4-GiB layout the game runs with.
    target_link_options(darkchronicle_tests PRIVATE -Wl,--dynamicbase -Wl,--high-entropy-va)
endif()
