#include "common.h"
#include "mw_runtime.h"

#include <nlohmann/json.hpp>

#include <algorithm>
#include <climits>
#include <cmath>
#include <cstdint>
#include <limits>
#include <string_view>
#include <vector>

#include "assets/data_registry.hpp"
#include "log/log.hpp"
#include "mg_memory.hpp"
#include "platform/native_config.hpp"
#include "snd_mngr.hpp"
#include "snd_seseq.hpp"

namespace dc2::audio {
std::span<const sndSeSeqEvent> SequenceEvents(const sndCSeSeqData &sequence) {
    const auto bytes = sequence.events_storage.Bytes();
    if (sequence.event_num <= 0 || static_cast<std::size_t>(sequence.event_num) > bytes.size() / sizeof(sndSeSeqEvent) ||
        reinterpret_cast<std::uintptr_t>(bytes.data()) % alignof(sndSeSeqEvent) != 0) {
        return {};
    }
    return {reinterpret_cast<const sndSeSeqEvent *>(bytes.data()), static_cast<std::size_t>(sequence.event_num)};
}

bool StartSequence(sndCSeSeq &player, std::span<const sndSeSeqEvent> events, int tick_rate) {
    if (tick_rate <= 0 || events.empty() || events.size() > 1048577 || events.back().status != 0 ||
        std::ranges::any_of(events, [](const sndSeSeqEvent &event) {
            return event.delta < 0 || event.data[0] < 0 || event.data[1] < 0;
        })) {
        return false;
    }
    std::vector<sndSeSeqEvent> snapshot(events.begin(), events.end());
    player.Stop();
    player.Initialize();
    player.sequence_events = std::move(snapshot);
    player.snapshot_tick_rate = tick_rate;
    player.snapshot_playing = true;
    return true;
}

bool SequencePlaying(const sndCSeSeq &player) {
    return player.snapshot_playing;
}

} // namespace dc2::audio

void sndTrack::Initialize() {
    vol = 127;
    expression = 127;
    prog = 0;
    pan = 64;
    bend_lsb = 0;
    bend_msb = 64;
    se_id = 0;
    voice_num = 1;

    for (int index = 0; index < voice_num; index++) {
        voice[index].active = 0;
    }
}

void sndCSeSeqData::Initialize() {
    tick_rate = 1;
    event_num = 0;
    events_storage = {};
}

void sndCSeSeq::Initialize() {
    if (snapshot_playing) {
        Stop();
    }
    sequence_events.clear();
    snapshot_tick_rate = 1;
    snapshot_playing = false;
    tick = 0;
    wait = 0;
    event = nullptr;
    loop_event = nullptr;
    loop_tick = 0;
    loop = 0;
    vol = 127;
    pause = 0;
    track_num = 8;

    for (int index = 0; index < track_num; index++) {
        track[index].Initialize();
        track[index].se_id = index + 64;
    }
}

void sndCSeSeq::SetSeID(int id) {
    for (int index = 0; index < track_num; index++) {
        track[index].se_id = id + index;
    }
}

void sndCSeSeq::Count(float frames) {
    if (snapshot_playing && snapshot_tick_rate > 0 && std::isfinite(frames) && frames > 0.0f) {
        const float scaled = (static_cast<float>(snapshot_tick_rate) * frames) / 60.0f;
        const int   ticks = !std::isfinite(scaled) || scaled >= static_cast<float>(INT_MAX)
                                ? INT_MAX
                                : fptosi(scaled);
        tick = static_cast<int>(std::min(static_cast<long long>(INT_MAX),
                                         static_cast<long long>(tick) + ticks));
        wait = static_cast<int>(std::min(static_cast<long long>(INT_MAX),
                                         static_cast<long long>(wait) + ticks));
    }
}

void sndCSeSeq::Stop() {
    AllNoteOff();
    wait = 0;
    tick = 0;
    event = nullptr;
    loop_event = nullptr;
    snapshot_playing = false;
    std::vector<sndSeSeqEvent>{}.swap(sequence_events);
}

int sndCSeSeq::Step(float frames) {
    int channel = {};

    if (!snapshot_playing) {
        return 1;
    }

    if (pause != 0) {
        return 0;
    }

    Count(frames);

    if (event == nullptr) {
        event = sequence_events.data();
    }
    if (sequence_events.empty()) {
        Stop();
        return 1;
    }
    const auto base = reinterpret_cast<std::uintptr_t>(sequence_events.data());
    const auto count = sequence_events.size();
    if (count > (std::numeric_limits<std::uintptr_t>::max() - base) / sizeof(sndSeSeqEvent)) {
        Stop();
        return 1;
    }
    const auto bytes = count * sizeof(sndSeSeqEvent);
    const auto inside = [base, bytes](const sndSeSeqEvent *candidate) {
        const auto address = reinterpret_cast<std::uintptr_t>(candidate);
        return address >= base && address - base < bytes &&
               (address - base) % sizeof(sndSeSeqEvent) == 0;
    };

    loop = 0;

    for (;;) {
        if (!inside(event)) {
            Stop();
            return 1;
        }
        if (event->status == 0) {
            if (loop != 0) {
                break;
            }
            Stop();
            return 1;
        }

        if (event->delta > wait) {
            break;
        }

        wait -= event->delta;
        channel = event->status & 0xF;

        switch (event->status & 0xF0) {
            case SND_MIDI_NOTE_ON:
                NoteOn(channel, event->data[0], event->data[1]);
                break;
            case SND_MIDI_NOTE_OFF:
                NoteOff(channel, event->data[0], event->data[1]);
                break;
            case SND_MIDI_CTRL_CHG:
                CtrlChg(channel, event->data[0], event->data[1]);

                if (event->data[0] == SND_MIDI_CTRL_LOOP) {
                    if (event->data[1] == SND_MIDI_LOOP_START) {
                        loop_tick = tick;
                        loop_event = event;
                    }

                    if (event->data[1] == SND_MIDI_LOOP_END) {
                        loop = 1;
                    }
                }

                break;
            case SND_MIDI_PROG_CHG:
                ProgChg(channel, event->data[0]);
                break;
            case SND_MIDI_PITCH_BEND:
                PitchBend(channel, static_cast<u8>(event->data[1]), static_cast<u8>(event->data[0]));
                break;
        }

        event++;
    }

    if (loop != 0) {
        if (!inside(loop_event)) {
            Stop();
            return 1;
        }
        event = loop_event;
    }

    return 0;
}

int sndCSeSeq::chk_trk(int trk) {
    if (trk < 0 || trk >= track_num || static_cast<std::size_t>(trk) >= std::size(track)) {
        return 0;
    }

    return 1;
}

void sndCSeSeq::NoteOn(int trk, int key, int velocity) {
    sndTrack *channel = {};
    int       volume = {};

    if (chk_trk(trk) != 0) {
        if (velocity == 0) {
            NoteOff(trk, key, velocity);
            return;
        }

        channel = &track[trk];

        if (channel->NoteOn(key, velocity) != 0) {
            int bend = channel->bend_lsb + (channel->bend_msb << 7);
            int level = channel->expression * (vol * channel->vol) / 127 / 127;
            volume = level;
            sndSePlayPBPrKr(port, bank, channel->prog, key, velocity, volume, channel->pan, bend, channel->se_id);
        }
    }
}

void sndCSeSeq::NoteOff(int trk, int key, int velocity) {
    if (chk_trk(trk) != 0 && track[trk].NoteOff(key, velocity) != 0) {
        sndSeStopPBPrKr(port, bank, track[trk].prog, key, track[trk].se_id);
    }
}

void sndCSeSeq::AllNoteOff() {
    int i = {};

    for (i = 0; i < std::clamp(track_num, 0, static_cast<int>(std::size(track))); i++) {
        TrackNoteOff(i);
    }
}

void sndCSeSeq::TrackNoteOff(int trk) {
    sndTrack      *channel = {};
    sndSeSeqVoice *note = {};
    int            i = {};

    if (chk_trk(trk) != 0) {
        channel = &track[trk];
        note = channel->voice;

        for (i = 0; i < std::clamp(channel->voice_num, 0, static_cast<int>(std::size(channel->voice))); i++, note++) {
            if (note->active != 0) {
                sndSeStopPBPrKr(port, bank, note->prog, note->key, note->se_id);
                note->active = 0;
            }
        }
    }
}

void sndCSeSeq::CtrlChg(int trk, int ctrl, int value) {
    if (chk_trk(trk) != 0 && track[trk].CtrlChg(ctrl, value) != 0) {
        if (ctrl == SND_MIDI_CTRL_PAN) {
            SendPan(trk);
        }

        if (ctrl == SND_MIDI_CTRL_EXPRESSION || ctrl == SND_MIDI_CTRL_VOLUME) {
            SendVol(trk);
        }
    }
}

void sndCSeSeq::ProgChg(int trk, int prog) {
    if (chk_trk(trk) != 0) {
        track[trk].ProgChg(prog);
    }
}

void sndCSeSeq::PitchBend(int trk, int msb, int lsb) {
    if (chk_trk(trk) != 0 && track[trk].PitchBend(msb, lsb) != 0) {
        SendPitch(trk);
    }
}

void sndCSeSeq::SendVol(int trk) {
    sndTrack      *channel = {};
    sndSeSeqVoice *note = {};
    int            volume = {};
    int            i = {};

    if (chk_trk(trk) != 0) {
        channel = &track[trk];
        note = channel->voice;
        volume = channel->expression * (vol * channel->vol) / 127 / 127;

        for (i = 0; i < std::clamp(channel->voice_num, 0, static_cast<int>(std::size(channel->voice))); i++, note++) {
            sndSetSeVolPBPrKr(port, bank, note->prog, note->key, volume, channel->se_id);
        }
    }
}

void sndCSeSeq::SendPan(int trk) {
    sndTrack      *channel = {};
    sndSeSeqVoice *note = {};
    int            i = {};

    if (chk_trk(trk) != 0) {
        channel = &track[trk];
        note = channel->voice;

        for (i = 0; i < std::clamp(channel->voice_num, 0, static_cast<int>(std::size(channel->voice))); i++, note++) {
            sndSetSePanPBPrKr(port, bank, note->prog, note->key, channel->pan, channel->se_id);
        }
    }
}

void sndCSeSeq::SendPitch(int trk) {
    sndTrack      *channel = {};
    sndSeSeqVoice *note = {};
    int            i = {};

    if (chk_trk(trk) != 0) {
        channel = &track[trk];
        note = channel->voice;

        for (i = 0; i < std::clamp(channel->voice_num, 0, static_cast<int>(std::size(channel->voice))); i++, note++) {
            sndSetSePitchPBPrKr(port, bank, note->prog, note->key,
                                ((channel->bend_msb & 0x7F) << 7) + (channel->bend_lsb & 0x7F), channel->se_id);
        }
    }
}

sndSeSeqVoice *sndTrack::SaerchVoice(int program, int key) {
    sndSeSeqVoice *note = voice;

    for (int index = 0; index < voice_num; index++, note++) {
        if (note->active != 0 && note->prog == program && note->key == key) {
            return note;
        }
    }

    return nullptr;
}

sndSeSeqVoice *sndTrack::GetEmptyVoice() {
    sndSeSeqVoice *note = voice;

    for (int index = 0; index < voice_num; index++, note++) {
        if (note->active == 0) {
            return note;
        }
    }

    return nullptr;
}

int sndTrack::NoteOn(int note, int velocity) {
    sndSeSeqVoice *voice = {};

    if (SaerchVoice(static_cast<int>(prog), note) != nullptr) {
        return 1;
    }

    voice = GetEmptyVoice();

    if (voice == nullptr) {
        return 0;
    }

    voice->active = 1;
    voice->key = static_cast<s8>(note);
    voice->prog = prog;
    voice->se_id = se_id;
    return 1;
}

int sndTrack::NoteOff(int key, int velocity) {
    sndSeSeqVoice *note = SaerchVoice(prog, key);

    if (note == nullptr) {
        return 0;
    }

    note->active = 0;
    return 1;
}

int sndTrack::CtrlChg(int ctrl, int value) {
    int result = 1;

    switch (ctrl) {
        case SND_MIDI_CTRL_VOLUME:
            vol = value;
            break;
        case SND_MIDI_CTRL_PAN:
            pan = value;
            break;
        case SND_MIDI_CTRL_EXPRESSION:
            expression = value;
            break;
        default:
            result = 1;
            break;
    }

    return result;
}

int sndTrack::ProgChg(int program) {
    prog = program;
    return 0;
}

int sndTrack::PitchBend(int msb, int lsb) {
    bend_lsb = lsb;
    bend_msb = msb;
    return 1;
}

void sndCSeSeqData::LoadSMF(std::string_view document, mgCMemory *memory) {
    Initialize();
    if (memory == nullptr || memory->lock != 0) {
        return;
    }
    if (!document.empty()) {
        try {
            const auto root = nlohmann::json::parse(document);
            if (native_config::Int(root.at("schema_version")) != 1 || root.at("kind") != "effect_sequence") {
                return;
            }
            const auto &events = root.at("events");
            if (!events.is_array() || events.size() > 1048576) {
                return;
            }
            std::vector<sndSeSeqEvent> converted;
            for (const auto &e : events) {
                const auto delta = native_config::Int(e.at("delta"));
                const auto status = native_config::Int(e.at("status"));
                const auto first = native_config::Int(e.at("data").at(0));
                const auto second = native_config::Int(e.at("data").at(1));
                if (delta < 0 || delta > SHRT_MAX || status < 0 || status > UCHAR_MAX ||
                    first < 0 || first > SCHAR_MAX || second < 0 || second > SCHAR_MAX) {
                    return;
                }
                auto &out = converted.emplace_back();
                out = {};
                out.delta = static_cast<s16>(delta);
                out.status = static_cast<u8>(status);
                out.data[0] = static_cast<s8>(first);
                out.data[1] = static_cast<s8>(second);
            }
            const int rate = native_config::Int(root.at("tick_rate"));
            if (rate <= 0) {
                return;
            }
            converted.emplace_back();
            converted.back() = {};
            event_num = static_cast<int>(converted.size());
            auto *event = dc2::memory::NewArray<sndSeSeqEvent>(*memory, converted.size());
            if (!event) {
                Initialize();
                return;
            }
            std::ranges::copy(converted, event);
            events_storage = dc2::memory::ArenaBuffer::Bind(*memory,
                                                            {reinterpret_cast<u8 *>(event), converted.size() * sizeof(sndSeSeqEvent)});
            if (events_storage.Bytes().empty()) {
                Initialize();
            }
            tick_rate = rate;
            return;
        } catch (const std::exception &) {
            Initialize();
        }
    }
    CT_LOG_ERROR(Audio, "sound: missing or invalid effect sequence JSON");
}
