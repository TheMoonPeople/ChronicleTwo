#include "common.h"
#include "mw_runtime.h"

#include <cstdio>
#include <cstring>

#include "dataread.hpp"
#include "font.hpp"
#include "gamedata.hpp"
#include "mainloop.hpp"
#include "menucapt.hpp"
#include "menucls1.hpp"
#include "menucommon.hpp"
#include "menudraw.hpp"
#include "menumain.hpp"
#include "menusys.hpp"
#include "mg_drawprim.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mg_tanime.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "prespr.hpp"
#include "savedata.hpp"
#include "scenesnd.hpp"
#include "scriptinterpreter.hpp"
#include "snd_mngr.hpp"
#include "sound.hpp"
#include "sysmes.hpp"
#include "userdata.hpp"

/**
 *
 * Chapter title fade and display mode.
 *
 */
static u32 MenuChapterMode;

/**
 *
 * Chapter title texture blocks, display counter and logo opacity.
 *
 */
static MENU_CHAPTER_INFO *MenuChapterInfo;

/**
 *
 * Background texture for the chapter title.
 *
 */
static mgCTexture *MenuChapterBG;

/**
 *
 * Logo texture for the chapter title.
 *
 */
static mgCTexture *MenuChapter_Logo;

/**
 *
 * Loaded chapter sound bank ID.
 *
 */
static u32 MenuChapterSnd_ID;

/**
 *
 * Frame counter for chapter narration and sound playback.
 *
 */
static int menu_snd_counter;

/**
 *
 * Elapsed frames used to time out chapter narration.
 *
 */
static int menu_chap_error_check_cnt;

/**
 *
 * Chapter narration wait counter.
 *
 */
static u32 wait_cnt_918;

/**
 *
 * Whether the chapter narration wait counter has been initialized.
 *
 */
static signed char init_919;

/**
 *
 * Whether chapter narration has finished or timed out.
 *
 */
static u32 voiceflag_921;

/**
 *
 * Whether chapter narration completion state has been initialized.
 *
 */
static signed char init_922;

/**
 *
 * Memory stack reserved for chapter images, sound and display state.
 *
 */
static mgCMemory MenuChapterStack;

/**
 *
 * Narration stream filenames for the eight chapter titles.
 *
 */
static char *chap_voice_851[8] = {
    "0060600.wav",
    "2070310.wav",
    "3060260.wav",
    "4020120.wav",
    "5000010.wav",
    "6000360.wav",
    "7000010.wav",
    "8000140.wav",
};

// Code (.text)
void MenuChapterInit(mgCMemory *stack, int *tex_block, int open_type, int chapter) {
    char image_path[96];

    union {
        mgCMemory sound_memory;
    };

    char       voice_path[140];
    u_int      file_size;
    int        remaining = stack->stGetRest();
    u_long128 *buffer = stack->stGetTop();
    MenuChapterStack.stSetBuffer(buffer, remaining);
    MenuChapterInfo = (MENU_CHAPTER_INFO *) MenuChapterStack.Alloc(2);
    MenuChapterInfo->tex_block[0] = tex_block[0];
    MenuChapterInfo->tex_block[1] = tex_block[1];
    MenuChapterInfo->logo_alpha = 0.0f;
    sprintf(image_path, "chap%d.img", chapter);
    MenuChapterStack.Align64();
    u_long128 *image_buffer = MenuChapterStack.stack + MenuChapterStack.stack_used;
    file_size = LoadFileMenu(image_path, image_buffer, 1);

    if ((int) file_size <= 0) {
        file_size = LoadFileMenu("chap0.img", image_buffer, 1);
    }

    u_int blocks;

    if (file_size & 0xF) {
        blocks = (file_size >> 4) + 1;
    } else {
        blocks = file_size >> 4;
    }

    MenuChapterStack.Alloc(blocks);
    mgTexManager.EnterIMGFile((unsigned char *) image_buffer, MenuChapterInfo->tex_block[0], 0, 0);
    MenuChapterBG = mgTexManager.GetTexture("chapbg", -1);
    MenuChapter_Logo = mgTexManager.GetTexture("chaplogo", -1);

    sound_memory.Init();
    sound_memory.stSetBuffer(MenuChapterStack.stack + MenuChapterStack.stack_used, 0x280);
    MenuChapterStack.Alloc(0x280);
    MenuChapterStack.Align64();
    menu_snd_counter = 0;
    unsigned int *sound_buffer = (unsigned int *) (MenuChapterStack.stack + MenuChapterStack.stack_used);
    LoadFile2((char *) "snd2/sp/SP_007.snd", sound_buffer, (int *) &file_size, 0);

    if (file_size & 0xF) {
        blocks = (file_size >> 4) + 1;
    } else {
        blocks = file_size >> 4;
    }

    MenuChapterStack.Alloc(blocks);
    sndInitPort(8);
    MenuChapterSnd_ID = sndLoadSound(8, sound_buffer, &sound_memory);
    strcpy(voice_path, chap_voice_851[chapter]);
    CSnd.StreamOpenFast(1, voice_path);

    if (CSnd.StreamOpenState() != 0) {
        while (CSnd.StreamOpenState() != 0) {
        }
    }

    CSnd.StreamStandBy(1);

    if (CSnd.StreamOpenState() != 0) {
        while (CSnd.StreamOpenState() != 0) {
        }
    }

    MenuChapterMode = MENU_CHAPTER_MODE_FADE_IN;
    MenuMainScene->fade.FadeIn(30);
}

int MenuChapterKey() {
    int         fade_done;
    int         voice_state;
    int         finished;
    CFadeInOut *fade;

    finished = 0;

    if (init_919 == 0) {
        wait_cnt_918 = 0;
        init_919 = 1;
    }

    if (init_922 == 0) {
        voiceflag_921 = 0;
        init_922 = 1;
    }

    fade = &MenuMainScene->fade;
    fade_done = fade->FadeCheck();

    switch (MenuChapterMode) {
        case MENU_CHAPTER_MODE_FADE_IN:
            if (fade_done != 0) {
                menu_snd_counter += 1;

                if (menu_snd_counter == 2) {
                    CSnd.StreamSetVol(1, 0x7FFF, 0x7FFF);
                    CSnd.StreamPlay(1);
                    wait_cnt_918 = 0;
                }

                if (CalcMenuAdd(&MenuChapterInfo->logo_alpha, 3.0f, 128.0f) != 0) {
                    MenuChapterMode = MENU_CHAPTER_MODE_SHOW;
                    MenuChapterInfo->show_cnt = 0;
                    menu_snd_counter = 0;
                    menu_chap_error_check_cnt = 0;
                    voiceflag_921 = 0;
                }
            }

            break;
        case MENU_CHAPTER_MODE_SHOW:
            MenuChapterInfo->show_cnt += 1;
            menu_chap_error_check_cnt += 1;
            voice_state = CSnd.StreamGetState(1);

            if (voice_state == 0x8000 || menu_chap_error_check_cnt > 0x5DC) {
                voiceflag_921 = 1;
            }

            if ((voiceflag_921 != 0) && (voice_state == 0)) {
                if (menu_snd_counter == 0) {
                    CSnd.StreamStop(1);
                    CSnd.StreamClose(1);
                }

                menu_snd_counter += 1;
            }

            if (menu_snd_counter == 0x24) {
                sndSePlay(MenuChapterSnd_ID, 0, 0);
            }

            if ((MenuChapterInfo->show_cnt > 0x12C) &&
                (menu_snd_counter >= 0x15A)) {
                MenuMainScene->fade.FadeOut(0x3C, 0.0f, 0.0f, 0.0f);
                MenuChapterMode = MENU_CHAPTER_MODE_FADE_OUT;
            }

            break;
        case MENU_CHAPTER_MODE_FADE_OUT:
            if (fade_done != 0) {
                finished = 1;
            }

            break;
    }

    return finished;
}

void MenuChapterDraw() {
    mgTexManager.ReloadTexture(MenuChapterInfo->tex_block[0], (sceVif1Packet *) 0);
    DrawMenuFillBox(128, 0, 0, 0);
    mgCDrawPrim prim;
    mgRect<int> screen;
    mgRect<int> source;
    mgRect<int> title;
    prim.offset_x = 0;
    prim.offset_y = 0;
    SetSpriteEnv(&prim, 0);
    prim.Begin(MG_PRIM_SPRITE);

    if (MenuChapterBG != 0) {
        prim.Texture(MenuChapterBG);
        prim.Color(128, 128, 128, 128);
        source.Set(0, 0, 512, 448);
        screen.Set(0, 0, 512, mgScreenHeight);
        PrimQuad(&prim, screen, source);
    }

    if (MenuChapter_Logo != 0) {
        prim.Texture(MenuChapter_Logo);
        prim.Color(128, 128, 128, fptosi(MenuChapterInfo->logo_alpha));
        mgRect<int> title(0, 0, 512, 64);
        float       height = (float) mgScreenHeight;
        float       half_height = height / 2.0f;
        float       top = half_height - 32.0f;
        PrimQuad(&prim, 0.0f, top - 12.0f, title);
        prim.Color(128, 128, 128, 128);
        mgRect<int> overlay(0, 64, 512, 64);
        PrimQuad(&prim, 0.0f, 0.0f, overlay);
    }

    prim.End();
}
