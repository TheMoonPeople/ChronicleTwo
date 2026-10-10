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
| `DivSpriteScreen(mgCDrawPrim&)` | **LOCAL** (`__2` suffix) | void | static, belongs in .cpp; not in header. Uses the file-scope statics `ras_off_1762` (float) and `init_1763` (signed char) and the two zero vector templates `at_1775`/`at_1776` (local 0x10 bss). Underwater raster wobble |
| `sgEffectDrawGyoRace` | global | int | only when `water_cam` |
| `sgSysDrawGyoRace` | global | int | function-local statics `lap_inf[2][5]` (h, m/10, m%10, cs/10, cs%10 per lap) and `lap_inf2[5]` (total time digits) |
| `Jikkyou(SubGameInfo*)` | global | int | -1 while race_cnt<=0 or mes_count>0, else 0 |
| `__sinit_gyorace_cpp` | - | - | `BuffTextureData.Init()`, `BuffWorkData.Init()`, `camera0 = mgCCamera(8.0f)` |

## Matching status

All ten functions are native and exact. The only remaining markers are the two
`INCLUDE_BSS` zero vector templates `at_1775`/`at_1776` that `DivSpriteScreen` copies (see
"Retained data markers").

## SubGameInfo (subgame.hpp, not owned here)
`+0` CScene*; `+4` is the first texture block number for fish characters (`CharaTexb = info->texb`).

## Global data (non-local -> extern in header)
| Symbol | Type | Evidence |
|---|---|---|
| `fish_name` 0x362150 | `char*[18]` | .data words -> strings ("f1a.chr"...); index `species(+2 of CGameDataUsed) - 0x140`, negative -> 0x11. The compiler emits the 18 string objects; the eight bytes before `cam_pos` are alignment padding, not extra entries |
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
`cam_pos[camera]` lookup and the named scene field are required; a byte-offset
write to the scene changes the generated code.

Local (static, stay in .cpp): old_cam_no (.sdata, int = -1), gyore_snd_id, rank_count, EffectTex,
EffectTex2, wind_tex (mgCTexture* 0x37E7D8, the window/time-digit atlas), hero_no, water_cam
(bool/char, symbol size 1), cam_no, win_alpha (float, 128.0 reset, -0.5/frame), effect_cnt
(0..0x5F ring), mes_count, jyunkai_flg, hantei_flg, goal_cnt, battle_effect (CHitEffectImage*,
0x60 entries via __construct_new_array, size 0x60), battle_EffectPara (0x3C000 bytes; arrays of
32 BattleEffectPrim per effect, 0xA00 per effect at effect+0x20, +0x2C = 0x20), CharaTexb,
WindowTexb (int 0x37E820, the atlas texture block), EffectTexb, fish_rank (int[6]: fish index by
place), old_fish_rank (int[6]), game_data (CGameDataUsed*[6]: [0] = player's fish or omake fish;
retail symbol size 0x18 at 0x1F59740, the 0x20-byte reservation includes eight alignment bytes),
old_ambient (float[4]), BuffTextureData / BuffWorkData (mgCMemory, 0x30).
Note `old_prog[rank + 0x23]` in Ghidra is really `fish_rank[rank - 1]`; `D_01F5971C + i*4` is
`old_fish_rank[i - 1]`.

`fish_rank` and `old_fish_rank` have 24-byte extents at 0x1F59700 and 0x1F59720 with 16-byte
section alignment, so the eight-byte gap between them is compiler alignment. Retail Jikkyou
addresses `old_fish_rank - 4` (the gap's last word, `D_01F5971C`) with a -4 addend; no filler
object exists for it.

`BuffTextureData` is a LOCAL `mgCMemory` at 0x1F59770 (size 0x30) holding the commentary buffer
and loaded texture resources. `BuffWorkData` is this unit's own LOCAL `mgCMemory`, distinct from
the same-named dungeon object; `dng_main.hpp` is not included. Construction order is Texture,
Work, then `camera0`.

## GYORACE_FISH_INF (0x2C, neutral name)
| Off | Field | Evidence |
|---|---|---|
| 0x00 | lane | = start lane (0..5, rotating from a random start); same value stored in RaceInfo fish +0x3C (RaceInfo+0x48+i*0x40), shown as +1 in commentary (`gyo_mes+0x21BC`), progress bar y = lane*10+35 |
| 0x04 | chara_no | 0x40+i; GetCharacter/LoadChara/SetActive/DrawChara |
| 0x08 | fish_no | -1 or index passed to `CGyoraceFishData::GetRaceFish`; copied to result +0x1C |
| 0x0C | rank | computed per frame from progress (+1 per fish ahead or already goaled); used for place sprite x = rank*0x18 |
| 0x10 | lap | u32 (`fptoui(pos/8)`, unsigned compare); 2 laps of 8 course units |
| 0x14 | unk_14 | written 0 by sgInit, set to 1 entering lap 1 (with `lap_start`), never read |
| 0x18 | lap_start | race_cnt on entering lap 1 |
| 0x1C | unk_1c | never accessed in this unit |
| 0x20 | time | race_cnt*20 (or goal time*20 from RaceInfo+0x1C4[i]) for hero_no only |
| 0x24 | lap_time[2] | [lap] = time - lap_start*20; at goal [1] = time - rounded [0] |
Time units: displayed as `t/3600` min, `(t%3600)/60` s, `rem*100/60` hundredths -> sixtieths of a second.

## GYORACE_RESULT (0x24, neutral name)
`+0 char name[0x18]` (blanked with 18 spaces then strncpy of CGameDataUsed+0x10 name), `+0x18 float time`,
`+0x1C int fish_no`, `+0x20 int race_class` (race_rank[0]).

## grRACE_INFO layout seen from here
`+0` seed (0 -> derived), `+8` fish count = 6; fish entries at `+0xC`, stride 0x40, 6 entries:
`+0 char name[0x18]` (CGameDataUsed+0x10), `+0x18` species (s16 +2), `+0x1C` (u8 +0x4A), `+0x20` (u8 +0x26,
also commentary message base: MakeMesWin(+0x20 + 9/0xD/0x11/0x15)), `+0x24` (u16 +0x3E), `+0x28` (u16 +0x3C, player
fish reduced by tiredness `+0x34`: `v - (t-1)*0.1*v`), `+0x2C` (+0x36), `+0x30` (+0x38), `+0x34` (+0x3A),
`+0x38` operation/tactics (printf "Operation=%d"), `+0x3C` lane. `+0x18C` = 1000, `+0x190` 6 pointers to
24000-byte buffers, `+0x1A8` = 0x14, `+0x1AC int[6]` final place per fish, `+0x1C4 float[6]` goal time.
grRACE_PROGRESS (0x18): `+0` float course position (0..16, 8 per lap), `+8` float lateral lane position
(x = v*15+190), `+0xC` char state (2 = battle splash, 3 = goaled).

`BREEDFISH_USED::fatigue` is `u16`: retail loads the player's fatigue increment with `lhu` and
reads the stamina minuend unsigned.

## Race initialization (`sgInitGyoRace`)

The function loads the race sound bank (`snd2/mon/EN_902.snd`), the localized commentary
(`/sg/gyo/`, `gyore%d.mes`), simulation fish data, splash work arrays and character models.
Six entrants are chosen without reusing generated fish numbers; later races can retain earlier
finishers. The simulation receives a zero seed, 1,000 progress entries per entrant and 20
after-goal steps. Parameters come from `BREEDFISH_USED`, with fatigue reducing the player's
stamina. The chosen lanes cycle through 0..5. Character setup loads one texture block per
entrant, clamps size scaling to 2.0, positions the models at their lane starts and selects the
swim motion. Allocator counts are the actual object/array sizes rounded to quadwords plus the
allocator's two-quadword overhead. The texture-buffer quadword walk follows the serialized
message-file size, not an object-field offset.

Source forms the match depends on:

- The duplicate-scan index also holds the selected generated fish number; one `int selection`
  names both roles. In the ordinary-entrant branch it is scoped to that branch, while the Omake
  scan's `selection` is declared inside its own retry loop. This gives retail's `a0` counter /
  `a1` induction pair.
- `fish_inf[fish].fish_no = selection` is stored directly, with no slot pointer.
- The parameter loop indexes `RaceInfo.fish[racer]` directly, with no `grRACE_INFO *entry`
  local; retail computes the row address after the tactics branches and keeps it live through
  the parameter stores. The name is a real `char *name` local (a separate stack spill).
- `BREEDFISH_USED *data` is reassigned after the fatigue update and supplies the stamina
  minuend. Retail keeps the game-item pointer and the refreshed fish-data address separately
  and reloads stamina through the latter; the reuse creates that later live range without a
  dummy local or type change. A fresh alias lets MWCC merge the two stamina loads.
- The character scale obtains its fish-data pointer directly from `*item` and uses that slot
  for the breed lookup. Retail keeps only the derived fish-data pointer in `s8` across the
  call, with the game-item load in `v0`.
- `int *character_no = &state->chara_no` stays: direct `state->chara_no` reads change the
  reload/register lifetimes after `LoadChara`.
- `int id = camera_id` is read before `before_camera` is saved: retail loads the global
  before the scene field, and reading `camera_id` afterwards changes the code.
- The loaded `u_long128` file buffers are passed to `sndLoadSound`, `LoadChara`
  (`unsigned int *`) and `EnterIMGFile` (`unsigned char *`) through casts; the parameter types
  are part of those functions' mangled names.
- The position `{0, -15, 0, 1}` and rotation `{0, 3.1415927f, 0, 1}` locals are SDK
  `sceVu0FVECTOR` initializers at their declaration sites; they supply the two 0x10-byte
  templates at 0x3621F0 and 0x362200 without markers.
- `sprintf(image_path, "grttex_new6.img", LanguageCode)` is a retail quirk: the format has no
  conversion but the argument is passed.
- `image->kind = HIT_EFFECT_BOARD`, `SetActive(SCENE_DATA_CHARA, ...)` /
  `ResetActive(SCENE_DATA_CHARA, 0)` and `LanguageCode > LANG_JAPANESE` use their owning enums.
  `AssignStack(5)`/`GetStack(5)` and `sndSeAllStop(2)` have no enumerator.

Profile: the Satan's Fiddle profile has two rows for this function, selecting binary32 zero
as evaluate-first for `SetRef__9mgCCameraFfff` and `SetNextRef__9mgCCameraFfff` (two
matches each). Retail transfers zero to `f13` before materializing 222 in both terminal
camera reference calls; other camera callees keep their ordinary schedule.

## Race loop (`sgLoopGyoRace`)

The loop replays simulated progress, computes places, updates lap timing, maps each fish onto
the two straight sections and circular course ends, spawns splash effects and updates the
tracking camera. Completed races save the ordered fish results and restore the ambient
lighting and scene state. The compiler emits the six-case switch jump table `at_1703`; its
targets are loop offsets 0x68, 0x2B4, 0x4B8, 0x4B8, 0x1028 and 0x1598.

- The splash rectangle is set through `CHitEffectImage::SetTexRect`, an inline member taking
  `mgRect<int>` by value. Retail copies the constructed rectangle into a second 16-byte
  aligned argument temporary (`lq`/`sq`) before storing its four edges, and reserves a 0x3F0
  frame. Plain assignment (the implicit reference `operator=`) and named-local copies are
  folded and give a 0x3E0 frame without the copy. A general by-value `mgRect::operator=`
  changes other matched units and is rejected (see the shared assignment evaluation).
- Six camera/splash argument orders use exact `sgLoopGyoRace` floating-expression rows in
  `scripts/build/satansfiddle.json`. These are the ready mode's `SetNextRef` zero before 222
  (switch value 0, two sites); mode 1's `SetPos`/`SetNextPos` Z (168) first; mode 4's
  `SetPos`/`SetNextPos` Z (-10) after X but before Y; and the non-battle splash gravity
  `-0.1f` (selected by its sibling spread argument 10.0f). Retail materializes that gravity
  into `$f20` before the `mgDistVector`/`fptosi` calls. Literal, double, local and
  negated-local gravity forms are folded or leave an unfolded `neg.s`.
- The motion, gate part/piece/frame names, blank result name and result diagnostic are
  inline string literals. The direction, rotation, ambient-colour and camera-position
  templates are `RaceVector` local initializers that the compiler emits as `.data` templates.

Source forms the match depends on:

- The hero's time is stored and read through one `float *total` declared before the goal
  test and assigned `&state->time` in each branch. With two definitions it is not
  forward-substituted: the normal branch stores the running time and reads it back through
  the pointer (retail's store to `32(s3)` and reload); the goal branch stores the total
  directly and assigns the pointer afterwards, so the address follows the `RaceInfo` base and
  `20.0f` in emission order (retail's `v1`/`v0` pair and `s7`). A single-definition pointer is
  propagated and the reload disappears.
- The rounded second-lap calculation ends each of its three conversions in its own statement
  through one reused `int count`; the following `3600.0f * count` then emits the constant
  before the `mtc1`, so both constants interfere with `v0` and take retail's `a2`/`v1`. This
  is the pre-allocation list-scheduler behaviour recorded in docs/MWCC.md.
- The fish loop reads the character number as `fish_inf[fish].chara_no`, not through
  `state`: fish in `s1`, character in `s2`, goal-time induction offset in `s4`.
- `float angle = atan2f(...)` as its own statement emits `atan2f`'s second argument first,
  the first in the delay slot, and `0.034906585f` before `rotation[1]` is reloaded; the nested
  call reverses both orders.
- The motion names, part/frame names and format strings are the retail string literals
  (`INCLUDE_RODATA` symbols) declared `char[]` and passed uncast, so they are simple address
  arguments evaluated after the computed ones. Casting `const unsigned char` arrays makes each
  name a computed argument evaluated in source order.

## Race display (`sgSysDrawGyoRace`)

The function draws the commentary window, the six-lane progress bar, the hero's place sprite,
the per-lap digit rows and the total time. Source forms the match depends on:

- The lane's vertical bar position is computed before the draw arguments are passed, which
  reproduces retail's float scheduling.
- The lap-display comparison `(int) fish_inf[hero_no].lap < lap_no` is signed (`slt`) despite
  the stored unsigned lap number.
- The lap loop uses one fresh `int lap_no` as both counter and row index of `lap_inf`,
  increments it after the two coordinate offsets (`lap_y`, `lap_x`), and is a `do`/`while`;
  `for` or incrementing first changes the row-offset order. In retail the counter is a fresh
  local and the row address is a load CSE temporary, so `lap_inf[lap_no][n]` is indexed
  directly with no row pointer. Reusing a split-web counter or a fresh row pointer swaps
  `s0`/`s4`.
- The lap number is assigned inside the subscript
  (`lap_time[lap = fish_inf[hero_no].lap]`); a separate statement changes the code.
- Generic `i`, `j` and `k` are reused: `i` counts the fish and then holds the lap minutes,
  `j`/`k` are the ready-mode row offsets and then the lap seconds and hundredths. Distinct
  minute/second/hundredth locals change the allocation. `row = 0` sits inside the ready-mode
  branch.
- Each sprite is written as a block with two `mgRect<int>` locals (`screen`, `texture`),
  `Set` and `PrimQuad`, in source order, with the progress record declared just before the
  fish loop so the stack order follows retail. Passing `mgRect<int>(...)` temporaries as
  arguments builds them right to left after the named locals. A static inline function taking
  the atlas texture and nine integers grows the function (0x1244 to 0x1304), and one reading
  `wind_tex` directly still grows it to 0x1274; neither preserves the call-site layout.
- `lap_inf[2][5]` and `lap_inf2[5]` are function-local statics (retail symbol sizes 0x28 and
  0x14; the larger BSS extents after them are following storage/alignment) and `"grt1"` is an
  inline literal shared with `sgInitGyoRace`.
- `(sceVif1Packet *) NULL` selects the `ReloadTexture` overload.

## Underwater raster (`DivSpriteScreen`)

The helper splits the screen into strips and wobbles their texture coordinates through a
rotating step vector. `ras_off_1762` (float phase) and `init_1763` (signed char) are file-scope
statics under their retail symbols; a natural function-static `float ras_off = 0.0f`
reproduces the image but emits anonymous small-BSS identities under different names.
`int origin[4] = {mgScreenOffx << 4, mgScreenOffy << 4, 0, 0}` supplies the anonymous 16-byte
zero template `at_1765__2`, and `float step[4] = {0, 0, 0, 1}` supplies `at_1766__3`.
`uv = *(RaceVector *) origin` is a quadword copy of the origin vector: the array's initialiser
loads a constant quadword template before patching in the screen offsets, and a `RaceVector`
filled field by field stores the offsets directly and reorders the function's opening.

## Retained data markers

- `INCLUDE_BSS(at_1775, 0x10)` / `INCLUDE_BSS(at_1776, 0x10)` with `extern RaceVector
  at_1775/at_1776`: the two zero vector templates `DivSpriteScreen` copies into `uv` and `xy`.
  SDK integer-vector zero initializers with a memcpy of the origin, or a typed aggregate
  containing an SDK integer vector with ordinary value assignment, change the strip helper and
  the linked unit initializer, so the markers stay. Both are under `#ifndef NONMATCHING`.

Strings supplied inline by the native functions (no markers): `snd2/mon/EN_902.snd`,
`/sg/gyo/`, `gyore%d.mes`, the seed/fatigue/entrant diagnostics, `info.cfg`,
`grttex_new6_%d.img`, `grttex_new6.img`, `grt_moji` and `grt1`.

## Unresolved
- Retail names of the two structs (neutral names chosen).
- Enum names for `GYORACE_MODE` are neutral.
