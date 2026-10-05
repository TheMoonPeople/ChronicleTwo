#include "sound.hpp"
#include "dataread.hpp"
#include "prespr.hpp"
#include "mg_drawprim.hpp"
#include <cstdio>
#include <cstring>
#include "dngmenu.hpp"
#include "editmenu.hpp"
#include "map.hpp"
#include "editparts.hpp"
#include "editdata.hpp"
#include "editmap.hpp"
#include "font.hpp"
#include "sysmes.hpp"
#include "scenesnd.hpp"
#include "savedata.hpp"
#include "userdata.hpp"
#include "gamedata.hpp"
#include "scriptinterpreter.hpp"
#include "mg_math.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "mainloop.hpp"
#include "menucls1.hpp"
#include "menucommon.hpp"
#include "menudraw.hpp"
#include "menusys.hpp"
#include "menumain.hpp"
#include "common.h"

enum { kBitFlagGekkaView = 0x2BE, kBitFlagCulture = 0x208 };
enum { kPartsHidden = 0x8000, kPlaceHidden = 0x40000, kPlaceSingle = 1 };
enum { kKeyRight = 8, kKeyRight2 = 0x20, kKeyLeft = 4, kKeyLeft2 = 0x10 };
enum { kStateBrowse = 0, kStateMakeObject = 6 };
enum { kMakeChooseAmount, kMakeDone, kMakeConfirm, kMakeNeedMaterials };
enum { kTabMake = 0, kTabStock = 1, kTabPaint = 2, kTabHouse = 4, kTabPlaced = 6 };
enum { kSortById, kSortByNameAscending, kSortByNameDescending, kSortModeCount };
enum { kGeoramaMaxParts = 384, kRemovalNpcMax = 32 };

extern short penki_item_no[8];
extern "C" int GetBuildPartsNum__9CSaveDataFi(CSaveData *, int);
extern "C" int GetMsgCursor__7CDC2MesFv(CDC2Mes *);
extern "C" short tbl_957[];
void DrawDownLoadAnaunceSwitch(int value);
void MenuGeoramaMessageMake(int mode);
void MakeMsgPartsItemInfo(CDC2Mes *mes, CEditPartsInfo *info, MENUFORM_MAKEBRD_INFO *makeBrd);
void InitDownLoadAnaunce(mgCMemory *memory);
void CheckMenuLine(int *selected, int *top, int count, int visible);

struct GeoramaVector {
    union {
        float f[4];
        u_long128 qw;
    };
};

struct DownLoadEntry {
      signed char kind;
      u8 unk_1[3];
      char *name;
      u8 unk_8;
      signed char has_extra;
      u8 unk_a[2];
      DownLoadEntry *next;
};
struct DownLoadRect {
    short x;
    short y;
    short w;
    short h;
};
struct GeoStoneDmyCnt {
      int step;
      int remaining_steps;
      int frames;
      GeoStoneDmyCnt *next;
};
struct GeoramaListState16 {
    short selected;
    short top;
};
struct MenuGeoramaSystemInfo {
      u8 unk_0[0x50];
      GeoramaListState16 list_state[7];
};

extern "C" char at_990__3[14];
extern CEditMap *MenuMainMapInfo;
extern "C" char at_3774[];
extern "C" char at_3775[];
extern "C" char at_3296[];
extern "C" char at_3939[];
extern "C" char at_3952[];
extern "C" GeoramaVector at_3757;
extern "C" signed char GeoramaMesMakeManner[5];
extern float GeoramaColorList[][3];
typedef int (*GeoramaPushFunc)(CMenuGeorama *, int, int);
extern GeoramaPushFunc MenuGeoramaPushFunc[];
extern CMenuGeorama *CMenuGeoPt;
extern CRemovalMenu *RemovalMenuPtr;
extern CDC2Mes *MenuDCMsg[9];
extern signed char DownLoadInfoDrawFlag;
extern u16 MenuGeoStoneDownLoad_Request;
extern u16 MenuGeoStoneDownLoad_PartsNum;
extern signed char DownLoadInfoEndFlag;
extern signed char DownLoadMesMakeProgress;
extern DownLoadEntry *DownLoadInfoNext;
extern ClsMes *DownLoadActiveMes;
extern short DownLoadProgress;
extern ClsMes *DownLoadMes[];
extern short DownLoadMesScrlGyouNum;
extern signed char DownLoadMesMakeNo;
extern short DownLoadMesUpY;
extern DownLoadRect DownLoadWinRect;
extern u32 MenuGeoStoneDownLoadTime;
extern GeoStoneDmyCnt *MenuGeoStoneDmyCnt_Now;
extern int HouseInfoSelectY;
extern int HouseInfoCursorY;
extern short HouseInfoSelectLine;
extern short HouseInfoSelectSelect;
extern signed char HouseInfoSelectMoveInit;
extern CMapParts *MenuMapPart;
extern mgCMemory *MenuPartsDrawStack;
extern short GeoramaParts_DrawWaitCnt;
extern ClsMes *GeoramaMes[5];
extern signed char msgtbl_2587[5];
extern signed char GeoramaMesForceMakeFlag;
extern signed char GeoramaMesForceMakeFlag_PaintVer;
extern signed char MenuGeoramaCursorForceSetFlag;
extern signed char MenuGeoStoneDonwLoadFlag;
extern mgCMemory MenuGeoramaStack;
extern mgCTexture *Tex_Georama;
extern u32 GeoRequestFlag;
extern MenuGeoramaSystemInfo *MenuGeoramaSystemData;
extern int PartsMakeOkTableNum;
extern int PartsMakeOkTable[];
extern CMenuPosDataForm *HouseInfoFormGrobal;
extern short MenuEditAnalyzeDataSrcListLimmitNum;
extern int DownLoadMesAlpha;
extern u8 NowPolyGonFormMoveFlag;
extern short MenuGeoramaViewNowPicNo;
extern int MenuGeoramaViewWallPic;
extern char at_1189__2[];
extern char at_1860[];
extern char at_2654[];
extern char at_2655[];
extern char at_2656[];
extern char at_2657[];
extern char at_2658[];
extern char at_2659[];
extern char at_2660[];
extern char at_2661[];
extern char at_2662[];
extern char at_2663[];
extern char at_2664[];
extern char at_2665[];
extern char at_2666[];
extern char at_2667[];
extern char at_2668[];
extern char at_2986[];
extern char at_3158[];
extern char at_3159[];
extern char at_3160[];
extern char at_3161[];
extern char at_3162[];
extern char at_3163[];
extern char at_3164__2[];
extern char at_3165[];
extern char at_3166[];
extern char at_3167[];
extern char at_3181[];
extern char at_3182[];
extern char at_3229[];
extern char at_3291__2[];
extern char at_3292[];
extern char at_3293[];
extern char at_3294[];
extern char at_3295[];
extern char at_3297[];
extern char at_3562[];
extern char at_3563[];
extern char at_3564[];
extern char at_3565[];
extern char at_3566[];
extern char at_3567[];
extern char at_3568[];
extern char at_3569[];
extern char at_3570[];
extern char at_3724[];
extern char at_3725[];
extern char at_3726[];
extern char at_3727__2[];
extern char at_3728__2[];
extern char at_3729__2[];
extern float at_3260;
extern float at_3268;
extern char *dmychar_3207;
extern signed char init_3208;
extern CEditPartsInfo *edparts_info_3580;
extern signed char init_3581;
extern int DestroyNum_3583;
extern short DestroyMaxNum_3584;
extern signed char init_3585;
extern char *DestroyPartsName_3587;
int georama_menu_local_key(int keys);
int MenuRemovalKey();
void MenuRemovalDraw(void);
int StepDownLoadAnaunce(int confirm);
void InitMenuDl3(mgCTexture *texture);
int StepMenuDl3();
void MenuPlacedHousePosLinkMes();
void MenuMapPartsDraw(int &drawWait);
int CheckGekkaViewMode(int viewMode);
int GetPenkiItemNo(int slot);
int MenuGeoramaBasePush(CMenuGeorama *menu, int buttonsHeld, int buttonsPressed);
int MenuGeoramaPlacePush(CMenuGeorama *menu, int buttonsHeld, int buttonsPressed);

// Code (.text)
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editmenu", GetPenkiColor__FiPf);
short ConvGeoramaDataNo(int georama_no) {
    return tbl_957[georama_no];
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editmenu", CheckMenuLine__FPiPiii);
void SetEditMenuEnv(void) {
    CMenuPosDataForm *form;

    form = MenuPosData->GetFormInfo(at_990__3);
    if (form != NULL) {
        form->draw_flag = 1;
        form->SetRGBACalcParam(0, -3, 0x40);
        form->SetRGBACalcParam(1, -3, 0x40);
        form->SetRGBACalcParam(2, -3, 0x40);
        form->x = 0;
        form->y = 0;
    }
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editmenu", MenuGeoramaInit__FP9mgCMemoryi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editmenu", MenuGeoDebugKey__Fv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editmenu", MenuGeoramaKey__Fv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editmenu", MenuGeoramaDraw__Fv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editmenu", MenuGeoramaTitleDraw__FRiPfi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editmenu", MenuGeoramaListDraw__FRiPfii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editmenu", MenuGeoramaAnalyzeDraw__FRiPfi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editmenu", InitDownLoadAnaunce__FP9mgCMemory);
void DrawDownLoadAnaunceSwitch(int value) {
    DownLoadInfoDrawFlag = value;
}
int StepDownLoadAnaunce(int confirm) {
    int advance;
    int unk_24;
    int growing;
    int i;
    float grow_speed;
    int state;

    if (MenuGeoStoneDownLoad_Request + MenuGeoStoneDownLoad_PartsNum <= 0)
        return 1;
    advance = 0;
    if (DownLoadInfoEndFlag == 0)
        return 1;
    if (confirm != 0)
        advance = 1;
    unk_24 = 0;
    growing = 0;
    if (DownLoadMesMakeProgress == 0 && advance != 0) {
        if (DownLoadInfoNext == NULL) {
            MenuSePlay(0x19);
            DownLoadInfoEndFlag = 0;
            return 1;
        }
        DownLoadMesMakeProgress = 1;
        DownLoadActiveMes->push_button = 0;
        MenuSePlay(0x19);
    }
    if (DownLoadMesMakeProgress == 1) {
        if (DownLoadProgress > 3)
            unk_24 = 1;
        else
            DownLoadMesMakeProgress = 2;
    }
    if (DownLoadMesMakeProgress == 3)
        growing = 1;
    grow_speed = 0.5f;
    if ((float)mgFrameRate != 1.0f)
        grow_speed = 1.0f;
    for (i = 0; i < 8; i++) {
        if (DownLoadMes[i] != NULL) {
            if (unk_24 != 0) {
                DownLoadMes[i]->abs_win.y -= 2;
                if (DownLoadMesScrlGyouNum == 2)
                    DownLoadMes[i]->abs_win.y -= 2;
            }
            if (i == DownLoadMesMakeNo && growing != 0)
                DownLoadMes[i]->draw_speed += grow_speed;
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
        int line;
        DownLoadActiveMes = DownLoadMes[DownLoadMesMakeNo];
        DownLoadActiveMes->State();
        DownLoadActiveMes->mes_no = -1;
        DownLoadActiveMes->draw_speed_def = 1.8f;
        DownLoadActiveMes->abs_win.x = DownLoadWinRect.x + 0x14;
        line = DownLoadProgress;
        if (line > 3)
            line = 3;
        if (DownLoadMesScrlGyouNum > 1 && line == 3)
            line -= DownLoadMesScrlGyouNum - 1;
        DownLoadActiveMes->abs_win.y = DownLoadWinRect.y + 0x16 + line * 0x18;
        if (DownLoadInfoNext->kind == 0) {
            char *name = DownLoadInfoNext->name;
            ClsMes *target = DownLoadActiveMes;
            if (name != NULL)
                strcpy(target->name[0], name);
            DownLoadActiveMes->MakeMesWin(0x67C);
        }
        if (DownLoadInfoNext->kind == 1) {
            char *name = DownLoadInfoNext->name;
            ClsMes *target = DownLoadActiveMes;
            if (name != NULL)
                strcpy(target->name[0], name);
            DownLoadActiveMes->MakeMesWin(0x67D);
            if (DownLoadInfoNext->has_extra == 1)
                DownLoadActiveMes->MakeMesWin(0x680);
        }
        DownLoadProgress++;
        DownLoadMesMakeNo++;
        if (DownLoadMesMakeNo > 5)
            DownLoadMesMakeNo = 0;
        DownLoadInfoNext = DownLoadInfoNext->next;
        DownLoadMesScrlGyouNum = 1;
        if (DownLoadInfoNext != NULL) {
            if (DownLoadInfoNext->kind == 1 && LanguageCode > 0) {
                DownLoadMesScrlGyouNum = 2;
                DownLoadProgress++;
            }
        }
        DownLoadMesMakeProgress = 3;
    }
    if (DownLoadMesMakeProgress == 3) {
        state = DownLoadActiveMes->State();
        if (state == 3 || state == 5) {
            DownLoadMesMakeProgress = 0;
            DownLoadActiveMes->push_button = 1;
        }
    }
    return 0;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editmenu", DrawDownLoadAnaunce__Fv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editmenu", MakeDownLoadAnaunce__FiP9mgCMemoryPiPiPi);
void InitMenuDl3(mgCTexture *texture) {
    InitMenuDl(texture, MenuGeoStoneDownLoadTime);
}
int StepMenuDl3() {
    int step;
    if ((int)MenuGeoStoneDownLoadTime <= 0)
        return 1;
    step = 0;
    if (MenuGeoStoneDmyCnt_Now != NULL) {
        MenuGeoStoneDmyCnt_Now->frames--;
        if (MenuGeoStoneDmyCnt_Now->frames <= 0) {
            step = MenuGeoStoneDmyCnt_Now->step;
            MenuGeoStoneDmyCnt_Now->remaining_steps--;
            if (MenuGeoStoneDmyCnt_Now->remaining_steps <= 0)
                MenuGeoStoneDmyCnt_Now = MenuGeoStoneDmyCnt_Now->next;
        }
    }
    return StepMenuDl(step);
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editmenu", MenuPlacedHouseDraw__FRi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editmenu", MenuPlacedHouseMessMake__FP14CEditPartsInfoP10CEditHousei);
void MenuPlacedHousePosLinkMes() {
    CalcMenu1(-HouseInfoSelectLine * 24, &HouseInfoSelectY, 3, 3, HouseInfoSelectMoveInit);
    CalcMenu1((HouseInfoSelectSelect - HouseInfoSelectLine) * 24, &HouseInfoCursorY, 3, 0,
              HouseInfoSelectMoveInit);
    HouseInfoSelectMoveInit = 0;
}
void MenuMapPartsDraw(int &draw_wait) {
    int draw_list[65];
    int blocks[128];
    mgCMemory *stack;
    int set_no;
    int n;
    if (MenuMapPart != NULL && GeoramaParts_DrawWaitCnt >= 0 &&
        (stack = MenuPartsDrawStack) != NULL) {
        stack->stack_used = 0;
        stack->lock = 0;
        for (int i = 0; i < 64; i++)
            draw_list[i] = i;
        draw_list[64] = -1;
        mgBeginDraw(MenuPartsDrawStack, draw_list, NULL);
        MenuMapPart->Draw();
        mgPreEndDraw(NULL);
        for (set_no = 0; set_no < 16; set_no++) {
            int count = MenuMainScene->mds_list_set.GetTextureBlockNo(set_no, blocks, 0x80);
            for (n = 0; n < count; n++) {
                int *top = &blocks[count - n - 1];
                int block = *top;
                mgEndDrawReloadTexture(block, NULL);
                mgEndDraw(block, NULL);
            }
        }
        draw_wait = -1;
    }
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editmenu", MenuGeoramaMessageMake__Fi);
int CheckGekkaViewMode(int view_mode) {
    if (view_mode == kTabHouse && CheckBitFlagMenu(kBitFlagGekkaView) != 0)
        return 1;
    return 0;
}
void CMenuGeorama::InitEnd() {
    char part_name[0x20];
    CMenuPosDataForm *form;
    BG_READ_INFO *read_b_g;
    u8 *image;
    int tex_block;
    int i;
    int k;
    int budget;
    int used_blocks;
    int free_blocks;
    mgCTexture *download_texture;
    u8 *message_pack;

    AttachFormInfo();
    Init_MENUFORM_MAKEBRD_INFO(&make_brd);
    read_b_g = GetReadBGFile(0);
    image = (u8 *)GetPackFile((unsigned int *)read_b_g->buffer, at_2654, NULL);
    tex_block = MenuCommonInfo->tex_block[3];
    mgTexManager.EnterIMGFile(image, tex_block, NULL, NULL);
    script = (char *)GetPackFile((unsigned int *)read_b_g->buffer, at_2655, &script_size);
    MenuPosData->ResetTextureBlockNo(at_1860, MenuArg.mes_tex_block);
    MenuPosData->ResetTextureInfoAll();
    Tex_Georama = mgTexManager.GetTexture(at_2656, tex_block);
    GetMenuMainMessageBuffer();
    message_pack = (u8 *)GetPackFile((unsigned int *)read_b_g->buffer, at_2657, NULL);
    MenuCommandAnalyzeInfo.system_mes_buff[0] = GetSystemMesBuffer();
    MenuCommandAnalyzeInfo.system_mes_buff[1] = (short *)message_pack;
    MenuCommandAnalyzeInfo.mes_buff[0] = GetMenuMainMessageBuffer();
    MenuCommandAnalyzeInfo.mes_buff[1] = NULL;
    ExeScript(at_2658);
    for (i = 0; i < 5; i++)
        GeoramaMes[i]->MakeMesWin(msgtbl_2587[i] + 0x5DC);
    GeoramaMesForceMakeFlag = 1;
    unk_10 = 0x80;
    form = MenuPosData->GetFormInfo(10);
    i = 0;
    do {
        i++;
        form->draw_flag = 1;
        form++;
    } while (i < 0x46);

    ExeScript(at_2659);
    if (title_form != NULL) {
        sprintf(part_name, at_2660, town_no);
        title_form->SetPartDrawFlag(part_name, 1);
    }
    if (MenuPrevEndCode == 2 && MenuArg.param[0] >= 0 && stock_num > 0) {
        sub_step = 0;
        key_arg_no = 2;
        view_mode = kTabStock;
        select = list_info[view_mode].select;
        top = list_info[view_mode].top;
        if (stock_num <= select)
            select = stock_num;
        if (stock_num <= 0)
            key_arg_no = 0;
        LoadGeoramaPart(GetNowModeLoadPartsID(), 0);
        ExeScript(at_2661);
    } else if (MenuPrevEndCode == 8) {
        key_arg_no = 3;
        view_mode = kTabPaint;
        select = list_info[view_mode].select;
        top = list_info[view_mode].top;
        paint_return = 1;
        ExeScript(at_2662);
    } else {
        key_arg_no = 0;
        view_mode = kTabStock;
        LoadGeoramaPart(GetNowModeLoadPartsID(), 0);
    }
    MenuGeoramaCursorForceSetFlag = 1;
    list_form[view_mode]->SetAction(at_2663);
    for (k = 0; k < 5; k++) {
        if (list_form[k] != NULL)
            list_pos[k][1] = 40.0f + list_form[k]->y - 24.0f * (float)list_info[k].top;
    }
    MenuArg.param[0] = -1;
    budget = GetMaxPolyn(town_no);
    polygon_left = budget - MenuMainMapInfo->GetTotalPolyn(NULL, NULL);
    if (title_form != NULL)
        title_form->SetNumber(at_2664, polygon_left);
    if (town_no == 4)
        ExeScript(at_2665);
    ExeScript(at_2666);
    MenuGeoramaMessageMake(0);
    if (LanguageCode > 0)
        MenuDCMsg[2]->font_w += 2;
    MenuGeoStoneDonwLoadFlag = 0;
    download_texture = NULL;
    ExeScript(at_2667);
    if (0 < MenuGeoStoneDownLoad_Request + MenuGeoStoneDownLoad_PartsNum) {
        MenuGeoStoneDonwLoadFlag = 1;
        ExeScript(at_2668);
        MenuDCMsg[5]->fuchi = 5;
        MenuDCMsg[5]->put_centering = 1;
        download_texture = GetMenuDlTexture();
    }
    InitMenuDl(download_texture, MenuGeoStoneDownLoadTime);
    free_blocks = MenuGeoramaStack.stack_size - MenuGeoramaStack.stack_used;
    used_blocks = free_blocks;
    MenuCharaLoadStack.stSetBuffer(
        (u_long128 *)(MenuGeoramaStack.stack + MenuGeoramaStack.stack_used), free_blocks);
}
void CMenuGeorama::ExitEnd() {
    MenuGeoramaSystemData->list_state[0].selected = (short)list_info[0].select;
    MenuGeoramaSystemData->list_state[0].top = (short)list_info[0].top;
    MenuGeoramaSystemData->list_state[1].selected = (short)list_info[1].select;
    MenuGeoramaSystemData->list_state[1].top = (short)list_info[1].top;
    MenuGeoramaSystemData->list_state[2].selected = (short)list_info[2].select;
    MenuGeoramaSystemData->list_state[2].top = (short)list_info[2].top;
    MenuGeoramaSystemData->list_state[3].selected = (short)list_info[3].select;
    MenuGeoramaSystemData->list_state[3].top = (short)list_info[3].top;
    MenuGeoramaSystemData->list_state[4].selected = (short)list_info[4].select;
    MenuGeoramaSystemData->list_state[4].top = (short)list_info[4].top;
    MenuGeoramaSystemData->list_state[5].selected = (short)list_info[5].select;
    MenuGeoramaSystemData->list_state[5].top = (short)list_info[5].top;
    MenuGeoramaSystemData->list_state[6].selected = (short)list_info[6].select;
    MenuGeoramaSystemData->list_state[6].top = (short)list_info[6].top;
    InitMenuDl(NULL, 0);
    InitDownLoadAnaunce(NULL);
    GeoRequestFlag = 0;
}
int CMenuGeorama::GetPartsIDListNum(int list_mode) {
    if (list_mode < 0)
        list_mode = view_mode;
    if (list_mode == kTabStock)
        return stock_num;
    if (list_mode == kTabMake)
        return make_num;
    if (list_mode == kTabPlaced)
        return placed_num + 1;
    if (list_mode == kTabHouse)
        return house_num;
    if (list_mode == kTabPaint)
        return 8;
    return 0;
}
int CMenuGeorama::GetNowMakePartsNum(int id) {
    return MenuMainMapInfo->GetePlacePartsAtInfoID(id, NULL, 0);
}
int GetPenkiItemNo(int slot) {
    if (slot < 0)
        return -1;
    if (slot >= 8)
        return -1;
    return penki_item_no[slot];
}
int CMenuGeorama::ArrangePartsList(int list, int advance_sort) {
    int *mode = &sort_mode[0];
    GEORAMA_PARTS_LIST_ITEM *entries = stock_list;
    int count = stock_num;
    GEORAMA_PARTS_LIST_ITEM swap_a;
    GEORAMA_PARTS_LIST_ITEM swap_b;
    GEORAMA_PARTS_LIST_ITEM swap_c;
    GEORAMA_PARTS_LIST_ITEM swap_d;
    int i;
    int j;

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
    if (advance_sort != 0)
        *mode += 1;
    if (*mode > kSortModeCount - 1)
        *mode = 0;
    switch (*mode) {
        case kSortById:

            for (i = 0; i < count; i++) {
                for (j = i + 1; j < count; j++) {
                    if (entries[j].no < entries[i].no) {
                        memcpy(&swap_a, &entries[j], sizeof(swap_a));
                        memcpy(&entries[j], &entries[i], sizeof(swap_a));
                        memcpy(&entries[i], &swap_a, sizeof(swap_a));
                        i = -1;
                        break;
                    }
                }
            }
            break;
        case kSortByNameAscending:

            for (i = 0; i < count; i++) {
                for (j = i + 1; j < count; j++) {
                    if (strcmp(entries[j].name, entries[i].name) < 0) {
                        memcpy(&swap_b, &entries[j], sizeof(swap_b));
                        memcpy(&entries[j], &entries[i], sizeof(swap_b));
                        memcpy(&entries[i], &swap_b, sizeof(swap_b));
                        i = -1;
                        break;
                    }
                }
            }
            break;
        case kSortByNameDescending:

            for (i = 0; i < count; i++) {
                for (j = i + 1; j < count; j++) {
                    if (strcmp(entries[j].name, entries[i].name) > 0) {
                        memcpy(&swap_c, &entries[j], sizeof(swap_c));
                        memcpy(&entries[j], &entries[i], sizeof(swap_c));
                        memcpy(&entries[i], &swap_c, sizeof(swap_c));
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
                        memcpy(&swap_d, &entries[j], sizeof(swap_d));
                        memcpy(&entries[j], &entries[i], sizeof(swap_d));
                        memcpy(&entries[i], &swap_d, sizeof(swap_d));
                        i = -1;
                        break;
                    }
                }
            }
            break;
    }
    if (list == 0) {
        for (i = stock_num; i < kGeoramaMaxParts; i++) {
            entries[i].no = -1;
            entries[i].name[0] = 0;
            entries[i].num = 0;
        }
    }
    return 0;
}
void CMenuGeorama::UpdateGeoramaPartsList() {
    int i;
    int j;
    int kind;
    int culture_arg;
    int culture_flag;
    CSaveData *save_data;
    int owned;
    CEditParts *parts;
    CEditPartsInfo *info;
    CEditPartsInfo *make_info;
    GEORAMA_PARTS_LIST_ITEM *entry;

    if (MenuMainMapInfo == NULL)
        return;
    place_num = MenuMainMapInfo->GetePlaceIDList(place_no, kGeoramaMaxParts);
    for (i = place_num; i < kGeoramaMaxParts; i++) {
        place_no[i] = -1;
        place_name[i][0] = 0;
    }
    stock_num = 0;
    memset(stock_list, 0, sizeof(stock_list));
    placed_num = 0;
    memset(placed_list, 0, sizeof(placed_list));
    placed_num = 0;
    stock_num = 0;
    house_num = 0;
    for (i = 0; i < place_num; i++) {
        parts = MenuMainMapInfo->GetePlaceParts(place_no[i]);
        if (parts == NULL)
            continue;
        info = parts->info;
        if (info == NULL || (info->attr & kPartsHidden))
            continue;
        strcpy(place_name[i], info->edit_name);
        kind = parts->state;
        if (kind == 1) {
            int fixed_flag = 0;
            entry = &house_list[house_num];
            if (parts->GetPartsType() == 1)
                fixed_flag = 1;
            if (fixed_flag != 0) {
                entry->no = place_no[i];
                entry->num = 1;
                strcpy(entry->name, info->edit_name);
                house_num++;
            }
        }
        if (cpview_form != NULL) {
            culture_flag = GetSaveData()->GetBitFlag(kBitFlagCulture);
            culture_arg = 0;
            if (culture_flag == 0) {
                if (CMenuGeoPt->town_no == 3)
                    culture_arg |= 1;
            }
            cpview_form->SetNumber(at_2986, MenuMainMapInfo->CultureAnalyze(culture_arg));
        }
        if (kind == 0) {
            placed_list[placed_num].no = place_no[i];
            placed_list[placed_num].num = 1;
            strcpy(placed_list[placed_num].name,
                   info->edit_name);
            int found = 0;
            int found_index = -1;
            int count = stock_num;

            j = 0;
            goto placedTest;
        placedBody:
            if (stock_list[j].no == info->id) {
                found_index = j;
                found = 1;
                goto placedDone;
            }
            j++;
        placedTest:
            if (j < count)
                goto placedBody;
        placedDone:
            if (found != 0) {
                stock_list[found_index].num++;
            } else {
                stock_list[stock_num].no = info->id;
                stock_list[stock_num].num = 1;
                strcpy(stock_list[stock_num].name,
                       info->edit_name);
                stock_num++;
            }
            placed_num++;
        }
    }
    save_data = GetSaveData();
    stock_num = 0;
    for (i = 0; i < 0x80; i++) {
        info = MenuMainMapInfo->GetePartsInfoAtID(i);
        if (info != NULL) {
            owned = GetBuildPartsNum__9CSaveDataFi(save_data, info->id);
            if (0 < owned) {
                stock_list[stock_num].no = info->id;
                stock_list[stock_num].num = owned;
                if (info->edit_name != NULL)
                    strcpy(stock_list[stock_num].name,
                           info->edit_name);
                stock_num++;
            }
        }
    }
    ArrangePartsList(0, 0);
    make_num = 0;
    i = 0;
    do {
        make_info = MenuMainMapInfo->GetePartsInfo(i);
        if (make_info == NULL)
            break;
        if (!(make_info->attr & kPartsHidden)) {
            int found = 0;
            for (j = 0; j < PartsMakeOkTableNum && found == 0; j++) {
                if (make_info->id == PartsMakeOkTable[j]) {
                    found = 1;
                    break;
                }
            }
            if (found == 0 && make_info->edit_name != NULL) {
                make_list[make_num].no = i;
                strcpy(make_list[make_num].name,
                       make_info->edit_name);
                make_list[make_num].num =
                    make_info->polyn[0];
                make_num++;
            }
        }
        i++;
    } while (i < kGeoramaMaxParts);
    ArrangePartsList(1, 0);
    ArrangePartsList(2, 0);
}
int CMenuGeorama::GetNowModeLoadPartsID() {
    int selected = list_info[view_mode].select;
    if (view_mode == kTabStock)
        return stock_list[selected].no;
    int id = -1;
    if (view_mode == kTabMake)
        id = make_list[selected].no;
    return id;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editmenu", GetNowSelectEditPartsInfo__12CMenuGeoramaFii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editmenu", LoadGeoramaPart__12CMenuGeoramaFii);
void CMenuGeorama::UpdateGeoramaPartColor(int paint_mode) {
    if (select == 0) {
        MenuArg.result[0] = (int)(127.5f * paint_color[0]);
        MenuArg.result[1] = (int)(127.5f * paint_color[1]);
        MenuArg.result[2] = (int)(127.5f * paint_color[2]);
        int paint = list_info[2].select;
        if (paint < 0 || paint > 7)
            paint = 0;
        MenuArg.result[3] = penki_item_no[paint];
    }
}
void CMenuGeorama::AttachFormInfo() {
    char name[32];
    int i;
    int gekka_view;
    title_form = (CMenuPosDataForm *)MenuPosData->GetFormInfo(at_3158);
    if (title_form != NULL) {
        gekka_view = 0;
        if (CheckGekkaViewMode(town_no) != 0) {
            gekka_view = 1;
            title_form->SetPartDrawFlag(at_3159, 0);
        }
        title_form->SetPartDrawFlag(at_3160, gekka_view != 0);
    }
    make_brd_form = (CMenuPosDataForm *)MenuPosData->GetFormInfo(at_3161);
    cpview_form = (CMenuPosDataForm *)MenuPosData->GetFormInfo(at_3162);
    free_color_form = (CMenuPosDataForm *)MenuPosData->GetFormInfo(at_3163);
    for (i = 0; i < 7; i++) {
        sprintf(name, at_3164__2, i);
        list_form[i] = (CMenuPosDataForm *)MenuPosData->GetFormInfo(name);
    }
    analyze_form = (CMenuPosDataForm *)MenuPosData->GetFormInfo(at_3165);
    analyze_percent_form = (CMenuPosDataForm *)MenuPosData->GetFormInfo(at_3166);
    house_info_form = (CMenuPosDataForm *)MenuPosData->GetFormInfo(at_3167);
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
        ExeScript(at_3181);
    }
    if (exit_script == 1) {
        ExeScript(at_3182);
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
    if (view_parts != NULL) {
        view_parts->GetRotation(rotation);
        if (GamePad__2.On(1) != 0)
            rotation[1] -= 0.05235988f;
        if (GamePad__2.On(2) != 0)
            rotation[1] += 0.05235988f;
        rotation[1] = mgAngleLimit(rotation[1]);
        view_parts->SetRotation(rotation);
    }
    return 0;
}
void MakeMsgPartsItemInfo(CDC2Mes *mes, CEditPartsInfo *info, MENUFORM_MAKEBRD_INFO *make_brd) {
    if (init_3208 == 0) {
        dmychar_3207 = at_3229;
        init_3208 = 1;
    }
    char *names[5];
    names[0] = info->edit_name;
    make_brd->material_num = 0;
    if (names[0] != NULL)
        strcpy(mes->name[0], names[0]);
    for (int i = 0; i < 4; i++) {
        EditPartsMaterial *material = info->GetMaterial(i);
        names[i + 1] = dmychar_3207;
        if (material->item_no > 0) {
            make_brd->material_num++;
            names[i + 1] = GetItemMessage(material->item_no);
        }
        if (names[i + 1] != NULL)
            strcpy(mes->name[i + 1], names[i + 1]);
    }
    ((ClsMes *)mes)->SetDefColor(0x80686A6B);
    mes->MakeMsg(0x654);
    mes->StepMsg();
}
int CMenuGeorama::IsMakeObject(int buttons_held, int buttons_pressed) {
    CDC2Mes *mes = MenuDCMsg[2];
    switch (step) {
        case kMakeChooseAmount: {
            int selection = SelectMakeObject(buttons_held);
            if (selection == -1) {
                make_brd.unk_24 = 6;
                make_brd.unk_28 = 0;
            } else if (selection == 1) {
                make_brd.unk_24 = 0;
                make_brd.unk_28 = 6;
            }
            switch (buttons_pressed) {
                case 1:
                case 4:
                    if ((s8)make_cursor == 0) {
                        if (make_parts != NULL) {
                            int enough = 1;
                            for (int i = 0; i < make_brd.material_num; i++) {
                                if (make_brd.line[i].button == 0)
                                    enough = 0;
                            }
                            if (DebugFlag != 0 && GamePad__2.On(2) != 0)
                                enough = 1;
                            if (enough == 0) {
                                ExeScript(at_3291__2);
                                step = kMakeNeedMaterials;
                            } else {
                                ExeScript(at_3292);
                                char *items[1];

                                *(float *)items = at_3260;
                                items[0] = make_parts->edit_name;
                                mes->SetMsgItemNo(items, 1);
                                mes->SetMsgVolumeNoOne(CBaseMenuClass::make_num);
                                step = kMakeConfirm;
                            }
                        }
                        break;
                    }
                case 2:
                    ExeScript(at_3293);
                    mode = kStateBrowse;
                    step = kMakeChooseAmount;
                    break;
            }
            break;
        }
        case kMakeDone:
            if (buttons_pressed != 0) {
                ExeScript(at_3294);
                make_parts = NULL;
                mode = kStateBrowse;
                step = kMakeChooseAmount;
            }
            break;
        case kMakeConfirm: {
            int answer = mes->YesNoCursor2(0);
            if (answer == 1) {
                GetSaveData()->AddBuildPartsNum(make_parts->id, CBaseMenuClass::make_num);
                UpdateGeoramaPartsList();
                GeoramaMesForceMakeFlag = 1;
                ExeScript(at_3295);
                char *items[1];

                *(float *)items = at_3268;
                items[0] = make_parts->edit_name;
                mes->SetMsgItemNo(items, 1);
                mes->SetMsgVolumeNoOne(CBaseMenuClass::make_num);
                for (int i = 0; i < make_brd.material_num; i++) {
                    EditPartsMaterial *material = make_parts->GetMaterial(i);
                    if (material != NULL)
                        GetUserDataMan()->DeleteItem(material->item_no,
                                                     material->num * CBaseMenuClass::make_num);
                }
                step = kMakeDone;
            }
            if (answer == 2) {
                ExeScript(at_3296);
                MakeMsgPartsItemInfo(MenuDCMsg[2], make_parts, &make_brd);
                step = kMakeChooseAmount;
            }
            break;
        }
        default:
            if (buttons_pressed != 0) {
                ExeScript(at_3297);
                step = kMakeChooseAmount;
            }
            break;
    }
    return 0;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editmenu", CalcCursorPosition__12CMenuGeoramaFv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editmenu", CalcTex__12CMenuGeoramaFv);
void CMenuGeorama::CalcMakeBrd() {
    int i;
    int owned;
    EditPartsMaterial *material;
    if (make_brd_form != NULL && mode == kStateMakeObject && step == kMakeChooseAmount) {
        i = 0;
        make_brd.unk_1c = CBaseMenuClass::make_num;
        for (; i < make_brd.material_num; i++) {
            material = make_parts->GetMaterial(i);
            if (material != NULL) {
                make_brd.line[i].kind = 1;
                make_brd.line[i].num =
                    (short)material->num * (short)make_brd.unk_1c;
                owned = GetUserItemHaveNum(material->item_no);
                make_brd.line[i].button = 0;
                if (owned >= make_brd.line[i].num)
                    make_brd.line[i].button = 1;
                make_brd.line[i].sub_num = make_brd.line[i].num - owned;
            }
        }
        for (; i < 4; i++) {
            make_brd.line[i].kind = 0;
            make_brd.line[i].button = 0;
            make_brd.line[i].num = 0;
            make_brd.line[i].sub_num = 0;
        }
        CalcMenuAdd(&make_brd.unk_24, -1, 0);
        CalcMenuAdd(&make_brd.unk_28, -1, 0);
        make_brd.unk_20 = (s8)make_cursor;
        CalcCommonBrdDrawInfo(&make_brd_form->x, &make_brd, (ClsMes *)MenuDCMsg[2]);
    }
}
int MenuGeoramaBasePush(CMenuGeorama *menu, int buttons_held, int buttons_pressed) {
    int result;
    int moved;
    int i;
    int step;
    int load_kind;
    int download_done;
    int view_mode;

    result = 0;
    if (MenuGeoStoneDonwLoadFlag != 0) {
        download_done = StepMenuDl3();
        if (MenuGeoStoneDonwLoadFlag == 1 && download_done != 0) {
            MenuGeoStoneDonwLoadFlag = 2;
            MenuSePlay(0x1F);
            MenuDCMsg[5]->MakeMsg(0x5DD);
        }
        if (MenuGeoStoneDonwLoadFlag == 2 && buttons_pressed != 0) {
            menu->ExeScript(at_1189__2);
            DrawDownLoadAnaunceSwitch(1);
            MenuSePlay(0x13);
            MenuGeoStoneDonwLoadFlag = 3;
            DownLoadMesMakeProgress = 2;
        }
        if (MenuGeoStoneDonwLoadFlag == 3 && StepDownLoadAnaunce(buttons_pressed) == 1)
            MenuGeoStoneDonwLoadFlag = 4;
        if (MenuGeoStoneDonwLoadFlag == 4) {
            if (buttons_pressed != 0)
                MenuGeoStoneDonwLoadFlag = 0;
        }
        return 0;
    }
    if (0 < DownLoadMesAlpha) {
        DownLoadMesAlpha -= 8;
        if (DownLoadMesAlpha <= 0)
            InitDownLoadAnaunce(NULL);
    }
    step = 0;
    if ((buttons_held & kKeyRight) != 0 || (buttons_held & kKeyRight2) != 0)
        step += 1;
    if ((buttons_held & kKeyLeft) != 0 || (buttons_held & kKeyLeft2) != 0)
        step -= 1;
    moved = 0;
    if (MenuKeySelectCheck(step, &menu->view_mode, NULL, 0, 6, 6, 0) != 0) {
        MenuSePlay(0);
        for (i = 0; i < 6; i++) {
            if (i < 3 || i == 4) {
                if (i == menu->view_mode)
                    menu->list_form[i]->SetAction(at_2663);
                else
                    menu->list_form[i]->SetAction(at_3562);
            } else if (menu->view_mode >= 3 && menu->view_mode < 5) {
                menu->list_form[2]->SetAction(at_2663);
                if (menu->view_mode == kTabHouse)
                    menu->list_form[2]->SetAction(at_3562);
            }
        }
        if (menu->view_mode == 5) {
            menu->ExeScript(at_3563);
            NowPolyGonFormMoveFlag = 1;
        } else if (menu->view_mode == kTabHouse) {
            menu->ExeScript(at_3564);
            NowPolyGonFormMoveFlag = 1;
        } else {
            menu->ExeScript(at_3565);
            NowPolyGonFormMoveFlag = 0;
        }
        if (CheckGekkaViewMode(menu->town_no) != 0) {
            menu->ExeScript(at_3566);
            if (menu->view_mode == kTabHouse) {
                menu->ExeScript(at_3567);
                NowPolyGonFormMoveFlag = 1;
            }
        }
        moved = 1;
    }
    if (moved != 0 || (menu->view_loaded == 0 && menu->unk_10 <= 0)) {
        if (menu->view_mode < 3) {
            load_kind = 0;
            if (menu->view_mode == kTabMake)
                load_kind = 1;
            if (menu->view_mode == kTabPlaced)
                load_kind = 2;
            menu->LoadGeoramaPart(menu->GetNowModeLoadPartsID(), load_kind);
        }
        if (menu->view_loaded == 0)
            menu->view_loaded = 1;
    }
    switch (buttons_pressed) {
        case 1:
        case 4:
        case 8:
            view_mode = menu->view_mode;
            if (view_mode < 3 || view_mode == kTabHouse || view_mode == 5) {
                menu->sub_step = 0;
                if (menu->view_mode == kTabHouse &&
                    CheckGekkaViewMode(CMenuGeoPt->town_no) != 0) {
                    menu->key_arg_no = menu->view_mode + 1;
                    menu->step = 0;
                    MenuGeoramaViewNowPicNo = 0;
                    MenuGeoramaViewWallPic = 0;
                    menu->ExeScript(at_3568);
                } else if (0 < menu->GetPartsIDListNum(-1) || menu->view_mode == 5) {
                    menu->key_arg_no = menu->view_mode + 1;
                    menu->top = menu->list_info[menu->view_mode].top;
                    menu->select = menu->list_info[menu->view_mode].select;
                    MenuGeoramaCursorForceSetFlag = 1;
                    if (menu->view_mode == 5)
                        menu->ExeScript(at_3569);
                    else
                        menu->ExeScript(at_3570);
                } else {
                    MenuSePlay(5);
                }
            } else {
                if (view_mode == 3) {
                    MenuArg.end_code = 3;
                    MenuArg.result[0] = -1;
                }
                result = 1;
                MenuSePlay(1);
            }
            break;
        case 2:
            MenuArg.end_code = 0;
            result = 1;
            MenuArg.result[0] = -1;
            MenuSePlay(5);
            break;
    }
    return result;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editmenu", georama_menu_local_key__Fi);
int MenuGeoramaPlacePush(CMenuGeorama *menu, int buttons_held, int buttons_pressed) {
    int result;
    CDC2Mes *msg;
    CMenuPosDataForm *form;
    int item_no[8];
    int amount[8];
    int pos[2];
    int pos_x;
    int pos_y;

    result = 0;
    msg = MenuDCMsg[3];
    form = MenuMesForm[3];
    if (init_3581 == 0) {
        edparts_info_3580 = NULL;
        init_3581 = 1;
    }
    if (init_3585 == 0) {
        DestroyMaxNum_3584 = 0;
        init_3585 = 1;
    }
    switch (menu->sub_step) {
        case 0:
            int key = georama_menu_local_key(buttons_held);
            int prev_selected = menu->select;
            int prev_top = menu->top;
            MenuKeySelectCheck(key, &menu->select, &menu->top, 0,
                               menu->GetNowViewModeMax(1), 8, 0);
            menu->SetGeoListInfo(menu->view_mode, menu->select, menu->top);
            if (prev_top != menu->top) {
                int manner = 0;
                if (prev_top < menu->top)
                    manner = 1;
                GeoramaMesMakeManner[menu->view_mode] = manner;
            }
            if (prev_selected != menu->select) {
                menu->LoadGeoramaPart(menu->GetNowModeLoadPartsID(), 0);
                MenuSePlay(0);
            }
            switch (buttons_pressed) {
                case 1:
                    edparts_info_3580 =
                        menu->GetNowSelectEditPartsInfo(menu->view_mode, menu->select);
                    if (edparts_info_3580 == NULL) {
                        MenuSePlay(5);
                    } else {
                        DestroyPartsName_3587 = edparts_info_3580->edit_name;
                        DestroyNum_3583 = 1;
                        DestroyMaxNum_3584 = 1;
                        if (DestroyPartsName_3587 != NULL) {
                            int j = 0;
                            int offset = 0;

                            for (; j < menu->stock_num; j++) {
                                if (strcmp(DestroyPartsName_3587,
                                           menu->stock_list->name + offset) ==
                                    0) {
                                    DestroyMaxNum_3584 =
                                        menu->stock_list[j].num;
                                    break;
                                }
                                offset += sizeof(GEORAMA_PARTS_LIST_ITEM);
                            }
                        }
                        MenuSePlay(0x13);
                        menu->sub_step = 1;
                        msg->MsgPreset(6);
                        msg->MakeMsg(0x672);
                        int flags = edparts_info_3580->attr;
                        if ((flags & kPlaceSingle) || (flags & kPlaceHidden))
                            msg->line_color[1] = 0x80303030;
                        form->draw_flag = 1;
                        ((ClsMes *)msg)->mes_no = -1;
                        msg->value_space = 2;
                        msg->SetMsgCursor(0);
                        MenuCommonInfo->GetCursorPos(pos);
                        pos_x = pos[0] + 0x28;
                        pos_y = pos[1] - 0x50;
                        form->x = (float)pos_x;
                        form->y = (float)pos_y;
                        msg->point_x = 0x28;
                        msg->point_y = 0x64;
                        if (MenuCommonInfo->cursor_form != NULL)
                            MenuCommonInfo->cursor_form->draw_flag = 0;
                        msg->SetMsgVolumeNoOne(DestroyNum_3583);
                    }
                    break;
                case 2:
                    menu->ReturnSelectMode(0);
                    break;
                case 4:
                case 32:
                    menu->ArrangePartsList(0, 1);
                    menu->LoadGeoramaPart(menu->GetNowModeLoadPartsID(), 0);
                    MenuSePlay(1);
                    break;
            }
            break;
        case 1:
            msg->AddMsgCursor2(0, 1, 1);
            int cursor = GetMsgCursor__7CDC2MesFv(msg);
            int flags = edparts_info_3580->attr;
            if (cursor == 1 && !(flags & kPlaceHidden)) {
                int old_num = DestroyNum_3583;
                int delta = 0;
                if (buttons_held & kKeyLeft)
                    delta -= 1;
                if (buttons_held & kKeyRight)
                    delta += 1;
                if (buttons_held & kKeyLeft2)
                    delta -= 5;
                if (buttons_held & kKeyRight2)
                    delta += 5;
                if (flags & kPlaceSingle)
                    delta = 0;
                DestroyNum_3583 += delta;
                if (DestroyNum_3583 <= 0)
                    DestroyNum_3583 = 1;
                if (DestroyMaxNum_3584 < DestroyNum_3583)
                    DestroyNum_3583 = DestroyMaxNum_3584;
                if (old_num != DestroyNum_3583)
                    MenuSePlay(0x1D);
            }
            msg->SetMsgVolumeNoOne(DestroyNum_3583);
            switch (buttons_pressed) {
                case 1:
                    if (cursor == 0) {
                        form->draw_flag = 0;
                        int selected = menu->list_info[1].select;
                        CEditPartsInfo *parts_info;
                        parts_info = MenuMainMapInfo->GetePartsInfoAtID(
                            menu->stock_list[selected].no);
                        if (parts_info == NULL) {
                            MenuSePlay(5);
                            break;
                        }
                        MenuArg.end_code = 2;
                        MenuArg.result[0] =
                            menu->stock_list[selected].no;
                        int made = menu->GetNowMakePartsNum(
                            menu->stock_list[selected].no);
                        int avail = menu->stock_list[selected].num;
                        int room = parts_info->max_num - made;
                        if (room < avail)
                            avail = room;
                        int poly_left = menu->polygon_left;
                        if (edparts_info_3580 != NULL && poly_left < edparts_info_3580->polyn[0]) {
                            menu->ExeScript(at_3724);
                            menu->sub_step = 3;
                            MenuArg.end_code = 0;
                            break;
                        }
                        MenuArg.result[1] = avail;
                        MenuArg.result[2] = parts_info->max_num;
                        MenuArg.result[3] =
                            menu->stock_list[selected].num;
                        if (MenuArg.result[1] <= 0) {
                            menu->ExeScript(at_3725);
                            menu->sub_step = 3;
                            MenuArg.end_code = 0;
                            break;
                        }
                        result = 1;
                        MenuSePlay(1);
                    }
                    if (cursor == 1) {
                        if (flags & kPlaceSingle) {
                            MenuSePlay(5);
                        } else if (flags & kPlaceHidden) {
                            MenuSePlay(5);
                        } else {
                            form->draw_flag = 0;
                            menu->sub_step = 2;
                            menu->ExeScript(at_3726);
                            msg->SetMsgItemNo(&DestroyPartsName_3587, 1);
                            msg->SetMsgVolumeNoOne(DestroyNum_3583);
                        }
                    }
                    break;
                case 2:
                    menu->sub_step = 0;
                    menu->ExeScript(at_3727__2);
                    break;
            }
            break;
        case 2:
            int choice = msg->YesNoCursor2(0);
            if (choice == 1) {
                GetSaveData()->AddBuildPartsNum(edparts_info_3580->id, -DestroyNum_3583);
                for (int k = 0; k < 4; k++) {
                    EditPartsMaterial *material = edparts_info_3580->GetMaterial(k);
                    if (material != NULL) {
                        item_no[k] = material->item_no;
                        amount[k] = material->num;
                        if (item_no[k] > 0) {
                            if (amount[k] > 1)
                                amount[k] = amount[k] / 2;
                            amount[k] = DestroyNum_3583 * amount[k];
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
                menu->ExeScript(at_3728__2);
                menu->sub_step = 3;
            }
            if (choice == 2) {
                menu->sub_step = 0;
                menu->ExeScript(at_3727__2);
            }
            break;
        case 3:
            if (buttons_pressed != 0) {
                menu->ExeScript(at_3729__2);
                menu->sub_step = 0;
                if (GetBuildPartsNum__9CSaveDataFi(GetSaveData(), edparts_info_3580->id) <= 0)
                    menu->ReturnSelectMode(0);
                else
                    MenuSePlay(1);
            }
            break;
    }
    return result;
}
int MenuGeoramaMakePush(CMenuGeorama *menu, int keys, int pushed) {
    GeoramaVector position;
    CEditPartsInfo *parts;
    int old_index;
    int step;
    int old_selected;
    int count;
    signed char manner;
    int river;
    short built;
    short placed;
    switch (menu->step) {
        case 0:
            step = georama_menu_local_key(keys);
            old_index = menu->select;
            old_selected = menu->top;
            MenuKeySelectCheck(step, &menu->select, &menu->top, 0,
                               menu->GetNowViewModeMax(0), 8, 0);
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
                MenuSePlay(0);
            }
            switch (pushed) {
                case 1:
                    menu->make_parts = menu->GetNowSelectEditPartsInfo(0, menu->select);
                    if (menu->make_parts == NULL) {
                        MenuSePlay(5);
                    } else {
                        menu->make_cursor = 0;
                        menu->unk_FC = menu->make_parts->id;
                        menu->CBaseMenuClass::make_num = 1;
                        menu->make_num_max = *(short *)&menu->make_parts->max_num;
                        if (0 > menu->make_parts->map_no) {
                            menu->make_num_max *= 4;
                        }
                        if (menu->make_num_max > 99) {
                            menu->make_num_max = 99;
                        }
                        parts = menu->make_parts;
                        count = menu->make_num_max;
                        if (parts->attr & 0x80) {
                            position = at_3757;
                            river = MenuMainMapInfo->GetRiverNum(position.f);
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
                            menu->ExeScript(at_3774);
                            MenuDCMsg[2]->SetMsgVolumeNoOne(count);
                            menu->step = 1;
                        } else {
                            menu->mode = 6;
                            menu->step = 0;
                            menu->ExeScript(at_3296);
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
                    MenuSePlay(1);
                    break;
            }
            break;
        case 1:
            if (pushed != 0) {
                menu->ExeScript(at_3775);
                menu->step = 0;
            }
            break;
    }
    return 0;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editmenu", MenuGeoramaCheckPointPush__FP12CMenuGeoramaii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editmenu", MenuGeoramaAnalyzeSelect__FP12CMenuGeoramaii);
int MenuGeoramaPaintSelect(CMenuGeorama *menu, int keys, int pushed) {
    int done = 0;
    int step = 0;
    int old_cursor;
    float *color;
    float red;
    float green;
    float blue;
    int cursor;
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
    MenuKeySelectCheck(step, &menu->paint_select, &menu->paint_top, 0, 9, 8, 0);
    menu->SetGeoListInfo(menu->view_mode, menu->paint_select, menu->paint_top);
    if (old_cursor != menu->paint_select) {
        MenuSePlay(0);
    }
    switch (pushed) {
        case 1:
        case 8:
        case 4:
            cursor = menu->paint_select;
            if (cursor == 8) {
                MenuArg.end_code = 0x10;
                MenuSePlay(1);
                menu->ExeScript(at_3939);
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
                    MenuArg.end_code = 8;
                    menu->ExeScript(at_3939);
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
int MenuGeoramaPushKey(int keys, int pushed) {
    if (MenuCommonInfo->key_enable == 0) {
        return 0;
    }
    if (MenuGeoramaPushFunc[CMenuGeoPt->key_arg_no](CMenuGeoPt, keys, pushed) == 1) {
        CMenuGeoPt->mode = 2;
        CMenuGeoPt->ExeScript(at_3952);
        CMenuGeoPt->LoadGeoramaPart(-1, 0);
    }
    return 0;
}
void CRemovalMenu::MakeNPCList() {
    int i;
    int j;
    int status;
    npc_num = 0;
    i = 1;
    do {
        status = MenuUserDataManPtr->GetPartyCharaStatus(i);
        if (status != 0 && ((i != 13 && i != 2) || GetNowChapter(GetSaveData()) >= 5) &&
            status != 0 && !(status & 4)) {
            npc_list[npc_num++] = i;
        }
        i++;
    } while (i <= 25);
    j = npc_num;
    if (j < kRemovalNpcMax) {
        do {
            npc_list[j] = 0;
            j++;
        } while (j < kRemovalNpcMax);
    }
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editmenu", KeyStep__12CRemovalMenuFv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editmenu", MenuRemovalInit__FP9mgCMemoryPi);
void CCharaFrameMatching::Initialize(void) {
    this->num = 0;
    this->dst_frame = 0;
    this->src_frame = 0;
}
int MenuRemovalKey() {
    return RemovalMenuPtr->KeyStep();
}
void MenuRemovalDraw(void) {
    MenuPosData->FormDraw();
}
void CBaseMenuClass::InitEnd() {}

// Static initialiser (.init)
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editmenu", __sinit_editmenu_cpp);

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", old_menuparts_pos__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", old_menuparts_rot__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", now_menu_pos_mapparts__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", georama_adjust_position__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", penki_item_no__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", GeoramaColorList__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", georama_parts_adjust_scaletable__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", georama_parts_adjust_z_table__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", tbl_957__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", brdtbl_active_1314__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", brdtbl_noneactive_1315__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", ScrlBarTable_1320__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", brdtbl_noneactive_1547__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", brdtbl_1550__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", offsettable_1551__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", rectboxtbl_1555__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", postbl_2175__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", offset_2176__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", jyunintbl_2187__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_2326__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", constant_msg_xyoffsettbl_2427__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_3361__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_3757__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", MenuGeoramaPushFunc__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_4101__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_990__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_1014__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_1132__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_1133__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_1134__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_1135__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_1136__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_1137__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_1138__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_1189__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_1277__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_1278__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_1299__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_1300__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_1860__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_2146__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_2370__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_2654__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_2655__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_2656__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_2657__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_2658__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_2659__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_2660__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_2661__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_2662__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_2663__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_2664__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_2665__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_2666__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_2667__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_2668__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_2986__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_3158__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_3159__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_3160__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_3161__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_3162__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_3163__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_3164__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_3165__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_3166__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_3167__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_3181__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_3182__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_3229__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_3291__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_3292__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_3293__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_3294__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_3295__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_3296__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_3297__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_3329__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_3330__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_3419__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_3420__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_3421__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_3422__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_3423__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_3562__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_3563__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_3564__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_3565__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_3566__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_3567__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_3568__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_3569__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_3570__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_3724__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_3725__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_3726__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_3727__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_3728__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_3729__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_3774__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_3775__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_3863__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_3864__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_3865__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_3866__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_3867__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_3868__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_3939__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_3952__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_4248__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_4249__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_4250__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_4251__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_4252__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_4253__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_4254__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_4255__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_4256__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_4257__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_4258__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_4259__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_4260__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_4261__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_4262__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_4263__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_4264__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_4265__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_4266__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_4267__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_4268__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_4269__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_4270__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_4271__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_4272__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_4293__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_4367__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_4368__DATA);

// Static initialiser table (.ctor)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", D_0037B01C__DATA);

// Virtual tables (.vtables)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", __vt__12CRemovalMenu__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", __vt__12CMenuGeorama__DATA);

// Small initialised data (.sdata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", DownLoadMesScrlGyouNum__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", analyze_percent__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", GeoramaReqMakeFlag__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", fname_1013__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", viewmode_to_mode_convtable_1310__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", maintopicbtn_1568__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_1828__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", msgtbl_2587__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", DestroyNum_3583__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", DestroyPartsName_3587__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_4151__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", at_4152__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmenu", fname_4292__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(HouseDrawInfo, 0x4);
INCLUDE_BSS(HouseInfoFormGrobal, 0x4);
INCLUDE_BSS(HousePartsID, 0x4);
INCLUDE_BSS(HouseInfoSelectLine, 0x4);
INCLUDE_BSS(HouseInfoSelectSelect, 0x4);
INCLUDE_BSS(HouseInfoSelectMoveInit, 0x4);
INCLUDE_BSS(HouseInfoSelectY, 0x4);
INCLUDE_BSS(HouseInfoCursorAlphaOnOff, 0x4);
INCLUDE_BSS(HouseInfoCursorAlpha, 0x4);
INCLUDE_BSS(HouseInfoCursorY, 0x4);
INCLUDE_BSS(PartsMakeOkTableNum, 0x4);
INCLUDE_BSS(DownLoadInfo, 0x4);
INCLUDE_BSS(DownLoadInfoNext, 0x4);
INCLUDE_BSS(DownLoadInfoEndFlag, 0x4);
INCLUDE_BSS(DownLoadInfoDrawFlag, 0x8);
INCLUDE_BSS(DownLoadWinRect, 0x8);
INCLUDE_BSS(DownLoadDispNum, 0x4);
INCLUDE_BSS(DownLoadProgress, 0x4);
INCLUDE_BSS(DownLoadMesMakeProgress, 0x4);
INCLUDE_BSS(DownLoadMesAlpha, 0x4);
INCLUDE_BSS(DownLoadMesMakeNo, 0x4);
INCLUDE_BSS(DownLoadActiveMes, 0x4);
INCLUDE_BSS(DownLoadMesUpY, 0x4);
INCLUDE_BSS(old_menuparts_pos_flag, 0x4);
INCLUDE_BSS(NowPolyGonFormMoveFlag, 0x4);
INCLUDE_BSS(MenuMapPart, 0x4);
INCLUDE_BSS(MenuGeoramaSystemData, 0x4);
INCLUDE_BSS(MenuGeoramaCursorForceSetFlag, 0x4);
INCLUDE_BSS(MenuGeoStoneDonwLoadFlag, 0x4);
INCLUDE_BSS(MenuGeoStoneDownLoad_PartsNum, 0x4);
INCLUDE_BSS(MenuGeoStoneDownLoad_Request, 0x4);
INCLUDE_BSS(MenuGeoStoneDownLoadTime, 0x4);
INCLUDE_BSS(MenuGeoStoneDmyCnt, 0x4);
INCLUDE_BSS(MenuGeoStoneDmyCnt_Now, 0x4);
INCLUDE_BSS(GeoRequestFlag, 0x4);
INCLUDE_BSS(MenuPartsDrawStack, 0x4);
INCLUDE_BSS(MenuMainMapInfo, 0x4);
INCLUDE_BSS(CMenuGeoPt, 0x4);
INCLUDE_BSS(MenuGeoramaViewNowPicNo, 0x4);
INCLUDE_BSS(MenuGeoramaViewWallPic, 0x4);
INCLUDE_BSS(MenuEditAnalyzeSrc, 0x4);
INCLUDE_BSS(MenuEditAnalyzeDataSrcNum, 0x4);
INCLUDE_BSS(MenuEditAnalyzeDataSrcListH, 0x4);
INCLUDE_BSS(MenuEditAnalyzeDataSrcListH_Move, 0x4);
INCLUDE_BSS(MenuEditAnalyzeDataSrcListLimmitNum, 0x4);
INCLUDE_BSS(MenuAnalyzeData, 0x4);
INCLUDE_BSS(GeoRequestBoardCheckPoint_P, 0x8);
INCLUDE_BSS(Tex_Georama, 0x4);
INCLUDE_BSS(GeoramaParts_DrawWaitCnt, 0x4);
INCLUDE_BSS(GeoramaMesPosForceSetFlag, 0x8);
INCLUDE_BSS(GeoramaMesMakeManner, 0x8);
INCLUDE_BSS(GeoramaReqMakeLine, 0x4);
INCLUDE_BSS(GeoramaReqMakeManner, 0x4);
INCLUDE_BSS(GeoramaMesForceMakeFlag, 0x4);
INCLUDE_BSS(GeoramaMesForceMakeFlag_PaintVer, 0x4);
INCLUDE_BSS(GeoAnalyzeCheckPointScrlBarY, 0x4);
INCLUDE_BSS(GeoAlpha_1199, 0x4);
INCLUDE_BSS(init_1200, 0x8);
INCLUDE_BSS(menu_georama_title_pos, 0x8);
INCLUDE_BSS(at_1556, 0x8);
INCLUDE_BSS(at_1829__2, 0x8);
INCLUDE_BSS(cnt_2177, 0x4);
INCLUDE_BSS(init_2178, 0x4);
INCLUDE_BSS(Dmy_2314, 0x4);
INCLUDE_BSS(init_2315, 0x4);
INCLUDE_BSS(at_2434, 0x8);
INCLUDE_BSS(dmychar_3207, 0x4);
INCLUDE_BSS(init_3208, 0x4);
INCLUDE_BSS(at_3260, 0x4);
INCLUDE_BSS(at_3268, 0x4);
INCLUDE_BSS(edparts_info_3580, 0x4);
INCLUDE_BSS(init_3581, 0x4);
INCLUDE_BSS(DestroyMaxNum_3584, 0x4);
INCLUDE_BSS(init_3585, 0x4);
INCLUDE_BSS(at_4043, 0x8);
INCLUDE_BSS(at_4085, 0x8);
INCLUDE_BSS(at_4124, 0x8);
INCLUDE_BSS(at_4137, 0x8);
INCLUDE_BSS(at_4150, 0x8);
INCLUDE_BSS(RemovalMenuPtr, 0x4);

// Uninitialised data (.bss)
INCLUDE_BSS(HouseChildPartInfo, 0x60);
INCLUDE_BSS(PartsMakeOkTable, 0x400);
INCLUDE_BSS(DownLoadMes, 0x20);
INCLUDE_BSS(GeoramaPenkiNum, 0x20);
INCLUDE_BSS(MenuGeoramaStack, 0x30);
INCLUDE_BSS(MenuEditAnalyzeDataSrcListHTable, 0x40);
INCLUDE_BSS(MenuEditAnalyzeDataSrc, 0x80);
INCLUDE_BSS(GeoBoardListTitleTexRect, 0x50);
INCLUDE_BSS(GeoBoardListTitlePutOffset, 0x30);
INCLUDE_BSS(GeoRequestBoardCheckPoint, 0x10);
INCLUDE_BSS(GeoramaMes, 0x18);
INCLUDE_BSS(GeoramaMesMakeLine, 0x18);
INCLUDE_BSS(GeoramaReqMsgFont, 0xC0);
INCLUDE_BSS(GeoramaReqMsgFontGyouNum, 0x30);
INCLUDE_BSS(GeoramaReqMsgTexH, 0x60);
INCLUDE_BSS(GeoramaReqMsgFontDrawFlag, 0x30);
INCLUDE_BSS(potti0, 0x10);
INCLUDE_BSS(potti1, 0x10);
INCLUDE_BSS(at_1826__2, 0x10);
INCLUDE_BSS(at_1827__2, 0x10);
INCLUDE_BSS(at_2443, 0x40);
INCLUDE_BSS(at_2444, 0x40);
INCLUDE_BSS(at_3303, 0x30);
INCLUDE_BSS(at_3304, 0x10);
