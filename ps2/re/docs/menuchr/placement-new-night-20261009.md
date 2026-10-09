# Character-menu model construction

`CMenuChrCngMenu::LoadBGNPCModel` allocates the townsperson's action character
and schedules its model read. `CMenuCostumeSel::LoadMenuData` creates the seven
costume characters, loads the screen's textures and prepares character loading.
`CMosBookMenu::KeyStep` drives the monster book and creates its selected model.
All existing unit notes and relevant type declarations were read before the
private cleanup; the established documented constructors and memory interfaces
remain authoritative. The three assembly guards are removed by hand.

| Caller | Retail address | Exact body / padded extent | Eligible sites |
| --- | --- | --- | ---: |
| `LoadBGNPCModel__15CMenuChrCngMenuFi` | 0x002B5240 | 0x1E0 / 0x1E0 | 1 |
| `LoadMenuData__15CMenuCostumeSelFP9mgCMemoryPi` | 0x002C0C60 | 0x390 / 0x390 | 1 |
| `KeyStep__12CMosBookMenuFv` | 0x002C3A60 | 0x54C / 0x550 | 1 |

All three are GLOBAL/FUNC in retail. Their exact `menuchr.cpp` rows select
`__nw__FUiP1`, `__ct__12CActionCharaFv`, `after_constructor_inline`, and
`expected_matches: 1`. The costume loop has one static construction syntax
site despite seven runtime iterations. The direct constructors originally read
as class 6. The existing depth-8 pragma permits the real action-character
constructor chain; no additional pragma or helper is introduced.

The costume body calls `stGetTop` and `stGetRest` directly, replaces the
integer alias of the speed field with `speed = 2.0f`, and resets floating
cursor members with `0.0f`. Existing `MENU_CHARA_LOAD_MAX` and `USER_CHARA_MAX`
name their actual array and character domains. The book removes three
self-assignments and redundant base casts, and uses the established button,
selection and confirmation-sound enums. Necessary byte casts at file/image
interfaces remain; they do not traverse objects or alias scalar fields.

Five exclusive strings are compiler literals: `CHRFADEPRE`, `fukusel.img`,
`fukusen`, `mnmain`, and Shift-JIS `立ち` (bytes 97 A7 82 BF). Their old
external aliases and assembly data pieces are removed. Retail padded sizes
are respectively 0x10, 0x10, 0x8, 0x10 and 0x8; the postprocessor preserves
those pieces with LOCAL literal binding. Other guarded callers retain their
existing memory-helper definitions. The monster-book header's extent-based
size correction is saved privately, without editing the shared header.

The final private draft has all three strict word scores zero; all 85 other
function diagnostics, sizes, extents and relocation maps equal its control.
Its fully promoted complete object passes 0x11CC0 allocated bytes / 3,761
resolved relocations. Receipts and fresh m2c passes are indexed by
`.private/pntc/menuchr-natural/natural-placement-callers.md`; the final object
is `whole-final/menuchr.cpp.o`, SHA256
`f87f7e6eef64e33dab2537e5ecbffd3f53e2bb2e7cd6559c0079f8e20d4b405a`.

Each canonical caller differs by two allocation guard/copy words. Full pn14
integration passes `SCES_511.90: OK` and 149/149 complete objects. Every
assembled/source-only object outside the 16 promoted units retains its
baseline whole-file hash, and linked main/game bytes and memory end agree.
Refreshed coverage is 6,773 matched / 89 guarded / 10 assembly-only / 0 fuzzy.
Full receipts are `.private/pntc/receipts/promote-twenty-four-build.log` and
`.exit`, `promote-twenty-four-objects.log`, `promote-twenty-four-artifacts.json`,
`promote-twenty-four-progress.log` and `promote-twenty-four-coverage.log`.
The [design note](../satansfiddle/placement-new.md)
records the intentional policy rather than claiming a compiler-state repair.

## Current design reference

This dated evidence retains its original measurement scope.
[The consolidated placement-conversion design](../satansfiddle/placement-new.md) owns the current
capability, activation rows, safety requirements, and accepted source status.
