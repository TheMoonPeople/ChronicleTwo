# ezbgm data migration (2026-10-08)

Baseline: `d56248a7`; 5 `INCLUDE_RODATA` / 2
`INCLUDE_BSS` markers; matched_data 0/262.

The two initialization diagnostics and three busy diagnostics are inline at
their existing `printf` uses, retaining spaces, spelling and newlines
(receipts `ezbgm-init-strings`, `ezbgm-busy-strings`).

The RPC send/response workspace is a file-local 16-int `sbuff`; the client
connection is a file-local `sceSifClientData gCd2`. Both retain 16-byte
alignment. The client type is 0x28 bytes; the verified postprocessor supplies
its eight-byte zero piece tail to 0x30, so no storage wrapper or extra field
is required. Both old BSS markers are removed (receipts `ezbgm-rpc-storage`
and `ezbgm-send-buffer-marker`). The dated notes' suggested wrapper is
unnecessary with the current data-extent support. Existing RPC calls,
return behavior and function bodies otherwise remain unchanged.

Final: 0 rodata / 0 BSS markers; matched_data
262/262 after the standard objdiff/progress refresh.
Every accepted step passes the full PAL build (`SCES_511.90: OK`) and
all 149 complete objects, including resolved relocations. The 148 other
object hashes are unchanged at each step. Function coverage stays
6,770 matched / 93 guarded / nine assembly-only / zero fuzzy.

Validation receipts are under `.private/dataE/`, with the step prefixes
listed above and `-build.log`, `-objects.log`, and `-hashes.log` suffixes.
Final refresh: `ezbgm-final-progress.log`, `ezbgm-final-coverage.log`,
and `ezbgm-final-metrics.json`.
