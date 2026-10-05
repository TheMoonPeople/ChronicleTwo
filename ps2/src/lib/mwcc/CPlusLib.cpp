#include "common.h"
#include "std/exception.hpp"

extern char at_204[];

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/mwcc/CPlusLib", __construct_array);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/mwcc/CPlusLib", __construct_new_array);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/mwcc/CPlusLib", __dl__FPv);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/mwcc/CPlusLib", __dt__Q23std9exceptionFv);

const char *std::exception::what() const {
    return at_204;
}

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/mwcc/CPlusLib", at_196__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/mwcc/CPlusLib", __RTTI__Q23std9exception__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/mwcc/CPlusLib", at_204__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/mwcc/CPlusLib", __vt__Q23std9exception__DATA);
