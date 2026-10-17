# Spec Delta

## Purpose

Defines how the PC port raises logical `mgCMemory` budgets so JSON character and floor map data fit without silent overlap, while PS2 retail caps stay unchanged.

## ADDED Requirements

### Requirement: Character model load delta on PORT

On PORT builds, `mem_table` logical sizes for model/metadata stacks SHALL exceed retail by `CHARA_MODEL_LOAD_DELTA` (or equivalent per-stack PORT additions), applied at least to human layout stacks 0 and 1, and SHALL follow the same pattern for other layout rows after peak measurement.

#### Scenario: Human stack 0 above retail 68500

- **WHEN** `GetCharaMemAllocPtr` configures `BaseCharacter[0]` for the human layout on PORT
- **THEN** `stack_size` is strictly greater than 68500 quadwords

#### Scenario: Dungeon entry with equipped Max

- **WHEN** the player enters a dungeon as Max with save equipment loaded through `SetupMainUnit`
- **THEN** loading completes without `ArenaOverflow` on any `BaseCharacter` stack

#### Scenario: Retail remains the floor

- **WHEN** a PORT stack budget is computed
- **THEN** it SHALL be at least the retail PS2 `mem_table` value for that index and row

### Requirement: Parent character slab includes deltas

On PORT, `GetCharaMemAllocSize()` SHALL return a value at least as large as the sum of the largest PORT `mem_table` row (including `CHARA_MODEL_LOAD_DELTA`), so `BuffCharacter` and edit-mode character parent stacks do not exhaust before per-part stacks.

#### Scenario: BuffCharacter sizing

- **WHEN** dungeon `memoryInit` allocates `BuffCharacter` using `GetCharaMemAllocSize()`
- **THEN** the parent `stack_size` is not less than the sum of PORT-adjusted stacks for the worst layout row

### Requirement: Dungeon floor map load preserves downstream stacks

On PORT, after loading any shipped dungeon floor map into scene stack 1, logical space for stacks 2 and 3 SHALL be at least `DUNGEON_STAGE_STACK2_MIN` and `DUNGEON_STAGE_STACK3_MIN` respectively (documented constants).

#### Scenario: Largest floor map in datapack

- **WHEN** the worst-case floor map loads through the normal `LoadMap` path
- **THEN** `AssignStack(2)` and `AssignStack(3)` each receive `stack_size` at least the documented minimum reserves

#### Scenario: Monster init after floor load

- **WHEN** `LoadMonsterFile` runs after that floor load
- **THEN** monster placement data is valid and the first monster can spawn without map-byte corruption

### Requirement: Peak regression tests

The port SHALL include automated tests that record peak `stack_used` for the reference character load and SHALL require `peak + margin <= stack_size` for each adjusted stack.

#### Scenario: Datapack growth

- **WHEN** character JSON grows and peak exceeds budget minus margin
- **THEN** the test fails until `CHARA_MODEL_LOAD_DELTA` or the budget table is updated

### Requirement: Overflow remains a fatal diagnostic

When allocation would exceed logical `stack_size`, the port SHALL abort with `ArenaOverflow` rather than truncating.

#### Scenario: Budget regression

- **WHEN** a change shrinks a budget below measured peak
- **THEN** CI or debug checks fail before silent overlap

### Requirement: Documented budget table

The port SHALL document retail vs PORT quadwords, delta macro names, and measurement source in `docs/PC.md`.

#### Scenario: Contributor changes a constant

- **WHEN** `CHARA_MODEL_LOAD_DELTA`, stage reserves, or `mem_table` PORT values change
- **THEN** the budget table and peak tests update in the same change
