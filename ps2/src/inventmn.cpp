#include "common.h"
#include "mw_runtime.h"

#include <cmath>
#include <cstdio>
#include <cstring>

#include "actionchara.hpp"
#include "dataread.hpp"
#include "font.hpp"
#include "gamepad.hpp"
#include "inventmn.hpp"
#include "mainloop.hpp"
#include "mapselect.hpp"
#include "menuaqua.hpp"
#include "menuchr.hpp"
#include "menucls1.hpp"
#include "menucommon.hpp"
#include "menumain.hpp"
#include "menuop.hpp"
#include "menusys.hpp"
#include "menusystemdata.hpp"
#include "mg_dataset.hpp"
#include "mg_math.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "nd_meswin.hpp"
#include "npccfg.hpp"
#include "savedata.hpp"
#include "scriptinterpreter.hpp"
#include "snd_mngr.hpp"
#include "sound.hpp"

/**
 *
 * Stores an inventory cursor position.
 *
 */
struct CursorPos {
    int x; /**< Horizontal cursor coordinate. */
    int y; /**< Vertical cursor coordinate. */
};

extern int                 menu_debug_flag;
extern short               MenuItemCmdArgPos;

/**
 *
 * Column and row counts of the inventory photo grid.
 *
 */
static int maxtbl_5171[2] = {
    15, 2
};

/**
 *
 * Visible column and row counts of the inventory photo grid.
 *
 */
static int viewnum_5172[2] = {
    3, 2
};

/**
 *
 * Inventory mode reached when leaving each photo menu.
 *
 */
static short nextmodetbl_5183[12] = {
    INVENT_MODE_THINK_ALBUM_BUTTON, -1, -1, -1, INVENT_MODE_ALBUM_VIEW, -1,
    INVENT_MODE_PHOTO_ALBUM_BUTTON, -1, -1, -1, -1, INVENT_MODE_THINK
};

/**
 *
 * Icon prefixes used by the invention memo list.
 *
 */
static char *gaiji_table_4737[3] = {
    "[bulb2]",
    "[bulb3]",
    "[heart]"
};

/**
 *
 * Column and row counts of the photo album grid.
 *
 */
static int maxtbl_album_5223[2] = {
    25, 2
};

/**
 *
 * Visible column and row counts of the photo album grid.
 *
 */
static int viewnum_album_5224[2] = {
    5, 2
};

/**
 *
 * Grid overlay codes used while navigating the album.
 *
 */
static int overcode_album_5225[4] = {
    0, 0, 2, 0
};

extern short               menu_item_swap_sndtbl[];

/**
 *
 * Colours used by the two invention success strips.
 *
 */
static u8 invent_color_tbl[3][2][4] = {
    {{0, 0, 0, 0}, {0, 0, 255, 128}},
    {{240, 140, 80, 80}, {255, 255, 0, 128}},
    {{0, 0, 0, 0}, {128, 128, 128, 128}}
};

/**
 *
 * Form names for the two invention grade effect rows.
 *
 */
static char *invent_grade_fff[2] = {
    "f0",
    "f1"
};

extern mgCMemory           MenuInventStack;
extern CActionChara       *MenuActionChara[7];
extern CMenuPosDataForm   *GiftBoxViewForm;

enum {
    K_COMMAND_HANDLED = -1
};

enum {
    K_COMMAND_NONE = 0
};

enum {
    K_COMMAND_REJECT = 5
};

enum {
    K_COMMAND_ITEM_COMMAND = 10
};

enum {
    K_COMMAND_SWAP_ITEM = 20
};

enum {
    K_COMMAND_GET_ITEM_ALL = 30
};

enum {
    K_COMMAND_TAKE_PHOTO = 40
};

enum {
    K_COMMAND_UNUSED = 50
};

enum {
    K_COMMAND_SWAP_BACK = 52
};

enum {
    K_COMMAND_RETURN_ITEM = 54
};

enum {
    K_COMMAND_SET_CIRCLE = 60
};

enum {
    K_COMMAND_LEAVE_CIRCLE = 65
};

enum {
    K_COMMAND_BACK_MODE = 66
};

enum {
    K_COMMAND_CHECK_IDEAS = 70
};

enum {
    K_COMMAND_PICK_CREATED = 80
};

enum {
    K_COMMAND_EXTEND = 90
};

enum {
    K_COMMAND_CONFIRM_BOARD = 91
};

enum {
    K_COMMAND_OPEN_MEMO = 100
};

enum {
    K_COMMAND_CLOSE_MEMO = 105
};

enum {
    K_COMMAND_QUIT = 110
};

extern char           at_2244[];
extern char           at_2245[];
extern char           at_2247[];
extern char           at_2248[];
extern char           at_2249[];
extern char           at_2250[];
extern char           at_2251[];
extern char           at_2252[];

/**
 *
 * Marks the three invention idea slots that match a recipe.
 *
 */
struct FoundSlots {
    int v[3]; /**< Match flag for each idea slot. */
};

extern FoundSlots at_2776;

/**
 *
 * Cursor frame type for each inventory menu mode.
 *
 */
static s8 wakutype_3203[12] = {
    0, -1, -1, 0, 0, 0, 0, -1, 0, -1, -1, 0
};

/**
 *
 * Holds two item names for the inventory display.
 *
 */
struct ItemNameList2 {
    char *name[2]; /**< Item name in each slot. */
};

extern mgCMemory           MenuInventCharaStack;
extern mgCMemory           MenuInventMCStack;
extern char                at_4354[];
extern char                at_4355[];
extern char                at_4356[];
extern char                at_4357[];
extern char                at_4358[];
extern char                at_4359[];
extern char                at_4360[];
extern char                at_4361[];
extern char                at_4362[];
extern char                at_4363[];
extern char                at_4364[];
extern char                at_4365[];
extern char                at_4366[];
extern char                at_4367__2[];
extern char                at_4368__2[];
extern char                at_4369[];
extern char                at_4370[];
extern char                at_4371[];
extern char                at_4372[];
extern char                at_4373[];
extern char                at_4374[];
extern char                at_4375[];
extern char                at_4376[];
extern char                at_4377[];
extern char                at_4379[];
extern char                at_4380[];
extern ItemNameList2       at_3739;
extern ItemNameList2       at_3765;

/**
 *
 * Selects the confirmation prompt shown for an inventory action.
 *
 */
enum INVENT_ASK_MODE {
    INVENT_ASK_COMMAND = 0,
    INVENT_ASK_ZOOM = 1,
    INVENT_ASK_DELETE = 2,
    INVENT_ASK_TO_ALBUM = 3,
    INVENT_ASK_DELETE_UNUSED = 4,
    INVENT_ASK_SET_BOARD = 5,
    INVENT_ASK_FROM_ALBUM = 6,
    INVENT_ASK_DELETE_ALL = 7
};

/**
 *
 * Localized label for an undiscovered invention card.
 *
 */
static char *NewComer_5648[7] = {
    "     ",
    "New Invention",
    "Nouvelle Invention",
    "Neue Erfindung",
    "Nuova Invenzione",
    "Nuevo invento",
    "New Invention"
};

/**
 *
 * Decimal widths used to display the invention count.
 *
 */
static int digit_tbl3_5641[8] = {
    3, 3, 3, 3, 3, 3, 3, 3
};

/**
 *
 * Maps inventory commands to their message numbers.
 *
 */
enum INVENT_COMMAND_MSG {
    INVENT_CMD_ZOOM = 0x1518,
    INVENT_CMD_DELETE = 0x1519,
    INVENT_CMD_TO_ALBUM = 0x151A,
    INVENT_CMD_FROM_ALBUM = 0x151B,
    INVENT_CMD_DELETE_UNUSED = 0x151C,
    INVENT_CMD_SET_BOARD = 0x151D,
    INVENT_CMD_DELETE_ALL = 0x151E
};

/**
 *
 * Defines the commands available in an inventory mode.
 *
 */
struct InventCommandList {
    int enable;  /**< Whether the command list is enabled. */
    int cmd_num; /**< Number of available commands. */
    int cmd[5];  /**< Command codes for this mode. */
};

int                       MenuInventDebugKey();
void                      MenuInventDebugDraw();

/**
 *
 * Icon prefixes used by invention idea names.
 *
 */
static char *addstringtable_1722[3] = {
    "[bulb2]",
    "[bulb3]",
    "[heart]"
};

extern mgCMemory          InventTeigiStack;

enum {
    kCreateAsk = 0,
    kCreateWaitStart = 1,
    kCreateShowReady = 2,
    kCreateShow = 3,
    kCreateAfter = 4,
    kCreateKeyConfirm = 1,
    kCreateKeyCancel = 2,
    kLoadSoundMsg = -1,
    kLoadModel = 0,
    kLoadModelDone = 1,
    kLoadItemModel = 2,
    kLoadSoundBank = 3,
    kLoadSoundPort = 4,
    kLoadJingleOpen = 5,
    kLoadJinglePlay = 6,
    kItemModelBlocks = 0x1020,
    kPhotoModelBlocks = 0x2000,
    kMsgItemCreated = 0x25F,
    kMsgNothingNew = 0x260,
    kMsgPhotoNamed = 0x265,
    kBlinkDark = 0x80303030,
    kBlinkLight = 0x8022227F,
    kLineColorNormal = 0x80686A6B,
    kSceneAttrFlags = 0x18000
};

/**
 *
 * Enables forced invention success in the debug menu.
 *
 */
static short debug_invent_successflag;

/**
 *
 * Invention records of the active user.
 *
 */
static CInventUserData *InventUserDataPtr;

/**
 *
 * Photo album used by the inventory menu.
 *
 */
static CDC2AlbumData *InventAlbumPtr;

/**
 *
 * Recipe manager used while inventing an item.
 *
 */
static CInventDataManage *InventManagePt;

/**
 *
 * Memory-card manager used for photo album transfers.
 *
 */
static CMemoryCardManager *MCManagerPtr;

/**
 *
 * Selects the ordering applied to the photo list.
 *
 */
static signed char pict_seiton_case;

/**
 *
 * Arena that stores the scoop name strings.
 *
 */
static mgCMemory *scoop_str_stack;

/**
 *
 * Arena that stores photo name definitions.
 *
 */
static mgCMemory *PicNameStack;

/**
 *
 * First parsed photo name record.
 *
 */
static PIC_NAME_INFO *pic_name_info_top;

/**
 *
 * Number of parsed photo name records.
 *
 */
static short pic_name_info_num;

/**
 *
 * Photo name records counted while sizing the list.
 *
 */
static short pic_name_info_num_count;

/**
 *
 * First recipe record populated by the invention script.
 *
 */
static INVENT_DATA_INFO *inventSpiDataTblTop;

/**
 *
 * Recipe index advanced by the invention script.
 *
 */
static short invent_num_counter;

/**
 *
 * Number of discovered idea names in the notebook.
 *
 */
static short NetaMemoStrNum;

/**
 *
 * Texture used for the invention display.
 *
 */
static mgCTexture *Tex_Hatsumei;

/**
 *
 * Background data-read handle of the inventory submenu.
 *
 */
static unsigned int InventSubDataReadBGInfo;

/**
 *
 * Photo selected by the active inventory command.
 *
 */
static USER_PICTURE_INFO *menu_invent_command_info_pict_info;

/**
 *
 * Command list of the current inventory screen.
 *
 */
static InventCommandList *menu_invent_command_info_ptr;

/**
 *
 * Photo moved between album spaces.
 *
 */
static USER_PICTURE_INFO *menu_invent_command_info_move_album_Space_info;

/**
 *
 * Destination position of a photo moved between album spaces.
 *
 */
static int menu_invent_command_info_move_album_Space_pos;

/**
 *
 * Controls the effect for a newly added idea.
 *
 */
static u8 InventInNetaEffectFlag;

/**
 *
 * Number of ideas displayed by the addition effect.
 *
 */
static signed char InventInNetaEffectNum;

/**
 *
 * Counter used by the idea addition effect.
 *
 */
static short InventInNetaEffectNum4;

/**
 *
 * Particle effect used when adding an idea.
 *
 */
static CStarDust *InventInNetaEffect;

/**
 *
 * Memory-card slot selected for album operations.
 *
 */
static s8 ActiveSlot_3949;

/**
 *
 * Indicates that the album memory-card slot has been initialized.
 *
 */
static s8 init_3950;

/**
 *
 * Active inventory menu.
 *
 */
static CMenuInvent *CMenuInventPt;

/**
 *
 * Recipe manager owned by the inventory menu.
 *
 */
static CInventDataManage InventManageMan;

/**
 *
 * Selected row of the inventory debug display.
 *
 */
static short debug_invent_select;

/**
 *
 * Work buffer for photo name definitions.
 *
 */
static char pic_name_text_buff_1660[0x2480];

/**
 *
 * Scratch string used while resolving a scoop name.
 *
 */
static char temp_1728[0x21];

/**
 *
 * Names of discovered ideas displayed in the notebook.
 *
 */
static char *NetaMemoStr[512];

/**
 *
 * Idea identifiers displayed in the notebook.
 *
 */
static short NetaMemoID[512];

/**
 *
 * Horizontal offsets of the inventory record-board entries.
 *
 */
static int rec_board_offset_xtbl[10];

/**
 *
 * Confirmation mode selected by each photo command.
 *
 */
static s8 convtbl_3726[7] = {
    INVENT_ASK_ZOOM, INVENT_ASK_DELETE, INVENT_ASK_TO_ALBUM, INVENT_ASK_FROM_ALBUM, INVENT_ASK_DELETE_UNUSED, INVENT_ASK_SET_BOARD, INVENT_ASK_DELETE_ALL
};

/**
 *
 * Defines each scoop and the event flag that reveals it.
 *
 */
static SCOOP_DATA scoop_table[53] = {
    {1000, 300, 1},
    {1001, 300, 2},
    {1002, 300, 3},
    {1003, 300, 4},
    {1004, 300, 5},
    {1005, 500, 6},
    {1006, 100, 7},
    {1007, 201, 8},
    {1009, 300, 9},
    {1010, 300, 10},
    {1011, 201, 11},
    {1012, 201, 12},
    {1013, 54, 13},
    {1014, 54, 14},
    {1016, 408, 15},
    {1017, 520, 16},
    {1018, 100, 17},
    {1019, 201, 18},
    {1021, 300, 19},
    {1022, 201, 20},
    {1023, 500, 21},
    {1024, 804, 22},
    {1026, 600, 24},
    {1027, 438, 25},
    {2000, 250, 26},
    {2001, 250, 27},
    {2002, 348, 28},
    {2003, 456, 29},
    {2004, 556, 30},
    {2005, 54, 31},
    {2006, 402, 32},
    {2007, 408, 33},
    {2008, 54, 34},
    {2009, 209, 35},
    {2010, 340, 36},
    {2011, 500, 37},
    {2012, 448, 38},
    {2013, 708, 39},
    {2014, 604, 40},
    {2015, 616, 41},
    {2016, 556, 42},
    {2017, 616, 43},
    {2018, 616, 44},
    {2019, 616, 45},
    {2020, 616, 46},
    {2021, 700, 47},
    {2022, 700, 48},
    {2023, 524, 49},
    {2025, 520, 51},
    {2026, 300, 52},
    {2027, 400, 53},
    {2028, 500, 54},
    {1015, 209, 55},
};

/**
 *
 * Lists the commands available for each inventory layout.
 *
 */
static InventCommandList modecmdtbl_3636[12] = {
    {1, 5, {INVENT_CMD_SET_BOARD, INVENT_CMD_ZOOM, INVENT_CMD_DELETE, INVENT_CMD_DELETE_UNUSED, INVENT_CMD_DELETE_ALL}},
    {0, 5, {INVENT_CMD_ZOOM, INVENT_CMD_DELETE, INVENT_CMD_FROM_ALBUM, INVENT_CMD_DELETE_UNUSED, INVENT_CMD_DELETE_ALL}},
    {0, 0, {INVENT_CMD_ZOOM, 0, 0, -1, -1}},
    {0, 0, {INVENT_CMD_ZOOM, 0, 0, -1, -1}},
    {1, 5, {INVENT_CMD_ZOOM, INVENT_CMD_DELETE, INVENT_CMD_TO_ALBUM, INVENT_CMD_DELETE_UNUSED, INVENT_CMD_DELETE_ALL}},
    {1, 5, {INVENT_CMD_ZOOM, INVENT_CMD_DELETE, INVENT_CMD_FROM_ALBUM, INVENT_CMD_DELETE_UNUSED, INVENT_CMD_DELETE_ALL}},
    {1, 4, {INVENT_CMD_ZOOM, INVENT_CMD_DELETE, INVENT_CMD_DELETE_UNUSED, INVENT_CMD_DELETE_ALL, -1}},
    {0, 5, {INVENT_CMD_ZOOM, INVENT_CMD_DELETE, INVENT_CMD_FROM_ALBUM, INVENT_CMD_DELETE_UNUSED, INVENT_CMD_DELETE_ALL}},
};

/**
 *
 * Byte lengths of the proposed Japanese invention name endings.
 *
 */
static u8 jp_conv_lentbl_2835[12] = {
    2, 2, 2, 4, 4, 8, 6, 4, 6, 14, 10, 6
};

// Code (.text)
CInventUserData *GetInventUserDataPtr() {
    CSaveData *save = GetSaveData();

    if (save == NULL) {
        return NULL;
    }

    return save->GetUserDataManager()->GetInventUserData();
}

void Init_USER_PICTURE_INFO(USER_PICTURE_INFO *photo) {
    if (photo != NULL) {
        photo->used = 0;
        photo->is_new = 0;
        photo->map_no = -1;
        photo->npc_no = -1;
        photo->unk_8 = -1;
        photo->monster_no = -1;
        photo->neta_id = 0;
    }
}

void Copy_USER_PICTURE_INFO(USER_PICTURE_INFO *src, USER_PICTURE_INFO *dst) {
    if (src == NULL || dst == NULL) {
        return;
    }

    dst->used = src->used;
    dst->is_new = *(signed char *) &src->is_new;
    dst->map_no = src->map_no;
    dst->npc_no = src->npc_no;
    dst->unk_8 = src->unk_8;
    dst->monster_no = src->monster_no;
    dst->neta_id = src->neta_id;
}

void PictureSeiton(USER_PICTURE_INFO *photos, char *work_base, int count) {
    char               work_tmp[(0x2000)];
    USER_PICTURE_INFO  info_tmp;
    int                i;
    int                j;
    USER_PICTURE_INFO *a;
    USER_PICTURE_INFO *b;
    int                swap;
    short              key_a;
    short              key_b;

    if (photos == NULL) {
        return;
    }

    for (i = 0; i < count; i++) {
        a = &photos[i];

        for (j = i + 1; j < count; j++) {
            b = &photos[j];

            if (b->used == 0) {
                continue;
            }

            swap = 0;

            if (pict_seiton_case == 0) {
                if (a->used == 0 && b->used == 1) {
                    swap = 1;
                }

                key_a = a->neta_id;

                if (key_a < 0 && 0 < b->neta_id) {
                    swap = 1;
                }

                if (0 < key_a) {
                    key_b = b->neta_id;

                    if (0 < key_b && key_b < key_a) {
                        swap = 1;
                    }
                }
            }

            if (pict_seiton_case == 1) {
                if (a->used == 0 && b->used == 1) {
                    swap = 1;
                }

                key_a = a->map_no;

                if (key_a < 0 && 0 <= b->map_no) {
                    swap = 1;
                }

                if (0 <= key_a) {
                    key_b = b->map_no;

                    if (0 <= key_b && key_b < key_a) {
                        swap = 1;
                    }
                }
            }

            if (pict_seiton_case == 2) {
                if (a->used == 0 && b->used == 1) {
                    swap = 1;
                }

                key_a = a->npc_no;

                if (key_a < 0 && 0 <= b->npc_no) {
                    swap = 1;
                }

                if (0 <= key_a) {
                    key_b = b->npc_no;

                    if (0 <= key_b && key_b < key_a) {
                        swap = 1;
                    }
                }
            }

            if (pict_seiton_case == 3) {
                if (a->used == 0 && b->used == 1) {
                    swap = 1;
                }

                key_a = a->monster_no;

                if (key_a < 0 && 0 <= b->monster_no) {
                    swap = 1;
                }

                if (0 <= key_a) {
                    key_b = b->monster_no;

                    if (0 <= key_b && key_b < key_a) {
                        swap = 1;
                    }
                }
            }

            if (swap != 0) {
                memcpy(work_tmp, a->image, (0x2000));
                memcpy(a->image, b->image, (0x2000));
                memcpy(b->image, work_tmp, (0x2000));
                memcpy(&info_tmp, a, sizeof(USER_PICTURE_INFO));
                memcpy(a, b, sizeof(USER_PICTURE_INFO));
                memcpy(b, &info_tmp, sizeof(USER_PICTURE_INFO));
                a->image = work_base + i * (0x2000);
                b->image = work_base + j * (0x2000);
            }

            if (swap != 0) {
                i = -1;
                break;
            }
        }
    }

    pict_seiton_case++;

    if (pict_seiton_case >= 4) {
        pict_seiton_case = 0;
    }
}

void AttachPictTex(int block, mgCTexture **textures, USER_PICTURE_INFO *info, int count) {
    mgCTextureManager *manager = &mgTexManager;
    char               name[0x20];
    int                base = 0;
    int                i;

    if (count == (50)) {
        base = (50);
    }

    for (i = 0; i < count; i++) {
        sprintf(name, "neta%d", i + base);
        manager->DeleteTexture(name, block);
        manager->EnterTexture(block, name, NULL, (64), (64), (0x10), 0, 0, 0);
        textures[i] = manager->GetTexture(name, -1);

        if (textures[i] != NULL) {
            textures[i]->image[0] = (u_long128 *) info[i].image;
        }
    }
}

int CheckPhotoDataNoNeed(USER_PICTURE_INFO *photos, int count, int *unneeded) {
    int found;
    int i;

    if (photos == NULL) {
        return 0;
    }

    found = 0;
    i = 0;

    if (0 < count) {
        do {
            if (photos->neta_id <= 0 && unneeded != NULL) {
                unneeded[found] = i;
                found++;
            }

            i++;
            photos++;
        } while (i < count);
    }

    return found;
}

int IsTakePhoto() {
    CUserDataManager *user = GetUserDataMan();

    if (user != NULL && (user)->active_chr_no == 0 &&
        user->SearchEquip(0, 0x171) != 0) {
        return 1;
    }

    return 0;
}

void CDC2AlbumData::Initialize() {
    memset(this, 0, 0x64CB0);
    this->RelateAlbumPicData();
}

void CDC2AlbumData::RelateAlbumPicData() {
    int i = 0;

    do {
        USER_PICTURE_INFO *info = GetAlbumPhotoInfo(i);

        if (info != NULL) {
            info->image = NULL;

            if (this != NULL) {
                info->image = photo_work[i];
            }
        }

        i++;
    } while (i < 50);
}

void CDC2AlbumData::DeletePhotoData(int index) {
    if (index < 0 || index >= 50) {
        return;
    }

    Init_USER_PICTURE_INFO(this->GetAlbumPhotoInfo(index));
}

USER_PICTURE_INFO *CDC2AlbumData::GetAlbumPhotoInfo(int slot) {
    if (slot < 0 || slot >= 50) {
        return NULL;
    }

    return &photo[slot];
}

void CInventUserData::Initialize() {
    int i;
    shutter_num = 0;
    level = 0;
    memset(neta_id, 0, sizeof(neta_id));
    memset(photo_work, 0, 30 * 0x2000);

    for (i = 0; i < 30; i++) {
        Init_USER_PICTURE_INFO(&photo[i]);
    }

    for (i = 0; i < 0x100; i++) {
        created_item[i].item_id = 0;
        created_item[i].unk_2 = 0;
    }

    ResetAddress();
}

#ifdef NONMATCHING
void CInventUserData::ResetAddress() {
    char (*work)[0x2000];
    int index = 0;
    work = photo_work;
    for (; index < 30; index++) {
        photo[index].image = work[index];
    }
}

#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/inventmn", ResetAddress__15CInventUserDataFv);
#endif

void CInventUserData::PhotoCheckEnd() {
    int i;

    for (i = 0; i < 30; i++) {
        photo[i].is_new = 0;
    }
}

USER_PICTURE_INFO *CInventUserData::GetPhotoInfo(int slot) {
    if (slot < 0 || slot >= 30) {
        return NULL;
    }

    return &photo[slot];
}

char *CInventUserData::GetPhototWorkAdr() {
    return &photo_work[0][0];
}

USER_PICTURE_INFO *CInventUserData::IsPhotoSpace(int *slot) {
    int i;

    for (i = 0; i < 30; i++) {
        if (photo[i].used == 0) {
            photo[i].image = &photo_work[i][0];

            if (slot != NULL) {
                *slot = i;
            }

            return &photo[i];
        }
    }

    return NULL;
}

void CInventUserData::DeletePhotoData(int slot) {
    if (slot < 0 || slot >= 30) {
        return;
    }

    Init_USER_PICTURE_INFO(&photo[slot]);
}

int CInventUserData::CheckNetaFlag(int neta_id) {
    int i = 0;

    do {
        if (this->neta_id[i] == neta_id) {
            return i;
        }

        i++;
    } while (i < 0x200);

    return -1;
}

int CInventUserData::GetNetaID(int slot) {
    if (slot < 0 || slot >= 0x200) {
        return 0;
    }

    return neta_id[slot];
}

void CInventUserData::SetNetaFlag(int neta_id) {
    int free_slot = -1;
    int i = 0;

    do {
        if (this->neta_id[i] == 0) {
            free_slot = i;
            break;
        }

        i++;
    } while (i < 0x200);

    if (0 <= free_slot) {
        this->neta_id[free_slot] = neta_id;
    }
}

int CInventUserData::CheckNetaFlagHavePhoto(int neta_id) {
    USER_PICTURE_INFO *info;
    int                i = 0;

    do {
        info = GetPhotoInfo(i);

        if (info != NULL && info->used != 0 && info->neta_id == neta_id) {
            return i;
        }

        i++;
    } while (i < 30);

    return -1;
}

int CInventUserData::CountNeta() {
    short             subject;
    CUserDataManager *user_data;
    int               count;
    int               slot;

    user_data = GetUserDataMan();
    count = 0;
    slot = 0;

    do {
        subject = user_data->photo_subject[slot];

        if (0 < subject && subject < 1000) {
            count++;
        }

        slot++;
    } while (slot < 0x200);

    return count;
}

int CInventUserData::CountScoop() {
    short             subject;
    CUserDataManager *user_data;
    int               count;
    int               slot;

    user_data = GetUserDataMan();
    count = 0;
    slot = 0;

    do {
        subject = user_data->photo_subject[slot];

        if (subject >= 1000 && subject < 10000) {
            count++;
        }

        slot++;
    } while (slot < 0x200);

    return count;
}

int CInventUserData::AddShutterNum(int add) {
    shutter_num += add;

    if (shutter_num > 99999) {
        shutter_num = 99999;
    }

    if (shutter_num < 0) {
        shutter_num = 0;
    }

    return shutter_num;
}

int CInventUserData::GetNowHavePictureNum() {
    int count = 0;
    int i = 0;

    do {
        if (photo[i].used != 0) {
            count++;
        }

        i++;
    } while (i < 30);

    return count;
}

int CInventUserData::GetPictureNum(int *counts) {
    counts[0] = GetNowHavePictureNum();
    counts[1] = 30;
    return counts[0];
}

int CInventUserData::CalcPhotoExp() {
    short             subject;
    CUserDataManager *user_data;
    int               slot;
    int               experience;

    experience = 0;
    user_data = GetUserDataMan();
    slot = 0;

    do {
        subject = user_data->photo_subject[slot];

        if (subject > 0) {
            if (subject < 1000) {
                experience += 2;
            } else {
                experience += 5;
            }
        }

        slot += 1;
    } while (slot < 0x200);

    return experience;
}

int CInventUserData::LevelCheck(USER_PICTURE_INFO *info) {
    CUserDataManager *user_data;
    int               i;
    int               slot;
    short             subject;
    int               old_level;

    if (info == NULL) {
        return 0;
    }

    user_data = GetUserDataMan();

    if (user_data == NULL) {
        return 0;
    }

    subject = info->neta_id;

    if (subject <= 0) {
        return 0;
    }

    slot = -1;
    i = 0;

    do {
        short owned = user_data->photo_subject[i];

        if (owned == subject) {
            return 0;
        }

        if (owned <= 0) {
            slot = i;
            break;
        }

        i++;
    } while (i < 0x200);

    if (slot < 0) {
        return 0;
    }

    user_data->photo_subject[slot] = subject;
    old_level = level;
    level = CalcPhotoExp() / 100;
    return old_level != level;
}

int CInventUserData::GetLevel() {
    return level + 1;
}

void CInventUserData::SetCreateItemFlag(int slot, int item_id) {
    int i;

    if (0 < slot && created_item[slot].item_id <= 0) {
        created_item[slot].item_id = item_id;
        return;
    }

    for (i = 1; i < 0x100; i++) {
        if (created_item[i].item_id <= 0) {
            created_item[i].item_id = item_id;
            return;
        }
    }
}

int CInventUserData::GetCreateItemID(int slot) {
    if (slot < 0 || slot >= 0x100) {
        return 0;
    }

    return created_item[slot].item_id;
}

int CInventUserData::IsAlreadyCreatedItem(int item_id) {
    int i;

    if (item_id <= 0) {
        return -1;
    }

    i = 0;

    do {
        if (created_item[i].item_id == item_id) {
            return i;
        }

        i++;
    } while (i < 0x100);

    return -1;
}

int CInventUserData::GetHatsumeiNum() {
    int count = 0;
    int i = 0;

    do {
        if (created_item[i].item_id > 0) {
            count++;
        }

        i++;
    } while (i < 0x100);

    return count;
}

void TranslateInventUserData(CInventUserData *old_data, CInventUserData *new_data) {
    short               *from;
    INVENT_CREATED_ITEM *to;
    int                  i;

    if (old_data == NULL || new_data == NULL) {
        return;
    }

    from = (short *) old_data->created_item;
    to = new_data->created_item;

    for (i = 0; i < 128; i++) {
        to->item_id = from[0];
        to->unk_2 = *(unsigned short *) &from[1];
        from += 6;
        to++;
    }
}

SCOOP_DATA *GetScoopDataTable(int scoop_id) {
    int i = 0;

    do {
        if (scoop_id == scoop_table[i].scoop_id) {
            return &scoop_table[i];
        }

        i++;
    } while (i < 53);

    return NULL;
}

SCOOP_DATA *GetScoopDataTableIndex(int index) {
    if (index < 0 || index >= 53) {
        return NULL;
    }

    return &scoop_table[index];
}

void InitScoopString() {
    int i;

    for (i = 0; i < 53; i++) {
        scoop_table[i].text = NULL;
        scoop_table[i].unk_c = 0;
        scoop_table[i].unk_10 = 0;
    }
}

int _SCOOP_STR(SPI_STACK *stack, int unused) {
    SCOOP_DATA *entry;
    SPI_STACK  *text_arg = stack + 1;
    entry = GetScoopDataTable(spiGetStackInt(stack));

    if (entry != NULL) {
        entry->text = mgCopyString(spiGetStackString(text_arg), scoop_str_stack);
    }

    return 1;
}

/**
 *
 * Script handlers used to load scoop descriptions.
 *
 */
static SPI_TAG_PARAM menu_scoop_str_tag[2] = {
    {"STR", _SCOOP_STR},
    {NULL, NULL}
};

void AnalyzeScoopString(mgCMemory *stack, char *script, int size) {
    InitScoopString();
    scoop_str_stack = stack;
    CScriptInterpreter interpreter;
    interpreter.SetTag(menu_scoop_str_tag);
    interpreter.SetScript(script, size);
    interpreter.Run();
}

SCOOP_INFO *CScoopDataManager::GetScoopInfo(int scoop_id) {
    SCOOP_DATA *entry = GetScoopDataTable(scoop_id);

    if (entry == NULL) {
        return NULL;
    }

    if (entry->info_no < 0 || entry->info_no >= 0x80) {
        return NULL;
    }

    return &info[entry->info_no];
}

void CScoopDataManager::SetViewFlag(int scoop_id, int flag) {
    SCOOP_INFO *scoop = GetScoopInfo(scoop_id);

    if (scoop != NULL) {
        scoop->known = flag;
    }
}

int CScoopDataManager::KnowScoop() {
    int         count;
    int         index;
    SCOOP_DATA *entry;
    SCOOP_INFO *info;

    index = 0;
    count = 0;

    do {
        entry = GetScoopDataTableIndex(index);

        if (entry != NULL) {
            info = GetScoopInfo((int) entry->scoop_id);

            if ((info != NULL) && (CheckBitFlagMenu((int) entry->flag_no) != 0) &&
                (info->known == 0)) {
                SetViewFlag((int) entry->scoop_id, 1);
                count += 1;
            }
        }

        index += 1;
    } while (index < 53);

    return count;
}

int CScoopDataManager::CheckScoop() {
    CInventUserData   *user;
    int                n;
    int                i;
    USER_PICTURE_INFO *photo;
    SCOOP_INFO        *info;
    int                neta;
    user = GetInventUserDataPtr();
    n = 0;

    if (user == NULL) {
        return 0;
    }

    for (i = 0; i < 30; i++) {
        photo = user->GetPhotoInfo(i);

        if (photo != NULL && photo->used != 0) {
            info = GetScoopInfo(photo->neta_id);

            if (info != NULL && info->obtained == 0) {
                n++;
                info->obtained = 1;
            }
        }
    }

    for (i = 0; i < 0x200; i++) {
        neta = user->GetNetaID(i);

        if (neta >= 1000) {
            info = GetScoopInfo(neta);

            if (info != NULL && info->obtained == 0) {
                n++;
                info->obtained = 1;
            }
        }
    }

    CheckPhotoFlag();
    return n;
}

int CScoopDataManager::GetScoopTotal(int *total) {
    int count = 0;
    int i = 0;

    do {
        if (info[i].obtained != 0) {
            count++;
        }

        i++;
    } while (i < 0x80);

    if (total != NULL) {
        *total = 53;
    }

    return count;
}

int _PIC_INFO(SPI_STACK *stack, int unused) {
    unsigned int size;
    unsigned int blocks;
    pic_name_info_num = spiGetStackInt(stack);
    size = pic_name_info_num * 8;

    if (size & 0xF) {
        blocks = (size >> 4) + 1;
    } else {
        blocks = size >> 4;
    }

    pic_name_info_top =
        (PIC_NAME_INFO *) operator new[](pic_name_info_num * 8, PicNameStack->Alloc(blocks + 2));
    pic_name_info_num_count = 0;
    return 1;
}

int _PIC_NAME(SPI_STACK *stack, int unused) {
    PIC_NAME_INFO *entry;
    SPI_STACK     *arg;
    char          *name;
    char           text[0x100];
    entry = &pic_name_info_top[pic_name_info_num_count];
    arg = stack + 1;

    if (entry != NULL) {
        entry->neta_id = spiGetStackInt(stack);
        name = spiGetStackString(arg++);
        memset(text, 0, sizeof(text));

        if (LanguageCode >= 2 && LanguageCode >= 5) {
            ConvertFontCode(name, text);
        } else {
            strcpy(text, name);
        }

        entry->name = mgCopyString(text, PicNameStack);
        entry->sort_key = spiGetStackInt(arg);
        pic_name_info_num_count++;

        if (entry->neta_id == 30000) {
            pic_name_info_num_count--;
            pic_name_info_num--;
        }
    }

    return 1;
}

/**
 *
 * Script handlers used to load photo subject names.
 *
 */
static SPI_TAG_PARAM pic_tag[3] = {
    {"PIC_INFO", _PIC_INFO},
    {"PIC_NAME", _PIC_NAME},
    {NULL, NULL}
};

void LoadFilePictureName() {
    mgCMemory    stack;
    char         align_buffer[0x5000];
    char        *buffer;
    unsigned int size;
    stack.stSetBuffer((u_long128 *) pic_name_text_buff_1660, 0x248);
    PicNameStack = &stack;
    buffer = (char *) MenuCalcBufAlignment((u_long128 *) align_buffer);
    size = LoadFileMenu("neta2.lst", (u_long128 *) buffer, 1);
    CScriptInterpreter interpreter;
    interpreter.SetTag(pic_tag);
    interpreter.SetScript(buffer, size);
    interpreter.Run();
}

char *GetPhotoName(USER_PICTURE_INFO *info) {
    int   i;
    int   offset;
    short neta_id;

    if (info == NULL) {
        return NULL;
    }

    if (info->used == 0) {
        return NULL;
    }

    neta_id = info->neta_id;

    if (neta_id > 0) {
        i = 0;
        offset = 0;

        for (; i < pic_name_info_num; i++) {
            if (neta_id == pic_name_info_top[i].neta_id) {
                return pic_name_info_top[i].name;
            }

            offset += 8;
        }
    }

    if (0 <= info->npc_no) {
        return GetNPCName(info->npc_no);
    }

    if (0 <= info->monster_no) {
        return GetMonsterName(info->monster_no);
    }

    if (0 <= info->map_no) {
        return GetMapTitle(info->map_no);
    }

    return NULL;
}

int GetPhotoNameStr(int neta_id, char *dest) {
    USER_PICTURE_INFO info;
    char             *name;
    info.used = 1;
    info.neta_id = neta_id;
    name = GetPhotoName(&info);

    if (name == NULL) {
        return 1;
    }

    strcpy(dest, name);
    return 0;
}

char *GetPhotoNameCheck(USER_PICTURE_INFO *info) {
    char *result;
    short neta_id;
    char *prefix;
    char *name = GetPhotoName(info);
    result = NULL;

    if (name != NULL) {
        neta_id = info->neta_id;

        if (0 < neta_id) {
            prefix = addstringtable_1722[0];

            if (neta_id >= 1000) {
                prefix = addstringtable_1722[1];
            }

            strcpy(temp_1728, prefix);
            strcat(temp_1728, name);
        } else {
            strcpy(temp_1728, name);
        }

        result = temp_1728;
    }

    return result;
}

int CheckPhotoFlag() {
    int                added = 0;
    CInventUserData   *user = GetInventUserDataPtr();
    USER_PICTURE_INFO *photos = user->GetPhotoInfo(0);
    int                i = 0;
    int                offset = 0;

    do {
        USER_PICTURE_INFO *info = (USER_PICTURE_INFO *) ((u8 *) photos + offset);

        if (*(signed char *) &*(signed char *) &info->used != 0) {
            short *neta_id = &info->neta_id;

            if (0 < *neta_id && user->CheckNetaFlag(*neta_id) < 0) {
                user->SetNetaFlag(*neta_id);
                added = 1;
            }
        }

        i++;
        offset += sizeof(USER_PICTURE_INFO);
    } while (i < 30);

    return added;
}

INVENT_DATA_INFO *CInventDataManage::GetInventDataInfoByItemID(int item_id) {
    int i;

    for (i = 0; i < num; i++) {
        if (item_id == table[i].item_id) {
            return &table[i];
        }
    }

    return NULL;
}

int CInventDataManage::CheckInventEnable(int *ids, int *combined) {
    int               want[3];
    int               i;
    INVENT_DATA_INFO *entry;
    short            *ingredient;
    int               count;
    int               j;
    int               k;
    int               m;
    GetInventUserDataPtr();

    for (i = 0; i < num; i++) {
        entry = &table[i];
        ingredient = &entry->neta_id[0];

        if (ingredient != NULL) {
            u8 found[3] = {0, 0, 0};

            for (j = 0; j < 3; j++) {
                want[j] = ingredient[j];

                for (k = 0; k < 3; k++) {
                    if (want[j] == ids[k]) {
                        found[j] = 1;
                    }
                }
            }

            count = 0;

            for (m = 0; m < 3; m++) {
                if (found[m] != 0) {
                    count++;
                    want[m] = 0;
                }
            }

            if (combined != NULL && count >= 2) {
                *combined = 1;
            }

            if (found[0] != 0 && found[1] != 0 && found[2] != 0) {
                return entry->item_id;
            }
        }
    }

    return -1;
}

int CInventDataManage::HowMuchZairyouMakeItem(int item_id, int count, int *needs) {
    INVENT_DATA_INFO     *make_material;
    INVENT_MATERIAL_LIST *list;
    int                   i;
    MakeItemNeeds        *result;

    if (needs == NULL) {
        return 0;
    }

    make_material = GetInventDataInfoByItemID(item_id);

    if (make_material == NULL) {
        return 0;
    }

    list = &make_material->materials;
    i = 0;
    result = reinterpret_cast<MakeItemNeeds *>(needs);
    result->num = make_material->materials.num;

    while (i < list->num) {
        result->need[i].item_id = list->material[i].item_id;
        result->need[i].amount = count * list->material[i].num;
        i++;
    }

    if (i < 4) {
        do {
            result->need[i].item_id = 0;
            result->need[i].amount = 0;
            i++;
        } while (i < 4);
    }

    return 1;
}

int CInventDataManage::DeleteUserUsedItem(int item_id, int count) {
    INVENT_DATA_INFO     *make_material;
    INVENT_MATERIAL_LIST *list;
    int                   i;
    INVENT_MATERIAL      *material;
    make_material = GetInventDataInfoByItemID(item_id);
    list = &make_material->materials;

    if (make_material == NULL) {
        return 0;
    }

    i = 0;

    while (i < list->num) {
        material = &list->material[i];

        if (material == NULL) {
            break;
        }

        GetUserDataMan()->DeleteItem(material->item_id, material->num * count);
        i++;
    }

    return 1;
}

int CInventDataManage::CheckMakeItem(int item_id, int count, CGameDataUsed *item) {
    MakeItemNeeds needs;
    HowMuchZairyouMakeItem(item_id, count, (int *) &needs);
    int available = 0;

    for (int index = 0; index < needs.num; index++) {
        int owned = GetUserItemHaveNum(needs.need[index].item_id);

        if (needs.need[index].amount > owned) {
            continue;
        }

        available++;
    }

    return available >= needs.num;
}

int _INVENT_DATATABLESET(SPI_STACK *stack, int unused) {
    int          num;
    int          i;
    unsigned int size;
    unsigned int blocks;
    num = spiGetStackInt(stack);
    size = num * sizeof(INVENT_DATA_INFO);
    invent_num_counter = 0;

    if (size & 0xF) {
        blocks = (size >> 4) + 1;
    } else {
        blocks = size >> 4;
    }

    inventSpiDataTblTop = (INVENT_DATA_INFO *) InventTeigiStack.Alloc(blocks);
    CInventDataManage *manager = InventManagePt;
    manager->table = inventSpiDataTblTop;
    manager->num = num;

    for (i = 0; i < num; i++) {
        inventSpiDataTblTop[i].item_id = -1;
    }

    return 1;
}

int _INVENT_DATASET(SPI_STACK *stack, int argument_count) {
    if (InventManagePt->num <= invent_num_counter) {
        return 0;
    }

    inventSpiDataTblTop->item_id = spiGetStackInt(stack++);
    short *ideas = inventSpiDataTblTop->neta_id;
    ideas[0] = spiGetStackInt(stack++);
    ideas[1] = spiGetStackInt(stack++);
    ideas[2] = spiGetStackInt(stack++);
    int                   index;
    INVENT_MATERIAL_LIST *materials = &inventSpiDataTblTop->materials;
    materials->num = (argument_count - 9) / 2;

    if (materials->num <= 0) {
        return 0;
    }

    unsigned int bytes = materials->num * sizeof(INVENT_MATERIAL);
    unsigned int blocks = (bytes & 15) != 0 ? (bytes >> 4) + 1 : bytes >> 4;
    materials->material = (INVENT_MATERIAL *) InventTeigiStack.Alloc(blocks);

    for (index = 0; index < materials->num; index++) {
        INVENT_MATERIAL *material = &materials->material[index];

        if (material != NULL) {
            material->item_id = spiGetStackInt(stack++);
            material->num = spiGetStackInt(stack++);
        }
    }

    inventSpiDataTblTop->unk_10 = spiGetStackInt(stack++);
    inventSpiDataTblTop->model_scale = spiGetStackFloat(stack++);
    inventSpiDataTblTop->model_pos[0] = spiGetStackFloat(stack++);
    inventSpiDataTblTop->model_pos[1] = spiGetStackFloat(stack++);
    inventSpiDataTblTop->model_pos[2] = spiGetStackFloat(stack);
    inventSpiDataTblTop++;
    invent_num_counter++;
    return 1;
}

/**
 *
 * Script handlers used to load invention recipes.
 *
 */
static SPI_TAG_PARAM invent_teigi_func[3] = {
    {"DATATABLESET", _INVENT_DATATABLESET},
    {"DATASET", _INVENT_DATASET},
    {NULL, NULL}
};

int CInventDataManage::LoadAnalyzeInventFile(char *script, int size) {
    if (script == NULL) {
        return 0;
    }

    InventManagePt = this;
    InventTeigiStack.stack_used = 0;
    InventTeigiStack.lock = 0;
    CScriptInterpreter interpreter;
    interpreter.SetTag(invent_teigi_func);
    interpreter.SetScript(script, size);
    interpreter.Run();
    return 1;
}

int CheckInventItem(int item_id) {
    CInventDataManage manage;
    int               file_size;
    char              align_buffer[0x7800];
    char              teigi_buffer[0x4000];
    char             *buffer;
    INVENT_DATA_INFO *record;
    short            *neta_id;
    int               i;
    manage.num = 0;
    manage.table = NULL;
    buffer = (char *) MenuCalcBufAlignment((u_long128 *) align_buffer);
    LoadFile2("menu/inv6.lst", buffer, &file_size, 0);
    InventTeigiStack.stSetBuffer((u_long128 *) teigi_buffer, 0x400);
    manage.LoadAnalyzeInventFile(buffer, file_size);
    InventUserDataPtr = GetInventUserDataPtr();
    record = manage.GetInventDataInfoByItemID(item_id);

    if (record == NULL) {
        return 0;
    }

    neta_id = record->neta_id;
    s8 found[3] = {0, 0, 0};

    for (i = 0; i < 30; i++) {
        USER_PICTURE_INFO *photo = InventUserDataPtr->GetPhotoInfo(i);

        if (*(signed char *) &photo->used != 0) {
            short photo_neta = photo->neta_id;

            if (photo_neta > 0) {
                if (neta_id[0] == photo_neta) {
                    found[0] = 1;
                }

                if (neta_id[1] == photo_neta) {
                    found[1] = 1;
                }

                if (neta_id[2] == photo_neta) {
                    found[2] = 1;
                }
            }
        }
    }

    for (i = 0; i < 0x200; i++) {
        int memo_neta = InventUserDataPtr->GetNetaID(i);

        if (neta_id[0] == memo_neta) {
            found[0] = 1;
        }

        if (neta_id[1] == memo_neta) {
            found[1] = 1;
        }

        if (neta_id[2] == memo_neta) {
            found[2] = 1;
        }
    }

    if (found[0] != 0 && found[1] != 0 && found[2] != 0) {
        return 1;
    }

    return 0;
}

int CheckItemTable(int item_id, int *values) {
    CInventDataManage manage;
    int               file_size;
    char              align_buffer[0x7800];
    char              teigi_buffer[0x4000];
    char             *buffer;
    INVENT_DATA_INFO *record;
    manage.num = 0;
    manage.table = NULL;
    buffer = (char *) MenuCalcBufAlignment((u_long128 *) align_buffer);

    if (LoadFile2("menu/inv6.lst", buffer, &file_size, 0) != 0) {
        InventTeigiStack.stSetBuffer((u_long128 *) teigi_buffer, 0x400);
        manage.LoadAnalyzeInventFile(buffer, file_size);
        record = manage.GetInventDataInfoByItemID(item_id);

        if (record == NULL) {
            return 0;
        }

        values[0] = record->neta_id[0];
        values[1] = record->neta_id[1];
        values[2] = record->neta_id[2];
        return 3;
    }

    return 0;
}

int CheckInventPhoto(int id, int kind) {
    CInventUserData   *user;
    USER_PICTURE_INFO *info;
    int                count;
    int                i;
    short              value;
    user = GetInventUserDataPtr();
    count = 0;

    if (user == NULL) {
        return 0;
    }

    for (i = 0; i < 30; i++) {
        info = user->GetPhotoInfo(i);

        if (info != NULL && info->used != 0) {
            if (kind == 0) {
                value = info->neta_id;

                if (0 < value && value == id) {
                    count++;
                }
            } else if (kind == 2) {
                value = info->npc_no;

                if (0 < value && value == id) {
                    count++;
                }
            } else if (kind == 3) {
                value = info->monster_no;

                if (0 < value && value == id) {
                    count++;
                }
            }
        }
    }

    return count;
}

void CMenuInvent::InitPhotoNetaBoardToAlbum(int source) {
    int i;

    for (i = 0; i < 50; i++) {
        if (source == 0) {
            album_flag[i] = -1;
        }

        if (InventAlbumPtr != 0 && source == 1) {
            USER_PICTURE_INFO *photo = InventAlbumPtr->GetAlbumPhotoInfo(i);

            if (photo == 0) {
                album_flag[i] = -1;
            }

            if (photo != 0 && photo->used == 0) {
                album_flag[i] = -1;
            }
        }
    }
}

int CMenuInvent::CheckRecoverPhotoNum() {
    int count = 0;
    int i = 0;

    do {
        if (0 < album_flag[i]) {
            count++;
        }

        i++;
    } while (i < 50);

    return count;
}

void CMenuInvent::AttachFormInfo() {
    bg_form = MenuPosData->GetFormInfo("inv_bg");
    itembrd_form = MenuPosData->GetFormInfo("itembrd");
    neta_board_form = MenuPosData->GetFormInfo("\x83\x6c\x83\x5e\x94\xc2");
    neta_board_bar[0] = 0;
    neta_board_bar[1] = 0;
    neta_board_bar[2] = 0;
    neta_board_arrow = 0;
    neta_memo_arrow = 0;

    if (neta_board_form != 0) {
        neta_board_form->SetNumber("maxnum", 30);
        neta_board_bar[0] = neta_board_form->GetPartInfo("bar0");
        neta_board_bar[1] = neta_board_form->GetPartInfo("bar1");
        neta_board_bar[2] = neta_board_form->GetPartInfo("bar2");
        neta_board_arrow = neta_board_form->GetPartInfo("\x81\xaa");
        neta_memo_arrow = neta_board_form->GetPartInfo("\x83\x6c\x83\x5e\x92\xa0\x96\xee\x88\xf3\x8a\xee\x96\x7b");
    }

    neta_memo_form = MenuPosData->GetFormInfo("\x83\x6c\x83\x5e\x92\xa0");
    photo_scroll_reset = 1;
    makebrd_form = MenuPosData->GetFormInfo("makebrd");
    card_scroll_reset = 1;
    card_list_title_form = MenuPosData->GetFormInfo("\x83\x4a\x81\x5b\x83\x68\x83\x8a\x83\x58\x83\x67");
    card_list_form = MenuPosData->GetFormInfo("cardlist");
    album_sw_form = MenuPosData->GetFormInfo("Album_sw");

    if (album_sw_form != 0) {
        album_sw_form->rgba_bit = 8;
    }

    album_big_form = MenuPosData->GetFormInfo("Album_Big");
    GiftBoxViewForm = MenuPosData->GetFormInfo("giftview");
    neta_form[0] = MenuPosData->GetFormInfo("neta0");
    neta_form[1] = MenuPosData->GetFormInfo("neta1");
    neta_form[2] = MenuPosData->GetFormInfo("neta2");
    neta_name_form[0] = MenuPosData->GetFormInfo("neta0name");
    neta_name_form[1] = MenuPosData->GetFormInfo("neta1name");
    neta_name_form[2] = MenuPosData->GetFormInfo("neta2name");
    recbrd_form = MenuPosData->GetFormInfo("recbrd");
    poly_chr_form[0] = MenuPosData->GetFormInfo("poly_chr0");
    poly_chr_form[1] = MenuPosData->GetFormInfo("poly_chr1");

    if (poly_chr_form[0] != 0) {
        poly_chr_form[0]->SetActionCharaPtr(0, -1, -1);
    }

    invent_okeff_form = MenuPosData->GetFormInfo("invent_okeff");
    dload_form = MenuPosData->GetFormInfo("DLOAD");
    kakudai_pic_form = MenuPosData->GetFormInfo("kakudai_pic");
    kakudai_pic = 0;

    if (kakudai_pic_form != 0) {
        kakudai_pic = kakudai_pic_form->GetPartInfo("pic");
    }

    AttachMessageForm();
}

/**
 *
 * Calculates 16-byte stack blocks for an object with two reserve blocks.
 *
 */
static inline int StackBlocks(int bytes) {
    return (bytes + 15) / 16 + 2;
}

/**
 *
 * Constructs an action character in the inventory memory stack.
 *
 */

static inline CActionChara *NewInventActionChara(mgCMemory *stack) {
    return new (stack->Alloc(StackBlocks(sizeof(CActionChara)))) CActionChara;
}

#ifdef NONMATCHING
void CMenuInvent::LoadCharaCheck() {
    CActionChara *chara = MenuActionChara[0];
    mgCMemory    *load_stack = &MenuCharaLoadStack;
    int           size;
    switch (chara_load_step) {
        case -1:
            break;
        case 0:
            if (poly_chr_form[0] != NULL) {
                poly_chr_form[0]->SetActionCharaPtr(NULL, tex_block[1], -1);
            }
            MenuLoadInfo.mode = 1;
            MenuLoadInfo.load_all = 1;
            MenuLoadInfo.chara_no = 0;
            MenuLoadInfo.update_scene = 0;
            SetMenuLoadItemNo(0);
            size = MenuItemCharaDataLoad(load_stack, 0, MenuCharaBuild2, 0);
            chara_load_step = 1;
            sub_chara = NULL;
            if (photo_only == 1) {
                LoadFileBG(at_2244, load_stack->stack + load_stack->stack_used, &size);
                load_stack->Alloc(((u_int) size & 0xF) ? ((u_int) size >> 4) + 1 : (u_int) size >> 4);
                chara_read_info = GetReadBGInfo(at_2244);
            }
            break;
        case 1:
            if (ReadBGSync() != 0) {
                break;
            }
            MenuItemCharaDataLoadEndCheck(MenuCharaBuild2, NULL, MenuActionChara, 0, tex_block[1], -1);
            chara->ResetParent();
            if (MenuActionChara[3] != NULL && MenuUserParam.chara[0]->equip[2].item_no > 0) {
                chara->SetRef(MenuActionChara[3], at_2245);
                chara->CopyOutLine(MenuActionChara[3]);
            }
            if (chara->CObjectFrame::frame != NULL) {
                mgCFrame     *frame = chara->CObjectFrame::frame;
                mgCFrameAttr *attr = frame->attr;
                attr->no_light = 1;
                frame->SetAttrParam(*attr, 1, kSceneAttrFlags);
            }
            chara->SetMotion("\x97\xa7\x82\xbf", 0, 1);
            if (chara_read_info != NULL) {
                BG_READ_INFO            *read_info = chara_read_info;
                u_int                   *model_file = GetPackFile((u_int *) read_info->buffer, at_2247, &size);
                mgCTextureManager *const tex_manager = &mgTexManager;
                chara_stack.stack_used = 0;
                chara_stack.lock = 0;
                strcpy(tex_manager->name_suffix, at_2248);
                if (model_file != NULL) {
                    chara->LoadPack(model_file, at_2249, &chara_stack, &chara_stack, &chara_stack, tex_block[1], NULL);
                }
                u_int *sub_file = GetPackFile((u_int *) read_info->buffer, at_2250, &size);
                sub_chara = NewInventActionChara(&chara_stack);
                sub_chara->Initialize(0);
                sub_chara->LoadPack(sub_file, at_2249, &chara_stack, &chara_stack, &chara_stack, tex_block[1], chara);
                tex_manager->name_suffix[0] = 0;
                chara->SetRef(sub_chara, at_2251);
                chara->CopyOutLine(sub_chara);
                chara->SetMotion(at_2252, 0, 1);
            }
            if (album_enable == 0 && photo_only == 1) {
                float z = 14.0f;
                float y = -29.0f;
                float x = float(15);
                chara->SetPosition(x, y, z);
            } else {
                float z = float(14);
                float x = 20.0f;
                float y = float(-29);
                chara->SetPosition(x, y, z);
            }
            chara->SetRotation(0.0f, -0.56f, 0.0f);
            chara->Step();
            ExeScript("\x8d\x6c\x82\xa6\x83\x82\x81\x5b\x83\x68" "0");
            chara_load_step = 2;
            poly_chr_form[0]->SetActionCharaPtr(chara, tex_block[1], -1);
            unk_642 = 0;
            unk_648 = -3.1415927f / 5.0f;
            unk_640 = 0;
            break;
        case 2:
            chara->Step();
            break;
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/inventmn", LoadCharaCheck__11CMenuInventFv);
#endif

USER_PICTURE_INFO *CMenuInvent::GetNowSelectedPictInfo() {
    USER_PICTURE_INFO *info = 0;

    switch (key_arg_no) {
        case INVENT_MODE_THINK:
        case INVENT_MODE_PHOTO_VIEW:
        case INVENT_MODE_THINK_WITH_ALBUM:
            info = InventUserDataPtr->GetPhotoInfo(photo_cursor);
            break;
        case INVENT_MODE_ALBUM_VIEW:
            info = InventAlbumPtr->GetAlbumPhotoInfo(album_cursor);
            break;
    }

    return info;
}

USER_PICTURE_INFO *CMenuInvent::GetPhotoInfoFromMode(int *slot_count) {
    switch (key_arg_no) {
        case INVENT_MODE_THINK:
        case INVENT_MODE_PHOTO_VIEW:
        case INVENT_MODE_THINK_WITH_ALBUM:
            if (slot_count != 0) {
                *slot_count = 30;
            }

            return InventUserDataPtr->GetPhotoInfo(0);
        case INVENT_MODE_ALBUM_VIEW:
            if (slot_count != 0) {
                *slot_count = 50;
            }

            return InventAlbumPtr->GetAlbumPhotoInfo(0);
    }

    return 0;
}

void CMenuInvent::InitNetaCircle(int show) {
    int i = 0;

    do {
        if (show == 0) {
            CancelNetaCircle(0);
            neta_select_state[i] = -1;

            neta_select_index[i] = -1;
            unk_622[i] = 0;
        }

        CMenuPosDataForm **panel = &neta_form[i];

        if (*panel != 0) {
            (*panel)->SetRGBACalcParam(3, 0x7F, 0x80);

            if (show == 0) {
                (*panel)->draw_flag = 0;
            } else {
                (*panel)->draw_flag = 1;
                CMenuPosDataForm *label = neta_name_form[i];

                if (label != 0) {
                    label->SetAction("\x92\x86\x82\xd6");
                }
            }
        }

        i++;
    } while (i < 3);
}

static inline void SetNetaName(CDC2Mes *message, int line, char *name) {
    if (name != NULL) {
        strcpy(message->name[line], name);
    }
}

int CMenuInvent::SetNetaCircle(int type, int index) {
    char             *name;
    CMenuPosDataForm *form;
    CMenuPosDataForm *label;
    int               pos[2];

    if (neta_select_num >= 3) {
        return 0;
    }

    name = NULL;

    if (type == 0) {
        if (SelectedNetaPhotoAlready(index) != 0) {
            return 0;
        }

        USER_PICTURE_INFO *photo = InventUserDataPtr->GetPhotoInfo(index);

        if (photo == NULL) {
            return 0;
        }

        if (*(s8 *) &photo->used == 0) {
            return 0;
        }

        photo->is_new = 0;
        name = GetPhotoName(photo);
        neta_select_type[neta_select_num] = 0;
        neta_select_index[neta_select_num] = index;
    } else if (type == 1) {
        if (SelectedNetaMemoListAlready(index) != 0) {
            return 0;
        }

        USER_PICTURE_INFO memo;
        memo.used = 1;
        memo.neta_id = NetaMemoID[index];
        neta_select_type[neta_select_num] = 1;
        neta_select_index[neta_select_num] = index;
        name = GetPhotoName(&memo);
    }

    neta_select_state[neta_select_num] = 1;
    form = neta_form[neta_select_num];

    if (form != NULL) {
        form->draw_flag = 1;
        form->rgba[0] = 0x80;
        form->rgba[1] = 0x80;
        form->rgba[2] = 0x80;
        form->rgba[3] = 0x80;

        for (int i = 0; i < 4; i++) {
            form->SetRGBACalcParam(i, 0, 0x80);
        }

        form->SetRGBACalcParam(3, 8, 0x80);
        MENUFORMPARTS_TYPE *ring = form->GetPartInfo("neta");
        ring->draw_flag = 1;

        if (neta_select_type[neta_select_num] == 0) {
            GetNetaBoardCursorPosition(index, pos);
            form->SetPos(pos[0], pos[1]);
            ring->etc_info[0] = index;
            ring->picture_scale = 0.7f;
        }

        if (neta_select_type[neta_select_num] == 1) {
            GetNetaMemoCursorPosition(index - memo_top, pos);
            pos[0] += 220;
            form->rgba[0] = 0x80;
            form->rgba[1] = 0x80;
            form->rgba[2] = 0x80;
            form->rgba[3] = 0;

            for (int i = 0; i < 4; i++) {
                form->SetRGBACalcParam(i, 0, 0x80);
            }

            form->SetRGBACalcParam(3, 12, 0x80);
            form->SetPos(pos[0], pos[1]);
            ring->etc_info[0] = 1000;
        }
    }

    label = neta_name_form[neta_select_num];

    if (label != NULL) {
        label->SetAction("\x92\x86\x82\xd6");
    }

    SetNetaName(MenuDCMsg[7], neta_select_num, name);
    MenuDCMsg[7]->ClsMes::mes_no = -1;
    MenuDCMsg[7]->MakeMsg(neta_select_num + 50);
    neta_select_num++;

    if (neta_select_num == 1 && MenuActionChara[0] != NULL) {
        MenuActionChara[0]->SetMotion("\x8d\x6c\x82\xa6", 0, 1);
    }

    neta_circle_angle += 0.05235988f;
    return 1;
}

int CMenuInvent::CancelNetaCircle(int mode) {
    int removed_idea = -1;

    if (neta_select_num <= 0) {
        return removed_idea;
    }

    neta_select_num = neta_select_num - 1;
    short       last = neta_select_num;
    signed char kind = neta_select_type[last];

    if (kind == 0) {
        removed_idea = neta_select_index[last];
    }

    if (kind == 1) {
        removed_idea = neta_select_index[last];
    }

    neta_select_state[last] = 0;
    CMenuPosDataForm *label = neta_name_form[neta_select_num];

    if (label != 0) {
        label->SetAction("\x8a\x4f\x82\xd6");
    }

    if (neta_select_num <= 0) {
        if (MenuActionChara[0] != 0) {
            MenuActionChara[0]->SetMotion("\x97\xa7\x82\xbf", 0, 1);
        }

        if (mode == 0) {
            ExeScript("\x8d\x6c\x82\xa6\x83\x82\x81\x5b\x83\x68" "0");
        }

        if (mode == 5) {
            ExeScript("\x8d\x6c\x82\xa6\x83\x82\x81\x5b\x83\x68" "5");
        }
    }

    return removed_idea;
}

int CMenuInvent::GetNowSelectNetaID(int slot) {
    if (slot < 0 || slot > 2) {
        return 0;
    }

    signed char kind = neta_select_type[slot];

    if (kind == 0) {
        USER_PICTURE_INFO *photos = InventUserDataPtr->GetPhotoInfo(0);
        int                photo_slot = neta_select_index[slot];
        USER_PICTURE_INFO *photo = photos + photo_slot;
        return photo->neta_id;
    }

    if (kind == 1) {
        return NetaMemoID[neta_select_index[slot]];
    }

    return 0;
}

int CMenuInvent::SelectedNetaPhotoAlready(int neta_id) {
    int i = 0;

    do {
        if (neta_select_type[i] == 0 && neta_select_index[i] == neta_id) {
            return 1;
        }

        i++;
    } while (i < 3);

    return 0;
}

int CMenuInvent::SelectedNetaMemoListAlready(int neta_id) {
    int i;

    if (NetaMemoID[neta_id] == 0) {
        return 1;
    }

    i = 0;

    do {
        if (neta_select_type[i] == 1 && neta_id == neta_select_index[i]) {
            return 1;
        }

        i++;
    } while (i < 3);

    return 0;
}

void CMenuInvent::UpdataRecordBoard() {
    CDC2Mes *mes = MenuDCMsg[7];
    int      values[5];
    int      i;
    int      j;
    mes->value_half = 0;

    if (CheckNowEurope() != 0) {
        mes->value_half = 1;
    }

    for (i = 0; i < 10; i++) {
        rec_board_offset_xtbl[i] = 0;
    }

    mes->value_zero = 1;
    mes->value_space = -1;
    values[0] = InventUserDataPtr->AddShutterNum(0);
    values[1] = InventUserDataPtr->CountNeta();
    values[2] = InventUserDataPtr->CountScoop();
    values[3] = InventUserDataPtr->CalcPhotoExp();
    values[4] = InventUserDataPtr->GetLevel();
    int volume_types[5] = {5, 5, 5, 3, 4};
    mes->SetMsgVolumeNo(values, volume_types, 5);
    mes->ClsMes::mes_no = -1;
    mes->MakeMsg(0x2BC);

    if (mes->value_half != 0) {
        for (j = 4; j < 9; j++) {
            int digits = GetNumberKeta(values[j - 4]) - 1;

            if (0 < digits) {
                rec_board_offset_xtbl[j] = digits * 9;
            }
        }
    }
}

void CMenuInvent::PrepareNextMode(int next_mode) {
    key_arg_no = next_mode;
    CMenuPosDataForm *ask_form = MenuCommonInfo->cursor_form;

    if (ask_form != 0) {
        ask_form->draw_flag = 1;
    }

    neta_form[0]->parts->etc_info[0] = -1;
    neta_form[1]->parts->etc_info[0] = -1;
    neta_form[2]->parts->etc_info[0] = -1;
    MenuPosData->InitDrawList();
    ExeScript("\x8d\x6c\x82\xa6\x83\x82\x81\x5b\x83\x68" "0");
    ExeScript("\x83\x74\x83\x48\x81\x5b\x83\x80\x8f\x89\x8a\xfa\x89\xbb");

    switch (key_arg_no) {
        case INVENT_MODE_THINK:
            ExeScript("MSG\x8d\x6c\x8e\x40\x83\x82\x81\x5b\x83\x68");
            ExeScript("NextToThink");

            if (LanguageCode > 0) {
                MenuDCMsg[7]->font_w = 0xE;
            }

            break;
        case INVENT_MODE_CARD_LIST:
            ExeScript("MSG\x94\xad\x96\xbe\x90\xbb\x8d\xec\x83\x82\x81\x5b\x83\x68");
            CreateModeSwapForm(0);
            ExeScript("NextToCardList");
            MenuDCMsg[2]->font_w = 0xD;
            MenuDCMsg[3]->value_space = -7;

            if (MenuDCMsg[3] != 0) {
                MenuDCMsg[3]->value_half = 0;

                if (CheckNowEurope() != 0) {
                    MenuDCMsg[3]->value_space = 1;
                    MenuDCMsg[3]->value_half = 1;
                }
            }

            break;
        case INVENT_MODE_ALBUM_VIEW:
            ExeScript("NextToAlbumView");

            do {
            } while (CancelNetaCircle(0) >= 0);

            break;
        case INVENT_MODE_PHOTO_VIEW:
            ExeScript("MSG\x8d\x6c\x8e\x40\x83\x82\x81\x5b\x83\x68");
            ExeScript("NextToPhotoView");
            UpdataRecordBoard();
            break;
    }

    if (photo_only == 1) {
        ExeScript("picmodeonly");
    }

    if (album_enable == 0) {
        ExeScript("ALBUM_OFF");
    }
}

CGameDataUsed *CMenuInvent::SearchNowPosItemExist() {
    CGameDataUsed *item = 0;

    switch (key_arg_no) {
        case INVENT_MODE_CARD_LIST:

            create_item.Init();
            item = &create_item;
            item->item_no = InventUserDataPtr->GetCreateItemID(card_cursor);
            break;
        case INVENT_MODE_ITEM_LIST:
            item = &MenuUserParam.used_data[item_cursor];
            break;
    }

    return item;
}

void CMenuInvent::CreateModeSwapForm(int side) {
    if (side == 0) {
        ExeScript("FORMSWAP0");
        return;
    }

    ExeScript("FORMSWAP1");
}

void CMenuInvent::GradationSet(int mode) {
    int i = 0;

    switch (mode) {
        case 0: {
            int               j;
            CMenuPosDataForm *form = invent_okeff_form;

            if (form != 0) {
                j = 0;
                form->rgba[0] = 0x80;
                form->rgba[1] = 0x80;
                form->rgba[2] = 0x80;
                form->rgba[3] = 0;

                do {
                    form->SetRGBACalcParam(j, 0, 0x80);
                    j++;
                } while (j < 4);

                int offset = 0;

                do {
                    MENUFORMPARTS_TYPE *part =
                        invent_okeff_form->GetPartInfo(*(char **) ((u8 *) invent_grade_fff + offset));
                    i++;

                    part->y = 224.0f;
                    offset += 4;
                    part->h = 0.0f;
                } while (i < 2);
            }

            gradation_mode = 0;
            return;
        }
        case 1: {
            int               j;
            CMenuPosDataForm *form = invent_okeff_form;

            if (form != 0) {
                j = 0;
                form->rgba[0] = 0x80;
                form->rgba[1] = 0x80;
                form->rgba[2] = 0x80;
                form->rgba[3] = 0x80;

                do {
                    form->SetRGBACalcParam(j, 0, 0x80);
                    j++;
                } while (j < 4);

                signed char rows[2] = {0, 1};

                do {
                    MENUFORMPARTS_TYPE *part = invent_okeff_form->GetPartInfo(invent_grade_fff[i]);
                    part->y = 224.0f;
                    part->h = 0.0f;
                    int                        row = rows[i];
                    u8                        *first = invent_color_tbl[2][row];
                    MENU_PARTS_EFFECT_STRUCT1 *first_effect = part->effect;
                    first_effect->param[0] = first[0];
                    first_effect->param[1] = first[1];
                    first_effect->param[2] = first[2];
                    first_effect->param[3] = first[3];
                    u8                        *second = invent_color_tbl[2][row ^ 1];
                    MENU_PARTS_EFFECT_STRUCT1 *second_effect = &part->effect[1];
                    second_effect->param[0] = second[0];
                    second_effect->param[1] = second[1];
                    second_effect->param[2] = second[2];
                    second_effect->param[3] = second[3];
                    i++;
                } while (i < 2);
            }

            gradation_mode = 1;
            gradation_height = 0;
            return;
        }
        case 2: {
            CMenuPosDataForm *form = invent_okeff_form;

            if (form != 0) {
                form->rgba[0] = 0x80;
                form->rgba[1] = 0x80;
                form->rgba[2] = 0x80;
                form->rgba[3] = 0x80;

                do {
                    form->SetRGBACalcParam(i, 0, 0x80);
                    i++;
                } while (i < 4);
            }

            gradation_mode = 2;
            return;
        }
        case 3:
            gradation_mode = 3;
            return;
        default:
            gradation_mode = mode;
            return;
    }
}

void CMenuInvent::GradationStep() {
    if (invent_okeff_form == NULL) {
        return;
    }

    int                 i;
    MENUFORMPARTS_TYPE *part;
    int steps[3] = {30, 60, 90};

    switch (gradation_mode) {
        case 1: {
            int grown = 0;

            for (i = 0; i < 2; i++) {
                part = invent_okeff_form->GetPartInfo(invent_grade_fff[i]);

                if (steps[2] >= gradation_height) {
                    part->h = gradation_height;

                    if (i % 2 == 0) {
                        part->y = 224.0f - part->h;
                    }

                    grown = 1;
                }
            }

            if (grown) {
                gradation_height += 4;
            }

            break;
        }
        case 3:
            for (i = 0; i < 2; i++) {
                part = invent_okeff_form->GetPartInfo(invent_grade_fff[i]);
                int k;
                int row = 0;

                if (i == 1) {
                    row = 1;
                }

                for (int j = 0; j < 2; j++) {
                    MENU_PARTS_EFFECT_STRUCT1 *effect = &part->effect[j];

                    for (k = 0; k < 3; k++) {
                        float now = effect->param[k];
                        int   next = now;
                        u_int target = invent_color_tbl[create_step][row][k];

                        if (now < target) {
                            next = now + 2.0f;
                        } else if (!(now <= target)) {
                            next = now - 2.0f;
                        }

                        if (next < 0) {
                            next = 0;
                        }

                        if (next > 255) {
                            next = 255;
                        }

                        effect->param[k] = next;
                    }

                    row ^= 1;
                }
            }

            break;
    }
}

void CMenuInvent::InitEnd() {
    BG_READ_INFO *read_info;

    read_info = (BG_READ_INFO *) InventSubDataReadBGInfo;
    album_enable = 1;

    if (GetUserDataMan()->GetNumSameItem(0x165) <= 0) {
        album_enable = 0;
    }

    if (photo_only == 1) {
        EnterDataMenu((u8 *) read_info->buffer);
        ExeScript("\x8d\x6c\x82\xa6\x83\x82\x81\x5b\x83\x68" "0");
        ExeScript("\x8e\xca\x90\x5e\x8a\x6d\x94\x46\x83\x82\x81\x5b\x83\x68\x8f\x89\x8a\xfa\x89\xbb");
        PrepareNextMode((int) key_arg_no);
    }

    cursor_snap = 1;
    ExeScript("INIT_END");
    MenuItemBrdCalcManner = 0;
}

void CMenuInvent::ExitEnd() {
    CMenuSystemData *sys = GetMenuSysData();

    if (sys != NULL) {
        sys->invent_item.select = this->item_cursor;
        sys->invent_item.top = this->item_top;
        sys->invent_card.select = this->card_cursor;
        sys->invent_card.top = this->card_top;
        sys->invent_photo.select = this->photo_cursor;
        sys->invent_photo.top = this->photo_top;
        sys->invent_album.select = this->album_cursor;
        sys->invent_album.top = this->album_top;
        sys->invent_memo.select = this->memo_cursor;
        sys->invent_memo.top = this->memo_top;
        sys->invent_memo_sort_mode = this->memo_sort_mode;
    }

    InventUserDataPtr->PhotoCheckEnd();
    ExeScript("\x96\x7b\x8f\x49\x97\xb9\x8f\x88\x97\x9d");
}

void CMenuInvent::EnterDataMenu(u8 *pack) {
    mgCTextureManager *tex_manager = &mgTexManager;
    u_int             *file = GetPackFile((unsigned int *) pack, "inv_bg.img", 0);

    if (file != 0) {
        int image_block = this->tex_block[3];

        if (file != 0) {
            tex_manager->EnterIMGFile((u8 *) file, image_block, 0, 0);
            Tex_Hatsumei = tex_manager->GetTexture("inv0", -1);
        }

        file = GetPackFile((unsigned int *) pack, "edmenu.img", 0);

        if (file != 0) {
            tex_manager->EnterIMGFile((u8 *) file, MenuCommonInfo->tex_block[1], 0, 0);
            (MenuPosData)->AttachCommonTexInfo();
        }

        int size = 0;
        MenuDataAnalyze((char *) GetPackFile((unsigned int *) pack, "invent.cfg", &size), size, &data_stack);
        MenuInventStack.Align64();

        icon_data[0].data = GetPackFile((u_int *) pack, icon_data[0].name, &icon_data[0].size);
        icon_data[1].data = GetPackFile((u_int *) pack, icon_data[1].name, &icon_data[1].size);
        icon_data[2].data = GetPackFile((u_int *) pack, icon_data[2].name, &icon_data[2].size);
        AttachPictTex(tex_block[3], photo_tex, InventUserDataPtr->GetPhotoInfo(0), 0x1E);
        script = (char *) GetPackFile((unsigned int *) pack, "inv_com.cfg", &script_size);
        int size2 = 0;
        InventManagePt->LoadAnalyzeInventFile((char *) GetPackFile((unsigned int *) pack, "inv6.lst", &size2),
                                              size2);
    }

    AttachFormInfo();
    MenuMoveItemPtr->AttachForm();
}

int CMenuInvent::ItemCmdAfter(int command, ITEMCMD_RET_PARA *para) {
    if (para->menu_cmd >= -1) {
        MenuSePlay(para->cmd);
        signed char result = para->menu_cmd;

        switch (result) {
            case 0:
            case 1: {
                SetPreCmdTrush(this, 5, ask_para.item, MenuMesForm[5]);

                if (MenuCommonInfo->cursor_form != NULL) {
                    MenuCommonInfo->cursor_form->draw_flag = 0;
                }
            }
        }
    }

    return 1;
}

extern CGamePad GamePad__2;

/**
 *
 * Stores the path prefix used for an inventory asset.
 *
 */
struct PathPrefix {
    u_long128 chunk[4]; /**< Four quadwords containing the prefix. */
};

extern PathPrefix  at_2913;
extern char        at_3113[];
extern char        at_3114[];
extern char        at_3115[];
extern char        at_3116[];
extern char        at_3117[];
extern char        at_3118[];
extern char        at_3119[];
extern char        at_3120[];
extern char        at_3121[];
extern char        at_3122[];
extern char        at_3123[];
extern char        at_3124[];
extern char        at_3125[];
extern char        at_3126[];
extern char        at_3127[];
extern char        at_3128[];
extern char        at_3129[];
extern char        at_3130[];
extern char        at_3131[];
extern char        at_3132[];
extern char        at_3133[];
extern char        at_3134[];
extern char        at_3135[];

/**
 *
 * Prefix used for an automatically proposed invention name.
 *
 */
static char *Tb_2819[7] = {
    "\x82\xa4\x81\x5b\x82\xf1",
    "Ummm",
    "Ummm",
    "Ummm",
    "Ummm",
    "Ummm",
    "Ummm"
};

/**
 *
 * Question endings appended to a proposed Japanese invention name.
 *
 */
static char *gobitbl_2847[2] = {
    "\x82\xa9\x82\xe0\x81\x48",
    "\x82\xa9\x82\xc8\x81\x48"
};

/**
 *
 * Item model assets selected for invention outcomes.
 *
 */
static char *getfilename_2928[2] = {
    "inv_ng.mds",
    "inv_ok.mds"
};

/**
 *
 * Sound banks selected for invention outcomes.
 *
 */
static char *sndfileName_2951[2] = {
    "snd2/sp/SP_008.snd",
    "snd2/sp/SP_009.snd"
};

/**
 *
 * Wave names used during the invention sound sequence.
 *
 */
static char *wavname_2960[3] = {
    "200",
    "190",
    "180"
};

/**
 *
 * Sound-bank time limits of the two invention stages.
 *
 */
static short sndtimetbl_2868[2] = {
    210, 280
};

extern signed char D_003532DF[];

/**
 *
 * Lighting colour used for the invented item model.
 *
 */
static float eff_light_2927[4] = {255.0f, 255.0f, 255.0f, 128.0f};

#pragma inline_depth(5)
#ifdef NONMATCHING
int CMenuInvent::IsCreateObject(int mode, int keys) {
    CActionChara      *action_chara = MenuActionChara[0];
    CDC2Mes           *message_window = MenuDCMsg[4];
    mgCMemory         *load_stack = &MenuCharaLoadStack;
    mgCTextureManager *texture_manager = &mgTexManager;
    s16                state = this->step;

    switch (state) {
        case kCreateAsk: {
            s32 answer = -1;
            if (state <= 0) {
                answer = message_window->YesNoCursor();
            }
            switch (keys) {
                case kCreateKeyConfirm:
                    if (answer == 0) {
                        this->key_arg_no = 0;
                        this->create_chara = NULL;
                        this->create_step = 0;
                        if (0 < this->create_item_id) {
                            this->create_step = 1;
                            InventUserDataPtr->SetCreateItemFlag(this->card_cursor, this->create_item_id);
                        } else {
                            s32 recipe_index;
                            s32 recipe_offset;
                            this->create_partial_match = 0;
                            InventUserDataPtr->GetPhotoInfo(0);
                            recipe_index = 0;
                            recipe_offset = 0;
                            while (InventManagePt->num != 0) {
                                INVENT_DATA_INFO  *recipe;
                                CInventDataManage *table = InventManagePt;
                                if (recipe_index < 0 || table->num <= recipe_index) {
                                    recipe = NULL;
                                } else {
                                    recipe = (INVENT_DATA_INFO *) ((u8 *) table->table + recipe_offset);
                                }
                                if (recipe == NULL) {
                                    break;
                                }
                                if (!(0 < InventUserDataPtr->IsAlreadyCreatedItem(recipe->item_id))) {
                                    s32        matched = 0;
                                    s32        index;
                                    s32        need;
                                    FoundSlots found = at_2776;
                                    for (index = 0; index < 3; index++) {
                                        need = recipe->neta_id[index];
                                        s32 slot;
                                        this->create_photo_neta[index] = need;
                                        for (slot = 0; slot < 3; slot++) {
                                            s32 id = this->GetNowSelectNetaID(slot);
                                            if (id == need) {
                                                this->create_photo_neta[index] = 0;
                                                found.v[slot] = 1;
                                                matched++;
                                                break;
                                            }
                                        }
                                    }
                                    if (matched == 2) {
                                        s32 slot_index;
                                        this->create_partial_match = 1;
                                        for (slot_index = 0; slot_index < 3; slot_index++) {
                                            if (found.v[slot_index] == 0) {
                                                this->create_missing_slot = slot_index;
                                            }
                                        }
                                        break;
                                    }
                                }
                                recipe_offset += sizeof(INVENT_DATA_INFO);
                                recipe_index++;
                            }
                        }
                        this->create_wait_time = 0x7C;
                        this->ExeScript(at_3113);
                        this->GradationSet(1);
                        this->step = kCreateWaitStart;
                        load_stack->stack_used = 0;
                        load_stack->lock = 0;
                        StartReadBG();
                        s32 sound_message_size;
                        LoadFileBG(at_3114, load_stack->stGetTop(), &sound_message_size);
                        this->create_load_state = kLoadSoundMsg;
                        break;
                    }
                case kCreateKeyCancel:
                    this->ExeScript(at_3115);
                    this->mode = 0;
                    break;
            }
            break;
        }
        case kCreateWaitStart:
            this->create_wait_time--;
            if (this->create_wait_time <= 0 && this->create_load_state > 1) {
                this->step++;
            }
            break;
        case kCreateShowReady:
            action_chara->GetNowMotionName();
            s32 motion = action_chara->seq_state;
            if (this->create_load_state >= 5 && motion == 3) {
                this->step++;
                action_chara->seq_advance = 1;
                action_chara->SetMotion(at_3116, 4, 1);
                this->jingle_state = 1;
                this->jingle_pending = 1;
                this->jingle_time = 0;
                this->poly_chr_form[1]->SetActionCharaPtr(this->create_chara, this->tex_block[2], -1);
                this->GradationSet(3);
                MenuCommonInfo->MenuPosPlay();
                this->create_spin_angle = 0.0f;
                this->create_wobble_phase = 0.0f;
                this->create_show_phase = 0;
                this->create_scale_in = 0.0f;
                if (this->create_step != 0) {
                    this->ExeScript(at_3117);
                    if (this->create_chara != NULL) {
                        INVENT_DATA_INFO *recipe;
                        mgCFrame         *frame = this->create_chara->CObjectFrame::frame;
                        recipe = InventManagePt->GetInventDataInfoByItemID(this->create_item_id);
                        this->create_scale = MenuAdjustPolygonScale(frame, 7.0f);
                        this->create_chara->SetScale(0.0f, 0.0f, 0.0f);
                        this->create_chara->SetPosition(-10.0f, 3.4f, 0.0f);
                        if (recipe != NULL) {
                            this->create_scale = recipe->model_scale;
                            this->create_chara->SetPosition(recipe->model_pos[0], recipe->model_pos[1],
                                                            recipe->model_pos[2]);
                        }
                        this->create_chara->Step();
                        if (this->create_item_id == 0x88) {
                            this->create_scale = 0.45f;
                            this->create_chara->SetPosition(-10.0f, 0.4f, 0.0f);
                        }
                        MenuRoboPartsLightOff(frame);
                    }
                } else if (this->create_partial_match != 0) {
                    s32 index;
                    this->ExeScript(at_3118);
                    for (index = 0; index < 3; index++) {
                        if (this->create_photo_neta[index] > 0) {
                            USER_PICTURE_INFO info;
                            char             *name;
                            s32               length;
                            info.neta_id = this->create_photo_neta[index];
                            info.used = 1;
                            name = GetPhotoName(&info);
                            if (name != NULL) {
                                strcpy((char *) this->create_photo_name, name);
                            } else {
                                strcpy((char *) this->create_photo_name, Tb_2819[LanguageCode]);
                            }
                            length = strlen((char *) this->create_photo_name);
                            if (length > 2) {
                                s32 half_length = length >> 1;
                                if (LanguageCode == 0) {
                                    s8 cut = D_003532DF[half_length];
                                    this->create_photo_name[cut] = -0x7F;
                                    this->create_photo_name[cut + 1] = -0x66;
                                } else if (LanguageCode > 0) {
                                    s32 character_index = length / 4;
                                    if (character_index <= 0) {
                                        character_index = 1;
                                    }
                                    for (; character_index < length; character_index++) {
                                        this->create_photo_name[character_index] = '.';
                                    }
                                }
                            } else if (name != NULL) {
                                sprintf((char *) this->create_photo_name, at_3119, name, gobitbl_2847[GetRandI(2)]);
                            } else {
                                strcpy((char *) this->create_photo_name, "\x82\xa4\x81\x5b\x82\xf1");
                            }
                            break;
                        }
                    }
                    this->neta_circle_snap = 1;
                } else {
                    this->ExeScript(at_3120);
                }
                MenuSePlay(0, this->create_sound_buffer, &MenuSoundBuffer);
            }
            break;
        case kCreateShow: {
            if (this->create_step != 0) {
                if (this->create_chara != NULL) {
                    float scale[4];
                    this->create_chara->GetScale(scale);
                    switch (this->create_show_phase) {
                        case 0:
                            if (CalcMenuAdd(&this->create_scale_in, 0.4f, this->create_scale_in) != 0) {
                                this->create_show_phase = 1;
                                this->create_spin_angle = 0.0f;
                                this->create_wobble_amp = 0.4f * this->create_scale;
                            }
                            scale[0] = this->create_scale_in;
                            break;
                        case 1:
                            scale[0] = this->create_scale + this->create_wobble_amp * sinf(0.10471976f * this->create_wobble_phase);
                            float step = -0.02f;
                            CalcMenuAdd(&this->create_wobble_amp, float(-0.02), 0.0f);
                            CalcMenuAdd(&this->create_spin_angle, 0.15707964f, 15.707964f);
                            CalcMenuAdd(&this->create_wobble_phase, 1.0f, 600.0f);
                            if (menu_debug_flag != 0) {
                                float move[4];
                                float scale_step = -GamePad__2.GetRYf() / 8.0f;
                                float move_x;
                                float move_y;
                                this->create_scale += scale_step;
                                scale[0] += scale_step;
                                if (scale[0] <= 0.0f) {
                                    scale[0] = 0.0f;
                                }
                                move_x = GamePad__2.GetLXf() / 10.0f;
                                move_y = -GamePad__2.GetLYf() / 10.0f;
                                this->create_chara->GetPosition(move);
                                move[0] += move_x;
                                move[1] += move_y;
                                this->create_chara->SetPosition(move);
                            }
                            break;
                    }
                    this->create_chara->SetScale(scale[0], scale[0], scale[0]);
                    AddRotationCharaY((CCharacter2 *) this->create_chara, 0.01308997f);
                    this->create_chara->Step();
                }
            }
            switch (this->jingle_state) {
                case 0:
                    break;
                case 1:
                    if (this->jingle_pending != 0) {
                        s16 jingle_length = sndtimetbl_2868[this->create_step];
                        if (this->jingle_time > jingle_length / 2) {
                            this->jingle_pending = 0;
                            this->ExeScript(at_3121);
                            if (this->create_step != 0) {
                                char *message = GetItemMessage(this->create_item_id);
                                if (message != NULL) {
                                    strcpy(message_window->name[0], message);
                                }
                                message_window->MakeMsg(kMsgItemCreated);
                            } else if (this->create_partial_match != 0) {
                                char *name;
                                message_window->MakeMsg(kMsgPhotoNamed);
                                name = (char *) this->create_photo_name;
                                if (name != NULL) {
                                    strcpy(message_window->name[0], name);
                                }
                            } else {
                                message_window->MakeMsg(kMsgNothingNew);
                            }
                        }
                    }
                    this->jingle_time++;
                    if (this->jingle_time > sndtimetbl_2868[this->create_step]) {
                        MenuCommonInfo->FadeInMenuBGMVol(6);
                        this->jingle_state = 0;
                    }
                    break;
            }
            if (this->create_partial_match != 0) {
                u32 color;
                this->blink_time++;
                if (this->blink_time >= 0x32) {
                    this->blink_time = 0;
                }
                color = kBlinkDark;
                if (this->blink_time >= 0x19) {
                    color = kBlinkLight;
                }
                CDC2Mes *color_window = MenuDCMsg[7];
                if (this->create_missing_slot >= 0 && this->create_missing_slot < 0x14) {
                    color_window->line_color[this->create_missing_slot] = color;
                }
            }
            if (this->jingle_state == 0 && ((keys & kCreateKeyConfirm) || (keys & kCreateKeyCancel))) {
                s32 cursor[2];
                this->step = 0;
                this->mode = 0;
                if (this->create_load_state == kLoadJingleOpen || this->create_load_state == kLoadJinglePlay) {
                    CSnd.StreamClose(1);
                    this->create_load_state = -2;
                }
                action_chara->DeleteExtMotion();
                MenuCommonInfo->FadeInMenuBGMVol(6);
                this->create_effect = NULL;
                if (this->create_step != 0 ||
                    ((s16) this->create_step == 0 && this->create_partial_match == 0)) {
                    this->InitNetaCircle(0);
                } else {
                    this->InitNetaCircle(1);
                }
                this->ExeScript(at_3122);
                this->create_step = 0;
                CDC2Mes *color_window = MenuDCMsg[7];
                if (this->create_missing_slot >= 0 && this->create_missing_slot < 0x14) {
                    color_window->line_color[this->create_missing_slot] = kLineColorNormal;
                }
                this->GradationSet(0);
                this->poly_chr_form[1]->SetActionCharaPtr(NULL, this->tex_block[2], -1);
                this->GetNetaBoardCursorPosition(this->photo_cursor, cursor);
                MenuCommonInfo->MenuSetPos(cursor[0], cursor[1]);
            }
            break;
        }
        case kCreateAfter:
            if (keys != 0) {
                this->ExeScript(at_3115);
                this->step = 0;
                this->mode = 0;
            }
            break;
        default:
            this->step = 0;
            this->mode = 0;
            break;
    }

    s32 read_done = ReadBGSync();
    switch (this->create_load_state) {
        case -2:
            break;
        case kLoadSoundMsg:
            if (read_done == 0) {
                BG_READ_INFO *file = GetReadBGFile(0);
                if (file != NULL) {
                    MenuSePlay(0, (u32 *) file->buffer, &MenuSoundBuffer);
                    MenuCommonInfo->FadeOutMenuBGMVol(-3, 0x18);
                }
                this->create_load_state = kLoadModel;
            }
            break;
        case kLoadModel: {
            PathPrefix path;
            s32        model_blocks;
            s32        motion_size;
            action_chara->SetMotion(at_3123, 0, 1);
            load_stack->stack_used = 0;
            load_stack->lock = 0;
            load_stack->Align64();
            path = at_2913;
            model_blocks = kItemModelBlocks;
            if (this->create_step != 0) {
                strcat((char *) &path, at_3124);
            } else {
                if (this->create_partial_match != 0) {
                    strcat((char *) &path, at_3125);
                } else {
                    strcat((char *) &path, at_3126);
                }
                model_blocks = kPhotoModelBlocks;
            }
            this->chara_stack.stSetBuffer(load_stack->stGetTop(), model_blocks);
            load_stack->Alloc((model_blocks * 16 & 15) != 0 ? ((unsigned int) (model_blocks * 16) >> 4) + 1 : (unsigned int) (model_blocks * 16) >> 4);
            this->create_model_file = (u8 *) load_stack->stGetTop();
            StartReadBG();
            LoadFileBG((char *) &path, (u_long128 *) this->create_model_file, &motion_size);
            this->create_motion_file = this->create_model_file + motion_size / 16 * 16;
            LoadFileBG(at_3127, (u_long128 *) this->create_motion_file, &motion_size);
            this->create_load_state = kLoadModelDone;
            break;
        }
        case kLoadModelDone:
            if (this->create_wait_time <= 0 && read_done == 0) {
                float             pos[4];
                float             rot[4];
                BG_READ_INFO     *pack_bg;
                MDS_HEADER       *pack_file;
                mgCFrame         *frame;
                CMenuPosDataForm *form;
                GetReadBGFile(0);
                action_chara->GetPosition(pos);
                action_chara->GetRotation(rot);
                strcpy(texture_manager->name_suffix, at_3128);
                action_chara->LoadPack((unsigned int *) this->create_model_file, at_2249, &this->chara_stack,
                                       &this->chara_stack, &this->chara_stack, this->tex_block[1], 0);
                texture_manager->name_suffix[0] = 0;
                action_chara->SetPosition(pos);
                action_chara->SetRotation(rot);
                if (this->create_step != 0) {
                    texture_manager->TexAnimeOn(this->tex_block[1], at_3129);
                    texture_manager->TexAnimeOn(this->tex_block[1], at_3130);
                } else {
                    texture_manager->TexAnimeOn(this->tex_block[1], at_3131);
                    texture_manager->TexAnimeOn(this->tex_block[1], at_3132);
                }
                pack_bg = GetReadBGFile(1);
                pack_file = NULL;
                if (pack_bg != NULL) {
                    pack_file = (MDS_HEADER *) GetPackFile((u32 *) pack_bg->buffer, getfilename_2928[this->create_step], NULL);
                }
                this->create_effect = NewInventActionChara(load_stack);
                this->create_effect->Initialize(0);
                frame = mgLoadMDSFile(pack_file, load_stack, NULL, NULL);
                this->create_effect->CObjectFrame::frame = frame;
                float effect_y = -20.0f;
                if (frame != NULL) {
                    mgCFrameAttr *attr = (mgCFrameAttr *) frame->attr;
                    attr->no_light = 1;
                    attr->color[0] = eff_light_2927[0];
                    attr->color[1] = eff_light_2927[1];
                    attr->color[2] = eff_light_2927[2];
                    attr->color[3] = eff_light_2927[3];
                    float y = -20.0f;
                    this->create_effect->SetPosition(18.0f, y, 20.0f);
                    this->create_effect->SetRotation(0.0f, 0.15707964f, 0.0f);
                    frame->SetAttrParam(*attr, 1, kSceneAttrFlags);
                }
                form = MenuPosData->GetFormInfo(at_3133);
                if (form != NULL) {
                    form->SetActionCharaPtr(this->create_effect, -1, -1);
                    form->counter = 0;
                    form->ambient[0] = -1.0f;
                }
                this->create_load_state = kLoadSoundBank;
                load_stack->Align64();
                this->create_timer = 100;
                if (this->create_step != 0) {
                    u8   *item_file;
                    char *item_path;
                    s32   item_size;
                    this->create_timer = 200;
                    this->create_chara = NewInventActionChara(load_stack);
                    this->create_chara->Initialize(0);
                    this->item_model_memory.stSetBuffer(load_stack->stGetTop(), 0x35C0);
                    this->item_model_memory.stack_used = 0;
                    this->item_model_memory.lock = 0;
                    load_stack->Alloc(0x35C0);
                    load_stack->Align64();
                    item_file = (u8 *) load_stack->stGetTop();
                    item_path = GetItemFilePath(this->create_item_id, 1);
                    if (item_path != NULL) {
                        if (*item_path != 0) {
                            StartReadBG();
                            LoadFileBG((char *) item_path, (u_long128 *) item_file, &item_size);
                        }
                    }
                    this->create_load_state = kLoadItemModel;
                }
            }
            break;
        case kLoadItemModel:
            if (read_done == 0) {
                BG_READ_INFO *item_bg = GetReadBGFile(0);
                if (item_bg != NULL && this->create_chara != NULL) {
                    texture_manager->DeleteBlock(this->tex_block[2]);
                    strcpy(texture_manager->name_suffix, at_3134);
                    this->create_chara->Initialize(0);
                    this->create_chara->LoadPack((unsigned int *) item_bg->buffer, at_2249, &this->item_model_memory,
                                                 &this->item_model_memory, &this->item_model_memory, this->tex_block[2], 0);
                    texture_manager->name_suffix[0] = 0;
                }
                this->create_load_state++;
            }
            break;
        case kLoadSoundBank: {
            s32 sound_size;
            load_stack->Align64();
            StartReadBG();
            this->create_sound_buffer = (u32 *) load_stack->stGetTop();
            LoadFileBG(sndfileName_2951[this->create_step], (u_long128 *) this->create_sound_buffer, &sound_size);
            load_stack->Alloc((sound_size & 15) != 0 ? ((unsigned int) sound_size >> 4) + 1 : (unsigned int) sound_size >> 4);
            this->create_load_state++;
            break;
        }
        case kLoadSoundPort:
            if (read_done == 0) {
                sndInitPort(8);
                this->create_load_state++;
            }
            break;
        case kLoadJingleOpen:
            this->create_timer--;
            if (this->create_timer == 0x28) {
                s32  wave = this->create_step;
                char wave_name[0x88];
                if (wave == 1) {
                    wave = GetRandI(2) + 1;
                }
                sprintf(wave_name, at_3135, wavname_2960[wave]);
                CSnd.StreamOpenFast(1, wave_name);
            }
            if (this->create_timer <= 0) {
                while (CSnd.StreamOpenState() != 0) {
                }
                CSnd.StreamStandBy(1);
                while (CSnd.StreamOpenState() != 0) {
                }
                CSnd.StreamSetVol(1, 0x7FFF, 0x7FFF);
                CSnd.StreamPlay(1);
                this->create_timer = 0x50;
                this->create_load_state++;
            }
            break;
        case kLoadJinglePlay:
            s32 play_state = CSnd.StreamGetState(1);
            this->create_timer--;
            if ((play_state & 0x8000) && this->create_timer <= 0) {
                CSnd.StreamClose(1);
                this->create_load_state++;
            }
            break;
    }
    return 1;
}

#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/inventmn", IsCreateObject__11CMenuInventFii);
#endif
#pragma inline_depth reset

void CMenuInvent::CalcMakeBrd(int message_index) {
    if (makebrd_form != NULL && makebrd_form->draw_flag) {
        make_board.make_num = make_num;
        make_board.material_num = 4;
        MakeItemNeeds needs;
        InventManagePt->HowMuchZairyouMakeItem(make_item_no, make_num, (int *) &needs);
        int index = 0;

        for (; index < needs.num; index++) {
            make_board.line[index].kind = 1;
            int owned = GetUserItemHaveNum(needs.need[index].item_id);

            if (owned >= needs.need[index].amount) {
                make_board.line[index].button = 1;
            } else {
                make_board.line[index].button = 0;
            }

            make_board.line[index].sub_num = (short) needs.need[index].amount - owned;

            if (make_board.line[index].sub_num < 0) {
                make_board.line[index].sub_num = 0;
            }

            make_board.line[index].num = (short) needs.need[index].amount;
        }

        for (; index < 4; index++) {
            make_board.line[index].kind = 0;
            make_board.line[index].button = 0;
            make_board.line[index].num = 0;
            make_board.line[index].sub_num = 0;
        }

        make_board.make_cursor = make_cursor;
        CalcMenuAdd(&make_board.decrease_flash_frames, -1, 0);
        CalcMenuAdd(&make_board.increase_flash_frames, -1, 0);
        CalcCommonBrdDrawInfo(&makebrd_form->x, &make_board, MenuDCMsg[message_index]);
    }
}

int CMenuInvent::EnableSelectMaxCardList() {
    int count;

    count = InventUserDataPtr->GetHatsumeiNum() + 1;

    if (count < 5) {
        count = 5;
    }

    return count;
}

void CMenuInvent::CalcCursorPosition() {
    if (mode == 2) {
        MenuCommonInfo->SetWakuType(-1);
        return;
    }

    if (mode == 1) {
        MenuCommonInfo->SetWakuType(-1);
    }

    int cursor[4] = {10, 10, 0, 0};
    char            text[0x28];
    CursorPos       offset = {0, 0};
    CursorPos       waku;
    CursorPos       command_pos;
    sprintf(text, "wakuwh%d", key_arg_no);
    MenuPosData->GetEtcTblValue(text, waku.x, waku.y);
    sprintf(text, "c_of%d", key_arg_no);
    MenuPosData->GetEtcTblValue(text, offset.x, offset.y);
    MenuCommonInfo->SetWakuWH(wakutype_3203[key_arg_no], waku.x, waku.y);
    MenuCommonInfo->SetWakuType(wakutype_3203[key_arg_no]);

    switch (key_arg_no) {
        case INVENT_MODE_THINK:
        case INVENT_MODE_THINK_WITH_ALBUM:
        case INVENT_MODE_PHOTO_VIEW:
            GetNetaBoardCursorPosition(photo_cursor, cursor);

            if (neta_board_form != NULL) {
                cursor[1] = 108.0f + (4.0f + neta_board_form->y) + (float) ((photo_cursor / 2 - photo_top) * 54);
            }

            cursor[0] += 3;
            cursor[1] += 2;
            command_pos.x = cursor[0];
            command_pos.y = cursor[1];
            break;
        case INVENT_MODE_THINK_ALBUM_BUTTON:
        case INVENT_MODE_PHOTO_ALBUM_BUTTON:
            album_sw_form->GetPutPosXY("cur", cursor[0], cursor[1]);
            break;
        case INVENT_MODE_CARD_LIST:
            cursor[0] = card_list_form->x - 40.0f;
            cursor[1] = (card_cursor - card_top) * 46 + 72;

            if (mode == 6) {
                cursor[0] = -50.0f + MakeBoardDrawInfo[make_cursor * 2];
                cursor[1] = MakeBoardDrawInfo[make_cursor * 2 + 1];
            }

            break;
        case INVENT_MODE_ITEM_LIST:
            MenuPosData->GetPosMenuItemOnItemBrd(cursor, item_cursor, 1);
            cursor[0] -= 8;
            cursor[1] -= 10;
            command_pos.x = cursor[0];
            command_pos.y = cursor[1];
            break;
        case INVENT_MODE_ALBUM_VIEW:
            sprintf(text, "cur%d", album_cursor - album_top * 2);
            album_big_form->GetPutPosXY(text, cursor[0], cursor[1]);
            command_pos.x = cursor[0];
            command_pos.y = cursor[1];
            break;
        case INVENT_MODE_MEMO_BUTTON:
            neta_board_form->GetPutPosXY("\x83\x6c\x83\x5e\x92\xa0\x88\xca\x92\x75", cursor[0], cursor[1]);
            break;
        case INVENT_MODE_MEMO_CORK:
            neta_memo_form->GetPutPosXY("\x83\x52\x83\x8b\x83\x4e", cursor[0], cursor[1]);
            break;
        case INVENT_MODE_MEMO_ARROW:
            neta_board_form->GetPutPosXY("\x83\x6c\x83\x5e\x92\xa0\x96\xee\x88\xf3", cursor[0], cursor[1]);
            break;
        case INVENT_MODE_MEMO_LIST:
            GetNetaMemoCursorPosition(memo_cursor - memo_top, cursor);
            cursor[0] -= 32;
            break;
    }

    MenuItemCommandDir = -1;

    if (mode == 4 || (mode == 12 && step == 0)) {
        SetItemCmdMsgPos(&command_pos.x);
    }

    if (mode == 5 || mode == 4 || mode == 12 || mode == 9 || mode == 14) {
        MenuCommonInfo->SetWakuType(-1);
    }

    MenuCommonInfo->MenuPosStep(cursor, &offset.x);

    if (cursor_snap != 0) {
        MenuCommonInfo->MenuSetPos(cursor[0], cursor[1]);
        cursor_snap = 0;
    }
}

int CMenuInvent::IsMakeObject(int keys, int button) {
    switch (step) {
        case 0: {
            int select = SelectMakeObject(keys);

            if (select == -1) {
                make_board.decrease_flash_frames = 6;
                make_board.increase_flash_frames = 0;
            } else if (select == 1) {
                make_board.decrease_flash_frames = 0;
                make_board.increase_flash_frames = 6;
            }

            switch (button) {
                case 1:
                    if (make_cursor == 0) {
                        int enough = InventManagePt->CheckMakeItem(make_item_no, make_num, MenuUserParam.used_data);
                        make_space_no = GetUserDataMan()->SearchSpaceUsedData();

                        if (enough == 0) {
                            step = 3;
                            ExeScript("ITEM\x95\x73\x91\xab");
                        } else if (make_space_no < 0) {
                            step = 3;
                            ExeScript("\x8b\xf3\x82\xab\x96\xb3\x82\xb5");
                        } else {
                            if (make_item_no == 0xA5) {
                                GetSaveData()->SetBitFlag(13, 1);
                            }

                            if (make_item_no == 0x12F) {
                                GetSaveData()->SetBitFlag(48, 1);
                            }

                            InventManagePt->DeleteUserUsedItem(make_item_no, make_num);
                            make_space_no = GetUserDataMan()->SearchSpaceUsedData();
                            int row = make_space_no / 6;

                            if (item_top > row) {
                                while (row < item_top) {
                                    item_top--;
                                }
                            } else if (item_top + 5 <= row) {
                                while (item_top + 5 <= row) {
                                    item_top++;
                                }
                            }

                            item_cursor = make_space_no;
                            step = 10;
                            MenuCharaLoadStack.stack_used = 0;
                            MenuCharaLoadStack.lock = 0;
                            MenuCharaLoadStack.Alloc(0xC0);
                            load_sound_buffer = MenuCharaLoadStack.stack + MenuCharaLoadStack.stack_used;
                            StartReadBG();
                            int size;
                            LoadFileBG("snd2/sp/SP_001.snd", (u_long128 *) load_sound_buffer, &size);
                            u_int bytes = size + 16;
                            MenuCharaLoadStack.Alloc((bytes & 0xF) ? (bytes >> 4) + 1 : bytes >> 4);
                        }

                        break;
                    }
                case 2:
                    mode = 0;
                    ExeScript("\x8d\xec\x90\xac\x83\x7b\x81\x5b\x83\x68OFF");
                    MenuSePlay(5);
                    MenuCommonInfo->SetVibeR(6, 4);
                    break;
            }

            break;
        }
        case 10:
            if (ReadBGSync() == 0) {
                int koma[10] = {256, 225, 100, 100};
                MenuPosData->GetPosMenuItemBrdKoma(koma, make_space_no, 0);
                mgCTexture *effect_tex = MenuPosData->icon_effect_tex;
                MenuEffect[0]->PresetEffect(&MenuCharaLoadStack, effect_tex, 0, koma);
                MenuEffect[0]->EffectStart();
                koma[2] = 32;
                koma[3] = 40;
                MenuEffect[1]->PresetEffect(&MenuCharaLoadStack, effect_tex, 4, koma);
                MenuEffect[1]->EffectStart();
                MenuCommonInfo->SetVibeR(6, 4);

                if (MenuCommonInfo->cursor_form != NULL) {
                    MenuCommonInfo->cursor_form->draw_flag = 0;
                }

                ExeScript("\x8d\xec\x90\xac\x83\x7b\x81\x5b\x83\x68OFF");
                MenuSePlay(0, (u_int *) load_sound_buffer, &MenuSoundBuffer);
                CreateModeSwapForm(1);
                step = 1;
            }

            break;
        case 1:
            if (MenuEffect[1]->counter == 0x70) {
                CGameDataUsed *space = GetUserDataMan()->SearchSpaceUsedDataPtr();

                for (int i = 0; i < make_num; i++) {
                    GetUserDataMan()->CopyGameData(space, make_item_no);
                    GetUserDataMan()->GetCostume(make_item_no);
                }

                CheckEnableHaveItemNum();
            }

            if (MenuEffect[1]->run == 0) {
                step++;
                ExeScript("MSG_ITEMMAKE");
                char *names[2] = {NULL, NULL};
                names[0] = GetItemMessage(make_item_no);
                CDC2Mes *message = MenuDCMsg[4];
                message->SetMsgItemNo(names, 1);
                message->SetMsgVolumeNoOne(make_num);
            }

            break;
        case 2:
            if (button != 0) {
                CreateModeSwapForm(0);
                ExeScript("ERRMSGOFF0");
                MenuSePlay(1);
                mode = 0;
                step = 0;
                make_cursor = 1;
            }

            break;
        case 3:
            if (button != 0) {
                ExeScript("ERRMSGOFF0");
                MenuCommonInfo->SetVibeR(6, 4);
                MenuSePlay(5);
                mode = 0;
                step = 0;
                make_cursor = 0;
                cursor_snap = 1;
            }

            break;
        default:
            mode = 0;
            step = 0;
            break;
    }

    return 1;
}

void CMenuInvent::CalcTex() {
    if (bg_form != NULL) {
        float *left_top = GetMenuMainFrameLeftTopPos(0);
        int    bg_pos[2] = {(int) left_top[0], (int) (left_top[1] - 480.0f)};
        bg_form->SetPos(bg_pos[0], bg_pos[1]);
    }
    blink_count++;
    blink_count %= 50;
    if (blink_count >= 180000) {
        blink_count = 0;
    }
    float wave = sinf(mgAngleLimit(3.1415927f * blink_count / 50.0f));
    float shade = 128.0f + 64.0f * wave;
    neta_color[0] = shade;
    neta_color[1] = shade;
    neta_color[2] = 128.0f;
    scoop_color[0] = scoop_color[1] = shade;
    CMenuPosDataForm *balloon = MenuPosData->GetFormInfo("\x90\x81\x8f\x6f\x82\xb5" "0");
    if (balloon != NULL) {
        float center[2];
        balloon->GetPutPosXY("o", center[0], center[1]);
        if (mode == MENU_ASK_MODE_CREATE && step > 0 && step < 3) {
            neta_circle_radius -= 0.44444445f;
            if (neta_circle_radius < 0.0f) {
                neta_circle_radius = 0.0f;
            }
        } else {
            neta_circle_radius = 40.0f;
        }
        float slot_angle = 0.0f;
        if (neta_select_num > 0) {
            slot_angle = 6.2831855f / neta_select_num;
        }
        neta_circle_angle += 3.1415927f / 60.0f;
        if (neta_circle_angle >= 3.1415927f) {
            neta_circle_angle -= 6.2831855f;
        }
        float clip[2] = {neta_board_form->y, neta_board_form->y + 6.0f + 270.0f};
        for (int i = 0; i < 3; i++) {
            CMenuPosDataForm *form = neta_form[i];
            if (form == NULL || form->draw_flag == 0) {
                continue;
            }
            form->rate_x = 6.0f;
            form->rate_y = 6.0f;
            form->rgba_bit = 8;
            int target[2];
            if (neta_select_state[i] == 1) {
                clip[0] = neta_board_form->y;
                float angle = neta_circle_angle + slot_angle * i;
                target[0] = (int) (center[0] + neta_circle_radius * cosf(angle));
                target[1] = (int) (center[1] + neta_circle_radius * sinf(angle));
                int now_pos[2];
                form->GetPutPosXY(NULL, now_pos[0], now_pos[1]);
                form->SetNextMovePos(target, 2);
                if (neta_circle_snap != 0) {
                    form->x = target[0];
                    form->y = target[1];
                }
                if (unk_622[i] != 0) {
                    neta_flash_angle += 3.1415927f / 40.0f;
                    if (neta_flash_angle > 3.1415927f) {
                        neta_flash_angle -= 6.2831855f;
                    }
                    sinf(neta_flash_angle);
                    form->rgba[0] = 0x20;
                    form->rgba[1] = 0x20;
                    form->rgba[2] = 0x20;
                    form->rgba[3] = 0x18;
                    for (int channel = 0; channel < 4; channel++) {
                        form->SetRGBACalcParam(channel, 0, 0x80);
                    }
                }
            } else if (neta_select_state[i] == 0) {
                clip[0] = neta_board_form->y + 6.0f + 54.0f;
                if (neta_select_type[i] == 0) {
                    GetNetaBoardCursorPosition(neta_select_index[i], target);
                    form->SetNextMovePos(target, 2);
                    if ((target[1] < clip[0] && form->y < clip[0]) ||
                        (target[1] > clip[1] && form->y > clip[0]) || target[0] < 0) {
                        form->SetRGBACalcParam(3, -0x1C, 0);
                    }
                } else if (neta_select_type[i] == 1) {
                    GetNetaMemoCursorPosition(neta_select_index[i], target);
                    target[0] += 200;
                    form->SetNextMovePos(target, 2);
                    form->SetRGBACalcParam(3, -0x10, 0);
                    if ((target[1] < clip[0] && form->y < clip[0]) ||
                        (target[1] > clip[1] && form->y > clip[0])) {
                        form->SetRGBACalcParam(3, -0x1C, 0);
                    }
                }
                if (form->CheckMoveEnd(target[0], target[1])) {
                    neta_select_state[i] = -1;
                    neta_select_index[i] = -1;
                    form->draw_flag = 0;
                }
            }
        }
        if (neta_circle_snap != 0) {
            neta_circle_snap = 0;
        }
    }
    if (neta_memo_form != NULL) {
        CalcMenu1(neta_memo_form->y + 76.0f + 2.0f - memo_top * 26, &memo_scroll, 4.0f, 0.0f, memo_scroll_reset);
        float bar_step = 0.0f;
        if (pic_name_info_num > 9) {
            bar_step = 216.0f / (pic_name_info_num - 9.0f);
        }
        CalcMenu1(neta_memo_form->y + 76.0f + 1.0f + bar_step * memo_top, &memo_bar, 4.0f, 0.0f, memo_scroll_reset);
        memo_scroll_reset = 0;
    }
    if (neta_board_form != NULL) {
        CalcMenu1(neta_board_form->y + 6.0f - photo_top * 0x36, &photo_scroll, 4.0f, 0.0f, photo_scroll_reset);
        CalcMenu1(112.0f + 11.733334f * photo_top, &photo_bar, 4.0f, 1.0f, photo_scroll_reset);
        photo_scroll_reset = 0;
        if (neta_board_bar[0] != NULL && neta_board_bar[1] != NULL && neta_board_bar[2] != NULL) {
            neta_board_bar[0]->y = photo_bar;
            neta_board_bar[1]->y = neta_board_bar[0]->y + 6.0f;
            neta_board_bar[1]->h = 23.2f;
            neta_board_bar[2]->y = neta_board_bar[1]->y + neta_board_bar[1]->h;
        }
        if (mode != MENU_ASK_MODE_PHOTO_NETA) {
            arrow_count++;
        }
        if (arrow_count >= 50) {
            arrow_count = 0;
        }
        if (neta_memo_arrow != NULL && neta_board_arrow != NULL) {
            neta_board_arrow->x = neta_memo_arrow->x;
            neta_board_arrow->y = neta_memo_arrow->y + 6.0f * sinf(3.1415927f / 25.0f * arrow_count);
        }
        neta_board_form->SetNumber("nownum", InventUserDataPtr->GetNowHavePictureNum());
    }
    if (album_big_form != NULL && album_big_form->draw_flag != 0) {
        int cursor[2];
        album_big_form->GetPutPosXY("cur0", cursor[0], cursor[1]);
        album_scroll_x = cursor[0] - 2;
        CalcMenu1(cursor[1] - 2 - album_top * 0x36, &album_scroll_y, 4.0f, 1.0f, album_scroll_reset);
        MENUFORMPARTS_TYPE *frame = album_big_form->GetPartInfo("b0");
        MENUFORMPARTS_TYPE *bar = album_big_form->GetPartInfo("c0");
        if (frame != NULL && bar != NULL) {
            bar[0].x = bar[1].x = bar[2].x = frame[0].x + 2.0f;
            float length = bar[0].h + bar[1].h + bar[2].h;
            float scroll_step = (frame[1].h + 4.0f - length) / 20.0f;
            float scroll_target = frame[0].y + 4.0f + scroll_step * album_top;
            float bar_y = bar[0].y;
            CalcMenu1(scroll_target, &bar_y, 4.0f, 0.0f, album_scroll_reset);
            length = bar[0].h + bar[1].h + bar[2].h;
            float mid_scale = (6.0f + (length - bar[0].h - bar[2].h)) / 40.0f;
            bar[0].y = bar_y;
            bar[1].y = bar[0].y + bar[0].h;
            bar[1].h = mid_scale;
            bar[2].y = bar[1].y + bar[1].h;
        }
        album_scroll_reset = 0;
    }
    CalcMakeBrd(4);
    CMenuPosDataForm *title = card_list_title_form;
    if (title != NULL && title->draw_flag != 0) {
        int reset = 0;
        if (card_scroll_reset != 0) {
            card_scroll_reset = 0;
            reset = 1;
        }
        CMenuPosDataForm *clip = MenuPosData->GetFormInfo("\x94\xad\x96\xbe\x83\x4a\x81\x5b\x83\x68\x83\x4e\x83\x8a\x83\x62\x83\x76" "1");
        clip->x = title->x;
        int card_pos[2];
        title->GetPutPosXY("basecard", card_pos[0], card_pos[1]);
        int bar_size[2];
        title->GetPutPosXY("barlong", bar_size[0], bar_size[1]);
        card_list_form->x = title->x + 10.0f;
        CalcMenu1(card_pos[1] - card_top * 46, &card_list_form->y, 4.0f, 2.0f, reset);
        MENUFORMPARTS_TYPE *base_bar = title->GetPartInfo("basebar");
        MENUFORMPARTS_TYPE *bar_top = title->GetPartInfo("bar0");
        MENUFORMPARTS_TYPE *bar_mid = title->GetPartInfo("bar1");
        MENUFORMPARTS_TYPE *bar_end = title->GetPartInfo("bar2");
        int                 card_max = EnableSelectMaxCardList();
        float               knob = bar_size[1] * (5.0f / card_max);
        float               hidden = card_max - 5;
        float               bar_step = 0.0f;
        if (1.0f <= hidden) {
            bar_step = (bar_size[1] - knob) / hidden;
        }
        bar_mid->h = knob - (bar_top->h + bar_end->h);
        if (bar_mid->h < 0.0f) {
            bar_mid->h = 0.0f;
        }
        CalcMenu1(base_bar->y + bar_step * card_top, &bar_top->y, 4.0f, 0.0f, reset);
        bar_mid->y = bar_top->y + bar_top->h;
        bar_end->y = bar_mid->y + bar_mid->h;
    }
    if (recbrd_form != NULL && recbrd_form->draw_flag != 0 && recbrd_form->rgba[3] > 0 && MenuDCMsg[7] != NULL) {
        for (int i = 0; i < 10; i++) {
            char name[0x20];
            sprintf(name, "n%d", i);
            int line_pos[2];
            recbrd_form->GetPutPosXY(name, line_pos[0], line_pos[1]);
            line_pos[0] += rec_board_offset_xtbl[i];
            MenuDCMsg[7]->SetMovePosGyou(i, line_pos[0], line_pos[1]);
        }
    }
    CActionChara *chara = NULL;
    if (poly_chr_form[0] != NULL && poly_chr_form[0]->draw_flag != 0 && poly_chr_form[0]->chara != NULL) {
        chara = poly_chr_form[0]->chara;
    }
    switch (key_arg_no) {
        case INVENT_MODE_THINK:
        case INVENT_MODE_THINK_ALBUM_BUTTON:
            if (chara != NULL) {
                float pos[4];
                float move[4];
                float scale[4];
                chara->GetPosition(pos);
                float *target = chara_pos;
                switch (mode) {
                    case MENU_ASK_MODE_CREATE:
                        if (step > 0 && step < 4) {
                            target = chara_make_pos;
                        }
                        break;
                }
                sceVu0SubVector(move, target, pos);
                sceVu0ScaleVectorXYZ(move, move, 0.25f);
                sceVu0AddVector(pos, pos, move);
                chara->SetPosition(pos);
                pos[1] += 34.0f;
                mgCFrame *frame = NULL;
                if (create_effect != NULL) {
                    frame = create_effect->GetFrame();
                }
                if (frame != NULL) {
                    if (mode == MENU_ASK_MODE_CREATE && step == 3) {
                        if (create_step != 0) {
                            pos[0] += 3.0f;
                            frame->GetScale(scale);
                            pos[0] += effect_sway * sinf(effect_sway_angle);
                            float bob = sinf(effect_bob_angle);
                            pos[1] += effect_bob * bob;
                            scale[1] = 0.6f + 0.4f * bob;
                            frame->SetScale(scale);
                            frame->SetPosition(pos);
                            effect_sway_angle += 3.1415927f / 46.0f;
                            if (effect_sway_angle >= 3.1415927f) {
                                effect_sway_angle -= 6.2831855f;
                                effect_sway = 1.0f + 2.0f * mgRnd();
                            }
                            if (CalcMenuAdd(&effect_bob_angle, 3.1415927f / 22.0f, 3.1415927f)) {
                                effect_bob_angle = 0.0f;
                                effect_bob_count++;
                                effect_bob -= 0.6f + 2.0f * mgRnd() / 10.0f;
                                if (effect_bob <= 3.3f) {
                                    effect_bob = 5.0f;
                                    effect_bob_count = 0;
                                }
                            }
                        } else {
                            pos[0] -= 4.0f;
                            pos[1] -= 3.0f;
                            pos[2] += 30.0f;
                            frame->SetPosition(pos);
                            float size = 0.6f + 0.2f * sinf(effect_bob_angle);
                            frame->SetScale(size, size, size);
                            effect_bob_angle += 3.1415927f / 36.0f;
                            if (effect_bob_angle >= 3.1415927f) {
                                effect_bob_angle -= 6.2831855f;
                            }
                        }
                    } else {
                        frame->SetPosition(pos);
                        effect_bob = 5.0f;
                        effect_bob_angle = 0.0f;
                        effect_bob_count = 0;
                    }
                }
            }
            break;
    }
    GradationStep();
    if (kakudai_pic_form != NULL && kakudai_pic != NULL) {
        if (mode == MENU_ASK_MODE_EXTEND) {
            if (ask_para.ask_mode == INVENT_ASK_ZOOM) {
                CalcMenuAdd(&kakudai_pic->picture_scale, 0.025f, 1.3f);
            } else if (CalcMenuAdd(&kakudai_pic->picture_scale, -0.025f, 0.7f)) {
                kakudai_pic_form->draw_flag = 0;
            }
        } else {
            kakudai_pic->picture_scale = 0.7f;
        }
    }
    NowGiftBoxPtr = SearchNowPosItemExist();
    if (GiftBoxViewForm != NULL) {
        int gift_pos[2] = {0, 0};
        if (key_arg_no == INVENT_MODE_ITEM_LIST) {
            MenuPosData->GetPosMenuItemOnItemBrd(gift_pos, item_cursor, 0);
        }
        CMenuPosDataForm *gift_form = GiftBoxViewForm;
        gift_form->x = gift_pos[0];
        gift_form->y = gift_pos[1];
        if (mode == MENU_ASK_MODE_CLOSE) {
            NowGiftBoxPtr = NULL;
        }
    }
    if (itembrd_form != NULL && itembrd_form->draw_flag != 0) {
        Func_MenuItemBrdPosStep(item_top);
        Func_MenuItemBrdPrepare(itembrd_form->GetPartInfo("icon"), MenuUserParam.used_data, NULL, 1);
    }
    if (mode == MENU_ASK_MODE_MAKE && step == 1) {
        int effect_pos[2];
        MenuPosData->GetPosMenuItemBrdForEffect(effect_pos, make_space_no, 0);
        MenuEffect[0]->base_info[0] = effect_pos[0];
        MenuEffect[0]->base_info[1] = effect_pos[1];
        MenuEffect[1]->base_info[0] = effect_pos[0] + 2;
        MenuEffect[1]->base_info[1] = effect_pos[1] + 1;
    }
    MenuEffect[0]->Step();
    MenuEffect[1]->Step();
}

void CMenuInvent::BootExtendCommand() {
    menu_invent_command_info_ptr = &modecmdtbl_3636[key_arg_no];

    if (menu_invent_command_info_ptr->enable == 0) {
        MenuSePlay(5);
        return;
    }

    menu_invent_command_info_pict_info = GetNowSelectedPictInfo();

    if (menu_invent_command_info_pict_info == NULL || menu_invent_command_info_pict_info->used == 0) {
        MenuSePlay(5);
        return;
    }

    menu_invent_command_info_move_album_Space_info = NULL;
    MenuSePlay(19);
    MENU_ASKMODE_PARA ask;
    ask.ask_mode = 0;
    ask.mes_no = 6;
    ask.form = MenuMesForm[ask.mes_no];
    int count = 0;

    for (int i = 0; i < menu_invent_command_info_ptr->cmd_num; i++) {
        int enable = 1;

        if (menu_invent_command_info_ptr->cmd[i] == INVENT_CMD_TO_ALBUM && album_enable == 0) {
            continue;
        }

        ask.cmd_shade[count] = MES_SHADE_AUTO;

        if (menu_invent_command_info_ptr->cmd[i] == INVENT_CMD_SET_BOARD && neta_select_num >= 3) {
            enable = 0;
        } else if (menu_invent_command_info_ptr->cmd[i] == INVENT_CMD_TO_ALBUM) {
            for (int slot = 0; slot < 50; slot++) {
                USER_PICTURE_INFO *album = InventAlbumPtr->GetAlbumPhotoInfo(slot);

                if (album != NULL && album->used == 0) {
                    menu_invent_command_info_move_album_Space_info = album;
                    menu_invent_command_info_move_album_Space_pos = slot;
                    break;
                }
            }

            if (menu_invent_command_info_move_album_Space_info == NULL) {
                enable = 0;
            }
        } else if (menu_invent_command_info_ptr->cmd[i] == INVENT_CMD_FROM_ALBUM) {
            menu_invent_command_info_move_album_Space_info = InventUserDataPtr->IsPhotoSpace(NULL);

            if (menu_invent_command_info_move_album_Space_info == NULL) {
                enable = 0;
            }
        } else if (menu_invent_command_info_ptr->cmd[i] == INVENT_CMD_DELETE_ALL ||
                   menu_invent_command_info_ptr->cmd[i] == INVENT_CMD_DELETE_UNUSED) {
            if (0 < neta_select_num) {
                enable = 0;
            }
        }

        if (enable == 0) {
            ask.cmd_color[count] = 0x80202020;
            ask.cmd_shade[count] = MES_SHADE_FAINT;
        }

        ask.cmd_msg[count] = menu_invent_command_info_ptr->cmd[i];
        count++;
    }

    ask.cmd_num = count;
    SetAskParam(&ask);
    CDC2Mes *message = MenuDCMsg[ask.mes_no];
    message->MsgPreset(6);
    message->MakeMsg(menu_invent_command_info_ptr->cmd_num);
    message->SetMsgItemNo(ask.cmd_msg, ask.cmd_num);
    message->select_top = 0;
    message->SetMsgCursor(0);

    for (int line = 0; line < count; line++) {
        int shade = ask.cmd_shade[line];

        if (line >= 0 && line < MES_LINE_MAX) {
            message->line_shade[line] = shade;
        }
    }

    MenuMesForm[ask.mes_no]->draw_flag = 1;

    if (MenuCommonInfo->cursor_form != NULL) {
        MenuCommonInfo->cursor_form->draw_flag = 0;
    }

    mode = 12;
    step = 0;

    if (menu_invent_command_info_pict_info != NULL) {
        menu_invent_command_info_pict_info->is_new = 0;
    }
}

int CMenuInvent::IsAskExtend(int keys, int button) {
    CMenuPosDataForm *command_form;
    CMenuPosDataForm *yesno_form = MenuMesForm[5];
    CDC2Mes          *yesno_message = MenuDCMsg[5];
    CDC2Mes          *command_message;
    command_form = MenuMesForm[ask_para.mes_no];
    command_message = MenuDCMsg[ask_para.mes_no];
    MENU_ASKMODE_PARA *ask = &ask_para;
    char               text[0x20];
    int                unneeded[50];
    int                pos[2];
    ItemNameList2      names;
    ItemNameList2      delete_names;
    int                num;
    int                all_num;

    switch (ask_para.ask_mode) {
        case INVENT_ASK_COMMAND: {
            int line = command_message->CommandMsgCursor();

            if (button & 1) {
                if (command_message->line_shade[line] == MES_SHADE_FAINT) {
                    MenuSePlay(5);
                    break;
                }

                int command = command_message->item_mes[line] - INVENT_CMD_ZOOM;
                ask->ask_mode = convtbl_3726[command];
                command_form->draw_flag = 0;
                int se = 1;

                switch (ask->ask_mode) {
                    case INVENT_ASK_SET_BOARD: {
                        int se_end = 5;

                        if (SetNetaCircle(0, photo_cursor) > 0) {
                            se_end = 12;
                        }

                        IsAskEnd(se_end, command_form);
                        yesno_form->draw_flag = 0;
                        se = -1;
                        break;
                    }
                    case INVENT_ASK_ZOOM: {
                        int picture = 0;

                        switch (key_arg_no) {
                            case INVENT_MODE_THINK:
                            case INVENT_MODE_THINK_WITH_ALBUM:
                            case INVENT_MODE_PHOTO_VIEW:
                                GetNetaBoardCursorPosition(photo_cursor, pos);
                                picture = photo_cursor;
                                break;
                            case INVENT_MODE_ALBUM_VIEW:
                                sprintf(text, "cur%d", album_cursor - album_top * 2);
                                album_big_form->GetPutPosXY(text, pos[0], pos[1]);
                                pos[0]--;
                                pos[1]--;
                                picture = album_cursor + 50;
                                break;
                        }

                        kakudai_pic->etc_info[0] = picture;
                        CMenuPosDataForm *zoom_form = kakudai_pic_form;
                        zoom_form->x = pos[0];
                        zoom_form->y = pos[1];
                        kakudai_pic_form->draw_flag = 1;
                        break;
                    }
                    case INVENT_ASK_DELETE: {
                        ExeScript("\x8e\xca\x90\x5e\x8f\xc1\x82\xb5\x82\xdc\x82\xb7\x82\xa9\x81\x48");
                        names = at_3739;
                        names.name[0] = GetPhotoName(menu_invent_command_info_pict_info);
                        yesno_message->SetMsgItemNo(names.name, se);
                        break;
                    }
                    case INVENT_ASK_DELETE_UNUSED:
                        if (key_arg_no == INVENT_MODE_ALBUM_VIEW) {
                            ExeScript("\x8e\xca\x90\x5e\x82\xcc\x88\xea\x8a\x87\x8f\xc1\x8b\x8e\x81\x48" "Album");
                        } else {
                            ExeScript("\x8e\xca\x90\x5e\x82\xcc\x88\xea\x8a\x87\x8f\xc1\x8b\x8e\x81\x48\x83\x6c\x83\x5e");
                        }

                        break;
                    case INVENT_ASK_DELETE_ALL:
                        if (key_arg_no == INVENT_MODE_ALBUM_VIEW) {
                            ExeScript("\x8e\xca\x90\x5e\x91\x53\x8f\xc1\x8b\x8e\x81\x48" "Album");
                        } else {
                            ExeScript("\x8e\xca\x90\x5e\x91\x53\x8f\xc1\x8b\x8e\x81\x48\x83\x6c\x83\x5e");
                        }

                        break;
                    case INVENT_ASK_TO_ALBUM: {
                        ExeScript("\x83\x41\x83\x8b\x83\x6f\x83\x80\x88\xda\x82\xb7\x81\x48");
                        names.name[0] = GetPhotoName(menu_invent_command_info_pict_info);
                        yesno_message->SetMsgItemNo(names.name, se);
                        break;
                    }
                    case INVENT_ASK_FROM_ALBUM: {
                        ExeScript("\x83\x6c\x83\x5e\x82\xc9\x88\xda\x82\xb7\x81\x48");
                        names.name[0] = GetPhotoName(menu_invent_command_info_pict_info);
                        yesno_message->SetMsgItemNo(names.name, se);
                        break;
                    }
                }

                MenuSePlay(se);
            } else if (button & 2) {
                command_form->draw_flag = 0;
                IsAskEnd(5, command_form);

                if (kakudai_pic_form != NULL) {
                    kakudai_pic_form->draw_flag = 0;
                }
            }

            break;
        }
        case INVENT_ASK_ZOOM:
            if (button != 0) {
                ask->ask_mode = INVENT_ASK_COMMAND;
                MenuSePlay(5);
                command_form->draw_flag = 1;
            }

            break;
        case INVENT_ASK_DELETE:
            if (step == 0) {
                int answer = yesno_message->YesNoCursor();

                switch (button) {
                    case 1:
                        if (answer == 0) {
                            ExeScript("\x8e\xca\x90\x5e\x8f\xc1\x82\xb5\x82\xdc\x82\xb5\x82\xbd");
                            delete_names = at_3765;
                            delete_names.name[0] = GetPhotoName(menu_invent_command_info_pict_info);
                            yesno_message->SetMsgItemNo(delete_names.name, 1);
                            MenuSePlay(13);

                            switch (key_arg_no) {
                                case INVENT_MODE_THINK:
                                case INVENT_MODE_THINK_WITH_ALBUM:
                                case INVENT_MODE_PHOTO_VIEW:
                                    InventUserDataPtr->DeletePhotoData(photo_cursor);
                                    break;
                                case INVENT_MODE_ALBUM_VIEW:
                                    InventAlbumPtr->DeletePhotoData(album_cursor);
                                    album_flag[album_cursor] = -1;
                                    break;
                            }

                            step = 1;
                            break;
                        }
                    case 2:
                        IsAskEnd(5, command_form);
                        yesno_form->draw_flag = 0;
                        break;
                }
            } else if (step == 1 && button != 0) {
                IsAskEnd(1, command_form);
                yesno_form->draw_flag = 0;
            }

            break;
        case INVENT_ASK_TO_ALBUM:
        case INVENT_ASK_FROM_ALBUM:
            if (step == 0) {
                int answer = yesno_message->YesNoCursor();

                switch (button) {
                    case 1:
                        if (answer == 0) {
                            MenuSePlay(12);
                            yesno_form->draw_flag = 0;
                            Copy_USER_PICTURE_INFO(menu_invent_command_info_pict_info,
                                                   menu_invent_command_info_move_album_Space_info);
                            memcpy(menu_invent_command_info_move_album_Space_info->image,
                                   menu_invent_command_info_pict_info->image, 0x2000);
                            menu_invent_command_info_move_album_Space_info->used = 1;
                            Init_USER_PICTURE_INFO(menu_invent_command_info_pict_info);

                            if (ask->ask_mode == INVENT_ASK_TO_ALBUM) {
                                AttachPictTex(tex_block[4], album_tex, InventAlbumPtr->GetAlbumPhotoInfo(0), 50);
                                album_flag[menu_invent_command_info_move_album_Space_pos] = 1;
                            } else {
                                AttachPictTex(tex_block[3], photo_tex, InventUserDataPtr->GetPhotoInfo(0), 30);
                                album_flag[album_cursor] = -1;
                            }

                            ask->ask_mode = INVENT_ASK_COMMAND;
                            step = 0;
                            mode = 0;
                            IsAskEnd(5, command_form);
                            yesno_form->draw_flag = 0;
                            break;
                        }
                    case 2:
                        IsAskEnd(5, command_form);
                        yesno_form->draw_flag = 0;
                        break;
                }
            }

            break;
        case INVENT_ASK_DELETE_UNUSED:
            if (step == 0) {
                int answer = yesno_message->YesNoCursor();

                switch (button) {
                    case 1:
                        if (answer == 0) {
                            num = 0;
                            USER_PICTURE_INFO *photos = GetPhotoInfoFromMode(&num);
                            int                count = CheckPhotoDataNoNeed(photos, num, unneeded);

                            for (int i = 0; i < count; i++) {
                                Init_USER_PICTURE_INFO(&photos[unneeded[i]]);
                            }

                            MenuSePlay(13);

                            if (key_arg_no == INVENT_MODE_ALBUM_VIEW) {
                                ExeScript("\x8e\xca\x90\x5e\x82\xcc\x88\xea\x8a\x87\x8f\xc1\x8b\x8e\x83\x41\x83\x8b\x83\x6f\x83\x80");
                                InitPhotoNetaBoardToAlbum(1);
                            } else {
                                ExeScript("\x8e\xca\x90\x5e\x82\xcc\x88\xea\x8a\x87\x8f\xc1\x8b\x8e");
                            }

                            step = 1;
                            break;
                        }
                    case 2:
                        IsAskEnd(5, command_form);
                        yesno_form->draw_flag = 0;
                        break;
                }
            } else if (button != 0) {
                IsAskEnd(1, yesno_form);
                yesno_form->draw_flag = 0;
            }

            break;
        case INVENT_ASK_DELETE_ALL:
            switch (step) {
                case 0: {
                    int answer = yesno_message->YesNoCursor();

                    switch (button) {
                        case 1:
                            if (answer == 0) {
                                all_num = 0;
                                USER_PICTURE_INFO *photo = GetPhotoInfoFromMode(&all_num);

                                for (int i = 0; i < all_num; i++, photo++) {
                                    Init_USER_PICTURE_INFO(photo);
                                }

                                step = 1;
                                MenuSePlay(13);

                                if (key_arg_no == INVENT_MODE_ALBUM_VIEW) {
                                    ExeScript("\x8e\xca\x90\x5e\x91\x53\x8f\xc1\x8b\x8e" "Album");
                                    InitPhotoNetaBoardToAlbum(0);
                                } else {
                                    ExeScript("\x8e\xca\x90\x5e\x91\x53\x8f\xc1\x8b\x8e\x83\x6c\x83\x5e");
                                }

                                break;
                            }
                        case 2:
                            IsAskEnd(5, command_form);
                            yesno_form->draw_flag = 0;
                            break;
                    }

                    break;
                }
                case 1:
                    if (button != 0) {
                        IsAskEnd(1, command_form);
                        yesno_form->draw_flag = 0;
                    }

                    break;
            }

            break;
    }

    return 0;
}

void CMenuInvent::PhotoNetaEnter(int index, int button) {
    CDC2Mes *message = MenuDCMsg[4];
    int      cancel = 0;

    switch (step) {
        case 0: {
            int answer = message->YesNoCursor();

            switch (button) {
                case 1:
                case 4:
                    if (answer == 0) {
                        neta_effect_time = 0;
                        InventInNetaEffectFlag = 1;
                        ExeScript("\x83\x6c\x83\x5e\x93\x6f\x98\x5e\x8a\x4a\x8e\x6e");
                        MenuSePlay(0x20);
                        MenuCharaLoadStack.stack_used = 0;
                        MenuCharaLoadStack.lock = 0;
                        InventInNetaEffectNum4 = InventInNetaEffectNum * 80;
                        int          count = InventInNetaEffectNum4;
                        unsigned int size = count * sizeof(CStarDust);
                        unsigned int blocks = (size & 0xF) ? (size >> 4) + 1 : size >> 4;
                        InventInNetaEffect = new (MenuCharaLoadStack.Alloc(blocks + 2)) CStarDust[count];
                        step = 1;
                        break;
                    }
                case 2:
                    cancel = 1;
                    break;
            }

            break;
        }
        case 1:
            if (neta_effect_time == 0) {
                if (CheckRunStarDust(InventInNetaEffect, InventInNetaEffectNum4) == 0) {
                    neta_effect_time++;
                }
            } else {
                neta_effect_time++;
            }

            if (neta_effect_time > 50) {
                CheckPhotoFlag();
                InventUserDataPtr->PhotoCheckEnd();

                if (photo_only == 1 && unk_112 == 0) {
                    UpdataRecordBoard();
                }

                MenuSePlay(0x21);
                InventInNetaEffectFlag = 0;
                step = 2;
                ExeScript("\x83\x6c\x83\x5e\x93\x6f\x98\x5e");
            }

            break;
        case 2:
            if (button != 0) {
                ExeScript("\x93\x6f\x98\x5e\x8e\xca\x90\x5e\x8f\xc1\x82\xb7\x81\x48");
                step = 3;
            }

            break;
        case 3: {
            int answer = message->YesNoCursor();

            switch (button) {
                case 1:
                    if (answer == 0) {
                        ExeScript("\x93\x6f\x98\x5e\x8e\xca\x90\x5e\x8f\xc1\x82\xb7");

                        for (int i = 0; i < 30; i++) {
                            if (new_neta_photo[i] != 0) {
                                InventUserDataPtr->DeletePhotoData(i);
                            }
                        }

                        step = 4;
                        break;
                    }
                case 2:
                    cancel = 1;
                    break;
            }

            break;
        }
        case 4:
            if (button != 0) {
                cancel = 1;
            }

            break;
        case 10:
            if (button != 0) {
                cancel = 1;
            }

            break;
    }

    if (cancel) {
        mode = 0;
        step = 0;
        ExeScript("\x83\x6c\x83\x5e\x93\x6f\x98\x5e\x8f\x49\x97\xb9");
        MenuSePlay(5);
    }
}

CStarDust::CStarDust() {
    this->active = 0;
}
#ifdef NONMATCHING

void CMenuInvent::IsAccessAlbum() {
    CDC2Mes *message = MenuDCMsg[4];
    if (message == NULL) {
        return;
    }
    int            keys = MenuCommonInfo->CheckSelectKey();
    int            button = MenuCommonInfo->CheckPushButton();
    MC_ERROR_INFO *error = NULL;
    MC_CARD_INFO  *card = NULL;
    int            done = 0;
    if (MCManagerPtr != NULL) {
        MCManagerPtr->GetFuncNo();
        done = MCManagerPtr->Step();
        CMemoryCardManager *manager = MCManagerPtr;
        int                 port = manager->port;
        if (port == 0 || port == 1) {
            card = &manager->card[port];
        }
        error = &manager->error;
    }
    int back_to_photo = 0;
    int finish = 0;
    int access = -2;
    int cancel = 0;
    int loaded = 0;
    int check_space = 0;
    int card_removed = 0;
    int no_card = 0;
    int card_full = 0;
    int card_error = 0;
    int read_error = 0;
    if (init_3950 == 0) {
        ActiveSlot_3949 = 0;
        init_3950 = 1;
    }
    switch (step) {
        case 0: {
            int move = 0;
            if (keys & MENU_SELECT_KEY_UP) {
                move = -1;
            }
            if (keys & MENU_SELECT_KEY_DOWN) {
                move++;
            }
            if (message->AddMsgCursor(move, 1, 2, 1) != 0) {
                MenuSePlay(SYSTEM_SE_CURSOR);
            }
            switch (button) {
                case 1:
                    ActiveSlot_3949 = message->GetMsgCursor() - 1;
                    printf(at_4354, ActiveSlot_3949);
                    chara_load_step = -1;
                    poly_chr_form[0]->SetActionCharaPtr(NULL, -1, -1);
                    ExeScript(at_4355);
                    while (CancelNetaCircle(0) >= 0) {
                    }
                    InitPhotoNetaBoardToAlbum(0);
                    MenuInventCharaStack.stack_used = 0;
                    MenuInventCharaStack.lock = 0;
                    MenuInventMCStack.stack_used = 0;
                    MenuInventMCStack.lock = 0;
                    step = 1;
                    album_scroll_reset = 1;
                    break;
                case 2:
                    unk_112 = 0;
                    cancel = 1;
                    break;
            }
            break;
        }
        case 1:
            MenuInventMCStack.stack_used = 0;
            MenuInventMCStack.lock = 0;
            MenuInventMCStack.Align64();
            InventAlbumPtr = new ((u_long128 *) MenuInventMCStack.Alloc(0x64CD)) CDC2AlbumData;
            MCManagerPtr = new ((u_long128 *) MenuInventMCStack.Alloc(0x112)) CMemoryCardManager;
            MCManagerPtr->Initialize(NULL);
            MCManagerPtr->InitForMC();
            MCManagerPtr->SetBuff_Album(InventAlbumPtr->photo_work[0]);
            MCManagerPtr->SetIconData(icon_data, 1);
            MCManagerPtr->port = ActiveSlot_3949;
            MCManagerPtr->SetFuncNo(0);
            step = 2;
            break;
        case 2:
            if (done != 0) {
                if (McCheckMCPs2(card) == 0) {
                    no_card = 1;
                } else if (card->formatted == 0) {
                    if (album_save_mode == 1) {
                        step = 500;
                        ExeScript(at_4356);
                    } else {
                        loaded = 2;
                    }
                } else if (album_save_mode == 0) {
                    step = 3;
                    MCManagerPtr->SetFuncNo(18);
                } else {
                    step = 200;
                    ExeScript(at_4357);
                }
            }
            break;
        case 3:
            if (done != 0) {
                if (McCheckMCPs2(card) == 0) {
                    loaded = 2;
                } else if (MCManagerPtr->file_exists != 0) {
                    if (error->code != 0) {
                        read_error = 1;
                    } else {
                        step = 5;
                        MCManagerPtr->SetFuncNo(17);
                        InitMenuDl(GetMenuDlTexture(), MCManagerPtr->GetSaveDataSize(2));
                        download_base = 0;
                        ExeScript(at_4358);
                        if (MenuDCMsg[4] != NULL) {
                            MenuDCMsg[4]->SetMsgVolumeNoOne(ActiveSlot_3949 + 1);
                        }
                    }
                } else {
                    loaded = 2;
                }
            }
            break;
        case 5:
            StepMenuDl2(download_base + MCManagerPtr->total_transferred);
            if (done != 0) {
                InitMenuDl(NULL, 0);
                if (McCheckMCPs2(card) == 0) {
                    read_error = 1;
                } else if (error->code == 3) {
                    read_error = 1;
                } else {
                    loaded = 1;
                }
            }
            break;
        case 6:
            if (button != 0) {
                back_to_photo = 1;
                cursor_snap = 1;
                MenuSePlay(SYSTEM_SE_DECIDE);
            }
            break;
        case 231:
            if (done != 0) {
                if (McCheckMCPs2(card) == 0) {
                    card_removed = 1;
                } else {
                    access = 0;
                    step = 232;
                }
            }
            break;
        case 232:
            StepMenuDl2(MCManagerPtr->total_transferred);
            if (done != 0) {
                if (McCheckMCPs2(card) == 0) {
                    card_removed = 1;
                } else {
                    access = 1;
                    step = 205;
                }
            }
            break;
        case 110:
            if (button != 0) {
                loaded = -1;
            }
            break;
        case 100:
            if (button != 0) {
                MenuSePlay(SYSTEM_SE_DECIDE);
                loaded = 2;
            }
            break;
        case 201: {
            int move = 0;
            if (keys & MENU_SELECT_KEY_UP) {
                move = -1;
            }
            if (keys & MENU_SELECT_KEY_DOWN) {
                move++;
            }
            if (message->AddMsgCursor(move, 2, 3, 1) != 0) {
                MenuSePlay(SYSTEM_SE_CURSOR);
            }
            switch (button) {
                case 1:
                    ActiveSlot_3949 = message->GetMsgCursor() - 2;
                    if (ActiveSlot_3949 < 0) {
                        ActiveSlot_3949 = 0;
                    }
                    if (ActiveSlot_3949 >= 2) {
                        ActiveSlot_3949 = 1;
                    }
                    step = 2;
                    ExeScript(at_4359);
                    MCManagerPtr->port = ActiveSlot_3949;
                    MCManagerPtr->SetFuncNo(0);
                    break;
                case 2:
                    step = 220;
                    ExeScript(at_4360);
                    break;
            }
            break;
        }
        case 200: {
            int answer = message->YesNoCursor();
            if (McCheckMCPs2(card) == 0) {
                no_card = 1;
            } else {
                switch (button) {
                    case 1:
                        if (answer == 0) {
                            step = 202;
                            MCManagerPtr->port = ActiveSlot_3949;
                            MCManagerPtr->SetFuncNo(0);
                            ExeScript(at_4361);
                            break;
                        }
                    case 2:
                        step = 220;
                        ExeScript(at_4360);
                        break;
                }
            }
            break;
        }
        case 202:
            if (done != 0) {
                if (McCheckMCPs2(card) != 0) {
                    if (card->formatted == 0) {
                        step = 500;
                        ExeScript(at_4356);
                    } else {
                        step = 203;
                        MCManagerPtr->SetFuncNo(18);
                    }
                } else {
                    card_removed = 1;
                }
            }
            break;
        case 203:
            if (done != 0) {
                if (McCheckMCPs2(card) == 0) {
                    card_removed = 1;
                } else if (MCManagerPtr->file_exists != 0) {
                    access = 2;
                    step = 205;
                } else {
                    check_space = 1;
                }
            }
            break;
        case 205:
            StepMenuDl2(download_base + MCManagerPtr->total_transferred);
            if (done != 0) {
                if (McCheckMCPs2(card) == 0) {
                    card_removed = 1;
                } else if (card->formatted != 0) {
                    access = 3;
                    AttachPictTex(tex_block[4], album_tex, InventAlbumPtr->GetAlbumPhotoInfo(0), 50);
                    step = 206;
                }
            }
            break;
        case 206:
            if (button != 0) {
                MenuSePlay(SYSTEM_SE_DECIDE);
                finish = 1;
            }
            break;
        case 220: {
            int answer = message->YesNoCursor2(0);
            if (answer == 1) {
                MenuSePlay(SYSTEM_SE_DECIDE);
                if (CheckRecoverPhotoNum() > 0) {
                    ExeScript(at_4362);
                    step = 240;
                } else {
                    finish = 1;
                }
            }
            if (answer == 2) {
                cancel = 1;
            }
            break;
        }
        case 230: {
            int answer = message->YesNoCursor();
            if (McCheckMCPs2(card) == 0) {
                no_card = 1;
            } else {
                switch (button) {
                    case 1:
                        if (answer == 0) {
                            access = -1;
                            step = 231;
                            break;
                        }
                    case 2:
                        cancel = 1;
                        break;
                }
            }
            break;
        }
        case 240: {
            int answer = message->YesNoCursor2(0);
            if (answer == 1) {
                int space = 0;
                for (int i = 0; i < 50; i++) {
                    USER_PICTURE_INFO *photo = InventUserDataPtr->GetPhotoInfo(i);
                    if (photo != NULL && *(s8 *) &photo->used == 0) {
                        space++;
                    }
                }
                int recover = 0;
                for (int i = 0; i < 50; i++) {
                    if (album_flag[i] > 0) {
                        recover++;
                    }
                }
                if (space < recover) {
                    step = 241;
                    ExeScript(at_4363);
                    MenuSePlay(5);
                } else {
                    for (int i = 0; i < 50; i++) {
                        if (album_flag[i] > 0) {
                            album_flag[i] = -1;
                            USER_PICTURE_INFO *photo = InventUserDataPtr->IsPhotoSpace(NULL);
                            USER_PICTURE_INFO *album = InventAlbumPtr->GetAlbumPhotoInfo(i);
                            if (photo != NULL && album != NULL) {
                                Copy_USER_PICTURE_INFO(album, photo);
                                memcpy(photo->image, album->image, 0x2000);
                                photo->used = 1;
                                Init_USER_PICTURE_INFO(album);
                            }
                        }
                    }
                    AttachPictTex(tex_block[3], photo_tex, InventUserDataPtr->GetPhotoInfo(0), 30);
                    finish = 1;
                    MenuSePlay(12);
                }
            }
            if (answer == 2) {
                finish = 1;
                MenuSePlay(5);
            }
            break;
        }
        case 241:
            if (button != 0) {
                back_to_photo = 1;
            }
            break;
        case 250:
            if (button != 0) {
                cancel = 1;
            }
            break;
        case 300:
            if (button != 0) {
                step = 301;
                ExeScript(at_4360);
            }
            break;
        case 301: {
            int answer = message->YesNoCursor2(0);
            if (answer == 1) {
                MenuSePlay(SYSTEM_SE_DECIDE);
                if (CheckRecoverPhotoNum() > 0) {
                    ExeScript(at_4362);
                    step = 240;
                } else {
                    finish = 1;
                }
            }
            if (answer == 2) {
                cancel = 1;
                MenuSePlay(5);
            }
            break;
        }
        case 500:
            if (McCheckMCPs2(card) == 0) {
                no_card = 1;
            } else {
                int answer = message->YesNoCursor2(0);
                if (answer == 1) {
                    ExeScript(at_4364);
                    MCManagerPtr->SetFuncNo(0);
                    MenuDCMsg[4]->SetMsgVolumeNoOne(ActiveSlot_3949 + 1);
                    step = 501;
                }
                if (answer == 2) {
                    back_to_photo = 1;
                }
            }
            break;
        case 501:
            if (done != 0) {
                if (McCheckMCPs2(card) == 1) {
                    if (card->formatted == 1) {
                        ExeScript(at_4365);
                        MenuSePlay(31);
                        step = 503;
                    } else {
                        MCManagerPtr->SetFuncNo(10);
                        step = 502;
                    }
                } else {
                    no_card = 1;
                }
            }
            break;
        case 502:
            if (done != 0) {
                step = 503;
                if (McCheckMCPs2(card) == 1 && card->formatted == 1) {
                    ExeScript(at_4365);
                    access = -1;
                    step = 231;
                } else {
                    ExeScript(at_4366);
                }
            }
            break;
        case 503:
            if (button != 0) {
                back_to_photo = 1;
                check_space = 1;
            }
            break;
    }
    switch (access) {
        case -1:
            ExeScript(at_4367__2);
            MCManagerPtr->SetFuncNo(0);
            break;
        case 0:
            if (McCheckMCPs2(card) == 0) {
                card_removed = 1;
            } else {
                download_base = 0;
                MCManagerPtr->SetFuncNo(19);
                InitMenuDl(GetMenuDlTexture(), MCManagerPtr->GetSaveDataSize(4));
            }
            break;
        case 1:
            if (McCheckMCPs2(card) == 0) {
                card_removed = 1;
            } else if (card->formatted == 1) {
                MCManagerPtr->SetFuncNo(16);
                download_base = MCManagerPtr->total_transferred;
            } else if (card->formatted == 0) {
                step = 500;
                ExeScript(at_4356);
            } else if (error->code == 4) {
                card_full = 1;
            } else {
                card_error = 1;
            }
            break;
        case 2:
            if (McCheckMCPs2(card) == 0) {
                card_removed = 1;
            } else {
                download_base = 0;
                MCManagerPtr->SetFuncNo(16);
                InitMenuDl(GetMenuDlTexture(), MCManagerPtr->GetSaveDataSize(2));
                ExeScript(at_4368__2);
                if (MenuDCMsg[4] != NULL) {
                    MenuDCMsg[4]->SetMsgVolumeNoOne(ActiveSlot_3949 + 1);
                }
            }
            break;
        case 3:
            if (error->code == 0) {
                InitMenuDl(NULL, 0);
                ExeScript(at_4369);
                MenuSePlay(31);
            } else if (error->code == 4) {
                card_full = 1;
            } else {
                card_error = 1;
            }
            break;
    }
    if (check_space != 0) {
        if (card->type == 2 && card->present == 1) {
            if (card->formatted == 0) {
                step = 500;
                ExeScript(at_4356);
            } else if (card->free_size < MCManagerPtr->GetSaveDataSize(5) + 2) {
                card_full = 1;
            } else {
                if (album_save_mode == 1) {
                    step = 230;
                }
                ExeScript(at_4370);
            }
        } else {
            no_card = 1;
        }
    }
    if (no_card != 0) {
        InitMenuDl(NULL, 0);
        if (album_save_mode == 0) {
            step = 110;
        }
        if (album_save_mode == 1) {
            step = 300;
        }
        ExeScript(at_4371);
    }
    if (card_full != 0) {
        InitMenuDl(NULL, 0);
        if (album_save_mode == 0) {
            step = 100;
        }
        if (album_save_mode == 1) {
            step = 300;
        }
        ExeScript(at_4372);
        MenuDCMsg[4]->SetMsgVolumeNoOne(ActiveSlot_3949 + 1);
    }
    if (card_error == 1) {
        InitMenuDl(NULL, 0);
        ExeScript(at_4373);
        if (album_save_mode == 0) {
            step = 100;
        }
        if (album_save_mode == 1) {
            step = 300;
        }
    }
    if (read_error != 0) {
        ExeScript(at_4374);
        step = 110;
    }
    if (card_removed != 0) {
        InitMenuDl(NULL, 0);
        ExeScript(at_4373);
        step = 300;
    }
    if (loaded != 0) {
        InventAlbumPtr->RelateAlbumPicData();
        AttachPictTex(tex_block[4], album_tex, InventAlbumPtr->GetAlbumPhotoInfo(0), 50);
        if (loaded == 3) {
            ExeScript(at_4375);
            MenuDCMsg[6]->SetMsgVolumeNoOne(ActiveSlot_3949 + 1);
        }
        if (loaded == 2) {
            ExeScript(at_4376);
        }
        if (loaded == 1) {
            ExeScript(at_4377);
            MenuSePlay(31);
        }
        cursor_snap = 1;
        step = 6;
        if (loaded < 0) {
            step = 0;
            ExeScript("IS_MCACCESS");
            if (LanguageCode > 0 && LanguageCode < 6) {
                MenuDCMsg[4]->SetMsgCursor(1);
                MenuDCMsg[4]->select_top = 1;
            }
            ExeScript(at_4379);
            chara_load_step = 0;
            StartReadBG();
            MCManagerPtr->FinishForMC();
            MCManagerPtr = NULL;
            MenuCharaLoadStack.stack_used = 0;
            MenuCharaLoadStack.lock = 0;
            return;
        }
    }
    if (finish != 0) {
        MenuMesForm[4]->draw_flag = 0;
        int next_mode = 0;
        if (photo_only == 1) {
            next_mode = 6;
        }
        PrepareNextMode(next_mode);
        mode = 0;
        step = 0;
        chara_load_step = 0;
        unk_112 = 0;
        MCManagerPtr->FinishForMC();
        MCManagerPtr = NULL;
        MenuCharaLoadStack.stack_used = 0;
        MenuCharaLoadStack.lock = 0;
        StartReadBG();
        return;
    }
    if (back_to_photo != 0) {
        PrepareNextMode(5);
        mode = 0;
        step = 0;
        ExeScript(at_4380);
    }
    if (cancel != 0) {
        mode = 0;
        step = 0;
        ExeScript(at_4380);
    }
    if (dload_form != NULL) {
        int x;
        int y;
        dload_form->GetPutPosXY(NULL, x, y);
        y += 26;
        MenuDCMsg[6]->StepMsg();
        MenuDCMsg[6]->SetMovePosCenteringGyou(0, mgScreenWidth >> 1, y);
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/inventmn", IsAccessAlbum__11CMenuInventFv);
#endif
void CMenuInvent::GetNetaBoardCursorPosition(int slot, int *pos) {
    pos[0] = (int) photo_pos[slot][0];
    pos[1] = (int) photo_pos[slot][1];

    if (neta_board_form != NULL) {
        pos[0] = (int) ((float) pos[0] + neta_board_form->x);
    }

    pos[1] = (int) ((float) pos[1] + photo_scroll);
}

void CMenuInvent::GetNetaMemoCursorPosition(int slot, int *pos) {
    pos[0] = 0;

    if (neta_memo_form != NULL) {
        neta_memo_form->GetPutPosXY(NULL, pos[0], pos[1]);
    }

    pos[1] += slot * 0x1A + 0x4E;
}

/**
 *
 * Orders discovered invention ideas while keeping their names, identifiers and sort keys together.
 *
 */
static int neta_sort(int mode, int first, int last, int *keys) {
    int swapped = 0;
    int i;
    int j;

    for (i = first; i < last; i++) {
        for (j = i + 1; j < last; j++) {
            if ((mode == 0 && keys[j] < keys[i]) || (mode == 1 && keys[j] < keys[i])) {
                char *tmp_str = NetaMemoStr[i];
                NetaMemoStr[i] = NetaMemoStr[j];
                NetaMemoStr[j] = tmp_str;
                int tmp_key = keys[i];
                keys[i] = keys[j];
                keys[j] = tmp_key;
                short tmp_id = NetaMemoID[i];
                NetaMemoID[i] = NetaMemoID[j];
                NetaMemoID[j] = tmp_id;
                swapped = 1;
            }
        }
    }

    return swapped;
}

void CMenuInvent::UpdataNetaMemoStr() {
    int              sort_keys[0x184];
    CInventUserData *user_data;
    int              i;
    int              standard_count;
    PIC_NAME_INFO   *info;

    NetaMemoStrNum = 0;
    user_data = GetInventUserDataPtr();
    standard_count = 0;
    i = 0;

    while (i < pic_name_info_num && i < (0x200)) {
        info = &pic_name_info_top[i];

        if (info == NULL) {
            break;
        }

        if (0 <= user_data->CheckNetaFlag(info->neta_id)) {
            NetaMemoID[NetaMemoStrNum] = info->neta_id;
            NetaMemoStr[NetaMemoStrNum] = info->name;
            sort_keys[NetaMemoStrNum] = info->sort_key;

            if (info->neta_id < (0x3E8)) {
                standard_count += 1;
            }

            NetaMemoStrNum += 1;
        }

        i += 1;
    }

    do {
        i = 0;
        i |= neta_sort(memo_sort_mode, 0, standard_count, sort_keys);
        i |= neta_sort(memo_sort_mode, standard_count, NetaMemoStrNum, sort_keys);
    } while (i != 0);

    for (i = NetaMemoStrNum; i < (0x200); i++) {
        NetaMemoID[i] = 0;
        NetaMemoStr[i] = 0;
    }
}

void MakeMsgNetaName(CDC2Mes *message, CMenuPosDataForm *form, USER_PICTURE_INFO *photo, int *pos, int show_mark) {
    char blank[2] = " ";
    char         *name = GetPhotoName(photo);
    int           offset_x = 6;

    if (name == NULL) {
        name = blank;
    }

    int message_no = 50;

    if (photo != NULL && photo->neta_id > 0 && show_mark == 1) {
        message_no = 601;

        if (photo->neta_id >= 1000) {
            message_no = 605;
        }

        offset_x = 0;
    }

    if (LanguageCode > 0) {
        message->SetHalfFontWPercent(0.5f);
    }

    message->MakeMsg(message_no);
    message->SetMsgItemNo(&name, 1);
    pos[0] -= message->GetStringDrawWidthDC(name) >> 1;
    pos[0] += offset_x;

    if (form != NULL) {
        if (pos[0] <= 0) {
            pos[0] = 514;
        }

        form->x = pos[0];
        form->y = pos[1];
    }
}

void MenuInventCreateCardDraw(int &tex_block, float *pos) {
    int         i;
    mgCTexture *texture = Tex_Hatsumei;

    if (texture != NULL) {
        MenuReloadTexture(tex_block, texture->block);
        mgRect<int> card_rect(280, 466, 231, 45);
        mgRect<int> put_rect;
        put_rect.Set(0, 0, 0, 0);
        mgCDrawPrim *prim = GetMenuPrim();
        int          origin[2] = {(int) pos[0], (int) pos[1]};
        put_rect.Set(origin[0], origin[1], card_rect.right, card_rect.bottom);
        u8 rgba[4] = {0x80, 0x80, 0x80, 0x80};
        SetSpriteEnv(prim, 0);
        prim->Bilinear(1);
        prim->Begin(6);
        prim->Texture(texture);

        for (i = 0; i < 256; i++) {
            if (put_rect.top + put_rect.bottom >= 20) {
                prim->Color(0x80, 0x80, 0x80, 0x80);
                PrimQuad(prim, put_rect, card_rect);

                if (put_rect.top >= 410) {
                    break;
                }
            }

            put_rect.top += 46;
        }

        prim->End();
        mgCTexture *icon_tex = MenuPosData->item_icon_tex[0][0];

        if (icon_tex != NULL) {
            MenuReloadTexture(tex_block, icon_tex->block);
            put_rect.left = origin[0] + 35;
            put_rect.top = origin[1] + 6;

            for (i = 0; i < 256; i++) {
                if (put_rect.top + put_rect.bottom >= 20) {
                    mgRect<float> icon_rect(put_rect.left, put_rect.top, 32.0f, 33.0f);
                    DrawOneItem(prim, icon_rect, InventUserDataPtr->GetCreateItemID(i), 2, NULL, rgba, 0);

                    if (put_rect.top >= 410) {
                        break;
                    }
                }

                put_rect.top += 46;
            }
        }

        MenuReloadTexture(tex_block, -1);
    }
}

void PictureDraw(mgCTexture *tex, USER_PICTURE_INFO *photo, float x, float y, float scale, int alpha, int red,
                 int blue, int green) {
    float        w;
    float        h;
    float        right;
    float        bottom;
    mgRect<int>  tex_rect;
    mgCDrawPrim *prim;
    mgRect<int>  put_rect;

    if (tex == NULL) {
        return;
    }

    w = 80.0f;
    h = 64.0f;
    tex_rect.Set(0, 0, 64, 64);
    w *= scale;
    x += (80.0f - w) / 2.0f;
    h *= scale;
    y += (64.0f - h) / 2.0f;

    if (mgScreenWidth < x) {
        return;
    }

    bottom = y + h;

    if (bottom < 0.0f) {
        return;
    }

    prim = GetMenuPrim();
    SetSpriteEnv(prim, 1);
    prim->Shading(0);
    prim->AntiAliasing(1);
    prim->Begin(6);
    prim->Color(0x20, 0x20, 0x20, alpha * 2 / 3);
    prim->Vertex(3.0f + (x - 2.0f), 3.0f + (y - 2.0f), 0.0f);
    right = x + w;
    right = 2.0f + right;
    bottom = 2.0f + bottom;
    prim->Vertex(3.0f + right, 3.0f + bottom, 0.0f);
    prim->Color(10, 10, 10, alpha);
    prim->Vertex((x - 2.0f) - 2.0f, (y - 2.0f) - 2.0f, 0.0f);
    prim->Vertex(1.0f + right, 1.0f + bottom, 0.0f);

    if (0 < photo->neta_id) {
        if (photo->neta_id >= 1000) {
            prim->Color(CMenuInventPt->scoop_color[0], CMenuInventPt->scoop_color[1], 0x40, alpha);
        } else {
            prim->Color(CMenuInventPt->neta_color[0], CMenuInventPt->neta_color[1], CMenuInventPt->neta_color[2],
                        alpha);
        }
    } else {
        prim->Color(0xCD, 0xCD, 0xCD, alpha);
    }

    prim->Vertex(x - 2.0f, (y - 2.0f) - 1.0f, 0.0f);
    prim->Vertex(right - 1.0f, bottom - 1.0f, 0.0f);
    prim->End();
    SetSpriteEnv(prim, 0);
    prim->AntiAliasing(1);
    prim->Bilinear(1);
    prim->AlphaTestEnable(0);
    prim->Begin(6);
    prim->Texture(tex);
    prim->Color(red, green, blue, alpha);
    prim->Direct(0x3B, 0x80 | (0x80UL << 32));
    put_rect.Set(x, y, w, h);
    PrimQuad(prim, put_rect, tex_rect);
    prim->End();
}

void PictureMemoOne(float x, float y, int alpha) {
    mgCDrawPrim *prim;

    prim = GetMenuPrim();
    SetSpriteEnv(prim, 0);
    prim->Bilinear(1);
    prim->Begin(6);
    prim->Texture(Tex_Hatsumei);
    prim->Color(0x80, 0x80, 0x80, alpha);
    prim->TextureCrd(0x6E, 0x162);
    prim->Vertex(x, y, 0.0f);
    prim->TextureCrd(0x90, 0x184);
    prim->Vertex(34.0f + x, 34.0f + y, 0.0f);
    prim->End();
}

void PictureDraw(int &tex_block, mgRect<float> rect, int picture_no, float scale, unsigned char *rgba) {
    mgCTexture        *texture = NULL;
    USER_PICTURE_INFO *photo = NULL;

    if (picture_no < 0) {
        return;
    }

    if (picture_no == 1000) {
        if (Tex_Hatsumei != 0) {
            MenuReloadTexture(tex_block, Tex_Hatsumei->block);
            PictureMemoOne(rect.left, rect.top, rgba[3]);
        }
    } else {
        if (0 <= picture_no && picture_no < 30) {
            texture = CMenuInventPt->photo_tex[picture_no];
            photo = InventUserDataPtr->GetPhotoInfo(picture_no);
        } else if (picture_no >= 50 && picture_no < 100) {
            picture_no -= 50;
            texture = CMenuInventPt->album_tex[picture_no];
            photo = InventAlbumPtr->GetAlbumPhotoInfo(picture_no);
        }

        if (texture == NULL || photo == NULL) {
            return;
        }

        int alpha = 0x80;

        if (rgba != NULL) {
            alpha = rgba[3];
        }

        MenuReloadTexture(tex_block, texture->block);
        PictureDraw(texture, photo, rect.left, rect.top, scale, alpha, rgba[0], rgba[1], rgba[2]);
    }
}

void MenuInventPictureBoardDraw(float *pos, int &tex_block, int alpha) {
    if (CMenuInventPt == NULL || CMenuInventPt->neta_board_form == NULL) {
        return;
    }

    USER_PICTURE_INFO *photos = InventUserDataPtr->GetPhotoInfo(0);
    MenuReloadTexture(tex_block, CMenuInventPt->photo_tex[0]->block);
    int         top = 108.0f + (4.0f + pos[1]);
    mgRect<int> clip;
    clip.Set(0, top, mgScreenWidth - 1, top + 163);
    MenuClipRectCheck(clip);
    SetMenuScissor(clip);
    int          i;
    mgCDrawPrim *prim = GetMenuPrim();

    for (i = 0; i < 30; i++) {
        if (*(s8 *) &photos[i].used == 0 || CMenuInventPt->SelectedNetaPhotoAlready(i) != 0) {
            continue;
        }

        USER_PICTURE_INFO *photo = &photos[i];
        float              x = pos[0] + CMenuInventPt->photo_pos[i][0];
        float              y = CMenuInventPt->photo_scroll + CMenuInventPt->photo_pos[i][1];

        if (y < 20.0f) {
            continue;
        }

        if (410.0f < y) {
            break;
        }

        PictureDraw(CMenuInventPt->photo_tex[i], photo, x, y, 0.7f, alpha, 0x80, 0x80, 0x80);

        if (*(s8 *) &photo->is_new != 0) {
            SetSpriteEnv(prim, 0);
            prim->Begin(6);
            prim->Texture(Tex_Hatsumei);
            prim->Color(0x80, 0x80, 0x80, alpha);
            mgRect<int> new_mark;
            new_mark.Set(74, 342, 34, 14);
            float mark_y = 44.8f + y;
            PrimQuad(prim, 35.0f + x, mark_y, new_mark);
            prim->End();
        }
    }

    ResetMenuScissor();

    if (InventInNetaEffectFlag != 0) {
        float target[2] = {24.0f + pos[0], 26.0f + pos[1]};

        for (int i = 0; i < InventInNetaEffectNum4; i++) {
            if (InventInNetaEffect[i].active != 0) {
                InventInNetaEffect[i].Step();
                InventInNetaEffect[i].Draw(Tex_Hatsumei, 220, 490);
            }
        }

        for (int i = 0; i < InventInNetaEffectNum; i++) {
            short *effect_alpha = &CMenuInventPt->neta_effect_alpha[i];

            if (*effect_alpha > 0) {
                float *effect_pos = CMenuInventPt->neta_effect_pos[i];
                float  dy = target[1] - effect_pos[1];
                effect_pos[0] += (target[0] - effect_pos[0]) / 26.0f;
                effect_pos[1] += dy / 12.0f;

                if (dy < 0.0f) {
                    dy = -dy;
                }

                if (dy < 14.0f) {
                    *effect_alpha -= 5;

                    if (*effect_alpha < 0) {
                        *effect_alpha = 0;
                    }
                } else {
                    CStarDust *star = CheckNotRunStarDust(InventInNetaEffect, InventInNetaEffectNum4);

                    if (star != NULL) {
                        int star_x = effect_pos[0] + GetRandF(34.0f);
                        star->Generate(star_x, 10.0f + effect_pos[1] + GetRandF(28.0f), 11, 7);
                    }
                }

                PictureMemoOne(effect_pos[0], effect_pos[1], CMenuInventPt->neta_effect_alpha[i]);
            }
        }
    }
}

void MenuInventAlbumPictureDraw(float *origin, int &loaded_tex) {
    mgRect<int>        unused_rect;
    mgRect<int>        clip_rect;
    USER_PICTURE_INFO *photo;
    float              y;
    int                i;
    float              top;
    int                clip_top;

    unused_rect.Set(0, 0, 0, 0);
    top = (8.0f) + origin[1];
    clip_top = (int) top;
    clip_rect.Set(0, clip_top, mgScreenWidth - 1, (int) (((270.0f) + top) - 2.0f));
    MenuClipRectCheck(clip_rect);
    SetMenuScissor(clip_rect);
    photo = InventAlbumPtr->GetAlbumPhotoInfo(0);
    mgCTexture *first_texture = CMenuInventPt->album_tex[0];

    if (first_texture != NULL) {
        MenuReloadTexture(loaded_tex, first_texture->block);
        i = 0;
        y = CMenuInventPt->album_scroll_y;

        do {
            if ((30.0f) < y && photo != NULL && photo->used == 1) {
                PictureDraw(CMenuInventPt->album_tex[i], photo,
                            CMenuInventPt->album_scroll_x + (80.0f) * (float) (i % 2), y, (0.7f), 0x80, 0x80,
                            0x80, 0x80);
            }

            if (i % 2 != 0) {
                y += (54.0f);
            }

            if ((410.0f) < y) {
                break;
            }

            i += 1;
            photo++;
        } while (i < (0x32));

        ResetMenuScissor();
    }
}

void MenuInventNetaMemoDraw(float *origin, int &loaded_tex) {
    mgRect<int> clip_rect;
    mgRect<int> row_rect;
    mgRect<int> bar_rect;

    int          i;
    mgCDrawPrim *prim;
    float        top;
    float        left;
    float        row_y;
    int          clip_top;
    int          clip_bottom;
    int          text_x;
    int          text_y;

    if (Tex_Hatsumei != 0 && !(origin[0] < -200.0f)) {
        top = 76.0f + origin[1];
        clip_top = (int) top;
        clip_bottom = (int) (240.0f + top);
        clip_rect.Set(0, clip_top, mgScreenWidth, clip_bottom);
        MenuClipRectCheck(clip_rect);
        SetMenuScissor(clip_rect);
        MenuReloadTexture(loaded_tex, Tex_Hatsumei->block);
        row_rect.Set(0x144, 0x180, 0xBC, 6);
        left = 16.0f + origin[0];
        row_y = 2.0f + (24.0f + CMenuInventPt->memo_scroll);
        prim = GetMenuPrim();
        SetSpriteEnv(prim, 0);
        prim->Begin(6);
        prim->Texture(Tex_Hatsumei);
        prim->Color(0x80, 0x80, 0x80, 0x80);
        i = 0;

        do {
            if (!(row_y < (float) (clip_top - 0x28))) {
                if ((float) clip_bottom < row_y) {
                    break;
                }

                PrimQuad(prim, left, row_y, row_rect);
            }

            i += 1;
            row_y += 26.0f;
        } while (i < (0x200));

        prim->End();
        ResetMenuScissor();
        bar_rect.Set(0x90, 0x166, 8, 0x1C);
        SetSpriteEnv(prim, 0);
        prim->Begin(6);
        prim->Texture(Tex_Hatsumei);
        prim->Color(0x80, 0x80, 0x80, 0x80);
        PrimQuad(prim, 209.0f + origin[0], CMenuInventPt->memo_bar, bar_rect);
        prim->End();
        SetMenuScissor(clip_rect);
        MenuReloadTexture(loaded_tex, MenuArg.mes_tex_block);
        text_x = (int) (6.0f + left);
        text_y = (int) (4.0f + CMenuInventPt->memo_scroll);

        CMenuFont menu_font;
        char      text[0x20];
        menu_font.SetClearance(0xE, 0x18);
        i = 0;

        while (i < pic_name_info_num && i < (0x200)) {
            if (text_y >= clip_top - 0x28) {
                if (clip_bottom < text_y) {
                    break;
                }

                char *name = NetaMemoStr[i];

                if (name != NULL) {
                    short neta_id = NetaMemoID[i];
                    char *prefix;

                    if (neta_id < 0x3E8) {
                        prefix = gaiji_table_4737[0];
                    } else if (neta_id < 0x2710) {
                        prefix = gaiji_table_4737[1];
                    } else {
                        prefix = gaiji_table_4737[2];
                    }

                    sprintf(text, "%s%s", prefix, name);
                    menu_font.SetStr(text);
                    menu_font.SetPos(text_x, text_y);
                    menu_font.DrawDirect(menu_font.str, menu_font.pos_x, menu_font.pos_y);
                } else {
                    menu_font.SetStr(GetHatena());
                    menu_font.SetPos(text_x, text_y);
                    menu_font.DrawDirect(menu_font.str, menu_font.pos_x, menu_font.pos_y);
                }
            }

            i += 1;
            text_y += (0x1A);
        }

        ResetMenuScissor();
    }
}

/**
 *
 * Background allocation selections for the inventory character assets.
 *
 */
static int tbl_4782[7] = {
    1, 1, 0, 0, 1, 1, 0
};

extern char at_5011[];
extern char at_5012[];
extern char at_5013[];
extern char at_5014[];
extern char at_5015[];
extern char at_5016[];
extern int *menu_randam_line_draw_postbl;

inline CMenuInvent::CMenuInvent() {
    int i;
    card_cursor = card_top = 0;
    item_cursor = item_top = 0;
    photo_cursor = photo_top = 0;
    album_cursor = album_top = 0;
    memo_cursor = 0;
    memo_top = 0;
    card_scroll_dir = 0;
    unk_112 = 0;

    for (i = 0; i < 3; i++) {
        neta_select_index[i] = -1;
        neta_select_type[i] = neta_select_state[i] = -1;
        unk_622[i] = 0;
    }

    neta_select_num = 0;
    neta_circle_angle = 0.0f;
    neta_circle_radius = 40.0f;
    create_step = 0;
    create_item_id = 0;
    create_partial_match = -1;

    for (i = 0; i < 3; i++) {
        create_photo_neta[i] = 0;
    }

    create_missing_slot = -1;
    blink_time = 0;
    neta_circle_snap = 0;
    neta_flash_angle = 0.0f;
    neta_effect_time = 0;
    album_scroll_reset = 0;
    album_scroll_x = album_scroll_y = 0.0f;

    for (i = 0; i < 30; i++) {
        photo_tex[i] = NULL;
        photo_pos[i][0] = (i % 2) * 0x58 + 8;
        photo_pos[i][1] = (i / 2) * 0x36 + 0x68;
    }

    for (i = 0; i < 50; i++) {
        album_tex[i] = NULL;
    }

    InitPhotoNetaBoardToAlbum(0);
    create_sound_buffer = NULL;
    photo_scroll = 0.0f;
    photo_bar = 0.0f;
    create_scale_in = 0.0f;
    create_show_phase = 0;
    blink_count = 0;
    chara_read_info = NULL;
    chara_load_step = 0;
    sub_chara = NULL;
    create_effect = NULL;
    create_chara = NULL;
    arrow_count = 0;
    photo_only = 0;
    gradation_mode = 0;
    gradation_height = 0;
    download_base = 0;
    mgZeroVector(neta_color);
    scoop_color[0] = 128.0f;
    scoop_color[1] = 128.0f;
    scoop_color[2] = 128.0f;
    blink_count = 0;
    effect_sway = 2.5f;
    effect_bob = 5.0f;
    effect_bob_angle = 0.0f;
    effect_bob_count = 0;
    effect_sway_angle = 0.0f;
    chara_pos[0] = 20.0f;
    chara_pos[1] = -29.0f;
    chara_pos[2] = 14.0f;
    chara_pos[3] = 1.0f;
    chara_make_pos[0] = 11.0f;
    chara_make_pos[1] = -28.0f;
    chara_make_pos[2] = 20.0f;
    chara_make_pos[3] = 1.0f;
    strcpy(icon_data[0].name, at_5011);
    strcpy(icon_data[1].name, at_5012);
    strcpy(icon_data[2].name, at_5013);
    Init_MENUFORM_MAKEBRD_INFO(&make_board);
}

static inline u8 *StackBytes(mgCMemory *m) { return m->stack_bytes; }

static inline int StackSize(mgCMemory *m) { return m->stack_size; }

static inline int StackUsed(mgCMemory *m) { return m->stack_used; }

#ifdef NONMATCHING
int MenuInventInit(mgCMemory *memory, int *tex_block, int arg) {
    int size = StackSize(memory);
    u8 *pack = StackBytes(memory);
    MenuInventStack.stSetBuffer((u_long128 *) pack, size);
    MenuInventStack.stAlloc64(StackUsed(memory));
    mgCMemory *stack = &MenuInventStack;
    debug_invent_successflag = 0;
    InventAlbumPtr = NULL;
    InventUserDataPtr = NULL;
    CMenuInventPt = new ((u_long128 *) stack->Alloc(StackBlocks(sizeof(CMenuInvent)))) CMenuInvent;
    CMenuInventPt->SetTexBlock(tex_block);
    InventUserDataPtr = GetInventUserDataPtr();
    InventManagePt = &InventManageMan;
    InventManagePt->Clear();
    if (MenuCommonInfo->open_type == 10) {
        CMenuInventPt->photo_only = 1;
    }
    MCManagerPtr = NULL;
    MenuBGReadInfo2Malloc(stack, tbl_4782);
    MenuActionChara[0] = NewInventActionChara(stack);
    MenuActionChara[1] = NULL;
    MenuActionChara[2] = NULL;
    MenuActionChara[3] = NewInventActionChara(stack);
    MenuActionChara[4] = NewInventActionChara(stack);
    MenuActionChara[5] = NULL;
    MenuActionChara[0]->Initialize(NULL);
    MenuActionChara[3]->Initialize(NULL);
    MenuActionChara[4]->Initialize(NULL);
    CMenuEffect *effect;
    if ((effect = (CMenuEffect *) operator new(sizeof(CMenuEffect), stack->Alloc(StackBlocks(sizeof(CMenuEffect))))) != NULL) {
        effect->Initialize();
    }
    MenuEffect[0] = effect;
    if ((effect = (CMenuEffect *) operator new(sizeof(CMenuEffect), stack->Alloc(StackBlocks(sizeof(CMenuEffect))))) != NULL) {
        effect->Initialize();
    }
    MenuEffect[1] = effect;
    MenuMoveItemPtr = new ((u_long128 *) stack->Alloc(StackBlocks(sizeof(CMenuMoveItem)))) CMenuMoveItem;
    menu_randam_line_draw_postbl = &CMenuInventPt->line_pos[0][0];
    InventTeigiStack.stSetBuffer(stack->stGetTop(), 0x210);
    stack->Alloc(0x210);
    stack->Align64();
    InventUserDataPtr->ResetAddress();
    CMenuInventPt->AttachFormInfo();
    MenuMoveItemPtr->AttachForm();
    u_long128 *data_top = stack->stGetTop();
    CMenuInventPt->data_stack.stSetBuffer(data_top, 0x1310);
    stack->Alloc(0x1310);
    if (CMenuInventPt->photo_only == 0) {
        CMenuInventPt->EnterDataMenu(pack);
    }
    StartReadBG();
    if (CMenuInventPt->photo_only == 1) {
        u_int size = LoadFileMenu(at_5014, stack->stGetTop(), 0);
        stack->Alloc((size & 0xF) ? (size >> 4) + 1 : size >> 4);
    }
    InventSubDataReadBGInfo = (unsigned int) GetReadBGFile(0);
    u_long128 *chara_top = stack->stGetTop();
    MenuInventMCStack.stSetBuffer(chara_top, stack->stGetRest());
    MenuActionCharaBuffer[0].stSetBuffer(stack->stGetTop(), 0x1B80);
    stack->Alloc(0x1B80);
    stack->Align64();
    MenuActionCharaBuffer[1].stSetBuffer(stack->stGetTop(), 0x9AC0);
    stack->Alloc(0x9AC0);
    stack->Align64();
    MenuActionCharaBuffer[4].stSetBuffer(stack->stGetTop(), 0xBC0);
    stack->Alloc(0xBC0);
    stack->Align64();
    MenuActionCharaBuffer[5].stSetBuffer(stack->stGetTop(), 0x26C0);
    stack->Alloc(0x26C0);
    stack->Align64();
    MenuActionCharaBuffer[2].stSetBuffer(NULL, 0);
    MenuActionCharaBuffer[3].stSetBuffer(NULL, 0);
    MenuActionCharaBuffer[6].stSetBuffer(NULL, 0);
    if (CMenuInventPt->photo_only == 1) {
        CMenuInventPt->chara_stack.stSetBuffer(stack->stGetTop(), 0x1680);
        stack->Alloc(0x1680);
        stack->Align64();
    }
    MenuInventCharaStack.stSetBuffer(chara_top, 0xC200);
    stack->Align64();
    int rest = stack->stGetRest();
    MenuCharaLoadStack.stSetBuffer(stack->stGetTop(), rest);
    MenuCharaLoadStack.stack_used = 0;
    MenuCharaLoadStack.lock = 0;
    CMenuInventPt->LoadCharaCheck();
    switch (CMenuInventPt->photo_only) {
        case 1:
            CMenuInventPt->key_arg_no = 6;
            MenuMainFrameModeSet(1, 1);
            ReturnMenuIntern(1);
            MenuMesForm[0]->draw_flag = 0;
            CMenuPosDataForm *image_form = MenuPosData->GetFormInfo(at_5015);
            if (image_form != NULL) {
                image_form->draw_flag = 1;
                image_form->x = 0.0f;
                image_form->y = 0.0f;
            }
            CMenuInventPt->GradationSet(0);
            break;
        case 0:
            CMenuInventPt->key_arg_no = 2;
            CMenuInventPt->ExeScript(at_5016);
            CMenuInventPt->poly_chr_form[0]->counter = 0;
            CMenuInventPt->ExeScript("\x8d\x6c\x82\xa6\x83\x82\x81\x5b\x83\x68" "0");
            CMenuInventPt->PrepareNextMode(CMenuInventPt->key_arg_no);
            CMenuInventPt->GradationSet(0);
            MenuMainFrameModeSet(6, 1);
            SetSpectolInfo(NULL, NULL);
            break;
    }
    MenuCamInit(1.0f);
    itemmenu_chr_rotflag = 1;
    if (CursorSaveOptionState()) {
        CMenuSystemData *sys = GetMenuSysData();
        if (sys != NULL) {
            CMenuInventPt->item_cursor = sys->invent_item.select;
            CMenuInventPt->item_top = sys->invent_item.top;
            CMenuInventPt->card_cursor = sys->invent_card.select;
            CMenuInventPt->card_top = sys->invent_card.top;
            CMenuInventPt->photo_cursor = sys->invent_photo.select;
            CMenuInventPt->photo_top = sys->invent_photo.top;
            CMenuInventPt->album_cursor = sys->invent_album.select;
            CMenuInventPt->album_top = sys->invent_album.top;
            CMenuInventPt->memo_cursor = sys->invent_memo.select;
            CMenuInventPt->memo_top = sys->invent_memo.top;
            CMenuInventPt->memo_sort_mode = sys->invent_memo_sort_mode;
        }
    }
    CMenuInvent *menu = CMenuInventPt;
    MenuItemBrdSetInfo(menu->item_cursor, menu->item_top, GetNowBagMax(0) / 6, 5);
    MenuCommonInfo->cursor = 0;
    MenuCommonInfo->key_enable = 0;
    MenuCommonInfo->SetWakuType(-1);
    MenuCommonInfo->SetWakuWH(0, 0x20, 0x20);
    CheckEnableHaveItemNum();
    InventInNetaEffectFlag = 0;
    InitMenuDl(NULL, 0);
    SetModeMenuDrawItemBoard(0);
    return 1;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/inventmn", MenuInventInit__FP9mgCMemoryPii);
#endif

void CMenuInvent::NextDifferentMode(int next, int arg) {
    switch (next) {
        case 0:
        case 1:
            break;
        case 2:
            if (MenuCommonInfo->have_item.item_no > 0) {
                next = 3;
                break;
            }

            if (this->key_arg_no == INVENT_MODE_ITEM_LIST) {
                MenuMesForm[0]->SetAction("\x8d\xb6\x89\xba\x82\xd6");
                this->CreateModeSwapForm(0);
            }

            break;
        case 3:
            this->CreateModeSwapForm(1);
            MenuMesForm[0]->SetAction("\x92\x86\x82\xd6");
            this->item_cursor = (this->item_top + (this->card_cursor - this->card_top)) * 6;
            break;
        case 4: {
            int gap;
            this->photo_cursor = this->photo_top * 2;
            gap = this->album_cursor / 2 - this->album_top;

            if (gap < 3) {
                gap = 0;
            } else {
                gap = gap - 2;
            }

            this->photo_cursor = this->photo_cursor + (gap * 2 + 1);
            break;
        }
        case 5:
        case 6:
        case 7:
            break;
        case 8:
            this->ExeScript("\x83\x6c\x83\x5e\x92\x50\x8c\xea\x83\x8a\x83\x58\x83\x67OFF");
            break;
        case 9:
            break;
    }

    MenuSePlay(0);
    this->key_arg_no = next;
}

int MenuInventDebugKey() {
    int keys = MenuCommonInfo->CheckSelectKey() | MenuCommonInfo->CheckLRKey();
    int button = MenuCommonInfo->CheckPushButton();

    switch (CMenuInventPt->key_arg_no) {
        case INVENT_MODE_THINK:
            if (keys & MENU_SELECT_KEY_UP) {
                debug_invent_select--;
            }

            if (keys & MENU_SELECT_KEY_DOWN) {
                debug_invent_select++;
            }

            if ((keys & MENU_SELECT_KEY_L1) || (keys & MENU_SELECT_KEY_L2)) {
                debug_invent_select -= 10;
            }

            if ((keys & MENU_SELECT_KEY_R1) || (keys & MENU_SELECT_KEY_R2)) {
                debug_invent_select += 10;
            }

            if (debug_invent_select < 0) {
                debug_invent_select = 0;
            }

            if (pic_name_info_num <= debug_invent_select) {
                debug_invent_select = pic_name_info_num - 1;
            }

            switch (button) {
                case MENU_PUSH_BUTTON_SELECT:
                    debug_invent_successflag ^= 1;
                    break;
                case MENU_PUSH_BUTTON_DECIDE: {
                    USER_PICTURE_INFO *photo = InventUserDataPtr->IsPhotoSpace(NULL);

                    if (photo != NULL) {
                        photo->used = 1;
                        photo->is_new = 1;
                        photo->neta_id = pic_name_info_top[debug_invent_select].neta_id;
                        photo->map_no = -1;
                        photo->npc_no = -1;
                        photo->monster_no = -1;
                        photo->unk_8 = -1;
                        memset(photo->image, 0, 0x2000);
                        MenuSePlay(1);
                    } else {
                        MenuSePlay(5);
                    }

                    break;
                }
                case MENU_PUSH_BUTTON_TRIANGLE:
                    for (int i = 0; i < pic_name_info_num; i++) {
                        GetInventUserDataPtr()->SetNetaFlag(pic_name_info_top[i].neta_id);
                    }

                    break;
                case MENU_PUSH_BUTTON_SQUARE:
                    for (int i = 0; i < 30; i++) {
                        InventUserDataPtr->LevelCheck(&InventUserDataPtr->photo[i]);
                    }

                    MenuSePlay(1);
                    break;
                case MENU_PUSH_BUTTON_CANCEL:
                    for (int i = 0; i < InventManageMan.num - 20; i++) {
                        InventUserDataPtr->SetCreateItemFlag(i + 1, InventManageMan.table[i].item_id);
                    }

                    break;
            }

            break;
    }

    return 1;
}

void MenuInventDebugDraw() {
    DrawMenuFillBox(0x40, 0, 0, 0);
    mgCTextureManager *texture_manager = &mgTexManager;
    mgCDrawPrim        prim;
    mgCTextureManager *tex_manager = texture_manager;
    CMenuFont          font;
    char               line[0x40];
    float              scale[4];
    float              position[4];
    char               model_text[0x80];

    switch (CMenuInventPt->key_arg_no) {
        case INVENT_MODE_THINK: {
            int   y = 80 - debug_invent_select * 20;
            float top = 80.0f;
            float left = 270.0f;
            float width = 220.0f;
            float height = 300.0f;
            DrawMenuFillBox(left, top, width, height, 0x80, 0, 0, 0);
            tex_manager->ReloadTexture(MenuArg.mes_tex_block, (sceVif1Packet *) NULL);

            for (int i = 0; i < pic_name_info_num; i++) {
                if (y >= 80) {
                    sprintf(line, "%3d: %s", pic_name_info_top[i].neta_id, pic_name_info_top[i].name);
                    font.SetStr(line);
                    font.SetPos(270, y);
                    font.DrawDirect(font.str, font.pos_x, font.pos_y);
                }

                y += 20;

                if (y >= 380) {
                    break;
                }
            }

            font.SetStr("\x81\xa8");
            font.SetPos(250, 80);
            font.DrawDirect(font.str, font.pos_x, font.pos_y);

            if (debug_invent_successflag != 0) {
                font.SetStr("Force Success Mode");
                font.SetPos(20, 60);
                font.DrawDirect(font.str, font.pos_x, font.pos_y);
            }

            if (CMenuInventPt->create_chara != NULL) {
                CMenuInventPt->create_chara->GetScale(scale);
                CMenuInventPt->create_chara->GetPosition(position);
                sprintf(model_text, "scale:%f\npos  :%f\n      %f\n      %f\n", scale[0], position[0], position[1], position[2]);
                font.SetStr(model_text);
                font.SetPos(40, 340);
                font.DrawDirect(font.str, font.pos_x, font.pos_y);
            }

            break;
        }
    }
}

int MenuInventPushKey(int pad, int pushed) {
    int mode = CMenuInventPt->key_arg_no;

    if (CMenuInventPt->mode <= 0) {
        if (menu_debug_flag != 0) {
            MenuInventDebugKey();
            return 0;
        }

        int         leave = 0;
        int         command = K_COMMAND_NONE;
        signed char lock = CMenuInventPt->chara_load_step;

        if (lock == 0 || lock == 1) {
            pushed = 0;
        }

        int mode_changed = 0;

        switch (mode) {
            case INVENT_MODE_THINK:
            case INVENT_MODE_THINK_WITH_ALBUM:
            case INVENT_MODE_PHOTO_VIEW: {
                int overcode[4] = {0, 0, 0, 2};

                if (CMenuInventPt->album_enable == 0) {
                    overcode[3] = 0;
                }

                int old_cursor = CMenuInventPt->photo_cursor;

                if ((pad & (1)) && old_cursor / 2 == 0) {
                    CMenuInventPt->NextDifferentMode(INVENT_MODE_MEMO_ARROW, 0);
                } else {
                    int result =
                        MenuGlidKeyCheck(pad, &CMenuInventPt->photo_cursor, &CMenuInventPt->photo_top,
                                         maxtbl_5171, viewnum_5172, overcode, 30);

                    if (old_cursor != CMenuInventPt->photo_cursor) {
                        MenuSePlay(0);
                    }

                    if (result == 2) {
                        CMenuInventPt->NextDifferentMode(nextmodetbl_5183[CMenuInventPt->key_arg_no], 0);
                        mode_changed = 1;
                    }
                }

                break;
            }
            case INVENT_MODE_THINK_ALBUM_BUTTON:
            case INVENT_MODE_PHOTO_ALBUM_BUTTON:
                if (pad & (4)) {
                    if (CMenuInventPt->photo_only == 1) {
                        CMenuInventPt->NextDifferentMode(INVENT_MODE_PHOTO_VIEW, 0);
                    } else {
                        CMenuInventPt->NextDifferentMode(INVENT_MODE_THINK, 0);
                    }

                    mode_changed = 1;
                }

                break;
            case INVENT_MODE_CARD_LIST: {
                int old_row = CMenuInventPt->card_top;
                int old_cursor = CMenuInventPt->card_cursor;
                int count = CMenuInventPt->EnableSelectMaxCardList();
                int jump = 0;

                if ((pad & 0x10) || (pad & 0x40)) {
                    jump = -8;
                } else if ((pad & 0x20) || (pad & 0x80)) {
                    jump = 8;
                }

                if (jump != 0) {
                    CMenuInventPt->card_cursor += jump;

                    if (CMenuInventPt->card_cursor < 0) {
                        CMenuInventPt->card_cursor = 0;
                    }

                    if (count - 1 < CMenuInventPt->card_cursor) {
                        CMenuInventPt->card_cursor = count - 1;
                    }

                    MenuCheckLine(&CMenuInventPt->card_top, CMenuInventPt->card_cursor, 5);
                } else {
                    MenuListKeyCheck(pad, &CMenuInventPt->card_cursor, &CMenuInventPt->card_top,
                                     count, 5, 0, 0);

                    if (pad & (8)) {
                        CMenuInventPt->NextDifferentMode(INVENT_MODE_ITEM_LIST, 0);
                        mode_changed = 1;
                    }
                }

                if (old_cursor != CMenuInventPt->card_cursor) {
                    MenuSePlay(0);
                }

                int new_row = CMenuInventPt->card_top;

                if (old_row != new_row) {
                    if (old_row < new_row) {
                        CMenuInventPt->card_scroll_dir = 1;
                    } else {
                        CMenuInventPt->card_scroll_dir = 0;
                    }
                }

                if (menu_debug_flag != 0) {
                    int debug_pushed;
                    int held;
                    MenuCommonInfo->GetDebugInputKey(held, debug_pushed);

                    if (debug_pushed & 4) {
                        InventUserDataPtr->SetCreateItemFlag(CMenuInventPt->card_cursor, 0);
                        return 0;
                    }
                }

                break;
            }
            case INVENT_MODE_ITEM_LIST:
                if (MenuItemBrdKey(pad, &CMenuInventPt->item_cursor, &CMenuInventPt->item_top,
                                   0) == 1) {
                    CMenuInventPt->NextDifferentMode(INVENT_MODE_CARD_LIST, 0);
                    mode_changed = 1;
                }

                break;
            case INVENT_MODE_ALBUM_VIEW: {
                int old_cursor = CMenuInventPt->album_cursor;
                int result = MenuGlidKeyCheck(pad, &CMenuInventPt->album_cursor,
                                              &CMenuInventPt->album_top, maxtbl_album_5223,
                                              viewnum_album_5224, overcode_album_5225, 50);

                if (old_cursor != CMenuInventPt->album_cursor) {
                    MenuSePlay(0);
                }

                if (result == 2) {
                    CMenuInventPt->NextDifferentMode(INVENT_MODE_THINK_WITH_ALBUM, 0);
                    mode_changed = 1;
                }

                break;
            }
            case INVENT_MODE_MEMO_ARROW:
                if (pad & (1)) {
                    CMenuInventPt->NextDifferentMode(INVENT_MODE_MEMO_BUTTON, 0);
                } else if (pad & (2)) {
                    int next = INVENT_MODE_THINK;

                    if (CMenuInventPt->photo_only == 1) {
                        next = INVENT_MODE_PHOTO_VIEW;
                    }

                    if (CMenuInventPt->unk_112 == 1) {
                        next = INVENT_MODE_THINK_WITH_ALBUM;
                    }

                    CMenuInventPt->NextDifferentMode(next, 0);
                    mode_changed = 1;
                }

                break;
            case INVENT_MODE_MEMO_BUTTON:
                if (pad & (2)) {
                    CMenuInventPt->NextDifferentMode(INVENT_MODE_MEMO_ARROW, 0);
                }

                break;
            case INVENT_MODE_MEMO_CORK:
                if (pad & (2)) {
                    CMenuInventPt->NextDifferentMode(INVENT_MODE_MEMO_LIST, 0);
                }

                break;
            case INVENT_MODE_MEMO_LIST: {
                int step = 0;

                if (pad & (1)) {
                    step -= 1;
                }

                if (pad & (2)) {
                    step += 1;
                }

                if ((pad & 0x10) || (pad & 0x40)) {
                    step -= 8;
                    CMenuInventPt->memo_scroll_reset = 1;
                }

                if ((pad & 0x20) || (pad & 0x80)) {
                    step += 8;
                    CMenuInventPt->memo_scroll_reset = 1;
                }

                int old_cursor = CMenuInventPt->memo_cursor;
                CMenuInventPt->memo_cursor = old_cursor + step;
                int at_start = 0;

                if (CMenuInventPt->memo_cursor < 0) {
                    CMenuInventPt->memo_cursor = 0;
                    at_start = 1;
                }

                int last = pic_name_info_num - 1;

                if (last < CMenuInventPt->memo_cursor) {
                    CMenuInventPt->memo_cursor = last;
                }

                MenuCheckLine(&CMenuInventPt->memo_top, CMenuInventPt->memo_cursor, 9);

                if (at_start != 0) {
                    CMenuInventPt->NextDifferentMode(INVENT_MODE_MEMO_CORK, 0);
                } else if (old_cursor != CMenuInventPt->memo_cursor) {
                    MenuSePlay(0);
                }

                break;
            }
        }

        if (mode != CMenuInventPt->key_arg_no) {
            mode_changed = 1;
        }

        int                swap_slot = CMenuInventPt->item_cursor;
        CGameDataUsed     *item = (CGameDataUsed *) &MenuUserParam.used_data[swap_slot];
        MENU_SWAPITEM_INFO swap_info;
        swap_info.Set(4, swap_slot, -1, 0);
        int next_mode = -1;

        if (mode_changed == 0) {
            switch (CMenuInventPt->key_arg_no) {
                case INVENT_MODE_THINK:
                case INVENT_MODE_PHOTO_VIEW: {
                    USER_PICTURE_INFO *photo =
                        InventUserDataPtr->GetPhotoInfo(CMenuInventPt->photo_cursor);

                    switch (pushed) {
                        case 4:
                            command = K_COMMAND_SET_CIRCLE;

                            if (CMenuInventPt->photo_only == 1) {
                                command = K_COMMAND_HANDLED;
                            }

                            break;
                        case 2:
                            next_mode = 2;
                            command = K_COMMAND_LEAVE_CIRCLE;

                            if (CMenuInventPt->photo_only == 1) {
                                command = K_COMMAND_RETURN_ITEM;
                            }

                            break;
                        case 8:
                            command = K_COMMAND_CHECK_IDEAS;

                            if (CMenuInventPt->neta_select_num < 3) {
                                command = K_COMMAND_REJECT;
                            }

                            if (CMenuInventPt->photo_only == 1) {
                                command = K_COMMAND_HANDLED;
                            }

                            break;
                        case 1:
                            if (CMenuInventPt->SelectedNetaPhotoAlready(
                                    CMenuInventPt->photo_cursor) == 0 &&
                                photo->used != 0) {
                                command = K_COMMAND_EXTEND;
                                MenuItemCmdArgPos = 5;
                            }

                            break;
                        case 32:
                            command = K_COMMAND_TAKE_PHOTO;
                            break;
                    }

                    break;
                }
                case INVENT_MODE_THINK_ALBUM_BUTTON:
                case INVENT_MODE_PHOTO_ALBUM_BUTTON:
                    switch (pushed) {
                        case 1:
                            CMenuInventPt->ExeScript("IS_MCACCESS");

                            if (LanguageCode > 0 && LanguageCode < 6) {
                                MenuDCMsg[4]->SetMsgCursor(1);
                                MenuDCMsg[4]->select_top = 1;
                            }

                            CMenuInventPt->mode = 14;
                            CMenuInventPt->step = 0;
                            CMenuInventPt->album_save_mode = 0;
                            CMenuInventPt->unk_112 = 1;
                            break;
                        case 2:
                            next_mode = 2;
                            command = K_COMMAND_LEAVE_CIRCLE;

                            if (CMenuInventPt->photo_only == 1) {
                                command = K_COMMAND_RETURN_ITEM;
                            }

                            break;
                    }

                    break;
                case INVENT_MODE_CARD_LIST:
                    switch (pushed) {
                        case 1:
                        case 4:
                        case 8:
                            if (MenuCommonInfo->have_item.item_no > 0) {
                                command = K_COMMAND_REJECT;
                            } else {
                                command = K_COMMAND_PICK_CREATED;
                            }

                            break;
                        case 2:
                            command = K_COMMAND_RETURN_ITEM;
                            break;
                    }

                    break;
                case INVENT_MODE_ITEM_LIST:
                    switch (pushed) {
                        case 4:
                            command = K_COMMAND_SWAP_ITEM;
                            break;
                        case 2:
                            command = K_COMMAND_SWAP_BACK;
                            break;
                        case 1:
                            command = K_COMMAND_ITEM_COMMAND;
                            break;
                        case 8:
                            command = K_COMMAND_GET_ITEM_ALL;
                            break;
                    }

                    break;
                case INVENT_MODE_THINK_WITH_ALBUM:
                    switch (pushed) {
                        case 4:
                            break;
                        case 2:
                            command = K_COMMAND_QUIT;
                            break;
                        case 1:
                            command = K_COMMAND_EXTEND;
                            MenuItemCmdArgPos = 5;
                            break;
                    }

                    break;
                case INVENT_MODE_ALBUM_VIEW:
                    switch (pushed) {
                        case 4:
                        case 8:
                            command = K_COMMAND_REJECT;
                            break;
                        case 2:
                            command = K_COMMAND_QUIT;
                            break;
                        case 1:
                            command = K_COMMAND_EXTEND;
                            MenuItemCmdArgPos = 6;
                            break;
                        case 32:
                            command = K_COMMAND_TAKE_PHOTO;
                            break;
                    }

                    break;
                case INVENT_MODE_MEMO_ARROW:
                    if ((pushed & 1) || (pushed & 4)) {
                        command = K_COMMAND_CONFIRM_BOARD;
                    } else if (pushed & 2) {
                        command = K_COMMAND_LEAVE_CIRCLE;
                        next_mode = 2;

                        if (CMenuInventPt->photo_only == 1) {
                            command = K_COMMAND_RETURN_ITEM;
                        }

                        if (CMenuInventPt->unk_112 == 1) {
                            command = K_COMMAND_QUIT;
                        }
                    }

                    break;
                case INVENT_MODE_MEMO_BUTTON:
                    switch (pushed) {
                        case 1:
                        case 4:
                            command = K_COMMAND_OPEN_MEMO;
                            MenuSePlay(1);
                            break;
                        case 2:
                            next_mode = 2;
                            command = K_COMMAND_LEAVE_CIRCLE;

                            if (CMenuInventPt->photo_only == 1) {
                                command = K_COMMAND_RETURN_ITEM;
                            }

                            if (CMenuInventPt->unk_112 == 1) {
                                CMenuInventPt->mode = 14;
                                CMenuInventPt->step = 201;
                                CMenuInventPt->album_save_mode = 1;
                                command = K_COMMAND_HANDLED;
                                CMenuInventPt->ExeScript("SAVE_SLOTSEL");
                            }

                            break;
                    }

                    break;
                case INVENT_MODE_MEMO_CORK:
                    if ((pushed & 1) || (pushed & 4)) {
                        command = K_COMMAND_CLOSE_MEMO;
                        MenuSePlay(1);
                    } else if (pushed & 2) {
                        command = K_COMMAND_BACK_MODE;
                        next_mode = 8;
                    }

                    break;
                case INVENT_MODE_MEMO_LIST:
                    switch (pushed) {
                        case 1:
                        case 4:
                            command = K_COMMAND_SET_CIRCLE;

                            if (CMenuInventPt->photo_only == 1 ||
                                CMenuInventPt->unk_112 == 1) {
                                command = K_COMMAND_REJECT;
                            }

                            break;
                        case 8:
                            command = K_COMMAND_CHECK_IDEAS;

                            if (CMenuInventPt->neta_select_num < 3) {
                                command = K_COMMAND_REJECT;
                            }

                            if (CMenuInventPt->photo_only == 1) {
                                command = K_COMMAND_HANDLED;
                            }

                            break;
                        case 2:
                            command = K_COMMAND_BACK_MODE;
                            next_mode = 8;
                            break;
                    }

                    break;
            }
        }

        CDC2Mes *message = MenuDCMsg[4];

        switch (command) {
            case K_COMMAND_REJECT:
                MenuSePlay(5);
                break;
            case K_COMMAND_ITEM_COMMAND:
                CMenuInventPt->MenuItemMoveItemCommand(item, 4, 5,
                                                       (CMenuPosDataForm *) MenuMesForm[5], 0);
                break;
            case K_COMMAND_SWAP_ITEM:
                if (CMenuInventPt->CheckSpectolFusion(item, 5, MenuMesForm[5]) != 0) {
                    CMenuPosDataForm *form = MenuCommonInfo->cursor_form;

                    if (form != NULL) {
                        form->draw_flag = 0;
                    }

                    MenuSePlay(1);
                } else {
                    switch (MenuCommonInfo->EnableSwapNowPos(&swap_info)) {
                        case 0:
                            MenuSePlay(menu_item_swap_sndtbl[MenuCommonInfo->MenuSwapItem(
                                item, &swap_info, 1, 1)]);
                            break;
                        case 1:
                        case 2:
                        case 9:
                            MenuSePlay(5);
                            break;
                        case 4:
                            CMenuInventPt->SetAskHowMuchItemNum(&swap_info, item);
                            MenuSePlay(1);
                            break;
                        default:
                            MenuSePlay(5);
                            break;
                    }
                }

                break;
            case K_COMMAND_GET_ITEM_ALL:
                MenuCommonInfo->GetItemAll(item, &swap_info);
                break;
            case K_COMMAND_TAKE_PHOTO:
                if (0 < CMenuInventPt->neta_select_num) {
                    MenuSePlay(5);
                } else {
                    if (CMenuInventPt->key_arg_no == INVENT_MODE_ALBUM_VIEW) {
                        USER_PICTURE_INFO *album_photo = InventAlbumPtr->GetAlbumPhotoInfo(0);
                        PictureSeiton(album_photo, (char *) InventAlbumPtr, 50);
                        InventAlbumPtr->RelateAlbumPicData();
                        AttachPictTex(CMenuInventPt->tex_block[4], CMenuInventPt->album_tex, album_photo,
                                      50);
                    } else {
                        USER_PICTURE_INFO *photo = InventUserDataPtr->GetPhotoInfo(0);
                        PictureSeiton(photo, InventUserDataPtr->GetPhototWorkAdr(), 30);
                        InventUserDataPtr->ResetAddress();
                        AttachPictTex(CMenuInventPt->tex_block[3], CMenuInventPt->photo_tex, photo,
                                      30);
                    }

                    MenuSePlay(1);
                }

                break;
            case K_COMMAND_UNUSED:
                break;
            case K_COMMAND_SET_CIRCLE: {
                int index = CMenuInventPt->photo_cursor;
                int source = 0;

                if (CMenuInventPt->key_arg_no == INVENT_MODE_MEMO_LIST) {
                    index = CMenuInventPt->memo_cursor;
                    source = 1;
                }

                if (CMenuInventPt->SetNetaCircle(source, index) <= 0) {
                    MenuSePlay(5);
                } else {
                    MenuSePlay(12);
                }

                break;
            }
            case K_COMMAND_CONFIRM_BOARD: {
                CMenuInventPt->mode = 13;

                while (CMenuInventPt->CancelNetaCircle(0) >= 0) {
                }

                InventInNetaEffectNum = 0;
                int i = 0;

                do {
                    CMenuInventPt->new_neta_photo[i] = 0;
                    USER_PICTURE_INFO *photo = InventUserDataPtr->GetPhotoInfo(i);

                    if (photo->used != 0) {
                        short neta = photo->neta_id;

                        if (neta > 0 && InventUserDataPtr->CheckNetaFlag(neta) < 0) {
                            CursorPos position;
                            CMenuInventPt->GetNetaBoardCursorPosition(i, &position.x);
                            float *effect = CMenuInventPt->neta_effect_pos[InventInNetaEffectNum];
                            effect[0] = (float) position.x;
                            effect[1] = (float) position.y;
                            CMenuInventPt->neta_effect_alpha[InventInNetaEffectNum] = 0x80;
                            CMenuInventPt->new_neta_photo[i] = 1;
                            InventInNetaEffectNum += 1;
                        }
                    }

                    i += 1;
                } while (i < 30);

                if (InventInNetaEffectNum <= 0) {
                    CMenuInventPt->ExeScript("\x83\x6c\x83\x5e\x8a\xf9\x93\x6f\x98\x5e");
                    CMenuInventPt->step = 10;
                } else {
                    CMenuInventPt->ExeScript("\x83\x6c\x83\x5e\x93\x6f\x98\x5e\x81\x48");
                    CMenuInventPt->step = 0;
                }

                break;
            }
            case K_COMMAND_LEAVE_CIRCLE:
                if (CMenuInventPt->CancelNetaCircle(5) < 0) {
                    if (CMenuInventPt->key_arg_no == INVENT_MODE_PHOTO_VIEW) {
                        leave = 1;
                    } else {
                        CMenuInventPt->InitNetaCircle(0);
                        CMenuInventPt->PrepareNextMode(next_mode);
                    }
                }

                MenuSePlay(5);
                break;
            case K_COMMAND_BACK_MODE:
                if (CMenuInventPt->CancelNetaCircle(5) < 0) {
                    CMenuInventPt->NextDifferentMode(next_mode, 0);
                } else {
                    MenuSePlay(5);
                }

                break;
            case K_COMMAND_SWAP_BACK: {
                MENU_SWAPITEM_INFO held_info;
                held_info.Set(-1, 0, -1, 0);
                memcpy(&held_info, &MenuCommonInfo->have_swap, 8);
                CGameDataUsed *source = GetGameDataUsedForSWAPINFO(&held_info);
                CGameDataUsed  source_copy;
                CGameDataUsed  held_copy;

                source_copy.CopyGameData(source);
                held_copy.CopyGameData((CGameDataUsed *) &MenuCommonInfo->have_item);
                int result = MenuCommonInfo->ReturnItemMenu(1);

                if (result == 0) {
                    leave = 1;
                    MenuSePlay(5);
                } else if (0 < result) {
                    MenuCommonInfo->SetHaveItemInfo(0, 1);
                    source->CopyGameData(&source_copy);
                    ((CGameDataUsed *) &MenuCommonInfo->have_item)->CopyGameData(&held_copy);
                    int moves[2][4];

                    if (ExchangeItemInfoMake(&held_info, moves, 1, 1) != 0) {
                        CommonSetMoveItemClass(moves);
                    }

                    MenuSePlay(menu_item_swap_sndtbl[result]);
                }

                break;
            }
            case K_COMMAND_RETURN_ITEM: {
                int result = MenuCommonInfo->ReturnItemMenu(0);

                if (result == 0) {
                    leave = 1;
                    MenuSePlay(5);
                } else if (0 < result) {
                    MenuSePlay(menu_item_swap_sndtbl[result]);
                }

                break;
            }
            case K_COMMAND_CHECK_IDEAS: {
                InventUserDataPtr->GetPhotoInfo(0);
                int ideas[3];
                int i = 0;

                do {
                    ideas[i] = CMenuInventPt->GetNowSelectNetaID(i);
                    i += 1;
                } while (i < 3);

                CMenuInventPt->create_item_id =
                    InventManagePt->CheckInventEnable(ideas, &CMenuInventPt->create_partial_match);
                InventManagePt->GetInventDataInfoByItemID(CMenuInventPt->create_item_id);
                CMenuInventPt->mode = 5;
                CMenuInventPt->create_load_state = -2;

                if (InventUserDataPtr->IsAlreadyCreatedItem(CMenuInventPt->create_item_id) >= 0) {
                    CMenuInventPt->step = 4;
                    CMenuInventPt->ExeScript("\x94\xad\x96\xbe\x8d\xcf\x82\xdd");
                    char *item_name[1] = {NULL};
                    item_name[0] = GetItemMessage(CMenuInventPt->create_item_id);
                    message->SetMsgItemNo(item_name, 1);
                } else {
                    CMenuInventPt->ExeScript("\x94\xad\x96\xbe\x82\xb7\x82\xe9\x81\x48");
                }

                break;
            }
            case K_COMMAND_PICK_CREATED: {
                int item_id = InventUserDataPtr->GetCreateItemID(CMenuInventPt->card_cursor);
                MenuSePlay(1);

                if (item_id <= 0) {
                    CMenuInventPt->PrepareNextMode(INVENT_MODE_THINK);
                } else {
                    CMenuInventPt->make_item_no = item_id;
                    CMenuInventPt->make_num = 1;
                    CMenuInventPt->make_material =
                        &InventManagePt->GetInventDataInfoByItemID(item_id)->materials;
                    CMenuInventPt->mode = 6;
                    CMenuInventPt->step = 0;
                    CMenuInventPt->make_cursor = 1;
                    CDataCommon *common = GetCommonItemData(CMenuInventPt->make_item_no);
                    CMenuInventPt->make_num_max = 1;

                    if (common != NULL) {
                        CMenuInventPt->make_num_max = common->max_num;
                    }

                    int owned = GetUserDataMan()->GetNumSameItem(item_id);
                    CMenuInventPt->make_num_max = CMenuInventPt->make_num_max - owned;

                    if (CMenuInventPt->make_num_max <= 0) {
                        CMenuInventPt->step = 3;
                        CMenuInventPt->ExeScript("\x8d\xc5\x91\xe5\x83\x60\x83\x46\x83\x62\x83\x4e");
                        char *item_name[1] = {NULL};
                        item_name[0] = GetItemMessage(CMenuInventPt->make_item_no);
                        MenuDCMsg[4]->SetMsgItemNo(item_name, 1);
                        MenuDCMsg[4]->SetMsgVolumeNoOne(common->max_num);
                    } else {
                        if (common->stack_num == 1) {
                            CMenuInventPt->make_num_max = 1;
                        }

                        char *names[5] = {NULL, NULL, NULL, NULL, NULL};
                        names[0] = GetItemMessage(CMenuInventPt->make_item_no);

                        for (int i = 0; i < CMenuInventPt->make_material->num; i++) {
                            names[1 + i] =
                                GetItemMessage(CMenuInventPt->make_material->material[i].item_id);
                        }

                        CMenuInventPt->ExeScript("\x8d\xec\x82\xe9\x81\x48");
                        message->SetMsgItemNo(names, 5);
                        message->StepMsg();
                        MenuCommonInfo->SetVibeR(0, 0);
                    }
                }

                break;
            }
            case K_COMMAND_EXTEND:
                CMenuInventPt->BootExtendCommand();
                break;
            case K_COMMAND_OPEN_MEMO:
                CMenuInventPt->ExeScript("\x83\x6c\x83\x5e\x92\x50\x8c\xea\x83\x8a\x83\x58\x83\x67");
                CMenuInventPt->UpdataNetaMemoStr();
                CMenuInventPt->key_arg_no = INVENT_MODE_MEMO_CORK;
                break;
            case K_COMMAND_CLOSE_MEMO:
                CMenuInventPt->ExeScript("\x83\x6c\x83\x5e\x92\x50\x8c\xea\x83\x8a\x83\x58\x83\x67OFF");
                CMenuInventPt->key_arg_no = INVENT_MODE_MEMO_BUTTON;
                break;
            case K_COMMAND_QUIT:
                CMenuInventPt->mode = 14;
                CMenuInventPt->step = 201;
                CMenuInventPt->album_save_mode = 1;
                CMenuInventPt->ExeScript("SAVE_SLOTSEL");
                MenuSePlay(5);
                break;
        }

        if (leave != 0) {
            CMenuInventPt->mode = 2;

            if (CMenuInventPt->photo_only == 1) {
                CMenuInventPt->ExeScript("\x8e\xca\x90\x5e\x83\x81\x83\x6a\x83\x85\x81\x5b\x8f\x49\x97\xb9");
                CActionChara *hidden[3] = {NULL, NULL, NULL};
                hidden[0] = MenuActionChara[0];
                hidden[1] = MenuActionChara[3];
                hidden[2] = CMenuInventPt->sub_chara;
                int i = 0;

                do {
                    CActionChara *model = hidden[i];

                    if (model != NULL) {
                        model->SetFadeFlag(1);
                        model->Show(0, 1);
                        model->fade_alpha = 0.2f;
                    }

                    i += 1;
                } while (i < 3);
            } else {
                CMenuInventPt->ExeScript("\x91\x4f\x8f\x49\x97\xb9\x8f\x88\x97\x9d");
                MenuMainFrameModeSet(7, 0);
                ReturnMenuIntern(0);
            }
        }
    }

    return 1;
}

int MenuInventKey() {
    int   result = 0;
    int   index;
    int   item_pos[16];
    char *names[MES_ITEM_MAX];
    int   number_pos[16];
    int   numbers[8];
    int   count_x;
    int   count_y;
    MenuCommonInfo->CheckSelectKey();
    int lr_key = MenuCommonInfo->CheckLRKey();
    int button = MenuCommonInfo->CheckPushButton();
    MenuCommonInfo->CheckKeyInput();
    switch (CMenuInventPt->mode) {
        case MENU_ASK_MODE_OPEN:
            if (ReadBGSync() == 0 && CMenuInventPt->opened == 0) {
                CMenuInventPt->InitEnd();
                CMenuInventPt->mode = MENU_ASK_MODE_NONE;
                CMenuInventPt->opened = 1;
                CMenuInventPt->unk_10 = 0x80;
            }
            break;
        case MENU_ASK_MODE_CLOSE:
            if ((CMenuInventPt->photo_only == 0 && GetMenuMainFrameEndFlag() != 0) ||
                (CMenuInventPt->photo_only == 1 && CalcMenuAdd(&CMenuInventPt->unk_10, -8, 0) != 0)) {
                CMenuInventPt->ExitEnd();
                result = 1;
                if (CMenuInventPt->photo_only == result) {
                    result = 2;
                }
            }
            break;
        case MENU_ASK_MODE_NONE:
            MenuMoveItemPtr->CheckMove();
            if (MenuMoveItemPtr->move_on != 0) {
                button = 0;
            }
            MenuInventPushKey(lr_key, button);
            break;
        case MENU_ASK_MODE_ALBUM_ACCESS:
            CMenuInventPt->IsAccessAlbum();
            break;
        case MENU_ASK_MODE_PHOTO_NETA:
            CMenuInventPt->PhotoNetaEnter(lr_key, button);
            break;
        default:
            CMenuInventPt->ExtendCommand(lr_key, button);
            break;
    }
    CMenuInventPt->LoadCharaCheck();
    if (CMenuInventPt->photo_only == 0) {
        int icon_mode = 2;
        if (CMenuInventPt->mode == MENU_ASK_MODE_CLOSE) {
            icon_mode = 0;
        }
        MenuPosData->StepMainMenuIconMove(GetCommonMenuModeID(), MENU_MODE_INVENT, icon_mode);
    }
    MenuPosData->FormStep();
    CMenuInventPt->CalcTex();
    CMenuInventPt->CalcCursorPosition();
    CDC2Mes *item_message = MenuDCMsg[0];
    CDC2Mes *list_message = MenuDCMsg[2];
    CDC2Mes *number_message = MenuDCMsg[3];
    switch (CMenuInventPt->key_arg_no) {
        case INVENT_MODE_THINK:
        case INVENT_MODE_THINK_ALBUM_BUTTON:
        case INVENT_MODE_THINK_WITH_ALBUM:
        case INVENT_MODE_ALBUM_VIEW:
        case INVENT_MODE_PHOTO_VIEW:
        case INVENT_MODE_PHOTO_ALBUM_BUTTON:
        case INVENT_MODE_MEMO_BUTTON:
        case INVENT_MODE_MEMO_LIST:
        case INVENT_MODE_MEMO_ARROW:
        case INVENT_MODE_MEMO_CORK: {
            USER_PICTURE_INFO *photo = InventUserDataPtr->GetPhotoInfo(CMenuInventPt->photo_cursor);
            if (photo != NULL) {
                CMenuInventPt->SelectedNetaPhotoAlready(CMenuInventPt->photo_cursor);
            }
            if (CMenuInventPt->neta_board_form != NULL) {
                CMenuInventPt->neta_board_form->GetPutPosXY("msgbrd", item_pos[0], item_pos[1]);
                item_pos[1] += 5;
            }
            MakeMsgNetaName(list_message, MenuMesForm[2], photo, item_pos, 1);
            CDC2Mes *name_message = MenuDCMsg[7];
            if (name_message != NULL) {
                short key = CMenuInventPt->key_arg_no;
                if (key == INVENT_MODE_THINK_WITH_ALBUM || key == INVENT_MODE_ALBUM_VIEW) {
                    if (CMenuInventPt->album_big_form != NULL && InventAlbumPtr != NULL) {
                        CMenuInventPt->album_big_form->GetPutPosXY("msgpos", item_pos[0], item_pos[1]);
                        item_pos[1] += 5;
                        MenuMesForm[7]->draw_flag = 1;
                        name_message->line_pos_on[0] = 0;
                        MakeMsgNetaName(name_message, MenuMesForm[7],
                                        InventAlbumPtr->GetAlbumPhotoInfo(CMenuInventPt->album_cursor), item_pos, 1);
                    }
                } else if (key != INVENT_MODE_PHOTO_VIEW && CMenuInventPt->unk_112 == 0 && CMenuInventPt->photo_only == 0) {
                    for (index = 0; index < 3; index++) {
                        CMenuPosDataForm *name_form = CMenuInventPt->neta_name_form[index];
                        if (name_form != NULL) {
                            name_form->GetPutPosXY("msg", item_pos[0], item_pos[1]);
                            name_message->SetMovePosGyou(index, item_pos[0], item_pos[1]);
                        }
                    }
                }
            }
            if (MenuMesForm[3] != NULL) {
                count_x = 370;
                count_y = 16;
                if (LanguageCode == LANG_ENGLISH) {
                    count_x = 336;
                    count_y = 14;
                }
                if (LanguageCode < LANG_FRENCH) {
                    MenuMesForm[3]->SetPos(count_x, count_y);
                } else {
                    MenuPosData->GetEtcTblValue("msg3q", count_x, count_y);
                }
                int message_no = 619;
                if (CMenuInventPt->neta_select_num < 3) {
                    number_message->SetMsgVolumeNoOne(3 - CMenuInventPt->neta_select_num);
                    message_no = 618;
                    MenuPosData->GetEtcTblValue("msg3p", count_x, count_y);
                }
                if (LanguageCode >= LANG_FRENCH) {
                    MenuMesForm[3]->SetPos(count_x, count_y);
                }
                number_message->MakeMsg(message_no);
            }
            break;
        }
        case INVENT_MODE_CARD_LIST:
        case INVENT_MODE_ITEM_LIST: {
            int tops[2] = {CMenuInventPt->card_top, CMenuInventPt->card_top - 1};
            int line = 0;
            int top = tops[CMenuInventPt->card_scroll_dir];
            InventUserDataPtr->GetHatsumeiNum();
            CMenuPosDataForm *list_form = CMenuInventPt->card_list_form;
            float             list_x = list_form->x;
            int               name_x = 74.0f + list_x;
            int               y = 13.0f + list_form->y + (float) (top * 46);
            int               number_x = 11.0f + list_x;
            index = top;
            for (; index < 0; index++) {
                names[line] = NULL;
                item_pos[line * 2] = name_x;
                item_pos[line * 2 + 1] = y;
                y += 46;
                line++;
            }
            int europe = CheckNowEurope();
            for (; line < 7; line++) {
                int card = top + line;
                int pos = line * 2;
                item_pos[pos] = name_x;
                item_pos[pos + 1] = y;
                number_pos[pos] = number_x;
                number_pos[pos + 1] = y + 2;
                int item = InventUserDataPtr->GetCreateItemID(card);
                names[line] = GetItemMessage(item);
                numbers[line] = card + 1;
                if (europe != 0) {
                    if (card + 1 < 10) {
                        number_pos[pos] -= 8;
                    } else if (card + 1 < 100) {
                        number_pos[pos] += 2;
                    } else {
                        number_pos[pos] += 12;
                    }
                }
                if (card == 0) {
                    names[line] = NewComer_5648[LanguageCode];
                } else if (item <= 0) {
                    names[line] = GetHatena();
                }
                y += 46;
            }
            list_message->SetMsgItemNo(names, 6);
            list_message->SetMsgItemPos(item_pos, 6);
            number_message->SetMsgVolumeNo(numbers, digit_tbl3_5641, 6);
            number_message->SetMsgItemPos(number_pos, 6);
            CGameDataUsed *item = CMenuInventPt->SearchNowPosItemExist();
            if (CMenuInventPt->key_arg_no == INVENT_MODE_CARD_LIST && InventUserDataPtr->GetCreateItemID(CMenuInventPt->card_cursor) <= 0) {
                item_message->MakeMsg(617);
            } else {
                item_message->MakeMsg(item);
            }
            break;
        }
    }
    return result;
}

void MenuInventDraw() {
    MenuPosData->FormDraw();
    MenuEffect[0]->Draw();
    MenuEffect[1]->Draw();

    if (menu_debug_flag != 0) {
        MenuInventDebugDraw();
    }
}

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", D_003532DF__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2913__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2244__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2245__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2247__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2248__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2249__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2250__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2251__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2252__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3113__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3114__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3115__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3116__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3117__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3118__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3119__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3120__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3121__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3122__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3123__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3124__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3125__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3126__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3127__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3128__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3129__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3130__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3131__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3132__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3133__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3134__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3135__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3138__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_4354__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_4355__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_4356__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_4357__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_4358__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_4359__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_4360__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_4361__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_4362__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_4363__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_4364__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_4365__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_4366__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_4367__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_4368__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_4369__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_4370__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_4371__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_4372__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_4373__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_4374__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_4375__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_4376__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_4377__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_4379__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_4380__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_5011__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_5012__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_5013__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_5014__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_5015__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_5016__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(at_3509, 0x8);
INCLUDE_BSS(at_3739, 0x8);
INCLUDE_BSS(at_3765, 0x8);

// Uninitialised data (.bss)
static mgCMemory MenuInventStack;
static mgCMemory MenuInventCharaStack;
static mgCMemory MenuInventMCStack;
static mgCMemory InventTeigiStack;
INCLUDE_BSS(at_2776, 0x18);
