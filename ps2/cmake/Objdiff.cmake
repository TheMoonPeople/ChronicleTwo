# objdiff's two objects per game unit, its configuration, and m2c's context.
#
# The target is retail: the unit's whole reference file, assembled as splat
# wrote it. The base is the source alone, compiled by add_cpp_object in
# ObjectLists.cmake, so a function the source does not define is absent from it
# and counts as not decompiled. Each base depends on the headers it includes.

set(OBJDIFF_DIR ${BUILD_DIR}/objdiff)
set(OBJDIFF_CONFIG objdiff.json)
set(CTX ${BUILD_DIR}/ctx.c)
set(CTX_CPP ${BUILD_DIR}/ctx.cpp)

# The graph tests clear this: a dry run cannot re-check globs.
if(NOT DEFINED HEADER_GLOB_FLAGS)
    set(HEADER_GLOB_FLAGS CONFIGURE_DEPENDS)
endif()
file(GLOB_RECURSE PROJECT_HEADERS ${HEADER_GLOB_FLAGS}
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
    kz_asm_object(${target} ${reference}
        POST COMMAND ${PYTHON} ${SCRIPTS_DIR}/build/prepare_objdiff_target.py
                     ${target} ${reference} --objcopy ${KZ_OBJCOPY}
        DEPENDS ${INCLUDE_DIR}/macro.inc
                ${KZ_SPLIT_STAMP}
                ${SCRIPTS_DIR}/build/prepare_objdiff_target.py
                ${SCRIPTS_DIR}/build/layout.py
                ${CONFIG_DIR}/main.symbols.txt
        COMMENT "AS (objdiff target) ${reference}")

    set(base ${OBJDIFF_DIR}/base/${unit}.cpp.o)
    list(APPEND OBJDIFF_OBJS ${target} ${base})
    foreach(copy ${OBJDIFF_DIR}/compare/base/${unit}.cpp.o
                 ${OBJDIFF_DIR}/compare/target/${unit}.s.o)
        list(APPEND OBJDIFF_COMPARE_FILES
             ${CMAKE_SOURCE_DIR}/${copy} ${CMAKE_SOURCE_DIR}/${copy}.json)
    endforeach()
    list(APPEND OBJDIFF_SOURCES ${CMAKE_SOURCE_DIR}/${source})
endforeach()
kz_object_dirs(${OBJDIFF_OBJS})

# Source cuts and function/fallback classification affect the global split.
# Kept beside the split stamp so a clean build does not re-split; restat keeps its timestamp when unchanged.
set(SOURCE_CUTS ps2/asm/pal.source-cuts.txt)
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
    OUTPUT ${KZ_SPLIT_STAMP}
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
            ${KZ_PYTHONPATH}/kazarov_elf/__init__.py
            ${OBJDIFF_ABS_OBJS} ${OBJDIFF_SOURCES}
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    COMMENT "Generating ${OBJDIFF_CONFIG}"
    VERBATIM)

add_custom_target(objdiff
    DEPENDS ${CMAKE_SOURCE_DIR}/${OBJDIFF_CONFIG} ${OBJDIFF_ABS_OBJS})

# m2c's context: every project header as one file of C declarations.
kz_ctx(OUTPUT ${CTX} ${CTX_CPP} HEADERS ${PROJECT_HEADERS})
