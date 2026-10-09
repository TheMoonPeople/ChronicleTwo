# Native camera state and vtables

The established unit notes identify the shared `mgCCamera::StopCamera` freeze
flag and both camera vtables. The static member now has its ordinary C++ source
definition, using the existing documented header declaration. The base and
follow-camera virtual methods emit their vtables naturally. No function body
changes or manual vtable writes. The state and vtable steps pass independently.


Markers: ROData **2 → 0**, BSS **1 → 0**.
Objdiff after the required refresh: matched_data **0 → 84** / total_data **84 → 84**.

Validation: `SCES_511.90: OK`, **149/149** complete objects including resolved relocations. No functions promoted. Receipts: `.private/dataB-r3/mg_camera-final-build.log`, `mg_camera-final-objects.log`, `mg_camera-progress.log`.
