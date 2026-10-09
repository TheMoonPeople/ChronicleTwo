#include "common.h"
#include "mw_runtime.h"

#include <cmath>
#include <cstdio>
#include <cstring>

#include "font.hpp"
#include "inventmn.hpp"
#include "mainloop.hpp"
#include "menucommon.hpp"
#include "mg_drawprim.hpp"
#include "mg_math.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "padcontrol.hpp"
#include "photo.hpp"
#include "snd_mngr.hpp"
#include "userdata.hpp"

/**
 * Photo mode prompts and announcements in each supported language.
 */
static char *mes_txt[6][PHOTO_MES_NUM] = {
    {
        "(A):\x8E\xCA\x90^\x82\xF0\x8Am\x94" "F",
        "(#):\x8E\xCA\x90^\x82\xF0\x82\xC6\x82\xE9",
        "\x83\x86\x83\x8A\x83X\x82\xCC\x8E\xCA\x90^\x89\xC6\x83\x8C\x83x\x83\x8B\x82\xAA\x8F\xE3\x82\xAA\x82\xC1\x82\xBD",
        "(R):\x83Y\x81[\x83\x80",
    },
    {
        "(A):Confirm Picture",
        "(#):Take Picture",
        "Max's photography level increased!",
        "(R):zoom (X):Back",
    },
    {
        "(A) : confirmer photo",
        "(#) : prendre photo",
        "Niveau de photographie de Max a augment[UNI00e9] !",
        "(R) : zoom (X) : retour",
    },
    {
        "(A):Foto best[UNI00e4]tigen",
        "(#):Fotografieren",
        "Max' Fotografen-Level ist gestiegen!",
        "(R):Zoom (X):Zur[UNI00fc]ck",
    },
    {
        "(A):Conferma Foto",
        "(#):Scatta foto",
        "Il livello foto di Max [UNI00e8] aumentato!",
        "(R):zoom (X):Indietro",
    },
    {
        "(A):Confirmar foto",
        "(#):Hacer foto",
        "[UNI00a1]Ha aumentado el nivel de fotograf[UNI00ed]a de Max!",
        "(R):zoom (X):Volver",
    },
};

/**
 * Empty text returned for an invalid photo message or language.
 */
static char *null_txt = "";
/**
 * Font used to draw the camera prompts, titles and picture count.
 */
static CFont Font__3;

/**
 * Current step of camera capture and display.
 */
static u32 TakePhotoMode;

/**
 * Projection offset controlled by camera zoom.
 */
static float AddProj__2;

/**
 * Texture block holding the camera interface.
 */
static u32 CameraTexb;

/**
 * Texture used to capture and preview the last picture.
 */
static mgCTexture *WorkTex;

/**
 * Frames remaining in the shutter animation.
 */
static int ShutterAnmCnt;

/**
 * Frames remaining in the last-picture preview.
 */
static int ShowTakePhotoCnt;

/**
 * Request to open the camera picture menu.
 */
static u32 OpenMenu;

/**
 * Frames remaining in the subject-title display.
 */
static int ShowTitleCnt;

/**
 * Frames remaining in the photography-level announcement.
 */
static int ShowLevelUpCnt;

/**
 * Title of the subject in the last picture.
 */
static char PhotoTitle[128];

// Code (.text)
char *GetMesTxt(int message_id) {
    if (message_id < 0 || message_id >= PHOTO_MES_NUM) {
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

/**
 *
 * Clears the photo title text and its display countdown.
 *
 */
static void InitPhotoTitle() {
    ShowTitleCnt = 0;
    PhotoTitle[0] = 0;
}

void InitTakePhoto() {
    TakePhotoMode = TAKE_PHOTO_OFF;
    AddProj__2 = 0;
    InitPhotoTitle();
    ShowTakePhotoCnt = 0;
    CameraTexb = -1;
    ShutterAnmCnt = 0;
    OpenMenu = 0;
    ShowLevelUpCnt = 0;
}

void LoadTakePhoto(int tex_block, mgCMemory *memory, u_long128 *buffer) {
    WorkTex = mgTexManager.EnterTexture(0x7FFF, "fix_work", NULL, 0x40, 0x40, 0x10, 0, 0, 0);
    CameraTexb = tex_block;
    Font__3.Init();
    Font__3.Preset(4);
    Font__3.SetFuchi(3);
    Font__3.SetClearance(0xF, 0x18);
}

void StartTakePhoto() {
    InitTakePhoto();
    TakePhotoMode = TAKE_PHOTO_AIM;
}

void EndTakePhoto() {
    InitTakePhoto();
}

int NowTakePhoto() {
    return (int) TakePhotoMode > TAKE_PHOTO_OFF;
}

int IsEnablePhotoMenu() {
    return TakePhotoMode == TAKE_PHOTO_AIM;
}

void HidePhoto() {
    ShowTakePhotoCnt = 0;
}

int GhostPhotoTiming() {
    switch (TakePhotoMode) {
        case TAKE_PHOTO_SHUTTER:
        case TAKE_PHOTO_STORE:
            return 1;
        default:
            return 0;
    }
}

void LoopTakePhoto(CPadControl *pad, CInventUserData *user_data) {
    if (user_data != NULL) {
        if (TakePhotoMode == TAKE_PHOTO_AIM) {
            AddProj__2 += 10.0f * -pad->Analog(PAD_ANALOG_RIGHT_Y);

            if (!(AddProj__2 <= 200.0f)) {
                AddProj__2 = 200.0f;
            }

            if (AddProj__2 < -200.0f) {
                AddProj__2 = -200.0f;
            }

            if (user_data->IsPhotoSpace(NULL) != 0 && pad->Btn(0x33) != 0) {
                TakePhotoMode = TAKE_PHOTO_SHUTTER;
            }

            ShowTakePhotoCnt -= 1;

            if (ShowTakePhotoCnt < 0) {
                ShowTakePhotoCnt = 0;
            }
        }

        if (TakePhotoMode == TAKE_PHOTO_AFTERSHOT) {
            ShutterAnmCnt -= 1;

            if (ShutterAnmCnt < 0) {
                ShutterAnmCnt = 0;
                TakePhotoMode = TAKE_PHOTO_AIM;
            }
        }

        if (TakePhotoMode == TAKE_PHOTO_OPEN_MENU) {
            OpenMenu = 1;
            TakePhotoMode = TAKE_PHOTO_AIM;
        }
    }
}
int DrawTakePhoto(USER_PICTURE_INFO *picture, float *distance) {
    int corner_x;
    int corner_y;
    int corner;
    int arc_x;
    int arc_y;
    int step;
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
    if (TakePhotoMode == TAKE_PHOTO_STORE) {
        mgStoreImage(WorkTex, image);
        mgRect<int> area(252, 204, 260, 212);
        int count = mgStoreZBuffImage(area, depth);
        count *= 4;
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
        TakePhotoMode = TAKE_PHOTO_AFTERSHOT;
        ShutterAnmCnt = 8;
    }
    if (TakePhotoMode == TAKE_PHOTO_SHUTTER) {
        mgCTexture frame;
        mgGetFrameBuffer(&frame);
        mgCTexture *target = WorkTex;
        mgSetPkFrameBuffer(target);
        mgCDrawPrim capture;
        capture.Initialize(NULL, NULL);
        capture.TextureMapEnable(1);
        capture.AlphaBlendEnable(0);
        capture.DepthTestEnable(0);
        capture.ZMask(MG_Z_MASK_MASKED);
        capture.Begin(MG_PRIM_SPRITE);
        capture.Texture(&frame);
        capture.Color(128, 128, 128, 128);
        capture.TextureCrd(0, 0);
        capture.Vertex(0, 0, 0);
        capture.TextureCrd(frame.width, frame.height);
        capture.Vertex(target->width, target->height, 0);
        capture.End();
        mgSetPkFrameBuffer(-1, -1, -1, -1);
        TakePhotoMode = TAKE_PHOTO_STORE;
    }
    prim.Initialize(NULL, NULL);
    prim.DepthTestEnable(0);
    prim.AlphaBlendEnable(1);
    prim.AlphaBlend(MG_ALPHA_BLEND_NORMAL);
    prim.TextureMapEnable(1);
    prim.ZMask(MG_Z_MASK_MASKED);
    prim.Begin(MG_PRIM_SPRITE);
    prim.Color(255, 255, 255, 128);
    prim.Texture(textures->GetTexture("camera", -1));
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
    prim.AlphaBlend(MG_ALPHA_BLEND_NORMAL);
    prim.AntiAliasing(1);
    if (TakePhotoMode == TAKE_PHOTO_AFTERSHOT) {
        int frame = 8 - ShutterAnmCnt;
        sceVu0FVECTOR center = {width / 2, height / 2, 0.0f, 1.0f};
        float radius = mgDistVector(center);
        float shutter_angle = (1.5707964f * (frame - 1)) / 4.0f;
        if (shutter_angle > 1.5707964f) {
            shutter_angle = 3.1415927f - shutter_angle;
        }
        for (int i = 0; i < 12; i++) {
            float spoke_angle = 0.5235988f;
            float angle = mgAngleLimit(3.1415927f + i * spoke_angle);
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
            prim.Begin(MG_PRIM_TRIANGLE);
            prim.Color(0, 0, 0, 128);
            prim.Vertex(position[0], position[1], 0.0f);
            prim.Vertex(position[0] + edge[0], position[1] + edge[1], 0.0f);
            prim.Vertex(position[0] + rotated[0], position[1] + rotated[1], 0.0f);
            prim.End();
            prim.Begin(MG_PRIM_LINE);
            prim.Color(64, 64, 64, 64);
            prim.Vertex(position[0], position[1], 0.0f);
            prim.Vertex(position[0] + rotated[0], position[1] + rotated[1], 0.0f);
            prim.End();
        }
    }
    prim.TextureMapEnable(0);
    prim.AlphaBlend(MG_ALPHA_BLEND_NORMAL);
    prim.AntiAliasing(1);
    prim.Begin(MG_PRIM_SPRITE);
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
    int x;
    float arc_radius = 33.0f;
    for (corner = 0; corner < 4; corner++) {
        float angle = 1.5707964f;
        if (corner == 0) {
                arc_y = arc_x = fptosi(48.0f);
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
                arc_y = fptosi(48.0f);
                angle = 0.0f;
                corner_y = 0;
        }
        prim.Begin(MG_PRIM_TRIANGLE_FAN);
        prim.Color(0, 0, 0, 128);
        prim.Vertex(corner_x, corner_y, 0);
        for (step = 0; step < 9; step++) {
            x = (int)((float)arc_x + arc_radius * cosf(angle));
            int y = (int)((float)arc_y + -arc_radius * sinf(angle));
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
        int frame_height = photo_height / 10;
        prim.TextureMapEnable(0);
        prim.Begin(MG_PRIM_SPRITE);
        prim.Color(32, 32, 32, alpha * 2 / 3);
        prim.Vertex(18, y - 2, 0);
        prim.Vertex(photo_width + 28, y + frame_height + 8, 0);
        prim.Color(0, 0, 0, alpha);
        prim.Vertex(14, y - 6, 0);
        prim.Vertex(photo_width + 26, y + frame_height + 6, 0);
        prim.Color(255, 255, 255, alpha);
        prim.Vertex(15, y - 5, 0);
        prim.Vertex(photo_width + 25, y + frame_height + 5, 0);
        prim.End();
        prim.TextureMapEnable(1);
        prim.Bilinear(1);
        prim.AlphaTestEnable(0);
        prim.Begin(MG_PRIM_SPRITE);
        prim.Color(128, 128, 128, alpha);
        prim.Direct(SCE_GS_TEXA, 0x8000000080UL);
        prim.Texture(WorkTex);
        prim.TextureCrd(0, 0);
        prim.Vertex(20, y, 0);
        texture = WorkTex;
        prim.TextureCrd(texture->width, texture->height);
        prim.Vertex(photo_width + 20, y + frame_height, 0);
        prim.End();
    }
    return taken;
}
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
    int  counts[2];
    int  y;
    int  char_width;
    mgTexManager.ReloadTexture(texture, (sceVif1Packet *) NULL);
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
    y -= (int) ((u32) (char_width * strlen(title)) >> 1) / 2;

    if (ShowLevelUpCnt > 0) {
        Font__3.SetStr(GetMesTxt(2));
        Font__3.SetPos(y, 0x140);
        Font__3.DrawDirect(Font__3.str, Font__3.pos_x, Font__3.pos_y);
        ShowLevelUpCnt -= 1;
    }

    user_data->GetPictureNum(counts);
    sprintf(count_text, "%d/%d", counts[0], counts[1]);

    if (counts[0] >= counts[1]) {
        Font__3.SetColor(0xFF, 0x20, 0x10, 0x80);
    }

    y = mgScreenHeight - 0x2E;
    Font__3.SetStr(count_text);
    Font__3.SetPos(0x1B8, y);
    Font__3.DrawDirect(Font__3.str, Font__3.pos_x, Font__3.pos_y);
}
