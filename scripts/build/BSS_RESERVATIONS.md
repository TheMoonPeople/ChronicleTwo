# BSS reservation evidence

Fresh raw linked compiles classify 157 BSS gaps. Two have original compiler
alignment proof and need no reservation; the other 155 placements across 23
units are explicit unresolved retail storage in
`postprocess_object.py:BSS_RETAIL_RESERVATIONS`. One of them belongs to a
function-local static: `CMenuChrCngMenu::KeyChangeMain` in `menuchr.cpp`
declares `static s8 SelectedCmdNo`, which the postprocessor binds to the retail
slot `SelectedCmdNo_1415`; its one byte at `0x0037e244` is followed by its
one-byte guard `init_1416` at `0x0037e248`, and the native guard's alignment of
one does not explain that gap.

| Classification | Count | Evidence |
|---|---:|---|
| Native alignment | 2 | Exact following native extent and original alignment explain the gap. |
| Four-byte placement | 141 | Retail small-data placement fits minimum-four-byte alignment; its original policy is unproved. |
| Retained following marker | 10 | The following retail object has no native alignment proof. |
| Larger gap | 4 | Original following alignment contradicts the observed gap. |

The four-byte group contains 139 scalar/guard slots and two aggregate slots:
`editmenu:GeoramaMesMakeManner` is five bytes followed by a short;
`menuaqua:GyoraceFishSel` is six bytes followed by a byte. Their own alignment
of eight does not round their tails under default MWLD.

## Compiler and linker measurements

Tiny units use MWCC 3.0-011126 through the pinned Satan's Fiddle wrapper and the
project's `-O3,p -strings readonly -c -Cpp_exceptions off -RTTI off
-pragma 'divbyzerocheck on' -i ps2/include` flags. Raw ELF section alignment
is measured before postprocessing. Links use MWLD 2.4-001213 with
`-map -nostdlib -nodead -g` and a probe entry point.

| Raw global definition | Alignment |
|---|---:|
| `char`, `short`, `int`/`float`/pointer scalar | 1, 2, 4 respectively |
| `long`, `long long`, `double` scalar | 8 |
| `__int128` scalar | 16 |
| Array/struct of 1-4 bytes | 4 |
| Array/struct of 5-15 bytes | 8 |
| Array/struct of 16-65,536 bytes | 16 |

Initialized aggregates have the same promotions. The small-data threshold is
eight bytes. Promotions already appear in `sh_addralign`; calculating type
size supplies no additional alignment evidence. Explicit
`__attribute__((aligned(64)))` and `aligned(128)` expose those larger values
in the raw object, while none of the tested ordinary aggregates does.

Default MWLD rounds the current end to the following section's alignment.
A five-byte byte array followed by a short leaves one byte; a six-byte short
array followed by a byte leaves none. `ALIGNALL(4);` reproduces their retail
gaps of three and two bytes and places byte/short globals on four-byte
boundaries. This demonstrates a possible policy, without proving the missing
retail linker command file used it. Explicit `ALIGNALL(64);` or
`ALIGNALL(128);` likewise places raw 4/16-aligned objects farther apart;
retail addresses alone do not establish those policies.

Canonical MWCC C tentative definitions emit `.sbss`/`.bss`, not COMMON.
GNU-as COMMON probes show MWLD honoring supplied symbol alignment: byte
commons with alignment one are adjacent, and a 64-byte COMMON with supplied
alignment one remains unaligned. COMMON itself establishes neither a
minimum-four-byte rule nor aggregate size promotion. The current raw objects
are not COMMON. No measured evidence establishes omitted retail objects or a
section-start cause for these gaps; all gaps are internal to their unit runs.

## Unresolved storage and comparison credit

The four larger gaps are `convviewlp:ConvertResultDispTime` to
`SaveFileInfoTablePtr` (48 bytes), `menuaqua:menu_debug_select` to
`aquarium_xz_table` (14), `menuaqua:aquarium_xz_table` to `aquarium_y_table`
(12), and `sound:msinBfCtx` to `msinBf` (56). Following raw alignments are
4, 4, 4 and 16. None explains the retail placement.

Exact exception tuples retain known section storage through the first
canonical cut. They preserve the owner symbol's declared size and do not
materialize the following marker-owned payload. Unknown tuples, changed
extents, ambiguous native ownership, interior declarations and relocation
fields cannot use an exception. The ordinary path separately requires
measured original following-object alignment. Both paths use the same native
extent snapshot for linked and source-only objects.
The list also records measured following alignments and explicitly distinguishes
retained marker storage from rejected live native evidence. A marker state
requires the source to retain that marker; current native or placeholder
storage must fit its object/piece bound, and live competing objects block
canonical fragment traversal. `dng_main:init_1107` records both a linked
following marker and a valid one-byte source-only native guard; the retained
guard itself is still excluded from comparison credit.
References bound to the same retained placeholder may keep declaration aliases
at offset zero, with the exact declared object or complete piece extent. The
`dbinfo` and title-global aliases share that one fallback payload; unrelated
names, offsets, types, sizes or sections remain rejected.

Existing objdiff credit includes accepted BSS reservation storage. Keeping that
metric unchanged supplies no independent proof of these gaps' compiler/linker
cause. Retained marker pieces continue to supply no native data credit.
Complete object-byte and PAL checks remain required. Regression coverage is
in `test_bss_original_alignment.py` and `test_data_padding.py`.

## Complete inventory

Addresses and sizes are retail declarations. Alignment is the following
object's original native section alignment; `none` means absent native proof. The two native-alignment rows are excluded from the exception
list. Every other row is an unresolved placement.

| Unit | Owner | Start | Size | Gap | Following object | Alignment | Classification |
|---|---|---:|---:|---:|---|---:|---|
| convviewlp | `ConvertResultDispTime` | 0x0037ea8c | 4 | 48 | `SaveFileInfoTablePtr` | 4 | Larger gap |
| convviewlp | `init_817` | 0x0037eac8 | 1 | 3 | `init_820` | 1 | Four-byte placement |
| convviewlp | `init_820` | 0x0037eacc | 1 | 3 | `init_823` | 1 | Four-byte placement |
| convviewlp | `init_823` | 0x0037ead0 | 1 | 3 | `init_826` | 1 | Four-byte placement |
| dng_debug | `dbFont` | 0x01ecdc30 | 184 | 8 | `dbinfo` | none | Retained following marker |
| dng_main | `nowload` | 0x01ee5210 | 60 | 4 | `at_941__2` | none | Retained following marker |
| dng_main | `init_1107` | 0x0037d470 | 1 | 3 | `init_1824` | none | Retained following marker |
| dngmenu | `dngfloor_infoview` | 0x0037d52c | 1 | 3 | `dngfloor_backdraw` | 1 | Four-byte placement |
| dngmenu | `DngInfoFishOkFlag` | 0x0037d53c | 1 | 3 | `DngInfoSphidaOkFlag` | 1 | Four-byte placement |
| dngmenu | `DngInfoSphidaOkFlag` | 0x0037d540 | 1 | 3 | `DngAskMessageDrawFlag` | 1 | Four-byte placement |
| dngmenu | `GeoramaMateriaInfoDrawFlag` | 0x0037d568 | 1 | 3 | `GeoramaMateriaInfoDrawPage` | 1 | Four-byte placement |
| dngmenu | `GeoramaMateriaInfoDrawPage` | 0x0037d56c | 1 | 3 | `GeoramaMateriaNum` | 2 | Four-byte placement |
| dngmenu | `DngTreeMode` | 0x0037d57c | 2 | 2 | `TreeMapSaveFlag` | 1 | Four-byte placement |
| dngmenu | `TreeMapSaveFlag` | 0x0037d580 | 1 | 3 | `TreeMapSaveNum` | 2 | Four-byte placement |
| dngmenu | `TreeMapSaveNum` | 0x0037d584 | 2 | 2 | `TreeMapSaveDispCount` | 2 | Four-byte placement |
| dngmenu | `TreeMapSaveDispY` | 0x0037d590 | 2 | 2 | `TreeMapCallDungeonSubMap` | 1 | Four-byte placement |
| dngmenu | `TreeMapCallDungeonSubMap` | 0x0037d594 | 1 | 3 | `TreeMapCalledWorldMap` | 1 | Four-byte placement |
| dngmenu | `init_1744` | 0x0037d564 | 1 | 3 | `GeoramaMateriaInfoDrawFlag` | 1 | Four-byte placement |
| dngmenu | `init_2837` | 0x0037d5b8 | 1 | 3 | `at_3040__2` | 4 | Native alignment |
| editmenu | `HouseInfoSelectLine` | 0x0037d5e4 | 2 | 2 | `HouseInfoSelectSelect` | 2 | Four-byte placement |
| editmenu | `HouseInfoSelectSelect` | 0x0037d5e8 | 2 | 2 | `HouseInfoSelectMoveInit` | 1 | Four-byte placement |
| editmenu | `DownLoadInfoEndFlag` | 0x0037d60c | 1 | 3 | `DownLoadInfoDrawFlag` | 1 | Four-byte placement |
| editmenu | `DownLoadDispNum` | 0x0037d620 | 2 | 2 | `DownLoadProgress` | 2 | Four-byte placement |
| editmenu | `DownLoadProgress` | 0x0037d624 | 2 | 2 | `DownLoadMesMakeProgress` | 1 | Four-byte placement |
| editmenu | `DownLoadMesUpY` | 0x0037d638 | 2 | 2 | `old_menuparts_pos_flag` | 1 | Four-byte placement |
| editmenu | `old_menuparts_pos_flag` | 0x0037d63c | 1 | 3 | `NowPolyGonFormMoveFlag` | 1 | Four-byte placement |
| editmenu | `MenuGeoramaCursorForceSetFlag` | 0x0037d64c | 1 | 3 | `MenuGeoStoneDonwLoadFlag` | 1 | Four-byte placement |
| editmenu | `MenuGeoStoneDonwLoadFlag` | 0x0037d650 | 1 | 3 | `MenuGeoStoneDownLoad_PartsNum` | 2 | Four-byte placement |
| editmenu | `MenuGeoStoneDownLoad_PartsNum` | 0x0037d654 | 2 | 2 | `MenuGeoStoneDownLoad_Request` | 2 | Four-byte placement |
| editmenu | `GeoramaParts_DrawWaitCnt` | 0x0037d6a4 | 2 | 2 | `GeoramaMesPosForceSetFlag` | 1 | Four-byte placement |
| editmenu | `GeoramaMesMakeManner` | 0x0037d6b0 | 5 | 3 | `GeoramaReqMakeLine` | 2 | Four-byte placement |
| editmenu | `GeoramaReqMakeLine` | 0x0037d6b8 | 2 | 2 | `GeoramaReqMakeManner` | 2 | Four-byte placement |
| editmenu | `GeoramaReqMakeManner` | 0x0037d6bc | 2 | 2 | `GeoramaMesForceMakeFlag` | 1 | Four-byte placement |
| editmenu | `GeoramaMesForceMakeFlag` | 0x0037d6c0 | 1 | 3 | `GeoramaMesForceMakeFlag_PaintVer` | 1 | Four-byte placement |
| editmenu | `cnt_2177` | 0x0037d6f0 | 1 | 3 | `init_2178` | 1 | Four-byte placement |
| editmenu | `init_3581` | 0x0037d71c | 1 | 3 | `DestroyMaxNum_3584` | 2 | Four-byte placement |
| editmenu | `DestroyMaxNum_3584` | 0x0037d720 | 2 | 2 | `init_3585` | 1 | Four-byte placement |
| editmode | `at_1149__2` | 0x01f58000 | 12 | 4 | `at_1445__3` | 16 | Native alignment |
| funcpoint | `init_1175` | 0x0037dfc8 | 1 | 3 | `init_1204` | 1 | Four-byte placement |
| funcpoint | `init_1204` | 0x0037dfcc | 1 | 3 | `init_1208` | 1 | Four-byte placement |
| gamepad | `rpad_256` | 0x0037cf30 | 2 | 2 | `init_257` | 1 | Four-byte placement |
| inventmn | `pic_name_info_num` | 0x0037d778 | 2 | 2 | `pic_name_info_num_count` | 2 | Four-byte placement |
| inventmn | `InventInNetaEffectFlag` | 0x0037d7e8 | 1 | 3 | `InventInNetaEffectNum` | 1 | Four-byte placement |
| inventmn | `InventInNetaEffectNum` | 0x0037d7ec | 1 | 3 | `InventInNetaEffectNum4` | 2 | Four-byte placement |
| inventmn | `ActiveSlot_3949` | 0x0037d7f8 | 1 | 3 | `init_3950` | 1 | Four-byte placement |
| mainloop | `init_1225` | 0x0037d18c | 1 | 3 | `init_1228` | 1 | Four-byte placement |
| mainloop | `init_1228` | 0x0037d190 | 1 | 3 | `init_1231` | 1 | Four-byte placement |
| mainloop | `init_1231` | 0x0037d194 | 1 | 3 | `init_1234` | 1 | Four-byte placement |
| map | `init_1249` | 0x0037cf88 | 1 | 3 | `init_1301` | 1 | Four-byte placement |
| menuaqua | `menu_debug_select` | 0x0037d860 | 2 | 14 | `aquarium_xz_table` | 4 | Larger gap |
| menuaqua | `aquarium_xz_table` | 0x0037d870 | 4 | 12 | `aquarium_y_table` | 4 | Larger gap |
| menuaqua | `GyoraceFishSelectMode` | 0x0037d8bc | 1 | 3 | `GyoraceFishSelectNo` | 2 | Four-byte placement |
| menuaqua | `GyoraceFishSelectNo` | 0x0037d8c0 | 2 | 2 | `GyoraceFishSelTexBk` | 2 | Four-byte placement |
| menuaqua | `GyoraceFishSelTexBk` | 0x0037d8c4 | 2 | 2 | `GyoraceFishFrameImgTexNo` | 2 | Four-byte placement |
| menuaqua | `GyoraceFishFrameImgTexNo` | 0x0037d8c8 | 2 | 2 | `GyoraceFishSelNum` | 1 | Four-byte placement |
| menuaqua | `GyoraceFishSel` | 0x0037d8d0 | 6 | 2 | `GyoRaceFishReadPhase` | 1 | Four-byte placement |
| menuaqua | `GyoRaceFishReadPhase` | 0x0037d8d8 | 1 | 3 | `GyoRaceAquariumNo` | 1 | Four-byte placement |
| menuaqua | `GyoRaceAquariumNo` | 0x0037d8dc | 1 | 3 | `GyoRaceClass` | 1 | Four-byte placement |
| menuaqua | `GyoRaceClass` | 0x0037d8e0 | 1 | 3 | `GyoRaceProgressNum` | 1 | Four-byte placement |
| menuaqua | `GyoRaceProgressNum` | 0x0037d8e4 | 1 | 3 | `GyoRaceRankingData` | 1 | Four-byte placement |
| menuaqua | `spi_nowanalyze_gyorace_limmit` | 0x0037d8f8 | 2 | 2 | `spi_gyorace_counter` | 2 | Four-byte placement |
| menuaqua | `FishTournamentGoodsNum` | 0x0037d908 | 2 | 2 | `FishTournamentGoodsType` | 1 | Four-byte placement |
| menuaqua | `GyoraceMesDrawFlag` | 0x0037d92c | 1 | 3 | `GyoraceFishInfoDrawFlag` | 1 | Four-byte placement |
| menuaqua | `GyoraceNowMode` | 0x0037d958 | 2 | 2 | `GyoraceNowPhase` | 2 | Four-byte placement |
| menuaqua | `GyoraceNowPhase` | 0x0037d95c | 2 | 2 | `GyoraceQuestionMsgDrawFlag` | 1 | Four-byte placement |
| menuaqua | `GyoraceQuestionMsgDrawFlag` | 0x0037d960 | 1 | 3 | `GyoraceHaveFishCursorDrawFlag` | 1 | Four-byte placement |
| menuaqua | `init_3639` | 0x0037d8ac | 1 | 3 | `sel_sift_fish_select_3641` | 2 | Four-byte placement |
| menuaqua | `init_5178` | 0x0037d9ac | 1 | 3 | `save_now_space_racer_no_5180` | 1 | Four-byte placement |
| menuaqua | `save_now_space_racer_no_5180` | 0x0037d9b0 | 1 | 3 | `init_5181` | 1 | Four-byte placement |
| menuchr | `NowMainCharaChngStatusBit` | 0x0037e2c0 | 2 | 2 | `MenuNPCLoadFlag` | 1 | Four-byte placement |
| menuchr | `MenuDebugChangeSelectMode` | 0x0037e23c | 2 | 2 | `MenuDebugCharaChangeSelect` | 2 | Four-byte placement |
| menuchr | `MenuDebugCharaChangeSelect` | 0x0037e240 | 2 | 2 | `SelectedCmdNo_1415` | 1 | Four-byte placement |
| menuchr | `SelectedCmdNo_1415` | 0x0037e244 | 1 | 3 | `init_1416` | 1 | Four-byte placement |
| menuchr | `menu_debug_npc_decide` | 0x0037e238 | 1 | 3 | `MenuDebugChangeSelectMode` | 2 | Four-byte placement |
| menuchr | `menu_debug_npcselect` | 0x0037e234 | 1 | 3 | `menu_debug_npc_decide` | 1 | Four-byte placement |
| menucommon | `MenuTexPosNo` | 0x0037de3c | 2 | 2 | `MenuTexPosNo_local` | 2 | Four-byte placement |
| menucommon | `MenuTexPosNo_local` | 0x0037de40 | 2 | 2 | `menu_analyze_texblock` | 2 | Four-byte placement |
| menucommon | `Menu_Target_No` | 0x0037de4c | 2 | 2 | `Menu_Target_No_local` | 2 | Four-byte placement |
| menucommon | `menu_analyze_formno` | 0x0037de60 | 2 | 2 | `menu_analyze_formno_offset` | 2 | Four-byte placement |
| menudraw | `MenuMainFrame_ActionEndFlag` | 0x0037da50 | 1 | 3 | `MenuMainFrame_Display_Mode` | 2 | Four-byte placement |
| menudraw | `MainFrameStepFlag_2092` | 0x0037da80 | 1 | 3 | `init_2093` | 1 | Four-byte placement |
| menudraw | `fish_boiled_count` | 0x0037db34 | 2 | 2 | `fish_boiled_runflag` | 2 | Four-byte placement |
| menumain | `MenuNowMapNo` | 0x0037db60 | 2 | 2 | `MenuNowMapType` | 2 | Four-byte placement |
| menumain | `HatumeiMenuOkFlag` | 0x0037dbc8 | 1 | 3 | `WorldMapOkFlag` | 1 | Four-byte placement |
| menumain | `WorldMapOkFlag` | 0x0037dbcc | 1 | 3 | `ManualMenuOkFlag` | 1 | Four-byte placement |
| menumain | `ManualMenuOkFlag` | 0x0037dbd0 | 1 | 3 | `DngMoveMenuOkFlag` | 1 | Four-byte placement |
| menumain | `DngMoveMenuOkFlag` | 0x0037dbd4 | 1 | 3 | `MenuDoubleDrawCheck` | 1 | Four-byte placement |
| menumain | `MenuDoubleDrawCheck` | 0x0037dbd8 | 1 | 3 | `refresh_cnt_1523` | 1 | Four-byte placement |
| menumain | `refresh_cnt_1523` | 0x0037dbdc | 1 | 3 | `init_1524` | 1 | Four-byte placement |
| menumain | `MenuTopicType` | 0x0037dbf8 | 2 | 2 | `MenuTopicLength` | 2 | Four-byte placement |
| menumap | `SphidaMenuPhase` | 0x0037e1f8 | 2 | 2 | `SfidaMakeLine` | 2 | Four-byte placement |
| menumap | `SfidaMakeLine` | 0x0037e1fc | 2 | 2 | `SfidaMoveInitFlag` | 1 | Four-byte placement |
| menumap | `WorldMapMenuType` | 0x0037e18c | 1 | 3 | `WorldMap_NextLoopNo` | 2 | Four-byte placement |
| menumap | `WorldMap_NextLoopNo` | 0x0037e190 | 2 | 2 | `WorldMap_MapNo` | 2 | Four-byte placement |
| menumap | `WorldMap_MapNo` | 0x0037e194 | 2 | 2 | `WorldMap_DngFloor` | 2 | Four-byte placement |
| menumap | `MapEnableNum` | 0x0037e188 | 2 | 2 | `WorldMapMenuType` | 1 | Four-byte placement |
| menuop | `MovieViewFlag` | 0x0037e328 | 1 | 3 | `ManualMovieFadeCount_1253` | 2 | Four-byte placement |
| menuop | `Movie_BossFlag` | 0x0037e31c | 2 | 2 | `MovieBgmBattleCheckStopFlag` | 2 | Four-byte placement |
| menuop | `Movie_DungeonFlag` | 0x0037e318 | 2 | 2 | `Movie_BossFlag` | 2 | Four-byte placement |
| menuop | `SubGameSaveOrLoad` | 0x0037e3c8 | 1 | 3 | `SubGameSaveOrLoadPhase` | 2 | Four-byte placement |
| menuop | `SubGameSaveOrLoadPhase` | 0x0037e3cc | 2 | 2 | `SubGameSaveLoadStatus` | 2 | Four-byte placement |
| menuop | `SubGameSaveLoadStatus` | 0x0037e3d0 | 2 | 2 | `SubGameMCPort` | 1 | Four-byte placement |
| menuop | `MenuReturnMsgDrawFlag` | 0x0037e308 | 1 | 3 | `MovieBattleBGMPhase` | 1 | Four-byte placement |
| menuop | `MenuMapInfoSave_DngNo` | 0x0037e3c4 | 2 | 2 | `SubGameSaveOrLoad` | 1 | Four-byte placement |
| menuop | `ManualMovieFadeCount_1253` | 0x0037e32c | 2 | 2 | `init_1254` | 1 | Four-byte placement |
| menuop | `init_2005` | 0x0037e380 | 1 | 3 | `input_wait_counter_2067` | 1 | Four-byte placement |
| menuop | `input_wait_counter_2067` | 0x0037e384 | 1 | 3 | `init_2068` | 1 | Four-byte placement |
| menuop | `init_2550` | 0x0037e3c0 | 1 | 3 | `MenuMapInfoSave_DngNo` | 2 | Four-byte placement |
| menushop | `QuestViewCommentFlag` | 0x0037df60 | 1 | 3 | `QuestReactionCommentGyouNum` | 2 | Four-byte placement |
| menushop | `shop_mode_prev_1326` | 0x0037def4 | 2 | 2 | `init_1327` | 1 | Four-byte placement |
| menusys | `MenuItem_ItemBoardTopLine` | 0x0037dc20 | 2 | 2 | `MenuItem_ItemBoardTopSelect` | 2 | Four-byte placement |
| menusys | `MenuItemCmdArgPos` | 0x0037dc84 | 2 | 2 | `MenuItemCommand_RoboPackBreakFlag` | 2 | Four-byte placement |
| menusys | `MenuItemCommand_RoboPackBreakFlag` | 0x0037dc88 | 2 | 2 | `cmd_counter_1048` | 1 | Four-byte placement |
| menusys | `SpectolBreakNum_Limit` | 0x0037dca4 | 2 | 2 | `SpectolBreakNum` | 2 | Four-byte placement |
| menusys | `SpectolBreakNum` | 0x0037dca8 | 2 | 2 | `SpectolBreakSpPoint` | 2 | Four-byte placement |
| menusys | `MenuSpectolTransPos` | 0x0037dcc0 | 2 | 2 | `itemmenu_chr_rotflag` | 1 | Four-byte placement |
| menusys | `itemmenu_chr_rotflag` | 0x0037dcc4 | 1 | 3 | `sndflag_1665` | 1 | Four-byte placement |
| menusys | `MenuDebugCamera` | 0x0037dd88 | 4 | 4 | `at_6133` | none | Retained following marker |
| menusys | `init_4683` | 0x0037dd3c | 1 | 3 | `BuildEndFlag_4703` | 1 | Four-byte placement |
| menusys | `BuildEndFlag_4703` | 0x0037dd40 | 1 | 3 | `init_4704` | 1 | Four-byte placement |
| menusys | `init_6162` | 0x0037dd9c | 1 | 3 | `at_6176` | none | Retained following marker |
| menusys | `cmd_counter_1048` | 0x0037dc8c | 1 | 3 | `init_1049` | 1 | Four-byte placement |
| menusys | `sndflag_1665` | 0x0037dcc8 | 1 | 3 | `init_1666` | 1 | Four-byte placement |
| menusys | `count_time_3839` | 0x0037dd08 | 1 | 3 | `init_3840` | 1 | Four-byte placement |
| menusys | `checkmoveFlag_5411` | 0x0037dd58 | 1 | 3 | `init_5412` | 1 | Four-byte placement |
| menusys | `fusion_blinkcnt_7120` | 0x0037ddd8 | 1 | 3 | `init_7121` | 1 | Four-byte placement |
| menusys | `init_7121` | 0x0037dddc | 1 | 3 | `diffent_weapon_dispflag_7125` | 1 | Four-byte placement |
| menusys | `diffent_weapon_dispflag_7125` | 0x0037dde0 | 1 | 3 | `init_7126` | 1 | Four-byte placement |
| menusys | `init_7510` | 0x0037ddf0 | 1 | 3 | `count_7867` | 1 | Four-byte placement |
| menusys | `count_7867` | 0x0037ddf4 | 1 | 3 | `init_7868` | 1 | Four-byte placement |
| menusys | `init_7868` | 0x0037ddf8 | 1 | 3 | `MonicaRotationFlag` | 1 | Four-byte placement |
| menusys | `init_8719` | 0x0037de0c | 1 | 3 | `MenuItemSelectMode` | 1 | Four-byte placement |
| movie | `isStarted` | 0x0037df94 | 1 | 3 | `isStrFileInit` | 1 | Four-byte placement |
| movie | `isCountVblank` | 0x0037dfa8 | 1 | 3 | `isFrameEnd` | 1 | Four-byte placement |
| movie | `isWithAudio` | 0x0037df90 | 1 | 3 | `isStarted` | 1 | Four-byte placement |
| movie | `isStrFileInit` | 0x0037df98 | 1 | 3 | `Loop` | 1 | Four-byte placement |
| movieviewlp | `MovieLine` | 0x0037e420 | 2 | 2 | `MovieSelect` | 2 | Four-byte placement |
| movieviewlp | `init_792` | 0x0037e43c | 1 | 3 | `init_795` | 1 | Four-byte placement |
| movieviewlp | `init_795` | 0x0037e440 | 1 | 3 | `init_798` | 1 | Four-byte placement |
| movieviewlp | `init_798` | 0x0037e444 | 1 | 3 | `init_801` | 1 | Four-byte placement |
| sound | `msinBfCtx` | 0x003f3f80 | 72 | 56 | `msinBf` | 16 | Larger gap |
| title | `TitleOmakeFlag` | 0x0037e0cc | 2 | 2 | `TitleMCCheckBootMode` | 1 | Four-byte placement |
| title | `TitlePhase` | 0x0037e038 | 2 | 2 | `TitlePushStart_AlphaPlus` | 2 | Four-byte placement |
| title | `TitleMCActivePort` | 0x0037e024 | 2 | 2 | `TitleMCCheckNow` | none | Retained following marker |
| title | `DCSelectedMovie` | 0x0037e008 | 1 | 3 | `DCRuncherCounter` | none | Retained following marker |
| title | `TitleRushWaitCountBoot` | 0x0037dfd4 | 1 | 3 | `TitleSelectInit` | none | Retained following marker |
| title | `debug_start_drawflag` | 0x0037e098 | 1 | 3 | `HDDPhase` | 2 | Four-byte placement |
| title | `TitleCopyRightDispPhase` | 0x0037e044 | 1 | 3 | `TitleCopyRightDispCounter` | 2 | Four-byte placement |
| title | `TitleCopyRightDispCounter` | 0x0037e048 | 2 | 2 | `TitleSkipLogoFlag` | 1 | Four-byte placement |
| title | `HDDPhase` | 0x0037e09c | 2 | 2 | `HDDConfirmType` | 2 | Four-byte placement |
| title | `HDDConfirmType` | 0x0037e0a0 | 2 | 2 | `HDDnowDisplayImageNo` | 2 | Four-byte placement |
| title | `HDDnowDisplayImageNo` | 0x0037e0a4 | 2 | 2 | `HDDDlBarDrawFlag` | 1 | Four-byte placement |
| title | `HDDModeSelect` | 0x0037e0c8 | 2 | 2 | `TitleOmakeFlag` | 2 | Four-byte placement |
| title | `TitleSkipLogoFlag` | 0x0037e04c | 1 | 3 | `Tex_TitleBG` | none | Retained following marker |
| title | `TitleMCCheckBootMode` | 0x0037e0d0 | 1 | 3 | `TitleMCCheckPort` | 2 | Four-byte placement |
| title | `TitleMCCheckPort` | 0x0037e0d4 | 2 | 2 | `TitleMCCheckPhase` | 2 | Four-byte placement |
| title | `MasterDebugModeOn` | 0x0037dffc | 1 | 3 | `TitleBootEventNo` | none | Retained following marker |
