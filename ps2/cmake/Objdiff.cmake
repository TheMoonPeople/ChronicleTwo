# objdiff's two objects per game unit, its configuration, and m2c's context.
#
# The target is retail: the unit's whole reference file, assembled as splat
# wrote it. The base is the source alone, compiled by MWCC without
# tools/mwccgap, so a function still behind INCLUDE_ASM is absent from it and
# counts as not decompiled. A header changing recompiles every base: the set
# is small, and scripts/build/globs.sh reconfigures when one is added.

set(OBJDIFF_DIR ${BUILD_DIR}/objdiff)
set(OBJDIFF_CONFIG objdiff.json)
set(CTX ${BUILD_DIR}/ctx.c)
set(CTX_CPP ${BUILD_DIR}/ctx.cpp)

file(GLOB_RECURSE PROJECT_HEADERS
     ${CMAKE_SOURCE_DIR}/${INCLUDE_DIR}/*.hpp
     ${CMAKE_SOURCE_DIR}/${INCLUDE_DIR}/*.h)

set(OBJDIFF_OBJS "")
set(OBJDIFF_SOURCES "")
foreach(row IN LISTS unit_rows)
    string(REPLACE "\t" ";" parts "${row}")
    list(GET parts 0 kind)
    list(GET parts 1 unit)
    list(GET parts 2 source)
    list(GET parts 3 reference)
    if(NOT kind STREQUAL "cpp")
        continue()
    endif()

    set(target ${OBJDIFF_DIR}/target/${unit}.s.o)
    add_custom_command(
        OUTPUT ${CMAKE_SOURCE_DIR}/${target}
        COMMAND ${AS} ${AS_FLAGS} -o ${target} ${reference}
        DEPENDS ${CMAKE_SOURCE_DIR}/${INCLUDE_DIR}/macro.inc
                ${CMAKE_SOURCE_DIR}/${SPLIT_STAMP}
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        COMMENT "AS (objdiff target) ${reference}"
        VERBATIM)

    # `-lang` is given because the linked object's compile gives it too
    # (scripts/build/mwccgap.sh).
    set(base ${OBJDIFF_DIR}/base/${unit}.cpp.o)
    set(base_compiler ${WIBO} ${MW_CC_DIR}/mwccps2.exe ${CC_FLAGS} -lang c++)
    set(base_environment "MWCIncludes=${INCLUDE_DIR}/std\;${INCLUDE_DIR}/sce")
    set(gcc_config ${CMAKE_SOURCE_DIR}/${CONFIG_DIR}/gcc_units.txt)
    if(EXISTS ${gcc_config})
        file(STRINGS ${gcc_config} gcc_rows)
        foreach(gcc_row IN LISTS gcc_rows)
            separate_arguments(gcc_parts UNIX_COMMAND "${gcc_row}")
            list(GET gcc_parts 0 gcc_unit)
            if(unit STREQUAL gcc_unit)
                list(GET gcc_parts 1 version)
                set(base_compiler ${PYTHON} ${SCRIPTS_DIR}/build/ee_gcc.py -O2 -G0 -c)
                set(base_environment EE_GCC=${version} MIPS_TOOL_PREFIX=${MIPS_TOOL_PREFIX})
            endif()
        endforeach()
    endif()
    list(APPEND base_compiler -DMIGRATED_CPP)
    add_custom_command(
        OUTPUT ${CMAKE_SOURCE_DIR}/${base}
        COMMAND ${CMAKE_COMMAND} -E env ${base_environment}
                ${base_compiler}
                -o ${base} ${source}
        DEPENDS ${CMAKE_SOURCE_DIR}/${source} ${PROJECT_HEADERS}
                ${CMAKE_SOURCE_DIR}/${SCRIPTS_DIR}/build/ee_gcc.py
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        COMMENT "CC (objdiff base) ${source}"
        VERBATIM)

    list(APPEND OBJDIFF_OBJS ${target} ${base})
    list(APPEND OBJDIFF_SOURCES ${CMAKE_SOURCE_DIR}/${source})
endforeach()
make_object_dirs("${OBJDIFF_OBJS}")

set(OBJDIFF_ABS_OBJS "")
foreach(obj IN LISTS OBJDIFF_OBJS)
    list(APPEND OBJDIFF_ABS_OBJS ${CMAKE_SOURCE_DIR}/${obj})
endforeach()

# objdiff's GUI reads the configuration at the root of the tree.
add_custom_command(
    OUTPUT ${CMAKE_SOURCE_DIR}/${OBJDIFF_CONFIG}
    COMMAND ${PYTHON} ${SCRIPTS_DIR}/build/objdiff_config.py
            --build-dir ${BUILD_DIR} -o ${OBJDIFF_CONFIG}
    DEPENDS ${CMAKE_SOURCE_DIR}/${CONFIG_DIR}/main.yaml
            ${CMAKE_SOURCE_DIR}/${SCRIPTS_DIR}/build/objdiff_config.py
            ${CMAKE_SOURCE_DIR}/${SCRIPTS_DIR}/build/layout.py
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    COMMENT "Generating ${OBJDIFF_CONFIG}"
    VERBATIM)

add_custom_target(objdiff
    DEPENDS ${CMAKE_SOURCE_DIR}/${OBJDIFF_CONFIG} ${OBJDIFF_ABS_OBJS})

# m2c's context: every project header as one file of C declarations.
add_custom_command(
    OUTPUT ${CMAKE_SOURCE_DIR}/${CTX} ${CMAKE_SOURCE_DIR}/${CTX_CPP}
    COMMAND ${PYTHON} ${SCRIPTS_DIR}/diff/m2ctx.py -o ${CTX}
    DEPENDS ${PROJECT_HEADERS} ${CMAKE_SOURCE_DIR}/${SCRIPTS_DIR}/diff/m2ctx.py
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    COMMENT "Generating m2c context"
    VERBATIM)

add_custom_target(ctx DEPENDS ${CMAKE_SOURCE_DIR}/${CTX} ${CMAKE_SOURCE_DIR}/${CTX_CPP})
