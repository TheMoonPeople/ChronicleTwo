# gyorace: reverse-engineering notes

Fish race sub game. No class is owned by this unit (`class_units.tsv` has none). No first-game
counterpart (Dark Cloud 1 has no fish race).

## Functions
| Function | Binding | Return | Notes |
|---|---|---|---|
| `sgInitGyoRace(SubGameInfo*)` | global | int | 1 ok, 0 if a fish chr file fails to load |
| `sgLoopGyoRace(SubGameInfo*)` | global | int | 1 after mode 5 (results stored, event 0x15E / 0x160 with OmakeFlag run), else 0 |
| `AutoCam(SubGameInfo*)` | global | void | nearest of 5 `cam_pos` to hero fish; plays SE 2 vol when cam y < 0 |
| `sgMapDrawGyoRace` | global | int | returns 0 |
| `sgCharaDrawGyoRace` | global | int | DrawChara for 6 fish, Step/Draw 0x60 CHitEffectImage |
| `DivSpriteScreen(mgCDrawPrim&)` | **LOCAL** (`__2` suffix) | void | static, belongs in .cpp; not in header. Uses fn-local statics `ras_off_1762` (float), `init_1763` (bool), `at_1765__2`/`at_1775`/`at_1776` (local 0x10 bss). Underwater raster wobble |
| `sgEffectDrawGyoRace` | global | int | only when `water_cam` |
| `sgSysDrawGyoRace` | global | int | fn-local statics `lap_inf_1798` int[2][5] (h, m/10, m%10, cs/10, cs%10 per lap), `lap_inf2_1799` int[5] (total time digits) |
| `Jikkyou(SubGameInfo*)` | global | int | -1 while race_cnt<=0 or mes_count>0, else 0 |
| `__sinit_gyorace_cpp` | — | — | `BuffTextureData.Init()`, `BuffWorkData.Init()`, `camera0 = mgCCamera(8.0f)` |

## SubGameInfo (subgame.hpp, not owned here)
`+0` CScene*; `+4` is the first texture block number for fish characters (`CharaTexb = info->texb`).

## Global data (non-local -> extern in header)
| Symbol | Type | Evidence |
|---|---|---|
| `fish_name` 0x362150 | `char*[18]` | .data words -> strings ("f1a.chr"...); index `species(+2 of CGameDataUsed) - 0x140`, negative -> 0x11. Two zero words follow (align pad before cam_pos) |
| `cam_pos` 0x3621A0 | `sceVu0FVECTOR[5]` | 0x50 bytes, w=1.0; stride 0x10 in AutoCam |
| `race_cnt` | float | `= 0.0`, `+= 0.1` per frame in modes 2/3 |
| `race_proc_cnt` | int | frame counter; 0x4B (mode 0), 0xF (mode 1), 0x78 (mode 3, fade out at 0x1E) |
| `race_mode` | int (`GYORACE_MODE`) | switch 0..5 in sgLoop. Mode 4 is never set in this unit (goal view from camera (270,-40,-10)/(192,0,0), back to 3) |
| `time_max` | int | `sw $v0` of `grGyoRaceSimulate` (which tail-returns StepGyoRace's value) |
| `camera_id` | int | `CScene::AssignCamera` result; written to `CScene::active_camera` at +0x2E54 (old in `before_camera` at +0x2E58). Symbol 4 bytes; BSS slot 8 (pad) |
| `race_rank` | int[2] | [0]=GetGyoRaceClass, [1]=GetGyoRaceNo; symbol size 8 |
| `gyo_mes` | ClsMes* | `new(Alloc(0x298)) ClsMes` (0x2958) ; inlined ClsMes init follows the ctor |
| `fish_game_data` | `GYORACE_RESULT[6]` | 0xD8 = 6*0x24; written in sgLoop mode 5 at index rank-1; read by event_func `_SET_GYORACE_ETC` (name +0, time +0x18) and sgInit (+0x1C/+0x20 for races already run) |
| `RaceInfo` | `grRACE_INFO` (gyoracesim) | 0x1DC; defined in gyoracesim.hpp |
| `old_prog` | `grRACE_PROGRESS[6]` (0x90, stride 0x18) | Declared in gyorace.hpp, which includes gyoracesim.hpp |
| `camera0` | mgCCamera (0x70) | ctor in __sinit; `mgCCamera` methods called on it |
| `fish_inf` | `GYORACE_FISH_INF[6]` | 0x108 = 6*0x2C |

`AutoCam` selects the nearest of the five `cam_pos` vectors, then writes the
assigned camera identifier through `CScene::active_camera`. The typed
`cam_pos[camera]` lookup and named scene field both retain a 100% object match;
replacing the scene field with a byte-offset write changes its generated code.

Local (static, stay in .cpp): old_cam_no (.sdata, int = -1), gyore_snd_id, rank_count, EffectTex,
EffectTex2, wind_tex (mgCTexture*), hero_no, water_cam (bool/char, symbol size 1), cam_no, win_alpha
(float, 128.0 reset, -0.5/frame), effect_cnt (0..0x5F ring), mes_count, jyunkai_flg, hantei_flg,
goal_cnt, battle_effect (CHitEffectImage*, 0x60 entries via __construct_new_array, size 0x60),
battle_EffectPara (0x3C000 bytes; 0xA00 per effect at effect+0x20, +0x2C = 0x20), CharaTexb,
WindowTexb, EffectTexb, fish_rank (int[6]: fish index by place; 4 bytes pad D_01F5971C follow),
old_fish_rank (int[6]), game_data (CGameDataUsed*[6]: [0] = player's fish or omake fish),
old_ambient (float[4]), BuffTextureData / BuffWorkData (mgCMemory, 0x30).
Note `old_prog[rank + 0x23]` in Ghidra is really `fish_rank[rank - 1]`; `D_01F5971C + i*4` is
`old_fish_rank[i - 1]`.

## GYORACE_FISH_INF (0x2C, neutral name)
| Off | Field | Evidence |
|---|---|---|
| 0x00 | lane | = start lane (0..5, rotating from a random start); same value stored in RaceInfo fish +0x3C (RaceInfo+0x48+i*0x40), shown as +1 in commentary (`gyo_mes+0x21BC`), progress bar y = lane*10+35 |
| 0x04 | chara_no | 0x40+i; GetCharacter/LoadChara/SetActive/DrawChara |
| 0x08 | fish_no | -1 or index passed to `CGyoraceFishData::GetRaceFish`; copied to result +0x1C |
| 0x0C | rank | computed per frame from progress (+1 per fish ahead or already goaled); used for place sprite x = rank*0x18 |
| 0x10 | lap | u32 (`fptoui(pos/8)`, unsigned compare); 2 laps of 8 course units |
| 0x14 | unk_14 | set to 1 entering lap 1, never read |
| 0x18 | lap_start | race_cnt on entering lap 1 |
| 0x1C | unk_1c | never accessed in this unit |
| 0x20 | time | race_cnt*20 (or goal time*20 from RaceInfo+0x1C4[i]) for hero_no only |
| 0x24 | lap_time[2] | [lap] = time - lap_start*20; at goal [1] = time - rounded [0] |
Time units: displayed as `t/3600` min, `(t%3600)/60` s, `rem*100/60` hundredths -> sixtieths of a second.

## GYORACE_RESULT (0x24, neutral name)
`+0 char name[0x18]` (blanked with 18 spaces then strncpy of CGameDataUsed+0x10 name), `+0x18 float time`,
`+0x1C int fish_no`, `+0x20 int race_class` (race_rank[0]).

## grRACE_INFO layout seen from here (for the gyoracesim agent)
`+0` seed (0 -> derived), `+8` fish count = 6; fish entries at `+0xC`, stride 0x40, 6 entries:
`+0 char name[0x18]` (CGameDataUsed+0x10), `+0x18` species (s16 +2), `+0x1C` (u8 +0x4A), `+0x20` (u8 +0x26,
also commentary message base: MakeMesWin(+0x20 + 9/0xD/0x11/0x15)), `+0x24` (u16 +0x3E), `+0x28` (u16 +0x3C, player
fish reduced by tiredness `+0x34`: `v - (t-1)*0.1*v`), `+0x2C` (+0x36), `+0x30` (+0x38), `+0x34` (+0x3A),
`+0x38` operation/tactics (printf "Operation=%d"), `+0x3C` lane. `+0x18C` = 1000, `+0x190` 6 pointers to
24000-byte buffers, `+0x1A8` = 0x14, `+0x1AC int[6]` final place per fish, `+0x1C4 float[6]` goal time.
grRACE_PROGRESS (0x18): `+0` float course position (0..16, 8 per lap), `+8` float lateral lane position
(x = v*15+190), `+0xC` char state (2 = battle splash, 3 = goaled).

## Unresolved
- Retail names of the two structs (neutral names chosen).
- Enum names for `GYORACE_MODE` are neutral.

## Current matching status (2026-10-08)

Nine of the ten functions are source supplied. Only `sgLoopGyoRace`
remains guarded; `sgInitGyoRace` and `sgSysDrawGyoRace` are native and exact
(see [night-20261008.md](night-20261008.md)). The earlier partial-draft
and initializer promotion descriptions are obsolete; the current initializer
and drawing/commentary helpers already match. Fresh receipts supersede the
previous claims of ten/twelve-word Init/Draw differences.

### Race display

Superseded by [night-20261008.md](night-20261008.md): the function matches.

`sgSysDrawGyoRace` starts at 65/1172 differing words, with a 0x1244-byte body
inside the 0x1250 retail extent. Computing the lane's vertical bar position
before passing the draw arguments reproduces retail's float scheduling and
removes 38 differences. The lap-display comparison is signed (`slt`), despite
the stored unsigned lap number, so an explicit signed index conversion
removes another difference.

The closest compliant draft differs by 47 words after removing an unused
pre-bar index initialization and storing all lap digits before initializing
the display counters. The remaining differences concern saved-register
allocation for the lane pointer and row induction, seconds/hundredths values,
and the later lap rows. Keeping the unused initialization yields 26 words,
but is not an acceptable matching technique. Reusing an entrant index or a
row variable across display paths and scoping the row pointers locally do
not recover the retail lifetimes. Reconsider with a natural loop form that
accounts for these saved-register identities.

### Race initialization

This historical draft analysis is superseded by the native initialization
and camera calibration in [night-20261008.md](night-20261008.md). The shared
fatigue field is now `u16`, and the complete native function matches.

The untouched Init draft emits a 0x1210-byte section against retail's 0x1200
extent and differs in 437 disassembled instructions. Direct fish pointers
for stamina and character scale replace unnecessary pointer-reference
bindings reduce its section to 0x1208 bytes, still eight bytes beyond the
retail extent; 433 disassembled instructions differ. Its first register differences are at +0x69C in entrant
selection. The parameter loop keeps the RaceInfo base and its entry offset
live separately, whereas retail retains one computed entry address and
keeps the fish-state induction offset in s8 instead of spilling it. Later
code inherits the resulting instruction displacement. The final reference
camera calls also load constants in a different order. Unsuffixed camera
arguments do not fix that order.

At +0xB84 retail loads the fish fatigue increment with `lhu`, whereas the
shared `BREEDFISH_USED::fatigue` declaration is signed. A temporary unsigned
field declaration corrects that opcode but also changes register allocation;
it was reverted. Any shared type correction requires auditing its other
consumers and complete-object validation. Neither pointer changes nor this
type probe produced a match. Reconsider after that type audit and with a
natural form preserving the computed entry address through its parameter
writes. The placement-new branch and pointer-copy delay slot at +0x154 and
+0x158 already match; they are not this function's blocker.

### Race loop

The untouched Loop draft emits a 0x1A40-byte section against the 0x1A30 extent
and differs in 1188 disassembled instructions. The unused dead-section
division helper and the identity wrapper around rectangle construction have
been removed. Rectangle assignment now uses the normal `mgRect<int>`
constructor and compiler-generated value assignment. Reading the hero's
time through the hero index when updating its lap time retains retail's
reload after writing the current fish time; this is equivalent within the
existing fish-equals-hero branch. The draft still differs in 1188
disassembled instructions, with substantial instruction displacement.

The early differences include camera argument constant order, followed by
evaluation order and reloads in the hero lap/goal-time branches. Implicit
double-to-float startup camera arguments do not improve the code. Reconsider
with source-level evaluation and alias-lifetime evidence for those branches,
then the rectangle copy, before treating later displaced instructions as
independent mismatches. The guarded assembly remains active.

## October 8 mid-day matching audit

At this historical mid-day checkpoint all three large functions were guarded;
Init and SysDraw have since become native. All probes below use
MWCC 3.0-011126 with canonical flags and the checked-in profile, unless a
private diagnostic profile or header overlay is explicitly named. The
following measurements supersede earlier draft scores and alias conclusions.

| Function | Retained native comparison | Body / retail extent |
|---|---|---|
| `sgInitGyoRace` | 432/1,154 words, including the two excess native words | 0x1208 / 0x1200 |
| `sgLoopGyoRace` | 490/1,676 words | 0x1A30 / 0x1A30 |
| `sgSysDrawGyoRace` | 10/1,172 words | 0x1244 / 0x1250 |

`attempt-word-metrics.json` masks relocation operands and zero-extends the
shorter side when a native body exceeds the retail extent. Thus the Init
score includes its overrun; `draft_check.compare` normally reports only the
size failure for that case. Word comparisons alone do not establish resolved
relocation identities or permit promotion.

### Entrant selection and initialization

The function loads the race sound bank, localized commentary, simulation
fish data, splash work arrays and character models. Six entrants are chosen
without reusing generated fish numbers; later races can retain earlier
finishers. The simulation receives a zero seed, 1,000 progress entries per
entrant and 20 after-goal steps. Parameters come from `BREEDFISH_USED`, with
fatigue reducing the player's stamina. The chosen lanes cycle through 0..5.
Character setup loads one texture block per entrant, clamps size scaling to
2.0, positions the models at their lane starts and selects the swim motion.

The current `grFISH_PARAM` and `GYORACE_FISH_INF` definitions establish the
0x40 and 0x2C strides; `grRACE_PROGRESS` is 0x18, with signed-byte state at
0xC and lane at +4. The seed/progress/rank/goal-time fields of `grRACE_INFO`
are documented by gyoracesim. No untyped byte-offset traversal is required.

The first mismatch at +0x69C swaps the chosen-array offset and chosen slot
pointer between `s3` and `s4`. The parameter loop then retains the RaceInfo
base and induction offset separately and spills the fish-state induction.
A direct `grFISH_PARAM*` produces 461/1,152 words and 0x11F8 bytes; extending
that pointer over the complete loop gives 520 words and 0x11C8 bytes. Neither
improves the retained function.

Retail's fatigue increment uses `lhu` at +0xB84. The shared field is `s16`,
and an unsigned conversion before increment is optimized back to the same
`lh` when stored into that field. The candidate type correction is held in
`.private/proposals/unsigned-race-fish-fatigue.patch`; it needs an audit of
all fish-data consumers. Callee-scoped evaluate-first probes for the camera
reference zero and 222.0f do not remove the size/allocation blocker.

Receipts: `.private/editloop-midday/sgInitGyoRace__FP11SubGameInfo.m2c.cpp`,
`race-other-original/`, `race-init-entries.log`,
`race-init-fatigue-cast-compile/diff.txt` and `race-camera-profiles.log`.

### Motion, lap timing and results

The complete m2c reconstruction uses an additional private assembly input
that identifies the existing switch table with a `jtbl_` label and appends
its unchanged retail targets. It is driven through `decompile.sh`; neither
tracked assembly nor generated retail instructions are modified.

The loop replays simulated progress, computes places, updates lap timing,
maps each fish onto the two straight sections and circular course ends,
spawns splash effects and updates the tracking camera. Completed races save
the ordered fish results and restore the ambient lighting and scene state.

The normal hero timing store reads the updated time through the current
`state` pointer while selecting the destination lap through the hero's lap
index. m2c and the retail load identify `state->time`; this supersedes the
earlier recommendation to read `fish_inf[hero].time`. The change removes
eight bytes and improves the overlength 1,188-word draft to 490 words with
the exact 0x1A30 extent. References/pointers to the time or lap field,
shared/fresh fish indices, named conversion rates and SDK vector aliases
do not improve it further.

Retail reserves 0x3F0 stack bytes; the retained draft reserves 0x3E0. At
+0xE14..+0xE20, retail copies a constructed 16-byte rectangle to a second
aligned argument temporary with `lq`/`sq`, then assigns its four edges into
the splash image. The current implicit `mgRect<int>` assignment consumes a
reference and omits that value argument. A private header overlay with a
by-value assignment parameter reproduces the copy and the 0x3F0 frame, but
the resulting function still exceeds its extent and differs elsewhere.
Returning void or a reference gives the same observed call-site behavior;
the return type cannot be established at this unused-result call.

`.private/proposals/rectangle-value-assignment.patch` is a candidate shared
template correction, not an accepted match. It has not been applied and
requires complete-object checks across all template consumers. Copy/direct
initialization of a real local rectangle does not reproduce the missing
argument copy. No identity helper is added. Remaining issues include camera
constant order between modes, active fish-index allocation, the rounded
goal-lap calculation and splash/rotation call evaluation order. A private
gravity evaluate-first selector does not improve the current body.

Receipts: `.private/editloop-midday/sgLoopGyoRace__FP11SubGameInfo.tables.m2c.cpp`,
`race-loop-state-time-compile/{compare.log,diff.txt,aligned.txt}`,
`race-loop-copy.log`, `race-loop-byvalue-reference/`,
`race-loop-rates.log` and `race-loop-time-aliases.log`.

### System display

Typed lane accesses remove the live scalar-field pointer from the six-fish
progress-bar loop. Reusing the ready-path vertical coordinate and giving
the active lap rows separate X/Y induction values recover the seconds and
hundredths register lifetimes. These source changes reduce the retained
draft from 47 words to 10, without an unused initialization or artificial
helper.

All ten residual differences exchange the active lap counter (`s0` in
retail, `s4` in native) and the five-digit row pointer (`s4` in retail,
`s0` in native). Their actual byte offsets are +0x8B8, +0x90C, +0xAD8, +0xAE0, +0xB34,
+0xB94, +0xBF4, +0xC54, +0xCA0 and +0xCA4; the round-1 audit below
corrects the earlier disassembly-row labels. Every other instruction word
compares, including floating scheduling and sprite rectangles. The 12-byte
tail is zero retail padding.

Alternative loop indices, local pointers/references, indexed digit access,
for/while forms, pre/post-increment, initialization/declaration order and
pointer acquisition sites do not recover that allocation. Changing the
helper mask from 0x30 to 0 or 0x10 worsens the best draft to 28 words.
Disabling global optimization also exceeds the retail extent. Those
diagnostics are private; no profile row or compiler pragma is changed.

Receipts: `.private/editloop-midday/sgSysDrawGyoRace__FP11SubGameInfo.m2c.cpp`,
`sys-saved/{compile.log,compare.log,diff.txt}`, `sys-lap-control.log`,
`sys-lap-lifetimes.log`, `sys-helper-masks.log` and `sys-global-off.log`.

### Active build

The guarded source improvements do not change the active gyorace object.
The lane remains at 147/149 complete-object passes and the known PAL 0x26
`.text` discrepancy; no other file-backed section or memory extent fails.
All 148 objects outside the promoted editloop assignment retain their
baseline hashes. Coverage is 6,687 matched functions, one above the base.
Private receipts are `guarded-drafts-build.log`, `guarded-drafts-objects.log`,
`guarded-drafts-object-hash-diff.json` and `attempt-word-metrics.json` under
`.private/editloop-midday/`.


## October 8 mid-day round 1

The fresh `98f90fd` baseline and final active build both pass 147/149 units,
retain the known PAL 0x26-byte `.text` difference and report 6,687 matched
functions. All 149 game object file hashes remain unchanged. No gyorace
source, header or profile row is changed and no function is promoted.

### Lap display allocation

`sgSysDrawGyoRace` remains at 10/1,172 differing words with a 0x1244 native
body in the 0x1250 retail extent. The established five time digits are whole
minutes, seconds tens/units and hundredths tens/units. Both row arrays are
persistent function-local state; their retail symbol sizes are 0x28 for the
two lap rows and 0x14 for the total row. The larger existing BSS marker
extents include following storage/alignment and do not change those types.

New natural-source probes do not recover the counter/pointer allocation:

- Declaring rectangles at their Set calls, with or without pair scopes,
  gives 143 words, primarily from changed stack-slot order.
- Splitting or nesting the hundredths assignment, a typed five-field digit
  record, enum-typed race mode, and true function-local lap arrays retain
  ten words. Defining statics with natural or numbered names has the same
  result; no storage migration is retained.
- A row-local const pointer gives 36 words. Distinct fish/minute/lap indices
  give 54; sharing the ready and active row counter gives 31. Removing the
  separate array-row index from the scoped-index form still gives 54.
- A switch over race mode gives 458 words. A long index exceeds the retail
  extent (0x1258 versus 0x1250, 1,148/1,174 compared words).

The earlier counter/pointer, helper-mask and loop-form trials are not replayed.
The function stays guarded because every otherwise matching word still uses
`s4` for the native lap counter and `s0` for the native digit-row pointer,
while retail uses the opposite allocation.

### Correct disassembly offsets

`draft_check.show_diff` invokes objdump without `-z`. Objdump suppresses runs
of zero instructions, but the helper labels rows using `row_index * 4`;
after a suppressed run its printed offsets are too small. The old lap-loop
labels are 0x20 bytes below their actual addresses.

Raw section bytes and a private objdump `-z` diagnostic agree on the ten
true offsets: +0x8B8, +0x90C, +0xAD8, +0xAE0, +0xB34, +0xB94, +0xBF4,
+0xC54, +0xCA0 and +0xCA4. The first is retail 0x30D5F8. The diagnostic also
prints the complete 1,172-word extent and agrees with the raw-word score.
The twelve-byte terminal padding is zero. This corrects the offset labels,
not the previously established ten-word register swap.

The tool is outside this lane's ownership. The exact proposed two-line fix,
`.private/proposals/draft-check-zero-disassembly.patch`, adds `-z` to both
retail and native objdump invocations. It remains unapplied.

Receipts under `.private/editloop-r1/`: `sgSysDrawGyoRace.m2c.cpp`,
`sys-natural-locals.log`, `sys-phase-lifetimes.log`, `sys-native-statics.log`,
`retained-sys/{compare.log,diff-with-zeros.txt}`,
`attempt-word-metrics.json`, `trial-ledger.tsv`, `final-objects.log` and
`final-object-hash-diff.json`.

## Race sprite helper forms

The canonical isolated baseline passes the complete gyorace object. Replacing
DrawRaceSprite with a static inline function that takes the atlas texture and
nine integer arguments grows sgSysDrawGyoRace's section from 0x1244 to 0x1304;
1,136/1,172 relocation-masked words differ within the padded retail extent.
An inline function reading the file-static wind_tex directly still grows the
section to 0x1274 and differs in 640/1,172 words. Both fail the complete object
check, including its local-static data identities. The first stack-frame and
rectangle-slot instructions already differ, so neither form preserves the
retail call-site layout. No inline-depth pragma or other steering is added.

The macro remains, with an explicit texture argument at every call. It no
longer captures wind_tex from the caller's scope. This form passes the full
isolated object check (0x4FF8 bytes, 1,114 resolved relocations), PAL, and all
149 production objects. TEX_SystemEffect1 already comes from maintex.hpp;
the duplicate source extern was removed by 43560dbd before this checkpoint.

Probes: .private/fixes-r0/probes/gyorace-{baseline,inline,inline-global,macro-texture}/
(compile.log, objects.log, and score.log for the two inline forms).
Production receipts: .private/fixes-r0/gyorace-final-{build,objects}.log.
