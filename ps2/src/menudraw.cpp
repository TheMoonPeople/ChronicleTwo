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
#include "menuaqua.hpp"
#include "editmenu.hpp"
#include "menushop.hpp"
#include "menuop.hpp"
#include "effscript.hpp"
#include "dng_main.hpp"
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

struct quad_uv {
    float corner[4][2];
};

struct cursor_hand {
    float corner[3][2];
};

struct cursor_width {
    float width[2];
};

struct icon_move_pos {
    int pos[2];
};

struct cursor_put_pos {
    float pos[2];
};

struct menu_put_pos {
    int pos[2];
};

struct menu_board_pos {
    float pos[2];
};

struct menu_tile_color {
    u8 rgba[4];
};

struct effect_color {
    int r;
    int g;
    int b;
    int a;
} __attribute__((aligned(16)));

struct item_color {
    u8 rgba[4];
};

struct board_frame_parts {
    mgRect<int> *rect[12];
} __attribute__((aligned(16)));

struct scroll_bar_heights {
    int height[3];
};

struct scroll_bar_layers {
    int layer[2][5];
};

struct scroll_bar_parts {
    mgRect<int> *rect[3];
};

struct board_number_uv {
    u8 uv[2][4];
};

struct board_line_uv {
    s8 uv[6][3][4];
};

struct board_row_height {
    int height[5];
};

struct board_pass_color {
    int rgba[2][4];
};

struct board_blink_color {
    int rgba[4];
};

struct board_button_color {
    int rgba[2][2][4];
};

struct menu_cursor_pos {
    float pos[2];
};

struct menu_line_origin {
    int pos[2];
};

struct menu_memo_pos {
    float pos[2];
};

struct waku_edge_pos {
    int pos[2][2];
} __attribute__((aligned(16)));

struct board_line_width {
    int width[4];
} __attribute__((aligned(16)));

extern signed char MenuDrawNumberKeta;

extern u8 MenuMainFrame_ActionEndFlag;

extern "C" char at_873__4[];

extern "C" int GetTimeBand__Ff(float time);

extern "C" int GetItemIconNo__Fi(int itemNo);

extern icon_texture_info at_900__4;

extern quad_uv at_2395__4;

extern cursor_hand at_1999__2;

extern cursor_width at_1998__2;

extern icon_move_pos at_4205;

extern cursor_put_pos at_1400__2;

extern texture_pair at_4526;

extern board_line_width at_1720;

extern "C" char at_1780[];

extern "C" char at_3054[];

extern mgCTexture *Tex_CommonBoard;

extern MENUFORM_MAKEBRD_INFO CommonBoardDrawInfo;

extern short use_trans_rect;

extern "C" int __ct__11mgCDrawPrimFv(void *);

extern "C" void PrimQuad_i___FP11mgCDrawPrim9mgRect_i_9mgRect_i_(mgCDrawPrim *, mgRect<int>,
                                                                 mgRect<int>);

extern "C" int GetMenuPrim__Fv(void);

extern "C" void Direct__11mgCDrawPrimFUlUl(void *prim, u64 reg, u64 value);

extern float use_item_enable_alpha_angle;

extern int use_item_enable_alpha;

extern float *spectol_raster_xtbl;

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

extern short basepos_4190[2];

extern short farleft_4191[2];

extern short xyoffset_4192[2];

extern short actpos_4193[2];

extern short baseposoffset_tbl_4194[23][2];

extern short actposoffsettbl1_4195[3][18][2];

extern mgRect<short> table_1650[3][3];

extern u8 rgbatbl_1379[4];

extern float curpos_1393;

extern signed char init_1394;

extern int star_color_table[9];

extern "C" void *__ct__9CMenuFontFv(void *font);

extern "C" void SetStr__5CFontFPc(void *font, char *text);
extern "C" void SetPos__5CFontFii(void *font, int x, int y);

extern "C" void DrawDirect__5CFontFPcii(void *font, char *text, int x, int y);

extern "C" void CalcDrawWH__5CFontFPcPiPi(void *font, char *text, int *width, int *height);

extern "C" void ConvertFontCode__FPcPc(char *source, char *converted);

extern "C" char at_1711[];

extern char *tbl_1689[][2];

extern float MenuMainFrame_LeftTop_Pos[2];

extern signed char MainFrameStepFlag_2092;

extern signed char init_2093;

extern u8 static_rgba_table_3128[4];

extern menu_put_pos at_3612;

extern menu_board_pos at_3651;

extern menu_tile_color at_3658;

extern "C" char at_3721[];

extern effect_color at_5901;

extern item_color at_5917;

extern s16 spectol_break_pos[16][3][2];

extern float spectol_break_angle[16][6];

extern board_frame_parts at_2919;

extern scroll_bar_heights at_2949__2;

extern scroll_bar_layers at_2950__2;

extern scroll_bar_parts at_2951__2;

extern s16 frmtbl0_2922[16];

extern s16 frmtbl1_2938[10];

extern mgRect<short> item_transtbl[2];

extern int paint_color_table_1234[9][4];

extern s8 spectol_y_addtbl_1245[40];

extern float make_object_husoku_number_blink;

extern board_number_uv at_1788__3;

extern board_line_uv at_1790__2;

extern board_row_height at_1791;

extern board_pass_color at_1796;

extern board_blink_color at_1803__2;

extern board_button_color at_1814;

extern s16 get_onoffbrdtbl_1789[2][3][4];

extern u8 get_btntbl_1810[2][2];

extern float menu_cursor_rotation_angle;

extern menu_cursor_pos at_3428;

extern menu_line_origin at_3527;

extern menu_memo_pos at_3531;

extern float putpostbl_3410[8];

extern int getpostbl_3411[8];

extern u8 menu_prim_tbl[2][2];

static void MenuFrameImageDraw(mgCDrawPrim *prim, mgCTexture *tex, mgRect<float> rect, mgRect<int> tex_rect, int gray,
                               int alpha, int dtype);

extern u8 localrgba_3166[4];

extern float item_board_counter;

extern float rottbl_3145[];

extern short MenuMainFrame_Display_Mode;

extern float tbl_2072[];

extern float MenuMainFrame_Display_Mode_Cnt;

extern float MenuMainFrame_Display_Mode_Cnt_Rate;

extern float MenuMainFrame_Lenze_Pos[2];

extern float MenuMainFrame_MoveRate[2];

extern float MenuMainFrame_MoveRate_Cnt;

extern float MenuWakuPutXY[2];

extern float MenuWakuRotCnt;

void SetPartEffectInfoRandFunc(MENU_PARTS_EFFECT_STRUCT1 *effect);

void SetPartEffectInfoRandFunc(MENU_PARTS_EFFECT_STRUCT1 *effect, short *values, int count);

extern "C" char at_2237[];

extern "C" char at_2238[];

extern mgRect<int> MenuMainFrame_PutRect;

extern mgRect<int> MenuMainIMG_PutRect;

extern mgRect<int> star_light;

extern mgRect<int> MenuItemBrdKomaRect;

extern mgRect<int> ItemBoardScrlBar1;

extern mgRect<int> ItemBoardScrlBar2;

extern mgRect<int> ItemBoardScrlBar3;

extern mgRect<int> ItemBoardCursor;

extern waku_edge_pos at_2292;

extern waku_edge_pos at_2303;

extern int MenuItemBrdMaxLine;

extern int MenuItemBrdViewLine;

extern float MenuItemBrdScrlCurLen;

extern "C" int CheckRobotCore__16CUserDataManagerFv(CUserDataManager *manager);

extern "C" int ReloadTexture__17mgCTextureManagerFiP13sceVif1Packet(void *manager, int block, sceVif1Packet *packet);

extern "C" int fptosi(float value);

extern "C" unsigned int fptoui(float value);

extern "C" int __ct__11mgCDrawPrimFv(void *prim);

extern "C" void Draw__16CEffVerticalLineFv(CEffVerticalLine *line);

extern float DrawItemCounter;

extern signed char DrawItemDefCounter;

extern float MenuItemBrdScrlBarY;
extern char at_4453[];
extern float MenuItemBrdUnderBrdPosY_Next;

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

extern int l_levelup_color[2][4];

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

extern "C" char at_4933[];

extern "C" char at_4934[];

extern "C" char at_4935[];

void MENU_BASETEXINFO_Init(MENU_BASETEXINFO *info);

mgCTexture *GetMenuItemIconTexInfo(int itemNo, int index);

void ConvMGIRECTtoINTtbl(mgRect<int> rect, int *corners);

void PushPrimRepeat(mgCDrawPrim *prim, float *positions, int *texCoords, int count);

void MenuWindowHelp(mgCDrawPrim *prim, mgCTexture *texture, float x, float y, float width, float height,
                    short *table);

static void SetMenuDrawNumberKeta(char value);
int DrawMenuNumber(mgCDrawPrim *prim, int number, int align, mgRect<int> rect, mgRect<int> texture_rect, int step_x,
                   int step_y);

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
void ConvMGFRECTtoFLOATtbl(mgRect<float> rect, float *corners) {
    corners[0] = rect.left;
    corners[1] = rect.top;
    corners[2] = rect.left + rect.right;
    corners[3] = rect.top;
    corners[4] = rect.left;
    corners[5] = rect.top + rect.bottom;
    corners[6] = corners[2];
    corners[7] = corners[5];
}
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
#ifdef NONMATCHING
int SetModeMenuDrawItemBoard(int mode) {
    int party;
    int i;
    CGameDataUsed *used;

    MenuDrawItemInfoNum = 0;
    party = GetUserDataMan()->GetNowPartyMember();
    if (mode == 0) {
        for (i = 0; i < 150; i++) {
            MenuDrawItemInfo[i] = &MenuUserParam.used_data[i];
        }
        MenuDrawItemInfoNum = GetNowBagMax(1);
    }
    if (mode == 1) {
        if (party & 1) {
            MenuDrawItemInfo[MenuDrawItemInfoNum] = &MenuUserParam.chara[0]->equip[0];
            MenuDrawItemInfoNum++;
            MenuDrawItemInfo[MenuDrawItemInfoNum] = &MenuUserParam.chara[0]->equip[1];
            MenuDrawItemInfoNum++;
        }
        if (party & 2) {
            MenuDrawItemInfo[MenuDrawItemInfoNum] = &MenuUserParam.chara[1]->equip[0];
            MenuDrawItemInfoNum++;
            MenuDrawItemInfo[MenuDrawItemInfoNum] = &MenuUserParam.chara[1]->equip[1];
            MenuDrawItemInfoNum++;
        }
        used = MenuUserParam.used_data;
        for (i = 0; i < 150; i++, used++) {
            if (used->used_type == USED_ITEM_TYPE_WEAPON) {
                MenuDrawItemInfo[MenuDrawItemInfoNum] = used;
                MenuDrawItemInfoNum++;
            }
        }
    }
    if (mode == 2) {
        if (party & 4) {
            MenuDrawItemInfo[MenuDrawItemInfoNum] = &MenuUserParam.robo->parts[0];
            MenuDrawItemInfoNum++;
        }
        used = MenuUserParam.used_data;
        for (i = 0; i < 150; i++, used++) {
            if (used->item_type == 0xD) {
                MenuDrawItemInfo[MenuDrawItemInfoNum] = used;
                MenuDrawItemInfoNum++;
            }
        }
    }
    if (mode == 3) {
        if (party & 4) {
            MenuDrawItemInfo[MenuDrawItemInfoNum] = &MenuUserParam.robo->parts[2];
            MenuDrawItemInfoNum++;
        }
        used = MenuUserParam.used_data;
        for (i = 0; i < 150; i++, used++) {
            if (used->item_type == 0xF) {
                MenuDrawItemInfo[MenuDrawItemInfoNum] = used;
                MenuDrawItemInfoNum++;
            }
        }
    }
    if (mode == 4) {
        if (0 < GetUserItemHaveNum(0x135)) {
            CFishAquarium *aquarium = GetAquariumData();
            if (aquarium != NULL) {
                used = aquarium->GetAquariumFishTop(0);
                for (i = 0; i < 6; i++, used++) {
                    if (0 < used->item_no) {
                        MenuDrawItemInfo[MenuDrawItemInfoNum] = used;
                        MenuDrawItemInfoNum++;
                    }
                }
            }
        }
        used = MenuUserParam.used_data;
        for (i = 0; i < 150; i++, used++) {
            if (used->used_type == USED_ITEM_TYPE_FISH) {
                MenuDrawItemInfo[MenuDrawItemInfoNum] = used;
                MenuDrawItemInfoNum++;
            }
        }
    }
    for (i = MenuDrawItemInfoNum; i < 150; i++) {
        MenuDrawItemInfo[i] = NULL;
    }
    return MenuDrawItemInfoNum;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menudraw", SetModeMenuDrawItemBoard__Fi);
#endif
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
    spectol_raster_xtbl = (float *)memory->Alloc(0x4E0);
    for (row = 0, offset = 0; row < 0x9C; row++) {
        angle = 0.0418879f * (float)row;
        while (3.1415927f < angle) {
            angle -= 6.2831855f;
        }
        for (column = 0; column < 0x20; column++) {
            spectol_raster_xtbl[offset + column] = 3.0f * sinf(angle);
            angle += 0.15707964f;
        }
        offset += 0x20;
    }
}
#ifdef NONMATCHING
void DrawOneItem(mgCDrawPrim *prim, mgRect<float> rect, int item, int mode, MENU_PARTS_EFFECT_STRUCT1 *effect, u8 *rgba,
                 int item_flag) {
    float bottom = rect.top + rect.bottom;
    if (bottom >= 0.0f && mgScreenWidth - 1 >= rect.left) {
        mgRect<int> icon_uv(0, 0, 0, 0);
        mgCTextureManager *textures = &mgTexManager;
        GetMenuItemIconTexGetXY(item, icon_uv);
        mgCTexture *tex = GetMenuItemIconTexInfo(item, mode);
        if (tex != NULL) {
            if (mode != 0) {
                textures->ReloadCLUT(tex, (sceVif1Packet *)NULL);
            }
            if (effect != NULL) {
                effect->param[0] += 1.0f;
                if (effect->param[0] > 150.0f) {
                    effect->param[0] = 0.0f;
                }
                effect[1].param[0] += 1.0f;
            }
            mgRect<int> uv(item_transtbl[use_trans_rect].left, item_transtbl[use_trans_rect].top,
                           item_transtbl[use_trans_rect].right, item_transtbl[use_trans_rect].bottom);
            u_long tex0 = tex->tex0.value;
            u_int tbp = tex0 & 0x3FFF;
            u_int tbw = (tex0 >> 14) & 0x3F;
            prim->Begin(0);
            prim->Direct(SCE_GS_BITBLTBUF, SCE_GS_SET_BITBLTBUF(tbp, tbw, SCE_GS_PSMT8, tbp, tbw, SCE_GS_PSMT8));
            prim->Direct(SCE_GS_TRXPOS, SCE_GS_SET_TRXPOS(icon_uv.left, icon_uv.top, uv.left, uv.top, 0));
            prim->Direct(SCE_GS_TRXREG, SCE_GS_SET_TRXREG(icon_uv.right, icon_uv.bottom));
            prim->Direct(SCE_GS_TRXDIR, SCE_GS_SET_TRXDIR(2));
            prim->End();
            float right = rect.left + rect.right;
            int uv_right = uv.left + uv.right;
            int uv_bottom = uv.top + uv.bottom;
            if (mode != 1) {
                SetSpriteEnv(prim, 0);
                prim->Begin(6);
                prim->Texture(tex);
                if (mode == 0) {
                    mgRect<float> shadow(3.0f + rect.left, 3.0f + rect.top, rect.right, rect.bottom);
                    prim->Color(0, 0, 0, rgba[3] * 40 / 128);
                    prim->TextureCrd(uv.left, uv.top);
                    prim->Vertex(shadow.left, shadow.top, 0.0f);
                    prim->TextureCrd(uv_right, uv_bottom);
                    prim->Vertex(shadow.left + shadow.right, shadow.top + shadow.bottom, 0.0f);
                }
                if ((item_flag & 1) || item == 0x128) {
                    int add = 0x30;
                    if (DrawItemDefCounter < 40) {
                        add = -36;
                    }
                    int red = rgba[0] + add;
                    if (red < 0) {
                        red = 0;
                    }
                    int green = rgba[1] + add;
                    if (green < 0) {
                        green = 0;
                    }
                    int blue = rgba[2] + add;
                    if (blue < 0) {
                        blue = 0;
                    }
                    prim->Color(red, green, blue, rgba[3]);
                } else {
                    prim->Color(rgba[0], rgba[1], rgba[2], rgba[3]);
                }
                prim->TextureCrd(uv.left, uv.top);
                prim->Vertex(rect.left, rect.top, 0.0f);
                prim->TextureCrd(uv_right, uv_bottom);
                prim->Vertex(right, bottom, 0.0f);
                if (item >= 0xED && item < 0xF5) {
                    prim->End();
                    prim->Bilinear(1);
                    prim->Begin(6);
                    int *paint = paint_color_table_1234[item - 0xED];
                    prim->Color(paint[0] * rgba[0] >> 7, paint[1] * rgba[1] >> 7, paint[2] * rgba[2] >> 7,
                                paint[3] * rgba[3] >> 7);
                    prim->TextureCrd(0x80, 0xC0);
                    prim->Vertex(rect.left, rect.top, 0.0f);
                    prim->TextureCrd(0xA0, 0xE0);
                    prim->Vertex(right, bottom, 0.0f);
                    prim->End();
                    prim->Bilinear(0);
                    prim->Begin(6);
                }
                if (mode == 2) {
                    prim->Color(0x14, 0x14, 0x14, rgba[3] >> 2);
                    prim->TextureCrd(uv.left, uv.top);
                    prim->Vertex(rect.left, rect.top, 0.0f);
                    prim->TextureCrd(uv_right, uv_bottom);
                    prim->Vertex(right, bottom, 0.0f);
                }
                if (item >= 0x188 && item < 0x1A6) {
                    prim->Texture(tex);
                    prim->Color(rgba[0], rgba[1], rgba[2], rgba[3]);
                    int mark = (item - 0x188) % 3;
                    int mark_u = mark % 2 * 16 + 0xC0;
                    int mark_v = mark / 2 * 16 + 0x1A0;
                    prim->TextureCrd(mark_u, mark_v);
                    float mark_y = 20.0f + rect.top;
                    float mark_x = 16.0f + rect.left;
                    prim->Vertex(mark_x, mark_y, 0.0f);
                    prim->TextureCrd(mark_u + 16, mark_v + 16);
                    prim->Vertex(16.0f + mark_x, 16.0f + mark_y, 0.0f);
                }
            } else if (mode == 1) {
                SetSpriteEnv(prim, 4);
                prim->AntiAliasing(0);
                prim->Begin(6);
                prim->Texture(tex);
                prim->Color(rgba[0], rgba[1], rgba[2], rgba[3] >> 2);
                prim->TextureCrd(uv.left, uv.top);
                prim->Vertex(rect.left, rect.top, 0.0f);
                prim->TextureCrd(uv_right, uv_bottom);
                prim->Vertex(right, bottom, 0.0f);
                prim->Flush();
                if (effect != NULL) {
                    int raster = (int)effect->param[0] * 32;
                    float hue = mgAngleLimit(0.017453292f * effect[1].param[0]);
                    int line_v = uv.top;
                    float line_y = rect.top;
                    for (int line = 0; line < 32; line++, line_v++) {
                        float line_x = rect.left + (int)spectol_raster_xtbl[raster + line];
                        float line_h = spectol_y_addtbl_1245[line];
                        u8 red = 255.0f * sinf(hue);
                        u8 green = 255.0f * sinf(2.0943952f + hue);
                        u8 blue = 255.0f * sinf(4.1887903f + hue);
                        prim->Color(red, green, blue, rgba[3] / 3);
                        prim->TextureCrd(uv.left, line_v);
                        prim->Vertex(line_x, line_y, 0.0f);
                        prim->TextureCrd(uv.left + 32, line_v + 1);
                        line_y += line_h;
                        prim->Vertex(32.0f + line_x, line_y, 0.0f);
                        hue += 0.049087387f;
                    }
                }
            }
            prim->End();
            if (item_flag & 2) {
                float mark_x = 23.0f + rect.left;
                float mark_y = 16.0f + rect.top - DrawItemCounter;
                float mark_right = 16.0f + mark_x;
                float mark_bottom = 16.0f + mark_y;
                prim->Bilinear(1);
                prim->Begin(6);
                prim->Color(0x80, 0x80, 0x80, 0x80);
                prim->Texture(tex);
                prim->TextureCrd(0xD0, 0x1B0);
                prim->Vertex(mark_x, mark_y, 0.0f);
                prim->TextureCrd(0xE0, 0x1C0);
                prim->Vertex(mark_right, mark_bottom, 0.0f);
                mark_y += 13.0f;
                mark_bottom += 13.0f;
                prim->TextureCrd(0xD0, 0x1B0);
                prim->Vertex(mark_x, mark_y, 0.0f);
                prim->TextureCrd(0xE0, 0x1C0);
                prim->Vertex(mark_right, mark_bottom, 0.0f);
                prim->End();
                prim->Bilinear(0);
            }
            if (item == 0x137) {
                prim->Begin(6);
                prim->Texture(MenuPosData->item_icon_tex[0][0]);
                prim->Color(0x80, 0x80, 0x80, rgba[3]);
                prim->TextureCrd(0xC0, 0x240);
                prim->Vertex(3.0f + rect.left, 2.0f + rect.top, 0.0f);
                prim->TextureCrd(0xE0, 0x260);
                prim->Vertex(3.0f + right, 2.0f + bottom, 0.0f);
                prim->End();
            }
        }
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menudraw", DrawOneItem__FP11mgCDrawPrim9mgRect_f_iiP25MENU_PARTS_EFFECT_STRUCT1PUci);
#endif
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
void MenuPresentBoxView(int x, int y, int &tex_block, mgCTexture *tex, mgCTexture *cursor_tex) {
    mgCDrawPrim *prim;
    mgRect<int> *window;
    int item_x;
    int i;

    if (NowGiftBoxPtr != NULL && NowGiftBoxPtr->used_type == USED_ITEM_TYPE_GIFT_BOX) {
        prim = GetMenuPrim();
        if (y < mgScreenHeight / 2 - 30) {
            y += 0x38;
        } else {
            y -= 0x46;
        }
        window = &GiftBoxWindowPutPos;
        window->Set(x, y, 0x90, 0x38);
        if (window->left > 0x15C) {
            window->left = 0x15C;
        }
        if (window->left < 0x14) {
            window->left = 0x14;
        }
        if (window->top < 0x28) {
            window->top = 0x28;
        }
        if (window->top > 0x154) {
            window->top = 0x154;
        }
        MenuReloadTexture(tex_block, tex->block);
        MenuWindowHelp(prim, tex, window->left, window->top, window->right, 22.0f, NULL);
        if (MenuPosData != NULL && MenuPosData->item_icon_tex[0][0] != NULL) {
            MenuReloadTexture(tex_block, MenuPosData->item_icon_tex[0][0]->block);
        }
        item_x = window->left + 14;
        for (i = 0; i < 3; i++) {
            Pos_ItemInGiftBox[i][0] = item_x;
            Pos_ItemInGiftBox[i][1] = window->top + 16;
            if (NowGiftBoxPtr->data.giftbox.item_no[i] > 0) {
                mgRect<float> item_rect(Pos_ItemInGiftBox[i][0], Pos_ItemInGiftBox[i][1], 32.0f, 40.0f);
                DrawOneItem(prim, item_rect, NowGiftBoxPtr->data.giftbox.item_no[i], 0, NULL, rgbatbl_1379, 0);
            }
            item_x += 41;
        }
        if (GiftBoxViewFlag != 0 && cursor_tex != NULL) {
            if (init_1394 == 0) {
                curpos_1393 = 0.0f;
                init_1394 = 1;
            }
            curpos_1393 += (Pos_ItemInGiftBox[NowGiftBoxSelect][0] - curpos_1393) / 4.0f;
            if (curpos_1393 < Pos_ItemInGiftBox[0][0]) {
                curpos_1393 = Pos_ItemInGiftBox[0][0];
            }
            if (curpos_1393 > Pos_ItemInGiftBox[2][0]) {
                curpos_1393 = Pos_ItemInGiftBox[2][0];
            }
            MenuReloadTexture(tex_block, cursor_tex->block);
            cursor_put_pos cursor = at_1400__2;
            cursor.pos[0] = curpos_1393 - 32.0f;
            cursor.pos[1] = Pos_ItemInGiftBox[NowGiftBoxSelect][1];
            MenuCursorDraw(cursor_tex, cursor.pos, 0.0f, 0x80);
        }
    }
}
static void SetMenuDrawNumberKeta(char value) {
    MenuDrawNumberKeta = value;
}
#ifdef NONMATCHING
int DrawMenuNumber(mgCDrawPrim *prim, int number, int align, mgRect<int> rect, mgRect<int> texture_rect, int step_x,
                   int step_y) {
    int digits = GetNumberKeta(number);
    int digit_w = texture_rect.right;
    int x = rect.left;
    int y = rect.top;
    int padding = MenuDrawNumberKeta;


    if (align == 1) {
        x = (int)((float)x + 0.5f * (float)step_x * (float)(digits - 1));
    }
    if (align == 2) {
        if (padding < 0) {
            x += step_x * (digits - 1);
        } else {
            x += step_x * (padding - 1);
        }
    }
    while (digits > 0) {
        mgRect<int> dst;
        mgRect<int> src;
        int put_y = y;
        x -= step_x;
        y -= step_y;
        src.Set(texture_rect.left + digit_w * (number % 10), texture_rect.top, digit_w, texture_rect.bottom);
        dst.Set(x, put_y, rect.right, rect.bottom);
        PrimQuad(prim, dst, src);
        number /= 10;
        digits--;
        padding--;
    }
    while (padding > 0) {
        mgRect<int> dst;
        mgRect<int> src;
        int put_y = y;
        x -= step_x;
        y -= step_y;
        src.Set(texture_rect.left, texture_rect.top, digit_w, texture_rect.bottom);
        dst.Set(x, put_y, rect.right, rect.bottom);
        PrimQuad(prim, dst, src);
        padding--;
    }
    return x;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menudraw", DrawMenuNumber__FP11mgCDrawPrimii9mgRect_i_9mgRect_i_ii);
#endif
void PrimDrawNumber(mgCDrawPrim *prim, int number, int digit_count, int x, int y,
                    mgRect<int> texture_rect, int spacing, int mode) {
    SetMenuDrawNumberKeta(-1);
    mgRect<int> rect(x, y, texture_rect.right, texture_rect.bottom);
    DrawMenuNumber(prim, number, digit_count, rect, texture_rect, texture_rect.right + spacing, mode);
}
void PrimDrawNumber2(mgCDrawPrim *prim, int number, int digit_count, int x, int y,
                    mgRect<int> texture_rect, int spacing, int mode) {
    SetMenuDrawNumberKeta((char)digit_count);
    mgRect<int> rect(x, y, texture_rect.right, texture_rect.bottom);
    DrawMenuNumber(prim, number, 0, rect, texture_rect, texture_rect.right + spacing, mode);
}
void PrimFillRect4(mgCDrawPrim *prim, mgRect<float> rect, float *rgba0, float *rgba1, float *rgba2, float *rgba3) {
    float right;
    float bottom;

    if (rgba0 == NULL || rgba1 == NULL || rgba2 == NULL || rgba3 == NULL) {
        return;
    }
    right = rect.left + rect.right;
    bottom = rect.top + rect.bottom;
    prim->Color((int)rgba0[0], (int)rgba0[1], (int)rgba0[2], (int)rgba0[3]);
    prim->Vertex(rect.left, rect.top, 0.0f);
    prim->Color((int)rgba1[0], (int)rgba1[1], (int)rgba1[2], (int)rgba1[3]);
    prim->Vertex(right, rect.top, 0.0f);
    prim->Color((int)rgba2[0], (int)rgba2[1], (int)rgba2[2], (int)rgba2[3]);
    prim->Vertex(rect.left, bottom, 0.0f);
    prim->Color((int)rgba3[0], (int)rgba3[1], (int)rgba3[2], (int)rgba3[3]);
    prim->Vertex(right, bottom, 0.0f);
}
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
#ifdef NONMATCHING
void GenarateRandamLine(int *origin, int width, int height, int *points, int count, int unused) {
    int rising = 1;
    float progress;
    float sway;
    int offset = 0;
    int i;
    for (i = 0; i < count; i++) {
        progress = (float)offset / (float)height;
        if (progress <= 0.06f) {
            progress = 0.04f;
        }
        sway = GetRandI(width) - width / 2;
        points[i * 2] = origin[0] + sway * sinf(3.1415927f * progress);
        points[i * 2 + 1] = origin[1] + offset;
        int step = GetRandI(15);
        if (rising != 0) {
            offset += step;
            if (offset > height) {
                rising = 0;
            }
        } else {
            offset -= step;
            if (offset < 0) {
                rising = 1;
            }
        }
    }
    int stride = GetRandI(7) + 4;
    for (i = 0; i < count && i + stride < count; i += stride) {
        int y = points[i * 2 + 1];
        points[i * 2 + 1] = points[((i + stride) << 1) + 1];
        points[((i + stride) << 1) + 1] = y;
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menudraw", GenarateRandamLine__FPiiiPiii);
#endif
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
void DrawMenuDl(int &tex_block, int x, int y, int w, int alpha) {
    mgCDrawPrim *prim;
    int left;
    float rate;
    float bar_len;
    int bar_w;
    int i;
    mgRect<int> frame_tex;
    mgRect<int> bar_tex;
    mgRect<int> frame_rect;
    mgRect<int> bar_rect;
    mgRect<int> shadow_rect;
    mgRect<int> window_rect;

    if (Tex_MenuDl != NULL) {
        MenuReloadTexture(tex_block, Tex_MenuDl->block);
        left = (mgScreenWidth - w) >> 1;
        prim = GetMenuPrim();
        SetSpriteEnv(prim, 0);
        prim->Begin(6);
        prim->Texture(Tex_MenuDl);
        prim->Color(0x80, 0x80, 0x80, alpha);
        frame_tex.Set(0x74, 0, 0xC, 0xC);
        bar_tex.Set(0x6D, 1, 6, 0xA);
        frame_rect.Set(left + 4, y + 0x40, w - 10, 0xE);
        PrimQuad(prim, frame_rect, frame_tex);
        prim->End();
        prim->Begin(6);
        bar_len = (float)w - (float)(table_1650[0][0].right - 20 + table_1650[1][1].left) - 2.0f;
        rate = (float)MenuDl_ProcessSize / (float)MenuDl_TotalSize;
        bar_w = (int)(bar_len * rate);
        if (rate < 1.0f) {
            prim->Color(0x80, 0x80, 0x80, alpha);
        } else {
            prim->Color(0x40, 0x94, 0x40, alpha);
        }
        bar_rect.Set(left + 0x17, y + 0x41, bar_w, 0xA);
        PrimQuad(prim, bar_rect, bar_tex);
        prim->End();
        prim->Bilinear(0);
        prim->Begin(6);
        for (i = 0; i < 3; i++) {
            prim->Color(0, 0, 0, alpha >> 2);
            shadow_rect.Set(left + 4, y + 4, w, table_1650[i][0].bottom);
            Menu3DivideTextureDraw(prim, shadow_rect, &table_1650[i][0].left, 1);
            prim->Color(0x80, 0x80, 0x80, alpha);
            window_rect.Set(left, y, w, table_1650[i][0].bottom);
            Menu3DivideTextureDraw(prim, window_rect, &table_1650[i][0].left, 1);
            y += table_1650[i][0].bottom;
        }
        prim->End();
    }
}
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
void CalcCommonBrdDrawInfo(float *pos, MENUFORM_MAKEBRD_INFO *info, ClsMes *mes) {
    float board_w;
    int i;
    int center_x;
    int quarter_w;
    int left_x;
    int right_x;

    if (info == NULL || mes == NULL) {
        Tex_CommonBoard = NULL;
        return;
    }
    Tex_CommonBoard = mgTexManager.GetTexture(at_1780, -1);
    board_w = 188.0f;
    if (LanguageCode > 0) {
        board_w = 208.0f;
    }
    board_line_width line_w = at_1720;
    for (i = 0; i < 4; i++) {
        if (mes->name[i + 1][0] != 0) {
            line_w.width[i] = mes->GetStrWidth(mes->name[i + 1]);
        }
        if (line_w.width[i] > board_w) {
            board_w = line_w.width[i];
        }
    }
    MakeBoardDrawInfo[4] = 40.0f + board_w;
    pos[0] = ((float)mgScreenWidth - MakeBoardDrawInfo[4]) / 2.0f - 18.0f;
    center_x = mgScreenWidth >> 1;
    board_w = MakeBoardDrawInfo[4];
    quarter_w = (int)board_w >> 2;
    left_x = center_x - quarter_w - (mes->line_w[0] >> 1);
    if (left_x < 22.0f + pos[0]) {
        left_x = 22.0f + pos[0];
    }
    right_x = center_x + quarter_w - (mes->line_w[1] >> 1);
    if (board_w / 2.0f < mes->line_w[1]) {
        right_x = (float)center_x + board_w / 2.0f - mes->line_w[1] - 4.0f;
    }
    mes->SetMovePosGyou(0, left_x, (int)(16.0f + pos[1]));
    mes->SetMovePosGyou(1, right_x, (int)(42.0f + pos[1]));
    for (i = 0; i < 4; i++) {
        if (mes->name[i + 1][0] != 0) {
            mes->SetMovePosGyou(i + 2, (int)(18.0f + (20.0f + pos[0])), (int)(1.0f + (92.0f + pos[1] + (float)(i * 34))));
        } else {
            mes->SetMovePosGyou(i + 2, -1, -1);
        }
    }
    memcpy(&CommonBoardDrawInfo, info, sizeof(MENUFORM_MAKEBRD_INFO));
}
#ifdef NONMATCHING
void CommonBoardDraw(float *pos, int &tex_block) {
    mgCTexture *board_tex = Tex_CommonBoard;
    if (board_tex == NULL) {
        return;
    }
    make_object_husoku_number_blink += 1.0f;
    if (59.0f < make_object_husoku_number_blink) {
        make_object_husoku_number_blink = 0.0f;
    }
    MenuReloadTexture(tex_block, board_tex->block);
    mgCDrawPrim *prim = GetMenuPrim();
    board_number_uv number_uv = at_1788__3;
    board_line_uv row_uv = at_1790__2;
    board_row_height row_height = at_1791;
    row_height.height[0] = row_uv.uv[0][0][3];
    row_height.height[2] = row_uv.uv[2][0][3];
    row_height.height[4] = row_uv.uv[4][0][3];
    int board_w = (int)MakeBoardDrawInfo[4];
    float board_x = pos[0];
    float board_y = pos[1];
    SetSpriteEnv(prim, 1);
    prim->Begin(6);
    prim->Color(0x28, 0x24, 0x23, 0x80);
    float fill_x = 10.0f + board_x;
    float fill_y = 10.0f + board_y;
    prim->Vertex(fill_x, fill_y, 0.0f);
    prim->Vertex(fill_x + board_w + 20.0f, fill_y + row_height.height[1] + row_height.height[2], 0.0f);
    prim->End();
    SetSpriteEnv(prim, 0);
    prim->Bilinear(0);
    prim->Begin(6);
    prim->Texture(Tex_CommonBoard);
    prim->Color(0x80, 0x80, 0x80, 0x80);
    int row;
    int pass;
    int height;
    for (row = 0; row < 5; row++) {
        int left = (int)(6.0f + pos[0]);
        int top = (int)(6.0f + board_y);
        board_pass_color pass_color = at_1796;
        for (pass = 0; pass < 2; pass++) {
            int *rgba = pass_color.rgba[pass];
            prim->Color(rgba[0], rgba[1], rgba[2], rgba[3]);
            s8 (*uv)[4] = row_uv.uv[row];
            prim->TextureCrd(uv[0][0], uv[0][1]);
            prim->Vertex(left, top, 0);
            prim->TextureCrd(uv[0][0] + uv[0][2], uv[0][1] + uv[0][3]);
            height = row_height.height[row];
            int bottom = top + height;
            prim->Vertex(left + uv[0][2], bottom, 0);
            left += uv[0][2];
            prim->TextureCrd(uv[1][0], uv[1][1]);
            prim->Vertex(left, top, 0);
            prim->TextureCrd(uv[1][0] + uv[1][2], uv[1][1] + uv[1][3]);
            prim->Vertex(left + board_w, bottom, 0);
            left += board_w;
            prim->TextureCrd(uv[2][0], uv[2][1]);
            prim->Vertex(left, top, 0);
            prim->TextureCrd(uv[2][0] + uv[2][2], uv[2][1] + uv[2][3]);
            prim->Vertex(left + uv[2][2], bottom, 0);
            top -= 6;
            left = (int)pos[0];
        }
        board_y += height;
    }
    prim->End();
    float title_x = 16.0f + pos[0];
    float title_y = 66.0f + pos[1];
    mgRect<int> title_uv(0x30, 0, 0x50, 0x14);
    prim->Bilinear(0);
    prim->Begin(6);
    prim->Texture(Tex_CommonBoard);
    prim->Color(0x80, 0x80, 0x80, 0x80);
    mgRect<int> title((int)title_x, (int)title_y, title_uv.right, title_uv.bottom);
    PrimQuad(prim, title, title_uv);
    prim->End();
    float blink = 32.0f * sinf(0.05235988f * make_object_husoku_number_blink);
    board_blink_color blink_color = at_1803__2;
    int blink_add = (int)blink;
    blink_color.rgba[0] = blink_add + 0x80;
    blink_color.rgba[1] = blink_color.rgba[2] = 0x80 - blink_add;
    int line_w = board_w - 10;
    prim->Bilinear(1);
    prim->Begin(6);
    prim->Texture(Tex_CommonBoard);
    prim->Color(0x80, 0x80, 0x80, 0x80);
    int number_u;
    int number_v;
    for (int i = 0, line_y = 0; i < 4; i++, line_y += 34) {
        MENUFORM_MAKEBRD_LINE *line = &CommonBoardDrawInfo.line[i];
        float line_x = 20.0f + pos[0];
        float line_top = 88.0f + pos[1] + line_y;
        s16 (*brd)[4] = get_onoffbrdtbl_1789[line->kind];
        mgRect<int> left_uv(brd[0][0], brd[0][1], brd[0][2], brd[0][3]);
        int top = (int)line_top;
        mgRect<int> left_put((int)line_x, top, brd[0][2], brd[0][3]);
        PrimQuad(prim, left_put, left_uv);
        float middle_x = line_x + brd[0][2];
        mgRect<int> middle_uv(brd[1][0], brd[1][1], brd[1][2], brd[1][3]);
        mgRect<int> middle_put((int)middle_x, top, line_w, brd[1][3]);
        PrimQuad(prim, middle_put, middle_uv);
        float right_x = middle_x + line_w;
        mgRect<int> right_uv(brd[2][0], brd[2][1], brd[2][2], brd[2][3]);
        int number_x = (int)right_x;
        mgRect<int> right_put(number_x, top, brd[2][2], brd[2][3]);
        PrimQuad(prim, right_put, right_uv);
        number_u = number_uv.uv[0][0];
        number_v = number_uv.uv[0][1];
        mgRect<int> number_rect(number_u, number_v, 10, 13);
        int number_y = (int)(10.0f + line_top);
        PrimDrawNumber2(prim, line->num, 0, number_x, number_y, number_rect, 0, 0);
        int times_x = (int)(right_x - GetNumberKeta(line->num) * 10 - 12.0f);
        mgRect<int> times_uv(0x14, 0x5C, 10, 12);
        mgRect<int> times_put(times_x, (int)(9.0f + line_top) + 1, 10, 12);
        PrimQuad(prim, times_put, times_uv);
        if (line->sub_num > 0) {
            prim->Color(blink_color.rgba[0], blink_color.rgba[1], blink_color.rgba[2], 0x80);
            mgRect<int> sub_rect(number_uv.uv[1][0], number_uv.uv[1][1], 10, 13);
            PrimDrawNumber2(prim, line->sub_num, 0, times_x - 2, number_y, sub_rect, 0, 0);
            mgRect<int> slash_uv(0x1E, 0x5C, 10, 12);
            mgRect<int> slash_put(times_x - 14 - GetNumberKeta(line->sub_num) * 10, number_y, 10, 12);
            PrimQuad(prim, slash_put, slash_uv);
            prim->Color(0x80, 0x80, 0x80, 0x80);
        }
        if (line->kind != 0) {
            u8 *button = get_btntbl_1810[line->button];
            mgRect<int> button_uv(button[0], button[1], 16, 16);
            mgRect<int> button_put((int)(line_x - 3.0f), top, 16, 16);
            PrimQuad(prim, button_put, button_uv);
        }
    }
    MakeBoardDrawInfo[1] = 246.0f + pos[1];
    MakeBoardDrawInfo[3] = 28.0f + MakeBoardDrawInfo[1];
    MakeBoardDrawInfo[0] = MakeBoardDrawInfo[2] = (mgScreenWidth >> 1) - MakeBoardDrawInfo[4] / 3.0f;
    board_button_color button_color = at_1814;
    mgRect<int> yes_uv(0x44, 0x14, 0x3C, 0x1A);
    mgRect<int> no_uv(0x44, 0x2E, 0x3C, 0x1A);
    int (*rgba)[4] = button_color.rgba[CommonBoardDrawInfo.unk_20];
    prim->Color(rgba[0][0], rgba[0][1], rgba[0][2], rgba[0][3]);
    int yes_x = (int)MakeBoardDrawInfo[0];
    mgRect<int> yes(yes_x, (int)MakeBoardDrawInfo[1], yes_uv.right, yes_uv.bottom);
    PrimQuad(prim, yes, yes_uv);
    prim->Color(rgba[1][0], rgba[1][1], rgba[1][2], rgba[1][3]);
    int no_x = (int)MakeBoardDrawInfo[2];
    mgRect<int> no(no_x, (int)MakeBoardDrawInfo[3], no_uv.right, no_uv.bottom);
    PrimQuad(prim, no, no_uv);
    int arrow_x = (int)(10.0f + pos[0] + MakeBoardDrawInfo[4] / 2.0f + MakeBoardDrawInfo[4] / 10.0f + 2.0f);
    int arrow_y = (int)(250.0f + pos[1]);
    prim->Color(0x80, 0x80, 0x80, 0x80);
    if (CommonBoardDrawInfo.unk_24 > 0) {
        prim->Color(0xC4, 0xC4, 0xC4, 0x80);
    }
    mgRect<int> down_uv(0x60, 0x48, 0x10, 0x16);
    mgRect<int> down_put(arrow_x, arrow_y, 0x10, 0x16);
    PrimQuad(prim, down_put, down_uv);
    prim->Color(0x80, 0x80, 0x80, 0x80);
    int count_y = (int)(250.0f + pos[1]);
    int count_x = arrow_x + 0x10;
    mgRect<int> count_left_uv(0x36, 0x32, 6, 0x16);
    mgRect<int> count_left(count_x, count_y, 6, 0x16);
    PrimQuad(prim, count_left, count_left_uv);
    mgRect<int> count_middle_uv(0x3C, 0x32, 2, 0x16);
    mgRect<int> count_middle(count_x + 6, count_y, 0x14, 0x16);
    PrimQuad(prim, count_middle, count_middle_uv);
    mgRect<int> count_right_uv(0x3E, 0x32, 6, 0x16);
    mgRect<int> count_right(count_x + 0x1A, count_y, 6, 0x16);
    PrimQuad(prim, count_right, count_right_uv);
    if (CommonBoardDrawInfo.unk_28 > 0) {
        prim->Color(0xC4, 0xC4, 0xC4, 0x80);
    }
    mgRect<int> up_uv(0x70, 0x48, 0x10, 0x16);
    mgRect<int> up_put(count_x + 0x22, arrow_y, 0x10, 0x16);
    PrimQuad(prim, up_put, up_uv);
    prim->Color(0x80, 0x80, 0x80, 0x80);
    mgRect<int> count_rect(number_u, number_v, 10, 13);
    PrimDrawNumber(prim, CommonBoardDrawInfo.unk_1c, 1, count_x + 0x15, count_y + 5, count_rect, 0, 0);
    prim->End();
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menudraw", CommonBoardDraw__FPfRi);
#endif
void MenuCursorDraw(mgCTexture *tex, float *pos, float rot, int reverse, int alpha, float scale) {
    mgCDrawPrim *prim;
    float sin_rot;
    float cos_rot;

    if (tex != NULL) {
        prim = GetMenuPrim();
        cursor_width width = at_1998__2;
        cursor_hand hand = at_1999__2;
        SetSpriteEnv(prim, 0);
        hand.corner[0][0] = scale * width.width[reverse];
        hand.corner[0][1] *= scale;
        hand.corner[1][0] = scale * width.width[reverse];
        hand.corner[1][1] *= scale;
        hand.corner[2][0] *= scale;
        hand.corner[2][1] *= scale;
        sin_rot = sinf(rot);
        cos_rot = cosf(rot);
        prim->Bilinear(1);
        prim->Begin(4);
        prim->Texture(tex);
        prim->Color(0x80, 0x80, 0x80, alpha);
        prim->TextureCrd(menu_long_hand.left, menu_long_hand.top);
        prim->Vertex(3.0f + pos[0], 3.0f + pos[1], 0.0f);
        prim->TextureCrd(menu_long_hand.left + menu_long_hand.right, menu_long_hand.top);
        prim->Vertex(3.0f + (pos[0] + (hand.corner[0][0] * cos_rot - hand.corner[0][1] * sin_rot)),
                     pos[1] + (hand.corner[0][0] * sin_rot + hand.corner[0][1] * cos_rot), 0.0f);
        prim->TextureCrd(menu_long_hand.left, menu_long_hand.top + menu_long_hand.bottom);
        prim->Vertex(3.0f + (pos[0] + (hand.corner[2][0] * cos_rot - hand.corner[2][1] * sin_rot)),
                     3.0f + (pos[1] + (hand.corner[2][0] * sin_rot + hand.corner[2][1] * cos_rot)), 0.0f);
        prim->TextureCrd(menu_long_hand.left + menu_long_hand.right, menu_long_hand.top + menu_long_hand.bottom);
        prim->Vertex(3.0f + (pos[0] + (hand.corner[1][0] * cos_rot - hand.corner[1][1] * sin_rot)),
                     pos[1] + (hand.corner[1][0] * sin_rot + hand.corner[1][1] * cos_rot), 0.0f);
        prim->End();
    }
}
void MenuCursorDraw(mgCTexture *texture, float *position, float value, int flag) {
    MenuCursorDraw(texture, position, value, 0, flag, 1.0f);
}
void DrawMenuTilePattern(mgCDrawPrim *prim, mgCTexture *tex, float x, float y, mgRect<int> tex_rect, int unused,
                         u8 *rgba) {
    mgRect<int> dest(0, 0, 0, 0);
    int column;
    int row;
    y -= tex_rect.bottom;
    SetSpriteEnv(prim, 0);
    prim->Begin(6);
    prim->Texture(tex);
    if (rgba != NULL) {
        prim->Color(rgba[0], rgba[1], rgba[2], rgba[3]);
    } else {
        prim->Color(0x80, 0x80, 0x80, 0x80);
    }
    for (column = 0; column < 16; column++) {
        if (!(x <= mgScreenWidth + 4)) {
            break;
        }
        dest.Set((int)x, (int)y, tex_rect.right, tex_rect.bottom);
        for (row = 0; row < 12; row++) {
            if (dest.top > mgScreenHeight + 40) {
                break;
            }
            PrimQuad(prim, dest, tex_rect);
            dest.top += dest.bottom;
        }
        x += dest.right;
    }
    prim->End();
}
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
    return MenuMainFrame_LeftTop_Pos;
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
void MenuMainFrameStep(void) {
    mgRect<int> screen;
    MenuMainFrame_PutRect.Set(0, 0, 0x2C0, 0x1E0);
    screen.Set(0, 0, 0x2C0, 0x1A0);
    float progress = MenuMainFrame_Display_Mode_Cnt / 10.0f;
    float scale = 1.5f - 0.5f * progress;
    if (init_2093 == 0) {
        MainFrameStepFlag_2092 = 0;
        init_2093 = 1;
    }
    switch (MenuMainFrame_Display_Mode) {
        case 0:
        case 1: {
            mgRect<int> *image;
            if (MenuMainFrame_Display_Mode == 0) {
                if (MenuMainFrame_Display_Mode_Cnt < 10.0f) {
                    CalcMenuAdd(&MenuMainFrame_Display_Mode_Cnt, MenuMainFrame_Display_Mode_Cnt_Rate, 10.0f);
                    if (MenuMainFrame_Display_Mode_Cnt < 7.142857f) {
                        CalcMenuAdd(&MenuMainFrame_Display_Mode_Cnt_Rate, 0.3f, 1.4f);
                    } else {
                        CalcMenuAdd(&MenuMainFrame_Display_Mode_Cnt_Rate, -0.3f, 0.6f);
                    }
                    MainFrameStepFlag_2092 = 0;
                } else {
                    MainFrameStepFlag_2092 = 0;
                    MenuMainFrame_Display_Mode_Cnt = 10.0f;
                    MenuMainFrame_ActionEndFlag = 1;
                }
            }
            int mode = MenuMainFrame_Display_Mode;
            if (mode == 1) {
                if (0.0f < MenuMainFrame_Display_Mode_Cnt) {
                    MenuMainFrame_Display_Mode_Cnt -= 1.0f;
                }
                if (MainFrameStepFlag_2092 > 0) {
                    MenuMainFrame_ActionEndFlag = 1;
                }
                if (MenuMainFrame_Display_Mode_Cnt < 0.0f) {
                    MenuMainFrame_Display_Mode_Cnt = 0.0f;
                }
            }
            MenuMainFrame_Lenze_Pos[0] = 256.0f + 94.0f * progress;
            MenuMainFrame_Lenze_Pos[1] = 240.0f;
            float lenze_x = MenuMainFrame_Lenze_Pos[0];
            MenuMainFrame_PutRect.left = (int)(lenze_x - 350.0f * scale);
            MenuMainFrame_PutRect.top = (int)(MenuMainFrame_Lenze_Pos[1] - 240.0f * scale);
            MenuMainFrame_PutRect.right = (int)(704.0f * scale);
            MenuMainFrame_PutRect.bottom = (int)(480.0f * scale);
            float image_half_height = 1.1538461f * (scale * 160.0f);
            image = &MenuMainIMG_PutRect;
            image->bottom = (int)(2.0f * image_half_height);
            image->right = (int)(1.06f * image->bottom);
            image->left = (int)(lenze_x - 198.0f * scale);
            image->top = (int)(MenuMainFrame_Lenze_Pos[1] - image_half_height);
            if (image->right > mgScreenWidth) {
                if (mode == 1) {
                    image->right = mgScreenWidth;
                } else {
                    image->right = mgScreenWidth;
                    image->left = 0;
                }
            }
            while (image->top < 0) {
                image->top++;
            }
            while (mgScreenHeight < image->top + image->bottom) {
                image->bottom--;
            }
            if (image->left < 9) {
                image->left = 0;
                MainFrameStepFlag_2092++;
            }
            break;
        }
        case 2:
            MenuMainFrame_Lenze_Pos[0] -= 11.285714f;
            if (MenuMainFrame_Lenze_Pos[0] < 158.0f) {
                MenuMainFrame_Lenze_Pos[0] = 158.0f;
                MenuMainFrame_ActionEndFlag = 1;
            }
            break;
        case 3:
            MenuMainFrame_Lenze_Pos[0] += 11.285714f;
            if (!(MenuMainFrame_Lenze_Pos[0] < 350.0f)) {
                MenuMainFrame_Lenze_Pos[0] = 350.0f;
                MenuMainFrame_ActionEndFlag = 1;
            }
            break;
        case 4:
        case 5: {
            MenuMainFrame_MoveRate_Cnt += 0.08726647f;
            float move = MenuMainFrame_MoveRate[0] * sinf(MenuMainFrame_MoveRate_Cnt);
            if (MenuMainFrame_Display_Mode == 4 && move < 0.0f) {
                move = -move;
            }
            if (MenuMainFrame_Display_Mode == 5 && move > 0.0f) {
                move = -move;
            }
            MenuMainFrame_Lenze_Pos[0] += move;
            if (MenuMainFrame_Display_Mode == 4) {
                if (!(MenuMainFrame_Lenze_Pos[0] < 860.0f)) {
                    MenuMainFrame_Lenze_Pos[0] = 860.0f;
                    MenuMainFrame_ActionEndFlag = 1;
                }
            } else if (MenuMainFrame_Lenze_Pos[0] <= 350.0f) {
                MenuMainFrame_Lenze_Pos[0] = 350.0f;
                MenuMainFrame_ActionEndFlag = 1;
            }
            break;
        }
        case 6:
        case 7: {
            MenuMainFrame_MoveRate_Cnt += 0.09817477f;
            float move = MenuMainFrame_MoveRate[1] * sinf(MenuMainFrame_MoveRate_Cnt);
            if (MenuMainFrame_Display_Mode == 6 && move < 0.0f) {
                move = -move;
            }
            if (MenuMainFrame_Display_Mode == 7 && move > 0.0f) {
                move = -move;
            }
            MenuMainFrame_Lenze_Pos[1] += move;
            if (MenuMainFrame_Display_Mode == 6 && !(MenuMainFrame_Lenze_Pos[1] < 720.0f)) {
                MenuMainFrame_Lenze_Pos[1] = 720.0f;
                MenuMainFrame_ActionEndFlag = 1;
            }
            if (MenuMainFrame_Display_Mode == 7 && MenuMainFrame_Lenze_Pos[1] <= 240.0f) {
                MenuMainFrame_Lenze_Pos[1] = 240.0f;
                MenuMainFrame_ActionEndFlag = 1;
            }
            break;
        }
        case 8:
        case 9: {
            MenuMainFrame_MoveRate_Cnt += 0.08726647f;
            float move = MenuMainFrame_MoveRate[1] * sinf(MenuMainFrame_MoveRate_Cnt);
            if (MenuMainFrame_Display_Mode == 8 && move > 0.0f) {
                move = -move;
            }
            if (MenuMainFrame_Display_Mode == 9 && move < 0.0f) {
                move = -move;
            }
            MenuMainFrame_Lenze_Pos[1] += move;
            if (MenuMainFrame_Display_Mode == 8 && MenuMainFrame_Lenze_Pos[1] <= -260.0f) {
                MenuMainFrame_Lenze_Pos[1] = -260.0f;
                MenuMainFrame_ActionEndFlag = 1;
            }
            if (MenuMainFrame_Display_Mode == 9 && !(MenuMainFrame_Lenze_Pos[1] < 240.0f)) {
                MenuMainFrame_Lenze_Pos[1] = 240.0f;
                MenuMainFrame_ActionEndFlag = 1;
            }
            break;
        }
    }
    if (MenuMainFrame_Display_Mode >= 2) {
        MenuMainFrame_PutRect.left = (int)(MenuMainFrame_Lenze_Pos[0] - 350.0f * scale);
        MenuMainFrame_PutRect.top = (int)(MenuMainFrame_Lenze_Pos[1] - 240.0f * scale);
    }
    MenuMainFrame_LeftTop_Pos[0] = MenuMainFrame_PutRect.left;
    MenuMainFrame_LeftTop_Pos[1] = MenuMainFrame_PutRect.top;
}
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
#ifdef NONMATCHING
void MenuMainFrameImgDraw(int &loaded_tex_no) {
    mgRect<int> dest(0, 0, 0, 0);
    mgRect<int> source(0, 0, mgScreenWidth / 2, mgScreenHeight / 2);
    int alpha = fptosi(128.0f * (MenuMainFrame_Display_Mode_Cnt / 10.0f));
    dest = MenuMainIMG_PutRect;
    if (MenuMainFrame_Display_Mode == 1 || MenuMainFrame_Display_Mode == 0) {
        if (MenuMainFrame_Display_Mode == 1) {
            alpha = 0x80;
        }
    } else {
        dest.left = fptosi(MenuMainFrame_Lenze_Pos[0] - 194.0f);
        dest.top = fptosi(MenuMainFrame_Lenze_Pos[1] - 184.61539f);
    }
    mgRect<int> screen(0, 0, mgScreenWidth, mgScreenHeight);
    DrawMenuMainFrmImg(loaded_tex_no, screen, source, 0x80, 0x80, 0x80, alpha, 0);
    dest.bottom += 1;
    DrawMenuMainFrmImg(loaded_tex_no, dest, source, 0x80, 0x80, 0x80, alpha, 0);
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menudraw", MenuMainFrameImgDraw__FRi);
#endif
#ifdef NONMATCHING
void DrawMenuWakuStep(void) {
    float move[2][3] = {{-0.2f, 0.0f, 18.0f}, {0.2f, 18.0f, 0.0f}};
    int i;
    for (i = 0; i < 2; i++) {
        float *axis = &MenuWakuPutXY[i];
        float *entry = move[i];
        *axis += entry[0];
        if (CalcMenuAdd(axis, entry[0], entry[1]) != 0) {
            *axis = entry[2];
        }
    }
    MenuWakuRotCnt -= 3.1415927f / 220.0f;
    if (MenuWakuRotCnt <= -3.1415927f) {
        MenuWakuRotCnt += 6.2831855f;
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menudraw", DrawMenuWakuStep__Fv);
#endif
void DrawMenuWakuRect(mgCTexture *tex, mgRect<float> rect, mgRect<int> tex_rect, int a, int r, int g, int b) {
    mgCDrawPrim *prim;
    float sign;
    float piece_w;
    float x;
    float y;
    int count;
    int i;
    int j;

    if (tex != NULL) {
        prim = GetMenuPrim();
        mgRect<int> outer((int)rect.left, (int)rect.top, (int)(tex_rect.bottom + (rect.left + rect.right)),
                          (int)(tex_rect.right + (rect.top + rect.bottom)));
        mgRect<int> scissor = outer;
        MenuClipRectCheck(scissor);
        if (scissor.right > 1) {
            SetMenuScissor(scissor);
            SetSpriteEnv(prim, 4);
            prim->Begin(6);
            prim->Texture(tex);
            prim->Color(r, g, b, a);
            sign = 1.0f;
            piece_w = tex_rect.right;
            count = (int)(3.0f + rect.right / piece_w);
            waku_edge_pos edge = at_2292;
            edge.pos[0][0] = outer.right - 3;
            edge.pos[0][1] = outer.top - 5;
            edge.pos[1][0] = outer.left;
            edge.pos[1][1] = outer.bottom - 8;
            for (i = 0; i < 2; i++) {
                x = MenuWakuPutXY[0] * sign + edge.pos[i][0];
                y = edge.pos[i][1];
                for (j = 0; j < count; j++) {
                    prim->TextureCrd(tex_rect.left, tex_rect.top);
                    prim->Vertex(x, y, 0.0f);
                    prim->TextureCrd(tex_rect.left + tex_rect.right, tex_rect.top + tex_rect.bottom);
                    prim->Vertex(x + tex_rect.right, y + tex_rect.bottom, 0.0f);
                    x -= piece_w * sign;
                }
                sign *= -1.0f;
            }
            prim->End();
            waku_edge_pos side_edge;
            mgRect<int> side(0, scissor.top + 1, mgScreenWidth - 1, scissor.bottom - 1);
            SetMenuScissor(side);
            SetSpriteEnv(prim, 4);
            prim->Begin(5);
            count = (int)(3.0f + rect.bottom / piece_w);
            side_edge = at_2303;
            side_edge.pos[0][0] = outer.left - 5;
            side_edge.pos[0][1] = outer.top - 13;
            side_edge.pos[1][0] = outer.right - 8;
            side_edge.pos[1][1] = outer.bottom;
            for (j = 0; j < 2; j++) {
                x = side_edge.pos[j][0];
                y = MenuWakuPutXY[1] * sign + side_edge.pos[j][1];
                for (i = 0; i < count; i++) {
                    prim->TextureCrd(tex_rect.left, tex_rect.top + tex_rect.bottom);
                    prim->Vertex(x, y, 0.0f);
                    prim->TextureCrd(tex_rect.left, tex_rect.top);
                    prim->Vertex(x + tex_rect.bottom, y, 0.0f);
                    prim->TextureCrd(tex_rect.left + tex_rect.right, tex_rect.top);
                    prim->Vertex(x + tex_rect.bottom, y + tex_rect.right, 0.0f);
                    prim->TextureCrd(tex_rect.left + tex_rect.right, tex_rect.top + tex_rect.bottom);
                    prim->Vertex(x, y + tex_rect.right, 0.0f);
                    prim->Flush();
                    y += piece_w * sign;
                }
                sign *= -1.0f;
            }
            prim->End();
            ResetMenuScissor();
        }
    }
}
void DrawWakuCircle(mgCDrawPrim *prim, mgCTexture *tex, mgRect<float> rect, mgRect<int> tex_rect, float rot, float size,
                    int a, int r, int g, int b) {
    float radius = size / 2.0f;
    float center_x = rect.left + rect.right / 2.0f;
    float center_y = rect.top + rect.bottom / 2.0f;
    sceVu0FVECTOR pos;
    quad_uv uv = at_2395__4;
    int i;

    uv.corner[0][0] = tex_rect.left;
    uv.corner[0][1] = tex_rect.top;
    uv.corner[1][0] = tex_rect.left + tex_rect.right;
    uv.corner[1][1] = tex_rect.top;
    uv.corner[2][0] = tex_rect.left + tex_rect.right;
    uv.corner[2][1] = tex_rect.top + tex_rect.bottom;
    uv.corner[3][0] = tex_rect.left;
    uv.corner[3][1] = tex_rect.top + tex_rect.bottom;
    prim->Begin(5);
    prim->Texture(tex);
    prim->Color(r, g, b, a);
    for (i = 0; i < 4; i++) {
        pos[0] = center_x + radius * cosf(rot);
        pos[1] = center_y + radius * sinf(rot);
        prim->TextureCrd((int)uv.corner[i][0], (int)uv.corner[i][1]);
        prim->Vertex(pos);
        rot += 1.5707964f;
    }
    prim->End();
}
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
void CMenuPosDataForm::GetPutPosXY(char *part_name, int &out_x, int &out_y) {
    float pos[2] = {out_x, out_y};
    GetPutPosXY(part_name, pos[0], pos[1]);
    out_x = pos[0];
    out_y = pos[1];
}
void CMenuPosDataForm::GetPutPosXY(char *part_name, float &out_x, float &out_y) {
    float put_x;
    float put_y;
    int i;
    CMenuPosDataForm *form;
    int form_pos[2];

    put_x = x;
    put_y = y;
    if (vibe_cnt[0] != 0) {
        put_x += 10.0f * cosf((3.1415927f / vibe_cnt[0]) * counter);
    }
    if (vibe_cnt[1] != 0) {
        put_y += 8.0f * sinf((3.1415927f / vibe_cnt[1]) * counter);
    }
    if (part_name == NULL) {
        out_x = put_x;
        out_y = put_y;
        return;
    }
    for (i = 0; i < parts_num; i++) {
        if (parts[i].name != NULL && strcmp(parts[i].name, part_name) == 0) {
            switch (parts[i].dtype) {
            case MENUFORMPARTS_DTYPE_FORM:
                form = MenuPosData->GetFormInfo(parts[i].tex_info_no);
                if (form != NULL) {
                    form->GetPutPosXY(part_name, form_pos[0], form_pos[1]);
                }
                put_x += form_pos[0];
                put_y += form_pos[1];
                break;
            case MENUFORMPARTS_DTYPE_FUNCINFO:
                put_x += parts[i].x;
                put_y += parts[i].y;
                if (parts[i].vibe_cnt[0] != 0) {
                    put_x += parts[i].viber[0] * cosf(counter * (3.1415927f / parts[i].vibe_cnt[0]));
                }
                if (parts[i].vibe_cnt[1] != 0) {
                    put_y += parts[i].viber[1] * sinf(counter * (3.1415927f / parts[i].vibe_cnt[1]));
                }
                break;
            default:
                put_x += parts[i].x;
                put_y += parts[i].y;
                break;
            }
            break;
        }
    }
    out_x = put_x;
    out_y = put_y;
}
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
#ifdef NONMATCHING
int CMenuPosDataForm::GetNowPosRGBA(MENUFORMPARTS_TYPE *part, MENU_BASETEXINFO *tex_info, float *pos, u8 *rgba) {
    MENU_PARTS_EFFECT_STRUCT1 *effect;
    int i;
    int k;
    int n;
    float center_x;
    float center_y;
    float angle;
    float phase;
    float cos_angle;
    float sin_angle;
    float scale_x;
    float scale_y;
    float grow;
    float shrink;
    int dx;
    int dy;
    float rot[4][4];
    float sway[4][2];
    short color;

    if (part == NULL) {
        return 0;
    }
    effect = part->effect;
    if (effect == NULL || part->effect_num <= 0) {
        return 0;
    }
    center_x = tex_info->rect.right + (x + part->x);
    center_y = tex_info->rect.bottom + (y + part->y);
    for (i = 0; i < part->effect_num && effect != NULL; i++, effect++) {
        if (effect->type == MENU_PARTS_EFFECT_UNK_1) {
            if (effect->param[0] <= effect->param[1]) {
                rgba[0] = effect->param[2];
                rgba[1] = effect->param[3];
                rgba[2] = effect->param[4];
                rgba[3] = effect->param[5];
            }
        } else if (effect->type == MENU_PARTS_EFFECT_BLINK) {
            for (k = 0; k < 4; k++) {
                color = rgba[k] + (int)(effect->param[2] * cosf((6.2831855f / effect->param[1]) * effect->param[0]));
                rgba[k] = color;
            }
        } else if (effect->type == MENU_PARTS_EFFECT_ROT || effect->type == MENU_PARTS_EFFECT_HURIKO) {
            angle = 0.0f;
            phase = effect->param[0];
            if (effect->type == MENU_PARTS_EFFECT_HURIKO) {
                if (effect->param[1] > 0.0f) {
                    if (phase >= effect->param[1] / 2.0f) {
                        phase = effect->param[1] - phase;
                    }
                } else if (effect->param[1] < 0.0f && phase <= effect->param[1] / 2.0f) {
                    phase = effect->param[1] - phase;
                }
            }
            if (effect->param[4] != 0.0f) {
                angle = (6.2831855f / effect->param[4]) * phase;
            }
            angle += 6.2831855f / effect->param[5];
            cos_angle = cosf(angle);
            sin_angle = sinf(angle);
            for (k = 0; k < 4; k++) {
                rot[k][0] = cos_angle;
                rot[k][1] = sin_angle;
                rot[k][2] = -sin_angle;
                rot[k][3] = cos_angle;
            }
            for (k = 0, n = 0; k < 4; k++, n += 2) {
                dx = pos[n] - center_x;
                dy = pos[n + 1] - center_y;
                pos[n] = center_x + (dx * rot[k][0] + dy * rot[k][1]);
                pos[n + 1] = center_y + (dx * rot[k][2] + dy * rot[k][3]);
            }
        } else if (effect->type == MENU_PARTS_EFFECT_STRETCH || effect->type == MENU_PARTS_EFFECT_STRETCH_REP) {
            grow = effect->param[0] / 3.0f;
            scale_x = effect->param[4] + grow;
            scale_y = effect->param[5] + grow;
            if (effect->type == MENU_PARTS_EFFECT_STRETCH_REP && grow > effect->param[1] / 2.0f) {
                shrink = effect->param[1] - grow;
                scale_x = (effect->param[4] - shrink) / 100.0f;
                scale_y = (effect->param[5] - shrink) / 100.0f;
            }
            pos[0] = center_x + part->w / 2.0f * scale_x;
            pos[1] = center_y + part->h / 2.0f * scale_y;
            pos[2] = center_x + part->w / 2.0f * scale_x;
            pos[3] = center_y + part->h / 2.0f * scale_y;
            pos[4] = center_x + part->w / 2.0f * scale_x;
            pos[5] = center_y + part->h / 2.0f * scale_y;
            pos[6] = center_x + part->w / 2.0f * scale_x;
            pos[7] = center_y + part->h / 2.0f * scale_y;
        } else if (effect->type == MENU_PARTS_EFFECT_STRETCH_SIN) {
            sin_angle = sinf(6.2831855f * effect->param[0] / effect->param[1]);
            sway[0][0] = -sin_angle;
            sway[0][1] = -sin_angle;
            sway[1][0] = sin_angle;
            sway[1][1] = -sin_angle;
            sway[2][0] = -sin_angle;
            sway[2][1] = sin_angle;
            sway[3][0] = sin_angle;
            sway[3][1] = sin_angle;
            pos[0] += effect->param[4] * sway[0][0];
            pos[1] += effect->param[5] * sway[0][1];
            pos[2] += effect->param[4] * sway[1][0];
            pos[3] += effect->param[5] * sway[1][1];
            pos[4] += effect->param[4] * sway[2][0];
            pos[5] += effect->param[5] * sway[2][1];
            pos[6] += effect->param[4] * sway[3][0];
            pos[7] += effect->param[5] * sway[3][1];
        }
    }
    return 1;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menudraw", GetNowPosRGBA__16CMenuPosDataFormFP18MENUFORMPARTS_TYPEP16MENU_BASETEXINFOPfPUc);
#endif
void CMenuPosDataForm::MenuPartsStep() {
    int i;
    MENUFORMPARTS_TYPE *part;
    MENU_PARTS_EFFECT_STRUCT1 *effect;
    int finished;
    int j;

    for (i = 0; i < parts_num; i++) {
        part = &parts[i];
        if (part != NULL && (effect = part->effect) != NULL) {
            for (j = 0; j < part->effect_num; j++, effect++) {
                finished = 0;
                if (effect->type == MENU_PARTS_EFFECT_UNK_100) {
                    continue;
                }
                if (effect->type == MENU_PARTS_EFFECT_UNK_9) {
                    effect->param[0] += 1.0f;
                    if (effect->param[0] >= effect->param[1]) {
                        SetPartEffectInfoRandFunc(effect);
                    }
                } else if (effect->type == MENU_PARTS_EFFECT_UNK_1) {
                    effect->param[0] += 1.0f;
                    if (effect->param[0] > effect->param[1]) {
                        effect->param[0] = 1.0f + effect->param[1];
                    }
                } else if (effect->type == MENU_PARTS_EFFECT_BLINK) {
                    effect->param[0] += 1.0f;
                    if (effect->param[0] >= effect->param[1]) {
                        finished = 1;
                        effect->param[0] = 0.0f;
                    }
                } else if (effect->type == MENU_PARTS_EFFECT_ROT || effect->type == MENU_PARTS_EFFECT_HURIKO ||
                           effect->type == MENU_PARTS_EFFECT_UNK_10 || effect->type == MENU_PARTS_EFFECT_UNK_11) {
                    if (effect->param[1] > 0.0f) {
                        effect->param[0] += 1.0f;
                        if (effect->param[0] >= effect->param[1]) {
                            effect->param[0] = 0.0f;
                            finished = 1;
                        }
                    } else if (effect->param[1] < 0.0f) {
                        effect->param[0] -= 1.0f;
                        if (effect->param[0] <= effect->param[1]) {
                            effect->param[0] = 0.0f;
                            finished = 1;
                        }
                    }
                } else if (effect->type == MENU_PARTS_EFFECT_STRETCH || effect->type == MENU_PARTS_EFFECT_STRETCH_REP ||
                           effect->type == MENU_PARTS_EFFECT_STRETCH_SIN) {
                    if (effect->param[1] < 0.0f) {
                        effect->param[0] -= 1.0f;
                        if (effect->param[0] <= effect->param[1]) {
                            effect->param[0] = 0.0f;
                            finished = 1;
                        }
                    } else if (effect->param[1] > 0.0f) {
                        effect->param[0] += 1.0f;
                        if (effect->param[0] >= effect->param[1]) {
                            effect->param[0] = 0.0f;
                            finished = 1;
                        }
                    }
                } else if (effect->type == MENU_PARTS_EFFECT_UNK_12) {
                    effect->param[0] += 1.0f;
                }
                if (finished != 0 && effect->repeat == 0) {
                    effect->active = 0;
                }
            }
        }
    }
}
#ifdef NONMATCHING
static void DrawItemIconEffect2(mgCDrawPrim *prim, mgCTexture *tex, MENUFORMPARTS_TYPE *parts, mgRect<float> rect) {
    MENU_PARTS_EFFECT_STRUCT1 *effect;
    int i;
    int k;
    int n;
    short center_x;
    short center_y;
    float sin_angle;
    float cos_angle;
    float scale;
    float angle;
    int alpha;
    int *color;
    float dx;
    float dy;

    if (parts != NULL && parts->effect != NULL) {
        effect = parts->effect + 2;
        mgRect<float> star_rect;
        float corners[4][2];
        int uv[8];
        star_rect.left = rect.left;
        star_rect.top = rect.top;
        star_rect.right = 8.0f;
        star_rect.bottom = 8.0f;
        ConvMGIRECTtoINTtbl(star_light, uv);
        SetSpriteEnv(prim, 4);
        prim->Begin(4);
        prim->Texture(tex);
        for (i = 0; i < 5; i++, effect++) {
            if (!(effect->param[0] <= 0.0f)) {
                star_rect.left = rect.left + effect->param[2];
                star_rect.top = rect.top + effect->param[3];
                ConvMGFRECTtoFLOATtbl(star_rect, corners[0]);
                center_x = 4.0f + star_rect.left;
                center_y = 4.0f + star_rect.top;
                scale = effect->param[5];
                angle = 0.34906587f * effect->param[6];
                sin_angle = sinf(angle);
                cos_angle = cosf(angle);
                alpha = (int)(64.0f * sinf((3.1415927f / effect->param[1]) * effect->param[0]));
                color = &star_color_table[(int)(3.0f * effect->param[4])];
                prim->Color(color[0], color[1], color[2], alpha);
                for (k = 0, n = 0; k < 4; k++, n += 2) {
                    dx = scale * ((float)center_x - corners[k][0]);
                    dy = scale * ((float)center_y - corners[k][1]);
                    corners[k][0] = center_x + dx * cos_angle - dy * sin_angle;
                    corners[k][1] = center_y + dx * sin_angle + dy * cos_angle;
                    prim->TextureCrd(uv[n], uv[n + 1]);
                    prim->Vertex((int)corners[0][n], (int)corners[0][n + 1], 0);
                }
                prim->Flush();
            }
        }
        prim->End();
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menudraw", DrawItemIconEffect2__FP11mgCDrawPrimP10mgCTextureP18MENUFORMPARTS_TYPE9mgRect_f_);
#endif
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
#ifdef NONMATCHING
void MenuItemBrdFrameDraw(int x, int y, int &tex_block, int a, int r, int g, int b) {
    int shadow_alpha;
    mgCDrawPrim *prim = GetMenuPrim();
    mgRect<int> put(0, 0, 0, 0);
    mgRect<int> top_left(0, 0, 32, 32);
    mgRect<int> top(32, 0, 32, 32);
    mgRect<int> top2(64, 0, 32, 32);
    mgRect<int> top_right(96, 0, 32, 32);
    mgRect<int> left(0, 32, 32, 32);
    mgRect<int> right(96, 32, 32, 32);
    mgRect<int> left2(0, 64, 32, 32);
    mgRect<int> right2(96, 64, 32, 32);
    mgRect<int> bottom_left(0, 96, 32, 32);
    mgRect<int> bottom(32, 96, 32, 32);
    mgRect<int> bottom2(64, 96, 32, 32);
    mgRect<int> bottom_right(96, 96, 32, 32);
    board_frame_parts parts = at_2919;
    parts.rect[0] = &top_left;
    parts.rect[1] = &top;
    parts.rect[2] = &top2;
    parts.rect[3] = &top_right;
    parts.rect[4] = &left;
    parts.rect[5] = &right;
    parts.rect[6] = &left2;
    parts.rect[7] = &right2;
    parts.rect[8] = &bottom_left;
    parts.rect[9] = &bottom;
    parts.rect[10] = &bottom2;
    parts.rect[11] = &bottom_right;
    mgCTexture *tex = mgTexManager.GetTexture(at_3054, -1);
    if (tex != NULL) {
        MenuReloadTexture(tex_block, tex->block);
        put.right = 40;
        float put_x = x + 4.0f;
        float put_y = y + 262.0f;
        int clip_left = (int)put_x;
        int clip_top = (int)(put_y + 20.0f);
        int clip_right = (int)(put_x + 300.0f);
        mgRect<int> clip(clip_left, clip_top, clip_right, (int)(put_y + 50.0f));
        MenuClipRectCheck(clip);
        SetMenuScissor(clip);
        SetSpriteEnv(prim, 0);
        prim->Bilinear(1);
        prim->Begin(6);
        prim->Texture(tex);
        prim->Color(r, g, b, a);
        int part = 8;
        prim->Color(0, 0, 0, shadow_alpha = (int)(2.0f * a / 3.0f));
        mgRect<float> corner(put_x, put_y, 40.0f, 32.0f);
        PrimQuad(prim, corner, *parts.rect[frmtbl0_2922[part++]]);
        put_x += 40.0f;
        int i;
        int j;
        int put_top;
        for (i = 0; i < 5; i++) {
            mgRect<int> edge((int)put_x, put_top = (int)put_y, 40, 32);
            PrimQuad(prim, edge, *parts.rect[frmtbl0_2922[part++]]);
            put_x += 40.0f;
        }
        mgRect<int> end_corner((int)put_x, put_top, 32, 32);
        PrimQuad(prim, end_corner, *parts.rect[11]);
        prim->End();
        ResetMenuScissor();
        SetSpriteEnv(prim, 0);
        put_y = y;
        prim->Begin(6);
        prim->Texture(tex);
        prim->Color(r, g, b, a);
        part = 0;
        for (i = 0; i < 2; i++) {
            put_x = x;
            mgRect<int> row_left((int)put_x, put_top = (int)put_y, 32, 40);
            PrimQuad(prim, row_left, *parts.rect[frmtbl0_2922[part++]]);
            mgRect<int> row_join((int)(put_x + 32.0f), put_top, 8, 40);
            PrimQuad(prim, row_join, *parts.rect[frmtbl0_2922[part++]]);
            put_x += 40.0f;
            for (j = 0; j < 5; j++) {
                mgRect<int> edge((int)put_x, put_top, 40, 40);
                PrimQuad(prim, edge, *parts.rect[frmtbl0_2922[part++]]);
                put_x += 40.0f;
            }
            mgRect<int> row_fill((int)(put_x - 8.0f), put_top, 6, 40);
            PrimQuad(prim, row_fill, *parts.rect[frmtbl0_2922[part - 1]]);
            mgRect<int> row_right((int)(put_x - 2.0f), put_top, 32, 40);
            PrimQuad(prim, row_right, *parts.rect[frmtbl0_2922[part++]]);
            put_y += 250.0f;
        }
        put.right = 32;
        part = 0;
        put_x = x;
        for (i = 0; i < 2; i++) {
            put_y = y + 40;
            int put_left;
            for (j = 0; j < 5; j++) {
                mgRect<int> side(put_left = (int)put_x, (int)put_y, 32, 40);
                PrimQuad(prim, side, *parts.rect[frmtbl1_2938[part++]]);
                put_y += 40.0f;
            }
            mgRect<int> side_end(put_left, (int)put_y, 32, 10);
            PrimQuad(prim, side_end, *parts.rect[frmtbl1_2938[part - 1]]);
            put_x += 238.0f;
        }
        prim->End();
        float bar_x = x + 260;
        scroll_bar_heights heights = at_2949__2;
        heights.height[0] = ItemBoardScrlBar1.bottom;
        heights.height[2] = ItemBoardScrlBar3.bottom;
        scroll_bar_layers layers = at_2950__2;
        layers.layer[0][4] = shadow_alpha;
        layers.layer[1][1] = r;
        layers.layer[1][2] = g;
        layers.layer[1][3] = b;
        layers.layer[1][4] = a;
        scroll_bar_parts bars = at_2951__2;
        prim->Begin(6);
        prim->Texture(tex);
        for (i = 0; i < 2; i++) {
            int *layer = layers.layer[i];
            prim->Color(layer[1], layer[2], layer[3], layer[4]);
            float bar_y = y + 9;
            for (j = 0; j < 3; j++) {
                mgRect<int> *bar = bars.rect[j];
                prim->TextureCrd(bar->left, bar->top);
                prim->Vertex(bar_x + layer[0], bar_y + layer[0], 0.0f);
                prim->TextureCrd(bar->left + bar->right, bar->top + bar->bottom);
                prim->Vertex(bar_x + bar->right + layer[0], bar_y + heights.height[j] + layer[0], 0.0f);
                bar_y += heights.height[j];
            }
        }
        prim->End();
        float bar_top = y + 9 + layers.layer[0][0];
        if (MenuItemBrdScrlBarY < bar_top) {
            MenuItemBrdScrlBarY = bar_top;
        }
        prim->Bilinear(1);
        prim->Begin(6);
        mgRect<float> cursor(8.0f + bar_x, MenuItemBrdScrlBarY, ItemBoardCursor.right, MenuItemBrdScrlCurLen);
        PrimQuad(prim, cursor, ItemBoardCursor);
        prim->End();
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menudraw", MenuItemBrdFrameDraw__FiiRiiiii);
#endif
void MenuItemBrdDraw(float *pos, mgRect<int> clip_rect, int &tex_block, int a, int r, int g, int b) {
    mgCDrawPrim *prim;
    mgCTexture *tex;
    int bottom;
    int last_row;
    int row;
    int col;
    int line_x0;
    int line_x1;
    int line_y;
    mgRect<int> koma;
    mgRect<int> scissor;

    prim = GetMenuPrim();
    koma = MenuItemBrdKomaRect;
    tex = mgTexManager.GetTexture(at_3054, -1);
    if (tex != NULL && !(mgScreenWidth < pos[0])) {
        scissor.left = clip_rect.left;
        scissor.top = clip_rect.top;
        scissor.right = clip_rect.right;
        scissor.bottom = bottom = clip_rect.bottom;
        MenuClipRectCheck(scissor);
        MenuReloadTexture(tex_block, tex->block);
        last_row = GetNowBagMax(0) / 6;
        mgRect<int> put(0, 0, 0, 0);
        SetSpriteEnv(prim, 0);
        prim->Begin(6);
        prim->Texture(tex);
        prim->Color(r, g, b, a);
        prim->Direct(0x40, scissor.left | ((s64)scissor.right << 16) | ((s64)scissor.top << 32) |
                               ((s64)scissor.bottom << 48));
        put.top = (int)pos[1];
        put.right = 40;
        put.bottom = 50;
        mgRect<int> unused(0, 0, 0, 0);
        for (row = 0; row < 26; row++) {
            if (bottom < put.top) {
                break;
            }
            put.left = (int)pos[0];
            for (col = 0; col < 6; col++) {
                if (mgScreenWidth < put.left) {
                    break;
                }
                PrimQuad(prim, put, koma);
                put.left += put.right;
            }
            if (row == last_row && OmakeFlag == 0) {
                prim->End();
                prim->TextureMapEnable(0);
                prim->Bilinear(1);
                prim->Shading(1);
                prim->Begin(6);
                prim->Color(0xDE, 0xDE, 0xDE, a);
                line_x0 = (int)(pos[0] - 2.0f);
                line_x1 = (int)(pos[0] + (float)(put.right * 6));
                line_y = put.top - 1;
                prim->Vertex(line_x0, line_y, 0);
                prim->Vertex(line_x1, line_y + 1, 0);
                prim->End();
                prim->Begin(6);
                prim->Color(0xAC, 0xAC, 0xAC, a * 3 / 5);
                prim->Vertex(line_x0, line_y + 2, 0);
                prim->Vertex(line_x1, line_y + 3, 0);
                prim->End();
                prim->Begin(6);
                prim->Color(0x80, 0x80, 0x80, a / 5);
                prim->Vertex(line_x0, line_y + 4, 0);
                prim->Vertex(line_x1, line_y + 5, 0);
                prim->End();
                prim->TextureMapEnable(1);
                prim->Bilinear(0);
                prim->Shading(0);
                prim->Begin(6);
                prim->Color(r, g, b, a);
            }
            put.top += put.bottom;
        }
        prim->Direct(0x40, ((s64)(mgScreenWidth - 1) << 16) | ((s64)(mgScreenHeight - 1) << 48));
        prim->End();
    }
}
#ifdef NONMATCHING
void MenuItemModeItemDraw(int &tex_block, mgRect<int> clip_rect, float *pos, MENUFORMPARTS_TYPE *parts,
                          mgCTexture *num_tex, mgRect<int> num_rect, int unk) {
    mgCTextureManager *textures;
    mgCTexture *effect_tex;
    int left;
    int y;
    int num_x;
    int num_y;
    int bag_max;
    int row;
    int col;
    int item_flag;
    int num_space;
    int num_unk;
    int num;
    int x;
    int bottom;
    mgCDrawPrim *prim = GetMenuPrim();
    textures = &mgTexManager;
    mgCTexture *icon_tex = MenuPosData->item_icon_tex[0][0];
    mgCTexture *icon_tex2 = MenuPosData->item_icon_tex[0][1];
    if (icon_tex == NULL || icon_tex2 == NULL) {
        return;
    }
    effect_tex = MenuPosData->icon_effect_tex;
    left = (int)(4.0f + pos[0]);
    y = (int)(4.0f + pos[1]);
    mgRect<int> scissor;
    scissor.left = clip_rect.left;
    scissor.top = clip_rect.top;
    scissor.right = clip_rect.right;
    scissor.bottom = bottom = clip_rect.bottom;
    MenuClipRectCheck(scissor);
    mgRect<float> item_rect(0.0f, 0.0f, 0.0f, 0.0f);
    item_rect.right = 32.0f;
    item_rect.bottom = 40.0f;
    mgRect<int> unused(0, 0, 32, 32);
    MenuReloadTexture(tex_block, icon_tex->block);
    SetMenuScissor(scissor);
    bag_max = GetNowBagMax(0);
    int no = 0;
    for (row = 0; row < 25; row++, y += 50) {
        if (y > bottom) {
            break;
        }
        for (col = 0, x = 0; col < 6; x += 40, col++, no++) {
            if (y < -40 || (parts != NULL && parts->draw_flag == 0)) {
                if (parts != NULL) {
                    parts++;
                }
                continue;
            }
            if (no >= MenuDrawItemInfoNum) {
                break;
            }
            item_rect.left = left + x;
            item_rect.top = y;
            CGameDataUsed *used = MenuDrawItemInfo[no];
            int item_no = used->item_no;
            if (mgScreenWidth < item_rect.left || item_no <= 0) {
                if (parts != NULL) {
                    parts++;
                }
                continue;
            }
            num_x = (int)(33.0f + item_rect.left);
            num_y = (int)(26.0f + item_rect.top);
            num = used->GetNum();
            MENU_PARTS_EFFECT_STRUCT1 *effect = NULL;
            u8 *rgba = static_rgba_table_3128;
            item_flag = 0;
            num_space = 0;
            num_unk = 0;
            if (parts != NULL) {
                effect = parts->effect;
                item_flag = parts->item_flag;
                rgba = parts->rgba;
                num_space = (int)(parts->x);
                num_unk = (int)(parts->y);
            }
            int icon_mode = 0;
            if (item_no == 0xB9) {
                item_no = used->GetSpectolNo();
                icon_mode = 1;
            } else if (item_no == 0x1AA) {
                item_no = used->data.item.num;
                icon_mode = 3;
            } else if (used->used_type == USED_ITEM_TYPE_FISH && effect != NULL) {
                float *wait = &MenuPosData->fish_jump_wait[no];
                if (*wait > 0.0f) {
                    *wait -= 1.0f;
                    if (*wait <= 0.0f) {
                        effect[1].param[0] = 0.0f;
                        MenuPosData->fish_jump_height[no] = 3.0f + GetRandF(7.0f);
                        MenuPosData->fish_jump_count[no] = 2;
                    }
                } else {
                    float height = MenuPosData->fish_jump_height[no] *
                                   sinf(effect[1].param[0] * rottbl_3145[MenuPosData->fish_jump_count[no]]);
                    if (height > 0.0f) {
                        item_rect.top -= height;
                    } else {
                        effect[1].param[0] = 0.0f;
                        MenuPosData->fish_jump_height[no] *= 0.4f;
                        MenuPosData->fish_jump_count[no]--;
                        if (MenuPosData->fish_jump_count[no] <= 0) {
                            *wait = 16.0f + GetRandF(12.0f);
                        }
                    }
                }
            } else if (item_no == 0x137) {
                num = GetUserDataMan()->yarikomi_medal;
            }
            if (no < bag_max) {
                DrawOneItem(prim, item_rect, item_no, icon_mode, effect, rgba, item_flag);
                if (num >= 2 || item_no == 0x137) {
                    prim->Begin(6);
                    prim->Texture(num_tex);
                    if (item_no == 0x137) {
                        prim->Color(0xA4, 0xA4, 0x40, rgba[3]);
                    } else if ((s8)menu_limmit_displayflag[no] == 1) {
                        prim->Color(0x52, 0x52, 0x94, rgba[3]);
                    } else {
                        prim->Color(rgba[0], rgba[1], rgba[2], rgba[3]);
                    }
                    PrimDrawNumber(prim, num, 0, num_x, num_y, num_rect, num_space, num_unk);
                    prim->End();
                }
            } else {
                memcpy(localrgba_3166, rgba, 4);
                rgba[0] = fptoui(160.0f + 32.0f * sinf(item_board_counter));
                rgba[1] = 0x40;
                rgba[2] = 0x40;
                if (OmakeFlag == 1) {
                    rgba[0] = 0x80;
                    rgba[1] = 0x80;
                    rgba[2] = 0x80;
                }
                DrawOneItem(prim, item_rect, item_no, icon_mode, effect, rgba, item_flag);
                if (num >= 2 || item_no == 0x137) {
                    prim->Begin(6);
                    prim->Texture(num_tex);
                    prim->Color(rgba[0], rgba[1], rgba[2], rgba[3]);
                    PrimDrawNumber(prim, num, 0, num_x, num_y, num_rect, num_space, num_unk);
                    prim->End();
                }
                memcpy(rgba, localrgba_3166, 4);
            }
            if (icon_mode != 0) {
                if (icon_mode == 1) {
                    DrawItemIconEffect2(prim, effect_tex, parts, item_rect);
                }
                textures->ReloadCLUT(MenuPosData->item_icon_tex[0][use_trans_rect], (sceVif1Packet *)NULL);
            }
            if (parts != NULL) {
                parts++;
            }
        }
    }
    item_board_counter += 0.06829549f;
    if (item_board_counter > 3.1415927f) {
        item_board_counter -= 6.2831855f;
    }
    ResetMenuScissor();
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menudraw", MenuItemModeItemDraw__FRi9mgRect_i_PfP18MENUFORMPARTS_TYPEP10mgCTexture9mgRect_i_i);
#endif
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
int CMenuPosDataForm::CheckMoveEnd() {
    if (action != NULL && action_state == 4) {
        return 1;
    }
    if (x == (float)next_x && y == (float)next_y) {
        return 1;
    }
    return 0;
}
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
#ifdef NONMATCHING
int CMenuPosDataForm::GetNextMovePos(int *pos) {
    int move_type;
    int i;
    int target_pos;
    float rate_now;
    float diff;
    MENU_FORM_ACTION_MOVE *move;
    float rate[2];
    int target[2];

    if (pos == NULL || active == 0) {
        return 1;
    }
    int now[2] = {(int)x, (int)y};
    if (0 <= action_no) {
        move = action[action_no].move;
        move_type = move->mtype;
        rate[0] = move->rate_x;
        rate[1] = move->rate_y;
        target[0] = (int)move->x;
        target[1] = (int)move->y;
    } else {
        move_type = mtype;
        rate[0] = rate_x;
        rate[1] = rate_y;
        target[0] = next_x;
        target[1] = next_y;
    }
    switch (move_type) {
    case MENUFORM_MTYPE_N:
        break;
    case MENUFORM_MTYPE_D:
        now[0] = target[0];
        now[1] = target[1];
        break;
    case MENUFORM_MTYPE_L:
        for (i = 0; i < 2; i++) {
            target_pos = target[i];
            if (target_pos - now[i] < 0) {
                rate[i] = -rate[i];
            }
            rate_now = rate[i];
            now[i] = (int)((float)now[i] + rate_now);
            if (abs(target_pos - now[i]) <= abs((int)rate_now)) {
                now[i] = target_pos;
            }
        }
        break;
    case MENUFORM_MTYPE_I:
    case MENUFORM_MTYPE_IR:
        for (i = 0; i < 2; i++) {
            target_pos = target[i];
            rate_now = rate[i];
            diff = (float)(target_pos - now[i]);
            now[i] = (int)((float)now[i] + diff / rate_now);
            if ((float)abs(target_pos - now[i]) <= rate_now) {
                if (mtype != MENUFORM_MTYPE_IR) {
                    if (diff > 0.0f) {
                        now[i]++;
                    }
                    if (diff < 0.0f) {
                        now[i]--;
                    }
                }
                if ((float)abs((int)diff) < 1.6f) {
                    now[i] = target_pos;
                }
            }
        }
        break;
    }
    pos[0] = now[0];
    pos[1] = now[1];
    return 1;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menudraw", GetNextMovePos__16CMenuPosDataFormFPi);
#endif
void Menu3DivideTextureDraw(mgCDrawPrim *prim, mgRect<int> rect, short *tex_tbl, int vertical) {
    int middle;
    if (vertical == 0) {
        middle = rect.bottom - tex_tbl[3] - tex_tbl[11];
        rect.bottom = tex_tbl[3];
    } else {
        middle = rect.right - tex_tbl[2] - tex_tbl[10];
        rect.right = tex_tbl[2];
    }
    mgRect<int> source(0, 0, 0, 0);
    int size[2][4] = {{tex_tbl[3], middle, tex_tbl[11]}, {tex_tbl[2], middle, tex_tbl[10]}};
    int *step = size[vertical];
    for (int i = 0; i < 3; i++) {
        source.Set(tex_tbl[i << 2], tex_tbl[(i << 2) + 1], tex_tbl[(i << 2) + 2], tex_tbl[(i << 2) + 3]);
        PrimQuad(prim, rect, source);
        if (vertical == 0) {
            rect.top += step[i];
            rect.bottom = step[i + 1];
        } else if (vertical == 1) {
            rect.left += step[i];
            rect.right = step[i + 1];
        }
    }
}
#ifdef NONMATCHING
void CMenuPosDataForm::MenuFormDrawNormal(int x, int y, float sway_x, float sway_y, int &tex_block) {
    mgCTextureManager *textures = &mgTexManager;
    mgCDrawPrim *prim = GetMenuPrim();
    prim->Initialize(NULL, NULL);
    mgRect<float> put(0.0f, 0.0f, 0.0f, 0.0f);
    mgRect<int> uv(0, 0, 0, 0);
    int block = -1;
    MENU_PARTS_EFFECT_STRUCT1 *item_effect = NULL;
    mgCTexture *effect_tex = MenuPosData->icon_effect_tex;
    for (int i = 0; i < parts_num; i++) {
        MENUFORMPARTS_TYPE *part = &parts[i];
        if (part->active == 0 || part->draw_flag == 0 || part->dtype == MENUFORMPARTS_DTYPE_FUNCINFO) {
            continue;
        }
        put.Set(sway_x + part->x, sway_y + part->y, part->w, part->h);
        if (part->vibe_cnt[0] != 0) {
            put.left += (u_int)part->viber[0] * cosf(3.1415927f / part->vibe_cnt[0] * counter);
            put.left = (int)put.left;
        }
        if (part->vibe_cnt[1] != 0) {
            put.top += (u_int)part->viber[1] * sinf(3.1415927f / part->vibe_cnt[1] * counter);
            put.top = (int)put.top;
        }
        if (part->dtype == MENUFORMPARTS_DTYPE_CURSOR) {
            menu_cursor_pos cursor = at_3428;
            cursor.pos[0] = put.left;
            cursor.pos[1] = put.top;
            mgCTexture *cursor_tex = textures->GetTexture(at_2238, -1);
            if (cursor_tex != NULL) {
                MenuReloadTexture(tex_block, cursor_tex->block);
                MenuCursorDraw(cursor_tex, cursor.pos, menu_cursor_rotation_angle, MenuCursorReverseFlag, rgba[3], 1.0f);
            }
            continue;
        }
        if (part->dtype == MENUFORMPARTS_DTYPE_CLUT_RELOAD) {
            MenuReloadCLUT(part->etc_info[0]);
            continue;
        }
        mgCTexture *tex = part->tex;
        u8 dtype = part->dtype;
        MENU_BASETEXINFO *info = MenuPosData->GetTexGetInfo(part->tex_info_no);
        if (dtype != MENUFORMPARTS_DTYPE_SQ_BETA && dtype != MENUFORMPARTS_DTYPE_FONT && tex == NULL) {
            continue;
        }
        if (tex != NULL) {
            block = tex->block;
        }
        if (dtype != MENUFORMPARTS_DTYPE_NETA && dtype != MENUFORMPARTS_DTYPE_SQ_BETA && dtype != MENUFORMPARTS_DTYPE_TRS &&
            dtype != MENUFORMPARTS_DTYPE_IDEA_BOARD && dtype != MENUFORMPARTS_DTYPE_FONT) {
            MenuReloadTexture(tex_block, block);
        }
        if (part->dtype < MENUFORMPARTS_DTYPE_BG || part->dtype >= MENUFORMPARTS_DTYPE_NETA) {
            SetSpriteEnv(prim, 0);
        }
        prim->AlphaBlend(part->alpha_blend);
        if (part->bilinear & 1) {
            prim->Bilinear(1);
        } else {
            prim->Bilinear(0);
        }
        u8 color[4];
        for (int channel = 0; channel < 4; channel++) {
            color[channel] = part->rgba[channel];
            if (rgba_bit & (1 << channel)) {
                color[channel] = rgba[channel];
            }
        }
        ConvMGFRECTtoFLOATtbl(put, putpostbl_3410);
        GetNowPosRGBA(part, info, putpostbl_3410, color);
        if (rgba[3] == 0) {
            color[3] = 0;
        }
        uv = info->rect;
        ConvMGIRECTtoINTtbl(uv, getpostbl_3411);
        switch (part->dtype) {
            case MENUFORMPARTS_DTYPE_NORMAL: {
                s8 repeat = part->effect != NULL;
                u8 *prim_type = menu_prim_tbl[repeat];
                prim->Begin(prim_type[0]);
                prim->Texture(tex);
                if (part->shadow != 0) {
                    prim->Color(0, 0, 0, color[3] / 3);
                    if (repeat == 0) {
                        s8 offset = part->shadow_offset;
                        mgRect<int> shadow((int)(put.left + offset), (int)(put.top + offset), (int)put.right, (int)put.bottom);
                        PrimQuad(prim, shadow, uv);
                    }
                }
                prim->Color(color[0], color[1], color[2], color[3]);
                if (repeat == 0) {
                    PrimQuad(prim, put, uv);
                } else if (repeat == 1) {
                    PushPrimRepeat(prim, putpostbl_3410, getpostbl_3411, prim_type[1]);
                }
                prim->End();
                break;
            }
            case MENUFORMPARTS_DTYPE_NORMAL2:
                prim->Begin(4);
                prim->Texture(tex);
                prim->Color(color[0], color[1], color[2], color[3]);
                prim->TextureCrd(uv.left, uv.top);
                prim->Vertex(put.left, put.top, 0.0f);
                prim->TextureCrd(uv.left + uv.right, uv.top);
                prim->Vertex(put.left + put.right, put.top, 0.0f);
                put.left += part->etc_info[0];
                prim->TextureCrd(uv.left, uv.top + uv.bottom);
                prim->Vertex(put.left, put.top + put.bottom, 0.0f);
                prim->TextureCrd(uv.left + uv.right, uv.top + uv.bottom);
                prim->Vertex(put.left + put.right, put.top + put.bottom, 0.0f);
                prim->End();
                break;
            case MENUFORMPARTS_DTYPE_NUMBER1:
            case MENUFORMPARTS_DTYPE_NUMBER2:
                if (part->etc_info[2] == 1 ? part->etc_info[1] >= 2 : part->etc_info[1] >= 0) {
                    uv = info->rect;
                    prim->Bilinear(0);
                    prim->Begin(6);
                    prim->Texture(tex);
                    if (part->shadow != 0) {
                        s8 offset = part->shadow_offset;
                        int shadow_x = (int)(put.left + offset);
                        int shadow_y = (int)(put.top + offset);
                        prim->Color(0, 0, 0, color[3] / 3);
                        if (part->dtype == MENUFORMPARTS_DTYPE_NUMBER1) {
                            PrimDrawNumber(prim, part->etc_info[1], part->etc_info[0], shadow_x, shadow_y, uv, (int)part->w,
                                           (int)part->h);
                        } else if (part->dtype == MENUFORMPARTS_DTYPE_NUMBER2) {
                            PrimDrawNumber2(prim, part->etc_info[1], part->etc_info[0], shadow_x, shadow_y, uv, (int)part->w,
                                            (int)part->h);
                        }
                    }
                    prim->Color(color[0], color[1], color[2], color[3]);
                    if (part->dtype == MENUFORMPARTS_DTYPE_NUMBER1) {
                        PrimDrawNumber(prim, part->etc_info[1], part->etc_info[0], (int)put.left, (int)put.top, uv,
                                       (int)part->w, (int)part->h);
                    } else if (part->dtype == MENUFORMPARTS_DTYPE_NUMBER2) {
                        PrimDrawNumber2(prim, part->etc_info[1], part->etc_info[0], (int)put.left, (int)put.top, uv,
                                        (int)part->w, (int)part->h);
                    }
                    prim->End();
                }
                break;
            case MENUFORMPARTS_DTYPE_WAKU_RECT:
                put.right = part->w;
                put.bottom = part->h;
                DrawMenuWakuRect(tex, put, uv, color[3], color[0], color[1], color[2]);
                break;
            case MENUFORMPARTS_DTYPE_WAKU_CIRCLE:
                put.right = part->w;
                put.bottom = part->h;
                DrawWakuCircle(prim, tex, put, uv, MenuWakuRotCnt, put.right, color[3], color[0], color[1], color[2]);
                break;
            case MENUFORMPARTS_DTYPE_BG:
            case MENUFORMPARTS_DTYPE_BETA:
                MenuFrameImageDraw(prim, tex, put, uv, color[0], color[3], part->dtype);
                break;
            case MENUFORMPARTS_DTYPE_TRS: {
                int item = part->etc_info[1];
                if (item > 0) {
                    MenuReloadTexture(tex_block, MenuItemIconTextureBlock);
                    int icon_item = item;
                    int icon_mode = 0;
                    if (item == 0xB9) {
                        icon_item = part->etc_info[2];
                        icon_mode = 1;
                        item_effect = part->effect;
                    }
                    if (item == 0x1AA) {
                        icon_item = part->etc_info[2];
                        icon_mode = 3;
                    }
                    DrawOneItem(prim, put, icon_item, icon_mode, item_effect, color, part->item_flag);
                    if (icon_mode != 0) {
                        if (icon_mode == 1) {
                            DrawItemIconEffect2(prim, effect_tex, part, put);
                        }
                        textures->ReloadCLUT(MenuPosData->item_icon_tex[0][use_trans_rect], (sceVif1Packet *)NULL);
                    }
                }
                break;
            }
            case MENUFORMPARTS_DTYPE_NETA:
                PictureDraw(tex_block, put, part->etc_info[0], part->unk_2c, color);
                break;
            case MENUFORMPARTS_DTYPE_IDEA_BOARD:
                MenuInventPictureBoardDraw(&this->x, tex_block, color[3]);
                break;
            case MENUFORMPARTS_DTYPE_ALBUM:
                MenuInventAlbumPictureDraw(&this->x, tex_block);
                break;
            case MENUFORMPARTS_DTYPE_SQ_BETA: {
                SetSpriteEnv(prim, 1);
                float alpha_rate = 1.0f;
                if (rgba_bit & 8) {
                    prim->DepthTestEnable(0);
                    alpha_rate = (u_int)color[3] / 128.0f;
                }
                float *top_left;
                float *top_right;
                float *bottom_left;
                float *bottom_right;
                switch (part->etc_info[0]) {
                    case 0: {
                        top_left = top_right = bottom_left = bottom_right = part->effect->param;
                        prim->Begin(6);
                        float *fill = part->effect->param;
                        prim->Color((int)fill[0], (int)fill[1], (int)fill[2], (int)(fill[3] * alpha_rate));
                        prim->Vertex(put.left, put.top, 0.0f);
                        prim->Vertex(put.left + put.right, put.top + put.bottom, 0.0f);
                        break;
                    }
                    case 1:
                        top_left = top_right = part->effect[0].param;
                        bottom_left = bottom_right = part->effect[1].param;
                        prim->Begin(4);
                        PrimFillRect4(prim, put, top_left, top_right, bottom_left, bottom_right);
                        break;
                    case 2:
                        top_left = bottom_left = part->effect[0].param;
                        top_right = bottom_right = part->effect[1].param;
                        prim->Begin(4);
                        PrimFillRect4(prim, put, top_left, top_right, bottom_left, bottom_right);
                        break;
                    case 3:
                        top_left = part->effect[0].param;
                        bottom_left = part->effect[1].param;
                        top_right = part->effect[2].param;
                        bottom_right = part->effect[3].param;
                        prim->Begin(4);
                        PrimFillRect4(prim, put, top_left, top_right, bottom_left, bottom_right);
                        break;
                }
                prim->End();
                if (rgba_bit & 8) {
                    top_left[3] = color[3];
                    bottom_left[3] = color[3];
                    top_right[3] = color[3];
                    bottom_right[3] = color[3];
                }
                break;
            }
            case MENUFORMPARTS_DTYPE_RANDOM_LINE: {
                menu_line_origin origin = at_3527;
                origin.pos[0] = (int)put.left;
                origin.pos[1] = (int)put.top;
                if (counter % 2 == 0) {
                    GenarateRandamLine(origin.pos, (int)part->w, (int)part->h, menu_randam_line_draw_postbl, 50, 0);
                }
                DrawRandamLine(prim, menu_randam_line_draw_postbl, 10, 50, color);
                break;
            }
            case MENUFORMPARTS_DTYPE_IDEA_MEMO: {
                menu_memo_pos memo = at_3531;
                memo.pos[0] = sway_x;
                memo.pos[1] = sway_y;
                MenuInventNetaMemoDraw(memo.pos, tex_block);
                break;
            }
        }
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menudraw", MenuFormDrawNormal__16CMenuPosDataFormFiiffRi);
#endif
void CMenuPosDataForm::MenuFormDraw(int x, int y, int &tex_block) {
    if (active == 0 || draw_flag == 0) {
        return;
    }
    float draw_x = x;
    float draw_y = y;
    if (vibe_cnt[0] != 0) {
        draw_x += 10.0f * cosf(3.1415927f / vibe_cnt[0] * counter);
    }
    if (vibe_cnt[1] != 0) {
        draw_y += 8.0f * sinf(3.1415927f / vibe_cnt[1] * counter);
    }
    mgCTextureManager *textures = &mgTexManager;
    mgCDrawPrim *prim = GetMenuPrim();
    u8 type = dtype;
    if (type == MENUFORM_DTYPE_NORMAL || type == MENUFORM_DTYPE_LIST) {
        MenuFormDrawNormal(x, y, draw_x, draw_y, tex_block);
    } else if (type == MENUFORM_DTYPE_MSGFORM) {
        CDC2Mes *mes = MenuDCMsg[sub_no];
        int texture_block = mes->texture_block;
        if (rgba[3] > 0) {
            MenuReloadTexture(tex_block, texture_block);

            mes->StepMsg();
            menu_put_pos put = at_3612;
            put.pos[0] = (int)(draw_x);
            put.pos[1] = (int)(draw_y);
            mes->SetPutPos(put.pos);
            mes->SetMsgAlpha(rgba[3]);
            mes->DrawMsg();
        }
    } else if (type == MENUFORM_DTYPE_MAINFRM) {
        MenuMainFrameDraw(tex_block, 0x80);
    } else if (type == MENUFORM_DTYPE_MAINIMG) {
        MenuMainFrameImgDraw(tex_block);
    } else if (type == MENUFORM_DTYPE_ITEMBRD) {
        float board_y = 20.0f + draw_y;
        float board_x = 16.0f + draw_x;
        int clip_left = (int)(board_x);
        int clip_top = (int)(board_y - 2.0f);
        int clip_right = (int)(board_x + 240.0f + 5.0f);
        mgRect<int> clip(clip_left, clip_top, clip_right, (int)(board_y + 250.0f + 2.0f));
        if (mgScreenWidth > draw_x && clip.bottom > 0) {
            MENU_BASETEXINFO *num_info = MenuPosData->GetTexGetInfo(at_3721);
            mgCTexture *num_tex = textures->GetTexture(at_2238, -1);
            mgRect<int> num_rect = num_info->rect;
            MenuItemBrdUnderBrdPosXY[0] = board_x;
            MenuItemBrdDraw(MenuItemBrdUnderBrdPosXY, clip, tex_block, 0x80, 0x80, 0x80, 0x80);
            MenuItemModeItemDraw(tex_block, clip, MenuItemBrdUnderBrdPosXY, parts, num_tex, num_rect, 0);
            MenuItemBrdFrameDraw((int)(draw_x), (int)(draw_y), tex_block, rgba[3], rgba[0], rgba[1], rgba[2]);
        }
    } else if (type == MENUFORM_DTYPE_GIFTVIEW) {
        mgCTexture *board_tex = textures->GetTexture(at_1780, -1);
        mgCTexture *cursor_tex = textures->GetTexture(at_2238, -1);
        if (board_tex != NULL) {
            MenuPresentBoxView((int)(draw_x), (int)(draw_y), tex_block, board_tex, cursor_tex);
        }
    } else if (type == MENUFORM_DTYPE_POLY) {
        if (counter >= 15 && chara != NULL) {
            float saved_ambient[4];
            mgGetAmbient(saved_ambient);
            if (0.0f <= ambient[0]) {
                mgSetAmbient(ambient);
            }
            if (chara_tex_block > 0) {
                MenuReloadTexture(tex_block, chara_tex_block);
                chara->DrawDirect();
                if (GetNowLoopNo() == 2 && FxScriptMan != NULL) {
                    FxScriptMan->PauseFromLevel(3, 2);
                    FxScriptMan->PauseFromLevel(1, 2);
                    chara->DrawEffect();
                    FxScriptMan->PauseFromLevel(3, 0);
                    FxScriptMan->PauseFromLevel(1, 0);
                }
            } else if (chara->GetFrame() != NULL) {
                mgDrawDirect(chara->GetFrame());
            }
            mgSetAmbient(saved_ambient);
        }
    } else if (type == MENUFORM_DTYPE_CREATEBRD) {
        menu_board_pos pos = at_3651;
        pos.pos[0] = x;
        pos.pos[1] = y;
        CommonBoardDraw(pos.pos, tex_block);
    } else if (type == MENUFORM_DTYPE_MAPPART) {
        MenuMapPartsDraw(tex_block);
    } else if (type == MENUFORM_DTYPE_BG_TILE) {
        MENU_BASETEXINFO *info = MenuPosData->GetTexGetInfo(parts->tex_info_no);
        mgCTexture *tex = textures->GetTexture(info->tex_name, info->tex_block);
        MenuReloadTexture(tex_block, info->tex_block);
        menu_tile_color color = at_3658;
        color.rgba[3] = rgba[3];
        DrawMenuTilePattern(prim, tex, this->x, this->y, info->rect, 0, color.rgba);
    } else if (type == MENUFORM_DTYPE_CHRSTAR) {
        MenuCharaChangeStarDraw();
    } else if (type == MENUFORM_DTYPE_INV_CARD) {
        MenuInventCreateCardDraw(tex_block, &this->x);
    } else if (type == MENUFORM_DTYPE_GEOLIST) {
        MenuGeoramaListDraw(tex_block, &this->x, sub_no, rgba[3]);
    } else if (type == MENUFORM_DTYPE_GEOTITLE) {
        MenuGeoramaTitleDraw(tex_block, &this->x, rgba[3]);
    } else if (type == MENUFORM_DTYPE_GEOANA) {
        MenuGeoramaAnalyzeDraw(tex_block, &this->x, rgba[3]);
    } else if (type == MENUFORM_DTYPE_HOUSE) {
        MenuPlacedHouseDraw(tex_block);
    } else if (type == MENUFORM_DTYPE_SHOPLIST) {
        ShopSellListDraw(tex_block, &this->x);
    } else if (type == MENUFORM_DTYPE_SAVELIST) {
        SaveFileListDraw(tex_block, &this->x, rgba[3]);
    } else if (type == MENUFORM_DTYPE_INFOCUR) {
        MenuItemInfoCursorDraw(tex_block);
        MenuCharaStatusDraw(tex_block);
    } else if (type == MENUFORM_DTYPE_DLOAD) {
        int dl_x = (int)(this->x);
        DrawMenuDl(tex_block, dl_x, (int)(this->y), dl_x, rgba[3]);
    } else if (type == MENUFORM_DTYPE_CLIP) {
        float top;
        float left = this->x;
        top = this->y;
        int clip_left = (int)(left);
        int clip_top = (int)(top);
        int clip_right = (int)(left + clip_w);
        mgRect<int> clip(clip_left, clip_top, clip_right, (int)(top + clip_h));
        MenuClipRectCheck(clip);
        SetMenuScissor(clip);
    } else if (type == MENUFORM_DTYPE_BUILDUP) {
        MenuWeaponBuildUpDraw(tex_block);
    }
}
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
int CMenuPosDataManage::StepMainMenuIconMove(int *icons, int select, int mode) {
    int arrived = 0;
    int count = 0;
    int language = 0;
    int slot;
    int i;
    CMenuPosDataForm *form;
    int j;
    int icon;
    short (*act_offset)[2];
    int highlight;

    if (LanguageCode > 0) {
        language = 1;
    }
    if (CheckNowEurope() != 0) {
        language = 2;
    }
    act_offset = actposoffsettbl1_4195[language];
    slot = 0;
    for (i = 0; (icon = icons[i]) >= 0 && count < 19; i++, count++) {
        form = GetFormInfo((char *)GetMenuMainIconChar(icon));
        if (form != NULL) {
            icon_move_pos target = at_4205;
            if (mode == 0) {
                target.pos[0] = (int)((float)baseposoffset_tbl_4194[icon][0] +
                               (170.0f - 110.0f * sinf(0.44879895f + 0.35298797f * (float)slot)));
            } else if (mode == 1 || mode == 2 || mode == 3) {
                target.pos[0] = basepos_4190[0] + farleft_4191[0];
            }
            target.pos[1] = basepos_4190[1] + xyoffset_4192[1] * slot;
            highlight = 1;
            if (select >= 0 && select == icon && (mode == 2 || mode == 3)) {
                target.pos[0] = actpos_4193[0] + act_offset[icon][0];
                target.pos[1] = actpos_4193[1] + act_offset[icon][1];
                highlight = 0;
            }
            form->rgba[0] = 0xA0;
            form->rgba[1] = 0xA0;
            form->rgba[2] = 0xA0;
            form->rgba[3] = 0x80;
            for (j = 0; j < 4; j++) {
                form->SetRGBACalcParam(j, 0, 0x80);
            }
            form->rgba_bit = 0;
            if (select == icon && highlight != 0) {
                form->rgba_bit = 7;
            }
            form->SetNextMovePos(target.pos, 2);
            form->draw_flag = 1;
            if (form->CheckMoveEnd(target.pos[0], target.pos[1]) != 0) {
                arrived++;
            }
            slot++;
        }
    }
    if (arrived >= count - 1) {
        return 1;
    }
    return 0;
}
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
#ifdef NONMATCHING
void Func_MenuItemBrdPosStep(int top_line) {
    int pos[2] = {0, 24};
    CMenuPosDataForm *form = MenuPosData->GetFormInfo(at_4453);
    if (form != NULL) {
        form->GetPutPosXY(NULL, pos[0], pos[1]);
    }
    MenuItemBrdUnderBrdPosXY[0] = pos[0] + 16;
    MenuItemBrdUnderBrdPosY_Next = pos[1] + 26;
    MenuItemBrdUnderBrdPosY_Next -= 50.0f * top_line;
    if (MenuItemBrdCalcManner == 0) {
        CalcMenu1(MenuItemBrdUnderBrdPosY_Next, &MenuItemBrdUnderBrdPosXY[1], 4.0f, 2.0f, 0);
    }
    if (MenuItemBrdCalcManner == 1) {
        MenuItemBrdUnderBrdPosXY[1] = MenuItemBrdUnderBrdPosY_Next;
    }
    MenuItemBrdScrlBarStep(top_line, pos[1] + 18, MenuItemBrdCalcManner);
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menudraw", Func_MenuItemBrdPosStep__Fi);
#endif
void CMenuPosDataManage::GetPosMenuItemBrdKoma(int *position, int item_index, int clip) {
    CMenuPosDataForm *form = GetFormInfo(at_4453);
    if (form != NULL) {
        form->GetNextMovePos(position);
        position[0] += (item_index % 6) * 40 + 16;
        int minimum_y = position[1] + 20;
        int maximum_y = position[1] + 270;
        position[1] = (int)(MenuItemBrdUnderBrdPosY_Next + (float)((item_index / 6) * 50));
        if (clip != 0) {
            if (position[1] < minimum_y) {
                position[1] = minimum_y;
            }
            if (maximum_y < position[1]) {
                position[1] = maximum_y;
            }
        }
    }
}
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
void Func_MenuItemIconSetEffectOne(MENUFORMPARTS_TYPE *part) {
    int i;
    if (part == NULL) {
        return;
    }
    if (part->effect == NULL) {
        return;
    }
    short first[10] = {GetRandI(20), 160, 16, 20, 0, 120};
    SetPartEffectInfoRandFunc(part->effect, first, 8);
    part->effect[0].type = MENU_PARTS_EFFECT_UNK_100;
    part->effect[0].active = 1;
    part->effect[0].repeat = 1;
    short second[10] = {GetRandI(30), 160, 16, 20, 0, 120};
    SetPartEffectInfoRandFunc(&part->effect[1], second, 8);
    part->effect[1].type = MENU_PARTS_EFFECT_UNK_100;
    part->effect[1].active = 1;
    part->effect[1].repeat = 1;
    short sparkle[10] = {0};
    for (i = 2; i < 8; i++) {
        Func_SetPartEffectInfo(&part->effect[i], MENU_PARTS_EFFECT_UNK_9, sparkle);
        part->effect[i].active = 1;
        part->effect[i].repeat = 1;
    }
}
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
#ifdef NONMATCHING
void CMenuPosDataManage::MallocPallet(mgCMemory *stack) {
    int i;
    int j;
    int k;
    int grey;
    u8 *color;

    stack->Align64();
    texture_pair icon_tex = at_4526;
    mgTexManager.ReloadTexture(-1, (sceVif1Packet *)NULL);
    mgTexManager.ReloadTexture(MenuItemIconTextureBlock, (sceVif1Packet *)NULL);
    icon_tex.tex[0] = item_icon_tex[0][0];
    icon_tex.tex[1] = item_icon_tex[0][1];
    if (icon_tex.tex[0] != NULL) {
        for (i = 0; i < 2; i++) {
            pallet[0][i] = stack->Alloc(0x40);
            pallet[1][i] = stack->Alloc(0x40);
            pallet[2][i] = stack->Alloc(0x40);
            memcpy(pallet[0][i], icon_tex.tex[i]->clut, 0x400);
            memcpy(pallet[1][i], icon_tex.tex[i]->clut, 0x400);
            memcpy(pallet[2][i], icon_tex.tex[i]->clut, 0x400);
            item_icon_tex[1][i] = new (stack->Alloc(9)) mgCTexture;
            item_icon_tex[2][i] = new (stack->Alloc(9)) mgCTexture;
            item_icon_tex[3][i] = new (stack->Alloc(9)) mgCTexture;
            memcpy(item_icon_tex[1][i], icon_tex.tex[i], sizeof(mgCTexture));
            memcpy(item_icon_tex[2][i], icon_tex.tex[i], sizeof(mgCTexture));
            memcpy(item_icon_tex[3][i], icon_tex.tex[i], sizeof(mgCTexture));
            color = (u8 *)pallet[0][i];
            for (j = 0; j < 256; j++, color += 4) {
                if ((color[0] + color[1] + color[2]) / 3 >= 9 && color[2] != 0) {
                    color[2] = 0xFF;
                }
            }
            item_icon_tex[1][i]->clut = pallet[0][i];
            color = (u8 *)pallet[1][i];
            for (j = 0; j < 256; j++, color += 4) {
                grey = (color[0] + color[1] + color[2]) / 3;
                for (k = 1; k < 17; k++) {
                    if (grey >= (k - 1) * 16 && grey < k * 16) {
                        color[0] = (k - 1) * 16;
                        color[1] = (k - 1) * 16;
                        color[2] = (k - 1) * 16;
                        break;
                    }
                }
            }
            item_icon_tex[2][i]->clut = pallet[1][i];
            color = (u8 *)pallet[2][i];
            for (j = 0; j < 256; j++, color += 4) {
                grey = (color[0] + color[1] + color[2]) / 3;
                for (k = 1; k < 17; k++) {
                    if (grey >= (k - 1) * 16 && grey < k * 16) {
                        color[0] = 30.0f + 12.2f * k;
                        color[1] = 20.0f + 8.75f * k;
                        color[2] = 20.0f + 6.75f * k;
                        break;
                    }
                }
            }
            item_icon_tex[3][i]->clut = pallet[2][i];
        }
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menudraw", MallocPallet__18CMenuPosDataManageFP9mgCMemory);
#endif
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
    memset(fish_jump_wait, 0, sizeof(fish_jump_wait));
    memset(fish_jump_height, 0, sizeof(fish_jump_height));
    memset(fish_jump_count, 2, sizeof(fish_jump_count));
}
#ifdef NONMATCHING
int MenuCapture(int block, mgCMemory *stack, int draw) {
    int half_w;
    int half_h;
    int tex_w;
    int tex_h;
    int pad_w;
    int pad_h;
    u8 *dst;
    u8 *src;
    u8 *line;
    u8 *below;
    int screen_w;
    int line_num;
    int pixel_num;
    int x;
    int y;
    int r;
    int g;
    int b;
    mgCDrawPrim *prim;
    mgCTextureManager *tex_manager;

    stack->Align64();
    tex_manager = &mgTexManager;
    dst = stack->stack_bytes + (stack->stack_used << 4);
    half_w = mgScreenWidth >> 1;
    half_h = mgScreenHeight >> 1;
    tex_w = half_w;
    MenuBGTextureBlock = block;
    tex_h = half_h;
    pad_w = half_w % 64;
    pad_h = half_h % 64;
    if (pad_w != 0) {
        tex_w += 64 - pad_w;
    }
    if (pad_h != 0) {
        tex_h += 64 - pad_h;
    }
    tex_manager->DeleteBlock(block);
    MenuFrameTex = tex_manager->EnterTexture(block, at_4182, NULL, tex_w, tex_h, 32, NULL, 0, 0);
    if (MenuFrameTex != NULL) {
        MenuFrameTex->tex0.bits.tcc = 0;
        MenuFrameTex->image[0] = (u_long128 *)dst;
        stack->Alloc(half_w * half_h * 4 / 16 + 1);
    }
    mgCTexture frame;
    mgGetFrameBuffer(&frame);
    mgEndFrame(NULL);
    mgBeginFrame(NULL);
    stack->Align64();
    src = stack->stack_bytes + (stack->stack_used << 4);
    mgStoreImage(&frame, (u_long128 *)src);
    screen_w = mgScreenWidth;
    line_num = mgScreenHeight >> 1;
    pixel_num = screen_w >> 1;
    for (y = 0; y < line_num; y++) {
        line = src;
        for (x = 0; x < pixel_num; x++) {
            below = line + screen_w * 4;
            r = 0;
            g = 0;
            b = 0;
            r += line[0];
            g += line[1];
            b += line[2];
            r += below[0];
            g += below[1];
            b += below[2];
            r += below[4];
            g += below[5];
            b += below[6];
            r += line[4];
            g += line[5];
            b += line[6];
            line += 8;
            dst[0] = r >> 2;
            dst[1] = g >> 2;
            dst[2] = b >> 2;
            dst[3] = 0x80;
            dst += 4;
        }
        src += screen_w * 8;
    }
    if (draw != 0 && MenuFrameTex != NULL) {
        tex_manager->ReloadTexture(block, (sceVif1Packet *)NULL);
        prim = GetMenuPrim();
        prim->Initialize(NULL, NULL);
        prim->TextureMapEnable(1);
        prim->Bilinear(1);
        prim->AlphaTestEnable(0);
        prim->DepthTestEnable(0);
        prim->ZMask(-1);
        prim->Begin(6);
        prim->Texture(MenuFrameTex);
        prim->Color(0x80, 0x80, 0x80, 0x80);
        prim->TextureCrd(0, 0);
        prim->Vertex(0, 0, 0);
        prim->TextureCrd(half_w, half_h);
        prim->Vertex(mgScreenWidth, mgScreenHeight, 0);
        prim->End();
    }
    return 1;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menudraw", MenuCapture__FiP9mgCMemoryi);
#endif
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
#ifdef NONMATCHING
static void MenuFrameImageDraw(mgCDrawPrim *prim, mgCTexture *tex, mgRect<float> rect, mgRect<int> tex_rect, int gray,
                               int alpha, int dtype) {
    int prim_type;
    int env;

    if (tex != NULL && prim != NULL) {
        prim_type = 6;
        env = 6;
        if (dtype == MENUFORMPARTS_DTYPE_BG) {
            env = 5;
        }
        if (dtype == MENUFORMPARTS_DTYPE_FADE_TOP || dtype == MENUFORMPARTS_DTYPE_FADE_BOTTOM ||
            dtype == MENUFORMPARTS_DTYPE_FADE_RIGHT || dtype == MENUFORMPARTS_DTYPE_FADE_LEFT) {
            prim_type = 4;
            env = 6;
        }
        SetSpriteEnv(prim, env);
        prim->Bilinear(1);
        prim->Begin(prim_type);
        prim->Texture(tex);
        u8 top_left[4] = {gray, gray, gray, alpha};
        u8 top_right[4] = {gray, gray, gray, alpha};
        u8 bottom_left[4] = {gray, gray, gray, alpha};
        u8 bottom_right[4] = {gray, gray, gray, alpha};
        if (dtype == MENUFORMPARTS_DTYPE_BG || dtype == MENUFORMPARTS_DTYPE_BETA) {
            prim->Color(gray, gray, gray, alpha);
            PrimQuad(prim, rect, tex_rect);
        } else {
            if (dtype == MENUFORMPARTS_DTYPE_FADE_TOP) {
                top_right[3] = 0;
                top_left[3] = 0;
            } else if (dtype == MENUFORMPARTS_DTYPE_FADE_BOTTOM) {
                bottom_right[3] = 0;
                bottom_left[3] = 0;
            } else if (dtype == MENUFORMPARTS_DTYPE_FADE_RIGHT) {
                bottom_right[3] = 0;
                top_right[3] = 0;
            } else if (dtype == MENUFORMPARTS_DTYPE_FADE_LEFT) {
                bottom_left[3] = 0;
                top_left[3] = 0;
            }
            prim->Color(top_left[0], top_left[1], top_left[2], top_left[3]);
            prim->TextureCrd(tex_rect.left, tex_rect.top);
            prim->Vertex(rect.left, rect.top, 0.0f);
            prim->Color(top_right[0], top_right[1], top_right[2], top_right[3]);
            prim->TextureCrd(tex_rect.left + tex_rect.right, tex_rect.top);
            prim->Vertex(rect.left + rect.right, rect.top, 0.0f);
            prim->Color(bottom_left[0], bottom_left[1], bottom_left[2], bottom_left[3]);
            prim->TextureCrd(tex_rect.left, tex_rect.top + tex_rect.bottom);
            prim->Vertex(rect.left, rect.top + rect.bottom, 0.0f);
            prim->Color(bottom_right[0], bottom_right[1], bottom_right[2], bottom_right[3]);
            prim->TextureCrd(tex_rect.left + tex_rect.right, tex_rect.top + tex_rect.bottom);
            prim->Vertex(rect.left + rect.right, rect.top + rect.bottom, 0.0f);
        }
        prim->End();
        tex->Bilinear(0);
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menudraw", MenuFrameImageDraw__FP11mgCDrawPrimP10mgCTexture9mgRect_f_9mgRect_i_iii);
#endif
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
void CRepairEffect::Draw() {
    mgCDrawPrim *prim;
    int i;
    REPAIR_EFFECT_PARTICLE *p;

    if (active != 0 && tex != NULL) {
        prim = GetMenuPrim();
        SetSpriteEnv(prim, 4);
        prim->Begin(6);
        prim->Texture(tex);
        prim->Color(0xC4, 0xC4, 0x80, alpha);
        prim->TextureCrd(0x40, 0);
        prim->Vertex(x, y, 0);
        prim->TextureCrd(0x60, 0x20);
        prim->Vertex(x + 0x28, y + 0x2C, 0);
        prim->End();
        prim->AlphaBlendEnable(1);
        prim->AlphaBlend(2);
        prim->Bilinear(1);
        prim->Begin(6);
        prim->Texture(tex);
        for (i = 0; i < particle_num; i++) {
            p = &particle[i];
            if (p->active != 0) {
                prim->Color(0xA4, 0xA4, 0x6E, (int)p->alpha);
                prim->TextureCrd(0, 0x20);
                prim->Vertex(p->x, p->y, 0.0f);
                prim->TextureCrd(8, 0x28);
                prim->Vertex(p->x + 8.0f, p->y + 8.0f, 0.0f);
            }
        }
        prim->End();
    }
}
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
extern void *__vt__9mgCObject[];
extern void *__vt__7CObject[];
extern void *__vt__12CObjectFrame[];
extern void *__vt__11CCharacter2[];
extern void *__vt__12CActionChara[];
extern "C" void *__ct__10CRunScriptFv(void *);

void CRepairManager::GeneratePoly(float *pos, int block) {
    int pack_size;
    unsigned int *pack;
    mgCFrame *frame;
    mgCFrameAttr *attr;
    CActionChara *chara;

    pack = (unsigned int *)GetPackFile(data, at_4933, &pack_size);
    model_stack.stack_used = 0;
    model_stack.lock = 0;
    if ((chara = (CActionChara *)operator new(sizeof(CActionChara), model_stack.Alloc(0x105))) != NULL) {
        *(void **)chara = __vt__9mgCObject;
        ((mgCObject *)chara)->Initialize();
        *(void **)chara = __vt__7CObject;
        ((mgCObject *)chara)->Initialize();
        *(void **)chara = __vt__12CObjectFrame;
        ((mgCObject *)chara)->Initialize();
        *(void **)chara = __vt__11CCharacter2;
        chara->shadow_link.num = 0;
        chara->shadow_link.dst_frame = 0;
        chara->shadow_link.src_frame = 0;
        ((mgCObject *)chara)->Initialize();
        *(void **)chara = __vt__12CActionChara;
        __ct__10CRunScriptFv(&chara->script);
        memset(&chara->move_check, 0, sizeof(chara->move_check));
    }
    model = chara;
    model->Initialize(NULL);
    model->LoadPack(pack, at_4934, &model_stack, &model_stack, &model_stack, block, NULL);
    model->SetScale(0.4f, 0.4f, 0.4f);
    model->SetPosition(pos);
    model->SetMotion(at_4935, 0, 1);
    model->SetFadeFlag(1);
    model->Show(0, 1);
    frame = model->CObjectFrame::frame;
    if (frame != NULL && (attr = frame->attr) != NULL) {
        attr->z_test = -1;
        frame->SetAttrParam(*attr, 1, 0x10);
    }
    model->Show(1, 1);
    model_counter = 0;
}
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
void CRepairManager::Step() {
    float angle;
    float scale;
    int i;

    if (model != NULL) {
        angle = 0.043633234f * model_counter;
        scale = 0.4f + 0.6f * sinf(angle);
        model->SetScale(scale, scale, scale);
        model->Step();
        if (scale < 0.46f && 1.5707964f < angle) {
            model->Show(0, 1);
        }
        model_counter += 1.0f;
        if (model->CheckMotionEnd(NULL) != 0) {
            mgTexManager.DeleteBlock(model->texture_block);
            model = NULL;
            model_stack.stack_used = 0;
            model_stack.lock = 0;
        }
    }
    for (i = 0; i < 8; i++) {
        if (effect[i] != NULL) {
            if (effect[i]->active == 0) {
                effect[i] = NULL;
                effect_stack[i].stack_used = 0;
                effect_stack[i].lock = 0;
            } else {
                effect[i]->Step();
            }
        }
    }
    if (bg_load == 0 && IsRun() == 0 && keep == 0) {
        Clear();
    }
}
void CRepairManager::Draw() {
    mgTexManager.ReloadTexture(tex_block, (sceVif1Packet *)NULL);
    if (model != NULL) {
        model->DrawDirect();
    }
    for (int index = 0; index < 8; index++) {
        if (effect[index] != NULL) {
            effect[index]->Draw();
        }
    }
}
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
void CLevelUpEffect::Draw() {
    mgCDrawPrim *prim;
    int *color;
    int i;
    int top_left[4];
    int bottom_right[4];
    sceVu0FVECTOR spark_pos;
    mgRect<int> label_rect;
    int alpha;
    float x;
    float y;

    if (active != 0 && tex != NULL) {
        if (chara != NULL) {
            prim = GetMenuPrim();
            SetSpriteEnv(prim, 4);
            prim->Coord(1);
            prim->DepthTestEnable(1);
            prim->Begin(6);
            prim->Texture(tex);
            color = l_levelup_color[kind];
            for (i = 0; i < 32; i++) {
                if (l_levelup_generate_counter[i] > 0) {
                    spark_pos[0] = l_levelup_pos[i][0];
                    spark_pos[1] = l_levelup_pos[i][1];
                    spark_pos[2] = l_levelup_pos[i][2];
                    spark_pos[3] = 1.0f;
                    if (mgTransWorldPrim3DSprite(top_left, bottom_right, spark_pos, 1.5f, 1.5f, 0) != 0) {
                        prim->Color(color[0], color[1], color[2], 0x80);
                        prim->TextureCrd(0x40, 0);
                        prim->Vertex4(top_left);
                        prim->TextureCrd(0x60, 0x20);
                        prim->Vertex4(bottom_right);
                    }
                }
            }
            prim->End();
        } else {
            x = pos[0];
            y = pos[1] - 0.5f * counter;
            alpha = 0x80;
            if (counter > 20) {
                alpha = 0x80 - (counter - 20) * 12;
            }
            label_rect.Set(0xB8, kind * 14 + 0xE4, 0x48, 0xE);
            PrimQuad(tex, x, y, label_rect, alpha, 0x80, 0x80, 0x80);
        }
    }
}
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
void CMenuEffect::PresetInfo(MENU_EFFECT_INFO *particle, int no, int mode) {
    switch (type) {
        case 0: {
            float life = GetRandI(90) + 100;
            particle->unk_4 = life;
            particle->unk_0 = GetRandI((int)life);
            particle->unk_8 = 0.0f;
            particle->unk_14 = GetRandI(4);
            particle->unk_18 = GetRandI(100);
            particle->unk_1c = base_info[2] + GetRandI(44);
            particle->unk_20 = -(GetRandI(5) + 6);
            if (mode != 0) {
                particle->unk_24 = GetRandI(3) + 3;
            }
            particle->unk_28 = GetRandI(32) + 128;
            break;
        }
        case 1:
            particle->unk_0 = GetRandI(3);
            particle->unk_14 = GetRandI(4) - 2;
            particle->unk_18 = GetRandI(9) + 10;
            particle->unk_1c = -(GetRandI(3) + 2);
            break;
        case 2:
            particle->unk_0 = 0.0f;
            particle->unk_14 = GetRandI(20) - 10;
            particle->unk_18 = GetRandI(20) - 10;
            particle->unk_1c = 128.0f;
            particle->unk_20 = GetRandI(3) + 5;
            break;
        case 4:
            particle->unk_0 = 0.0f;
            particle->unk_14 = 0.0f;
            particle->unk_18 = 0.0f;
            particle->unk_1c = 0.0f;
            particle->unk_20 = 0.0f;
            particle->unk_28 = 128.0f;
            break;
        case 10:
        case 12: {
            float life = GetRandI(30) + 120;
            particle->unk_4 = life;
            particle->unk_0 = GetRandI((int)life);
            particle->unk_8 = GetRandI(3);
            particle->unk_14 = GetRandI(4);
            particle->unk_18 = GetRandI(100) + 70;
            particle->unk_30 = GetRandI(20);
            particle->unk_34 = GetRandI(20);
            particle->unk_38 = GetRandI(5) + 14;
            particle->unk_3c = GetRandI(4) + 4;
            particle->unk_28 = GetRandI(32) + 128;
            particle->unk_2c = -GetRandI(5) - 1;
            particle->unk_1c = base_info[2] + GetRandI(44);
            particle->unk_20 = -(GetRandI(3) + 2);
            if (mode != 0) {
                particle->unk_24 = GetRandI(2) + 3;
            }
            break;
        }
        case 11:
            particle->unk_0 = 0.0f;
            particle->unk_4 = 64.0f;
            break;
        case 21:
            particle->unk_0 = 0.0f;
            particle->unk_4 = base_info[2];
            particle->unk_14 = 8.0f;
            particle->unk_18 = 0.88f;
            break;
        case 15:
            particle->unk_0 = 0.0f;
            particle->unk_4 = 1.0f;
            if (mode != 0) {
                particle->unk_14 = no * ((float)base_info[2] / info_num);
            } else {
                particle->unk_14 = base_info[2];
            }
            particle->unk_18 = -1.0f;
            particle->unk_1c = 0.0f;
            particle->unk_28 = 0.0f;
            particle->unk_2c = 1.0f;
            if (mode != 0) {
                particle->unk_24 = 1.0f;
            }
            break;
        case 16:
            particle->unk_0 = 0.0f;
            particle->unk_14 = GetRandI(4) + 1;
            particle->unk_18 = GetRandI(4) + 1;
            if (GetRandI(2) != 0) {
                particle->unk_14 = -particle->unk_14;
            }
            if (GetRandI(2) != 0) {
                particle->unk_18 = -particle->unk_18;
            }
            particle->x = base_info[0] + particle->unk_14 * GetRandI(3);
            particle->y = base_info[1] + particle->unk_18 * GetRandI(3);
            particle->unk_28 = 128.0f;
            particle->unk_2c = -6.0f;
            particle->unk_24 = 1.0f;
            break;
        case 19:
            particle->unk_0 = GetRandI(8) + 4;
            particle->unk_4 = no;
            particle->unk_14 = 10.0f;
            particle->unk_18 = -particle->unk_14 - 12.0f;
            particle->unk_1c = -particle->unk_14 - 13.0f;
            if (no == 0) {
                particle->unk_30 = 168.0f;
            } else {
                particle->unk_30 = 0.0f;
            }
            break;
        case 18: {
            particle->unk_0 = GetRandI(12);
            particle->unk_4 = no % 16;
            int left = base_info[0] - 16;
            int top = base_info[1] - 16;
            int piece = (int)particle->unk_4;
            particle->x = left + spectol_break_pos[piece][0][0];
            particle->y = top + spectol_break_pos[piece][0][1];
            particle->unk_14 = spectol_break_angle[piece][2];
            particle->unk_18 = spectol_break_angle[piece][4];
            particle->unk_1c = 4.0f * (0.98f + GetRandF(0.02f));
            particle->unk_20 = GetRandI(3);
            if (piece >= 48) {
                particle->x = left + GetRandI(32);
                particle->y = top + GetRandI(32);
            }
            float speed = (1.0f + GetRandF(0.01f)) * GetRandF(3.0f);
            speed += GetRandF(0.005f);
            int corner = (int)particle->unk_4 % 8;
            if (corner >= 4) {
                particle->unk_24 = speed;
                if (speed < 0.0f) {
                    particle->unk_24 = 0.0f;
                }
            } else {
                particle->unk_24 = -speed;
                if (particle->unk_24 > 0.0f) {
                    particle->unk_24 = 0.0f;
                }
            }
            float rate = 1.0f;
            if (corner <= 1 || corner == 6 || corner == 7) {
                rate = 0.8f;
            }
            if (particle->unk_4 < 8.0f) {
                particle->unk_28 = -(GetRandF(2.7f * rate) * (1.0f + GetRandF(0.01f))) - 3.0f;
                particle->unk_38 = base_info[1] - GetRandF(5.0f) - 6.0f;
            } else {
                particle->unk_28 = -(GetRandF(4.0f * rate) * (1.0f + GetRandF(0.01f))) - 1.0f;
                particle->unk_38 = base_info[1] + GetRandF(13.0f) + 3.0f;
            }
            particle->unk_3c = 0.0f;
            particle->unk_2c = 0.0f;
            particle->unk_8 = 0.66f + GetRandF(0.032f);
            particle->unk_30 = 138.0f;
            if (piece < 48) {
                particle->unk_34 = 0.0f;
            } else {
                particle->unk_34 = 96.0f;
            }
            break;
        }
        case 20:
            particle->unk_0 = GetRandI(80);
            particle->unk_4 = 0.0f;
            particle->unk_14 = GetRandI(8) + 2;
            particle->unk_18 = 0.0f;
            particle->unk_1c = 0.0f;
            particle->unk_20 = GetRandI(3);
            break;
    }
}
#ifdef NONMATCHING
#pragma divbyzerocheck on
void CMenuEffect::Step() {
    end = 0;
    if (run != 0) {
        MENU_EFFECT_INFO *particle = info;
        if (particle != NULL) {
            int i;
            s8 prev_type = type;
            int done = 1;
            switch (prev_type) {
                case 0:
                    for (i = 0; i < info_num; i++, particle++) {
                        if (particle->unk_24 > 0.0f) {
                            float radius = particle->unk_1c;
                            float angle = 3.1415927f / particle->unk_18 * particle->unk_0;
                            particle->x = base_info[0] + radius * cosf(angle);
                            particle->y = base_info[1] + radius * sinf(angle);
                            particle->unk_1c += particle->unk_20;
                            particle->unk_28 -= 8.0f;
                            if (radius < 40.0f) {
                                particle->unk_28 -= 20.0f;
                            }
                            if (particle->unk_28 < 0.0f) {
                                particle->unk_28 = 0.0f;
                            }
                            particle->unk_0 += 1.0f;
                            if (particle->unk_24 > 1.0f && particle->unk_1c < 3.0f) {
                                particle->unk_24 -= 1.0f;
                                PresetInfo(particle, i, 0);
                            }
                            if (particle->unk_24 == 1.0f && particle->unk_1c < 2.0f) {
                                particle->unk_24 -= 1.0f;
                            }
                            done = 0;
                        }
                    }
                    if (done != 0) {
                        run = 0;
                    }
                    break;
                case 1:
                    for (i = 0; i < info_num; i++) {
                        MENU_EFFECT_INFO *drop = &info[i];
                        if (drop->y < 520.0f) {
                            done = 0;
                            drop->x = base_info[0] + drop->unk_14 * drop->unk_0;
                            drop->y = base_info[1] + drop->unk_18 * drop->unk_0 + 0.25f * (drop->unk_1c * drop->unk_0);
                            drop->unk_0 += 1.0f;
                        }
                    }
                    if (done != 0) {
                        run = 0;
                    }
                    break;
                case 2:
                    for (i = 0; i < info_num; i++) {
                        MENU_EFFECT_INFO *spark = &info[i];
                        if (spark->unk_1c > 0.0f) {
                            spark->x += spark->unk_14;
                            spark->y += spark->unk_18;
                            if (spark->unk_14 > 0.0f) {
                                spark->unk_14 -= 1.0f;
                            }
                            if (spark->unk_14 < 0.0f) {
                                spark->unk_14 += 1.0f;
                            }
                            if (spark->unk_18 > 0.0f) {
                                spark->unk_18 -= 1.0f;
                            }
                            if (spark->unk_18 < 0.0f) {
                                spark->unk_18 += 1.0f;
                            }
                            spark->unk_1c -= spark->unk_20;
                            if (spark->unk_1c < 0.0f) {
                                spark->unk_1c = 0.0f;
                            }
                            done = 0;
                        }
                    }
                    if (done != 0) {
                        run = 0;
                    }
                    break;
                case 3:
                    alpha = 128 - counter * 3;
                    if (alpha < 0) {
                        alpha = 0;
                    }
                    break;
                case 4:
                    particle->x = base_info[0] - particle->unk_1c;
                    particle->y = base_info[1] - particle->unk_20;
                    particle->unk_14 = 2.0f * particle->unk_1c;
                    particle->unk_18 = 2.0f * particle->unk_20;
                    particle->unk_0 += 1.0f;
                    if (particle->unk_0 < 70.0f && (int)particle->unk_0 % 2 != 0) {
                        particle->unk_1c += 1.0f;
                        particle->unk_20 += 1.0f;
                        particle->unk_28 += 1.0f;
                    } else if (particle->unk_0 >= 70.0f && particle->unk_0 < 112.0f &&
                               (int)particle->unk_0 % 4 == 0) {
                        particle->unk_1c += 2.0f;
                        particle->unk_20 += 2.0f;
                        particle->unk_28 += 5.0f;
                    } else if (particle->unk_0 >= 112.0f) {
                        particle->unk_1c -= 6.0f;
                        particle->unk_20 -= 6.0f;
                        particle->unk_28 -= 13.0f;
                    }
                    if (particle->unk_28 > 255.0f) {
                        particle->unk_28 = 255.0f;
                    }
                    if (particle->unk_28 < 0.0f) {
                        particle->unk_28 = 0.0f;
                    }
                    if (particle->unk_1c < 0.0f) {
                        particle->unk_1c = 0.0f;
                    }
                    if (particle->unk_20 < 0.0f) {
                        particle->unk_20 = 0.0f;
                    }
                    if (particle->unk_28 <= 0.0f && particle->unk_1c <= 0.0f) {
                        run = 0;
                        type = -1;
                    }
                    break;
                case 10:
                case 12: {
                    int faded = 1;
                    for (i = 0; i < info_num; i++, particle++) {
                        particle->unk_28 += particle->unk_2c;
                        if (particle->unk_28 < 0.0f) {
                            particle->unk_28 = 0.0f;
                        }
                        if (particle->unk_24 > 0.0f) {
                            float radius = particle->unk_1c;
                            float angle = 3.1415927f / particle->unk_18 * particle->unk_0;
                            particle->x = base_info[0] + radius * cosf(angle);
                            particle->y = base_info[1] + radius * sinf(angle);
                            particle->x += (int)(particle->unk_30 * sinf(3.1415927f * particle->unk_0 / particle->unk_38));
                            particle->y += (int)(particle->unk_34 * sinf(3.1415927f * particle->unk_0 / particle->unk_38));
                            particle->unk_1c += particle->unk_20;
                            particle->unk_0 += 1.0f;
                            if (particle->unk_24 > 1.0f && particle->unk_1c < 3.0f) {
                                particle->unk_24 -= 1.0f;
                                PresetInfo(particle, i, 0);
                            }
                            if (particle->unk_24 == 1.0f && particle->unk_1c < 2.0f) {
                                particle->unk_24 -= 1.0f;
                            }
                            done = 0;
                        }
                        if (particle->unk_28 > 0.0f) {
                            faded = 0;
                        }
                    }
                    if (done != 0 && faded != 0) {
                        run = 0;
                    }
                    break;
                }
                case 11:
                    break;
                case 21:
                    particle->unk_0 += 1.0f;
                    particle->x = base_info[0] + particle->unk_14 * sinf(GetRandF(6.2831855f));
                    particle->y = base_info[1] + particle->unk_14 * sinf(GetRandF(6.2831855f));
                    if ((int)particle->unk_0 % 2 != 0) {
                        particle->unk_14 *= particle->unk_18;
                    }
                    particle->unk_1c = particle->unk_20 = particle->unk_24 = 200.0f;
                    break;
                case 15:
                    for (i = 0; i < info_num; i++, particle++) {
                        particle->unk_0 += 1.0f;
                        if ((int)particle->unk_0 % 2 != 0) {
                            particle->unk_28 += particle->unk_2c;
                        }
                        if (particle->unk_28 <= 0.0f) {
                            particle->unk_28 = 0.0f;
                        }
                        if (particle->unk_28 > 164.0f) {
                            particle->unk_28 = 164.0f;
                        }
                        if (particle->unk_24 > 0.0f) {
                            if ((int)particle->unk_0 % (int)particle->unk_4 == 0) {
                                particle->unk_14 += particle->unk_18;
                                if (particle->unk_14 <= 0.0f) {
                                    particle->unk_24 -= 1.0f;
                                    particle->unk_14 = 0.0f;
                                    PresetInfo(particle, i, 0);
                                }
                            }
                            done = 0;
                            particle->x = base_info[0] - particle->unk_14;
                            particle->y = base_info[1] - particle->unk_14;
                        }
                        if (particle->unk_24 <= 0.0f) {
                            particle->unk_28 = 0.0f;
                        }
                    }
                    if (done != 0) {
                        run = 0;
                    }
                    break;
                case 16:
                    for (i = 0; i < info_num; i++, particle++) {
                        particle->unk_28 += particle->unk_2c;
                        if (particle->unk_24 > 0.0f) {
                            particle->x += particle->unk_14;
                            particle->y += particle->unk_18;
                            particle->unk_0 += 1.0f;
                            done = 0;
                            if (particle->unk_24 > 1.0f && particle->unk_28 < 10.0f) {
                                particle->unk_24 -= 1.0f;
                            }
                        }
                    }
                    if (done != 0) {
                        run = 0;
                    }
                    break;
                case 19: {
                    int ended = 0;
                    for (i = 0; i < 1; i++, particle++) {
                        particle->unk_0 += 1.0f;
                        particle->unk_28 = particle->unk_30 * sinf(0.07853982f * particle->unk_0);
                        particle->x = base_info[0] - 16;
                        particle->y = base_info[1] - 12;
                        if (particle->unk_28 <= 0.0f) {
                            particle->unk_28 = 0.0f;
                            ended++;
                        }
                    }
                    if (ended > 0) {
                        type = 18;
                        PresetInfoAll(0);
                        counter = 0;
                    }
                    break;
                }
                case 18: {
                    int ended = 0;
                    for (i = 0; i < info_num; i++, particle++) {
                        particle->unk_0 += 1.0f;
                        if (particle->unk_0 > 26.0f) {
                            particle->unk_30 -= 2.0f;
                        }
                        if (particle->unk_30 < 0.0f) {
                            particle->unk_30 = 0.0f;
                            ended++;
                        }
                        if (particle->y <= mgScreenHeight && particle->x <= mgScreenWidth) {
                            particle->x += particle->unk_24;
                            particle->y += particle->unk_28;
                            if ((int)particle->unk_0 % 6 == 0) {
                                particle->unk_24 *= particle->unk_8;
                                particle->unk_28 += particle->unk_2c;
                            }
                            if (particle->unk_38 <= base_info[1] && particle->unk_28 > 2.0f &&
                                particle->unk_38 < particle->y) {
                                particle->unk_28 = -(0.8f * particle->unk_1c);
                                particle->unk_2c = -1.0f;
                                particle->unk_38 += 3.5f * (1.0f + GetRandF(0.004f) - 0.002f);
                                if (particle->unk_1c > 2.9f) {
                                    particle->unk_1c -= 1.6f;
                                }
                            }
                            if (particle->unk_38 > base_info[1] && particle->unk_28 > 2.0f &&
                                particle->unk_38 < particle->y) {
                                particle->unk_28 = -(0.9f * particle->unk_1c);
                                particle->unk_2c = 2.0f;
                                particle->unk_38 += 3.6f * (1.0f + GetRandF(0.004f) - 0.002f);
                                if (particle->unk_1c > 2.6f) {
                                    particle->unk_1c -= 1.1f;
                                }
                            }
                            if (particle->unk_38 < base_info[1]) {
                                if ((int)particle->unk_0 % 6 == 0) {
                                    particle->unk_2c += 1.0f;
                                }
                            } else if ((int)particle->unk_0 % 12 == 0) {
                                particle->unk_2c += 1.0f;
                            }
                            if ((int)particle->unk_0 % 12 == 0) {
                                particle->unk_2c += 1.0f;
                            }
                        }
                    }
                    if (ended >= 48 && counter > 90) {
                        type = 20;
                        PresetInfoAll(0);
                        tex = MenuPosData->icon_effect_tex;
                        counter = 0;
                    }
                    break;
                }
                case 20: {
                    int gathered = 0;
                    for (i = 0; i < info_num - 1; i++, particle++) {
                        particle->unk_0 += 1.0f;
                        particle->x += (base_info[4] - particle->x) / 9.0f;
                        particle->y += (base_info[5] - particle->y) / 9.0f;
                        int fade;
                        if (abs((int)(particle->x - base_info[4])) < 9 && abs((int)(particle->y - base_info[5])) < 9) {
                            particle->x = base_info[4] + particle->unk_14 * sinf(0.07853982f * particle->unk_0);
                            particle->y = base_info[5] + particle->unk_14 * cosf(0.07853982f * particle->unk_0);
                            gathered++;
                            fade = -5;
                        } else {
                            fade = 3;
                            done = 0;
                        }
                        particle->unk_30 += fade;
                        if (particle->unk_30 < 0.0f) {
                            particle->unk_30 = 0.0f;
                        }
                        if (particle->unk_30 > 128.0f) {
                            particle->unk_30 = 128.0f;
                        }
                    }
                    particle->unk_0 += 1.0f;
                    particle->x = base_info[4] - particle->unk_18;
                    particle->y = base_info[5] - particle->unk_18;
                    if (gathered < info_num * 14 / 15) {
                        particle->unk_18 += 2.0f;
                        if (!(particle->unk_18 < 30.0f)) {
                            particle->unk_18 = 30.0f;
                        }
                    } else if ((int)particle->unk_0 % 2 == 0) {
                        particle->unk_1c = 1.0f;
                        particle->unk_18 -= 1.0f;
                        if (particle->unk_18 < 0.0f) {
                            particle->unk_18 = 0.0f;
                        }
                    }
                    particle->unk_30 = 7.0f * particle->unk_18;
                    if (done != 0 && particle->unk_18 <= 0.0f) {
                        run = 0;
                    }
                    break;
                }
            }
            if (prev_type != type) {
                end = 1;
            }
            counter++;
        }
    }
}
#pragma divbyzerocheck reset
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menudraw", Step__11CMenuEffectFv);
#endif
#ifdef NONMATCHING
void CMenuEffect::Draw() {
    if (run != 0 && info != NULL && tex != NULL) {
        mgTexManager.ReloadTexture(tex_block, (sceVif1Packet *)NULL);
        mgCDrawPrim *prim = GetMenuPrim();
        prim->Initialize(NULL, NULL);
        prim->AlphaBlendEnable(1);
        prim->AlphaBlend(2);
        prim->AlphaTestEnable(1);
        prim->AlphaTest(1, 0);
        prim->DepthTestEnable(0);
        prim->ZMask(-1);
        prim->Shading(1);
        prim->TextureMapEnable(1);
        prim->Bilinear(1);
        MENU_EFFECT_INFO *particle = info;
        effect_color color = at_5901;
        color.a = alpha;
        mgRect<float> rect(0.0f, 0.0f, 8.0f, 8.0f);
        mgRect<int> uv(0, 32, 8, 8);
        mgRect<int> corner_uv[4];
        corner_uv[0].Set(0, 0, 0, 0);
        corner_uv[1].Set(0, 0, 0, 0);
        corner_uv[2].Set(0, 0, 0, 0);
        corner_uv[3].Set(0, 0, 0, 0);
        corner_uv[3].Set(32, 32, 32, 32);
        int i;
        switch (type) {
            case 18:
                prim->AlphaBlend(1);
                prim->Begin(3);
                prim->Texture(tex);
                for (i = 0; i < 48; i++, particle++) {
                    int piece = (int)particle->unk_4;
                    prim->Color(color.r, color.g, color.b, (int)particle->unk_30);
                    s16 (*corner)[2] = spectol_break_pos[piece];
                    prim->TextureCrd(base_info[2] + corner[0][0], base_info[3] + corner[0][1]);
                    prim->Vertex(particle->x, particle->y, 0.0f);
                    prim->TextureCrd(base_info[2] + corner[1][0], base_info[3] + corner[1][1]);
                    float angle = particle->unk_14 + 0.05235988f * particle->unk_0;
                    prim->Vertex(particle->x + 10.0f * cosf(angle), particle->y + 10.0f * sinf(angle), 0.0f);
                    prim->TextureCrd(base_info[2] + corner[2][0], base_info[3] + corner[2][1]);
                    angle = particle->unk_18 + 0.05235988f * particle->unk_0;
                    prim->Vertex(particle->x + 10.0f * cosf(angle), particle->y + 10.0f * sinf(angle), 0.0f);
                }
                prim->End();
                prim->AlphaBlend(2);
                prim->Begin(6);
                prim->Texture(MenuPosData->icon_effect_tex);
                for (; i < info_num || i < 80; i++, particle++) {
                    prim->Color(color.r, color.g, color.b, (int)particle->unk_30);
                    prim->TextureCrd(0, 32);
                    prim->Vertex(particle->x, particle->y, 0.0f);
                    prim->TextureCrd(8, 40);
                    prim->Vertex(8.0f + particle->x, 8.0f + particle->y, 0.0f);
                }
                prim->End();
                return;
            case 19: {
                int size = (int)(32.0f + 2.0f * particle->unk_14);
                prim->Begin(6);
                prim->Texture(MenuPosData->icon_effect_tex);
                prim->Color(0x80, 0x80, 0x80, (int)particle->unk_28);
                mgRect<int> put((int)particle->x, (int)particle->y, size, size);
                PrimQuad(prim, put, star_light);
                prim->End();
                return;
            }
            case 21: {
                rect.Set(particle->x, particle->y, 32.0f, 40.0f);
                item_color item_rgba = at_5917;
                item_rgba.rgba[0] = particle->unk_1c;
                item_rgba.rgba[1] = particle->unk_20;
                item_rgba.rgba[2] = particle->unk_20;
                item_rgba.rgba[3] = particle->unk_28;
                DrawOneItem(prim, rect, (int)particle->unk_4, 0, NULL, item_rgba.rgba, 0);
                return;
            }
            case 4:
                uv.Set(0x60, 0, 16, 16);
                rect.Set(particle->x, particle->y, particle->unk_14, particle->unk_18);
                break;
            case 10:
                rect.Set(0.0f, 0.0f, 32.0f, 32.0f);
                corner_uv[0].Set(0, 0, 32, 32);
                corner_uv[1].Set(32, 0, 32, 32);
                corner_uv[2].Set(0, 32, 32, 32);
                if (base_info[4] == 0) {
                    rect.Set(0.0f, 0.0f, 16.0f, 16.0f);
                }
                break;
            case 12:
                rect.Set(0.0f, 0.0f, 32.0f, 32.0f);
                break;
            case 15:
                uv.Set(0, 0, 32, 32);
                color.r = 0x20;
                color.g = 0x20;
                color.b = 0x60;
                break;
            case 16:
                rect.Set(0.0f, 0.0f, 32.0f, 32.0f);
                uv.Set(0x40, 0, 32, 32);
                break;
        }
        prim->Begin(6);
        prim->Texture(tex);
        for (i = 0; i < info_num; i++, particle++) {
            if (type == 0) {
                color.a = (int)particle->unk_28;
            } else if (type == 2) {
                color.a = (int)particle->unk_1c;
            } else if (type == 10) {
                uv = corner_uv[(int)particle->unk_8];
                float angle = 0.3926991f * particle->unk_0;
                while (3.1415927f <= angle) {
                    angle -= 6.2831855f;
                }
                rect.right = rect.bottom = 32.0f + particle->unk_3c * sinf(angle);
                color.a = (int)particle->unk_28;
            } else if (type == 12) {
                uv = corner_uv[3];
            } else if (type == 15) {
                float size = 2.0f * particle->unk_14;
                rect.Set(particle->x, particle->y, size, size);
                color.a = (int)particle->unk_28;
            } else if (type == 20) {
                if (i == info_num - 1) {
                    float size = 2.0f * particle->unk_18;
                    rect.Set(particle->x, particle->y, size, size);
                    uv.Set(0x40, 0, 32, 32);
                } else {
                    int *star_color = &star_color_table[(int)particle->unk_20 * 3];
                    color.r = star_color[0];
                    color.g = star_color[1];
                    color.b = star_color[2];
                }
                color.a = (int)particle->unk_30;
            }
            prim->Color(color.r, color.g, color.b, color.a);
            rect.left = particle->x;
            rect.top = particle->y;
            PrimQuad(prim, rect, uv);
        }
        prim->End();
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menudraw", Draw__11CMenuEffectFv);
#endif
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
extern "C" void __sinit_menudraw_cpp() {
    GiftBoxWindowPutPos.Set(0, 0, 0, 0);
    menu_long_hand.Set(62, 1, 40, 24);
    MenuMainFrame_PutRect.Set(0, 0, 0, 0);
    MenuMainIMG_PutRect.Set(0, 0, 0, 0);
    star_light.Set(0, 32, 8, 8);
    MenuItemBrdKomaRect.Set(32, 32, 40, 50);
    ItemBoardScrlBar1.Set(96, 128, 22, 11);
    ItemBoardScrlBar2.Set(96, 138, 22, 4);
    ItemBoardScrlBar3.Set(96, 140, 22, 12);
    ItemBoardCursor.Set(118, 128, 8, 30);
}

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
