# Natural placement-animation slot search

`EditSetPlaceAnime` starts an animation on a map part. Removal reuses a free
removal slot and copies the part into `CurPartsBuff`; other animation kinds
choose a free slot or the greatest-age occupied slot. The documented
`CPlaceAnime` record is 0x90 bytes and its actual array supplies both searches.
The existing real inline `CMapParts` constructor is activated with the caller
by manually removing their shared guard.

The inherited searches used a byte counter and cast byte addresses back to
`CPlaceAnime*`. Ordinary typed indexing initially leaves 14 differing words.
The optimizer already creates retail's 0x90 induction and loop-back delay
slot; the residual is register assignment. Reading `PlaceAnime[i].state`
directly resolves the first-loop candidate/displacement exchange. Giving
each loop its own `for (int i = 0; ...)` counter resolves the remaining
counter/displacement exchange. Each real candidate pointer is local to its
iteration, and the greatest-frame accumulator is local to the second branch.
The final complete draft object equals the inherited diagnostic-zero object
byte-for-byte. Replacing direct state reads with `candidate->state` in this
otherwise passing source leaves 12 words and is not retained.

The exact row uses `editeff.cpp`, `EditSetPlaceAnime__FiP9CMapParts`,
`__nw__FUiP1`, `__ct__9CMapPartsFv`, `after_constructor_inline`, and
`expected_matches: 1`. The direct constructor's observed original class is 6.
The canonical allocation pair has two differences; the selected, fully
natural source reaches zero. Existing animation/state enums replace their
known numeric values. No byte-field arithmetic, steering helper, dummy
counter, new pragma or manual special member remains in the promoted body.

Retail 0x00300C40 is GLOBAL/FUNC, size 0x264 within extent 0x270. The header's
old `@size 0x270` is corrected only in a private shared-header proposal.
The complete resolved unit, all 149 objects and PAL image are checked on
pn14. All assembled and source-only objects outside the twelve promoted
units retain baseline hashes; linked main/game bytes and memory extent agree.

Private evidence: `.private/pntc/editeff-natural/README.md`, `report.json`,
`best.diff`, `retail-m2c.txt`, and `natural-best-verify/compile.log`.
Full-build receipts: `.private/pntc/receipts/promote-eighteen-pn14-clean-build.log`
and `.exit`, `promote-eighteen-pn14-clean-objects.log`, and
`promote-eighteen-pn14-clean-artifacts.json`.
This intentional conversion policy remains an isolated
[design note](../satansfiddle/placement-new.md).

Final marker-order validation also passes `promote-eighteen-final-build.log`,
`promote-eighteen-final-objects.log` (149/149), and
`promote-eighteen-final-artifacts.json`. Resolved game bytes and all objects outside the accepted units still agree.
Refreshed native coverage is 6,767 matched / 95 guarded / 10 assembly-only /
0 fuzzy, recorded in `promote-eighteen-coverage.log`.

## Current design reference

This dated evidence retains its original measurement scope.
[The consolidated placement-conversion design](../satansfiddle/placement-new.md) owns the current
capability, activation rows, safety requirements, and accepted source status.
