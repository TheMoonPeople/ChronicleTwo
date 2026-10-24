# Optimisation of the shipped configurations (docs/PC.md). Release, RelWithDebInfo and MinSizeRel link the
# game with link-time optimisation, so ps2/src, port/src and the host code inline across units; symbols.cmake
# keeps their line tables through it. x86-64 builds target x86-64-v2 (SSE4.2 and POPCNT) in every
# configuration. -ffp-contract=off still holds, so no configuration fuses multiply-adds.
#
# CT_LTO:
#   thin  ThinLTO, parallel and cached across links (the default).
#   full  one monolithic LTO module: slower and far heavier to link.
#   off   no link-time optimisation.
set(CT_LTO thin CACHE STRING "Link-time optimisation outside Debug: thin, full or off")
set_property(CACHE CT_LTO PROPERTY STRINGS thin full off)
if(NOT CT_LTO MATCHES "^(thin|full|off)$")
    message(FATAL_ERROR "CT_LTO must be thin, full or off, not '${CT_LTO}'")
endif()
set(CT_X86_64_LEVEL x86-64-v2 CACHE STRING "The -march baseline of x86-64 builds")

if(CMAKE_SYSTEM_PROCESSOR MATCHES "^(x86_64|AMD64|amd64)$")
    target_compile_options(ct_options INTERFACE -march=${CT_X86_64_LEVEL})
    target_compile_options(ct_host PRIVATE -march=${CT_X86_64_LEVEL})
endif()
# iOS 16, the minimum, runs only on A11 and later, so iOS builds target that core (ARMv8.2, with LSE atomics) rather
# than the toolchain's A7 baseline.
if(CMAKE_SYSTEM_NAME STREQUAL "iOS")
    target_compile_options(ct_options INTERFACE -mcpu=apple-a11)
    target_compile_options(ct_host PRIVATE -mcpu=apple-a11)
endif()

if(NOT CT_LTO STREQUAL "off")
    set(ct_optimised $<NOT:$<CONFIG:Debug>>)
    set(ct_lto_options $<${ct_optimised}:-flto=${CT_LTO}>)
    target_compile_options(ct_options INTERFACE ${ct_lto_options})
    target_compile_options(ct_host PRIVATE ${ct_lto_options})
    # The LTO backend takes its level from the link line, which CMake gives none.
    target_link_options(ct_options INTERFACE ${ct_lto_options}
        "$<${ct_optimised}:$<IF:$<CONFIG:MinSizeRel>,-Os,-O3>>")
    if(APPLE)
        # ld64 deletes the objects LTO generates once it links, and with them the DWARF dsymutil collects
        # into darkchronicle.dSYM; kept here, the dSYM still names file:line.
        set(ct_lto_objects ${CMAKE_BINARY_DIR}/lto/darkchronicle)
        if(CT_LTO STREQUAL "thin")
            file(MAKE_DIRECTORY ${ct_lto_objects})
        else()
            file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/lto)
            set(ct_lto_objects ${ct_lto_objects}.o)
        endif()
        target_link_options(darkchronicle PRIVATE $<${ct_optimised}:-Wl,-object_path_lto,${ct_lto_objects}>)
    elseif(CT_LTO STREQUAL "thin")
        target_link_options(ct_options INTERFACE
            $<${ct_optimised}:-Wl,--thinlto-cache-dir=${CMAKE_BINARY_DIR}/lto-cache/$<TARGET_PROPERTY:NAME>>)
    endif()
endif()
