#include "common.h"
#include "sound.hpp"

#include <cstdio>
#include <cstring>
#include <eekernel.h>
#include <libsdr.h>
#include <modmsin.h>
#include <sifrpc.h>

#include "ezbgm.hpp"
#include "ezmidi.hpp"

#ifdef NONMATCHING
static void          *iopMSINBuffAddr;              /**< IOP destination of the MIDI stream buffers. */
static int            bgm_info[2];                  /**< Layout information returned for each stream channel. */
static int            bd_size_total;                /**< Accumulated bank body size. */
static sceCslCtx      msinCtx;                      /**< Context of the MIDI stream input module. */
static sceCslBuffGrp  msinBfGrp[2];                 /**< Input and output buffer groups of the MIDI stream module. */
static sceCslBuffCtx  msinBfCtx[MIDI_MSIN_PORT_COUNT]; /**< Contexts of the MIDI message buffers. */
static MSIN_BUFFER    msinBf[MIDI_MSIN_PORT_COUNT];  /**< MIDI messages waiting to be sent to the IOP. */
static MIDI_BANK      gBank;                        /**< Description of the bank being transferred. */
static MIDI_STATE     midi_state;                   /**< Banks, sequences and fades of each MIDI port. */
#endif

// Code (.text)
void CSound::StopVoice(int core) {
    sceSdRemote(1, rSdSetSwitch, core | SD_S_KOFF, 0xFFFFFF);
    printf("voice completed Core=%d\n", core);
}
extern "C" void SndInReverb__6CSoundFb(CSound *self, int on) {
    if (on != 0) {
        sceSdRemote(1, 0x8010, 0x800, -4);
        sceSdRemote(1, 0x8010, 0x801, -4);
        return;
    }
    sceSdRemote(1, 0x8010, 0x800, -0x34);
    sceSdRemote(1, 0x8010, 0x801, -0x34);
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

#ifdef NONMATCHING
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
    ezTransToIOP2(header, (void *)hd, hd_size);
    gBank.hd_address = header;
    gBank.bd_size = bd_size;
    gBank.bd_address = iop_bd_addr;
    printf(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>SPU ADDR==%d size=%d!!!!!!!!!!\n", gBank.spu_address, bd_size);
    if ((u32)gBank.spu_address < 0x18AE20 && (u32)(gBank.spu_address + bd_size) > 0x18AE20) {
        printf(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>SYS AREA HAKAI????addr=%d size=%d!!!!!!!!!!\n", gBank.spu_address, bd_size);
    }
    if (bd_size <= 0x6DE00) {
        sceSdRemote(1, rSdVoiceTransStatus, 1, SD_TRANS_STATUS_WAIT);
        ezTransToIOP2(iop_bd_addr, (void *)bd, bd_size);
        FlushCache(0);
        sceSdRemote(1, rSdVoiceTrans, 1, SD_TRANS_MODE_WRITE, gBank.bd_address, gBank.spu_address, bd_size);
    } else {
        sceSdRemote(1, rSdVoiceTransStatus, 1, SD_TRANS_STATUS_WAIT);
        ezTransToIOP2(iop_bd_addr, (void *)bd, 0x6DD00);
        FlushCache(0);
        sceSdRemote(1, rSdVoiceTrans, 1, SD_TRANS_MODE_WRITE, gBank.bd_address, gBank.spu_address, 0x6DD00);
        sceSdRemote(1, rSdVoiceTransStatus, 1, SD_TRANS_STATUS_WAIT);
        ezTransToIOP2(iop_bd_addr, (void *)(bd + 0x6DD00), bd_size - 0x6DD00);
        FlushCache(0);
        sceSdRemote(1, rSdVoiceTrans, 1, SD_TRANS_MODE_WRITE, gBank.bd_address, gBank.spu_address + 0x6DD00, bd_size - 0x6DD00);
    }
    return 0;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sound", TransHdBd__Fiiii);
#endif

#ifdef NONMATCHING
int CSound::Init(int mode0, int mode1, int depth0, int depth1) {
    static int load_m_flg = 0;
    int        port;
    int        slot;
    MIDI_PORT *state;

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
        msinCtx.conf = NULL;
        msinCtx.callBack = NULL;
        msinCtx.extmod = NULL;
        msinBfGrp[0].buffNum = 0;
        msinBfGrp[0].buffCtx = NULL;
        msinBfGrp[1].buffNum = MIDI_MSIN_PORT_COUNT;
        msinBfGrp[1].buffCtx = msinBfCtx;
        for (port = 0; port < MIDI_MSIN_PORT_COUNT; port++) {
            msinBfCtx[port].sema = 0;
            msinBfCtx[port].buff = &msinBf[port];
            msinBf[port].size = sizeof(MSIN_BUFFER);
            msinBf[port].length = 0;
        }
        if (sceMSIn_Init(&msinCtx) != 0) {
            printf("sceMSIn_Init Error\n");
            return 1;
        }
        bd_size_total = 0;
        for (port = 0; port < MIDI_PORT_COUNT; port++) {
            state = &midi_state.port[port];
            state->unk_00 = 0;
            state->spu_direction = SPU_ALLOC_UPWARD;
            state->linked_port = -1;
            for (slot = 0; slot < MIDI_PORT_BANK_MAX; slot++) {
                state->dependent_port[slot] = -1;
            }
            state->dependent_port_count = 0;
            for (slot = 0; slot < MIDI_PORT_BANK_MAX; slot++) {
                state->bank[slot] = NULL;
            }
            state->bank_count = 0;
            state->unk_98 = 0;
            state->spu_next_address = 0;
            for (slot = 0; slot < MIDI_PORT_SEQ_MAX; slot++) {
                state->sequence[slot] = NULL;
            }
            state->resident_sequence = NULL;
            for (slot = 0; slot < MIDI_PORT_SEQ_MAX; slot++) {
                state->unk_CC[slot] = 0;
            }
            state->sequence_count = 0;
            state->fade[0].active = 0;
            state->fade[1].active = 0;
            state->unk_118 = 0;
            state->unk_11C = 0;
            state->unk_120 = 0;
        }
        midi_state.port[0].unk_00 = 0;
        midi_state.port[15].unk_118 = 1;
        midi_state.port[13].unk_118 = 1;
        midi_state.port[3].unk_00 = 0;
        midi_state.port[10].dependent_port[0] = 8;
        midi_state.port[10].unk_00 = 0;
        midi_state.port[10].dependent_port_count = 5;
        midi_state.port[8].dependent_port_count = 4;
        midi_state.port[1].dependent_port_count = 3;
        midi_state.port[8].unk_00 = 2;
        midi_state.port[1].unk_00 = 2;
        midi_state.port[15].unk_00 = 2;
        midi_state.port[2].unk_00 = 2;
        midi_state.port[14].unk_00 = 2;
        midi_state.port[13].unk_00 = 1;
        midi_state.port[7].unk_00 = 0;
        midi_state.port[9].unk_00 = 0;
        midi_state.port[12].unk_00 = 0;
        midi_state.port[10].unk_98 = 0x3037;
        midi_state.port[8].unk_98 = 0x3035;
        midi_state.port[1].unk_98 = 0x3032;
        midi_state.port[15].unk_98 = 0x3031;
        midi_state.port[11].unk_00 = 0;
        midi_state.port[13].unk_98 = 0x3036;
        midi_state.port[7].unk_98 = 0x3010;
        midi_state.port[9].unk_98 = 0x3038;
        midi_state.port[12].unk_98 = 0x3034;
        midi_state.port[11].unk_98 = 0x3033;
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
        midi_state.port[15].dependent_port_count = 2;
        midi_state.port[0].spu_next_address = midi_state.port[0].spu_address = 0x5210;
        midi_state.port[3].spu_next_address = midi_state.port[3].spu_address = 0x5210;
        midi_state.port[10].spu_next_address = midi_state.port[10].spu_address = 0x7D210;
        midi_state.port[8].spu_next_address = midi_state.port[8].spu_address = 0x7D210;
        midi_state.port[1].spu_next_address = midi_state.port[1].spu_address = 0x7D210;
        midi_state.port[15].spu_next_address = midi_state.port[15].spu_address = 0x7D210;
        midi_state.port[2].spu_next_address = midi_state.port[2].spu_address = 0x7D210;
        midi_state.port[14].spu_next_address = midi_state.port[14].spu_address = 0x7D210;
        midi_state.port[13].spu_next_address = midi_state.port[13].spu_address = 0x18AE20;
        midi_state.port[7].spu_next_address = midi_state.port[7].spu_address = 0x18AE20;
        midi_state.port[9].spu_next_address = midi_state.port[9].spu_address = 0x1E0000;
        midi_state.port[12].spu_next_address = midi_state.port[12].spu_address = 0x18AE20;
        midi_state.port[11].spu_next_address = midi_state.port[11].spu_address = 0x1A82E0;
        midi_state.port[0].unk_98 = 0x3040;
        midi_state.port[3].unk_98 = 0x3040;
        midi_state.port[2].unk_98 = 0x3039;
        midi_state.port[14].unk_98 = 0x3039;
        return 0;
    }
    return 0;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sound", Init__6CSoundFiiii);
#endif

#ifdef NONMATCHING
int CSound::Exit() {
    int         port;
    int         slot;
    MIDI_PORT  *state;

    for (port = 0; port < MIDI_PORT_COUNT; port++) {
        ezMidi(port + 0x20, 0);
        state = &midi_state.port[port];
        for (slot = 0; slot < state->bank_count; slot++) {
            sceSifInitIopHeap();
            sceSifFreeSysMemory(state->bank[slot]);
            state->bank[slot] = NULL;
        }
        state->bank_count = 0;
        for (slot = 0; slot < state->sequence_count; slot++) {
            sceSifInitIopHeap();
            sceSifFreeSysMemory(state->sequence[slot]);
        }
        state->sequence_count = 0;
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
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sound", Exit__6CSoundFv);
#endif

#ifdef NONMATCHING
void CSound::DEL_PORT(int port) {
    int        slot;
    int        dependent;
    int        dependent_port;
    MIDI_PORT *state;
    MIDI_PORT *linked;
    MIDI_PORT *child;

    printf("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$DEL PORT %d\n", port);
    if (port - MIDI_PORT_MSIN_FIRST >= 0) {
        msinBf[port - MIDI_PORT_MSIN_FIRST].length = 0;
    }
    ezMidi(port + 0x20, 0);
    state = &midi_state.port[port];
    if (state->sequence_count != 0) {
        ezMidi(port + 0x40, (int)state->resident_sequence);
    }
    for (slot = 1; slot < state->sequence_count; slot++) {
        sceSifInitIopHeap();
        sceSifFreeSysMemory(state->sequence[slot]);
    }
    state->sequence_count = 0;
    if (state->linked_port >= 0) {
        if (state->linked_port - MIDI_PORT_MSIN_FIRST >= 0) {
            msinBf[state->linked_port - MIDI_PORT_MSIN_FIRST].length = 0;
        }
        ezMidi(state->linked_port + 0x20, 0);
        linked = &midi_state.port[state->linked_port];
        if (linked->sequence_count != 0) {
            ezMidi(state->linked_port + 0x40, (int)linked->resident_sequence);
        }
        for (slot = 1; slot < linked->sequence_count; slot++) {
            sceSifInitIopHeap();
            sceSifFreeSysMemory(linked->sequence[slot]);
            linked->sequence[slot] = NULL;
        }
        linked->sequence_count = 0;
    }
    for (dependent = 0; dependent < state->dependent_port_count; dependent++) {
        dependent_port = state->dependent_port[dependent];
        if (dependent_port - MIDI_PORT_MSIN_FIRST >= 0) {
            msinBf[dependent_port - MIDI_PORT_MSIN_FIRST].length = 0;
        }
        ezMidi(dependent_port + 0x20, 0);
        child = &midi_state.port[dependent_port];
        child->spu_address = state->spu_address;
        child->spu_next_address = state->spu_address;
        if (child->sequence_count != 0) {
            ezMidi(dependent_port + 0x40, (int)child->resident_sequence);
        }
        for (slot = 1; slot < child->sequence_count; slot++) {
            sceSifInitIopHeap();
            sceSifFreeSysMemory(child->sequence[slot]);
            child->sequence[slot] = NULL;
        }
        child->sequence_count = 0;
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sound", DEL_PORT__6CSoundFi);
#endif

#ifdef NONMATCHING
void CSound::SQ_Play(int port, int seq_no, int volume) {
    void *sequence;

    if (seq_no >= midi_state.port[port].sequence_count) {
        printf("###############NOT FOUND SEQ_NO=%d #####################\n", seq_no);
        return;
    }
    sequence = midi_state.port[port].sequence[seq_no];
    ezMidi(port + 0x20, 0);
    printf("MIDI start! port=%d \n", port);
    ezMidi(port + 0x40, (int)sequence);
    printf("###############PLAY SEQ_NO=%d PORT=%d#####################\n", seq_no, port);
    if (volume != 256) {
        volume = (int)(volume * 2.015748f);
    }
    ezMidi(port + 0xB0, volume);
    ezMidi(port + 0x30, 0);
    ezMidi(port, 0);
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sound", SQ_Play__6CSoundFiii);
#endif

#ifdef NONMATCHING
void CSound::SQ_RePlay(int port) {
    if (midi_state.port[port].sequence_count > 0) {
        printf("MIDI restart! port=%d \n", port);
        ezMidi(port, 0);
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sound", SQ_RePlay__6CSoundFi);
#endif

#ifdef NONMATCHING
void CSound::SE_Play(int port, int bank, int program, int key, int pan, int velocity, int volume, int pitch, int id) {
    u8  message[7];
    u32 stream_port;

    if (id >= 0x7F) {
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
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sound", SE_Play__6CSoundFiiiiiiiii);
#endif

#ifdef NONMATCHING
void CSound::SE_SetVol(int port, int bank, int program, int key, int volume, int id) {
    u8  message[7];
    u32 stream_port;

    if (id >= 0x7F) {
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
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sound", SE_SetVol__6CSoundFiiiiii);
#endif

#ifdef NONMATCHING
void CSound::SE_SetPan(int port, int bank, int program, int key, int pan, int id) {
    u8  message[7];
    u32 stream_port;

    if (id >= 0x7F) {
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
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sound", SE_SetPan__6CSoundFiiiiii);
#endif

#ifdef NONMATCHING
void CSound::SE_Stop(int port, int bank, int program, int key, int id) {
    u8  message[7];
    u32 stream_port;

    if (id >= 0x7F) {
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
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sound", SE_Stop__6CSoundFiiiii);
#endif

#ifdef NONMATCHING
void CSound::Step() {
    int          port;
    MIDI_FADE   *fade;
    MSIN_BUFFER *buffer;

    for (port = 0; port < MIDI_PORT_COUNT; port++) {
        fade = &midi_state.port[port].fade[0];
        if (fade->active != 0) {
            fade->volume += fade->step;
            if (!(fade->step <= 0.0f)) {
                if (!(fade->volume <= (float)fade->target_volume)) {
                    fade->volume = (float)fade->target_volume;
                    fade->active = 0;
                }
            }
            if (fade->step < 0.0f) {
                if (fade->volume < (float)fade->target_volume) {
                    fade->volume = (float)fade->target_volume;
                    fade->active = 0;
                }
            }
            SetVol(0, (int)fade->volume);
        }
    }
    for (port = 0; port < MIDI_MSIN_PORT_COUNT; port++) {
        buffer = &msinBf[port];
        if (buffer->length != 0) {
            if ((u32)buffer->length <= sizeof(MSIN_BUFFER)) {
                if (ezTransToIOP2(&((MSIN_BUFFER *)iopMSINBuffAddr)[port], buffer, sizeof(MSIN_BUFFER)) != 0) {
                    printf("EX MIDI SEND ERR!! SIZE= %d\n", buffer->length);
                }
            }
            buffer->length = 0;
        }
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sound", Step__6CSoundFv);
#endif

void CSound::Stop(int port) {
    ezMidi(port + 0x20, 0);
    printf("MIDI stop! %d\n", port);
}

void CSound::SetVol(int port, int volume) {
    if (volume != 256) {
        volume = (int)(volume * 2.015748f);
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

#ifdef NONMATCHING
void CSound::LoadHdBd2(int port, int hd, int hd_size, int bd, int bd_size) {
    int        slot;
    int        dependent;
    int        dependent_port;
    MIDI_PORT *state;
    MIDI_PORT *linked;
    MIDI_PORT *child;

    if (port - MIDI_PORT_MSIN_FIRST >= 0) {
        msinBf[port - MIDI_PORT_MSIN_FIRST].length = 0;
    }
    state = &midi_state.port[port];
    if (state->spu_direction == SPU_ALLOC_UPWARD) {
        gBank.spu_address = state->spu_address;
    }
    if (state->spu_direction == SPU_ALLOC_DOWNWARD) {
        gBank.spu_address = state->spu_address - (bd_size + 0x10);
    }
    if (state->spu_direction == SPU_ALLOC_UPWARD) {
        state->spu_next_address = bd_size + 0x10 + state->spu_address;
    }
    if (state->spu_direction == SPU_ALLOC_DOWNWARD) {
        state->spu_next_address = state->spu_address - (bd_size + 0x10);
    }
    printf("###############LOAD PORT_NO=%d #####################\n", port);
    TransHdBd(hd, hd_size, bd, bd_size);
    gBank.bank_no = 0;
    ezMidi(port + 0x20, 0);
    ezMidi(port + 0x9050, (int)&gBank);
    if (state->linked_port >= 0) {
        ezMidi(state->linked_port + 0x20, 0);
        ezMidi(state->linked_port + 0x9050, (int)&gBank);
    }
    for (slot = 0; slot < state->bank_count; slot++) {
        sceSifInitIopHeap();
        sceSifFreeSysMemory(state->bank[slot]);
        state->bank[slot] = NULL;
    }
    state->bank_count = 0;
    if (state->sequence_count != 0) {
        ezMidi(port + 0x40, (int)state->resident_sequence);
    }
    for (slot = 1; slot < state->sequence_count; slot++) {
        sceSifInitIopHeap();
        sceSifFreeSysMemory(state->sequence[slot]);
    }
    state->sequence_count = 0;
    if (state->linked_port >= 0) {
        if (state->linked_port - MIDI_PORT_MSIN_FIRST >= 0) {
            msinBf[state->linked_port - MIDI_PORT_MSIN_FIRST].length = 0;
        }
        linked = &midi_state.port[state->linked_port];
        for (slot = 0; slot < linked->bank_count; slot++) {
            linked->bank[slot] = NULL;
        }
        linked->bank_count = 0;
        if (linked->sequence_count != 0) {
            ezMidi(state->linked_port + 0x40, (int)linked->resident_sequence);
        }
        for (slot = 1; slot < linked->sequence_count; slot++) {
            sceSifInitIopHeap();
            sceSifFreeSysMemory(linked->sequence[slot]);
        }
        linked->sequence_count = 0;
    }
    for (dependent = 0; dependent < state->dependent_port_count; dependent++) {
        dependent_port = state->dependent_port[dependent];
        ezMidi(dependent_port + 0x20, 0);
        child = &midi_state.port[dependent_port];
        child->spu_address = state->spu_address;
        child->spu_next_address = state->spu_address;
    }
    ezMidi(port + 0xA0, state->unk_98);
    if (state->linked_port >= 0) {
        ezMidi(state->linked_port + 0xA0, midi_state.port[state->linked_port].unk_98);
    }
    state->bank[0] = gBank.hd_address;
    for (dependent = 0; dependent < state->dependent_port_count; dependent++) {
        child = &midi_state.port[state->dependent_port[dependent]];
        child->spu_address = state->spu_next_address;
        child->spu_next_address = state->spu_next_address;
    }
    if (state->linked_port >= 0) {
        linked = &midi_state.port[state->linked_port];
        linked->bank[0] = state->bank[0];
        linked->spu_next_address = state->spu_next_address;
        linked->bank_count++;
    }
    state->bank_count++;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sound", LoadHdBd2__6CSoundFiiiii);
#endif

#ifdef NONMATCHING
int CSound::LoadHdBdAdd(int port, int hd, int hd_size, int bd, int bd_size) {
    int        dependent;
    int        result;
    MIDI_PORT *state;
    MIDI_PORT *linked;
    MIDI_PORT *child;

    state = &midi_state.port[port];
    if (state->bank_count >= MIDI_PORT_BANK_MAX) {
        printf("############################################################Bank MAX OVER!  \n");
        return 0;
    }
    printf("###############ADD LOAD PORT_NO=%d #####################\n", port);
    gBank.bank_no = state->bank_count;
    if (state->spu_direction == SPU_ALLOC_UPWARD) {
        gBank.spu_address = state->spu_next_address;
    }
    if (state->spu_direction == SPU_ALLOC_DOWNWARD) {
        gBank.spu_address = state->spu_next_address - (bd_size + 0x10);
    }
    if (state->spu_direction == SPU_ALLOC_UPWARD) {
        state->spu_next_address += bd_size + 0x10;
    }
    if (state->spu_direction == SPU_ALLOC_DOWNWARD) {
        state->spu_next_address -= bd_size + 0x10;
    }
    TransHdBd(hd, hd_size, bd, bd_size);
    state->bank[state->bank_count] = gBank.hd_address;
    for (dependent = 0; dependent < state->dependent_port_count; dependent++) {
        child = &midi_state.port[state->dependent_port[dependent]];
        child->spu_address = state->spu_next_address;
        child->spu_next_address = state->spu_next_address;
    }
    result = ezMidi(port + 0x9050, (int)&gBank);
    if (state->linked_port >= 0) {
        result = ezMidi(state->linked_port + 0x9050, (int)&gBank);
    }
    if (state->linked_port >= 0) {
        linked = &midi_state.port[state->linked_port];
        linked->bank[state->bank_count] = state->bank[state->bank_count];
        linked->spu_next_address = state->spu_next_address;
        linked->bank_count++;
    }
    state->bank_count++;
    return result;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sound", LoadHdBdAdd__6CSoundFiiiii);
#endif

#ifdef NONMATCHING
int CSound::LoadSeq(int port, int address, int size) {
    void      *sequence;
    MIDI_PORT *state;

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
    state = &midi_state.port[port];
    state->sequence[state->sequence_count] = sequence;
    ezTransToIOP2(sequence, (void *)address, size);
    if (state->sequence_count == 0) {
        ezMidi(port + 0x40, (int)sequence);
        if (state->resident_sequence != NULL) {
            sceSifFreeSysMemory(state->resident_sequence);
        }
        state->resident_sequence = sequence;
    }
    state->sequence_count++;
    printf("LOAD_SEQ cnt=%d!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n", state->sequence_count);
    if (state->sequence_count >= 16) {
        printf("SEQ_MAX OVER!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
    }
    return 0;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sound", LoadSeq__6CSoundFiii);
#endif

#ifdef NONMATCHING
void CSound::SE_SetPitch(int port, int bank, int program, int key, int pitch, int id) {
    u8  message[7];
    u32 stream_port;

    if (id >= 0x7F) {
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
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sound", SE_SetPitch__6CSoundFiiiiii);
#endif

#ifdef NONMATCHING
void CSound::StreamOpenFast(int channel, char *name) {
    char file_name[64];

    strcpy(file_name, name);
    ezBgm(channel | 0x80, 0);
    bgm_info[channel] = ezBgm(channel | EZBGM_OPEN, (int)file_name);
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sound", StreamOpenFast__6CSoundFiPc);
#endif

#ifdef NONMATCHING
void CSound::StreamOpenFromFPLFast(int channel, char *name, char *pack_name) {
    STREAM_PACK_REQUEST request;

    strcpy(request.name, name);
    strcpy(request.pack_name, pack_name);
    ezBgm(channel | 0x80, 0);
    bgm_info[channel] = ezBgm(channel | EZBGM_OPEN_FROM_PACK, (int)&request);
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sound", StreamOpenFromFPLFast__6CSoundFiPcPc);
#endif

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

#ifdef NONMATCHING
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
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sound", StreamStandBy__6CSoundFi);
#endif

int CSound::TransBdState(int channel) {
    return sceSdRemote(1, rSdVoiceTransStatus, channel, SD_TRANS_STATUS_CHECK);
}


// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sound", at_218__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sound", at_278__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sound", at_279__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sound", at_280__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sound", at_281__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sound", at_282__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sound", at_283__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sound", at_474__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sound", at_475__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sound", at_476__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sound", at_477__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sound", at_564__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sound", at_576__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sound", at_577__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sound", at_578__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sound", at_595__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sound", at_613__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sound", at_728__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sound", at_733__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sound", at_843__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sound", at_883__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sound", at_884__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sound", at_904__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sound", at_905__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sound", at_906__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sound", at_907__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sound", at_908__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sound", at_929__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sound", at_930__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(iopMSINBuffAddr, 0x8);
INCLUDE_BSS(bgm_info, 0x8);
INCLUDE_BSS(iop_bd_addr, 0x4);
INCLUDE_BSS(bd_size_total, 0x4);
INCLUDE_BSS(load_m_flg_351, 0x4);
INCLUDE_BSS(init_352, 0x4);

// Uninitialised data (.bss)
INCLUDE_BSS(msinCtx, 0x1C);
INCLUDE_BSS(D_003F3F6C, 0x4);
INCLUDE_BSS(msinBfGrp, 0x10);
INCLUDE_BSS(msinBfCtx, 0x80);
INCLUDE_BSS(msinBf, 0x1200);
INCLUDE_BSS(gBank, 0x50);
INCLUDE_BSS(midi_state, 0x1270);
