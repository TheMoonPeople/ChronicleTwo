# River, mask and water map-piece construction

The three script callbacks construct a `CMapPiece` for the selected river,
river mask or water model, resolve its MDS entry, and apply the documented
frame attributes. Their complete natural bodies and purpose comments are
retained, and their assembly guards are removed by hand. Z-buffer write
suppression uses `MG_ZBUF_NO_WRITE`; the mask bound uses the existing
`EDIT_MAP_MASK_PIECE_MAX`. Attribute masks retain their documented enums.

Each exact selector uses `editmap.cpp`, allocator `__nw__FUiP1`, constructor
`__ct__9CMapPieceFv`, `after_constructor_inline`, and one eligible class-6
construction. Caller identities and retail LOCAL/FUNC symbols are:

| Caller | Address | Symbol size | Layout extent |
| --- | ---: | ---: | ---: |
| `emapRIVER_PARTS_NAME__FP9SPI_STACKi` | 0x001B5800 | 0x1A0 | 0x1A0 |
| `emapMASK_PARTS_NAME__FP9SPI_STACKi` | 0x001B59A0 | 0x174 | 0x180 |
| `emapWATER_PARTS_NAME__FP9SPI_STACKi` | 0x001B5B20 | 0x11C | 0x120 |

Each canonical two-word allocation branch/copy difference becomes zero.
The proposed policy retains the normal constructor inline read and requests
MWCC's enclosing statement conversion after its construction walk. It adds
no source helpers, synthetic tests or ordinal selectors. The distinction
between measured behavior and an unproven state repair is documented in the
[design note](../satansfiddle/placement-new.md).

Full-function review covers bounds, failure behavior, MDS lookup and frame
attribute handling. pn13 passes the complete resolved editmap object, all
149 units and `SCES_511.90: OK`, including symbol-body alignment padding.
All assembled and source-only objects outside the seven promoted units
retain exact baseline hashes; linked main/game bytes and memory extent agree.

Receipts: `.private/pntc/receipts/promote-eleven-accepted-build.log` and `.exit`,
`promote-eleven-accepted-objects.log`, `promote-eleven-accepted-artifacts.json`,
and `semantic12-score-comparison.json`. Only these three callbacks change
their previously documented guarded status.

## Current design reference

This dated evidence retains its original measurement scope.
[The consolidated placement-conversion design](../satansfiddle/placement-new.md) owns the current
capability, activation rows, safety requirements, and accepted source status.
