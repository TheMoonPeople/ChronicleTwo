#include "common.h"

extern int _sceSifLoadModuleBuffer(int, int, int, int);

extern int _sceSifLoadModuleBuffer(int, int, int, int);

extern int _sceSifLoadModule(int, int, int, int, int);

extern int _sceSifLoadElfPart(int, int, int, int);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/eeloadfile", _lf_bind);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/eeloadfile", _lf_version);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/eeloadfile", sceSifLoadFileReset);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/eeloadfile", _sceSifLoadModuleBuffer);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/eeloadfile", sceSifStopModule);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/eeloadfile", sceSifUnloadModule);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/eeloadfile", sceSifSearchModuleByName);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/eeloadfile", sceSifSearchModuleByAddress);

int sceSifLoadModuleBuffer(int a, int b, int c) {
    int k8d[4];
    return _sceSifLoadModuleBuffer(a, b, c, (int)k8d);
}

int sceSifLoadStartModuleBuffer(int a, int b, int c, int d) {
    return _sceSifLoadModuleBuffer(a, b, c, d);
}

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/eeloadfile", _sceSifLoadModule);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/eeloadfile", sceSifLoadModule);

int sceSifLoadStartModule(int a, int b, int c, int d) {
    return _sceSifLoadModule(a, b, c, d, 0);
}

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/eeloadfile", _sceSifLoadElfPart);

int sceSifLoadElfPart(int a, int b, int c) {
    return _sceSifLoadElfPart(a, b, c, 1);
}

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/eeloadfile", sceSifLoadElf);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/eeloadfile", sceSifGetIopAddr);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/eeloadfile", sceSifSetIopAddr);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/kernl/eeloadfile", _bind_check__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/kernl/eeloadfile", _lfwildcard__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/kernl/eeloadfile", D_003654E0__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/kernl/eeloadfile", D_003654E8__DATA);

INCLUDE_BSS(_senddata, 0x8);

INCLUDE_BSS(D_00382C88, 0x1F8);

INCLUDE_BSS(cd__2, 0x28);

INCLUDE_BSS(_lfversion, 0x18);
