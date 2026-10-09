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
- Layout verified by compiling against stubs (CBaseMenuClass = 0x10C bytes + vptr at 0x10C, sizeof
  0x110; SV_CONFIG_OPTION 0x40; BGM_STATUS 0x1C) with every field offset asserted.
- `SV_CONFIG_OPTION`: size 0x40 (`InitSV_CONFIG_OPTION` memsets 0x40, sets +0x14 = 1), owned by
  savedata. `CScene::BGM_STATUS`: 0x1C (GetActiveBgmStatus writes +0..+0x18; +4 is the BGM number,
  read as `bgm_status+4` for LoadBGM in MenuManualDraw / CSaveMenuClass::KeyStep).
- `ps2/src/menuop.cpp` includes `menuop.hpp`; the unit compiles with all drafts enabled.

## Vtables
`__vt__11CManualMenu` 0x37C580, `__vt__11CMenuOption` 0x37C560, `__vt__14CSaveMenuClass` 0x37C540,
each 0x20: 2 zero words + CBaseMenuClass's six (IsCreateObject, IsMakeObject, IsAskExtend,
ItemCmdAfter, InitEnd, ExitEnd), none overridden. No out-of-line ctor/dtor exists for any of the
three; the constructors are inlined into the *Init functions (`__nw__FUiP1(size, Alloc(...))`,
`__ct__14CBaseMenuClassFv`, store vptr at 0x10C, then member inits). The inline
constructors reproduce these stores in the order documented below.

## CManualMenu (0x178) -- `__nw(0x178)` in MenuManualInit
`MenuManualInit` is native and accepted at the retail 0x510-byte body size.
Before the placement policy, its guarded draft emitted 0x518 bytes and moved
the next function by 0x10 after alignment, so that baseline used the assembly
gap. `MenuSaveInit` is native and exact with a loop initializing the two
slot-form pointers in `CSaveMenuClass`. The current menuop object passes
`check_objects.py` with no remaining guards.
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
  its former guarded init differed at the placement-new null branch and later
  scheduling, which the current after-inline conversion resolves.
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

## LocalFunc_AdjustScrlBar draft
The scrollbar helper divides the available height by total and visible lines, resizes the middle part, then positions the three parts in order. The typed C++ function matches retail.

## SaveFileListDraw draft
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

## Historical remaining-function classification at 0abce37

At `0abce37`, the 36-function unit had 33 matches and the three guards below.
These historical comparisons use relocation-masked instruction words over each
manifest extent, not objdiff percentages. All three guards are now removed.

### MenuManualInit__FP9mgCMemoryPii — placement-new null branch

Retail is 0x510 bytes; the natural draft at `0abce37` was 0x518 bytes. At
retail +0x98 (0x2C4518), `beqz v0` skips construction with `move s2,v0` in its
delay slot. That draft copied into s2 first, then branched on s2. Its base
construction, vtable emission and mgCMemory initialization consequently had
different scheduling, and that draft did not fit the retail extent.

This was the placement-new branch category assigned to compiler research.
The constructor and init remained guarded at that snapshot pending a natural
form or evidenced lowering policy reproducing branch-before-copy. The later
accepted conversion uses neither handwritten vtables nor instruction wrappers.

### MenuSaveInit__FP9mgCMemoryPii — placement-new null branch

At `0abce37`, the draft and retail extents were both 0x6A0, with 245/424 masked
words differing. The first pair was +0x68/+0x6C (0x2C9B48/0x2C9B4C): retail
uses `beqz v0` with `move s0,v0` in its delay slot; that draft copied first and
branched on s0. This shifted the inline base/derived initialization through
CMemoryCardManager allocation by one instruction. Matching store order alone
was insufficient, and a separate placement-new call in the message-window
loop also had a scheduling difference in that snapshot.

At that snapshot this caller was parked on the shared placement-new category,
with allocation and loop scheduling still requiring comparison. The genuine
slot-form loop below subsequently resolved it without a placement row.

### KeyStep__14CSaveMenuClassFv — control flow and stack layout

Baseline: 1291/1692 words differ, draft 0x1A2C, retail 0x1A70. With the
retained natural C++ corrections: 1189/1692 differ, draft 0x1A44. No guard has
been removed. All other 33 unit functions still match.

Retail loads MenuDCMsg[2] after CMemoryCardManager::Step. After FormStep, it
captures messages 4, 5 and 6 before StepMsg and the position calls. Those load
orders are significant across calls and are reflected in the draft. File-list
phase 7 is an explicit idle switch arm: retail compares it between phases 2 and
6 and branches to the shared page exit. Placing that arm after the phase-6
notice body reproduces the dispatch order. LR page jumps modify the existing
movement accumulator by two, and the file-read page clamps `top > 10` to 10.
The latter spelling reproduces retail's `slti at` comparison.

Entering the file list refreshes its messages in every menu mode. Expressing
that assignment once after the conditional load messages restores the retail
register allocation: Step result s7, error pointer s8, refresh s6, LR key spill
at stack +0xDC. The comma assignment inside the mode test changes those live
ranges despite giving the same boolean result.

Remaining differences include:

- Retail frame 0x1A0 versus draft 0x160. Both place the 13 file-info pointers
  at +0xE0 and the form coordinates at +0x120/+0x124. Retail's temporary arrays
  start at +0x168, while the draft's start at +0x128. The unreferenced interval
  +0x128..+0x167 does not establish a legitimate extra array or its element type;
  adding artificial padding or enlarging an array solely to reserve it is not
  supported by the evidence.
- The readiness tests after clamping the signed input-wait counter emit a
  relational result followed by a branch in retail (for example `slt`/`bnez`
  at +0xA18/+0xA1C); the draft emits `bgtz` directly. Changing only the ready
  predicate from `<= 0` to `< 1` produces identical instructions.
- Save/load message and page-exit blocks retain scheduling and branch-target
  differences; the shorter draft displaces later blocks. Matching initial
  register allocation is insufficient to establish a matching full body.

Park under control-flow/stack-layout reconstruction. Reconsider when an actual
local type or array extent explains the 64-byte stack interval, or when a
natural counter-condition structure supported by retail produces its boolean
materialization. Re-run the complete function diff after either finding;
remaining page scheduling must also reach zero before removing the guard.

For m2c, the generated retail function refers to two tables named
`at_2517__2` and `at_2518__2`, which its jump-table recognizer does not accept.
An analysis-only copy renaming those to `jtbl_at_2517__2` and
`jtbl_at_2518__2`, with their exact `.word` destinations from the corresponding
retail `__DATA.s` files expressed as local labels, allows the full function to
be decompiled. Generated assembly and shared headers need no changes.

## Save-menu constructor inline classification (2026-10-08)

`CSaveMenuClass` initializes its two actual `slot_form` entries in an ascending
loop. The optimizer unrolls it to the same NULL stores at +0x17C and +0x180;
all intervening form assignments and the three scrollbar-part assignments
retain their existing order and values. No base/member constructor calls are
added or removed. The constructor's inline-info classification is 3, verified
with the hash-pinned trace driver. This puts allocation assignment inside the
construction guard: `beqz v0` at caller +0x68, with `move s0,v0` at +0x6C.

Canonical native `MenuSaveInit__FP9mgCMemoryPii` has 0/424 differing words,
identical relocation kinds and the retail 0x6A0 size; plain-wibo
`draft.sh --diff` also reports zero differences. Only that function changes
in the full native draft comparison. Its guard/fallback were removed manually.
At that stage `MenuManualInit` and `CSaveMenuClass::KeyStep` retained their
independent parks; neither is guarded now.

The full build retains i15's .text difference of 0x26 bytes, with every other
section and BSS end OK. Complete objects pass 147/149; nd_meswin and actscript
retain exactly their original single problem each. Against the accepted shop
change, only `menuop.cpp.o` changes its full-file hash; all 149 allocated-section
inventories stay identical. Coverage increases from 6,682/173/15/2 to
6,683 matched / 172 guarded / 15 asm-only / 2 fuzzy, without any matched function
losing its status. Receipts: `.private/receipts/ctor-final/save-promoted/`.
See [the classifier rules](../funcpoint/placement-new.md#constructor-inline-classification).

## Mid-day save-menu draft at c79e57c

The `c79e57c` baseline had 34 matched functions and two guarded drafts in the
36-function unit: MenuManualInit and CSaveMenuClass::KeyStep, with no asm-only
functions. Canonical SF native compilation confirms the earlier
1189/1692 masked-word KeyStep diff and its 0x1A44-byte body.

### Input-wait predicate and retained scheduling

The signed input-wait counter is decremented and clamped to zero separately
from deciding whether input is still waiting. An explicit boolean
`input_waiting = input_wait_counter > 0`, followed by `if (!input_waiting)`,
reproduces retail's boolean materialization (`slt` followed by `bnez`) at
all three readiness checks. This flag carries the actual debounce condition;
it adds no game state, dummy storage, helper function, or SF policy.
An integer flag produces the same native function as the boolean control.

Additional retained natural expressions preserve these retail operations:

- Accumulate the up-key movement with `moveKey -= 1`, matching the retail
  saved-register decrement at +0x290; the accumulator begins at zero.
- Clamp the slot with `slot > 1`, producing retail's `slti at`/`bnez`
  upper-bound check at +0x2F4/+0x2F8.
- Express insufficient space as `card->free_size <= check_kb`. The equality
  boundary is unchanged, while operand loading and comparison allocation
  become closer to retail at the relevant space checks.
- Capture the selected file-info pointer before decrementing the input-wait
  counter. Both operations follow the cursor's SetAction call and no call
  intervenes; this restores retail's select/manager load order in that block.

| Canonical native KeyStep variant | Differing words / 1692 | Body bytes |
| --- | --- | --- |
| Lane entry | 1189 | 0x1A44 |
| Explicit waiting flag only, bool or int | 1011 | 0x1A4C |
| Waiting flag plus slot upper-bound spelling | 1009 | 0x1A4C |
| Waiting flag plus accumulated up movement | 1010 | 0x1A4C |
| Waiting flag plus free-space operand order | 1003 | 0x1A4C |
| All three additional expressions | 1000 | 0x1A4C |
| Combined version capturing file info before decrement, retained | 994 | 0x1A4C |
| Combined version capturing file info after clamping, rejected | 1008 | 0x1A4C |

At the `c79e57c` probe boundary, the other 34 native functions remained exact,
and MenuManualInit's draft remained 0x518 against retail's 0x510. The diff
printer counted 285/326 words including that two-word overrun. This probe
removed no guard or assembly fallback.

### Remaining boundaries

KeyStep's frame is still 0x160 against retail's 0x1A0, and scratch-array
addresses still differ by 0x40 after the existing row-info and form-coordinate
locals. Page exits and later scheduling remain different; the body is still
0x24 bytes shorter than the 0x1A70 retail extent. The improved readiness
predicate does not resolve these independent boundaries.

The quest-fish confirmation at retail +0x950 passes count 16 to the already
documented CDC2Mes::SetMsgVolumeNo overload, with its buffer at stack +0x168;
only the first two words are initialized in this caller. That count is not
evidence for filling the unreferenced interval +0x128..+0x167 with a larger
initialized local array: the buffer begins after that interval, and the
callee reads up to MES_VALUE_MAX entries from the supplied pointer. No
artificial stack padding, invented extent, or shared-header proposal is made.

m2c uses an analysis-only assembly copy with the two existing jump tables
named `jtbl_at_2517__2` and `jtbl_at_2518__2`; exact destinations are copied
from their retail data files. Passing that copy as an additional input to
decompile.sh yields the complete function without modifying generated
assembly. At this probe boundary, MenuManualInit's constructor-classification
park still applied: no supported homogeneous inline member-array clear existed.
Its later accepted conversion does not invent such a clear.

### Validation

The final build retains the baseline 0x26 differing PAL .text bytes; all
other file-backed sections and memory end 0x01F64A00 are OK. Complete object
checks remain 147/149, with the unchanged single nd_meswin/DrawMesWin and
actscript/_SHOT problems. Owned units pass: menudraw 0x14058 bytes/2,584
relocations, menushop 0x5A5C/1,327, menuop 0x7DE4/2,075.

All 149 final object SHA-256 values and allocated-section inventories are
identical to lane entry. Coverage stays 6,686 matched / 169 guarded /
15 asm-only / 2 fuzzy, with identical per-function rows. No header, compiler
profile, toolchain, or non-owned source is changed.

Private receipts: `.private/menuui-{baseline,final}-{build,objects,objdiff,progress}.log`,
`.private/menuui/hash-comparison.json`, the before/final coverage files,
`.private/menuui/native-before/`, `.private/menuui/retained/`,
`.private/menuui/save-*/`, and the complete m2c output
`.private/menuui/save.m2c.txt`.

## Round-1 load-confirmation join at b1220c8

The refreshed `b1220c8` baseline had 6,736 matched functions, 124 guarded drafts,
10 asm-only functions and two fuzzy functions. Complete objects pass
147/149; the only failures remain nd_meswin/DrawMesWin and actscript/_SHOT.
The PAL verifier differs in exactly 0x26 .text bytes, with all other sections
and memory end 0x01F64A00 matching. That menuop baseline had 34 native matches
and the two then-established guarded drafts.

Retail's quest-fish and ordinary load-confirmation paths join at +0x994
for one MenuSePlay(SYSTEM_SE_DECIDE) call. A quest file without fish instead
sets SAVE_LIST_PHASE_NOTICE and exits the input-button switch. Expressing
that exit with break allows the two successful confirmation paths to share
the sound call naturally. The message setup order and notice behavior are
unchanged; the count-16 volume argument is spelled MES_VALUE_MAX.

Canonical native KeyStep improves from 994/1692 to 522/1692 differing
relocation-masked words, retaining the 0x1A4C body and NONMATCHING guard.
At that probe boundary, all 34 other native functions remained exact and
MenuManualInit retained its independent 0x518-versus-0x510 constructor park.

The 0x160 native frame still differs from retail's 0x1A0. The initialized
quest buffer remains two words at retail stack +0x168, immediately followed
by another two-word initializer at +0x170. Extending that buffer to 16
elements would overlap the documented neighboring locals and extend beyond
retail's frame. The SetMsgVolumeNo count does not justify a larger buffer
or a dummy array in the unreferenced +0x128..+0x167 interval.

Receipts: .private/menuui-r1/{baseline-build,baseline-objects,baseline-objdiff,
baseline-progress}.log, coverage-before.txt, native-before/,
save-shared-load-sound/, and save.m2c.txt. The complete m2c analysis uses the
pre-existing private jump-table input; no assembly file is written or modified.

The guarded-change build preserves the baseline PAL result. The complete
menuop object passes with 0x7DE4 allocated bytes and 2,075 relocations.
All 149 object file hashes and allocated-section inventories are identical
to the refreshed baseline. Additional receipts are save-shared-build.log,
save-shared-objects.log and save-shared-hash-comparison.json in that directory.

## Round-1 page transitions and message rows

The next-page jump table has seven entries. FILE_READ (3) and UNK_5 (5)
both reset phase but have distinct retail destinations, +0x15D8 and +0x16A0.
Keeping these as separate switch cases, with the UNK_5 reset after FORMAT
and an explicit empty ERROR case, restores the seven-entry table and the
retail placement of the reset blocks. Combining cases 3 and 5 emits a
six-entry table and displaces subsequent blocks.

The retained reconstruction also expresses formatting completion with the
failure predicate first, uses a real boolean for the absence of a pending
page change, and preserves the loaded-transfer operand order in StepMenuDl2.
The format-confirmation assignment follows both message and answer tests,
rather than appearing in a comma expression inside the condition. Each
message row initializes its slot number before initializing its digit width.
These changes preserve the analyzed behavior and improve control flow and
scheduling without artificial locals or new helpers.

The row refresh at retail +0x1738 writes a 32-bit -1 to the documented
ClsMes::mes_no field at +0x1E3C. CDC2Mes also has a distinct 16-bit mes_no
at +0x295E, used for the existing error-message comparisons. The reset must
therefore use `rowMes->ClsMes::mes_no = -1`; unqualified access selects the
wrong field. Both fields and the class sizes are already documented in
menucls1 and nd_meswin, so no shared-header change is necessary.

| Canonical native KeyStep variant | Differing words / 1692 | Body bytes |
| --- | --- | --- |
| Shared load-confirmation sound, preceding retained draft | 522 | 0x1A4C |
| Failure-first format completion only | 499 | 0x1A4C |
| Transfer operand order only | 519 | 0x1A4C |
| Format and transfer changes combined | 496 | 0x1A4C |
| Combined plus bool negative-page flag compared to zero | 392 | 0x1A5C |
| Combined plus int negative-page flag compared to zero | 319 | 0x1A54 |
| Separate FILE_READ and UNK_5 reset cases | 98 | 0x1A64 |
| Qualified base message-number reset | 97 | 0x1A64 |
| Slot number initialized before digit width | 93 | 0x1A64 |
| Format-confirmation assignment after both predicates | 95 | 0x1A64 |
| Combined row/confirmation changes and bool flag negation, retained | 91 | 0x1A64 |

Further predicate alternatives do not improve the retained draft. On the
97-word version, a bool flag compared to zero gives 232 words, whereas
negating the bool or int flag gives 97. Direct negative-predicate negation
gives 494, comparison to zero gives 336, and a combined update-page boolean
gives 212. Moving predicate recomputation, separating its branch-local
assignments, or changing the int flag's declaration scope does not improve
allocation. Private enum typing also leaves the measured predicate draft
unchanged and supplies no reason for a header change.

Normalizing the other-slot index through bool/u8 locals or casts gives
233..391 words before the final two improvements; comparisons of a converted
bool with false give 227 on the final draft. A named transfer-progress local
produces 100 instead of 97 words. These variants are rejected. No compiler
profile row is supported by the remaining integer differences.

### Remaining boundaries and receipts

The final guarded draft has 91/1692 differing words, a 0x1A64 body against
retail's padded 0x1A70 extent, and a 0x160 frame against 0x1A0. The
unreferenced 0x40 interval preceding the small initialized message buffers
still has no supported source type or local extent. Buffer initialization,
message values and row-number stores after that interval use stack addresses
0x40 below retail. No dummy padding or overlapping array is added.

The other differences are the commutative addition operand order at +0xABC,
negative-page predicate allocation and duplicated materialization around
+0x12A4..+0x14BC, and the other-slot boolean lowering before +0x1568. The
extra predicate instruction and shorter boolean sequence offset each other;
most later instructions again align. All 34 other native functions remain
exact in that measured snapshot, and MenuManualInit still had its independent
constructor park. Both functions are now native and accepted.

Private receipts: `.private/menuui-r1/save-variants2.log` through
`save-variants8.log`, their `save-*` source/object/diff directories, and
`retained-menuop/`. The final whole-build, complete-object and hash receipts
are `final-build.log`, `final-objects.log` and `final-hash-comparison.json`
in that directory. No assembly, header, compiler-profile or non-owned
source edit is retained.

The final complete menuop object passes with 0x7DE4 allocated bytes and
2,075 relocations. Complete objects remain 147/149, with the unchanged
nd_meswin and actscript failures. PAL retains exactly 0x26 .text bytes
different, with all other sections and memory end 0x01F64A00 matching.
All 149 file hashes and allocated-section inventories are identical to the
refreshed baseline. Coverage remains 6,736 matched / 124 guarded /
10 asm-only / 2 fuzzy, and no promotion is claimed.
