# mg_dataset: reverse-engineering notes

The native drafts of `CreateFrameVisual`, `CopyFrame`, `CopyFrameSub`, and `mgCMDTBuilder::End(mgCFrame*, mgCVisualMDT*,
mgLoadData*)` remain behind `NONMATCHING` with retail assembly fallbacks.
Every other function, including `htoi` and `mgSetFrameAttr`, is native C++ and
byte-identical. `htoi` reads digits from the end as `((u8 *) (back + (s32) text))[-1]`:
retail adds the text address to the position (`addu v1,v1,a0`), while both
`(text + back)[-1]` and `(back + text)[-1]` put the pointer first.

## Data

- `mgSetFrameAttr` has a function-local `static char *name_def = ""`, and `mgLoadMDSFile` a
  function-local `static int flag = 0` that nothing reads; each emits its retail storage and
  one-byte initialization guard. The empty string is inline at `SearchVisualType` as well.
- The sphere-centre and scalar `SetData` overloads initialize their four-float vectors
  directly; normal data writes zero to the homogeneous component using `MG_MDT_DATA_NORMAL`.
- Two `INCLUDE_RODATA` markers remain: `at_550__DATA` is the `"mgLoadMDSFile"` diagnostic
  referenced by the assembly-backed `CreateFrameVisual`, and `__vt__15mgCShadowFixMDT__DATA`
  is the shadow-visual vtable that no native source in this unit emits.

## Typed access

- `mgCMDTBuilder::EndData` stores each closed section's offset and count in the named
  `MDT_HEADER` fields selected by `mgMDTDataType`; section offsets are `end - (char *) header`
  and the cursor rewinds with `end = data`. `EndFaces` keeps its `face_end`/`face_block_addr`/
  `cursor` integer views: the face size is a byte difference between differently typed pointers
  and the end is rounded up with `& 0xF`.
- MDS and MDT sections are located from serialized byte offsets (`object_ofs`, `mdt_ofs`,
  `vertex_ofs`, `object->size`); `(int) mds % 16` tests the file buffer's alignment.
- `mgLoadMDSFile` allocates `new (...) mgCFrame *[mds->object_num]` and
  `new (...) sceVu0FMATRIX[mds->object_num + 2]`. `mgCopyFrame` keeps
  `(mgCFrame **) operator new[](bytes, ...)`: `new (...) mgCFrame *[count]` keeps `bytes` in a
  temporary and shifts `count` again for the call.

A prior typed `static_cast<u8>(text[back - 1])` trial scored 96.01887%.
An unsigned-byte view of `&text[back]` differed in one commutative `addu`
operand order (99.81132%). A reversed-index byte-view experiment also retains
the first difference at 0x132586 and is not an accepted compliant source form.
No replacement from these experiments is promoted. Guarding `htoi` in an
earlier experiment also changed the following mgSetFrameAttr code generation
from 0x658 to 0x668; that experimental guard is not present in current source.

Header: `ps2/include/mg_dataset.hpp`. Retail unit `0x1321E0`-`0x134A20`.
First-game counterpart: `dataset`/`mds`/`mdt` (`LoadMDSFile`, `CopyFrame`, `SetFrameAttr`,
`MDT_HEADER`, `MDS_OBJECT`); this game's API is different (mgCMemory instead of CDataAlloc2,
mgLoadData, mgCreateVisualType, the MDT builder), so only the file-format layouts carried over,
and each was re-verified here.

## Functions
| Function | Linkage | Notes |
|---|---|---|
| `conv_new_text(char*, char*)` | static | writes converted object name to dst, returns length; only caller CreateFrameVisual |
| `htoi(char*)` | static | hex string -> int; called by mgSetFrameAttr |

| `mgSetFrameAttr(mgCFrame*, int)` | global | parses name text after `--` into the frame's mgCFrameAttr (`frame+0xF4`, or a stack mgCFrameAttr when none); recurses over children (`+0x58` first child, `+0x5C` next sibling) when arg 2 != 0. Uses local statics `name_def_276`/`init_277` (default name = `at_387`, the empty string) |
| `SearchVisualType(mgCreateVisualType*, char*)` | static | walks the table (stride 8) until `name == NULL` or `type == -1`; match via `mgFrameNameComp` |
| `CreateFrameVisual(...)` | static | returns int (0 failure / no model, 1 visual created). See below |
| `mgLoadMDSFile(MDS_HEADER*, mgCMemory*, mgCreateVisualType*, mgCTextureManager*)` | global | memset a 0x40 stack mgLoadData, fills mds/memory/visual_type/texture_manager, tail-returns the other overload. Returns `mgCFrame*` (callers store it, e.g. character `nowChr+0x70`) |
| `mgLoadMDSFile(mgLoadData*)` | global | returns first frame of a `new mgCFrame[n]` array (stride 0x110, ctor `0x136B20`); stores frame table at frame0`+0x68`, count at `+0x64`, matrix table at `+0x6C`; then `mgSetFrameAttr(frames, 1)`. Uses local statics `flag_571`/`init_572`. Prints `at_618` ("address error!! %d\n") if mds is not 16-aligned |
| `mgCreateBBoxSphere(max, min, sphere, verts, n)` | global | void; `mgVectorMaxMin` per vertex then centre=(max+min)/2, radius in sphere[3]. `at_717` is a 16-byte .bss temp |
| `CopyFrame(dst, src, mem, copy_visual, table)` | static | void; `mgCFrame::operator=`, visual `Copy` (vtable slot +0x18) then `SetVisual` (mgCFrame vtable +0x48); if copied visual's `Iam()==3` sets `visual+0x50 = table` |
| `CopyFrameSub(src, mem, copy_visual, table)` | static | returns new `mgCFrame*` (0x110, `Alloc(mem,0x13)`), recurses over children |
| `mgCopyFrame(frame, mem, copy_visual)` | global | returns `mgCFrame*` |
| mgCMDTBuilder members | global | see layout below |
| `mgCMDTBuilder::Begin(mgCMemory*)` | member | allocates and clears an MDT header, writes its magic and size, and places the output cursor after the header. |
| `mgCMDTBuilder::AddFace(int)` | member | appends a vertex index to the face cursor and increments the primitive's index count; advancing the typed `s32` array matches retail. |
| `mgCFrame::SetVisual` | inline, owner mg_frame | `frame+0xF8 = visual`; it is virtual (mgCFrame vtable +0x48) |
| `mgCVisualFixMDT::Initialize` | inline, owner mg_visual | just calls `mgCVisualMDT::Initialize` |
| `mgCVisualMDT::Iam/GetMaterialNum/GetpMaterial/Draw(float(*)[4],mgCDrawManager*)` | inline, owner mg_visual | Iam=1; `+0x40` material count; `+0x44` material table; Draw = `Draw(NULL, m, dm)` via slot +0x2C |

The typed-view `htoi` experiment above emits `base,index` rather than retail's
`index,base` in one commutative address addition. This is an unresolved source
compliance issue, not an accepted replacement.

`CopyFrameSub` allocates and constructs a frame, copies its contents, then recursively copies each child and attaches the copy to the new parent. The guarded draft's native placement new tests the allocation result before putting it in saved register `s0`; retail first saves it in `s0`, then tests and passes that saved register to the constructor. The four-instruction shift also moves the following loop and epilogue, producing 46 differing instructions out of 68. Splitting the memory allocation from placement new, combining the frame assignment with its null check, and spelling the child loop as `while` left this code generation unchanged. The retail gap remains active.

All mgCVisual virtuals and the inline mgCVisualMDT ones are emitted here as weak inline functions
because the vtables `__vt__9mgCVisual` and `__vt__15mgCShadowFixMDT` are emitted in this unit (both
classes have only inline virtuals; the inlined constructors in CreateFrameVisual pull them in).
Ordering in retail: Initialize stuff right after CreateFrameVisual; `Iam`/`Copy` of mgCVisual after
CopyFrame; the rest at the end of the unit.

## mgCVisual (size 0x20, asserted)
Size: mgCVisualMDT's own fields start at 0x20 (`mgCVisualMDT::Initialize`, `operator=`), vptr at
0x1C (every virtual call loads `lw 0x1C(this)`), so data members come before the first virtual.
| Off | Field | Evidence |
|---|---|---|
| 0x00 | unk_00 | zeroed by Initialize, copied by mgCVisualMDT::operator= |
| 0x04 | draw_env `mgCDrawEnv*` | mgCVisualMDT/mgCVisualPrim/mgCShadowMDT CreateRenderInfoPacket: NULL -> `info+0xF20` |
| 0x08 | texture_manager | `GetTextureManager`: NULL -> `&mgTexManager` |
| 0x0C | prmode | mgCVisualMDT::CreateRenderInfoPacket writes `0x58|...` then emits it with GS reg 0x1B (PRMODE); SetPModeRef reads it |
| 0x10 | vu1_base | emitted `|0x03000000` (VIF BASE); mgCVisualMDT::Initialize sets 0x3C, motion MDT sets `n*4+0x3C` |
| 0x14 | vu1_offset | emitted `|0x02000000` (VIF OFFSET); 0xB4 default |
| 0x18 | unk_18 | only copied by operator= |
| 0x1C | vptr | |

Vtable (`__vt__9mgCVisual`, 0x37B180, 2 header words then): Iam(+0x08), GetMaterialNum(+0x0C),
GetpMaterial(+0x10), GetMaterial(int)(+0x14), Copy(mgCMemory*)(+0x18), CreateBBox(+0x1C),
CreateRenderInfoPacket(+0x20), CreatePacket(mgCMemory*,mgCMemory*)(+0x24),
Draw(float(*)[4],mgCDrawManager*)(+0x28), Draw(u_int*,float(*)[4],mgCDrawManager*)(+0x2C),
Initialize(+0x30). Subclasses append further slots (mgCVisualMDT: +0x40 CreateExtRenderInfoPacket,
+0x44 DataAssignMDT; mgCVisualMotionMDT: +0x48 DataAssignMotionMDT, see `__vt__15mgCShadowFixMDT`).

Return types: Iam int (values in `mgVisualKind`: 0 visual, 1 MDT, 2 FixMDT, 3 MotionMDT, 7 Prim;
taken from every `Iam` in the game). GetpMaterial/GetMaterial return `mgMaterial*` (stride 0x30,
`mgCVisualMDT::GetMaterial`). CreateBBox returns int (mgCVisualMDT returns a bool-ish flag); args are
(max, min, matrix) per `mgVectorMinMaxN(max, min, ...)`. Draw(packet,...) returns int (used by
`mgCFrame::Draw`). **Ambiguous**: Draw(float(*)[4], mgCDrawManager*) is declared `void`; the body
leaves `$v0` from the inner call untouched, so `int` with `return Draw(NULL,...)` would also fit
(mgCSprite's versions are tail jumps). If mg_sprite/mg_visual declare it `int`, change here.
Constructor: inline `mgCVisual() { Initialize(); }` (vptr store then virtual call through slot +0x30,
seen in CreateFrameVisual). `GetTextureManager`/`SetDrawEnvGifTag` are defined in mg_visual
(declared non-inline). `SetDrawEnvGifTag` returns 4 (quadwords); `P1` mangles `u_long128*`.

## mgCMDTBuilder (size 0x90, asserted)
Size: stack object in `EditInit` (editloop) spans 0x210..0x180; `Begin` memsets 0x30..0x90.
| Off | Field | Evidence |
|---|---|---|
| 0x00 | memory | Begin arg; End() `Alloc(memory, (end-header)/16)` |
| 0x04 | header `MDT_HEADER*` | Begin: `new(Alloc(mem,6)) [0x40]`, memset, strcpy "MDT" (`at_886`), `+4 = 0x40` |
| 0x08 | end | header+0x40 after Begin; offsets are `end - header` (bytes) |
| 0x0C | data | BeginData: `data = end`; SetData writes 16 bytes and advances; SetMaterial advances 0x60; EndData: `end = data` |
| 0x10 | data_num | count of entries in the open section |
| 0x14 | faces `MDT_FACES*` | BeginFaces: `faces = end`, memset 0x10, `faces->header_size = 0x10` |
| 0x18 | prim `FACES_ID*` | BeginPrim |
| 0x1C | index_num | AddFace ++ |
| 0x20 | face_index_num | 3, -1 if type&0x10, +1 if type&0x100, -1 if type&0x200; EndPrim divides by it (trap 7 on 0) |
| 0x24 | index `int*` | face write cursor; EndFaces rounds it up to 16 and sets `end` |
| 0x28 | data_type | `mgMDTDataType`; 0 when no section open |
| 0x2C | unk_2c | never touched |
| 0x30 | material `MDT_MATERIAL_` | SetMaterial: `lq` colour into 0x30, strcpy texture to 0x64, then member-wise copy to `data` |

EndData mapping (section -> header count/offset): 1 -> 0x0C/0x10, 2 -> 0x14/0x18, 4 -> 0x1C/0x20,
3 -> 0x2C/0x30, 5 -> 0x34/0x38. `SetData(PF)` accepts types 1-4; `SetData(ffff)` zeroes w for type 2
(normals). Names UV(3)/COLOUR(4) follow the first game's MDT_HEADER (colour at 0x1C, uv at 0x2C) and
mgCVisualMDT::CopyMDTData (count 0x1C -> visual+0x28, 0x2C -> visual+0x2C); not otherwise proven.
`End(frame, visual, load)`: bbox/sphere from vertices, `visual->Initialize()`, `visual->DataAssignMDT
(header, load->memory, tex)` (slot +0x44), `frame+0xF0 = new(Alloc(mem,0xD)) [0xB0]` (bbox block),
`frame->SetVisual`, SetBBox/SetBSphere, `frame+0xF4 = new mgCFrameAttr` (0x90 bytes).
BeginPrim flags (0x10/0x100/0x200) meaning unresolved; EditInit uses 0x214.

## File formats (declared here; no owning class)
- `MDT_HEADER` (0x40): see header; magic "MDT", header_size 0x40, unk_08 (first game: total size;
  builder never writes it), faces_size 0x24 / faces_ofs 0x28 (EndFaces/BeginFaces), unk_3c.
- `MDT_MATERIAL_` (0x60, retail name from `CopyMaterial(mgMaterial*, MDT_MATERIAL_*, ...)`):
  0x00 diffuse (SetMaterial colour, copied with lq/sq -> 16-aligned vector), 0x10/0x20 float[4]
  (0x10 copied into mgMaterial+0x10 by CopyMaterial; first game calls them ambient/specular),
  0x30 float, 0x34 texture[32] (CopyMaterial looks it up via `GetTexture(name, -1)`), 0x54 int,
  0x58/0x5C floats. Member types from SetMaterial's member-wise copy (lwc1 vs lw, 2-byte char loop of 0x20).
- `MDT_FACES` (0x10): **name invented** (no retail symbol); +4 = 0x10, +8 prim count
  (mgCVisualMDT::DataAssignMDT reads `faces+8`, records from `faces+0x10`).
- `FACES_ID`: retail name (mg_visual/mg_shadow `CreateFace(FACES_ID*, ...)`): type, face_num,
  material (+8, grouped by in CreateFace), indices from +0xC. Variable length.
- `MDS_HEADER` (0x10): +8 object count, +0xC offset to first object (LoadCollisionFile assumes 0x10).
- `MDTOBJ_HEADER` (0x70): +4 record size (loader strides by it; collision assumes 0x70), +8 name[32],
  +0x28 MDT offset from MDS start (0 = no model), +0x2C parent index (<0 none), +0x30 matrix.
  Same as the first game's `MDS_OBJECT`.
- `mgCreateVisualType` (8): {type, name}. Default entry has name "" (`at_387`). With no default the
  type is 1 (FixMDT).
- `mgLoadData` (0x40, memset by every caller): mds, memory, work_memory (passed as second memory to
  motion visuals), visual_type, texture_manager (NULL -> `mgTexManager`), weight (`.wgt` pack file,
  character.cpp), matrix (+0x18, read only by `CreateChangeFrame` in character), unk_1c[9].

## CreateFrameVisual
`(frame, mem, work_mem, parent, obj, mdt, type, tex, weight, index, frame_table, matrix_table)`.
Name -> `conv_new_text` into 256-byte buffer -> `Alloc` + `MG_ADDRESS_CHECK(.., "mgLoadMDSFile")`
(`at_550`). Creates mgCFrameAttr (0x90) when the name has `--`, or the object has a model, or no
parent. Visual sizes: MDT/FixMDT/ShadowMDT/ShadowFixMDT 0x50 (`Alloc(mem,7)`), MotionMDT 0x110
(`Alloc(mem,0x13)`); constructors inlined (vptr store + `Initialize` per level). Type 0 widens the
bbox by half its extent each way and the sphere radius by 1.5. MotionMDT gets a 0x14-byte
`mgCVMotionData` {weight, index, frame_table, matrix_table, 0} and `DataAssignMotionMDT` (+0x48)
then `SetBaseBox`; others `DataAssignMDT` (+0x44).

## Unresolved / for other units
- `mgCShadowFixMDT` (0x50, derives mgCShadowMDT, no members of its own, vtable emitted here,
  Iam via mgCVisualMDT) is NOT declared here: mg_shadow.hpp -> mg_visual.hpp -> mg_dataset.hpp
  (for mgCVisual) would make the include circular. It belongs in `mg_shadow.hpp`.
- MDT_HEADER, MDT_MATERIAL_, FACES_ID, MDS_HEADER, MDTOBJ_HEADER, mgLoadData,
  mgCreateVisualType are defined here; other units (mg_visual, mg_shadow, mg_frame, collision,
  visualmotion, character...) should include `mg_dataset.hpp` rather than redefine them.
- mgCVisual unk_00/unk_18, MDT_HEADER unk_08/unk_3c, MDS_HEADER unk_00/04, MDTOBJ unk_00 unknown.
- `mgLoadData` 0x1C..0x3F never read in this unit.
## Compiler flag cleanup

The local `divbyzerocheck on`/`reset` pair is redundant with the PS2
compiler flag. Removing it leaves every section and symbol in this unit's
object diff unchanged.
The draft compiler must use the same global flag: without it, `EndPrim`
omits retail's divide-by-zero trap and appears to differ in 10 words even
though its normal game build matches.

The typed-view `htoi` experiment differs in one commutative `addu` at +0x44.
Among the current guarded drafts, `CopyFrame` and `mgCMDTBuilder::End(frame, visual,
load)` each differ only in the null branch following placement allocation:
retail tests `v0`, while the compiled drafts test the equal-valued `a0`.
`CreateFrameVisual` has this same branch-register difference at six placement
allocations, plus one four-instruction scheduling difference near +0x1E4.

## Typed frame copies

`mgCopyFrame` keeps its allocated copies as `mgCFrame*` and accesses each
frame by array index. The constructor array has a 0x110-byte element stride;
the typed version matches retail at 100% (0x274 bytes).

## Native MDS loader

`mgLoadMDSFile(mgLoadData*)` is native and matches retail with a separate
allocation count and iteration index. Its serialized-file offsets and current
placement-new parks are documented in [matching-20261008.md](matching-20261008.md).
