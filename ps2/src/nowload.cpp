#include "common.h"
#include "nowload.hpp"
#include "mglib.hpp"
#include "snd_mngr.hpp"
#include <eekernel.h>
#include "mg_texture.hpp"
#include "mainloop.hpp"
#include "dataread.hpp"
#include "scenesnd.hpp"
#include "sound.hpp"
#include "menucommon.hpp"
#include <cstring>
#include <cstdio>

extern int PauseFlag__2;
extern int cancel_now_loading;
extern int InitFlag;
extern PAUSE_INFO PauseInfo;
extern float SeCoreVol;
extern int PauseEnableFlag;
extern int PauseCancelCnt;
extern int ProgBarCnt;
extern int LoopStep;
extern int EndFlag;
extern int TheadID__3;
extern float NextProgBarWidth;
extern char at_863__5[];
extern char at_864__3[];
extern float ProgBarWidth;
extern u8 ThreadStack__3[0x1000];
extern "C" void NowLoadingLoop__FPv(void *);
extern int load_skip_img;
extern char at_912__6[];
extern char at_913__5[];
extern u8 SkipImage[];
extern int PauseTexb;
extern char at_920__7[];
extern int wave_status;
extern int play_time_count;
extern CScene::BGM_STATUS bgm_status;
extern NowLoadingInfo LoadInfo;
extern float ProgBarWidthStep;

// Code (.text)
void SwitchNowLoadingThread() {
    RotateThreadReadyQueue(10);
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nowload", NowLoadingLoop__FPv);
void CancelNowLoading() {
    cancel_now_loading = 1;
}
void CreateNowLoading(NowLoadingInfo *info) {
    char name[0x40];
    char path[0x40];
    struct {
        ThreadParam param;
        int reserved[4];
    } thread;
    int size;
    u32 length;
    mgCMemory *memory;
    u8 *buffer;
    int language;
    LoopStep = -1;
    if (cancel_now_loading != 0) {
        cancel_now_loading = 0;
        return;
    }
    LoadInfo.tex_block = info->tex_block;
    LoadInfo.unk_4 = info->unk_4;
    memory = &LoadInfo.memory;
    *memory = info->memory;
    language = LanguageCode;
    LoadInfo.step_count = info->step_count;
    buffer = (u8 *)(memory->stack + memory->stack_used);
    if (language > 0 && language < 6) {
        language = 2;
    }
    sprintf(name, at_863__5, language);
    strcpy(path, name);
    strcat(path, at_864__3);
    if (LoadFile2(path, buffer, &size, 0) != 0) {
        u32 blocks;
        if ((u32)size & 0xF) {
            blocks = ((u32)size >> 4) + 1;
        } else {
            blocks = (u32)size >> 4;
        }
        memory->Alloc(blocks);
        mgTexManager.EnterIMGFile(buffer, LoadInfo.tex_block, memory, 0);
        ProgBarWidthStep = 0.2f / (float)LoadInfo.step_count;
        ProgBarWidth = 0;
        ProgBarCnt = 0;
        NextProgBarWidth = 0;
        LoopStep = 0;
        thread.param.entry = (void (*)(void *))NowLoadingLoop__FPv;
        EndFlag = 0;
        thread.param.stack = ThreadStack__3;
        thread.param.option = 0;
        thread.param.stackSize = 0x1000;
        thread.param.initPriority = 10;
        thread.param.gpReg = &_gp;
        TheadID__3 = CreateThread(&thread.param);
        StartThread(TheadID__3, 0);
    }
}
void NowLoadingBarStep() {
    ProgBarCnt += 1;
    if (ProgBarCnt >= LoadInfo.step_count) {
        ProgBarCnt = LoadInfo.step_count;
    }
    float width = (float)(ProgBarCnt + 1) / (float)LoadInfo.step_count;
    NextProgBarWidth = width;
    if (!(width <= 0.99f)) {
        NextProgBarWidth = 1.0f;
    }
}
void NowLoadingBarSteEnd() {
    ProgBarCnt = LoadInfo.step_count;
    ProgBarWidthStep = 0.05f;
}
void DeleteNowLoading() {
    if (LoopStep != -1) {
        SwitchNowLoadingThread();
        EndFlag = 1;
        SwitchNowLoadingThread();
        while (LoopStep != 2) {
            SwitchNowLoadingThread();
        }
        TerminateThread(TheadID__3);
        DeleteThread(TheadID__3);
        mgTexManager.DeleteBlock(LoadInfo.tex_block);
    }
}
NowLoadingInfo::NowLoadingInfo() {
    memory.Init();
    tex_block = -1;
    unk_4 = 0;
    step_count = 0;
}
int InitPauseData() {
    int size;
    u8 data[0x10000];
    char path[0x40];
    if (LanguageCode > 1) {
        sprintf(path, at_912__6, LanguageCode);
        if (LoadFile2(path, data, &size, 0) == 0) {
            return 0;
        }
    } else if (LoadFile2(at_913__5, data, &size, 0) == 0) {
        return 0;
    }
    if (size >= 0x2800) {
        return 0;
    }
    memcpy(SkipImage, data, size);
    load_skip_img = 1;
    return 1;
}
int InitPause(int block) {
    mgCTextureManager *tex = &mgTexManager;
    PauseEnableFlag = 1;
    PauseFlag__2 = 0;
    InitFlag = 0;
    PauseCancelCnt = 0;
    tex->DeleteBlock(block);
    tex->EnterTexture(block, at_920__7, 0, mgScreenWidth, mgScreenHeight, 0x20, 0, 0, 0);
    if (load_skip_img != 0) {
        tex->EnterIMGFile(SkipImage, block, 0, 0);
    }
    PauseTexb = block;
    return 1;
}
int PauseEnable(int arg0) {
    int old = PauseEnableFlag;
    PauseEnableFlag = arg0;
    return old;
}
int GetPauseFlag() {
    return PauseFlag__2;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nowload", PauseStart__FP10PAUSE_INFO);
void PauseCancel() {
    PauseFlag__2 = 0;
}
void PauseEnd() {
    if (PauseFlag__2 != 0) {
        if (InitFlag <= 0) {
            return;
        }
    } else {
        return;
    }
    PauseFlag__2 = 0;
    if (bgm_status.state == 1) {
        PauseInfo.scene->RePlayBGM();
    }
    if (wave_status & 0x1000) {
        sndStreamRePlay();
    }
    sndPortSqReplay(4);
    sndPortSqReplay(0);
    PlayTimeCount(play_time_count);
    if (!(SeCoreVol < 0.0f)) {
        sndMasterVolFadeInOut(1, 0xF, SeCoreVol, 0.0f);
    }
    sndSePlay(GetSystemSndID(), 0x19, 0);
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nowload", PauseLoop__Fv);
void PauseCount() {
    PauseCancelCnt -= 1;
    if (PauseCancelCnt < 0)
        PauseCancelCnt = 0;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nowload", SCElogoFade__FiP9mgCMemory);

// Static initialiser (.init)
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nowload", __sinit_nowload_cpp);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nowload", at_832__7__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nowload", at_863__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nowload", at_864__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nowload", at_912__6__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nowload", at_913__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nowload", at_920__7__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nowload", at_1003__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nowload", at_1068__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nowload", at_1069__6__DATA);

// Static initialiser table (.ctor)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nowload", D_0037B080__DATA);

// Small initialised data (.sdata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nowload", LoopStep__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(TheadID__3, 0x4);
INCLUDE_BSS(ProgBarWidth, 0x4);
INCLUDE_BSS(ProgBarWidthStep, 0x4);
INCLUDE_BSS(NextProgBarWidth, 0x4);
INCLUDE_BSS(ProgBarCnt, 0x4);
INCLUDE_BSS(EndFlag, 0x4);
INCLUDE_BSS(cancel_now_loading, 0x4);
INCLUDE_BSS(load_skip_img, 0x4);
INCLUDE_BSS(PauseFlag__2, 0x4);
INCLUDE_BSS(PauseEnableFlag, 0x4);
INCLUDE_BSS(PauseCancelCnt, 0x4);
INCLUDE_BSS(PauseTexb, 0x4);
INCLUDE_BSS(PauseInfo, 0x8);
INCLUDE_BSS(InitFlag, 0x4);
INCLUDE_BSS(SeCoreVol, 0x4);
INCLUDE_BSS(play_time_count, 0x4);
INCLUDE_BSS(wave_status, 0x4);
INCLUDE_BSS(start_vcount, 0x4);

// Uninitialised data (.bss)
INCLUDE_BSS(ThreadStack__3, 0x1000);
INCLUDE_BSS(LoadInfo, 0x40);
INCLUDE_BSS(SkipImage, 0x2800);
INCLUDE_BSS(bgm_status, 0x20);
