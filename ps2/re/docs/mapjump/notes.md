# mapjump: reverse-engineering notes

Town map switching (main map / sub map), interiors, and per-map event script loading.
No first-game counterpart (the first game has no `mapjump` unit or `MapJumpMapInfo`).

## MapJumpMapInfo (0x18)
Size: `__ct__14MapJumpMapInfoFv` is `memset(this, 0, 0x18)`; the BSS symbols `MainMapInfo__2`
and `SubMapInfo` are 0x18 in main.symbols.txt; `dng_event`'s own `MainMapInfo` is also 0x18.
Field meanings come from how they are copied into `SCN_LOADMAP_INFO2` (sceneload.hpp) and from
the values callers set (editloop `EditInit`, title `TitleBootInit`, dng_event `LoadDungeonMapFile`).

| Off | Field | Evidence |
|---|---|---|
| 0x00 | `map_no` | passed as the slot to `CScene::DeleteMap/LoadMap/SetActive/ResetActive`; stored to `CScene+0x2e5c` (active map slot). Main=0, Sub=1 in EditInit. |
| 0x04 | `tex_block` | copied to `SCN_LOADMAP_INFO2::tex_block` (+0x0). Main 0, Sub 0x18. |
| 0x08 | `stack_no` | copied to `SCN_LOADMAP_INFO2::stack_no` (+0x4). Main 1, Sub 3. |
| 0x0C | `efp_tex_block` | copied to +0xC. Main 0x40, Sub 0x41. |
| 0x10 | `sky_tex_block` | copied to +0x10 in `GetLoadMapInfo` only; `LoadSubMap` does not copy it (sub maps get no sky). 0xA9 in EditInit. |
| 0x14 | `load_buf` (`u8 *`) | copied to `SCN_LOADMAP_INFO2::load_buf` (+0x8); callers store `read_buffer` / `BuffReadData` / a DataBuffer pointer. |

No vtable, no base. Constructor is out of line (emitted in mapjump, called from title/editloop and
`__sinit_mapjump_cpp`).

## Globals (all LOCAL in retail -> `static` in mapjump.cpp, no externs in the header)
| Symbol | Size | Type / meaning |
|---|---|---|
| `NowMainMapNo` | 4 | `int`, map number of loaded main map, -1 none. Also written to save data +0x1a18 (+0x1a1c gets previous). |
| `NowSubMapNo` | 4 | `int`, map number of loaded sub map, -1 none. Save data +0x1a1a (s16), previous at +0x1a1e. |
| `NowInteriorMapNo` | 4 | `int`, map number of current interior, -1 none. |
| `OldInteriorMapNo` | 4 | `int`, previous `NowInteriorMapNo`. |
| `ScriptBuffer` | 4 | `mgCMemory *`, stack scripts load into (editloop passes its own `ScriptBuffer__2`, 0x30 bytes = an mgCMemory). |
| `InteriorFlag` | 4 | `int`, nonzero while inside an interior (`InInterior`). |
| `old_bgm_no` | 4 | `int` (signed compare `-1 < old_bgm_no`), BGM number saved by `SaveBeforeInterior` from `GetActiveBgmInfo()+8`. |
| `now_script_file` | 0x40 | `char[64]`, path of last loaded map script (`ReloadMapScript`). |
| `MainMapInfo__2` (retail name `MainMapInfo`, local) | 0x18 | `MapJumpMapInfo`; constructed in `__sinit_mapjump_cpp`. |
| `SubMapInfo` | 0x18 | `MapJumpMapInfo`; constructed in `__sinit_mapjump_cpp`. |
| `at_912__4` | 0x80 | function-local static `char[0x80]` in `LoadMapScript` (initial contents of a 0x80 stack buffer, copied 4x32 bytes; the script directory prefix). Compiler-generated name. |
| `old_mapname` | 0x40 | `char[64]`, sub map name saved before entering an interior (`CScene::GetMapName(SubMapInfo.map_no)`). |
| `OldPos` | 0x10 | `float[4]` (vector), player position saved before interior; vfunc +0x18 on character = GetPos. |
| `OldRot` | 0x10 | `float[4]`, player rotation; vfunc +0x24 = GetRot. `ExitInterior` uses `OldRot[1] + PI` (faces back out). |
| `OldCamPos` / `OldCamRef` | 0x10 each | `float[4]`, `mgCCamera::GetPos/GetRef` saved, `SetPos/SetRef` restored. |
| `PrevInterior` / `NowInterior` | 0x40 each | `char[64]`, map names of previous and current interior. |
| `OldBgmStatus` | 0x1C | `CScene::BGM_STATUS` from `GetActiveBgmStatus`; its four-byte piece tail is alignment. |

`.data` `at_997__4` (0x40 at 0x35B940) is the initialiser of a `char[0x40]` local in
`SetInteriorDoorPos`: the default door function point name (Ghidra shows a string starting
"exit" at 0x35B940), replaced by `PrevInterior` when that is set.
`at_912__4` is the zero template for `LoadMapScript`'s stack-local
`char script[0x80] = ""`. Four 32-byte copies initialize the buffer before
path concatenation; it is not persistent mutable state.

## Functions
All 23 functions are global (only `__sinit_mapjump_cpp` is local). Return types:
- `GotoInterior` is `void`: the early-exit path does not set `$v0` (Ghidra's `char *` return is
  the trailing `strcpy`). `LoadMapScript` likewise `void` (unused by callers).
- `MapJump`, `GetLoadMapInfo`, `LoadSubMap`, `InteriorMapJump` return 0/1 (`int`).
- `LoadSubMap` third arg goes to `CScene::LoadMap`'s 4th arg: 0 = load and build now,
  nonzero = only read files (`LoadMapData(...,1)`), the scene copies the info to `CScene+0x2ca8`
  and builds later (EditLoop passes 1).
- `ExitInterior(CScene *, int *out)`: `*out` = -1, or the map number of the restored sub map
  (`SearchMapNo(old_mapname)`).
- `MapJump` deletes characters 8..0x3F (`DeleteChara(i + 8)` for i<0x38), sets
  `info->load_sky` (+0x18c) = 1, and copies `CScene+0x2f6c` into map +0xc88.
- `GetLoadMapInfo`: `place_parts_max` (+0x190) defaults to 0x140; game progress
  (`GetGameProgressInfo(save+0x1a08)`) chapter 8..9 appends a suffix (`at_891__3`) to the efp
  and def-sky names; chapter 6..7 replaces one added-map path (`at_892__2` -> `at_893__2`).
- `LoadScript`: tries `<name minus 4 chars>` + `sprintf(at_950__4, LanguageCode)` first, then
  the plain name; allocates `ceil(size/16)` units from `ScriptBuffer` and calls
  `SetEventScript(data, NULL, ScriptBuffer)`; on failure `SetEventScript(NULL, NULL, NULL)`.
  `ScriptBuffer` fields +0x1c, +0x24 cleared directly (mgCMemory internals).
- `SetInteriorDoorPos` walks `CFuncPointMngr` at map +0xcb0, type 6, entries with flag 8 at
  +0x20 and name at +0x38 matching; position at +0x180, rotation Y at +0x194 (+PI).
  Character vfuncs used: +0x10 SetPos, +0x14 ?, +0x1c SetRot, +0x20 ?; camera
  `*(cam+0x60)` vfunc +8 with -1. Character/camera types belong to other units.

## Unresolved
- Contents and purpose of `at_912__4` (BSS, so filled at runtime or zero): Ghidra treats it as
  the start of the script path; confirm when decompiling `LoadMapScript`.
- Header `@size` values use the padded sizes from `index.md`, as `sceneload.hpp` does.
# Preload completion value

`PreLoadSync` calls `ReadBG`, then returns the value from `ReadBGSync`.
The door event tests this result for zero before fading back in. An `int`
return type matches the retail function and its caller; declaring it `void`
hides a value the caller uses.

## MWCC 3.0 floating argument calibration

`ExitInterior__FP6CScenePi` restores the player's rotation with
`SetRotation(0.0f, mgAngleLimit(pi + OldRot[1]), 0.0f)`. Retail materializes
zero early and preserves it across `mgAngleLimit`, using the saved floating
register and an 80-byte stack frame. The deterministic false policy instead
produced a 64-byte frame and a function 12 bytes shorter than retail.

The verified profile row selects `mapjump.cpp`, `ExitInterior__FP6CScenePi`,
`binary32`, IEEE bits `0x00000000`, and `evaluate_first: true`. It applies to
both matching zero arguments without occurrence indices or a source change.
The selected row preserves the retail function bytes and resolved relocations.
The map state objects now have native declared extents and source names;
`MainMapInfo` is file-local in this unit. See
[MWCC notes](../../../../docs/MWCC.md).
