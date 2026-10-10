# mapload: header notes

## Matching status

All functions are native; no assembly function fallback remains.

## Method used for layouts
Compiler-generated copy plans were reproduced with MWCC (wibo + `tools/compilers/mw/3.0-011126`)
on scratch sources and compared with retail. A float scalar copies with `lwc1`, a `sceVu0FVECTOR`
member copies with 4x `lwc1`/`swc1`, a non-16-aligned array with an 8-byte `lw` pair loop, a
16-aligned array of structs or a 16-aligned struct with `lq`/`sq`.

## CMapLightingInfo (0x1D0)
Size: `__ct__16CMapLightingInfoFv` (mapinfo) = `memset(this, 0, 0x1D0)`; also memset 0x1D0 in
UpDateMapInfo, DrawSky, DngMainDraw, TitleMapDraw; OutputLightData strides 0x1D0.
Layout from `__as__` (0x162A50) plan, reproduced exactly by the declared field types; meanings from
the mapinfo tag handlers (MPL_* strings at mapinfo at_704..at_713) and from UpDateMapInfo/TitleMapDraw:
- 0x000 float projection: MPL_FOV -> `(mgScreenWidth/2)/tan(26deg)`; passed to mgSetRenderInfo arg 1.
- 0x004-0x00F alignment padding (not copied).
- 0x010 sceVu0FVECTOR bg_color (MPL_BGCOLOR, w=128) -> mgSetBackGround.
- 0x020 sceVu0FVECTOR bg_color2 (MPL_BGCOLOR2; copies bg_color if all zero).
- 0x030 sceVu0FMATRIX light_dir (MPL_LIGHT n: x at 0x30+4n, y 0x40+4n, z 0x50+4n) -> mgSetLight arg 1.
- 0x070 sceVu0FMATRIX light_color (row n at 0x70+0x10n) -> mgSetLight arg 2. Both copy as 8-byte lw loops x8.
- 0x0B0 int plight_enable (MPL_PLIGHT sets 1; tested before mgPlightEnable(1)).
- 0x0C0 mgPOINT_LIGHT point_light[4] (stride 0x30; MPL_PLIGHT: power +0x20, pos +0x00 (w=1), color +0x10 (w=0)).
- 0x180 sceVu0FVECTOR ambient (MPL_AMBIENT, w=128) -> mgSetAmbient.
- 0x190 int fog_enable (MPL_FOG_ENABLE) -> mgFogEnable.
- 0x1A0 mgFOG_PARAM fog: near 0x1A0, far 0x1A4, r/g/b 0x1A8-0x1AA, far_value 0x1B0, near_value 0x1B4
  (MPL_FOG defaults rgb 255, 0x1B0=0, 0x1B4=255) -> mgSetFogParam. Copied as 3x lq.
`operator=` is the implicit compiler-generated memberwise copy assignment. The two real assignments in
`CMap::GetLightInfo(CMapLightingInfo *)` cause MWCC to emit it naturally as an out-of-line weak symbol
when `#pragma inline_depth(0)` is scoped to that caller. The pragma resets immediately after the
caller; the remaining functions keep their existing inlining behavior.
First game: no equivalent class.

## CFuncPoint (0x1C0)
Size: CList<CFuncPoint> is 0x1E0 (`Add__14CFuncPointMngrFiP9mgCMemory` new 0x1E0; Reserve stride
0x1E0) with data at +0x10 and the CList vptr at +0x1D0, so CFuncPoint = 0x1C0. Frame at 0x70 is an
mgCFrame (ctor `__ct__10CFuncPointFv` calls `__ct__8mgCFrameFv(this+0x70)`; mgCFrame is 0x110).
No vtable of its own. Full plan from `Copy__14CFuncPointMngr...` (funcpoint, 0x2A1F..), reproduced
exactly by the header:
- 0x00 char *name (FUNC_NAME; CFuncPointMngr::Search strcasecmp's it).
- 0x04 int type (FUNC_POINT_TYPE; mapFUNC_DATA maps strings at_1128..1136: effect=1 fire=2
  flare=3 plight=4 anime=5 invent=7 event=6 sound=8 pos=9). EFFECT_NAME with an unknown effect
  name sets type 0. The manager loops types 1..9 (`< 10`).
- 0x08 int unk_8 (FUNC_FLAG arg 1), 0x0C int unk_c (FUNC_FLAG arg 0); meaning not seen.
- 0x10 int enable: FUNC_DATA arg 1; Check() returns 0 when 0; _FUNC_POINT_SHOW sets it.
- 0x14 float start, 0x18 float end: FUNC_FLAG args 2/3; Check() -> CheckTime(check->time, start, end).
- 0x1C padding (not copied).
- 0x20 anonymous union, 0x50 bytes, Initialize memsets 0x20..0x6F. The retail plan is: 8-byte lw loop
  x10 over 0x20..0x6F, then 0x20/0x24 lw, 0x28/0x2C lwc1, mgVu0FBOX::operator= at 0x30. Reproduced only
  with an `int data[0x14]` FIRST member and InventData (with its mgVu0FBOX) LAST; keep that order.
  Per-type members (offsets absolute):
  - effect: 0x20 name (EFFECT_NAME), 0x24 index (CMap::SaerchEffectIndex).
  - fire/flare: 0x20 color (default 128,90,38 else vector*128, w=128), 0x30 = (arg3 == 0),
    0x34, 0x38 (UpdateStatus: non-zero adds status bit 0x40). DrawFireEffect tests 0x30 == 0.
  - plight: 0x20 color (*0.5, w=0), 0x30 power, 0x34 range (= power*sqrt(max rgb)*0.25),
    0x38 (==2 -> status bit 0x40 / GetLight), 0x3C, 0x40, 0x44, 0x48 (GetLight tests 0x48, 0x3C),
    0x4C flicker type, 0x50 depth, 0x54 period (GetLightAnimeWeight: 1 random, 2 sine, 3 saw).
  - anime: 0x20/0x24/0x28 strings (0x24 piece -> CMapParts::SearchPiece, 0x28 frame -> SearchFrame),
    0x2C, 0x30 ints, 0x34/0x36 s16, 0x40 vec -> CObjAnime::SetParam, 0x50, 0x60 vecs.
  - event: 0x20 flags, 0x24 event no (CheckFuncEvent copies to MapEventInfo+4 when > 0), 0x28-0x34
    ints, 0x38 char[16] (strncpy 15 + NUL). cfgFUNC_EVENT_DATA instead writes 0x20 = 1/2/4
    (every/action/check/item/invent) and 0x24 = 0/1/2, 0x28 = arg 0.
  - invent: 0x20 int, 0x24 int, 0x28 float, 0x2C angle (degrees*pi/180), 0x30 mgVu0FBOX
    (0x40 from args 1-3, 0x30 from args 4-6, both w=1).
  - sound: 0x20 se no, 0x24/0x28 floats -> sndGetVolPan last two args, 0x2C float(int), 0x30 shape
    (1 -> line between 0x40 and 0x50 transformed by the frame), 0x40/0x50 vecs (w=1).
- 0x70 mgCFrame frame.
- 0x180 position, 0x190 rotation, 0x1A0 scale (sceVu0FVECTOR; Initialize: zero, zero, 1,1,1,0).
- 0x1B0 int active (UpdateFlag stores Check() result; draw/light/sound code tests it).
- 0x1B4-0x1BF tail padding (16-byte alignment).
Set* (inline-placed after mapFUNC_POS): lq/sq copy of the vector into the member, then a virtual
call on `frame` through its vtable with the original pointer: slot 0x10 SetPosition(float*),
0x1C SetRotation(float*), 0x28 SetScale(float*) (`__vt__8mgCFrame`). Declared without bodies.

Enums (header): FUNC_POINT_TYPE; FUNC_EVENT_FLAG from mapFUNC_EVENT_DATA kinds (door 0x10A,
ed_door 0x11A, lddr_b 0x20, lddr_t 0x40, close_door 0x8A, t_box 0x202, book 0x402; arg 7 |2,
arg 8 |4, arg 9 sets/clears 0x100; mapFUNC_POS offsets the point by (-2,?,-12) rotated when 0x8,
and picks default scales by 0x20/0x40/0x200), bits 1/2/4 from cfg strings and CheckFuncEvent
(check type 0 rejects 2/4, type 1 needs 2, type 2 needs 4). 0x100 meaning unknown (FUNC_EVENT_UNK_100).
FUNC_PLIGHT_FLICKER from GetLightAnimeWeight.

## PieceMaterial (0x20)
Size: Initialize = `memset(this, 0, 0x20)`; mapPIECE_MATERIAL_START `__construct_new_array(.., 0x20, n)`.
0x00 mgCFrame* (SearchFrame of arg 0), 0x04 int material index (arg 1), 0x08 mgMaterial*
(mgCFrame::GetMaterial(index)), 0x0C int (arg 6, unk), 0x10 sceVu0FVECTOR colour (args 2-5);
CMapPiece::DrawSub swaps the material's first quadword with it during the draw. Copy plan in
`Copy__9CMapPiece...` (lw x4, lwc1 x4) reproduced.

## CCameraDrawInfo (0x8)
Size: CCameraInfo ctor constructs 4 at 0xA8..0xC8 (stride 8); GetDrawInfo `this + i*8 + 0xA8`.
0x0 group_no (= CMap::SearchPartsGroupNo(name); -1 by Initialize; FixCameraPartsOnOff uses it),
0x4 int (FIX_CAMERA_OFF_GROUP third arg; 0 by Initialize; meaning unknown).

## Globals
All `.sbss` (mapMap .. cfgWater) and `map_tag`, `cfg_tag`, `mapPlacePartsName`, `mapMapPartsName`
are LOCAL in retail (local_symbols.tsv), so they are file statics for the .cpp, not in the header:
mapMap CMap*, mapNowMapParts CList<CMapParts>*, mapNowMapPiece CList<CMapPiece>*, mapStack mgCMemory*,
mapFarDist float (-1 = none), mapFarAlpha, mapShow int, mapLOD_ID, mapCameraInfoIdx, mapCameraRectIdx,
mapFuncPointIdx, mapNowFuncPoint CFuncPoint*, mapMatIdx, mapPtsFunc (non-zero: func points go to
the current map part's manager at +0x2B0 instead of CMap+0xCB0), mapAddMode (IsAddMode returns it),
ReserveFuncFlag (cfgFUNC_DATA reserves 0x40 points once), WaterIndex, cfgWater;
map_tag SPI_TAG_PARAM[0x58] (0x2C0), cfg_tag SPI_TAG_PARAM[0x11] (0x88).
Global (extern in header): mapMapPartsGroupName char[0x100] (PARTS_GROUP), mapPos/mapRot/mapScale
sceVu0FVECTOR (MAP_PARTS zeroes pos/rot, scale = 1,1,1,0; PARTS_POS/ROT/SCALE fill; MAP_PARTS_END
passes them to CMap::PlaceParts).
at_438__2 (.data, 0x10) = {0, -1900.0, 700.0, 1.0}: a function-local vector template.

## Functions
Non-member globals declared: GetTimeBand (hours: [6,9) morning 3, [9,17) day 0, [17,21) evening 1,
else night 2 -> enum MAP_TIME_BAND), mgAbs(float), algn16_size(unsigned) (= (n>>4) + ((n&15)!=0)).
mgAbs/algn16_size are global, emitted only here, after their first callers; possibly inline
helpers from a library header. Every map*/cfg* tag handler, mapDummy and IsAddMode are LOCAL -> static
in the .cpp.
CMap/CMapInfo/CMapParts/CMapPiece/CObject/mgCObject/CObjectFrame/CCameraInfo/CColFrame/CCollision/
CMapWater/mgCFrame members emitted here belong to other units' headers.

## Compiler flag
The local `divbyzerocheck on/reset` directives are redundant with the unit's
global flag: removing them produces an identical complete `mapload.cpp.o`.
The `fptosi` conversion used by this unit is the CodeWarrior runtime helper declared in
`mw_runtime.h`; using that header preserves the complete object.

## CMapLightingInfo implicit assignment

The explicit operator declaration, hand-written body, and its byte-copy helper structs were removed.
The real `*out_info = *info` assignments in `CMap::GetLightInfo(CMapLightingInfo *)` emit the retail
`__as__16CMapLightingInfoFRC16CMapLightingInfo` naturally when that caller is compiled with inline
depth zero. The scoped `#pragma inline_depth(0)`/`reset` pair leaves unrelated callers at their
existing settings; this is the only unit-local assignment use of `CMapLightingInfo`.

After section fixup, the canonical object passes with 0x475C bytes and 945 relocations. ObjDiff
reports 100% for the 0x11C operator, the 0x1A4 one-argument `GetLightInfo`, and the 0x4AC overload.

The retail ELF marks this assignment with processor-specific binding 13, as it
also does for the generated CameraCtrlParam, sceGsTex0, and mgCVisualMDT copy
assignments. The non-const-reference mgCDrawEnv assignment instead has ordinary
GLOBAL binding. This provides additional evidence that the map-light copy is a
compiler-generated member rather than an authored operator body.


## Native data and matching constraints

All data are native. `map_tag[88]` and `cfg_tag[17]` are mutable `SPI_TAG_PARAM` tables
with null terminators. The first 35 map rows are `{"d", mapDummy}`; the repeated
`FUNC_FIRE_DATA` and `FUNC_DATA` spellings dispatch distinct handlers and must remain
repeated. `cfg_tag`'s eight-byte tail is alignment. Public
`mapMapPartsGroupName[0x100]`, `mapPos`, `mapRot` and `mapScale` retain their header
types; parser state is file-local.

The compiler emits the 12-byte `CList<CMapPiece>` and `CList<CMapParts>` vtables at
0x37B608 and 0x37B618. Each contains two zero words and its Initialize pointer. The
first table receives four verified alignment bytes; the terminal tail belongs to the
linker. The sun initializer is `{0.0f, -1900.0f, 700.0f, 1.0f}`.

`mapFUNC_EFFECT_NAME` uses the `effect.name`/`effect.index` union members at 0x20/0x24.
`cfgOCCLUSION_PLANE` writes homogeneous W as 1.0f; `cfgWATER_DRAW` reads the name and
follower digits through character indexing.

The inherited quadword copies remain exact. Natural alternatives fail with these masked
instruction-word differences:

| Function | memcpy | Components | Loop |
| --- | ---: | ---: | ---: |
| GetLightInfo | 76 | 99 | 100 |
| mapFUNC_FIRE_DATA | 36 | 85 | 85 |
| mapFUNC_PLIGHT_DATA | 73 | 149 | 149 |
| CFuncPoint::SetScale | 19 | 12 | 12 |
| CFuncPoint::SetRotation | 19 | 12 | 12 |
| CFuncPoint::SetPosition | 19 | 12 | 12 |

The setters are 0x1C bytes plus four alignment bytes. Components grow them to 0x34,
memcpy to 0x4C, and sceVu0CopyVector to 0x48; the SDK SetScale variant differs by 18
words. An aligned-vector parameter keeps float-pointer mangling but does not change
these results.
