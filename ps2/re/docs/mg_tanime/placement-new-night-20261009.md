# Matched texture-animation node allocation with the isolated proposal

`mgCTextureAnime::NewTexAnimeData` obtains storage from the supplied memory
manager and constructs an unlinked `CList<mgCTexAnimeData>`. The existing
natural caller and documented list/record types are retained; the assembly
guard is removed by hand.

The exact row selects `mg_tanime.cpp`,
`NewTexAnimeData__15mgCTextureAnimeFP9mgCMemory`, allocator `__nw__FUiP1`,
and constructor `__ct__24CList<15mgCTexAnimeData>Fv`, with
`before_constructor_inline` and one eligible class-6 construction. The
canonical six-word difference becomes zero. After-inline conversion retains
that six-word difference, so its timing is not interchangeable with the
measured before-inline request. Only the current direct constructor inline
read receives class 3; stored constructor metadata remains unchanged.

The row uses the lane's [design note](../satansfiddle/placement-new.md).
It adds no synthetic source helper, no-op local, ordinal selector or generated
instruction patch. The retained inline-body and enclosing-expression audits
bound its construction effects before the object is published.

The pn13 complete resolved object passes; all 149 game units pass and the
PAL verifier reports `SCES_511.90: OK`. Every recursive object outside
mg_tanime and the simultaneously promoted funcpoint unit retains its exact
baseline hash. Linked main/game bytes are identical; ELF symbol metadata
changes with native function ownership.

Retail symbol 0x0013DA40 is GLOBAL/FUNC with size 0x7C. Its layout extent is
0x80 because the next function is aligned; the native 0x7C body and four
zero padding bytes are both checked. The header's existing `@size 0x80`
describes that extent rather than the retail symbol size. This lane does not
own shared headers, so the exact documentation correction is saved as
`.private/proposals/mg-tanime-newtex-size.patch` without editing the header.
No texture-animation function remains guarded.

Receipts: `.private/pntc/receipts/promote-first-two-build.log` and `.exit`,
`promote-first-two-objects.log`, `promote-first-two-artifacts.json`,
`semantic12-score-comparison.json`, and the genuine compiler tests in
`semantic-pn13-tests.log`.

## Current design reference

This dated evidence retains its original measurement scope.
[The consolidated placement-conversion design](../satansfiddle/placement-new.md) owns the current
capability, activation rows, safety requirements, and accepted source status.
