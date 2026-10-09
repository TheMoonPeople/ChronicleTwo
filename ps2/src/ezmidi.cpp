#include "common.h"

#include <eekernel.h>
#include <sifdma.h>
#include <sifrpc.h>

#include <cstdio>

#include "ezmidi.hpp"

static s32 sbuff__2[16]; /**< Shared argument and response buffer for EZMIDI RPC calls. */

/**
 *
 * Holds the RPC client and the alignment gap before the DMA descriptor.
 *
 */
struct EzMidiClientStorage {
    sceSifClientData client; /**< Connection to the EZMIDI IOP server. */
    u8               unk_28[8];
};

static EzMidiClientStorage    gCd;       /**< Client storage for the EZMIDI IOP server. */
static volatile sceSifDmaData transData; /**< Descriptor reused for EE-to-IOP transfers. */

int ezMidiInit() {
    s32 wait;

    sceSifInitRpc(0);

    while (1) {
        if (sceSifBindRpc(&gCd.client, 0x12346, 0) < 0) {
            printf("error: sceSifBindRpc \n");

            for (;;) {
            }
        }

        wait = 10000;

        while (wait--) {
        }

        if (gCd.client.server != 0) {
            break;
        }
    }

    return 1;
}

int ezMidi(int command, int argument) {
    s32 receive_size;

    receive_size = 0;
    s32 wait = 0;

    // Leave a short interval for the IOP sound server between commands.
    do {
        wait += 8;
    } while (wait < 2000);

    if ((command & EZMIDI_RESPONSE) != 0) {
        receive_size = 64;
    }

    if ((command & EZMIDI_ARGUMENT_BLOCK) != 0) {
        sceSifCallRpc(&gCd.client, command, 0, (void *) argument, 64, sbuff__2, receive_size, 0, 0);
    } else {
        sbuff__2[0] = argument;
        sceSifCallRpc(&gCd.client, command, 0, sbuff__2, 16, sbuff__2, receive_size, 0, 0);
    }

    return sbuff__2[0];
}

int ezTransToIOP2(void *iop_address, void *ee_address, int size) {
    s32 id;
    u32 source = (u32) ee_address;

    transData.size = size;
    transData.data = ee_address;
    transData.addr = iop_address;
    transData.mode = 0;
    FlushCache(0);
    id = sceSifSetDma((sceSifDmaData *) &transData, 1);

    if (id == 0) {
        return -1;
    }

    while (sceSifDmaStat(id) >= 0) {
    }

    transData.data = (void *) source;
    return 0;
}
