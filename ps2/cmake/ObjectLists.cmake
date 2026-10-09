# Object rules, from what scripts/build/layout.py says about main.yaml.

# Ask layout.py for one of its listings, one row per list element. Each ask is
# a python process that reads the whole split configuration, so what a flag
# produced is kept for the rest of the configure run.
function(layout_rows flag out_var)
    string(MAKE_C_IDENTIFIER "layout_rows_${flag}" key)
    get_property(known GLOBAL PROPERTY ${key} SET)
    if(known)
        get_property(rows GLOBAL PROPERTY ${key})
        set(${out_var} "${rows}" PARENT_SCOPE)
        return()
    endif()

    execute_process(
        COMMAND ${PYTHON} ${SCRIPTS_DIR}/build/layout.py ${flag}
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        OUTPUT_VARIABLE rows
        RESULT_VARIABLE status
        OUTPUT_STRIP_TRAILING_WHITESPACE)
    if(NOT status EQUAL 0)
        message(FATAL_ERROR "scripts/build/layout.py ${flag} failed (${status})")
    endif()
    # Rows are tab-separated, and a list element cannot hold a `;`.
    string(REPLACE ";" "\\;" rows "${rows}")
    string(REPLACE "\n" ";" rows "${rows}")
    set_property(GLOBAL PROPERTY ${key} "${rows}")
    set(${out_var} "${rows}" PARENT_SCOPE)
endfunction()

# Create the directory of every object up front; neither the assembler nor
# MWCC creates one.
function(make_object_dirs objs)
    set(dirs "")
    foreach(obj IN LISTS objs)
        get_filename_component(dir ${CMAKE_SOURCE_DIR}/${obj} DIRECTORY)
        list(APPEND dirs ${dir})
    endforeach()
    list(REMOVE_DUPLICATES dirs)
    foreach(dir IN LISTS dirs)
        file(MAKE_DIRECTORY ${dir})
    endforeach()
endfunction()

# Assemble one file splat wrote: a library unit's whole-unit file, or one
# section of a data-only unit. `fixup_args` are the objcopy arguments
# fixup_sections.sh applies (each section's retail alignment).
function(add_asm_object obj src fixup_args)
    add_custom_command(
        OUTPUT ${CMAKE_SOURCE_DIR}/${obj}
        COMMAND ${AS} ${AS_FLAGS} -o ${obj} ${src}
        COMMAND sh ${SCRIPTS_DIR}/build/fixup_sections.sh ${obj} ${fixup_args}
        DEPENDS ${CMAKE_SOURCE_DIR}/${src}
                ${CMAKE_SOURCE_DIR}/${INCLUDE_DIR}/macro.inc
                ${CMAKE_SOURCE_DIR}/${SCRIPTS_DIR}/build/fixup_sections.sh
                ${CMAKE_SOURCE_DIR}/${SPLIT_STAMP}
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        COMMENT "AS ${src}"
        VERBATIM)
endfunction()

# Compile one game unit. tools/mwccgap puts retail's assembly wherever the
# source has an INCLUDE_ASM or INCLUDE_RODATA marker, reading the per-symbol
# files the split wrote, so every object depends on the split.
function(add_cpp_object obj src)
    add_custom_command(
        OUTPUT ${CMAKE_SOURCE_DIR}/${obj}
        COMMAND ${CMAKE_COMMAND} -E env
                MW_DIR=${MW_CC_DIR} MIPS_TOOL_PREFIX=${MIPS_TOOL_PREFIX}
                SATANSFIDDLE=${SATANSFIDDLE} SATANSFIDDLE_CONFIG=${SATANSFIDDLE_CONFIG}
                sh ${SCRIPTS_DIR}/build/mwccgap.sh ${obj} ${obj}.d ${src}
                ${CC_FLAGS} ${CC_DEP_FLAGS}
        COMMAND sh ${SCRIPTS_DIR}/build/fixup_sections.sh ${obj}
        DEPENDS ${CMAKE_SOURCE_DIR}/${src}
                ${CMAKE_SOURCE_DIR}/${SPLIT_STAMP}
                ${CMAKE_SOURCE_DIR}/${SCRIPTS_DIR}/build/mwccgap.sh
                ${CMAKE_SOURCE_DIR}/${SCRIPTS_DIR}/build/postprocess_object.py
                ${CMAKE_SOURCE_DIR}/${SCRIPTS_DIR}/build/objdiff_data.py
                ${CMAKE_SOURCE_DIR}/${SCRIPTS_DIR}/build/lcf.py
                ${CMAKE_SOURCE_DIR}/${SCRIPTS_DIR}/build/fixup_sections.sh
                ${MWCCGAP_SOURCES}
                ${SATANSFIDDLE_DEPENDENCIES}
        DEPFILE ${CMAKE_SOURCE_DIR}/${obj}.d
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        COMMENT "CC ${src}"
        VERBATIM)
endfunction()
