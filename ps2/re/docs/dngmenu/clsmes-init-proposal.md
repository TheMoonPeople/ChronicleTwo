# ClsMes::Init standalone proposal

This is a historical probe record. The current native/guarded status is in
[notes.md](notes.md#current-assembly-gaps); later exact matches are documented
in [night-20261008.md](night-20261008.md).

Applied on October 8 night: `DngTreeMapInit` is exact and the `Init__6ClsMesFv`
assembly marker is removed. The complete dngmenu object passes and the PAL
executable verifies; see [night-20261008.md](night-20261008.md).

`Init__6ClsMesFv` at 0x001F38E0 remains assembly-supplied in dngmenu by
assignment. The unchanged `nd_meswin.hpp` contains its inline definition.
The midday natural `CMenuTreeMap` constructor makes MWCC emit that body as
a standalone function: all 176 words match its 0x2C0 manifest reservation,
comprising 0x2B8 native bytes and eight bytes of alignment padding.

The private canonical experiment removes only the Init assembly marker
while enabling the tree-initialization draft. It reports `MATCH` for Init
and 28 complete-unit problems, all for `DngTreeMapInit`; there are no Init
byte or relocation failures. This experiment needs no shared-header edit.
The constructor and its real eight-window member array supply the necessary
natural call/emission context. The draft itself remains 55/256 words from
exact, so neither function is promoted by this experiment.

The exact conditional marker-removal patch is
`.private/proposals/dngmenu-clsmes-emission.patch`; its conditions are in
`.private/proposals/dngmenu-clsmes-emission.md`. Apply it only with exact
native `DngTreeMapInit`, then require complete-unit, other-object and PAL
baseline acceptance. Applying it to the current guarded tree initialization
would remove the sole active implementation. The real Init marker remains
intact. Receipts: `.private/dnginv-midday/tree-retained-canonical.log` and
its `tree-retained-canonical/` compile, word and object reports.

## Earlier out-of-line experiment

The earlier r2 proposal moved the inline definition from the shared header
to dngmenu.cpp and also matched all 174 nonpadding instructions. It was
reverted because callers' inlining had not been validated. Its historical
receipts remain `.private/receipts/clsmes-out-of-line.log` and
`.private/receipts/clsmes-proposed-unit-link.log`. That shared-header route
is unnecessary for the natural constructor result above; no foreign-file
patch or shared-header change is retained in this lane.
