# event_func: reverse-engineering notes

## Status
824 of the 827 functions in `ps2/src/event_func.cpp` are native C++ definitions and match retail
(including `_COPY_CHARA`, `LoadMovie`, `_SET_CROSSFADE` and `_SET_GYORACE_ETC`). Two are guarded
drafts (`#ifdef NONMATCHING` C++ with an `INCLUDE_ASM` fallback): `_ESM_INITIALIZE` and
`_COPY_MONS2SCNCHR`. One symbol is assembly-only: the compiler-generated
`CObject::CObject(const CObject &)` (`__ct__7CObjectFRC7CObject`, 0x2804B0, 0xC8 in a 0xD0
extent), which retail emits from the character copy inside `_COPY_MONS2SCNCHR`; no active native
caller emits it while that command is guarded, and an explicit copy body or dummy use is not an
acceptable way to force it. Both guarded functions fail on MWCC's placement-new allocation-result
schedule: retail tests the allocator's `v0` and copies it into the saved register in the branch
delay slot, while MWCC copies first and branches on the saved register (see
[placement conversion](../satansfiddle/placement-new.md)).

- `_ESM_INITIALIZE` (0x128 body in a 0x130 extent): the natural source loads the texture-block
  start and remaining count, adds the decoded offset to the start and calls
  `CEffectScriptMan::Initialize`; it differs by two words at +0xE8/+0xF0 (the branch pair). The
  retained draft's `Ident` helper scores zero only as a diagnostic and is inadmissible; without it
  the direct expression leaves nine register-operand differences (MWCC merges the base load and
  sum into the `a2` argument before colouring, retail loads the base into `v1` and adds into `a2`).
- `_COPY_MONS2SCNCHR` (0x754 body at 0x27FD50 in a 0x760 extent; native 0x750): 244/472 words.
  Retail copy-constructs the local `CCharacter2` snapshot (generated `CObject` copy constructor at
  +0x190 into `sp+0x60`, then the derived members), not default-construct-then-assign. Beyond
  the allocation branch pair, the 0xC-byte `shadow_link` (`CCharaFrameMatching`, source offset
  +0x35C..+0x364) is copied through GPRs in retail but as three FPR loads/stores plus a
  destination temporary in native (first difference +0x390, no float conversion involved), and
  retail calls `Copy` through vtable slot +0xEC while the exact-type native snapshot is
  devirtualized to a direct call. `CCharaFrameMatching` must stay a grouped member with an
  explicit `Initialize` and no declared constructor (an empty constructor breaks
  `MenuMonsterBoxInit`). The command is retail LOCAL; a `static` definition gives a LOCAL symbol.

`_COPY_CHARA` (0x26A900, retail LOCAL, 0x2B4 in a 0x2C0 extent) allocates a `CCharacter2` in a
scene stack (allocation precedes the source-character check, as in retail) and copies the source
into the assigned slot with its texture block; it accepts one `ARG_DATA` tuple argument or three
direct stack arguments. It is defined with external linkage like the unit's other native command
callbacks; a `static` definition also gives a LOCAL FUNC symbol with an unchanged object.

Several decompiled functions in this unit compile to exact retail instruction matches. `CEoh`'s five
typed pointer names occupy the same union word; its constructor clears each alias in succession.
`CRaster::Initialize` clears the effect values in retail store order and sets `frames` to -1.
`CScreenEffect::Initialize` clears the three effect modes and their textures. `SetSepiaFlag`
requires a sepia texture; `SetMonoFlashFlag` requires either monochrome texture and resets the
frame counter and selected texture. The migrated script commands that return a constant do not
read their stack or argument count; the reset and effect commands call the named state helpers.

827 functions. 112 are global (prototyped in `event_func.hpp`); the other 715 are retail-local
(`local_symbols.tsv`) and belong in the .cpp as `static`: the ~698 event-script external functions
`_XXX(RS_STACKDATA *, int)`, the stack/arg helpers (`GetStackInt/Float/Vector/String`, `SetStack`
x2, `GetArgInt/Float/String/Vector`, `_DATA`, `_ID_OFFSET`), `FileNameConvLanguage`, `GetObjSeq`,
`GetChara`, `GetMes`, `GetCamera`, `GetEventSprite`. No first-game counterpart unit exists; the
first game's `ED_EVENT_INFO` (`chronicle/ps2/include/edit.hpp`, 0x450) shares only the name and the
idea -- this game's block is 0x12A0 and laid out differently.

`CObject::CObject(const CObject &)` (0x2804B0) is emitted here but CObject is owned by `map`; not
declared in this header.

## Header dependencies
- `dng_effect.hpp` (CHitEffectImage, by-value array `HitEffect[5]`), `sceneseq.hpp`
  (`_SEN_CMR_SEQ`, `_SEN_OBJ_SEQ`, arrays), `runscript.hpp` (`RS_STACKDATA`, `CRunScript`),
  `scenesnd.hpp` (owner of `CScene`, needed for the by-value `CScene::BGM_STATUS` member of
  `ED_EVENT_INFO`). `scenesnd.hpp` was absent during the original header probing;
  it now declares `CScene::BGM_STATUS` (0x1C bytes: +0 state, +4 now no, +8,
  +0xC, +0x10, +0x14 float volume, +0x18; see `CScene::GetActiveBgmStatus`).
  The original `u8[0x1C]` stub compile checked every STATIC_ASSERT; current
  builds use the real member type.
- `RS_EXTFUNC_INFO` (row type of `ext_func_info` / `esa_ext_func_info`) is declared in
  `runscript_opcodes.hpp`; include it from the .cpp.

## ED_EVENT_INFO / EdEventInfo (0x1EFD460, 0x12A0, global)
Type name taken from the first game (not retail-proven). All offsets come from `%lo(EdEventInfo + X)`
in the asm across all units (no other base+offset access exists; the addiu users only index
`snd_id`, `script_name`, `jump_map_name`, `skip_fade_color`).
| Off | Field | Evidence |
|---|---|---|
| 0x0 | `sceVu0FVECTOR world_coord_pos` | `_SET_WORLD_COORD` args 0..2, w=1.0 (InitWorldCoord); `CalcPosWorldCoord` sceVu0AddVector |
| 0x10 | `sceVu0FVECTOR world_coord_rot` | `mgRotMatrixXYZ(&+0x10)`; only Y (+0x14) set by script; `CEohMother::SetRot/GetRot`, eventedit |
| 0x20 | `float projection` | `InitEvent` mgGetProjection; `EdEventStep` mgSetProjection; `_GET/_SET_PROJECTION` |
| 0x24 | unk 0x40 | never accessed |
| 0x64 | `jump_point` | 1st arg of `_MAP_JUMP/_GOTO_INTERIOR/_GOTO_OUTSIDE/_MOVE_INTERIOR/_FUNCTION_MAP_JUMP` |
| 0x68 | `char jump_map_name[0x20]` | strcpy of map name; `EditLoop` SearchMapNo |
| 0x88 | `event_no` | default 100 for jumps; -1 none; `StartEventSyori`, `EditLoop` |
| 0x8C | `char script_name[0x40]` | `_LOAD_SCRIPT`; memset 0x40 in `EdEventLoopInit` |
| 0xCC | `request` | EVENT_REQUEST (see event notes) |
| 0xD0 | `command_mode` | EVENT_COMMAND_MODE |
| 0xD4 | `skip_state` | EVENT_SKIP_STATE |
| 0xD8 | `skip_button` | default 0xF |
| 0xDC | unk | never accessed |
| 0xE0 | `float skip_fade_color[4]` | `_SET_SKIP_FCOL`; CFadeInOut args |
| 0xF0 | `start_button` | only read by `_GET_START_BUTTON`, zeroed in init |
| 0xF4 | `int snd_id[12]` | `_SND_LOAD_SOUND` port 0..11 stores sndLoadSound result; [4] (0x104) used as SE handle by dng_event `BattleAreaBGMCtrl`, menuop, editexception |
| 0x124 | `last_snd_id` | `_GET_SND_ID` default |
| 0x128 | unk int | only zeroed |
| 0x12C/0x130 | `env_bgm_volume` (float) / `env_bgm_no` | `_PLAY_ENV_BGM` |
| 0x134 | `stream_playing` | 1 in `_STREAM_PLAY`, read by `_GET_MES_VOICE`, ClsMes::DrawMesWin |
| 0x138 | `stream_from_fpl` | 1 when opened via `CommandStreamOpenFromFPL`; chooses StreamEND vs StreamClose |
| 0x13C | `int func_iparam[16]` | door mode: [0] chara no, [1] = EventScene+0x2E9C, [2] SE id (`EventDoorLoop`) |
| 0x17C | `float func_fparam[16]` | door mode: [0..2] pos, [3] yaw (atan2), [4..6] cam pos, [7..9] cam ref offset |
| 0x1BC | `int monster_talk[3]` | written by dng_main `IsEventRun`, read by `_GET_MONSTER_TALK_DATA` |
| 0x1C8 | `door_type` | EventDoorLoop maps 5/4/3/2/1 -> SE 0xD/8/6/4/2 |
| 0x1CC | `interior_entrance` | `_GOTO_INTERIOR` 4th arg -> `EditGotoInterior` |
| 0x1D0 | `u64 stopwatch_start` | `_STOPWATCH` 0: SaveData+0x1A00 play time (ld/sd 64-bit) |
| 0x1D8 | `s64 stopwatch_limit` | `_STOPWATCH` 2 (sign-extended int); `_GET_EVENT_INFO` (runscript_opcodes) |
| 0x1E0/0x1E4/0x1E8 | `stopwatch_x/y/style` | `_STOPWATCH` 3; EventTimeDraw (style 1 = alternative layout) |
| 0x1EC | `CMapParts *dng_event_parts` | dng_event `GetDungeonEventPoint` |
| 0x1F0 | `dng_event_found` | same, set 1 |
| 0x1F4 | `pack_loaded` | `_LOAD_PACK_FILE` sets 1; `GetLoadBGBuff` searches read_buffer with GetPackFile while 1 |
| 0x1F8 | `map_draw` | `_SET_MAP_DRAW`; editloop `EditDraw`; default 1 |
| 0x1FC | `stream_reading` | 1 by `_STREAM_OPEN2/3`; GetLoadBGBuff / `_SET_LOADBG_FILE` hang (printf + infinite loop) if a disc load is attempted while 1 |
| 0x200 | `stream_volume` | `CommandStreamPlay` stores its volume; StreamSetVol on close |
| 0x204 | `caption_enable` | `_SET_MOVIE_CC` mode 0; LoadMovie |
| 0x208/0x250 | `int caption_start[18]` / `caption_frames[18]` | `_SET_MOVIE_CC` (value*50/60); LoadMovie range check |
| 0x298 | `char caption_text[18][0xE1]` | strcpy to 0x1EFD6F8 + i*0xE1, memset 0xE1 |
| 0x126A | pad 2 | |
| 0x126C/0x1270 | `npc_talk_text` / `npc_talk_size` | event `LoadNpcTalkMes`, `_MES_MAKE` |
| 0x1274 | `CScene::BGM_STATUS bgm_status` | `_GET/_SET_ACTIVE_BGM_STATUS`; +4 (0x1278) read by `_GET_BGM_STATUS_NOW_NO` |
| 0x1290 | `float keep_time` | `_GET/_SET_KEEP_TIME` |
| 0x1294 | unk 0xC | never accessed |

## CEoh (0x10) / CEohMother (0x200) -- EventObjHandleMother (0x1EFE700, global)
- CEoh: +0 `type` (EOH_TYPE; ctor -1), +4 `scene_no` (ctor -1; scene character slot, used with
  `CScene::GetCharaTexb`, `SetStatus/ResetStatus(1, no, 8)` for shadows), +8 `world_coord` (ctor 1;
  CObject Set's 3rd arg; SetPos/GetPos convert through the event world coordinate only when non-zero
  for OBJECT and FUNC_POINT), +0xC union of the five pointers. The ctor stores 0 to +0xC five times:
  one store per union member, i.e. the ctor body nulls each member.
- `CEoh::Set` stores `type` first, then succeeds only if it equals the overload's kind (0 chara,
  1 object, 2 sprite, 3 frame, 4 func point). `CEohMother::Set(int,int,CObject*,int)` ignores its
  `type` argument and passes the constant 1 (asm: `addiu $5,$0,1`); the other overloads forward it.
- CEohMother = `CEoh eoh[32]` (ctor constructs 32 CEoh, stride 0x10, then re-initialises them in an
  unrolled x8 loop identical to the one at the top of `EventSeqInit` -- an inline reset function,
  not in the manifest). All methods range-check `no` 0..31 and return 0/1 (or a pointer).
- No vtables (no `__vt__` symbols for any class of this unit).
- Character vtable slots used (CCharacter2): +0x10 SetPos(float*), +0x14 SetPos(fff) for objects,
  +0x18 GetPos, +0x54 SetShow, +0x58 GetShow, +0x88 now motion status, +0x8C now motion name,
  +0x90 motion end, +0xB0 SetMotion(char*,int), +0xB8 set step, +0xC4 fade flag, +0xD0 drive.
  Fields: +0x70 mgCFrame* model, +0x2C0 shadow frame, +0x374 motion data, +0x378/+0x3B8/+0x3BC
  motion sequence, +0x388 motion time, +0x508/+0x50C change step, +0x57C/+0x580/+0x588 sound ids.
- CFuncPoint: +0x10 show flag, +0x70 sub-object with vtable (+0x10 called after a move),
  +0x180 position.

## CEventScriptArg (0x10) -- EventScriptArg (0x1F328B0, local) and ARG_DATA / ARG_LIST
- +0 `next_id` (set by script `_ID_OFFSET`, copied into each new list, then incremented), +4 `list`,
  +8 `list_num`, +0xC `mgCMemory *memory` (from `CScene::GetStack` in `_LOAD_ARG`).
- `BuildArgData(u_int *program)` runs the program with a local `CRunScript` (stack 0x20, call 0x20,
  3 external functions from `esa_ext_func_info` = {_DATA, _ID_OFFSET, ...}, `run(100)`), with
  `nowScriptArg` (local) pointing at this.
- `ARG_LIST` (0x10, **name not retail**): new(0x10) in `_DATA`: +0 id, +4 ARG_DATA*, +8 count,
  +0xC next. Lookups by id are inlined in each consumer (`_SET_CHARA_POS` etc.).
- `ARG_DATA` (8, retail name from mangling): RS_STACK_TYPE + value union. `GetArgFloat` converts
  type 0 (int) with cvt.s.w; `GetArgInt` converts type 1 with fptosi.

## CRaster (0x2C) / CScreenEffect (0x4C) -- EventScreenEffect (0x1F328C0, global, retail size 0x4C)
- CRaster: state (RASTER_STATE: StartRaster sets 1, or 2 when frames < 2; StopRaster 3, or 0 when
  frames < 2; StepRaster 1->2 and 3->0 when `frame >= frames`), amplitude/+step (clamped >= 0),
  speed/+step and pitch/+step (clamped 0..pi), phase (+0x1C, advanced by speed in DrawRaster),
  +0x20 unk (only zeroed), frames (+0x24, -1 idle), frame (+0x28).
- CScreenEffect has a CRaster at +0 (member vs base indistinguishable; Initialize calls
  `CRaster::Initialize(this)`, InitRaster calls `CRaster::SetParam`; `Step` contains StepRaster
  inlined; Start/StopRaster are 0x10-byte tail calls). +0x2C sepia texture, +0x30 sepia on,
  +0x34/+0x38 mono textures, +0x3C mono on, +0x40 interval, +0x44 frame counter, +0x48 index (xor 1).
- `SetSepiaTexture(mgCTexture*, u_long128*)` / `SetMonoFlashTexture(mgCTexture**, u_long128**)`:
  `P1` in the mangled name is `u_long128`; the pointer is stored to texture+0x50 (`image[0]`).

## Globals
| Symbol | Addr / size | Binding | Type |
|---|---|---|---|
| EventMarker | 0x37DE7C / 4 | global | `CMarker` (eventsprite; Init/Draw called on it) |
| SwordEffect | 0x37DE80 / 4 | local | `CSWordAfterImage *` |
| EventEffectScript | 0x37DE84 / 4 | local | `CEffectScriptMan *` (its symbol must stay reachable for the guarded `_ESM_INITIALIZE` assembly) |
| p_use_item | 0x37DE88 / 4 | global | `RS_STACKDATA *` (= arg slot `->p` in `_GOTO_USE_ITEM`; `EdEventMenuExit` writes `->i`) |
| SetWorldCoordFlg | 0x37DE8C / 4 | global | int |
| PakuAnimEohNo, PakuMotionEohNo | 4 each | global | int handle, -1 none |
| PakuMotionType, PakuMotionType2 | 4 each | global | int |
| nowScriptArg | 0x37DEA0 / 4 | local | `CEventScriptArg *` |
| EdEventInfo | 0x1EFD460 / 0x12A0 | global | ED_EVENT_INFO |
| EventObjHandleMother | 0x1EFE700 / 0x200 | global | CEohMother (also used by effscript, sceneseq) |
| esMother | 0x1EFE900 / 0x440 | global | CEventSpriteMother (8 x CEventSprite 0x88) |
| EventLocalFlag | 0x100 | global | `u32[64]` bit flags |
| EventLocalCnt | 0x100 | global | `int[64]` |
| EventRain | 0xABF0 | global | CRain (scene.hpp; also used by editloop) |
| Hit_para | 0x6400 | global | `BattleEffectPrim[5][0x40]`, one buffer per HitEffect (+0x20 para ptr, +0x2C max 0x40) |
| HitEffect | 0x1E0 | global | `CHitEffectImage[5]` (__construct_array 0x60 x5) |
| PakuAnimName(2), PakuMotionName(2) | 0x40 each | global | char[0x40] |
| event_snd_buff / event_snd2_buff | 0x8010 / 0x1410 | local | u_long128 buffers (0x801 / 0x141 quadwords) for BuffEventSnd(2) |
| BuffEventSnd / BuffEventSnd2 | 0x30 each | local | mgCMemory ("Event Snd Buffer"/"Event Snd2 Buffer"); `_SND_LOAD_SOUND` port 8 uses Snd2 |
| EventDngMap | 0x110 | local | CDngFreeMap (contains mgRect<float> at +0x20 and 8 at +0x40..) |
| cmr_seq_tbl | 0x6000 | global | `_SEN_CMR_SEQ[0x100]` |
| CameraSeq | 0xB10 | local | CSceneCmrSeq |
| obj_seq_tbl | 0x5000 | global | `_SEN_OBJ_SEQ[0x100]` (shared by all 32 object sequences) |
| ObjectSeq | 0xBE00 | local | `CSceneObjSeq[32]` |
| EventSprite2 | 0x1800 | local | `CEventSprite2[0x30]` |
| EventScriptArg | 0x10 | local | CEventScriptArg |
| EventScreenEffect | 0x4C | global | CScreenEffect |
| ext_func (symbol file `ext_func__2`) | 0x1770 | local | `static EventFunc ext_func[event_func_slots]` (0x5DC typed `int (*)(RS_STACKDATA *, int)`) |
| ext_func_info (symbol file `ext_func_info__2`) | 0x15C8 .data | local | `static RS_EXTFUNC_INFO ext_func_info[697]`: 696 typed handlers followed by `{NULL, EVENT_EXT_END}`; `EventExternalCommand` names every retail command number (sparse and out of order); eight-byte zero tail is retail piece padding (`SetEventFunc`, numbers 0..0x5DB) |
| esa_ext_func_info | 0x18 .data | local | `static RS_EXTFUNC_INFO esa_ext_func_info[3]`: `_DATA`, `_ID_OFFSET` (`EventArgumentCommand`) and the null sentinel |
| vv (retail `vv$3333`) | 0x30 .data | local | `static float vv[3][4]` inside `_SET_TALK_CAMERA`; it transforms `vv[1]`, the other two rows are retail data |

`Hit_para` holds `BattleEffectPrim` (dng_effect.hpp, 0x50) sparks, the type `HitEffect[n].spark`
points at: +0x10 pos, +0x20 velocity, +0x34 speed, +0x38 rate, +0x3C life, +0x44 alpha,
+0x48 alpha step.

## Functions
- `_OBJS_SYNC_OBJ` and the eight object-sequence delay commands evaluate the slot first and
  the following frame argument second. The native calls pass both values explicitly to
  `GetObjSeq(slot)` and the corresponding `CSceneObjSeq` member. The retail call sequence passed
  the frame through `$a1` even though `GetObjSeq` itself accepts only the slot.
- `_EOH_SET_STEP` passes the first script value as the handle number and the next as the
  motion speed. `SetStack` writes through a pointer stack entry; the event command returns 1
  after that write when its argument count is valid.
- `_SET_GYORACE_ETC` dispatches race settings by script operation: aquarium, rank, class and
  race number (0–3); tour count (4); fish name (5); formatted race time (6); and prize reload
  (7). The time is clamped to 0–360000 sixtieths, split into hours, minutes and hundredths, and
  assembled from Shift-JIS digit strings plus the separator before being copied into a message
  name slot.
- `VectMatMul__FPfPfPA4_f` exists twice: 0x260A70 here (global) and 0x282610 (local, another unit).
- `_LOAD_CHARA_sub(int,char**,int,u_int*)` is a 0x10 tail call to the 5-argument form with 0.
- `GetConfigCaptionOff` returns `lb` of SaveData+0x1C5A8 -> `char`.
- `EdEventStep` returns 1; `EdEventFinish` returns 0 when the scene camera is missing, else 1.
- `GetLocalFlag` computes a bool but returns `int` (mangling does not include return type).
- `CommandStreamOpen2` builds the path but never opens it (retail behaviour).
- `_SET_CROSSFADE` captures the current screen, converts script frames from 60 Hz to 50 Hz with a
  minimum of one frame, then calls `CrossFadeIn`/`CrossFadeOut` for three arguments, otherwise
  `CrossFade`.

## Data
All data is native; the unit has no `INCLUDE_RODATA`/`INCLUDE_BSS` markers.
- The 22 zero-storage objects (event state, flags/counters, mouth-animation names, particle
  buffers, camera/object sequence entries, sound buffers, dispatch array) are typed definitions
  with the extents in the table above. `EventStorageExtent` in `event_func.hpp` names
  `EVENT_LOCAL_NUM` (0x40 words), `PAKU_NAME_SIZE` (0x40 bytes) and `SEQ_NODE_NUM` (0x100
  entries) for `EventLocalFlag`/`EventLocalCnt`, the four mouth-name arrays and
  `cmr_seq_tbl`/`obj_seq_tbl`.
- `FileNameConvLanguage` initializes its four extension pointers (`txt`, `img`, `stb`, `""`) at
  their use and inlines its two format strings. Every user of the shared empty string writes `""`.
- Local aggregates with direct initializers: twelve NPC positions/facing angles
  (`_GET_TRAIN_NPC_POS`, zero-based row, y forced to zero in map 120), 25 three-column NPC
  training rows (`_GET_NPC_TRAIN_ETC`, requested column, one-based NPC row; the integer
  template's four-byte tail is alignment), 164 voice-pack lookup rows (`VpkFileNameFromVoiceNo`,
  group/kind match then resource id/subresource formatting), and `_HIT_EFFECT`'s default upward
  vector `{0, 1, 0, 1}` initialized at the copy site after reading the position.
- All string literals are inline at their uses, with Shift-JIS bytes as hexadecimal escapes.
- Jump tables emitted by native switches: `EventTimeDraw` (`at_1909`, `at_1910`),
  `_CHK_INTERSECTION_POINT` (`at_3823__2`), `_CHK_INTERSECTION_POINT_PIPE` (`at_3884`),
  `_SET_GYORACE_ETC` (`at_4272__2`, `at_4273`, `at_4274`), `_GET_GYORACE_ETC` (`at_4291`),
  `_GET_SAVEDATA_ETC` (`at_4360__2`), `_SET_EVENT_DATA` (`at_4573`), `_SET_MES_ETC`
  (`at_5264__2`), `_GET_FISHINGTOURNAMENT_ETC` (`at_5424`), `_GET_SND_ID` (`at_6703`),
  `_GET_EVENT_DATA` (`at_8406`), `_SET_FLOOR_INFO` (`at_8458`), `_GET_FLOOR_INFO` (`at_8480`).
  Piece tails beyond the declared payload are zero alignment padding.

## Callback result types
`CRunScript::ext` tests each callback's integer result and diagnoses zero. These callbacks return
their final dependency call's integer status (a `void` declaration would hide it): `_FINISH`,
`_IMG_SET_DRAW`, `_IMG_SET_GET`, `_IMG_SET_PUT`, `_IMG_SET_MOVE`, `_IMG_SET_FADE`,
`_IMG_SET_COLOR`, `_GEORAMA_FUNC`, `_EOH_SET_STEP`, `_EOH_SET_SHOW`, `_EOH_SET_FRAME_SHOW`,
`_EOH_SET_SHADOW`, `_EOH_SET_FOOT_SOUND_ID`, `_EOH_SET_FRAME_STATUS`, `_EOH_SET_SOUND_ID`,
`_EOH_SET_FADE_FLAG`, `_EOH_RESET_DA_POSITION`, `_EOH_SET_SHADOW_FRAME_STATUS`,
`_EOH_SYNC_GEOSTONE`, `_EOH_NORMAL_DRIVE`, `_EOH_SET_FOOT_SE_ID`, `_MT_TEST`. `_EOH_GET_POS`,
`_EOH_GET_ROT`, `_EOH_GET_SHOW` and `_EOH_GET_FRAME_POS` return the handle lookup's result, which
their stack-output calls preserve in `v0`. `_EOH_GET_FRAME_POS` needs the positive
`if (result != 0)` body with one common return: an early return shortens the body by four bytes
and moves the branch/call placement.

## Source forms the match depends on
- `_CHK_INTERSECTION_POINT` and `_CHK_INTERSECTION_POINT_PIPE` select polygons by indexing
  through the collision polygon cursor; indexing from the original local array changes register
  allocation. (`_CHK_INTERSECTION_POINT` tests a segment against event collision polygons, with an
  optional treasure-box test that adds polygons along the segment, and returns hit index, polygon
  kind, position, reflection and reflection angle by argument count; the `_PIPE` form is the
  swept-radius version returning the first hit.)
- `_DIST_VECTOR`, `_DIST_VECTOR2`, `_AMG_GET_ATTR_STATUS`: the stack advance past a vector is an
  integer byte add (`(RS_STACKDATA *) ((int) stack + 0x18/0x30)`) before `SetStack`. Retail keeps
  the advanced pointer in `s0` (`addiu s0,s0,24; move a0,s0`); `stack += 3`, `&stack[3]` and
  `SetStack(stack += 3, ...)` fold the add into the argument (`addiu a0,s0,24`) and drop an
  instruction. `_OBJS_SET_EOH_FRAME_POS` likewise uses `(u8 *) stack + vector_bytes`
  (`const int vector_bytes = 0x18`); `stack += 3` changes the function size.
- `_DELETE_CHARA`: `(CEoh *) ((u8 *) &EventObjHandleMother + offset)`; both an
  `&EventObjHandleMother.eoh[i]` local and direct indexing rotate `a3`/`t0`/`t1` between the
  offset, the element and the `charaSlot` pointer.
- `_FUNCTION_MAP_JUMP`: `(char *) (request + 6)` from `&EventScene->map_jump_flags`;
  `EventScene->map_jump_name` (the same address) reloads `EventScene` and shrinks the function.
- `_SWE_SET_COLOR`, `_SWE_SET_TEXTURE`, `_SWE_START_EFFECT`: `(CSWordAfterEffect **) ((slot << 2)
  + (int) chara + chara_sword_after_offset)` (0x570, `CCharacter2::sword_effect`) keeps retail's
  index-first sum; `&chara->sword_effect[slot]` adds the base first (`addu v0,v0,v1`).
- `_SWE_INIT`: `chara->sword_effect[slot] = new (scene_stack->Alloc(12)) CSWordAfterEffect` uses
  the inline constructor for the two colours.
- `_ESM_INIT_FIX`: `(mgCMemory *) operator new(0x30, ...)` then `Init()`; `new (...) mgCMemory`
  is one instruction longer (the null test moves after the copy of the result).
- Handle drives use `(CCharacter2 *) handle->object` locals (base-to-derived downcasts of the
  handle's `CObject *`); `mgCObject *` locals take `CEoh::object` without an upcast.
- `_GET_NEAR_TBOX_POS`: `stack += 3` and `&box_manager->box[i]` for `i < TREASURE_BOX_MAX`.
  `_GET_EVENT_DATA` case 8 reads `event_data->map_event.matrix[3][0..2]` (translation) and
  `matrix[2][0]`, `matrix[2][2]` (z axis, for the yaw). `_GET_INVENTION_ID` uses
  `&save->user_data.invent_data` (0x7F30). `_MES_MAKE` stores the text in `ClsMes::text_ptr`
  (`char *`). Loaded data at API boundaries: `CheckLoadedBGFile` returns the `u_long128` read
  buffer as a `u32 *` pack, `GetLoadBGBuff` results are viewed as `MDS_HEADER *`, `char *` or
  `u_char *`, and `CScreenEffect::CaptureSepiaScreen`/`CaptureMonoFlashScreen` walk
  `texture->image[0]` as RGBA bytes.

## Floating argument calibration (satansfiddle rows)
- `_SET_CROSSFADE__FP12RS_STACKDATAi`: each of the three calls passes `1.0f`, but retail evaluates
  that constant early only for `CrossFadeOut__10CFadeInOutFiif`. The row selects `event_func.cpp`,
  this function, `binary32` bits `0x3f800000`, `callee: CrossFadeOut__10CFadeInOutFiif`,
  `evaluate_first: true`; the `CrossFadeIn__10CFadeInOutFiif` and `CrossFade__10CFadeInOutFif`
  calls keep the false policy. A value-only true row changes the sibling calls' register
  allocation; false for all three emits a function four bytes too long. The callee name
  distinguishes the argument at consumption without occurrence indices. The function is 0x158
  bytes.
- `LoadMovie__FPcP9mgCMemoryb`: a `binary32` `0x44000000` (512.0f) `evaluate_first: true` row
  for caption centering prepares the horizontal extent before the zero origin in
  `CalcAutoPosSet`. The unit's helper masks are GPR `0x30` / FPR `0`.
See [MWCC notes](../../../../docs/MWCC.md).
