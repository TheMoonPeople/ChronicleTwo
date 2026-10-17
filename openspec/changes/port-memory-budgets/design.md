# Design

## Context

See proposal.md — logical caps vs physical `kArenaHeadroom`. Retail human stack 0 = **68500** quadwords; coredump shows ABRT at `68500/68500` on `BaseCharacter[0]` during `SetupMainUnit` → JSON `LoadCharacter` → `SEQ_END`. Script stacks already use `CHARA_SCRIPT_RUNTIME_DELTA`; model stacks do not.

Dungeon: `BuffStageMain` holds map on stack 1; `AssignStack(2|3)` carves the remainder for parts and monsters. Larger PC map payloads shrink stack 3 without raising logical limits.

## Goals / Non-Goals

**Goals:**

- Raise PORT logical budgets so current datapack character and floor data fit with margin.
- One clear mechanism for character data (`CHARA_MODEL_LOAD_DELTA`) and one for stage tail (`DUNGEON_STAGE_STACK2_RESERVE`, `DUNGEON_STAGE_STACK3_RESERVE`, optional `DUNGEON_STAGE_MAP_DELTA` on `MainBuffer` planning).
- Peak tests document observed usage; regressions fail in CI.

**Non-Goals:**

- Raising only `kArenaHeadroom` (does not change `stack_size`).
- PS2 `mem_table` edits or removing overflow aborts.

## Decisions

### 1. `CHARA_MODEL_LOAD_DELTA` (PORT)

**Choice:** In `charasetup.cpp`, define:

```cpp
#ifdef PORT
#define CHARA_MODEL_LOAD_DELTA <quadwords>  // set from peak test + margin
#endif
```

Apply to `mem_table` for stacks that receive `LoadCharacter` / mesh metadata:

| Layout row | Stacks to bump (minimum) | Retail stack 0 (reference) |
|------------|--------------------------|----------------------------|
| Human      | 0, 1                     | 68500, 40000               |
| Robo       | 0, 1, 2 (verify peaks)   | 30000, 30000, 60000        |
| Edit       | 0                        | 75000                      |
| (4th row)  | 0                        | 120000                     |

Use `retail_value + CHARA_MODEL_LOAD_DELTA` in a PORT-only initializer macro so PS2 table stays literal.

**Bootstrap:** Until peak test lands, use a conservative `CHARA_MODEL_LOAD_DELTA` (e.g. **12000** quadwords ≈ 187 KiB per bumped cell) so equipped Max clears dungeon entry; tighten after measurement.

**Rationale:** Mirrors proven `CHARA_SCRIPT_RUNTIME_DELTA` approach; addresses exact 68500 fence without guessing per-asset sizes.

### 2. Parent buffer coupling

**Choice:** `GetCharaMemAllocSize()` must sum the PORT row maximum (including all deltas). `memoryInit` / `editloop` allocations for `BuffCharacter` and `ControlCharaBuff` already call this — no separate parent bump.

### 3. Dungeon stage reserves

**Choice:**

1. Measure max `GetStack(1)->stack_used` after `LoadMap` across datapack floor maps.
2. Define `DUNGEON_STAGE_STACK2_MIN` and `DUNGEON_STAGE_STACK3_MIN` (quadwords) from retail peaks + margin for part placement and `LoadMonsterFile` pools.
3. If `BuffStageMain.stack_size - stack1_used < STACK2_MIN + STACK3_MIN + margin`, increase effective stage slab by reducing fixed `MainBuffer` consumers before `BuffStageMain.stSetBuffer`, or add `DUNGEON_STAGE_MAIN_DELTA` quadwords carved from `MainBuffer` re-balance (documented in budget table).

Debug: `assert(stGetRest() >= sum of reserves)` after floor load on PORT.

### 4. Validation artifacts

**Choice:**

- `port/src/tests/chara_mem_budget_test.cpp` (or extend existing): load heaviest character fixture; `EXPECT_LT(peak, stack_size - margin)` per stack.
- Optional floor map peak test or scripted scan output checked in CI.

### 5. Documentation

Budget table columns: arena, retail qw, port qw, delta name, peak source, date/datapack rev.

## Risks / Trade-offs

- **[Over-large bootstrap DELTA]** → Wastes a little RAM; peak test narrows it.
- **[Under-large DELTA]** → ABRT returns; overflow guard catches it.
- **[MainBuffer total]** → Recompute `stGetRest()` after `mem_table` bump before assuming stage slab still fits.

## Migration Plan

1. Land peak test on current `main` (expect failure at 68500).
2. Apply `CHARA_MODEL_LOAD_DELTA` + stage reserves; tests green.
3. Update `docs/PC.md` table; manual dungeon entry + heaviest floor room.

## Open Questions

- Single global `CHARA_MODEL_LOAD_DELTA` vs per-row constants (start global; split if robo peak diverges).
- Worst-case floor map list owner (datapack scan script vs curated `d03`/`d05` set).
