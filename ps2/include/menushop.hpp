#pragma once

#include "common.h"

#include <cstring>

#include "menusys.hpp"
#include "scenesnd.hpp"
#include "userdata.hpp"

/**
 * @file
 * Declares the town shop menu, where goods are bought with money, robot energy,
 * medals or, in Donny's shop, for nothing and the player's items are sold back;
 * the shop's goods and price list read from the chapter's shop script; and the
 * NPC quest and scoop memo viewer that shares the unit.
 */

class CMenuPosDataForm;
class mgCMemory;
struct MENUFORMPARTS_TYPE;

/**
 *
 * Currencies a shop deals in, chosen by the shop's number when its goods are read.
 *
 */
enum SHOP_SELL_MODE {
    SHOP_SELL_MODE_MONEY = 0,    /**< Goods cost money (gilda), and items can be sold for money. */
    SHOP_SELL_MODE_ROBO_ABS = 1, /**< Goods cost the robot's energy (ABS); shops 0x17 and 0x1C. */
    SHOP_SELL_MODE_MEDAL = 2,    /**< Goods cost medals; shop 0x20. */
    SHOP_SELL_MODE_DONY = 3,     /**< Donny's goods are free, one of each, as his level allows; shop 0x21. */
};

/**
 *
 * Screens of the shop menu, as the menu's sub-screen field holds them; even screens deal
 * with the shop's goods, odd ones with the player's bag.
 *
 */
enum SHOP_MENU_MODE {
    SHOP_MENU_MODE_BUY_LIST = 0,    /**< Choosing one of the shop's goods. */
    SHOP_MENU_MODE_BAG = 1,         /**< Choosing an item in the bag to sell or move. */
    SHOP_MENU_MODE_BUY_NUM = 2,     /**< Choosing how many of the goods to buy. */
    SHOP_MENU_MODE_SELL_NUM = 3,    /**< Choosing how many of the item to sell. */
    SHOP_MENU_MODE_BUY_ASK = 4,     /**< Confirming the purchase. */
    SHOP_MENU_MODE_SELL_ASK = 5,    /**< Confirming the sale. */
    SHOP_MENU_MODE_BUY_ERROR = 6,   /**< Showing why the goods cannot be bought or the item sold, until a button is pressed. */
    SHOP_MENU_MODE_SELL_ERROR = 7,  /**< Bag-side message screen, left on a button press like SHOP_MENU_MODE_BUY_ERROR; never entered. */
};

/**
 *
 * Reasons a purchase or sale is refused, as CShopMenu::error holds them.
 *
 */
enum SHOP_MENU_ERROR {
    SHOP_MENU_ERROR_NONE = -1,       /**< Nothing refused. */
    SHOP_MENU_ERROR_NO_MONEY = 1,    /**< The player cannot pay for the goods. */
    SHOP_MENU_ERROR_BAG_FULL = 2,    /**< The bag has no room for the goods. */
    SHOP_MENU_ERROR_ITEM_LIMIT = 3,  /**< The player already holds as many of the goods as allowed. */
    SHOP_MENU_ERROR_LAST_WEAPON = 4, /**< The item is an equipped weapon or rod and cannot be sold ("最後の武器"). */
};

/**
 *
 * What GetDonyShopLineUp reports about Donny's goods.
 *
 */
enum DONY_SHOP_STATUS {
    DONY_SHOP_STATUS_ALL_TAKEN = 0, /**< Every one of Donny's goods has been taken. */
    DONY_SHOP_STATUS_NONE_YET = 1,  /**< Goods remain, but Donny's level offers none of them yet. */
    DONY_SHOP_STATUS_OFFERED = 2,   /**< As many goods are offered as have been taken. */
};

/**
 *
 * Kinds of memo the NPC quest viewer shows.
 *
 */
enum QUEST_VIEW_MODE {
    QUEST_VIEW_MODE_QUEST = 0, /**< The townspeople's requests ("quest.pac"). */
    QUEST_VIEW_MODE_SCOOP = 1, /**< The photo scoops ("scoop.pac"). */
};

/**
 *
 * Sizes of the shop's tables.
 *
 */
enum {
    SHOP_ITEM_MAX = 0x40,         /**< Goods one shop can offer. */
    SHOP_PRICE_MAX = 0x200,       /**< Item numbers the price list covers. */
    SHOP_LIST_LINE = 6,           /**< Lines of goods the shop list shows at once. */
    QUEST_VIEW_PHOTO_MAX = 0x1E,  /**< Photo album slots the quest viewer reads. */
};

/**
 *
 * One of Donny's goods: an item and the level Donny has to be above to offer it.
 *
 */
struct DONY_SHOP_ITEM {
    s16 item_no; /**< Item offered, or a negative number to end the list. */
    s8 level;    /**< Donny's level has to be above this for the item to be offered. */
};

STATIC_ASSERT(sizeof(DONY_SHOP_ITEM) == 0x4);

/**
 *
 * What one item costs in a shop and what the shop pays for it.
 *
 */
struct SHOP_PRICE_INFO {
    s32 buy;  /**< Price the shop sells the item for. */
    s32 sell; /**< Price the shop pays for the item. */
};

STATIC_ASSERT(sizeof(SHOP_PRICE_INFO) == 0x8);

/**
 *
 * One shop's goods, how many of each the player holds and the price of every item,
 * read from the chapter's shop script.
 *
 */
class CShop {
public:
    s16 shop_id;                              /**< Number of the shop, whose entry is read from the shop script. */
    u8 unk_2[0x2];
    s32 item_num;                             /**< Number of goods on offer. */
    s32 item_no[SHOP_ITEM_MAX];               /**< Item number of each of the goods. */
    s32 have_num[SHOP_ITEM_MAX];              /**< Number of each of the goods the player already holds. */
    s32 once_item_chosen;                     /**< Set once item 0x1A7, sold one per visit, has been chosen; removes it from the goods. */
    SHOP_PRICE_INFO price[SHOP_PRICE_MAX];    /**< Buying and selling price of each item, by item number. */

    /**
     *
     * Creates a shop with no goods and no prices.
     *
     */
    CShop() { memset(this, 0, sizeof(CShop)); }

    /**
     *
     * Gives the item number of one of the goods, or 0 for a line past the goods.
     *
     */
    int GetItemNo(int no) {
        if (no < 0 || no >= item_num) {
            return 0;
        }
        return item_no[no];
    }

    /**
     *
     * Gives how many of one of the goods the player holds, or 0 for a line past the goods.
     *
     */
    int GetHaveNum(int no) {
        if (no < 0 || no >= item_num) {
            return 0;
        }
        return have_num[no];
    }

    /**
     *
     * Counts how many of each of the goods the player already holds.
     *
     * @mangled CheckSyojiHin__5CShopFv
     * @address 0x2952B0
     * @size 0x90
     */
    void CheckSyojiHin();

    /**
     *
     * Removes the goods the story does not offer yet or no longer offers, or fills
     * Donny's goods from his line-up.
     *
     * @mangled CheckEventItem__5CShopFv
     * @address 0x295370
     * @size 0x340
     */
    void CheckEventItem();

    /**
     *
     * Gives the price the shop sells an item for and the price it pays for it,
     * counting a weapon's level and a gift box's contents.
     *
     * @mangled GetPrice__5CShopFP13CGameDataUsedPiPi
     * @address 0x2956B0
     * @size 0x1F0
     */
    void GetPrice(CGameDataUsed *item, int *buy, int *sell);

    /**
     *
     * Gives how much of the shop's currency the player has.
     *
     * @mangled CheckMoney__5CShopFv
     * @address 0x2958A0
     * @size 0xA0
     */
    int CheckMoney();

    /**
     *
     * Adds an amount of the shop's currency to the player's, or takes it away when
     * negative; gives the player's new total.
     *
     * @mangled AddMoney__5CShopFi
     * @address 0x295940
     * @size 0xB0
     */
    int AddMoney(int money);

    /**
     *
     * Reads the shop's goods and prices from a shop script and works out which of
     * them are offered and held.
     *
     * @mangled AnalyzeShopList__5CShopFPci
     * @address 0x295C10
     * @size 0xA0
     */
    void AnalyzeShopList(char *script, int size);
};

STATIC_ASSERT(sizeof(CShop) == 0x120C);

/**
 *
 * Menu of a town shop, with the list of the shop's goods beside the player's bag.
 *
 */
class CShopMenu : public CBaseMenuClass {
public:
    CMenuPosDataForm *trade_brd;              /**< Board asking how many to buy or sell and showing the total ("売買ボード"). */
    CMenuPosDataForm *item_list;              /**< Scrolling list of the shop's goods ("品物リスト"). */
    CMenuPosDataForm *shop_name_brd;          /**< Board showing the shop's name ("店名ボード"). */
    CMenuPosDataForm *money_brd;              /**< Board showing the player's money ("moneybrd"). */
    CMenuPosDataForm *exp_brd;                /**< Board showing the robot's energy ("EXPBRD"). */
    CMenuPosDataForm *medal_brd;              /**< Board showing the player's medals ("MEDALBRD"). */
    float scrl_bar_step;                      /**< Distance the scroll bar moves for each line the list scrolls. */
    MENUFORMPARTS_TYPE *scrl_bar_top;         /**< Top end of the list's scroll bar ("b0"). */
    MENUFORMPARTS_TYPE *scrl_bar_body;        /**< Middle of the list's scroll bar, stretched to its length ("b1"). */
    MENUFORMPARTS_TYPE *scrl_bar_bottom;      /**< Bottom end of the list's scroll bar ("b2"). */
    CMenuPosDataForm *item_brd;               /**< Board framing the list of goods ("品物ボード"). */
    u_int *pack;                              /**< Contents of "shop.pac", the shop's textures, forms and messages. */
    s32 pack_size;                            /**< Size of "shop.pac", in bytes. */
    u_int se_handle;                          /**< Sound of a completed sale ("SP_042.snd"). */
    CGameDataUsed shop_item;                  /**< Goods under the list cursor, as an item the player could hold. */
    s32 bag_pos;                              /**< Bag slot under the cursor. */
    s32 bag_top;                              /**< First line of the bag shown. */
    s32 list_pos;                             /**< Line of the goods list under the cursor. */
    s32 list_top;                             /**< First line of the goods list shown. */
    s32 total;                                /**< Total price of the quantity being bought or sold. */
    s16 num_cursor;                           /**< Choice on the quantity board: 0 the quantity, 1 cancel. */
    s16 num;                                  /**< Quantity being bought or sold. */
    s16 num_max;                              /**< Largest quantity that can be bought or sold. */
    u8 unk_1ce[0x2];
    s32 arrow_flash[2];                       /**< Frames the quantity board's up and down arrows stay lit. */
    float list_x;                             /**< Screen position of the goods list's first line, horizontally. */
    float list_y;                             /**< Screen position of the goods list's first line, vertically. */
    s16 shop_name_ofs_x;                      /**< Half the width of the shop's name, to centre it on its board. */
    s16 shop_name_ofs_y;                      /**< Vertical offset of the shop's name on its board. */
    s16 price_mes_width;                      /**< Width of the window telling an item's selling price. */
    s16 unk_1e6;
    s16 no_price_mes_width;                   /**< Width of the window telling that the shop will not buy an item. */
    s16 unk_1ea;
    CScene::BGM_STATUS bgm_status;            /**< Music that was playing when the shop opened, restored when it closes. */
    s32 error;                                /**< Why the last purchase or sale was refused, a SHOP_MENU_ERROR. */
    u8 cursor_reset;                          /**< Non-zero to put the cursor onto its target at once. */
    u8 unk_20d[0x3];

    /**
     *
     * Creates the menu with every field cleared and the cursor ready to be put in place.
     *
     */
    CShopMenu() {
        list_pos = 0;
        list_top = 0;
        bag_pos = 0;
        bag_top = 0;
        key_arg_no = 0;
        num_cursor = 0;
        total = 0;
        cursor_reset = 1;
        error = -1;
        num = 0;
        num_max = 0;
        arrow_flash[0] = 0;
        arrow_flash[1] = 0;
        list_x = 0.0f;
        list_y = 0.0f;
        shop_name_ofs_x = 0;
        shop_name_ofs_y = 0;
        price_mes_width = 0;
        unk_1e6 = 0;
        no_price_mes_width = 0;
        unk_1ea = 0;
        scrl_bar_top = NULL;
        scrl_bar_body = NULL;
        scrl_bar_bottom = NULL;
        pack = NULL;
        pack_size = 0;
        se_handle = 0;
        trade_brd = NULL;
        item_list = NULL;
        shop_name_brd = NULL;
        money_brd = NULL;
        exp_brd = NULL;
        medal_brd = NULL;
        item_brd = NULL;
    }

    /**
     *
     * Finds the shop menu's boards in the loaded menu forms.
     *
     * @mangled AttachForm__9CShopMenuFv
     * @address 0x295CB0
     * @size 0xF0
     */
    void AttachForm();

    /**
     *
     * Puts back an item the player is carrying before the shop closes; gives non-zero
     * when the shop may close.
     *
     * @mangled IsCancelNoneLoadItem__9CShopMenuFv
     * @address 0x295DA0
     * @size 0x120
     */
    int IsCancelNoneLoadItem();

    /**
     *
     * Sizes the goods list's scroll bar to the number of goods.
     *
     * @mangled UpdataScrlBar__9CShopMenuFv
     * @address 0x295EC0
     * @size 0x100
     */
    void UpdataScrlBar();

    /**
     *
     * Loads the shop's goods, textures, forms, sounds and music once the menu has
     * faded in, and shows the shop's name.
     *
     * @mangled InitEnd__9CShopMenuFv
     * @address 0x295FC0
     * @size 0x3F0
     */
    virtual void InitEnd();

    /**
     *
     * Runs the shop for one frame: moves the cursors, buys and sells, and closes the
     * shop; gives non-zero once it has closed.
     *
     * @mangled KeyStep__9CShopMenuFv
     * @address 0x2963B0
     * @size 0x12F0
     */
    int KeyStep();

    /**
     *
     * Updates the boards' numbers, positions and colours and the price window for
     * the frame.
     *
     * @mangled CalcTex__9CShopMenuFv
     * @address 0x2976A0
     * @size 0x6E0
     */
    void CalcTex();

    /**
     *
     * Moves the menu cursor to the goods, bag slot or quantity choice it is on.
     *
     * @mangled CalcCursorPosition__9CShopMenuFv
     * @address 0x297D80
     * @size 0x190
     */
    void CalcCursorPosition();

    /**
     *
     * Gives the item under the cursor: the goods on the list's screens or the bag's
     * item on the bag's screens.
     *
     * @mangled SearchNowPosItemExist__9CShopMenuFv
     * @address 0x297F10
     * @size 0xE0
     */
    CGameDataUsed *SearchNowPosItemExist();
};

STATIC_ASSERT(sizeof(CShopMenu) == 0x210);

/**
 *
 * Menu listing the townspeople's requests or the photo scoops, with the
 * comment of the one chosen.
 *
 */
class CMenuQuestView : public CBaseMenuClass {
public:
    s32 select;                               /**< Line under the cursor. */
    s32 top;                                  /**< First line shown. */
    s32 photo_no[QUEST_VIEW_PHOTO_MAX];       /**< Photo held in each album slot, or -1 when the slot is empty. */

    /**
     *
     * Shows the help message along the bottom of the screen: 0 for the list, 1 for
     * a chosen entry's comment.
     *
     * @mangled UnderMsg__14CMenuQuestViewFi
     * @address 0x298AD0
     * @size 0xA0
     */
    void UnderMsg(int type);

    /**
     *
     * Gives the number of entries in the list.
     *
     * @mangled SelectMax__14CMenuQuestViewFv
     * @address 0x298B70
     * @size 0x30
     */
    int SelectMax();

    /**
     *
     * Loads the quest or scoop list, its messages and textures once the menu has
     * faded in, and fades the menu in.
     *
     * @mangled InitEnd__14CMenuQuestViewFv
     * @address 0x298BA0
     * @size 0x380
     */
    virtual void InitEnd();

    /**
     *
     * Runs the viewer for one frame: moves the cursor, opens and closes an entry's
     * comment, and closes the menu; gives non-zero once it has closed.
     *
     * @mangled KeyStep__14CMenuQuestViewFv
     * @address 0x298F20
     * @size 0x700
     */
    int KeyStep();
};

STATIC_ASSERT(sizeof(CMenuQuestView) == 0x190);

/**
 *
 * Lists the goods Donny offers at his level and has not given yet; gives how many
 * he offers and reports a DONY_SHOP_STATUS.
 *
 * @mangled GetDonyShopLineUp__FPiPi
 * @address 0x295160
 * @size 0x150
 */
int GetDonyShopLineUp(int *item_no, int *status);

/**
 *
 * Draws the shop's list of goods with the number held and the price of each.
 *
 * @mangled ShopSellListDraw__FRiPf
 * @address 0x297FF0
 * @size 0x5E0
 */
void ShopSellListDraw(int &tex_block, float *pos);

/**
 *
 * Opens the shop menu: creates the menu and the shop, keeps the music playing, and
 * loads the menu's forms and "shop.pac".
 *
 * @mangled MenuShopInit__FP9mgCMemoryPii
 * @address 0x2985D0
 * @size 0x4E0
 */
void MenuShopInit(mgCMemory *stack, int *tex_block, int mode);

/**
 *
 * Runs the shop menu for one frame; gives non-zero once it has closed.
 *
 * @mangled MenuShopKey__Fv
 * @address 0x298AB0
 * @size 0x10
 */
int MenuShopKey();

/**
 *
 * Draws the shop menu's forms.
 *
 * @mangled MenuShopDraw__Fv
 * @address 0x298AC0
 * @size 0x10
 */
void MenuShopDraw();

/**
 *
 * Opens the NPC quest viewer, showing the scoop memo when the argument is 1 and
 * the quest list otherwise.
 *
 * @mangled MenuNPCQuestViewInit__FP9mgCMemoryPii
 * @address 0x299620
 * @size 0x130
 */
void MenuNPCQuestViewInit(mgCMemory *stack, int *tex_block, int view_mode);

/**
 *
 * Runs the NPC quest viewer for one frame; gives non-zero once it has closed.
 *
 * @mangled MenuNPCQuestViewKey__Fv
 * @address 0x299750
 * @size 0x10
 */
int MenuNPCQuestViewKey();

/**
 *
 * Draws the NPC quest viewer: its backdrop, the list, the scroll bar, the cursor
 * and the chosen entry's comment.
 *
 * @mangled MenuNPCQuestViewDraw__Fv
 * @address 0x299760
 * @size 0xE70
 */
void MenuNPCQuestViewDraw();
