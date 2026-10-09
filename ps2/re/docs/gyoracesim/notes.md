# gyoracesim notes

Fish race simulation. `sgInitGyoRace` (gyorace) fills `RaceInfo` (0x1F59490, a `grRACE_INFO`),
calls `grGyoRaceSimulate` once (result stored in `time_max`), then the race is replayed with
`grGetFishProgress(&RaceInfo, fish, race_cnt, &prog)`. No class in `class_units.tsv` is owned by
this unit; all types are plain structs. `gyorace.hpp` includes `gyoracesim.hpp` for the complete race and progress types.

## Matching status

Every function in the unit is native; there is no `INCLUDE_ASM`, `NONMATCHING` guard or data
marker. `CollisionFish` and `StepGyoRace` are native together: StepGyoRace's call to
`LaneBattleStep` relies on MWCC knowing that the native `CollisionFish` preserves the fish
argument in `a0`; with an opaque assembly `CollisionFish` the compiler reloads `a0` and
reschedules seven words after the call. `FishModifyParam` needs direct retail disassembly for
its six-way tactics switch, which m2c cannot resolve from the jump table.

## Linkage
- Global: `grGyoRaceSimulate`, `grGetFishProgress`, `rand_prob` (in header).
- Local (static, belong in the .cpp): FishDist, StepFish, LaneBattleStep, CollisionFish,
  StepGyoRace, GetRaceDivision, GetRaceDivisionLength, GetCourseR, FishModifyParam,
  CharacterBonus, RndFishParam, GetPaseRatio, SetRaceFishParam, GetFishData, irn55, init_rnd,
  irnd, rnd, nrnd, GetRandomNumber.
- Retail `StepGyoRace__FP15RACE_FISH_PARAMP11grRACE_INFO` is LOCAL at 0x323270 with declared
  size 0x32C; both source prototypes and the definition use static linkage.
- All data is local: `fish_data` (.rodata 0x3630C0, `static grFISH_DATA[18]`, 0x1F8; the
  payload is the retail table and its final eight alignment bytes carry no extra record),
  `jrand` (.sbss, `static int`, index into `ia`, starts at 0x37 after init), `ia` (.bss,
  `static int ia[56]`, 0xE0; Knuth subtractive generator, modulus 1000000000, 1-based with an
  unused index-zero slot, `ia[55]` = seed). So no externs in header.
- `at_483__2` (.sdata, 8 bytes) = `{-1, -1}` is produced by the local `int[2]` initializer in
  LaneBattleStep (best neighbour per side). `at_1059__3` (.rodata 0x18) is the jump table of
  the 6-case `tactics` switch in FishModifyParam. Both come from the natural source.

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
- `FISH_STATS` (gyoracesim.cpp) is the six-float output buffer passed to `FishModifyParam`.
  `SetRaceFishParam` maps its fifth and sixth floats directly to the race entrant's power and
  aggression fields, so those members use those names.

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

## grFISH_PARAM (0x40) - sources from sgInitGyoRace (game_data entry = CGameDataUsed, fish at +0x10 = BREEDFISH_USED)
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

`grGetFishProgress` copies between the progress record and the sample record, which are
different types, as `*(RaceProgressCopy *) out = *(RaceProgressCopy *) &progress[index]`.

## RACE_FISH_PARAM (0xA0; memset 0xA0, stride 0xA0, grGyoRaceSimulate local array 0x3C0 = 6)
- 0x00 speed[5]: StepFish target = speed[div]*0.0002 + 0.1, times rank_ratio[rank-1] if rank 1..6.
- 0x14 accel[5]: out[0]*ratio[i]/(len_i*10); RndFishParam scales speed[]/accel[] by N(1,0.5), clamp 0.
- 0x28..0x4F: never accessed (only memset).
- 0x50 velocity: v += (accel - (v-target)/0.016 + boost*1.25)*0.0016, min 0.01; past the goal
  v -= 0.01. Initial N(0.02,0.02) clamped 0.
- 0x54 pos: += v*GetCourseR(); goal at >= 16.0 (state set 3 in the record).
- 0x58 lane: int 0..5 (CollisionFish buckets by it into 6 lanes).
- 0x5C state s8 (1 init, 2 push, back to 1), 0x5D battle u8 (1 during push).
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

## Race state signedness

Every read of `grRACE_PROGRESS::state` in gyorace and gyoracesim is an
unsigned byte load, so the field is `u8` and its comparisons need no cast.
`RACE_FISH_PARAM::state` stays `s8`: StepFish copies it into the record
with a signed load (`lb`), while the battle tests in LaneBattleStep load it
with `lbu` and keep their `(u_char)` reads. `RaceProgressCopy::state` also
stays `s8`, because grGetFishProgress's record copy loads the byte signed.
Making all three fields `u8` changes grGetFishProgress and StepFish on those loads.

## CollisionFish and StepGyoRace source forms

`CollisionFish` sorts the fish by `pos - velocity`, buckets them by lane into `int
lane_fish[6][6]` / `int lane_count[6]`, then walks each lane keeping every following fish at
least 0.05f behind the one ahead. `StepGyoRace` clears the ranks and goal times, records the
first completed step of each fish as a fractional goal time, assigns a current rank by position
each step, resolves collisions and lane battles, then assigns final ranks by goal time. It
records up to `after_goal_step + 1` further steps and returns the next step index.

Both matches depend on C-style variable sharing across disjoint loops:

- In `CollisionFish` one `int j`, declared after `old_index`, is shared by the sorting inner
  loop and the final lane loop's inner index; one `RACE_FISH_PARAM *current`, declared at
  function level, takes `&fish[index]` in the lane-bucket loop to read the lane and is reused
  as the following fish in the final lane loop; the lane loop reuses `i` as its counter
  (`for (i = 0; i < 6; ++i)`). `ahead` stays scoped to the lane loop.
- In `StepGyoRace` `int i, j;` is at function level and one `j` is shared by the opening
  rank/goal-time clear loop and both inner rank loops; the final rank loop compares `i != j`
  directly, with no extra local, unsigned counter or cast.

Declaring these per loop (a block-scoped `j`, a separate `behind` pointer, `i` in the opening
clear loop) leaves the operations identical but permutes the registers of the final loops.
This is the MWCC trait docs/MWCC.md describes under "Register allocation": extra webs of a
reused variable are numbered below single-web locals and the optimizer's induction and
invariant temporaries, so they colour after them. Retail's lane loop (inner offset `a3`, row
offset `t0`, count offset `t1`, row base `t2`, lane counter `t3`, inner index `t4`, ahead
pointer `a2`) needs the counter, inner index and following-fish pointer all numbered below the
row-base invariant with the counter above the other two; a fresh `lane_no` at any declaration
point is numbered above every temporary and takes `a3`. A carried preceding position or entrant
index instead of the preceding fish pointer, or a repeated `fish[lane_fish[i][j]]` expression,
exceeds the 0x5A0 retail extent. The final lane loop has no call consuming its binary32 0.05f
separation distance, so no floating-argument selector applies to it. Loop form (`for`/`while`),
increment style and comparison direction do not change the allocation; narrower counters and
scoping `old_index` to its swap block introduce other differences.

## MWCC register allocator

- Simplify scans nodes in increasing virtual-register number and pushes any node whose current
  degree is below the class budget `K` (25 for GPRs); neighbours' degrees drop immediately (by
  two for paired registers). Passes repeat until nothing is pushed. When no node is below `K`,
  the node with the smallest `cost / current degree` (reverse scan order, strictly smaller wins)
  is pushed as the spill choice and simplify resumes.
- Colouring pops the stack, so later pushes are coloured first, and assigns the first free
  register in the order `v0 v1 a0-a3 t0-t7 t8 t9 s0-s7`.
- Virtual-register numbering in these functions, highest first: single-web user locals
  (reverse declaration order), strength-reduced induction temporaries, hoisted invariants such
  as the lane row base, then extra webs of reused variables. Extra webs are numbered per
  variable in program order; `j`'s webs precede `i`'s once `j` is used before `i`.

## Satan's Fiddle profile rows

The unit uses GPR helper mask 0x30 / FPR 0; GPR 0x10 introduces a byte difference in
`LaneBattleStep`.

- `CharacterBonus__FP12grFISH_PARAMP15RACE_FISH_PARAMi` (0x323E90) needs binary32 `0.01f`
  (`0x3C23D70A`) evaluated before `1.0f` in the random-bonus call. Selecting `0.01f` alone would
  also reorder the earlier `GetRandomNumber(0.0f, 0.01f)` calls, so the profile sets
  `evaluate_first` for both `0x3C23D70A` and `0x00000000` in this function; the earlier calls
  keep their retail order while the later call materializes `0.01f` before `1.0f`. Each
  selector applies to all matching constants, independent of visitation order.
- `FishModifyParam__FP12grFISH_PARAMPff` (0x323710) has two callee-scoped
  `GetRandomNumber__Fff` evaluate-first rows, each asserting `expected_matches: 1`: binary32
  0.2f (`0x3e4ccccd`) with `control: {kind: switch, values: [1]}`, which orders tactics 1's
  range before its mean without touching tactics 2 or 4 (they take the same constant), and
  binary32 0.3f (`0x3e99999a`), which orders tactics 5's range before its 1.3f mean. Retail
  prepares `f13` before `f12` at those two calls. The `nested_call`/`nested_variable` selectors
  need a sibling call inside the argument list and do not apply to these direct-constant calls;
  the switch-context selector distinguishes the tactics-1 call from the identical constants in
  tactics 2 and 4. Double range locals exceed the 0x780 extent.

## FishModifyParam source forms

The function builds the six race-statistic outputs from the entrant's attributes, species,
name-seeded random variation and selected tactics. The RNG state and the name-hash accumulator
share their initial value through `u32 seed = random.seed = 1`; the name hash then reseeds the
generator before its 1,000-step warm-up. This preserves retail's initial seed store. Deleting
that store moves `strlen` and changes the body; aggregate initialization emits extra constant
data; an explicit field read (`random.seed = 1; u32 seed = random.seed;`) emits a stack reload;
hashing through a seed reference or the generator field exceeds the 0x780 extent. Separate
initializations of the two values also match. No unused float declarations remain.

The `GetRandomNumber` constant spellings are part of the match: tactics 0 passes
`(float(1.0), 0.1f)`, tactics 1 `(1.0, 0.2)` as double literals, tactics 2 `(1.5f, 0.2f)`,
tactics 3 `(1.8f, 0.4)`, tactics 4 `((float)1.0, 0.2f)`, tactics 5 `(mean, float(0.3))`, and
the aggression base `(float(0.5), float(0.5))`.

## First game
No equivalent in Dark Cloud 1 (no fish race).
