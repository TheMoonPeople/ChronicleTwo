if(NOT WIN32)
    find_package(Python3 COMPONENTS Interpreter)

    # No build dependency on darkchronicle: ctest runs after the build and reads the binary from CMAKE_BINARY_DIR.
    add_test(NAME Truncations.Check
        COMMAND sh -c [=[
            if ! "$0" -c "import clang.cindex" >/dev/null 2>&1; then exit 77; fi
            exec "$0" "$1" --build "$2" --check
        ]=] "${Python3_EXECUTABLE}" "${CMAKE_SOURCE_DIR}/scripts/port/truncations.py" "${CMAKE_BINARY_DIR}"
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR})
    set_tests_properties(Truncations.Check PROPERTIES SKIP_RETURN_CODE 77 TIMEOUT 1200)
endif()
