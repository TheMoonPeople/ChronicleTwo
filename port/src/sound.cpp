#include "common.h"

#include <algorithm>
#include <array>
#include <bitset>
#include <cstddef>
#include <cstdint>
#include <cstdio>
#include <memory>
#include <span>
#include <vector>

#include "audio/hdbank.hpp"
#include "audio/mixer.hpp"
#include "audio/soundtrack.hpp"
#include "audio/sq.hpp"
#include "audio/trace.hpp"
#include "controller_speaker.hpp"
#include "ezbgm.hpp"
#include "ezmidi.hpp"
#include "platform/config.hpp"
#include "platform/settings.hpp"
#include "snd_mngr.hpp"
#include "sound.hpp"
#include "sound_port.hpp"

extern sndPortInfo PortInfo[SND_PORT_NUM];

namespace {

constexpr int kMaxReverbDepth = 127;
constexpr int kMasterVolFull = 0x3FFF;

struct QueuedMessage {
    int                         port;
    bool                        hs;
    std::uint32_t               word;
    std::array<std::uint8_t, 7> bytes;
};

struct PortState {
    std::array<std::shared_ptr<const audio::Bank>, MIDI_PORT_BANK_MAX> bank{};
    int                                                               bank_count = 0;
    std::vector<std::shared_ptr<const audio::SqFile>>                 sequence;
    std::vector<std::string>                                           sequence_name;
    std::shared_ptr<const audio::SqFile>                              resident_sequence;
    int                                                               linked_port = -1;
    std::vector<int>                                                  dependent_port;
    int                                                               ezmidi_param = 0;
    MIDI_FADE                                                         fade[2] = {};
};

struct PortLayout {
    int                  port;
    int                  linked_port;
    int                  ezmidi_param;
    std::span<const int> dependents;
};

constexpr int kDependentsOf1[] = {15, 2, 14};
constexpr int kDependentsOf8[] = {1, 15, 2, 14};
constexpr int kDependentsOf10[] = {8, 1, 15, 2, 14};
constexpr int kDependentsOf15[] = {2, 14};

constexpr PortLayout kLayout[] = {
    {0, -1, 0x3040, {}},
    {1, -1, 0x3032, kDependentsOf1},
    {2, 14, 0x3039, {}},
    {3, -1, 0x3040, {}},
    {7, -1, 0x3010, {}},
    {8, -1, 0x3035, kDependentsOf8},
    {9, -1, 0x3038, {}},
    {10, -1, 0x3037, kDependentsOf10},
    {11, -1, 0x3033, {}},
    {12, -1, 0x3034, {}},
    {13, -1, 0x3036, {}},
    {14, 2, 0x3039, {}},
    {15, -1, 0x3031, kDependentsOf15},
};

std::array<PortState, MIDI_PORT_COUNT> ports;
std::vector<QueuedMessage>             queued;
bool                                   initialised = false;

// Sound effect ids, per driver port, whose key-ons play on the controller speaker.
using SpeakerIds = std::array<std::bitset<128>, MIDI_PORT_COUNT>;

SpeakerIds speaker_ids;

std::span<const std::uint8_t> AsBytes(const void *data, int size) {
    if (data == nullptr || size <= 0) {
        return {};
    }

    return {static_cast<const std::uint8_t *>(data), static_cast<std::size_t>(size)};
}

std::array<std::uint8_t, 7> HsBytes(std::uint8_t status, std::uint8_t sub, int a, int b, int c, int d) {
    return {status, sub, 0, static_cast<std::uint8_t>(a), static_cast<std::uint8_t>(b), static_cast<std::uint8_t>(c), static_cast<std::uint8_t>(d)};
}

void ResetHostState() {
    ports = {};
    queued.clear();

    for (const PortLayout &layout : kLayout) {
        PortState &state = ports[layout.port];
        state.linked_port = layout.linked_port;
        state.ezmidi_param = layout.ezmidi_param;
        state.dependent_port.assign(layout.dependents.begin(), layout.dependents.end());
    }
}

void DropQueued(int port) {
    std::erase_if(queued, [port](const QueuedMessage &message) { return message.port == port; });
}

void QueueShort(int port, std::uint32_t word) {
    queued.push_back({port, false, word, {}});
}

void QueueHs(int port, const std::array<std::uint8_t, 7> &bytes) {
    queued.push_back({port, true, 0, bytes});
}

void QueueBankProgram(int port, int bank, int program) {
    QueueShort(port, static_cast<std::uint32_t>(((bank & 0x7F) << 16) | 0xB0));
    QueueShort(port, static_cast<std::uint32_t>(((program & 0x7F) << 8) | 0xC0));
}

bool ValidSeId(int port, int id) {
    if (id > 0x7E) {
        audio::Trace("SE_ID ERR PORT=%d ID=%d", port, id);
        return false;
    }

    return true;
}

void ApplyReverb(int core, int mode, int depth) {
    audio::Mixer &mixer = audio::DefaultMixer();

    // Retail shifts depth into a 16-bit effect volume, so only 0..127 is meaningful.
    mixer.SetReverb(core, mode, std::clamp(depth, 0, kMaxReverbDepth));
    mixer.SetReverbEnabled(true);

    // Retail rewrites the core's master volume to full in the same setup.
    mixer.SetCoreVolume(core, 1.0f);
}

void DropBankSlots(audio::Mixer &mixer, int port) {
    for (int bank_no = 1; bank_no < MIDI_PORT_BANK_MAX; bank_no++) {
        mixer.BindBank(port, bank_no, nullptr);
    }
}

void LoadFirstBank(audio::Mixer &mixer, int port, const std::shared_ptr<const audio::Bank> &bank) {
    PortState &state = ports[port];

    DropQueued(port);
    mixer.Stop(port);
    DropBankSlots(mixer, port);
    mixer.BindBank(port, bank);
    state.bank.fill(nullptr);
    state.bank[0] = bank;
    state.bank_count = 1;
}

void ReleaseSequences(audio::Mixer &mixer, int port) {
    PortState &state = ports[port];

    if (!state.sequence.empty()) {
        mixer.SetSequence(port, state.resident_sequence);
    }

    state.sequence.clear();
    state.sequence_name.clear();
}

void RejectIntAddress(const char *function) {
    std::fprintf(stderr, "%s takes its bank or sequence address as int; the host loads through SoundLoad*\n", function);
}

// The treasure chests' opening (wood, iron and stone) is a sound-effect sequence of every base bank.
constexpr int kChestSeFirst = 110;
constexpr int kChestSeLast = 112;

// The ids the chest sequences playing now key their effects on: a sequence player keys its eight
// tracks on ids from eight times its number up (PlaySeSeq's SetSeID).
SpeakerIds ChestSpeakerIds() {
    SpeakerIds         ids{};
    const sndPortInfo &info = PortInfo[SND_PORT_BASE];

    if (!ConfigGet().dualsense_speaker || info.port < 0 || info.port >= MIDI_PORT_COUNT) {
        return ids;
    }

    for (const sndPortSeSeq &entry : info.seseq) {
        if (entry.seseq_no < 0 || entry.se_no < kChestSeFirst || entry.se_no > kChestSeLast) {
            continue;
        }

        for (int track = 0; track < 8; track++) {
            const int id = (entry.seseq_no * 8) % 256 + track;

            if (id < 128) {
                ids[info.port].set(id);
            }
        }
    }

    return ids;
}

// Gives the speaker's mixer a port's banks the first time an effect of it plays there, and its
// volumes every step, so the effect sounds as it would on the TV.
void MirrorSpeakerPort(int port, bool bind) {
    audio::Mixer &speaker = ControllerSpeakerMixer();
    audio::Mixer &mixer = audio::DefaultMixer();

    if (bind) {
        for (int bank_no = 0; bank_no < MIDI_PORT_BANK_MAX; bank_no++) {
            speaker.BindBank(port, bank_no, ports[port].bank[bank_no]);
        }
    }

    speaker.SetVolume(port, mixer.Volume(port));
    speaker.SetAttribute(port, mixer.Attribute(port));

    for (int core = 0; core < audio::kCores; core++) {
        speaker.SetCoreVolume(core, mixer.CoreVolume(core));
    }
}

// Sends the step's messages. Bank, program, volume and pan go to both mixers of a port with effects
// on the speaker; a key-on, key-off or change of one effect goes where its id plays. An id stays on
// the speaker for one more step after its sequence ends, for the key-offs of its last step.
void DispatchQueued() {
    SpeakerIds current = ChestSpeakerIds();
    bool       any = false;

    for (const std::bitset<128> &ids : current) {
        any = any || ids.any();
    }

    if (any && !ControllerSpeakerOpen()) {
        current = {};
    }

    audio::Mixer &mixer = audio::DefaultMixer();
    audio::Mixer &speaker = ControllerSpeakerMixer();
    SpeakerIds    routed;

    for (int port = 0; port < MIDI_PORT_COUNT; port++) {
        routed[port] = current[port] | speaker_ids[port];

        if (current[port].any()) {
            MirrorSpeakerPort(port, speaker_ids[port].none());
        }
    }

    for (const QueuedMessage &message : queued) {
        const bool split = routed[message.port].any();

        if (!message.hs) {
            mixer.ShortMessage(message.port, message.word);

            if (split) {
                speaker.ShortMessage(message.port, message.word);
            }

            continue;
        }

        if (split && message.bytes[0] == 0xFD) {
            (routed[message.port].test(message.bytes[4] & 0x7F) ? speaker : mixer).HsMessage(message.port, message.bytes);
            continue;
        }

        mixer.HsMessage(message.port, message.bytes);

        if (split) {
            speaker.HsMessage(message.port, message.bytes);
        }
    }

    queued.clear();
    speaker_ids = current;
}

} // namespace

void SoundApplySettings() {
    audio::DefaultMixer().SetMasterGain(SettingsGet().master_volume);
}

PORT_OVERRIDE void set_spu(int mode0, int mode1, int depth0, int depth1) {
    ApplyReverb(0, mode0, depth0);
    ApplyReverb(1, mode1, depth1);
}

PORT_OVERRIDE void CSound::StopVoice(int core) {
    audio::DefaultMixer().KeyOffCore(core);
}

PORT_OVERRIDE void CSound::SndInReverb(bool) {
    // Stream channels never enter the mixer's effect units, so the SPU input route has nothing to switch.
}

PORT_OVERRIDE void CSound::SetReverb(int core, int mode, int depth) {
    ApplyReverb(core, mode, depth);
}

PORT_OVERRIDE int CSound::Init(int mode0, int mode1, int depth0, int depth1) {
    if (initialised) {
        return 0;
    }

    ezBgmInit();
    ezMidiInit();
    audio::DefaultMixer().Reset();
    SoundApplySettings();
    set_spu(mode0, mode1, depth0, depth1);
    ResetHostState();
    initialised = true;
    return 0;
}

PORT_OVERRIDE int CSound::Exit() {
    audio::Mixer &mixer = audio::DefaultMixer();

    for (int port = 0; port < MIDI_PORT_COUNT; port++) {
        mixer.Stop(port);
    }

    mixer.Reset();
    ResetHostState();
    initialised = false;
    return 0;
}

PORT_OVERRIDE void CSound::DEL_PORT(int port) {
    audio::Mixer &mixer = audio::DefaultMixer();
    const int     linked = ports[port].linked_port;

    // Retail clears queued messages only for MSIn-range ports; ports below that have no MSIn buffer to clear.
    DropQueued(port);
    mixer.Stop(port);
    ReleaseSequences(mixer, port);

    if (linked >= 0) {
        DropQueued(linked);
        mixer.Stop(linked);
        ReleaseSequences(mixer, linked);
    }

    for (int dependent : ports[port].dependent_port) {
        DropQueued(dependent);
        mixer.Stop(dependent);
        ReleaseSequences(mixer, dependent);
    }
}

PORT_OVERRIDE void CSound::SQ_Play(int port, int seq_no, int volume) {
    PortState &state = ports[port];

    // Retail returns before stopping on a bad index, so the port keeps playing.
    if (seq_no < 0 || seq_no >= static_cast<int>(state.sequence.size())) {
        audio::Trace("SQ_Play PORT=%d SEQ_NO=%d not loaded", port, seq_no);
        return;
    }

    audio::Mixer &mixer = audio::DefaultMixer();
    mixer.Stop(port);
    mixer.SetSequence(port, state.sequence[seq_no]);
    // Resolve at playback, so choosing another soundtrack in Options applies to the next song,
    // including songs whose sequence data was already loaded. Missing recordings keep the PS2 song.
    if (seq_no < static_cast<int>(state.sequence_name.size()) && !state.sequence_name[seq_no].empty()) {
        mixer.SetPendingStream(port, audio::SoundtrackRequestFor(state.sequence_name[seq_no]));
    }

    if (volume != audio::kFullPortVolume) {
        volume = static_cast<int>(2.015748f * volume);
    }

    mixer.SetVolume(port, volume);
    mixer.Rewind(port, 0);
    mixer.Play(port);
}

PORT_OVERRIDE void CSound::SQ_RePlay(int port) {
    if (!ports[port].sequence.empty()) {
        audio::DefaultMixer().Play(port);
    }
}

PORT_OVERRIDE void CSound::SE_Play(int port, int bank, int program, int key, int pan, int velocity, int volume, int, int id) {
    if (!ValidSeId(port, id) || ports[port].bank_count <= 0) {
        return;
    }

    QueueBankProgram(port, bank, program);
    QueueHs(port, HsBytes(0xF9, 0, volume, 0, 0, 0));
    // Retail writes a pitch message into the same buffer and overwrites it before sending; no pitch is sent here.
    QueueHs(port, HsBytes(0xF9, 1, pan, 0, 0, 0));
    QueueHs(port, HsBytes(0xFD, 0x10, key, id, velocity, 0));
}

PORT_OVERRIDE void CSound::SE_SetVol(int port, int bank, int program, int key, int volume, int id) {
    if (!ValidSeId(port, id) || ports[port].bank_count <= 0) {
        return;
    }

    QueueBankProgram(port, bank, program);
    QueueHs(port, HsBytes(0xFD, 0, key, id, volume, 0));
}

PORT_OVERRIDE void CSound::SE_SetPan(int port, int bank, int program, int key, int pan, int id) {
    if (!ValidSeId(port, id) || ports[port].bank_count <= 0) {
        return;
    }

    QueueBankProgram(port, bank, program);
    QueueHs(port, HsBytes(0xFD, 1, key, id, pan, 0));
}

PORT_OVERRIDE void CSound::SE_Stop(int port, int bank, int program, int key, int id) {
    if (!ValidSeId(port, id) || ports[port].bank_count <= 0) {
        return;
    }

    QueueBankProgram(port, bank, program);
    QueueHs(port, HsBytes(0xFD, 0x10, key, id, 0, 0));
}

PORT_OVERRIDE void CSound::SE_SetPitch(int port, int bank, int program, int key, int pitch, int id) {
    if (!ValidSeId(port, id)) {
        return;
    }

    QueueBankProgram(port, bank, program);
    QueueHs(port, HsBytes(0xFD, 2, key, id, pitch & 0x7F, (pitch >> 7) & 0x7F));
}

PORT_OVERRIDE void CSound::Step() {
    for (int port = 0; port < MIDI_PORT_COUNT; port++) {
        MIDI_FADE &fade = ports[port].fade[0];

        if (fade.active == 0) {
            continue;
        }

        fade.volume += fade.step;

        if (!(fade.step <= 0.0f)) {
            if (!(fade.volume <= static_cast<float>(fade.target_volume))) {
                fade.volume = static_cast<float>(fade.target_volume);
                fade.active = 0;
            }
        }

        if (fade.step < 0.0f) {
            if (fade.volume < static_cast<float>(fade.target_volume)) {
                fade.volume = static_cast<float>(fade.target_volume);
                fade.active = 0;
            }
        }

        // Retail drives port 0's volume from every port's fade; kept as-is.
        SetVol(0, static_cast<int>(fade.volume));
    }

    DispatchQueued();
    EzBgmStep();
}

PORT_OVERRIDE void CSound::SetMasterVol(int core, int volume) {
    audio::DefaultMixer().SetCoreVolume(core, static_cast<float>(std::clamp(volume, 0, kMasterVolFull)) / kMasterVolFull);
}

PORT_OVERRIDE void CSound::LoadHdBd(int, int, int, int, int) {
    RejectIntAddress("CSound::LoadHdBd");
}

PORT_OVERRIDE void CSound::LoadHdBd2(int, int, int, int, int) {
    RejectIntAddress("CSound::LoadHdBd2");
}

PORT_OVERRIDE int CSound::LoadHdBdAdd(int, int, int, int, int) {
    RejectIntAddress("CSound::LoadHdBdAdd");
    return -1;
}

PORT_OVERRIDE int CSound::LoadSeq(int, int, int) {
    RejectIntAddress("CSound::LoadSeq");
    return -1;
}

PORT_OVERRIDE int TransHdBd(int, int, int, int) {
    RejectIntAddress("TransHdBd");
    return -1;
}

void SoundLoadHdBd(int port, const void *hd, int hd_size, const void *bd, int bd_size) {
    std::shared_ptr<audio::Bank> bank = audio::Bank::Create(AsBytes(hd, hd_size), AsBytes(bd, bd_size));

    if (!bank) {
        std::fprintf(stderr, "SoundLoadHdBd PORT=%d: bank header rejected\n", port);
        return;
    }

    audio::Mixer &mixer = audio::DefaultMixer();
    const int     linked = ports[port].linked_port;

    LoadFirstBank(mixer, port, bank);

    if (linked >= 0) {
        LoadFirstBank(mixer, linked, bank);
    }

    ReleaseSequences(mixer, port);

    if (linked >= 0) {
        ReleaseSequences(mixer, linked);
    }

    for (int dependent : ports[port].dependent_port) {
        mixer.Stop(dependent);
    }

    mixer.SetAttribute(port, ports[port].ezmidi_param);

    if (linked >= 0) {
        mixer.SetAttribute(linked, ports[linked].ezmidi_param);
    }
}

int SoundLoadHdBdAdd(int port, const void *hd, int hd_size, const void *bd, int bd_size) {
    PortState &state = ports[port];

    if (state.bank_count >= MIDI_PORT_BANK_MAX) {
        audio::Trace("Bank MAX OVER PORT=%d", port);
        return 0;
    }

    std::shared_ptr<audio::Bank> bank = audio::Bank::Create(AsBytes(hd, hd_size), AsBytes(bd, bd_size));

    if (!bank) {
        std::fprintf(stderr, "SoundLoadHdBdAdd PORT=%d: bank header rejected\n", port);
        return -1;
    }

    audio::Mixer &mixer = audio::DefaultMixer();
    const int     bank_no = state.bank_count;

    state.bank[bank_no] = bank;
    mixer.BindBank(port, bank_no, bank);

    if (state.linked_port >= 0) {
        PortState &linked = ports[state.linked_port];

        mixer.BindBank(state.linked_port, bank_no, bank);
        linked.bank[bank_no] = bank;
        linked.bank_count++;
    }

    state.bank_count++;
    return 0;
}

int SoundLoadSeq(int port, const void *sq, int size, const char *name) {
    audio::Mixer &mixer = audio::DefaultMixer();

    mixer.Stop(port);

    std::shared_ptr<audio::SqFile> file = audio::SqFile::Create(AsBytes(sq, size));

    if (!file) {
        std::fprintf(stderr, "SoundLoadSeq PORT=%d: sequence rejected\n", port);
        return -1;
    }

    PortState &state = ports[port];

    if (state.sequence.empty()) {
        state.resident_sequence = file;
        mixer.SetSequence(port, file);
    }

    state.sequence.push_back(file);
    state.sequence_name.emplace_back(name != nullptr ? name : "");

    if (state.sequence.size() > 15) {
        std::fprintf(stderr, "SEQ_MAX OVER PORT=%d\n", port);
    }

    return 0;
}

PORT_OVERRIDE void CSound::StreamOpenFast(int channel, char *name) {
    ezBgm(channel | 0x80, 0);
    EzBgmOpen(channel, name);
}

PORT_OVERRIDE void CSound::StreamOpenFromFPLFast(int channel, char *name, char *pack_name) {
    ezBgm(channel | 0x80, 0);
    EzBgmOpenFromPack(channel, name, pack_name);
}

PORT_OVERRIDE int CSound::TransBdState(int) {
    // Bank registration is synchronous on the host, so the transfer is always complete.
    return 1;
}
