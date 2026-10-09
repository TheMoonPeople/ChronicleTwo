#include "common.h"

#include <eekernel.h>
#include <libsdr.h>
#include <modmsin.h>
#include <sifrpc.h>

#include <cstdio>
#include <cstring>

#include "ezbgm.hpp"
#include "ezmidi.hpp"
#include "sound.hpp"

/**
 *
 * Stream format information returned by each EZBGM channel.
 *
 */
static int bgm_info[2];

/**
 *
 * Playback, bank allocation and fade state for all MIDI ports.
 *
 */
static MIDI_STATE midi_state;

/**
 *
 * MIDI stream input module context.
 *
 */
static sceCslCtx msinCtx;

/**
 *
 * IOP destination of the MIDI stream buffers.
 *
 */
static void *iopMSINBuffAddr;

/**
 *
 * Accumulated body size of the sound bank transfer.
 *
 */
static int bd_size_total;

/**
 *
 * Input and output groups of the MIDI stream module.
 *
 */
static sceCslBuffGrp msinBfGrp[2];

/**
 *
 * Contexts of the MIDI message buffers.
 *
 */
static sceCslBuffCtx msinBfCtx[MIDI_MSIN_PORT_COUNT];

/**
 *
 * MIDI message buffers transferred to the stream input module.
 *
 */
static MSIN_BUFFER msinBf[MIDI_MSIN_PORT_COUNT];

/**
 *
 * Sound bank descriptor submitted to the sequencer.
 *
 */
static MIDI_BANK gBank;

/**
 *
 * IOP staging area used to transfer sound banks.
 *
 */
void *iop_bd_addr;

// Code (.text)
void CSound::StopVoice(int core) {
    sceSdRemote(1, rSdSetSwitch, core | SD_S_KOFF, 0xFFFFFF);
    printf("voice completed Core=%d\n", core);
}

void CSound::SndInReverb(bool enable) {
    if (enable) {
        sceSdRemote(1, rSdSetParam, 0x800, -4);
        sceSdRemote(1, rSdSetParam, 0x801, -4);
        return;
    }

    sceSdRemote(1, rSdSetParam, 0x800, -0x34);
    sceSdRemote(1, rSdSetParam, 0x801, -0x34);
}

void CSound::SetReverb(int core, int mode, int depth) {
    sceSdEffectAttr effect;

    sceSdRemote(1, rSdSetCoreAttr, SD_C_SPDIF_MODE, SD_SPDIF_COPY_PROHIBIT);
    sceSdRemote(1, rSdSetAddr, core | SD_A_EEA, 0x1FFFFF - (core << 17));
    effect.mode = mode | SD_REV_MODE_CLEAR_WA;
    effect.depth_L = 0;
    effect.depth_R = 0;
    sceSdRemote(1, rSdSetEffectAttr, core, &effect);
    sceSdRemote(1, rSdSetCoreAttr, core | SD_C_EFFECT_ENABLE, 1);
    depth = (depth << 8) & 0xFFFF;
    sceSdRemote(1, rSdSetParam, core | SD_P_EVOLL, depth);
    sceSdRemote(1, rSdSetParam, core | SD_P_EVOLR, depth);
    sceSdRemote(1, rSdSetParam, core | SD_P_MVOLL, 0x3FFF);
    sceSdRemote(1, rSdSetParam, core | SD_P_MVOLR, 0x3FFF);
}

void set_spu(int mode0, int mode1, int depth0, int depth1) {
    sceSdEffectAttr effect;
    int             mode[2];
    int             depth[2];
    int             core;
    int             volume;

    mode[0] = mode0;
    mode[1] = mode1;
    depth[0] = depth0;
    depth[1] = depth1;
    sceSdRemoteInit();
    sceSdRemote(1, rSdInit, 0);
    sceSdRemote(1, rSdSetCoreAttr, SD_C_SPDIF_MODE, SD_SPDIF_COPY_PROHIBIT);

    for (core = 0; core < 2; core++) {
        sceSdRemote(1, rSdSetAddr, core | SD_A_EEA, 0x1FFFFF - core * 0x20000);
        effect.mode = mode[core] | SD_REV_MODE_CLEAR_WA;
        effect.depth_L = 0;
        effect.depth_R = 0;
        sceSdRemote(1, rSdSetEffectAttr, core, &effect);
        sceSdRemote(1, rSdSetCoreAttr, core | SD_C_EFFECT_ENABLE, 1);
        volume = (depth[core] << 8) & 0xFFFF;
        sceSdRemote(1, rSdSetParam, core | SD_P_EVOLL, volume);
        sceSdRemote(1, rSdSetParam, core | SD_P_EVOLR, volume);
        sceSdRemote(1, rSdSetParam, core | SD_P_MVOLL, 0x3FFF);
        sceSdRemote(1, rSdSetParam, core | SD_P_MVOLR, 0x3FFF);
    }
}

int TransHdBd(int hd, int hd_size, int bd, int bd_size) {
    void *header;

    if (bd_size == 0) {
        printf("BD LOAD Err!!!!!!!!!!!!!!!!!!!!!\n");
        gBank.bd_size = 0;
        gBank.hd_address = NULL;
        return -1;
    }
    if (hd_size == 0) {
        printf("HD LOAD Err!!!!!!!!!!!!!!!!!!!!!\n");
        gBank.bd_size = 0;
        gBank.hd_address = NULL;
        return -1;
    }
    sceSifInitIopHeap();
    if (hd_size <= 256) {
        header = sceSifAllocSysMemory(1, 256, NULL);
    } else {
        header = sceSifAllocSysMemory(1, hd_size + 256, NULL);
    }
    if (header == NULL) {
        printf("AllocIopHeap Err!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
        return -1;
    }
    printf("hd AllocIopHeap %d \n", header);
    ezTransToIOP2(header, (void *) hd, hd_size);
    gBank.hd_address = header;
    gBank.bd_size = bd_size;
    gBank.bd_address = iop_bd_addr;
    printf(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>SPU ADDR==%d size=%d!!!!!!!!!!\n", gBank.spu_address, bd_size);
    if ((u32) gBank.spu_address < 0x18AE20 && (u32) (gBank.spu_address + bd_size) > 0x18AE20) {
        printf(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>SYS AREA HAKAI????addr=%d size=%d!!!!!!!!!!\n", gBank.spu_address, bd_size);
    }
    if (bd_size <= 0x6DE00) {
        sceSdRemote(1, rSdVoiceTransStatus, 1, SD_TRANS_STATUS_WAIT);
        ezTransToIOP2(iop_bd_addr, (void *) bd, bd_size);
        FlushCache(0);
        sceSdRemote(1, rSdVoiceTrans, 1, SD_TRANS_MODE_WRITE, gBank.bd_address, gBank.spu_address, bd_size);
    } else {
        sceSdRemote(1, rSdVoiceTransStatus, 1, SD_TRANS_STATUS_WAIT);
        ezTransToIOP2(iop_bd_addr, (void *) bd, 0x6DD00);
        FlushCache(0);
        sceSdRemote(1, rSdVoiceTrans, 1, SD_TRANS_MODE_WRITE, gBank.bd_address, gBank.spu_address, 0x6DD00);
        sceSdRemote(1, rSdVoiceTransStatus, 1, SD_TRANS_STATUS_WAIT);
        ezTransToIOP2((void *) iop_bd_addr, (void *) (bd + 0x6DD00), bd_size - 0x6DD00);
        FlushCache(0);
        sceSdRemote(1, rSdVoiceTrans, 1, SD_TRANS_MODE_WRITE, gBank.bd_address, gBank.spu_address + 0x6DD00, bd_size - 0x6DD00);
    }
    return 0;
}

int CSound::Init(int mode0, int mode1, int depth0, int depth1) {
    static int load_m_flg = 0;
    int        port;
    int        slot;

    if (iopMSINBuffAddr == NULL) {
        printf("EzMIDI initialize...\n");
        ezBgmInit();
        ezMidiInit();
        set_spu(mode0, mode1, depth0, depth1);
        iopMSINBuffAddr = (void *)ezMidi(0x8010, 0x4000);
        sceSifInitIopHeap();
        printf("iopMSINBuffAddr %d\n", iopMSINBuffAddr);
        if (iop_bd_addr == NULL) {
            iop_bd_addr = sceSifAllocSysMemory(1, 0x6DD00, NULL);
            if (iop_bd_addr == NULL) {
                printf("AllocIopHeap Err\n");
                return -1;
            }
        }
        msinCtx.buffGrpNum = 2;
        msinCtx.buffGrp = msinBfGrp;
        msinCtx.extmod = NULL;
        msinCtx.callBack = NULL;
        msinCtx.conf = NULL;
        msinBfGrp[0].buffNum = 0;
        msinBfGrp[0].buffCtx = NULL;
        msinBfGrp[1].buffNum = MIDI_MSIN_PORT_COUNT;
        msinBfGrp[1].buffCtx = msinBfCtx;
        for (slot = 0; slot < MIDI_MSIN_PORT_COUNT; slot++) {
            msinBfCtx[slot].sema = 0;
            msinBfCtx[slot].buff = &msinBf[slot];
            msinBf[slot].size = sizeof(MSIN_BUFFER);
            msinBf[slot].length = 0;
        }
        if (sceMSIn_Init(&msinCtx) != 0) {
            printf("sceMSIn_Init Error\n");
            return 1;
        }
        bd_size_total = 0;
        for (port = 0; port < MIDI_PORT_COUNT; port++) {
            midi_state.port[port].unk_00 = 0;
            midi_state.port[port].spu_direction = SPU_ALLOC_UPWARD;
            midi_state.port[port].linked_port = -1;
            for (slot = 0; slot < MIDI_PORT_BANK_MAX; slot++) {
                midi_state.port[port].dependent_port[slot] = -1;
            }
            midi_state.port[port].dependent_port_count = 0;
            for (slot = 0; slot < MIDI_PORT_BANK_MAX; slot++) {
                midi_state.port[port].bank[slot] = NULL;
            }
            midi_state.port[port].bank_count = 0;
            midi_state.port[port].ezmidi_param = 0;
            midi_state.port[port].spu_next_address = 0;
            for (slot = 0; slot < MIDI_PORT_SEQ_MAX; slot++) {
                midi_state.port[port].sequence[slot] = NULL;
            }
            midi_state.port[port].resident_sequence = NULL;
            for (slot = 0; slot < MIDI_PORT_SEQ_MAX; slot++) {
                midi_state.port[port].unk_CC[slot] = 0;
            }
            midi_state.port[port].sequence_count = 0;
            midi_state.port[port].fade[0].active = 0;
            midi_state.port[port].fade[1].active = 0;
            midi_state.port[port].unk_118 = 0;
            midi_state.port[port].unk_11C = 0;
            midi_state.port[port].unk_120 = 0;
        }
        midi_state.port[0].unk_00 = 0;
        midi_state.port[15].unk_118 = 1;
        midi_state.port[13].unk_118 = 1;
        midi_state.port[3].unk_00 = 0;
        midi_state.port[10].unk_00 = 0;
        midi_state.port[8].unk_00 = 2;
        midi_state.port[1].unk_00 = 2;
        midi_state.port[15].unk_00 = 2;
        midi_state.port[2].unk_00 = 2;
        midi_state.port[14].unk_00 = 2;
        midi_state.port[13].unk_00 = 1;
        midi_state.port[7].unk_00 = 0;
        midi_state.port[9].unk_00 = 0;
        midi_state.port[12].unk_00 = 0;
        midi_state.port[11].unk_00 = 0;
        midi_state.port[0].spu_direction = SPU_ALLOC_UPWARD;
        midi_state.port[3].spu_direction = SPU_ALLOC_UPWARD;
        midi_state.port[10].spu_direction = SPU_ALLOC_UPWARD;
        midi_state.port[8].spu_direction = SPU_ALLOC_UPWARD;
        midi_state.port[1].spu_direction = SPU_ALLOC_UPWARD;
        midi_state.port[15].spu_direction = SPU_ALLOC_UPWARD;
        midi_state.port[2].spu_direction = SPU_ALLOC_UPWARD;
        midi_state.port[14].spu_direction = SPU_ALLOC_UPWARD;
        midi_state.port[13].spu_direction = SPU_ALLOC_DOWNWARD;
        midi_state.port[7].spu_direction = SPU_ALLOC_UPWARD;
        midi_state.port[9].spu_direction = SPU_ALLOC_UPWARD;
        midi_state.port[12].spu_direction = SPU_ALLOC_UPWARD;
        midi_state.port[11].spu_direction = SPU_ALLOC_UPWARD;
        midi_state.port[2].linked_port = 14;
        midi_state.port[14].linked_port = 2;
        midi_state.port[10].dependent_port[0] = 8;
        midi_state.port[10].dependent_port[1] = 1;
        midi_state.port[8].dependent_port[0] = 1;
        midi_state.port[10].dependent_port[2] = 15;
        midi_state.port[10].dependent_port[3] = 2;
        midi_state.port[10].dependent_port[4] = 14;
        midi_state.port[8].dependent_port[1] = 15;
        midi_state.port[1].dependent_port[0] = 15;
        midi_state.port[8].dependent_port[2] = 2;
        midi_state.port[8].dependent_port[3] = 14;
        midi_state.port[1].dependent_port[1] = 2;
        midi_state.port[1].dependent_port[2] = 14;
        midi_state.port[15].dependent_port[1] = 14;
        midi_state.port[15].dependent_port[0] = 2;
        midi_state.port[10].dependent_port_count = 5;
        midi_state.port[8].dependent_port_count = 4;
        midi_state.port[1].dependent_port_count = 3;
        midi_state.port[15].dependent_port_count = 2;
        midi_state.port[0].spu_address = midi_state.port[0].spu_next_address = 0x5210;
        midi_state.port[3].spu_address = midi_state.port[3].spu_next_address = 0x5210;
        midi_state.port[10].spu_address = midi_state.port[10].spu_next_address = 0x7D210;
        midi_state.port[8].spu_address = midi_state.port[8].spu_next_address = 0x7D210;
        midi_state.port[1].spu_address = midi_state.port[1].spu_next_address = 0x7D210;
        midi_state.port[15].spu_address = midi_state.port[15].spu_next_address = 0x7D210;
        midi_state.port[2].spu_address = midi_state.port[2].spu_next_address = 0x7D210;
        midi_state.port[14].spu_address = midi_state.port[14].spu_next_address = 0x7D210;
        midi_state.port[13].spu_address = midi_state.port[13].spu_next_address = 0x18AE20;
        midi_state.port[7].spu_address = midi_state.port[7].spu_next_address = 0x18AE20;
        midi_state.port[9].spu_address = midi_state.port[9].spu_next_address = 0x1E0000;
        midi_state.port[12].spu_address = midi_state.port[12].spu_next_address = 0x18AE20;
        midi_state.port[11].spu_address = midi_state.port[11].spu_next_address = 0x1A82E0;
        midi_state.port[0].ezmidi_param = 0x3040;
        midi_state.port[3].ezmidi_param = 0x3040;
        midi_state.port[10].ezmidi_param = 0x3037;
        midi_state.port[8].ezmidi_param = 0x3035;
        midi_state.port[1].ezmidi_param = 0x3032;
        midi_state.port[15].ezmidi_param = 0x3031;
        midi_state.port[2].ezmidi_param = 0x3039;
        midi_state.port[14].ezmidi_param = 0x3039;
        midi_state.port[13].ezmidi_param = 0x3036;
        midi_state.port[7].ezmidi_param = 0x3010;
        midi_state.port[9].ezmidi_param = 0x3038;
        midi_state.port[12].ezmidi_param = 0x3034;
        midi_state.port[11].ezmidi_param = 0x3033;
    }
    return 0;
}

int CSound::Exit() {
    int port;
    int slot;

    for (port = 0; port < MIDI_PORT_COUNT; port++) {
        ezMidi(port + 0x20, 0);
        for (slot = 0; slot < midi_state.port[port].bank_count; slot++) {
            sceSifInitIopHeap();
            sceSifFreeSysMemory(midi_state.port[port].bank[slot]);
            midi_state.port[port].bank[slot] = NULL;
        }
        midi_state.port[port].bank_count = 0;
        for (slot = 0; slot < midi_state.port[port].sequence_count; slot++) {
            sceSifInitIopHeap();
            sceSifFreeSysMemory(midi_state.port[port].sequence[slot]);
        }
        midi_state.port[port].sequence_count = 0;
    }
    ezMidi(0x80F0, 0);
    iopMSINBuffAddr = NULL;
    if (iop_bd_addr != NULL) {
        sceSifInitIopHeap();
        sceSifFreeSysMemory(iop_bd_addr);
        iop_bd_addr = NULL;
    }
    return 0;
}

void CSound::DEL_PORT(int port) {
    int        dependent;
    int        dependent_port;
    int        stream_port;
    MSIN_BUFFER *buffer;

    printf("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$DEL PORT %d\n", port);
    stream_port = port - MIDI_PORT_MSIN_FIRST;
    if (stream_port >= 0) {
        buffer = &msinBf[stream_port];
        buffer->length = 0;
    }
    ezMidi(port + 0x20, 0);
    if (midi_state.port[port].sequence_count != 0) {
        ezMidi(port + 0x40, (int)midi_state.port[port].resident_sequence);
    }
    for (int slot = 1; slot < midi_state.port[port].sequence_count; slot++) {
        sceSifInitIopHeap();
        sceSifFreeSysMemory(midi_state.port[port].sequence[slot]);
    }
    midi_state.port[port].sequence_count = 0;
    if (midi_state.port[port].linked_port >= 0) {
        stream_port = midi_state.port[port].linked_port - MIDI_PORT_MSIN_FIRST;
        if (stream_port >= 0) {
            buffer = &msinBf[stream_port];
            buffer->length = 0;
        }
        ezMidi(midi_state.port[port].linked_port + 0x20, 0);
        if (midi_state.port[midi_state.port[port].linked_port].sequence_count != 0) {
            ezMidi(midi_state.port[port].linked_port + 0x40, (int)midi_state.port[midi_state.port[port].linked_port].resident_sequence);
        }
        for (int slot = 1; slot < midi_state.port[midi_state.port[port].linked_port].sequence_count; slot++) {
            sceSifInitIopHeap();
            sceSifFreeSysMemory(midi_state.port[midi_state.port[port].linked_port].sequence[slot]);
            midi_state.port[midi_state.port[port].linked_port].sequence[slot] = NULL;
        }
        midi_state.port[midi_state.port[port].linked_port].sequence_count = 0;
    }
    for (dependent = 0; dependent < midi_state.port[port].dependent_port_count; dependent++) {
        dependent_port = midi_state.port[port].dependent_port[dependent];
        stream_port = dependent_port - MIDI_PORT_MSIN_FIRST;
        if (stream_port >= 0) {
            buffer = &msinBf[stream_port];
            buffer->length = 0;
        }
        ezMidi(dependent_port + 0x20, 0);
        midi_state.port[dependent_port].spu_next_address = midi_state.port[dependent_port].spu_address = midi_state.port[port].spu_address;
        if (midi_state.port[dependent_port].sequence_count != 0) {
            ezMidi(dependent_port + 0x40, (int)midi_state.port[dependent_port].resident_sequence);
        }
        for (int slot = 1; slot < midi_state.port[dependent_port].sequence_count; slot++) {
            sceSifInitIopHeap();
            sceSifFreeSysMemory(midi_state.port[dependent_port].sequence[slot]);
            midi_state.port[dependent_port].sequence[slot] = NULL;
        }
        midi_state.port[dependent_port].sequence_count = 0;
    }
}

void CSound::SQ_Play(int port, int seq_no, int volume) {
    void *sequence;

    if (seq_no < midi_state.port[port].sequence_count) {
        sequence = midi_state.port[port].sequence[seq_no];
    } else {
        printf("###############NOT FOUND SEQ_NO=%d #####################\n", seq_no);
        return;
    }
    ezMidi(port + 0x20, 0);
    printf("MIDI start! port=%d \n", port);
    ezMidi(port + 0x40, (int)sequence);
    printf("###############PLAY SEQ_NO=%d PORT=%d#####################\n", seq_no, port);
    if (volume != 256) {
        volume = static_cast<int>(2.015748f * volume);
    }
    ezMidi(port + 0xB0, volume);
    ezMidi(port + 0x30, 0);
    ezMidi(port, 0);
}

void CSound::SQ_RePlay(int port) {
    if (midi_state.port[port].sequence_count > 0) {
        printf("MIDI restart! port=%d \n", port);
        ezMidi(port, 0);
    }
}

void CSound::SE_Play(int port, int bank, int program, int key, int pan, int velocity, int volume, int pitch, int id) {
    u8  message[7];
    u32 stream_port;

    if (id > 0x7E) {
        printf(" ################################SE_ID ERR!! PORT NO=%d !!!\n", port);
        return;
    }

    if (midi_state.port[port].bank_count > 0) {
        stream_port = port - MIDI_PORT_MSIN_FIRST;
        sceMSIn_PutMsg(&msinCtx, stream_port, ((bank & 0x7F) << 16) | 0xB0);
        sceMSIn_PutMsg(&msinCtx, stream_port, ((program & 0x7F) << 8) | 0xC0);
        message[0] = 0xF9;
        message[1] = 0;
        message[2] = 0;
        message[3] = volume;
        message[4] = 0;
        sceMSIn_PutHsMsg(&msinCtx, stream_port, message);
        message[0] = 0xF9;
        message[1] = 2;
        message[2] = 0;
        message[3] = pitch & 0x7F;
        message[4] = (pitch >> 7) & 0x7F;
        message[0] = 0xF9;
        message[1] = 1;
        message[2] = 0;
        message[3] = pan;
        message[4] = 0;
        sceMSIn_PutHsMsg(&msinCtx, stream_port, message);
        message[0] = 0xFD;
        message[1] = 0x10;
        message[2] = 0;
        message[3] = key;
        message[4] = id;
        message[5] = velocity;
        message[6] = 0;
        sceMSIn_PutHsMsg(&msinCtx, stream_port, message);
    }
}

void CSound::SE_SetVol(int port, int bank, int program, int key, int volume, int id) {
    u8  message[7];
    u32 stream_port;

    if (id > 0x7E) {
        printf(" ################################SE_ID ERR!! PORT NO=%d !!!\n", port);
        return;
    }

    if (midi_state.port[port].bank_count > 0) {
        stream_port = port - MIDI_PORT_MSIN_FIRST;
        sceMSIn_PutMsg(&msinCtx, stream_port, ((bank & 0x7F) << 16) | 0xB0);
        sceMSIn_PutMsg(&msinCtx, stream_port, ((program & 0x7F) << 8) | 0xC0);
        message[0] = 0xFD;
        message[1] = 0;
        message[2] = 0;
        message[3] = key;
        message[4] = id;
        message[5] = volume;
        message[6] = 0;
        sceMSIn_PutHsMsg(&msinCtx, stream_port, message);
    }
}

void CSound::SE_SetPan(int port, int bank, int program, int key, int pan, int id) {
    u8  message[7];
    u32 stream_port;

    if (id > 0x7E) {
        printf(" ################################SE_ID ERR!! PORT NO=%d !!!\n", port);
        return;
    }

    if (midi_state.port[port].bank_count > 0) {
        stream_port = port - MIDI_PORT_MSIN_FIRST;
        sceMSIn_PutMsg(&msinCtx, stream_port, ((bank & 0x7F) << 16) | 0xB0);
        sceMSIn_PutMsg(&msinCtx, stream_port, ((program & 0x7F) << 8) | 0xC0);
        message[0] = 0xFD;
        message[1] = 0x1;
        message[2] = 0;
        message[3] = key;
        message[4] = id;
        message[5] = pan;
        message[6] = 0;
        sceMSIn_PutHsMsg(&msinCtx, stream_port, message);
    }
}

void CSound::SE_Stop(int port, int bank, int program, int key, int id) {
    u8  message[7];
    u32 stream_port;

    if (id > 0x7E) {
        printf(" ################################SE_ID ERR!! PORT NO=%d !!!\n", port);
        return;
    }

    if (midi_state.port[port].bank_count > 0) {
        stream_port = port - MIDI_PORT_MSIN_FIRST;
        sceMSIn_PutMsg(&msinCtx, stream_port, ((bank & 0x7F) << 16) | 0xB0);
        sceMSIn_PutMsg(&msinCtx, stream_port, ((program & 0x7F) << 8) | 0xC0);
        message[0] = 0xFD;
        message[1] = 0x10;
        message[2] = 0;
        message[3] = key;
        message[4] = id;
        message[5] = 0;
        message[6] = 0;
        sceMSIn_PutHsMsg(&msinCtx, stream_port, message);
    }
}

void CSound::Step() {
    int port;

    for (port = 0; port < MIDI_PORT_COUNT; port++) {
        if (midi_state.port[port].fade[0].active != 0) {
            midi_state.port[port].fade[0].volume += midi_state.port[port].fade[0].step;
            if (!(midi_state.port[port].fade[0].step <= 0.0f)) {
                if (!(midi_state.port[port].fade[0].volume <= (float)midi_state.port[port].fade[0].target_volume)) {
                    midi_state.port[port].fade[0].volume = (float)midi_state.port[port].fade[0].target_volume;
                    midi_state.port[port].fade[0].active = 0;
                }
            }
            if (midi_state.port[port].fade[0].step < 0.0f) {
                if (midi_state.port[port].fade[0].volume < (float)midi_state.port[port].fade[0].target_volume) {
                    midi_state.port[port].fade[0].volume = (float)midi_state.port[port].fade[0].target_volume;
                    midi_state.port[port].fade[0].active = 0;
                }
            }
            SetVol(0, (int)midi_state.port[port].fade[0].volume);
        }
    }
    for (port = 0; port < MIDI_MSIN_PORT_COUNT; port++) {
        if (msinBf[port].length != 0) {
            if ((u32)msinBf[port].length <= sizeof(MSIN_BUFFER)) {
                if (ezTransToIOP2(&((MSIN_BUFFER *)iopMSINBuffAddr)[port], &msinBf[port], sizeof(MSIN_BUFFER)) != 0) {
                    printf("EX MIDI SEND ERR!! SIZE= %d\n", msinBf[port].length);
                }
                msinBf[port].length = 0;
            } else {
                msinBf[port].length = 0;
            }
        }
    }
}

void CSound::Stop(int port) {
    ezMidi(port + 0x20, 0);
    printf("MIDI stop! %d\n", port);
}

void CSound::SetVol(int port, int volume) {
    if (volume != 256) {
        volume = (int) (volume * 2.015748f);
    }

    ezMidi(port + 0xB0, volume);
}

void CSound::SetStereoMode(int mode) {
    ezMidi(0xC0, mode);
}

void CSound::SetMasterVol(int core, int volume) {
    sceSdRemote(1, rSdSetParam, core | SD_P_MVOLL, volume);
    sceSdRemote(1, rSdSetParam, core | SD_P_MVOLR, volume);
}

void CSound::LoadHdBd(int port, int hd, int hd_size, int bd, int bd_size) {
    LoadHdBd2(port, hd, hd_size, bd, bd_size);
}

void CSound::LoadHdBd2(int port, int hd, int hd_size, int bd, int bd_size) {
    int        dependent_port;
    MIDI_PORT *child;
    int        stream_port;
    MSIN_BUFFER *buffer;
    int slot;

    stream_port = port - MIDI_PORT_MSIN_FIRST;
    if (stream_port >= 0) {
        buffer = &msinBf[stream_port];
        buffer->length = 0;
    }
    if (midi_state.port[port].spu_direction == SPU_ALLOC_UPWARD) {
        gBank.spu_address = midi_state.port[port].spu_address;
    }
    if (midi_state.port[port].spu_direction == SPU_ALLOC_DOWNWARD) {
        gBank.spu_address = midi_state.port[port].spu_address - (bd_size + 0x10);
    }
    if (midi_state.port[port].spu_direction == SPU_ALLOC_UPWARD) {
        midi_state.port[port].spu_next_address = bd_size + 0x10 + midi_state.port[port].spu_address;
    }
    if (midi_state.port[port].spu_direction == SPU_ALLOC_DOWNWARD) {
        midi_state.port[port].spu_next_address = midi_state.port[port].spu_address - (bd_size + 0x10);
    }
    printf("###############LOAD PORT_NO=%d #####################\n", port);
    TransHdBd(hd, hd_size, bd, bd_size);
    gBank.bank_no = 0;
    ezMidi(port + 0x20, 0);
    ezMidi(port + 0x9050, (int)&gBank);
    if (midi_state.port[port].linked_port >= 0) {
        ezMidi(midi_state.port[port].linked_port + 0x20, 0);
        ezMidi(midi_state.port[port].linked_port + 0x9050, (int)&gBank);
    }
    for (slot = 0; slot < midi_state.port[port].bank_count; slot++) {
        sceSifInitIopHeap();
        sceSifFreeSysMemory(midi_state.port[port].bank[slot]);
        midi_state.port[port].bank[slot] = NULL;
    }
    midi_state.port[port].bank_count = 0;
    if (midi_state.port[port].sequence_count != 0) {
        ezMidi(port + 0x40, (int)midi_state.port[port].resident_sequence);
    }
    for (int slot = 1; slot < midi_state.port[port].sequence_count; slot++) {
        sceSifInitIopHeap();
        sceSifFreeSysMemory(midi_state.port[port].sequence[slot]);
    }
    midi_state.port[port].sequence_count = 0;
    if (midi_state.port[port].linked_port >= 0) {
        stream_port = midi_state.port[port].linked_port - MIDI_PORT_MSIN_FIRST;
        if (stream_port >= 0) {
            buffer = &msinBf[stream_port];
            buffer->length = 0;
        }
        for (slot = 0; slot < midi_state.port[midi_state.port[port].linked_port].bank_count; slot++) {
            midi_state.port[midi_state.port[port].linked_port].bank[slot] = NULL;
        }
        midi_state.port[midi_state.port[port].linked_port].bank_count = 0;
        if (midi_state.port[midi_state.port[port].linked_port].sequence_count != 0) {
            ezMidi(midi_state.port[port].linked_port + 0x40, (int)midi_state.port[midi_state.port[port].linked_port].resident_sequence);
        }
        for (int slot = 1; slot < midi_state.port[midi_state.port[port].linked_port].sequence_count; slot++) {
            sceSifInitIopHeap();
            sceSifFreeSysMemory(midi_state.port[midi_state.port[port].linked_port].sequence[slot]);
        }
        midi_state.port[midi_state.port[port].linked_port].sequence_count = 0;
    }
    for (slot = 0; slot < midi_state.port[port].dependent_port_count; slot++) {
        dependent_port = midi_state.port[port].dependent_port[slot];
        ezMidi(dependent_port + 0x20, 0);
        child = &midi_state.port[dependent_port];
        child->spu_next_address = child->spu_address = midi_state.port[port].spu_address;
    }
    ezMidi(port + 0xA0, midi_state.port[port].ezmidi_param);
    if (midi_state.port[port].linked_port >= 0) {
        ezMidi(midi_state.port[port].linked_port + 0xA0, midi_state.port[midi_state.port[port].linked_port].ezmidi_param);
    }
    midi_state.port[port].bank[0] = gBank.hd_address;
    for (slot = 0; slot < midi_state.port[port].dependent_port_count; slot++) {
        child = &midi_state.port[midi_state.port[port].dependent_port[slot]];
        child->spu_next_address = child->spu_address = midi_state.port[port].spu_next_address;
    }
    if (midi_state.port[port].linked_port >= 0) {
        midi_state.port[midi_state.port[port].linked_port].bank[0] = midi_state.port[port].bank[0];
        midi_state.port[midi_state.port[port].linked_port].spu_next_address = midi_state.port[port].spu_next_address;
        midi_state.port[midi_state.port[port].linked_port].bank_count++;
    }
    midi_state.port[port].bank_count++;
}

int CSound::LoadHdBdAdd(int port, int hd, int hd_size, int bd, int bd_size) {
    int        dependent;
    int        dependent_port;
    MIDI_PORT *child;
    int        result;
    int        listed_port;

    if (midi_state.port[port].bank_count > MIDI_PORT_BANK_MAX - 1) {
        printf("############################################################Bank MAX OVER!  \n");
        return 0;
    }
    printf("###############ADD LOAD PORT_NO=%d #####################\n", port);
    gBank.bank_no = midi_state.port[port].bank_count;
    if (midi_state.port[port].spu_direction == SPU_ALLOC_UPWARD) {
        gBank.spu_address = midi_state.port[port].spu_next_address;
    }
    if (midi_state.port[port].spu_direction == SPU_ALLOC_DOWNWARD) {
        gBank.spu_address = midi_state.port[port].spu_next_address - (bd_size + 0x10);
    }
    if (midi_state.port[port].spu_direction == SPU_ALLOC_UPWARD) {
        midi_state.port[port].spu_next_address = bd_size + 0x10 + midi_state.port[port].spu_next_address;
    }
    if (midi_state.port[port].spu_direction == SPU_ALLOC_DOWNWARD) {
        midi_state.port[port].spu_next_address -= bd_size + 0x10;
    }
    TransHdBd(hd, hd_size, bd, bd_size);
    midi_state.port[port].bank[midi_state.port[port].bank_count] = gBank.hd_address;
    for (dependent = 0; dependent < midi_state.port[port].dependent_port_count; dependent++) {
        dependent_port = listed_port = midi_state.port[port].dependent_port[dependent];
        child = &midi_state.port[dependent_port];
        child->spu_next_address = child->spu_address = midi_state.port[port].spu_next_address;
    }
    result = ezMidi(port + 0x9050, (int)&gBank);
    if (midi_state.port[port].linked_port >= 0) {
        result = ezMidi(midi_state.port[port].linked_port + 0x9050, (int)&gBank);
    }
    if (midi_state.port[port].linked_port >= 0) {
        midi_state.port[midi_state.port[port].linked_port].bank[midi_state.port[port].bank_count] = midi_state.port[port].bank[midi_state.port[port].bank_count];
        midi_state.port[midi_state.port[port].linked_port].spu_next_address = midi_state.port[port].spu_next_address;
        midi_state.port[midi_state.port[port].linked_port].bank_count++;
    }
    midi_state.port[port].bank_count++;
    return result;
}

int CSound::LoadSeq(int port, int address, int size) {
    void *sequence;

    ezMidi(port + 0x20, 0);
    printf("LOAD_SEQ PORT=%d!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n", port);
    sceSifInitIopHeap();
    if (size <= 256) {
        sequence = sceSifAllocSysMemory(1, 256, NULL);
    } else {
        sequence = sceSifAllocSysMemory(1, size + 256, NULL);
    }
    if (sequence == NULL) {
        printf("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@AllocIopHeap Err\n");
        return -1;
    }
    printf("AllocIopHeap %d \n", sequence);
    midi_state.port[port].sequence[midi_state.port[port].sequence_count] = sequence;
    ezTransToIOP2(sequence, (void *)address, size);
    if (midi_state.port[port].sequence_count == 0) {
        ezMidi(port + 0x40, (int)sequence);
        if (midi_state.port[port].resident_sequence != NULL) {
            sceSifFreeSysMemory(midi_state.port[port].resident_sequence);
        }
        midi_state.port[port].resident_sequence = sequence;
    }
    midi_state.port[port].sequence_count++;
    printf("LOAD_SEQ cnt=%d!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n", midi_state.port[port].sequence_count);
    if (midi_state.port[port].sequence_count > 15) {
        printf("SEQ_MAX OVER!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
    }
    return 0;
}

void CSound::SE_SetPitch(int port, int bank, int program, int key, int pitch, int id) {
    u8  message[7];
    u32 stream_port;

    if (id > 0x7E) {
        printf(" ################################SE_ID ERR!! PORT NO=%d !!!\n", port);
        return;
    }

    stream_port = port - MIDI_PORT_MSIN_FIRST;
    sceMSIn_PutMsg(&msinCtx, stream_port, ((bank & 0x7F) << 16) | 0xB0);
    sceMSIn_PutMsg(&msinCtx, stream_port, ((program & 0x7F) << 8) | 0xC0);
    message[0] = 0xFD;
    message[1] = 2;
    message[2] = 0;
    message[3] = key;
    message[4] = id;
    message[5] = pitch & 0x7F;
    message[6] = (pitch >> 7) & 0x7F;
    sceMSIn_PutHsMsg(&msinCtx, stream_port, message);
}

void CSound::StreamOpenFast(int channel, char *name) {
    char file_name[64];

    strcpy(file_name, name);
    ezBgm(channel | 0x80, 0);
    bgm_info[channel] = ezBgm(channel | EZBGM_OPEN, (int) file_name);
}

void CSound::StreamOpenFromFPLFast(int channel, char *name, char *pack_name) {
    STREAM_PACK_REQUEST request;

    strcpy(request.name, name);
    strcpy(request.pack_name, pack_name);
    ezBgm(channel | 0x80, 0);
    bgm_info[channel] = ezBgm(channel | EZBGM_OPEN_FROM_PACK, (int) &request);
}

void CSound::StreamPlay(int channel) {
    ezBgm(channel | 0x50, 0);
}

void CSound::StreamStop(int channel) {
    ezBgm(channel | 0x60, 0);
}

void CSound::StreamClose(int channel) {
    ezBgm(channel | 0x60, 0);
    ezBgm(channel | 0x30, 0);
    ezBgm(channel | 0x10, 0);
}

void CSound::StreamEND(int channel) {
    ezBgm(channel | 0x60, 0);
    ezBgm(channel | 0x70, 0);
    ezBgm(channel | 0x10, 0);
}

void CSound::StreamPause(int channel) {
    ezBgm(channel | 0x60, 0);
}

void CSound::StreamRePlay(int channel) {
    ezBgm(channel | 0x50, 0);
}

void CSound::StreamSetVol(int channel, int left, int right) {
    ezBgm(channel | 0x80, (left << 16) | right);
}

int CSound::StreamGetState(int channel) {
    return ezBgm(channel | 0x80B0, 0) & ~0xFFF;
}

int CSound::StreamGetLevel(int channel) {
    return ezBgm(channel | 0x80E0, 0);
}

void CSound::StreamStandBy(int channel) {
    bgm_info[channel] = ezBgm(channel | 0x80D0, 0);

    if (!(bgm_info[channel] & 0x1)) {
        printf("mono \n");
        ezBgm(channel | 0x8000, 0x3000);
        ezBgm(channel | 0x80C0, 0x10);
    } else {
        printf("stereo \n");
        ezBgm(channel | 0x8000, 0x4000);
        ezBgm(channel | 0x80C0, 0);
    }

    ezBgm(channel | EZBGM_PRELOAD, 0);
}

int CSound::TransBdState(int channel) {
    return sceSdRemote(1, rSdVoiceTransStatus, channel, SD_TRANS_STATUS_CHECK);
}
