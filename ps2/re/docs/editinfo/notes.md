# editinfo: reverse-engineering notes

The unit holds `CEditInfoMngr` (8 methods), the `emap*` command routines of the edit information
script (all file-local), their `emap_tag` table and state, and `CEditMap::GetEvent` (declared in
`editmap.hpp`).

## CEditInfoMngr (0x18 bytes)
Size: `CEditMap::info_mngr` is a by-value member at CEditMap+0xF94 and `editmap.hpp` places the next
member at +0xFAC; `Initialize` zeroes exactly six words.

| Off | Field | Evidence |
|---|---|---|
| 0x00 | `s32 parts_info_num` | `SetePartsInfoTable` arg 2; loop bound in all `GetePartsInfo*` |
| 0x04 | `CEditPartsInfo *parts_info` | `SetePartsInfoTable` arg 1; stride 0x280 = sizeof(CEditPartsInfo) |
| 0x08 | `s32 fix_parts_num` | `SeteFixPartsTable` arg 2; `CEditMap::ClearAllParts` loop bound (+0xF9C) |
| 0x0C | `ePlaceData *fix_parts` | `SeteFixPartsTable` arg 1; ClearAllParts reads +0xFA0, stride 0x20 |
| 0x10 | `s32 init_parts_num` | written directly by `emapINIT_EPARTS_START` (editmap); `InitialPlaceParts` loop bound (+0xFA4), only when `CEditData` word 0 == 0 |
| 0x14 | `ePlaceData *init_parts` | `emapINIT_EPARTS_START`; `InitialPlaceParts` reads +0xFA8 |

No vtable, no constructor/destructor. Not present in the first game.

Methods:
- `GetePartsInfo(int)`: `no < 0 || no >= parts_info_num` -> NULL, else `&parts_info[no]`.
- `GetePartsInfo(char*)`: linear search, skips entries whose `edit_name` (+0x3C) is NULL, `strcmp == 0`.
  No NULL check of `parts_info`.
- `GetePartsInfoAtID(int)`: `id < 0` -> NULL; NULL `parts_info` -> NULL; compares `parts_info[i].id` (+0x00).
- `GetePartsInfoAtType(int)`: compares `parts_info[i].GetPartsType()` to the argument.
- `LoadEditInfo`: sets the statics (see below), builds a `CScriptInterpreter` on the stack (sp+0x30,
  frame 0xF00, no destructor call), `SetTag(emap_tag)`, `SetScript(script, size)`, `Run()`. Returns void.

## ePlaceData (0x20 bytes)
Not declared by any other unit; used only in `SeteFixPartsTable`'s signature and editmap's
`emapFIX_EPARTS*/emapINIT_EPARTS*`. Size from `__nwa__(n << 5)` and the 0x20 stride.
- +0x00 `id`: first int argument of FIX_EPARTS/INIT_EPARTS; passed to `GetePartsInfoAtID`.
- +0x04 `angle`: third script argument (`spiGetStackInt(stack + 4 args)`); passed to `CEditMap::GetEditAngle`.
- +0x08, +0x0C: never touched.
- +0x10 `position[3]`: `spiGetStackVector` (3 floats) from args 1..3; passed as `float*` to
  `CheckEditParts`/`PlaceEditParts`.
- +0x1C: never touched (possibly the w of a 16-byte vector; declared `unk_1c`, no alignment forced).

## File-local data (static, belong in the .cpp; all LOCAL in retail)
All eleven script-state objects are typed file-local definitions of four bytes each; the unit has
no `NONMATCHING` guards, `INCLUDE_ASM` gaps, or data markers. gp offsets as in the asm (`$28`):
| Symbol | gp off | Type | Use |
|---|---|---|---|
| `emapInfo` | -0x65EC | `CEditInfoMngr *` | manager being filled |
| `emapStack` | -0x65E8 | `mgCMemory *` | heap for tables and strings |
| `emapIdx` | -0x65E4 | `int` | next definition number for EDIT_PARTS (post-incremented) |
| `emapMatID` | -0x65E0 | `int` | next material slot (reset by EDIT_PARTS, NOT by LoadEditInfo) |
| `emapNowInfo` | -0x65DC | `CEditPartsInfo *` | definition being filled; NULL after EDIT_PARTS_END |
| `emapRectType` | -0x65D8 | `int` | written into rect +0x00 by RECT; never set in this unit |
| `emapRect` | -0x65D4 | pointer to 0x30-byte rect records | only ever set to 0 (LoadEditInfo, *_RECT_END), so RECT always fails |
| `emapRectNum` | -0x65D0 | `int` | set by PLACE/PARTS/PUT_RECT |
| `emapRectIdx` | -0x65CC | `int` | reset by *_RECT, incremented by RECT |
| `emapFixNum` | -0x65C8 | `int` | only zeroed by LoadEditInfo |
| `emapFixIdx` | -0x65C4 | `int` | only zeroed by LoadEditInfo |

Rect record (0x30): +0x00 int type, +0x10 vec3 + 1.0f at +0x1C, +0x20 vec3 + 1.0f at +0x2C.
Only reachable through `emapRect`, which is never non-NULL; leave it as a local struct in the .cpp
if one is needed.

`emap_tag` (.data, 0xF0): 30 `SPI_TAG_PARAM` (29 commands + NULL terminator), in order:
EDIT_PARTS_NUM, EDIT_PARTS, ID, PARTS_NAME, PARTS_ATR, PARTS_MATERIAL, PARTS_COMMENT, GROUND_PARTS,
BLOCK_PARTS, RIVER_PARTS, FENCE_PARTS, CPOINT, WEIGHT, GEO_STONE, MAX_NUM, PAINT_NUM, PAINT_USED,
PARTS_TYPE, PLACE_EPS, MAP_NO, POLYN, RECT, PLACE_RECT, PLACE_RECT_END, PARTS_RECT, PARTS_RECT_END,
PUT_RECT, PUT_RECT_END, EDIT_PARTS_END (tag names are inline string literals; the handlers have
file-local linkage). The four part attribute masks use the `EditPartsAtr` enumerators.

## emap* commands -> CEditPartsInfo fields (see editparts.hpp)
- EDIT_PARTS_NUM: `new (Alloc(stack, ceil(n*0x280/16)+2)) CEditPartsInfo[n]`, then `SetePartsInfoTable`.
- EDIT_PARTS: `GetePartsInfo(emapIdx++)`, string through `ConvertFontCode` into a 256-byte buffer,
  copied to the heap -> `edit_name` (+0x3C); `emapMatID = 0`.
- ID +0x00; PARTS_ATR ORs +0x04; GROUND/BLOCK/RIVER/FENCE_PARTS OR 0x7/0x30/0x80/0x130 into +0x04
  (`EditPartsAtr` in editparts.hpp); CPOINT +0x08/+0x0C; WEIGHT +0x10; MAX_NUM +0x14; GEO_STONE +0x18; PAINT_NUM +0x1C, PAINT_USED +0x20, PARTS_TYPE +0x24, PLACE_EPS +0x28,
  MAP_NO +0x2C, POLYN +0x30/+0x34/+0x38 (optional by arg count), PARTS_NAME -> +0x40 (plain strcpy),
  PARTS_COMMENT -> +0x48, PARTS_MATERIAL -> `GetMaterial(emapMatID++)` item/num (needs >= 2 args).
- Every routine returns 1 on success, 0 when there is no current definition.

`emapEDIT_PARTS` receives quadword-aligned storage from `mgCMemory::Alloc` and
views it as a character buffer for the converted name through an explicit pointer
reinterpretation. `emapPARTS_NAME` and `emapPARTS_COMMENT` hold the copy of the script string in a
`char *buffer` used for both `strcpy` and the stored field.

## Other
- `editmap.hpp` declares `CEditMap::GetEvent` with `@size 0x1A0`; retail's symbol size is 0x198
  (0x1A0 is the padded extent). Not changed here (editmap's header).
