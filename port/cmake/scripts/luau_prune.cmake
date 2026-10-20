# Removes the module copies a build or install made earlier whose sources are gone, such as scripts moved to the
# interpreter's fallback list, and records the copies it makes now.
#
# MANIFEST lists the copies made into SCRIPTS last time, one "<sha256> <path relative to SCRIPTS>" line each. A listed
# copy that EXPECTED (one path relative to SOURCES per line) no longer names is removed if it still holds the bytes it
# was copied with; a copy changed since is kept. Files the manifest does not list, such as hand-written modules, are
# never touched. The manifest is then rewritten with the hashes of the sources named in EXPECTED.
#
# Run with cmake -DSCRIPTS=<dir> -DSOURCES=<dir> -DEXPECTED=<file> -DMANIFEST=<file> -P luau_prune.cmake.
cmake_minimum_required(VERSION 3.22)

foreach(variable IN ITEMS SCRIPTS SOURCES EXPECTED MANIFEST)
    if(NOT DEFINED ${variable})
        message(FATAL_ERROR "luau_prune.cmake needs -D${variable}=...")
    endif()
endforeach()

file(STRINGS "${EXPECTED}" expected)
set(owned "")
if(EXISTS "${MANIFEST}")
    file(STRINGS "${MANIFEST}" owned)
endif()
foreach(line IN LISTS owned)
    string(LENGTH "${line}" length)
    if(length LESS 66)
        continue()
    endif()
    string(SUBSTRING "${line}" 0 64 recorded)
    string(SUBSTRING "${line}" 65 -1 relative)
    list(FIND expected "${relative}" at)
    if(NOT at EQUAL -1 OR NOT EXISTS "${SCRIPTS}/${relative}")
        continue()
    endif()
    file(SHA256 "${SCRIPTS}/${relative}" present)
    if(present STREQUAL recorded)
        file(REMOVE "${SCRIPTS}/${relative}")
        message(STATUS "Removed the obsolete script ${relative}")
    else()
        message(STATUS "Kept the obsolete script ${relative}, which was changed after it was copied")
    endif()
endforeach()

set(lines "")
foreach(relative IN LISTS expected)
    file(SHA256 "${SOURCES}/${relative}" hash)
    string(APPEND lines "${hash} ${relative}\n")
endforeach()
file(WRITE "${MANIFEST}" "${lines}")
