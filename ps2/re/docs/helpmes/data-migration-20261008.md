# Native help message data

The existing unit notes establish the state flags, loaded-file storage and
message-window objects. `InitFlag__2`, `WindowMode` and `ShowOffOnce` are native
file-static integers. `HelpMesBuff` is the native 4096-byte array receiving the
localized message file. The established conversion at the message-window API
is unchanged; the raw file representation and all function bodies are preserved.
The two load/error strings are literals at use, and the native message-window
and request-state objects have purpose comments.

A diagnostic `short[0x800]` buffer, with direct or first-element pointer arguments,
changes three instruction/relocation sites around `CreateHelpMes+0x3C8`.
Global rather than local linkage does not change that result. These probes are
reverted; the byte-buffer declaration preserves the existing source body and
passes. Receipts: `helpmes-state-failure-check.log`,
`helpmes-short-buffer-index-build.log`, `helpmes-global-short-buffer-build.log`.


Markers: ROData **2 → 0**, BSS **4 → 0**.
Objdiff after the required refresh: matched_data **4 → 14778** / total_data **14778 → 14778**.

Validation: `SCES_511.90: OK`, **149/149** complete objects including resolved relocations. No functions promoted. Receipts: `.private/dataB-r3/helpmes-final-build.log`, `helpmes-final-objects.log`, `helpmes-progress.log`.
