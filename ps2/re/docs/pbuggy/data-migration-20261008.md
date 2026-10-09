# pbuggy data migration

Checkpoint `830e48ed` has **45 RODATA / 43 BSS** markers and
**4/937 matched data bytes** after the warm
progress refresh.

Seventeen native-use texture, player/buggy/Starbull motion and bomb-attachment strings are inlined, with exact Shift-JIS byte escapes. The two HUD health-gauge colours use direct float aggregate initializers. `BuggyHP` is a documented native initialized integer with retail initial value one.

The buggy action-cycle counter and its guard use an ordinary initialized local static; the bomb reload counter uses an ordinary zero-initialized local static. Named state words, pointers and velocity/position vectors replace the remaining reservations with documented native types. Texture slots and the work-buffer pointer used only by assembly have external definitions under their retail names, ensuring storage is emitted. Existing `EffectBuff` and `PolVoice` constructors and data extents are unchanged.

Retained RODATA markers include the 23 resource/motion names directly referenced by assembly-backed `sgInitBuggy`: `at_942__4`, `at_943__5`, `at_944__4`, `at_945__6`, `at_946__5`, `at_947__5`, `at_948__5`, `at_949__6`, `at_950__6`, `at_951__5`, `at_952__5`, `at_953__4`, `at_954__4`, `at_955__3`, `at_956__3`, `at_957__3`, `at_958__5`, `at_959__5`, `at_960__3`, `at_961__4`, `at_962__4`, `at_963__3`, `at_964__3` (each has the source suffix `__DATA`). Shared native uses retain those symbols too.

Two additional vector markers remain: `at_1074__4__DATA` supplies player facing in `CharaControl`; natural VU-vector initialization at the existing copy point changes 0x1b text bytes starting at function+0x254. `at_1193__DATA` supplies the buggy gun's muzzle endpoint; natural float-vector initialization changes 0x11 text bytes starting at `BuggyControl+0x50`. Both rejected changes are restored, preserving the existing compiler-profile behavior. The inherited `BuggyQuad` wrapper remains only for these two consumers; no new union or cast is introduced.

Each accepted step passes the complete PAL build (`SCES_511.90: OK`) and
all 149 canonical object comparisons, including resolved relocations.
The final hash inventory changes only migrated owned units; every unowned
object remains equal to the warm baseline. No guarded function, assembly
entry or existing compiler-profile row changes. No function is promoted.

Accepted receipt prefixes under `.private/dataF/`:
- `pbuggy-gauge-name` (`-build.log`, `-objects.log`).
- `pbuggy-player-motion-names` (`-build.log`, `-objects.log`).
- `pbuggy-buggy-motion-names` (`-build.log`, `-objects.log`).
- `pbuggy-starbull-motion` (`-build.log`, `-objects.log`).
- `pbuggy-bomb-attachment-names` (`-build.log`, `-objects.log`).
- `pbuggy-gauge-colors` (`-build.log`, `-objects.log`).
- `pbuggy-initial-hp` (`-build.log`, `-objects.log`).
- `pbuggy-action-cycle-static` (`-build.log`, `-objects.log`).
- `pbuggy-reload-static` (`-build.log`, `-objects.log`).
- `pbuggy-game-state-storage` (`-build.log`, `-objects.log`).

Final refresh, coverage and hash receipts are
`pbuggy-final-{refresh,coverage,metrics}.log` in that directory.
Final markers are **25 RODATA / 0 BSS**; refreshed
matched data is **284/937**.
