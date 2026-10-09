# menusys data migration (2026-10-08)

Lane base `91af9829` (checkpoint m24), canonical MWCC 3.0-011126 flags,
production Satan's Fiddle profile, image `chronicletwo_dev:sf-63f7a9e`.
The warm build passes `SCES_511.90: OK` and **149/149 objects**.
The refreshed baseline has **360 INCLUDE_RODATA / 126 INCLUDE_BSS**,
**4 / 10,332 matched_data**, and **161 / 165 native functions**.

The four guarded drafts are preserved verbatim, and the SF-controlled
`MenuItemDebugDraw` retains byte-identical code under the unchanged profile. No function promotion, profile change or toolchain change
is part of this migration. Every accepted step uses the normal full build,
the byte and resolved-relocation object checker, protected-body comparison,
and SHA-256 comparison of all 149 linked game objects. Only menusys's object
metadata may change; every unowned object hash remains equal to the warm build.
Receipts are under `.private/dataD-r2/`.

The source-definition inventories below describe this migration checkpoint.
The October 9 cleanup replaces ten explicit state/latch pairs and three
wrapper templates with natural local definitions while retaining their retail
storage; see [review-fixes-r2-20261009.md](review-fixes-r2-20261009.md).

## Object extents and existing types

Retail declared sizes are distinct from the splitter's padded reservation
lengths. Native definitions use the actual object extents; the existing
postprocessor supplies only the verified retail alignment tail. Important
extents are `ITEMCMD_RET_PARA` 0x14, `MenuCharaReadBuffers` 0xC,
`MENU_ITEM_CURSOR_INFO` 0xC, `BUILDUP_WEAPON_INFO` 0x44,
`CLevelUpEffectManager` 0x190, and `BuildUpNameXY` 0xC.
The saved fusion parameters have twelve signed shorts, and both build-up
part-pointer arrays have twelve entries. Their old ten-element source-only
extern declarations understate the retail symbols.

`CLevelUpEffectManager` and its eight effect records have no constructor or
destructor. Their fields are scalar values, pointers and vector arrays, so
native uninitialized storage does not introduce another static initializer.
The existing header types and global declarations remain source-compatible.

The same size distinction applies to initialized tables: the ridepod equipment
mapping has four signed bytes, confirm/cancel mappings are two rows of two
integers, and active-weapon part names have three rows of two pointers.
The palette-effect table is two rows of five integers describing RGB, pulse
count and duration. It does not hold motion identifiers.

## Native zero-initializer templates

The matched source already creates the following zero templates. Removing a
marker exposes that native compiler object; obsolete external declarations do
not establish a type for these anonymous initializers.

| Retail symbol | Native consumer and purpose |
| --- | --- |
| `at_1385__2` | `SetItemCmdMsgPos`, initial message screen coordinates. |
| `at_2345__2`, `at_2346__2` | `MenuGlidKeyCheck`, movement and step arrays. |
| `at_2564` | `CMenuKeyFunc::MenuPosStep`, initial cursor coordinates. |
| `at_3407` | `CMenuKeyFunc::CheckAnalogKey`, four analog input components. |
| `at_3791__2`, `at_3792__2` | `MenuPosFormValueSetWeapon`, gauge rates and status values. |
| `at_4365__2`, `at_4406`, `at_4423__2`, `at_4510` | `CMenuItemInfo::ItemCmdAfter`, name, movement and value arrays. |
| `at_5026` | `CommonSetMoveItemClass`, item-movement pointers. |
| `at_5532`, `at_5573` | `CMenuItemInfo::CalcTex`, monster values and name substitution. |
| `at_5769`, `at_5774`, `at_5782`, `at_5829` | `CMenuItemInfo::CalcCursorPosition`, position, offset and form arrays. |
| `at_7021` | `CMenuItemInfo::PushKey`, one null item-name pointer. |
| `at_7650`, `at_7688` | `MenuWeaponBuildUpDraw`, name positions and monster-name substitutions. |
| `at_9093` | `CItemSelect::Draw`, selection display coordinates. |

`at_7021` is a pointer-array initializer, despite the obsolete float extern;
its actual load/store through an FPR does not imply a floating-point value.
The existing PushKey analysis establishes that typed initializer.

## Named menu state

The ordinary state objects use the types established by the matched consumers
and existing headers: controller/model/message/form/texture pointers, signed
short quantities and positions, byte visibility/initialization flags, floating
animation counters and vectors, and the documented cursor/build-up records.
Migrated retail LOCAL state objects retain file-local linkage; existing public globals retain
their header-compatible declarations. Primitive persistent counters and their
one-byte initialization latches preserve the existing runtime initialization
and exact retail symbol names.

## Validation and retained markers

The final measurements and complete retained-marker inventory follow the
completed migration checks below.

### Zero-template checkpoint

All twenty-two zero-template removals pass independently. Markers are
**360 RODATA / 104 BSS**, with **4 / 10,332 matched_data**. PAL remains OK,
all 149 objects pass, and the four guards and compiler profile are unchanged.
The step ledger is `.private/dataD-r2/generated-bss-ledger.log`; per-template
receipts use `generated-<symbol>-{build,objects,metrics}.log`, with the first
check recorded as `generated-at_1385`.

### Named-state checkpoint

All sixty-five ordinary named reservations have native, documented C++
definitions. The native sizes and bindings pass PAL and all 149 object checks,
including the twelve-element fusion and form-pointer arrays. The state groups
are recorded by `named-bss-ledger.log` and
`bss-state-{1,2,3,4}-{build,objects,metrics}.log`.
Markers are **360 RODATA / 39 BSS** and data credit remains
**4 / 10,332** while the remaining template pieces keep aggregate sections
incomplete. The guarded drafts and unowned object hashes remain unchanged.

### Persistent-state checkpoint

All twenty-nine counter, pointer and latch reservations have native file-local
primitive definitions under their exact retail names. The existing runtime
initialization is unchanged, including the guarded effect/debug counters and
the saved preview fields whose stores must remain present. No artificial read,
volatile qualifier or additional constructor is needed.

Markers are **360 RODATA / 10 BSS**, with **4 / 10,332 matched_data**.
All thirteen counter groups pass PAL, 149/149 objects, protected guards and
unowned hashes independently. Receipts are `persistent-bss-ledger.log` and
`bss-<group>-{build,objects,metrics}.log` under `.private/dataD-r2/`.

### Natural local initializer checkpoint

The spectrumisation name substitution is a one-pointer automatic array, the
fusion name substitution has two pointer slots, and the breakdown values are
four integers initialized to zero. Their native aggregate templates replace
`at_1545`, `at_1685` and `at_1557`. At this migration checkpoint the accepted
`KeyPairTable` copy retained a file-local zero wrap-target object at
`at_2333__3`. The October 9 cleanup supplies both key-pair templates through
plain local-array initializers instead; see
[review-fixes-r2-20261009.md](review-fixes-r2-20261009.md).
The old name/position/breakdown wrapper types and the `MenuEffect` declaration
macro are unnecessary and absent.

`MenuEquipCameraSetEnv` uses two automatic four-float arrays initialized to
`{0, 0, 0, 1}`. They are declared after a camera attachment is found, followed
by the name and lookup buffers, preserving the original initializer execution
point and stack allocation order. This replaces the two external aggregate
load casts and both `at_3771`/`at_3772` markers. A separate ordinary `memcpy`
trial for the existing output-vector copies fails PAL layout verification and
is reverted; those unrelated output operations retain their validated source.
Its negative receipt is `copy-camera-output-build.log`.

All accepted forms and the final restored source pass PAL and 149/149 objects.
The complete native `.bss` section now receives data credit: markers are
**358 RODATA / 6 BSS**, and **2,884 / 10,332 matched_data**.
Receipts are `natural-copy-ledger.log`, `copy-<group>-{build,objects,metrics}.log`,
and `copy-final-{build,objects,metrics}.log`. No guarded draft changes.

### Native generated tables checkpoint

Thirty-three RODATA markers are redundant with the existing native C++
aggregate initializers and switches. Removing them leaves the emitted bytes
and resolved relocation targets unchanged, without new source objects or
changes to the functions. The generated debug buffer and colour template are
also emitted by the matched debug display function under its unchanged SF
profile. The two dispatch tables belonging to guarded drafts remain explicit.

| Removed retail aliases | Native source purpose |
| --- | --- |
| `at_1232` | Automatic command cursor layout initializer. |
| `at_1462__3` | Command message dispatch jump table. |
| `at_3316` | Inventory information dispatch jump table. |
| `at_4350`, `at_4369__3`, `at_4410`, `at_4414`, `at_4485`, `at_4495__2`, `at_4509`, `at_4469` | Automatic cursor-transition layouts for item commands. |
| `at_4674` | Item command dispatch jump table. |
| `at_5458`, `at_5531`, `at_5534`, `at_5556__2`, `at_5563` | Automatic texture-preview layout initializers. |
| `at_5763`, `at_5760` | Texture-preview page dispatch jump tables. |
| `at_6480`, `at_6438`, `at_6814` | Automatic debug text buffer and RGBA initializers, and debug page dispatch jump table. |
| `at_7349`, `at_7348` | Inventory key dispatch jump tables. |
| `at_7695` | Automatic monster build-up board row counts. |
| `at_7968` | Inventory preview selection dispatch jump table. |
| `at_8084` | Preview model loading dispatch jump table. |
| `at_8201`, `at_8200` | Preview model cleanup dispatch jump tables. |
| `at_8421` | Cursor information dispatch jump table. |
| `at_8825`, `at_8824` | Main item-menu input dispatch jump tables. |
| `at_8869` | Main item-menu drawing dispatch jump table. |

All sixteen groups pass PAL, 149/149 objects, protected guard checks and
unowned hashes separately. Markers are **325 RODATA / 6 BSS**, and
matched data remains **2,884 / 10,332**. Receipts are
`generated-rodata-ledger.log` and
`generated-<group>-{build,objects,metrics}.log` in `.private/dataD-r2/`.

`CItemSelect::Draw` uses an automatic `u8 color[4]` initialized to
`{0x80, 0x80, 0x80, 0}`, then replaces the alpha byte with the current fade.
Its native four-byte initializer replaces the external `at_9055` copy and
marker without changing the object. The final generated-data checkpoint is
**324 RODATA / 6 BSS** and **2,884 / 10,332 matched_data**, with the same
PAL and 149-object guarantees (`generated-selector-color-*` receipts).

## Declared state inventory

The following native reservations use the declared retail extents, excluding
splitter alignment tails. Their source definitions document the purpose and
preserve public or file-local linkage according to the retail symbols.

| Symbol | Declared bytes | Native type and purpose |
| --- | ---: | --- |
| `MainCharaReadStackReadAdr` | 4 | `u8 *MainCharaReadStackReadAdr`: Next write address for character model data. |
| `MenuRepairMan` | 4 | `CRepairManager *MenuRepairMan`: Weapon repair effect of the item menu. |
| `MenuItem_ItemBoardTopLine` | 2 | `s16 MenuItem_ItemBoardTopLine`: Saved top row of the inventory board. |
| `MenuItem_ItemBoardTopSelect` | 2 | `s16 MenuItem_ItemBoardTopSelect`: Saved selection on the inventory board. |
| `menu_chara_activeItem_limmit_check` | 6 | `u8 menu_chara_activeItem_limmit_check[6]`: Owned-item limit flags for each character's three active slots. |
| `MenuSpectolSatusCheckForm` | 4 | `CMenuPosDataForm *MenuSpectolSatusCheckForm`: Status comparison form for a spectrum fusion. |
| `MenuSpectolSatusCheckBGFadeForm` | 4 | `CMenuPosDataForm *MenuSpectolSatusCheckBGFadeForm`: Background fade form behind the spectrum status comparison. |
| `TrushMesWindowFlag` | 1 | `s8 TrushMesWindowFlag`: Visibility state of the discard message window. |
| `ActiveMenuWeaponCharaRange` | 4 | `float ActiveMenuWeaponCharaRange`: Motion range of the equipped weapon preview. |
| `MenuWeaponEnvSetChara` | 4 | `CActionChara *MenuWeaponEnvSetChara`: Character whose weapon preview environment is active. |
| `MenuStatusMode` | 1 | `s8 MenuStatusMode`: Non-zero while the character status texture is hidden. |
| `MenuStatusTex` | 4 | `mgCTexture *MenuStatusTex`: Texture of the character status display. |
| `CMenuItemInfoPt` | 4 | `CMenuItemInfo *CMenuItemInfoPt`: Active item-menu controller. |
| `MenuEffect` | 8 | `CMenuEffect *MenuEffect[2]`: Effects of the current spectrumisation or fusion. |
| `MenuItemSpectolTransSoundBuffer` | 4 | `u32 *MenuItemSpectolTransSoundBuffer`: Loaded spectrumisation sound data. |
| `SpectolInfo` | 8 | `CGameDataUsed *SpectolInfo[2]`: Attachment and weapon participating in a spectrum fusion. |
| `SpectolFusion_LeftOrRight` | 2 | `s16 SpectolFusion_LeftOrRight`: Selected side of the spectrum fusion view. |
| `SpectolFusionTargetChara` | 4 | `CCharacter2 *SpectolFusionTargetChara`: Character model receiving the spectrum fusion effect. |
| `save_spectol_fusion_spstatus` | 4 | `int save_spectol_fusion_spstatus`: Saved special-ability difference for the fusion status display. |
| `MenuItemCmdArgPos` | 2 | `s16 MenuItemCmdArgPos`: Position of the item whose command list is open. |
| `MenuItemCommand_RoboPackBreakFlag` | 2 | `s16 MenuItemCommand_RoboPackBreakFlag`: Ridepod pack spectrumisation command variant. |
| `MenuItemCommandDir` | 4 | `int MenuItemCommandDir`: Side of the screen used by the item command window. |
| `MenuHowHaveMuchNum` | 4 | `int MenuHowHaveMuchNum`: Quantity currently selected by the how-many question. |
| `SpectolBreakNum_Limit` | 2 | `s16 SpectolBreakNum_Limit`: Maximum number of items available to spectrumise. |
| `SpectolBreakNum` | 2 | `s16 SpectolBreakNum`: Number of items selected for spectrumisation. |
| `SpectolBreakSpPoint` | 2 | `s16 SpectolBreakSpPoint`: Synthesis points supplied by each spectrumised item. |
| `trans_spectol_cnt` | 4 | `float trans_spectol_cnt`: Frame counter of the spectrumisation effect. |
| `spegetflag` | 1 | `s8 spegetflag`: Acquisition latch for the spectrumisation result. |
| `SpectolFrame` | 4 | `CActionChara *SpectolFrame`: Model framing the spectrumisation preview. |
| `MenuSpectolTransPos` | 2 | `s16 MenuSpectolTransPos`: Pending spectrumisation inventory position. |
| `itemmenu_chr_rotflag` | 1 | `s8 itemmenu_chr_rotflag`: Non-zero while the preview character rotates. |
| `MenuTrushNum` | 2 | `s16 MenuTrushNum`: Number of items selected for discard. |
| `fusion_color_val` | 4 | `float fusion_color_val`: Amplitude of the fusion preview colour oscillation. |
| `SpectolFrameScaleAngle` | 4 | `float SpectolFrameScaleAngle`: Phase of the spectrumisation frame scale oscillation. |
| `SpectolFrameFadeAlpha` | 4 | `float SpectolFrameFadeAlpha`: Opacity of the spectrumisation frame. |
| `FxScriptManPauseFlag` | 4 | `int FxScriptManPauseFlag`: Non-zero while menu effect scripts are paused. |
| `debug_common_data` | 4 | `CDataCommon *debug_common_data`: Item metadata displayed by the debug browser. |
| `view_weapon_flag` | 1 | `u8 view_weapon_flag`: Non-zero when the viewed weapon needs refreshing. |
| `OldViewWep` | 4 | `CGameDataUsed *OldViewWep`: Previous weapon used by the preview comparison. |
| `NewViewWep` | 4 | `CGameDataUsed *NewViewWep`: Current weapon used by the preview comparison. |
| `MenuRepairTargetWeaponPos` | 8 | `int MenuRepairTargetWeaponPos[2]`: Screen coordinates of the weapon repair target. |
| `Tex_BuildUpBoard` | 4 | `mgCTexture *Tex_BuildUpBoard`: Texture of the weapon build-up board. |
| `Robo_Sound_ID_Save` | 4 | `int Robo_Sound_ID_Save`: Ridepod sound bank saved before a preview reload. |
| `MenuDebugModelDrawFlag` | 1 | `s8 MenuDebugModelDrawFlag`: Visibility state of the debug model preview. |
| `MenuDebugSize` | 4 | `int MenuDebugSize`: Byte count of the loaded debug model data. |
| `MenuDebugItemModel` | 4 | `CActionChara *MenuDebugItemModel`: Character model displayed by the debug preview. |
| `MenuDebugCamera` | 4 | `mgCCamera *MenuDebugCamera`: Camera of the debug model preview. |
| `WeaponWarningCounter` | 4 | `float WeaponWarningCounter`: Phase of the weapon durability warning pulse. |
| `MonicaRotationFlag` | 1 | `u8 MonicaRotationFlag`: Non-zero when Monica's saved preview rotation is valid. |
| `MenuItemSelectMode` | 1 | `s8 MenuItemSelectMode`: Mode of the event-requested item selector. |
| `ItemSelectPtr` | 4 | `CItemSelect *ItemSelectPtr`: Active event-requested item selector. |
| `MenuItemCmdRet` | 20 | `ITEMCMD_RET_PARA MenuItemCmdRet`: Outcome of the most recent item command. |
| `MainCharaReadBuffer` | 12 | `MenuCharaReadBuffers MainCharaReadBuffer`: Model, skin and outline buffers of the preview character. |
| `MenuLevelUpMan` | 400 | `CLevelUpEffectManager MenuLevelUpMan`: Manager of the menu's weapon level-up effects. |
| `MenuItemCursorInfo` | 12 | `MENU_ITEM_CURSOR_INFO MenuItemCursorInfo`: Arrows and marks surrounding the item-menu cursor. |
| `BuildUpFormInfoIndex` | 48 | `MENUFORMPARTS_TYPE *BuildUpFormInfoIndex[12]`: Parameter-label parts of the weapon build-up display. |
| `BuildUpFormInfoStatusVol` | 48 | `MENUFORMPARTS_TYPE *BuildUpFormInfoStatusVol[12]`: Parameter-value parts of the weapon build-up display. |
| `TrushMesCls` | 16 | `CDC2Mes *TrushMesCls[4]`: Message windows of the discard menu. |
| `BuildUpWeaponInfo` | 68 | `BUILDUP_WEAPON_INFO BuildUpWeaponInfo`: State of the weapon build-up view. |
| `save_spectol_fusion_param` | 24 | `s16 save_spectol_fusion_param[12]`: Saved parameter differences for the spectrum fusion display. |
| `fusion_ambient` | 16 | `float fusion_ambient[4]`: Ambient colour of the fusion preview model. |
| `fusion_color_ang` | 16 | `float fusion_color_ang[4]`: Phase of each fusion preview colour component. |
| `MenuWeaponBasePos` | 16 | `float MenuWeaponBasePos[4]`: Base position of the equipped weapon preview. |
| `BuildUpNameXY` | 12 | `s16 BuildUpNameXY[3][2]`: Screen position of each prospective build-up weapon name. |
| `MonicaRotationData` | 16 | `float MonicaRotationData[4]`: Saved rotation of Monica's preview model. |
| `cmd_counter_1048` | 1 | `s8 cmd_counter_1048`: Delay counter of the item command selection. |
| `init_1049` | 1 | `s8 init_1049`: Initialization latch of the item command delay counter. |
| `sndflag_1665` | 1 | `s8 sndflag_1665`: Non-zero after the fusion sound begins. |
| `init_1666` | 1 | `s8 init_1666`: Initialization latch of the fusion sound state. |
| `count_time_3839` | 1 | `s8 count_time_3839`: Pulse counter of the attachment information display. |
| `init_3840` | 1 | `s8 init_3840`: Initialization latch of the attachment information pulse. |
| `Effect_Counter_4682` | 4 | `int Effect_Counter_4682`: Counter of the extended weapon build-up effect. |
| `init_4683` | 1 | `s8 init_4683`: Initialization latch of the extended build-up effect counter. |
| `BuildEndFlag_4703` | 1 | `u8 BuildEndFlag_4703`: Non-zero when the extended weapon build-up finishes. |
| `init_4704` | 1 | `s8 init_4704`: Initialization latch of the build-up completion state. |
| `checkmoveFlag_5411` | 1 | `s8 checkmoveFlag_5411`: Previous preview movement state used when refreshing character data. |
| `init_5412` | 1 | `s8 init_5412`: Initialization latch of the preview movement state. |
| `cnt_6161` | 4 | `int cnt_6161`: Counter of the debug character-status selection. |
| `init_6162` | 1 | `s8 init_6162`: Initialization latch of the debug character-status counter. |
| `testcnt_6298` | 4 | `int testcnt_6298`: Counter of the debug spectrumisation effect test. |
| `init_6299` | 1 | `s8 init_6299`: Initialization latch of the debug spectrumisation test counter. |
| `Save_AskParamInfo_7099` | 4 | `void *Save_AskParamInfo_7099`: Temporary command parameters saved while handling item-menu input. |
| `fusion_blinkcnt_7120` | 1 | `s8 fusion_blinkcnt_7120`: Blink counter of the raised fusion parameters. |
| `init_7121` | 1 | `s8 init_7121`: Initialization latch of the fusion parameter blink counter. |
| `diffent_weapon_dispflag_7125` | 1 | `s8 diffent_weapon_dispflag_7125`: Non-zero while a different weapon's fusion preview is shown. |
| `init_7126` | 1 | `s8 init_7126`: Initialization latch of the different-weapon fusion display. |
| `counter_7509` | 4 | `float counter_7509`: Pulse phase of the character voice indicator. |
| `init_7510` | 1 | `s8 init_7510`: Initialization latch of the character voice indicator pulse. |
| `count_7867` | 1 | `s8 count_7867`: Counter of the weapon build-up status warning. |
| `init_7868` | 1 | `s8 init_7868`: Initialization latch of the build-up status warning counter. |
| `old_viewmode_8715` | 4 | `int old_viewmode_8715`: Previous item preview page remembered by the menu input handler. |
| `init_8716` | 1 | `s8 init_8716`: Initialization latch of the saved preview page. |
| `old_chrid_8718` | 4 | `int old_chrid_8718`: Previous preview character remembered by the menu input handler. |
| `init_8719` | 1 | `s8 init_8719`: Initialization latch of the saved preview character. |

## Typed initialized tables

This inventory records the analyzed initialized layouts; the checkpoints below identify the accepted definitions. Native table entries retain the original payload and relocation targets. Pointer
tables use inline strings, preserving pooling and null terminators. Direction
and button tables use the existing menu enums; character-status masks use
`CHARA_STATUS_ATTR`. Pixel coordinates and animation values remain numeric.

| Symbol | Declared bytes | Type and purpose |
| --- | ---: | --- |
| `WepStatusInfoStrTable` | 40 | `char *WepStatusInfoStrTable[10]`: Weapon parameter label parts. |
| `WepStatusInfoStatusVolStrTable` | 40 | `char *WepStatusInfoStatusVolStrTable[10]`: Weapon parameter value parts. |
| `addtbl_2178` | 16 | `float addtbl_2178[4]`: Phase increments of the fusion preview colour oscillation. |
| `at_2328` | 16 | `KeyPairTable at_2328`: Directional key pairs used by the item cursor. |
| `n_2667` | 16 | `char *n_2667[4]`: Held-item cursor, count, icon and shadow parts. |
| `human_tbl_2871` | 10 | `s8 human_tbl_2871[5][2]`: Paired item-use command offsets for each target character. |
| `padtbl_3359` | 16 | `int padtbl_3359[2][2]`: Confirm and cancel actions for each language button layout. |
| `MenuCheckKey` | 16 | `int MenuCheckKey[4]`: Direction bits associated with the four cursor movements. |
| `focusnametbl` | 84 | `char *focusnametbl[21]`: Preview-camera attachment names for character equipment. |
| `item_menu_argtbl` | 432 | `MENU_INPUTKEY_ARG item_menu_argtbl[12]`: Cursor limits and edge transitions of each item-menu layout. |
| `exename_4332` | 16 | `char *exename_4332[4]`: Item-use status scripts for each character preview. |
| `ItemMenuFormNameTbl` | 24 | `char *ItemMenuFormNameTbl[6]`: Forms of the item-menu preview pages. |
| `local_over_flow_baseposname` | 12 | `char *local_over_flow_baseposname[3]`: Part names positioning overflow items. |
| `tbl_4981` | 12 | `char *tbl_4981[3]`: Forms displaying the two characters and the ridepod during item movement. |
| `plist_4982` | 12 | `char *plist_4982[3]`: Part-name formats for item movement slots. |
| `tbl_5293` | 28 | `int tbl_5293[7]`: Background-read reservation mode for each menu memory area. |
| `waku_infotbl_5836` | 24 | `s8 waku_infotbl_5836[12][2]`: Cursor frame width and height for each key layout. |
| `wakutypeTbl_5837` | 12 | `s8 wakutypeTbl_5837[12]`: Cursor frame type for each key layout. |
| `dbox_path_6083` | 15 | `char dbox_path_6083[15]`: Model path of the debug gift box. |
| `table_6164` | 28 | `u32 table_6164[7]`: Character-status flags offered by the debug preview. |
| `attrtable_6472` | 28 | `char *attrtable_6472[7]`: Character-status labels of the debug preview. |
| `stchar_6508` | 52 | `char *stchar_6508[13]`: Weapon special-ability labels of the debug preview. |
| `whptbl_7376` | 24 | `char *whptbl_7376[3][2]`: Durability and warning-mark parts for each active weapon. |
| `backboard_table_x_7625` | 10 | `s16 backboard_table_x_7625[5]`: Horizontal texture coordinates of the build-up board tiles. |
| `mos_repeat_table_x_7694` | 10 | `s16 mos_repeat_table_x_7694[5]`: Horizontal tile repeats of the monster build-up board. |
| `strtbl_7727` | 28 | `char *strtbl_7727[7]`: Enemy requirement messages for each menu language. |
| `argtblno_7927` | 36 | `s8 argtblno_7927[6][6]`: Destination key layout for each preview page and inventory row. |
| `sel_7928` | 36 | `s8 sel_7928[6][6]`: Destination cursor selection for each preview page and inventory row. |
| `conv_7932` | 12 | `s8 conv_7932[12]`: Inventory row offset associated with each previous key layout. |
| `robo_stand_pos_8151` | 132 | `float robo_stand_pos_8151[11][3]`: Ridepod preview position for each core height offset. |
| `effparamtbl_8275` | 40 | `int effparamtbl_8275[2][5]`: Colour, pulse count and duration of the cure and power-up palette effects. |
| `status_table_8427` | 28 | `u32 status_table_8427[7]`: Character-status masks controlling the displayed icons. |
| `xytable_8428` | 14 | `s8 xytable_8428[7][2]`: Texture coordinates of the character-status icons. |
| `xytable_wep_8429` | 24 | `s8 xytable_wep_8429[12][2]`: Texture coordinates of the weapon special-ability icons. |
| `draw_tbl_8453` | 48 | `u32 draw_tbl_8453[12]`: Weapon special-ability masks controlling the displayed icons. |
| `imgtbl_8945` | 16 | `char *imgtbl_8945[4]`: Texture package entries of the item selector. |
| `menu_item_swap_sndtbl` | 16 | `s16 menu_item_swap_sndtbl[8]`: Sound effect for each item exchange result. |
| `MenuRoboEquipTable` | 4 | `s8 MenuRoboEquipTable[4]`: Inventory equipment slots associated with ridepod commands. |
| `MenuItemBoardTotalNum` | 2 | `s16 MenuItemBoardTotalNum`: Number of inventory slots shown by the item board. |
| `MenuItemBoardTotalLine` | 2 | `s16 MenuItemBoardTotalLine`: Number of inventory rows shown by the item board. |
| `MenuWeaponEnvSetListNo` | 2 | `s16 MenuWeaponEnvSetListNo`: Weapon-list entry used by the preview environment. |
| `wakutbl_1411` | 2 | `s8 wakutbl_1411[2]`: Message pointer horizontal position for each equipment cursor. |
| `tartbl_1412` | 2 | `s8 tartbl_1412[2]`: Message box horizontal offset for each equipment cursor. |
| `trans_spectol_pos` | 4 | `int trans_spectol_pos`: Inventory slot of the item being spectrumised. |
| `trans_spectol_posold` | 2 | `s16 trans_spectol_posold`: Previous inventory slot used by spectrumisation. |
| `trans_spectol_rgb` | 4 | `int trans_spectol_rgb`: Alpha of the spectrumisation item icon. |
| `SpectolFramePosValue` | 4 | `float SpectolFramePosValue`: Position oscillation amplitude of the spectrumisation frame. |
| `menu_camera_reference_id` | 1 | `s8 menu_camera_reference_id`: Character attachment category selected by the preview camera. |
| `menu_camera_reference_no` | 1 | `s8 menu_camera_reference_no`: Equipment attachment selected by the preview camera. |
| `tbl_4094` | 2 | `s8 tbl_4094[2]`: Ridepod equipment slots eligible for spectrum fusion. |
| `menuitem_initviewtbl` | 4 | `s8 menuitem_initviewtbl[4]`: Initial preview page for each player-character selection. |
| `menuitem_initmenumode` | 4 | `s8 menuitem_initmenumode[4]`: Initial cursor layout for each player-character selection. |
| `OverFlowFormName` | 4 | `char *OverFlowFormName`: Form displaying inventory overflow items. |
| `itemmenu_calcmode_tbl_5410` | 6 | `u8 itemmenu_calcmode_tbl_5410[6]`: View-page number associated with each preview form. |
| `MenuDebugModel_AdjustFlag` | 1 | `s8 MenuDebugModel_AdjustFlag`: Non-zero when debug model adjustments are enabled. |
| `backboard_table_y_7626` | 3 | `u8 backboard_table_y_7626[3]`: Vertical texture coordinates of the build-up board tiles. |
| `backboard_table_w_7627` | 5 | `s8 backboard_table_w_7627[5]`: Widths of the build-up board tiles. |
| `backboard_x_repeat_drawnum_7628` | 5 | `s8 backboard_x_repeat_drawnum_7628[5]`: Horizontal repeat count of each build-up board tile column. |
| `backboard_y_repeat_drawnum_7629` | 3 | `s8 backboard_y_repeat_drawnum_7629[3]`: Vertical repeat count of each build-up board tile row. |
| `cnttbl_8130` | 6 | `s8 cnttbl_8130[6]`: Preview-form animation counter for each view page. |
| `SameviewmodeTable_8406` | 4 | `s8 SameviewmodeTable_8406[4]`: Preview page associated with each cursor character command. |

### Initial named tables checkpoint

Fifteen initialized definitions pass independently: `WepStatusInfoStrTable`, `WepStatusInfoStatusVolStrTable`, `addtbl_2178`, `at_2328`, `human_tbl_2871`, `padtbl_3359`, `MenuCheckKey`, `item_menu_argtbl`, `ItemMenuFormNameTbl`, `tbl_4981`, `tbl_5293`, `waku_infotbl_5836`, `wakutypeTbl_5837`, `dbox_path_6083`, `table_6164`.
The confirm/cancel table is `int[2][2]`; its caller selects a typed row
instead of casting a byte-offset address. The debug path and status masks
retain the retail names used by the untouched debug draft.

The initial candidates for `n_2667`, `focusnametbl`, `exename_4332`, `local_over_flow_baseposname`, `plist_4982` fail and are restored.
The held-item, attachment and overflow tables have shared external string
references to normalize before another attempt. The status-script table
changes text instruction words despite unchanged allocated section sizes;
its later check must establish whether literal references are responsible.

Markers are **283 RODATA / 6 BSS**, with **2,884 / 10,332 matched_data**.
Every accepted definition passes PAL, all 149 objects, protected guards and
unowned hashes. Receipts are `table-group-1-ledger.log` and
`table-<symbol>-{build,objects,metrics}.log` under `.private/dataD-r2/`.

### Shared cursor strings checkpoint

Nine aliases become inline literals in the cursor, held-item, build-up and
form callers: `at_2545__2`, `at_2546__2`, `at_2547`, `at_2548`, `at_2549`,
`at_2550`, `at_2584`, `at_2585`, and `at_2651`. This establishes one native
pooled copy of each shared value. With those external aliases removed,
`n_2667[4]` passes as a typed pointer table initialized with the same literals.
The earlier isolated table candidate duplicated shared literal storage; its
failed source is not active.

Markers are **273 RODATA / 6 BSS**, with **2,884 / 10,332 matched_data**.
Both accepted steps pass PAL, all 149 objects, protected guards and unowned
hashes. Receipts are `inline-cursor-*` and `table-n_2667-after-cursor-*`,
with ledgers `string-cursor-ledger.log` and `cursor-table-retry-ledger.log`.

### Inline literal checkpoint

A further 164 direct string aliases become inline literals in the existing
matched callers, including all fifty-four literals in the SF-controlled
`MenuItemDebugDraw`. Shift-JIS bytes use hexadecimal escapes. The source
uses literal values directly, without new alias objects, helper functions or
changes to the guarded drafts. The compiled debug display remains identical
under the unchanged production profile.

| Literal group | Accepted aliases |
| --- | --- |
| camera | `at_3774__2`, `at_3775__2` |
| weapon | `at_3822`, `at_3823`, `at_3824`, `at_3825`, `at_3826`, `at_3827`, `at_3828`, `at_3829` |
| fusion-status | `at_3893` |
| item-command | `at_4659`, `at_4660`, `at_4661`, `at_4662`, `at_4663`, `at_4664`, `at_4665`, `at_4666`, `at_4667`, `at_4668`, `at_4669`, `at_4670`, `at_4671`, `at_4673` |
| move-form | `at_4985`, `at_5022` |
| resources | `at_3751`, `at_5130`, `at_5131`, `at_5132`, `at_5133`, `at_5134`, `at_5210`, `at_5211` |
| attach-forms | `at_5259`, `at_5260`, `at_5261`, `at_5262`, `at_5263`, `at_5264`, `at_5265`, `at_5266`, `at_5267`, `at_5268`, `at_5269`, `at_5270`, `at_5271`, `at_5272`, `at_5273`, `at_5274`, `at_5275`, `at_5276`, `at_5277`, `at_5278`, `at_5279`, `at_5280`, `at_5281`, `at_5282`, `at_5283` |
| calc-textures | `at_5757`, `at_5758`, `at_5759` |
| cursor-position | `at_5879`, `at_5880`, `at_5881` |
| item-init | `at_6011`, `at_6012`, `at_6013`, `at_6014`, `at_6015`, `at_6016` |
| item-keys | `at_7342`, `at_7343`, `at_7344`, `at_7345`, `at_7346`, `at_7347` |
| build-up | `at_7438`, `at_7439`, `at_7440`, `at_7441`, `at_7442`, `at_7443` |
| active-weapons | `at_7478`, `at_7534`, `at_7535`, `at_7536`, `at_7537`, `at_7538`, `at_7539`, `at_7540`, `at_7541` |
| fishing-rod | `at_7560`, `at_7561`, `at_7562`, `at_7563`, `at_7564` |
| model-read | `at_8083`, `at_8199` |
| item-effect | `at_8315` |
| key-step | `at_8711` |
| main-keys | `at_8819`, `at_8820`, `at_8821`, `at_8822`, `at_8823` |
| item-selector | `at_9032`, `at_9033`, `at_9179` |
| debug-display | `at_6760`, `at_6761`, `at_6762`, `at_6763`, `at_6764`, `at_6765`, `at_6766`, `at_6767`, `at_6768`, `at_6769`, `at_6770`, `at_6771`, `at_6772`, `at_6773`, `at_6774`, `at_6775`, `at_6776`, `at_6777`, `at_6778`, `at_6779`, `at_6780`, `at_6781`, `at_6782`, `at_6783`, `at_6784`, `at_6785`, `at_6786`, `at_6787`, `at_6788`, `at_6789`, `at_6790`, `at_6791`, `at_6792`, `at_6793`, `at_6794`, `at_6795`, `at_6796`, `at_6797`, `at_6798`, `at_6799`, `at_6800`, `at_6801`, `at_6802`, `at_6803`, `at_6804`, `at_6805`, `at_6806`, `at_6807`, `at_6808`, `at_6809`, `at_6810`, `at_6811`, `at_6812`, `at_6813` |

The retained direct aliases are `at_3894`, `at_3895`, `at_3924`, `at_5882`, `at_5883`.
Their isolated candidates fail PAL and are restored. Saved failed objects
show the 48-byte native `at_5774` BSS initializer losing its retail identity;
the unresolved piece moves before the named BSS reservations and shifts
their code references by `0x30`. The fusion-status group produces 45 changed
instruction words across existing functions and static initialization; only
the low immediate fields change. This is an identity/layout failure under the
fixed postprocessor, not a reason to change the functions or add synthetic
storage. The unchanged aliases retain their exact retail symbols.

Markers are **109 RODATA / 6 BSS**, with **2,884 / 10,332 matched_data**.
All accepted groups pass PAL, all 149 objects, protected guard checks and
unowned hashes. Receipts are `string-remaining-ledger.log`,
`inline-<group>-{build,objects,metrics}.log`, and the per-alias fallback logs.
The failed object, binary and word-diff receipts use the same label plus
`-failed-*` or `-worddiff.log`; `inline-fusion-status-failed-objects.log`
records the unnamed BSS piece.

### Shared pointer-table checkpoint

After the callers use inline literals, all four remaining initial pointer-table
candidates pass: `focusnametbl`, `exename_4332`,
`local_over_flow_baseposname` and `plist_4982`. Their native strings now pool
with those callers, and the complete unit preserves the BSS identities and
all code relocation targets. No qualifier change or alternate source helper
is needed. The initial rejected sources are absent.

Markers are **91 RODATA / 6 BSS**, with **2,884 / 10,332 matched_data**.
All four retries pass PAL, all 149 objects, protected guards and unowned
hashes. Receipts are `table-retry-ledger.log` and
`table-retry-<symbol>-{build,objects,metrics}.log`.

### Status and selector tables checkpoint

Nineteen initialized definitions pass independently: `attrtable_6472`, `whptbl_7376`, `backboard_table_x_7625`, `mos_repeat_table_x_7694`, `strtbl_7727`, `argtblno_7927`, `sel_7928`, `conv_7932`, `robo_stand_pos_8151`, `effparamtbl_8275`, `status_table_8427`, `xytable_8428`, `xytable_wep_8429`, `draw_tbl_8453`, `imgtbl_8945`, `menu_item_swap_sndtbl`, `MenuRoboEquipTable`, `MenuItemBoardTotalNum`, `MenuItemBoardTotalLine`.
The typed palette table records colour, pulse count and duration, while the
preview position table stores eleven three-component positions. Status masks
use the existing `CHARA_STATUS_ATTR` values. The weapon ability label table
`stchar_6508` fails its initial candidate, shifts resolved BSS references in
menusys and an external caller, and is restored for a later identity check.

Markers are **57 RODATA / 6 BSS**, with **2,884 / 10,332 matched_data**.
Receipts are `table-group-2-ledger.log` and
`table-<symbol>-{build,objects,metrics}.log`; the rejected label-table binary
and word differences are `table-stchar_6508-failed-*` and
`table-stchar_6508-worddiff.log`.

### Weapon ability flag names

The additive `MENU_WEAPON_ABILITY` enum names the twelve flags without
changing any existing header declaration or the `u32` icon-mask storage.
Retail `stchar_6508` at `0x355800` contains these labels in index order.
The already-matched debug display selects label `i` with
`weapon.special & (1 << i)`; retail instructions at `0x24A544` through
`0x24A550` establish the shift and mask. `MenuCharaStatusDraw` tests the
same field against `draw_tbl_8453` at `0x355A20`. The names specify labels,
without asserting unverified gameplay effects; `ABS2` remains unexpanded.

| Flag | Enum suffix |
| --- | --- |
| `0x001` | `RICH` |
| `0x002` | `POOR` |
| `0x004` | `POISON` |
| `0x008` | `STOP` |
| `0x010` | `STEAL` |
| `0x020` | `BREAK_EASY` |
| `0x040` | `BREAK_HARD` |
| `0x080` | `DRAIN` |
| `0x100` | `HEAL` |
| `0x200` | `DARK` |
| `0x400` | `CRITICAL` |
| `0x800` | `ABS2` |

The enum substitution passes PAL and all 149 object checks. Every unowned
object hash remains identical, including the rebuilt header consumers.
Receipts are `weapon-enum-{build,objects,metrics}.log`.

### Initialized state checkpoint

All twenty-one remaining initialized state definitions pass independently: `MenuWeaponEnvSetListNo`, `wakutbl_1411`, `tartbl_1412`, `trans_spectol_pos`, `trans_spectol_posold`, `trans_spectol_rgb`, `SpectolFramePosValue`, `menu_camera_reference_id`, `menu_camera_reference_no`, `tbl_4094`, `menuitem_initviewtbl`, `menuitem_initmenumode`, `OverFlowFormName`, `itemmenu_calcmode_tbl_5410`, `MenuDebugModel_AdjustFlag`, `backboard_table_y_7626`, `backboard_table_w_7627`, `backboard_x_repeat_drawnum_7628`, `backboard_y_repeat_drawnum_7629`, `cnttbl_8130`, `SameviewmodeTable_8406`.
Their existing mutability and runtime writes are preserved; the public
`trans_spectol_pos` definition remains header-compatible. The complete
native `.sdata` section adds 152 bytes of data credit.

The sixty active initialized definitions are arranged by retail address.
This source-order cleanup also passes PAL and all 149 objects, with the
guards, profile and unowned object hashes unchanged. Markers are
**35 RODATA / 6 BSS**, and **3,036 / 10,332 matched_data**.
Receipts are `table-group-3-ledger.log`,
`table-<symbol>-{build,objects,metrics}.log`, and
`data-initialized-order-{build,objects,metrics}.log`.

### Complete initialized tables checkpoint

With the complete typed state and retail-order declarations, the ordinary
mutable `char *stchar_6508[13]` definition passes. Its twelve native labels
and terminal null replace thirteen remaining RODATA markers. No const
variant, helper or additional storage is necessary. All sixty-one analyzed
initialized definitions are now active in retail order, and the complete
native `.data` section adds 2,224 bytes of data credit.

Markers are **22 RODATA / 6 BSS**, with **5,260 / 10,332 matched_data**.
PAL, all 149 objects, protected guards and unowned hashes pass. Receipts
are `table-final-stchar_6508-{build,objects,metrics}.log` and
`table-final-label-ledger.log`. The earlier rejected table source is absent.

## Final retained-marker inventory

The completed typed layout allows `at_3894` to become an inline literal on
retry. A total of 174 of the 178 direct string aliases are now native literals.
The four other isolated retries fail and are restored. Their final receipts
are `inline-final-<symbol>-build.log`, `-failed-*`, and `-worddiff.log`,
with `string-final-retry-ledger.log` recording all five outcomes.

| Retained RODATA marker | Declared bytes | Reason |
| --- | ---: | --- |
| `at_1493__2` | 4 | Shared number-part literal referenced by the frozen MenuItemDebugKey draft. |
| `at_3895` | 5 | Attachment or weapon icon part name, "item"; the isolated inline literal loses the native 48-byte at_5774 BSS identity and changes resolved code references under the fixed postprocessor. |
| `at_3924` | 6 | Fishing rod parameter part-name format, "fps%d"; the isolated inline literal loses the native 48-byte at_5774 BSS identity and changes resolved code references under the fixed postprocessor. |
| `at_4672` | 9 | Effect-part literal referenced by the frozen CMenuItemInfo::MenuModeMalloc draft. |
| `at_4950` | 15 | Compiler literal referenced by the frozen CMenuItemInfo::IsAskExtend draft. |
| `at_4951` | 15 | Compiler literal referenced by the frozen CMenuItemInfo::IsAskExtend draft. |
| `at_4952` | 21 | Compiler literal referenced by the frozen CMenuItemInfo::IsAskExtend draft. |
| `at_4953` | 19 | Compiler literal referenced by the frozen CMenuItemInfo::IsAskExtend draft. |
| `at_4954` | 9 | Compiler literal referenced by the frozen CMenuItemInfo::IsAskExtend draft and MenuItemDebugKey. |
| `at_4955` | 5 | Compiler literal referenced by the frozen CMenuItemInfo::IsAskExtend draft. |
| `at_4956` | 4 | Compiler literal referenced by the frozen CMenuItemInfo::IsAskExtend draft. |
| `at_4957` | 17 | Compiler literal referenced by the frozen CMenuItemInfo::IsAskExtend draft. |
| `at_4958` | 24 | Six-entry dispatch jump table of the frozen CMenuItemInfo::IsAskExtend draft; no active native switch supplies it. |
| `at_5882` | 5 | Message-position part for cursor layout 11, "esac"; the isolated inline literal loses the native 48-byte at_5774 BSS identity and changes resolved code references under the fixed postprocessor. |
| `at_5883` | 10 | Cursor offset table-name format, "cur_off%d"; the isolated inline literal loses the native 48-byte at_5774 BSS identity and changes resolved code references under the fixed postprocessor. |
| `at_6424` | 48 | Twelve-entry dispatch jump table of the frozen MenuItemDebugKey draft; no active native switch supplies it. |
| `at_9215` | 12 | Item-selector package path referenced by the frozen MenuItemSelectInit draft. |
| `at_9216` | 12 | Fishing-selector package path referenced by the frozen MenuItemSelectInit draft. |
| `__vt__11CItemSelect` | 32 | Compiler-owned vtable has no owning native definition in this source-only unit; forcing storage would require an artificial object, manual vtable data or changes outside this data lane. |
| `__vt__13CMenuItemInfo` | 32 | Compiler-owned vtable has no owning native definition in this source-only unit; forcing storage would require an artificial object, manual vtable data or changes outside this data lane. |
| `__vt__14CBaseMenuClass` | 32 | Compiler-owned vtable has no owning native definition in this source-only unit; forcing storage would require an artificial object, manual vtable data or changes outside this data lane. |

The native caller references to shared frozen literals continue to use their
retail aliases. No substitute alias object or disguised `LIT_*` definition is
introduced. The ordinary tables referenced by those drafts have native typed
definitions under their retail names; only compiler-owned literals, jump
tables and vtables remain explicit.

| Retained BSS marker | Declared bytes | Reason |
| --- | ---: | --- |
| `at_6133` | 8 | Two-float zero initializer used through the frozen MenuItemDebugKey draft's existing 64-bit copy; natural local initialization would require editing that protected body. |
| `at_6176` | 8 | Two-float zero initializer used through the frozen MenuItemDebugKey draft's existing 64-bit copy; natural local initialization would require editing that protected body. |
| `at_6220` | 8 | Two-float zero initializer used through the frozen MenuItemDebugKey draft's existing 64-bit copy; natural local initialization would require editing that protected body. |
| `at_6234` | 8 | Two-float zero initializer used through the frozen MenuItemDebugKey draft's existing 64-bit copy; natural local initialization would require editing that protected body. |
| `at_6256` | 8 | Two-float zero initializer used through the frozen MenuItemDebugKey draft's existing 64-bit copy; natural local initialization would require editing that protected body. |
| `at_6265` | 8 | Two-float zero initializer used through the frozen MenuItemDebugKey draft's existing 64-bit copy; natural local initialization would require editing that protected body. |

The six eight-byte templates occupy `.sbss`. The native `.bss`, `.sdata`,
`.data` and `.ctor` sections together receive 5,260 bytes of data credit;
remaining aggregate sections still include the documented suppliers.
Empty initialized-data footer headings are absent, and native footer objects
retain their declaration order with blank lines between definitions.

## Final validation

The final restored source passes `SCES_511.90: OK` and **149/149 units**.
The normal build and explicit context/objdiff/progress refresh agree on:

| Measure | Warm baseline | Final |
| --- | ---: | ---: |
| INCLUDE_RODATA markers | 360 | 21 |
| INCLUDE_BSS markers | 126 | 6 |
| matched_data / total_data | 4 / 10,332 | 5,260 / 10,332 |
| Native menusys functions | 161 / 165 | 161 / 165 |

The migration removes 339 RODATA and 120 BSS suppliers. No functions are
promoted or independently matched. Global coverage remains **6,776 matched /
87 guarded / 9 asm-only / 0 fuzzy**. All four guarded drafts are verbatim, the
SF profile is unchanged, and the only header change is the additive weapon
ability enum; every prior header declaration remains verbatim. SHA-256
comparison finds **zero changed unowned objects**. `dng_main.cpp`,
`dng_main.hpp` and AGENTS.md retain their baseline hashes.

Each final rejected direct-literal candidate changes 55 resolved instruction
words in the completed data context; the earlier isolated forms change 45.
Their allocation/identity failures remain documented above, with no rejected
source active. The native table candidates that initially failed all pass
after their literal dependencies and the complete typed layout are present.
No toolchain or profile changes, artificial objects, manual vtables, inline
assembly, codegen helpers or dummy locals are introduced. No unowned-file
proposal is needed.

Final receipts in `.private/dataD-r2/` are `final-build.log`,
`final-objects.log`, `final-metrics.log`, `final-summary.log`,
`final-refresh.log`, `final-refresh-metrics.log`, and `final-coverage.log`.
The warm comparison receipts are `warm-build.log`, `warm-objects.log`,
`baseline-metrics.log`, `baseline-report.json` and `baseline-hashes.json`.
