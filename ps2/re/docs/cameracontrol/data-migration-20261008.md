# Native camera control data

The established unit notes identify the homogeneous reference-vector initializer,
rotation zero template and camera vtable. `SetCheckRef(x, y, z)` now initializes
its local float vector as `{0, 0, 0, 1}`, removing the external byte template and
quadword type-pun. Existing virtual methods emit the camera-control vtable.
The SF-calibrated constructor body is unchanged.

`SetRotate` uses an ordinary zero-initialized four-float offset vector. Declaring
the vector before its transformation matrix preserves retail's stack order and
matches every instruction and relocation. The prior float/quadword union and
external zero-template declaration are removed. All data markers are gone.

An initial diagnostic that declared the matrix before the vector differed by
**8/40 words** (native size **0xA0**), solely in stack displacements. Explicit
16-byte vector alignment did not change those displacements. The earlier
8/28-word, 0x70-size note was incorrect; the stored word-diff receipt gives
8/40 and 0xA0. Placing the actual vector and matrix in retail order resolves
all eight sites naturally, with no helper type, dummy local or compiler policy.
Receipts: `cameracontrol-rotate-worddiff.log` and
`cameracontrol-rotate-array-order-objects.log` under `.private/dataB-r3/`.


Markers: ROData **2 → 0**, BSS **1 → 0**.
Objdiff after the required refresh: matched_data **0 → 68** / total_data **68 → 68**.

Validation: `SCES_511.90: OK`, **149/149** complete objects including resolved relocations. No functions promoted. Receipts: `.private/dataB-r3/cameracontrol-final-build.log`, `cameracontrol-final-objects.log`, `cameracontrol-progress.log`.
