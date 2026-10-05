#include "common.h"

extern char gp_6[];

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libgraph", sceGsResetGraph);

void *sceGsGetGParam(void) {
    return gp_6;
}

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libgraph", sceGsResetPath);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libgraph", sceGsSetDefDispEnv);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libgraph", sceGsPutDispEnv);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libgraph", sceGszbufaddr);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libgraph", sceGsSetDefDrawEnv);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libgraph", sceGsSetDefClear);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libgraph", sceGsPutDrawEnv);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libgraph", sceGsSetDefDBuff);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libgraph", sceGsSwapDBuff);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libgraph", sceGsSyncV);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libgraph", sceGsSyncPath);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libgraph", sceGsSetDefLoadImage);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libgraph", sceGsSetDefStoreImage);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libgraph", sceGsExecLoadImage);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libgraph", sceGsExecStoreImage);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libgraph", sceGsSyncVCallback);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libgraph", __ps2_libinfo____DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libgraph", gp_6__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libgraph", init_vif_regs_3__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libgraph", init_mp3_3__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libgraph", D_00363808__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libgraph", D_00363840__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libgraph", D_00363870__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libgraph", D_003638A0__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libgraph", D_003638B0__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libgraph", D_003638C0__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libgraph", D_003638D0__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libgraph", D_003638E0__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libgraph", D_003638F0__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libgraph", D_00363900__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libgraph", D_00363910__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libgraph", D_00363920__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libgraph", D_00363938__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libgraph", D_00363950__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libgraph", D_00363980__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libgraph", D_003639B0__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libgraph", D_003639D8__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libgraph", D_00363A00__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libgraph", D_00363B20__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libgraph", D_00363B60__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libgraph", D_00363B98__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libgraph", D_00363BC8__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libgraph", D_00363C08__DATA);
