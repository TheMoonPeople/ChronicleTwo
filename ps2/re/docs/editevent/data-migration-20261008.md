# editevent data migration (2026-10-08)

The fresh round-2 baseline has 20 rodata markers, no BSS markers, and
`matched_data` 0 / `total_data` 324. All nine functions already match; the
existing notes own the event/state and NPC-loading analysis.

## Event and NPC literals

Twelve diagnostic, motion, frame, and configuration strings are inlined at
their existing calls. The exact Shift-JIS motion bytes use hexadecimal
escapes. `at_1152` and `at_1154` are generated switch tables of `CEditEvent::Step`;
the native switches emit the same target offsets without handwritten data.

Acceptance: `.private/dataC-r2/editevent-literals-{build,objects}.log` and
`editevent-literals-metrics.json`. The full image and all 149 objects pass,
and all unowned object hashes remain unchanged. Six markers remain: the
four house suffix strings, their initializer template, and the menu pointer.

## House suffixes and menu arguments

The door branch initializes `char *suffix[4] = {"ia", "ib", "ic", "id"}`
at the point the original template is copied. This generates `at_920__4`
and the four string-pointer relocations naturally, replacing the quadword
union and reinterpretation. The default suffix remains the literal `"ia"`.
The menu state pointer becomes a documented file-local `MENU_INIT_ARG *`
initialized to `&MenuArg`, preserving its four-byte .sdata extent.

Final acceptance: `.private/dataC-r2/editevent-native-data-fixed-{build,objects}.log`
and `editevent-native-data-fixed-metrics.json`. No markers remain and native
data coverage is 324 / 324. The complete image, all 149 objects, and every
unowned object hash pass. No data or tooling proposal is parked.

## Event flag and point-number fields

`StartEvent` now reads `data.event.flag` and writes
`data.event.point_no` through the established event-data type, replacing
integer-pointer views of its float-copy overlay. The field at +8 remains
the event number consumed by the door branch of `Step`; closed doors set
it to 0xF9. Existing `FUNC_EVENT_FLAG`, `EditEventState`, and `EditEventType`
enums replace the redundant flag constants and raw state/type values.
The group-by-group event copy remains unchanged.

The typed accesses preserve all native instructions and resolved
references. Acceptance: `.private/dataC-r2/editevent-start-fields-final-{build,objects}.log`.
The complete image, all 149 objects, and all unowned hashes pass.
Data coverage remains 324 / 324 and no marker is added.

## Declared function extents

The header function-size annotations use the retail ELF's declared
`STT_FUNC` extents. 5 annotations previously included the alignment
gap up to the next function and are corrected without changing declarations
or layouts. The symbol names and addresses remain exact.

Header validation: `.private/dataC-r2/header-extents-final-{build,objects}.log`.
The complete PAL image, all 149 objects, and every unowned object hash pass.
The evidence audit is `header-metadata-corrections.json` in the same directory.
