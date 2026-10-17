# Proposal

## Why

The PC port still sizes several gameplay arenas using retail PS2 **logical** quadword budgets (`mem_table` character stacks, dungeon stage slab carving). Host RAM and `kArenaHeadroom` physical backing are already large; the failure mode is `mgCMemory.stack_size` staying at retail values (e.g. **68500** on human stack 0). JSON character metadata and larger floor map payloads exceed those caps, causing `ArenaOverflow` at dungeon entry or monster data corruption when map load consumes the tail of `BuffStageMain`.

## What Changes

- Add **`CHARA_MODEL_LOAD_DELTA`** on PORT (same pattern as existing `CHARA_SCRIPT_RUNTIME_DELTA`): increase logical `mem_table` entries for stacks that hold model geometry and JSON-driven metadata, not script VM stacks alone.
- Apply deltas to **every layout row** in `mem_table` for stacks 0–1 at minimum (human 68500/40000, robo/monster/edit rows as needed); keep retail values as the floor via `retail + DELTA` or a PORT-only table initializer.
- Ensure **`GetCharaMemAllocSize()`** sums the enlarged row so `BuffCharacter` and edit-mode `ControlCharaBuff` parent slabs grow with `BaseCharacter[i]`.
- Add **`DUNGEON_STAGE_*` reserve constants** (map stack peak + minimum quadwords for scene stacks 2 and 3) so floor JSON/binary growth does not steal the monster slice.
- Peak **tests** lock in observed usage after datapack changes; CI fails if load exceeds budget minus margin.
- Document logical vs physical arenas and a **budget table** in `docs/PC.md`.

**Out of scope:** Changing retail PS2 builds, unbounded heap for all assets, or disabling `ArenaOverflow`.

## Capabilities

### New Capabilities

- `port/memory-budgets`: Port logical arena sizing for character `mem_table` and dungeon stage carving, tied to JSON/datapack growth.

### Modified Capabilities

- (none)

## Impact

- **Code:** `ps2/src/charasetup.cpp` (`CHARA_MODEL_LOAD_DELTA`, PORT `mem_table`, `GetCharaMemAllocSize`), `ps2/src/dng_main.cpp` / `dng_event.cpp` (stage reserves if `MainBuffer` tail adjusted), `port/src/tests/`.
- **Docs:** `docs/PC.md`.
- **Compatibility:** PS2/objdiff unchanged (`#ifdef PORT` only).
- **RAM:** Bounded increase (on the order of hundreds of KiB to low MiB per worst-case layout), negligible on PC.
