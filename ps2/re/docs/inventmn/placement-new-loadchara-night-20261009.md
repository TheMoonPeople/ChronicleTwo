# Inventory character loading and natural construction

## Scope, types, and behavior

`CMenuInvent::LoadCharaCheck`, at 0x002022a0, advances the inventory preview
character's asynchronous load. The actual retail GLOBAL/FUNC symbol is
0x4d8 bytes, followed by eight zero bytes within its 0x4e0 layout extent.
The inherited header records the extent; its comment correction is retained
as a private proposal because this lane does not own shared headers.

The existing inventory, character, object, background-read, memory-stack,
texture-manager and menu-form analyses supply the dependent types and APIs.
The fresh pn15 `decompile.sh LoadCharaCheck__11CMenuInventFv` analysis succeeds.
No header layout, constructor, special member, generated assembly or vtable
definition changes for this match.

State zero detaches the displayed character, requests its equipped model,
clears the auxiliary character and starts `menu/chara4/camera.pac` when the
photo-only mode needs it. The background-file reservation retains the actual
unsigned byte-to-quadword round-up expression. State one waits for background
I/O, completes the main character's model, restores the hat attachment and
disables lighting on its object frame. The `CObjectFrame::frame` qualification
selects that real inherited pointer rather than `CCharacter2`'s animation
frame value.

If the camera pack exists, the function resets the character stack, uses the
`_mn` texture suffix, loads `c01_camera.chr`, constructs the auxiliary
`CActionChara`, loads `camera.chr` with the main character as its parent,
attaches it at `ef00` and selects the camera-standing motion. The main
character is positioned at (15,-29,14) for photo-only mode without the album,
or (20,-29,14) otherwise. It takes the existing rotation, advances once,
runs the thinking-mode script and is attached to the polygon form. State two
continues stepping the character; state -1 does no work.

## Natural source and compiler controls

The fresh canonical source differs by 190 words, with native body 0x48c.
One exact after-inline `CActionChara` construction row reduces this to 145
words and body 0x4a8. The inherited `NewInventActionChara` wrapper consumes an
additional inline level: the base `CObject` constructor remains out of line.
Writing the ordinary placement expression directly restores the existing
base-constructor and Initialize chain, giving twelve words and the exact
0x4d8 body. This uses the existing meaningful `StackBlocks(sizeof(CActionChara))`
reservation, including its two reserve blocks. No new helper, inliner pragma,
dummy local or handwritten constructor is supplied.

The selected placement policy is exactly `inventmn.cpp`,
`LoadCharaCheck__11CMenuInventFv`, allocator `__nw__FUiP1`, constructor
`__ct__12CActionCharaFv`, `after_constructor_inline`, and
`expected_matches: 1`. The compiler provides the normal mangled identity and
actual class-6 construction witness. The existing `IsCreateObject` two-match
row remains unchanged and continues to report two matches.

The remaining twelve words concern materializing the two SetPosition calls'
real constants. The old six XYZ temporaries and conversion spellings are
replaced by the direct calls above. The existing semantic float capability
resolves `SetPosition__11CCharacter2Ffff`. Two rows suffice:

- Binary32 14.0f (`0x41600000`) evaluates before formal slot one, with
  `evaluate_first: false` and `expected_matches: 2`.
- Binary32 -29.0f (`0xc1e80000`) evaluates before formal slot three, with
  `evaluate_first: false` and `expected_matches: 1`, restricted by the actual
  slot-one argument 20.0f (`0x41a00000`).

Formal slot zero is the receiver. These dependencies reproduce Z,X,Y in the
15.0f call and Y,Z,X in the 20.0f call. Selecting either call alone retains
six differing words; combining the dependencies reaches zero. A three-row
per-call control also reaches zero, and its entire native object is identical
to the smaller two-row policy. Matching uses real call/argument semantics
and positive occurrence assertions, never instruction offsets or arena
addresses.

The load buffer uses the existing `stGetTop()` API. Ten string aliases are
recovered from retail bytes and inlined, including the standing,
camera-standing and thinking-mode Shift-JIS names represented by fixed-width
octal escapes. Declarations and storage markers are removed only for strings
without another consumer. The shared standing and thinking-mode storage
remains for other callers. No LIT alias or replacement padding is introduced.
These source cleanups preserve the twelve-word control before float policy.

## Complete object evidence

All 115 other retail-owned native function bodies and their normalized
relocation targets retain their control values. Nine raw anonymous-reference
suffix changes resolve to the same literal bytes. An expanded audit also
records two foreign emitted inline functions disappearing:
`Initialize__19CCharaFrameMatchingFv` (owned by editmenu) and
`__ct__12CObjectFrameFv` (owned by mapload). Their definitions are absorbed
into this constructor path, so this is not a claim that every emitted
nonselected helper remains present. The other 119 emitted functions retain
their instruction bodies and normalized references. The failed initial
all-helper invariance assertion is preserved with the corrected inventory.

Both the three-row and smaller two-row promoted private sources pass the
complete production wrapper, postprocessing, section fixup and resolved
object check: 0xff1c bytes and 2,826 relocations. The two-row fixed object has
SHA-256 `127a23017c683d0c19cdd25799cb656f31dc0fd2fcbf25ee70b136b3b7f5e4e7`.
The wrapper checks the full unit's instructions, original data pieces and
resolved references, beyond the selected function's diagnostic score.

Controls, source/profile inputs, literal recovery, type/symbol evidence,
nonselected audits, wrapper provenance and explicit statuses are under
`.private/pntc/inventmn-loadchara-natural/`. The owning receipt for the
smaller policy is `promotion/wrapper-two-rows.log` and its zero status, with
the four stages recorded in `outputs/promotion-two-rows/wrapped/provenance.json`.
Tracked promotion still requires the game build, all object checks, baseline
artifact comparison and refreshed progress.

## Promotion acceptance

The final private binding audit also preserves all 115 other owned function
symbol shapes and the one emitted vtable, including size, binding, value,
section type/flags/alignment, bytes and named vtable relocations. It is saved
as `binding-audit.json` with its explicit zero status.

The manually unguarded source and grouped two-float/one-placement policy pass
the pn15 clean game build, PAL verifier and all 149 complete object checks.
The inventory unit retains the privately checked 0xff1c bytes and 2,826
relocations. Across the 31-caller group, all 306 assembled objects and 149
native base objects outside the nineteen promoted units retain their exact
baseline hashes. Linked main bytes retain SHA-256
`a103b0461a88e443a3af684cf150c05b5bd355e5a97ab2dc029c4d872bed0811`, and
loaded memory ends at 0x01f64a00. Whole ELF metadata is allowed to differ.

The explicit context/objdiff refresh, followed by host coverage, reports
6,780 matched / 82 guarded / ten assembly-only / zero fuzzy. Acceptance
receipts are `.private/pntc/receipts/promote-thirty-one-{clean-build,objects,artifacts,progress,coverage}`,
including logs, explicit zero statuses and the artifact JSON. The initial
successful incremental build used the same selectors before their final
unit grouping; clean acceptance uses the final grouped profile.

## Current design reference

This dated evidence retains its original measurement scope.
[The consolidated placement-conversion design](../satansfiddle/placement-new.md) owns the current
capability, activation rows, safety requirements, and accepted source status.
