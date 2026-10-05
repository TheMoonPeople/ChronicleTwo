#include "common.h"

typedef struct {
    int p0, p4, p8, pc;
    unsigned flags;
    int p14;
    int clr;
} K7RP;

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/sifrpc", sceSifInitRpc);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/sifrpc", sceSifExitRpc);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/sifrpc", _sceRpcGetPacket);

void _sceRpcFreePacket(K7RP *p) {
    p->clr = 0;
    p->flags &= 0xFFFFFFFE;
}

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/sifrpc", _sceRpcGetFPacket);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/sifrpc", _sceRpcGetFPacket2);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/sifrpc", _request_end);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/sifrpc", _request_rdata);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/sifrpc", sceSifGetOtherData);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/sifrpc", _search_svdata);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/sifrpc", _request_bind);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/sifrpc", sceSifBindRpc);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/sifrpc", _request_call);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/sifrpc", sceSifCallRpc);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/sifrpc", sceSifCheckStatRpc);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/sifrpc", sceSifSetRpcQueue);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/sifrpc", sceSifRegisterRpc);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/sifrpc", sceSifRemoveRpc);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/sifrpc", sceSifRemoveRpcQueue);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/sifrpc", sceSifGetNextRequest);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/sifrpc", sceSifExecRequest);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/sifrpc", sceSifRpcLoop);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/kernl/sifrpc", _sceSifInitCheck__DATA);

INCLUDE_BSS(_packet_buffer, 0x174);

INCLUDE_BSS(D_00380034, 0x4);

INCLUDE_BSS(D_00380038, 0x184);

INCLUDE_BSS(D_003801BC, 0x504);

INCLUDE_BSS(_free_buffer, 0x800);

INCLUDE_BSS(_free_buffer2, 0x800);

INCLUDE_BSS(_data_table__2, 0x40);
