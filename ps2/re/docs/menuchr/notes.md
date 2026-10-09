# menuchr: reverse-engineering notes

The matching build uses retail gaps for the C++ drafts still guarded by
`NONMATCHING`, including `CMenuChrCngMenu::LoadBGNPCModel`,
`MenuCharaChangeInit`, `CMenuCostumeSel::LoadMenuData`,
and `CMosBookMenu::KeyStep`. The current source also keeps gaps for
`KeyChangeMain` and `MenuCostumeInit`. `CMenuMosSelect::KeyStep` is native;
see [the KeyStep promotion](night-20261008.md#keystep-promoted) and
[the round-three review fixes](review-fixes-r3-20261009.md).
`MenuItemCharaDataLoadEndCheckAfter` is native; see
[the temporary-scene notes](night-20261008.md#temporary-scene-initializer-match-round-1).
Only unguarded functions are active C++ decompilations. `MenuMemoryDivide` and
`CMosBookMenu::Draw` are native, including their capacity and drawing tables.
`CMenuChrCngMenu::EnterDataMenu` is native; its palette and command-loop
findings are in [the night assessment](night-20261008.md#enterdatamenu-match).
`MenuCharaChangeStarDraw` is native; `mgRect<short>` is the generic
template (see [the star notes](night-20261008.md#character-change-star-drawing-round-1)).
`CMenuCostumeSel::Draw` is native with one scoped floating-argument row; see
[the costume notes](night-20261008.md#costume-drawing-match-round-1).
The complete unit passes canonical verification. The `63f7a9e5` baseline
and the current lane pass all 149 object checks and the complete PAL
verifier. Current scores and new probes are in
[the night assessment](night-20261008.md); the dated older assessments
below record their earlier baselines.

`MonsterBookDraw` draws the book, then draws a debug label when
`menu_debug_flag` is set. The retail float register setup for
`DrawMenuFillBox` requires `float(20.0)` and `float(24.0)` at the first and
fourth arguments; these explicit C++ conversions keep its 0x94-byte body
byte-identical. `MenuNPCLoadCheck` clears the model stack state, frees the
loaded texture block, applies the temporary name suffix, initializes and
loads the townsperson model, then clears the suffix and load flag. A typed
`static_cast<mgCTextureManager *>` on the manager address keeps the base
pointer in `s0`, matching the retail code. The loaded model buffer is typed
as `u_int *` for `CActionChara::LoadPack`; reinterpretation happens only at
the memory allocation and DMA loading boundaries. Both functions, the entire
menuchr unit object, and the isolated linked image match retail.

`monster_progress_tbl` is a 19-by-5 array of `s16` rows. Each row starts with
the badge ID and has four monster form IDs. The retail code advances its row
address by ten bytes and its form address by two bytes; declaring the array
with both dimensions lets MWCC produce those two induction variables while
the source uses typed indices. `get_gajji_id_from_monster_progress_table`
searches all forms and returns the badge ID with the form column, while
`GetMonsterProgressTableNo` searches one form column for a monster ID and
returns the row. Both are active C++ functions. Their typed loops pass the
current complete-object check; the unit retains assembly gaps for the menu functions listed below.

`MenuCharaChangeDraw` matches as native C++ with the three stable
floating-expression rows documented below. They restore the panel coordinates
and dimensions to retail's argument materialization order.
`CMenuMosSelect::CheckLoadBGMonster` has the same four-instruction reversal for
the 16.0f and 1.0f arguments to `SetPosition`; binding the character pointer to
a local also changes the adjacent zero argument setup. Writing the first
argument as `float(16.0)` produces the retail register order, so this function
now matches as C++, including the complete object and isolated linked image.


`CMenuChrCngMenu::LoadBGNPCModel` has a native placement-new draft whose
compiled body differs in only two instructions: retail branches on the
allocation result in `v0` and moves it to `s1` in the delay slot, while MWCC
currently moves first and branches on `s1`. Named locals, assignment chaining,
parenthesized new expressions, and a same-type cast retain that difference.
`MenuMemoryDivide` partitions aligned quadword storage with typed table and
buffer indexing; its native function, capacity tables, and stack-name literal
match retail. See [memory partitioning](midday-memory.md).
`MenuMonsterLoadBG` is also native, as documented in the loader section below.
`CMosBookMenu::Draw` preserves the explicit panel, heading, model, digit, and
font sequence and matches with its six native drawing tables; see
[monster-book drawing](midday-book.md).
`CMenuCostumeSel::LoadMenuData` and `CMosBookMenu::KeyStep` each differ by
the same two placement-new branch/move instructions as `LoadBGNPCModel`.
`MenuItemCharaDataLoadEndCheckAfter` returns early through a `switch` on the
load mode. An equivalent `if` lets MWCC fill the inlined `CScene` constructor's
message-loop branch delay slot with the `CMdsListSet::Initialize` address, which
retail sets in the call's delay slot. The function is compiled at inline depth 8
so that the game-object array's `CSceneData` base constructor is inlined.

The seven `MenuActionCharaBuffer` stacks and the other eight `mgCMemory` globals use native
C++ construction in BSS declaration order. MWCC generates the 148-byte retail
`__sinit_menuchr_cpp` from those declarations. `CMosBookMenu` constructs its camera with speed
8.0 and then its stack; the native `MonsterBookInit` matches PAL exactly.
The character and other menu constructors are still being
matched after converting their manual constructor aliases to native C++.

`MenuItemChrLoadEndCheck` obtains the background read's `buffer` at offset 0x110 and uses the
texture manager's `name_suffix` at offset 0x1D8. Typed access to both fields matches retail.

Header: `ps2/include/menuchr.hpp`. The unit has no first-game counterpart (no `menuchr` or
equivalent classes exist in `/home/adubbz/development/chronicle`).

## Classes

All four classes derive from `CBaseMenuClass` (`menusys.hpp`, size 0x110, vptr at 0x10C), so
derived fields start at 0x110. Each is constructed inline in its `*Init` function (no
constructor symbol), which is why the vtables are emitted in this unit.

### Vtables (`__vt__<class>`, 0x20 each, 2 header words + 6 slots)
Slot order is the base's: `IsCreateObject`, `IsMakeObject`, `IsAskExtend`, `ItemCmdAfter`,
`InitEnd`, `ExitEnd`. Only `CMosBookMenu` overrides anything (`InitEnd__12CMosBookMenuFv` in the
`InitEnd` slot). `CMenuChrCngMenu`, `CMenuMosSelect`, `CMenuCostumeSel` use the base entries.

### CMenuChrCngMenu (0x1F80)
- Size: `__nw__FUiP1(0x1F80, ...)` in `MenuCharaChangeInit`; instance kept in `ChrChangMenuPt`.
- Inline ctor in `MenuCharaChangeInit`: `Init` on 0x194/0x1C4 (two `mgCMemory`), clears/sets most
  fields (0x122 = -1 change_chara, 0x11C = -1 then 0x11E = 1, 0x24C/0x24E = -1 sub_menu(s),
  0x200 = -1 face_state, 0x202 = -1 face_chara), calls `InitStarInfo`, then
  `memset(this+0x1A80, 0, 0x500)`.
- 0x1A80 `clut[256]`: `EnterDataMenu` sets `MenuCharaChangeCLUT = this+0x1A80`, `memcpy`s 0x400
  bytes of the base texture's palette (`tex+0x60`) into it, darkens each of the 0x100 RGBA entries,
  and points the copied texture `MenuCharaChangeCLUT_Tex` (0x70-byte `mgCTexture` copy) at it.
- 0x1E80..0x1F80 (`unk_1E80[0x100]`): only covered by the 0x500 memset; no other access found in
  any unit.
- 0x280 `star[256]` of `CHR_CNG_STAR` (0x18 stride; 0x280 + 0x1800 = 0x1A80). Fields 0x10/0x14 of
  a star are unresolved.
- Field offsets in the header were checked with temporary `offsetof` asserts against the
  offsets above (all fields from 0x110 to 0x1E80).

### CMenuMosSelect (0x7670)
- Size: `__nw__FUiP1(0x7670, ...)` in `MenuMonsterBoxInit`; instance in `MenuMosSelectPtr`.
- Inline ctor: `CDC2Mes` ctor at 0x150 (0x2A50 -> 0x2BA0), `ClsMes` ctor at 0x2BA8 (0x2958 ->
  0x5500), a loop constructing `CActionChara`s (0x1030 stride) from 0x5590 until 0x65C0, i.e. one
  element (declared `monster[1]` to keep the array form the loop implies), then a single
  `CActionChara` at 0x65C0 (`effect`), `mgCMemory` Init at 0x75F0 and 0x7620.
- 0x5554/0x5558/0x555C = -1 (view/pick/load monster); 0x5508 = 1 (set_cursor); 0x5500 = 1
  (info_win_show); 0x140 = `GetMonsterBajjiDataPtr(.., 1)` (badges, `MOS_CHANGE_PARAM`).
- 0x110/0x120 are `sceVu0FVECTOR` (16-aligned) holding camera pos/ref; 0x5580 model_pos is a
  vector (hence the 16-byte alignment and the tail padding to 0x7670 after load_phase at 0x7662).
- Unresolved: `unk_148[8]`, `unk_2BA4`, `unk_5504` (zeroed in ctor), `unk_7620` (second stack),
  `unk_765C`.
- `KeyStep` returns `MOS_SELECT_RESULT` (1 close, 2 change) per the existing header; the
  meaning of 2 should be re-confirmed against `KeyStep`'s return sites when its body is written.

### CMenuCostumeSel (0x2D0)
- `MenuCostumeInit` constructs the camera and menu in 0x2F quadwords from the caller's stack,
  sets the default outfit bitset to `0x1274521CB`, includes the optional costume bits when
  `MenuArg.param[0]` is one, loads form data and begins a 40-frame fade. Its guarded constructor
  and initializer are behavioral drafts; normal builds still use the retail assembly.
- Size: `__nw__FUiP1(0x2D0, ...)` in `MenuCostumeInit`; instance in `MenuCosPtr`.
- Inline ctor: `mgCCameraFollow(40, 30, 0, 8)` at 0x110 (0xC0 -> 0x1D0), `mgCMemory` Init at 0x228,
  0x2C0 = `GetCharaDataPtr(.., 0)`, 0x260 = 15.0f, 0x268 = 4.0f (chara_pos x/z), zeroes
  0x1DE..0x1E2 (costume_select) and 0x284..0x2A4.
- `costume_list[3][8]` s16 at 0x1E4, `list[3]` s16* at 0x214.
- Unresolved: `unk_1D4`, `unk_220`, `unk_270[4]`, `unk_280`, `unk_2A8`, `unk_2AC`, `unk_2BC`.

### CMenuChrCngMenu::EnterDataMenu

The native function registers the ring image, parses the menu layout once, installs repair data,
then clones the base texture and darkens its 256 palette entries using a 32-step warm colour
scale. It attaches forms, shows the party members and available characters, installs the two
message buffers, and loads the current townsperson's command messages and ability costs. The
m2c output mislabels several fields after offset 0x110 as `star` members; disassembly confirms
that offsets 0x124/0x128 are `enable_change`/`party_member`, 0x140 is `form`, and 0x21C–0x248
are the NPC and message fields in `menuchr.hpp`. The exact native match is
recorded in [night-20261008.md](night-20261008.md).

### CMosBookMenu (0x980)
- Its native `Draw` function draws the scrolling background, layered panels, attribute icons,
  monster model, three numeric stats and the monster's names and item drops. The model is clipped
  to the central panel after load phase 4 and 17 frames of display. The list counter at offset
  0x7E8 supplies the final page indicator; m2c mislabels it as `abs`. The `ic_5580` table has
  eight coordinate pairs: seven explicit icon positions and a final zero pair
  used for the eighth attribute bit. The exact match and declared table extent
  are documented in [midday-book.md](midday-book.md).
- Size: `__nw__FUiP1(0x980, ...)` in `MonsterBookInit`; instance in `MonsterBookPtr` /
  `MenuMosBookPtr`.
- Inline ctor: `mgCCamera(8.0f)` at 0x110 (0x70 -> 0x180), `mgCMemory` Init at 0x184, zeroes
  0x1B8..0x1E4 and 0x7E8; camera pos (0,0,100), ref (0,0,0).
- `SetMonsterInfo`: strcpy to 0x82C (name, from tbl+4), 0x7EC (area), 0x86C (type name from
  `monster_type_name`), 0x8AC strcpy/strcat (weak names from `monster_jyakuten`), 0x904/0x908 from
  u16 at tbl+0x56/+0x58 (hp, abs), 0x90C = `KillMonsterCount`, 0x910/0x914 OR'd with
  `stand_bit_5472` (resist >100 / weak <0x33), drop items at 0x918 stride 0x21 x3 (also seen in
  `Draw` at 0x918/0x939/0x95A). `list[0x180]` ints 0x1E8..0x7E8.
- Unresolved: 0x1BC..0x1CC (five words, zeroed in ctor).

### MENU_BGREAD_INFO2
- `InitMenuBGReadInfo2` clears 0x0, 0x20, 0x70 (u8) and 0x74 (pointer). 0x70 is tested as the
  "reading" flag in `MenuLoadFileCheck` and loop code; 0x74 holds a `CActionChara*`
  (`MenuItemCharaDataLoadEndCheck`). Allocated with `Alloc(stack, 8)` (8 x 16 bytes), which only
  bounds the size to <= 0x80; natural size is 0x78. No size assert is given.
- `CosutmeSelDefaultSet` searches the first five 16-bit costume IDs and returns the matching
  index, or zero when none match. The function is local to this unit.
- `CMosBookMenu::InitMonsterInfo` clears the first character of
  each display name and drop item, plus the numeric monster details. The offsets are inside
  the named arrays and fields in `CMosBookMenu`.

### CHR_CNG_STAR (0x18)
Stride from `InitStarInfo`/`CalcTex`/`MenuCharaChangeStarDraw`; 0x10/0x14 unresolved.

### mgRect<short>
Declared by the `mgRect<T>` template in `mg_tanime.hpp`; `Set__9mgRect_s_Fssss` is its inline
`Set` instantiated here. Its four halfword fields use 16-byte class alignment,
so `sizeof(mgRect<short>)` is `0x10`, including eight bytes of trailing padding.

## Enums
- `CHR_CNG_PHASE` (change_phase 0x120): 0..3 from `CheckChrChange`.
- `CHR_CNG_SUB_MENU` (0x24C/0x24E): -1 none, 1 monster box.
- `MOS_SELECT_RESULT`: 1 close, 2 change (`CMenuMosSelect::KeyStep`).
- Table sizes enum: `MENU_CHARA_LOAD_MAX` 7 (loops `< 7` over `MenuCharaBuild2`,
  `MenuActionChara`; `MenuActionCharaBuffer` built with `__construct_array(..., 0x30, 7)` in
  `__sinit`), `MENU_LOAD_ITEM_MAX` 12 (`MenuLoadItemNo` 0x18 bytes), `MONSTER_PROGRESS_NUM` 19 and
  `MONSTER_PROGRESS_LEVEL_NUM` 4 (`monster_progress_tbl` 0xBE = 19 x 5 s16).

## Globals
Only symbols that are global in retail are declared in the header: `monster_progress_tbl`,
`MorattaStack`, `MenuLoadInfo`, `MenuCharaChangeBase_Tex`, `MenuCharaChangeCLUT_Tex`,
`MenuCharaChangeStar_Tex`, `CharaSndBuffer`, `MenuCharaBuild2`, `MenuActionChara`,
`MenuActionCharaBuffer`, `MenuLoadItemNo`, `MenuChangeNpcMemory`, `SwordEffectStack`.
Every other named datum in the unit (`menu_robo_memorytbl`, `menu_chr_memorytbl`,
`menu_infocfgname`, `MonsterDataPath`, `monster_type_name`, `monster_jyakuten`,
`monstere_file_template`, `MenuSoundCharaNo`, `menu_chara_chrtbl`, `menu_chara_cfg_chrtbl`,
`monster_load_id`, `NowReadMainChara*`, `MenuCharaChangeCLUT`, `ChrChangMenuPt`,
`MenuMosSelectPtr`, `MenuCosPtr`, `MonsterBookPtr`, `MenuMosBookPtr`, `Tex_MB*`, the
`MenuMos*Stack`/`MosBookStack`/`MenuChangeMemory`/`ChrChangeInitTextureStack` stacks,
`mos_effect_*`, `MenuMonsterBGInfo`, `script_file_name`, `NowMainRead*`, debug flags, etc.) is
LOCAL in `local_symbols.tsv` and belongs as `static` in the `.cpp`.
Note: `MenuActionChara` is 0x1C in main.symbols.txt (BSS slot 0x20 with padding) and
`MenuLoadItemNo` is 0x18 (slot 0x20).

## Local functions (static, not in header)
`CheckBattleLoop`, `MenuMemoryDivide`, `EditCharaPrepare`, `GetBajjiPosition`,
`CosutmeSelDefaultSet`, `GetMonsterBaseInfoForMonsterMemoIndex`.

## Return values
- `CMenuChrCngMenu::KeyChangeMain` always returns 0 (both paths set `$v0 = 0`); caller ignores it.
- `ConvertCharaLoadDataPhase` returns an s16 from `tbl_992[chara*5 + part]`.
- `get_gajji_id_from_monster_progress_table` returns s16 (row's first column) or -1.
- `MenuCharaSoundLoad`, `MenuItemChrLoad` return u32 sizes.

## Monster effect loading

`MOS_HENGE_PARAM` holds four effect base names at offset 0xC. The loader keeps
one script buffer, script length, pack buffer and pack length for each name.
`MonsterEffectRead` fills those four parallel arrays and counts successfully
read bases. `MonsterEffectEnter` temporarily replaces the effect manager's
load buffer, builds the bases for that count, then restores the buffer. The
scene's `read_buff` field is at offset 0x3C. Both functions match when their
array indexing and member calls use the declared C++ types.
# Native party-change construction

`CMenuChrCngMenu` initializes its inherited menu object and its two `mgCMemory` work stacks before clearing its state fields. The palette at offset `0x1A80` and the following reserved bytes form one contiguous `0x500`-byte clear; the header exposes a typed `clut_storage` overlay so the constructor can make that single clear without byte-pointer arithmetic. PAL's `MenuCharaChangeInit` emits one `memset` for this region.

`CMosBookMenu` initializes the camera, list, and description fields in its native constructor, as in the PR7 cleanup branch. `MonsterBookInit` constructs it in `MosBookStack` and then sets its texture block and boot mode.

`CMenuMosSelect` initializes its badge and message window fields in its native
constructor. Its two `CActionChara` members contain `CCharaFrameMatching`
objects. `CCharaFrameMatching` has no user-declared constructor: PAL contains
no constructor calls for these members, and each character retains its
explicit `Initialize__19CCharaFrameMatchingFv` call. An explicitly empty
constructor added two calls absent from PAL. The menu constructor is inlined
into `MenuMonsterBoxInit` at inline depth 3, which matches PAL with trivial
default construction; every other unit including `character.hpp` keeps its
object bytes and relocations.

`SetMenuLoadItemNo` reads Max's or Monica's five `CHARA_DATA::equip` item numbers. For the ridepod, the displayed order is parts 3, 0, 1, an empty slot, and part 2. Typed access to `ROBO_DATA::parts` and `CGameDataUsed::item_no` preserves its exact PAL object code.

`monster_progress_tbl` has 19 rows of five signed halfwords. Each row starts with a badge number and holds four monster forms. The search functions walk the row and form columns, while `get_monster_tbl_bajjilevel` filters a row by badge and level before gathering its next form. Typed indexing preserves the latter function's PAL code; both badge and form searches match PAL exactly. The badge search first selects a row pointer, then indexes its form column; the form search first offsets the table base by the selected column and then indexes successive five-halfword rows. These expression shapes retain the independent retail induction variables without byte-pointer arithmetic.

`CMenuCostumeSel::UpdateCostumeList` reads the worn outfit IDs from equipment slots 2, 4, and 3. These are the `item_no` fields of `CHARA_DATA::equip`; typed member access matches PAL. `MenuNPCLoadCheck` writes a temporary texture manager name suffix while loading the party model, then clears its first character.

`MenuRoboPartsLightOff` finds the child frame named `light` and clears its
`mgCFrameAttr::draw` field. The two anonymous offset structs previously used
for this access are the existing `mgCFrame` and `mgCFrameAttr` types. Using
those types and the literal name matches the 0x34-byte PAL function exactly.

## Stable party-panel and monster-position argument order

These `menuchr.cpp` rows in `scripts/build/satansfiddle.json` select
`binary32` IEEE bits with `evaluate_first: true` for every identical literal
in the named function. They use neither occurrence counters nor callee
restrictions.

| Function | IEEE bits | Value | Purpose |
| --- | --- | --- | --- |
| `MenuCharaChangeDraw__Fv` | `0x41a00000` | 20.0f | Keeps the panel's horizontal origin ahead of its remaining coordinates. |
| `MenuCharaChangeDraw__Fv` | `0x41d00000` | 26.0f | Keeps the second panel's vertical origin ahead of its dimensions. |
| `MenuCharaChangeDraw__Fv` | `0x43960000` | 300.0f | Materializes the second panel's height before its 280.0f width. |
| `CheckLoadBGMonster__14CMenuMosSelectFv` | `0x3f800000` | 1.0f | Materializes the monster's vertical position before its 16.0f horizontal position. |

All three panel rows are needed together: promoting only 300.0f changes the
first `DrawMenuFillBox` call and moves the second panel's dimensions ahead
of its origin. The complete set preserves both debug-panel calls. The
monster row preserves `SetPosition(16.0f, 1.0f, 0.0f)` after background model
loading and before attaching the monster to its menu form.

With the current annotation and direct-literal consumer hooks, the native
1,968-byte `MenuCharaChangeDraw` and 1,036-byte `CheckLoadBGMonster` bodies
have zero differing instruction words and relocation fields. Canonical
wrapper compilation, `fixup_sections.sh`, and `check_objects.py` check
`0x11D00` allocated unit bytes and 3,723 relocations. Other existing unit
findings remain; these rows preserve the matched monster-progress lookup
functions and introduce no additional failing function.

## Monster-book debug argument order

Three unscoped binary32 selectors for `MonsterBookDraw__Fv` mark `40.0f` (`0x42200000`), `200.0f` (`0x43480000`), and `24.0f` (`0x41c00000`) as evaluated first. The debug rectangle materializes those values before `20.0f`, matching retail. The complete unit passes canonical verification: `0x11CF8` allocated bytes and 3,640 relocations. The unused long-division primer is replaced by translation-unit GPR helper mask `0x30`, FPR mask `0`, with identical allocated bytes and relocation identities.

## Native monster-box draw

`MenuMonsterBoxDraw` uses its existing typed native draft. The `sceVif1Packet*` null argument selects the texture reload overload. Its debug-label literal preserves the retail Shift-JIS bytes inline; the unused `at_3762` declaration and separate assembly data include are removed. Canonical verification passes the complete unit: `0x11CF4` allocated bytes and 3,651 relocations, with the accepted monster-book selectors and helper masks.

## Main-character background initialization

`InitMainCharaBG` prepares the menu texture blocks and load stacks, selects the
requested character, preserves the active model's position and rotation, then
starts the appropriate character, ridepod, or monster background read. When
the stored monster ID is negative it sets both user data and the read request
to 0x34. Naming the `CUserDataManager *` returned by the getter before the
store produces retail's two halfword stores from v1, avoiding the draft's
constant in saved register s0. This removes all five differing instructions.

`InitMainCharaBG` passes the draft comparison, the game-unit object check,
and coverage.

The guarded drafts refer to the current shared field names `battle_clear`
(`DNG_BATTLE_AREA` offset 0x5c) and `monster_mode` (`BUILDUP_WEAPON_INFO`
offset zero). The palette overlay's substructure is named `palette`, exposing
`palette.clut` through MWCC without changing its layout or the contiguous
constructor clear. These names repair compilation of all eighteen original
drafts; the nested switch in `KeyChangeMain` itself was well formed.

`MenuMemoryDivide` uses typed quadword-array indexing for its buffer movement.
The earlier round-two draft retained an 18-word register-allocation difference.
The native match in [midday-memory.md](midday-memory.md) supersedes that score. Moving
the buffer declaration before alignment and reversing the explicit rounding
addition operands do not correct the allocation.

The earlier guarded `EnterDataMenu` draft used the texture block loaded from base
menu offset 0x18 for texture registration, repair setup, and reload. Its
script pointer and script length are base fields at 0x8 and 0xc, rather than
the party-change state at 0x118/0x11c. The NPC reset includes offset 0x23c.
Capturing the texture manager and initial texture block follows retail's
reads before the pack lookup. These corrections reduce the draft difference
from 370 to 331 of 388 words at that checkpoint. The subsequent exact native
match is recorded in [night-20261008.md](night-20261008.md).

See [the October 8 lane assessment](round2.md) for the remaining function
scores, concrete park triggers, shared constructor proposal, and validation
receipts.

## Native monster background read

`MenuMonsterLoadBG` resets the background reader when requested, selects the
monster model path for the current menu mode, and starts the model read from
an aligned stack buffer. A successful read marks the request as reading and
reserves its rounded quadword count. Mode 2 also starts the monster script
read and reserves its buffer. A missing model filename returns zero; an
unsuccessful background read still returns one without marking the request
as reading or reserving buffers.

The model and script filenames occupy separate 64-byte buffers. Naming the
pointer into each buffer at its lookup preserves their lifetimes across
lookup and string-copy calls. The script pointer begins after model lookup
succeeds. The successful-read branch encloses allocation and optional script
loading, followed by the common return. Naming the typed `stGetTop()` result
before `LoadFileBG` preserves the buffer read before the path argument read.
These source changes reduce the current Satan's Fiddle draft from 118
differing words to zero, without a profile row or shared-header change.

After manual guard removal, the canonical wrapper, section fixup, and
complete-unit checker accept `0x11CDC` allocated bytes and 3,734 resolved
relocations. The native loader body is `0x1E4` bytes inside its `0x1F0` retail
extent. See [remaining guards on the merged base](remaining-sf-r2.md) for
per-target measurements, useful negative experiments, and final receipts.

## Review cleanup and scene-update load flag

CMenuCostumeSel::Draw uses snake_case local names and USER_CHARA_MONICA for
its character comparison. MenuItemCharaDataLoadEndCheckAfter's case label
uses the surrounding switch indentation. The MenuDCMsg and CostumeOptionEnv
source redeclarations are unnecessary: menuaqua.hpp and title.hpp own them.
MenuCharaChangePosDataCfgBuffer already has one static definition at this
checkpoint (introduced by fb857059); the duplicated extern finding is resolved.

MENU_LOAD_INFO byte +7, update_scene, selects main-scene model updates:
CheckLoadBGMonster uses the main scene's stack and character when it is set,
the character/ridepod loaders collect and reload the main scene's characters,
and MenuItemCharaDataLoadEndCheckAfter calls SetupUnitMan for MenuMainScene.
The signed-byte field shares a union with the old unk_6 array, retaining the
eight-byte layout and existing accesses in protected methods and inventmn.
All unprotected menuchr and menusys accesses use the named field. Byte +6
remains unidentified. The earlier cross-unit full-rename proposal is
superseded; see [the October 9 fixes](review-fixes-r2-20261009.md).

Receipts: .private/fixes-r0/menuchr-final-{build,objects}.log:
SCES_511.90: OK and 149/149 objects.
