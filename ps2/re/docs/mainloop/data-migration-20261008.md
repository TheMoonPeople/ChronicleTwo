# Main-loop data migration

## Baseline

At `55cdb46c`: 126 `INCLUDE_RODATA`, 51 `INCLUDE_BSS` markers;
4 / 27,902,952 matched data bytes in objdiff.

## Main-loop state

The scalar state, font-page pointers, resource arenas, controller objects and
thread priority use native definitions of their documented types.
`GamePad__2` has the declared `CGamePad` size of 0x478 and receives the retail
eight-byte alignment tail. `PadCtrl` remains 0x510. The main arena is
`u_long128[0x1A0000]`; system sound and info arenas contain 400 and 5,000
quadwords; font image storage is `u8[0xD000]`.

The four resource arenas retain external linkage: generated SDK and VU
assembly objects have relocations to `main_buffer`, `SystemSeBuff`, `InfoBuff`
and `font_buff`. Local linkage passes the main-loop object check but fails
those link references. Other scalar state remains file-local. Public
variables retain the declarations and types in `mainloop.hpp`.

The PAL build is byte-identical and all 149 objects pass. Receipts:
`.private/dataB-r2/mainloop-controller-{build,check}.log` and
`.private/dataB-r2/mainloop-state-{build,check}.log`.

## Controller bindings

The mutable 46-entry button table uses `PAD_TABLE_ENTRY`, existing logical
button names where documented, `PadCtrlTrigger` values and `PadButton` masks.
The nine-entry analog table uses `ANALOG_TABLE_ENTRY` and `PadCtrlAxis` values.
Each retains its negative terminator. The two language-dependent button pairs
are emitted by the natural local initializers in `InitPadTable`. `SelectArg`
is a zero-initialized native `int[32]`, placed in retail's initialized-data
section by the existing named-object section mapping.

Each table and the caller's literals pass the complete main-loop object
check; the full build reports `SCES_511.90: OK`, and all 149 objects pass.
Receipt: `.private/dataB-r2/mainloop-button-literals-{build,check}.log`.

## Mode callback tables

`LoopInit`, `LoopMain` and `LoopExit` are native ten-entry arrays using the
existing `LOOP_INIT_FUNC`, `LOOP_MAIN_FUNC` and `LOOP_EXIT_FUNC` types and
`LOOP_MODE_NUM` bounds. Entries follow `MainLoopMode` order and reference
functions through their owning headers. The local menu callbacks retain local
linkage. Each 0x28-byte table receives the retail eight-byte alignment tail.
All three steps preserve the complete main-loop object and PAL executable;
all 149 objects pass after the final table. Receipts:
`.private/dataB-r2/mainloop-{init,main,exit}-table-{build,check}.log`.

## Configuration and debug-menu tables

The 23-entry `tag__3` script table uses `SPI_TAG_PARAM` with inline tag names.
The menu labels are native file-private tables under their retail storage
names: 15 pointers in `menu_1281` and 12 in `menu_1457`. The first ends at its
empty string, removing the extra source NULL that emitted a 64-byte copy of
the 60-byte retail table. `menu_sel_1452` is a native zero-initialized
`int[11]`. These tables only serve their respective debug-menu functions.
Their payloads and resolved references match retail after each migration.

Language names, item-set names/numbers, extra-game names and the event cursor
are produced by their natural local aggregate initializers. Menu format
strings, boot file names, font file names, config messages and option tag
names are inline literals. The complete PAL build and all 149 objects pass.
Receipt: `.private/dataB-r2/mainloop-option-literals-{build,check}.log`.

### Remaining debug cursor markers

`at_1317__2` holds the two cursor pointers to `at_1315` (" ") and `at_1316`
(">"). Their natural initializer is already in `MenuLoop`. Removing their
markers leaves one unidentified ROData piece and one unidentified SData piece:
the short space string has ambiguous byte matches, and its unresolved identity
prevents the native aggregate from being recognized. The PAL image fails.
The three markers are retained; restoring only this group resolves the full
object check. Receipts:
`.private/dataB-r2/mainloop-menu-literals-{build,check}.log` and
`.private/dataB-r2/mainloop-menu-literals-restored-{build,check}.log`.

## Menu render buffers and VU addresses

The four render-buffer initialization blocks are natural local `mgCMemory`
statics (`buf0`, `buf1`, `dbuf0`, `dbuf1`). Their constructors call `Init` and
emit the original guarded initialization in the original order. The four
storage markers and four guard markers remain for compiler-local identity
binding. The 16-entry VU program-address table is native file-private
`u_long128 *` storage under its retail name `vu_prog_1048`.

The remaining 17 BSS markers are:

- Four scalar local statics and their guards: `pmeter_flag`, `pause`, and the
  two menu `select` values (eight markers).
- Four local render-buffer statics and their guards (eight markers).
- The compiler's 64-byte zero initializer for EventSelect's local
  `char config_name[64] = ""` (one marker, `at_1529`). This is not an
  additional field of `INIT_LOOP_ARG`. Its use copies four quadwords from
  the initializer to the local buffer; converting that initializer to a
  named standalone template would preserve the scaffolding rather than
  produce its natural source form. Native anonymous BSS identification is
  needed to remove its marker.

## Font reload access

`ReLoadFontTexture` retains its existing byte-offset access to the now-typed
font-page arrays. The indexed alternatives in `notes.md` are not repeated.
A new walk with typed `TM2_head **` and `mgCTexture **` cursors produces a
0xFC-byte function versus retail's 0x108 bytes, at 85.833% in objdiff. Its
alignment has 6 argument mismatches, 6 deletions and 3 insertions (15 differing
instruction rows). This changes the complete object and PAL image, so the
matching access form is retained. Receipts:
`.private/dataB-r2/mainloop-font-walk-{build,check,diff}.log` and
`.private/dataB-r2/mainloop-font-walk-diff.json` (the diff receipt is the JSON).

A scoped `#pragma optimization_level 2` around the direct typed-index form
also fails: 0x124 bytes versus retail's 0x108 and 69.469696% in objdiff.
The original source is restored and the complete main-loop object passes.
Receipts: `.private/dataB-r2/mainloop-font-opt2-{build,check,diff}.log`,
`.private/dataB-r2/mainloop-font-opt2-diff.json`, and
`.private/dataB-r2/mainloop-font-opt2-restored-{build,check}.log`.

Removing only the cursor's arrow-string marker also fails: the arrow's
native copy is discarded while the retained parent table refers to its retail
name. All three cursor markers therefore remain together. Receipt:
`.private/dataB-r2/mainloop-cursor-arrow-{build,check}.log`.

## Tooling proposal

`.private/proposals/native-local-data-identity.patch` is a proposed change
for the tooling lane, not an applied change. Its identity is the source-local
name, declared size and referencing mangled-function set from actual native
and retail relocations. Guard identity adds the named storage initialized by
the guard's semantic initialization region. It does not select instruction
positions, change allocated bytes, or edit instruction/relocation values.
The scalar guard prototype covers editctrl's three pairs and character's
outline counter. Constructor guards need additional support. Objdiff base
objects need equivalent identity mapping separately; linked-object
normalization alone will not fix the data coverage metric.

### Anonymous data identities

The additional unapplied proposal
`.private/proposals/anonymous-data-extent-identity.patch` requires equal declared
extents when matching native literals. The native two-byte space string
(`20 00`) otherwise also matches the prefix of retail's eight-byte
`at_973` controller-button pair (`20 00 00 00 40 00 00 00`). Exact extents
identify `at_1315`, `at_1316` and the eight-byte `at_1317__2` cursor table.
The proposal also preserves a native child of a removed parent when no retail
placeholder for that child remains; the arrow-only failure supplies the
evidence for this discard-path change.

The anonymous 64-byte zero template has native name `@825` in the current raw
object and retail name `@1529`. Both are NOBITS `.bss` objects referenced only
by `EventSelect`. The proposal identifies them by section kind, declared
extent and incoming mangled-function/relocation-kind graph. NOBITS implies
zero storage; its reader buffer is not a stored payload. Literal and zero
identity tests on genuine raw compiler output preserve instructions,
relocation indices, offsets and types. Wrong extents, initialized storage,
ambiguous graphs and retained markers are rejected. Both proposal patches
pass a combined `git apply --check`; neither is applied or container-built.
Their tests are included in the patches and were executed in memory, without
writing separate test receipts. Constructor guards still need a separate
semantic constructor/receiver extension. Source-only objdiff identity mapping
is also separate from these linked-object proposals.

After refreshing progress: 4 / 27902952 matched data bytes; markers 3 ROData, 17 BSS. Final receipts: `.private/dataB-r2/mainloop-final-{build,check,progress}.log`.
