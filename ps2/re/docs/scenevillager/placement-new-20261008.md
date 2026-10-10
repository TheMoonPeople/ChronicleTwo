# Villager frame attributes — October 8 midday

The literal-allocation negatives below describe the earlier guarded draft.
The native block-count allocation form and exact match are documented in
[notes.md](notes.md#charaobjectonoff).

On baseline `c79e57c`, the canonical native `CharaObjectOnOff` draft differs
in 6/112 words, with a 0x1C0 body matching retail's extent. It finds the
villager's named show and hide frames, allocates missing `mgCFrameAttr`
objects, and sets their drawing state. Existing type and lookup-function
documentation remains applicable.

The show-loop allocation already matches every instruction and relocation
identity. The hide loop uses the same attribute constructor but moves the
allocation result to `a0` before testing it; retail tests `v0` and places
that move in the branch delay slot. The extra draft nop shifts the call and
result copy within `+0x158..+0x16C`, then both versions rejoin at `+0x170`.
This localized difference is not evidence that the attribute's layout or
constructor body is wrong.

| Natural caller-lifetime probe | Words different |
|---|---:|
| Retained separate loop counters and block-local attribute pointers | 6/112 |
| Reuse `i` for the hide loop | 14/112 |
| Declare one attribute pointer for both loops | 6/112 |
| Give the hide count a separate local | 12/112 |

None improves the allocation site, and no source change or profile row is
retained. The matching build continues to use the assembly gap. Measurements
use MWCC 3.0-011126, the existing flags/pragmas and
`chronicletwo_dev:sf-d8bf13c`; word comparisons mask relocated operands and
check their identities separately.

Receipts: `.private/placenew-midday/baseline-native/scenevillager/` and the
`villager-*` directories under `.private/placenew-midday/probes/`.

## Construction boundary

`mgCFrameAttr` is 0x90 bytes and its constructor is an out-of-line call to
`__ct__12mgCFrameAttrFv`, not an inline class-6 construction. Both retail loops
call that constructor after the same 0x90-byte placement allocation; the
memory stack reserves eleven quadwords. The existing statement-conversion
capability selects direct expression-inline class-6 roots, so it cannot select
these calls. A row naming the attribute constructor does not address this
residual within that capability's verified boundary.

The show-loop attribute value remains in `v0` through construction and its
subsequent store and draw update. The hide-loop value is in `a0` before and
after allocation; its constructor returns in `v0` and the result is copied back
to `a0`. The hide loop therefore exposes the allocation-result copy preceding
the null test, while the show loop has no corresponding copy instruction.
The two loops do not establish different attribute types or constructors.

Under the current deterministic compiler profile, ordinary construction-result
copies, const pointer locals, const references to pointer temporaries, explicit
same-type pointer casts, and value-initialized construction all retain the
six-word residual. Chaining the frame store with the local assignment, or
storing a separate const result before updating the mutable attribute local,
also retains it. An explicit null-test condition with separate success/failure
frame stores instead grows the function to 0x1D8 and retains the allocation
branch mismatch. These controls rule out the tested result-substitution and
assignment-order forms; they do not identify the original source spelling or
establish a new compiler policy. The existing natural guarded draft remains
the closest measured form.
