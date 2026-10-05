#include "common.h"

extern int _fs_semid;
extern int SignalSema(int);

extern int _sceCallCode(const char *, int);

extern int _sceCallCode(const char *, int);

extern int _sceCallCode(const char *, int);

extern int _sceCallCode(const char *, int);

extern int _sceCallCode(const char *, int);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/filestub", _sceFsIobSemaMK);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/filestub", new_iob);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/filestub", get_iob);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/filestub", _sceFs_Rcv_Intr);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/filestub", _sceFsSemInit);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/filestub", _sceFsWaitS);

void _sceFsSigSema(void) {
    SignalSema(_fs_semid);
}

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/filestub", scePowerOffHandler);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/filestub", _sceFs_Poff_Intr);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/filestub", sceFsInit);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/filestub", _fs_version);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/filestub", sceFsReset);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/filestub", sceOpen);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/filestub", sceClose);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/filestub", sceLseek);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/filestub", sceRead);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/filestub", sceWrite);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/filestub", sceIoctl);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/filestub", sceIoctl2);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/filestub", _sceCallCode);

int sceRemove(const char *a) {
    return _sceCallCode(a, 6);
}

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/filestub", sceMkdir);

int sceRmdir(const char *a) {
    return _sceCallCode(a, 8);
}

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/filestub", sceFormat);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/filestub", sceAddDrv);

int sceDelDrv(const char *a) {
    return _sceCallCode(a, 0x10);
}

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/filestub", sceDopen);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/filestub", sceDclose);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/filestub", sceDread);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/filestub", sceGetstat);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/filestub", sceChstat);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/filestub", sceRename);

int sceChdir(const char *a) {
    return _sceCallCode(a, 0x12);
}

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/filestub", sceSync);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/filestub", sceMount);

int sceUmount(const char *a) {
    return _sceCallCode(a, 0x15);
}

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/filestub", sceLseek64);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/filestub", sceDevctl);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/filestub", sceSymlink);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/filestub", sceReadlink);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/kernl/filestub", _sceFs_q__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/kernl/filestub", _fs_init__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/kernl/filestub", _fs_semid__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/kernl/filestub", _fs_iob_semid__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/kernl/filestub", _fs_fsq_semid__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/kernl/filestub", _fswildcard__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/kernl/filestub", D_00365470__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/kernl/filestub", D_003654D8__DATA);

INCLUDE_BSS(rcv_adr_30, 0x4);

INCLUDE_BSS(ip0_55, 0x3C);

INCLUDE_BSS(_send_data, 0xC40);

INCLUDE_BSS(_rcv_data_rpc, 0x40);

INCLUDE_BSS(_rcv_data_cmd, 0x10);

INCLUDE_BSS(D_003823D0, 0x4);

INCLUDE_BSS(D_003823D4, 0x42C);

INCLUDE_BSS(_iob, 0x200);

INCLUDE_BSS(_cd, 0x28);

INCLUDE_BSS(_fsversion, 0x18);

INCLUDE_BSS(_sif_FsRcv_Data, 0x40);

INCLUDE_BSS(_sif_FsPoff_Data, 0x40);
