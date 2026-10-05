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
`+0` CScene*; `+4` is the first texture block number for fish characters (`CharaTexb = info->unk_4`).

## Global data (non-local -> extern in header)
| Symbol | Type | Evidence |
|---|---|---|
| `fish_name` 0x362150 | `char*[18]` | .data words -> strings ("f1a.chr"...); index `species(+2 of CGameDataUsed) - 0x140`, negative -> 0x11. Two zero words follow (align pad before cam_pos) |
| `cam_pos` 0x3621A0 | `sceVu0FVECTOR[5]` | 0x50 bytes, w=1.0; stride 0x10 in AutoCam |
| `race_cnt` | float | `= 0.0`, `+= 0.1` per frame in modes 2/3 |
| `race_proc_cnt` | int | frame counter; 0x4B (mode 0), 0xF (mode 1), 0x78 (mode 3, fade out at 0x1E) |
| `race_mode` | int (`GYORACE_MODE`) | switch 0..5 in sgLoop. Mode 4 is never set in this unit (goal view from camera (270,-40,-10)/(192,0,0), back to 3) |
| `time_max` | int | `sw $v0` of `grGyoRaceSimulate` (which tail-returns StepGyoRace's value) |
| `camera_id` | int | `CScene::AssignCamera` result; written to `scene+0x2E54` (old in `+0x2E58`). Symbol 4 bytes; BSS slot 8 (pad) |
| `race_rank` | int[2] | [0]=GetGyoRaceClass, [1]=GetGyoRaceNo; symbol size 8 |
| `gyo_mes` | ClsMes* | `new(Alloc(0x298)) ClsMes` (0x2958) ; inlined ClsMes init follows the ctor |
| `fish_game_data` | `GYORACE_RESULT[6]` | 0xD8 = 6*0x24; written in sgLoop mode 5 at index rank-1; read by event_func `_SET_GYORACE_ETC` (name +0, time +0x18) and sgInit (+0x1C/+0x20 for races already run) |
| `RaceInfo` | `grRACE_INFO` (gyoracesim) | 0x1DC; incomplete here |
| `old_prog` | `grRACE_PROGRESS[6]` (0x90, stride 0x18) | **not declared in header**: grRACE_PROGRESS is gyoracesim's and gyoracesim.hpp does not exist yet, and an extern array of an incomplete type does not compile. Add `extern grRACE_PROGRESS old_prog[6];` with `#include "gyoracesim.hpp"` once it exists |
| `camera0` | mgCCamera (0x70) | ctor in __sinit; `mgCCamera` methods called on it |
| `fish_inf` | `GYORACE_FISH_INF[6]` | 0x108 = 6*0x2C |

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

## C++ draft and promotion status (2026-10-06)

All eight ASM-backed runtime functions have typed C++ drafts guarded by `NONMATCHING`.
`sgMapDrawGyoRace` is already matched. The compiler-generated initializer matches when the
guarded globals are compiled, but default promotion is blocked: the object compiler emits
`__sinit_gyorace.cpp`, whereas the retail constructor table references
`__sinit_gyorace_cpp`. The retail initializer remains the default assembly implementation.

The eight runtime drafts all differ from retail. Each received one isolated promotion
attempt; each trial failed to compile because the trial deliberately enabled only that
function while its dependent includes and locally owned globals remained guarded.
The guarded unit itself compiles, and the default full build verifies byte-identical.

The initializer, race loop and race display drafts currently model their principal
state transitions and typed data flow. They do not yet cover every resource load,
animation update, screen primitive or commentary branch in retail. In particular,
`sgInitGyoRace` and `sgSysDrawGyoRace` are substantially shorter than the retail code.
These remain analysis and matching gaps, not promoted functions.
