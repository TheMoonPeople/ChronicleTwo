# Function-point animation list construction

`AssignFuncAnime__9CMapPartsFP9mgCMemory` is native and exact at `0x169560`. Its body is
`0x138` bytes within a `0x140` layout extent.

The function starts the part's function-point manager at `FUNC_POINT_ANIME` (retail
category 5). Each returned animation point receives a newly constructed
`CList<CObjAnime>` node allocated from the supplied `mgCMemory`, appended to
`anime_list`, and bound to the point and the current part by the existing
`CObjAnime::AssignFuncAnime` method. Allocation failure returns zero; reaching the end
of the manager returns one. The bind method's return value is ignored by this caller in
retail.

The relevant existing types already describe the actual storage:

| Type/member | Actual layout or use |
| --- | --- |
| `CMapParts` | Existing size `0x310`; manager at `+0x2B0`, animation list at `+0x2F0` |
| `CFuncPointMngr` | Existing manager extent `0x34`; `GetStart` selects the category and `Get` supplies each real point |
| `CObjAnime` | Existing size `0x30`, with six constructor-initialized scalar fields at `+0` through `+0x14` and aligned vector storage at `+0x20` |
| `CList<CObjAnime>` | Existing size `0x50`; `next`/`prev` at `+0`/`+4`, typed data at `+0x10`, compiler vptr at `+0x40` |
| Pool request | `(sizeof(CList<CObjAnime>) + 15) / 16 + 2`, retail seven quadwords: five for the actual object and the existing two-quadword reserve |

The constructor chain is the genuine existing `CList()` body `{ Initialize(); }` and the
genuine existing `CObjAnime()` constructor. It naturally emits the six retail scalar
stores and its virtual initializer call. The caller then invokes `node->Initialize()`
again, as retail explicitly does. Both calls remain actual virtual dispatches; no
constructor, helper, special member, vtable write or field assignment was fabricated.

The list append source uses the real `next`, `prev` and `data` members. Its existing
inline append idiom, including the nested tail and node checks, is also present in the
already matched `CMapParts::AddPiece` body. That idiom was in the first fresh natural
control; it was not added after observing a score. The function uses `pGetData()` to
reach the contained animation object.

The only successful source scheduling change is to consume the actual `Get()` return in
the loop condition:

```cpp
while ((point = func_point_mngr.Get()) != NULL) {
```

This is the same actual point later passed to `CObjAnime::AssignFuncAnime`. It combines
retrieval, termination and the point lifetime without extra state or a call boundary. No
dummy local, dead store, invented buffer, helper, manual special member, byte-field
arithmetic, type pun, inline asm, literal alias or floating-point policy was added. The
target has no float-valued call argument that warrants a float selector. The existing
unknown animation fields and vector are left with their genuine constructor behavior.

## Construction policy and controls

The `mapparts.cpp` row names this caller, allocator `__nw__FUiP1` and constructor
`__ct__17CList<9CObjAnime>Fv`, with `after_constructor_inline` and `expected_matches:
1`. Ordinary lowering exchanges the branch and saved-pointer copy at `+0x54/+0x58`; the
row restores the retail delay slot.

| Case | Actual source/profile change | Masked words | Body size | Relocation geometry |
| --- | --- | ---: | ---: | --- |
| `assembly-control` | Assembly fallback | No native target row | ASM reservation `0x140` | Wrapper passes |
| `natural-control` | Genuine typed body, first `for` form, ordinary lowering | 66 | `0x148` | Unequal |
| `after` | Same source, exact after-constructor row | 67 | `0x148` | Unequal |
| `before` | Same source, exact before-constructor row | 67 | `0x148` | Unequal |
| `condition-control` | Actual `Get()` result in while condition, ordinary lowering | 2 | `0x138` | Equal |
| `condition-after` | Same while source, exact after-constructor row | **0** | **`0x138`** | **Equal** |

The first for-loop form also changes point scheduling and join padding; construction
conversion alone does not repair it. Earlier do/while and helper-mask `0x30`
alternatives did not match.

## Native data ownership

The list vtable has size `0xC`, binding 13 and alignment 8. Its relocation at `+8`
targets the existing Initialize at `0x1696A0`; the first eight bytes are zero. The
`0x18` split piece includes twelve bytes of alignment before the CMapParts table at
`0x37B740`. Native data migration preserves this piece through the documented padding
rule, without enlarging the vtable. An earlier removal of the data marker before that
rule failed on the extent.

Construction selector semantics are documented in [the compiler
design](../satansfiddle/placement-new.md).
