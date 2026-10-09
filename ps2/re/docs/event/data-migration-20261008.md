# event data migration (2026-10-08)

Baseline: `d56248a7`; 4 `INCLUDE_RODATA` / 2
`INCLUDE_BSS` markers; matched_data 88/217.

`EventScene` is a native CScene pointer with the existing public header
declaration; `cnt_1056` is a native file-local int preserving the door
sequence's frame counter (`event-state-storage`). The existing EventScript
object and compiler-generated initializer are unchanged and now have a
purpose comment.

The three camera-offset rows are a documented native
`static float vv_984[3][4]` with 16-byte alignment
(`event-door-camera-offsets`). All 48 bytes, including the negative
half-unit values and homogeneous W components, match retail.

NPC talk-file format strings are inline in their primary/fallback uses.
The door-opening motion is inline as the eight exact Shift-JIS bytes
`83 68 83 41 8A 4A 82 AF` (`event-script-motion-literals`). Shared uses
retain literal pooling. The unused initializer-address extern is removed;
no manual initializer or generated data replacement is added.

Final: 0 rodata / 0 BSS markers; matched_data
217/217 after the standard objdiff/progress refresh.
Every accepted step passes the full PAL build (`SCES_511.90: OK`) and
all 149 complete objects, including resolved relocations. The 148 other
object hashes are unchanged at each step. Function coverage stays
6,770 matched / 93 guarded / nine assembly-only / zero fuzzy.

Validation receipts are under `.private/dataE/`, with the step prefixes
listed above and `-build.log`, `-objects.log`, and `-hashes.log` suffixes.
Final refresh: `event-final-progress.log`, `event-final-coverage.log`,
and `event-final-metrics.json`.

## Function statics (2026-10-09)

`cnt` and `vv` are real function statics of `EventLoop` and `EventDoorLoop`
(retail `cnt$1056`, `vv$984`), replacing the file-scope `cnt_1056` and
`vv_984`; `EventScript` is defined after the includes. The event object stays
exact and the PAL link is unchanged (`.private/fixes-r3c/b1-*.log`).
