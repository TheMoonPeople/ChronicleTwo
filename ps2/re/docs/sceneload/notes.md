# sceneload: reverse-engineering notes

`CScene::LoadChara` and `CScene::CopyChara` are accepted native C++ callers,
with one scoped `CCharacter2` placement row each. No `NONMATCHING` guards or
assembly fallbacks remain in this unit. See
[placement conversion](../satansfiddle/placement-new.md).
Their inline `"chara"` and `"cfg"` literals supply `at_958__2` and
`at_959__2`, so the unit has no assembly data markers.

Header: `ps2/include/sceneload.hpp`. Owns `SCN_LOADMAP_INFO2` (with nested `MapFiles`) and
`mgCObjectStack<T>`; also declares `SCN_LOADMAP_FILES_MAX` and `SCN_LOADMAP_STEP`.
Members emitted here but owned elsewhere: `CScene::*` (8, owner `scenesnd.hpp`) and
`CMap::CMap()` (map.hpp, already declared there). The CEditMap constructor is inlined into
`CScene::LoadMapFromMemory(int,int,SCN_LOADMAP_INFO2*)`.

`mgCObjectStack<CList<EMAP_MESSAGE>>::Initialize` is an active C++
specialization and matches retail. `CMap::CMap` is also active native C++ and
matches retail. The current
`map_info` member model in `map.hpp` supersedes the older base-class
interpretation and its nine-word constructor miss; that is not a remaining
placement-new target.

`CScene::LoadChara` and `CScene::CopyChara` allocate `CCharacter2` objects
through natural construction in each native caller. The earlier two-word
null-branch miss kept their baseline drafts guarded; that source/profile
measurement is preserved in [the midday construction note](placement-new-20261008.md).

## Non-member functions and data
- `LoadMapData(SCN_LOADMAP_INFO2&, int)` is LOCAL in retail (`local_symbols.tsv`): `static` in
  the `.cpp`, not in the header. Returns `load_buf` end address (int) or 0 on failure; second
  arg nonzero = background read (`StartReadBG`, `LoadFileBG`) else `LoadFile2`.
- Data is all compiler-generated: `at_820__6` (.data, 0x20: local `char[32]` initialiser "map/"),
  `at_885..890` = ".map" ".cfg" ".mpk" ".sky" ".ipk" ".efp", `at_958/959` (CopyChara),
  `at_1116..1118` (LoadMapFromMemory: string and two printf formats). No externs.

## SCN_LOADMAP_INFO2 (0x1A8, no first-game equivalent)
Size: `Initialize` = `memset(this, 0, 0x1A8)` (tail call). `operator=` is a field map:
5 words, a 16-byte byte-pair loop at 0x14 (=> `char[16]`, align 1), a 0x2D x 8-byte loop at
0x24..0x18C (the `files[2]` array as plain data), then 7 words 0x18C..0x1A4.
`operator=` looks compiler-generated (field-map shape per MWCC.md section 9); it is declared
explicitly in the header like `CMapLightingInfo::operator=`. If an explicit body cannot match,
try removing the declaration and letting MWCC generate it.
Instances: `CScene` +0x2CA8 (used by `LoadMap` with BG load and `LoadMapBGStep`;
`CScene+0x2CA0` = next BG load step + 1, `+0x2E44` gate flag, `+0x2E48` map slot); stack copies in
title, dng_event, editloop, mapjump; a global at 0x01DFDDD8 (mainloop sinit).

| off | field | evidence |
|---|---|---|
| 0x000 | `s32 tex_block` | LoadMapFromMemory step 2 seeds `LoadData`'s `int *tex_block`; step 6 copies to scene-map +0x28. From MapJumpMapInfo+4 (GetLoadMapInfo) |
| 0x004 | `s32 stack_no` | `LoadMap`: `ClearStack/AssignStack/GetStack(info->stack_no)`. dng_event/title/editloop set MapJumpMapInfo+8 = 1 |
| 0x008 | `u8 *load_buf` | LoadMapData: running load address for .map/.cfg/.mpk/.sky; step 0 fails if 0. From MapJumpMapInfo+0x14 (= `BuffReadData` etc.) |
| 0x00C | `s32 efp_tex_block` | step 3: `CMap::CreateEffect(efp_data, this, stack)` -> `LoadEFPFile(.., int block, ..)`. 0xF/0x40/100 set by callers |
| 0x010 | `s32 sky_tex_block` | step 3: `> 0` gate and `CMapSky::LoadPack(.., tex_block_base, ..)`; dng sets 0x4C, title 0x6B |
| 0x014 | `char name[16]` | step 0: `AssignMap(slot, map, name)`; GetLoadMapInfo/LoadSubMap strcpy the map basename |
| 0x024 | `MapFiles files[2]` | LoadMapData loops 2 entries with stride 0xB4; [1] is the added map (GetLoadMapInfo `GetAddMapPath`, dir "map/cmn/"+path) |
| 0x18C | `s32 load_sky` | LoadMapData loads .sky only if nonzero; MapJump and dng/title set 1 |
| 0x190 | `s32 place_parts_max` | step 4: `SetPlacePartsBuff(stack, n)` if > 0; GetLoadMapInfo/LoadSubMap default 0x140, dng/title 400 |
| 0x194 | `unk_194` | only copied by operator= |
| 0x198 | `s32 tex_block_num` | step 2: sum of blocks `LoadData` reports for both maps; step 6 copies to scene-map +0x2C |
| 0x19C | `s32 data_ready` | set 1 by LoadMap and LoadMapData; step 0 returns -1 if 0 |
| 0x1A0 | `s32 map_no` | LoadMap stores its slot argument |
| 0x1A4 | `mgCMemory *stack` | LoadMap stores `GetStack(stack_no)`; used by every step; step 6 copies to scene-map +0x30 |

### MapFiles (0xB4; name is ours, retail gives none)
+0x00 `enable` (loop breaks on 0; GetLoadMapInfo sets 1), +0x04 `dir[0x20]` (from
`DivPathName`), then `char[0x10]` names at +0x24 map, +0x34 cfg, +0x44 mpk, +0x54 ipk, +0x64 efp,
+0x74 sky, +0x84 def_sky (file `map/<def_sky>.sky` tried when `<dir><sky>.sky` fails, sync load
only; GetLoadMapInfo sets "def", with "b" appended for game progress 8..9). Sizes of name
arrays are the spacing between offsets. Then +0x94 `map_data` (`CMapInfo::LoadMapInfo(char*,
int, ..)`), +0x98 `map_size`, +0x9C `cfg_data` (`CMap::LoadCfgFile(char*, int, ..)`), +0xA0
`cfg_size`, +0xA4 `mpk_data` (`LoadData` pcp_pack), +0xA8 `ipk_data` (`LoadData` img_pack;
allocated from `stack` after Align64), +0xAC `efp_data` (also from `stack`), +0xB0 `sky_data`.
ipk/efp/sky are zeroed when their file is missing; a missing ipk also fails LoadMapData.

## SCN_LOADMAP_STEP
`LoadMapFromMemory(int slot, int step, info)` performs one step and returns the next step
number (0->1 ... 5->6, 6 returns 6), or -1. `LoadMapFromMemory(int, info)` loops until the result
stops changing. Enum names are ours.

## mgCObjectStack<T> (0x14)
Only instance `mgCObjectStack<CList<EMAP_MESSAGE>>` = `CEditMap::message` at +0xF6C; size 0x14
from the gap to `area_no` at +0xF80 (editmap notes). `Initialize` (inline in the template;
emitted only here because only the inlined CEditMap ctor uses it) only zeroes +0x8; nothing
else in any unit reads +0xF6C..+0xF7F, so fields stay `unk_`. +0x8 is plausibly the element
count, unconfirmed. No vtable symbol exists. `EMAP_MESSAGE` stays forward-declared: no code
reads it.
