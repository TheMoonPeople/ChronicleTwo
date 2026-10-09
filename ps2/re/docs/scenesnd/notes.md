# scenesnd: header notes

Header `ps2/include/scenesnd.hpp` owns `CScene` (all 184 members in scene, sceneload, scenesnd,
sceneevent, scenevillager are declared there, grouped by unit) and its nested `BGM_INFO`,
`BGM_STATUS`, `InScreenCharaInfo`. It also defines `DNG_BATTLE_AREA` (dng_main forward-declares
it), `SYSTEM_SCRIPT_INFO` (retail name from `EventScriptSetup__FP18SYSTEM_SCRIPT_INFO`; dng_main
should include this header rather than redefine it), `SND_FILE_INFO`, `SND_REV_INFO`,
`SE_SRC_PLAY_INFO` and `SND_FILE_NO`. All names except CScene, BGM_INFO, BGM_STATUS,
InScreenCharaInfo and SYSTEM_SCRIPT_INFO are ours. No first-game counterpart.

Non-members `GetNumber3__FPci` and `GetLine__FPPcPcPc__2` are LOCAL (local_symbols.tsv): static in
the .cpp. No file-scope data: every datum is an inline literal at its use ("snd2/bgm/BG_%s...",
"snd2/ob/OB_%s", "snd2/env/SR_%s", "snd2/bs/BS_%s", "snd2/fg/FG_%s", "snd2/event/EV_%s_%s",
"load sound %d\n", "Reverb %d %d\n"). `LoadSndFileInfo` compares the Shift-JIS "時間変化*" (time
change) prefix, trailing `*` included, written with hexadecimal byte escapes. `GetLine` holds the
line terminator as a two-byte `LineBreakPair` initialised `{'\r', '\n'}` with no NUL terminator;
MWCC emits the two-byte object with six bytes of padding.

## Status
All 71 functions are native C++; the unit has no `INCLUDE_ASM`, `INCLUDE_RODATA` or `INCLUDE_BSS`
markers and all 260 data bytes are owned by the source.

## CScene size / vtable
- Size 0x10550: `MainScene` symbol size. Construction is inline (`__sinit_mainloop_cpp`, also
  menuchr MenuItemCharaDataLoadEndCheckAfter): sub-object Initialize loops give every array base.
- `__vt__6CScene` (0xC) = {0, 0, Initialize}; vptr at +0x10548 (MWCC puts it after the members).
  `InitAllData` calls it through the vtable. Only virtual: `Initialize()`.
- Explicit `unk_` pads are at 0x23CC, 0x2CA4, 0x2F7C, 0x3044,
  0x3F0C (after CThunderEffect, assumed 0x9C as water.hpp declares; nothing touches
  0x3F0C..0x405F), 0x9078, 0x99C4, 0xA048, 0xC4D8.

## Layout evidence (CScene)
| Off | Field | Evidence |
|---|---|---|
| 0x0/0x4/0x8 | stack_num (=12) / stack_no / mgCMemory *stack[12] | Initialize, Set/Get/Clear/AssignStack (AssignStack writes +4) |
| 0x38 | work_stack | scenevillager scratch for collision polys; editloop/title set it |
| 0x3C | u_long128 *read_buff | dng_main stores BuffReadData |
| 0x40..0x2C70 | slot counts + arrays (128 chara, 8 camera, 8 message, CMdsListSet, CFireRaster, 4 map, 4 sky, 4 gameobj, 8 effect) | Initialize, __sinit (scene notes) |
| 0x2C70 | CFadeInOut fade (0x30) | effectlist notes |
| 0x2CA0 | bg_load_step | sceneload notes |
| 0x2CA8 | SCN_LOADMAP_INFO2 bg_load_info | sceneload notes |
| 0x2E50 | player_chara | Initialize -1, InitLadder |
| 0x2E54 | active_camera | AssignCamera sets if <0; GetCamera(+0x2E54) everywhere |
| 0x2E58 | before_camera | `_SET_BEFORE_CMRID`, `_GET_BEFORE_CAMERA_*`, EditLoop swaps with 0x2E54 |
| 0x2E5C | active_map | AssignMap sets if <0; GetMainMapNo picks 0x2E60 when 0 else 0x2E64 |
| 0x2E60..0x2E6C | now/now_sub/old/old_sub map no | SetNowMapNo, SetNowSubMapNo, InitAllData |
| 0x2E70/74/78 | chara_texb / villager_texb / villager_texb_num | GetCharaTexb |
| 0x2E7C/80 | event_texb / event_texb_num | `_LOAD_IMG`, `_DEL_IMG`, `_INIT_SEPIA`, LoadMovie |
| 0x2E84 | unk (-1; EditInit 0x9F) | |
| 0x2E88/8C/90 | event_run / event_no / CSceneEventData | sceneevent notes |
| 0x2F60 | map_event_no | GetMapEvent |
| 0x2F64 | exit_flag | `_SET/_GET_EXIT_FLAG` |
| 0x2F68/6C/70/74 | day / time / time_speed (init 0x3A66AFCD) / time_step | TimeStep, SetTime, `_SET_TIME_STEP_ENABLE`; copied to CSaveData +0x1A14/+0x1A10 |
| 0x2F78/80 | wind_power / wind_dir | Set/Get/ResetWind |
| 0x2F90 | DNG_BATTLE_AREA (0xA8) | menu_GetBattleAreaScene returns +0x2F90; event_func tests `&scene->battle_area != NULL` |
| 0x3038/3C | skip_load_villager / skip_load_sub_villager | `_CANCEL_LOAD_VILLAGER`, scenevillager |
| 0x3040 | CSaveData *save_data | SetTime/TimeStep |
| 0x3050 | CVillagerMngr (0xE10) | villagermngr notes |
| 0x3E60/64 | villager_time / sub_villager_time | scenevillager notes |
| 0x3E68/6C | unk: EditInit 0xB9/0x15, dng 0x28/0x1F, passed by `_GOTO_SUBGAME` (maybe a texb range; unconfirmed) | |
| 0x3E70 | CThunderEffect | Initialize |
| 0x4060/64 | snd_file_num / SND_FILE_INFO[512] | LoadSndFileInfo, SearchSndDataID (stride 0x24, binary search on id); 512 = gap to 0x8864 |
| 0x8864/68 | snd_rev_num (=size>>3) / SND_REV_INFO[256] | LoadSndRevInfo memcpy; 256 = gap to 0x9068 |
| 0x9068 | snd_file_id | LoadSound sets; PlayEnvBgm looks it up; InitSnd -1 |
| 0x906C/70/74 | skip_load_bgm / skip_load_sound / skip_play_bgm | LoadBGM / LoadSound / PlayBGM: if set, clear and return |
| 0x9080 | BGM_INFO bgm[2] (stride 0x460) | InitSnd loop; ports [0]=0 (SND_PORT_BGM), [1]=0xB (SND_PORT_BGM2) |
| 0x9940 | bgm_no | GetActiveBgmInfo |
| 0x9944/0x9984 | se_src_id[16] / se_src_no[16] | InitSeSrc, LoadSeSrcPack, GetSeSrcID |
| 0x99D0/0x9DD0 | se_src_buff (0x40 qw) / stack | InitSeSrc stSetBuffer(..., 0x40), port 1 (OB) |
| 0x9E00 | SE_SRC_PLAY_INFO[4] (0x88) | PlaySeSrc, PrePlaySeSrc, StepSnd |
| 0xA020/0xA030 | se_src_play_no[4] / flag[4] | check_se_play, StepSnd |
| 0xA040/44, 0xA050, 0xA450 | env id / no, buff (0x40 qw), stack | InitSeEnv, LoadSeEnvPack (port 2) |
| 0xA480 | unk (InitSeEnv 0) | |
| 0xA484..0xA494 | env_bgm_no, env_bgm_vol, env_bgm_volf, env_bgm_auto, env_bgm_offset | PlayEnvBGM, SetEnvBGMVol, AutoChangeEnv*, StepSnd (no = offset + CMap::GetNowTimeBand) |
| 0xA498/9C, 0xA4A0, 0xC4A0 | base id / no, buff (0x200 qw), stack | InitSeBas (port 3); id also copied to CCharacter2+0x57C and used for door/foot SE |
| 0xC4D0/D4, 0xC4E0, 0xE4E0 | battle id / no, buff, stack | InitSeBattle (port 9) |
| 0xE510/0x10510/0x10540 | loop_se_buff (0x200 qw) / stack / CLoopSeMngr | InitLooSeMngr (Create(0x30, stack)) |

## `InitSeSrc` matching

`InitSeSrc` stops the old source effects and ports, clears both 16-entry
source tables, attaches the source stack to its buffer, starts ports 4 and 1,
clears the four active playback slots, and queues source effects for playback.
MWCC unrolls the table loop eight entries at a time.

The ID table at +0x9944 (`se_src_id`) is `u32[16]` and holds packed sound IDs
(port byte, bank byte, effect halfword; `sndLoadSound` returns `unsigned int`);
the bank-number table at +0x9984 (`se_src_no`) is `s32[16]` with -1 marking an
empty slot. `LoadSeSrcPack` stores the unsigned `sndLoadSound` result directly
into the ID table and searches for a free slot with a signed load and `bgez` on
the number table. Returning an ID through the signed `GetSeSrcID` signature
preserves its bits.

The unsigned ID table is what the match depends on. With both tables signed,
39 words differ purely through the loop register permutation: retail uses `v1`
for the count, `a0` for the byte offset, `a1` for the scene-relative base and
`a2` for -1, while the signed form colours them `a0`, `a1`, `a2`, `v1`.
Casting the sentinel RHS to `u32`, named sentinel locals, index reuse, local
table pointers, explicit unrolling or separate loops do not change that
permutation while the destination stays signed.

Accesses at +0xA46C/+0xA474 (LoadSeEnvPack) and BGM_INFO +0x44C/+0x454 (LoadBGMPack,
`piVar1[0x113]`/`[0x115]`) are `mgCMemory::lock` / `stack_used` of the embedded stacks, not
separate fields.

## Nested / sound types
- BGM_INFO (0x460): BGM_INFO::Init sets +4/+8 = -1, +0xC = 1.0, +0x18 = 1.0, +0x1C = 0, +0x24 = 0.
  +0 port, +4 snd_id (sndLoadSound result, first arg of every sndSe*), +8 load_no (CheckLoadBGM),
  +0xC float (multiplied in SetVolfBGM; meaning unknown -> unk_c), +0x10 vol, +0x14 volf,
  +0x18 fade_volf, +0x1C fade_speed (FadeIn/FadeOut/StepSnd), +0x20 play_no, +0x24 time_vol
  (AutoChangeBGMVol; StepSnd uses GetTimeBgmVolf), +0x30 buff (stSetBuffer size 0x40), +0x430 mgCMemory.
- BGM_STATUS (0x1C): +0 GetBGMState(), +4 = info+8 load_no, +8 = info+0x20 play_no, +0xC, +0x10,
  +0x14, +0x18 = info+0x24. +4 is the loaded number, which menushop/event_func read as the "bgm
  number". mapjump's OldBgmStatus symbol is 0x20 (alignment padding of the global).
  `CScene::GetActiveBgmStatus` reads these members through `this` without a cast.
- SND_FILE_INFO columns (LoadSndFileInfo): id; 'B' -> bgm_no; 'B' -> se_base; 'F' -> se_battle;
  'S' -> se_env; 'S'(+7) -> env_bgm with env_vol 0, or "時間変化<f>" -> env_bgm -1 and env_vol
  f*127 clamped; up to 6 'O' columns -> se_src (8 slots init -1; '*' sets se_src[0] = 9999);
  'E' -> event_se[2] (3-digit fields at +3/+7); 'R<n>' -> reverb bytes from the rev table row
  with id n. '*' in the first five columns = 9999 (SND_FILE_NO_KEEP), missing = -1.
  LoadSound: <0 -> Init*, 9999 -> keep, else Load*; then sndSetReverb(1, type, depth).
- SND_REV_INFO: only +0 (id) and +2/+4 (read as halfwords, stored as bytes) are used; +6 unk.
- InScreenCharaInfo (0xC): scenevillager notes.

## DNG_BATTLE_AREA (0xA8, at CScene+0x2F90)
Extent: first byte is the address returned by menu_GetBattleAreaScene; last used field +0xA0
(free_texb, `CEffectScriptMan::GetNotUsedTexb` in InitDungeonMain; monster/`_DEL_MONSTER`
delete texture blocks from it to 0xAA); u64 at +0x90 gives 8-byte alignment -> 0xA8, which
ends exactly at the next CScene field 0x3038.
+0x8 pause_flag (`_DNG_PAUSE`/`_DNG_CHECK_PAUSE`; bits 0x100, 0x400 event, 0x2000, 0x4000, 0x8000
seen), +0xC floor_status (`_SET/_GET_FLOOR_STATUS`), +0x10 timer (`_DNG_GET/RESET_TIMER`,
DngStep ++), +0x14 CDngFloorManager, +0x24 map_name (LoadDungeonMapFile strcpy/strcmp,
SearchMapNo), +0x44 SYSTEM_SCRIPT_INFO (EventScriptSetup: +0 event no, +2 = 1 when started;
RunMainEvent clears +0x46), +0x48/+0x49/+0x4C/+0x50 status bar (`_SET_STATUSBAR_SHOW`:
old = show, show = arg, rate 0/1, speed = arg*1.2 or 0.02*1.2), +0x58 boss_map
(`_DNG_CHECK_BOSS_MAP`; automap hides symbols when set), +0x6C bright_rate
(`_BSCN_SET_BLIGHT_RATE`, init 1.0, DngMainDraw scales colours), +0x70/+0x74/+0x78 camera quake
(`_CAMERA_QUAKE`: power, power/frames, frames), +0x7C CTreasureBoxManager*, +0x80 = &BattleFX
(BattleEffectMan), +0x84/+0x88 BattleAreaBGMCtrl state 0..4 / volume (`_GET/_SET_BTL_BGM_VOL`),
+0x90 u64 = CSaveData+0x1A00 play time (`_RESET_SUBJECT_COUNTER`), +0x9C map_effect_id
(`_SET/_GET_MAP_EFFECT_ID`, init 0xFF). Unnamed: +0x0, +0x4 (Initialize 0), +0x54 (DngMainKey
compares 0/1/2/4), +0x5C (1 at map load / event), +0x64 (|1), +0x8C (s8, ==2 in draw), +0x98
(flags, |0x80), +0x9E (s16; lock-on mode 0/2 in actionchara, dng_debug edits it).

## Return types / signatures (for the body writer)
Return types are from m2c/Ghidra agreement and caller use; pointer getters typed by what they
return. Unsure ones: GetBgmFile & co. declared `void` (Ghidra shows sprintf's value falling
through; no caller uses it); GetDefBgmNo declared `int` (returns an s16 load, -1 when absent);
CheckLoad*/IsActive/DeleteSky/CheckDrawChara/GetNowVillagerTime return compare results (int).
`LoadSound/LoadBGM/LoadSe*__6CSceneFiP1` and `PreLoadVillager__6CSceneFiP1` take `u_long128 *`
(P1); LoadBGM passes it to LoadFile2 and LoadBGMPack (`unsigned int *`), so the body casts.
`InScreenFunc` returns `CFuncPoint *` (a function-local static `sun_func`, 0x1C0, or NULL).
`monster.hpp` can now declare `int CheckPhoto(CScene::InScreenCharaInfo *)` by including this header.

## PlayBGM
`PlayBGM` consumes `skip_play_bgm` once. It stops the previous play number when changing songs,
resolves a negative requested volume from the bank default, clamps a negative limited volume to 1,
starts the sound at voice 0, and clears `time_vol`.

## Float constant materialisation order

`SePlayFoot__6CSceneFiiPf` at `0x002AC5D0` materialises the far distance `1200.0f`
before the near distance `160.0f` for `sndGetVolPan`. Plain MWCC 3.0-011126 `-O3,p`
evaluates them in the opposite order; the build profile marks the binary32 constant
`0x44960000` in this function as `evaluate_first` so that every occurrence of the
identity is materialised first. The other constants keep the default order. The
complete unit then passes the retail checker (`0x2CB4` initialised bytes, 241
relocations).
