# Quill, the port's logger (docs/LOGGING.md): log calls only copy their arguments into a per-thread queue, and
# one backend thread formats and writes them. Header-only; port/src/log wraps it.
include(FetchContent)
FetchContent_Declare(quill
    URL https://codeload.github.com/odygrd/quill/tar.gz/refs/tags/v13.1.0
    URL_HASH SHA256=a08b93bafc7e712b28eb47e4a1ed9b60fc01ac7fad3ce269f1f100560a506a85
    DOWNLOAD_EXTRACT_TIMESTAMP FALSE
    # An installed Quill of this version (the Flatpak's module, built offline) is used when one is found.
    FIND_PACKAGE_ARGS 13.1.0 EXACT CONFIG)
FetchContent_MakeAvailable(quill)

# Dependencies must not disable diagnostics in native consumers.
if(TARGET quill)
    get_target_property(CT_QUILL_OPTIONS quill INTERFACE_COMPILE_OPTIONS)
    if(CT_QUILL_OPTIONS)
        list(FILTER CT_QUILL_OPTIONS EXCLUDE REGEX "-Wno-")
        set_property(TARGET quill PROPERTY INTERFACE_COMPILE_OPTIONS "${CT_QUILL_OPTIONS}")
    endif()
endif()


# Statements below this level are compiled out; the runtime level (log.level) filters the rest.
set(CT_LOG_COMPILE_LEVEL Trace CACHE STRING "Lowest log level compiled in: Trace, Debug, Info, Warning, Error or Critical")
set_property(CACHE CT_LOG_COMPILE_LEVEL PROPERTY STRINGS Trace Debug Info Warning Error Critical)
set(ct_quill_levels Trace TRACE_L1 Debug DEBUG Info INFO Warning WARNING Error ERROR Critical CRITICAL)
list(FIND ct_quill_levels "${CT_LOG_COMPILE_LEVEL}" ct_quill_level_index)
math(EXPR ct_quill_level_odd "${ct_quill_level_index} % 2")
if(ct_quill_level_index LESS 0 OR ct_quill_level_odd)
    message(FATAL_ERROR "CT_LOG_COMPILE_LEVEL must be Trace, Debug, Info, Warning, Error or Critical")
endif()
math(EXPR ct_quill_level_index "${ct_quill_level_index} + 1")
list(GET ct_quill_levels ${ct_quill_level_index} ct_quill_level)

target_link_libraries(ct_options INTERFACE quill::quill)
target_compile_definitions(ct_options INTERFACE QUILL_DISABLE_NON_PREFIXED_MACROS QUILL_DISABLE_FUNCTION_NAME
    QUILL_COMPILE_ACTIVE_LOG_LEVEL=QUILL_COMPILE_ACTIVE_LOG_LEVEL_${ct_quill_level})
