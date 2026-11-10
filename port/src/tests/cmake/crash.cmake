# --crash-test MODE:early fires each failure the crash pipeline handles before the window opens, so these run
# without a GPU. Each run must end the way that failure always has and leave exactly one complete bundle.
# Crash.segv-frame fires at the end of the first game frame instead, so its report carries the game state.
set(crash_script ${CMAKE_CURRENT_BINARY_DIR}/crash_test.cmake)
file(WRITE ${crash_script} [=[
file(REMOVE_RECURSE "${ROOT}")
file(MAKE_DIRECTORY "${ROOT}/data" "${ROOT}/save")
if(FRAME_TEST)
    include("${EMPTY_DATA_FIXTURE}")
    ct_empty_data_fixture("${ROOT}" "${DATA_VERSION_SOURCE}")
    set(when --offscreen --crash-test "${MODE}")
else()
    set(when --crash-test "${MODE}:early")
endif()
execute_process(COMMAND "${EXE}" --headless --data "${ROOT}/data" --save "${ROOT}/save" ${when}
    RESULT_VARIABLE rc OUTPUT_VARIABLE out ERROR_VARIABLE err TIMEOUT 120)
set(run "exit: ${rc}\n${out}${err}")

# How the process ended. CMake reports death by a signal (POSIX) or an exception (Windows) as text, such as
# "Segmentation fault" or "Access violation", and an exit as its status.
if(STATUS STREQUAL "signal")
    if(rc MATCHES "^[0-9]+$")
        message(FATAL_ERROR "expected death by a signal or exception\n${run}")
    endif()
elseif(STATUS STREQUAL "abort")
    # abort(): SIGABRT on POSIX, the CRT's fast-fail status 0xC0000409 on Windows.
    if(WIN32)
        if(NOT rc MATCHES "[cC]0000409|^-1073740791$|^3221226505$")
            message(FATAL_ERROR "expected abort's status 0xC0000409\n${run}")
        endif()
    elseif(rc MATCHES "^[0-9]+$" AND NOT rc EQUAL 134)
        message(FATAL_ERROR "expected SIGABRT\n${run}")
    endif()
elseif(NOT rc STREQUAL STATUS)
    message(FATAL_ERROR "expected status ${STATUS}\n${run}")
endif()

file(GLOB bundles LIST_DIRECTORIES true "${ROOT}/save/crashes/*")
list(FILTER bundles EXCLUDE REGEX "last_crash\\.json$")
list(LENGTH bundles count)
if(NOT count EQUAL 1)
    message(FATAL_ERROR "expected one crash bundle, found ${count}: ${bundles}\n${run}")
endif()
set(report "${bundles}/report.txt")
if(NOT EXISTS "${report}")
    message(FATAL_ERROR "no report.txt in ${bundles}\n${run}")
endif()
file(READ "${report}" text)
foreach(section "Dark Chronicle crash report" "\n== exception ==\n" "\n== game state ==\n" "\nloop: " "\nlast asset: "
        "\n== raw frames ==\n#0 " "\n== stack trace ==\n" "\n== end ==\n")
    string(FIND "${text}" "${section}" at)
    if(at EQUAL -1)
        message(FATAL_ERROR "report.txt lacks \"${section}\"\n${text}")
    endif()
endforeach()
if(NOT text MATCHES "${EXCEPTION}")
    message(FATAL_ERROR "report.txt does not name ${EXCEPTION}\n${text}")
endif()
string(REGEX MATCH "== stack trace ==\n.*" trace "${text}")
if(NOT trace MATCHES "${FRAME}")
    message(FATAL_ERROR "the symbolised trace has no ${FRAME} frame\n${text}")
endif()
if(FRAME_TEST AND NOT text MATCHES "\nframe: +1\n.*\nloop: boot\n")
    message(FATAL_ERROR "the report lacks the first frame's game state\n${text}")
endif()
if(MODE STREQUAL "audio-thread" AND text MATCHES "thread: [0-9]+ [(]main[)]")
    message(FATAL_ERROR "the audio-thread fault was reported on the main thread\n${text}")
endif()
if(NOT EXISTS "${bundles}/darkchronicle.log")
    message(FATAL_ERROR "the session log was not copied into the bundle\n${text}")
endif()
if(NOT EXISTS "${ROOT}/config.json" OR EXISTS "${ROOT}/save/config.json" OR EXISTS "${ROOT}/save/logs")
    message(FATAL_ERROR "config and logs must live above the save root\n${run}")
endif()
if(NOT EXISTS "${bundles}/config.json")
    message(FATAL_ERROR "the configuration was not copied into the bundle\n${text}")
endif()
if(NOT EXISTS "${ROOT}/save/crashes/last_crash.json")
    message(FATAL_ERROR "no last_crash.json\n${run}")
endif()
message("CRASH_TEST_OK")
]=])

# mode, exit, what the report names, the symbolised frame
set(ct_crash_cases
    "segv|signal|EXCEPTION_ACCESS_VIOLATION|SIGSEGV|SIGBUS|CrashTestSegv"
    "abort|abort|abort\\(\\) called|CrashTestAbort"
    "assert|4|assertion failed: crash test|CrashTestAssert"
    "unimplemented|abort|not implemented on PC|CrashTestUnimplemented"
    "terminate|abort|uncaught exception std::runtime_error: crash test|CrashTestTerminate"
    "stackoverflow|signal|EXCEPTION_STACK_OVERFLOW|SIGSEGV|SIGBUS|CrashTestStackOverflow"
    "audio-thread|signal|EXCEPTION_ACCESS_VIOLATION|SIGSEGV|SIGBUS|CrashTestAudioCallback")
foreach(case IN LISTS ct_crash_cases)
    string(REPLACE "|" ";" fields "${case}")
    list(POP_FRONT fields mode status)
    list(POP_BACK fields frame)
    list(JOIN fields "|" exception)
    add_test(NAME Crash.${mode}
        COMMAND ${CMAKE_COMMAND} -DEXE=$<TARGET_FILE:darkchronicle> -DROOT=${CMAKE_BINARY_DIR}/crash-test/${mode}
            -DMODE=${mode} -DSTATUS=${status} "-DEXCEPTION=${exception}" -DFRAME=${frame} -P ${crash_script})
    set_tests_properties(Crash.${mode} PROPERTIES PASS_REGULAR_EXPRESSION "CRASH_TEST_OK" TIMEOUT 90
        ENVIRONMENT "DC2_CRASH_TEST=;DC2_LOG_FILE=1")
endforeach()

add_test(NAME Crash.segv-frame
    COMMAND ${CMAKE_COMMAND} -DEXE=$<TARGET_FILE:darkchronicle> -DROOT=${CMAKE_BINARY_DIR}/crash-test/segv-frame
        -DMODE=segv -DSTATUS=signal "-DEXCEPTION=EXCEPTION_ACCESS_VIOLATION|SIGSEGV|SIGBUS" -DFRAME=CrashTestSegv
        -DFRAME_TEST=ON -DEMPTY_DATA_FIXTURE=${CMAKE_CURRENT_LIST_DIR}/empty_data.cmake
        -DDATA_VERSION_SOURCE=${KZ_ROOT}/data_version.json -P ${crash_script})
set_tests_properties(Crash.segv-frame PROPERTIES PASS_REGULAR_EXPRESSION "CRASH_TEST_OK" TIMEOUT 150
    ENVIRONMENT "DC2_CRASH_TEST=;DC2_LOG_FILE=1" RUN_SERIAL TRUE LABELS gpu)
