# movieviewlp data migration (2026-10-08)

Baseline: `95f8fdd1`; 14 initialized-data
markers and 20 BSS markers. Every function already matches.
The pinned `chronicletwo_dev:sf-63f7a9e` image and full object/PAL checks
validate each accepted step. Public declarations remain compatible.

## Viewer state and tag table

The twelve viewer-state reservations are native file-local scalar, pointer
and short-array definitions with the existing interfaces. `MovieLine`,
`MovieSelect` and `MovieSpecialMode` own two bytes each; their two-byte piece
tails remain alignment. `MovieSpecialModeInfo` owns three shorts, followed
by a two-byte alignment tail. The four buffer-manager objects and their
guards retain their eight markers.

`DataBuffer__2` and `Stack_ReadBuff__2` remain native `mgCMemory` objects,
now with file-local binding and documented purposes. Their constructor order
and the generated initializer are unchanged. `_MOVIE` has retail's file-local
binding, and `tag_movie` is a native two-entry `SPI_TAG_PARAM` array containing
the inline `"MOVIE"` tag and handler, followed by the null terminator.

Markers fall from **14 RODATA / 20 BSS** to **12 / 8**. Interim refreshed
matched data is **20/539**, from **4/539**. All five functions remain matched;
none is promoted. Each accepted group passes PAL and all 149 objects with
unchanged unowned object hashes. Receipts:
`.private/dataD/movieviewlp-{state,storage,tags}-{build,objects,metrics}.log`.

## Inline configuration and playback strings

All twelve remaining strings are inline at their existing uses: configuration
path, movie-work texture name, promotional list names and first-part paths,
list heading and row formats, and later promotional-part formats. The list
heading's Shift-JIS bytes use hexadecimal escapes. No argument order, stack
local or runtime control flow changes.

Initialized-data markers fall from **12 to 0**. Interim matched data is
**186/539**; the eight buffer-manager BSS markers remain. Receipts:
`.private/dataD/movieviewlp-{config,work,promo,list,parts}-{build,objects,metrics}.log`.
Every group passes PAL and all 149 objects with unchanged unowned object hashes.

## Buffer initialization flags

The four existing one-time initialization flags are native file-local signed
bytes. Their three-byte piece tails remain alignment padding. The four explicit
manager initialization paths are unchanged while their storage still comes from
markers. Markers fall from **0 RODATA / 8 BSS** to **0 / 4**; refreshed matched
data rises from **186/539** to **251/539**. Receipts:
`.private/dataD/movieviewlp-guards-final-{build,objects,metrics}.log`.

## Remaining buffer-manager storage

Native function-local `static mgCMemory` declarations reproduce all retail
instructions and constructor guards. The current data binder cannot name those
four manager objects or their compiler guards without storage markers. A raw
private copy using `buf0`, `buf1`, `dbuf0` and `dbuf1` has zero masked instruction
differences, but the unchanged postprocessor leaves the eight local identities
unmapped and the complete object fails. Four canonical manager markers remain.

The same generic proposal tested for scene,
`.private/proposals/dataD-local-static-bss.patch`, establishes each identity
from exact extent and consistent opcode-matched retail references. On that same
raw copy it names and pads the four individual guard slots, preserves the two
earlier native global buffers, and passes the complete unit: 0xD00 initialized
bytes and 361 resolved relocations. No shared tool or profile file is edited.
Receipts: `.private/dataD/movieviewlp-native-bss-{raw-build,baseline-check,proposed-check}.log`.

Final canonical markers: **0 RODATA / 4 BSS**, from **14 / 20**. Final
`matched_data` is **251/539**, from **4/539**. The unmatched 288-byte BSS
section contains the four retained 48-byte managers and the two native 48-byte
global buffers; objdiff's exact data credit applies to the complete section.

A private PAL link replacing both this unit and scene with their proposed
native-static objects passes every section and the final memory extent:
`.private/dataD/bss-proposal-pair-pal.log`. The ready source follow-up is
`.private/proposals/dataD-movieviewlp-native-statics.patch`; it requires the
shared tool proposal first.

## Marker-free storage validation, tooling round 3

The four packet/draw buffers are native function-local `mgCMemory` statics; the compiler generates their constructor guards. The four old file-scope guard definitions and explicit initialization blocks are removed.

A fresh marker-free private compile passes the complete unit with the checkpoint
tooling. The accepted source passes `SCES_511.90: OK`, all 149 object checks,
and all 17 build regression scripts (116 discovered tests). The object hash
audit changes only `movieviewlp.cpp.o`; code metrics remain 6,775 matched functions
and 1,841,188 matched bytes. No function is promoted.

Markers change from 0 initialized-data / 4 BSS to 0 / 0.
Refreshed `matched_data` changes from 251 to
539 / 539 bytes. Receipts are
`.private/dtool-r3/movieviewlp-{build,objects,tests,all-tests}.log`,
`movieviewlp-object-hash-audit.json`, and `movieviewlp-report.json`; the independent
existing-tooling probe is `probe/movieviewlp-check.log` in the same directory.
