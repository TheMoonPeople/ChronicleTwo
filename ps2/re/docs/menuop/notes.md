# menuop: reverse-engineering notes

`MenuManualInit` is native C++ with one after-inline conversion of its
`CManualMenu` construction; complete-object and PAL verification pass. No
`NONMATCHING` guards, assembly fallbacks or data markers remain in this unit.
`MenuSaveInit` is already native through its genuine slot-form initialization
loop, without a new placement row. See
[placement conversion](../satansfiddle/placement-new.md).

Unit: manual menu (`CManualMenu`, `MenuManual*`), option menu (`CMenuOption`, `MenuOption*`), save/load
menu (`CSaveMenuClass`, `MenuSave*`, `SaveFileListDraw`, map-info save/restore), mini-game save menu
(`SubGameSave*`). No first-game counterpart (Dark Cloud 1 has no `CBaseMenuClass` menus).

## Header dependencies
- `menuop.hpp` includes `menusys.hpp` (base `CBaseMenuClass`), `savedata.hpp`
  (`SV_CONFIG_OPTION`, by value twice in CMenuOption), `scenesnd.hpp`
  (`CScene::BGM_STATUS`, by value in CManualMenu and CSaveMenuClass), and
  `memcard.hpp` (typed card and file information). These headers compile together.
- `CBaseMenuClass` has its vptr at 0x10C and size 0x110; `SV_CONFIG_OPTION` is
  0x40 bytes and `BGM_STATUS` is 0x1C bytes.
- `SV_CONFIG_OPTION`: size 0x40 (`InitSV_CONFIG_OPTION` memsets 0x40, sets +0x14 = 1), owned by
  savedata. `CScene::BGM_STATUS`: 0x1C (GetActiveBgmStatus writes +0..+0x18; +4 is the BGM number,
  read as `bgm_status+4` for LoadBGM in MenuManualDraw / CSaveMenuClass::KeyStep).

## Vtables
`__vt__11CManualMenu` 0x37C580, `__vt__11CMenuOption` 0x37C560, `__vt__14CSaveMenuClass` 0x37C540,
each 0x20: 2 zero words + CBaseMenuClass's six (IsCreateObject, IsMakeObject, IsAskExtend,
ItemCmdAfter, InitEnd, ExitEnd), none overridden. No out-of-line ctor/dtor exists for any of the
three; the constructors are inlined into the *Init functions (`__nw__FUiP1(size, Alloc(...))`,
`__ct__14CBaseMenuClassFv`, store vptr at 0x10C, then member inits). The inline
constructors reproduce these stores in the order documented below.

## CManualMenu (0x178) -- `__nw(0x178)` in MenuManualInit
`MenuManualInit` is native at the retail 0x510-byte body size. `MenuSaveInit`
initializes the two slot-form pointers in `CSaveMenuClass` through a loop.
Ctor order: vptr; `movie_stack.Init()`; select=0, top=0, list_y=400.0f (0x43C80000), cursor_jump=0,
pict_mode=0, pict_num=0, base 0x14 (s16)=0; `movie_stack.stSetBuffer(NULL)`.
- 0x110 select, 0x114 top: `MenuKeySelectCheck(.., &select, &top, 0, 0x2E, 10, 0)`; 46 entries, 10 lines.
  Entry `select` unlocks on `CheckBitFlagMenu(manual_boot_event_no[select])` or `CheckOmakeVtuto`.
- 0x118 BGM_STATUS saved before the movie, restored by SetActiveBgmStatus in MenuManualDraw.
- 0x134 pict_mode (entries 0x16/0x17 1-based load `pict` images instead of a movie),
  0x138 pict_num (6, or 3 for 0x17), 0x13C pict_page (L/R wrap). MnOnePictTex[pict_page] drawn.
- 0x140 mgCMemory movie_stack (Init in ctor; stSetBuffer to MenuArg.stack top before Load; its
  +0x1C/+0x24 accesses appear as 0x15C/0x164 in m2c).
- 0x170 float list_y (CalcMenu1 target `y - top*24`), 0x174 cursor_jump (MenuSetPos once).
- Uses base 0x0 (`mode`: 0 keys, 1 opening, 2 closing) and base 0x14 (`key_arg_no` in menusys's
  header) as the manual step: ManualMenuStep 0..4 (KeyStep switch 2, MenuManualDraw cases 2/3/4).

## CMenuOption (0x384) -- `__nw(900)` in MenuOptionInit
Ctor: vptr; for i<20: choice_num[i]=1, button[i][0..2]=0, value[i]=0, unk_2A4[i]=0 (unrolled x8 then
tail loop); list_y=400.0f; select=top=choice=0 (0x374/0x378/0x37C).
- 0x110 float list_y; 0x114 s32 choice_num[20] (2 for the first `config_option_num_i` lines,
  [5] = 3); 0x164 MENUFORMPARTS_TYPE* button[20][3] from form "Op_Switch" parts "INDEX%d"+"%d";
  0x254 s32* value[20] -> fields of `config`; 0x2A4 s32[20] only zeroed (unk).
- value map (option -> config offset): 0:+0 1:+4 2:+8 3:+0xC 4:+0x10 5:+0x14 6:+0x20 7:+0x1C
  8:+0x2C 9:+0x24 10:+0x28 11:+0x30; options 12..15 are the u8s at +0x34..+0x37 (set directly in
  KeyStep). +0x18 unused. Choosing option 7 = 1 forces *value[8] = 1; option 8 is locked and its
  buttons unlit while +0x1C == 1. Options 14/15 shown only when LanguageCode > 0. KeyStep prints
  MenuConfigPtr +0x36/+0x37 and sets CSound stereo from +0xC on close.
- 0x2F4 SV_CONFIG_OPTION config (copy of *MenuConfigPtr; Select resets via InitSV_CONFIG_OPTION;
  copied back to MenuConfigPtr on cancel/close); 0x334 config_backup (second copy, never read here).
- 0x374 select / 0x378 top (MenuKeySelectCheck max `config_option_num_i`, 9 lines), 0x37C choice
  (L/R clamp to choice_num[select]), 0x380 cursor_jump.
- DefaultButton sets rgba[0..2] (part +7..+9) to 0x40, EnableButton to 0x80.
- Opened with MenuArg.open_type 0x12 (MENU_OPEN_OPTION from title) uses TITLE_INITEND/PREEND_T.

## CSaveMenuClass (0x1A4) -- `__nw(0x1A4)` in MenuSaveInit
Ctor order: vptr; first_step(u8)=1; slot=0; list_jump(u8)=0; top=0; select=0; mode=0; dl_base=0;
save_kind=1; need_kb=save_kb=check_kb=0; chapter8_start=save_count=unk_154=0; dl_tex=0; six forms=0;
scrlbar_parts[0..2]=0; scrlbar_pos={0,9}; card_ok=0; card_changed=0.
- mode (0x124) from open_type: 7 -> 0 save, 8 -> 1 load (title), 0x1E -> 2 (from GyoraceMenuKey;
  "NOT_FISH" script, shows file +0x38 count). MenuSaveDraw debug: mode 1/2 "MODE STATE : LOAD".
- page (0x128) = KeyStep's result code (var_17): 0 slot select ("NEXT_SLOT"), 1 file list,
  2 card info ("GET_CARDINFO"), 3 file read (after SetFuncNo 5), 4 format ("FORMAT"),
  5 (SetFuncNo 0xB, msgs 0xBF5/0xBF6; never seen being set -- unk), 6 error (card missing,
  unformatted, no files, no space "SIZE_NOT").
- phase (0x12C) within file list: 0 pick, 1 yes/no confirm save, 2 saving (StepMenuDl2(dl_base +
  mc+0x914)), 3 "SAVEEND" wait, 6 "NOT_FISH" wait, 0xA new-file create step (then dl_base =
  mc+0x914, SetFuncNo 6, phase 2), 0x32 load confirm, 0x33 loading, 0x34 "LOADEND" (fills
  MenuArg+0x3C..0x50 from memcard +0x8F8..0x908), 0x3C; within format page: 0, 0xA, 0x14.
- save_kind (0x130): 0 when the chosen file exists (overwrite), 1 new. EnvSetSave(kind): kind 1 ->
  SetFuncNo 3, phase 0xA, progress size - 0x1000; kind 0 -> SetFuncNo 6, phase 2. Also writes
  memcard +0x4CC = select.
- 0x13C save_kb = GetSaveDataSize(0)/1024, 0x140 check_kb = save_kb+3 (vs MC_CARD_INFO +0x14 free),
  0x138 need_kb = save_kb+4 (message volume).
- 0x144 card_ok = McCheckMCPs2 result stored in file list; 0x148 card_changed -> page 2 retry.
- 0x14C = CheckStartChapter8(GetSaveData()) (forced 0 in load modes), 0x150 save count.
- 0x154: only zeroed (unk). 0x158 BGM_STATUS (save mode only), 0x174 GetMenuDlTexture().
- Forms: 0x178 "TITLE", 0x17C/0x180 "SLOT1"/"SLOT2" (indexed by slot), 0x184 "CURSOR", 0x188 "LIST"
  (its +0x10 y animated by CalcMenu1 to `y - 80*top`), 0x18C "SCRLBAR"; parts 0x190[3] from
  `b_2715` names. 0x19C int[2] passed as `pos` to LocalFunc_AdjustScrlBar (13 files, 3 shown).
- MC_CARD_INFO for slot = memcard + 0xD5C + slot*0x20 (+4 type, +8 formatted, +0x14 free);
  file infos memcard + 0xDA0 + i*0x40 (13 files).

## Globals (all `.sbss/.bss` symbols are LOCAL except MenuMapInfoSave -> declare `static` in .cpp)
- MenuMapInfoSave (global, 0xC): memcpy of CSaveData+0x1A18..0x1A23 (s16 main map 0x1A18, s16 sub map
  0x1A1A, s16 prev main 0x1A1C, s16 prev sub 0x1A1E, s32 0x1A20 -- see MapJump/CSaveData::Initialize).
  Declared `u8[0xC]` because the savedata struct's name is unknown; retype once savedata.hpp has it.
- MenuMapInfoSave_DngNo s16: saved CSaveData+0x1C5B4 (dungeon number). SaveMapInfo(dng) sets
  +0x1A1C = +0x1A18, +0x1A18 = GetDngMapNo(dng), +0x1C5B4 = dng. GetDngMapNo: dngmap_2627[7] names.
- ManualMovie CMovie* (`__nw(0x23940)`), ManualMovieTex mgCTexture* ("manumoviework"),
  LocalMenuBGForm/LocalMenuClipForm CMenuPosDataForm* ("op_bg"/"clip0"), MenuReturnMsg CDC2Mes*,
  MenuReturnMsgDrawFlag u8 (size 1), MovieBattleBGMPhase s8, MoviePreBattleBGMVol_Save,
  MoviePreBattleBGMVol float, Movie_DungeonFlag/Movie_BossFlag/MovieBgmBattleCheckStopFlag s16,
  CManualPtr CManualMenu*, MovieViewFlag u8, OptionButtonForm CMenuPosDataForm*, CMenuOptionPtr,
  MemoryCardPtr CMemoryCardManager* (`__nw(0x1100)`), SaveMenuPtr CSaveMenuClass*,
  Tex_SaveFile mgCTexture* ("save"), SubGameSaveOrLoad u8 (1 save / 0 load: open type 0x1B/0x1A),
  SubGameSaveOrLoadPhase s16 (0xA1,0xA5,200,0xC9,0xCA,0xFA,1000,0x3E9...), SubGameSaveLoadStatus
  s16, SubGameMCPort u8, SubGameSaveBlock s16[3] (tex_block[0..2]), SubTrue/SubCheckTotalSaveFileSize
  int (GetSaveDataSize(9), +3), SubSaveTileXY float, SubGameSaveCFGBuffer char* +
  SubGameSaveCFGBufferSize int ("save_com.cfg").
- MnOnePictTex mgCTexture*[8] (6 used), StaticMenuLocalStack/StaticMenuLocalStack2/SaveMenuStack
  mgCMemory (Init'd in __sinit), SaveFileList CDC2Mes*[13] (`__nw(0x2A50)` each), SubGameDataBgm
  CScene::BGM_STATUS (0x1C).
- .sdata statics: manual_list_mesclstbl s8[5] = {2,4,5,6,8} (MenuDCMsg/MenuMesForm indices of the 5
  list columns); config_option_num_i / config_option_num_f are BOTH float (14.0 or 16.0 if
  LanguageCode > 0). manual_boot_event_no s16[47] (.data).
- Local functions (static, keep in .cpp): InitMnOnePictTex, SetMCIconData, SubGameCFGAnalyze.

## Function notes
- The typed `CMenuOption` constructor produces an exact retail `MenuOptionInit`.
  `CSaveMenuClass` also produces an exact `MenuSaveInit`, using a loop over its
  actual slot-form array. `CManualMenu` reproduces the documented member stores;
  its initialization and construction sequence matches retail.
- Init signature `(mgCMemory *stack, int *tex_block, int open_type)`; open_type is
  MenuCommonInfo+0x50 (MenuOpenType) from NextMenuInit/MenuMainInit, or 7 / 0x1E from
  DngTreeMapKey / GyoraceMenuKey.
- *Key functions are `return Ptr->KeyStep();` (tail call), so they return int.
- `CManualMenu::KeyStep` matches retail, including the float argument setup
  for the movie BGM phase-3 `CalcMenuAdd` call.
- LocalFunc_AdjustScrlBar(parts[3], pos[2], size[2], top, line_num, show_num, jump): uses pos[1],
  size[1]; part +0x20 y, +0x28 h. Also called by editmenu's CRemovalMenu::KeyStep.
- SaveFileListDraw(int &tex_block, float *pos, int alpha): called from
  CMenuPosDataForm::MenuFormDraw (menudraw); `tex_block` is passed on to MenuReloadTexture(int&, int).
- SetDlInfoMsg(load, show): msg 0xC09 if load else 0xC08 on MenuDCMsg[7]; MenuMesForm[?] +1 = show.

## LocalFunc_AdjustScrlBar
The scrollbar helper divides the available height by total and visible lines, resizes the middle part, then positions the three parts in order. The typed C++ function matches retail.

## SaveFileListDraw
The save list draws 13 card slots in one primitive batch, with an extra marker for occupied slots. It then positions message lines and formats each occupied file’s play time from frames into hours and minutes. Europe uses ASCII digits and `sprintf`; other regions build digits with `GetMenuBigNum`. The typed C++ function matches retail.

## Save map and option indexing

`CSaveData::save_dungeon.stage_id` occupies the saved dungeon word at offset
0x1C5B4. Direct field access is semantically equivalent, but MWCC forms the
large address as `lui 2` plus a negative store offset; retail uses `lui 1`,
`ori 0xC5B4`, then a zero-offset store. `SaveMapInfo` and `ResetMapInfo`
therefore retain the explicit offset for exact matching. The three option
map buttons form a typed pointer array, but direct indexing changes
`CMenuOption::UpdateOptionForm` register allocation (99.78%).
The typed `loop_row[i]` variant keeps the 0x344-byte function size and changes
only the saved-register pairing in the three-button loop: retail uses `s3`
for the row base and `s2` for the byte offset, while MWCC assigns these in
the opposite order. Reordering declarations and loop increments leaves the
99.78% score unchanged.

## Current source status

All 36 functions are native C++ and the complete `menuop` object matches
retail. `CSaveMenuClass::KeyStep` handles card selection, load confirmation,
notice messages and page transitions. The quest-fish and ordinary successful
load paths join for one `MenuSePlay(SYSTEM_SE_DECIDE)` call; a quest file
without fish instead enters the notice phase.

`CSaveMenuClass::KeyStep` declares `form_pos[9][2]`, but accesses only row zero
for menu message coordinates. The other eight rows supply stack space needed
for the exact 0x1A0-byte frame and have no observed use. A natural source form
that preserves the frame and retail instruction order remains a source cleanup
blocker. Keep the exact match for review while searching for that form.
