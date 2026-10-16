#include "common.h"

#include <algorithm>
#include <cstdio>

#include "dataread.hpp"
#include "menucapt.hpp"
#include "menucommon.hpp"
#include "menudraw.hpp"
#include "menumain.hpp"
#include "mg_drawprim.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "pal_timing.hpp"
#include "scene.hpp"
#include "snd_mngr.hpp"
#include "sound.hpp"

namespace {
mgCMemory          chapter_memory;
mgCMemory          sound_memory;
MENU_CHAPTER_INFO *chapter_info;
mgCTexture        *background;
mgCTexture        *logo;
unsigned int       sound_id;
MenuChapterModeID  mode;
int                sound_frames;
int                narration_frames;
bool               narration_finished;
} // namespace

PORT_OVERRIDE void MenuChapterInit(mgCMemory *stack, int *tex_block, int open_type, int chapter) {
    static const char *voices[] = {"sound/0060600.wav", "sound/2070310.wav", "sound/3060260.wav", "sound/4020120.wav",
                                   "sound/5000010.wav", "sound/6000360.wav", "sound/7000010.wav", "sound/8000140.wav"};
    chapter_memory.stSetBuffer(stack->stGetTop(), stack->stGetRest());
    chapter_info = new (chapter_memory.Alloc((sizeof(MENU_CHAPTER_INFO) + 15) / 16)) MENU_CHAPTER_INFO{};
    std::copy_n(tex_block, 2, chapter_info->tex_block);
    chapter_memory.Align64();
    char name[32];
    std::snprintf(name, sizeof(name), "chap%d.json", chapter);
    auto *image = chapter_memory.stGetTop();
    int   size = LoadFileMenu(name, image, MENU_FILE_LOAD_DIRECT);
    if (size <= 0) {
        char fallback[] = "chap0.json";
        size = LoadFileMenu(fallback, image, MENU_FILE_LOAD_DIRECT);
    }
    background = logo = nullptr;
    if (size > 0) {
        chapter_memory.Alloc((size + 15) / 16);
        mgTexManager.EnterIMGFile(reinterpret_cast<unsigned char *>(image), tex_block[0], nullptr, 0);
        background = mgTexManager.GetTexture("chapbg", -1);
        logo = mgTexManager.GetTexture("chaplogo", -1);
    }

    sound_memory.Init();
    sound_memory.stSetBuffer(chapter_memory.Alloc(0x280), 0x280);
    chapter_memory.Align64();
    auto *bank = chapter_memory.stGetTop();
    size = 0;
    char bank_name[] = "snd2/sp/sp_007.sound.json";
    LoadFile2(bank_name, bank, &size, LOAD_FILE_READ);
    sndInitPort(SND_PORT_MENU);
    sound_id = 0;
    if (size > 0) {
        chapter_memory.Alloc((size + 15) / 16);
        sound_id = sndLoadSound(SND_PORT_MENU, reinterpret_cast<unsigned int *>(bank), &sound_memory);
    }
    char voice[32];
    std::snprintf(voice, sizeof(voice), "%s", voices[std::clamp(chapter, 0, 7)]);
    CSnd.StreamOpenFast(1, voice);
    CSnd.StreamStandBy(1);
    sound_frames = narration_frames = 0;
    narration_finished = false;
    mode = MENU_CHAPTER_MODE_FADE_IN;
    MenuMainScene->fade.FadeIn(30);
}

PORT_OVERRIDE int MenuChapterKey() {
    if (!chapter_info) {
        return 0;
    }
    const bool fade_done = MenuMainScene->fade.FadeCheck() != 0;
    if (mode == MENU_CHAPTER_MODE_FADE_IN && fade_done) {
        if (++sound_frames == 2) {
            CSnd.StreamSetVol(1, 0x7FFF, 0x7FFF);
            CSnd.StreamPlay(1);
        }
        if (CalcMenuAdd(&chapter_info->logo_alpha, 3.0f, 128.0f)) {
            mode = MENU_CHAPTER_MODE_SHOW;
            sound_frames = narration_frames = 0;
            chapter_info->show_cnt = 0;
            narration_finished = false;
        }
    } else if (mode == MENU_CHAPTER_MODE_SHOW) {
        ++chapter_info->show_cnt;
        ++narration_frames;
        const int state = CSnd.StreamGetState(1);
        if (state == SND_STREAM_STATE_END || narration_frames > PAL_TIMING(1500, 1800)) {
            narration_finished = true;
        }
        if (narration_finished && state == 0) {
            if (sound_frames == 0) {
                CSnd.StreamStop(1);
                CSnd.StreamClose(1);
            }
            ++sound_frames;
        }
        if (sound_frames == 36) {
            sndSePlay(sound_id, 0, 0);
        }
        if (chapter_info->show_cnt > 300 && sound_frames >= PAL_TIMING(346, 406)) {
            MenuMainScene->fade.FadeOut(60, 0, 0, 0);
            mode = MENU_CHAPTER_MODE_FADE_OUT;
        }
    } else if (mode == MENU_CHAPTER_MODE_FADE_OUT) {
        return fade_done;
    }
    return 0;
}

PORT_OVERRIDE void MenuChapterDraw() {
    if (!chapter_info) {
        return;
    }
    mgTexManager.ReloadTexture(chapter_info->tex_block[0], static_cast<sceVif1Packet *>(nullptr));
    DrawMenuFillBox(128, 0, 0, 0);
    mgCDrawPrim prim;
    prim.offset_x = prim.offset_y = 0;
    SetSpriteEnv(&prim, MENU_SPRITE_ENV_TEXTURE);
    prim.Begin(MG_PRIM_SPRITE);
    if (background) {
        prim.Texture(background);
        prim.Color(128, 128, 128, 128);
        PrimQuad(&prim, mgRect<int>(0, 0, 512, mgScreenHeight), mgRect<int>(0, 0, 512, 448));
    }
    if (logo) {
        prim.Texture(logo);
        prim.Color(128, 128, 128, static_cast<int>(chapter_info->logo_alpha));
        PrimQuad(&prim, 0.0f, mgScreenHeight / 2.0f - 44.0f, mgRect<int>(0, 0, 512, 64));
        prim.Color(128, 128, 128, 128);
        PrimQuad(&prim, 0.0f, 0.0f, mgRect<int>(0, 64, 512, 64));
    }
    prim.End();
}
