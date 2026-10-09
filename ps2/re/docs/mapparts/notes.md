# mapparts: reverse-engineering notes

`CMapParts::Copy` and `CMapParts::AssignFuncAnime` are currently supplied by
retail assembly. Their list nodes and map pieces are constructed as C++ objects
in retail; the source no longer writes virtual-table addresses into raw storage.

Header: `ps2/include/mapparts.hpp`. Declares `CMapParts`, `CMapTreasureBox`, `InScreenFuncInfo`,
`MAP_PARTS_COLOR_MAX`. Unit owns no plain-named global data (only `at_244` = float4 {0,0,0,1}
literal and the three vtables).

## Header dependencies (by value)
- `CObject` (base of CMapParts) from `map.hpp` (owner per class_units; `object.hpp` already
  includes `map.hpp` for it). `map.hpp` must therefore NOT include `mapparts.hpp`; it only needs
  `class CMapParts;` (CMap holds `CMapParts *` arrays, stride 0x310).
- `CFuncPointMngr`, `CFuncPointCheck` from `funcpoint.hpp`; `CCharacter2` from `character.hpp`;
  `mgCFrame` from `mg_frame.hpp` (needs `mg_visual.hpp`).
- None of map.hpp / funcpoint.hpp / character.hpp / mg_visual.hpp existed when written, so the
  header does not compile yet. Layout was verified with stub types of the right sizes (CObject
  0x70, mgCFrame 0x110, CFuncPointMngr 0x34 with vptr at +0x30, CFuncPointCheck {float, s32},
  CCharacter2 0x660): all offsets and both size asserts pass.
- `InScreenFuncInfo` has no owner; also used by `CMap::InScreenFunc`, `CEditMap::InScreenFunc`,
  `CScene::InScreenFunc`, `DngMainDraw`. Declared here; other headers should include this one or
  forward-declare `struct InScreenFuncInfo;` rather than redefine it.

## CMapParts (size 0x310)
Size: `CList<CMapParts>` ctor puts its vptr at +0x320 with data at +0x10 (`__nw__(0x330)` in
mapload); `CMap` arrays step 0x310 (PreDraw, InScreenFunc, CreateTrBox). `CEditParts` (same
0x84 vtable size) derives from it; its fields start at 0x310.

Vtable `__vt__9CMapParts` (0x84): CObject's slots, overriding Draw (0x34), DrawDirect (0x38),
Initialize (0x3C), PreDraw (0x40), DrawStep (0x4C); new: Step (0x74), AnimeStep (0x78),
UpDatePosition (0x7C), Copy(CMapParts&, mgCMemory*) (0x80). Other slots used: 0x48 FarClip,
0x58 GetShow, 0x6C CheckDraw.

| Off | Field | Evidence |
|---|---|---|
| 0x00-0x6F | CObject | ctor chain mgCObject -> CObject; Copy copies 0x10..0x68 |
| 0x70 | char name[32] | SetName strcpy, len < 0x20; Copy 16x2 bytes; CMap checks name[0] |
| 0x90 | char parts_name[32] | SetPartsName |
| 0xB0 | CList<CMapPiece>* piece_list | AddPiece/Search*/Draw loops; node data at +0x10, next at +0 |
| 0xB4-0xBF | alignment | |
| 0xC0 | mgCFrame frame | ctor `__ct__8mgCFrameFv(this+0xC0)`; Copy uses `mgCFrame::operator=` |
| 0x1D0 | s32 lod_num | SetLODDist (mapload, called with 4 and {600,1000,1400,1800}) |
| 0x1D4 | s32 lod_blend | Set/GetLODBlend |
| 0x1D8 | float* lod_dist | SetLODDist |
| 0x1DC | unk_1dc | only zeroed (Initialize) and copied |
| 0x1E0 | float fixed_time | Initialize -1.0; CopyFuncPointCheck replaces check time when >= 0 |
| 0x1E4 | s32 need_step | set by AddPiece when piece flag (piece+0x84) & 4; gates Step |
| 0x1E8 | s32 color_num | Initialize 4; bound for Set/Get/GetDefColor, UpdateColor |
| 0x1F0 | sceVu0FVECTOR color[4] | SetColor (forces W=1), UpdateColor (only W > 0); Copy 0x40 bytes |
| 0x230 | s32 bound_valid | CreateBoundBox; GetBBox/GetBoundBox/GetBoundSphere/InsideScreen |
| 0x240 | mgVu0FBOX bound_box | max at +0, min at +0x10 (mgVu0FBOX order) |
| 0x260 | sceVu0FVECTOR bound_sphere | centre=(max+min)/2, W=dist/2 |
| 0x270 | s32 col_bound_valid | CheckColBox |
| 0x280 | mgVu0FBOX col_bound_box | pieces with flag (piece+0x84) & 1 |
| 0x2A0 | sceVu0FVECTOR col_bound_sphere | as above |
| 0x2B0 | CFuncPointMngr func_point_mngr | vptr at 0x2E0 (+0x30); Initialize/GetStart/Get/UpdateFlag/Step; flags word at +0 (& 0x20 = has lights) |
| 0x2E4 | s32 no_light | mapLIGHT_FLAG arg 0; DrawSub clears lights + point lights |
| 0x2E8 | s32 no_plight | mapLIGHT_FLAG arg 1; DrawSub mgPlightEnable(0) |
| 0x2EC | u32 move_flag | mapMOVE_FLAG sets bits 1/2/4/8 from four ints; CAutoMapGen::IndexToPartsPlace copies it. Bit meanings unknown (likely passable directions) |
| 0x2F0 | CList<CObjAnime>* anime_list | AssignFuncAnime / AnimeStep |
| 0x2F4 | s32 group_no | Initialize -1; mapMAP_PARTS_END stores CMap::AddPartsGroup result |
| 0x2F8 | s32 in_screen | Initialize 1; CMap::PreDraw stores InsideScreen() result, gates StepFuncPoint and is cleared by area boxes |
| 0x2FC | CFuncPointCheck func_check | {float time, s32 +4}; CopyFuncPointCheck; +4 passed to GetLightAnimeWeight |
| 0x304-0x30F | alignment | |

Inline functions emitted elsewhere: ctor (map 0x15DF40; the `*(this+0x2FC)=0` store is
CFuncPointCheck's ctor), Draw/DrawDirect (map, weak; tail calls to DrawSub(0)/DrawSub(1);
inline in `mapparts.hpp`, so `Initialize` is the first non-inline virtual and this unit
emits `__vt__9CMapParts`),
SetLODDist/SetLODBlend/GetLODBlend (mapload).

Return types: functions returning a value are declared `int` (flags/counts) except SearchPiece /
SearchPieceColType (`CMapPiece*` = node+0x10) and InScreenFunc (`CFuncPoint*`). GetColPoly /
GetCameraPoly are tail calls to GetPoly so return int.

Magic values seen (no enum declared here because they belong to other units):
- GetPoly kind: 1 = collision (GetColPoly), 3 = camera (GetCameraPoly) -> CMapPiece::GetPoly.
- CFuncPointMngr::GetStart kinds: 4 = lights (DrawSub, Step in StepFuncPoint), 5 = animations
  (AssignFuncAnime), 6 = treasure (CMap::CreateTrBox), 7 = screen targets (InScreenFunc,
  DrawScreenFunc). UpdateFlag kinds 1, 2, 3 in StepFuncPoint.
- CFuncPoint light type at +0x38: 0 directional, 1 ambient (set), 2 point, 3 ambient (add);
  +0x1B0 enabled; +0x20 colour; +0x30 point range; +0x48 skip.
- CMapPiece (node+0x10): +0x70 mgCFrame* (frame +0x54 non-zero = skip), +0x80 char* name,
  +0x84 flags (1 collision piece, 4 needs step), +0x68 flag bit 0 set when hidden by time
  (CheckTime with +0x94/+0x98), +0xA0 s16 col type, +0x8C material count. CMapPiece size 0xB0
  (CList<CMapPiece> node 0xD0, vptr at +0xC0).
- `CList<CObjAnime>` uses the native list template from `mg_tanime.hpp`. Its next/prev
  links occupy +0/+4; the aligned `CObjAnime` begins at +0x10; MWCC puts the
  implicit vptr at +0x40 and rounds the node size to 0x50. The virtual
  `Initialize` specialization at 0x1696A0 clears prev then next, and the
  compiler emits the retail `__vt__17CList_9CObjAnime_` table naturally.
  Construction uses `CObjAnime`'s default constructor, then calls virtual
  `Initialize`; `AssignFuncAnime` calls the virtual method again before
  linking the node. Both calls use retail's `t9` dispatch register. A private
  typed `AssignFuncAnime` draft compiles, but compares at 80.4375% and emits
  0x148 bytes against retail's 0x140. Differences include allocation-result
  null checks, list-head/tail control flow, and the loop-tail branch and delay
  slot. A private `do`/`while` form and a private 0x30 helper-mask seed did not
  change the output. The source retains its assembly gap; this private draft
  is not a matched implementation.
- COcclusion stride 0xC0 (InsideScreen).
- DAT_003971e0 in InsideScreen: global view matrix (owned elsewhere).

## CMapTreasureBox (size 0x680)
Base CCharacter2 (ctor chain mgCObject -> CObject -> CObjectFrame -> CCharacter2). Vtable is
CCharacter2's with only Initialize (0x3C) replaced. Size: `__construct_new_array(...,0x680,...)`
in CMap::CreateTrBox. CCharacter2 assumed 0x660 (first field here).

| Off | Field | Evidence |
|---|---|---|
| 0x660 | s32 active | AssignFuncPoint 1; CMap::DeleteTrBox 0; UpdateTrBoxFlag = !flag; GetTrBoxColPoly |
| 0x664 | s32 flag_no | func point +0xC; CMapFlagData::Get/SetFlag when > 0 |
| 0x668 | s32 item_no | func point +0x2C; CEditEvent::Step -> CSaveData::GetItem, GetItemMessageNo |
| 0x66C | s32 item_num | func point +0x30, 0 -> 1 |
| 0x670 | s32 floor_id | func point +0x34; editloop UpdateTrBoxFlag: GetFloorInfoPtr(id/100-1, id%100) |
| 0x674 | CFuncPoint* func_point | DeleteTrBox clears point+0x10 |
| 0x678 | CMapParts* parts | frame reference to parts->frame; GetTrBoxColPoly calls its GetShow |

Ctor in map (0x161970) is inline `{ Initialize(); }`; it also zeroes CCharacter2 0x35C..0x364
(CCharacter2's ctor).

## First game
The first game's `CMapParts` (chronicle `mapparts.hpp`, CMapObject-based edit part, 0x2A0) is an
unrelated class; nothing was carried over. No first-game equivalent of CMapTreasureBox.

## Not declared here
CCharacter2 inline members emitted in this unit (GetMotionStatus ... SetPosition) belong to
`character.hpp`; CMapPiece::Draw/DrawDirect (emitted here, 0x10 each) belong to `mdslist.hpp`;
`CList<CObjAnime>::Initialize` comes from the CList template in `mg_tanime.hpp`.
