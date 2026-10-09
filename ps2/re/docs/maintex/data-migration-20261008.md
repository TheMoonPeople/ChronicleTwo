# Native texture data

The thirteen `TEX_` globals are `mgCTexture *` definitions in retail order;
their declarations and purposes are documented in `maintex.hpp`. Each occupies
four bytes in `.sbss`.

The texture lookup and loader already contain their string literals at their
uses. The 27 string markers and their unused extern declarations duplicate
those native strings. `AddExpWeaponParam` generates the remaining nine-entry
switch table from its native switch, including the default entries for kinds
0 and 5–7. No function body changes are needed to replace the markers.

All 28 `INCLUDE_RODATA` and 13 `INCLUDE_BSS` markers are removed. The canonical
focused object passes 0xF94 bytes and 254 resolved relocations. Whole-project
validation and refreshed data coverage are recorded with the lane receipts.

The full build retains `SCES_511.90: OK`, and all 149 objects pass. Only
`maintex.cpp.o` changes its raw object hash; its allocated bytes and resolved
relocations remain exact. Refreshed `matched_data / total_data` remains
52 / 532: the current source-only report does not credit these anonymous
string/switch sections, although the linked object passes without markers.
Receipts: `.private/dataA-r2/maintex-native-data.log`, `maintex-build.log`,
and `maintex-objects.log`.
