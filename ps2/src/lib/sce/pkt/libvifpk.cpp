#include "common.h"
#include "sce/libpkt.h"

void sceVif1PkInit(sceVif1Packet *packet, u_int *base) {
    packet->count = 0;
    packet->pBase = base;
    packet->pCurrent = base;
}

void sceVif1PkReset(sceVif1Packet *packet) {
    u_int *base = packet->pBase;
    packet->count = 0;
    packet->pCurrent = base;
}

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/pkt/libvifpk", sceVif1PkTerminate);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/pkt/libvifpk", sceVif1PkCnt);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/pkt/libvifpk", sceVif1PkCall);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/pkt/libvifpk", sceVif1PkEnd);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/pkt/libvifpk", sceVif1PkOpenDirectCode);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/pkt/libvifpk", sceVif1PkCloseDirectCode);

void sceVif1PkOpenGifTag(sceVif1Packet *packet, u_long128 tag) {
    packet->pOpenTag = (u_int *)packet->pCurrent;
    *(u_long128 *)packet->pCurrent = tag;
    packet->pCurrent = (u_int *)((u_long128 *)packet->pCurrent + 1);
}

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/pkt/libvifpk", sceVif1PkCloseGifTag);

u_int *sceVif1PkReserve(sceVif1Packet *packet, int count) {
    u_int *current = (u_int *)packet->pCurrent;
    packet->pCurrent = (u_int *)(current + count);
    return current;
}

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/pkt/libvifpk", sceVif1PkAlign);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/pkt/libvifpk", sceVif1PkAddGsAD);
