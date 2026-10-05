# gyoracesim notes

Fish race simulation. `sgInitGyoRace` (gyorace) fills `RaceInfo` (0x1F59490, a `grRACE_INFO`),
calls `grGyoRaceSimulate` once (result stored in `time_max`), then the race is replayed with
`grGetFishProgress(&RaceInfo, fish, race_cnt, &prog)`. No class in `class_units.tsv` is owned by
this unit; all types are plain structs. `gyorace.hpp` only forward-declares `grRACE_INFO` /
`grRACE_PROGRESS`; it will need `#include "gyoracesim.hpp"` once gyorace's bodies use the fields.

## Linkage
- Global: `grGyoRaceSimulate`, `grGetFishProgress`, `rand_prob` (in header).
- Local (static, belong in the .cpp): FishDist, StepFish, LaneBattleStep, CollisionFish,
  StepGyoRace, GetRaceDivision, GetRaceDivisionLength, GetCourseR, FishModifyParam,
  CharacterBonus, RndFishParam, GetPaseRatio, SetRaceFishParam, GetFishData, irn55, init_rnd,
  irnd, rnd, nrnd, GetRandomNumber.
- All data is local: `fish_data` (.rodata 0x3630C0, `grFISH_DATA[18]`, 0x1F8), `jrand` (.sbss,
  int, index into `ia`, starts at 0x37 after init), `ia` (.bss, `int ia[56]`, 0xE0; Knuth
  subtractive generator, modulus 1000000000, 1-based, `ia[55]` = seed). So no externs in header.
- `at_483__2` (.sdata, 8 bytes) = `{-1, -1}` initialiser of a local `int[2]` in LaneBattleStep
  (best neighbour per side). `at_1059__3` (.rodata 0x18) = jump table of the 6-case `tactics`
  switch in FishModifyParam.

## Signatures / return types
- `grGyoRaceSimulate` returns StepGyoRace's int (v0 untouched before `jr`; stored as time_max).
- `grGetFishProgress` int 0/1. `StepFish(int step, RACE_FISH_PARAM*)` int: 1 when finished or
  no record. `StepGyoRace` int = last step index + after-goal steps. `GetRaceDivision(float)` int
  0..4, -1 at/after 16. `GetRaceDivisionLength(int)` float: <0 -> 0, 0/4 -> 2, else 4 (course
  divisions 0-2, 2-6, 6-10, 10-14, 14-16). `GetCourseR(float pos, float lane)` float, always 1.0
  (computes `(int)` something & 7 but every branch gives 1.0). `FishDist` float =
  (a.pos+a.velocity) - (b.pos+b.velocity). `GetFishData(int fish_no)` grFISH_DATA* or null.
  `GetPaseRatio(int tactics, float out[5])` sets all to 1/5. `rnd()` float = irnd()/1e9;
  `nrnd()` = sum of 12 rnd() - 6; `GetRandomNumber(float mean, float range)` = mean +
  nrnd()*(range/3); `rand_prob(int pct)` = ((irnd()>>12) % 100) < pct.

## grRACE_INFO (0x1DC; RaceInfo symbol size 0x1DC, memset 0x1DC in sgInitGyoRace)
- 0x000 seed u32: 0 -> seed is a CRandom-LCG (x*0x5D588B65+1, start 0x3526D02F) hash of each
  entrant's name chars and the ten ints 0x18..0x3C; sgInitGyoRace writes 0.
- 0x004 unk_4: never seen.
- 0x008 fish_num: loop bound everywhere; sgInit writes 6.
- 0x00C grFISH_PARAM fish[6]: stride 0x40 (strlen at +0xC, ints +0x24..+0x48 per entrant;
  SetRaceFishParam copies 0x40 bytes as 8 dword pairs = struct copy).
- 0x18C step_max: sgInit writes 1000; progress buffers are `new[] 24000` = 1000*0x18.
- 0x190 grRACE_PROGRESS* progress[6]: memset `step_max*0x18` in SetRaceFishParam.
- 0x1A8 after_goal_step: sgInit writes 0x14; StepGyoRace steps that many more after all goal.
- 0x1AC int rank[6]: StepGyoRace, 1 + number of fish with smaller goal_time.
- 0x1C4 float goal_time[6]: step - (pos-16)/velocity when StepFish first returns 1. gyorace
  reads `RaceInfo+0x1C4+rank*4`.

## grFISH_PARAM (0x40) — sources from sgInitGyoRace (game_data entry = CGameDataUsed, fish at +0x10 = BREEDFISH_USED)
- 0x00 name[0x18]: strcpy of fish name.
- 0x18 fish_no: CGameDataUsed.item_no (s16 +2); key of GetFishData.
- 0x1C affinity: BREEDFISH_USED.unk_3a (byte); equal to grFISH_DATA.affinity -> all x1.1.
  Name is mine; real meaning unknown.
- 0x20 bonus_type: BREEDFISH_USED.unk_16 (byte); CharacterBonus switch (0..3), see enum.
- 0x24 power: param[4] -> FishModifyParam out[4] -> RACE_FISH_PARAM.power (battle strength diff).
- 0x28 stamina: param[3], reduced by (n-1)*10% where n = BREEDFISH fatigue counter (+1 per race
  for the player's fish). Becomes out[0], shared out by GetPaseRatio over divisions into accel[].
  "stamina" is an inferred name.
- 0x2C/0x30/0x34 speed[3]: param[0..2] -> out[1..3] -> speed[0], speed[2], speed[4]; speed[1] =
  (s0 + s1/2)/1.5, speed[3] = (s2 + s1/2)/1.5. The four ints 0x28..0x34 of all entrants are
  averaged (sum / (n*4)) as the nrnd scale in FishModifyParam.
- 0x38 tactics: GetGyoRaceAquariumNo() for the player's fish / random 0..5 / GetOmakeGyoracerTactics;
  FishModifyParam switch 0..5 adjusts out[1..3] and out[5] (aggression). No enum (meanings only
  numeric tweaks): 0 aggr-0.5, x N(1,0.1); 1 x N(1,0.2); 2 aggr-0.3, s0 x N(1.5,.2), s1 x.873,
  s2 x.5; 3 aggr+0.2, s0,s1 x.8, s2 x N(1.8,.4); 4 aggr+0.5, x N(1,.2); 5 aggr+0.1, s1 x N(1.3,.3).
- 0x3C lane: written by sgInit (0..5 rotation).

## grRACE_PROGRESS (0x18; stride 0x18, old_prog 0x90 = 6 entries)
0 pos f, 4 lane int (sgInit: `lane*15+190`), 8 lane_pos f (StepFish writes (float)lane;
interpolated by grGetFishProgress with pos), 0xC state u8 (0 => grGetFishProgress returns 0;
Jikkyou tests ==2 for push commentary), 0xD battle u8, 0xE pad, 0x10 battle_target int,
0x14 battle_hits int (copied from RACE_FISH_PARAM 0x60/0x64).

## RACE_FISH_PARAM (0xA0; memset 0xA0, stride 0xA0, grGyoRaceSimulate local array 0x3C0 = 6)
- 0x00 speed[5]: StepFish target = speed[div]*0.0002 + 0.1, times rank_ratio[rank-1] if rank 1..6.
- 0x14 accel[5]: out[0]*ratio[i]/(len_i*10); RndFishParam scales speed[]/accel[] by N(1,0.5), clamp 0.
- 0x28..0x4F: never accessed (only memset).
- 0x50 velocity: v += (accel - (v-target)/0.016 + boost*1.25)*0.0016, min 0.01; past the goal
  v -= 0.01. Initial N(0.02,0.02) clamped 0.
- 0x54 pos: += v*GetCourseR(); goal at >= 16.0 (state set 3 in the record).
- 0x58 lane: int 0..5 (CollisionFish buckets by it into 6 lanes).
- 0x5C state u8 (1 init, 2 push, back to 1), 0x5D battle u8 (1 during push).
- 0x60 battle_target, 0x64 battle_hits (incremented on rand_prob win), 0x68 power (out[4]),
  0x6C aggression (out[5]), 0x70 battle_urge (+= aggression*crowd, >1 starts push),
  0x74 battle_time (set 5.0, -1 per step), 0x78 boost (clamped +-1, decays 0.05/step; push winner
  +0.5, loser -0.25), 0x7C rank (1 + number of fish ahead, StepGyoRace).
- 0x80 rank_ratio[6]: CharacterBonus, linear from first to last place; [0] forced 1.0.
- 0x98 progress_num (= step_max), 0x9C progress (= info->progress[i]).

## grFISH_DATA (0x1C; fish_data 0x1F8 / 18 rows; GetFishData stride 0x1C, loop 0x12)
int fish_no (0x136, 0x140..0x150), float power% (+4 -> 0x24), stamina% (+8 -> 0x28),
speed%[3] (+0xC..0x14 -> 0x2C..0x34), int affinity (+0x18). Type name is not retail (none known).

## Enums
- grRACE_STATE (0..3) from StepFish (3 at goal), SetRaceFishParam (1), LaneBattleStep (2/1),
  grGetFishProgress (0 = no record). Names mine.
- grCHARA_BONUS_TYPE from CharacterBonus: 0 first=1+|x|, last=1-|x|; 1 first=1-0.2|x|,
  last=1+|x|; 2 both 1; 3 both N(1,0.01); x = N(0,0.01). Names mine.

## First game
No equivalent in Dark Cloud 1 (no fish race).

## C++ draft status
- `GetPaseRatio`, `GetFishData`, and `rnd` compile with byte-identical MWCC output.
- `GetRaceDivisionLength`, `GetCourseR`, `irn55`, `init_rnd`, `irnd`, `nrnd`,
  `GetRandomNumber`, and `rand_prob` have typed C++ drafts under `NONMATCHING`.
  Their first promotion attempts did not match, so the default build keeps their
  retail assembly.
- The generator draft uses the documented 56-element state array. Its first
  promotion attempt reached 95.71% for `init_rnd`, but that is not an exact match.
- Typed `NONMATCHING` drafts now cover all remaining race functions: the seed
  hash and simulation entry, progress interpolation, fish stepping, collision
  ordering, lane battles, division setup, figure modification, character
  bonus, and parameter randomization. `FishModifyParam` needed direct assembly
  analysis because m2c could not resolve its six-way tactics jump table.
- `RndFishParam` matched byte for byte and passed isolated whole-image
  promotion. The remaining new drafts failed their first isolated promotion
  and retain retail assembly in the default build. The full default build
  remained byte-identical after the promotion.
