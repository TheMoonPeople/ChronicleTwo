#include "common.h"

extern int sceDmaDebugMode;

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libdma", memclr);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libdma", sceDmaGetChan);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libdma", sceDmaReset);

int sceDmaDebug(int m) {
    int o = sceDmaDebugMode;
    sceDmaDebugMode = m;
    return o;
}

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libdma", sceDmaPutEnv);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libdma", sceDmaGetEnv);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libdma", sceDmaPutStallAddr);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libdma", sceDmaSend);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libdma", sceDmaSendN);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libdma", sceDmaSendI);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libdma", sceDmaRecv);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libdma", sceDmaRecvN);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libdma", sceDmaRecvI);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libdma", sceDmaSync);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libdma", sceDmaWatch);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libdma", sceDmaPause);

int sceDmaRestart(volatile unsigned *p, unsigned v) {
    unsigned o = *p;
    *p = v;
    return (o >> 8) & 1;
}

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libdma", dch__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libdma", sceDmaDebugMode__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libdma", __ps2_libinfo____2__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libdma", isclr__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libdma", ststbl__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libdma", stdtbl__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libdma", mfdtbl__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libdma", sceDmaCurrentEnv__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libdma", D_00363D30__DATA);
