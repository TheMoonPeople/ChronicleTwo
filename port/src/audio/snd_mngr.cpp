// clang-format off
// Load JSON before legacy game headers define conflicting macros.
#include <nlohmann/json.hpp>
// clang-format on

#include "common.h"
#include "mw_runtime.h"

#include <eekernel.h>
#include <libvu0.h>

#include <algorithm>
#include <cctype>
#include <climits>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <limits>
#include <new>
#include <optional>
#include <utility>
#include <vector>

#include "assets/data_registry.hpp"
#include "audio/sound_runtime.hpp"
#include "audio/sq.hpp"
#include "audio_assets.hpp"
#include "dataread.hpp"
#include "log/log.hpp"
#include "mainloop.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mglib.hpp"
#include "platform/native_config.hpp"
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

static sndPortInfo             *GetPortInfo(int port);
static std::optional<sndSeInfo> GetSeInfo(u32 snd_id, int se_no);
static sndCSeSeq               *GetSeSeq(int seq_id);
static int                      CSndStep();
static int                      IsBgmPort(int port);

std::optional<sndCSeSeqData> sndBankInfo::GetSeSeqData(int index) const {
    const auto bytes = seseq_storage.Bytes();
    if (index < 0 || seseq_num < 0 || index >= seseq_num ||
        static_cast<std::size_t>(seseq_num) > bytes.size() / sizeof(sndCSeSeqData) ||
        bytes.data() != reinterpret_cast<const u8 *>(seseq)) {
        return std::nullopt;
    }
    return seseq[index];
}

static void StopSeSeq(int seq_id);
static int  GetCSndPortNo(int port_no, int *port, int *sq_port, int *vol);
static void FadeMasterVol();
static void SetMasterVol(int core, float vol);
static void SeAllStop_Sub(int port_no);

static sndBankInfo *GetBankInfo(unsigned int snd_id);
static int          PlaySeSeq(unsigned int snd_id, const sndCSeSeqData &data, int vol);
static void         SetVolSeSeq(int index, int vol);
static int          GetPortBankNo(unsigned int snd_id, int *port, int *bank);

int CLoopSeMngr::Create(int sequence_count, mgCMemory *memory) {
    if (memory == nullptr || memory->lock != 0 || sequence_count <= 0) {
        return 0;
    }
    const auto count = static_cast<std::size_t>(sequence_count);
    const auto quadwords = dc2::memory::ArrayQuadwords<SND_LOOP_SE_SEQ>(count);
    if (!quadwords || static_cast<std::size_t>(*quadwords) >=
                          dc2::memory::RemainingBytes(*memory).size() / sizeof(u_long128)) {
        return 0;
    }

    auto *entries = dc2::memory::NewArray<SND_LOOP_SE_SEQ>(*memory, count);
    if (entries == nullptr) {
        return 0;
    }
    const auto storage = dc2::memory::ArenaBuffer::Bind(*memory,
                                                        {reinterpret_cast<u8 *>(entries), count * sizeof(SND_LOOP_SE_SEQ)});
    if (storage.Bytes().empty()) {
        return 0;
    }
    loop_storage = storage;
    loop_se_num = sequence_count;
    return 1;
}

SND_LOOP_SE_SEQ::SND_LOOP_SE_SEQ() {
    se_id = -1;
    vol = -1.0f;
    pan = 0.0f;
}

std::span<SND_LOOP_SE_SEQ> CLoopSeMngr::Entries() const {
    const auto bytes = loop_storage.Bytes();
    if (loop_se_num <= 0 || static_cast<std::size_t>(loop_se_num) > bytes.size() / sizeof(SND_LOOP_SE_SEQ) ||
        reinterpret_cast<std::uintptr_t>(bytes.data()) % alignof(SND_LOOP_SE_SEQ) != 0) {
        return {};
    }
    return {reinterpret_cast<SND_LOOP_SE_SEQ *>(bytes.data()), static_cast<std::size_t>(loop_se_num)};
}

void CLoopSeMngr::Initialize() {
    loop_se_num = 0;
    loop_storage = {};
}

void CLoopSeMngr::Clear() {
    const auto entries = Entries();
    auto      *loop_se = entries.data();
    const auto live_count = entries.size();
    if (loop_se != nullptr) {
        for (int index = 0; static_cast<std::size_t>(index) < live_count; index++) {
            SND_LOOP_SE_SEQ *entry = &loop_se[index];
            entry->se_id = -1;
            entry->vol = -1.0f;
            entry->pan = 0.0f;
        }
    }
}

SND_LOOP_SE_SEQ *CLoopSeMngr::GetLoopSe(int *found, unsigned int se_id, int voice) {
    const auto       entries = Entries();
    auto            *loop_se = entries.data();
    const auto       live_count = entries.size();
    SND_LOOP_SE_SEQ *free_entry = {};
    int              i = {};

    if (found == nullptr) {
        return nullptr;
    }
    *found = 0;
    if (entries.empty()) {
        return nullptr;
    }

    free_entry = nullptr;

    for (i = 0; static_cast<std::size_t>(i) < live_count; i++) {
        if ((int) loop_se[i].se_id < 0) {
            free_entry = &loop_se[i];
            break;
        }
    }

    if ((int) se_id >= 0) {
        for (i = 0; static_cast<std::size_t>(i) < live_count; i++) {
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
    SND_LOOP_SE_SEQ *entry = {};
    int              found = {};

    if ((int) snd_id < 0 || se_no < 0 || !std::in_range<s16>(keep_time) || !std::in_range<s16>(voice) ||
        !std::isfinite(vol) || !std::isfinite(pan)) {
        return 0;
    }

    snd_id = sndCreateID(snd_id, se_no);
    entry = GetLoopSe(&found, snd_id, voice);

    if (entry == nullptr) {
        return 0;
    }

    entry->se_id = snd_id;
    entry->keep_time = static_cast<s16>(keep_time);
    entry->vol = vol;
    entry->pan = pan;

    if (found != 0) {
        entry->count = 1;
    } else {
        entry->count = 0;
    }

    entry->voice = static_cast<s16>(voice);
    return 1;
}

void CLoopSeMngr::Step() {
    const auto       entries = Entries();
    auto            *loop_se = entries.data();
    const auto       live_count = entries.size();
    SND_LOOP_SE_SEQ *entry = {};
    int              i = {};
    int              se_no = {};

    if (loop_se != nullptr) {
        for (i = 0; static_cast<std::size_t>(i) < live_count; i++) {
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

                if (entry->count < SHRT_MAX) {
                    ++entry->count;
                }
            }
        }
    }
}

void CLoopSeMngr::AllSeStop() {
    const auto       entries = Entries();
    auto            *loop_se = entries.data();
    const auto       live_count = entries.size();
    SND_LOOP_SE_SEQ *entry = {};
    int              i = {};
    int              se_no = {};

    if (loop_se != nullptr) {
        for (i = 0; static_cast<std::size_t>(i) < live_count; i++) {
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
    if (port < 0 || port >= SND_PORT_NUM) {
        return nullptr;
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
        return nullptr;
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

        if (!dc2::audio::SequencePlaying(*sequencer)) {
            *seq_id = index;
            return sequencer;
        }
    }

    return nullptr;
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
    sndPortInfo *info = {};
    int          port_no = {};
    int          bank_no = {};

    port_no = GetPortNo(snd_id);
    bank_no = GetBankNo(snd_id);
    info = GetPortInfo(port_no);

    if (info == nullptr) {
        return nullptr;
    }

    return info->GetBank(bank_no);
}

/**
 *
 * Finds a sound effect in the bank identified by a sound ID.
 *
 */
static std::optional<sndSeInfo> GetSeInfo(unsigned int snd_id, int se_no) {
    const auto *bank = GetBankInfo(snd_id);
    return bank != nullptr ? bank->GetSe(se_no) : std::nullopt;
}

void sndInitMngr();

void sndWaitSema();

void sndSignalSema();

void sndInitPort(int port_no) {
    sndPortInfo *info = {};

    sndSeAllStop(port_no);

    if (port_no == SND_PORT_BGM || port_no == SND_PORT_BGM2) {
        sndStopVoice(0);
    }

    info = GetPortInfo(port_no);

    if (info != nullptr) {
        sndStopSeSeq(port_no);
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
            info->bank[i] = sndBankInfo{};
        }
    }
}

void sndInitSeSeq(int port_no) {
    sndPortInfo *port_info = {};
    int          index = {};

    port_info = GetPortInfo(port_no);

    if (port_info != nullptr) {
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
    int core = {};

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
    float change = {};

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

void sndSetPortVol(int port_no, float vol);

float sndGetPortVol(int port);

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
    int stepped = {};

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
    int delay = {};

    for (delay = 0; delay < 10000; delay++) {
    }

    CSnd.Step();
}

void sndStep(float frames) {
    int           port_no = {};
    sndPortInfo  *info = {};
    sndCSeSeq    *player = {};
    sndPortSeSeq *entry = {};
    int           i = {};

    for (port_no = 0; port_no < 16; port_no++) {
        info = GetPortInfo(port_no);

        if (info != nullptr) {
            for (i = 0; i < 16; i++) {
                entry = &info->seseq[i];

                if (entry->seseq_no >= 0) {
                    player = GetSeSeq(entry->seseq_no);

                    if (player != nullptr && player->Step(frames) != 0) {
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
    sndPortInfo *info = {};

    if (port_no >= 0) {
        info = GetPortInfo(port_no);

        if (info != nullptr) {
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
    int port = {};

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
    std::optional<sndSeInfo> info;

    info = GetSeInfo(se_id, index);

    if (info) {
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

unsigned int sndLoadSound(int port_no, unsigned int *pack, mgCMemory *memory);

sndCSeSeqData::sndCSeSeqData() {
    Initialize();
}

void sndDeletePort(int port_no) {
    int volume = {};
    int driver_port = {};
    int sequence_port = {};

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
    sndPortInfo *info = {};
    sndBankInfo *bank_info = {};
    int          port_no = {};
    int          bank_no = {};

    port_no = GetPortNo(snd_id);
    bank_no = GetBankNo(snd_id);
    info = GetPortInfo(port_no);

    if (info == nullptr) {
        return 0;
    }

    bank_info = info->GetBank(bank_no);

    if (bank_info == nullptr) {
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
    int volume = {};
    int driver_pan = {};

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
    int volume = {};

    volume = (int) (vol * sndGetSeDefVol(snd_id, se_no));

    if (volume > 127) {
        volume = 127;
    }

    sndSePlayV(snd_id, se_no, volume, voice);
}

void sndSePause(unsigned int snd_id, int se_no) {
    sndPortInfo             *info = {};
    sndBankInfo             *bank = {};
    std::optional<sndSeInfo> se;
    int                      port_no = {};
    int                      bank_no = {};

    if (snd_id == (unsigned int) -1) {
        return;
    }

    port_no = GetPortNo(snd_id);
    bank_no = GetBankNo(snd_id);
    info = GetPortInfo(port_no);

    if (info == nullptr) {
        return;
    }

    bank = info->GetBank(bank_no);

    if (bank == nullptr) {
        return;
    }

    se = bank->GetSe(se_no);

    if (se && se->type == SND_SE_TYPE_SQ && info->sq_state == SND_SQ_STATE_PLAY) {
        sndSqStop(info->sq_port, se->prog);
        info->sq_state = SND_SQ_STATE_PAUSE;
    }
}

int sndGetSeStatus(unsigned int snd_id, int se_no) {
    sndPortInfo             *info = {};
    sndBankInfo             *bank = {};
    std::optional<sndSeInfo> se;
    int                      port_no = {};
    int                      bank_no = {};

    if (snd_id == (unsigned int) -1) {
        return -1;
    }

    port_no = GetPortNo(snd_id);
    bank_no = GetBankNo(snd_id);
    info = GetPortInfo(port_no);

    if (info == nullptr) {
        return -1;
    }

    bank = info->GetBank(bank_no);

    if (bank == nullptr) {
        return -1;
    }

    se = bank->GetSe(se_no);

    if (!se) {
        return -1;
    }

    if (se->type != SND_SE_TYPE_SQ) {
        return -1;
    }

    return info->sq_state;
}

void sndPortSqPause(int port) {
    sndPortInfo *info = {};

    info = GetPortInfo(port);

    if ((info != nullptr) && (info->sq_state == 1)) {
        sndSqStop(info->sq_port, info->sq_no);
        info->sq_state = 3;
    }
}

void sndPortSqReplay(int port) {
    sndPortInfo *info = {};

    info = GetPortInfo(port);

    if ((info != nullptr) && (info->sq_state == 3)) {
        sndSqRePlay(info->sq_port, info->sq_no);
        sndSetSqVol(info->sq_port, info->sq_no, info->sq_vol);
        info->sq_state = 1;
    }
}

int sndSeCheck(unsigned int snd_id, int se_no) {
    sndPortInfo             *info = {};
    sndBankInfo             *bank = {};
    std::optional<sndSeInfo> se;
    int                      port_no = {};
    int                      bank_no = {};

    if (snd_id == (unsigned int) -1) {
        return 0;
    }

    port_no = GetPortNo(snd_id);
    bank_no = GetBankNo(snd_id);
    info = GetPortInfo(port_no);

    if (info == nullptr) {
        return 0;
    }

    bank = info->GetBank(bank_no);

    if (bank == nullptr) {
        return 0;
    }

    se = bank->GetSe(se_no);

    if (!se) {
        return 0;
    }

    return 1;
}

void sndSePlaySeID(unsigned int snd_id, int se_no, int velocity, int vol, int pan, int pitch, int voice) {
    int                          port_no = {};
    int                          bank_no = {};
    sndPortInfo                 *info = {};
    sndBankInfo                 *bank = {};
    std::optional<sndSeInfo>     se;
    sndPortSeSeq                *entry = {};
    std::optional<sndCSeSeqData> data;

    if (snd_id == (unsigned int) -1) {
        return;
    }

    port_no = GetPortNo(snd_id);
    bank_no = GetBankNo(snd_id);
    info = GetPortInfo(port_no);

    if (info == nullptr) {
        return;
    }

    bank = info->GetBank(bank_no);

    if (bank == nullptr) {
        return;
    }

    se = bank->GetSe(se_no);

    if (!se) {
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

        if (entry != nullptr && data.has_value()) {
            entry->seseq_no = PlaySeSeq(snd_id, *data, vol);

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
    int                      port_no = {};
    int                      bank_no = {};
    sndPortInfo             *info = {};
    sndBankInfo             *bank = {};
    std::optional<sndSeInfo> se;
    sndPortSeSeq            *entry = {};

    if (snd_id == (unsigned int) -1) {
        return;
    }

    port_no = GetPortNo(snd_id);
    bank_no = GetBankNo(snd_id);
    info = GetPortInfo(port_no);

    if (info == nullptr) {
        return;
    }

    bank = info->GetBank(bank_no);

    if (bank == nullptr) {
        return;
    }

    se = bank->GetSe(se_no);

    if (!se) {
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

        if (entry != nullptr) {
            StopSeSeq(entry->seseq_no);
        }
    }
}

void sndSetSeVol(unsigned int snd_id, int se_no, int vol, int voice) {
    int                      port_no = {};
    int                      bank_no = {};
    sndPortInfo             *info = {};
    sndBankInfo             *bank = {};
    std::optional<sndSeInfo> se;
    sndPortSeSeq            *entry = {};

    if (snd_id == (unsigned int) -1) {
        return;
    }

    port_no = GetPortNo(snd_id);
    bank_no = GetBankNo(snd_id);
    info = GetPortInfo(port_no);

    if (info == nullptr) {
        return;
    }

    bank = info->GetBank(bank_no);

    if (bank == nullptr) {
        return;
    }

    se = bank->GetSe(se_no);

    if (!se) {
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

        if (entry != nullptr) {
            SetVolSeSeq(entry->seseq_no, vol);
        }
    }
}

void sndSetSePan(unsigned int snd_id, int se_no, int pan, int voice) {
    sndPortInfo             *info = {};
    sndBankInfo             *bank = {};
    std::optional<sndSeInfo> se;
    int                      port_no = {};
    int                      bank_no = {};

    if (snd_id == (unsigned int) -1) {
        return;
    }

    port_no = GetPortNo(snd_id);
    bank_no = GetBankNo(snd_id);
    info = GetPortInfo(port_no);

    if (info == nullptr) {
        return;
    }

    bank = info->GetBank(bank_no);

    if (bank == nullptr) {
        return;
    }

    se = bank->GetSe(se_no);

    if (!se) {
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
    int volume = {};

    volume = (int) (vol * sndGetSeDefVol(snd_id, se_no));

    if (volume > 127) {
        volume = 127;
    }

    sndSetSeVol(snd_id, se_no, volume, voice);
}

void sndSetSePanf(unsigned int snd_id, int se_no, float pan, int voice) {
    int driver_pan = {};

    driver_pan = (int) (64.0f * pan) + 64;

    if (driver_pan < 0) {
        driver_pan = 0;
    }

    if (driver_pan > 127) {
        driver_pan = 127;
    }

    sndSetSePan(snd_id, se_no, driver_pan, voice);
}

void sndSetSePitch(unsigned int snd_id, int se_no, int pitch, int voice) {
    sndPortInfo             *info = {};
    sndBankInfo             *bank = {};
    std::optional<sndSeInfo> se;
    int                      port_no = {};
    int                      bank_no = {};

    if (snd_id == (unsigned int) -1) {
        return;
    }

    port_no = GetPortNo(snd_id);
    bank_no = GetBankNo(snd_id);
    info = GetPortInfo(port_no);

    if (info == nullptr) {
        return;
    }

    bank = info->GetBank(bank_no);

    if (bank == nullptr) {
        return;
    }

    se = bank->GetSe(se_no);

    if (!se) {
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
    float         distance = {};
    float         volume = {};
    float         projection = {};
    float         panning = {};
    float         boost = {};
    int           sign = {};

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
    int port = {};
    int bank = {};

    if (snd_id != (unsigned int) -1 && GetPortBankNo(snd_id, &port, &bank) != 0) {
        sndSePlayPBPrKr(port, bank, prog, key, velocity, vol, pan, pitch, voice);
    }
}

void sndSeStopPrKr(unsigned int snd_id, int prog, int key, int voice) {
    int port = {};
    int bank = {};

    if (snd_id != (unsigned int) -1 && GetPortBankNo(snd_id, &port, &bank) != 0) {
        sndSeStopPBPrKr(port, bank, prog, key, voice);
    }
}

void sndSetSeVolPrKr(unsigned int snd_id, int prog, int key, int vol, int voice) {
    int port = {};
    int bank = {};

    if (snd_id != (unsigned int) -1 && GetPortBankNo(snd_id, &port, &bank) != 0) {
        sndSetSeVolPBPrKr(port, bank, prog, key, vol, voice);
    }
}

void sndSetSePanPrKr(unsigned int snd_id, int prog, int key, int pan, int voice) {
    int port = {};
    int bank = {};

    if (snd_id != (unsigned int) -1 && GetPortBankNo(snd_id, &port, &bank) != 0) {
        sndSetSePanPBPrKr(port, bank, prog, key, pan, voice);
    }
}

void sndSetSePitchPrKr(unsigned int snd_id, int prog, int key, int pitch, int voice) {
    int port = {};
    int bank = {};

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

int sndBankInfo::SearchSeq(std::string_view name, int &index) {
    index = 0;
    if (name.empty()) {
        return SND_SE_TYPE_NONE;
    }
    if (name == "KeyOn") {
        return SND_SE_TYPE_KEYON;
    }
    const auto equal_name = [name](const dc2::memory::ArenaText &candidate) {
        const auto text = candidate.Text();
        return text && std::ranges::equal(name, *text, [](char left, char right) {
                   return std::tolower(static_cast<unsigned char>(left)) == std::tolower(static_cast<unsigned char>(right));
               });
    };
    const auto names = sq_name_storage.Bytes();
    if (sq_num < 0 || static_cast<std::size_t>(sq_num) > names.size() / sizeof(dc2::memory::ArenaText) ||
        (sq_num > 0 && names.data() != reinterpret_cast<const u8 *>(sq_name))) {
        return SND_SE_TYPE_NONE;
    }
    for (int entry = 0; entry < sq_num; ++entry) {
        if (equal_name(sq_name[entry])) {
            index = entry;
            return SND_SE_TYPE_SQ;
        }
    }
    const auto effects = seseq_storage.Bytes();
    if (seseq_num < 0 || static_cast<std::size_t>(seseq_num) > effects.size() / sizeof(sndCSeSeqData) ||
        (seseq_num > 0 && effects.data() != reinterpret_cast<const u8 *>(seseq))) {
        return SND_SE_TYPE_NONE;
    }
    for (int entry = 0; entry < seseq_num; ++entry) {
        if (equal_name(seseq[entry].name)) {
            index = entry;
            return SND_SE_TYPE_SESEQ;
        }
    }
    return name.find('.') == std::string_view::npos ? SND_SE_TYPE_KEYON : SND_SE_TYPE_NONE;
}

sndSeInfo::sndSeInfo() {
    this->unk_0 = 0;
    this->type = 0;
}

void sndStopSeSeq(int port_no) {
    sndPortInfo *info = {};
    sndCSeSeq   *player = {};
    int          port = {};
    int          player_index = {};

    info = GetPortInfo(port_no);

    if (info != nullptr) {
        port = info->port;

        for (player_index = 0; player_index < 32; player_index++) {
            player = &SeSequencer[player_index];

            if (dc2::audio::SequencePlaying(*player) && port == player->port) {
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
static int PlaySeSeq(unsigned int snd_id, const sndCSeSeqData &data, int vol) {
    sndCSeSeq   *player = {};
    sndPortInfo *info = {};
    int          index = {};
    int          port_no = {};
    int          bank_no = {};

    player = GetEmptySeSeq(&index);

    if (player == nullptr) {
        return -1;
    }

    if (snd_id == (unsigned int) -1) {
        return -1;
    }

    port_no = GetPortNo(snd_id);
    bank_no = GetBankNo(snd_id);
    info = GetPortInfo(port_no);

    if (info == nullptr) {
        return -1;
    }

    if (vol < 0) {
        vol = 127;
    }

    if (!dc2::audio::StartSequence(*player, dc2::audio::SequenceEvents(data), data.tick_rate)) {
        return -1;
    }
    player->SetSeID((index * 8) % 256);
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
    sndCSeSeq *seq = {};

    seq = GetSeSeq(seq_id);

    if (seq != nullptr) {
        seq->Stop();
    }
}

/**
 *
 * Sets the volume of a sound-effect sequence player.
 *
 */
static void SetVolSeSeq(int index, int vol) {
    sndCSeSeq *player = {};

    player = GetSeSeq(index);

    if (vol < 0) {
        vol = 127;
    }

    if (player != nullptr) {
        player->vol = vol;
    }
}

void sndStreamOpenFast(char *name) {
    sndWaitSema();
    CSnd.StreamOpenFast(1, name);
    sndSignalSema();
}

int sndStreamOpenState() {
    int state = {};

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
    int left_vol = {};
    int right_vol = {};

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
    int state = {};

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

extern sndPortInfo PortInfo[SND_PORT_NUM];

namespace {

bool  host_initialized = false;
float host_port_volume[SND_PORT_NUM] = {};

sndPortInfo *HostGetPortInfo(int port) {
    if (port < 0 || port >= SND_PORT_NUM) {
        return nullptr;
    }

    return &PortInfo[port];
}

int HostGetDriverPort(int port_no, int *port, int *sq_port, int *vol) {
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
        case SND_PORT_ENV:
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
        case SND_PORT_CHARA:
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
        case SND_PORT_BATTLE:
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

// The SPU2 core whose reverb a driver port's sound config sets, or -1.
int ReverbCore(int port) {
    switch (port) {
        case 0:
            return 0;
        case 7:
            return 1;
        default:
            return -1;
    }
}

} // namespace

// The game's threads are cooperative fibers on one OS thread and nothing inside these sections yields,
// so there is nothing for a semaphore to guard.
void sndWaitSema() {}

void sndSignalSema() {}

void sndInitMngr() {
    if (host_initialized) {
        CSnd.Exit();
        host_initialized = false;
    }

    CSnd.Init(4, 0, 40, 0);
    sndSetMasterVol(0, 1.0f);
    sndSetMasterVol(1, 1.0f);
    host_initialized = true;

    for (int port = 0; port < 16; port++) {
        sndInitPort(port);
        host_port_volume[port] = 0.0f;
    }
}

void sndSetPortVol(int port_no, float vol) {
    sndPortInfo *info = nullptr;
    int          driver_vol = 0;

    info = HostGetPortInfo(port_no);

    if (info == nullptr || info->port < 0 || info->port >= 16 || !std::isfinite(vol)) {
        return;
    }

    vol = std::max(vol, 0.0f);

    vol = std::min(vol, 1.0f);

    host_port_volume[port_no] = vol;
    driver_vol = static_cast<int>(127.0f * vol);

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

    return host_port_volume[port];
}

unsigned SoundLoadBundleData(int port_no, std::span<const std::byte> bytes, mgCMemory *memory) {
    auto *info = HostGetPortInfo(port_no);
    if (!info || !memory || memory->lock != 0 || bytes.empty()) {
        return -1;
    }
    try {
        const auto root = nlohmann::json::parse(reinterpret_cast<const char *>(bytes.data()), reinterpret_cast<const char *>(bytes.data() + bytes.size()));
        if (root.at("schema_version") != 1 || root.at("kind") != "sound_bundle") {
            return -1;
        }
        auto read = [&](const nlohmann::json &uri, std::string_view kind) {
            for (const auto &text : AudioDocuments(uri.get<std::string>())) {
                try {
                    const auto doc = nlohmann::json::parse(text);
                    if (doc.at("schema_version") != 1 || doc.at("kind") != kind) {
                        continue;
                    }
                    if (kind == "sequence") {
                        if (!audio::SqFile::CreateFromJson(text)) {
                            continue;
                        }
                    } else if (kind == "effect_sequence") {
                        if (native_config::Int(doc.at("tick_rate")) <= 0 || !doc.at("events").is_array() || doc.at("events").size() > 1048576) {
                            continue;
                        }
                        for (const auto &e : doc.at("events")) {
                            const auto delta = native_config::Int(e.at("delta"));
                            const auto status = native_config::Int(e.at("status"));
                            const auto first = native_config::Int(e.at("data").at(0));
                            const auto second = native_config::Int(e.at("data").at(1));
                            if (delta < 0 || delta > SHRT_MAX || status < 0 || status > UCHAR_MAX ||
                                first < 0 || first > SCHAR_MAX || second < 0 || second > SCHAR_MAX) {
                                throw std::runtime_error("invalid sound effect event fields");
                            }
                        }
                    } else {
                        if (!doc.at("entries").is_array() || !doc.at("reverb").is_array()) {
                            continue;
                        }
                        if (kind == "sound_config") {
                            const auto count = native_config::Int(doc.at("entry_count"));
                            if (count < 0 || count > 1048576 || doc.at("entries").size() > static_cast<std::size_t>(count)) {
                                continue;
                            }
                            for (const auto &e : doc.at("entries")) {
                                (void) e.at("filename").get<std::string>();
                                if (!std::in_range<s8>(native_config::Int(e.at("program"))) ||
                                    !std::in_range<s8>(native_config::Int(e.at("key")))) {
                                    throw std::runtime_error("invalid sound config byte field");
                                }
                                (void) e.at("flag").get<bool>();
                            }
                        } else {
                            for (const auto &e : doc.at("entries")) {
                                (void) native_config::Int(e.at("index"));
                                (void) native_config::Int(e.at("volume"));
                            }
                        }
                        for (const auto &r : doc.at("reverb")) {
                            (void) native_config::Int(r.at("type"));
                            (void) native_config::Int(r.at("depth"));
                        }
                    }
                    return text;
                } catch (const std::exception &) {
                }
            }
            throw std::runtime_error("sound dependency missing or invalid");
        };
        const auto                                       config = read(root.at("config"), "sound_config");
        const auto                                       volume = read(root.at("volume"), "sound_volume");
        std::vector<std::pair<std::string, std::string>> sequences;
        std::vector<std::pair<std::string, std::string>> effects;
        for (const auto &uri : root.at("sequences")) {
            sequences.emplace_back(uri.get<std::string>(), read(uri, "sequence"));
        }
        for (const auto &uri : root.at("effect_sequences")) {
            effects.emplace_back(uri.get<std::string>(), read(uri, "effect_sequence"));
        }
        if (sequences.size() > 32 || effects.size() > 48 || info->bank_num > 15) {
            return -1;
        }
        int initial_vol = -1;
        if (!HostGetDriverPort(port_no, &info->port, &info->sq_port, &initial_vol)) {
            return -1;
        }
        const auto sequence_quads = info->sq_port >= 0 && !sequences.empty()
                                        ? dc2::memory::ArrayQuadwords<dc2::memory::ArenaText>(sequences.size())
                                        : std::optional<int>(0);
        const auto effect_quads = !effects.empty()
                                      ? dc2::memory::ArrayQuadwords<sndCSeSeqData>(effects.size())
                                      : std::optional<int>(0);
        if (config.size() > static_cast<std::size_t>(std::numeric_limits<int>::max()) ||
            volume.size() > static_cast<std::size_t>(std::numeric_limits<int>::max())) {
            return -1;
        }
        const auto  available = dc2::memory::RemainingBytes(*memory).size() / sizeof(u_long128);
        std::size_t required = 0;
        const auto  add = [&](std::optional<int> quadwords) {
            if (!quadwords || static_cast<std::size_t>(*quadwords) >= available - required) {
                return false;
            }
            required += static_cast<std::size_t>(*quadwords);
            return true;
        };
        if (!add(sequence_quads) || !add(effect_quads)) {
            return -1;
        }
        for (const auto &[name, document] : effects) {
            if (document.size() > static_cast<std::size_t>(std::numeric_limits<int>::max())) {
                return -1;
            }
            const auto events = nlohmann::json::parse(document).at("events").size();
            if (events == std::numeric_limits<std::size_t>::max() ||
                !add(dc2::memory::ArrayQuadwords<sndSeSeqEvent>(events + 1))) {
                return -1;
            }
        }
        const int config_count = native_config::Int(nlohmann::json::parse(config).at("entry_count"));
        if (config_count < 0 || (config_count > 0 &&
                                 !add(dc2::memory::ArrayQuadwords<sndSeInfo>(static_cast<std::size_t>(config_count))))) {
            return -1;
        }
        const int bank_no = info->bank_num;
        if (!root.at("bank").is_null()) {
            bool loaded = false;
            for (const auto &text : AudioDocuments(root.at("bank").get<std::string>())) {
                if (SoundLoadBankJson(info->port, text, bank_no != 0) == 0) {
                    loaded = true;
                    break;
                }
            }
            if (!loaded) {
                return -1;
            }
        }
        sndBankInfo pending_bank;
        auto       *bank = &pending_bank;
        if (info->sq_port >= 0) {
            bank->sq_name = !sequences.empty()
                                ? dc2::memory::NewArray<dc2::memory::ArenaText>(*memory, sequences.size())
                                : nullptr;
            if (!sequences.empty() && bank->sq_name == nullptr) {
                return -1;
            }
            bank->sq_num = static_cast<int>(sequences.size());
            if (!sequences.empty()) {
                bank->sq_name_storage = dc2::memory::ArenaBuffer::Bind(*memory,
                                                                       {reinterpret_cast<u8 *>(bank->sq_name), sequences.size() * sizeof(dc2::memory::ArenaText)});
            }
            for (std::size_t i = 0; i < sequences.size(); ++i) {
                if (SoundLoadSequenceJson(info->sq_port, sequences[i].second, sequences[i].first.c_str()) != 0) {
                    return -1;
                }
                bank->sq_name[i] = dc2::memory::ArenaText::Copy(
                    bank->sq_name_storage.Subspan(i * sizeof(dc2::memory::ArenaText), sizeof(dc2::memory::ArenaText)),
                    sequences[i].first);
                if (!bank->sq_name[i].Text()) {
                    return -1;
                }
            }
        }
        bank->seseq = !effects.empty()
                          ? dc2::memory::NewArray<sndCSeSeqData>(*memory, effects.size())
                          : nullptr;
        if (!effects.empty() && bank->seseq == nullptr) {
            return -1;
        }
        bank->seseq_num = static_cast<int>(effects.size());
        if (!effects.empty()) {
            bank->seseq_storage = dc2::memory::ArenaBuffer::Bind(*memory,
                                                                 {reinterpret_cast<u8 *>(bank->seseq), effects.size() * sizeof(sndCSeSeqData)});
        }
        for (std::size_t i = 0; i < effects.size(); ++i) {
            bank->seseq[i].name = dc2::memory::ArenaText::Copy(
                bank->seseq_storage.Subspan(i * sizeof(sndCSeSeqData), sizeof(sndCSeSeqData)), effects[i].first);
            if (!bank->seseq[i].name.Text()) {
                return -1;
            }
            bank->seseq[i].LoadSMF(effects[i].second, memory);
            if (dc2::audio::SequenceEvents(bank->seseq[i]).empty()) {
                return -1;
            }
        }
        info->bank[bank_no] = pending_bank;
        ++info->bank_num;
        if (initial_vol >= 0) {
            CSnd.SetVol(info->port, initial_vol);
            host_port_volume[port_no] = 1.0f;
        }
        info->LoadSeInfoTxt(bank_no, config, memory);
        info->LoadVolInfoTxt(bank_no, volume);
        CT_LOG_TRACE(Audio, "sound bundle: port {} bank {} loaded ({} sequences, {} effects)", port_no, bank_no, sequences.size(),
                     effects.size());
        return ((port_no & 255) << 24) | ((bank_no & 255) << 16);
    } catch (const std::exception &error) {
        CT_LOG_ERROR(Audio, "sound bundle: {}", error.what());
        return -1;
    }
}

unsigned SoundLoadBundlePath(int port_no, std::string_view path, mgCMemory *memory) {
    for (const auto &document : AudioDocuments(path)) {
        const auto result = SoundLoadBundleData(port_no, std::as_bytes(std::span(document.data(), document.size())), memory);
        if (result != static_cast<unsigned>(-1)) {
            return result;
        }
    }
    return -1;
}

unsigned int sndLoadSound(int port_no, unsigned int *document, mgCMemory *memory) {
    if (const auto path = DataReadBufferPath(document)) {
        return SoundLoadBundlePath(port_no, *path, memory);
    }
    return SoundLoadBundleData(port_no, {reinterpret_cast<const std::byte *>(document), DataReadBufferSize(document)}, memory);
}

void sndPortInfo::LoadSeInfoTxt(int bank_no, std::string_view document, mgCMemory *memory) {
    auto *bank_info = GetBank(bank_no);
    if (!bank_info) {
        return;
    }
    if (!document.empty()) {
        try {
            const auto root = nlohmann::json::parse(document);
            if (root.at("schema_version") != 1 || root.at("kind") != "sound_config") {
                return;
            }
            const int raw_count = native_config::Int(root.at("entry_count"));
            if (raw_count < 0) {
                return;
            }
            const auto count = static_cast<std::size_t>(raw_count);
            if (count > 1048576 || root.at("entries").size() > count) {
                return;
            }
            if (memory == nullptr || memory->lock != 0) {
                return;
            }
            const auto quadwords = count > 0 ? dc2::memory::ArrayQuadwords<sndSeInfo>(count)
                                             : std::optional<int>(0);
            if (!quadwords || static_cast<std::size_t>(*quadwords) >=
                                  dc2::memory::RemainingBytes(*memory).size() / sizeof(u_long128)) {
                return;
            }
            std::vector<sndSeInfo>           effects;
            std::vector<std::pair<int, int>> reverbs;
            for (const auto &r : root.at("reverb")) {
                reverbs.emplace_back(native_config::Int(r.at("type")), native_config::Int(r.at("depth")));
            }
            for (const auto &e : root.at("entries")) {
                auto      filename = e.at("filename").get<std::string>();
                sndSeInfo effect;
                std::memset(&effect, 0, sizeof(effect));
                int sequence_index = 0;
                effect.type = static_cast<s8>(bank_info->SearchSeq(filename, sequence_index));
                const int program = native_config::Int(e.at("program"));
                const int key = native_config::Int(e.at("key"));
                if (!std::in_range<s8>(program) || !std::in_range<s8>(key)) {
                    return;
                }
                effect.prog = static_cast<s8>(program);
                if (effect.type == SND_SE_TYPE_SQ || effect.type == SND_SE_TYPE_SESEQ) {
                    effect.prog = static_cast<s8>(sequence_index);
                }
                effect.key = static_cast<s8>(key);
                effect.unk_7 = e.at("flag").get<bool>();
                effect.def_vol = 64;
                effects.push_back(effect);
            }
            auto *entries = count > 0 ? dc2::memory::NewArray<sndSeInfo>(*memory, count) : nullptr;
            if (count > 0 && entries == nullptr) {
                return;
            }
            if (count > 0) {
                std::memset(entries, 0, count * sizeof(sndSeInfo));
                std::ranges::copy(effects, entries);
            }
            bank_info->se_storage = count > 0 ? dc2::memory::ArenaBuffer::Bind(*memory,
                                                                               {reinterpret_cast<u8 *>(entries), count * sizeof(sndSeInfo)})
                                              : dc2::memory::ArenaBuffer{};
            bank_info->se = entries;
            bank_info->se_num = static_cast<int>(count);
            const int core = ReverbCore(port);
            if (core >= 0) {
                for (const auto &[type, depth] : reverbs) {
                    CSnd.SetReverb(core, type, depth);
                }
            }
            return;
        } catch (const std::exception &) {
        }
    }
    CT_LOG_ERROR(Audio, "sound: missing or invalid sound config JSON");
}

void sndPortInfo::LoadVolInfoTxt(int bank_no, std::string_view document) {
    auto *bank_info = GetBank(bank_no);
    if (!bank_info) {
        return;
    }
    if (!document.empty()) {
        try {
            const auto root = nlohmann::json::parse(document);
            if (root.at("schema_version") != 1 || root.at("kind") != "sound_volume") {
                return;
            }
            std::vector<std::pair<int, int>> levels;
            std::vector<std::pair<int, int>> reverbs;
            for (const auto &e : root.at("entries")) {
                levels.emplace_back(native_config::Int(e.at("index")), native_config::Int(e.at("volume")));
            }
            for (const auto &r : root.at("reverb")) {
                reverbs.emplace_back(native_config::Int(r.at("type")), native_config::Int(r.at("depth")));
            }
            for (const auto &[index, volume] : levels) {
                if (bank_info->GetSe(index)) {
                    bank_info->se[index].def_vol = static_cast<s8>(volume);
                }
            }
            const int core = ReverbCore(port);
            if (core >= 0) {
                for (const auto &[type, depth] : reverbs) {
                    sndSetReverb(core, type, depth);
                }
            }
            return;
        } catch (const std::exception &) {
        }
    }
    CT_LOG_ERROR(Audio, "sound: missing or invalid volume JSON");
}
