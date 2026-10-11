# The PS2 build: compiles every game unit with MWCC through Satan's Fiddle,
# assembles the library and data-only units from the split, links the
# executable with MWLD and verifies it against retail.
#
# Targets:
#   setup             check the disc, extract it and split the executable
#   disassemble       split the executable again
#   elf               link <build>/SCES_511.90
#   build (default)   elf, then verify it against retail
#   verify_extracted  check the files extracted from the disc
#   iso               master <build>/Dark Chronicle (PAL Build).iso
#   objdiff, ctx      objdiff's configuration and m2c's context (cmake/Objdiff.cmake)

set(BASENAME SCES_511.90)
set(RELEASE PAL)
set(RELEASE_DIR pal)

set(SRC_DIR ps2/src)
set(INCLUDE_DIR ps2/include)
set(CONFIG_DIR ps2/config/${RELEASE_DIR})
set(ASM_DIR ps2/asm/${RELEASE_DIR})
set(SCRIPTS_DIR scripts)
set(ROM_DIR rom/${RELEASE_DIR})
set(RETAIL_ISO "${ROM_DIR}/Dark Chronicle (${RELEASE}).iso")
set(EXTRACTED_DIR ${ROM_DIR}/extracted/iso)
set(EXTRACTED_ELF ${EXTRACTED_DIR}/${BASENAME})

file(RELATIVE_PATH BUILD_DIR ${CMAKE_SOURCE_DIR} ${CMAKE_BINARY_DIR})
set(OUTPUT ${BUILD_DIR}/${BASENAME})
set(BUILT_ISO "${BUILD_DIR}/Dark Chronicle (${RELEASE} Build).iso")

if(NOT EXISTS "${CMAKE_SOURCE_DIR}/${RETAIL_ISO}"
   AND NOT EXISTS "${CMAKE_SOURCE_DIR}/${EXTRACTED_ELF}")
    message(FATAL_ERROR
        "Nothing to split ${ASM_DIR}/ from. Place the ${RELEASE} disc image at "
        "${RETAIL_ISO}.")
endif()

find_program(PYTHON NAMES python3 python REQUIRED HINTS $ENV{VIRTUAL_ENV}/bin)

#
# Compiler and linker, for tools/kazarov/cmake/Kazarov.cmake
#

# Satan's Fiddle controls the compiler's state. The runner is an absolute path:
# kz-mwcc-exec runs the compiler in a private directory.
if(DEFINED ENV{SATANSFIDDLE})
    set(SATANSFIDDLE_DEFAULT "$ENV{SATANSFIDDLE}")
else()
    set(SATANSFIDDLE_DEFAULT satansfiddle)
endif()
set(SATANSFIDDLE "${SATANSFIDDLE_DEFAULT}"
    CACHE STRING "Satan's Fiddle executable or command")
if(DEFINED ENV{SATANSFIDDLE_CONFIG})
    set(SATANSFIDDLE_CONFIG_DEFAULT "$ENV{SATANSFIDDLE_CONFIG}")
else()
    set(SATANSFIDDLE_CONFIG_DEFAULT "${CMAKE_SOURCE_DIR}/scripts/build/satansfiddle.json")
endif()
set(SATANSFIDDLE_CONFIG "${SATANSFIDDLE_CONFIG_DEFAULT}"
    CACHE FILEPATH "Satan's Fiddle JSON compiler profile")

set(KZ_MWCC tools/compilers/mw/3.0-011126/mwccps2.exe)
set(KZ_MWLD tools/compilers/mw/2.4-001213/mwldps2.exe)
set(KZ_MWCC_RUNNER ${PYTHON} ${CMAKE_SOURCE_DIR}/${SCRIPTS_DIR}/build/satansfiddle-wibo.py)
set(KZ_LIB_INCLUDE_DIRS ps2/include/std ps2/include/sce)
set(KZ_AS_FLAGS -EL -march=r5900 -mabi=eabi -mno-pdr -non_shared -G0 -I ${INCLUDE_DIR})

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)
include(${CMAKE_SOURCE_DIR}/tools/kazarov/cmake/Kazarov.cmake)

# MWLD runs under wibo and links the executable from every object in
# <build>/main_o_files, placed by the linker script.
set(LD_FLAGS -map -nostdlib -m ENTRYPOINT -nodead -g)
set(LD_SCRIPT ${CONFIG_DIR}/${BASENAME}.lcf)

# Flags for the game units, in the order the compiler reads them. Each
# UNIT_CC_FLAGS_<unit> list is appended after CC_FLAGS, so its options
# override CC_FLAGS'.
set(CC_FLAGS -O3,p -strings readonly -c -Cpp_exceptions off -RTTI off
    -pragma "divbyzerocheck on" -i ${INCLUDE_DIR})
set(UNIT_CC_FLAGS_mg_dataset -O2,p)
set(UNIT_CC_FLAGS_mg_shadow -O2,p)
set(UNIT_CC_FLAGS_mg_tanime -O2,p)
set(UNIT_CC_FLAGS_mg_texture -O2,p)
set(UNIT_CC_FLAGS_password -O0)
set(UNIT_CC_FLAGS_scriptinterpreter -inline off)

# The compiler flags, for the diffing and decompiling tools.
string(JOIN " " CC_FLAGS_TEXT ${CC_FLAGS})
file(GENERATE OUTPUT ${CMAKE_BINARY_DIR}/compiler_flags.txt
     CONTENT "${CC_FLAGS_TEXT}\n")

set(SATANSFIDDLE_DEPENDENCIES
    ${CMAKE_SOURCE_DIR}/${SCRIPTS_DIR}/build/satansfiddle-wibo.py
    ${SATANSFIDDLE_CONFIG})
find_program(SATANSFIDDLE_EXECUTABLE NAMES "${SATANSFIDDLE}" NO_CACHE)
if(SATANSFIDDLE_EXECUTABLE)
    list(APPEND SATANSFIDDLE_DEPENDENCIES ${SATANSFIDDLE_EXECUTABLE})
endif()

# Configure reads main.yaml through layout.py, so either changing re-runs it.
set_property(DIRECTORY APPEND PROPERTY CMAKE_CONFIGURE_DEPENDS
    ${CMAKE_SOURCE_DIR}/${CONFIG_DIR}/main.yaml
    ${CMAKE_SOURCE_DIR}/${SCRIPTS_DIR}/build/layout.py)

include(ObjectLists)

#
# Setup: the disc, what is extracted from it, and the split
#

# ps2/asm/ is never committed. It is split from the executable extracted from the
# disc, which is checked against rom/pal/extracted.sha256 first.
set(TOOLS_DIR tools)
file(GLOB SPLAT_EXTENSIONS CONFIGURE_DEPENDS ${CMAKE_SOURCE_DIR}/${TOOLS_DIR}/splat_ext/*.py)

# The files the objects are assembled from are named as the split's byproducts,
# so a build of any target knows the split makes them.
layout_rows(--list-assembled assembled_rows)
set(SPLIT_FILES "")
foreach(row IN LISTS assembled_rows)
    string(REPLACE "\t" ";" parts "${row}")
    list(GET parts 1 reference)
    list(APPEND SPLIT_FILES ${CMAKE_SOURCE_DIR}/${reference})
endforeach()

kz_disc_setup(
    ISO "${RETAIL_ISO}"
    ISO_CHECKSUM ${ROM_DIR}/checksum.sha256
    EXTRACT_DIR ${ROM_DIR}/extracted
    INPUTS ${EXTRACTED_ELF}
    INPUTS_CHECKSUM ${ROM_DIR}/extracted.sha256
    INPUTS_CHECKSUM_DIR rom
    SPLIT_DIR ${ASM_DIR}
    SPLIT_STAMP ${ASM_DIR}.split-stamp
    SPLIT_COMMAND
        COMMAND ${PYTHON} -u ${SCRIPTS_DIR}/build/symbols.py --check
        COMMAND ${PYTHON} -u ${SCRIPTS_DIR}/build/disassemble.py
    SPLIT_DEPENDS
        ${CONFIG_DIR}/main.yaml
        ${CONFIG_DIR}/main.symbols.txt
        ${SCRIPTS_DIR}/build/symbols.py
        ${SCRIPTS_DIR}/build/disassemble.py
        ${SCRIPTS_DIR}/build/layout.py
        ${SPLAT_EXTENSIONS}
    SPLIT_BYPRODUCTS ${SPLIT_FILES})

#
# Objects
#

# Game units, compiled from ps2/src/<unit>.cpp.
layout_rows(--list-units unit_rows)
set(CPP_OBJS "")
set(MISSING_SOURCES "")
foreach(row IN LISTS unit_rows)
    string(REPLACE "\t" ";" parts "${row}")
    list(GET parts 0 kind)
    list(GET parts 1 unit)
    list(GET parts 2 source)
    if(kind STREQUAL "cpp")
        if(NOT EXISTS ${CMAKE_SOURCE_DIR}/${source})
            list(APPEND MISSING_SOURCES ${source})
        endif()
        set(obj ${BUILD_DIR}/obj/${unit}.cpp.o)
        list(APPEND CPP_OBJS ${obj})
        add_cpp_object(${obj} ${source} ${unit})
    endif()
endforeach()
if(MISSING_SOURCES)
    list(JOIN MISSING_SOURCES "\n  " missing)
    message(FATAL_ERROR "main.yaml names game units with no source:\n  ${missing}")
endif()

# Library units and data-only units, assembled from the split.
set(ASM_OBJS "")
set(DATA_OBJS "")
foreach(row IN LISTS assembled_rows)
    string(REPLACE "\t" ";" parts "${row}")
    list(GET parts 0 kind)
    list(GET parts 1 reference)
    list(GET parts 2 obj)
    list(LENGTH parts nparts)
    set(fixup_args "")
    if(nparts GREATER 3)
        list(GET parts 3 fixup_text)
        separate_arguments(fixup_args UNIX_COMMAND "${fixup_text}")
    endif()
    set(obj ${BUILD_DIR}/${obj})
    if(kind STREQUAL "data")
        list(APPEND DATA_OBJS ${obj})
    else()
        list(APPEND ASM_OBJS ${obj})
    endif()
    add_asm_object(${obj} ${reference} "${fixup_args}")
endforeach()

# A data-only unit is linked only when the linker script places its object;
# one the script writes itself (`.rdata`) stays out, or a wildcard would pull
# in a second copy.
if(EXISTS ${CMAKE_SOURCE_DIR}/${LD_SCRIPT})
    set_property(DIRECTORY APPEND PROPERTY CMAKE_CONFIGURE_DEPENDS
        ${CMAKE_SOURCE_DIR}/${LD_SCRIPT})
    file(READ ${CMAKE_SOURCE_DIR}/${LD_SCRIPT} lcf_text)
    set(placed "")
    foreach(obj IN LISTS DATA_OBJS)
        get_filename_component(name ${obj} NAME)
        string(FIND "${lcf_text}" "${name}" at)
        if(at GREATER_EQUAL 0)
            list(APPEND placed ${obj})
        endif()
    endforeach()
    set(DATA_OBJS ${placed})
endif()

set(ALL_OBJS ${CPP_OBJS} ${ASM_OBJS} ${DATA_OBJS})
kz_object_dirs(${ALL_OBJS})

#
# Link
#

# MWLD reads its objects from main_o_files: the units in link order, as
# layout.py gives it for build/pal, then the data-only objects the linker
# script places.
layout_rows(--link-order link_rows)
set(LINK_ORDER "")
foreach(path IN LISTS link_rows)
    string(REGEX REPLACE "^build/${RELEASE_DIR}/" "${BUILD_DIR}/" path "${path}")
    list(APPEND LINK_ORDER ${path})
endforeach()
list(APPEND LINK_ORDER ${DATA_OBJS})
list(REMOVE_DUPLICATES LINK_ORDER)
list(JOIN LINK_ORDER "\n" link_text)
set(MAIN_O_FILES ${BUILD_DIR}/main_o_files)
file(GENERATE OUTPUT ${CMAKE_SOURCE_DIR}/${MAIN_O_FILES} CONTENT "${link_text}\n")

set(ABS_OBJS "")
foreach(obj IN LISTS ALL_OBJS)
    list(APPEND ABS_OBJS ${CMAKE_SOURCE_DIR}/${obj})
endforeach()

add_custom_command(
    OUTPUT ${CMAKE_SOURCE_DIR}/${OUTPUT}
    COMMAND ${KZ_LD} ${LD_FLAGS} -o ${OUTPUT} ${LD_SCRIPT} @${MAIN_O_FILES}
    DEPENDS ${ABS_OBJS}
            ${CMAKE_SOURCE_DIR}/${LD_SCRIPT}
            ${CMAKE_SOURCE_DIR}/${MAIN_O_FILES}
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    COMMENT "Linking ${OUTPUT}"
    VERBATIM)

add_custom_target(elf DEPENDS ${CMAKE_SOURCE_DIR}/${OUTPUT})

#
# Verification
#

# BUILD_DIR names the build directory being verified.
set(VERIFY ${CMAKE_COMMAND} -E env BUILD_DIR=${BUILD_DIR}
    ${PYTHON} -u ${SCRIPTS_DIR}/build/verify.py)

add_custom_target(build ALL
    COMMAND ${VERIFY} -c
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    USES_TERMINAL
    VERBATIM)
add_dependencies(build elf)

add_custom_target(verify_extracted
    COMMAND ${VERIFY} -e
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    USES_TERMINAL
    VERBATIM)

#
# The disc image
#

if(EXISTS "${CMAKE_SOURCE_DIR}/${RETAIL_ISO}")
    add_custom_command(
        OUTPUT "${CMAKE_SOURCE_DIR}/${BUILT_ISO}"
        COMMAND ${PYTHON} -u ${SCRIPTS_DIR}/build/make_iso.py
                --source "${RETAIL_ISO}" --out "${BUILT_ISO}" ${OUTPUT}
        DEPENDS ${CMAKE_SOURCE_DIR}/${OUTPUT}
                ${KZ_EXTRACT_ID}
                ${CMAKE_SOURCE_DIR}/${SCRIPTS_DIR}/build/make_iso.py
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        COMMENT "Mastering ${BUILT_ISO}"
        USES_TERMINAL
        VERBATIM)
    add_custom_target(iso DEPENDS "${CMAKE_SOURCE_DIR}/${BUILT_ISO}")
else()
    add_custom_target(iso
        COMMAND ${CMAKE_COMMAND} -E echo "Mastering a disc needs ${RETAIL_ISO}."
        COMMAND ${CMAKE_COMMAND} -E false
        VERBATIM)
endif()

#
# objdiff and m2c
#

include(Objdiff)
