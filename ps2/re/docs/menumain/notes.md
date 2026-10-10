# menumain: reverse-engineering notes

Main menu driver: opens the menu for a game loop (`MenuMainInit`), runs/draws the active mode
through `menu_keyfunctbl`/`menu_drawfunctbl`, the top icon menu (`CMenuInter`), area/time boards,
the scrolling "topic" ticker, and closes (`MenuMainExit`). No first-game counterpart exists for
`CMenuInter`, `MENU_INIT_ARG` or the menu-mode tables (chronicle has no `menumain`).

## Local (static) symbols -> belong in the .cpp, not the header
Functions: `DisablePadReset`, `MenuWorldTrans`, `MenuPolygonSetEnv`, `MenuPolygonEnvReset`,
`CheckEventDay`, `MakeMenuTopic`, `DrawMenuTopic`, `MenuInternInit`, `MenuInternSelectKey`,
`MenuInternSelectDraw`, `MenuDebugModeDraw`.
Data: `light_1062`, `lightcolor_1063` (function-local float[4][4] in MenuMainInit),
`menu_keyfunctbl` (int(*[30])()), `menu_drawfunctbl` (void(*[30])()), `menu_basedgRef`,
`menu_basedgCamPos` (sceVu0FVECTOR; (0,0,-100,1) ref), `CommonMenuModeID` (int[2][8], -1
terminated: town {2,4,5,6,7,8}, dungeon {2,4,5,11,7,8}), `menu_maintopic_colortbl[_shadow]`
(float[4][4] RGBA), `topic_tbl_1777` (char*[7][3] by [lang][type]), `filetbl_2141` (char*[17],
indexed by mode-2: itemmn0.pac, "", chrchg0.pac, inv2_bg.pac, "", op1.pac, manual1.pac, ""...),
`monster_table` ({s16 monster, s16 item}[10] + pad), `MenuPrim` (= &MenuPrimFix),
`MenuTopicAlpha` (int, init 0x80), `MenuMainSubDataPackAdr`, `CMenuInterPt` (CMenuInter*),
`MenuInterMes` (CDC2Mes*), `MenuInterMesDrawFlag` (s8), `MenuAreaBrdForm`/`MenuTimeBrdForm`
(CMenuPosDataForm*; forms "areaboard"/"timeboard"), `MenuAreaName` (char*), `SndPortVol_Enemy`
(float), `MenuLoopType` (s8, lb), `MenuEtcSpecialCode` (int), `MenuBGMVolume_Save` (int),
`MenuTopicAlphaCalc` (s16; 0 fade in, 1 fade out), `TopicTex` (mgCTexture*, "mnmain"),
`old_light_menu` (int), `HatumeiMenuOkFlag`/`WorldMapOkFlag`/`ManualMenuOkFlag`/
`DngMoveMenuOkFlag`/`MenuDoubleDrawCheck` (1 byte, lbu: u8 or bool), `MenuTopicType`,
`MenuTopicLength` (s16), `TopicFontX` (int), `MenuMainStack`, `MenuMainStack_Next` (mgCMemory; menu and
sub-menu work areas, only referenced in menumain), `CMenuInterStatic` (CMenuInter), `MenuPrimFix` (mgCDrawPrim),
`workchr_1622` (char[0x60]), `CommonMenuModeID2` (int[8]), `TopicFont` (CMenuFont, 0xB8),
`at_2351` (int[8] default icon item numbers).

## CMenuInter (size 0x18; `CMenuInterStatic` symbol size 0x18)
No vtable, no ctor (the static instance is not constructed in `__sinit_menumain_cpp`).
| off | type | name | evidence |
|---|---|---|---|
| 0x00 | int | select_no | Initialize sw 0; passed as int* to MenuKeySelectCheck; index into mode_list; set -1 on close |
| 0x04 | int | select_num | Initialize sw 6; passed twice to MenuKeySelectCheck (exact meaning of both args unknown) |
| 0x08 | int | next_mode | Initialize -1; PushOk stores chosen mode; MenuInternSelectKey passes to NextMenuInit |
| 0x0C | int* | mode_list | = GetCommonMenuModeID() in MenuInternInit; -1 terminated |
| 0x10 | s16 | step | sh/lh; 1 Initialize, 0 InitEnd, 2 cancel, 13 message (MenuInterStep) |
| 0x12 | s8 | bg_read_step | lb/sb; 0/1/2 in ReadBGTexture |
| 0x13 | s8 | bg_read_wait | lb/sb; 30 on restart, decremented |
| 0x14 | s8 | cursor_jump | lb; set when cursor moves >1 icon; triggers MenuSetPos |
| 0x15 | u8 | help_update | lbu; when set, MakeMsg(MenuDCMsg, mode+10 or 30 if disabled) |
0x16-0x17 padding. MenuMainKey writes these through an int* (`CMenuInterPt+4` = 0x10 etc).
`ReadBGTexture` returns `bg_read_step == 2` via xori/sltiu (declared int; bool is also possible).

## MenuInternSelectDraw

Draws the position form, optional message, and topic ticker, then conditionally
draws its debug status panels. `MENU_DEBUG_BIT_CTRL` names the five status bits
shown by this function; these are diagnostic labels, not inferred retail enum
names. The function uses native `CMenuFont` construction and inline literals.

The first debug rectangle requires `80.0f` (`0x42A00000`) to evaluate first;
the second requires `350.0f` (`0x43AF0000`). Both verified consumer selectors
are scoped to `DrawMenuFillBox__Fffffiiii`. With those rows and direct float
arguments, the complete unit matches 0x4F98 bytes and 1396 resolved relocations.

All seven strings are inline. The Japanese fallback is the 23-byte Shift-JIS
payload `何も禁止\nされていません`; the help panel is the 45-byte payload
`○:Add Day\n×:View Opening\n△：Boot FishEvent`. Fixed three-digit octal
escapes preserve their bytes independently of source-file encoding. The retail
pieces are padded to 0x20 and 0x30 bytes, respectively, and have no relocations.
Only this function references their original labels, so their assembly data
markers and source extern declarations are removed. The earlier failed literal
experiment used incorrectly reordered bytes; its malformed payloads do not
establish a limitation of the source representation or toolchain.

## MENU_INIT_ARG (size 0x98; `MenuArg` symbol size 0x98)
Filled by dng_main (InitDungeonMain/LoopDungeonMain), title (TitleBootInit/TitleLoop), editloop
(EditInit, via its `MenuInfo` pointer) and event_func (_GOTO_*), read by many menu units as
`MenuArg + off`.
| off | type | name | evidence |
|---|---|---|---|
| 0x00 | mgCMemory* | stack | MenuMainInit sets MenuMainStack over stack->stack + stack_used*16 |
| 0x04 | mgCMemory* | chara_stack | &BuffCharacter; GetCharaMemAllocPtr 1st arg |
| 0x08 | mgCMemory* | base_chara_stack | BaseCharacter / TitleInfo+0x22; -> MorattaStack |
| 0x0C | s16 | chara_tex_block | only lh/sh; 0x10 dungeon, 0x46 town; ReloadTexture / CheckChrChange |
| 0x10, 0x14 | | unk | never accessed |
| 0x18 | CScene* | scene | DngMainScene / TitleScene / MainScene |
| 0x1C | CUserDataManager* | user_data | -> MenuCommonInfo+0xA0 (then overwritten) |
| 0x20 | u_int* | pack | GetPackFile first arg; -> MenuCommonInfo+0x60 |
| 0x24 | int | pack_size | LoadFile out size; -> MenuCommonInfo+0x64 |
| 0x28 | int | open_type | sw/lw everywhere; MenuMainInit reads it with `lh` because it is copied into the s16 at MenuCommonInfo+0x50 (narrowed load) |
| 0x2C | int | tex_block_top | 0x6C/0x54/0x86; MenuCommonInfo+0xC+i*4 = top+i, DeleteBlock |
| 0x30 | int | tex_block_num | 0x10; loop bound (also capped at 16) |
| 0x34 | int | mes_tex_block | 0x58/0x46/0x9A; ReloadTexture before message draws |
| 0x38 | int | active_chara_no | = UserData+0x44d96; GetActiveChraNo returns it |
| 0x3C | int | end_code | -> MenuPrevEndCode; reset to 0; values 1 (chara change), 5, 6, 0xB (fishing), 0x15 seen in dng_main/editloop |
| 0x40..0x50 | int[5] | result | `_GET_MENU_PARAM` returns 0x40,0x44,0x48,0x4C,0x50 |
| 0x54 | | unk | never accessed |
| 0x58..0x94 | int[16] | param | `_GOTO_MENU` writes args from 0x58; CItemSelect::CheckUse uses [0] as mode, [1..10] item list; MenuChapterInit/DngTreeMapInit/InitMainCharaBG take [0] |

## MENU_DRAW_ENV (size 0xD0; new'd with size 0xD0 in MenuMainInit)
Name is not retail (none survives); named after the global `MenuDrawEnv`.
`mgCCamera::mgCCamera(float)` is called on the allocation and no other vtable is stored, so the
camera is a by-value member at 0 (not a base), and the struct needs an inline ctor
`MENU_DRAW_ENV(float f) : camera(f) {}` (or equivalent) to reproduce `new (...) X(8.0f)`; add it
when matching MenuMainInit.
0x00 mgCCamera (0x70, vptr at 0x60); 0x70-0x7F unused; 0x80 ref (MenuCamInit/MenuWorldTrans
SetNextRef; editmenu writes it); 0x90 pos (SetNextPos); 0xA0 float speed (SetSpeed; other menus
write 2,3,7); 0xA4 float projection (800.0, mgSetProjection each frame); 0xA8 float
old_projection (mgGetProjection at init, restored at exit); 0xAC unused; 0xB0 old_ambient
(mgGetAmbient); 0xC0 ambient (80,80,80,128; mgSetAmbient).

## MENU_ETC_INFO (MenuEtcInfo, 8 bytes)
Name not retail. Only written: +0 = MenuArg.mes_tex_block, +4 = GetTexture("mnmain") (InitEnd).

## Enums (names invented)
- MenuModeID: index into menu_keyfunctbl/menu_drawfunctbl (30 entries; 9 and 30/31 null);
  value held at MenuCommonInfo+0x54 (current) and +0x58 (requested, -1 none). Names from the
  table's function names. Modes 0/1 both run MenuInternSelect*: at_1514 = {0,1} maps open type
  0/1 back to the top menu.
- MenuOpenType: MenuMainInit switch on MenuCommonInfo+0x50 (= arg->open_type). Values and the
  init each calls are as documented in the header. 0x10/0x11 = 0/1 + 0x10 set by MenuMainInit
  when CheckItemOver() > 0 (ItemOverFlowCheckFlag); CheckTrushMenu tests for them. 7 vs 8: save
  in play (SaveMapInfo, mode 13) vs from title (mode 14, TitleLoop sets 8). 13 vs 19 both call
  WorldMoveInit with the value; 9 vs 22 differ only in the SE played (1 vs none); 21 vs 29 call
  InitMainCharaBG with flag (type==29). Set by: DngMainKey (1, 10, 0x15, 0x1C), editloop (0, 2,
  10, 0x1D), events (3, 4, 9, 0xB, 0xE), title (8, 0x12, 0x14, 0x1B).
- MenuLoopType: MenuLoopType = 1 for open types 1, 0x11, 0xE, 0x15. MenuInternInit hides the
  world-map icon ("mi4") when 1 and the floor-map icon ("mi9") when 0 -> 1 = dungeon.
- MenuInterStep / MenuInterBGReadStep: CMenuInter fields above.

## Globals in the header (non-local), with evidence
- MenuMainScene CScene* (GetMainScene), MenuActiveSaveData CSaveData* (GetSaveData).
- Save-data sub-pointers (offsets from CSaveData): MenuUserDataManPtr +0x1D2A0 CUserDataManager;
  MenuConfigPtr +0x1C574 SV_CONFIG_OPTION (CMenuOption memcpy's 0x40 bytes to/from it and calls
  InitSV_CONFIG_OPTION on its copy); MenuSystemDataPtr +0x640C0 CMenuSystemData (menushop casts
  GetMenuSysData() to it); MenuSaveDataDungeonPtr +0x1C5B4 CSaveDataDungeon (SetFloorID called
  on it); MenuFishAquarium +0x21BF8 CFishAquarium (type from name only; only stored here).
- MenuNowMapNo/MenuNowMapType s16 (sh/lh; symbol size 2). MenuNowTime float (scene+0x2F6C,
  hours). ItemOverFlowCheckFlag s8 (lb, size 1). MenuCommonInfo CMenuKeyFunc* (new 0x160,
  CMenuKeyFunc::Initialize). MenuMoveItemPtr CMenuMoveItem*. MenuFormMI2 CMenuPosDataForm*
  (form "mi2"). MenuItemCommandCounter int (wraps at 10,000,000). menu_debug_flag int (toggled by
  pad 0x400 when DebugFlag). MenuPrevEndCode/MenuBGTextureBlock/MenuItemIconTextureBlock int
  (.sdata, init -1). MenuItemUse CMenuItemUse (0x1C). MenuMainTextureReadBuf/MenuSoundBuffer
  mgCMemory (Init in __sinit). MenuArg MENU_INIT_ARG.

## Function notes
- Return types: CheckShortFlagMenu sign-extends 16 bits after the call -> short.
  CursorSaveOptionState ends `andi 0xFF` -> bool. GetMenuLoopType returns `lb MenuLoopType`.
  SetMenuEtcFlag reloads and returns the global. MenuMainInit returns `lh MenuCommonInfo+0x50`.
  GetMenuMain*Buffer/IMGPtr return GetPackFile's u_int* (MessageBuffer used as short*).
- menu_GetBattleAreaScene returns CScene+0x2F90 (same object as dng_main's `BattleAreaScene`);
  its type has no known name, so it is declared `void*`. Fields seen: +8 u32 flags (0x8000 =
  pad reset disabled), +0xC u16, +0x5C int, +0x9E s16.
- CopyActiveIconTexture's third argument and CopyActiveItemAndWeapon's second, CMenuInter::
  Initialize's argument and GetMenuCfgFileName's second are never read.
- MenuInterMes / MenuDCMsg CDC2Mes objects are new'd with 0x2A50 bytes, then the inline
  ClsMes reset (the large block of stores) runs; that is an inlined ClsMes/CDC2Mes method, not
  menumain code.
- MenuWorldTrans/MenuMainExit call camera vtable slot +0x18 (get view matrix) and slot +0x8.
  In `MenuWorldTrans`, loading the camera speed into a separate local before
  passing the literal `-1.0f` preserves the retail register assignment for
  `mgCCamera::SetSpeed`.

## Topic rectangle argument order

The unscoped binary32 selector for `DrawMenuTopic__Fv`, `36.0f` (`0x42100000`), sets `evaluate_first: true`. It preserves the vertical-origin assignment through all four rectangle constructor calls. Canonical verification passes the complete unit: `0x4F98` allocated bytes and 1,389 relocations. The unused long-division primer is replaced by GPR helper mask `0x30`, FPR mask `0`, preserving all allocated bytes and relocation identities.


## Native data and matching constraints

MenuMainInit remains assembly-backed, with light_1062, lightcolor_1063 and at_1440__2
supplying its lighting and branch tables. menu_basedgRef and menu_basedgCamPos also
retain markers: natural SDK vectors plus memcpy grow MenuCamInit from 0x44 to 0x6C and
add call relocations. All BSS are native.

MENU_INIT_ARG, CMenuItemUse and CMenuInter own 0x98, 0x1C and 0x18 bytes; their tails to
0xA0/0x20/0x20 are alignment. Refresh counter and flag are signed bytes with a
twenty-five-frame interval. Thirty-entry key/draw callback arrays include the unused
null slot; their eight-byte tails are alignment. Topic color/shadow tables are mutable
float[4][4]. Topic messages are seven-by-three pointers, the resource table has
seventeen pointers sharing its empty literal, and monster_table has eleven name/message
pairs including its zero terminator.

Page, board and opening aggregates initialize at their original copy points, preserving
the null-board branch and declaration order. Opening points are {50,40}, {-260,0},
{20,40}; the selection cursor starts {0,0}. Constructor-bearing definition order is
MenuMainStack, MenuMainStack_Next, MenuPrimFix, MenuMainTextureReadBuf, MenuSoundBuffer,
TopicFont; the primitive pointer follows its builder declaration.

## Persistent state ownership

MenuMainKey owns its signed-byte refresh_cnt static at the refresh point,
so MWCC emits its initialization guard and the twenty-five-frame cadence.
The saved player position is declared in menumain.hpp and shared with the
character-menu consumer through that header. Both definitions preserve
complete-object bytes and resolved relocations.
