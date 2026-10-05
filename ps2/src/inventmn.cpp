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
extern unsigned int Tex_Hatsumei;
extern unsigned int InventSubDataReadBGInfo;
extern unsigned char MenuItemBrdCalcManner;
extern mgCMemory MenuInventStack;
extern CActionChara *MenuActionChara[7];
extern short NetaMemoID[512];
extern int NetaMemoStr[512];
extern short NetaMemoStrNum;
extern CMenuPosDataForm *GiftBoxViewForm;
extern "C" int fptosi(float);
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
extern char at_1965[];
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
extern char at_2246[];
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
extern char at_2776[];
extern char at_3202[];
extern char at_3317[];
extern char at_3363[];
extern char at_3379[];
extern char at_3509[];
extern char at_3739[];
extern char at_3765[];
extern char at_4378[];
extern char at_4493[];
extern char at_4638[];
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
extern char at_5642[];

extern int pict_seiton_case;
void MenuInventDebugKey();
void MenuInventDebugDraw();
extern char at_2005[];

extern mgCMemory *scoop_str_stack;
extern SPI_TAG_PARAM menu_scoop_str_tag[];
extern mgCMemory *PicNameStack;
extern short pic_name_info_num;
extern int pic_name_info_top;
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/inventmn", ResetAddress__15CInventUserDataFv);
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
        if (info != NULL && *(signed char *)&info->used != 0 && info->neta_id == neta_id) {
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
        if (photo != NULL && *(signed char *)&photo->used != 0) {
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
        (int)operator new[](pic_name_info_num * 8, (u_long128 *)PicNameStack->Alloc(blocks + 2));
    pic_name_info_num_count = 0;
    return 1;
}
int _PIC_NAME(SPI_STACK *stack, int unused) {
    PIC_NAME_INFO *entry;
    SPI_STACK *arg;
    char *name;
    char text[0x100];
    entry = (PIC_NAME_INFO *)(pic_name_info_top + pic_name_info_num_count * 8);
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
    if (*(signed char *)&info->used == 0) {
        return NULL;
    }
    neta_id = info->neta_id;
    if (neta_id > 0) {
        i = 0;
        offset = 0;
        for (; i < pic_name_info_num; i++) {
            if (neta_id == *(u16 *)(pic_name_info_top + offset)) {
                return ((PIC_NAME_INFO *)((i << 3) + pic_name_info_top))->name;
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
        if (*(signed char *)&info->used != 0) {
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/inventmn", CheckMakeItem__17CInventDataManageFiiP13CGameDataUsed);
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/inventmn", _INVENT_DATASET__FP9SPI_STACKi);
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/inventmn", CheckInventItem__Fi);
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
        if (info != NULL && *(signed char *)&info->used != 0) {
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
    unk_eb5 = 1;
    makebrd_form = MenuPosData->GetFormInfo(at_2134__2);
    unk_eb4 = 1;
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/inventmn", LoadCharaCheck__11CMenuInventFv);
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
            unk_61f[i] = -1;

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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/inventmn", SetNetaCircle__11CMenuInventFii);
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
    unk_61f[last] = 0;
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
    CMenuPosDataForm *ask_form = MenuCommonInfo->how_much_form;
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/inventmn", GradationStep__11CMenuInventFv);
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
    mgCTextureManager *tex_manager = &mgTexManager;
    u_int *file = GetPackFile((unsigned int *)pack, at_2732__2, 0);
    if (file != 0) {
        int image_block = this->tex_block[3];
        if (file != 0) {
            tex_manager->EnterIMGFile((u8 *)file, image_block, 0, 0);
            Tex_Hatsumei = (unsigned int)tex_manager->GetTexture(at_2733__2, -1);
        }
        file = GetPackFile((unsigned int *)pack, at_2734__2, 0);
        if (file != 0) {
            tex_manager->EnterIMGFile((u8 *)file, MenuCommonInfo->tex_block[0], 0, 0);
            ((CMenuPosDataManage *)MenuPosData)->AttachCommonTexInfo();
        }
        int size = 0;
        MenuDataAnalyze((char *)GetPackFile((unsigned int *)pack, at_2735__2, &size), size, &data_stack);
        MenuInventStack.Align64();

        for (int i = 0; i < 3; i++) {
            icon_data[i].data = GetPackFile((unsigned int *)pack, icon_data[i].name, &icon_data[i].size);
        }
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
    if (para->result >= -1) {
        MenuSePlay(para->item_no);
        signed char result = para->result;
        switch (result) {
            case 0:
            case 1: {
                SetPreCmdTrush(this, 5, ask_para.item, MenuMesForm[5]);
                CMenuPosDataForm *ask_form = MenuCommonInfo->how_much_form;
                if (ask_form != 0) {
                    ask_form->draw_flag = 0;
                }
            }
        }
    }
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/inventmn", IsCreateObject__11CMenuInventFii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/inventmn", CalcMakeBrd__11CMenuInventFi);
extern "C" int EnableSelectMaxCardList__11CMenuInventFv(CMenuInvent *objet) {
    int var_v0;

    var_v0 = InventUserDataPtr->GetHatsumeiNum() + 1;
    if (var_v0 < 5) {
        var_v0 = 5;
    }
    return var_v0;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/inventmn", CalcCursorPosition__11CMenuInventFv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/inventmn", IsMakeObject__11CMenuInventFii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/inventmn", CalcTex__11CMenuInventFv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/inventmn", BootExtendCommand__11CMenuInventFv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/inventmn", IsAskExtend__11CMenuInventFii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/inventmn", PhotoNetaEnter__11CMenuInventFii);
CStarDust::CStarDust(void) {
    this->active = 0;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/inventmn", IsAccessAlbum__11CMenuInventFv);
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
        info = (PIC_NAME_INFO *)(pic_name_info_top + offset);
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/inventmn", MakeMsgNetaName__FP7CDC2MesP16CMenuPosDataFormP17USER_PICTURE_INFOPii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/inventmn", MenuInventCreateCardDraw__FRiPf);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/inventmn", PictureDraw__FP10mgCTextureP17USER_PICTURE_INFOfffiiii);
void PictureMemoOne(float x, float y, int alpha) {
    mgCDrawPrim *prim;

    prim = GetMenuPrim();
    SetSpriteEnv(prim, 0);
    prim->Bilinear(1);
    prim->Begin(6);
    prim->Texture((mgCTexture *)Tex_Hatsumei);
    prim->Color(0x80, 0x80, 0x80, alpha);
    prim->TextureCrd(0x6E, 0x162);
    prim->Vertex(x, y, 0.0f);
    prim->TextureCrd(0x90, 0x184);
    prim->Vertex(34.0f + x, 34.0f + y, 0.0f);
    prim->End();
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/inventmn", PictureDraw__FRi9mgRect_f_ifPUc);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/inventmn", MenuInventPictureBoardDraw__FPfRii);
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
        y = CMenuInventPt->unk_254;
        do {
            if ((30.0f) < y && photo != NULL && photo->used == 1) {
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
    CMenuFont menu_font;
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
        MenuReloadTexture(loadedTex, ((mgCTexture *)Tex_Hatsumei)->block);
        rowRect.Set(0x144, 0x180, 0xBC, 6);
        left = 16.0f + origin[0];
        row_y = 2.0f + (24.0f + CMenuInventPt->memo_scroll);
        prim = (mgCDrawPrim *)GetMenuPrim();
        SetSpriteEnv(prim, 0);
        prim->Begin(6);
        prim->Texture((mgCTexture *)Tex_Hatsumei);
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
        prim->Texture((mgCTexture *)Tex_Hatsumei);
        prim->Color(0x80, 0x80, 0x80, 0x80);
        PrimQuad(prim, 209.0f + origin[0], *(float *)((u8 *)CMenuInventPt + 0x35C), barRect);
        prim->End();
        SetMenuScissor(clipRect);
        MenuReloadTexture(loadedTex, MenuArg.mes_tex_block);
        text_x = (int)(6.0f + left);
        text_y = (int)(4.0f + CMenuInventPt->memo_scroll);

        menu_font.SetClearance(0xE, 0x18);
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
                    menu_font.SetStr(text);
                    menu_font.SetPos(text_x, text_y);
                    menu_font.DrawDirect(menu_font.str, menu_font.pos_x,
                                             menu_font.pos_y);
                } else {
                    menu_font.SetStr(GetHatena());
                    menu_font.SetPos(text_x, text_y);
                    menu_font.DrawDirect(menu_font.str, menu_font.pos_x,
                                             menu_font.pos_y);
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/inventmn", MenuInventInit__FP9mgCMemoryPii);
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/inventmn", MenuInventDebugKey__Fv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/inventmn", MenuInventDebugDraw__Fv);
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
                    CMenuInventPt->unk_354 = 1;
                }
                if ((pad & 0x20) || (pad & 0x80)) {
                    step += 8;
                    CMenuInventPt->unk_354 = 1;
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
                    CMenuPosDataForm *form = MenuCommonInfo->how_much_form;
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
                        AttachPictTex(CMenuInventPt->tex_block[2], CMenuInventPt->photo_tex, photo,
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
                    (&CMenuInventPt->unk_5c4)[i] = 0;
                    USER_PICTURE_INFO *photo = InventUserDataPtr->GetPhotoInfo(i);
                    if (photo->used != 0) {
                        short neta = photo->neta_id;
                        if (neta > 0 && InventUserDataPtr->CheckNetaFlag(neta) < 0) {
                            CursorPos position;
                            CMenuInventPt->GetNetaBoardCursorPosition(i, &position.x);
                            float *effect = ((float *)CMenuInventPt->unk_d80 + InventInNetaEffectNum * 2);
                            effect[0] = (float)position.x;
                            effect[1] = (float)position.y;
                            ((short *)(CMenuInventPt->unk_d80 + 0xF0))[InventInNetaEffectNum] = 0x80;
                            (&CMenuInventPt->unk_5c4)[i] = 1;
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/inventmn", MenuInventKey__Fv);
void MenuInventDraw() {
    MenuPosData->FormDraw();
    MenuEffect[0]->Draw();
    MenuEffect[1]->Draw();
    if (menu_debug_flag != 0) {
        MenuInventDebugDraw();
    }
}

// Static initialiser (.init)
INCLUDE_ASM("ps2/asm/pal/nonmatchings/inventmn", __sinit_inventmn_cpp);

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

// Static initialiser table (.ctor)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/inventmn", D_0037B020__DATA);

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
INCLUDE_BSS(MenuInventStack, 0x30);
INCLUDE_BSS(MenuInventCharaStack, 0x30);
INCLUDE_BSS(MenuInventMCStack, 0x30);
INCLUDE_BSS(pic_name_text_buff_1660, 0x2480);
INCLUDE_BSS(temp_1728, 0x30);
INCLUDE_BSS(InventTeigiStack, 0x30);
INCLUDE_BSS(NetaMemoStr, 0x800);
INCLUDE_BSS(NetaMemoID, 0x400);
INCLUDE_BSS(rec_board_offset_xtbl, 0x28);
INCLUDE_BSS(at_2776, 0x18);
INCLUDE_BSS(at_5460, 0x18);
INCLUDE_BSS(at_5474, 0x18);
