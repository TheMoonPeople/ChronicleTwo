#include "common.h"

extern void *sceSd_gEnd_func;

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/sdr_main", sceSdRemoteInit);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/sdr_main", sceSdTransToIOP);

void *sceSdCallBack(void *f) {
    void *o = sceSd_gEnd_func;
    sceSd_gEnd_func = f;
    return o;
}

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/sdr_main", sceSdRemote);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/sdr_main", __ps2_libinfo____4__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/sdr_main", sceSd_gEnd_func__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/sdr_main", _sce_sdr_gDMA0CB__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/sdr_main", _sce_sdr_gDMA1CB__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/sdr_main", _sce_sdr_gIRQCB__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/sdr_main", _sce_sdr_transIntr0Hdr__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/sdr_main", _sce_sdr_transIntr1Hdr__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/sdr_main", _sce_sdr_spu2IntrHdr__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/sdr_main", _sce_sdr_transIntr0Arg__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/sdr_main", _sce_sdr_transIntr1Arg__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/sdr_main", _sce_sdr_spu2IntrArg__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/sdr_main", D_003655A0__DATA);

INCLUDE_BSS(transData_6, 0x10);

INCLUDE_BSS(stack, 0x130);

INCLUDE_BSS(sbuff, 0x40);

INCLUDE_BSS(sceSd_gCd, 0x40);
