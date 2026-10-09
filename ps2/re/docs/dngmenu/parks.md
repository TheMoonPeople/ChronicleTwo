# dngmenu remainder after r2 — October 8

Current source: all 48 functions are native and exact; Step's later
promotion resolves the last assembly gap. The older scores below record
the route to those matches. Upstream supplies the exact `CheckIsViewMove` implementation and
its translation-unit helper seed; its former park is resolved.
The r2 baseline at `2f71f10` was 34/13/1. All assigned targets were
remeasured with the merged SF profile before experiments. Rows below use SF
diagnostic differing words (including retail padding), or body/retail bytes
when the body exceeds retail. Detailed disassemblies are saved privately.
Only complete-unit canonical checks authorize the two native promotions;
see [r2.md](r2.md).

## Assigned targets and historical scores

| Target | SF baseline → retained result | Status and concrete reconsideration trigger |
|---|---|---|
| `CheckGeoramaMateria__FP22TRESURE_BOX_FLOOR_INFOiPi` | 6/112 → exact | Promoted. Reusing the completed group-search index for item traversal fixes the induction allocation. Complete-unit byte/relocation check passes. |
| `MsgInit__12CMenuTreeMapFv` | 7/116 → **exact** (nmparked-r1) | Promoted. The first line's screen X and half line width are named values updated in place (`x >>= 2; width >>= 1;`), so they colour after the X temporaries and the height load keeps `v1`, whose reuse pins retail's schedule; see [night-20261008.md](night-20261008.md). |
| `LoadDngInfo__11CDngFreeMapFP9mgCMemoryiiii` | 31/1016 → 10/1016 (nmparked) → 0/1016 (nmparked-r1) → **exact**, promoted (dngmenu-r0) | Promoted. Its pointer and direction tables are function statics; the 14 point tables stay at file scope because MWCC numbers native statics `$1522..` instead of retail's `$2230..`, and the postprocessor cannot identify a local table reached only through a pointer table. See [night-20261008.md](night-20261008.md). |
| `DrawRoot__11CDngFreeMapF9mgRect_f_P16DNGMAP_ROOT_INFOiUii` | 781/844, 0xD08/0xD30 → 708/844, 0xCEC/0xD30 | Earlier guarded stage: event tints share retail's single branch. Shapes 4 and 5 are excluded from the five-pixel adjustment, and dispatch is an ordered comparison chain. Root/marks/opacity and color/mark saved registers and individual shape loops still differ. Reconsider with a case-zero lifetime map and the default/event color register map before changing the other shapes. → 6/844 at 0xD2C → **exact**, promoted (see night-20261008.md). |
| `DrawRoomOne__11CDngFreeMapF9mgRect_f_P16DNGMAP_ROOM_INFOUiif` | 553/584, 0x8A8/0x920 → exact | Promoted in night round 1. The glyph table is read as flat halfwords with `[i << 2]` indexing, which shares the destination table's `i * 4` induction; a `tex_no` local read before the visited test fills the branch delay slot; the colour components are assigned `b = g = r`. Complete-unit byte/relocation check passes; see [night-20261008.md](night-20261008.md). |
| `DrawDngRoomInfo__FP16DNGMAP_ROOM_INFO` | 506/712 → 65/712 (nmparked) → **0/712**, 0xB18 (nmparked-r1) | Exact. Separate icon X, inline `ix + width` right edges, board Y assigned in the first strip argument and both row counters chained from one conversion; see [night-20261008.md](night-20261008.md). |
| `Step__12CMenuTreeMapFv` | 1506/1548, 0x1734/0x1830 → 1488/1548 → **0/1548**, 0x1828 body | Promoted after complete-unit validation. Natural mode switch, question-message timing, selection-change flag and later key/message/result lifetimes recover the retail body and frame. Its statics and data are native; see [night-20261008.md](night-20261008.md) and [stepclean-20261009.md](stepclean-20261009.md). |
| `InitEnd__12CMenuTreeMapFv` | 198/224, 0x364/0x380 → exact | Promoted. Cached floor bound, loader locals, sequential bounds, separate sub/boss checks, coordinate pair updates, output-size lifetime, and cursor state now match all 224 words and the complete unit. |
| `DrawGeoramaMateria__FiPciPii` | 0x404/0x400 → exact | Promoted in night round 1. One `x`/`y` pair shared by the title, list rows and page counter moves the spill to the right column like retail; the item width is read into `x` before the column test. Complete-unit byte/relocation check passes; see [night-20261008.md](night-20261008.md). |
| `Draw__11CDngFreeMapFv` | 0x628/0x610 (353/394 detailed words) → exact | Promoted in the midday lane. Retained texture/manager, temporary mark rectangle, local-font access, typed room pointer, positive conditions, debug Y base, ordered query calls with moon/sun/normal declarations, and separate ON/OFF calls reproduce the complete unit; see [midday.md](midday.md). |
| `Draw__12CMenuTreeMapFv` | 446/460, 0x6E0/0x730 → exact | Promoted in the midday lane. Restored numeral alpha and money-digit Color, manager lifetime, ordered wrap comparison, 32-byte numeral buffer, separate board temporaries, named digit rectangle, coordinate pair, cursor branches, and signed question flag. Complete-unit byte/relocation check passes; see [midday.md](midday.md). |

## Constructor and emission remainders

`DngTreeMapInit__FP9mgCMemoryPiii` is exact and native (0x3F8 bytes in its
0x400 reservation). The opening modes are a `switch` whose `MENU_OPEN_MAIN_TOWN`
and `MENU_OPEN_DNG_TREE_MAP` cases share the separate-map block, and the
cursor buffer is a byte image pointer converted for `LoadFileMenu`; see
[night-20261008.md](night-20261008.md).

`Init__6ClsMesFv` is emitted natively from the unchanged shared header by the
natural tree-map constructor, as [clsmes-init-proposal.md](clsmes-init-proposal.md)
predicted; its assembly marker is removed.

No VU0/COP2 inline-code blocker was identified in this unit. No ledger rows
or compiler-profile rows were added in r2. One-hypothesis experiment logs are
private at `.private/experiments-dngmenu-r2.md`; receipts for final acceptance
are at `.private/receipts/r2-final/`.
