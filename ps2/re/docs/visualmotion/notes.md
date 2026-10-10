# visualmotion: reverse-engineering notes

`mgCVisualMotionMDT::Copy` is native C++. Placement new runs the inline
constructor of each base, with no direct virtual-table stores. `*copy = *this`
is the implicit derived assignment: it calls the generated `mgCVisualMDT`
assignment (emitted by mg_visual) and `mgVu0FBOX::operator=`, and shares the
frame and weight data. The copy then gets a material array of its own; indexing
the source and destination material arrays with a separate index keeps retail's
offset induction. The placement construction uses an after-inline statement
conversion row in `scripts/build/satansfiddle.json`
(`placement-new-copy-derived-20261009.md`).

Header: `ps2/include/visualmotion.hpp`. Skinned MDT model (`mgCVisualMotionMDT`), its per-vertex
weight (`mgVertexWeight`) and its build parameters (`mgCVMotionData`). No first-game counterpart
(chronicle has no VisualMotion / VertexWeight).

## mgCVisualMotionMDT (size 0x110)
- Base `mgCVisualFixMDT` (vtable inherits `CreatePacket__15mgCVisualFixMDT` and
  `DataAssignMDT__15mgCVisualFixMDT`); constructor chain in `CreateFrameVisual` (mg_dataset) and
  `Copy` stores mgCVisual -> mgCVisualMDT -> mgCVisualFixMDT -> mgCVisualMotionMDT vtables, calling
  Initialize (slot 0x30) after each: the constructor is inline `{ Initialize(); }`.
- Size: `__nw__FUiP1(0x110, Alloc(memory, 0x13))` in `CreateFrameVisual` (type 4) and in `Copy`.
  0x108..0x10F is tail padding from the 16-byte alignment of the base.
- Fields (offset -> evidence):
  - 0x50 `mgCFrame **frame`: from `motion->frame` (DataAssignMotionMDT); `frame[bone[i]]->name`
    (+0x50 of mgCFrame) passed to SearchFrameID in ChangeWeight; `frame[0]` / `frame[bone]`
    `GetLWMatrix` in CreateBBox / CreateExtRenderInfoPacket.
  - 0x54 `int frame_id`: from `motion->frame_id`; indexes `base_matrix` (stride 0x40); zeroed by
    Initialize; ChangeWeight's third argument.
  - 0x58 `float (*base_matrix)[4][4]`: from `motion->base_matrix`; `base_matrix + id*0x40`
    multiplied with frame LW matrices. In CreateChangeFrame (character) it is filled from
    `mgLoadData + 0x18` by frame.
  - 0x5C: alignment padding (not declared; implied by the 16-aligned box).
  - 0x60 `mgVu0FBOX base_box`: SetBaseBox `sq` to 0x60/0x70; Copy calls `mgVu0FBOX::operator=` on
    it; CreateBBox reads both corners and builds the 8 box corners.
  - 0x80 `int bone[32]`: Initialize / CreateVertexWeight fill with -1 (8 per iteration, 4 loops);
    loops of 0x20 stop at the first negative. Value = frame number of the bone; slot index * 4 is the
    VU1 matrix offset stored in `mgVertexWeight::matrix`.
  - 0x100 `int weight_num`: = `vertex_num` (0x20) in CreateVertexWeight; zeroed on failure.
  - 0x104 `mgVertexWeight *weight`: `__construct_new_array(..., mgVertexWeight ctor, 0, 0x20, n)`;
    passed as 9th (stack) argument to `set_data_func[i]` in CreateFaceMotionPacket.
- Base-class fields used: 0x08 texture_manager (defaults to `&mgTexManager`), 0x10 vu1_base /
  0x14 vu1_offset (Initialize: 0x7C / 0x94; DataAssignMotionMDT: `bones*4 + 0x3C` /
  `0xB4 - bones*2`), 0x20 vertex_num, 0x30 vertex, 0x34 normal, 0x38 colour, 0x3C uv, 0x40
  material_num, 0x44 material (Copy allocates its own material table, 0x30 per entry), 0x48
  face_group (zeroed before faces are created).

### Vtable `__vt__18mgCVisualMotionMDT` (0x37C260, 0x50 bytes)
0x08 Iam (own, inline, returns 3 = MG_VISUAL_KIND_MOTION_MDT), 0x0C GetMaterialNum (MDT), 0x10
GetpMaterial (MDT), 0x14 GetMaterial (MDT), 0x18 Copy (own), 0x1C CreateBBox (own), 0x20
CreateRenderInfoPacket (own), 0x24 CreatePacket(mgCMemory*, mgCMemory*) (mgCVisual), 0x28/0x2C Draw
(MDT), 0x30 Initialize (own), 0x34 CreatePacket(mgCDrawManager*) (FixMDT), 0x38 CreateFacePacket
(MDT), 0x3C CreateFace (MDT), 0x40 CreateExtRenderInfoPacket (own), 0x44 DataAssignMDT (FixMDT),
**0x48 DataAssignMotionMDT (new)**, **0x4C CreateFaceMotionPacket (new)**.
Iam sits after Copy at the end of the unit: inline, emitted with the vtable.

## mgVertexWeight (size 0x20)
Constructor (0x28D620, non-inline) is `memset(this, 0, 0x20)`; array stride 0x20.
- 0x00 `int matrix[4]`: CreateVertexWeight stores `slot << 2` into the first free entry.
- 0x10 `float weight[4]`: free entry = weight 0.0; stores `percent / 100.0f`; normalised to sum 1;
  a vertex with total 0 gets `weight[0] = 1.0`. More than 4 influences: prints
  "Weight Num Over!!! %s vert=%d\n" (frame name, vertex) after normalising.
SetData0..7 copy the whole 0x20 per vertex after the position into the packet.

## mgCVMotionData (size 0x14)
No member functions in retail; declared here because DataAssignMotionMDT /
CreateFaceMotionPacket take it and no unit owns it. Built on the stack in `CreateFrameVisual`
(`memset(&d, 0, 0x14)` twice -- possibly an inline constructor plus an explicit clear; not
declared), then filled from that function's last four arguments.
- 0x00 `u_int *weight_data`, 0x04 `int frame_id`, 0x08 `mgCFrame **frame`, 0x0C
  `float (*base_matrix)[4][4]`, 0x10 `unk_10` (never read in this unit).
CreateFaceMotionPacket does not read its `motion` argument.

## Weight record format (u_int stream read by CreateVertexWeight)
Blocks of a 0x20-byte header followed by `count` 0x20-byte entries:
- header word 0: frame number of the model the block belongs to (compared to `frame_id`);
  word 1: frame number of the bone; word 4: entry count; word 5: non-zero when another block
  follows.
- entry word 0: vertex index; word 4 (float): weight in percent.
Blocks for other models are skipped by `count` entries. More than 32 distinct bones prints
"Bone Num Over!!!\n" and leaves `weight = NULL`, `weight_num = 0`. Kept as `u_int *` because the
retail signature is `PUi`; no record struct is declared.

## Data
- `set_data_func` (0x358500, LOCAL): table of the 8 file-local `SetData0..7` writers, indexed by
  `(type & 0x100 ? 1 : 0) + (type & 0x10 ? 2 : 0) + (type & 0x200 ? 4 : 0)` (colour, no texture,
  no normal; same scheme as mg_visual's `set_data_func`). Belongs in the .cpp as `static`.
- `SetData0..7__FiiPPiP1P1P1P1P1P14mgVertexWeight` are LOCAL: `static u_long128 *SetDataN(int
  vertex_num, int type, int **index, u_long128 *packet, u_long128 *vertex, u_long128 *normal,
  u_long128 *uv, u_long128 *colour, mgVertexWeight *weight)` (`P1` = u_long128*; the symbol
  file's demangling "P" is wrong). Same as mg_visual's SetData plus the weight after each position.
  Not declared in the header.
- `prog_vif_532` / `progf_vif_533` (0x358520/30): function-local statics of
  CreateFaceMotionPacket, VIF MSCAL 0x2 (first batch) / MSCNT (later batches) quadwords.
  `at_571__3` (0x358540): VIF FLUSHA quadword (0x13000000) appended after the batches.
- `at_357`, `at_358`: the two printf strings above.
- No global data with plain names: no `extern`s in the header.

## Other units
- CreateRenderInfoPacket sets `mgRENDER_INFO::motion` (+0x1010) to 1 around the call to
  `mgCVisualMDT::CreateRenderInfoPacket`, then back to 0.
- `CreateChangeFrame` (character) calls ChangeWeight on a frame's visual (mgCFrame +0xF8) after
  checking `Iam() == 3`.
- DataAssignMotionMDT resets `work_memory`'s `lock` (0x1C) and `stack_used` (0x24), allocates the
  weights from it, then uses its free space as a temporary `mgCMemory` for face indices;
  packets go to `memory`. Each face gets `packet_tag_word[0] = size | MG_DMA_REF` (DMA tag ID 3,
  REF: the GS data sits at the tag's address) and the packet address in `packet_tag_word[1]`. The face section is an `MDT_FACES` header followed by variable-size
  `FACES_ID` records; its `prim_num` field supplies the iteration count. Typed header and
  record access preserve a 100% PAL object match. Returns 1, or 0 when `work_memory` is NULL.

## Unresolved
- Field names are descriptive, not retail. `mgCVMotionData::unk_10` purpose unknown.
- `Initialize` clears the 32 typed bone entries with a single loop. MWCC unrolls this
  into eight stores per iteration; writing the unrolled loop explicitly changes its
  register allocation. `ChangeWeight` indexes the bone array directly and stops at
  its first negative entry before remapping names onto the new skeleton. Keeping a
  separate slot pointer changes the retained induction register. Both functions now
  have zero canonical byte and resolved-relocation differences.

## Canonical native verification

The focused MWCC wrapper build, section fixup and canonical checker pass the complete
`visualmotion` object: 0x1A00 checked bytes and 101 relocations. This establishes the
native `Initialize` and `ChangeWeight` corrections; `CreateFaceMotionPacket`
is also native in the linked object.
- CreateVertexWeight's return value is unused by its only caller; declared `void`.

## Motion-packet loop types

CreateFaceMotionPacket is native and exact. The decompiler's halfword temporaries do not
justify making every batch counter short: that change adds truncations and grows the
body to 0x5E8. Packed GIF-tag fields and the face's short vertex count have distinct
arithmetic roles.

## Native data

The unit has no assembly data markers. The callback table, 0x50-byte motion vtable,
aligned finish template, and local four-word `prog_vif`/`progf_vif` commands are native.
The command arrays encode MSCAL(2) and MSCNT. Their identity depends on source base
names, exact declared extents and bytes, and complete retail consumers; numeric compiler
suffixes do not prove identity.
