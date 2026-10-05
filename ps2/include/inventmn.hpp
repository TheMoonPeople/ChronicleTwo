#pragma once

#include "common.h"
#include "mg_memory.hpp"
#include "mg_tanime.hpp"
#include "memcard.hpp"
#include "menudraw.hpp"
#include "menusys.hpp"
#include "userdata.hpp"

struct InventFoundFlags {
    u8 flag[3];
};
STATIC_ASSERT(sizeof(InventFoundFlags) == 3);

/**
 * @file
 * Declares the invention menu: the photos the player takes with the camera,
 * the ideas ("neta") and scoops learnt from them, the album saved on the memory
 * card, the invention recipes that combine three ideas into an item, and the
 * menu in which the player browses photos, thinks up inventions and builds them.
 */

class CActionChara;
class CDC2Mes;
class CMenuPosDataForm;
class mgCTexture;
struct ITEMCMD_RET_PARA;

// clang-format off

/**
 *
 * Page of the invention menu shown, as held in the menu's mode.
 *
 */
enum INVENT_MENU_MODE {
    INVENT_MODE_THINK      = 0, /**< Idea board, on which three ideas are combined into an invention. */
    INVENT_MODE_CARD_LIST  = 2, /**< List of the invention cards made so far. */
    INVENT_MODE_ITEM_LIST  = 3, /**< List of the items the player carries. */
    INVENT_MODE_ALBUM_VIEW = 5, /**< Album of photos kept on the memory card. */
    INVENT_MODE_PHOTO_VIEW = 6  /**< Photos carried by the player. */
};

/**
 *
 * Field of a photo that CheckInventPhoto compares against.
 *
 */
enum INVENT_PHOTO_CHECK {
    INVENT_PHOTO_CHECK_NETA    = 0, /**< Idea or scoop the photo shows. */
    INVENT_PHOTO_CHECK_NPC     = 2, /**< Townsperson the photo shows. */
    INVENT_PHOTO_CHECK_MONSTER = 3  /**< Monster the photo shows. */
};

// clang-format on

/**
 *
 * Row of the scoop table: a scoop, the event flag that reveals it and its text.
 *
 */
struct SCOOP_DATA {
    short scoop_id; /**< Idea number of the scoop, from 1000. */
    short flag_no;  /**< Menu bit flag whose setting makes the scoop known. */
    s8    info_no;  /**< Index of the scoop's record in CScoopDataManager. */
    u8    unk_5[3];
    char *text;     /**< Description of the scoop, read from the scoop text file. */
    int   unk_c;
    int   unk_10;
};
STATIC_ASSERT(sizeof(SCOOP_DATA) == 0x14);

/**
 *
 * Name of a photographed idea, read from the picture name file.
 *
 */
struct PIC_NAME_INFO {
    short neta_id; /**< Idea the name belongs to. */
    short unk_2;
    char *name;    /**< Name of the idea. */
};
STATIC_ASSERT(sizeof(PIC_NAME_INFO) == 0x8);

/**
 *
 * Material an invention consumes when it is built.
 *
 */
struct INVENT_MATERIAL {
    short item_id; /**< Item consumed. */
    u8    num;     /**< Number of the item consumed per invention built. */
    u8    unk_3;
};
STATIC_ASSERT(sizeof(INVENT_MATERIAL) == 0x4);

/**
 *
 * Invention recipe: the item produced, the three ideas that make it and the materials that build it.
 *
 */
struct INVENT_MATERIAL_LIST {
    INVENT_MATERIAL *material;     /**< Materials consumed in building the invention. */
    short num;
    u8 unk_6[2];
};
STATIC_ASSERT(sizeof(INVENT_MATERIAL_LIST) == 0x8);

struct MakeItemNeeds {
    struct Need {
        int item_id;
        int amount;
    };
    int num;
    Need need[4];
};
STATIC_ASSERT(sizeof(MakeItemNeeds) == 0x24);

struct INVENT_DATA_INFO {
    short            item_id;      /**< Item the invention produces, or -1 for an unset row. */
    short            neta_id[3];   /**< Ideas that combine into the invention. */
    union {
        struct {
    INVENT_MATERIAL *material;     /**< Materials consumed in building the invention. */
    short            material_num; /**< Number of entries in material. */
    u8               unk_e[2];
        };
        INVENT_MATERIAL_LIST materials;
    };
    short            unk_10;
    u8               unk_12[2];
    float            model_pos[3]; /**< Position the produced item's model is shown at when built. */
    float            model_scale;  /**< Scale the produced item's model is shown at when built. */
};
STATIC_ASSERT(sizeof(INVENT_DATA_INFO) == 0x24);

/**
 *
 * Album kept on the memory card: fifty photos with their pixels.
 *
 */
class CDC2AlbumData {
public:
    char              photo_work[50][0x2000]; /**< Pixels of the album's photos. */
    USER_PICTURE_INFO photo[50];              /**< Photos of the album. */
    u8                unk_644b0[0x800];

    /**
     *
     * Clears the album and points each photo at its pixels.
     *
     * @mangled Initialize__13CDC2AlbumDataFv
     * @address 0x1FFF00
     * @size 0x40
     */
    void Initialize();

    /**
     *
     * Points each photo at its pixels in photo_work.
     *
     * @mangled RelateAlbumPicData__13CDC2AlbumDataFv
     * @address 0x1FFF40
     * @size 0x70
     */
    void RelateAlbumPicData();

    /**
     *
     * Empties a photo slot of the album.
     *
     * @mangled DeletePhotoData__13CDC2AlbumDataFi
     * @address 0x1FFFB0
     * @size 0x40
     */
    void DeletePhotoData(int index);

    /**
     *
     * Returns a photo slot of the album, or NULL for an index out of range.
     *
     * @mangled GetAlbumPhotoInfo__13CDC2AlbumDataFi
     * @address 0x1FFFF0
     * @size 0x40
     */
    USER_PICTURE_INFO *GetAlbumPhotoInfo(int index);
};
STATIC_ASSERT(sizeof(CDC2AlbumData) == 0x64CB0);

/**
 *
 * Invention recipes read from the invention list file.
 *
 */
class CInventDataManage {
public:
    short             num;   /**< Number of recipes. */
    INVENT_DATA_INFO *table; /**< Recipes. */

    /**
     *
     * Returns the recipe producing an item, or NULL when there is none.
     *
     * @mangled GetInventDataInfoByItemID__17CInventDataManageFi
     * @address 0x2013B0
     * @size 0x60
     */
    INVENT_DATA_INFO *GetInventDataInfoByItemID(int item_id);

    /**
     *
     * Returns the item invented from three ideas, or -1 when they make nothing, flagging when two or more match.
     *
     * @mangled CheckInventEnable__17CInventDataManageFPiPi
     * @address 0x201410
     * @size 0x180
     */
    int CheckInventEnable(int *neta_id, int *near_match);

    /**
     *
     * Stores the number of materials of an item's recipe followed by each material and the amount needed for a count.
     *
     * @mangled HowMuchZairyouMakeItem__17CInventDataManageFiiPi
     * @address 0x201590
     * @size 0xE0
     */
    int HowMuchZairyouMakeItem(int item_id, int count, int *result);

    /**
     *
     * Removes from the player's items the materials used to build a count of an item.
     *
     * @mangled DeleteUserUsedItem__17CInventDataManageFii
     * @address 0x201670
     * @size 0xB0
     */
    int DeleteUserUsedItem(int item_id, int count);

    /**
     *
     * Returns non-zero when the player carries the materials to build a count of an item.
     *
     * @mangled CheckMakeItem__17CInventDataManageFiiP13CGameDataUsed
     * @address 0x201720
     * @size 0x90
     */
    int CheckMakeItem(int item_id, int count, CGameDataUsed *item);

    /**
     *
     * Reads the recipes from an invention list script, returning non-zero when there was one.
     *
     * @mangled LoadAnalyzeInventFile__17CInventDataManageFPci
     * @address 0x201AC0
     * @size 0x80
     */
    int LoadAnalyzeInventFile(char *script, int size);
};
STATIC_ASSERT(sizeof(CInventDataManage) == 0x8);

/**
 *
 * Invention menu: the photo, album, idea board, invention card and item pages and the building of inventions.
 *
 */
class CMenuInvent : public CBaseMenuClass {
public:
    short                 photo_only;               /**< 1 when the menu was opened to show the photos alone. */
    short                 unk_112;
    int                   card_cursor;              /**< Invention card under the cursor. */
    int                   card_top;                 /**< Invention card at the top of the list. */
    int                   item_cursor;              /**< Carried item under the cursor. */
    int                   item_top;                 /**< Carried item at the top of the list. */
    int                   photo_cursor;             /**< Carried photo under the cursor. */
    int                   photo_top;                /**< Row of carried photos at the top of the board. */
    int                   album_cursor;             /**< Album photo under the cursor. */
    int                   album_top;                /**< Row of album photos at the top of the board. */
    int                   memo_cursor;              /**< Idea notebook line under the cursor. */
    int                   memo_top;                 /**< Idea notebook line at the top of the list. */
    MENUFORM_MAKEBRD_INFO make_board;               /**< Materials shown on the building board. */
    CGameDataUsed         create_item;              /**< Item shown for the invention card under the cursor. */
    MC_ICON_DATA          icon_data[3];             /**< Memory card icons of the album save. */
    u8                    unk_24c;
    u8                    unk_24d;
    u8                    unk_24e[2];
    float                 unk_250;
    float                 unk_254;
    u8                    album_enable;             /**< Non-zero when the player carries the album item. */
    u8                    unk_259[3];
    float                 photo_scroll;             /**< Vertical scroll of the photo board. */
    float                 photo_bar;                /**< Position of the photo board's scroll bar. */
    float                 photo_pos[30][2];         /**< Position of each slot on the photo board. */
    u8                    unk_354;
    u8                    unk_355[3];
    float                 memo_scroll;              /**< Vertical scroll of the idea notebook. */
    float                 unk_35c;
    int                   unk_360;
    u8                    unk_364[0xC];
    float                 unk_370[4];
    float                 unk_380[4];
    short                 unk_390;
    short                 unk_392;
    u_int                *unk_394;
    mgCMemory             data_stack;               /**< Memory the menu layout data is read into. */
    mgCTexture           *photo_tex[30];            /**< Texture of each carried photo. */
    mgCTexture           *album_tex[50];            /**< Texture of each album photo. */
    s8                    album_flag[50];           /**< State of each album photo, -1 for an empty slot. */
    u8                    unk_53a[2];
    mgCMemory             chara_stack;              /**< Memory the menu characters are built in. */
    u8                   *create_model_file;
    u8                   *create_motion_file;
    CActionChara         *create_chara;             /**< Model of the item being built. */
    void                 *unk_578;
    INVENT_MATERIAL_LIST *make_material; /**< Materials of the recipe being built. */
    short                 create_step;              /**< Stage of the building sequence. */
    short                 create_item_id;           /**< Item being built. */
    int                   unk_584;
    int                   create_photo_neta[3];
    int                   unk_594;
    s8                    create_photo_name[32];
    s8                    unk_5b8;
    u8                    unk_5b9[3];
    int                   unk_5bc;
    float                 unk_5c0;
    u8                    unk_5c4;
    u8                    unk_5c5[0x1F];
    float                 unk_5e4;
    float                 create_scale;             /**< Scale of the model of the item being built. */
    float                 unk_5ec;
    float                 unk_5f0;
    u8                    unk_5f4;
    u8                    unk_5f5[3];
    float                 unk_5f8;
    s8                    unk_5fc;
    u8                    unk_5fd[3];
    int                   unk_600;
    short                 unk_604;
    short                 unk_606;
    short                 unk_608;
    short                 unk_60a;
    short                 neta_select_num;          /**< Number of ideas placed on the idea board. */
    u8                    unk_60e[2];
    int                   neta_select_index[3];     /**< Photo slot or notebook line of each idea on the board, or -1. */
    s8                    neta_select_type[3];      /**< Source of each idea on the board: 0 a photo, 1 the notebook, -1 none. */
    s8                    unk_61f[3];
    s8                    unk_622[3];
    u8                    unk_625[3];
    float                 unk_628;
    float                 unk_62c;
    void                 *chara_read_info;          /**< Background read of the extra character data. */
    s8                    chara_load_step;          /**< Stage of loading the menu characters. */
    u8                    unk_635[3];
    CActionChara         *sub_chara;                /**< Character attached to the menu character. */
    CActionChara         *unk_63c;
    s8                    unk_640;
    u8                    unk_641;
    short                 unk_642;
    u8                    unk_644[4];
    float                 unk_648;
    s8                    unk_64c;
    u8                    unk_64d[3];
    float                 unk_650;
    float                 unk_654;
    float                 unk_658;
    int                   unk_65c;
    float                 unk_660;
    u8                    unk_664[0xC];
    float                 unk_670[4];
    float                 unk_680[4];
    int                   line_pos[50][2];          /**< Points of the random line drawn by the menu forms. */
    u8                    unk_820[0x528];
    mgCMemory             unk_d48;
    int                   unk_d78;
    int                   unk_d7c;
    u8                    unk_d80[0x12C];
    int                   gradation_mode;           /**< Colour fade of the invention flash being run. */
    int                   unk_eb0;
    u8                    unk_eb4;
    u8                    unk_eb5;
    u8                    unk_eb6;
    u8                    unk_eb7;
    CMenuPosDataForm     *bg_form;                  /**< Background form. */
    CMenuPosDataForm     *itembrd_form;             /**< Item board form. */
    CMenuPosDataForm     *neta_board_form;          /**< Idea board form. */
    void                 *neta_board_bar[3];        /**< Scroll bar parts of the idea board. */
    void                 *neta_board_arrow;         /**< Up arrow part of the idea board. */
    void                 *neta_memo_arrow;          /**< Notebook arrow part of the idea board. */
    CMenuPosDataForm     *makebrd_form;             /**< Building board form. */
    CMenuPosDataForm     *card_list_title_form;     /**< Invention card list title form. */
    CMenuPosDataForm     *card_list_form;           /**< Invention card list form. */
    CMenuPosDataForm     *album_sw_form;            /**< Album switch form. */
    CMenuPosDataForm     *album_big_form;           /**< Enlarged album photo form. */
    CMenuPosDataForm     *neta_memo_form;           /**< Idea notebook form. */
    CMenuPosDataForm     *neta_form[3];             /**< Form of each idea slot on the idea board. */
    u8                    unk_efc[4];
    CMenuPosDataForm     *neta_name_form[3];        /**< Name form of each idea slot on the idea board. */
    u8                    unk_f0c[4];
    CMenuPosDataForm     *poly_chr_form[2];         /**< Forms the menu characters are drawn in. */
    CMenuPosDataForm     *invent_okeff_form;        /**< Invention success effect form. */
    CMenuPosDataForm     *dload_form;               /**< Loading form. */
    CMenuPosDataForm     *recbrd_form;              /**< Camera record board form. */
    CMenuPosDataForm     *kakudai_pic_form;         /**< Enlarged photo form. */
    void                 *kakudai_pic;              /**< Picture part of the enlarged photo form. */
    u8                    unk_f2c[4];

    /**
     *
     * Marks the album photos as empty, or, from the album, only those slots without a photo.
     *
     * @mangled InitPhotoNetaBoardToAlbum__11CMenuInventFi
     * @address 0x201EE0
     * @size 0xB0
     */
    void InitPhotoNetaBoardToAlbum(int from_album);

    /**
     *
     * Walks the album photo states without effect.
     *
     * @mangled CheckRecoverPhotoNum__11CMenuInventFv
     * @address 0x201F90
     * @size 0x40
     */
    int CheckRecoverPhotoNum();

    /**
     *
     * Looks up the menu's forms and form parts by name.
     *
     * @mangled AttachFormInfo__11CMenuInventFv
     * @address 0x201FD0
     * @size 0x2D0
     */
    void AttachFormInfo();

    /**
     *
     * Advances loading of the menu characters by one stage.
     *
     * @mangled LoadCharaCheck__11CMenuInventFv
     * @address 0x2022A0
     * @size 0x4E0
     */
    void LoadCharaCheck();

    /**
     *
     * Returns the photo under the cursor on the photo or album page, or NULL on another page.
     *
     * @mangled GetNowSelectedPictInfo__11CMenuInventFv
     * @address 0x202780
     * @size 0x70
     */
    USER_PICTURE_INFO *GetNowSelectedPictInfo();

    /**
     *
     * Returns the first photo of the current page's photos, storing their number, or NULL on another page.
     *
     * @mangled GetPhotoInfoFromMode__11CMenuInventFPi
     * @address 0x2027F0
     * @size 0x80
     */
    USER_PICTURE_INFO *GetPhotoInfoFromMode(int *num);

    /**
     *
     * Clears the idea board's slots, or re-shows the ideas placed on it.
     *
     * @mangled InitNetaCircle__11CMenuInventFi
     * @address 0x202870
     * @size 0xF0
     */
    void InitNetaCircle(int keep);

    /**
     *
     * Places a photo or notebook idea in the next slot of the idea board.
     *
     * @mangled SetNetaCircle__11CMenuInventFii
     * @address 0x202960
     * @size 0x3A0
     */
    int SetNetaCircle(int type, int index);

    /**
     *
     * Takes the last idea off the idea board, returning its photo slot or notebook line, or -1 when the board is empty.
     *
     * @mangled CancelNetaCircle__11CMenuInventFi
     * @address 0x202D00
     * @size 0x130
     */
    int CancelNetaCircle(int mode);

    /**
     *
     * Returns the idea in a slot of the idea board, or 0 for an empty slot.
     *
     * @mangled GetNowSelectNetaID__11CMenuInventFi
     * @address 0x202E30
     * @size 0xB0
     */
    int GetNowSelectNetaID(int slot);

    /**
     *
     * Returns non-zero when a photo has already been placed on the idea board.
     *
     * @mangled SelectedNetaPhotoAlready__11CMenuInventFi
     * @address 0x202EE0
     * @size 0x50
     */
    int SelectedNetaPhotoAlready(int index);

    /**
     *
     * Returns non-zero when a notebook line is empty or has already been placed on the idea board.
     *
     * @mangled SelectedNetaMemoListAlready__11CMenuInventFi
     * @address 0x202F30
     * @size 0x70
     */
    int SelectedNetaMemoListAlready(int index);

    /**
     *
     * Fills the camera record board with the photo count, ideas, scoops, experience and level.
     *
     * @mangled UpdataRecordBoard__11CMenuInventFv
     * @address 0x202FA0
     * @size 0x1A0
     */
    void UpdataRecordBoard();

    /**
     *
     * Switches to a page of the menu, running the page's form scripts.
     *
     * @mangled PrepareNextMode__11CMenuInventFi
     * @address 0x203140
     * @size 0x210
     */
    void PrepareNextMode(int mode);

    /**
     *
     * Returns the item under the cursor on the card or item list, or NULL on another page.
     *
     * @mangled SearchNowPosItemExist__11CMenuInventFv
     * @address 0x203350
     * @size 0xA0
     */
    CGameDataUsed *SearchNowPosItemExist();

    /**
     *
     * Runs the form script that swaps between the card list and item list layouts.
     *
     * @mangled CreateModeSwapForm__11CMenuInventFi
     * @address 0x2033F0
     * @size 0x40
     */
    void CreateModeSwapForm(int swap);

    /**
     *
     * Starts a colour fade of the invention flash.
     *
     * @mangled GradationSet__11CMenuInventFi
     * @address 0x203430
     * @size 0x3C0
     */
    void GradationSet(int mode);

    /**
     *
     * Advances the colour fade of the invention flash by one frame.
     *
     * @mangled GradationStep__11CMenuInventFv
     * @address 0x2037F0
     * @size 0x300
     */
    void GradationStep();

    /**
     *
     * Finishes opening the menu.
     *
     * @mangled InitEnd__11CMenuInventFv
     * @address 0x203AF0
     * @size 0xC0
     */
    virtual void InitEnd();

    /**
     *
     * Finishes closing the menu, saving the cursor positions.
     *
     * @mangled ExitEnd__11CMenuInventFv
     * @address 0x203BB0
     * @size 0xA0
     */
    virtual void ExitEnd();

    /**
     *
     * Enters the menu's textures, layout and invention list from the menu pack file.
     *
     * @mangled EnterDataMenu__11CMenuInventFPUc
     * @address 0x203C50
     * @size 0x1B0
     */
    void EnterDataMenu(unsigned char *pack);

    /**
     *
     * Handles the result of an item command chosen in the menu.
     *
     * @mangled ItemCmdAfter__11CMenuInventFiP16ITEMCMD_RET_PARA
     * @address 0x203E00
     * @size 0x90
     */
    virtual int ItemCmdAfter(int command, ITEMCMD_RET_PARA *result);

    /**
     *
     * Runs one frame of building an invention: its model, sound and messages.
     *
     * @mangled IsCreateObject__11CMenuInventFii
     * @address 0x203E90
     * @size 0x1590
     */
    virtual int IsCreateObject(int mode, int arg);

    /**
     *
     * Fills the building board with the materials of the item under the cursor.
     *
     * @mangled CalcMakeBrd__11CMenuInventFi
     * @address 0x205420
     * @size 0x1B0
     */
    void CalcMakeBrd(int message);

    /**
     *
     * Returns how many lines of the invention card list can be selected, at least five.
     *
     * @mangled EnableSelectMaxCardList__11CMenuInventFv
     * @address 0x2055D0
     * @size 0x30
     */
    int EnableSelectMaxCardList();

    /**
     *
     * Moves the cursor to the selected entry of the current page.
     *
     * @mangled CalcCursorPosition__11CMenuInventFv
     * @address 0x205600
     * @size 0x480
     */
    void CalcCursorPosition();

    /**
     *
     * Runs one frame of the make-item prompt.
     *
     * @mangled IsMakeObject__11CMenuInventFii
     * @address 0x205A80
     * @size 0x5A0
     */
    virtual int IsMakeObject(int mode, int arg);

    /**
     *
     * Updates the scroll positions and textures of the current page.
     *
     * @mangled CalcTex__11CMenuInventFv
     * @address 0x206020
     * @size 0x13A0
     */
    void CalcTex();

    /**
     *
     * Opens the command window for the entry under the cursor.
     *
     * @mangled BootExtendCommand__11CMenuInventFv
     * @address 0x2073C0
     * @size 0x3B0
     */
    void BootExtendCommand();

    /**
     *
     * Runs one frame of a confirmation prompt opened from the command window.
     *
     * @mangled IsAskExtend__11CMenuInventFii
     * @address 0x207770
     * @size 0x840
     */
    virtual int IsAskExtend(int mode, int arg);

    /**
     *
     * Learns the idea shown by a photo, playing the star effect over it.
     *
     * @mangled PhotoNetaEnter__11CMenuInventFii
     * @address 0x207FB0
     * @size 0x310
     */
    void PhotoNetaEnter(int index, int mode);

    /**
     *
     * Runs one frame of reading or writing the album on the memory card.
     *
     * @mangled IsAccessAlbum__11CMenuInventFv
     * @address 0x2082D0
     * @size 0x13F0
     */
    void IsAccessAlbum();

    /**
     *
     * Stores the screen position of a slot of the photo board.
     *
     * @mangled GetNetaBoardCursorPosition__11CMenuInventFiPi
     * @address 0x2096C0
     * @size 0xA0
     */
    void GetNetaBoardCursorPosition(int index, int *pos);

    /**
     *
     * Stores the screen position of a visible line of the idea notebook.
     *
     * @mangled GetNetaMemoCursorPosition__11CMenuInventFiPi
     * @address 0x209760
     * @size 0x70
     */
    void GetNetaMemoCursorPosition(int line, int *pos);

    /**
     *
     * Rebuilds the lines of the idea notebook from the ideas learnt.
     *
     * @mangled UpdataNetaMemoStr__11CMenuInventFv
     * @address 0x209900
     * @size 0x1A0
     */
    void UpdataNetaMemoStr();

    /**
     *
     * Moves to another page of the menu, carrying the cursor position across.
     *
     * @mangled NextDifferentMode__11CMenuInventFii
     * @address 0x20C000
     * @size 0x160
     */
    void NextDifferentMode(int mode, int arg);
};
STATIC_ASSERT(sizeof(CMenuInvent) == 0xF30);

/**
 *
 * Returns the invention part of the save data, or NULL when there is no save data.
 *
 * @mangled GetInventUserDataPtr__Fv
 * @address 0x1FF8E0
 * @size 0x40
 */
CInventUserData *GetInventUserDataPtr();

/**
 *
 * Empties a photo slot.
 *
 * @mangled Init_USER_PICTURE_INFO__FP17USER_PICTURE_INFO
 * @address 0x1FF920
 * @size 0x30
 */
void Init_USER_PICTURE_INFO(USER_PICTURE_INFO *photo);

/**
 *
 * Copies what a photo shows, leaving the destination's pixels in place.
 *
 * @mangled Copy_USER_PICTURE_INFO__FP17USER_PICTURE_INFOP17USER_PICTURE_INFO
 * @address 0x1FF950
 * @size 0x60
 */
void Copy_USER_PICTURE_INFO(USER_PICTURE_INFO *src, USER_PICTURE_INFO *dst);

/**
 *
 * Sorts photos and their pixels by one of four keys, moving to the next key on each call.
 *
 * @mangled PictureSeiton__FP17USER_PICTURE_INFOPci
 * @address 0x1FF9B0
 * @size 0x360
 */
void PictureSeiton(USER_PICTURE_INFO *photo, char *work, int num);

/**
 *
 * Enters a 64x64 texture for each photo, pointed at the photo's pixels.
 *
 * @mangled AttachPictTex__FiPP10mgCTextureP17USER_PICTURE_INFOi
 * @address 0x1FFD10
 * @size 0x130
 */
void AttachPictTex(int block, mgCTexture **tex, USER_PICTURE_INFO *photo, int num);

/**
 *
 * Stores the indices of the photos that show no idea, returning how many there are.
 *
 * @mangled CheckPhotoDataNoNeed__FP17USER_PICTURE_INFOiPi
 * @address 0x1FFE40
 * @size 0x60
 */
int CheckPhotoDataNoNeed(USER_PICTURE_INFO *photo, int num, int *index);

/**
 *
 * Returns non-zero when the first character is active and has item 0x171 equipped, which lets photos be taken.
 *
 * @mangled IsTakePhoto__Fv
 * @address 0x1FFEA0
 * @size 0x60
 */
int IsTakePhoto();

/**
 *
 * Converts the invention cards of an older save layout into the current one.
 *
 * @mangled TranslateInventUserData__FP15CInventUserDataP15CInventUserData
 * @address 0x200960
 * @size 0xC0
 */
void TranslateInventUserData(CInventUserData *src, CInventUserData *dst);

/**
 *
 * Returns the scoop table row of a scoop, or NULL when it is not in the table.
 *
 * @mangled GetScoopDataTable__Fi
 * @address 0x200A20
 * @size 0x50
 */
SCOOP_DATA *GetScoopDataTable(int scoop_id);

/**
 *
 * Returns a scoop table row by index, or NULL for an index out of range.
 *
 * @mangled GetScoopDataTableIndex__Fi
 * @address 0x200A70
 * @size 0x40
 */
SCOOP_DATA *GetScoopDataTableIndex(int index);

/**
 *
 * Clears the texts of every scoop table row.
 *
 * @mangled InitScoopString__Fv
 * @address 0x200AB0
 * @size 0xD0
 */
void InitScoopString();

/**
 *
 * Reads the scoop texts from a script, copying them into memory.
 *
 * @mangled AnalyzeScoopString__FP9mgCMemoryPci
 * @address 0x200BE0
 * @size 0x70
 */
void AnalyzeScoopString(mgCMemory *memory, char *script, int size);

/**
 *
 * Reads the names of the photographed ideas from the picture name file.
 *
 * @mangled LoadFilePictureName__Fv
 * @address 0x201070
 * @size 0xA0
 */
void LoadFilePictureName();

/**
 *
 * Returns the name of what a photo shows: its idea, townsperson, monster or map, or NULL for none.
 *
 * @mangled GetPhotoName__FP17USER_PICTURE_INFO
 * @address 0x201110
 * @size 0xF0
 */
char *GetPhotoName(USER_PICTURE_INFO *photo);

/**
 *
 * Copies the name of an idea, returning non-zero when it has none.
 *
 * @mangled GetPhotoNameStr__FiPc
 * @address 0x201200
 * @size 0x50
 */
int GetPhotoNameStr(int neta_id, char *name);

/**
 *
 * Returns the title of a photo, with the idea or scoop mark before an idea's name, or NULL for none.
 *
 * @mangled GetPhotoNameCheck__FP17USER_PICTURE_INFO
 * @address 0x201250
 * @size 0xA0
 */
char *GetPhotoNameCheck(USER_PICTURE_INFO *photo);

/**
 *
 * Returns non-zero when the player has the three ideas of an item's recipe, from photos or the notebook.
 *
 * @mangled CheckInventItem__Fi
 * @address 0x201B40
 * @size 0x1B0
 */
int CheckPhotoFlag();

int CheckInventItem(int item_id);

/**
 *
 * Stores the three ideas of an item's recipe, returning their number, or 0 when the item has no recipe.
 *
 * @mangled CheckItemTable__FiPi
 * @address 0x201CF0
 * @size 0xD0
 */
int CheckItemTable(int item_id, int *neta_id);

/**
 *
 * Returns how many carried photos show an idea, townsperson or monster, as chosen by an INVENT_PHOTO_CHECK.
 *
 * @mangled CheckInventPhoto__Fii
 * @address 0x201DC0
 * @size 0x120
 */
int CheckInventPhoto(int id, int check);

/**
 *
 * Draws the invention card shown while building an invention.
 *
 * @mangled MenuInventCreateCardDraw__FRiPf
 * @address 0x209BF0
 * @size 0x260
 */
void MenuInventCreateCardDraw(int &tex_block, float *pos);

/**
 *
 * Draws a photo in its frame, tinted by what it shows.
 *
 * @mangled PictureDraw__FP10mgCTextureP17USER_PICTURE_INFOfffiiii
 * @address 0x209E50
 * @size 0x440
 */
void PictureDraw(mgCTexture *tex, USER_PICTURE_INFO *photo, float x, float y, float scale, int alpha, int red,
                 int blue, int green);

/**
 *
 * Draws one picture by number at a rectangle's corner: a carried photo (0 to 29), an album photo (50 to 99) or the invention memo (1000).
 *
 * @mangled PictureDraw__FRi9mgRect_f_ifPUc
 * @address 0x20A380
 * @size 0x180
 */
void PictureDraw(int &tex_block, mgRect<float> rect, int picture_no, float scale, unsigned char *rgba);

/**
 *
 * Draws the board of carried photos.
 *
 * @mangled MenuInventPictureBoardDraw__FPfRii
 * @address 0x20A500
 * @size 0x4A0
 */
void MenuInventPictureBoardDraw(float *pos, int &tex_block, int mode);

/**
 *
 * Draws the board of album photos.
 *
 * @mangled MenuInventAlbumPictureDraw__FPfRi
 * @address 0x20A9A0
 * @size 0x200
 */
void MenuInventAlbumPictureDraw(float *pos, int &tex_block);

/**
 *
 * Draws the idea notebook.
 *
 * @mangled MenuInventNetaMemoDraw__FPfRi
 * @address 0x20ABA0
 * @size 0x410
 */
void MenuInventNetaMemoDraw(float *pos, int &tex_block);

/**
 *
 * Opens the invention menu, building it and its characters in a menu memory.
 *
 * @mangled MenuInventInit__FP9mgCMemoryPii
 * @address 0x20AFB0
 * @size 0x1050
 */
int MenuInventInit(mgCMemory *memory, int *tex_block, int arg);

/**
 *
 * Runs one frame of the invention menu's input.
 *
 * @mangled MenuInventKey__Fv
 * @address 0x20DBE0
 * @size 0x830
 */
int MenuInventKey();

/**
 *
 * Draws one frame of the invention menu.
 *
 * @mangled MenuInventDraw__Fv
 * @address 0x20E410
 * @size 0x50
 */
void MenuInventDraw();
