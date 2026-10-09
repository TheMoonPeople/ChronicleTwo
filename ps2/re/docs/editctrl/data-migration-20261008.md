# Edit-mode controller data migration

## Baseline

At `55cdb46c`: 27 `INCLUDE_RODATA`, 38 `INCLUDE_BSS` markers;
612 / 1,212 matched data bytes in objdiff.

## State and footstep tables

The 32 file-scope BSS markers are replaced by the documented native types
in `notes.md`. The existing movement-query and scene-event constructors stay
in the same order and produce retail's static initializer. The footstep names
are a four-entry `char *` table. Their index table contains 30
`EditFootEffect` enum entries: sand at ground kinds 7, 8, 13, 14 and 16;
water at 11, 18 and 22; grass at 1; all others have no effect.
The index table's declared 0x78-byte size receives the retail eight-byte
piece padding from the existing postprocessor.

The standing-motion literal is inline. The effect-scale and camera-distance
aggregate initializers, camera strings, character motion strings and ladder
motion strings are emitted by their existing natural C++ use sites. Their
assembly markers are removed after individual caller-group object checks.
No ROData markers remain.

## Remaining local-static markers

Six BSS markers reserve three local statics and their initialization guards:
`HamonCnt_1075` / `init_1076`, `reference_1252` / `init_1253`, and
`camera_dist_mode_1317` / `init_1318`. Their source declarations are already
natural local statics. Removing the ripple timer pair leaves two unnamed
native SBSS pieces in `check_objects`, with unresolved addresses cascading
through the remaining SBSS relocations; the PAL image fails too. The marker
binding currently supplies the retail identity for compiler-generated local
names, so these markers are retained pending tooling support. Receipt:
`.private/dataB-r2/editctrl-local-static-{build,check}.log`.

The completed changes pass all 149 object checks and `SCES_511.90: OK`.
Final receipts: `.private/dataB-r2/editctrl-final-{build,check,progress}.log`.

After the progress refresh: 612 / 1212 matched data bytes; markers 0 ROData, 6 BSS.

The complete-object checksum audit after the shared header change finds no altered
ELF object outside the four assigned units.

## Marker-free storage validation, tooling round 3

The existing all-consumer BSS matcher names the native local statics, guards and zero initializer objects without any shared-tool changes.

A fresh marker-free private compile passes the complete unit with the checkpoint
tooling. The accepted source passes `SCES_511.90: OK`, all 149 object checks,
and all 17 build regression scripts (116 discovered tests). The object hash
audit changes only `editctrl.cpp.o`; code metrics remain 6,775 matched functions
and 1,841,188 matched bytes. No function is promoted.

Markers change from 0 initialized-data / 6 BSS to 0 / 0.
Refreshed `matched_data` changes from 1080 to
1200 / 1200 bytes. Receipts are
`.private/dtool-r3/editctrl-{build,objects,tests,all-tests}.log`,
`editctrl-object-hash-audit.json`, and `editctrl-report.json`; the independent
existing-tooling probe is `probe/editctrl-check.log` in the same directory.
