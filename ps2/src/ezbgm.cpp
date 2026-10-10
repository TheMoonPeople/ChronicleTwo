#include "common.h"

#include <sifrpc.h>

#include <cstdio>

#include "ezbgm.hpp"
#include "sound.hpp"

/**
 *
 * Command send and response buffer shared with the EZBGM server.
 *
 */
static int sbuff[16] __attribute__((aligned(16)));

/**
 *
 * Client connection to the EZBGM IOP server.
 *
 */
static sceSifClientData gCd2 __attribute__((aligned(16)));

int ezBgmInit() {
    int delay;

    printf("EZ_BGMINIT START \n");
    sceSifInitRpc(0);

    do {
        if (sceSifBindRpc(&gCd2, 0x12345, 0) < 0) {
            printf("error: sceSifBindRpc \n");

            while (true) {
            }
        }

        delay = 10000;

        while (delay--) {
        }
    } while (gCd2.server == 0);

    return 1;
}

int ezBgm(int command, int argument) {
    switch (command & EZBGM_COMMAND_MASK) {
        case EZBGM_OPEN:
        case EZBGM_UNK_8A00:
        case EZBGM_OPEN_FROM_PACK:
            if (sceSifCheckStatRpc(&gCd2) != 0) {
                printf("########### Rpc is bussy1!! \n");
                return 0;
            }

            sceSifCallRpc(&gCd2, command, 1, (void *) argument, 0x40, sbuff, 0x40, NULL,
                          NULL);
            break;
        case EZBGM_PRELOAD:
            if (sceSifCheckStatRpc(&gCd2) != 0) {
                printf("########### Rpc is bussy2!! \n");
                return 0;
            }

            sbuff[0] = argument;
            sceSifCallRpc(&gCd2, command, 1, sbuff, 0x10, sbuff, 0x40, NULL,
                          NULL);
            break;
        default:
            if (sceSifCheckStatRpc(&gCd2) != 0) {
                printf("########### Rpc is bussy3!! \n");
                return 0;
            }

            sbuff[0] = argument;
            sceSifCallRpc(&gCd2, command, 0, sbuff, 0x10, sbuff, 0x40, NULL,
                          NULL);
            break;
    }

    return sbuff[0];
}

int CSound::StreamOpenState() {
    return sceSifCheckStatRpc(&gCd2);
}
