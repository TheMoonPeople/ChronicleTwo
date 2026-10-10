#pragma once

#include "common.h"

#include <libvu0.h>

#include "mg_memory.hpp"
#include "mg_tanime.hpp"

/**
 * @file
 * Declares the menu drawing layer: forms and parts laid out by the menu
 * layout scripts and the manager that holds them, the shared menu drawing
 * helpers (textured quads, numbers, frames, cursors, item icons and the item
 * board), and the small particle effects shown on menu screens.
 */

class CActionChara;
class CCharacter2;
class CGameDataUsed;
class CItemUseTarget;
class CUserDataManager;
class ClsMes;
class mgCDrawPrim;
class mgCTexture;
class CMenuPosDataForm;

enum MENU_NUMBER_ALIGN {
    MENU_NUMBER_ALIGN_RIGHT = 0,
    MENU_NUMBER_ALIGN_CENTER = 1,
    MENU_NUMBER_ALIGN_LEFT = 2,
};

enum MENU_ITEM_ICON_FLAG {
    MENU_ITEM_ICON_HIGHLIGHT = 1,
    MENU_ITEM_ICON_BUILD_UP = 2,
};

enum MENU_ITEM_NEED {
    MENU_ITEM_NEED_RESTORE_HP = 0x1,
    MENU_ITEM_NEED_REPAIR_MELEE = 0x2,
    MENU_ITEM_NEED_REPAIR_GUN = 0x4,
    MENU_ITEM_NEED_REPAIR_MAGIC = 0x8,
    MENU_ITEM_NEED_REFUEL_RIDEPOD = 0x80,
    MENU_ITEM_NEED_CURE_POISON = 0x100,
    MENU_ITEM_NEED_CURE_SLOW = 0x200,
    MENU_ITEM_NEED_REPAIR_RIDEPOD = 0x8000,
    MENU_ITEM_NEED_RIDEPOD_SHIELD_KIT = 0x10000,
};

/**
 *
 * Kind of drawing a form performs, as the dtype keyword of a menu layout
 * script selects it.
 *
 */
// clang-format off
enum MENUFORM_DTYPE {
    MENUFORM_DTYPE_NORMAL    = 0x00, /**< "normal": draws the form's parts. */
    MENUFORM_DTYPE_ITEMBRD   = 0x0A, /**< "itembrd": draws the item board. */
    MENUFORM_DTYPE_GIFTVIEW  = 0x0C, /**< "giftview": draws the contents of a gift box. */
    MENUFORM_DTYPE_POLY      = 0x0D, /**< "poly": draws a 3D character model. */
    MENUFORM_DTYPE_MAPPART   = 0x0F, /**< "mappart": draws the map menu's parts. */
    MENUFORM_DTYPE_CREATEBRD = 0x10, /**< "createbrd": draws the common creation board. */
    MENUFORM_DTYPE_MSGFORM   = 0x14, /**< "msgform": draws one of the menu message windows. */
    MENUFORM_DTYPE_COMBRD    = 0x16, /**< "combrd". */
    MENUFORM_DTYPE_LIST      = 0x17, /**< "list": draws the form's parts. */
    MENUFORM_DTYPE_BG_TILE   = 0x18, /**< "bg_tile": draws a scrolling tiled background. */
    MENUFORM_DTYPE_DLOAD     = 0x19, /**< "dload": draws the loading progress bar. */
    MENUFORM_DTYPE_MAINFRM   = 0x1E, /**< "mainfrm": draws the main menu frame. */
    MENUFORM_DTYPE_MAINIMG   = 0x1F, /**< "mainimg": draws the main menu frame image. */
    MENUFORM_DTYPE_CHRSTAR   = 0x20, /**< "chrstar": draws the character change stars. */
    MENUFORM_DTYPE_INV_CARD  = 0x21, /**< "inv_card": draws the invention card. */
    MENUFORM_DTYPE_GEOLIST   = 0x23, /**< "geolist": draws a Georama list. */
    MENUFORM_DTYPE_GEOTITLE  = 0x24, /**< "geotitle": draws the Georama title. */
    MENUFORM_DTYPE_GEOANA    = 0x25, /**< "geoana": draws the Georama analysis. */
    MENUFORM_DTYPE_HOUSE     = 0x26, /**< "house": draws the placed houses. */
    MENUFORM_DTYPE_SHOPLIST  = 0x27, /**< "shoplist": draws the shop's sell list. */
    MENUFORM_DTYPE_BUILDUP   = 0x28, /**< "buildup": draws the weapon build-up view. */
    MENUFORM_DTYPE_MOSBAJI   = 0x29, /**< "mosbaji". */
    MENUFORM_DTYPE_SAVELIST  = 0x2A, /**< "savelist": draws the save file list. */
    MENUFORM_DTYPE_WMAP      = 0x2B, /**< "wmap". */
    MENUFORM_DTYPE_INFOCUR   = 0x2C, /**< "infocur": draws the item info cursor and character status. */
    MENUFORM_DTYPE_CLIP      = 0x2D, /**< "clip": sets the scissor area to the form's clip size. */
};

// clang-format on

/**
 *
 * Way a form moves towards its next position, as the mtype keyword of a menu
 * layout script selects it.
 *
 */
// clang-format off
enum MENUFORM_MTYPE {
    MENUFORM_MTYPE_N  = -1, /**< "n": no movement set. */
    MENUFORM_MTYPE_D  = 0,  /**< "d": jumps to the target at once. */
    MENUFORM_MTYPE_L  = 1,  /**< "l": moves towards the target at a fixed speed. */
    MENUFORM_MTYPE_I  = 2,  /**< "i": closes a fraction of the remaining distance each frame. */
    MENUFORM_MTYPE_IR = 3,  /**< "ir": as "i", without the extra pixel of approach. */
};

// clang-format on

/**
 *
 * Kind of drawing a form part performs.
 *
 */
// clang-format off
enum MENUFORMPARTS_DTYPE {
    MENUFORMPARTS_DTYPE_NORMAL      = 0x00, /**< Textured rectangle. */
    MENUFORMPARTS_DTYPE_NORMAL2     = 0x01, /**< Textured rectangle slanted by the part's first extra value. */
    MENUFORMPARTS_DTYPE_CURSOR      = 0x02, /**< Menu cursor. */
    MENUFORMPARTS_DTYPE_FUNCINFO    = 0x03, /**< Position only; not drawn. */
    MENUFORMPARTS_DTYPE_NUMBER1     = 0x05, /**< Number drawn by PrimDrawNumber. */
    MENUFORMPARTS_DTYPE_NUMBER2     = 0x06, /**< Number drawn by PrimDrawNumber2. */
    MENUFORMPARTS_DTYPE_WAKU_RECT   = 0x0D, /**< Rectangular window frame. */
    MENUFORMPARTS_DTYPE_WAKU_CIRCLE = 0x0E, /**< Rotating circular frame. */
    MENUFORMPARTS_DTYPE_FORM        = 0x19, /**< Reference to another form, whose position it adds. */
    MENUFORMPARTS_DTYPE_BG          = 0x2D, /**< "bg" frame image. */
    MENUFORMPARTS_DTYPE_BETA        = 0x2E, /**< "beta" frame image. */
    MENUFORMPARTS_DTYPE_FADE_TOP    = 0x2F, /**< Frame image whose top edge fades out. */
    MENUFORMPARTS_DTYPE_FADE_BOTTOM = 0x30, /**< Frame image whose bottom edge fades out. */
    MENUFORMPARTS_DTYPE_FADE_RIGHT  = 0x31, /**< Frame image whose right edge fades out. */
    MENUFORMPARTS_DTYPE_FADE_LEFT   = 0x32, /**< Frame image whose left edge fades out. */
    MENUFORMPARTS_DTYPE_TRS         = 0x37, /**< "trs": item icon. */
    MENUFORMPARTS_DTYPE_CHECKMARK   = 0x39, /**< Item check mark. */
    MENUFORMPARTS_DTYPE_NETA        = 0x3B, /**< "neta": picture. */
    MENUFORMPARTS_DTYPE_IDEA_BOARD  = 0x3C, /**< Invention idea board. */
    MENUFORMPARTS_DTYPE_ALBUM       = 0x3D, /**< Album picture. */
    MENUFORMPARTS_DTYPE_IDEA_MEMO   = 0x3E, /**< Idea notebook. */
    MENUFORMPARTS_DTYPE_SQ_BETA     = 0x41, /**< "sq_beta": flat or gradient filled box. */
    MENUFORMPARTS_DTYPE_RANDOM_LINE = 0x4C, /**< Scribbled random line. */
    MENUFORMPARTS_DTYPE_FONT        = 0x4E, /**< "font". */
    MENUFORMPARTS_DTYPE_CLUT_RELOAD = 0x4F, /**< "clut_reload": reloads a character change palette. */
};

// clang-format on

/**
 *
 * Kind of animation a part effect runs.
 *
 */
// clang-format off
enum MENU_PARTS_EFFECT_TYPE {
    MENU_PARTS_EFFECT_UNK_1       = 1,   /**< Counts up to a limit, then sets the part colour. */
    MENU_PARTS_EFFECT_BLINK       = 2,   /**< "blink". */
    MENU_PARTS_EFFECT_ROT         = 3,   /**< "rot". */
    MENU_PARTS_EFFECT_HURIKO      = 4,   /**< "huriko": pendulum swing. */
    MENU_PARTS_EFFECT_STRETCH     = 6,   /**< "stretch". */
    MENU_PARTS_EFFECT_STRETCH_REP = 7,   /**< "stretch_rep". */
    MENU_PARTS_EFFECT_STRETCH_SIN = 8,   /**< "stretch_sin". */
    MENU_PARTS_EFFECT_UNK_9       = 9,   /**< Sparkle that restarts with random parameters. */
    MENU_PARTS_EFFECT_UNK_10      = 10,  /**< Counts like "rot". */
    MENU_PARTS_EFFECT_UNK_11      = 11,  /**< Counts like "rot". */
    MENU_PARTS_EFFECT_UNK_12      = 12,  /**< Counts up without end. */
    MENU_PARTS_EFFECT_UNK_100     = 100, /**< Item icon effect; never stepped. */
};

// clang-format on

/**
 *
 * Texture rectangle with short coordinates and dimensions.
 *
 */
struct MENU_SHORT_RECT {
    short left;   /**< Left texture coordinate. */
    short top;    /**< Top texture coordinate. */
    short right;  /**< Texture rectangle width. */
    short bottom; /**< Texture rectangle height. */
};

STATIC_ASSERT(sizeof(MENU_SHORT_RECT) == 0x8);

/**
 *
 * Texture rectangle registered by name in a menu layout script, together
 * with the texture it is cut from.
 *
 */
struct MENU_BASETEXINFO {
    mgRect<int> rect;      /**< Texel rectangle as x, y, width and height. */
    char       *name;      /**< Name the rectangle is looked up by. */
    char       *tex_name;  /**< Name of the texture the rectangle lies in. */
    u8          tex_block; /**< Texture block the texture is loaded into. */
    u8          unk_19;
    s16         tbl_no; /**< Index of this entry in the manager's table. */
    u8          unk_1c[0x4];
};

STATIC_ASSERT(sizeof(MENU_BASETEXINFO) == 0x20);

/**
 *
 * One animation attached to a form part, with its kind and eight
 * parameters whose meaning depends on the kind.
 *
 */
struct MENU_PARTS_EFFECT_STRUCT1 {
    u8    active;   /**< Non-zero while the effect runs. */
    u8    repeat;   /**< Non-zero to keep the effect running when a cycle ends. */
    u16   type;     /**< Kind of effect, a MENU_PARTS_EFFECT_TYPE. */
    float param[8]; /**< Counter, limit and per-kind parameters. */
};

STATIC_ASSERT(sizeof(MENU_PARTS_EFFECT_STRUCT1) == 0x24);

/**
 *
 * One drawable element of a form: a textured rectangle, number, frame,
 * icon or other item positioned relative to the form.
 *
 */
struct MENUFORMPARTS_TYPE {
    char                      *name;      /**< Name the part is looked up by. */
    u8                         active;    /**< Non-zero once the slot holds a part. */
    u8                         draw_flag; /**< Non-zero to draw the part. */
    u8                         dtype;     /**< Kind of drawing, a MENUFORMPARTS_DTYPE. */
    u8                         rgba[4];   /**< Colour and alpha. */
    u8                         viber[2];  /**< Amplitude of the horizontal and vertical sway. */
    u8                         unk_d;
    s16                        vibe_cnt[2]; /**< Half period of the horizontal and vertical sway, in frames; 0 for none. */
    u8                         unk_12[0x2];
    mgCTexture                *tex;         /**< Texture the part is drawn with. */
    u8                         tex_info_no; /**< Index of the part's MENU_BASETEXINFO in the manager. */
    u8                         bilinear;    /**< Bit 0 set to sample the texture bilinearly. */
    s8                         alpha_blend; /**< Blend equation the part is drawn with. */
    u8                         unk_1b;
    float                      x;             /**< Position relative to the form. */
    float                      y;             /**< Position relative to the form. */
    float                      w;             /**< Width. */
    float                      h;             /**< Height. */
    float                      picture_scale; /**< Scale applied when drawing the part as a picture. */
    int                        etc_info[4];   /**< Extra values whose meaning depends on dtype, such as a number to draw. */
    MENU_PARTS_EFFECT_STRUCT1 *effect;        /**< Animations attached to the part. */
    u8                         effect_num;    /**< Number of entries in effect. */
    u8                         item_flag;     /**< State bits of an item icon part. */
    u8                         shadow;        /**< Non-zero to draw a drop shadow under the part. */
    s8                         shadow_offset; /**< Offset of the drop shadow, in pixels. */
};

STATIC_ASSERT(sizeof(MENUFORMPARTS_TYPE) == 0x48);

/**
 *
 * Movement an action of a form performs.
 *
 */
struct MENU_FORM_ACTION_MOVE {
    s16   mtype;  /**< Way of moving, a MENUFORM_MTYPE. */
    float x;      /**< Target position. */
    float y;      /**< Target position. */
    float rate_x; /**< Horizontal speed or divisor, depending on mtype. */
    float rate_y; /**< Vertical speed or divisor, depending on mtype. */
};

STATIC_ASSERT(sizeof(MENU_FORM_ACTION_MOVE) == 0x14);

/**
 *
 * Named action of a form, defined by a menu layout script.
 *
 */
struct MENU_FORM_ACTION {
    char                   name[0x10]; /**< Name the action is set by. */
    MENU_FORM_ACTION_MOVE *move;       /**< Movement the action performs. */
};

STATIC_ASSERT(sizeof(MENU_FORM_ACTION) == 0x14);

/**
 *
 * Named pair of integers defined by a menu layout script.
 *
 */
struct MENU_ETCINFO {
    char *name;     /**< Name the entry is looked up by. */
    int   value[2]; /**< Values. */
};

STATIC_ASSERT(sizeof(MENU_ETCINFO) == 0xC);

/**
 *
 * Named set of four numbers defined by a menu layout script.
 *
 */
struct MENU_ETCINFO2 {
    char *name;     /**< Name the entry is looked up by. */
    float value[4]; /**< Values. */
};

STATIC_ASSERT(sizeof(MENU_ETCINFO2) == 0x14);

/**
 *
 * One line of the common creation board.
 *
 */
struct MENUFORM_MAKEBRD_LINE {
    u8  kind;    /**< Board style of the line; 0 hides the button icon. */
    u8  button;  /**< Button icon shown on the line. */
    s16 num;     /**< Number shown on the line. */
    s16 sub_num; /**< Second number, shown when positive. */
};

STATIC_ASSERT(sizeof(MENUFORM_MAKEBRD_LINE) == 0x6);

/**
 *
 * Contents of the common creation board drawn by CommonBoardDraw.
 *
 */
struct MENUFORM_MAKEBRD_INFO {
    MENUFORM_MAKEBRD_LINE line[4];               /**< Lines of the board. */
    int                   material_num;          /**< Number of materials listed. */
    int                   make_num;              /**< Number of objects selected for creation. */
    int                   make_cursor;           /**< Selected row on the building board. */
    int                   decrease_flash_frames; /**< Frames left in the decrease button flash. */
    int                   increase_flash_frames; /**< Frames left in the increase button flash. */
};

STATIC_ASSERT(sizeof(MENUFORM_MAKEBRD_INFO) == 0x2C);

/**
 *
 * State of one particle of a menu effect; the meaning of each value
 * depends on the effect kind.
 *
 */
struct MENU_EFFECT_INFO {
    float unk_0;
    float unk_4;
    float unk_8;
    float x; /**< Screen position. */
    float y; /**< Screen position. */
    float unk_14;
    float unk_18;
    float unk_1c;
    float unk_20;
    float unk_24;
    float unk_28;
    float unk_2c;
    float unk_30;
    float unk_34;
    float unk_38;
    float unk_3c;
};

STATIC_ASSERT(sizeof(MENU_EFFECT_INFO) == 0x40);

/**
 *
 * One spark of a repair effect.
 *
 */
struct REPAIR_EFFECT_PARTICLE {
    float unk_0;
    float unk_4;
    float unk_8;
    float alpha; /**< Alpha; the spark ends when it reaches 0. */
    float vx;    /**< Horizontal speed. */
    float unk_14;
    float x;       /**< Screen position. */
    float y;       /**< Screen position. */
    int   counter; /**< Frames the spark has lived. */
    u8    unk_24;
    u8    active; /**< Non-zero while the spark lives. */
    u8    unk_26[0xa];
};

STATIC_ASSERT(sizeof(REPAIR_EFFECT_PARTICLE) == 0x30);

/**
 *
 * Form of a menu screen: a positioned group of parts read from a menu
 * layout script, which moves, fades and sways as a unit and is drawn in
 * the manager's draw list order.
 *
 */
class CMenuPosDataForm {
public:
    u8                  active;      /**< Non-zero once the slot holds a form. */
    u8                  draw_flag;   /**< Non-zero to draw the form. */
    u8                  dtype;       /**< Kind of drawing, a MENUFORM_DTYPE. */
    u8                  step_stop;   /**< Non-zero to skip the form's per-frame step. */
    s16                 clip_w;      /**< Width of the scissor area of a clip form. */
    s16                 clip_h;      /**< Height of the scissor area of a clip form. */
    s16                 vibe_cnt[2]; /**< Half period of the horizontal and vertical sway, in frames; 0 for none. */
    float               x;           /**< Screen position. */
    float               y;           /**< Screen position. */
    char               *name;        /**< Name the form is looked up by. */
    int                 counter;     /**< Frames stepped, wrapping after 100000. */
    u8                  sub_no;      /**< Message window or list the form draws. */
    u8                  unk_1d[0x3];
    u8                  mtype; /**< Way of moving to the next position, a MENUFORM_MTYPE; MENUFORM_MTYPE_N is stored as 0xFF. */
    u8                  unk_21[0x3];
    int                 next_x;          /**< Position the form moves to. */
    int                 next_y;          /**< Position the form moves to. */
    float               rate_x;          /**< Horizontal speed or divisor of the movement. */
    float               rate_y;          /**< Vertical speed or divisor of the movement. */
    s16                 chara_tex_block; /**< Texture block of the model drawn by a poly form, or below 1 to draw its frame directly. */
    s16                 secondary_tex_block;
    CActionChara       *chara; /**< Model drawn by a poly form. */
    u8                  unk_3c[0x4];
    float               ambient[4];     /**< Ambient light a poly form is drawn with, unused when negative. */
    u8                  rgba_bit;       /**< Bits of the RGBA channels for which the form colour replaces the part colour. */
    s8                  rgba_add[4];    /**< Per-frame change of each colour channel; 0 when settled. */
    u8                  rgba[4];        /**< Form colour and alpha. */
    u8                  rgba_target[4]; /**< Value each colour channel changes towards. */
    u8                  unk_5d;
    s16                 action_no;    /**< Index of the running action, or -1 for none. */
    s16                 action_state; /**< 1 while an action runs, 4 once its movement ends. */
    s16                 action_num;   /**< Number of entries in action. */
    MENU_FORM_ACTION   *action;       /**< Actions of the form. */
    s16                 parts_num;    /**< Number of entries in parts. */
    MENUFORMPARTS_TYPE *parts;        /**< Parts of the form. */
    CMenuPosDataForm   *prev;         /**< Previous form in the draw list. */
    CMenuPosDataForm   *next;         /**< Next form in the draw list. */
    u8                  unk_78[0x8];

    /**
     *
     * Moves the form to a screen position.
     *
     */
    void SetPos(int pos_x, int pos_y) {
        x = pos_x;
        y = pos_y;
    }

    /**
     *
     * Empties the form: no parts or actions, not active, white, no movement
     * and unlinked from the draw list.
     *
     * @mangled Initialize__16CMenuPosDataFormFv
     * @address 0x227AF0
     * @size 0xD0
     */
    void Initialize();

    /**
     *
     * Returns the part of the given name, or NULL.
     *
     * @mangled GetPartInfo__16CMenuPosDataFormFPc
     * @address 0x227BC0
     * @size 0xA0
     */
    MENUFORMPARTS_TYPE *GetPartInfo(char *part_name);

    /**
     *
     * Shows or hides the part of the given name.
     *
     * @mangled SetPartDrawFlag__16CMenuPosDataFormFPcb
     * @address 0x227C60
     * @size 0x30
     */
    void SetPartDrawFlag(char *part_name, bool draw);

    /**
     *
     * Sets the model a poly form draws and the texture block it is drawn with.
     *
     * @mangled SetActionCharaPtr__16CMenuPosDataFormFP12CActionCharaii
     * @address 0x227D50
     * @size 0x10
     */
    void SetActionCharaPtr(CActionChara *character, int texture_block, int secondary_block);

    /**
     *
     * Starts one colour channel changing by the given step towards a target.
     *
     * @mangled SetRGBACalcParam__16CMenuPosDataFormFiii
     * @address 0x227D60
     * @size 0x30
     */
    void SetRGBACalcParam(int index, int from, int to);

    /**
     *
     * Fades the form in over the given number of frames, optionally starting
     * from white with zero alpha.
     *
     * @mangled FormFadeIn__16CMenuPosDataFormFii
     * @address 0x227D90
     * @size 0xA0
     */
    void FormFadeIn(int frames, int reset);

    /**
     *
     * Fades the form out over the given number of frames, optionally starting
     * from full white.
     *
     * @mangled FormFadeOut__16CMenuPosDataFormFii
     * @address 0x227E30
     * @size 0xA0
     */
    void FormFadeOut(int frames, int reset);

    /**
     *
     * Sets the number a number part of the given name shows.
     *
     * @mangled SetNumber__16CMenuPosDataFormFPci
     * @address 0x227ED0
     * @size 0x30
     */
    void SetNumber(char *part_name, int number);

    /**
     *
     * Sets the colour of the part of the given name.
     *
     * @mangled SetPartRGBA__16CMenuPosDataFormFPciiii
     * @address 0x227F00
     * @size 0x60
     */
    void SetPartRGBA(char *part_name, int r, int g, int b, int a);

    /**
     *
     * Gets the screen position of a part, or of the form for a NULL name,
     * in whole pixels.
     *
     * @mangled GetPutPosXY__16CMenuPosDataFormFPcRiRi
     * @address 0x227F60
     * @size 0x80
     */
    void GetPutPosXY(char *part_name, int &out_x, int &out_y);

    /**
     *
     * Gets the screen position of a part, or of the form for a NULL name,
     * including the current sway.
     *
     * @mangled GetPutPosXY__16CMenuPosDataFormFPcRfRf
     * @address 0x227FE0
     * @size 0x2F0
     */
    void GetPutPosXY(char *part_name, float &out_x, float &out_y);

    /**
     *
     * Returns the first part slot not yet in use, or NULL.
     *
     * @mangled GetEnableEnterPart__16CMenuPosDataFormFv
     * @address 0x2282D0
     * @size 0x60
     */
    MENUFORMPARTS_TYPE *GetEnableEnterPart();

    /**
     *
     * Applies the part's running effects to its corner positions and colour.
     *
     * @mangled GetNowPosRGBA__16CMenuPosDataFormFP18MENUFORMPARTS_TYPEP16MENU_BASETEXINFOPfPUc
     * @address 0x228330
     * @size 0x670
     */
    int GetNowPosRGBA(MENUFORMPARTS_TYPE *part, MENU_BASETEXINFO *tex_info, float *pos, u8 *rgba);

    /**
     *
     * Advances the effects of every part by one frame.
     *
     * @mangled MenuPartsStep__16CMenuPosDataFormFv
     * @address 0x2289A0
     * @size 0x360
     */
    void MenuPartsStep();

    /**
     *
     * Advances the form by one frame: movement, sway counter, colour fades and
     * part effects. Returns non-zero once the form has reached its target.
     *
     * @mangled MenuFormStep__16CMenuPosDataFormFv
     * @address 0x22A840
     * @size 0x260
     */
    int MenuFormStep();

    /**
     *
     * Returns non-zero when the form stands at the given position.
     *
     * @mangled CheckMoveEnd__16CMenuPosDataFormFii
     * @address 0x22AAA0
     * @size 0x50
     */
    int CheckMoveEnd(int target_x, int target_y);

    /**
     *
     * Returns non-zero when the running action has ended or the form stands at
     * its next position.
     *
     * @mangled CheckMoveEnd__16CMenuPosDataFormFv
     * @address 0x22AAF0
     * @size 0x70
     */
    int CheckMoveEnd();

    /**
     *
     * Starts the action of the given name, or stops any action when there is
     * none of that name.
     *
     * @mangled SetAction__16CMenuPosDataFormFPc
     * @address 0x22AB60
     * @size 0x90
     */
    void SetAction(char *action_name);

    /**
     *
     * Sets the position the form moves to and the way it moves there.
     *
     * @mangled SetNextMovePos__16CMenuPosDataFormFPii
     * @address 0x22ABF0
     * @size 0x20
     */
    void SetNextMovePos(int *pos, int move_type);

    /**
     *
     * Computes the form's position one frame further along its movement.
     *
     * @mangled GetNextMovePos__16CMenuPosDataFormFPi
     * @address 0x22AC10
     * @size 0x330
     */
    int GetNextMovePos(int *out_pos);

    /**
     *
     * Draws every visible part of the form at the given swayed position.
     *
     * @mangled MenuFormDrawNormal__16CMenuPosDataFormFiiffRi
     * @address 0x22B0E0
     * @size 0xFE8
     */
    void MenuFormDrawNormal(int x, int y, float sway_x, float sway_y, int &tex_block);

    /**
     *
     * Draws the form at the given position in the way its dtype selects.
     *
     * @mangled MenuFormDraw__16CMenuPosDataFormFiiRi
     * @address 0x22C0D0
     * @size 0x860
     */
    void MenuFormDraw(int x, int y, int &tex_block);

    /**
     *
     * Draws the form at its own position.
     *
     * @mangled MenuFormDraw__16CMenuPosDataFormFRi
     * @address 0x22C930
     * @size 0x60
     */
    void MenuFormDraw(int &state);
};

STATIC_ASSERT(sizeof(CMenuPosDataForm) == 0x80);

/**
 *
 * Tables read from a menu layout script: named values, texture rectangles
 * and forms, with the forms chained into a draw list.
 *
 */
class CPosDataManage {
public:
    MENU_ETCINFO     *etc_tbl;      /**< Named integer pairs. */
    u16               etc_tbl_num;  /**< Number of entries in etc_tbl. */
    MENU_ETCINFO2    *etc_tbl2;     /**< Named sets of four numbers. */
    u16               etc_tbl2_num; /**< Number of entries in etc_tbl2. */
    MENU_BASETEXINFO *tex_info;     /**< Named texture rectangles. */
    u16               tex_info_num; /**< Number of entries in tex_info. */
    CMenuPosDataForm *form;         /**< Forms. */
    u16               form_num;     /**< Number of entries in form. */
    u8                step_stop;    /**< Non-zero to stop every form's per-frame step. */

    /**
     *
     * Empties every table.
     *
     * @mangled Initialize__14CPosDataManageFv
     * @address 0x22C990
     * @size 0x20
     */
    void Initialize();

    /**
     *
     * Returns the texture rectangle of the given index, or NULL.
     *
     * @mangled GetTexGetInfo__14CPosDataManageFi
     * @address 0x22C9B0
     * @size 0x40
     */
    MENU_BASETEXINFO *GetTexGetInfo(int no);

    /**
     *
     * Returns the texture rectangle of the given name, or NULL.
     *
     * @mangled GetTexGetInfo__14CPosDataManageFPc
     * @address 0x22C9F0
     * @size 0xB0
     */
    MENU_BASETEXINFO *GetTexGetInfo(char *info_name);

    /**
     *
     * Returns the index of the texture rectangle of the given name, or -1.
     *
     * @mangled GetTexGetInfoTblNo__14CPosDataManageFPc
     * @address 0x22CAA0
     * @size 0xA0
     */
    int GetTexGetInfoTblNo(char *info_name);

    /**
     *
     * Empties a range of texture rectangles.
     *
     * @mangled TexGetInfoClear__14CPosDataManageFii
     * @address 0x22CB40
     * @size 0x80
     */
    void TexGetInfoClear(int from, int to);

    /**
     *
     * Moves every texture rectangle cut from the named texture to another
     * texture block.
     *
     * @mangled ResetTextureBlockNo__14CPosDataManageFPci
     * @address 0x22CBC0
     * @size 0xA0
     */
    void ResetTextureBlockNo(char *tex_name, int tex_block);

    /**
     *
     * Looks up again the texture of every part of every form.
     *
     * @mangled ResetTextureInfoAll__14CPosDataManageFv
     * @address 0x22CC60
     * @size 0xC0
     */
    void ResetTextureInfoAll();

    /**
     *
     * Empties a range of named integer pairs.
     *
     * @mangled EtcTblClear__14CPosDataManageFii
     * @address 0x22CD20
     * @size 0x60
     */
    void EtcTblClear(int from, int to);

    /**
     *
     * Returns the named integer pair of the given name, or NULL.
     *
     * @mangled GetEtcTbl__14CPosDataManageFPc
     * @address 0x22CD80
     * @size 0x90
     */
    MENU_ETCINFO *GetEtcTbl(char *info_name);

    /**
     *
     * Gets the values of the named integer pair, or zeroes when there is none.
     *
     * @mangled GetEtcTblValue__14CPosDataManageFPcRiRi
     * @address 0x22CE10
     * @size 0x80
     */
    void GetEtcTblValue(char *info_name, int &value1, int &value2);

    /**
     *
     * Returns the named set of four numbers of the given name, or NULL.
     *
     * @mangled GetEtcTbl2__14CPosDataManageFPc
     * @address 0x22CE90
     * @size 0x90
     */
    MENU_ETCINFO2 *GetEtcTbl2(char *info_name);

    /**
     *
     * Copies the first values of the named set of four numbers.
     *
     * @mangled GetEtcTbl2Value__14CPosDataManageFPcPfi
     * @address 0x22CF20
     * @size 0xE0
     */
    void GetEtcTbl2Value(char *info_name, float *out_values, int count);

    /**
     *
     * Empties a range of named sets of four numbers.
     *
     * @mangled EtcTbl2Clear__14CPosDataManageFii
     * @address 0x22D000
     * @size 0x60
     */
    void EtcTbl2Clear(int from, int to);

    /**
     *
     * Returns the form of the given name, searching in draw list order, or NULL.
     *
     * @mangled GetFormInfo__14CPosDataManageFPc
     * @address 0x22D0A0
     * @size 0xB0
     */
    CMenuPosDataForm *GetFormInfo(char *form_name);

    /**
     *
     * Returns the form of the given index, or NULL.
     *
     * @mangled GetFormInfo__14CPosDataManageFi
     * @address 0x22D150
     * @size 0x40
     */
    CMenuPosDataForm *GetFormInfo(int no);

    /**
     *
     * Empties a range of forms.
     *
     * @mangled FormInfoClear__14CPosDataManageFii
     * @address 0x22D190
     * @size 0x90
     */
    void FormInfoClear(int from, int to);

    /**
     *
     * Moves the form of the given name to a position at once.
     *
     * @mangled SetFormPos__14CPosDataManageFPcPi
     * @address 0x22D220
     * @size 0x50
     */
    void SetFormPos(char *form_name, int *pos);

    /**
     *
     * Chains every named form into the draw list in index order.
     *
     * @mangled InitDrawList__14CPosDataManageFv
     * @address 0x22D270
     * @size 0x90
     */
    void InitDrawList();

    /**
     *
     * Returns the first form of the draw list.
     *
     * @mangled GetDrawTopList__14CPosDataManageFv
     * @address 0x22D300
     * @size 0x50
     */
    CMenuPosDataForm *GetDrawTopList();

    /**
     *
     * Swaps the places of two forms in the draw list.
     *
     * @mangled FormReLink__14CPosDataManageFPcPc
     * @address 0x22D350
     * @size 0xC0
     */
    void FormReLink(char *form_name0, char *target);

    /**
     *
     * Swaps the places of two runs of forms in the draw list.
     *
     * @mangled FormReLink2__14CPosDataManageFPcPcPcPc
     * @address 0x22D410
     * @size 0x140
     */
    void FormReLink2(char *form, char *target, char *third, char *fourth);

    /**
     *
     * Steps every form of the draw list.
     *
     * @mangled FormStep__14CPosDataManageFv
     * @address 0x22D550
     * @size 0x90
     */
    void FormStep();

    /**
     *
     * Draws every form of the draw list.
     *
     * @mangled FormDraw__14CPosDataManageFv
     * @address 0x22D660
     * @size 0x60
     */
    void FormDraw();

    /**
     *
     * Empties the named values, texture rectangles and forms.
     *
     * @mangled ClearPos__14CPosDataManageFv
     * @address 0x22D6C0
     * @size 0x50
     */
    void ClearPos();
};

STATIC_ASSERT(sizeof(CPosDataManage) == 0x20);

/**
 *
 * Layout tables of the menu screens, with the textures and item icon
 * palettes that every menu screen shares.
 *
 */
class CMenuPosDataManage : public CPosDataManage {
public:
    u_long128  *pallet[3][2];       /**< Item icon palettes: normal, grey and sepia, for each icon texture. */
    s16         trans_pallet_no[2]; /**< First transparent entry of each item icon palette. */
    mgCTexture *common_tex;         /**< Common menu texture. */
    int         unk_40;
    int         unk_44;
    int         unk_48;
    mgCTexture *icon_effect_tex;       /**< Texture of the item icon effects. */
    mgCTexture *effect_tex;            /**< Texture of the menu effects. */
    mgCTexture *item_icon_tex[4][2];   /**< Item icon textures: original, normal, grey and sepia, for each icon texture. */
    float       fish_jump_wait[150];   /**< Frames until each item board fish next jumps. */
    float       fish_jump_height[150]; /**< Height of the current jump of each item board fish. */
    s8          fish_jump_count[150];  /**< Bounces left in the current jump of each item board fish. */

    /**
     *
     * Looks up the textures every menu screen shares.
     *
     * @mangled AttachCommonTexInfo__18CMenuPosDataManageFv
     * @address 0x22D710
     * @size 0xB0
     */
    void AttachCommonTexInfo();

    /**
     *
     * Moves the main menu icons towards their places for a mode, highlighting
     * the selected one. Returns non-zero once every icon has arrived.
     *
     * @mangled StepMainMenuIconMove__18CMenuPosDataManageFPiii
     * @address 0x22D7C0
     * @size 0x2F0
     */
    int StepMainMenuIconMove(int *icons, int select, int mode);

    /**
     *
     * Gets the screen position of a cell of the item board, optionally kept
     * inside the board.
     *
     * @mangled GetPosMenuItemBrdKoma__18CMenuPosDataManageFPiii
     * @address 0x22E490
     * @size 0x110
     */
    void GetPosMenuItemBrdKoma(int *position, int item_index, int clip);

    /**
     *
     * Gets the screen position of the item icon in a cell of the item board.
     *
     * @mangled GetPosMenuItemOnItemBrd__18CMenuPosDataManageFPiii
     * @address 0x22E5A0
     * @size 0x40
     */
    void GetPosMenuItemOnItemBrd(int *out_pos, int no, int clip);

    /**
     *
     * Gets the screen position of the effect over a cell of the item board.
     *
     * @mangled GetPosMenuItemBrdForEffect__18CMenuPosDataManageFPiii
     * @address 0x22E5E0
     * @size 0x40
     */
    void GetPosMenuItemBrdForEffect(int *out_pos, int no, int clip);

    /**
     *
     * Builds the normal, grey and sepia copies of the item icon palettes and
     * the textures that use them.
     *
     * @mangled MallocPallet__18CMenuPosDataManageFP9mgCMemory
     * @address 0x22E850
     * @size 0x470
     */
    void MallocPallet(mgCMemory *stack);

    /**
     *
     * Finds the first transparent entry of each item icon palette.
     *
     * @mangled SearchTransPalletNo__18CMenuPosDataManageFv
     * @address 0x22ECC0
     * @size 0x70
     */
    void SearchTransPalletNo();

    /**
     *
     * Empties every table and clears the shared textures.
     *
     * @mangled InitializeCMenuPosDataManage__18CMenuPosDataManageFv
     * @address 0x22ED30
     * @size 0x90
     */
    void InitializeCMenuPosDataManage();
};

STATIC_ASSERT(sizeof(CMenuPosDataManage) == 0x5BC);

/**
 *
 * Burst of sparks shown when a weapon is repaired.
 *
 */
class CRepairEffect {
public:
    u8                      active;       /**< Non-zero while any spark lives. */
    int                     particle_num; /**< Number of entries in particle. */
    int                     counter;      /**< Frames the effect has run. */
    int                     x;            /**< Screen position. */
    int                     y;            /**< Screen position. */
    int                     alpha;        /**< Alpha of the flash. */
    REPAIR_EFFECT_PARTICLE *particle;     /**< Sparks. */
    mgCTexture             *unk_1c;
    mgCTexture             *tex; /**< Texture the effect is drawn with. */

    /**
     *
     * Clears the effect.
     *
     * @mangled Initialize__13CRepairEffectFv
     * @address 0x22F5D0
     * @size 0x20
     */
    void Initialize();

    /**
     *
     * Starts the effect with the given number of sparks allocated from a stack.
     *
     * @mangled Generate__13CRepairEffectFP9mgCMemoryi
     * @address 0x22F5F0
     * @size 0x190
     */
    void Generate(mgCMemory *memory, int particle_count);

    /**
     *
     * Advances the sparks by one frame.
     *
     * @mangled Step__13CRepairEffectFv
     * @address 0x22F780
     * @size 0xF0
     */
    void Step();

    /**
     *
     * Draws the flash and the sparks.
     *
     * @mangled Draw__13CRepairEffectFv
     * @address 0x22F870
     * @size 0x1F0
     */
    void Draw();
};

STATIC_ASSERT(sizeof(CRepairEffect) == 0x24);

/**
 *
 * Runs the repair effects and the repair model shown on the item menu.
 *
 */
class CRepairManager {
public:
    u8             bg_load;         /**< Non-zero while the repair data is read in the background. */
    u8             data_ready;      /**< Non-zero once the repair data is loaded. */
    s16            tex_block;       /**< Texture block of the repair textures. */
    CRepairEffect *effect[8];       /**< Running effects. */
    mgCMemory      effect_stack[8]; /**< Stack each effect is allocated from. */
    mgCTexture    *unk_1a4;
    mgCTexture    *tex;           /**< Texture of the effects. */
    u32           *data;          /**< Pack file of the repair data. */
    CActionChara  *model;         /**< Repair model, or NULL. */
    mgCMemory      model_stack;   /**< Stack the model is allocated from. */
    float          model_counter; /**< Frames the model has run. */
    u8             keep;          /**< Non-zero to keep the data after the effects end. */

    /**
     *
     * Clears every effect and the model.
     *
     * @mangled Initialize__14CRepairManagerFv
     * @address 0x22FA60
     * @size 0xA0
     */
    void Initialize();

    /**
     *
     * Carves the effect and model stacks out of a stack.
     *
     * @mangled SetStack__14CRepairManagerFP9mgCMemoryi
     * @address 0x22FB00
     * @size 0x110
     */
    void SetStack(mgCMemory *memory, int mode);

    /**
     *
     * Clears every effect and the model.
     *
     * @mangled Clear__14CRepairManagerFv
     * @address 0x22FC10
     * @size 0x10
     */
    void Clear();

    /**
     *
     * Starts reading the repair data in the background.
     *
     * @mangled LoadDataBG__14CRepairManagerFP9mgCMemory
     * @address 0x22FC20
     * @size 0xC0
     */
    void LoadDataBG(mgCMemory *memory);

    /**
     *
     * Registers the repair textures once the background read has finished.
     *
     * @mangled CheckDataBG__14CRepairManagerFi
     * @address 0x22FCE0
     * @size 0xA0
     */
    void CheckDataBG(int new_tex_block);

    /**
     *
     * Registers already loaded repair data.
     *
     * @mangled SetRepairData__14CRepairManagerFP9mgCMemoryiPUi
     * @address 0x22FD80
     * @size 0xB0
     */
    void SetRepairData(mgCMemory *memory, int new_tex_block, u32 *pack);

    /**
     *
     * Creates the repair model at a position.
     *
     * @mangled GeneratePoly__14CRepairManagerFPfi
     * @address 0x22FE30
     * @size 0x240
     */
    void GeneratePoly(float *pos, int block);

    /**
     *
     * Starts a repair effect at a screen position in a free slot.
     *
     * @mangled Generate__14CRepairManagerFii
     * @address 0x230070
     * @size 0x110
     */
    void Generate(int x, int y);

    /**
     *
     * Returns non-zero while the repair model exists.
     *
     * @mangled IsRunModel__14CRepairManagerFv
     * @address 0x230180
     * @size 0x10
     */
    int IsRunModel();

    /**
     *
     * Returns non-zero while any effect or the model runs.
     *
     * @mangled IsRun__14CRepairManagerFv
     * @address 0x230190
     * @size 0x70
     */
    int IsRun();

    /**
     *
     * Advances the model and every effect by one frame.
     *
     * @mangled Step__14CRepairManagerFv
     * @address 0x230200
     * @size 0x200
     */
    void Step();

    /**
     *
     * Draws the model and every effect.
     *
     * @mangled Draw__14CRepairManagerFv
     * @address 0x230400
     * @size 0x90
     */
    void Draw();
};

STATIC_ASSERT(sizeof(CRepairManager) == 0x1EC);

/**
 *
 * Level-up indicator: a rising label, or sparks rising from a character.
 *
 */
class CLevelUpEffect {
public:
    u8            active;  /**< Non-zero while the effect runs. */
    int           counter; /**< Frames the label has risen. */
    int           kind;    /**< Colour and label of the effect. */
    sceVu0FVECTOR pos;     /**< Screen position of the label, or world position of the character. */
    mgCTexture   *tex;     /**< Texture the effect is drawn with. */
    CCharacter2  *chara;   /**< Character the sparks rise from, or NULL for the label. */

    /**
     *
     * Clears the effect.
     *
     * @mangled Initialize__14CLevelUpEffectFv
     * @address 0x230490
     * @size 0x10
     */
    void Initialize();

    /**
     *
     * Starts the rising label at a screen position.
     *
     * @mangled Generate__14CLevelUpEffectFP10mgCTextureiii
     * @address 0x2304A0
     * @size 0x40
     */
    void Generate(mgCTexture *spark_texture, int param, int x, int y);

    /**
     *
     * Starts the sparks rising from a character.
     *
     * @mangled Generate__14CLevelUpEffectFP10mgCTextureiP11CCharacter2
     * @address 0x2304E0
     * @size 0x190
     */
    void Generate(mgCTexture *spark_texture, int param, CCharacter2 *target);

    /**
     *
     * Returns non-zero while the effect runs.
     *
     * @mangled IsRun__14CLevelUpEffectFv
     * @address 0x230670
     * @size 0x10
     */
    int IsRun();

    /**
     *
     * Advances the effect by one frame.
     *
     * @mangled Step__14CLevelUpEffectFv
     * @address 0x230680
     * @size 0x230
     */
    void Step();

    /**
     *
     * Draws the effect.
     *
     * @mangled Draw__14CLevelUpEffectFv
     * @address 0x2308B0
     * @size 0x230
     */
    void Draw();
};

STATIC_ASSERT(sizeof(CLevelUpEffect) == 0x30);

/**
 *
 * Runs the level-up effects of the item menu.
 *
 */
class CLevelUpEffectManager {
public:
    mgCTexture    *label_tex; /**< Texture of the rising labels. */
    mgCTexture    *spark_tex; /**< Texture of the sparks. */
    CLevelUpEffect effect[8]; /**< Effects. */

    /**
     *
     * Clears every effect.
     *
     * @mangled Initialize__21CLevelUpEffectManagerFv
     * @address 0x230AE0
     * @size 0x60
     */
    void Initialize();

    /**
     *
     * Returns non-zero while any effect runs.
     *
     * @mangled IsRun__21CLevelUpEffectManagerFv
     * @address 0x230B40
     * @size 0x70
     */
    int IsRun();

    /**
     *
     * Starts a rising label in a free slot.
     *
     * @mangled Generate__21CLevelUpEffectManagerFiii
     * @address 0x230BB0
     * @size 0xC0
     */
    void Generate(int param, int x, int y);

    /**
     *
     * Starts sparks rising from a character in a free slot.
     *
     * @mangled Generate__21CLevelUpEffectManagerFiP11CCharacter2
     * @address 0x230C70
     * @size 0xA0
     */
    void Generate(int param, CCharacter2 *chara);

    /**
     *
     * Advances every effect by one frame.
     *
     * @mangled Step__21CLevelUpEffectManagerFv
     * @address 0x230D10
     * @size 0x60
     */
    void Step();

    /**
     *
     * Draws every effect.
     *
     * @mangled Draw__21CLevelUpEffectManagerFv
     * @address 0x230D70
     * @size 0x60
     */
    void Draw();
};

STATIC_ASSERT(sizeof(CLevelUpEffectManager) == 0x190);

/**
 *
 * Single star that fades out after a set time.
 *
 */
class CStarDust {
public:
    float x;      /**< Screen position. */
    float y;      /**< Screen position. */
    s16   life;   /**< Frames left to live. */
    u8    active; /**< Non-zero while the star lives. */

    /**
     *
     * Creates an idle star.
     *
     * @mangled __ct__9CStarDustFv
     * @address 0x2082C0
     * @size 0x10
     */
    CStarDust();

    /**
     *
     * Starts the star at a screen position with a partly random lifetime.
     *
     * @mangled Generate__9CStarDustFiiii
     * @address 0x230DD0
     * @size 0x60
     */
    void Generate(int pos_x, int pos_y, int life_base, int life_range);

    /**
     *
     * Counts down the star's lifetime.
     *
     * @mangled Step__9CStarDustFv
     * @address 0x230E30
     * @size 0x30
     */
    void Step();

    /**
     *
     * Draws the star with an 8 by 8 texel image.
     *
     * @mangled Draw__9CStarDustFP10mgCTextureii
     * @address 0x230E60
     * @size 0x120
     */
    void Draw(mgCTexture *tex, int u, int v);
};

STATIC_ASSERT(sizeof(CStarDust) == 0xC);

/**
 *
 * Rising vertical streak of light shown around a character during a weapon
 * build-up.
 *
 */
class CEffVerticalLine {
public:
    sceVu0FVECTOR pos;       /**< World position. */
    float         w;         /**< Width. */
    float         h;         /**< Height. */
    float         speed;     /**< Rising speed. */
    float         r;         /**< Colour. */
    float         g;         /**< Colour. */
    float         b;         /**< Colour. */
    float         alpha;     /**< Peak alpha. */
    float         angle;     /**< Phase of the fade, from 0 to pi. */
    float         angle_add; /**< Per-frame change of angle. */

    /**
     *
     * Starts the streak at a random place around a position.
     *
     * @mangled Generate__16CEffVerticalLineFPfff
     * @address 0x231050
     * @size 0x1C0
     */
    void Generate(float *center, float range, float height);

    /**
     *
     * Raises and fades the streak by one frame.
     *
     * @mangled Step__16CEffVerticalLineFv
     * @address 0x231210
     * @size 0xC0
     */
    void Step();

    /**
     *
     * Draws the streak and its glow.
     *
     * @mangled Draw__16CEffVerticalLineFv
     * @address 0x2312D0
     * @size 0x250
     */
    void Draw();
};

STATIC_ASSERT(sizeof(CEffVerticalLine) == 0x40);

/**
 *
 * Particle effect of the item menus, such as the breaking or fusing of a
 * spectrum.
 *
 */
class CMenuEffect {
public:
    s16               tex_block;     /**< Texture block of the texture. */
    mgCTexture       *tex;           /**< Texture the effect is drawn with. */
    u8                end;           /**< Non-zero once the effect has ended. */
    s8                type;          /**< Kind of effect, or -1 for none. */
    u8                run;           /**< Non-zero while the effect runs. */
    s16               info_num;      /**< Number of entries in info. */
    MENU_EFFECT_INFO *info;          /**< Particles. */
    s16               base_info[16]; /**< Base parameters, such as positions, given when the effect is set. */
    s16               alpha;         /**< Alpha of the whole effect. */
    s16               counter;       /**< Frames the effect has run. */

    /**
     *
     * Clears the effect.
     *
     * @mangled Initialize__11CMenuEffectFv
     * @address 0x231DD0
     * @size 0x30
     */
    void Initialize();

    /**
     *
     * Prepares an effect of the given kind with its particles and base
     * parameters.
     *
     * @mangled PresetEffect__11CMenuEffectFP9mgCMemoryP10mgCTextureiPi
     * @address 0x231E00
     * @size 0x1B0
     */
    void PresetEffect(mgCMemory *memory, mgCTexture *texture, int kind, int *base);

    /**
     *
     * Allocates the particles from a stack.
     *
     * @mangled SetMemory__11CMenuEffectFP9mgCMemory
     * @address 0x231FB0
     * @size 0x50
     */
    void SetMemory(mgCMemory *memory);

    /**
     *
     * Sets the texture and, when given, its texture block.
     *
     * @mangled SetTexInfo__11CMenuEffectFP10mgCTexturePi
     * @address 0x232000
     * @size 0x20
     */
    void SetTexInfo(mgCTexture *texture, int *params);

    /**
     *
     * Copies the base parameters and optionally prepares every particle.
     *
     * @mangled SetBaseInfo__11CMenuEffectFPiiii
     * @address 0x232020
     * @size 0xE0
     */
    void SetBaseInfo(int *values, int preset, int kind, int count);

    /**
     *
     * Starts the effect.
     *
     * @mangled EffectStart__11CMenuEffectFv
     * @address 0x232100
     * @size 0x10
     */
    void EffectStart();

    /**
     *
     * Prepares every particle.
     *
     * @mangled PresetInfoAll__11CMenuEffectFi
     * @address 0x232110
     * @size 0x80
     */
    void PresetInfoAll(int kind);

    /**
     *
     * Prepares one particle for the effect's kind.
     *
     * @mangled PresetInfo__11CMenuEffectFP16MENU_EFFECT_INFOii
     * @address 0x232190
     * @size 0xA40
     */
    void PresetInfo(MENU_EFFECT_INFO *particle, int no, int mode);

    /**
     *
     * Advances the effect by one frame.
     *
     * @mangled Step__11CMenuEffectFv
     * @address 0x232BD0
     * @size 0x1550
     */
    void Step();

    /**
     *
     * Draws the effect.
     *
     * @mangled Draw__11CMenuEffectFv
     * @address 0x234120
     * @size 0xA00
     */
    void Draw();
};

STATIC_ASSERT(sizeof(CMenuEffect) == 0x38);

/**
 *
 * Looks up the forms of the nine menu message windows.
 *
 * @mangled AttachMessageForm__Fv
 * @address 0x2214F0
 * @size 0x70
 */
void AttachMessageForm();

/**
 *
 * Clears the contents of a creation board.
 *
 * @mangled Init_MENUFORM_MAKEBRD_INFO__FP21MENUFORM_MAKEBRD_INFO
 * @address 0x221560
 * @size 0x10
 */
void Init_MENUFORM_MAKEBRD_INFO(MENUFORM_MAKEBRD_INFO *board);

/**
 *
 * Gets the texel rectangle of an item's icon.
 *
 * @mangled GetMenuItemIconTexGetXY__FiR9mgRect_i_
 * @address 0x221570
 * @size 0xB0
 */
void GetMenuItemIconTexGetXY(int item, mgRect<int> &out_rect);

/**
 *
 * Returns the icon texture of an item in the given colouring, or NULL.
 *
 * @mangled GetMenuItemIconTexInfo__Fii
 * @address 0x221620
 * @size 0xB0
 */
mgCTexture *GetMenuItemIconTexInfo(int item, int index);

/**
 *
 * Sets the drawing state for menu sprites.
 *
 * @mangled SetSpriteEnv__FP11mgCDrawPrimi
 * @address 0x221A60
 * @size 0x2B0
 */
void SetSpriteEnv(mgCDrawPrim *prim, int mode);

/**
 *
 * Writes a sprite at a position with the size of its texel rectangle.
 *
 * @mangled PrimQuad__FP11mgCDrawPrimff9mgRect_i_
 * @address 0x221DC0
 * @size 0xD0
 */
void PrimQuad(mgCDrawPrim *prim, float x, float y, mgRect<int> cell);

/**
 *
 * Draws a coloured sprite of a texture at a position.
 *
 * @mangled PrimQuad__FP10mgCTextureff9mgRect_i_iiii
 * @address 0x221E90
 * @size 0xE0
 */
void PrimQuad(mgCTexture *tex, float x, float y, mgRect<int> cell, int a, int r, int g, int b);

/**
 *
 * Draws a coloured sprite of a texture at a position with a given primitive
 * builder.
 *
 * @mangled PrimQuad__FP11mgCDrawPrimP10mgCTextureff9mgRect_i_iiii
 * @address 0x221F70
 * @size 0xE0
 */
void PrimQuad(mgCDrawPrim *prim, mgCTexture *tex, float x, float y, mgRect<int> cell, int a, int r, int g, int b);

/**
 *
 * Draws a coloured sprite of a texture stretched over a screen rectangle.
 *
 * @mangled PrimQuad__FP10mgCTexture9mgRect_i_9mgRect_i_iiii
 * @address 0x222050
 * @size 0xD0
 */
void PrimQuad(mgCTexture *tex, mgRect<int> dest, mgRect<int> source, int a, int r, int g, int b);

/**
 *
 * Draws a coloured sprite of a texture stretched over a screen rectangle
 * with a given primitive builder.
 *
 * @mangled PrimQuad__FP11mgCDrawPrimP10mgCTexture9mgRect_i_9mgRect_i_iiii
 * @address 0x222120
 * @size 0xD0
 */
void PrimQuad(mgCDrawPrim *prim, mgCTexture *tex, mgRect<int> dest, mgRect<int> source, int a, int r, int g, int b);

/**
 *
 * Limits a scissor rectangle to the screen.
 *
 * @mangled MenuClipRectCheck__FR9mgRect_i_
 * @address 0x2221F0
 * @size 0x60
 */
void MenuClipRectCheck(mgRect<int> &rect);

/**
 *
 * Limits menu drawing to a screen rectangle.
 *
 * @mangled SetMenuScissor__F9mgRect_i_
 * @address 0x222250
 * @size 0x90
 */
void SetMenuScissor(mgRect<int> rect);

/**
 *
 * Lets menu drawing cover the whole screen again.
 *
 * @mangled ResetMenuScissor__Fv
 * @address 0x2222E0
 * @size 0x80
 */
void ResetMenuScissor();

/**
 *
 * Selects the items the item board shows.
 *
 * @mangled SetModeMenuDrawItemBoard__Fi
 * @address 0x222360
 * @size 0x470
 */
int SetModeMenuDrawItemBoard(int mode);

/**
 *
 * Advances the pulsing alpha of usable items by one frame.
 *
 * @mangled EnableUseItemAlphaStep__Fv
 * @address 0x2227D0
 * @size 0x90
 */
void EnableUseItemAlphaStep();

/**
 *
 * Builds the table of wave offsets that the spectrum effect draws with.
 *
 * @mangled InitSpectolRasterTable__FP9mgCMemory
 * @address 0x222860
 * @size 0xF0
 */
void InitSpectolRasterTable(mgCMemory *memory);

/**
 *
 * Draws the icon of one item.
 *
 * @mangled DrawOneItem__FP11mgCDrawPrim9mgRect_f_iiP25MENU_PARTS_EFFECT_STRUCT1PUci
 * @address 0x222950
 * @size 0xB50
 */
void DrawOneItem(mgCDrawPrim *prim, mgRect<float> rect, int item, int mode, MENU_PARTS_EFFECT_STRUCT1 *effect, u8 *rgba, int item_flag);

/**
 *
 * Draws the contents window of the current gift box.
 *
 * @mangled MenuPresentBoxView__FiiRiP10mgCTextureP10mgCTexture
 * @address 0x223640
 * @size 0x370
 */
void MenuPresentBoxView(int x, int y, int &tex_block, mgCTexture *tex, mgCTexture *cursor_tex);

/**
 *
 * Draws a number with digits cut from a texel rectangle.
 *
 * @mangled PrimDrawNumber__FP11mgCDrawPrimiiii9mgRect_i_ii
 * @address 0x223BE0
 * @size 0xB0
 */
void PrimDrawNumber(mgCDrawPrim *prim, int number, int alignment, int x, int y, mgRect<int> texture_rect, int spacing, int vertical_spacing);

/**
 *
 * Draws a number with digits cut from a texel rectangle, in the second
 * layout.
 *
 * @mangled PrimDrawNumber2__FP11mgCDrawPrimiiii9mgRect_i_ii
 * @address 0x223C90
 * @size 0xB0
 */
void PrimDrawNumber2(mgCDrawPrim *prim, int number, int digit_count, int x, int y, mgRect<int> texture_rect, int spacing, int vertical_spacing);

/**
 *
 * Writes a filled rectangle with a colour at each corner.
 *
 * @mangled PrimFillRect4__FP11mgCDrawPrim9mgRect_f_PfPfPfPf
 * @address 0x223D40
 * @size 0x220
 */
void PrimFillRect4(mgCDrawPrim *prim, mgRect<float> rect, float *rgba0, float *rgba1, float *rgba2, float *rgba3);

/**
 *
 * Uploads a texture block unless it is the one last uploaded.
 *
 * @mangled MenuReloadTexture__FRii
 * @address 0x223F60
 * @size 0x40
 */
void MenuReloadTexture(int &loaded_tex, int tex_no);

/**
 *
 * Uploads the palette of a character change texture.
 *
 * @mangled MenuReloadCLUT__Fi
 * @address 0x223FA0
 * @size 0x50
 */
void MenuReloadCLUT(int index);

/**
 *
 * Fills the whole screen with a colour.
 *
 * @mangled DrawMenuFillBox__Fiiii
 * @address 0x223FF0
 * @size 0x20
 */
void DrawMenuFillBox(int alpha, int red, int green, int blue);

/**
 *
 * Fills a screen rectangle with a colour.
 *
 * @mangled DrawMenuFillBox__Fffffiiii
 * @address 0x224010
 * @size 0xF0
 */
void DrawMenuFillBox(float x, float y, float w, float h, int alpha, int red, int green, int blue);

/**
 *
 * Fills a screen rectangle with a colour with a given primitive builder.
 *
 * @mangled DrawMenuFillBox__FP11mgCDrawPrimffffiiii
 * @address 0x224100
 * @size 0xF0
 */
void DrawMenuFillBox(mgCDrawPrim *prim, float x, float y, float w, float h, int alpha, int red, int green, int blue);

/**
 *
 * Returns the texture of the loading progress bar.
 *
 * @mangled GetMenuDlTexture__Fv
 * @address 0x224670
 * @size 0x20
 */
mgCTexture *GetMenuDlTexture();

/**
 *
 * Starts a loading progress bar of the given total size.
 *
 * @mangled InitMenuDl__FP10mgCTexturei
 * @address 0x224690
 * @size 0x10
 */
void InitMenuDl(mgCTexture *tex, int total_size);

/**
 *
 * Adds progress to the loading progress bar. Returns non-zero once full.
 *
 * @mangled StepMenuDl__Fi
 * @address 0x2246A0
 * @size 0x40
 */
int StepMenuDl(int step);

/**
 *
 * Sets the progress of the loading progress bar. Returns non-zero once
 * full.
 *
 * @mangled StepMenuDl2__Fi
 * @address 0x2246E0
 * @size 0x40
 */
int StepMenuDl2(int progress);

/**
 *
 * Draws the loading progress bar.
 *
 * @mangled DrawMenuDl__FRiiiii
 * @address 0x224720
 * @size 0x2F0
 */
void DrawMenuDl(int &tex_block, int x, int y, int w, int alpha);

/**
 *
 * Draws the loading progress bar and its caption in the middle of the
 * screen.
 *
 * @mangled DrawMenuDl__Fi
 * @address 0x224A10
 * @size 0x160
 */
void DrawMenuDl(int alpha);

/**
 *
 * Lays out the creation board and its message for the given contents.
 *
 * @mangled CalcCommonBrdDrawInfo__FPfP21MENUFORM_MAKEBRD_INFOP6ClsMes
 * @address 0x224B70
 * @size 0x3A0
 */
void CalcCommonBrdDrawInfo(float *pos, MENUFORM_MAKEBRD_INFO *info, ClsMes *mes);

/**
 *
 * Draws the creation board.
 *
 * @mangled CommonBoardDraw__FPfRi
 * @address 0x224F10
 * @size 0xDD8
 */
void CommonBoardDraw(float *pos, int &tex_block);

/**
 *
 * Draws the menu cursor.
 *
 * @mangled MenuCursorDraw__FP10mgCTexturePffiif
 * @address 0x225CF0
 * @size 0x300
 */
void MenuCursorDraw(mgCTexture *tex, float *pos, float rot, int reverse, int alpha, float scale);

/**
 *
 * Draws the menu cursor unreversed at full size.
 *
 * @mangled MenuCursorDraw__FP10mgCTexturePffi
 * @address 0x225FF0
 * @size 0x20
 */
void MenuCursorDraw(mgCTexture *tex, float *pos, float value, int flag);

/**
 *
 * Covers the screen with a tiled texel rectangle.
 *
 * @mangled DrawMenuTilePattern__FP11mgCDrawPrimP10mgCTextureff9mgRect_i_iPUc
 * @address 0x226010
 * @size 0x1C0
 */
void DrawMenuTilePattern(mgCDrawPrim *prim, mgCTexture *tex, float x, float y, mgRect<int> tex_rect, int unused, u8 *rgba);

/**
 *
 * Draws the main menu frame image.
 *
 * @mangled DrawMenuMainFrmImg__FRi9mgRect_i_9mgRect_i_iiiii
 * @address 0x2261D0
 * @size 0xE0
 */
void DrawMenuMainFrmImg(int &loaded_tex_no, mgRect<int> dest, mgRect<int> source, int red, int green, int blue, int alpha, int a);

/**
 *
 * Returns non-zero once the main menu frame has finished moving.
 *
 * @mangled GetMenuMainFrameEndFlag__Fv
 * @address 0x2262B0
 * @size 0x10
 */
int GetMenuMainFrameEndFlag();

/**
 *
 * Returns the position of the top left corner of the main menu frame.
 *
 * @mangled GetMenuMainFrameLeftTopPos__Fi
 * @address 0x2262C0
 * @size 0x10
 */
float *GetMenuMainFrameLeftTopPos(int frame);

/**
 *
 * Returns the movement rate of the main menu frame for its current mode.
 *
 * @mangled GetMenuMainFrameCount__Fv
 * @address 0x2262D0
 * @size 0x30
 */
float GetMenuMainFrameCount();

/**
 *
 * Starts the main menu frame moving to a display mode.
 *
 * @mangled MenuMainFrameModeSet__Fii
 * @address 0x226300
 * @size 0xC0
 */
void MenuMainFrameModeSet(int mode, int restart);

/**
 *
 * Advances the main menu frame by one frame.
 *
 * @mangled MenuMainFrameStep__Fv
 * @address 0x2263C0
 * @size 0x780
 */
void MenuMainFrameStep();

/**
 *
 * Draws the main menu frame.
 *
 * @mangled MenuMainFrameDraw__FRii
 * @address 0x226B40
 * @size 0x4C0
 */
void MenuMainFrameDraw(int &loaded_tex, int alpha);

/**
 *
 * Draws the picture inside the main menu frame.
 *
 * @mangled MenuMainFrameImgDraw__FRi
 * @address 0x227000
 * @size 0x1BC
 */
void MenuMainFrameImgDraw(int &tex_block);

/**
 *
 * Advances the animation of the window frames by one frame.
 *
 * @mangled DrawMenuWakuStep__Fv
 * @address 0x2271C0
 * @size 0x110
 */
void DrawMenuWakuStep();

/**
 *
 * Draws a rectangular window frame.
 *
 * @mangled DrawMenuWakuRect__FP10mgCTexture9mgRect_f_9mgRect_i_iiii
 * @address 0x2272D0
 * @size 0x520
 */
void DrawMenuWakuRect(mgCTexture *tex, mgRect<float> rect, mgRect<int> tex_rect, int a, int r, int g, int b);

/**
 *
 * Draws a rotating circular frame.
 *
 * @mangled DrawWakuCircle__FP11mgCDrawPrimP10mgCTexture9mgRect_f_9mgRect_i_ffiiii
 * @address 0x2277F0
 * @size 0x200
 */
void DrawWakuCircle(mgCDrawPrim *prim, mgCTexture *tex, mgRect<float> rect, mgRect<int> tex_rect, float rot, float size, int a, int r, int g, int b);

/**
 *
 * Empties a form part.
 *
 * @mangled MenuPosDataTypeInit__FP18MENUFORMPARTS_TYPE
 * @address 0x227A30
 * @size 0x90
 */
void MenuPosDataTypeInit(MENUFORMPARTS_TYPE *part);

/**
 *
 * Sets the item an item icon part shows and restarts its effects.
 *
 * @mangled MenuFormPartsPresetItem__FP18MENUFORMPARTS_TYPEiii
 * @address 0x227AC0
 * @size 0x30
 */
void MenuFormPartsPresetItem(MENUFORMPARTS_TYPE *part, int visible, int value34, int value38);

/**
 *
 * Allocates the effects of a part from a stack.
 *
 * @mangled Func_MallocPartEffectInfo__FP18MENUFORMPARTS_TYPEP9mgCMemoryi
 * @address 0x227C90
 * @size 0x60
 */
void Func_MallocPartEffectInfo(MENUFORMPARTS_TYPE *part, mgCMemory *memory, int effect_count);

/**
 *
 * Sets the kind and parameters of a part effect.
 *
 * @mangled Func_SetPartEffectInfo__FP25MENU_PARTS_EFFECT_STRUCT1UiPs
 * @address 0x227CF0
 * @size 0x60
 */
void Func_SetPartEffectInfo(MENU_PARTS_EFFECT_STRUCT1 *effect, unsigned int kind, short *values);

/**
 *
 * Sets the number of lines of the item board and scrolls it to a line.
 *
 * @mangled MenuItemBrdSetInfo__Fiiii
 * @address 0x229020
 * @size 0x60
 */
void MenuItemBrdSetInfo(int unused, int pos, int max_line, int view_line);

/**
 *
 * Draws the frame and scroll bar of the item board.
 *
 * @mangled MenuItemBrdFrameDraw__FiiRiiiii
 * @address 0x229080
 * @size 0xAA0
 */
void MenuItemBrdFrameDraw(int x, int y, int &tex_block, int a, int r, int g, int b);

/**
 *
 * Draws the cells of the item board.
 *
 * @mangled MenuItemBrdDraw__FPf9mgRect_i_Riiiii
 * @address 0x229B20
 * @size 0x510
 */
void MenuItemBrdDraw(float *pos, mgRect<int> clip_rect, int &tex_block, int a, int r, int g, int b);

/**
 *
 * Draws the item icons on the item board.
 *
 * @mangled MenuItemModeItemDraw__FRi9mgRect_i_PfP18MENUFORMPARTS_TYPEP10mgCTexture9mgRect_i_i
 * @address 0x22A030
 * @size 0x810
 */
void MenuItemModeItemDraw(int &tex_block, mgRect<int> clip_rect, float *pos, MENUFORMPARTS_TYPE *parts, mgCTexture *num_tex, mgRect<int> num_rect, int unused_arg);

/**
 *
 * Draws a bar from a left end, a stretched middle and a right end.
 *
 * @mangled Menu3DivideTextureDraw__FP11mgCDrawPrim9mgRect_i_Psi
 * @address 0x22AF40
 * @size 0x1A0
 */
void Menu3DivideTextureDraw(mgCDrawPrim *prim, mgRect<int> rect, short *tex_tbl, int vertical);

/**
 *
 * Returns the name of the form of a main menu icon.
 *
 * @mangled GetMenuMainIconChar__Fi
 * @address 0x22D060
 * @size 0x40
 */
char *GetMenuMainIconChar(int no);

/**
 *
 * Advances the shared menu drawing animations by one frame.
 *
 * @mangled MenuDrawParamStep__Fv
 * @address 0x22D5E0
 * @size 0x80
 */
void MenuDrawParamStep();

/**
 *
 * Returns bits telling whether an item can be used on a target now and
 * whether it builds the target up.
 *
 * @mangled CheckItemUseVariable__FP13CGameDataUsedP14CItemUseTarget
 * @address 0x22DAB0
 * @size 0x70
 */
int CheckItemUseVariable(CGameDataUsed *item, CItemUseTarget *target);

/**
 *
 * Fills the item board parts from a list of items.
 *
 * @mangled Func_MenuItemBrdPrepare__FP18MENUFORMPARTS_TYPEP13CGameDataUsedP13CGameDataUsedi
 * @address 0x22DB20
 * @size 0xC0
 */
void Func_MenuItemBrdPrepare(MENUFORMPARTS_TYPE *parts, CGameDataUsed *items, CGameDataUsed *used, int target_kind);

/**
 *
 * Fills the item board parts from a list of items, in the second layout.
 *
 * @mangled Func_MenuItemBrdPrepare2__FP18MENUFORMPARTS_TYPEP13CGameDataUsedP13CGameDataUsed
 * @address 0x22DBE0
 * @size 0xE0
 */
void Func_MenuItemBrdPrepare2(MENUFORMPARTS_TYPE *parts, CGameDataUsed *items, CGameDataUsed *used);

/**
 *
 * Checks which items can be used now.
 *
 * @mangled NowUseNeedItemCheck__FP16CUserDataManager
 * @address 0x22DCC0
 * @size 0x300
 */
int NowUseNeedItemCheck(CUserDataManager *manager);

/**
 *
 * Sets the state bits of an item icon part for its item.
 *
 * @mangled Func_MenuIconDrawPrepare__FP18MENUFORMPARTS_TYPEP13CGameDataUsedi
 * @address 0x22DFC0
 * @size 0x250
 */
void Func_MenuIconDrawPrepare(MENUFORMPARTS_TYPE *part, CGameDataUsed *item, int need_item);

/**
 *
 * Sets the state bits of every item icon part of the item board.
 *
 * @mangled CheckItemBoardFunc_MenuIconDrawPrepare__FP16CUserDataManagerP18MENUFORMPARTS_TYPE
 * @address 0x22E210
 * @size 0xE0
 */
void CheckItemBoardFunc_MenuIconDrawPrepare(CUserDataManager *manager, MENUFORMPARTS_TYPE *parts);

/**
 *
 * Moves the item board scroll bar towards the current line.
 *
 * @mangled MenuItemBrdScrlBarStep__Fiii
 * @address 0x22E2F0
 * @size 0xA0
 */
void MenuItemBrdScrlBarStep(int top_line, int height, int mode);

/**
 *
 * Scrolls the item board towards a line.
 *
 * @mangled Func_MenuItemBrdPosStep__Fi
 * @address 0x22E390
 * @size 0x100
 */
void Func_MenuItemBrdPosStep(int top_line);

/**
 *
 * Restarts the effects of an item icon part.
 *
 * @mangled Func_MenuItemIconSetEffectOne__FP18MENUFORMPARTS_TYPE
 * @address 0x22E620
 * @size 0x160
 */
void Func_MenuItemIconSetEffectOne(MENUFORMPARTS_TYPE *part);

/**
 *
 * Prepares the item icon parts of the item board and their effects.
 *
 * @mangled MenuItemBrdItemIconEffectMalloc__FP9mgCMemoryP18MENUFORMPARTS_TYPEi
 * @address 0x22E780
 * @size 0xD0
 */
void MenuItemBrdItemIconEffectMalloc(mgCMemory *memory, MENUFORMPARTS_TYPE *parts, int count);

/**
 *
 * Captures the screen into a texture used as the menu background.
 *
 * @mangled MenuCapture__FiP9mgCMemoryi
 * @address 0x22EDC0
 * @size 0x3B0
 */
int MenuCapture(int block, mgCMemory *stack, int draw);

/**
 *
 * Copies a texture to the frame buffer as the menu background.
 *
 * @mangled SetBGFrameForMenu__FiPc
 * @address 0x22F170
 * @size 0x110
 */
void SetBGFrameForMenu(int tex_block, char *tex_name);

/**
 *
 * Returns the first idle star of an array, or NULL.
 *
 * @mangled CheckNotRunStarDust__FP9CStarDusti
 * @address 0x230F80
 * @size 0x70
 */
CStarDust *CheckNotRunStarDust(CStarDust *dusts, int count);

/**
 *
 * Returns non-zero while any star of an array lives.
 *
 * @mangled CheckRunStarDust__FP9CStarDusti
 * @address 0x230FF0
 * @size 0x60
 */
int CheckRunStarDust(CStarDust *dusts, int count);

/**
 *
 * Allocates the streaks of light of the weapon build-up view.
 *
 * @mangled InitBuildUpInfoEffect__FP9mgCMemoryP10mgCTextureif
 * @address 0x2315D0
 * @size 0x70
 */
void InitBuildUpInfoEffect(mgCMemory *memory, mgCTexture *tex, int num, float up_limit);

/**
 *
 * Sets the character the streaks of light rise around.
 *
 * @mangled SetBuildUpInfoChara__FP11CCharacter2f
 * @address 0x231640
 * @size 0x80
 */
void SetBuildUpInfoChara(CCharacter2 *chara, float range);

/**
 *
 * Advances the streaks of light by one frame.
 *
 * @mangled StepBuildUpInfoEffect__Fv
 * @address 0x2316C0
 * @size 0xC0
 */
void StepBuildUpInfoEffect();

/**
 *
 * Draws the streaks of light.
 *
 * @mangled DrawBuildUpInfoEffect__Fv
 * @address 0x231780
 * @size 0xA0
 */
void DrawBuildUpInfoEffect();

/**
 *
 * Starts the bubbles of the boiling fish effect at a position.
 *
 * @mangled InitFishBoiledEffect__FPiP10mgCTexture
 * @address 0x231820
 * @size 0x140
 */
void InitFishBoiledEffect(int *pos, mgCTexture *tex);

/**
 *
 * Advances the boiling fish effect by one frame. Returns non-zero while it
 * runs.
 *
 * @mangled StepFishBoiledEffect__Fv
 * @address 0x231960
 * @size 0x100
 */
int StepFishBoiledEffect();

/**
 *
 * Draws the boiling fish effect.
 *
 * @mangled DrawFishBoiledEffect__Fv
 * @address 0x231A60
 * @size 0x190
 */
void DrawFishBoiledEffect();

/**
 *
 * Starts the effect of an item breaking into a spectrum.
 *
 * @mangled SetEffectSpectolBreak__FP9mgCMemoryP11CMenuEffecti
 * @address 0x231BF0
 * @size 0xE0
 */
void SetEffectSpectolBreak(mgCMemory *memory, CMenuEffect *effect, int item);

/**
 *
 * Starts the effects of a spectrum fusing into an item.
 *
 * @mangled SetEffectSpectolFusion__FP9mgCMemoryPP11CMenuEffectP13CGameDataUsedi
 * @address 0x231CD0
 * @size 0x100
 */
void SetEffectSpectolFusion(mgCMemory *memory, CMenuEffect **effect, CGameDataUsed *item, int is_fusion);

/**
 *
 * Writes a sprite over a screen rectangle textured with a texel rectangle,
 * instantiated for float and int screen rectangles.
 *
 * @mangled PrimQuad_f___FP11mgCDrawPrim9mgRect_f_9mgRect_i_
 * @address 0x234B20
 * @size 0xB0
 * @mangled PrimQuad_i___FP11mgCDrawPrim9mgRect_i_9mgRect_i_
 * @address 0x234BD0
 * @size 0xB0
 */
template <class T>
void PrimQuad(mgCDrawPrim *prim, mgRect<T> put_rect, mgRect<int> tex_rect);

/**
 *
 * Float rectangle passed by value to the rectangle primitive.
 *
 */
struct mgRect_f_ {
    float left;   /**< Left coordinate. */
    float top;    /**< Top coordinate. */
    float right;  /**< Width from the left coordinate. */
    float bottom; /**< Height from the top coordinate. */
} __attribute__((aligned(16)));

/**
 *
 * Integer texture rectangle passed by value to the rectangle primitive.
 *
 */
struct mgRect_i_ {
    int left;   /**< Left texel. */
    int top;    /**< Top texel. */
    int right;  /**< Width in texels. */
    int bottom; /**< Height in texels. */
} __attribute__((aligned(16)));

/**
 *
 * Draws the first and opposite textured corners of a float rectangle.
 *
 * @mangled PrimQuad_f___FP11mgCDrawPrim9mgRect_f_9mgRect_i_
 * @address 0x234B20
 * @size 0xB0
 */
void PrimQuad_f_(mgCDrawPrim *prim, mgRect_f_ rect, mgRect_i_ tex_rect);

/**
 *
 * Draws the first and opposite textured corners of an integer rectangle.
 *
 * @mangled PrimQuad_i___FP11mgCDrawPrim9mgRect_i_9mgRect_i_
 * @address 0x234BD0
 * @size 0xB0
 */
void PrimQuad_i_(mgCDrawPrim *prim, mgRect_i_ rect, mgRect_i_ tex_rect);

/**
 *
 * Per-entry flags that limit what the item menus display.
 *
 */
extern u8 menu_limmit_displayflag[0x9C];

/**
 *
 * Forms of the menu message windows.
 *
 */
extern CMenuPosDataForm *MenuMesForm[9];

/**
 *
 * Items the item board shows.
 *
 */
extern CGameDataUsed *MenuDrawItemInfo[150];

/**
 *
 * Number of items the item board shows.
 *
 */
extern int MenuDrawItemInfoNum;

/**
 *
 * Screen rectangle of the gift box contents window.
 *
 */
extern mgRect<int> GiftBoxWindowPutPos;

/**
 *
 * Positions of the items in the gift box contents window.
 *
 */
extern s16 Pos_ItemInGiftBox[3][2];

/**
 *
 * Positions of the two buttons of the creation board, then its width.
 *
 */
extern float MakeBoardDrawInfo[5];

/**
 *
 * Texel rectangle of the clock hand.
 *
 */
extern mgRect<int> menu_long_hand;

/**
 *
 * Gift box whose contents the gift box window shows.
 *
 */
extern CGameDataUsed *NowGiftBoxPtr;

/**
 *
 * Form of the gift box contents window.
 *
 */
extern CMenuPosDataForm *GiftBoxViewForm;

/**
 *
 * Selected item in the gift box contents window.
 *
 */
extern int NowGiftBoxSelect;

/**
 *
 * Non-zero while the gift box contents window is shown.
 *
 */
extern u8 GiftBoxViewFlag;

/**
 *
 * Points of the scribbled random line.
 *
 */
extern int *menu_randam_line_draw_postbl;

/**
 *
 * Non-zero to draw the menu cursor reversed.
 *
 */
extern int MenuCursorReverseFlag;

/**
 *
 * Way the item board scrolls: 0 eases, 1 jumps.
 *
 */
extern s8 MenuItemBrdCalcManner;

/**
 *
 * Screen position of the item board's cells.
 *
 */
extern float MenuItemBrdUnderBrdPosXY[2];

/**
 *
 * Layout tables of the current menu screen.
 *
 */
extern CMenuPosDataManage *MenuPosData;

/**
 *
 * Texture the captured menu background is held in.
 *
 */
extern mgCTexture *MenuFrameTex;
