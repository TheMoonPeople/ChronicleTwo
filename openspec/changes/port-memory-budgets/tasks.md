# Tasks

## 1. Baseline measurement

- [ ] 1.1 Add `chara_mem_budget_test` (or similar): PORT-only `SetupMainUnit` with Max + heavy-equipment fixture; expect current peak on stack 0 ≥ 68500 and failure or at-cap without delta.
- [x] 1.2 Record peaks per `BaseCharacter` stack and per `mem_table` row; log for budget table.
- [x] 1.3 Enumerate dungeon floor maps; record max `GetStack(1)->stack_used` and `stGetRest()` before `AssignStack(2)`.

## 2. `CHARA_MODEL_LOAD_DELTA` (PORT)

- [x] 2.1 Add `#ifdef PORT` `CHARA_MODEL_LOAD_DELTA` in `charasetup.cpp` (bootstrap **12000** qw until 1.2 refines).
- [x] 2.2 Apply to human stacks **0 and 1**; apply to robo/edit rows **0–1** (and robo stack 2 if peaks require).
- [x] 2.3 Keep PS2 table literal; PORT uses `retail + CHARA_MODEL_LOAD_DELTA` via macro or duplicate initializer.
- [x] 2.4 Confirm `GetCharaMemAllocSize()` sums PORT row max (dungeon `BuffCharacter` + edit `ControlCharaBuff`).
- [ ] 2.5 Re-run 1.1 — dungeon entry and edit `SetupMainUnit` pass without `ArenaOverflow`.

## 3. Dungeon stage reserves (PORT)

- [x] 3.1 Define `DUNGEON_STAGE_STACK2_MIN` and `DUNGEON_STAGE_STACK3_MIN` from 1.3 peaks + margin.
- [x] 3.2 Adjust `MainBuffer` / `BuffStageMain` sizing if `stGetRest()` after max map load is below reserves + margin.
- [x] 3.3 PORT debug assert after floor `LoadMap`; test on heaviest floor from 1.3.
- [x] 3.4 Verify `LoadMonsterFile` / first `AutoSetMonster` on that floor.

## 4. Documentation

- [x] 4.1 Add budget table to `docs/PC.md`: logical vs `kArenaHeadroom`, 68500 reference, `CHARA_MODEL_LOAD_DELTA`, stage mins, peaks.
- [x] 4.2 Note contributor rule: datapack JSON growth → re-run peak tests → bump deltas.

## 5. Validation

- [x] 5.1 Run new + existing `port/src/tests/*` (chara + dungeon storage).
- [ ] 5.2 Manual: enter dungeon (Max + gear), clear floor, enter heaviest room — no ABRT/SIGSEGV.
- [ ] 5.3 Tighten `CHARA_MODEL_LOAD_DELTA` from measured peak + 10% margin; update table and test thresholds.
