#include "common.h"
#include "sce/libpkt.h"

void sceGifPkInit(sceGifPacket *packet, u_long128 *base) {
    packet->count = 0;
    packet->pBase = base;
    packet->pCurrent = base;
}

void sceGifPkReset(sceGifPacket *packet) {
    u_long128 *base = packet->pBase;
    packet->count = 0;
    packet->pCurrent = base;
}

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/pkt/libgifpk", sceGifPkTerminate);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/pkt/libgifpk", sceGifPkCnt);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/pkt/libgifpk", sceGifPkRef);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/pkt/libgifpk", sceGifPkEnd);

u_int *sceGifPkReserve(sceGifPacket *packet, int count) {
    u_int *current = (u_int *)packet->pCurrent;
    packet->pCurrent = (u_long128 *)(current + count);
    return current;
}

void sceGifPkOpenGifTag(sceGifPacket *packet, u_long128 tag) {
    packet->pOpenTag = (u_long128 *)packet->pCurrent;
    *(u_long128 *)packet->pCurrent = tag;
    packet->pCurrent = (u_long128 *)((u_long128 *)packet->pCurrent + 1);
}

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/pkt/libgifpk", sceGifPkCloseGifTag);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/pkt/libgifpk", sceGifPkAddGsData);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/pkt/libgifpk", sceGifPkAddGsAD);
