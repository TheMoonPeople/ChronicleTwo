# Boot data migration

Checkpoint `830e48ed` has 12 RODATA markers, no BSS markers, and
4/384 matched data bytes after the warm progress refresh.

`init` uses the exact IOP reboot path and ten module paths as inline string
literals. Both startup counter prints use the same inline format string;
MWCC pools their storage naturally. The casts and twelve anonymous-data
extern declarations disappear. Path spelling, module order, retry loops and
format arguments remain identical. The native volatile vertical-blank counter
and assembly-only interrupt callback are unchanged.

The module-path and counter-format steps independently pass the complete
PAL build (`SCES_511.90: OK`) and all 149 canonical object comparisons.
The final hash inventory changes only the two units already migrated,
`main.cpp.o` and `mg_math.cpp.o`; all other objects equal the warm baseline.
Receipts: `.private/dataF/main-module-paths-{build,objects}.log`,
`main-counter-format-{build,objects}.log`, and
`main-final-{refresh,coverage,metrics}.log`.

Final markers are **0 RODATA / 0 BSS**, with **384/384 matched data**.
No function is promoted, no marker remains, and no shared-file proposal is
needed.
