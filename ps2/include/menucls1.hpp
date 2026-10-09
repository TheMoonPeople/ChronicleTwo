#pragma once

#include "common.h"

#include "gamedata.hpp"
#include "mg_tanime.hpp"
#include "nd_meswin.hpp"
#include "userdata.hpp"

/**
 * @file
 * Declares the menus' shared helper classes: the menu font, the menu message window that
 * inserts item names and numbers into system messages and drives its choice cursor, the
 * carrier that animates items moving between two slots, and the item-use checker; plus the
 * full-width digit helpers and the "???" placeholder string the menus print with.
 */

class CMenuPosDataForm;

/**
 *
 * Choice a yes/no message window reports for the frame.
 *
 */
enum MesYesNoResult {
    MES_YESNO_NONE = 0, /**< Nothing decided yet. */
    MES_YESNO_YES = 1,  /**< The first choice was confirmed. */
    MES_YESNO_NO = 2,   /**< The second choice was confirmed, or the choice was cancelled. */
};

/**
 *
 * How a moved item is written into its destination slot when it arrives.
 *
 */
enum MenuMoveItemMode {
    MENU_MOVE_ITEM_COPY = 0,  /**< The carried item replaces the destination's contents. */
    MENU_MOVE_ITEM_STACK = 1, /**< The carried item is stacked onto, or swapped with, the destination's item. */
    MENU_MOVE_ITEM_ONE = 2,   /**< One unit of the item is carried and replaces the destination's contents. */
};

/**
 *
 * Font the menus draw text with: CFont with the menu's spacing, outline and colour.
 *
 */
class CMenuFont : public CFont {
public:
    /**
     *
     * Creates a font with the menu's character spacing, outline and text colour.
     *
     * @mangled __ct__9CMenuFontFv
     * @address 0x21EE20
     * @size 0x70
     */
    CMenuFont();
};

STATIC_ASSERT(sizeof(CMenuFont) == 0xB8);

/**
 *
 * Menu message window: a ClsMes that shows a system message, inserts item names and numbers
 * into it, keeps a choice cursor, and can be centred on screen or clipped to a rectangle.
 *
 */
class CDC2Mes : public ClsMes {
public:
    u8          msg_change;    /**< Non-zero when an inserted string or number changed, so the message is laid out again. */
    s8          cursor;        /**< Choice the cursor is on; -1 for none. */
    s16         text_off_x;    /**< Distance of the text from the fixed frame's left edge; negative to use the frame's margins. */
    s16         text_off_y;    /**< Distance of the text from the fixed frame's top edge; negative to use the frame's margins. */
    s16         mes_no;        /**< System message the window shows; -1 to show str. */
    u8          cursor_on;     /**< Non-zero to draw the choice cursor. */
    s8          put_centering; /**< Non-zero to centre the window horizontally on screen. */
    u8          scissor_on;    /**< Non-zero to clip the window to scissor. */
    u8          unk_2963[0xD];
    mgRect<int> scissor;   /**< Screen rectangle the window is clipped to. */
    char        str[0xC1]; /**< Text the window shows when mes_no is -1. */
    u8          unk_2a41[0xF];

    /**
     *
     * Creates a window with no message, no choice and the full-screen clip rectangle.
     *
     * @mangled __ct__7CDC2MesFv
     * @address 0x21F1E0
     * @size 0x90
     */
    CDC2Mes();

    /**
     *
     * Sets the system message file the item codes read from and the message file the window's
     * messages are read from.
     *
     * @mangled SetMessData__7CDC2MesFPsPs
     * @address 0x21F270
     * @size 0x40
     */
    void SetMessData(short *buff_system, short *buff);

    /**
     *
     * Resets the window and sets it up in one of the menus' window styles.
     *
     * @mangled MsgPreset__7CDC2MesFi
     * @address 0x21F2B0
     * @size 0x300
     */
    void MsgPreset(int preset);

    /**
     *
     * Resets the window to a menu window style, writing digits half-width in English.
     *
     * @mangled MsgPreset__7CDC2MesFii
     * @address 0x21F5B0
     * @size 0x40
     */
    void MsgPreset(int preset, int unused);

    /**
     *
     * Puts the choice cursor on a choice.
     *
     * @mangled SetMsgCursor__7CDC2MesFi
     * @address 0x21F5F0
     * @size 0x10
     */
    void SetMsgCursor(int choice);

    /**
     *
     * Moves the choice cursor up or down with the pad, playing the cursor sound when it moves.
     *
     * @mangled AddMsgCursor2__7CDC2MesFiii
     * @address 0x21F600
     * @size 0xB0
     */
    int AddMsgCursor2(int min, int max, int loop);

    /**
     *
     * Moves the choice cursor by a step, wrapping or stopping at the ends; gives back
     * non-zero when it moved.
     *
     * @mangled AddMsgCursor__7CDC2MesFiiii
     * @address 0x21F6B0
     * @size 0x70
     */
    int AddMsgCursor(int step, int min, int max, int loop);

    /**
     *
     * Moves the cursor over the command list the inserted messages make up, wrapping at the ends.
     *
     * @mangled CommandMsgCursor__7CDC2MesFv
     * @address 0x21F720
     * @size 0xD0
     */
    int CommandMsgCursor();

    /**
     *
     * Moves the cursor between the yes and no choices with left and right.
     *
     * @mangled YesNoCursor__7CDC2MesFv
     * @address 0x21F7F0
     * @size 0x90
     */
    int YesNoCursor();

    /**
     *
     * Moves the cursor between the yes and no choices and gives back the choice confirmed this
     * frame, a MesYesNoResult.
     *
     * @mangled YesNoCursor2__7CDC2MesFi
     * @address 0x21F880
     * @size 0xF0
     */
    int YesNoCursor2(int alt_button);

    /**
     *
     * Gives back the choice the cursor is on.
     *
     * @mangled GetMsgCursor__7CDC2MesFv
     * @address 0x21F970
     * @size 0x10
     */
    int GetMsgCursor();

    /**
     *
     * Gives back one of the system messages inserted into the message.
     *
     * @mangled GetMsgItemNo__7CDC2MesFi
     * @address 0x21F980
     * @size 0x10
     */
    int GetMsgItemNo(int index);

    /**
     *
     * Sets the colour the text starts in from its components.
     *
     * @mangled SetFontColor__7CDC2MesFiiii
     * @address 0x21F990
     * @size 0x20
     */
    void SetFontColor(int r, int g, int b, int a);

    /**
     *
     * Fixes the window's frame to a screen rectangle.
     *
     * @mangled SetPutPos__7CDC2MesFiiii
     * @address 0x21F9B0
     * @size 0x40
     */
    void SetPutPos(int x, int y, int w, int h);

    /**
     *
     * Fixes the window's frame to a screen position, given as x and y.
     *
     * @mangled SetPutPos__7CDC2MesFPi
     * @address 0x21F9F0
     * @size 0x70
     */
    void SetPutPos(int *pos);

    /**
     *
     * Forces the window into one of the screen slots, counting from one; zero to choose it.
     *
     * @mangled SetAbsPos__7CDC2MesFi
     * @address 0x21FA60
     * @size 0x10
     */
    void SetAbsPos(int pos);

    /**
     *
     * Gives back how wide a string of font numbers draws, never less than zero.
     *
     * @mangled GetStringDrawWidthDC__7CDC2MesFPc
     * @address 0x21FA70
     * @size 0x30
     */
    int GetStringDrawWidthDC(char *str);

    /**
     *
     * Places one line by itself, centred on a screen x.
     *
     * @mangled SetMovePosCenteringGyou__7CDC2MesFiii
     * @address 0x21FAA0
     * @size 0x50
     */
    void SetMovePosCenteringGyou(int line, int centre_x, int y);

    /**
     *
     * Sets the system messages inserted into the message; a negative entry ends the list.
     *
     * @mangled SetMsgItemNo__7CDC2MesFPii
     * @address 0x21FAF0
     * @size 0xD0
     */
    void SetMsgItemNo(int *messages, int count);

    /**
     *
     * Sets the strings inserted into the message; a NULL entry ends the list.
     *
     * @mangled SetMsgItemNo__7CDC2MesFPPci
     * @address 0x21FBC0
     * @size 0x170
     */
    void SetMsgItemNo(char **str, int count);

    /**
     *
     * Sets the numbers inserted into the message, unpadded.
     *
     * @mangled SetMsgVolumeNo__7CDC2MesFPii
     * @address 0x21FD30
     * @size 0x80
     */
    void SetMsgVolumeNo(int *numbers, int count);

    /**
     *
     * Sets the numbers inserted into the message and the digits each is padded to.
     *
     * @mangled SetMsgVolumeNo__7CDC2MesFPiPii
     * @address 0x21FDB0
     * @size 0x80
     */
    void SetMsgVolumeNo(int *numbers, int *digit_widths, int count);

    /**
     *
     * Sets the one number inserted into the message.
     *
     * @mangled SetMsgVolumeNoOne__7CDC2MesFi
     * @address 0x21FE30
     * @size 0x30
     */
    void SetMsgVolumeNoOne(int value);

    /**
     *
     * Places lines by themselves at screen positions, given as x and y pairs.
     *
     * @mangled SetMsgItemPos__7CDC2MesFPii
     * @address 0x21FE60
     * @size 0x70
     */
    void SetMsgItemPos(int *pos, int count);

    /**
     *
     * Shows a system message.
     *
     * @mangled MakeMsg__7CDC2MesFi
     * @address 0x21FED0
     * @size 0x10
     */
    void MakeMsg(int message_no);

    /**
     *
     * Shows a string of font numbers.
     *
     * @mangled MakeMsg__7CDC2MesFPc
     * @address 0x21FEE0
     * @size 0x30
     */
    void MakeMsg(char *text);

    /**
     *
     * Shows an item's description, with its added details inserted.
     *
     * @mangled MakeMsg__7CDC2MesFP13CGameDataUsed
     * @address 0x21FF10
     * @size 0x150
     */
    void MakeMsg(CGameDataUsed *item);

    /**
     *
     * Shows what using an item on a weapon would do: the fusion slots it takes and leaves, or
     * the weapon's name.
     *
     * @mangled MakeMsg__7CDC2MesFP13CGameDataUsedP13CGameDataUsed
     * @address 0x220060
     * @size 0x150
     */
    void MakeMsg(CGameDataUsed *attachment, CGameDataUsed *weapon);

    /**
     *
     * Lays the message out again when it changed and advances the window by a frame.
     *
     * @mangled StepMsg__7CDC2MesFv
     * @address 0x2201B0
     * @size 0xC0
     */
    void StepMsg();

    /**
     *
     * Draws the window, clipped and without the choice cursor as its flags ask.
     *
     * @mangled DrawMsg__7CDC2MesFv
     * @address 0x220270
     * @size 0xA0
     */
    void DrawMsg();

    /**
     *
     * Sets the alpha the whole window draws with, clamped to 0 to 0x80.
     *
     * @mangled SetMsgAlpha__7CDC2MesFi
     * @address 0x220310
     * @size 0x30
     */
    void SetMsgAlpha(int value);
};

STATIC_ASSERT(sizeof(CDC2Mes) == 0x2A50);

/**
 *
 * One item being carried from one slot to another by CMenuMoveItem.
 *
 */
struct MENU_ITEM_MOVE_INFO {
    u8             active; /**< Non-zero while the item is on its way. */
    u8             mode;   /**< How the item is written into dest on arrival, a MenuMoveItemMode. */
    u8             unk_2[2];
    CGameDataUsed *dest;    /**< Slot the item is written into on arrival. */
    CGameDataUsed  item;    /**< Item being carried. */
    s16            from[4]; /**< Slot the item comes from: kind, character, list and index. */
};

STATIC_ASSERT(sizeof(MENU_ITEM_MOVE_INFO) == 0x7C);

/**
 *
 * Animates up to two items moving between menu slots and writes each into its destination
 * when its form arrives.
 *
 */
class CMenuMoveItem {
public:
    s8                  move_on; /**< Non-zero while any item is moving. */
    CMenuPosDataForm   *form[2]; /**< Form each carried item is drawn with as it moves. */
    MENU_ITEM_MOVE_INFO info[2]; /**< Items being carried. */

    /**
     *
     * Creates the animator with nothing being carried.
     *
     */
    CMenuMoveItem() { Initialize(); }

    /**
     *
     * Clears both carried items and their forms.
     *
     * @mangled Initialize__13CMenuMoveItemFv
     * @address 0x220340
     * @size 0x80
     */
    void Initialize();

    /**
     *
     * Finds the "moveitem0" and "moveitem1" forms in the menu layout and hides them.
     *
     * @mangled AttachForm__13CMenuMoveItemFv
     * @address 0x2203C0
     * @size 0x90
     */
    void AttachForm();

    /**
     *
     * Writes each item whose form has arrived into its destination; gives back move_on.
     *
     * @mangled CheckMove__13CMenuMoveItemFv
     * @address 0x220450
     * @size 0x170
     */
    int CheckMove();

    /**
     *
     * Starts carrying an item in a free slot, moving its form from one screen position to
     * another.
     *
     * @mangled SetMoveItemInfo__13CMenuMoveItemFP19MENU_ITEM_MOVE_INFOPiPi
     * @address 0x2205C0
     * @size 0x180
     */
    void SetMoveItemInfo(MENU_ITEM_MOVE_INFO *request, int *start, int *goal);
};

STATIC_ASSERT(sizeof(CMenuMoveItem) == 0x104);

/**
 *
 * Checks whether items can be used on a target from the menus, and uses them.
 *
 */
class CMenuItemUse {
public:
    int item_no;     /**< Item last used. */
    int target_type; /**< Kind of target the item was last used on, an ITEM_USE_TARGET_TYPE. */
    u8  unk_8[0x10];
    s32 unk_18;

    /**
     *
     * Tells how many of an item's effects would act on a target, without using it.
     *
     * @mangled CheckItemUseEnable__12CMenuItemUseFP13CGameDataUsediPv
     * @address 0x2213A0
     * @size 0x60
     */
    int CheckItemUseEnable(CGameDataUsed *item, int kind, void *ptr);

    /**
     *
     * Uses an item on a target given by its kind and pointer.
     *
     * @mangled UseItem__12CMenuItemUseFP13CGameDataUsediPv
     * @address 0x221400
     * @size 0x80
     */
    int UseItem(CGameDataUsed *item, int kind, void *ptr);

    /**
     *
     * Uses an item on a target, recording both; gives back how many of its effects acted.
     *
     * @mangled UseItem__12CMenuItemUseFP13CGameDataUsedP14CItemUseTarget
     * @address 0x221480
     * @size 0x50
     */
    int UseItem(CGameDataUsed *item, CItemUseTarget *target);

    /**
     *
     * Clears the record of the last use.
     *
     * @mangled Initialize__12CMenuItemUseFv
     * @address 0x2214D0
     * @size 0x10
     */
    void Initialize();
};

STATIC_ASSERT(sizeof(CMenuItemUse) == 0x1C);

/**
 *
 * Gives back the placeholder shown for unknown names: full-width "???" in Japanese and
 * English, half-width in French, German, Italian and Spanish.
 *
 * @mangled GetHatena__Fv
 * @address 0x21EAD0
 * @size 0x70
 */
char *GetHatena();

/**
 *
 * Gives back the full-width digit string for the last digit of a number.
 *
 * @mangled GetMenuBigNum__Fi
 * @address 0x21EB40
 * @size 0x30
 */
char *GetMenuBigNum(int num);

/**
 *
 * Writes a number into a buffer in full-width digits.
 *
 * @mangled SetMenuBigNum2__FPci
 * @address 0x21EB70
 * @size 0x100
 */
void SetMenuBigNum2(char *out, int num);

/**
 *
 * Writes a number into a buffer in full-width digits, or in half-width ones in European
 * versions.
 *
 * @mangled SetMenuBigNum__FPci
 * @address 0x21EC70
 * @size 0x1B0
 */
void SetMenuBigNum(char *out, int num);

/**
 *
 * Resets a message window to the menus' defaults.
 *
 * @mangled MenuMesInit__FP6ClsMes
 * @address 0x21EE90
 * @size 0x350
 */
void MenuMesInit(ClsMes *mes);

/**
 *
 * Checks whether a shield kit can raise the ridepod's shield, raising it when @p use is
 * non-zero; gives back the sound to play, or -1.
 *
 * @mangled CheckRoboShieldKit__FP16CUserDataManagerP13CGameDataUsediPiPi
 * @address 0x220740
 * @size 0xD0
 */
int CheckRoboShieldKit(CUserDataManager *manager, CGameDataUsed *item, int apply, int *kit_count,
                       int *applied_count);

/**
 *
 * Tells how many of an item's effects would act on a target, or with @p use set to one applies
 * them and tells how many acted.
 *
 * @mangled MenuUseItemCheckFunc__FP13CGameDataUsedP14CItemUseTargeti
 * @address 0x220810
 * @size 0xB90
 */
int MenuUseItemCheckFunc(CGameDataUsed *item, CItemUseTarget *target, int use);

/**
 *
 * Tells how many of an item's effects would act on a target in the current state.
 *
 * @mangled CheckNowStateUseThisItem__FP13CGameDataUsedP14CItemUseTarget
 * @address 0x2214E0
 * @size 0x10
 */
int CheckNowStateUseThisItem(CGameDataUsed *item, CItemUseTarget *target);

/** Full-width digit strings, zero to nine. */
extern char *MenuBigNum[10];

/** Item the menus last checked or used. */
extern int MenuUsedItemNo;

/** Use flags of the item the menus last checked or used. */
extern u32 MenuUsedItemType;

/** One when the last check refused the item because of its target's condition, otherwise zero. */
extern int MenuUsedNotErrorCode;

/** Target the menus last used an item on. */
extern CItemUseTarget MenuUsedTarget;
