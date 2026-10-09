# gamepad data migration (2026-10-08)

Baseline: `d56248a7`; 4 `INCLUDE_RODATA` / 10
`INCLUDE_BSS` markers; matched_data 0/3176.

The thread identifier and previous VSync count are native static ints;
`GamePad` remains the existing native static CGamePad pointer. The two
port DMA buffers are `static u8[0x400]` aligned to 64 bytes; the thread
stack is `static u8[0x400]` aligned to 16 bytes (`gamepad-storage-named`).
All ten BSS markers are removed with exact piece extents and references.

The rpad/cnt and explicit initialization-flag pairs retain their original
one-time initialization logic. Removing their markers while retaining
function-local declarations fails named piece identity (`rpad_256`,
`init_257`, `cnt_374`, `init_375`), and shifts the small-BSS layout in the
PAL link (`gamepad-native-counters`). Typed file-local definitions with
those retail names resolve the identity without changing any instructions.
The unsuccessful intermediate storage check is
`gamepad-thread-storage-failed-objects.log`; the final complete-storage
step is `gamepad-storage-named`.

The port-open diagnostic is inline in both Init failure branches. Existing
native SaveCapture/LoadCapture string literals supply the remaining three
pieces once their markers are removed (`gamepad-literals`). No controller
behavior, capture-buffer traversal, or thread API changes are included.

Final: 0 rodata / 0 BSS markers; matched_data
3176/3176 after the standard objdiff/progress refresh.
Every accepted step passes the full PAL build (`SCES_511.90: OK`) and
all 149 complete objects, including resolved relocations. The 148 other
object hashes are unchanged at each step. Function coverage stays
6,770 matched / 93 guarded / nine assembly-only / zero fuzzy.

Validation receipts are under `.private/dataE/`, with the step prefixes
listed above and `-build.log`, `-objects.log`, and `-hashes.log` suffixes.
Final refresh: `gamepad-final-progress.log`, `gamepad-final-coverage.log`,
and `gamepad-final-metrics.json`.

## Function statics (2026-10-09)

`rpad` and `cnt` are now written as the natural `static u16 rpad = 0;` in
`pad_button_read` and `static int cnt = 0;` in `CGamePad::UpDate`. MWCC emits
the retail `rpad$256`/`init$257` and `cnt$374`/`init$375` pairs itself, so the
four file-scope definitions and the two hand-written guards are gone. With the
current postprocessor the object is exact (0x15BC bytes, 104 relocations) and
the PAL link is unchanged; the earlier piece-identity failure described above
no longer occurs. `old_vsync` uses its retail name. Receipts:
`.private/fixes-r3c/b1-build.log`, `b1-check.log`.
