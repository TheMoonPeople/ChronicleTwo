# Hard-disk menu data migration (2026-10-08)

All 35 initialized-data markers are removed. Existing map IDs, cursor
arrays and debug formats use their native C++ initializers. The connection
array now uses both `disconnect` and `connect` directly; the compiler emits
the separately addressed retail connection string, so suffix pooling is
not a blocker here.

`emergency_mes` is a file-local two-pointer table, with the exact retail
Shift-JIS repair instructions and English `error.` message. Adjacent
Japanese string literals preserve the message's newlines and byte encoding.
The seven hard-disk status/work variables have typed file-local definitions.
The five existing `mgCMemory` objects retain their constructor order;
`Stack__2` keeps external linkage for the assembled references.

`FutureMapSelect` uses ordinary initialized function-local `select` and
`sel_map` statics. `EmergencyMessage` uses a local initialized `col` counter
and an uninitialized `txt` pointer; the latter emits no initialization
guard, matching retail. No manual guard variables remain in C++.

The seven BSS markers for these locals and their compiler-generated guards
remain because the current postprocessor can bind their explicit storage
but cannot name those native BSS sections after marker removal. This is
the same shared-tool limit as the conversion-screen local buffers.

All accepted steps pass the PAL verifier and all 149 objects. Counts decrease
from 35 `INCLUDE_RODATA` and 14 `INCLUDE_BSS` to 0 and 7. Receipts are
`.private/dataB-r1/mainloop3-{native-literals,emergency-text,connect,state,map-statics,error-statics}-{build,objects}.log`.

## Native data marker completion (round 1)

The existing natural local statics supply the selections, colour counter,
text pointer and three compiler-generated guards without seven reservations.
The integer/pointer objects are four bytes; the guards are one-byte objects
with four-byte pieces. Every GP-relative consumer validates its retail
identity, so repeated `init` source names and changing numeric suffixes do not
need source aliases or manual guard storage.

All initialized-data and BSS markers are now absent. Refreshed objdiff
`matched_data` changes from 835 to 891/891 bytes. All existing
native functions and code bytes remain matched; no function is promoted.

Validation receipts in `.private/dtool-r1/`: `final-build.log`,
`final-objects.log`, `final-hashes.json`, `final-refresh.log`,
`resume-metrics.json`, `final-tests.log` and `all-test-scripts.log`. The PAL
verifier and all 149 canonical object comparisons pass. All 142 unowned
object file hashes match the warm baseline. The retained-fallback audit
finds no assembly-supplied piece credited as native data.
