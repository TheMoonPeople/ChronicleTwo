# Native monster-book drawing

`CMosBookMenu::Draw` is native and exact. Its retail address is 0x2C2B90
and its manifest extent is 0xED0.

## Rendering and dependency contracts

The function returns when any background, book, or base texture is missing.
A texture-manager pointer spans the entire draw. `GetMenuPrim()` supplies the
primitive builder. The existing `mgRect<int>` and `mgRect<float>` are
16-byte-aligned four-value rectangles; their `Set` calls remain out of line.
The sprite renderer interprets the last two values as width and height.
`Menu3DivideTextureDraw` takes three successive four-halfword source texture
rectangles, represented by twelve halfwords per strip. These established
interfaces remain unchanged.

The background is tiled first. Three black shadow strips precede the three
normal strips. A regional model backing width is selected before drawing the
solid rectangle. The first pair of description underboards both use offset
row 1 and precede the regional width/shift test. Subsequent underboards use
rows 3, 5, 7, and 9, with the last two row-9 boards 34 and 68 pixels lower.
Row 11 uses the separately selected final width and shift. The page-counter
underboard has a fixed position. All these draws are explicit; folding them
into loops changes retail's call and global-read sequence.

The title and description headings use the book texture. The initial title
sets color before texture. The first base heading rereads offset row 0's Y
coordinate after retaining the base X/Y for the following two glyphs. Six
further headings use even rows 2 through 12. Resistance and weakness masks
are each scanned over eight bits, placing only selected icons consecutively.
The horizontal icon position is reset between the two rows. Their Y offsets
are 92 and 142 pixels relative to offset row 4. `SetMonsterInfo` constructs
both masks from values no larger than 64, so ordinary menu state never
selects bit seven. If externally forced, that arm reads the four-byte zero
alignment tail after the seven real coordinate pairs.

The camera's view matrix and eye are installed before the model draw. A
loaded monster is drawn only at load phase 4 with `show_wait > 16`. Its call
is `DrawDirect`, the retail virtual slot at +0x38, rather than `Draw` at +0x34.
The named model scissor rectangle preserves its stack lifetime. The base
texture is restored afterward. One regional width selection supplies all
three model-frame strips, then health, absorption, and defeated-count digits
are drawn.

The message texture is restored before constructing `CMenuFont`. The name
and area are measured and centered; their X coordinates are calculated
before the second string setup. Type, weakness, three drops, and the page
counter follow. Retail contains repeated `SetStr` calls for name, type,
area, and weakness. They are preserved directly; no undocumented wrapper
or hidden mutation is inferred from those calls. The page-counter text
buffer occupies 0x80 bytes, from stack offset 0x1B0 to the following local
at 0x230. An empty list displays current page zero.

## Native drawing data

The six former assembly tables are now local C++ definitions, with their
retail halfword contents and normal zero alignment tails:

| Table | Declared shape | Purpose |
| --- | --- | --- |
| `tiletbl` | `short[3][12]` | Background shadow and normal strips |
| `under_brdtbl` | `short[12]` | Description underboards |
| `put_under_offset` | `short[16][2]` | Heading and panel positions |
| `ic` | `short[7][2]` | Resistance and weakness icon UVs |
| `line` | `short[12]` | Vertical divider |
| `wakutbl` | `short[3][12]` | Monster-model frame strips |

The position table includes fifteen coordinate pairs and its final zero
pair. The icon table owns exactly seven UV pairs, or 0x1C bytes; the following
zero pair belongs to section alignment. A const local puts it in `.rodata`,
while retail requires initialized `.data`. An eight-pair local fails the
strict declared-extent proof. The nonconstant strip/position definitions retain retail's loads
and satisfy the existing mutable-pointer drawing interface. The supported
postprocessor places these named definitions in their retail sections; no
section attributes or tool changes are introduced.

The language-dependent `monstere_file_template` and its strings are native.
Its seven actual pointer entries are a single space, English, French,
German, English, Spanish, English; their alignment tail is zero. The format
strings are `  File  %3d/%3d`, `Fichier %3d/%3d`, `  Datei %3d/%3d`, and
`Archivo %3d/%3d`. An earlier isolated pointer-array probe failed 601 checks
because it left string identities unresolved across the unit; the complete
native-data conversion supplies those dependencies together.

## Matching evidence

The m2c reconstruction preserves explicit panel, heading, frame, and drop
sequences, the 0x80-byte text buffer, texture-manager lifetime, model scissor,
`DrawDirect`, and font-call timing. The callee-scoped title selector is
explained in [the compiler note](midday-book-sf.md).

The remaining six words swap the weak-row X coordinate and synthesized UV
stride between s2 and s3, at +0x91C, +0x924, +0x958, +0x96C, +0x988, and
+0x99C. Resetting the existing horizontal icon-position variable between
rows, instead of declaring a second X coordinate, resolves all six.
The retained local is named `icon_x`.
The emitted body is 0xEC4, followed by retail's zero alignment tail to 0xED0.

Initialization/declaration permutations, scoped loops, do/while, preincrement,
commutative additions, named UV pointers, a shared index, a shared Y
coordinate, and a named icon rectangle do not solve that allocation.
A shared X coordinate does. The named icon rectangle adds a by-value copy
and changes stack usage. No such copy is retained.

## Complete-object verification

The current native unit passes the PAL verifier and all 149 complete-object
comparisons. The menuchr comparison covers 0x11C9B allocated bytes and 4,010
resolved relocations, including the seven-pair icon payload and its
linker-owned alignment tail.
