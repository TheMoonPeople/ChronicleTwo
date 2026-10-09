# editdebug notes

Town-building (georama) debug menu and lighting editor. Called from `editloop`: `EditInit` calls
`EditDebugInit`/`InitLightingEdit`; `EditLoop` (only when `DebugFlag != 0`) calls
`EditDebugMode`, `EditDebugLoop(MainScene, &EdDebugInfo)`, `EditDebugStart(0xD7, &MenuBuffer)`
(on pad 0x400) and `LightingEdit(MainScene)` every frame. No first-game counterpart (nothing named
EditDebug/LightingEdit/SubGameInfo in Dark Cloud 1).

The unit owns no classes (`class_units.tsv` has none). Header declares `EditDebugInfo` and enums.

## Source status

Every function is native C++ (no `NONMATCHING` guards, `INCLUDE_ASM` or data
markers); all data is typed native definitions. `LightingEdit`
(`LightingEdit__FP6CScene`, 0x1A9820, GLOBAL, symbol size 0x1524 inside the
0x1530 extent) is the only function with non-trivial matching dependencies;
see "LightingEdit" below.

## Functions
| Function | Binding | Return | Notes |
|---|---|---|---|
| `EditDebugInit()` | global | void | `EditDebugFlag=0; Select=0; EditDebugTexb=-1;` |
| `EditDebugMode()` | global | int | `return EditDebugFlag;` |
| `EditDebugStart(int, mgCMemory*)` | global | void | `buffer->stack_used(0x24)=0; buffer->lock(0x1C)=0; EditDebugFlag=1; EditDebugTexb=texb;` |
| `PrintCursor(char*, int)` | **local** -> static in .cpp | int | two `sprintf` branches for `"->"` and `"  "`; the returned length advances the menu text pointer |
| `EditDebugLoop(CScene*, EditDebugInfo*)` | global | int | 0 while open, 1 after `EditDebugEnd` (pad 0x440 or an action that closes) |
| `EditDebugEnd()` | global | void | same body as `EditDebugInit` |
| `InitLightingEdit()` / `EndLightingEdit()` | global | void | `LEditFlag = 0` |
| `IsLightingEditMode()` | global | int | `return LEditFlag` |
| `LightingEdit(CScene*)` | global | void | opens itself (`LEditFlag=1`) on a pad combination |
| `tagGyoFish(SPI_STACK*, int)` | **local** -> static (the native `SPI_TAG_PARAM` table in `LoadGyorace` references it) | int (1/0) | script tag handler for `host:gyorace.cfg`; fills `GetOmakeGyoracer2(fish_num)` (+0x10 name strcpy, +0x02 s16, +0x4A u8, +0x26 s16, +0x3E/+0x3C/+0x36/+0x38/+0x3A s16) from args 0,1,2,3,5..9, arg 4 -> `SetOmakeGyoracerTactics(fish_num, v)`; `fish_num++` |
| `LoadGyorace()` | **local** -> static | void | `LoadFile2("host:gyorace.cfg", buf[0x4000], &size, 0)`, `fish_num=0`, builds a local two-entry `SPI_TAG_PARAM tags[2]` (`{"…", tagGyoFish}` + terminator), runs a stack `CScriptInterpreter` |

## Data (all LOCAL in retail -> `static` in the .cpp; no externs in the header)
`.data`: `SelMax` int[3] (0xC) = {7,5,2}; `SelData` int*[3][8] (0x60) = value each entry edits
(page0: `&DebugInfo[0]`, `&EventNo`, `&DebugInfo[2]`, `&DebugInfo[1]`, `&sg_type`, `&DebugInfo[3]`,
`&DebugInfo[4]`; page1: NULL, `&save_no`, `&load_no`, `&condition`, `&map_flag_no`; page2: `&map_jump`);
`SelText` char*[3][8] entry labels; `SelHelp` char*[3][8] help lines (page0 entry1 "○:run ▲:reload" (Shift-JIS),
entry3 "1:sp up 2:col off", rest ""); `LightSel` int[4] current row per lighting page;
`LightListNum` int[4] = {11,8,9,3} rows per lighting page. `.sdata`: `EventNo` int = 100.
`.sbss`: `EditDebugFlag`, `EditDebugTexb` (texture bank, -1 none, 0xD7 from EditLoop), `Select`
(row), `SelTAG` (page, EDIT_DEBUG_PAGE), `sg_type`, `map_jump`, `save_no`, `load_no`, `condition`,
`map_flag_no`, `LEditFlag`, `LightType` (LIGHTING_EDIT_PAGE), `DirLightNo` (0..), `fish_num`; all int.
`LightingEdit` has a 0x10 `.bss` function-local static vector.

Values edited via `SelData` are clamped 0..99999; pad: 0x8000/0x2000 ±1, 4/8 ±10 (±10000 with
pads 1+2 held), 1/2 ±100; 0x100 next page; 0x4000/0x1000 next/prev row; 0x20 act; 0x10 alt-act.
After editing, `DebugInfo` words are clamped: [0],[2],[3] -> bool, [1] 0..2, [4] 0..1
(`DebugInfo` is a global int[5] at 0x3FAF30 owned elsewhere).

## Enums (values from SelText strings and EditDebugLoop's `SelTAG`/`Select` tests)
- `EDIT_DEBUG_PAGE`: 0 general ("Debug Camera","RunEvent","Georama Debug","CharaMove","SubGame",
  "ParamOff","InventDebug"), 1 edit data ("All Clear","Save File","Load File","Con","Map Flag"),
  2 map ("Map Jump","Load Gyorace"). `SelTAG` wraps after 2.
- Actions on 0x20: page0 row4 -> `sgInitSubGame(sg_type, info)` + `EditDebugEnd`; page0 row1 ->
  `CScene::RunEvent(EventNo, NULL)` (0x10 -> `ReloadMapScript`); page1 row0 `CEditMap::ClearAllParts`,
  row1 save `host0:geo_data/geo%d-%d.edt` (`WriteFile(..., info->edit_data, 0x5510)`), row2 load
  (`LoadFile2` into `info->edit_data`, then `EditDataLoad`), row3 toggle
  `CEditData::dbgSet/GetContintionFlag(edit_data_no, condition)` (0x10 toggles all 0x40), row4
  toggle `CMapFlagData::SetFlag(map_flag_no)`; page2 row0 `info->jump_map_no = map_jump` and close,
  row1 `LoadGyorace()`. Item enums: `EDIT_DEBUG_GENERAL_ITEM`, `EDIT_DEBUG_EDIT_DATA_ITEM`,
  `EDIT_DEBUG_MAP_ITEM` (names derived from the label strings).
- `LIGHTING_EDIT_PAGE` from the page labels: 0 "BG & AMB", 1 "Dir Light" (prints `DirLightNo`),
  2 "Fog" (NEAR/FAR/R/G/B/MIN/MAX), 3 "File" (save to `%sy:/dc2/build/light_info/%s.lgt`, prefix "host:").
  The page labels carry retail's trailing arrows; omitting them changes the data binding.
- `LIGHTING_EDIT_ROW`: row 0 prints `"%sLightSet [%d]"` (left/right change `light_no` and move
  the scene time to that set); row 1 is the page selector (and the light on the directional page;
  a page change lands on row 1); each page's own entries start at row 2 (`edit = row - 2` on all
  four pages), so `LightListNum = {11, 8, 9, 3}` is 2 + {9, 6, 7, 1}.
- `LIGHTING_EDIT_DIR_ITEM`: rows 0-2 select the colour component (`COL R/G/B`), 3-5 rotate about
  axis `edit - 3` (`ROTATE X/Y/Z`).
- `LIGHTING_EDIT_FOG_ITEM`: cases 0..6 edit `near_dist`, `far_dist`, `color[0..2]`, `far_value`
  and `near_value`.

## EditDebugInfo (size 0x3C)
Size from the `EdDebugInfo` global (editloop, 0x1ECDA20, size 0x3C).
- 0x00..0x2F: a `SubGameInfo`. Evidence: `EditDebugLoop` passes the pointer unchanged to
  `sgInitSubGame(int, SubGameInfo*)`, which reads 0x00 and 0x0C..0x2C; `__sinit_editloop_cpp` zeroes
  exactly +0x00,+0x10,+0x14,+0x18,+0x1C,+0x28,+0x2C of `EdDebugInfo`, the same set
  `__sinit_subgame_cpp` zeroes on `GameInfo` -> an inline `SubGameInfo` constructor. +0x00 is a
  `CScene*` (EditInit stores MainScene; fishing derefs it as CScene). EditInit also sets +0x04=0xB9,
  +0x08=0x15, +0x0C=0x9A, +0x20/+0x24 = same register value.
  Declared as a base class (`struct EditDebugInfo : public SubGameInfo`); a first member would
  compile identically. `SubGameInfo` belongs to `subgame`; `subgame.hpp` declares its 0x30-byte
  layout, and the size assertion for `EditDebugInfo` passes in the PS2 build.
- 0x30 `CEditData* edit_data`: set by `EditMapJump` = `CSaveData::GetEditData(n)`; NULL check and
  `dbgGetContintionFlag` this; save/load buffer (0x5510 bytes).
- 0x34 `int edit_data_no`: the `n` above (0..3 by town map), passed to `dbg*ContintionFlag`.
- 0x38 `int jump_map_no`: set from `map_jump`; EditInit sets -1; EditLoop calls
  `EditMapJump(jump_map_no)` when >= 0 and resets to -1.

## LightingEdit: source forms the match depends on

- The fog colour channels are edited as `fog->color[edit - LIGHTING_EDIT_FOG_R]`
  (load, clamp 0..255, store). `mgFOG_PARAM` (0x30; near/far distances at 0/4,
  colour bytes at 8..11) exposes `u_char color[4]` in a union with `r/g/b/a`,
  the same form as its `values[4]` coefficients. MWCC folds the array offset
  and the subscript adjustment into retail's base-plus-6 displacement; a
  reference to the whole array or a named channel index emits a separate
  subtraction (873/1356 words, body 0x1528), and selecting the three typed
  field addresses with a conditional expression oversizes the body (0x1548).
  Dark Cloud 1's `EDIT_FOG_INFO` has the same near/far/RGB layout (unknown
  byte at 11) and its light-parameter interpolation calls `MGSetFogParm`;
  neither game stores an editor colour array starting at byte 6.
- `float *colors[3] __attribute__((aligned(16)))` on the background page's
  pointer array fixes its stack slot; without it the local retail addresses at
  `0x6430($sp)` moves and the function no longer matches.
- Four named projected endpoint arrays and a two-dimension coordinate
  adjustment loop reproduce retail's endpoint lifetimes; a single indexed
  matrix differs by 53 words.
- The absolute value of the projected Y axis is a conditional expression; an
  in-place `if` changes the branch delay slot at +0x122C/+0x1230. The
  projection declaration comes from `mglib.hpp`.
- `GetLightingInfo` and `OutputLightData` are reached through
  `map->map_info` (CMap's first member).
- m2c cannot resolve the function's jump table; the switch cases come from
  the retail disassembly.

## LoadGyorace

`interpreter.SetScript((char *) &script, size)` casts the address of the
`char script[0x4000]` array. Passing `script` makes MWCC set up the arguments
in order (`a0` then `a1`); retail sets up the cast argument first
(`addiu a1,sp,16` before `addiu a0,sp,16416`).
