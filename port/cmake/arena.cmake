if(WIN32 AND TARGET darkchronicle)
    # The image and every mapping land above 4 GiB, so a pointer the game truncates to 32 bits faults
    # at once. These are lld's MinGW defaults, pinned so a toolchain change cannot drop them.
    target_link_options(darkchronicle PRIVATE -Wl,--dynamicbase -Wl,--high-entropy-va)
endif()
