#include "common.h"

#include <eekernel.h>

#include <cstdio>
#include <cstring>

#include "dataread.hpp"
#include "event.hpp"
#include "gamepad.hpp"
#include "mainloop.hpp"
#include "menucommon.hpp"
#include "mg_drawprim.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "nowload.hpp"
#include "padcontrol.hpp"
#include "savedata.hpp"
#include "scenesnd.hpp"
#include "snd_mngr.hpp"
#include "sound.hpp"
#include "title.hpp"

/**
 *
 * Pause information initialized without an active scene or event skip.
 *
 */
struct PauseState : PAUSE_INFO {
    /**
     *
     * Clears the pause scene and event skip state.
     *
     */
    PauseState() {
        scene = NULL;
        event_skip = 0;
    }
};

/**
 *
 * Memory and progress settings of the active loading screen.
 *
 */
static NowLoadingInfo LoadInfo;

#ifdef NONMATCHING
#include "mg_tanime.hpp"
#endif

/**
 *
 * Current stage of the loading-screen thread.
 *
 */
static int LoopStep = NOW_LOADING_STEP_NONE;

/**
 *
 * ID of the loading-screen thread.
 *
 */
static int TheadID__3;

/**
 *
 * Current loading progress bar width as a ratio.
 *
 */
static float ProgBarWidth;

/**
 *
 * Per-frame increase of the loading progress bar ratio.
 *
 */
static float ProgBarWidthStep;

/**
 *
 * Target loading progress bar width as a ratio.
 *
 */
static float NextProgBarWidth;

/**
 *
 * Number of completed loading progress steps.
 *
 */
static int ProgBarCnt;

/**
 *
 * Whether loading-screen shutdown has been requested.
 *
 */
static int EndFlag;

/**
 *
 * Whether the next loading-screen request is ignored.
 *
 */
static int cancel_now_loading;

/**
 *
 * Whether the pause skip image has been loaded.
 *
 */
static int load_skip_img;

/**
 *
 * Whether the pause screen is active.
 *
 */
static int PauseFlag__2;

/**
 *
 * Whether the game may enter the pause screen.
 *
 */
static int PauseEnableFlag;

/**
 *
 * Remaining frames before another pause is allowed.
 *
 */
static int PauseCancelCnt;

/**
 *
 * Texture block containing the pause screen images.
 *
 */
static int PauseTexb;

/**
 *
 * Scene and event-skip settings of the active pause screen.
 *
 */
static PauseState PauseInfo;

/**
 *
 * Elapsed pause-screen frames, capped at one thousand.
 *
 */
static int InitFlag;

/**
 *
 * Master sound volume saved when the game pauses.
 *
 */
static float SeCoreVol;

/**
 *
 * Play-time counting flag saved when the game pauses.
 *
 */
static int play_time_count;

/**
 *
 * Stream playback status saved when the game pauses.
 *
 */
static int wave_status;

/**
 *
 * VSync count recorded when the boot logo fades in.
 *
 */
static int start_vcount;

/**
 *
 * Stack memory for the loading-screen thread.
 *
 */
static u8 ThreadStack__3[0x1000];

/**
 *
 * Loaded skip-button image data for the pause screen.
 *
 */
static u8 SkipImage[0x2800];

/**
 *
 * Music status words whose first word controls pause-end replay.
 *
 */
static int bgm_status[7];

// Code (.text)
void SwitchNowLoadingThread() {
    RotateThreadReadyQueue(10);
}

/**
 *
 * Draws the loading image and progress bar until the main thread requests shutdown.
 *
 */
void NowLoadingLoop(void *unused) {
    mgRect<int> image_rect(0, 0, 256, 192);
    int         image_y = mgScreenHeight - 186;

    if (LanguageCode > 0 && LanguageCode < 6) {
        image_y -= 20;
    }

    int bar_y = image_y + 158;

    for (;;) {
        if (LoopStep == NOW_LOADING_STEP_START) {
            LoopStep = NOW_LOADING_STEP_DRAW;
        } else if (LoopStep == NOW_LOADING_STEP_DRAW) {
            for (;;) {
                mgSetBackGround(0.0f, 0.0f, 0.0f, 0.0f);
                mgBeginFrame(NULL);
                mgTexManager.ReloadTexture(LoadInfo.tex_block, (sceVif1Packet *) NULL);
                mgCTexture *loading = mgTexManager.GetTexture("loading", LoadInfo.tex_block);
                mgCDrawPrim prim;
                prim.Initialize(NULL, NULL);
                prim.DepthTestEnable(0);
                prim.AlphaBlendEnable(1);
                prim.ZMask(MG_Z_MASK_WRITE);
                prim.TextureMapEnable(0);
                prim.Shading(1);
                prim.AntiAliasing(1);
                prim.Begin(MG_PRIM_TRIANGLE_STRIP);
                float        x_local = 91.0f;
                const float &x_value = x_local;
                float        top_y;
                float        end_x;
                float        bottom_y;
                top_y = 0.0f;
                top_y = (float) bar_y + top_y;
                end_x = x_value + 157.0f * ProgBarWidth;
                bottom_y = top_y;
                bottom_y += 5.0f;
                prim.Color(40, 100, 255, 128);
                prim.Vertex(91.0f, top_y, 0.0f);
                prim.Vertex(end_x, top_y, 0.0f);
                prim.Color(5, 20, 50, 128);
                prim.Vertex(91.0f, bottom_y, 0.0f);
                prim.Vertex(end_x, bottom_y, 0.0f);
                prim.End();
                prim.TextureMapEnable(1);
                prim.AntiAliasing(0);
                prim.Bilinear(0);
                prim.Begin(MG_PRIM_SPRITE);
                prim.Color(128, 128, 128, 128);
                prim.Texture(loading);
                prim.TextureCrd(image_rect.left, image_rect.top);
                prim.Vertex(50, image_y, 0);
                prim.TextureCrd(image_rect.right, image_rect.bottom);
                prim.Vertex(image_rect.right + 50 - image_rect.left, image_y + image_rect.bottom - image_rect.top, 0);
                prim.End();
                ProgBarWidth += ProgBarWidthStep;

                if (!(ProgBarWidth <= NextProgBarWidth)) {
                    ProgBarWidth = NextProgBarWidth;
                }

                mgSetRotateThread(10);
                mgEndFrame(NULL);
                mgSetRotateThread(-1);

                if (EndFlag && !(ProgBarWidth < 1.0f)) {
                    LoopStep = NOW_LOADING_STEP_END;
                    SwitchNowLoadingThread();
                    break;
                }

                SwitchNowLoadingThread();
            }
        } else if (LoopStep == NOW_LOADING_STEP_END) {
            LoopStep = NOW_LOADING_STEP_END;
        }

        SwitchNowLoadingThread();
    }
}

void CancelNowLoading() {
    cancel_now_loading = 1;
}

/**
 *
 * Twelve words of loading screen data copied as floats.
 *
 */
struct LoadingMemoryWords {
    float words[12]; /**< Loading screen words. */
};

void CreateNowLoading(NowLoadingInfo *info) {
    char name[0x40];
    char path[0x40];

    struct {
        ThreadParam param;
        int         reserved[4];
    } thread;

    int        size;
    u32        length;
    mgCMemory *memory;
    u8        *buffer;
    int        language;
    LoopStep = -1;

    if (cancel_now_loading != 0) {
        cancel_now_loading = 0;
        return;
    }

    LoadInfo.tex_block = info->tex_block;
    LoadInfo.unk_4 = info->unk_4;
    memory = &LoadInfo.memory;
    *(LoadingMemoryWords *) memory = *(LoadingMemoryWords *) &info->memory;
    language = LanguageCode;
    LoadInfo.step_count = info->step_count;
    buffer = reinterpret_cast<u8 *>(memory->stGetTop());

    if (language > 0 && language < 6) {
        language = 2;
    }

    sprintf(name, "img/%d/", language);
    strcpy(path, name);
    strcat(path, "loading.img");

    if (LoadFile2(path, buffer, &size, 0) != 0) {
        u32 blocks;

        if ((u32) size & 0xF) {
            blocks = ((u32) size >> 4) + 1;
        } else {
            blocks = (u32) size >> 4;
        }

        memory->Alloc(blocks);
        mgTexManager.EnterIMGFile(buffer, LoadInfo.tex_block, memory, 0);
        ProgBarWidthStep = 0.2f / (float) LoadInfo.step_count;
        ProgBarWidth = 0;
        ProgBarCnt = 0;
        NextProgBarWidth = 0;
        LoopStep = 0;
        thread.param.entry = NowLoadingLoop;
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

    NextProgBarWidth = (float) (ProgBarCnt + 1) / (float) LoadInfo.step_count;

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
    int  size;
    u8   data[0x10000];
    char path[0x40];

    if (LanguageCode > 1) {
        sprintf(path, "img/%d/skip.img", LanguageCode);

        if (LoadFile2(path, data, &size, 0) == 0) {
            return 0;
        }
    } else if (LoadFile2("img/skip.img", data, &size, 0) == 0) {
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
    tex->EnterTexture(block, "pause_work", 0, mgScreenWidth, mgScreenHeight, 0x20, 0, 0, 0);

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

int PauseStart(PAUSE_INFO *info) {
    int result = 1;

    if (PauseEnableFlag == 0) {
        return 0;
    }

    if (PauseCancelCnt > 0) {
        return 0;
    }

    InitFlag = 0;
    PauseFlag__2 = result;
    PauseCancelCnt = 10;
    static_cast<PAUSE_INFO &>(PauseInfo) = *info;
    SeCoreVol = -1.0f;
    return result;
}

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

    if ((wave_status & (int) SND_STREAM_STATE_PLAYING) != 0) {
        sndStreamRePlay();
    }

    sndPortSqReplay((int) SND_PORT_EVENT);
    sndPortSqReplay((int) SND_PORT_BGM);
    PlayTimeCount(play_time_count);

    if (SeCoreVol >= 0.0f) {
        sndMasterVolFadeInOut(1, 15, SeCoreVol, 0.0f);
    }

    sndSePlay(GetSystemSndID(), 0x19, 0);
}

int PauseLoop() {
    if (!PauseFlag__2) {
        return 0;
    }

    mgCTextureManager *tex = &mgTexManager;
    mgBeginFrame(NULL);
    tex->ReloadTexture(PauseTexb, (sceVif1Packet *) NULL);
    mgCTexture *backdrop = tex->GetTexture("pause_work", -1);

    if (InitFlag == 0) {
        sndSePlay(GetSystemSndID(), 25, 0);
        SeCoreVol = sndGetMasterVol(1);

        sndMasterVolFadeInOut(1, 15, 0.0f, -1.0f);
        sndPortSqPause((int) SND_PORT_EVENT);
        sndPortSqPause((int) SND_PORT_BGM);
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

        if (wave_status & (int) SND_STREAM_STATE_PLAYING) {
            sndStreamPause();
            sndSetMasterVol(1, 0.0f);
        }
    }

    if (InitFlag <= 15) {
        sndStep(2.0f);
    }

    ++InitFlag;

    if (InitFlag > 1000) {
        InitFlag = 1000;
    }

    SV_CONFIG_OPTION *config = &GetSaveData()->config;
    mgCDrawPrim       prim;
    prim.Initialize(NULL, NULL);
    prim.DepthTestEnable(0);
    prim.AlphaBlendEnable(0);
    prim.Bilinear(0);
    prim.ZMask(MG_Z_MASK_MASKED);
    prim.TextureMapEnable(1);
    prim.Begin(MG_PRIM_SPRITE);
    prim.Texture(backdrop);

    if (config->pause_overlay_off == 0) {
        prim.Color(64, 64, 64, 128);
    } else {
        prim.Color(128, 128, 128, 128);
    }

    prim.TextureCrd(0, 0);
    prim.Vertex(0, 0, 0);
    prim.TextureCrd(mgScreenWidth + 1, mgScreenHeight + 1);
    prim.Vertex(mgScreenWidth, mgScreenHeight, 0);
    prim.End();
    mgCTexture *skip = tex->GetTexture("skip", -1);

    if (skip != NULL && config->pause_overlay_off == 0) {
        int width = 82;
        int height = 22;

        if (LanguageCode == 3) {
            width = 112;
        }

        if (PauseInfo.event_skip == 1) {
            height = 46;
        }

        int x = mgScreenWidth / 2 - width / 2;
        int y = mgScreenHeight / 2 - height / 2;
        prim.AlphaBlendEnable(1);
        prim.Begin(MG_PRIM_SPRITE);
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
    int quit = 0;

    if (InitFlag > 17 && PadCtrl.Btn(PAD_BTN_PAUSE)) {
        quit = 1;
    }

    if (PauseInfo.event_skip == 1 && PadCtrl.Btn(PAD_BTN_EVENT_SKIP)) {
        SkipEventStart();
        quit = 1;
    }

    if (quit) {
        PauseEnd();
        return 0;
    }

    return 1;
}

void PauseCount() {
    PauseCancelCnt--;

    if (PauseCancelCnt < 0) {
        PauseCancelCnt = 0;
    }
}

#pragma opt_strength_reduction off

void SCElogoFade(int fade_out, mgCMemory *memory) {
    mgCMemory  packet0, packet1, data0, data1;
    u_long128 *vif0 = memory->stAlloc64(0x2710);
    u_long128 *vif1 = memory->stAlloc64(0x2710);
    mgInitVif1Packet(vif0, vif1, 0x27100);
    packet0.stSetBuffer(memory->stAlloc64(0x2710), 0x2710);
    packet1.stSetBuffer(memory->stAlloc64(0x2710), 0x2710);
    mgSetPacketBuffer(&packet0, &packet1);
    data0.stSetBuffer(memory->stAlloc64(0x2710), 0x2710);
    u_long128        *data1_buffer = memory->stAlloc64(0x2710);
    mgCMemory        *data1_pointer = &data1;
    mgCMemory *const &data1_memory = data1_pointer;
    data1_memory->stSetBuffer(data1_buffer, 0x2710);
    mgSetDataBuffer(&data0, data1_memory, 1);
    mgCTextureManager *tex = &mgTexManager;
    tex->SetTableBuffer(10, 10, memory);
    tex->Initialize(mgGetTopVRAMAddress(), -1);
    memory->Align64();
    int   language;
    void *image = &memory->stack[memory->stack_used];

    if (!fade_out) {
        GamePad__2.WaitEnable();
        GamePad__2.UpDate();
        TitleLangSelInit(memory);

        do {
            mgBeginFrame(NULL);
            language = TitleLangSelKey();
            TitleLangSelDraw();
            GamePad__2.UpDate();
            mgEndFrame(NULL);
        } while (!(0 < language));

        LanguageCode = language;
        char path[0x80];
        sprintf(path, "title/title%d.img", language);
        int image_size;

        if (LoadFile2(path, image, &image_size, 0)) {
            tex->EnterIMGFile((unsigned char *) image, 0, NULL, NULL);
            memory->Alloc(image_size / 16 + 1);
        }

        start_vcount = mgGetVSyncCount();
    } else {
        int end_count = start_vcount + 300;
        int remaining = end_count - mgGetVSyncCount();

        if (remaining > 0 && remaining < 300) {
            for (int frame = 0; frame < 65; ++frame) {
                sceGsSyncV(0);
            }
        }
    }

    int         frame;
    mgCTexture *logo;
    int         opacity_value;
    frame = 0;
    opacity_value = 0;

    for (; frame <= 22; ++frame, opacity_value += 128) {
        mgBeginFrame(NULL);
        tex->ReloadTexture(0, (sceVif1Packet *) NULL);
        logo = tex->GetTexture("moji", -1);
        mgCDrawPrim prim;
        prim.Initialize(NULL, NULL);
        prim.AlphaBlendEnable(1);
        prim.TextureMapEnable(1);
        prim.Begin(MG_PRIM_SPRITE);
        int opacity = opacity_value / 20;

        if (opacity > 128) {
            opacity = 128;
        }

        if (fade_out) {
            prim.Color(128, 128, 128, 128 - opacity);
        } else {
            prim.Color(128, 128, 128, opacity);
        }

        prim.Texture(logo);
        prim.TextureCrd(0, 324);
        prim.Vertex(0, 176, 0);
        prim.TextureCrd(512, 384);
        prim.Vertex(512, 236, 0);
        prim.End();
        mgEndFrame(NULL);
    }
}

#pragma opt_strength_reduction reset
