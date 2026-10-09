# Movie data migration, October 8 night, round 4

Baseline: `9eb8f660`, pinned SF image, canonical flags and unchanged profile.
The decoder, stream, pool and DMA layouts already documented in notes.md
supply the types; no interrupt or restart reconstruction is attempted.

## Native data

Twenty-two diagnostics/path literals are inline in their existing callers.
The MPEG end-code marker is removed because videoDecFlush already uses
its natural four-byte local initializer. Each function's literals are checked
separately against all object bytes and resolved relocations.

All 25 BSS markers are removed. File-local typed definitions supply the
stream state, interrupt flags, decoder records, output ring, input file and
0x800-byte silence block. Retail symbol names remain reachable from the
assembly handlers; the complete object proves those references resolve.
The two Load overloads use zero-initialized MoviePools locals, reproducing
their 0x18-byte templates and alignment without artificial trailing slots.
stepMain uses its natural persistent `static int cnt = 0`; the compiler
emits the counter and guard previously reserved as cnt_513/init_514.

## Retained markers

`at_1276__2` and `at_1287__2` are the packed GIF tag initializers in
setImageTag. Each has one packed AD descriptor, with the second additionally
setting EOP. The native 128-bit shift initializer is rejected by MWCC
(`illegal data size`). A 16-aligned typed pair of 64-bit control/descriptor
words with memcpy into the SDK quadword argument compiles, but changes
setImageTag and the linked layout. Both markers and the exact original
function are restored. No new pun, helper or instruction-padding object is
retained. The source-only failed object and all diagnostic receipts are in
`.private/dataB-r4/movie-giftags-*`.

vblankHandler, handler_endimage and viBufRestartDMA, including their guarded
bodies, remain unchanged. No header or SDK declaration is changed.

## Measurement and validation

Markers (RODATA / BSS): **25 / 25 → 2 / 0**.
Fresh objdiff `matched_data / total_data`: **0 / 3098 → 3066 / 3098**.

`movie-final-build.log` prints `SCES_511.90: OK`; `movie-final-objects.log`
passes 149/149 objects. These receipts, the incremental checks, baseline
measurements and object-hash audit are under `.private/dataB-r4/`.
All objects outside the seven owned units retain their baseline file hashes.
No function is promoted and no assembly fallback or guarded function body changes.
