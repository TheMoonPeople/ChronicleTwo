# Fishing-round and loading-thread character construction

`sgRestartFishing` starts a round with its selected rod and bait or lure,
loading the bait model and applying the documented rod attributes.
`StepDataLoading` loads the fishing models, textures, sound and configuration
on the loading thread. Their complete typed bodies are activated by manual
guard removal, and the source-defined worker receives a purpose comment.

Both rows use `fishing.cpp`, `__nw__FUiP1`, `__ct__11CCharacter2Fv` and
`after_constructor_inline`. Their caller identities and static counts are:

| Caller | Eligible constructions | Retail binding/address/size |
| --- | ---: | --- |
| `sgRestartFishing__FP11SubGameInfo` | 1 | GLOBAL/FUNC, 0x00301A00, 0x55C |
| `StepDataLoading__FPv` | 7 | LOCAL/FUNC, 0x003021C0, 0xB70 |

The seven worker expressions are separately present in source; the count is
not a runtime loop-iteration count. All direct constructors originally read
as class 6. Canonical differences of 2 and 651 words respectively reach zero.
The worker's change includes constructor-expansion scheduling, beyond its
seven allocation branch pairs.

Recovered paths, model/config names and diagnostics are inline literals,
including exact newline escapes. Shared literals still used by other source
functions keep their aliases/data. Typed `u_long128` read buffers and real
character pointers remain; there is no byte-field walk, artificial helper or
type-punned local. Established fishing-mode enums are retained. Item, map,
story-bit and sound-port numbers without established owner enums are left
numeric instead of assigning speculative names.

The restart symbol's layout extent is 0x560; the worker is exactly 0xB70.
An exact restart header-size correction is saved privately. pn14 checks the
complete fishing object, resolved worker-entry relocation, all 149 units and
`SCES_511.90: OK`. Every assembled and source-only object outside the twelve
promoted units retains its baseline hash; main/game bytes and memory end agree.

Receipts: `.private/pntc/receipts/natural-resource-callers.log`,
`fishing-literal-recovery.json`, `promote-eighteen-pn14-clean-build.log`
and `.exit`, `promote-eighteen-pn14-clean-objects.log`, and
`promote-eighteen-pn14-clean-artifacts.json`.
These promotions use the isolated intentional
[design note](../satansfiddle/placement-new.md).

Final marker-order validation also passes `promote-eighteen-final-build.log`,
`promote-eighteen-final-objects.log` (149/149), and
`promote-eighteen-final-artifacts.json`. Restoring the original data-marker
locations changes only fishing’s compiler/assembly object metadata hash;
resolved game bytes and all objects outside the accepted units still agree.
Refreshed native coverage is 6,767 matched / 95 guarded / 10 assembly-only /
0 fuzzy, recorded in `promote-eighteen-coverage.log`.

## Current design reference

This dated evidence retains its original measurement scope.
[The consolidated placement-conversion design](../satansfiddle/placement-new.md) owns the current
capability, activation rows, safety requirements, and accepted source status.
