#include "common.h"
#include "savedata.hpp"
#include "mg_memory.hpp"
#include "nd_meswin.hpp"
#include "gamepad.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "mainloop.hpp"
#include "snd_mngr.hpp"
#include "sound.hpp"
#include "title.hpp"
#include "dataread.hpp"
#include "hddinstall.hpp"
#include <cstdio>
#include <cstdlib>

extern s16 TitleOmakeFlag;

extern char at_1267[];
extern ClsMes *TitleMCCheckMes;
extern mgCTexture *lang_tex;
extern u32 title_lang_cursor_cnt;
extern int title_lang_fadealpha;
extern int title_lang_phase;
extern int title_lang_select;
extern char at_2723[];
extern char at_2724[];
extern float title_lang_curxy[2];

// Code (.text)
void title_init_rand() {
    srand(mgGetVSyncCount());
}
void SetSoundMode() {
    CSaveData *save = GetSaveData();
    if (save != NULL) {
        SV_CONFIG_OPTION *config = &save->config;
        if (config != NULL) {
            if (config->sound_mode == 0) {
                CSnd.SetStereoMode(1);
                return;
            }
        }
        CSnd.SetStereoMode(0);
    }
}

void InitTitleOmakeFlag(void) {
    TitleOmakeFlag = 0;
    OmakeFlag = 0;
}
void TitleOmakeOn(void) {
    TitleOmakeFlag = 1;
}
int CheckOmakeFlag(void) {
    return TitleOmakeFlag;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/title", InitOmakeEnv__FiP13INIT_LOOP_ARGPi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/title", TitleInit__F13INIT_LOOP_ARG);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/title", TitleBootInit__Fv);
void TitleExit() {
    if (CheckOmakeFlag() != 0) {
        OmakeFlag = 1;
    }
    printf(at_1267, OmakeFlag);
    sndSeAllStop(-1);
    GamePad__2.AutoRepeatOff();
    GamePad__2.MenuModeOff();
    mgFrameRate = 2;
    mgCloseFont();
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/title", TitleLoop__Fv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/title", TitleDraw__Fv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/title", InitRushMovie__Fi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/title", RushMovieKey__Fv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/title", RushMovieDraw__Fv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/title", TitleModeInit__Fv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/title", TitleModeKey__Fv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/title", TitleModeDraw__Fv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/title", TitleMapDraw__Fv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/title", CalcPushAlpha__FiPf);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/title", TitleMCCheckInit__Fi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/title", TitleMCCheckKey__Fv);
void TitleMCCheckDraw(void) {
    if (TitleMCCheckMes != NULL) {
        mgTexManager.ReloadTexture(0x46, (sceVif1Packet *)NULL);
        TitleMCCheckMes->Step();
        TitleMCCheckMes->DrawMesWin();
    }
}
s32 DCTitleStep(s32 phase) {
    return 0;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/title", TitleCopyRightInit__Fv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/title", TitleCopyRightStep__Fv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/title", TitleCopyRightDraw__Fv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/title", TitleHDDInstallInit__Fv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/title", TitleHDDInstallKey__Fv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/title", DrawMenuDl__Fiiiif);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/title", TitleHDDInstallDraw__Fv);
int CheckAppInstallForTitle(void) {
    if (GetMainFileDev() == 3) {
        return 1;
    }
    return CheckAppInstall();
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/title", CheckHDDInstall__Fv);
void TitleLangSelInit(mgCMemory *memory) {
    int file_size;
    u8 *buffer;

    GamePad__2.SetAutoRepeat(0x5000, 0xF, 4);
    GamePad__2.MenuModeOn(0x78);
    title_lang_select = 0;
    mgFrameRate = 1;
    buffer = (u8 *)(memory->stack + memory->stack_used);
    LoadFile2(at_2723, buffer, &file_size, 0);
    memory->Alloc(file_size / 16 + 1);
    mgTexManager.EnterIMGFile(buffer, 1, NULL, NULL);
    lang_tex = mgTexManager.GetTexture(at_2724, -1);
    title_lang_phase = 0;
    title_lang_curxy[0] = 100.0f;
    title_lang_fadealpha = 0x80;
    title_lang_curxy[1] = 100.0f;
    title_lang_cursor_cnt = 0;
}
int TitleLangSelKey(void) {
    switch (title_lang_phase) {
        case 0:
            title_lang_fadealpha -= 6;
            if (title_lang_fadealpha <= 0) {
                title_lang_fadealpha = 0;
                title_lang_phase += 1;
            }
            break;
        case 1:
            if (GamePad__2.Down(PAD_UP) != 0) {
                title_lang_select -= 1;
            }
            if (GamePad__2.Down(PAD_DOWN) != 0) {
                title_lang_select += 1;
            }
            if (title_lang_select < 0) {
                title_lang_select = 4;
            }
            if (title_lang_select > 4) {
                title_lang_select = 0;
            }
            if (GamePad__2.Down(0x40) != 0) {
                title_lang_phase += 1;
            }
            break;
        case 2:
            title_lang_fadealpha += 6;
            if (title_lang_fadealpha >= 0x80) {
                title_lang_fadealpha = 0x80;
                mgTexManager.DeleteBlock(0);
                mgFrameRate = 2;
                lang_tex = 0;
                GamePad__2.AutoRepeatOff();
                GamePad__2.MenuModeOff();
                return title_lang_select + 1;
            }
            break;
    }
    return 0;
}
int GetSelectLanguageNo(void) {
    return title_lang_select + 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/title", TitleLangSelDraw__Fv);

// Static initialiser (.init)
INCLUDE_ASM("ps2/asm/pal/nonmatchings/title", __sinit_title_cpp);

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", MC_ICON_Data__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", at_1594__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", at_1595__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", start_button_tbl_1826__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", btn_tblxy_1830__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", at_1924__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", table_2611__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", infomsg_2664__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", at_991__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", at_1221__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", at_1222__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", at_1223__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", at_1224__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", at_1225__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", at_1226__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", at_1227__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", at_1228__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", at_1229__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", at_1230__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", at_1231__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", at_1232__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", at_1233__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", at_1234__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", at_1235__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", at_1236__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", at_1237__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", at_1238__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", at_1239__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", at_1267__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", at_1479__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", at_1481__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", at_1480__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", at_1495__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", at_1517__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", at_2020__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", at_2021__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", at_2182__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", at_2281__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", at_2310__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", at_2369__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", at_2370__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", at_2371__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", at_2372__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", at_2373__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", at_2374__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", at_2375__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", at_2376__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", at_2607__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", at_2606__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", at_2665__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", at_2666__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", at_2667__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", at_2723__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", at_2724__DATA);

// Static initialiser table (.ctor)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", D_0037B04C__DATA);

// Small initialised data (.sdata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", TitleRushWaitCount__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", TitleProjection__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", TitleHDDCheckFlag__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", TitleMCCheckFileFind__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", TitleMCCheckInport__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", cnttbl_2026__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", at_2646__2__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(TitleRushWaitCountBoot, 0x4);
INCLUDE_BSS(TitleSelectInit, 0x4);
INCLUDE_BSS(TitleMap, 0x4);
INCLUDE_BSS(TitleCamera, 0x4);
INCLUDE_BSS(TitleCamera2, 0x4);
INCLUDE_BSS(WaveTable__3, 0x4);
INCLUDE_BSS(TitleCameraPhase, 0x4);
INCLUDE_BSS(TitleCameraPhaseCounter, 0x4);
INCLUDE_BSS(TitleCameraAddAngle, 0x4);
INCLUDE_BSS(GameBootInit, 0x4);
INCLUDE_BSS(MasterDebugModeOn, 0x4);
INCLUDE_BSS(TitleBootEventNo, 0x4);
INCLUDE_BSS(DCRuncherMode, 0x4);
INCLUDE_BSS(DCSelectedMovie, 0x4);
INCLUDE_BSS(DCRuncherCounter, 0x4);
INCLUDE_BSS(TitleInfo, 0x4);
INCLUDE_BSS(OmakePlayEnableAttr, 0x4);
INCLUDE_BSS(CostumeOptionEnv, 0x8);
INCLUDE_BSS(TitleMCFuncFlag, 0x4);
INCLUDE_BSS(TitleMCActivePort, 0x4);
INCLUDE_BSS(TitleMCCheckNow, 0x4);
INCLUDE_BSS(TitleMainMCCheckPhase, 0x4);
INCLUDE_BSS(TitleMCCheck, 0x4);
INCLUDE_BSS(TitleMCCheckMes, 0x4);
INCLUDE_BSS(TitlePhase, 0x4);
INCLUDE_BSS(TitlePushStart_AlphaPlus, 0x4);
INCLUDE_BSS(Trial_TitleBlackFadeAlpha, 0x4);
INCLUDE_BSS(TitleCopyRightDispPhase, 0x4);
INCLUDE_BSS(TitleCopyRightDispCounter, 0x4);
INCLUDE_BSS(TitleSkipLogoFlag, 0x4);
INCLUDE_BSS(Tex_TitleBG, 0x4);
INCLUDE_BSS(Tex_Chronicle, 0x4);
INCLUDE_BSS(Tex_Logo, 0x4);
INCLUDE_BSS(Tex_Plate, 0x4);
INCLUDE_BSS(Tex_TitleLight, 0x4);
INCLUDE_BSS(Tex_TitleCursor, 0x4);
INCLUDE_BSS(Tex_TrialMsg, 0x4);
INCLUDE_BSS(Tex_TitleBG2, 0x4);
INCLUDE_BSS(RushMovie, 0x4);
INCLUDE_BSS(RushStart, 0x4);
INCLUDE_BSS(RushWork, 0x4);
INCLUDE_BSS(TitleScene, 0x4);
INCLUDE_BSS(TitleEventSound, 0x4);
INCLUDE_BSS(E3Select, 0x4);
INCLUDE_BSS(E3ModeBoardDrawFlag, 0x4);
INCLUDE_BSS(E3ModeBoardDrawAlpha, 0x4);
INCLUDE_BSS(E3_Title_SpriteY, 0x4);
INCLUDE_BSS(E3_Trial_SpriteY, 0x4);
INCLUDE_BSS(debug_start_drawflag, 0x4);
INCLUDE_BSS(HDDPhase, 0x4);
INCLUDE_BSS(HDDConfirmType, 0x4);
INCLUDE_BSS(HDDnowDisplayImageNo, 0x4);
INCLUDE_BSS(HDDDlBarDrawFlag, 0x4);
INCLUDE_BSS(HDDDlBar, 0x4);
INCLUDE_BSS(HDDMesDrawFlag, 0x4);
INCLUDE_BSS(HDDMesDataBuff, 0x4);
INCLUDE_BSS(HDDMes, 0x4);
INCLUDE_BSS(HDDMes2, 0x4);
INCLUDE_BSS(HDDBGTex, 0x4);
INCLUDE_BSS(HDDSysImage, 0x4);
INCLUDE_BSS(HDDModeSelect, 0x4);
INCLUDE_BSS(TitleOmakeFlag, 0x4);
INCLUDE_BSS(TitleMCCheckBootMode, 0x4);
INCLUDE_BSS(TitleMCCheckPort, 0x4);
INCLUDE_BSS(TitleMCCheckPhase, 0x4);
INCLUDE_BSS(count_2647, 0x4);
INCLUDE_BSS(init_2648, 0x4);
INCLUDE_BSS(title_lang_select, 0x4);
INCLUDE_BSS(title_lang_phase, 0x8);
INCLUDE_BSS(title_lang_curxy, 0x8);
INCLUDE_BSS(title_lang_fadealpha, 0x4);
INCLUDE_BSS(title_lang_cursor_cnt, 0x4);
INCLUDE_BSS(lang_tex, 0x4);

// Uninitialised data (.bss)
INCLUDE_BSS(DataBuffer, 0x30);
INCLUDE_BSS(TitleMapBuffer, 0x30);
INCLUDE_BSS(TitleWorkBuffer, 0x30);
INCLUDE_BSS(Stack_ReadBuff, 0x30);
INCLUDE_BSS(Stack_MenuCharaBuff_Fix, 0x30);
INCLUDE_BSS(RushInfo, 0x20);
INCLUDE_BSS(HDDImage, 0x30);
INCLUDE_BSS(HDDImageAlpha, 0x30);
INCLUDE_BSS(HDDINFO, 0x30);
INCLUDE_BSS(lang_stack, 0x30);
