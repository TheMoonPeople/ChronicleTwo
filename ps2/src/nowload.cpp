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
extern NowLoadingInfo LoadInfo;
extern float ProgBarWidthStep;
#include "mglib.hpp"
#include "mg_texture.hpp"
#include "mainloop.hpp"
#include "scenesnd.hpp"
#include "snd_mngr.hpp"
#include "dataread.hpp"
#include <cstdio>
#include <cstring>
#ifdef NONMATCHING
#include "event.hpp"
#include "gamepad.hpp"
#include "padcontrol.hpp"
#include "mg_drawprim.hpp"
#include "mg_tanime.hpp"
#include "savedata.hpp"
#include "title.hpp"

static char ThreadStack__3[0x1000];
static float ProgBarWidth;
static int start_vcount;
NowLoadingInfo LoadInfo;
#endif

extern int cancel_now_loading;
extern int PauseEnableFlag;
extern int PauseFlag__2;
extern int PauseCancelCnt;
extern int ProgBarCnt;
extern float ProgBarWidthStep;
extern float NextProgBarWidth;
extern int InitFlag;
extern float SeCoreVol;
extern PAUSE_INFO PauseInfo;
extern NowLoadingInfo LoadInfo;
extern int TheadID__3;
extern int EndFlag;
extern int play_time_count;
extern int wave_status;
extern int bgm_status[7];
extern int load_skip_img;
extern int PauseTexb;
extern unsigned char SkipImage[0x2800];

#ifdef NONMATCHING
struct PauseInfoInitializer {
    PauseInfoInitializer() {
        PauseInfo.event_skip = 0;
        PauseInfo.scene = NULL;
    }
};
static PauseInfoInitializer pause_info_initializer;
#endif

// Code (.text)
void SwitchNowLoadingThread() {
    RotateThreadReadyQueue(10);
}
#ifdef NONMATCHING
static void NowLoadingLoop(void *unused) {
    mgRect<int> image_rect(0, 0, 256, 192);
    int image_y = mgScreenHeight - 186;
    if (LanguageCode > 0 && LanguageCode < 6) image_y -= 20;
    int bar_y = image_y + 158;
    for (;;) {
        if (LoopStep == NOW_LOADING_STEP_START) LoopStep = NOW_LOADING_STEP_DRAW;
        if (LoopStep == NOW_LOADING_STEP_DRAW) {
            mgSetBackGround(0.0f, 0.0f, 0.0f, 0.0f);
            mgBeginFrame(NULL);
            mgTexManager.ReloadTexture(LoadInfo.tex_block, (sceVif1Packet *)NULL);
            mgCTexture *loading = mgTexManager.GetTexture((char *)"loading", LoadInfo.tex_block);
            mgCDrawPrim prim;
            prim.Initialize(NULL, NULL);
            prim.DepthTestEnable(0);
            prim.AlphaBlendEnable(1);
            prim.ZMask(1);
            prim.TextureMapEnable(0);
            prim.Shading(1);
            prim.AntiAliasing(1);
            prim.Begin(4);
            float end_x = 91.0f + 157.0f * ProgBarWidth;
            prim.Color(40, 100, 255, 128);
            prim.Vertex(91.0f, (float)bar_y, 0.0f);
            prim.Vertex(end_x, (float)bar_y, 0.0f);
            prim.Color(5, 20, 50, 128);
            prim.Vertex(91.0f, (float)bar_y + 5.0f, 0.0f);
            prim.Vertex(end_x, (float)bar_y + 5.0f, 0.0f);
            prim.End();
            prim.TextureMapEnable(1);
            prim.AntiAliasing(0);
            prim.Bilinear(0);
            prim.Begin(6);
            prim.Color(128, 128, 128, 128);
            prim.Texture(loading);
            prim.TextureCrd(image_rect.left, image_rect.top);
            prim.Vertex(50, image_y, 0);
            prim.TextureCrd(image_rect.right, image_rect.bottom);
            prim.Vertex(image_rect.right + 50 - image_rect.left, image_y + image_rect.bottom - image_rect.top, 0);
            prim.End();
            ProgBarWidth += ProgBarWidthStep;
            if (ProgBarWidth > NextProgBarWidth) ProgBarWidth = NextProgBarWidth;
            mgSetRotateThread(10);
            mgEndFrame(NULL);
            mgSetRotateThread(-1);
            if (EndFlag && ProgBarWidth >= 1.0f) LoopStep = NOW_LOADING_STEP_END;
        }
        SwitchNowLoadingThread();
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nowload", NowLoadingLoop__FPv);
#endif
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
    ProgBarCnt++;
    if (ProgBarCnt >= LoadInfo.step_count) {
        ProgBarCnt = LoadInfo.step_count;
    }
    NextProgBarWidth = (float)(ProgBarCnt + 1) / (float)LoadInfo.step_count;
    if (NextProgBarWidth > 0.99f) {
        NextProgBarWidth = 1.0f;
    }
}
void NowLoadingBarSteEnd() {
    ProgBarCnt = LoadInfo.step_count;
    ProgBarWidthStep = 0.05f;
}
void DeleteNowLoading() {
    if (LoopStep == NOW_LOADING_STEP_NONE) {
        return;
    }
    SwitchNowLoadingThread();
    EndFlag = 1;
    SwitchNowLoadingThread();
    while (LoopStep != NOW_LOADING_STEP_END) {
        SwitchNowLoadingThread();
    }
    TerminateThread(TheadID__3);
    DeleteThread(TheadID__3);
    mgTexManager.DeleteBlock(LoadInfo.tex_block);
}
NowLoadingInfo::NowLoadingInfo() {
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
int PauseEnable(int enable) {
    int previous = PauseEnableFlag;
    PauseEnableFlag = enable;
    return previous;
}

int GetPauseFlag() {
    return PauseFlag__2;
}

#ifdef NONMATCHING
int PauseStart(PAUSE_INFO *info) {
    if (PauseEnableFlag == 0 || PauseCancelCnt > 0) {
        return 0;
    }
    PauseCancelCnt = 10;
    InitFlag = 0;
    PauseFlag__2 = 1;
    PauseInfo = *info;
    SeCoreVol = -1.0f;
    return 1;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nowload", PauseStart__FP10PAUSE_INFO);
#endif

void PauseCancel() {
    PauseFlag__2 = 0;
}
void PauseEnd() {
    if (PauseFlag__2 == 0 || InitFlag <= 0) {
        return;
    }
    PauseFlag__2 = 0;
    if (bgm_status[0] == 1) {
        PauseInfo.scene->RePlayBGM();
    }
    if ((wave_status & 0x1000) != 0) {
        sndStreamRePlay();
    }
    sndPortSqReplay(4);
    sndPortSqReplay(0);
    PlayTimeCount(play_time_count);
    if (SeCoreVol >= 0.0f) {
        sndMasterVolFadeInOut(1, 15, SeCoreVol, 0.0f);
    }
    sndSePlay(GetSystemSndID(), 0x19, 0);
}
#ifdef NONMATCHING
int PauseLoop() {
    if (!PauseFlag__2) return 0;
    mgBeginFrame(NULL);
    mgTexManager.ReloadTexture(PauseTexb, (sceVif1Packet *)NULL);
    mgCTexture *backdrop = mgTexManager.GetTexture((char *)"pause_work", -1);
    if (InitFlag == 0) {
        sndSePlay(GetSystemSndID(), 25, 0);
        SeCoreVol = sndGetMasterVol(1);
        sndMasterVolFadeInOut(1, 15, 0.0f, -1.0f);
        sndPortSqPause(4);
        sndPortSqPause(0);
        mgCTexture back_buffer;
        mgGetFrameBackBuffer(&back_buffer);
        mgRect<int> source(0, 0, (mgScreenWidth - 1) * 16, (mgScreenHeight - 1) * 16);
        mgSetPkMoveImage(&back_buffer, source, backdrop, 0, 0, 0);
        play_time_count = GetPlayTimeCountFlag();
        PlayTimeCount(0);
        wave_status = 0;
    }
    if (InitFlag == 15) {
        wave_status = sndStreamGetState();
        if (wave_status & 0x1000) { sndStreamPause(); sndSetMasterVol(1, 0.0f); }
    }
    if (InitFlag < 16) sndStep(2.0f);
    ++InitFlag;
    if (InitFlag >= 1001) InitFlag = 1000;
    bool show_pause = GetSaveData()->config.unk_35 == 0;
    mgCDrawPrim prim;
    prim.Initialize(NULL, NULL);
    prim.DepthTestEnable(0);
    prim.AlphaBlendEnable(0);
    prim.Bilinear(0);
    prim.ZMask(-1);
    prim.TextureMapEnable(1);
    prim.Begin(6);
    prim.Texture(backdrop);
    int shade = show_pause ? 64 : 128;
    prim.Color(shade, shade, shade, 128);
    prim.TextureCrd(0, 0);
    prim.Vertex(0, 0, 0);
    prim.TextureCrd(mgScreenWidth + 1, mgScreenHeight + 1);
    prim.Vertex(mgScreenWidth, mgScreenHeight, 0);
    prim.End();
    mgCTexture *skip = mgTexManager.GetTexture((char *)"skip", -1);
    if (skip != NULL && show_pause) {
        int width = LanguageCode == 3 ? 112 : 82;
        int height = PauseInfo.event_skip ? 46 : 22;
        int x = mgScreenWidth / 2 - width / 2;
        int y = mgScreenHeight / 2 - height / 2;
        prim.AlphaBlendEnable(1);
        prim.Begin(6);
        prim.Texture(skip);
        prim.Color(128, 128, 128, 128);
        prim.TextureCrd(0, 0);
        prim.Vertex(x, y, 0);
        prim.TextureCrd(width, height);
        prim.Vertex(x + width, y + height, 0);
        prim.End();
    }
    mgEndFrame(NULL);
    GamePad__2.UpDate();
    PadCtrl.Update(&GamePad__2);
    bool quit = InitFlag >= 18 && PadCtrl.Btn(21);
    if (PauseInfo.event_skip && PadCtrl.Btn(22)) { SkipEventStart(); quit = true; }
    if (quit) { PauseEnd(); return 0; }
    return 1;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nowload", PauseLoop__Fv);
#endif
void PauseCount() {
    PauseCancelCnt--;
    if (PauseCancelCnt < 0) {
        PauseCancelCnt = 0;
    }
}
#ifdef NONMATCHING
void SCElogoFade(int fade_out, mgCMemory *memory) {
    mgCMemory packet0, packet1, data0, data1;
    u_long128 *vif0 = memory->stAlloc64(0x2710);
    u_long128 *vif1 = memory->stAlloc64(0x2710);
    mgInitVif1Packet(vif0, vif1, 0x2710);
    packet0.stSetBuffer(memory->stAlloc64(0x2710), 0x2710);
    packet1.stSetBuffer(memory->stAlloc64(0x2710), 0x2710);
    mgSetPacketBuffer(&packet0, &packet1);
    data0.stSetBuffer(memory->stAlloc64(0x2710), 0x2710);
    data1.stSetBuffer(memory->stAlloc64(0x2710), 0x2710);
    mgSetDataBuffer(&data0, &data1, 1);
    mgTexManager.SetTableBuffer(10, 10, memory);
    mgTexManager.Initialize(mgGetTopVRAMAddress(), -1);
    memory->Align64();
    void *image = &memory->stack[memory->stack_used];
    if (!fade_out) {
        GamePad__2.WaitEnable();
        GamePad__2.UpDate();
        TitleLangSelInit(memory);
        int language;
        do {
            mgBeginFrame(NULL);
            language = TitleLangSelKey();
            TitleLangSelDraw();
            GamePad__2.UpDate();
            mgEndFrame(NULL);
        } while (language <= 0);
        LanguageCode = language;
        char path[0x80];
        sprintf(path, "title/title%d.img", language);
        int image_size;
        if (LoadFile2(path, image, &image_size, 0)) {
            mgTexManager.EnterIMGFile((unsigned char *)image, 0, NULL, NULL);
            memory->Alloc(image_size / 16 + 1);
        }
        start_vcount = mgGetVSyncCount();
    } else {
        int remaining = start_vcount + 300 - mgGetVSyncCount();
        if (remaining > 0 && remaining < 300) {
            for (int frame = 0; frame < 65; ++frame) sceGsSyncV(0);
        }
    }
    for (int frame = 0; frame < 23; ++frame) {
        mgBeginFrame(NULL);
        mgTexManager.ReloadTexture(0, (sceVif1Packet *)NULL);
        mgCTexture *logo = mgTexManager.GetTexture((char *)"moji", -1);
        mgCDrawPrim prim;
        prim.Initialize(NULL, NULL);
        prim.AlphaBlendEnable(1);
        prim.TextureMapEnable(1);
        prim.Begin(6);
        int opacity = frame * 128 / 20;
        if (opacity > 128) opacity = 128;
        prim.Color(128, 128, 128, fade_out ? 128 - opacity : opacity);
        prim.Texture(logo);
        prim.TextureCrd(0, 324);
        prim.Vertex(0, 176, 0);
        prim.TextureCrd(512, 384);
        prim.Vertex(512, 236, 0);
        prim.End();
        mgEndFrame(NULL);
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nowload", SCElogoFade__FiP9mgCMemory);
#endif

// Static initialiser (.init)
#ifndef NONMATCHING
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nowload", __sinit_nowload_cpp);
#endif

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
#ifndef NONMATCHING
INCLUDE_BSS(ProgBarWidth, 0x4);
#endif
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
#ifndef NONMATCHING
INCLUDE_BSS(start_vcount, 0x4);
#endif

// Uninitialised data (.bss)
#ifndef NONMATCHING
INCLUDE_BSS(ThreadStack__3, 0x1000);
#endif
#ifndef NONMATCHING
INCLUDE_BSS(LoadInfo, 0x40);
#endif
INCLUDE_BSS(SkipImage, 0x2800);
INCLUDE_BSS(bgm_status, 0x20);
