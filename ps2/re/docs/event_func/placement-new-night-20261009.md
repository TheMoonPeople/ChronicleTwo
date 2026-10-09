# Scripted scene-character copying

`_COPY_CHARA` decodes a memory-stack number and source/destination character
slots, obtains the scene stack, constructs a character, and copies the source
into the assigned destination slot with its texture block. It accepts either
one argument naming an `ARG_DATA` tuple or three direct stack arguments.
The documented argument and character types are retained. The complete body
has no byte-offset object access, literal alias or identity helper, and a
source-local purpose comment accompanies manual guard removal.

Its exact row selects `event_func.cpp`, `_COPY_CHARA__FP12RS_STACKDATAi`,
`__nw__FUiP1`, `__ct__11CCharacter2Fv`, `after_constructor_inline` and
`expected_matches: 1`. The original direct constructor class is 6, and the
canonical two-word allocation pair becomes zero. Allocation still precedes
the source-character availability check, as the actual retail body does.
The numeric SetStatus kind/mask retains the documented API behavior without
asserting a new status enum.

Retail 0x0026A900 is LOCAL/FUNC, size 0x2B4 within extent 0x2C0. pn14 checks
the complete event_func object, its data, alignment and resolved relocations,
all 149 objects and `SCES_511.90: OK`. All assembled/source-only objects
outside the twelve promoted units retain baseline hashes; linked main/game
bytes and memory end agree. Receipts:
`.private/pntc/receipts/promote-eighteen-pn14-clean-build.log` and `.exit`,
`promote-eighteen-pn14-clean-objects.log`, and
`promote-eighteen-pn14-clean-artifacts.json`.

This promotion is independent of `_ESM_INITIALIZE`. That caller's inherited
`Ident` helper is inadmissible; its initial helper-free selected control has
nine differing register operands and stays guarded. Private natural-source
experiments are indexed in `.private/pntc/event-esm-natural/SUMMARY.md`.
Only the character-copy row is accepted into the production profile here.
The [design note](../satansfiddle/placement-new.md)
records the policy's measured behavior and its evidence limits.

Final marker-order validation also passes `promote-eighteen-final-build.log`,
`promote-eighteen-final-objects.log` (149/149), and
`promote-eighteen-final-artifacts.json`. Resolved game bytes and all objects outside the accepted units still agree.
Refreshed native coverage is 6,767 matched / 95 guarded / 10 assembly-only /
0 fuzzy, recorded in `promote-eighteen-coverage.log`.

## Current design reference

This dated evidence retains its original measurement scope.
[The consolidated placement-conversion design](../satansfiddle/placement-new.md) owns the current
capability, activation rows, safety requirements, and accepted source status.
