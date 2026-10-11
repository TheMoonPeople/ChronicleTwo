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
    string(REPLACE ";" "\;" rows "${rows}")
    string(REPLACE "\n" ";" rows "${rows}")
    set_property(GLOBAL PROPERTY ${key} "${rows}")
    set(${out_var} "${rows}" PARENT_SCOPE)
endfunction()

# Assemble one file splat wrote: a library unit's whole-unit file, or one
# section of a data-only unit. `fixup_args` are the objcopy arguments
# fixup_sections.sh applies (each section's retail alignment).
function(add_asm_object obj src fixup_args)
    kz_asm_object(${obj} ${src}
        POST COMMAND sh ${SCRIPTS_DIR}/build/fixup_sections.sh ${obj} ${fixup_args}
        DEPENDS ${INCLUDE_DIR}/macro.inc
                ${SCRIPTS_DIR}/build/fixup_sections.sh
                ${KZ_SPLIT_STAMP})
endfunction()

# Compile one game unit with MWCC through Satan's Fiddle. The compile is also the
# objdiff base, the source alone, so it lands in objdiff/base; the linked object is that
# compile, copied and postprocessed. The two share one compile.
function(add_cpp_object obj src unit)
    get_filename_component(logical_source "${src}" NAME)
    if(src MATCHES "\\.c$")
        set(lang c)
    else()
        set(lang c++)
    endif()

    set(base ${BUILD_DIR}/objdiff/base/${unit}.cpp.o)
    kz_mwcc_object(${base} ${src}
        FLAGS -lang ${lang} ${CC_FLAGS} ${UNIT_CC_FLAGS_${unit}}
        ENV SATANSFIDDLE=${SATANSFIDDLE} SATANSFIDDLE_CONFIG=${SATANSFIDDLE_CONFIG}
            SATANSFIDDLE_TRANSLATION_UNIT=${logical_source}
        DEPENDS ${SATANSFIDDLE_DEPENDENCIES}
        COMMENT "CC ${src}")

    kz_absolute_path(${obj} obj_abs)
    kz_absolute_path(${base} base_abs)
    add_custom_command(
        OUTPUT ${obj_abs}
        COMMAND ${CMAKE_COMMAND} -E copy ${base_abs} ${obj_abs}
        COMMAND ${CMAKE_COMMAND} -E env PYTHONPATH=${KZ_PYTHONPATH}
                ${PYTHON} ${SCRIPTS_DIR}/build/postprocess_object.py ${obj}
        COMMAND ${CMAKE_COMMAND} -E env PYTHONPATH=${KZ_PYTHONPATH}
                sh ${SCRIPTS_DIR}/build/fixup_sections.sh ${obj}
        DEPENDS ${base_abs}
                ${CMAKE_SOURCE_DIR}/${SCRIPTS_DIR}/build/postprocess_object.py
                ${CMAKE_SOURCE_DIR}/${SCRIPTS_DIR}/build/fixup_sections.sh
                ${KZ_PYTHONPATH}/kazarov_elf/__init__.py
                ${KZ_SPLIT_STAMP}
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        COMMENT "POST ${src}"
        VERBATIM)
endfunction()
