# gyoracesim notes

Fish race simulation. `sgInitGyoRace` (gyorace) fills `RaceInfo` (0x1F59490, a `grRACE_INFO`),
calls `grGyoRaceSimulate` once (result stored in `time_max`), then the race is replayed with
`grGetFishProgress(&RaceInfo, fish, race_cnt, &prog)`. No class in `class_units.tsv` is owned by
this unit; all types are plain structs. `gyorace.hpp` includes `gyoracesim.hpp` for the complete race and progress types.

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

## First game
No equivalent in Dark Cloud 1 (no fish race).

## Current matching status (2026-10-08)

Twenty-two functions are source supplied. `CollisionFish` and `StepGyoRace`
are native and exact (see [night-20261008.md](night-20261008.md));
`FishModifyParam` retains its guarded typed draft and retail assembly in the
default build.

FishModifyParam still needs direct retail assembly analysis because m2c
cannot resolve its six-way tactics jump table.

## StepGyoRace draft
`StepGyoRace` records the first completed step of each fish as a fractional goal time, assigns a current rank by position each step, resolves collisions and lane battles, then assigns final ranks by goal time. It records up to `after_goal_step + 1` further steps and returns the next step index. It matches all 204 retail instruction words. Its call to LaneBattleStep relies on MWCC knowing that the native CollisionFish preserves the fish argument in a0; with an assembly CollisionFish the compiler reloads a0 and reschedules seven words at +0x1A8, so the two functions are native together.

`FISH_STATS` is the six-float output buffer passed to `FishModifyParam`.
`SetRaceFishParam` maps its fifth and sixth floats directly to the race
entrant's power and aggression fields, so those members use those names.
The promoted function remains exact in objdiff.

## Deterministic floating-point compilation

`CharacterBonus__FP12grFISH_PARAMP15RACE_FISH_PARAMi` at `0x00323E90` needs
binary32 `0.01f` (`0x3C23D70A`) evaluated before `1.0f` in the random-bonus
call. Selecting `0.01f` alone would also reorder the earlier
`GetRandomNumber(0.0f, 0.01f)` calls. The Satan's Fiddle JSON profile therefore
sets `evaluate_first` to true for both `0x3C23D70A` and `0x00000000` in this
function. The earlier calls keep their retail order, while the later call
materializes `0.01f` before `1.0f`. Each selector applies to all matching
constants, without relying on their visitation order.

With MWCC 3.0-011126, `-O3,p`, both mwccgap passes and the normal section
fixup, the complete unit passes the retail checker: `0x3150` initialized bytes and
86 relocations. This remains true with the call-argument consumer hook.
`CollisionFish` and `StepGyoRace` are now native; the complete unit is `0x313C` bytes with 87 relocations.

## CollisionFish and StepGyoRace caller dependency

A post-merge isolated trial with the explicit GPR 0x30/FPR 0 helper history compiles both guarded drafts natively. StepGyoRace then matches completely: its retail call to LaneBattleStep relies on a0 remaining live across CollisionFish. When CollisionFish remains an opaque assembly fallback, the compiler reloads a0 and shifts the following call by four bytes. The joint trial retains one canonical error in CollisionFish at 0x003231B1, in the final per-lane traversal register assignment. Advancing one fish pointer directly, and using the existing outer traversal index with a separate inner index, both preserve the retail operations but leave that allocation difference. Both fallbacks remain active until the joint unit passes.

## Remaining matching blockers (2026-10-08)

The CollisionFish paragraph below is superseded by the C-style variable
reuse in [night-20261008.md](night-20261008.md).

`CollisionFish` is 8/360 instruction words from matching; the compiled body is
0x59C bytes within the 0x5A0 retail extent. Only the final per-lane separation
loop differs: retail uses t3 for its lane counter, t2 for its row base and a3
for its inner byte offset, while the draft uses a3/t3/t2. Unsigned lane
induction leaves that permutation unchanged. Reusing bucket or sorting
indices, adding a row pointer/reference, and changing loop induction forms
produce more differences. Reconsider when a natural loop representation
accounts for those three register lifetimes; retain the original scoped
pointers and indexed arrays meanwhile.

`FishModifyParam` improves from 19/480 to 11/480 words by passing the case-1
range as an implicitly converted double literal. Case 2 then matches. The
remaining words are argument constant materialization in case 1 (+0x4F4
through +0x504, five words) and case 5 (+0x68C through +0x6A8, six words).
Retail prepares f13 before f12; the draft reverses their integer temporary
identities and constant order. Named range-first initialization, direct
case-5 arguments, integer mean folding and float suffix changes do not
resolve this. Earlier case-0 mean conversion changes affect cases 2/3
without fixing cases 1/5. Reconsider with evidence about MWCC constant
identity and argument scheduling. Both this draft and StepGyoRace remain
guarded; no linked mismatch is accepted.

## FishModifyParam stable-selector limits

The canonical Satan's Fiddle build with FishModifyParam alone native retains
11/480 differing words, a `0x778` body in the `0x780` retail extent, and one
complete-unit byte problem. A callee-scoped binary32 `0x3e99999a` (0.3f)
evaluate-first selector for `GetRandomNumber__Fff` fixes all six case-5 words
at +0x68C..+0x6A8. It prepares the range before the 1.3f mean
(`0x3fa66666`), leaving only the five case-1 words at +0x4F4..+0x504.
This is a partial calibration, so the row is not accepted into the profile.

Selecting binary32 `0x3e4ccccd` (0.2f) first at that same callee fixes case 1
but disturbs already matching calls: eight words at +0x540..+0x55C in case 2
and five at +0x610..+0x620 in case 4. With both range selectors the function
has 13/480 differing words. The unscoped 0.2f selector has the same result.
Changing case 1's mean to a float literal does not resolve the conflict.
An explicit binary64 0.2 selector (`0x3fc999999999999a`) is unmatched and
correctly fails compilation: the consumed constants have already narrowed
to binary32. The same enclosing function, bits and callee cannot distinguish
these case-specific requirements; occurrence/address selectors are unsuitable.

Blocker category: floating argument scheduling with conflicting stable
identities. The original 11-word guarded draft remains. Reconsider when a
natural expression/type distinction explains the case-1/case-4 materialization
without disturbing case 2; then combine it with the verified case-5 range row
and require a complete-unit pass.

## CollisionFish helper-history exclusion

The GPR `0x30` / FPR `0` history retains the eight final-loop differences in
`CollisionFish__FP15RACE_FISH_PARAMi`. GPR `0x10` / FPR `0` leaves all eight
unchanged and introduces a byte problem in `LaneBattleStep__FP15RACE_FISH_PARAMi`.
Thus that alternate helper history is unsuitable for this unit. CollisionFish
has no call consuming its binary32 0.05f (`0x3d4ccccd`) separation distance;
its remaining differences are the final loop's integer register permutation.

With CollisionFish and StepGyoRace jointly native under the existing `0x30`
history, StepGyoRace matches and CollisionFish remains the sole canonical
problem at `0x003231B1`. Both guards remain. Reconsider with a natural final
lane-loop representation that accounts for the lane counter, row base and
inner-offset lifetimes; helper-mask calibration does not remove this blocker.

## Mid-day float-selector and loop probes (2026-10-08)

The remaining guards are `CollisionFish`, `StepGyoRace` and
`FishModifyParam`. Source-only probes use the canonical Satan's Fiddle
adapter, rather than the draft helper's plain-wibo compiler. The existing
drafts remain 8/360 words for CollisionFish and 11/480 for FishModifyParam;
StepGyoRace remains exact when CollisionFish is native alongside it.

The upstream `nested_call` / `nested_variable` selectors require an actual
sibling call expression inside the outer call's argument list. The conflicting
`GetRandomNumber` calls in tactics 1, 2 and 4 take direct constants. There is
no nested call identity to select at those sites. Moving the cases 2/4 range
into float locals does not create one: with the private 0.2f/0.3f rows the
consumer still recognizes the same binary32 constants, retaining 13 differing
words. A shared tactics multiplier also retains 13. Double range locals
instead produce a `0x7A0` body, exceeding the `0x780` extent. The existing
0.3f-only calibration remains the best five-word FishModifyParam probe and
is not accepted into the production profile.

CollisionFish's final six-lane loop has no call consuming its 0.05f distance;
its eight-word register permutation is independent of these selectors.
New natural lifetime/type probes give:

| Source boundary | CollisionFish differing words |
|---|---:|
| Initialize the lane counter at function entry | 349 |
| Initialize it before sorting | 259 |
| Initialize it beside the lane counts | 232 |
| Use an unsigned byte or halfword lane counter | 10 |
| Use a signed byte or halfword lane counter | 17 |
| Scope the saved sorting index to its swap block | 18 |
| Compute the separation limit before selecting the following fish | 8 |
| Separate the ahead pointer's declaration and initialization | 8 |

The narrower counters add extension/induction differences without fixing
the original permutation. Scoping the saved sorting index changes the
sorting loop's registers as well. Removing the unused float declarations
does not change either function's score. None of these source probes is
retained. m2c receipts and each canonical-profile source snapshot are under
`.private/floatsel/`; m2c's original FishModifyParam jump-table limitation
remains recorded in its receipt. No new helper-history or expression row
is proposed for this unit.

The fresh production FishModifyParam probe confirms 5/480 words and one
complete-unit byte problem at `0x00323C46`, with every other native function
preserved. Receipt: `.private/floatsel/gyoracesim/fish-best-production/`.

## Round-1 natural loop and tactics probes (2026-10-08)

Round 1 starts at integration commit `a9dddc679a4550c1d3ab9fdf1c1ce2bfb1e4a88b`.
The fresh canonical `chronicletwo_dev:sf-d8bf13c`, `JOBS=4` build passes
147/149 complete objects; only the inherited `nd_meswin` and `actscript`
problems remain. The PAL verifier reports exactly `0x26` differing text
bytes and passes every other section and the memory-end check. The guarded
production gyoracesim object passes `0x314C` bytes and 87 relocations.
Coverage reports 6,687 matched, 122 guarded drafts, 61 assembly-only and
two fuzzy functions. These counts supersede the earlier pre-upstream guard
classifications; they are measurements of this base.

The existing m2c receipts and documented dependency layouts are the analysis
baseline. Every source experiment below uses the canonical Satan's Fiddle
adapter with `-O3,p` and the existing GPR `0x30` / FPR `0` history. No assembly,
source helper, compiler hook or per-occurrence selector is introduced.

### CollisionFish

All 42 natural variants retain an eight-word best residual. The `for`/`while`
outer loop, typed row/count/index walks, inner-index scope, pointer/reference
lifetimes and sorting scopes are measured separately below. Pre/post
increments and comparison direction are included. A carried preceding
position or entrant index instead of the preceding fish pointer emits a
`0x5A4` body, exceeding the `0x5A0` retail extent. The original `0x59C` body
remains the best source.

The reference to the following fish's position adds a separate field-address
calculation in the branch delay slot and changes the store base, in addition
to the original integer permutation. Reversing the comparison uses a
different floating comparison and opposite branch sense. The sorting
variants that retain their earlier bytes also retain the final permutation;
changing the swap declaration or comparison introduces earlier differences.
None justifies replacing the guarded draft.

| Trial | Differing words / retail extent |
|---|---|
| `outer-for` | 14/360 |
| `outer-for-post` | 14/360 |
| `outer-while` | 14/360 |
| `outer-condition-pre` | 8/360 |
| `inner-condition-pre` | 8/360 |
| `inner-post` | 8/360 |
| `outer-compare-reverse` | 8/360 |
| `inner-compare-reverse` | 8/360 |
| `carry-position` | 0x5A4 body, oversized |
| `carry-index` | 0x5A4 body, oversized |
| `carry-reference` | 8/360 |
| `local-position` | 8/360 |
| `row-and-count-walk` | 44/360 |
| `row-reference-for` | 33/360 |
| `inner-index-walk` | 32/360 |
| `row-count-indices` | 41/360 |
| `inner-after-condition` | 21/360 |
| `inner-after-post` | 43/360 |
| `inner-infinite-break` | 32/360 |
| `inner-counter-scope` | 17/360 |
| `inner-counter-entry` | 8/360 |
| `behind-outside-loop` | 8/360 |
| `limit-outside-loop` | 8/360 |
| `behind-limit-scoped` | 8/360 |
| `sort-compare-reverse` | 10/360 |
| `sort-inner-while` | 8/360 |
| `sort-inner-index-function` | 8/360 |
| `sort-outer-while` | 8/360 |
| `sort-both-while` | 8/360 |
| `sort-index-before-distance` | 22/360 |
| `sort-distance-scope` | 8/360 |
| `sort-distance-references` | 17/360 |
| `sort-order-references` | 23/360 |
| `sort-old-index-const` | 18/360 |
| `sort-old-distance-const` | 8/360 |
| `sort-index-before-const-distance` | 26/360 |
| `sort-scope-block` | 8/360 |
| `final-counter-register` | 8/360 |
| `limit-member-compare` | 10/360 |
| `behind-reference-assignment` | 10/360 |
| `inner-counter-declaration` | 17/360 |
| `inner-index-local-counter-register` | 17/360 |

With only CollisionFish and StepGyoRace made native in a private production
probe, StepGyoRace still matches all 204 words. The complete object has one
byte problem, in CollisionFish at `0x003231B1`; `0x3144` bytes and 87
relocations are checked. No other function or relocation differs. Both
production guards remain because the joint object does not pass.
Receipt: `.private/round1/gyoracesim/collision-step-production/`.

### FishModifyParam

Thirteen per-case expression forms are tested under both private range
policies. `range03` is the previously verified callee-scoped binary32 0.3f
(`0x3e99999a`) evaluate-first row. `range02-03` adds the same callee's
binary32 0.2f (`0x3e4ccccd`) evaluate-first row. Both rows use real
`GetRandomNumber__Fff` identities in `FishModifyParam__FP12grFISH_PARAMPff`.
They remain private partial calibrations, with no production profile edit.

The variants include explicit speed-tier products, factor assignment in
loop initialization or the first product, product operand order, `do` and
`while` loops, and separate case-2 random-factor evaluation. Unary negation
pairs and the equivalent one-fifth range fold to the same binary32 literal;
they do not distinguish the conflicting calls. A case-4 comma expression
preserves the random-factor call before its aggression update but also
retains the conflict.

| Trial and private policy | Differing words / retail extent |
|---|---|
| `fish-case1-explicit-speeds-range03` | 5/480 |
| `fish-case1-explicit-speeds-range02-03` | 13/480 |
| `fish-case1-loop-init-range03` | 5/480 |
| `fish-case1-loop-init-range02-03` | 13/480 |
| `fish-case1-factor-assignment-range03` | 5/480 |
| `fish-case1-factor-assignment-range02-03` | 13/480 |
| `fish-case1-factor-first-product-range03` | 5/480 |
| `fish-case1-factor-first-product-range02-03` | 13/480 |
| `fish-case1-products-factor-first-range03` | 8/480 |
| `fish-case1-products-factor-first-range02-03` | 16/480 |
| `fish-case1-loop-do-range03` | 146/480 |
| `fish-case1-loop-do-range02-03` | 140/480 |
| `fish-case1-loop-while-range03` | 5/480 |
| `fish-case1-loop-while-range02-03` | 13/480 |
| `fish-case1-range-negation-range03` | 5/480 |
| `fish-case1-range-negation-range02-03` | 13/480 |
| `fish-case1-range-ratio-range03` | 5/480 |
| `fish-case1-range-ratio-range02-03` | 13/480 |
| `fish-case2-factor-separate-range03` | 5/480 |
| `fish-case2-factor-separate-range02-03` | 13/480 |
| `fish-case4-factor-aggression-expression-range03` | 5/480 |
| `fish-case4-factor-aggression-expression-range02-03` | 13/480 |
| `fish-cases2-4-unary-range-range03` | 5/480 |
| `fish-cases2-4-unary-range-range02-03` | 13/480 |
| `fish-cases2-4-range-ratio-range03` | 5/480 |
| `fish-cases2-4-range-ratio-range02-03` | 13/480 |

The private complete-wrapper confirmation checks `0x3144` bytes and 87
relocations and has only the FishModifyParam byte problem at `0x00323C46`.
Its body remains `0x778` bytes and 5/480 differing words. The five words in
case 1 are the unchanged range/mean materialization order; enabling 0.2f
first fixes them but breaks the already matching cases 2 and 4. There is
still no sibling nested call identity at those direct-constant calls.
Receipt: `.private/round1/gyoracesim/fish-best-production/`.

The guarded source and checked-in profile remain byte-for-byte identical to
the round-1 base. Trial source copies, compile logs, instruction diffs,
structured sweep ledgers and the exact private profiles are retained under
`.private/round1/`. No shared-file proposal is needed.

Final guarded validation repeats the baseline exactly: all 149 game object
SHA-256 hashes and the complete PAL ELF file are unchanged, the canonical
checker remains 147/149 with only `nd_meswin` and `actscript` failing, and
coverage is unchanged. The verifier retains exactly `0x26` text bytes and
passes all other sections and the memory-end check. Receipts:
`.private/round1/final-build.log`, `final-check.log`, `final-coverage.txt`,
`final-hashes.json` and `validation-summary.json`.

## Control-context promotion (2026-10-08)

`FishModifyParam` is now source-supplied and exact at 0/480 words. Two
callee-scoped range rows select tactics 1's 0.2f argument by its switch
context and evaluate tactics 5's 0.3f first. The whole function removes
seven unused declarations and initializes the RNG state and name-hash
seed together. `CollisionFish` and `StepGyoRace` retain their guards.

The clean proto-image build passes `SCES_511.90: OK`, 149/149 complete
objects, and 6,746 matched / zero fuzzy functions. Every other linked and
source-only object hash equals the `24d3d21` baseline. Full selector,
hygiene and validation evidence is in
[selector-context-20261008.md](selector-context-20261008.md).

## Race state signedness

Every read of `grRACE_PROGRESS::state` in gyorace and gyoracesim is an
unsigned byte load, so the field is `u8` and its comparisons need no cast.
`RACE_FISH_PARAM::state` stays `s8`: StepFish copies it into the record
with a signed load, and its comparisons in LaneBattleStep keep `(u_char)`.
`RaceProgressCopy::state` also stays `s8`, because grGetFishProgress's
record copy loads the byte signed. Making all three fields `u8` fails
grGetFishProgress and StepFish on those loads; retyping only
`grRACE_PROGRESS::state` passes SCES_511.90 and 149/149 objects.

## Race-step function linkage

Retail StepGyoRace__FP15RACE_FISH_PARAMP11grRACE_INFO is LOCAL at 0x323270,
with declared size 0x32C (812 bytes). Both source prototypes and the definition
now use static linkage. The complete isolated object preserves 0x3134 checked
bytes and all 87 resolved relocations, with the native symbol also LOCAL and
812 bytes. The production PAL build and all 149 objects remain exact; no
function guard changes.

Receipts: .private/fixes-r0/probes/gyoracesim-static/objects.log and
.private/fixes-r0/gyoracesim-final-{build,objects}.log.
