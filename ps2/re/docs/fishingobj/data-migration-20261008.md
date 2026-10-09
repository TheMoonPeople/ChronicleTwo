# Native fishing data

The 28 BSS reservations are replaced by documented static definitions. The
sixteen scalar state values keep their established types, including the floating
`NowFishRot`. The larger objects use `FISH_POINT`, `FISH_ROD_SEGMENT`, frame
pointers, and four-float vectors according to the existing layout evidence in
`decompilation.md`.

`RodPoint` is five `FISH_POINT` entries, rather than a flat sixty-float buffer.
The rod tip and preceding mass are entries 4 and 3. Every former rod byte/float
offset is expressed through a point index and `pos`, `old_pos`, or `velo`.
The focused object remains exact after that replacement.

The lure, float, and hook objects require declaration order `LureObj`, `UkiObj`,
`HariObj`. Defining the hook first changes only the three initializer relocation
targets. Defining them in retail order preserves the native 80-byte static
initializer; all 0x3DE0 checked bytes and 1,042 resolved relocations pass.
The inactive alternate state declarations and unused point/bind helpers are
removed with their `NONMATCHING` block.

Receipts: `.private/dataA-r2/fishingobj-bss.log` (rejected constructor order),
`fishingobj-bss-order.log` (exact), `fishingobj-bss-build.log`, and
`fishingobj-bss-objects.log`.

## Local initializers and strings

The signed pose-axis triplets are native `TriAxis` aggregate initializers at
their original uses: `{0, 1, 2}`, `{-1, 2, 0}`, and `{-1, 0, 2}`. Their declared
size is twelve bytes, with the four-byte zero alignment gap retained by the
normal data postprocessor.

The ten strings are inlined at their uses. Retail's first and final rod-frame
strings are `"sao"` and `"ito"`, not the `"sao1"`/`"sao8"` names asserted in the
older notes. The six intervening strings are `"sao2"` through `"sao7"`; the
remaining literals are `"fish_juji"` and `"obj1"`.

`ParaBlend` contains its cubic basis matrix and homogeneous powers-vector
initializer directly. Declaring the basis where it is first copied preserves
its initialization timing. Declaring the uninitialized geometry matrix after
the basis preserves their stack order. Moving the initialized basis to function
entry changes the instructions and is rejected. The powers vector is initialized
where its former cast-based constant copy occurred. Both native initializers
pass the complete focused object with no byte or relocation differences.

All fifteen `INCLUDE_RODATA` markers and all twenty-eight `INCLUDE_BSS` markers
are now absent. No function is promoted during this data migration. Focused
receipts include `fishingobj-axes.log`, `fishingobj-actual-strings.log`,
`fishingobj-basis-late.log`, and `fishingobj-powers.log` in `.private/dataA-r2/`.

The full build retains `SCES_511.90: OK`, and all 149 objects pass. Refreshed
`matched_data / total_data` is 6884 / 6972 (baseline 6756 / 6972).
Final unit receipts are `fishingobj-literals-build.log` and
`fishingobj-literals-objects.log` under `.private/dataA-r2/`.
