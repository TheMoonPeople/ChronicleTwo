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
