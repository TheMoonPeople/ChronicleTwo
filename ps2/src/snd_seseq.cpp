#include "common.h"
#include "snd_seseq.hpp"

extern "C" int fptosi(float value);

// Code (.text)
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_seseq", BigToLittle__FPvPvi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_seseq", GetDeltaTime__FPcPi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_seseq", Initialize__8sndTrackFv);
void sndCSeSeqData::Initialize(void) {
    tick_rate = 1;
    event_num = 0;
    event = NULL;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_seseq", LoadSMF__13sndCSeSeqDataFPciP9mgCMemory);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_seseq", Initialize__9sndCSeSeqFv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_seseq", SetSeID__9sndCSeSeqFi);
void sndCSeSeq::Count(float frames) {
    int ticks;
    sndCSeSeqData *seqData;

    seqData = data;
    if (seqData != NULL) {
        ticks = (int)(fptosi(((float)seqData->tick_rate * frames) / 60.0f));
        tick += ticks;
        wait += ticks;
    }
}
void sndCSeSeq::Stop(void) {
    AllNoteOff();
    wait = 0;
    tick = 0;
    data = NULL;
    event = NULL;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_seseq", Step__9sndCSeSeqFf);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_seseq", chk_trk__9sndCSeSeqFi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_seseq", NoteOn__9sndCSeSeqFiii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_seseq", NoteOff__9sndCSeSeqFiii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_seseq", AllNoteOff__9sndCSeSeqFv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_seseq", TrackNoteOff__9sndCSeSeqFi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_seseq", CtrlChg__9sndCSeSeqFiii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_seseq", ProgChg__9sndCSeSeqFii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_seseq", PitchBend__9sndCSeSeqFiii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_seseq", SendVol__9sndCSeSeqFi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_seseq", SendPan__9sndCSeSeqFi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_seseq", SendPitch__9sndCSeSeqFi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_seseq", SaerchVoice__8sndTrackFii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_seseq", GetEmptyVoice__8sndTrackFv);
int sndTrack::NoteOn(int note, int velocity) {
    sndSeSeqVoice *voice;

    if (SaerchVoice((int)prog, note) != 0) {
        return 1;
    }
    voice = GetEmptyVoice();
    if (voice == NULL) {
        return 0;
    }
    voice->active = 1;
    voice->key = (s8)note;
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_seseq", CtrlChg__8sndTrackFii);
int sndTrack::ProgChg(int program) {
    prog = program;
    return 0;
}
int sndTrack::PitchBend(int msb, int lsb) {
    bend_lsb = lsb;
    bend_msb = msb;
    return 1;
}

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/snd_seseq", at_295__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/snd_seseq", at_296__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/snd_seseq", at_297__2__DATA);
