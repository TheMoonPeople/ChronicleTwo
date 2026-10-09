# editmenu anonymous data (October 8, 2026)

These sixteen held BSS markers describe compiler-created zero templates for
local aggregates. They are not independent runtime menu variables. Object
size and section-piece extent differ where alignment follows the template.
All owners and reference offsets follow the m2c outputs, existing source,
retail relocations and native initializer data; compiler counter names are
intentionally omitted because they change with source layout.

| Retail name | Section | Object / piece bytes | Native aggregate and owner | Retail reference |
| --- | --- | --- | --- | --- |
| `at_1556` | .sbss | 8 / 8 | `float list_pos[2]`, MenuGeoramaAnalyzeDraw, initialized from analysis page XY | +0x554 GPREL |
| `at_1826__2` | .bss | 16 / 16 | `RECT win`, DrawDownLoadAnaunce, initialized from DownLoadWinRect | +0x74 HI, +0x7C LO |
| `at_1827__2` | .bss | 16 / 16 | `RECT shadow`, DrawDownLoadAnaunce, shifted five pixels | +0x80 HI, +0x9C LO |
| `at_1829__2` | .sbss | 8 / 8 | `WinColor shadow_color`, DrawDownLoadAnaunce, zero RGB/Q and dynamic alpha | +0x120 GPREL |
| `at_2434` | .sbss | 8 / 8 | `int top_line[2]`, MenuGeoramaMessageMake, current/previous list top | +0x7C GPREL |
| `at_2443` | .bss | 52 / 64 | `int item_mes[13] = {0}`, MenuGeoramaMessageMake | +0x200 HI, +0x204 LO |
| `at_2444` | .bss | 52 / 64 | `char *names[13] = {NULL}`, MenuGeoramaMessageMake | +0x208 HI, +0x220 LO |
| `at_3260` | .sbss | 4 / 4 | `char *items[1] = {make_parts->edit_name}`, IsMakeObject | retail LW C1 at 0x1FB960 |
| `at_3268` | .sbss | 4 / 4 | `char *items[1] = {make_parts->edit_name}`, IsMakeObject | retail LW C1 at 0x1FBA4C |
| `at_3303` | .bss | 36 / 48 | `CMenuPosDataForm *forms[9]`, CalcCursorPosition, members and one NULL | +0x1C HI, +0x24 LO |
| `at_3304` | .bss | 16 / 16 | `int pos[4] = {0,0,0,0}`, CalcCursorPosition | +0x28 HI, +0x40 LO |
| `at_4043` | .sbss | 4 / 8 | `char *name[1] = {GetNPCName(...)}`, KeyStep | +0x5CC GPREL |
| `at_4085` | .sbss | 8 / 8 | `char *names[2] = {GetNPCName(select_npc), parts_info->edit_name}`, KeyStep | +0x930 GPREL |
| `at_4124` | .sbss | 8 / 8 | `int talk[2] = {GetPartyCharaMessage(...), GetPartyCharaMessage(...)}`, KeyStep | +0xD68 GPREL |
| `at_4137` | .sbss | 8 / 8 | `int top_line[2] = {top,top-1}`, KeyStep | +0xEBC GPREL |
| `at_4150` | .sbss | 8 / 8 | `int bar_pos[2]`, KeyStep, list-form scrollbar position | +0x1104 GPREL |

## Naming limitation and private proposal

The current initialized-literal naming pass excludes NOBITS sections. Its
named-static BSS binder requires an explicit marker and unique source static
name, which anonymous local initializer templates do not have. Removing
these markers therefore needs a shared naming pass rather than different
C++ declarations or invented named constants.

The unapplied proposal is
`.private/proposals/editmenu-anonymous-bss-naming.patch`. It selects a
nonempty, local, offset-zero anonymous NOBITS object with exactly matching
symbol/section extent. Every reference must belong to a known retail caller,
have the same relocation kind and instruction bits outside the immediate,
and resolve to one matching retail BSS object boundary. HI/LO pairing,
object size, section kind, piece extent and competing live names are checked.
Unknown callers, inconsistent destinations, duplicate candidates and live
placeholders prevent naming. The new pass changes only symbol names;
existing piece-padding rules supply permitted alignment gaps.

The read-only analysis first mapped fourteen existing templates. Both
IsMakeObject item arrays now use natural aggregate initializers and provide
the other two. The private prototype applied to the compiler-only object
passes the complete editmenu comparison: 0xC7E8 allocated bytes and 2,581
relocations. This object has no assembly data placeholders or transplants.
The production tool file remains unchanged, and all sixteen markers remain
until the tooling owner accepts and integrates the proposal.

Receipts: `.private/dataB/receipts/editmenu-proposed-native-only-object.log`,
`.private/dataB/anonymous-analysis/naming-simulation.json` and
`naming-rejection-checks.json`. Eight in-memory selection/rejection checks
cover unchanged input, wrong size/section/opcode, unknown caller, missing
references, disagreeing destinations and live placeholders.

## Initialized templates and types

The compiler supplies the initialized child-number array (21 ints), cursor
list-count array (11 ints), model position (four floats), window RGBAQ
(eight bytes), scrollbar size (two ints), scrollbar line counts (two ints),
river-query vector (four aligned floats), cursor switch table and both class
vtables. Their markers are removed while preserving their existing natural
aggregate/switch/class source forms. The window colours use RGBAQ_TYPE's
r/g/b/a/q bitfields directly. The river-query vector is sceVu0FVECTOR with
components {0,0,0,-1}. These use previously documented SDK/engine types.

## m2c evidence

Required decompile.sh calls for initializer analysis ran through the pinned
container/image. Private outputs for DrawDownLoadAnaunce,
MenuGeoramaMessageMake, KeyStep, MenuGeoramaMakePush, IsMakeObject,
MenuGeoramaAnalyzeDraw and LoadGeoramaPart are beneath
`.private/dataB/anonymous-analysis/`. CalcCursorPosition's m2c output records
its jump-table-name limitation; its aggregate mapping uses the existing
source, exact object sizes, retail assembly and matching relocations.
Previously documented function behavior was not re-analyzed.
