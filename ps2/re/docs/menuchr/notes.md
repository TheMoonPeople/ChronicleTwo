# menuchr: reverse-engineering notes

`CMenuChrCngMenu::LoadBGNPCModel`, `CMenuCostumeSel::LoadMenuData` and
`CMosBookMenu::KeyStep` are native C++ with three expected-one after-inline
`CActionChara` rows; see [placement conversion](../satansfiddle/placement-new.md). The
matching build uses retail gaps for the C++ drafts still guarded by `NONMATCHING`:
`MenuCharaChangeInit` and `MenuCostumeInit`. `CMenuMosSelect::KeyStep` is native; see
[the KeyStep promotion](matching-constraints.md) and [the monster-box command notes](#monster-box-pages-and-command-steps). `MenuItemCharaDataLoadEndCheckAfter` is native; see
[the temporary-scene notes](matching-constraints.md). Only unguarded functions are
active C++ decompilations. `MenuMemoryDivide` and `CMosBookMenu::Draw` are native,
including their capacity and drawing tables. `CMenuChrCngMenu::EnterDataMenu` is native;
its palette and command-loop findings are in [matching constraints](matching-constraints.md). `MenuCharaChangeStarDraw` is native;
`mgRect<short>` is the generic template (see [the star notes](matching-constraints.md)).
`CMenuCostumeSel::Draw` is native with one scoped floating-argument row; see [the
costume notes](matching-constraints.md). The complete unit passes canonical object and PAL verification. The current
source forms and rejected controls are recorded in
[matching constraints](matching-constraints.md).

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


Before placement conversion, `CMenuChrCngMenu::LoadBGNPCModel` had a native draft
differing in only two instructions: retail branched on allocation result `v0` and copied
to `s1` in the delay slot, while the draft copied first and branched on `s1`. Named
locals, assignment chaining, parenthesized new expressions and a same-type cast retained
that difference. The current row resolves it. `MenuMemoryDivide` partitions aligned
quadword storage with typed table and buffer indexing; its native function, capacity
tables, and stack-name literal match retail. See [memory
partitioning](midday-memory.md). `MenuMonsterLoadBG` is also native, as documented in
the loader section below. `CMosBookMenu::Draw` preserves the explicit panel, heading,
model, digit, and font sequence and matches with its six native drawing tables; see
[monster-book drawing](midday-book.md). Before their placement rows,
`CMenuCostumeSel::LoadMenuData` and `CMosBookMenu::KeyStep` each differed by the same
two branch/move instructions as `LoadBGNPCModel`. Both current bodies are accepted
native C++. `CMenuChrCngMenu::KeyChangeMain` is native. Its cursor table
`nextIDtbl_1594` is a flat 40-entry array read as `[select * 8 + dir]`: retail adds the
direction before the row offset, while every `[select][dir]` form adds the row first.
Cancelling in the dungeon variant writes `action = 5` before the HP test and again in
the test's then-arm. That repeated same-value store is the one accepted redundant form:
retail's then-block is a leftover `b break; nop`, so the original arm held a statement
that survived block layout and was removed afterwards. An empty arm, `;`, `(void) 0`,
`do {} while (0)`, `if (0)`, an empty inline call and `action = action` are removed
before layout, and `break` in the arm does not match; see
[matching constraints](matching-constraints.md). Its 21 script and map names are inline
literals, the remembered command is the function-local `static s8 SelectedCmdNo = -1`
with its compiler guard, and the name, answer and gift-volume arrays use aggregate
initializers whose zero templates MWCC emits (`at_1650__2`, `at_1684__2`, `at_1806__2`).
`KeyStep` advances its background scroll in place (`bg_scroll += 0.5f`, then subtracts
256 once it reaches zero); computing `bg_scroll + 0.5f` into a local first commutes
retail's `add.s` operands. Its preview model is placed with literal coordinates. The
three promoted bodies spell their literals inline, so `at_1361`, `at_5051`-`at_5053` and
`at_5839` are emitted natively. `MenuItemCharaDataLoadEndCheckAfter` returns early
through a `switch` on the load mode. An equivalent `if` lets MWCC fill the inlined
`CScene` constructor's message-loop branch delay slot with the `CMdsListSet::Initialize`
address, which retail sets in the call's delay slot. The function is compiled at inline
depth 8 so that the game-object array's `CSceneData` base constructor is inlined.

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

The native function registers the ring image, parses the menu layout once, installs
repair data, then clones the base texture and darkens its 256 palette entries using a
32-step warm colour scale. It attaches forms, shows the party members and available
characters, installs the two message buffers, and loads the current townsperson's
command messages and ability costs. The m2c output mislabels several fields after offset
0x110 as `star` members; disassembly confirms that offsets 0x124/0x128 are
`enable_change`/`party_member`, 0x140 is `form`, and 0x21C–0x248 are the NPC and message
fields in `menuchr.hpp`. The exact native match is recorded in
[matching constraints](matching-constraints.md).

### CMosBookMenu (0x980)
- Its native `Draw` function draws the scrolling background, layered panels, attribute icons,
  monster model, three numeric stats and the monster's names and item drops. The model is clipped
  to the central panel after load phase 4 and 17 frames of display. The list counter at offset
  0x7E8 supplies the final page indicator; m2c mislabels it as `abs`. The local `ic` table has
  seven coordinate pairs; its declared retail payload is `0x1C` bytes.
  The following four zero bytes are section-alignment padding.
  The exact match and declared table extent
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
constructor clear. The
nested switch in KeyChangeMain uses the same shared records.

`MenuMemoryDivide` uses typed quadword-array indexing for its buffer movement.
The earlier round-two draft retained an 18-word register-allocation difference.
The accepted form is documented in [the memory notes](midday-memory.md). Moving
the buffer declaration before alignment and reversing the explicit rounding
addition operands do not correct the allocation.

The earlier guarded `EnterDataMenu` draft used the texture block loaded from base menu
offset 0x18 for texture registration, repair setup, and reload. Its script pointer and
script length are base fields at 0x8 and 0xc, rather than the party-change state at
0x118/0x11c. The NPC reset includes offset 0x23c. Capturing the texture manager and
initial texture block follows retail's reads before the pack lookup. The exact palette and command-loop form is recorded in
[matching constraints](matching-constraints.md).

See [the source controls](matching-constraints.md) for accepted source forms and rejected
alternatives.

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
extent. See [matching controls](matching-constraints.md) for
useful rejected source alternatives.

## Review cleanup and scene-update load flag

CMenuCostumeSel::Draw uses snake_case local names and USER_CHARA_MONICA for
its character comparison. MenuItemCharaDataLoadEndCheckAfter's case label
uses the surrounding switch indentation. The MenuDCMsg and CostumeOptionEnv
source redeclarations are unnecessary: menuaqua.hpp and title.hpp own them.
MenuCharaChangePosDataCfgBuffer already has one static definition and no redundant extern declaration.

MENU_LOAD_INFO byte +7, update_scene, selects main-scene model updates:
CheckLoadBGMonster uses the main scene's stack and character when it is set, the
character/ridepod loaders collect and reload the main scene's characters, and
MenuItemCharaDataLoadEndCheckAfter calls SetupUnitMan for MenuMainScene. The signed-byte
field and separate unk_6 byte retain the eight-byte layout. All menuchr, menusys
and inventmn accesses use the named field. Byte +6 remains unidentified; see
[the layout constraints](matching-constraints.md).

## Native character-menu data

The only retained data markers are at_2595__2 (twelve-byte filename literal), at_2596__3
(nine-byte info.cfg), the two costume/character-change vtables owned by the guarded
initializers, and the distinct four-byte D_01F3C7FC BSS piece. Removing that boundary
shifts following objects; MenuCharaBuild2 owns seven pointers and must not absorb it
through an eighth element.

Public arrays have seven MenuCharaBuild2 pointers, seven MenuActionChara pointers and
twelve signed MenuLoadItemNo halfwords. MenuLoadInfo::update_scene is the signed byte at
+7; +6 remains unk_6. The record stays eight bytes. Memory/read-record labels use
mgCMemory::name and MENU_BGREAD_INFO2::name.

The equipment-phase table is twenty signed halfwords (four characters by five phases);
its monster-mode zeros are declared elements. A 2-D spelling changes address
calculations and fails complete-object checking. MenuItemChrLoad's `(char *)&info->path`
retains the match; using info->path changes six instruction bytes at +0xAC.

The seven monster-book page-format pointers use space for Japanese; Italian and Chinese
reuse English. Family labels have seven-by-twelve pointers (0x150); weakness labels
seven-by-eight (0xE0). Both include distinct Italian rows, Japanese empty labels, and
Chinese English duplicates. Accents preserve [UNI00xx] notation. Badge grid dimensions
are two-integer arrays {4,3}; fourteen weakness/resistance masks own 56 bytes plus eight
alignment bytes. Background slot conversion has four-by-seven signed bytes with negative
absent-slot sentinels. Costume tables remain mutable: a const equipment table changes
loads.

Native aggregates include seven/eight scene-target pointers, six ridepod scene/stack
pointers, nine read-request integers, a 64-byte chrchg0.pac buffer and the signed sound
map {3,3,1,0}. Ridepod memory selectors are 0,1,2,2,3,2; two monster stack pointers both
name MenuActionCharaBuffer[5]. NPC position is {14,0,0,1}; costume IDs are {0,0,0,-1}.
MenuLocalLoop's name pair is {" ",""}; two empty strings preserve masked instructions
but have wrong resolved targets.

Three 128-byte debug lines use {0}; an empty-string spelling creates an unmatched
eight-byte BSS template. Other debug buffers own 512 and 256 bytes. EnterDataMenu owns
the four cost-label pointers as static tbl. Numeric compiler @names are provisional
identities and must not conflict with explicit at_N source names before literal naming.

KeyStep owns plain arrays commands[8], grown[1], names[8] and values[6], plus
convert_table, ghobitbl, get_stringtbl and select_monster_save. The latter static is
declared after case 10 so later steps share it. Its native script literals pool the
closing script with MenuLocalLoop. Class-change rewards fill ten halfwords spanning
ATTACH_USED::status[2] and adjacent attribute[8], matching GetStatusParam's read order;
the separate arrays remain part of shared producers' interface. CameraPoint's four-float
copies remain inherited: replacing them with quadword copies shrinks both KeyStep and
MenuMonsterBoxInit and fails retail matching.

## Monster-box pages and command steps

MOS_SELECT_PAGE identifies key_arg_no: badge movement is page 0, command
processing page 1, and L/R information cycling page 2. Actions 500 and 600
select badge and command pages; action 20 selects status. The status page
fades the information window in.

| Action | Behavior |
| ---: | --- |
| 5 | Play cancel sound |
| 10 | Close with changed-form result |
| 11 | Show cannot-transform script and enter error step |
| 12 | Fill transform choices and enter step 20 |
| 20 | Open status page |
| 30 | Fill class-change choices and enter step 10 |
| 500 | Return to badge selection |
| 600 | Build badge command window |
| 1000 | Close without changing form |

Command steps are 0 for choice, 1 for error, 10 for class choice, 11 for
yes/no, 12 for the change effect, 13 for completion and attach reward,
14 for reward text, 15 for the last-class reward text, and 20 for transform
choices. Class confirmation loads SP_045.snd and mos_chn.chr. A last-class
change additionally awards ghobitbl[select].

The closing script pools with MenuLocalLoop's identical inline literal.
The command-choice and monster-name confirmation arms are braced so their
automatic declarations cannot be bypassed by a later case label.
select_monster_save is declared directly in the step switch after case 10,
with that arm's body nested inside braces: this keeps it visible to steps
12/13 and places its compiler guard at step 10, rather than function entry.

Plain commands[8], grown[1], names[8] and values[6] arrays supply the
aggregate templates. No initializer-only wrapper types are needed.
MOS_SELECT_COMMAND_MSG identifies transform, status and class-change
commands from their scripts. The attach reward uses USED_ITEM_TYPE_ATTACH
and ITEM_DATA_UNK_22. Transform/status/class-change sounds 0x10, 2 and 0x1E
retain numeric IDs because their wider meanings are unestablished.
MENU_LOAD_INFO mode values and GetPartyCharaMessage type values also remain
unnamed across their shared consumers.


## Function-local data ownership

Thirty-two single-consumer statics use their bare retail names inside their
owning functions. `MenuMonsterBoxInit` has two separate `tbl` objects: slot
request flags inside its allocation loop and localized help at function
scope. The background request table `tbl_2483` and its two associated
literals remain file-local because `MenuCharaChangeInit` is guarded.
Shared `menu_debug_select__2` also stays file-local.

The longest-page calculations in `CMenuChrCngMenu::KeyChangeMain` use direct
scans with their established declaration order. The five menu memory
objects are declared in `menuchr.hpp`; saved character position is declared
by its owning `menumain.hpp`. Header size tags use the exact declared retail
function sizes. Monster-book prompt state uses the shared `MENU_ASK_MODE`
values.

The current menuchr object compares 0x11C9B allocated bytes and 4,010 resolved
relocations without findings. The monster-book icon extent and the
unreachable eighth-bit scan arm are described in
[the drawing analysis](midday-book.md).
