#include "common.h"
#include "inventmn.hpp"
#include <cstring>
#include "mainloop.hpp"
#include "savedata.hpp"
#include "menucommon.hpp"
#include "menumain.hpp"
#include "scriptinterpreter.hpp"
#include "npccfg.hpp"
#include "menuchr.hpp"
#include "mapselect.hpp"
#include "dataread.hpp"
#include "actionchara.hpp"
#include "mg_texture.hpp"
#include "nd_meswin.hpp"
#include "menucls1.hpp"
#include "font.hpp"
#include "mglib.hpp"
#include "menuaqua.hpp"
#include "menusystemdata.hpp"
#include <cstdio>
#include "menuop.hpp"
#include "menusys.hpp"
#include "mg_dataset.hpp"
#include "sound.hpp"
#include "snd_mngr.hpp"
#include "gamepad.hpp"
#include "mg_math.hpp"
#include <cmath>

struct GridOverCode { int value[4]; };
struct ModelTriple { CActionChara *model[3]; };
struct ItemNameList1 { char *name[1]; };
struct ItemNameList5 { char *name[5]; };
struct CursorPos { int x; int y; };
struct RecordBoardMsgTypes { int v[5]; };
struct GradationSteps { int v[3]; };
struct GradeRows { signed char v[2]; };
extern CMenuInvent *CMenuInventPt;
extern CInventUserData *InventUserDataPtr;
extern CDC2AlbumData *InventAlbumPtr;
extern int menu_debug_flag;
extern signed char InventInNetaEffectNum;
extern short MenuItemCmdArgPos;
extern int maxtbl_5171;
extern int viewnum_5172;
extern GridOverCode at_5173;
extern short nextmodetbl_5183[];
extern char *gaiji_table_4737[3];
extern int maxtbl_album_5223;
extern int viewnum_album_5224;
extern int overcode_album_5225[];
extern short menu_item_swap_sndtbl[];
extern ItemNameList1 at_5448;
extern ItemNameList1 at_5457;
extern ItemNameList5 at_5460;
extern ModelTriple at_5474;
extern RecordBoardMsgTypes at_2455;
extern int rec_board_offset_xtbl[10];
extern GradationSteps at_2639;
extern unsigned char invent_color_tbl[3][2][4];
extern char *invent_grade_fff[2];
extern GradeRows at_2562;
extern mgCTexture *Tex_Hatsumei;
extern unsigned int InventSubDataReadBGInfo;
extern mgCMemory MenuInventStack;
extern CActionChara *MenuActionChara[7];
extern short NetaMemoID[512];
extern int NetaMemoStr[512];
extern short NetaMemoStrNum;
extern CMenuPosDataForm *GiftBoxViewForm;
extern "C" int fptosi(float);
extern "C" void *__ct__9CMenuFontFv(void *);
extern "C" int neta_sort__FiiiPi(int, int, int);
enum { K_COMMAND_HANDLED = -1 };
enum { K_COMMAND_NONE = 0 };
enum { K_COMMAND_REJECT = 5 };
enum { K_COMMAND_ITEM_COMMAND = 10 };
enum { K_COMMAND_SWAP_ITEM = 20 };
enum { K_COMMAND_GET_ITEM_ALL = 30 };
enum { K_COMMAND_TAKE_PHOTO = 40 };
enum { K_COMMAND_UNUSED = 50 };
enum { K_COMMAND_SWAP_BACK = 52 };
enum { K_COMMAND_RETURN_ITEM = 54 };
enum { K_COMMAND_SET_CIRCLE = 60 };
enum { K_COMMAND_LEAVE_CIRCLE = 65 };
enum { K_COMMAND_BACK_MODE = 66 };
enum { K_COMMAND_CHECK_IDEAS = 70 };
enum { K_COMMAND_PICK_CREATED = 80 };
enum { K_COMMAND_EXTEND = 90 };
enum { K_COMMAND_CONFIRM_BOARD = 91 };
enum { K_COMMAND_OPEN_MEMO = 100 };
enum { K_COMMAND_CLOSE_MEMO = 105 };
enum { K_COMMAND_QUIT = 110 };
extern char at_1046__2[];
struct NetaFoundFlags { s8 flag[3]; };
extern NetaFoundFlags at_1965;
extern char at_2124__2[];
extern char at_2125__3[];
extern char at_2126__3[];
extern char at_2127__2[];
extern char at_2128__3[];
extern char at_2129__2[];
extern char at_2130__2[];
extern char at_2131__2[];
extern char at_2132__2[];
extern char at_2133__2[];
extern char at_2134__2[];
extern char at_2135[];
extern char at_2136__2[];
extern char at_2137[];
extern char at_2138[];
extern char at_2139[];
extern char at_2140[];
extern char at_2141[];
extern char at_2142[];
extern char at_2143[];
extern char at_2144[];
extern char at_2145[];
extern char at_2146__2[];
extern char at_2147[];
extern char at_2148[];
extern char at_2149[];
extern char at_2150[];
extern char at_2151[];
extern char at_2152[];
extern char at_2244[];
extern char at_2245[];
extern char at_2246[];
extern char at_2247[];
extern char at_2248[];
extern char at_2249[];
extern char at_2250[];
extern char at_2251[];
extern char at_2252[];
extern char at_2253[];
extern char at_2313[];
extern char at_2395__2[];
extern char at_2396__2[];
extern char at_2520[];
extern char at_2521[];
extern char at_2522[];
extern char at_2523[];
extern char at_2524[];
extern char at_2525[];
extern char at_2526[];
extern char at_2527[];
extern char at_2528[];
extern char at_2543__2[];
extern char at_2544[];
extern char at_2712[];
extern char at_2713__2[];
extern char at_2720__2[];
extern char at_2732__2[];
extern char at_2733__2[];
extern char at_2734__2[];
extern char at_2735__2[];
extern char at_2736[];
extern char at_2737[];
struct FoundSlots { int v[3]; };
extern FoundSlots at_2776;
extern CursorPos at_3202;
struct InventCursorPos {
    int pos[4];
} __attribute__((aligned(16)));
extern InventCursorPos at_3201;
extern s8 wakutype_3203[];
extern char at_3257[];
extern char at_3258[];
extern char at_3259[];
extern char at_3260__2[];
extern char at_3261[];
extern char at_3262__2[];
extern char at_3263__2[];
struct ItemNameList2 { char *name[2]; };
extern ItemNameList2 at_3317;
extern CMemoryCardManager *MCManagerPtr;
extern s8 ActiveSlot_3949;
extern s8 init_3950;
extern mgCMemory MenuInventCharaStack;
extern mgCMemory MenuInventMCStack;
extern char at_4354[];
extern char at_4355[];
extern char at_4356[];
extern char at_4357[];
extern char at_4358[];
extern char at_4359[];
extern char at_4360[];
extern char at_4361[];
extern char at_4362[];
extern char at_4363[];
extern char at_4364[];
extern char at_4365[];
extern char at_4366[];
extern char at_4367__2[];
extern char at_4368__2[];
extern char at_4369[];
extern char at_4370[];
extern char at_4371[];
extern char at_4372[];
extern char at_4373[];
extern char at_4374[];
extern char at_4375[];
extern char at_4376[];
extern char at_4377[];
extern char at_4378[];
extern char at_4379[];
extern char at_4380[];
extern ItemNameList2 at_3739;
extern ItemNameList2 at_3765;
extern s8 convtbl_3726[7];
extern char at_3858[];
extern char at_3859[];
extern char at_3860[];
extern char at_3861[];
extern char at_3862[];
extern char at_3863__2[];
extern char at_3864__2[];
extern char at_3865__2[];
extern char at_3866__2[];
extern char at_3867__2[];
extern char at_3868__2[];
extern char at_3869[];
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
struct ItemBoardKoma {
    int pos[10];
};
extern ItemBoardKoma at_3306;
extern char at_3348__2[];
extern char at_3349__2[];
extern char at_3350__2[];
extern char at_3351[];
extern char at_3352[];
extern char at_3353[];
struct NetaClipRange { float top; float bottom; };
struct ScreenPoint { int xy[2]; };
extern ScreenPoint at_3363;
extern NetaClipRange at_3379;
extern CursorPos at_3509;
extern ScreenPoint at_4493;
struct MenuColor { u8 rgba[4]; };
extern MenuColor at_4494;
struct NetaEffectTarget { float x; float y; };
extern NetaEffectTarget at_4638;
extern char at_4775[];
extern char at_5066[];
extern char at_5067[];
extern char at_5550[];
extern char at_5551[];
extern char at_5552[];
extern char at_5553[];
extern char at_5554[];
extern char at_5555[];
extern char at_5556[];
extern char at_5557[];
extern char at_5558[];
extern char at_5559[];
struct CardListTops { int top[2]; };
extern CardListTops at_5642;
extern char *NewComer_5648[];
extern int digit_tbl3_5641[];
extern char at_5742[];
extern char at_5743[];
extern char at_5744[];
extern char at_5745[];
extern char at_5746[];
struct NetaNameBlank { char text[2]; };
extern NetaNameBlank at_4470;

extern signed char pict_seiton_case;
extern short debug_invent_successflag;
extern short debug_invent_select;
extern CInventDataManage InventManageMan;
extern char at_5153[];
extern char at_5154[];
extern char at_5155[];
extern char at_5156[];
enum INVENT_COMMAND_MSG {
    INVENT_CMD_ZOOM = 0x1518,
    INVENT_CMD_DELETE = 0x1519,
    INVENT_CMD_TO_ALBUM = 0x151A,
    INVENT_CMD_FROM_ALBUM = 0x151B,
    INVENT_CMD_DELETE_UNUSED = 0x151C,
    INVENT_CMD_SET_BOARD = 0x151D,
    INVENT_CMD_DELETE_ALL = 0x151E
};
struct InventCommandList {
    int enable;
    int cmd_num;
    int cmd[5];
};
extern InventCommandList modecmdtbl_3636[12];
extern InventCommandList *menu_invent_command_info_ptr;
extern USER_PICTURE_INFO *menu_invent_command_info_pict_info;
extern USER_PICTURE_INFO *menu_invent_command_info_move_album_Space_info;
extern int menu_invent_command_info_move_album_Space_pos;
extern char at_2368__2[];
extern char at_2369__2[];
extern char at_3932[];
extern char at_3933[];
extern char at_3934[];
extern char at_3935[];
extern char at_3936[];
extern u8 InventInNetaEffectFlag;
extern short InventInNetaEffectNum4;
extern CStarDust *InventInNetaEffect;
int MenuInventDebugKey();
void MenuInventDebugDraw();
extern char at_2005[];

extern mgCMemory *scoop_str_stack;
extern SPI_TAG_PARAM menu_scoop_str_tag[];
extern mgCMemory *PicNameStack;
extern short pic_name_info_num;
extern PIC_NAME_INFO *pic_name_info_top;
extern short pic_name_info_num_count;
extern char pic_name_text_buff_1660[];
extern char at_1664[];
extern SPI_TAG_PARAM pic_tag[];
extern char *addstringtable_1722[];
extern char temp_1728[0x30];

extern SCOOP_DATA scoop_table[53];
extern InventFoundFlags at_1788__2;
extern CInventDataManage *InventManagePt;
extern mgCMemory InventTeigiStack;
extern INVENT_DATA_INFO *inventSpiDataTblTop;
extern short invent_num_counter;
extern SPI_TAG_PARAM invent_teigi_func[];

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

// Code (.text)
CInventUserData *GetInventUserDataPtr() {
    CSaveData *save = GetSaveData();
    if (save == NULL) {
        return NULL;
    }
    return (CInventUserData *)((u8 *)&save->user_data +
                              (int)&((CUserDataManager *)NULL)->invent_data);
}
void Init_USER_PICTURE_INFO(USER_PICTURE_INFO *photo) {
    if (photo != NULL) {
        *(signed char *)&photo->used = 0;
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
    dst->used = *(signed char *)&src->used;
    dst->is_new = *(signed char *)&src->is_new;
    dst->map_no = src->map_no;
    dst->npc_no = src->npc_no;
    dst->unk_8 = src->unk_8;
    dst->monster_no = src->monster_no;
    dst->neta_id = src->neta_id;
}
void PictureSeiton(USER_PICTURE_INFO *photos, char *work_base, int count) {
    char work_tmp[(0x2000)];
    USER_PICTURE_INFO info_tmp;
    int i;
    int j;
    USER_PICTURE_INFO *a;
    USER_PICTURE_INFO *b;
    int swap;
    short key_a;
    short key_b;
    if (photos == NULL) {
        return;
    }
    for (i = 0; i < count; i++) {
        a = &photos[i];
        for (j = i + 1; j < count; j++) {
            b = &photos[j];
            if (*(signed char *)&b->used == 0) {
                continue;
            }
            swap = 0;
            if (pict_seiton_case == 0) {
                if (*(signed char *)&a->used == 0 && *(signed char *)&b->used == 1) {
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
                if (*(signed char *)&a->used == 0 && *(signed char *)&b->used == 1) {
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
                if (*(signed char *)&a->used == 0 && *(signed char *)&b->used == 1) {
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
                if (*(signed char *)&a->used == 0 && *(signed char *)&b->used == 1) {
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
    char name[0x20];
    int base = 0;
    int i;
    if (count == (50)) {
        base = (50);
    }
    for (i = 0; i < count; i++) {
        sprintf(name, at_1046__2, i + base);
        manager->DeleteTexture(name, block);
        manager->EnterTexture(block, name, NULL, (64), (64), (0x10), 0, 0, 0);
        textures[i] = manager->GetTexture(name, -1);
        if (textures[i] != NULL) {
            textures[i]->image[0] = (u_long128 *)info[i].image;
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
int IsTakePhoto(void) {
    CUserDataManager *user = GetUserDataMan();
    if (user != NULL && ((CUserDataManager *)user)->active_chr_no == 0 &&
        user->SearchEquip(0, 0x171) != 0) {
        return 1;
    }
    return 0;
}
void CDC2AlbumData::Initialize(void) {
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
                info->image = (char *)this + i * 0x2000;
            }
        }
        i++;
    } while (i < 50);
}
void CDC2AlbumData::DeletePhotoData(int index) {
    if (index < 0 || index >= 50) return;
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
void CInventUserData::ResetAddress() {
    for (int index = 0; index < 30; index++) {
        photo[index].image = (char *)photo_work + index * (int)sizeof(photo_work[0]);
    }
}

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
        if (*(signed char *)&photo[i].used == 0) {
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
    int i = 0;
    do {
        info = GetPhotoInfo(i);
        if (info != NULL && *(signed char *)&*(signed char *)&info->used != 0 && info->neta_id == neta_id) {
            return i;
        }
        i++;
    } while (i < 30);
    return -1;
}
int CInventUserData::CountNeta() {
    short subject;
    int user_data;
    int count;
    int slot;
    int byte_offset;

    user_data = (int)GetUserDataMan();
    count = 0;
    slot = 0;
    byte_offset = 0;
    do {
        subject = ((CUserDataManager *)(user_data + byte_offset))->photo_subject[0];
        if (0 < subject && subject < 1000) {
            count++;
        }
        slot++;
        byte_offset += 2;
    } while (slot < 0x200);
    return count;
}
int CInventUserData::CountScoop() {
    short subject;
    int user_data;
    int count;
    int slot;
    int byte_offset;

    user_data = (int)GetUserDataMan();
    count = 0;
    slot = 0;
    byte_offset = 0;
    do {
        subject = ((CUserDataManager *)(user_data + byte_offset))->photo_subject[0];
        if (subject >= 1000 && subject < 10000) {
            count++;
        }
        slot++;
        byte_offset += 2;
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
        if (*(signed char *)&photo[i].used != 0) {
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
    short subject;
    int user_data;
    int slot;
    int byte_offset;
    int experience;

    experience = 0;
    user_data = (int)GetUserDataMan();
    slot = 0;
    byte_offset = 0;
    do {
        subject = ((CUserDataManager *)(user_data + byte_offset))->photo_subject[0];
        if (subject > 0) {
            if (subject < 1000) {
                experience += 2;
            } else {
                experience += 5;
            }
        }
        slot += 1;
        byte_offset += 2;
    } while (slot < 0x200);
    return experience;
}
int CInventUserData::LevelCheck(USER_PICTURE_INFO *info) {
    int user_data;
    int i;
    int slot;
    int byte_offset;
    short subject;
    int old_level;
    if (info == NULL) {
        return 0;
    }
    user_data = (int)GetUserDataMan();
    if (user_data == 0) {
        return 0;
    }
    subject = info->neta_id;
    if (subject <= 0) {
        return 0;
    }
    slot = -1;
    i = 0;
    byte_offset = 0;
    do {
        short owned = ((CUserDataManager *)(user_data + byte_offset))->photo_subject[0];
        if (owned == subject) {
            return 0;
        }
        if (owned <= 0) {
            slot = i;
            break;
        }
        i++;
        byte_offset += 2;
    } while (i < 0x200);
    if (slot < 0) {
        return 0;
    }
    ((CUserDataManager *)((slot << 1) + user_data))->photo_subject[0] = subject;
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
    short *from;
    INVENT_CREATED_ITEM *to;
    int i;
    if (old_data == NULL || new_data == NULL) {
        return;
    }
    from = (short *)old_data->created_item;
    to = new_data->created_item;
    for (i = 0; i < 128; i++) {
        to->item_id = from[0];
        to->unk_2 = *(unsigned short *)&from[1];
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
    SPI_STACK *text_arg = stack + 1;
    entry = GetScoopDataTable(spiGetStackInt(stack));
    if (entry != NULL) {
        entry->text = mgCopyString(spiGetStackString(text_arg), scoop_str_stack);
    }
    return 1;
}
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
    int count;
    int index;
    SCOOP_DATA *entry;
    SCOOP_INFO *info;

    index = 0;
    count = 0;
    do {
        entry = GetScoopDataTableIndex(index);
        if (entry != NULL) {
            info = GetScoopInfo((int)entry->scoop_id);
            if ((info != NULL) && (CheckBitFlagMenu((int)entry->flag_no) != 0) &&
                (*(signed char *)&info->known == 0)) {
                SetViewFlag((int)entry->scoop_id, 1);
                count += 1;
            }
        }
        index += 1;
    } while (index < 53);
    return count;
}
int CScoopDataManager::CheckScoop() {
    CInventUserData *user;
    int n;
    int i;
    USER_PICTURE_INFO *photo;
    SCOOP_INFO *info;
    int neta;
    user = GetInventUserDataPtr();
    n = 0;
    if (user == NULL) {
        return 0;
    }
    for (i = 0; i < 30; i++) {
        photo = user->GetPhotoInfo(i);
        if (photo != NULL && *(signed char *)&*(signed char *)&photo->used != 0) {
            info = GetScoopInfo(photo->neta_id);
            if (info != NULL && *(signed char *)&info->obtained == 0) {
                n++;
                info->obtained = 1;
            }
        }
    }
    for (i = 0; i < 0x200; i++) {
        neta = user->GetNetaID(i);
        if (neta >= 1000) {
            info = GetScoopInfo(neta);
            if (info != NULL && *(signed char *)&info->obtained == 0) {
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
        if (*(signed char *)&info[i].obtained != 0) {
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
        (PIC_NAME_INFO *)operator new[](pic_name_info_num * 8, (u_long128 *)PicNameStack->Alloc(blocks + 2));
    pic_name_info_num_count = 0;
    return 1;
}
int _PIC_NAME(SPI_STACK *stack, int unused) {
    PIC_NAME_INFO *entry;
    SPI_STACK *arg;
    char *name;
    char text[0x100];
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
        entry->unk_2 = spiGetStackInt(arg);
        pic_name_info_num_count++;
        if (*(unsigned short *)&entry->neta_id == 30000) {
            pic_name_info_num_count--;
            pic_name_info_num--;
        }
    }
    return 1;
}
void LoadFilePictureName(void) {
    mgCMemory stack;
    char align_buffer[0x5000];
    char *buffer;
    unsigned int size;
    stack.stSetBuffer((u_long128 *)pic_name_text_buff_1660, 0x248);
    PicNameStack = &stack;
    buffer = (char *)MenuCalcBufAlignment((u_long128 *)align_buffer);
    size = LoadFileMenu(at_1664, (u_long128 *)buffer, 1);
    CScriptInterpreter interpreter;
    interpreter.SetTag(pic_tag);
    interpreter.SetScript(buffer, size);
    interpreter.Run();
}
char *GetPhotoName(USER_PICTURE_INFO *info) {
    int i;
    int offset;
    short neta_id;
    if (info == NULL) {
        return NULL;
    }
    if (*(signed char *)&*(signed char *)&info->used == 0) {
        return NULL;
    }
    neta_id = info->neta_id;
    if (neta_id > 0) {
        i = 0;
        offset = 0;
        for (; i < pic_name_info_num; i++) {
            if (neta_id == ((PIC_NAME_INFO *)((char *)pic_name_info_top + offset))->neta_id) {
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
    char *name;
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
int CheckPhotoFlag(void) {
    int added = 0;
    CInventUserData *user = GetInventUserDataPtr();
    USER_PICTURE_INFO *photos = user->GetPhotoInfo(0);
    int i = 0;
    int offset = 0;
    do {
        USER_PICTURE_INFO *info = (USER_PICTURE_INFO *)((u8 *)photos + offset);
        if (*(signed char *)&*(signed char *)&info->used != 0) {
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
    int want[3];
    int i;
    INVENT_DATA_INFO *entry;
    short *ingredient;
    int count;
    int j;
    int k;
    int m;
    GetInventUserDataPtr();
    for (i = 0; i < num; i++) {
        entry = &table[i];
        ingredient = &entry->neta_id[0];
        if (ingredient != NULL) {
            InventFoundFlags found = at_1788__2;
            for (j = 0; j < 3; j++) {
                want[j] = ingredient[j];
                for (k = 0; k < 3; k++) {
                    if (want[j] == ids[k]) {
                        found.flag[j] = 1;
                    }
                }
            }
            count = 0;
            for (m = 0; m < 3; m++) {
                if (found.flag[m] != 0) {
                    count++;
                    want[m] = 0;
                }
            }
            if (combined != NULL && count >= 2) {
                *combined = 1;
            }
            if (found.flag[0] != 0 && found.flag[1] != 0 && found.flag[2] != 0) {
                return entry->item_id;
            }
        }
    }
    return -1;
}
int CInventDataManage::HowMuchZairyouMakeItem(int item_id, int count, int *needs) {
    INVENT_DATA_INFO *make_material;
    INVENT_MATERIAL_LIST *list;
    int i;
    int offset;
    int slot;
    MakeItemNeeds *row;
    if (needs == NULL) {
        return 0;
    }
    make_material = GetInventDataInfoByItemID(item_id);
    if (make_material == NULL) {
        return 0;
    }
    list = &make_material->materials;
    i = 0;
    offset = 0;
    slot = 0;
    *needs = make_material->materials.num;
    while (i < list->num) {
        row = (MakeItemNeeds *)((u8 *)needs + slot);
        slot += 8;
        row->need[0].item_id = *(short *)((u8 *)list->material + offset);
        row->need[0].amount = count * ((INVENT_MATERIAL *)((u8 *)list->material + offset))->num;
        offset += 4;
        i++;
    }
    if (i < 4) {
        slot = i * 8;
        do {
            row = (MakeItemNeeds *)((u8 *)needs + slot);
            i++;
            row->need[0].item_id = 0;
            slot += 8;
            row->need[0].amount = 0;
        } while (i < 4);
    }
    return 1;
}
int CInventDataManage::DeleteUserUsedItem(int item_id, int count) {
    INVENT_DATA_INFO *make_material;
    INVENT_MATERIAL_LIST *list;
    int i;
    INVENT_MATERIAL *material;
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
    HowMuchZairyouMakeItem(item_id, count, (int *)&needs);
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
    int num;
    int i;
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
    inventSpiDataTblTop = (INVENT_DATA_INFO *)InventTeigiStack.Alloc(blocks);
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
    int index;
    INVENT_MATERIAL_LIST *materials = &inventSpiDataTblTop->materials;
    materials->num = (argument_count - 9) / 2;
    if (materials->num <= 0) {
        return 0;
    }
    unsigned int bytes = materials->num * sizeof(INVENT_MATERIAL);
    unsigned int blocks = (bytes & 15) != 0 ? (bytes >> 4) + 1 : bytes >> 4;
    materials->material = (INVENT_MATERIAL *)InventTeigiStack.Alloc(blocks);
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
#ifdef NONMATCHING
int CheckInventItem(int item_id) {
    CInventDataManage manage;
    int file_size;
    char align_buffer[0x7800];
    char teigi_buffer[0x4000];
    char *buffer;
    INVENT_DATA_INFO *record;
    short *neta_id;
    int i;
    manage.num = 0;
    manage.table = NULL;
    buffer = (char *)MenuCalcBufAlignment((u_long128 *)align_buffer);
    LoadFile2(at_2005, buffer, &file_size, 0);
    InventTeigiStack.stSetBuffer((u_long128 *)teigi_buffer, 0x400);
    manage.LoadAnalyzeInventFile(buffer, file_size);
    InventUserDataPtr = GetInventUserDataPtr();
    record = manage.GetInventDataInfoByItemID(item_id);
    neta_id = record->neta_id;
    if (record == NULL) {
        return 0;
    }
    s8 found[3] = {0, 0, 0};
    for (i = 0; i < 30; i++) {
        USER_PICTURE_INFO *photo = InventUserDataPtr->GetPhotoInfo(i);
        if (*(signed char *)&photo->used != 0) {
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
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/inventmn", CheckInventItem__Fi);
#endif
int CheckItemTable(int item_id, int *values) {
    CInventDataManage manage;
    int file_size;
    char align_buffer[0x7800];
    char teigi_buffer[0x4000];
    char *buffer;
    INVENT_DATA_INFO *record;
    manage.num = 0;
    manage.table = NULL;
    buffer = (char *)MenuCalcBufAlignment((u_long128 *)align_buffer);
    if (LoadFile2(at_2005, buffer, &file_size, 0) != 0) {
        InventTeigiStack.stSetBuffer((u_long128 *)teigi_buffer, 0x400);
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
    CInventUserData *user;
    USER_PICTURE_INFO *info;
    int count;
    int i;
    short value;
    user = GetInventUserDataPtr();
    count = 0;
    if (user == NULL) {
        return 0;
    }
    for (i = 0; i < 30; i++) {
        info = user->GetPhotoInfo(i);
        if (info != NULL && *(signed char *)&*(signed char *)&info->used != 0) {
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
            if (photo != 0 && *(signed char *)&photo->used == 0) {
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
    bg_form = MenuPosData->GetFormInfo(at_2124__2);
    itembrd_form = MenuPosData->GetFormInfo(at_2125__3);
    neta_board_form = MenuPosData->GetFormInfo(at_2126__3);
    neta_board_bar[0] = 0;
    neta_board_bar[1] = 0;
    neta_board_bar[2] = 0;
    neta_board_arrow = 0;
    neta_memo_arrow = 0;
    if (neta_board_form != 0) {
        neta_board_form->SetNumber(at_2127__2, 30);
        neta_board_bar[0] = neta_board_form->GetPartInfo(at_2128__3);
        neta_board_bar[1] = neta_board_form->GetPartInfo(at_2129__2);
        neta_board_bar[2] = neta_board_form->GetPartInfo(at_2130__2);
        neta_board_arrow = neta_board_form->GetPartInfo(at_2131__2);
        neta_memo_arrow = neta_board_form->GetPartInfo(at_2132__2);
    }
    neta_memo_form = MenuPosData->GetFormInfo(at_2133__2);
    photo_scroll_reset = 1;
    makebrd_form = MenuPosData->GetFormInfo(at_2134__2);
    card_scroll_reset = 1;
    card_list_title_form = MenuPosData->GetFormInfo(at_2135);
    card_list_form = MenuPosData->GetFormInfo(at_2136__2);
    album_sw_form = MenuPosData->GetFormInfo(at_2137);
    if (album_sw_form != 0) {
        album_sw_form->rgba_bit = 8;
    }
    album_big_form = MenuPosData->GetFormInfo(at_2138);
    GiftBoxViewForm = MenuPosData->GetFormInfo(at_2139);
    neta_form[0] = MenuPosData->GetFormInfo(at_2140);
    neta_form[1] = MenuPosData->GetFormInfo(at_2141);
    neta_form[2] = MenuPosData->GetFormInfo(at_2142);
    neta_name_form[0] = MenuPosData->GetFormInfo(at_2143);
    neta_name_form[1] = MenuPosData->GetFormInfo(at_2144);
    neta_name_form[2] = MenuPosData->GetFormInfo(at_2145);
    recbrd_form = MenuPosData->GetFormInfo(at_2146__2);
    poly_chr_form[0] = MenuPosData->GetFormInfo(at_2147);
    poly_chr_form[1] = MenuPosData->GetFormInfo(at_2148);
    if (poly_chr_form[0] != 0) {
        poly_chr_form[0]->SetActionCharaPtr(0, -1, -1);
    }
    invent_okeff_form = MenuPosData->GetFormInfo(at_2149);
    dload_form = MenuPosData->GetFormInfo(at_2150);
    kakudai_pic_form = MenuPosData->GetFormInfo(at_2151);
    kakudai_pic = 0;
    if (kakudai_pic_form != 0) {
        kakudai_pic = kakudai_pic_form->GetPartInfo(at_2152);
    }
    AttachMessageForm();
}
extern void *__vt__9mgCObject[];
extern void *__vt__7CObject[];
extern void *__vt__12CObjectFrame[];
extern void *__vt__11CCharacter2[];
extern void *__vt__12CActionChara[];
extern "C" void *__ct__10CRunScriptFv(void *);

static inline int StackBlocks(int bytes) {
    return (bytes + 15) / 16 + 2;
}

static inline CActionChara *NewInventActionChara(mgCMemory *stack) {
    CActionChara *chara;
    if ((chara = (CActionChara *)operator new(sizeof(CActionChara), stack->Alloc(StackBlocks(sizeof(CActionChara))))) != NULL) {
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
    return chara;
}

#ifdef NONMATCHING
void CMenuInvent::LoadCharaCheck() {
    CActionChara *chara = MenuActionChara[0];
    mgCMemory *load_stack = &MenuCharaLoadStack;
    int size;
    switch (chara_load_step) {
    case -1:
        break;
    case 0:
        if (poly_chr_form[0] != NULL) {
            poly_chr_form[0]->SetActionCharaPtr(NULL, tex_block[1], -1);
        }
        MenuLoadInfo.mode = 1;
        MenuLoadInfo.unk_2 = 1;
        MenuLoadInfo.unk_3 = 0;
        MenuLoadInfo.unk_6[1] = 0;
        SetMenuLoadItemNo(0);
        size = MenuItemCharaDataLoad(load_stack, 0, MenuCharaBuild2, 0);
        chara_load_step = 1;
        sub_chara = NULL;
        if (photo_only == 1) {
            LoadFileBG(at_2244, load_stack->stack + load_stack->stack_used, &size);
            load_stack->Alloc(((u_int)size & 0xF) ? ((u_int)size >> 4) + 1 : (u_int)size >> 4);
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
            mgCFrame *frame = chara->CObjectFrame::frame;
            mgCFrameAttr *attr = frame->attr;
            attr->no_light = 1;
            frame->SetAttrParam(*attr, 1, kSceneAttrFlags);
        }
        chara->SetMotion(at_2246, 0, 1);
        if (chara_read_info != NULL) {
            BG_READ_INFO *read_info = chara_read_info;
            mgCTextureManager *tex_manager = &mgTexManager;
            u_int *model_file = GetPackFile((u_int *)read_info->buffer, at_2247, &size);
            chara_stack.stack_used = 0;
            chara_stack.lock = 0;
            strcpy(tex_manager->name_suffix, at_2248);
            if (model_file != NULL) {
                chara->LoadPack(model_file, at_2249, &chara_stack, &chara_stack, &chara_stack, tex_block[1], NULL);
            }
            u_int *sub_file = GetPackFile((u_int *)read_info->buffer, at_2250, &size);
            sub_chara = NewInventActionChara(&chara_stack);
            sub_chara->Initialize(0);
            sub_chara->LoadPack(sub_file, at_2249, &chara_stack, &chara_stack, &chara_stack, tex_block[1], chara);
            tex_manager->name_suffix[0] = 0;
            chara->SetRef(sub_chara, at_2251);
            chara->CopyOutLine(sub_chara);
            chara->SetMotion(at_2252, 0, 1);
        }
        if (album_enable == 0 && photo_only == 1) {
            chara->SetPosition(15.0f, -29.0f, 14.0f);
        } else {
            chara->SetPosition(20.0f, -29.0f, 14.0f);
        }
        chara->SetRotation(0.0f, -0.56f, 0.0f);
        chara->Step();
        ExeScript(at_2253);
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
        case 0:
        case 6:
        case 4:
            info = InventUserDataPtr->GetPhotoInfo(photo_cursor);
            break;
        case 5:
            info = InventAlbumPtr->GetAlbumPhotoInfo(album_cursor);
            break;
    }
    return info;
}
USER_PICTURE_INFO *CMenuInvent::GetPhotoInfoFromMode(int *slot_count) {
    switch (key_arg_no) {
        case 0:
        case 6:
        case 4:
            if (slot_count != 0) {
                *slot_count = 30;
            }
            return InventUserDataPtr->GetPhotoInfo(0);
        case 5:
            if (slot_count != 0) {
                *slot_count = 50;
            }
            return InventAlbumPtr->GetAlbumPhotoInfo(0);
    }
    return 0;
}
void CMenuInvent::InitNetaCircle(int show) {
    CMenuPosDataForm **panel;
    int i = 0;
    int byte_offset = 0;
    u8 *entry;
    do {
        if (show == 0) {
            CancelNetaCircle(0);
            neta_select_state[i] = -1;

            *(int *)((u8 *)this + 0x610 + byte_offset) = -1;
            unk_622[i] = 0;
        }

        entry = (u8 *)this + byte_offset;
        panel = (CMenuPosDataForm **)(entry + 0xEF0);
        if (*panel != 0) {
            (*panel)->SetRGBACalcParam(3, 0x7F, 0x80);
            if (show == 0) {
                (*panel)->draw_flag = 0;
            } else {
                (*panel)->draw_flag = 1;
                CMenuPosDataForm *label = *(CMenuPosDataForm **)(entry + 0xF00);
                if (label != 0) {
                    label->SetAction(at_2313);
                }
            }
        }
        i++;
        byte_offset += 4;
    } while (i < 3);
}
#ifdef NONMATCHING
int CMenuInvent::SetNetaCircle(int type, int index) {
    char *name;
    CMenuPosDataForm *form;
    CMenuPosDataForm *label;
    int pos[2];
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
        if (*(s8 *)&photo->used == 0) {
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
        MENUFORMPARTS_TYPE *ring = form->GetPartInfo(at_2368__2);
        ring->draw_flag = 1;
        if (neta_select_type[neta_select_num] == 0) {
            GetNetaBoardCursorPosition(index, pos);
            form->SetPos(pos[0], pos[1]);
            ring->etc_info[0] = index;
            ring->unk_2c = 0.7f;
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
        label->SetAction(at_2313);
    }
    CDC2Mes *message = MenuDCMsg[7];
    if (name != NULL) {
        strcpy(message->name[neta_select_num], name);
    }
    MenuDCMsg[7]->ClsMes::mes_no = -1;
    MenuDCMsg[7]->MakeMsg(neta_select_num + 50);
    neta_select_num++;
    if (neta_select_num == 1 && MenuActionChara[0] != NULL) {
        MenuActionChara[0]->SetMotion(at_2369__2, 0, 1);
    }
    neta_circle_angle += 0.05235988f;
    return 1;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/inventmn", SetNetaCircle__11CMenuInventFii);
#endif
int CMenuInvent::CancelNetaCircle(int mode) {
    int removed_idea = -1;
    if (neta_select_num <= 0) {
        return removed_idea;
    }
    neta_select_num = neta_select_num - 1;
    short last = neta_select_num;
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
        label->SetAction(at_2395__2);
    }
    if (neta_select_num <= 0) {
        if (MenuActionChara[0] != 0) {
            MenuActionChara[0]->SetMotion(at_2246, 0, 1);
        }
        if (mode == 0) {
            ExeScript(at_2253);
        }
        if (mode == 5) {
            ExeScript(at_2396__2);
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
        int photo_slot = neta_select_index[slot];
        return ((USER_PICTURE_INFO *)((u8 *)photos + photo_slot * sizeof(USER_PICTURE_INFO)))
            ->neta_id;
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
    int values[5];
    int i;
    int j;
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
    RecordBoardMsgTypes volume_types = at_2455;
    mes->SetMsgVolumeNo(values, (int *)&volume_types, 5);
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
    CMenuPosDataForm *ask_form = *(CMenuPosDataForm **)((u_char *)MenuCommonInfo + 0x138);
    if (ask_form != 0) {
        ask_form->draw_flag = 1;
    }
    neta_form[0]->parts->etc_info[0] = -1;
    neta_form[1]->parts->etc_info[0] = -1;
    neta_form[2]->parts->etc_info[0] = -1;
    MenuPosData->InitDrawList();
    ExeScript(at_2253);
    ExeScript(at_2520);
    switch (key_arg_no) {
        case 0:
            ExeScript(at_2521);
            ExeScript(at_2522);
            if (LanguageCode > 0) {
                MenuDCMsg[7]->font_w = 0xE;
            }
            break;
        case 2:
            ExeScript(at_2523);
            CreateModeSwapForm(0);
            ExeScript(at_2524);
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
        case 5:
            ExeScript(at_2525);
            do {
            } while (CancelNetaCircle(0) >= 0);
            break;
        case 6:
            ExeScript(at_2521);
            ExeScript(at_2526);
            UpdataRecordBoard();
            break;
    }
    if (photo_only == 1) {
        ExeScript(at_2527);
    }
    if (album_enable == 0) {
        ExeScript(at_2528);
    }
}
CGameDataUsed *CMenuInvent::SearchNowPosItemExist() {
    CGameDataUsed *item = 0;
    switch (key_arg_no) {
        case 2:

            create_item.Init();
            item = &create_item;
            item->item_no = InventUserDataPtr->GetCreateItemID(card_cursor);
            break;
        case 3:
            item = &MenuUserParam.used_data[item_cursor];
            break;
    }
    return item;
}
void CMenuInvent::CreateModeSwapForm(int side) {
    if (side == 0) {
        ExeScript(at_2543__2);
        return;
    }
    ExeScript(at_2544);
}
void CMenuInvent::GradationSet(int mode) {
    int i = 0;
    switch (mode) {
        case 0: {
            int j;
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
                        invent_okeff_form->GetPartInfo(*(char **)((u8 *)invent_grade_fff + offset));
                    i++;

                    *(int *)&part->y = 0x43600000;
                    offset += 4;
                    part->h = 0.0f;
                } while (i < 2);
            }
            gradation_mode = 0;
            return;
        }
        case 1: {
            int j;
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
                GradeRows rows = at_2562;
                do {
                    MENUFORMPARTS_TYPE *part = invent_okeff_form->GetPartInfo(invent_grade_fff[i]);
                    *(int *)&part->y = 0x43600000;
                    part->h = 0.0f;
                    int row = rows.v[i];
                    u8 *first = invent_color_tbl[2][row];
                    MENU_PARTS_EFFECT_STRUCT1 *first_effect = part->effect;
                    first_effect->param[0] = first[0];
                    first_effect->param[1] = first[1];
                    first_effect->param[2] = first[2];
                    first_effect->param[3] = first[3];
                    u8 *second = invent_color_tbl[2][row ^ 1];
                    MENU_PARTS_EFFECT_STRUCT1 *second_effect = &part->effect[1];
                    second_effect->param[0] = second[0];
                    second_effect->param[1] = second[1];
                    second_effect->param[2] = second[2];
                    second_effect->param[3] = second[3];
                    i++;
                } while (i < 2);
            }
            gradation_mode = 1;
            unk_eb0 = 0;
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
    int i;
    MENUFORMPARTS_TYPE *part;
    GradationSteps steps = at_2639;
    switch (gradation_mode) {
    case 1: {
        int grown = 0;
        for (i = 0; i < 2; i++) {
            part = invent_okeff_form->GetPartInfo(invent_grade_fff[i]);
            if (steps.v[2] >= unk_eb0) {
                part->h = unk_eb0;
                if (i % 2 == 0) {
                    part->y = 224.0f - part->h;
                }
                grown = 1;
            }
        }
        if (grown) {
            unk_eb0 += 4;
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
                    int next = now;
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

    read_info = (BG_READ_INFO *)InventSubDataReadBGInfo;
    album_enable = 1;
    if (GetUserDataMan()->GetNumSameItem(0x165) <= 0) {
        album_enable = 0;
    }
    if (photo_only == 1) {
        EnterDataMenu((u8 *)read_info->buffer);
        ExeScript(at_2253);
        ExeScript(at_2712);
        PrepareNextMode((int)key_arg_no);
    }
    unk_eb6 = 1;
    ExeScript(at_2713__2);
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
        sys->invent_unk_2e = this->unk_392;
    }
    InventUserDataPtr->PhotoCheckEnd();
    ExeScript(at_2720__2);
}
void CMenuInvent::EnterDataMenu(u8 *pack) {
    char *raw = (char *)this;
    int *words = (int *)this;
    mgCTextureManager *tex_manager = &mgTexManager;
    u_int *file = GetPackFile((unsigned int *)pack, at_2732__2, 0);
    if (file != 0) {
        int image_block = this->tex_block[3];
        if (file != 0) {
            tex_manager->EnterIMGFile((u8 *)file, image_block, 0, 0);
            Tex_Hatsumei = tex_manager->GetTexture(at_2733__2, -1);
        }
        file = GetPackFile((unsigned int *)pack, at_2734__2, 0);
        if (file != 0) {
            tex_manager->EnterIMGFile((u8 *)file, MenuCommonInfo->tex_block[1], 0, 0);
            ((CMenuPosDataManage *)MenuPosData)->AttachCommonTexInfo();
        }
        int size = 0;
        MenuDataAnalyze((char *)GetPackFile((unsigned int *)pack, at_2735__2, &size), size, &data_stack);
        MenuInventStack.Align64();

        *(u_int **)(raw + 0x1F4) = GetPackFile((u_int *)pack, raw + 0x1D4, words + 0x7E);
        *(u_int **)(raw + 0x21C) = GetPackFile((u_int *)pack, raw + 0x1FC, words + 0x88);
        *(u_int **)(raw + 0x244) = GetPackFile((u_int *)pack, raw + 0x224, words + 0x92);
        AttachPictTex(tex_block[3], photo_tex, InventUserDataPtr->GetPhotoInfo(0), 0x1E);
        script = (char *)GetPackFile((unsigned int *)pack, at_2736, &script_size);
        int size2 = 0;
        InventManagePt->LoadAnalyzeInventFile((char *)GetPackFile((unsigned int *)pack, at_2737, &size2),
                                              size2);
    }
    AttachFormInfo();
    MenuMoveItemPtr->AttachForm();
}
int CMenuInvent::ItemCmdAfter(int command, ITEMCMD_RET_PARA *para) {
    if (para->unk_2 >= -1) {
        MenuSePlay(para->cmd);
        signed char result = para->unk_2;
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
struct PathPrefix { u_long128 chunk[4]; };
extern PathPrefix at_2913;
extern char at_3113[];
extern char at_3114[];
extern char at_3115[];
extern char at_3116[];
extern char at_3117[];
extern char at_3118[];
extern char at_3119[];
extern char at_3120[];
extern char at_3121[];
extern char at_3122[];
extern char at_3123[];
extern char at_3124[];
extern char at_3125[];
extern char at_3126[];
extern char at_3127[];
extern char at_3128[];
extern char at_3129[];
extern char at_3130[];
extern char at_3131[];
extern char at_3132[];
extern char at_3133[];
extern char at_3134[];
extern char at_3135[];
extern char at_2820[];
extern char *Tb_2819[7];
extern char *gobitbl_2847[2];
extern char *getfilename_2928[2];
extern char *sndfileName_2951[2];
extern char *wavname_2960[3];
extern short sndtimetbl_2868[2];
extern signed char D_003532DF[];
extern float eff_light_2927[4];

#ifdef NONMATCHING

#pragma inline_depth(5)
int CMenuInvent::IsCreateObject(int mode, int keys) {
    CActionChara *action_chara = MenuActionChara[0];
    CDC2Mes *message_window = MenuDCMsg[4];
    mgCMemory *load_stack = &MenuCharaLoadStack;
    mgCTextureManager *texture_manager = &mgTexManager;
    s16 state = this->step;

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
                    this->unk_584 = 0;
                    InventUserDataPtr->GetPhotoInfo(0);
                    recipe_index = 0;
                    recipe_offset = 0;
                    while (InventManagePt->num != 0) {
                        INVENT_DATA_INFO *recipe;
                        CInventDataManage *table = InventManagePt;
                        if (recipe_index < 0 || table->num <= recipe_index) {
                            recipe = NULL;
                        } else {
                            recipe = (INVENT_DATA_INFO *)((u8 *)table->table + recipe_offset);
                        }
                        if (recipe == NULL) {
                            break;
                        }
                        if (!(0 < InventUserDataPtr->IsAlreadyCreatedItem(recipe->item_id))) {
                            s32 matched = 0;
                            s32 index;
                            s32 need;
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
                                this->unk_584 = 1;
                                for (slot_index = 0; slot_index < 3; slot_index++) {
                                    if (found.v[slot_index] == 0) {
                                        this->unk_594 = slot_index;
                                    }
                                }
                                break;
                            }
                        }
                        recipe_offset += sizeof(INVENT_DATA_INFO);
                        recipe_index++;
                    }
                }
                this->unk_60a = 0x7C;
                this->ExeScript(at_3113);
                this->GradationSet(1);
                this->step = kCreateWaitStart;
                load_stack->stack_used = 0;
                load_stack->lock = 0;
                StartReadBG();
                s32 sound_message_size;
                LoadFileBG(at_3114, load_stack->stGetTop(), &sound_message_size);
                this->unk_5fc = kLoadSoundMsg;
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
        this->unk_60a--;
        if (this->unk_60a <= 0 && this->unk_5fc > 1) {
            this->step++;
        }
        break;
    case kCreateShowReady:
        action_chara->GetNowMotionName();
        s32 motion = action_chara->seq_state;
        if (this->unk_5fc >= 5 && motion == 3) {
            this->step++;
            action_chara->seq_advance = 1;
            action_chara->SetMotion(at_3116, 4, 1);
            this->unk_604 = 1;
            this->unk_606 = 1;
            this->unk_608 = 0;
            this->poly_chr_form[1]->SetActionCharaPtr(this->create_chara, this->tex_block[2], -1);
            this->GradationSet(3);
            MenuCommonInfo->MenuPosPlay();
            this->unk_5e4 = 0.0f;
            this->unk_5f0 = 0.0f;
            this->unk_5f4 = 0;
            this->unk_5f8 = 0.0f;
            if (this->create_step != 0) {
                this->ExeScript(at_3117);
                if (this->create_chara != NULL) {
                    INVENT_DATA_INFO *recipe;
                    mgCFrame *frame = this->create_chara->CObjectFrame::frame;
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
            } else if (this->unk_584 != 0) {
                s32 index;
                this->ExeScript(at_3118);
                for (index = 0; index < 3; index++) {
                    if (this->create_photo_neta[index] > 0) {
                        USER_PICTURE_INFO info;
                        char *name;
                        s32 length;
                        info.neta_id = this->create_photo_neta[index];
                        info.used = 1;
                        name = GetPhotoName(&info);
                        if (name != NULL) {
                            strcpy((char *)this->create_photo_name, name);
                        } else {
                            strcpy((char *)this->create_photo_name, Tb_2819[LanguageCode]);
                        }
                        length = strlen((char *)this->create_photo_name);
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
                            sprintf((char *)this->create_photo_name, at_3119, name, gobitbl_2847[GetRandI(2)]);
                        } else {
                            strcpy((char *)this->create_photo_name, at_2820);
                        }
                        break;
                    }
                }
                this->neta_circle_snap = 1;
            } else {
                this->ExeScript(at_3120);
            }
            MenuSePlay(0, this->unk_394, &MenuSoundBuffer);
        }
        break;
    case kCreateShow: {
        if (this->create_step != 0) {
            if (this->create_chara != NULL) {
                float scale[4];
                this->create_chara->GetScale(scale);
                switch (this->unk_5f4) {
                case 0:
                    if (CalcMenuAdd(&this->unk_5f8, 0.4f, this->unk_5f8) != 0) {
                        this->unk_5f4 = 1;
                        this->unk_5e4 = 0.0f;
                        this->unk_5ec = 0.4f * this->create_scale;
                    }
                    scale[0] = this->unk_5f8;
                    break;
                case 1:
                    scale[0] = this->create_scale + this->unk_5ec * sinf(0.10471976f * this->unk_5f0);
                    CalcMenuAdd(&this->unk_5ec, -0.02f, 0.0f);
                    CalcMenuAdd(&this->unk_5e4, 0.15707964f, 15.707964f);
                    CalcMenuAdd(&this->unk_5f0, 1.0f, 600.0f);
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
                AddRotationCharaY((CCharacter2 *)this->create_chara, 0.01308997f);
                this->create_chara->Step();
            }
        }
        switch (this->unk_604) {
        case 0:
            break;
        case 1:
            if (this->unk_606 != 0) {
                s16 jingle_length = sndtimetbl_2868[this->create_step];
                if (this->unk_608 > jingle_length / 2) {
                    this->unk_606 = 0;
                    this->ExeScript(at_3121);
                    if (this->create_step != 0) {
                        char *message = GetItemMessage(this->create_item_id);
                        if (message != NULL) {
                            strcpy(message_window->name[0], message);
                        }
                        message_window->MakeMsg(kMsgItemCreated);
                    } else if (this->unk_584 != 0) {
                        char *name;
                        message_window->MakeMsg(kMsgPhotoNamed);
                        name = (char *)this->create_photo_name;
                        if (name != NULL) {
                            strcpy(message_window->name[0], name);
                        }
                    } else {
                        message_window->MakeMsg(kMsgNothingNew);
                    }
                }
            }
            this->unk_608++;
            if (this->unk_608 > sndtimetbl_2868[this->create_step]) {
                MenuCommonInfo->FadeInMenuBGMVol(6);
                this->unk_604 = 0;
            }
            break;
        }
        if (this->unk_584 != 0) {
            u32 color;
            this->unk_5b8++;
            if (this->unk_5b8 >= 0x32) {
                this->unk_5b8 = 0;
            }
            color = kBlinkDark;
            if (this->unk_5b8 >= 0x19) {
                color = kBlinkLight;
            }
            CDC2Mes *color_window = MenuDCMsg[7];
            if (this->unk_594 >= 0 && this->unk_594 < 0x14) {
                color_window->line_color[this->unk_594] = color;
            }
        }
        if (this->unk_604 == 0 && ((keys & kCreateKeyConfirm) || (keys & kCreateKeyCancel))) {
            s32 cursor[2];
            this->step = 0;
            this->mode = 0;
            if (this->unk_5fc == kLoadJingleOpen || this->unk_5fc == kLoadJinglePlay) {
                CSnd.StreamClose(1);
                this->unk_5fc = -2;
            }
            action_chara->DeleteExtMotion();
            MenuCommonInfo->FadeInMenuBGMVol(6);
            this->create_effect = NULL;
            if (this->create_step != 0 ||
                ((s16)this->create_step == 0 && this->unk_584 == 0)) {
                this->InitNetaCircle(0);
            } else {
                this->InitNetaCircle(1);
            }
            this->ExeScript(at_3122);
            this->create_step = 0;
            CDC2Mes *color_window = MenuDCMsg[7];
            if (this->unk_594 >= 0 && this->unk_594 < 0x14) {
                color_window->line_color[this->unk_594] = kLineColorNormal;
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
    switch (this->unk_5fc) {
    case -2:
        break;
    case kLoadSoundMsg:
        if (read_done == 0) {
            BG_READ_INFO *file = GetReadBGFile(0);
            if (file != NULL) {
                MenuSePlay(0, (u32 *)file->buffer, &MenuSoundBuffer);
                MenuCommonInfo->FadeOutMenuBGMVol(-3, 0x18);
            }
            this->unk_5fc = kLoadModel;
        }
        break;
    case kLoadModel: {
        PathPrefix path;
        s32 model_blocks;
        s32 motion_size;
        action_chara->SetMotion(at_3123, 0, 1);
        load_stack->stack_used = 0;
        load_stack->lock = 0;
        load_stack->Align64();
        path = at_2913;
        model_blocks = kItemModelBlocks;
        if (this->create_step != 0) {
            strcat((char *)&path, at_3124);
        } else {
            if (this->unk_584 != 0) {
                strcat((char *)&path, at_3125);
            } else {
                strcat((char *)&path, at_3126);
            }
            model_blocks = kPhotoModelBlocks;
        }
        this->chara_stack.stSetBuffer(load_stack->stGetTop(), model_blocks);
        load_stack->Alloc((model_blocks * 16 & 15) != 0 ?
                          ((unsigned int)(model_blocks * 16) >> 4) + 1 :
                          (unsigned int)(model_blocks * 16) >> 4);
        this->create_model_file = (u8 *)load_stack->stGetTop();
        StartReadBG();
        LoadFileBG((char *)&path, (u_long128 *)this->create_model_file, &motion_size);
        this->create_motion_file = this->create_model_file + motion_size / 16 * 16;
        LoadFileBG(at_3127, (u_long128 *)this->create_motion_file, &motion_size);
        this->unk_5fc = kLoadModelDone;
        break;
    }
    case kLoadModelDone:
        if (this->unk_60a <= 0 && read_done == 0) {
            float pos[4];
            float rot[4];
            BG_READ_INFO *pack_bg;
            MDS_HEADER *pack_file;
            mgCFrame *frame;
            CMenuPosDataForm *form;
            GetReadBGFile(0);
            action_chara->GetPosition(pos);
            action_chara->GetRotation(rot);
            strcpy(texture_manager->name_suffix, at_3128);
            action_chara->LoadPack((unsigned int *)this->create_model_file, at_2249, &this->chara_stack,
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
                pack_file = (MDS_HEADER *)GetPackFile((u32 *)pack_bg->buffer, getfilename_2928[this->create_step], NULL);
            }
            this->create_effect = NewInventActionChara(load_stack);
            this->create_effect->Initialize(0);
            frame = mgLoadMDSFile(pack_file, load_stack, NULL, NULL);
            this->create_effect->CObjectFrame::frame = frame;
            if (frame != NULL) {
                mgCFrameAttr *attr = (mgCFrameAttr *)frame->attr;
                attr->no_light = 1;
                attr->color[0] = eff_light_2927[0];
                attr->color[1] = eff_light_2927[1];
                attr->color[2] = eff_light_2927[2];
                attr->color[3] = eff_light_2927[3];
                this->create_effect->SetPosition(18.0f, -20.0f, 20.0f);
                this->create_effect->SetRotation(0.0f, 0.15707964f, 0.0f);
                frame->SetAttrParam(*attr, 1, kSceneAttrFlags);
            }
            form = MenuPosData->GetFormInfo(at_3133);
            if (form != NULL) {
                form->SetActionCharaPtr(this->create_effect, -1, -1);
                form->counter = 0;
                form->ambient[0] = -1.0f;
            }
            this->unk_5fc = kLoadSoundBank;
            load_stack->Align64();
            this->unk_600 = 100;
            if (this->create_step != 0) {
                u8 *item_file;
                char *item_path;
                s32 item_size;
                this->unk_600 = 200;
                this->create_chara = NewInventActionChara(load_stack);
                this->create_chara->Initialize(0);
                this->unk_d48.stSetBuffer(load_stack->stGetTop(), 0x35C0);
                this->unk_d48.stack_used = 0;
                this->unk_d48.lock = 0;
                load_stack->Alloc(0x35C0);
                load_stack->Align64();
                item_file = (u8 *)load_stack->stGetTop();
                item_path = GetItemFilePath(this->create_item_id, 1);
                if (item_path != NULL) {
                    if (*item_path != 0) {
                        StartReadBG();
                        LoadFileBG((char *)item_path, (u_long128 *)item_file, &item_size);
                    }
                }
                this->unk_5fc = kLoadItemModel;
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
                this->create_chara->LoadPack((unsigned int *)item_bg->buffer, at_2249, &this->unk_d48,
                                           &this->unk_d48, &this->unk_d48, this->tex_block[2], 0);
                texture_manager->name_suffix[0] = 0;
            }
            this->unk_5fc++;
        }
        break;
    case kLoadSoundBank: {
        s32 sound_size;
        load_stack->Align64();
        StartReadBG();
        this->unk_394 = (u32 *)load_stack->stGetTop();
        LoadFileBG(sndfileName_2951[this->create_step], (u_long128 *)this->unk_394, &sound_size);
        load_stack->Alloc((sound_size & 15) != 0 ? ((unsigned int)sound_size >> 4) + 1 :
                                                (unsigned int)sound_size >> 4);
        this->unk_5fc++;
        break;
    }
    case kLoadSoundPort:
        if (read_done == 0) {
            sndInitPort(8);
            this->unk_5fc++;
        }
        break;
    case kLoadJingleOpen:
        this->unk_600--;
        if (this->unk_600 == 0x28) {
            s32 wave = this->create_step;
            char wave_name[0x88];
            if (wave == 1) {
                wave = GetRandI(2) + 1;
            }
            sprintf(wave_name, at_3135, wavname_2960[wave]);
            CSnd.StreamOpenFast(1, wave_name);
        }
        if (this->unk_600 <= 0) {
            while (CSnd.StreamOpenState() != 0) {
            }
            CSnd.StreamStandBy(1);
            while (CSnd.StreamOpenState() != 0) {
            }
            CSnd.StreamSetVol(1, 0x7FFF, 0x7FFF);
            CSnd.StreamPlay(1);
            this->unk_600 = 0x50;
            this->unk_5fc++;
        }
        break;
    case kLoadJinglePlay:
        s32 play_state = CSnd.StreamGetState(1);
        this->unk_600--;
        if ((play_state & 0x8000) && this->unk_600 <= 0) {
            CSnd.StreamClose(1);
            this->unk_5fc++;
        }
        break;
    }
    return 1;
}

#pragma inline_depth reset
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/inventmn", IsCreateObject__11CMenuInventFii);
#endif
void CMenuInvent::CalcMakeBrd(int message_index) {
    if (makebrd_form != NULL && makebrd_form->draw_flag) {
        make_board.unk_1c = make_num;
        make_board.material_num = 4;
        MakeItemNeeds needs;
        InventManagePt->HowMuchZairyouMakeItem(unk_FC, make_num, (int *)&needs);
        int index = 0;
        for (; index < needs.num; index++) {
            make_board.line[index].kind = 1;
            int owned = GetUserItemHaveNum(needs.need[index].item_id);
            if (owned >= needs.need[index].amount) {
                make_board.line[index].button = 1;
            } else {
                make_board.line[index].button = 0;
            }
            make_board.line[index].sub_num = (short)needs.need[index].amount - owned;
            if (make_board.line[index].sub_num < 0) {
                make_board.line[index].sub_num = 0;
            }
            make_board.line[index].num = (short)needs.need[index].amount;
        }
        for (; index < 4; index++) {
            make_board.line[index].kind = 0;
            make_board.line[index].button = 0;
            make_board.line[index].num = 0;
            make_board.line[index].sub_num = 0;
        }
        make_board.unk_20 = make_cursor;
        CalcMenuAdd(&make_board.unk_24, -1, 0);
        CalcMenuAdd(&make_board.unk_28, -1, 0);
        CalcCommonBrdDrawInfo(&makebrd_form->x, &make_board, MenuDCMsg[message_index]);
    }
}
extern "C" int EnableSelectMaxCardList__11CMenuInventFv(CMenuInvent *objet) {
    int var_v0;

    var_v0 = InventUserDataPtr->GetHatsumeiNum() + 1;
    if (var_v0 < 5) {
        var_v0 = 5;
    }
    return var_v0;
}

void CMenuInvent::CalcCursorPosition() {
    if (mode == 2) {
        MenuCommonInfo->SetWakuType(-1);
        return;
    }
    if (mode == 1) {
        MenuCommonInfo->SetWakuType(-1);
    }
    InventCursorPos cursor = at_3201;
    char text[0x28];
    CursorPos offset = at_3202;
    CursorPos waku;
    CursorPos command_pos;
    sprintf(text, at_3257, key_arg_no);
    MenuPosData->GetEtcTblValue(text, waku.x, waku.y);
    sprintf(text, at_3258, key_arg_no);
    MenuPosData->GetEtcTblValue(text, offset.x, offset.y);
    MenuCommonInfo->SetWakuWH(wakutype_3203[key_arg_no], waku.x, waku.y);
    MenuCommonInfo->SetWakuType(wakutype_3203[key_arg_no]);
    switch (key_arg_no) {
    case 0:
    case 4:
    case 6:
        GetNetaBoardCursorPosition(photo_cursor, cursor.pos);
        if (neta_board_form != NULL) {
            cursor.pos[1] = 108.0f + (4.0f + neta_board_form->y) + (float)((photo_cursor / 2 - photo_top) * 54);
        }
        cursor.pos[0] += 3;
        cursor.pos[1] += 2;
        command_pos.x = cursor.pos[0];
        command_pos.y = cursor.pos[1];
        break;
    case 1:
    case 7:
        album_sw_form->GetPutPosXY(at_3259, cursor.pos[0], cursor.pos[1]);
        break;
    case 2:
        cursor.pos[0] = card_list_form->x - 40.0f;
        cursor.pos[1] = (card_cursor - card_top) * 46 + 72;
        if (mode == 6) {
            cursor.pos[0] = -50.0f + MakeBoardDrawInfo[make_cursor * 2];
            cursor.pos[1] = MakeBoardDrawInfo[make_cursor * 2 + 1];
        }
        break;
    case 3:
        MenuPosData->GetPosMenuItemOnItemBrd(cursor.pos, item_cursor, 1);
        cursor.pos[0] -= 8;
        cursor.pos[1] -= 10;
        command_pos.x = cursor.pos[0];
        command_pos.y = cursor.pos[1];
        break;
    case 5:
        sprintf(text, at_3260__2, album_cursor - album_top * 2);
        album_big_form->GetPutPosXY(text, cursor.pos[0], cursor.pos[1]);
        command_pos.x = cursor.pos[0];
        command_pos.y = cursor.pos[1];
        break;
    case 8:
        neta_board_form->GetPutPosXY(at_3261, cursor.pos[0], cursor.pos[1]);
        break;
    case 11:
        neta_memo_form->GetPutPosXY(at_3262__2, cursor.pos[0], cursor.pos[1]);
        break;
    case 10:
        neta_board_form->GetPutPosXY(at_3263__2, cursor.pos[0], cursor.pos[1]);
        break;
    case 9:
        GetNetaMemoCursorPosition(memo_cursor - memo_top, cursor.pos);
        cursor.pos[0] -= 32;
        break;
    }
    MenuItemCommandDir = -1;
    if (mode == 4 || (mode == 12 && step == 0)) {
        SetItemCmdMsgPos(&command_pos.x);
    }
    if (mode == 5 || mode == 4 || mode == 12 || mode == 9 || mode == 14) {
        MenuCommonInfo->SetWakuType(-1);
    }
    MenuCommonInfo->MenuPosStep(cursor.pos, &offset.x);
    if (unk_eb6 != 0) {
        MenuCommonInfo->MenuSetPos(cursor.pos[0], cursor.pos[1]);
        unk_eb6 = 0;
    }
}
int CMenuInvent::IsMakeObject(int keys, int button) {
    switch (step) {
    case 0: {
        int select = SelectMakeObject(keys);
        if (select == -1) {
            make_board.unk_24 = 6;
            make_board.unk_28 = 0;
        } else if (select == 1) {
            make_board.unk_24 = 0;
            make_board.unk_28 = 6;
        }
        switch (button) {
        case 1:
            if (make_cursor == 0) {
                int enough = InventManagePt->CheckMakeItem(unk_FC, make_num, MenuUserParam.used_data);
                unk_104 = GetUserDataMan()->SearchSpaceUsedData();
                if (enough == 0) {
                    step = 3;
                    ExeScript(at_3348__2);
                } else if (unk_104 < 0) {
                    step = 3;
                    ExeScript(at_3349__2);
                } else {
                    if (unk_FC == 0xA5) {
                        GetSaveData()->SetBitFlag(13, 1);
                    }
                    if (unk_FC == 0x12F) {
                        GetSaveData()->SetBitFlag(48, 1);
                    }
                    InventManagePt->DeleteUserUsedItem(unk_FC, make_num);
                    unk_104 = GetUserDataMan()->SearchSpaceUsedData();
                    int row = unk_104 / 6;
                    if (item_top > row) {
                        while (row < item_top) {
                            item_top--;
                        }
                    } else if (item_top + 5 <= row) {
                        while (item_top + 5 <= row) {
                            item_top++;
                        }
                    }
                    item_cursor = unk_104;
                    step = 10;
                    MenuCharaLoadStack.stack_used = 0;
                    MenuCharaLoadStack.lock = 0;
                    MenuCharaLoadStack.Alloc(0xC0);
                    unk_578 = MenuCharaLoadStack.stack + MenuCharaLoadStack.stack_used;
                    StartReadBG();
                    int size;
                    LoadFileBG(at_3350__2, (u_long128 *)unk_578, &size);
                    u_int bytes = size + 16;
                    MenuCharaLoadStack.Alloc((bytes & 0xF) ? (bytes >> 4) + 1 : bytes >> 4);
                }
                break;
            }
        case 2:
            mode = 0;
            ExeScript(at_3351);
            MenuSePlay(5);
            MenuCommonInfo->SetVibeR(6, 4);
            break;
        }
        break;
    }
    case 10:
        if (ReadBGSync() == 0) {
            ItemBoardKoma koma = at_3306;
            MenuPosData->GetPosMenuItemBrdKoma(koma.pos, unk_104, 0);
            mgCTexture *effect_tex = MenuPosData->icon_effect_tex;
            MenuEffect[0]->PresetEffect(&MenuCharaLoadStack, effect_tex, 0, koma.pos);
            MenuEffect[0]->EffectStart();
            koma.pos[2] = 32;
            koma.pos[3] = 40;
            MenuEffect[1]->PresetEffect(&MenuCharaLoadStack, effect_tex, 4, koma.pos);
            MenuEffect[1]->EffectStart();
            MenuCommonInfo->SetVibeR(6, 4);
            if (MenuCommonInfo->cursor_form != NULL) {
                MenuCommonInfo->cursor_form->draw_flag = 0;
            }
            ExeScript(at_3351);
            MenuSePlay(0, (u_int *)unk_578, &MenuSoundBuffer);
            CreateModeSwapForm(1);
            step = 1;
        }
        break;
    case 1:
        if (MenuEffect[1]->counter == 0x70) {
            CGameDataUsed *space = GetUserDataMan()->SearchSpaceUsedDataPtr();
            for (int i = 0; i < make_num; i++) {
                GetUserDataMan()->CopyGameData(space, unk_FC);
                GetUserDataMan()->GetCostume(unk_FC);
            }
            CheckEnableHaveItemNum();
        }
        if (MenuEffect[1]->run == 0) {
            step++;
            ExeScript(at_3352);
            ItemNameList2 names = at_3317;
            names.name[0] = GetItemMessage(unk_FC);
            CDC2Mes *message = MenuDCMsg[4];
            message->SetMsgItemNo(names.name, 1);
            message->SetMsgVolumeNoOne(make_num);
        }
        break;
    case 2:
        if (button != 0) {
            CreateModeSwapForm(0);
            ExeScript(at_3353);
            MenuSePlay(1);
            mode = 0;
            step = 0;
            make_cursor = 1;
        }
        break;
    case 3:
        if (button != 0) {
            ExeScript(at_3353);
            MenuCommonInfo->SetVibeR(6, 4);
            MenuSePlay(5);
            mode = 0;
            step = 0;
            make_cursor = 0;
            unk_eb6 = 1;
        }
        break;
    default:
        mode = 0;
        step = 0;
        break;
    }
    return 1;
}
extern char at_3621[];
extern char at_3622[];
extern char at_3623[];
extern char at_3624[];
extern char at_3625[];
extern char at_3626[];
extern char at_3627[];
extern char at_3628[];
extern char at_3629[];
extern char at_3630[];
extern char at_3631[];
extern char at_3632[];

#ifdef NONMATCHING
#pragma opt_common_subs off
void CMenuInvent::CalcTex() {
    if (bg_form != NULL) {
        float *left_top = GetMenuMainFrameLeftTopPos(0);
        int bg_pos[2] = {0, 0};
        bg_pos[0] = (int)left_top[0];
        bg_pos[1] = (int)(left_top[1] - 480.0f);
        bg_form->x = bg_pos[0];
        bg_form->y = bg_pos[1];
    }
    blink_count++;
    blink_count %= 50;
    if (blink_count >= 180000) {
        blink_count = 0;
    }
    float shade = 128.0f + 64.0f * sinf(mgAngleLimit(3.1415927f * blink_count / 50.0f));
    neta_color[0] = shade;
    neta_color[1] = shade;
    neta_color[2] = 128.0f;
    scoop_color[0] = scoop_color[1] = shade;
    CMenuPosDataForm *balloon = MenuPosData->GetFormInfo(at_3621);
    if (balloon != NULL) {
        float center[2];
        balloon->GetPutPosXY(at_3622, center[0], center[1]);
        if (mode == 5 && step > 0 && step < 3) {
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
        NetaClipRange clip = at_3379;
        clip.top = neta_board_form->y;
        clip.bottom = neta_board_form->y + 6.0f + 270.0f;
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
                clip.top = neta_board_form->y;
                float angle = neta_circle_angle + slot_angle * i;
                target[0] = (int)(center[0] + neta_circle_radius * cosf(angle));
                target[1] = (int)(center[1] + neta_circle_radius * sinf(angle));
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
                clip.top = neta_board_form->y + 6.0f + 54.0f;
                if (neta_select_type[i] == 0) {
                    GetNetaBoardCursorPosition(neta_select_index[i], target);
                    form->SetNextMovePos(target, 2);
                    if ((target[1] < clip.top && form->y < clip.top) ||
                        (target[1] > clip.bottom && form->y > clip.top) || target[0] < 0) {
                        form->SetRGBACalcParam(3, -0x1C, 0);
                    }
                } else if (neta_select_type[i] == 1) {
                    GetNetaMemoCursorPosition(neta_select_index[i], target);
                    target[0] += 200;
                    form->SetNextMovePos(target, 2);
                    form->SetRGBACalcParam(3, -0x10, 0);
                    if ((target[1] < clip.top && form->y < clip.top) ||
                        (target[1] > clip.bottom && form->y > clip.top)) {
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
            bar_step = 108.0f / (pic_name_info_num - 9.0f);
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
        if (mode != 13) {
            arrow_count++;
        }
        if (arrow_count >= 50) {
            arrow_count = 0;
        }
        if (neta_memo_arrow != NULL && neta_board_arrow != NULL) {
            neta_board_arrow->x = neta_memo_arrow->x;
            neta_board_arrow->y = neta_memo_arrow->y + 6.0f * sinf(3.1415927f / 25.0f * arrow_count);
        }
        neta_board_form->SetNumber(at_3623, InventUserDataPtr->GetNowHavePictureNum());
    }
    if (album_big_form != NULL && album_big_form->draw_flag != 0) {
        int cursor[2];
        album_big_form->GetPutPosXY(at_3624, cursor[0], cursor[1]);
        album_scroll_x = cursor[0] - 2;
        CalcMenu1(cursor[1] - 2 - album_top * 0x36, &album_scroll_y, 4.0f, 1.0f, album_scroll_reset);
        MENUFORMPARTS_TYPE *frame = album_big_form->GetPartInfo(at_3625);
        MENUFORMPARTS_TYPE *bar = album_big_form->GetPartInfo(at_3626);
        if (frame != NULL && bar != NULL) {
            bar[0].x = bar[1].x = bar[2].x = frame[0].x + 2.0f;
            float length = bar[0].h + bar[1].h + bar[2].h;
            float bar_y = bar[0].y;
            CalcMenu1(frame[0].y + 4.0f + (frame[1].h + 4.0f - length) / 20.0f * album_top, &bar_y, 4.0f, 0.0f,
                      album_scroll_reset);
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
        CMenuPosDataForm *clip = MenuPosData->GetFormInfo(at_3627);
        clip->x = title->x;
        int card_pos[2];
        title->GetPutPosXY(at_3628, card_pos[0], card_pos[1]);
        int bar_size[2];
        title->GetPutPosXY(at_3629, bar_size[0], bar_size[1]);
        card_list_form->x = title->x + 10.0f;
        CalcMenu1(card_pos[1] - card_top * 46, &card_list_form->y, 4.0f, 2.0f, reset);
        MENUFORMPARTS_TYPE *base_bar = title->GetPartInfo(at_3630);
        MENUFORMPARTS_TYPE *bar_top = title->GetPartInfo(at_2128__3);
        MENUFORMPARTS_TYPE *bar_mid = title->GetPartInfo(at_2129__2);
        MENUFORMPARTS_TYPE *bar_end = title->GetPartInfo(at_2130__2);
        int card_max = EnableSelectMaxCardList();
        float bar_step = 0.0f;
        float knob = bar_size[1] * (5.0f / card_max);
        float hidden = card_max - 5;
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
            sprintf(name, at_3631, i);
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
    case 0:
    case 1:
        if (chara != NULL) {
            float pos[4];
            float move[4];
            float scale[4];
            chara->GetPosition(pos);
            float *target = chara_pos;
            switch (mode) {
            case 5:
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
                if (mode == 5 && step == 3) {
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
        if (mode == 12) {
            if (ask_para.unk_70 == INVENT_ASK_ZOOM) {
                CalcMenuAdd(&kakudai_pic->unk_2c, 0.025f, 1.3f);
            } else if (CalcMenuAdd(&kakudai_pic->unk_2c, -0.025f, 0.7f)) {
                kakudai_pic_form->draw_flag = 0;
            }
        } else {
            kakudai_pic->unk_2c = 0.7f;
        }
    }
    NowGiftBoxPtr = SearchNowPosItemExist();
    if (GiftBoxViewForm != NULL) {
        CursorPos gift_pos = at_3509;
        if (key_arg_no == 3) {
            MenuPosData->GetPosMenuItemOnItemBrd(&gift_pos.x, item_cursor, 0);
        }
        CMenuPosDataForm *gift_form = GiftBoxViewForm;
        gift_form->x = gift_pos.x;
        gift_form->y = gift_pos.y;
        if (mode == 2) {
            NowGiftBoxPtr = NULL;
        }
    }
    if (itembrd_form != NULL && itembrd_form->draw_flag != 0) {
        Func_MenuItemBrdPosStep(item_top);
        Func_MenuItemBrdPrepare(itembrd_form->GetPartInfo(at_3632), MenuUserParam.used_data, NULL, 1);
    }
    if (mode == 6 && step == 1) {
        int effect_pos[2];
        MenuPosData->GetPosMenuItemBrdForEffect(effect_pos, unk_104, 0);
        MenuEffect[0]->base_info[0] = effect_pos[0];
        MenuEffect[0]->base_info[1] = effect_pos[1];
        MenuEffect[1]->base_info[0] = effect_pos[0] + 2;
        MenuEffect[1]->base_info[1] = effect_pos[1] + 1;
    }
    MenuEffect[0]->Step();
    MenuEffect[1]->Step();
}
#pragma opt_common_subs reset
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/inventmn", CalcTex__11CMenuInventFv);
#endif
void CMenuInvent::BootExtendCommand() {
    menu_invent_command_info_ptr = &modecmdtbl_3636[key_arg_no];
    if (menu_invent_command_info_ptr->enable == 0) {
        MenuSePlay(5);
        return;
    }
    menu_invent_command_info_pict_info = GetNowSelectedPictInfo();
    if (menu_invent_command_info_pict_info == NULL || *(s8 *)&menu_invent_command_info_pict_info->used == 0) {
        MenuSePlay(5);
        return;
    }
    menu_invent_command_info_move_album_Space_info = NULL;
    MenuSePlay(19);
    MENU_ASKMODE_PARA ask;
    ask.unk_70 = 0;
    ask.mes_no = 6;
    ask.form = MenuMesForm[ask.mes_no];
    int count = 0;
    for (int i = 0; i < menu_invent_command_info_ptr->cmd_num; i++) {
        int enable = 1;
        if (menu_invent_command_info_ptr->cmd[i] == INVENT_CMD_TO_ALBUM && album_enable == 0) {
            continue;
        }
        ask.unk_48[count] = MES_SHADE_AUTO;
        if (menu_invent_command_info_ptr->cmd[i] == INVENT_CMD_SET_BOARD && neta_select_num >= 3) {
            enable = 0;
        } else if (menu_invent_command_info_ptr->cmd[i] == INVENT_CMD_TO_ALBUM) {
            for (int slot = 0; slot < 50; slot++) {
                USER_PICTURE_INFO *album = InventAlbumPtr->GetAlbumPhotoInfo(slot);
                if (album != NULL && *(s8 *)&album->used == 0) {
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
            ask.unk_48[count] = MES_SHADE_FAINT;
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
        int shade = ask.unk_48[line];
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
    CDC2Mes *yesno_message = MenuDCMsg[5];
    CDC2Mes *command_message;
    command_form = MenuMesForm[ask_para.mes_no];
    command_message = MenuDCMsg[ask_para.mes_no];
    MENU_ASKMODE_PARA *ask = &ask_para;
    char text[0x20];
    int unneeded[50];
    int pos[2];
    ItemNameList2 names;
    ItemNameList2 delete_names;
    int num;
    int all_num;
    switch (ask_para.unk_70) {
    case INVENT_ASK_COMMAND: {
        int line = command_message->CommandMsgCursor();
        if (button & 1) {
            if (command_message->line_shade[line] == MES_SHADE_FAINT) {
                MenuSePlay(5);
                break;
            }
            int command = command_message->item_mes[line] - INVENT_CMD_ZOOM;
            ask->unk_70 = convtbl_3726[command];
            command_form->draw_flag = 0;
            int se = 1;
            switch (ask->unk_70) {
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
                case 0:
                case 4:
                case 6:
                    GetNetaBoardCursorPosition(photo_cursor, pos);
                    picture = photo_cursor;
                    break;
                case 5:
                    sprintf(text, at_3260__2, album_cursor - album_top * 2);
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
                ExeScript(at_3858);
                names = at_3739;
                names.name[0] = GetPhotoName(menu_invent_command_info_pict_info);
                yesno_message->SetMsgItemNo(names.name, se);
                break;
            }
            case INVENT_ASK_DELETE_UNUSED:
                if (key_arg_no == 5) {
                    ExeScript(at_3859);
                } else {
                    ExeScript(at_3860);
                }
                break;
            case INVENT_ASK_DELETE_ALL:
                if (key_arg_no == 5) {
                    ExeScript(at_3861);
                } else {
                    ExeScript(at_3862);
                }
                break;
            case INVENT_ASK_TO_ALBUM: {
                ExeScript(at_3863__2);
                names.name[0] = GetPhotoName(menu_invent_command_info_pict_info);
                yesno_message->SetMsgItemNo(names.name, se);
                break;
            }
            case INVENT_ASK_FROM_ALBUM: {
                ExeScript(at_3864__2);
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
            ask->unk_70 = INVENT_ASK_COMMAND;
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
                    ExeScript(at_3865__2);
                    delete_names = at_3765;
                    delete_names.name[0] = GetPhotoName(menu_invent_command_info_pict_info);
                    yesno_message->SetMsgItemNo(delete_names.name, 1);
                    MenuSePlay(13);
                    switch (key_arg_no) {
                    case 0:
                    case 4:
                    case 6:
                        InventUserDataPtr->DeletePhotoData(photo_cursor);
                        break;
                    case 5:
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
                    if (ask->unk_70 == INVENT_ASK_TO_ALBUM) {
                        AttachPictTex(tex_block[4], album_tex, InventAlbumPtr->GetAlbumPhotoInfo(0), 50);
                        album_flag[menu_invent_command_info_move_album_Space_pos] = 1;
                    } else {
                        AttachPictTex(tex_block[3], photo_tex, InventUserDataPtr->GetPhotoInfo(0), 30);
                        album_flag[album_cursor] = -1;
                    }
                    ask->unk_70 = INVENT_ASK_COMMAND;
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
                    int count = CheckPhotoDataNoNeed(photos, num, unneeded);
                    for (int i = 0; i < count; i++) {
                        Init_USER_PICTURE_INFO(&photos[unneeded[i]]);
                    }
                    MenuSePlay(13);
                    if (key_arg_no == 5) {
                        ExeScript(at_3866__2);
                        InitPhotoNetaBoardToAlbum(1);
                    } else {
                        ExeScript(at_3867__2);
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
                    if (key_arg_no == 5) {
                        ExeScript(at_3868__2);
                        InitPhotoNetaBoardToAlbum(0);
                    } else {
                        ExeScript(at_3869);
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
    int cancel = 0;
    switch (step) {
    case 0: {
        int answer = message->YesNoCursor();
        switch (button) {
        case 1:
        case 4:
            if (answer == 0) {
                unk_390 = 0;
                InventInNetaEffectFlag = 1;
                ExeScript(at_3932);
                MenuSePlay(0x20);
                MenuCharaLoadStack.stack_used = 0;
                MenuCharaLoadStack.lock = 0;
                InventInNetaEffectNum4 = InventInNetaEffectNum * 80;
                int count = InventInNetaEffectNum4;
                unsigned int size = count * sizeof(CStarDust);
                unsigned int blocks = (size & 0xF) ? (size >> 4) + 1 : size >> 4;
                InventInNetaEffect = new ((u_long128 *)MenuCharaLoadStack.Alloc(blocks + 2)) CStarDust[count];
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
        if (unk_390 == 0) {
            if (CheckRunStarDust(InventInNetaEffect, InventInNetaEffectNum4) == 0) {
                unk_390++;
            }
        } else {
            unk_390++;
        }
        if (unk_390 > 50) {
            CheckPhotoFlag();
            InventUserDataPtr->PhotoCheckEnd();
            if (photo_only == 1 && unk_112 == 0) {
                UpdataRecordBoard();
            }
            MenuSePlay(0x21);
            InventInNetaEffectFlag = 0;
            step = 2;
            ExeScript(at_3933);
        }
        break;
    case 2:
        if (button != 0) {
            ExeScript(at_3934);
            step = 3;
        }
        break;
    case 3: {
        int answer = message->YesNoCursor();
        switch (button) {
        case 1:
            if (answer == 0) {
                ExeScript(at_3935);
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
        ExeScript(at_3936);
        MenuSePlay(5);
    }
}
CStarDust::CStarDust(void) {
    this->active = 0;
}
#ifdef NONMATCHING
void CMenuInvent::IsAccessAlbum() {
    CDC2Mes *message = MenuDCMsg[4];
    if (message == NULL) {
        return;
    }
    int keys = MenuCommonInfo->CheckSelectKey();
    int button = MenuCommonInfo->CheckPushButton();
    MC_ERROR_INFO *error = NULL;
    MC_CARD_INFO *card = NULL;
    int done = 0;
    if (MCManagerPtr != NULL) {
        MCManagerPtr->GetFuncNo();
        done = MCManagerPtr->Step();
        CMemoryCardManager *manager = MCManagerPtr;
        int port = manager->port;
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
            MenuSePlay(0);
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
        InventAlbumPtr = new ((u_long128 *)MenuInventMCStack.Alloc(0x64CD)) CDC2AlbumData;
        MCManagerPtr = new ((u_long128 *)MenuInventMCStack.Alloc(0x112)) CMemoryCardManager;
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
                if (unk_d7c == 1) {
                    step = 500;
                    ExeScript(at_4356);
                } else {
                    loaded = 2;
                }
            } else if (unk_d7c == 0) {
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
                    unk_d78 = 0;
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
        StepMenuDl2(unk_d78 + MCManagerPtr->total_transferred);
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
            unk_eb6 = 1;
            MenuSePlay(1);
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
            MenuSePlay(1);
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
            MenuSePlay(0);
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
        StepMenuDl2(unk_d78 + MCManagerPtr->total_transferred);
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
            MenuSePlay(1);
            finish = 1;
        }
        break;
    case 220: {
        int answer = message->YesNoCursor2(0);
        if (answer == 1) {
            MenuSePlay(1);
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
                if (photo != NULL && *(s8 *)&photo->used == 0) {
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
            MenuSePlay(1);
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
            unk_d78 = 0;
            MCManagerPtr->SetFuncNo(19);
            InitMenuDl(GetMenuDlTexture(), MCManagerPtr->GetSaveDataSize(4));
        }
        break;
    case 1:
        if (McCheckMCPs2(card) == 0) {
            card_removed = 1;
        } else if (card->formatted == 1) {
            MCManagerPtr->SetFuncNo(16);
            unk_d78 = MCManagerPtr->total_transferred;
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
            unk_d78 = 0;
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
                if (unk_d7c == 1) {
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
        if (unk_d7c == 0) {
            step = 110;
        }
        if (unk_d7c == 1) {
            step = 300;
        }
        ExeScript(at_4371);
    }
    if (card_full != 0) {
        InitMenuDl(NULL, 0);
        if (unk_d7c == 0) {
            step = 100;
        }
        if (unk_d7c == 1) {
            step = 300;
        }
        ExeScript(at_4372);
        MenuDCMsg[4]->SetMsgVolumeNoOne(ActiveSlot_3949 + 1);
    }
    if (card_error == 1) {
        InitMenuDl(NULL, 0);
        ExeScript(at_4373);
        if (unk_d7c == 0) {
            step = 100;
        }
        if (unk_d7c == 1) {
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
        unk_eb6 = 1;
        step = 6;
        if (loaded < 0) {
            step = 0;
            ExeScript(at_4378);
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
    pos[0] = (int)photo_pos[slot][0];
    pos[1] = (int)photo_pos[slot][1];
    if (neta_board_form != NULL) {
        pos[0] = (int)((float)pos[0] + neta_board_form->x);
    }
    pos[1] = (int)((float)pos[1] + photo_scroll);
}
void CMenuInvent::GetNetaMemoCursorPosition(int slot, int *pos) {
    pos[0] = 0;
    if (neta_memo_form != NULL) {
        neta_memo_form->GetPutPosXY(NULL, pos[0], pos[1]);
    }
    pos[1] += slot * 0x1A + 0x4E;
}
int neta_sort(int mode, int first, int last, int *keys) {
    int swapped = 0;
    int i;
    int j;
    for (i = first; i < last; i++) {
        for (j = i + 1; j < last; j++) {
            if ((mode == 0 && keys[j] < keys[i]) || (mode == 1 && keys[j] < keys[i])) {
                int tmp_str = NetaMemoStr[i];
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
    int sort_keys[(0x184)];
    CInventUserData *user_data;
    int i;
    int standard_count;
    PIC_NAME_INFO *info;
    int offset;

    NetaMemoStrNum = 0;
    user_data = GetInventUserDataPtr();
    standard_count = 0;
    i = 0;
    offset = 0;
    while (i < pic_name_info_num && i < (0x200)) {
        info = (PIC_NAME_INFO *)((char *)pic_name_info_top + offset);
        if (info == NULL) {
            break;
        }
        if (0 <= user_data->CheckNetaFlag(info->neta_id)) {
            NetaMemoID[NetaMemoStrNum] = info->neta_id;
            NetaMemoStr[NetaMemoStrNum] = (int)info->name;
            sort_keys[NetaMemoStrNum] = info->unk_2;
            if (info->neta_id < (0x3E8)) {
                standard_count += 1;
            }
            NetaMemoStrNum += 1;
        }
        offset += 8;
        i += 1;
    }
    do {
        i = 0;
        i |= neta_sort(unk_392, 0, standard_count, sort_keys);
        i |= neta_sort__FiiiPi(unk_392, standard_count, NetaMemoStrNum);
    } while (i != 0);
    for (i = NetaMemoStrNum; i < (0x200); i++) {
        NetaMemoID[i] = 0;
        NetaMemoStr[i] = 0;
    }
}
void MakeMsgNetaName(CDC2Mes *message, CMenuPosDataForm *form, USER_PICTURE_INFO *photo, int *pos, int show_mark) {
    NetaNameBlank blank = at_4470;
    char *name = GetPhotoName(photo);
    int offset_x = 6;
    if (name == NULL) {
        name = blank.text;
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

#ifdef NONMATCHING
void MenuInventCreateCardDraw(int &tex_block, float *pos) {
    mgCTexture *texture = Tex_Hatsumei;
    if (texture != NULL) {
        MenuReloadTexture(tex_block, texture->block);
        mgRect<int> card_rect(280, 466, 231, 45);
        mgRect<int> put_rect;
        put_rect.Set(0, 0, 0, 0);
        mgCDrawPrim *prim = GetMenuPrim();
        ScreenPoint origin = at_4493;
        origin.xy[0] = (int)pos[0];
        origin.xy[1] = (int)pos[1];
        put_rect.Set(origin.xy[0], origin.xy[1], card_rect.right, card_rect.bottom);
        MenuColor rgba = at_4494;
        SetSpriteEnv(prim, 0);
        prim->Bilinear(1);
        prim->Begin(6);
        prim->Texture(texture);
        int i;
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
            put_rect.left = origin.xy[0] + 35;
            put_rect.top = origin.xy[1] + 6;
            for (i = 0; i < 256; i++) {
                if (put_rect.top + put_rect.bottom >= 20) {
                    mgRect<float> icon_rect(put_rect.left, put_rect.top, 32.0f, 33.0f);
                    DrawOneItem(prim, icon_rect, InventUserDataPtr->GetCreateItemID(i), 2, NULL, rgba.rgba, 0);
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
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/inventmn", MenuInventCreateCardDraw__FRiPf);
#endif
#ifdef NONMATCHING
void PictureDraw(mgCTexture *tex, USER_PICTURE_INFO *photo, float x, float y, float scale, int alpha, int red,
                 int blue, int green) {
    if (tex == NULL) {
        return;
    }
    float w = 80.0f;
    float h = 64.0f;
    mgRect<int> tex_rect;
    tex_rect.Set(0, 0, 64, 64);
    w *= scale;
    x += (80.0f - w) / 2.0f;
    h *= scale;
    y += (64.0f - h) / 2.0f;
    if (mgScreenWidth < x) {
        return;
    }
    float bottom = y + h;
    if (bottom < 0.0f) {
        return;
    }
    mgCDrawPrim *prim = GetMenuPrim();
    SetSpriteEnv(prim, 1);
    prim->Shading(0);
    prim->AntiAliasing(1);
    prim->Begin(6);
    prim->Color(0x20, 0x20, 0x20, alpha * 2 / 3);
    prim->Vertex(3.0f + (x - 2.0f), 3.0f + (y - 2.0f), 0.0f);
    float right = 2.0f + (x + w);
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
    mgRect<int> put_rect;
    put_rect.Set(x, y, w, h);
    PrimQuad(prim, put_rect, tex_rect);
    prim->End();
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/inventmn", PictureDraw__FP10mgCTextureP17USER_PICTURE_INFOfffiiii);
#endif
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
    mgCTexture *texture = NULL;
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
#ifdef NONMATCHING
void MenuInventPictureBoardDraw(float *pos, int &tex_block, int alpha) {
    if (CMenuInventPt == NULL || CMenuInventPt->neta_board_form == NULL) {
        return;
    }
    USER_PICTURE_INFO *photos = InventUserDataPtr->GetPhotoInfo(0);
    MenuReloadTexture(tex_block, CMenuInventPt->photo_tex[0]->block);
    int top = 108.0f + (4.0f + pos[1]);
    mgRect<int> clip;
    clip.Set(0, top, mgScreenWidth - 1, top + 163);
    MenuClipRectCheck(clip);
    SetMenuScissor(clip);
    int i;
    mgCDrawPrim *prim = GetMenuPrim();
    for (i = 0; i < 30; i++) {
        USER_PICTURE_INFO *photo = &photos[i];
        if (*(s8 *)&photo->used == 0 || CMenuInventPt->SelectedNetaPhotoAlready(i) != 0) {
            continue;
        }
        float x = pos[0] + CMenuInventPt->photo_pos[i][0];
        float y = CMenuInventPt->photo_scroll + CMenuInventPt->photo_pos[i][1];
        if (y < 20.0f) {
            continue;
        }
        if (410.0f < y) {
            break;
        }
        PictureDraw(CMenuInventPt->photo_tex[i], photo, x, y, 0.7f, alpha, 0x80, 0x80, 0x80);
        if (*(s8 *)&photo->is_new != 0) {
            SetSpriteEnv(prim, 0);
            prim->Begin(6);
            prim->Texture(Tex_Hatsumei);
            prim->Color(0x80, 0x80, 0x80, alpha);
            mgRect<int> new_mark;
            new_mark.Set(74, 342, 34, 14);
            PrimQuad(prim, 35.0f + x, 44.8f + y, new_mark);
            prim->End();
        }
    }
    ResetMenuScissor();
    if (InventInNetaEffectFlag != 0) {
        NetaEffectTarget target = at_4638;
        target.x = 24.0f + pos[0];
        target.y = 26.0f + pos[1];
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
                float dy = target.y - effect_pos[1];
                effect_pos[0] += (target.x - effect_pos[0]) / 26.0f;
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
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/inventmn", MenuInventPictureBoardDraw__FPfRii);
#endif
void MenuInventAlbumPictureDraw(float *origin, int &loadedTex) {
    mgRect<int> unusedRect;
    mgRect<int> clipRect;
    USER_PICTURE_INFO *photo;
    float y;
    int i;
    int offset;
    float top;
    int clip_top;

    unusedRect.Set(0, 0, 0, 0);
    top = (8.0f) + origin[1];
    clip_top = (int)top;
    clipRect.Set(0, clip_top, mgScreenWidth - 1, (int)(((270.0f) + top) - 2.0f));
    MenuClipRectCheck(clipRect);
    SetMenuScissor(clipRect);
    photo = InventAlbumPtr->GetAlbumPhotoInfo(0);
    mgCTexture *first_texture = CMenuInventPt->album_tex[0];
    if (first_texture != NULL) {
        MenuReloadTexture(loadedTex, first_texture->block);
        i = 0;
        offset = 0;
        y = CMenuInventPt->album_scroll_y;
        do {
            if ((30.0f) < y && photo != NULL && *(signed char *)&photo->used == 1) {
                PictureDraw(*(mgCTexture **)((u8 *)CMenuInventPt + 0x440 + offset), photo, *(float *)((u8 *)CMenuInventPt + 0x250) + (80.0f) * (float)(i % 2), y, (0.7f), 0x80, 0x80, 0x80, 0x80);
            }
            if (i % 2 != 0) {
                y += (54.0f);
            }
            if ((410.0f) < y) {
                break;
            }
            i += 1;
            offset += 4;
            photo = (USER_PICTURE_INFO *)((u8 *)photo + 0x18);
        } while (i < (0x32));
        ResetMenuScissor();
    }
}
void MenuInventNetaMemoDraw(float *origin, int &loadedTex) {
    mgRect<int> clipRect;
    mgRect<int> rowRect;
    mgRect<int> barRect;
    struct {
        u_char font[0x94];
        int draw_x;
        int draw_y;
        u_char tail[0xB8 - 0x9C];
    } menu_font;
    char text[0x20];
    int i;
    mgCDrawPrim *prim;
    float top;
    float left;
    float row_y;
    int clip_top;
    int clip_bottom;
    int text_x;
    int text_y;
    int str_offset;
    int id_offset;

    if (Tex_Hatsumei != 0 && !(origin[0] < -200.0f)) {
        top = 76.0f + origin[1];
        clip_top = (int)top;
        clip_bottom = (int)(240.0f + top);
        clipRect.Set(0, clip_top, mgScreenWidth, clip_bottom);
        MenuClipRectCheck(clipRect);
        SetMenuScissor(clipRect);
        MenuReloadTexture(loadedTex, Tex_Hatsumei->block);
        rowRect.Set(0x144, 0x180, 0xBC, 6);
        left = 16.0f + origin[0];
        row_y = 2.0f + (24.0f + CMenuInventPt->memo_scroll);
        prim = (mgCDrawPrim *)GetMenuPrim();
        SetSpriteEnv(prim, 0);
        prim->Begin(6);
        prim->Texture(Tex_Hatsumei);
        prim->Color(0x80, 0x80, 0x80, 0x80);
        i = 0;
        do {
            if (!(row_y < (float)(clip_top - 0x28))) {
                if ((float)clip_bottom < row_y) {
                    break;
                }
                PrimQuad(prim, left, row_y, rowRect);
            }
            i += 1;
            row_y += 26.0f;
        } while (i < (0x200));
        prim->End();
        ResetMenuScissor();
        barRect.Set(0x90, 0x166, 8, 0x1C);
        SetSpriteEnv(prim, 0);
        prim->Begin(6);
        prim->Texture(Tex_Hatsumei);
        prim->Color(0x80, 0x80, 0x80, 0x80);
        PrimQuad(prim, 209.0f + origin[0], *(float *)((u8 *)CMenuInventPt + 0x35C), barRect);
        prim->End();
        SetMenuScissor(clipRect);
        MenuReloadTexture(loadedTex, MenuArg.mes_tex_block);
        text_x = (int)(6.0f + left);
        text_y = (int)(4.0f + CMenuInventPt->memo_scroll);

        __ct__9CMenuFontFv(&menu_font);
        ((CMenuFont *)&menu_font)->SetClearance(0xE, 0x18);
        i = 0;
        str_offset = 0;
        id_offset = 0;
        while (i < pic_name_info_num && i < (0x200)) {
            if (text_y >= clip_top - 0x28) {
                if (clip_bottom < text_y) {
                    break;
                }
                int number = *(int *)((u8 *)NetaMemoStr + str_offset);
                if (number != 0) {
                    short neta_id = *(short *)((u8 *)NetaMemoID + id_offset);
                    char *prefix;
                    if (neta_id < 0x3E8) {
                        prefix = gaiji_table_4737[0];
                    } else if (neta_id < 0x2710) {
                        prefix = gaiji_table_4737[1];
                    } else {
                        prefix = gaiji_table_4737[2];
                    }
                    sprintf(text, at_4775, prefix, number);
                    ((CMenuFont *)&menu_font)->SetStr(text);
                    ((CMenuFont *)&menu_font)->SetPos(text_x, text_y);
                    ((CFont *)&menu_font)->DrawDirect((char *)&menu_font, menu_font.draw_x, menu_font.draw_y);
                } else {
                    ((CMenuFont *)&menu_font)->SetStr(GetHatena());
                    ((CMenuFont *)&menu_font)->SetPos(text_x, text_y);
                    ((CFont *)&menu_font)->DrawDirect((char *)&menu_font, menu_font.draw_x, menu_font.draw_y);
                }
            }
            str_offset += 4;
            id_offset += 2;
            i += 1;
            text_y += (0x1A);
        }
        ResetMenuScissor();
    }
}
extern int tbl_4782[];
extern char at_5011[];
extern char at_5012[];
extern char at_5013[];
extern char at_5014[];
extern char at_5015[];
extern char at_5016[];
extern u8 itemmenu_chr_rotflag;
extern int *menu_randam_line_draw_postbl;

#ifdef NONMATCHING
inline CMenuInvent::CMenuInvent() {
    int i;
    card_cursor = card_top = 0;
    item_cursor = item_top = 0;
    photo_cursor = photo_top = 0;
    album_cursor = album_top = 0;
    memo_cursor = 0;
    memo_top = 0;
    unk_24c = 0;
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
    unk_584 = -1;
    for (i = 0; i < 3; i++) {
        create_photo_neta[i] = 0;
    }
    unk_594 = -1;
    unk_5b8 = 0;
    neta_circle_snap = 0;
    neta_flash_angle = 0.0f;
    unk_390 = 0;
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
    unk_394 = NULL;
    photo_scroll = 0.0f;
    photo_bar = 0.0f;
    unk_5f8 = 0.0f;
    unk_5f4 = 0;
    blink_count = 0;
    chara_read_info = NULL;
    chara_load_step = 0;
    sub_chara = NULL;
    create_effect = NULL;
    create_chara = NULL;
    arrow_count = 0;
    photo_only = 0;
    gradation_mode = 0;
    unk_eb0 = 0;
    unk_d78 = 0;
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

int MenuInventInit(mgCMemory *memory, int *tex_block, int arg) {
    u8 *pack = memory->stack_bytes;
    MenuInventStack.stSetBuffer((u_long128 *)pack, memory->stack_size);
    MenuInventStack.stAlloc64(memory->stack_used);
    mgCMemory *stack = &MenuInventStack;
    debug_invent_successflag = 0;
    InventAlbumPtr = NULL;
    InventUserDataPtr = NULL;
    CMenuInventPt = new ((u_long128 *)stack->Alloc(StackBlocks(sizeof(CMenuInvent)))) CMenuInvent;
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
    if ((effect = (CMenuEffect *)operator new(sizeof(CMenuEffect), stack->Alloc(StackBlocks(sizeof(CMenuEffect))))) != NULL) {
        effect->Initialize();
    }
    MenuEffect[0] = effect;
    if ((effect = (CMenuEffect *)operator new(sizeof(CMenuEffect), stack->Alloc(StackBlocks(sizeof(CMenuEffect))))) != NULL) {
        effect->Initialize();
    }
    MenuEffect[1] = effect;
    MenuMoveItemPtr = new ((u_long128 *)stack->Alloc(StackBlocks(sizeof(CMenuMoveItem)))) CMenuMoveItem;
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
    InventSubDataReadBGInfo = (unsigned int)GetReadBGFile(0);
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
        CMenuInventPt->ExeScript(at_2253);
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
            CMenuInventPt->unk_392 = sys->invent_unk_2e;
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
            if (this->key_arg_no == 3) {
                MenuMesForm[0]->SetAction(at_5066);
                this->CreateModeSwapForm(0);
            }
            break;
        case 3:
            this->CreateModeSwapForm(1);
            MenuMesForm[0]->SetAction(at_2313);
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
            this->ExeScript(at_5067);
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
    case 0:
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
        case MENU_PUSH_BUTTON_START:
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
#ifdef NONMATCHING
void MenuInventDebugDraw() {
    DrawMenuFillBox(0x40, 0, 0, 0);
    mgCTextureManager *tex_manager = &mgTexManager;
    mgCDrawPrim prim;
    CMenuFont font;
    char line[0x40];
    float scale[4];
    float position[4];
    char model_text[0x80];
    switch (CMenuInventPt->key_arg_no) {
    case 0: {
        int y = 80 - debug_invent_select * 20;
        DrawMenuFillBox(270.0f, 80.0f, 220.0f, 300.0f, 0x80, 0, 0, 0);
        tex_manager->ReloadTexture(MenuArg.mes_tex_block, (sceVif1Packet *)NULL);
        for (int i = 0; i < pic_name_info_num; i++) {
            if (y >= 80) {
                sprintf(line, at_5153, pic_name_info_top[i].neta_id, pic_name_info_top[i].name);
                font.SetStr(line);
                font.SetPos(270, y);
                font.DrawDirect(font.str, font.pos_x, font.pos_y);
            }
            y += 20;
            if (y >= 380) {
                break;
            }
        }
        font.SetStr(at_5154);
        font.SetPos(250, 80);
        font.DrawDirect(font.str, font.pos_x, font.pos_y);
        if (debug_invent_successflag != 0) {
            font.SetStr(at_5155);
            font.SetPos(20, 60);
            font.DrawDirect(font.str, font.pos_x, font.pos_y);
        }
        if (CMenuInventPt->create_chara != NULL) {
            CMenuInventPt->create_chara->GetScale(scale);
            CMenuInventPt->create_chara->GetPosition(position);
            sprintf(model_text, at_5156, scale[0], position[0], position[1], position[2]);
            font.SetStr(model_text);
            font.SetPos(40, 340);
            font.DrawDirect(font.str, font.pos_x, font.pos_y);
        }
        break;
    }
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/inventmn", MenuInventDebugDraw__Fv);
#endif
int MenuInventPushKey(int pad, int pushed) {
    int mode = CMenuInventPt->key_arg_no;
    if (CMenuInventPt->mode <= 0) {
        if (menu_debug_flag != 0) {
            MenuInventDebugKey();
            return 0;
        }
        int leave = 0;
        int command = K_COMMAND_NONE;
        signed char lock = CMenuInventPt->chara_load_step;
        if (lock == 0 || lock == 1) {
            pushed = 0;
        }
        int mode_changed = 0;

        switch (mode) {
            case 0:
            case 4:
            case 6: {
                GridOverCode overcode = at_5173;

                if (CMenuInventPt->album_enable == 0) {
                    overcode.value[3] = 0;
                }
                int old_cursor = CMenuInventPt->photo_cursor;
                if ((pad & (1)) && old_cursor / 2 == 0) {
                    CMenuInventPt->NextDifferentMode(10, 0);
                } else {
                    int result =
                        MenuGlidKeyCheck(pad, &CMenuInventPt->photo_cursor, &CMenuInventPt->photo_top,
                                         &maxtbl_5171, &viewnum_5172, overcode.value, 30);
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
            case 1:
            case 7:
                if (pad & (4)) {
                    if (CMenuInventPt->photo_only == 1) {
                        CMenuInventPt->NextDifferentMode(6, 0);
                    } else {
                        CMenuInventPt->NextDifferentMode(0, 0);
                    }
                    mode_changed = 1;
                }
                break;
            case 2: {
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
                        CMenuInventPt->NextDifferentMode(3, 0);
                        mode_changed = 1;
                    }
                }
                if (old_cursor != CMenuInventPt->card_cursor) {
                    MenuSePlay(0);
                }
                int new_row = CMenuInventPt->card_top;
                if (old_row != new_row) {
                    if (old_row < new_row) {
                        CMenuInventPt->unk_24c = 1;
                    } else {
                        CMenuInventPt->unk_24c = 0;
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
            case 3:
                if (MenuItemBrdKey(pad, &CMenuInventPt->item_cursor, &CMenuInventPt->item_top,
                                   0) == 1) {
                    CMenuInventPt->NextDifferentMode(2, 0);
                    mode_changed = 1;
                }
                break;
            case 5: {
                int old_cursor = CMenuInventPt->album_cursor;
                int result = MenuGlidKeyCheck(pad, &CMenuInventPt->album_cursor,
                                              &CMenuInventPt->album_top, &maxtbl_album_5223,
                                              &viewnum_album_5224, overcode_album_5225, 50);
                if (old_cursor != CMenuInventPt->album_cursor) {
                    MenuSePlay(0);
                }
                if (result == 2) {
                    CMenuInventPt->NextDifferentMode(4, 0);
                    mode_changed = 1;
                }
                break;
            }
            case 10:
                if (pad & (1)) {
                    CMenuInventPt->NextDifferentMode(8, 0);
                } else if (pad & (2)) {
                    int next = 0;
                    if (CMenuInventPt->photo_only == 1) {
                        next = 6;
                    }
                    if (CMenuInventPt->unk_112 == 1) {
                        next = 4;
                    }
                    CMenuInventPt->NextDifferentMode(next, 0);
                    mode_changed = 1;
                }
                break;
            case 8:
                if (pad & (2)) {
                    CMenuInventPt->NextDifferentMode(10, 0);
                }
                break;
            case 11:
                if (pad & (2)) {
                    CMenuInventPt->NextDifferentMode(9, 0);
                }
                break;
            case 9: {
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
                    CMenuInventPt->NextDifferentMode(11, 0);
                } else if (old_cursor != CMenuInventPt->memo_cursor) {
                    MenuSePlay(0);
                }
                break;
            }
        }
        if (mode != CMenuInventPt->key_arg_no) {
            mode_changed = 1;
        }

        int swap_slot = CMenuInventPt->item_cursor;
        CGameDataUsed *item = (CGameDataUsed *)&MenuUserParam.used_data[swap_slot];
        MENU_SWAPITEM_INFO swap_info;
        swap_info.Set(4, swap_slot, -1, 0);
        int next_mode = -1;
        if (mode_changed == 0) {
            switch (CMenuInventPt->key_arg_no) {
                case 0:
                case 6: {
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
                                *(signed char *)&photo->used != 0) {
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
                case 1:
                case 7:
                    switch (pushed) {
                        case 1:
                            CMenuInventPt->ExeScript(at_4378);
                            if (LanguageCode > 0 && LanguageCode < 6) {
                                MenuDCMsg[4]->SetMsgCursor(1);
                                MenuDCMsg[4]->select_top = 1;
                            }
                            CMenuInventPt->mode = 14;
                            CMenuInventPt->step = 0;
                            CMenuInventPt->unk_d7c = 0;
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
                case 2:
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
                case 3:
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
                case 4:
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
                case 5:
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
                case 10:
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
                case 8:
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
                                CMenuInventPt->unk_d7c = 1;
                                command = K_COMMAND_HANDLED;
                                CMenuInventPt->ExeScript(at_5550);
                            }
                            break;
                    }
                    break;
                case 11:
                    if ((pushed & 1) || (pushed & 4)) {
                        command = K_COMMAND_CLOSE_MEMO;
                        MenuSePlay(1);
                    } else if (pushed & 2) {
                        command = K_COMMAND_BACK_MODE;
                        next_mode = 8;
                    }
                    break;
                case 9:
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
                                                       (CMenuPosDataForm *)MenuMesForm[5], 0);
                break;
            case K_COMMAND_SWAP_ITEM:
                if (CMenuInventPt->CheckSpectolFusion(item, 5, MenuMesForm[5]) != 0) {
                    CMenuPosDataForm *form = *(CMenuPosDataForm **)((u_char *)MenuCommonInfo + 0x138);
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
                    if (CMenuInventPt->key_arg_no == 5) {
                        USER_PICTURE_INFO *album_photo = InventAlbumPtr->GetAlbumPhotoInfo(0);
                        PictureSeiton(album_photo, (char *)InventAlbumPtr, 50);
                        InventAlbumPtr->RelateAlbumPicData();
                        AttachPictTex(CMenuInventPt->tex_block[4], CMenuInventPt->album_tex, album_photo,
                                      50);
                    } else {
                        USER_PICTURE_INFO *photo = InventUserDataPtr->GetPhotoInfo(0);
                        PictureSeiton(photo, (char *)InventUserDataPtr->GetPhototWorkAdr(), 30);
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
                if (CMenuInventPt->key_arg_no == 9) {
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
                    if (*(signed char *)&photo->used != 0) {
                        short neta = photo->neta_id;
                        if (neta > 0 && InventUserDataPtr->CheckNetaFlag(neta) < 0) {
                            CursorPos position;
                            CMenuInventPt->GetNetaBoardCursorPosition(i, &position.x);
                            float *effect = (float *)((u_char *)CMenuInventPt + (u_int)(InventInNetaEffectNum * 8));
                            effect[0xD80 / 4] = (float)position.x;
                            effect[0xD84 / 4] = (float)position.y;
                            *(short *)((u_char *)CMenuInventPt + (u_int)(InventInNetaEffectNum * 2) + 0xE70) = 0x80;
                            CMenuInventPt->new_neta_photo[i] = 1;
                            InventInNetaEffectNum += 1;
                        }
                    }
                    i += 1;
                } while (i < 30);
                if (InventInNetaEffectNum <= 0) {
                    CMenuInventPt->ExeScript(at_5551);
                    CMenuInventPt->step = 10;
                } else {
                    CMenuInventPt->ExeScript(at_5552);
                    CMenuInventPt->step = 0;
                }
                break;
            }
            case K_COMMAND_LEAVE_CIRCLE:
                if (CMenuInventPt->CancelNetaCircle(5) < 0) {
                    if (CMenuInventPt->key_arg_no == 6) {
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
                CGameDataUsed source_copy;
                CGameDataUsed held_copy;

                source_copy.CopyGameData(source);
                held_copy.CopyGameData((CGameDataUsed *)&MenuCommonInfo->have_item);
                int result = MenuCommonInfo->ReturnItemMenu(1);
                if (result == 0) {
                    leave = 1;
                    MenuSePlay(5);
                } else if (0 < result) {
                    MenuCommonInfo->SetHaveItemInfo(0, 1);
                    source->CopyGameData(&source_copy);
                    ((CGameDataUsed *)&MenuCommonInfo->have_item)->CopyGameData(&held_copy);
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
                    InventManagePt->CheckInventEnable(ideas, &CMenuInventPt->unk_584);
                InventManagePt->GetInventDataInfoByItemID(CMenuInventPt->create_item_id);
                CMenuInventPt->mode = 5;
                CMenuInventPt->unk_5fc = -2;
                if (InventUserDataPtr->IsAlreadyCreatedItem(CMenuInventPt->create_item_id) >= 0) {
                    CMenuInventPt->step = 4;
                    CMenuInventPt->ExeScript(at_5553);
                    ItemNameList1 item_name = at_5448;
                    item_name.name[0] = GetItemMessage(CMenuInventPt->create_item_id);
                    message->SetMsgItemNo(item_name.name, 1);
                } else {
                    CMenuInventPt->ExeScript(at_5554);
                }
                break;
            }
            case K_COMMAND_PICK_CREATED: {
                int item_id = InventUserDataPtr->GetCreateItemID(CMenuInventPt->card_cursor);
                MenuSePlay(1);
                if (item_id <= 0) {
                    CMenuInventPt->PrepareNextMode(0);
                } else {
                    CMenuInventPt->unk_FC = item_id;
                    CMenuInventPt->make_num = 1;
                    CMenuInventPt->make_material =
                        &InventManagePt->GetInventDataInfoByItemID(item_id)->materials;
                    CMenuInventPt->mode = 6;
                    CMenuInventPt->step = 0;
                    CMenuInventPt->make_cursor = 1;
                    CDataCommon *common = GetCommonItemData(CMenuInventPt->unk_FC);
                    CMenuInventPt->make_num_max = 1;
                    if (common != NULL) {
                        CMenuInventPt->make_num_max = common->max_num;
                    }
                    int owned = GetUserDataMan()->GetNumSameItem(item_id);
                    CMenuInventPt->make_num_max = CMenuInventPt->make_num_max - owned;
                    if (CMenuInventPt->make_num_max <= 0) {
                        CMenuInventPt->step = 3;
                        CMenuInventPt->ExeScript(at_5555);
                        ItemNameList1 item_name = at_5457;
                        item_name.name[0] = GetItemMessage(CMenuInventPt->unk_FC);
                        MenuDCMsg[4]->SetMsgItemNo(item_name.name, 1);
                        MenuDCMsg[4]->SetMsgVolumeNoOne(common->max_num);
                    } else {
                        if (common->stack_num == 1) {
                            CMenuInventPt->make_num_max = 1;
                        }
                        ItemNameList5 names = at_5460;
                        names.name[0] = GetItemMessage(CMenuInventPt->unk_FC);
                        for (int i = 0; i < CMenuInventPt->make_material->num; i++) {
                            names.name[1 + i] =
                                GetItemMessage(CMenuInventPt->make_material->material[i].item_id);
                        }
                        CMenuInventPt->ExeScript(at_5556);
                        message->SetMsgItemNo(names.name, 5);
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
                CMenuInventPt->ExeScript(at_5557);
                CMenuInventPt->UpdataNetaMemoStr();
                CMenuInventPt->key_arg_no = 11;
                break;
            case K_COMMAND_CLOSE_MEMO:
                CMenuInventPt->ExeScript(at_5067);
                CMenuInventPt->key_arg_no = 8;
                break;
            case K_COMMAND_QUIT:
                CMenuInventPt->mode = 14;
                CMenuInventPt->step = 201;
                CMenuInventPt->unk_d7c = 1;
                CMenuInventPt->ExeScript(at_5550);
                MenuSePlay(5);
                break;
        }

        if (leave != 0) {
            CMenuInventPt->mode = 2;
            if (CMenuInventPt->photo_only == 1) {
                CMenuInventPt->ExeScript(at_5558);
                ModelTriple hidden = at_5474;
                hidden.model[0] = MenuActionChara[0];
                hidden.model[1] = MenuActionChara[3];
                hidden.model[2] = CMenuInventPt->sub_chara;
                int i = 0;
                do {
                    CActionChara *model = hidden.model[i];
                    if (model != NULL) {
                        model->SetFadeFlag(1);
                        model->Show(0, 1);
                        model->fade_alpha = 0.2f;
                    }
                    i += 1;
                } while (i < 3);
            } else {
                CMenuInventPt->ExeScript(at_5559);
                MenuMainFrameModeSet(7, 0);
                ReturnMenuIntern(0);
            }
        }
    }
    return 1;
}
#ifdef NONMATCHING
int MenuInventKey() {
    int result = 0;
    int item_pos[8][2];
    char *names[MES_ITEM_MAX];
    int number_pos[8][2];
    int numbers[8];
    CardListTops tops;
    int count_x;
    int count_y;
    MenuCommonInfo->CheckSelectKey();
    int lr_key = MenuCommonInfo->CheckLRKey();
    int button = MenuCommonInfo->CheckPushButton();
    MenuCommonInfo->CheckKeyInput();
    switch (CMenuInventPt->mode) {
    case 1:
        if (ReadBGSync() == 0 && CMenuInventPt->opened == 0) {
            CMenuInventPt->InitEnd();
            CMenuInventPt->mode = 0;
            CMenuInventPt->opened = 1;
            CMenuInventPt->unk_10 = 0x80;
        }
        break;
    case 2:
        if ((CMenuInventPt->photo_only == 0 && GetMenuMainFrameEndFlag() != 0) ||
            (CMenuInventPt->photo_only == 1 && CalcMenuAdd(&CMenuInventPt->unk_10, -8, 0) != 0)) {
            CMenuInventPt->ExitEnd();
            result = 1;
            if (CMenuInventPt->photo_only == result) {
                result = 2;
            }
        }
        break;
    case 0:
        MenuMoveItemPtr->CheckMove();
        if (MenuMoveItemPtr->move_on != 0) {
            button = 0;
        }
        MenuInventPushKey(lr_key, button);
        break;
    case 14:
        CMenuInventPt->IsAccessAlbum();
        break;
    case 13:
        CMenuInventPt->PhotoNetaEnter(lr_key, button);
        break;
    default:
        CMenuInventPt->ExtendCommand(lr_key, button);
        break;
    }
    CMenuInventPt->LoadCharaCheck();
    if (CMenuInventPt->photo_only == 0) {
        int icon_mode = 2;
        if (CMenuInventPt->mode == 2) {
            icon_mode = 0;
        }
        MenuPosData->StepMainMenuIconMove(GetCommonMenuModeID(), 5, icon_mode);
    }
    MenuPosData->FormStep();
    CMenuInventPt->CalcTex();
    CMenuInventPt->CalcCursorPosition();
    CDC2Mes *item_message = MenuDCMsg[0];
    CDC2Mes *list_message = MenuDCMsg[2];
    CDC2Mes *number_message = MenuDCMsg[3];
    switch (CMenuInventPt->key_arg_no) {
    case 0:
    case 1:
    case 4:
    case 5:
    case 6:
    case 7:
    case 8:
    case 9:
    case 10:
    case 11: {
        USER_PICTURE_INFO *photo = InventUserDataPtr->GetPhotoInfo(CMenuInventPt->photo_cursor);
        if (photo != NULL) {
            CMenuInventPt->SelectedNetaPhotoAlready(CMenuInventPt->photo_cursor);
        }
        if (CMenuInventPt->neta_board_form != NULL) {
            CMenuInventPt->neta_board_form->GetPutPosXY(at_5742, item_pos[0][0], item_pos[0][1]);
            item_pos[0][1] += 5;
        }
        MakeMsgNetaName(list_message, MenuMesForm[2], photo, item_pos[0], 1);
        int line;
        CDC2Mes *name_message = MenuDCMsg[7];
        if (name_message != NULL) {
            short key = CMenuInventPt->key_arg_no;
            if (key == 4 || key == 5) {
                if (CMenuInventPt->album_big_form != NULL && InventAlbumPtr != NULL) {
                    CMenuInventPt->album_big_form->GetPutPosXY(at_5743, item_pos[0][0], item_pos[0][1]);
                    item_pos[0][1] += 5;
                    MenuMesForm[7]->draw_flag = 1;
                    name_message->line_pos_on[0] = 0;
                    MakeMsgNetaName(name_message, MenuMesForm[7],
                                    InventAlbumPtr->GetAlbumPhotoInfo(CMenuInventPt->album_cursor), item_pos[0], 1);
                }
            } else if (key != 6 && CMenuInventPt->unk_112 == 0 && CMenuInventPt->photo_only == 0) {
                for (line = 0; line < 3; line++) {
                    CMenuPosDataForm *name_form = CMenuInventPt->neta_name_form[line];
                    if (name_form != NULL) {
                        name_form->GetPutPosXY(at_5744, item_pos[0][0], item_pos[0][1]);
                        int x = item_pos[0][0];
                        int y = item_pos[0][1];
                        if (line >= 0 && line < MES_LINE_MAX) {
                            name_message->line_pos[line][0] = x;
                            name_message->line_pos[line][1] = y;
                            name_message->line_pos_on[line] = 1;
                        }
                    }
                }
            }
        }
        CMenuPosDataForm *count_form = MenuMesForm[3];
        if (count_form != NULL) {
            count_x = 370;
            count_y = 16;
            if (LanguageCode == 1) {
                count_x = 336;
                count_y = 14;
            }
            if (LanguageCode < 2) {
                count_form->SetPos(count_x, count_y);
            } else {
                MenuPosData->GetEtcTblValue(at_5745, count_x, count_y);
            }
            int message_no = 619;
            if (CMenuInventPt->neta_select_num < 3) {
                number_message->SetMsgVolumeNoOne(3 - CMenuInventPt->neta_select_num);
                message_no = 618;
                MenuPosData->GetEtcTblValue(at_5746, count_x, count_y);
            }
            if (LanguageCode >= 2) {
                MenuMesForm[3]->SetPos(count_x, count_y);
            }
            number_message->MakeMsg(message_no);
        }
        break;
    }
    case 2:
    case 3: {
        tops = at_5642;
        int line = 0;
        tops.top[0] = CMenuInventPt->card_top;
        tops.top[1] = CMenuInventPt->card_top - 1;
        int top = tops.top[CMenuInventPt->unk_24c];
        InventUserDataPtr->GetHatsumeiNum();
        CMenuPosDataForm *list_form = CMenuInventPt->card_list_form;
        float list_x = list_form->x;
        int name_x = 74.0f + list_x;
        int y = 13.0f + list_form->y + (float)(top * 46);
        int number_x = 11.0f + list_x;
        for (int card = top; card < 0; card++) {
            names[line] = NULL;
            item_pos[line][0] = name_x;
            item_pos[line][1] = y;
            y += 46;
            line++;
        }
        int europe = CheckNowEurope();
        for (; line < 7; line++) {
            int card = top + line;
            item_pos[line][0] = name_x;
            item_pos[line][1] = y;
            number_pos[line][0] = number_x;
            number_pos[line][1] = y + 2;
            int item = InventUserDataPtr->GetCreateItemID(card);
            names[line] = GetItemMessage(item);
            numbers[line] = card + 1;
            if (europe != 0) {
                if (card + 1 < 10) {
                    number_pos[line][0] -= 8;
                } else if (card + 1 < 100) {
                    number_pos[line][0] += 2;
                } else {
                    number_pos[line][0] += 12;
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
        list_message->SetMsgItemPos(&item_pos[0][0], 6);
        number_message->SetMsgVolumeNo(numbers, digit_tbl3_5641, 6);
        number_message->SetMsgItemPos(&number_pos[0][0], 6);
        CGameDataUsed *item = CMenuInventPt->SearchNowPosItemExist();
        if (CMenuInventPt->key_arg_no == 2 && InventUserDataPtr->GetCreateItemID(CMenuInventPt->card_cursor) <= 0) {
            item_message->MakeMsg(617);
        } else {
            item_message->MakeMsg(item);
        }
        break;
    }
    }
    return result;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/inventmn", MenuInventKey__Fv);
#endif
void MenuInventDraw() {
    MenuPosData->FormDraw();
    MenuEffect[0]->Draw();
    MenuEffect[1]->Draw();
    if (menu_debug_flag != 0) {
        MenuInventDebugDraw();
    }
}


// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", scoop_table__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", menu_scoop_str_tag__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", pic_tag__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", addstringtable_1722__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", invent_teigi_func__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2455__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", invent_color_tbl__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2639__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", Tb_2819__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", D_003532DF__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", jp_conv_lentbl_2835__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2913__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", eff_light_2927__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", wavname_2960__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3201__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", wakutype_3203__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3306__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", modecmdtbl_3636__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", gaiji_table_4737__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", tbl_4782__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_5173__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", nextmodetbl_5183__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", overcode_album_5225__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", digit_tbl3_5641__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", NewComer_5648__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_1046__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_1537__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_1655__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_1656__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_1664__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_1723__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_1724__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_1725__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_1947__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_1948__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2005__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2124__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2125__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2126__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2127__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2128__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2129__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2130__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2131__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2132__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2133__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2134__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2135__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2136__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2137__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2138__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2139__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2140__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2141__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2142__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2143__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2144__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2145__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2146__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2147__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2148__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2149__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2150__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2151__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2152__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2244__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2245__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2246__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2247__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2248__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2249__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2250__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2251__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2252__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2253__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2313__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2368__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2369__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2395__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2396__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2520__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2521__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2522__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2523__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2524__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2525__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2526__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2527__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2528__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2543__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2544__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2545__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2546__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2712__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2713__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2720__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2732__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2733__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2734__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2735__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2736__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2737__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2820__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2821__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2848__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2849__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2929__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2930__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2952__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2953__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2961__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2962__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2963__DATA);
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
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3257__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3258__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3259__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3260__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3261__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3262__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3263__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3264__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3348__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3349__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3350__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3351__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3352__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3353__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3621__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3622__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3623__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3624__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3625__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3626__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3627__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3628__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3629__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3630__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3631__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3632__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3858__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3859__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3860__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3861__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3862__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3863__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3864__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3865__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3866__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3867__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3868__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3869__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3871__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3870__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3932__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3933__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3934__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3935__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_3936__DATA);
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
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_4378__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_4379__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_4380__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_4775__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_5011__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_5012__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_5013__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_5014__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_5015__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_5016__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_5066__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_5067__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_5068__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_5153__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_5154__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_5155__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_5156__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_5550__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_5551__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_5552__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_5553__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_5554__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_5555__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_5556__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_5557__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_5558__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_5559__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_5562__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_5560__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_5649__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_5650__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_5651__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_5652__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_5653__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_5654__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_5742__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_5743__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_5744__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_5745__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_5746__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_5747__DATA);

// Virtual tables (.vtables)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", __vt__11CMenuInvent__DATA);

// Small initialised data (.sdata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", invent_grade_fff__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_2562__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", gobitbl_2847__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", sndtimetbl_2868__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", getfilename_2928__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", sndfileName_2951__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", convtbl_3726__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_4470__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", at_4494__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", maxtbl_5171__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", viewnum_5172__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", maxtbl_album_5223__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", viewnum_album_5224__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(debug_invent_successflag, 0x4);
INCLUDE_BSS(InventUserDataPtr, 0x4);
INCLUDE_BSS(InventAlbumPtr, 0x4);
INCLUDE_BSS(InventManagePt, 0x4);
INCLUDE_BSS(MCManagerPtr, 0x4);
INCLUDE_BSS(pict_seiton_case, 0x4);
INCLUDE_BSS(scoop_str_stack, 0x4);
INCLUDE_BSS(PicNameStack, 0x4);
INCLUDE_BSS(pic_name_info_top, 0x4);
INCLUDE_BSS(pic_name_info_num, 0x4);
INCLUDE_BSS(pic_name_info_num_count, 0x4);
INCLUDE_BSS(at_1788__2, 0x4);
INCLUDE_BSS(inventSpiDataTblTop, 0x4);
INCLUDE_BSS(invent_num_counter, 0x4);
INCLUDE_BSS(at_1965, 0x4);
INCLUDE_BSS(NetaMemoStrNum, 0x4);
INCLUDE_BSS(Tex_Hatsumei, 0x4);
INCLUDE_BSS(InventSubDataReadBGInfo, 0x8);
INCLUDE_BSS(at_3202, 0x8);
INCLUDE_BSS(at_3317, 0x8);
INCLUDE_BSS(at_3363, 0x8);
INCLUDE_BSS(at_3379, 0x8);
INCLUDE_BSS(at_3509, 0x8);
INCLUDE_BSS(menu_invent_command_info_pict_info, 0x4);
INCLUDE_BSS(menu_invent_command_info_ptr, 0x4);
INCLUDE_BSS(menu_invent_command_info_move_album_Space_info, 0x4);
INCLUDE_BSS(menu_invent_command_info_move_album_Space_pos, 0x4);
INCLUDE_BSS(at_3739, 0x8);
INCLUDE_BSS(at_3765, 0x8);
INCLUDE_BSS(InventInNetaEffectFlag, 0x4);
INCLUDE_BSS(InventInNetaEffectNum, 0x4);
INCLUDE_BSS(InventInNetaEffectNum4, 0x4);
INCLUDE_BSS(InventInNetaEffect, 0x4);
INCLUDE_BSS(ActiveSlot_3949, 0x4);
INCLUDE_BSS(init_3950, 0x4);
INCLUDE_BSS(CMenuInventPt, 0x8);
INCLUDE_BSS(at_4493, 0x8);
INCLUDE_BSS(at_4638, 0x8);
INCLUDE_BSS(InventManageMan, 0x8);
INCLUDE_BSS(debug_invent_select, 0x4);
INCLUDE_BSS(at_5448, 0x4);
INCLUDE_BSS(at_5457, 0x8);
INCLUDE_BSS(at_5642, 0x8);

// Uninitialised data (.bss)
static mgCMemory MenuInventStack;
static mgCMemory MenuInventCharaStack;
static mgCMemory MenuInventMCStack;
INCLUDE_BSS(pic_name_text_buff_1660, 0x2480);
INCLUDE_BSS(temp_1728, 0x30);
static mgCMemory InventTeigiStack;
INCLUDE_BSS(NetaMemoStr, 0x800);
INCLUDE_BSS(NetaMemoID, 0x400);
INCLUDE_BSS(rec_board_offset_xtbl, 0x28);
INCLUDE_BSS(at_2776, 0x18);
INCLUDE_BSS(at_5460, 0x18);
INCLUDE_BSS(at_5474, 0x18);
