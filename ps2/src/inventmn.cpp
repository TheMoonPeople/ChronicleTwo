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
#include "menudraw.hpp"
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
#include "pal_timing.hpp"
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

/**
 *
 * Row and column counts of the carried photo grid.
 *
 */
static int maxtbl_5171[2] = {
    15, 2};

/**
 *
 * Visible row and column counts of the carried photo grid.
 *
 */
static int viewnum_5172[2] = {
    3, 2};

/**
 *
 * Inventory mode reached when leaving each photo menu.
 *
 */
static short nextmodetbl_5183[12] = {
    INVENT_MODE_THINK_ALBUM_BUTTON, -1, -1, -1, INVENT_MODE_ALBUM_VIEW, -1,
    INVENT_MODE_PHOTO_ALBUM_BUTTON, -1, -1, -1, -1, INVENT_MODE_THINK};

/**
 *
 * Icon prefixes used by the invention memo list.
 *
 */
static char *gaiji_table_4737[3] = {
    "[bulb2]",
    "[bulb3]",
    "[heart]"};

/**
 *
 * Row and column counts of the album photo grid.
 *
 */
static int maxtbl_album_5223[2] = {
    25, 2};

/**
 *
 * Visible row and column counts of the album photo grid.
 *
 */
static int viewnum_album_5224[2] = {
    5, 2};

/**
 *
 * What each direction does at the album grid's edge, as MenuGlidKeyCheck takes it.
 *
 */
static int overcode_album_5225[4] = {
    MENU_CURSOR_LIMIT_CLAMP, MENU_CURSOR_LIMIT_CLAMP, MENU_CURSOR_LIMIT_EXIT, MENU_CURSOR_LIMIT_CLAMP};

/**
 *
 * Colours used by the two invention success strips.
 *
 */
static u8 invent_color_tbl[3][2][4] = {
    {{0, 0, 0, 0},       {0, 0, 255, 128}    },
    {{240, 140, 80, 80}, {255, 255, 0, 128}  },
    {{0, 0, 0, 0},       {128, 128, 128, 128}}
};

/**
 *
 * Form names for the two invention grade effect rows.
 *
 */
static char *invent_grade_fff[2] = {
    "f0",
    "f1"};

static mgCMemory         MenuInventStack;

/**
 *
 * Cursor frame type for each inventory menu mode.
 *
 */
static s8 wakutype_3203[12] = {
    0, -1, -1, 0, 0, 0, 0, -1, 0, -1, -1, 0};

/**
 *
 * Holds two item names for the inventory display.
 *
 */
struct ItemNameList2 {
    char *name[2]; /**< Item name in each slot. */
};

static mgCMemory     MenuInventCharaStack;
static mgCMemory     MenuInventMCStack;
static ItemNameList2 at_3739;
static ItemNameList2 at_3765;

/**
 *
 * Step of the photo command window, as the extended question's ask_mode holds it.
 *
 */
enum INVENT_ASK_MODE {
    INVENT_ASK_COMMAND       = 0, /**< Choosing a command from the photo command window. */
    INVENT_ASK_ZOOM          = 1, /**< Showing the photo enlarged. */
    INVENT_ASK_DELETE        = 2, /**< Asking whether to delete the photo. */
    INVENT_ASK_TO_ALBUM      = 3, /**< Asking whether to move the photo into the album. */
    INVENT_ASK_DELETE_UNUSED = 4, /**< Asking whether to delete every photo that shows no idea. */
    INVENT_ASK_SET_BOARD     = 5, /**< Placing the photo's idea on the idea board. */
    INVENT_ASK_FROM_ALBUM    = 6, /**< Asking whether to move the album photo to the carried photos. */
    INVENT_ASK_DELETE_ALL    = 7  /**< Asking whether to delete every photo. */
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
    "New Invention"};

/**
 *
 * Decimal widths used to display the invention count.
 *
 */
static int digit_tbl3_5641[8] = {
    3, 3, 3, 3, 3, 3, 3, 3};

/**
 *
 * Message numbers of the photo commands' names.
 *
 */
enum INVENT_COMMAND_MSG {
    INVENT_CMD_ZOOM          = 0x1518, /**< Zoom. */
    INVENT_CMD_DELETE        = 0x1519, /**< Delete the photo. */
    INVENT_CMD_TO_ALBUM      = 0x151A, /**< Move the photo into the album. */
    INVENT_CMD_FROM_ALBUM    = 0x151B, /**< Move the album photo to the carried photos. */
    INVENT_CMD_DELETE_UNUSED = 0x151C, /**< Delete every photo that shows no idea. */
    INVENT_CMD_SET_BOARD     = 0x151D, /**< Place the photo's idea on the idea board. */
    INVENT_CMD_DELETE_ALL    = 0x151E  /**< Delete every photo. */
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

static int  MenuInventDebugKey();
static void MenuInventDebugDraw();
static int  CheckPhotoFlag();

/**
 *
 * Icon prefixes used by invention idea names.
 *
 */
static char *addstringtable_1722[3] = {
    "[bulb2]",
    "[bulb3]",
    "[heart]"};

static mgCMemory InventTeigiStack;

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
 * Key the next PictureSeiton call sorts the photos by, an INVENT_PHOTO_SORT.
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
static BG_READ_INFO *InventSubDataReadBGInfo;

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
static u_long128 pic_name_text_buff_1660[0x248];

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
    INVENT_ASK_ZOOM, INVENT_ASK_DELETE, INVENT_ASK_TO_ALBUM, INVENT_ASK_FROM_ALBUM, INVENT_ASK_DELETE_UNUSED, INVENT_ASK_SET_BOARD, INVENT_ASK_DELETE_ALL};

/**
 *
 * Defines each scoop and the event flag that reveals it.
 *
 */
static SCOOP_DATA scoop_table[INVENT_SCOOP_TABLE_NUM] = {
    {1000, 300, 1 },
    {1001, 300, 2 },
    {1002, 300, 3 },
    {1003, 300, 4 },
    {1004, 300, 5 },
    {1005, 500, 6 },
    {1006, 100, 7 },
    {1007, 201, 8 },
    {1009, 300, 9 },
    {1010, 300, 10},
    {1011, 201, 11},
    {1012, 201, 12},
    {1013, 54,  13},
    {1014, 54,  14},
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
    {2005, 54,  31},
    {2006, 402, 32},
    {2007, 408, 33},
    {2008, 54,  34},
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
    {1, 5, {INVENT_CMD_SET_BOARD, INVENT_CMD_ZOOM, INVENT_CMD_DELETE, INVENT_CMD_DELETE_UNUSED, INVENT_CMD_DELETE_ALL} },
    {0, 5, {INVENT_CMD_ZOOM, INVENT_CMD_DELETE, INVENT_CMD_FROM_ALBUM, INVENT_CMD_DELETE_UNUSED, INVENT_CMD_DELETE_ALL}},
    {0, 0, {INVENT_CMD_ZOOM, 0, 0, -1, -1}                                                                             },
    {0, 0, {INVENT_CMD_ZOOM, 0, 0, -1, -1}                                                                             },
    {1, 5, {INVENT_CMD_ZOOM, INVENT_CMD_DELETE, INVENT_CMD_TO_ALBUM, INVENT_CMD_DELETE_UNUSED, INVENT_CMD_DELETE_ALL}  },
    {1, 5, {INVENT_CMD_ZOOM, INVENT_CMD_DELETE, INVENT_CMD_FROM_ALBUM, INVENT_CMD_DELETE_UNUSED, INVENT_CMD_DELETE_ALL}},
    {1, 4, {INVENT_CMD_ZOOM, INVENT_CMD_DELETE, INVENT_CMD_DELETE_UNUSED, INVENT_CMD_DELETE_ALL, -1}                   },
    {0, 5, {INVENT_CMD_ZOOM, INVENT_CMD_DELETE, INVENT_CMD_FROM_ALBUM, INVENT_CMD_DELETE_UNUSED, INVENT_CMD_DELETE_ALL}},
};

/**
 *
 * Byte lengths of the proposed Japanese invention name endings.
 *
 */
static u8 jp_conv_lentbl_2835[12] = {
    2, 2, 2, 4, 4, 8, 6, 4, 6, 14, 10, 6};

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
        photo->is_new = false;
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
    dst->is_new = src->is_new;
    dst->map_no = src->map_no;
    dst->npc_no = src->npc_no;
    dst->unk_8 = src->unk_8;
    dst->monster_no = src->monster_no;
    dst->neta_id = src->neta_id;
}

void PictureSeiton(USER_PICTURE_INFO *photos, char *work_base, int count) {
    char               work_tmp[0x2000];
    USER_PICTURE_INFO  info_tmp;
    int                i;
    int                j;
    USER_PICTURE_INFO *first;
    USER_PICTURE_INFO *second;
    int                swap;
    short              key_a;
    short              key_b;

    if (photos == NULL) {
        return;
    }

    for (i = 0; i < count; i++) {
        first = &photos[i];

        for (j = i + 1; j < count; j++) {
            second = &photos[j];

            if (second->used == 0) {
                continue;
            }

            swap = false;

            if (pict_seiton_case == INVENT_PHOTO_SORT_NETA) {
                if (first->used == 0 && second->used == 1) {
                    swap = true;
                }

                key_a = first->neta_id;

                if (key_a < 0 && 0 < second->neta_id) {
                    swap = true;
                }

                if (0 < key_a) {
                    key_b = second->neta_id;

                    if (0 < key_b && key_b < key_a) {
                        swap = true;
                    }
                }
            }

            if (pict_seiton_case == INVENT_PHOTO_SORT_MAP) {
                if (first->used == 0 && second->used == 1) {
                    swap = true;
                }

                key_a = first->map_no;

                if (key_a < 0 && 0 <= second->map_no) {
                    swap = true;
                }

                if (0 <= key_a) {
                    key_b = second->map_no;

                    if (0 <= key_b && key_b < key_a) {
                        swap = true;
                    }
                }
            }

            if (pict_seiton_case == INVENT_PHOTO_SORT_NPC) {
                if (first->used == 0 && second->used == 1) {
                    swap = true;
                }

                key_a = first->npc_no;

                if (key_a < 0 && 0 <= second->npc_no) {
                    swap = true;
                }

                if (0 <= key_a) {
                    key_b = second->npc_no;

                    if (0 <= key_b && key_b < key_a) {
                        swap = true;
                    }
                }
            }

            if (pict_seiton_case == INVENT_PHOTO_SORT_MONSTER) {
                if (first->used == 0 && second->used == 1) {
                    swap = true;
                }

                key_a = first->monster_no;

                if (key_a < 0 && 0 <= second->monster_no) {
                    swap = true;
                }

                if (0 <= key_a) {
                    key_b = second->monster_no;

                    if (0 <= key_b && key_b < key_a) {
                        swap = true;
                    }
                }
            }

            if (swap != 0) {
                memcpy(work_tmp, first->image, 0x2000);
                memcpy(first->image, second->image, 0x2000);
                memcpy(second->image, work_tmp, 0x2000);
                memcpy(&info_tmp, first, sizeof(USER_PICTURE_INFO));
                memcpy(first, second, sizeof(USER_PICTURE_INFO));
                memcpy(second, &info_tmp, sizeof(USER_PICTURE_INFO));
                first->image = work_base + i * 0x2000;
                second->image = work_base + j * 0x2000;
            }

            if (swap != 0) {
                i = -1;
                break;
            }
        }
    }

    pict_seiton_case++;

    if (pict_seiton_case >= INVENT_PHOTO_SORT_NUM) {
        pict_seiton_case = INVENT_PHOTO_SORT_NETA;
    }
}

void AttachPictTex(int block, mgCTexture **textures, USER_PICTURE_INFO *info, int count) {
    mgCTextureManager *manager = &mgTexManager;
    char               name[0x20];
    int                base = 0;
    int                i;

    if (count == INVENT_ALBUM_PHOTO_NUM) {
        base = INVENT_ALBUM_PHOTO_NUM;
    }

    for (i = 0; i < count; i++) {
        sprintf(name, "neta%d", i + base);
        manager->DeleteTexture(name, block);
        manager->EnterTexture(block, name, NULL, 64, 64, 0x10, 0, 0, 0);
        textures[i] = manager->GetTexture(name, -1);

        if (textures[i] != NULL) {
            textures[i]->image[0] = (u_long128 *) info[i].image;
        }
    }
}

int CheckPhotoDataNoNeed(USER_PICTURE_INFO *photos, int count, int *unneeded) {
    int unneeded_count;
    int i;

    if (photos == NULL) {
        return 0;
    }

    unneeded_count = 0;
    i = 0;

    if (0 < count) {
        do {
            if (photos->neta_id <= 0 && unneeded != NULL) {
                unneeded[unneeded_count] = i;
                unneeded_count++;
            }

            i++;
            photos++;
        } while (i < count);
    }

    return unneeded_count;
}

int IsTakePhoto() {
    CUserDataManager *user = GetUserDataMan();

    if (user != NULL && user->active_chr_no == USER_CHARA_MAX && user->SearchEquip(USER_CHARA_MAX, ITEM_ID_CAMERA) != 0) {
        return true;
    }

    return false;
}

void CDC2AlbumData::Initialize() {
    memset(this, 0, sizeof(*this));
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
    } while (i < INVENT_ALBUM_PHOTO_NUM);
}

void CDC2AlbumData::DeletePhotoData(int index) {
    if (index < 0 || index >= INVENT_ALBUM_PHOTO_NUM) {
        return;
    }

    Init_USER_PICTURE_INFO(this->GetAlbumPhotoInfo(index));
}

USER_PICTURE_INFO *CDC2AlbumData::GetAlbumPhotoInfo(int slot) {
    if (slot < 0 || slot >= INVENT_ALBUM_PHOTO_NUM) {
        return NULL;
    }

    return &photo[slot];
}

void CInventUserData::Initialize() {
    int i;
    shutter_num = 0;
    level = 0;
    memset(neta_id, 0, sizeof(neta_id));
    memset(photo_work, 0, sizeof(photo_work));

    for (i = 0; i < 30; i++) {
        Init_USER_PICTURE_INFO(&photo[i]);
    }

    for (i = 0; i < 0x100; i++) {
        created_item[i].item_id = 0;
        created_item[i].unk_2 = 0;
    }

    ResetAddress();
}

void CInventUserData::ResetAddress() {
    for (int index = 0; index < 30; index++) {
        photo[index].image = reinterpret_cast<char (*)[0x2000]>(photo_work)[index];
    }
}

void CInventUserData::PhotoCheckEnd() {
    int i;

    for (i = 0; i < 30; i++) {
        photo[i].is_new = false;
    }
}

USER_PICTURE_INFO *CInventUserData::GetPhotoInfo(int slot) {
    if (slot < 0 || slot >= 30) {
        return NULL;
    }

    return &photo[slot];
}

char *CInventUserData::GetPhototWorkAdr() {
    return (char *) &photo_work[0][0];
}

USER_PICTURE_INFO *CInventUserData::IsPhotoSpace(int *slot) {
    int i;

    for (i = 0; i < 30; i++) {
        if (photo[i].used == 0) {
            photo[i].image = (char *) &photo_work[i][0];

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

        if (0 < subject && subject < INVENT_NETA_ID_SCOOP) {
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

        if (subject >= INVENT_NETA_ID_SCOOP && subject < INVENT_NETA_ID_SCOOP_END) {
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
            if (subject < INVENT_NETA_ID_SCOOP) {
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

/**
 *
 * Invention card record of the older save layout that TranslateInventUserData converts.
 *
 */
struct INVENT_CREATED_ITEM_OLD {
    short   item_id; /**< Item the invention produced, or 0 or less for an empty slot. */
    u_short unk_2;
    u8      unk_4[8];
};

STATIC_ASSERT(sizeof(INVENT_CREATED_ITEM_OLD) == 0xC);
PORT_RECORD_ASSERT(sizeof(INVENT_CREATED_ITEM_OLD) == 0xC);

void TranslateInventUserData(CInventUserData *old_data, CInventUserData *new_data) {
    INVENT_CREATED_ITEM_OLD *from;
    INVENT_CREATED_ITEM     *to;
    int                      i;

    if (old_data == NULL || new_data == NULL) {
        return;
    }

    from = (INVENT_CREATED_ITEM_OLD *) old_data->created_item;
    to = new_data->created_item;

    for (i = 0; i < 128; i++) {
        to->item_id = from->item_id;
        to->unk_2 = from->unk_2;
        from++;
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
    } while (i < INVENT_SCOOP_TABLE_NUM);

    return NULL;
}

SCOOP_DATA *GetScoopDataTableIndex(int index) {
    if (index < 0 || index >= INVENT_SCOOP_TABLE_NUM) {
        return NULL;
    }

    return &scoop_table[index];
}

void InitScoopString() {
    int i;

    for (i = 0; i < INVENT_SCOOP_TABLE_NUM; i++) {
        scoop_table[i].text = NULL;
        scoop_table[i].unk_c = 0;
        scoop_table[i].unk_10 = 0;
    }
}

/**
 *
 * Stores the text of a scoop, read by the STR tag of the scoop text file.
 *
 */
static int _SCOOP_STR(SPI_STACK *stack, int arg_count) {
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
    {NULL,  NULL      }
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
            info = GetScoopInfo(entry->scoop_id);

            if (info != NULL && CheckBitFlagMenu(entry->flag_no) != 0 && info->known == 0) {
                SetViewFlag(entry->scoop_id, true);
                count += 1;
            }
        }

        index += 1;
    } while (index < INVENT_SCOOP_TABLE_NUM);

    return count;
}

int CScoopDataManager::CheckScoop() {
    CInventUserData   *user;
    int                obtained_count;
    int                i;
    USER_PICTURE_INFO *photo;
    SCOOP_INFO        *info;
    int                neta_id;

    user = GetInventUserDataPtr();
    obtained_count = 0;

    if (user == NULL) {
        return 0;
    }

    for (i = 0; i < 30; i++) {
        photo = user->GetPhotoInfo(i);

        if (photo != NULL && photo->used != 0) {
            info = GetScoopInfo(photo->neta_id);

            if (info != NULL && info->obtained == 0) {
                obtained_count++;
                info->obtained = true;
            }
        }
    }

    for (i = 0; i < 0x200; i++) {
        neta_id = user->GetNetaID(i);

        if (neta_id >= INVENT_NETA_ID_SCOOP) {
            info = GetScoopInfo(neta_id);

            if (info != NULL && info->obtained == 0) {
                obtained_count++;
                info->obtained = true;
            }
        }
    }

    CheckPhotoFlag();
    return obtained_count;
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
        *total = INVENT_SCOOP_TABLE_NUM;
    }

    return count;
}

/**
 *
 * Reserves the picture name records, read by the PIC_INFO tag.
 *
 */
static int _PIC_INFO(SPI_STACK *stack, int arg_count) {
    unsigned int size;
    unsigned int blocks;
    pic_name_info_num = spiGetStackInt(stack);
    size = pic_name_info_num * sizeof(PIC_NAME_INFO);

    if (size & 0xF) {
        blocks = (size >> 4) + 1;
    } else {
        blocks = size >> 4;
    }

    pic_name_info_top =
        (PIC_NAME_INFO *) operator new[](pic_name_info_num * sizeof(PIC_NAME_INFO), PicNameStack->Alloc(blocks + 2));
    pic_name_info_num_count = 0;
    return 1;
}

/**
 *
 * Stores one idea's picture name, read by the PIC_NAME tag.
 *
 */
static int _PIC_NAME(SPI_STACK *stack, int arg_count) {
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

        if (LanguageCode >= LANG_FRENCH && LanguageCode >= LANG_SPANISH) {
            ConvertFontCode(name, text);
        } else {
            strcpy(text, name);
        }

        entry->name = mgCopyString(text, PicNameStack);
        entry->sort_key = spiGetStackInt(arg);
        pic_name_info_num_count++;

        if (entry->neta_id == INVENT_NETA_ID_DUMMY) {
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
    {NULL,       NULL     }
};

void LoadFilePictureName() {
    mgCMemory    stack;
    char         align_buffer[0x5000];
    char        *buffer;
    unsigned int size;
    stack.stSetBuffer(pic_name_text_buff_1660, 0x248);
    PicNameStack = &stack;
    buffer = (char *) MenuCalcBufAlignment((u_long128 *) align_buffer);
    size = LoadFileMenu("neta2.lst", (u_long128 *) buffer, MENU_FILE_LOAD_DIRECT);
    CScriptInterpreter interpreter;
    interpreter.SetTag(pic_tag);
    interpreter.SetScript(buffer, size);
    interpreter.Run();
}

char *GetPhotoName(USER_PICTURE_INFO *info) {
    int   i;
    short neta_id;

    if (info == NULL) {
        return NULL;
    }

    if (info->used == 0) {
        return NULL;
    }

    neta_id = info->neta_id;

    if (neta_id > 0) {
        for (i = 0; i < pic_name_info_num; i++) {
            if (neta_id == pic_name_info_top[i].neta_id) {
                return pic_name_info_top[i].name;
            }
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
    info.used = true;
    info.neta_id = neta_id;
    name = GetPhotoName(&info);

    if (name == NULL) {
        return true;
    }

    strcpy(dest, name);
    return false;
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

            if (neta_id >= INVENT_NETA_ID_SCOOP) {
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

/**
 *
 * Learns the ideas of the carried photos that show new ones, returning non-zero when any was learnt.
 *
 */
static int CheckPhotoFlag() {
    int                added = 0;
    CInventUserData   *user = GetInventUserDataPtr();
    USER_PICTURE_INFO *photos = user->GetPhotoInfo(0);
    int                i = 0;
    int                offset = 0;

    do {
        USER_PICTURE_INFO *info = (USER_PICTURE_INFO *) ((u8 *) photos + offset);

        if (info->used != 0) {
            short *neta_id = &info->neta_id;

            if (0 < *neta_id && user->CheckNetaFlag(*neta_id) < 0) {
                user->SetNetaFlag(*neta_id);
                added = true;
            }
        }

        i++;
        offset += sizeof(USER_PICTURE_INFO);
    } while (i < INVENT_PHOTO_NUM);

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
    int               recipe_neta[3];
    int               i;
    INVENT_DATA_INFO *entry;
    short            *recipe_ids;
    int               match_count;
    int               j;
    int               k;
    int               slot;
    GetInventUserDataPtr();

    for (i = 0; i < num; i++) {
        entry = &table[i];
        recipe_ids = &entry->neta_id[0];

        if (recipe_ids != NULL) {
            u8 found[3] = {0, 0, 0};

            for (j = 0; j < 3; j++) {
                recipe_neta[j] = recipe_ids[j];

                for (k = 0; k < 3; k++) {
                    if (recipe_neta[j] == ids[k]) {
                        found[j] = true;
                    }
                }
            }

            match_count = 0;

            for (slot = 0; slot < 3; slot++) {
                if (found[slot] != 0) {
                    match_count++;
                    recipe_neta[slot] = 0;
                }
            }

            if (combined != NULL && match_count >= 2) {
                *combined = true;
            }

            if (found[0] != 0 && found[1] != 0 && found[2] != 0) {
                return entry->item_id;
            }
        }
    }

    return -1;
}

int CInventDataManage::HowMuchZairyouMakeItem(int item_id, int count, int *needs) {
    INVENT_DATA_INFO     *recipe;
    INVENT_MATERIAL_LIST *materials;
    int                   i;
    MakeItemNeeds        *make_needs;

    if (needs == NULL) {
        return false;
    }

    recipe = GetInventDataInfoByItemID(item_id);

    if (recipe == NULL) {
        return false;
    }

    materials = &recipe->materials;
    i = 0;
    make_needs = reinterpret_cast<MakeItemNeeds *>(needs);
    make_needs->num = recipe->materials.num;

    while (i < materials->num) {
        make_needs->need[i].item_id = materials->material[i].item_id;
        make_needs->need[i].amount = count * materials->material[i].num;
        i++;
    }

    if (i < 4) {
        do {
            make_needs->need[i].item_id = 0;
            make_needs->need[i].amount = 0;
            i++;
        } while (i < 4);
    }

    return true;
}

int CInventDataManage::DeleteUserUsedItem(int item_id, int count) {
    INVENT_DATA_INFO     *recipe;
    INVENT_MATERIAL_LIST *materials;
    int                   i;
    INVENT_MATERIAL      *material;

    recipe = GetInventDataInfoByItemID(item_id);
    materials = &recipe->materials;

    if (recipe == NULL) {
        return false;
    }

    i = 0;

    while (i < materials->num) {
        material = &materials->material[i];

        if (material == NULL) {
            break;
        }

        GetUserDataMan()->DeleteItem(material->item_id, material->num * count);
        i++;
    }

    return true;
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

/**
 *
 * Reserves the invention recipe table, read by the DATATABLESET tag.
 *
 */
static int _INVENT_DATATABLESET(SPI_STACK *stack, int arg_count) {
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

/**
 *
 * Stores one invention recipe, read by the DATASET tag.
 *
 */
static int _INVENT_DATASET(SPI_STACK *stack, int arg_count) {
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
    materials->num = (arg_count - 9) / 2;

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
    {"DATASET",      _INVENT_DATASET     },
    {NULL,           NULL                }
};

int CInventDataManage::LoadAnalyzeInventFile(char *script, int size) {
    if (script == NULL) {
        return false;
    }

    InventManagePt = this;
    InventTeigiStack.stack_used = 0;
    InventTeigiStack.lock = 0;
    CScriptInterpreter interpreter;
    interpreter.SetTag(invent_teigi_func);
    interpreter.SetScript(script, size);
    interpreter.Run();
    return true;
}

int CheckInventItem(int item_id) {
    CInventDataManage manage;
    int               file_size;
    char              align_buffer[0x7800];
    char              teigi_buffer[0x4000];
    char             *buffer;
    INVENT_DATA_INFO *recipe;
    short            *recipe_neta;
    int               i;

    manage.Clear();
    buffer = (char *) MenuCalcBufAlignment((u_long128 *) align_buffer);
    LoadFile2("menu/inv6.lst", buffer, &file_size, 0);
    InventTeigiStack.stSetBuffer((u_long128 *) teigi_buffer, 0x400);
    manage.LoadAnalyzeInventFile(buffer, file_size);
    InventUserDataPtr = GetInventUserDataPtr();
    recipe = manage.GetInventDataInfoByItemID(item_id);

    if (recipe == NULL) {
        return false;
    }

    recipe_neta = recipe->neta_id;
    s8 found[3] = {0, 0, 0};

    for (i = 0; i < 30; i++) {
        USER_PICTURE_INFO *photo = InventUserDataPtr->GetPhotoInfo(i);

        if (photo->used != 0) {
            short photo_neta = photo->neta_id;

            if (photo_neta > 0) {
                if (recipe_neta[0] == photo_neta) {
                    found[0] = true;
                }

                if (recipe_neta[1] == photo_neta) {
                    found[1] = true;
                }

                if (recipe_neta[2] == photo_neta) {
                    found[2] = true;
                }
            }
        }
    }

    for (i = 0; i < 0x200; i++) {
        int memo_neta = InventUserDataPtr->GetNetaID(i);

        if (recipe_neta[0] == memo_neta) {
            found[0] = true;
        }

        if (recipe_neta[1] == memo_neta) {
            found[1] = true;
        }

        if (recipe_neta[2] == memo_neta) {
            found[2] = true;
        }
    }

    if (found[0] != 0 && found[1] != 0 && found[2] != 0) {
        return true;
    }

    return false;
}

int CheckItemTable(int item_id, int *neta_ids) {
    CInventDataManage manage;
    int               file_size;
    char              align_buffer[0x7800];
    char              teigi_buffer[0x4000];
    char             *buffer;
    INVENT_DATA_INFO *recipe;

    manage.Clear();
    buffer = (char *) MenuCalcBufAlignment((u_long128 *) align_buffer);

    if (LoadFile2("menu/inv6.lst", buffer, &file_size, 0) != 0) {
        InventTeigiStack.stSetBuffer((u_long128 *) teigi_buffer, 0x400);
        manage.LoadAnalyzeInventFile(buffer, file_size);
        recipe = manage.GetInventDataInfoByItemID(item_id);

        if (recipe == NULL) {
            return 0;
        }

        neta_ids[0] = recipe->neta_id[0];
        neta_ids[1] = recipe->neta_id[1];
        neta_ids[2] = recipe->neta_id[2];
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
            if (kind == INVENT_PHOTO_CHECK_NETA) {
                value = info->neta_id;

                if (0 < value && value == id) {
                    count++;
                }
            } else if (kind == INVENT_PHOTO_CHECK_NPC) {
                value = info->npc_no;

                if (0 < value && value == id) {
                    count++;
                }
            } else if (kind == INVENT_PHOTO_CHECK_MONSTER) {
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

    for (i = 0; i < INVENT_ALBUM_PHOTO_NUM; i++) {
        if (source == 0) {
            album_flag[i] = -1;
        }

        if (InventAlbumPtr != NULL && source == 1) {
            USER_PICTURE_INFO *photo = InventAlbumPtr->GetAlbumPhotoInfo(i);

            if (photo == NULL) {
                album_flag[i] = -1;
            }

            if (photo != NULL && photo->used == 0) {
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
    } while (i < INVENT_ALBUM_PHOTO_NUM);

    return count;
}

void CMenuInvent::AttachFormInfo() {
    bg_form = MenuPosData->GetFormInfo("inv_bg");
    itembrd_form = MenuPosData->GetFormInfo("itembrd");
    neta_board_form = MenuPosData->GetFormInfo("\x83\x6c\x83\x5e\x94\xc2");
    neta_board_bar[0] = NULL;
    neta_board_bar[1] = NULL;
    neta_board_bar[2] = NULL;
    neta_board_arrow = NULL;
    neta_memo_arrow = NULL;

    if (neta_board_form != NULL) {
        neta_board_form->SetNumber("maxnum", INVENT_PHOTO_NUM);
        neta_board_bar[0] = neta_board_form->GetPartInfo("bar0");
        neta_board_bar[1] = neta_board_form->GetPartInfo("bar1");
        neta_board_bar[2] = neta_board_form->GetPartInfo("bar2");
        neta_board_arrow = neta_board_form->GetPartInfo("\x81\xaa");
        neta_memo_arrow = neta_board_form->GetPartInfo("\x83\x6c\x83\x5e\x92\xa0\x96\xee\x88\xf3\x8a\xee\x96\x7b");
    }

    neta_memo_form = MenuPosData->GetFormInfo("\x83\x6c\x83\x5e\x92\xa0");
    photo_scroll_reset = true;
    makebrd_form = MenuPosData->GetFormInfo("makebrd");
    card_scroll_reset = true;
    card_list_title_form = MenuPosData->GetFormInfo("\x83\x4a\x81\x5b\x83\x68\x83\x8a\x83\x58\x83\x67");
    card_list_form = MenuPosData->GetFormInfo("cardlist");
    album_sw_form = MenuPosData->GetFormInfo("Album_sw");

    if (album_sw_form != NULL) {
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

    if (poly_chr_form[0] != NULL) {
        poly_chr_form[0]->SetActionCharaPtr(NULL, -1, -1);
    }

    invent_okeff_form = MenuPosData->GetFormInfo("invent_okeff");
    dload_form = MenuPosData->GetFormInfo("DLOAD");
    kakudai_pic_form = MenuPosData->GetFormInfo("kakudai_pic");
    kakudai_pic = NULL;

    if (kakudai_pic_form != NULL) {
        kakudai_pic = kakudai_pic_form->GetPartInfo("pic");
    }

    AttachMessageForm();
}

/**
 *
 * Rounds a byte count up to a number of 16-byte allocation blocks.
 *
 */
static inline u_int align16_blocks(u_int size) {
    if (size & 0xF) {
        return (size >> 4) + 1;
    }

    return size >> 4;
}

/**
 *
 * Calculates 16-byte stack blocks for an object with two reserve blocks.
 *
 */
static inline int StackBlocks(int bytes) {
    return (bytes + 15) / 16 + 2;
}

void CMenuInvent::LoadCharaCheck() {
    CActionChara *chara = MenuActionChara[0];
    mgCMemory    *load_stack = &MenuCharaLoadStack;
    int           size;

    switch (chara_load_step) {
        case INVENT_CHARA_LOAD_OFF:
            break;
        case INVENT_CHARA_LOAD_START:
            if (poly_chr_form[0] != NULL) {
                poly_chr_form[0]->SetActionCharaPtr(NULL, tex_block[1], -1);
            }

            MenuLoadInfo.mode = MENU_LOAD_MODE_INVENT;
            MenuLoadInfo.load_all = true;
            MenuLoadInfo.chara_no = 0;
            MenuLoadInfo.update_scene = false;
            SetMenuLoadItemNo(0);
            size = MenuItemCharaDataLoad(load_stack, 0, MenuCharaBuild2, 0);
            chara_load_step = INVENT_CHARA_LOAD_WAIT;
            sub_chara = NULL;

            if (photo_only == 1) {
                LoadFileBG("menu/chara4/camera.pac", load_stack->stGetTop(), &size);
                load_stack->Alloc(align16_blocks(size));
                chara_read_info = GetReadBGInfo("menu/chara4/camera.pac");
            }

            break;
        case INVENT_CHARA_LOAD_WAIT:
            if (ReadBGSync() != 0) {
                break;
            }

            MenuItemCharaDataLoadEndCheck(MenuCharaBuild2, NULL, MenuActionChara, 0, tex_block[1], -1);
            chara->ResetParent();

            if (MenuActionChara[3] != NULL && MenuUserParam.chara[0]->equip[2].item_no > 0) {
                chara->SetRef(MenuActionChara[3], "hat");
                chara->CopyOutLine(MenuActionChara[3]);
            }

            if (chara->CObjectFrame::frame != NULL) {
                mgCFrame     *frame = chara->CObjectFrame::frame;
                mgCFrameAttr *attr = frame->attr;
                attr->no_light = true;
                frame->SetAttrParam(*attr, 1, MG_FRAME_ATTR_NO_LIGHT | MG_FRAME_ATTR_COLOR);
            }

            chara->SetMotion("\x97\xa7\x82\xbf", 0, 1);

            if (chara_read_info != NULL) {
                BG_READ_INFO            *read_info = chara_read_info;
                u_int                   *model_file = GetPackFile((u_int *) read_info->buffer, "c01_camera.chr", &size);
                mgCTextureManager *const tex_manager = &mgTexManager;
                chara_stack.stack_used = 0;
                chara_stack.lock = 0;
                strcpy(tex_manager->name_suffix, "_mn");

                if (model_file != NULL) {
                    chara->LoadPack(model_file, "info.cfg", &chara_stack, &chara_stack, &chara_stack, tex_block[1], NULL);
                }

                u_int *sub_file = GetPackFile((u_int *) read_info->buffer, "camera.chr", &size);
                sub_chara = new (chara_stack.Alloc(StackBlocks(sizeof(CActionChara)))) CActionChara;
                sub_chara->Initialize(0);
                sub_chara->LoadPack(sub_file, "info.cfg", &chara_stack, &chara_stack, &chara_stack, tex_block[1], chara);
                tex_manager->name_suffix[0] = '\0';
                chara->SetRef(sub_chara, "ef00");
                chara->CopyOutLine(sub_chara);
                chara->SetMotion("\x83\x4a\x83\x81\x83\x89\x97\xa7\x82\xbf", 0, 1);
            }

            if (album_enable == 0 && photo_only == 1) {
                chara->SetPosition(15.0f, -29.0f, 14.0f);
            } else {
                chara->SetPosition(20.0f, -29.0f, 14.0f);
            }

            chara->SetRotation(0.0f, -0.56f, 0.0f);
            chara->Step();
            ExeScript("\x8d\x6c\x82\xa6\x83\x82\x81\x5b\x83\x68"
                      "0");
            chara_load_step = INVENT_CHARA_LOAD_READY;
            poly_chr_form[0]->SetActionCharaPtr(chara, tex_block[1], -1);
            unk_642 = 0;
            unk_648 = -PI / 5.0f;
            unk_640 = 0;
            break;
        case INVENT_CHARA_LOAD_READY:
            chara->Step();
            break;
    }
}

USER_PICTURE_INFO *CMenuInvent::GetNowSelectedPictInfo() {
    USER_PICTURE_INFO *info = NULL;

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
            if (slot_count != NULL) {
                *slot_count = INVENT_PHOTO_NUM;
            }

            return InventUserDataPtr->GetPhotoInfo(0);
        case INVENT_MODE_ALBUM_VIEW:
            if (slot_count != NULL) {
                *slot_count = INVENT_ALBUM_PHOTO_NUM;
            }

            return InventAlbumPtr->GetAlbumPhotoInfo(0);
    }

    return NULL;
}

void CMenuInvent::InitNetaCircle(int show) {
    int i = 0;

    do {
        if (show == 0) {
            CancelNetaCircle(0);
            neta_select_state[i] = INVENT_NETA_SLOT_EMPTY;

            neta_select_index[i] = -1;
            neta_flash[i] = false;
        }

        CMenuPosDataForm **panel = &neta_form[i];

        if (*panel != NULL) {
            (*panel)->SetRGBACalcParam(3, 0x7F, 0x80);

            if (show == 0) {
                (*panel)->draw_flag = false;
            } else {
                (*panel)->draw_flag = true;
                CMenuPosDataForm *label = neta_name_form[i];

                if (label != NULL) {
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
        return false;
    }

    name = NULL;

    if (type == INVENT_NETA_SOURCE_PHOTO) {
        if (SelectedNetaPhotoAlready(index) != 0) {
            return false;
        }

        USER_PICTURE_INFO *photo = InventUserDataPtr->GetPhotoInfo(index);

        if (photo == NULL) {
            return false;
        }

        if (*(s8 *) &photo->used == 0) {
            return false;
        }

        photo->is_new = false;
        name = GetPhotoName(photo);
        neta_select_type[neta_select_num] = INVENT_NETA_SOURCE_PHOTO;
        neta_select_index[neta_select_num] = index;
    } else if (type == INVENT_NETA_SOURCE_MEMO) {
        if (SelectedNetaMemoListAlready(index) != 0) {
            return false;
        }

        USER_PICTURE_INFO memo;
        memo.used = true;
        memo.neta_id = NetaMemoID[index];
        neta_select_type[neta_select_num] = INVENT_NETA_SOURCE_MEMO;
        neta_select_index[neta_select_num] = index;
        name = GetPhotoName(&memo);
    }

    neta_select_state[neta_select_num] = INVENT_NETA_SLOT_PLACED;
    form = neta_form[neta_select_num];

    if (form != NULL) {
        form->draw_flag = true;
        form->rgba[0] = 0x80;
        form->rgba[1] = 0x80;
        form->rgba[2] = 0x80;
        form->rgba[3] = 0x80;

        for (int i = 0; i < 4; i++) {
            form->SetRGBACalcParam(i, 0, 0x80);
        }

        form->SetRGBACalcParam(3, 8, 0x80);
        MENUFORMPARTS_TYPE *ring = form->GetPartInfo("neta");
        ring->draw_flag = true;

        if (neta_select_type[neta_select_num] == INVENT_NETA_SOURCE_PHOTO) {
            GetNetaBoardCursorPosition(index, pos);
            form->SetPos(pos[0], pos[1]);
            ring->etc_info[0] = index;
            ring->picture_scale = 0.7f;
        }

        if (neta_select_type[neta_select_num] == INVENT_NETA_SOURCE_MEMO) {
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
            ring->etc_info[0] = INVENT_PICTURE_MEMO;
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
    return true;
}

int CMenuInvent::CancelNetaCircle(int mode) {
    int removed_idea = -1;

    if (neta_select_num <= 0) {
        return removed_idea;
    }

    neta_select_num = neta_select_num - 1;
    short       last = neta_select_num;
    signed char kind = neta_select_type[last];

    if (kind == INVENT_NETA_SOURCE_PHOTO) {
        removed_idea = neta_select_index[last];
    }

    if (kind == INVENT_NETA_SOURCE_MEMO) {
        removed_idea = neta_select_index[last];
    }

    neta_select_state[last] = INVENT_NETA_SLOT_RETURNING;
    CMenuPosDataForm *label = neta_name_form[neta_select_num];

    if (label != NULL) {
        label->SetAction("\x8a\x4f\x82\xd6");
    }

    if (neta_select_num <= 0) {
        if (MenuActionChara[0] != NULL) {
            MenuActionChara[0]->SetMotion("\x97\xa7\x82\xbf", 0, 1);
        }

        if (mode == 0) {
            ExeScript("\x8d\x6c\x82\xa6\x83\x82\x81\x5b\x83\x68"
                      "0");
        }

        if (mode == 5) {
            ExeScript("\x8d\x6c\x82\xa6\x83\x82\x81\x5b\x83\x68"
                      "5");
        }
    }

    return removed_idea;
}

int CMenuInvent::GetNowSelectNetaID(int slot) {
    if (slot < 0 || slot > 2) {
        return 0;
    }

    signed char kind = neta_select_type[slot];

    if (kind == INVENT_NETA_SOURCE_PHOTO) {
        USER_PICTURE_INFO *photos = InventUserDataPtr->GetPhotoInfo(0);
        int                photo_slot = neta_select_index[slot];
        USER_PICTURE_INFO *photo = photos + photo_slot;
        return photo->neta_id;
    }

    if (kind == INVENT_NETA_SOURCE_MEMO) {
        return NetaMemoID[neta_select_index[slot]];
    }

    return 0;
}

int CMenuInvent::SelectedNetaPhotoAlready(int neta_id) {
    int i = 0;

    do {
        if (neta_select_type[i] == INVENT_NETA_SOURCE_PHOTO && neta_select_index[i] == neta_id) {
            return true;
        }

        i++;
    } while (i < 3);

    return false;
}

int CMenuInvent::SelectedNetaMemoListAlready(int neta_id) {
    int i;

    if (NetaMemoID[neta_id] == 0) {
        return true;
    }

    i = 0;

    do {
        if (neta_select_type[i] == INVENT_NETA_SOURCE_MEMO && neta_id == neta_select_index[i]) {
            return true;
        }

        i++;
    } while (i < 3);

    return false;
}

void CMenuInvent::UpdataRecordBoard() {
    CDC2Mes *mes = MenuDCMsg[7];
    int      values[5];
    int      i;
    int      j;

    mes->value_half = false;

    if (CheckNowEurope() != 0) {
        mes->value_half = true;
    }

    for (i = 0; i < 10; i++) {
        rec_board_offset_xtbl[i] = 0;
    }

    mes->value_zero = true;
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

    if (ask_form != NULL) {
        ask_form->draw_flag = true;
    }

    neta_form[0]->parts->etc_info[0] = -1;
    neta_form[1]->parts->etc_info[0] = -1;
    neta_form[2]->parts->etc_info[0] = -1;
    MenuPosData->InitDrawList();
    ExeScript("\x8d\x6c\x82\xa6\x83\x82\x81\x5b\x83\x68"
              "0");
    ExeScript("\x83\x74\x83\x48\x81\x5b\x83\x80\x8f\x89\x8a\xfa\x89\xbb");

    switch (key_arg_no) {
        case INVENT_MODE_THINK:
            ExeScript("MSG\x8d\x6c\x8e\x40\x83\x82\x81\x5b\x83\x68");
            ExeScript("NextToThink");

            if (LanguageCode > LANG_JAPANESE) {
                MenuDCMsg[7]->font_w = 0xE;
            }

            break;
        case INVENT_MODE_CARD_LIST:
            ExeScript("MSG\x94\xad\x96\xbe\x90\xbb\x8d\xec\x83\x82\x81\x5b\x83\x68");
            CreateModeSwapForm(0);
            ExeScript("NextToCardList");
            MenuDCMsg[2]->font_w = 0xD;
            MenuDCMsg[3]->value_space = -7;

            if (MenuDCMsg[3] != NULL) {
                MenuDCMsg[3]->value_half = false;

                if (CheckNowEurope() != 0) {
                    MenuDCMsg[3]->value_space = 1;
                    MenuDCMsg[3]->value_half = true;
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
    CGameDataUsed *item = NULL;

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
        case INVENT_GRADATION_OFF: {
            int               j;
            CMenuPosDataForm *form = invent_okeff_form;

            if (form != NULL) {
                j = 0;
                form->rgba[0] = 0x80;
                form->rgba[1] = 0x80;
                form->rgba[2] = 0x80;
                form->rgba[3] = 0;

                do {
                    form->SetRGBACalcParam(j, 0, 0x80);
                    j++;
                } while (j < 4);

                int grade = 0;

                do {
                    MENUFORMPARTS_TYPE *part = invent_okeff_form->GetPartInfo(invent_grade_fff[grade]);
                    i++;

                    part->y = 224.0f;
                    grade++;
                    part->h = 0.0f;
                } while (i < 2);
            }

            gradation_mode = INVENT_GRADATION_OFF;
            return;
        }
        case INVENT_GRADATION_GROW: {
            int               j;
            CMenuPosDataForm *form = invent_okeff_form;

            if (form != NULL) {
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

            gradation_mode = INVENT_GRADATION_GROW;
            gradation_height = 0;
            return;
        }
        case INVENT_GRADATION_ON: {
            CMenuPosDataForm *form = invent_okeff_form;

            if (form != NULL) {
                form->rgba[0] = 0x80;
                form->rgba[1] = 0x80;
                form->rgba[2] = 0x80;
                form->rgba[3] = 0x80;

                do {
                    form->SetRGBACalcParam(i, 0, 0x80);
                    i++;
                } while (i < 4);
            }

            gradation_mode = INVENT_GRADATION_ON;
            return;
        }
        case INVENT_GRADATION_COLOR:
            gradation_mode = INVENT_GRADATION_COLOR;
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
    int                 steps[3] = {30, 60, 90};

    switch (gradation_mode) {
        case INVENT_GRADATION_GROW: {
            int grown = false;

            for (i = 0; i < 2; i++) {
                part = invent_okeff_form->GetPartInfo(invent_grade_fff[i]);

                if (steps[2] >= gradation_height) {
                    part->h = gradation_height;

                    if (i % 2 == 0) {
                        part->y = 224.0f - part->h;
                    }

                    grown = true;
                }
            }

            if (grown) {
                gradation_height += 4;
            }

            break;
        }
        case INVENT_GRADATION_COLOR:
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
                        u_int target = invent_color_tbl[create_success][row][k];

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

    read_info = InventSubDataReadBGInfo;
    album_enable = true;

    if (GetUserDataMan()->GetNumSameItem(ITEM_ID_PHOTO_ALBUM) <= 0) {
        album_enable = false;
    }

    if (photo_only == 1) {
        EnterDataMenu((u8 *) read_info->buffer);
        ExeScript("\x8d\x6c\x82\xa6\x83\x82\x81\x5b\x83\x68"
                  "0");
        ExeScript("\x8e\xca\x90\x5e\x8a\x6d\x94\x46\x83\x82\x81\x5b\x83\x68\x8f\x89\x8a\xfa\x89\xbb");
        PrepareNextMode(key_arg_no);
    }

    cursor_snap = true;
    ExeScript("INIT_END");
    MenuItemBrdCalcManner = MENU_ITEM_BRD_CALC_EASE;
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
    u_int             *file = GetPackFile((unsigned int *) pack, "inv_bg.img", NULL);

    if (file != NULL) {
        int image_block = this->tex_block[3];

        if (file != NULL) {
            tex_manager->EnterIMGFile((u8 *) file, image_block, NULL, NULL);
            Tex_Hatsumei = tex_manager->GetTexture("inv0", -1);
        }

        file = GetPackFile((unsigned int *) pack, "edmenu.img", NULL);

        if (file != NULL) {
            tex_manager->EnterIMGFile((u8 *) file, MenuCommonInfo->tex_block[1], NULL, NULL);
            MenuPosData->AttachCommonTexInfo();
        }

        int size = 0;
        MenuDataAnalyze((char *) GetPackFile((unsigned int *) pack, "invent.cfg", &size), size, &data_stack);
        MenuInventStack.Align64();

        icon_data[0].data = GetPackFile((u_int *) pack, icon_data[0].name, &icon_data[0].size);
        icon_data[1].data = GetPackFile((u_int *) pack, icon_data[1].name, &icon_data[1].size);
        icon_data[2].data = GetPackFile((u_int *) pack, icon_data[2].name, &icon_data[2].size);
        AttachPictTex(tex_block[3], photo_tex, InventUserDataPtr->GetPhotoInfo(0), INVENT_PHOTO_NUM);
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
        MenuSePlay(para->se_no);
        signed char result = para->menu_cmd;

        switch (result) {
            case 0:
            case 1: {
                SetPreCmdTrush(this, 5, ask_para.item, MenuMesForm[5]);

                if (MenuCommonInfo->cursor_form != NULL) {
                    MenuCommonInfo->cursor_form->draw_flag = false;
                }
            }
        }
    }

    return 1;
}

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
    "Ummm"};

/**
 *
 * Question endings appended to a proposed Japanese invention name.
 *
 */
static char *gobitbl_2847[2] = {
    "\x82\xa9\x82\xe0\x81\x48",
    "\x82\xa9\x82\xc8\x81\x48"};

/**
 *
 * Item model assets selected for invention outcomes.
 *
 */
static char *getfilename_2928[2] = {
    "inv_ng.mds",
    "inv_ok.mds"};

/**
 *
 * Sound banks selected for invention outcomes.
 *
 */
static char *sndfileName_2951[2] = {
    "snd2/sp/SP_008.snd",
    "snd2/sp/SP_009.snd"};

/**
 *
 * Wave names used during the invention sound sequence.
 *
 */
static char *wavname_2960[3] = {
    "200",
    "190",
    "180"};

/**
 *
 * Sound-bank time limits of the two invention stages.
 *
 */
static short sndtimetbl_2868[2] = {
    210, 280};

/**
 *
 * Lighting colour used for the invented item model.
 *
 */
static float eff_light_2927[4] = {255.0f, 255.0f, 255.0f, 128.0f};

int CMenuInvent::IsCreateObject(int mode, int keys) {
    CActionChara      *action_chara = MenuActionChara[0];
    CDC2Mes           *message_window = MenuDCMsg[4];
    mgCMemory         *load_stack = &MenuCharaLoadStack;
    mgCTextureManager *texture_manager = &mgTexManager;
    s16                state = this->step;

    switch (state) {
        case INVENT_CREATE_STEP_ASK: {
            s32 answer = -1;

            if (state <= 0) {
                answer = message_window->YesNoCursor();
            }

            switch (keys) {
                case MENU_PUSH_BUTTON_DECIDE:
                    if (answer == 0) {
                        this->key_arg_no = INVENT_MODE_THINK;
                        this->create_chara = NULL;
                        this->create_success = false;

                        if (0 < this->create_item_id) {
                            this->create_success = true;
                            InventUserDataPtr->SetCreateItemFlag(this->card_cursor, this->create_item_id);
                        } else {
                            s32 recipe_index;
                            this->create_partial_match = false;
                            InventUserDataPtr->GetPhotoInfo(0);
                            recipe_index = 0;

                            while (InventManagePt->num != 0) {
                                INVENT_DATA_INFO  *recipe;
                                CInventDataManage *table = InventManagePt;

                                if (recipe_index < 0 || table->num <= recipe_index) {
                                    recipe = NULL;
                                } else {
                                    recipe = &table->table[recipe_index];
                                }

                                if (recipe == NULL) {
                                    break;
                                }

                                if (!(0 < InventUserDataPtr->IsAlreadyCreatedItem(recipe->item_id))) {
                                    s32 matched = 0;
                                    s32 index;
                                    s32 need;
                                    int found[3] = {false, false, false};

                                    for (index = 0; index < 3; index++) {
                                        need = recipe->neta_id[index];
                                        s32 slot;
                                        this->create_photo_neta[index] = need;

                                        for (slot = 0; slot < 3; slot++) {
                                            s32 id = this->GetNowSelectNetaID(slot);

                                            if (id == need) {
                                                this->create_photo_neta[index] = 0;
                                                found[slot] = true;
                                                matched++;
                                                break;
                                            }
                                        }
                                    }

                                    if (matched == 2) {
                                        s32 slot_index;
                                        this->create_partial_match = true;

                                        for (slot_index = 0; slot_index < 3; slot_index++) {
                                            if (found[slot_index] == 0) {
                                                this->create_missing_slot = slot_index;
                                            }
                                        }

                                        break;
                                    }
                                }

                                recipe_index++;
                            }
                        }

                        this->create_wait_time = 0x7C;
                        this->ExeScript("\x94\xad\x96\xbe\x8d\x6c\x82\xa6\x8a\x4a\x8e\x6e");
                        this->GradationSet(INVENT_GRADATION_GROW);
                        this->step = INVENT_CREATE_STEP_WAIT_START;
                        load_stack->stack_used = 0;
                        load_stack->lock = 0;
                        StartReadBG();
                        s32 sound_message_size;
                        LoadFileBG("snd2/sp/SP_003.snd", load_stack->stGetTop(), &sound_message_size);
                        this->create_load_state = INVENT_CREATE_LOAD_SOUND_MSG;
                        break;
                    }
                case MENU_PUSH_BUTTON_CANCEL:
                    this->ExeScript("\x94\xad\x96\xbe\x82\xe2\x82\xdf");
                    this->mode = MENU_ASK_MODE_NONE;
                    break;
            }

            break;
        }
        case INVENT_CREATE_STEP_WAIT_START:
            this->create_wait_time--;

            if (this->create_wait_time <= 0 && this->create_load_state > INVENT_CREATE_LOAD_MODEL_DONE) {
                this->step++;
            }

            break;
        case INVENT_CREATE_STEP_SHOW_READY:
            action_chara->GetNowMotionName();
            s32 motion; motion = action_chara->seq_state;

            if (this->create_load_state >= INVENT_CREATE_LOAD_JINGLE_OPEN && motion == 3) {
                this->step++;
                action_chara->seq_advance = true;
                action_chara->SetMotion("\x8c\x8b\x89\xca", 4, 1);
                this->jingle_state = true;
                this->jingle_pending = true;
                this->jingle_time = 0;
                this->poly_chr_form[1]->SetActionCharaPtr(this->create_chara, this->tex_block[2], -1);
                this->GradationSet(INVENT_GRADATION_COLOR);
                MenuCommonInfo->MenuPosPlay();
                this->create_spin_angle = 0.0f;
                this->create_wobble_phase = 0.0f;
                this->create_show_phase = 0;
                this->create_scale_in = 0.0f;

                if (this->create_success != 0) {
                    this->ExeScript("\x94\xad\x96\xbe\x90\xac\x8c\xf7");

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
                    this->ExeScript("\x94\xad\x96\xbe\x90\xc9\x82\xb5\x82\xa2");

                    for (index = 0; index < 3; index++) {
                        if (this->create_photo_neta[index] > 0) {
                            USER_PICTURE_INFO info;
                            char             *name;
                            s32               length;
                            info.neta_id = this->create_photo_neta[index];
                            info.used = true;
                            name = GetPhotoName(&info);

                            if (name != NULL) {
                                strcpy(this->create_photo_name, name);
                            } else {
                                strcpy(this->create_photo_name, Tb_2819[LanguageCode]);
                            }

                            length = strlen(this->create_photo_name);

                            if (length > 2) {
                                s32 half_length = length >> 1;

                                if (LanguageCode == LANG_JAPANESE) {
                                    s8 cut = jp_conv_lentbl_2835[half_length - 1];
                                    this->create_photo_name[cut] = -0x7F;
                                    this->create_photo_name[cut + 1] = -0x66;
                                } else if (LanguageCode > LANG_JAPANESE) {
                                    s32 character_index = length / 4;

                                    if (character_index <= 0) {
                                        character_index = 1;
                                    }

                                    for (; character_index < length; character_index++) {
                                        this->create_photo_name[character_index] = '.';
                                    }
                                }
                            } else if (name != NULL) {
                                sprintf(this->create_photo_name, "\x82\xe0\x82\xb5\x82\xa9\x82\xb5\x82\xbd\x82\xe7%s%s", name, gobitbl_2847[GetRandI(2)]);
                            } else {
                                strcpy(this->create_photo_name, "\x82\xa4\x81\x5b\x82\xf1");
                            }

                            break;
                        }
                    }

                    this->neta_circle_snap = true;
                } else {
                    this->ExeScript("\x94\xad\x96\xbe\x8e\xb8\x94\x73");
                }

                MenuSePlay(0, this->create_sound_buffer, &MenuSoundBuffer);
            }

            break;
        case INVENT_CREATE_STEP_SHOW: {
            if (this->create_success != 0) {
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
                            CalcMenuAdd(&this->create_wobble_amp, -0.02f, 0.0f);
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
                    AddRotationCharaY(this->create_chara, 0.01308997f);
                    this->create_chara->Step();
                }
            }

            switch (this->jingle_state) {
                case 0:
                    break;
                case 1:
                    if (this->jingle_pending != 0) {
                        s16 jingle_length = sndtimetbl_2868[this->create_success];

                        if (this->jingle_time > jingle_length / 2) {
                            this->jingle_pending = false;
                            this->ExeScript("MSG_WARNING");

                            if (this->create_success != 0) {
                                char *message = GetItemMessage(this->create_item_id);

                                if (message != NULL) {
                                    strcpy(message_window->name[0], message);
                                }

                                message_window->MakeMsg(INVENT_CREATE_MSG_CREATED);
                            } else if (this->create_partial_match != 0) {
                                char *name;
                                message_window->MakeMsg(INVENT_CREATE_MSG_PARTIAL_MATCH);
                                name = this->create_photo_name;

                                if (name != NULL) {
                                    strcpy(message_window->name[0], name);
                                }
                            } else {
                                message_window->MakeMsg(INVENT_CREATE_MSG_NOTHING);
                            }
                        }
                    }

                    this->jingle_time++;

                    if (this->jingle_time > sndtimetbl_2868[this->create_success]) {
                        MenuCommonInfo->FadeInMenuBGMVol(6);
                        this->jingle_state = false;
                    }

                    break;
            }

            if (this->create_partial_match != 0) {
                u32 color;
                this->blink_time++;

                if (this->blink_time >= PAL_TIMING(0x32, 0x3c)) {
                    this->blink_time = 0;
                }

                color = 0x80303030;

                if (this->blink_time >= PAL_TIMING(0x19, 0x1e)) {
                    color = 0x8022227F;
                }

                CDC2Mes *color_window = MenuDCMsg[7];

                if (this->create_missing_slot >= 0 && this->create_missing_slot < 0x14) {
                    color_window->line_color[this->create_missing_slot] = color;
                }
            }

            if (this->jingle_state == 0 && ((keys & MENU_PUSH_BUTTON_DECIDE) || (keys & MENU_PUSH_BUTTON_CANCEL))) {
                s32 cursor[2];
                this->step = INVENT_CREATE_STEP_ASK;
                this->mode = MENU_ASK_MODE_NONE;

                if (this->create_load_state == INVENT_CREATE_LOAD_JINGLE_OPEN || this->create_load_state == INVENT_CREATE_LOAD_JINGLE_PLAY) {
                    CSnd.StreamClose(1);
                    this->create_load_state = INVENT_CREATE_LOAD_STOPPED;
                }

                action_chara->DeleteExtMotion();
                MenuCommonInfo->FadeInMenuBGMVol(6);
                this->create_effect = NULL;

                if (this->create_success != 0 ||
                    ((s16) this->create_success == 0 && this->create_partial_match == 0)) {
                    this->InitNetaCircle(0);
                } else {
                    this->InitNetaCircle(1);
                }

                this->ExeScript("\x94\xad\x96\xbe\x8c\xe3\x8f\x88\x97\x9d");
                this->create_success = false;
                CDC2Mes *color_window = MenuDCMsg[7];

                if (this->create_missing_slot >= 0 && this->create_missing_slot < 0x14) {
                    color_window->line_color[this->create_missing_slot] = 0x80686A6B;
                }

                this->GradationSet(INVENT_GRADATION_OFF);
                this->poly_chr_form[1]->SetActionCharaPtr(NULL, this->tex_block[2], -1);
                this->GetNetaBoardCursorPosition(this->photo_cursor, cursor);
                MenuCommonInfo->MenuSetPos(cursor[0], cursor[1]);
            }

            break;
        }
        case INVENT_CREATE_STEP_AFTER:
            if (keys != 0) {
                this->ExeScript("\x94\xad\x96\xbe\x82\xe2\x82\xdf");
                this->step = INVENT_CREATE_STEP_ASK;
                this->mode = MENU_ASK_MODE_NONE;
            }

            break;
        default:
            this->step = INVENT_CREATE_STEP_ASK;
            this->mode = MENU_ASK_MODE_NONE;
            break;
    }

    s32 read_done = ReadBGSync();

    switch (this->create_load_state) {
        case INVENT_CREATE_LOAD_STOPPED:
            break;
        case INVENT_CREATE_LOAD_SOUND_MSG:
            if (read_done == 0) {
                BG_READ_INFO *file = GetReadBGFile(0);

                if (file != NULL) {
                    MenuSePlay(0, (u32 *) file->buffer, &MenuSoundBuffer);
                    MenuCommonInfo->FadeOutMenuBGMVol(-3, 0x18);
                }

                this->create_load_state = INVENT_CREATE_LOAD_MODEL;
            }

            break;
        case INVENT_CREATE_LOAD_MODEL: {
            s32 model_blocks;
            s32 motion_size;
            action_chara->SetMotion("\x94\xad\x96\xbe\x8d\x6c\x82\xa6\x92\x86", 0, 1);
            load_stack->stack_used = 0;
            load_stack->lock = 0;
            load_stack->Align64();
            char path[64] = "menu/chara4/";
            model_blocks = 0x1020;

            if (this->create_success != 0) {
                strcat(path, "c01_success.chr");
            } else {
                if (this->create_partial_match != 0) {
                    strcat(path, "c01_regret.chr");
                } else {
                    strcat(path, "c01_failure.chr");
                }

                model_blocks = 0x2000;
            }

            this->chara_stack.stSetBuffer(load_stack->stGetTop(), model_blocks);
            load_stack->Alloc(align16_blocks(model_blocks * sizeof(u_long128)));
            this->create_model_file = (u8 *) load_stack->stGetTop();
            StartReadBG();
            LoadFileBG(path, (u_long128 *) this->create_model_file, &motion_size);
            this->create_motion_file = this->create_model_file + motion_size / 16 * 16;
            LoadFileBG("menu/inventsub.pac", (u_long128 *) this->create_motion_file, &motion_size);
            this->create_load_state = INVENT_CREATE_LOAD_MODEL_DONE;
            break;
        }
        case INVENT_CREATE_LOAD_MODEL_DONE:
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
                strcpy(texture_manager->name_suffix, "_menu");
                action_chara->LoadPack((unsigned int *) this->create_model_file, "info.cfg", &this->chara_stack,
                                       &this->chara_stack, &this->chara_stack, this->tex_block[1], NULL);
                texture_manager->name_suffix[0] = '\0';
                action_chara->SetPosition(pos);
                action_chara->SetRotation(rot);

                if (this->create_success != 0) {
                    texture_manager->TexAnimeOn(this->tex_block[1], "\x96\xda\x83\x70\x83\x60");
                    texture_manager->TexAnimeOn(this->tex_block[1], "\x82\xed\x82\xe7\x82\xa2\x8c\xfb\x82\xa0\x82\xaf");
                } else {
                    texture_manager->TexAnimeOn(this->tex_block[1], "\x82\xad\x82\xe2\x82\xb5\x96\xda\x83\x70\x83\x60");
                    texture_manager->TexAnimeOn(this->tex_block[1], "\x82\xad\x82\xe2\x82\xb5\x8a\xe7");
                }

                pack_bg = GetReadBGFile(1);
                pack_file = NULL;

                if (pack_bg != NULL) {
                    pack_file = (MDS_HEADER *) GetPackFile((u32 *) pack_bg->buffer, getfilename_2928[this->create_success], NULL);
                }

                this->create_effect = new (load_stack->Alloc(StackBlocks(sizeof(CActionChara)))) CActionChara;
                this->create_effect->Initialize(0);
                frame = mgLoadMDSFile(pack_file, load_stack, NULL, NULL);
                this->create_effect->CObjectFrame::frame = frame;

                if (frame != NULL) {
                    mgCFrameAttr *attr = frame->attr;
                    attr->no_light = true;
                    attr->color[0] = eff_light_2927[0];
                    attr->color[1] = eff_light_2927[1];
                    attr->color[2] = eff_light_2927[2];
                    attr->color[3] = eff_light_2927[3];
                    this->create_effect->SetPosition(18.0f, -20.0f, 20.0f);
                    this->create_effect->SetRotation(0.0f, 0.15707964f, 0.0f);
                    frame->SetAttrParam(*attr, 1, MG_FRAME_ATTR_NO_LIGHT | MG_FRAME_ATTR_COLOR);
                }

                form = MenuPosData->GetFormInfo("thinkin_ef1");

                if (form != NULL) {
                    form->SetActionCharaPtr(this->create_effect, -1, -1);
                    form->counter = 0;
                    form->ambient[0] = -1.0f;
                }

                this->create_load_state = INVENT_CREATE_LOAD_SOUND_BANK;
                load_stack->Align64();
                this->create_timer = PAL_TIMING(100, 120);

                if (this->create_success != 0) {
                    u8   *item_file;
                    char *item_path;
                    s32   item_size;
                    this->create_timer = PAL_TIMING(200, 240);
                    this->create_chara = new (load_stack->Alloc(StackBlocks(sizeof(CActionChara)))) CActionChara;
                    this->create_chara->Initialize(0);
                    this->item_model_memory.stSetBuffer(load_stack->stGetTop(), 0x35C0);
                    this->item_model_memory.stack_used = 0;
                    this->item_model_memory.lock = 0;
                    load_stack->Alloc(0x35C0);
                    load_stack->Align64();
                    item_file = (u8 *) load_stack->stGetTop();
                    item_path = GetItemFilePath(this->create_item_id, 1);

                    if (item_path != NULL) {
                        if (*item_path != '\0') {
                            StartReadBG();
                            LoadFileBG(item_path, (u_long128 *) item_file, &item_size);
                        }
                    }

                    this->create_load_state = INVENT_CREATE_LOAD_ITEM_MODEL;
                }
            }

            break;
        case INVENT_CREATE_LOAD_ITEM_MODEL:
            if (read_done == 0) {
                BG_READ_INFO *item_bg = GetReadBGFile(0);

                if (item_bg != NULL && this->create_chara != NULL) {
                    texture_manager->DeleteBlock(this->tex_block[2]);
                    strcpy(texture_manager->name_suffix, "_i");
                    this->create_chara->Initialize(0);
                    this->create_chara->LoadPack((unsigned int *) item_bg->buffer, "info.cfg", &this->item_model_memory,
                                                 &this->item_model_memory, &this->item_model_memory, this->tex_block[2], NULL);
                    texture_manager->name_suffix[0] = '\0';
                }

                this->create_load_state++;
            }

            break;
        case INVENT_CREATE_LOAD_SOUND_BANK: {
            s32 sound_size;
            load_stack->Align64();
            StartReadBG();
            this->create_sound_buffer = (u32 *) load_stack->stGetTop();
            LoadFileBG(sndfileName_2951[this->create_success], (u_long128 *) this->create_sound_buffer, &sound_size);
            load_stack->Alloc(align16_blocks(sound_size));
            this->create_load_state++;
            break;
        }
        case INVENT_CREATE_LOAD_SOUND_PORT:
            if (read_done == 0) {
                sndInitPort(SND_PORT_MENU);
                this->create_load_state++;
            }

            break;
        case INVENT_CREATE_LOAD_JINGLE_OPEN:
            this->create_timer--;

            if (this->create_timer == 0x28) {
                s32  wave = this->create_success;
                char wave_name[0x88];

                if (wave == 1) {
                    wave = GetRandI(2) + 1;
                }

                sprintf(wave_name, "8500%s.wav", wavname_2960[wave]);
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
        case INVENT_CREATE_LOAD_JINGLE_PLAY:
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

void CMenuInvent::CalcMakeBrd(int message_index) {
    if (makebrd_form != NULL && makebrd_form->draw_flag) {
        make_board.make_num = make_num;
        make_board.material_num = 4;
        MakeItemNeeds needs;
        InventManagePt->HowMuchZairyouMakeItem(make_item_no, make_num, &needs.num);
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

            make_board.line[index].num = needs.need[index].amount;
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
    if (mode == MENU_ASK_MODE_CLOSE) {
        MenuCommonInfo->SetWakuType(-1);
        return;
    }

    if (mode == MENU_ASK_MODE_OPEN) {
        MenuCommonInfo->SetWakuType(-1);
    }

    int       cursor[4] = {10, 10, 0, 0};
    char      text[0x28];
    CursorPos offset = {0, 0};
    CursorPos waku;
    CursorPos command_pos;
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

            if (mode == MENU_ASK_MODE_MAKE) {
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

    if (mode == MENU_ASK_MODE_ITEM_COMMAND || (mode == MENU_ASK_MODE_EXTEND && step == 0)) {
        SetItemCmdMsgPos(&command_pos.x);
    }

    if (mode == MENU_ASK_MODE_CREATE || mode == MENU_ASK_MODE_ITEM_COMMAND || mode == MENU_ASK_MODE_EXTEND || mode == MENU_ASK_MODE_TRUSH ||
        mode == MENU_ASK_MODE_ALBUM_ACCESS) {
        MenuCommonInfo->SetWakuType(-1);
    }

    MenuCommonInfo->MenuPosStep(cursor, &offset.x);

    if (cursor_snap != 0) {
        MenuCommonInfo->MenuSetPos(cursor[0], cursor[1]);
        cursor_snap = false;
    }
}

int CMenuInvent::IsMakeObject(int keys, int button) {
    switch (step) {
        case INVENT_MAKE_STEP_SELECT: {
            int select = SelectMakeObject(keys);

            if (select == -1) {
                make_board.decrease_flash_frames = 6;
                make_board.increase_flash_frames = 0;
            } else if (select == 1) {
                make_board.decrease_flash_frames = 0;
                make_board.increase_flash_frames = 6;
            }

            switch (button) {
                case MENU_PUSH_BUTTON_DECIDE:
                    if (make_cursor == 0) {
                        int enough = InventManagePt->CheckMakeItem(make_item_no, make_num, MenuUserParam.used_data);
                        make_space_no = GetUserDataMan()->SearchSpaceUsedData();

                        if (enough == 0) {
                            step = INVENT_MAKE_STEP_ERROR;
                            ExeScript("ITEM\x95\x73\x91\xab");
                        } else if (make_space_no < 0) {
                            step = INVENT_MAKE_STEP_ERROR;
                            ExeScript("\x8b\xf3\x82\xab\x96\xb3\x82\xb5");
                        } else {
                            if (make_item_no == ITEM_ID_ENERGY_PACK) {
                                GetSaveData()->SetBitFlag(13, true);
                            }

                            if (make_item_no == ITEM_ID_LURE_ROD) {
                                GetSaveData()->SetBitFlag(SAVE_FLAG_LURE_ROD, true);
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
                            step = INVENT_MAKE_STEP_LOAD_SOUND;
                            MenuCharaLoadStack.stack_used = 0;
                            MenuCharaLoadStack.lock = 0;
                            MenuCharaLoadStack.Alloc(0xC0);
                            load_sound_buffer = &MenuCharaLoadStack.stack[MenuCharaLoadStack.stack_used];
                            StartReadBG();
                            int size;
                            LoadFileBG("snd2/sp/SP_001.snd", (u_long128 *) load_sound_buffer, &size);
                            u_int bytes = size + 16;
                            MenuCharaLoadStack.Alloc(align16_blocks(bytes));
                        }

                        break;
                    }
                case MENU_PUSH_BUTTON_CANCEL:
                    mode = MENU_ASK_MODE_NONE;
                    ExeScript("\x8d\xec\x90\xac\x83\x7b\x81\x5b\x83\x68OFF");
                    MenuSePlay(SYSTEM_SE_CANCEL);
                    MenuCommonInfo->SetVibeR(6, 4);
                    break;
            }

            break;
        }
        case INVENT_MAKE_STEP_LOAD_SOUND:
            if (ReadBGSync() == 0) {
                int koma[10] = {256, 225, 100, 100};
                MenuPosData->GetPosMenuItemBrdKoma(koma, make_space_no, 0);
                mgCTexture *effect_tex = MenuPosData->icon_effect_tex;
                MenuEffect[0]->PresetEffect(&MenuCharaLoadStack, effect_tex, MENU_EFFECT_TYPE_GATHER, koma);
                MenuEffect[0]->EffectStart();
                koma[2] = 32;
                koma[3] = 40;
                MenuEffect[1]->PresetEffect(&MenuCharaLoadStack, effect_tex, MENU_EFFECT_TYPE_FLASH, koma);
                MenuEffect[1]->EffectStart();
                MenuCommonInfo->SetVibeR(6, 4);

                if (MenuCommonInfo->cursor_form != NULL) {
                    MenuCommonInfo->cursor_form->draw_flag = false;
                }

                ExeScript("\x8d\xec\x90\xac\x83\x7b\x81\x5b\x83\x68OFF");
                MenuSePlay(0, (u_int *) load_sound_buffer, &MenuSoundBuffer);
                CreateModeSwapForm(1);
                step = INVENT_MAKE_STEP_EFFECT;
            }

            break;
        case INVENT_MAKE_STEP_EFFECT:
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
        case INVENT_MAKE_STEP_RESULT:
            if (button != 0) {
                CreateModeSwapForm(0);
                ExeScript("ERRMSGOFF0");
                MenuSePlay(SYSTEM_SE_DECIDE);
                mode = MENU_ASK_MODE_NONE;
                step = INVENT_MAKE_STEP_SELECT;
                make_cursor = 1;
            }

            break;
        case INVENT_MAKE_STEP_ERROR:
            if (button != 0) {
                ExeScript("ERRMSGOFF0");
                MenuCommonInfo->SetVibeR(6, 4);
                MenuSePlay(SYSTEM_SE_CANCEL);
                mode = MENU_ASK_MODE_NONE;
                step = INVENT_MAKE_STEP_SELECT;
                make_cursor = 0;
                cursor_snap = true;
            }

            break;
        default:
            mode = MENU_ASK_MODE_NONE;
            step = INVENT_MAKE_STEP_SELECT;
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
    blink_count %= PAL_TIMING(50, 60);

    if (blink_count >= PAL_TIMING(180000, 216000)) {
        blink_count = 0;
    }

    float wave = sinf(mgAngleLimit(PI * blink_count / PAL_TIMING(50.0f, 60.0f)));
    float shade = 128.0f + 64.0f * wave;
    neta_color[0] = shade;
    neta_color[1] = shade;
    neta_color[2] = 128.0f;
    scoop_color[0] = scoop_color[1] = shade;
    CMenuPosDataForm *balloon = MenuPosData->GetFormInfo("\x90\x81\x8f\x6f\x82\xb5"
                                                         "0");

    if (balloon != NULL) {
        float center[2];
        balloon->GetPutPosXY("o", center[0], center[1]);

        if (mode == MENU_ASK_MODE_CREATE && step > INVENT_CREATE_STEP_ASK && step < INVENT_CREATE_STEP_SHOW) {
            neta_circle_radius -= 0.44444445f;

            if (neta_circle_radius < 0.0f) {
                neta_circle_radius = 0.0f;
            }
        } else {
            neta_circle_radius = 40.0f;
        }

        float slot_angle = 0.0f;

        if (neta_select_num > 0) {
            slot_angle = TWO_PI / neta_select_num;
        }

        neta_circle_angle += PI / 60.0f;

        if (neta_circle_angle >= PI) {
            neta_circle_angle -= TWO_PI;
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

            if (neta_select_state[i] == INVENT_NETA_SLOT_PLACED) {
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

                if (neta_flash[i] != 0) {
                    neta_flash_angle += PI / 40.0f;

                    if (neta_flash_angle > PI) {
                        neta_flash_angle -= TWO_PI;
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
            } else if (neta_select_state[i] == INVENT_NETA_SLOT_RETURNING) {
                clip[0] = neta_board_form->y + 6.0f + 54.0f;

                if (neta_select_type[i] == INVENT_NETA_SOURCE_PHOTO) {
                    GetNetaBoardCursorPosition(neta_select_index[i], target);
                    form->SetNextMovePos(target, 2);

                    if ((target[1] < clip[0] && form->y < clip[0]) ||
                        (target[1] > clip[1] && form->y > clip[0]) || target[0] < 0) {
                        form->SetRGBACalcParam(3, -0x1C, 0);
                    }
                } else if (neta_select_type[i] == INVENT_NETA_SOURCE_MEMO) {
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
                    neta_select_state[i] = INVENT_NETA_SLOT_EMPTY;
                    neta_select_index[i] = -1;
                    form->draw_flag = false;
                }
            }
        }

        if (neta_circle_snap != 0) {
            neta_circle_snap = false;
        }
    }

    if (neta_memo_form != NULL) {
        CalcMenu1(neta_memo_form->y + 76.0f + 2.0f - memo_top * 26, &memo_scroll, 4.0f, 0.0f, memo_scroll_reset);
        float bar_step = 0.0f;

        if (pic_name_info_num > 9) {
            bar_step = 216.0f / (pic_name_info_num - 9.0f);
        }

        CalcMenu1(neta_memo_form->y + 76.0f + 1.0f + bar_step * memo_top, &memo_bar, 4.0f, 0.0f, memo_scroll_reset);
        memo_scroll_reset = false;
    }

    if (neta_board_form != NULL) {
        CalcMenu1(neta_board_form->y + 6.0f - photo_top * 54, &photo_scroll, 4.0f, 0.0f, photo_scroll_reset);
        CalcMenu1(112.0f + 11.733334f * photo_top, &photo_bar, 4.0f, 1.0f, photo_scroll_reset);
        photo_scroll_reset = false;

        if (neta_board_bar[0] != NULL && neta_board_bar[1] != NULL && neta_board_bar[2] != NULL) {
            neta_board_bar[0]->y = photo_bar;
            neta_board_bar[1]->y = neta_board_bar[0]->y + 6.0f;
            neta_board_bar[1]->h = 23.2f;
            neta_board_bar[2]->y = neta_board_bar[1]->y + neta_board_bar[1]->h;
        }

        if (mode != MENU_ASK_MODE_PHOTO_NETA) {
            arrow_count++;
        }

        if (arrow_count >= PAL_TIMING(50, 60)) {
            arrow_count = 0;
        }

        if (neta_memo_arrow != NULL && neta_board_arrow != NULL) {
            neta_board_arrow->x = neta_memo_arrow->x;
            neta_board_arrow->y = neta_memo_arrow->y + 6.0f * sinf(PAL_TIMING(PI / 25.0f, PI / 30.0f) * arrow_count);
        }

        neta_board_form->SetNumber("nownum", InventUserDataPtr->GetNowHavePictureNum());
    }

    if (album_big_form != NULL && album_big_form->draw_flag != 0) {
        int cursor[2];
        album_big_form->GetPutPosXY("cur0", cursor[0], cursor[1]);
        album_scroll_x = cursor[0] - 2;
        CalcMenu1(cursor[1] - 2 - album_top * 54, &album_scroll_y, 4.0f, 1.0f, album_scroll_reset);
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

        album_scroll_reset = false;
    }

    CalcMakeBrd(4);
    CMenuPosDataForm *title = card_list_title_form;

    if (title != NULL && title->draw_flag != 0) {
        int reset = false;

        if (card_scroll_reset != 0) {
            card_scroll_reset = false;
            reset = true;
        }

        CMenuPosDataForm *clip = MenuPosData->GetFormInfo("\x94\xad\x96\xbe\x83\x4a\x81\x5b\x83\x68\x83\x4e\x83\x8a\x83\x62\x83\x76"
                                                          "1");
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
                        if (step > INVENT_CREATE_STEP_ASK && step < INVENT_CREATE_STEP_AFTER) {
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
                    if (mode == MENU_ASK_MODE_CREATE && step == INVENT_CREATE_STEP_SHOW) {
                        if (create_success != 0) {
                            pos[0] += 3.0f;
                            frame->GetScale(scale);
                            pos[0] += effect_sway * sinf(effect_sway_angle);
                            float bob = sinf(effect_bob_angle);
                            pos[1] += effect_bob * bob;
                            scale[1] = 0.6f + 0.4f * bob;
                            frame->SetScale(scale);
                            frame->SetPosition(pos);
                            effect_sway_angle += PI / 46.0f;

                            if (effect_sway_angle >= PI) {
                                effect_sway_angle -= TWO_PI;
                                effect_sway = 1.0f + 2.0f * mgRnd();
                            }

                            if (CalcMenuAdd(&effect_bob_angle, PI / 22.0f, PI)) {
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
                            effect_bob_angle += PI / 36.0f;

                            if (effect_bob_angle >= PI) {
                                effect_bob_angle -= TWO_PI;
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
                kakudai_pic_form->draw_flag = false;
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

    if (mode == MENU_ASK_MODE_MAKE && step == INVENT_MAKE_STEP_EFFECT) {
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
        MenuSePlay(SYSTEM_SE_CANCEL);
        return;
    }

    menu_invent_command_info_pict_info = GetNowSelectedPictInfo();

    if (menu_invent_command_info_pict_info == NULL || menu_invent_command_info_pict_info->used == 0) {
        MenuSePlay(SYSTEM_SE_CANCEL);
        return;
    }

    menu_invent_command_info_move_album_Space_info = NULL;
    MenuSePlay(SYSTEM_SE_WINDOW);
    MENU_ASKMODE_PARA ask;
    ask.ask_mode = INVENT_ASK_COMMAND;
    ask.mes_no = 6;
    ask.form = MenuMesForm[ask.mes_no];
    int count = 0;

    for (int i = 0; i < menu_invent_command_info_ptr->cmd_num; i++) {
        int enable = true;

        if (menu_invent_command_info_ptr->cmd[i] == INVENT_CMD_TO_ALBUM && album_enable == 0) {
            continue;
        }

        ask.cmd_shade[count] = MES_SHADE_AUTO;

        if (menu_invent_command_info_ptr->cmd[i] == INVENT_CMD_SET_BOARD && neta_select_num >= 3) {
            enable = false;
        } else if (menu_invent_command_info_ptr->cmd[i] == INVENT_CMD_TO_ALBUM) {
            for (int slot = 0; slot < INVENT_ALBUM_PHOTO_NUM; slot++) {
                USER_PICTURE_INFO *album = InventAlbumPtr->GetAlbumPhotoInfo(slot);

                if (album != NULL && album->used == 0) {
                    menu_invent_command_info_move_album_Space_info = album;
                    menu_invent_command_info_move_album_Space_pos = slot;
                    break;
                }
            }

            if (menu_invent_command_info_move_album_Space_info == NULL) {
                enable = false;
            }
        } else if (menu_invent_command_info_ptr->cmd[i] == INVENT_CMD_FROM_ALBUM) {
            menu_invent_command_info_move_album_Space_info = InventUserDataPtr->IsPhotoSpace(NULL);

            if (menu_invent_command_info_move_album_Space_info == NULL) {
                enable = false;
            }
        } else if (menu_invent_command_info_ptr->cmd[i] == INVENT_CMD_DELETE_ALL ||
                   menu_invent_command_info_ptr->cmd[i] == INVENT_CMD_DELETE_UNUSED) {
            if (0 < neta_select_num) {
                enable = false;
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

    MenuMesForm[ask.mes_no]->draw_flag = true;

    if (MenuCommonInfo->cursor_form != NULL) {
        MenuCommonInfo->cursor_form->draw_flag = false;
    }

    mode = MENU_ASK_MODE_EXTEND;
    step = 0;

    if (menu_invent_command_info_pict_info != NULL) {
        menu_invent_command_info_pict_info->is_new = false;
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
    int                unneeded[INVENT_ALBUM_PHOTO_NUM];
    int                pos[2];
    ItemNameList2      names;
    ItemNameList2      delete_names;
    int                num;
    int                all_num;

    switch (ask_para.ask_mode) {
        case INVENT_ASK_COMMAND: {
            int line = command_message->CommandMsgCursor();

            if (button & MENU_PUSH_BUTTON_DECIDE) {
                if (command_message->line_shade[line] == MES_SHADE_FAINT) {
                    MenuSePlay(SYSTEM_SE_CANCEL);
                    break;
                }

                int command = command_message->item_mes[line] - INVENT_CMD_ZOOM;
                ask->ask_mode = convtbl_3726[command];
                command_form->draw_flag = false;
                int se = SYSTEM_SE_DECIDE;

                switch (ask->ask_mode) {
                    case INVENT_ASK_SET_BOARD: {
                        int se_end = SYSTEM_SE_CANCEL;

                        if (SetNetaCircle(INVENT_NETA_SOURCE_PHOTO, photo_cursor) > 0) {
                            se_end = 12;
                        }

                        IsAskEnd(se_end, command_form);
                        yesno_form->draw_flag = false;
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
                                picture = album_cursor + INVENT_PICTURE_ALBUM;
                                break;
                        }

                        kakudai_pic->etc_info[0] = picture;
                        CMenuPosDataForm *zoom_form = kakudai_pic_form;
                        zoom_form->x = pos[0];
                        zoom_form->y = pos[1];
                        kakudai_pic_form->draw_flag = true;
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
                            ExeScript("\x8e\xca\x90\x5e\x82\xcc\x88\xea\x8a\x87\x8f\xc1\x8b\x8e\x81\x48"
                                      "Album");
                        } else {
                            ExeScript("\x8e\xca\x90\x5e\x82\xcc\x88\xea\x8a\x87\x8f\xc1\x8b\x8e\x81\x48\x83\x6c\x83\x5e");
                        }

                        break;
                    case INVENT_ASK_DELETE_ALL:
                        if (key_arg_no == INVENT_MODE_ALBUM_VIEW) {
                            ExeScript("\x8e\xca\x90\x5e\x91\x53\x8f\xc1\x8b\x8e\x81\x48"
                                      "Album");
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
            } else if (button & MENU_PUSH_BUTTON_CANCEL) {
                command_form->draw_flag = false;
                IsAskEnd(SYSTEM_SE_CANCEL, command_form);

                if (kakudai_pic_form != NULL) {
                    kakudai_pic_form->draw_flag = false;
                }
            }

            break;
        }
        case INVENT_ASK_ZOOM:
            if (button != 0) {
                ask->ask_mode = INVENT_ASK_COMMAND;
                MenuSePlay(SYSTEM_SE_CANCEL);
                command_form->draw_flag = true;
            }

            break;
        case INVENT_ASK_DELETE:
            if (step == 0) {
                int answer = yesno_message->YesNoCursor();

                switch (button) {
                    case MENU_PUSH_BUTTON_DECIDE:
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
                    case MENU_PUSH_BUTTON_CANCEL:
                        IsAskEnd(SYSTEM_SE_CANCEL, command_form);
                        yesno_form->draw_flag = false;
                        break;
                }
            } else if (step == 1 && button != 0) {
                IsAskEnd(SYSTEM_SE_DECIDE, command_form);
                yesno_form->draw_flag = false;
            }

            break;
        case INVENT_ASK_TO_ALBUM:
        case INVENT_ASK_FROM_ALBUM:
            if (step == 0) {
                int answer = yesno_message->YesNoCursor();

                switch (button) {
                    case MENU_PUSH_BUTTON_DECIDE:
                        if (answer == 0) {
                            MenuSePlay(12);
                            yesno_form->draw_flag = false;
                            Copy_USER_PICTURE_INFO(menu_invent_command_info_pict_info,
                                                   menu_invent_command_info_move_album_Space_info);
                            memcpy(menu_invent_command_info_move_album_Space_info->image,
                                   menu_invent_command_info_pict_info->image, 0x2000);
                            menu_invent_command_info_move_album_Space_info->used = true;
                            Init_USER_PICTURE_INFO(menu_invent_command_info_pict_info);

                            if (ask->ask_mode == INVENT_ASK_TO_ALBUM) {
                                AttachPictTex(tex_block[4], album_tex, InventAlbumPtr->GetAlbumPhotoInfo(0), INVENT_ALBUM_PHOTO_NUM);
                                album_flag[menu_invent_command_info_move_album_Space_pos] = 1;
                            } else {
                                AttachPictTex(tex_block[3], photo_tex, InventUserDataPtr->GetPhotoInfo(0), INVENT_PHOTO_NUM);
                                album_flag[album_cursor] = -1;
                            }

                            ask->ask_mode = INVENT_ASK_COMMAND;
                            step = 0;
                            mode = MENU_ASK_MODE_NONE;
                            IsAskEnd(SYSTEM_SE_CANCEL, command_form);
                            yesno_form->draw_flag = false;
                            break;
                        }
                    case MENU_PUSH_BUTTON_CANCEL:
                        IsAskEnd(SYSTEM_SE_CANCEL, command_form);
                        yesno_form->draw_flag = false;
                        break;
                }
            }

            break;
        case INVENT_ASK_DELETE_UNUSED:
            if (step == 0) {
                int answer = yesno_message->YesNoCursor();

                switch (button) {
                    case MENU_PUSH_BUTTON_DECIDE:
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
                    case MENU_PUSH_BUTTON_CANCEL:
                        IsAskEnd(SYSTEM_SE_CANCEL, command_form);
                        yesno_form->draw_flag = false;
                        break;
                }
            } else if (button != 0) {
                IsAskEnd(SYSTEM_SE_DECIDE, yesno_form);
                yesno_form->draw_flag = false;
            }

            break;
        case INVENT_ASK_DELETE_ALL:
            switch (step) {
                case 0: {
                    int answer = yesno_message->YesNoCursor();

                    switch (button) {
                        case MENU_PUSH_BUTTON_DECIDE:
                            if (answer == 0) {
                                all_num = 0;
                                USER_PICTURE_INFO *photo = GetPhotoInfoFromMode(&all_num);

                                for (int i = 0; i < all_num; i++, photo++) {
                                    Init_USER_PICTURE_INFO(photo);
                                }

                                step = 1;
                                MenuSePlay(13);

                                if (key_arg_no == INVENT_MODE_ALBUM_VIEW) {
                                    ExeScript("\x8e\xca\x90\x5e\x91\x53\x8f\xc1\x8b\x8e"
                                              "Album");
                                    InitPhotoNetaBoardToAlbum(0);
                                } else {
                                    ExeScript("\x8e\xca\x90\x5e\x91\x53\x8f\xc1\x8b\x8e\x83\x6c\x83\x5e");
                                }

                                break;
                            }
                        case MENU_PUSH_BUTTON_CANCEL:
                            IsAskEnd(SYSTEM_SE_CANCEL, command_form);
                            yesno_form->draw_flag = false;
                            break;
                    }

                    break;
                }
                case 1:
                    if (button != 0) {
                        IsAskEnd(SYSTEM_SE_DECIDE, command_form);
                        yesno_form->draw_flag = false;
                    }

                    break;
            }

            break;
    }

    return 0;
}

void CMenuInvent::PhotoNetaEnter(int index, int button) {
    CDC2Mes *message = MenuDCMsg[4];
    int      cancel = false;

    switch (step) {
        case INVENT_NETA_ENTER_ASK: {
            int answer = message->YesNoCursor();

            switch (button) {
                case MENU_PUSH_BUTTON_DECIDE:
                case MENU_PUSH_BUTTON_TRIANGLE:
                    if (answer == 0) {
                        neta_effect_time = 0;
                        InventInNetaEffectFlag = true;
                        ExeScript("\x83\x6c\x83\x5e\x93\x6f\x98\x5e\x8a\x4a\x8e\x6e");
                        MenuSePlay(0x20);
                        MenuCharaLoadStack.stack_used = 0;
                        MenuCharaLoadStack.lock = 0;
                        InventInNetaEffectNum4 = InventInNetaEffectNum * 80;
                        int          count = InventInNetaEffectNum4;
                        unsigned int size = count * sizeof(CStarDust);
                        unsigned int blocks = align16_blocks(size);
                        InventInNetaEffect = new (MenuCharaLoadStack.Alloc(blocks + 2)) CStarDust[count];
                        step = INVENT_NETA_ENTER_EFFECT;
                        break;
                    }
                case MENU_PUSH_BUTTON_CANCEL:
                    cancel = true;
                    break;
            }

            break;
        }
        case INVENT_NETA_ENTER_EFFECT:
            if (neta_effect_time == 0) {
                if (CheckRunStarDust(InventInNetaEffect, InventInNetaEffectNum4) == 0) {
                    neta_effect_time++;
                }
            } else {
                neta_effect_time++;
            }

            if (neta_effect_time > PAL_TIMING(50, 60)) {
                CheckPhotoFlag();
                InventUserDataPtr->PhotoCheckEnd();

                if (photo_only == 1 && album_open == 0) {
                    UpdataRecordBoard();
                }

                MenuSePlay(0x21);
                InventInNetaEffectFlag = false;
                step = INVENT_NETA_ENTER_LEARNT;
                ExeScript("\x83\x6c\x83\x5e\x93\x6f\x98\x5e");
            }

            break;
        case INVENT_NETA_ENTER_LEARNT:
            if (button != 0) {
                ExeScript("\x93\x6f\x98\x5e\x8e\xca\x90\x5e\x8f\xc1\x82\xb7\x81\x48");
                step = INVENT_NETA_ENTER_ASK_DELETE;
            }

            break;
        case INVENT_NETA_ENTER_ASK_DELETE: {
            int answer = message->YesNoCursor();

            switch (button) {
                case MENU_PUSH_BUTTON_DECIDE:
                    if (answer == 0) {
                        ExeScript("\x93\x6f\x98\x5e\x8e\xca\x90\x5e\x8f\xc1\x82\xb7");

                        for (int i = 0; i < INVENT_PHOTO_NUM; i++) {
                            if (new_neta_photo[i] != 0) {
                                InventUserDataPtr->DeletePhotoData(i);
                            }
                        }

                        step = INVENT_NETA_ENTER_DELETED;
                        break;
                    }
                case MENU_PUSH_BUTTON_CANCEL:
                    cancel = true;
                    break;
            }

            break;
        }
        case INVENT_NETA_ENTER_DELETED:
            if (button != 0) {
                cancel = true;
            }

            break;
        case INVENT_NETA_ENTER_NOTHING:
            if (button != 0) {
                cancel = true;
            }

            break;
    }

    if (cancel) {
        mode = MENU_ASK_MODE_NONE;
        step = INVENT_NETA_ENTER_ASK;
        ExeScript("\x83\x6c\x83\x5e\x93\x6f\x98\x5e\x8f\x49\x97\xb9");
        MenuSePlay(SYSTEM_SE_CANCEL);
    }
}

CStarDust::CStarDust() {
    this->active = false;
}

void CMenuInvent::IsAccessAlbum() {
    MC_CARD_INFO  *card;
    CDC2Mes       *message;
    int            keys;
    int            button;
    int            done;
    int            back_to_photo;
    int            finish;
    int            access;
    int            cancel;
    int            loaded;
    int            check_space;
    int            card_removed;
    int            no_card;
    int            card_full;
    int            card_error;
    int            read_error;
    int            answer;
    MC_ERROR_INFO *error;

    message = MenuDCMsg[4];

    if (message == NULL) {
        return;
    }

    keys = MenuCommonInfo->CheckSelectKey();
    button = MenuCommonInfo->CheckPushButton();
    error = NULL;
    card = NULL;
    done = false;

    if (MCManagerPtr != NULL) {
        MCManagerPtr->GetFuncNo();
        done = MCManagerPtr->Step();
        CMemoryCardManager *manager = MCManagerPtr;
        card = manager->GetCardInfo();
        error = manager->GetErrorInfo();
    }

    back_to_photo = false;
    finish = false;
    access = INVENT_ALBUM_ACCESS_NONE;
    cancel = false;
    loaded = INVENT_ALBUM_LOAD_NONE;
    check_space = false;
    card_removed = false;
    no_card = false;
    card_full = false;
    card_error = false;
    read_error = false;

    if (init_3950 == 0) {
        ActiveSlot_3949 = 0;
        init_3950 = true;
    }

    switch (step) {
        case INVENT_ALBUM_STEP_SLOT_SELECT: {
            int move = 0;

            if (keys & MENU_SELECT_KEY_UP) {
                move--;
            }

            if (keys & MENU_SELECT_KEY_DOWN) {
                move++;
            }

            if (message->AddMsgCursor(move, 1, 2, 1) != 0) {
                MenuSePlay(SYSTEM_SE_CURSOR);
            }

            switch (button) {
                case MENU_PUSH_BUTTON_DECIDE:
                    ActiveSlot_3949 = message->GetMsgCursor() - 1;
                    printf("ActiveSlot:%d\n", ActiveSlot_3949);
                    chara_load_step = INVENT_CHARA_LOAD_OFF;
                    poly_chr_form[0]->SetActionCharaPtr(NULL, -1, -1);
                    ExeScript("MCLOAD_BEGIN");

                    while (CancelNetaCircle(0) >= 0) {
                    }

                    InitPhotoNetaBoardToAlbum(0);
                    MenuInventCharaStack.stack_used = 0;
                    MenuInventCharaStack.lock = 0;
                    MenuInventMCStack.stack_used = 0;
                    MenuInventMCStack.lock = 0;
                    step = INVENT_ALBUM_STEP_ALLOCATE;
                    album_scroll_reset = true;
                    break;
                case MENU_PUSH_BUTTON_CANCEL:
                    album_open = false;
                    cancel = true;
                    break;
            }

            break;
        }
        case INVENT_ALBUM_STEP_ALLOCATE:
            MenuInventMCStack.stack_used = 0;
            MenuInventMCStack.lock = 0;
            MenuInventMCStack.Align64();
            InventAlbumPtr = new (MenuInventMCStack.Alloc(align16_blocks(sizeof(CDC2AlbumData)) + 2)) CDC2AlbumData;
            MCManagerPtr = new (MenuInventMCStack.Alloc(align16_blocks(sizeof(CMemoryCardManager)) + 2)) CMemoryCardManager;
            MCManagerPtr->Initialize(NULL);
            MCManagerPtr->InitForMC();
            MCManagerPtr->SetBuff_Album((char *) InventAlbumPtr);
            MCManagerPtr->SetIconData(icon_data, 1);
            MCManagerPtr->port = ActiveSlot_3949;
            MCManagerPtr->SetFuncNo(MC_FUNC_SEARCH_TYPE);
            step = INVENT_ALBUM_STEP_SEARCH;
            break;
        case INVENT_ALBUM_STEP_SEARCH:
            if (done != 0) {
                if (McCheckMCPs2(card) == 0) {
                    no_card = true;
                } else if (card->formatted == 0) {
                    if (album_save_mode == INVENT_ALBUM_SAVE) {
                        step = INVENT_ALBUM_STEP_ASK_FORMAT;
                        ExeScript("FORMAT\212m\224F");
                    } else {
                        loaded = INVENT_ALBUM_LOAD_NO_ALBUM;
                    }
                } else if (album_save_mode == INVENT_ALBUM_LOAD) {
                    step = INVENT_ALBUM_STEP_CHECK_ALBUM;
                    MCManagerPtr->SetFuncNo(MC_FUNC_CHECK_ALBUM);
                } else {
                    step = INVENT_ALBUM_STEP_ASK_SAVE;
                    ExeScript("IS_SAVE");
                }
            }

            break;
        case INVENT_ALBUM_STEP_CHECK_ALBUM:
            if (done != 0) {
                if (McCheckMCPs2(card) == 0) {
                    loaded = INVENT_ALBUM_LOAD_NO_ALBUM;
                } else if (MCManagerPtr->file_exists != 0) {
                    if (error->code != MC_ERROR_NONE) {
                        read_error = true;
                    } else {
                        step = INVENT_ALBUM_STEP_LOAD;
                        MCManagerPtr->SetFuncNo(MC_FUNC_LOAD_ALBUM);
                        InitMenuDl(GetMenuDlTexture(), MCManagerPtr->GetSaveDataSize(MC_SIZE_ALBUM_FILE));
                        download_base = 0;
                        ExeScript("LOADING");

                        if (MenuDCMsg[4] != NULL) {
                            MenuDCMsg[4]->SetMsgVolumeNoOne(ActiveSlot_3949 + 1);
                        }
                    }
                } else {
                    loaded = INVENT_ALBUM_LOAD_NO_ALBUM;
                }
            }

            break;
        case INVENT_ALBUM_STEP_LOAD:
            StepMenuDl2(download_base + MCManagerPtr->GetTransferredSize());

            if (done != 0) {
                InitMenuDl(NULL, 0);

                if (McCheckMCPs2(card) == 0) {
                    read_error = true;
                } else if (error->code == MC_ERROR_BROKEN) {
                    read_error = true;
                } else {
                    loaded = INVENT_ALBUM_LOAD_DONE;
                }
            }

            break;
        case INVENT_ALBUM_STEP_LOADED:
            if (button != 0) {
                back_to_photo = true;
                cursor_snap = true;
                MenuSePlay(SYSTEM_SE_DECIDE);
            }

            break;
        case INVENT_ALBUM_STEP_MAKE_DIR_SEARCH:
            if (done != 0) {
                if (McCheckMCPs2(card) == 0) {
                    card_removed = true;
                } else {
                    access = INVENT_ALBUM_ACCESS_MAKE_DIR;
                    step = INVENT_ALBUM_STEP_MAKE_DIR;
                }
            }

            break;
        case INVENT_ALBUM_STEP_MAKE_DIR:
            StepMenuDl2(MCManagerPtr->total_transferred);

            if (done != 0) {
                if (McCheckMCPs2(card) == 0) {
                    card_removed = true;
                } else {
                    access = INVENT_ALBUM_ACCESS_SAVE_NEW;
                    step = INVENT_ALBUM_STEP_SAVE;
                }
            }

            break;
        case INVENT_ALBUM_STEP_LOAD_RETRY:
            if (button != 0) {
                loaded = INVENT_ALBUM_LOAD_RETRY;
            }

            break;
        case INVENT_ALBUM_STEP_LOAD_ERROR:
            if (button != 0) {
                MenuSePlay(SYSTEM_SE_DECIDE);
                loaded = INVENT_ALBUM_LOAD_NO_ALBUM;
            }

            break;
        case INVENT_ALBUM_STEP_SAVE_SLOT_SELECT: {
            int move = 0;

            if (keys & MENU_SELECT_KEY_UP) {
                move--;
            }

            if (keys & MENU_SELECT_KEY_DOWN) {
                move++;
            }

            if (message->AddMsgCursor(move, 2, 3, 1) != 0) {
                MenuSePlay(SYSTEM_SE_CURSOR);
            }

            switch (button) {
                case MENU_PUSH_BUTTON_DECIDE:
                    ActiveSlot_3949 = message->GetMsgCursor() - 2;

                    if (ActiveSlot_3949 < 0) {
                        ActiveSlot_3949 = 0;
                    }

                    if (ActiveSlot_3949 > 1) {
                        ActiveSlot_3949 = 1;
                    }

                    step = INVENT_ALBUM_STEP_SEARCH;
                    ExeScript("SAVE_PRECHECK");
                    MCManagerPtr->port = ActiveSlot_3949;
                    MCManagerPtr->SetFuncNo(MC_FUNC_SEARCH_TYPE);
                    break;
                case MENU_PUSH_BUTTON_CANCEL:
                    step = INVENT_ALBUM_STEP_ASK_LEAVE;
                    ExeScript("IS_SAVE2");
                    break;
            }

            break;
        }
        case INVENT_ALBUM_STEP_ASK_SAVE: {
            int answer = message->YesNoCursor();

            if (McCheckMCPs2(card) == 0) {
                no_card = true;
            } else {
                switch (button) {
                    case MENU_PUSH_BUTTON_DECIDE:
                        if (answer == 0) {
                            step = INVENT_ALBUM_STEP_SAVE_SEARCH;
                            MCManagerPtr->port = ActiveSlot_3949;
                            MCManagerPtr->SetFuncNo(MC_FUNC_SEARCH_TYPE);
                            ExeScript("SAVE_BEGIN");
                            break;
                        }
                    case MENU_PUSH_BUTTON_CANCEL:
                        step = INVENT_ALBUM_STEP_ASK_LEAVE;
                        ExeScript("IS_SAVE2");
                        break;
                }
            }

            break;
        }
        case INVENT_ALBUM_STEP_SAVE_SEARCH:
            if (done != 0) {
                if (McCheckMCPs2(card) != 0) {
                    if (card->formatted == 0) {
                        step = INVENT_ALBUM_STEP_ASK_FORMAT;
                        ExeScript("FORMAT\212m\224F");
                    } else {
                        step = INVENT_ALBUM_STEP_SAVE_CHECK_ALBUM;
                        MCManagerPtr->SetFuncNo(MC_FUNC_CHECK_ALBUM);
                    }
                } else {
                    card_removed = true;
                }
            }

            break;
        case INVENT_ALBUM_STEP_SAVE_CHECK_ALBUM:
            if (done != 0) {
                if (McCheckMCPs2(card) == 0) {
                    card_removed = true;
                } else if (MCManagerPtr->file_exists != 0) {
                    access = INVENT_ALBUM_ACCESS_SAVE;
                    step = INVENT_ALBUM_STEP_SAVE;
                } else {
                    check_space = true;
                }
            }

            break;
        case INVENT_ALBUM_STEP_SAVE:
            StepMenuDl2(download_base + MCManagerPtr->GetTransferredSize());

            if (done != 0) {
                if (McCheckMCPs2(card) == 0) {
                    card_removed = true;
                } else if (card->formatted != 0) {
                    access = INVENT_ALBUM_ACCESS_SAVED;
                    AttachPictTex(tex_block[4], album_tex, InventAlbumPtr->GetAlbumPhotoInfo(0), INVENT_ALBUM_PHOTO_NUM);
                    step = INVENT_ALBUM_STEP_SAVED;
                }
            }

            break;
        case INVENT_ALBUM_STEP_SAVED:
            if (button != 0) {
                MenuSePlay(SYSTEM_SE_DECIDE);
                finish = true;
            }

            break;
        case INVENT_ALBUM_STEP_ASK_LEAVE: {
            int answer = message->YesNoCursor2(0);

            if (answer == 1) {
                MenuSePlay(SYSTEM_SE_DECIDE);

                if (0 < CheckRecoverPhotoNum()) {
                    ExeScript("\226\337\202\267\212m\224F");
                    step = INVENT_ALBUM_STEP_ASK_RECOVER;
                } else {
                    finish = true;
                }
            }

            if (answer == 2) {
                cancel = true;
            }

            break;
        }
        case INVENT_ALBUM_STEP_ASK_NEW_ALBUM: {
            int answer = message->YesNoCursor();

            if (McCheckMCPs2(card) == 0) {
                no_card = true;
            } else {
                switch (button) {
                    case MENU_PUSH_BUTTON_DECIDE:
                        if (answer == 0) {
                            access = INVENT_ALBUM_ACCESS_NEW_ALBUM;
                            step = INVENT_ALBUM_STEP_MAKE_DIR_SEARCH;
                            break;
                        }
                    case MENU_PUSH_BUTTON_CANCEL:
                        cancel = true;
                        break;
                }
            }

            break;
        }
        case INVENT_ALBUM_STEP_ASK_RECOVER: {
            answer = message->YesNoCursor2(0);

            if (answer == 1) {
                int space = 0;

                for (int i = 0; i < 50; i++) {
                    USER_PICTURE_INFO *photo = InventUserDataPtr->GetPhotoInfo(i);

                    if (photo != NULL && photo->used == 0) {
                        space++;
                    }
                }

                int recover = 0;

                for (int i = 0; i < INVENT_ALBUM_PHOTO_NUM; i++) {
                    if (0 < album_flag[i]) {
                        recover++;
                    }
                }

                if (space < recover) {
                    step = INVENT_ALBUM_STEP_RECOVER_NO_SPACE;
                    ExeScript("\216\312\220^\210\352\224t");
                    MenuSePlay(SYSTEM_SE_CANCEL);
                    break;
                } else {
                    for (int i = 0; i < INVENT_ALBUM_PHOTO_NUM; i++) {
                        if (0 < album_flag[i]) {
                            album_flag[i] = -1;
                            USER_PICTURE_INFO *photo = InventUserDataPtr->IsPhotoSpace(NULL);
                            USER_PICTURE_INFO *album = InventAlbumPtr->GetAlbumPhotoInfo(i);

                            if (photo != NULL && album != NULL) {
                                Copy_USER_PICTURE_INFO(album, photo);
                                memcpy(photo->image, album->image, 0x2000);
                                photo->used = true;
                                Init_USER_PICTURE_INFO(album);
                            }
                        }
                    }

                    AttachPictTex(tex_block[3], photo_tex, InventUserDataPtr->GetPhotoInfo(0), INVENT_PHOTO_NUM);
                    finish = true;
                    MenuSePlay(12);
                }
            }

            if (answer == 2) {
                finish = true;
                MenuSePlay(SYSTEM_SE_CANCEL);
            }

            break;
        }
        case INVENT_ALBUM_STEP_RECOVER_NO_SPACE:
            if (button != 0) {
                back_to_photo = true;
            }

            break;
        case INVENT_ALBUM_STEP_CANCEL_NOTICE:
            if (button != 0) {
                cancel = true;
            }

            break;
        case INVENT_ALBUM_STEP_SAVE_ERROR:
            if (button != 0) {
                step = INVENT_ALBUM_STEP_ASK_LEAVE_FAILED;
                ExeScript("IS_SAVE2");
            }

            break;
        case INVENT_ALBUM_STEP_ASK_LEAVE_FAILED: {
            int answer = message->YesNoCursor2(0);

            if (answer == 1) {
                MenuSePlay(SYSTEM_SE_DECIDE);

                if (0 < CheckRecoverPhotoNum()) {
                    ExeScript("\226\337\202\267\212m\224F");
                    step = INVENT_ALBUM_STEP_ASK_RECOVER;
                } else {
                    finish = true;
                }
            }

            if (answer == 2) {
                cancel = true;
                MenuSePlay(SYSTEM_SE_CANCEL);
            }

            break;
        }
        case INVENT_ALBUM_STEP_ASK_FORMAT:
            if (McCheckMCPs2(card) == 0) {
                no_card = true;
            } else {
                int answer = message->YesNoCursor2(0);

                if (answer == 1) {
                    ExeScript("FORMAT\222\206");
                    MCManagerPtr->SetFuncNo(MC_FUNC_SEARCH_TYPE);
                    MenuDCMsg[4]->SetMsgVolumeNoOne(ActiveSlot_3949 + 1);
                    step = INVENT_ALBUM_STEP_FORMAT_SEARCH;
                }

                if (answer == 2) {
                    back_to_photo = true;
                }
            }

            break;
        case INVENT_ALBUM_STEP_FORMAT_SEARCH:
            if (done != 0) {
                if (McCheckMCPs2(card) == 1) {
                    if (card->formatted == 1) {
                        ExeScript("FORMAT_END");
                        MenuSePlay(SYSTEM_SE_COMPLETE);
                        step = INVENT_ALBUM_STEP_FORMATTED;
                    } else {
                        MCManagerPtr->SetFuncNo(MC_FUNC_FORMAT);
                        step = INVENT_ALBUM_STEP_FORMAT;
                    }
                } else {
                    no_card = true;
                }
            }

            break;
        case INVENT_ALBUM_STEP_FORMAT:
            if (done != 0) {
                step = INVENT_ALBUM_STEP_FORMATTED;

                if (McCheckMCPs2(card) == 1 && card->formatted == 1) {
                    ExeScript("FORMAT_END");
                    access = INVENT_ALBUM_ACCESS_NEW_ALBUM;
                    step = INVENT_ALBUM_STEP_MAKE_DIR_SEARCH;
                } else {
                    ExeScript("FORMAT_FAIL");
                }
            }

            break;
        case INVENT_ALBUM_STEP_FORMATTED:
            if (button != 0) {
                back_to_photo = true;
                check_space = true;
            }

            break;
    }

    switch (access) {
        case INVENT_ALBUM_ACCESS_NEW_ALBUM:
            ExeScript("NEWALBUMSYS_SAVE");
            MCManagerPtr->SetFuncNo(MC_FUNC_SEARCH_TYPE);
            break;
        case INVENT_ALBUM_ACCESS_MAKE_DIR:
            if (McCheckMCPs2(card) == 0) {
                card_removed = true;
            } else {
                download_base = 0;
                MCManagerPtr->SetFuncNo(MC_FUNC_MAKE_ALBUM_DIR);
                InitMenuDl(GetMenuDlTexture(), MCManagerPtr->GetSaveDataSize(MC_SIZE_ALBUM_TOTAL));
            }

            break;
        case INVENT_ALBUM_ACCESS_SAVE_NEW:
            if (McCheckMCPs2(card) == 0) {
                card_removed = true;
            } else if (card->formatted == 1) {
                MCManagerPtr->SetFuncNo(MC_FUNC_SAVE_ALBUM);
                download_base = MCManagerPtr->total_transferred;
            } else if (card->formatted == 0) {
                step = INVENT_ALBUM_STEP_ASK_FORMAT;
                ExeScript("FORMAT\212m\224F");
            } else if (error->code == MC_ERROR_FULL) {
                card_full = true;
            } else {
                card_error = true;
            }

            break;
        case INVENT_ALBUM_ACCESS_SAVE:
            if (McCheckMCPs2(card) == 0) {
                card_removed = true;
            } else {
                download_base = 0;
                MCManagerPtr->SetFuncNo(MC_FUNC_SAVE_ALBUM);
                InitMenuDl(GetMenuDlTexture(), MCManagerPtr->GetSaveDataSize(MC_SIZE_ALBUM_FILE));
                ExeScript("SAVING");

                if (MenuDCMsg[4] != NULL) {
                    MenuDCMsg[4]->SetMsgVolumeNoOne(ActiveSlot_3949 + 1);
                }
            }

            break;
        case INVENT_ALBUM_ACCESS_SAVED:
            if (error->code == MC_ERROR_NONE) {
                InitMenuDl(NULL, 0);
                ExeScript("SAVE_END");
                MenuSePlay(SYSTEM_SE_COMPLETE);
            } else if (error->code == MC_ERROR_FULL) {
                card_full = true;
            } else {
                card_error = true;
            }

            break;
    }

    if (check_space != 0) {
        if (card->type == 2 && card->present == 1) {
            if (card->formatted == 0) {
                step = INVENT_ALBUM_STEP_ASK_FORMAT;
                ExeScript("FORMAT\212m\224F");
            } else if (MCManagerPtr->GetSaveDataSize(MC_SIZE_SAVE_KB) + 2 > card->free_size) {
                card_full = true;
            } else {
                if (album_save_mode == INVENT_ALBUM_SAVE) {
                    step = INVENT_ALBUM_STEP_ASK_NEW_ALBUM;
                }

                ExeScript("\220V\213KALBUM");
            }
        } else {
            no_card = true;
        }
    }

    if (no_card != 0) {
        InitMenuDl(NULL, 0);

        if (album_save_mode == INVENT_ALBUM_LOAD) {
            step = INVENT_ALBUM_STEP_LOAD_RETRY;
        }

        if (album_save_mode == INVENT_ALBUM_SAVE) {
            step = INVENT_ALBUM_STEP_SAVE_ERROR;
        }

        ExeScript("NOTPS2MC");
    }

    if (card_full != 0) {
        InitMenuDl(NULL, 0);

        if (album_save_mode == INVENT_ALBUM_LOAD) {
            step = INVENT_ALBUM_STEP_LOAD_ERROR;
        }

        if (album_save_mode == INVENT_ALBUM_SAVE) {
            step = INVENT_ALBUM_STEP_SAVE_ERROR;
        }

        ExeScript("NEWALBUM_SIZE\225s\221\253");
        MenuDCMsg[4]->SetMsgVolumeNoOne(ActiveSlot_3949 + 1);
    }

    if (card_error == 1) {
        InitMenuDl(NULL, 0);
        ExeScript("NOT_SAVE");

        if (album_save_mode == INVENT_ALBUM_LOAD) {
            step = INVENT_ALBUM_STEP_LOAD_ERROR;
        }

        if (album_save_mode == INVENT_ALBUM_SAVE) {
            step = INVENT_ALBUM_STEP_SAVE_ERROR;
        }
    }

    if (read_error != 0) {
        ExeScript("LOAD_MISS");
        step = INVENT_ALBUM_STEP_LOAD_RETRY;
    }

    if (card_removed != 0) {
        InitMenuDl(NULL, 0);
        ExeScript("NOT_SAVE");
        step = INVENT_ALBUM_STEP_SAVE_ERROR;
    }

    if (loaded != 0) {
        InventAlbumPtr->RelateAlbumPicData();
        AttachPictTex(tex_block[4], album_tex, InventAlbumPtr->GetAlbumPhotoInfo(0), INVENT_ALBUM_PHOTO_NUM);

        if (loaded == INVENT_ALBUM_LOAD_OTHER) {
            ExeScript("LOADEND3");
            MenuDCMsg[6]->SetMsgVolumeNoOne(ActiveSlot_3949 + 1);
        }

        if (loaded == INVENT_ALBUM_LOAD_NO_ALBUM) {
            ExeScript("LOADEND2");
        }

        if (loaded == INVENT_ALBUM_LOAD_DONE) {
            ExeScript("LOADEND");
            MenuSePlay(SYSTEM_SE_COMPLETE);
        }

        cursor_snap = true;
        step = INVENT_ALBUM_STEP_LOADED;

        if (loaded < INVENT_ALBUM_LOAD_NONE) {
            step = INVENT_ALBUM_STEP_SLOT_SELECT;
            ExeScript("IS_MCACCESS");

            if (LanguageCode > LANG_JAPANESE && LanguageCode < LANG_CHINESE) {
                MenuDCMsg[4]->SetMsgCursor(1);
                MenuDCMsg[4]->select_top = 1;
            }

            ExeScript("COMBACK_SLOTSEL");
            chara_load_step = INVENT_ALBUM_STEP_SLOT_SELECT;
            StartReadBG();
            MCManagerPtr->FinishForMC();
            MCManagerPtr = NULL;
            MenuCharaLoadStack.stack_used = 0;
            MenuCharaLoadStack.lock = 0;
            return;
        }
    }

    if (finish != 0) {
        MenuMesForm[4]->draw_flag = false;
        int next_mode = INVENT_MODE_THINK;

        if (photo_only == 1) {
            next_mode = INVENT_MODE_PHOTO_VIEW;
        }

        PrepareNextMode(next_mode);
        mode = MENU_ASK_MODE_NONE;
        step = INVENT_ALBUM_STEP_SLOT_SELECT;
        chara_load_step = INVENT_ALBUM_STEP_SLOT_SELECT;
        album_open = false;
        MCManagerPtr->FinishForMC();
        MCManagerPtr = NULL;
        MenuCharaLoadStack.stack_used = 0;
        MenuCharaLoadStack.lock = 0;
        StartReadBG();
        return;
    }

    if (back_to_photo != 0) {
        PrepareNextMode(INVENT_MODE_ALBUM_VIEW);
        mode = MENU_ASK_MODE_NONE;
        step = INVENT_ALBUM_STEP_SLOT_SELECT;
        ExeScript("IS_MCACCESS_\216\346\217\301");
    }

    if (cancel != 0) {
        mode = MENU_ASK_MODE_NONE;
        step = INVENT_ALBUM_STEP_SLOT_SELECT;
        ExeScript("IS_MCACCESS_\216\346\217\301");
    }

    if (dload_form != NULL) {
        int pos[2];
        dload_form->GetPutPosXY(NULL, pos[0], pos[1]);
        pos[1] += 26;
        MenuDCMsg[6]->StepMsg();
        MenuDCMsg[6]->SetMovePosCenteringGyou(0, mgScreenWidth >> 1, pos[1]);
    }
}

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

    pos[1] += slot * 26 + 78;
}

/**
 *
 * Orders discovered invention ideas while keeping their names, identifiers and sort keys together.
 *
 */
static int neta_sort(int mode, int first, int last, int *keys) {
    int swapped = false;
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
                swapped = true;
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

    while (i < pic_name_info_num && i < 512) {
        info = &pic_name_info_top[i];

        if (info == NULL) {
            break;
        }

        if (0 <= user_data->CheckNetaFlag(info->neta_id)) {
            NetaMemoID[NetaMemoStrNum] = info->neta_id;
            NetaMemoStr[NetaMemoStrNum] = info->name;
            sort_keys[NetaMemoStrNum] = info->sort_key;

            if (info->neta_id < INVENT_NETA_ID_SCOOP) {
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

    for (i = NetaMemoStrNum; i < 512; i++) {
        NetaMemoID[i] = 0;
        NetaMemoStr[i] = NULL;
    }
}

/**
 *
 * Writes the name of a photo's idea into a message window and centres it on a position, optionally with the idea mark.
 *
 */
static void MakeMsgNetaName(CDC2Mes *message, CMenuPosDataForm *form, USER_PICTURE_INFO *photo, int *pos, int show_mark) {
    char  blank[2] = " ";
    char *name = GetPhotoName(photo);
    int   offset_x = 6;

    if (name == NULL) {
        name = blank;
    }

    int message_no = 50;

    if (photo != NULL && photo->neta_id > 0 && show_mark == 1) {
        message_no = 601;

        if (photo->neta_id >= INVENT_NETA_ID_SCOOP) {
            message_no = 605;
        }

        offset_x = 0;
    }

    if (LanguageCode > LANG_JAPANESE) {
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
        SetSpriteEnv(prim, MENU_SPRITE_ENV_TEXTURE);
        prim->Bilinear(true);
        prim->Begin(MG_PRIM_SPRITE);
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
    SetSpriteEnv(prim, MENU_SPRITE_ENV_COLOR);
    prim->Shading(false);
    prim->AntiAliasing(true);
    prim->Begin(MG_PRIM_SPRITE);
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
        if (photo->neta_id >= INVENT_NETA_ID_SCOOP) {
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
    SetSpriteEnv(prim, MENU_SPRITE_ENV_TEXTURE);
    prim->AntiAliasing(true);
    prim->Bilinear(true);
    prim->AlphaTestEnable(false);
    prim->Begin(MG_PRIM_SPRITE);
    prim->Texture(tex);
    prim->Color(red, green, blue, alpha);
    prim->Direct(0x3B, 0x80 | (0x80UL << 32));
    put_rect.Set(x, y, w, h);
    PrimQuad(prim, put_rect, tex_rect);
    prim->End();
}

/**
 *
 * Draws the idea notebook icon at a screen position.
 *
 */
static void PictureMemoOne(float x, float y, int alpha) {
    mgCDrawPrim *prim;

    prim = GetMenuPrim();
    SetSpriteEnv(prim, MENU_SPRITE_ENV_TEXTURE);
    prim->Bilinear(true);
    prim->Begin(MG_PRIM_SPRITE);
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

    if (picture_no == INVENT_PICTURE_MEMO) {
        if (Tex_Hatsumei != NULL) {
            MenuReloadTexture(tex_block, Tex_Hatsumei->block);
            PictureMemoOne(rect.left, rect.top, rgba[3]);
        }
    } else {
        if (0 <= picture_no && picture_no < INVENT_PHOTO_NUM) {
            texture = CMenuInventPt->photo_tex[picture_no];
            photo = InventUserDataPtr->GetPhotoInfo(picture_no);
        } else if (picture_no >= INVENT_PICTURE_ALBUM && picture_no < INVENT_PICTURE_ALBUM + (int) INVENT_ALBUM_PHOTO_NUM) {
            picture_no -= INVENT_PICTURE_ALBUM;
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

    for (i = 0; i < INVENT_PHOTO_NUM; i++) {
        if (photos[i].used == 0 || CMenuInventPt->SelectedNetaPhotoAlready(i) != 0) {
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

        if (photo->is_new != 0) {
            SetSpriteEnv(prim, MENU_SPRITE_ENV_TEXTURE);
            prim->Begin(MG_PRIM_SPRITE);
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
    mgRect<int>        empty_rect;
    mgRect<int>        clip_rect;
    USER_PICTURE_INFO *photo;
    float              y;
    int                i;
    float              top;
    int                clip_top;

    empty_rect.Set(0, 0, 0, 0);
    top = 8.0f + origin[1];
    clip_top = (int) top;
    clip_rect.Set(0, clip_top, mgScreenWidth - 1, (int) ((270.0f + top) - 2.0f));
    MenuClipRectCheck(clip_rect);
    SetMenuScissor(clip_rect);
    photo = InventAlbumPtr->GetAlbumPhotoInfo(0);
    mgCTexture *first_texture = CMenuInventPt->album_tex[0];

    if (first_texture != NULL) {
        MenuReloadTexture(loaded_tex, first_texture->block);
        i = 0;
        y = CMenuInventPt->album_scroll_y;

        do {
            if (30.0f < y && photo != NULL && photo->used == 1) {
                PictureDraw(CMenuInventPt->album_tex[i], photo,
                            CMenuInventPt->album_scroll_x + 80.0f * (float) (i % 2), y, 0.7f, 0x80, 0x80,
                            0x80, 0x80);
            }

            if (i % 2 != 0) {
                y += 54.0f;
            }

            if (410.0f < y) {
                break;
            }

            i += 1;
            photo++;
        } while (i < INVENT_ALBUM_PHOTO_NUM);

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

    if (Tex_Hatsumei != NULL && !(origin[0] < -200.0f)) {
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
        SetSpriteEnv(prim, MENU_SPRITE_ENV_TEXTURE);
        prim->Begin(MG_PRIM_SPRITE);
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
        } while (i < 512);

        prim->End();
        ResetMenuScissor();
        bar_rect.Set(0x90, 0x166, 8, 0x1C);
        SetSpriteEnv(prim, MENU_SPRITE_ENV_TEXTURE);
        prim->Begin(MG_PRIM_SPRITE);
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

        while (i < pic_name_info_num && i < 512) {
            if (text_y >= clip_top - 0x28) {
                if (clip_bottom < text_y) {
                    break;
                }

                char *name = NetaMemoStr[i];

                if (name != NULL) {
                    short neta_id = NetaMemoID[i];
                    char *prefix;

                    if (neta_id < INVENT_NETA_ID_SCOOP) {
                        prefix = gaiji_table_4737[0];
                    } else if (neta_id < INVENT_NETA_ID_SCOOP_END) {
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
            text_y += 26;
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
    1, 1, 0, 0, 1, 1, 0};

inline CMenuInvent::CMenuInvent() {
    int i;
    card_cursor = card_top = 0;
    item_cursor = item_top = 0;
    photo_cursor = photo_top = 0;
    album_cursor = album_top = 0;
    memo_cursor = 0;
    memo_top = 0;
    card_scroll_dir = 0;
    album_open = false;

    for (i = 0; i < 3; i++) {
        neta_select_index[i] = -1;
        neta_select_type[i] = neta_select_state[i] = -1;
        neta_flash[i] = false;
    }

    neta_select_num = 0;
    neta_circle_angle = 0.0f;
    neta_circle_radius = 40.0f;
    create_success = false;
    create_item_id = 0;
    create_partial_match = -1;

    for (i = 0; i < 3; i++) {
        create_photo_neta[i] = 0;
    }

    create_missing_slot = -1;
    blink_time = 0;
    neta_circle_snap = false;
    neta_flash_angle = 0.0f;
    neta_effect_time = 0;
    album_scroll_reset = false;
    album_scroll_x = album_scroll_y = 0.0f;

    for (i = 0; i < INVENT_PHOTO_NUM; i++) {
        photo_tex[i] = NULL;
        photo_pos[i][0] = (i % 2) * 88 + 8;
        photo_pos[i][1] = (i / 2) * 54 + 104;
    }

    for (i = 0; i < INVENT_ALBUM_PHOTO_NUM; i++) {
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
    chara_load_step = INVENT_CHARA_LOAD_START;
    sub_chara = NULL;
    create_effect = NULL;
    create_chara = NULL;
    arrow_count = 0;
    photo_only = false;
    gradation_mode = INVENT_GRADATION_OFF;
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
    strcpy(icon_data[0].name, "dc2album.ico");
    strcpy(icon_data[1].name, "dc2album_c.ico");
    strcpy(icon_data[2].name, "dc2album_d.ico");
    Init_MENUFORM_MAKEBRD_INFO(&make_board);
}

int MenuInventInit(mgCMemory *memory, int *tex_block, int arg) {
    int size = memory->stGetSize();
    u8 *pack = memory->stGetBuffer();
    MenuInventStack.stSetBuffer((u_long128 *) pack, size);
    MenuInventStack.stAlloc64(memory->stGetUsed());
    mgCMemory *stack = &MenuInventStack;
    debug_invent_successflag = false;
    InventAlbumPtr = NULL;
    InventUserDataPtr = NULL;
    CMenuInventPt = new (stack->Alloc(align16_blocks(sizeof(CMenuInvent)) + 2)) CMenuInvent;
    CMenuInventPt->SetTexBlock(tex_block);
    InventUserDataPtr = GetInventUserDataPtr();
    InventManagePt = &InventManageMan;
    InventManagePt->Clear();

    if (MenuCommonInfo->open_type == MENU_OPEN_INVENT) {
        CMenuInventPt->photo_only = true;
    }

    MCManagerPtr = NULL;
    MenuBGReadInfo2Malloc(stack, tbl_4782);
    MenuActionChara[0] = new (stack->Alloc(align16_blocks(sizeof(CActionChara)) + 2)) CActionChara;
    MenuActionChara[1] = NULL;
    MenuActionChara[2] = NULL;
    MenuActionChara[3] = new (stack->Alloc(align16_blocks(sizeof(CActionChara)) + 2)) CActionChara;
    MenuActionChara[4] = new (stack->Alloc(align16_blocks(sizeof(CActionChara)) + 2)) CActionChara;
    MenuActionChara[5] = NULL;
    MenuActionChara[0]->Initialize(NULL);
    MenuActionChara[3]->Initialize(NULL);
    MenuActionChara[4]->Initialize(NULL);
    CMenuEffect *effect;

    if ((effect = (CMenuEffect *) operator new(sizeof(CMenuEffect),
                                               stack->Alloc(align16_blocks(sizeof(CMenuEffect)) + 2))) != NULL) {
        effect->Initialize();
    }

    MenuEffect[0] = effect;

    if ((effect = (CMenuEffect *) operator new(sizeof(CMenuEffect),
                                               stack->Alloc(align16_blocks(sizeof(CMenuEffect)) + 2))) != NULL) {
        effect->Initialize();
    }

    MenuEffect[1] = effect;
    MenuMoveItemPtr = new (stack->Alloc(align16_blocks(sizeof(CMenuMoveItem)) + 2)) CMenuMoveItem;
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
        u_int size = LoadFileMenu("photo_bg1.pac", stack->stGetTop(), 0);
        stack->Alloc(align16_blocks(size));
    }

    InventSubDataReadBGInfo = GetReadBGFile(0);
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
            CMenuInventPt->key_arg_no = INVENT_MODE_PHOTO_VIEW;
            MenuMainFrameModeSet(MENU_MAIN_FRAME_CLOSE, true);
            ReturnMenuIntern(1);
            MenuMesForm[0]->draw_flag = false;
            CMenuPosDataForm *image_form; image_form = MenuPosData->GetFormInfo("mainpureimage");

            if (image_form != NULL) {
                image_form->draw_flag = true;
                image_form->x = 0.0f;
                image_form->y = 0.0f;
            }

            CMenuInventPt->GradationSet(INVENT_GRADATION_OFF);
            break;
        case 0:
            CMenuInventPt->key_arg_no = INVENT_MODE_CARD_LIST;
            CMenuInventPt->ExeScript("\x92\xca\x8f\xed\x82\xcc\x82\xdd\x8f\x89\x8a\xfa\x89\xbb");
            CMenuInventPt->poly_chr_form[0]->counter = 0;
            CMenuInventPt->ExeScript("\x8d\x6c\x82\xa6\x83\x82\x81\x5b\x83\x68"
                                     "0");
            CMenuInventPt->PrepareNextMode(CMenuInventPt->key_arg_no);
            CMenuInventPt->GradationSet(INVENT_GRADATION_OFF);
            MenuMainFrameModeSet(MENU_MAIN_FRAME_LEAVE_DOWN, true);
            SetSpectolInfo(NULL, NULL);
            break;
    }

    MenuCamInit(1.0f);
    itemmenu_chr_rotflag = true;

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
    MenuItemBrdSetInfo(menu->item_cursor, menu->item_top, GetNowBagMax(ITEM_BOARD_MAIN) / 6, 5);
    MenuCommonInfo->cursor = 0;
    MenuCommonInfo->key_enable = false;
    MenuCommonInfo->SetWakuType(-1);
    MenuCommonInfo->SetWakuWH(0, 0x20, 0x20);
    CheckEnableHaveItemNum();
    InventInNetaEffectFlag = false;
    InitMenuDl(NULL, 0);
    SetModeMenuDrawItemBoard(MENU_ITEM_BOARD_BAG);
    return 1;
}

void CMenuInvent::NextDifferentMode(int next, int arg) {
    switch (next) {
        case INVENT_MODE_THINK:
        case INVENT_MODE_THINK_ALBUM_BUTTON:
            break;
        case INVENT_MODE_CARD_LIST:
            if (MenuCommonInfo->have_item.item_no > 0) {
                next = INVENT_MODE_ITEM_LIST;
                break;
            }

            if (this->key_arg_no == INVENT_MODE_ITEM_LIST) {
                MenuMesForm[0]->SetAction("\x8d\xb6\x89\xba\x82\xd6");
                this->CreateModeSwapForm(0);
            }

            break;
        case INVENT_MODE_ITEM_LIST:
            this->CreateModeSwapForm(1);
            MenuMesForm[0]->SetAction("\x92\x86\x82\xd6");
            this->item_cursor = (this->item_top + (this->card_cursor - this->card_top)) * 6;
            break;
        case INVENT_MODE_THINK_WITH_ALBUM: {
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
        case INVENT_MODE_ALBUM_VIEW:
        case INVENT_MODE_PHOTO_VIEW:
        case INVENT_MODE_PHOTO_ALBUM_BUTTON:
            break;
        case INVENT_MODE_MEMO_BUTTON:
            this->ExeScript("\x83\x6c\x83\x5e\x92\x50\x8c\xea\x83\x8a\x83\x58\x83\x67OFF");
            break;
        case INVENT_MODE_MEMO_LIST:
            break;
    }

    MenuSePlay(SYSTEM_SE_CURSOR);
    this->key_arg_no = next;
}

/**
 *
 * Handles the debug keys of the idea board: adding photos of any idea, learning every idea, levelling photos and marking inventions made.
 *
 */
static int MenuInventDebugKey() {
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
                        photo->used = true;
                        photo->is_new = true;
                        photo->neta_id = pic_name_info_top[debug_invent_select].neta_id;
                        photo->map_no = -1;
                        photo->npc_no = -1;
                        photo->monster_no = -1;
                        photo->unk_8 = -1;
                        memset(photo->image, 0, 0x2000);
                        MenuSePlay(SYSTEM_SE_DECIDE);
                    } else {
                        MenuSePlay(SYSTEM_SE_CANCEL);
                    }

                    break;
                }
                case MENU_PUSH_BUTTON_TRIANGLE:
                    for (int i = 0; i < pic_name_info_num; i++) {
                        GetInventUserDataPtr()->SetNetaFlag(pic_name_info_top[i].neta_id);
                    }

                    break;
                case MENU_PUSH_BUTTON_SQUARE:
                    for (int i = 0; i < INVENT_PHOTO_NUM; i++) {
                        InventUserDataPtr->LevelCheck(&InventUserDataPtr->photo[i]);
                    }

                    MenuSePlay(SYSTEM_SE_DECIDE);
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

/**
 *
 * Draws the idea list of the debug keys and the created model's scale and position.
 *
 */
static void MenuInventDebugDraw() {
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

/**
 *
 * Handles the direction keys and buttons on the current page of the invention menu.
 *
 */
static int MenuInventPushKey(int pad, int pushed) {
    int mode = CMenuInventPt->key_arg_no;

    if (CMenuInventPt->mode <= 0) {
        if (menu_debug_flag != 0) {
            MenuInventDebugKey();
            return 0;
        }

        int         leave = false;
        int         command = INVENT_KEY_COMMAND_NONE;
        signed char lock = CMenuInventPt->chara_load_step;

        if (lock == INVENT_CHARA_LOAD_START || lock == INVENT_CHARA_LOAD_WAIT) {
            pushed = 0;
        }

        int mode_changed = false;

        switch (mode) {
            case INVENT_MODE_THINK:
            case INVENT_MODE_THINK_WITH_ALBUM:
            case INVENT_MODE_PHOTO_VIEW: {
                int overcode[4] = {0, 0, 0, 2};

                if (CMenuInventPt->album_enable == 0) {
                    overcode[3] = 0;
                }

                int old_cursor = CMenuInventPt->photo_cursor;

                if ((pad & MENU_SELECT_KEY_UP) && old_cursor / 2 == 0) {
                    CMenuInventPt->NextDifferentMode(INVENT_MODE_MEMO_ARROW, 0);
                } else {
                    int result =
                        MenuGlidKeyCheck(pad, &CMenuInventPt->photo_cursor, &CMenuInventPt->photo_top,
                                         maxtbl_5171, viewnum_5172, overcode, INVENT_PHOTO_NUM);

                    if (old_cursor != CMenuInventPt->photo_cursor) {
                        MenuSePlay(SYSTEM_SE_CURSOR);
                    }

                    if (result == 2) {
                        CMenuInventPt->NextDifferentMode(nextmodetbl_5183[CMenuInventPt->key_arg_no], 0);
                        mode_changed = true;
                    }
                }

                break;
            }
            case INVENT_MODE_THINK_ALBUM_BUTTON:
            case INVENT_MODE_PHOTO_ALBUM_BUTTON:
                if (pad & MENU_SELECT_KEY_LEFT) {
                    if (CMenuInventPt->photo_only == 1) {
                        CMenuInventPt->NextDifferentMode(INVENT_MODE_PHOTO_VIEW, 0);
                    } else {
                        CMenuInventPt->NextDifferentMode(INVENT_MODE_THINK, 0);
                    }

                    mode_changed = true;
                }

                break;
            case INVENT_MODE_CARD_LIST: {
                int old_row = CMenuInventPt->card_top;
                int old_cursor = CMenuInventPt->card_cursor;
                int count = CMenuInventPt->EnableSelectMaxCardList();
                int jump = 0;

                if ((pad & MENU_SELECT_KEY_L1) || (pad & MENU_SELECT_KEY_L2)) {
                    jump = -8;
                } else if ((pad & MENU_SELECT_KEY_R1) || (pad & MENU_SELECT_KEY_R2)) {
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

                    if (pad & MENU_SELECT_KEY_RIGHT) {
                        CMenuInventPt->NextDifferentMode(INVENT_MODE_ITEM_LIST, 0);
                        mode_changed = true;
                    }
                }

                if (old_cursor != CMenuInventPt->card_cursor) {
                    MenuSePlay(SYSTEM_SE_CURSOR);
                }

                int new_row = CMenuInventPt->card_top;

                if (old_row != new_row) {
                    if (old_row < new_row) {
                        CMenuInventPt->card_scroll_dir = true;
                    } else {
                        CMenuInventPt->card_scroll_dir = false;
                    }
                }

                if (menu_debug_flag != 0) {
                    int debug_pushed;
                    int held;
                    MenuCommonInfo->GetDebugInputKey(held, debug_pushed);

                    if (debug_pushed & MENU_PUSH_BUTTON_TRIANGLE) {
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
                    mode_changed = true;
                }

                break;
            case INVENT_MODE_ALBUM_VIEW: {
                int old_cursor = CMenuInventPt->album_cursor;
                int result = MenuGlidKeyCheck(pad, &CMenuInventPt->album_cursor,
                                              &CMenuInventPt->album_top, maxtbl_album_5223,
                                              viewnum_album_5224, overcode_album_5225, INVENT_ALBUM_PHOTO_NUM);

                if (old_cursor != CMenuInventPt->album_cursor) {
                    MenuSePlay(SYSTEM_SE_CURSOR);
                }

                if (result == 2) {
                    CMenuInventPt->NextDifferentMode(INVENT_MODE_THINK_WITH_ALBUM, 0);
                    mode_changed = true;
                }

                break;
            }
            case INVENT_MODE_MEMO_ARROW:
                if (pad & MENU_SELECT_KEY_UP) {
                    CMenuInventPt->NextDifferentMode(INVENT_MODE_MEMO_BUTTON, 0);
                } else if (pad & MENU_SELECT_KEY_DOWN) {
                    int next = INVENT_MODE_THINK;

                    if (CMenuInventPt->photo_only == 1) {
                        next = INVENT_MODE_PHOTO_VIEW;
                    }

                    if (CMenuInventPt->album_open == 1) {
                        next = INVENT_MODE_THINK_WITH_ALBUM;
                    }

                    CMenuInventPt->NextDifferentMode(next, 0);
                    mode_changed = true;
                }

                break;
            case INVENT_MODE_MEMO_BUTTON:
                if (pad & MENU_SELECT_KEY_DOWN) {
                    CMenuInventPt->NextDifferentMode(INVENT_MODE_MEMO_ARROW, 0);
                }

                break;
            case INVENT_MODE_MEMO_CORK:
                if (pad & MENU_SELECT_KEY_DOWN) {
                    CMenuInventPt->NextDifferentMode(INVENT_MODE_MEMO_LIST, 0);
                }

                break;
            case INVENT_MODE_MEMO_LIST: {
                int move = 0;

                if (pad & MENU_SELECT_KEY_UP) {
                    move -= 1;
                }

                if (pad & MENU_SELECT_KEY_DOWN) {
                    move += 1;
                }

                if ((pad & MENU_SELECT_KEY_L1) || (pad & MENU_SELECT_KEY_L2)) {
                    move -= 8;
                    CMenuInventPt->memo_scroll_reset = true;
                }

                if ((pad & MENU_SELECT_KEY_R1) || (pad & MENU_SELECT_KEY_R2)) {
                    move += 8;
                    CMenuInventPt->memo_scroll_reset = true;
                }

                int old_cursor = CMenuInventPt->memo_cursor;
                CMenuInventPt->memo_cursor = old_cursor + move;
                int at_start = false;

                if (CMenuInventPt->memo_cursor < 0) {
                    CMenuInventPt->memo_cursor = 0;
                    at_start = true;
                }

                int last = pic_name_info_num - 1;

                if (last < CMenuInventPt->memo_cursor) {
                    CMenuInventPt->memo_cursor = last;
                }

                MenuCheckLine(&CMenuInventPt->memo_top, CMenuInventPt->memo_cursor, 9);

                if (at_start != 0) {
                    CMenuInventPt->NextDifferentMode(INVENT_MODE_MEMO_CORK, 0);
                } else if (old_cursor != CMenuInventPt->memo_cursor) {
                    MenuSePlay(SYSTEM_SE_CURSOR);
                }

                break;
            }
        }

        if (mode != CMenuInventPt->key_arg_no) {
            mode_changed = true;
        }

        int                swap_slot = CMenuInventPt->item_cursor;
        CGameDataUsed     *item = &MenuUserParam.used_data[swap_slot];
        MENU_SWAPITEM_INFO swap_info;
        swap_info.Set(MENU_SWAP_TYPE_INVENT_ITEM, swap_slot, -1, 0);
        int next_mode = -1;

        if (mode_changed == 0) {
            switch (CMenuInventPt->key_arg_no) {
                case INVENT_MODE_THINK:
                case INVENT_MODE_PHOTO_VIEW: {
                    USER_PICTURE_INFO *photo =
                        InventUserDataPtr->GetPhotoInfo(CMenuInventPt->photo_cursor);

                    switch (pushed) {
                        case MENU_PUSH_BUTTON_TRIANGLE:
                            command = INVENT_KEY_COMMAND_SET_IDEA;

                            if (CMenuInventPt->photo_only == 1) {
                                command = INVENT_KEY_COMMAND_IGNORE;
                            }

                            break;
                        case MENU_PUSH_BUTTON_CANCEL:
                            next_mode = INVENT_MODE_CARD_LIST;
                            command = INVENT_KEY_COMMAND_REMOVE_IDEA;

                            if (CMenuInventPt->photo_only == 1) {
                                command = INVENT_KEY_COMMAND_LEAVE;
                            }

                            break;
                        case MENU_PUSH_BUTTON_SQUARE:
                            command = INVENT_KEY_COMMAND_THINK;

                            if (CMenuInventPt->neta_select_num < 3) {
                                command = INVENT_KEY_COMMAND_REJECT;
                            }

                            if (CMenuInventPt->photo_only == 1) {
                                command = INVENT_KEY_COMMAND_IGNORE;
                            }

                            break;
                        case MENU_PUSH_BUTTON_DECIDE:
                            if (CMenuInventPt->SelectedNetaPhotoAlready(
                                    CMenuInventPt->photo_cursor) == 0 &&
                                photo->used != 0) {
                                command = INVENT_KEY_COMMAND_EXTEND;
                                MenuItemCmdArgPos = 5;
                            }

                            break;
                        case MENU_PUSH_BUTTON_SELECT:
                            command = INVENT_KEY_COMMAND_SORT_PHOTOS;
                            break;
                    }

                    break;
                }
                case INVENT_MODE_THINK_ALBUM_BUTTON:
                case INVENT_MODE_PHOTO_ALBUM_BUTTON:
                    switch (pushed) {
                        case MENU_PUSH_BUTTON_DECIDE:
                            CMenuInventPt->ExeScript("IS_MCACCESS");

                            if (LanguageCode > LANG_JAPANESE && LanguageCode < LANG_CHINESE) {
                                MenuDCMsg[4]->SetMsgCursor(1);
                                MenuDCMsg[4]->select_top = 1;
                            }

                            CMenuInventPt->mode = MENU_ASK_MODE_ALBUM_ACCESS;
                            CMenuInventPt->step = INVENT_ALBUM_STEP_SLOT_SELECT;
                            CMenuInventPt->album_save_mode = INVENT_ALBUM_LOAD;
                            CMenuInventPt->album_open = true;
                            break;
                        case MENU_PUSH_BUTTON_CANCEL:
                            next_mode = INVENT_MODE_CARD_LIST;
                            command = INVENT_KEY_COMMAND_REMOVE_IDEA;

                            if (CMenuInventPt->photo_only == 1) {
                                command = INVENT_KEY_COMMAND_LEAVE;
                            }

                            break;
                    }

                    break;
                case INVENT_MODE_CARD_LIST:
                    switch (pushed) {
                        case MENU_PUSH_BUTTON_DECIDE:
                        case MENU_PUSH_BUTTON_TRIANGLE:
                        case MENU_PUSH_BUTTON_SQUARE:
                            if (MenuCommonInfo->have_item.item_no > 0) {
                                command = INVENT_KEY_COMMAND_REJECT;
                            } else {
                                command = INVENT_KEY_COMMAND_MAKE;
                            }

                            break;
                        case MENU_PUSH_BUTTON_CANCEL:
                            command = INVENT_KEY_COMMAND_LEAVE;
                            break;
                    }

                    break;
                case INVENT_MODE_ITEM_LIST:
                    switch (pushed) {
                        case MENU_PUSH_BUTTON_TRIANGLE:
                            command = INVENT_KEY_COMMAND_SWAP_ITEM;
                            break;
                        case MENU_PUSH_BUTTON_CANCEL:
                            command = INVENT_KEY_COMMAND_RETURN_HELD;
                            break;
                        case MENU_PUSH_BUTTON_DECIDE:
                            command = INVENT_KEY_COMMAND_ITEM_COMMAND;
                            break;
                        case MENU_PUSH_BUTTON_SQUARE:
                            command = INVENT_KEY_COMMAND_GET_ITEM_ALL;
                            break;
                    }

                    break;
                case INVENT_MODE_THINK_WITH_ALBUM:
                    switch (pushed) {
                        case MENU_PUSH_BUTTON_TRIANGLE:
                            break;
                        case MENU_PUSH_BUTTON_CANCEL:
                            command = INVENT_KEY_COMMAND_SAVE_ALBUM;
                            break;
                        case MENU_PUSH_BUTTON_DECIDE:
                            command = INVENT_KEY_COMMAND_EXTEND;
                            MenuItemCmdArgPos = 5;
                            break;
                    }

                    break;
                case INVENT_MODE_ALBUM_VIEW:
                    switch (pushed) {
                        case MENU_PUSH_BUTTON_TRIANGLE:
                        case MENU_PUSH_BUTTON_SQUARE:
                            command = INVENT_KEY_COMMAND_REJECT;
                            break;
                        case MENU_PUSH_BUTTON_CANCEL:
                            command = INVENT_KEY_COMMAND_SAVE_ALBUM;
                            break;
                        case MENU_PUSH_BUTTON_DECIDE:
                            command = INVENT_KEY_COMMAND_EXTEND;
                            MenuItemCmdArgPos = 6;
                            break;
                        case MENU_PUSH_BUTTON_SELECT:
                            command = INVENT_KEY_COMMAND_SORT_PHOTOS;
                            break;
                    }

                    break;
                case INVENT_MODE_MEMO_ARROW:
                    if ((pushed & MENU_PUSH_BUTTON_DECIDE) || (pushed & MENU_PUSH_BUTTON_TRIANGLE)) {
                        command = INVENT_KEY_COMMAND_LEARN_IDEAS;
                    } else if (pushed & MENU_PUSH_BUTTON_CANCEL) {
                        command = INVENT_KEY_COMMAND_REMOVE_IDEA;
                        next_mode = INVENT_MODE_CARD_LIST;

                        if (CMenuInventPt->photo_only == 1) {
                            command = INVENT_KEY_COMMAND_LEAVE;
                        }

                        if (CMenuInventPt->album_open == 1) {
                            command = INVENT_KEY_COMMAND_SAVE_ALBUM;
                        }
                    }

                    break;
                case INVENT_MODE_MEMO_BUTTON:
                    switch (pushed) {
                        case MENU_PUSH_BUTTON_DECIDE:
                        case MENU_PUSH_BUTTON_TRIANGLE:
                            command = INVENT_KEY_COMMAND_OPEN_MEMO;
                            MenuSePlay(SYSTEM_SE_DECIDE);
                            break;
                        case MENU_PUSH_BUTTON_CANCEL:
                            next_mode = INVENT_MODE_CARD_LIST;
                            command = INVENT_KEY_COMMAND_REMOVE_IDEA;

                            if (CMenuInventPt->photo_only == 1) {
                                command = INVENT_KEY_COMMAND_LEAVE;
                            }

                            if (CMenuInventPt->album_open == 1) {
                                CMenuInventPt->mode = MENU_ASK_MODE_ALBUM_ACCESS;
                                CMenuInventPt->step = INVENT_ALBUM_STEP_SAVE_SLOT_SELECT;
                                CMenuInventPt->album_save_mode = INVENT_ALBUM_SAVE;
                                command = INVENT_KEY_COMMAND_IGNORE;
                                CMenuInventPt->ExeScript("SAVE_SLOTSEL");
                            }

                            break;
                    }

                    break;
                case INVENT_MODE_MEMO_CORK:
                    if ((pushed & MENU_PUSH_BUTTON_DECIDE) || (pushed & MENU_PUSH_BUTTON_TRIANGLE)) {
                        command = INVENT_KEY_COMMAND_CLOSE_MEMO;
                        MenuSePlay(SYSTEM_SE_DECIDE);
                    } else if (pushed & MENU_PUSH_BUTTON_CANCEL) {
                        command = INVENT_KEY_COMMAND_BACK;
                        next_mode = INVENT_MODE_MEMO_BUTTON;
                    }

                    break;
                case INVENT_MODE_MEMO_LIST:
                    switch (pushed) {
                        case MENU_PUSH_BUTTON_DECIDE:
                        case MENU_PUSH_BUTTON_TRIANGLE:
                            command = INVENT_KEY_COMMAND_SET_IDEA;

                            if (CMenuInventPt->photo_only == 1 ||
                                CMenuInventPt->album_open == 1) {
                                command = INVENT_KEY_COMMAND_REJECT;
                            }

                            break;
                        case MENU_PUSH_BUTTON_SQUARE:
                            command = INVENT_KEY_COMMAND_THINK;

                            if (CMenuInventPt->neta_select_num < 3) {
                                command = INVENT_KEY_COMMAND_REJECT;
                            }

                            if (CMenuInventPt->photo_only == 1) {
                                command = INVENT_KEY_COMMAND_IGNORE;
                            }

                            break;
                        case MENU_PUSH_BUTTON_CANCEL:
                            command = INVENT_KEY_COMMAND_BACK;
                            next_mode = INVENT_MODE_MEMO_BUTTON;
                            break;
                    }

                    break;
            }
        }

        CDC2Mes *message = MenuDCMsg[4];

        switch (command) {
            case INVENT_KEY_COMMAND_REJECT:
                MenuSePlay(SYSTEM_SE_CANCEL);
                break;
            case INVENT_KEY_COMMAND_ITEM_COMMAND:
                CMenuInventPt->MenuItemMoveItemCommand(item, 4, 5,
                                                       MenuMesForm[5], 0);
                break;
            case INVENT_KEY_COMMAND_SWAP_ITEM:
                if (CMenuInventPt->CheckSpectolFusion(item, 5, MenuMesForm[5]) != 0) {
                    CMenuPosDataForm *form = MenuCommonInfo->cursor_form;

                    if (form != NULL) {
                        form->draw_flag = 0;
                    }

                    MenuSePlay(SYSTEM_SE_DECIDE);
                } else {
                    switch (MenuCommonInfo->EnableSwapNowPos(&swap_info)) {
                        case 0:
                            MenuSePlay(menu_item_swap_sndtbl[MenuCommonInfo->MenuSwapItem(
                                item, &swap_info, 1, 1)]);
                            break;
                        case 1:
                        case 2:
                        case 9:
                            MenuSePlay(SYSTEM_SE_CANCEL);
                            break;
                        case 4:
                            CMenuInventPt->SetAskHowMuchItemNum(&swap_info, item);
                            MenuSePlay(SYSTEM_SE_DECIDE);
                            break;
                        default:
                            MenuSePlay(SYSTEM_SE_CANCEL);
                            break;
                    }
                }

                break;
            case INVENT_KEY_COMMAND_GET_ITEM_ALL:
                MenuCommonInfo->GetItemAll(item, &swap_info);
                break;
            case INVENT_KEY_COMMAND_SORT_PHOTOS:
                if (0 < CMenuInventPt->neta_select_num) {
                    MenuSePlay(SYSTEM_SE_CANCEL);
                } else {
                    if (CMenuInventPt->key_arg_no == INVENT_MODE_ALBUM_VIEW) {
                        USER_PICTURE_INFO *album_photo = InventAlbumPtr->GetAlbumPhotoInfo(0);
                        PictureSeiton(album_photo, (char *) InventAlbumPtr, INVENT_ALBUM_PHOTO_NUM);
                        InventAlbumPtr->RelateAlbumPicData();
                        AttachPictTex(CMenuInventPt->tex_block[4], CMenuInventPt->album_tex, album_photo,
                                      50);
                    } else {
                        USER_PICTURE_INFO *photo = InventUserDataPtr->GetPhotoInfo(0);
                        PictureSeiton(photo, InventUserDataPtr->GetPhototWorkAdr(), INVENT_PHOTO_NUM);
                        InventUserDataPtr->ResetAddress();
                        AttachPictTex(CMenuInventPt->tex_block[3], CMenuInventPt->photo_tex, photo,
                                      30);
                    }

                    MenuSePlay(SYSTEM_SE_DECIDE);
                }

                break;
            case INVENT_KEY_COMMAND_UNUSED:
                break;
            case INVENT_KEY_COMMAND_SET_IDEA: {
                int index = CMenuInventPt->photo_cursor;
                int source = INVENT_NETA_SOURCE_PHOTO;

                if (CMenuInventPt->key_arg_no == INVENT_MODE_MEMO_LIST) {
                    index = CMenuInventPt->memo_cursor;
                    source = INVENT_NETA_SOURCE_MEMO;
                }

                if (CMenuInventPt->SetNetaCircle(source, index) <= 0) {
                    MenuSePlay(SYSTEM_SE_CANCEL);
                } else {
                    MenuSePlay(12);
                }

                break;
            }
            case INVENT_KEY_COMMAND_LEARN_IDEAS: {
                CMenuInventPt->mode = MENU_ASK_MODE_PHOTO_NETA;

                while (CMenuInventPt->CancelNetaCircle(0) >= 0) {
                }

                InventInNetaEffectNum = 0;
                int i = 0;

                do {
                    CMenuInventPt->new_neta_photo[i] = false;
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
                            CMenuInventPt->new_neta_photo[i] = true;
                            InventInNetaEffectNum += 1;
                        }
                    }

                    i += 1;
                } while (i < INVENT_PHOTO_NUM);

                if (InventInNetaEffectNum <= 0) {
                    CMenuInventPt->ExeScript("\x83\x6c\x83\x5e\x8a\xf9\x93\x6f\x98\x5e");
                    CMenuInventPt->step = INVENT_NETA_ENTER_NOTHING;
                } else {
                    CMenuInventPt->ExeScript("\x83\x6c\x83\x5e\x93\x6f\x98\x5e\x81\x48");
                    CMenuInventPt->step = INVENT_NETA_ENTER_ASK;
                }

                break;
            }
            case INVENT_KEY_COMMAND_REMOVE_IDEA:
                if (CMenuInventPt->CancelNetaCircle(5) < 0) {
                    if (CMenuInventPt->key_arg_no == INVENT_MODE_PHOTO_VIEW) {
                        leave = true;
                    } else {
                        CMenuInventPt->InitNetaCircle(0);
                        CMenuInventPt->PrepareNextMode(next_mode);
                    }
                }

                MenuSePlay(SYSTEM_SE_CANCEL);
                break;
            case INVENT_KEY_COMMAND_BACK:
                if (CMenuInventPt->CancelNetaCircle(5) < 0) {
                    CMenuInventPt->NextDifferentMode(next_mode, 0);
                } else {
                    MenuSePlay(SYSTEM_SE_CANCEL);
                }

                break;
            case INVENT_KEY_COMMAND_RETURN_HELD: {
                MENU_SWAPITEM_INFO held_info;
                held_info.Set(MENU_SWAP_TYPE_NONE, 0, -1, 0);
                memcpy(&held_info, &MenuCommonInfo->have_swap, sizeof(held_info));
                CGameDataUsed *source = GetGameDataUsedForSWAPINFO(&held_info);
                CGameDataUsed  source_copy;
                CGameDataUsed  held_copy;

                source_copy.CopyGameData(source);
                held_copy.CopyGameData((CGameDataUsed *) &MenuCommonInfo->have_item);
                int result = MenuCommonInfo->ReturnItemMenu(1);

                if (result == 0) {
                    leave = true;
                    MenuSePlay(SYSTEM_SE_CANCEL);
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
            case INVENT_KEY_COMMAND_LEAVE: {
                int result = MenuCommonInfo->ReturnItemMenu(0);

                if (result == 0) {
                    leave = true;
                    MenuSePlay(SYSTEM_SE_CANCEL);
                } else if (0 < result) {
                    MenuSePlay(menu_item_swap_sndtbl[result]);
                }

                break;
            }
            case INVENT_KEY_COMMAND_THINK: {
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
                CMenuInventPt->mode = MENU_ASK_MODE_CREATE;
                CMenuInventPt->create_load_state = INVENT_CREATE_LOAD_STOPPED;

                if (InventUserDataPtr->IsAlreadyCreatedItem(CMenuInventPt->create_item_id) >= 0) {
                    CMenuInventPt->step = INVENT_CREATE_STEP_AFTER;
                    CMenuInventPt->ExeScript("\x94\xad\x96\xbe\x8d\xcf\x82\xdd");
                    char *item_name[1] = {NULL};
                    item_name[0] = GetItemMessage(CMenuInventPt->create_item_id);
                    message->SetMsgItemNo(item_name, 1);
                } else {
                    CMenuInventPt->ExeScript("\x94\xad\x96\xbe\x82\xb7\x82\xe9\x81\x48");
                }

                break;
            }
            case INVENT_KEY_COMMAND_MAKE: {
                int item_id = InventUserDataPtr->GetCreateItemID(CMenuInventPt->card_cursor);
                MenuSePlay(SYSTEM_SE_DECIDE);

                if (item_id <= 0) {
                    CMenuInventPt->PrepareNextMode(INVENT_MODE_THINK);
                } else {
                    CMenuInventPt->make_item_no = item_id;
                    CMenuInventPt->make_num = 1;
                    CMenuInventPt->make_material =
                        &InventManagePt->GetInventDataInfoByItemID(item_id)->materials;
                    CMenuInventPt->mode = MENU_ASK_MODE_MAKE;
                    CMenuInventPt->step = INVENT_MAKE_STEP_SELECT;
                    CMenuInventPt->make_cursor = 1;
                    CDataCommon *common = GetCommonItemData(CMenuInventPt->make_item_no);
                    CMenuInventPt->make_num_max = 1;

                    if (common != NULL) {
                        CMenuInventPt->make_num_max = common->max_num;
                    }

                    int owned = GetUserDataMan()->GetNumSameItem(item_id);
                    CMenuInventPt->make_num_max = CMenuInventPt->make_num_max - owned;

                    if (CMenuInventPt->make_num_max <= 0) {
                        CMenuInventPt->step = INVENT_MAKE_STEP_ERROR;
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
            case INVENT_KEY_COMMAND_EXTEND:
                CMenuInventPt->BootExtendCommand();
                break;
            case INVENT_KEY_COMMAND_OPEN_MEMO:
                CMenuInventPt->ExeScript("\x83\x6c\x83\x5e\x92\x50\x8c\xea\x83\x8a\x83\x58\x83\x67");
                CMenuInventPt->UpdataNetaMemoStr();
                CMenuInventPt->key_arg_no = INVENT_MODE_MEMO_CORK;
                break;
            case INVENT_KEY_COMMAND_CLOSE_MEMO:
                CMenuInventPt->ExeScript("\x83\x6c\x83\x5e\x92\x50\x8c\xea\x83\x8a\x83\x58\x83\x67OFF");
                CMenuInventPt->key_arg_no = INVENT_MODE_MEMO_BUTTON;
                break;
            case INVENT_KEY_COMMAND_SAVE_ALBUM:
                CMenuInventPt->mode = MENU_ASK_MODE_ALBUM_ACCESS;
                CMenuInventPt->step = INVENT_ALBUM_STEP_SAVE_SLOT_SELECT;
                CMenuInventPt->album_save_mode = INVENT_ALBUM_SAVE;
                CMenuInventPt->ExeScript("SAVE_SLOTSEL");
                MenuSePlay(SYSTEM_SE_CANCEL);
                break;
        }

        if (leave != 0) {
            CMenuInventPt->mode = MENU_ASK_MODE_CLOSE;

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
                MenuMainFrameModeSet(MENU_MAIN_FRAME_RETURN_DOWN, false);
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
                CMenuInventPt->opened = true;
                CMenuInventPt->fade_alpha = 0x80;
            }

            break;
        case MENU_ASK_MODE_CLOSE:
            if ((CMenuInventPt->photo_only == 0 && GetMenuMainFrameEndFlag() != 0) ||
                (CMenuInventPt->photo_only == 1 && CalcMenuAdd(&CMenuInventPt->fade_alpha, -8, 0) != 0)) {
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
                        MenuMesForm[7]->draw_flag = true;
                        name_message->line_pos_on[0] = 0;
                        MakeMsgNetaName(name_message, MenuMesForm[7],
                                        InventAlbumPtr->GetAlbumPhotoInfo(CMenuInventPt->album_cursor), item_pos, 1);
                    }
                } else if (key != INVENT_MODE_PHOTO_VIEW && CMenuInventPt->album_open == 0 && CMenuInventPt->photo_only == 0) {
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

