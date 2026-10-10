# mapsky: reverse-engineering notes

Unit at 0x1846F0-0x185710. One class (`CMapSky`, no vtable, no constructor) and one script-filled
struct (`MAP_SKY_INFO`). No first-game counterpart (Dark Cloud has no `CMapSky`).

## Matching status

All functions are native; no assembly function fallback remains.

## CMapSky (0x108)
Size: `CScene::LoadMapFromMemory` (sceneload) does `__nw__FUiP1(0x108, mem)`, then calls
`Initialize` and `LoadPack` directly (no constructor exists), then `CScene::AssignSky(0, sky, NULL)`.
`Initialize` writes 0x00-0x108 exactly.

| Offset | Field | Evidence |
|---|---|---|
| 0x00 | `mgCFrame *sky[4]` | LoadPack: `mgLoadMDSFile` of `info.sky_mds_name[i]` (info+0x80); DrawSky draws it last |
| 0x10 | `float sky_rot[4]` | DrawSky: `sky_rot[i] = mgAngleLimit(sky_rot[i] + sky_rot_speed[i])`; passed as Y to vtable+0x20 SetRotation(x,y,z) |
| 0x20 | `float sky_rot_speed[4]` | LoadPack copies `info+0x100` |
| 0x30 | `mgCFrame *skyb[4]` | LoadPack: model of `info.skyb_mds_name[i]` (info+0x190); DrawSky draws it first |
| 0x40 | `float skyb_rot[4]` | as sky_rot |
| 0x50 | `float skyb_rot_speed[4]` | LoadPack copies `info+0x210` |
| 0x60 | `mgCFrame *sun[4]` | LoadPack: model of `info.sun_mds_name[i]` (info+0x110); DrawSky positions it at sun_pos or moon_pos |
| 0x70 | `int tex_block[4]` | Initialize sets -1; LoadPack sets `tex_block_base + i` when the IMG file exists, `EnterIMGFile`; DrawSky `ReloadTexture(tex_block[i])` before each band's models |
| 0x80 | `mgCFrame *bg` | LoadPack: model of `info.bg_mds_name` loaded with the `at_387__2` mgCreateVisualType; its `attr` (+0xF4) gets +0x08=-1, +0x1C=1, +0x30=0 |
| 0x84 | `mgCVisualMDT *bg_visual` | `bg->visual` (+0xF8); DrawSkyBack calls `GetColor(&n)` and, when n==2, copies color1 to colours[1] and color0 to colours[0] |
| 0x88 | `AnimeFrame anime[16]` (stride 8: frame, speed) | LoadPack fills from SKY_ANIME then SKYB_ANIME entries via `SearchFrame`; DrawSky: GetRotation (vt+0x24), `rot.y = mgAngleLimit(rot.y + speed)`, SetRotation(float*) (vt+0x1C) |

mgCFrame vtable offsets used: +0x10 SetPosition(float*), +0x14 SetPosition(x,y,z), +0x1C SetRotation(float*),
+0x20 SetRotation(x,y,z), +0x24 GetRotation, +0x2C SetScale(x,y,z). Models are drawn twice, the
second time with scale (1,-1,1) (mirrored below the horizon). `SetAttrParam(attr, 1, 0x40000)` in
DrawSky, `(attr, 1, 10)` in LoadPack (attribute ids not yet enumerated; owned by mg_frame).

## Time bands (index of the 4-entry arrays)
`CScene::DrawSky` passes `CMap::GetNowTimeBand()`; `GetTimeBand(float hour)` (mapload): 0 = 9-17h,
1 = 17-21h, 2 = 21-6h (night), 3 = 6-9h. DrawSky only range-checks `time_band` (0..3) and does not
use it otherwise. `lighting_ratio[i] > 0` selects which bands' sky/back sky are drawn,
`sun_lighting_ratio[i] > 0` which bands' sun models; `lighting_ratio[2] > 0` (night) places sun
models at `moon_pos` instead of `sun_pos`, and band 2 is not drawn mirrored. The enum belongs to
mapload (`GetTimeBand`), so it is not declared here; use it when mapload.hpp provides one.
`CheckSkyID(int)` returns `0 <= id < 4`.

DrawSkyBack(camera_pos, color1, color0): from CScene::DrawSky, color1/color0 are
`CMapLightingInfo` +0x10 / +0x20 vectors scaled by 1/128 with w=1.

## MAP_SKY_INFO (0x740)
Size: `memset(info, 0, 0x740)` in LoadPack; the script handlers write the offsets below through
`skyInfo`. Script file is `info.cfg` (at_457) inside the pack.

| Offset | Field | Tag (handler) |
|---|---|---|
| 0x000 | `char img_name[4][32]` | SKY_IMG id, name |
| 0x080 | `char sky_mds_name[4][32]` | SKY_MDS id, name, deg |
| 0x100 | `float sky_rot_speed[4]` | SKY_MDS deg * pi/180 |
| 0x110 | `char sun_mds_name[4][32]` | SUN_MDS id, name |
| 0x190 | `char skyb_mds_name[4][32]` | SKYB_MDS id, name, deg |
| 0x210 | `float skyb_rot_speed[4]` | SKYB_MDS |
| 0x220 | `char bg_mds_name[32]` | SKY_BG name |
| 0x240 | `int sky_anime_id[16]` | SKY_ANIME id, frame name, deg (index = skyAnmNum, max 16) |
| 0x280 | `char sky_anime_name[16][32]` | SKY_ANIME |
| 0x480 | `float sky_anime_speed[16]` | SKY_ANIME |
| 0x4C0 | `int skyb_anime_id[16]` | SKYB_ANIME (index = skybAnmNum) |
| 0x500 | `char skyb_anime_name[16][32]` | SKYB_ANIME |
| 0x700 | `float skyb_anime_speed[16]` | SKYB_ANIME |

LoadPack looks each anime name up in `sky[id]` (or `skyb[id]`) with `SearchFrame`; sky entries are
taken first, total capped at 16.

## Data and linkage
All non-member functions (`LoadSkyPack`, `CheckSkyID`, `_SKY_IMG`, `_SKY_MDS`, `_SUN_MDS`,
`_SKYB_MDS`, `_SKY_BG`, `_SKY_ANIME`, `_SKYB_ANIME`) and all named data (`skyInfo`
(`MAP_SKY_INFO *`), `skyAnmNum`, `skybAnmNum` (int)) are LOCAL in retail: `static` in
mapsky.cpp, not in the header. Handlers have signature `int (SPI_STACK *, int)` and return 1 on
success, 0 on an invalid id / full table; they read int, string (stack+8), float (stack+0x10).
- `tag` (0x40): file-scope static `SPI_TAG_PARAM tag[8]` used by LoadSkyPack, in tag order (retail
  LOCAL `tag` has no numbered suffix, so it is not a function static; the symbol list's `tag__2`
  only separates it from other units' `tag`)
  SKY_IMG, SKY_MDS, SKY_ANIME, SUN_MDS, SKYB_MDS, SKYB_ANIME, SKY_BG, {0,0}.
- `at_387__2` (0x10): function-local static `mgCreateVisualType` in LoadPack: {0, "" (at_386), -1, 0}.
- LoadSkyPack builds a `CScriptInterpreter` on the stack (0xED0 bytes), `SetTag`, `SetScript`, `Run`.

## Unresolved
- The bg frame's attr fields are `z_write`, `clip_enable`, and `fog` in the
  existing `mgCFrameAttr` header. The masks 10 and 0x40000 are the named
  `MG_FRAME_ATTR_ALPHA_REF | MG_FRAME_ATTR_Z_WRITE` and
  `MG_FRAME_ATTR_OBJ_ALPHA` bits. `mgCVisualMDT::GetColor` returns
  `sceVu0FVECTOR *` in the existing `mg_visual.hpp` header.
- Field names `AnimeFrame`, `color0/color1` are neutral, not retail.

## Matched initialization
`Initialize` clears the seven four-element model and rotation arrays in one loop, sets each
texture block to -1, then clears the sixteen animation entries in two groups of eight. The
eight-entry grouping reproduces MWCC's two iterations of 0x40-byte stores. The background
frame and visual pointers are cleared last. `CheckSkyID` accepts indices 0 through 3.


## Native data

No assembly data markers remain. MAP_SKY_INFO *skyInfo, skyAnmNum and skybAnmNum are
file-local; the eight-row tag table includes its null row. LoadPack's 16-byte
mgCreateVisualType initializer and one-byte empty string are identified together through
the real pointer relocation. Anonymous initializer graphs require consistent code-root
addresses, exact extents/fixed bytes, real R_MIPS_32 fields and zero alignment tails.
Cycles, conflicting destinations, duplicate owners, nonpointer fields and changed child
contents reject the graph; agreeing shared-child claims retain one section owner.
