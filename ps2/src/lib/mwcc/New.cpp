#include "common.h"
#include "std/exception.hpp"

extern char at_47[];

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/mwcc/New", default_new_handler__3stdFv);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/mwcc/New", __dt__Q23std9bad_allocFv);

const char *std::bad_alloc::what() const {
    return at_47;
}

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/mwcc/New", _new_handler_func__3std__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/mwcc/New", __throws_bad_alloc__3std__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/mwcc/New", at_34__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/mwcc/New", at_43__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/mwcc/New", at_45__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/mwcc/New", __RTTI__Q23std9exception__2__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/mwcc/New", at_44__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/mwcc/New", __RTTI__Q23std9bad_alloc__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/mwcc/New", at_47__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/mwcc/New", __vt__Q23std9bad_alloc__DATA);
