# Effect-base and extra-character construction

`CEffectScriptMan::BuildBase(int, ...)` loads an effect base's model or
sprite data and script into its designated memory and texture block.
`AssignCharacter` constructs the requested extra copies of its character
inside a fitted work-memory stack. Both natural bodies are active after
manual removal of their assembly guards.

Exact rows use `effscript.cpp`, scalar allocator `__nw__FUiP1`, constructor
`__ct__11CCharacter2Fv`, `after_constructor_inline`, and one eligible
class-6 construction per caller. Their full identities are
`BuildBase__16CEffectScriptManFiP1iP1iP9mgCMemoryi` and
`AssignCharacter__16CEffectScriptManFP11_EFF_SCRIPTi`. Each canonical
two-word allocator-result branch/copy difference becomes zero. The single
AssignCharacter loop expression is one static occurrence regardless of the
requested number of characters.

Retail strings are recovered as inline literals, including the exact
diagnostic newlines and `info.cfg`; only now-unused declarations and data
fragments are removed. The fitted stack uses the documented
`MG_STACK_MODE_FIT`. Full review covers model/sprite branches, texture-block
validation, failure exits and work-stack termination, without steering
helpers, object byte arithmetic or type-punned assignments.

Retail BuildBase at 0x002E5420 is GLOBAL/FUNC, size 0x630.
AssignCharacter at 0x002E6FA0 is GLOBAL/FUNC, size 0x1A8 within extent 0x1B0.
Its header's `@size 0x1B0` is a layout extent; an exact documentation
correction is saved privately because the lane does not own shared headers.
The [design note](../satansfiddle/placement-new.md)
describes the intentional policy and absence of a proven global state repair.

pn13 passes the complete resolved effscript object, all 149 units and
`SCES_511.90: OK`. All assembled and source-only objects outside the seven
promoted units retain baseline hashes; linked main/game bytes and loaded
memory extent agree. Body tails, alignment bytes and resolved relocations
are included in these checks.

Receipts: `.private/pntc/receipts/natural-first-cleanups-corrected.log`,
`promote-eleven-accepted-build.log` and `.exit`,
`promote-eleven-accepted-objects.log`, and `promote-eleven-accepted-artifacts.json`.
This note supersedes the earlier guarded status of these two callers only.

## Current design reference

This dated evidence retains its original measurement scope.
[The consolidated placement-conversion design](../satansfiddle/placement-new.md) owns the current
capability, activation rows, safety requirements, and accepted source status.
