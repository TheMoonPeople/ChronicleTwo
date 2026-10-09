# Native MIDI RPC bind diagnostic

The existing unit notes identify the bind-error format and its exact trailing
space/newline. `ezMidiInit` now uses the ordinary literal at use, removing the
external string declaration and assembly marker. The RPC client, DMA descriptor,
request buffer and wait-loop code retain their existing native definitions.


Markers: ROData **1 → 0**, BSS **0 → 0**.
Objdiff after the required refresh: matched_data **128 → 151** / total_data **151 → 151**.

Validation: `SCES_511.90: OK`, **149/149** complete objects including resolved relocations. No functions promoted. Receipts: `.private/dataB-r3/ezmidi-final-build.log`, `ezmidi-final-objects.log`, `ezmidi-progress.log`.
