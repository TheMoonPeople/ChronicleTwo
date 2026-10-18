#include "common.h"

#include "gamedata.hpp"
#include "mainloop.hpp"
#include "menuaqua.hpp"
#include "menucommon.hpp"
#include "menumain.hpp"
#include "menusys.hpp"
#include "nd_meswin.hpp"
#include "quick_loadout.hpp"
#include "snd_mngr.hpp"

// The item menu's "Equip Slot" command: on a weapon of Max or Monica or a Ridepod arm or leg part, it lists the quick
// loadout's four slots by their buttons, the two of the item's row to choose from and the other two greyed out, and
// puts the item in the one chosen. The commands' text is in message_text.cpp.

// menusys.cpp's own record of the chosen command, which ItemCmdAfter reads.
extern ITEMCMD_RET_PARA MenuItemCmdRet asm("QuickLoadout_ItemCmdRet");

namespace {

constexpr int kEquipSlotCommand = 90;
constexpr int kEquipSlotMessage = ITEM_MENU_COMMAND_MSG_BASE + kEquipSlotCommand;
// Square, Triangle, Cross, Circle: the panel's order (the messages are Triangle, Square, Cross, Circle).
constexpr int kSlotMessage[4] = {kEquipSlotMessage + 2, kEquipSlotMessage + 1, kEquipSlotMessage + 3,
                                 kEquipSlotMessage + 4};
constexpr int kCommandMax = 8;
constexpr u32 kColorEnabled = 0x80808080;
constexpr u32 kColorDisabled = 0x80202020; // retail's mark of a command that cannot be chosen

// The menu whose command list is showing the slots.
CBaseMenuClass *picking = nullptr;

bool Decide(int push_button) {
    // As MenuItemCommandSelect reads them: in the PAL languages only the decide button picks a command.
    if (LanguageCode > 0) {
        return push_button & MENU_PUSH_BUTTON_DECIDE;
    }
    return push_button & (MENU_PUSH_BUTTON_DECIDE | MENU_PUSH_BUTTON_TRIANGLE | MENU_PUSH_BUTTON_SQUARE);
}

void CloseList(CBaseMenuClass *menu, int se) {
    picking = nullptr;
    if (MenuCommonInfo->cursor_form != nullptr) {
        MenuCommonInfo->cursor_form->draw_flag = true;
    }
    menu->ask_para.form->draw_flag = false;
    menu->mode = MENU_ASK_MODE_NONE;
    // ItemCmdAfter plays the sound and has no command to run.
    MenuItemCmdRet.menu_cmd = -1;
    MenuItemCmdRet.se_no = se;
}

void ShowSlots(CBaseMenuClass *menu) {
    MENU_ASKMODE_PARA &ask = menu->ask_para;
    int                chara = 0;
    int                row = 0;
    PortQuickLoadoutTarget(ask.item, &chara, &row);
    int first = -1;
    for (int slot = 0; slot < 4; slot++) {
        const bool fits = slot / 2 == row;
        ask.cmd_msg[slot] = kSlotMessage[slot];
        ask.cmd_color[slot] = fits ? kColorEnabled : kColorDisabled;
        ask.cmd_mark[slot] = 0;
        if (fits && first < 0) {
            first = slot;
        }
    }
    ask.cmd_msg[4] = -1;
    ask.cmd_num = 4;

    CDC2Mes *message = MenuDCMsg[ask.mes_no];
    message->SetMsgItemNo(ask.cmd_msg, 5);
    message->MakeMsg(4);
    message->SetMsgCursor(first);
    message->rows = 4;
    for (int slot = 0; slot < 4; slot++) {
        message->line_shade[slot] = ask.cmd_color[slot] == kColorDisabled ? MES_SHADE_FAINT : MES_SHADE_AUTO;
    }
    picking = menu;
}

// The list of slots takes the keys while it shows; the item's own list only gives up its "Equip Slot" command.
bool SlotCommand(CBaseMenuClass *menu, int push_button) {
    CDC2Mes *message = MenuDCMsg[menu->ask_para.mes_no];
    if (message == nullptr || menu->ask_para.item == nullptr) {
        picking = nullptr;
        return false;
    }
    if (picking != menu || message->item_mes[0] != kSlotMessage[0]) {
        picking = nullptr;
        if (!Decide(push_button) || menu->ask_para.cmd_msg[message->GetMsgCursor()] != kEquipSlotMessage) {
            return false;
        }
        ShowSlots(menu);
        MenuSePlay(SYSTEM_SE_DECIDE);
        MenuItemCmdRet.menu_cmd = -2; // still choosing: ItemCmdAfter waits
        return true;
    }

    message->CommandMsgCursor();
    MenuItemCmdRet.menu_cmd = -2;
    if (Decide(push_button)) {
        const int slot = message->GetMsgCursor();
        if (slot < 0 || slot >= 4 || menu->ask_para.cmd_color[slot] == kColorDisabled ||
            !PortQuickLoadoutAssign(menu->ask_para.item, slot)) {
            MenuSePlay(SYSTEM_SE_DENIED);
            return true;
        }
        CloseList(menu, SYSTEM_SE_DECIDE);
    } else if (push_button & MENU_PUSH_BUTTON_CANCEL) {
        CloseList(menu, SYSTEM_SE_CANCEL);
    }
    return true;
}

} // namespace

PORT_OVERRIDE int GetItemCommandMsg(CGameDataUsed *item, MENU_ASKMODE_PARA *param, int place, int chara) {
    int num = GetItemCommandMsg(item, param->cmd_msg, param->cmd_color, param->cmd_shade, param->cmd_mark, place, chara);
    int owner = 0;
    int row = 0;
    if (num <= 0 || num >= kCommandMax - 1 || !PortQuickLoadoutTarget(item, &owner, &row) ||
        (place != MENU_SWAP_TYPE_ITEM_BOARD && place != MENU_SWAP_TYPE_EQUIP && place != MENU_SWAP_TYPE_ROBO_PART)) {
        return num;
    }
    // Right after the equip command, else last.
    int at = num;
    for (int i = 0; i < num; i++) {
        const int command = param->cmd_msg[i] - ITEM_MENU_COMMAND_MSG_BASE;
        if (command == ITEM_MENU_COMMAND_EQUIP || command == ITEM_MENU_COMMAND_EQUIP_RIDEPOD_PART ||
            command == ITEM_MENU_COMMAND_UNEQUIP) {
            at = i + 1;
            break;
        }
    }
    for (int i = num; i > at; i--) {
        param->cmd_msg[i] = param->cmd_msg[i - 1];
        param->cmd_color[i] = param->cmd_color[i - 1];
        param->cmd_shade[i] = param->cmd_shade[i - 1];
        param->cmd_mark[i] = param->cmd_mark[i - 1];
    }
    param->cmd_msg[at] = kEquipSlotMessage;
    param->cmd_color[at] = kColorEnabled;
    param->cmd_shade[at] = 0;
    param->cmd_mark[at] = 0;
    num++;
    param->cmd_msg[num] = -1;
    return num;
}

PORT_OVERRIDE int CBaseMenuClass::MenuItemCommandSelect(int select_key, int push_button) {
    if (step == 0 && mode == MENU_ASK_MODE_ITEM_COMMAND && SlotCommand(this, push_button)) {
        return 0;
    }
    if (picking == this) {
        picking = nullptr;
    }
    return PortRetailMenuItemCommandSelect(select_key, push_button);
}
