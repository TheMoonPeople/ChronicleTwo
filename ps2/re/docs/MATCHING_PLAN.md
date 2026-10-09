# Remaining native matching plan

## Baseline and completion gate

At local revision `f0a4ce9`, the retail comparison contains 6,872 functions:
6,657 native matches and 215 outstanding functions. The outstanding inventory
comprises 192 guarded drafts, 15 assembly-only functions, and eight native
functions with residual differences. Assembly fallbacks and inline assembly do
not count as decompiled functions.

Each promotion requires documented dependency types, m2c analysis through
`decompile.sh`, source and header compliance with `AGENTS.md`, a zero-difference
whole-unit object comparison including resolved relocations, and a 100% objdiff
function comparison. Preserve retail function order and migrate associated data
to native definitions. Do not replace compiler-generated constructors or vtable
stores with manually written equivalents. Refresh the inventory after validated
batches. Each validated commit is pushed to remote master immediately; the
complete-game build and exact executable remain the final completion gate.

## Current measured coverage

After the validated promotions through `fa99453`, the report contains 6,664
perfect native functions and 208 outstanding functions: 191 guarded drafts,
15 assembly-only bodies, and two fuzzy native functions (DrawMesWin and _SHOT).
This count measures object matching, not full source compliance. In particular,
mg_dataset's htoi currently matches bytes using a pointer-to-integer expression
that still requires a compliant typed-indexing replacement. The complete game
has not reached the final matching or source-compliance gate.

## Dependency order

| Phase | Work | Prerequisite and exit evidence |
| --- | --- | --- |
| 1 | Restore the eight native residuals in mg_texture, menuaqua, nd_meswin, actionchara, and actscript. | Existing typed implementations; all 149 game object checks and executable comparison pass. |
| 2 | Resolve shared native allocation/constructor lowering, beginning with mg_tanime and funcpoint, then dependent mg_dataset, map, scene, and list routines. | Document CList/CObject, mgCFrame, and CMapParts dependencies; prove natural C++ allocation and null-check behavior with exact whole-unit checks before applying it to callers. |
| 3 | Complete small UI, scalar, and scene routines; migrate required native tables and repair owning declarations before consumers. | Prefer documented dependency-complete routines; leave a draft guarded until its entire unit passes. |
| 4 | Resolve VU and hardware routines through reproducible compiler support and native source. | Explain hardware effects and types; no inline assembly or instruction-byte substitution qualifies as a match. |
| 5 | Audit remaining source, headers, and data; regenerate the function inventory and verify the complete game. | Zero outstanding native functions, every unit exact, linked retail executable exact, and documentation/source review complete. |

Phases 2-4 may overlap only when they own different translation units and do not
change a shared dependency. Shared compiler changes must be generic, reproducible
from the repository's pinned toolchain, and tested against unaffected units.
Profiles must preserve existing selectors. A function-specific address or
occurrence counter is not a semantic explanation of compiler behavior.

## Measured results

Unit changes are integrated through the dependency plan above; experiments on
a unit are checked independently against the complete object before
integration.

- **mg_texture:** native AddHash, DelHash, and SearchHash now pass the whole-unit
  check (0x3674 bytes, 160 relocations), and all three objdiff scores are 100%.
  Direct table indexing and one shared optimization-level region are required;
  whole-unit level 2 was tested and changes unrelated functions.
- **menuaqua:** a callee-scoped 1.0f argument-order selector restores
  DrawEsaDropRoot. Canonical whole-unit validation passes 0x11C54 bytes and 2,970
  relocations; standard canonical objdiff reports 100% for the 316-byte function.
- **nd_meswin:** DrawMesWin needs different constant scheduling for calls sharing
  the same callee and literal. Broad 0.5f/0.95f selectors do not match; investigate
  a stable semantic discriminator without instruction or occurrence targeting.
- **actionchara:** duplicate assembly literal definitions account for most
  original failures. Generic nested-argument selectors restore the two native rotation
  calls. Canonical whole-unit validation passes 0x8F80 bytes and 1,035
  relocations; standard objdiff is 100% for both RoboWalkMoveIF (1,300 bytes)
  and RoboAirMoveIF (1,784 bytes).
- **actscript:** _SHOT retains a register-allocation residual. Earlier literal,
  local-variable, and helper-mask variants did not resolve it.
- **mg_tanime / funcpoint:** next small constructor-dependent trials test native
  allocation and scoped optimization; manual initializer/vtable writes remain
  prohibited.
- **mg_visual / visualmotion:** `mgCVisualFixMDT::Copy` and
  `mgCVisualMotionMDT::Copy` are native with placement-construction rows. The
  header no longer declares `mgCVisualMDT::operator=`; the compiler emits the
  generated assignment after `Copy` exactly as retail does.

Per-unit notes contain the detailed observations and failed experiments. Counts
above are a revision-specific baseline, not a claim that the remaining work is
complete or that a guarded draft is matched.

- **inventmn:** UpdataNetaMemoStr native promotion with a correctly typed name
  pointer array passes canonical whole-unit validation (0xFF2C bytes, 2,794
  relocations). Standard objdiff is 100% for the 404-byte function after its
  sort-key field documentation and removal of the obsolete assembly fallback.
