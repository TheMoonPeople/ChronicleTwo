#include "common.h"
#include "snd_mngr.hpp"
#include "sound.hpp"
#include "snd_seseq.hpp"

extern CSound CSnd;
sndPortInfo *GetPortInfo(int port);
sndSeInfo *GetSeInfo(u32 snd_id, int index);
sndCSeSeq *GetSeSeq(int seq_id);
void CSndStep();

// Code (.text)
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", Create__11CLoopSeMngrFiP9mgCMemory);
SND_LOOP_SE_SEQ::SND_LOOP_SE_SEQ() {
    se_id = -1;
    vol = -1.0f;
    pan = 0.0f;
}
void CLoopSeMngr::Initialize(void) {
    loop_se_num = 0;
    loop_se = NULL;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", Clear__11CLoopSeMngrFv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", GetLoopSe__11CLoopSeMngrFPiUii);
int CLoopSeMngr::SeLoopPlayStop(u32 handle, int sound, int flags, int loop) {
    return SeLoopPlayStop(handle, sound, flags, -1.0f, 0.0f, loop);
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", SeLoopPlayStop__11CLoopSeMngrFUiiiffi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", Step__11CLoopSeMngrFv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", AllSeStop__11CLoopSeMngrFv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndGetReverbDepth__Fi);
u32 sndCreateID(u32 snd_id, s32 se_no) {
    return (snd_id & 0xFFFF0000) | (se_no & 0xFFFF);
}
int sndGetSeNo(u32 se_id) {
    return se_id & 0xFFFF;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", GetPortInfo__Fi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", GetSeSeq__Fi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", GetEmptySeSeq__FPi);
u32 GetPortNo(u32 sound_id) {
    return (sound_id >> 24) & 0xFF;
}
u32 GetBankNo(u32 sound_id) {
    return (sound_id >> 16) & 0xFF;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", GetBankInfo__FUi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", GetSeInfo__FUii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndInitMngr__Fv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndWaitSema__Fv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndSignalSema__Fv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndInitPort__Fi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndInitSeSeq__Fi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndSetReverb__Fiii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndStopVoice__Fi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", SetMasterVol__Fif);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", FadeMasterVol__Fv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndSetMasterVol__Fif);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndGetMasterVol__Fi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndMasterVolFadeInOut__Fiiff);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndSetPortVol__Fif);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndGetPortVol__Fi);
int sndTransBdState(void) {
    return CSnd.TransBdState(1);
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndWaitTransBd__Fv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", CSndStep__Fv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", CSndStepWait__Fv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndStep__Ff);
void sndFlush(void) {
    sndWaitSema();
    CSndStep();
    sndSignalSema();
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", SeAllStop_Sub__Fi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndSeAllStop__Fi);
int sndGetSeDefVol(u32 se_id, int index) {
    sndSeInfo *info;

    info = GetSeInfo(se_id, index);
    if (info != NULL) {
        return info->def_vol;
    }
    return 0;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", IsBgmPort__Fi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", GetCSndPortNo__FiPiPiPi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndLoadSound__FiPUiP9mgCMemory);
sndCSeSeqData::sndCSeSeqData() {
    Initialize();
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndDeletePort__Fi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", GetPortBankNo__FUiPiPi);
void sndSePlay(u32 snd_id, s32 se_no, s32 voice) {
    sndSePlaySeID(snd_id, se_no, -1, -1, 0x40, 0x2000, voice);
}
void sndSePlayV(u32 snd_id, s32 se_no, s32 vol, s32 voice) {
    sndSePlaySeID(snd_id, se_no, -1, vol, 0x40, 0x2000, voice);
}
void sndSePlayVP(u32 snd_id, s32 se_no, s32 vol, s32 pan, s32 voice) {
    sndSePlaySeID(snd_id, se_no, -1, vol, pan, 0x2000, voice);
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndSePlayVPf__FUiiffi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndSePlayVf__FUiifi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndSePause__FUii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndGetSeStatus__FUii);
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndSeCheck__FUii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndSePlaySeID__FUiiiiiii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndSeStop__FUiii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndSetSeVol__FUiiii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndSetSePan__FUiiii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndSetSeVolf__FUiifi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndSetSePanf__FUiifi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndSetSePitch__FUiiii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndSetMicPos__FPfPf);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndGetVolPan__FPfPfPfff);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndGetVolPan__FPfPfPfPfff);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndVolLimit__Fi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndSePlayPrKr__FUiiiiiiii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndSeStopPrKr__FUiiii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndSetSeVolPrKr__FUiiiii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndSetSePanPrKr__FUiiiii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndSetSePitchPrKr__FUiiiii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndSePlayPBPrKr__Fiiiiiiiii);
void sndSeStopPBPrKr(int a, int b, int c, int d, int e) {
    sndWaitSema();
    CSnd.SE_Stop(a, b, c, d, e);
    sndSignalSema();
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndSetSeVolPBPrKr__Fiiiiii);
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndSqStop__Fii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndSetSqVol__Fiii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndSqRePlay__Fii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", GetLine__FPPcPcPc);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", SearchSeq__11sndBankInfoFPcPi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", LoadSeInfoTxt__11sndPortInfoFiPciP9mgCMemory);
sndSeInfo::sndSeInfo(void) {
    this->unk_0 = 0;
    this->type = 0;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", LoadVolInfoTxt__11sndPortInfoFiPci);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndStopSeSeq__Fi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", PlaySeSeq__FUiP13sndCSeSeqDatai);
void StopSeSeq(int seq_id) {
    sndCSeSeq *seq;

    seq = GetSeSeq(seq_id);
    if (seq != NULL) {
        seq->Stop();
    }
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", SetVolSeSeq__Fii);
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndStreamSetVol__Fff);
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", sndStreamClose__Fv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", __ct__9sndCSeSeqFv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", __ct__11sndPortInfoFv);

// Static initialiser (.init)
INCLUDE_ASM("ps2/asm/pal/nonmatchings/snd_mngr", __sinit_snd_mngr_cpp);

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
