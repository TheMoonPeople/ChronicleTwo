# MenuMainInit save-data pointer colouring

`MenuMainInit__FP13MENU_INIT_ARG` is native and byte-identical. This note
records the constraints of its last residual, the save-data pointer block
(offsets 0x330-0x380), following the
[October 8 guard notes](remaining-guards-20261008.md).

## Source form

- `Alloc(align16_blocks(sizeof(T)) + 2)` for `MENU_DRAW_ENV` (15 blocks),
  `CMenuPosDataManage` (94), `CMenuKeyFunc` (24) and `CDC2Mes` (679). No
  Satan's Fiddle row is involved.
- `CMenuKeyFunc() : rect(0, 0, 0, 0)` in `menusys.hpp`. Retail initializes
  `rect` (+0x90) before constructing `have_item` (+0xC0) and `have_swap`
  (+0x12C).
- Function-local `light` and `lightcolor` tables, with the native switch
  emitting the jump table.
- In the save-data block, the user data is `&MenuActiveSaveData->user_data`
  held in the function's `user` local. The configuration comes from the inline
  `GetConfig()`. The system data, dungeon and aquarium addresses are bound as
  `T *const &` locals. The active character number is read into a local before
  the aquarium store.

| value | register |
|---|---|
| `MenuActiveSaveData` reload | a0 |
| user data (`+0x1D2A0`) | v0 |
| config, system data, dungeon | v1 |
| aquarium (`user + 0x4958`) | v1 |
| active character (`lh user+0x44D96`) | v0 |

## Why this form colours like retail

Every value in the block has low degree, so MWCC's simplifier removes them in
ascending virtual-register order and colours them in descending order. Each one
takes the first free register from v0. Retail's assignment therefore needs the
user pointer numbered above the config, system, dungeon and aquarium values.
The aquarium value must be numbered above the active-character value. The save
pointer must be numbered below the user pointer and a v1 value.

The interference-graph capture shows how MWCC numbers these GPR virtual
registers:

- Optimizer temporaries (the `MenuActiveSaveData` reload) come first.
- Inline-function temporaries follow, in reverse order of creation:
  `GetUserDataManager()` numbers above the later `GetConfig()`.
- Named locals that survive copy propagation follow, in reverse declaration
  order. Block-scoped `system`, `dungeon` and `aquarium` number 72, 71 and 70.
- Plain address expressions are code-generation temporaries and number above
  all of these.

With `GetUserDataManager()`, the user pointer is an inline temporary, below
the system, dungeon and aquarium code-generation temporaries, so it is coloured
after them and receives v1. As a function-scope named local holding
`&MenuActiveSaveData->user_data`, it numbers above the block-scoped bindings.
Plain named locals for system, dungeon and aquarium are copy-propagated back into
code-generation temporaries, but `T *const &` bindings survive as named locals.
Of the 64 combinations of getter or field user pointer, getter or field
configuration, plain or bound system/dungeon/aquarium, and a named or inline
active-character value, only a field user pointer with the getter
configuration and all three bindings gives retail's registers.

Reading the active character before the aquarium store gives retail's
`lh`, `lui`, `sw aquarium`, `sw active` order. Storing the aquarium first
leaves those three words out of order.

## Recorded negatives

- Statement order alone makes no difference: all 60 orders of user,
  publication, config, system and dungeon keep the user pointer in v1.
- The declaration position of `user` or of the active-character local does
  not change their numbers.
- `#pragma inline_depth(smart)`, `(3)` and `(4)` around the function, and
  inline getters for the system data, dungeon and aquarium, leave the
  registers unchanged.
- The earlier 810c9f05 body reached retail's order by reusing `common` and
  `draw_env` through unrelated pointer casts. That is not an acceptable source
  form.
