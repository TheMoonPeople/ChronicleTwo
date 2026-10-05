#include "menudraw.hpp"
#include "mainloop.hpp"
#include "mg_drawprim.hpp"
#include "mg_math.hpp"
#include "mg_texture.hpp"
#include "mg_frame.hpp"
#include "character.hpp"
#include "actionchara.hpp"
#include "gamedata.hpp"
#include "userdata.hpp"
#include "menucls1.hpp"
#include "menucommon.hpp"
#include "menumain.hpp"
#include "menusys.hpp"
#include "nd_meswin.hpp"
#include "inventmn.hpp"
#include "menuchr.hpp"
#include "dataread.hpp"
#include "mglib.hpp"
extern "C" int sprintf(...);
#include <cstdlib>
#include <cmath>
#include <cstring>

struct texture_pair {
    mgCTexture *tex[2];
};

struct icon_texture_info {
    int value[4];
};

struct menu_effect_preset {
    int v[10];
};

extern signed char MenuDrawNumberKeta;

extern u8 MenuMainFrame_ActionEndFlag;

extern "C" char at_873__4[];

extern "C" int GetTimeBand__Ff(float time);

extern "C" int GetItemIconNo__Fi(int itemNo);

extern icon_texture_info at_900__4;

extern short use_trans_rect;

extern "C" int __ct__11mgCDrawPrimFv(void *);

extern "C" void PrimQuad_i___FP11mgCDrawPrim9mgRect_i_9mgRect_i_(mgCDrawPrim *, mgRect<int>,
                                                                 mgRect<int>);

extern "C" int GetMenuPrim__Fv(void);

extern "C" void Direct__11mgCDrawPrimFUlUl(void *prim, u64 reg, u64 value);

extern float use_item_enable_alpha_angle;

extern int use_item_enable_alpha;

extern int spectol_raster_xtbl;

extern short MenuWindowHelpTable_1346[36];

extern "C" int ReloadTexture__17mgCTextureManagerFiP13sceVif1Packet(void *, int, sceVif1Packet *);

extern "C" texture_pair at_1521__2;

extern "C" int ReloadCLUT__17mgCTextureManagerFP10mgCTextureP13sceVif1Packet(void *, mgCTexture *,
                                                                             sceVif1Packet *);

extern "C" void DrawMenuFillBox__Fffffiiii(float arg0, float arg1, float arg2, float arg3, int arg4,
                                           int arg5, int arg6, int arg7);

extern "C" char at_1622__2[];

extern "C" mgCTexture *Tex_MenuDl;

extern "C" int MenuDl_TotalSize;

extern "C" int MenuDl_ProcessSize;

extern "C" void *__ct__9CMenuFontFv(void *font);

extern "C" void SetStr__5CFontFPc(void *font, char *text);
extern "C" void SetPos__5CFontFii(void *font, int x, int y);

extern "C" void DrawDirect__5CFontFPcii(void *font, char *text, int x, int y);

extern "C" void CalcDrawWH__5CFontFPcPiPi(void *font, char *text, int *width, int *height);

extern "C" void ConvertFontCode__FPcPc(char *source, char *converted);

extern "C" char at_1711[];

extern char *tbl_1689[][2];

extern "C" int MenuMainFrame_LeftTop_Pos[2];

extern short MenuMainFrame_Display_Mode;

extern float tbl_2072[];

extern float MenuMainFrame_Display_Mode_Cnt;

extern float MenuMainFrame_Display_Mode_Cnt_Rate;

extern float MenuMainFrame_Lenze_Pos[2];

extern float MenuMainFrame_MoveRate[2];

extern float MenuMainFrame_MoveRate_Cnt;

void SetPartEffectInfoRandFunc(MENU_PARTS_EFFECT_STRUCT1 *effect);

void SetPartEffectInfoRandFunc(MENU_PARTS_EFFECT_STRUCT1 *effect, short *values, int count);

extern "C" char at_2237[];

extern "C" char at_2238[];

extern mgRect<int> MenuMainFrame_PutRect;

extern icon_texture_info at_2292;

extern icon_texture_info at_2303;

extern int MenuItemBrdMaxLine;

extern int MenuItemBrdViewLine;

extern float MenuItemBrdScrlCurLen;

extern "C" int CheckRobotCore__16CUserDataManagerFv(CUserDataManager *manager);

extern "C" int ReloadTexture__17mgCTextureManagerFiP13sceVif1Packet(void *manager, int block, sceVif1Packet *packet);

extern "C" int fptosi(float value);

extern "C" int __ct__11mgCDrawPrimFv(void *prim);

extern "C" void Draw__16CEffVerticalLineFv(CEffVerticalLine *line);

extern float DrawItemCounter;

extern signed char DrawItemDefCounter;

extern float MenuItemBrdScrlBarY;

extern mgCTexture *MenuVerticalLineTex;

extern float MenuVerticalLineUpLimmit;

extern CEffVerticalLine *MenuVerticalLine;

extern int MenuVerticalLineNum;

extern int MenuVerticalLineChara;

extern float MenuVerticalRange;

extern float MenuVerticalLineCharaPos[4];

extern float MenuVerticalLineCharaPos2[4];

extern float l_levelup_pos[32][3];

extern float l_levelup_vec[32][3];

extern signed char l_levelup_counter[32];

extern signed char l_levelup_generate_counter[32];

extern short fish_boiled_runflag;

extern short fish_boiled_count;

extern float fish_boiled_positin[8][2];

extern float fish_boiled_amp_count[8];

extern float fish_boiled_alpha[8];

extern float fish_boiled_streatch_rate[8];

extern int fish_boiled_effect_tex;

extern menu_effect_preset at_5441;

extern menu_effect_preset at_5450;

extern "C" u8 temp_3925[32];

extern "C" u8 at_3927[];

extern "C" char at_4182[];

extern "C" char at_4183[];

extern "C" char at_4184[];

extern "C" char at_4185__2[];

extern "C" char at_4186[];

extern char at_4522[];

extern "C" u8 at_4877[];

extern "C" u8 at_4888[20];

extern "C" u8 at_4889[];

extern "C" char at_4890[11];

void MENU_BASETEXINFO_Init(MENU_BASETEXINFO *info);

mgCTexture *GetMenuItemIconTexInfo(int itemNo, int index);

void ConvMGIRECTtoINTtbl(mgRect<int> rect, int *corners);

void PushPrimRepeat(mgCDrawPrim *prim, float *positions, int *texCoords, int count);

void MenuWindowHelp(mgCDrawPrim *prim, mgCTexture *texture, float x, float y, float width, float height,
                    short *table);

void SetMenuDrawNumberKeta(char value);

void DrawRandamLine(mgCDrawPrim *prim, int *points, int smoothing, int count, u8 *color);

mgCTexture *GetMenuDlTexture(void);

float *GetMenuMainFrameLeftTopPos(int frame);

void *GetMenuMainIconChar(int iconNo);

CStarDust *CheckNotRunStarDust(CStarDust *dusts, int count);

void InitInitBuildUpInfoEffectPos();

void PrimQuad_i_(mgCDrawPrim *prim, mgRect<int> rect, mgRect<int> texRect);

#include "common.h"

// Code (.text)
void AttachMessageForm() {
    char name[32];
    for (int i = 0; i < 9; i++) {
        sprintf(name, at_873__4, i);
        MenuMesForm[i] = (CMenuPosDataForm *)MenuPosData->GetFormInfo(name);
    }
}
void Init_MENUFORM_MAKEBRD_INFO(MENUFORM_MAKEBRD_INFO *board) {
    memset(board, 0, sizeof(*board));
}
void GetMenuItemIconTexGetXY(int item_no, mgRect<int> &rect) {
    int icon_no = GetItemIconNo__Fi(item_no);
    if (item_no == 0x38 && MenuMainScene != 0 &&
        GetTimeBand__Ff(*(float *)((u8 *)MenuMainScene + 0x2F6C)) == 2) {
        icon_no++;
    }
    rect.right = rect.bottom = 32;
    rect.left = (icon_no % 8) * rect.right;
    rect.top = (icon_no / 8) * rect.bottom;
}
mgCTexture *GetMenuItemIconTexInfo(int item_no, int index) {
    use_trans_rect = -1;
    CDataCommon *common = GameItemDataManage.GetCommonData(item_no);
    if (common != 0) {
        use_trans_rect = common->unk_20;
        if (0 <= use_trans_rect) {
            icon_texture_info info = at_900__4;
            int *words = (int *)MenuPosData;
            int n = use_trans_rect;
            info.value[0] = words[n + 0x15];
            info.value[1] = words[n + 0x17];
            info.value[2] = words[n + 0x19];
            info.value[3] = words[n + 0x1B];
            return (mgCTexture *)info.value[index];
        }
    }
    return 0;
}
void ConvMGIRECTtoINTtbl(mgRect<int> rect, int *corners) {
    corners[0] = rect.left;
    corners[1] = rect.top;
    corners[2] = rect.left + rect.right;
    corners[3] = rect.top;
    corners[4] = rect.left;
    corners[5] = rect.top + rect.bottom;
    corners[6] = corners[2];
    corners[7] = corners[5];
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menudraw", ConvMGFRECTtoFLOATtbl__F9mgRect_f_Pf);
void SetPartEffectInfoRandFunc(MENU_PARTS_EFFECT_STRUCT1 *effect) {
    if (effect != 0) {
        int rand_a = rand();
        int rand_b = rand();
        switch (effect->type) {
            case 9:
                effect->param[0] = 0.0f;
                effect->param[1] = 34.0f + (float)(rand_a % 20);
                effect->param[2] = 2.0f + (float)(rand_a % 30);
                effect->param[3] = (float)(rand_b % 34 - 1);
                effect->param[4] = (float)(rand_a % 3);
                effect->param[5] = 1.0f + 0.2f * (float)(rand_b % 4);
                effect->param[6] = (float)(rand_a % 9);
                effect->param[7] = 3.0f + (float)(rand_b % 6);
                return;
            case 6:
                effect->param[0] = 0.0f;
                effect->param[1] = 320.0f;
                effect->param[2] = 16.0f;
                effect->param[3] = 20.0f;
                effect->param[4] = 0.0f;
                effect->param[5] = 1000.0f;
                break;
        }
    }
}
void SetPartEffectInfoRandFunc(MENU_PARTS_EFFECT_STRUCT1 *effect, short *values, int count) {
    for (int i = 0; i < count; i++) {
        effect->param[i] = values[i];
    }
}
void SetSpriteEnv(mgCDrawPrim *prim, int mode) {
    if (prim != 0) {
        prim->Initialize(0, 0);
        prim->Coord(0);
        switch (mode) {
            case 0:
            case 4:
            case 6:
                prim->AlphaBlendEnable(1);
                prim->Bilinear(0);
                if (mode == 4) {
                    prim->AlphaBlend(2);
                    prim->Bilinear(1);
                } else {
                    prim->AlphaBlend(1);
                }
                prim->AlphaTestEnable(1);
                prim->AlphaTest(1, 0);
                prim->DepthTestEnable(0);
                prim->ZMask(-1);
                prim->Shading(0);
                prim->TextureMapEnable(1);
                prim->AntiAliasing(0);
                if (mode == 6) {
                    prim->Shading(1);
                    prim->Bilinear(1);
                    return;
                }
                break;
            case 1:
            case 2:
                prim->AlphaTestEnable(1);
                prim->AlphaTest(1, 0);
                prim->AlphaBlendEnable(1);
                prim->AlphaBlend(1);
                prim->TextureMapEnable(0);
                prim->DepthTestEnable(1);
                if (mode == 2) {
                    prim->DepthTestEnable(0);
                    prim->AntiAliasing(1);
                }
                prim->ZMask(-1);
                prim->Shading(1);
                return;
            case 5:
                prim->AlphaTestEnable(0);
                prim->AlphaTest(1, 0);
                prim->AlphaBlendEnable(0);
                prim->AlphaBlend(4);
                prim->DepthTestEnable(0);
                prim->ZMask(-1);
                prim->Shading(0);
                prim->TextureMapEnable(1);
                prim->Bilinear(1);
                return;
            case 3:
                prim->AlphaTestEnable(1);
                prim->AlphaTest(1, 0);
                prim->AlphaBlendEnable(1);
                prim->AlphaBlend(1);
                prim->DepthTestEnable(0);
                prim->ZMask(-1);
                prim->Shading(1);
                prim->TextureMapEnable(0);
                break;
            default:
                break;
        }
    }
}
void PushPrimRepeat(mgCDrawPrim *prim, float *positions, int *tex_coords, int count) {
    for (int i = 0; i < count; i++) {
        prim->TextureCrd(tex_coords[i * 2], tex_coords[i * 2 + 1]);
        prim->Vertex(positions[i * 2], positions[i * 2 + 1], 0.0f);
    }
}
void PrimQuad(mgCDrawPrim *prim, float x, float y, mgRect<int> cell) {
    prim->TextureCrd(cell.left, cell.top);
    prim->Vertex(x, y, 0.0f);
    prim->TextureCrd(cell.left + cell.right, cell.top + cell.bottom);
    prim->Vertex(x + cell.right, y + cell.bottom, 0.0f);
}

void PrimQuad(mgCTexture *texture, float x, float y, mgRect<int> cell, int alpha, int red, int green,
              int blue) {

    mgCDrawPrim prim;
    SetSpriteEnv(&prim, 0);
    prim.Begin(6);
    prim.Texture(texture);
    prim.Color(red, green, blue, alpha);
    PrimQuad(&prim, x, y, cell);
    prim.End();
}

void PrimQuad(mgCDrawPrim *prim, mgCTexture *texture, float x, float y, mgRect<int> cell, int alpha,
              int red, int green, int blue) {
    SetSpriteEnv(prim, 0);
    prim->Begin(6);
    prim->Texture(texture);
    prim->Color(red, green, blue, alpha);
    PrimQuad(prim, x, y, cell);
    prim->End();
}

void PrimQuad(mgCTexture *texture, mgRect<int> dest, mgRect<int> source, int alpha, int red, int green,
              int blue) {

    mgCDrawPrim prim;
    SetSpriteEnv(&prim, 0);
    prim.Begin(6);
    prim.Texture(texture);
    prim.Color(red, green, blue, alpha);
    PrimQuad_i___FP11mgCDrawPrim9mgRect_i_9mgRect_i_(&prim, dest, source);
    prim.End();
}

void PrimQuad(mgCDrawPrim *prim, mgCTexture *texture, mgRect<int> dest, mgRect<int> source, int alpha,
              int red, int green, int blue) {
    SetSpriteEnv(prim, 0);
    prim->Begin(6);
    prim->Texture(texture);
    prim->Color(red, green, blue, alpha);
    PrimQuad_i___FP11mgCDrawPrim9mgRect_i_9mgRect_i_(prim, dest, source);
    prim->End();
}
void MenuClipRectCheck(mgRect<int> &rect) {
    if (rect.left < 0) {
        rect.left = 0;
    }
    if (rect.top < 0) {
        rect.top = 0;
    }
    int max_x = mgScreenWidth - 1;
    if (max_x < rect.right) {
        rect.right = max_x;
    }
    int max_y = mgScreenHeight - 1;
    if (max_y < rect.bottom) {
        rect.bottom = max_y;
    }
}
void SetMenuScissor(mgRect<int> rect) {
    mgCDrawPrim *prim = (mgCDrawPrim *)GetMenuPrim__Fv();
    prim->Initialize(0, 0);
    prim->Begin(0);
    Direct__11mgCDrawPrimFUlUl(
        prim, 0x40, rect.left | ((s64)rect.right << 16) | ((s64)rect.top << 32) | ((s64)rect.bottom << 48));
    prim->End();
}
void ResetMenuScissor() {
    mgCDrawPrim *prim = (mgCDrawPrim *)GetMenuPrim__Fv();
    prim->Initialize(0, 0);
    prim->Begin(0);
    Direct__11mgCDrawPrimFUlUl(
        prim, 0x40, ((s64)(mgScreenWidth - 1) << 16) | ((s64)(mgScreenHeight - 1) << 48));
    prim->End();
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menudraw", SetModeMenuDrawItemBoard__Fi);
void EnableUseItemAlphaStep() {
    use_item_enable_alpha_angle += 0.052359879f;
    if (use_item_enable_alpha_angle >= 3.1415927f) {
        use_item_enable_alpha_angle -= 6.2831855f;
    }
    use_item_enable_alpha = (int)(48.0f + 32.0f * sinf(use_item_enable_alpha_angle));
}
void InitSpectolRasterTable(mgCMemory *memory) {
    int row;
    int column;
    int offset;
    float angle;
    spectol_raster_xtbl = (int)memory->Alloc(0x4E0);
    for (row = 0, offset = 0; row < 0x9C; row++) {
        angle = 0.0418879f * (float)row;
        while (3.1415927f < angle) {
            angle -= 6.2831855f;
        }
        for (column = 0; column < 0x20; column++) {
            *(float *)(spectol_raster_xtbl + (offset + column) * 4) = 3.0f * sinf(angle);
            angle += 0.15707964f;
        }
        offset += 0x20;
    }
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menudraw", DrawOneItem__FP11mgCDrawPrim9mgRect_f_iiP25MENU_PARTS_EFFECT_STRUCT1PUci);
void MenuWindowHelp(mgCDrawPrim *prim, mgCTexture *texture, float x, float y, float width, float height,
                    short *table) {
    if (texture != 0) {
        mgRect<int> top;
        mgRect<int> middle;
        mgRect<int> bottom;
        if (table == 0) {
            table = MenuWindowHelpTable_1346;
        }
        SetSpriteEnv(prim, 0);
        prim->Begin(6);
        prim->Texture(texture);
        prim->Color(128, 128, 128, 128);
        top.Set((int)x, (int)y, (int)width, 24);
        Menu3DivideTextureDraw(prim, top, table, 1);
        middle.Set((int)x, (int)(24.0f + y), (int)width, (int)height);
        Menu3DivideTextureDraw(prim, middle, table + 12, 1);
        bottom.Set((int)x, (int)(24.0f + y + height), (int)width, 24);
        Menu3DivideTextureDraw(prim, bottom, table + 24, 1);
        prim->End();
    }
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menudraw", MenuPresentBoxView__FiiRiP10mgCTextureP10mgCTexture);
void SetMenuDrawNumberKeta(char value) {
    MenuDrawNumberKeta = value;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menudraw", DrawMenuNumber__FP11mgCDrawPrimii9mgRect_i_9mgRect_i_ii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menudraw", PrimDrawNumber__FP11mgCDrawPrimiiii9mgRect_i_ii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menudraw", PrimDrawNumber2__FP11mgCDrawPrimiiii9mgRect_i_ii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menudraw", PrimFillRect4__FP11mgCDrawPrim9mgRect_f_PfPfPfPf);
void MenuReloadTexture(int &loaded_tex, int tex_no) {
    void *manager = &mgTexManager;
    if (loaded_tex != tex_no) {
        loaded_tex = tex_no;
        ReloadTexture__17mgCTextureManagerFiP13sceVif1Packet(manager, loaded_tex, 0);
    }
}
void MenuReloadCLUT(int index) {
    texture_pair t = at_1521__2;
    t.tex[0] = MenuCharaChangeCLUT_Tex;
    t.tex[1] = MenuCharaChangeBase_Tex;
    if (t.tex[index] != 0) {
        ReloadCLUT__17mgCTextureManagerFP10mgCTextureP13sceVif1Packet(&mgTexManager, t.tex[index],
                                                                      0);
    }
}
void DrawMenuFillBox(int alpha, int red, int green, int blue) {
    DrawMenuFillBox__Fffffiiii(0.0f, 0.0f, (float)mgScreenWidth, (float)mgScreenHeight, alpha, red,
                               green, blue);
}

void DrawMenuFillBox(float x, float y, float width, float height, int alpha, int red, int green, int blue) {
    mgCDrawPrim *prim;

    prim = GetMenuPrim();
    SetSpriteEnv(prim, 1);
    prim->DepthTestEnable(0);
    prim->Begin(6);
    prim->Color(red, green, blue, alpha);
    prim->Vertex(x, y, 0.0f);
    prim->Vertex(x + width, y + height, 0.0f);
    prim->End();
}

void DrawMenuFillBox(mgCDrawPrim *prim, float x, float y, float width, float height, int alpha, int red,
                     int green, int blue) {
    SetSpriteEnv(prim, 1);
    prim->DepthTestEnable(0);
    prim->Begin(6);
    prim->Color(red, green, blue, alpha);
    prim->Vertex(x, y, 0.0f);
    prim->Vertex(x + width, y + height, 0.0f);
    prim->End();
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menudraw", GenarateRandamLine__FPiiiPiii);
void DrawRandamLine(mgCDrawPrim *prim, int *points, int smoothing, int count, u8 *color) {
    float source[1000][4];
    float smoothed[2000][4];
    int i;
    int k;
    int total;
    if (prim == 0 || points == 0) {
        return;
    }
    for (i = 0; i < count; i++) {
        source[i][0] = (float)points[i * 2];
        source[i][1] = (float)points[i * 2 + 1];
        source[i][2] = 0;
    }
    SetSpriteEnv(prim, 3);
    prim->Begin(2);
    CreatSmoothPass(smoothed, source, count, smoothing, 0, count);
    prim->Color(color[0], color[1], color[2], color[3]);
    prim->Vertex(smoothed[0][0], smoothed[0][1], 0.0f);
    total = (count - 1) * (smoothing - 1);
    for (k = 0; k < total; k++) {
        prim->Vertex(smoothed[k][0], smoothed[k][1], 0.0f);
    }
    prim->End();
}
mgCTexture *GetMenuDlTexture(void) {
    return mgTexManager.GetTexture(at_1622__2, -1);
}
void InitMenuDl(mgCTexture *texture, int total_size) {
    Tex_MenuDl = texture;
    MenuDl_TotalSize = total_size;
    MenuDl_ProcessSize = 0;
}
int StepMenuDl(int step) {
    if (MenuDl_TotalSize <= 0) {
        return 1;
    }
    MenuDl_ProcessSize += step;
    if (MenuDl_TotalSize <= MenuDl_ProcessSize) {
        MenuDl_ProcessSize = MenuDl_TotalSize;
        return 1;
    }
    return 0;
}
int StepMenuDl2(int progress) {
    if (MenuDl_TotalSize <= 0) {
        return 1;
    }
    MenuDl_ProcessSize = progress;
    if (MenuDl_TotalSize <= progress) {
        MenuDl_ProcessSize = MenuDl_TotalSize;
        return 1;
    }
    return 0;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menudraw", DrawMenuDl__FRiiiii);
void DrawMenuDl(int alpha) {
    char text[0x80];

    struct {
        u8 padding[0x90];
        int alpha;
        int pos_x;
        int pos_y;
        u8 tail[0x1C];
    } menuFont;
    int loaded_tex_no;
    int caption_height;
    int caption_width;
    if (Tex_MenuDl != 0) {
        if (alpha < 0) {
            alpha = 0;
        }
        loaded_tex_no = -1;
        int panel_width = 0x10E;
        if (LanguageCode == 2 || LanguageCode == 4 || LanguageCode == 5) {
            panel_width = 0x13A;
        }
        DrawMenuDl(loaded_tex_no, 0, 0x72, panel_width, alpha);
        int language = LanguageCode;
        short *texture = (short *)mgTexManager.GetTexture(at_1711, -1);
        if (texture != 0) {
            MenuReloadTexture(loaded_tex_no, *texture);
            int step = StepMenuDl(0);
            memset(text, 0, 0x80);
            ConvertFontCode__FPcPc(tbl_1689[language][step], text);
            __ct__9CMenuFontFv(&menuFont);
            menuFont.alpha = alpha;
            SetStr__5CFontFPc(&menuFont, text);
            CalcDrawWH__5CFontFPcPiPi(&menuFont, (char *)&menuFont, &caption_width, &caption_height);
            SetPos__5CFontFii(&menuFont, (0x200 - caption_width) >> 1, 0x86);
            DrawDirect__5CFontFPcii(&menuFont, (char *)&menuFont, menuFont.pos_x,
                                    menuFont.pos_y);
        }
    }
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menudraw", CalcCommonBrdDrawInfo__FPfP21MENUFORM_MAKEBRD_INFOP6ClsMes);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menudraw", CommonBoardDraw__FPfRi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menudraw", MenuCursorDraw__FP10mgCTexturePffiif);
void MenuCursorDraw(mgCTexture *texture, float *position, float value, int flag) {
    MenuCursorDraw(texture, position, value, 0, flag, 1.0f);
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menudraw", DrawMenuTilePattern__FP11mgCDrawPrimP10mgCTextureff9mgRect_i_iPUc);
void DrawMenuMainFrmImg(int &loaded_tex_no, mgRect<int> dest, mgRect<int> source, int red, int green,
                        int blue, int alpha, int unused) {
    mgCTexture *texture = *(mgCTexture **)((u8 *)MenuPosData + 0x3C);
    if (texture != 0) {
        MenuReloadTexture(loaded_tex_no, *(short *)texture);
        mgCDrawPrim *prim = (mgCDrawPrim *)GetMenuPrim__Fv();
        SetSpriteEnv(prim, 5);
        prim->Begin(6);
        prim->Texture(texture);
        prim->Color(red, green, blue, alpha);
        PrimQuad_i___FP11mgCDrawPrim9mgRect_i_9mgRect_i_(prim, dest, source);
        prim->End();
    }
}
int GetMenuMainFrameEndFlag(void) {
    return MenuMainFrame_ActionEndFlag;
}
float *GetMenuMainFrameLeftTopPos(int frame) {
    return (float *)MenuMainFrame_LeftTop_Pos;
}
float GetMenuMainFrameCount(void) {
    return tbl_2072[MenuMainFrame_Display_Mode / 2];
}
void MenuMainFrameModeSet(int mode, int restart) {
    MenuMainFrame_Display_Mode = mode;
    MenuMainFrame_ActionEndFlag = 0;
    MenuMainFrame_MoveRate[0] = 1.0f;
    if (restart != 0) {
        switch (MenuMainFrame_Display_Mode) {
            case 0:
                MenuMainFrame_Display_Mode_Cnt = 0.0f;
                MenuMainFrame_Display_Mode_Cnt_Rate = 0.7f;
                break;
            case 2:
            case 4:
            case 6:
            case 8:
                MenuMainFrame_Display_Mode_Cnt = 10.0f;
                MenuMainFrame_Lenze_Pos[0] = 350.0f;
                MenuMainFrame_Lenze_Pos[1] = 240.0f;
                break;
        }
    }
    MenuMainFrame_MoveRate[0] = GetMenuMainFrameCount();
    MenuMainFrame_MoveRate[1] = GetMenuMainFrameCount();
    MenuMainFrame_MoveRate_Cnt = 0.0f;
    if (MenuMainFrame_Display_Mode >= 4) {
        MenuMainFrame_MoveRate_Cnt = 0.2617994f;
    }
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menudraw", MenuMainFrameStep__Fv);
void MenuMainFrameDraw(int &loaded_tex, int unused) {
    mgRect<int> screenRect;
    float alpha, radiusX, radiusY, turn, scale, x0, y0, x1, y1, x3, y3, x2, y2, x4, size, y4, angle;
    mgCTextureManager *textures = &mgTexManager;
    mgCTexture *background = textures->GetTexture(at_2237, -1);
    if (background == NULL) {
        return;
    }
    screenRect.Set(0, 0, 0x2C0, 0x1A0);
    radiusX = 160.0f;
    alpha = 128.0f;
    float progress = MenuMainFrame_Display_Mode_Cnt / 10.0f;
    scale = 1.5f - 0.5f * progress;
    switch (MenuMainFrame_Display_Mode) {
        case 0:
        case 1:
            alpha = 128.0f * progress;
            break;
    }
    turn = 0.7853982f * progress;
    angle = -0.5235988f + turn;
    radiusX *= scale;
    radiusY = 120.0f * scale;
    x0 = MenuMainFrame_Lenze_Pos[0] - radiusX * cosf(angle);
    y0 = MenuMainFrame_Lenze_Pos[1] - radiusX * sinf(angle);
    x1 = MenuMainFrame_Lenze_Pos[0] - radiusY * cosf(angle - 0.2617994f);
    y1 = MenuMainFrame_Lenze_Pos[1] - radiusY * sinf(angle - 0.2617994f);
    angle += 0.7853982f;
    x3 = MenuMainFrame_Lenze_Pos[0] - radiusX * cosf(angle);
    y3 = MenuMainFrame_Lenze_Pos[1] - radiusX * sinf(angle);
    angle = 0.24166098f + angle;
    x2 = MenuMainFrame_Lenze_Pos[0] - radiusY * cosf(angle);
    y2 = MenuMainFrame_Lenze_Pos[1] - radiusY * sinf(angle);
    turn = -0.83775806f + turn;
    x4 = MenuMainFrame_Lenze_Pos[0] - radiusX * cosf(turn);
    y4 = MenuMainFrame_Lenze_Pos[1] - radiusX * sinf(turn);
    size = 3.0 * 16.0 * scale;
    MenuReloadTexture(loaded_tex, background->block);
    mgCDrawPrim *prim = GetMenuPrim();
    SetSpriteEnv(prim, 0);
    prim->Bilinear(1);
    prim->Begin(6);
    prim->Texture(background);
    int alpha_int;
    prim->Color(0x80, 0x80, 0x80, alpha_int = fptosi(alpha));
    PrimQuad_i___FP11mgCDrawPrim9mgRect_i_9mgRect_i_(prim, MenuMainFrame_PutRect, screenRect);
    prim->End();
    mgCTexture *ornament = textures->GetTexture(at_2238, -1);
    prim->AlphaBlend(2);
    prim->Shading(1);
    prim->Begin(5);
    prim->Texture(ornament);
    prim->Color(0x80, 0x80, 0x80, alpha_int);
    prim->TextureCrd(0x1A, 8);
    prim->Vertex(x0, y0, 0.0f);
    prim->TextureCrd(0x1A, 0x1A);
    prim->Vertex(x1, y1, 0.0f);
    prim->TextureCrd(0x38, 0x1A);
    prim->Vertex(x2, y2, 0.0f);
    prim->TextureCrd(0x38, 8);
    prim->Vertex(x3, y3, 0.0f);
    prim->End();
    prim->Begin(6);
    prim->TextureCrd(4, 0xA);
    prim->Vertex(x4, y4, 0.0f);
    prim->TextureCrd(0x12, 0x18);
    prim->Vertex(fptosi(x4 + size), fptosi(y4 + 1.25f * size), 0);
    prim->End();
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menudraw", MenuMainFrameImgDraw__FRi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menudraw", DrawMenuWakuStep__Fv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menudraw", DrawMenuWakuRect__FP10mgCTexture9mgRect_f_9mgRect_i_iiii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menudraw", DrawWakuCircle__FP11mgCDrawPrimP10mgCTexture9mgRect_f_9mgRect_i_ffiiii);
void MENU_BASETEXINFO_Init(MENU_BASETEXINFO *info) {
    info->name = 0;
    info->tex_name = 0;
    info->rect.Set(0, 0, 0, 0);
    info->tex_block = 0;
}
void MenuPosDataTypeInit(MENUFORMPARTS_TYPE *part) {
    part->name = NULL;
    part->active = 0;
    part->draw_flag = 1;
    part->dtype = 0;
    part->vibe_cnt[1] = 0;
    part->vibe_cnt[0] = 0;
    part->viber[0] = 10;
    part->viber[1] = 8;
    part->tex_info_no = 0;
    part->h = 0;
    part->w = 0;
    part->y = 0;
    part->x = 0;
    part->rgba[3] = 0x80;
    part->rgba[2] = 0x80;
    part->rgba[1] = 0x80;
    part->rgba[0] = 0x80;
    part->etc_info[2] = 0;
    part->etc_info[1] = 0;
    part->etc_info[0] = 0;
    part->unk_2c = 1.0f;
    part->effect_num = 0;
    part->effect = NULL;
    part->alpha_blend = 1;
    part->bilinear = 0;
    part->item_flag = 0;
    *(int *)&part->tex = 0;
    part->shadow = 0;
}
void MenuFormPartsPresetItem(MENUFORMPARTS_TYPE *part, int visible, int value34, int value38) {
    if (part != NULL) {
        part->draw_flag = visible != 0;
        part->etc_info[0] = 0;
        part->etc_info[1] = value34;

        part->etc_info[2] = value38;
        Func_MenuItemIconSetEffectOne(part);
    }
}
void CMenuPosDataForm::Initialize(void) {
    int i;
    u8 *bytes = (u8 *)this;
    name = NULL;
    active = 0;
    draw_flag = 1;
    y = 0;
    x = 0;
    dtype = 0;
    vibe_cnt[1] = 0;
    vibe_cnt[0] = 0;
    clip_h = -1;
    clip_w = -1;
    *(int *)&bytes[0x28] = 0;
    *(int *)&bytes[0x24] = 0;
    rate_y = 1.1f;
    rate_x = 1.1f;
    bytes[0x20] = 0xFF;
    bytes[0x50] = 0;
    for (i = 0; i < 4; i++) {
        bytes[0x51 + i] = 0;
        bytes[0x55 + i] = 0x80;
        bytes[0x59 + i] = 0x80;
    }
    *(int *)&bytes[0x18] = 0;
    parts_num = 0;
    parts = NULL;
    *(int *)&bytes[0x38] = 0;
    *(short *)&bytes[0x34] = 0;
    *(short *)&bytes[0x36] = 0;
    step_stop = 0;
    *(short *)&bytes[0x5E] = -1;
    *(short *)&bytes[0x60] = -1;
    action_num = 0;
    action = NULL;
    bytes[0x1C] = 0;
    prev = NULL;
    next = NULL;
}
MENUFORMPARTS_TYPE *CMenuPosDataForm::GetPartInfo(char *name) {
    int i = 0;
    int offset = 0;
    while (i < parts_num) {
        if (strcmp(((MENUFORMPARTS_TYPE *)((u8 *)parts + offset))->name, name) == 0) {
            return parts + i;
        }
        offset += 0x48;
        i++;
    }
    return NULL;
}
void CMenuPosDataForm::SetPartDrawFlag(char *name, bool draw_flag) {
    MENUFORMPARTS_TYPE *part = GetPartInfo(name);
    if (part != NULL) {
        part->draw_flag = draw_flag;
    }
}
void Func_MallocPartEffectInfo(MENUFORMPARTS_TYPE *part, mgCMemory *memory, int effect_count) {
    unsigned int bytes;
    unsigned int blocks;

    if (part != NULL) {
        bytes = effect_count * sizeof(MENU_PARTS_EFFECT_STRUCT1);
        part->effect_num = (signed char)effect_count;
        if (bytes & 0xF) {
            blocks = (bytes >> 4) + 1;
        } else {
            blocks = bytes >> 4;
        }
        part->effect = (MENU_PARTS_EFFECT_STRUCT1 *)memory->Alloc(blocks);
    }
}
void Func_SetPartEffectInfo(MENU_PARTS_EFFECT_STRUCT1 *effect, unsigned int kind, short *values) {
    int i;
    if (effect == NULL)
        return;
    effect->type = kind;
    for (i = 0; i < 8; i++) {
        effect->param[i] = 0;
        if (values != NULL) {
            effect->param[i] = values[i];
        }
    }
}
void CMenuPosDataForm::SetActionCharaPtr(CActionChara *character, int texture_block, int secondary_block) {
    chara = character;
    chara_tex_block = texture_block;
    unk_36 = secondary_block;
}
void CMenuPosDataForm::SetRGBACalcParam(int index, int from, int to) {
    if (index < 0 || index > 3)
        return;
    u8 *p = (u8 *)index + (int)this;
    p[0x51] = from;
    p[0x59] = to;
}
#pragma divbyzerocheck on
void CMenuPosDataForm::FormFadeIn(int frames, int reset) {
    int i;
    if (reset != 0) {
        i = 0;
        rgba[0] = 0x80;
        rgba[1] = 0x80;
        rgba[2] = 0x80;
        rgba[3] = 0;
        do {
            SetRGBACalcParam(i, 0, 0x80);
            i++;
        } while (i < 4);
    }
    SetRGBACalcParam(3, 0x80 / frames, 0x80);
}
#pragma divbyzerocheck reset
#pragma divbyzerocheck on
void CMenuPosDataForm::FormFadeOut(int frames, int reset) {
    int i;
    if (reset != 0) {
        i = 0;
        rgba[0] = 0x80;
        rgba[1] = 0x80;
        rgba[2] = 0x80;
        rgba[3] = 0x80;
        do {
            SetRGBACalcParam(i, 0, 0x80);
            i++;
        } while (i < 4);
    }
    SetRGBACalcParam(3, -0x80 / frames, 0);
}
#pragma divbyzerocheck reset
void CMenuPosDataForm::SetNumber(char *part_name, int number) {
    MENUFORMPARTS_TYPE *part = GetPartInfo(part_name);
    if (part != NULL) {
        part->etc_info[1] = number;
    }
}
void CMenuPosDataForm::SetPartRGBA(char *name, int r, int g, int b, int a) {
    MENUFORMPARTS_TYPE *part = GetPartInfo(name);
    if (part != NULL) {
        part->rgba[0] = r;
        part->rgba[1] = g;
        part->rgba[2] = b;
        part->rgba[3] = a;
    }
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menudraw", GetPutPosXY__16CMenuPosDataFormFPcRiRi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menudraw", GetPutPosXY__16CMenuPosDataFormFPcRfRf);
MENUFORMPARTS_TYPE *CMenuPosDataForm::GetEnableEnterPart(void) {
    int i = 0;
    int offset = 0;
    MENUFORMPARTS_TYPE *part;
    MENUFORMPARTS_TYPE *base;
    while (i < parts_num) {
        base = parts;
        part = (MENUFORMPARTS_TYPE *)((u8 *)base + offset);
        if (part->name == NULL && part->active == 0) {
            return base + i;
        }
        offset += 0x48;
        i++;
    }
    return NULL;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menudraw", GetNowPosRGBA__16CMenuPosDataFormFP18MENUFORMPARTS_TYPEP16MENU_BASETEXINFOPfPUc);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menudraw", MenuPartsStep__16CMenuPosDataFormFv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menudraw", DrawItemIconEffect2__FP11mgCDrawPrimP10mgCTextureP18MENUFORMPARTS_TYPE9mgRect_f_);
void MenuItemBrdSetInfo(int unused, int pos, int max_line, int view_line) {
    float hidden_lines;
    MenuItemBrdMaxLine = max_line;
    MenuItemBrdViewLine = view_line;
    hidden_lines = (float)(max_line - view_line);
    if (hidden_lines < 1.0f) {
        hidden_lines = 1.0f;
    }
    MenuItemBrdScrlCurLen = 256.0f / hidden_lines;
    MenuItemBrdCalcManner = 1;
    Func_MenuItemBrdPosStep(pos);
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menudraw", MenuItemBrdFrameDraw__FiiRiiiii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menudraw", MenuItemBrdDraw__FPf9mgRect_i_Riiiii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menudraw", MenuItemModeItemDraw__FRi9mgRect_i_PfP18MENUFORMPARTS_TYPEP10mgCTexture9mgRect_i_i);
int CMenuPosDataForm::MenuFormStep(void) {
    int ended = 0;
    int next[2];
    int calc;
    int i;
    if (step_stop != 0) {
        return 0;
    }
    GetNextMovePos(next);
    counter += 1;
    if (counter > 100000) {
        counter = 0;
    }
    if ((u8)dtype == 13 || (u8)dtype == 15) {
        if (counter > 15) {
            counter = 15;
        }
    }
    if ((u8)dtype == 24) {
        MENUFORMPARTS_TYPE *part = parts;
        MENU_BASETEXINFO *texture = MenuPosData->GetTexGetInfo(part->tex_info_no);
        if (counter % 2 != 0) {
            next[0] += part->etc_info[0];
            next[1] += part->etc_info[1];
        }
        if (part->etc_info[0] < 0) {
            if (next[0] <= -texture->rect.right) {
                next[0] = 0;
            }
        } else if (part->etc_info[0] > 0 && next[0] >= 0) {
            next[0] = -texture->rect.right;
        }
        if (part->etc_info[1] < 0) {
            if (next[1] <= -texture->rect.bottom) {
                next[1] = 0;
            }
        } else if (part->etc_info[1] > 0 && next[1] >= 0) {
            next[1] = -texture->rect.bottom;
        }
    } else if ((u8)dtype != 20) {
        MenuPartsStep();
    }
    if (CheckMoveEnd(next[0], next[1]) != 0) {
        ended = 1;
        action_state = 4;
    }
    i = 0;
    do {
        u8 *channel = (u8 *)this + i;
        signed char step = channel[0x51];
        signed char *step_ptr = (signed char *)&channel[0x51];
        if (step != 0) {
            calc = channel[0x55];
            u8 *value_ptr = &channel[0x55];
            if (CalcMenuAdd(&calc, step, channel[0x59]) != 0) {
                *step_ptr = 0;
            }
            *value_ptr = calc;
        }
        i++;
    } while (i < 4);
    x = (float)next[0];
    y = (float)next[1];
    return ended;
}
int CMenuPosDataForm::CheckMoveEnd(int target_x, int target_y) {
    int finished = 0;
    if (x == (float) target_x) {
        finished = 1;
        if (y != (float) target_y) {
            finished = 0;
        }
    }
    return finished;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menudraw", CheckMoveEnd__16CMenuPosDataFormFv);
void CMenuPosDataForm::SetAction(char *action) {
    int i = 0;
    int offset = 0;
    while (i < action_num) {
        if (strcmp(action, (char *)this->action + offset) == 0) {
            *(short *)((u8 *)this + 0x5E) = i;
            *(short *)((u8 *)this + 0x60) = 1;
            return;
        }
        offset += 0x14;
        i++;
    }
    *(short *)((u8 *)this + 0x5E) = -1;
}
void CMenuPosDataForm::SetNextMovePos(int *position, int move_type) {
    mtype = move_type;
    next_x = position[0];
    next_y = position[1];
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menudraw", GetNextMovePos__16CMenuPosDataFormFPi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menudraw", Menu3DivideTextureDraw__FP11mgCDrawPrim9mgRect_i_Psi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menudraw", MenuFormDrawNormal__16CMenuPosDataFormFiiffRi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menudraw", MenuFormDraw__16CMenuPosDataFormFiiRi);
void CMenuPosDataForm::MenuFormDraw(int &state) {
    MenuFormDraw(fptosi(x), fptosi(y), state);
}
void CPosDataManage::Initialize(void) {
    etc_tbl = NULL;
    etc_tbl_num = 0;
    tex_info = NULL;
    tex_info_num = 0;
    form = NULL;
    form_num = 0;
    step_stop = 0;
}
MENU_BASETEXINFO *CPosDataManage::GetTexGetInfo(int no) {
    if (no < 0 || tex_info_num <= no) {
        return NULL;
    }
    return tex_info + no;
}
MENU_BASETEXINFO *CPosDataManage::GetTexGetInfo(char *name) {
    int i;

    if (name == NULL) {
        return NULL;
    }
    for (i = 0; i < tex_info_num; i++) {
        if (tex_info[i].name != 0 && strcmp(name, tex_info[i].name) == 0) {
            return tex_info + i;
        }
    }
    return NULL;
}
int CPosDataManage::GetTexGetInfoTblNo(char *name) {
    int i;

    if (name != NULL) {
        for (i = 0; i < tex_info_num; i++) {
            if (tex_info[i].name != 0 && strcmp(tex_info[i].name, name) == 0) {
                return i;
            }
        }
    }
    return -1;
}
void CPosDataManage::TexGetInfoClear(int from, int to) {
    int i;

    if (tex_info_num < to) {
        to = tex_info_num;
    }
    for (i = from; i < to; i++) {
        MENU_BASETEXINFO_Init(tex_info + i);
    }
}
void CPosDataManage::ResetTextureBlockNo(char *name, int block) {
    MENU_BASETEXINFO *info;
    int i;

    info = GetTexGetInfo(0);
    for (i = 0; i < tex_info_num; i++, info++) {
        if (info->tex_name != 0 && strcmp(info->tex_name, name) == 0) {
            info->tex_block = block;
        }
    }
}
void CPosDataManage::ResetTextureInfoAll() {
    mgCTextureManager *tex_manager = &mgTexManager;
    CMenuPosDataForm *form;
    MENUFORMPARTS_TYPE *part;
    MENU_BASETEXINFO *info;
    int i;

    form = GetDrawTopList();
    if (form != NULL) {
        do {
            part = form->parts;
            for (i = 0; i < form->parts_num && part != NULL; i++, part++) {
                info = GetTexGetInfo(part->tex_info_no);
                if (info != NULL) {
                    part->tex = tex_manager->GetTexture(info->tex_name, (u8)info->tex_block);
                }
            }
            form = form->next;
        } while (form != NULL);
    }
}
void CPosDataManage::EtcTblClear(int from, int to) {
    MENU_ETCINFO *p;
    int end;
    int i;

    end = to;
    if (etc_tbl_num < end) {
        end = etc_tbl_num;
    }
    p = etc_tbl + from;
    for (i = 0; i < end - from; i++, p++) {
        p->name = 0;
    }
}
MENU_ETCINFO *CPosDataManage::GetEtcTbl(char *name) {
    MENU_ETCINFO *p;
    u16 n;
    int i;

    if (name == NULL) {
        return NULL;
    }
    n = etc_tbl_num;
    p = etc_tbl;
    i = 0;
    if (0 < n) {
        do {
            if (p->name != 0 && strcmp(p->name, name) == 0) {
                return p;
            }
            i++;
            p++;
        } while (i < n);
    }
    return NULL;
}
void CPosDataManage::GetEtcTblValue(char *name, int &value1, int &value2) {
    MENU_ETCINFO *entry = GetEtcTbl(name);

    if (entry == NULL) {
        if (&value1 != NULL) {
            value1 = 0;
        }
        if (&value2 != NULL) {
            value2 = 0;
        }
        return;
    }
    if (&value1 != NULL) {
        value1 = entry->value[0];
    }
    if (&value2 != NULL) {
        value2 = entry->value[1];
    }
}
MENU_ETCINFO2 *CPosDataManage::GetEtcTbl2(char *name) {
    MENU_ETCINFO2 *p;
    u16 n;
    int i;

    if (name == NULL) {
        return NULL;
    }
    n = etc_tbl2_num;
    p = etc_tbl2;
    i = 0;
    if (0 < n) {
        do {
            if (p->name != 0 && strcmp(p->name, name) == 0) {
                return p;
            }
            i++;
            p++;
        } while (i < n);
    }
    return NULL;
}
void CPosDataManage::GetEtcTbl2Value(char *name, float *out, int count) {
    MENU_ETCINFO2 *entry = GetEtcTbl2(name);
    int i;

    if (entry == NULL) {
        return;
    }
    for (i = 0; i < count; i++) {
        out[i] = entry->value[i];
    }
}
void CPosDataManage::EtcTbl2Clear(int from, int to) {
    MENU_ETCINFO2 *p;
    int end;
    int count;
    int i;

    end = to;
    if (etc_tbl2_num < end) {
        end = etc_tbl2_num;
    }
    count = end - from;
    i = 0;
    p = etc_tbl2 + from;
    if (0 < count) {
        do {
            i++;
            p->name = 0;
            p++;
        } while (i < count);
    }
}
void *GetMenuMainIconChar(int icon_no) {
    sprintf(&temp_3925, &at_3927, icon_no - 2);
    return &temp_3925;
}
CMenuPosDataForm *CPosDataManage::GetFormInfo(char *name) {
    CMenuPosDataForm *form;
    int i;

    if (name == NULL) {
        return NULL;
    }
    form = GetDrawTopList();
    i = 0;
    while (form != NULL && i < form_num) {
        if (form->name == 0) {
            break;
        }
        if (strcmp(form->name, name) == 0) {
            return form;
        }
        form = form->next;
        i++;
    }
    return NULL;
}
CMenuPosDataForm *CPosDataManage::GetFormInfo(int no) {

    if (no < 0 || form_num <= no) {
        return NULL;
    }
    return form + no;
}
void CPosDataManage::FormInfoClear(int from, int to) {
    int i;

    if (from < 0) {
        from = 0;
    }
    if (!(to < form_num)) {
        to = form_num;
    }
    for (i = from; i < to; i++) {
        (form + i)->Initialize();
    }
}
void CPosDataManage::SetFormPos(char *name, int *pos) {
    CMenuPosDataForm *form = GetFormInfo(name);
    if (form != NULL) {
        form->x = (float)pos[0];
        form->y = (float)pos[1];
    }
}
void CPosDataManage::InitDrawList() {
    CMenuPosDataForm *form = this->form;
    CMenuPosDataForm *prev = NULL;
    CMenuPosDataForm *next;
    int i = 0;
    int j;
    while (i < form_num) {
        form->prev = prev;
        next = NULL;
        for (j = 1; j < form_num - i; j++) {
            if (form[j].name != 0) {
                i += j;
                next = form + j;
                break;
            }
        }
        form->next = next;
        prev = form;
        form = next;
        if (form == NULL) {
            break;
        }
    }
}
CMenuPosDataForm *CPosDataManage::GetDrawTopList() {

    CMenuPosDataForm *next;
    CMenuPosDataForm *form;

    form = GetFormInfo(0);
    if (form != NULL) {
    loop_1:
        next = form->prev;
        if (next == NULL) {
            return form;
        }
        form = next;
        if (next == NULL) {
            goto block_4;
        }
        goto loop_1;
    }
block_4:
    return NULL;
}
void CPosDataManage::FormReLink(char *form, char *target) {
    CMenuPosDataForm *a = GetFormInfo(form);
    CMenuPosDataForm *b = GetFormInfo(target);
    CMenuPosDataForm *old_top;
    CMenuPosDataForm *old_next;

    if (a == NULL || b == NULL) {
        return;
    }
    old_top = a->prev;
    old_next = a->next;
    a->prev = b->prev;
    a->next = b->next;
    b->prev = old_top;
    b->next = old_next;
    if (b->prev != NULL) {
        b->prev->next = b;
    }
    if (b->next != NULL) {
        b->next->prev = b;
    }
    if (a->next != NULL) {
        a->next->prev = a;
    }
    if (a->prev != NULL) {
        a->prev->next = a;
    }
}
void CPosDataManage::FormReLink2(char *form, char *target, char *third, char *fourth) {
    CMenuPosDataForm *a = GetFormInfo(form);
    CMenuPosDataForm *t = GetFormInfo(third);
    CMenuPosDataForm *g = GetFormInfo(target);
    CMenuPosDataForm *f = GetFormInfo(fourth);
    CMenuPosDataForm *g_next;
    CMenuPosDataForm *f_next;
    CMenuPosDataForm *t_top;
    CMenuPosDataForm *a_top;

    if (a == NULL || t == NULL) {
        return;
    }
    a_top = a->prev;
    g_next = NULL;
    t_top = t->prev;
    f_next = NULL;
    if (g != NULL) {
        g_next = g->next;
    }
    if (f != NULL) {
        f_next = f->next;
    }
    if (g == t_top) {
        t->prev = a_top;
        a_top->next = t;
        a->prev = f;
        f->next = a;
        g->next = f_next;
        f_next->prev = g;
    } else if (f == a_top) {
        a->prev = a_top;
        t_top->next = a;
        t->prev = g;
        g->next = t;
        f->next = g_next;
        g_next->prev = f;
    } else {
        t->prev = a_top;
        if (a_top != NULL) {
            a_top->next = t;
        }
        if (g_next != NULL) {
            f->next = g_next;
            g_next->prev = f;
        }
        a->prev = t_top;
        if (t_top != NULL) {
            t_top->next = a;
        }
        if (f_next != NULL) {
            g->next = f_next;
            f_next->prev = g;
        }
    }
}
void CPosDataManage::FormStep() {
    CMenuPosDataForm *form = GetDrawTopList();
    int was_visible;

    if (form != NULL) {
        do {
            was_visible = form->step_stop;
            if (step_stop != 0) {
                form->step_stop = 1;
            }
            form->MenuFormStep();
            if (was_visible == 0) {
                form->step_stop = 0;
            }
            form = form->next;
            if (form == NULL) {
                break;
            }
        } while (form != NULL);
    }
}
void MenuDrawParamStep() {
    DrawMenuWakuStep();
    EnableUseItemAlphaStep();
    DrawItemCounter += 0.25f;
    if (!(DrawItemCounter < 10.0f)) {
        DrawItemCounter = 0.0f;
    }
    DrawItemDefCounter += 1;
    if (DrawItemDefCounter >= 0x50) {
        DrawItemDefCounter = 0;
    }
}
void CPosDataManage::FormDraw() {
    int state = -1;
    CMenuPosDataForm *form = GetDrawTopList();

    if (form != NULL) {
        do {
            form->MenuFormDraw(state);
            form = form->next;
            if (form == NULL) {
                break;
            }
        } while (form != NULL);
    }
}
void CPosDataManage::ClearPos(void) {
    EtcTblClear(0, etc_tbl_num);
    TexGetInfoClear(0, tex_info_num);
    FormInfoClear(0, form_num);
}
void CMenuPosDataManage::AttachCommonTexInfo() {
    common_tex = (&mgTexManager)->GetTexture(at_4182, -1);
    unk_40 = NULL;
    icon_effect_tex = (&mgTexManager)->GetTexture(at_4183, -1);
    effect_tex = (&mgTexManager)->GetTexture(at_4184, -1);
    item_icon_tex[0][0] = (&mgTexManager)->GetTexture(at_4185__2, -1);
    item_icon_tex[0][1] = (&mgTexManager)->GetTexture(at_4186, -1);
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menudraw", StepMainMenuIconMove__18CMenuPosDataManageFPiii);
int CheckItemUseVariable(CGameDataUsed *item, CItemUseTarget *target) {
    int state;
    int result;

    if ((item == NULL) || (target == NULL)) {
        return 0;
    }
    state = CheckNowStateUseThisItem(item, target);
    result = state;
    if (CheckBuildUp((CGameDataUsed *)target->target.data, NULL, NULL, NULL) != 0) {
        result = state | 2;
    }
    return result;
}
void Func_MenuItemBrdPrepare(MENUFORMPARTS_TYPE *parts, CGameDataUsed *items, CGameDataUsed *used,
                             int target_kind) {
    CGameDataUsed *item;
    int count;
    int i;

    if (parts != NULL) {
        CItemUseTarget target;
        count = GetNowBagMax(1);
        i = 0;
        if (0 < count) {
            do {

                item = (CGameDataUsed *)((u8 *)items + i * 0x6C);
                target.SetPtr(target_kind, item);
                parts->item_flag = CheckItemUseVariable(used, &target);
                i++;
                parts++;
            } while (i < count);
        }
    }
}
void Func_MenuItemBrdPrepare2(MENUFORMPARTS_TYPE *parts, CGameDataUsed *items,
                              CGameDataUsed *used) {
    int count;
    int i;
    int offset;
    int item_no;

    if (parts == NULL) {
        return;
    }
    if (used == NULL) {
        return;
    }
    count = GetNowBagMax(1);
    item_no = used->item_no;
    i = 0;
    if (0 < count) {

        offset = 0;
        do {
            if (item_no == 0x17D) {
                parts->item_flag = 0;
            } else {
                CItemUseTarget target;
                target.SetPtr(1, (u8 *)items + offset);
                parts->item_flag = CheckItemUseVariable(used, &target);
            }
            i++;
            offset += 0x6C;
            parts++;
        } while (i < count);
    }
}
int NowUseNeedItemCheck(CUserDataManager *manager) {
    int needs;
    int in_battle;
    int limit;
    int party;
    int active_chara;
    CHARA_DATA *charas[2];
    ROBO_DATA *robo;
    CHARA_DATA *chara;
    CGameDataUsed *weapon;

    if (manager == NULL) {
        return 0;
    }
    needs = 0;
    in_battle = 0;
    if ((*(u16 *)((u8 *)GetMainScene() + 0x2F9C) & 4) != 0) {
        in_battle = 1;
    }
    active_chara = manager->active_chr_no;
    party = manager->GetNowPartyMember();
    charas[0] = manager->GetCharaDataPtr(0);
    charas[1] = manager->GetCharaDataPtr(1);
    if ((party & 4) != 0) {
        robo = &manager->robo_data;
        if (robo != NULL) {
            if (robo->AddPoint(0.0f) < 0.2f) {
                needs |= 0x80;
            }
        }
        limit = GetShiledKitLimmit(CheckRobotCore__16CUserDataManagerFv(manager));
        if (robo->shield_kit_num < limit) {
            needs |= 0x10000;
        }
    }
    if (active_chara == 0 || active_chara == 1) {
        chara = charas[active_chara];
        if (active_chara == 0 || (active_chara == 1 && (party & 2) != 0)) {
            if (chara->hp.GetRate() < 0.2f) {
                needs |= 1;
            }
            if ((chara->status_attr & 0x1) != 0) {
                needs |= 0x100;
            }
            if ((chara->status_attr & 0x2) != 0) {
                needs |= 0x200;
            }
            if ((chara->status_attr & 0x4) != 0) {
                needs |= 0x400;
            }
            if ((chara->status_attr & 0x8) != 0) {
                needs |= 0x800;
            }
            if ((chara->status_attr & 0x10) != 0) {
                needs |= 0x1000;
            }
            if ((chara->status_attr & 0x20) != 0) {
                needs |= 0x2000;
            }
            if ((chara->status_attr & 0x40) != 0) {
                needs |= 0x4000;
            }
        }
        weapon = &chara->equip[0];
        if (weapon->GetWHp(NULL) < 0.2f) {
            needs |= 2;
        }
        if (chara->equip[1].GetWHp(NULL) < 0.2f) {
            if (active_chara == 0) {
                needs |= 4;
            }
            if (active_chara == 1) {
                needs |= 8;
            }
        }
    } else if (active_chara == 2) {

        if (((CGameDataUsed *)&((ROBO_DATA *)&manager->robo_data)->parts[0])->GetWHp(NULL) < 0.2f) {
            needs |= 0x8000;
        }
    } else if (active_chara == 3) {
        if (charas[1]->hp.GetRate() < 0.2f) {
            needs |= 1;
        }
    }
    needs |= 0x30;
    if ((party & 2) == 0) {
        needs &= ~0x20;
    }
    if (in_battle != 0) {
        needs &= ~0x6F01;
    }
    return needs | 0x40;
}
void Func_MenuIconDrawPrepare(MENUFORMPARTS_TYPE *part, CGameDataUsed *item, int need_item) {
    int item_no;
    CDataCommon *record;
    unsigned int *item_info;
    unsigned int flags;

    if (part != NULL && item != NULL) {
        part->item_flag = 0;
        item_no = item->item_no;
        if (item_no >= 0x10C) {
            record = (CDataCommon *)GetCommonItemData(item_no);
            if (record != NULL && (record->attribute & 0x20) != 0) {
                item_info = (unsigned int *)GetItemInfoData(item_no);
                if (item_info != NULL) {
                    flags = item_info[1];
                    if ((flags & 0x100) != 0 && (need_item & 0x1) != 0) {
                        part->item_flag |= 1;
                    } else if (((flags & 0x20000) != 0 && (need_item & 0x100) != 0) ||
                               ((flags & 0x80000) != 0 && (need_item & 0x400) != 0) ||
                               ((flags & 0x8000) != 0 && (need_item & 0x800) != 0) ||
                               ((flags & 0x200000) != 0 && (need_item & 0x200) != 0) ||
                               ((flags & 0x4000000) != 0 && (need_item & 0x2000) != 0) ||
                               ((flags & 0x10000000) != 0 && (need_item & 0x4000) != 0)) {
                        part->item_flag |= 1;
                    } else if ((flags & 0x400) != 0 &&
                               ((item_no == 0x126 &&
                                 ((need_item & 0x2) != 0 || (need_item & 0x8000) != 0)) ||
                                (item_no == 0x12A && (need_item & 0x4) != 0) ||
                                (item_no == 0x160 && (need_item & 0x8) != 0) ||
                                (item_no == 0x17D && (need_item & 0x80) != 0))) {
                        part->item_flag |= 1;
                    } else if (item_no == 0x1A7 && (need_item & 0x10000) != 0) {
                        part->item_flag |= 1;
                    } else if (item_no == 0x128 || item_no == 0x184) {
                        part->item_flag |= 1;
                    } else if (item_no == 0x185 && (need_item & 0x20) != 0) {
                        part->item_flag |= 1;
                    }
                }
            }
        }
    }
}
void CheckItemBoardFunc_MenuIconDrawPrepare(CUserDataManager *manager, MENUFORMPARTS_TYPE *parts) {
    int need_item;
    CGameDataUsed *item;
    int count;
    int i;
    int offset;
    MENUFORMPARTS_TYPE *part;

    need_item = NowUseNeedItemCheck(manager);
    item = (CGameDataUsed *)manager->GetUsedDataPtr(0);
    count = GetNowBagMax(1);
    i = 0;
    if (0 < count) {
        offset = 0;
        do {
            part = (MENUFORMPARTS_TYPE *)((u8 *)parts + offset);
            Func_MenuIconDrawPrepare(part, item, need_item);
            if (CheckBuildUp(item, NULL, NULL, NULL) != 0) {
                part->item_flag |= 2;
            }
            i++;
            item = (CGameDataUsed *)((u8 *)item + 0x6C);
            offset += 0x48;
        } while (i < count);
    }
}
void MenuItemBrdScrlBarStep(int line, int height, int mode) {
    int pos =
        CalcScrlBarPutPos(height, 252.0f, line, (float)(MenuItemBrdMaxLine - MenuItemBrdViewLine));

    if (mode == 0) {
        CalcMenu1((float)pos, &MenuItemBrdScrlBarY, 4.0f, 4.0f, 0);
    }
    if (mode == 1) {
        MenuItemBrdScrlBarY = (float)pos;
    }
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menudraw", Func_MenuItemBrdPosStep__Fi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menudraw", GetPosMenuItemBrdKoma__18CMenuPosDataManageFPiii);
void CMenuPosDataManage::GetPosMenuItemOnItemBrd(int *pos, int item_no, int clip) {
    this->GetPosMenuItemBrdKoma(pos, item_no, clip);
    pos[0] += 4;
    pos[1] += 4;
}
void CMenuPosDataManage::GetPosMenuItemBrdForEffect(int *pos, int item_no, int clip) {
    this->GetPosMenuItemOnItemBrd(pos, item_no, clip);
    pos[0] += 0x12;
    pos[1] += 0x15;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menudraw", Func_MenuItemIconSetEffectOne__FP18MENUFORMPARTS_TYPE);
void MenuItemBrdItemIconEffectMalloc(mgCMemory *memory, MENUFORMPARTS_TYPE *parts, int count) {
    int i;
    int offset;
    MENUFORMPARTS_TYPE *part;

    i = 0;
    if (0 < count) {

        offset = 0;
        do {
            part = (MENUFORMPARTS_TYPE *)((u8 *)parts + offset);
            MenuPosDataTypeInit(part);
            part->active = 1;
            Func_MallocPartEffectInfo(part, memory, 8);
            Func_MenuItemIconSetEffectOne(part);
            i++;
            offset += 0x48;
        } while (i < count);
    }
    parts->name = (char *)memory->Alloc(1);
    strcpy(parts->name, at_4522);
    parts->w = 32.0f;
    parts->h = 40.0f;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menudraw", MallocPallet__18CMenuPosDataManageFP9mgCMemory);
void CMenuPosDataManage::SearchTransPalletNo() {
    u8 *colors;
    int i;
    int j;

    for (i = 0; i < 2; i++) {
        if (item_icon_tex[0][i] != NULL) {
            colors = (u8 *)item_icon_tex[0][i]->clut;
            for (j = 0; j < 256; j++) {
                if (colors[3] == 0) {
                    trans_pallet_no[i] = j;
                    break;
                }
                colors += 4;
            }
        }
    }
}
void CMenuPosDataManage::InitializeCMenuPosDataManage() {
    Initialize();
    common_tex = NULL;
    unk_40 = NULL;
    unk_44 = NULL;
    unk_48 = NULL;
    icon_effect_tex = NULL;
    effect_tex = NULL;
    item_icon_tex[0][0] = NULL;
    item_icon_tex[0][1] = NULL;
    item_icon_tex[1][0] = NULL;
    item_icon_tex[1][1] = NULL;
    pallet[2][0] = 0;
    pallet[2][1] = 0;
    item_icon_tex[3][0] = 0;
    item_icon_tex[3][1] = 0;
    memset(unk_74, 0, sizeof(unk_74));
    memset(unk_2cc, 0, sizeof(unk_2cc));
    memset(unk_524, 2, sizeof(unk_524));
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menudraw", MenuCapture__FiP9mgCMemoryi);
void SetBGFrameForMenu(int tex_block, char *name) {
    (&mgTexManager)->ReloadTexture(tex_block, (sceVif1Packet *)NULL);
    mgCTexture frame;
    mgRect<int> src;
    mgRect<int> half;
    mgCDrawPrim *prim;
    mgCTexture *background;

    mgGetFrameBuffer(&frame);
    src.Set(0, 0, mgScreenWidth << 4, mgScreenHeight << 4);
    half.Set(0, 0, mgScreenWidth << 3, mgScreenHeight << 3);
    prim = GetMenuPrim();
    prim->Initialize(NULL, NULL);
    prim->AlphaTestEnable(0);
    prim->ZMask(-1);
    prim->TextureMapEnable(1);
    background = (&mgTexManager)->GetTexture(name, -1);
    background->Bilinear(1);
    mgSetPkMoveImage(&frame, src, background, 0, 0, 0);
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menudraw", MenuFrameImageDraw__FP11mgCDrawPrimP10mgCTexture9mgRect_f_9mgRect_i_iii);
void CRepairEffect::Initialize(void) {
    active = 0;
    particle = NULL;
    unk_1c = NULL;
    tex = NULL;
    particle_num = 0;
}
void CRepairEffect::Generate(mgCMemory *memory, int particle_count) {
    unsigned int size;
    unsigned int blocks;
    int i;
    REPAIR_EFFECT_PARTICLE *p;
    int side;

    alpha = 0x80;
    counter = 0;
    active = 1;
    particle_num = particle_count;
    size = particle_num * sizeof(REPAIR_EFFECT_PARTICLE);
    if ((size & 0xF) != 0) {
        blocks = (size >> 4) + 1;
    } else {
        blocks = (size >> 4);
    }
    particle = (REPAIR_EFFECT_PARTICLE *)operator new[](particle_num * sizeof(REPAIR_EFFECT_PARTICLE),
                                                  (u_long128 *)memory->Alloc(blocks + 2));
    i = 0;
    for (; i < particle_num; i++) {
        p = &particle[i];
        p->active = 1;
        p->unk_0 = 128.0f;
        p->unk_4 = 128.0f;
        p->unk_8 = 64.0f;
        p->alpha = 90.0f + GetRandF(20.0f);
        p->y = (float)y + GetRandF(40.0f) - 22.0f;
        side = GetRandI(34);
        p->x = (float)(x + side);
        p->vx = GetRandF(0.16f);
        if (side < 19) {
            p->vx = -p->vx;
        }
        p->unk_14 = 0;
        p->counter = 0;
    }
}
void CRepairEffect::Step() {
    REPAIR_EFFECT_PARTICLE *p;
    int alive_count;
    int i;

    if ((u8)active != 0) {
        alive_count = 0;
        alpha -= 2;
        if (alpha < 0) {
            alpha = 0;
        }
        for (i = 0; i < particle_num; i++) {
            p = particle + i;
            if (p->active != 0) {
                p->counter++;
                p->x += p->vx;
                p->y += 0.5f;
                p->alpha -= 1.7f;
                if (p->alpha <= 0.0f) {
                    p->active = 0;
                }
                alive_count++;
            }
        }
        if (alive_count == 0) {
            active = 0;
        }
        counter++;
    }
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menudraw", Draw__13CRepairEffectFv);
void CRepairManager::Initialize() {
    int i;

    data_ready = 0;
    tex_block = -1;
    unk_1a4 = 0;
    tex = NULL;
    model = NULL;
    data = NULL;
    for (i = 0; i < 8; i++) {
        effect[i] = NULL;
        effect_stack[i].stSetBuffer(0, 0);
    }
    keep = 0;
}
void CRepairManager::SetStack(mgCMemory *memory, int mode) {
    int i;
    int top;
    int used = memory->stack_used;
    int end = memory->stack_size;
    int base = *(int *)&memory->stack;

    i = 0;
    top = base + (used << 4) + ((end - used) << 4);
    for (; i < 8; i++) {
        if (mode == 0) {
            top -= 0x5000;
            effect_stack[i].stSetBuffer((u_long128 *)(top - 0x5000), 0x500);
        }
        if (mode == 1) {
            top = *(int *)&memory->stack + (memory->stack_used << 4);
            effect_stack[i].stSetBuffer((u_long128 *)top, 0x500);
            memory->Alloc(0x501);
        }
    }
    if (mode == 0) {

        model_stack.stSetBuffer((u_long128 *)((u8 *)top - 0x18000), 0x1800);
    }
}
void CRepairManager::Clear(void) {
    this->Initialize();
}
void CRepairManager::LoadDataBG(mgCMemory *memory) {
    int size;
    unsigned int blocks;

    bg_load = 0;
    if (data_ready == 0 || data == NULL) {
        memory->stack_used = 0;
        memory->lock = 0;
        memory->Align64();
        size = 0;
        data = (unsigned int *)(*(int *)&memory->stack + (memory->stack_used << 4));
        StartReadBG();
        LoadFileBG((char *)at_4877, (u_long128 *)data, &size);
        if (((unsigned int)size & 0xF) != 0) {
            blocks = ((unsigned int)size >> 4) + 1;
        } else {
            blocks = (unsigned int)size >> 4;
        }
        memory->Alloc(blocks);
        SetStack(memory, 0);
        bg_load = 1;
    }
}
void CRepairManager::CheckDataBG(int block) {
    int pack_size;

    if (data_ready == 0) {
        (&mgTexManager)->DeleteBlock(block);
        tex_block = (short)block;
        MenuEnterIMG(block, (u8 *)GetPackFile(data, (char *)&at_4888, &pack_size), (char *)&at_4889);
        tex = (&mgTexManager)->GetTexture(at_4890, -1);
        data_ready = 1;
        bg_load = 0;
    }
}
void CRepairManager::SetRepairData(mgCMemory *memory, int block, unsigned int *pack) {
    int pack_size;

    tex_block = (short)block;
    data = pack;
    MenuEnterIMG(block, (u8 *)GetPackFile(pack, (char *)&at_4888, &pack_size), (char *)&at_4889);
    tex = (&mgTexManager)->GetTexture(at_4890, -1);
    data_ready = 1;
    bg_load = 0;
    SetStack(memory, 1);
    keep = 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menudraw", GeneratePoly__14CRepairManagerFPfi);
void CRepairManager::Generate(int x, int y) {
    int i;
    int slot;
    CRepairEffect *effect;
    mgCMemory *memory;
    u8 *entry;

    slot = -1;
    for (i = 0; i < 8; i++) {
        if (this->effect[i] == NULL) {
            slot = i;
            break;
        }
    }
    if (0 <= slot) {
        entry = (u8 *)(slot * 0x30) + (int)this;

        memory = (mgCMemory *)(entry + 0x24);
        memory->stack_used = 0;
        memory->lock = 0;
        this->effect[slot] = (CRepairEffect *)operator new(0x24, (u_long128 *)memory->Alloc(5));
        if ((effect = this->effect[slot]) != NULL) {
            effect->Initialize();
            effect->x = x;
            effect->y = y;
            effect->unk_1c = unk_1a4;
            effect->tex = tex;
            effect->Generate(memory, 0x20);
        }
    }
}
int CRepairManager::IsRunModel(void) {
    return model != NULL;
}
int CRepairManager::IsRun(void) {
    int i;
    int running;

    running = 0;
    for (i = 0; i < 8; i++) {
        if (effect[i] != NULL) {
            running = 1;
        }
    }
    if (this->IsRunModel() != 0) {
        running = 1;
    }
    return running;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menudraw", Step__14CRepairManagerFv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menudraw", Draw__14CRepairManagerFv);
void CLevelUpEffect::Initialize(void) {
    active = 0;
    chara = NULL;
    tex = NULL;
}
void CLevelUpEffect::Generate(mgCTexture *spark_texture, int param, int x, int y) {
    tex = spark_texture;
    kind = param;
    pos[0] = (float)(x - 0x10);
    pos[1] = (float)y;
    counter = 0;
    chara = NULL;
    active = 1;
}
void CLevelUpEffect::Generate(mgCTexture *spark_texture, int param, CCharacter2 *target) {
    int i;

    active = 1;
    kind = param;
    chara = target;
    tex = spark_texture;
    ((CCharacter2 *)chara)->GetPosition(pos);
    for (i = 0; i < 0x20; i++) {
        l_levelup_pos[i][0] = (pos[0] + GetRandF(14.0f)) - 7.0f;
        l_levelup_pos[i][1] = (pos[1] - 3.0f) + GetRandF(3.0f);
        l_levelup_pos[i][2] = (pos[2] + GetRandF(14.0f)) - 7.0f;
        l_levelup_vec[i][0] = GetRandF(0.3f) - 0.15f;
        l_levelup_vec[i][1] = GetRandF(0.5f);
        l_levelup_vec[i][2] = GetRandF(0.3f) - 0.15f;
        l_levelup_counter[i] = GetRandI(0x15);
        l_levelup_generate_counter[i] = GetRandI(3) + 2;
    }
}
int CLevelUpEffect::IsRun(void) {
    return active;
}
void CLevelUpEffect::Step() {
    int i;
    float *spark_pos;
    float *spark_vec;
    int offset;
    signed char *counter;
    signed char *generate_counter;
    int alive;

    if ((u8)active != 0) {
        if (chara != NULL) {
            alive = 0;
            i = 0;
            offset = 0;
            do {
                generate_counter = l_levelup_generate_counter + i;
                if (*generate_counter > 0) {

                    spark_pos = (float *)((u8 *)l_levelup_pos + offset);
                    spark_vec = (float *)((u8 *)l_levelup_vec + offset);
                    counter = l_levelup_counter + i;
                    spark_pos[0] += spark_vec[0];
                    spark_pos[1] += spark_vec[1];
                    spark_pos[2] += spark_vec[2];
                    (*counter)--;
                    if (*counter < 0) {
                        spark_pos[0] = pos[0] + GetRandF(14.0f) - 7.0f;
                        spark_pos[1] = pos[1] - 3.0f + GetRandF(3.0f);
                        spark_pos[2] = pos[2] + GetRandF(14.0f) - 7.0f;
                        spark_vec[0] = GetRandF(0.3f) - 0.15f;
                        spark_vec[1] = GetRandF(0.4f);
                        spark_vec[2] = GetRandF(0.3f) - 0.15f;
                        *counter = GetRandI(6) + 16;
                        (*generate_counter)--;
                    }
                    alive++;
                }
                i++;
                offset += 12;
            } while (i < 32);
            if (alive <= 0) {
                active = 0;
                chara = NULL;
            }
        } else {
            this->counter = this->counter + 1;
            if (this->counter > 30) {
                active = 0;
            }
        }
    }
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menudraw", Draw__14CLevelUpEffectFv);
void CLevelUpEffectManager::Initialize() {
    int i;

    for (i = 0; i < 8; i++) {
        effect[i].Initialize();
    }
    label_tex = NULL;
}
int CLevelUpEffectManager::IsRun() {
    int i;

    for (i = 0; i < 8; i++) {
        if (effect[i].IsRun() != 0) {
            return 1;
        }
    }
    return 0;
}
void CLevelUpEffectManager::Generate(int param, int x, int y) {
    int i;

    for (i = 0; i < 8; i++) {
        if (effect[i].IsRun() == 0) {
            effect[i].Generate(label_tex, param, x, y);
            break;
        }
    }
}
void CLevelUpEffectManager::Generate(int param, CCharacter2 *chara) {
    int i;

    for (i = 0; i < 8; i++) {
        if (effect[i].IsRun() == 0) {
            effect[i].Generate(spark_tex, param, chara);
            break;
        }
    }
}
void CLevelUpEffectManager::Step() {
    int i;

    for (i = 0; i < 8; i++) {
        effect[i].Step();
    }
}
void CLevelUpEffectManager::Draw() {
    int i;

    for (i = 0; i < 8; i++) {
        effect[i].Draw();
    }
}
void CStarDust::Generate(int pos_x, int pos_y, int life_base, int life_range) {
    x = (float)pos_x;
    y = (float)pos_y;
    life = life_base + GetRandI(life_range);
    active = 1;
}
void CStarDust::Step() {
    if (active != 0) {
        life -= 1;
        if (life < 0) {
            active = 0;
        }
    }
}
void CStarDust::Draw(mgCTexture *texture, int u, int v) {
    short remaining;
    int alpha;
    mgCDrawPrim *prim;

    if ((active != 0) && (texture != NULL)) {
        remaining = (short)(life);
        alpha = 0x80;
        if (remaining < 8) {
            alpha = remaining * 0x10;
        }
        prim = GetMenuPrim();
        SetSpriteEnv(prim, 4);
        prim->Begin(6);
        prim->Texture(texture);
        prim->Color(0x80, 0x80, 0x80, alpha);
        prim->TextureCrd(u, v);
        prim->Vertex(x, y, 0.0f);
        prim->TextureCrd(u + 8, v + 8);
        prim->Vertex(8.0f + x, 8.0f + y, 0.0f);
        prim->End();
    }
}
CStarDust *CheckNotRunStarDust(CStarDust *dusts, int count) {
    int i;
    if (dusts == NULL || count <= 0) {
        return NULL;
    }
    i = 0;
    if (0 < count) {
        do {
            if ((u8)dusts[i].active == 0) {
                return dusts + i;
            }
            i++;
        } while (i < count);
    }
    return NULL;
}
int CheckRunStarDust(CStarDust *dusts, int count) {
    int i;
    if (dusts == NULL || count <= 0) {
        return 0;
    }
    i = 0;
    if (0 < count) {
        do {
            if ((u8)dusts[i].active != 0) {
                return 1;
            }
            i++;
        } while (i < count);
    }
    return 0;
}
void CEffVerticalLine::Generate(float *center, float range, float height) {
    CEffVerticalLine *line = this;
    float half_range;

    line->speed = 0.005f + GetRandF(0.1f);
    half_range = range / 2.0f;
    line->pos[0] = (center[0] + GetRandF(1.9f * range)) - 1.9f * half_range;
    line->pos[1] = center[1] - 0.76f * range;
    line->pos[2] = (center[2] + GetRandF(1.7f * range)) - 1.7f * half_range;
    line->pos[3] = center[3];
    line->w = 1.0f + GetRandF(0.4f);
    line->h = 0.7f + GetRandF(0.5f);
    line->r = GetRandF(26.0f);
    line->g = 72.0f + GetRandF(26.0f);
    line->b = 96.0f + GetRandF(26.0f);
    line->alpha = 138.0f + GetRandF(32.0f);
    line->angle = GetRandF(0.029637668f);
    line->angle_add = 0.059275337f;
}
void CEffVerticalLine::Step() {
    CEffVerticalLine *line = this;
    line->pos[1] += line->speed;
    line->h += 1.5f * line->speed;
    if (line->speed < 0.26f) {
        line->speed += 0.005f;
    } else {
        line->speed += 0.009f;
    }
    float phase = line->angle_add;
    phase = line->angle + phase;
    line->angle = phase;
    if (3.1415927f <= phase) {
        line->angle = 3.1415927f;
    }
}
extern "C" void Draw__16CEffVerticalLineFv(CEffVerticalLine *line) {
    int screen_a[4];
    int screen_b[4];

    mgCDrawPrim prim;
    float alpha;

    SetSpriteEnv(&prim, 4);
    prim.Coord(1);
    prim.DepthTestEnable(1);
    prim.Begin(6);
    prim.Texture(MenuVerticalLineTex);
    if (mgTransWorldPrim3DSprite(screen_a, screen_b, &line->pos[0], line->w, line->h, 0) != 0) {
        alpha = line->alpha * sinf(line->angle);
        if (alpha <= 0.0f) {
            alpha = 0.0f;
        }
        prim.Color(fptosi(line->r), fptosi(line->g), fptosi(line->b),
                                fptosi(alpha));
        prim.TextureCrd(0, 0x62);
        prim.Vertex4(screen_a);
        prim.TextureCrd(0xA, 0x80);
        prim.Vertex4(screen_b);
    }
    if (mgTransWorldPrim3DSprite(screen_a, screen_b, &line->pos[0], 3.6f * line->w, 1.5f * line->h,
                                 0) != 0) {
        alpha = line->alpha * sinf(line->angle);
        if (alpha <= 0.0f) {
            alpha = 0.0f;
        }
        alpha *= 0.2f;
        prim.Color(fptosi(line->r), fptosi(line->g), fptosi(line->b),
                                fptosi(alpha));
        prim.TextureCrd(0, 0x62);
        prim.Vertex4(screen_a);
        prim.TextureCrd(0xA, 0x80);
        prim.Vertex4(screen_b);
    }
    prim.End();
}
void InitInitBuildUpInfoEffectPos() {
    int i;
    int offset = 0;

    for (i = 0; i < MenuVerticalLineNum; i++, offset += sizeof(CEffVerticalLine)) {
        CEffVerticalLine *lines = MenuVerticalLine;
        ((CEffVerticalLine *)((u8 *)lines + offset))
            ->Generate(MenuVerticalLineCharaPos, MenuVerticalRange, 20.0f);
        ((CEffVerticalLine *)((u8 *)MenuVerticalLine + offset))->pos[1] =
            MenuVerticalLineCharaPos[1] + GetRandF(8.0f);
        ((CEffVerticalLine *)((u8 *)MenuVerticalLine + offset))->angle = GetRandF(3.1415927f);
    }
}
void InitBuildUpInfoEffect(mgCMemory *memory, mgCTexture *texture, int num, float up_limit) {
    unsigned int size;
    unsigned int blocks;

    MenuVerticalLineTex = texture;
    MenuVerticalLineUpLimmit = up_limit;
    MenuVerticalLine = NULL;
    MenuVerticalLineNum = num;
    MenuVerticalLineChara = 0;
    if (memory != NULL) {
        size = num << 6;
        blocks = (size & 0xF) != 0 ? (size >> 4) + 1 : size >> 4;
        MenuVerticalLine =
            (CEffVerticalLine *)operator new[](size, (u_long128 *)memory->Alloc(blocks + 2));
        InitInitBuildUpInfoEffectPos();
    }
}
void SetBuildUpInfoChara(CCharacter2 *chara, float range) {
    int same;

    same = 1;
    if (MenuVerticalLineChara != (int)chara) {
        same = 0;
    }
    MenuVerticalRange = range;
    MenuVerticalLineChara = (int)chara;
    if (chara != NULL) {
        chara->GetPosition(MenuVerticalLineCharaPos);
        MenuVerticalLineCharaPos2[1] = MenuVerticalLineCharaPos[1] - 3.0f;
        if (same != 0) {
            InitInitBuildUpInfoEffectPos();
        }
    }
}
void StepBuildUpInfoEffect() {
    int i;
    int offset;
    CEffVerticalLine *line;

    if (MenuVerticalLine != NULL) {
        for (i = 0, offset = 0; i < MenuVerticalLineNum; offset += sizeof(CEffVerticalLine), i++) {
            ((CEffVerticalLine *)((u8 *)MenuVerticalLine + offset))->Step();
            line = (CEffVerticalLine *)((u8 *)MenuVerticalLine + offset);
            if (3.1415927f <= line->angle || 19.0f <= line->pos[1]) {
                ((CEffVerticalLine *)((u8 *)MenuVerticalLine + offset))
                    ->Generate(MenuVerticalLineCharaPos, MenuVerticalRange, 20.0f);
            }
        }
    }
}
void DrawBuildUpInfoEffect() {
    int i;
    int offset;

    if (MenuVerticalLineChara == 0 || MenuVerticalLine == NULL) {
        return;
    }
    if (MenuVerticalLineTex != NULL) {
        ReloadTexture__17mgCTextureManagerFiP13sceVif1Packet(&mgTexManager, MenuVerticalLineTex->block,
                                                             NULL);
        for (i = 0, offset = 0; i < MenuVerticalLineNum; offset += sizeof(CEffVerticalLine), i++) {
            Draw__16CEffVerticalLineFv((CEffVerticalLine *)((u8 *)MenuVerticalLine + offset));
        }
    }
}
void InitFishBoiledEffect(int *position, mgCTexture *texture) {
    int i;

    fish_boiled_effect_tex = (int)texture;
    fish_boiled_runflag = 0;
    if (position != NULL) {
        for (i = 0; i < 8; i++) {
            fish_boiled_positin[i][0] = (24.0f + (float)position[0]) - GetRandF(32.0f);
            fish_boiled_positin[i][1] = (24.0f + (float)position[1] + GetRandF(12.0f)) - 6.0f;
            fish_boiled_alpha[i] = 132.0f - GetRandF(24.0f);
            fish_boiled_streatch_rate[i] = 0.4f + GetRandF(0.4f);
        }
        fish_boiled_runflag = 1;
    }
    fish_boiled_count = 0;
}
int StepFishBoiledEffect() {
    int finished;
    int i;

    finished = 0;
    if (fish_boiled_runflag == 0) {
        return 0;
    }
    for (i = 0; i < 8; i++) {
        fish_boiled_positin[i][1] -= 0.5f;
        fish_boiled_amp_count[i] = mgAngleLimit(0.052359879f + fish_boiled_amp_count[i]);
        if (CalcMenuAdd(&(&fish_boiled_alpha)[0][i], -2.0f, 0.0f) != 0) {
            finished++;
        }
    }
    if (finished >= 8) {
        fish_boiled_runflag = 0;
        fish_boiled_effect_tex = 0;
        return 0;
    }
    return 1;
}
void DrawFishBoiledEffect() {
    mgCDrawPrim *prim;
    int i;
    float size;
    float x;

    if (fish_boiled_runflag == 0) {
        return;
    }
    if (fish_boiled_effect_tex == 0) {
        return;
    }
    prim = (mgCDrawPrim *)GetMenuPrim();
    SetSpriteEnv(prim, 4);
    prim->Begin(6);
    prim->Texture((mgCTexture *)fish_boiled_effect_tex);
    for (i = 0; i < 8; i++) {
        size = 32.0f * fish_boiled_streatch_rate[i];
        x = fish_boiled_positin[i][0] + 2.0f * sinf(fish_boiled_amp_count[i]);
        prim->Color(0x80, 0x80, 0x80, (int)fish_boiled_alpha[i]);
        prim->TextureCrd(0x20, 0);
        prim->Vertex(x, fish_boiled_positin[i][1], 0.0f);
        prim->TextureCrd(0x40, 0x20);
        prim->Vertex(x + size, size + fish_boiled_positin[i][1], 0.0f);
    }
    prim->End();
}
void SetEffectSpectolBreak(mgCMemory *memory, CMenuEffect *effect, int item_no) {
    memory->stack_used = 0;
    memory->lock = 0;
    menu_effect_preset params = at_5441;
    mgRect<int> rect;

    rect.Set(0, 0, 0, 0);
    GetMenuItemIconTexGetXY(item_no, rect);
    mgCTexture *icon_texture = GetMenuItemIconTexInfo(item_no, 0);
    params.v[2] = rect.left;
    params.v[3] = rect.top;
    params.v[4] = use_trans_rect;
    effect->PresetEffect(memory, icon_texture, 0x13, params.v);
    effect->EffectStart();
    MenuSePlay(-1);
}
void SetEffectSpectolFusion(mgCMemory *memory, CMenuEffect **effects, CGameDataUsed *item,
                            int is_fusion) {
    menu_effect_preset params = at_5450;
    mgCTexture *icon_texture;

    trans_spectol_pos = GetSameAdrressUserData(item, 0);
    trans_spectol_cnt = 0;
    if (is_fusion != 0) {
        params.v[4] = 1;
    }
    if (trans_spectol_pos >= 0) {
        itemmenu_chr_rotflag = 0;
    }
    memory->stack_used = 0;
    memory->lock = 0;
    effects[0]->PresetEffect(memory, MenuPosData->effect_tex, 10,
                             params.v);
    icon_texture = GetMenuItemIconTexInfo(item->item_no, 0);
    params.v[2] = item->item_no;
    effects[1]->PresetEffect(memory, icon_texture, 0x15, params.v);
    effects[0]->EffectStart();
    effects[1]->EffectStart();
}
void CMenuEffect::Initialize(void) {
    tex_block = 0;
    tex = NULL;
    type = -1;
    run = 0;
    info_num = 0;
    info = NULL;
    alpha = 128;
}
void CMenuEffect::PresetEffect(mgCMemory *memory, mgCTexture *texture, int kind, int *base) {
    int *info;

    info = MenuCommonInfo->tex_block;
    type = kind;
    switch (kind) {
        case 10:
            SetTexInfo(texture, info);
            info_num = 0x60;
            SetMemory(memory);
            SetBaseInfo(base, 1, 1, 4);
            break;
        case 0:
            SetTexInfo(texture, info);
            info_num = 0x80;
            SetMemory(memory);
            SetBaseInfo(base, 1, 1, 4);
            break;
        case 4:
            SetTexInfo(texture, info);
            info_num = 1;
            SetMemory(memory);
            SetBaseInfo(base, 1, 1, 4);
            break;
        case 19:
            SetTexInfo(texture, info);
            info_num = 0x70;
            SetMemory(memory);
            SetBaseInfo(base, 1, 1, 7);
            break;
        case 21:
            SetTexInfo(texture, info);
            info_num = 1;
            SetMemory(memory);
            SetBaseInfo(base, 1, 1, 4);
            break;
    }
}
void CMenuEffect::SetMemory(mgCMemory *memory) {
    unsigned int bytes;
    unsigned int blocks;

    bytes = (unsigned int)(info_num << 6);
    if (bytes & 0xF) {
        blocks = (bytes >> 4) + 1;
    } else {
        blocks = bytes >> 4;
    }
    info = (MENU_EFFECT_INFO *)memory->Alloc(blocks);
}
void CMenuEffect::SetTexInfo(mgCTexture *texture, int *params) {
    tex = texture;
    if (params != NULL) {
        tex_block = *(short *)params;
    }
}
void CMenuEffect::SetBaseInfo(int *values, int preset, int kind, int count) {
    int i;

    for (i = 0; i < count; i++) {
        base_info[i] = values[i];
    }
    if (preset != 0) {
        PresetInfoAll(kind);
    }
}
void CMenuEffect::EffectStart(void) {
    run = 1;
    counter = 0;
}
void CMenuEffect::PresetInfoAll(int kind) {
    int i;
    int offset;

    offset = 0;
    for (i = 0; i < info_num; i++) {
        PresetInfo((MENU_EFFECT_INFO *)((u8 *)info + offset), i, kind);
        offset += 0x40;
    }
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menudraw", PresetInfo__11CMenuEffectFP16MENU_EFFECT_INFOii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menudraw", Step__11CMenuEffectFv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menudraw", Draw__11CMenuEffectFv);
extern "C" void PrimQuad_f___FP11mgCDrawPrim9mgRect_f_9mgRect_i_(mgCDrawPrim *prim, mgRect<float> rect,
                                                                 mgRect<int> texRect) {
    if (prim != NULL) {
        prim->TextureCrd(texRect.left, texRect.top);
        prim->Vertex(rect.left, rect.top, 0.0f);
        prim->TextureCrd(texRect.left + texRect.right, texRect.top + texRect.bottom);
        prim->Vertex(rect.left + rect.right, rect.top + rect.bottom, 0.0f);
    }
}
void PrimQuad_i_(mgCDrawPrim *prim, mgRect<int> rect, mgRect<int> texRect) {
    if (prim != NULL) {
        prim->TextureCrd(texRect.left, texRect.top);
        prim->Vertex(rect.left, rect.top, 0);
        prim->TextureCrd(texRect.left + texRect.right, texRect.top + texRect.bottom);
        prim->Vertex(rect.left + rect.right, rect.top + rect.bottom, 0);
    }
}

// Static initialiser (.init)
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menudraw", __sinit_menudraw_cpp);

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", spectol_break_pos__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", spectol_break_angle__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", item_transtbl__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", paint_color_table_1234__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", spectol_y_addtbl_1245__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", MenuWindowHelpTable_1346__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", table_1650__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", tbl_1689__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", get_onoffbrdtbl_1789__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", at_1790__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", at_1791__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", at_1796__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", at_1803__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", at_1814__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", at_1999__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", tbl_2072__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", at_2265__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", star_color_table__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", frmtbl0_2922__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", frmtbl1_2938__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", at_2949__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", at_2950__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", at_2951__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", rottbl_3145__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", baseposoffset_tbl_4194__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", actposoffsettbl1_4195__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", at_4494__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", at_4495__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", l_levelup_color__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", at_5441__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", at_5450__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", at_5901__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", at_873__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", at_975__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", at_1622__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", at_1690__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", at_1691__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", at_1692__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", at_1693__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", at_1694__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", at_1695__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", at_1696__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", at_1697__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", at_1698__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", at_1699__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", at_1700__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", at_1711__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", at_1780__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", at_2209__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", at_2237__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", at_2238__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", at_3054__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", at_3721__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", at_3927__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", at_4182__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", at_4183__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", at_4184__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", at_4185__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", at_4186__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", at_4453__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", at_4522__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", at_4877__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", at_4888__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", at_4889__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", at_4890__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", at_4933__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", at_4934__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", at_4935__DATA);

// Static initialiser table (.ctor)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", D_0037B02C__DATA);

// Small initialised data (.sdata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", rgbatbl_1379__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", at_1788__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", get_btntbl_1810__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", at_1998__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", MenuWakuPutXY__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", static_rgba_table_3128__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", menu_prim_tbl__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", at_3658__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", basepos_4190__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", farleft_4191__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", xyoffset_4192__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", actpos_4193__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menudraw", at_4442__2__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(use_trans_rect, 0x4);
INCLUDE_BSS(item_board_counter, 0x4);
INCLUDE_BSS(MenuDrawItemInfoNum, 0x4);
INCLUDE_BSS(use_item_enable_alpha_angle, 0x4);
INCLUDE_BSS(use_item_enable_alpha, 0x4);
INCLUDE_BSS(spectol_raster_xtbl, 0x4);
INCLUDE_BSS(DrawItemCounter, 0x4);
INCLUDE_BSS(DrawItemDefCounter, 0x4);
INCLUDE_BSS(NowGiftBoxPtr, 0x4);
INCLUDE_BSS(GiftBoxViewForm, 0x4);
INCLUDE_BSS(NowGiftBoxSelect, 0x4);
INCLUDE_BSS(GiftBoxViewFlag, 0x4);
INCLUDE_BSS(curpos_1393, 0x4);
INCLUDE_BSS(init_1394, 0x4);
INCLUDE_BSS(at_1400__2, 0x8);
INCLUDE_BSS(MenuDrawNumberKeta, 0x8);
INCLUDE_BSS(at_1521__2, 0x8);
INCLUDE_BSS(menu_randam_line_draw_postbl, 0x4);
INCLUDE_BSS(Tex_MenuDl, 0x4);
INCLUDE_BSS(MenuDl_TotalSize, 0x4);
INCLUDE_BSS(MenuDl_ProcessSize, 0x4);
INCLUDE_BSS(Tex_CommonBoard, 0x4);
INCLUDE_BSS(make_object_husoku_number_blink, 0x4);
INCLUDE_BSS(MenuCursorReverseFlag, 0x4);
INCLUDE_BSS(menu_cursor_rotation_angle, 0x4);
INCLUDE_BSS(MenuMainFrame_ActionEndFlag, 0x4);
INCLUDE_BSS(MenuMainFrame_Display_Mode, 0x4);
INCLUDE_BSS(MenuMainFrame_Display_Mode_Cnt, 0x4);
INCLUDE_BSS(MenuMainFrame_Display_Mode_Cnt_Rate, 0x4);
INCLUDE_BSS(MenuMainFrame_Lenze_Pos, 0x8);
INCLUDE_BSS(MenuMainFrame_MoveRate, 0x8);
INCLUDE_BSS(MenuMainFrame_MoveRate_Cnt, 0x8);
INCLUDE_BSS(MenuMainFrame_LeftTop_Pos, 0x8);
INCLUDE_BSS(MainFrameStepFlag_2092, 0x4);
INCLUDE_BSS(init_2093, 0x4);
INCLUDE_BSS(MenuWakuRotCnt, 0x8);
INCLUDE_BSS(at_2596__2, 0x8);
INCLUDE_BSS(MenuItemBrdCalcManner, 0x4);
INCLUDE_BSS(MenuItemBrdMaxLine, 0x4);
INCLUDE_BSS(MenuItemBrdViewLine, 0x4);
INCLUDE_BSS(MenuItemBrdScrlCurLen, 0x4);
INCLUDE_BSS(MenuItemBrdUnderBrdPosY_Next, 0x8);
INCLUDE_BSS(MenuItemBrdUnderBrdPosXY, 0x8);
INCLUDE_BSS(MenuItemBrdScrlBarY, 0x4);
INCLUDE_BSS(localrgba_3166, 0x4);
INCLUDE_BSS(at_3325, 0x8);
INCLUDE_BSS(at_3428, 0x8);
INCLUDE_BSS(at_3527, 0x8);
INCLUDE_BSS(at_3531, 0x8);
INCLUDE_BSS(at_3612, 0x8);
INCLUDE_BSS(at_3651, 0x8);
INCLUDE_BSS(MenuPosData, 0x8);
INCLUDE_BSS(at_4205, 0x8);
INCLUDE_BSS(at_4526, 0x8);
INCLUDE_BSS(MenuFrameTex, 0x4);
INCLUDE_BSS(at_4727, 0x4);
INCLUDE_BSS(at_4728, 0x4);
INCLUDE_BSS(at_4729, 0x4);
INCLUDE_BSS(at_4730, 0x4);
INCLUDE_BSS(MenuVerticalLineTex, 0x4);
INCLUDE_BSS(MenuVerticalLine, 0x4);
INCLUDE_BSS(MenuVerticalLineNum, 0x4);
INCLUDE_BSS(MenuVerticalLineUpLimmit, 0x4);
INCLUDE_BSS(MenuVerticalLineChara, 0x4);
INCLUDE_BSS(MenuVerticalRange, 0x4);
INCLUDE_BSS(fish_boiled_count, 0x4);
INCLUDE_BSS(fish_boiled_runflag, 0x4);
INCLUDE_BSS(fish_boiled_effect_tex, 0x4);
INCLUDE_BSS(at_5917, 0x4);

// Uninitialised data (.bss)
INCLUDE_BSS(menu_limmit_displayflag, 0xA0);
INCLUDE_BSS(MenuMesForm, 0x30);
INCLUDE_BSS(at_900__4, 0x10);
INCLUDE_BSS(MenuDrawItemInfo, 0x260);
INCLUDE_BSS(GiftBoxWindowPutPos, 0x10);
INCLUDE_BSS(Pos_ItemInGiftBox, 0x10);
INCLUDE_BSS(MakeBoardDrawInfo, 0x20);
INCLUDE_BSS(CommonBoardDrawInfo, 0x30);
INCLUDE_BSS(at_1720, 0x10);
INCLUDE_BSS(menu_long_hand, 0x10);
INCLUDE_BSS(MenuMainFrame_PutRect, 0x10);
INCLUDE_BSS(MenuMainIMG_PutRect, 0x10);
INCLUDE_BSS(at_2292, 0x10);
INCLUDE_BSS(at_2303, 0x10);
INCLUDE_BSS(at_2395__4, 0x20);
INCLUDE_BSS(star_light, 0x10);
INCLUDE_BSS(MenuItemBrdKomaRect, 0x10);
INCLUDE_BSS(ItemBoardScrlBar1, 0x10);
INCLUDE_BSS(ItemBoardScrlBar2, 0x10);
INCLUDE_BSS(ItemBoardScrlBar3, 0x10);
INCLUDE_BSS(ItemBoardCursor, 0x10);
INCLUDE_BSS(at_2919, 0x30);
INCLUDE_BSS(at_3384, 0x20);
INCLUDE_BSS(putpostbl_3410, 0x20);
INCLUDE_BSS(getpostbl_3411, 0x20);
INCLUDE_BSS(temp_3925, 0x20);
INCLUDE_BSS(at_4496, 0x20);
INCLUDE_BSS(l_levelup_pos, 0x180);
INCLUDE_BSS(l_levelup_vec, 0x180);
INCLUDE_BSS(l_levelup_counter, 0x20);
INCLUDE_BSS(l_levelup_generate_counter, 0x20);
INCLUDE_BSS(MenuVerticalLineCharaPos, 0x10);
INCLUDE_BSS(MenuVerticalLineCharaPos2, 0x10);
INCLUDE_BSS(fish_boiled_positin, 0x40);
INCLUDE_BSS(fish_boiled_amp_count, 0x20);
INCLUDE_BSS(fish_boiled_streatch_rate, 0x20);
INCLUDE_BSS(fish_boiled_alpha, 0x20);
