#include "common.h"
#include "mw_runtime.h"

#include <eekernel.h>
#include <libcdvd.h>
#include <libdma.h>
#include <libgraph.h>
#include <sifdev.h>
#include <sifrpc.h>

#include <cstdio>

#include "dataread.hpp"
#include "log/game_output.hpp"
#include "main.hpp"
#include "mainloop.hpp"

/**
 *
 * Vertical blanks counted since start-up, kept non-negative.
 *
 */
static volatile int vcount;

/**
 *
 * Counts vertical blank interrupts and resets the count if it wraps negative.
 *
 * @mangled VSyncCallBack__Fi__2
 * @address 0x15D470
 * @size 0x2C
 */
static int VSyncCallBack(int event) {
    vcount++;

    if (vcount < 0) {
        vcount = 0;
    }

    ExitHandler();

    return 0;
}

/**
 *
 * Sets up a default double buffer, clears both buffers to the given colour
 * and shows each in turn so the screen starts out blank.
 *
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

    FlushCache(WRITEBACK_DCACHE);
    sceGsSyncV(0);
    FlushCache(WRITEBACK_DCACHE);
    sceGsSyncV(0);
    sceGsSwapDBuff(&db, 0);
    sceGsSyncPath(0, 0);
    sceGsSwapDBuff(&db, 1);
    sceGsSyncPath(0, 0);
}

/**
 *
 * Resets the graphics hardware, reboots the IOP with the game's IOP image,
 * loads every IOP module the game uses and opens the CD file system.
 *
 */
static void init() {
    sceDmaReset(1);
    sceGsResetPath();
    sceGsResetGraph(0, SCE_GS_INTERLACE, SCE_GS_PAL, SCE_GS_FRAME);
    sceGsSyncVCallback(VSyncCallBack);
    ClearScreen(0, 0, 0);
    mwInit();

    sceSifInitRpc(0);
    sceCdInit(SCECdINIT);
    sceCdMmode(SCECdDVD);

    while (!sceSifRebootIop("textures/cdrom0:\\MODULES\\IOPRP243.json;1")) {
    }

    while (!sceSifSyncIop()) {
    }

    sceSifInitRpc(0);
    sceCdInit(SCECdINIT);
    sceCdMmode(SCECdDVD);
    sceFsReset();
    dc2::log::PrintGame("######################%d\n", vcount);

    while (sceSifLoadModule("cdrom0:\\MODULES\\SIO2MAN.IRX;1", 0, nullptr) < 0) {
    }

    while (sceSifLoadModule("cdrom0:\\MODULES\\PADMAN.IRX;1", 0, nullptr) < 0) {
    }

    while (sceSifLoadModule("cdrom0:\\MODULES\\MCMAN.IRX;1", 0, nullptr) < 0) {
    }

    while (sceSifLoadModule("cdrom0:\\MODULES\\MCSERV.IRX;1", 0, nullptr) < 0) {
    }

    while (sceSifLoadModule("cdrom0:\\MODULES\\LIBSD.IRX;1", 0, nullptr) < 0) {
    }

    while (sceSifLoadModule("cdrom0:\\MODULES\\SDRDRV.IRX;1", 0, nullptr) < 0) {
    }

    while (sceSifLoadModule("cdrom0:\\MODULES\\MODMIDI.IRX;1", 0, nullptr) < 0) {
    }

    while (sceSifLoadModule("cdrom0:\\MODULES\\MODHSYN.IRX;1", 0, nullptr) < 0) {
    }

    while (sceSifLoadModule("cdrom0:\\MODULES\\EZMIDI.IRX;1", 0, nullptr) < 0) {
    }

    while (sceSifLoadModule("cdrom0:\\MODULES\\EZBGM.IRX;1", 0, nullptr) < 0) {
    }

    InitCDFile();
    sceDmaReset(1);
    sceGsResetPath();
}

int main();
