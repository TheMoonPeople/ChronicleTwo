#include "common.h"
#include "main.hpp"
#include "dataread.hpp"
#include "mainloop.hpp"
#include <cstdio>
#include <eekernel.h>
#include <libcdvd.h>
#include <libdma.h>
#include <libgraph.h>
#include <sifdev.h>
#include <sifrpc.h>

/** Vertical blanks counted since start-up, kept non-negative. */
// Small uninitialised data (.sbss)
static volatile int vcount__2;
extern int MainThreadPriority;
extern const unsigned char at_846__DATA[];
extern const unsigned char at_847__DATA[];
extern const unsigned char at_848__DATA[];
extern const unsigned char at_849__DATA[];
extern const unsigned char at_850__DATA[];
extern const unsigned char at_851__DATA[];
extern const unsigned char at_852__DATA[];
extern const unsigned char at_853__DATA[];
extern const unsigned char at_854__DATA[];
extern const unsigned char at_855__DATA[];
extern const unsigned char at_856__DATA[];
extern const unsigned char at_857__DATA[];

// Code (.text)
/**
 * Vertical-blank interrupt handler: counts the frame and re-enables
 * interrupts before returning.
 */
extern "C" int VSyncCallBack__Fi__2(int) {
    vcount__2++;
    if (vcount__2 < 0) {
        vcount__2 = 0;
    }
    asm {
        sync
        ei
    }
    return 0;
}

/**
 * Sets up a default double buffer, clears both buffers to the given colour
 * and shows each in turn so the screen starts out blank.
 */
static void ClearScreen(int r, int g, int b) {
    sceGsDBuff db;

    sceGsSetDefDBuff(&db, SCE_GS_PSMCT32, 640, 448, SCE_GS_ZGEQUAL, SCE_GS_PSMZ24, 1);
    db.clear0.rgbaq.A = 0x80;
    db.clear1.rgbaq.A = 0x80;
    db.clear0.rgbaq.R = r;
    db.clear1.rgbaq.R = r;
    db.clear0.rgbaq.G = g;
    db.clear1.rgbaq.G = g;
    db.clear0.rgbaq.B = b;
    db.clear1.rgbaq.B = b;

    FlushCache(0);
    sceGsSyncV(0);
    FlushCache(0);
    sceGsSyncV(0);
    sceGsSwapDBuff(&db, 0);
    sceGsSyncPath(0, 0);
    sceGsSwapDBuff(&db, 1);
    sceGsSyncPath(0, 0);
}

/**
 * Resets the graphics hardware, reboots the IOP with the game's IOP image,
 * loads every IOP module the game uses and opens the CD file system.
 */
static void init() {
    sceDmaReset(1);
    sceGsResetPath();
    sceGsResetGraph(0, SCE_GS_INTERLACE, SCE_GS_PAL, 0);
    sceGsSyncVCallback(VSyncCallBack__Fi__2);
    ClearScreen(0, 0, 0);
    mwInit();

    sceSifInitRpc(0);
    sceCdInit(0);
    sceCdMmode(2);
    while (!sceSifRebootIop((const char *)at_846__DATA)) {
    }
    while (!sceSifSyncIop()) {
    }
    sceSifInitRpc(0);
    sceCdInit(0);
    sceCdMmode(2);
    sceFsReset();
    printf((const char *)at_847__DATA, vcount__2);

    while (sceSifLoadModule((const char *)at_848__DATA, 0, NULL) < 0) {
    }
    while (sceSifLoadModule((const char *)at_849__DATA, 0, NULL) < 0) {
    }
    while (sceSifLoadModule((const char *)at_850__DATA, 0, NULL) < 0) {
    }
    while (sceSifLoadModule((const char *)at_851__DATA, 0, NULL) < 0) {
    }
    while (sceSifLoadModule((const char *)at_852__DATA, 0, NULL) < 0) {
    }
    while (sceSifLoadModule((const char *)at_853__DATA, 0, NULL) < 0) {
    }
    while (sceSifLoadModule((const char *)at_854__DATA, 0, NULL) < 0) {
    }
    while (sceSifLoadModule((const char *)at_855__DATA, 0, NULL) < 0) {
    }
    while (sceSifLoadModule((const char *)at_856__DATA, 0, NULL) < 0) {
    }
    while (sceSifLoadModule((const char *)at_857__DATA, 0, NULL) < 0) {
    }

    InitCDFile();
    sceDmaReset(1);
    sceGsResetPath();
}
int main() {
    MainThreadPriority = 10;
    ChangeThreadPriority(GetThreadId(), MainThreadPriority);
    init();
    printf((const char *)at_847__DATA, vcount__2);
    MainLoop();

    sceGsSyncPath(0, 0);
    sceGsSyncVCallback(NULL);
    sceGsSyncV(0);
    sceCdInit(5);
    sceSifExitCmd();
    return 0;
}

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/main", at_846__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/main", at_847__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/main", at_848__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/main", at_849__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/main", at_850__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/main", at_851__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/main", at_852__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/main", at_853__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/main", at_854__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/main", at_855__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/main", at_856__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/main", at_857__DATA);
