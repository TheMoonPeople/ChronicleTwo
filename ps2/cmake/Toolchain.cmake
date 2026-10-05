# The tools the PS2 build runs, and their flags: the one place to change them.

set(MIPS_TOOL_PREFIX mips-ps2-decompals-
    CACHE STRING "Prefix of the binutils-mips-ps2-decompals tools")
set(AS ${MIPS_TOOL_PREFIX}as)

# GNU as, for the split assembly of the library units and the data-only units.
set(AS_FLAGS -EL -march=r5900 -mabi=eabi -mno-pdr -non_shared -G0 -I ${INCLUDE_DIR})

# MWCC, through tools/mwccgap (scripts/build/mwccgap.sh), for the game units.
# `-MD` has it write the header dependencies the wrapper turns into a depfile.
set(MW_CC_DIR ${TOOLS_DIR}/compilers/mw/3.0-011126
    CACHE STRING "Directory holding mwccps2.exe")
set(CC_FLAGS -O3,p -strings readonly -c -Cpp_exceptions off -RTTI off -i ${INCLUDE_DIR})
set(CC_DEP_FLAGS -MD)
option(MIGRATED_CPP "Compile migrated C++ whose instructions or layout differ from retail" OFF)

# MWLD, run under wibo, links the executable from every object in
# <build>/main_o_files, placed by the linker script.
set(MW_LD ${TOOLS_DIR}/compilers/mw/2.4-001213/mwldps2.exe
    CACHE STRING "The MWLD executable that links the game")
set(LD ${WIBO} ${MW_LD})
set(LD_FLAGS -map -nostdlib -m ENTRYPOINT -nodead -g)
set(LD_SCRIPT ${CONFIG_DIR}/${BASENAME}.lcf)
