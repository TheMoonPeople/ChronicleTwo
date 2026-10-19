#!/usr/bin/env python3
"""Mirror ps2/include into the build with the header fixups the port compiles against, and fix unit copies.

    header_fixups.py <src_dir> <dst_dir> <stamp_file>
    header_fixups.py --unit <copy_path>

Every fixup's old text must occur exactly once in its file; anything else fails before a byte is written.
Headers are then passed through long64, because the PS2's `long` is 64-bit and Windows' is not.
"""

import argparse
import re
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from long64 import rewrite as rewrite_long64  # noqa: E402

LONG64_SUFFIXES = (".h", ".hpp", ".hh", ".inc", ".inl")

# MWCC accepts a `void` override of a base's `int` virtual and gives it a new vtable slot; clang rejects it.
# The PS2 vtables keep those separate slots, so making them overrides here is an accepted difference until
# rendering replaces these draws.
# COFF has no COMDAT-vs-strong resolution, so one out-of-line definition collides with every inline copy.
# ClsMes::Init is out-of-line only in dngmenu.cpp; making it inline everywhere leaves one definition.
# mgVu0FBOX is not trivially copyable, so memset on it trips -Wnontrivial-memcall.
FIXUPS = [
    # Paint colours close the menu into paint mode on the first visit as well as returned visits.
    ("editmenu.hpp", "        paint_top = 0;", "        paint_top = 0; paint_return = 1;"),
    ("dng_event.hpp", "    virtual void Draw();", "    virtual int Draw();"),
    # The monster scene slots end MONSTER_ACTIVE_MAX past their start, however many there are.
    ("dng_main.hpp", "    DNG_CHARA_SLOT_MONSTER = 24, /**< First slot of the MONSTER_ACTIVE_MAX active monsters. */",
     "    DNG_CHARA_SLOT_MONSTER = 24, /**< First slot of the MONSTER_ACTIVE_MAX active monsters. */"
     " DNG_CHARA_SLOT_MONSTER_END = DNG_CHARA_SLOT_MONSTER + MONSTER_ACTIVE_MAX,"),
    # A dungeon floor holds up to 60 monsters with game.more_monsters; the floors use retail's 24 slots otherwise.
    ("monster.hpp", "    MONSTER_ACTIVE_MAX = 24,", "    MONSTER_ACTIVE_MAX = 60,"),
    ("dng_hud.hpp", "    virtual void Draw();", "    virtual int Draw();"),
    # The quick loadout's "Equip Slot" command wraps the item command list; retail's routine stays under this name.
    ("menusys.hpp", "    int MenuItemCommandSelect(int select_key, int push_button);",
     "    int MenuItemCommandSelect(int select_key, int push_button);\n"
     "    int PortRetailMenuItemCommandSelect(int select_key, int push_button);"),
    # The floor information's monster page wraps the tree map's step and draw; retail's routines stay under these names.
    ("dngmenu.hpp", "    int FadeInOutMenu();",
     "    int FadeInOutMenu();\n"
     "    int PortRetailStep();\n"
     "    void PortRetailDraw();"),
    # The player's effects are tagged for the playerless pause picture around retail's draws, which stay under these names.
    ("actionchara.hpp", "    virtual void DrawEffect();", "    virtual void DrawEffect();\n    void PortRetailDrawEffect();"),
    # The recovery effect's sprite incarnations end with the effect, or with its manager, around retail's delete and
    # reset, which stay under these names.
    ("effscript.hpp", "    void Initialize(mgCMemory *memory, int texb_start, int texb_num);",
     "    void Initialize(mgCMemory *memory, int texb_start, int texb_num);\n"
     "    void PortRetailInitialize(mgCMemory *memory, int texb_start, int texb_num);"),
    ("effscript.hpp", "    void DeleteEffSpt(_EFF_SCRIPT *script);",
     "    void DeleteEffSpt(_EFF_SCRIPT *script);\n    void PortRetailDeleteEffSpt(_EFF_SCRIPT *script);"),
    ("dng_effect.hpp",
     "     * @mangled Draw__14CSwordLuminousFv\n     * @address 0x1C2E40\n     * @size 0x200\n     */\n    void Draw();",
     "     * @mangled Draw__14CSwordLuminousFv\n     * @address 0x1C2E40\n     * @size 0x200\n     */\n    void Draw();\n"
     "    void PortRetailDraw();"),
    ("dng_effect.hpp", "    void DrawWire(sceVu0FVECTOR *smooth);",
     "    void DrawWire(sceVu0FVECTOR *smooth);\n    void PortRetailDrawWire(float (*smooth)[4]);"),
    # The Item page's title is centred on the frame after retail's icon step, which stays under this name.
    ("menudraw.hpp", "    int StepMainMenuIconMove(int *icons, int select, int mode);",
     "    int StepMainMenuIconMove(int *icons, int select, int mode);\n"
     "    int PortRetailStepMainMenuIconMove(int *icons, int select, int mode);"),
    # A menu message window parked past the screen is clipped to it around retail's draw, which stays under this name.
    ("menucls1.hpp", "    void DrawMsg();",
     "    void DrawMsg();\n"
     "    void PortRetailDrawMsg();"),
    ("nd_meswin.hpp", "#ifndef MES_WINDOW_OUT_OF_LINE_INIT", "#if 1"),
    ("collision.hpp", "memset(&bbox, 0, sizeof(bbox));", "memset(static_cast<void *>(&bbox), 0, sizeof(bbox));"),
    # kernel32 exports these three names on Windows; the PS2 kernel's versions take their own link names so they never bind to kernel32.
    ("sce/eekernel.h", "int CreateThread(struct ThreadParam *param);", "int CreateThread(struct ThreadParam *param) __asm__(\"Ps2CreateThread\");"),
    ("sce/eekernel.h", "int TerminateThread(int thread_id);", "int TerminateThread(int thread_id) __asm__(\"Ps2TerminateThread\");"),
    ("sce/eekernel.h", "int GetThreadId(void);", "int GetThreadId(void) __asm__(\"Ps2GetThreadId\");"),
    # InventData's mgVu0FBOX makes the union's copy assignment deleted; MWCC generated the memberwise copy
    # GetLight and GetCharaLight assign with, so the mirror spells it out on the declaration's line.
    ("mapload.hpp", "    CFuncPoint() {}", '    CFuncPoint() {} CFuncPoint &operator=(CFuncPoint &other) { name = other.name; type = other.type; unk_8 = other.unk_8; flag_no = other.flag_no; enable = other.enable; start = other.start; end = other.end; __builtin_memcpy(static_cast<void *>(data), other.data, reinterpret_cast<char *>(&frame) - reinterpret_cast<char *>(data)); frame = other.frame; __builtin_memcpy(position, other.position, sizeof(position)); __builtin_memcpy(rotation, other.rotation, sizeof(rotation)); __builtin_memcpy(scale, other.scale, sizeof(scale)); active = other.active; return *this; }'),
    # A town's houses and the villagers a removal leaves homeless grow with its placed parts (port/src/editmap.cpp).
    ("editmap.hpp", "    CEditHouse                           house[EDIT_MAP_HOUSE_MAX];             /**< Houses that placed buildings give. */",
     "    CEditHouse                          *house;                                 /**< Houses that placed buildings give. */"),
    ("editmap.hpp", "        s32  house_npc[EDIT_REMOVE_HOUSE_MAX];   /**< Villagers whose house was removed. */",
     "        s32 *house_npc;                          /**< Villagers whose house was removed. */"),
    # Clearing a town also clears its extra model heaps around retail's clear, which stays under this name.
    ("editmap.hpp", "    void ClearAllParts();", "    void ClearAllParts();\n    void PortRetailClearAllParts();"),
    # Luau runs the scripts that have modules; the interpreter's own entry points stay under these names for the rest.
    ("runscript.hpp", "    void exe(vmcode_t *entry);",
     "    void exe(vmcode_t *entry);\n"
     "    void PortRetailDeleteProgram();\n"
     "    void PortRetailLoad(RS_PROG_HEADER *program, RS_STACKDATA *values, int value_count, RS_CALLDATA *calls, int call_count);\n"
     "    void PortRetailResume();\n"
     "    int  PortRetailRun(int no);\n"
     "    void PortRetailSkip();"),
    # Collision polygons name placed Georama parts beyond slot 4095.
    ("collision.hpp", "    CCPOLY_PARTS_EDIT = 0x1000,     /**< The polygon belongs to a placed Georama part. */",
     "    CCPOLY_PARTS_EDIT = 0x8000,     /**< The polygon belongs to a placed Georama part. */"),
    ("collision.hpp", "    CCPOLY_PARTS_SLOT_MASK = 0xFFF, /**< Placed-part slot of such a polygon. */",
     "    CCPOLY_PARTS_SLOT_MASK = 0x7FFF, /**< Placed-part slot of such a polygon. */"),
    # The Georama menu's placed-part lists live in host vectors sized to the town (port/src/editmenu.cpp).
    ("editmenu.hpp", "    s32                     place_no[GEORAMA_PARTS_LIST_MAX];         /**< Number of every placed part of the town. */",
     "    s32                    *place_no;                                 /**< Number of every placed part of the town. */"),
    ("editmenu.hpp", "    char                    place_name[GEORAMA_PARTS_LIST_MAX][0x40]; /**< Name of each part of place_no. */",
     "    char (*place_name)[0x40];                                         /**< Name of each part of place_no. */"),
    ("editmenu.hpp", "    GEORAMA_PARTS_LIST_ITEM placed_list[GEORAMA_PARTS_LIST_MAX];      /**< Every placed part, for GEORAMA_VIEW_PLACED. */",
     "    GEORAMA_PARTS_LIST_ITEM *placed_list;                             /**< Every placed part, for GEORAMA_VIEW_PLACED. */"),
    ("editmenu.hpp", "    GEORAMA_PARTS_LIST_ITEM house_list[GEORAMA_PARTS_LIST_MAX];       /**< Placed houses, for GEORAMA_VIEW_CHECK_POINT. */",
     "    GEORAMA_PARTS_LIST_ITEM *house_list;                              /**< Placed houses, for GEORAMA_VIEW_CHECK_POINT. */"),
    ("editmenu.hpp", "        memset(place_no, 0, sizeof(place_no));", "        place_no = NULL;"),
    ("editmenu.hpp", "        memset(place_name, 0, sizeof(place_name));", "        place_name = NULL;"),
    ("editmenu.hpp", "        memset(placed_list, 0, sizeof(placed_list));", "        placed_list = NULL;"),
    ("editmenu.hpp", "        memset(house_list, 0, sizeof(house_list));", "        house_list = NULL;"),
]

# Copies of each Georama part definition a town may place: the limit of a held part count (SAVE_BUILD_PARTS_NUM_MAX).
GEORAMA_PARTS_MAX_NUM = 9999

# Each packet a frame sorts takes one mgSORT_PACKET (one quadword on the PS2) from the scene's work stack, along with
# its slot in the draw manager's pointer tables. Both grow with pointer width, so the work stacks scale with them.
WORK_STACK_QUADWORDS = "10000 * (int) sizeof(mgSORT_PACKET) / 16"

# Quadwords added to each character model stack. Host model and metadata records outgrow retail's counts: with a
# datapack, Max's body exceeds the 68500 quadwords of human stack 0 on entering a dungeon.
CHARA_MODEL_STACK_EXTRA = 12000

# The leading newline anchors each match to its line start: a copy already rewritten fails the exactly-once check
# instead of gaining a second `inline`.
# COFF has no inline-vs-strong resolution: map.cpp's out-of-line CMapParts::CMapParts is the single definition,
# so the identical inline copies in editeff.cpp/editmap.cpp are blanked rather than kept.
UNIT_FIXUPS = [
    # The native texture-copy prelude includes host stdlib.h, which declares random().
    ("password.cpp", "static unsigned int random() {", "static unsigned int PortPasswordRandom() {"),
    # Replace party-ring palette copies with independently registered RGBA pixels.
    ("menuchr.cpp", """    MenuCharaChangeCLUT = palette.clut;
    tex_manager->ReloadTexture(block, (sceVif1Packet *) NULL);

    if (MenuCharaChangeCLUT_Tex == NULL) {
        MenuCharaChangeCLUT_Tex = new (MenuChangeMemory.Alloc(9)) mgCTexture;
    }

    memcpy(MenuCharaChangeCLUT_Tex, MenuCharaChangeBase_Tex, sizeof(mgCTexture));
    memcpy(MenuCharaChangeCLUT, MenuCharaChangeBase_Tex->clut, sizeof(palette.clut));
    MenuCharaChangeCLUT_Tex->clut = (u_long128 *) MenuCharaChangeCLUT;

    // Darken the copied palette into brightness bands, keeping each colour's alpha.
    for (palette_index = 0, color = MenuCharaChangeCLUT; palette_index < CHR_CNG_CLUT_NUM; palette_index++, color++) {
        float luminance = (float) ((color->r + color->g + color->b) / 3);
        int   step = 1;

        do {
            if (8.0f * (float) (step - 1) <= luminance && luminance < 8.0f * (float) step) {
                break;
            }

            step++;
        } while (step < CHR_CNG_CLUT_BAND_NUM + 1);

        color->r = (u8) (7.75f * (float) step);
        color->g = (u8) (5.625f * (float) step);
        color->b = (u8) (4.6875f * (float) step);
    }
""", """    MenuCharaChangeCLUT_Tex = MgTextureCreateColorVariant(MenuCharaChangeBase_Tex,
        const_cast<char *>("party_locked"), MgTextureColorMode::PartyLocked);
    MgTextureSetDrawVariant(MenuCharaChangeBase_Tex, nullptr);
    tex_manager->ReloadTexture(block, (sceVif1Packet *) NULL);
"""),
    # Emit the constructor from the native unit without changing its retail inline spelling.
    ("inventmn.cpp", "\ninline CMenuInvent::CMenuInvent() {", "\nCMenuInvent::CMenuInvent() {"),
    # game.skip_intro: the boot's language select and title image load stay; the logo's fade frames are skipped.
    ("nowload.cpp", "    for (; frame <= 22; ++frame, opacity_value += 128) {",
     "    for (; frame <= 22 && !PortSkipIntro(); ++frame, opacity_value += 128) {"),
    ("editeff.cpp", "\ninline CMapParts::CMapParts() { Initialize(); }", "\n"),
    ("editmap.cpp", "\ninline CMapParts::CMapParts() { Initialize(); }", "\n"),
    # PAL's op_cursorlimmit bottom (y 274) lies above the ninth shown row (288); the Options cursor's bottom limit
    # reaches the selected row's place in the settled list instead.
    ("menuop.cpp", '                MenuPosData->GetEtcTblValue("op_cursorlimmit", limit[0], limit[1]);',
     '                MenuPosData->GetEtcTblValue("op_cursorlimmit", limit[0], limit[1]); '
     'if (LocalMenuBGForm != NULL) { int base[2]; LocalMenuBGForm->GetPutPosXY("base_msg", base[0], base[1]); '
     'limit[1] = PortOptionCursorBottom(limit[1], pos.y, fptosi(list_y - 3.0f), base[1] - top * 24 - 3); }'),
    # MenuManualInit fills five 10-row Help columns (entries 0-49) from the 47-entry manual_boot_event_no.
    # Retail reads its padding and the next table there. That read is undefined in C++, and at -O3 clang drops
    # the last column's loop exit and writes past its window. Entries 47-49 have no event flag, so they stay locked.
    ("menuop.cpp", "static short manual_boot_event_no[47] = {", "static short manual_boot_event_no[50] = {"),
    ("menuop.cpp", "SAVE_FLAG_FINNY_FRENZY_UNLOCKED, SAVE_FLAG_FINNY_FRENZY_UNLOCKED, -1};",
     "SAVE_FLAG_FINNY_FRENZY_UNLOCKED, SAVE_FLAG_FINNY_FRENZY_UNLOCKED, -1, -1, -1, -1};"),
    # The floor list's debug panel (R3 with DebugFlag) prints a room's four next-floor IDs into its line; one-digit IDs
    # already need 33 bytes. FONT_STR_MAX, SetStr's own limit, holds any four IDs and the terminator.
    ("dngmenu.cpp", "                char line[32];", "                char line[FONT_STR_MAX];"),
    # Fusion colours can target a float-aligned ambient field rather than a quadword boundary.
    ("menusys.cpp", "*(u_long128 *) color = *(u_long128 *) fusion_ambient;",
     "memcpy(color, fusion_ambient, sizeof(fusion_ambient));"),
    ("dng_debug.cpp", "\nvoid CTreasureBox::Initialize() {", "\ninline void CTreasureBox::Initialize() {"),
    # The dungeon menu carves its memory from these 200000 quadwords and gives the invention menu's
    # model reads (LOAD STACK) whatever is left. Host objects are larger than retail's, so with Max's
    # largest outfit (the Explorer's set) the reads overran it. Give the menu 60000 more quadwords.
    ("dng_main.cpp", "BuffReadData = MainBuffer->stAlloc64(200000);",
     "BuffReadData = MainBuffer->stAlloc64(260000);"),
    ("dng_main.cpp", "\n                stack.stSetBuffer(BuffReadData, 200000);",
     "\n                stack.stSetBuffer(BuffReadData, 260000);"),
    ("dng_main.cpp", "BuffWorkData.stSetBuffer(MainBuffer->stAlloc64(10000), 10000);",
     f"BuffWorkData.stSetBuffer(MainBuffer->stAlloc64({WORK_STACK_QUADWORDS}), {WORK_STACK_QUADWORDS});"),
    # The town menu's buffer, carved from the end of the main stack after the total data buffer, needs
    # the same 60000 quadwords for the invention menu's model reads. The work stack follows it.
    ("editloop.cpp", """    TotalDataBuff.stSetBuffer(&main_stack->stack[main_stack->stack_used], data_size - 210128);
    printf("data memory size = %d kbyte", (data_size - 210128) * 16 / 1024);""",
     f"""    TotalDataBuff.stSetBuffer(&main_stack->stack[main_stack->stack_used], data_size - (260128 + {WORK_STACK_QUADWORDS}));
    printf("data memory size = %d kbyte", (data_size - (260128 + {WORK_STACK_QUADWORDS})) * 16 / 1024);"""),
    # The model stacks of every character layout: human 0-1, ridepod 0-2, edit 0 and monster 0.
    ("charasetup.cpp", "    {68500,  40000, 7000,",
     f"    {{68500 + {CHARA_MODEL_STACK_EXTRA},  40000 + {CHARA_MODEL_STACK_EXTRA}, 7000,"),
    ("charasetup.cpp", "    {30000,  30000, 60000, 10000,",
     f"    {{30000 + {CHARA_MODEL_STACK_EXTRA},  30000 + {CHARA_MODEL_STACK_EXTRA}, "
     f"60000 + {CHARA_MODEL_STACK_EXTRA}, 10000,"),
    ("charasetup.cpp", "    {75000,  40000,", f"    {{75000 + {CHARA_MODEL_STACK_EXTRA},  40000,"),
    ("charasetup.cpp", "    {120000, 0,", f"    {{120000 + {CHARA_MODEL_STACK_EXTRA}, 0,"),
    # Each floor reads game.more_monsters once; spawns, free slots and the slots' script memory keep to its limit.
    ("monster.cpp", "    priority_limit = 5;", "    priority_limit = PortMonsterLatchLimits();"),
    # The monster slots reach into the sub-game slots, which InitDungeonMain clears after binding the monsters.
    ("subgame.cpp", "            scene->DeleteChara(j + SUBGAME_CHARA_BASE);",
     "            if (scene->GetType(SCENE_DATA_CHARA, j + SUBGAME_CHARA_BASE) != SCENE_CHARA_TYPE_MONSTER) scene->DeleteChara(j + SUBGAME_CHARA_BASE);"),
    ("monster.cpp", "    for (slot = 0; slot < MONSTER_ACTIVE_MAX; slot++) {\n        monster = active[slot];",
     "    for (slot = 0; slot < PortMonsterActiveLimit(); slot++) {\n        monster = active[slot];"),
    ("dng_event.cpp", "        if (spawn_count > MONSTER_ACTIVE_MAX) {\n            spawn_count = MONSTER_ACTIVE_MAX;",
     "        if (spawn_count > PortMonsterActiveLimit()) {\n            spawn_count = PortMonsterActiveLimit();"),
    ("event_func.cpp", "    for (j = 0; j < MONSTER_ACTIVE_MAX; j++) {\n        u_long128 *buffer = monster_stack->stAlloc64(0xFA0);",
     "    for (j = 0; j < PortMonsterActiveLimit(); j++) {\n        u_long128 *buffer = monster_stack->stAlloc64(0xFA0);"),
    # Monster scene slots start at DNG_CHARA_SLOT_MONSTER rather than at MONSTER_ACTIVE_MAX, which grows above.
    ("actionchara.cpp", "            if (index >= MONSTER_ACTIVE_MAX * 2) {\n                index = MONSTER_ACTIVE_MAX;",
     "            if (index >= DNG_CHARA_SLOT_MONSTER_END) {\n                index = DNG_CHARA_SLOT_MONSTER;"),
    ("actionchara.cpp", "GetCharacter(tries + MONSTER_ACTIVE_MAX)", "GetCharacter(DNG_CHARA_SLOT_MONSTER + tries)"),
    ("actionchara.cpp", "return tries + MONSTER_ACTIVE_MAX;", "return DNG_CHARA_SLOT_MONSTER + tries;"),
    ("actionchara.cpp", "GetCharacter(i + MONSTER_ACTIVE_MAX)", "GetCharacter(DNG_CHARA_SLOT_MONSTER + i)"),
    ("actionchara.cpp", "return best + MONSTER_ACTIVE_MAX;", "return DNG_CHARA_SLOT_MONSTER + best;"),
    ("actionchara.cpp", "return ids[rank] + MONSTER_ACTIVE_MAX;", "return DNG_CHARA_SLOT_MONSTER + ids[rank];"),
    ("actionchara.cpp", "for (index = MONSTER_ACTIVE_MAX; index < MONSTER_ACTIVE_MAX * 2; index++)",
     "for (index = DNG_CHARA_SLOT_MONSTER; index < DNG_CHARA_SLOT_MONSTER_END; index++)"),
    ("actionchara.cpp", "target_no = MONSTER_ACTIVE_MAX;\n                } else {",
     "target_no = DNG_CHARA_SLOT_MONSTER;\n                } else {"),
    ("actionchara.cpp", "if (target_no >= MONSTER_ACTIVE_MAX * 2) {\n                    target_no = MONSTER_ACTIVE_MAX;",
     "if (target_no >= DNG_CHARA_SLOT_MONSTER_END) {\n                    target_no = DNG_CHARA_SLOT_MONSTER;"),
    ("actionchara.cpp", "target_no = MONSTER_ACTIVE_MAX;", "target_no = DNG_CHARA_SLOT_MONSTER;"),
    ("actionchara.cpp", "target_no - MONSTER_ACTIVE_MAX;", "target_no - DNG_CHARA_SLOT_MONSTER;"),
    ("actscript.cpp", "int chara_no = MONSTER_ACTIVE_MAX;", "int chara_no = DNG_CHARA_SLOT_MONSTER;"),
    ("actscript.cpp", "chara_no <= MONSTER_ACTIVE_MAX * 2 - 1", "chara_no < DNG_CHARA_SLOT_MONSTER_END"),
    ("monster.cpp", "GetCharacter(i + MONSTER_ACTIVE_MAX)", "GetCharacter(DNG_CHARA_SLOT_MONSTER + i)"),
    ("monster.cpp", "GetCharacter(slot + MONSTER_ACTIVE_MAX)", "GetCharacter(DNG_CHARA_SLOT_MONSTER + slot)"),
    ("monster.cpp", "chara_type = slot + MONSTER_ACTIVE_MAX;", "chara_type = DNG_CHARA_SLOT_MONSTER + slot;"),
    ("monster.cpp", "if (i + MONSTER_ACTIVE_MAX == target_no)", "if (DNG_CHARA_SLOT_MONSTER + i == target_no)"),
    ("monster.cpp", "*slot = i + MONSTER_ACTIVE_MAX;", "*slot = DNG_CHARA_SLOT_MONSTER + i;"),
    ("monster.cpp", "CheckHit(i + MONSTER_ACTIVE_MAX)", "CheckHit(DNG_CHARA_SLOT_MONSTER + i)"),
    ("monster.cpp", "target_no == i + MONSTER_ACTIVE_MAX)", "target_no == DNG_CHARA_SLOT_MONSTER + i)"),
    # Geostone announcement updates and draws reserve eight nullable message slots.
    ("editmenu.cpp", "static CDC2Mes *DownLoadMes[6];", "static CDC2Mes *DownLoadMes[8];"),
    # A Georama list that fits on one page has no scroll range: the EE FPU's 0/0 is finite, IEEE's is NaN.
    ("editmenu.cpp", "            float rate = space / (num - GEORAMA_LIST_LINE_NUM);",
     "            float rate = num > GEORAMA_LIST_LINE_NUM ? space / (num - GEORAMA_LIST_LINE_NUM) : 0.0f;"),
    # Geostone conditions are copied bounded into their 128-byte text, and word-wrapped into 128 bytes
    # rather than 64: wrapping replaces a space with a newline, so the result is never longer.
    ("editmenu.cpp", "            strcpy(text, condition_name);",
     "            snprintf(text, sizeof(text), \"%s\", condition_name);"),
    ("editmenu.cpp", "            char        *wrapped = (char *) stack->Alloc(4);",
     "            char        *wrapped = (char *) stack->Alloc(8);"),
    ("editloop.cpp", """    main_stack->Alloc(data_size - 210128);
    MenuBuffer__2.stSetBuffer(read_buffer = main_stack->stAlloc64(200000), 200000);
    read_buffer_end = read_buffer + 200000;
    WorkBuffer.stSetBuffer(main_stack->stAlloc64(10000), 10000);""",
     f"""    main_stack->Alloc(data_size - (260128 + {WORK_STACK_QUADWORDS}));
    MenuBuffer__2.stSetBuffer(read_buffer = main_stack->stAlloc64(260000), 260000);
    read_buffer_end = read_buffer + 260000;
    WorkBuffer.stSetBuffer(main_stack->stAlloc64({WORK_STACK_QUADWORDS}), {WORK_STACK_QUADWORDS});"""),
    # Map files are read into a buffer sized to them rather than the caller's fixed one.
    ("sceneload.cpp", "    u8        *load_buf = info.load_buf;", "    u8        *load_buf = PortMapLoadBuffer(info);"),
    # Every Georama part definition may be placed as often as the player can hold it.
    ("editinfo.cpp", "    emapNowInfo->max_num = spiGetStackInt(stack);",
     f"    emapNowInfo->max_num = {GEORAMA_PARTS_MAX_NUM};"),
    # The build menu quadruples a map-wide part's limit in an s16 before clamping it to 99; clamping first keeps every
    # retail result without overflowing the lifted limit.
    ("editmenu.cpp", "                        menu->make_num_max = (short) menu->make_parts->max_num;",
     "                        menu->make_num_max = (short) (menu->make_parts->max_num < 99 ? menu->make_parts->max_num : 99);"),
    # Towns have no polygon budget, so every Georama menu hides the polygon counter as retail's fifth town does.
    ("editmenu.cpp", "    if (town_no == 4) {\n        ExeScript(\"POLYOF\");", "    if (true) {\n        ExeScript(\"POLYOF\");"),
]

# MWCC-only pragmas. ct_port builds with -Wall and no -Wno-unknown-pragmas, so they are blanked, not silenced.
MWCC_PRAGMA = re.compile(r"[ \t]*#[ \t]*pragma[ \t]+(?:cpp_extensions\b.*|push|pop)[ \t]*")


def neutralise_mwcc_pragmas(text: str) -> str:
    lines = text.split("\n")
    for i, line in enumerate(lines):
        body = line.rstrip("\r")
        if MWCC_PRAGMA.fullmatch(body):
            lines[i] = line[len(body):]
    return "\n".join(lines)


def build_mirror(src: Path) -> dict[str, bytes]:
    files = {}
    for path in sorted(p for p in src.rglob("*") if p.is_file()):
        files[path.relative_to(src).as_posix()] = path.read_bytes()

    for rel, old, new in FIXUPS:
        if rel not in files:
            sys.exit(f"header_fixups: {rel} is not under {src}; its fixup has no target")
        data = files[rel]
        count = data.count(old.encode())
        if count != 1:
            sys.exit(f"header_fixups: {rel} has {count} occurrences of {old!r}, expected exactly 1")
        files[rel] = data.replace(old.encode(), new.encode())

    for rel, data in files.items():
        if rel.endswith(LONG64_SUFFIXES):
            text = neutralise_mwcc_pragmas(data.decode("latin-1"))
            rewritten = rewrite_long64(text).encode("latin-1")
            if rewritten.count(b"\n") != data.count(b"\n"):
                sys.exit(f"header_fixups: {rel} changed its line count")
            files[rel] = rewritten
    return files


def write_mirror(dst: Path, files: dict[str, bytes]) -> None:
    dst.mkdir(parents=True, exist_ok=True)
    for rel, data in files.items():
        out = dst / rel
        if out.is_file() and out.read_bytes() == data:
            continue
        out.parent.mkdir(parents=True, exist_ok=True)
        out.write_bytes(data)

    for path in sorted((p for p in dst.rglob("*") if p.is_file()), reverse=True):
        if path.relative_to(dst).as_posix() not in files:
            path.unlink()
    for path in sorted((p for p in dst.rglob("*") if p.is_dir()), reverse=True):
        if not any(path.iterdir()):
            path.rmdir()


def fixup_unit_text(name: str, text: str) -> str:
    for unit, old, new in UNIT_FIXUPS:
        if unit != name:
            continue
        count = text.count(old)
        if count != 1:
            sys.exit(f"header_fixups: {name} has {count} occurrences of {old!r}, expected exactly 1")
        # Keep diagnostics and debug locations aligned with the retail source.
        replacement = new + "\n" * max(0, old.count("\n") - new.count("\n"))
        text = text.replace(old, replacement)
    if name == "password.cpp":
        text = text.replace("random()", "PortPasswordRandom()")
    return text


def fixup_unit(copy: Path) -> None:
    if not copy.is_file():
        sys.exit(f"header_fixups: {copy} is not a file")

    data = copy.read_bytes()
    fixed = fixup_unit_text(copy.name, data.decode("latin-1")).encode("latin-1")
    if fixed != data:
        copy.write_bytes(fixed)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--unit", type=Path, metavar="COPY")
    parser.add_argument("src_dir", nargs="?", type=Path)
    parser.add_argument("dst_dir", nargs="?", type=Path)
    parser.add_argument("stamp_file", nargs="?", type=Path)
    args = parser.parse_args()

    if args.unit is not None:
        if any(arg is not None for arg in (args.src_dir, args.dst_dir, args.stamp_file)):
            parser.error("--unit takes no other arguments")
        fixup_unit(args.unit)
        return

    if any(arg is None for arg in (args.src_dir, args.dst_dir, args.stamp_file)):
        parser.error("expected <src_dir> <dst_dir> <stamp_file>, or --unit <copy_path>")
    if not args.src_dir.is_dir():
        sys.exit(f"header_fixups: {args.src_dir} is not a directory")

    write_mirror(args.dst_dir, build_mirror(args.src_dir))
    args.stamp_file.parent.mkdir(parents=True, exist_ok=True)
    args.stamp_file.touch()


if __name__ == "__main__":
    main()
