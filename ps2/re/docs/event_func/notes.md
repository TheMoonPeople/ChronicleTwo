# event_func: reverse-engineering notes

`_SET_CROSSFADE` captures the current screen, converts script frames from 60 Hz to 50 Hz
with a minimum of one frame, then starts an incoming, outgoing, or ordinary crossfade.
The native function matches with the callee-scoped floating argument calibration
documented below.

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
  `ED_EVENT_INFO`). **`scenesnd.hpp` did not exist when this header was written**, so the header
  does not compile until it appears and declares `CScene::BGM_STATUS` (0x1C bytes: +0 state,
  +4 now no, +8, +0xC, +0x10, +0x14 float volume, +0x18; see `CScene::GetActiveBgmStatus`).
  With that member stubbed as `u8[0x1C]` the header and `event_func.cpp` compile and every
  STATIC_ASSERT holds.
- `RS_EXTFUNC_INFO` (row type of `ext_func_info__2` / `esa_ext_func_info`) is declared in
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
| EventEffectScript | 0x37DE84 / 4 | local | `CEffectScriptMan *` |
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
| event_snd_buff / event_snd2_buff | 0x8010 / 0x1410 | local | u_long128 buffers for BuffEventSnd(2) |
| BuffEventSnd / BuffEventSnd2 | 0x30 each | local | mgCMemory ("Event Snd Buffer"/"Event Snd2 Buffer"); `_SND_LOAD_SOUND` port 8 uses Snd2 |
| EventDngMap | 0x110 | local | CDngFreeMap (contains mgRect<float> at +0x20 and 8 at +0x40..) |
| cmr_seq_tbl | 0x6000 | global | `_SEN_CMR_SEQ[0x100]` |
| CameraSeq | 0xB10 | local | CSceneCmrSeq |
| obj_seq_tbl | 0x5000 | global | `_SEN_OBJ_SEQ[0x100]` (shared by all 32 object sequences) |
| ObjectSeq | 0xBE00 | local | `CSceneObjSeq[32]` |
| EventSprite2 | 0x1800 | local | `CEventSprite2[0x30]` |
| EventScriptArg | 0x10 | local | CEventScriptArg |
| EventScreenEffect | 0x4C | global | CScreenEffect |
| ext_func__2 | 0x1770 | local | `int (*[0x5DC])(RS_STACKDATA *, int)` |
| ext_func_info__2 | 0x15C8 .data | local | `RS_EXTFUNC_INFO[]` terminated by func 0 (`SetEventFunc`, numbers 0..0x5DB) |
| esa_ext_func_info | 0x18 .data | local | `RS_EXTFUNC_INFO[3]` (argument-script functions, numbers 0..2) |
| vv_3333 | 0x30 .data | local | function-local static |

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
  name slot. The C++ draft is guarded and differs from retail; the normal build keeps assembly.
- `VectMatMul__FPfPfPA4_f` exists twice: 0x260A70 here (global) and 0x282610 (local, another unit).
- `_LOAD_CHARA_sub(int,char**,int,u_int*)` is a 0x10 tail call to the 5-argument form with 0.
- `GetConfigCaptionOff` returns `lb` of SaveData+0x1C5A8 -> `char`.
- `EdEventStep` returns 1; `EdEventFinish` returns 0 when the scene camera is missing, else 1.
- `GetLocalFlag` computes a bool but returns `int` (mangling does not include return type).
- `CommandStreamOpen2` builds the path but never opens it (retail behaviour).
# Native event object construction

`_COPY_CHARA` and `_COPY_MONS2SCNCHR` allocate a `CCharacter2` in a scene stack,
then copy the source character or monster into the new slot. Their C++ bodies
use typed placement construction for the base and character initialization.
`_ESM_INITIALIZE` similarly constructs `CEffectScriptMan` in the event stack;
its member constructors initialize the sprite and manager. All three remain
`NONMATCHING` drafts with retail `INCLUDE_ASM` bodies. The retail
`_COPY_MONS2SCNCHR` body calls the compiler-generated `CObject` copy constructor,
which is also supplied as an assembly gap immediately after it. The natural
C++ draft emits the constructor at retail's 0xC8-byte size but differs at
placement-new's null branch: retail tests `v0` before moving the allocation
result to `s3` in the delay slot, whereas MWCC moves it first and then tests
`s3`. Value initialization, staged allocation, reference binding, volatile
storage, and alternate assignment forms did not match that branch schedule.
## Pending code matches

`_CHK_INTERSECTION_POINT` tests a segment against event collision polygons. An optional
treasure-box test adds polygons along the segment. The command can return the hit index,
polygon kind, hit position, reflection, and reflection angle according to its argument count.
`_CHK_INTERSECTION_POINT_PIPE` performs a swept-radius version of the same test and returns
the first hit's details. Both native C++ functions pass the full linked-image comparison.
Their polygon selection uses array indexing through the collision polygon cursor; indexing
from the original local array changes MWCC register allocation and no longer matches.

`LoadMovie`, `_COPY_CHARA`, `_ESM_INITIALIZE`, and `_COPY_MONS2SCNCHR` retain
C++ drafts under `NONMATCHING`. The default build uses retail assembly for
these functions until their C++ object scores reach zero. The copy constructor
gap is required while `_COPY_MONS2SCNCHR` uses retail assembly, since no active
C++ use otherwise causes MWCC to emit that constructor.

## Crossfade floating argument calibration

`_SET_CROSSFADE__FP12RS_STACKDATAi` captures the screen, converts script frame
counts from 60 Hz to 50 Hz with a minimum of one, and calls `CrossFadeIn` or
`CrossFadeOut` for three arguments, otherwise `CrossFade`. Each native call
passes `1.0f`, but retail evaluates that constant early only for
`CrossFadeOut__10CFadeInOutFiif`. The `CrossFadeIn__10CFadeInOutFiif` and
`CrossFade__10CFadeInOutFif` calls retain the false policy.

The verified row selects `event_func.cpp`,
`_SET_CROSSFADE__FP12RS_STACKDATAi`, `binary32`, IEEE bits `0x3f800000`,
`callee: CrossFadeOut__10CFadeInOutFiif`, and `evaluate_first: true`.
A value-only true row changes the sibling calls' register allocation; false
for all three emits a function four bytes too long. The stable mangled callee
distinguishes the argument at consumption without occurrence indices. Live
compiler tracing found direct floating constant nodes at all three calls,
including a freshly allocated node with an uninitialized evaluate-first byte.

The production mwccgap wrapper, section fixup, and canonical object checker
prove the `0x158`-byte function's exact bytes and resolved relocations. The unit
returns to its original `0x22cc4` bytes, 6888 relocations, and 16 existing issues,
with no crossfade failure. Those remaining issues include event object-copy
functions and unrelated data/layout mismatches. This is a function match,
not a whole-unit pass. See [MWCC notes](../../../../docs/MWCC.md).

## LoadMovie floating argument calibration

`LoadMovie__FPcP9mgCMemoryb` uses a stable binary32 `0x44000000` (512.0f)
`evaluate_first: true` selector for caption centering. This prepares the
horizontal extent before the zero origin in `CalcAutoPosSet`; caption behavior
is unchanged. With the artificial division primer removed and translation-unit
helper masks GPR `0x30` / FPR `0`, the complete unit passes canonical instruction
bytes and resolved relocations: `0x22C7C` checked bytes and 6,920 relocations.

## Remaining allocation checks on the integrated baseline

With the pinned profile, `_COPY_CHARA` and `_ESM_INITIALIZE` each differ by
two instruction words. The generated bodies are 0x2B4 and 0x128 within the
padded retail extents 0x2C0 and 0x130 respectively. The difference is the documented
placement-new result schedule: retail tests v0 and copies to the saved
object register in its delay slot; MWCC copies first and tests that saved
register. `_ESM_INITIALIZE` isolates the pair at +0x78/+0x7C. These remain
parked for the dedicated placement-new investigation.

The October 8 midday baseline `c79e57c` does not reproduce the previously
reported two-word `_COPY_MONS2SCNCHR` miss. It has 248/472 differing words
and a 0x758 native body in the retail 0x760 extent. Naming the copied
`CCharacter2` source retains natural copy construction and improves the draft
to 246/472 with a 0x750 body. The allocation branch at +0x94/+0x98 remains,
and a separate aggregate-copy difference begins at +0x390. In particular,
the implicit copy of `shadow_link` at source offsets +0x35C..+0x364 uses
three FPR loads/stores and a destination-address temporary; retail copies
the corresponding words individually through a GPR. No floating conversion
is involved. This changes subsequent scheduling and instruction positions.
The existing `CCharaFrameMatching` grouping therefore needs further type and
copy-construction evidence in its owning header; it is not just a null-branch
park. No shared-header patch or hand-written copy body is proposed here.

The compiler-generated `CObject(const CObject&)` already matches in the
all-drafts compilation with the current natural class definition. No shared
header change is required for its bytes or relocations. Its actual emission
here comes from the character copy inside `_COPY_MONS2SCNCHR`.
While that caller is guarded, the default build still requires the copy
constructor assembly fallback. Reconsider its independent promotion when
an active native caller naturally emits it; an explicit copy body or dummy
use is not an acceptable way to force emission.

`_ESM_INITIALIZE`'s inherited two-word draft score still includes the legacy
identity-only `Ident` scaffold; that helper is not an acceptable promotion
mechanism. Removing it leaves an 11/76-word helper-free draft at the same
0x128-byte body size: the branch pair plus exchanged s0/s1 lifetimes.
Initializing the stack number at declaration instead changes the stack frame
and shortens the body; declaration reordering alone leaves the 11-word
remainder. The default complete object still passes without Ident, but the
lane's closer-draft rule leaves the original guarded source unchanged.
An admissible source lifetime distinction is required before promoting this
function, in addition to resolving the placement-new branch.

Midday helper-free probes with named texture-buffer arguments, a named base
texture buffer, a named offset, or direct assignment to `EventEffectScript`
each retain 11/76. No new helper or source workaround is retained.

Private receipts: `.private/placenew-midday/baseline-native/event_func/`,
`.private/placenew-midday/probes/monster-copy-initialization/`,
`monster-named-copy/`, `monster-source-reference/`, and the `effect-*`
directories under `.private/placenew-midday/probes/`.

## Shared native storage extents

EventStorageExtent exposes the existing source extents in event_func.hpp:
EVENT_LOCAL_NUM is 0x40 words, PAKU_NAME_SIZE is 0x40 bytes, and SEQ_NODE_NUM
is 0x100 command entries. EventLocalFlag/EventLocalCnt, the four mouth-name
arrays, and cmr_seq_tbl/obj_seq_tbl use the same identifiers in declarations
and definitions. The header enum replaces only the three source-local const
integers; the existing range checks, initialization calls and native data
retain their values and layouts.

Receipts: .private/fixes-r0/event-func-final-{build,objects}.log:
SCES_511.90: OK and 149/149 objects.
