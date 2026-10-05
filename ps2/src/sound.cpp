#include "common.h"
#include "sound.hpp"
#include "ezbgm.hpp"
#include "ezmidi.hpp"
#include <libsdr.h>
#include <cstdio>

extern const char at_218[];
extern const char at_733[];
extern "C" int fptosi(float value);

// Code (.text)
void CSound::StopVoice(int voice) {
    sceSdRemote(1, 0x8030, voice | 0x1600, 0xFFFFFF);
    printf(at_218, voice);
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sound", SetReverb__6CSoundFiii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sound", set_spu__Fiiii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sound", TransHdBd__Fiiii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sound", Init__6CSoundFiiii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sound", Exit__6CSoundFv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sound", DEL_PORT__6CSoundFi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sound", SQ_Play__6CSoundFiii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sound", SQ_RePlay__6CSoundFi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sound", SE_Play__6CSoundFiiiiiiiii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sound", SE_SetVol__6CSoundFiiiiii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sound", SE_SetPan__6CSoundFiiiiii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sound", SE_Stop__6CSoundFiiiii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sound", Step__6CSoundFv);
void CSound::Stop(int port) {
    ezMidi(port + 0x20, 0);
    printf(at_733, port);
}
void CSound::SetVol(int port, int volume) {
    int scaled;

    scaled = volume;
    if (scaled != 0x100) {
        scaled = fptosi(2.015748f * (float)scaled);
    }
    ezMidi(port + 0xB0, scaled);
}
void CSound::SetStereoMode(int mode) {
    ezMidi(0xC0, mode);
}
void CSound::SetMasterVol(int core, int volume) {
    sceSdRemote(1, 0x8010, core | 0x980, volume);
    sceSdRemote(1, 0x8010, core | 0xA80, volume);
}
void CSound::LoadHdBd(int a, int b, int c, int d, int e) {
    LoadHdBd2(a, b, c, d, e);
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sound", LoadHdBd2__6CSoundFiiiii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sound", LoadHdBdAdd__6CSoundFiiiii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sound", LoadSeq__6CSoundFiii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sound", SE_SetPitch__6CSoundFiiiiii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sound", StreamOpenFast__6CSoundFiPc);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sound", StreamOpenFromFPLFast__6CSoundFiPcPc);
int CSound::StreamPlay(int stream) {
    return ezBgm(stream | 0x50, 0);
}
void CSound::StreamStop(int stream) {
    ezBgm(stream | 0x60, 0);
}
void CSound::StreamClose(int stream) {
    ezBgm(stream | 0x60, 0);
    ezBgm(stream | 0x30, 0);
    ezBgm(stream | 0x10, 0);
}
void CSound::StreamEND(int stream) {
    ezBgm(stream | 0x60, 0);
    ezBgm(stream | 0x70, 0);
    ezBgm(stream | 0x10, 0);
}
void CSound::StreamPause(int stream) {
    ezBgm(stream | 0x60, 0);
}
void CSound::StreamRePlay(int stream) {
    ezBgm(stream | 0x50, 0);
}
void CSound::StreamSetVol(int stream, int left, int right) {
    ezBgm(stream | 0x80, (left << 16) | right);
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sound", StreamGetState__6CSoundFi);
int CSound::StreamGetLevel(int stream) {
    return ezBgm(stream | 0x80E0, 0);
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sound", StreamStandBy__6CSoundFi);
int CSound::TransBdState(int mode) {
    return sceSdRemote(1, 0x80F0, mode, 0);
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
