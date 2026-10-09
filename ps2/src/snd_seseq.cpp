#include "common.h"
#include "mw_runtime.h"

#include <cstdio>
#include <cstring>

#include "mg_memory.hpp"
#include "snd_mngr.hpp"
#include "snd_seseq.hpp"

// Code (.text)
/**
 *
 * Copies a big-endian field into little-endian byte order.
 *
 */
static void BigToLittle(void *dst, void *src, int size) {
    u8 *output;
    u8 *input;
    int i;

    output = (u8 *) dst + (size - 1);
    input = (u8 *) src;

    for (i = 0; i < size; i++) {
        *output-- = *input++;
    }
}

/**
 *
 * Reads a MIDI variable-length delta and returns the following byte.
 *
 */
static char *GetDeltaTime(char *p, int *delta) {
    int value;
    u8  byte;

    value = 0;

    for (;;) {
        byte = *p++;
        value += byte & 0x7F;

        if ((byte & 0x80) == 0) {
            break;
        }

        value <<= 7;
    }

    *delta = value;
    return p;
}

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
    event = NULL;
}
void sndCSeSeqData::LoadSMF(char *smf, int size, mgCMemory *memory) {
    s16            format;
    s16            track_count;
    s16            division;
    int            header_size;
    int            track_size;
    int            delta;
    int            i;
    int            previous_status;
    unsigned int   bytes;
    unsigned int   qwords;
    char          *cursor;
    char          *track_start;
    int            status;
    int            data_size;
    int            meta_size;
    sndSeSeqEvent *output;

    if (memcmp(smf, "MThd", 4) != 0) {
        return;
    }
    BigToLittle(&header_size, smf + 4, 4);
    cursor = (char *)(header_size + (int)smf + 8);
    BigToLittle(&format, smf + 8, 2);
    if (format != 0) {
        return;
    }
    BigToLittle(&track_count, smf + 10, 2);
    BigToLittle(&division, smf + 12, 2);
    if (memcmp(cursor, "MTrk", 4) != 0) {
        return;
    }
    BigToLittle(&track_size, cursor + 4, 4);
    cursor += 8;
    track_start = cursor;
    event = (sndSeSeqEvent *)memory->stAllocTest(1);
    output = event;
    if (output == NULL) {
        return;
    }
    event_num = 0;
    previous_status = -1;
    do {
        cursor = GetDeltaTime(cursor, &delta);
        status = (u8)*cursor++;
        if ((status & 0x80) == 0) {
            status = previous_status;
            cursor--;
        }
        if (status == SND_MIDI_META) {
            if (*cursor == SND_MIDI_META_END_OF_TRACK) {
                break;
            }
            meta_size = (u8)cursor[1];
            cursor += 2;
            cursor += meta_size;
        } else {
            data_size = 0;
            switch (status & 0xF0) {
            case SND_MIDI_NOTE_ON:
            case SND_MIDI_NOTE_OFF:
            case SND_MIDI_CTRL_CHG:
            case SND_MIDI_PITCH_BEND:
                data_size = 2;
                break;
            case SND_MIDI_PROG_CHG:
            case SND_MIDI_CH_PRESSURE:
                data_size = 1;
                break;
            }
            if (data_size < 0) {
                printf("Unknown Message!! %x\n", status);
            } else {
                output->delta = delta;
                output->status = status;
                for (i = 0; i < data_size; i++) {
                    output->data[i] = *cursor++;
                }
                output++;
                event_num++;
            }
        }
        previous_status = status;
    } while (cursor - track_start <= track_size);
    output->status = 0;
    event_num = output + 1 - event;
    bytes = event_num * sizeof(sndSeSeqEvent);
    if ((bytes & 0xF) != 0) {
        qwords = (bytes >> 4) + 1;
    } else {
        qwords = bytes >> 4;
    }
    memory->Alloc(qwords);
    tick_rate = division * 225 / 60;
}

void sndCSeSeq::Initialize() {
    tick = 0;
    wait = 0;
    data = NULL;
    event = NULL;
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
    int            ticks;
    sndCSeSeqData *seq_data;

    seq_data = data;

    if (seq_data != NULL) {
        ticks = fptosi(((float) seq_data->tick_rate * frames) / 60.0f);
        tick += ticks;
        wait += ticks;
    }
}

void sndCSeSeq::Stop() {
    AllNoteOff();
    wait = 0;
    tick = 0;
    data = NULL;
    event = NULL;
}

int sndCSeSeq::Step(float frames) {
    int channel;

    if (data == NULL) {
        return 1;
    }

    if (pause != 0) {
        return 0;
    }

    Count(frames);

    if (event == NULL) {
        event = data->event;
    }

    loop = 0;

    for (;;) {
        if (event->status == 0 && loop == 0) {
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
                PitchBend(channel, (u8) event->data[1], (u8) event->data[0]);
                break;
        }

        event++;
    }

    if (loop != 0) {
        event = loop_event;
    }

    return 0;
}

int sndCSeSeq::chk_trk(int trk) {
    if (trk < 0 || trk >= track_num) {
        return 0;
    }

    return 1;
}

void sndCSeSeq::NoteOn(int trk, int key, int velocity) {
    sndTrack *channel;
    int       volume;

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
    int i;

    for (i = 0; i < track_num; i++) {
        TrackNoteOff(i);
    }
}

void sndCSeSeq::TrackNoteOff(int trk) {
    sndTrack      *channel;
    sndSeSeqVoice *note;
    int            i;

    if (chk_trk(trk) != 0) {
        channel = &track[trk];
        note = channel->voice;

        for (i = 0; i < channel->voice_num; i++, note++) {
            sndSeStopPBPrKr(port, bank, note->prog, note->key, note->se_id);
            note->active = 0;
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
    sndTrack      *channel;
    sndSeSeqVoice *note;
    int            volume;
    int            i;

    if (chk_trk(trk) != 0) {
        channel = &track[trk];
        note = channel->voice;
        volume = channel->expression * (vol * channel->vol) / 127 / 127;

        for (i = 0; i < channel->voice_num; i++, note++) {
            sndSetSeVolPBPrKr(port, bank, note->prog, note->key, volume, channel->se_id);
        }
    }
}

void sndCSeSeq::SendPan(int trk) {
    sndTrack      *channel;
    sndSeSeqVoice *note;
    int            i;

    if (chk_trk(trk) != 0) {
        channel = &track[trk];
        note = channel->voice;

        for (i = 0; i < channel->voice_num; i++, note++) {
            sndSetSePanPBPrKr(port, bank, note->prog, note->key, channel->pan, channel->se_id);
        }
    }
}

void sndCSeSeq::SendPitch(int trk) {
    sndTrack      *channel;
    sndSeSeqVoice *note;
    int            i;

    if (chk_trk(trk) != 0) {
        channel = &track[trk];
        note = channel->voice;

        for (i = 0; i < channel->voice_num; i++, note++) {
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

    return NULL;
}

sndSeSeqVoice *sndTrack::GetEmptyVoice() {
    sndSeSeqVoice *note = voice;

    for (int index = 0; index < voice_num; index++, note++) {
        if (note->active == 0) {
            return note;
        }
    }

    return NULL;
}

int sndTrack::NoteOn(int note, int velocity) {
    sndSeSeqVoice *voice;

    if (SaerchVoice((int) prog, note) != 0) {
        return 1;
    }

    voice = GetEmptyVoice();

    if (voice == NULL) {
        return 0;
    }

    voice->active = 1;
    voice->key = (s8) note;
    voice->prog = prog;
    voice->se_id = se_id;
    return 1;
}

int sndTrack::NoteOff(int key, int velocity) {
    sndSeSeqVoice *note = SaerchVoice(prog, key);

    if (note == NULL) {
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
