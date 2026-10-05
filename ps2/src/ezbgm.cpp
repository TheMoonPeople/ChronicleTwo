#include "common.h"
#include "ezbgm.hpp"
#include "sound.hpp"
#include <sifrpc.h>
#include <cstdio>

/** Client connection to the EZBGM IOP server. */
extern sceSifClientData gCd2;
/** Command send and response buffer shared with the EZBGM server. */
extern int sbuff__3[16];
extern const char at_32[];
extern const char at_33__2[];
extern const char at_52[];
extern const char at_53[];
extern const char at_54[];

// Code (.text)
#ifdef NONMATCHING
int ezBgmInit() {
    printf(at_32);
    sceSifInitRpc(0);
    do {
        if (sceSifBindRpc(&gCd2, 0x12345, 0) < 0) {
            printf(at_33__2);
            for (;;) {}
        }
        int wait = 10000;
        do {
            wait--;
        } while (wait >= 0);
    } while (gCd2.serverr == 0);
    return 1;
}
#else
int ezBgmInit(void) {
    int previous;
    int delay;

    printf(at_32);
    sceSifInitRpc(0);
retry:
    if (sceSifBindRpc(&gCd2, 0x12345, 0) < 0) {
        printf(at_33__2);
    hang:
        goto hang;
    }
    delay = 0x2710;
    do {
        previous = delay;
        delay -= 1;
    } while (previous != 0);
    if (gCd2.server != 0) {
        return 1;
    }
    goto retry;
}
#endif

#ifdef NONMATCHING
int ezBgm(int command, int argument) {
    switch (command & EZBGM_COMMAND_MASK) {
    case EZBGM_PRELOAD:
        if (sceSifCheckStatRpc(&gCd2)) {
            printf(at_53);
            return 0;
        }
        sbuff__3[0] = argument;
        sceSifCallRpc(&gCd2, command, 1, sbuff__3, 0x10, sbuff__3, 0x40, 0, 0);
        break;
    case EZBGM_OPEN_FROM_PACK:
    case EZBGM_UNK_8A00:
    case EZBGM_OPEN:
        if (sceSifCheckStatRpc(&gCd2)) {
            printf(at_52);
            return 0;
        }
        sceSifCallRpc(&gCd2, command, 1, (void *)argument, 0x40, sbuff__3, 0x40, 0, 0);
        break;
    default:
        if (sceSifCheckStatRpc(&gCd2)) {
            printf(at_54);
            return 0;
        }
        sbuff__3[0] = argument;
        sceSifCallRpc(&gCd2, command, 0, sbuff__3, 0x10, sbuff__3, 0x40, 0, 0);
        break;
    }
    return sbuff__3[0];
}
#else
int ezBgm(int command, int argument) {
    switch (command & 0xFFF0) {
        case 0x8020:
        case 0x8A00:
        case 0x80F0:
            if (sceSifCheckStatRpc(&gCd2) != 0) {
                printf(at_52);
                return 0;
            }
            sceSifCallRpc(&gCd2, command, 1, (void *)argument, 0x40, sbuff__3, 0x40, NULL,
                          NULL);
            break;
        case 0x40:
            if (sceSifCheckStatRpc(&gCd2) != 0) {
                printf(at_53);
                return 0;
            }
            sbuff__3[0] = argument;
            sceSifCallRpc(&gCd2, command, 1, sbuff__3, 0x10, sbuff__3, 0x40, NULL,
                          NULL);
            break;
        default:
            if (sceSifCheckStatRpc(&gCd2) != 0) {
                printf(at_54);
                return 0;
            }
            sbuff__3[0] = argument;
            sceSifCallRpc(&gCd2, command, 0, sbuff__3, 0x10, sbuff__3, 0x40, NULL,
                          NULL);
            break;
    }
    return sbuff__3[0];
}
#endif
int CSound::StreamOpenState() {
    return sceSifCheckStatRpc(&gCd2);
}

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/ezbgm", at_32__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/ezbgm", at_33__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/ezbgm", at_52__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/ezbgm", at_53__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/ezbgm", at_54__DATA);

// Uninitialised data (.bss)
INCLUDE_BSS(sbuff__3, 0x40);
INCLUDE_BSS(gCd2, 0x30);
