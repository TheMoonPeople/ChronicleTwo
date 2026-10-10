#pragma once

#include "common.h"

#include <libvu0.h>

#include "actionchara.hpp"
#include "menucls1.hpp"
#include "menudraw.hpp"
#include "menusys.hpp"
#include "mg_camera.hpp"
#include "mg_memory.hpp"
#include "mg_tanime.hpp"
#include "nd_meswin.hpp"
#include "userdata.hpp"

/**
 * @file
 * Declares the character menus: the party change screen with its townsperson
 * and monster box, the costume screen, the monster book, and the background
 * loading of the character, ridepod and monster models that the menus show.
 */

class CCharacter2;
class CDC2Mes;
class CMenuPosDataForm;
class CScene;
class mgCFrame;
class mgCTexture;
struct BASE_MONSTER_TBL;
struct NPC_BASE_DATA;

/**
 *
 * Sizes of the character menus' tables.
 *
 */
enum {
    MENU_CHARA_LOAD_MAX = 7,        /**< Models that the menus load at once, in MenuCharaBuild2 and MenuActionChara. */
    MENU_LOAD_ITEM_MAX = 12,        /**< Equipment numbers held in MenuLoadItemNo. */
    MONSTER_PROGRESS_NUM = 19,      /**< Rows of monster_progress_tbl. */
    MONSTER_PROGRESS_LEVEL_NUM = 4, /**< Monster forms one row of monster_progress_tbl lists. */
    CHR_CNG_STAR_NUM = 256,         /**< Sparkles drawn around the party change ring. */
    CHR_CNG_CLUT_NUM = 256,         /**< Colours of the darkened copy of the party change palette. */
    CHR_CNG_CLUT_BAND_NUM = 32,     /**< Brightness bands the darkened party change palette is reduced to. */
    CHR_CNG_NPC_COMMAND_NUM = 4,    /**< Commands the party change screen lists for the townsperson. */
    MOS_SELECT_BADGE_NUM = 12,      /**< Monster badges the monster box shows. */
    MOS_SELECT_LEVEL_MAX = 16,      /**< Forms a badge can grow into, as listed by get_monster_tbl_bajjilevel. */
    COSTUME_LIST_NUM = 3,           /**< Costume lists of the costume screen. */
    COSTUME_LIST_MAX = 8,           /**< Costumes one list of the costume screen holds. */
    MOS_BOOK_LIST_MAX = 0x180,      /**< Monster numbers the monster book can list. */
    MOS_BOOK_DROP_ITEM_NUM = 3,     /**< Dropped items the monster book shows for one monster. */
};

/**
 *
 * Steps of a party member change, as CMenuChrCngMenu::change_phase holds them.
 *
 */
enum CHR_CNG_PHASE {
    CHR_CNG_PHASE_NONE = 0,  /**< No change is running. */
    CHR_CNG_PHASE_LOAD = 1,  /**< The new character's model is loading. */
    CHR_CNG_PHASE_ENTER = 2, /**< The model has loaded and its sounds are loading. */
    CHR_CNG_PHASE_DONE = 3,  /**< The new character has been put into the scene. */
};

/**
 *
 * Screen that the party change screen opens over itself, as CMenuChrCngMenu::sub_menu holds it.
 *
 */
enum CHR_CNG_SUB_MENU {
    CHR_CNG_SUB_MENU_NONE = -1,       /**< The party change screen itself runs. */
    CHR_CNG_SUB_MENU_MONSTER_BOX = 1, /**< The monster box runs. */
};

/**
 *
 * How the monster box closed, as CMenuMosSelect::KeyStep returns it.
 *
 */
enum MOS_SELECT_RESULT {
    MOS_SELECT_RESULT_CLOSE = 1,  /**< The player left the monster box. */
    MOS_SELECT_RESULT_CHANGE = 2, /**< Monica turned into the chosen monster. */
};

/**
 *
 * Background read of one model file for a menu, with the file name and the character that receives it.
 *
 */
struct MENU_BGREAD_INFO2 {
    char          name[0x20]; /**< Name of the model, which also names its textures. */
    char          path[0x50]; /**< Path of the file being read. */
    s8            reading;    /**< Non-zero while the file is being read. */
    CActionChara *chara;      /**< Character the model was put into, or NULL. */
};

/**
 *
 * One sparkle that drifts around the party change ring.
 *
 */
struct CHR_CNG_STAR {
    float life;  /**< Counts down by one each frame. */
    float alpha; /**< Alpha the sparkle is drawn with; the sparkle is drawn while it is above zero. */
    float x;     /**< Horizontal offset from the ring's corner. */
    float y;     /**< Vertical offset from the ring's corner. */
    float unk_10;
    float unk_14;
};

STATIC_ASSERT(sizeof(CHR_CNG_STAR) == 0x18);

/**
 *
 * One colour of the party change palette, a byte per channel.
 *
 */
struct CHR_CNG_CLUT_COLOR {
    u8 r; /**< Red intensity. */
    u8 g; /**< Green intensity. */
    u8 b; /**< Blue intensity. */
    u8 a; /**< Alpha. */
};

STATIC_ASSERT(sizeof(CHR_CNG_CLUT_COLOR) == 0x4);

/**
 *
 * The party change screen: picks who is at the front, shows the townsperson
 * who travels with the party and lets them use their ability, and opens the
 * monster box.
 *
 */
class CMenuChrCngMenu : public CBaseMenuClass {
public:
    int                 select;      /**< Character the cursor is on: 0 to 3 for the party, 4 for the townsperson. */
    int                 last_select; /**< Character the cursor was last moved to. */
    s32                 unk_118;
    s16                 open_wait;                            /**< Frames left before the screen takes keys. */
    u8                  set_cursor;                           /**< Non-zero to put the cursor on its place at once. */
    u8                  change_ready;                         /**< Non-zero once a change of character may be loaded. */
    s16                 change_phase;                         /**< Step of the change of character. @see CHR_CNG_PHASE */
    s16                 change_chara;                         /**< Character being changed to. */
    u32                 enable_change;                        /**< Bits of the characters that can be changed to. */
    u32                 party_member;                         /**< Bits of the characters in the party. */
    u8                  close_on_end;                         /**< Non-zero to close the menu once the townsperson's ability ends. */
    u8                  got_item;                             /**< Non-zero once the townsperson's ability has given an item. */
    int                 gift_item;                            /**< Item the townsperson's ability gives. */
    int                 gift_num;                             /**< Number of gift_item given. */
    int                 item_brd_select;                      /**< Slot of the item board the cursor is on. */
    int                 item_brd_pos;                         /**< Scroll position of the item board. */
    CMenuPosDataForm   *form;                                 /**< Form of the screen. */
    MENUFORMPARTS_TYPE *gauge_part[3];                        /**< Health gauge part of Max, Monica and the ridepod. */
    COMMON_GAGE        *gauge[3];                             /**< Health of Max, Monica and the ridepod. */
    MENU_ETCINFO       *chara_pos[5];                         /**< Place of each character's icon. */
    CMenuPosDataForm   *npc_mes_form;                         /**< Form that holds the townsperson's speech. */
    CMenuPosDataForm   *npc_sub_form;                         /**< Form that moves with the townsperson's speech. */
    CMenuPosDataForm   *npc_chara_form;                       /**< Form that shows the townsperson's model. */
    CMenuPosDataForm   *npc_sub_form2;                        /**< Second form that moves with the townsperson's speech. */
    MENUFORMPARTS_TYPE *cmd_part[4];                          /**< Parts the townsperson's commands are placed at. */
    MENUFORMPARTS_TYPE *point_gauge_part;                     /**< Gauge of the townsperson's ability points. */
    mgCMemory           npc_model_stack;                      /**< Memory the townsperson's model file is read into. */
    mgCMemory           npc_build_stack;                      /**< Memory the townsperson's model is built in. */
    PARTY_CHARA_INFO   *party_info;                           /**< Party record of the townsperson. */
    NPC_BASE_DATA      *npc_data;                             /**< Definition of the townsperson. */
    int                 item_brd_arrived;                     /**< Non-zero once the item board has reached its place. */
    s8                  face_state;                           /**< State of the townsperson's face: -1 none, 0 loading, 1 entered. */
    u8                  face_loaded;                          /**< Non-zero when the face file has been read at once rather than in the background. */
    s16                 face_chara;                           /**< Townsperson whose face is loaded, or below zero for none. */
    u8                 *face_img;                             /**< Face image file of the townsperson. */
    u8                  npc_loading;                          /**< Non-zero while the townsperson's model is loading. */
    u8                  npc_loaded;                           /**< Non-zero once the townsperson's model is in place. */
    CActionChara       *npc_chara;                            /**< Model of the townsperson, or NULL. */
    int                 npc_wait;                             /**< Frames the townsperson's model has been shown, up to 21. */
    int                 npc_show;                             /**< Non-zero while the townsperson's model is drawn in its form. */
    float               npc_y;                                /**< Height of the townsperson's model. */
    int                 npc_no;                               /**< Townsperson in the party, or zero or below for none. */
    int                 npc_mes_talk;                         /**< Message that the townsperson says on the screen. */
    int                 npc_mes_cmd;                          /**< Message of the townsperson's command question. */
    int                 npc_mes_cancel;                       /**< Message the townsperson says when their ability is cancelled. */
    int                 npc_cmd_mes[CHR_CNG_NPC_COMMAND_NUM]; /**< Message of each of the townsperson's commands. */
    s32                 unk_23C;
    float               cursor_wave;    /**< Angle that bobs the character under the cursor. */
    s16                *sys_mes;        /**< System message data. */
    s16                *mes_data;       /**< Message data of the screen. */
    s16                 sub_menu;       /**< Screen opened over this one. @see CHR_CNG_SUB_MENU */
    s16                 sub_menu_next;  /**< Screen to open over this one once the fade ends. @see CHR_CNG_SUB_MENU */
    int                 star_stop_wait; /**< Frames left while every sparkle fades out. */
    s16                 star_spawn;     /**< Non-zero to keep making sparkles while the screen closes. */
    s16                 star_fade;      /**< State of the ring: -1 none, 0 fading in, 1 fading out. */
    float               star_x;         /**< Screen x of the ring's corner. */
    float               star_y;         /**< Screen y of the ring's corner. */
    float               unk_260;
    float               star_size;     /**< Size of the ring. */
    float               star_angle;    /**< Angle the ring has turned through. */
    float               star_alpha;    /**< Alpha of the ring, from 0 to 128. */
    int                 star_fade_out; /**< 1 to fade the ring out. */
    float               star_wave;     /**< Angle that makes the ring's circles throb. */
    float               star_pulse;    /**< Angle that makes the ring's outer circle pulse. */
    s32                 unk_27C;
    CHR_CNG_STAR        star[CHR_CNG_STAR_NUM]; /**< Sparkles around the ring. */

    union {
        struct {
            CHR_CNG_CLUT_COLOR clut[CHR_CNG_CLUT_NUM]; /**< Darkened copy of the screen's palette, drawn for those not in the party. */
            u8                 unk_1E80[0x100];
        } palette; /**< Palette entries and adjacent reserved space. */

        u8 clut_storage[0x500]; /**< Palette bytes and adjacent reserved space cleared together. */
    };

    /**
     *
     * Initializes the party change menu and clears its model work stacks.
     *
     */
    CMenuChrCngMenu();

    /**
     *
     * Finds the screen's forms, the parts of its main form and its icon places.
     *
     * @mangled AttachForm__15CMenuChrCngMenuFv
     * @address 0x2B4920
     * @size 0x17C
     */
    void AttachForm();

    /**
     *
     * Enters the screen's textures and layout from its pack file and fills it with the party's state.
     *
     * @mangled EnterDataMenu__15CMenuChrCngMenuFPUc
     * @address 0x2B4AA0
     * @size 0x608
     */
    void EnterDataMenu(u8 *pack);

    /**
     *
     * Reads the face image of the townsperson in the party, at once or in the background.
     *
     * @mangled LoadNPCFaceData__15CMenuChrCngMenuFP9mgCMemoryi
     * @address 0x2B50B0
     * @size 0xF4
     */
    void LoadNPCFaceData(mgCMemory *memory, int mode);

    /**
     *
     * Enters the townsperson's face image once it has been read.
     *
     * @mangled EnterNPCFaceData__15CMenuChrCngMenuFv
     * @address 0x2B51B0
     * @size 0x84
     */
    void EnterNPCFaceData();

    /**
     *
     * Creates the townsperson's model and starts reading its file; returns non-zero if the read started.
     *
     * @mangled LoadBGNPCModel__15CMenuChrCngMenuFi
     * @address 0x2B5240
     * @size 0x1E0
     */
    int LoadBGNPCModel(int restart_read);

    /**
     *
     * Builds the townsperson's model once read, then moves and shows it; returns 1 on the frame it is built.
     *
     * @mangled CheckBGNPCModel__15CMenuChrCngMenuFv
     * @address 0x2B5420
     * @size 0x2C8
     */
    int CheckBGNPCModel();

    /**
     *
     * Handles the keys of the screen and of the townsperson's ability; returns 0.
     *
     * @mangled KeyChangeMain__15CMenuChrCngMenuFv
     * @address 0x2B5760
     * @size 0x21A0
     */
    int KeyChangeMain();

    /**
     *
     * Moves the screen's parts, the ring and its sparkles for this frame.
     *
     * @mangled CalcTex__15CMenuChrCngMenuFv
     * @address 0x2B7900
     * @size 0x9B8
     */
    void CalcTex();

    /**
     *
     * Runs the change of character; returns 2 once the new character is in the scene.
     *
     * @mangled CheckChrChange__15CMenuChrCngMenuFv
     * @address 0x2B82C0
     * @size 0x1E4
     */
    int CheckChrChange();

    /**
     *
     * Runs the screen for one frame; returns non-zero once it has closed.
     *
     * @mangled MenuLocalLoop__15CMenuChrCngMenuFv
     * @address 0x2B84B0
     * @size 0x4D4
     */
    int MenuLocalLoop();

    /**
     *
     * Clears the ring and every sparkle.
     *
     * @mangled InitStarInfo__15CMenuChrCngMenuFv
     * @address 0x2B8990
     * @size 0x74
     */
    void InitStarInfo();

    /**
     *
     * Shows the health of Max, Monica and the ridepod and hides those not in the party.
     *
     * @mangled UpdataLife__15CMenuChrCngMenuFv
     * @address 0x2B8A10
     * @size 0x178
     */
    void UpdataLife();
};

STATIC_ASSERT(sizeof(CMenuChrCngMenu) == 0x1F80);

/**
 *
 * The monster box: shows Monica's monster badges, lets one be grown into a
 * stronger form, and turns Monica into the chosen monster.
 *
 */
class CMenuMosSelect : public CBaseMenuClass {
public:
    sceVu0FVECTOR     camera_pos;   /**< Camera position kept to give back when the box closes. */
    sceVu0FVECTOR     camera_ref;   /**< Camera look-at point kept to give back when the box closes. */
    int               result;       /**< How the box closed. @see MOS_SELECT_RESULT */
    s16              *mes_data;     /**< Message data of the box. */
    int               select;       /**< Badge the cursor is on. */
    int               top;          /**< First row of badges shown. */
    MOS_CHANGE_PARAM *badge;        /**< Monica's badges. */
    MOS_CHANGE_PARAM *select_badge; /**< Badge being worked on. */
    u8                unk_148[8];
    CDC2Mes           mes;      /**< Message window of the box's questions. */
    int               mes_show; /**< Non-zero while mes is drawn. */
    s32               unk_2BA4;
    ClsMes            info_win;      /**< Window that describes the badge under the cursor. */
    int               info_win_show; /**< Non-zero while info_win is drawn. */
    s32               unk_5504;
    int               set_cursor;                          /**< Non-zero to put the cursor on its place at once. */
    int               level_num;                           /**< Number of entries in level_monster. */
    int               level_monster[MOS_SELECT_LEVEL_MAX]; /**< Monsters the badge can grow into. */
    int               change_wait;                         /**< Frames counted while the badge grows. */
    int               view_monster;                        /**< Monster to show, or -1 for none. */
    int               pick_monster;                        /**< Monster picked to show. */
    int               load_monster;                        /**< Monster whose model is loaded, or -1 for none. */
    int               level_max;                           /**< Non-zero when the badge is at its highest form. */
    s8                skip_draw;                           /**< Toggled each frame to step the shown model every other frame. */
    CMenuPosDataForm *badge_form;                          /**< Form of the badges. */
    CMenuPosDataForm *info_form;                           /**< Form of the badge description. */
    CMenuPosDataForm *model_form;                          /**< Form that shows the monster's model. */
    u8                model_side;                          /**< Side the monster's model stands at: 0 shown, 1 moved aside. */
    sceVu0FVECTOR     model_pos;                           /**< Position of the monster's model. */
    CActionChara      monster[1];                          /**< Model of the monster shown. */
    CActionChara      effect;                              /**< Model of the growth effect. */
    mgCMemory         effect_stack;                        /**< Memory the growth effect is built in. */
    mgCMemory         unk_7620;
    u_long128        *effect_data;  /**< File of the growth effect's model. */
    u32              *effect_sound; /**< Sounds of the growth effect. */
    s16               effect_show;  /**< Non-zero while the growth effect plays. */
    s16               effect_frame; /**< Frames the growth effect has played. */
    s32               unk_765C;
    s16               load_wait;  /**< Frames left before the shown monster's model is loaded. */
    s16               load_phase; /**< Step of loading the shown monster's model. */

    /**
     *
     * Initializes the monster box, its message windows, and the default badge selection.
     *
     */
    CMenuMosSelect();

    /**
     *
     * Finds the box's forms and shows the badges Monica has.
     *
     * @mangled AttachForm__14CMenuMosSelectFv
     * @address 0x2BA570
     * @size 0xF4
     */
    void AttachForm();

    /**
     *
     * Loads, builds and moves the model of the monster under the cursor.
     *
     * @mangled CheckLoadBGMonster__14CMenuMosSelectFv
     * @address 0x2BAA10
     * @size 0x40C
     */
    int CheckLoadBGMonster();

    /**
     *
     * Moves the cursor towards the badge it is on.
     *
     * @mangled CalcCursorPosition__14CMenuMosSelectFv
     * @address 0x2BAE80
     * @size 0xC8
     */
    void CalcCursorPosition();

    /**
     *
     * Moves the box's parts for this frame.
     *
     * @mangled CalcTex__14CMenuMosSelectFv
     * @address 0x2BAF50
     * @size 0x25C
     */
    void CalcTex();

    /**
     *
     * Moves the cursor over the badges and picks the monster to show.
     *
     * @mangled KeyNormalMode__14CMenuMosSelectFiii
     * @address 0x2BB1B0
     * @size 0xC0
     */
    int KeyNormalMode(int keys, int lr_key, int push_button);

    /**
     *
     * Runs the box for one frame; returns how it closed, or 0 while it runs. @see MOS_SELECT_RESULT
     *
     * @mangled KeyStep__14CMenuMosSelectFv
     * @address 0x2BB890
     * @size 0x19F0
     */
    int KeyStep();
};

STATIC_ASSERT(sizeof(CMenuMosSelect) == 0x7670);

/**
 *
 * The costume screen: dresses Max or Monica in the costumes they have and shows them turning.
 *
 */
class CMenuCostumeSel : public CBaseMenuClass {
public:
    mgCCameraFollow camera; /**< Camera that looks at the character. */
    int             select; /**< Line the cursor is on: the costume lists, then the character and leaving. */
    s32             unk_1D4;
    s16             costume_num[COSTUME_LIST_NUM];                    /**< Number of costumes in each list of list. */
    s16             costume_select[COSTUME_LIST_NUM];                 /**< Costume picked in each list of list. */
    s16             costume_list[COSTUME_LIST_NUM][COSTUME_LIST_MAX]; /**< Costumes the character has, by kind. */
    s16            *list[COSTUME_LIST_NUM];                           /**< List shown on each line, as an entry of costume_list. */
    s32             unk_220;
    float           tile_scroll;         /**< Scroll of the background tiles. */
    mgCMemory       stack;               /**< Memory of the screen's data. */
    s16             chara;               /**< Character being dressed: 0 for Max, 1 for Monica. */
    int             monica_enabled;      /**< 1 when Monica can be dressed too. */
    sceVu0FVECTOR   chara_pos;           /**< Position of the character's model. */
    float           costume_rotation[4]; /**< Rotation restored to the character model while dressing it. */
    s32             unk_280;
    int             cursor_show;  /**< Non-zero while the cursor is drawn. */
    int             change_chara; /**< Non-zero while the other character is loading. */
    float           line_wave[3]; /**< Angle that bobs each costume line. */
    int             load_wait;    /**< Frames counted while a costume loads. */
    int             loading;      /**< Non-zero while a costume is loading. */
    int             wait_load;    /**< Non-zero while the screen waits for a load to end. */
    int             show_help;    /**< Non-zero while the help is drawn. */
    s32             unk_2A8;
    s32             unk_2AC;
    float           cursor_x;      /**< Screen x of the cursor. */
    float           cursor_y;      /**< Screen y of the cursor. */
    float           cursor_wave;   /**< Angle that bobs the cursor. */
    float           cursor_wave_y; /**< Phase of the costume cursor's vertical bob. */
    CHARA_DATA     *chara_data;    /**< Status of the character being dressed. */
    mgCTexture     *tile_tex;      /**< Texture of the background tiles. */
    mgCTexture     *cursor_tex;    /**< Texture of the cursor. */

    CMenuCostumeSel();

    /**
     *
     * Lists the costumes a character has of each kind and puts each list's cursor on the costume worn.
     *
     * @mangled UpdateCostumeList__15CMenuCostumeSelFiUl
     * @address 0x2C0A80
     * @size 0x1A0
     */
    void UpdateCostumeList(int mode, unsigned long chara_flag);

    /**
     *
     * Reads the screen's pack file and enters its textures and layout.
     *
     * @mangled LoadMenuData__15CMenuCostumeSelFP9mgCMemoryPi
     * @address 0x2C0C60
     * @size 0x390
     */
    void LoadMenuData(mgCMemory *stack, int *tex_block);

    /**
     *
     * Runs the screen for one frame; returns non-zero once it has closed.
     *
     * @mangled KeyStep__15CMenuCostumeSelFv
     * @address 0x2C0FF0
     * @size 0x9D8
     */
    int KeyStep();

    /**
     *
     * Draws the screen.
     *
     * @mangled Draw__15CMenuCostumeSelFv
     * @address 0x2C19D0
     * @size 0x8D4
     */
    void Draw();
};

STATIC_ASSERT(sizeof(CMenuCostumeSel) == 0x2D0);

/**
 *
 * The monster book: lists every monster defeated and shows its model and description.
 *
 */
class CMosBookMenu : public CBaseMenuClass {
public:
    mgCCamera         camera;       /**< Camera that looks at the monster. */
    float             bg_scroll;    /**< Scroll of the background, from 0 to 256. */
    mgCMemory         stack;        /**< Memory the monster's model is read and built in. */
    int               tex_block_no; /**< Texture block of the monster's model. */
    CActionChara     *monster;      /**< Model of the monster shown, or NULL. */
    s32               unk_1BC;
    s32               unk_1C0;
    s32               unk_1C4;
    s32               unk_1C8;
    s32               unk_1CC;
    int               load_phase;                              /**< Step of loading the monster's model. */
    int               load_wait;                               /**< Frames counted before the monster's model is loaded. */
    int               show_wait;                               /**< Frames the monster's model has been built, up to 20. */
    s8                skip_draw;                               /**< Toggled each frame to step the model every other frame. */
    int               select;                                  /**< Entry of list the cursor is on. */
    BASE_MONSTER_TBL *monster_info;                            /**< Definition of the monster shown. */
    int               list[MOS_BOOK_LIST_MAX];                 /**< Monster numbers of the monsters defeated, then -1. */
    int               list_num;                                /**< Number of monsters in list. */
    char              area_name[0x40];                         /**< Name of the place the monster lives. */
    char              name[0x40];                              /**< Name of the monster. */
    char              type_name[0x40];                         /**< Name of the monster's kind. */
    char              weak_name[0x58];                         /**< Names of the attributes the monster is weak to. */
    u32               hp;                                      /**< Health of the monster. */
    u32               abs;                                     /**< Absorption points the monster gives. */
    int               kill_num;                                /**< Number of the monster defeated. */
    u32               strong_bit;                              /**< Bits of the attributes the monster resists. */
    u32               weak_bit;                                /**< Bits of the attributes the monster is weak to. */
    char              drop_item[MOS_BOOK_DROP_ITEM_NUM][0x21]; /**< Names of the items the monster drops. */

    /**
     *
     * Constructs the book with its model camera at the default speed.
     *
     */
    CMosBookMenu() : camera(8.0f) {
        bg_scroll = 0.0f;
        monster = NULL;
        unk_1BC = 0;
        unk_1C0 = 0;
        unk_1C4 = 0;
        unk_1C8 = 0;
        unk_1CC = 0;
        load_phase = 0;
        show_wait = 0;
        load_wait = 0;
        monster_info = NULL;
        select = 0;
        skip_draw = 0;
        list_num = 0;

        for (int i = 0; i < MOS_BOOK_LIST_MAX; i++) {
            list[i] = -1;
        }

        InitMonsterInfo();
        camera.SetPos(0.0f, 0.0f, 100.0f);
        camera.SetRef(0.0f, 0.0f, 0.0f);
    }

    /**
     *
     * Clears the description of the monster shown.
     *
     * @mangled InitMonsterInfo__12CMosBookMenuFv
     * @address 0x2C2610
     * @size 0x34
     */
    void InitMonsterInfo();

    /**
     *
     * Fills the description from a monster's definition.
     *
     * @mangled SetMonsterInfo__12CMosBookMenuFP16BASE_MONSTER_TBL
     * @address 0x2C2650
     * @size 0x308
     */
    void SetMonsterInfo(BASE_MONSTER_TBL *monster);

    /**
     *
     * Finishes opening the book: enters its textures, lists the monsters defeated and shows the first.
     *
     * @mangled InitEnd__12CMosBookMenuFv
     * @address 0x2C2960
     * @size 0x224
     */
    virtual void InitEnd();

    /**
     *
     * Draws the book.
     *
     * @mangled Draw__12CMosBookMenuFv
     * @address 0x2C2B90
     * @size 0xEC4
     */
    void Draw();

    /**
     *
     * Runs the book for one frame; returns non-zero once it has closed.
     *
     * @mangled KeyStep__12CMosBookMenuFv
     * @address 0x2C3A60
     * @size 0x54C
     */
    int KeyStep();
};

STATIC_ASSERT(sizeof(CMosBookMenu) == 0x980);

/**
 *
 * Monster forms of each badge: a badge number, then the monster of each of its four forms.
 *
 */
extern s16 monster_progress_tbl[MONSTER_PROGRESS_NUM][1 + MONSTER_PROGRESS_LEVEL_NUM];

/**
 *
 * Memory stacks of the main characters, which the menus load character sounds into.
 *
 */
extern mgCMemory *MorattaStack;

/**
 *
 * Texture of the party change ring.
 *
 */
extern mgCTexture *MenuCharaChangeBase_Tex;

/**
 *
 * Copy of the ring's texture that draws with the darkened palette.
 *
 */
extern mgCTexture *MenuCharaChangeCLUT_Tex;

/**
 *
 * Texture of the party change sparkles.
 *
 */
extern mgCTexture *MenuCharaChangeStar_Tex;

/**
 *
 * Sound data of the character whose sounds the menus load.
 *
 */
extern u32 *CharaSndBuffer;

/**
 *
 * Background reads of the models that the menus show.
 *
 */
extern MENU_BGREAD_INFO2 *MenuCharaBuild2[MENU_CHARA_LOAD_MAX];

/**
 *
 * Characters of the menu scene that the loaded models are put into.
 *
 */
extern CActionChara *MenuActionChara[MENU_CHARA_LOAD_MAX];

/**
 *
 * Memory of each character of MenuActionChara.
 *
 */
extern mgCMemory MenuActionCharaBuffer[MENU_CHARA_LOAD_MAX];

/**
 *
 * Equipment numbers whose models the menus load for the character shown.
 *
 */
extern s16 MenuLoadItemNo[MENU_LOAD_ITEM_MAX];

/**
 *
 * Memory containing the party change menu models.
 *
 */
extern mgCMemory MenuChangeMemory;

/**
 *
 * Memory containing the monster book menu and its resources.
 *
 */
extern mgCMemory MosBookStack;

/**
 *
 * Memory containing monster model background loads for the menu.
 *
 */
extern mgCMemory MenuMonChangeLoadStack;

/**
 *
 * Memory remaining for monster selection menu background loads.
 *
 */
extern mgCMemory MenuMosLoadStack;

/**
 *
 * Memory containing the initial party change menu textures.
 *
 */
extern mgCMemory ChrChangeInitTextureStack;

/**
 *
 * Memory the party change screen reads the townsperson's face into.
 *
 */
extern mgCMemory MenuChangeNpcMemory;

/**
 *
 * Memory of the sword effects that the menus show.
 *
 */
extern mgCMemory SwordEffectStack;

/**
 *
 * Clears a background read.
 *
 * @mangled InitMenuBGReadInfo2__FP17MENU_BGREAD_INFO2
 * @address 0x2B41F0
 * @size 0x14
 */
void InitMenuBGReadInfo2(MENU_BGREAD_INFO2 *info);

/**
 *
 * Returns non-zero while any of the menus' background reads is reading.
 *
 * @mangled MenuLoadFileCheck__FPP17MENU_BGREAD_INFO2
 * @address 0x2B4210
 * @size 0x48
 */
int MenuLoadFileCheck(MENU_BGREAD_INFO2 **slots);

/**
 *
 * Allocates the background reads of MenuCharaBuild2 that a table of flags asks for.
 *
 * @mangled MenuBGReadInfo2Malloc__FP9mgCMemoryPi
 * @address 0x2B4260
 * @size 0x9C
 */
void MenuBGReadInfo2Malloc(mgCMemory *memory, int *wanted);

/**
 *
 * Gives the load step of a character's model part.
 *
 * @mangled ConvertCharaLoadDataPhase__Fii
 * @address 0x2B4300
 * @size 0x24
 */
s16 ConvertCharaLoadDataPhase(int a0, int a1);

/**
 *
 * Fills MenuLoadItemNo with the equipment of Max, Monica or the ridepod.
 *
 * @mangled SetMenuLoadItemNo__Fi
 * @address 0x2B4380
 * @size 0x114
 */
void SetMenuLoadItemNo(int who);

/**
 *
 * Divides a memory stack among MenuActionCharaBuffer and puts the remainder into another stack.
 *
 * @mangled MenuMemoryAdjust__FP9mgCMemoryP9mgCMemoryP9mgCMemoryi
 * @address 0x2B4670
 * @size 0xF0
 */
void MenuMemoryAdjust(mgCMemory *pool, mgCMemory *rest, mgCMemory *buffer, int chara);

/**
 *
 * Removes the effects of a monster transformation.
 *
 * @mangled DeleteMonsterEffect__Fv
 * @address 0x2B4760
 * @size 0x54
 */
void DeleteMonsterEffect();

/**
 *
 * Places a townsperson's speech at the parts of a form.
 *
 * @mangled SetMessagePositionNPCForm__FP16CMenuPosDataFormP7CDC2Mes
 * @address 0x2B47C0
 * @size 0xE4
 */
void SetMessagePositionNPCForm(CMenuPosDataForm *form, CDC2Mes *mes);

/**
 *
 * Places a townsperson's speech over their model.
 *
 * @mangled AdjustNPCTalk__FP7CDC2MesP11CCharacter2
 * @address 0x2B48B0
 * @size 0x6C
 */
void AdjustNPCTalk(CDC2Mes *mes, CCharacter2 *npc);

/**
 *
 * Draws the party change ring and its sparkles.
 *
 * @mangled MenuCharaChangeStarDraw__Fv
 * @address 0x2B8B90
 * @size 0x5BC
 */
void MenuCharaChangeStarDraw();

/**
 *
 * Opens the party change screen.
 *
 * @mangled MenuCharaChangeInit__FP9mgCMemoryPii
 * @address 0x2B9150
 * @size 0x4F0
 */
int MenuCharaChangeInit(mgCMemory *memory, int *tex_block, int mode);

/**
 *
 * Runs the party change screen for one frame; returns non-zero once it has closed.
 *
 * @mangled MenuCharaChangeKey__Fv
 * @address 0x2B9640
 * @size 0x2F8
 */
int MenuCharaChangeKey();

/**
 *
 * Draws the party change screen.
 *
 * @mangled MenuCharaChangeDraw__Fv
 * @address 0x2B9940
 * @size 0x7B0
 */
void MenuCharaChangeDraw();

/**
 *
 * Gives a monster's name, or NULL.
 *
 * @mangled GetMonsterName__Fi
 * @address 0x2BA0F0
 * @size 0x30
 */
char *GetMonsterName(int monster_no);

/**
 *
 * Gives the badge whose forms include a monster, and the form, or -1.
 *
 * @mangled get_gajji_id_from_monster_progress_table__FiPi
 * @address 0x2BA120
 * @size 0x88
 */
int get_gajji_id_from_monster_progress_table(int progress_no, int *column_out);

/**
 *
 * Gives the row of monster_progress_tbl whose form of a level is a monster, or -1.
 *
 * @mangled GetMonsterProgressTableNo__Fii
 * @address 0x2BA1B0
 * @size 0x4C
 */
int GetMonsterProgressTableNo(int column, int value);

/**
 *
 * Lists the monsters a badge can grow into from a form; returns how many.
 *
 * @mangled get_monster_tbl_bajjilevel__FPiiii
 * @address 0x2BA200
 * @size 0x178
 */
int get_monster_tbl_bajjilevel(int *list, int monster_id, int value, int column);

/**
 *
 * Gives the row of monster_progress_tbl of a badge.
 *
 * @mangled get_default_monster_progresstbl__Fi
 * @address 0x2BA380
 * @size 0x44
 */
int get_default_monster_progresstbl(int id);

/**
 *
 * Writes the path of a monster's model, motion, transformation or effect file; returns non-zero on success.
 *
 * @mangled GetMonsterModelFile__FiiPc
 * @address 0x2BA3D0
 * @size 0x198
 */
int GetMonsterModelFile(int monster_id, int kind, char *file_name);

/**
 *
 * Scales a monster's model to the size the menus show it at.
 *
 * @mangled MonsterScaleCheck__FP11CCharacter2
 * @address 0x2BA670
 * @size 0x68
 */
void MonsterScaleCheck(CCharacter2 *chara);

/**
 *
 * Reads the effect files of a monster transformation; returns how many are read.
 *
 * @mangled MonsterEffectRead__FP9mgCMemoryii
 * @address 0x2BA6E0
 * @size 0x210
 */
int MonsterEffectRead(mgCMemory *stack, int monster_no, int background);

/**
 *
 * Builds the effects of a monster transformation once read into a texture block; returns non-zero on success.
 * The two-argument form has no definition; it is kept for an older caller.
 *
 * @mangled MonsterEffectEnter__FP6CSceneP1i
 * @address 0x2BA8F0
 * @size 0x11C
 */
int MonsterEffectEnter(CScene *scene, u_long128 *buffer, int tex_block);
int MonsterEffectEnter(CScene *scene, u_long128 *buffer);

/**
 *
 * Opens the monster box.
 *
 * @mangled MenuMonsterBoxInit__FP9mgCMemoryPii
 * @address 0x2BB270
 * @size 0x620
 */
void MenuMonsterBoxInit(mgCMemory *stack, int *tex_block, int mode);

/**
 *
 * Runs the monster box for one frame. @see MOS_SELECT_RESULT
 *
 * @mangled MenuMonsterBoxKey__Fv
 * @address 0x2BD280
 * @size 0x8
 */
int MenuMonsterBoxKey();

/**
 *
 * Draws the monster box.
 *
 * @mangled MenuMonsterBoxDraw__Fv
 * @address 0x2BD290
 * @size 0x22C
 */
void MenuMonsterBoxDraw();

/**
 *
 * Shows the parts of a menu model that suit the time of day.
 *
 * @mangled MenuTimeStepEnvFunc__FP6CSceneP12CActionCharai
 * @address 0x2BD4C0
 * @size 0xEC
 */
void MenuTimeStepEnvFunc(CScene *scene, CActionChara *chara, int step);

/**
 *
 * Turns the moving part of a weapon shown in a menu.
 *
 * @mangled MenuWeaponRealStepEnvFunc__FP12CActionCharai
 * @address 0x2BD5B0
 * @size 0x94
 */
void MenuWeaponRealStepEnvFunc(CActionChara *chara, int step);

/**
 *
 * Starts reading the model of Max or Monica and their equipment; returns the size read.
 *
 * @mangled MenuItemCharaDataLoad__FP9mgCMemoryiPP17MENU_BGREAD_INFO2i
 * @address 0x2BD650
 * @size 0x4AC
 */
int MenuItemCharaDataLoad(mgCMemory *stack, int chara_no, MENU_BGREAD_INFO2 **info, int restart_read);

/**
 *
 * Builds the model of Max or Monica and their equipment once read; returns non-zero once built.
 *
 * @mangled MenuItemCharaDataLoadEndCheck__FPP17MENU_BGREAD_INFO2P9mgCMemoryPP12CActionCharaiii
 * @address 0x2BDE50
 * @size 0x644
 */
int MenuItemCharaDataLoadEndCheck(MENU_BGREAD_INFO2 **info, mgCMemory *stack, CActionChara **chara, int chara_no,
                                  int tex_block, int scene_tex_block);

/**
 *
 * Reads the sounds of a character; returns the size read.
 *
 * @mangled MenuCharaSoundLoad__FP9mgCMemoryii
 * @address 0x2BE4A0
 * @size 0xFC
 */
u32 MenuCharaSoundLoad(mgCMemory *stack, int chara_no, int background);

/**
 *
 * Gives a character the sounds read by MenuCharaSoundLoad.
 *
 * @mangled MenuCharaSoundEnter__FP6CSceneP12CActionCharai
 * @address 0x2BE5A0
 * @size 0xC0
 */
void MenuCharaSoundEnter(CScene *scene, CActionChara *chara, int open_port);

/**
 *
 * Starts reading the model of an item; returns the size read.
 *
 * @mangled MenuItemChrLoad__FP9mgCMemoryiiP17MENU_BGREAD_INFO2i
 * @address 0x2BE660
 * @size 0x11C
 */
u32 MenuItemChrLoad(mgCMemory *stack, int item_no, int variant, MENU_BGREAD_INFO2 *info, int restart_read);

/**
 *
 * Builds the model of an item once read; returns non-zero once built.
 *
 * @mangled MenuItemChrLoadEndCheck__FP17MENU_BGREAD_INFO2P12CActionCharaP9mgCMemoryi
 * @address 0x2BE780
 * @size 0xF8
 */
int MenuItemChrLoadEndCheck(MENU_BGREAD_INFO2 *info, CActionChara *chara, mgCMemory *memory, int tex_block);

/**
 *
 * Starts reading the ridepod's model and parts; returns the size read.
 *
 * @mangled MenuItemRoboDataLoad__FP9mgCMemoryPP17MENU_BGREAD_INFO2i
 * @address 0x2BE880
 * @size 0x31C
 */
int MenuItemRoboDataLoad(mgCMemory *stack, MENU_BGREAD_INFO2 **info, int restart_read);

/**
 *
 * Removes the outline texture of a menu model.
 *
 * @mangled DeleteOutLineMenu__FP12CActionCharai
 * @address 0x2BEBA0
 * @size 0x70
 */
void DeleteOutLineMenu(CActionChara *chara, int alternate);

/**
 *
 * Builds the ridepod's model and parts once read; returns non-zero once built.
 *
 * @mangled MenuItemRoboDataLoadEndCheck__FPP17MENU_BGREAD_INFO2P9mgCMemoryPP12CActionCharaii
 * @address 0x2BEC10
 * @size 0x840
 */
int MenuItemRoboDataLoadEndCheck(MENU_BGREAD_INFO2 **info, mgCMemory *stack, CActionChara **chara, int tex_block,
                                 int scene_tex_block);

/**
 *
 * Switches off the light of a ridepod part.
 *
 * @mangled MenuRoboPartsLightOff__FP8mgCFrame
 * @address 0x2BF450
 * @size 0x34
 */
void MenuRoboPartsLightOff(mgCFrame *frame);

/**
 *
 * Starts reading a monster's model; returns the size read.
 *
 * @mangled MenuMonsterLoadBG__FP9mgCMemoryPP17MENU_BGREAD_INFO2ii
 * @address 0x2BF490
 * @size 0x1E4
 */
int MenuMonsterLoadBG(mgCMemory *stack, MENU_BGREAD_INFO2 **info, int monster_no, int restart_read);

/**
 *
 * Builds a monster's model once read; returns non-zero once built.
 *
 * @mangled MenuMonsterLoadBGCheck__FPP17MENU_BGREAD_INFO2PP12CActionCharaii
 * @address 0x2BF680
 * @size 0x340
 */
int MenuMonsterLoadBGCheck(MENU_BGREAD_INFO2 **info, CActionChara **chara, int tex_block, int scene_tex_block);

/**
 *
 * Finishes the models built by MenuItemCharaDataLoadEndCheck.
 *
 * @mangled MenuItemCharaDataLoadEndCheckAfter__FPP17MENU_BGREAD_INFO2i
 * @address 0x2BF9C0
 * @size 0x368
 */
void MenuItemCharaDataLoadEndCheckAfter(MENU_BGREAD_INFO2 **info, int chara_no);

/**
 *
 * Starts the quick change to Max or Monica from the field.
 *
 * @mangled InitMainCharaBG__FiP9mgCMemoryi
 * @address 0x2BFD30
 * @size 0x4C4
 */
void InitMainCharaBG(int chara_no, mgCMemory *stack, int mode);

/**
 *
 * Loads the character of the quick change; returns 2 once it is in the scene.
 *
 * @mangled ReadMainCharaBG__Fv
 * @address 0x2C0200
 * @size 0x4D0
 */
int ReadMainCharaBG();

/**
 *
 * Runs the quick change for one frame; returns non-zero once it has ended.
 *
 * @mangled KeyMainCharaBG__Fv
 * @address 0x2C06D0
 * @size 0xE8
 */
int KeyMainCharaBG();

/**
 *
 * Draws the quick change.
 *
 * @mangled DrawMainCharaBG__Fv
 * @address 0x2C07C0
 * @size 0x10C
 */
void DrawMainCharaBG();

/**
 *
 * Reads the model of a townsperson; returns non-zero if it was read.
 *
 * @mangled MenuNPCModelLoad__FP9mgCMemoryii
 * @address 0x2C08D0
 * @size 0xCC
 */
int MenuNPCModelLoad(mgCMemory *memory, int chara_no, int background);

/**
 *
 * Builds the townsperson's model once read; returns non-zero once built.
 *
 * @mangled MenuNPCLoadCheck__FP12CActionCharaP9mgCMemoryi
 * @address 0x2C09A0
 * @size 0xD8
 */
int MenuNPCLoadCheck(CActionChara *chara, mgCMemory *memory, int tex_block);

/**
 *
 * Opens the costume screen.
 *
 * @mangled MenuCostumeInit__FP9mgCMemoryPii
 * @address 0x2C22B0
 * @size 0x2D8
 */
void MenuCostumeInit(mgCMemory *stack, int *tex_block, int mode);

/**
 *
 * Runs the costume screen for one frame; returns non-zero once it has closed.
 *
 * @mangled MenuCostumeKey__Fv
 * @address 0x2C2590
 * @size 0x8
 */
int MenuCostumeKey();

/**
 *
 * Draws the costume screen.
 *
 * @mangled MenuCostumeDraw__Fv
 * @address 0x2C25A0
 * @size 0x8
 */
void MenuCostumeDraw();

/**
 *
 * Opens the monster book.
 *
 * @mangled MonsterBookInit__FP9mgCMemoryPii
 * @address 0x2C3FB0
 * @size 0x1D8
 */
void MonsterBookInit(mgCMemory *memory, int *tex_block, int mode);

/**
 *
 * Runs the monster book for one frame; returns non-zero once it has closed.
 *
 * @mangled MonsterBookKey__Fv
 * @address 0x2C4190
 * @size 0x8
 */
int MonsterBookKey();

/**
 *
 * Draws the monster book.
 *
 * @mangled MonsterBookDraw__Fv
 * @address 0x2C41A0
 * @size 0x94
 */
void MonsterBookDraw();

#define MENU_LOAD_TARGET_SCENE 1

/**
 *
 * State of the menus' background model loading.
 *
 */
struct MENU_LOAD_INFO {
    signed char mode;            /**< Current loading mode. */
    signed char alternate_model; /**< Selects the alternate character model for loading. */
    signed char load_all;        /**< Non-zero when all character model phases are loaded together. */
    signed char chara_no;        /**< Character selected for model loading. */
    signed char request_phase;   /**< Requested phase of character model loading. */
    signed char load_phase;      /**< Current phase of character model loading. */
    signed char target_flags;
    signed char update_scene; /**< Non-zero when loading also updates the main scene's characters and stacks. */
};

STATIC_ASSERT(sizeof(MENU_LOAD_INFO) == 8);
/**
 *
 * State of the menus' background model loading.
 *
 */
extern MENU_LOAD_INFO MenuLoadInfo;
