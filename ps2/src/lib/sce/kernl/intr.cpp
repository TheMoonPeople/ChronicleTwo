#include "common.h"

int QueryIntrContext(void) {
    int s;
    __asm__ volatile("mfc0 %0, $12" : "=r"(s));
    return (s ^ 1) & 1;
}

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/intr", DisableIntc);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/intr", EnableIntc);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/intr", DisableDmac);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/intr", EnableDmac);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/intr", iEnableIntc);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/intr", iDisableIntc);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/intr", iEnableDmac);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/intr", iDisableDmac);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/intr", setup);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/intr", Copy);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/intr", kCopy);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/intr", GetEntryAddress);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/intr", InitAlarm);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/kernl/intr", srcfile__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/kernl/intr", eenull__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/kernl/intr", SysEntry__DATA);
