# menusys review corrections — October 8, 2026

Lane base `4831afdc`, MWCC 3.0-011126 with the production profile in
`chronicletwo_dev:sf-63f7a9e`. The warm build passes `SCES_511.90: OK` and
149/149 complete objects. Receipts are under `.private/fixes-r1a/`.

## Retail function sizes (finding 2)

All 142 existing `@size` tags in `menusys.hpp` resolve by `@mangled` to
`ps2/config/pal/main.symbols.txt`. Of those, 113 described the aligned section
extent rather than the symbol's declared size; all now use the declared size.
The other 29 tags already agree. This includes declarations for inline
functions emitted in another unit and for the four guarded menu functions;
no function body or guard changes.

The promoted functions singled out by the review have declared sizes
`CMenuItemInfo::CalcTex` **0xCF8**, `CheckEnableHaveItemNum` **0x34C**, and
`CommonSetMoveItemClass` **0x3D8**. Their padded section extents remain 0xD00,
0x350, and 0x3E0 respectively. Symbol sizes exclude the zero alignment tail.

The before/after inventories are `size-audit-before.json` and
`size-audit-after.json`; full acceptance is recorded in `sizes-build.log` and
`sizes-objects.log` (PAL OK, 149/149 objects).

## File-local function identities (finding 3)

Each of the three source-defined helpers has one documentation block on its
definition, with the retail identity and declared extent:

| Function | Retail address | Declared size |
| --- | --- | --- |
| `MenuDataSwap__FP13CGameDataUsedP13CGameDataUsedi` | 0x23DD80 | 0x38C |
| `MenuItemDebugDraw__Fv` | 0x2494E0 | 0x13A4 |
| `MenuPosFormValueSetCharaRobo__FP9ROBO_DATAi` | 0x24CB20 | 0x498 |

The existing purpose descriptions remain. `identities-build.log` and
`identities-objects.log` record PAL OK and 149/149 objects.

## Existing item and character enums (finding 5)

`CMenuItemInfo::LRCheck` uses `1 << USER_CHARA_*` for the four party bits,
`USER_CHARA_MONSTER` for the active-transformation tests, and the same enum
for character numbers in `page_chara`. The view-page and key-layout numbers
are separate domains and keep their existing values. `JoinPartyMember` and
`LeavePartyMember` in userdata establish the character-index bit mapping;
`GetNowPartyMember` additionally includes the monster bit for the badge box.
`MenuDataSwap` uses `USED_ITEM_TYPE_NONE` for its empty source-slot test.
These substitutions preserve the existing integer values and behavior.

The seven raw item-data values in MenuDataSwap (0x11, 0x15, 0x1A, 0x1B,
0x1D, 0x1E, 0x22) need additions to `ITEM_DATA_TYPE`, whose definition is
owned by `gamedata.hpp`, outside this lane. No second enum is introduced in
menusys. The unapplied coordinator proposal is
`.private/proposals/menusys-item-data-types.patch`, with evidence in the
adjacent Markdown file; unknown meanings have neutral enumerator names.
Those seven constants remain until the shared enum is updated and validated.

`enums-build.log` and `enums-objects.log` record PAL OK and 149/149 objects
for the substitutions using existing enums.

## Debug title controller alias (finding 9(d))

The `info` alias is removed with identical function bytes and relocations;
[the debug-display notes](night-20261008.md#debug-title-controller-accesses-review-finding-9d)
record the private probe and production receipts. Finding 9(c)'s accepted
unbraced case scope remains as documented.

## Debug display float literals (finding 10)

All nine functional casts are replaced by single-precision literals with
identical bytes and resolved relocations. The per-call inventory and
validation receipts are in the debug-display section of
[night-20261008.md](night-20261008.md).

## Current item-limit matching notes (finding 11)

`notes.md` identifies CheckEnableHaveItemNum as promoted and records the
joint source facts that resolve its active-slot register allocation. The
round-zero, round-one and near-miss scores are explicitly historical; the
current remaining list has the four constructor-backed guarded functions.
`notes-build.log` and `notes-objects.log` record PAL OK and 149/149 objects.

## Internal helper linkage (finding 16)

Retail `readelf -sW rom/pal/extracted/iso/SCES_511.90` identifies
MenuDataSwap, MenuItemDebugDraw and MenuPosFormValueSetCharaRobo as LOCAL
functions, with declared sizes 908, 5,028 and 1,176 bytes respectively.
Their C++ declarations and definitions now use `static`. Each helper retains
its existing symbol spelling, function bytes and resolved relocation targets;
only symbol binding metadata changes from GLOBAL to LOCAL.

`linkage-build.log` and `linkage-objects.log` record PAL OK and 149/149
objects. `linkage-symbols.txt` records the native bindings, and
`final-audit.json` compares allocated sections and relocation identities with
the warm baseline, as well as the guarded bodies, data markers and scope.
