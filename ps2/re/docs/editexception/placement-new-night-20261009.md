# Fire-rain sprite construction

`InitFirePowder` loads the fire-rain texture and initializes the particle
array, sprite visual and black-fog frame for the already documented maps
and story condition. Its complete natural body is active after manually
removing the assembly guard.

The exact selector is `editexception.cpp` /
`InitFirePowder__FiP6CSceneiP9mgCMemory` / `__nw__FUiP1` /
`__ct__11mgC3DSpriteFv`, with `after_constructor_inline` and one eligible
class-6 construction. The canonical 150-word schedule difference reaches
zero. Particle array-new and the out-of-line frame/attribute constructors
are not selected. Eligibility and counts are verified independently of raw
constructor-name matches.

The recovered literal is `effect/firerain.img`; its now-unused alias and
data fragment are removed. `attr->fog = 2` selects black fog under the documented
`mgCFrameAttr::fog` contract (0 off, 1 scene, 2 black, 3 white); an owning
enum belongs in `mg_frame.hpp`. `MG_ZBUF_NO_WRITE` replaces the known Z-write sentinel. The existing
allocation-size helper performs real quadword rounding and predates this
proposal. Map IDs and story bit remain numerically expressed because no
owning enum is established by the available analysis.

Retail 0x002FCA30 is GLOBAL/FUNC, size 0x358 within extent 0x360. The header's
existing `@size 0x360` is an extent rather than symbol size; an exact private
correction is proposed without editing the shared header. pn13 passes the
complete resolved editexception object, all 149 units and `SCES_511.90: OK`.
Every assembled and source-only object outside the seven promoted units
retains its baseline hash; linked main/game bytes and memory extent agree.

This remains an isolated intentional toolchain policy, not a demonstrated
compiler-state repair; see the [design note](../satansfiddle/placement-new.md).
Receipts: `.private/pntc/receipts/natural-first-cleanups-corrected.log`,
`promote-eleven-accepted-build.log` and `.exit`,
`promote-eleven-accepted-objects.log`, and `promote-eleven-accepted-artifacts.json`.

## Current design reference

This dated evidence retains its original measurement scope.
[The consolidated placement-conversion design](../satansfiddle/placement-new.md) owns the current
capability, activation rows, safety requirements, and accepted source status.
