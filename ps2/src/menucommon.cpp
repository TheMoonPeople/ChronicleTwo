#include "menucommon.hpp"
#include "mw_runtime.h"

#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <cstring>

#include "character.hpp"
#include "dataread.hpp"
#include "effectlist.hpp"
#include "gamedata.hpp"
#include "mainloop.hpp"
#include "menuaqua.hpp"
#include "menucls1.hpp"
#include "menudraw.hpp"
#include "menumain.hpp"
#include "menusys.hpp"
#include "mg_camera.hpp"
#include "mg_frame.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "nd_meswin.hpp"
#include "savedata.hpp"
#include "scene.hpp"
#include "sceneseq.hpp"
#include "scenesnd.hpp"
#include "scriptinterpreter.hpp"
#include "snd_mngr.hpp"
#include "sound.hpp"
#include "sysmes.hpp"
#include "userdata.hpp"

/**
 *
 * Number of item categories used by the menu sorting order.
 *
 */
static const int sort_type_count = 0x24;

/**
 *
 * Default number of miscellaneous-information entries in a menu layout.
 *
 */
static const int default_etc_count = 0x60;

static inline unsigned int align16_blocks(unsigned int n);

int menu_dtype_init(CMenuPosDataForm *form, SPI_STACK *stack, int argc);

int CompGameData(int item_a, int item_b);

int SeitonItemBoardSub(CGameDataUsed *items, int count);

int _ETCINFO_MALLOC(SPI_STACK *stack, int arg_count);

int _MENU_ETCINFO_OFFSET(SPI_STACK *stack, int arg_count);

int _MENU_ETCINFO(SPI_STACK *stack, int arg_count);

int _MENU_ETCINFO_CLEAR(SPI_STACK *stack, int arg_count);

int _ETCINFO2_MALLOC(SPI_STACK *stack, int arg_count);

int _MENU_ETCINFO2_OFFSET(SPI_STACK *stack, int arg_count);

int _MENU_ETCINFO2(SPI_STACK *stack, int arg_count);

int _MENU_ETCINFO2_CLEAR(SPI_STACK *stack, int arg_count);

int _MENU_RESET_TEXINFO(SPI_STACK *stack, int arg_count);

int _MENU_INIT_DRAWLIST(SPI_STACK *stack, int arg_count);

int _MENU_TEXDATA_CLEAR(SPI_STACK *stack, int argc);

int _MENU_FORM_CLEAR(SPI_STACK *stack, int argc);

int _MENU_TEXDATA_MALLOC(SPI_STACK *stack, int argc);

int _MENU_TEXNAME(SPI_STACK *stack, int argc);

int _MENU_TEXDATA_OFFSET(SPI_STACK *stack, int argc);

int _MENU_TEXDATA(SPI_STACK *stack, int argc);

int _MENU_FORM_MALLOC(SPI_STACK *stack, int argc);

int _MENU_FORM_OFFSET_NO(SPI_STACK *stack, int argc);

int _MENU_FORM_SET(SPI_STACK *stack, int argc);

int _MENU_FORM_PARTNUM(SPI_STACK *stack, int argc);

void menu_texdata_to_formpart_copy(MENUFORMPARTS_TYPE *part);

int _MENU_FORM_DTYPE(SPI_STACK *stack, int argc);

int _MENU_FORM_MTYPE(SPI_STACK *stack, int argc);

int _MENU_FORM_DRAWFLG(SPI_STACK *stack, int argc);

int _MENU_FORM_VIBECNT(SPI_STACK *stack, int argc);

int _MENU_FORM_SETEND(SPI_STACK *stack, int argc);

int _MENU_FORM_MOVERATE(SPI_STACK *stack, int argc);

int _MENU_FORM_PUTXY(SPI_STACK *stack, int argc);

int _MENU_FORM_RGBA(SPI_STACK *stack, int argc);

int _MENU_ACTION_TABLE_NUM(SPI_STACK *stack, int argc);

int _MENU_ACTION_DEF(SPI_STACK *stack, int argc);

int _MENU_ACTION_SETACTION(SPI_STACK *stack, int argc);

int _MENU_PARTVIBECNT(SPI_STACK *stack, int argc);

int _MENU_PARTVIBER(SPI_STACK *stack, int argc);

int _MENU_SHADOW_ONOFF(SPI_STACK *stack, int argc);

int _CLIP_WH(SPI_STACK *stack, int argc);

int _MENU_PARTRGBA(SPI_STACK *stack, int argc);

int _MENU_PART_ALPHA_BLEND(SPI_STACK *stack, int argc);

int _MENU_PART_ETCINFO(SPI_STACK *stack, int argc);

int _MENU_PART_BILINEAR(SPI_STACK *stack, int argc);

void MakePartsName(SPI_STACK *stack, MENUFORMPARTS_TYPE *part);

int _MENU_PART_DTYPE(SPI_STACK *stack, int argc);

int _MENU_NORMAL(SPI_STACK *stack, int argc);

int _MENU_NORMAL2(SPI_STACK *stack, int argc);

int _MENU_CURSOR(SPI_STACK *stack, int argc);

int _MENU_FUNCINFO(SPI_STACK *stack, int argc);

int _MENU_NUMBER1(SPI_STACK *stack, int argc);

int _MENU_NUMBER2(SPI_STACK *stack, int argc);

int _MENU_FRMIMG(SPI_STACK *stack, int argc);

int _MENU_FORM(SPI_STACK *stack, int argc);

int _MENU_ITEM(SPI_STACK *stack, int argc);

int _MENU_ITEM_CHECKMARK(SPI_STACK *stack, int argc);

int _MENU_FILLBOXINFO(SPI_STACK *stack, int argc);

int _MENU_WAKU_RECT(SPI_STACK *stack, int argc);

int _MENU_WAKU_CIRCLE(SPI_STACK *stack, int argc);

int _MENU_PARTS_EFF_NUM(SPI_STACK *stack, int argc);

int _MENU_PARTS_EFFECT(SPI_STACK *stack, int argc);

int _MENU_EXE_COMMAND_NAME(SPI_STACK *stack, int argc);

int _MENU_EXE_FORM_DRAWFLAG(SPI_STACK *stack, int argc);

int _MENU_EXE_FORM_RGBA(SPI_STACK *stack, int argc);

int _MENU_EXE_FORM_CALCRGBAPARAM(SPI_STACK *stack, int argc);

int _MENU_EXE_FORM_FADE(SPI_STACK *stack, int argc);

int _MENU_EXE_FORM_SETACTION(SPI_STACK *stack, int argc);

int _MENU_EXE_FORM_PARTSONOFF(SPI_STACK *stack, int argc);

int _MENU_EXE_FORM_PARTSONOFF_GRP(SPI_STACK *stack, int argc);

int _MENU_EXE_FORM_SWAP(SPI_STACK *stack, int argc);

int _MENU_EXE_FORM_GROUP_SWAP(SPI_STACK *stack, int argc);

int _MENU_EXE_MSGENV(SPI_STACK *stack, int argc);

int _MENU_EXE_MAKEMSG(SPI_STACK *stack, int argc);

int _MENU_EXE_SETABSPOS(SPI_STACK *stack, int argc);

int _MENU_EXE_MSGSETSYSTEMBUFF(SPI_STACK *stack, int argc);

int _MENU_EXE_MSGSETFUCHI(SPI_STACK *stack, int argc);

int _MENU_EXE_MSGSETCURSOR(SPI_STACK *stack, int argc);

int _MENU_SET_QUESTIONGYOU(SPI_STACK *stack, int argc);

int _MENU_SET_OPENSPEED(SPI_STACK *stack, int argc);

int _MENU_INPUT_KEY(SPI_STACK *stack, int argc);

int _MENU_CURSOR_ONOFF(SPI_STACK *stack, int argc);

int _MENU_CURSOR_FADE(SPI_STACK *stack, int argc);

int _MENU_WAKUTYPE(SPI_STACK *stack, int argc);

int _MENU_SCENE_FADE(SPI_STACK *stack, int argc);

int _MENU_SE_PLAY(SPI_STACK *stack, int argc);

int _MENU_EXE_INIT_DRAWLIST(SPI_STACK *stack, int argc);

int _MENU_EXE_RESET_TEXINFO(SPI_STACK *stack, int argc);

int _MENU_DEBUG_PRINTF(SPI_STACK *stack, int argc);

/**
 *
 * Rounds a byte count up to the number of 16-byte allocation blocks.
 *
 */
int _MENU_FORM_RGBA_BIT(SPI_STACK *stack, int argc);

int _MENU_FILLBOX(SPI_STACK *stack, int argc);

int _MENU_EXE_FORM_SETPOS(SPI_STACK *stack, int argc);

int _MENU_EXE_MSGSETBUFF(SPI_STACK *stack, int argc);

/**
 *
 * Sort rank of each item category, with an empty slot ordered last.
 *
 */
static signed char sort_table[0x24] = {
    sort_type_count, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
    11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22,
    23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 0
};

/**
 *
 * Language-specific subdirectory used for menu files.
 *
 */
static char *langdirpathTable_1161[8] = {
    "0/", "1/", "2/", "3/", "4/", "5/", "1/", NULL
};

/**
 *
 * Hexadecimal digits and their nibble values for bracketed font codes.
 *
 */
static s8 mes_cord_conv_1193[16][2] = {
    {'0', 0}, {'1', 1}, {'2', 2}, {'3', 3},
    {'4', 4}, {'5', 5}, {'6', 6}, {'7', 7},
    {'8', 8}, {'9', 9}, {'a', 10}, {'b', 11},
    {'c', 12}, {'d', 13}, {'e', 14}, {'f', 15}
};

/**
 *
 * Drawing-type keywords accepted by the menu form script.
 *
 */
static MENU_SPI_ANALYZE_STRUCT1 tbl_1728[] = {
    {"normal", MENUFORM_DTYPE_NORMAL},
    {"itembrd", MENUFORM_DTYPE_ITEMBRD},
    {"giftview", MENUFORM_DTYPE_GIFTVIEW},
    {"msgform", MENUFORM_DTYPE_MSGFORM},
    {"poly", MENUFORM_DTYPE_POLY},
    {"mappart", MENUFORM_DTYPE_MAPPART},
    {"combrd", MENUFORM_DTYPE_COMBRD},
    {"createbrd", MENUFORM_DTYPE_CREATEBRD},
    {"list", MENUFORM_DTYPE_LIST},
    {"bg_tile", MENUFORM_DTYPE_BG_TILE},
    {"dload", MENUFORM_DTYPE_DLOAD},
    {"mainfrm", MENUFORM_DTYPE_MAINFRM},
    {"mainimg", MENUFORM_DTYPE_MAINIMG},
    {"chrstar", MENUFORM_DTYPE_CHRSTAR},
    {"inv_card", MENUFORM_DTYPE_INV_CARD},
    {"geolist", MENUFORM_DTYPE_GEOLIST},
    {"geotitle", MENUFORM_DTYPE_GEOTITLE},
    {"geoana", MENUFORM_DTYPE_GEOANA},
    {"shoplist", MENUFORM_DTYPE_SHOPLIST},
    {"clip", MENUFORM_DTYPE_CLIP},
    {"wmap", MENUFORM_DTYPE_WMAP},
    {"buildup", MENUFORM_DTYPE_BUILDUP},
    {"mosbaji", MENUFORM_DTYPE_MOSBAJI},
    {"savelist", MENUFORM_DTYPE_SAVELIST},
    {"infocur", MENUFORM_DTYPE_INFOCUR},
    {"house", MENUFORM_DTYPE_HOUSE},
    {NULL, -1},
};

/**
 *
 * Movement keywords ordered by their MENUFORM_MTYPE value plus one.
 *
 */
static char *tbl_1759[6] = {"n", "d", "l", "i", "ir", NULL};

/**
 *
 * Additional drawing-type keywords accepted by the menu part script.
 *
 */
static MENU_SPI_ANALYZE_STRUCT1 tbl_1994[] = {
    {"clut_reload", MENUFORMPARTS_DTYPE_CLUT_RELOAD},
    {"\x94\xAD\x96\xBE\x83l\x83^", MENUFORMPARTS_DTYPE_IDEA_BOARD},
    {"\x83" "A\x83\x8B\x83o\x83\x80", MENUFORMPARTS_DTYPE_ALBUM},
    {"\x82\xB2\x82\xBF\x82\xE1\x90\xFC", MENUFORMPARTS_DTYPE_RANDOM_LINE},
    {"font", MENUFORMPARTS_DTYPE_FONT},
    {"\x83l\x83^\x92\xA0", MENUFORMPARTS_DTYPE_IDEA_MEMO},
    {NULL, -1},
};

/**
 *
 * Frame-image drawing keywords accepted by the menu script.
 *
 */
static MENU_SPI_ANALYZE_STRUCT1 tbl_2060[] = {
    {"bg", MENUFORMPARTS_DTYPE_BG},
    {"beta", MENUFORMPARTS_DTYPE_BETA},
    {NULL, -1},
};

/**
 *
 * Item-icon drawing keywords accepted by the menu script.
 *
 */
static MENU_SPI_ANALYZE_STRUCT1 tbl_2074[] = {
    {"trs", MENUFORMPARTS_DTYPE_TRS},
    {"neta", MENUFORMPARTS_DTYPE_NETA},
    {NULL, -1},
};

/**
 *
 * Filled-box drawing keywords accepted by the menu script.
 *
 */
static MENU_SPI_ANALYZE_STRUCT1 tbl_2090[] = {
    {"sq_beta", MENUFORMPARTS_DTYPE_SQ_BETA},
    {NULL, -1},
};

/**
 *
 * Animation-effect keywords accepted by the menu part script.
 *
 */
static MENU_SPI_ANALYZE_STRUCT1 tbl_2144[] = {
    {"blink", MENU_PARTS_EFFECT_BLINK},
    {"rot", MENU_PARTS_EFFECT_ROT},
    {"huriko", MENU_PARTS_EFFECT_HURIKO},
    {"stretch", MENU_PARTS_EFFECT_STRETCH},
    {"stretch_rep", MENU_PARTS_EFFECT_STRETCH_REP},
    {"stretch_sin", MENU_PARTS_EFFECT_STRETCH_SIN},
    {NULL, 0},
};

/**
 *
 * Dispatch table for texture, form, part and effect layout script tags.
 *
 */
static SPI_TAG_PARAM menu_analyze_tag[] = {
    {"ETCINFO_MALLOC", _ETCINFO_MALLOC},
    {"ETCINFO_OFFSET", _MENU_ETCINFO_OFFSET},
    {"ETCINFO", _MENU_ETCINFO},
    {"ETCINFO_CLEAR", _MENU_ETCINFO_CLEAR},
    {"ETCINFO2_MALLOC", _ETCINFO2_MALLOC},
    {"ETCINFO2_OFFSET", _MENU_ETCINFO2_OFFSET},
    {"ETCINFO2", _MENU_ETCINFO2},
    {"ETCINFO2_CLEAR", _MENU_ETCINFO2_CLEAR},
    {"RESET_TEXINFO", _MENU_RESET_TEXINFO},
    {"INIT_DRAWLIST", _MENU_INIT_DRAWLIST},
    {"TEXDATA_CLEAR", _MENU_TEXDATA_CLEAR},
    {"TEXDATA_MALLOC", _MENU_TEXDATA_MALLOC},
    {"TEXNAME", _MENU_TEXNAME},
    {"TEXDATA_OFFSET", _MENU_TEXDATA_OFFSET},
    {"TEXDATA", _MENU_TEXDATA},
    {"TD", _MENU_TEXDATA},
    {"FORM_CLEAR", _MENU_FORM_CLEAR},
    {"FORM_MALLOC", _MENU_FORM_MALLOC},
    {"FORM_OFFSET_NO", _MENU_FORM_OFFSET_NO},
    {"FORM_SET", _MENU_FORM_SET},
    {"FORM_PARTNUM", _MENU_FORM_PARTNUM},
    {"FORM_DTYPE", _MENU_FORM_DTYPE},
    {"FORM_MTYPE", _MENU_FORM_MTYPE},
    {"FORM_DRAWFLG", _MENU_FORM_DRAWFLG},
    {"FORM_VIBECNT", _MENU_FORM_VIBECNT},
    {"FORM_MOVERATE", _MENU_FORM_MOVERATE},
    {"FORM_PUTXY", _MENU_FORM_PUTXY},
    {"FORM_RGBA", _MENU_FORM_RGBA},
    {"FORM_RGBABIT", _MENU_FORM_RGBA_BIT},
    {"FORM_ACTTBL", _MENU_ACTION_TABLE_NUM},
    {"FORM_ACTDEF", _MENU_ACTION_DEF},
    {"FORM_SETACT", _MENU_ACTION_SETACTION},
    {"PARTVIBECNT", _MENU_PARTVIBECNT},
    {"PARTVIBER", _MENU_PARTVIBER},
    {"SHADOW", _MENU_SHADOW_ONOFF},
    {"CLIP", _CLIP_WH},
    {"PARTRGBA", _MENU_PARTRGBA},
    {"PARTALP_BLEND", _MENU_PART_ALPHA_BLEND},
    {"PART_ETCINFO", _MENU_PART_ETCINFO},
    {"PART_BILINEAR", _MENU_PART_BILINEAR},
    {"PART_DTYPE", _MENU_PART_DTYPE},
    {"NORMAL", _MENU_NORMAL},
    {"NRL", _MENU_NORMAL},
    {"NORMAL2", _MENU_NORMAL2},
    {"CURSOR", _MENU_CURSOR},
    {"FUNCINFO", _MENU_FUNCINFO},
    {"NUMBER1", _MENU_NUMBER1},
    {"NUMBER2", _MENU_NUMBER2},
    {"FRMIMG", _MENU_FRMIMG},
    {"FORM", _MENU_FORM},
    {"FORM_SETEND", _MENU_FORM_SETEND},
    {"ITEM", _MENU_ITEM},
    {"ITEM_MARK", _MENU_ITEM_CHECKMARK},
    {"FILLBOX", _MENU_FILLBOX},
    {"FILLBOXINFO", _MENU_FILLBOXINFO},
    {"WAKU_RECT", _MENU_WAKU_RECT},
    {"WAKU_CIRCLE", _MENU_WAKU_CIRCLE},
    {"PARTS_EFF_NUM", _MENU_PARTS_EFF_NUM},
    {"PARTS_EFFECT", _MENU_PARTS_EFFECT},
    {NULL, NULL},
};

/**
 *
 * Message preset keywords accepted by menu command scripts.
 *
 */
static MENU_SPI_ANALYZE_STRUCT1 tbl_2369[] = {
    {"default", MENU_SCRIPT_MES_DEFAULT},
    {"default_black", MENU_SCRIPT_MES_DEFAULT_BLACK},
    {"no_win", MENU_SCRIPT_MES_NO_WIN},
    {"system", MENU_SCRIPT_MES_SYSTEM},
    {"name", MENU_SCRIPT_MES_NAME},
    {"name_black", MENU_SCRIPT_MES_NAME_BLACK},
    {"itemcmd", MENU_SCRIPT_MES_ITEMCMD},
    {"invent", MENU_SCRIPT_MES_INVENT},
    {"geo", MENU_SCRIPT_MES_GEO},
    {"msgdic", MENU_SCRIPT_MES_MSGDIC},
    {"general", MENU_SCRIPT_MES_GENERAL},
    {"general_2", MENU_SCRIPT_MES_GENERAL_2},
    {"yesno", MENU_SCRIPT_MES_YESNO},
    {"brd3", MENU_SCRIPT_MES_BRD3},
    {"helpwin", MENU_SCRIPT_MES_HELPWIN},
    {"makebrd", MENU_SCRIPT_MES_MAKEBRD},
    {"itemmsg", MENU_SCRIPT_MES_ITEMMSG},
    {"itemmsg_defaultfuchi", MENU_SCRIPT_MES_ITEMMSG_DEFAULTFUCHI},
    {"volmsg", MENU_SCRIPT_MES_VOLMSG},
    {"talk", MENU_SCRIPT_MES_TALK},
    {NULL, MENU_SCRIPT_MES_DEFAULT},
};

/**
 *
 * Font-outline keywords accepted by menu command scripts.
 *
 */
static MENU_SPI_ANALYZE_STRUCT1 tbl_2422[] = {
    {"default", FUCHI_SHADOW_BLACK_WIDE},
    {"none", FUCHI_NONE},
    {"ol2", FUCHI_OUTLINE_THICK},
    {NULL, FUCHI_NONE},
};

/**
 *
 * System sound keywords accepted by menu command scripts.
 *
 */
static MENU_SPI_ANALYZE_STRUCT1 tbl_2516[] = {
    {"OK", 1},
    {"CANCEL", MENU_SCRIPT_SOUND_CANCEL},
    {NULL, -1},
};

/**
 *
 * Dispatch table for form, message, input, sound and debug menu command tags.
 *
 */
static SPI_TAG_PARAM menu_execommand_analyze_tag[] = {
    {"EXE_NAME", _MENU_EXE_COMMAND_NAME},
    {"FRM_DRAWFLG", _MENU_EXE_FORM_DRAWFLAG},
    {"FRM_RGBA", _MENU_EXE_FORM_RGBA},
    {"FRM_CALCRGBA", _MENU_EXE_FORM_CALCRGBAPARAM},
    {"FRM_FADE", _MENU_EXE_FORM_FADE},
    {"FRM_SETPOS", _MENU_EXE_FORM_SETPOS},
    {"FRM_SETACTION", _MENU_EXE_FORM_SETACTION},
    {"FRM_PARTSONOFF", _MENU_EXE_FORM_PARTSONOFF},
    {"FRM_PARTSONOFFG", _MENU_EXE_FORM_PARTSONOFF_GRP},
    {"FRM_PTSONOFF", _MENU_EXE_FORM_PARTSONOFF},
    {"FRM_PTSONOFFG", _MENU_EXE_FORM_PARTSONOFF_GRP},
    {"FRM_SWAP", _MENU_EXE_FORM_SWAP},
    {"FRM_SWAP_G", _MENU_EXE_FORM_GROUP_SWAP},
    {"INIT_DRAWLIST", _MENU_EXE_INIT_DRAWLIST},
    {"RESET_TEXINFO", _MENU_EXE_RESET_TEXINFO},
    {"MSG_ENV", _MENU_EXE_MSGENV},
    {"MSG_MAKEMSG", _MENU_EXE_MAKEMSG},
    {"MSG_ABSPOS", _MENU_EXE_SETABSPOS},
    {"MSG_SYSBUF", _MENU_EXE_MSGSETSYSTEMBUFF},
    {"MSG_BUF", _MENU_EXE_MSGSETBUFF},
    {"MSG_FUCHI", _MENU_EXE_MSGSETFUCHI},
    {"MSG_SETCUR", _MENU_EXE_MSGSETCURSOR},
    {"MSG_SETGYOU", _MENU_SET_QUESTIONGYOU},
    {"MSG_SPD", _MENU_SET_OPENSPEED},
    {"IN_KEY", _MENU_INPUT_KEY},
    {"CURSOR_ONOFF", _MENU_CURSOR_ONOFF},
    {"CURSOR_FADE", _MENU_CURSOR_FADE},
    {"SET_WAKU", _MENU_WAKUTYPE},
    {"SCN_FADE", _MENU_SCENE_FADE},
    {"SE_ON", _MENU_SE_PLAY},
    {"PRINT", _MENU_DEBUG_PRINTF},
    {NULL, NULL},
};

/**
 *
 * First item category used by the next sorting pass.
 *
 */
static short sort_top_type = 1;

u8 MenuSePlayUsedFlag;

/**
 *
 * Volume of the object sound port before the menu silences it.
 *
 */
static float SndPortVol_Ob;

/**
 *
 * Volume of the base sound port before the menu silences it.
 *
 */
static float SndPortVol_Base;

/**
 *
 * Volume of the event sound port before the menu silences it.
 *
 */
static float SndPortVol_Event;

/**
 *
 * Whether the menu also silences the event sound port.
 *
 */
static int SndPortCheck_EventPort;

/**
 *
 * Environment music volume before the menu silences it.
 *
 */
static float SndPortVol_Env;

/**
 *
 * First texture-information slot of the current script block.
 *
 */
static u16 MenuTexPosNo;

/**
 *
 * Texture-information offset within the current script block.
 *
 */
static u16 MenuTexPosNo_local;

/**
 *
 * Texture block assigned to the current script texture.
 *
 */
static short menu_analyze_texblock;

mgCMemory *MenuSpiStack;

/**
 *
 * First miscellaneous-information slot of the current script block.
 *
 */
static u16 Menu_Target_No;

/**
 *
 * Miscellaneous-information offset within the current script block.
 *
 */
static u16 Menu_Target_No_local;

/**
 *
 * Form receiving the current menu layout script entries.
 *
 */
static CMenuPosDataForm *menu_formPt;

/**
 *
 * Part receiving the current menu layout script entries.
 *
 */
static MENUFORMPARTS_TYPE *menu_form_part;

/**
 *
 * Next effect entry receiving script parameters.
 *
 */
static MENU_PARTS_EFFECT_STRUCT1 *menu_parts_effect_ptr;

/**
 *
 * Form index selected by the layout script.
 *
 */
static short menu_analyze_formno;

/**
 *
 * Offset added to form indices in the current script block.
 *
 */
static short menu_analyze_formno_offset;

/**
 *
 * Next part index receiving a layout script entry.
 *
 */
static int menu_form_partsno;

/**
 *
 * Next action entry receiving layout script parameters.
 *
 */
static MENU_FORM_ACTION *menu_spi_form_action_info;

/**
 *
 * Whether the command interpreter is executing the selected command block.
 *
 */
static u8 SpiMenuExeCommandFlag;

/**
 *
 * Texture name copied into entries of the current texture-information block.
 *
 */
static char MenuSpiTextureName[0x20];

MENU_COMMAND_ANALYZE_INFO MenuCommandAnalyzeInfo;

static inline unsigned int align16_blocks(unsigned int n) {
    if (n & 0xF) {
        return (n >> 4) + 1;
    }

    return n >> 4;
}

#include "common.h"

// Code (.text)
int GetRandI(int range) {
    return rand() % range;
}

float GetRandF(float range) {
    return range * mgRnd();
}

/**
 *
 * Recenters a bounding box around its midpoint.
 *
 */
static void ReCalcBox(mgVu0FBOX *out, mgVu0FBOX box) {
    float center_x = (box.max[0] + box.min[0]) / 2.0f;
    float center_y = (box.max[1] + box.min[1]) / 2.0f;
    float center_z = (box.max[2] + box.min[2]) / 2.0f;
    out->max[0] = box.max[0] - center_x;
    out->max[1] = box.max[1] - center_y;
    out->max[2] = box.max[2] - center_z;
    out->min[0] = box.min[0] - center_x;
    out->min[1] = box.min[1] - center_y;
    out->min[2] = box.min[2] - center_z;
    out->min[3] = 1.0f;
    out->max[3] = 1.0f;
}

float MenuAdjustPolygonScale(mgCFrame *frame, float size) {
    mgVu0FBOX box;

    if (frame == NULL) {
        return 1.0f;
    }

    (frame)->GetWorldBBox(&box);
    return MenuAdjustPolygonScale(box, size);
}

float MenuAdjustPolygonScale(mgVu0FBOX box, float size) {
    mgVu0FBOX centered_box;
    ReCalcBox(&centered_box, box);
    mgVu0FBOX target_box;
    target_box.max[0] = size;
    target_box.max[1] = size;
    target_box.max[2] = size;
    target_box.max[3] = 1.0f;
    float size_distance = mgDistVector(target_box.max);
    float box_distance = mgDistVector(centered_box.max);
    float scale = 1.0f;

    if (box_distance != 0.0f) {
        scale = size_distance / box_distance;

        if (scale <= 0.0f) {
            scale = -scale;
        }
    }

    return scale;
}

void MenuAdjustPolygonScale(CCharacter2 *chara, float size) {
    if (chara != NULL) {
        float magnitude;
        float height = chara->body_height;
        float scale = 1.0f;
        magnitude = height;

        if (height < 0.0f) {
            magnitude = -height;
        }

        if (!(magnitude <= 1.0f)) {
            scale = size / height;
        }

        chara->SetScale(scale, scale, scale);
    }
}

void AddRotationCharaY(CCharacter2 *chara, float angle) {
    float rotation[4];

    if (chara != NULL) {
        chara->GetRotation(rotation);
        float *rotation_y = &rotation[1];
        *rotation_y += angle;
        *rotation_y = mgAngleLimit(*rotation_y);
        chara->SetRotation(rotation);
    }
}

void MenuSePlay(int sound_no) {
    if (sound_no >= 0) {
        MenuSePlay(SystemSND_ID, sound_no);
    }
}

void MenuSePlay(unsigned int handle, int sound_no) {
    if (sound_no >= 0) {
        sndSePlay(handle, sound_no, 0);
    }
}

void MenuSePlay(int sound_no, unsigned int *bank, mgCMemory *memory) {
    if (bank == NULL || memory == NULL) {
        return;
    }

    memory->stack_used = 0;
    memory->lock = 0;
    sndInitPort(8);
    sndSePlay(sndLoadSound(8, bank, memory), sound_no, 0);
    MenuSePlayUsedFlag = 1;
}

void StopEnvSoundMenu(int event_port) {
    SndPortVol_Ob = sndGetPortVol(1);
    SndPortVol_Base = sndGetPortVol(3);
    sndSetPortVol(1, 0.0f);
    sndSetPortVol(3, 0.0f);
    SndPortCheck_EventPort = event_port;

    if (event_port != 0) {
        SndPortVol_Event = sndGetPortVol(4);
        sndSetPortVol(4, 0.0f);
    }

    SndPortCheck_EventPort = event_port;
    SndPortVol_Env = GetMainScene()->GetEnvBGMVol();
    GetMainScene()->SetEnvBGMVol(0.0f);
}

void ReStartEnvSoundMenu() {
    sndSetPortVol(1, SndPortVol_Ob);
    sndSetPortVol(3, SndPortVol_Base);

    if (SndPortCheck_EventPort != 0) {
        sndSetPortVol(4, SndPortVol_Event);
    }

    GetMainScene()->SetEnvBGMVol(SndPortVol_Env);
}

/**
 *
 * Compares item identifiers by their configured inventory category and item number.
 *
 */
int CompGameData(int item_a, int item_b) {
    CGameData   *game_data;
    CDataCommon *record_a;
    CDataCommon *record_b;
    int          rank_a;
    int          rank_b;

    game_data = GetGameDataPt();
    record_a = game_data->GetCommonData(item_a);
    record_b = game_data->GetCommonData(item_b);
    rank_b = 0;
    rank_a = 0;

    if (record_a != NULL) {
        rank_a = sort_table[record_a->type];
    }

    if (record_b != NULL) {
        rank_b = sort_table[record_b->type];
    }

    if (item_a <= 0) {
        rank_a = sort_type_count;
    }

    if (item_b <= 0) {
        rank_b = sort_type_count;
    }

    if (rank_b < rank_a) {
        return 1;
    }

    if (rank_a < rank_b) {
        return -1;
    }

    if (item_b < item_a) {
        return 1;
    }

    if (item_a < item_b) {
        return -1;
    }

    return 0;
}

/**
 *
 * Sorts an item board using the current inventory category order.
 *
 */
int SeitonItemBoardSub(CGameDataUsed *items, int count) {
    CGameDataUsed *board;
    int            i;
    int            sort_type;
    int            j;
    u8             swapped;

    board = items;
    sort_type = sort_top_type;

    for (i = 0; i < sort_type_count; i++) {
        sort_table[sort_type] = i;
        sort_type++;

        if (sort_type >= sort_type_count) {
            sort_type = 0;
        }
    }

    sort_table[0] = sort_type_count;
    swapped = 0;

    for (i = 0; i < count - 1; i++) {
        for (j = i + 1; j < count; j++) {
            if (CompGameData(board[i].item_no, board[j].item_no) > 0) {
                GameDataSwap(&board[i], &board[j], 1);
                swapped = 1;
            }
        }
    }

    return swapped;
}

int MenuSeiton(CGameDataUsed *items, int count) {
    CGameDataUsed *board = items;
    int            i;
    int            j;
    int            attempt;
    CGameDataUsed *second;
    int            room;
    int            moved;
    CGameDataUsed *first;

    if (board == NULL) {
        return 0;
    }

    for (i = 0; i < count; i++) {
        first = &board[i];

        if (first->CheckTypeEnableStack() != 0) {
            for (j = i + 1; j < count; j++) {
                second = &board[j];

                if (first->item_no == second->item_no) {
                    room = first->CheckStackRemain();

                    if (room <= 0) {
                        break;
                    }

                    moved = second->GetNum();

                    if (room < moved) {
                        moved = room;
                    }

                    first->AddNum(moved, 1);
                    second->DeleteNum(moved);
                }
            }
        }
    }

    for (attempt = 0; attempt < sort_type_count; attempt++) {
        if (SeitonItemBoardSub(board, count) != 0) {
            break;
        }

        sort_top_type += 1;

        if (sort_top_type >= sort_type_count) {
            sort_top_type = 1;
        }
    }

    return 1;
}

int GetSameAdrressUserData(CGameDataUsed *item, int kind) {
    CGameDataUsed *entry;
    int            bag_max;
    int            i;

    if (kind == 0) {
        entry = MenuUserParam.used_data;
        bag_max = GetNowBagMax(1);

        for (i = 0; i < bag_max; i++, entry++) {
            if (entry == item) {
                return i;
            }
        }
    }

    return -1;
}

void local_sort1(int &cursor, int *count, int *list) {
    int i;

    for (i = cursor; i < *count; i++) {
        list[i] = list[i + 1];
    }

    *count -= 1;

    if (cursor > 0) {
        cursor -= 1;
    }
}

int GetNowChapter(CSaveData *save) {
    int progress;

    if (save == NULL) {
        return -1;
    }

    progress = save->game_progress;

    if (progress < 2) {
        return 0;
    }

    if (progress == 2 || progress == 3) {
        return 1;
    }

    if (progress >= 4) {
        return progress - 2;
    }

    if (progress >= 100) {
        return 1;
    }

    return 1;
}

u_long128 *MenuCalcBufAlignment(u_long128 *buffer) {
    int aligned;
    int blocks;
    int size = (int) buffer;

    aligned = size;

    if ((size % 64) != 0) {
        blocks = size >> 6;

        if (size < 0) {
            blocks = (size + 0x3F) >> 6;
        }

        aligned = (blocks + 1) << 6;
    }

    return (u_long128 *) aligned;
}

int LoadFileMenu(char *name, u_long128 *buffer, int mode) {
    char path[0x8C];
    int  size;

    if (name == NULL || buffer == NULL) {
        return -1;
    }

    strcpy(path, "menu/");
    strcat(path, langdirpathTable_1161[LanguageCode]);
    strcat(path, name);

    if (mode == 0) {
        LoadFileBG(path, buffer, &size);
    }

    if (mode == 1) {
        LoadFile2(path, buffer, &size, 0);
    }

    return size;
}

void ConvertFontCode(char *source, char *destination) {
    if (source != NULL) {
        if (destination == NULL) {
            return;
        }
    } else {
        return;
    }

    if (CheckNowEurope()) {
        while ((s8) *source != 0) {
            if ((s8) *source == '[') {
                if ((s8) source[5] == '0') {
                    s8 character_code = 0;

                    for (int index = 0; index < 16; index++) {
                        if ((s8) source[6] == mes_cord_conv_1193[index][0]) {
                            character_code = mes_cord_conv_1193[index][1] << 4;
                            break;
                        }
                    }

                    for (int index = 0; index < 16; index++) {
                        if ((s8) source[7] == mes_cord_conv_1193[index][0]) {
                            character_code += mes_cord_conv_1193[index][1];
                            break;
                        }
                    }

                    *destination++ = character_code;
                    source += 9;
                } else if ((s8) source[5] == '1') {
                    s8 character_code = 0;

                    for (int index = 0; index < 16; index++) {
                        if ((s8) source[6] == mes_cord_conv_1193[index][0]) {
                            character_code = mes_cord_conv_1193[index][1] << 4;
                            break;
                        }
                    }

                    for (int index = 0; index < 16; index++) {
                        if ((s8) source[7] == mes_cord_conv_1193[index][0]) {
                            character_code += mes_cord_conv_1193[index][1];
                            break;
                        }
                    }

                    if (character_code == 0x52) {
                        *destination = (s8) 0xBD;
                    } else if (character_code == 0x53) {
                        *destination = (s8) 0xBE;
                    } else {
                        *destination = character_code;
                    }

                    destination++;
                    source += 9;
                }
            } else {
                *destination = *source;
                destination++;
                source++;
            }
        }

        *destination = 0;
    } else {
        strcpy(destination, source);
    }
}

int CheckNowEurope() {
    if (LanguageCode > 0 && LanguageCode < 6) {
        return 1;
    }

    return 0;
}

int MenuCommonReadData(mgCMemory *memory, char **names, int mode) {
    int          total;
    int          i;
    unsigned int size;

    StartReadBG();
    total = 0;
    memory->Align64();

    i = 0;

    while (*(char **) ((u8 *) names + i) != NULL) {
        size = LoadFileMenu(*(char **) ((u8 *) names + i), memory->stack + memory->stack_used, mode);
        memory->Alloc(align16_blocks(size));
        total += size;
        i += 4;
        memory->Align64();
    }

    return total;
}

void MenuDeleteTextureBlock(int *blocks) {
    mgCTextureManager *manager = &mgTexManager;
    int                i = 0;
    int                block;

    while ((block = blocks[i]) >= 0 && i < 16) {
        manager->DeleteBlock(block);
        i++;
    }
}

void MenuWorkTextureEnter(int id, char *name, int width, int height, int format) {
    mgCTextureManager *manager = &mgTexManager;
    int                width_rest = width % 64;

    if (width_rest != 0) {
        width += 64 - width_rest;
    }

    int height_rest = height % 64;

    if (height_rest != 0) {
        height += 64 - height_rest;
    }

    manager->EnterTexture(id, name, NULL, width, height, format, NULL, 0, 0);
}

void MenuEnterIMG(int size, u8 *data, char *name) {
    mgCTextureManager *manager = &mgTexManager;

    if (name == NULL) {
        manager->name_suffix[0] = 0;
    } else {
        strcpy(manager->name_suffix, name);
    }

    manager->EnterIMGFile(data, size, NULL, NULL);
    manager->name_suffix[0] = 0;
}

BG_READ_INFO *GetReadBGInfo(char *name) {
    char path[0x80];
    GetCurrentDir(path);
    strcat(path, name);
    return GetReadBGFile(path);
}

void CalcMenu1(float target, float *value, float divisor, float snap_range, int snap) {
    *value += (target - *value) / divisor;

    if (snap != 0 || (float) abs(fptosi(target - *value)) < snap_range) {
        *value = target;
    }
}

void CalcMenu1(int target, int *value, int divisor, int snap_range, int snap) {
    *value += (target - *value) / divisor;

    if (snap != 0 || abs(target - *value) < snap_range) {
        *value = target;
    }
}

int CalcMenuAdd(int *cursor, int step, int limit) {
    if (cursor == NULL) {
        return -1;
    }

    *cursor += step;

    if ((step < 0 && *cursor < limit) || (step > 0 && *cursor > limit)) {
        *cursor = limit;
        return 1;
    }

    return 0;
}

int CalcMenuAdd(float *cursor, float step, float limit) {
    if (cursor == NULL) {
        return -1;
    }

    *cursor += step;

    if ((step < 0.0f && *cursor < limit) || (step > 0.0f && *cursor > limit)) {
        *cursor = limit;
        return 1;
    }

    return 0;
}

int CalcMenuAdd2(int *value, int delta, int limit) {
    if (value == NULL) {
        return -1;
    }

    if ((delta < 0) && ((*value + delta) < limit)) {
        return 1;
    }

    if ((delta > 0) && (limit < (*value + delta))) {
        return 1;
    }

    *value += delta;
    return 0;
}

int GetNumberKeta(int value) {
    int digits = 1;
    int number = abs(value);

    while (9 < number) {
        number /= 10;
        digits++;
    }

    return digits;
}

int GetDispVolumeForFloat(float volume) {
    int whole;

    whole = fptosi(volume);

    if ((volume - (float) whole) < 0.00005f) {
        return whole;
    }

    return whole + 1;
}

float GetFloatCommaValue(float value) {
    return value - (float) fptosi(value);
}
int CalcScrlBarPutPos(int top, float pos, int length, float pos_max) {
    int y = top;
    if (pos_max != 0.0f) {
        y = (int)((float)top + length * (pos / pos_max));
    }
    return y;
}
void Trans3DPosTo2DPos(mgCCamera *camera, mgCFrame *frame, int *out) {
    float view[4][4];
    float camera_pos[4];
    float frame_pos[4];

    if (camera == NULL || frame == NULL) {
        return;
    }

    camera->GetCameraMatrix(view);
    camera->GetPos(camera_pos);
    mgSetViewMatrix(view, camera_pos);
    frame->GetPosition(frame_pos);
    mgTransWorldScreen(out, frame_pos);
}

/**
 *
 * Allocates and clears the menu's integer extra-information table.
 *
 */
int _ETCINFO_MALLOC(SPI_STACK *stack, int arg_count) {
    int             count;
    CPosDataManage *data;
    MENU_ETCINFO   *table;

    count = default_etc_count;

    if (arg_count > 0) {
        count = spiGetStackInt(stack);
    }

    table = (MENU_ETCINFO *) MenuSpiStack->Alloc(
        align16_blocks(count * sizeof(MENU_ETCINFO)));
    data = MenuPosData;
    data->etc_tbl = table;
    data->etc_tbl_num = count;
    MenuPosData->EtcTblClear(0, count);
    return 1;
}

/**
 *
 * Sets the starting index for subsequent integer extra-information entries.
 *
 */
int _MENU_ETCINFO_OFFSET(SPI_STACK *stack, int arg_count) {
    Menu_Target_No = spiGetStackInt(stack);
    Menu_Target_No_local = 0;
    return 1;
}

/**
 *
 * Stores a named integer extra-information entry from the menu script.
 *
 */
int _MENU_ETCINFO(SPI_STACK *stack, int arg_count) {
    int           index;
    char         *name;
    int           i;
    MENU_ETCINFO *entry;

    index = (short) Menu_Target_No + (short) Menu_Target_No_local;

    if (index >= MenuPosData->etc_tbl_num) {
        return 1;
    }

    entry = MenuPosData->etc_tbl + index;
    name = spiGetStackString(stack++);

    if (entry->name != NULL) {

        for (i = 0; i < index; i++) {
            if (strcmp(entry->name, name) == 0) {
                return 1;
            }
        }

        return 1;
    }

    entry->name = mgCopyString(name, MenuSpiStack);
    entry->value[0] = spiGetStackInt(stack++);
    entry->value[1] = spiGetStackInt(stack);
    Menu_Target_No_local = (short) Menu_Target_No_local + 1;
    return 1;
}

/**
 *
 * Clears a selected range of integer extra-information entries.
 *
 */
int _MENU_ETCINFO_CLEAR(SPI_STACK *stack, int arg_count) {
    int from;
    int to;

    from = spiGetStackInt(stack++);
    to = 1000;

    if (arg_count > 1) {
        to = spiGetStackInt(stack);
    }

    if (arg_count <= 1 || MenuPosData->etc_tbl_num < to) {
        to = MenuPosData->etc_tbl_num;
    }

    MenuPosData->EtcTblClear(from, to);
    return 1;
}

/**
 *
 * Allocates and clears the menu's floating-point extra-information table.
 *
 */
int _ETCINFO2_MALLOC(SPI_STACK *stack, int arg_count) {
    int             count;
    CPosDataManage *data;
    MENU_ETCINFO2  *table;

    count = default_etc_count;

    if (arg_count > 0) {
        count = spiGetStackInt(stack);
    }

    table = (MENU_ETCINFO2 *) MenuSpiStack->Alloc(
        align16_blocks(count * sizeof(MENU_ETCINFO2)));
    data = MenuPosData;
    data->etc_tbl2 = table;
    data->etc_tbl2_num = count;
    MenuPosData->EtcTbl2Clear(0, count);
    return 1;
}

/**
 *
 * Sets the starting index for floating-point extra-information entries.
 *
 */
int _MENU_ETCINFO2_OFFSET(SPI_STACK *stack, int arg_count) {
    Menu_Target_No = spiGetStackInt(stack);
    Menu_Target_No_local = 0;
    return 1;
}

/**
 *
 * Stores a named floating-point extra-information entry from the menu script.
 *
 */
int _MENU_ETCINFO2(SPI_STACK *stack, int arg_count) {
    int            index;
    char          *name;
    int            i;
    int            j;
    MENU_ETCINFO2 *entry;

    index = (short) Menu_Target_No + (short) Menu_Target_No_local;

    if (index >= MenuPosData->etc_tbl2_num) {
        return 1;
    }

    entry = MenuPosData->etc_tbl2 + index;
    name = spiGetStackString(stack++);

    if (entry->name != NULL) {
        for (i = 0; i < index; i++) {
            if (strcmp(entry->name, name) == 0) {
                return 1;
            }
        }
    }

    entry->name = mgCopyString(name, MenuSpiStack);

    for (j = 0; j < arg_count - 1; j++) {
        entry->value[j] = spiGetStackFloat(stack++);
    }

    Menu_Target_No_local = (short) Menu_Target_No_local + 1;
    return 1;
}

/**
 *
 * Clears a selected range of floating-point extra-information entries.
 *
 */
int _MENU_ETCINFO2_CLEAR(SPI_STACK *stack, int arg_count) {
    CPosDataManage *data;
    int             from;
    int             to;
    int             count;

    from = spiGetStackInt(stack++);
    to = 1000;

    if (arg_count > 1) {
        to = spiGetStackInt(stack);
    }

    data = MenuPosData;
    count = data->etc_tbl2_num;

    if (arg_count <= 1 || count < to) {
        to = count;
    }

    data->EtcTbl2Clear(from, to);
    return 1;
}

/**
 *
 * Resets all texture information held by the menu position manager.
 *
 */
int _MENU_RESET_TEXINFO(SPI_STACK *stack, int arg_count) {
    MenuPosData->ResetTextureInfoAll();
    return 1;
}

/**
 *
 * Initializes the menu form drawing list.
 *
 */
int _MENU_INIT_DRAWLIST(SPI_STACK *stack, int arg_count) {
    MenuPosData->InitDrawList();
    return 1;
}

/**
 *
 * Clears a selected range of menu texture records.
 *
 */
int _MENU_TEXDATA_CLEAR(SPI_STACK *stack, int argc) {
    int from = spiGetStackInt(stack++);
    int to = 500;

    if (argc > 1) {
        to = spiGetStackInt(stack);
    }

    CPosDataManage *pos_data = MenuPosData;
    int             count = pos_data->tex_info_num;

    if (!(argc > 1) || count < to) {
        to = count;
    }

    pos_data->TexGetInfoClear(from, to);
    return 1;
}

/**
 *
 * Clears menu forms and resets their drawing list.
 *
 */
int _MENU_FORM_CLEAR(SPI_STACK *stack, int argc) {
    int from = 0;
    int to = 100;

    if (argc == 2) {
        from = spiGetStackInt(stack++);
        to = spiGetStackInt(stack);
    }

    MenuPosData->FormInfoClear(from, to);
    MenuPosData->InitDrawList();
    return 1;
}

/**
 *
 * Allocates the menu texture record table from a scripted count.
 *
 */
int _MENU_TEXDATA_MALLOC(SPI_STACK *stack, int argc) {
    int          count = 256;
    unsigned int bytes;
    unsigned int blocks;

    if (argc > 0) {
        count = spiGetStackInt(stack);
    }

    bytes = count * 0x20;

    if (bytes & 0xF) {
        blocks = (bytes >> 4) + 1;
    } else {
        blocks = bytes >> 4;
    }

    MENU_BASETEXINFO *table = (MENU_BASETEXINFO *) MenuSpiStack->Alloc(blocks);
    CPosDataManage   *pos_data = MenuPosData;
    pos_data->tex_info = table;
    pos_data->tex_info_num = count;
    return 1;
}

/**
 *
 * Selects the texture pack name and block used by following texture records.
 *
 */
int _MENU_TEXNAME(SPI_STACK *stack, int argc) {
    SPI_STACK *block_arg = stack + 1;
    char      *name = spiGetStackString(stack);

    if (name != NULL) {
        strcpy(MenuSpiTextureName, name);
    }

    int index = spiGetStackInt(block_arg);

    struct {
        u8 prefix[0xC];

        struct {
            short block;
            short tail;
        } entries[16];
    } *common = (typeof(common)) MenuCommonInfo;

    menu_analyze_texblock = common->entries[index].block;
    return 1;
}

/**
 *
 * Sets the starting index for following menu texture records.
 *
 */
int _MENU_TEXDATA_OFFSET(SPI_STACK *stack, int argc) {
    MenuTexPosNo = spiGetStackInt(stack);
    MenuTexPosNo_local = 0;
    return 1;
}

/**
 *
 * Stores a named menu texture region and its source rectangle.
 *
 */
int _MENU_TEXDATA(SPI_STACK *stack, int argc) {
    char             *name;
    int               x;
    int               y;
    int               w;
    int               h;
    int               no;
    MENU_BASETEXINFO *slot;

    name = spiGetStackString(stack++);
    x = spiGetStackInt(stack++);
    y = spiGetStackInt(stack++);
    w = spiGetStackInt(stack++);
    h = spiGetStackInt(stack);
    no = MenuTexPosNo + MenuTexPosNo_local;
    slot = MenuPosData->GetTexGetInfo(no);

    if (slot == NULL) {
        return 0;
    }

    if (MenuPosData->GetTexGetInfo(name) != 0) {
        return 0;
    }

    slot->tex_name = mgCopyString(MenuSpiTextureName, MenuSpiStack);
    slot->tex_block = (signed char) menu_analyze_texblock;
    slot->tbl_no = no;
    slot->name = mgCopyString(name, MenuSpiStack);
    slot->rect.Set(x, y, w, h);
    MenuTexPosNo_local += 1;
    return 1;
}

/**
 *
 * Allocates and clears the menu form table.
 *
 */
int _MENU_FORM_MALLOC(SPI_STACK *stack, int argc) {
    int          count = spiGetStackInt(stack);
    unsigned int bytes = count << 7;
    unsigned int blocks;

    if (bytes & 0xF) {
        blocks = (bytes >> 4) + 1;
    } else {
        blocks = bytes >> 4;
    }

    u_long128        *block = MenuSpiStack->Alloc(blocks + 2);
    CMenuPosDataForm *table = (CMenuPosDataForm *) operator new[](bytes, block);
    CPosDataManage   *pos_data = MenuPosData;
    pos_data->form = table;
    pos_data->form_num = count;
    MenuPosData->FormInfoClear(0, count);
    return 1;
}

/**
 *
 * Sets the starting index for following menu forms.
 *
 */
int _MENU_FORM_OFFSET_NO(SPI_STACK *stack, int argc) {
    menu_analyze_formno = spiGetStackInt(stack);
    menu_analyze_formno_offset = 0;
    return 1;
}

/**
 *
 * Initializes a named menu form at the selected table index.
 *
 */
int _MENU_FORM_SET(SPI_STACK *stack, int argc) {
    char      *name = spiGetStackString(stack++);
    int        form_no;
    SPI_STACK *next_slot = stack;
    form_no = menu_analyze_formno + menu_analyze_formno_offset;

    if (argc > 2) {
        form_no = menu_analyze_formno + spiGetStackInt(next_slot);
    }

    menu_formPt = NULL;

    if (MenuPosData->GetFormInfo(name) != 0) {
        return 0;
    }

    menu_formPt = MenuPosData->GetFormInfo(form_no);

    if (menu_formPt != NULL) {
        menu_formPt->Initialize();
        menu_formPt->name = mgCopyString(name, MenuSpiStack);
    }

    menu_formPt->active = 1;
    menu_formPt->draw_flag = 1;
    menu_form_partsno = 0;
    menu_analyze_formno_offset += 1;
    return 1;
}

/**
 *
 * Allocates and initializes the parts of the current menu form.
 *
 */
int _MENU_FORM_PARTNUM(SPI_STACK *stack, int argc) {
    int          i;
    unsigned int bytes;
    unsigned int blocks;

    if (menu_formPt == NULL) {
        return 0;
    }

    menu_formPt->parts_num = spiGetStackInt(stack);
    bytes = menu_formPt->parts_num * sizeof(MENUFORMPARTS_TYPE);

    if (bytes & 0xF) {
        blocks = (bytes >> 4) + 1;
    } else {
        blocks = bytes >> 4;
    }

    menu_formPt->parts = (MENUFORMPARTS_TYPE *) MenuSpiStack->Alloc(blocks);

    for (i = 0; i < menu_formPt->parts_num; i++) {
        MenuPosDataTypeInit(&menu_formPt->parts[i]);
    }

    return 1;
}

/**
 *
 * Copies the referenced texture region's size into a menu form part.
 *
 */
void menu_texdata_to_formpart_copy(MENUFORMPARTS_TYPE *part) {
    MENU_BASETEXINFO *tex = MenuPosData->GetTexGetInfo(part->tex_info_no);
    part->w = 0;
    part->h = 0;

    if (tex != NULL) {
        part->w = tex->rect.right;
        part->h = tex->rect.bottom;
    }
}

int menu_spi_analyze_func_strcut1(MENU_SPI_ANALYZE_STRUCT1 *table, char *name) {
    int i = 0;

    while (1) {
        char *entry_name = table[i].name;

        if (entry_name == NULL) {
            break;
        }

        if (strcmp(entry_name, name) == 0) {

            return table[i].value;
        }

        i++;
    }

    return -1;
}

/**
 *
 * Initializes type-specific data for the current menu form.
 *
 */
int menu_dtype_init(CMenuPosDataForm *form, SPI_STACK *stack, int argc) {
    if (menu_formPt == NULL) {
        return 0;
    }

    if (form->dtype == MENUFORM_DTYPE_POLY) {
        menu_formPt->ambient[0] = 64.0f;
        menu_formPt->ambient[1] = 64.0f;
        menu_formPt->ambient[2] = 64.0f;
        menu_formPt->ambient[3] = 128.0f;

        if (argc == 5) {
            menu_formPt->ambient[0] = spiGetStackFloat(stack++);
            menu_formPt->ambient[1] = spiGetStackFloat(stack++);
            menu_formPt->ambient[2] = spiGetStackFloat(stack++);
            menu_formPt->ambient[3] = spiGetStackFloat(stack);
        }
    } else if (form->dtype == MENUFORM_DTYPE_ITEMBRD) {
        menu_formPt->parts_num = 150;
        menu_formPt->parts = (MENUFORMPARTS_TYPE *) MenuSpiStack->Alloc(
            align16_blocks(menu_formPt->parts_num * sizeof(MENUFORMPARTS_TYPE)));
        MenuItemBrdItemIconEffectMalloc(MenuSpiStack, menu_formPt->parts, menu_formPt->parts_num);
    } else if (form->dtype == MENUFORM_DTYPE_GEOLIST) {
        form->sub_no = spiGetStackInt(stack);
    } else if (form->dtype == MENUFORM_DTYPE_MSGFORM) {
        char message_slot_text[8];
        message_slot_text[0] = menu_formPt->name[3];
        message_slot_text[1] = 0;
        form->sub_no = atoi(message_slot_text);
    }

    return 1;
}

/**
 *
 * Resolves and initializes the current menu form's drawing type.
 *
 */
int _MENU_FORM_DTYPE(SPI_STACK *stack, int argc) {
    char *name;

    if (menu_formPt == NULL) {
        return 0;
    }

    name = spiGetStackString(stack++);

    if (name == NULL) {
        return 0;
    }

    menu_formPt->dtype = menu_spi_analyze_func_strcut1(tbl_1728, name);
    menu_dtype_init(menu_formPt, stack, argc);
    return 1;
}

/**
 *
 * Sets the current menu form's movement type from a scripted name.
 *
 */
int _MENU_FORM_MTYPE(SPI_STACK *stack, int argc) {
    char *name = spiGetStackString(stack);
    int   type = -1;
    int   i = 0;
    char *entry;

    while ((entry = tbl_1759[i]) != 0) {
        if (strcmp(name, entry) == 0) {
            type = i - 1;
            break;
        }

        i++;
    }

    if (type < -1) {
        type = -1;
    }

    menu_formPt->mtype = type;
    return 1;
}

/**
 *
 * Sets the drawing flag of the current or a named menu form.
 *
 */
int _MENU_FORM_DRAWFLG(SPI_STACK *stack, int argc) {
    CMenuPosDataForm *form;

    if (menu_formPt == NULL) {
        return 0;
    }

    if (argc == 1) {
        menu_formPt->draw_flag = (spiGetStackInt(stack++) != 0);
    }

    if (argc == 2) {
        form = MenuPosData->GetFormInfo(spiGetStackString(stack++));
        int value = spiGetStackInt(stack);

        if (form != NULL) {
            form->draw_flag = (value != 0);
        }
    }

    return 1;
}

/**
 *
 * Sets the current menu form's vibration counts.
 *
 */
int _MENU_FORM_VIBECNT(SPI_STACK *stack, int argc) {
    SPI_STACK *next_slot = stack + 1;

    if (menu_formPt == NULL) {
        return 0;
    }

    menu_formPt->vibe_cnt[0] = spiGetStackInt(stack);
    menu_formPt->vibe_cnt[1] = spiGetStackInt(next_slot);
    return 1;
}

/**
 *
 * Accepts the end marker of a menu form definition.
 *
 */
int _MENU_FORM_SETEND(SPI_STACK *stack, int argc) {
    return 1;
}

/**
 *
 * Sets the current menu form's horizontal and vertical movement rates.
 *
 */
int _MENU_FORM_MOVERATE(SPI_STACK *stack, int argc) {
    SPI_STACK *next_slot = stack + 1;

    if (menu_formPt == 0) {
        return 0;
    }

    menu_formPt->rate_x = spiGetStackFloat(stack);
    menu_formPt->rate_y = spiGetStackFloat(next_slot);
    return 1;
}

/**
 *
 * Sets the current menu form's screen position.
 *
 */
int _MENU_FORM_PUTXY(SPI_STACK *stack, int argc) {
    SPI_STACK *next_slot = stack + 1;

    if (menu_formPt == 0) {
        return 0;
    }

    menu_formPt->x = (float) spiGetStackInt(stack);
    menu_formPt->y = (float) spiGetStackInt(next_slot);
    return 1;
}

/**
 *
 * Sets the current menu form's color channels and resets their animation parameters.
 *
 */
int _MENU_FORM_RGBA(SPI_STACK *stack, int argc) {
    int               values[4];
    int               i;
    int               step;
    CMenuPosDataForm *form;

    if (menu_formPt == NULL) {
        return 0;
    }

    for (i = 0; i < argc; i++) {
        values[i] = spiGetStackInt(stack++);
    }

    if (argc == 3) {
        form = menu_formPt;
        form->rgba[0] = (signed char) values[0];
        form->rgba[1] = (signed char) values[1];
        form->rgba[2] = (signed char) values[2];
        form->rgba[3] = 0x80;

        for (step = 0; step < 4; step++) {
            form->SetRGBACalcParam(step, 0, 0x80);
        }
    }

    if (argc == 4) {
        form = menu_formPt;
        form->rgba[0] = (signed char) values[0];
        form->rgba[1] = (signed char) values[1];
        form->rgba[2] = (signed char) values[2];
        form->rgba[3] = (signed char) values[3];

        for (i = 0; i < 4; i++) {
            form->SetRGBACalcParam(i, 0, 0x80);
        }
    }

    return 1;
}

/**
 *
 * Selects which color channels a menu form may animate.
 *
 */
int _MENU_FORM_RGBA_BIT(SPI_STACK *stack, int argc) {
    u8    mask;
    char *text = spiGetStackString(stack);
    char *channels = text;
    mask = 0;
    int length = strlen(text);

    for (int index = 0; index < length; index++, channels++) {
        s8 channel = *channels;
        u8 bit = 0;

        if (channel == 'r') {
            bit = 1;
        }

        if (channel == 'g') {
            bit = 2;
        }

        if (channel == 'b') {
            bit = 4;
        }

        if (channel == 'a') {
            bit = 8;
        }

        if (mask != 0) {
            mask |= bit;
        } else {
            mask = bit;
        }
    }

    menu_formPt->rgba_bit = mask;
    return 1;
}

/**
 *
 * Allocates the current menu form's named action table.
 *
 */
int _MENU_ACTION_TABLE_NUM(SPI_STACK *stack, int argc) {
    int               count;
    MENU_FORM_ACTION *table;
    unsigned int      bytes;
    unsigned int      blocks;

    if (menu_formPt == NULL) {
        return 0;
    }

    count = spiGetStackInt(stack);
    bytes = count * 0x14;

    if (bytes & 0xF) {
        blocks = (bytes >> 4) + 1;
    } else {
        blocks = bytes >> 4;
    }

    table = (MENU_FORM_ACTION *) MenuSpiStack->Alloc(blocks);
    menu_formPt->action = table;
    menu_formPt->action_num = count;
    menu_spi_form_action_info = table;
    return 1;
}

/**
 *
 * Defines one named menu form movement action.
 *
 */
int _MENU_ACTION_DEF(SPI_STACK *stack, int argc) {
    MENU_FORM_ACTION_MOVE *action;
    strcpy(menu_spi_form_action_info->name, spiGetStackString(stack++));
    menu_spi_form_action_info->move = (MENU_FORM_ACTION_MOVE *) MenuSpiStack->Alloc(2);
    action = menu_spi_form_action_info->move;
    action->mtype = spiGetStackInt(stack++);
    action->x = spiGetStackFloat(stack++);
    action->y = spiGetStackFloat(stack++);
    action->rate_x = spiGetStackFloat(stack++);
    action->rate_y = spiGetStackFloat(stack);
    menu_spi_form_action_info++;
    return 1;
}

/**
 *
 * Selects the current menu form's active named action.
 *
 */
int _MENU_ACTION_SETACTION(SPI_STACK *stack, int argc) {
    if (menu_formPt == NULL) {
        return 0;
    }

    menu_formPt->SetAction(spiGetStackString(stack));
    return 1;
}

/**
 *
 * Sets vibration counts for the current menu form part.
 *
 */
int _MENU_PARTVIBECNT(SPI_STACK *stack, int argc) {
    menu_form_part->vibe_cnt[0] = spiGetStackInt(stack++);
    menu_form_part->vibe_cnt[1] = spiGetStackInt(stack);
    return 1;
}

/**
 *
 * Sets vibration ranges for the current menu form part.
 *
 */
int _MENU_PARTVIBER(SPI_STACK *stack, int argc) {
    menu_form_part->viber[0] = spiGetStackInt(stack++);
    menu_form_part->viber[1] = spiGetStackInt(stack);
    return 1;
}

/**
 *
 * Configures the shadow and its offset for the current menu form part.
 *
 */
int _MENU_SHADOW_ONOFF(SPI_STACK *stack, int argc) {
    menu_form_part->shadow = 1;
    menu_form_part->shadow_offset = 4;

    if (argc > 0) {
        menu_form_part->shadow = (spiGetStackInt(stack++) != 0);
    }

    if (argc == 2) {
        menu_form_part->shadow_offset = spiGetStackInt(stack);
    }

    return 1;
}

/**
 *
 * Sets the current form's clipping width and height.
 *
 */
int _CLIP_WH(SPI_STACK *stack, int argc) {
    int width;
    int height;

    if (menu_formPt == NULL) {
        return 0;
    }

    width = mgScreenWidth - 1;
    height = mgScreenHeight - 1;

    if (argc == 2) {
        width = spiGetStackInt(stack++);
        height = spiGetStackInt(stack);
    }

    menu_formPt->clip_w = width;
    menu_formPt->clip_h = height;
    return 1;
}

/**
 *
 * Sets color channels of the current menu form part.
 *
 */
int _MENU_PARTRGBA(SPI_STACK *stack, int argc) {
    MENUFORMPARTS_TYPE *part;
    int                 i;

    part = menu_form_part;

    if (part == NULL) {
        return 0;
    }

    if (argc == 1) {
        part->rgba[3] = spiGetStackInt(stack);
        part->rgba[2] = 0x80;
        part->rgba[1] = 0x80;
        part->rgba[0] = 0x80;
    } else if (argc == 3) {
        part->rgba[0] = spiGetStackInt(stack++);
        part->rgba[1] = spiGetStackInt(stack++);
        part->rgba[2] = spiGetStackInt(stack);
        part->rgba[3] = 0x80;
    } else if (argc == 4) {
        for (i = 0; i < 4; i++) {
            part->rgba[i] = spiGetStackInt(stack++);
        }
    }

    return 1;
}

/**
 *
 * Sets alpha blending mode for the current menu form part.
 *
 */
int _MENU_PART_ALPHA_BLEND(SPI_STACK *stack, int argc) {
    if (menu_form_part == NULL) {
        return 0;
    }

    menu_form_part->alpha_blend = spiGetStackInt(stack);
    return 1;
}

/**
 *
 * Sets indexed extra values on the current menu form part.
 *
 */
int _MENU_PART_ETCINFO(SPI_STACK *stack, int argc) {
    int pairs;
    int i;
    int index;

    if (menu_form_part == 0) {
        return 0;
    }

    pairs = argc / 2;

    for (i = 0; i < pairs; i++) {
        index = spiGetStackInt(stack++);

        (&menu_form_part->etc_info[0])[index] = spiGetStackInt(stack++);
    }

    return 1;
}

/**
 *
 * Enables bilinear texture filtering on the current menu form part.
 *
 */
int _MENU_PART_BILINEAR(SPI_STACK *stack, int argc) {
    MENUFORMPARTS_TYPE *part = menu_form_part;
    u8                 *field = &part->bilinear;

    if (part == NULL) {
        return 0;
    }

    {
        u8 value = part->bilinear;

        if (value == 0) {
            *field = 1;
        } else {
            *field = value | 1;
        }
    }
    return 1;
}

/**
 *
 * Copies a scripted name into a menu form part.
 *
 */
void MakePartsName(SPI_STACK *stack, MENUFORMPARTS_TYPE *part) {
    part->name = mgCopyString(spiGetStackString(stack), MenuSpiStack);
}

/**
 *
 * Creates a named menu part of a scripted drawing type.
 *
 */
int _MENU_PART_DTYPE(SPI_STACK *stack, int argc) {
    MENUFORMPARTS_TYPE *part;
    int                 i;

    if (menu_formPt == NULL) {
        return 0;
    }

    part = menu_formPt->GetEnableEnterPart();
    menu_form_part = part;
    part->dtype = menu_spi_analyze_func_strcut1(tbl_1994, spiGetStackString(stack++));
    MakePartsName(stack++, part);

    if (part->dtype == 'O') {
        for (i = 0; i < argc - 2; i++) {
            (&part->etc_info[0])[i] = spiGetStackInt(stack++);
        }
    } else if (part->dtype == 'L') {
        part->x = spiGetStackInt(stack++);
        part->y = spiGetStackInt(stack++);
        part->w = spiGetStackInt(stack++);
        part->h = spiGetStackInt(stack);
    }

    part->draw_flag = 1;
    part->active = 1;
    return 1;
}

/**
 *
 * Creates a textured menu part with drawing type zero.
 *
 */
int _MENU_NORMAL(SPI_STACK *stack, int argc) {
    MENUFORMPARTS_TYPE *part;

    if (menu_formPt == NULL) {
        return 0;
    }

    part = menu_formPt->GetEnableEnterPart();
    menu_form_part = part;
    part->tex_info_no = MenuPosData->GetTexGetInfoTblNo(spiGetStackString(stack++));
    MakePartsName(stack++, part);
    part->x = spiGetStackInt(stack++);
    part->y = spiGetStackInt(stack++);

    if (argc > 4) {
        part->w = spiGetStackInt(stack++);
        part->h = spiGetStackInt(stack);
    } else {
        menu_texdata_to_formpart_copy(part);
    }

    part->dtype = 0;
    part->active = 1;
    return 1;
}

/**
 *
 * Creates a textured menu part with drawing type one.
 *
 */
int _MENU_NORMAL2(SPI_STACK *stack, int argc) {
    MENUFORMPARTS_TYPE *part = menu_formPt->GetEnableEnterPart();
    menu_form_part = part;
    part->tex_info_no = MenuPosData->GetTexGetInfoTblNo(spiGetStackString(stack++));
    MakePartsName(stack++, part);
    part->x = spiGetStackInt(stack++);
    part->y = spiGetStackInt(stack++);

    if (argc > 4) {
        part->w = spiGetStackInt(stack++);
        part->h = spiGetStackInt(stack);
    } else {
        menu_texdata_to_formpart_copy(part);
    }

    part->dtype = 1;
    part->active = 1;
    return 1;
}

/**
 *
 * Creates an active cursor part at a scripted position.
 *
 */
int _MENU_CURSOR(SPI_STACK *stack, int argc) {
    MENUFORMPARTS_TYPE *part = menu_formPt->GetEnableEnterPart();
    menu_form_part = part;
    MakePartsName(stack++, part);
    part->x = spiGetStackInt(stack++);
    part->y = spiGetStackInt(stack);
    part->dtype = 2;
    part->active = 1;
    part->draw_flag = 1;
    return 1;
}

/**
 *
 * Creates a hidden function-information part at a scripted position.
 *
 */
int _MENU_FUNCINFO(SPI_STACK *stack, int argc) {
    MENUFORMPARTS_TYPE *part = menu_formPt->GetEnableEnterPart();
    menu_form_part = part;
    MakePartsName(stack++, part);
    part->x = spiGetStackInt(stack++);
    part->y = spiGetStackInt(stack);
    part->dtype = 3;
    part->active = 1;
    part->draw_flag = 0;
    return 1;
}

/**
 *
 * Creates a textured number display part of drawing type five.
 *
 */
int _MENU_NUMBER1(SPI_STACK *stack, int argc) {
    MENUFORMPARTS_TYPE *part = menu_formPt->GetEnableEnterPart();
    menu_form_part = part;
    part->tex_info_no = MenuPosData->GetTexGetInfoTblNo(spiGetStackString(stack++));
    MakePartsName(stack++, part);
    part->etc_info[0] = spiGetStackInt(stack++);
    part->x = spiGetStackInt(stack++);
    part->y = spiGetStackInt(stack++);

    if (argc > 5) {
        part->w = spiGetStackInt(stack++);
        part->h = spiGetStackInt(stack);
    }

    part->dtype = 5;
    part->active = 1;
    return 1;
}

/**
 *
 * Creates a textured number display part of drawing type six.
 *
 */
int _MENU_NUMBER2(SPI_STACK *stack, int argc) {
    MENUFORMPARTS_TYPE *part = menu_formPt->GetEnableEnterPart();
    menu_form_part = part;
    part->tex_info_no = MenuPosData->GetTexGetInfoTblNo(spiGetStackString(stack++));
    MakePartsName(stack++, part);
    part->etc_info[0] = spiGetStackInt(stack++);
    part->x = spiGetStackInt(stack++);
    part->y = spiGetStackInt(stack++);

    if (argc > 5) {
        part->w = spiGetStackInt(stack++);
        part->h = spiGetStackInt(stack);
    }

    part->etc_info[1] = 0;
    part->dtype = 6;
    part->active = 1;
    return 1;
}

/**
 *
 * Creates a textured frame image part with scripted dimensions.
 *
 */
int _MENU_FRMIMG(SPI_STACK *stack, int argc) {
    MENUFORMPARTS_TYPE *part = menu_formPt->GetEnableEnterPart();
    menu_form_part = part;
    part->dtype = menu_spi_analyze_func_strcut1(tbl_2060, spiGetStackString(stack++));
    part->tex_info_no = MenuPosData->GetTexGetInfoTblNo(spiGetStackString(stack++));
    MakePartsName(stack++, part);
    part->x = spiGetStackInt(stack++);
    part->y = spiGetStackInt(stack++);
    part->w = spiGetStackInt(stack++);
    part->h = spiGetStackInt(stack);

    if (part->bilinear != 0) {
        part->bilinear |= 1;
    } else {
        part->bilinear = 1;
    }

    part->active = 1;
    return 1;
}

/**
 *
 * Creates a menu form reference part at a scripted position.
 *
 */
int _MENU_FORM(SPI_STACK *stack, int argc) {
    MENUFORMPARTS_TYPE *part = menu_formPt->GetEnableEnterPart();
    menu_form_part = part;
    part->tex_info_no = spiGetStackInt(stack++);
    MakePartsName(stack++, part);
    part->x = spiGetStackInt(stack++);
    part->y = spiGetStackInt(stack);
    part->dtype = 0x19;
    part->active = 1;
    return 1;
}

/**
 *
 * Creates an item display part with its scripted type and dimensions.
 *
 */
int _MENU_ITEM(SPI_STACK *stack, int argc) {
    MENUFORMPARTS_TYPE *part = menu_formPt->GetEnableEnterPart();
    menu_form_part = part;
    part->dtype = menu_spi_analyze_func_strcut1(tbl_2074, spiGetStackString(stack++));
    part->etc_info[1] = 0;
    MakePartsName(stack++, part);
    part->x = spiGetStackInt(stack++);
    part->y = spiGetStackInt(stack++);
    part->w = 32.0f;
    part->h = 40.0f;

    if (argc > 4) {
        part->w = spiGetStackInt(stack++);
        part->h = spiGetStackInt(stack);
    }

    part->active = 1;
    part->draw_flag = 1;
    return 1;
}

/**
 *
 * Creates a textured checkmark part for an item display.
 *
 */
int _MENU_ITEM_CHECKMARK(SPI_STACK *stack, int argc) {
    MENUFORMPARTS_TYPE *part = menu_formPt->GetEnableEnterPart();
    menu_form_part = part;
    part->dtype = 0x39;
    part->tex_info_no = (s8) MenuCommonInfo->tex_block[0];
    MakePartsName(stack++, part);
    part->x = spiGetStackInt(stack++);
    part->y = spiGetStackInt(stack++);

    if (argc > 3) {
        part->w = spiGetStackInt(stack++);
        part->h = spiGetStackInt(stack);
    } else {
        menu_texdata_to_formpart_copy(part);
    }

    part->active = 1;
    part->draw_flag = 1;
    return 1;
}

/**
 *
 * Creates a filled box part and allocates its color effects.
 *
 */
int _MENU_FILLBOX(SPI_STACK *stack, int argc) {
    MENUFORMPARTS_TYPE *part = menu_formPt->GetEnableEnterPart();
    menu_form_part = part;
    part->dtype = menu_spi_analyze_func_strcut1(tbl_2090, spiGetStackString(stack++));
    MakePartsName(stack++, part);
    part->x = spiGetStackInt(stack++);
    part->y = spiGetStackInt(stack++);
    part->w = spiGetStackInt(stack++);
    part->h = spiGetStackInt(stack++);
    part->etc_info[0] = spiGetStackInt(stack);
    part->active = 1;
    part->draw_flag = 1;
    u8 effect_counts[4] = {1, 2, 2, 4};
    part->effect = (MENU_PARTS_EFFECT_STRUCT1 *) MenuSpiStack->Alloc(
        align16_blocks(effect_counts[part->etc_info[0]] * sizeof(MENU_PARTS_EFFECT_STRUCT1)));
    menu_parts_effect_ptr = part->effect;
    return 1;
}

/**
 *
 * Sets the next filled box color effect from scripted channels.
 *
 */
int _MENU_FILLBOXINFO(SPI_STACK *stack, int argc) {
    menu_parts_effect_ptr->type = 1;

    for (int i = 0; i < 4; i++) {
        menu_parts_effect_ptr->param[i] = spiGetStackInt(stack++);
    }

    menu_parts_effect_ptr++;
    return 1;
}

/**
 *
 * Creates a textured rectangular frame part.
 *
 */
int _MENU_WAKU_RECT(SPI_STACK *stack, int argc) {
    MENUFORMPARTS_TYPE *part = menu_formPt->GetEnableEnterPart();
    menu_form_part = part;
    part->tex_info_no = MenuPosData->GetTexGetInfoTblNo(spiGetStackString(stack++));
    MakePartsName(stack++, part);
    part->dtype = 0xD;
    part->x = spiGetStackInt(stack++);
    part->y = spiGetStackInt(stack++);
    part->w = spiGetStackInt(stack++);
    part->h = spiGetStackInt(stack);
    part->active = 1;
    part->draw_flag = 1;
    return 1;
}

/**
 *
 * Creates a textured circular frame part.
 *
 */
int _MENU_WAKU_CIRCLE(SPI_STACK *stack, int argc) {
    MENUFORMPARTS_TYPE *part = menu_formPt->GetEnableEnterPart();
    menu_form_part = part;
    part->tex_info_no = MenuPosData->GetTexGetInfoTblNo(spiGetStackString(stack++));
    MakePartsName(stack++, part);
    part->dtype = 0xE;
    part->x = spiGetStackInt(stack++);
    part->y = spiGetStackInt(stack++);
    part->w = spiGetStackInt(stack++);
    part->h = spiGetStackInt(stack);
    part->active = 1;
    part->draw_flag = 1;
    return 1;
}

/**
 *
 * Allocates the current part's scripted effect records.
 *
 */
int _MENU_PARTS_EFF_NUM(SPI_STACK *stack, int argc) {
    int          count = spiGetStackInt(stack);
    unsigned int bytes;
    unsigned int blocks;

    if (menu_form_part == 0 || count <= 0) {
        return 0;
    }

    menu_form_part->effect_num = count;
    bytes = count * 0x24;

    if (bytes & 0xF) {
        blocks = (bytes >> 4) + 1;
    } else {
        blocks = bytes >> 4;
    }

    menu_form_part->effect = (MENU_PARTS_EFFECT_STRUCT1 *) MenuSpiStack->Alloc(blocks);
    menu_parts_effect_ptr = menu_form_part->effect;
    return 1;
}

/**
 *
 * Configures the next scripted effect of the current menu part.
 *
 */
int _MENU_PARTS_EFFECT(SPI_STACK *stack, int argc) {
    MENU_PARTS_EFFECT_STRUCT1 *effect;
    char                      *name;
    int                        i;
    name = spiGetStackString(stack++);
    effect = menu_parts_effect_ptr;

    if (effect == NULL || name == 0) {
        return 0;
    }

    effect->type = menu_spi_analyze_func_strcut1(tbl_2144, name);
    effect->active = 1;
    effect->repeat = 1;

    for (i = 0; i < argc - 1; i++) {
        effect->param[i] = spiGetStackInt(stack++);
    }

    menu_parts_effect_ptr++;
    return 1;
}

int MenuDataAnalyze(char *script, int size, mgCMemory *memory) {
    if (script == NULL) {
        return 0;
    }

    MenuSpiStack = memory;
    CScriptInterpreter interpreter;
    interpreter.SetTag(menu_analyze_tag);
    interpreter.SetScript(script, size);
    interpreter.Run();
    return 1;
}

/**
 *
 * Selects whether subsequent commands match the requested menu command name.
 *
 */
int _MENU_EXE_COMMAND_NAME(SPI_STACK *stack, int argc) {
    char *name;

    name = spiGetStackString(stack);
    SpiMenuExeCommandFlag = 0;

    if (strcmp(MenuCommandAnalyzeInfo.command_name, name) == 0) {
        SpiMenuExeCommandFlag = 1;
    }

    return 1;
}

/**
 *
 * Sets visibility for the named forms in the selected menu command.
 *
 */
int _MENU_EXE_FORM_DRAWFLAG(SPI_STACK *stack, int argc) {
    int               draw;
    int               count;
    int               i;
    char             *name;
    CMenuPosDataForm *form;

    if (SpiMenuExeCommandFlag == 0) {
        return 1;
    }

    draw = spiGetStackInt(stack++);
    count = argc - 1;

    for (i = 0; i < count; i++) {
        name = spiGetStackString(stack++);
        form = MenuPosData->GetFormInfo(name);

        if (form != NULL) {
            form->draw_flag = (draw != 0);
        } else {
            printf("%s not found\n", name);
        }
    }

    return 1;
}

/**
 *
 * Sets a named form's color and resets its color animation parameters.
 *
 */
int _MENU_EXE_FORM_RGBA(SPI_STACK *stack, int argc) {
    CMenuPosDataForm *form;
    int               i;

    if (SpiMenuExeCommandFlag == 0) {
        return 1;
    }

    form = MenuPosData->GetFormInfo(spiGetStackString(stack++));

    if (form == NULL) {
        return 1;
    }

    if (argc == 1) {
        form->rgba[0] = 0x80;
        form->rgba[1] = 0x80;
        form->rgba[2] = 0x80;
        form->rgba[3] = 0x80;

        for (i = 0; i < 4; i++) {
            form->SetRGBACalcParam(i, 0, 0x80);
        }
    } else {
        int r = spiGetStackInt(stack++);
        int g = spiGetStackInt(stack++);
        int b = spiGetStackInt(stack++);
        int a = spiGetStackInt(stack);
        form->rgba[0] = r;
        form->rgba[1] = g;
        form->rgba[2] = b;
        form->rgba[3] = a;

        for (i = 0; i < 4; i++) {
            form->SetRGBACalcParam(i, 0, 0x80);
        }
    }

    return 1;
}

/**
 *
 * Sets a named form's color animation parameters.
 *
 */
int _MENU_EXE_FORM_CALCRGBAPARAM(SPI_STACK *stack, int argc) {
    CMenuPosDataForm *form;
    int               mode;
    int               param1;

    if (SpiMenuExeCommandFlag == 0) {
        return 1;
    }

    form = MenuPosData->GetFormInfo(spiGetStackString(stack++));

    if (form == 0) {
        return 1;
    }

    mode = spiGetStackInt(stack++);
    param1 = spiGetStackInt(stack++);
    form->SetRGBACalcParam(mode, param1, spiGetStackInt(stack));
    return 1;
}

/**
 *
 * Starts a fade in or out on a named menu form.
 *
 */
int _MENU_EXE_FORM_FADE(SPI_STACK *stack, int argc) {
    CMenuPosDataForm *form;
    int               mode;
    int               frames;

    if (SpiMenuExeCommandFlag == 0) {
        return 1;
    }

    form = MenuPosData->GetFormInfo(spiGetStackString(stack++));

    if (form == 0) {
        return 1;
    }

    mode = spiGetStackInt(stack++);
    frames = spiGetStackInt(stack);

    if (mode == 0) {
        form->FormFadeIn(frames, 1);
    }

    if (mode == 1) {
        form->FormFadeOut(frames, 1);
    }

    return 1;
}

/**
 *
 * Sets a named form's screen position for the selected language.
 *
 */
int _MENU_EXE_FORM_SETPOS(SPI_STACK *stack, int argc) {
    if (SpiMenuExeCommandFlag == 0) {
        return 1;
    }

    CMenuPosDataForm *form = MenuPosData->GetFormInfo(
        spiGetStackString(stack++));

    if (form == NULL) {
        return 1;
    }

    int x = spiGetStackInt(stack++);
    int y = spiGetStackInt(stack++);
    int language = LanguageCode;

    if (argc >= 4) {
        language = spiGetStackInt(stack);
    }

    if (language != LanguageCode) {
        return 0;
    }

    form->x = x;
    form->y = y;
    return 1;
}

/**
 *
 * Starts a named action on a selected menu form.
 *
 */
int _MENU_EXE_FORM_SETACTION(SPI_STACK *stack, int argc) {
    CMenuPosDataForm *form;
    SPI_STACK        *next_slot = stack + 1;

    if (SpiMenuExeCommandFlag == 0) {
        return 1;
    }

    form = MenuPosData->GetFormInfo(spiGetStackString(stack));

    if (form == 0) {
        return 1;
    }

    form->SetAction(spiGetStackString(next_slot));
    return 1;
}

/**
 *
 * Sets visibility for one named part of a menu form.
 *
 */
int _MENU_EXE_FORM_PARTSONOFF(SPI_STACK *stack, int argc) {
    CMenuPosDataForm   *form;
    MENUFORMPARTS_TYPE *part;

    if (SpiMenuExeCommandFlag == 0) {
        return 1;
    }

    form = MenuPosData->GetFormInfo(spiGetStackString(stack++));

    if (form == 0) {
        return 0;
    }

    part = form->GetPartInfo(spiGetStackString(stack++));

    if (part == NULL) {
        return 0;
    }

    part->draw_flag = (spiGetStackInt(stack) != 0);
    return 1;
}

/**
 *
 * Sets visibility for a named group of parts on one form.
 *
 */
int _MENU_EXE_FORM_PARTSONOFF_GRP(SPI_STACK *stack, int argc) {
    CMenuPosDataForm   *form;
    int                 on;
    int                 count;
    int                 i;
    MENUFORMPARTS_TYPE *part;

    if (SpiMenuExeCommandFlag == 0) {
        return 1;
    }

    form = MenuPosData->GetFormInfo(spiGetStackString(stack++));

    if (form == 0) {
        return 0;
    }

    on = spiGetStackInt(stack++);
    count = argc - 2;

    for (i = 0; i < count; i++) {
        part = form->GetPartInfo(spiGetStackString(stack++));

        if (part != NULL) {
            part->draw_flag = (on != 0);
        }
    }

    return 1;
}

/**
 *
 * Changes the drawing order of two named menu forms.
 *
 */
int _MENU_EXE_FORM_SWAP(SPI_STACK *stack, int argc) {
    SPI_STACK *next_slot = stack + 1;
    char      *form;

    if (SpiMenuExeCommandFlag == 0) {
        return 1;
    }

    form = spiGetStackString(stack);
    MenuPosData->FormReLink(form, spiGetStackString(next_slot));
    return 1;
}

/**
 *
 * Changes the drawing order of two named groups of menu forms.
 *
 */
int _MENU_EXE_FORM_GROUP_SWAP(SPI_STACK *stack, int argc) {
    char *form;
    char *target;
    char *third;
    char *fourth;

    if (SpiMenuExeCommandFlag == 0) {
        return 1;
    }

    form = spiGetStackString(stack++);
    target = spiGetStackString(stack++);
    third = spiGetStackString(stack++);
    fourth = spiGetStackString(stack);
    MenuPosData->FormReLink2(form, target, third, fourth);
    return 1;
}

/**
 *
 * Applies a named message preset to a menu message window.
 *
 */
int _MENU_EXE_MSGENV(SPI_STACK *stack, int argc) {
    SPI_STACK *next_slot = stack + 1;
    int        msg_no;
    int        preset;

    if (SpiMenuExeCommandFlag == 0) {
        return 1;
    }

    msg_no = spiGetStackInt(stack);
    preset = menu_spi_analyze_func_strcut1(tbl_2369, spiGetStackString(next_slot));
    MenuDCMsg[msg_no]->MsgPreset(preset, LanguageCode);
    return 1;
}

/**
 *
 * Builds a message in the selected menu message window.
 *
 */
int _MENU_EXE_MAKEMSG(SPI_STACK *stack, int argc) {
    SPI_STACK *next_slot = stack + 1;
    int        message;
    int        id;

    if (SpiMenuExeCommandFlag == 0) {
        return 1;
    }

    message = spiGetStackInt(stack);
    id = spiGetStackInt(next_slot);
    MenuDCMsg[message]->MakeMsg(id);
    return 1;
}

/**
 *
 * Sets the selected message window's absolute position mode.
 *
 */
int _MENU_EXE_SETABSPOS(SPI_STACK *stack, int argc) {
    SPI_STACK *next_slot = stack + 1;
    int        index;
    int        value;

    if (SpiMenuExeCommandFlag == 0) {
        return 1;
    }

    index = spiGetStackInt(stack);
    value = spiGetStackInt(next_slot);
    MenuDCMsg[index]->SetAbsPos(value);
    return 1;
}

/**
 *
 * Selects a system text buffer for a menu message window.
 *
 */
int _MENU_EXE_MSGSETSYSTEMBUFF(SPI_STACK *stack, int argc) {
    SPI_STACK *next_slot = stack + 1;
    int        message;
    short     *buffer;

    if (SpiMenuExeCommandFlag == 0) {
        return 1;
    }

    message = spiGetStackInt(stack);
    buffer = MenuCommandAnalyzeInfo.system_mes_buff[spiGetStackInt(next_slot)];

    if (buffer == NULL) {
        buffer = GetSystemMesBuffer();
    }

    MenuDCMsg[message]->SetBuff_system(buffer);
    return 1;
}

/**
 *
 * Selects a menu text buffer for a message window.
 *
 */
int _MENU_EXE_MSGSETBUFF(SPI_STACK *stack, int argc) {
    SPI_STACK *next_slot = stack + 1;

    if (SpiMenuExeCommandFlag == 0) {
        return 1;
    }

    int message_index = spiGetStackInt(stack);
    int buffer_index = spiGetStackInt(next_slot);
    MenuDCMsg[message_index]->SetBuff(MenuCommandAnalyzeInfo.mes_buff[buffer_index]);
    return 1;
}

/**
 *
 * Sets the outline style of a menu message window.
 *
 */
int _MENU_EXE_MSGSETFUCHI(SPI_STACK *stack, int argc) {
    SPI_STACK *next_slot = stack + 1;
    int        message;
    char      *text;
    int        type;

    if (SpiMenuExeCommandFlag == 0) {
        return 1;
    }

    message = spiGetStackInt(stack);
    text = spiGetStackString(next_slot);
    type = menu_spi_analyze_func_strcut1(tbl_2422, text);
    MenuDCMsg[message]->fuchi = type;
    return 1;
}

/**
 *
 * Sets the selected menu message window's cursor position.
 *
 */
int _MENU_EXE_MSGSETCURSOR(SPI_STACK *stack, int argc) {
    SPI_STACK *next_slot = stack + 1;
    int        index;
    int        cursor;

    if (SpiMenuExeCommandFlag == 0) {
        return 1;
    }

    index = spiGetStackInt(stack);
    cursor = spiGetStackInt(next_slot);
    MenuDCMsg[index]->SetMsgCursor(cursor);
    return 1;
}

/**
 *
 * Sets the first selectable answer line of a menu message window.
 *
 */
int _MENU_SET_QUESTIONGYOU(SPI_STACK *stack, int argc) {
    SPI_STACK *next_slot = stack + 1;
    int        msg_no;

    if (SpiMenuExeCommandFlag == 0) {
        return 1;
    }

    msg_no = spiGetStackInt(stack);
    MenuDCMsg[msg_no]->select_top = spiGetStackInt(next_slot);
    return 1;
}

/**
 *
 * Sets the opening fade speed of a menu message window.
 *
 */
int _MENU_SET_OPENSPEED(SPI_STACK *stack, int argc) {
    int        message;
    SPI_STACK *next_slot = stack + 1;

    if (SpiMenuExeCommandFlag == 0) {
        return 1;
    }

    message = spiGetStackInt(stack);
    MenuDCMsg[message]->fade_speed = spiGetStackFloat(next_slot);
    return 1;
}

/**
 *
 * Enables or disables menu key input.
 *
 */
int _MENU_INPUT_KEY(SPI_STACK *stack, int argc) {
    if (SpiMenuExeCommandFlag == 0) {
        return 1;
    }

    MenuCommonInfo->key_enable = spiGetStackInt(stack);
    return 1;
}

/**
 *
 * Shows or hides the menu cursor form.
 *
 */
int _MENU_CURSOR_ONOFF(SPI_STACK *stack, int argc) {
    int               value;
    CMenuPosDataForm *cursor;

    if (SpiMenuExeCommandFlag == 0) {
        return 1;
    }

    value = spiGetStackInt(stack);
    cursor = MenuCommonInfo->cursor_form;

    if (cursor != NULL) {
        cursor->draw_flag = (value != 0);
    }

    return 1;
}

/**
 *
 * Fades the menu cursor in or out at a scripted speed.
 *
 */
int _MENU_CURSOR_FADE(SPI_STACK *stack, int argc) {
    int fade_in;
    int speed;
    int steps;

    if (SpiMenuExeCommandFlag == 0) {
        return 1;
    }

    fade_in = spiGetStackInt(stack++);
    speed = 10;

    if (argc == 2) {
        speed = spiGetStackInt(stack++);
    }

    steps = 1;

    if (argc == 3) {
        steps = spiGetStackInt(stack);
    }

    if (fade_in != 0) {
        MenuCommonInfo->CursorFadeIn(speed, steps);
    } else {
        MenuCommonInfo->CursorFadeOut(speed, steps);
    }

    return 1;
}

/**
 *
 * Sets the menu window frame type.
 *
 */
int _MENU_WAKUTYPE(SPI_STACK *stack, int argc) {
    if (SpiMenuExeCommandFlag == 0) {
        return 1;
    }

    MenuCommonInfo->SetWakuType(spiGetStackInt(stack));
    return 1;
}

/**
 *
 * Starts and advances a scene fade for the selected menu command.
 *
 */
int _MENU_SCENE_FADE(SPI_STACK *stack, int argc) {
    int fade_in;
    int frames;

    if (SpiMenuExeCommandFlag == 0) {
        return 1;
    }

    fade_in = spiGetStackInt(stack++);
    frames = 40;

    if (argc == 2) {
        frames = spiGetStackInt(stack);
    }

    if (fade_in != 0) {
        MenuMainScene->fade.FadeIn(frames);
    } else {
        MenuMainScene->fade.FadeOut(frames, 0.0f, 0.0f, 0.0f);
    }

    MenuMainScene->fade.FadeStep();
    return 1;
}

/**
 *
 * Plays a named menu sound effect.
 *
 */
int _MENU_SE_PLAY(SPI_STACK *stack, int argc) {
    if (SpiMenuExeCommandFlag == 0) {
        return 1;
    }

    MenuSePlay(menu_spi_analyze_func_strcut1(tbl_2516, spiGetStackString(stack)));
    return 1;
}

/**
 *
 * Reinitializes the menu form drawing list for a command.
 *
 */
int _MENU_EXE_INIT_DRAWLIST(SPI_STACK *stack, int argc) {
    if (SpiMenuExeCommandFlag == 0) {
        return 1;
    }

    MenuPosData->InitDrawList();
    return 1;
}

/**
 *
 * Resets all menu texture information for a command.
 *
 */
int _MENU_EXE_RESET_TEXINFO(SPI_STACK *stack, int argc) {
    if (SpiMenuExeCommandFlag == 0) {
        return 1;
    }

    MenuPosData->ResetTextureInfoAll();
    return 1;
}

/**
 *
 * Prints a scripted menu debugging message.
 *
 */
int _MENU_DEBUG_PRINTF(SPI_STACK *stack, int argc) {
    if (SpiMenuExeCommandFlag == 0) {
        return 1;
    }

    printf(spiGetStackString(stack));
    printf("\n");
    return 1;
}

void MenuCommandAnalyze(char *script, int size, char *command_name) {
    if ((script != NULL) && (command_name != NULL)) {
        strcpy(MenuCommandAnalyzeInfo.command_name, command_name);
        CScriptInterpreter interpreter;
        interpreter.SetTag(menu_execommand_analyze_tag);
        interpreter.SetScript(script, size);
        interpreter.Run();
    }
}
