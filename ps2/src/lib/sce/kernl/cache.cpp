#include "common.h"

extern void _sceSDC(unsigned a, unsigned b);

extern void _sceIDC(unsigned a, unsigned b);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/cache", _sceSDC);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/cache", SyncDCache);

void iSyncDCache(unsigned a, unsigned b) {
    _sceSDC(a & 0xFFFFFFC0, b & 0xFFFFFFC0);
}

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/cache", _sceIDC);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/cache", InvalidDCache);

void iInvalidDCache(unsigned a, unsigned b) {
    _sceIDC(a & 0xFFFFFFC0, b & 0xFFFFFFC0);
}
