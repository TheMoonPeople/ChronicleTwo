#include "common.h"

#include "dngmenu.hpp"
#include "floor_monsters.hpp"
#include "mainloop.hpp"
#include "memcard.hpp"
#include "menumain.hpp"
#include "menuop.hpp"

extern CDngFreeMap  *TreeDngMap asm("MenuMouse_DngMap");
extern CMenuTreeMap *TreeMap asm("MenuMouse_Tree");
extern short         TreeMode asm("MenuMouse_TreeMode");

// Retail opens the floor map with no room under the cursor when the saved floor has no room cell and
// no floor is marked. Its step then reads the floor of that NULL cell (the debug flag editor at once,
// a directional key otherwise). On the PS2 that reads low RAM; natively it faults. Put the cursor on
// the entrance room, which is the floor retail's decide already falls back to with no selection.
PORT_OVERRIDE int DngTreeMapKey() {
    int result = 0;

    if (TreeMode == DNG_TREE_MODE_MAP) {
        if (TreeMap->select_glid == NULL && TreeMap->key_arg_no == DNG_TREE_MAP_SCREEN_MAP &&
            TreeMap->mode == MENU_ASK_MODE_NONE) {
            TreeMap->select_glid = TreeDngMap->GetEntranceRoomGlid();
        }

        result = TreeMap->Step();

        if (TreeMode == DNG_TREE_MODE_SAVE) {
            SetDngTreeFlag(1);
            SaveMapInfo(TreeDngMap->dng_no);
            NowProgramLoopNo = LOOP_DUNGEON;
            mgCMemory  save_stack;
            int        rest = MenuTreeMapStack.stGetRest();
            u_long128 *top = MenuTreeMapStack.stGetTop();
            save_stack.stSetBuffer(top, rest);
            MenuSaveInit(&save_stack, &TreeMap->tex_block[3], MENU_OPEN_SAVE);
        }
    } else if (TreeMode == DNG_TREE_MODE_SAVE) {
        result = MenuSaveKey();

        if (result != 0) {
            SetDngTreeFlag(0);
            TreeMode = DNG_TREE_MODE_MAP;
            result = 0;
            TreeMap->FadeInMenu(40, 0.0f);
            TreeMap->mode = MENU_ASK_MODE_EXTEND;
            TreeMap->step = 1;
            TreeMap->MsgInit();
        }
    }

    return result;
}

// The floor information's monster page (floor_monsters.cpp) reads the keys before retail's step, which has no keys
// for the page's screen, and changes the information's state once that step has run.
PORT_OVERRIDE int CMenuTreeMap::Step() {
    const auto action = floor_monsters::BeforeStep(*this);
    const int  result = PortRetailStep();
    floor_monsters::AfterStep(*this, action);
    return result;
}

// The monster page and the prompt leading to it draw over retail's map and information.
PORT_OVERRIDE void CMenuTreeMap::Draw() {
    PortRetailDraw();
    floor_monsters::Draw(*this);
}
