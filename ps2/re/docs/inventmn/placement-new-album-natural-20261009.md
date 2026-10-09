# IsAccessAlbum: guarded natural placement result

`IsAccessAlbum__11CMenuInventFv` starts at `0x2082D0`. Its actual retail
GLOBAL/FUNC symbol is `0x13E8` bytes; the manifest reservation is `0x13F0`
including two padding words. The best supported private source is **177
different words**, with the actual symbol size and relocation offset/type map
equal to retail. This is not zero and is not a promotion request.

The captured production29 control remains intact. A fresh production31 control
at head `af88553fcc2183971faefecdb8ab99965ff68fb7` reproduces **1080 current,
845 exact scoped placement, 177 natural source**. The source proposal is an
exact selected-body diff against that current tracked `inventmn.cpp`, retaining
the newly accepted LoadCharaCheck source and every production31 row, including
the CreateDrawRect policy in its separate unit. The private
profile adds only the one genuine album row to production31; no float policy or
shared header changes are proposed.

## Analysis entry and prior evidence

AGENTS, MWCC, SATANSFIDDLE, all initial inventmn owning notes, previous private
invention/create/load receipts, and the relevant current menu, message, memory,
card, user-photo and album declarations/docs were read before the new probes.
The later LoadCharaCheck owning note was also read before the live31 freeze.
Existing MenuInventInit, ResetAddress, MenuKey, CalcTex and IsCreateObject
negatives were not rerun. The accepted IsCreateObject source and policies stay
untouched.

Fresh mandatory `decompile.sh IsAccessAlbum__11CMenuInventFv` succeeded with
792 lines and no stderr. Four unrelated forward CList type warnings were
retained. There is no jump-table decompiler failure for this target. The m2c
context's malformed saved-gp field names and incidental wrong member labels
were checked against the actual existing typed declarations and assembly,
rather than copied into source. The context was reused, with no full build or
gratuitous context rebuild.

Every compiler/m2c/ELF tool ran through the required H wrapper and explicit
`CHRONICLETWO_IMAGE=chronicletwo_dev:sf-63f7a9e-pn15`. The canonical flags,
real logical `inventmn.cpp`, genuine fresh controls, production semantic
profiles, verification mode and positive expected counts are recorded in the
command scripts and per-probe receipts.

## Construction and type ownership

The actual album class is **CDC2AlbumData**, not the census shorthand
CInventAlbum/CMenuInventAlbum. Its existing user-written constructor calls its
matched Initialize method. Initialize clears `0x64CB0` bytes and relates the
fifty photo records to their actual pixel rows.

| Type/member | Actual extent or location | Ownership relevant to the caller |
| --- | --- | --- |
| CDC2AlbumData | `0x64CB0` | Allocated album storage |
| photo_work | `char[50][0x2000]`, offset `0` | Fifty real image rows |
| photo | `USER_PICTURE_INFO[50]`, offset `0x64000` | Fifty real album records |
| USER_PICTURE_INFO | `0x18`; signed used byte and image pointer at `+0x14` | Existing user/album record type |
| CInventUserData.photo | Thirty records | GetPhotoInfo returns null beyond the thirty user slots |
| CMenuInvent.album_flag | Fifty signed bytes, `+0x508` | Positive selected entries; `-1` denotes transferred entries |
| CMenuInvent.album_tex | Fifty pointers, `+0x440` | Album texture binding |
| CMenuInvent.photo_tex | Thirty pointers, `+0x3C8` | User-photo texture binding |
| CMemoryCardManager | `0x1100` | Separately allocated manager |
| manager.card | `MC_CARD_INFO[2]`, `+0xD5C`, stride `0x20` | Card records remain in the manager |
| manager.error | `MC_ERROR_INFO`, `+0x4D0`, size `0x14` | Error record remains in the manager |
| manager.port | Signed word at `+0x4C8` | Only ports zero and one select a card pointer |
| MC_ICON_DATA | `0x28` | Existing icon records passed to SetIconData |
| CMenuInvent / mgCMemory | `0xF30` / `0x30` | Existing declared layouts, unchanged |

The retail album allocation is at `0x208600`, requesting `0x64CB0` bytes
after stack Alloc receives `0x64CD` quadwords. The null branch is `0x208608`,
its saved-result copy is in the delay slot at `0x20860C`, and Initialize is
called at `0x208610`. One exact class6 row observes **expected=1 actual=1**:

```json
{
  "translation_unit": "inventmn.cpp",
  "function": "IsAccessAlbum__11CMenuInventFv",
  "allocator": "__nw__FUiP1",
  "constructor": "__ct__13CDC2AlbumDataFv",
  "conversion": "after_constructor_inline",
  "expected_matches": 1
}
```

The manager allocation at `0x208630` requests `0x1100` bytes after Alloc
receives `0x112`. Its genuine constructor is out of line, class0, and is
excluded from this capability. Its later Initialize(NULL) and InitForMC calls
are real retail calls and are retained. There is no standalone generated
album/manager constructor definition in the diagnostic native object.

The fifty-iteration user-photo space loop is genuine. GetPhotoInfo's null
result for indices thirty through forty-nine protects the smaller user-photo
array; changing this loop to thirty or widening the user array would discard
retail evidence. No header defect requiring a new extent was established.

## Caller behavior

The caller checks the slot prompt message, reads selection/button input, steps
the card manager, then caches pointers to the current valid card and error
record. The manager/port loads remain after Step, matching the observable call
boundary. The ignored GetFuncNo return is still a real call.

The primary state groups are:

| States | Work |
| --- | --- |
| 0, 1, 2 | Select a port, allocate album/manager storage, search the card and choose load/save/format handling |
| 3, 5, 6 | Check an existing album, report load progress and finish the loaded-album prompt |
| 100, 110 | Acknowledge load/card/capacity error prompts |
| 200, 201, 202, 203 | Confirm saving, select/save-check the port, search and determine whether an album already exists |
| 205, 206 | Report write progress, bind resulting album textures and acknowledge completion |
| 220, 230 | Confirm exit/recovery or new-album creation |
| 231, 232 | Search before creating an album directory and report its progress |
| 240, 241 | Count user space and selected album photos, copy valid records/images, or acknowledge insufficient space |
| 250, 300, 301 | Acknowledge cancellation/card/save messages and offer recovery when leaving |
| 500–503 | Confirm format, search/format, report the result and resume the relevant prompt |

The access dispatch separately starts new-album search/directory creation,
save/overwrite operations and progress limits, and completes saving. Deferred
flags then handle card presence, formatting, free capacity, errors, loaded
photo bindings, mode transitions and stack resets. The loading message takes
the existing form's X/Y coordinates, shifts Y by 26, steps the message, and
centers it with the updated Y value.

## Supported natural source corrections

All 27 selected literal aliases are replaced by the exact retail byte strings,
with fixed-width octal escapes for non-ASCII bytes. Existing MC function,
error, size and menu-mode enum names replace the corresponding known values.
Redundant casts of Alloc's correctly typed return are removed. The used field
is already signed s8, so its inherited pointer pun is removed.

All actual runtime state variables may be declared at function entry, with
their real assignment and call order retained. This changes the register and
spill selection without adding a variable or initialization. It improves
845 to 804. Narrowed nullable-message scope and the alternative error/state
declaration boundary are retained as negative controls.

Four positive tests use `0 < actual_operand`, and the two up-key cases use
`move--` after their genuine zero initialization. Down still increments, so
both directions cancel when both bits are set. Six independent operation
witnesses match exact retail words:

| Caller offset | Actual source operation | Type |
| --- | --- | --- |
| `0x1F8`, `0x654` | Up decrements the real direction value | int |
| `0x938`, `0xBDC` | Positive recover-photo count | int |
| `0xA3C`, `0xAA0` | Positive selected album flag | s8 |

These changes improve 804 to 215. Their exact assembly windows are saved
independently of the global positional score in
`signed-selection-witnesses.json`.

The loading coordinates are represented by the actual two-element int array,
with both elements passed to the existing two-reference API and Y used after
StepMsg. Retail proves two adjacent words and a retained Y address; it does
not reveal whether the original declaration was an array or two scalars.
This supported representation restores the tail call schedule and actual
symbol size, improving 215 to 185. Commuting the two actual progress operands
improves this to 181, while leaving their final addition operand order as a
small residual. Function-scope coordinate and shared-prompt lifetimes make
no further change.

Finally, the capacity comparison uses
`MCManagerPtr->GetSaveDataSize(MC_SIZE_SAVE_KB) + 2 > card->free_size`.
This emits the genuine call before loading card capacity, as retail does,
and improves 181 to 177 with equal relocation maps. The documented matched
GetSaveDataSize/GetIconDataSize methods read the manager's icon sizes and do
not write the card. No helper, extra call, local cache or field store is added.

## Exact remaining blocker

The production31 177-word residual decomposes diagnostically as:

* **154 words**: native `this=s0`, `card=s1` versus retail `this=s1`, `card=s0`
  across caller offsets `0x38..0x1368`.
* **13 words**: frame `0x140` versus `0x150`, error pointer `0x120` versus
  `0x130`, prompt result `0x134` versus `0x12C`, and coordinates
  `0x138/0x13C` versus `0x148/0x14C`.
* **10 words**: port-guard delay slot/branch target (`0x8C/0x90`), buffer-call
  argument loads (`0x390/0x398`), progress-add operand order (`0x548/0x894`),
  clamp result register (`0x6CC/0x6D0`) and recovery-full-path exit
  (`0xA8C/0xA90`).

That register/stack transformation is an analysis-only calculation. It does
not change source/object files or turn the score into ten, and does not
authorize a compiler hook.

Every SP-derived address and access was audited. Apart from saved registers,
keys and real integer flags, the error cache and prompt spill each require
only four bytes. MC_ERROR_INFO's twenty-byte record is manager-owned; the
stack contains its pointer, not a local record. The only escaping local
addresses are the two actual int outputs at `0x148/0x14C`. No buffer,
by-value record, third coordinate or other actual storage supports the
extra `0x10`. No padding, widened array or dummy spill is proposed.

## Preservation and limits

Across all 23 successful fresh probes, **115 nonselected score rows remain
stable**. The production29 probes preserve **121 native bodies/normalized
relocation targets**; the production31 probes preserve **119**. The existing
production31 LoadCharaCheck constructor chain has absorbed two foreign
inline definitions, as its owning acceptance note records; Album changes no
additional emitted helper. IsCreateObject remains zero. The newly accepted
live31 LoadCharaCheck body and the separate CreateDrawRect production row are
preserved. The private compilation audits only inventmn bodies. Five unrelated raw
generated-data relocation names renumber after
literal migration; their target contents and all other audited properties
remain equal.

The best native target's GLOBAL/FUNC binding and `0x13E8` size match retail.
Its 342 relocation offsets/types match, and **340 of 342 resolved targets
match**. The exceptions are the real manager/buffer global loads exchanged
at `0x390/0x398`. All 27 inline literal objects have the exact retail bytes,
local OBJECT symbols and sizes. Twenty-three align to eight and four to
sixteen in the canonical compiler object. All 106 preexisting allocated data
sections and 119 nonselected native function symbol records in the live31
control are preserved. The existing
CMenuInvent vtable remains GLOBAL/OBJECT, 32 bytes, alignment sixteen, with
equal masked bytes/maps and all six retail targets.

The first private data auditor incorrectly hashed parser slices for
SHT_NOBITS sections, producing nine false BSS deltas. Its corrected audit
uses declared extents, alignment, symbols, relocations and logical zero
initialization. A later audit initially assumed all strings align to eight;
the four actual sixteen-byte-aligned objects are now individually recorded.
The earlier reports/logs are preserved, not erased. Neither finding changed
the ELF parser or any tracked file.

No inline assembly, manual vtable, generated special-member implementation,
new helper, dummy local, added steering store, LIT alias, raw field-byte
arithmetic or type pun is present in the selected proposal. No float selector
is applicable: this target has no actual floating arguments or values.
Shared source/headers/profile, generated build products, images and reserved
dungeon paths were not edited or inspected. All work stayed in the assigned
private directory. Root owns source promotion and complete-object/PAL
acceptance; the result remains guarded and private.

## Receipts

* `inputs.json`, `live-inputs.json`, `m2c.c`, `m2c.exit`, `m2c.stderr`.
* `retail-witnesses.json`, `signed-selection-witnesses.json`.
* `coordinate-progress-combined/`: preserved 181 candidate and audits.
* `capacity-call-before-card-value/`: production29 177 candidate and audits.
* `live-control/`, `live-scoped-control/`, `live-best/`: production31 controls,
  exact target-only source/profile patches, compiler logs, objects and scores.
* `live-best/residual-storage-audit.json`, `live-best/data-symbol-audit.json`.
* `comparisons.json`, command scripts/logs, `final.json`, `receipt-hashes.json`.

## Current design reference

This dated evidence retains its original measurement scope.
[The consolidated placement-conversion design](../satansfiddle/placement-new.md) owns the current
capability, activation rows, safety requirements, and accepted source status.
