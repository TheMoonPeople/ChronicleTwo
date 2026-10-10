# menucommon: reverse-engineering notes

Unit range `0x252CF0`-`0x2576F0`, 129 functions. `class_units.tsv` lists **no class owned by this
unit**. The header (`ps2/include/menucommon.hpp`) holds the 37 global functions, two structs, one
enum and the three global data symbols. The other 92 functions are LOCAL in retail
(`build/re/local_symbols.tsv`) and must be `static` in `menucommon.cpp`.

## Local (static) functions
`ReCalcBox`, `CompGameData`, `SeitonItemBoardSub`, every `_MENU_*`, `_ETCINFO*`, `_CLIP_WH`,
`menu_texdata_to_formpart_copy`, `menu_spi_analyze_func_strcut1`, `menu_dtype_init`,
`MakePartsName`. All `_X(SPI_STACK *stack, int argc)` are `SPI_TAG_FUNCTION`s (scriptinterpreter.hpp)
returning `int` (1 = handled; a few return 0 on failure, e.g. `_MENU_FORM_SET`, `_MENU_TEXDATA`).
`ReCalcBox(mgVu0FBOX *out, mgVu0FBOX box)`: out = box re-centred on its own centre; w of both
corners set to 1.0.

## Global functions: return types / evidence
- `MenuAdjustPolygonScale(mgCFrame*, float)`: calls frame vtable +0x40 (`GetWorldBBox(mgVu0FBOX*)`
  per mg_frame.hpp) then the mgVu0FBOX overload; null frame returns 1.0f.
- `MenuAdjustPolygonScale(mgVu0FBOX, float)`: `|(size,size,size,1)| / |ReCalcBox(box).min|`, abs'd,
  1.0 if the divisor is 0. Box passed by value (pointer to copy).
- `MenuAdjustPolygonScale(CCharacter2*, float)`: reads float at CCharacter2+0x110 (`body_height`
  in character.hpp); if |h| > 1 scale = size/h else 1; calls vtable +0x2C with (s,s,s)
  (= `SetScale(float,float,float)`). Returns nothing (epilogue does not set $f0).
- `AddRotationCharaY`: vtable +0x24 `GetRotation(float*)`, adds to [1], `mgAngleLimit`, vtable +0x1C
  `SetRotation(float*)`.
- `MenuSePlay(int)` -> `MenuSePlay(SystemSND_ID, n)` -> `sndSePlay(id, n, 0)`; negative n skipped.
  `MenuSePlay(int, unsigned*, mgCMemory*)` zeroes mgCMemory +0x1C/+0x24, `sndInitPort(8)`
  (SND_PORT_MENU), `sndLoadSound(8, ...)`, plays, sets `MenuSePlayUsedFlag = 1`.
- `StopEnvSoundMenu(int)`: saves/zeros ports 1 (SND_PORT_OB) and 3 (SND_PORT_BASE); if arg != 0
  also 4 (SND_PORT_EVENT); saves/zeros `CScene::GetEnvBGMVol` of `GetMainScene()`.
  `ReStartEnvSoundMenu` restores. Use the `SND_PORT_*` enum from snd_mngr.hpp.
- `MenuSeiton`: returns 0 for null list, else 1. First merges stacks (`CheckTypeEnableStack`,
  `CheckStackRemain`, `GetNum`, `AddNum(n,1)`, `DeleteNum`), then calls `SeitonItemBoardSub` up to
  0x24 times, rotating `sort_top_type` (1..0x23) until a pass reports a swap. CGameDataUsed stride
  0x6C; item id is the s16 at +2.
- `CompGameData(a, b)`: compares `sort_table[CGameData::GetCommonData(id)->byte0]` (kind order);
  ids < 1 sort as 0x24 (last); ties by id; returns 1/-1/0.
- `GetSameAdrressUserData(item, kind)`: only kind 0 searches; walks the bag array at `0x01EFC900`
  (a CUserDataManager member, stride 0x6C) for `GetNowBagMax(1)` entries; returns index or -1.
- `local_sort1(int &sel, int *num, int *list)`: shifts list[sel..num-1] down by one, `--*num`,
  decrements sel if > 0.
- `GetNowChapter(CSaveData*)`: int at CSaveData+0x1A08 (scenario progress): <2 -> 0, 2/3 -> 1,
  >=4 -> v-2; null -> -1.
- `MenuCalcBufAlignment`: same as the first game's (u_long128* rounded up to 64). Retail mangles
  `u_long128*` as `P1`.
- `LoadFileMenu(char*, u_long128*, int mode)`: path = `"menu/"` + `langdirpathTable[LanguageCode]`
  + name; mode 0 -> `LoadFileBG(path, buf, &size)`, 1 -> `LoadFile2(path, buf, &size, 0)`; returns
  size, -1 for null args. Callers pass only 0 or 1 (enum `MenuFileLoadMode`).
  The function-local `langdirpathTable` has seven entries: "0/", "1/", "2/",
  "3/", "4/", "5/", and "1/". Retail declares 0x1C bytes; the following
  zero word is section padding rather than an eighth pointer.
- `MenuCommonReadData(stack, names, mode)`: `StartReadBG`; for each name until NULL loads into
  `stack->buffer + stack->pos*16` (+0x20/+0x24 of mgCMemory), `Alloc((size+15)/16)`, `Align64`.
  Returns total bytes. `mode` is passed on to LoadFileMenu in $a2.
  `names` is a `char **`, but direct `names[i]` indexing changes the PAL loop's
  register allocation (99.18% at the same 0xC4 size); retaining the byte
  offset remains necessary for an exact object.
  Retaining the byte induction variable but indexing `names[i / 4]` scores
  97.12%; indexing with an unsigned shift scores 95.82%. Advancing a typed
  `char **` cursor scores 86.47%. All three compile to the same 0xC4-byte
  function but change register selection or scheduling.
- `ConvertFontCode(src, dst)`: if not `CheckNowEurope()` plain strcpy. Else `[xxxx0HL]`/`[xxxx1HL]`
  9-char codes become one byte from two hex digits looked up in the function-local
  `mes_cord_conv` table (16 pairs
  {char, nibble}); type 1 maps 'R' -> 0xBD, 'S' -> 0xBE.
- `CheckNowEurope`: 1 when 0 < LanguageCode < 6 (see `LanguageCodeNo` in mainloop.hpp).
- `MenuWorkTextureEnter(block, name, w, h, bpp)`: rounds w,h up to 64, `EnterTexture(block, name,
  NULL, w, h, bpp, NULL, 0, 0)`; result discarded (void; no caller reads $v0).
- `MenuEnterIMG(block, img, suffix)`: copies suffix into `mgTexManager.name_suffix` (+0x1D8), or
  clears it; `EnterIMGFile(img, block, NULL, NULL)`; clears suffix.
- `GetReadBGInfo(name)`: `GetCurrentDir` + name -> `GetReadBGFile`; returns its `BG_READ_INFO*`
  (callers use $v0, e.g. MenuMonsterLoadBGCheck).
- `CalcMenu1`, `CalcMenuAdd`, `CalcMenuAdd2`, `GetNumberKeta`, `GetDispVolumeForFloat`
  (rounds up when fraction >= 5e-5), `GetFloatCommaValue`, `CalcScrlBarPutPos`
  (`top + length * (pos / pos_max)`; returns top if pos_max == 0): see Ghidra; all simple.
- `Trans3DPosTo2DPos`: camera vtable at camera+0x60 slot +0x18 fills a matrix, `GetPos`,
  `mgSetViewMatrix`, frame vtable +0x18 (`GetPosition(float*)`), `mgTransWorldScreen(out, pos)`.
- `MenuDataAnalyze(script, size, stack)`: sets `MenuSpiStack`, builds a `CScriptInterpreter` on the
  stack (0xED0 frame), `SetTag(menu_analyze_tag)`, `SetScript`, `Run`; returns 1 (0 for null script).
- `MenuCommandAnalyze(script, size, command)`: strcpy command into `MenuCommandAnalyzeInfo`, runs
  the script with `menu_execommand_analyze_tag`.

## Structs
- `MENU_SPI_ANALYZE_STRUCT1` (retail name, from the mangled `menu_spi_analyze_func_strcut1`): 8 bytes
  `{char *name; int value;}`, from `menu_spi_analyze_func_strcut1` (stride 8, name at +0, value at
  +4, NULL-name terminator). Each keyword table is a function-local static
  named `tbl`; the retail symbols include `tbl_1728`, `tbl_1994`, `tbl_2060`,
  `tbl_2074`, `tbl_2090`, `tbl_2144`, `tbl_2369`, `tbl_2422` and `tbl_2516`.
- `MENU_COMMAND_ANALYZE_INFO` (**not a retail name**; retail gives only the variable name). Size
  0x68 from the symbol size. +0x00 char[0x48] command name (strcpy/strcmp in MenuCommandAnalyze /
  `_MENU_EXE_COMMAND_NAME`); +0x48 short*[4] (`_MENU_EXE_MSGSETSYSTEMBUFF` indexes it, falls back to
  `GetSystemMesBuffer()` when null; menus set +0x48/+0x4C, CShopMenu::InitEnd +0x50);
  +0x58 short*[4] (`_MENU_EXE_MSGSETBUFF`; menus set +0x58/+0x5C). The 0x48 name length is
  inferred from where the arrays start.
- `MenuFileLoadMode` enum: neutral name, values from LoadFileMenu and its callers.

## Globals
Global (in header): `MenuSePlayUsedFlag` (1 byte, `lbu`/`sb`; set by MenuSePlay(3-arg) and
CAquarium::Initialize, cleared in MenuMainInit, tested in MenuMainExit), `MenuSpiStack`
(`mgCMemory*`), `MenuCommandAnalyzeInfo` (0x68; BSS slot 0x70 with alignment).
Local (keep static in .cpp):
- `sort_table` char[0x24] (kind -> sort order; [0] = 0x24), `sort_top_type` s16 (.sdata).
- `SndPortVol_Ob/_Base/_Event/_Env` float, `SndPortCheck_EventPort` int.
- `MenuTexPosNo`, `MenuTexPosNo_local`, `menu_analyze_texblock`, `Menu_Target_No`,
  `Menu_Target_No_local`, `menu_analyze_formno`, `menu_analyze_formno_offset`: 16-bit (symbol size 2).
- `menu_formPt` CMenuPosDataForm*; `menu_form_part` MENUFORMPARTS_TYPE*; `menu_parts_effect_ptr`
  (stride 0x24, probably MENU_PARTS_EFFECT_STRUCT1*); `menu_form_partsno` int;
  `menu_spi_form_action_info` pointer (alloc'd from MenuSpiStack, stored at CMenuPosDataForm+0x64,
  string copied into it, +0x10 holds a pointer); `SpiMenuExeCommandFlag` u8;
  `MenuSpiTextureName` char[0x20].
- `menu_analyze_tag` SPI_TAG_PARAM[0x3C], `menu_execommand_analyze_tag` SPI_TAG_PARAM[0x20].

The two native dispatch tables include their null terminators. The message
preset table has twenty entries plus a terminator and uses
`MenuScriptMessagePreset`; the sound keyword table maps `OK` and `CANCEL` to
`SYSTEM_SE_DECIDE` and `SYSTEM_SE_CANCEL`. `sort_table` stays writable because
the sorting pass updates its ranks. All 129 functions and the complete object
match retail; no assembly data markers remain.

## Types owned elsewhere (forward-declared / not declared here)
- `MENUFORMPARTS_TYPE` (size 0x48 from `_MENU_FORM_PARTNUM` stride; +0x0 name char*, +0xB/+0xC u8,
  +0xE/+0x10 s16, +0x18 u8 texture index, +0x19 u8 flags, +0x1A u8, +0x24/+0x28 float tex w/h,
  +0x44 u8, +0x46 u8 bool, +0x47 u8) and `CMenuPosDataForm` (+0x0/+0x1 u8 set to 1, +0x14 name,
  +0x64 action info, +0x68 s16 part count, +0x6C MENUFORMPARTS_TYPE*): menudraw's types
  (`MenuPosDataTypeInit`, `CMenuPosDataForm::Initialize`). Only static functions here use them,
  so the header does not need them.
- `CPosDataManage` (global `MenuPosData`): +0x0 etc table / +0x4 s16 count (`_ETCINFO_MALLOC`,
  12-byte entries), +0x10 texture table / +0x14 s16 count (0x20-byte entries: mgRect<int> at +0,
  +0x10 name, +0x14 texture name, +0x18 u8 block, +0x1A s16 index; `_MENU_TEXDATA`),
  +0x18 form array (new[] of 0x80-byte CMenuPosDataForm) / +0x1C s16 count.
- `MenuCommonInfo` + 0xC: int[] of texture blocks (`_MENU_TEXNAME`).
- `MenuDCMsg[]`: CDC2Mes* array; +0xB8 int (fuchi), +0x190 float (open speed), +0x228C int (question).

## First game
No direct counterpart unit. `MenuCalcBufAlignment` matches the first game's
(`menu_draw.hpp`), and `LoadFileMenu` replaces the first game's `LoadFileBGMenuData`/
`LoadFileMenuData` pair with one function taking a mode.

## Compiler flag
The local `divbyzerocheck on/reset` directives are redundant with the unit's
global flag: removing them produces an identical complete `menucommon.cpp.o`.
The `fptosi` conversion used by this unit is the CodeWarrior runtime helper declared in
`mw_runtime.h`; using that header preserves the complete object.

## Matching source forms

`_MENU_FORM_MALLOC` retains the explicit placement `operator new[]` call.
Spelling the allocation as `new (block) CMenuPosDataForm[count]` removes the
live byte count, shrinks the frame from 0x30 to 0x20 and changes the object.
`MenuCommonReadData` keeps its byte-offset walk over the name-pointer list;
typed pointer indexing exchanges the saved registers and fails the exact
match. `CalcScrlBarPutPos` is native and returns `top` when `pos_max` is zero;
otherwise it computes `top + length * (pos / pos_max)` in single precision.
