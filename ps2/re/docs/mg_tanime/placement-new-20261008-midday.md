# Texture-animation parks — October 8 midday

Checks use baseline `c79e57c`, MWCC 3.0-011126, the canonical flags/pragmas
and `chronicletwo_dev:sf-d8bf13c`. Word counts mask relocation operands and
check relocation identities separately. Both guarded functions remain
unpromoted; no source, shared-header or profile change is retained.

## List-node allocation

`NewTexAnimeData` constructs a texture-animation record in a `CList` node
from the supplied memory stack. The pinned baseline reproduces 6/32
differing words, 0x7C code against retail's 0x80 extent. The recorded
constructor-classification and null-path/result-lifetime analysis remains
applicable. Upstream's assignment-outlining notes and nested float-argument
selectors supply no new genuine array initialization or constructor body
for this node. Recorded constructor-spelling and specialization experiments
are not repeated.

## Drawing and advancing records

`TexAnime` submits palette/image copies and wrapped sprite rectangles for
enabled texture-animation groups, advances their scroll/wave phases, and
selects subsequent records according to their wait counters. Its baseline
is 660/1304 differing words, with 0x1450 code against retail's 0x1460 extent.

An alignment diagnostic masks branch distances in addition to relocated
operands, then aligns instruction words. Apart from retail's trailing
zero padding, it finds only four nop differences: one extra draft nop at
`+0x7A4`, one missing in the indexed Y-period join near `+0x81C`, and two
missing in the true-colour Y-period/wave join region `+0xA70..+0xA9C`.
The nonzero instruction words otherwise align. This diagnostic is not a
byte-match test; ordinary canonical comparison still reports 660/1304.

| Source or optimizer probe | Words different |
|---|---:|
| Remove self-assignment scaffolding | 662/1304 |
| Also replace group byte accesses with typed member-array indexing | 1145/1304 |
| Use short framebuffer-height locals | 906/1308 |
| Normalize periods with conditional expressions | 746/1308 |
| Combine both preceding changes | 923/1316 |
| Separate X-period or wave-phase declaration and assignment | 660/1304 |
| Initialize indexed Y-period and numerator at declaration | 661/1304 |
| Initialize true-colour Y-period and numerator at declaration | 664/1304 |
| Use a switch for true-colour scroll versus wave | 696/1304 |
| Keep distinct signed and normalized period locals | 660, 661 or 664/1304 |
| Disable lifetime optimization, propagation or loop invariants individually | 660/1304 |
| Disable peephole optimization | 1427/1522 |

Multiplying the indexed X period by `-1.0f` gives an apparent 174/1304
positional improvement, with a 0x1458 body. The aligned comparison exposes
the reason: a `lui`, `mtc1`, nop and `mul.s` replace retail's single
`neg.s`, and their extra length offsets the missing nops later. It does
not fix the retail operation or the joins, so it is rejected rather than
retained as progress. Applying that spelling to all four normalizations
gives 792/1314 and adds still more non-retail instructions.

The current guarded draft also contains inherited raw object-field byte
accesses and self-assignment scaffolding. A valid promotion must recover
natural field expressions and reproduce the joins together; adding source
padding or choosing longer arithmetic to compensate for them is not a fix.
