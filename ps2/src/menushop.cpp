#include "sound.hpp"
#include "dataread.hpp"
#include "prespr.hpp"
#include "mg_drawprim.hpp"
#include <cstdio>
#include <cstring>
#include "menusystemdata.hpp"
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
#include "menushop.hpp"

CInventUserData *GetInventUserDataPtr();

extern "C" int CheckRobotCore__16CUserDataManagerFv(CUserDataManager *);
extern "C" int fptosi(float value);
extern "C" int AddYarikomiMedal__16CUserDataManagerFi(CUserDataManager *, int);
extern "C" void *__ct__18CScriptInterpreterFv(void *);
extern "C" void SetTag__18CScriptInterpreterFP13SPI_TAG_PARAM(void *, SPI_TAG_PARAM *);
extern "C" void SetScript__18CScriptInterpreterFPci(void *, char *, int);
extern "C" void Run__18CScriptInterpreterFv(void *);
extern "C" void GetPutPosXY__16CMenuPosDataFormFPcRfRf(CMenuPosDataForm *, char *, float &, float &);
extern "C" void KeyStep__9CShopMenuFv(void *);
extern "C" void FormDraw__14CPosDataManageFv(void *);
extern "C" void KeyStep__14CMenuQuestViewFv(void *);

extern "C" CMenuSystemData *GetMenuSysData__Fv();
extern "C" int CheckGetAlready__15CMenuSystemDataFi(CMenuSystemData *, int);
extern "C" void *GetSaveData__Fv();
extern "C" int GetQuestRequestStatus__Fi(int);
extern short NowSellMode;
extern "C" int GetItemDataType__Fi(int);
extern "C" int CheckVoiceUnit__16CUserDataManagerFv(CUserDataManager *);
extern SHOP_PRICE_INFO *Spi_PriceList;
extern char at_1221__3[];
extern char at_1222__3[];
extern char at_1223__3[];
extern char at_1224__3[];
extern char at_1225__3[];
extern char at_1226__3[];
extern char at_1227__2[];
extern char at_1228__2[];
extern DONY_SHOP_ITEM dony_shoplist[];
extern short Now_Shop_ID;
extern int *Now_ShopDataReadPtr;
extern short Now_ShopListNum;
extern SPI_TAG_PARAM menu_shop_tag[];
extern "C" void *CShopMenuPt;
extern "C" void *MenuQuestView;

// Code (.text)
int GetDonyShopLineUp(int *itemList, int *status) {
    CInventUserData *inventData = GetInventUserDataPtr();
    CMenuSystemData *systemData = GetMenuSysData__Fv();
    if (systemData == NULL || inventData == NULL) {
        return 0;
}
    int level = inventData->GetLevel();
    int alreadyOwned = 0;
    int listed = 0;
    int available = 0;
    DONY_SHOP_ITEM *entry = dony_shoplist;
    int offset = 0;
    for (; 0 < entry->item_no; entry++) {
        listed++;
        if (CheckGetAlready__15CMenuSystemDataFi(systemData, entry->item_no) != 0) {
            alreadyOwned++;
        } else if (entry->level < level) {
            if (itemList != NULL) {
                *(int *)((u8 *)itemList + offset) = entry->item_no;
            }
            offset += 4;
            available++;
        }
    }
    if (status != NULL) {
        if (listed == alreadyOwned) {
            *status = 0;
        } else {
            if (available <= 0) {
                *status = 1;
            } else if (available == alreadyOwned) {
                *status = 2;
            }
        }
    }
    return available;
}
void CShop::CheckSyojiHin() {
    CUserDataManager *userData = GetUserDataMan();
    for (int i = 0; i < item_num; i++) {
        have_num[i] = 0;
        if (item_no[i] > 0) {
            have_num[i] = userData->GetNumSameItem(item_no[i]);
        }
    }
}
int CheckRobotCore(void) {
    return CheckRobotCore__16CUserDataManagerFv(GetUserDataMan());
}
void CShop::CheckEventItem() {
    CUserDataManager *userData = (CUserDataManager *)((u8 *)GetSaveData__Fv() + 0x1D2A0);
    if (NowSellMode == 3) {
        item_num = GetDonyShopLineUp(item_no, NULL);
        return;
    }
    int cursor = 0;
    while (cursor < item_num) {
        if (item_no[cursor] == 0x173 && CheckBitFlagMenu(0x1B) != 0) {
            local_sort1(cursor, &item_num, item_no);
        }
        if (item_no[cursor] == 0xAC && userData->GetNumSameItem(0xAC) > 0) {
            local_sort1(cursor, &item_num, item_no);
        }
        if (item_no[cursor] == 0x1A6 && CheckVoiceUnit__16CUserDataManagerFv(userData) != 0) {
            local_sort1(cursor, &item_num, item_no);
            cursor -= 1;
        }
        if (item_no[cursor] == 0x1A7 && (once_item_chosen == 1 || userData->unk_44dc0 >= 0x15)) {
            local_sort1(cursor, &item_num, item_no);
        }
        if (item_no[cursor] == 0x163 && userData->GetNumSameItem(0x163) > 0) {
            local_sort1(cursor, &item_num, item_no);
        }
        if (item_no[cursor] == 0x12F && userData->GetNumSameItem(0x12F) > 0) {
            local_sort1(cursor, &item_num, item_no);
        }
        if (item_no[cursor] == 0x166 && userData->GetNumSameItem(0x166) > 0) {
            local_sort1(cursor, &item_num, item_no);
        }
        if (GetItemDataType__Fi(item_no[cursor]) == 0xB) {
            int core = CheckRobotCore();
            if (core >= 0xF6 && core < 0xFC) {
                item_no[cursor] = core + 1;
            } else {
                local_sort1(cursor, &item_num, item_no);
                cursor -= 1;
            }
        }
        if (item_no[cursor] == 0x1A8 &&
            *(u8 *)&userData->GetMonsterBajjiDataPtr(4)->enable != 0) {
            local_sort1(cursor, &item_num, item_no);
        }
        if (GetQuestRequestStatus__Fi(2) == 2 &&
            (item_no[cursor] == 0xC9 || item_no[cursor] == 0xCA)) {
            local_sort1(cursor, &item_num, item_no);
            cursor -= 1;
        }
        cursor += 1;
    }
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menushop", GetPrice__5CShopFP13CGameDataUsedPiPi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menushop", CheckMoney__5CShopFv);
int CShop::AddMoney(int amount) {
    if (NowSellMode == 0) {
        return GetUserDataMan()->AddMoney(amount);
    }
    if (NowSellMode == 1) {
        return fptosi(GetUserDataMan()->AddRoboAbs((float)amount));
    }
    if (NowSellMode == 2) {
        return AddYarikomiMedal__16CUserDataManagerFi(GetUserDataMan(), amount);
    }
    if (NowSellMode == 3) {
        return 0;
    }
    return 0;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menushop", _SHOP_ANALYZE__FP9SPI_STACKi);
int _PRICE(SPI_STACK *stack, int argc) {
    int itemId = spiGetStackInt(stack++);
    Spi_PriceList[itemId].buy = spiGetStackInt(stack++);
    Spi_PriceList[itemId].sell = spiGetStackInt(stack++);
    return 1;
}
void CShop::AnalyzeShopList(char *script, int length) {
    char interpreter[0xED0];
    Now_Shop_ID = shop_id;
    Now_ShopDataReadPtr = item_no;
    Spi_PriceList = price;
    NowSellMode = 0;
    __ct__18CScriptInterpreterFv(interpreter);
    SetTag__18CScriptInterpreterFP13SPI_TAG_PARAM(interpreter, menu_shop_tag);
    SetScript__18CScriptInterpreterFPci(interpreter, script, length);
    Run__18CScriptInterpreterFv(interpreter);
    item_num = Now_ShopListNum;
    CheckEventItem();
    CheckSyojiHin();
}
void CShopMenu::AttachForm() {
    money_brd = (CMenuPosDataForm *)MenuPosData->GetFormInfo(at_1221__3);
    trade_brd = (CMenuPosDataForm *)MenuPosData->GetFormInfo(at_1222__3);
    shop_name_brd = (CMenuPosDataForm *)MenuPosData->GetFormInfo(at_1223__3);
    item_brd = (CMenuPosDataForm *)MenuPosData->GetFormInfo(at_1224__3);
    item_list = (CMenuPosDataForm *)MenuPosData->GetFormInfo(at_1225__3);
    exp_brd = (CMenuPosDataForm *)MenuPosData->GetFormInfo(at_1226__3);
    medal_brd = (CMenuPosDataForm *)MenuPosData->GetFormInfo(at_1227__2);
    if (item_list != NULL) {
        item_list->GetPutPosXY(NULL, list_x, list_y);
        list_y += 48.0f;
    }
    GiftBoxViewForm = (CMenuPosDataForm *)MenuPosData->GetFormInfo(at_1228__2);
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menushop", IsCancelNoneLoadItem__9CShopMenuFv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menushop", UpdataScrlBar__9CShopMenuFv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menushop", InitEnd__9CShopMenuFv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menushop", KeyStep__9CShopMenuFv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menushop", CalcTex__9CShopMenuFv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menushop", CalcCursorPosition__9CShopMenuFv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menushop", SearchNowPosItemExist__9CShopMenuFv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menushop", ShopSellListDraw__FRiPf);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menushop", MenuShopInit__FP9mgCMemoryPii);
int MenuShopKey() {
    return ((CShopMenu *)CShopMenuPt)->KeyStep();
}
void MenuShopDraw() {
    MenuPosData->FormDraw();
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menushop", UnderMsg__14CMenuQuestViewFi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menushop", SelectMax__14CMenuQuestViewFv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menushop", InitEnd__14CMenuQuestViewFv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menushop", KeyStep__14CMenuQuestViewFv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menushop", MenuNPCQuestViewInit__FP9mgCMemoryPii);
int MenuNPCQuestViewKey() {
    return ((CMenuQuestView *)MenuQuestView)->KeyStep();
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menushop", MenuNPCQuestViewDraw__Fv);

// Static initialiser (.init)
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menushop", __sinit_menushop_cpp);

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", dony_shoplist__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", menu_shop_tag__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", imglist_1267__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", extbl_1278__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", exe_tbl_1509__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", extbl_1573__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", extbl_1589__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", randam_checktbl__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", tbl_2469__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_2470__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1206__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1207__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1221__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1222__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1223__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1224__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1225__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1226__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1227__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1228__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1252__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1253__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1254__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1268__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1269__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1270__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1279__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1280__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1281__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1282__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1298__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1299__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1300__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1301__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1302__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1303__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1304__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1305__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1306__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1307__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1308__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1510__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1511__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1512__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1513__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1574__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1575__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1576__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1590__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1591__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1592__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1650__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1651__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1652__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1653__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1654__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1655__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1656__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1657__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1658__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1659__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1660__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1661__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1662__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1663__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1664__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1665__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1666__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1667__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1817__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1818__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1819__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1820__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1821__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1822__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1823__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1824__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1825__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1826__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1839__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1840__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_1881__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_2114__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_2115__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_2116__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_2117__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_2118__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_2172__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_2173__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_2219__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_2220__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_2221__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_2222__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", at_2629__2__DATA);

// Static initialiser table (.ctor)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", D_0037B048__DATA);

// Virtual tables (.vtables)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", __vt__14CMenuQuestView__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", __vt__9CShopMenu__DATA);

// Small initialised data (.sdata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", t_offxy_1832__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", cursor_offsetxy_1836__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", cursortbl_1838__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", rgba_1897__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", QuestMoveRate__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menushop", packname_2171__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(NowSellMode, 0x4);
INCLUDE_BSS(CShopPtr, 0x4);
INCLUDE_BSS(Tex_Shop, 0x4);
INCLUDE_BSS(Tex_Mt0, 0x4);
INCLUDE_BSS(Now_ShopListNum, 0x4);
INCLUDE_BSS(Now_ShopDataReadPtr, 0x4);
INCLUDE_BSS(Now_Shop_ID, 0x4);
INCLUDE_BSS(Spi_PriceList, 0x4);
INCLUDE_BSS(shop_mode_prev_1326, 0x4);
INCLUDE_BSS(init_1327, 0x8);
INCLUDE_BSS(at_1581__2, 0x8);
INCLUDE_BSS(at_1582__3, 0x8);
INCLUDE_BSS(at_1595__3, 0x8);
INCLUDE_BSS(at_1685__2, 0x8);
INCLUDE_BSS(at_1831__2, 0x8);
INCLUDE_BSS(CShopMenuPt, 0x4);
INCLUDE_BSS(QuestMan, 0x4);
INCLUDE_BSS(QuestDataPtr, 0x4);
INCLUDE_BSS(Tex_QuestMemo, 0x4);
INCLUDE_BSS(QuestMenuMes, 0x4);
INCLUDE_BSS(ActiveQuestInfo, 0x4);
INCLUDE_BSS(QuestTilePatternXY, 0x8);
INCLUDE_BSS(QuestCursorPos, 0x8);
INCLUDE_BSS(QuestListTopY, 0x4);
INCLUDE_BSS(QuestCommentWinX, 0x4);
INCLUDE_BSS(QuestScrlBarY, 0x4);
INCLUDE_BSS(QuestScrlBarH, 0x4);
INCLUDE_BSS(QuestViewCommentFlag, 0x4);
INCLUDE_BSS(QuestReactionCommentGyouNum, 0x4);
INCLUDE_BSS(ScoopMan, 0x4);
INCLUDE_BSS(ScmFlagCtrl, 0x4);
INCLUDE_BSS(menu_debug_questselect, 0x4);
INCLUDE_BSS(Menu_Memo_ViewMode, 0x4);
INCLUDE_BSS(MenuQuestView, 0x4);

// Uninitialised data (.bss)
INCLUDE_BSS(MenuLocalStack, 0x30);
INCLUDE_BSS(QuestCommentMes, 0x10);
