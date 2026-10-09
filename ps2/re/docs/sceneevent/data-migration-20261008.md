# sceneevent data migration (2026-10-08)

Baseline: `d56248a7`; 6 `INCLUDE_RODATA` / 0
`INCLUDE_BSS` markers; matched_data 0/146.

The event-running diagnostic, eye-view group names, and fire-raster texture
name are inline literals (`sceneevent-literals`). The writable time-band
flare palette is `static float col_1003[4][4]` with its exact four rows and
16-byte alignment (`sceneevent-flare-colors`). Its 64 bytes are native data.

One marker remains: `at_1013__4`, the `{0, 0, 0, 78}` base flare-color
initializer in DrawLensFlare. Natural float-array, aligned-vector, and
existing union aggregate initializers preserve data but change register
allocation: the compiler retains ratio[0] across the aggregate copy,
where retail reloads it. Moving the following sun/screen declarations into
the conditional scope restores stack order but does not restore that
allocation (`sceneevent-flare-vector`, `-aligned`, `-aggregate`, `-order`).
Copying a native static union generates an extra implicit assignment
function (`sceneevent-flare-vector-copy`), so it is rejected. Ordinary
memcpy from a static native base-color array, with and without SDK vector
alignment, preserves the function extent but emits an out-of-line memcpy call
and changes argument/address setup: the best candidate differs in **29/156 relocation-masked
words**, native extent 0x26C within the retail 0x270-byte piece
(`sceneevent-flare-vector-memcpy`, `-memcpy-aligned`). No failing source,
new type pun, helper, dummy local, compiler pragma, or tool/profile edit is
retained. The existing marker/copy remains pending a natural exact form.

`sceneevent-final` revalidates the accepted source after all probes are
reverted. The best-score and disassembly receipts are
`sceneevent-flare-vector-best-score.log` and
`sceneevent-flare-vector-memcpy-aligned-disassembly.log`.

A follow-up typed CopyVector assignment with scoped `inline_depth(8)`
suppresses the extra implicit assignment helper, but still produces a
0x268-byte function versus retail's 0x26C declared extent and 0x270 piece.
It differs in 106/155 relocation-masked words over the declared extent
(106/156 over the padded piece), including stack/register allocation, and
the named static base color remains unbound. The probe and pragma are
reverted (`sceneevent-flare-copy-depth-build.log`, `-objects.log`,
`-score.log`). `sceneevent-flare-copy-depth-source-restored` passes the full
PAL and 149-object checks afterward.

The additional native initializer probe uses CopyVector for both the
lighting ratio and color, with the color aggregate initialized at its
conditional use and the actual sun/screen buffers declared afterward.
It emits all data correctly but still differs in 106/156 masked words,
with native extent 0x268 against the 0x270 retail piece
(`sceneevent-flare-typed-ratio-build.log`, `-objects.log`, `-score.log`).
The source is restored and the full PAL, 149 objects, and unchanged
object hashes pass (`sceneevent-flare-typed-ratio-source-restored`).

The scoped optimization-level-2 initializer probe also fails: 143/160
masked words, native extent 0x280 versus the 0x270 retail piece. Its changed
function extent shifts linked references elsewhere, so the full PAL fails
(`sceneevent-flare-initializer-opt2-build.log`, `-objects.log`, `-score.log`).
The initializer and pragma are reverted; the full PAL, all 149 objects, and
unchanged object hashes pass afterward
(`sceneevent-flare-initializer-opt2-source-restored`).

Final: 1 rodata / 0 BSS markers; matched_data
66/146 after the standard objdiff/progress refresh.
Every accepted step passes the full PAL build (`SCES_511.90: OK`) and
all 149 complete objects, including resolved relocations. The 148 other
object hashes are unchanged at each step. Function coverage stays
6,770 matched / 93 guarded / nine assembly-only / zero fuzzy.

Validation receipts are under `.private/dataE/`, with the step prefixes
listed above and `-build.log`, `-objects.log`, and `-hashes.log` suffixes.
Final refresh: `sceneevent-final-progress.log`, `sceneevent-final-coverage.log`,
and `sceneevent-final-metrics.json`.

## Function static (2026-10-09)

The flare palette is the function static `static float col[4][4]` (16-byte
aligned) of `CScene::DrawLensFlare`, retail `col$1003`, instead of the
file-scope `col_1003`. The object stays exact (`.private/fixes-r3c/b1-*.log`).
