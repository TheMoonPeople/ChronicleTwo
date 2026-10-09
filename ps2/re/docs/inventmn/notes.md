# inventmn: reverse-engineering notes

Invention menu ("Invent"): camera photos, ideas ("neta", id < 1000) and scoops (id >= 1000),
the memory-card album, invention recipes and the menu page class. No first-game counterpart
(Dark Cloud 1 has no camera/invention system).

## Function status

Every function of the unit is native C++ except three guarded drafts
(`#ifdef NONMATCHING` ... `INCLUDE_ASM`): `CInventUserData::ResetAddress`,
`CMenuInvent::IsAccessAlbum` and `MenuInventInit`. There is no assembly-only
function. `MenuInventKey`, `CMenuInvent::CalcTex`, `LoadCharaCheck`,
`IsCreateObject`, `UpdataNetaMemoStr`, `GradationStep` and `CalcCursorPosition`
are native and exact; the forms their matches depend on are in
"Matching-dependent source forms" below.

`decompile.sh` cannot recover the jump tables in `MenuInventKey` and
`IsCreateObject` (assembly lines 176 and 861); analysis of those switches uses
the retail instructions directly.

### Guarded functions

- `CInventUserData::ResetAddress` points each of the thirty `USER_PICTURE_INFO`
  records at its `0x2000`-byte row of `photo_work`. Retail recomputes the
  invariant `this + 0xD60` row base inside the eight-way unrolled loop body and
  again before the two-photo remainder; the typed row-pointer draft computes it
  once before the induction setup, so its base setup and two-photo tail differ.
  Only a cast on the decayed `photo_work` array (`(char *) photo_work + index *
  0x2000` or a same-type `(char (*)[0x2000])` cast) keeps the base opaque enough
  to reproduce retail, and such a no-op cast is not accepted as source.
- `CMenuInvent::IsAccessAlbum` runs the memory-card album dialogue (see "Album
  access states"). It constructs `CDC2AlbumData` and `CMemoryCardManager` with
  placement new from `MenuInventMCStack`; the draft copies the allocation result
  to a saved register before testing it for null, where retail branches on `v0`
  and copies in the delay slot, and the draft's frame is `0x10` smaller with
  `this` and the card pointer in exchanged saved registers.
- `MenuInventInit` builds `CMenuInvent` and the menu's `CActionChara` objects
  on `MenuInventStack`, loads the inventory configuration and starts the item
  board. The `CMenuInvent` placement expression and the two effect allocations
  already have retail's branch-before-copy shape; the three character
  allocations copy the result before the branch, as in `IsAccessAlbum`.

### Remaining data markers

- `at_3138`: retail's jump table for the load-stage switch in `IsCreateObject`
  (nine `IsCreateObject` targets and a trailing zero word).
- `at_4354`..`at_4380` except `at_4378`: script and format strings used only by
  the guarded `IsAccessAlbum`.
- `at_5011`..`at_5013`: the three memory-card icon names copied by the inline
  `CMenuInvent` constructor; the constructor is inlined only into the guarded
  `MenuInventInit`, so no native literal is emitted for them.
- `at_5014`..`at_5016`: the configuration file name, image form name and script
  name used only by the guarded `MenuInventInit`.
- `INCLUDE_BSS` `at_3739` and `at_3765`: the zero templates of the two
  `ItemNameList2` locals (`names`, `delete_names`) of `IsAskExtend`. Giving each
  its own case scope changes the function prologue, and value initialization
  does not reproduce the template copies.

All other data of the unit is native: the thirty-four LOCAL objects, sixteen
local aggregates with ordinary initializers (recipe flags, message types, grade
rows and steps, cursor and gift coordinates, item board positions and names,
blank name, card colour, grid codes and creation/exit arguments), twenty-eight
initialized tables, the switch tables and the `CMenuInvent` vtable. The cursor
seed is `{10, 10, 0, 0}`. Shift-JIS text is written with hex escapes. `Tb_2819`
holds seven pointers (entries one and six share one literal) and is followed by
three alignment bytes before `jp_conv_lentbl_2835`. The 53 `scoop_table` rows
keep retail's order and ID/index gaps, with scoop 1015 last. The gift
coordinates in `CalcTex` are `int gift_pos[2] = {0, 0}`, which emits its own
eight-byte zero template; `GetPosMenuItemOnItemBrd` writes both elements.

Header `@size` values are the retail symbol sizes from
`ps2/config/pal/main.symbols.txt`, excluding padding before the next function
(`LoadCharaCheck` 0x4D8, `IsCreateObject` 0x1588, `IsAccessAlbum` 0x13E8,
`UpdataNetaMemoStr` 0x194, `MenuInventKey` 0x824, `CalcTex` 0x139C).

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
this header needs userdata/menusys/memcard, so keeping them here would make an include cycle. All includes are
at the top. Header order (acyclic, each includes only what it needs by value): gamedata < userdata < menusys < savedata < memcard < inventmn.
`CInventUserData() { Initialize(); }` is the inline constructor CUserDataManager's constructor runs.
`itemmenu_chr_rotflag` is defined in `menusys.cpp` and declared `s8` in `menusys.hpp`; inventmn
reaches it through that header. `menu_debug_flag` and `MenuItemCmdArgPos` come from
`menumain.hpp` and `menusys.hpp`. Controller declarations come from `mainloop.hpp`.

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
  are dropped from the count. The photo-name buffer has 0x2480 bytes; `temp_1728` is 33 characters.
- `inventSpiDataTblTop` INVENT_DATA_INFO* (write cursor during DATASET), `invent_num_counter`
  short. `InventTeigiStack` mgCMemory (recipe memory). `MenuInventStack`,
  `MenuInventCharaStack`, `MenuInventMCStack` mgCMemory (initialised by `__sinit`).
- `NetaMemoStr` char*[0x200] (pointers to idea names, copied from `PIC_NAME_INFO::name`),
  `NetaMemoID` short[0x200], `NetaMemoStrNum` short: idea-notebook lines.
- `InventInNetaEffect` CStarDust* (array from `__construct_new_array(.., 0xC, n)`),
  `InventInNetaEffectFlag`/`Num` s8, `InventInNetaEffectNum4` short.
- `Tex_Hatsumei` mgCTexture* (invention memo texture), `InventSubDataReadBGInfo`,
  `rec_board_offset_xtbl` int[10], `invent_color_tbl` u8 RGBA rows used by Gradation*,
  `invent_grade_fff` (.sdata 8 bytes), `debug_invent_*` debug state,
  `menu_invent_command_info_*` command-window state.
- `jp_conv_lentbl_2835` (file-scope static used by `IsCreateObject`) u8[12] = 2,2,2,4,4,8,6,4,6,14,10,6: byte offset of the masked
  character of a proposed Japanese name, by half-length. `Tb_2819` holds the Japanese
  fallback name `うーん` and six `Ummm` entries; `gobitbl_2847` the two Japanese guess suffixes.
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
0 s8 used; 1 u8 is_new (PhotoCheckEnd clears; DrawTakePhoto sets 0/1 both to 1);
2 map_no (SearchMapNo in DngMainDraw; GetMapTitle); 4 npc_no (GetNPCName; 0x104 special);
6 monster_no (GetMonsterName); 8 s16 never read meaningfully (init/copy -1);
A neta_id (<=0 none, <1000 idea, >=1000 scoop); C..13 never touched except by memcpy;
14 pixel pointer (copied to mgCTexture::image[0], a u_long128*; PictureSeiton takes the base
as char*, so typed char*; cast when assigning). Init sets 0,0,-1,-1,-1(8),-1(6),0.
`used` is a signed byte in retail; declaring it `s8` removes signed-byte pointer casts in
the photo paths. `SCOOP_INFO::known` and `obtained` are also signed bytes.

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
`GetPhotoInfo` returns NULL for indices 30 and above, which protects the thirty-slot user
array when `IsAccessAlbum` scans fifty slots.

## CDC2AlbumData (0x64CB0: Initialize memset, GetSaveDataSize)
0 char photo_work[50][0x2000]; 0x64000 USER_PICTURE_INFO[50]; 0x644B0..0x64CB0 unseen.
Its constructor calls `Initialize`, which clears the object and relates the fifty photo
records to their pixel rows.

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
PIC_NAME_INFO: +0 unsigned idea identifier (retail `lhu`), +2 signed `sort_key` (retail `lh`,
assigned from the third picture-name script argument), then `name`.

## CMenuInvent (0xF30, operator new 0xF30 in MenuInventInit; base CBaseMenuClass)
Constructor is inline (MenuInventInit): CBaseMenuClass ctor, vptr = __vt__11CMenuInvent at
0x10C, CGameDataUsed ctor at 0x168, mgCMemory::Init at 0x398/0x53C/0xD48, field inits.
Vtable order (= base): IsCreateObject(int,int), IsMakeObject(int,int), IsAskExtend(int,int),
ItemCmdAfter(int, ITEMCMD_RET_PARA*), InitEnd(), ExitEnd(). The int virtuals return int.
The base's `mode` short at 0x14 uses `MENU_ASK_MODE_*`: 0 idle, 1 opening, 2 closing;
`CBaseMenuClass::ExtendCommand` runs IsCreateObject at 5, IsMakeObject at 6 and IsAskExtend
at 12 (`BootExtendCommand` sets 12); the inventory extensions 13 and 14 call PhotoNetaEnter
and IsAccessAlbum. The layout mode is `key_arg_no` (INVENT_MENU_MODE, below).
Offsets:
- 0x110 photo_only (=1 when MenuCommonInfo+0x50 == 10; runs "picmodeonly"), 0x112 short
  `unk_112`: 1 while the memory-card album opened from an album button is in use (users
  are inside the guarded `IsAccessAlbum`, so it is not renamed).
- 0x114/118 card cursor/top, 0x11C/120 item, 0x124/128 photo, 0x12C/130 album, 0x134/138 notebook
  (ExitEnd stores all ten and 0x392 into CMenuSystemData 0x20..0x3E).
- 0x13C MENUFORM_MAKEBRD_INFO (CalcMakeBrd, CalcCommonBrdDrawInfo).
- 0x1D4 MC_ICON_DATA[3] (names strcpy'd from at_5011..5013; GetPackFile fills data/size;
  `EnterDataMenu` loads the records through `name`, `data` and `size`).
- 0x258 album_enable (GetNumSameItem(0x165) > 0; "ALBUM_OFF" otherwise).
- 0x25C/0x260 photo board scroll / scroll bar (CalcTex), 0x264 float[30][2] slot positions
  (x = (i&1)*0x58+8, y = (i/2)*0x36+0x68), 0x358 notebook scroll.
- 0x370 float[4] zero vector, 0x380.. 128.0 x3, 0x394 u_int* sound data for MenuSePlay.
- 0x398 mgCMemory (MenuDataAnalyze), 0x3C8 mgCTexture*[30] photo_tex, 0x440 mgCTexture*[50]
  album_tex (AttachPictTex), 0x508 s8[50] album_flag (positive selected, -1 transferred).
- 0x53C mgCMemory chara memory (0x558/0x560 written as mgCMemory fields in LoadCharaCheck).
- 0x574 CActionChara* model of built item, 0x57C = &recipe->material, 0x580 build stage,
  0x582 built item id, 0x5E4..0x5F0 floats of the bob animation (0x5E8 scale).
- 0x60C neta_select_num, 0x610 int[3] index, 0x61C s8[3] `neta_select_type` (0 photo,
  1 notebook), 0x61F s8[3] `neta_select_state` (-1/0/1), 0x622 s8[3] `unk_622` (only CalcTex
  reads it, non-zero flashes the idea in the selection circle; nothing stores non-zero);
  0x628 = 40.0.
- 0x630 MENU_BGREAD_INFO-like pointer (GetReadBGInfo), 0x634 load stage (0,1,2,-1),
  0x638 CActionChara* (built in LoadCharaCheck), 0x63C CActionChara*, 0x648 = -0.628.
- 0x650..0x68C floats set in MenuInventInit; 0x670/0x680 two float[4].
- 0x690 int[50][2]: `menu_randam_line_draw_postbl` points here (GenarateRandamLine writes 50
  points). 0x820..0xD48 no access found.
- 0xD48 mgCMemory (IsCreateObject), 0xD78/0xD7C ints (album memory-card progress).
- 0xEAC gradation mode, 0xEB0 int, 0xEB4..0xEB6 flags.
- 0xEB8..0xF28 forms/parts from AttachFormInfo (see header); 0xEFC, 0xF0C, 0xF2C not touched.
  Part pointers returned by GetPartInfo use menudraw.hpp's MENUFORMPARTS_TYPE.
- `create_photo_name` is `char[32]`.

## CStarDust
The type is declared by menudraw.hpp. Its native constructor at 0x2082C0
clears active and is called by `__construct_new_array` in PhotoNetaEnter.
Its asserted size is 0xC.

## Function behaviour

- `GradationStep` advances the two success-flash strips by four pixels in mode 1. In mode 3 it
  moves the first three effect parameters of both strips by two toward the colour table row for
  `create_step`, alternating the row for the second effect. It uses `MENU_PARTS_EFFECT_STRUCT1`.
  `GradationSet` writes 224.0f directly to each part's y coordinate.
- `CalcCursorPosition` selects cursor coordinates by the active layout (`key_arg_no`), including
  the idea board, card and photo lists, item board, album and notebook. It takes frame dimensions
  and offsets from the menu layout table, hides the frame for special `photo_only` states, and
  can snap the cursor to its new position via `cursor_snap`.
- `MenuInventKey` passes `MENU_MODE_INVENT` to `StepMainMenuIconMove` (each sub-menu passes its
  own `MenuModeID`). The inventory debug key is `MENU_PUSH_BUTTON_SELECT` (0x20);
  `MenuCheckPushButton` maps `PAD_START` to 0x10 and `PAD_SELECT` to 0x20.
- `UpdataNetaMemoStr` gathers known ideas, separates identifiers below 1000 from the others,
  repeatedly sorts both ranges with `neta_sort` until stable, and clears the unused list tail.
  `neta_sort` sorts one half-open range of the discovered idea list, exchanging each entry's
  name pointer, sort key and signed halfword idea identifier together; both supported mode
  values use the same ascending key comparison and the return flag records whether any pair
  was swapped.
- `LoadCharaCheck` (0x2022A0) advances the preview character's asynchronous load. State zero
  detaches the displayed character, requests its equipped model, clears the auxiliary character
  and starts `menu/chara4/camera.pac` when the photo-only mode needs it; the background-file
  reservation uses the unsigned byte-to-quadword round-up. State one waits for background I/O,
  completes the main character's model, restores the hat attachment and disables lighting on its
  object frame (`CObjectFrame::frame`, the inherited pointer, not `CCharacter2`'s animation
  frame). If the camera pack exists it resets the character stack, uses the `_mn` texture
  suffix, loads `c01_camera.chr`, constructs the auxiliary `CActionChara`, loads `camera.chr`
  with the main character as parent, attaches it at `ef00` and selects the camera-standing
  motion. The main character is positioned at (15,-29,14) for photo-only mode without the
  album, or (20,-29,14) otherwise, takes the existing rotation, advances once, runs the
  thinking-mode script and is attached to the polygon form. State two keeps stepping the
  character; state -1 does nothing.
- `IsCreateObject` (0x203E90) is the asynchronous invention-result update. The first state
  confirms or cancels invention: a positive item ID marks the selected recipe as created;
  otherwise it searches the recipe table, skips created items, compares the three required
  idea IDs with the three selected slots and records the matched slots in `int found[3]`;
  two matches select the partial-result path and identify the missing slot (the table pointer
  and signed count are re-read on each iteration). The display states wait for the background
  model and character sequence, select the success, partial-result or failure script and attach
  the result model to its polygon form; successful items use a scaled rotating model with a
  damped sine wobble (step -0.02f); partial results mask the guessed idea name (one two-byte
  character at `jp_conv_lentbl_2835[half_length - 1]` replaced by 0x81 0x9A, name terminator
  kept) and blink the missing message line; the unnamed-photo fallback is the inline `うーん`
  (`82 A4 81 5B 82 F1`) with `Tb_2819` as the localized fallback. The jingle state schedules
  the message, restores menu music and finally allows confirmation/cancellation to reset the
  forms, effect pointer, circle, cursor and gradation. A second state machine advances
  background I/O: it loads the thinking character plus `menu/inventsub.pac` (the path buffer is
  `char path[64] = "menu/chara4/"` followed by `c01_success.chr`, `c01_regret.chr` or
  `c01_failure.chr`), preserves the menu character's position and rotation while replacing its
  pack, and creates the result effect from `inv_ng.mds` or `inv_ok.mds` (lighting off, RGBA
  255,255,255,128, placed at (18,-20,20)); success also allocates and loads the item character.
  Later states read the selected sound bank (SP_008/SP_009, wave suffixes 200/190/180,
  `sndtimetbl_2868` 210/280 frames), initialise the sound port and open/play/close the result
  stream. The second serialized file is addressed after the first file's 16-byte boundary,
  which is genuine file-buffer traversal.

### Album access states (`IsAccessAlbum`, 0x2082D0)

The function checks the slot prompt message, reads selection/button input, steps the card
manager, then caches pointers to the current valid card (ports zero and one only) and error
record. Only `CDC2AlbumData` (0x64CB0 bytes, 0x64CD quadwords) and `CMemoryCardManager`
(0x1100 bytes, 0x112 quadwords) are allocated here; the card records (`MC_CARD_INFO[2]` at
manager +0xD5C, stride 0x20), the error record (`MC_ERROR_INFO` at +0x4D0, 0x14 bytes) and
the port word (+0x4C8) live in the manager. The fifty-iteration user-photo loop is genuine
(`GetPhotoInfo` returns NULL beyond thirty). The loading message takes the DLOAD form's X/Y,
shifts Y by 26, steps the message and centres it with the updated Y.

| States | Work |
| --- | --- |
| 0, 1, 2 | Select a port, allocate album/manager storage, search the card and choose load/save/format handling |
| 3, 5, 6 | Check an existing album, report load progress and finish the loaded-album prompt |
| 100, 110 | Acknowledge load/card/capacity error prompts |
| 200..203 | Confirm saving, select/save-check the port, search and determine whether an album already exists |
| 205, 206 | Report write progress, bind resulting album textures and acknowledge completion |
| 220, 230 | Confirm exit/recovery or new-album creation |
| 231, 232 | Search before creating an album directory and report its progress |
| 240, 241 | Count user space and selected album photos, copy valid records/images, or acknowledge insufficient space |
| 250, 300, 301 | Acknowledge cancellation/card/save messages and offer recovery when leaving |
| 500..503 | Confirm format, search/format, report the result and resume the relevant prompt |

Source forms that reproduce retail's instruction windows for this function (the guarded
draft does not use all of them): runtime state variables declared at function entry with
their assignment order kept; the four positive tests on the recover-photo count and the
selected album flag written `0 < value`, and the two up-key cases as `move--` after zero
initialization (down increments, so both bits cancel); the loading coordinates as one
`int[2]` passed to the two-reference `GetPutPosXY` with Y used after `StepMsg`; and the
capacity test `MCManagerPtr->GetSaveDataSize(MC_SIZE_SAVE_KB) + 2 > card->free_size`, which
emits the call before the card capacity load.

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
  lets the function index its material and output arrays directly.
- `CountNeta`, `CountScoop`, `CalcPhotoExp`, and `LevelCheck` scan or update
  `CUserDataManager::photo_subject[0x200]` with typed short-array indexing.
- `PrepareNextMode` uses `CMenuKeyFunc::cursor_form` at offset 0x138.
  `MenuInventNetaMemoDraw` uses `memo_bar`, `NetaMemoStr[i]`, and `NetaMemoID[i]`;
  `MenuInventAlbumPictureDraw` uses `album_tex[i]`, `album_scroll_x`, and successive
  `USER_PICTURE_INFO` records.
- `GradationSet` reads two grade-part names from `invent_grade_fff` with a byte-offset
  loop; an element-index loop changes a shift and the loop increment.
- `IsCreateObject` indexes recipe entries as `&table->table[recipe_index]`. The model
  reservation is a byte count derived from quadwords with the allocator's unsigned
  round-up; replacing it with `Alloc(model_blocks)` changes the code and relocation
  positions. `jp_conv_lentbl_2835[half_length - 1]` is read into an `s8`, which makes
  MWCC emit retail's `lb`; retail addresses the element through `D_003532DF`, the label one
  byte before the table, and no `D_003532DF` data marker is needed.
- `MenuInventDebugDraw` materialises 300.0f, 270.0f and 80.0f for the debug panel
  rectangle in retail's order through binary32 selectors (`0x43960000` evaluate first,
  `0x43870000` evaluate last, `0x42a00000` evaluate first) without occurrence counters.

## Matching-dependent source forms

MWCC register-web facts (see docs/MWCC.md "Register allocation"):

- `MenuInventKey`: one `int index` is shared by the three-slot name-form loop in one switch
  arm and the negative-card padding loop in the other, and the padding assignment from `top`
  comes after the number-X float conversion. The disjoint lifetimes make MWCC colour the
  padding counter after the strength-reduced name/coordinate offsets (card `a2`, offsets
  `a0`/`a1`); giving each loop its own counter permutes the saved and argument registers in
  both loops. Its two list tops are `int tops[2] = {card_top, card_top - 1}`, which emits
  the eight-byte zero template before the runtime stores; the form names `msgbrd`, `msgpos`,
  `msg`, `msg3q`, `msg3p` are inline literals and the switch emits its own jump table.
  Name-line positions use the `SetMovePosGyou` inline.
- `CalcTex`: the background position and clip range are two-element arrays with
  non-constant initialisers (`int bg_pos[2] = {(int) left_top[0], (int) (left_top[1] -
  480.0f)}`, `float clip[2] = {neta_board_form->y, neta_board_form->y + 6.0f + 270.0f}`);
  MWCC copies a zero template and stores each element at a direct stack address. A copy
  from an extern template followed by element assignments keeps element 1's address in a
  register (saved `s7` for the clip bottom, enlarging the frame); a `NetaClipRange` record
  behaves the same way. `bg_form->SetPos(...)` stores the background position (separate
  field writes reload `bg_form`). The memo bar step divides 216.0f. The blink sine
  (`float wave = sinf(...)`) and the shade (`float shade = 128.0f + 64.0f * wave`) are
  separate statements; merging them puts the 128.0f temporary (also stored to
  `neta_color[2]`) in `v0` where retail has 64.0f. The album scroll step (`scroll_step`)
  and scroll target are separate statements before the `bar_y` copy: `bar_y` is
  address-taken, so its store orders every later load, and the named division becomes the
  multiply's first operand. The card bar's `bar_step = 0.0f` is declared after `knob` and
  `hidden`, otherwise `card_max - 5` takes `a0` instead of `v1`. Retail calls the three SDK
  vector routines rather than inlining COP2. One callee-scoped SF row makes
  `CalcMenuAdd(&effect_bob_angle, 3.1415927f / 22.0f, 3.1415927f)` materialise the third
  argument's pi before the second's pi/22.
- `LoadCharaCheck`, `IsCreateObject`: the `CActionChara` objects are constructed with the
  direct placement expression `new (stack->Alloc(StackBlocks(sizeof(CActionChara))))
  CActionChara` under the after-constructor-inline placement conversion; the
  `NewInventActionChara` wrapper consumes an inline level and leaves the base `CObject`
  constructor out of line. Two SF rows order the `SetPosition` constants in `LoadCharaCheck`
  (14.0f before slot one, -29.0f before slot three for the 20.0f call) and one orders 20.0f
  in `IsCreateObject`. The `IsAskExtend` confirmation-name copies keep their shared
  `ItemNameList2` templates (see "Remaining data markers").

## Unresolved
- Meaning of most unk_ fields of CMenuInvent.
- Exact sizes of CInventUserData and CScoopDataManager.
- MenuInventInit third parameter unused in what Ghidra shows.
- LevelCheck / CheckMakeItem / LoadAnalyzeInventFile / GetPhotoNameStr look bool-returning in
  Ghidra; declared int.
- `neta_select_type` 0/1 and `neta_select_state` -1/0/1 appear in nine other functions; an
  enum for them belongs in one change across all of them.

## Layout modes held in key_arg_no

`INVENT_MENU_MODE` names all twelve layouts; `CalcCursorPosition`'s file-scope `wakutype_3203`,
`modecmdtbl_3636` and `nextmodetbl_5183` have one row each. 0, 2, 5, 6 are named from the scripts run in
PrepareNextMode; 3 from SearchNowPosItemExist (MenuUserParam items) / NextDifferentMode.
1 `INVENT_MODE_THINK_ALBUM_BUTTON` and 7 `INVENT_MODE_PHOTO_ALBUM_BUTTON` are the
album-access buttons beside the idea board and photo-only board: CalcCursorPosition places
both on `album_sw_form`, MenuInventPushKey runs `IS_MCACCESS` from both and returns to the
idea or photo board on left navigation. The remaining values:

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
comparisons and `NextDifferentMode`/`PrepareNextMode` targets. The guarded
drafts keep their numbers.
