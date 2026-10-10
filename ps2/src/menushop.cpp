#include "common.h"
#include "mw_runtime.h"

#include <cstdio>
#include <cstdlib>
#include <cstring>

#include "dataread.hpp"
#include "editmenu.hpp"
#include "font.hpp"
#include "gamedata.hpp"
#include "inventmn.hpp"
#include "mainloop.hpp"
#include "menuaqua.hpp"
#include "menucls1.hpp"
#include "menucommon.hpp"
#include "menudraw.hpp"
#include "menumain.hpp"
#include "menushop.hpp"
#include "menusys.hpp"
#include "menusystemdata.hpp"
#include "mg_drawprim.hpp"
#include "mg_math.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "prespr.hpp"
#include "quest.hpp"
#include "savedata.hpp"
#include "scenesnd.hpp"
#include "scriptinterpreter.hpp"
#include "sound.hpp"
#include "sysmes.hpp"
#include "userdata.hpp"

/**
 *
 * Storage for shop and quest memo resources.
 *
 */
static mgCMemory MenuLocalStack;

/**
 *
 * Currency used for the current shop.
 *
 */
static short NowSellMode;

/**
 *
 * Goods and prices for the current shop.
 *
 */
static CShop *CShopPtr;

/**
 *
 * Texture atlas for the shop boards and item marks.
 *
 */
static mgCTexture *Tex_Shop;

/**
 *
 * Item texture loaded with the shop resources.
 *
 */
static mgCTexture *Tex_Mt0;

/**
 *
 * Number of goods parsed from the selected shop row.
 *
 */
static short Now_ShopListNum;

/**
 *
 * Destination for item numbers parsed from the shop script.
 *
 */
static int *Now_ShopDataReadPtr;

/**
 *
 * Shop number selected while parsing the goods script.
 *
 */
static short Now_Shop_ID;

/**
 *
 * Destination for buying and selling prices parsed from the shop script.
 *
 */
static SHOP_PRICE_INFO *Spi_PriceList;

/**
 *
 * Active shop menu.
 *
 */
static CShopMenu *CShopMenuPt;

/**
 *
 * Request definitions displayed in the quest memo.
 *
 */
static CQuestManager *QuestMan;

/**
 *
 * Saved request acceptance and completion flags.
 *
 */
static CQuestData *QuestDataPtr;

/**
 *
 * Texture atlas for the quest and scoop memo.
 *
 */
static mgCTexture *Tex_QuestMemo;

/**
 *
 * Message shown beneath the quest memo.
 *
 */
static CDC2Mes *QuestMenuMes;

/**
 *
 * Request selected for the open memo comment.
 *
 */
static QUEST_INFO *ActiveQuestInfo;

/**
 *
 * Scrolling offset of the quest memo backing pattern.
 *
 */
static float QuestTilePatternXY;

/**
 *
 * Screen position of the quest memo selection cursor.
 *
 */
static float QuestCursorPos[2];

/**
 *
 * Screen position of the first quest memo list row.
 *
 */
static float QuestListTopY;

/**
 *
 * Horizontal position of the open memo comment.
 *
 */
static float QuestCommentWinX;

/**
 *
 * Vertical position of the quest memo scrollbar.
 *
 */
static float QuestScrlBarY;

/**
 *
 * Height of the quest memo scrollbar.
 *
 */
static float QuestScrlBarH;

/**
 *
 * Whether the quest memo comment window is open.
 *
 */
static u8 QuestViewCommentFlag;

/**
 *
 * Number of lines in the request reaction message.
 *
 */
static s16 QuestReactionCommentGyouNum;

/**
 *
 * Saved scoop discovery and photograph flags.
 *
 */
static CScoopDataManager *ScoopMan;

/**
 *
 * Scoop selected for the open memo comment.
 *
 */
static SCOOP_DATA *ScmFlagCtrl;

/**
 *
 * First request or scoop displayed by the debug overlay.
 *
 */
static int menu_debug_questselect;

/**
 *
 * Request or photo-scoop mode of the quest memo.
 *
 */
static s8 Menu_Memo_ViewMode;

/**
 *
 * Active quest memo viewer.
 *
 */
static CMenuQuestView *MenuQuestView;

/**
 *
 * Request title, description and reaction message windows.
 *
 */
static CDC2Mes *QuestCommentMes[3];

/**
 *
 * Donny's goods and their required recruitment levels.
 *
 */
static DONY_SHOP_ITEM dony_shoplist[8] = {
    {0xBD, 1},
    {0x73, 2},
    {0xCD, 3},
    {0x7A, 4},
    {0x105, 5},
    {0x1AC, 6},
    {0x1AB, 7},
    {-1, 1}
};

/**
 *
 * Parses goods for the selected shop.
 *
 */
static int _SHOP_ANALYZE(SPI_STACK *stack, int argc);

/**
 *
 * Parses an item's buying and selling prices.
 *
 */
static int _PRICE(SPI_STACK *stack, int argc);

/**
 *
 * Tags accepted by the shop goods and price script.
 *
 */
static SPI_TAG_PARAM menu_shop_tag[3] = {
    {"SHOP", _SHOP_ANALYZE},
    {"PRICE", _PRICE},
    {NULL, NULL}
};

// Code (.text)
int GetDonyShopLineUp(int *item_list, int *status) {
    CInventUserData *invent_data = GetInventUserDataPtr();
    CMenuSystemData *system_data = GetMenuSysData();

    if (system_data == NULL || invent_data == NULL) {
        return 0;
    }

    int             level = invent_data->GetLevel();
    int             already_owned = 0;
    int             listed = 0;
    int             available = 0;
    DONY_SHOP_ITEM *entry = dony_shoplist;

    for (; 0 < entry->item_no; entry++) {
        listed++;

        if (system_data->CheckGetAlready(entry->item_no) != 0) {
            already_owned++;
        } else if (entry->level < level) {
            if (item_list != NULL) {
                item_list[available] = entry->item_no;
            }

            available++;
        }
    }

    if (status != NULL) {
        if (listed == already_owned) {
            *status = 0;
        } else {
            if (available <= 0) {
                *status = 1;
            } else if (available == already_owned) {
                *status = 2;
            }
        }
    }

    return available;
}

void CShop::CheckSyojiHin() {
    CUserDataManager *user_data = GetUserDataMan();

    for (int i = 0; i < item_num; i++) {
        have_num[i] = 0;

        if (item_no[i] > 0) {
            have_num[i] = user_data->GetNumSameItem(item_no[i]);
        }
    }
}

int CheckRobotCore() {
    return GetUserDataMan()->CheckRobotCore();
}

void CShop::CheckEventItem() {
    CUserDataManager *user_data = &GetSaveData()->user_data;

    if (NowSellMode == 3) {
        item_num = GetDonyShopLineUp(item_no, NULL);
        return;
    }

    int cursor = 0;

    while (cursor < item_num) {
        if (item_no[cursor] == 0x173 && CheckBitFlagMenu(0x1B) != 0) {
            local_sort1(cursor, &item_num, item_no);
        }

        if (item_no[cursor] == 0xAC && user_data->GetNumSameItem(0xAC) > 0) {
            local_sort1(cursor, &item_num, item_no);
        }

        if (item_no[cursor] == 0x1A6 && user_data->CheckVoiceUnit() != 0) {
            local_sort1(cursor, &item_num, item_no);
            cursor -= 1;
        }

        if (item_no[cursor] == 0x1A7 && (once_item_chosen == 1 || user_data->special_item_bought >= 0x15)) {
            local_sort1(cursor, &item_num, item_no);
        }

        if (item_no[cursor] == 0x163 && user_data->GetNumSameItem(0x163) > 0) {
            local_sort1(cursor, &item_num, item_no);
        }

        if (item_no[cursor] == 0x12F && user_data->GetNumSameItem(0x12F) > 0) {
            local_sort1(cursor, &item_num, item_no);
        }

        if (item_no[cursor] == 0x166 && user_data->GetNumSameItem(0x166) > 0) {
            local_sort1(cursor, &item_num, item_no);
        }

        if (GetItemDataType(item_no[cursor]) == 0xB) {
            int core = CheckRobotCore();

            if (core >= 0xF6 && core < 0xFC) {
                item_no[cursor] = core + 1;
            } else {
                local_sort1(cursor, &item_num, item_no);
                cursor -= 1;
            }
        }

        if (item_no[cursor] == 0x1A8 &&
            *(&user_data->GetMonsterBajjiDataPtr(4)->enable) != 0) {
            local_sort1(cursor, &item_num, item_no);
        }

        if (GetQuestRequestStatus(2) == 2 &&
            (item_no[cursor] == 0xC9 || item_no[cursor] == 0xCA)) {
            local_sort1(cursor, &item_num, item_no);
            cursor -= 1;
        }

        cursor += 1;
    }
}
static inline void ReadPrice(CShop *shop, int item_no, int *buy, int *sell) {
    if (buy) {
        *buy = shop->price[item_no].buy;
    }
    if (sell) {
        *sell = shop->price[item_no].sell;
    }
}
void CShop::GetPrice(CGameDataUsed *item, int *buy, int *sell) {
    if (item == NULL) {
        return;
    }
    int item_id = item->item_no;
    if (buy != NULL) {
        *buy = 0;
    }
    if (sell != NULL) {
        *sell = 0;
    }
    if (item_id > 0) {
        ReadPrice(this, item_id, buy, sell);
        if (NowSellMode == SHOP_SELL_MODE_DONY && buy != NULL) {
            *buy = 0;
        }
    }
    if (buy != NULL && item_id == 0x1A7) {
        int bought = GetUserDataMan()->special_item_bought;
        float scaled = (float)*buy;
        while (bought > 0) {
            scaled *= 1.1f;
            bought--;
        }
        *buy = fptosi(scaled);
    }
    if (sell != NULL) {
        if (item->item_no == 0x130) {
            for (int slot = 0; slot < 3; slot++) {
                int box_item = item->GetGiftBoxItemNo(slot);
                int box_price = 0;
                if (box_item > 0) {
                    ReadPrice(this, box_item, NULL, &box_price);
                }
                *sell += box_price;
            }
        }
        switch (item->used_type) {
        case USED_ITEM_TYPE_WEAPON: {
            int level = item->GetLevel();
            if (0 < level) {
                *sell += level * 20;
                *sell += item->RemainFusion() * 5;
            }
            break;
        }
        case USED_ITEM_TYPE_BOILED:
            *sell += (s16)item->data.boiled.value;
            break;
        }
    }
}
int CShop::CheckMoney() {
    int money;

    if (NowSellMode == SHOP_SELL_MODE_MONEY) {
        money = GetUserDataMan()->money;
    } else if (NowSellMode == SHOP_SELL_MODE_ROBO_ABS) {
        money = fptosi(GetUserDataMan()->robo_data.abs.now);
    } else if (NowSellMode == SHOP_SELL_MODE_MEDAL) {
        money = GetUserDataMan()->GetYarikomiMedal();
    } else if (NowSellMode == SHOP_SELL_MODE_DONY) {
        money = GetUserDataMan()->money;
    } else {
        money = 0;
    }

    return money;
}

int CShop::AddMoney(int amount) {
    if (NowSellMode == 0) {
        return GetUserDataMan()->AddMoney(amount);
    }

    if (NowSellMode == 1) {
        return fptosi(GetUserDataMan()->AddRoboAbs((float) amount));
    }

    if (NowSellMode == 2) {
        return GetUserDataMan()->AddYarikomiMedal(amount);
    }

    if (NowSellMode == 3) {
        return 0;
    }

    return 0;
}

static int _SHOP_ANALYZE(SPI_STACK *stack, int argc) {
    int remaining;
    int index;
    int shop_id = spiGetStackInt(stack++);
    remaining = argc - 1;
    int selected = 0;

    if (shop_id == Now_Shop_ID) {
        Now_ShopListNum = remaining;
        selected = 1;
    }

    if (selected == 0) {
        return 0;
    }

    GetUserDataMan();

    if (Now_Shop_ID == 0x17 || Now_Shop_ID == 0x1C) {
        NowSellMode = SHOP_SELL_MODE_ROBO_ABS;

        for (index = 0; index < Now_ShopListNum; index++) {
            Now_ShopDataReadPtr[index] = spiGetStackInt(stack++);
        }
    } else if (Now_Shop_ID == 0x20) {
        NowSellMode = SHOP_SELL_MODE_MEDAL;

        for (index = 0; index < Now_ShopListNum; index++) {
            Now_ShopDataReadPtr[index] = spiGetStackInt(stack++);
        }
    } else if (Now_Shop_ID == 0x21) {
        NowSellMode = SHOP_SELL_MODE_DONY;

        for (index = 0; index < Now_ShopListNum; index++) {
            Now_ShopDataReadPtr[index] = spiGetStackInt(stack++);
        }
    } else {
        if (0 < remaining) {
            index = 0;

            do {
                Now_ShopDataReadPtr[index] = spiGetStackInt(stack++);
                index++;
            } while (index < remaining);
        }
    }

    return 1;
}

static int _PRICE(SPI_STACK *stack, int argc) {
    int item_id = spiGetStackInt(stack++);
    Spi_PriceList[item_id].buy = spiGetStackInt(stack++);
    Spi_PriceList[item_id].sell = spiGetStackInt(stack++);
    return 1;
}

void CShop::AnalyzeShopList(char *script, int length) {
    Now_Shop_ID = shop_id;
    Now_ShopDataReadPtr = item_no;
    Spi_PriceList = price;
    NowSellMode = 0;
    CScriptInterpreter interpreter;
    interpreter.SetTag(menu_shop_tag);
    interpreter.SetScript(script, length);
    interpreter.Run();
    item_num = Now_ShopListNum;
    CheckEventItem();
    CheckSyojiHin();
}

void CShopMenu::AttachForm() {
    money_brd = (CMenuPosDataForm *) MenuPosData->GetFormInfo("moneybrd");
    trade_brd = (CMenuPosDataForm *) MenuPosData->GetFormInfo("\x94\x84\x94\x83\x83\x7B\x81\x5B\x83\x68");
    shop_name_brd = (CMenuPosDataForm *) MenuPosData->GetFormInfo("\x93\x58\x96\xBC\x83\x7B\x81\x5B\x83\x68");
    item_brd = (CMenuPosDataForm *) MenuPosData->GetFormInfo("\x95\x69\x95\xA8\x83\x7B\x81\x5B\x83\x68");
    item_list = (CMenuPosDataForm *) MenuPosData->GetFormInfo("\x95\x69\x95\xA8\x83\x8A\x83\x58\x83\x67");
    exp_brd = (CMenuPosDataForm *) MenuPosData->GetFormInfo("EXPBRD");
    medal_brd = (CMenuPosDataForm *) MenuPosData->GetFormInfo("MEDALBRD");

    if (item_list != NULL) {
        item_list->GetPutPosXY(NULL, list_x, list_y);
        list_y += 48.0f;
    }

    GiftBoxViewForm = MenuPosData->GetFormInfo("giftview");
}

int CShopMenu::IsCancelNoneLoadItem() {
    MENU_SWAPITEM_INFO origin;
    origin.Set(-1, 0, -1, 0);
    memcpy(&origin, &MenuCommonInfo->have_swap, sizeof(origin));
    origin.flag = 0;
    CGameDataUsed *destination = GetGameDataUsedForSWAPINFO(&origin);
    CGameDataUsed  previous_item;
    CGameDataUsed  carried_item;
    previous_item.CopyGameData(destination);
    carried_item.CopyGameData(&MenuCommonInfo->have_item);
    int result = MenuCommonInfo->ReturnItemMenu(1);

    if (0 < result) {
        destination->CopyGameData(&previous_item);
        MenuCommonInfo->have_item.CopyGameData(&carried_item);
        int exchange[2][4];

        if (ExchangeItemInfoMake(&origin, exchange, 0, 0) != 0) {
            CommonSetMoveItemClass(exchange);
        }

        MenuSePlay(menu_item_swap_sndtbl[result]);
        return 0;
    }

    MenuSePlay(5);
    return 1;
}

void CShopMenu::UpdataScrlBar() {
    if (item_brd != NULL) {
        scrl_bar_top = item_brd->GetPartInfo("b0");
        scrl_bar_body = item_brd->GetPartInfo("b1");
        scrl_bar_bottom = item_brd->GetPartInfo("b2");
        float line_count = (float) CShopPtr->item_num;

        if (line_count < 6.0f) {
            line_count = 6.0f;
        }

        scrl_bar_step = 0.0f;
        float visible_ratio = 6.0f / line_count;
        float height = 270.0f * visible_ratio;
        float scroll_count = line_count - 6.0f;

        if (1.0f <= scroll_count) {
            scrl_bar_step = (270.0f - height) / scroll_count;
        }

        scrl_bar_body->h = height - scrl_bar_top->h - scrl_bar_bottom->h;
    }
}

void CShopMenu::InitEnd() {
    // Opening shop script selected by currency.
    static char *extbl[4] = {
        "\x92\xCA\x8F\xED",
        "\x83\x58\x83\x5E\x81\x5B\x83\x75\x83\x8B",
        "\x83\x6A\x81\x5B\x83\x68",
        "\x83\x68\x83\x6A\x81\x5B"
    };

    // Image packs loaded for shop items and their special icons.
    static char *imglist[4] = {
        "allitem.img",
        "spectre.img",
        "img.img",
        NULL
    };

    mgCTextureManager *textures = &mgTexManager;
    int                size;
    int                shop_name_no;
    int                texture_block = tex_block[1];

    if (pack != NULL) {
        u_int *shop_pack = pack;
        char   path[0x40];
        int    chapter = GetNowChapter(GetSaveData());

        if (chapter <= 0 || chapter > 8) {
            chapter = 1;
        }

        sprintf(path, "menu/shoplst%d.cfg", chapter);

        if (LanguageCode > 0) {
            sprintf(path, "menu/shopusa%d.cfg", chapter);
        }

        MenuLocalStack.Align64();
        u_long128 *script_buffer = MenuLocalStack.stGetTop();

        if (LoadFile2(path, script_buffer, &size, 0) != 0) {
            CShopPtr->AnalyzeShopList((char *) script_buffer, size);
        }

        for (int image = 0; image < 3; image++) {
            textures->EnterIMGFile((u_char *) GetPackFile(shop_pack, imglist[image], &size), texture_block, NULL, NULL);
        }

        Tex_Shop = textures->GetTexture("shop", -1);
        Tex_Mt0 = textures->GetTexture("mt0", -1);
        MenuDataAnalyze((char *) GetPackFile(shop_pack, "shop.cfg", &size), size, &MenuLocalStack);
        script = (char *) GetPackFile(shop_pack, "shop_com.cfg", &script_size);
        MenuCommandAnalyzeInfo.system_mes_buff[2] = (short *) GetPackFile(shop_pack, "shopname.mes", &size);
    }

    mgCMemory sound_memory;
    MenuLocalStack.Align64();
    sound_memory.stSetBuffer(MenuLocalStack.stGetTop(), 0x300);
    MenuLocalStack.Alloc(0x300);
    u_int *sound_buffer = (u_int *) MenuLocalStack.stGetTop();

    if (LoadFile2("snd2/sp/SP_042.snd", sound_buffer, NULL, 0) != 0) {
        sndInitPort(8);
        se_handle = sndLoadSound(8, sound_buffer, &sound_memory);
    }

    MenuPosData->AttachCommonTexInfo();
    MenuItemIconTextureBlock = texture_block;
    MenuPosData->MallocPallet(&MenuLocalStack);
    MenuPosData->SearchTransPalletNo();
    AttachMessageForm();
    AttachForm();
    MenuMoveItemPtr->AttachForm();
    int bag_max = GetNowBagMax(0);
    MenuItemBrdSetInfo(bag_pos, bag_top, bag_max / 6, 5);
    MenuItemBrdCalcManner = 0;
    UpdataScrlBar();
    MenuLocalStack.Align64();
    MenuMainScene->LoadBGM(0x32, MenuLocalStack.stGetTop());
    MenuMainScene->PlayBGM(0, -1, 1.0f);
    cursor_reset = 1;
    MenuPosData->FormReLink("msg0", "dmy_msg0");
    MenuCommonInfo->InitHaveData();
    MenuCommonInfo->SetHaveItemInfo(0, 0);
    ExeScript("INIT");
    ExeScript(extbl[NowSellMode]);
    CDC2Mes *message = MenuDCMsg[1];
    shop_name_no = CShopPtr->shop_id;
    message->SetMsgItemNo(&shop_name_no, 1);
    shop_name_ofs_x = message->GetMesWidth_system(shop_name_no) >> 1;
    shop_name_ofs_y = 2;
}

int CShopMenu::KeyStep() {
    // Purchase setup script selected by currency.
    static char *exe_tbl[4] = {
        "\x82\xA9\x82\xA4\x90\xDD\x92\xE8",
        "\x82\xA9\x82\xA4\x90\xDD\x92\xE8\x52\x4F\x42\x4F",
        "\x82\xA9\x82\xA4\x90\xDD\x92\xE8\x83\x81\x83\x5F\x83\x8B",
        "\x82\xE0\x82\xE7\x82\xA4\x90\xDD\x92\xE8"
    };

    int ret = 0;
    MenuCommonInfo->CheckSelectKey();
    int lr;
    int push;
    push = MenuCommonInfo->CheckPushButton();
    lr = MenuCommonInfo->CheckLRKey();
    CUserDataManager *user = GetUserDataMan();
    int fade_end = FadeCheckMenu();
    switch (mode) {
    case 1:
        if (fade_end) {
            ExeScript("INIT_END");
            mode = 0;
        }
        break;
    case 2:
        if (fade_end) {
            MenuMainScene->StopBGM(0);
            MenuMainScene->LoadBGM(bgm_status.load_no, MenuLocalStack.stGetTop());
            MenuMainScene->SetActiveBgmStatus(&bgm_status);
            ret = 1;
        }
        break;
    case 0: {
        if (MenuMoveItemPtr->CheckMove()) {
            push = 0;
        }
        if (menu_debug_flag != 0) {
            if (GamePad__2.On(PAD_CIRCLE)) {
                GetUserDataMan()->AddYarikomiMedal(1);
            }
            return 0;
        }
        // Shop list mode restored after a quantity selection or error message.
        static s16 shop_mode_prev = 0;
        int command = 0;
        MENU_SWAPITEM_INFO swap;
        swap.Set(-1, 0, -1, 0);
        int item_num = CShopPtr->item_num;
        int buy_price = 0;
        int sell_price;
        switch (key_arg_no) {
        case 0: {
            int old_pos = list_pos;
            int old_top = list_top;
            int moved = MenuListKeyCheck(lr, &list_pos, &list_top, item_num, 6, 0, 0);
            if (lr & 0x50) {
                list_pos -= 5;
            }
            if (lr & 0xA0) {
                list_pos += 5;
            }
            if (list_pos < 0) {
                list_pos = 0;
            }
            if (item_num <= list_pos) {
                list_pos = item_num - 1;
            }
            while (list_pos < list_top) {
                list_top--;
            }
            while (list_top + 6 < list_pos) {
                list_top++;
            }
            if (old_pos != list_pos || old_top != list_top) {
                moved = 1;
            }
            if (lr & 8) {
                key_arg_no = 1;
                int line = list_pos - list_top + 1;
                if (line > 4) {
                    line = 4;
                }
                bag_pos = (bag_top + line) * 6;
                MenuSePlay(SYSTEM_SE_CURSOR);
            } else {
                if (moved) {
                    MenuSePlay(SYSTEM_SE_CURSOR);
                }
                switch (push) {
                case 1:
                case 4:
                    command = 0x3E8;
                    shop_mode_prev = key_arg_no;
                    break;
                case 2:
                    command = 0x32;
                    break;
                }
            }
            break;
        }
        case 1:
            if (MenuItemBrdKey(lr, &bag_pos, &bag_top, 0) == 1 && MenuCommonInfo->have_item.item_no <= 0) {
                if (item_num > 0) {
                    key_arg_no = 0;
                    int line = bag_pos / 6 - bag_top - 1;
                    if (line < 0) {
                        line = 0;
                    }
                    list_pos = list_top + line;
                    MenuSePlay(SYSTEM_SE_CURSOR);
                }
            } else {
                swap.Set(3, bag_pos, -1, 0);
                switch (push) {
                case 1:
                    command = 0x14;
                    if (MenuCommonInfo->have_item.item_no > 0) {
                        command = 0x14;
                        break;
                    }
                    command = 5;
                    if (NowSellMode == SHOP_SELL_MODE_ROBO_ABS || NowSellMode == SHOP_SELL_MODE_MEDAL) {
                        command = 5;
                        break;
                    }
                    command = 0x3F2;
                    shop_mode_prev = key_arg_no;
                    break;
                case 4:
                    command = 0x14;
                    break;
                case 8:
                    command = 0x1E;
                    break;
                case 2:
                    command = 0x32;
                    break;
                }
            }
            break;
        case 2:
        case 3: {
            int old_cursor = num_cursor;
            int old_num = num;
            if (lr & 4) {
                num_cursor = old_cursor - 1;
            }
            if (lr & 8) {
                num_cursor++;
            }
            if (num_cursor < 0) {
                num_cursor = 0;
            }
            if (num_cursor > 1) {
                num_cursor = 1;
            }
            int arrow = -1;
            if (num_cursor == 0) {
                if (lr & 1) {
                    num++;
                }
                if (lr & 2) {
                    num--;
                }
                if (lr & 0x50) {
                    num -= 10;
                }
                if (lr & 0xA0) {
                    if (num == 1) {
                        num += 9;
                    } else {
                        num += 10;
                    }
                }
            }
            if (old_num < num) {
                arrow = 0;
            }
            if (num < old_num) {
                arrow = 1;
            }
            if (num <= 0) {
                num = 1;
            }
            if (num > num_max) {
                num = num_max;
            }
            if (old_cursor != num_cursor || old_num != num) {
                MenuSePlay(SYSTEM_SE_CURSOR);
                if (0 <= arrow) {
                    arrow_flash[arrow] = 8;
                    arrow_flash[arrow ^ 1] = 0;
                }
            }
            total = 0;
            if (NowSellMode == SHOP_SELL_MODE_DONY && key_arg_no == 2) {
                MenuDCMsg[3]->SetMsgCursor(num_cursor);
            }
            if (key_arg_no == 2) {
                CShopPtr->GetPrice(SearchNowPosItemExist(), &buy_price, NULL);
                total = buy_price * num;
            }
            if (key_arg_no == 3) {
                CShopPtr->GetPrice(SearchNowPosItemExist(), NULL, &sell_price);
                total = sell_price * num;
            }
            trade_brd->SetNumber("\x8D\x87\x8C\x76", total);
            trade_brd->SetPartRGBA("\x8D\x87\x8C\x76", 0x80, 0x80, 0x80, 0x80);
            trade_brd->SetPartRGBA("\x83\x4D\x83\x8B\x83\x5F\x82\x51", 0x80, 0x80, 0x80, 0x80);
            if (key_arg_no == 2 && total > CShopPtr->CheckMoney()) {
                trade_brd->SetPartRGBA("\x8D\x87\x8C\x76", 0x80, 0x14, 0x14, 0x80);
                trade_brd->SetPartRGBA("\x83\x4D\x83\x8B\x83\x5F\x82\x51", 0x80, 0x14, 0x14, 0x80);
            }
            switch (push) {
            case 1:
            case 4:
                if (num_cursor == 0) {
                    if (key_arg_no == 2) {
                        command = 0x3E9;
                        if (NowSellMode == SHOP_SELL_MODE_DONY) {
                            command = 0x3ED;
                        }
                    }
                    if (key_arg_no == 3) {
                        command = 0x3F3;
                    }
                    break;
                }
            case 2:
                command = 0x44C;
                break;
            }
            break;
        }
        case 4:
        case 5: {
            int answer = MenuDCMsg[4]->YesNoCursor2(0);
            if (answer == 1) {
                if (key_arg_no == 4) {
                    command = 0x3ED;
                }
                if (key_arg_no == 5) {
                    command = 0x3F7;
                }
            }
            if (answer == 2) {
                ExeScript("\x82\xE2\x82\xC1\x82\xCF\x82\xE2\x82\xDF");
                if (key_arg_no == 4) {
                    key_arg_no = 2;
                }
                if (key_arg_no == 5) {
                    key_arg_no = 3;
                }
            }
            break;
        }
        case 6:
        case 7:
            if (push != 0) {
                command = 0x44C;
                cursor_reset = 1;
            }
            break;
        }
        CGameDataUsed *item = SearchNowPosItemExist();
        char *item_name = NULL;
        int item_no = -1;
        if (item != NULL) {
            item_no = item->item_no;
            item_name = item->GetName(1);
        }
        if (trade_brd != NULL) {
            MENUFORMPARTS_TYPE *icon = trade_brd->GetPartInfo("item");
            if (item != NULL && item_no != 0x1A6 && item_no != 0x1A8) {
                if (item_no == 0x1AA) {
                    MenuFormPartsPresetItem(icon, 1, item_no, item->data.item.num);
                } else {
                    MenuFormPartsPresetItem(icon, 1, item_no, item->GetSpectolNo());
                }
            }
        }
        CDC2Mes *count_mes = MenuDCMsg[3];
        CDC2Mes *ask_mes = MenuDCMsg[4];
        int refuse = -1;
        switch (command) {
        case 5:
            MenuSePlay(5);
            break;
        case 0x14:
            switch (MenuCommonInfo->EnableSwapNowPos(&swap)) {
            case 0:
                MenuSePlay(menu_item_swap_sndtbl[MenuCommonInfo->MenuSwapItem(item, &swap, 1, 1)]);
                break;
            case 4:
                SetAskHowMuchItemNum(&swap, item);
                MenuSePlay(SYSTEM_SE_DECIDE);
                break;
            default:
                MenuSePlay(5);
                break;
            }
            break;
        case 0x1E:
            MenuCommonInfo->GetItemAll(item, &swap);
            break;
        case 0x32:
            if (IsCancelNoneLoadItem()) {
                FadeOutMenu(0x1E, 0.0f);
                mode = 2;
            }
            break;
        case 0x3E8: {
            num_max = 1;
            CDataCommon *common = GameItemDataManage.GetCommonData(item_no);
            if (common == NULL) {
                break;
            }
            int room = 0;
            CGameDataUsed *bag = user->GetUsedDataPtr(0);
            for (int slot = 0; slot < GetNowBagMax(0); bag++, slot++) {
                if (bag->item_no <= 0) {
                    room += common->stack_num;
                }
                if (bag->item_no == item_no && bag->CheckTypeEnableStack()) {
                    room += bag->CheckStackRemain();
                }
            }
            if (item_no == 0x1A6 || item_no == 0x1A8 || item_no == 0x1AB || item_no == 0x1AC ||
                GetItemDataType(item_no) == ITEM_DATA_ROBO_CORE) {
                room = 1;
            }
            if (room <= 0) {
                refuse = 2;
                break;
            }
            int can_have = common->max_num - user->GetNumSameItem(item_no);
            if (can_have <= 0) {
                refuse = 3;
                break;
            }
            if (room < can_have) {
                can_have = room;
            }
            num_cursor = 0;
            num_max = can_have;
            if (item_no == 0x1A7) {
                num_max = 1;
                CShopPtr->once_item_chosen = 1;
            }
            if (NowSellMode == SHOP_SELL_MODE_DONY) {
                num_max = 1;
            }
            SetMenuKeyCtrlEnv(2);
            key_arg_no = 2;
            arrow_flash[1] = 0;
            arrow_flash[0] = 0;
            CShopPtr->GetPrice(SearchNowPosItemExist(), &buy_price, NULL);
            trade_brd->SetNumber("\x92\x50\x95\x69", buy_price);
            num = 1;
            ExeScript(exe_tbl[NowSellMode]);
            count_mes->SetMsgItemNo(&item_name, 1);
            if (item_no == 0x1A6) {
                ExeScript("VOICEON");
            } else if (item_no == 0x1A8) {
                ExeScript("\x83\x71\x83\x7D\x81\x5B\x83\x89\x4F\x4E");
            } else {
                ExeScript("VOICEOFF");
            }
            break;
        }
        case 0x3ED: {
            key_arg_no = 0;
            if (GetItemDataType(item_no) == ITEM_DATA_ROBO_CORE) {
                user->DeleteItem(item_no - 1, 1);
            }
            int no_get = 0;
            if (item_no == 0x1A8 || item_no == 0x1AC || item_no == 0x1AB) {
                no_get = 1;
            }
            if (item_no == 0x1A6) {
                no_get = 1;
            }
            if (no_get == 0) {
                user->GetItem(item_no, num);
            }
            CShopPtr->AddMoney(-total);
            ExeScript("\x94\x84\x94\x83\x90\xAC\x97\xA7");
            if (item_no == 0x1A7) {
                user->special_item_bought++;
            }
            CSaveData *save = GetSaveData();
            save->SetBitFlag(0xC, 1);
            if (item_no == 0x173) {
                save->SetBitFlag(0x1B, 1);
            }
            if (item_no == 0x1A8) {
                GetUserDataMan()->monster_box.EnableChange(4);
                CMap *map = MenuMainScene->GetMap(MenuMainScene->active_map);
                if (map != NULL) {
                    CFuncPoint *point = map->func_point.Search("e277");
                    if (point != NULL) {
                        point->enable = 1;
                    }
                }
            }
            if (item_no == 0x1AC) {
                GetUserDataMan()->monster_box.EnableChange(0xC);
            }
            if (item_no == 0x1AB) {
                GetUserDataMan()->monster_box.EnableChange(0xB);
            }
            if (item_no == 0x1A6) {
                GetUserDataMan()->SetVoiceUnit(1);
            }
            if (item_no == 0x163) {
                GetUserDataMan()->GetInventUserData()->GetScoopData()->KnowScoop();
            }
            if (NowSellMode == SHOP_SELL_MODE_DONY) {
                GetMenuSysData()->GetGhobi(item_no);
            }
            CShopPtr->CheckEventItem();
            CShopPtr->CheckSyojiHin();
            CheckEnableHaveItemNum();
            UpdataScrlBar();
            int goods = CShopPtr->item_num;
            CheckMenuLine(&list_pos, &list_top, goods + 1, 6);
            MenuSePlay(se_handle, 0);
            if (goods <= 0) {
                key_arg_no = 1;
            }
            break;
        }
        case 0x3F2: {
            CGameDataUsed *sell_item = SearchNowPosItemExist();
            if (sell_item->GetNum() <= 0) {
                MenuSePlay(5);
            } else if (CShopPtr->price[item_no].sell <= 0) {
                MenuSePlay(5);
            } else if (CheckEquipFishRod(sell_item) == 1) {
                refuse = 4;
            } else {
                arrow_flash[1] = 0;
                arrow_flash[0] = 0;
                if (item_no == 0x1A6) {
                    ExeScript("VOICEON");
                } else if (item_no == 0x1A8) {
                    ExeScript("\x83\x71\x83\x7D\x81\x5B\x83\x89\x4F\x4E");
                } else {
                    ExeScript("VOICEOFF");
                }
                int unit_price;
                CShopPtr->GetPrice(sell_item, NULL, &unit_price);
                trade_brd->SetNumber("\x92\x50\x95\x69", unit_price);
                key_arg_no = 3;
                SetMenuKeyCtrlEnv(2);
                num_cursor = 0;
                num = 1;
                num_max = sell_item->GetNum();
                ExeScript("\x82\xA4\x82\xE9\x90\xDD\x92\xE8");
                count_mes->SetMsgItemNo(&item_name, 1);
            }
            break;
        }
        case 0x3E9:
        case 0x3F3:
            if (key_arg_no == 2) {
                // Purchase confirmation script selected by currency.
                static char *extbl[4] = {
                    "\x82\xA9\x82\xA4\x81\x48",
                    "\x82\xA9\x82\xA4\x81\x48\x52\x4F\x42\x4F",
                    "\x82\xA9\x82\xA4\x81\x48\x83\x81\x83\x5F\x83\x8B",
                    "\x82\xA9\x82\xA4\x81\x48"
                };
                if (NowSellMode != SHOP_SELL_MODE_DONY && total > CShopPtr->CheckMoney()) {
                    refuse = 1;
                    break;
                }
                ExeScript(extbl[NowSellMode]);
                key_arg_no = 4;
            }
            if (key_arg_no == 3) {
                ExeScript("\x82\xA4\x82\xE9\x81\x48");
                key_arg_no = 5;
            }
            {
                CGameDataUsed *trade_item = SearchNowPosItemExist();
                char *name = NULL;
                if (trade_item != NULL) {
                    name = trade_item->GetName(0);
                }
                char *names[2] = {NULL, NULL};
                names[0] = name;
                int values[2] = {0, 0};
                values[0] = num;
                values[1] = total;
                ask_mes->SetMsgItemNo(names, 1);
                ask_mes->SetMsgVolumeNo(values, 2);
            }
            break;
        case 0x3F7:
            item->DeleteNum(num);
            CShopPtr->AddMoney(total);
            CShopPtr->CheckSyojiHin();
            CheckEnableHaveItemNum();
            key_arg_no = 1;
            ExeScript("\x94\x84\x94\x83\x90\xAC\x97\xA7");
            MenuSePlay(se_handle, 0);
            break;
        case 0x44C:
            ExeScript("\x83\x41\x83\x43\x83\x65\x83\x80\x91\x49\x91\xF0\x82\xC9\x82\xE0\x82\xC7\x82\xE9");
            error = -1;
            key_arg_no = shop_mode_prev;
            SetMenuKeyCtrlEnv(0);
            break;
        }
        if (refuse > 0) {
            error = refuse;
            ask_mes->ClsMes::mes_no = -1;
        }
        switch (refuse) {
        case 1: {
            // Insufficient currency script selected by currency.
            static char *extbl[4] = {
                "\x82\xA8\x8B\xE0\x95\x73\x91\xAB",
                "\x45\x58\x45\x95\x73\x91\xAB",
                "\x83\x81\x83\x5F\x83\x8B\x95\x73\x91\xAB",
                "\x82\xA8\x8B\xE0\x95\x73\x91\xAB"
            };
            key_arg_no = 6;
            ExeScript(extbl[NowSellMode]);
            break;
        }
        case 2:
            key_arg_no = 6;
            ExeScript("\x8B\xF3\x82\xAB\x83\x58\x83\x79\x81\x5B\x83\x58\x96\xB3\x82\xB5");
            break;
        case 3: {
            key_arg_no = 6;
            ExeScript("\x83\x41\x83\x43\x83\x65\x83\x80\x8C\xC0\x8A\x45");
            char *message[1] = {NULL};
            message[0] = GetItemMessage(item_no);
            ask_mes->SetMsgItemNo(message, 1);
            break;
        }
        case 4:
            key_arg_no = 6;
            ExeScript("\x8D\xC5\x8C\xE3\x82\xCC\x95\x90\x8A\xED");
            break;
        }
        break;
    }
    default:
        ExtendCommand(lr, push);
        break;
    }
    MenuPosData->FormStep();
    CalcTex();
    CalcCursorPosition();
    CGameDataUsed *now_item = SearchNowPosItemExist();
    if (now_item != NULL) {
        MenuDCMsg[0]->MakeMsg(now_item);
    } else {
        MenuDCMsg[0]->MakeMsg(now_item);
    }
    return ret;
}
void CShopMenu::CalcTex() {
    int pos[3][2];
    int name_pos[2];
    float bar_pos[2];
    if (shop_name_brd != NULL && MenuMesForm[1] != NULL) {
        shop_name_brd->GetPutPosXY("\x92\x86\x90\x53", name_pos[0], name_pos[1]);
        MenuDCMsg[1]->SetMovePosGyou(0, name_pos[0] - shop_name_ofs_x, name_pos[1] + shop_name_ofs_y);
    }
    if (item_list != NULL && item_brd != NULL) {
        CalcMenu1(item_brd->y - 44.0f * (float)list_top, &item_list->y, 4.0f, 0.0f, 0);
        item_brd->GetPutPosXY("\x83\x6F\x81\x5B\x8A\xEE\x96\x7B", bar_pos[0], bar_pos[1]);
        bar_pos[1] -= item_brd->y;
        CalcMenu1(bar_pos[1] + scrl_bar_step * (float)list_top, &scrl_bar_top->y, 4.0f, 0.0f, 0);
        scrl_bar_body->y = scrl_bar_top->y + scrl_bar_top->h;
        scrl_bar_bottom->y = scrl_bar_body->y + scrl_bar_body->h;
    }
    CUserDataManager *user_data = GetUserDataMan();
    if (money_brd != NULL) {
        money_brd->SetNumber("num", user_data->money);
    }
    if (exp_brd != NULL) {
        exp_brd->SetNumber("corep", GetDispVolumeForFloat(user_data->GetRoboAbs()));
    }
    if (medal_brd != NULL) {
        medal_brd->SetNumber("num", CShopPtr->CheckMoney());
    }
    Func_MenuItemBrdPosStep(bag_top);
    NowGiftBoxPtr = SearchNowPosItemExist();
    if (GiftBoxViewForm != NULL) {
        int view_pos[2] = { 0, 0 };
        if (key_arg_no == SHOP_MENU_MODE_BAG) {
            MenuPosData->GetPosMenuItemOnItemBrd(view_pos, bag_pos, 0);
        } else {
            NowGiftBoxPtr = NULL;
            view_pos[0] = 0x280;
            view_pos[1] = 0x1B8;
        }
        CMenuPosDataForm *view_form = GiftBoxViewForm;
        view_form->x = view_pos[0];
        view_form->y = view_pos[1];
        if (mode == 2) {
            NowGiftBoxPtr = NULL;
        }
    }
    CDC2Mes *message = MenuDCMsg[2];
    CMenuPosDataForm *message_form = MenuMesForm[2];
    if (message_form != NULL) {
        message_form->draw_flag = 0;
        message->MakeMsg(0);
        if (NowSellMode == SHOP_SELL_MODE_MONEY && (key_arg_no == SHOP_MENU_MODE_BAG || key_arg_no == SHOP_MENU_MODE_SELL_NUM)) {
            int py;
            s16 *mes_width;
            int win_y;
            int koma[2];
            int mes_no;
            int sell;
            CGameDataUsed *item;
            int gift_box;
            int line;
            int win_x;
            mes_width = &price_mes_width;
            item = SearchNowPosItemExist();
            message->point_y = 0;
            gift_box = 0;
            mes_no = -1;
            if (item->item_no > 0) {
                message_form->draw_flag = 1;
                sell = 0;
                CShopPtr->GetPrice(item, NULL, &sell);
                if (item->used_type == USED_ITEM_TYPE_GIFT_BOX) {
                    gift_box = 1;
                }
                if (sell <= 0) {
                    message->win_color.r = 0x3B;
                    mes_width = &no_price_mes_width;
                    message->win_color.g = 0x16;
                    message->win_color.b = 0x16;
                    message->win_color.a = 0x80;
                    mes_no = 0x3EA;
                } else {
                    message->SetMsgVolumeNoOne(sell);
                    message->win_color.r = 0x27;
                    message->win_color.g = 0x20;
                    message->win_color.b = 0x20;
                    message->win_color.a = 0x80;
                    mes_no = 0x3E8;
                }
                message->MakeMsg(mes_no);
            }
            message->StepMsg();
            line = bag_pos / 6 - bag_top;
            MenuPosData->GetPosMenuItemBrdKoma(koma, bag_pos, 1);
            if (gift_box == 1) {
                koma[0] += 0x2C;
                win_x = koma[0] + 0xA;
                if (win_x > mgScreenWidth - *mes_width - 0x1E) {
                    win_x -= *mes_width + 0x6D;
                }
                koma[1] = koma[1] + 0xC;
                win_y = koma[1] - 0x1A;

                py = koma[1] - win_y;
                message->point_x = koma[0] - win_x;
                message->point_y = py;
            } else {
                koma[0] += 0x14;
                win_x = koma[0] - *mes_width / 2;
                if (mgScreenWidth - 0x28 < (int)win_x + *mes_width) {
                    if (mgScreenWidth - 0x28 - *mes_width < (int)win_x) {
                        do {
                            win_x--;
                        } while (mgScreenWidth - 0x28 - *mes_width < win_x);
                    }
                }

                win_y = koma[1] + 0x32;
                if (line >= 3) {
                    win_y = koma[1] - 0x50;
                    if (mes_no == 0x3EA) {
                        win_y = koma[1] - 0x32;
                    }
                }

                py = koma[1] - win_y;
                message->point_x = koma[0] - win_x;
                message->point_y = py;
            }
            message_form->x = win_x;
            message_form->y = win_y;
        }
    }
    if (trade_brd != NULL) {
        trade_brd->GetPutPosXY("\x97\xF1\x30", pos[0][0], pos[0][1]);
        int *up = pos[1];
        trade_brd->GetPutPosXY("\x97\xF1\x31", up[0], up[1]);
        int *down = pos[2];
        trade_brd->GetPutPosXY("\x8D\x87\x8C\x76\x8B\xE0\x8A\x7A", down[0], down[1]);
        trade_brd->SetNumber("\x90\x94", num);
        if (NowSellMode != SHOP_SELL_MODE_DONY || (key_arg_no != SHOP_MENU_MODE_BUY_NUM && key_arg_no != SHOP_MENU_MODE_BUY_ASK && key_arg_no != SHOP_MENU_MODE_BUY_ERROR)) {
            MenuDCMsg[3]->SetMovePosGyou(0, pos[0][0], pos[0][1]);
            MenuDCMsg[3]->SetMovePosGyou(1, up[0], pos[1][1]);
            MenuDCMsg[3]->SetMovePosGyou(2, down[0], pos[2][1]);
        }
        trade_brd->SetPartRGBA("\x96\xEE\x88\xF3\x8F\xE3", 0x80, 0x80, 0x80, 0x80);
        trade_brd->SetPartRGBA("\x96\xEE\x88\xF3\x89\xBA", 0x80, 0x80, 0x80, 0x80);
        if (0 < arrow_flash[0]) {
            trade_brd->SetPartRGBA("\x96\xEE\x88\xF3\x8F\xE3", 0xA4, 0xA4, 0xA4, 0x80);
        }
        if (0 < arrow_flash[1]) {
            trade_brd->SetPartRGBA("\x96\xEE\x88\xF3\x89\xBA", 0xA4, 0xA4, 0xA4, 0x80);
        }
    }
    if (0 < arrow_flash[0]) {
        arrow_flash[0]--;
    }
    if (0 < arrow_flash[1]) {
        arrow_flash[1]--;
    }
}
/**
 *
 * Position or offset of a shop menu cursor.
 *
 */
struct CursorPoint {
    int x; /**< Horizontal coordinate. */
    int y; /**< Vertical coordinate. */
};

/**
 *
 * Sets a shop menu form's position from integer screen coordinates.
 *
 */
static inline void SetFormPoint(CMenuPosDataForm *form, int x, int y) {
    form->x = (float) x;
    form->y = (float) y;
}

void CShopMenu::CalcCursorPosition() {
    // Quantity and cancellation cursor part names.
    static char *cursortbl[2] = {
        "0",
        "1"
    };

    // Cursor frame offset for the player's bag.
    static CursorPoint cursor_offsetxy = {-46, 18};

    // Cursor frame offset for the shop goods list.
    static CursorPoint t_offxy = {0, 0};

    CursorPoint  position = {0, 0};
    CursorPoint  bag_point;
    int          waku_type = -1;
    CursorPoint *offset = &t_offxy;

    switch (key_arg_no) {
        case SHOP_MENU_MODE_BUY_LIST:
            position.x = fptosi(list_x - 10.0f);
            position.y = fptosi(list_y + (float) ((list_pos - list_top) * 0x2C));
            break;
        case SHOP_MENU_MODE_BAG:
            MenuPosData->GetPosMenuItemOnItemBrd(&bag_point.x, bag_pos, 1);
            waku_type = 0;
            offset = &cursor_offsetxy;
            position.x = bag_point.x - 8;
            position.y = bag_point.y - 10;
            break;
        default:
            if (trade_brd != NULL) {
                trade_brd->GetPutPosXY(cursortbl[num_cursor], position.x, position.y);
            }

            break;
    }

    if (cursor_reset != 0) {
        SetFormPoint(MenuCommonInfo->cursor_form, position.x, position.y);
        SetFormPoint(MenuCommonInfo->waku_form, position.x, position.y);
        cursor_reset = 0;
    }

    MenuCommonInfo->MenuPosStep(&position.x, &offset->x);
    MenuCommonInfo->SetWakuType(waku_type);
    MenuCommonInfo->SetWakuWH(0, 0x24, 0x2A);
}

CGameDataUsed *CShopMenu::SearchNowPosItemExist() {
    switch (key_arg_no) {
        case SHOP_MENU_MODE_BUY_LIST:
        case SHOP_MENU_MODE_BUY_NUM:
        case SHOP_MENU_MODE_BUY_ASK:
        case SHOP_MENU_MODE_BUY_ERROR: {
            int    item_no;
            CShop *shop = CShopPtr;
            int    position = list_pos;

            if (position < 0 || shop->item_num <= position) {
                item_no = 0;
            } else {
                item_no = shop->item_no[position];
            }

            shop_item.Init();
            GetUserDataMan()->CopyGameData(&shop_item, item_no);

            if (shop_item.used_type == USED_ITEM_TYPE_WEAPON) {
                shop_item.data.weapon.fusion_point = 0;
            }

            return &shop_item;
        }
        case SHOP_MENU_MODE_BAG:
        case SHOP_MENU_MODE_SELL_NUM:
        case SHOP_MENU_MODE_SELL_ASK:
        case SHOP_MENU_MODE_SELL_ERROR:
            return GetUserDataMan()->GetUsedDataPtr(bag_pos);
    }

    return NULL;
}
void ShopSellListDraw(int &tex_block, float *pos) {
    // Neutral item icon color used in the shop list.
    static u8 rgba[4] = {128, 128, 128, 128};

    mgCTexture *icon_tex = MenuPosData->item_icon_tex[0][0];
    int line;
    if (icon_tex == NULL) {
        return;
    }
    MenuReloadTexture(tex_block, icon_tex->block);
    mgRect<int> money_mark(0, 0xC4, 0x24, 0x10);
    mgRect<int> abs_mark(0x24, 0xC4, 0x24, 0x10);
    mgRect<int> medal_mark(0x48, 0xC2, 0x12, 0x12);
    mgRect<int> free_mark(0xAA, 0x9E, 0x30, 0x10);
    mgRect<int> *price_mark = &money_mark;
    if (NowSellMode == SHOP_SELL_MODE_ROBO_ABS) {
        price_mark = &abs_mark;
    }
    if (NowSellMode == SHOP_SELL_MODE_MEDAL) {
        price_mark = &medal_mark;
        if (LanguageCode > 0) {
            price_mark = &free_mark;
            free_mark.right = 0x32;
        }
        if (LanguageCode == 4) {
            free_mark.right = 0x36;
        }
    }
    mgRect<int> have_board(0x3A, 0x94, 0x30, 0x28);
    mgRect<int> have_digits(0, 0xD4, 0xB, 0x14);
    mgRect<int> price_digits(0, 0xE8, 0xB, 0x17);
    if (LanguageCode > 0) {
        abs_mark.left = 0x28;
        have_board.left = 0x3E;
    }
    mgRect<int> line_rect(0, 0x8E, 0xB0, 6);
    mgCDrawPrim *prim = GetMenuPrim();
    SetSpriteEnv(prim, 0);
    float price_x;
    int price;
    float mark_x;
    float x;
    int count;
    float y;
    x = pos[0] + 18.0f;
    y = pos[1] + 44.0f;
    CGameDataUsed item;
    price_x = x + 92.0f;
    if (LanguageCode > 0 && NowSellMode == SHOP_SELL_MODE_MEDAL) {
        price_x -= 12.0f;
    }
    mark_x = price_x;
    if (LanguageCode > 0 && NowSellMode == SHOP_SELL_MODE_ROBO_ABS) {
        mark_x += 6.0f;
    }
    count = CShopPtr->item_num;
    for (line = 0; line < count; line++, y += 44.0f) {
        if (y + 44.0f < 0.0f) {
            continue;
        }
        int item_no = CShopPtr->GetItemNo(line);
        if ((float)(mgScreenHeight - 30) <= y) {
            break;
        }
        prim->Bilinear(0);
        prim->Begin(MG_PRIM_SPRITE);
        prim->Texture(Tex_Shop);
        prim->Color(0x80, 0x80, 0x80, 0x80);
        PrimQuad(prim, x - 4.0f, y + 40.0f, line_rect);
        PrimQuad(prim, x + 128.0f, y + 1.0f, have_board);
        int have = CShopPtr->GetHaveNum(line);
        price = have;
        PrimDrawNumber(prim, have, 1, fptosi(x + 134.0f + 23.0f), fptosi(y + 12.0f), have_digits, 0, 0);
        item.item_no = item_no;
        CShopPtr->GetPrice(&item, &price, NULL);
        PrimDrawNumber(prim, price, 0, fptosi(price_x), fptosi(y + 16.0f), price_digits, 0, 0);
        int mark_y = fptosi(y + 22.0f);
        int mark_left = fptosi(mark_x);
        PrimQuad(prim, mgRect<int>(mark_left, mark_y, price_mark->right, price_mark->bottom), *price_mark);
        prim->End();
        mgRect<float> icon_rect(x, y, 32.0f, 40.0f);
        if (item_no == 0x1A8 || item_no == 0x1AB || item_no == 0x1AC || item_no == 0x1A6) {
            prim->Bilinear(1);
            prim->Begin(MG_PRIM_SPRITE);
            prim->Color(0x80, 0x80, 0x80, 0x80);
            mgRect<int> robo_icon(0x6A, 0xAE, 0x22, 0x22);
            if (LanguageCode > 0) {
                robo_icon.left += 4;
            }
            if (item_no == 0x1A8) {
                robo_icon.left += 0x22;
            }
            if (item_no == 0x1AC) {
                robo_icon.left += 0x44;
            }
            if (item_no == 0x1AB) {
                robo_icon.left += 0x66;
            }
            PrimQuad(prim, icon_rect, robo_icon);
            prim->End();
        } else {
            DrawOneItem(prim, icon_rect, item_no, 0, NULL, rgba, 0);
        }
    }
}

void MenuShopInit(mgCMemory *stack, int *tex_block, int arg) {
    int               cfg_size;
    CMenuPosDataForm *form;
    int               no;
    int               form_num;
    int               free_size = stack->stGetRest();
    u_long128        *top = stack->stGetTop();
    MenuLocalStack.stSetBuffer(top, free_size);
    CShopMenu *menu = new (MenuLocalStack.Alloc(0x23)) CShopMenu;

    CShopMenuPt = menu;
    CShopMenuPt->SetTexBlock(tex_block);
    CShop *shop;

    if ((shop = (CShop *) operator new(sizeof(CShop), MenuLocalStack.Alloc(0x123))) != NULL) {
        memset(shop, 0, sizeof(CShop));
    }

    int shop_id = MenuArg.param[0];
    CShopPtr = shop;

    if (shop_id < 0) {
        shop_id = 0;
    }

    shop->shop_id = shop_id;
    MenuMainScene->GetActiveBgmStatus(&CShopMenuPt->bgm_status);
    MenuMainScene->StopBGM(0);
    MenuMoveItemPtr = new (MenuLocalStack.Alloc(0x13)) CMenuMoveItem;
    MenuCommonInfo->now_mode = MENU_MODE_SHOP;
    MenuMainImageDataEnter(CShopMenuPt->tex_block[1]);
    short *system_mes = GetSystemMesBuffer();
    short *menu_mes = GetMenuMainMessageBuffer();
    MenuCommandAnalyzeInfo.system_mes_buff[0] = system_mes;
    MenuCommandAnalyzeInfo.mes_buff[0] = menu_mes;
    MenuCommandAnalyzeInfo.system_mes_buff[1] = menu_mes;
    CDC2Mes *message = MenuDCMsg[2];
    message->SetMessData(menu_mes, menu_mes);
    message->MsgPreset(6);
    message->fuchi = 4;
    message->value_sign = 0;
    message->value_zero = 1;
    int width = 60;
    message->line_indent_on = 1;
    message->MakeMsg(0x3E8);
    message->StepMsg();

    if (message->line_w[0] > 60) {
        width = message->line_w[0];
    }

    int no_width = 60;
    CShopMenuPt->price_mes_width = width;
    message->MakeMsg(0x3EA);
    message->StepMsg();

    if (message->line_w[0] > 60) {
        no_width = message->line_w[0];
    }

    CShopMenuPt->no_price_mes_width = no_width;
    message->MakeMsg(0);
    MenuDataAnalyze(GetMenuMainPosCfgBuffer(&cfg_size), cfg_size, &MenuLocalStack);
    form = MenuPosData->GetFormInfo(0x50);
    form_num = MenuPosData->form_num;

    for (no = 0x50; no < form_num; no++, form++) {
        if (form != NULL && form->name != NULL && strcmp(form->name, "msg0") != 0 &&
            strcmp(form->name, "msg1") != 0 && strcmp(form->name, "howmachbrd") != 0 &&
            strcmp(form->name, "cursor0") != 0 && strcmp(form->name, "cur_waku0") != 0) {
            form->draw_flag = 0;
        }
    }

    form = MenuPosData->GetFormInfo(1);

    for (no = 1; no < 9; no++, form++) {
        if (form != NULL && form->name != NULL) {
            form->draw_flag = 0;
        }
    }

    MenuPosData->InitDrawList();
    MenuPosData->AttachCommonTexInfo();
    MenuCommonInfo->AttachFuncData();
    AttachMessageForm();
    MenuMainFrameModeSet(0, 1);
    CShopMenuPt->AttachForm();
    MenuLocalStack.Alloc(0x180);
    MenuLocalStack.Align64();
    CShopMenuPt->pack = (u_int *) MenuLocalStack.stGetTop();
    CShopMenuPt->pack_size =
        LoadFileMenu("shop.pac", (u_long128 *) CShopMenuPt->pack, 1);
    u_int pack_size = CShopMenuPt->pack_size;
    MenuLocalStack.Alloc((pack_size & 0xF) ? (pack_size >> 4) + 1 : pack_size >> 4);
    MenuLocalStack.Alloc(0x100);
    GiftBoxViewForm = NULL;
    CheckEnableHaveItemNum();
    CShopMenuPt->InitEnd();
}

int MenuShopKey() {
    return CShopMenuPt->KeyStep();
}

void MenuShopDraw() {
    MenuPosData->FormDraw();
}

void CMenuQuestView::UnderMsg(int type) {
    int position[2];
    QuestMenuMes->MsgPreset(2);
    QuestMenuMes->push_button = 0;

    if (type == 0) {
        QuestMenuMes->MakeMsg(0xDAC);
    }

    if (type == 1) {
        QuestMenuMes->MakeMsg(0xDAD);
    }

    QuestMenuMes->StepMsg();
    position[0] = ((mgScreenWidth - QuestMenuMes->line_w[0]) >> 1) - 14;
    position[1] = mgScreenHeight - 96;
    QuestMenuMes->SetPutPos(position);
    QuestMenuMes->SetWindowMode(4);
}

int CMenuQuestView::SelectMax() {
    if (Menu_Memo_ViewMode == QUEST_VIEW_MODE_QUEST) {
        return QuestMan->num;
    }

    if (Menu_Memo_ViewMode == QUEST_VIEW_MODE_SCOOP) {
        return QUEST_VIEW_SCOOP_COUNT;
    }

    return 1;
}

/**
 *
 * Interpolation divisor for quest memo list and cursor movement.
 *
 */
static float QuestMoveRate = 1.0f;

void CMenuQuestView::InitEnd() {
    // Package names for the quest and memo view.
    static char *packname[2] = {
        "quest.pac",
        "scoop.pac"
    };

    select = 0;
    top = 0;
    int              line;
    CInventUserData *invent = GetInventUserDataPtr();

    for (int slot = 0; slot < QUEST_VIEW_PHOTO_MAX; slot++) {
        photo_no[slot] = -1;

        if (invent != NULL) {
            USER_PICTURE_INFO *photo = invent->GetPhotoInfo(slot);

            if (photo != NULL && photo->used != 0) {
                photo_no[slot] = photo->neta_id;
            }
        }
    }

    MenuLocalStack.Align64();
    u_int *pack = (u_int *) MenuLocalStack.stGetTop();
    int    size = LoadFileMenu(packname[Menu_Memo_ViewMode], (u_long128 *) pack, 1);

    if (0 < size) {
        unsigned int quadwords;

        if ((size & 15) != 0) {
            quadwords = ((unsigned int) size >> 4) + 1;
        } else {
            quadwords = (unsigned int) size >> 4;
        }

        MenuLocalStack.Alloc(quadwords);

        if (Menu_Memo_ViewMode == QUEST_VIEW_MODE_QUEST) {
            char name[64];
            sprintf(name, "quest%d.cfg", LanguageCode);
            char *script = (char *) GetPackFile(pack, name, &size);

            if (script != NULL) {
                QuestMan->LoadCfg(&MenuLocalStack, script, size);
            }
        }

        if (Menu_Memo_ViewMode == QUEST_VIEW_MODE_SCOOP) {
            InitScoopString();
            char *script = (char *) GetPackFile(pack, "scoop.cfg", &size);

            if (script != NULL) {
                AnalyzeScoopString(&MenuLocalStack, script, size);
            }
        }

        QuestMenuMes = new (MenuLocalStack.Alloc(sizeof(CDC2Mes) / sizeof(u_long128) + 2)) CDC2Mes;
        short *system_mes = GetSystemMesBuffer();
        QuestMenuMes->SetMessData(system_mes, GetMenuMainMessageBuffer());
        UnderMsg(0);

        for (line = 0; line < 3; line++) {
            QuestCommentMes[line] = new (MenuLocalStack.Alloc(sizeof(CDC2Mes) / sizeof(u_long128) + 2)) CDC2Mes;
            short *system_mes = GetSystemMesBuffer();
            QuestCommentMes[line]->SetMessData(system_mes, GetMenuMainMessageBuffer());
            QuestCommentMes[line]->MsgPreset(16);
            QuestCommentMes[line]->push_button = 0;
        }

        u_char *image = (u_char *) GetPackFile(pack, "out.img", NULL);
        mgTexManager.EnterIMGFile(image, tex_block[0], NULL, NULL);
        Tex_QuestMemo = mgTexManager.GetTexture("memonpc", -1);
        QuestTilePatternXY = 0.0f;
    }

    QuestScrlBarH = 10.0f;
    QuestScrlBarY = 90.0f;
    QuestCursorPos[0] = 82.0f;
    QuestCursorPos[1] = 90.0f;

    if (SelectMax() != 0) {
        QuestScrlBarH = 7.0f * (float) (248 / SelectMax());
    }

    QuestMoveRate = 1.0f;
    QuestViewCommentFlag = 0;
    ActiveQuestInfo = NULL;
    ScmFlagCtrl = NULL;
    FadeInMenu(40, 0.0f);
}

int CMenuQuestView::KeyStep() {
    MenuCommonInfo->CheckSelectKey();
    int lr_key = MenuCommonInfo->CheckLRKey();
    int push = MenuCommonInfo->CheckPushButton();
    int jump = 0;
    switch (mode) {
    case 1:
        if (FadeCheckMenu()) {
            MenuCommonInfo->key_enable = 1;
            mode = 0;
            QuestMoveRate = 4.0f;
        }
        break;
    case 2:
        if (FadeCheckMenu()) {
            FadeInMenu(0x28, 0.0f);
            DeleteTexBlock();
            return 1;
        }
        break;
    case 0:
        if (menu_debug_flag) {
            if (lr_key & 1) {
                menu_debug_questselect--;
            }
            if (lr_key & 2) {
                menu_debug_questselect++;
            }
            if (menu_debug_questselect < 0) {
                menu_debug_questselect = 0;
            }
            if (SelectMax() <= menu_debug_questselect) {
                menu_debug_questselect = SelectMax() - 1;
            }
            if (Menu_Memo_ViewMode == 1) {
                SCOOP_DATA *scoop = GetScoopDataTableIndex(menu_debug_questselect);
                if (scoop == NULL) {
                    return 0;
                }
                SCOOP_INFO *info = ScoopMan->GetScoopInfo(scoop->scoop_id);
                if (push & 1) {
                    info->known ^= 1;
                }
                if (push & 2) {
                    info->obtained ^= 1;
                }
            }
            if (Menu_Memo_ViewMode == 0) {
                QUEST_PLAY_DATA *quest = QuestDataPtr->GetPlayQuestData(menu_debug_questselect);
                if (push & 1) {
                    quest->accepted ^= 1;
                }
                if (push & 2) {
                    quest->cleared ^= 1;
                }
            }
            return 0;
        }
        switch (step) {
        case 0: {
            int max = SelectMax();
            int select_key = MenuListSelectKeyCheck(lr_key, 7);
            int old_select = select;
            int old_top = top;
            MenuKeySelectCheck(select_key, &select, &top, 0, max, 7, 0);
            if (old_select != select) {
                MenuSePlay(SYSTEM_SE_CURSOR);
                if (abs(old_top - top) > 1) {
                    jump = 1;
                }
            }
            if (push & 1) {
                if (Menu_Memo_ViewMode == 0) {
                    QUEST_PLAY_DATA *quest = QuestDataPtr->GetPlayQuestData(select);
                    if (quest == NULL || quest->accepted == 0) {
                        break;
                    }
                    step = 1;
                    QuestViewCommentFlag = 1;
                    ActiveQuestInfo = QuestMan->GetQuestInfo(select);
                    QuestCommentMes[0]->MakeMsg(ActiveQuestInfo->name);
                    QuestCommentMes[0]->StepMsg();
                    QuestCommentMes[1]->MakeMsg(ActiveQuestInfo->comment);
                    QuestCommentMes[1]->StepMsg();
                    char *reaction = ActiveQuestInfo->reaction[0];
                    if (quest->cleared != 0) {
                        reaction = ActiveQuestInfo->reaction[1];
                    }
                    QuestCommentMes[2]->MakeMsg(reaction);
                    QuestCommentMes[2]->StepMsg();
                    QuestReactionCommentGyouNum = 1;
                    if (0 < QuestCommentMes[2]->line_w[1]) {
                        QuestReactionCommentGyouNum = 2;
                    }
                    float width = 0.0f;
                    for (int line = 0; line < 3; line++) {
                        float line_w = QuestCommentMes[1]->line_w[line];
                        if (width < line_w) {
                            width = line_w;
                        }
                    }
                    QuestCommentWinX = (int)(mgScreenWidth - width) >> 1;
                    UnderMsg(1);
                } else if (Menu_Memo_ViewMode == 1) {
                    ScmFlagCtrl = GetScoopDataTableIndex(select);
                    if (ScmFlagCtrl == NULL) {
                        break;
                    }
                    SCOOP_INFO *info = ScoopMan->GetScoopInfo(ScmFlagCtrl->scoop_id);
                    if (info == NULL || info->known == 0) {
                        break;
                    }
                    char photo_name[0x100];
                    step = 1;
                    QuestViewCommentFlag = 1;
                    GetPhotoNameStr(ScmFlagCtrl->scoop_id, photo_name);
                    QuestCommentMes[0]->MakeMsg(photo_name);
                    QuestCommentMes[0]->StepMsg();
                    QuestCommentMes[1]->MakeMsg(ScmFlagCtrl->text);
                    QuestCommentMes[1]->StepMsg();
                    float width = 0.0f;
                    for (int line = 0; line < 3; line++) {
                        float line_w = QuestCommentMes[1]->line_w[line];
                        if (width < line_w) {
                            width = line_w;
                        }
                    }
                    QuestCommentWinX = (int)(mgScreenWidth - width) >> 1;
                    UnderMsg(1);
                }
                MenuSePlay(SYSTEM_SE_DECIDE);
            } else if (push & 2) {
                FadeOutMenu(0x28, 0.0f);
                MenuSePlay(5);
                mode = 2;
            }
            break;
        }
        case 1:
            if (push != 0) {
                QuestViewCommentFlag = 0;
                ActiveQuestInfo = NULL;
                ScmFlagCtrl = NULL;
                step = 0;
                MenuSePlay(5);
                UnderMsg(0);
            }
            break;
        }
        break;
    }
    QuestTilePatternXY += 0.5f;
    if (0.0f <= QuestTilePatternXY) {
        QuestTilePatternXY -= 128.0f;
    }
    float target = 0x52 - top * 0x22;
    QuestListTopY += (target - QuestListTopY) / QuestMoveRate;
    if (jump) {
        QuestListTopY = target;
    }
    if (Menu_Memo_ViewMode == 0) {
        target = 77.0f + (float)top * ((248.0f - QuestScrlBarH) / (float)(QuestMan->num - 7));
    }
    if (Menu_Memo_ViewMode == 1) {
        target = 77.0f + ((248.0f - QuestScrlBarH) / 46.0f) * (float)top;
    }
    QuestScrlBarY += (target - QuestScrlBarY) / QuestMoveRate;
    if (jump) {
        QuestScrlBarY = target;
    }
    QuestCursorPos[1] += ((float)((select - top) * 0x22 + 0x52) + 3.0f - QuestCursorPos[1]) / QuestMoveRate;
    return 0;
}

#ifdef NONMATCHING
void MenuNPCQuestViewInit(mgCMemory *stack, int *tex_block, int view_mode) {
    Menu_Memo_ViewMode = 0;

    if (view_mode == 1) {
        Menu_Memo_ViewMode = 1;
    }

    stack->Align64();
    int        free_size = stack->stGetRest();
    u_long128 *top = stack->stGetTop();
    MenuLocalStack.stSetBuffer(top, free_size);
    CMenuQuestView *view = new (MenuLocalStack.Alloc(0x1B)) CMenuQuestView;

    MenuQuestView = view;
    CQuestManager *quest;

    if ((quest = (CQuestManager *) operator new(sizeof(CQuestManager), MenuLocalStack.Alloc(3))) != NULL) {
        quest->Initialize();
    }

    QuestMan = quest;
    QuestDataPtr = &GetSaveData()->quest_data;
    ScoopMan = GetSaveData()->GetUserDataManager()->GetInventUserData()->GetScoopData();
    MenuQuestView->SetTexBlock(tex_block);
    MenuQuestView->InitEnd();
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menushop", MenuNPCQuestViewInit__FP9mgCMemoryPii);
#endif

int MenuNPCQuestViewKey() {
    return MenuQuestView->KeyStep();
}

/**
 *
 * Photograph stamp variants selected by scoop index.
 *
 */
static s8 randam_checktbl[60] = {
    0, 1, 2, 3, 1, 3, 2, 1, 0, 3, 0, 1, 3, 2, 1, 0, 2, 0, 3, 1, 0, 1, 2, 3, 1, 3, 2, 1, 0, 3, 0, 1, 3, 2, 1, 0, 2, 0, 3, 1, 0, 1, 2, 3, 1, 3, 2, 1, 0, 3, 0, 1, 3, 2, 1, 0, 2, 0, 3, 1
};

void MenuNPCQuestViewDraw() {
    // Quest board texture rows.
    static short tbl[7][12] = {
        {0, 0, 26, 26, 26, 0, 6, 26, 32, 0, 26, 26},
        {0, 26, 26, 4, 26, 26, 6, 4, 32, 26, 26, 4},
        {0, 30, 26, 14, 26, 30, 6, 14, 32, 30, 26, 14},
        {0, 44, 26, 4, 26, 44, 6, 4, 32, 44, 26, 4},
        {0, 48, 26, 14, 26, 48, 6, 14, 32, 48, 26, 14},
        {0, 62, 26, 4, 26, 62, 6, 4, 32, 62, 26, 4},
        {0, 66, 26, 26, 26, 66, 6, 26, 32, 66, 26, 26}
    };

    int mark_u;
    if (Tex_QuestMemo == NULL) {
        return;
    }
    mgCTextureManager *textures = &mgTexManager;
    textures->ReloadTexture(Tex_QuestMemo->block, (sceVif1Packet *)NULL);
    mgCDrawPrim *prim = GetMenuPrim();
    SetSpriteEnv(prim, 0);
    DrawMenuTilePattern(prim, Tex_QuestMemo, QuestTilePatternXY, QuestTilePatternXY,
                        mgRect<int>(0x180, 0, 0x80, 0x80), 0, NULL);
    SetSpriteEnv(prim, 0);
    prim->Begin(MG_PRIM_SPRITE);
    prim->Texture(Tex_QuestMemo);
    mgRect<int> board_rect(0, 0xBA, 0x184, 0x146);
    mgRect<int> line_rect(0, 0xB4, 0x138, 6);
    prim->Color(0, 0, 0, 0x30);
    PrimQuad(prim, 66.0f, 60.0f, board_rect);
    prim->Color(0x80, 0x80, 0x80, 0x80);
    PrimQuad(prim, 60.0f, 54.0f, board_rect);
    prim->End();
    SetMenuScissor(mgRect<int>(0, 0x52, mgScreenWidth - 1, 0x142));
    int font_num = 0;
    CMenuFont fonts[16];
    int y = (int)(QuestListTopY);
    int i;
    if (Menu_Memo_ViewMode == QUEST_VIEW_MODE_QUEST) {
        for (i = 0; i < MenuQuestView->SelectMax() + 1; i++, y += 0x22) {
            if (y + 0x22 < 0x52) {
                continue;
            }
            if (y >= 0x143) {
                break;
            }
            prim->Begin(MG_PRIM_SPRITE);
            prim->Texture(Tex_QuestMemo);
            prim->Color(0x80, 0x80, 0x80, 0x80);
            PrimQuad(prim, 118.0f, (float)(y - 2), line_rect);
            QUEST_INFO *info = QuestMan->GetQuestInfo(i);
            QUEST_PLAY_DATA *play = QuestDataPtr->GetPlayQuestData(i);
            if (info == NULL || play == NULL) {
                prim->End();
                break;
            }
            mark_u = 0x48;
            if (play->accepted == 1 && play->cleared == 0) {
                mark_u = 0x3A;
            }
            PrimQuad(prim, 124.0f, (float)(y + 0xB), mgRect<int>(mark_u, 0x30, 0xE, 0xE));
            int stamp_y = y + 5;
            int stamp_v = 0x18;
            if (play->cleared != 0) {
                stamp_v = 0;
            }
            PrimQuad(prim, 376.0f, (float)stamp_y, mgRect<int>(0x3A, stamp_v, 0x1C, 0x18));
            prim->End();
            CMenuFont *font = &fonts[font_num];
            font->SetColor(0x80132333);
            font->SetFuchi(2);
            if (play->accepted != 0) {
                font->SetStr(info->name);
            } else {
                font->SetStr(GetHatena());
            }
            font->SetPos(0x90, y + 8);
            font_num++;
        }
    }
    if (Menu_Memo_ViewMode == QUEST_VIEW_MODE_SCOOP) {
        CInventUserData *invent = GetInventUserDataPtr();
        if (invent == NULL) {
            return;
        }
        for (i = 0; i < MenuQuestView->SelectMax() + 1; i++, y += 0x22) {
            if (y + 0x22 < 0x52) {
                continue;
            }
            if (y >= 0x143) {
                break;
            }
            prim->Begin(MG_PRIM_SPRITE);
            prim->Texture(Tex_QuestMemo);
            prim->Color(0x80, 0x80, 0x80, 0x80);
            PrimQuad(prim, 118.0f, (float)(y - 2), line_rect);
            SCOOP_DATA *scoop = GetScoopDataTableIndex(i);
            if (scoop == NULL) {
                prim->End();
                continue;
            }
            SCOOP_INFO *scoop_info = ScoopMan->GetScoopInfo(scoop->scoop_id);
            if (scoop_info == NULL) {
                prim->End();
                break;
            }
            int mark_u = 0x48;
            if (scoop_info->known == 1 && scoop_info->obtained == 0) {
                mark_u = 0x3A;
            }
            PrimQuad(prim, 124.0f, (float)(y + 0xB), mgRect<int>(mark_u, 0x30, 0xE, 0xE));
            int stamp_v = 0x18;
            int stamp_y = y + 5;
            if (scoop_info->obtained != 0 || 0 <= invent->CheckNetaFlag(scoop->scoop_id) ||
                0 <= invent->CheckNetaFlagHavePhoto(scoop->scoop_id)) {
                stamp_v = 0;
            }
            PrimQuad(prim, 376.0f, (float)stamp_y, mgRect<int>(0x3A, stamp_v, 0x1C, 0x18));
            if (scoop_info->obtained != 0) {
                PrimQuad(prim, 370.0f, (float)(stamp_y - 2),
                         mgRect<int>(randam_checktbl[i] * 0x28 + 0x56, 0x18, 0x28, 0x1E));
            }
            prim->End();
            CMenuFont *font = &fonts[font_num];
            font->SetColor(0x80132333);
            font->SetFuchi(2);
            if (scoop_info->known != 0) {
                char photo_name[0x80];
                GetPhotoNameStr(scoop->scoop_id, photo_name);
                font->SetStr(photo_name);
            } else {
                font->SetStr(GetHatena());
            }
            font->SetPos(0x90, y + 8);
            font_num++;
        }
    }
    textures->ReloadTexture(MenuArg.mes_tex_block, (sceVif1Packet *)NULL);
    for (int n = 0; n < font_num; n++) {
        fonts[n].DrawDirect(fonts[n].str, fonts[n].pos_x, fonts[n].pos_y);
    }
    ResetMenuScissor();
    textures->ReloadTexture(Tex_QuestMemo->block, (sceVif1Packet *)NULL);
    prim->Begin(MG_PRIM_SPRITE);
    prim->Texture(Tex_QuestMemo);
    prim->Color(0x80, 0x80, 0x80, 0x80);
    PrimQuad(prim, 412.0f, 75.0f, mgRect<int>(0x1F4, 0x104, 0xC, 0xFC));
    mgRect<int> bar_rect(0x19E, (int)(QuestScrlBarY), 8, 0xA);
    PrimQuad(prim, bar_rect, mgRect<int>(0x3A, 0x3E, 8, 0xA));
    bar_rect.bottom = (int)(QuestScrlBarH - 20.0f);
    bar_rect.top += 0xA;
    PrimQuad(prim, bar_rect, mgRect<int>(0x3A, 0x48, 8, 0xA));
    bar_rect.top += bar_rect.bottom;
    bar_rect.bottom = 0xA;
    PrimQuad(prim, bar_rect, mgRect<int>(0x3A, 0x52, 8, 0xA));
    prim->End();
    mgCTexture *cursor = textures->GetTexture("mnmain", -1);
    if (cursor != NULL && QuestViewCommentFlag == 0) {
        textures->ReloadTexture(cursor->block, (sceVif1Packet *)NULL);
        MenuCursorDraw(cursor, QuestCursorPos, 0.0f, 0x80);
    }
    if (QuestViewCommentFlag != 0) {
        DrawMenuFillBox(0x30, 0, 0, 0);
        textures->ReloadTexture(Tex_QuestMemo->block, (sceVif1Packet *)NULL);
        short heights[7] = {26, 8, 14, 72, 14, 8, 26};
        if (1 < QuestReactionCommentGyouNum) {
            heights[5] += 0x18;
        }
        if (Menu_Memo_ViewMode == QUEST_VIEW_MODE_SCOOP) {
            heights[4] = 0;
            heights[5] = 0;
            heights[3] -= 8;
        }
        int box_y = 0x78;
        int box_x = (mgScreenWidth - 0x18C) >> 1;
        int box_h = 0;
        for (i = 0; i < 7; i++) {
            box_h += heights[i];
        }
        DrawMenuFillBox((float)(box_x + 6), 125.0f, 384.0f, (float)(box_h - 0xC), 0x56, 0, 0, 0);
        SetSpriteEnv(prim, 0);
        prim->Begin(MG_PRIM_SPRITE);
        prim->Texture(Tex_QuestMemo);
        prim->Color(0x80, 0x80, 0x80, 0x80);
        for (int part = 0; part < 7; part++) {
            Menu3DivideTextureDraw(prim, mgRect<int>(box_x, box_y, 0x18C, heights[part]), tbl[part], 1);
            box_y += heights[part];
        }
        prim->End();
        textures->ReloadTexture(MenuArg.mes_tex_block, (sceVif1Packet *)NULL);
        if (QuestCommentMes[2] != NULL) {
            int center_x = mgScreenWidth >> 1;
            QuestCommentMes[0]->SetMovePosCenteringGyou(0, center_x, 0x86);
            QuestCommentMes[1]->SetPutPos((int)(QuestCommentWinX), 0xA8, -1, -1);
            QuestCommentMes[2]->SetMovePosCenteringGyou(0, center_x, 0xFE);
            if (1 < QuestReactionCommentGyouNum) {
                QuestCommentMes[2]->SetMovePosCenteringGyou(1, center_x, 0x116);
            }
            for (int line = 0; line < 3; line++) {
                QuestCommentMes[line]->StepMsg();
                QuestCommentMes[line]->DrawMsg();
            }
        }
    }
    if (QuestMenuMes != NULL) {
        textures->ReloadTexture(MenuArg.mes_tex_block, (sceVif1Packet *)NULL);
        QuestMenuMes->StepMsg();
        QuestMenuMes->DrawMsg();
    }
    textures->ReloadTexture(Tex_QuestMemo->block, (sceVif1Packet *)NULL);
    PrimQuad(Tex_QuestMemo, 26.0f, 22.0f, mgRect<int>(0x56, 0, 0x92, 0x18), 0x80, 0x80, 0x80, 0x80);
    if (menu_debug_flag != 0) {
        CMenuFont debug_font;
        DrawMenuFillBox(0x40, 0, 0, 0);
        int line_y = 100;
        char line[0x100];
        char photo_name[0x80];
        if (Menu_Memo_ViewMode == QUEST_VIEW_MODE_QUEST) {
            QUEST_INFO *info = QuestMan->GetQuestInfo(menu_debug_questselect);
            QUEST_PLAY_DATA *play = QuestDataPtr->GetPlayQuestData(menu_debug_questselect);
            for (i = menu_debug_questselect; i < MenuQuestView->SelectMax(); i++) {
                for (int c = 0; c < 0x18; c++) {
                    line[c] = ' ';
                }
                strcpy(&line[0x18], info->name);
                if (i == menu_debug_questselect) {
                    line[1] = '>';
                }
                line[6] = '[';
                line[8] = ':';
                line[10] = ']';
                if (play->accepted != 0) {
                    line[7] = 'o';
                } else {
                    line[7] = 'x';
                }
                if (play->cleared != 0) {
                    line[9] = 'o';
                } else {
                    line[9] = 'x';
                }
                debug_font.SetStr(line);
                debug_font.SetPos(0x42, line_y);
                debug_font.DrawDirect(debug_font.str, debug_font.pos_x, debug_font.pos_y);
                line_y += 0x18;
                play++;
                info++;
            }
        }
        if (Menu_Memo_ViewMode == QUEST_VIEW_MODE_SCOOP) {
            for (int n = menu_debug_questselect; n < menu_debug_questselect + 12 && n < 0x35; n++) {
                SCOOP_DATA *scoop = GetScoopDataTableIndex(n);
                if (scoop == NULL) {
                    break;
                }
                SCOOP_INFO *scoop_info = ScoopMan->GetScoopInfo(scoop->scoop_id);
                if (scoop_info == NULL) {
                    break;
                }
                for (int c = 0; c < 0x18; c++) {
                    line[c] = ' ';
                }
                if (n == menu_debug_questselect) {
                    line[1] = '>';
                }
                line[6] = '[';
                line[8] = ':';
                line[10] = ']';
                GetPhotoNameStr(scoop->scoop_id, photo_name);
                strcpy(&line[0x18], photo_name);
                if (scoop_info->known != 0) {
                    line[7] = 'o';
                } else {
                    line[7] = 'x';
                }
                if (scoop_info->obtained != 0) {
                    line[9] = 'o';
                } else {
                    line[9] = 'x';
                }
                debug_font.SetStr(line);
                debug_font.SetPos(0x42, line_y);
                debug_font.DrawDirect(debug_font.str, debug_font.pos_x, debug_font.pos_y);
                line_y += 0x18;
            }
        }
    }
}
