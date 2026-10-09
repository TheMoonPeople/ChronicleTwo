# Native shadow packet data

The established unit notes identify the local FLUSHA packet initializer, zero
quadword initializer, local MSCAL program words and compiler vtable.
The FLUSHA and zero initializers now supply their data without assembly markers;
the `mgCShadowMDT` vtable is emitted from the existing virtual methods. No
function body is changed and no vtable is manually written.

The local static `prog_vif[4]` already naturally defines its four VIF words.
Removing its marker passes the PAL verifier, but the canonical complete-object
checker rejects its projected local symbol identity. The marker is retained
pending the previously proposed generic native-local data identity support.
Receipt: `.private/dataB-r3/mg_shadow-program-objects.log`.


Markers: ROData **3 → 1**, BSS **1 → 0**.
Objdiff after the required refresh: matched_data **0 → 88** / total_data **120 → 120**.

Validation: `SCES_511.90: OK`, **149/149** complete objects including resolved relocations. No functions promoted. Receipts: `.private/dataB-r3/mg_shadow-final-build.log`, `mg_shadow-final-objects.log`, `mg_shadow-progress.log`.

## Round-4 retained-marker checks

The initialized-local matcher identifies the aligned four-word MSCAL array
from its exact payload and complete native consumer. The `prog_vif_208` marker
is removed without changing the packet-building function.

Markers: rodata 1 → 0, BSS 0 → 0.
Native data credit: 88 → 120 / 120.

Validation: `.private/dtool-r4/mg_shadow-{build,objects,tests}.log`.
PAL is byte-identical and all 149 complete objects pass. Other game objects
retain their baseline hashes, and the code metric is unchanged.
