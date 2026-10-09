# object: reverse-engineering notes

The unit holds the out-of-line members of two classes:
- `CObject` (owned by `map`, declared in `map.hpp`): GetMatrix, FarClip, GetCameraDist, CheckDraw,
  DrawStep, GetAlpha, PreDraw, Initialize, plus `__vt__7CObject`.
- `CObjectFrame` (owned here, declared in `object.hpp`): 8 members, plus `__vt__12CObjectFrame`.

No global data besides the two vtables; no non-member functions.

## Hierarchy
`mgCFrame`/`mgCObject` (mg_frame) <- `CObject` (map) <- `CObjectFrame` (object) <- `CMapPiece`
(mdslist) and others (`CMapTreasureBox` ctor and many chara classes reference the CObjectFrame
vtable/ctor). Not the first game's `CObjectFrame` (that one derives from a physics `CObject`
with four `CFrameVu1*` LOD frames, size 0xD0); unrelated layout, only the name is shared.

## CObjectFrame layout (size 0x80)
| Offset | Field | Evidence |
|---|---|---|
| 0x00-0x6B | `CObject` base | ctor `__ct__12CObjectFrameFv` (mapload 0x163830) calls `__ct__7CObjectFv` first |
| 0x70 | `mgCFrame *frame` | `Initialize` stores 0; `GetFrame` (mapload) returns it; Draw/DrawDirect pass it to `mgDraw`/`mgDrawDirect(mgCFrame*)`; GetCameraDist calls `mgCFrame::GetWorldPosition0` on it |
| 0x74-0x7F | padding | never accessed; CObject/mgCObject hold `sceVu0FVECTOR`s so the class is 16-aligned |

Size 0x80: `CMapPiece::Initialize` (mdslist) writes its own fields from 0x80 onward right after
calling `CObjectFrame::Initialize`; no `operator new` of a bare CObjectFrame was found.
The 0x80 assert depends on `CObject` being 16-byte aligned (mgCObject's position/rotation/scale
vectors at 0x10/0x20/0x30). CObject's own last field is at 0x68 (copy ctor in event_func copies
0x50..0x68), so CObject's sizeof is 0x70 and `frame` lands at 0x70 without explicit padding.

CObject offsets used by CObjectFrame code (named by the map agent): 0x10 position, 0x20 rotation,
0x30 scale (UpDatePosition passes these to the frame's SetPosition(float*)/SetRotation(float*)/
SetScale(float*), mgCObject vtable slots 0x10/0x1C/0x28); 0x54 int flag that enables alpha fade
in PreDraw; 0x58 float reset to -1.0 by Copy; 0x64 show flag and 0x68 flag checked by
`CObject::PreDraw`.

## Vtable (`__vt__12CObjectFrame` @ 0x37B860, offsets from vtable start, 8-byte header)
0x08 ChangeParam, 0x0C UseParam, 0x10 SetPosition(float*), 0x14 SetPosition(fff),
0x18 GetPosition, 0x1C SetRotation(float*), 0x20 SetRotation(fff), 0x24 GetRotation,
0x28 SetScale(float*), 0x2C SetScale(fff), 0x30 GetScale (all mgCObject);
0x34 Draw*, 0x38 DrawDirect*, 0x3C Initialize*, 0x40 PreDraw*, 0x44 GetCameraDist*,
0x48 FarClip(float, float*), 0x4C DrawStep*, 0x50 GetAlpha, 0x54 Show(int), 0x58 GetShow,
0x5C SetFarDist(float), 0x60 GetFarDist, 0x64 SetNearDist(float), 0x68 GetNearDist,
0x6C CheckDraw, 0x70 Copy(CObject&, mgCMemory*) (CObject's);
new in CObjectFrame: 0x74 UpDatePosition, 0x78 Copy(CObjectFrame&, mgCMemory*).
(* = overridden by CObjectFrame.) `__vt__7CObject` is identical up to 0x70 with CObject's
Draw/DrawDirect/Initialize/PreDraw/GetCameraDist/DrawStep. This unit emits it because
CObject's Draw/DrawDirect are inline (`map.hpp`, weak in map), leaving `Initialize` as the
first non-inline virtual.

## Member notes
- Return types: Draw/DrawDirect return int 0 (`daddu v0,0,0`; same as `mgCObject::Draw`);
  PreDraw returns int (FarClip result, 0 when no frame); GetCameraDist returns float
  (`mgGetDistFromCamera` result in $f0); DrawStep, Initialize, UpDatePosition, Copy are void.
- `DrawStep__12CObjectFrame` is `j DrawStep__7CObjectFv`, i.e. body `CObject::DrawStep();`.
  CObject::DrawStep calls `FarClip(GetCameraDist(), &alpha)` virtually and drops the result.
- `Initialize__12CObjectFrame`: `frame = NULL;` then tail-call `CObject::Initialize()`.
- `PreDraw`: if frame: `UpDatePosition()` (virtual 0x74), `CObject::PreDraw()` (result
  unused), `r = FarClip(GetCameraDist(), &alpha)`; if r and field 0x54:
  `frame->SetAttrParamObjAlpha(alpha, 1)`; return r.
- `Copy(dest, memory)`: copies this into `dest`: mgCObject part (0x10..0x44), CObject part
  (0x50..0x68), then `dest.frame = frame` in both branches of `if (memory == NULL)` (the
  memory branch does not duplicate the frame), then 0x50, 0x54 again and `dest[0x58] = -1.0f`.
  The repeated 0x50/0x54/0x58 tail looks like an inlined `CObject::Copy`-style body; work out
  the exact source when matching.
- Ctor: `CObject()` then virtual `Initialize()` through the vtable (slot 0x3C).

## Unresolved
- `map.hpp` (CObject) did not exist when this header was written; the header includes it and
  the override return types above must agree with the CObject declarations there.
