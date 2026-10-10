# MenuMainInit save-data pointer colouring

This note covers the remaining residual in `MenuMainInit__FP13MENU_INIT_ARG`,
following the [October 8 guard notes](remaining-guards-20261008.md).

## Best natural draft

The best natural draft has 13 differing words out of 948, and all 52 other
menumain natives stay exact. It uses:

- `Alloc(align16_blocks(sizeof(T)) + 2)` for `MENU_DRAW_ENV` (15 blocks),
  `CMenuPosDataManage` (94), `CMenuKeyFunc` (24) and `CDC2Mes` (679). This
  needs no new Satan's Fiddle rows.
- `CMenuKeyFunc() : rect(0, 0, 0, 0)` in `menusys.hpp`. Retail initializes
  `rect` (+0x90) before constructing `have_item` (+0xC0) and `have_swap`
  (+0x12C).
- Function-local `light` and `lightcolor` tables, with the native switch
  emitting the jump table.

All 13 differing words sit in the save-data pointer block (offsets
0x330-0x380). The instructions match, but the registers do not:

| value | retail | native |
|---|---|---|
| `MenuActiveSaveData` reload | a0 | a0 |
| user data (`+0x1D2A0`) | v0 | v1 |
| config, system data, dungeon | v1 | v0 |
| aquarium (`user + 0x4958`) | v1 | v0 |
| active character (`lh user+0x44D96`) | v0 | v1 |

## Colouring constraints established

A standalone MWCC harness reproduces the native colouring exactly when the
block is followed by the `GetMainScene` call. The block's interference graph is
the same in retail and native; only the colouring order differs. Native colours
the short address temporaries first and the user pointer after them. Retail
colours the user pointer first.

- With no unconditional call after the block (and in leaf functions), the
  block never uses v0, and every value moves up one register. The return
  register is live to the function exit until a later call redefines it.
- Statement order makes no difference: all 60 orders of user, publication,
  config, system and dungeon keep the user pointer in v1. The best of them
  scores 11 words, but with the wrong store order.
- Making each value a plain expression, a named local, or a `T *const &`
  binding (729 combinations) never moves the address temporaries after the
  user pointer.
- Binding the aquarium address as `CFishAquarium *const &` does give retail's
  aquarium v1 / active v0 pair. However, the user pointer then moves to a0.
- `#pragma inline_depth(smart)`, `(3)` and `(4)` around the function leave
  the same 13 words.
- Adding inline getters (`GetMenuSystemData`, `GetSaveDataDungeon`,
  `GetFishAquarium`) or using `GetActiveChrNo` changes nothing.

The 810c9f05 body still scores 0 with today's compiler. It relies on two
things together:

- The save pointer and the four address temporaries are later webs of
  `common` and `draw_env`, reassigned through unrelated pointer casts.
- Those variables get a real first web from explicit
  `if ((x = (T *) operator new(size, Alloc(n))) != NULL)` allocation.

Either reuse alone scores 8 or 13. With placement-new expressions the first
webs copy-propagate away, and the same casts score 16. This is how the old
body reached retail's order: variables reused in a later web colour after
named single-web locals. It is not a natural source form.

The natural source still needs a form that colours the four address
temporaries, and the `MenuActiveSaveData` reload, after the user pointer.
