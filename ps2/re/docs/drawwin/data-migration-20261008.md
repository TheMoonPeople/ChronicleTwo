# Native versatile-window texture rectangles

The existing unit notes establish the 21 rows of four signed integers and the
`VersatileWinPart` row order. The public `data[VWIN_PART_MAX][4]` array now has a
typed native definition containing each texture x, y, width and height. Its
existing header declaration is unchanged. No drawing function, macro or sprite
geometry changes; the native extent is exactly 0x150 bytes.


Markers: ROData **1 → 0**, BSS **0 → 0**.
Objdiff after the required refresh: matched_data **0 → 336** / total_data **336 → 336**.

Validation: `SCES_511.90: OK`, **149/149** complete objects including resolved relocations. No functions promoted. Receipts: `.private/dataB-r3/drawwin-final-build.log`, `drawwin-final-objects.log`, `drawwin-progress.log`.
