# menudraw: reverse-engineering notes

`CommonBoardDraw` matches. Its row loop colours `left`, `top`, the row-UV base and the
inline bottom-edge subexpression in retail's order only without no-op `(int)` casts and
without a named bottom-edge local; see [the night assessment](matching-constraints.md).

`CRepairManager::GeneratePoly` is accepted native C++ with one scoped
`CActionChara` placement conversion after constructor inlining. This timing is
required for its retail constructor and null-result sequence. No
`NONMATCHING` guards, assembly fallbacks or `.rodata` markers remain in this
unit. Earlier `GeneratePoly` source/profile forms produced 0x214 bytes against
retail's 0x240, shifting following linked text by 0x20 after alignment; that
baseline selected the retail assembly body. See
[placement conversion](../satansfiddle/placement-new.md).

The migrated form helpers write the form's character, movement and named part data through
their existing members. `CMenuEffect::type` is a signed byte: its initializer stores -1, and
using an unsigned field changes MWCC's immediate instruction. `CRepairManager::IsRun` checks
all eight effect pointers and the model pointer even after finding an active entry.

Header: `ps2/include/menudraw.hpp`. Every field offset below was checked with compile-time
offset asserts against the header. No class in this unit has a vtable (no `__vt__` symbol).

## Script keyword tables (source of enum names)
The menu layout script parser in `menucommon` maps keywords to values with
`MENU_SPI_ANALYZE_STRUCT1` tables; the strings give the retail names used for the enums.
- `tbl_1728` (form dtype, `_MENU_FORM_DTYPE`) -> `MENUFORM_DTYPE`. 0x16 "combrd", 0x29 "mosbaji",
  0x2B "wmap" have no case in `MenuFormDraw` (draw nothing).
- `tbl_1759` (form mtype, `_MENU_FORM_MTYPE`): "n","d","l","i","ir" -> index-1, so n=-1 ... ir=3
  -> `MENUFORM_MTYPE`. Stored as a byte at form+0x20; `Initialize` writes 0xFF (= n).
- `tbl_1994` (part dtype, `_MENU_PART_DTYPE`): clut_reload 0x4F, 発明ネタ 0x3C, アルバム 0x3D,
  ごちゃ線 0x4C, font 0x4E, ネタ帳 0x3E. `tbl_2060` bg 0x2D / beta 0x2E (`_MENU_FRMIMG`),
  `tbl_2074` trs 0x37 / neta 0x3B (`_MENU_ITEM`), `tbl_2090` sq_beta 0x41 (`_MENU_FILLBOX`).
  Fixed values: `_MENU_NORMAL` 0, `_MENU_NORMAL2` 1, `_MENU_CURSOR` 2, `_MENU_FUNCINFO` 3,
  `_MENU_NUMBER1` 5, `_MENU_NUMBER2` 6, `_MENU_WAKU_RECT` 0xD, `_MENU_WAKU_CIRCLE` 0xE,
  `_MENU_FORM` 0x19, `_MENU_ITEM_CHECKMARK` 0x39. -> `MENUFORMPARTS_DTYPE`.
- `tbl_2144` (`_MENU_PARTS_EFFECT`): blink 2, rot 3, huriko 4, stretch 6, stretch_rep 7,
  stretch_sin 8. Values 1, 9, 10, 11, 12, 100 appear only in code (`MenuPartsStep`,
  `GetNowPosRGBA`, `Func_MenuItemIconSetEffectOne`) -> `MENU_PARTS_EFFECT_UNK_*`.

## CPosDataManage (0x20)
From `Initialize`, `EtcTblClear` (stride 0xC), `EtcTbl2Clear` (stride 0x14), `TexGetInfoClear`
(stride 0x20), `FormInfoClear`/`GetFormInfo(int)` (stride 0x80). 0x1E: `FormStep` forces each
form's `step_stop` while it is set. Size 0x20 = where `CMenuPosDataManage`'s own fields begin.
Element types `MENU_ETCINFO` (char*, int[2]) and `MENU_ETCINFO2` (char*, float[4]) are not
retail names (named after the `_ETCINFO_MALLOC`/`_ETCINFO2_MALLOC` script tags).

## CMenuPosDataManage : CPosDataManage (0x5BC)
Size from `MenuMainInit` (`__nw(0x5BC)`). `InitializeCMenuPosDataManage` zeroes 0x30..0x60,
0x6C, 0x70, memsets 0x74 (600 bytes, 0), 0x2CC (600, 0), 0x524 (0x96, value 2). Nothing in
the decompiled corpus reads 0x40..0x48, 0x74, 0x2CC or 0x524 through `MenuPosData`; types
unknown. `MallocPallet` loops i=0..1: palettes at 0x20/0x28/0x30 + 4i (normal / grey
quantised / sepia copies of the source texture's clut), textures at 0x5C/0x64/0x6C + 4i built
by `memcpy` of the source `mgCTexture` at 0x54 + 4i. `GetMenuItemIconTexInfo(item, kind)`
reads {0x54,0x5C,0x64,0x6C}[kind] + `use_trans_rect`*4 -> `item_icon_tex[4][2]`.
`SearchTransPalletNo` writes s16 at 0x38 + 2i. `AttachCommonTexInfo`: 0x3C, 0x4C, 0x50,
0x54, 0x58 from `mgTexManager.GetTexture` (names at_4182..at_4186); 0x4C is passed to
`DrawItemIconEffect2`, 0x50 to `CMenuEffect::PresetEffect` (fusion), hence the field names
`icon_effect_tex`/`effect_tex` are guesses from use; rename freely.

## CMenuPosDataForm (0x80)
Stride 0x80 in `CPosDataManage`. Layout from `Initialize`, script tags in `menucommon`
(`_MENU_FORM_SET` 0x00/0x01/0x14, `_MENU_FORM_DRAWFLG` 0x01, `_MENU_FORM_VIBECNT` 0x08/0x0A,
`_MENU_FORM_PUTXY` 0x0C/0x10, `_MENU_FORM_MOVERATE` 0x2C/0x30, `_MENU_FORM_RGBA_BIT` 0x50
(r=1 g=2 b=4 a=8), `_CLIP_WH` 0x06, `menu_dtype_init` 0x1C, 0x40..0x4C), `SetNextMovePos`
(0x20,0x24,0x28), `SetActionCharaPtr` (0x34,0x36,0x38), `SetRGBACalcParam` (0x51+i, 0x59+i),
`MenuFormStep` (`CalcMenuAdd(&rgba[i], (s8)rgba_add[i], rgba_target[i])`), `SetAction`
(0x5E, 0x60, 0x62, 0x64 stride 0x14, name compared inline), `FormReLink` (0x70/0x74).
- 0x34: below 1 -> `mgDrawDirect(chara->frame)`, else reload that texture block and call a
  chara vfunc. 0x36 never read here. 0x3C and 0x78..0x7F never seen.
- `action_state` values: 1 set by `SetAction`, 4 once `MenuFormStep` reaches target.
- `MenuFormStep`/`StepMainMenuIconMove` return a comparison result (ghidra: bool); declared
  `int`. `GetNextMovePos` always returns 1.
- Action entry `MENU_FORM_ACTION` {char[0x10], ptr} and its `MENU_FORM_ACTION_MOVE` {s16 mtype,
  float x, y, rate_x, rate_y} (from `_MENU_ACTION_DEF` and `GetNextMovePos`) are not retail
  names.

## MENUFORMPARTS_TYPE (0x48)
Stride 0x48 everywhere. `MenuPosDataTypeInit` gives defaults. `_MENU_PARTVIBER` 0x0B/0x0C,
`_MENU_PARTVIBECNT` 0x0E/0x10, `_MENU_SHADOW_ONOFF` 0x46/0x47, `_MENU_PART_ETCINFO` writes
int 0x30 + 4*i, `_MENU_PARTS_EFF_NUM` 0x40/0x44, `menu_texdata_to_formpart_copy` 0x24/0x28
from the tex info w/h. 0x19 bit 0 -> Bilinear; 0x1A -> `AlphaBlend((s8))`. 0x45 = item icon
state bits (|1 in `Func_MenuIconDrawPrepare`, |2 in `CheckItemBoardFunc_...`), passed to
`DrawOneItem`. 0x2C float, init 1.0, passed to `PictureDraw` (meaning unknown). 0x0D, 0x12,
0x1B unseen. menuop `KeyStep__14CSaveMenuClassFv` reads s16 at +0x12 of something: not
verified to be a part.

## MENU_BASETEXINFO (0x20), MENU_PARTS_EFFECT_STRUCT1 (0x24)
BASETEXINFO: `MENU_BASETEXINFO_Init`, `_MENU_TEXDATA` (0x10 name, 0x14 tex name, 0x18 block,
0x1A table index), rect is x,y,w,h. EFFECT_STRUCT1: `_MENU_PARTS_EFFECT` sets 0=1, 1=1, 2=type,
4+ floats; `MenuPartsStep` clears byte 0 at cycle end only when byte 1 is 0. Allocated in
16-byte units: `(n*0x24 + 15) >> 4`.

## MENUFORM_MAKEBRD_INFO (0x2C)
`Init_` memsets 0x2C; `CalcCommonBrdDrawInfo` copies 0x2C into the local `CommonBoardDrawInfo`.
`CommonBoardDraw` reads 4 lines of stride 6 (u8 board-style index into `get_onoffbrdtbl_1789`
stride 0x18, u8 button index into `get_btntbl_1810`, s16 at +2 and +4), int 0x1C drawn as a
number, 0x20 index into a colour table, 0x24/0x28 tested > 0. editmenu `MakeMsgPartsItemInfo`
counts materials into 0x18. Line struct `MENUFORM_MAKEBRD_LINE` is not a retail name.
`MakeBoardDrawInfo` (global, 0x14) is float[5]: (x,y) of two buttons indexed `[i*2]` by
editmenu/inventmn, then the board width at +0x10.

## Effects
- `CRepairEffect` 0x24: `CRepairManager::Generate` does `__nw(0x24, ...)`. Particles stride 0x30
  (`__nwa(n*0x30)`), struct `REPAIR_EFFECT_PARTICLE` not retail. Particle 0x0/0x4/0x8 set to
  128/128/64 but never read; 0x14 set 0.
- `CRepairManager` 0x1EC: `MenuModeMalloc__13CMenuItemInfo` `__nw(0x1EC)` and constructs
  `mgCMemory` at 0x24..0x1A4 step 0x30 plus 0x1B4 (implicit ctor of the member array).
  0x1A4 copied into effect+0x1C, never set in this unit. 0x1B0 holds an inline-constructed
  `CActionChara` (`__nw(0x1030)`), driven by vtable calls. 0x1D0/0x1D8 writes in
  `GeneratePoly`/`Step` are fields of `model_stack`.
- `CLevelUpEffect` 0x30 / `CLevelUpEffectManager` 0x190 (`MenuLevelUpMan` symbol size). Effects
  start at manager+0x10, so the effect is 16-aligned: pos at 0x10 is `sceVu0FVECTOR` (filled by
  a CCharacter2 vfunc +0x18). Manager 0x0 = label texture (menusys `EnterDataMenu`), 0x4 = spark
  texture; 0x8..0xF padding. `IsRun` returns the byte at 0 (declared u8).
  Spark state is in the local arrays `l_levelup_pos/vec/counter/generate_counter` (32 sparks,
  shared by all effects).
- `CStarDust` 0xC: inventmn `__construct_new_array(..., __ct__9CStarDustFv, 0, 0xC, n)`; ctor
  (inline, emitted in inventmn) clears byte 0xA.
- `CEffVerticalLine` 0x40: `__nwa(n << 6)`; `mgTransWorldPrim3DSprite(..., this, w, h)` so
  pos is a 4-float vector at 0; 0x34..0x3F unseen.
- `CMenuEffect` 0x38: `__nw(0x38)` in inventmn/menusys. Effect type byte 0x9 values seen:
  0, 1, 2, 4, 0xA, 0xB, 0xC, 0xF, 0x10, 0x12, 0x13 (spectrum break), 0x14, 0x15 (fusion item);
  no names known, so no enum. 0x14 is s16[16] copied from an int array (low halves).
  `MENU_EFFECT_INFO` (0x40, stride in `PresetInfoAll`) is 16 floats used per kind; only
  0xC/0x10 (screen x/y in `Draw`) named.

## Globals
Only non-local data is declared `extern` (checked against `local_symbols.tsv`). Types:
`MenuMesForm` 9 form pointers (`AttachMessageForm`), `MenuDrawItemInfo` 150 item pointers
(stride 0x6C items in `SetModeMenuDrawItemBoard`; loop bound 0x96), `menu_limmit_displayflag`
byte flags (symbol size 0x9C), `Pos_ItemInGiftBox` s16[3][2], `GiftBoxWindowPutPos` /
`menu_long_hand` mgRect<int> (set in `__sinit_menudraw_cpp` via `mgRect::Set`, so these are
dynamically initialised in source; same for local `MenuMainFrame_PutRect`,
`MenuMainIMG_PutRect`, `star_light`, `MenuItemBrdKomaRect`, `ItemBoardScrlBar1..3`,
`ItemBoardCursor`). `NowGiftBoxPtr` holds `SearchNowPosItemExist` results (declared
`CGameDataUsed*`; it reads s16 at 0 and +0x10). `MenuCursorReverseFlag`,
`MenuItemBrdCalcManner`, `GiftBoxViewFlag` are 1 byte.

Defining the ten rectangle globals with their initial coordinates invokes the `mgRect<int>`
constructor at startup. MWCC emits the retail `__sinit_menudraw_cpp` initializer exactly,
including the order and calls to `mgRect<int>::Set`.

`PrimQuad_f_` and `PrimQuad_i_` use concrete 16-byte-aligned rectangle parameter types;
their native C++ mangled names and instructions match retail. The template `mgRect<T>`
name mangles differently under this compiler and cannot supply these retail symbols.

An earlier `CRepairManager::GeneratePoly` typed-placement trial removed raw
vtable writes and a run-script constructor alias but scored 89.17%. In that
source/profile form, retail wrote successive base vtables and called their
virtual `Initialize`, while the candidate called base constructors. The miss
lay in construction before model setup. The current accepted body uses natural
construction with the scoped compiler conversion.

## Other
- File-local functions (static, not in the header): ConvMGIRECTtoINTtbl, ConvMGFRECTtoFLOATtbl,
  both SetPartEffectInfoRandFunc, PushPrimRepeat, MenuWindowHelp, SetMenuDrawNumberKeta,
  DrawMenuNumber, GenarateRandamLine, DrawRandamLine, MenuMainFrameImgDraw,
  MENU_BASETEXINFO_Init, DrawItemIconEffect2, MenuFrameImageDraw, InitInitBuildUpInfoEffectPos.
- `PrimQuad<f>`/`PrimQuad<i>` are instances of a function template
  `template <class T> void PrimQuad(mgCDrawPrim*, mgRect<T>, mgRect<int>)`; only declared in the
  header. Retail has one copy each, in this unit; other units call them.
- `GetMenuDlTexture` returns the texture (ghidra lost the return; callers cast the result).
  `GetMenuMainFrameCount` returns a float from `tbl_2072`; `GetMenuMainFrameLeftTopPos` returns
  `&MenuMainFrame_LeftTop_Pos` (float[2]) regardless of its argument.
- Parameter names of the large drawing functions are best guesses from their bodies; `unk`
  parameters were not traced.
- No first-game counterpart: the first game has no menudraw/CPosDataManage equivalent in
  `/home/adubbz/development/chronicle/ps2/include`.

## Native drawing helpers

`PrimFillRect4` emits four coloured vertices in top-left, top-right, bottom-left,
bottom-right order after checking all four colour pointers. `DrawMenuTilePattern`
draws up to 16 columns and 12 rows, stepping by the source rectangle dimensions;
it exits at screen width plus 4 and screen height plus 40. `DrawMenuDl(int&,...)`
and `MenuMainFrameStep` drive the progress panel and moving lens frame.
`CalcCommonBrdDrawInfo` sizes the common board from up to four message names and
positions the line slots. All five have active native bodies; the earlier
five-fallback inventory predates their accepted source forms.

## Compiler flag
The earlier local `divbyzerocheck on/reset` directives around form fades and
an effect step were redundant with the unit's global flag: removing them
produced an identical complete `menudraw.cpp.o`.

## Typed menu array access

`GetPartInfo` indexes its `MENUFORMPARTS_TYPE` array directly; the 0x48-byte
stride follows from the type. `Func_MenuItemBrdPrepare` and
`Func_MenuItemBrdPrepare2` index `CGameDataUsed` entries, and `SetAction`
reads the named `MENU_FORM_ACTION` and writes `action_no` and `action_state`.
All four functions retain a 100% retail object diff. `GetEnableEnterPart`
still requires its explicit stride to keep MWCC's register choice (direct
typed indexing scored 97.83%).

## Additional typed effect arrays

`StepBuildUpInfoEffect` indexes the 0x40-byte `CEffVerticalLine` array
directly for each line. `CMenuEffect::PresetInfoAll` indexes the 0x40-byte
`MENU_EFFECT_INFO` array, and `CheckItemBoardFunc_MenuIconDrawPrepare`
advances its `CGameDataUsed*` by one entry. These three functions retain
100% retail object diffs. `DrawBuildUpInfoEffect` also matches with direct
indexing, but that spelling changes the adjacent `StepFishBoiledEffect`
object diff, so it retains its explicit stride. The separate part lookup in
the item board helper and the line-position initializer still need their
byte-stride forms for exact MWCC register allocation.

## Stable item-board interpolation argument order

The `menudraw.cpp` profile row for `Func_MenuItemBrdPosStep__Fi` selects
`binary32` `0x40000000` (2.0f) with `evaluate_first: true`. It applies to all
identical literals in that function and has no occurrence counter or callee
restriction. The function obtains the item board's origin, computes its
vertical target from the top visible row, either interpolates or snaps the
board position, and updates its scroll bar. At `CalcMenu1`, the flag
materializes the 2.0f minimum movement argument before the 4.0f interpolation
divisor, restoring retail's argument register order.

The native 256-byte function has zero differing instruction words and
relocation fields with the current annotation and direct-literal consumer
hooks. Canonical wrapper compilation, `fixup_sections.sh`, and
`check_objects.py` validate `0x14090` allocated unit bytes and 2,389
relocations. At that source/profile boundary the existing `CRepairManager::GeneratePoly`
constructor/layout findings remained; the row introduced no additional failing
function. Those findings predate the accepted placement-conversion body.

## Native main-frame image drawing

`MenuMainFrameImgDraw(int&)` draws the full-screen captured image and its
lens-positioned copy. Modes 0 and 1 retain the configured image rectangle;
mode 1 fixes opacity to 128. Other modes offset the rectangle from the lens
centre. The opacity otherwise follows the display-mode counter, and the
second destination gains one pixel of height. Grouping modes 0/1 in a switch
preserves retail's compact mode block before the lens-offset block.

The native function had zero canonical instruction and resolved-relocation
differences using the then-standard profile. That isolated unit contained
`0x1408C` allocated bytes and 2,397 relocations, with 16 existing
`CRepairManager::GeneratePoly` constructor/layout problems. The image-drawing
function needed no profile override. At that earlier boundary, `PrimFillRect4`
and `DrawMenuNumber` were guarded after entry-copy and texture-argument
scheduling misses; both are now native.
The newer native `DrawMenuWakuStep` is retained in the merge; the earlier
induction-scheduling trial does not describe its current status.

An earlier tile-pattern draft reproduced retail's outer column loop when the
screen edge was tested within a bounded do-loop and columns advanced by the
destination width. Its row-loop delay and exit schedule differed, including
with a direct label spelling, so that trial retained assembly. An earlier
`GenarateRandamLine` trial matched the point-generation phase when `sway` was
declared before `progress`, but the final periodic y-coordinate exchange
allocated different integer registers. These rejected forms predate the
active native implementations of both functions.


## Native data and matching constraints

MenuCursorReverseFlag is the sole retained data marker: retail declares one byte while
the public header exposes extern int. Its four-byte reservation contains three alignment
bytes. Other state and initialized data are native, including GeneratePoly's inline
literals.

Exported extents are nine forms, 150 item pointers, three gift-box position pairs, five
creation-board floats and 156 display-limit bytes. Counters and flags retain their
declared widths: use_trans_rect and boiled-fish counters are two bytes;
MenuMainFrame_MoveRate_Cnt and MenuWakuRotCnt are floats; MenuPosData is a pointer;
CommonBoardDrawInfo is 0x2C. Marker reservations must not enlarge these objects.

Compiler initializer ownership includes DrawMenuWakuStep's six-float move (0x18), two
ten-short icon arrays (0x14 each), Func_MenuItemBrdPosStep's {0,24} position (8),
GetPutPosXY's float pair (8), GetNextMovePos's integer pair (8),
Menu3DivideTextureDraw's int[2][4] (0x20), ten-short zero sparkle (0x14), and four
four-byte corner RGBA arrays. The last size-row element is an implicit zero.
CommonBoardDraw and MenuItemBrdFrameDraw emit their row heights, blink colors,
scroll/layer arrays and twelve-pointer frame-parts templates; native switches generate
their own jump tables.

Spectrum tables contain sixteen triples of short pairs and sixteen rows of six binary32
angles. Rectangles use MENU_SHORT_RECT's final width/height components. Paint has nine
RGBA rows, spectrum raster forty signed bytes, gift-box coordinates thirty-six shorts,
frame-mode counts eight floats, star colors nine components, fish-bounce rates three
floats, icon offsets twenty-three pairs, and language movement offsets three-by-eighteen
pairs. Geostone text has seven pointer pairs, preserving [UNI00e9], pooled space/English
strings and real pointer relocations.

GetMenuItemIconTexInfo reads typed item_icon_tex[4][2] members; its four-pointer
initializer owns sixteen bytes. DrawMenuWakuRect's second edge initializer must remain a
call-argument temporary after the named edge record: moving a named initializer to its
use exchanges stack slots (eight word differences at 0x518 bytes); value initialization
grows to 0x538 with 118 differences. The direct scissor rectangle yields retail's
0x518-byte body without extra storage or profile rows.

## Common-board constants

CommonBoardDraw's integer casts convert floating positions, blink values
and dimensions. SetSpriteEnv's 0/1 mode has no established shared enum;
line->kind indexes the two-entry on/off board table. Other literals are
screen/texture coordinates and color channels. Its declared retail body
is 0xDD8 at 0x224F10.

## Persistent state ownership

MenuPresentBoxView owns its float curpos static inside the visible-cursor
branch, while MenuMainFrameStep owns its signed-byte MainFrameStepFlag at
the frame-step point. C++ emits both initialization guards; no explicit
compiler latch is needed in the source. Their localized forms preserve the
complete unit's bytes, data extents and resolved relocations.
