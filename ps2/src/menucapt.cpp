#include "sound.hpp"
#include "dataread.hpp"
#include "prespr.hpp"
#include "mg_drawprim.hpp"
#include <cstdio>
#include <cstring>
#include "font.hpp"
#include "sysmes.hpp"
#include "scenesnd.hpp"
#include "savedata.hpp"
#include "userdata.hpp"
#include "gamedata.hpp"
#include "scriptinterpreter.hpp"
#include "mg_math.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "mainloop.hpp"
#include "menucls1.hpp"
#include "menucommon.hpp"
#include "menudraw.hpp"
#include "menusys.hpp"
#include "menumain.hpp"
#include "common.h"
#include "menucapt.hpp"

extern "C" int StreamPlay__6CSoundFi(void *, int);
extern "C" void *__ct__11mgCDrawPrimFv(void *prim);

extern MENU_CHAPTER_INFO *MenuChapterInfo;
extern u32 MenuChapterMode;
extern u32 MenuChapterSnd_ID;
extern signed char init_919;
extern signed char init_922;
extern int menu_chap_error_check_cnt;
extern int menu_snd_counter;
extern u32 voiceflag_921;
extern u32 wait_cnt_918;
extern mgCTexture *MenuChapterBG;
extern mgCTexture *MenuChapter_Logo;
extern CSound CSnd;
extern "C" int fptosi(float value);
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mg_drawprim.hpp"
#include "mg_tanime.hpp"
#include "mglib.hpp"
#include "menucommon.hpp"
#include "menudraw.hpp"
#include "menumain.hpp"
#include "mainloop.hpp"
#include "scenesnd.hpp"
#include "sound.hpp"
#include "snd_mngr.hpp"
#include "dataread.hpp"

#include <cstdio>
#include <cstring>

#ifdef NONMATCHING
static int MenuChapterMode;
static MENU_CHAPTER_INFO *MenuChapterInfo;
static mgCTexture *MenuChapterBG;
static mgCTexture *MenuChapter_Logo;
static unsigned int MenuChapterSnd_ID;
static int menu_snd_counter;
static int menu_chap_error_check_cnt;
static int wait_cnt_918;
static int init_919;
static int voiceflag_921;
static int init_922;
static mgCMemory MenuChapterStack;
static char *chap_voice_851[8] = {
    (char *)"0060600.wav", (char *)"0270310.wav", (char *)"0360260.wav", (char *)"0420120.wav",
    (char *)"0500010.wav", (char *)"0600360.wav", (char *)"0700010.wav", (char *)"0800140.wav"
};
#endif

// Code (.text)
#ifdef NONMATCHING
void MenuChapterInit(mgCMemory *stack, int *tex_block, int open_type, int chapter) {
    char image_path[96];
    char voice_path[140];
    int file_size;
    MenuChapterStack.stSetBuffer(stack->stack + stack->stack_used, stack->stack_size - stack->stack_used);
    MenuChapterInfo = (MENU_CHAPTER_INFO *)MenuChapterStack.Alloc(2);
    MenuChapterInfo->tex_block[0] = tex_block[0];
    MenuChapterInfo->tex_block[1] = tex_block[1];
    MenuChapterInfo->logo_alpha = 0.0f;
    sprintf(image_path, "chap%d.img", chapter);
    MenuChapterStack.Align64();
    u_long128 *image_buffer = MenuChapterStack.stack + MenuChapterStack.stack_used;
    file_size = LoadFileMenu(image_path, image_buffer, 1);
    if (file_size <= 0) {
        file_size = LoadFileMenu((char *)"chap0.img", image_buffer, 1);
    }
    MenuChapterStack.Alloc((file_size + 15) >> 4);
    mgTexManager.EnterIMGFile((unsigned char *)image_buffer, MenuChapterInfo->tex_block[0], 0, 0);
    MenuChapterBG = mgTexManager.GetTexture((char *)"chapbg", -1);
    MenuChapter_Logo = mgTexManager.GetTexture((char *)"chaplogo", -1);

    mgCMemory sound_memory;
    sound_memory.stSetBuffer(MenuChapterStack.stack + MenuChapterStack.stack_used, 0x280);
    MenuChapterStack.Alloc(0x280);
    MenuChapterStack.Align64();
    menu_snd_counter = 0;
    unsigned int *sound_buffer = (unsigned int *)(MenuChapterStack.stack + MenuChapterStack.stack_used);
    LoadFile2((char *)"snd2/sp/SP_007.snd", sound_buffer, &file_size, 0);
    MenuChapterStack.Alloc((file_size + 15) >> 4);
    sndInitPort(8);
    MenuChapterSnd_ID = sndLoadSound(8, sound_buffer, &sound_memory);
    strcpy(voice_path, chap_voice_851[chapter]);
    CSnd.StreamOpenFast(1, voice_path);
    while (CSnd.StreamOpenState() != 0) {}
    CSnd.StreamStandBy(1);
    while (CSnd.StreamOpenState() != 0) {}
    MenuChapterMode = MENU_CHAPTER_MODE_FADE_IN;
    MenuMainScene->fade.FadeIn(30);
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menucapt", MenuChapterInit__FP9mgCMemoryPiii);
#endif
int MenuChapterKey(void) {
    int fadeDone;
    int voiceState;
    int finished;
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
    fadeDone = fade->FadeCheck();
    switch (MenuChapterMode) {
        case MENU_CHAPTER_MODE_FADE_IN:
            if (fadeDone != 0) {
                menu_snd_counter += 1;
                if (menu_snd_counter == 2) {
                    CSnd.StreamSetVol(1, 0x7FFF, 0x7FFF);
                    StreamPlay__6CSoundFi(&CSnd, 1);
                    wait_cnt_918 = 0;
                }

                if (CalcMenuAdd((float *)((unsigned int)MenuChapterInfo + 0x1C), 3.0f, 128.0f) != 0) {
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
            voiceState = CSnd.StreamGetState(1);
            if (voiceState == 0x8000 || menu_chap_error_check_cnt > 0x5DC) {
                voiceflag_921 = 1;
            }
            if ((voiceflag_921 != 0) && (voiceState == 0)) {
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
                (&MenuMainScene->fade)->FadeOut(0x3C, 0.0f, 0.0f, 0.0f);
                MenuChapterMode = MENU_CHAPTER_MODE_FADE_OUT;
            }
            break;
        case MENU_CHAPTER_MODE_FADE_OUT:
            if (fadeDone != 0) {
                finished = 1;
            }
            break;
    }
    return finished;
}
void MenuChapterDraw(void) {
    struct {
        mgCDrawPrim prim;
        u8 pad[0x10];
    } block;
    volatile mgRect<int> origin;
    mgRect<int> screenRect;
    mgRect<int> texRect;
    mgRect<int> logoRect;
    mgRect<int> shadeRect;

    (&mgTexManager)
        ->ReloadTexture(MenuChapterInfo->tex_block[0], (sceVif1Packet *)0);
    DrawMenuFillBox(0x80, 0, 0, 0);
    __ct__11mgCDrawPrimFv(&block.prim);
    origin.left = 0;
    origin.top = 0;
    SetSpriteEnv(&block.prim, 0);
    block.prim.Begin(6);
    if (MenuChapterBG != 0) {
        block.prim.Texture(MenuChapterBG);
        block.prim.Color(0x80, 0x80, 0x80, 0x80);
        texRect.Set(0, 0, 0x200, 0x1C0);
        screenRect.Set(0, 0, 0x200, mgScreenHeight);
        PrimQuad(&block.prim, screenRect, texRect);
    }
    if (MenuChapter_Logo != 0) {
        block.prim.Texture(MenuChapter_Logo);
        block.prim.Color(0x80, 0x80, 0x80, fptosi(MenuChapterInfo->logo_alpha));
        logoRect.Set(0, 0, 0x200, 0x40);
        PrimQuad(&block.prim, 0.0f, ((float)mgScreenHeight / 2.0f - 32.0f) - 12.0f, logoRect);
        block.prim.Color(0x80, 0x80, 0x80, 0x80);
        shadeRect.Set(0, 0x40, 0x200, 0x40);
        PrimQuad(&block.prim, 0.0f, 0.0f, shadeRect);
    }
    block.prim.End();
}

// Static initialiser (.init)
#ifndef NONMATCHING
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menucapt", __sinit_menucapt_cpp);
#endif

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menucapt", chap_voice_851__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menucapt", at_852__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menucapt", at_853__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menucapt", at_854__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menucapt", at_855__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menucapt", at_856__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menucapt", at_857__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menucapt", at_858__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menucapt", at_859__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menucapt", at_902__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menucapt", at_903__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menucapt", at_904__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menucapt", at_905__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menucapt", at_906__5__DATA);

// Static initialiser table (.ctor)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menucapt", D_0037B054__DATA);

// Small uninitialised data (.sbss)
#ifndef NONMATCHING
INCLUDE_BSS(MenuChapterMode, 0x4);
INCLUDE_BSS(MenuChapterInfo, 0x4);
INCLUDE_BSS(MenuChapterBG, 0x4);
INCLUDE_BSS(MenuChapter_Logo, 0x4);
INCLUDE_BSS(MenuChapterSnd_ID, 0x4);
INCLUDE_BSS(menu_snd_counter, 0x4);
INCLUDE_BSS(menu_chap_error_check_cnt, 0x4);
INCLUDE_BSS(wait_cnt_918, 0x4);
INCLUDE_BSS(init_919, 0x4);
INCLUDE_BSS(voiceflag_921, 0x4);
INCLUDE_BSS(init_922, 0x4);
#endif

// Uninitialised data (.bss)
#ifndef NONMATCHING
INCLUDE_BSS(MenuChapterStack, 0x30);
#endif
