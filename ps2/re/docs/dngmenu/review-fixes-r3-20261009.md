# October 9 round-three review fixes

## M4: room-information function statics

`DrawDngRoomInfo` owns the five-halfword `medal_xytbl` table. Its seal block
owns `AlphaRate`, initialized to zero on its first execution; MWCC generates
the initialization guard. Both use real function-local static declarations,
with no hand-written guard or file-scope aliases. This is the P1/P12 source
form verified by the round-two review.

The full pinned-image build verifies `SCES_511.90: OK` and the canonical
checker passes 149/149 objects. Function selection and profile rows are
unchanged. Receipts: `.private/fixes-r3b/receipts/dng-statics-{build,objects}.log`.

## S2 and source nits: room drawing and route access

Sprite batches use `MG_PRIM_SPRITE`. The room-info alpha loop uses
`DNG_TREE_MAP_MES_MAX`. The forward declaration documents the LOCAL retail
symbol at `0x1EE0F0`, size `0xB18`; the definition has no duplicate block.
The redundant scope around `line_right`, same-width image cast spelling,
and explicit float casts on signed-halfword route points are removed.
Implicit conversion by the existing floating addition preserves each value.

The current native frame tables and pointer-to-coordinate-pair route tables
are described accurately in the night notes. `notes.md` and the data-migration
record already distinguish the promoted functions from historical probes at
m72, so their round-two stale-status findings need no further status edits.
Q/R's negative first-assignment result is recorded without repeating it.

The lane left Step's second message-alpha loop to bigdraft-r0. Step is now
native, and the Step cleanup uses `DNG_TREE_MAP_MES_MAX` for the loop.
Shared save-flag naming is integrated in `savedata.hpp` and the
DrawDngRoomInfo consumer; Step's two consumers also use
`SAVE_FLAG_SPHEDA_UNLOCKED` after the Step cleanup.

Full pinned-image build: `SCES_511.90: OK`; canonical objects: 149/149.
Receipts: `.private/fixes-r3b/receipts/dng-cleanup-final-{build,objects}.log`.
