# EditMode selector context

`EditMode__FP6CScene` matches natively with the production Satan's Fiddle row
that evaluates the binary32 quarter-turn tolerance `0x3f490fdb` first at its
three real `mgAngleCmp__Ffff` calls (`expected_matches: 3`). The row covers
only the three angle-test argument materialisations; the rest of the function
(axis arithmetic, the `GetGeoCheckCamCol` argument setup and the ground
query) is determined by the source forms listed in [notes.md](notes.md).
The nested collision-query argument to `CheckHit` carries no floating
constant, so no further selector applies in that region.

The complete editmode object is 0x637C bytes with 1,400 relocations.
