# Fishing character construction

`sgRestartFishing` resets the selected fishing equipment and bait and
constructs one `CCharacter2`. `StepDataLoading` loads the fishing resources and
constructs the rod, float, lure, hook and two cursor characters before
attaching them to the player; its seven constructions reuse one local
`CCharacter2 *`. Both are native with scoped placement rows in the compiler
profile (`__nw__FUiP1`, `__ct__11CCharacter2Fv`, after-inline conversion).

`InitSuccess` prepares the caught-fish character, fishing rewards and the
success message and remains guarded; see [notes.md](notes.md) for the
saved-register exchange that keeps it from matching.

## Caught-fish construction eligibility

The unchanged `InitSuccess` draft exposes one measured class-6 direct
`CCharacter2` construction, with exact caller, allocator and constructor
witnesses. A private row using either conversion timing consumes exactly one
site and restores retail's allocator-result test and delay-slot pointer copy.
Both timings leave **24/280** differing words: the player and constructed fish
exchange `s1` and `s2`, while the reward phase already matches. The emitted body
is `0x458` bytes inside retail's `0x460` extent.

With after-inline conversion, reversed player/fish pointer declarations,
constant pointer locals for either character, a reference to the constructed
object, a const reference to its pointer result, and an inherited
`CObjectFrame` pointer with a typed downcast all retain the same 24-word
exchange. These forms do not recover a separately coloured fish local.
No row or source change is activated.

A player reference bound after the existing null check, both global/local
assignment-chain orders for the constructed fish, and explicit same-type
casts of either character result also retain the 24-word exchange under the
one-site after-inline row. The assignment chains preserve the same single
eligible construction. These tests isolate the remaining pointer-web
colouring from the already-correct allocation guard.

An explicit `u_long128 *` allocation-buffer local, using the declared return
type of `mgCMemory::Alloc` and the placement-new overload's buffer type, also
retains **24/280** words. The exact after-inline row still consumes one site.
Separating allocation from construction therefore does not separate the
player and constructed-fish register colours.

## Block-count allocation expression

`sizeof(CCharacter2)` is `0x660`, so the existing early-return
`align16_blocks` helper gives 102 blocks and adding two reproduces retail's
`Alloc(0x68)`. Writing that expression inside placement new restores the
retail allocation-result test with the production profile and **no new row**,
but still leaves the same **24/280** saved-register exchange and `0x458` body.
A construction-local const pointer and direct assignment to `FishChara`
retain that result. The helper's statement-inline body is not an eligible
expression-inline site for the one-site conversion row; combining them is
rejected rather than producing an object. No helper or profile change is
activated while the function remains guarded.

## Saved-register numbering

A capture of MWCC's GPR interference graph for the block-count draft,
replayed by colouring simulation, reproduces the draft's colours exactly.
The texture manager, player and constructed fish all interfere and
simplification is blocked, so their relative node numbers decide the
saved registers. Retail's `s0`/`s1`/`s2` order needs the fish numbered
between the texture manager and the player, or the player numbered below
the fish.

Named function-scope locals are numbered downward in declaration order.
The constructed fish is never a named web: copy propagation replaces
`fish_chara` with the construction temporary, which belongs to the
`LoadFishFlag` block and is numbered after every function-scope local.
Moving the `fish_chara` declaration therefore changes nothing. Scopes are
numbered in pre-order, so a player declared in an outer block still numbers
above the fish. Temporaries created by inline expansion number below the
frontend's construction temporary.

| Player source form | Result |
|---|---|
| Same-type cast, assignment inside the null test, `!chara`, `= NULL` initializer | unchanged colours |
| Player in a block enclosing its uses | unchanged colours |
| `CCharacter2 *const &` bound to the call result | retail colours, but the temporary is spilled (`0x70` frame) |
| `static inline` scene-to-player accessor, this function only | **0/280** in the draft |
| The same accessor at all 19 player fetches in the unit | five matched functions regress |

The accessor works only because it makes the player an inline temporary.
It is not a unit-wide idiom: the other player fetches need the direct
call. No existing header inline returns the player character, so the
function stays guarded.

## Smart and deferred inline policies

With the block-count allocation, scoped `inline_depth(smart)` retains
**24/280** differing words and the `0x458` body: the player/fish saved-register
exchange remains. Leaving smart depth active through the next declaration
also retains that result, so an immediate depth reset does not hide a
numbering correction. `-inline deferred` retains the same target score and
regresses other native functions. Scoped `defer_codegen on`, alone or with
`inline_bottom_up on`, alongside smart depth also retains 24/280. These
policies do not recover the player-first temporary numbering required by the
interference graph. No inline policy or allocation-source edit is retained.
