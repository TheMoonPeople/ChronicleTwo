# Photo data migration (2026-10-08)

`mes_txt` is a file-local `char *[6][PHOTO_MES_NUM]` table with four messages
for each of the six languages, in retail order. Japanese text retains the
retail Shift-JIS bytes through three-digit octal escapes; other messages
retain their literal font-code tokens, punctuation and spacing. The texture
names `fix_work` and `camera` and picture-count format `%d/%d` are inline
strings. Camera state comparisons use the existing `TakePhotoState` names.

All ten state/title BSS objects have typed file-local definitions. Their
integer widths and signedness preserve the matched code. `PhotoTitle` is a
128-byte character array; `Font__3` remains the native `CFont` object that
provides the single static initializer.

## Retained empty-text pieces

`null_txt` has the natural definition `static char *null_txt = ""`, but its
assembly pointer marker and the empty-string marker `at_817__6` remain.
Removing both fails object validation because the current postprocessor
cannot uniquely identify the one-byte zero literal: multiple data pieces
begin with zero, and the literal is referenced only by the pointer table.
The named pointer's relocation is enough evidence for a future generic
native-data naming extension; no artificial source object is introduced.

The final message/literal, state and enum steps each pass the PAL verifier
and all 149 objects. Marker counts decrease from 30 `INCLUDE_RODATA` and
10 `INCLUDE_BSS` to 2 and 0. Receipts are
`.private/dataB-r1/photo-{corrected-messages,state,enums}-{build,objects}.log`.
The failed preliminary table probe is also retained privately; its
Japanese literal bytes and ambiguous empty-string ownership were corrected
before acceptance.

## Native data marker completion (round 1)

The existing `static char *null_txt = ""` supplies the native four-byte
fallback pointer and its one-byte empty literal. The real R_MIPS_32 field
in the named pointer identifies the otherwise ambiguous empty-string piece;
compiled addends and target-symbol offsets are subtracted. Both markers are
removed together without changing the pointer definition or message table.
The round-0 pointer-owned literal support already handles this case.

All initialized-data and BSS markers are now absent. Refreshed objdiff
`matched_data` changes from 472 to 1,306/1,306 bytes. All existing
native functions and code bytes remain matched; no function is promoted.

Validation receipts in `.private/dtool-r1/`: `final-build.log`,
`final-objects.log`, `final-hashes.json`, `final-refresh.log`,
`resume-metrics.json`, `final-tests.log` and `all-test-scripts.log`. The PAL
verifier and all 149 canonical object comparisons pass. All 142 unowned
object file hashes match the warm baseline. The retained-fallback audit
finds no assembly-supplied piece credited as native data.
