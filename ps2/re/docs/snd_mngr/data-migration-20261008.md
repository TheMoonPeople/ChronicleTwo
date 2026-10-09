# snd_mngr data migration (2026-10-08)

The fresh baseline has 23 rodata markers and 11 BSS markers, with
`matched_data` 4 / `total_data` 16808. The existing notes document all state
and classes used below; all unit functions already match.

## Compiler-generated literals and local templates

The native string expressions in the bank/sequence loaders, reverb parser,
and line reader emit their retail literals without the 17 string markers.
`at_816__2` is the compiler-generated game-port switch table of
`GetCSndPortNo`; its native switch emits the same code-target relocations.
The line reader's two-byte `{'\r', '\n'}` initializer has a two-byte retail
symbol and a four-byte section piece; it is not a null-terminated string.

The existing nine- and four-entry `char *col[]` local initializers emit
`at_1555` (0x24 bytes) and `at_1648` (0x10 bytes) as anonymous zero-filled
BSS templates. The first owns 12 bytes of alignment before the next piece.
The new shared tooling binds them by declared extent and the matching code
references, so no handwritten buffer or reinterpretation is required.

Acceptance: `.private/dataC-r2/snd-native-literals-{build,objects}.log` and
`snd-native-literals-metrics.json`. The whole image and all 149 objects pass,
and all unowned hashes are unchanged. Markers fall to 5 rodata / 9 BSS;
native data coverage is 250 / 16808.

## Typed sound state

The five initialized flags/volume arrays and nine uninitialized state
objects now have documented definitions with their established types.
`init_snd` is a four-byte integer; its eight-byte section piece includes
four bytes of alignment. Listener position/direction use the SDK's aligned
four-float vector type. The existing sequencer array remains 32 instances
of the established 0xB0-byte class, and the port array remains 16 instances
of the 0x29C-byte class. Their compiler-generated initializer stays exact.

All newly defined state has retail-local `static` binding. `PortInfo`, which
was already a typed global at the checkpoint, keeps its existing global
binding: making it static exposes a generated SDK-library reference from
`e_rem_pio2`'s `two_over_pi` numeric table. At 0x003658E0 the retail word is
0x003F669E with no relocation, but splat emits `PortInfo + 0x15E`.
The failed linker receipt is `snd-typed-state-build.log`; the evidence is
`snd-library-word-evidence.log`. The proposal to preserve raw library
words lacking real relocations is at
`.private/proposals/dataC-r2-library-numeric-words.patch`. No shared tooling
or generated assembly was edited. The port array itself needs no marker.

Final acceptance: `.private/dataC-r2/snd-typed-state-global-port-{build,objects}.log`
and `snd-typed-state-global-port-metrics.json`. All markers are gone and
native data coverage is 16808 / 16808. The complete image, all 149 objects,
and all unowned object hashes pass. No function is promoted or rewritten
for the named state definitions.

## Declared function extents

The header function-size annotations use the retail ELF's declared
`STT_FUNC` extents. 59 annotations previously included the alignment
gap up to the next function and are corrected without changing declarations
or layouts. The symbol names and addresses remain exact.

## Listener-vector copy cleanup trial

Replacing the inherited quadword casts in `sndSetMicPos` with two ordinary
`memcpy` calls preserves the intended 16-byte copies but changes codegen.
MWCC emits calls and a frame, increasing the declared function size from
0x24 to 0x4C; eight instruction words differ within the retail extent.
The accepted source is restored. Receipts:
`.private/dataC-r2/snd-listener-copy-build.log` and
`snd-listener-copy-word-diff.log`.

The library-word proposal was exercised read-only against the generated
library inputs: 316 unrelocated words in 18 files pass their retail byte
comments and section checks. This includes `PortInfo` and the file-index
buffer references in `e_rem_pio2`, `intr`, `libdev`, and `libgraph`. No
generated file was written; a full build with the splitter change still
belongs to the tooling lane. Receipt:
`.private/dataC-r2/library-word-proposal-check.log`.

Header validation: `.private/dataC-r2/header-extents-final-{build,objects}.log`.
The complete PAL image, all 149 objects, and every unowned object hash pass.
The evidence audit is `header-metadata-corrections.json` in the same directory.
