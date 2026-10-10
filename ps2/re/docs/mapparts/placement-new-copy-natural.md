# Map-parts deep copying

`Copy__9CMapPartsFR9CMapPartsP9mgCMemory` is native and exact. Its body is `0x6AC` bytes
within a `0x6B0` retail extent; the final four bytes are zero alignment padding.

## Retail behavior and source ownership

Retail first chooses the pool branch. Each branch independently performs `dest = *this`
through the compiler's implicit member assignment. No new copy constructor or assignment
operator is declared or hand-written. The compiler preserves the destination's dynamic
vptr, copies the real base vectors and metadata, the two 32-byte names, genuine
four-color array, bounds and manager state, and calls the existing authored mgCFrame and
mgVu0FBOX assignment APIs. The first complete assignment prefix is already exact in the
initial draft. Bulk FPR copies of the manager's real pointer list and mixed condition
record are compiler-generated aggregate copies; they do not imply float overlays or
replacement field types.

With a pool, the function traverses the original piece list and copies only nodes whose
signed-short `data.col_type` is zero. The `lh` at `0x16916C` reads the real node's data
field at node `+0xB0`; this is not the separate `data.type` model-kind field. It
requests fifteen quadwords from mgCMemory and uses ordinary typed placement construction
of a `0xD0` CList<CMapPiece>. The source expression uses the actual node size rounded to
quadwords plus the retail two-quadword allowance. It neither constructs raw storage nor
writes any vtable by hand.

The existing constructor chain naturally installs the CList table and constructs its
contained CMapPiece through mgCObject, CObject and CObjectFrame. Each authored
constructor's virtual Initialize boundary and the final list Initialize are preserved.
The scalar allocation result is checked after that chain. Failure branches directly to
the epilogue (`0x169220` to `0x169538`): the source returns without publishing its
partially allocated new head or performing the manager/animation copies. It retains the
initial shallow assignment. Replacing this return with a break would change retail
behavior.

For each successful node, the real nonvirtual CMapPiece::Copy copies its data. The
ordinary list append uses real next/prev fields. The nonempty tail walk and its existing
null checks follow retail and the current matched AddPiece idiom; no append wrapper or
helper is invented. After the traversal completes, the destination receives the new
head. The source manager's virtual deep Copy is then called, followed by destination
AssignFuncAnime. With no pool, only the implicit assignment executes. There is no
destination Initialize in this caller and no fabricated default state.

The final source initializes the output-list accumulator to NULL before loading the
source traversal cursor. These are the same two independently initialized, genuinely
used local bindings as in the first draft. The accumulator owns the new list for the
whole traversal; the cursor visits the old list. The single source control changes only
their declaration order. It adds no state, store, helper, padding, artificial use or
lifetime boundary. Its effect is the exact remaining retail register allocation: head in
s0 and cursor in s1. No declaration reordering sweep was performed.

## Types and inspected functions

| Type or API | Verified role in this caller |
|---|---|
| CMapParts, `0x310` | Existing CObject-derived named map placement; Copy is virtual at slot `0x80`. Names are `+0x70/+0x90`, piece_list `+0xB0`, real frame `+0xC0`, colors `+0x1F0`, manager `+0x2B0`, animation list `+0x2F0`, conditions `+0x2FC`. |
| mgCObject, `0x50` | Existing aligned position/rotation/scale vectors and changed/use_srt fields; its authored ctor calls virtual Initialize. |
| CObject, `0x70` | Existing renderable base; its authored Copy uses ordinary base assignment. Its normal constructor/Initialize chain is used unchanged. |
| CObjectFrame, `0x80` | Existing frame pointer at `+0x70`; out-of-line Copy shares that pointer in either memory branch and resets fade_alpha. |
| mgCFrame, `0x110` | Genuine embedded frame and existing non-const-reference authored assignment; its source copies the frame, unlinks hierarchy links, marks changed and clears reference. No replacement special member is supplied. |
| mgVu0FBOX, `0x20` | Real max/min vectors and existing authored assignment API; the caller emits the exact retail out-of-line calls. Its inherited implementation uses quadword casts; none is adopted into this target. |
| CMapPiece, `0xB0` | Existing CObjectFrame-derived piece; col_type is signed short `+0xA0`, col_param `+0xA2`. Existing typed Copy initializes the destination, copies base/frame metadata and PieceMaterial records, optionally clones its character, copies col_type and retains the initialized col_param. |
| CList<CMapPiece>, `0xD0` | Existing CList template: next/prev `+0/+4`, data `+0x10`, compiler vptr `+0xC0`. Generic authored Initialize clears both links; actual retail initializer is `0x1637D0`. Owning mapload notes assign this instantiation to that unit. |
| CFuncPointMngr, `0x34` | Existing ten category-list pointers, traversal pointer and vptr; virtual deep Copy is called through the real object. Its inherited out-of-line settings overlays remain unchanged and are not copied into this caller. |
| CFuncPointCheck, `0x8` | Existing `{float time; s32 anime_frame;}` aggregate copied implicitly; its authored default constructor only initializes time and is not newly invoked here. |
| mgCMemory, `0x30` | Quadword allocator; existing `Alloc(int)` returns u_long128 storage and ordinary `operator new(size_t,u_long128*)` is the witnessed `__nw__FUiP1`. No allocator/header/profile-global hook is changed. |
| sdk/basic types | Existing sceVu0FVECTOR arrays have their real 16-byte alignment; signed short, size_t and u_long128 use current documented target aliases. No type pun, widened fake array or field-byte arithmetic is introduced. |

CMap::PlaceParts and CEditMap::BuildEditParts copy into derived destinations. Their use
requires implicit assignment to preserve the destination vptr.

## Construction policy and controls

The row names `mapparts.cpp`, this caller, allocator `__nw__FUiP1` and constructor
`__ct__17CList<9CMapPiece>Fv`, with `after_constructor_inline` and `expected_matches:
1`.

| Source/control | Word difference | Actual body | Reservation | Relocation offsets/types |
|---|---:|---:|---:|---|
| Natural source, ordinary lowering | 246 | `0x684` | `0x6B0` | Different |
| before, sole witnessed row | 247 | `0x67C` | `0x6B0` | Different |
| after, sole witnessed row | 12 | `0x6AC` | `0x6B0` | Equal |
| accumulator-before-cursor, same after row | 0 | `0x6AC` | `0x6B0` | Equal |

The twelve differences with after-inline conversion are solely the cursor/head s0/s1
exchange. Before-inline conversion leaves a different body and cannot substitute for the
selected timing. The native list vtable has size twelve, binding 13 and a relocation to
Initialize at `0x1637D0`. The complete wrapper preserves the existing mapload ownership
of that initializer and table.

Construction selector semantics are documented in [the compiler
design](../satansfiddle/placement-new.md).
