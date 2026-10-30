# Records

## Handoff

Done (stream `records`, branch `s/records`):

- 57 records carry `PORT_RECORD_ASSERT(sizeof(T) == N)` beside their `STATIC_ASSERT`; all hold on PC, and `scripts/port/records.py --build port/build/pc --require-clang` (ctest `Records.Check`) proves sizes and the absence of pointer, `uptr`/`sptr` and vtable members.
- `funcdata::name` is `u32`: it is zero in every disc script and retail never resolves it, and as `char *` it moved `local`/`arg` to 16/20 on PC. This is the one pointer-typed declaration changed, a documented exception to the rule that pointer-typed declarations never change, approved because the field is a 32-bit word on the disc that is always 0 and never resolved.
- `CVillagerMngr::GetAppearVlgr` (port/src/villagermngr.cpp) indexes `place[alternative][time]` and the output arrays; retail's 4-byte strides are kept in ps2/src because the index form changed MWCC's code.
- `_GET_INDEXOBJ_SIZE` (port/src/runscript_opcodes.cpp) indexes `entry_object`; retail sums the address into an `int`.
- `SetEffectScript` (ps2/src/effscript.cpp) sizes its call data by `sizeof(RS_CALLDATA) * 2 / 16`, byte-identical on the PS2.
- memcard.cpp sizes the save, album and omake images by sizeof; `runscript.cpp`'s stack dump prints strings through `val.s`.
- The 535 runtime structs were rechecked through their 407 cast sites: no new records.

Left:

- `CMenuItemInfo::ExitEnd` (`ps2/src/menusys.cpp:6860`) reads `MenuCommonInfo->cursor` as a `void *` and truncates it; the plain read is not byte-identical, so it needs an override by the menus' owner. The value is right on little-endian hosts.
- Save images are host layout on PC; `USER_PICTURE_INFO::image` comes back from the card stale until `CInventUserData::ResetAddress` (`ps2/src/inventmn.cpp:843`, called at 6227 and 7079) runs. A reader before menu init would see a stale host address; none was found.
- `mgCVisualFixMDT::DataAssignMDT` (`ps2/src/mg_visual.cpp:610`) stores an address in `mgCFace::packet_tag_word` (`u_int`), a runtime packet field for the mesh owner.

Verify: `./build.sh ps2-pal` then `verify.py -c` (SCES_511.90: OK); Linux gate; `kazarov shell python3 scripts/port/records.py --build port/build/pc --require-clang`; `ctest -R 'Records|Truncations|Uptr'`.

A record is a struct whose instances are read from a file in place (disc file, pack entry, memory-card image). Its layout is the disc's on every host, and its pointer-sized fields stay the 32-bit offsets retail wrote: never `uptr`, never a pointer. Each record carries `PORT_RECORD_ASSERT(sizeof(T) == N)` beside its PS2 `STATIC_ASSERT`: a `static_assert` on PC, nothing on PS2. Offsets are resolved on access (`(u_char *) header + header->x_ofs`) or decoded into a host table by the unit's port file.

Every other struct with a `STATIC_ASSERT` is runtime: built by code, its layout may differ on PC, so its `STATIC_ASSERT` stays compiled out there. Its address-holding integer fields are `uptr`. The parenthesised kind in the last column is the inventory's tag (address, offset, VRAM, VU1, IOP, SPU).

This inventory was made by stream `uptr` and completed by stream `records`. `scripts/port/records.py` checks it against the tree; `--emit` prints the asserts, `--update-lines` refreshes the Declared column after header edits. The PC column says what the PC does: `assert` (disc layout, `PORT_RECORD_ASSERT` beside the `STATIC_ASSERT`), `PS2 only` (never read on PC), `host image` (written and read by the PC in host layout).

## Summary

- Total: 598 `STATIC_ASSERT` rows: 65 records (57 `assert`, 1 `PS2 only`, 7 `host image`), 533 runtime.
- Runtime with address-holding integer fields: 13 of 535.

## Records

| Struct | Size | Declared | Reader | Approach | PC | Offset/address fields |
|---|---|---|---|---|---|---|
| DATA_HEADER | 0xC | `ps2/include/dataread.hpp:77` | dataread.cpp:InitCDFile (fixup loop, line 538); SearchFile (line 220) | PS2 only: `InitCDFile` writes `name` pointers into the loaded index; on PC `InitCDFile`, `LoadFileBG` and `LoadFile2` are overridden and the host index replaces DATA.HD4, so no linked code reads it (records.py gate) | PS2 only | name_offset(int, offset) |
| PACK_ENTRY | 0x4C | `ps2/include/dataread.hpp:133` | ps2/src/dataread.cpp:GetPackFile (name and index overloads) | resolved on access | assert | offset(int, offset); next(int, offset) |
| EditDataParts | 0x24 | `ps2/include/editdata.hpp:190` | memcard.cpp:CMemoryCardManager::LoadFromMc; editdata.cpp:CEditMap::LoadData | none (no pointers) | assert | - |
| EditDataGrid | 0x18 | `ps2/include/editdata.hpp:206` | memcard.cpp:CMemoryCardManager::LoadFromMc; editdata.cpp:CEditMap::LoadData | none (no pointers) | assert | - |
| EditDataHouse | 0x10 | `ps2/include/editdata.hpp:228` | memcard.cpp:CMemoryCardManager::LoadFromMc; editdata.cpp:CEditMap::LoadData | none (no pointers) | assert | - |
| EditDataAnalyze | 0xD0 | `ps2/include/editdata.hpp:253` | memcard.cpp:CMemoryCardManager::LoadFromMc (memcpy of CSaveData; CEditData.analyze member) | none (no pointers) | assert | - |
| EditPlaceLog | 0x4 | `ps2/include/editdata.hpp:266` | memcard.cpp:CMemoryCardManager::LoadFromMc; editdata.cpp:CEditMap::LoadData | none (no pointers) | assert | - |
| CEditData | 0x5510 | `ps2/include/editdata.hpp:446` | memcard.cpp:CMemoryCardManager::LoadFromMc (memcpy of CSaveData.edit_data[]) | none (no pointers) | assert | - |
| FONT_TBL_BIN | FONT_TBL_BIN_SIZE | `ps2/include/font.hpp:158` | font.cpp:LoadFontTblBin (LoadFile into FontTblBinBuff, read in place by font.cpp:154-183) | none (no pointers) | assert | - |
| PAD_CAPTURE_FRAME | 0x6 | `ps2/include/gamepad.hpp:175` | gamepad.cpp:CGamePad::LoadCapture (LoadFile2 of key_cap.bin into PAD_CAPTURE_BUFFER) | none (no pointers) | assert | - |
| FRAME_VECTOR_EX_DATA | 0x20 | `ps2/include/gameutil.hpp:72` | gameutil.cpp:CreateAnimeDataEX (info[1].data motion file), gameutil.cpp:ChangeWeight | none (no pointers) | assert | - |
| Mot_File_List | 0x20 | `ps2/include/gameutil.hpp:90` | gameutil.cpp:CreateAnimeDataEX (info[1].data motion file header), gameutil.cpp:ChangeWeight | none (no pointers) | assert | - |
| CMapFlagData | 0x10 | `ps2/include/map.hpp:84` | memcard.cpp:CMemoryCardManager::LoadFromMc (member of SAVEDATA_FORMAT::save_data) | none (no pointers) | assert | - |
| SAVEDATA_FORMAT | 0x659C0 | `ps2/include/memcard.hpp:258` | memcard.cpp:CMemoryCardManager::LoadFromMc | host image: the PC writes and reads its own card files in host layout; `USER_PICTURE_INFO::image` is a pointer into `photo_work`, rebound by `CInventUserData::ResetAddress` before use; memcard.cpp sizes everything by sizeof | host image | - |
| MENU_SYSTEM_LIST_CURSOR | 0x4 | `ps2/include/menusystemdata.hpp:21` | memcard.cpp:CMemoryCardManager::LoadFromMc (CSaveData memcpy, member of CMenuSystemData) | none (no pointers) | assert | - |
| MENU_SYSTEM_GHOBI | 0x4 | `ps2/include/menusystemdata.hpp:34` | memcard.cpp:CMemoryCardManager::LoadFromMc (CSaveData memcpy, member of CMenuSystemData) | none (no pointers) | assert | - |
| CMenuSystemData | 0x308 | `ps2/include/menusystemdata.hpp:110` | memcard.cpp:CMemoryCardManager::LoadFromMc (CSaveData memcpy, member of CSaveData) | none (no pointers) | assert | - |
| MDS_HEADER | 0x10 | `ps2/include/mg_dataset.hpp:71` | mg_dataset.cpp:mgLoadMDSFile (buffers from GetPackFile casts) | resolved on access | assert | object_ofs(int, offset) |
| MDTOBJ_HEADER | 0x70 | `ps2/include/mg_dataset.hpp:88` | mg_dataset.cpp:mgLoadMDSFile (object walk, line 695); collision.cpp:LoadCollisionFile | resolved on access | assert | mdt_ofs(int, offset) |
| mgIMG_FILE_HEADER | 0x10 | `ps2/include/mg_texture.hpp:144` | mg_texture.cpp:mgCTextureManager::EnterIMGFile (img buffer from archive file) | none (no pointers) | assert | - |
| mgIMG1_HEADER | 0x30 | `ps2/include/mg_texture.hpp:158` | mg_texture.cpp:mgCTextureManager::EnterIMGFile | resolved on access | assert | offset(int, offset) |
| mgIMG_HEADER | 0x40 | `ps2/include/mg_texture.hpp:195` | mg_texture.cpp:mgCTextureManager::EnterIMGFile; character.cpp:CCharacter2::DeleteImage | resolved on access | assert | offset(int, offset) |
| MDT_HEADER | 0x40 | `ps2/include/mg_visual.hpp:69` | ps2/src/mg_dataset.cpp:mgLoadMDSFile | resolved on access | assert | vertex_ofs(int, offset); normal_ofs(int, offset); colour_ofs(int, offset); faces_ofs(int, offset); uv_ofs(int, offset); material_ofs(int, offset) |
| MDT_MATERIAL_ | 0x60 | `ps2/include/mg_visual.hpp:87` | ps2/src/mg_visual.cpp:mgCVisualMDT::CopyMDTData | none (no pointers) | assert | - |
| MDT_FACES | 0x10 | `ps2/include/mg_visual.hpp:102` | ps2/src/mg_visual.cpp:mgCVisualMDT::DataAssignMDT | none (no pointers) | assert | - |
| QUEST_PLAY_DATA | 0x10 | `ps2/include/quest.hpp:113` | memcard.cpp:CMemoryCardManager::LoadFromMc (member of CSaveData, memcpy from save_buffer) | none (no pointers) | assert | - |
| CQuestData | 0x480 | `ps2/include/quest.hpp:174` | memcard.cpp:CMemoryCardManager::LoadFromMc (member of CSaveData) | none (no pointers) | assert | - |
| MONSTER_BOOK_ENTRY | 0xC | `ps2/include/quest.hpp:188` | memcard.cpp:CMemoryCardManager::LoadFromMc (member of CMonsterBook in CSaveData) | none (no pointers) | assert | - |
| CMonsterBook | 0x1200 | `ps2/include/quest.hpp:211` | memcard.cpp:CMemoryCardManager::LoadFromMc (member of CSaveData) | none (no pointers) | assert | - |
| vmcode_t | 0xC | `ps2/include/runscript.hpp:166` | runscript.cpp:CRunScript::exe (jump/call targets); loaded by 5 script units | resolved on access (arg1 jump and arg2 call targets are offsets added to code at use) | assert | arg1(int, offset), arg2(int, offset) |
| funcdata | 0x10 | `ps2/include/runscript.hpp:182` | runscript.cpp:CRunScript::run (func = prog + prog->main / header + entry->func) | resolved on access; `name` is the script compiler's word, zero on every disc script, held as `u32` so `local`/`arg` sit at 8/12 on PC | assert | addr(u32, offset) |
| RS_PROGDATA | 0x8 | `ps2/include/runscript.hpp:208` | runscript.cpp:CRunScript::run (entry = header + header->prog) | resolved on access | assert | func(int, offset) |
| SV_CONFIG_OPTION | 0x40 | `ps2/include/savedata.hpp:188` | memcard.cpp:CMemoryCardManager::LoadFromMc (member of CSaveData) | none (no pointers) | assert | - |
| SAVE_TOUR_INFO | 0x1C | `ps2/include/savedata.hpp:206` | memcard.cpp:CMemoryCardManager::LoadFromMc (member of CSaveData) | none (no pointers) | assert | - |
| CSaveData | 0x65930 | `ps2/include/savedata.hpp:504` | memcard.cpp:CMemoryCardManager::LoadFromMc (line 1333); SaveToMc (writer, line 1078) | host image: the PC writes and reads its own card files in host layout; `USER_PICTURE_INFO::image` is a pointer into `photo_work`, rebound by `CInventUserData::ResetAddress` before use; memcard.cpp sizes everything by sizeof | host image | - |
| SPHIDA_PLAYER_DATA | 0x50 | `ps2/include/savedata.hpp:523` | memcard.cpp:CMemoryCardManager::LoadOmakeFile (member of CSphidaData in CSubGameData) | none (no pointers) | assert | - |
| CSphidaData | 0x1848 | `ps2/include/savedata.hpp:642` | mainloop.cpp:MainLoop; memcard.cpp:CMemoryCardManager::LoadOmakeFile | none (no pointers) | assert | - |
| GYORACE_DATA | 0xA0 | `ps2/include/savedata.hpp:675` | memcard.cpp:CMemoryCardManager::LoadOmakeFile (member of CGyoRaceData in CSubGameData) | none (no pointers) | assert | - |
| CGyoRaceData | 0x2C28 | `ps2/include/savedata.hpp:739` | memcard.cpp:CMemoryCardManager::LoadOmakeFile (member of CSubGameData) | none (no pointers) | assert | - |
| CSubGameData | 0x5470 | `ps2/include/savedata.hpp:808` | mainloop.cpp:MainLoop; memcard.cpp:CMemoryCardManager::LoadOmakeFile | none (no pointers) | assert | - |
| DNG_FLOOR_SAVE | 0x14 | `ps2/include/savedatadungeon.hpp:56` | memcard.cpp:CMemoryCardManager::LoadFromMc (member of CSaveDataDungeon in CSaveData) | none (no pointers) | assert | - |
| CSaveDataDungeon | 0xCE4 | `ps2/include/savedatadungeon.hpp:104` | memcard.cpp:CMemoryCardManager::LoadFromMc (member of CSaveData) | none (no pointers) | assert | - |
| sceMcColor | 0x10 | `ps2/include/sce/libmc.h:57` | memcard.cpp:CMemoryCardManager::SetIconData (member of sceMcIconSys, written to the card) | none (no pointers) | assert | - |
| sceMcIconSys | 0x3C4 | `ps2/include/sce/libmc.h:90` | memcard.cpp:CMemoryCardManager::SetIconData (writer only) | none (no pointers) | assert | - |
| sceMcStDateTime | 0x8 | `ps2/include/sce/libmc.h:106` | convviewlp.cpp:SaveDataConvertLoop (member of sceMcTblGetDir) | none (no pointers) | assert | - |
| sceMcTblGetDir | 0x40 | `ps2/include/sce/libmc.h:123` | convviewlp.cpp:SaveDataConvertLoop (sceMcGetDir fills dir_entries, memcpy at line 360) | none (no pointers) | assert | - |
| SND_REV_INFO | 0x8 | `ps2/include/scenesnd.hpp:255` | scenesnd.cpp:CScene::LoadSndRevInfo (memcpy of rev.bin buffer) | none (no pointers) | assert | - |
| CHARA_DATA | 0x38C | `ps2/include/userdata.hpp:252` | memcard.cpp:CMemoryCardManager::LoadFromMc (CSaveData memcpy, memcard.cpp:1333) | none (no pointers) | assert | - |
| ROBO_DATA | 0x220 | `ps2/include/userdata.hpp:307` | memcard.cpp:CMemoryCardManager::LoadFromMc (CSaveData memcpy, memcard.cpp:1333) | none (no pointers) | assert | - |
| MOS_CHANGE_PARAM | 0xBC | `ps2/include/userdata.hpp:398` | memcard.cpp:CMemoryCardManager::LoadFromMc (CSaveData memcpy, memcard.cpp:1333) | none (no pointers) | assert | - |
| CMonsterBox | 0x2F00 | `ps2/include/userdata.hpp:471` | memcard.cpp:CMemoryCardManager::LoadFromMc (CSaveData memcpy, memcard.cpp:1333) | none (no pointers) | assert | - |
| CFishAquarium | 0x530 | `ps2/include/userdata.hpp:581` | memcard.cpp:CMemoryCardManager::LoadFromMc (CSaveData memcpy, memcard.cpp:1333) | none (no pointers) | assert | - |
| FISH_RECORD | 0x20 | `ps2/include/userdata.hpp:598` | memcard.cpp:CMemoryCardManager::LoadFromMc (CSaveData memcpy, memcard.cpp:1333) | none (no pointers) | assert | - |
| CFishingRecord | 0x340 | `ps2/include/userdata.hpp:642` | memcard.cpp:CMemoryCardManager::LoadFromMc (CSaveData memcpy, memcard.cpp:1333) | none (no pointers) | assert | - |
| FISH_TOURNAMENT_ENTRY | 0x8 | `ps2/include/userdata.hpp:657` | memcard.cpp:CMemoryCardManager::LoadFromMc (CSaveData memcpy, memcard.cpp:1333) | none (no pointers) | assert | - |
| CFishingTournament | 0x70 | `ps2/include/userdata.hpp:760` | memcard.cpp:CMemoryCardManager::LoadFromMc (CSaveData memcpy, memcard.cpp:1333) | none (no pointers) | assert | - |
| PARTY_CHARA_INFO | 0xC | `ps2/include/userdata.hpp:775` | memcard.cpp:CMemoryCardManager::LoadFromMc (CSaveData memcpy, memcard.cpp:1333) | none (no pointers) | assert | - |
| USER_PICTURE_INFO | 0x18 | `ps2/include/userdata.hpp:795` | memcard.cpp:CMemoryCardManager::LoadFromMc; inventmn.cpp:CInventUserData::ResetAddress | host image: the PC writes and reads its own card files in host layout; `USER_PICTURE_INFO::image` is a pointer into `photo_work`, rebound by `CInventUserData::ResetAddress` before use; memcard.cpp sizes everything by sizeof | host image | - |
| INVENT_CREATED_ITEM | 0x4 | `ps2/include/userdata.hpp:807` | memcard.cpp:CMemoryCardManager::LoadFromMc (CSaveData memcpy, memcard.cpp:1333) | none (no pointers) | assert | - |
| SCOOP_INFO | 0x4 | `ps2/include/userdata.hpp:821` | memcard.cpp:CMemoryCardManager::LoadFromMc (CSaveData memcpy, memcard.cpp:1333) | none (no pointers) | assert | - |
| CInventUserData | 0x3CE60 | `ps2/include/userdata.hpp:1143` | memcard.cpp:CMemoryCardManager::LoadFromMc; inventmn.cpp:CInventUserData::ResetAddress | host image: the PC writes and reads its own card files in host layout; `USER_PICTURE_INFO::image` is a pointer into `photo_work`, rebound by `CInventUserData::ResetAddress` before use; memcard.cpp sizes everything by sizeof | host image | - |
| CUserDataManager | 0x457A0 | `ps2/include/userdata.hpp:2180` | memcard.cpp:CMemoryCardManager::LoadFromMc; inventmn.cpp:CInventUserData::ResetAddress | host image: the PC writes and reads its own card files in host layout; `USER_PICTURE_INFO::image` is a pointer into `photo_work`, rebound by `CInventUserData::ResetAddress` before use; memcard.cpp sizes everything by sizeof | host image | - |
| CDC2AlbumData | 0x64CB0 | `ps2/include/inventmn.hpp:556` | memcard.cpp album save/load | host image: the PC writes and reads its own card files in host layout; `USER_PICTURE_INFO::image` is a pointer into `photo_work`, rebound by `CInventUserData::ResetAddress` before use; memcard.cpp sizes everything by sizeof | host image | - |
| SAVE_CONVERT_WORK | 0x659C0 | `ps2/include/convviewlp.hpp:83` | convviewlp.cpp:SaveDataConvertLoop | host image: the PC writes and reads its own card files in host layout; `USER_PICTURE_INFO::image` is a pointer into `photo_work`, rebound by `CInventUserData::ResetAddress` before use; memcard.cpp sizes everything by sizeof | host image | - |
| INVENT_CREATED_ITEM_OLD | 0xC | `ps2/src/inventmn.cpp:1186` | memcard.cpp:CMemoryCardManager::LoadFromMc; inventmn.cpp:TranslateInventUserData | none (no pointers) | assert | - |

## Notes per format

- `DATA_HEADER`: PS2 only (see its row). `records.py` fails if any ps2/src or port/src file other than `ps2/src/dataread.cpp` names it, or if `InitCDFile`, `SearchFile`, `LoadFileBG`, `LoadFile2` or `CDRead` is linked and not overridden.
- `funcdata`: retail declares `name` as `char *`; every `SB2` script under `data/` (dungeon/act_script/*.stb and the rest) stores 0 there and retail never fixes it up, so the field is a 32-bit word. The error messages in `runscript.cpp` print it through `(char *) (uptr)`, as retail did.
- `RS_CALLDATA` (runtime): `SetEffectScript` allocates `sizeof(RS_CALLDATA) * 2 / 16` quadwords, which is retail's one quadword on the PS2 and the three that two 24-byte frames fill on PC.
- Save images (`host image`): the album's check-digit run is `sizeof(USER_PICTURE_INFO) * INVENT_ALBUM_PHOTO_NUM` and the save's half check digit `sizeof(CSaveData) / 2`, so on PC they cover the host arrays and no longer land inside `photo[]`. PS2 card images do not load on PC (the short-read check in `LoadFromMc` rejects them), and PC card files do not load on the PS2.
- MDS/MDT/MOT: no code stores a pointer into a record. `mgCShadowMDT::DataAssignMDT` (`ps2/src/mg_shadow.cpp:270-271`) zeroes `uv_num`/`normal_num` in the loaded `MDT_HEADER`, an in-place integer write retail relies on; `LoadCollisionFile` (`ps2/src/collision.cpp:493`) keeps a pointer to `MDTOBJ_HEADER::name` in a runtime frame.
- `FONT_TBL_BIN` asserts against the symbol `FONT_TBL_BIN_SIZE`. `sceMcIconSys`/`sceMcColor` are written to the card, not read in place; they keep the assert because the card format fixes their layout.
- The runtime list was rechecked by following every cast to each runtime struct (407 sites, 109 structs) to its source buffer: none is a file view.

## Runtime structs

| Struct | Size | Declared | Address-holding integer fields |
|---|---|---|---|
| ACCUME_EFFECT | 0x330 | `ps2/include/actionchara.hpp:212` | - |
| RUN_SCRIPT_ENV | 0x8 | `ps2/include/actionchara.hpp:224` | - |
| ACTION_SW_EFFECT | 0x20 | `ps2/include/actionchara.hpp:245` | - |
| ACTION_DAMAGE | 0x28 | `ps2/include/actionchara.hpp:265` | - |
| ACTION_OBJECT | 0x20 | `ps2/include/actionchara.hpp:278` | - |
| ACTION_BODY_COL | 0x24 | `ps2/include/actionchara.hpp:293` | - |
| ACTION_SOUND | 0x14 | `ps2/include/actionchara.hpp:308` | - |
| ACTION_ACCELE | 0x20 | `ps2/include/actionchara.hpp:323` | - |
| ACTION_ACCUME | 0x8 | `ps2/include/actionchara.hpp:336` | - |
| ACTION_SHAKE | 0x8 | `ps2/include/actionchara.hpp:348` | - |
| CActionChara | 0x1030 | `ps2/include/actionchara.hpp:1098` | - |
| ACTION_INFO | 0x10 | `ps2/include/actscript.hpp:130` | - |
| AUTOMAP_PARTS_INFO | 0x18 | `ps2/include/automap.hpp:145` | - |
| MINIMAP_INFO | 0x290 | `ps2/include/automap.hpp:157` | - |
| MINIMAP_SYMBOL_INFO | 0x10 | `ps2/include/automap.hpp:175` | - |
| AUTOMAP_ROOM_INFO | 0x18 | `ps2/include/automap.hpp:191` | - |
| AUTOMAP_ROOM | 0x14 | `ps2/include/automap.hpp:206` | - |
| CAutoMapParts | 0x1C | `ps2/include/automap.hpp:245` | - |
| CMiniMapSymbol | 0x180 | `ps2/include/automap.hpp:338` | - |
| CHealingPoint | 0x8 | `ps2/include/automap.hpp:374` | - |
| CAutoMapGen | 0x2A0 | `ps2/include/automap.hpp:704` | - |
| CameraCtrlParam | 0x2C | `ps2/include/cameracontrol.hpp:101` | - |
| CCameraControl | 0x1F0 | `ps2/include/cameracontrol.hpp:411` | - |
| CHRINFO_KEY_SET | 0x30 | `ps2/include/character.hpp:141` | - |
| CHRINFO_SEQ | 0x2C | `ps2/include/character.hpp:156` | - |
| CHRINFO_SEQ_HEADER | 0x30 | `ps2/include/character.hpp:170` | - |
| CHRINFO_SE | 0x10 | `ps2/include/character.hpp:186` | - |
| CHARA_EFFECT_MANAGER | 0x1F0 | `ps2/include/character.hpp:206` | - |
| CHRINFO_EFFECT | 0x28 | `ps2/include/character.hpp:219` | - |
| CHRINFO_EFFECT_IMAGE | 0x28 | `ps2/include/character.hpp:232` | - |
| CHARA_ENTRY_OBJECT | 0x10 | `ps2/include/character.hpp:259` | - |
| CHARA_ENTRY_EFFECT | 0xC | `ps2/include/character.hpp:272` | - |
| CCharaFrameMatching | 0xC | `ps2/include/character.hpp:308` | - |
| CHARA_SOUND_INFO | 0x28 | `ps2/include/character.hpp:339` | - |
| CCharaLOD | 0x18 | `ps2/include/character.hpp:366` | - |
| CCharacter2 | 0x660 | `ps2/include/character.hpp:1139` | - |
| ROBO_INFO_BODY | 0x25 | `ps2/include/charasetup.hpp:53` | - |
| ROBO_INFO_DATA | 0x24 | `ps2/include/charasetup.hpp:68` | - |
| CCPoly | 0x50 | `ps2/include/collision.hpp:79` | - |
| CCollision | 0x40 | `ps2/include/collision.hpp:180` | - |
| CCollisionMDT | 0x50 | `ps2/include/collision.hpp:259` | - |
| CColFrame | 0x120 | `ps2/include/collision.hpp:357` | - |
| DAMAGE_PARAM | 0x48 | `ps2/include/colprim.hpp:153` | - |
| CColPrim | 0x110 | `ps2/include/colprim.hpp:318` | - |
| CColPrimMan | 0x4410 | `ps2/include/colprim.hpp:412` | - |
| CRandom | 0x4 | `ps2/include/crandom.hpp:33` | - |
| BG_READ_INFO | 0x120 | `ps2/include/dataread.hpp:102` | - |
| FILE_CACHE | 0x40 | `ps2/include/dataread.hpp:118` | - |
| dbgCJISFont | 0x8B0 | `ps2/include/dbg_font.hpp:132` | - |
| DNG_DEBUG_INFO | 0x20 | `ps2/include/dng_debug.hpp:67` | - |
| BattleEffectPrim | 0x50 | `ps2/include/dng_effect.hpp:203` | - |
| BattleEffectChara | 0x1C | `ps2/include/dng_effect.hpp:219` | - |
| CHILL_AFTER_HIT_PIECE | 0x50 | `ps2/include/dng_effect.hpp:241` | - |
| CChillAfterHit | 0x7A0 | `ps2/include/dng_effect.hpp:307` | - |
| FIRE_AFTER_HIT_FLAME | 0x30 | `ps2/include/dng_effect.hpp:325` | - |
| FIRE_AFTER_HIT_TRAIL | 0x14 | `ps2/include/dng_effect.hpp:338` | - |
| CFireAfterHit | 0x940 | `ps2/include/dng_effect.hpp:405` | - |
| TORNADO_PIECE | 0x30 | `ps2/include/dng_effect.hpp:421` | - |
| CTornado | 0x380 | `ps2/include/dng_effect.hpp:478` | - |
| THUNDER_SPARK | 0x40 | `ps2/include/dng_effect.hpp:495` | - |
| CThunder | 0xDC0 | `ps2/include/dng_effect.hpp:553` | - |
| CSparcEffect | 0xB0 | `ps2/include/dng_effect.hpp:602` | - |
| CMiniEffPrim | 0x20 | `ps2/include/dng_effect.hpp:658` | - |
| CMiniEffPrimMan | 0x940 | `ps2/include/dng_effect.hpp:713` | - |
| CPalletAnime | 0xE | `ps2/include/dng_effect.hpp:770` | - |
| HEALING_LIGHT | 0x30 | `ps2/include/dng_effect.hpp:787` | - |
| CHealingEffectMan | 0x330 | `ps2/include/dng_effect.hpp:853` | - |
| CSwordLuminous | 0x18 | `ps2/include/dng_effect.hpp:890` | - |
| CSWordAfterImage | 0x60 | `ps2/include/dng_effect.hpp:968` | - |
| CAfterWire | 0x120 | `ps2/include/dng_effect.hpp:1036` | - |
| CHitEffectImage | 0x60 | `ps2/include/dng_effect.hpp:1129` | - |
| CFlushEffect | 0x40 | `ps2/include/dng_effect.hpp:1169` | - |
| CPowerLine | 0x80 | `ps2/include/dng_effect.hpp:1237` | - |
| CDeadEffect | 0x40 | `ps2/include/dng_effect.hpp:1298` | - |
| CMapEffect_Sprite | 0x50 | `ps2/include/dng_effect.hpp:1348` | - |
| CMapEffectsManeger | 0x14 | `ps2/include/dng_effect.hpp:1394` | - |
| BattleEffectMan | 0x48 | `ps2/include/dng_effect.hpp:1453` | - |
| CWeaponElement | 0x7C0 | `ps2/include/dng_effect.hpp:1651` | - |
| TRESURE_BOX_ITEM | 0xC | `ps2/include/dng_event.hpp:136` | - |
| TRESURE_BOX_GROUP | 0x488 | `ps2/include/dng_event.hpp:149` | - |
| TRESURE_BOX_FLOOR | 0x104 | `ps2/include/dng_event.hpp:161` | - |
| TRESURE_BOX_FLOOR_INFO | 0x1A40C | `ps2/include/dng_event.hpp:177` | - |
| CStartupEpisodeTitle | 0x18 | `ps2/include/dng_event.hpp:235` | - |
| MESSAGE_TASK | 0x90 | `ps2/include/dng_event.hpp:252` | - |
| MessageTaskManager | 0x36C | `ps2/include/dng_event.hpp:317` | - |
| CRedMarkModel | 0x90 | `ps2/include/dng_event.hpp:360` | - |
| CGeoStone | 0x670 | `ps2/include/dng_event.hpp:435` | - |
| CRandomCircle | 0x6A0 | `ps2/include/dng_event.hpp:542` | - |
| CTreasureBox | 0x70 | `ps2/include/dng_event.hpp:600` | - |
| CTreasureBoxManager | 0xAA0 | `ps2/include/dng_event.hpp:730` | - |
| CLevelupInfo | 0x38 | `ps2/include/dng_hud.hpp:140` | - |
| CPiyori | 0x20 | `ps2/include/dng_hud.hpp:218` | - |
| CGiftMark | 0x14 | `ps2/include/dng_hud.hpp:274` | - |
| CEnemyGekirin | 0x2 | `ps2/include/dng_hud.hpp:307` | - |
| CEnemyLifeGage | 0x50 | `ps2/include/dng_hud.hpp:386` | - |
| CDamageScore | 0x90 | `ps2/include/dng_hud.hpp:480` | - |
| CDamageScore2 | 0x28 | `ps2/include/dng_hud.hpp:530` | - |
| CLockOnModel | 0xB0 | `ps2/include/dng_hud.hpp:589` | - |
| CWarningGage2 | 0x20 | `ps2/include/dng_hud.hpp:624` | - |
| DNG_STATUS | 0x1C | `ps2/include/dng_main.hpp:140` | - |
| CRocketLauncher | 0x190 | `ps2/include/dng_object.hpp:146` | - |
| CRocketLauncherMan | 0x2580 | `ps2/include/dng_object.hpp:208` | - |
| CMachineGun | 0x390 | `ps2/include/dng_object.hpp:247` | - |
| CLaserGun | 0x130 | `ps2/include/dng_object.hpp:339` | - |
| CLaserGunMan | 0x1300 | `ps2/include/dng_object.hpp:401` | - |
| CPullItem | 0x80 | `ps2/include/dng_object.hpp:535` | - |
| CPullItemManager | 0x8 | `ps2/include/dng_object.hpp:568` | - |
| CRoboVoiceSystem | 0x18 | `ps2/include/dng_object.hpp:651` | - |
| SP_RGBA | 0x10 | `ps2/include/dng_status.hpp:27` | - |
| DNGMAP_ROOT_INFO | 0x5 | `ps2/include/dngfloor.hpp:157` | - |
| DNGMAP_ROOM_INFO | 0x50 | `ps2/include/dngfloor.hpp:199` | - |
| GLID_INFO | 0x70 | `ps2/include/dngfloor.hpp:224` | - |
| CDngFloorManager | 0x10 | `ps2/include/dngfloor.hpp:454` | - |
| DNGMAP_KOMA_POS | 0xC | `ps2/include/dngmenu.hpp:183` | - |
| CDngFreeMap | 0x110 | `ps2/include/dngmenu.hpp:510` | - |
| `mgRect<float>` | 0x10 | `ps2/include/dngmenu.hpp:511` | - |
| CMenuTreeMap | 0x2FBE0 | `ps2/include/dngmenu.hpp:599` | - |
| DA_FRAME_POSE | 0x10 | `ps2/include/dynamicanime.hpp:40` | - |
| DA_FIX_VERTEX | 0x20 | `ps2/include/dynamicanime.hpp:55` | - |
| DA_BIND_VERTEX | 0x10 | `ps2/include/dynamicanime.hpp:68` | - |
| DA_BOUNDING_BOX | 0x30 | `ps2/include/dynamicanime.hpp:81` | - |
| CDACollision | 0xD0 | `ps2/include/dynamicanime.hpp:128` | - |
| CDAColPipe | 0xE0 | `ps2/include/dynamicanime.hpp:169` | - |
| CDynamicAnime | 0x90 | `ps2/include/dynamicanime.hpp:565` | - |
| CEditCollision | 0x50 | `ps2/include/editcoll.hpp:118` | - |
| EditMoveCharaInfo | 0x130 | `ps2/include/editctrl.hpp:119` | - |
| EditAnalyzeDataSrc | 0x1C | `ps2/include/editdata.hpp:128` | - |
| EditAnalyzeSrc | 0x340 | `ps2/include/editdata.hpp:163` | - |
| EditDebugInfo | 0x3C | `ps2/include/editdebug.hpp:136` | - |
| EditStarParticle | 0x20 | `ps2/include/editeff.hpp:87` | - |
| CStarEffect | 0x100 | `ps2/include/editeff.hpp:155` | - |
| CPaintEffect | 0x400 | `ps2/include/editeff.hpp:222` | - |
| CPlaceAnime | 0x90 | `ps2/include/editeff.hpp:281` | - |
| CEditEvent | 0x150 | `ps2/include/editevent.hpp:199` | - |
| GeoFuncParam | 0x4 | `ps2/include/editevent.hpp:222` | - |
| FirePowder | 0x20 | `ps2/include/editexception.hpp:42` | - |
| CGeyserEffectPoint | 0x30 | `ps2/include/editexception.hpp:72` | - |
| CGeyserEffect | 0x80 | `ps2/include/editexception.hpp:153` | - |
| ePlaceData | 0x20 | `ps2/include/editinfo.hpp:29` | - |
| CEditInfoMngr | 0x18 | `ps2/include/editinfo.hpp:135` | - |
| EP_PLACE_INFO | 0x48 | `ps2/include/editmap.hpp:70` | - |
| CEditMap::RemoveInfo | 0x494 | `ps2/include/editmap.hpp:1065` | - |
| CEditMap | 0x10F0 | `ps2/include/editmap.hpp:1066` | - |
| GEORAMA_PARTS_LIST_ITEM | 0x38 | `ps2/include/editmenu.hpp:126` | - |
| GEORAMA_LIST_INFO | 0x8 | `ps2/include/editmenu.hpp:138` | - |
| CMenuGeorama | 0x1B900 | `ps2/include/editmenu.hpp:450` | - |
| CRemovalMenu | 0x1500 | `ps2/include/editmenu.hpp:554` | - |
| UNDO_DATA | 0x30 | `ps2/include/editmode.hpp:78` | - |
| EditPartsMaterial | 0x8 | `ps2/include/editparts.hpp:92` | - |
| CEditPartsInfo | 0x280 | `ps2/include/editparts.hpp:227` | - |
| CEditHouse | 0x10 | `ps2/include/editparts.hpp:259` | - |
| CEditParts::WallInfo | 0x40 | `ps2/include/editparts.hpp:494` | - |
| CEditParts | 0x330 | `ps2/include/editparts.hpp:495` | - |
| CGridData | 0x14 | `ps2/include/editriver.hpp:63` | - |
| CEditGrid | 0x130 | `ps2/include/editriver.hpp:262` | - |
| EFFECT_PARAM | 0x1B0 | `ps2/include/effect.hpp:140` | - |
| CEffect | 0x200 | `ps2/include/effect.hpp:223` | - |
| CEffectCtrl | 0x310 | `ps2/include/effect.hpp:394` | - |
| CEffectManager | 0x184 | `ps2/include/effect.hpp:558` | - |
| CEffectList | 0x18 | `ps2/include/effectlist.hpp:118` | - |
| CFadeInOut | 0x30 | `ps2/include/effectlist.hpp:301` | - |
| EFF_SPT_BASE_DEF | 0x64 | `ps2/include/effscript.hpp:222` | - |
| EFF_SPT_BASE | 0x1C | `ps2/include/effscript.hpp:239` | - |
| _ES_SPRITE | 0x110 | `ps2/include/effscript.hpp:277` | - |
| _EFF_SCRIPT | 0x150 | `ps2/include/effscript.hpp:326` | - |
| CEffectScriptMan | 0x1190 | `ps2/include/effscript.hpp:866` | - |
| ED_EVENT_INFO | 0x12A0 | `ps2/include/event_func.hpp:1148` | - |
| CEoh | 0x10 | `ps2/include/event_func.hpp:1231` | - |
| CEohMother | 0x200 | `ps2/include/event_func.hpp:1674` | - |
| ARG_DATA | 0x8 | `ps2/include/event_func.hpp:1691` | - |
| ARG_LIST | 0x10 | `ps2/include/event_func.hpp:1705` | - |
| CEventScriptArg | 0x10 | `ps2/include/event_func.hpp:1738` | - |
| CRaster | 0x2C | `ps2/include/event_func.hpp:1828` | - |
| CScreenEffect | 0x4C | `ps2/include/event_func.hpp:1975` | - |
| EventEditInfo | 0x40 | `ps2/include/eventedit.hpp:72` | - |
| CMarker | 0x4 | `ps2/include/eventsprite.hpp:80` | - |
| CEventSprite | 0x88 | `ps2/include/eventsprite.hpp:216` | - |
| CEventSpriteMother | 0x440 | `ps2/include/eventsprite.hpp:345` | - |
| CEventSprite2 | 0x80 | `ps2/include/eventsprite.hpp:593` | - |
| FISH_PARAM | 0x54 | `ps2/include/fishing.hpp:100` | - |
| FISHING_ROD_DATA | 0x18 | `ps2/include/fishing.hpp:112` | - |
| FISH_DATA | 0x24 | `ps2/include/fishing.hpp:131` | - |
| FISH_PLACE | 0xC | `ps2/include/fishing.hpp:144` | - |
| FISH_PLACE_MAP | 0x88 | `ps2/include/fishing.hpp:183` | - |
| FISH_POINT | 0x30 | `ps2/include/fishingobj.hpp:40` | - |
| FISH_BIND | 0x10 | `ps2/include/fishingobj.hpp:54` | - |
| FISH_FLOAT | 0x10 | `ps2/include/fishingobj.hpp:68` | - |
| FISH_ROD_SEGMENT | 0x10 | `ps2/include/fishingobj.hpp:82` | - |
| CFishObj | 0x3D0 | `ps2/include/fishingobj.hpp:147` | - |
| RECT | 0x10 | `ps2/include/font.hpp:28` | - |
| RGBAQ_TYPE | 0x8 | `ps2/include/font.hpp:43` | - |
| GAIJI_DATA | 0xE | `ps2/include/font.hpp:129` | - |
| FCONV_CODE | 0xC | `ps2/include/font.hpp:142` | - |
| CFont | 0xB8 | `ps2/include/font.hpp:371` | - |
| CObjAnime | 0x30 | `ps2/include/funcpoint.hpp:166` | - |
| `CList<CObjAnime>` | 0x50 | `ps2/include/funcpoint.hpp:179` | - |
| CFuncPointMngr | 0x34 | `ps2/include/funcpoint.hpp:393` | - |
| CDataCommon | 0x2C | `ps2/include/gamedata.hpp:317` | - |
| CDataItem | 0x10 | `ps2/include/gamedata.hpp:342` | - |
| CDataAttach | 0x18 | `ps2/include/gamedata.hpp:366` | - |
| CDataWeapon | 0x4C | `ps2/include/gamedata.hpp:404` | - |
| CDataRoboPart | 0x24 | `ps2/include/gamedata.hpp:437` | - |
| CDataBreedFish | 0x14 | `ps2/include/gamedata.hpp:467` | - |
| COMMON_GAGE | 0x8 | `ps2/include/gamedata.hpp:543` | - |
| CGameDataUsed | 0x6C | `ps2/include/gamedata.hpp:1324` | - |
| CItemUseTarget | 0x8 | `ps2/include/gamedata.hpp:1358` | - |
| BASE_MONSTER_TBL | 0xB8 | `ps2/include/gamedata.hpp:1405` | - |
| CGameData | 0x30 | `ps2/include/gamedata.hpp:1562` | - |
| PAD_STATUS | 0x4C | `ps2/include/gamepad.hpp:144` | - |
| PAD_REPEAT | 0x188 | `ps2/include/gamepad.hpp:160` | - |
| CGamePad | 0x478 | `ps2/include/gamepad.hpp:675` | - |
| Mot_List | 0x20 | `ps2/include/gameutil.hpp:107` | - |
| FrameLinkRecord | 0x30 | `ps2/include/gameutil.hpp:119` | - |
| tagFRAME_INF | 0x20 | `ps2/include/gameutil.hpp:136` | - |
| tagMOTION_TYPE | 0x14 | `ps2/include/gameutil.hpp:151` | - |
| MOTION_FILE_INFO | 0xC | `ps2/include/gameutil.hpp:164` | - |
| CollisionInfo | 0x10 | `ps2/include/gameutil.hpp:178` | - |
| MoveCheckInfo | 0x110 | `ps2/include/gameutil.hpp:222` | - |
| GYORACE_FISH_INF | 0x2C | `ps2/include/gyorace.hpp:80` | - |
| GYORACE_RESULT | 0x24 | `ps2/include/gyorace.hpp:94` | - |
| grFISH_PARAM | 0x40 | `ps2/include/gyoracesim.hpp:64` | - |
| grRACE_PROGRESS | 0x18 | `ps2/include/gyoracesim.hpp:82` | - |
| grRACE_INFO | 0x1DC | `ps2/include/gyoracesim.hpp:101` | - |
| RACE_FISH_PARAM | 0xA0 | `ps2/include/gyoracesim.hpp:131` | - |
| grFISH_DATA | 0x1C | `ps2/include/gyoracesim.hpp:146` | - |
| HELP_MES_INFO | 0x1C | `ps2/include/helpmes.hpp:42` | - |
| SCOOP_DATA | 0x14 | `ps2/include/inventmn.hpp:415` | - |
| PIC_NAME_INFO | 0x8 | `ps2/include/inventmn.hpp:428` | - |
| INVENT_MATERIAL | 0x4 | `ps2/include/inventmn.hpp:441` | - |
| INVENT_MATERIAL_LIST | 0x8 | `ps2/include/inventmn.hpp:454` | - |
| MakeItemNeeds | 0x24 | `ps2/include/inventmn.hpp:476` | - |
| INVENT_DATA_INFO | 0x24 | `ps2/include/inventmn.hpp:495` | - |
| CInventDataManage | 0x8 | `ps2/include/inventmn.hpp:639` | - |
| CMenuInvent | 0xF30 | `ps2/include/inventmn.hpp:1154` | - |
| INIT_LOOP_ARG | 0x50 | `ps2/include/mainloop.hpp:223` | - |
| DEBUG_INFO | 0x14 | `ps2/include/mainloop.hpp:240` | - |
| PAD_TABLE_ENTRY | 0xC | `ps2/include/mainloop.hpp:253` | - |
| ANALOG_TABLE_ENTRY | 0x8 | `ps2/include/mainloop.hpp:265` | - |
| PartsGroupData | 0x4 | `ps2/include/map.hpp:102` | - |
| `CList<PartsGroupData>` | 0x10 | `ps2/include/map.hpp:103` | - |
| `CList<CMapParts *>` | 0x10 | `ps2/include/map.hpp:104` | - |
| CPartsGroup | 0x10 | `ps2/include/map.hpp:141` | - |
| MapDrawOffRect | 0x30 | `ps2/include/map.hpp:161` | - |
| MapEventInfo | 0x60 | `ps2/include/map.hpp:187` | - |
| CMapWater | 0xA0 | `ps2/include/map.hpp:234` | - |
| CMap | 0xD10 | `ps2/include/map.hpp:1073` | - |
| CCameraInfo | 0xD0 | `ps2/include/mapinfo.hpp:81` | - |
| CMapInfo | 0x100 | `ps2/include/mapinfo.hpp:233` | - |
| MapJumpMapInfo | 0x18 | `ps2/include/mapjump.hpp:41` | - |
| CMapLightingInfo | 0x1D0 | `ps2/include/mapload.hpp:123` | - |
| CFuncPointCheck | 0x8 | `ps2/include/mapload.hpp:143` | - |
| CFuncPoint | 0x1C0 | `ps2/include/mapload.hpp:340` | - |
| PieceMaterial | 0x20 | `ps2/include/mapload.hpp:376` | - |
| CCameraDrawInfo | 0x8 | `ps2/include/mapload.hpp:409` | - |
| InScreenFuncInfo | 0xC | `ps2/include/mapparts.hpp:48` | - |
| CMapParts | 0x310 | `ps2/include/mapparts.hpp:509` | - |
| CMapTreasureBox | 0x680 | `ps2/include/mapparts.hpp:570` | - |
| MAP_NAME_INFO | 0x1C | `ps2/include/mapselect.hpp:143` | - |
| EVENT_VIEW_INFO | 0x1C | `ps2/include/mapselect.hpp:160` | - |
| MAP_SKY_INFO | 0x740 | `ps2/include/mapsky.hpp:39` | - |
| CMapSky::AnimeFrame | 0x8 | `ps2/include/mapsky.hpp:123` | - |
| CMapSky | 0x108 | `ps2/include/mapsky.hpp:124` | - |
| CMdsInfo | 0x20 | `ps2/include/mdslist.hpp:82` | - |
| CMdsList | 0x10 | `ps2/include/mdslist.hpp:137` | - |
| CIMGList | 0x8 | `ps2/include/mdslist.hpp:160` | - |
| CMapPiece | 0xB0 | `ps2/include/mdslist.hpp:445` | - |
| MC_ICON_DATA | 0x28 | `ps2/include/memcard.hpp:166` | - |
| MC_CARD_INFO | 0x20 | `ps2/include/memcard.hpp:184` | - |
| MC_ERROR_INFO | 0x14 | `ps2/include/memcard.hpp:199` | - |
| SAVEDATA_INFO | 0x40 | `ps2/include/memcard.hpp:225` | - |
| COSBIT_INFO | 0x4 | `ps2/include/memcard.hpp:271` | - |
| CMemoryCardManager | 0x1100 | `ps2/include/memcard.hpp:758` | - |
| AQUA_BUBBLE | 0x30 | `ps2/include/menuaqua.hpp:295` | - |
| CBubble | 0x40 | `ps2/include/menuaqua.hpp:389` | - |
| CAquaFishActionParam | 0x40 | `ps2/include/menuaqua.hpp:433` | - |
| AQUA_FISH_ROUND | 0x10 | `ps2/include/menuaqua.hpp:447` | - |
| CAquaFishEff | 0x10 | `ps2/include/menuaqua.hpp:502` | - |
| NEXT_THINK_PARAM | 0x20 | `ps2/include/menuaqua.hpp:516` | - |
| CAquaFish | 0x940 | `ps2/include/menuaqua.hpp:729` | - |
| CFishFood | 0x6A0 | `ps2/include/menuaqua.hpp:788` | - |
| CAquaMes | 0x64 | `ps2/include/menuaqua.hpp:976` | - |
| CAquarium | 0x3D0 | `ps2/include/menuaqua.hpp:1172` | - |
| FISH_PRIZE_INFO | 0x8 | `ps2/include/menuaqua.hpp:1216` | - |
| MENU_CHAPTER_INFO | 0x20 | `ps2/include/menucapt.hpp:40` | - |
| CHR_CNG_STAR | 0x18 | `ps2/include/menuchr.hpp:418` | - |
| CHR_CNG_CLUT_COLOR | 0x4 | `ps2/include/menuchr.hpp:432` | - |
| CMenuChrCngMenu | 0x1F80 | `ps2/include/menuchr.hpp:647` | - |
| CMenuMosSelect | 0x7670 | `ps2/include/menuchr.hpp:766` | - |
| CMenuCostumeSel | 0x2D0 | `ps2/include/menuchr.hpp:855` | - |
| CMosBookMenu | 0x980 | `ps2/include/menuchr.hpp:974` | - |
| MENU_LOAD_INFO | 8 | `ps2/include/menuchr.hpp:1690` | - |
| CMenuFont | 0xB8 | `ps2/include/menucls1.hpp:59` | - |
| CDC2Mes | 0x2A50 | `ps2/include/menucls1.hpp:397` | - |
| MENU_ITEM_MOVE_INFO | 0x7C | `ps2/include/menucls1.hpp:413` | - |
| CMenuMoveItem | 0x104 | `ps2/include/menucls1.hpp:476` | - |
| CMenuItemUse | 0x1C | `ps2/include/menucls1.hpp:531` | - |
| MENU_SPI_ANALYZE_STRUCT1 | 0x8 | `ps2/include/menucommon.hpp:73` | - |
| MENU_COMMAND_ANALYZE_INFO | 0x68 | `ps2/include/menucommon.hpp:96` | - |
| MENU_SHORT_RECT | 0x8 | `ps2/include/menudraw.hpp:312` | - |
| MENU_BASETEXINFO | 0x20 | `ps2/include/menudraw.hpp:330` | - |
| MENU_PARTS_EFFECT_STRUCT1 | 0x24 | `ps2/include/menudraw.hpp:345` | - |
| MENUFORMPARTS_TYPE | 0x48 | `ps2/include/menudraw.hpp:381` | - |
| MENU_FORM_ACTION_MOVE | 0x14 | `ps2/include/menudraw.hpp:396` | - |
| MENU_FORM_ACTION | 0x14 | `ps2/include/menudraw.hpp:408` | - |
| MENU_ETCINFO | 0xC | `ps2/include/menudraw.hpp:420` | - |
| MENU_ETCINFO2 | 0x14 | `ps2/include/menudraw.hpp:432` | - |
| MENUFORM_MAKEBRD_LINE | 0x6 | `ps2/include/menudraw.hpp:446` | - |
| MENUFORM_MAKEBRD_INFO | 0x2C | `ps2/include/menudraw.hpp:462` | - |
| MENU_EFFECT_INFO | 0x40 | `ps2/include/menudraw.hpp:576` | - |
| REPAIR_EFFECT_PARTICLE | 0x30 | `ps2/include/menudraw.hpp:596` | - |
| CMenuPosDataForm | 0x80 | `ps2/include/menudraw.hpp:895` | - |
| CPosDataManage | 0x20 | `ps2/include/menudraw.hpp:1157` | - |
| CMenuPosDataManage | 0x5BC | `ps2/include/menudraw.hpp:1262` | - |
| CRepairEffect | 0x24 | `ps2/include/menudraw.hpp:1322` | - |
| CRepairManager | 0x1EC | `ps2/include/menudraw.hpp:1465` | - |
| CLevelUpEffect | 0x30 | `ps2/include/menudraw.hpp:1542` | - |
| CLevelUpEffectManager | 0x190 | `ps2/include/menudraw.hpp:1616` | - |
| CStarDust | 0xC | `ps2/include/menudraw.hpp:1671` | - |
| CEffVerticalLine | 0x40 | `ps2/include/menudraw.hpp:1723` | - |
| CMenuEffect | 0x38 | `ps2/include/menudraw.hpp:1846` | - |
| MENU_INIT_ARG | 0x98 | `ps2/include/menumain.hpp:225` | - |
| MENU_DRAW_ENV | 0xD0 | `ps2/include/menumain.hpp:252` | - |
| MENU_ETC_INFO | 0x8 | `ps2/include/menumain.hpp:264` | - |
| CMenuInter | 0x18 | `ps2/include/menumain.hpp:324` | - |
| WMAP_POS_DATA | 0x14 | `ps2/include/menumap.hpp:130` | - |
| WMAP_AREA_DATA | 0x4C | `ps2/include/menumap.hpp:153` | - |
| CWorldMapMenu | 0xBA4 | `ps2/include/menumap.hpp:241` | - |
| SaveIconSet | 0x78 | `ps2/include/menuop.hpp:27` | - |
| CManualMenu | 0x178 | `ps2/include/menuop.hpp:310` | - |
| CMenuOption | 0x384 | `ps2/include/menuop.hpp:405` | - |
| CSaveMenuClass | 0x1A4 | `ps2/include/menuop.hpp:518` | - |
| DONY_SHOP_ITEM | 0x4 | `ps2/include/menushop.hpp:107` | - |
| SHOP_PRICE_INFO | 0x8 | `ps2/include/menushop.hpp:119` | - |
| CShop | 0x120C | `ps2/include/menushop.hpp:235` | - |
| CShopMenu | 0x210 | `ps2/include/menushop.hpp:413` | - |
| CMenuQuestView | 0x190 | `ps2/include/menushop.hpp:473` | - |
| MENU_SWAPITEM_INFO | 0x8 | `ps2/include/menusys.hpp:393` | - |
| MENU_ASKMODE_PARA | 0x94 | `ps2/include/menusys.hpp:469` | - |
| ITEMCMD_RET_PARA | 0x14 | `ps2/include/menusys.hpp:488` | - |
| CMENU_USERPARAM | 0x18 | `ps2/include/menusys.hpp:531` | - |
| MENU_INPUTKEY_ARG | 0x24 | `ps2/include/menusys.hpp:551` | - |
| CBaseMenuClass | 0x110 | `ps2/include/menusys.hpp:880` | - |
| CMenuKeyFunc | 0x160 | `ps2/include/menusys.hpp:1318` | - |
| CMenuItemInfo | 0x370 | `ps2/include/menusys.hpp:1723` | - |
| CItemSelect | 0x450 | `ps2/include/menusys.hpp:1817` | - |
| MENU_ITEM_CURSOR_INFO | 0xC | `ps2/include/menusys.hpp:1832` | - |
| BUILDUP_WEAPON_INFO | 0x44 | `ps2/include/menusys.hpp:1854` | - |
| mgCCamera | 0x70 | `ps2/include/mg_camera.hpp:299` | - |
| mgCCameraFollow | 0xC0 | `ps2/include/mg_camera.hpp:547` | - |
| mgCreateVisualType | 0x8 | `ps2/include/mg_dataset.hpp:99` | - |
| mgLoadData | 0x40 | `ps2/include/mg_dataset.hpp:117` | - |
| mgCMDTBuilder | 0x90 | `ps2/include/mg_dataset.hpp:292` | cursor(int, address); face_block_addr(int, address); face_end(int, address) |
| mgVu0FBOX | 0x20 | `ps2/include/mg_drawenv.hpp:59` | - |
| mgPOINT_LIGHT | 0x30 | `ps2/include/mg_drawenv.hpp:90` | - |
| mgLIGHT_INFO | 0x150 | `ps2/include/mg_drawenv.hpp:104` | - |
| mgFOG_PARAM | 0x30 | `ps2/include/mg_drawenv.hpp:143` | - |
| mgCDrawEnv | 0x40 | `ps2/include/mg_drawenv.hpp:228` | - |
| mgCVisualAttr | 0x18 | `ps2/include/mg_drawenv.hpp:266` | - |
| mgCFrameAttr | 0x90 | `ps2/include/mg_drawenv.hpp:331` | - |
| mgRENDER_INFO | 0x1020 | `ps2/include/mg_drawenv.hpp:615` | - |
| mgSORT_PACKET | 0x10 | `ps2/include/mg_drawprim.hpp:123` | - |
| mgCDrawManager | 0x80 | `ps2/include/mg_drawprim.hpp:265` | - |
| mgCDrawPrim | 0x120 | `ps2/include/mg_drawprim.hpp:777` | - |
| mgCObject | 0x50 | `ps2/include/mg_frame.hpp:250` | - |
| mgCFrameBase | 0x50 | `ps2/include/mg_frame.hpp:277` | - |
| mgCFrame::BoundInfo | 0xB0 | `ps2/include/mg_frame.hpp:774` | - |
| mgCFrame | 0x110 | `ps2/include/mg_frame.hpp:775` | - |
| mgMEMORY_BLOCK | 0x10 | `ps2/include/mg_memory.hpp:36` | - |
| mgCMemory | 0x30 | `ps2/include/mg_memory.hpp:245` | - |
| mgCShadowMDT | 0x50 | `ps2/include/mg_shadow.hpp:81` | - |
| mgCShadowFixMDT | 0x50 | `ps2/include/mg_shadow.hpp:93` | - |
| mg3DSpriteRenderInfo | 0x280 | `ps2/include/mg_sprite.hpp:100` | - |
| mgC3DSprite | 0x50 | `ps2/include/mg_sprite.hpp:340` | - |
| `mgRect<int>` | 0x10 | `ps2/include/mg_tanime.hpp:131` | - |
| mgCEnterIMGInfo | 0x100 | `ps2/include/mg_texture.hpp:207` | - |
| mgCTexture | 0x70 | `ps2/include/mg_texture.hpp:283` | - |
| mgCTexAnimeData | 0x34 | `ps2/include/mg_texture.hpp:344` | - |
| `CList<mgCTexAnimeData>` | 0x40 | `ps2/include/mg_texture.hpp:345` | - |
| mgCTextureAnime | 0x1E4 | `ps2/include/mg_texture.hpp:512` | - |
| mgCTextureBlock | 0x10 | `ps2/include/mg_texture.hpp:569` | - |
| mgTEXTURE_HASH | 8 | `ps2/include/mg_texture.hpp:582` | - |
| mgCTextureManager | 0x21C | `ps2/include/mg_texture.hpp:946` | vram_top(int, VRAM address); vram_fix(int, VRAM address) |
| mgMaterial | 0x30 | `ps2/include/mg_visual.hpp:125` | - |
| mgCFace | 0x30 | `ps2/include/mg_visual.hpp:148` | - |
| mgFACE_GROUP | 0x20 | `ps2/include/mg_visual.hpp:166` | - |
| mgCVisual | 0x20 | `ps2/include/mg_visual.hpp:322` | vu1_base(int, VU1 address); vu1_offset(int, offset) |
| mgCVisualMDT | 0x50 | `ps2/include/mg_visual.hpp:559` | - |
| mgCVisualFixMDT | 0x50 | `ps2/include/mg_visual.hpp:634` | - |
| mgVisualGifTag | 0x10 | `ps2/include/mg_visual.hpp:879` | - |
| MG_PICKZ | 0x10 | `ps2/include/mglib.hpp:98` | - |
| MONSTER_SCOOP | 0x18 | `ps2/include/monster.hpp:181` | - |
| MONSTER_STATUS | 0xC | `ps2/include/monster.hpp:195` | - |
| MONSTER_REACT | 0x8 | `ps2/include/monster.hpp:209` | - |
| CActiveMonster | 0x14A0 | `ps2/include/monster.hpp:371` | - |
| MONSTER_REFER | 0x14C0 | `ps2/include/monster.hpp:384` | - |
| CMonsterLocateInfo | 0x8C | `ps2/include/monster.hpp:410` | - |
| CMonsterMan | 0x100F0 | `ps2/include/monster.hpp:731` | - |
| TimeStamp | 0x18 | `ps2/include/movie.hpp:64` | pos(int, offset) |
| QWORD | 0x10 | `ps2/include/movie.hpp:76` | - |
| ViBuf | 0x60 | `ps2/include/movie.hpp:106` | - |
| VideoDec | 0xB8 | `ps2/include/movie.hpp:123` | - |
| VoData | 0xE0000 | `ps2/include/movie.hpp:134` | - |
| VoTag | 0x48 | `ps2/include/movie.hpp:148` | - |
| VoBuf | 0x18 | `ps2/include/movie.hpp:164` | - |
| StrFile | 0x34 | `ps2/include/movie.hpp:180` | - |
| AudioDec | 0x5C | `ps2/include/movie.hpp:218` | iop_buff(int, IOP address); iop_zero(int, IOP address) |
| CMovie | 0x23940 | `ps2/include/movie.hpp:443` | - |
| MOVIE_LIST_ENTRY | 0xC | `ps2/include/movieviewlp.hpp:23` | - |
| NAMEREGI_TARGET_INFO | 0x48 | `ps2/include/nameregi.hpp:77` | - |
| NAMEREGI_KANJI_INDEX | 0x10 | `ps2/include/nameregi.hpp:114` | - |
| CNameRegiMenu | 0xBC8 | `ps2/include/nameregi.hpp:294` | - |
| MES_WIN_TBL | 0x10 | `ps2/include/nd_meswin.hpp:194` | - |
| ClsMes | 0x2958 | `ps2/include/nd_meswin.hpp:1066` | - |
| NowLoadingInfo | 0x3C | `ps2/include/nowload.hpp:53` | - |
| PAUSE_INFO | 0x8 | `ps2/include/nowload.hpp:66` | - |
| NPC_BASE_DATA | 0x36 | `ps2/include/npccfg.hpp:62` | - |
| CObject | 0x70 | `ps2/include/object.hpp:210` | - |
| CObjectFrame | 0x80 | `ps2/include/object.hpp:327` | - |
| COcclusion | 0xC0 | `ps2/include/occlusion.hpp:53` | - |
| COutLineDraw | 0x70 | `ps2/include/outline.hpp:90` | - |
| PAD_CTRL_BTN | 0x8 | `ps2/include/padcontrol.hpp:124` | - |
| PAD_CTRL_ANALOG | 0x8 | `ps2/include/padcontrol.hpp:136` | - |
| CPadControl | 0x510 | `ps2/include/padcontrol.hpp:213` | - |
| CFragment | 0x60 | `ps2/include/pot.hpp:129` | - |
| CBPot | 0xC50 | `ps2/include/pot.hpp:200` | - |
| CPot | 0x80 | `ps2/include/pot.hpp:311` | - |
| CPreSprite | 0x130 | `ps2/include/prespr.hpp:79` | - |
| QUEST_INFO | 0x3D0 | `ps2/include/quest.hpp:50` | - |
| CQuestManager | 0x8 | `ps2/include/quest.hpp:100` | - |
| RS_STACKDATA | 0x8 | `ps2/include/runscript.hpp:148` | - |
| RS_CALLDATA | 0xC | `ps2/include/runscript.hpp:194` | - |
| CRunScript | 0x54 | `ps2/include/runscript.hpp:450` | - |
| RS_EXTFUNC_INFO | 0x8 | `ps2/include/runscript_opcodes.hpp:210` | - |
| sceDmaChcr | 4 | `ps2/include/sce/libdma.h:39` | - |
| sceDmaChan | 0x90 | `ps2/include/sce/libdma.h:40` | madr(u_int, address), tadr(u_int, address), asr0(u_int, address), asr1(u_int, address), sadr(u_int, address) |
| sceDmaEnv | 0x14 | `ps2/include/sce/libdma.h:58` | - |
| CRipple | 0x30 | `ps2/include/scene.hpp:225` | - |
| CParticle | 0x50 | `ps2/include/scene.hpp:295` | - |
| CRainDrop | 0xB0 | `ps2/include/scene.hpp:363` | - |
| CRain | 0xABF0 | `ps2/include/scene.hpp:464` | - |
| CSceneData | 0x34 | `ps2/include/scene.hpp:494` | - |
| CSceneCharacter | 0x40 | `ps2/include/scene.hpp:531` | - |
| CSceneMap | 0x38 | `ps2/include/scene.hpp:566` | - |
| CSceneMessage | 0x38 | `ps2/include/scene.hpp:601` | - |
| CSceneCamera | 0x38 | `ps2/include/scene.hpp:636` | - |
| CSceneSky | 0x38 | `ps2/include/scene.hpp:671` | - |
| CSceneGameObj | 0x40 | `ps2/include/scene.hpp:693` | - |
| CSceneEffect | 0x38 | `ps2/include/scene.hpp:728` | - |
| CSceneEventData | 0xD0 | `ps2/include/sceneevent.hpp:97` | - |
| SCN_LOADMAP_INFO2::MapFiles | 0xB4 | `ps2/include/sceneload.hpp:105` | - |
| SCN_LOADMAP_INFO2 | 0x1A8 | `ps2/include/sceneload.hpp:106` | - |
| `mgCObjectStack<CList<EMAP_MESSAGE> >` | 0x14 | `ps2/include/sceneload.hpp:156` | - |
| SPLINE_KEY | 0x38 | `ps2/include/sceneseq.hpp:182` | - |
| C3DSpline | 0x39C | `ps2/include/sceneseq.hpp:262` | - |
| CCameraPas | 0x950 | `ps2/include/sceneseq.hpp:417` | - |
| CCharaPas | 0x4B0 | `ps2/include/sceneseq.hpp:571` | - |
| _SEN_CMR_SEQ | 0x60 | `ps2/include/sceneseq.hpp:607` | - |
| _SEN_OBJ_SEQ | 0x50 | `ps2/include/sceneseq.hpp:644` | - |
| CSceneCmrSeq | 0xB10 | `ps2/include/sceneseq.hpp:1213` | - |
| CSceneObjSeq | 0x5F0 | `ps2/include/sceneseq.hpp:1825` | - |
| DNG_BATTLE_AREA | 0xA8 | `ps2/include/scenesnd.hpp:219` | - |
| SND_FILE_INFO | 0x24 | `ps2/include/scenesnd.hpp:240` | - |
| SE_SRC_PLAY_INFO | 0x88 | `ps2/include/scenesnd.hpp:268` | - |
| CScene::BGM_INFO | 0x460 | `ps2/include/scenesnd.hpp:2354` | - |
| CScene::BGM_STATUS | 0x1C | `ps2/include/scenesnd.hpp:2355` | - |
| CScene::InScreenCharaInfo | 0xC | `ps2/include/scenesnd.hpp:2356` | - |
| CScene | 0x10550 | `ps2/include/scenesnd.hpp:2357` | - |
| GAMEOBJ_PLACE | 0x10 | `ps2/include/scenevillager.hpp:110` | - |
| GAMEOBJ_INFO | 0x50 | `ps2/include/scenevillager.hpp:126` | - |
| input_str | 0xC | `ps2/include/scriptinterpreter.hpp:113` | position(int, offset) |
| SPI_STACK | 0x8 | `ps2/include/scriptinterpreter.hpp:144` | - |
| SPI_TAG_PARAM | 0x8 | `ps2/include/scriptinterpreter.hpp:164` | - |
| SPI_TAG_HASH | 0x10 | `ps2/include/scriptinterpreter.hpp:178` | - |
| CScriptInterpreter | 0xED0 | `ps2/include/scriptinterpreter.hpp:339` | - |
| SND_LOOP_SE_SEQ | 0x14 | `ps2/include/snd_mngr.hpp:162` | - |
| CLoopSeMngr | 0x8 | `ps2/include/snd_mngr.hpp:270` | - |
| sndSeInfo | 0xC | `ps2/include/snd_mngr.hpp:298` | - |
| sndBankInfo | 0x1C | `ps2/include/snd_mngr.hpp:365` | - |
| sndPortSeSeq | 0x8 | `ps2/include/snd_mngr.hpp:389` | - |
| sndPortInfo | 0x29C | `ps2/include/snd_mngr.hpp:514` | - |
| sndSeSeqEvent | 0x6 | `ps2/include/snd_seseq.hpp:74` | - |
| sndSeSeqVoice | 0x4 | `ps2/include/snd_seseq.hpp:96` | - |
| sndCSeSeqData | 0x10 | `ps2/include/snd_seseq.hpp:143` | - |
| sndTrack | 0x10 | `ps2/include/snd_seseq.hpp:256` | - |
| sndCSeSeq | 0xB0 | `ps2/include/snd_seseq.hpp:459` | - |
| MIDI_FADE | 0x10 | `ps2/include/sound.hpp:53` | - |
| MIDI_PORT | 0x124 | `ps2/include/sound.hpp:83` | spu_address(s32, address); spu_next_address(s32, address) |
| MIDI_STATE | 0x1240 | `ps2/include/sound.hpp:94` | - |
| MIDI_BANK | 0x44 | `ps2/include/sound.hpp:112` | spu_address(s32, address) |
| MSIN_BUFFER | 0x200 | `ps2/include/sound.hpp:126` | - |
| STREAM_PACK_REQUEST | 0x40 | `ps2/include/sound.hpp:138` | - |
| CSound | 1 | `ps2/include/sound.hpp:525` | - |
| GOLF_CLUB_DEF | 0xC | `ps2/include/sphida.hpp:72` | - |
| CPowGage | 0x24 | `ps2/include/sphida.hpp:132` | - |
| CSphida | 0x240 | `ps2/include/sphida.hpp:315` | - |
| SubGameInfo | 0x30 | `ps2/include/subgame.hpp:83` | - |
| sgCPlayVoice | 0x14 | `ps2/include/subgame.hpp:164` | - |
| CSWordAfterEffect | 0xA0 | `ps2/include/swordeffect.hpp:190` | - |
| TITLE_INFO | 0x194 | `ps2/include/title.hpp:286` | - |
| RUSH_INFO | 0x18 | `ps2/include/title.hpp:303` | - |
| HDD_INFO | 0x24 | `ps2/include/title.hpp:325` | - |
| MOS_HENGE_PARAM | 0x1C | `ps2/include/userdata.hpp:322` | - |
| BATTLE_WEAPON_PARAM | 0x1C | `ps2/include/userdata.hpp:2182` | - |
| CBattleCharaInfo | 0x90 | `ps2/include/userdata.hpp:2612` | - |
| CVillagerPlaceInfo::Node | 0x20 | `ps2/include/villagermngr.hpp:141` | - |
| CVillagerPlaceInfo | 0x40 | `ps2/include/villagermngr.hpp:142` | - |
| CVillagerPlace::ProgressInfo | 0x28 | `ps2/include/villagermngr.hpp:186` | - |
| CVillagerPlace | 0x8 | `ps2/include/villagermngr.hpp:187` | - |
| CVillagerData | 0x70 | `ps2/include/villagermngr.hpp:239` | - |
| CVillagerMngr | 0xE10 | `ps2/include/villagermngr.hpp:394` | - |
| mgVertexWeight | 0x20 | `ps2/include/visualmotion.hpp:37` | matrix[4](int, offset) |
| mgCVMotionData | 0x14 | `ps2/include/visualmotion.hpp:54` | - |
| mgCVisualMotionMDT | 0x110 | `ps2/include/visualmotion.hpp:203` | - |
| GAME_PROGRESS_INFO | 0xC | `ps2/include/vlgr_info.hpp:51` | - |
| CVillagerInfo | 0x1C | `ps2/include/vlgr_info.hpp:79` | - |
| FireRasterParticle | 0x20 | `ps2/include/water.hpp:42` | - |
| CFireRaster | 0x2F0 | `ps2/include/water.hpp:105` | - |
| CWater | 0x80 | `ps2/include/water.hpp:262` | packet(u_int, address) |
| CWaterFrame | 0x120 | `ps2/include/water.hpp:377` | - |
| CWaveTable | 0x1208 | `ps2/include/wavetable.hpp:91` | - |
| DngTreeReadNames | 8 | `ps2/src/dngmenu.cpp:3917` | - |
| EditGsTest | 8 | `ps2/src/editexception.cpp:132` | - |
| GeoRequestCheck | 0x440 | `ps2/src/editmenu.cpp:184` | - |
| aqua_food_info | 10 | `ps2/src/menuaqua.cpp:105` | - |
| fish_breed_pair | 3 | `ps2/src/menuaqua.cpp:147` | - |
| aqua_fish_info | 12 | `ps2/src/menuaqua.cpp:161` | - |
| aqua_col_point | 0x20 | `ps2/src/menuaqua.cpp:205` | - |
| mgVISUAL_SETUP_PACKET | 0x140 | `ps2/src/mg_visual.cpp:41` | - |
| SpriteGsPacket | 0x10 | `ps2/src/prespr.cpp:15` | - |
| WaterRenderPacket | 0x260 | `ps2/src/water.cpp:47` | - |
| WaterStripPacket | 0x30 | `ps2/src/water.cpp:60` | - |
| WaterDmaTag | 0x10 | `ps2/src/water.cpp:73` | address(u_int, address) |
| WaterFinishPacket | 0x30 | `ps2/src/water.cpp:86` | dma.address(u_int, address), ret.address(u_int, address) |
