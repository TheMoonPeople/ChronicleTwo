#pragma once

#include "common.h"

/**
 * @file
 * Declares the menu system data kept in the save data: the cursor of each
 * menu list between visits and the record of Donny's goods already taken.
 */

/**
 *
 * Cursor of one menu list: the line selected and the first line shown.
 *
 */
struct MENU_SYSTEM_LIST_CURSOR {
    s16 select; /**< Line the cursor is on. */
    s16 top;    /**< First line shown. */
};

STATIC_ASSERT(sizeof(MENU_SYSTEM_LIST_CURSOR) == 0x4);

/**
 *
 * One of Donny's goods that the player has already taken.
 *
 */
struct MENU_SYSTEM_GHOBI {
    s16 item_no; /**< Item taken, or zero or less for an empty slot. */
    s16 unk_2;
};

STATIC_ASSERT(sizeof(MENU_SYSTEM_GHOBI) == 0x4);

/** Number of Donny's goods the menu system data can record. */
#define MENU_SYSTEM_GHOBI_NUM 32

/** Number of Georama menu pages whose list cursor is kept. */
#define MENU_SYSTEM_GEORAMA_LIST_NUM 7

/**
 *
 * Menu state kept in the save data so menus reopen where they were left.
 *
 */
class CMenuSystemData {
public:
    s16                     item_board_select; /**< Item under the cursor on the item menu's board. */
    s16                     item_board_top;    /**< Row of the item menu's board shown at the top. */
    s16                     unk_4;
    s16                     unk_6;
    s16                     item_key_arg_no; /**< Cursor layout in use when the item menu closed. */
    s16                     item_cursor;     /**< Cursor position within that layout when the item menu closed. */
    u8                      unk_c[0x14];
    MENU_SYSTEM_LIST_CURSOR invent_item; /**< Cursor of the invention menu's carried item list. */
    u8                      unk_24[0xA];
    s16                     invent_memo_sort_mode; /**< Value kept for the invention menu between visits. */
    MENU_SYSTEM_LIST_CURSOR invent_card;           /**< Cursor of the invention menu's card list. */
    MENU_SYSTEM_LIST_CURSOR invent_photo;          /**< Cursor of the invention menu's carried photo board. */
    MENU_SYSTEM_LIST_CURSOR invent_album;          /**< Cursor of the invention menu's album board. */
    MENU_SYSTEM_LIST_CURSOR invent_memo;           /**< Cursor of the invention menu's idea notebook. */
    u8                      unk_40[0x10];
    MENU_SYSTEM_LIST_CURSOR georama_list[MENU_SYSTEM_GEORAMA_LIST_NUM]; /**< Cursor of each Georama menu page's list. */
    u8                      unk_6c[0x21C];
    MENU_SYSTEM_GHOBI       ghobi[MENU_SYSTEM_GHOBI_NUM]; /**< Donny's goods already taken, filled from the front. */

    /**
     *
     * Creates the menu system data and clears it.
     *
     * @mangled __ct__15CMenuSystemDataFv
     * @address 0x2F62D0
     * @size 0x30
     */
    CMenuSystemData();

    /**
     *
     * Clears the leading status word of the menu system data.
     *
     * @mangled MenuSystemDataInit__15CMenuSystemDataFv
     * @address 0x2F6300
     * @size 0x10
     */
    void MenuSystemDataInit();

    /**
     *
     * Tells whether one of Donny's goods has already been taken; gives 1 if so, else 0.
     *
     * @mangled CheckGetAlready__15CMenuSystemDataFi
     * @address 0x2F6310
     * @size 0x40
     */
    int CheckGetAlready(int item_no);

    /**
     *
     * Records one of Donny's goods as taken in the first empty slot.
     *
     * @mangled GetGhobi__15CMenuSystemDataFi
     * @address 0x2F6350
     * @size 0x40
     */
    void GetGhobi(int item_no);
};

STATIC_ASSERT(sizeof(CMenuSystemData) == 0x308);
