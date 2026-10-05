#include "common.h"
#include "photo.hpp"
#include "mglib.hpp"
#include "menucommon.hpp"
#include "padcontrol.hpp"
#include "font.hpp"
#include "userdata.hpp"
#include "mg_texture.hpp"
#include "mainloop.hpp"
#include "inventmn.hpp"
#include <cstring>
#include <cstdio>

extern char *mes_txt[6][4];
extern float AddProj__2;
extern char PhotoTitle[];
extern int ShowTitleCnt;
extern u32 CameraTexb;
extern u32 OpenMenu;
extern int ShowLevelUpCnt;
extern int ShowTakePhotoCnt;
extern int ShutterAnmCnt;
extern u32 TakePhotoMode;
extern CFont Font__3;
extern char *null_txt;
extern char at_852__6[];
extern mgCTexture *WorkTex;
extern char at_1055[];

// Code (.text)
char *GetMesTxt(int message_id) {
    if (message_id < 0 || message_id >= 4) {
        return null_txt;
    }
    if (LanguageCode < 0 || LanguageCode >= 6) {
        return null_txt;
    }
    return mes_txt[LanguageCode][message_id];
}
float PhotoAddProjection() {
    if (NowTakePhoto()) {
        return AddProj__2;
    }
    return 0.0f;
}
void InitPhotoTitle() {
    ShowTitleCnt = 0;
    PhotoTitle[0] = 0;
}
void InitTakePhoto() {
    TakePhotoMode = 0;
    AddProj__2 = 0;
    InitPhotoTitle();
    ShowTakePhotoCnt = 0;
    CameraTexb = -1;
    ShutterAnmCnt = 0;
    OpenMenu = 0;
    ShowLevelUpCnt = 0;
}
void LoadTakePhoto(int arg0, mgCMemory *memory, u_long128 *buffer) {
    WorkTex = mgTexManager.EnterTexture(0x7FFF, at_852__6, NULL, 0x40, 0x40, 0x10, 0, (int)0, 0);
    CameraTexb = arg0;
    Font__3.Init();
    Font__3.Preset(4);
    Font__3.SetFuchi(3);
    Font__3.SetClearance(0xF, 0x18);
}
void StartTakePhoto() {
    InitTakePhoto();
    TakePhotoMode = 2;
}
void EndTakePhoto() {
    InitTakePhoto();
}
int NowTakePhoto() {
    return (int)TakePhotoMode > 0;
}
int IsEnablePhotoMenu() {
    return TakePhotoMode == 2;
}
void HidePhoto() {
    ShowTakePhotoCnt = 0;
}
int GhostPhotoTiming() {
    switch (TakePhotoMode) {
        case 3:
        case 5:
            return 1;
        default:
            return 0;
    }
}
void LoopTakePhoto(CPadControl *pad, CInventUserData *user_data) {
    if (user_data != NULL) {
        if (TakePhotoMode == 2) {
            AddProj__2 += 10.0f * -pad->Analog(3);
            if (!(AddProj__2 <= 200.0f)) {
                AddProj__2 = 200.0f;
            }
            if (AddProj__2 < -200.0f) {
                AddProj__2 = -200.0f;
            }
            if (user_data->IsPhotoSpace(NULL) != 0 && pad->Btn(0x33) != 0) {
                TakePhotoMode = 3;
            }
            ShowTakePhotoCnt -= 1;
            if (ShowTakePhotoCnt < 0) {
                ShowTakePhotoCnt = 0;
            }
        }
        if (TakePhotoMode == 4) {
            ShutterAnmCnt -= 1;
            if (ShutterAnmCnt < 0) {
                ShutterAnmCnt = 0;
                TakePhotoMode = 2;
            }
        }
        if (TakePhotoMode == 6) {
            OpenMenu = 1;
            TakePhotoMode = 2;
        }
    }
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/photo", DrawTakePhoto__FP17USER_PICTURE_INFOPf);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/photo", SetTookPhotoData__FP17USER_PICTURE_INFO);
void DrawTakePhotoSystem(int texture, CInventUserData *user_data) {
    char title[0x100];
    char count_text[0x28];
    int counts[2];
    int y;
    int char_width;
    mgTexManager.ReloadTexture(texture, (sceVif1Packet *)NULL);
    Font__3.SetColor(0xFF, 0xFF, 0xFF, 0x80);
    if (ShowTitleCnt > 0 && PhotoTitle[0] != 0) {
        y = mgScreenHeight - 0x24;
        Font__3.SetStr(PhotoTitle);
        Font__3.SetPos(0x14, y);
        Font__3.DrawDirect(Font__3.str, Font__3.pos_x, Font__3.pos_y);
        ShowTitleCnt -= 1;
        if (ShowTitleCnt <= 0) {
            InitPhotoTitle();
        }
    } else {
        y = mgScreenHeight - 0x29;
        Font__3.SetStr(GetMesTxt(0));
        Font__3.SetPos(0x28, y);
        Font__3.DrawDirect(Font__3.str, Font__3.pos_x, Font__3.pos_y);
        y = mgScreenHeight - 0x29;
        Font__3.SetStr(GetMesTxt(3));
        Font__3.SetPos(0xF0, y);
        Font__3.DrawDirect(Font__3.str, Font__3.pos_x, Font__3.pos_y);
        y = mgScreenHeight - 0x15;
        Font__3.SetStr(GetMesTxt(1));
        Font__3.SetPos(0x28, y);
        Font__3.DrawDirect(Font__3.str, Font__3.pos_x, Font__3.pos_y);
    }
    ConvertFontCode(GetMesTxt(2), title);
    char_width = Font__3.draw_w;
    y = 0xF6;
    y -= (int)((u32)(char_width * strlen(title)) >> 1) / 2;
    if (ShowLevelUpCnt > 0) {
        Font__3.SetStr(GetMesTxt(2));
        Font__3.SetPos(y, 0x140);
        Font__3.DrawDirect(Font__3.str, Font__3.pos_x, Font__3.pos_y);
        ShowLevelUpCnt -= 1;
    }
    user_data->GetPictureNum(counts);
    sprintf(count_text, at_1055, counts[0], counts[1]);
    if (counts[0] >= counts[1]) {
        Font__3.SetColor(0xFF, 0x20, 0x10, 0x80);
    }
    y = mgScreenHeight - 0x2E;
    Font__3.SetStr(count_text);
    Font__3.SetPos(0x1B8, y);
    Font__3.DrawDirect(Font__3.str, Font__3.pos_x, Font__3.pos_y);
}

// Static initialiser (.init)
INCLUDE_ASM("ps2/asm/pal/nonmatchings/photo", __sinit_photo_cpp);

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/photo", mes_txt__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/photo", at_936__6__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/photo", at_793__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/photo", at_794__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/photo", at_795__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/photo", at_796__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/photo", at_797__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/photo", at_798__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/photo", at_799__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/photo", at_800__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/photo", at_801__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/photo", at_802__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/photo", at_803__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/photo", at_804__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/photo", at_805__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/photo", at_806__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/photo", at_807__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/photo", at_808__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/photo", at_809__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/photo", at_810__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/photo", at_811__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/photo", at_812__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/photo", at_813__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/photo", at_814__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/photo", at_815__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/photo", at_816__6__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/photo", at_817__6__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/photo", at_852__6__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/photo", at_997__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/photo", at_1055__DATA);

// Static initialiser table (.ctor)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/photo", D_0037B088__DATA);

// Small initialised data (.sdata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/photo", null_txt__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(TakePhotoMode, 0x4);
INCLUDE_BSS(AddProj__2, 0x4);
INCLUDE_BSS(CameraTexb, 0x4);
INCLUDE_BSS(WorkTex, 0x4);
INCLUDE_BSS(ShutterAnmCnt, 0x4);
INCLUDE_BSS(ShowTakePhotoCnt, 0x4);
INCLUDE_BSS(OpenMenu, 0x4);
INCLUDE_BSS(ShowTitleCnt, 0x4);
INCLUDE_BSS(ShowLevelUpCnt, 0x4);

// Uninitialised data (.bss)
INCLUDE_BSS(Font__3, 0xC0);
INCLUDE_BSS(PhotoTitle, 0x80);
