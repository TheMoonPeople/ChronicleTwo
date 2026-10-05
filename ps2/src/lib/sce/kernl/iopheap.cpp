#include "common.h"

extern int sceSifFreeSysMemory(void *);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/iopheap", sceSifInitIopHeap);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/iopheap", sceSifAllocIopHeap);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/iopheap", sceSifAllocSysMemory);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/iopheap", sceSifFreeSysMemory);

int sceSifFreeIopHeap(void *a) {
    return sceSifFreeSysMemory(a);
}

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/iopheap", sceSifLoadIopHeap);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/kernl/iopheap", _bind__DATA);

INCLUDE_BSS(cd, 0x40);

INCLUDE_BSS(rdata, 0x40);

INCLUDE_BSS(sdata, 0x40);

INCLUDE_BSS(_lih_data, 0x100);
