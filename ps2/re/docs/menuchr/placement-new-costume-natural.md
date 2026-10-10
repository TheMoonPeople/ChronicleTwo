# Costume initializer construction

`MenuCostumeInit__FP9mgCMemoryPii` is native and exact. It uses the source-owned
CMenuCostumeSel constructor and one camera argument policy.

## Constructor behavior and source boundary

`CMenuCostumeSel` is 0x2d0, comprising the 0x110 base menu, 0xc0 follow camera, real
selection/list arrays, 0x30 memory manager and character status pointer. Its allocation
reserves 0x2f manager quadwords. No field layout, array dimension, vtable or generated
special member is changed.

Retail resets the source-owned `MenuCosutumeLoadPhase` and obtains Max's character data
inside the successful constructor guard. The inherited caller performs both operations
after construction, outside that guard. The actual constructor clears three costume
selections and then three line-wave values in separate loops, then clears the real
`costume_list[3][8]` by column: rows zero, one and two for each of eight columns. A
column loop with three explicit row stores unrolls to the observed 24 halfword stores.
A nested row loop unrolls only the inner loop and keeps an eight-iteration column loop;
one combined selection/line-wave loop interleaves their stores (four words). Retail does not contain the inherited
constructor's extra costume-count or cursor-coordinate/wave initialization.

The constructor is an out-of-class inline definition immediately before its sole
allocation caller, following the unit's existing constructor style. The owning header
holds its documented declaration. This lets the real source-owned phase operation remain in its source unit;
no steering helper or manual compiler special member is introduced. No standalone
constructor symbol is emitted, matching the retail symbol inventory.

The constructor retains actual camera setup, position/rotation constants, list pointers
and loading/help state. The caller binds the real remaining stack capacity before
passing the stack top into `stSetBuffer`. Its `buffer_quadwords` value is consumed as
that argument. Binding the top first leaves seven differences, while capacity first
restores retail's load and subtraction order. The mode parameter remains unused, as in
retail.

Default costume flags are the genuine 64-bit value `0x1274521cb`; `CostumeAttr`,
`CostumeOptionEnv` and the relevant API use that width. A 32-bit substitute would
discard the high bit. The source includes the owning `title.hpp` declaration instead of
repeating an extern. No target string alias, reference pun or raw field-address
calculation remains.

## Compiler measurements

| Source/control | Differing words | Native body |
| --- | ---: | ---: |
| Current source and production profile | 161 | 0x2bc |
| Original constructor, exact after-inline row | 158 | 0x2b8 |
| Correct typed constructor, ordinary lowering | 17 | 0x2d8 |
| Actual camera zero evaluated first | 7 | 0x2d8 |
| Capacity bound before stack-top argument | 0 | 0x2d8 |
| Owning-header include and final hygiene | 0 | 0x2d8 |

The original constructor has one normally witnessed class-6 root, and its exact
placement row verifies expected/actual count one. The corrected real column loop changes
ordinary inline lowering: the corresponding diagnostic reports class 3, and the stale
class-6 row rejects expected one / actual zero. The rejection is retained. The final
zero has **no Costume placement row**; neither eligibility nor the positive-count
assertion is weakened.

The sole profile delta selects logical `menuchr.cpp`, exact
`MenuCostumeInit__FP9mgCMemoryPii`, actual callee `__ct__15mgCCameraFollowFffff`,
binary32 positive zero, `evaluate_first: true` and expected count one. It selects the
real camera's third float argument. Other camera-zero and menu-fade calls remain
unselected.


The retail GLOBAL/FUNC body is `0x2D8` within extent `0x2E0`; all 44 relocations resolve
to retail. The native costume vtable is a weak `0x20`-byte object with six matching targets; its
former assembly data marker is removed. The complete menuchr object, the 149-unit object
check and the PAL verifier pass.

Construction selector semantics are documented in [the compiler
design](../satansfiddle/placement-new.md).
