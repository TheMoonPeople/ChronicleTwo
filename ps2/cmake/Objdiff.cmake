# objdiff's two objects per game unit, its configuration, and m2c's context.
#
# The target is retail: the unit's whole reference file, assembled as splat
# wrote it. The base is the source alone, compiled through Satan's Fiddle without
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
set(OBJDIFF_COMPARE_FILES "")
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
        COMMAND ${PYTHON} ${SCRIPTS_DIR}/build/prepare_objdiff_target.py
                ${target} ${reference} --objcopy ${MIPS_TOOL_PREFIX}objcopy
        DEPENDS ${CMAKE_SOURCE_DIR}/${INCLUDE_DIR}/macro.inc
                ${CMAKE_SOURCE_DIR}/${SPLIT_STAMP}
                ${CMAKE_SOURCE_DIR}/${SCRIPTS_DIR}/build/prepare_objdiff_target.py
                ${CMAKE_SOURCE_DIR}/${SCRIPTS_DIR}/build/layout.py
                ${CMAKE_SOURCE_DIR}/${CONFIG_DIR}/main.symbols.txt
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        COMMENT "AS (objdiff target) ${reference}"
        VERBATIM)

    # `-lang` is given because the linked object's compile gives it too
    # (scripts/build/mwccgap.sh).
    set(base ${OBJDIFF_DIR}/base/${unit}.cpp.o)
    get_filename_component(logical_source "${source}" NAME)
    add_custom_command(
        OUTPUT ${CMAKE_SOURCE_DIR}/${base}
        COMMAND ${CMAKE_COMMAND} -E env "MWCIncludes=${INCLUDE_DIR}/std;${INCLUDE_DIR}/sce"
                SATANSFIDDLE=${SATANSFIDDLE} SATANSFIDDLE_CONFIG=${SATANSFIDDLE_CONFIG}
                SATANSFIDDLE_TRANSLATION_UNIT=${logical_source}
                ${PYTHON} ${SCRIPTS_DIR}/build/satansfiddle-wibo.py
                ${MW_CC_DIR}/mwccps2.exe ${CC_FLAGS} -lang c++
                -o ${base} ${source}
        DEPENDS ${CMAKE_SOURCE_DIR}/${source} ${PROJECT_HEADERS}
                ${SATANSFIDDLE_DEPENDENCIES}
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        COMMENT "CC (objdiff base) ${source}"
        VERBATIM)

    list(APPEND OBJDIFF_OBJS ${target} ${base})
    foreach(copy ${OBJDIFF_DIR}/compare/base/${unit}.cpp.o
                 ${OBJDIFF_DIR}/compare/target/${unit}.s.o)
        list(APPEND OBJDIFF_COMPARE_FILES
             ${CMAKE_SOURCE_DIR}/${copy} ${CMAKE_SOURCE_DIR}/${copy}.json)
    endforeach()
    list(APPEND OBJDIFF_SOURCES ${CMAKE_SOURCE_DIR}/${source})
endforeach()
make_object_dirs("${OBJDIFF_OBJS}")

# Source cuts and function/fallback classification affect the global split.
# Ninja's restat avoids rebuilding the split when this file keeps its timestamp.
set(SOURCE_CUTS ${BUILD_DIR}/source_cuts.txt)
add_custom_command(
    OUTPUT ${CMAKE_SOURCE_DIR}/${SOURCE_CUTS}
    COMMAND ${PYTHON} ${SCRIPTS_DIR}/build/source_cuts.py
            ${SOURCE_CUTS} ${OBJDIFF_SOURCES}
    DEPENDS ${OBJDIFF_SOURCES}
            ${CMAKE_SOURCE_DIR}/${SCRIPTS_DIR}/build/source_cuts.py
            ${CMAKE_SOURCE_DIR}/${SCRIPTS_DIR}/build/disassemble.py
            ${CMAKE_SOURCE_DIR}/${SCRIPTS_DIR}/build/layout.py
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    COMMENT "Checking source split inputs"
    VERBATIM)
add_custom_command(
    OUTPUT ${CMAKE_SOURCE_DIR}/${SPLIT_STAMP}
    APPEND DEPENDS ${CMAKE_SOURCE_DIR}/${SOURCE_CUTS})

set(OBJDIFF_ABS_OBJS "")
foreach(obj IN LISTS OBJDIFF_OBJS)
    list(APPEND OBJDIFF_ABS_OBJS ${CMAKE_SOURCE_DIR}/${obj})
endforeach()

# objdiff's GUI reads the configuration at the root of the tree.
add_custom_command(
    OUTPUT ${CMAKE_SOURCE_DIR}/${OBJDIFF_CONFIG}
    BYPRODUCTS ${OBJDIFF_COMPARE_FILES}
    COMMAND ${PYTHON} ${SCRIPTS_DIR}/build/objdiff_config.py
            --build-dir ${BUILD_DIR} -o ${OBJDIFF_CONFIG}
    DEPENDS ${CMAKE_SOURCE_DIR}/${CONFIG_DIR}/main.yaml
            ${CMAKE_SOURCE_DIR}/${SCRIPTS_DIR}/build/objdiff_config.py
            ${CMAKE_SOURCE_DIR}/${CONFIG_DIR}/main.symbols.txt
            ${CMAKE_SOURCE_DIR}/${EXTRACTED_ELF}
            ${CMAKE_SOURCE_DIR}/${SCRIPTS_DIR}/build/layout.py
            ${CMAKE_SOURCE_DIR}/${SCRIPTS_DIR}/build/objdiff_data.py
            ${CMAKE_SOURCE_DIR}/${SCRIPTS_DIR}/build/postprocess_object.py
            ${CMAKE_SOURCE_DIR}/${SCRIPTS_DIR}/build/disassemble.py
            ${CMAKE_SOURCE_DIR}/${SCRIPTS_DIR}/build/lcf.py
            ${MWCCGAP_SOURCES}
            ${OBJDIFF_ABS_OBJS} ${OBJDIFF_SOURCES}
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
