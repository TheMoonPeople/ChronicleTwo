# Checks luau_prune.cmake on a scratch tree: it removes only the copies it recorded whose sources are gone and that are
# unchanged, and never a file it did not copy. Run with cmake -DPRUNE=<luau_prune.cmake> -DROOT=<scratch dir> -P.
cmake_minimum_required(VERSION 3.22)

file(REMOVE_RECURSE "${ROOT}")
set(sources "${ROOT}/sources")
set(scripts "${ROOT}/scripts")
set(expected "${ROOT}/expected.txt")
set(manifest "${ROOT}/manifest.txt")

function(prune)
    execute_process(COMMAND "${CMAKE_COMMAND}" "-DSCRIPTS=${scripts}" "-DSOURCES=${sources}" "-DEXPECTED=${expected}"
            "-DMANIFEST=${manifest}" -P "${PRUNE}"
        RESULT_VARIABLE result OUTPUT_VARIABLE output ERROR_VARIABLE output)
    if(NOT result EQUAL 0)
        message(FATAL_ERROR "luau_prune.cmake failed (${result}): ${output}")
    endif()
endfunction()

function(expect_present)
    foreach(relative IN LISTS ARGN)
        if(NOT EXISTS "${scripts}/${relative}")
            message(FATAL_ERROR "${relative} was removed")
        endif()
    endforeach()
endfunction()

# Copies every source, as the build's copy rules do.
function(copy)
    foreach(relative IN LISTS ARGN)
        file(READ "${sources}/${relative}" text)
        file(WRITE "${scripts}/${relative}" "${text}")
    endforeach()
endfunction()

foreach(relative IN ITEMS kept.luau gone.luau edited.luau dir/nested.luau)
    file(WRITE "${sources}/${relative}" "return {} -- ${relative}\n")
endforeach()
file(WRITE "${expected}" "kept.luau\ngone.luau\nedited.luau\ndir/nested.luau\n")
copy(kept.luau gone.luau edited.luau dir/nested.luau)
file(WRITE "${scripts}/user.luau" "return {}\n")
file(WRITE "${scripts}/user.txt" "notes\n")

# The first run has no manifest, so it removes nothing; a repeated run with the same list removes nothing either.
prune()
prune()
expect_present(kept.luau gone.luau edited.luau dir/nested.luau user.luau user.txt)

# Three sources go away; one of their copies was edited after it was copied.
file(REMOVE "${sources}/gone.luau" "${sources}/edited.luau" "${sources}/dir/nested.luau")
file(WRITE "${expected}" "kept.luau\n")
file(APPEND "${scripts}/edited.luau" "-- changed by hand\n")
prune()
expect_present(kept.luau edited.luau user.luau user.txt)
foreach(relative IN ITEMS gone.luau dir/nested.luau)
    if(EXISTS "${scripts}/${relative}")
        message(FATAL_ERROR "the obsolete copy ${relative} was kept")
    endif()
endforeach()

# A hand-written module with the name of a module that is no longer generated is not the build's copy.
file(WRITE "${scripts}/gone.luau" "return { hand = true }\n")
prune()
expect_present(gone.luau)

message("LUAU_PRUNE_OK")
