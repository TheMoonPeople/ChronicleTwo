# Remaining main-menu guards

The current Satan's Fiddle translation-unit row uses GPR helper mask `0x30`
and FPR mask `0`. The existing `DrawMenuTopic` selector remains unchanged.
`MenuMainInit` is native; see
[user-data-colouring-20261010.md](user-data-colouring-20261010.md).

## MenuInternSelectDraw float-order calibration

`MenuInternSelectDraw__Fv` draws the active forms and message, topic ticker,
and optional debug status overlays. Its existing natural draft has the retail
`0x1C0` extent. With the current deterministic profile, 10 of 112 words differ:
six literal-materialization words at offsets `0x5C` through `0x84` in the first
`DrawMenuFillBox`, and four at `0x164` through `0x174` in the second.

Two unscoped expression selectors restore retail: translation unit
`menumain.cpp`, enclosing function `MenuInternSelectDraw__Fv`, value type
`binary32`, values `0x42A00000` (80.0f) and `0x43AF0000` (350.0f), each with
`evaluate_first: true`. The first is the height argument of the upper debug
box; the second is the y coordinate of the help box. No source rewrite is
needed. Each identity is consumed by the pinned compiler without stale-row
errors.

With both selectors in `scripts/build/satansfiddle.json` and the guard
removed, the complete object checker passes: `0x4F98` allocated bytes, 1,396
relocations, zero byte or resolved-relocation differences. The integrated
build leaves every other object and the linked image unchanged, so the
function is native.

## MenuMainInit

`MenuMainInit__FP13MENU_INIT_ARG` configures menu work areas, camera and scene
state, message objects, and the requested initial menu mode. It is native and
byte-identical; the allocation, constructor and save-data constraints are in
[user-data-colouring-20261010.md](user-data-colouring-20261010.md).
