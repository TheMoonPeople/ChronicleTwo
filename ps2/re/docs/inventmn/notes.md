# inventmn: reverse-engineering notes

## Linked text length

The native drafts of `CMenuInvent::LoadCharaCheck`, `CMenuInvent::IsCreateObject`,
and `MenuInventInit` compile to 0x48C, 0x1568, and 0x1018 bytes, respectively;
retail uses 0x4D8, 0x1588, and 0x1048. Their shorter code shifts the following
linked text by 0xA0 after function alignment. These drafts remain guarded by
`NONMATCHING` and the matching build uses their retail assembly. `UpdataNetaMemoStr` matches with the sorting helper declared local, as in retail.

The matching build also selects retail gaps for `ResetAddress` and
`IsAccessAlbum`; those functions have guarded C++ drafts.
`MenuInventKey` and `CalcTex` are native and exact (see [night-20261008.md](night-20261008.md)).
The other invention-menu functions remain native C++ where already matched.

Invention menu ("Invent"): camera photos, ideas ("neta", id < 1000) and scoops (id >= 1000),
the memory-card album, invention recipes and the menu page class. No first-game counterpart
(Dark Cloud 1 has no camera/invention system).

## Header dependencies
`inventmn.hpp` includes, for by-value types:
- `menusys.hpp`   -> `CBaseMenuClass` (base of `CMenuInvent`; size 0x110, vptr at 0x10C,
  `__vt__14CBaseMenuClass` has the same six slots).
- `userdata.hpp`  -> `CGameDataUsed` (member at 0x168; size 0x6C from `MenuUserParam` stride 0x6C
  in `SearchNowPosItemExist` and the 0x1D4 next field).
- `memcard.hpp`   -> `MC_ICON_DATA` (array of 3 at 0x1D4; 0x28 each, `SetIconData` memcpys 3x0x28).
- `menudraw.hpp`  -> `MENUFORM_MAKEBRD_INFO` (0x2C, `Init_MENUFORM_MAKEBRD_INFO` memsets 0x2C).
`CInventUserData`, `CScoopDataManager`, `USER_PICTURE_INFO`, `INVENT_CREATED_ITEM` and `SCOOP_INFO` are
declared in `userdata.hpp` (functions still here): CUserDataManager holds CInventUserData by value and
this header needs userdata/menusys/memcard, so keeping them here made an include cycle. All includes are
now at the top. Header order (acyclic, each includes only what it needs by value): gamedata < userdata < menusys < savedata < memcard < inventmn.
`CInventUserData() { Initialize(); }` is the inline constructor CUserDataManager's constructor runs.

## Globals
Every data symbol of the unit is LOCAL in retail (`local_symbols.tsv`), so the header has no
`extern`s; declare them `static` in the `.cpp`. What they are:
- `InventUserDataPtr` CInventUserData*, `InventAlbumPtr` CDC2AlbumData*, `InventManagePt`
  CInventDataManage* (points at `InventManageMan`, a CInventDataManage, 8 bytes),
  `MCManagerPtr` CMemoryCardManager*, `CMenuInventPt` CMenuInvent*.
- `pict_seiton_case` s8: sort key PictureSeiton uses next (0 neta_id, 1 map_no, 2 npc_no,
  3 monster_no), cycles 0..3.
- `scoop_table` SCOOP_DATA[53] (.data 0x424). `menu_scoop_str_tag` SPI_TAG_PARAM[2] ("STR"),
  `pic_tag` SPI_TAG_PARAM[3] (PIC_INFO, PIC_NAME), `invent_teigi_func` SPI_TAG_PARAM[3]
  (DATATABLESET, DATASET); each list ends with a null entry.
- `scoop_str_stack`, `PicNameStack` mgCMemory*; `pic_name_info_top` PIC_NAME_INFO*,
  `pic_name_info_num`, `pic_name_info_num_count` short (size 2). Entries with neta_id 30000
  are dropped from the count.
- `inventSpiDataTblTop` INVENT_DATA_INFO* (write cursor during DATASET), `invent_num_counter`
  short. `InventTeigiStack` mgCMemory (recipe memory). `MenuInventStack`,
  `MenuInventCharaStack`, `MenuInventMCStack` mgCMemory (initialised by `__sinit`).
- `NetaMemoStr` 0x800, `NetaMemoID` short[0x200], `NetaMemoStrNum` short: idea-notebook lines.
- `InventInNetaEffect` CStarDust* (array from `__construct_new_array(.., 0xC, n)`),
  `InventInNetaEffectFlag`/`Num` s8, `InventInNetaEffectNum4` short.
- `Tex_Hatsumei` mgCTexture* (invention memo texture), `InventSubDataReadBGInfo`,
  `rec_board_offset_xtbl` int[10], `invent_color_tbl` u8 RGBA rows used by Gradation*,
  `invent_grade_fff` (.sdata 8 bytes), `debug_invent_*` debug state,
  `menu_invent_command_info_*` command-window state.
- Strings (Shift-JIS) are useful: forms "inv_bg","itembrd","ネタ板","makebrd","カードリスト",
  "cardlist","Album_sw","Album_Big","neta0..2","neta0name..2","recbrd","poly_chr0/1",
  "invent_okeff","DLOAD","kakudai_pic"/"pic"; scripts "MSG考察モード","NextToThink",
  "MSG発明製作モード","NextToCardList","NextToAlbumView","NextToPhotoView","picmodeonly",
  "ALBUM_OFF","FORMSWAP0/1","INIT_END"; files "inv_bg.img","edmenu.img","invent.cfg",
  "inv_com.cfg","inv6.lst","menu/inv6.lst","neta2.lst"; "neta%d" texture names.

## Local (static) functions
_SCOOP_STR, _PIC_INFO, _PIC_NAME, CheckPhotoFlag, _INVENT_DATATABLESET, _INVENT_DATASET,
neta_sort, MakeMsgNetaName, PictureMemoOne, MenuInventDebugKey, MenuInventDebugDraw,
MenuInventPushKey. Not in the header. Signatures: SPI tags `int f(SPI_STACK *, int)`;
`int CheckPhotoFlag()`; `int neta_sort(int,int,int,int*)`;
`void MakeMsgNetaName(CDC2Mes*, CMenuPosDataForm*, USER_PICTURE_INFO*, int*, int)`;
`void PictureMemoOne(float,float,int)`; `int MenuInventDebugKey()`; `void MenuInventDebugDraw()`;
`int MenuInventPushKey(int,int)`.

## USER_PICTURE_INFO (0x18; stride in every photo array)
0 u8 used; 1 u8 is_new (PhotoCheckEnd clears; DrawTakePhoto sets 0/1 both to 1);
2 map_no (SearchMapNo in DngMainDraw; GetMapTitle); 4 npc_no (GetNPCName; 0x104 special);
6 monster_no (GetMonsterName); 8 s16 never read meaningfully (init/copy -1);
A neta_id (<=0 none, <1000 idea, >=1000 scoop); C..13 never touched except by memcpy;
14 pixel pointer (copied to mgCTexture::image[0], a u_long128*; PictureSeiton takes the base
as char*, so typed char*; cast when assigning). Init sets 0,0,-1,-1,-1(8),-1(6),0.

The compiled `Init_USER_PICTURE_INFO` stores these seven fields separately and leaves the
pixel pointer and unused bytes alone. `CDC2AlbumData::DeletePhotoData` accepts slots 0..49
and clears their metadata through this initializer. `CInventUserData::AddShutterNum`
clamps the running shutter count to 0..99999. `CScoopDataManager::SetViewFlag` changes
the first byte (`known`) only when `GetScoopInfo` finds the requested scoop.

## CInventUserData (save data + 0x251D0; CUserDataManager + 0x7F30)
0 shutter_num (AddShutterNum clamps 0..99999); 4 level (= CalcPhotoExp/100; GetLevel +1);
8 short neta_id[0x200]; 0x408 USER_PICTURE_INFO photo[30]; 0x6D8 INVENT_CREATED_ITEM[0x100]
(Initialize zeroes both shorts; only item_id is read); 0xAD8 CScoopDataManager
(`ScoopMan` = savedata + 0x25CA8, CShopMenu passes userdata + 0x8A08); 0xCD8..0xD60 unseen;
0xD60 photo_work[30][0x2000] (Initialize memsets 0x3C000).
0x3CD60..0x3CE60 unseen (unk_3cd60). Size 0x3CE60 is inferred from the containing
CUserDataManager: its next field (party_member) is at 0x44D90 = 0x7F30 + 0x3CE60 and nothing
there touches the 0x100 bytes in between; no inventmn code reaches past 0x3CD60.
CScoopDataManager: SCOOP_INFO[0x80] (index <= 0x7F, total loop 0x80); size not asserted
(the 0x88 bytes after it may belong to it).
TranslateInventUserData: source (older save, buffer + 0x25250) has 12-byte created-item
records; copies the first two shorts of each of 128 into 4-byte records of the destination.
Called from CMemoryCardManager::LoadFromMc when the version string matches an older one.
Photographed-ideas list lives in CUserDataManager + 0x44DD0 (short[0x200]), not here.

## CDC2AlbumData (0x64CB0: Initialize memset, GetSaveDataSize)
0 char photo_work[50][0x2000]; 0x64000 USER_PICTURE_INFO[50]; 0x644B0..0x64CB0 unseen.

## SCOOP_DATA (0x14; table 53 rows)
0 scoop_id, 2 flag_no (CheckBitFlagMenu), 4 s8 info_no (CScoopDataManager index), 8 char* text
(set by STR tag), C and 10 zeroed by InitScoopString, never read here.

## CInventDataManage (8; InventManageMan size 8)
0 short num; 4 INVENT_DATA_INFO* table. Constructed by hand on the stack in CheckInventItem
and CheckItemTable (no constructor).
INVENT_DATA_INFO (0x24, stride in GetInventDataInfoByItemID): 0 item_id (-1 unset), 2 neta[3],
8 INVENT_MATERIAL*, C material_num ((argc-9)/2), 10 short read from DATASET, 14/18/1C model
position (passed to the created model's vfunc 0x14), 20 scale (CMenuInvent 0x5E8).
DATASET float order: arg -> 0x20, then 0x14, 0x18, 0x1C.
INVENT_MATERIAL (4): short item_id, u8 num.
HowMuchZairyouMakeItem result: int count, then {int item, int need}[4].
CheckInventEnable returns item_id or -1 (short), sets *near_match when >= 2 ideas match.
Struct names INVENT_DATA_INFO, INVENT_MATERIAL, INVENT_CREATED_ITEM, SCOOP_DATA, SCOOP_INFO,
PIC_NAME_INFO are not retail (no symbol); chosen from the accessor names.

## CMenuInvent (0xF30, operator new 0xF30 in MenuInventInit; base CBaseMenuClass)
Constructor is inline (MenuInventInit): CBaseMenuClass ctor, vptr = __vt__11CMenuInvent at
0x10C, CGameDataUsed ctor at 0x168, mgCMemory::Init at 0x398/0x53C/0xD48, field inits.
Vtable order (= base): IsCreateObject(int,int), IsMakeObject(int,int), IsAskExtend(int,int),
ItemCmdAfter(int, ITEMCMD_RET_PARA*), InitEnd(), ExitEnd(). The int virtuals return int.
Mode is the base's short at 0x14 (INVENT_MENU_MODE). 0, 2, 5, 6 named from the scripts run in
PrepareNextMode; 3 from SearchNowPosItemExist (MenuUserParam items) / NextDifferentMode;
4 and 8 also occur (NextDifferentMode) but their page is not established.
Offsets:
- 0x110 photo_only (=1 when MenuCommonInfo+0x50 == 10; runs "picmodeonly"), 0x112 short.
- 0x114/118 card cursor/top, 0x11C/120 item, 0x124/128 photo, 0x12C/130 album, 0x134/138 notebook
  (ExitEnd stores all ten and 0x392 into CMenuSystemData 0x20..0x3E).
- 0x13C MENUFORM_MAKEBRD_INFO (CalcMakeBrd, CalcCommonBrdDrawInfo).
- 0x1D4 MC_ICON_DATA[3] (names strcpy'd from at_5011..5013; GetPackFile fills data/size).
- 0x258 album_enable (GetNumSameItem(0x165) > 0; "ALBUM_OFF" otherwise).
- 0x25C/0x260 photo board scroll / scroll bar (CalcTex), 0x264 float[30][2] slot positions
  (x = (i&1)*0x58+8, y = (i/2)*0x36+0x68), 0x358 notebook scroll.
- 0x370 float[4] zero vector, 0x380.. 128.0 x3, 0x394 u_int* sound data for MenuSePlay.
- 0x398 mgCMemory (MenuDataAnalyze), 0x3C8 mgCTexture*[30], 0x440 mgCTexture*[50] (AttachPictTex),
  0x508 s8[50] album flags (-1 empty).
- 0x53C mgCMemory chara memory (0x558/0x560 written as mgCMemory fields in LoadCharaCheck).
- 0x574 CActionChara* model of built item, 0x57C = &recipe->material, 0x580 build stage,
  0x582 built item id, 0x5E4..0x5F0 floats of the bob animation (0x5E8 scale).
- 0x60C neta_select_num, 0x610 int[3] index, 0x61C s8[3] type (0 photo, 1 notebook), 0x61F s8[3],
  0x622 s8[3]; 0x628 = 40.0.
- 0x630 MENU_BGREAD_INFO-like pointer (GetReadBGInfo), 0x634 load stage (0,1,2,-1),
  0x638 CActionChara* (built in LoadCharaCheck), 0x63C CActionChara*, 0x648 = -0.628.
- 0x650..0x68C floats set in MenuInventInit; 0x670/0x680 two float[4].
- 0x690 int[50][2]: `menu_randam_line_draw_postbl` points here (GenarateRandamLine writes 50
  points). 0x820..0xD48 no access found.
- 0xD48 mgCMemory (IsCreateObject), 0xD78/0xD7C ints (album memory-card progress).
- 0xEAC gradation mode, 0xEB0 int, 0xEB4..0xEB6 flags.
- `GradationStep` advances the two success-flash strips by four pixels in mode 1. In mode 3 it
  moves the first three effect parameters of both strips by two toward the colour table row for
  `create_step`, alternating the row for the second effect. The native function
  uses `MENU_PARTS_EFFECT_STRUCT1` and is exact.
- `CalcCursorPosition` selects cursor coordinates by the active layout (`key_arg_no`), including
  the idea board, card and photo lists, item board, album and notebook. It takes frame dimensions
  and offsets from the menu layout table, hides the frame for special `photo_only` states, and
  can snap the cursor to its new position via `cursor_snap`. Its native body is exact.
- 0xEB8..0xF28 forms/parts from AttachFormInfo (see header); 0xEFC, 0xF0C, 0xF2C not touched.
  Part pointers returned by GetPartInfo use menudraw.hpp's MENUFORMPARTS_TYPE.

## CStarDust
The type is declared by menudraw.hpp. Its native constructor at 0x2082C0
clears active and is called by `__construct_new_array` in PhotoNetaEnter.
Its asserted size is 0xC.

## Typed access and code generation
- `GetInventUserDataPtr` reaches the embedded invention data through the existing
  `CSaveData::GetUserDataManager()` and `CUserDataManager::GetInventUserData()` accessors.
  MWCC inlines both and retains the retail two-addition address calculation; a single
  nested field expression combines the offsets and changes the object code.
- `CDC2AlbumData::RelateAlbumPicData`, `GetPhotoName`, and
  `CMenuInvent::GetNowSelectNetaID` accept typed photo-array access without changing
  their retail instructions. The latter keeps a named typed photo pointer so MWCC
  emits the retail operand order for the final address addition.
- `CMenuInvent::InitNetaCircle` uses `neta_select_index`, `neta_form`, and
  `neta_name_form` arrays for its three slots; typed indexing matches retail.
- `HowMuchZairyouMakeItem` has an `int *` output parameter in its retail ABI,
  but the pointed-to storage is `MakeItemNeeds`. A single cast to that record
  lets the function index its material and output arrays directly; the typed
  implementation remains a complete match.
- `CountNeta`, `CountScoop`, `CalcPhotoExp`, and `LevelCheck` scan or update
  `CUserDataManager::photo_subject[0x200]`. Typed short-array indexing preserves
  each function's retail instructions and removes the integer pointer casts.
- `USER_PICTURE_INFO::used` is a signed byte in retail. Declaring it `s8`
  removes the signed-byte pointer casts in photo paths without changing the
  matched functions; `SCOOP_INFO::known` and `obtained` were already signed bytes.
- `CMenuInvent::EnterDataMenu` loads the three `MC_ICON_DATA` records through
  their `name`, `data`, and `size` fields. Typed field access preserves retail.
- `PrepareNextMode` uses `CMenuKeyFunc::cursor_form` at offset 0x138; typed
  field access preserves retail. `MenuInventNetaMemoDraw` uses `memo_bar`,
  `NetaMemoStr[i]`, and `NetaMemoID[i]`; `MenuInventAlbumPictureDraw` uses
  `album_tex[i]`, `album_scroll_x`, and successive `USER_PICTURE_INFO` records.
  Both drawing functions remain complete matches.
- `GradationSet` reads two grade-part names from `invent_grade_fff`. Typed
  indexing converts the byte-offset loop to an element index, changing a
  shift and the loop increment; the historical typed-index probe scored
  99.096% and was not retained.
- `UpdataNetaMemoStr` indexes `PIC_NAME_INFO` records directly and matches
  retail with the file-local `neta_sort` definition described below.
- `CInventUserData::ResetAddress` unrolls eight photo pointers per iteration. A
  typed, indexed `photo_work` row pointer now matches the unrolled body, with
  thirteen words remaining in base setup and the final two-photo tail. Direct
  `&photo_work[index][0]` indexing scores 60.0%, while the previous byte-offset
  expression scored 99.583336% but used raw pointer arithmetic. The typed draft
  remains under `NONMATCHING`; the matching build uses retail assembly.
  A private native compile of the explicit eight-assignment loop scored 34.0208%
  and emitted 0x108 bytes; a typed row pointer advanced by eight scored 55.8958%
  and emitted 0xA8 bytes. Neither variant is kept in the source.

## Unresolved
- Meaning of most unk_ fields of CMenuInvent; mode values 4 and 8.
- Exact sizes of CInventUserData and CScoopDataManager.
- MenuInventInit third parameter unused in what Ghidra shows.
- LevelCheck / CheckMakeItem / LoadAnalyzeInventFile / GetPhotoNameStr look bool-returning in
  Ghidra; declared int.

## Invention memo sorting linkage

`neta_sort` sorts one half-open range of the discovered idea list, exchanging each entry's name value, sort key and signed halfword idea identifier together. Both supported mode values currently use the same ascending key comparison, and the return flag records whether any pair was swapped. The helper is file-local and defined before `CMenuInvent::UpdataNetaMemoStr`. This linkage lets MWCC retain the unchanged sort-key pointer in the caller-saved argument register between the two range sorts. `UpdataNetaMemoStr` gathers known ideas, separates identifiers below 1000 from the other identifiers, repeatedly sorts both ranges until stable, and clears the unused list tail. Its native 404-byte body now has zero differing instruction or relocation fields in the PAL checker; no data or caller interfaces change.

## Debug inventory floating argument calibration

`MenuInventDebugDraw__Fv` uses stable binary32 selectors for 300.0f
(`0x43960000`, evaluate first), 270.0f (`0x43870000`, evaluate last), and
80.0f (`0x42a00000`, evaluate first). These preserve retail's materialization
order for the debug panel rectangle without occurrence counters. With the
artificial division primer removed and helper masks GPR `0x30` / FPR `0`, the
complete unit passes canonical bytes and resolved relocations: `0xFF38` checked
bytes and 2,786 relocations.

## Native notebook promotion and pointer types

The previously documented exact UpdataNetaMemoStr body remained behind a
NONMATCHING guard. A fresh m2c analysis and private native promotion confirm
that it passes the whole-unit PAL checker (0xFF2C bytes, 2,794 relocations).
NetaMemoStr holds pointers to idea names, not integer identifiers; its
producer copies PIC_NAME_INFO::name, its sorter exchanges pointers, and its
draw consumer supplies the name to the formatted label. These consumers now
use char pointers directly without a pointer-to-integer cast.

PIC_NAME_INFO offset +2 is the signed sort_key read by the notebook sorter
and assigned from the third picture-name script argument. Its idea identifier
at +0 remains unsigned: retail uses lhu for that field, while sort_key uses
lh. The native notebook function occupies 0x194 bytes; the old 0x1A0 header
size included more than the symbol's actual extent.

Canonical normal and objdiff-base builds also pass after the type and field
updates: 0xFF2C checked bytes and 2,794 relocations, with standard project
objdiff reporting 100% for the native 404-byte UpdataNetaMemoStr.

## Native MenuInventKey and CalcTex

MenuInventKey is native and exact at 0x824 bytes. Its shared counter is
reused across the name-form and card-padding arms; those disjoint lifetimes
preserve retail's induction register allocation. The native literals, list-top
initializer and switch table are supplied entirely by C++; name-line
positions use the existing SetMovePosGyou inline. See the promotion in
[night-20261008.md](night-20261008.md) and the data cleanup in
[review-fixes-20261008.md](review-fixes-20261008.md).

`CalcTex__11CMenuInventFv` is native and exact (declared body 0x139C,
aligned reservation 0x13A0). The background position and clip range
are two-element arrays with non-constant initialisers. The compiler copies
their zero templates (`at_3363`, `at_3379`) and stores the elements
directly. The memo bar step divides 216.0f. The album scroll target and its
step are computed before the `bar_y` copy. One callee-scoped SF row
evaluates pi first for `CalcMenuAdd`. Retail calls the three SDK vector
routines rather than inlining COP2. Details and probes are in
[night-20261008.md](night-20261008.md).

## Remaining guarded functions

The draft checker compares relocated instruction words against each manifest
extent, including alignment padding. The following functions remain guarded.

- `ResetAddress__15CInventUserDataFv`: 13/48 words differ, both 0xC0 bytes.
  A typed, indexed row pointer restores the exact eight-assignment unrolled
  body; its invariant-base setup and two-photo remainder still differ. The
  previous direct indexing was 34/48. No row-pointer induction or shared
  flat-buffer type change is retained; see [midday.md](midday.md).
- `LoadCharaCheck__11CMenuInventFv`: 190/312 words differ, 0x48C native bytes
  against retail's 0x4E0 extent. Retail's placement new branches on `v0` at
  0x00202528 and copies its result into `s4` in the delay slot at 0x0020252C.
  The draft copies first (offset 0x288), then branches on `s4` (offset 0x28C).
  The constructor expansion is also shorter. Reconsider after the dedicated
  placement-new lane supplies a compliant matching form and the shared
  `CActionChara` constructor chain reproduces the retail expansion.
- `MenuInventInit__FP9mgCMemoryPii`: 606/1044 words differ, 0x1018 native bytes
  against retail's 0x1050 extent. The first character allocation branches on
  `v0` at 0x0020B79C with the copy to `s1` at 0x0020B7A0; the draft copies
  to `s0` at offset 0x7EC before branching at 0x7F0. The same mismatch recurs
  for the next two character allocations. The direct `CMenuInvent` placement-new
  expression already preserves the retail branch-before-copy shape at
  0x0020B024/0x0020B028, as do the two effect allocations; those are useful
  comparisons for the dedicated allocation research. Reconsider after that
  lane resolves character allocation and the shared constructor chain.
- `IsCreateObject__11CMenuInventFii`: 380/1380 words differ, 0x1568 native bytes
  against retail's 0x1590 extent. Its two character allocations have the same
  placement-new branch/copy pairs at 0x00204E04/0x00204E08 and
  0x0020500C/0x00205010. Reconsider after the dedicated allocation result and
  shared constructor chain are resolved.
- `IsAccessAlbum__11CMenuInventFv`: 1080/1276 words differ, 0x13D0 native bytes
  against retail's 0x13F0 extent. The album allocation branches on `v0` at
  0x00208608 with the copy to `s2` in the delay slot at 0x0020860C. The draft
  copies to `s1` at offset 0x32C, then branches at 0x330 and inserts a nop.
  Its stack frame is 0x140 bytes rather than retail's 0x150. Reconsider after
  the dedicated placement-new result, then recheck local lifetimes and scheduling.
`decompile.sh` cannot recover the jump tables in `MenuInventKey` and
`IsCreateObject` at assembly lines 176 and 861, respectively. The instruction
findings above use their retail assembly directly; no jump-table metadata or
assembly was modified.

## Midday remainder measurements

[midday.md](midday.md) records the retained ResetAddress and MenuInventKey
improvements, rejected CalcTex local-layout probes, and the natural-constructor
condition for revisiting the four placement-new remainders. CalcTex has
since been matched together with MenuInventKey; five guards remain.

## Midday round 1

[round1.md](round1.md) records the new small-remainder probes and the retained
13/48-word ResetAddress draft. The row pointer is declared before the real
photo index and assigned after its initialization. The native unrolled body
remains exact; the invariant-base setup and two-photo tail still differ.
That midday checkpoint had MenuInventKey at 8/524 and seven guards.
Its later promotion supersedes that remainder; five guards now remain.

## October 8 near-miss wave

[nearmiss-20261008.md](nearmiss-20261008.md) records the new linkage,
local-data, index-width, initialization-order and compiler-control probes.
That near-miss wave retained 8/524 for MenuInventKey and 13/48 for
ResetAddress without a promotion. MenuInventKey is now native; the
ResetAddress remainder remains current.

## Layout modes held in key_arg_no

`INVENT_MENU_MODE` names all twelve layouts; `wakutype_3203`, `modecmdtbl_3636`
and `nextmodetbl_5183` have one row each. The values without an earlier name:

- 4 `INVENT_MODE_THINK_WITH_ALBUM`: the idea board while the album is open. The
  board's down move from the arrow returns here instead of 0 when `unk_112` is 1;
  its right edge leads to the album (`nextmodetbl_5183[4]` = 5) and the album's
  left edge back to 4; MenuInventKey places the photo name with the album's
  `msgpos` as for 5; its command row offers `INVENT_CMD_TO_ALBUM`.
- 8 `INVENT_MODE_MEMO_BUTTON`: cursor on the closed idea notebook
  (`neta_board_form` part ネタ帳位置); closing the notebook selects it and down
  leads to 10.
- 9 `INVENT_MODE_MEMO_LIST`: the notebook's word list (`memo_cursor`,
  `GetNetaMemoCursorPosition`); moving above the first word leads to 11, and
  `K_COMMAND_SET_CIRCLE` takes the circled idea from the notebook here.
- 10 `INVENT_MODE_MEMO_ARROW`: the arrow between board and notebook
  (ネタ帳矢印), reached by moving up from the board's top row; up leads to 8,
  down back to the board.
- 11 `INVENT_MODE_MEMO_CORK`: the opened notebook's cork tab (`neta_memo_form`
  part コルク); opening the notebook selects it and down leads to 9.

Every matched function uses these enumerators in its `key_arg_no` switches,
comparisons and `NextDifferentMode`/`PrepareNextMode` targets; the object
is unchanged (`.private/fixes-r3c/b3-*.log`). The guarded drafts keep their
numbers.
