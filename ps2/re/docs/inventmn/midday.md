# October 8 midday matching

This is a historical checkpoint. MenuInventKey is now native and exact;
see [notes.md](notes.md) and [night-20261008.md](night-20261008.md).
Five guarded inventory functions remain.

Base `fe60604` already contains upstream `d8bf13c`, including the native
notebook sorting promotion. Canonical image:
`chronicletwo_dev:sf-d8bf13c`. This pass retains two strictly better guarded
drafts. No inventory function is promoted, no shared header or data layout
is changed, and no compiler-profile row or assembly is written.

## ResetAddress

`ResetAddress__15CInventUserDataFv` remains guarded at 14/48 differing words,
with matching 0xC0 extent. Direct `&photo_work[index][0]` gives 34/48.
A typed pointer to the existing 0x2000-byte image rows, indexed by the
photo number, restores the exact eight-assignment unrolled body at
+0x10..+0x78. Both arrays retain their existing types; there is no pointer
induction or byte-offset traversal.

MWCC calculates the buffer base before its three zero-valued loop inductions;
retail does so afterward. The final two-photo remainder reuses that base,
where retail recomputes it, making the sequence one instruction shorter.
A row-array reference also gives fourteen; initializing the index first gives
21. A retained picture-record pointer, a not-equal bound, a do loop and
moving the row pointer into the loop worsen the result. The earlier shared
flat-buffer type experiment is already documented and is not repeated or
proposed. Reconsider the invariant-base lifetime and remainder expression
together. Receipts: `.private/dnginv-midday/ResetAddress.m2c.c`,
`reset-rows/`, the `reset-*` probe directories, and `invent-retained.log`.

## MenuInventKey

`MenuInventKey__Fv` remains guarded at 8/524 differing words, 0x824 native
bytes against retail's 0x830 extent, improved from ten. In the recipe-card
padding branch, the current card is initialized after the row Y conversion
and before the number X conversion. Its negative-card loop still indexes
the name and coordinate arrays directly. This initialization placement
makes `card` live across the X conversion, changing its induction allocation.

The remaining differences are in the negative-card padding loop at
+0x5E0..+0x620. The card occupies a saved register while retail uses a2;
name-offset and position-offset inductions also differ. Initializing the
card at other geometry stages gives 25, 30 or 46 words. While/do forms and
an uninitialized earlier declaration leave ten. Updating the name index
last gives sixteen, advancing line in the loop expression twelve, reversed
position assignments fifteen, and a two-dimensional coordinate record
overshoots retail at 0x83C. Those variants are rejected. Named combined
indices and `top + line` variants already documented are not repeated.

`decompile.sh` still cannot recover the jump table at assembly line 176;
its log and partial output are retained, and the loop analysis uses the
retail instructions. Receipts: `MenuInventKey.m2c.c`, `card-init-y/`,
the `card-*` directories, and `invent-retained.log`.

## CalcTex

`CalcTex__11CMenuInventFv` retains its existing guarded source, oversized
at 0x13B0 against retail's 0x13A0. Its 0x160 frame and extra saved s8 differ
from retail's 0x150 frame and s0..s7 saves. `NetaClipRange` is the existing
eight-byte record containing the top and bottom floats. Retail copies its
two-float seed from BSS, overwrites both fields and retains their addresses
for clipping.

Separate float locals give 1211/1256 differing words and 0x1368 bytes.
They repair frame size and remove s8, but eliminate the observed seed copy
and add an extra saved f22. This is rejected rather than retained as a
semantic rewrite that merely lowers the word count. Array and combined
clip variants grow to 0x13C0; alternate album-geometry ordering leaves
0x13B0. Copying the aggregate first and extracting separate fields lets
optimization discard the seed copy and does not fix the discrepancy.
Reconsider the two field-address lifetimes while retaining the authentic
aggregate copy and the album-scroll operation order. Retail calls three
SDK vector functions; no inline VU0/COP2 replacement is required or allowed.
Receipts: `CalcTex.m2c.c`, `calctex-baseline/`, `calc-range-fields/`,
`calc-range-copy/`, `calc-range-array/`, and the `calc-album-*` directories.

## Placement-new remainders

The four larger placement-new drafts are unchanged. Their documented best
results remain `LoadCharaCheck` 190/312, `MenuInventInit` 606/1044,
`IsCreateObject` 382/1380, and `IsAccessAlbum` 1080/1276 words. The character
or album constructor expansion does not yet reproduce the real retail
member initialization. The allocation result is copied before its branch,
where retail branches on v0 and copies in the delay slot. Tree-map matching
shows that a genuine member-array constructor can restore this behavior;
it does not authorize adding artificial arrays to unrelated classes.

These inventory classes depend on shared constructor definitions outside
this lane's ownership. No natural replacement for those chains is established
by the available analysis, so no speculative helper, member array or foreign
header proposal is made. The detailed branch sites and reconsideration
conditions remain in [notes.md](notes.md). `IsCreateObject`'s m2c jump-table
failure at assembly line 861 remains documented; no assembly or jump-table
metadata is modified.
