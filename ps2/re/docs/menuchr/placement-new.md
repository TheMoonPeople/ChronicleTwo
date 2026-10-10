# Character-menu model construction

`CMenuChrCngMenu::LoadBGNPCModel` allocates the townsperson's action character and
schedules its model read. `CMenuCostumeSel::LoadMenuData` creates the seven costume
characters, loads the screen's textures and prepares character loading.
`CMosBookMenu::KeyStep` drives the monster book and creates its selected model. All
existing unit notes and relevant type declarations were read before the private cleanup;
the established documented constructors and memory interfaces remain authoritative. All
three functions are native and exact.

| Caller | Retail address | Exact body / padded extent | Eligible sites |
| --- | --- | --- | ---: |
| `LoadBGNPCModel__15CMenuChrCngMenuFi` | 0x002B5240 | 0x1E0 / 0x1E0 | 1 |
| `LoadMenuData__15CMenuCostumeSelFP9mgCMemoryPi` | 0x002C0C60 | 0x390 / 0x390 | 1 |
| `KeyStep__12CMosBookMenuFv` | 0x002C3A60 | 0x54C / 0x550 | 1 |

All three are GLOBAL/FUNC in retail. Their exact `menuchr.cpp` rows select
`__nw__FUiP1`, `__ct__12CActionCharaFv`, `after_constructor_inline`, and
`expected_matches: 1`. The costume loop has one static construction syntax site despite
seven runtime iterations. The direct constructors originally read as class 6. The
existing depth-8 pragma permits the real action-character constructor chain; no
additional pragma or helper is introduced.

The costume body calls `stGetTop` and `stGetRest` directly, replaces the integer alias
of the speed field with `speed = 2.0f`, and resets floating cursor members with `0.0f`.
Existing `MENU_CHARA_LOAD_MAX` and `USER_CHARA_MAX` name their actual array and
character domains. The book removes three self-assignments and redundant base casts, and
uses the established button, selection and confirmation-sound enums. Necessary byte
casts at file/image interfaces remain; they do not traverse objects or alias scalar
fields.

Five exclusive strings are compiler literals: `CHRFADEPRE`, `fukusel.img`, `fukusen`,
`mnmain`, and Shift-JIS `立ち` (bytes 97 A7 82 BF). Their old external aliases and
assembly data pieces are removed. Retail padded sizes are respectively 0x10, 0x10, 0x8,
0x10 and 0x8; the postprocessor preserves those pieces with LOCAL literal binding. Other
guarded callers retain their existing memory-helper definitions.
