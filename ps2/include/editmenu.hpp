#pragma once

#include "common.h"

#include <libvu0.h>

#include "actionchara.hpp"
#include "menudraw.hpp"
#include "menusys.hpp"
#include "mg_memory.hpp"

/**
 * @file
 * Declares the town's Georama menu, which builds, places, paints and
 * analyses the parts of a town, the menu that moves villagers into and out
 * of a placed house, and the announcement of the parts that a Geostone
 * gives.
 */

class CDC2Mes;
class CEditHouse;
class CEditMap;
class CEditParts;
class CEditPartsInfo;
class CMapParts;
class CMenuPosDataForm;
class mgCTexture;
struct MENUFORMPARTS_TYPE;

/**
 * Number of entries in each parts list of the Georama menu.
 */
#define GEORAMA_PARTS_LIST_MAX 0x180

/**
 * Number of pages of the Georama menu, GeoramaViewMode.
 */
#define GEORAMA_VIEW_MODE_NUM 7

/**
 * Number of lines of a Georama menu list shown at once.
 */
#define GEORAMA_LIST_LINE_NUM 8

/**
 * Number of paint colours the Georama menu offers.
 */
#define GEORAMA_PENKI_NUM 8

/**
 * Number of villagers the removal menu can list.
 */
#define REMOVAL_NPC_LIST_MAX 0xB4

/**
 * Number of villager name lines the removal menu's list form holds.
 */
#define REMOVAL_NAME_LINE_MAX 10

/**
 * Page of the Georama menu that the player has chosen, as
 * CMenuGeorama::view_mode holds it.
 */
// clang-format off
enum GeoramaViewMode {
    GEORAMA_VIEW_MAKE        = 0, /**< Builds parts from materials; lists every part the town can build. */
    GEORAMA_VIEW_STOCK       = 1, /**< Takes a built part to place in the town; lists the parts in stock. */
    GEORAMA_VIEW_PAINT       = 2, /**< Picks a paint colour. */
    GEORAMA_VIEW_EDIT        = 3, /**< Leaves the menu to edit the town. */
    GEORAMA_VIEW_CHECK_POINT = 4, /**< Lists the placed houses and their villagers. */
    GEORAMA_VIEW_ANALYZE     = 5, /**< Shows the analysis of the town against its requests. */
    GEORAMA_VIEW_PLACED      = 6, /**< Lists every placed part. */
};

// clang-format on

/**
 * Order that CMenuGeorama::ArrangePartsList sorts a parts list in, as
 * CMenuGeorama::sort_mode holds it.
 */
// clang-format off
enum GeoramaSortMode {
    GEORAMA_SORT_NO        = 0, /**< By ascending part number. */
    GEORAMA_SORT_NAME      = 1, /**< By name, ascending. */
    GEORAMA_SORT_NAME_DESC = 2, /**< By name, descending. */
    GEORAMA_SORT_NUM       = 3, /**< Number of orders; a sort mode wraps back to the first at this value. */
};

// clang-format on

/**
 * How CMenuGeorama::LoadGeoramaPart finds the part it shows.
 */
// clang-format off
enum GeoramaLoadPartKind {
    GEORAMA_LOAD_INFO_ID    = 0, /**< By the identifying number of a part definition. */
    GEORAMA_LOAD_INFO_INDEX = 1, /**< By the index of a part definition in the map's list. */
    GEORAMA_LOAD_PLACE      = 2, /**< By the number of a placed part. */
};

// clang-format on

/**
 * One line of a Georama menu parts list: a part and the name it is shown by.
 */
struct GEORAMA_PARTS_LIST_ITEM {
    s32  no;         /**< Placed part number, part definition number or definition index, by list; -1 for an empty line. */
    s32  num;        /**< Number of the part held, 1 for a placed part, or the part's polygon count in the build list. */
    char name[0x30]; /**< Name of the part shown in the list. */
};

STATIC_ASSERT(sizeof(GEORAMA_PARTS_LIST_ITEM) == 0x38);

/**
 * Selected line and first shown line of one Georama menu page's list.
 */
struct GEORAMA_LIST_INFO {
    s32 select; /**< Line the cursor is on. */
    s32 top;    /**< First line shown. */
};

STATIC_ASSERT(sizeof(GEORAMA_LIST_INFO) == 0x8);

/**
 * Index of each frame of one model that matches a frame of another model,
 * pairing the frames that are posed together.
 */
class CCharaFrameMatching {
public:
    s32  num;       /**< Number of entries in src_frame and dst_frame. */
    s32 *src_frame; /**< Index of each frame of the first model. */
    s32 *dst_frame; /**< Index of the frame of the second model that matches each entry of src_frame. */

    /**
     * Empties the matching.
     *
     * @mangled Initialize__19CCharaFrameMatchingFv
     * @address 0x1FF8A0
     * @size 0x10
     */
    void Initialize();
};

STATIC_ASSERT(sizeof(CCharaFrameMatching) == 0xC);

/**
 * The Georama menu of a town: lists the parts the town can build, the parts
 * in stock, the paint colours, the placed houses and the analysis of the
 * town, and shows the part the cursor is on as a turning model.
 */
class CMenuGeorama : public CBaseMenuClass {
public:
    CEditPartsInfo        *parts_info;                                            /**< Definition of the part shown, or NULL. */
    CEditParts            *place_parts;                                           /**< Placed part shown, or NULL. */
    CMapParts             *view_parts;                                            /**< Model of the part shown, or NULL. */
    u8                     unk_11C[0x14];
    sceVu0FVECTOR          paint_color;                                           /**< Paint colour picked, each channel from 0.0 to 2.0, and alpha. */
    s32                    town_no;                                               /**< Town the menu edits, from 0 to 9. */
    s32                    start_wait;                                            /**< Frames counted while the menu fades in. */
    s32                    view_mode;                                             /**< Page the cursor is on. @see GeoramaViewMode. */
    s8                     view_loaded;                                           /**< Non-zero once a part has been shown on entering the menu. */
    s32                    top;                                                   /**< First line shown of the open page's list. */
    s32                    select;                                                /**< Line the cursor is on in the open page's list. */
    s32                    polygon_left;                                          /**< Polygons the town can still place. */
    s32                    paint_select;                                          /**< Paint colour the cursor is on; GEORAMA_PENKI_NUM for leaving. */
    s32                    paint_top;                                             /**< First paint colour line shown. */
    s32                    unk_164;
    s32                    paint_return;                                          /**< Non-zero when the menu opened to pick a paint colour, and closes once one is picked. */
    s32                    unk_16C;
    mgCMemory              parts_stack;                                           /**< Memory that the part shown draws from. */
    s32                    sort_mode[3];                                          /**< Order of the stock, build and house lists. @see GeoramaSortMode. */
    s32                    unk_1AC;
    s32                    place_num;                                             /**< Number of entries in place_no. */
    s32                    place_no[GEORAMA_PARTS_LIST_MAX];                      /**< Number of every placed part of the town. */
    char                   place_name[GEORAMA_PARTS_LIST_MAX][0x40];              /**< Name of each part of place_no. */
    s32                    placed_num;                                            /**< Number of lines in placed_list. */
    GEORAMA_PARTS_LIST_ITEM placed_list[GEORAMA_PARTS_LIST_MAX];                  /**< Every placed part, for GEORAMA_VIEW_PLACED. */
    s32                    stock_num;                                             /**< Number of lines in stock_list. */
    GEORAMA_PARTS_LIST_ITEM stock_list[GEORAMA_PARTS_LIST_MAX];                   /**< Built parts in stock, by part definition number, for GEORAMA_VIEW_STOCK. */
    s32                    make_num;                                              /**< Number of lines in make_list. */
    GEORAMA_PARTS_LIST_ITEM make_list[GEORAMA_PARTS_LIST_MAX];                    /**< Parts the town can build, by definition index, for GEORAMA_VIEW_MAKE. */
    s32                    house_num;                                             /**< Number of lines in house_list. */
    GEORAMA_PARTS_LIST_ITEM house_list[GEORAMA_PARTS_LIST_MAX];                   /**< Placed houses, for GEORAMA_VIEW_CHECK_POINT. */
    MENUFORM_MAKEBRD_INFO  make_brd;                                              /**< Materials board shown while building a part. */
    CEditPartsInfo        *make_parts;                                            /**< Definition of the part being built, or NULL. */
    GEORAMA_LIST_INFO      list_info[GEORAMA_VIEW_MODE_NUM];                      /**< Cursor of each page's list, kept in the system data between visits. */
    CMenuPosDataForm      *make_brd_form;                                         /**< Form of the materials board. */
    CMenuPosDataForm      *free_color_form;                                       /**< Form of the free colour list. */
    CMenuPosDataForm      *title_form;                                            /**< Form of the menu's title and page tabs. */
    CMenuPosDataForm      *cpview_form;                                           /**< Form that shows the town's culture points. */
    s32                    unk_1B83C;
    float                  list_target_y[GEORAMA_VIEW_MODE_NUM];                  /**< Screen y that each page's list moves to. */
    float                  scroll_bar_y[GEORAMA_VIEW_MODE_NUM];                   /**< Offset of each page's scroll bar from the top of its track. */
    float                  scroll_bar_h[GEORAMA_VIEW_MODE_NUM];                   /**< Length of each page's scroll bar. */
    float                  list_pos[GEORAMA_VIEW_MODE_NUM][2];                    /**< Screen x and y of each page's list. */
    CMenuPosDataForm      *list_form[GEORAMA_VIEW_MODE_NUM];                      /**< Form of each page's list. */
    CMenuPosDataForm      *analyze_form;                                          /**< Form of the analysis list. */
    CMenuPosDataForm      *analyze_percent_form;                                  /**< Form of the analysis percentage bar. */
    CMenuPosDataForm      *house_info_form;                                       /**< Form of the house information. */
    s32                    sub_step;                                              /**< Step of the stock and house pages: 0 for the list, others for the choices on a line. */
    u8                     unk_1B8F8[8];

    /**
     * Finishes opening the menu: enters its textures, makes its messages,
     * opens the page that the previous menu asks for and shows its part.
     *
     * @mangled InitEnd__12CMenuGeoramaFv
     * @address 0x1F9AD0
     * @size 0x570
     */
    virtual void InitEnd();

    /**
     * Closes the menu, keeping each page's cursor in the system data.
     *
     * @mangled ExitEnd__12CMenuGeoramaFv
     * @address 0x1FA040
     * @size 0x150
     */
    virtual void ExitEnd();

    /**
     * Gives the number of lines of a page's list.
     *
     * @mangled GetPartsIDListNum__12CMenuGeoramaFi
     * @address 0x1FA190
     * @size 0x80
     */
    int GetPartsIDListNum(int mode);

    /**
     * Gives the number of placed parts made from a part definition.
     *
     * @mangled GetNowMakePartsNum__12CMenuGeoramaFi
     * @address 0x1FA210
     * @size 0x10
     */
    int GetNowMakePartsNum(int id);

    /**
     * Sorts the stock, build or house list in the list's next order.
     *
     * @mangled ArrangePartsList__12CMenuGeoramaFii
     * @address 0x1FA260
     * @size 0x450
     */
    int ArrangePartsList(int list, int next);

    /**
     * Fills the placed, stock, build and house lists from the town and the
     * save data.
     *
     * @mangled UpdateGeoramaPartsList__12CMenuGeoramaFv
     * @address 0x1FA6B0
     * @size 0x6B0
     */
    void UpdateGeoramaPartsList();

    /**
     * Gives the part number on the cursor's line of the stock or build page,
     * or -1 on another page.
     *
     * @mangled GetNowModeLoadPartsID__12CMenuGeoramaFv
     * @address 0x1FAD60
     * @size 0x70
     */
    int GetNowModeLoadPartsID();

    /**
     * Gives the definition of the part on a line of a page's list, or NULL.
     *
     * @mangled GetNowSelectEditPartsInfo__12CMenuGeoramaFii
     * @address 0x1FADD0
     * @size 0xC0
     */
    CEditPartsInfo *GetNowSelectEditPartsInfo(int mode, int line);

    /**
     * Shows the model of a part, put back where it was and scaled to fit the
     * menu, in place of the part shown before.
     *
     * @mangled LoadGeoramaPart__12CMenuGeoramaFii
     * @address 0x1FAE90
     * @size 0x3A0
     */
    void LoadGeoramaPart(int no, int kind);

    /**
     * Hands the paint colour picked and its item to the town editor.
     *
     * @mangled UpdateGeoramaPartColor__12CMenuGeoramaFi
     * @address 0x1FB230
     * @size 0xC0
     */
    void UpdateGeoramaPartColor(int update);

    /**
     * Finds the forms of the menu by name.
     *
     * @mangled AttachFormInfo__12CMenuGeoramaFv
     * @address 0x1FB2F0
     * @size 0x1C0
     */
    void AttachFormInfo();

    /**
     * Sets the cursor of a page's list.
     *
     * @mangled SetGeoListInfo__12CMenuGeoramaFiii
     * @address 0x1FB4B0
     * @size 0x30
     */
    void SetGeoListInfo(int mode, int select, int top);

    /**
     * Leaves a page for the choice of pages, running one of two scripts.
     *
     * @mangled ReturnSelectMode__12CMenuGeoramaFi
     * @address 0x1FB4E0
     * @size 0x70
     */
    int ReturnSelectMode(int script);

    /**
     * Gives the last line the cursor can reach on a page's list.
     *
     * @mangled GetNowViewModeMax__12CMenuGeoramaFi
     * @address 0x1FB550
     * @size 0x70
     */
    int GetNowViewModeMax(int mode);

    /**
     * Turns the part shown while the L or R button is held.
     *
     * @mangled LRCheck__12CMenuGeoramaFv
     * @address 0x1FB5C0
     * @size 0xD0
     */
    int LRCheck();

    /**
     * Steps the materials board: asks whether to build the part, builds it
     * from the party's items and puts it in stock.
     *
     * @mangled IsMakeObject__12CMenuGeoramaFii
     * @address 0x1FB7D0
     * @size 0x3A0
     */
    virtual int IsMakeObject(int key, int push);

    /**
     * Moves the menu cursor towards the line or tab it is on.
     *
     * @mangled CalcCursorPosition__12CMenuGeoramaFv
     * @address 0x1FBB70
     * @size 0x310
     */
    void CalcCursorPosition();

    /**
     * Moves the forms, scroll bars, analysis bar and part shown towards
     * where the open page puts them.
     *
     * @mangled CalcTex__12CMenuGeoramaFv
     * @address 0x1FBE80
     * @size 0x540
     */
    void CalcTex();

    /**
     * Counts the materials that building the part needs and the party lacks,
     * and lays out the materials board.
     *
     * @mangled CalcMakeBrd__12CMenuGeoramaFv
     * @address 0x1FC3C0
     * @size 0x200
     */
    void CalcMakeBrd();
};

STATIC_ASSERT(sizeof(CMenuGeorama) == 0x1B900);

/**
 * The menu that moves villagers into and out of a placed house, showing
 * the villager picked as a model.
 */
class CRemovalMenu : public CBaseMenuClass {
public:
    mgCMemory           data_stack;                                  /**< Memory of the menu's form data. */
    s32                 exit_wait;                                   /**< Frames counted while the menu closes. */
    s32                 npc_list[REMOVAL_NPC_LIST_MAX];              /**< Villagers who can move into the house. */
    s32                 npc_num;                                     /**< Number of entries in npc_list. */
    s32                 place_no;                                    /**< Number of the placed house. */
    mgCMemory           chara_stack;                                 /**< Memory of the villager model. */
    s32                 special_house;                               /**< Non-zero when the house is of part definition 0x49. */
    s32                 first_npc;                                   /**< Villager who lived in the house when the menu opened. */
    CEditParts         *parts;                                       /**< Placed house, or NULL. */
    CEditPartsInfo     *parts_info;                                  /**< Definition of the placed house. */
    CEditHouse         *house;                                       /**< Villagers of the placed house, or NULL. */
    s32                 model_state;                                 /**< Step of loading the villager model: 0 none, 1 asked for, 2 loading, 3 shown. */
    s32                 model_wait;                                  /**< Frames left before the villager on the cursor is loaded. */
    s32                 select_npc;                                  /**< Villager picked to move into the house. */
    s32                 unk_46C;
    CActionChara        chara;                                       /**< Model of the villager on the cursor. */
    CMenuPosDataForm   *house_form;                                  /**< Form of the house information. */
    u8                  list_jump;                                   /**< Non-zero to put the list at its place at once rather than moving it. */
    s32                 list_scroll_dir;                             /**< 1 when the list last scrolled down, 0 when up. */
    float               list_x;                                      /**< Screen x of the villager list. */
    float               list_y;                                      /**< Screen y of the villager list, moving towards its place. */
    CMenuPosDataForm   *list_form;                                   /**< Form of the villager list. */
    MENUFORMPARTS_TYPE *scroll_parts[3];                             /**< Parts of the list's scroll bar. */
    MENUFORMPARTS_TYPE *line_parts[REMOVAL_NAME_LINE_MAX];           /**< Parts behind each line of the list. */
    CMenuPosDataForm   *npc_win_form;                                /**< Form of the villager's speech window. */
    CMenuPosDataForm   *npc_chr_form;                                /**< Form that shows the villager model. */
    CMenuPosDataForm   *clip_form;                                   /**< Form that clips the list. */
    s32                 select;                                      /**< Line the cursor is on. */
    s32                 top;                                         /**< First line shown. */

    /**
     * Lists the villagers who have joined the town and live in no house.
     *
     * @mangled MakeNPCList__12CRemovalMenuFv
     * @address 0x1FE110
     * @size 0xF0
     */
    void MakeNPCList();

    /**
     * Steps the menu one frame: loads it, moves villagers in and out, shows
     * the villager on the cursor and closes. Gives 1 once it has closed.
     *
     * @mangled KeyStep__12CRemovalMenuFv
     * @address 0x1FE200
     * @size 0x1270
     */
    int KeyStep();
};

STATIC_ASSERT(sizeof(CRemovalMenu) == 0x1500);

/**
 * Gets one of the Georama menu's paint colours as red, green and blue.
 *
 * @mangled GetPenkiColor__FiPf
 * @address 0x1F3D70
 * @size 0x50
 */
void GetPenkiColor(int no, float *out_rgb);

/**
 * Gives the page whose list a list form shows, or -1 for none.
 *
 * @mangled ConvGeoramaDataNo__Fi
 * @address 0x1F3DC0
 * @size 0x20
 */
short ConvGeoramaDataNo(int data_no);

/**
 * Keeps a list's first shown line and cursor within the list and the lines
 * shown.
 *
 * @mangled CheckMenuLine__FPiPiii
 * @address 0x1F3DE0
 * @size 0xC0
 */
void CheckMenuLine(int *select, int *top, int num, int line_num);

/**
 * Opens the Georama menu: reads its data, makes the menu and its messages
 * and fills its lists.
 *
 * @mangled MenuGeoramaInit__FP9mgCMemoryi
 * @address 0x1F3F30
 * @size 0xB70
 */
int MenuGeoramaInit(mgCMemory *stack, int arg);

/**
 * Steps the Georama menu one frame. Gives 1 once it has closed.
 *
 * @mangled MenuGeoramaKey__Fv
 * @address 0x1F4C70
 * @size 0x3B0
 */
int MenuGeoramaKey();

/**
 * Draws the Georama menu.
 *
 * @mangled MenuGeoramaDraw__Fv
 * @address 0x1F5020
 * @size 0x1B0
 */
void MenuGeoramaDraw();

/**
 * Draws the Georama menu's title frame and the cursor on the page tabs.
 *
 * @mangled MenuGeoramaTitleDraw__FRiPfi
 * @address 0x1F51D0
 * @size 0x140
 */
void MenuGeoramaTitleDraw(int &tex_block, float *pos, int alpha);

/**
 * Draws one page's list of the Georama menu.
 *
 * @mangled MenuGeoramaListDraw__FRiPfii
 * @address 0x1F5310
 * @size 0xFD0
 */
void MenuGeoramaListDraw(int &tex_block, float *pos, int data_no, int alpha);

/**
 * Draws the Georama menu's analysis of the town against its requests.
 *
 * @mangled MenuGeoramaAnalyzeDraw__FRiPfi
 * @address 0x1F62E0
 * @size 0xAD0
 */
void MenuGeoramaAnalyzeDraw(int &tex_block, float *pos, int alpha);

/**
 * Clears the announcement of the parts a Geostone gives, keeping memory to
 * make it from.
 *
 * @mangled InitDownLoadAnaunce__FP9mgCMemory
 * @address 0x1F6DB0
 * @size 0x190
 */
void InitDownLoadAnaunce(mgCMemory *stack);

/**
 * Shows or hides the announcement of the parts a Geostone gives.
 *
 * @mangled DrawDownLoadAnaunceSwitch__Fi
 * @address 0x1F6F40
 * @size 0x10
 */
void DrawDownLoadAnaunceSwitch(int draw);

/**
 * Steps the announcement of the parts a Geostone gives one frame, moving to
 * its next message on a push. Gives 1 once it has ended.
 *
 * @mangled StepDownLoadAnaunce__Fi
 * @address 0x1F6F50
 * @size 0x430
 */
int StepDownLoadAnaunce(int push);

/**
 * Draws the announcement of the parts a Geostone gives.
 *
 * @mangled DrawDownLoadAnaunce__Fv
 * @address 0x1F7380
 * @size 0x290
 */
void DrawDownLoadAnaunce();

/**
 * Makes the announcement of the parts and requests a town's Geostones give
 * and the town's analysis list, giving two line counts and the list's height.
 *
 * @mangled MakeDownLoadAnaunce__FiP9mgCMemoryPiPiPi
 * @address 0x1F7610
 * @size 0xE10
 */
int MakeDownLoadAnaunce(int town_no, mgCMemory *stack, int *out_num, int *out_sub_num, int *out_height);

/**
 * Starts the Geostone download effect for as long as the download takes.
 *
 * @mangled InitMenuDl3__FP10mgCTexture
 * @address 0x1F8420
 * @size 0x10
 */
void InitMenuDl3(mgCTexture *texture);

/**
 * Steps the Geostone download effect one frame. Gives non-zero once it has
 * ended.
 *
 * @mangled StepMenuDl3__Fv
 * @address 0x1F8430
 * @size 0x80
 */
int StepMenuDl3();

/**
 * Draws the information of the placed house the Georama or removal menu
 * shows.
 *
 * @mangled MenuPlacedHouseDraw__FRi
 * @address 0x1F84B0
 * @size 0x980
 */
void MenuPlacedHouseDraw(int &tex_block);

/**
 * Draws the model of the part the Georama menu shows.
 *
 * @mangled MenuMapPartsDraw__FRi
 * @address 0x1F90D0
 * @size 0x180
 */
void MenuMapPartsDraw(int &tex_block);

/**
 * Gives non-zero when a town's Georama menu shows the pictures of its
 * check points rather than its house list.
 *
 * @mangled CheckGekkaViewMode__Fi
 * @address 0x1F9A90
 * @size 0x40
 */
int CheckGekkaViewMode(int town_no);

/**
 * Gives the item number of one of the paint colours, or -1.
 *
 * @mangled GetPenkiItemNo__Fi
 * @address 0x1FA220
 * @size 0x40
 */
int GetPenkiItemNo(int no);

/**
 * Writes the name of a part and of the materials it needs into a message,
 * counting the materials on a materials board.
 *
 * @mangled MakeMsgPartsItemInfo__FP7CDC2MesP14CEditPartsInfoP21MENUFORM_MAKEBRD_INFO
 * @address 0x1FB690
 * @size 0x140
 */
void MakeMsgPartsItemInfo(CDC2Mes *mes, CEditPartsInfo *info, MENUFORM_MAKEBRD_INFO *brd);

/**
 * Opens the menu that moves villagers into and out of the placed house.
 *
 * @mangled MenuRemovalInit__FP9mgCMemoryPi
 * @address 0x1FF470
 * @size 0x430
 */
void MenuRemovalInit(mgCMemory *stack, int *arg);

/**
 * Steps the removal menu one frame. Gives 1 once it has closed.
 *
 * @mangled MenuRemovalKey__Fv
 * @address 0x1FF8B0
 * @size 0x10
 */
int MenuRemovalKey();

/**
 * Draws the removal menu's forms.
 *
 * @mangled MenuRemovalDraw__Fv
 * @address 0x1FF8C0
 * @size 0x10
 */
void MenuRemovalDraw();
