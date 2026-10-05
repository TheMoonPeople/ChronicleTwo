#include "common.h"

extern void InitTLB(void);

void TerminateLibrary(void) {
    InitTLB();
}

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/exit", ExecPS2);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/exit", LoadExecPS2);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/exit", Exit__2);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/exit", ExecOSD);
