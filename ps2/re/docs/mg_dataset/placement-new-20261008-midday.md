# Frame-copy construction — October 8 midday

These checks use baseline `c79e57c`, MWCC 3.0-011126, the canonical flags and
existing pragmas, and `chronicletwo_dev:sf-d8bf13c`. Native-draft word counts
mask relocation operands and check their identities separately. None of the
four placement-new parks is promoted.

## Bounding-box arguments

`CreateFrameVisual` reads its vertex count from `MDT_HEADER::vertex_num`
before deriving the vertex pointer from the serialized `vertex_ofs`. That
source order reproduces retail's `lw t0,12(s2)` at `+0x1E4`, followed by
the three output-vector argument addresses. The previous byte-offset cast
and later count declaration materialize that load after those addresses.

The native result improves from 10/444 to 6/444 differing words; its body
remains 0x6E8 within retail's 0x6F0 extent. The only differences are six
allocation null tests at `+0x180`, `+0x30C`, `+0x380`, `+0x414`, `+0x4C8`,
and `+0x548`, each using the saved object register rather than retail `v0`.
The guard remains. A typed count declared after the vertex pointer and a
call with both arguments expressed directly each retain 10/444.

## Generated attribute assignment

`CopyFrame` allocates an `mgCFrameAttr` when the source frame has attributes,
copies its complete visual-attribute state, and attaches it to the new frame.
The compiler-generated `*attr = *source_attr` emits exactly the same copy
instructions as the previous individual field assignments and two vector
casts. The ordinary assignment is retained in the guarded draft.

The native result remains 1/208 words different, with a 0x33C body in the
retail 0x340 extent. The only mismatch is the placement-new null branch at
`+0x138`: draft `beqz a0` versus retail `beqz v0`. Both registers hold the
same allocation result. Generated assignment does not change the branch.

A reference to the newly constructed attribute and an assignment expression
combining construction with the copy also retain 1/208. They offer no
improvement over the simple pointer and separate assignment. Assigning the
new pointer to `dst->attr` before copying its fields instead gives 68/208.

Replacing the separate bound-corner/vector copies with typed placement new
and a whole `BoundInfo` assignment gives 8/208. Its aggregate copy ordering
differs from retail, so the existing bound-copy expression is retained.

## Other controlled probes

Directly assigning the new attribute to `frame->attr` in builder `End`, and
initializing its local at declaration, each retain 1/96. Disabling pointer
analysis, propagation, or lifetime optimization individually around the four
guarded functions leaves their native results unchanged. Disabling peephole
optimization increases differences, including `End` to 4/96; no pragma is
retained. The six visual-allocation branches remain after the independent
query-argument scheduling correction above.

All other native functions in `mg_dataset` retain their match results. The
normal complete build preserves all 149 object-file SHA-256 hashes, retains
147/149 complete-object matches, and retains the baseline PAL `.text`
difference of 0x26 bytes. No shared header or compiler-profile row changes.
