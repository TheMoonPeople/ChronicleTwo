# Invention result construction and native source (2026-10-08/09)

## Scope and type authority

`CMenuInvent::IsCreateObject(int mode, int keys)` is the menu's asynchronous
invention-result update at 0x00203e90. Its actual retail GLOBAL/FUNC symbol
(info 0x12) is 0x1588 bytes; the next function starts at 0x00205420, making
its layout extent 0x1590. The inherited header's @size records that extent.
An exact documentation correction is kept as a private shared-header proposal;
this lane does not own the header.

The existing [unit notes](notes.md), [midday review](midday.md),
[near-miss review](nearmiss-20261008.md), and
[other natural allocation review](placement-new-natural-night-20261009.md)
were read before these controls. Their already established layouts supply
`CMenuInvent`, its base menu, `INVENT_DATA_INFO`, `CInventDataManage`,
`USER_PICTURE_INFO`, the menu forms/messages, `mgCMemory`, `CActionChara`,
`CCharacter2`, `mgCFrame`/`mgCFrameAttr`, and the background-file records.
No special member or vtable is supplied by hand. The existing class headers
continue to define their sizes, fields, and APIs.

The mandated pn15 `decompile.sh IsCreateObject__11CMenuInventFii` attempt
retains the known unresolved jump table at assembly line 861. Its fresh
receipt is `.private/pntc/inventmn-create-natural/m2c.log`. The required
decompiler attempt, earlier type analysis, and actual retail instructions
are the analysis inputs; no generated assembly or jump table was changed.

## Behavior

The first state confirms or cancels invention. An existing positive item ID
marks the selected recipe as created. Otherwise the function searches the
current recipe table, skips already created items, compares each of three
required idea IDs with the three selected slots, and records the matched
slots. Two matches select the partial-result path and identify the missing
slot. The table pointer and signed count are read again on each iteration;
typed indexing retains that behavior.

The display states wait for the background model and character sequence,
select the success, partial-result or failure script, and attach the result
model to its polygon form. Successful items use a scaled rotating model with
a damped sine wobble; the debug path adjusts real scale/position values using
the documented main-loop controller. Partial results mask the guessed idea
name and blink the missing message line. The jingle state schedules the
message, restores menu music, and eventually allows confirmation/cancellation
to reset the forms, effect pointer, circle, cursor and gradation.

A second state machine advances background I/O independently. It loads the
thinking character plus `menu/inventsub.pac`, preserves the current menu
character's position and rotation while replacing its pack, and creates the
result effect from `inv_ng.mds` or `inv_ok.mds`. The effect's frame disables
lighting, takes RGBA (255,255,255,128), and is placed at (18,-20,20). Success
also allocates and loads the actual item character. Subsequent states read
the selected sound bank, initialize the sound port and open/play/close the
result stream. These are ordinary C++ calls through the existing typed APIs;
no new fallback behavior or default file size is introduced.

## Data and source audit

- The old `FoundSlots` copy is a real three-int automatic match array. Retail
  loads its twelve zero bytes from `at_2776` (0x01efb3c8), which lies beyond
  PT_LOAD's file-backed end and within its zero-filled memory tail. The old
  BSS marker spans 24 bytes, including twelve bytes after the actual symbol.
  `int found[3] = {0,0,0}` supplies the actual initializer without a fabricated
  record or copy assignment.
- The old `PathPrefix` quadword record is a 64-byte text buffer. Its bytes at
  0x003532f0 are `menu/chara4/`, its terminator and 52 zero bytes. A real
  `char path[64]` initializer is placed after stack alignment, followed by
  `c01_success.chr`, `c01_regret.chr` or `c01_failure.chr`. No record-to-char
  cast remains.
- `jp_conv_lentbl_2835` is the real twelve-byte Japanese name-mask table at
  0x003532e0: 2,2,2,4,4,8,6,4,6,14,10,6. The inherited `D_003532DF` alias
  points one byte before it. The source uses the typed table at
  `half_length - 1`; it replaces one two-byte character with bytes 0x81/0x9a
  and retains the existing name terminator. This is masking, not a guessed
  truncation operation. The table is defined as an ordinary source array.
- `Tb_2819` contains the Japanese fallback `うーん` and six `Ummm` entries;
  `gobitbl_2847` contains the two Japanese guess suffixes. The outcome tables
  select `inv_ng.mds`/`inv_ok.mds`, SP_008/SP_009 sound banks, and wave suffixes
  200/190/180. `sndtimetbl_2868` gives 210/280 frames. These existing named
  tables retain their definitions and indexing; their bytes and pointer
  targets are recorded in the private table audit.
- Every target string alias is recovered from retail bytes and used as an
  ordinary literal. Shift-JIS is written with hex escapes.
  Declarations/markers are removed only when no consumer remains. No LIT
  alias is introduced.
- Recipe entries use `&table->table[recipe_index]`, rather than a byte offset
  and a cast. The model reservation has a real `model_bytes` value derived
  from quadwords and the allocator's existing unsigned round-up expression.
  Character placement uses the existing meaningful block-rounding utility
  with `sizeof(CActionChara)` directly, removing the constructor wrapper from
  this function. Dead `step`/`effect_y` locals are removed; the wobble step is
  the ordinary -0.02f literal. Redundant same-type frame and file-name casts
  are removed. Controller declarations come from `mainloop.hpp`.
- The remaining byte-pointer addition places the second serialized file after
  the first file's 16-byte boundary. It is actual file-buffer traversal, not
  a field-address substitute. The existing signed-byte name buffer uses the
  C string APIs' char view; no numeric or object reference is type-punned.

## Measured compiler scope and controls

The fresh pn15 canonical draft is 380 words different. The two exact
`CActionChara` placement expressions under after-constructor-inline conversion
reduce it to four words, with body 0x1588 in extent 0x1590 and equal relocation
positions/types. Direct placement expressions give the same result as the
inherited constructor wrapper. Typed recipes, the real path and match array,
literal recovery and removal of the unused locals all preserve those four.

The residual changes only the integer materialization and FPR transfers for
20.0f/-20.0f at offsets 0x1064, 0x1070, 0x1074 and 0x1078. The existing float
capability resolves the actual virtual call identity
`SetPosition__11CCharacter2Ffff`. Selecting binary32 20.0f (`0x41a00000`),
`evaluate_first: false`, `evaluate_before: 2`, and `expected_matches: 1`
reproduces the retail argument order. Formal slot zero is the receiver;
slot two is the Y argument. The selected constant is the Z argument, and
its one-match assertion is independent of semantic identity.

The placement row selects `inventmn.cpp`,
`IsCreateObject__11CMenuInventFii`, `__nw__FUiP1`,
`__ct__12CActionCharaFv`, after-constructor-inline conversion and count two.
Both roots retain normal mangled witnesses and real class-6 eligibility.
The float row asserts one actual argument match. No instruction, ordinal,
compiler-arena address or incidental source line selects either capability.

20.0f evaluate-first and evaluation before the X argument retain four words;
evaluation of -20.0f before Z also retains four. Replacing the real byte-to-
block conversion with `Alloc(model_blocks)` changes 505 words and relocation
positions; that source simplification is rejected. A meaningful unsigned
byte-count local preserves zero. Literal -0.02f, typed frame access, the real
Japanese table and its source definition each preserve zero independently.
The selected complete source is checked again after combining the cleanup.
All 115 nonselected diagnostic rows retain instruction bodies and normalized
relocation targets; some compiler-generated anonymous data numbers move,
which is recorded separately from a changed data target.

Private inputs, explicit compiler statuses, native objects, scores, instruction
diffs, initializer/table evidence and nonselected audits are under
`.private/pntc/inventmn-create-natural/`. A diagnostic zero is not complete
unit acceptance. The guard and profile rows require the full wrapper,
resolved-object, unrelated-artifact and PAL checks before promotion.

## Complete data-piece check

The complete wrapper needs the existing `at_2776` storage marker and both
the `D_003532DF` one-byte alignment piece and the Japanese table's storage
marker. The typed source has no reference to the shifted alias. Its generated
table address has a -1 addend, so the existing local-data binder resolves that
reference through the preceding retail piece and discards the checked native
copy. Removing the table marker then leaves its storage absent. The automatic
match initializer similarly binds to the original zero storage, whose full
piece includes the following twelve-byte gap. Retaining these proven pieces
introduces no padding array, data alias in the function, or substitute type.

The first complete build caught these missing pieces despite zero function
instructions. After restoring their storage, the resolved object check passes
the entire invention unit: 0xff24 bytes and 2,822 relocations. The matching
inventory selector unit also passes. Receipts are
`.private/pntc/receipts/promote-twenty-seven-layout2.log` and its explicit zero
status. Full PAL and unrelated-artifact acceptance remain separate checks.

The final 27-caller group passes PAL verification and all 149 complete object
checks on pn15. All 306 assembled objects and 149 source-only objects outside
the eighteen promoted units retain baseline hashes. Linked main bytes retain
SHA-256 `a103b0461a88e443a3af684cf150c05b5bd355e5a97ab2dc029c4d872bed0811`,
and the memory end remains 0x01f64a00. Whole ELF metadata differs, as expected
when native definitions replace assembly. Explicit context/objdiff refresh
reports 6,776 matched, 86 guarded drafts, ten assembly-only and zero fuzzy.
The manually removed guard is accepted only after those checks. Receipts are
`.private/pntc/receipts/promote-twenty-seven-{final-build,objects,artifacts,progress,coverage}`
with logs, explicit zero statuses and the artifact JSON.

## Current design reference

This dated evidence retains its original measurement scope.
[The consolidated placement-conversion design](../satansfiddle/placement-new.md) owns the current
capability, activation rows, safety requirements, and accepted source status.
