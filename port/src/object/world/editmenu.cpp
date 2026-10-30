#include "common.h"
#include "mw_runtime.h"

#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <iterator>
#include <memory>

#include "dataread.hpp"
#include "dngmenu.hpp"
#include "drawwin.hpp"
#include "editanalyze.hpp"
#include "editdata.hpp"
#include "editevent.hpp"
#include "editmap.hpp"
#include "editmenu.hpp"
#include "editmode.hpp"
#include "editparts.hpp"
#include "font.hpp"
#include "gamedata.hpp"
#include "mainloop.hpp"
#include "map.hpp"
#include "memory/tracked_copy.hpp"
#include "menuaqua.hpp"
#include "menuchr.hpp"
#include "menucls1.hpp"
#include "menucommon.hpp"
#include "menudraw.hpp"
#include "menumain.hpp"
#include "menuop.hpp"
#include "menusys.hpp"
#include "mg_drawprim.hpp"
#include "mg_math.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "npccfg.hpp"
#include "prespr.hpp"
#include "savedata.hpp"
#include "scenesnd.hpp"
#include "scriptinterpreter.hpp"
#include "sound.hpp"
#include "sysmes.hpp"
#include "text/bounded.hpp"
#include "userdata.hpp"

/**
 *
 * Identifies actions returned while removing a georama part.
 *
 */
enum RemovalAction {
    REMOVAL_ACTION_NONE = -1,
    REMOVAL_ACTION_BACK = 0x32,
    REMOVAL_ACTION_PICK = 0xBE,
    REMOVAL_ACTION_MOVE_IN = 0xC8,
    REMOVAL_ACTION_CANCEL = 0xD2,
    REMOVAL_ACTION_WAIT = 0x1F4,
    REMOVAL_ACTION_CLOSE = 0x1FE
};

/**
 *
 * Steps of the part-building flow, as CMenuGeorama::step holds them while the mode is MENU_ASK_MODE_MAKE.
 *
 */
enum GeoramaMakeStep {
    GEORAMA_MAKE_STEP_CHOOSE_AMOUNT = 0,  /**< Choosing how many parts to build. */
    GEORAMA_MAKE_STEP_DONE = 1,           /**< Waiting for a press after the build, before returning to browsing. */
    GEORAMA_MAKE_STEP_CONFIRM = 2,        /**< Asking the player to confirm the build. */
    GEORAMA_MAKE_STEP_NEED_MATERIALS = 3, /**< Telling the player that materials are missing. */
};

/**
 *
 * Villager count that CRemovalMenu::MakeNPCList zero-fills the removal villager list up to.
 *
 */
enum RemovalNpcLimit {
    REMOVAL_NPC_LIMIT = 32, /**< Entries of the removal villager list that are cleared past the last villager found. */
};

/**
 *
 * Identifies the five Georama list message windows and their backing part lists.
 *
 */
enum GeoramaMessageList {
    GEORAMA_MESSAGE_LIST_NONE = -1,  /**< View without a list message window. */
    GEORAMA_MESSAGE_LIST_MAKE = 0,   /**< Buildable part list. */
    GEORAMA_MESSAGE_LIST_STOCK = 1,  /**< Built part stock list. */
    GEORAMA_MESSAGE_LIST_PAINT = 2,  /**< Paint colour list. */
    GEORAMA_MESSAGE_LIST_PLACED = 3, /**< Placed part list. */
    GEORAMA_MESSAGE_LIST_HOUSE = 4,  /**< Placed-house information list. */
};

/**
 *
 * Identifies the initial system messages assigned to Georama list windows.
 *
 */
enum GeoramaInitialMessage {
    GEORAMA_INITIAL_MESSAGE_BASE = 0x5DC,   /**< Base added to the compact message offsets. */
    GEORAMA_INITIAL_MESSAGE_MAKE = 0x5F0,   /**< Buildable part message. */
    GEORAMA_INITIAL_MESSAGE_STOCK = 0x5F1,  /**< Built part stock message. */
    GEORAMA_INITIAL_MESSAGE_PAINT = 0x5F2,  /**< Paint colour message. */
    GEORAMA_INITIAL_MESSAGE_PLACED = 0x5F6, /**< Placed part message. */
    GEORAMA_INITIAL_MESSAGE_HOUSE = 0x5F7,  /**< Placed-house information message. */
};

void MenuGeoramaMessageMake(int mode);

/**
 *
 * Links a downloadable georama item to its name and category.
 *
 */
struct DownLoadEntry {
    signed char    kind; /**< Download entry category. */
    u8             unk_1[3]{};
    char          *name; /**< Display name of the download entry. */
    u8             unk_8;
    signed char    has_extra; /**< Whether the entry carries extra data. */
    u8             unk_a[2]{};
    DownLoadEntry *next; /**< Next entry in the download list. */

    /**
     *
     * Creates an empty download entry.
     *
     */
    DownLoadEntry() {
        kind = 0;
        name = nullptr;
        next = nullptr;
        unk_8 = 1;
        has_extra = 0;
    }
};

/**
 *
 * Stores the screen rectangle for a download item.
 *
 */
struct DownLoadRect {
    short x; /**< Horizontal rectangle position. */
    short y; /**< Vertical rectangle position. */
    short w; /**< Rectangle width. */
    short h; /**< Rectangle height. */
};

/**
 *
 * Tracks a staged Geostone count animation.
 *
 */
struct GeoStoneDmyCnt {
    int             step;            /**< Current animation step. */
    int             remaining_steps; /**< Steps left in the animation. */
    int             frames;          /**< Frames elapsed in the current step. */
    GeoStoneDmyCnt *next;            /**< Next count animation entry. */

    /**
     *
     * Creates a count animation before its steps are assigned.
     *
     */
    GeoStoneDmyCnt() {
        frames = 0;
        step = 0;
        remaining_steps = 0;
        next = nullptr;
    }
};

/**
 *
 * Tracks whether each georama request condition has been met.
 *
 */
struct GeoRequestCheck {
    int con_no[16][8];   /**< Condition numbers for each request. */
    int con_flag[16][8]; /**< Flags for each request condition. */
    int met[16];         /**< Completion state of each request. */
};

STATIC_ASSERT(sizeof(GeoRequestCheck) == 0x440);

/**
 *
 * Tracks the selected and first visible row of a georama list.
 *
 */
struct GeoramaListState16 {
    short selected; /**< Selected list row. */
    short top;      /**< First visible list row. */
};

/**
 *
 * Stores list positions for the georama menu.
 *
 */
struct MenuGeoramaSystemInfo {
    u8                 unk_0[0x50];
    GeoramaListState16 list_state[7]; /**< Position and selection of each list. */
};

/**
 *
 * Handles held and pressed buttons for one Georama menu action.
 *
 */
using GeoramaPushFunc = int (*)(CMenuGeorama *menu, int buttons_held, int buttons_pressed);

int  georama_menu_local_key(int keys);
void MenuPlacedHousePosLinkMes();
void MenuPlacedHouseMessMake(CEditPartsInfo *info, CEditHouse *house, int update);
int  MenuGeoramaPushKey(int keys, int pushed);
int  MenuGeoramaBasePush(CMenuGeorama *menu, int buttons_held, int buttons_pressed);
int  MenuGeoramaPlacePush(CMenuGeorama *menu, int buttons_held, int buttons_pressed);

int MenuGeoramaMakePush(CMenuGeorama *menu, int keys, int pushed);
int MenuGeoramaPaintSelect(CMenuGeorama *menu, int keys, int pushed);
int MenuGeoramaCheckPointPush(CMenuGeorama *menu, int keys, int pushed);
int MenuGeoramaAnalyzeSelect(CMenuGeorama *menu, int keys, int pushed);

/**
 *
 * Original position of the displayed Georama part before menu transformations.
 *
 */
static float old_menuparts_pos[4] = {0.0f, 0.0f, 0.0f, 0.0f};

/**
 *
 * Original rotation of the displayed Georama part before menu transformations.
 *
 */
static float old_menuparts_rot[4] = {
    0.0f,
    0.0f,
    0.0f,
    0.0f,
};

/**
 *
 * Current position of the map part shown in the Georama preview.
 *
 */
static float now_menu_pos_mapparts[4] = {
    0.0f,
    0.0f,
    0.0f,
    0.0f,
};

/**
 *
 * Offset positioning the displayed Georama part within its preview.
 *
 */
static float georama_adjust_position[4] = {
    0.0f,
    0.0f,
    0.0f,
    0.0f,
};

/**
 *
 * Inventory item identifiers for the eight Georama paint colours.
 *
 */
static short penki_item_no[8] = {
    237,
    238,
    242,
    240,
    241,
    243,
    244,
    239,
};

/**
 *
 * Georama paint colours and the unpainted sentinel.
 *
 */
static float GeoramaColorList[9][3] = {
    {90.5f,       38.2000008f, 35.0f      },
    {38.2000008f, 63.7000008f, 76.5f      },
    {155.0f,      145.0f,      50.5f      },
    {63.7000008f, 89.25f,      63.7000008f},
    {128.5f,      90.8000031f, 30.0f      },
    {76.5f,       63.7999992f, 89.0f      },
    {128.0f,      76.0f,       76.0f      },
    {50.0f,       50.0f,       50.0f      },
    {-1.0f,       -1.0f,       -1.0f      },
};

/**
 *
 * Preview scale for each georama part definition.
 *
 */
static float georama_parts_adjust_scaletable[93] = {
    0.0f,
    0.35800001f,
    0.607200027f,
    0.0f,
    0.963f,
    0.948000014f,
    0.483999997f,
    0.307999998f,
    1.1868f,
    0.326700002f,
    0.529200017f,
    0.995999992f,
    0.237499997f,
    0.43599999f,
    0.635999978f,
    1.579f,
    2.27850008f,
    0.699999988f,
    2.04099989f,
    0.241500005f,
    0.250999987f,
    0.485000014f,
    0.284999996f,
    0.450100005f,
    1.36889994f,
    0.833800018f,
    0.301999986f,
    0.529500008f,
    0.860000014f,
    0.299899995f,
    1.18200004f,
    0.35800001f,
    0.292699993f,
    0.485500008f,
    0.565999985f,
    0.183300003f,
    0.698499978f,
    0.615001023f,
    0.527711987f,
    0.325399995f,
    0.168400005f,
    0.195690006f,
    0.204999998f,
    0.0680000037f,
    0.600000024f,
    0.166500002f,
    0.533999979f,
    0.205308005f,
    0.0f,
    0.219300002f,
    0.0f,
    0.0f,
    0.0f,
    0.190599993f,
    0.0f,
    0.0f,
    0.0f,
    0.196999997f,
    0.0f,
    0.0983999968f,
    0.1426f,
    0.146919996f,
    0.207599998f,
    0.188999996f,
    0.269699991f,
    1.06760001f,
    0.235699996f,
    0.385600001f,
    0.163000003f,
    0.156680003f,
    0.210327998f,
    0.259932995f,
    0.243741006f,
    0.42750001f,
    1.09300005f,
    0.106700003f,
    0.0f,
    1.23500001f,
    0.15106f,
    0.128000006f,
    0.300000012f,
    0.244200006f,
    0.337500006f,
    0.0f,
    0.0f,
    0.759500027f,
    0.0f,
    0.0f,
    0.94599998f,
    0.329100013f,
    0.390799999f,
    0.0f,
    0.0f,
};

/**
 *
 * Preview depth offset for each georama part definition.
 *
 */
static float georama_parts_adjust_z_table[93] = {
    0.0f,
    0.0f,
    7.0f,
    0.0f,
    0.200000003f,
    0.0f,
    2.0f,
    14.0f,
    0.0f,
    0.0f,
    -0.5f,
    6.0f,
    12.0f,
    12.0f,
    1.60000002f,
    0.600000024f,
    2.27850008f,
    0.0f,
    13.0f,
    18.0f,
    -10.0f,
    -6.0f,
    0.0f,
    9.0f,
    0.0f,
    0.0f,
    27.0f,
    -2.5f,
    0.860000014f,
    17.0f,
    3.0f,
    -5.0f,
    -5.0f,
    4.0f,
    -6.0f,
    14.0f,
    0.0f,
    0.0f,
    0.0f,
    -4.0f,
    1.0f,
    1.0f,
    0.0f,
    -30.0f,
    2.0f,
    -8.0f,
    5.5f,
    -0.800000012f,
    0.0f,
    0.219300002f,
    0.0f,
    0.0f,
    0.0f,
    -3.0f,
    0.0f,
    0.0f,
    0.0f,
    -11.0f,
    0.0f,
    0.0983999968f,
    15.0f,
    -8.0f,
    -14.0f,
    0.172999993f,
    0.269699991f,
    -3.0f,
    -14.0f,
    -14.0f,
    14.0f,
    -8.0f,
    -19.0f,
    -17.0f,
    -19.0f,
    0.42750001f,
    1.09300005f,
    0.0f,
    0.0f,
    1.23500001f,
    -3.0f,
    3.0f,
    0.300000012f,
    5.0f,
    15.0f,
    0.0f,
    0.0f,
    -3.0f,
    0.0f,
    0.0f,
    -10.0f,
    0.329100013f,
    0.390799999f,
    0.0f,
    0.0f,
};

/**
 *
 * Input handler for each Georama menu action, with null entries for inactive actions.
 *
 */
static GeoramaPushFunc MenuGeoramaPushFunc[9] = {
    MenuGeoramaBasePush,
    MenuGeoramaMakePush,
    MenuGeoramaPlacePush,
    MenuGeoramaPaintSelect,
    nullptr,
    MenuGeoramaCheckPointPush,
    MenuGeoramaAnalyzeSelect,
    nullptr,
    nullptr,
};

/**
 *
 * Number of text lines used when scrolling the Geostone announcement.
 *
 */
static short DownLoadMesScrlGyouNum = 1;

/**
 *
 * Percentage of the current town Georama requests that are satisfied.
 *
 */
static int analyze_percent = 100;

/**
 *
 * Whether the Georama request message list needs reconstruction.
 *
 */
static signed char GeoramaReqMakeFlag = 1;

/**
 *
 * House whose residents and attached parts appear in the placed-house panel.
 *
 */
static CEditHouse *HouseDrawInfo;

/**
 *
 * Form containing the placed-house information panel.
 *
 */
static CMenuPosDataForm *HouseInfoFormGrobal;

/**
 *
 * Placed part identifier of the house shown in the information panel.
 *
 */
static int HousePartsID;

/**
 *
 * First visible row of the placed-house information list.
 *
 */
static short HouseInfoSelectLine;

/**
 *
 * Selected row of the placed-house information list.
 *
 */
static short HouseInfoSelectSelect;

/**
 *
 * Whether to snap the placed-house list and cursor to their target positions.
 *
 */
static signed char HouseInfoSelectMoveInit;

/**
 *
 * Vertical scrolling position of the placed-house information list.
 *
 */
static int HouseInfoSelectY;

/**
 *
 * Whether the placed-house list cursor is visible.
 *
 */
static int HouseInfoCursorAlphaOnOff;

/**
 *
 * Opacity of the placed-house list cursor.
 *
 */
static int HouseInfoCursorAlpha;

/**
 *
 * Vertical position of the placed-house list cursor.
 *
 */
static int HouseInfoCursorY;

/**
 *
 * Number of part definitions already available for construction.
 *
 */
int PartsMakeOkTableNum;

/**
 *
 * First entry in the Geostone download announcement.
 *
 */
static DownLoadEntry *DownLoadInfo;

/**
 *
 * Next announcement entry waiting for message construction.
 *
 */
static DownLoadEntry *DownLoadInfoNext;

/**
 *
 * Whether every download entry has been announced.
 *
 */
static signed char DownLoadInfoEndFlag;

/**
 *
 * Whether the download announcement windows are drawn.
 *
 */
static signed char DownLoadInfoDrawFlag;

/**
 *
 * Screen rectangle used by the download announcement windows.
 *
 */
static DownLoadRect DownLoadWinRect;

/**
 *
 * Number of entries displayed by the download announcement.
 *
 */
static short DownLoadDispNum;

/**
 *
 * Current progress of the download announcement.
 *
 */
static short DownLoadProgress;

/**
 *
 * Progress state for constructing the next announcement message.
 *
 */
static signed char DownLoadMesMakeProgress;

/**
 *
 * Opacity of the download announcement message windows.
 *
 */
static int DownLoadMesAlpha;

/**
 *
 * Announcement message window selected for construction.
 *
 */
static signed char DownLoadMesMakeNo;

/**
 *
 * Message window currently revealing a download entry.
 *
 */
static ClsMes *DownLoadActiveMes;

/**
 *
 * Upward scrolling offset of announcement message windows.
 *
 */
static short DownLoadMesUpY;

/**
 *
 * Whether the original displayed part position and rotation have been saved.
 *
 */
static u8 old_menuparts_pos_flag;

/**
 *
 * Whether the displayed model form should snap to its target position.
 *
 */
static u8 NowPolyGonFormMoveFlag;

/**
 *
 * Map part currently shown by the Georama menu.
 *
 */
static CMapParts *MenuMapPart;

/**
 *
 * Saved selections and scrolling positions for the Georama menu lists.
 *
 */
static MenuGeoramaSystemInfo *MenuGeoramaSystemData;

/**
 *
 * Whether the menu cursor must move immediately to its target.
 *
 */
static u8 MenuGeoramaCursorForceSetFlag;

/**
 *
 * Whether a Geostone download is active in the Georama menu.
 *
 */
static signed char MenuGeoStoneDonwLoadFlag;

/**
 *
 * Number of part entries supplied by the Geostone download.
 *
 */
static u16 MenuGeoStoneDownLoad_PartsNum;

/**
 *
 * Number of request entries supplied by the Geostone download.
 *
 */
static u16 MenuGeoStoneDownLoad_Request;

/**
 *
 * Total steps represented by the staged Geostone count animation.
 *
 */
static u32 MenuGeoStoneDownLoadTime;

/**
 *
 * First stage of the Geostone count animation.
 *
 */
static GeoStoneDmyCnt *MenuGeoStoneDmyCnt;

/**
 *
 * Current stage of the Geostone count animation.
 *
 */
static GeoStoneDmyCnt *MenuGeoStoneDmyCnt_Now;

/**
 *
 * Results of checking each Georama request condition.
 *
 */
static GeoRequestCheck *GeoRequestFlag;

/**
 *
 * Memory stack used for the displayed Georama part.
 *
 */
static mgCMemory *MenuPartsDrawStack;

/**
 *
 * Town edit map inspected by the Georama menu.
 *
 */
CEditMap *MenuMainMapInfo;

/**
 *
 * Active Georama menu.
 *
 */
CMenuGeorama *CMenuGeoPt;

/**
 *
 * Photograph selected for the Georama wall-picture preview.
 *
 */
static short MenuGeoramaViewNowPicNo;

/**
 *
 * Texture of the selected Georama wall photograph.
 *
 */
static mgCTexture *MenuGeoramaViewWallPic;

/**
 *
 * Request source currently examined by the Georama analysis menu.
 *
 */
static EditAnalyzeSrc *MenuEditAnalyzeSrc;

/**
 *
 * Number of request entries in the Georama analysis list.
 *
 */
static short MenuEditAnalyzeDataSrcNum;

/**
 *
 * Total vertical extent of the Georama analysis list.
 *
 */
static float MenuEditAnalyzeDataSrcListH;

/**
 *
 * Target vertical position of the Georama analysis list.
 *
 */
static float MenuEditAnalyzeDataSrcListH_Move;

/**
 *
 * Number of selectable rows within the analysis list scroll limit.
 *
 */
static short MenuEditAnalyzeDataSrcListLimmitNum;

/**
 *
 * Current analysis of the town's Georama state.
 *
 */
static EditDataAnalyze *MenuAnalyzeData;

/**
 *
 * Integer position parameters of the request-board checkpoint indicator.
 *
 */
static int GeoRequestBoardCheckPoint_P[2];

/**
 *
 * Texture containing the Georama menu artwork.
 *
 */
static mgCTexture *Tex_Georama;

/**
 *
 * Frames to wait before drawing the displayed Georama part.
 *
 */
static short GeoramaParts_DrawWaitCnt;

/**
 *
 * Whether Georama message positions must snap to their targets.
 *
 */
static u8 GeoramaMesPosForceSetFlag;

/**
 *
 * Scroll direction used to populate each Georama list message.
 *
 */
static signed char GeoramaMesMakeManner[5];

/**
 *
 * First request line used to populate the analysis message.
 *
 */
static short GeoramaReqMakeLine;

/**
 *
 * Scroll direction used to populate the analysis message.
 *
 */
static short GeoramaReqMakeManner;

/**
 *
 * Whether Georama list messages need immediate reconstruction.
 *
 */
static u8 GeoramaMesForceMakeFlag;

/**
 *
 * Whether the paint-list message needs reconstruction.
 *
 */
static u8 GeoramaMesForceMakeFlag_PaintVer;

/**
 *
 * Vertical scroll-bar position for the Georama analysis list.
 *
 */
static float GeoAnalyzeCheckPointScrlBarY;

/**
 *
 * Screen position of the Georama menu title.
 *
 */
static float menu_georama_title_pos[2];

/**
 *
 * Active villager removal menu.
 *
 */
static CRemovalMenu *RemovalMenuPtr;

/**
 *
 * House name, resident name and names of up to twenty attached parts.
 *
 */
static char *HouseChildPartInfo[22];

/**
 *
 * Part definition identifiers already available for construction.
 *
 */
int PartsMakeOkTable[256];

/**
 *
 * Message windows available to the Geostone download announcement.
 *
 */
static CDC2Mes *DownLoadMes[8];

/**
 *
 * Cached quantities for the paint items displayed by the Georama menu.
 *
 */
static short GeoramaPenkiNum[16];

/**
 *
 * Memory stack for Georama menu data and display objects.
 *
 */
mgCMemory MenuGeoramaStack;

namespace {
/**
 * Owns the active Georama controller independently of its reclaimable arena workspaces.
 */
std::unique_ptr<CMenuGeorama> &GeoramaControllerOwner() {
    static std::unique_ptr<CMenuGeorama> owner;
    return owner;
}

/**
 * Owns the active villager-removal controller independently of its reclaimable arena workspaces.
 */
std::unique_ptr<CRemovalMenu> &RemovalControllerOwner() {
    static std::unique_ptr<CRemovalMenu> owner;
    return owner;
}
} // namespace

void dc2::menu::ResetGeoramaMenus() {
    CMenuGeoPt = nullptr;
    RemovalMenuPtr = nullptr;
    MenuPartsDrawStack = nullptr;
    RemovalControllerOwner().reset();
    GeoramaControllerOwner().reset();
}

CMenuGeorama *dc2::menu::CreateGeoramaController(mgCMemory &memory) {
    auto *storage = dc2::memory::NewArray<u_long128>(memory, 0x2580);
    if (storage == nullptr) {
        return nullptr;
    }
    auto controller = std::make_unique<CMenuGeorama>();
    controller->parts_stack.stSetChildBuffer(memory, storage, 0x2580);
    ResetGeoramaMenus();
    GeoramaControllerOwner() = std::move(controller);
    CMenuGeoPt = GeoramaControllerOwner().get();
    MenuPartsDrawStack = &CMenuGeoPt->parts_stack;
    return CMenuGeoPt;
}

CRemovalMenu *dc2::menu::CreateRemovalController(mgCMemory &memory) {
    auto *storage = dc2::memory::NewArray<u_long128>(memory, 0x1180);
    if (storage == nullptr) {
        return nullptr;
    }
    auto controller = std::make_unique<CRemovalMenu>();
    controller->data_stack.stSetChildBuffer(memory, storage, 0x1180);
    ResetGeoramaMenus();
    RemovalControllerOwner() = std::move(controller);
    RemovalMenuPtr = RemovalControllerOwner().get();
    return RemovalMenuPtr;
}

/**
 *
 * Vertical starting position of each Georama analysis entry.
 *
 */
static float MenuEditAnalyzeDataSrcListHTable[EDIT_ANALYZE_DATA_MAX + 1];

/**
 *
 * Request data entries shown by the Georama analysis menu.
 *
 */
static EditAnalyzeDataSrc *MenuEditAnalyzeDataSrc[EDIT_ANALYZE_DATA_MAX];

/**
 *
 * Texture rectangles of the Georama list titles.
 *
 */
static float GeoBoardListTitleTexRect[5][4];

/**
 *
 * Screen-position offsets of the Georama list titles.
 *
 */
static int GeoBoardListTitlePutOffset[5][2];

/**
 *
 * Texture rectangle of the request-board checkpoint indicator.
 *
 */
static float GeoRequestBoardCheckPoint[4];

/**
 *
 * Message windows used by the Georama lists.
 *
 */
static CDC2Mes *GeoramaMes[5];

/**
 *
 * First source line used to populate each Georama list message.
 *
 */
static short GeoramaMesMakeLine[5];

/**
 *
 * Font objects containing the individual Georama request messages.
 *
 */
static CFont *GeoramaReqMsgFont[48];

/**
 *
 * Number of text lines in each request message font object.
 *
 */
static signed char GeoramaReqMsgFontGyouNum[48];

/**
 *
 * Texture height reserved for each Georama request message.
 *
 */
static short GeoramaReqMsgTexH[48];

/**
 *
 * Whether each request message font object should be drawn.
 *
 */
static signed char GeoramaReqMsgFontDrawFlag[48];

/**
 *
 * Texture rectangle marking completed Georama conditions.
 *
 */
mgRect<int> potti0(0x174, 0xBE, 0x10, 0x10);

/**
 *
 * Texture rectangle of Georama list and condition markers.
 *
 */
mgRect<int> potti1(0x164, 0xBE, 0x10, 0x10);

void GetPenkiColor(int no, float *out_rgb) {
    if (no >= 0 && no < 8) {
        float *color = GeoramaColorList[no];
        out_rgb[0] = color[0];
        out_rgb[1] = color[1];
        out_rgb[2] = color[2];
    }
}

int ConvGeoramaDataNo(int georama_no) {
    static short tbl[7] = {
        GEORAMA_MESSAGE_LIST_MAKE,
        GEORAMA_MESSAGE_LIST_STOCK,
        GEORAMA_MESSAGE_LIST_PAINT,
        GEORAMA_MESSAGE_LIST_NONE,
        GEORAMA_MESSAGE_LIST_HOUSE,
        GEORAMA_MESSAGE_LIST_NONE,
        GEORAMA_MESSAGE_LIST_PLACED,
    };
    return tbl[georama_no];
}

void CheckMenuLine(int *selected, int *top, int count, int visible) {
    while (0 < *top && *top + visible >= count) {
        (*top)--;
    }

    while (*selected < *top) {
        (*selected)++;
    }

    while (*top + visible <= *selected) {
        (*selected)--;
    }

    while (*selected >= count) {
        (*selected)--;
    }
}

/**
 *
 * Sets the initial drawing state and position of the Georama menu form.
 *
 */
void SetEditMenuEnv() {
    CMenuPosDataForm *form = {};

    form = MenuPosData->GetFormInfo("mainpureimage");

    if (form != nullptr) {
        form->draw_flag = 1;
        form->SetRGBACalcParam(0, -3, 0x40);
        form->SetRGBACalcParam(1, -3, 0x40);
        form->SetRGBACalcParam(2, -3, 0x40);
        form->x = 0;
        form->y = 0;
    }
}

int MenuGeoramaInit(mgCMemory *stack, int arg) {
    static char *fname[2] = {"georama0.pac", nullptr};
    int          size = {};
    int          num = {};
    int          sub_num = {};
    int          height = {};

    dc2::menu::ResetGeoramaMenus();
    if (stack == nullptr) {
        return 1;
    }
    SetMenuKeyCtrlEnv(2);
    stack->Align64();
    int rest = stack->stGetRest();
    if (rest <= 0 || !MenuGeoramaStack.stShareBuffer(*stack, std::span(stack->stGetTop(), static_cast<std::size_t>(rest)))) {
        return 1;
    }
    MenuCapture(MenuCommonInfo->tex_block[0], &MenuGeoramaStack, 1);
    MenuMainImageDataEnter(MenuCommonInfo->tex_block[1]);
    MenuCommonInfo->now_mode = MENU_MODE_GEORAMA;
    MenuDataAnalyze(GetMenuMainPosCfgBuffer(&size), size, &MenuGeoramaStack);
    MenuDataAnalyze(reinterpret_cast<char *>(AssetDirectoryRead(MenuArg.pack, "geo.cfg.json", &size)), size, &MenuGeoramaStack);
    InitDownLoadAnaunce(&MenuGeoramaStack);
    HouseInfoSelectMoveInit = 1;
    MenuGeoStoneDmyCnt = nullptr;
    MenuGeoStoneDmyCnt_Now = nullptr;
    MenuMapPart = nullptr;
    Tex_Georama = nullptr;
    HouseInfoFormGrobal = nullptr;
    HouseInfoCursorAlphaOnOff = 0;
    HouseInfoCursorAlpha = 0;
    HouseInfoSelectLine = 0;
    HouseInfoSelectSelect = 0;
    HouseInfoCursorY = 0;
    MenuPosData->ResetTextureInfoAll();
    if (dc2::menu::CreateGeoramaController(MenuGeoramaStack) == nullptr) {
        return 1;
    }
    CMenuGeoPt->town_no = MenuMainScene->now_map_no;

    if (CMenuGeoPt->town_no < 0 || CMenuGeoPt->town_no >= 10) {
        dc2::menu::ResetGeoramaMenus();
        return 1;
    }

    NowPolyGonFormMoveFlag = 0;
    MenuGeoramaViewWallPic = nullptr;
    MenuDrawEnv->camera.SetRef(0.0f, 0.0f, 0.0f);
    MenuDrawEnv->camera.SetPos(0.0f, 0.0f, 1000.0f);
    MenuDrawEnv->ref[0] = -60.0f;
    MenuDrawEnv->ref[1] = 0.0f;
    MenuDrawEnv->ref[2] = 0.0f;
    MenuDrawEnv->pos[0] = 0.0f;
    MenuDrawEnv->pos[1] = 160.0f;
    MenuDrawEnv->pos[2] = 340.0f;
    MenuDrawEnv->speed = 3.0f;
    MenuMainMapInfo = static_cast<CEditMap *>(MenuMainScene->GetMap(MenuMainScene->active_map));
    CMenuGeoPt->AttachFormInfo();
    MenuCommonInfo->AttachFuncData();

    if (MenuCommonInfo->cursor_form != nullptr) {
        MenuCommonInfo->cursor_form->draw_flag = 0;
    }

    MenuCommonInfo->SetVibeCnt(0, 0);
    MenuCommonInfo->SetVibeR(0, 0);
    MenuCommonInfo->SetWakuMoveMethod(2);
    MenuCommonInfo->SetWakuType(-1);
    MenuCommonInfo->key_enable = 0;
    MenuArg.result[0] = -1;
    MenuArg.end_code = MENU_END_NONE;
    MenuGeoramaSystemData = reinterpret_cast<MenuGeoramaSystemInfo *>(GetMenuSysData());

    if (CursorSaveOptionState() != 0) {
        CMenuGeoPt->SetGeoListInfo(0, MenuGeoramaSystemData->list_state[0].selected,
                                   MenuGeoramaSystemData->list_state[0].top);
        CMenuGeoPt->SetGeoListInfo(1, MenuGeoramaSystemData->list_state[1].selected,
                                   MenuGeoramaSystemData->list_state[1].top);
        CMenuGeoPt->SetGeoListInfo(2, MenuGeoramaSystemData->list_state[2].selected,
                                   MenuGeoramaSystemData->list_state[2].top);
    }

    CMenuPosDataForm *form = MenuPosData->GetFormInfo(10);
    int               form_num = MenuPosData->form_num - 10;
    int               i = {};

    for (i = 0; i < form_num; i++, form++) {
        form->draw_flag = 0;
    }

    SetEditMenuEnv();
    const auto system_mes = GetSystemMesBuffer();

    for (i = 0; i < 5; i++) {
        GeoramaMes[i] = dc2::memory::NewObject<CDC2Mes>(MenuGeoramaStack);
        if (GeoramaMes[i] == nullptr) {
            std::exit(EXIT_FAILURE);
        }
        CDC2Mes *mes = GeoramaMes[i];
        mes->MsgPreset(0x10);
        mes->buff = nullptr;
        mes->texture_block = MenuArg.mes_tex_block;
        mes->SetMessData(system_mes, GetMenuMainMessageBuffer());
        mes->font_w = 15;

        if (LanguageCode > 0) {
            mes->font_w = 14;
        }

        mes->font_h = 0x16;
        GeoramaMesMakeManner[i] = 0;
        GeoramaMesMakeLine[i] = 0;
    }

    GeoramaReqMakeFlag = 1;
    GeoramaMesForceMakeFlag = 0;
    GeoramaMesForceMakeFlag_PaintVer = 0;
    GeoramaReqMakeLine = 0;
    GeoramaReqMakeManner = 0;
    MenuCommonReadData(&MenuGeoramaStack, fname, 0);
    MenuGeoramaStack.Alloc(0x1000);
    MenuGeoramaStack.Align64();
    GeoramaParts_DrawWaitCnt = -20;
    MakeDownLoadAnaunce(CMenuGeoPt->town_no, &MenuGeoramaStack, &num, &sub_num, &height);
    MenuEditAnalyzeDataSrcListH_Move = 0;
    MenuEditAnalyzeDataSrcListLimmitNum = 0;
    MenuEditAnalyzeDataSrcListHTable[0] = 0.0f;
    MenuEditAnalyzeDataSrcListH = height;
    MenuEditAnalyzeDataSrcListH -= 228.0f;
    int over = 0;
    int no = {};
    int line = 0;
    int list_h = 0;

    for (no = 0; no + 1 < static_cast<int>(std::size(MenuEditAnalyzeDataSrcListHTable)) &&
                 MenuEditAnalyzeDataSrc[no] != nullptr && line < static_cast<int>(std::size(GeoramaReqMsgTexH));
         no++) {
        EditAnalyzeDataSrc *src = MenuEditAnalyzeDataSrc[no];
        list_h += GeoramaReqMsgTexH[line++];

        for (int con = 0; con < EDIT_ANALYZE_CON_NO_MAX && src->con_no[con] >= 0 &&
                          line < static_cast<int>(std::size(GeoramaReqMsgTexH));
             con++) {
            list_h += GeoramaReqMsgTexH[line++];
        }

        MenuEditAnalyzeDataSrcListHTable[no + 1] = list_h;
        MenuEditAnalyzeDataSrcListLimmitNum++;

        if (MenuEditAnalyzeDataSrcListH < MenuEditAnalyzeDataSrcListHTable[no + 1]) {
            if (over != 0) {
                MenuEditAnalyzeDataSrcListHTable[no + 1] = MenuEditAnalyzeDataSrcListH;
                break;
            }

            over++;
        }
    }

    MenuPosData->GetEtcTblValue("\x82\xC2\x82\xAD\x82\xEA\x82\xE9\x82\xE0\x82\xCC", GeoBoardListTitlePutOffset[0][0], GeoBoardListTitlePutOffset[0][1]);
    MenuPosData->GetEtcTblValue("\x8C\x9A\x82\xC4\x82\xEA\x82\xE9\x82\xE0\x82\xCC", GeoBoardListTitlePutOffset[1][0], GeoBoardListTitlePutOffset[1][1]);
    MenuPosData->GetEtcTblValue("\x83y\x83"
                                "C\x83\x93\x83g\x82\xC5\x82\xAB\x82\xE9\x82\xE0\x82\xCC",
                                GeoBoardListTitlePutOffset[3][0], GeoBoardListTitlePutOffset[3][1]);
    MenuPosData->GetEtcTblValue("\x83y\x83"
                                "C\x83\x93\x83g\x82\xCC\x90"
                                "F",
                                GeoBoardListTitlePutOffset[2][0], GeoBoardListTitlePutOffset[2][1]);
    MenuPosData->GetEtcTblValue("\x94z\x92u\x82\xB5\x82\xC4\x82\xA2\x82\xE9\x82\xE0\x82\xCC", GeoBoardListTitlePutOffset[4][0], GeoBoardListTitlePutOffset[4][1]);

    if (LanguageCode >= 2) {
        MenuPosData->GetEtcTblValue("\x83`\x83"
                                    "F\x83"
                                    "b\x83N\x83|\x83"
                                    "C\x83\x93\x83g",
                                    GeoRequestBoardCheckPoint_P[0], GeoRequestBoardCheckPoint_P[1]);
    }

    MenuPosData->GetEtcTbl2Value("\x82\xC2\x82\xAD\x82\xEA\x82\xE9\x82\xE0\x82\xCC", GeoBoardListTitleTexRect[0], 4);
    MenuPosData->GetEtcTbl2Value("\x8C\x9A\x82\xC4\x82\xEA\x82\xE9\x82\xE0\x82\xCC", GeoBoardListTitleTexRect[1], 4);
    MenuPosData->GetEtcTbl2Value("\x83y\x83"
                                 "C\x83\x93\x83g\x82\xC5\x82\xAB\x82\xE9\x82\xE0\x82\xCC",
                                 GeoBoardListTitleTexRect[3], 4);
    MenuPosData->GetEtcTbl2Value("\x83y\x83"
                                 "C\x83\x93\x83g\x82\xCC\x90"
                                 "F",
                                 GeoBoardListTitleTexRect[2], 4);
    MenuPosData->GetEtcTbl2Value("\x94z\x92u\x82\xB5\x82\xC4\x82\xA2\x82\xE9\x82\xE0\x82\xCC", GeoBoardListTitleTexRect[4], 4);
    MenuPosData->GetEtcTbl2Value("\x83`\x83"
                                 "F\x83"
                                 "b\x83N\x83|\x83"
                                 "C\x83\x93\x83g",
                                 GeoRequestBoardCheckPoint, 4);
    CMenuGeoPt->UpdateGeoramaPartsList();
    MenuKeySelectCheck(0, &CMenuGeoPt->list_info[0].select, &CMenuGeoPt->list_info[0].top, 0,
                       CMenuGeoPt->GetNowViewModeMax(0) + 1, GEORAMA_LIST_LINE_NUM, MENU_CURSOR_LIMIT_CLAMP);
    CheckMenuLine(&CMenuGeoPt->list_info[0].select, &CMenuGeoPt->list_info[0].top, CMenuGeoPt->GetNowViewModeMax(0),
                  GEORAMA_LIST_LINE_NUM);
    CheckMenuLine(&CMenuGeoPt->list_info[1].select, &CMenuGeoPt->list_info[1].top, CMenuGeoPt->GetNowViewModeMax(1),
                  GEORAMA_LIST_LINE_NUM);

    for (int no = 0; no < GEORAMA_PENKI_NUM; no++) {
        GeoramaPenkiNum[no] = GetUserItemHaveNum(penki_item_no[no]);
    }

    return 1;
}

/**
 *
 * Handles debug key shortcuts while the Georama menu is open.
 *
 */
void MenuGeoDebugKey() {
    if (GamePad__2.Down(PAD_TRIANGLE) != 0) {
        CMenuGeoPt->ExeScript("DL_END");
        MenuGeoStoneDonwLoadFlag = 0;
        DownLoadMesAlpha = 0;
        MenuSePlay(SYSTEM_SE_COMPLETE);
    }

    if (GamePad__2.Down(PAD_SQUARE) != 0) {
        CSaveDataDungeon *dungeon = menu_GetSaveDataDungeon();
        int               i = {};

        for (int stage = 0; stage < 7; stage++) {
            for (int floor = 0; floor < 0x28; floor++) {
                DNG_FLOOR_SAVE *info = dungeon->GetFloorInfoPtr(stage, floor);

                if (info != nullptr) {
                    info->flag |= DNG_FLOOR_FLAG_GEOSTONE_FOUND | DNG_FLOOR_FLAG_GEOSTONE_READ;
                }
            }
        }

        for (i = 0; i < EDIT_ANALYZE_DATA_MAX; i++) {
            MenuAnalyzeData->data_open[i] = 1;
        }

        for (i = 0; i < EDIT_ANALYZE_CONDITION_MAX; i++) {
            MenuAnalyzeData->condition_open[i] = 1;
        }

        MenuSePlay(SYSTEM_SE_DECIDE);
    }
}

int MenuGeoramaKey() {
    CMenuGeorama *menu = CMenuGeoPt;
    CMenuKeyFunc *key_func = {};
    int           closed = {};
    int           lr_key = {};
    int           push_button = {};
    int           loading = {};

    if (menu == nullptr) {
        return 1;
    }

    if (MenuMainMapInfo == nullptr) {
        dc2::menu::ResetGeoramaMenus();
        return 1;
    }

    key_func = MenuCommonInfo;

    if (menu_debug_flag != 0) {
        MenuGeoDebugKey();
        return 0;
    }

    closed = 0;
    key_func->CheckSelectKey();
    lr_key = key_func->CheckLRKey();
    push_button = key_func->CheckPushButton();
    key_func->CheckKeyInput();
    loading = ReadBGSync();

    static int GeoAlpha = 0x80;

    switch (menu->mode) {
        case MENU_ASK_MODE_OPEN:
            menu->start_wait++;

            if (menu->opened == 0 && loading == 0) {
                menu->InitEnd();
                menu->opened = 1;
            }

            if (menu->start_wait > 10 && loading == 0) {
                menu->mode = MENU_ASK_MODE_NONE;
                MenuScreenBlackBeltSet(1);
                GeoAlpha = 0x80;
            }

            break;
        case MENU_ASK_MODE_CLOSE:
            GeoAlpha -= 8;

            if (GeoAlpha <= 0) {
                menu->LoadGeoramaPart(-1, GEORAMA_LOAD_INFO_ID);
                menu->ExitEnd();
                closed = 1;
            }

            break;
        case MENU_ASK_MODE_NONE:
            menu->LRCheck();
            MenuGeoramaPushKey(lr_key, push_button);
            break;
        default:
            menu->ExtendCommand(lr_key, push_button);
            break;
    }

    if (menu->mode != MENU_ASK_MODE_CLOSE && menu->opened != 0) {
        CalcMenuAdd(&menu->fade_alpha, -6, 0x40);

        if (GeoramaParts_DrawWaitCnt < 0) {
            GeoramaParts_DrawWaitCnt++;
        }
    }

    MenuPosData->FormStep();
    menu->CalcCursorPosition();
    menu->CalcTex();
    CDC2Mes *mes = MenuDCMsg[0];
    mes->fade_speed = 1.0f;

    switch (menu->key_arg_no) {
        case 0: {
            int tab_mes = menu->view_mode + 10;

            if (menu->town_no != 4 && tab_mes > 13) {
                tab_mes = 13;
            }

            mes->MakeMsg(tab_mes + 0x640);
            break;
        }
        default: {
            int             mes_no = 20000;
            char           *comment = nullptr;
            CEditPartsInfo *info = menu->GetNowSelectEditPartsInfo(menu->view_mode, menu->select);

            if (info != nullptr) {
                comment = info->comment;
            } else {
                mes_no = 0;

                if (menu->view_mode == GEORAMA_VIEW_PAINT) {
                    mes_no = 23000;
                }
            }

            if (comment != nullptr) {
                mes->MakeMsg(comment);
            } else {
                mes->MakeMsg(mes_no);
                mes->open = 1;
            }

            if (menu->key_arg_no == 5 && menu->town_no == 4) {
                mes->MakeMsg(0x64E);
                mes->open = 1;
            }

            break;
        }
    }

    MenuGeoramaMessageMake(0);
    CEditParts     *house_parts = nullptr;
    CEditPartsInfo *house_info = nullptr;
    CEditHouse     *house = nullptr;

    if (menu->view_mode == GEORAMA_VIEW_CHECK_POINT) {
        HousePartsID = -1;

        if (0 <= menu->list_info[GEORAMA_VIEW_CHECK_POINT].select) {
            HousePartsID = menu->house_list[menu->list_info[GEORAMA_VIEW_CHECK_POINT].select].no;
            house_parts = MenuMainMapInfo->GetePlaceParts(HousePartsID);
        }

        if (house_parts != nullptr) {
            house_info = house_parts->info;
            house = house_parts->house;
        }

        MenuPlacedHouseMessMake(house_info, house, 1);
    }

    MenuPlacedHousePosLinkMes();
    if (closed != 0) {
        dc2::menu::ResetGeoramaMenus();
    }
    return closed;
}

void MenuGeoramaDraw() {
    if (CMenuGeoPt != nullptr) {
        mgCTextureManager *tex_manager = {};
        MenuPosData->FormDraw();

        if (MenuGeoStoneDonwLoadFlag == 3 || MenuGeoStoneDonwLoadFlag == 4) {
            DrawDownLoadAnaunce();
        }

        tex_manager = &mgTexManager;

        if (MenuGeoramaViewWallPic) {
            tex_manager->ReloadTexture(MenuGeoramaViewWallPic->block, (sceVif1Packet *) nullptr);
            PrimQuad(MenuGeoramaViewWallPic, mgRect<int>(0, 0, mgScreenWidth, mgScreenHeight),
                     mgRect<int>(0, 0x20, 0x200, 0x1A0), 0x80, 0x80, 0x80, 0x80);
            int tex_block = -1;
            MenuMesForm[2]->MenuFormDraw(tex_block);
        }

        if (menu_debug_flag != 0) {
            int mes_block = MenuArg.mes_tex_block;
            tex_manager->ReloadTexture(mes_block, (sceVif1Packet *) nullptr);
            CMenuFont font;
            DrawMenuFillBox(340.0f, 98.0f, 160.0f, 100.0f, 0x48, 0, 0, 0);
            font.SetStr("(#)\x81"
                        "FAll GeoramaParts On");
            font.SetPos(0x156, 0x64);
            font.DrawDirect(font.str, font.pos_x, font.pos_y);
            font.SetStr("(A)\x81"
                        "FOmit Download");
            font.SetPos(0x156, 0x78);
            font.DrawDirect(font.str, font.pos_x, font.pos_y);
        }
    }
}

void MenuGeoramaTitleDraw(int &tex_block, float *pos, int alpha) {
    if (MenuGeoStoneDonwLoadFlag == 0) {
        __typeof__(&mgTexManager) tex_manager = &mgTexManager;
        DrawMenuWakuRect(tex_manager->GetTexture("menueff0", -1),
                         mgRect<float>(menu_georama_title_pos[0], menu_georama_title_pos[1], 74.0f, 21.0f),
                         mgRect<int>(0x10, 0x20, 0x12, 0xC), alpha, 0x80, 0x80, 0x80);
        mgCTexture *cursor_tex = tex_manager->GetTexture("mnmain", -1);

        if (cursor_tex != nullptr && CMenuGeoPt->key_arg_no == 0) {
            MenuReloadTexture(tex_block, cursor_tex->block);
            float cursor_pos[2];
            cursor_pos[0] = menu_georama_title_pos[0] - 22.0f;
            cursor_pos[1] = 34.0f + menu_georama_title_pos[1];
            MenuCursorDraw(cursor_tex, cursor_pos, -(PI / 6.0f), 0, alpha, 0.7f);
        }
    }
}

void MenuGeoramaListDraw(int &tex_block, float *pos, int page, int alpha) {
    static signed char viewmode_to_mode_convtable[7] = {
        GEORAMA_VIEW_MAKE + 1,
        GEORAMA_VIEW_STOCK + 1,
        GEORAMA_VIEW_PAINT + 1,
        GEORAMA_VIEW_EDIT + 1,
        GEORAMA_VIEW_CHECK_POINT + 1,
        GEORAMA_VIEW_ANALYZE + 1,
        GEORAMA_VIEW_PLACED + 1,
    };
    static short brdtbl_active[12] = {
        350,
        460,
        12,
        22,
        362,
        460,
        12,
        22,
        374,
        460,
        12,
        22,
    };
    static short brdtbl_noneactive[12] = {
        350,
        438,
        12,
        22,
        362,
        438,
        12,
        22,
        374,
        438,
        12,
        22,
    };
    static short ScrlBarTable[12] = {
        356,
        234,
        8,
        10,
        356,
        242,
        8,
        10,
        356,
        250,
        8,
        10,
    };

    if (Tex_Georama != nullptr && pos[0] >= -260.0f) {
        int data_no = ConvGeoramaDataNo(page);

        if (data_no >= 0) {
            MenuReloadTexture(tex_block, Tex_Georama->block);
            mgRect<int>  head_tex(0, 0x132, 0xF2, 0x5E);
            mgRect<int>  body_tex(0, 0x190, 0xF2, 0x40);
            mgRect<int>  foot_tex(0, 0x1D0, 0xF2, 0x59);
            mgCDrawPrim *prim = GetMenuPrim();
            SetSpriteEnv(prim, MENU_SPRITE_ENV_TEXTURE);
            prim->Begin(MG_PRIM_SPRITE);
            prim->Texture(Tex_Georama);
            prim->Color(0, 0, 0, alpha >> 2);
            int shadow_x = static_cast<int>(3.0f + pos[0]);
            int shadow_y = static_cast<int>(3.0f + pos[1]);
            int body_y = shadow_y + head_tex.bottom;
            PrimQuad(prim, shadow_x, shadow_y, head_tex);
            PrimQuad(prim, mgRect<int>(shadow_x, body_y, body_tex.right, 0x88), body_tex);
            PrimQuad(prim, mgRect<int>(shadow_x, static_cast<int>(136.0f + body_y), foot_tex.right, foot_tex.bottom), foot_tex);
            prim->Color(0x80, 0x80, 0x80, alpha);
            float top = pos[1];
            body_y = static_cast<int>(top + head_tex.bottom);
            PrimQuad(prim, pos[0], top, head_tex);
            PrimQuad(prim, mgRect<int>(static_cast<int>(pos[0]), body_y, body_tex.right, 0x88), body_tex);
            PrimQuad(prim, mgRect<int>(static_cast<int>(pos[0]), static_cast<int>(136.0f + body_y), foot_tex.right, foot_tex.bottom), foot_tex);
            u8     active = page >= 0 && CMenuGeoPt->key_arg_no == viewmode_to_mode_convtable[page];
            short *board = brdtbl_active;

            if (!active) {
                board = brdtbl_noneactive;
            }

            prim->Color(0x80, 0x80, 0x80, alpha);
            Menu3DivideTextureDraw(prim, mgRect<int>(static_cast<int>(54.0f + pos[0]), static_cast<int>(11.0f + pos[1]), 0x89, 0x15), board, 1);

            if (active) {
                prim->Color(0xB6, 0xB6, 0xB6, alpha);
            }

            float *title = GeoBoardListTitleTexRect[data_no];
            PrimQuad(prim, mgRect<int>(static_cast<int>(pos[0] + GeoBoardListTitlePutOffset[data_no][0]), static_cast<int>(12.0f + pos[1]), static_cast<int>(title[2]), static_cast<int>(title[3])), mgRect<int>(static_cast<int>(title[0]), static_cast<int>(title[1]), static_cast<int>(title[2]), static_cast<int>(title[3])));
            int bar_x = static_cast<int>(228.0f + pos[0]);
            int bar_y = static_cast<int>(46.0f + pos[1]);
            prim->Color(0x80, 0x80, 0x80, alpha);
            Menu3DivideTextureDraw(prim, mgRect<int>(bar_x, static_cast<int>(bar_y + CMenuGeoPt->scroll_bar_y[page]), 8, static_cast<int>(CMenuGeoPt->scroll_bar_h[page])), ScrlBarTable, 0);
            prim->End();
            float       clip_top = pos[1];
            float       left = pos[0];
            int         screen_right = mgScreenWidth - 1;
            int         screen_bottom = mgScreenHeight - 1;
            mgRect<int> clip(static_cast<int>(19.0f + left), static_cast<int>(45.0f + clip_top), static_cast<int>(222.0f + left), static_cast<int>(1.0f + (238.0f + clip_top)));
            mgRect<int> under_clip(0, static_cast<int>(18.0f + (238.0f + pos[1])), screen_right, screen_bottom);

            if (page == GEORAMA_VIEW_PAINT) {
                clip.bottom -= 2;
                under_clip.top += 2;
            }

            MenuClipRectCheck(clip);
            MenuClipRectCheck(under_clip);
            SetMenuScissor(clip);
            mgRect<int> line_tex(0, 0x229, 0xC0, 6);
            mgRect<int> number_tex(0, 0x294, 0xA, 0xE);
            mgRect<int> number_minus_tex(0, 0x286, 0xA, 0xE);
            mgRect<int> times_tex(0x8C, 0x294, 0xA, 0xE);
            float       check_y = {};
            float       list_x = {};
            int         i = {};
            float       line_x = {};
            float       line_y = {};
            float       list_y = {};
            float      *color = {};
            list_x = CMenuGeoPt->list_pos[data_no][0];
            list_y = CMenuGeoPt->list_pos[data_no][1];
            line_x = list_x - 14.0f;
            line_y = 19.0f + list_y;
            check_y = 3.0f + list_y;

            if (page == GEORAMA_VIEW_STOCK) {
                prim->Bilinear(1);
                prim->Begin(MG_PRIM_SPRITE);
                prim->Texture(Tex_Georama);
                prim->Color(0x80, 0x80, 0x80, alpha);

                for (int i = 0; i < 99; i++, check_y += 24.0f, line_y += 24.0f) {
                    if (line_y < 133.0f) {
                        continue;
                    }

                    if (clip.bottom < line_y) {
                        break;
                    }

                    PrimQuad(prim, line_x, line_y, line_tex);

                    if (line_x < 4.0f) {
                        continue;
                    }

                    PrimQuad(prim, line_x, check_y, potti1);
                    int number_y = static_cast<int>(line_y - 16.0f);
                    PrimQuad(prim, 150.0f + line_x, number_y, times_tex);
                    PrimDrawNumber(prim, CMenuGeoPt->stock_list[i].num, MENU_NUMBER_ALIGN_CENTER, static_cast<int>(180.0f + line_x), number_y, number_tex, -2, 0);

                    if (mgScreenHeight <= check_y) {
                        break;
                    }
                }

                prim->End();
            }

            if (page == GEORAMA_VIEW_MAKE) {
                prim->Begin(MG_PRIM_SPRITE);
                prim->Texture(Tex_Georama);
                prim->Color(0x80, 0x80, 0x80, alpha);

                for (i = 0; i < 99; i++, check_y += 24.0f, line_y += 24.0f) {
                    if (line_y < 133.0f) {
                        continue;
                    }

                    if (clip.bottom < line_y) {
                        break;
                    }

                    PrimQuad(prim, line_x, line_y, line_tex);

                    if (mgScreenHeight <= check_y) {
                        break;
                    }
                }

                prim->End();
            }

            if (page == GEORAMA_VIEW_CHECK_POINT) {
                GEORAMA_PARTS_LIST_ITEM *item = CMenuGeoPt->house_list;
                prim->Bilinear(1);
                prim->Begin(MG_PRIM_SPRITE);
                prim->Texture(Tex_Georama);
                prim->Color(0x80, 0x80, 0x80, alpha);

                for (int i = 0; i < 99; i++, item++, check_y += 24.0f, line_y += 24.0f) {
                    if (line_y < 133.0f) {
                        continue;
                    }

                    if (clip.bottom < line_y) {
                        break;
                    }

                    PrimQuad(prim, line_x, line_y, line_tex);

                    if (0 < item->no && item->num > 1) {
                        PrimQuad(prim, 150.0f + line_x, line_y - 16.0f, times_tex);
                        PrimDrawNumber(prim, item->num, MENU_NUMBER_ALIGN_CENTER, static_cast<int>(180.0f + line_x), static_cast<int>(line_y - 16.0f), number_tex, -2, 0);
                    }

                    if (mgScreenHeight <= check_y) {
                        break;
                    }
                }

                prim->End();
            }

            if (page == GEORAMA_VIEW_PAINT) {
                float swatch_x = 4.0f + list_x;
                float swatch_y = 2.0f + list_y;

                for (i = 0; i < 16; i++, line_y += 24.0f, swatch_y += 24.0f) {
                    if (line_y < 133.0f) {
                        continue;
                    }

                    if (clip.bottom < line_y) {
                        break;
                    }

                    SetSpriteEnv(prim, MENU_SPRITE_ENV_TEXTURE);
                    prim->Bilinear(1);
                    prim->Begin(MG_PRIM_SPRITE);
                    prim->Texture(Tex_Georama);
                    prim->Color(0x80, 0x80, 0x80, alpha);
                    PrimQuad(prim, line_x, line_y, line_tex);
                    prim->End();

                    if (i < GEORAMA_PENKI_NUM) {
                        prim->Begin(MG_PRIM_SPRITE);
                        prim->Texture(Tex_Georama);
                        prim->Color(0x80, 0x80, 0x80, alpha);
                        PrimQuad(prim, 150.0f + line_x, line_y - 16.0f, times_tex);
                        PrimDrawNumber(prim, GeoramaPenkiNum[i], MENU_NUMBER_ALIGN_CENTER, static_cast<int>(180.0f + line_x), static_cast<int>(line_y - 16.0f), number_tex, -2, 0);
                        prim->End();
                        prim->TextureMapEnable(0);
                        prim->Shading(0);
                        prim->Bilinear(1);
                        prim->Begin(MG_PRIM_SPRITE);
                        prim->Color(200, 200, 200, alpha);
                        prim->Vertex(swatch_x, swatch_y, 0.0f);
                        prim->Vertex(static_cast<int>(22.0f + swatch_x), static_cast<int>(19.0f + swatch_y), 0);
                        color = GeoramaColorList[i];
                        float red = 1.6f * color[0];
                        float green = 1.6f * color[1];
                        float blue = 1.6f * color[2];

                        if (255.0f < red) {
                            red = 255.0f;
                        }

                        if (255.0f < green) {
                            green = 255.0f;
                        }

                        if (255.0f < blue) {
                            blue = 255.0f;
                        }

                        prim->Color(static_cast<int>(red), static_cast<int>(green), static_cast<int>(blue), alpha);
                        float ux = 1.0f + swatch_x;
                        float uy = 2.0f + swatch_y;
                        prim->Vertex(ux, uy, 0.0f);
                        float vx = 21.0f + swatch_x;
                        float vy = 17.0f + swatch_y;
                        prim->Vertex(vx, vy, 0.0f);
                        prim->End();
                    }

                    if (mgScreenHeight <= swatch_y) {
                        break;
                    }
                }
            }

            if (0 <= data_no) {
                CDC2Mes *mes = GeoramaMes[data_no];

                if (mes->line_pos[0][0] > -180) {
                    MenuReloadTexture(tex_block, MenuArg.mes_tex_block);
                    mes->SetMsgAlpha(alpha);
                    mes->DrawMesWin();
                    int line = {};

                    for (int line = 0; line < 9; line++) {
                        mes->line_pos[line][1] -= 3;
                    }

                    SetMenuScissor(under_clip);
                    mes->DrawMesWin();

                    for (int line = 0; line < 9; line++) {
                        mes->line_pos[line][1] += 3;
                    }
                }
            }

            ResetMenuScissor();
        }
    }
}

void MenuGeoramaAnalyzeDraw(int &tex_block, float *pos, int alpha) {
    static short brdtbl_noneactive[12] = {
        350,
        438,
        12,
        22,
        362,
        438,
        12,
        22,
        374,
        438,
        12,
        22,
    };
    static short brdtbl[12] = {
        350,
        460,
        12,
        22,
        362,
        460,
        12,
        22,
        374,
        460,
        12,
        22,
    };
    static float offsettable[2][2] = {
        {59.0f, 11.0f},
        {67.0f, 12.0f},
    };
    static short rectboxtbl[12] = {
        356,
        264,
        8,
        32,
        364,
        264,
        2,
        32,
        366,
        264,
        8,
        32,
    };
    static short maintopicbtn[2][2] = {
        {356, 114},
        {356, 152},
    };

    if (Tex_Georama != nullptr && pos[0] >= -300.0f) {
        MenuReloadTexture(tex_block, Tex_Georama->block);
        mgCDrawPrim *prim = GetMenuPrim();
        SetSpriteEnv(prim, MENU_SPRITE_ENV_TEXTURE);
        mgRect<int> head_tex(0, 0x72, 0x164, 0x5E);
        mgRect<int> body_tex(0, 0xD0, 0x164, 0x40);
        mgRect<int> foot_tex(0, 0x110, 0x164, 0x22);
        mgRect<int> bar_tex(0x165, 0xEB, 6, 0x1C);
        prim->Begin(MG_PRIM_SPRITE);
        prim->Texture(Tex_Georama);
        prim->Color(0, 0, 0, alpha / 3);
        int shadow_x = static_cast<int>(3.0f + pos[0]);
        int shadow_y = static_cast<int>(3.0f + pos[1]);
        int body_y = shadow_y + head_tex.bottom;
        PrimQuad(prim, shadow_x, shadow_y, head_tex);
        PrimQuad(prim, mgRect<int>(shadow_x, body_y, body_tex.right, 0xB0), body_tex);
        PrimQuad(prim, mgRect<int>(shadow_x, static_cast<int>(176.0f + body_y), foot_tex.right, foot_tex.bottom), foot_tex);
        prim->Color(0x80, 0x80, 0x80, alpha);
        float top = pos[1];
        int   body_y2 = static_cast<int>(top + head_tex.bottom);
        PrimQuad(prim, pos[0], top, head_tex);
        PrimQuad(prim, mgRect<int>(static_cast<int>(pos[0]), body_y2, body_tex.right, 0xB0), body_tex);
        PrimQuad(prim, mgRect<int>(static_cast<int>(pos[0]), static_cast<int>(176.0f + body_y2), foot_tex.right, foot_tex.bottom), foot_tex);
        PrimQuad(prim, 329.0f + pos[0], GeoAnalyzeCheckPointScrlBarY, bar_tex);
        Menu3DivideTextureDraw(prim, mgRect<int>(static_cast<int>(57.0f + pos[0]), static_cast<int>(11.0f + pos[1]), 0x73, 0x15),
                               brdtbl_noneactive, 1);

        if (CMenuGeoPt->key_arg_no == 6) {
            prim->Color(0x80, 0x80, 0x80, alpha);
            Menu3DivideTextureDraw(prim, mgRect<int>(static_cast<int>(56.0f + pos[0]), static_cast<int>(11.0f + pos[1]), 0x73, 0x15),
                                   brdtbl, 1);
        }

        float check_x = {};
        float check_y = {};

        if (LanguageCode >= 2) {
            check_x = GeoRequestBoardCheckPoint_P[0];
            check_y = GeoRequestBoardCheckPoint_P[1];
        } else {
            check_x = offsettable[LanguageCode][0];
            check_y = offsettable[LanguageCode][1];
        }

        PrimQuad(prim, pos[0] + check_x, pos[1] + check_y,
                 mgRect<int>(static_cast<int>(GeoRequestBoardCheckPoint[0]), static_cast<int>(GeoRequestBoardCheckPoint[1]),
                             static_cast<int>(GeoRequestBoardCheckPoint[2]), static_cast<int>(GeoRequestBoardCheckPoint[3])));
        prim->End();
        float       clip_top = pos[1];
        float       left = pos[0];
        mgRect<int> clip(static_cast<int>(left), static_cast<int>(42.0f + clip_top), static_cast<int>(left + head_tex.right),
                         static_cast<int>(16.0f + (176.0f + (clip_top + head_tex.bottom))));
        MenuClipRectCheck(clip);
        SetMenuScissor(clip);
        prim->Bilinear(1);
        prim->Begin(MG_PRIM_SPRITE);
        prim->Texture(Tex_Georama);
        prim->Color(0x80, 0x80, 0x80, alpha);
        float list_pos[2] = {CMenuGeoPt->list_pos[GEORAMA_VIEW_ANALYZE][0], CMenuGeoPt->list_pos[GEORAMA_VIEW_ANALYZE][1]};
        int   first_hidden = -1;

        if (GeoRequestFlag != nullptr) {
            if (MenuEditAnalyzeSrc != nullptr) {
                int req_h = 0;
                int font_no = 0;
                int con_h = 0;

                for (int no = 0; no < EDIT_ANALYZE_DATA_MAX && MenuEditAnalyzeDataSrc[no] != nullptr &&
                                 font_no < static_cast<int>(std::size(GeoramaReqMsgFont));
                     no++) {
                    float y = list_pos[1] + req_h + con_h;
                    GeoramaReqMsgFont[font_no]->SetPos(static_cast<int>(4.0f + list_pos[0]), static_cast<int>(y));
                    GeoramaReqMsgFontDrawFlag[font_no] = 1;

                    if (mgScreenHeight < y && first_hidden < 0) {
                        first_hidden = font_no;
                    }

                    PrimQuad(prim, list_pos[0] - 19.0f, 17.0f + y, mgRect<int>(0x160, 0x132, 0x26, 0x1A));
                    short *button = maintopicbtn[GeoRequestFlag->met[no]];
                    float  btn_y = y - 9.0f;
                    PrimQuad(prim, list_pos[0] - 30.0f, btn_y, mgRect<int>(button[0], button[1], 0x1C, 0x26));
                    y += 30.0f;
                    req_h += GeoramaReqMsgTexH[font_no];
                    font_no++;

                    for (int con = 0; con < EDIT_ANALYZE_CON_NO_MAX &&
                                      MenuEditAnalyzeDataSrc[no]->con_no[con] >= 0 &&
                                      font_no < static_cast<int>(std::size(GeoramaReqMsgFont));
                         con++) {
                        const int condition = MenuEditAnalyzeDataSrc[no]->con_no[con];
                        if (condition >= EDIT_ANALYZE_CONDITION_MAX || MenuEditAnalyzeSrc->condition[condition] == nullptr) {
                            continue;
                        }
                        if (mgScreenWidth < y) {
                            break;
                        }

                        float text_x = 12.0f + list_pos[0];
                        int   box_h = {};

                        if (GeoramaReqMsgFontGyouNum[font_no] == 2) {
                            Menu3DivideTextureDraw(prim, mgRect<int>(static_cast<int>(text_x - 20.0f), static_cast<int>(y - 4.0f), 0x116, 0x38),
                                                   rectboxtbl, 1);
                            box_h = 0x36;
                        } else {
                            Menu3DivideTextureDraw(prim, mgRect<int>(static_cast<int>(text_x - 20.0f), static_cast<int>(y - 4.0f), 0x116, 0x20),
                                                   rectboxtbl, 1);
                            box_h = 0x1E;
                        }

                        int mark_x = static_cast<int>(text_x - 14.0f);
                        int mark_y = static_cast<int>(4.0f + y);
                        PrimQuad(prim, mark_x, mark_y, potti1);

                        if (GeoRequestFlag->con_flag[no][con] != 0) {
                            PrimQuad(prim, mark_x, mark_y, potti0);
                        }

                        GeoramaReqMsgFont[font_no]->SetPos(static_cast<int>(text_x), static_cast<int>(1.0f + y));
                        GeoramaReqMsgFontDrawFlag[font_no] = 1;

                        if (1.0f + y < 80.0f) {
                            GeoramaReqMsgFontDrawFlag[font_no] = 0;
                        }

                        con_h += GeoramaReqMsgTexH[font_no];
                        font_no++;
                        y += box_h;
                    }
                }
            }

            prim->End();

            if (CMenuGeoPt->list_pos[GEORAMA_VIEW_ANALYZE][0] < mgScreenWidth) {
                MenuReloadTexture(tex_block, MenuArg.mes_tex_block);

                for (int i = 0; i < static_cast<int>(std::size(GeoramaReqMsgFont)) && GeoramaReqMsgFont[i] != nullptr; i++) {
                    if (0 <= first_hidden && first_hidden < i) {
                        break;
                    }

                    if (GeoramaReqMsgFontDrawFlag[i] != 0) {
                        GeoramaReqMsgFont[i]->alpha = alpha;
                        GeoramaReqMsgFont[i]->DrawDirect(GeoramaReqMsgFont[i]->str, GeoramaReqMsgFont[i]->pos_x,
                                                         GeoramaReqMsgFont[i]->pos_y);
                    }
                }
            }

            ResetMenuScissor();
        }
    }
}

void InitDownLoadAnaunce(mgCMemory *stack) {
    const auto msg_buf = GetMenuMainMessageBuffer();

    DownLoadActiveMes = nullptr;
    DownLoadMesAlpha = 0x80;
    DownLoadMesUpY = 0;
    DownLoadMesMakeNo = 0;
    DownLoadProgress = 0;
    DrawDownLoadAnaunceSwitch(0);
    DownLoadInfoEndFlag = 0;

    for (int i = 0; i < 6; i++) {
        if (stack == nullptr) {
            DownLoadMes[i] = nullptr;
        } else {
            DownLoadMes[i] = dc2::memory::NewObject<CDC2Mes>(*stack);
            if (DownLoadMes[i] == nullptr) {
                std::exit(EXIT_FAILURE);
            }
            DownLoadMes[i]->SetMessData(GetSystemMesBuffer(), msg_buf);
            DownLoadMes[i]->MsgPreset(0x10);
            DownLoadMes[i]->draw_speed = 1.7f;
            DownLoadMes[i]->draw_speed_def = 1.7f;
            DownLoadMes[i]->push_button = 1;
        }
    }

    if (stack != nullptr) {
        GeoRequestFlag = new (stack->Alloc(0x46)) GeoRequestCheck;
        DownLoadInfoEndFlag = 1;
    }

    DownLoadWinRect.w = 0x1E2;
    DownLoadWinRect.h = 0x84;
    DownLoadWinRect.x = (mgScreenWidth - DownLoadWinRect.w) >> 1;
    DownLoadWinRect.y = (mgScreenHeight - DownLoadWinRect.h) >> 1;
}

void DrawDownLoadAnaunceSwitch(int value) {
    DownLoadInfoDrawFlag = value;
}

int StepDownLoadAnaunce(int confirm) {
    int   advance = {};
    int   unk_24 = {};
    int   growing = {};
    int   i = {};
    float grow_speed = {};
    int   state = {};

    if (MenuGeoStoneDownLoad_Request + MenuGeoStoneDownLoad_PartsNum <= 0) {
        return 1;
    }

    advance = 0;

    if (DownLoadInfoEndFlag == 0) {
        return 1;
    }

    if (confirm != 0) {
        advance = 1;
    }

    unk_24 = 0;
    growing = 0;

    if (DownLoadMesMakeProgress == 0 && advance != 0) {
        if (DownLoadInfoNext == nullptr) {
            MenuSePlay(SYSTEM_SE_MESSAGE);
            DownLoadInfoEndFlag = 0;
            return 1;
        }

        DownLoadMesMakeProgress = 1;
        DownLoadActiveMes->push_button = 0;
        MenuSePlay(SYSTEM_SE_MESSAGE);
    }

    if (DownLoadMesMakeProgress == 1) {
        if (DownLoadProgress > 3) {
            unk_24 = 1;
        } else {
            DownLoadMesMakeProgress = 2;
        }
    }

    if (DownLoadMesMakeProgress == 3) {
        growing = 1;
    }

    grow_speed = 0.5f;

    if (static_cast<float>(mgFrameRate) != 1.0f) {
        grow_speed = 1.0f;
    }

    for (i = 0; i < 8; i++) {
        if (DownLoadMes[i] != nullptr) {
            if (unk_24 != 0) {
                DownLoadMes[i]->abs_win.y -= 2;

                if (DownLoadMesScrlGyouNum == 2) {
                    DownLoadMes[i]->abs_win.y -= 2;
                }
            }

            if (i == DownLoadMesMakeNo && growing != 0) {
                DownLoadMes[i]->draw_speed += grow_speed;
            }

            DownLoadMes[i]->Step();
        }
    }

    if (DownLoadMesMakeProgress == 1 && DownLoadProgress > 2) {
        if (DownLoadMesScrlGyouNum == 2) {
            DownLoadMesUpY += 4;

            if (DownLoadMesUpY >= 0x30) {
                DownLoadMesMakeProgress = 2;
                DownLoadMesUpY = 0;
            }
        } else {
            DownLoadMesUpY += 2;

            if (DownLoadMesUpY >= 0x18) {
                DownLoadMesMakeProgress = 2;
                DownLoadMesUpY = 0;
            }
        }
    }

    if (DownLoadMesMakeProgress == 2) {
        int line = {};
        DownLoadActiveMes = DownLoadMes[DownLoadMesMakeNo];
        DownLoadActiveMes->State();
        DownLoadActiveMes->mes_no = -1;
        DownLoadActiveMes->draw_speed_def = 1.8f;
        DownLoadActiveMes->abs_win.x = DownLoadWinRect.x + 0x14;
        line = DownLoadProgress;

        if (line > 3) {
            line = 3;
        }

        if (DownLoadMesScrlGyouNum > 1 && line == 3) {
            line -= DownLoadMesScrlGyouNum - 1;
        }

        DownLoadActiveMes->abs_win.y = DownLoadWinRect.y + 0x16 + line * 0x18;

        if (DownLoadInfoNext->kind == 0) {
            char   *name = DownLoadInfoNext->name;
            ClsMes *target = DownLoadActiveMes;

            if (name != nullptr) {
                dc2::text::Copy(target->name[0], dc2::text::View(name));
            }

            DownLoadActiveMes->MakeMesWin(0x67C);
        }

        if (DownLoadInfoNext->kind == 1) {
            char   *name = DownLoadInfoNext->name;
            ClsMes *target = DownLoadActiveMes;

            if (name != nullptr) {
                dc2::text::Copy(target->name[0], dc2::text::View(name));
            }

            DownLoadActiveMes->MakeMesWin(0x67D);

            if (DownLoadInfoNext->has_extra == 1) {
                DownLoadActiveMes->MakeMesWin(0x680);
            }
        }

        DownLoadProgress++;
        DownLoadMesMakeNo++;

        if (DownLoadMesMakeNo > 5) {
            DownLoadMesMakeNo = 0;
        }

        DownLoadInfoNext = DownLoadInfoNext->next;
        DownLoadMesScrlGyouNum = 1;

        if (DownLoadInfoNext != nullptr) {
            if (DownLoadInfoNext->kind == 1 && LanguageCode > 0) {
                DownLoadMesScrlGyouNum = 2;
                DownLoadProgress++;
            }
        }

        DownLoadMesMakeProgress = 3;
    }

    if (DownLoadMesMakeProgress == 3) {
        state = DownLoadActiveMes->State();

        if (state == CLSMES_SHOWN || state == CLSMES_PAGE_WAIT) {
            DownLoadMesMakeProgress = 0;
            DownLoadActiveMes->push_button = 1;
        }
    }

    return 0;
}

void DrawDownLoadAnaunce() {
    if (DownLoadMes[0] != nullptr && DownLoadInfoDrawFlag != 0) {
        mgCTextureManager *tex_manager = &mgTexManager;
        mgCTexture        *tex = tex_manager->GetTexture("gaiji", -1);

        if (tex != nullptr) {
            tex_manager->ReloadTexture(tex->block, (sceVif1Packet *) nullptr);
            mgCDrawPrim prim;
            RECT        win = {DownLoadWinRect.x, DownLoadWinRect.y, DownLoadWinRect.w, DownLoadWinRect.h};
            RECT        shadow = {DownLoadWinRect.x + 5, DownLoadWinRect.y + 5, DownLoadWinRect.w, DownLoadWinRect.h};
            RGBAQ_TYPE  frame_color = {0x80, 0x80, 0x80, DownLoadMesAlpha, 0};
            RGBAQ_TYPE  shadow_color = {0, 0, 0, DownLoadMesAlpha >> 2, 0};
            SetSpriteEnv(&prim, MENU_SPRITE_ENV_TEXTURE);
            DrawVersatileWin_1(&prim, shadow, &shadow_color, shadow_color.a);
            DrawMenuFillBox(&prim, shadow.x, shadow.y, shadow.width - 10, shadow.height - 10, 0x40, 0, 0, 0);
            DrawVersatileWin_1(&prim, win, &frame_color, frame_color.a);
            mgRect<int> clip(win.x, win.y + 0x11, win.x + win.width, win.y + win.height);
            MenuClipRectCheck(clip);
            SetMenuScissor(clip);

            for (int i = 0; i < 8; i++) {
                if (DownLoadMes[i] != nullptr) {
                    DownLoadMes[i]->alpha = DownLoadMesAlpha;
                    DownLoadMes[i]->Step();
                    DownLoadMes[i]->DrawMesWin();
                }
            }

            ResetMenuScissor();
        }
    }
}

int MakeDownLoadAnaunce(int town_no, mgCMemory *stack, int *out_num, int *out_sub_num, int *out_height) {
    int              *ok_table = {};
    int               valid = {};
    int               map_no = {};
    CSaveData        *save = {};
    int               floor_num = {};
    int               count = {};
    int               n = {};
    char             *dst_char = {};
    char             *hatena = {};
    int               request_num = {};
    int               condition_num = {};
    int               no = {};
    int               height = {};
    int               limit = {};
    int               con = {};
    char             *condition_name = {};
    int               size = {};
    CScene           *scene = {};
    int               condition = {};
    CSaveDataDungeon *dungeon = {};
    int               total = {};
    CEditInfoMngr    *info = {};
    char             *word = {};
    int               geo_floor = {};
    CEditData        *edit = {};
    int               font_no = {};
    short             floors[0x180][2];
    char             *names[0x180];
    signed char       extras[0x180];
    u_long128         load_buffer[0x780];
    char              file_name[0x40];
    char              text[0x80];
    char              conv_text[0x80];
    valid = 1;
    map_no = town_no;

    if (town_no < 0 || town_no > 4) {
        map_no = 0;
        valid = 0;
    }

    save = GetSaveData();

    if (save == nullptr) {
        return 0;
    }

    edit = save->GetEditData(map_no);

    if (edit == nullptr) {
        return 0;
    }

    MenuEditAnalyzeSrc = edit->GetAnalyzeSrc(map_no);
    MenuEditAnalyzeDataSrcNum = 0;

    for (no = 0; no < static_cast<int>(std::size(MenuEditAnalyzeDataSrc)); no++) {
        MenuEditAnalyzeDataSrc[no] = edit->GetAnalyzeData(map_no, no);
    }

    for (n = 0; n < EDIT_ANALYZE_DATA_MAX && MenuEditAnalyzeDataSrc[n] != nullptr; n++) {
        GeoRequestFlag->met[n] =
            edit->GetAnalyzeFlag(map_no, n, GeoRequestFlag->con_no[n], GeoRequestFlag->con_flag[n]);
    }

    analyze_percent = edit->GetAnalyzePercent(map_no);
    MenuAnalyzeData = &edit->analyze;
    MenuGeoStoneDownLoad_PartsNum = 0;
    dungeon = &save->save_dungeon;
    floor_num = 0;
    MenuGeoStoneDownLoad_Request = 0;
    memset(floors, 0, sizeof(floors));
    PartsMakeOkTableNum = 0;
    ok_table = PartsMakeOkTable;
    hatena = GetHatena();
    scene = GetMainScene();
    if (scene == nullptr) {
        return 0;
    }
    CEditMap *map = static_cast<CEditMap *>(scene->GetMap(scene->active_map));
    if (map == nullptr) {
        return 0;
    }
    info = &map->info_mngr;

    if (valid == 0) {
        if ((info = dc2::memory::NewObject<CEditInfoMngr>(*stack)) != nullptr) {
            info->Initialize();
        }

        if (info != nullptr) {
            char *script = reinterpret_cast<char *>(MenuCalcBufAlignment(load_buffer));
            std::snprintf(file_name, sizeof(file_name), "map/g/g01/g01%d.gpi", LanguageCode);

            if (LoadFile2(file_name, std::span(reinterpret_cast<u8 *>(script), sizeof load_buffer - static_cast<std::size_t>(script - reinterpret_cast<char *>(load_buffer))), &size, 0) != 0) {
                info->LoadEditInfo(script, size, stack);
            } else {
                info = nullptr;
            }
        }
    }

    if (info == nullptr) {
        return 0;
    }

    for (no = 0; no < GEORAMA_PARTS_LIST_MAX; no++) {
        CEditPartsInfo *parts = info->GetePartsInfo(no);

        if (parts == nullptr) {
            break;
        }

        if (0 < parts->geo_stone) {
            int             dungeon_no = parts->geo_stone / 100;
            int             floor_no = parts->geo_stone % 100;
            DNG_FLOOR_SAVE *floor = dungeon->GetFloorInfoPtr(dungeon_no, floor_no);

            if (floor != nullptr) {
                if (!(floor->flag & DNG_FLOOR_FLAG_GEOSTONE_FOUND)) {
                    PartsMakeOkTableNum++;
                    ok_table[PartsMakeOkTableNum] = parts->id;
                    PartsMakeOkTableNum++;
                } else if (!(floor->flag & DNG_FLOOR_FLAG_GEOSTONE_READ)) {
                    names[MenuGeoStoneDownLoad_PartsNum] = parts->edit_name;
                    extras[MenuGeoStoneDownLoad_PartsNum] = 0;
                    MenuGeoStoneDownLoad_PartsNum++;
                    floors[floor_num][0] = dungeon_no;
                    floors[floor_num][1] = floor_no;
                    floor_num++;
                }
            }
        }
    }

    for (no = 0; no < 48; no++) {
        GeoramaReqMsgFont[no] = nullptr;
        GeoramaReqMsgFontGyouNum[no] = 0;
        GeoramaReqMsgTexH[no] = 0;
        GeoramaReqMsgFontDrawFlag[no] = 1;
    }

    request_num = 0;
    font_no = 0;
    condition_num = 0;
    height = 0;

    for (no = 0; no < EDIT_ANALYZE_DATA_MAX && font_no < static_cast<int>(std::size(GeoramaReqMsgFont)); no++) {
        if (MenuEditAnalyzeDataSrc[no] == nullptr) {
            continue;
        }

        EditAnalyzeDataSrc *src = MenuEditAnalyzeDataSrc[no];
        MenuEditAnalyzeDataSrcNum++;

        if (src->message != nullptr) {
            GeoramaReqMsgFont[font_no] = new (stack->Alloc(0xE)) CMenuFont;
            GeoramaReqMsgFontGyouNum[font_no] = 1;
            GeoramaReqMsgTexH[font_no] = 0x1E;
            short *tex_h = &GeoramaReqMsgTexH[font_no];
            CFont *font = GeoramaReqMsgFont[font_no];
            font->SetFuchi(5);
            geo_floor = src->geo_floor;
            int known = 0;

            if (geo_floor <= 0) {
                MenuAnalyzeData->data_open[no] = 1;
            } else {
                int             dungeon_no = geo_floor / 100;
                int             floor_no = geo_floor % 100;
                DNG_FLOOR_SAVE *floor = dungeon->GetFloorInfoPtr(dungeon_no, floor_no);
                int             was_open = MenuAnalyzeData->data_open[no];

                if (floor != nullptr && (floor->flag & DNG_FLOOR_FLAG_GEOSTONE_FOUND)) {
                    known = 1;
                    MenuAnalyzeData->data_open[no] = 1;
                    floors[floor_num][0] = dungeon_no;
                    floors[floor_num][1] = floor_no;
                    floor_num++;
                }

                if (was_open != MenuAnalyzeData->data_open[no]) {
                    names[MenuGeoStoneDownLoad_PartsNum + MenuGeoStoneDownLoad_Request] = src->message;
                    extras[MenuGeoStoneDownLoad_PartsNum + MenuGeoStoneDownLoad_Request] = 0;
                    MenuGeoStoneDownLoad_Request++;
                }
            }

            font->SetStr(src->message);

            if (geo_floor > 0 && known == 0) {
                font->SetStr(hatena);
            }

            font_no++;
            request_num++;
            height += *tex_h;
        }

        for (con = 0; con < EDIT_ANALYZE_CON_NO_MAX && src->con_no[con] >= 0 &&
                      font_no < static_cast<int>(std::size(GeoramaReqMsgFont));
             condition_num++, con++) {
            condition = src->con_no[con];
            if (condition >= EDIT_ANALYZE_CONDITION_MAX) {
                continue;
            }
            condition_name = MenuEditAnalyzeSrc->condition[condition];

            if (condition_name == nullptr) {
                continue;
            }

            GeoramaReqMsgFont[font_no] = new (stack->Alloc(0xE)) CMenuFont;
            CFont *font = GeoramaReqMsgFont[font_no];
            font->SetFuchi(5);
            geo_floor = MenuEditAnalyzeSrc->geo_floor[condition];
            int known = 0;

            if (geo_floor <= 0) {
                MenuAnalyzeData->condition_open[condition] = 1;
            } else {
                int             dungeon_no = geo_floor / 100;
                int             floor_no = geo_floor % 100;
                DNG_FLOOR_SAVE *floor = dungeon->GetFloorInfoPtr(dungeon_no, floor_no);
                int             was_open = MenuAnalyzeData->condition_open[condition];

                if (floor != nullptr && (floor->flag & DNG_FLOOR_FLAG_GEOSTONE_FOUND)) {
                    known = 1;
                    MenuAnalyzeData->condition_open[condition] = 1;
                    floors[floor_num][0] = dungeon_no;
                    floors[floor_num][1] = floor_no;
                    floor_num++;
                }

                if (was_open != MenuAnalyzeData->condition_open[condition]) {
                    names[MenuGeoStoneDownLoad_PartsNum + MenuGeoStoneDownLoad_Request] = condition_name;
                    extras[MenuGeoStoneDownLoad_PartsNum + MenuGeoStoneDownLoad_Request] = 0;

                    if (town_no == 4) {
                        extras[MenuGeoStoneDownLoad_PartsNum + MenuGeoStoneDownLoad_Request] = 1;
                    }

                    MenuGeoStoneDownLoad_Request++;
                }
            }

            GeoramaReqMsgFontGyouNum[font_no] = 1;
            GeoramaReqMsgTexH[font_no] = 0x1E;
            signed char *lines = &GeoramaReqMsgFontGyouNum[font_no];
            short       *tex_h = &GeoramaReqMsgTexH[font_no];
            char         wrapped[sizeof(conv_text)]{};
            snprintf(text, sizeof(text), "%s", condition_name);
            ConvertFontCode(text, conv_text);
            std::memcpy(wrapped, conv_text, std::strlen(conv_text) + 1);
            char *src_char = conv_text;

            if (LanguageCode > 0) {
                limit = 10;
                count = 0;
                dst_char = wrapped;

                while (*src_char != '\0') {
                    count++;
                    *dst_char = *src_char;
                    src_char++;
                    dst_char++;

                    if (count > 20 && *src_char == ' ') {
                        word = src_char + 1;
                        int word_len = 0;

                        if (word != nullptr) {
                            while (word != nullptr && *word != ' ' && *word != '\0') {
                                word_len++;
                                word++;
                            }
                        }

                        if (word_len >= limit) {
                            *dst_char = '\n';
                            src_char++;
                            (*lines)++;
                            dst_char++;
                            count = 0;
                            *tex_h = 0x36;
                        }

                        limit--;
                    }
                }

                *dst_char = '\0';
            }

            font->SetColor(0x78, 0x76, 0x66, 0x80);
            font->SetStr(wrapped);

            if (geo_floor > 0 && known == 0) {
                font->SetStr(hatena);
                *lines = 1;
                *tex_h = 0x1E;
            }

            font_no++;
            height += *tex_h;
        }
    }

    if (map_no == 0 && MenuAnalyzeData->condition_open[5] != 0) {
        save->SetBitFlag(0x21, 1);
    }

    for (no = 0; no < floor_num; no++) {
        DNG_FLOOR_SAVE *floor = dungeon->GetFloorInfoPtr(floors[no][0], floors[no][1]);

        if (floor != nullptr) {
            floor->flag |= DNG_FLOOR_FLAG_GEOSTONE_READ;
        }
    }

    total = MenuGeoStoneDownLoad_Request + MenuGeoStoneDownLoad_PartsNum;
    DownLoadInfo = nullptr;
    DownLoadInfoNext = nullptr;
    MenuGeoStoneDmyCnt_Now = nullptr;
    MenuGeoStoneDmyCnt = nullptr;
    MenuGeoStoneDownLoadTime = 0;

    if (0 < total) {
        DownLoadDispNum = total;
        DownLoadInfo = new (stack->Alloc(3)) DownLoadEntry;
        DownLoadEntry *entry = DownLoadInfo;
        DownLoadEntry *last = nullptr;

        for (int no = 0; no < total; no++) {
            if (last != nullptr) {
                entry->next = new (stack->Alloc(3)) DownLoadEntry;
                entry = entry->next;
            }

            if (no < MenuGeoStoneDownLoad_PartsNum) {
                entry->kind = 0;
            } else {
                entry->kind = 1;
            }

            entry->name = names[no];
            entry->has_extra = extras[no];
            last = entry;
        }

        DownLoadInfoNext = DownLoadInfo;
        MenuGeoStoneDownLoadTime = 0;
        MenuGeoStoneDmyCnt = new (stack->Alloc(3)) GeoStoneDmyCnt;
        GeoStoneDmyCnt *count = MenuGeoStoneDmyCnt;
        GeoStoneDmyCnt *last_count = nullptr;
        float           rate = mgFrameRate;
        int             speed = 1;

        if (rate != 1.0f) {
            speed = 2;
        }

        for (no = 0; no < total; no++) {
            if (last_count != nullptr) {
                count->next = new (stack->Alloc(3)) GeoStoneDmyCnt;
                count = count->next;
            }

            if (no < MenuGeoStoneDownLoad_PartsNum) {
                count->frames = (GetRandI(0x1F) - 8) / speed;
                count->step = 10 / speed;
                count->remaining_steps = (GetRandI(0x15) + 10) / speed;
            } else {
                count->frames = GetRandI(0xB) - 2;
                count->step = 14 / speed;
                count->remaining_steps = (GetRandI(10) + 10) / speed;
            }

            MenuGeoStoneDownLoadTime += count->step * count->remaining_steps;
            last_count = count;
        }

        MenuGeoStoneDmyCnt_Now = MenuGeoStoneDmyCnt;
    }

    if (out_num != nullptr) {
        *out_num = request_num;
    }

    if (out_sub_num != nullptr) {
        *out_sub_num = condition_num;
    }

    if (out_height != nullptr) {
        *out_height = height;
    }

    if (valid == 0) {
        DownLoadMesMakeProgress = 2;
    }

    return 0;
}

void InitMenuDl3(mgCTexture *texture) {
    InitMenuDl(texture, MenuGeoStoneDownLoadTime);
}

int StepMenuDl3() {
    int step = {};

    if (static_cast<int>(MenuGeoStoneDownLoadTime) <= 0) {
        return 1;
    }

    step = 0;

    if (MenuGeoStoneDmyCnt_Now != nullptr) {
        MenuGeoStoneDmyCnt_Now->frames--;

        if (MenuGeoStoneDmyCnt_Now->frames <= 0) {
            step = MenuGeoStoneDmyCnt_Now->step;
            MenuGeoStoneDmyCnt_Now->remaining_steps--;

            if (MenuGeoStoneDmyCnt_Now->remaining_steps <= 0) {
                MenuGeoStoneDmyCnt_Now = MenuGeoStoneDmyCnt_Now->next;
            }
        }
    }

    return StepMenuDl(step);
}

void MenuPlacedHouseDraw(int &tex_block) {
    static short postbl[8][4] = {
        {364, 674, 60,  18},
        {280, 674, 100, 18},
        {278, 674, 104, 18},
        {280, 674, 100, 18},
        {278, 674, 102, 18},
        {280, 674, 98,  18},
        {364, 674, 60,  18},
        {364, 674, 60,  18},
    };
    static short offset[7] = {
        82,
        62,
        62,
        62,
        64,
        64,
        62,
    };
    static short jyunintbl[2][4] = {
        {466, 692, 32, 18},
        {400, 606, 32, 20},
    };
    int   pos[2];
    float cursor_pos[2];
    int   text_h = {};
    int   text_w = {};
    int   i = {};

    if (HouseInfoFormGrobal != nullptr && Tex_Georama != nullptr) {
        HouseInfoFormGrobal->GetPutPosXY(nullptr, pos[0], pos[1]);

        if (pos[0] < 0x209) {
            MenuReloadTexture(tex_block, Tex_Georama->block);
            mgCDrawPrim *prim = GetMenuPrim();
            SetSpriteEnv(prim, MENU_SPRITE_ENV_TEXTURE);
            prim->Begin(MG_PRIM_SPRITE);
            prim->Texture(Tex_Georama);
            int alpha = HouseInfoFormGrobal->rgba[3];
            int shadow_x = pos[0] + 4;
            int shadow_y = pos[1] + 4;
            prim->Color(0, 0, 0, alpha / 3);
            mgRect<int> shadow(shadow_x, shadow_y, 0x24, 0xE0);
            PrimQuad(prim, shadow, mgRect<int>(0xF2, 0x132, 0x24, 0xE0));
            shadow.left += 0x24;
            shadow.right = 0xA0;
            PrimQuad(prim, shadow, mgRect<int>(0x116, 0x132, 0x24, 0xE0));
            shadow.right = 0x24;
            shadow.left += 0xA0;
            PrimQuad(prim, shadow, mgRect<int>(0x13A, 0x132, 0x24, 0xE0));
            prim->Color(0x80, 0x80, 0x80, alpha);
            mgRect<int> frame(pos[0], pos[1], 0x24, 0xE0);
            PrimQuad(prim, frame, mgRect<int>(0xF2, 0x132, 0x24, 0xE0));
            frame.left += 0x24;
            frame.right = 0xA0;
            PrimQuad(prim, frame, mgRect<int>(0x116, 0x132, 0x24, 0xE0));
            frame.left += 0xA0;
            frame.right = 0x24;
            PrimQuad(prim, frame, mgRect<int>(0x13A, 0x132, 0x24, 0xE0));
            short *title = postbl[LanguageCode];
            int    title_x = pos[0] + offset[LanguageCode];
            prim->Color(0x80, 0x80, 0x80, alpha);
            PrimQuad(prim, mgRect<int>(title_x, pos[1] + 0xE, title[2], title[3]),
                     mgRect<int>(title[0], title[1], title[2], title[3]));
            int blink_alpha = alpha;

            static signed char cnt = 0;

            cnt++;

            if (cnt > 50 || HouseInfoCursorAlphaOnOff == 0) {
                blink_alpha = 0;
            }

            if (cnt >= 80) {
                cnt = 0;
            }

            int         blink_up_y = pos[1] + 0x30;
            int         blink_down_y = pos[1] + 0xAE;
            int         blink_x = pos[0] + 0xC8;
            mgRect<int> blink_up_tex(0x15E, 0x1E2, 0x18, 0x12);
            mgRect<int> blink_down_tex(0x15E, 0x1F4, 0x18, 0x12);
            prim->Color(0x80, 0x80, 0x80, blink_alpha);
            PrimQuad(prim, mgRect<int>(blink_x, blink_up_y, 0x10, 0x10), blink_up_tex);
            PrimQuad(prim, mgRect<int>(blink_x, blink_down_y, 0x10, 0x10), blink_down_tex);
            prim->End();
            int cursor_alpha = HouseInfoCursorAlpha;
            cursor_pos[0] = pos[0] - 0x12;
            cursor_pos[1] = pos[1] + 0x2C + HouseInfoCursorY;
            mgCTexture *cursor_tex = mgTexManager.GetTexture("mnmain", -1);

            if (cursor_tex != nullptr) {
                MenuReloadTexture(tex_block, cursor_tex->block);
                MenuCursorDraw(cursor_tex, cursor_pos, 0.0f, 0, cursor_alpha, 1.0f);
            }

            mgRect<int> clip(pos[0], pos[1] + 0x2E, pos[0] + 0xCE, pos[1] + 0xD4);
            MenuClipRectCheck(clip);
            SetMenuScissor(clip);
            int         number_x = pos[0] + 0x1A;
            int         line_y = pos[1] + 0x2C + HouseInfoSelectY;
            mgRect<int> line_tex(0, 0x229, 0xC0, 6);
            mgRect<int> line_rect(pos[0] + 0x18, line_y + 0x14, 0xCC, 6);
            SetSpriteEnv(prim, MENU_SPRITE_ENV_TEXTURE);
            prim->Begin(MG_PRIM_SPRITE);
            prim->Texture(Tex_Georama);
            prim->Color(0x80, 0x80, 0x80, alpha);
            PrimQuad(prim, line_rect, line_tex);
            int lang = LanguageCode;

            if (lang > 0) {
                lang = 1;
            }

            short      *mark = jyunintbl[lang];
            mgRect<int> number_rect(number_x - 5, line_y + 0x19, mark[2], mark[3]);
            prim->Color(0x80, 0x80, 0x80, alpha);
            PrimQuad(prim, number_rect, mgRect<int>(mark[0], mark[1], mark[2], mark[3]));
            number_rect.left = number_x;
            number_rect.right = 0x14;
            number_rect.bottom = 0x14;
            number_rect.top += 0x18;
            line_rect.top += 0x18;
            mgRect<int> number_tex(0, 0x25E, 0x14, 0x14);
            prim->Color(0x80, 0x80, 0x80, alpha);

            for (i = 0; i < 22; i++) {
                PrimQuad(prim, number_rect, number_tex);
                PrimQuad(prim, line_rect, line_tex);
                number_rect.top += 0x18;
                line_rect.top += 0x18;
                number_tex.left += 0x14;
            }

            prim->End();
            MenuReloadTexture(tex_block, MenuArg.mes_tex_block);
            CMenuFont font;
            int       text_x = pos[0] + 0x1A;
            int       text_y = pos[1] + 0x2D + HouseInfoSelectY;

            if (text_x < 0x200) {
                font.alpha = alpha;
                font.SetStr(HouseChildPartInfo[0]);
                font.CalcDrawWH(font.str, &text_w, &text_h);
                text_x = pos[0] + 0x6E - (text_w >> 1);
                font.SetStr(HouseChildPartInfo[0]);
                font.SetPos(text_x, text_y);
                font.DrawDirect(font.str, font.pos_x, font.pos_y);
                text_y += 0x18;
                text_x = pos[0] + 0x34;

                for (int line = 1; line < 22; line++) {
                    font.SetStr(HouseChildPartInfo[line]);
                    font.SetPos(text_x, text_y);
                    font.DrawDirect(font.str, font.pos_x, font.pos_y);
                    text_y += 0x18;
                }
            }

            ResetMenuScissor();

            if (HouseInfoCursorAlphaOnOff == 0) {
                CalcMenuAdd(&HouseInfoCursorAlpha, -0xE, 0);
            } else {
                CalcMenuAdd(&HouseInfoCursorAlpha, 0xE, 0x80);
            }

            int         arrow_alpha = HouseInfoCursorAlpha;
            int         arrow_shadow_alpha = arrow_alpha / 3;
            int         arrow_x = pos[0] + 0xD2;
            int         arrow_up_y = pos[1] + 0x1E;
            int         arrow_down_y = pos[1] + 0xBE;
            mgRect<int> arrow_up_tex(0x20, 0x84, 0x20, 0x17);
            mgRect<int> arrow_down_tex(0x40, 0x84, 0x20, 0x17);
            mgCTexture *arrow = mgTexManager.GetTexture("gaiji", -1);
            SetSpriteEnv(prim, MENU_SPRITE_ENV_TEXTURE);
            prim->Begin(MG_PRIM_SPRITE);
            prim->Texture(arrow);
            prim->Color(0, 0, 0, arrow_shadow_alpha);
            PrimQuad(prim, mgRect<int>(arrow_x + 4, arrow_up_y + 4, 0x1E, 0x14), arrow_up_tex);
            PrimQuad(prim, mgRect<int>(arrow_x + 4, arrow_down_y + 4, 0x1E, 0x14), arrow_down_tex);
            prim->Color(0x80, 0x80, 0x80, arrow_alpha);
            PrimQuad(prim, mgRect<int>(arrow_x, arrow_up_y, 0x1E, 0x14), arrow_up_tex);
            PrimQuad(prim, mgRect<int>(arrow_x, arrow_down_y, 0x1E, 0x14), arrow_down_tex);
            prim->End();
        }
    }
}

/**
 *
 * Builds the displayed names of a placed house and its residents.
 *
 */
void MenuPlacedHouseMessMake(CEditPartsInfo *info, CEditHouse *house, int update) {
    if (update == 0 || info == nullptr) {
        return;
    }

    static char *Dmy = " ";

    for (int i = 0; i < 22; i++) {
        HouseChildPartInfo[i] = Dmy;
    }

    HouseChildPartInfo[0] = info->edit_name;

    if (info->GetPartsType() == -1) {
        HouseChildPartInfo[0] = Dmy;
    }

    if (info->attr & EDIT_PARTS_ATR_NO_REFUND) {
        HouseChildPartInfo[0] = Dmy;
    }

    int child_no[21] = {-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
                        -1, -1, -1, -1, -1, -1, -1, -1, -1, -1};
    MenuMainMapInfo->GetChildParts(HousePartsID, child_no, 15);
    int child_num = 0;

    for (int i = 0; i < 20; i++) {
        if (0 < child_no[i]) {
            CEditParts *child = MenuMainMapInfo->GetePlaceParts(child_no[i]);

            if (child != nullptr && child->info != nullptr && !(child->info->attr & EDIT_PARTS_ATR_NO_REFUND)) {
                HouseChildPartInfo[2 + child_num++] = child->info->edit_name;
            }
        }
    }

    if (house != nullptr && GetNPCName(house->npc_no[0]) != nullptr) {
        HouseChildPartInfo[1] = GetNPCName(house->npc_no[0]);
    }
}

/**
 *
 * Moves the placed-house list and cursor toward their selected positions.
 *
 */
void MenuPlacedHousePosLinkMes() {
    CalcMenu1(-HouseInfoSelectLine * 24, &HouseInfoSelectY, 3, 3, HouseInfoSelectMoveInit);
    CalcMenu1((HouseInfoSelectSelect - HouseInfoSelectLine) * 24, &HouseInfoCursorY, 3, 0,
              HouseInfoSelectMoveInit);
    HouseInfoSelectMoveInit = 0;
}

void MenuMapPartsDraw(int &draw_wait) {
    int        draw_list[65];
    int        blocks[128];
    mgCMemory *stack = {};
    int        set_no = {};
    int        n = {};

    if (MenuMapPart != nullptr && GeoramaParts_DrawWaitCnt >= 0 &&
        (stack = MenuPartsDrawStack) != nullptr) {
        stack->stClearUsed();
        stack->stSetLocked(false);

        for (int i = 0; i < 64; i++) {
            draw_list[i] = i;
        }

        draw_list[64] = -1;
        mgBeginDraw(MenuPartsDrawStack, draw_list, nullptr);
        MenuMapPart->Draw();
        mgPreEndDraw(nullptr);

        for (set_no = 0; set_no < 16; set_no++) {
            int count = MenuMainScene->mds_list_set.GetTextureBlockNo(set_no, blocks, 0x80);

            for (n = 0; n < count; n++) {
                int *top = &blocks[count - n - 1];
                int  block = *top;
                mgEndDrawReloadTexture(block, nullptr);
                mgEndDraw(block, nullptr);
            }
        }

        draw_wait = -1;
    }
}

void MenuGeoramaMessageMake(int mode) {
    static short constant_msg_xyoffsettbl[5][4] = {
        {40, 258, 40, 282},
        {40, 258, 40, 282},
        {54, 267, 0,  0  },
        {40, 261, 40, 285},
        {54, 267, 0,  0  },
    };
    int first_line = {};
    int force_pos = GeoramaMesPosForceSetFlag;
    int k = {};
    GeoramaMesPosForceSetFlag = 0;

    for (int list_no = 0; list_no < GEORAMA_VIEW_MODE_NUM; list_no++) {
        int data_no = ConvGeoramaDataNo(list_no);

        if (data_no < 0) {
            continue;
        }

        int top_line[2] = {CMenuGeoPt->list_info[list_no].top, CMenuGeoPt->list_info[list_no].top - 1};
        GeoramaMesMakeLine[data_no] = top_line[GeoramaMesMakeManner[data_no]];
        first_line = GeoramaMesMakeLine[data_no];
        CMenuPosDataForm *form = CMenuGeoPt->list_form[list_no];
        CMenuGeoPt->list_target_y[data_no] = 45.0f + form->y - 24.0f * CMenuGeoPt->list_info[list_no].top;
        float *list_pos = CMenuGeoPt->list_pos[data_no];
        list_pos[0] = 40.0f + form->x;
        CalcMenu1(CMenuGeoPt->list_target_y[data_no], &list_pos[1], 3.5f, 3.0f, force_pos);

        if (list_no == GEORAMA_VIEW_PAINT) {
            if (GeoramaMesForceMakeFlag_PaintVer == 0 && list_pos[0] < -180.0f) {
                continue;
            }
        } else if (list_pos[0] < -180.0f) {
            continue;
        }

        CEditPartsInfo *info[10];
        sceVu0FVECTOR   line_color[10];
        int             item_mes[13] = {0};
        int             line_pos[13][2];
        char           *names[13] = {nullptr};
        float           x = list_pos[0];
        float           y = list_pos[1] + 24.0f * first_line;
        int             i = 0;
        int             line = first_line;

        while (line < 0) {
            item_mes[i] = 0;
            names[i] = nullptr;
            line_pos[i][0] = static_cast<int>(x);
            line_pos[i][1] = static_cast<int>(y);
            y += 24.0f;
            i++;
            ++line;
        }

        for (; i < 10; i++) {
            item_mes[i] = 0;
            int no = first_line + i;
            names[i] = nullptr;
            line_pos[i][0] = static_cast<int>(x);
            line_pos[i][1] = y;

            switch (list_no) {
                case GEORAMA_VIEW_PAINT:
                    item_mes[i] = i + 0x145A + CMenuGeoPt->list_info[GEORAMA_VIEW_PAINT].top;

                    if (no == 8 && LanguageCode > 0) {
                        line_pos[i][0] = static_cast<int>(x - 40.0f);
                    }

                    break;
                default: {
                    float *color = line_color[i];
                    color[0] = 107.0f;
                    color[1] = 106.0f;
                    color[2] = 104.0f;
                }
                    info[i] = CMenuGeoPt->GetNowSelectEditPartsInfo(data_no, no);

                    if (info[i] != nullptr) {
                        names[i] = info[i]->edit_name;
                    } else {
                        names[i] = nullptr;
                    }

                    break;
            }

            y += 24.0f;
        }

        CDC2Mes *mes = GeoramaMes[data_no];

        for (k = 0; k < 10; k++) {
            if (list_no == GEORAMA_VIEW_PAINT) {
                line_pos[k][0] += 40;

                if (mes->item_mes[k] != item_mes[k]) {
                    mes->ClsMes::mes_no = -1;
                }

                mes->SetItemMes(k, item_mes[k]);
            }

            if (list_no != GEORAMA_VIEW_PAINT) {
                if (names[k] != nullptr && strcmp(mes->name[k], names[k]) != 0) {
                    mes->ClsMes::mes_no = -1;
                }

                if (names[k] != nullptr) {
                    dc2::text::Copy(mes->name[k], dc2::text::View(names[k]));
                }

                if (names[k] == nullptr) {
                    dc2::text::Copy(mes->name[k], dc2::text::View(" "));
                }
            }

            mes->SetMovePosGyou(k, line_pos[k][0], line_pos[k][1]);
        }

        if (GeoramaMesForceMakeFlag != 0) {
            mes->ClsMes::mes_no = -1;
        }

        if ((GeoramaMesMakeManner[data_no] == 1 && 238.0f + form->y - 9.0f <= line_pos[8][1]) || (GeoramaMesMakeManner[data_no] == 0 && 238.0f + form->y - 9.0f <= line_pos[8][1])) {
            mes->line_pos[8][0] = mgScreenWidth - 20;
            mes->line_pos_on[8] = 1;
        }

        short *offset = constant_msg_xyoffsettbl[data_no];
        mes->SetMovePosGyou(9, static_cast<int>(form->x + offset[0]), static_cast<int>(form->y + offset[1]));
        mes->SetMovePosGyou(10, static_cast<int>(form->x + offset[2]), static_cast<int>(form->y + offset[3]));

        if (LanguageCode > 0 && list_no == 0) {
            mes->SetMovePosGyou(9, static_cast<int>(22.0f + form->x), static_cast<int>(form->y + offset[1]));
            mes->SetMovePosGyou(10, static_cast<int>(22.0f + form->x), static_cast<int>(form->y + offset[3]));
        }

        mes->MakeMesWin(list_no + 0x5F0);
        mes->Step();
    }

    CMenuGeoPt->list_pos[GEORAMA_VIEW_ANALYZE][0] = 54.0f + CMenuGeoPt->analyze_form->x;

    if (GeoramaMesForceMakeFlag != 0) {
        GeoramaMesForceMakeFlag_PaintVer = 0;
        GeoramaMesForceMakeFlag = static_cast<signed char>(GeoramaMesForceMakeFlag) ^ 1;
    }
}

int CheckGekkaViewMode(int town_no) {
    if (town_no == EDIT_ANALYZE_MAP_MOON_FLOWER && CheckBitFlagMenu(SAVE_FLAG_GEKKA_VIEW) != 0) {
        return 1;
    }

    return 0;
}

void CMenuGeorama::InitEnd() {
    static signed char msgtbl[5] = {
        GEORAMA_INITIAL_MESSAGE_MAKE - GEORAMA_INITIAL_MESSAGE_BASE,
        GEORAMA_INITIAL_MESSAGE_STOCK - GEORAMA_INITIAL_MESSAGE_BASE,
        GEORAMA_INITIAL_MESSAGE_PAINT - GEORAMA_INITIAL_MESSAGE_BASE,
        GEORAMA_INITIAL_MESSAGE_PLACED - GEORAMA_INITIAL_MESSAGE_BASE,
        GEORAMA_INITIAL_MESSAGE_HOUSE - GEORAMA_INITIAL_MESSAGE_BASE,
    };
    char                    part_name[0x20];
    CMenuPosDataForm       *form = {};
    dc2::io::FileRead       read_b_g = {};
    u8                     *image = {};
    int                     tex_block = {};
    int                     i = {};
    int                     k = {};
    int                     budget = {};
    int                     used_blocks = {};
    int                     free_blocks = {};
    mgCTexture             *download_texture = {};
    dc2::text::MessageTable message_pack;

    AttachFormInfo();
    Init_MENUFORM_MAKEBRD_INFO(&make_brd);
    read_b_g = dc2::io::FindBackgroundRead(0);
    image = reinterpret_cast<u8 *>(AssetDirectoryRead(reinterpret_cast<unsigned int *>(read_b_g.Bytes().data()), "g.json", nullptr));
    tex_block = MenuCommonInfo->tex_block[3];
    mgTexManager.EnterIMGFile(image, tex_block, nullptr, nullptr);
    script = reinterpret_cast<char *>(AssetDirectoryRead(reinterpret_cast<unsigned int *>(read_b_g.Bytes().data()), "geo_com.cfg.json", &script_size));
    MenuPosData->ResetTextureBlockNo("gaiji", MenuArg.mes_tex_block);
    MenuPosData->ResetTextureInfoAll();
    Tex_Georama = mgTexManager.GetTexture("geo", tex_block);
    GetMenuMainMessageBuffer();
    int         message_size = 0;
    const auto *message_bytes = AssetDirectoryRead(reinterpret_cast<unsigned int *>(read_b_g.Bytes().data()), "npcmsg.mes", &message_size);
    message_pack = message_bytes != nullptr && message_size > 0 ? dc2::text::MessageTable::Parse(
                                                                      {reinterpret_cast<const std::byte *>(message_bytes), static_cast<std::size_t>(message_size)})
                                                                : dc2::text::MessageTable{};
    MenuCommandAnalyzeInfo.system_mes_buff[0] = GetSystemMesBuffer();
    MenuCommandAnalyzeInfo.system_mes_buff[1] = message_pack;
    MenuCommandAnalyzeInfo.mes_buff[0] = GetMenuMainMessageBuffer();
    MenuCommandAnalyzeInfo.mes_buff[1] = nullptr;
    ExeScript("MSG_BUFF");

    for (i = 0; i < 5; i++) {
        GeoramaMes[i]->MakeMesWin(msgtbl[i] + GEORAMA_INITIAL_MESSAGE_BASE);
    }

    GeoramaMesForceMakeFlag = 1;
    fade_alpha = 0x80;
    form = MenuPosData->GetFormInfo(10);
    i = 0;

    do {
        i++;
        form->draw_flag = 1;
        form++;
    } while (i < 0x46);

    ExeScript("INIT_END");

    if (title_form != nullptr) {
        std::snprintf(part_name, sizeof(part_name), "Title%d", town_no);
        title_form->SetPartDrawFlag(part_name, 1);
    }

    if (MenuPrevEndCode == 2 && MenuArg.param[0] >= 0 && stock_num > 0) {
        sub_step = 0;
        key_arg_no = 2;
        view_mode = GEORAMA_VIEW_STOCK;
        select = list_info[view_mode].select;
        top = list_info[view_mode].top;

        if (stock_num <= select) {
            select = stock_num;
        }

        if (stock_num <= 0) {
            key_arg_no = 0;
        }

        LoadGeoramaPart(GetNowModeLoadPartsID(), 0);
        ExeScript("PLACE_INIT");
    } else if (MenuPrevEndCode == 8) {
        key_arg_no = 3;
        view_mode = GEORAMA_VIEW_PAINT;
        select = list_info[view_mode].select;
        top = list_info[view_mode].top;
        paint_return = 1;
        ExeScript("PAINT_INIT");
    } else {
        key_arg_no = 0;
        view_mode = GEORAMA_VIEW_STOCK;
        LoadGeoramaPart(GetNowModeLoadPartsID(), 0);
    }

    MenuGeoramaCursorForceSetFlag = 1;
    list_form[view_mode]->SetAction("1");

    for (k = 0; k < 5; k++) {
        if (list_form[k] != nullptr) {
            list_pos[k][1] = 40.0f + list_form[k]->y - 24.0f * static_cast<float>(list_info[k].top);
        }
    }

    MenuArg.param[0] = -1;
    budget = GetMaxPolyn(town_no);
    polygon_left = budget - MenuMainMapInfo->GetTotalPolyn(nullptr, nullptr);

    if (title_form != nullptr) {
        title_form->SetNumber("\x83|\x83\x8A\x83\x93\x90\x94", polygon_left);
    }

    if (true) {
        ExeScript("POLYOF");
    }

    ExeScript("MSG_\x8F\x89\x8A\xFA\x89\xBB");
    MenuGeoramaMessageMake(0);

    if (LanguageCode > 0) {
        MenuDCMsg[2]->font_w += 2;
    }

    MenuGeoStoneDonwLoadFlag = 0;
    download_texture = nullptr;
    ExeScript("DL_OFF");

    if (0 < MenuGeoStoneDownLoad_Request + MenuGeoStoneDownLoad_PartsNum) {
        MenuGeoStoneDonwLoadFlag = 1;
        ExeScript("DL_ON");
        MenuDCMsg[5]->fuchi = 5;
        MenuDCMsg[5]->put_centering = 1;
        download_texture = GetMenuDlTexture();
    }

    InitMenuDl(download_texture, MenuGeoStoneDownLoadTime);
    free_blocks = MenuGeoramaStack.stack_size - MenuGeoramaStack.stack_used;
    used_blocks = free_blocks;
    MenuCharaLoadStack.stSetBuffer(MenuGeoramaStack.stGetTop(), free_blocks);
}

void CMenuGeorama::ExitEnd() {
    MenuGeoramaSystemData->list_state[0].selected = static_cast<short>(list_info[0].select);
    MenuGeoramaSystemData->list_state[0].top = static_cast<short>(list_info[0].top);
    MenuGeoramaSystemData->list_state[1].selected = static_cast<short>(list_info[1].select);
    MenuGeoramaSystemData->list_state[1].top = static_cast<short>(list_info[1].top);
    MenuGeoramaSystemData->list_state[2].selected = static_cast<short>(list_info[2].select);
    MenuGeoramaSystemData->list_state[2].top = static_cast<short>(list_info[2].top);
    MenuGeoramaSystemData->list_state[3].selected = static_cast<short>(list_info[3].select);
    MenuGeoramaSystemData->list_state[3].top = static_cast<short>(list_info[3].top);
    MenuGeoramaSystemData->list_state[4].selected = static_cast<short>(list_info[4].select);
    MenuGeoramaSystemData->list_state[4].top = static_cast<short>(list_info[4].top);
    MenuGeoramaSystemData->list_state[5].selected = static_cast<short>(list_info[5].select);
    MenuGeoramaSystemData->list_state[5].top = static_cast<short>(list_info[5].top);
    MenuGeoramaSystemData->list_state[6].selected = static_cast<short>(list_info[6].select);
    MenuGeoramaSystemData->list_state[6].top = static_cast<short>(list_info[6].top);
    InitMenuDl(nullptr, 0);
    InitDownLoadAnaunce(nullptr);
    GeoRequestFlag = nullptr;
}

int CMenuGeorama::GetPartsIDListNum(int list_mode) {
    if (list_mode < 0) {
        list_mode = view_mode;
    }

    if (list_mode == GEORAMA_VIEW_STOCK) {
        return stock_num;
    }

    if (list_mode == GEORAMA_VIEW_MAKE) {
        return make_num;
    }

    if (list_mode == GEORAMA_VIEW_PLACED) {
        return placed_num + 1;
    }

    if (list_mode == GEORAMA_VIEW_CHECK_POINT) {
        return house_num;
    }

    if (list_mode == GEORAMA_VIEW_PAINT) {
        return 8;
    }

    return 0;
}

int CMenuGeorama::GetNowMakePartsNum(int id) {
    return MenuMainMapInfo->GetePlacePartsAtInfoID(id, nullptr, 0);
}

int GetPenkiItemNo(int slot) {
    if (slot < 0) {
        return -1;
    }

    if (slot >= 8) {
        return -1;
    }

    return penki_item_no[slot];
}

int CMenuGeorama::ArrangePartsList(int list, int advance_sort) {
    int                     *mode = &sort_mode[0];
    GEORAMA_PARTS_LIST_ITEM *entries = stock_list;
    int                      count = stock_num;
    GEORAMA_PARTS_LIST_ITEM  swap_a{};
    GEORAMA_PARTS_LIST_ITEM  swap_b{};
    GEORAMA_PARTS_LIST_ITEM  swap_c{};
    GEORAMA_PARTS_LIST_ITEM  swap_d{};
    int                      i = {};
    int                      j = {};

    if (list == 1) {
        mode = &sort_mode[1];
        entries = make_list;
        count = make_num;
    }

    if (list == 2) {
        mode = &sort_mode[2];
        entries = house_list;
        count = house_num;
    }

    if (advance_sort != 0) {
        *mode += 1;
    }

    if (*mode > GEORAMA_SORT_NUM - 1) {
        *mode = 0;
    }

    switch (*mode) {
        case GEORAMA_SORT_NO:

            for (i = 0; i < count; i++) {
                for (j = i + 1; j < count; j++) {
                    if (entries[j].no < entries[i].no) {
                        dc2::memory::CopyTrackedBytes(&swap_a, &entries[j], sizeof(swap_a));
                        dc2::memory::CopyTrackedBytes(&entries[j], &entries[i], sizeof(swap_a));
                        dc2::memory::CopyTrackedBytes(&entries[i], &swap_a, sizeof(swap_a));
                        i = -1;
                        break;
                    }
                }
            }

            break;
        case GEORAMA_SORT_NAME:

            for (i = 0; i < count; i++) {
                for (j = i + 1; j < count; j++) {
                    if (strcmp(entries[j].name, entries[i].name) < 0) {
                        dc2::memory::CopyTrackedBytes(&swap_b, &entries[j], sizeof(swap_b));
                        dc2::memory::CopyTrackedBytes(&entries[j], &entries[i], sizeof(swap_b));
                        dc2::memory::CopyTrackedBytes(&entries[i], &swap_b, sizeof(swap_b));
                        i = -1;
                        break;
                    }
                }
            }

            break;
        case GEORAMA_SORT_NAME_DESC:

            for (i = 0; i < count; i++) {
                for (j = i + 1; j < count; j++) {
                    if (strcmp(entries[j].name, entries[i].name) > 0) {
                        dc2::memory::CopyTrackedBytes(&swap_c, &entries[j], sizeof(swap_c));
                        dc2::memory::CopyTrackedBytes(&entries[j], &entries[i], sizeof(swap_c));
                        dc2::memory::CopyTrackedBytes(&entries[i], &swap_c, sizeof(swap_c));
                        i = -1;
                        break;
                    }
                }
            }

            break;
        case 3:

            for (i = 0; i < count; i++) {
                for (j = i + 1; j < count; j++) {
                    if (strcmp(entries[j].name, entries[i].name) > 0) {
                        dc2::memory::CopyTrackedBytes(&swap_d, &entries[j], sizeof(swap_d));
                        dc2::memory::CopyTrackedBytes(&entries[j], &entries[i], sizeof(swap_d));
                        dc2::memory::CopyTrackedBytes(&entries[i], &swap_d, sizeof(swap_d));
                        i = -1;
                        break;
                    }
                }
            }

            break;
    }

    if (list == 0) {
        for (i = stock_num; i < GEORAMA_PARTS_LIST_MAX; i++) {
            entries[i].no = -1;
            entries[i].name[0] = 0;
            entries[i].num = 0;
        }
    }

    return 0;
}

int CMenuGeorama::GetNowModeLoadPartsID() {
    int selected = list_info[view_mode].select;

    if (view_mode == GEORAMA_VIEW_STOCK) {
        return stock_list[selected].no;
    }

    int id = -1;

    if (view_mode == GEORAMA_VIEW_MAKE) {
        id = make_list[selected].no;
    }

    return id;
}

CEditPartsInfo *CMenuGeorama::GetNowSelectEditPartsInfo(int mode, int line) {
    CEditPartsInfo *info = {};

    if (MenuMainMapInfo == nullptr) {
        return nullptr;
    }

    if (mode == GEORAMA_VIEW_STOCK) {
        info = MenuMainMapInfo->GetePartsInfo(stock_list[line].name);
    } else if (mode == GEORAMA_VIEW_MAKE) {
        info = MenuMainMapInfo->GetePartsInfo(make_list[line].name);
    } else if (mode == GEORAMA_VIEW_CHECK_POINT) {
        info = MenuMainMapInfo->GetePartsInfo(house_list[line].name);
    } else {
        info = nullptr;
    }

    return info;
}

void CMenuGeorama::LoadGeoramaPart(int no, int kind) {
    int       id = {};
    mgVu0FBOX box{};
    float     scale = {};

    if (MenuMainMapInfo != nullptr) {
        if (view_parts != nullptr) {
            view_parts->SetScale(1.0f, 1.0f, 1.0f);
            view_parts->SetRotation(0.0f, 0.0f, 0.0f);

            if (old_menuparts_pos_flag != 0) {
                view_parts->SetPosition(old_menuparts_pos);
                view_parts->SetRotation(old_menuparts_rot);
                old_menuparts_pos_flag = 0;
            }
        }

        view_parts = nullptr;
        id = -1;
        place_parts = nullptr;
        parts_info = nullptr;

        if (kind == GEORAMA_LOAD_INFO_ID) {
            parts_info = MenuMainMapInfo->GetePartsInfoAtID(no);

            if (parts_info != nullptr) {
                view_parts = parts_info->parts;
                id = parts_info->id;
            }
        } else if (kind == GEORAMA_LOAD_INFO_INDEX) {
            parts_info = MenuMainMapInfo->GetePartsInfo(no);

            if (parts_info != nullptr) {
                view_parts = parts_info->parts;
                id = parts_info->id;
            }
        } else if (kind == GEORAMA_LOAD_PLACE) {
            place_parts = MenuMainMapInfo->GetePlaceParts(no);
            view_parts = place_parts;

            if (place_parts != nullptr) {
                old_menuparts_pos_flag = 1;
                id = place_parts->info->id;
            }
        }

        MenuMapPart = view_parts;

        if (view_parts != nullptr) {
            view_parts->GetPosition(old_menuparts_pos);
            view_parts->GetRotation(old_menuparts_rot);
            old_menuparts_pos_flag = 1;
            mgZeroVector(now_menu_pos_mapparts);
            now_menu_pos_mapparts[1] = -20.0f;
            now_menu_pos_mapparts[2] = -14.0f;
            now_menu_pos_mapparts[3] = 1.0f;
            std::memmove(georama_adjust_position, now_menu_pos_mapparts, sizeof(float) * 4);
            view_parts->SetScale(1.0f, 1.0f, 1.0f);

            if (view_parts != nullptr) {
                view_parts->SetPosition(0.0f, 0.0f, 0.0f);
                view_parts->SetRotation(0.0f, 0.0f, 0.0f);
            }

            view_parts->GetBoundBox(&box);
            scale = MenuAdjustPolygonScale(box, 11.2f);
            view_parts->SetScale(scale, scale, scale);

            if (0 <= id) {
                scale = 0.85f * georama_parts_adjust_scaletable[id];
                view_parts->SetScale(scale, scale, scale);
            }

            if (parts_info != nullptr) {
                georama_adjust_position[1] -= box.min[1] * scale - 1.0f;
                georama_adjust_position[2] += georama_parts_adjust_z_table[id];
            }

            view_parts->SetPosition(georama_adjust_position);
        }
    }
}

void CMenuGeorama::UpdateGeoramaPartColor(int paint_mode) {
    if (select == 0) {
        MenuArg.result[0] = static_cast<int>(127.5f * paint_color[0]);
        MenuArg.result[1] = static_cast<int>(127.5f * paint_color[1]);
        MenuArg.result[2] = static_cast<int>(127.5f * paint_color[2]);
        int paint = list_info[2].select;

        if (paint < 0 || paint > 7) {
            paint = 0;
        }

        MenuArg.result[3] = penki_item_no[paint];
    }
}

void CMenuGeorama::AttachFormInfo() {
    char name[32];
    int  i = {};
    int  gekka_view = {};
    title_form = MenuPosData->GetFormInfo("field_title");

    if (title_form != nullptr) {
        gekka_view = 0;

        if (CheckGekkaViewMode(town_no) != 0) {
            gekka_view = 1;
            title_form->SetPartDrawFlag("index4", 0);
        }

        title_form->SetPartDrawFlag("index14", gekka_view != 0);
    }

    make_brd_form = MenuPosData->GetFormInfo("makebrd");
    cpview_form = MenuPosData->GetFormInfo("CPVIEW");
    free_color_form = MenuPosData->GetFormInfo("free_color");

    for (i = 0; i < 7; i++) {
        std::snprintf(name, sizeof(name), "list_data%d", i);
        list_form[i] = MenuPosData->GetFormInfo(name);
    }

    analyze_form = MenuPosData->GetFormInfo("analyze0");
    analyze_percent_form = MenuPosData->GetFormInfo("analyze1");
    house_info_form = MenuPosData->GetFormInfo("\x89\xC6\x8F\xEE\x95\xF1");
    HouseInfoFormGrobal = house_info_form;
    AttachMessageForm();
}

void CMenuGeorama::SetGeoListInfo(int list, int selected, int top) {
    list_info[list].select = selected;
    list_info[list].top = top;
}

int CMenuGeorama::ReturnSelectMode(int exit_script) {
    view_mode = CBaseMenuClass::key_arg_no - 1;
    CBaseMenuClass::key_arg_no = 0;

    if (exit_script == 0) {
        ExeScript("RETURN_SELMODE");
    }

    if (exit_script == 1) {
        ExeScript("RETURN_SELMODE2");
    }

    return 1;
}

int CMenuGeorama::GetNowViewModeMax(int view_mode) {
    switch (view_mode) {
        case 1:
            return stock_num;
        case 0:
            return make_num;
        case 4:
            return house_num;
        case 5:
            return MenuEditAnalyzeDataSrcListLimmitNum - 1;
        default:
            return 0;
    }
}

int CMenuGeorama::LRCheck() {
    float rotation[4];

    if (view_parts != nullptr) {
        view_parts->GetRotation(rotation);

        if (GamePad__2.On(PAD_L2) != 0) {
            rotation[1] -= 0.05235988f;
        }

        if (GamePad__2.On(PAD_R2) != 0) {
            rotation[1] += 0.05235988f;
        }

        rotation[1] = mgAngleLimit(rotation[1]);
        view_parts->SetRotation(rotation);
    }

    return 0;
}

void MakeMsgPartsItemInfo(CDC2Mes *mes, CEditPartsInfo *info, MENUFORM_MAKEBRD_INFO *make_brd) {
    static char *dmychar = "";

    char *names[5];
    names[0] = info->edit_name;
    make_brd->material_num = 0;

    if (names[0] != nullptr) {
        dc2::text::Copy(mes->name[0], dc2::text::View(names[0]));
    }

    for (int i = 0; i < 4; i++) {
        EditPartsMaterial *material = info->GetMaterial(i);
        names[i + 1] = dmychar;

        if (material->item_no > 0) {
            make_brd->material_num++;
            names[i + 1] = GetItemMessage(material->item_no);
        }

        if (names[i + 1] != nullptr) {
            dc2::text::Copy(mes->name[i + 1], dc2::text::View(names[i + 1]));
        }
    }

    mes->SetDefColor(0x80686A6B);
    mes->MakeMsg(0x654);
    mes->StepMsg();
}

int CMenuGeorama::IsMakeObject(int buttons_held, int buttons_pressed) {
    CDC2Mes *mes = MenuDCMsg[2];

    switch (step) {
        case GEORAMA_MAKE_STEP_CHOOSE_AMOUNT: {
            int selection = SelectMakeObject(buttons_held);

            if (selection == -1) {
                make_brd.decrease_flash_frames = 6;
                make_brd.increase_flash_frames = 0;
            } else if (selection == 1) {
                make_brd.decrease_flash_frames = 0;
                make_brd.increase_flash_frames = 6;
            }

            switch (buttons_pressed) {
                case 1:
                case 4:
                    if (make_cursor == 0) {
                        if (make_parts != nullptr) {
                            int enough = 1;

                            for (int i = 0; i < make_brd.material_num; i++) {
                                if (make_brd.line[i].button == 0) {
                                    enough = 0;
                                }
                            }

                            if (DebugFlag != 0 && GamePad__2.On(PAD_R2) != 0) {
                                enough = 1;
                            }

                            if (enough == 0) {
                                ExeScript("\x8D\xDE\x97\xBF\x95s\x91\xAB");
                                step = GEORAMA_MAKE_STEP_NEED_MATERIALS;
                            } else {
                                ExeScript("MAKE_GEOPARTS\x8Am\x94"
                                          "F");
                                char *items[1] = {make_parts->edit_name};
                                mes->SetMsgItemNo(items, 1);
                                mes->SetMsgVolumeNoOne(CBaseMenuClass::make_num);
                                step = GEORAMA_MAKE_STEP_CONFIRM;
                            }
                        }

                        break;
                    }
                case 2:
                    ExeScript("NOT_MAKE_GEOPARTS");
                    mode = MENU_ASK_MODE_NONE;
                    step = GEORAMA_MAKE_STEP_CHOOSE_AMOUNT;
                    break;
            }

            break;
        }
        case GEORAMA_MAKE_STEP_DONE:
            if (buttons_pressed != 0) {
                ExeScript("MAKEMODE\x8FI\x97\xB9");
                make_parts = nullptr;
                mode = MENU_ASK_MODE_NONE;
                step = GEORAMA_MAKE_STEP_CHOOSE_AMOUNT;
            }

            break;
        case GEORAMA_MAKE_STEP_CONFIRM: {
            int answer = mes->YesNoCursor2(0);

            if (answer == 1) {
                GetSaveData()->AddBuildPartsNum(make_parts->id, CBaseMenuClass::make_num);
                UpdateGeoramaPartsList();
                GeoramaMesForceMakeFlag = 1;
                ExeScript("MAKE_GEOPARTS");
                char *items[1] = {make_parts->edit_name};
                mes->SetMsgItemNo(items, 1);
                mes->SetMsgVolumeNoOne(CBaseMenuClass::make_num);

                for (int i = 0; i < make_brd.material_num; i++) {
                    EditPartsMaterial *material = make_parts->GetMaterial(i);

                    if (material != nullptr) {
                        GetUserDataMan()->DeleteItem(material->item_no,
                                                     material->num * CBaseMenuClass::make_num);
                    }
                }

                step = GEORAMA_MAKE_STEP_DONE;
            }

            if (answer == 2) {
                ExeScript("MAKE_GEOPARTS?");
                MakeMsgPartsItemInfo(MenuDCMsg[2], make_parts, &make_brd);
                step = GEORAMA_MAKE_STEP_CHOOSE_AMOUNT;
            }

            break;
        }
        default:
            if (buttons_pressed != 0) {
                ExeScript("\x90\xBB\x8D\xEC"
                          "ERROR_OFF");
                step = GEORAMA_MAKE_STEP_CHOOSE_AMOUNT;
            }

            break;
    }

    return 0;
}

void CMenuGeorama::CalcCursorPosition() {
    char name[32];

    if (MenuPosData != nullptr) {
        CMenuPosDataForm *forms[9] = {title_form, list_form[0], list_form[1], list_form[2], nullptr,
                                      list_form[4], list_form[6], list_form[6], free_color_form};
        CMenuPosDataForm *form = forms[key_arg_no];
        int               pos[4] = {0, 0, 0, 0};

        if (form != nullptr) {
            switch (key_arg_no) {
                case 0:
                    MenuCommonInfo->SetWakuType(0);
                    MenuCommonInfo->SetWakuWH(0, 0x54, 0x26);
                    pos[0] = static_cast<int>(menu_georama_title_pos[0]);
                    pos[1] = static_cast<int>(menu_georama_title_pos[1]);
                    break;
                case 1:
                case 2:
                case 5:
                case 7:
                    form->GetPutPosXY(nullptr, pos[0], pos[1]);
                    pos[0] -= 6;
                    pos[1] = static_cast<int>(pos[1] + (43.0f + 24.0f * (list_info[view_mode].select - list_info[view_mode].top)));
                    break;
                case 3:
                    form->GetPutPosXY(nullptr, pos[0], pos[1]);
                    pos[0] -= 6;
                    pos[1] = static_cast<int>(pos[1] + (40.0f + 24.0f * (paint_select - paint_top)));
                    break;
                case 8:
                    std::snprintf(name, sizeof(name), "num%d", free_color_select);
                    form->GetPutPosXY(name, pos[0], pos[1]);
                    pos[0] -= 0x1A;
                    pos[1] -= 0xC;
                    break;
            }
        }

        if (mode == MENU_ASK_MODE_MAKE) {
            pos[0] = static_cast<int>(-50.0f + MakeBoardDrawInfo[make_cursor * 2]);
            pos[1] = static_cast<int>(MakeBoardDrawInfo[make_cursor * 2 + 1]);
        }

        if (MenuGeoramaCursorForceSetFlag != 0) {
            MenuCommonInfo->MenuSetPos(pos[0], pos[1]);
            MenuGeoramaCursorForceSetFlag = 0;
        }

        MenuCommonInfo->MenuPosStep(pos, nullptr);
    }
}

void CMenuGeorama::CalcTex() {
    char name[32];
    int  i = {};

    if (analyze_form != nullptr && analyze_percent_form != nullptr) {
        int show = 0;

        if (view_mode >= GEORAMA_VIEW_EDIT) {
            float scroll = 0.0f;

            if (MenuEditAnalyzeDataSrcListH != 0.0f) {
                scroll = 192.0f * (MenuEditAnalyzeDataSrcListH_Move / MenuEditAnalyzeDataSrcListH);
            }

            float target = 56.0f + analyze_form->y + scroll;
            CalcMenu1(target, &GeoAnalyzeCheckPointScrlBarY, 4.0f, 0.0f, 0);
            MENUFORMPARTS_TYPE *bar_base = analyze_percent_form->GetPartInfo("base");
            MENUFORMPARTS_TYPE *bar_tip = analyze_percent_form->GetPartInfo("bar0");
            MENUFORMPARTS_TYPE *bar_body = analyze_percent_form->GetPartInfo("bar1");
            float               body = 161.0f * analyze_percent / 100.0f;
            float               tip = 1.0f;

            if (body >= tip) {
                body -= tip;
            } else {
                tip = body;
                body = 0.0f;
            }

            if (bar_tip != nullptr && bar_body != nullptr && bar_base != nullptr) {
                bar_body->y = bar_base->y - body;
                bar_body->h = body;
                bar_tip->y = bar_body->y - tip;
                bar_tip->h = tip;
            }

            analyze_percent_form->SetNumber("\x8A\xAE\x90\xAC\x93x", analyze_percent);
            show = 1;
        }

        analyze_form->draw_flag = show != 0;
        analyze_percent_form->draw_flag = show != 0;
    }

    if (title_form != nullptr) {
        for (i = 0; i < 6; i++) {
            std::snprintf(name, sizeof(name), "b%d", i);
            MENUFORMPARTS_TYPE *tab = title_form->GetPartInfo(name);

            if (tab != nullptr) {
                tab->draw_flag = 0;

                if (i == view_mode || (key_arg_no == 3 && i == 6)) {
                    tab->draw_flag = 1;
                    menu_georama_title_pos[0] = title_form->x + tab->x - 2.0f;
                    menu_georama_title_pos[1] = title_form->y + tab->y;
                }
            }
        }
    }

    int list_num[11] = {make_num, stock_num, 9, 0, house_num, 0, 8};

    for (i = 0; i < GEORAMA_VIEW_MODE_NUM; i++) {
        if (list_form[i] != nullptr) {
            int num = list_num[i];

            if (num < GEORAMA_LIST_LINE_NUM) {
                num = GEORAMA_LIST_LINE_NUM;
            }

            scroll_bar_h[i] = 186.0f * (8.0f / num);
            float space = 186.0f - scroll_bar_h[i];

            if (space < 0.0f) {
                space = 0.0f;
            }

            float rate = num > GEORAMA_LIST_LINE_NUM ? space / (num - GEORAMA_LIST_LINE_NUM) : 0.0f;
            float bar_y = rate * list_info[i].top;

            if (bar_y <= 0.0f) {
                bar_y = 0.0f;
            }

            if (186.0f < bar_y) {
                bar_y = 186.0f;
            }

            CalcMenu1(bar_y, &scroll_bar_y[i], 4.0f, 0.0f, 0);
        }
    }

    if (list_form[GEORAMA_VIEW_CHECK_POINT] != nullptr && house_info_form != nullptr) {
        int show = 0;

        if (view_mode >= GEORAMA_VIEW_PAINT) {
            show = 1;
        }

        list_form[GEORAMA_VIEW_CHECK_POINT]->draw_flag = show != 0;
        house_info_form->draw_flag = show != 0;
    }

    CalcMakeBrd();

    if (MenuMapPart != nullptr) {
        float pos[4];
        MenuMapPart->GetPosition(pos);
        pos[1] = georama_adjust_position[1];

        if (NowPolyGonFormMoveFlag != 0) {
            pos[0] += (100.0f - pos[0]) / 4.0f;
        } else {
            pos[0] += (georama_adjust_position[0] - pos[0]) / 4.0f;
        }

        MenuMapPart->SetPosition(pos);
    }
}

void CMenuGeorama::CalcMakeBrd() {
    int                i = {};
    int                owned = {};
    EditPartsMaterial *material = {};

    if (make_brd_form != nullptr && mode == MENU_ASK_MODE_MAKE && step == GEORAMA_MAKE_STEP_CHOOSE_AMOUNT) {
        i = 0;
        make_brd.make_num = CBaseMenuClass::make_num;

        for (; i < make_brd.material_num; i++) {
            material = make_parts->GetMaterial(i);

            if (material != nullptr) {
                make_brd.line[i].kind = 1;
                make_brd.line[i].num =
                    static_cast<short>(material->num) * static_cast<short>(make_brd.make_num);
                owned = GetUserItemHaveNum(material->item_no);
                make_brd.line[i].button = 0;

                if (owned >= make_brd.line[i].num) {
                    make_brd.line[i].button = 1;
                }

                make_brd.line[i].sub_num = make_brd.line[i].num - owned;
            }
        }

        for (; i < 4; i++) {
            make_brd.line[i].kind = 0;
            make_brd.line[i].button = 0;
            make_brd.line[i].num = 0;
            make_brd.line[i].sub_num = 0;
        }

        CalcMenuAdd(&make_brd.decrease_flash_frames, -1, 0);
        CalcMenuAdd(&make_brd.increase_flash_frames, -1, 0);
        make_brd.make_cursor = make_cursor;
        CalcCommonBrdDrawInfo(&make_brd_form->x, &make_brd, MenuDCMsg[2]);
    }
}

/**
 *
 * Handles the Georama menu's base page controls and download announcement.
 *
 */
int MenuGeoramaBasePush(CMenuGeorama *menu, int buttons_held, int buttons_pressed) {
    int result = {};
    int moved = {};
    int i = {};
    int step = {};
    int load_kind = {};
    int download_done = {};
    int view_mode = {};

    result = 0;

    if (MenuGeoStoneDonwLoadFlag != 0) {
        download_done = StepMenuDl3();

        if (MenuGeoStoneDonwLoadFlag == 1 && download_done != 0) {
            MenuGeoStoneDonwLoadFlag = 2;
            MenuSePlay(SYSTEM_SE_COMPLETE);
            MenuDCMsg[5]->MakeMsg(0x5DD);
        }

        if (MenuGeoStoneDonwLoadFlag == 2 && buttons_pressed != 0) {
            menu->ExeScript("DL_END");
            DrawDownLoadAnaunceSwitch(1);
            MenuSePlay(SYSTEM_SE_WINDOW);
            MenuGeoStoneDonwLoadFlag = 3;
            DownLoadMesMakeProgress = 2;
        }

        if (MenuGeoStoneDonwLoadFlag == 3 && StepDownLoadAnaunce(buttons_pressed) == 1) {
            MenuGeoStoneDonwLoadFlag = 4;
        }

        if (MenuGeoStoneDonwLoadFlag == 4) {
            if (buttons_pressed != 0) {
                MenuGeoStoneDonwLoadFlag = 0;
            }
        }

        return 0;
    }

    if (0 < DownLoadMesAlpha) {
        DownLoadMesAlpha -= 8;

        if (DownLoadMesAlpha <= 0) {
            InitDownLoadAnaunce(nullptr);
        }
    }

    step = 0;

    if ((buttons_held & MENU_SELECT_KEY_RIGHT) != 0 || (buttons_held & MENU_SELECT_KEY_R1) != 0) {
        step += 1;
    }

    if ((buttons_held & MENU_SELECT_KEY_LEFT) != 0 || (buttons_held & MENU_SELECT_KEY_L1) != 0) {
        step -= 1;
    }

    moved = 0;

    if (MenuKeySelectCheck(step, &menu->view_mode, nullptr, 0, 6, 6, MENU_CURSOR_LIMIT_CLAMP) != 0) {
        MenuSePlay(SYSTEM_SE_CURSOR);

        for (i = 0; i < 6; i++) {
            if (i < 3 || i == 4) {
                if (i == menu->view_mode) {
                    menu->list_form[i]->SetAction("1");
                } else {
                    menu->list_form[i]->SetAction("0");
                }
            } else if (menu->view_mode >= 3 && menu->view_mode < 5) {
                menu->list_form[2]->SetAction("1");

                if (menu->view_mode == GEORAMA_VIEW_CHECK_POINT) {
                    menu->list_form[2]->SetAction("0");
                }
            }
        }

        if (menu->view_mode == GEORAMA_VIEW_ANALYZE) {
            menu->ExeScript("VIEW_ANALYZE");
            NowPolyGonFormMoveFlag = 1;
        } else if (menu->view_mode == GEORAMA_VIEW_CHECK_POINT) {
            menu->ExeScript("VIEW_C_POINT");
            NowPolyGonFormMoveFlag = 1;
        } else {
            menu->ExeScript("EXCEPT_ANALYZE");
            NowPolyGonFormMoveFlag = 0;
        }

        if (CheckGekkaViewMode(menu->town_no) != 0) {
            menu->ExeScript("\x8C\x8E\x89\xD4\x8F\x88\x97\x9D");

            if (menu->view_mode == GEORAMA_VIEW_CHECK_POINT) {
                menu->ExeScript("\x8C\x8E\x89\xD4\x8F\x88\x97\x9D"
                                "2");
                NowPolyGonFormMoveFlag = 1;
            }
        }

        moved = 1;
    }

    if (moved != 0 || (menu->view_loaded == 0 && menu->fade_alpha <= 0)) {
        if (menu->view_mode < 3) {
            load_kind = 0;

            if (menu->view_mode == GEORAMA_VIEW_MAKE) {
                load_kind = 1;
            }

            if (menu->view_mode == GEORAMA_VIEW_PLACED) {
                load_kind = 2;
            }

            menu->LoadGeoramaPart(menu->GetNowModeLoadPartsID(), load_kind);
        }

        if (menu->view_loaded == 0) {
            menu->view_loaded = 1;
        }
    }

    switch (buttons_pressed) {
        case 1:
        case 4:
        case 8:
            view_mode = menu->view_mode;

            if (view_mode < 3 || view_mode == GEORAMA_VIEW_CHECK_POINT || view_mode == GEORAMA_VIEW_ANALYZE) {
                menu->sub_step = 0;

                if (menu->view_mode == GEORAMA_VIEW_CHECK_POINT &&
                    CheckGekkaViewMode(CMenuGeoPt->town_no) != 0) {
                    menu->key_arg_no = menu->view_mode + 1;
                    menu->step = 0;
                    MenuGeoramaViewNowPicNo = 0;
                    MenuGeoramaViewWallPic = nullptr;
                    menu->ExeScript("GO_\x8C\x8E\x89\xD4");
                } else if (0 < menu->GetPartsIDListNum(-1) || menu->view_mode == GEORAMA_VIEW_ANALYZE) {
                    menu->key_arg_no = menu->view_mode + 1;
                    menu->top = menu->list_info[menu->view_mode].top;
                    menu->select = menu->list_info[menu->view_mode].select;
                    MenuGeoramaCursorForceSetFlag = 1;

                    if (menu->view_mode == GEORAMA_VIEW_ANALYZE) {
                        menu->ExeScript("GO_\x95\xAA\x90\xCD");
                    } else {
                        menu->ExeScript("GO_\x95\xAA\x90\xCD\x88\xC8\x8AO");
                    }
                } else {
                    MenuSePlay(SYSTEM_SE_CANCEL);
                }
            } else {
                if (view_mode == GEORAMA_VIEW_EDIT) {
                    MenuArg.end_code = EDIT_MODE_REMOVE;
                    MenuArg.result[0] = -1;
                }

                result = 1;
                MenuSePlay(SYSTEM_SE_DECIDE);
            }

            break;
        case 2:
            MenuArg.end_code = MENU_END_NONE;
            result = 1;
            MenuArg.result[0] = -1;
            MenuSePlay(SYSTEM_SE_CANCEL);
            break;
    }

    return result;
}

/**
 *
 * Converts menu key input into a list step and requests a position snap for large moves.
 *
 */
int georama_menu_local_key(int keys) {
    int step = MenuListSelectKeyCheck(keys, GEORAMA_LIST_LINE_NUM);

    if (abs(step) > 2) {
        GeoramaMesPosForceSetFlag = 1;
    }

    return step;
}

/**
 *
 * Handles selection and placement of a stocked Georama part.
 *
 */
int MenuGeoramaPlacePush(CMenuGeorama *menu, int buttons_held, int buttons_pressed) {
    int               result = {};
    CDC2Mes          *msg = {};
    CMenuPosDataForm *form = {};
    int               item_no[8];
    int               amount[8];
    int               pos[2];
    int               pos_x = {};
    int               pos_y = {};

    result = 0;
    msg = MenuDCMsg[3];
    form = MenuMesForm[3];

    static CEditPartsInfo *edparts_info = nullptr;
    static int             DestroyNum[1] = {0};
    static short           DestroyMaxNum = 0;
    static char           *DestroyPartsName[1] = {nullptr};

    int key = {};
    int prev_selected = {};
    int prev_top = {};
    int cursor = {};
    int flags = {};
    int choice = {};

    switch (menu->sub_step) {
        case 0:
            key = georama_menu_local_key(buttons_held);
            prev_selected = menu->select;
            prev_top = menu->top;
            MenuKeySelectCheck(key, &menu->select, &menu->top, 0,
                               menu->GetNowViewModeMax(1), 8, MENU_CURSOR_LIMIT_CLAMP);
            menu->SetGeoListInfo(menu->view_mode, menu->select, menu->top);

            if (prev_top != menu->top) {
                int manner = 0;

                if (prev_top < menu->top) {
                    manner = 1;
                }

                GeoramaMesMakeManner[menu->view_mode] = manner;
            }

            if (prev_selected != menu->select) {
                menu->LoadGeoramaPart(menu->GetNowModeLoadPartsID(), 0);
                MenuSePlay(SYSTEM_SE_CURSOR);
            }

            switch (buttons_pressed) {
                case 1:
                    edparts_info =
                        menu->GetNowSelectEditPartsInfo(menu->view_mode, menu->select);

                    if (edparts_info == nullptr) {
                        MenuSePlay(SYSTEM_SE_CANCEL);
                    } else {
                        DestroyPartsName[0] = edparts_info->edit_name;
                        DestroyNum[0] = 1;
                        DestroyMaxNum = 1;

                        if (DestroyPartsName[0] != nullptr) {
                            int j = 0;

                            for (; j < menu->stock_num; j++) {
                                if (strcmp(DestroyPartsName[0],
                                           menu->stock_list[j].name) == 0) {
                                    DestroyMaxNum = menu->stock_list[j].num;
                                    break;
                                }
                            }
                        }

                        MenuSePlay(SYSTEM_SE_WINDOW);
                        menu->sub_step = 1;
                        msg->MsgPreset(6);
                        msg->MakeMsg(0x672);
                        int flags = edparts_info->attr;

                        if ((flags & EDIT_PARTS_ATR_NO_REMOVE) || (flags & EDIT_PARTS_ATR_NO_STOCK_DESTROY)) {
                            msg->line_color[1] = 0x80303030;
                        }

                        form->draw_flag = 1;
                        msg->ClsMes::mes_no = -1;
                        msg->value_space = 2;
                        msg->SetMsgCursor(0);
                        MenuCommonInfo->GetCursorPos(pos);
                        pos_x = pos[0] + 0x28;
                        pos_y = pos[1] - 0x50;
                        form->x = static_cast<float>(pos_x);
                        form->y = static_cast<float>(pos_y);
                        msg->point_x = 0x28;
                        msg->point_y = 0x64;

                        if (MenuCommonInfo->cursor_form != nullptr) {
                            MenuCommonInfo->cursor_form->draw_flag = 0;
                        }

                        msg->SetMsgVolumeNoOne(DestroyNum[0]);
                    }

                    break;
                case 2:
                    menu->ReturnSelectMode(0);
                    break;
                case 4:
                case 32:
                    menu->ArrangePartsList(0, 1);
                    menu->LoadGeoramaPart(menu->GetNowModeLoadPartsID(), 0);
                    MenuSePlay(SYSTEM_SE_DECIDE);
                    break;
            }

            break;
        case 1:
            msg->AddMsgCursor2(0, 1, 1);
            cursor = msg->GetMsgCursor();
            flags = edparts_info->attr;

            if (cursor == 1 && !(flags & EDIT_PARTS_ATR_NO_STOCK_DESTROY)) {
                int old_num = DestroyNum[0];
                int delta = 0;

                if (buttons_held & MENU_SELECT_KEY_LEFT) {
                    delta -= 1;
                }

                if (buttons_held & MENU_SELECT_KEY_RIGHT) {
                    delta += 1;
                }

                if (buttons_held & MENU_SELECT_KEY_L1) {
                    delta -= 5;
                }

                if (buttons_held & MENU_SELECT_KEY_R1) {
                    delta += 5;
                }

                if (flags & EDIT_PARTS_ATR_NO_REMOVE) {
                    delta = 0;
                }

                DestroyNum[0] += delta;

                if (DestroyNum[0] <= 0) {
                    DestroyNum[0] = 1;
                }

                if (DestroyMaxNum < DestroyNum[0]) {
                    DestroyNum[0] = DestroyMaxNum;
                }

                if (old_num != DestroyNum[0]) {
                    MenuSePlay(SYSTEM_SE_NUMBER);
                }
            }

            msg->SetMsgVolumeNoOne(DestroyNum[0]);

            switch (buttons_pressed) {
                case 1:
                    if (cursor == 0) {
                        form->draw_flag = 0;
                        int             selected = menu->list_info[1].select;
                        CEditPartsInfo *parts_info = {};
                        parts_info = MenuMainMapInfo->GetePartsInfoAtID(
                            menu->stock_list[selected].no);

                        if (parts_info == nullptr) {
                            MenuSePlay(SYSTEM_SE_CANCEL);
                            break;
                        }

                        MenuArg.end_code = EDIT_MODE_PLACE;
                        MenuArg.result[0] =
                            menu->stock_list[selected].no;
                        int made = menu->GetNowMakePartsNum(
                            menu->stock_list[selected].no);
                        int avail = menu->stock_list[selected].num;
                        int room = parts_info->max_num - made;

                        if (room < avail) {
                            avail = room;
                        }

                        int poly_left = menu->polygon_left;

                        if (edparts_info != nullptr && poly_left < edparts_info->polyn[0]) {
                            menu->ExeScript("\x83|\x83\x8A\x83\x93\x95s\x91\xAB");
                            menu->sub_step = 3;
                            MenuArg.end_code = MENU_END_NONE;
                            break;
                        }

                        MenuArg.result[1] = avail;
                        MenuArg.result[2] = parts_info->max_num;
                        MenuArg.result[3] =
                            menu->stock_list[selected].num;

                        if (MenuArg.result[1] <= 0) {
                            menu->ExeScript("\x94z\x92uERROR");
                            menu->sub_step = 3;
                            MenuArg.end_code = MENU_END_NONE;
                            break;
                        }

                        result = 1;
                        MenuSePlay(SYSTEM_SE_DECIDE);
                    }

                    if (cursor == 1) {
                        if (flags & EDIT_PARTS_ATR_NO_REMOVE) {
                            MenuSePlay(SYSTEM_SE_CANCEL);
                        } else if (flags & EDIT_PARTS_ATR_NO_STOCK_DESTROY) {
                            MenuSePlay(SYSTEM_SE_CANCEL);
                        } else {
                            form->draw_flag = 0;
                            menu->sub_step = 2;
                            menu->ExeScript("\x82\xB1\x82\xED\x82\xB7\x81H");
                            msg->SetMsgItemNo(DestroyPartsName, 1);
                            msg->SetMsgVolumeNoOne(DestroyNum[0]);
                        }
                    }

                    break;
                case 2:
                    menu->sub_step = 0;
                    menu->ExeScript("RETURN_CMD");
                    break;
            }

            break;
        case 2:
            choice = msg->YesNoCursor2(0);

            if (choice == 1) {
                GetSaveData()->AddBuildPartsNum(edparts_info->id, -DestroyNum[0]);

                for (int k = 0; k < 4; k++) {
                    EditPartsMaterial *material = edparts_info->GetMaterial(k);

                    if (material != nullptr) {
                        item_no[k] = material->item_no;
                        amount[k] = material->num;

                        if (item_no[k] > 0) {
                            if (amount[k] > 1) {
                                amount[k] = amount[k] / 2;
                            }

                            amount[k] = DestroyNum[0] * amount[k];
                        }

                        GetUserDataMan()->GetItemNotOver(item_no[k], amount[k]);
                    }
                }

                GeoramaMesForceMakeFlag = 1;
                GeoramaMesForceMakeFlag_PaintVer = 1;
                menu->UpdateGeoramaPartsList();
                menu->LoadGeoramaPart(menu->GetNowModeLoadPartsID(), 0);
                MenuSePlay(0x17);
                CheckMenuLine(&menu->list_info[1].select, &menu->list_info[1].top,
                              menu->GetNowViewModeMax(1) + 1, 8);
                menu->ExeScript("\x8D\xDE\x97\xBF"
                                "BACK");
                menu->sub_step = 3;
            }

            if (choice == 2) {
                menu->sub_step = 0;
                menu->ExeScript("RETURN_CMD");
            }

            break;
        case 3:
            if (buttons_pressed != 0) {
                menu->ExeScript("\x94z\x92uERROROFF");
                menu->sub_step = 0;

                if (GetSaveData()->GetBuildPartsNum(edparts_info->id) <= 0) {
                    menu->ReturnSelectMode(0);
                } else {
                    MenuSePlay(SYSTEM_SE_DECIDE);
                }
            }

            break;
    }

    return result;
}

/**
 *
 * Handles part selection and construction from the Georama build list.
 *
 */
int MenuGeoramaMakePush(CMenuGeorama *menu, int keys, int pushed) {
    CEditPartsInfo *parts = {};
    int             old_index = {};
    int             step = {};
    int             old_selected = {};
    int             count = {};
    signed char     manner = {};
    int             river = {};
    short           built = {};
    short           placed = {};

    switch (menu->step) {
        case 0:
            step = georama_menu_local_key(keys);
            old_index = menu->select;
            old_selected = menu->top;
            MenuKeySelectCheck(step, &menu->select, &menu->top, 0,
                               menu->GetNowViewModeMax(0), 8, MENU_CURSOR_LIMIT_CLAMP);
            menu->SetGeoListInfo(menu->view_mode, menu->select, menu->top);

            if (old_selected != menu->top) {
                manner = 0;

                if (old_selected < menu->top) {
                    manner = 1;
                }

                GeoramaMesMakeManner[menu->view_mode] = manner;
            }

            if (old_index != menu->select) {
                menu->LoadGeoramaPart(menu->GetNowModeLoadPartsID(), 1);
                MenuSePlay(SYSTEM_SE_CURSOR);
            }

            switch (pushed) {
                case 1:
                    menu->make_parts = menu->GetNowSelectEditPartsInfo(0, menu->select);

                    if (menu->make_parts == nullptr) {
                        MenuSePlay(SYSTEM_SE_CANCEL);
                    } else {
                        menu->make_cursor = 0;
                        menu->make_item_no = menu->make_parts->id;
                        menu->CBaseMenuClass::make_num = 1;
                        menu->make_num_max = static_cast<short>(menu->make_parts->max_num < 99 ? menu->make_parts->max_num : 99);

                        if (0 > menu->make_parts->map_no) {
                            menu->make_num_max *= 4;
                        }

                        if (menu->make_num_max > 99) {
                            menu->make_num_max = 99;
                        }

                        parts = menu->make_parts;
                        count = menu->make_num_max;

                        if (parts->attr & EDIT_PARTS_ATR_RIVER) {
                            sceVu0FVECTOR position = {0.0f, 0.0f, 0.0f, -1.0f};
                            river = MenuMainMapInfo->GetRiverNum(position);
                            menu->make_num_max = menu->make_num_max - river;
                            built = GetSaveData()->GetBuildPartsNum(menu->make_parts->id);
                            menu->make_num_max = menu->make_num_max - built;
                        } else {
                            placed = GetSaveData()->GetPlaceEditPartsNum(parts->id);
                            menu->make_num_max = menu->make_num_max - placed;
                            built = GetSaveData()->GetBuildPartsNum(menu->make_parts->id);
                            menu->make_num_max = menu->make_num_max - built;
                        }

                        if (menu->make_num_max <= 0) {
                            menu->ExeScript("\x8C\xC0\x8A"
                                            "E\x90\x94\x8D\xEC\x90\xAC");
                            MenuDCMsg[2]->SetMsgVolumeNoOne(count);
                            menu->step = 1;
                        } else {
                            menu->mode = MENU_ASK_MODE_MAKE;
                            menu->step = GEORAMA_MAKE_STEP_CHOOSE_AMOUNT;
                            menu->ExeScript("MAKE_GEOPARTS?");
                            MakeMsgPartsItemInfo(MenuDCMsg[2], menu->make_parts, &menu->make_brd);
                        }
                    }

                    break;
                case 2:
                    menu->ReturnSelectMode(0);
                    break;
                case 4:
                case 0x20:
                    menu->ArrangePartsList(1, 1);
                    menu->LoadGeoramaPart(menu->GetNowModeLoadPartsID(), 1);
                    MenuSePlay(SYSTEM_SE_DECIDE);
                    break;
            }

            break;
        case 1:
            if (pushed != 0) {
                menu->ExeScript("\x83p\x81[\x83"
                                "c1\x82\xC2\x82\xBE\x82\xAFOFF");
                menu->step = 0;
            }

            break;
    }

    return 0;
}

/**
 *
 * Handles the checkpoint page and loads its selected town picture.
 *
 */
int MenuGeoramaCheckPointPush(CMenuGeorama *menu, int keys, int pushed) {
    mgCTextureManager *tex_manager = &mgTexManager;
    char               name[64];
    int                size = {};

    if (CheckGekkaViewMode(CMenuGeoPt->town_no) != 0) {
        int step = menu->step;

        switch (step) {
            case 0:
            case 1:
                if (menu->FadeCheckMenu() != 0) {
                    std::snprintf(name, sizeof(name), "textures/menu/g_heki%d.json", MenuGeoramaViewNowPicNo);
                    u_char *image = reinterpret_cast<u_char *>(MenuCharaLoadStack.stGetTop());

                    if (LoadFile2(name, dc2::memory::AvailableFrom(MenuCharaLoadStack, image), &size, 0) != 0) {
                        tex_manager->DeleteBlock(MenuCommonInfo->tex_block[5]);
                        tex_manager->EnterIMGFile(image, MenuCommonInfo->tex_block[5], nullptr, nullptr);
                        std::snprintf(name, sizeof(name), "heki40%d", MenuGeoramaViewNowPicNo + 1);
                    }

                    MenuGeoramaViewWallPic = tex_manager->GetTexture(name, -1);
                    menu->ExeScript("\x8C\x8E\x89\xD4\x8AG");
                    MenuDCMsg[2]->SetMsgVolumeNoOne(MenuGeoramaViewNowPicNo + 1);
                    menu->step = 2;
                }

                break;
            case 2:
                if (menu->FadeCheckMenu() != 0) {
                    if ((keys & 4) || (keys & 0x10)) {
                        MenuGeoramaViewNowPicNo--;
                        step = 0;

                        if (MenuGeoramaViewNowPicNo < 0) {
                            MenuGeoramaViewNowPicNo = 7;
                        }

                        MenuSePlay(SYSTEM_SE_DECIDE);
                    } else if ((keys & 8) || (keys & 0x20) || (pushed & 1)) {
                        MenuGeoramaViewNowPicNo++;
                        step = 1;

                        if (MenuGeoramaViewNowPicNo > 7) {
                            MenuGeoramaViewNowPicNo = 0;
                        }

                        MenuSePlay(SYSTEM_SE_DECIDE);
                    } else if (pushed & 2) {
                        step = 3;
                        MenuSePlay(SYSTEM_SE_CANCEL);
                    }

                    if (step != 2) {
                        CMenuGeoPt->FadeOutMenu(0x28, 0.0f);
                        menu->step = step;
                    }
                }

                break;
            case 3:
                if (menu->FadeCheckMenu() != 0) {
                    menu->step = 0;
                    menu->ExeScript("\x8C\x8E\x89\xD4\x8AGEND");
                    MenuGeoramaViewWallPic = nullptr;
                    tex_manager->DeleteBlock(MenuCommonInfo->tex_block[5]);
                    menu->ReturnSelectMode(1);
                }

                break;
        }

        return 0;
    }

    switch (menu->sub_step) {
        case 0: {
            int step = georama_menu_local_key(keys);
            int old_select = menu->select;
            int old_top = menu->top;
            MenuKeySelectCheck(step, &menu->select, &menu->top, 0, menu->GetNowViewModeMax(GEORAMA_VIEW_CHECK_POINT),
                               GEORAMA_LIST_LINE_NUM, MENU_CURSOR_LIMIT_CLAMP);
            menu->SetGeoListInfo(menu->view_mode, menu->select, menu->top);

            if (old_top != menu->top) {
                GeoramaMesMakeManner[menu->view_mode] = old_top < menu->top ? 1 : 0;
            }

            if (old_select != menu->select) {
                MenuSePlay(SYSTEM_SE_CURSOR);
                HouseInfoSelectLine = 0;
                HouseInfoSelectMoveInit = 1;
                HouseInfoSelectSelect = 0;
            }

            switch (pushed) {
                case 1:
                    menu->sub_step = 1;
                    HouseInfoCursorAlphaOnOff = 1;
                    menu->ExeScript("GUIDELROUT");
                    break;
                case 2:
                    menu->ReturnSelectMode(0);
                    break;
                case 4:
                case 0x20:
                    menu->ArrangePartsList(2, 1);
                    MenuSePlay(SYSTEM_SE_DECIDE);
                    break;
                case 8:
                    MenuSePlay(SYSTEM_SE_CANCEL);
                    break;
            }

            break;
        }
        case 1: {
            int old_select = HouseInfoSelectSelect;

            if (keys & 1) {
                HouseInfoSelectSelect--;
            }

            if (keys & 2) {
                HouseInfoSelectSelect++;
            }

            if (keys & 0x10) {
                HouseInfoSelectSelect -= 6;
            }

            if (keys & 0x20) {
                HouseInfoSelectSelect += 6;
            }

            if (HouseInfoSelectSelect < 0) {
                HouseInfoSelectSelect = 0;
            }

            if (HouseInfoSelectSelect > 21) {
                HouseInfoSelectSelect = 21;
            }

            if (HouseInfoSelectSelect < HouseInfoSelectLine) {
                HouseInfoSelectLine = HouseInfoSelectSelect;
            }

            if (HouseInfoSelectLine + 6 < HouseInfoSelectSelect) {
                while (HouseInfoSelectLine + 6 < HouseInfoSelectSelect) {
                    HouseInfoSelectLine++;
                }
            }

            if (old_select != HouseInfoSelectSelect) {
                MenuSePlay(SYSTEM_SE_CURSOR);
            }

            switch (pushed) {
                case 2:
                    menu->sub_step = 0;
                    menu->ExeScript("GUIDELRIN");
                    HouseInfoCursorAlphaOnOff = 0;
                    break;
            }

            break;
        }
    }

    return 0;
}

int MenuGeoramaAnalyzeSelect(CMenuGeorama *menu, int keys, int pushed) {
    int old_top = menu->top;
    int max = menu->GetNowViewModeMax(GEORAMA_VIEW_ANALYZE);
    if (max < 0) {
        max = 0;
    }
    if (max >= static_cast<int>(std::size(MenuEditAnalyzeDataSrcListHTable))) {
        max = static_cast<int>(std::size(MenuEditAnalyzeDataSrcListHTable)) - 1;
    }
    int    step = 0;
    float *list_pos = {};

    if ((keys & 1) || (keys & 0x10)) {
        step--;
    }

    if ((keys & 2) || (keys & 0x20)) {
        step++;
    }

    menu->select += step;

    if (menu->select < 0) {
        menu->select = 0;
    }

    if (max < menu->select) {
        menu->select = max;
    }

    MenuEditAnalyzeDataSrcListH_Move = MenuEditAnalyzeDataSrcListHTable[menu->select];

    if (MenuEditAnalyzeDataSrcListH < MenuEditAnalyzeDataSrcListH_Move) {
        MenuEditAnalyzeDataSrcListH_Move = MenuEditAnalyzeDataSrcListH;
    }

    menu->list_target_y[GEORAMA_VIEW_ANALYZE] = 50.0f + menu->analyze_form->y - MenuEditAnalyzeDataSrcListH_Move;
    list_pos = CMenuGeoPt->list_pos[GEORAMA_VIEW_ANALYZE];
    list_pos[1] += (menu->list_target_y[GEORAMA_VIEW_ANALYZE] - list_pos[1]) / 4.0f;

    if (abs(static_cast<int>(list_pos[1] - menu->list_target_y[GEORAMA_VIEW_ANALYZE])) <= 0) {
        list_pos[1] = menu->list_target_y[GEORAMA_VIEW_ANALYZE];
    }

    menu->top = menu->select;
    menu->SetGeoListInfo(menu->view_mode, menu->select, menu->top);

    if (old_top != menu->top) {
        GeoramaReqMakeManner = old_top < menu->top ? 1 : 0;
        GeoramaReqMakeFlag = 1;
        MenuSePlay(SYSTEM_SE_CURSOR);
    }

    if (pushed & 2) {
        menu->ReturnSelectMode(0);
    }

    return 0;
}

/**
 *
 * Handles paint-colour selection on the Georama paint page.
 *
 */
int MenuGeoramaPaintSelect(CMenuGeorama *menu, int keys, int pushed) {
    int    done = 0;
    int    step = 0;
    int    old_cursor = {};
    float *color = {};
    float  red = {};
    float  green = {};
    float  blue = {};
    int    cursor = {};

    if (keys & 1) {
        step -= 1;
    }

    if (keys & 2) {
        step += 1;
    }

    if (keys & 0x10) {
        step -= 7;
    }

    if (keys & 0x20) {
        step += 7;
    }

    old_cursor = menu->paint_select;
    MenuKeySelectCheck(step, &menu->paint_select, &menu->paint_top, 0, 9, 8, MENU_CURSOR_LIMIT_CLAMP);
    menu->SetGeoListInfo(menu->view_mode, menu->paint_select, menu->paint_top);

    if (old_cursor != menu->paint_select) {
        MenuSePlay(SYSTEM_SE_CURSOR);
    }

    switch (pushed) {
        case 1:
        case 8:
        case 4:
            cursor = menu->paint_select;

            if (cursor == GEORAMA_PENKI_NUM) {
                MenuArg.end_code = EDIT_MODE_REPAINT;
                MenuSePlay(SYSTEM_SE_DECIDE);
                menu->ExeScript("COL_END");
                done = 1;
            } else {
                menu->select = 0;
                color = GeoramaColorList[cursor];
                red = color[0] / 128.0f;
                blue = color[2] / 128.0f;
                green = color[1] / 128.0f;
                menu->paint_color[0] = red;
                menu->paint_color[1] = green;
                menu->paint_color[2] = blue;
                menu->paint_color[3] = 1.0f;
                menu->UpdateGeoramaPartColor(1);
                MenuSePlay(0x16);

                if (menu->paint_return != 0) {
                    MenuArg.end_code = EDIT_MODE_PAINT;
                    menu->ExeScript("COL_END");
                    done = 1;
                }
            }

            break;
        case 2:
            menu->ReturnSelectMode(0);
            break;
    }

    return done;
}

/**
 *
 * Dispatches Georama menu input to the active page and starts a requested page transition.
 *
 */

int MenuGeoramaPushKey(int keys, int pushed) {
    if (MenuCommonInfo->key_enable == 0) {
        return 0;
    }

    if (MenuGeoramaPushFunc[CMenuGeoPt->key_arg_no](CMenuGeoPt, keys, pushed) == 1) {
        CMenuGeoPt->mode = MENU_ASK_MODE_CLOSE;
        CMenuGeoPt->ExeScript("\x8FI\x97\xB9\x8F\x88\x97\x9D");
        CMenuGeoPt->LoadGeoramaPart(-1, 0);
    }

    return 0;
}

void CRemovalMenu::MakeNPCList() {
    int i = {};
    int j = {};
    int status = {};
    npc_num = 0;
    i = 1;

    do {
        status = MenuUserDataManPtr->GetPartyCharaStatus(i);

        if (status != 0 && ((i != 13 && i != 2) || GetNowChapter(GetSaveData()) >= 5) &&
            status != 0 && !(status & PARTY_CHARA_STATUS_IN_HOUSE)) {
            npc_list[npc_num++] = i;
        }

        i++;
    } while (i <= 25);

    j = npc_num;

    if (j < REMOVAL_NPC_LIMIT) {
        do {
            npc_list[j] = 0;
            j++;
        } while (j < REMOVAL_NPC_LIMIT);
    }
}

int CRemovalMenu::KeyStep() {
    int      closed = 0;
    int      select_key = {};
    int      push = {};
    CDC2Mes *ask_mes = {};
    CDC2Mes *yes_mes = {};
    CDC2Mes *list_mes = {};
    CDC2Mes *npc_mes = {};
    int      remake = {};
    int      reload = {};
    int      action = {};
    int      size = {};
    char     part_name[32];
    int      old_top = {};
    u8      *pack = {};
    int      first = {};

    if (MenuMainMapInfo == nullptr) {
        return 1;
    }

    select_key = MenuCommonInfo->CheckSelectKey();
    push = MenuCommonInfo->CheckPushButton();
    ask_mes = MenuDCMsg[1];
    remake = 0;
    yes_mes = MenuDCMsg[2];
    CDC2Mes *info_mes = {};
    info_mes = MenuDCMsg[3];
    list_mes = MenuDCMsg[4];
    npc_mes = MenuDCMsg[5];
    reload = 0;

    switch (mode) {
        case MENU_ASK_MODE_OPEN:
            if (HouseDrawInfo == nullptr) {
                return 1;
            }

            if (ReadBGSync() == 0) {
                MakeNPCList();
                dc2::io::FileRead read_b_g = dc2::io::FindBackgroundRead(0);

                if (static_cast<bool>(read_b_g)) {
                    MenuDataAnalyze(reinterpret_cast<char *>(AssetDirectoryRead(reinterpret_cast<unsigned int *>(read_b_g.Bytes().data()), "npcmove.cfg.json", &size)), size, &data_stack);
                    script = reinterpret_cast<char *>(AssetDirectoryRead(reinterpret_cast<unsigned int *>(read_b_g.Bytes().data()), "npcmove_com.cfg.json", &script_size));
                    AttachMessageForm();
                    MenuMesForm[0]->rgba_bit = 8;
                    house_form = MenuPosData->GetFormInfo("\x89\xC6\x8F\xEE\x95\xF1");
                    HouseInfoFormGrobal = house_form;
                    list_form = MenuPosData->GetFormInfo("\x8C\xF3\x95\xE2\x83\x8A\x83X\x83g");
                    clip_form = MenuPosData->GetFormInfo("ListClip");
                    npc_win_form = MenuPosData->GetFormInfo("polywin");
                    npc_chr_form = MenuPosData->GetFormInfo("polychr");

                    if (list_form != nullptr) {
                        scroll_parts[0] = list_form->GetPartInfo("bar0");
                        scroll_parts[1] = list_form->GetPartInfo("bar1");
                        scroll_parts[2] = list_form->GetPartInfo("bar2");

                        for (int i = 0; i < 9; i++) {
                            std::snprintf(part_name, sizeof(part_name), "ULine%d", i);
                            line_parts[i] = list_form->GetPartInfo(part_name);
                        }
                    }

                    list_jump = 1;
                    list_scroll_dir = 0;
                    u8 *pack = reinterpret_cast<u8 *>(AssetDirectoryRead(reinterpret_cast<unsigned int *>(read_b_g.Bytes().data()), "g.json", nullptr));
                    int tex_block = MenuCommonInfo->tex_block[3];
                    mgTexManager.EnterIMGFile(pack, tex_block, nullptr, nullptr);
                    mgTexManager.EnterIMGFile(reinterpret_cast<u8 *>(AssetDirectoryRead(reinterpret_cast<unsigned int *>(read_b_g.Bytes().data()), "npcdata.json", nullptr)), tex_block, nullptr, nullptr);
                    Tex_Georama = mgTexManager.GetTexture("geo", tex_block);
                    MenuPosData->ResetTextureInfoAll();
                    ExeScript("INIT_END");
                    const auto *message_bytes = AssetDirectoryRead(reinterpret_cast<unsigned int *>(read_b_g.Bytes().data()), "npcmsg.mes", &size);
                    const auto  message_pack = message_bytes != nullptr && size > 0 ? dc2::text::MessageTable::Parse(
                                                                                          {reinterpret_cast<const std::byte *>(message_bytes), static_cast<std::size_t>(size)})
                                                                                    : dc2::text::MessageTable{};
                    MenuCommandAnalyzeInfo.system_mes_buff[0] = GetSystemMesBuffer();
                    MenuCommandAnalyzeInfo.system_mes_buff[1] = message_pack;
                    MenuCommandAnalyzeInfo.mes_buff[0] = GetMenuMainMessageBuffer();
                    MenuCommandAnalyzeInfo.mes_buff[1] = message_pack;

                    if (LanguageCode == 0) {
                        ExeScript("MSG_INIT");
                    } else {
                        ExeScript("MSG_INITUSA");
                    }

                    if (special_house == 1) {
                        CMenuPosDataForm *form = MenuMesForm[1];
                        form->x = 76.0f;
                        form->y = 160.0f;

                        if (LanguageCode > 0) {
                            form = MenuMesForm[1];
                            form->x = 54.0f;
                            form->y = 160.0f;
                        }
                    }

                    remake = 1;
                }

                MenuGeoramaStack.Align64();
                auto *character_storage = dc2::memory::NewArray<u_long128>(MenuGeoramaStack, 0xFA00);
                if (character_storage == nullptr) {
                    return 1;
                }
                chara_stack.stSetChildBuffer(MenuGeoramaStack, character_storage, 0xFA00);
                MenuGeoramaStack.Align64();
                int rest = MenuGeoramaStack.stGetRest();
                if (rest <= 0 || !MenuChangeNpcMemory.stShareBuffer(MenuGeoramaStack, std::span(MenuGeoramaStack.stGetTop(), static_cast<std::size_t>(rest)))) {
                    return 1;
                }
                MenuCommonInfo->key_enable = 1;
                key_arg_no = 0;
                mode = MENU_ASK_MODE_NONE;
                step = 0;
            }

            break;
        case MENU_ASK_MODE_CLOSE:
            exit_wait++;

            if (exit_wait >= 10) {
                closed = 1;
            }

            break;
        default:
            action = REMOVAL_ACTION_NONE;

            switch (key_arg_no) {
                case 0:
                    switch (step) {
                        case 0: {
                            int last = 1;

                            if (special_house == 1) {
                                last = 0;
                            }

                            ask_mes->AddMsgCursor2(0, last, 1);

                            switch (push) {
                                case 1:
                                case 4: {
                                    int cursor = ask_mes->GetMsgCursor();

                                    if (special_house == 1) {
                                        cursor = 1;
                                    }

                                    switch (cursor) {
                                        case 0:
                                            MenuSePlay(SYSTEM_SE_DECIDE);
                                            action = REMOVAL_ACTION_CLOSE;
                                            MenuArg.end_code = MENU_END_ENTER_HOUSE;
                                            break;
                                        case 1:
                                            MenuSePlay(SYSTEM_SE_DECIDE);

                                            if (house->npc_no[0] <= 0) {
                                                if (npc_num <= 0) {
                                                    MenuSePlay(SYSTEM_SE_CANCEL);
                                                } else {
                                                    key_arg_no = 1;
                                                    step = 0;
                                                    ExeScript("TO_NPCSEL");
                                                    model_wait = 0;
                                                    reload = 1;
                                                    model_state = 1;

                                                    if (npc_num <= select) {
                                                        select = npc_num - 1;
                                                    }

                                                    if (npc_num <= top + 8) {
                                                        top = npc_num - 8;
                                                    }

                                                    if (top < 0) {
                                                        top = 0;
                                                    }
                                                }
                                            } else {
                                                ExeScript("MSG_IS_RETURN_TRAIN");
                                                char *name[1] = {GetNPCName(house->npc_no[0])};
                                                yes_mes->SetMsgItemNo(name, 1);
                                                ask_mes->cursor_on = 0;
                                                step = 1;
                                            }

                                            break;
                                    }

                                    break;
                                }
                                case 2:
                                    action = REMOVAL_ACTION_CLOSE;
                                    MenuSePlay(SYSTEM_SE_CANCEL);
                                    break;
                            }

                            break;
                        }
                        case 1: {
                            int answer = yes_mes->YesNoCursor2(1);

                            if (answer == 1) {
                                MenuUserDataManPtr->LeaveHouse(house->npc_no[0]);
                                house->npc_no[0] = 0;
                                ExeScript("MSG_RETURN_TRAIN_AFTER");
                                ask_mes->cursor_on = 1;

                                if (special_house == 1) {
                                    ask_mes->MakeMsg(0x11F8);
                                }

                                MakeNPCList();
                                step = 0;
                                remake = 1;
                            }

                            if (answer == 2) {
                                ask_mes->cursor_on = 1;
                                ExeScript("MSG_ISMOVE_END");
                                step = 0;
                                MenuSePlay(SYSTEM_SE_CANCEL);
                            }

                            break;
                        }
                    }

                    break;
                case 1:
                    switch (step) {
                        case 0: {
                            int move = georama_menu_local_key(select_key);
                            old_top = top;

                            if (MenuKeySelectCheck(move, &select, &top, 0, npc_num, GEORAMA_LIST_LINE_NUM, MENU_CURSOR_LIMIT_CLAMP) != 0) {
                                model_wait = 0x10;
                                reload = 1;
                                MenuSePlay(SYSTEM_SE_CURSOR);
                            }

                            if (old_top != top) {
                                if (old_top < top) {
                                    list_scroll_dir = 1;
                                } else {
                                    list_scroll_dir = 0;
                                }
                            }

                            switch (push) {
                                case 1:
                                case 4:
                                    action = REMOVAL_ACTION_PICK;
                                    break;
                                case 2:
                                    action = REMOVAL_ACTION_BACK;
                                    MenuSePlay(SYSTEM_SE_CANCEL);
                                    break;
                            }

                            break;
                        }
                        case 1: {
                            int answer = yes_mes->YesNoCursor2(1);

                            if (answer == 1) {
                                action = REMOVAL_ACTION_MOVE_IN;
                            }

                            if (answer == 2) {
                                action = REMOVAL_ACTION_CANCEL;
                            }

                            break;
                        }
                        case 2:
                            if (push != 0) {
                                ExeScript("NOT_\x88\xDA\x8FZEND");
                                step = 0;
                            }

                            break;
                    }

                    break;
            }

            switch (action) {
                case REMOVAL_ACTION_PICK: {
                    int npc = npc_list[select];
                    int live = CheckLiveChara(MenuMainScene->now_map_no, MenuMainMapInfo, place_no, npc);

                    if (npc == 6 && CheckBitFlagMenu(0x132) == 0) {
                        live = 0;
                    }

                    if (DebugFlag != 0 && (GamePad__2.On(PAD_R2) | GamePad__2.On(PAD_R1)) != 0) {
                        live = 1;
                    }

                    if (live == 0) {
                        ExeScript("NOT_\x88\xDA\x8FZ");
                        MenuDCMsg[6]->MakeMsg(GetPartyCharaMessage(npc, 10, 0));
                        MenuDCMsg[6]->StepMsg();
                        AdjustNPCTalk(MenuDCMsg[6], &chara);
                        MenuDCMsg[6]->StepMsg();
                        MenuDCMsg[6]->DrawMsg();
                        step = 2;
                    } else {
                        select_npc = npc_list[select];
                        char *names[2] = {GetNPCName(select_npc), parts_info->edit_name};
                        step = 1;
                        ExeScript("MSG_ISMOVE_COMFIRM");
                        yes_mes->SetMsgItemNo(names, 2);
                    }

                    break;
                }
                case REMOVAL_ACTION_MOVE_IN:
                    MenuUserDataManPtr->SetPartyCharaStatus(select_npc, PARTY_CHARA_STATUS_IN_HOUSE);
                    house->npc_no[0] = select_npc;
                    MakeNPCList();
                    remake = 1;
                    ExeScript("MSG_ISMOVE_END");
                    ExeScript("BACK_FROM_NPCSEL");
                    step = 0;
                    key_arg_no = 0;
                    model_state = 0;
                    MenuSePlay(SYSTEM_SE_DECIDE);
                    break;
                case REMOVAL_ACTION_CANCEL:
                    ExeScript("MSG_ISMOVE_END");
                    step = 0;
                    MenuSePlay(SYSTEM_SE_CANCEL);
                    break;
                case REMOVAL_ACTION_BACK:
                    key_arg_no = 0;
                    ExeScript("BACK_FROM_NPCSEL");
                    model_state = 0;
                    break;
                case REMOVAL_ACTION_WAIT:
                    break;
                case REMOVAL_ACTION_CLOSE:
                    mode = MENU_ASK_MODE_CLOSE;
                    ExeScript("\x8FI\x97\xB9\x8F\x88\x97\x9D");
                    exit_wait = 0;

                    if (MenuArg.end_code != MENU_END_ENTER_HOUSE && house != nullptr && first_npc != house->npc_no[0]) {
                        MenuArg.end_code = MENU_END_RESIDENT_CHANGE;
                        MenuArg.result[0] = 1;
                        MenuArg.result[1] = house->npc_no[0];
                    }

                    break;
            }

            break;
    }

    int npc = npc_list[select];

    if (0 < model_wait) {
        model_wait--;

        if (model_wait == 0) {
            model_state = 1;
        }
    }

    float model_pos[4] = {14.0f, -3.0f, 0.0f, 1.0f};

    switch (model_state) {
        case 0:
            if (npc_chr_form != nullptr) {
                npc_chr_form->SetActionCharaPtr(nullptr, -1, -1);
            }

            break;
        case 1:
            MenuChangeNpcMemory.stReset();
            StartReadBG();
            MenuNPCModelLoad(&MenuChangeNpcMemory, npc, 1);
            npc_chr_form->SetActionCharaPtr(nullptr, -1, -1);
            ExeScript("FADEINIT_CHR");
            model_state = 2;
            break;
        case 2:
            if (ReadBGSync() == 0) {
                chara_stack.stReset();
                chara.Initialize(nullptr);
                MenuNPCLoadCheck(&chara, &chara_stack, MenuCommonInfo->tex_block[4]);
                chara.SetScale(1.0f, 1.0f, 1.0f);
                chara.SetPosition(model_pos);

                if (npc == 9) {
                    MenuAdjustPolygonScale(&chara, 5.655f);
                } else {
                    MenuAdjustPolygonScale(&chara, 6.96f);
                }

                chara.SetRotation(0.0f, -0.07853982f, 0.0f);
                chara.SetMotion("\x97\xA7\x82\xBF", 0, 1);
                npc_chr_form->SetActionCharaPtr(&chara, MenuCommonInfo->tex_block[4], -1);
                npc_chr_form->counter = -14;
                model_state = 3;
                mgTexManager.TexAnimeAllOff(MenuCommonInfo->tex_block[4]);
            }
        case 3:
            chara.Step();

            if (npc_chr_form->counter == 14) {
                ExeScript("FADEIN_CHR");
            }

            break;
    }

    MenuPosData->FormStep();
    MenuPlacedHouseMessMake(parts_info, house, remake);

    if (house != nullptr) {
        if (house->npc_no[0] <= 0) {
            ask_mes->MakeMsg(special_house * 30 + 0x960);
        } else {
            ask_mes->MakeMsg(special_house * 30 + 0x962);
        }
    }

    MenuPlacedHousePosLinkMes();

    if (reload != 0 && npc_mes != nullptr) {
        int talk[2] = {GetPartyCharaMessage(npc, 0, 0), GetPartyCharaMessage(npc, 3, 0)};
        npc_mes->SetMsgItemNo(talk, 2);
        npc_mes->MakeMsg(0xB);
        npc_mes->StepMsg();
    }

    CMenuPosDataForm *culture_form = MenuPosData->GetFormInfo("CPVIEW");

    if (culture_form != nullptr) {
        int flag = GetSaveData()->GetBitFlag(SAVE_FLAG_HEIM_FIRE_OUT);
        int cpoint_no = 0;

        if (flag == 0 && MenuMainScene->now_map_no == 3) {
            cpoint_no |= 1;
        }

        culture_form->SetNumber("CP", MenuMainMapInfo->CultureAnalyzeParts(place_no, cpoint_no));
    }

    if (list_form != nullptr && list_mes != nullptr) {
        int put_pos[2];

        if (clip_form != nullptr) {
            list_form->GetPutPosXY("clippos", put_pos[0], put_pos[1]);
            CMenuPosDataForm *clip = clip_form;
            clip->x = put_pos[0];
            clip->y = put_pos[1];
        }

        if (info_mes != nullptr) {
            list_form->GetPutPosXY("btnmsg", put_pos[0], put_pos[1]);
            info_mes->SetMovePosGyou(0, put_pos[0], put_pos[1]);
        }

        int top_line[2] = {top, top - 1};
        first = top_line[list_scroll_dir];
        float list_pos[2];
        list_form->GetPutPosXY("infomsg", list_pos[0], list_pos[1]);
        int line_h = list_mes->font_h;
        list_pos[1] -= top * line_h;
        list_x = list_pos[0];
        CalcMenu1(list_pos[1], &list_y, 4.0f, 0.0f, list_jump);
        list_jump = 0;
        list_pos[1] = list_y + first * line_h;
        int   no = first;
        char *names[9];
        int   line_pos[12][2];
        int   i = 0;

        for (; no < 0; no++, i++) {
            names[i] = nullptr;
            line_pos[i][0] = static_cast<int>(list_pos[0]);
            line_pos[i][1] = static_cast<int>(list_pos[1]);
            line_parts[i]->y = 20.0f + list_pos[1] - list_form->y;
            list_pos[1] += line_h;
        }

        for (; i < 9;) {
            names[i] = GetNPCName(npc_list[first + i]);
            line_pos[i][0] = static_cast<int>(list_pos[0]);
            line_pos[i][1] = static_cast<int>(list_pos[1]);
            line_parts[i]->y = 20.0f + list_pos[1] - list_form->y;

            if (258.0f < line_parts[i]->y) {
                line_parts[i]->y = -130.0f;
            }

            list_pos[1] += line_h;
            i += 1;
        }

        list_mes->SetMsgItemNo(names, 9);
        list_mes->SetMsgItemPos(&line_pos[0][0], 9);
        list_mes->MakeMsg(0x3A);
        int   bar_pos[2] = {static_cast<int>(216.0f + list_form->x), static_cast<int>(list_form->y - 44.0f)};
        int   bar_size[2] = {8, 200};
        float bar_lines[2] = {static_cast<float>(npc_num), 8.0f};

        if (bar_lines[0] < 8.0f) {
            bar_lines[0] = 8.0f;
        }

        LocalFunc_AdjustScrlBar(scroll_parts, bar_pos, bar_size, top, bar_lines[0], bar_lines[1], 0);
    }

    SetMessagePositionNPCForm(npc_win_form, npc_mes);

    switch (mode) {
        case MENU_ASK_MODE_NONE:
            switch (key_arg_no) {
                case 1: {
                    int cursor_pos[2];
                    list_form->GetPutPosXY("infomsg", cursor_pos[0], cursor_pos[1]);
                    cursor_pos[0] -= 0x28;
                    cursor_pos[1] += list_mes->font_h * (select - top);
                    MenuCommonInfo->MenuPosStep(cursor_pos, nullptr);
                    break;
                }
            }

            break;
    }

    return closed;
}

void MenuRemovalInit(mgCMemory *stack, int *arg) {
    static char *fname[2] = {"npcmove.pac", nullptr};
    int          size = {};

    dc2::menu::ResetGeoramaMenus();
    if (stack == nullptr) {
        return;
    }
    int rest = stack->stGetRest();
    if (rest <= 0 || !MenuGeoramaStack.stShareBuffer(*stack, std::span(stack->stGetTop(), static_cast<std::size_t>(rest)))) {
        return;
    }
    MenuCapture(MenuCommonInfo->tex_block[0], &MenuGeoramaStack, 1);
    MenuMainImageDataEnter(MenuCommonInfo->tex_block[1]);
    MenuDrawEnv->camera.SetRef(0.0f, 0.0f, 0.0f);
    MenuDrawEnv->camera.SetPos(0.0f, 0.0f, 500.0f);
    MenuMainMapInfo = static_cast<CEditMap *>(MenuMainScene->GetMap(MenuMainScene->active_map));
    if (dc2::menu::CreateRemovalController(MenuGeoramaStack) == nullptr) {
        return;
    }
    HouseInfoSelectMoveInit = 1;
    Tex_Georama = nullptr;
    HouseInfoCursorAlphaOnOff = 0;
    HouseInfoCursorAlpha = 0;
    HouseInfoSelectLine = 0;
    HouseInfoSelectSelect = 0;
    HouseInfoFormGrobal = nullptr;
    MenuDataAnalyze(GetMenuMainPosCfgBuffer(&size), size, &MenuGeoramaStack);

    MenuCommonInfo->AttachFuncData();
    RemovalMenuPtr->place_no = MenuArg.param[0];

    if (MenuMainMapInfo != nullptr) {
        HousePartsID = RemovalMenuPtr->place_no;
        RemovalMenuPtr->parts = MenuMainMapInfo->GetePlaceParts(RemovalMenuPtr->place_no);

        if (RemovalMenuPtr->parts != nullptr) {
            RemovalMenuPtr->parts_info = RemovalMenuPtr->parts->info;

            if (RemovalMenuPtr->parts_info->id == EDIT_GEO_NPC_PARTS_ID) {
                RemovalMenuPtr->special_house = 1;
            }
        }

        if (RemovalMenuPtr->parts != nullptr) {
            RemovalMenuPtr->house = RemovalMenuPtr->parts->house;

            if (RemovalMenuPtr->house != nullptr) {
                RemovalMenuPtr->first_npc = RemovalMenuPtr->house->npc_no[0];
            }
        }
    }

    HouseDrawInfo = RemovalMenuPtr->house;
    SetEditMenuEnv();
    CMenuPosDataForm *form = MenuPosData->GetFormInfo("timeboard");

    if (form != nullptr) {
        form->draw_flag = 0;
    }

    form = MenuPosData->GetFormInfo("areaboard");

    if (form != nullptr) {
        form->draw_flag = 0;
    }

    MenuPosData->AttachCommonTexInfo();
    MenuPosData->InitDrawList();
    MenuPosData->ResetTextureInfoAll();
    AttachMessageForm();
    MenuMesForm[0]->draw_flag = 0;
    MenuMesForm[1]->draw_flag = 0;
    MenuCommonReadData(&MenuGeoramaStack, fname, 0);
    MenuGeoramaStack.Align64();

    if (MenuCommonInfo->cursor_form != nullptr) {
        MenuCommonInfo->cursor_form->draw_flag = 0;
    }

    MenuArg.result[0] = 0;
}

int MenuRemovalKey() {
    if (RemovalMenuPtr == nullptr) {
        return 1;
    }
    const int result = RemovalMenuPtr->KeyStep();
    if (result != 0) {
        dc2::menu::ResetGeoramaMenus();
    }
    return result;
}

void MenuRemovalDraw() {
    if (RemovalMenuPtr != nullptr) {
        MenuPosData->FormDraw();
    }
}

#include "common.h"

#include <algorithm>
#include <array>
#include <cstring>
#include <iterator>
#include <memory>
#include <vector>

#include "editmap.hpp"
#include "editmenu.hpp"
#include "editparts.hpp"
#include "mainloop.hpp"
#include "menudraw.hpp"
#include "savedata.hpp"
#include "stubs/editmenu.hpp"

namespace {

/**
 * Host storage behind the Georama menu's lists of placed parts, sized to the town.
 */
struct GeoramaLists {
    std::vector<s32>                     place_no;    /**< Storage of CMenuGeorama::place_no. */
    std::vector<std::array<char, 0x40>>  place_name;  /**< Storage of CMenuGeorama::place_name. */
    std::vector<GEORAMA_PARTS_LIST_ITEM> placed_list; /**< Storage of CMenuGeorama::placed_list. */
    std::vector<GEORAMA_PARTS_LIST_ITEM> house_list;  /**< Storage of CMenuGeorama::house_list. */
};

GeoramaLists &Lists() {
    static GeoramaLists lists;
    return lists;
}

} // namespace

// Retail's list building, into lists as long as the town has part slots, with the culture points shown once.
void CMenuGeorama::UpdateGeoramaPartsList() {
    if (MenuMainMapInfo == nullptr) {
        return;
    }

    // The placed list shows one line past its parts, so it always has room for an empty one.
    const auto capacity = std::max<std::size_t>(GEORAMA_PARTS_LIST_MAX, static_cast<std::size_t>(std::max(MenuMainMapInfo->edit_parts_max, 0)) + 1);
    auto      &lists = Lists();
    lists.place_no.assign(capacity, -1);
    lists.place_name.assign(capacity, {});
    lists.placed_list.assign(capacity, {});
    lists.house_list.resize(capacity);
    place_no = lists.place_no.data();
    place_name = reinterpret_cast<char (*)[0x40]>(lists.place_name.data());
    placed_list = lists.placed_list.data();
    house_list = lists.house_list.data();

    place_num = MenuMainMapInfo->GetePlaceIDList(place_no, static_cast<int>(capacity));
    std::memset(static_cast<void *>(stock_list), 0, sizeof(stock_list));
    stock_num = 0;
    placed_num = 0;
    house_num = 0;

    bool listed = false;
    for (int i = 0; i < place_num; ++i) {
        CEditParts *parts = MenuMainMapInfo->GetePlaceParts(place_no[i]);
        if (parts == nullptr) {
            continue;
        }
        CEditPartsInfo *info = parts->info;
        if (info == nullptr || (info->attr & EDIT_PARTS_ATR_NO_REFUND) != 0) {
            continue;
        }
        listed = true;
        dc2::text::Copy(lists.place_name[i], dc2::text::View(info->edit_name));
        if (parts->state == EDIT_PARTS_STATE_PLACED && parts->GetPartsType() == 1) {
            GEORAMA_PARTS_LIST_ITEM &entry = house_list[house_num++];
            entry.no = place_no[i];
            entry.num = 1;
            dc2::text::Copy(entry.name, dc2::text::View(info->edit_name));
        }
        if (parts->state != EDIT_PARTS_STATE_NONE) {
            continue;
        }
        GEORAMA_PARTS_LIST_ITEM &placed = placed_list[placed_num++];
        placed.no = place_no[i];
        placed.num = 1;
        dc2::text::Copy(placed.name, dc2::text::View(info->edit_name));
        // Retail counts the stock of unplaced parts here too, and then rebuilds the stock from the save below.
        auto *found = std::find_if(stock_list, stock_list + stock_num, [&](const GEORAMA_PARTS_LIST_ITEM &item) { return item.no == info->id; });
        if (found != stock_list + stock_num) {
            ++found->num;
        } else if (stock_num < GEORAMA_PARTS_LIST_MAX) {
            GEORAMA_PARTS_LIST_ITEM &stock = stock_list[stock_num++];
            stock.no = info->id;
            stock.num = 1;
            dc2::text::Copy(stock.name, dc2::text::View(info->edit_name));
        }
    }

    if (listed && cpview_form != nullptr) {
        int culture_arg = 0;
        if (GetSaveData()->GetBitFlag(SAVE_FLAG_HEIM_FIRE_OUT) == 0 && CMenuGeoPt->town_no == 3) {
            culture_arg |= 1;
        }
        cpview_form->SetNumber(const_cast<char *>("CP"), MenuMainMapInfo->CultureAnalyze(culture_arg));
    }

    CSaveData *save_data = GetSaveData();
    stock_num = 0;
    for (int i = 0; i < 0x80; ++i) {
        CEditPartsInfo *info = MenuMainMapInfo->GetePartsInfoAtID(i);
        if (info == nullptr) {
            continue;
        }
        const int owned = save_data->GetBuildPartsNum(info->id);
        if (owned <= 0) {
            continue;
        }
        GEORAMA_PARTS_LIST_ITEM &stock = stock_list[stock_num++];
        stock.no = info->id;
        stock.num = owned;
        if (info->edit_name != nullptr) {
            dc2::text::Copy(stock.name, dc2::text::View(info->edit_name));
        }
    }
    ArrangePartsList(0, 0);

    make_num = 0;
    for (int i = 0; i < GEORAMA_PARTS_LIST_MAX; ++i) {
        CEditPartsInfo *make_info = MenuMainMapInfo->GetePartsInfo(i);
        if (make_info == nullptr) {
            break;
        }
        if ((make_info->attr & EDIT_PARTS_ATR_NO_REFUND) != 0) {
            continue;
        }
        int       *made_end = PartsMakeOkTable + std::clamp(PartsMakeOkTableNum, 0, static_cast<int>(std::size(PartsMakeOkTable)));
        const bool made_ok = std::find(PartsMakeOkTable, made_end, make_info->id) != made_end;
        if (made_ok || make_info->edit_name == nullptr) {
            continue;
        }
        GEORAMA_PARTS_LIST_ITEM &make = make_list[make_num++];
        make.no = i;
        dc2::text::Copy(make.name, dc2::text::View(make_info->edit_name));
        make.num = make_info->polyn[0];
    }
    ArrangePartsList(1, 0);
    ArrangePartsList(2, 0);
}
