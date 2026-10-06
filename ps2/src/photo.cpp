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
#include <cmath>
#include "mg_drawprim.hpp"
#include "mg_math.hpp"
#include "snd_mngr.hpp"

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
static CFont Font__3;
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
static void InitPhotoTitle() {
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
#ifdef NONMATCHING
extern "C" int fptosi(float value);
extern char at_997__5[];
extern sceVu0FVECTOR at_936__6;
int DrawTakePhoto(USER_PICTURE_INFO *picture, float *distance) {
    int x;
    if (WorkTex == NULL) {
        return 0;
    }
    if (NowTakePhoto() == 0) {
        return 0;
    }
    mgCTextureManager *textures = &mgTexManager;
    textures->ReloadTexture(CameraTexb, (sceVif1Packet *)NULL);
    u_long128 image[0x240];
    u_long128 depth[0x40];
    mgCDrawPrim prim;
    int taken = 0;
    if (TakePhotoMode == 5) {
        mgStoreImage(WorkTex, image);
        mgRect<int> area(252, 204, 260, 212);
        int count = mgStoreZBuffImage(area, depth) * 4;
        u_int *pixel = (u_int *)depth;
        u_int nearest = *pixel;
        int i = 0;
        while (i < count) {
            if (nearest < *pixel) {
                nearest = *pixel;
            }
            pixel++;
            i++;
        }
        *distance = mgConvZBuffToDist(nearest);
        if (picture != NULL) {
            memcpy(picture->image, image, 0x2000);
            picture->used = 1;
            picture->is_new = 1;
            sndSePlay(GetSystemSndID(), 11, 0);
            taken = 1;
        }
        ShowTakePhotoCnt = 120;
        TakePhotoMode = 4;
        ShutterAnmCnt = 8;
    }
    if (TakePhotoMode == 3) {
        mgCTexture frame;
        mgGetFrameBuffer(&frame);
        mgCTexture *target = WorkTex;
        mgSetPkFrameBuffer(target);
        mgCDrawPrim capture;
        capture.Initialize(NULL, NULL);
        capture.TextureMapEnable(1);
        capture.AlphaBlendEnable(0);
        capture.DepthTestEnable(0);
        capture.ZMask(-1);
        capture.Begin(6);
        capture.Texture(&frame);
        capture.Color(128, 128, 128, 128);
        capture.TextureCrd(0, 0);
        capture.Vertex(0, 0, 0);
        capture.TextureCrd(frame.width, frame.height);
        capture.Vertex(target->width, target->height, 0);
        capture.End();
        mgSetPkFrameBuffer(-1, -1, -1, -1);
        TakePhotoMode = 5;
    }
    prim.Initialize(NULL, NULL);
    prim.DepthTestEnable(0);
    prim.AlphaBlendEnable(1);
    prim.AlphaBlend(1);
    prim.TextureMapEnable(1);
    prim.ZMask(-1);
    prim.Begin(6);
    prim.Color(255, 255, 255, 128);
    prim.Texture(textures->GetTexture(at_997__5, -1));
    int center_x = mgScreenWidth / 2;
    int center_y = mgScreenHeight / 2;
    prim.TextureCrd(0x40, 1);
    prim.Vertex(center_x - 0x40, center_y - 0x40, 0);
    prim.TextureCrd(0x80, 0x40);
    prim.Vertex(center_x, center_y, 0);
    prim.TextureCrd(0x40, 1);
    prim.Vertex(center_x - 0x40, center_y + 0x40, 0);
    prim.TextureCrd(0x80, 0x40);
    prim.Vertex(center_x, center_y, 0);
    prim.TextureCrd(0x40, 1);
    prim.Vertex(center_x + 0x40, center_y - 0x40, 0);
    prim.TextureCrd(0x80, 0x40);
    prim.Vertex(center_x, center_y, 0);
    prim.TextureCrd(0x40, 1);
    prim.Vertex(center_x + 0x40, center_y + 0x40, 0);
    prim.TextureCrd(0x80, 0x40);
    prim.Vertex(center_x, center_y, 0);
    prim.TextureCrd(0, 0);
    prim.Vertex(center_x - 0xD4, center_y - 0xC4, 0);
    prim.TextureCrd(0x40, 0x40);
    prim.Vertex(center_x - 0x94, center_y - 0x84, 0);
    prim.TextureCrd(0, 0);
    prim.Vertex(center_x - 0xD4, center_y + 0xC4, 0);
    prim.TextureCrd(0x40, 0x40);
    prim.Vertex(center_x - 0x94, center_y + 0x84, 0);
    prim.TextureCrd(0, 0);
    prim.Vertex(center_x + 0xD4, center_y - 0xC4, 0);
    prim.TextureCrd(0x40, 0x40);
    prim.Vertex(center_x + 0x94, center_y - 0x84, 0);
    prim.TextureCrd(0, 0);
    prim.Vertex(center_x + 0xD4, center_y + 0xC4, 0);
    prim.TextureCrd(0x40, 0x40);
    prim.Vertex(center_x + 0x94, center_y + 0x84, 0);
    prim.End();
    int width = mgScreenWidth;
    int height = mgScreenHeight;
    prim.TextureMapEnable(0);
    prim.AlphaBlend(1);
    prim.AntiAliasing(1);
    if (TakePhotoMode == 4) {
        int frame = 8 - ShutterAnmCnt;
        sceVu0FVECTOR center;
        sceVu0CopyVector(center, at_936__6);
        center[0] = width / 2;
        center[1] = height / 2;
        float radius = mgDistVector(center);
        float shutter_angle = (1.5707964f * (frame - 1)) / 4.0f;
        if (shutter_angle > 1.5707964f) {
            shutter_angle = 3.1415927f - shutter_angle;
        }
        for (int i = 0; i < 12; i++) {
            float angle = mgAngleLimit(3.1415927f + i * 0.5235988f);
            sceVu0FVECTOR position;
            sceVu0FVECTOR edge;
            sceVu0FVECTOR rotated;
            sceVu0FMATRIX matrix;
            mgZeroVector(position);
            mgZeroVector(edge);
            position[1] = -radius;
            edge[0] = 1.1f * radius;
            mgUnitMatrix(matrix);
            sceVu0RotMatrixZ(matrix, matrix, angle);
            sceVu0ApplyMatrix(position, matrix, position);
            sceVu0ApplyMatrix(edge, matrix, edge);
            mgAddVector(position, center);
            mgUnitMatrix(matrix);
            sceVu0RotMatrixZ(matrix, matrix, shutter_angle);
            sceVu0ApplyMatrix(rotated, matrix, edge);
            prim.Begin(3);
            prim.Color(0, 0, 0, 128);
            prim.Vertex(position[0], position[1], 0.0f);
            prim.Vertex(position[0] + edge[0], position[1] + edge[1], 0.0f);
            prim.Vertex(position[0] + rotated[0], position[1] + rotated[1], 0.0f);
            prim.End();
            prim.Begin(1);
            prim.Color(64, 64, 64, 64);
            prim.Vertex(position[0], position[1], 0.0f);
            prim.Vertex(position[0] + rotated[0], position[1] + rotated[1], 0.0f);
            prim.End();
        }
    }
    prim.TextureMapEnable(0);
    prim.AlphaBlend(1);
    prim.AntiAliasing(1);
    prim.Begin(6);
    prim.Color(0, 0, 0, 128);
    prim.Vertex(0, 0, 0);
    prim.Vertex(16, mgScreenHeight, 0);
    prim.Vertex(mgScreenWidth - 16, 0, 0);
    prim.Vertex(mgScreenWidth, mgScreenHeight, 0);
    prim.Vertex(0, 0, 0);
    prim.Vertex(mgScreenWidth, 16, 0);
    prim.Vertex(0, mgScreenHeight - 16, 0);
    prim.Vertex(mgScreenWidth, mgScreenHeight, 0);
    prim.End();
    int arc_x;
    int arc_y;
    int corner_x;
    int corner_y;
    for (int corner = 0; corner < 4; corner++) {
        float angle = 1.5707964f;
        if (corner == 0) {
                arc_x = arc_y = fptosi(48.0f);
                corner_x = 0;
                corner_y = 0;
                angle = 1.5707964f;
        } else if (corner == 1) {
                arc_x = fptosi(48.0f);
                corner_x = 0;
                arc_y = (int)((float)height - 48.0f);
                angle = 3.1415927f;
                corner_y = height;
        } else if (corner == 2) {
                arc_x = (int)((float)width - 48.0f);
                corner_x = width;
                arc_y = (int)((float)height - 48.0f);
                angle = 4.712389f;
                corner_y = height;
        } else if (corner == 3) {
                arc_x = (int)((float)width - 48.0f);
                corner_x = width;
                angle = 0.0f;
                arc_y = fptosi(48.0f);
                corner_y = 0;
        }
        prim.Begin(5);
        prim.Color(0, 0, 0, 128);
        prim.Vertex(corner_x, corner_y, 0);
        for (int i = 0; i < 9; i++) {
            x = (int)((float)arc_x + 33.0f * cosf(angle));
            int y = (int)((float)arc_y + -33.0f * sinf(angle));
            angle += 0.19634955f;
            prim.Vertex(x, y, 0);
        }
        prim.End();
    }
    if (ShowTakePhotoCnt > 0 && ShutterAnmCnt == 0) {
        int alpha = 128;
        if (ShowTakePhotoCnt < 30) {
            alpha = 128 - (30 - ShowTakePhotoCnt) * 5;
            if (alpha < 0) {
                alpha = 0;
            }
        }
        mgCTexture *texture = WorkTex;
        int y = mgScreenHeight - 126;
        int photo_width = texture->width * 3 / 2;
        int photo_height = texture->height * 24 / 2;
        int bottom = y + photo_height / 10;
        prim.TextureMapEnable(0);
        prim.Begin(6);
        prim.Color(32, 32, 32, alpha * 2 / 3);
        prim.Vertex(18, y - 2, 0);
        prim.Vertex(photo_width + 28, bottom + 8, 0);
        prim.Color(0, 0, 0, alpha);
        prim.Vertex(14, y - 6, 0);
        prim.Vertex(photo_width + 26, bottom + 6, 0);
        prim.Color(255, 255, 255, alpha);
        prim.Vertex(15, y - 5, 0);
        prim.Vertex(photo_width + 25, bottom + 5, 0);
        prim.End();
        prim.TextureMapEnable(1);
        prim.Bilinear(1);
        prim.AlphaTestEnable(0);
        prim.Begin(6);
        prim.Color(128, 128, 128, alpha);
        prim.Direct(0x3B, 0x8000000080UL);
        prim.Texture(WorkTex);
        prim.TextureCrd(0, 0);
        prim.Vertex(20, y, 0);
        texture = WorkTex;
        prim.TextureCrd(texture->width, texture->height);
        prim.Vertex(photo_width + 20, bottom, 0);
        prim.End();
    }
    return taken;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/photo", DrawTakePhoto__FP17USER_PICTURE_INFOPf);
#endif
void SetTookPhotoData(USER_PICTURE_INFO *photo) {
    InitPhotoTitle();
    char *name = GetPhotoNameCheck(photo);
    if (name != NULL) {
        ShowTitleCnt = 90;
        strcpy(PhotoTitle, name);
        CInventUserData *invent = GetSaveData()->GetUserDataManager()->GetInventUserData();
        invent->AddShutterNum(1);
        if (invent->LevelCheck(photo) != 0) {
            ShowLevelUpCnt = 60;
        }
    }
}
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
INCLUDE_BSS(PhotoTitle, 0x80);
