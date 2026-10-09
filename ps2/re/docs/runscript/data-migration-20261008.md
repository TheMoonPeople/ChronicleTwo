# runscript data migration (2026-10-08)

The round-2 baseline has 27 `INCLUDE_RODATA` markers, no `INCLUDE_BSS`
markers, and `matched_data` 0 / `total_data` 1180 after a warm build and
objdiff refresh. All 28 functions are already native matches; no function
promotion or repeat function analysis is needed.

## Runtime error and value formats

`at_168`, `at_173`, `at_183__2`, `at_197`, `at_202`, and `at_223` through
`at_225` are null-terminated strings used by the runtime error helpers and
value printer. Their assembly words establish the exact text, including
capitalization and newline bytes. Inlining each string at its existing call
preserves every code byte and resolved relocation. The eight marker-backed
arrays and their extern declarations are removed.

Validation receipts: `.private/dataC-r2/runscript-errors-{build,objects}.log`.
The executable remains `SCES_511.90: OK`, all 149 objects pass, and every
unowned object hash equals the warm baseline. The unit now has 19 rodata
markers; its incomplete native rodata section still reports 0 / 1180 data
bytes matched.

## Remaining strings and generated switches

The external-function diagnostics and SB2 magic string are inlined at their
calls. The overflow and boolean-type diagnostics keep their exact Shift-JIS
bytes with hexadecimal escapes. `at_341__2` and `at_686` through `at_696`
already have natural string expressions in the matched functions; their
unused declarations and fallback markers can be removed directly.

`at_697`, `at_698`, and `at_699` are compiler-generated switch tables of
`CRunScript::exe`: the opcode switch and its integer/floating comparison
switches. Their R_MIPS_32 entries point to the same function offsets emitted
by the existing native switches. No handwritten table is required.

Final validation: `.private/dataC-r2/runscript-final-{build,objects}.log` and
`runscript-final-metrics.json`. All data markers are gone and native data
coverage is 1180 / 1180. The full image, all 149 objects, and all unowned
object hashes pass. No marker is parked and no shared-tool proposal is
needed for this unit.

## Native stack-payload assignment

`push` and the store opcode assign the `RS_STACKDATA::val` union directly.
MWCC generates the same floating-point load/store pair for the union copy;
the explicit cast through its integer field is unnecessary. This preserves
all value kinds without choosing an inactive scalar member.

Acceptance: `.private/dataC-r2/runscript-union-values-{build,objects}.log`
and `runscript-union-values-metrics.json`. The complete PAL image, all 149
objects, and every unowned object hash pass. No data count changes.

An anonymous integer/float operand union in `vmcode_t` also preserves PAL
bytes and passes all 149 canonical object checks, but changes metadata in
three unowned objects (`eventedit`, `userdata`, `charasetup`). The existing
header and float-operand access are retained to preserve their complete
object hashes. Receipts: `runscript-typed-operands-{build,objects}.log` and
`runscript-float-operand-unowned.log`, under `.private/dataC-r2/`.

## Declared function extents

The header function-size annotations use the retail ELF's declared
`STT_FUNC` extents. 14 annotations previously included the alignment
gap up to the next function and are corrected without changing declarations
or layouts. The symbol names and addresses remain exact.

## Serialized float operand copy trial

Copying the floating operand's four serialized bytes into a meaningful
`float constant` local with `memcpy` avoids the cast but expands the stack
frame and the function from its declared 0x145C bytes to 0x146C. The ensuing
schedule and branch changes give 980 masked word differences. That trial is
restored as well; receipts are `.private/dataC-r2/runscript-float-copy-build.log`
and `runscript-float-copy-word-diff.log`.

Header validation: `.private/dataC-r2/header-extents-final-{build,objects}.log`.
The complete PAL image, all 149 objects, and every unowned object hash pass.
The evidence audit is `header-metadata-corrections.json` in the same directory.
