# Map-piece copying and character allocation

`CMapPiece::Copy` copies the base object/frame state, piece metadata and
material records, optionally constructing a separately allocated character.
`CreateChara` constructs and initializes a character and loads its model
pack. Their assembly guards are removed by hand.

Both selectors use `mdslist.cpp`, allocator `__nw__FUiP1`, constructor
`__ct__11CCharacter2Fv`, `after_constructor_inline`, and exactly one eligible
class-6 construction. Full callers are
`Copy__9CMapPieceFR9CMapPieceP9mgCMemory` and
`CreateChara__FPUiPcP9mgCMemory`. Canonical differences are respectively
57 and 2 words; both reach zero with the scoped policy and final natural
source. The broader scheduling difference in Copy is not just its branch pair.
The [design note](../satansfiddle/placement-new.md)
states the evidence limits of this intentional conversion request.

The inherited material-copy draft used byte offsets and a local colour
overlay. The final loop indexes the real `PieceMaterial` arrays and uses
their implicit assignment. The documented 0x20 record contains four integer
or pointer members followed by a four-float colour. Its natural assignment
emits retail's four integer loads/stores followed by four float loads and
four float stores, preserving the complete object. No compiler-generated
special member is written by hand. Array-new of the material records is
outside the selected scalar constructor site.

Fresh Copy analysis through `decompile.sh`/m2c confirms that `col_type` at
0xA0 is copied, while `col_param` at 0xA2 is not: destination initialization
leaves that optional parameter zero. The older field-usage table's mention
of Copy for `col_param` is corrected. This correction does not change code.

Retail Copy at 0x00169C60 is GLOBAL/FUNC, size 0x268 within extent 0x270.
CreateChara at 0x0016ACD0 is LOCAL/FUNC, size 0x12C within extent 0x130.
Both native bodies and zero padding are checked. pn13 passes the complete
resolved mdslist object, all 149 units and `SCES_511.90: OK`. Every assembled
and source-only object outside the seven promoted units retains its baseline
hash; linked main/game bytes and loaded memory extent agree.

Receipts: `.private/pntc/receipts/m2c-mdspiece-copy.log`,
`natural-mdspiece-record.log`, `promote-eleven-accepted-build.log` and `.exit`,
`promote-eleven-accepted-objects.log`, and `promote-eleven-accepted-artifacts.json`.
The previous guarded status for these two callers is superseded by this note.

## Current design reference

This dated evidence retains its original measurement scope.
[The consolidated placement-conversion design](../satansfiddle/placement-new.md) owns the current
capability, activation rows, safety requirements, and accepted source status.
