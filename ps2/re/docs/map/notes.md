# map: reverse-engineering notes

`CMap::AddPartsGroup` and `CMap::CreateDrawRect` are native C++ with one
after-inline placement row each for their list-node constructions. No
`NONMATCHING` guards or assembly fallbacks remain in map. Complete-object
and PAL verification pass; see
[placement conversion](../satansfiddle/placement-new.md).

`CreateDrawRect` uses typed `mgVu0FBOX` bounds, direct `CMapParts::GetBoundBox`
and a native `CList<CMapParts *>` node. Its earlier 97.55% comparison differed
at the null branch: the draft copied the node to its saved register before
branching and added a nop, while retail copied it in the delay slot. That was
a pre-merge baseline, not the current score. `PlacePartsEnd`'s native box
assignment is exact.

Header: `ps2/include/map.hpp`. `ps2/src/map.cpp` includes it.

## Header status
- Depends on `funcpoint.hpp` (CFuncPointMngr by value), `occlusion.hpp` (COcclusion[8] by value),
  `mapinfo.hpp` (CMapInfo base; it in turn includes the missing `mapload.hpp`), `effectlist.hpp`
  (CEffectList by value), `mg_frame.hpp` (mgCObject base), `mg_drawenv.hpp` (mgVu0FBOX),
  `mg_tanime.hpp` (the `CList<T>` template). At the time of writing `funcpoint.hpp`,
  `occlusion.hpp`, `mapload.hpp` did not exist, so the header and the unit do not compile yet.
- Layout was checked by compiling a copy with stubs for those four types (CMapInfo 0x100,
  CEffectList 0x18, CFuncPointMngr 0x34 with its vptr last, COcclusion 0xC0 aligned 16): every
  field offset listed below and every `sizeof` assert passed.
- `InScreenFuncInfo` is declared by `mapparts.hpp` (which includes `map.hpp`); map.hpp only
  forward-declares it.

## CMap (size 0xD10)
Base `CMapInfo` (0x000-0x0FF; `CMapInfo::Initialize` memsets 0x100). CMap reads CMapInfo fields
directly (`GetLightingInfo` reads +0x9C/+0xA0, `GetNowTime` +0xC0/+0xC8/+0xCC, `LoadData` +0xE8)
and calls `CMapInfo::GetImgName` etc. on `this`, so it is a base, not a member.
Size 0xD10: `CScene::LoadMapFromMemory` news 0x10F0 for a `CEditMap`, runs `CMap::CMap`, then
stores CEditMap's vtable at 0xD00 and constructs CEditMap's first member (an mgCMemory) at 0xD10.
The vptr is at 0xD00 (end), i.e. data members are declared before the virtuals.

| Off | Field | Evidence |
|---|---|---|
| 0x100 | `CMdsListSet *mds_list_set` | `SearchMDS`, `LoadData`; CScene stores `scene+0x23D0` here |
| 0x104 | `CList<CMapParts> *parts_list` | `AddParts`, `GetParts` (node+0x10 = CMapParts, name at node+0x80 = parts+0x70) |
| 0x108 | `parts_group_max` | Initialize sets 32; loop bound of Search*/PreDraw |
| 0x10C | `CPartsGroup parts_group[32]` | ctor/Initialize loop, stride 0x10, ends 0x30C |
| 0x30C | `unk_30c` | only zeroed by Initialize |
| 0x310 | `CEffectList effect_list` | `CreateEffect`/`DrawEffect`/`EffectStep` pass `this+0x310`; ctor writes 0x310..0x324; `SaerchEffectIndex` reads its count (+0xC) and table (+0x10, stride 0x184) |
| 0x328 | `place_parts_max` | `SetPlacePartsBuff` |
| 0x32C | `CMapParts *place_parts` | `__construct_new_array(.., CMapParts::CMapParts, 0x310, n)` |
| 0x330 | `place_parts_num` | index after last used entry (`PlacePartsEnd`); bound of most loops |
| 0x334 | `bbox_valid` | `PlacePartsEnd`, `GetBBox` return, `PreDraw` |
| 0x340 | `mgVu0FBOX bbox` | `mgZeroVectorW(0x340/0x350)`, `mgBoxMaxMin` |
| 0x360 | `draw_parts_num` | PreDraw fills, DrawSub etc. iterate |
| 0x364 | `CMapParts **draw_parts` | allocated in SetPlacePartsBuff (n*4) |
| 0x368 | `draw_rect_max` | Initialize sets 16 |
| 0x370 | `MapDrawOffRect draw_rect[16]` | stride 0x30, ends 0x670 |
| 0x670 | `occlusion_num` | CreateOcclusion (max 8) |
| 0x680 | `COcclusion occlusion[8]` | stride 0xC0 memset in ctor/Initialize; `COcclusion::Setup(this+0x680+i*0xC0)`; `CMapParts::InsideScreen(COcclusion*, n)` |
| 0xC80 | `camera_info_num` | SetCameraInfoTable |
| 0xC84 | `CCameraInfo *camera_info` | stride 0xD0 (matches CCameraInfo size in mapinfo.hpp) |
| 0xC88 | `float now_time` | GetNowTime returns it when time is enabled; scene/dng_main/editloop copy `scene+0x2F6C` into it |
| 0xC8C | `obj_anime_num` | AssignFuncPoint (`CFuncPointMngr::GetNum(5)`) |
| 0xC90 | `CObjAnime *obj_anime` | `__construct_new_array(.., CObjAnime::CObjAnime, 0x30, n)` |
| 0xC94 | `tr_box_texture` | Initialize -1; CreateTrBox param 2; DrawTrBox `ReloadTexture` |
| 0xC98 | `tr_box_num` | CreateTrBox (`GetEventNum(0x200)` over map + parts) |
| 0xC9C | `CMapTreasureBox *tr_box` | stride 0x680 |
| 0xCA0 | `CMapTreasureBox *tr_box_model` | CreateTrBox param 1; vtable slot 0xEC of it copies into each box |
| 0xCA4 | `unk_ca4` | never seen |
| 0xCA8 | `piece_load_skip` | `SetPieceLoadSkip` |
| 0xCAC | `parts_event` | set to 1 by `mapFUNC_DATA` (mapload) for event-type points; GetEvent searches placed parts only when set |
| 0xCB0 | `CFuncPointMngr func_point` | vptr stored at 0xCE0 in ctor → CFuncPointMngr is 0x34 with vptr at +0x30; first word = flag bits (0x40 = has point lights, tested in DrawSub/DrawTrBox) |
| 0xCE4 | `float anime_time` | EffectStep `+= 1.0` |
| 0xCE8 | `anime_frame` | EffectStep `= (int)anime_time`; CreateFuncCheck copies it into CFuncPointCheck+4; passed to GetLightAnimeWeight |
| 0xCEC | `water_surface_num` | cfgWATER_SURFACE_NUM |
| 0xCF0 | `CWaterFrame **water_surface` | cfgWATER_SURFACE_NUM/END |
| 0xCF4 | `water_num` | cfgWATER_DRAW_NUM |
| 0xCF8 | `CMapWater *water` | cfgWATER_DRAW_NUM: `__construct_new_array(.., CMapWater::CMapWater, 0xA0, n)` |
| 0xCFC | `CFireRaster *fire_raster` | DrawFireRaster; CScene::DrawEffect sets `scene+0x24F0` / NULL |
| 0xD00 | vptr | |

### CMap vtable (`__vt__4CMap`, 0x54 bytes, 19 slots after the 8-byte header)
DrawSub(0x08), Draw, DrawDirect, PreDraw, DrawEffect, DrawFireEffect, DrawFireRaster, DrawWater,
GetPoly(0x28), GetColPoly, GetCameraPoly, GetEvent, InScreenFunc, DrawScreenFunc, GetSeSrcVolPan,
AnimeStep, Step, Iam, Initialize(0x50). No destructor. The ctor calls slot 0x50 (Initialize).
CEditMap (editmap*) overrides some of these.

- `Draw`/`DrawDirect` (0x161F20/0x161F40, end of unit) are tail calls `DrawSub(0)`/`DrawSub(1)`
  through the vtable; their address (after all non-inline code) says they are inline in-class
  definitions emitted with the vtable. Return type `int` assumed (DrawSub returns a count);
  marked `@unknownret`.
- `GetColPoly` = `GetPoly(1, ...)`, `GetCameraPoly` = `GetPoly(3, ...)` via vtable. The poly kind
  (1 collision, 3 camera) is CMapParts::GetPoly's; no enum declared here since mapparts owns it.
- CFuncPointMngr category numbers used by CMap: 1 (effect points, DrawEffect), 2/3 (UpdateFlag in
  PreDraw), 4 (Step in PreDraw), 5 (animation points), 6 (event points), 7 (screen points,
  CMapParts::InScreenFunc). Point flag 0x200 = treasure box point. Enum belongs in funcpoint.hpp.
- CMapParts flag word at parts+0x2B0 (its CFuncPointMngr's flags): 0x02 fire, 0x20 lights,
  0x40 point lights, 0x80 sound, 0x100 events.
- `GetFixCameraPos` returns 0/1/2 → `MapFixCamera` enum (declared here). Camera info: +0 point
  count, +0x10 points (vec4 stride 0x10), +0x90 col-frame count, +0x94 CColFrame* list, +0x94
  word also tested ==0 as "default camera" (see mapinfo notes).
- `CheckFuncEvent(point, pos, check_type, info, out_dist)`: point flag 0x2 requires check_type 1,
  flag 0x4 requires check_type 2, check_type 0 rejects either flag. Meaning of the check types
  unresolved (no enum declared).
- `SaerchEffectIndex` (0x10 bytes in index) reads CEffectList internals; probably an inline
  CEffectList accessor. Check effectlist.hpp when writing it.
- Static locals: `ft_1248` (CFuncPoint[8], 0x1C0 each, constructed on first use with `init_1249`)
  in SetFuncPLight; `attr_1300` (mgCFrameAttr, 0x90, guard `init_1301`) in DrawEffect. These stay
  as INCLUDE_BSS.

## CMapFlagData (0x10)
`u32 flag[4]`, 128 flags. Size from `CSaveData::GetMapFlag`: `this + 0x200 + no*0x10`, 256 maps.
SetFlag returns the previous state; numbers outside 0..127 return 0.

## CPartsGroup (0x10)
+0 `char *name` (NULL = free; set from mgCopyString in AddPartsGroup), +4 `off` (written by
`CScene::EyeViewDrawOnOff`), +8 `camera_off` (set 0/1 by FixCameraPartsOnOff, cleared each PreDraw
after hiding the group), +0xC `CList<PartsGroupData> *list`.

## PartsGroupData (4), CList<PartsGroupData> / CList<CMapParts*> (0x10)
CList template from mg_tanime.hpp: next +0, prev +4, data +8, vptr +0xC (`operator new(0x10)` in
AddPartsGroup/CreateDrawRect, vtable stored at +0xC). Their `Initialize` (0x15DB50, 0x15E3D0) are
the template's inline virtual, emitted here. PartsGroupData's only field is the CMapParts* (+8 of
the node).

## MapDrawOffRect (0x30) — name not retail
+0 mgVu0FBOX area, +0x20 used, +0x24 outside (CreateDrawRect param 4; cfgDRAW_OFF_RECT passes 0;
PreDraw hides when the point is inside the area if 0, outside if nonzero), +0x28
`CList<CMapParts*> *parts`, +0x2C padding.

## MapEventInfo (0x60)
From GetEvent's local copy and CheckFuncEvent: +0 check_type, +4 event_no (CFuncPoint+0x24),
+8/+0xC unknown (never written), +0x10 world matrix (from mgCFrame::GetLWMatrix of point+0x70),
+0x50 parts_no (-1 for the map's own points), +0x54 point_no (CFuncPoint+0x28; CreateTrBox
writes the treasure box index there). Size: next local in GetEvent starts 0x60 after it.

## CObject (0x70) — owned by map
Derives from mgCObject (0x50: vptr, pos 0x10, rot 0x20, scale 0x30, changed 0x40, moved 0x44).
Fields from `CObject::Initialize` (object), `Copy`, `FarClip`, `CheckDraw`, `GetAlpha`:
0x50 far_dist (-1), 0x54 fade, 0x58 fade_alpha (-1 = unset), 0x5C fade_speed (0.2, doubled
inside near_dist), 0x60 near_dist (-1), 0x64 show (1), 0x68 draw_off (0). Size 0x70 = CMapWater
fields start at 0x70; CMapParts (0x310) and CMapTreasureBox derive from it.
Vtable `__vt__7CObject` (object, 0x74): mgCObject's 14 slots with Draw/DrawDirect/Initialize
overridden, then PreDraw(0x40), GetCameraDist, FarClip, DrawStep, GetAlpha, Show, GetShow,
SetFarDist, GetFarDist, SetNearDist, GetNearDist, CheckDraw, Copy(0x70).
- Emitted in map (weak, after the code that uses them): GetShow (0x160520), Draw, DrawDirect,
  Show, Set/GetFarDist, Set/GetNearDist, Copy (0x161F60..0x162080). These are inline in-class
  definitions in `map.hpp`. Draw/DrawDirect return 0. With them inline, `Initialize` is the
  first non-inline virtual, so object.cpp emits `__vt__7CObject`.
- Non-inline, in object.cpp: GetMatrix, FarClip, GetCameraDist, CheckDraw, DrawStep, GetAlpha,
  PreDraw, Initialize. `CObject()` is emitted in mapload (inline ctor: mgCObject ctor, vtable,
  `Initialize()` via vtable).
- `__ct__7CObjectFRC7CObject` (event_func) and `__as__7CObjectFRC7CObject` (character) are the
  implicit copy constructor/assignment (memberwise; the copy ctor inlines mgCObject's). They are
  deliberately NOT declared: declaring them would suppress the compiler-generated versions.
- `Copy(dest, stack)` copies this INTO dest (pos/rot/scale, 0x40/0x44, 0x50..0x68).
- FarClip returns `bool` (`andi 0xFF` in its epilogue).
- First game: unrelated class of the same name (physics object); nothing carried over.

## CMapWater (0xA0)
Derives CObject. Stride 0xA0 in PlacePartsEnd/ClearPlaceParts/DrawWater/cfgWATER_DRAW_NUM.
+0x70 `CWaterFrame *frame` (0 = free slot; DrawWater calls mgCFrame virtuals on it, so CWaterFrame
derives mgCFrame), +0x80 `sceVu0IVECTOR follow` (x/y/z digits after "#follow" in cfgWATER_DRAW;
Initialize zeroes it with one `sq $0, 0x80`), +0x90 `char *parts_name`, +0x94 parts_max (16, set
by cfgWATER_DRAW_NUM), +0x98 parts_num, +0x9C `CMapParts **parts`.
Vtable `__vt__9CMapWater` (0x74) = CObject's with Initialize replaced; it is emitted in map since
Initialize (0x15D9A0) is the first non-inline virtual. Ctor (0x166020) is inline, emitted in
mapload.

## Other units' functions emitted in map (not declared here)
CMapParts::CMapParts (0x15DF40), CMapParts::Draw/DrawDirect (0x15F7E0/0x15F7F0, 0x10 each),
CFuncPoint::CFuncPoint (0x15F5D0), CObjAnime::CObjAnime (0x1616B0), CMapTreasureBox::CMapTreasureBox
(0x161970): inline functions of mapparts/funcpoint classes, emitted after their first use here.

## Globals
- `CMapName` (.sdata, 4): `char *` pointing to at_327 = "CMap"; returned by `Iam`. Global.
- `at_574` "test" (CreateEffect name), `at_1352` "fire_wrk", `at_1353` "lightling" (texture
  names in DrawFireEffect), `at_1927` "top" (frame name in CreateTrBox), `at_2008` "%x %s\n"
  (printf in LoadData): string literals.
- No file-local functions in this unit (local_symbols.tsv has none in 0x15D830-0x162080).
  `CheckFuncEvent` is global (also called by `CEditMap::GetEvent`), so it is prototyped.

## Trivial CObject draws
`CObject::Draw` and `CObject::DrawDirect` each return 0 without changing state.
Retail binds both weak (binding 13) in map's `.text`, as it does
`CMapParts::Draw`/`DrawDirect`, which tail call `DrawSub(0)`/`DrawSub(1)`. All four
are inline in their class bodies (`map.hpp`, `mapparts.hpp`); map.cpp emits weak
copies that match retail's bytes, and the classes' vtables are emitted by
object.cpp and mapparts.cpp, whose `Initialize` is each class's first non-inline
virtual. Out-of-line definitions in map.cpp would make map.o emit both tables.

## Typed array access and matching
- `PreDraw` indexes the `COcclusion` member array directly; `CreateTrBox` indexes
  `tr_box` by its box number. Both typed forms preserve retail instructions.
- `GetPoly` writes each collected triangle's `CCPoly::parts_no`, the map-part
  index used by later collision queries; typed field access matches retail.
- Empty map-part names can be tested with `parts->name[0]` instead of casting
  the first character pointer to `s8 *`; these typed reads preserve retail
  in the map selection and drawing loops. `PreDraw` keeps its exact branch
  sequence when the emptiness result is first held in a local `u8`.
- `GetEvent` initializes `MapEventInfo::matrix` directly; typed matrix access
  matches retail. Its stack buffer remains an aligned word array: declaring
  the local as `MapEventInfo` makes MWCC address its fields from `sp` instead
  of retaining the retail `s1` base pointer.
- `DrawWater` indexes its fixed water-surface array directly without changing
  the object. Typed indexing of the overlay water's placed-parts array changes
  only saved-register allocation in the second overlay loop; the indexed form
  remains until an exact source pattern is found.
- `GetCharaLight` can index its `CFuncPoint` array directly. The typed form
  preserves instruction shape but exchanges saved registers `s3` and `s4`
  throughout its light loop. A pointer-increment form and an array view indexed
  by a byte-offset quotient differ more substantially.
- `AddPartsGroup` constructs a `CList<PartsGroupData>` in the memory stack.
  Native placement construction supplies the list vtable, clears its data and
  calls `Initialize`. Before placement conversion, its draft moved the result
  before the null branch while retail moved it in the delay slot.

## Constructor-backed allocations and verification

`CMap::AddPartsGroup` and `CMap::CreateDrawRect` allocate `CList` nodes whose
constructors install the list vtable and initialize the links. Both natural
callers are active and accepted under their after-inline rows. The list vtables
reference `CList<PartsGroupData>::Initialize` and `CList<CMapParts *>::Initialize`.
Both methods have native explicit specializations: `PartsGroupData` at
0x15DB50 and `CMapParts *` at 0x15E3D0 (each size 0xC). Each clears
`prev` at offset 4, then `next` at offset 0, leaving the stored data unchanged. `decompile.sh` confirms those
two stores. The specializations use the documented `CList` fields and let
MWCC generate their template symbols naturally. The earlier complete `map`
object comparison matched 0x4734 bytes and 418 resolved relocations with the
allocation callers still guarded; that measured the initializers independently.
Current complete-object acceptance also includes both native allocation callers.

`CPartsGroup::Add` and `CMap::AddParts` reproduce PAL code in the pre-merge
canonical comparison. Each append walks to the last node, writes its next link
and sets the new node's prev link when non-null. `CMap::AddParts` rejects a null
new node.

The previous native `GetCharaLight` comparison exchanged the saved registers of
the light-loop array displacement and point address. `DrawWater` exchanged the
overlay-placement pointer and overlay-parts displacement registers. The literal
float arguments in `DrawWater` matched in that isolated build. Pointer
declaration and redundant initialization trials did not correct those
allocations and are absent from the source. These observations describe the
pre-merge snapshot; that merged source still required canonical revalidation.
The current object has since passed complete acceptance.

## Earlier guarded list-allocation comparisons

Explicit member specializations are the active list initializers. Earlier
whole-class instantiation experiments matched their two bodies but did not
establish the then-guarded allocation callers.

Before its conversion row, AddPartsGroup remained guarded: its original draft
was 0x104 bytes against 0x100 retail. It clears `data.parts` again after the natural data constructor
already clears it. Removing that redundant caller clear produces 0xFC bytes
but increases positional differences to 26/64 words through constructor
scheduling and inserted nops, so that isolated trial was not retained then.
The current natural caller removes the redundant clear and accepts a 0xFC body
with its after-inline row.
The earlier pointer-walk `CreateDrawRect` draft had 50/112 positional word differences;
its construction moves the allocation result before the null branch and
adds two nops, shifting the subsequent instructions. These counts supersede
the older pre-merge percentage above.

Both callers were blocked by placement-new allocation-result scheduling at
that earlier source/profile boundary. The current rows preserve the same list
construction and null-result flow and pass whole-object acceptance.

The mapmglib pass at `0c33a7e` replaced that draft's array pointer induction
with typed indexing. Its retained comparison was 112/116 words, with a 0x1D0
native body against 0x1C0 retail. The captured array base preserved the original
selection traversal. That pass was a guarded source-compliance cleanup, not a
closer match; the current accepted typed caller has a 0x1B8 body in the 0x1C0
extent. See [mapmglib-midday-20261008.md](mapmglib-midday-20261008.md) for that
constructor trial, source boundary and validation receipts.
