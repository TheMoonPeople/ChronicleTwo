# menuchr midday matching assessment

Historical probe record. Current exact matches and guarded remainders are
listed in [notes.md](notes.md); later promotions are documented in
[night-20261008.md](night-20261008.md).

October 8, 2026. Worktree `/home/dylan/projects/chronicletwo-menuchr-midday`,
branch `work/dc2-menuchr-midday`, pinned base `c79e57c`. No upstream merge or
rebase is performed. Image `chronicletwo_dev:sf-d8bf13c`, four build jobs.
This assessment supersedes the current-score claims in the dated earlier
[remaining-guard assessment](remaining-sf-r2.md).

## Results and all remaining guards

All scores count differing 32-bit words over the manifest retail extent,
including zero padding, with relocated operands masked by the supported
comparison. A promotion additionally passes complete-object checking with
resolved relocations and integrated validation.

| Function | Base | Retained | Best private result / remaining blocker |
| --- | ---: | ---: | --- |
| `MenuMemoryDivide` | 18/116 | **0; promoted** | Complete unit accepted; [memory evidence](midday-memory.md) |
| `CMosBookMenu::Draw` | 905/948 | **0; promoted** | Complete unit accepted; [book evidence](midday-book.md) |
| `CMenuChrCngMenu::EnterDataMenu` | 331/388 | 11/388 | 9 with a named message-array view, but shifted instructions; retained 11 is solely the NPC index/stride register swap |
| `CMenuCostumeSel::Draw` | 71/568 | 71/568 | 18 with private 36.0 selector; abs merge, int-to-float and shadow argument setup |
| `MenuItemCharaDataLoadEndCheckAfter` | 2/220 | 2/220 | Inline scene/list-constructor scheduling |
| `LoadBGNPCModel` | 2/120 | 2/120 | Placement-new branch/result-copy order; no supported natural constructor change |
| `CMenuCostumeSel::LoadMenuData` | 2/228 | 2/228 | Same placement-new lowering |
| `CMosBookMenu::KeyStep` | 2/340 | 2/340 | Same placement-new lowering |
| `CMenuChrCngMenu::KeyChangeMain` | 1998/2152 | 1792/2152 | NPC/action dispatch and local/register correspondence |
| `CMenuMosSelect::KeyStep` | 1154/1660 | 843/1660 | Step dispatch, state branches, and later induction/stack correspondence |
| `MenuCharaChangeStarDraw` | 361/368 | 300/368 | Center/UV lifetime, saved registers, drawing/float schedule |
| `MenuCharaChangeInit` | 236/316 | 236/316 | Not retried; constructor-dependent parked initializer |
| `MenuCostumeInit` | 161/184 | 161/184 | Not retried; constructor-dependent parked initializer |

The final inventory has eleven guarded functions and no assembly-only
functions in menuchr. The three placement-new sites are remeasured and
reviewed against the existing constructor classification; no unsupported
constructor modification is attempted.

## EnterDataMenu: palette rows and independent command loops

Analysis uses `decompile.sh`, saved privately as `m2c-enter.c`, and the
already documented 0x36-byte `NPC_BASE_DATA`. Its signed ability count is
at 0x30 and its four unsigned ability costs begin at 0x32. Existing
`MENUFORMPARTS_TYPE`, texture, memory, and menu field declarations remain
unchanged.

The pack pointer is reinterpreted only at the pack-file and repair-data
interfaces. Naming a separate word-pointer alias reverses the incoming pack
and menu saved registers; retaining the actual pack parameter restores
retail's s0/s1 pair. The copied 256-entry CLUT is viewed as rows of four
unsigned bytes. This character-byte view permits typed channel indexing
without arbitrary byte-pointer offsets. The average RGB brightness is
integer-divided by three, converted to float, and assigned a band with
`8*(step-1) <= brightness < 8*step`. The loop includes band 32 (`step < 33`),
then stores red/green/blue scales 7.75, 5.625, and 4.6875 times the band.
Alpha is untouched. Initializing the palette index before its row cursor
restores their s2/s3 allocation.

The party form preserves the repeated locked-overlay store and the actual
available-party branch. Max and Monica consult the change-enable mask;
ridepod and monster do not use that human gate. Existing `USER_CHARA`
constants identify those bounds. File, script, texture, and form-name
strings are inline in the guarded source; their assembly data stays while
retail still supplies the guarded function.

NPC state is cleared in retail field order. Message IDs are first filled
for `ability_num`, then remaining command slots are cleared in a separate
loop. The empty-ability case assigns message 10 to slot zero. A separate
successive pair of loops sets costs and hides the unused cost parts. No
extra clamp on the first loop is inferred from the four-slot data contract.

E76 restores palette rows/bands (193 words). E77's NPC loops alone retain
other control differences (380); E78 combines them (201). Restoring the
party branch gives 84 (E79), using the pack parameter gives 22 (E80), and
the palette index/cursor declaration order gives 11 (E81). Eleven residual
words, +0x4E8 through +0x538, swap a1/a2 between the first command index and
its synthesized four-byte stride. The retained body is 0x608 in extent
0x610. Cost-loop correspondence afterward is exact.

E82–E97 and E107 test a separate cost index, commutative sums/conditions,
while/do-while forms, initialization placement, named message values,
and pointer/reference views of the message array. Ordinary rearrangements
leave 11. A named array view reaches nine but adds a base-address setup and
shifts the first loop; it does not resolve the desired register allocation
and is not retained. Initializing the command index before its message
lookup keeps it in a saved register. A future useful hypothesis should
preserve the proven palette/party/cost sequence and resolve the first
message loop's index/stride lifetimes.

## Costume drawing: stable selector limits

`m2c-costume-draw.c` confirms the camera/model, row shadows, labels, cursor,
font, and help-box sequence already represented by the draft. Private E01
selects binary32 36.0 (`0x42100000`) first only for
`DrawMenuFillBox__Fffffiiii`, reproducing the 18-word park. Its remaining
words lie at +0x2AC..+0x2F8: a nop at the absolute-sine merge, the right
integer-origin conversion's f0/f1 choice, and the shadow coordinates'
argument setup. This selector is not committed for an unmatched function.

The new nested selectors identify sibling *calls* and their inner constant
or variable arguments. Here the conflicting 4.0 literals occur in direct
arithmetic arguments of the arrow `PrimQuad` calls; the wave is computed
before those calls. There is no corresponding nested-call identity to
select without inventing source calls. E03–E06, E11–E14, and E18 instead
test natural coordinate declarations, separate conversions, named coordinate
arrays, and explicit floating construction. E61–E63 confirm that additional
simple 55.0/4.0/6.0 evaluate-first identities leave the same 18 words.
None resolves the merge and shadow schedule. Source and checked-in profile
for costume Draw remain unchanged. A future hypothesis needs a natural
abs/coordinate lifetime that removes the merge nop and gives the actual
per-site shadow operand sequence.

## Scene and placement-new parks

`m2c-scene.c` confirms the constructor/list call order. In the retained
scene draft, `addiu a0,sp,9280` occupies +0xF4, the preceding loop branch's
delay slot; retail places it at +0xFC, the list-initializer call's delay slot.
E23's temporary scene construction introduces a large copy; E24's named
reference changes escaping-address/register behavior and reaches 218 words.
Both are rejected, leaving two words in the existing 0x368-byte body.

The existing [constructor classification](../funcpoint/placement-new.md)
shows that `CActionChara` traverses heterogeneous base construction and
out-of-line base initialization. It supplies no genuinely natural homogeneous
array-construction change for these three sites. Their two-word placement-new
branch/move differences are unchanged. Earlier parenthesized allocation,
assignment, cast, and synthetic constructor experiments are not repeated.
No shared header is edited and no speculative header patch is proposed.

## Larger state and effect drafts

`m2c-keychange.c` establishes the positive NPC page-count gates and dispatch
shape. `GetUseableEsaNo` is already decompiled in menuaqua and writes the
food-list entry at index 8, so the old eight-entry caller buffer is too small.
Retail reserves 0x80 bytes at stack 0x130 through the following local at
0x1B0. The retained `NPC_GIFT_FOOD_CAPACITY` is 32, restoring the 0x1D0
frame. This is a real caller-buffer correction; no new callee analysis or
shared-header edit is needed. E103 makes this correction, E104 restores the
menu-open switch using `MENU_OPEN_CHARA_CHANGE`, and E121 adds the observed
positive page-count gates around the two scans. They reduce 1998 to 1792,
body 0x2198 within extent 0x21A0. Explicit else resets (E122) are worse.
Further progress requires region-by-region NPC action and field-access
correspondence, rather than compiler-profile rows.

`m2c-mos-keystep.c` confirms retail's two null checks before reading a
selected badge's enable byte. Preserving the second check in the existing
failure condition restores the eight-byte inner null branch and reduces 1154 to
843 words (E109), with body equal to extent 0x19F0. E105 is rejected because
its branch rewrite loses the failure behavior for disabled badges. A nested
step switch (E123) grows the body; naming the answer-message pointer (E124)
leaves 843. The retained condition preserves the original success/failure
semantics while expressing both observed guards. Later step dispatch and
induction/local-layout regions still need reconstruction.

`m2c-star-draw.c` confirms that absolute pulse is computed before reading
star alpha for `0.5f * alpha * pulse`. The retained effect draft fixes that
read/operation order, uses the actual fan/sprite primitive enums, and uses
the manager directly (E17). It reduces 361 to 300, body 0x58C in extent
0x5C0. It remains guarded. Retail retains the manager in s0; the original
named-pointer draft instead retains a center-Y interior address and assigns
the manager to s5. Removing the pointer improves this measurement but does
not establish retail's lifetime. E15–E21, E31–E33, E106, and E110–E116 test
manager placement/reference/cast, separate ring angle/position, a coordinate
array, and aggregate assignment boundaries. Their best named-manager form
is 336 words. A useful future hypothesis must restore center and UV storage
lifetimes before reconsidering manager allocation or individual float order.

## Final acceptance

`final/drafts.log` has 77 MATCH /11 DIFF /0 missing drafts across 88 functions.
Every previously matched function stays matched; only the two promoted
functions change status, and the four retained guarded drafts improve.

`final/objects.log` accepts menuchr with 0x11CC4 allocated bytes and 3,745
resolved relocations. It accepts 147/149 complete game units. The only
failures remain `nd_meswin/DrawMesWin` and `actscript/_SHOT`, one problem each.
The PAL verifier lines in `final/build.log` equal the baseline exactly:
0x26 differing `.text` bytes, first 0x0015C5AD in DrawMesWin +0x6FD; the other
nine file-backed sections and BSS end 0x01F64A00 pass. This is not a whole-PAL
retail-match claim.

Final coverage is 6,688 matched /167 guarded /15 assembly-only /2 fuzzy;
menuchr has 77 matched /11 guarded /0 assembly-only /0 fuzzy. Final object
hashes change only `menuchr.cpp.o`; all 148 other raw object files equal their
base SHA-256 hashes. No header, toolchain, SDK/VU0 unit, other unit's source,
or other unit's profile rows change. There are no unowned-file proposals.

Receipts stay private under `.private/menuchr-midday/`: baseline build/object/
coverage/hash files; memory and book acceptance receipts linked in their
notes; all E00–E124 probes; and `final/build.log`, `final/objects.log`,
`final/drafts.log`, `final/coverage.txt`, `final/functions.tsv`,
`final/coverage-build.log`, `final/hashes.json`, and `final/acceptance.json`.
