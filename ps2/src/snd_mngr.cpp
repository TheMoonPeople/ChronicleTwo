#include "common.h"
#include "mw_runtime.h"

#include <eekernel.h>
#include <libvu0.h>

#include <cstdio>
#include <cstdlib>
#include <cstring>

#include "dataread.hpp"
#include "mainloop.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mglib.hpp"
#include "snd_mngr.hpp"
#include "snd_seseq.hpp"
#include "sound.hpp"

/**
 *
 * Enables loading sound banks.
 *
 */
static int EnableSndMngr = 1;

/**
 *
 * Semaphore that serializes sound driver calls.
 *
 */
static int snd_sema_id = -1;

/**
 *
 * Master volume scale for each sound core.
 *
 */
static float MasterVol[2] = {1.0f, 1.0f};

/**
 *
 * Active master-volume fade flag for each sound core.
 *
 */
static int MasterVolFade[2] = {0, 0};

/**
 *
 * Last vertical sync on which the sound driver stepped.
 *
 */
static int snd_old_vsync = -1;

/**
 *
 * Selected reverb type for each sound core.
 *
 */
static int ReverbType[2];

/**
 *
 * Selected reverb depth for each sound core.
 *
 */
static int ReverbDepthe[2];

/**
 *
 * Indicates that the sound driver has been initialized.
 *
 */
static int init_snd;

/**
 *
 * Target master volume of each core fade.
 *
 */
static float feMasterVol[2];

/**
 *
 * Current interpolated master volume of each core fade.
 *
 */
static float fnowMasterVol[2];

/**
 *
 * Master-volume increment applied by each core fade.
 *
 */
static float fstpMasterVol[2];

/**
 *
 * Bank and sequence state for each game sound port.
 *
 */
sndPortInfo PortInfo[SND_PORT_NUM];

/**
 *
 * Playback state of the sound-effect sequence slots.
 *
 */
static sndCSeSeq SeSequencer[32];

/**
 *
 * Playback volume scale for each game sound port.
 *
 */
static float PortVolf[SND_PORT_NUM];

/**
 *
 * Listener position used by positional sound effects.
 *
 */
static sceVu0FVECTOR MicPos;

/**
 *
 * Listener forward direction used by positional sound effects.
 *
 */
static sceVu0FVECTOR MicDir;

static sndPortInfo *GetPortInfo(int port);
static sndSeInfo   *GetSeInfo(u32 snd_id, int se_no);
static sndCSeSeq   *GetSeSeq(int seq_id);
static int          CSndStep();
static int          IsBgmPort(int port);

inline sndCSeSeqData *sndBankInfo::GetSeSeqData(int seseq_no) {
    if (seseq_no < 0 || seseq_no >= seseq_num) {
        return NULL;
    }

    return &seseq[seseq_no];
}

static void StopSeSeq(int seq_id);
static int  GetCSndPortNo(int port_no, int *port, int *sq_port, int *vol);
static void FadeMasterVol();
static void SetMasterVol(int core, float vol);
static void SeAllStop_Sub(int port_no);

static sndBankInfo *GetBankInfo(unsigned int snd_id);
static int          PlaySeSeq(unsigned int snd_id, sndCSeSeqData *data, int vol);
static void         SetVolSeSeq(int index, int vol);
static int          GetPortBankNo(unsigned int snd_id, int *port, int *bank);

#ifdef NONMATCHING
static void  CSndStepWait();
static char *GetLine(char **col, char *text, char *end);
#endif

// Code (.text)
int CLoopSeMngr::Create(int sequence_count, mgCMemory *memory) {
    unsigned int byte_count;
    unsigned int quadwords;

    if (memory == NULL) {
        return 0;
    }

    byte_count = sequence_count * sizeof(SND_LOOP_SE_SEQ);

    if (byte_count & 0xF) {
        quadwords = (byte_count >> 4) + 1;
    } else {
        quadwords = byte_count >> 4;
    }

    loop_se = new (memory->Alloc(quadwords + 2)) SND_LOOP_SE_SEQ[sequence_count];

    if (loop_se == NULL) {
        return 0;
    }

    loop_se_num = sequence_count;
    return 1;
}

SND_LOOP_SE_SEQ::SND_LOOP_SE_SEQ() {
    se_id = -1;
    vol = -1.0f;
    pan = 0.0f;
}

void CLoopSeMngr::Initialize() {
    loop_se_num = 0;
    loop_se = NULL;
}

void CLoopSeMngr::Clear() {
    if (loop_se != NULL) {
        for (int index = 0; index < loop_se_num; index++) {
            SND_LOOP_SE_SEQ *entry = &loop_se[index];
            entry->se_id = -1;
            entry->vol = -1.0f;
            entry->pan = 0.0f;
        }
    }
}

SND_LOOP_SE_SEQ *CLoopSeMngr::GetLoopSe(int *found, unsigned int se_id, int voice) {
    SND_LOOP_SE_SEQ *free_entry;
    int              i;

    if (loop_se == NULL) {
        return NULL;
    }

    *found = 0;
    free_entry = NULL;

    for (i = 0; i < loop_se_num; i++) {
        if ((int) loop_se[i].se_id < 0) {
            free_entry = &loop_se[i];
            break;
        }
    }

    if ((int) se_id >= 0) {
        for (i = 0; i < loop_se_num; i++) {
            if ((int) loop_se[i].se_id >= 0 && se_id == loop_se[i].se_id && voice == loop_se[i].voice) {
                *found = 1;
                return &loop_se[i];
            }
        }
    }

    return free_entry;
}

int CLoopSeMngr::SeLoopPlayStop(u32 handle, int sound, int flags, int loop) {
    return SeLoopPlayStop(handle, sound, flags, -1.0f, 0.0f, loop);
}

int CLoopSeMngr::SeLoopPlayStop(unsigned int snd_id, int se_no, int keep_time, float vol, float pan, int voice) {
    SND_LOOP_SE_SEQ *entry;
    int              found;

    if ((int) snd_id < 0 || se_no < 0) {
        return 0;
    }

    snd_id = sndCreateID(snd_id, se_no);
    entry = GetLoopSe(&found, snd_id, voice);

    if (entry == NULL) {
        return 0;
    }

    entry->se_id = snd_id;
    entry->keep_time = keep_time;
    entry->vol = vol;
    entry->pan = pan;

    if (found != 0) {
        entry->count = 1;
    } else {
        entry->count = 0;
    }

    entry->voice = voice;
    return 1;
}

void CLoopSeMngr::Step() {
    SND_LOOP_SE_SEQ *entry;
    int              i;
    int              se_no;

    if (loop_se != NULL) {
        for (i = 0; i < loop_se_num; i++) {
            entry = &loop_se[i];

            if ((int) entry->se_id >= 0) {
                se_no = sndGetSeNo(entry->se_id);

                if (entry->count == 0) {
                    if (entry->vol >= 0.0f) {
                        sndSePlayVPf(entry->se_id, se_no, entry->vol, entry->pan, entry->voice);
                    } else {
                        sndSePlay(entry->se_id, se_no, entry->voice);
                    }
                } else if (entry->vol >= 0.0f) {
                    sndSetSeVolf(entry->se_id, se_no, entry->vol, entry->voice);
                    sndSetSePanf(entry->se_id, se_no, entry->pan, entry->voice);
                }

                if (entry->count >= entry->keep_time) {
                    sndSeStop(entry->se_id, se_no, entry->voice);
                    entry->se_id = -1;
                    entry->vol = -1.0f;
                    entry->pan = 0.0f;
                }

                entry->count++;
            }
        }
    }
}

void CLoopSeMngr::AllSeStop() {
    SND_LOOP_SE_SEQ *entry;
    int              i;
    int              se_no;

    if (loop_se != NULL) {
        for (i = 0; i < loop_se_num; i++) {
            entry = &loop_se[i];

            if ((int) entry->se_id >= 0) {
                se_no = sndGetSeNo(entry->se_id);
                sndSeStop(entry->se_id, se_no, entry->voice);
                entry->se_id = -1;
                entry->vol = -1.0f;
                entry->pan = 0.0f;
            }
        }
    }
}

int sndGetReverbDepth(int core) {
    if (core < 0 || core > 1) {
        return 0;
    }

    return ReverbDepthe[core];
}

u32 sndCreateID(u32 snd_id, s32 se_no) {
    return (snd_id & 0xFFFF0000) | (se_no & 0xFFFF);
}

int sndGetSeNo(u32 se_id) {
    return se_id & 0xFFFF;
}

/**
 *
 * Returns a sound port entry when the port number is in range.
 *
 */
static sndPortInfo *GetPortInfo(int port) {
    if (port < 0 || port > SND_PORT_NUM) {
        return NULL;
    }

    return &PortInfo[port];
}

/**
 *
 * Returns a sequence player when the sequence number is in range.
 *
 */
static sndCSeSeq *GetSeSeq(int seq_id) {
    if (seq_id < 0 || seq_id >= 32) {
        return NULL;
    }

    return &SeSequencer[seq_id];
}

/**
 *
 * Finds an unused sequence player and writes its slot number.
 *
 */
static sndCSeSeq *GetEmptySeSeq(int *seq_id) {
    for (int index = 0; index < 32; index++) {
        sndCSeSeq *sequencer = &SeSequencer[index];

        if (sequencer->data == NULL) {
            *seq_id = index;
            return sequencer;
        }
    }

    return NULL;
}

/**
 *
 * Extracts the sound port number encoded in a sound identifier.
 *
 */
static u32 GetPortNo(u32 sound_id) {
    return (sound_id >> 24) & 0xFF;
}

/**
 *
 * Extracts the sound bank number encoded in a sound identifier.
 *
 */
static u32 GetBankNo(u32 sound_id) {
    return (sound_id >> 16) & 0xFF;
}

/**
 *
 * Finds the loaded bank identified by a sound ID.
 *
 */
static sndBankInfo *GetBankInfo(unsigned int snd_id) {
    sndPortInfo *info;
    int          port_no;
    int          bank_no;

    port_no = GetPortNo(snd_id);
    bank_no = GetBankNo(snd_id);
    info = GetPortInfo(port_no);

    if (info == NULL) {
        return NULL;
    }

    if (bank_no < 0 || bank_no >= info->bank_num) {
        return NULL;
    }

    return &info->bank[bank_no];
}

/**
 *
 * Finds a sound effect in the bank identified by a sound ID.
 *
 */
static sndSeInfo *GetSeInfo(unsigned int snd_id, int se_no) {
    sndBankInfo *bank;

    bank = GetBankInfo(snd_id);

    if (bank == NULL) {
        return NULL;
    }

    if (se_no < 0 || se_no >= bank->se_num) {
        return NULL;
    }

    return &bank->se[se_no];
}

void sndInitMngr() {
    SemaParam semaphore;
    int       port;

    if (init_snd != 0) {
        CSnd.Exit();
        init_snd = 0;
        DeleteSema(snd_sema_id);
        snd_sema_id = -1;
    }

    semaphore.initCount = 1;
    semaphore.maxCount = 1;
    snd_sema_id = CreateSema(&semaphore);
    CSnd.Init(4, 0, 40, 0);
    sndSetMasterVol(0, 1.0f);
    sndSetMasterVol(1, 1.0f);
    init_snd = 1;

    for (port = 0; port < 16; port++) {
        sndInitPort(port);
        PortVolf[port] = 0.0f;
    }
}

void sndWaitSema() {
    if (snd_sema_id >= 0) {
        WaitSema(snd_sema_id);
    }
}

void sndSignalSema() {
    if (snd_sema_id >= 0) {
        SignalSema(snd_sema_id);
    }
}

void sndInitPort(int port_no) {
    sndPortInfo *info;

    sndSeAllStop(port_no);

    if (port_no == SND_PORT_BGM || port_no == SND_PORT_BGM2) {
        sndStopVoice(0);
    }

    info = GetPortInfo(port_no);

    if (info != NULL) {
        info->port = -1;
        info->sq_port = -1;
        info->bank_num = 0;
        info->sq_no = -1;
        info->sq_state = SND_SQ_STATE_STOP;
        info->sq_vol = 0;
        info->sq_se_no = -1;

        for (int i = 0; i < 16; i++) {
            info->seseq[i].seseq_no = -1;
        }

        for (int i = 0; i < 16; i++) {
            info->bank[i].seseq_num = 0;
            info->bank[i].sq_num = 0;
            info->bank[i].se_num = 0;
            info->bank[i].se = NULL;
            info->bank[i].sq_name = NULL;
            info->bank[i].seseq = NULL;
            info->bank[i].unk_0 = 0;
        }
    }

    sndStopSeSeq(port_no);
}

void sndInitSeSeq(int port_no) {
    sndPortInfo *port_info;
    int          index;

    port_info = GetPortInfo(port_no);

    if (port_info != NULL) {
        for (index = 0; index < 16; index++) {
            port_info->seseq[index].seseq_no = -1;
        }
    }
}

void sndSetReverb(int core, int type, int depth) {
    if (core < 0 || core > 1) {
        return;
    }

    sndWaitSema();
    CSnd.SetReverb(core, type, depth);
    ReverbType[core] = type;
    ReverbDepthe[core] = depth;
    sndSignalSema();
}

void sndStopVoice(int voice) {
    if (voice < 0 || voice > 1) {
        return;
    }

    sndWaitSema();
    CSnd.StopVoice(voice);
    sndSignalSema();
}

/**
 *
 * Clamps and applies the master volume for one sound core.
 *
 */
static void SetMasterVol(int core, float vol) {
    if (core < 0 || core > 1) {
        return;
    }

    if (vol < 0.0f) {
        vol = 0.0f;
    }

    if (vol > 1.0f) {
        vol = 1.0f;
    }

    sndWaitSema();
    CSnd.SetMasterVol(core, (int) (16383.0f * vol));
    sndSignalSema();
}

/**
 *
 * Advances active master-volume fades toward their target values.
 *
 */
static void FadeMasterVol() {
    int core;

    for (core = 0; core < 2; core++) {
        if (MasterVolFade[core] != 0) {
            fnowMasterVol[core] += fstpMasterVol[core];

            if (fstpMasterVol[core] > 0.0f) {
                if (fnowMasterVol[core] > feMasterVol[core]) {
                    fnowMasterVol[core] = feMasterVol[core];
                    MasterVolFade[core] = 0;
                }
            } else if (fnowMasterVol[core] < feMasterVol[core]) {
                fnowMasterVol[core] = feMasterVol[core];
                MasterVolFade[core] = 0;
            }

            SetMasterVol(core, fnowMasterVol[core]);
        }
    }
}

void sndSetMasterVol(int core, float vol) {
    if (core < 0 || core > 1) {
        return;
    }

    if (vol < 0.0f) {
        vol = 0.0f;
    }

    if (vol > 1.0f) {
        vol = 1.0f;
    }

    MasterVol[core] = vol;
    SetMasterVol(core, vol);
    MasterVolFade[core] = 0;
}

float sndGetMasterVol(int core) {
    if (core < 0 || core > 1) {
        return 0.0f;
    }

    return MasterVol[core];
}

void sndMasterVolFadeInOut(int core, int frames, float target, float start) {
    float change;

    if (frames <= 1 || core < 0 || core > 1) {
        return;
    }

    if (target < 0.0f) {
        target = 0.0f;
    }

    if (target > 1.0f) {
        target = 1.0f;
    }

    if (start > 1.0f) {
        start = 1.0f;
    }

    if (start >= 0.0f) {
        fnowMasterVol[core] = start;
    } else {
        fnowMasterVol[core] = MasterVol[core];
    }

    feMasterVol[core] = target;
    change = target - fnowMasterVol[core];
    fstpMasterVol[core] = change;

    if (change < 0.0f) {
        change = -change;
    }

    if (change >= 0.01f) {
        fstpMasterVol[core] /= frames;
        MasterVolFade[core] = 1;
        MasterVol[core] = target;
    }
}

void sndSetPortVol(int port_no, float vol) {
    sndPortInfo *info;
    int          driver_vol;

    info = GetPortInfo(port_no);

    if (info == NULL || info->port < 0 || info->port >= 16) {
        return;
    }

    if (vol < 0.0f) {
        vol = 0.0f;
    }

    if (vol > 1.0f) {
        vol = 1.0f;
    }

    PortVolf[port_no] = vol;
    driver_vol = (int) (127.0f * vol);

    if (vol == 1.0f) {
        driver_vol = 0x100;
    }

    sndWaitSema();
    CSnd.SetVol(info->port, driver_vol);
    sndSignalSema();
}

float sndGetPortVol(int port) {
    if (port < 0 || port >= SND_PORT_NUM) {
        return 0.0f;
    }

    return PortVolf[port];
}

int sndTransBdState() {
    return CSnd.TransBdState(1);
}

void sndWaitTransBd() {
    int previous_frame = -1;

    while (1) {
        int frame = mgGetVSyncCount();

        if (frame != previous_frame && sndTransBdState()) {
            return;
        }

        previous_frame = frame;
    }
}

/**
 *
 * Steps the sound driver at most once per vertical sync interval.
 *
 */
static int CSndStep() {
    int frame = mgGetVSyncCount();
    int stepped;

    if (frame != snd_old_vsync) {
        CSnd.Step();
        snd_old_vsync = frame;
        stepped = 1;
    } else {
        stepped = 0;
    }

    return stepped;
}

/**
 *
 * Delays briefly before stepping the sound driver.
 *
 */
static void CSndStepWait() {
    int delay;

    for (delay = 0; delay < 10000; delay++) {
    }

    CSnd.Step();
}

void sndStep(float frames) {
    int           port_no;
    sndPortInfo  *info;
    sndCSeSeq    *player;
    sndPortSeSeq *entry;
    int           i;

    for (port_no = 0; port_no < 16; port_no++) {
        info = GetPortInfo(port_no);

        if (info != NULL) {
            for (i = 0; i < 16; i++) {
                entry = &info->seseq[i];

                if (entry->seseq_no >= 0) {
                    player = GetSeSeq(entry->seseq_no);

                    if (player != NULL && player->Step(frames) != 0) {
                        entry->seseq_no = -1;
                    }
                }
            }
        }
    }

    FadeMasterVol();
    sndFlush();
}

void sndFlush() {
    sndWaitSema();
    CSndStep();
    sndSignalSema();
}

/**
 *
 * Stops playback on the selected sound port.
 *
 */
static void SeAllStop_Sub(int port_no) {
    sndPortInfo *info;

    if (port_no >= 0) {
        info = GetPortInfo(port_no);

        if (info != NULL) {
            if (info->port >= 0) {
                CSnd.Stop(info->port);
            }

            if (info->sq_port >= 0 && info->port != info->sq_port) {
                CSnd.Stop(info->sq_port);
            }
        }
    }
}

void sndSeAllStop(int port_no) {
    int port;

    if (port_no < 0) {
        for (port = 0; port <= 11; port++) {
            if (port != SND_PORT_BGM && port != SND_PORT_BGM2) {
                sndStopSeSeq(port_no);
                sndInitSeSeq(port_no);
                sndWaitSema();
                SeAllStop_Sub(port);
                sndSignalSema();
            }
        }

        sndWaitSema();
        CSndStepWait();
        sndSignalSema();
        return;
    }

    sndStopSeSeq(port_no);
    sndInitSeSeq(port_no);
    sndWaitSema();
    SeAllStop_Sub(port_no);
    CSndStep();
    sndSignalSema();
}

int sndGetSeDefVol(u32 se_id, int index) {
    sndSeInfo *info;

    info = GetSeInfo(se_id, index);

    if (info != NULL) {
        return info->def_vol;
    }

    return 0;
}

/**
 *
 * Identifies the driver's voice-capable music ports.
 *
 */
static int IsBgmPort(int port) {
    if (port == 0 || port == 11) {
        return 1;
    }

    return 0;
}

/**
 *
 * Maps a game sound port to driver ports and its initial volume.
 *
 */
static int GetCSndPortNo(int port_no, int *port, int *sq_port, int *vol) {
    *vol = -1;

    switch (port_no) {
        case SND_PORT_BGM:
            *port = 0;
            *sq_port = 0;
            break;
        case SND_PORT_OB:
            *port = 15;
            *sq_port = -1;
            *vol = 0x100;
            break;
        case 2:
            *port = 1;
            *sq_port = 1;
            break;
        case SND_PORT_BASE:
            *port = 10;
            *sq_port = -1;
            *vol = 0x100;
            break;
        case SND_PORT_EVENT:
            *port = 14;
            *sq_port = 2;
            *vol = 0x100;
            break;
        case SND_PORT_ENEMY:
            *port = 13;
            *sq_port = -1;
            *vol = 0x100;
            break;
        case SND_PORT_SYSTEM:
            *port = 12;
            *sq_port = -1;
            *vol = 0x100;
            break;
        case 7:
            *port = 9;
            *sq_port = -1;
            *vol = 0x100;
            break;
        case SND_PORT_MENU:
            *port = 11;
            *sq_port = -1;
            *vol = 0x100;
            break;
        case SND_PORT_BGM2:
            *port = 3;
            *sq_port = 3;
            break;
        case 9:
            *port = 8;
            *sq_port = -1;
            *vol = 0x100;
            break;
        case 10:
            *port = 7;
            *sq_port = -1;
            *vol = 0x100;
            break;
        default:
            return 0;
    }

    return 1;
}

unsigned int sndLoadSound(int port_no, unsigned int *pack, mgCMemory *memory) {
    sndPortInfo  *info;
    sndBankInfo  *bank;
    unsigned int *sq[32];
    int           sq_size[32];
    char         *sq_name[32];
    unsigned int *mid[48];
    int           mid_size[48];
    char         *mid_name[48];
    int           initial_vol;
    unsigned int *config;
    int           config_size;
    unsigned int *volume;
    int           volume_size;
    unsigned int *bd;
    unsigned int *hd;
    int           bd_size;
    int           hd_size;
    int           bank_no;
    unsigned int  size;
    unsigned int  quadwords;
    int           i;
    unsigned int  sound_id;

    if (EnableSndMngr == 0) {
        return -1;
    }
    info = GetPortInfo(port_no);
    if (info == NULL) {
        return -1;
    }
    initial_vol = -1;
    if (GetCSndPortNo(port_no, &info->port, &info->sq_port, &initial_vol) == 0) {
        return -1;
    }
    sound_id = (port_no & 0xFF) << 24;
    if (GetPackFileExt(pack, "cfg", &config, 1, &config_size, NULL) <= 0) {
        return -1;
    }
    if (GetPackFileExt(pack, "vol", &volume, 1, &volume_size, NULL) <= 0) {
        return -1;
    }
    bank_no = info->bank_num;
    if (GetPackFileExt(pack, "bd", &bd, 1, &bd_size, NULL) <= 0) {
        bd_size = 0;
    }
    if (GetPackFileExt(pack, "hd", &hd, 1, &hd_size, NULL) <= 0) {
        hd_size = 0;
    }
    sndWaitSema();
    CSndStepWait();
    if (info->bank_num == 0) {
        if (bd_size != 0 && hd_size != 0) {
            CSnd.LoadHdBd(info->port, (int) hd, hd_size, (int) bd, bd_size);
        }
        sndWaitTransBd();
        info->bank_num++;
    } else {
        if (info->bank_num > 15) {
            sndSignalSema();
            return -1;
        }
        if (bd_size != 0 && hd_size != 0) {
            CSnd.LoadHdBdAdd(info->port, (int) hd, hd_size, (int) bd, bd_size);
        }
        sndWaitTransBd();
        info->bank_num++;
    }
    sound_id |= (bank_no & 0xFF) << 16;
    bank = info->GetBank(bank_no);
    if (bank == NULL) {
        sndSignalSema();
        return -1;
    }
    if (port_no == SND_PORT_BGM || port_no == SND_PORT_BGM2 || port_no == 2 || port_no == SND_PORT_EVENT) {
        bank->sq_num = GetPackFileExt(pack, "sq", sq, 32, sq_size, sq_name);
        size = bank->sq_num * sizeof(char *);
        if (size & 0xF) {
            quadwords = (size >> 4) + 1;
        } else {
            quadwords = size >> 4;
        }
        bank->sq_name = new (memory->Alloc(quadwords + 2)) char *[bank->sq_num];
        for (i = 0; i < bank->sq_num; i++) {
            bank->sq_name[i] = NULL;
            CSnd.LoadSeq(info->sq_port, (int) sq[i], sq_size[i]);
            bank->sq_name[i] = mgCopyString(sq_name[i], memory);
        }
    }
    bank->seseq_num = GetPackFileExt(pack, "mid", mid, 48, mid_size, mid_name);
    if (bank->seseq_num > 0) {
        size = bank->seseq_num * sizeof(sndCSeSeqData);
        if (size & 0xF) {
            quadwords = (size >> 4) + 1;
        } else {
            quadwords = size >> 4;
        }
        bank->seseq = new (memory->Alloc(quadwords + 2)) sndCSeSeqData[bank->seseq_num];
    }
    for (i = 0; i < bank->seseq_num; i++) {
        bank->seseq[i].name = mgCopyString(mid_name[i], memory);
        bank->seseq[i].LoadSMF((char *) mid[i], mid_size[i], memory);
    }
    if (initial_vol >= 0) {
        CSnd.SetVol(info->port, initial_vol);
        if (port_no >= 0 && port_no <= 16) {
            PortVolf[port_no] = 1.0f;
        }
    }
    info->LoadSeInfoTxt(bank_no, (char *) config, config_size, memory);
    info->LoadVolInfoTxt(bank_no, (char *) volume, volume_size);
    sndSignalSema();
    return sound_id;
}

sndCSeSeqData::sndCSeSeqData() {
    Initialize();
}

void sndDeletePort(int port_no) {
    int volume;
    int driver_port;
    int sequence_port;

    volume = -1;

    if (GetCSndPortNo(port_no, &driver_port, &sequence_port, &volume) != 0) {
        sndWaitSema();

        if (driver_port >= 0) {
            CSnd.DEL_PORT(driver_port);
        }

        if (sequence_port >= 0 && sequence_port != driver_port) {
            CSnd.DEL_PORT(sequence_port);
        }

        sndSignalSema();
    }

    sndInitPort(port_no);
}

/**
 *
 * Resolves a sound identifier to its loaded driver port and bank.
 *
 */
static int GetPortBankNo(unsigned int snd_id, int *port, int *bank) {
    sndPortInfo *info;
    sndBankInfo *bank_info;
    int          port_no;
    int          bank_no;

    port_no = GetPortNo(snd_id);
    bank_no = GetBankNo(snd_id);
    info = GetPortInfo(port_no);

    if (info == NULL) {
        return 0;
    }

    bank_info = info->GetBank(bank_no);

    if (bank_info == NULL) {
        return 0;
    }

    *port = info->port;
    *bank = bank_no;
    return 1;
}

void sndSePlay(u32 snd_id, s32 se_no, s32 voice) {
    sndSePlaySeID(snd_id, se_no, -1, -1, 0x40, 0x2000, voice);
}

void sndSePlayV(u32 snd_id, s32 se_no, s32 vol, s32 voice) {
    sndSePlaySeID(snd_id, se_no, -1, vol, 0x40, 0x2000, voice);
}

void sndSePlayVP(u32 snd_id, s32 se_no, s32 vol, s32 pan, s32 voice) {
    sndSePlaySeID(snd_id, se_no, -1, vol, pan, 0x2000, voice);
}

void sndSePlayVPf(unsigned int snd_id, int se_no, float vol, float pan, int voice) {
    int volume;
    int driver_pan;

    volume = (int) (vol * sndGetSeDefVol(snd_id, se_no));

    if (volume > 127) {
        volume = 127;
    }

    driver_pan = (int) (64.0f * pan) + 64;

    if (driver_pan < 0) {
        driver_pan = 0;
    }

    if (driver_pan > 127) {
        driver_pan = 127;
    }

    sndSePlaySeID(snd_id, se_no, -1, volume, driver_pan, SND_SE_PITCH_CENTER, voice);
}

void sndSePlayVf(unsigned int snd_id, int se_no, float vol, int voice) {
    int volume;

    volume = (int) (vol * sndGetSeDefVol(snd_id, se_no));

    if (volume > 127) {
        volume = 127;
    }

    sndSePlayV(snd_id, se_no, volume, voice);
}

void sndSePause(unsigned int snd_id, int se_no) {
    sndPortInfo *info;
    sndBankInfo *bank;
    sndSeInfo   *se;
    int          port_no;
    int          bank_no;

    if (snd_id == (unsigned int) -1) {
        return;
    }

    port_no = GetPortNo(snd_id);
    bank_no = GetBankNo(snd_id);
    info = GetPortInfo(port_no);

    if (info == NULL) {
        return;
    }

    bank = info->GetBank(bank_no);

    if (bank == NULL) {
        return;
    }

    se = bank->GetSe(se_no);

    if (se != NULL && se->type == SND_SE_TYPE_SQ && info->sq_state == SND_SQ_STATE_PLAY) {
        sndSqStop(info->sq_port, se->prog);
        info->sq_state = SND_SQ_STATE_PAUSE;
    }
}

int sndGetSeStatus(unsigned int snd_id, int se_no) {
    sndPortInfo *info;
    sndBankInfo *bank;
    sndSeInfo   *se;
    int          port_no;
    int          bank_no;

    if (snd_id == (unsigned int) -1) {
        return -1;
    }

    port_no = GetPortNo(snd_id);
    bank_no = GetBankNo(snd_id);
    info = GetPortInfo(port_no);

    if (info == NULL) {
        return -1;
    }

    bank = info->GetBank(bank_no);

    if (bank == NULL) {
        return -1;
    }

    se = bank->GetSe(se_no);

    if (se == NULL) {
        return -1;
    }

    if (se->type != SND_SE_TYPE_SQ) {
        return -1;
    }

    return info->sq_state;
}

void sndPortSqPause(int port) {
    sndPortInfo *info;

    info = GetPortInfo(port);

    if ((info != NULL) && (info->sq_state == 1)) {
        sndSqStop(info->sq_port, info->sq_no);
        info->sq_state = 3;
    }
}

void sndPortSqReplay(int port) {
    sndPortInfo *info;

    info = GetPortInfo(port);

    if ((info != NULL) && (info->sq_state == 3)) {
        sndSqRePlay(info->sq_port, info->sq_no);
        sndSetSqVol(info->sq_port, info->sq_no, info->sq_vol);
        info->sq_state = 1;
    }
}

int sndSeCheck(unsigned int snd_id, int se_no) {
    sndPortInfo *info;
    sndBankInfo *bank;
    sndSeInfo   *se;
    int          port_no;
    int          bank_no;

    if (snd_id == (unsigned int) -1) {
        return 0;
    }

    port_no = GetPortNo(snd_id);
    bank_no = GetBankNo(snd_id);
    info = GetPortInfo(port_no);

    if (info == NULL) {
        return 0;
    }

    bank = info->GetBank(bank_no);

    if (bank == NULL) {
        return 0;
    }

    se = bank->GetSe(se_no);

    if (se == NULL) {
        return 0;
    }

    return 1;
}

void sndSePlaySeID(unsigned int snd_id, int se_no, int velocity, int vol, int pan, int pitch, int voice) {
    int            port_no;
    int            bank_no;
    sndPortInfo   *info;
    sndBankInfo   *bank;
    sndSeInfo     *se;
    sndPortSeSeq  *entry;
    sndCSeSeqData *data;

    if (snd_id == (unsigned int) -1) {
        return;
    }

    port_no = GetPortNo(snd_id);
    bank_no = GetBankNo(snd_id);
    info = GetPortInfo(port_no);

    if (info == NULL) {
        return;
    }

    bank = info->GetBank(bank_no);

    if (bank == NULL) {
        return;
    }

    se = bank->GetSe(se_no);

    if (se == NULL) {
        return;
    }

    if (vol < 0) {
        vol = se->def_vol;
    }

    if (se->type == SND_SE_TYPE_NONE) {
        return;
    }

    if (se->type == SND_SE_TYPE_SQ && info->sq_state != SND_SQ_STATE_PLAY) {
        if (info->sq_state == SND_SQ_STATE_PAUSE || info->sq_state == SND_SQ_STATE_PORT_PAUSE) {
            sndSqRePlay(info->sq_port, se->prog);
            sndSetSqVol(info->sq_port, se->prog, info->sq_vol);
        } else {
            sndSqPlay(info->sq_port, se->prog, vol);
        }

        info->sq_vol = vol;
        info->sq_state = SND_SQ_STATE_PLAY;
        info->sq_no = se->prog;
        info->sq_se_no = se_no;
    }

    if (se->type == SND_SE_TYPE_KEYON) {
        sndSePlayPrKr(snd_id, se->prog, se->key, velocity, vol, pan, pitch, voice);
    }

    if (se->type == SND_SE_TYPE_SESEQ) {
        entry = info->GetFreeSeSeq();
        data = bank->GetSeSeqData(se->prog);

        if (entry != NULL && data != NULL) {
            entry->seseq_no = PlaySeSeq(snd_id, data, vol);

            if (entry->seseq_no >= 0) {
                entry->bank = bank_no;
                entry->se_no = se_no;
                entry->voice = voice;
                entry->unk_6 = 1;
            }
        }
    }
}

void sndSeStop(unsigned int snd_id, int se_no, int voice) {
    int           port_no;
    int           bank_no;
    sndPortInfo  *info;
    sndBankInfo  *bank;
    sndSeInfo    *se;
    sndPortSeSeq *entry;

    if (snd_id == (unsigned int) -1) {
        return;
    }

    port_no = GetPortNo(snd_id);
    bank_no = GetBankNo(snd_id);
    info = GetPortInfo(port_no);

    if (info == NULL) {
        return;
    }

    bank = info->GetBank(bank_no);

    if (bank == NULL) {
        return;
    }

    se = bank->GetSe(se_no);

    if (se == NULL) {
        return;
    }

    if (se->type == SND_SE_TYPE_NONE) {
        return;
    }

    if (se->type == SND_SE_TYPE_SQ && info->sq_state != SND_SQ_STATE_STOP) {
        sndSqStop(info->sq_port, se->prog);
        info->sq_state = SND_SQ_STATE_STOP;
    }

    if (se->type == SND_SE_TYPE_KEYON) {
        sndSeStopPrKr(snd_id, se->prog, se->key, voice);
    }

    if (se->type == SND_SE_TYPE_SESEQ) {
        entry = info->SearchSeSeq(bank_no, se_no, voice);

        if (entry != NULL) {
            StopSeSeq(entry->seseq_no);
        }
    }
}

void sndSetSeVol(unsigned int snd_id, int se_no, int vol, int voice) {
    int           port_no;
    int           bank_no;
    sndPortInfo  *info;
    sndBankInfo  *bank;
    sndSeInfo    *se;
    sndPortSeSeq *entry;

    if (snd_id == (unsigned int) -1) {
        return;
    }

    port_no = GetPortNo(snd_id);
    bank_no = GetBankNo(snd_id);
    info = GetPortInfo(port_no);

    if (info == NULL) {
        return;
    }

    bank = info->GetBank(bank_no);

    if (bank == NULL) {
        return;
    }

    se = bank->GetSe(se_no);

    if (se == NULL) {
        return;
    }

    if (vol < 0) {
        vol = se->def_vol;
    }

    if (se->type == SND_SE_TYPE_NONE) {
        return;
    }

    if (se->type == SND_SE_TYPE_SQ && info->sq_vol != vol && vol >= 0 && vol < 128 && info->sq_state != SND_SQ_STATE_STOP) {
        info->sq_vol = vol;
        sndSetSqVol(info->sq_port, se->prog, vol);
    }

    if (se->type == SND_SE_TYPE_KEYON) {
        sndSetSeVolPrKr(snd_id, se->prog, se->key, vol, voice);
    }

    if (se->type == SND_SE_TYPE_SESEQ) {
        entry = info->SearchSeSeq(bank_no, se_no, voice);

        if (entry != NULL) {
            SetVolSeSeq(entry->seseq_no, vol);
        }
    }
}

void sndSetSePan(unsigned int snd_id, int se_no, int pan, int voice) {
    sndPortInfo *info;
    sndBankInfo *bank;
    sndSeInfo   *se;
    int          port_no;
    int          bank_no;

    if (snd_id == (unsigned int) -1) {
        return;
    }

    port_no = GetPortNo(snd_id);
    bank_no = GetBankNo(snd_id);
    info = GetPortInfo(port_no);

    if (info == NULL) {
        return;
    }

    bank = info->GetBank(bank_no);

    if (bank == NULL) {
        return;
    }

    se = bank->GetSe(se_no);

    if (se == NULL) {
        return;
    }

    if (se->type == SND_SE_TYPE_NONE) {
        return;
    }

    if (se->type == SND_SE_TYPE_KEYON) {
        sndSetSePanPrKr(snd_id, se->prog, se->key, pan, voice);
    }
}

void sndSetSeVolf(unsigned int snd_id, int se_no, float vol, int voice) {
    int volume;

    volume = (int) (vol * sndGetSeDefVol(snd_id, se_no));

    if (volume > 127) {
        volume = 127;
    }

    sndSetSeVol(snd_id, se_no, volume, voice);
}

void sndSetSePanf(unsigned int snd_id, int se_no, float pan, int voice) {
    int driver_pan;

    driver_pan = (int)(64.0f * pan) + 64;
    if (driver_pan < 0) {
        driver_pan = 0;
    }
    if (driver_pan > 127) {
        driver_pan = 127;
    }
    sndSetSePan(snd_id, se_no, driver_pan, voice);
}

void sndSetSePitch(unsigned int snd_id, int se_no, int pitch, int voice) {
    sndPortInfo *info;
    sndBankInfo *bank;
    sndSeInfo   *se;
    int          port_no;
    int          bank_no;

    if (snd_id == (unsigned int) -1) {
        return;
    }

    port_no = GetPortNo(snd_id);
    bank_no = GetBankNo(snd_id);
    info = GetPortInfo(port_no);

    if (info == NULL) {
        return;
    }

    bank = info->GetBank(bank_no);

    if (bank == NULL) {
        return;
    }

    se = bank->GetSe(se_no);

    if (se == NULL) {
        return;
    }

    if (se->type == SND_SE_TYPE_NONE) {
        return;
    }

    if (se->type == SND_SE_TYPE_KEYON) {
        sndSetSePitchPrKr(snd_id, se->prog, se->key, pitch, voice);
    }
}

void sndSetMicPos(float *position, float *direction) {
    *(u_long128 *) MicPos = *(u_long128 *) position;
    *(u_long128 *) MicDir = *(u_long128 *) direction;
}

void sndGetVolPan(float *vol, float *pan, float *pos, float near_dist, float far_dist) {
    sceVu0FVECTOR direction;
    sceVu0FVECTOR side;
    float         distance;
    float         volume;
    float         projection;
    float         panning;
    float         boost;
    int           sign;

    distance = mgDistVector(pos, MicPos);
    volume = 1.0f - (distance - near_dist) / (far_dist - near_dist);

    if (distance > far_dist) {
        volume = 0.0f;
    }

    if (distance < near_dist) {
        volume = 1.0f;
    }

    *vol = volume;
    *pan = 0.0f;
    sceVu0CopyVector(direction, MicDir);
    direction[1] = 0.0f;
    sceVu0Normalize(direction, direction);
    side[1] = 0.0f;
    side[0] = direction[2];
    side[2] = -direction[0];
    sceVu0SubVector(direction, pos, MicPos);
    direction[1] = 0.0f;
    sceVu0Normalize(direction, direction);
    projection = -sceVu0InnerProduct(direction, side);
    sign = 1;

    if (projection < 0.0f) {
        sign = -1;
    }

    if (projection < 0.0f) {
        projection = -projection;
    }

    projection *= projection;
    projection *= projection;
    panning = 0.7f * (sign * projection);
    *pan = panning;

    if (panning < 0.0f) {
        panning = -panning;
    }

    boost = 0.4f * panning;
    *vol *= 1.0f + boost;
}

void sndGetVolPan(float *vol, float *pan, float *start, float *end, float near_dist, float far_dist) {
    sceVu0FVECTOR nearest;

    mgDistLinePoint(MicPos, start, end, nearest);
    sndGetVolPan(vol, pan, nearest, near_dist, far_dist);
}

int sndVolLimit(int vol) {
    if (vol < 0) {
        return 0;
    }

    return vol > 127 ? 127 : vol;
}

void sndSePlayPrKr(unsigned int snd_id, int prog, int key, int velocity, int vol, int pan, int pitch, int voice) {
    int port;
    int bank;

    if (snd_id != (unsigned int) -1 && GetPortBankNo(snd_id, &port, &bank) != 0) {
        sndSePlayPBPrKr(port, bank, prog, key, velocity, vol, pan, pitch, voice);
    }
}

void sndSeStopPrKr(unsigned int snd_id, int prog, int key, int voice) {
    int port;
    int bank;

    if (snd_id != (unsigned int) -1 && GetPortBankNo(snd_id, &port, &bank) != 0) {
        sndSeStopPBPrKr(port, bank, prog, key, voice);
    }
}

void sndSetSeVolPrKr(unsigned int snd_id, int prog, int key, int vol, int voice) {
    int port;
    int bank;

    if (snd_id != (unsigned int) -1 && GetPortBankNo(snd_id, &port, &bank) != 0) {
        sndSetSeVolPBPrKr(port, bank, prog, key, vol, voice);
    }
}

void sndSetSePanPrKr(unsigned int snd_id, int prog, int key, int pan, int voice) {
    int port;
    int bank;

    if (snd_id != (unsigned int) -1 && GetPortBankNo(snd_id, &port, &bank) != 0) {
        sndSetSePanPBPrKr(port, bank, prog, key, pan, voice);
    }
}

void sndSetSePitchPrKr(unsigned int snd_id, int prog, int key, int pitch, int voice) {
    int port;
    int bank;

    if (snd_id != (unsigned int) -1 && GetPortBankNo(snd_id, &port, &bank) != 0) {
        sndSetSePitchPBPrKr(port, bank, prog, key, pitch, voice);
    }
}

void sndSePlayPBPrKr(int port, int bank, int prog, int key, int velocity, int vol, int pan, int pitch, int voice) {
    if (vol < 0) {
        vol = 127;
    }

    if (velocity < 0) {
        velocity = 127;
    }

    sndWaitSema();
    CSnd.SE_Play(port, bank, prog, key, pan, velocity, vol, pitch, voice);
    sndSignalSema();
}

void sndSeStopPBPrKr(int a, int b, int c, int d, int e) {
    sndWaitSema();
    CSnd.SE_Stop(a, b, c, d, e);
    sndSignalSema();
}

void sndSetSeVolPBPrKr(int port, int bank, int prog, int key, int vol, int voice) {
    if (vol < 0) {
        vol = 127;
    }

    sndWaitSema();
    CSnd.SE_SetVol(port, bank, prog, key, vol, voice);
    sndSignalSema();
}

void sndSetSePanPBPrKr(int a, int b, int c, int d, int e, int f) {
    sndWaitSema();
    CSnd.SE_SetPan(a, b, c, d, e, f);
    sndSignalSema();
}

void sndSetSePitchPBPrKr(int a, int b, int c, int d, int e, int f) {
    sndWaitSema();
    CSnd.SE_SetPitch(a, b, c, d, e, f);
    sndSignalSema();
}

void sndSqPlay(int a, int b, int c) {
    sndWaitSema();
    CSnd.SQ_Play(a, b, c);
    sndSignalSema();
}

void sndSqStop(int port, int sq_no) {
    sndWaitSema();
    CSnd.SetVol(port, 0);

    if (IsBgmPort(port)) {
        CSnd.StopVoice(0);
    }

    CSnd.Stop(port);

    if (IsBgmPort(port)) {
        CSnd.StopVoice(0);
    }

    CSndStep();
    sndSignalSema();
}

void sndSetSqVol(int port, int sq_no, int vol) {
    sndWaitSema();
    CSnd.SetVol(port, vol);
    sndSignalSema();
}

void sndSqRePlay(int port, int sq_no) {
    sndWaitSema();
    CSnd.SQ_RePlay(port);
    sndSignalSema();
}

/**
 *
 * Reads a line of tab or space separated columns into text buffers.
 *
 */
static char *GetLine(char **col, char *text, char *end) {
    char crlf[] = {'\r', '\n'};
    int  column;
    int  length;
    char character;

    column = 0;

    while (text < end) {
        if (memcmp(text, crlf, 2) == 0) {
            text += 2;
            break;
        }

        if (memcmp(text, crlf, 1) == 0) {
            text++;
            break;
        }

        if (memcmp(text, &crlf[1], 1) == 0) {
            text++;
            break;
        }

        length = 0;

        while (text < end) {
            if (memcmp(text, crlf, 2) == 0 || memcmp(text, crlf, 1) == 0 || memcmp(text, &crlf[1], 1) == 0) {
                break;
            }

            character = *text;

            if (character == '\t' || (character == ' ' && text[1] != ' ')) {
                text++;

                if (col[column + 1] != NULL) {
                    col[column + 1][0] = '\0';
                }

                break;
            }

            if (character != ' ' && col[column] != NULL) {
                col[column][length] = character;
                length++;
            }

            text++;
        }

        if (col[column] != NULL) {
            col[column][length] = '\0';
            column++;
        }
    }

    return text;
}

int sndBankInfo::SearchSeq(char *name, int *index) {
    int i;

    if (name == NULL || *name == '\0') {
        return SND_SE_TYPE_NONE;
    }

    if (strcmp(name, "KeyOn") == 0) {
        return SND_SE_TYPE_KEYON;
    }

    for (i = 0; i < sq_num; i++) {
        if (strcasecmp(sq_name[i], name) == 0) {
            *index = i;
            return SND_SE_TYPE_SQ;
        }
    }

    for (i = 0; i < seseq_num; i++) {
        if (strcasecmp(seseq[i].name, name) == 0) {
            *index = i;
            return SND_SE_TYPE_SESEQ;
        }
    }

    for (i = 0; name[i] != '\0'; i++) {
        long ch = name[i];

        if (ch == '.') {
            return SND_SE_TYPE_NONE;
        }
    }

    return SND_SE_TYPE_KEYON;
}

void sndPortInfo::LoadSeInfoTxt(int bank_no, char *text, int size, mgCMemory *memory) {
    sndBankInfo *bank_info;
    sndSeInfo   *entry;
    char        *end;
    char        *begin;
    char         name[64];
    char         description[64];
    char         filename[64];
    char         number[8];
    char         category[8];
    char         program[8];
    char         key[8];
    char         flag[8];
    unsigned int bytes;
    unsigned int quadwords;
    int          se_count;
    int          count;
    int          index;
    int          reverb_type;
    int          depth;
    int          core;

    bank_info = GetBank(bank_no);
    if (bank_info == NULL) {
        return;
    }
    end = text + size;
    char        *col[9] = { number, name, description, category, filename, program, key, flag, NULL };
    begin = text;
    bank_info->se_num = 0;
    while (text < end) {
        text = GetLine(col, text, end);
        if (strcmp(col[0], "END") == 0) {
            break;
        }
        bank_info->se_num++;
    }
    se_count = bank_info->se_num;
    bytes = se_count * sizeof(sndSeInfo);
    if (bytes & 0xF) {
        quadwords = (bytes >> 4) + 1;
    } else {
        quadwords = bytes >> 4;
    }
    bank_info->se = new (memory->Alloc(quadwords + 2)) sndSeInfo[se_count];
    text = begin;
    count = 0;
    while (text < end) {
        if (!(count < bank_info->se_num)) {
            break;
        }
        text = GetLine(col, text, end);
        if (strcmp(col[0], "END") == 0) {
            break;
        }
        if (strcmp(col[0], "REVERBE") == 0) {
            reverb_type = SND_REVERB_OFF;
            if (strcmp(col[1], "Room") == 0) {
                reverb_type = SND_REVERB_ROOM;
            }
            if (strcmp(col[1], "Studio_A") == 0) {
                reverb_type = SND_REVERB_STUDIO_A;
            }
            if (strcmp(col[1], "Studio_B") == 0) {
                reverb_type = SND_REVERB_STUDIO_B;
            }
            if (strcmp(col[1], "Studio_C") == 0) {
                reverb_type = SND_REVERB_STUDIO_C;
            }
            if (strcmp(col[1], "Hall") == 0) {
                reverb_type = SND_REVERB_HALL;
            }
            if (strcmp(col[1], "Space") == 0) {
                reverb_type = SND_REVERB_SPACE;
            }
            if (strcmp(col[1], "Echo") == 0) {
                reverb_type = SND_REVERB_ECHO;
            }
            if (strcmp(col[1], "Delay") == 0) {
                reverb_type = SND_REVERB_DELAY;
            }
            if (strcmp(col[1], "Pipe") == 0) {
                reverb_type = SND_REVERB_PIPE;
            }
            if (strcmp(col[1], "Max") == 0) {
                reverb_type = SND_REVERB_MAX;
            }
            depth = atoi(col[2]);
            core = -1;
            if (port == 0) {
                core = 0;
            }
            if (port == 7) {
                core = 1;
            }
            if (core >= 0) {
                CSnd.SetReverb(core, reverb_type, depth);
            }
        } else if (col[0][0] >= '0' && col[0][0] <= '9') {
            entry = &bank_info->se[count];
            count++;
            memset(entry, 0, sizeof(sndSeInfo));
            entry->type = bank_info->SearchSeq(filename, &index);
            entry->prog = atoi(program);
            if (entry->type == SND_SE_TYPE_SQ) {
                entry->prog = index;
            }
            if (entry->type == SND_SE_TYPE_SESEQ) {
                entry->prog = index;
            }
            entry->key = atoi(key);
            entry->unk_7 = flag[0] != '\0';
            entry->def_vol = 64;
        }
    }
}

sndSeInfo::sndSeInfo() {
    this->unk_0 = 0;
    this->type = 0;
}

void sndPortInfo::LoadVolInfoTxt(int bank_no, char *text, int size) {
    sndBankInfo *bank_info;
    sndSeInfo   *entry;
    char        *end;
    char         volume[64];
    char         depth_text[64];
    char         number[8];
    int          se_no;
    int          type;
    int          depth;
    int          core;

    bank_info = GetBank(bank_no);

    if (bank_info == NULL) {
        return;
    }

    char *col[4] = {number, volume, depth_text, NULL};
    end = text + size;

    while (text < end) {
        text = GetLine(col, text, end);

        if (strcmp(col[0], "END") == 0) {
            break;
        }

        if (strcmp(col[0], "REVERB") == 0) {
            type = atoi(col[1]);
            depth = atoi(col[2]);
            core = -1;

            if (port == 0) {
                core = 0;
            }

            if (port == 7) {
                core = 1;
            }

            if (core >= 0) {
                CSnd.SetReverb(core, type, depth);
                ReverbType[core] = type;
                ReverbDepthe[core] = depth;
                printf("REVERB %d %d\n", type, depth);
            }
        } else {
            se_no = atoi(number);
            entry = bank_info->GetSe(se_no);

            if (entry != NULL) {
                entry->def_vol = atoi(volume);
            }
        }
    }
}

void sndStopSeSeq(int port_no) {
    sndPortInfo *info;
    sndCSeSeq   *player;
    int          port;
    int          player_index;

    info = GetPortInfo(port_no);

    if (info != NULL) {
        port = info->port;

        for (player_index = 0; player_index < 32; player_index++) {
            player = &SeSequencer[player_index];

            if (player->data != NULL && port == player->port) {
                player->Stop();
            }
        }
    }
}

/**
 *
 * Starts a sound-effect sequence on a free player.
 *
 */
static int PlaySeSeq(unsigned int snd_id, sndCSeSeqData *data, int vol) {
    sndCSeSeq   *player;
    sndPortInfo *info;
    int          index;
    int          port_no;
    int          bank_no;

    player = GetEmptySeSeq(&index);

    if (player == NULL || data == NULL) {
        return -1;
    }

    player->Initialize();
    player->SetSeID((index * 8) % 256);

    if (snd_id == (unsigned int) -1) {
        return -1;
    }

    port_no = GetPortNo(snd_id);
    bank_no = GetBankNo(snd_id);
    info = GetPortInfo(port_no);

    if (info == NULL) {
        return -1;
    }

    if (vol < 0) {
        vol = 127;
    }

    player->data = data;
    player->port = info->port;
    player->bank = bank_no;
    player->vol = vol;
    return index;
}

/**
 *
 * Stops the sound-effect sequence with the requested identifier.
 *
 */
static void StopSeSeq(int seq_id) {
    sndCSeSeq *seq;

    seq = GetSeSeq(seq_id);

    if (seq != NULL) {
        seq->Stop();
    }
}

/**
 *
 * Sets the volume of a sound-effect sequence player.
 *
 */
static void SetVolSeSeq(int index, int vol) {
    sndCSeSeq *player;

    player = GetSeSeq(index);

    if (vol < 0) {
        vol = 127;
    }

    if (player != NULL) {
        player->vol = vol;
    }
}

void sndStreamOpenFast(char *name) {
    sndWaitSema();
    CSnd.StreamOpenFast(1, name);
    sndSignalSema();
}

int sndStreamOpenState() {
    int state;

    sndWaitSema();
    state = CSnd.StreamOpenState();
    sndSignalSema();
    return state;
}

void sndStreamStandBy() {
    sndWaitSema();
    CSnd.StreamStandBy(1);
    sndSignalSema();
}

void sndStreamSetVol(float left, float right) {
    int left_vol;
    int right_vol;

    if (left < 0.0f) {
        left = 0.0f;
    }

    if (right < 0.0f) {
        right = 0.0f;
    }

    if (left > 1.0f) {
        left = 1.0f;
    }

    if (right > 1.0f) {
        right = 1.0f;
    }

    sndWaitSema();
    left_vol = (int) (32767.0f * left);
    right_vol = (int) (32767.0f * right);
    CSnd.StreamSetVol(1, left_vol, right_vol);
    sndSignalSema();
}

void sndStreamPlay() {
    sndWaitSema();
    CSnd.StreamPlay(1);
    sndSignalSema();
}

void sndStreamPause() {
    sndWaitSema();
    CSnd.StreamPause(1);
    sndSignalSema();
}

void sndStreamRePlay() {
    sndWaitSema();
    CSnd.StreamRePlay(1);
    sndSignalSema();
}

int sndStreamGetState() {
    int state;

    sndWaitSema();
    state = CSnd.StreamGetState(1);
    sndSignalSema();
    return state;
}

void sndStreamClose() {
    sndWaitSema();
    CSnd.StreamClose(1);
    sndSignalSema();
}
