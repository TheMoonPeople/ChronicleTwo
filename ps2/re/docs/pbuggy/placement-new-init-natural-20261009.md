# Buggy initialization: accepted natural construction

`sgInitBuggy__FP11SubGameInfo` has a genuinely typed private C++ zero under
`chronicletwo_dev:sf-63f7a9e-pn15`, with the captured production31 profile plus
one witnessed constructor-conversion row. The privately unguarded complete
unit passes compilation, postprocessing, section fixup and the canonical
checker: **0x34B0 bytes / 834 resolved relocations**. Subsequent canonical
production33 acceptance is recorded below.

Retail is GLOBAL/FUNC (`st_info 0x12`) at **0x318B70**, actual body **0x994**.
Its **0x9A0** reservation includes twelve independently verified zero bytes.
The native zero has the actual 0x994 size, equal instruction words and equal
relocation geometry. The owning header's 0x9A0 annotation is an extent; the
exact comment-only correction is `.private/proposals/pbuggy-init-body-size.patch`.
The shared header remains untouched.

## Analysis and actual interfaces

The complete pbuggy note, MWCC instructions, existing effect/subgame/memory,
scene loading/sound, packed-file, frame/character, camera and message type
notes/headers were consulted before reconstruction. Fresh mandatory pn15
`decompile.sh sgInitBuggy__FP11SubGameInfo` succeeds, producing 301 lines.
Its input/output and receipt are frozen under
`.private/pntc/pbuggy-init-natural/fresh-m2c.txt` and
`.private/pntc/receipts/pbuggy-init-m2c.log/.exit`.

The initializer divides the texture blocks consecutively: buggy, Porcuss,
Muccho, bomb, Starbull, gun, system, and then the five-block effect pool.
It requires the scene's current player, assigns work stack 5, deletes the
existing subgame texture blocks, loads the buggy pack and seven character
resources, obtains their real scene objects, and activates the observed
slots. Bomb receives a texture block without the sibling activation call.
Missing player, character, required model frame, pack load or assigned effect
returns zero at the observed checkpoints; optional packed resources preserve
their retail skip behavior.

The scene slots are the actual contiguous 0x40..0x46 records, named by the
source-local `BuggySceneChara` enum. `SubGameInfo::scene`, `texb` and `texb_num`
are the existing +0/+4/+8 members. `CScene` supplies its real `read_buff`,
stack, texture/character/effect, camera and message APIs. The serial pack is
viewed as words only at the documented `GetPackFile` interfaces; the image
copy is an actual returned byte buffer. No object field is reached through
byte-address arithmetic or a fake aggregate view.

`CCharacter2::frame` is its floating animation counter. The root model at
+0x70 is **`CObjectFrame::frame`**, explicitly qualified in the source.
The two passengers follow `polcurse_chair` and `macho_chair`; the muzzle
model follows `dcol00`. The actual `cyl68` and `obj290` frames have their
existing `mgCFrameAttr::draw` fields cleared. The player's packed model call
is its actual virtual **LoadPack** slot, not its sibling LoadPackNoLine.
The gun resources pass **no_outline=1**, verified from the real stack-argument
`sd 1,0(sp)` instructions; m2c's guessed final zero argument is incorrect.

The image byte count is written by `GetPackFile(..., int*)`. Its real block
count uses unsigned shift and the nonzero remainder branch, then copies the
reported bytes into the returned storage and enters the IMG through the
texture manager. `WorkBuff` is the four-byte LOCAL pointer to a genuine
160000-byte array; its source declaration is corrected from int to `u_char*`.
Its allocator request is 10002 quadwords, expressed from the actual byte
capacity plus the observed two-quadword reserve. **EffectBuff receives 20000
quadwords (320000 bytes)**, not the 20000 bytes stated in the older pbuggy note.

`CEffectScriptMan` is the existing 0x1190-byte type. Its embedded 0x50-byte
`mgC3DSprite` starts at +0x30, with the sprite vptr at +0x4C. The genuine
existing manager constructor naturally performs the base/derived sprite
construction and `Initialize(NULL,-1,-1)`. Ordinary whole-object placement
new supplies that chain; no source vtable store, explicit ctor call, fake
sprite-state layout or hand-written special member is retained. The manager
then uses the real work pool, read buffer and texture pool, loads the two
actual Shift-JIS effects and becomes scene effect 7. Retail continues to
initialize the result even when allocation returns null; no new failure
check changes that behavior.

Sound uses the existing `SND_PORT_ENEMY` identity, then the real BGM APIs.
The buggy/bomb initialization calls and player motion/reset remain in order.
The camera is the observed CCameraControl reached through GetCamera; its
real inherited virtual **Step(-1)** slot is called after SetRotate/RotBack.
The message uses `MES_PRESET_WINDOW` and `MES_WIN_VERSATILE_1`. Its +0x158
write is **fukidashi_pos=8**, not the spurious `tbl[1].color` field inferred
by the m2c context. The existing sgCPlayVoice fields are reset individually;
its file number is not overwritten. All referenced type/API contracts are
already documented by their owning units; matched callees are not reanalyzed.

## Witnessed conversion and bounded source controls

A plain-wibo read-only normal compiler observation establishes exactly one
scalar root, eligible class6. The actual caller, allocator and constructor
names are read from cached normal fields or actual normal mangler returns:

```json
{
  "translation_unit": "pbuggy.cpp",
  "function": "sgInitBuggy__FP11SubGameInfo",
  "allocator": "__nw__FUiP1",
  "constructor": "__ct__16CEffectScriptManFv",
  "conversion": "after_constructor_inline",
  "expected_matches": 1
}
```

`normal-witness-natural-cleanup.json` and
`observe-normal-witness-natural-cleanup/observations.json` bind this root to
the exact final guarded source SHA-256
`0cc855afe53aea1038ef5cbc8b013d97d8d9332a3db79dd7a27119fdd256486a`.
No guest data is written and the mangler is not invoked manually. The normal
observer's entire selected body, binding/size/value and every named relocation
are independently equal to the source-only production31 control. The byte-array
allocation is not another eligible scalar constructor. No floating row is added.

The four successful admissible native controls are the natural reconstructed
body, the same body with the exact row, actual enum/size/unused-declaration
cleanup, and that cleanup with the exact row. Their results are **2,0,2,0**;
all are 0x994 bytes with the exact relocation map. The source-only pair differs
only at +0x6C0/+0x6C4: retail branches on allocator v0 and copies to s2 in
the delay slot; ordinary lowering copies first and branches on s2. The row
resolves precisely that constructor-result boundary. Both source-only controls
have the same complete raw object SHA-256 `5ed0ca9a...59ec5f`; both row controls
have the same complete raw object SHA-256 `1d27ec69...adf6b8`. These are actual
object equalities, not an inference from equal word scores.

The older pre-vtable-cleanup source was consulted only as historical structure
and checked against m2c/retail, then stripped of all explicit sprite construction
and five unused motion-name locals. The reconstructed current source uses real
APIs and storage; the historical bad member view is never compiled or promoted.
No optimization/depth/helper-mask tuning, extra state, dummy local, invented
helper, manual vtable, type pun, inline asm or LIT alias supplies this zero.

## Complete audits and frozen proposal

Across all four admissible controls, **24 other emitted functions**, **20 other
manifest score rows**, and **46 original allocated data objects** preserve their
complete bodies, bindings, symbol/section sizes, values, relocation offsets,
types, targets/addends and contents. No generated-name correspondence is needed.
The sole extra native function is this actual initializer. The unit emits no
vtable definition; the two actual sprite vtables are external targets resolved
by the complete checker. No unrelated unit or header is changed.

All **23** added LOCAL null-terminated strings have unique actual retail
counterparts. `literal-proof.json` verifies full bytes, declared size, binding,
normal 8/16 alignment and their exact selected consumers. Shift-JIS strings
are inline exact-byte literals. Nineteen obsolete source declarations are
removed; existing assembly data markers remain until full unit data migration.
`full-audit.json` records every original object, selected relocation and witness
calibration, and the strict complete private wrapper independently resolves
all 834 unit relocations against retail.

Private receipt prefix: `.private/pntc/pbuggy-init-natural/`. Exact proposals
are `.private/proposals/pbuggy-init-guarded-natural.patch`,
`pbuggy-init-validated-source.patch`, the unowned comment-only header patch,
and `row-delta.json`. All apply-checks pass. The privately unguarded source
SHA-256 is `9cfc13f8f0a50705a2174eda81daee1091f2e33a8a511e36050bde4a82567b18`;
profile SHA-256 is `c0b88fae637e7252f5e40de215b54b7025bbb3bce1a8988e097f752b235c4faf`.
The passing complete object SHA-256 is
`b97a0e2da61bcf0c8e8b3bb374052efde6e94d0ac8fc3ac43c99b342fa777dd4`.
`artifact-hashes.json` freezes 99 private files. Standard wrapper provenance
and all four logs are in `outputs/natural-cleanup-after/wrapped/`;
outer receipts are `.private/pntc/receipts/pbuggy-init-private-wrapper.*`,
`pbuggy-init-full-audit.*` and `pbuggy-init-literal-proof.*`.

Setup mistakes are preserved: the first retail-data script searched project
suffix names directly in the raw ELF and fails before output; the corrected
script resolves the unique actual address/symbol. The first draft fails on the
shadowed animation frame and base-camera return type. Its qualified successor
compiles but still contains the two wrong guessed outline flags and sibling
load method, so its 431-word result is **not an admissible control**. Exact
corrected source and the independently audited zero supersede it. No failure
is relabeled as passing evidence or production acceptance.

## Canonical production33 acceptance

The guard is removed by hand and the exact privately validated natural source
is active. Its source and complete object hashes above match the clean
canonical outputs exactly. Only the witnessed expected-one after-inline row
is added for this caller; no float policy or shared header is changed. The
joint profile, including AssignFuncAnime, has 33 callers /43 static sites,
SHA-256 `1a86ec615aca8b4ded2e9173a059dcb3572188b4a3db721801f426c33c8bf099`.

The pn15 CLEAN build passes `SCES_511.90: OK` and all 149 resolved unit checks.
All 306 assembled and 149 source-only objects outside the 21 promoted units
are byte-identical to upstream. Linked main bytes retain SHA-256
`a103b0461a88e443a3af684cf150c05b5bd355e5a97ab2dc029c4d872bed0811`
and loaded memory ends at 0x01f64a00. The ELF metadata comparison is separate.
Explicit context/objdiff refresh followed by coverage reports 6,782 matched /
82 guarded /8 assembly-only /0 fuzzy; pbuggy has no remaining assembly-only
or guarded function.

The independent read-only pre-activation review and exact source/row/witness
correspondence are frozen in `.private/pntc/promotion-review-33/`. Full
acceptance receipts are `.private/pntc/receipts/promote-thirty-three-` with
`clean-build`, `objects`, `artifacts`, `progress` and `coverage` logs/zero exit
statuses, the artifact JSON, and `.private/pntc/promote33/acceptance.json`.
The comment-only owning-header size correction remains an unowned proposal.

## Current design reference

This dated evidence retains its original measurement scope.
[The consolidated placement-conversion design](../satansfiddle/placement-new.md) owns the current
capability, activation rows, safety requirements, and accepted source status.
