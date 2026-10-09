# Map-part data migration

The `830e48ed` baseline has four RODATA markers, no BSS markers, and
0/420 matched data bytes.

`CCharacter2::SetPosition(float,float,float)` initializes its position array
as `{0,0,0,1}`. This supplies the 16-byte `at_244` aggregate directly and
removes its anonymous extern and quadword type-punned initializer copy.
The native compiler already emits the 0xF8-byte treasure-box vtable;
removing its marker uses that table with its original methods and symbols.
No guarded or assembly-only function changes.

Two vtable markers remain:

- `__vt__17CList_9CObjAnime___DATA`: assembly-only `AssignFuncAnime`
  explicitly relocates against this list vtable. The current native source
  does not emit the table.
- `__vt__9CMapParts__DATA`: retained at this step; the native table is
  described under *Native `CMapParts` vtable* below.

Both accepted steps pass PAL and all 149 object comparisons. Only migrated
units change their object-file hashes from the warm baseline.
Receipts: `.private/dataF/mapparts-position-template-{build,objects}.log`,
`mapparts-treasure-vtable-{build,objects}.log`, and
`mapparts-final-{refresh,coverage,metrics}.log`.

Final markers are **2 RODATA / 0 BSS**; matched data is **16/420**.
The vtable section remains incomplete in source-only coverage, so the
native treasure-box table does not earn aggregate section credit.
No function is promoted and no shared-file proposal is made.


## Native `CMapParts` vtable

MWCC emits a class's vtable in the translation unit that defines its first
non-inline virtual function. Retail binds `Draw__9CMapPartsFv` (0x15F7E0)
and `DrawDirect__9CMapPartsFv` (0x15F7F0) weak (binding 13) inside map's
`.text`, so both are inline in the class body in `mapparts.hpp`, tail
calling `DrawSub(0)` and `DrawSub(1)`. `CMapParts`'s first non-inline virtual
is then `Initialize` (0x167660, the first function of this unit's `.text`),
and `mapparts.cpp` emits the exact 132-byte `__vt__9CMapParts` (0x37B740)
from its own compile. `map.o` keeps only weak copies of the two inline
bodies. Class layout, constructors, guarded `Copy` and assembly-only
`AssignFuncAnime` are unchanged. The `CList<CObjAnime>` marker remains
because no active native code emits that table.

Markers: RODATA **2 → 1**, BSS **0 → 0**. Refreshed matched data:
**16 / 420** (the `.vtables` run stays incomplete while the list table is
a marker). PAL is `SCES_511.90: OK`, all **149/149** canonical objects pass,
and code metrics are unchanged (**6,787** perfect functions). No function is
promoted. Receipts: `.private/vtable-r0/src-{build,check,tests}.log` and
`src-report.json`.
