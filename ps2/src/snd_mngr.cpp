#include "common.h"
#include "snd_mngr.hpp"

#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <eekernel.h>
#include <libvu0.h>

#include "dataread.hpp"
#include "mainloop.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mglib.hpp"
#include "snd_seseq.hpp"
#include "sound.hpp"

extern CSound CSnd;
extern int snd_sema_id;
extern float PortVolf[SND_PORT_NUM];
extern sndPortInfo PortInfo[SND_PORT_NUM];
extern sndCSeSeq SeSequencer[32];
extern float MicPos[4];
extern float MicDir[4];
extern "C" int WaitSema(int id);
extern "C" int SignalSema(int id);
sndPortInfo *GetPortInfo(int port);
sndSeInfo *GetSeInfo(u32 snd_id, int index);
sndCSeSeq *GetSeSeq(int seq_id);
int CSndStep();
int IsBgmPort(int port);
int mgGetVSyncCount();

#ifdef NONMATCHING
static int         EnableSndMngr = 1;                      /**< Enables loading sound banks. */
static float       MasterVol[2] = { 1.0f, 1.0f };          /**< Target master volumes. */
static int         MasterVolFade[2] = { 0, 0 };            /**< Active master volume fades. */
static int         snd_old_vsync = -1;                     /**< Last frame stepped by the driver. */
static int         ReverbType[2];                          /**< Reverb type of each core. */
static int         ReverbDepthe[2];                        /**< Reverb depth of each core. */
static int         init_snd;                               /**< Whether the sound driver is initialized. */
static float       feMasterVol[2];                         /**< End volumes of active fades. */
static float       fnowMasterVol[2];                       /**< Current volumes of active fades. */
static float       fstpMasterVol[2];                       /**< Volume change per frame. */

static sndBankInfo *GetBankInfo(unsigned int snd_id);
static void SetMasterVol(int core, float vol);
static void FadeMasterVol();
static void CSndStepWait();
static void SeAllStop_Sub(int port_no);
static int GetCSndPortNo(int port_no, int *port, int *sq_port, int *vol);
static int GetPortBankNo(unsigned int snd_id, int *port, int *bank);
static char *GetLine(char **col, char *text, char *end);
static int PlaySeSeq(unsigned int snd_id, sndCSeSeqData *data, int vol);
static void SetVolSeSeq(int index, int vol);
#endif

// Code (.text)
#ifdef NONMATCHING
int CLoopSeMngr::Create(int num, mgCMemory *memory) {
    unsigned int size;
    unsigned int quadwords;

    if (memory == NULL) {
        return 0;
    }
    size = num * sizeof(SND_LOOP_SE_SEQ);
    quadwords = size >> 4;
    if (size & 0xF) {
        quadwords++;
    }
    loop_se = new (memory->Alloc(quadwords + 2)) SND_LOOP_SE_SEQ[num];
    if (loop_se == NULL) {
        return 0;
    }
    loop_se_num = num;
    return 1;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", Create__11CLoopSeMngrFiP9mgCMemory);
#endif

SND_LOOP_SE_SEQ::SND_LOOP_SE_SEQ() {
    se_id = -1;
    vol = -1.0f;
    pan = 0.0f;
}

void CLoopSeMngr::Initialize(void) {
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

#ifdef NONMATCHING
SND_LOOP_SE_SEQ *CLoopSeMngr::GetLoopSe(int *found, unsigned int se_id, int voice) {
    SND_LOOP_SE_SEQ *free_entry;
    SND_LOOP_SE_SEQ *entry;
    int              i;

    if (loop_se == NULL) {
        return NULL;
    }
    *found = 0;
    free_entry = NULL;
    for (i = 0; i < loop_se_num; i++) {
        if (loop_se[i].se_id < 0) {
            free_entry = &loop_se[i];
            break;
        }
    }
    if ((int)se_id >= 0) {
        for (i = 0; i < loop_se_num; i++) {
            entry = &loop_se[i];
            if (entry->se_id >= 0 && se_id == entry->se_id && voice == entry->voice) {
                *found = 1;
                return entry;
            }
        }
    }
    return free_entry;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", GetLoopSe__11CLoopSeMngrFPiUii);
#endif

int CLoopSeMngr::SeLoopPlayStop(u32 handle, int sound, int flags, int loop) {
    return SeLoopPlayStop(handle, sound, flags, -1.0f, 0.0f, loop);
}

#ifdef NONMATCHING
int CLoopSeMngr::SeLoopPlayStop(unsigned int snd_id, int se_no, int keep_time, float vol, float pan, int voice) {
    unsigned int     se_id;
    SND_LOOP_SE_SEQ *entry;
    int              found;

    if ((int)snd_id < 0 || se_no < 0) {
        return 0;
    }
    se_id = sndCreateID(snd_id, se_no);
    entry = GetLoopSe(&found, se_id, voice);
    if (entry == NULL) {
        return 0;
    }
    entry->se_id = se_id;
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
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", SeLoopPlayStop__11CLoopSeMngrFUiiiffi);
#endif

#ifdef NONMATCHING
void CLoopSeMngr::Step() {
    SND_LOOP_SE_SEQ *entry;
    int              i;
    int              se_no;

    if (loop_se != NULL) {
        for (i = 0; i < loop_se_num; i++) {
            entry = &loop_se[i];
            if (entry->se_id >= 0) {
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
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", Step__11CLoopSeMngrFv);
#endif

#ifdef NONMATCHING
void CLoopSeMngr::AllSeStop() {
    SND_LOOP_SE_SEQ *entry;
    int              i;

    if (loop_se != NULL) {
        for (i = 0; i < loop_se_num; i++) {
            entry = &loop_se[i];
            if (entry->se_id >= 0) {
                sndSeStop(entry->se_id, sndGetSeNo(entry->se_id), entry->voice);
                entry->se_id = -1;
                entry->vol = -1.0f;
                entry->pan = 0.0f;
            }
        }
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", AllSeStop__11CLoopSeMngrFv);
#endif

#ifdef NONMATCHING
int sndGetReverbDepth(int core) {
    if (core < 0 || core >= 2) {
        return 0;
    }
    return ReverbDepthe[core];
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndGetReverbDepth__Fi);
#endif

u32 sndCreateID(u32 snd_id, s32 se_no) {
    return (snd_id & 0xFFFF0000) | (se_no & 0xFFFF);
}
int sndGetSeNo(u32 se_id) {
    return se_id & 0xFFFF;
}

sndPortInfo *GetPortInfo(int port) {
    if (port < 0 || port > SND_PORT_NUM) {
        return NULL;
    }
    return &PortInfo[port];
}

sndCSeSeq *GetSeSeq(int seq_id) {
    if (seq_id < 0 || seq_id >= 32) {
        return NULL;
    }
    return &SeSequencer[seq_id];
}

sndCSeSeq *GetEmptySeSeq(int *seq_id) {
    for (int index = 0; index < 32; index++) {
        sndCSeSeq *sequencer = &SeSequencer[index];
        if (sequencer->data == NULL) {
            *seq_id = index;
            return sequencer;
        }
    }
    return NULL;
}

u32 GetPortNo(u32 sound_id) {
    return (sound_id >> 24) & 0xFF;
}
u32 GetBankNo(u32 sound_id) {
    return (sound_id >> 16) & 0xFF;
}
#ifdef NONMATCHING
/**
 * Finds the loaded bank identified by a sound ID.
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
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", GetBankInfo__FUi);
#endif

#ifdef NONMATCHING
/**
 * Finds a sound effect in the bank identified by a sound ID.
 */
sndSeInfo *GetSeInfo(unsigned int snd_id, int se_no) {
    sndBankInfo  *bank;

    bank = GetBankInfo(snd_id);
    if (bank == NULL) {
        return NULL;
    }
    if (se_no < 0 || se_no >= bank->se_num) {
        return NULL;
    }
    return &bank->se[se_no];
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", GetSeInfo__FUii);
#endif

#ifdef NONMATCHING
void sndInitMngr() {
    SemaParam sema;
    int       i;

    if (init_snd != 0) {
        CSnd.Exit();
        init_snd = 0;
        DeleteSema(snd_sema_id);
        snd_sema_id = -1;
    }
    sema.initCount = 1;
    sema.maxCount = 1;
    snd_sema_id = CreateSema(&sema);
    CSnd.Init(4, 0, 40, 0);
    sndSetMasterVol(0, 1.0f);
    sndSetMasterVol(1, 1.0f);
    init_snd = 1;
    for (i = 0; i < 16; i++) {
        sndInitPort(i);
        PortVolf[i] = 0.0f;
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndInitMngr__Fv);
#endif

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

#ifdef NONMATCHING
void sndInitPort(int port_no) {
    sndPortInfo *info;
    int          i;

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
        for (i = 0; i < 16; i++) {
            info->seseq[i].seseq_no = -1;
        }
        for (i = 0; i < 16; i++) {
            info->bank[i].unk_0 = 0;
            info->bank[i].se_num = 0;
            info->bank[i].se = NULL;
            info->bank[i].sq_num = 0;
            info->bank[i].sq_name = NULL;
            info->bank[i].seseq_num = 0;
            info->bank[i].seseq = NULL;
        }
    }
    sndStopSeSeq(port_no);
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndInitPort__Fi);
#endif

#ifdef NONMATCHING
void sndInitSeSeq(int port_no) {
    sndPortInfo *info;
    int          i;

    info = GetPortInfo(port_no);
    if (info != NULL) {
        for (i = 0; i < 16; i++) {
            info->seseq[i].seseq_no = -1;
        }
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndInitSeSeq__Fi);
#endif

#ifdef NONMATCHING
void sndSetReverb(int core, int type, int depth) {
    if (core < 0 || core >= 2) {
        return;
    }
    sndWaitSema();
    CSnd.SetReverb(core, type, depth);
    ReverbType[core] = type;
    ReverbDepthe[core] = depth;
    sndSignalSema();
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndSetReverb__Fiii);
#endif

#ifdef NONMATCHING
void sndStopVoice(int voice) {
    if (voice < 0 || voice >= 2) {
        return;
    }
    sndWaitSema();
    CSnd.StopVoice(voice);
    sndSignalSema();
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndStopVoice__Fi);
#endif

#ifdef NONMATCHING
/**
 * Applies a clamped master volume to one sound processor core.
 */
static void SetMasterVol(int core, float vol) {
    if (core < 0 || core >= 2) {
        return;
    }
    if (vol < 0.0f) {
        vol = 0.0f;
    }
    if (vol > 1.0f) {
        vol = 1.0f;
    }
    sndWaitSema();
    CSnd.SetMasterVol(core, (int)(16383.0f * vol));
    sndSignalSema();
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", SetMasterVol__Fif);
#endif

#ifdef NONMATCHING
/**
 * Advances active master volume fades by one frame.
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
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", FadeMasterVol__Fv);
#endif

#ifdef NONMATCHING
void sndSetMasterVol(int core, float vol) {
    if (core < 0 || core >= 2) {
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
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndSetMasterVol__Fif);
#endif

#ifdef NONMATCHING
float sndGetMasterVol(int core) {
    if (core < 0 || core >= 2) {
        return 0.0f;
    }
    return MasterVol[core];
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndGetMasterVol__Fi);
#endif

#ifdef NONMATCHING
void sndMasterVolFadeInOut(int core, int frames, float target, float start) {
    float change;

    if (frames < 2 || core < 0 || core >= 2) {
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
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndMasterVolFadeInOut__Fiiff);
#endif

#ifdef NONMATCHING
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
    driver_vol = (int)(127.0f * vol);
    if (vol == 1.0f) {
        driver_vol = 0x100;
    }
    sndWaitSema();
    CSnd.SetVol(info->port, driver_vol);
    sndSignalSema();
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndSetPortVol__Fif);
#endif

float sndGetPortVol(int port) {
    if (port < 0 || port >= SND_PORT_NUM) {
        return 0.0f;
    }
    return PortVolf[port];
}

int sndTransBdState(void) {
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

#ifdef NONMATCHING
/**
 * Steps the driver at most once per vertical sync.
 */
int CSndStep() {
    int vsync;
    int stepped;

    vsync = mgGetVSyncCount();
    stepped = 0;
    if (vsync != snd_old_vsync) {
        CSnd.Step();
        snd_old_vsync = vsync;
        stepped = 1;
    }
    return stepped;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", CSndStep__Fv);
#endif

/**
 * Delays briefly before stepping the sound driver.
 */
static void CSndStepWait() {
    int delay;

    for (delay = 0; delay < 10000; delay++) {
    }
    CSnd.Step();
}

#ifdef NONMATCHING
void sndStep(float frames) {
    sndPortInfo *info;
    sndCSeSeq   *player;
    int          port_no;
    int          i;

    for (port_no = 0; port_no < 16; port_no++) {
        info = GetPortInfo(port_no);
        if (info != NULL) {
            for (i = 0; i < 16; i++) {
                if (info->seseq[i].seseq_no >= 0) {
                    player = GetSeSeq(info->seseq[i].seseq_no);
                    if (player != NULL && player->Step(frames) != 0) {
                        info->seseq[i].seseq_no = -1;
                    }
                }
            }
        }
    }
    FadeMasterVol();
    sndFlush();
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndStep__Ff);
#endif

void sndFlush(void) {
    sndWaitSema();
    CSndStep();
    sndSignalSema();
}

#ifdef NONMATCHING
/**
 * Stops both driver ports assigned to a game sound port.
 */
static void SeAllStop_Sub(int port_no) {
    sndPortInfo  *info;

    if (port_no >= 0) {
        info = GetPortInfo(port_no);
        if (info != NULL) {
            if (info->port >= 0) {
                CSnd.Stop(info->port);
            }
            if (info->sq_port >= 0 && info->sq_port != info->port) {
                CSnd.Stop(info->sq_port);
            }
        }
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", SeAllStop_Sub__Fi);
#endif

#ifdef NONMATCHING
void sndSeAllStop(int port_no) {
    int i;

    if (port_no < 0) {
        for (i = 0; i < 12; i++) {
            if (i != SND_PORT_BGM && i != SND_PORT_BGM2) {
                sndStopSeSeq(port_no);
                sndInitSeSeq(port_no);
                sndWaitSema();
                SeAllStop_Sub(i);
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
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndSeAllStop__Fi);
#endif

int sndGetSeDefVol(u32 se_id, int index) {
    sndSeInfo *info;

    info = GetSeInfo(se_id, index);
    if (info != NULL) {
        return info->def_vol;
    }
    return 0;
}

/**
 * Identifies the driver's voice-capable music ports.
 */
int IsBgmPort(int port) {
    if (port == 0 || port == 11) {
        return 1;
    }
    return 0;
}

#ifdef NONMATCHING
/**
 * Maps a game port to its driver ports and initial volume.
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
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", GetCSndPortNo__FiPiPiPi);
#endif

#ifdef NONMATCHING
unsigned int sndLoadSound(int port_no, unsigned int *pack, mgCMemory *memory) {
    sndPortInfo  *info;
    sndBankInfo  *bank;
    unsigned int *config;
    unsigned int *volume;
    unsigned int *bd;
    unsigned int *hd;
    unsigned int *sq[32];
    unsigned int *mid[48];
    int           sq_size[32];
    int           mid_size[48];
    char         *sq_name[32];
    char         *mid_name[48];
    int           config_size;
    int           volume_size;
    int           bd_size;
    int           hd_size;
    int           initial_vol;
    int           bank_no;
    unsigned int  size;
    unsigned int  quadwords;
    int           i;

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
            CSnd.LoadHdBd(info->port, (int)hd, hd_size, (int)bd, bd_size);
        }
        sndWaitTransBd();
        info->bank_num++;
    } else {
        if (info->bank_num >= 16) {
            sndSignalSema();
            return -1;
        }
        if (bd_size != 0 && hd_size != 0) {
            CSnd.LoadHdBdAdd(info->port, (int)hd, hd_size, (int)bd, bd_size);
        }
        sndWaitTransBd();
        info->bank_num++;
    }
    bank = NULL;
    if (bank_no >= 0 && bank_no < info->bank_num) {
        bank = &info->bank[bank_no];
    }
    if (bank == NULL) {
        sndSignalSema();
        return -1;
    }
    if (port_no == SND_PORT_BGM || port_no == SND_PORT_BGM2 || port_no == 2 || port_no == SND_PORT_EVENT) {
        bank->sq_num = GetPackFileExt(pack, "sq", sq, 32, sq_size, sq_name);
        size = bank->sq_num * sizeof(char *);
        quadwords = size >> 4;
        if (size & 0xF) {
            quadwords++;
        }
        bank->sq_name = new (memory->Alloc(quadwords + 2)) char *[bank->sq_num];
        for (i = 0; i < bank->sq_num; i++) {
            bank->sq_name[i] = NULL;
            CSnd.LoadSeq(info->sq_port, (int)sq[i], sq_size[i]);
            bank->sq_name[i] = mgCopyString(sq_name[i], memory);
        }
    }
    bank->seseq_num = GetPackFileExt(pack, "mid", mid, 48, mid_size, mid_name);
    if (bank->seseq_num > 0) {
        size = bank->seseq_num * sizeof(sndCSeSeqData);
        quadwords = size >> 4;
        if (size & 0xF) {
            quadwords++;
        }
        bank->seseq = new (memory->Alloc(quadwords + 2)) sndCSeSeqData[bank->seseq_num];
    }
    for (i = 0; i < bank->seseq_num; i++) {
        bank->seseq[i].name = mgCopyString(mid_name[i], memory);
        bank->seseq[i].LoadSMF((char *)mid[i], mid_size[i], memory);
    }
    if (initial_vol >= 0) {
        CSnd.SetVol(info->port, initial_vol);
        if (port_no >= 0 && port_no <= 16) {
            PortVolf[port_no] = 1.0f;
        }
    }
    info->LoadSeInfoTxt(bank_no, (char *)config, config_size, memory);
    info->LoadVolInfoTxt(bank_no, (char *)volume, volume_size);
    sndSignalSema();
    return ((port_no & 0xFF) << 24) | ((bank_no & 0xFF) << 16);
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndLoadSound__FiPUiP9mgCMemory);
#endif

sndCSeSeqData::sndCSeSeqData() {
    Initialize();
}

#ifdef NONMATCHING
void sndDeletePort(int port_no) {
    int port;
    int sq_port;
    int vol;

    vol = -1;
    if (GetCSndPortNo(port_no, &port, &sq_port, &vol) != 0) {
        sndWaitSema();
        if (port >= 0) {
            CSnd.DEL_PORT(port);
        }
        if (sq_port >= 0 && sq_port != port) {
            CSnd.DEL_PORT(sq_port);
        }
        sndSignalSema();
    }
    sndInitPort(port_no);
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndDeletePort__Fi);
#endif

#ifdef NONMATCHING
/**
 * Returns the driver port and bank of a loaded sound ID.
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
    bank_info = NULL;
    if (bank_no >= 0 && bank_no < info->bank_num) {
        bank_info = &info->bank[bank_no];
    }
    if (bank_info == NULL) {
        return 0;
    }
    *port = info->port;
    *bank = bank_no;
    return 1;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", GetPortBankNo__FUiPiPi);
#endif

void sndSePlay(u32 snd_id, s32 se_no, s32 voice) {
    sndSePlaySeID(snd_id, se_no, -1, -1, 0x40, 0x2000, voice);
}
void sndSePlayV(u32 snd_id, s32 se_no, s32 vol, s32 voice) {
    sndSePlaySeID(snd_id, se_no, -1, vol, 0x40, 0x2000, voice);
}
void sndSePlayVP(u32 snd_id, s32 se_no, s32 vol, s32 pan, s32 voice) {
    sndSePlaySeID(snd_id, se_no, -1, vol, pan, 0x2000, voice);
}
#ifdef NONMATCHING
void sndSePlayVPf(unsigned int snd_id, int se_no, float vol, float pan, int voice) {
    int volume;
    int driver_pan;

    volume = (int)(vol * sndGetSeDefVol(snd_id, se_no));
    if (volume >= 128) {
        volume = 127;
    }
    driver_pan = (int)(64.0f * pan) + 64;
    if (driver_pan < 0) {
        driver_pan = 0;
    }
    if (driver_pan >= 128) {
        driver_pan = 127;
    }
    sndSePlaySeID(snd_id, se_no, -1, volume, driver_pan, SND_SE_PITCH_CENTER, voice);
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndSePlayVPf__FUiiffi);
#endif

#ifdef NONMATCHING
void sndSePlayVf(unsigned int snd_id, int se_no, float vol, int voice) {
    int volume;

    volume = (int)(vol * sndGetSeDefVol(snd_id, se_no));
    if (volume >= 128) {
        volume = 127;
    }
    sndSePlayV(snd_id, se_no, volume, voice);
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndSePlayVf__FUiifi);
#endif

#ifdef NONMATCHING
void sndSePause(unsigned int snd_id, int se_no) {
    sndPortInfo *info;
    sndBankInfo *bank;
    sndSeInfo   *se;
    int          port_no;
    int          bank_no;

    if (snd_id == (unsigned int)-1) {
        return;
    }
    port_no = GetPortNo(snd_id);
    bank_no = GetBankNo(snd_id);
    info = GetPortInfo(port_no);
    if (info == NULL) {
        return;
    }
    bank = NULL;
    if (bank_no >= 0 && bank_no < info->bank_num) {
        bank = &info->bank[bank_no];
    }
    if (bank == NULL) {
        return;
    }
    se = NULL;
    if (se_no >= 0 && se_no < bank->se_num) {
        se = &bank->se[se_no];
    }
    if (se != NULL && se->type == SND_SE_TYPE_SQ && info->sq_state == SND_SQ_STATE_PLAY) {
        sndSqStop(info->sq_port, se->prog);
        info->sq_state = SND_SQ_STATE_PAUSE;
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndSePause__FUii);
#endif

#ifdef NONMATCHING
int sndGetSeStatus(unsigned int snd_id, int se_no) {
    sndPortInfo *info;
    sndBankInfo *bank;
    sndSeInfo   *se;
    int          port_no;
    int          bank_no;

    if (snd_id == (unsigned int)-1) {
        return -1;
    }
    port_no = GetPortNo(snd_id);
    bank_no = GetBankNo(snd_id);
    info = GetPortInfo(port_no);
    if (info == NULL) {
        return -1;
    }
    bank = NULL;
    if (bank_no >= 0 && bank_no < info->bank_num) {
        bank = &info->bank[bank_no];
    }
    if (bank == NULL) {
        return -1;
    }
    se = NULL;
    if (se_no >= 0 && se_no < bank->se_num) {
        se = &bank->se[se_no];
    }
    if (se == NULL || se->type != SND_SE_TYPE_SQ) {
        return -1;
    }
    return info->sq_state;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndGetSeStatus__FUii);
#endif

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

#ifdef NONMATCHING
int sndSeCheck(unsigned int snd_id, int se_no) {
    sndPortInfo *info;
    sndBankInfo *bank;
    sndSeInfo   *se;
    int          port_no;
    int          bank_no;

    if (snd_id == (unsigned int)-1) {
        return 0;
    }
    port_no = GetPortNo(snd_id);
    bank_no = GetBankNo(snd_id);
    info = GetPortInfo(port_no);
    if (info == NULL) {
        return 0;
    }
    bank = NULL;
    if (bank_no >= 0 && bank_no < info->bank_num) {
        bank = &info->bank[bank_no];
    }
    if (bank == NULL) {
        return 0;
    }
    se = NULL;
    if (se_no >= 0 && se_no < bank->se_num) {
        se = &bank->se[se_no];
    }
    if (se == NULL) {
        return 0;
    }
    return 1;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndSeCheck__FUii);
#endif

#ifdef NONMATCHING
void sndSePlaySeID(unsigned int snd_id, int se_no, int velocity, int vol, int pan, int pitch, int voice) {
    sndPortInfo   *info;
    sndBankInfo   *bank;
    sndSeInfo     *se;
    int            port_no;
    int            bank_no;
    sndPortSeSeq  *entry;
    sndCSeSeqData *data;
    int            i;

    if (snd_id == (unsigned int)-1) {
        return;
    }
    port_no = GetPortNo(snd_id);
    bank_no = GetBankNo(snd_id);
    info = GetPortInfo(port_no);
    if (info == NULL) {
        return;
    }
    bank = NULL;
    if (bank_no >= 0 && bank_no < info->bank_num) {
        bank = &info->bank[bank_no];
    }
    if (bank == NULL) {
        return;
    }
    se = NULL;
    if (se_no >= 0 && se_no < bank->se_num) {
        se = &bank->se[se_no];
    }
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
        entry = NULL;
        for (i = 0; i < 16; i++) {
            if (info->seseq[i].seseq_no < 0) {
                entry = &info->seseq[i];
                break;
            }
        }
        data = NULL;
        if (se->prog >= 0 && se->prog < bank->seseq_num) {
            data = &bank->seseq[se->prog];
        }
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
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndSePlaySeID__FUiiiiiii);
#endif

#ifdef NONMATCHING
void sndSeStop(unsigned int snd_id, int se_no, int voice) {
    sndPortInfo  *info;
    sndBankInfo  *bank;
    sndSeInfo    *se;
    int           port_no;
    int           bank_no;
    sndPortSeSeq *entry;
    int           i;

    if (snd_id == (unsigned int)-1) {
        return;
    }
    port_no = GetPortNo(snd_id);
    bank_no = GetBankNo(snd_id);
    info = GetPortInfo(port_no);
    if (info == NULL) {
        return;
    }
    bank = NULL;
    if (bank_no >= 0 && bank_no < info->bank_num) {
        bank = &info->bank[bank_no];
    }
    if (bank == NULL) {
        return;
    }
    se = NULL;
    if (se_no >= 0 && se_no < bank->se_num) {
        se = &bank->se[se_no];
    }
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
        entry = NULL;
        for (i = 0; i < 16; i++) {
            if (info->seseq[i].seseq_no >= 0 && info->seseq[i].bank == bank_no && info->seseq[i].se_no == se_no && info->seseq[i].voice == voice) {
                entry = &info->seseq[i];
                break;
            }
        }
        if (entry != NULL) {
            StopSeSeq(entry->seseq_no);
        }
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndSeStop__FUiii);
#endif

#ifdef NONMATCHING
void sndSetSeVol(unsigned int snd_id, int se_no, int vol, int voice) {
    sndPortInfo  *info;
    sndBankInfo  *bank;
    sndSeInfo    *se;
    int           port_no;
    int           bank_no;
    sndPortSeSeq *entry;
    int           i;

    if (snd_id == (unsigned int)-1) {
        return;
    }
    port_no = GetPortNo(snd_id);
    bank_no = GetBankNo(snd_id);
    info = GetPortInfo(port_no);
    if (info == NULL) {
        return;
    }
    bank = NULL;
    if (bank_no >= 0 && bank_no < info->bank_num) {
        bank = &info->bank[bank_no];
    }
    if (bank == NULL) {
        return;
    }
    se = NULL;
    if (se_no >= 0 && se_no < bank->se_num) {
        se = &bank->se[se_no];
    }
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
        entry = NULL;
        for (i = 0; i < 16; i++) {
            if (info->seseq[i].seseq_no >= 0 && info->seseq[i].bank == bank_no && info->seseq[i].se_no == se_no && info->seseq[i].voice == voice) {
                entry = &info->seseq[i];
                break;
            }
        }
        if (entry != NULL) {
            SetVolSeSeq(entry->seseq_no, vol);
        }
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndSetSeVol__FUiiii);
#endif

#ifdef NONMATCHING
void sndSetSePan(unsigned int snd_id, int se_no, int pan, int voice) {
    sndPortInfo *info;
    sndBankInfo *bank;
    sndSeInfo   *se;
    int          port_no;
    int          bank_no;

    if (snd_id == (unsigned int)-1) {
        return;
    }
    port_no = GetPortNo(snd_id);
    bank_no = GetBankNo(snd_id);
    info = GetPortInfo(port_no);
    if (info == NULL) {
        return;
    }
    bank = NULL;
    if (bank_no >= 0 && bank_no < info->bank_num) {
        bank = &info->bank[bank_no];
    }
    if (bank == NULL) {
        return;
    }
    se = NULL;
    if (se_no >= 0 && se_no < bank->se_num) {
        se = &bank->se[se_no];
    }
    if (se == NULL) {
        return;
    }
    if (se->type == SND_SE_TYPE_KEYON) {
        sndSetSePanPrKr(snd_id, se->prog, se->key, pan, voice);
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndSetSePan__FUiiii);
#endif

#ifdef NONMATCHING
void sndSetSeVolf(unsigned int snd_id, int se_no, float vol, int voice) {
    int volume;

    volume = (int)(vol * sndGetSeDefVol(snd_id, se_no));
    if (volume >= 128) {
        volume = 127;
    }
    sndSetSeVol(snd_id, se_no, volume, voice);
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndSetSeVolf__FUiifi);
#endif

#ifdef NONMATCHING
void sndSetSePanf(unsigned int snd_id, int se_no, float pan, int voice) {
    int driver_pan;

    driver_pan = (int)(64.0f * pan) + 64;
    if (driver_pan < 0) {
        driver_pan = 0;
    }
    if (driver_pan >= 128) {
        driver_pan = 127;
    }
    sndSetSePan(snd_id, se_no, driver_pan, voice);
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndSetSePanf__FUiifi);
#endif

#ifdef NONMATCHING
void sndSetSePitch(unsigned int snd_id, int se_no, int pitch, int voice) {
    sndPortInfo *info;
    sndBankInfo *bank;
    sndSeInfo   *se;
    int          port_no;
    int          bank_no;

    if (snd_id == (unsigned int)-1) {
        return;
    }
    port_no = GetPortNo(snd_id);
    bank_no = GetBankNo(snd_id);
    info = GetPortInfo(port_no);
    if (info == NULL) {
        return;
    }
    bank = NULL;
    if (bank_no >= 0 && bank_no < info->bank_num) {
        bank = &info->bank[bank_no];
    }
    if (bank == NULL) {
        return;
    }
    se = NULL;
    if (se_no >= 0 && se_no < bank->se_num) {
        se = &bank->se[se_no];
    }
    if (se == NULL) {
        return;
    }
    if (se->type == SND_SE_TYPE_KEYON) {
        sndSetSePitchPrKr(snd_id, se->prog, se->key, pitch, voice);
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndSetSePitch__FUiiii);
#endif

void sndSetMicPos(float *position, float *direction) {
    *(u_long128 *)MicPos = *(u_long128 *)position;
    *(u_long128 *)MicDir = *(u_long128 *)direction;
}

#ifdef NONMATCHING
void sndGetVolPan(float *vol, float *pan, float *pos, float near_dist, float far_dist) {
    sceVu0FVECTOR direction;
    sceVu0FVECTOR side;
    float         distance;
    float         volume;
    float         projection;
    float         square;
    float         panning;
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
    square = projection * projection;
    panning = 0.7f * (sign * (square * square));
    *pan = panning;
    if (panning < 0.0f) {
        panning = -panning;
    }
    *vol *= 1.0f + 0.4f * panning;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndGetVolPan__FPfPfPfff);
#endif

#ifdef NONMATCHING
void sndGetVolPan(float *vol, float *pan, float *start, float *end, float near_dist, float far_dist) {
    sceVu0FVECTOR nearest;

    mgDistLinePoint(MicPos, start, end, nearest);
    sndGetVolPan(vol, pan, nearest, near_dist, far_dist);
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndGetVolPan__FPfPfPfPfff);
#endif

#ifdef NONMATCHING
int sndVolLimit(int vol) {
    if (vol < 0) {
        vol = 0;
    }
    if (vol >= 128) {
        vol = 127;
    }
    return vol;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndVolLimit__Fi);
#endif

#ifdef NONMATCHING
void sndSePlayPrKr(unsigned int snd_id, int prog, int key, int velocity, int vol, int pan, int pitch, int voice) {
    int port;
    int bank;

    if (snd_id != (unsigned int)-1 && GetPortBankNo(snd_id, &port, &bank) != 0) {
        sndSePlayPBPrKr(port, bank, prog, key, velocity, vol, pan, pitch, voice);
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndSePlayPrKr__FUiiiiiiii);
#endif

#ifdef NONMATCHING
void sndSeStopPrKr(unsigned int snd_id, int prog, int key, int voice) {
    int port;
    int bank;

    if (snd_id != (unsigned int)-1 && GetPortBankNo(snd_id, &port, &bank) != 0) {
        sndSeStopPBPrKr(port, bank, prog, key, voice);
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndSeStopPrKr__FUiiii);
#endif

#ifdef NONMATCHING
void sndSetSeVolPrKr(unsigned int snd_id, int prog, int key, int vol, int voice) {
    int port;
    int bank;

    if (snd_id != (unsigned int)-1 && GetPortBankNo(snd_id, &port, &bank) != 0) {
        sndSetSeVolPBPrKr(port, bank, prog, key, vol, voice);
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndSetSeVolPrKr__FUiiiii);
#endif

#ifdef NONMATCHING
void sndSetSePanPrKr(unsigned int snd_id, int prog, int key, int pan, int voice) {
    int port;
    int bank;

    if (snd_id != (unsigned int)-1 && GetPortBankNo(snd_id, &port, &bank) != 0) {
        sndSetSePanPBPrKr(port, bank, prog, key, pan, voice);
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndSetSePanPrKr__FUiiiii);
#endif

#ifdef NONMATCHING
void sndSetSePitchPrKr(unsigned int snd_id, int prog, int key, int pitch, int voice) {
    int port;
    int bank;

    if (snd_id != (unsigned int)-1 && GetPortBankNo(snd_id, &port, &bank) != 0) {
        sndSetSePitchPBPrKr(port, bank, prog, key, pitch, voice);
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndSetSePitchPrKr__FUiiiii);
#endif

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
 * Reads a line of tab or space separated columns into text buffers.
 */
static char *GetLine(char **col, char *text, char *end) {
    char crlf[] = { '\r', '\n' };
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

#ifdef NONMATCHING
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
        if (name[i] == '.') {
            return SND_SE_TYPE_NONE;
        }
    }
    return SND_SE_TYPE_KEYON;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", SearchSeq__11sndBankInfoFPcPi);
#endif

#ifdef NONMATCHING
void sndPortInfo::LoadSeInfoTxt(int bank_no, char *text, int size, mgCMemory *memory) {
    sndBankInfo *bank_info;
    sndSeInfo   *entry;
    char        *end;
    char        *line;
    char        *col[9] = { NULL };
    char         number[8];
    char         name[64];
    char         description[64];
    char         category[8];
    char         filename[64];
    char         program[8];
    char         key[8];
    char         flag[8];
    unsigned int bytes;
    unsigned int quadwords;
    int          count;
    int          index;
    int          reverb_type;
    int          depth;
    int          core;

    bank_info = NULL;
    if (bank_no >= 0 && bank_no < bank_num) {
        bank_info = &bank[bank_no];
    }
    if (bank_info == NULL) {
        return;
    }
    end = text + size;
    line = text;
    col[0] = number;
    col[1] = name;
    col[2] = description;
    col[3] = category;
    col[4] = filename;
    col[5] = program;
    col[6] = key;
    col[7] = flag;
    bank_info->se_num = 0;
    while (line < end) {
        line = GetLine(col, line, end);
        if (strcmp(col[0], "END") == 0) {
            break;
        }
        bank_info->se_num++;
    }
    bytes = bank_info->se_num * sizeof(sndSeInfo);
    quadwords = bytes >> 4;
    if (bytes & 0xF) {
        quadwords++;
    }
    bank_info->se = new (memory->Alloc(quadwords + 2)) sndSeInfo[bank_info->se_num];
    line = text;
    count = 0;
    while (line < end && count < bank_info->se_num) {
        line = GetLine(col, line, end);
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
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", LoadSeInfoTxt__11sndPortInfoFiPciP9mgCMemory);
#endif

sndSeInfo::sndSeInfo(void) {
    this->unk_0 = 0;
    this->type = 0;
}

#ifdef NONMATCHING
void sndPortInfo::LoadVolInfoTxt(int bank_no, char *text, int size) {
    sndBankInfo *bank_info;
    sndSeInfo   *entry;
    char        *end;
    char        *line;
    char        *col[4] = { NULL };
    char         number[8];
    char         volume[64];
    char         depth_text[64];
    int          se_no;
    int          type;
    int          depth;
    int          core;

    bank_info = NULL;
    if (bank_no >= 0 && bank_no < bank_num) {
        bank_info = &bank[bank_no];
    }
    if (bank_info == NULL) {
        return;
    }
    end = text + size;
    col[0] = number;
    col[1] = volume;
    col[2] = depth_text;
    line = text;
    while (line < end) {
        line = GetLine(col, line, end);
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
            entry = NULL;
            if (se_no >= 0 && se_no < bank_info->se_num) {
                entry = &bank_info->se[se_no];
            }
            if (entry != NULL) {
                entry->def_vol = atoi(volume);
            }
        }
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", LoadVolInfoTxt__11sndPortInfoFiPci);
#endif

#ifdef NONMATCHING
void sndStopSeSeq(int port_no) {
    sndPortInfo *info;
    sndCSeSeq   *player;
    int          port;
    int          i;

    info = GetPortInfo(port_no);
    if (info != NULL) {
        port = info->port;
        for (i = 0; i < 32; i++) {
            player = &SeSequencer[i];
            if (player->data != NULL && player->port == port) {
                player->Stop();
            }
        }
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndStopSeSeq__Fi);
#endif

#ifdef NONMATCHING
/**
 * Starts a sound-effect sequence on a free player.
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
    if (snd_id == (unsigned int)-1) {
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
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", PlaySeSeq__FUiP13sndCSeSeqDatai);
#endif

void StopSeSeq(int seq_id) {
    sndCSeSeq *seq;

    seq = GetSeSeq(seq_id);
    if (seq != NULL) {
        seq->Stop();
    }
}

#ifdef NONMATCHING
/**
 * Sets the volume of a sound-effect sequence player.
 */
static void SetVolSeSeq(int index, int vol) {
    sndCSeSeq  *player;

    player = GetSeSeq(index);
    if (vol < 0) {
        vol = 127;
    }
    if (player != NULL) {
        player->vol = vol;
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", SetVolSeSeq__Fii);
#endif

void sndStreamOpenFast(char *name) {
    sndWaitSema();
    CSnd.StreamOpenFast(1, name);
    sndSignalSema();
}

int sndStreamOpenState(void) {
    int state;

    sndWaitSema();
    state = CSnd.StreamOpenState();
    sndSignalSema();
    return state;
}

void sndStreamStandBy(void) {
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
    left_vol = (int)(32767.0f * left);
    right_vol = (int)(32767.0f * right);
    CSnd.StreamSetVol(1, left_vol, right_vol);
    sndSignalSema();
}

void sndStreamPlay(void) {
    sndWaitSema();
    CSnd.StreamPlay(1);
    sndSignalSema();
}

void sndStreamPause(void) {
    sndWaitSema();
    CSnd.StreamPause(1);
    sndSignalSema();
}

void sndStreamRePlay(void) {
    sndWaitSema();
    CSnd.StreamRePlay(1);
    sndSignalSema();
}

int sndStreamGetState(void) {
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

#ifdef NONMATCHING
// Defined inline in snd_seseq.hpp.
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", __ct__9sndCSeSeqFv);
#endif

#ifdef NONMATCHING
// Defined inline in snd_mngr.hpp.
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", __ct__11sndPortInfoFv);
#endif


// Static initialiser (.init)
#ifdef NONMATCHING
// PortInfo and SeSequencer produce this initializer.
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", __sinit_snd_mngr_cpp);
#endif


// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/snd_mngr", at_732__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/snd_mngr", at_816__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/snd_mngr", at_896__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/snd_mngr", at_897__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/snd_mngr", at_898__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/snd_mngr", at_899__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/snd_mngr", at_900__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/snd_mngr", at_1549__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/snd_mngr", at_1625__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/snd_mngr", at_1626__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/snd_mngr", at_1627__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/snd_mngr", at_1628__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/snd_mngr", at_1629__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/snd_mngr", at_1630__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/snd_mngr", at_1631__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/snd_mngr", at_1632__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/snd_mngr", at_1633__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/snd_mngr", at_1634__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/snd_mngr", at_1635__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/snd_mngr", at_1636__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/snd_mngr", at_1679__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/snd_mngr", at_1680__DATA);

// Static initialiser table (.ctor)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/snd_mngr", D_0037AFF4__DATA);

// Small initialised data (.sdata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/snd_mngr", EnableSndMngr__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/snd_mngr", snd_sema_id__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/snd_mngr", MasterVol__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/snd_mngr", MasterVolFade__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/snd_mngr", snd_old_vsync__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/snd_mngr", at_1469__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(ReverbType, 0x8);
INCLUDE_BSS(ReverbDepthe, 0x8);
INCLUDE_BSS(init_snd, 0x8);
INCLUDE_BSS(feMasterVol, 0x8);
INCLUDE_BSS(fnowMasterVol, 0x8);
INCLUDE_BSS(fstpMasterVol, 0x8);

// Uninitialised data (.bss)
INCLUDE_BSS(PortInfo, 0x29C0);
INCLUDE_BSS(SeSequencer, 0x1600);
INCLUDE_BSS(PortVolf, 0x40);
INCLUDE_BSS(MicPos, 0x10);
INCLUDE_BSS(MicDir, 0x10);
INCLUDE_BSS(at_1555, 0x30);
INCLUDE_BSS(at_1648, 0x10);
