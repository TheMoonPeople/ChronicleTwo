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
