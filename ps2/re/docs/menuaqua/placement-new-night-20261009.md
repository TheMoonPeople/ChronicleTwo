# Aquarium resource construction

`CAquarium::SettingAqua` replaces the active tank resources, initializes its
bubbles and water, loads saved fish and their thinking state, and constructs
the pairing character. Both existing aquarium notes and the documented memory,
character, frame, water, fish, bubble and parameter types were read before
experiments. The complete guard is removed by hand.

Retail `SettingAqua__9CAquariumFv` is GLOBAL/FUNC at 0x00215350, exact body
0xBB4 inside extent 0xBC0. Its canonical profile score is 16 words. The
previously documented caller-wide binary32 47.0f row removes fourteen
scheduling differences, and the semantic character construction policy removes
the remaining allocator branch/copy pair. The accepted proposed rows are:

* Placement: `menuaqua.cpp`, the exact caller above, `__nw__FUiP1`,
  `__ct__11CCharacter2Fv`, `after_constructor_inline`, `expected_matches: 1`.
  The direct character constructor has original inline class 6.
* Floating evaluation: same unit/caller, binary32 `0x423c0000`,
  `evaluate_first: true`, separately scoped to
  `Initialize__7CBubbleFP9mgCMemoryPfif` and
  `SetPosition__9mgCObjectFfff`, each `expected_matches: 1`.
  These are the bubble height and water Y-position, respectively.

The two callee/count rows replace the private caller-wide control. Both
verified compiles are zero and each row asserts one distinct call argument.
The bubble loop is one call syntax site; runtime iterations do not multiply
that count. Other allocations are not selected by the character identity.

## Natural source and initializer data

Sixteen file, texture and configuration strings are inline literals. Four
array initializer templates migrate from assembly to ordinary C++: bubble
counts `{224,224,24}`, minimum water `{0,0,0,1}`, maximum water `{68,0,43,1}`,
and initial fish position `{10,35,0,1}`. Their real int/float arrays replace
the inherited wrapper type and union use in this function. The unused
`aqua_bubble_counts` type and exclusive aliases/data markers are removed;
shared string aliases remain. The union still used by other functions is
not altered. All recovered values match the actual retail template bytes.

Moving just vector initialization to each actual use preserves body length
but changes eight stack displacements. Moving the real fish-data array and
`NEXT_THINK_PARAM` declarations to their uses restores their order relative
to the water vectors, and the complete function reaches zero. No padding,
helper, dummy array or lifetime variable is introduced. Quadword stack
partitioning remains typed element arithmetic over real allocation buffers.
The known depth-write value is `MG_ZBUF_WRITE`.

The retail tail writes the changed attribute's pointer back to its frame;
the fresh mandated m2c output explicitly records both the depth-write member
store and pointer publication. That actual memory operation is retained.
Deleting it shortens the body by four bytes and leaves 51 positional word
differences. It is distinct from an added no-op or source-only identity
helper. m2c's stale names/byte-pointer memory guesses are not type authority;
the existing documented headers supply the actual layouts.

Private variant receipts in `.private/pntc/aqua-natural/` and
`.private/pntc/experiments/aqua-*` record inherited zero, literal-only zero,
initializer 8, scoped-initializer zero, genuine arrays zero, and two counted
callee rows zero. Every one of the 123 other diagnostic function rows equals
the selected control. `literal-recovery.json` records exact resource bytes,
`retail-m2c.log` is the decompile.sh/m2c receipt, and `best.diff` records the
guarded natural cleanup. Two initial counted caller-wide rows are invalid
configuration trials (`expected_matches requires expression callee`); their
failed compiles are preserved and excluded from successful measurements.
The exact header-size correction is a private shared-header proposal.

Clean pn14 acceptance passes `SCES_511.90: OK` and 149/149 complete objects.
Every object outside the 17 promoted units keeps its baseline whole-file hash
in the recursive 306 assembled objects and 149 source-only base objects.
Linked main/game bytes and loaded memory end remain identical. Fresh
context/objdiff and coverage report 6,774 matched / 88 guarded /
10 assembly-only / 0 fuzzy. Receipts are
`.private/pntc/receipts/promote-twenty-five-clean-build.log` and `.exit`,
`promote-twenty-five-clean-objects.log`, `promote-twenty-five-clean-artifacts.json`,
`promote-twenty-five-progress.log` and `promote-twenty-five-coverage.log`.
`final-symbols.json` in the private aquarium directory records the exact
GLOBAL function size and all four LOCAL initializer templates, each 0x10
bytes including the count array’s linker padding.
The [design note](../satansfiddle/placement-new.md)
records the policy and its evidence limits.

## Current design reference

This dated evidence retains its original measurement scope.
[The consolidated placement-conversion design](../satansfiddle/placement-new.md) owns the current
capability, activation rows, safety requirements, and accepted source status.
