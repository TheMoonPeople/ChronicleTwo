# Sine-table data migration

At checkpoint `830e48ed`, this unit has two `INCLUDE_RODATA` markers,
one `INCLUDE_BSS` marker, and 0/4,104 matched data bytes in the refreshed
progress report.

The two public mutable floats retain their established header types:
`sin_table_num` is initialized to 1024.0f (binary32 0x44800000), and
`sin_table_unit_1` to 162.97466f (0x4322F983). They occupy the two retail
four-byte `.sdata` objects. `SinTable` is a native `float[1024]` with its
exact 0x1000-byte BSS extent. No vector, matrix, guarded function or assembly
body changes.

The constants and table-storage steps each pass the complete PAL build and
all 149 canonical object comparisons, including resolved relocations.
Only `mg_math.cpp.o` changes its whole-file hash from the warm baseline.
Receipts are `.private/dataF/mg_math-constants-{build,objects}.log` and
`mg_math-sine-storage-{build,objects}.log`; refreshed measurement and hash
proof are `mg_math-final-{refresh,coverage,metrics}.log` in that directory.

Final markers are **0 RODATA / 0 BSS**. Matched data increases to
**4,104/4,104**. All functions retain their baseline status; none is promoted.
No marker or outside-file proposal remains.
