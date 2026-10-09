# Placement-new null checks in MWCC 3.0-011126

## Summary

`CFuncPointMngr::Add(int, mgCMemory*)` is native and matches retail.

`CFuncPointMngr::Add(int, mgCMemory*)` allocates a `CList<CFuncPoint>` node with the
out-of-line `operator new(size_t, u_long128 *)` from `mg_memory.hpp`. Non-trivial
construction makes MWCC emit a null check of the allocation result; how that result is
bound to the persistent object pointer depends on the inline classification of the
constructor (see [Constructor inline classification](#constructor-inline-classification)).
The natural source is:

```cpp
CFuncPoint *CFuncPointMngr::Add(int type, mgCMemory *stack) {
    CList<CFuncPoint> *node = new (stack->Alloc(0x20)) CList<CFuncPoint>;
    if (node == NULL) {
        return NULL;
    }
    node->data.Initialize();
    return Add(type, node);
}
```

With plain MWCC this source copies `v0` to `s0` and branches on `s0` (two words differ
from retail). It is matched through one scoped placement-conversion row described in
[the shared placement-conversion design](../satansfiddle/placement-new.md); no source
helper, artificial control flow or stored inline metadata is used.

## Retail instructions

`CFuncPointMngr::Add(int, mgCMemory*)`, address 0x002A11C0, extent 0xA0:

```asm
+0x2c  jal   __nw__FUiP1
+0x30  move  a1,v0
+0x34  beqz  v0,+0x60
+0x38  move  s0,v0             # branch delay slot
```

Construction writes the list vptr, constructs the frame at node+0x80, and
dispatches virtual list initialization. A separate check at +0x60 rejects
a NULL node. Only afterwards does +0x70 call point initialization on node+0x10;
the existing list-taking `Add` overload is called at +0x80.

`mgCTextureAnime::NewTexAnimeData` (0x0013DA40, extent 0x80) is the related case in a
`schedule off` unit: retail copies to `s0` before `beqz v0`, and plain MWCC saves
`s0` only on the success path. [mg_tanime's notes](../mg_tanime/notes.md) cover it.

## Constructor evidence

`CList<T>` is defined in `mg_tanime.hpp`. Its constructor calls virtual
`Initialize()` after constructing its data member.

- Retail `__ct__10CFuncPointFv` at 0x0015F5D0 only constructs its `mgCFrame`
  member at +0x70. It does not call point initialization.
- Retail `__ct__19CList_10CFuncPoint_Fv` at 0x002A13E0, used by `Reserve`'s
  array construction, writes the list vptr, constructs the frame, and
  dispatches list initialization. It does not initialize the point's other
  fields either.
- The out-of-line `mgCTexAnimeData` constructor at 0x0013C340 calls its
  `Initialize`. Retail `NewTexAnimeData` calls that constructor at +0x48,
  followed by virtual list initialization.
- `Initialize__23CList_14PartsGroupData_Fv` at 0x0015DB50 and
  `Initialize__18CList_P9CMapParts_Fv` at 0x0015E3D0 only clear the links.

Making `CFuncPoint()` call `Initialize()` contradicts these retail constructors: it moves
point initialization before list initialization, removes the caller's second null guard,
and changes five other units' objects (`map`, `dng_main`, `scene`, `funcpoint`,
`scenevillager`).

## Two lowerings of a scalar placement new-expression

Class A: the guard tests `v0` and the copy to the saved register sits after it (in the
delay slot under scheduling). Class B: the copy to a saved register precedes the guard and
the saved register is tested. Retail `Add` is class A; plain MWCC produces class B for it.

The distinction is made in the frontend, before register allocation. At the original
high-level IR boundary (compiler image address `0x436f5d`), class-A callers already have
the allocator assignment inside a conditional statement. Class-B callers retain a
construction node (kind `0x3a`) holding the allocation and a constructor comma expression;
IR optimization (`0x436f66`) turns it into a separate allocation assignment followed by
a condition that loads the object temporary. The expansion paths are:

- Early inline statement conversion, construction handler `0x463bf0`: builds a
  conditional statement whose expression assigns the allocator result. Constructor
  statements follow.
- Late IroLinearForm, construction case `0x4c2d8a`: emits a separate assignment, then a
  conditional load of its fresh temporary.

The inliner reads callee inline-info byte +0x64 at `0x462fa0`. Constructors classified
`3` request statement conversion (class A); constructors classified `6` stay expression
inlines (class B). After code selection the difference is explicit:

```text
class B (funcpoint Add):      class A (inventmn CMenuInvent):
result39 = v0                 result86 = v0
object35 = result39           object67 = result86
if (object35 == 0) ...        if (result86 == 0) ...
```

The first coalescer (`0x4a73c0`) merges the class-B result into the object temporary while
the guard still tests the object; coloring puts it in `s0`, so the copy must execute before
the guard. In class A the short-lived result merges into ABI register 2 and the object
stays separate because it survives the constructor calls, so the delay-slot pass can place
the copy after the independent `v0` guard. Helper-register masks, float evaluation order
and translation-unit history do not change this binding.

Positive natural class-A examples in DC2: `NameRegistInit` (ordinary `CNameRegiMenu`
constructor defined inline in the source before the caller, named local destination),
`MenuInventInit`'s direct `new CMenuInvent` and `new CMenuMoveItem`. `CMenuMoveItem` is
class 3 because its two `CGameDataUsed` members produce a compiler-generated construction
loop. Callers that explicitly call `operator new` and then `Initialize` are not examples of
new-expression lowering. `mapPARTS` constructs `CList<CMapParts>` under `inline_depth(0)`
with an out-of-line constructor.

Source variations that do not change the class for `Add`: naming the `u_long128 *` buffer
before `new(buffer)`, splitting the declaration initializer, direct return of the
new-expression, a compiler-generated instead of empty `CFuncPoint` constructor, complete
`CList` specializations, out-of-class inline constructors, and compiling at `-O2` (which
grows the body to 0xC4 bytes). An invented inline helper such as
`AddNewFuncPoint(manager, type, new(...))` matches all 40 words but is not admissible
source.

Dark Cloud 1 (MWCC 2.3.3, `-O2`) has 10 scalar placement sites (4 class A, 6 class B) and
9 array sites. `CreateVisual` shows both classes in one function: out-of-line base
constructors give A, the implicit derived `CVisualShadow` constructor (which must keep the
original pointer to write the derived vptr after the base ctor) gives B. A named local, a
buffer cast, constructor arguments, an explicit caller null test or an out-of-line
constructor do not by themselves select the class. Array sites call
`__construct_new_array`, whose own argument guard is a runtime-helper property.

## Constructor inline classification

These are properties of the pinned MWCC 3.0-011126 image.

### Exact classifier rule

The signature gate returns **0**, rather than 3, for variadic functions,
indirectly returned classes with a registered destructor, and by-value class parameters with a registered
destructor. At `0x46503F`, `0x4590E0` tests the result-passing convention.
`0x45EF30` searches the class members for the interned `__dt` name from
`0x57AB54`. Variadic and terminal argument markers are checked at
`0x465078` and `0x465086`. Classes with constructors but no destructor are
not rejected by this test. The result-convention query is boolean: a true
result rejects the return only when its type is kind 5 and destructor lookup
succeeds.

For eligible signatures, the classifier (`0x465030`) starts at **6** and walks the
already lowered linked statement list. The exact body rule is:

```text
class = 6
for each statement:
    if DWORD(statement + 0x12) != 0:
        return 3
    if kind == 4:                         # expression statement
        continue
    if kind == 8:                         # return statement
        if next != NULL:
            class = 3
        else if expression == NULL and return_type != canonical_void:
            class = 3
        continue
    class = 3
return class
```

`0x4650B1` reads a **DWORD**, not a byte, at statement+0x12. The local-object
case with a destructor has nonzero cleanup-associated metadata there;
ordinary scalar, aggregate and constructor-only locals do not.
The jump table at `0x5376E4` maps kinds 4/5/6/7/8 to
`0x4650EC/0x4650EA/0x4650EA/0x4650EA/0x4650D3`. Thus expression statements
are accepted, switch and conditional statements are not, and return has the
special final-statement rule. Every other kind also selects 3, including
labels (2), jumps (3) and any retained scope marker. The classifier does not
recursively inspect expression kinds inside an ordinary expression statement.
Inline-info is zeroed before classification and published only after the byte is
written; the conversion-request flag is reset before each expression walk.

### Source forms and their class

| Body form | Class |
| --- | --- |
| Empty constructor; one assignment; several assignments | 6 |
| Scalar local, uninitialized scalar local, ordinary local array, nested braces/local scope | 6 |
| Aggregate local initialization/copy; value-initialized aggregate member | 6 |
| Local with constructor but no destructor | 6 |
| Local requiring a destructor | 3 (nonzero +0x12 metadata) |
| One or multiple out-of-line void calls | 6 |
| Final `return;` in void function or constructor; final value return | 6 (constructor return is lowered to a return of `this`) |
| Multiple/early returns with retained control flow | 3 |
| `for`, `while`, `do` initialization loops | 3 |
| `if`/`else`; `switch` | 3 |
| Ternary or logical expression inside an assignment/expression statement | 6 |
| Constructor calls an inline method containing a loop | Constructor 6; method 3, and the method's class-3 read requests conversion of the enclosing new-expression |
| Constructor calls an inline straight-line method | Both 6 |
| Nontrivial member array, including declared extent 1 | 3 (generated element-construction loop) |
| Uninitialized trivial member array | 6 |
| Variadic signature; by-value/returned class with destructor | 0 (signature gate) |
| By-value/returned class with constructors but no destructor | 6 |

A `return;` followed by unreachable source statements is not automatically
class 3: the unreachable statements are dropped before the classifier.

An inlined callee's class-3 read sets the conversion request even while an outer class-6
constructor is being expression-inlined; the statement walker then converts the entire
enclosing expression. A loop in an out-of-line or virtual initialization method does not
propagate that request. A scalar field must not be changed into a singleton array solely
to obtain class 3.

### Natural class-3 constructors

Genuine homogeneous member-array initialization in a constructor is class 3 and fully
unrolls to the retail stores, so the caller's guard becomes class A without any further
change. `CShopMenu` (`menushop.hpp`, `arrow_flash[2] = 0`, ascending +0x1D0/+0x1D4 stores;
caller `MenuShopInit`) and `CSaveMenuClass` (`menuop.hpp`, `slot_form[2] = NULL`,
ascending +0x17C/+0x180 stores; caller `MenuSaveInit`) match this way.

`CList<CFuncPoint>` has no member array to initialize: its construction is the list vptr
at node+0x1D0, the frame constructor at node+0x80 and virtual list initialization, with
point initialization after the caller's second null guard. `CFuncPoint` in `mapload.hpp`
contains an `mgCFrame`. There is therefore no natural class-3 form for `Add`, which is why
it uses the scoped conversion row.
