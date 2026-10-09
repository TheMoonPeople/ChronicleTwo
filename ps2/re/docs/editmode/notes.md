# editmode: reverse-engineering notes

## Source status

Every function in the unit is native C++; there are no `NONMATCHING` guards,
`INCLUDE_ASM` fallbacks or data markers. All `.data`, `.sbss`, `.sdata`,
`.bss` and `.rodata` objects are typed native definitions.

- `EditMode` (0x2DF4F0, GLOBAL, symbol size 0x1DDC inside the padded 0x1DE0
  extent) depends on the Satan's Fiddle row in `scripts/build/satansfiddle.json`
  for `EditMode__FP6CScene`: binary32 `0x3f490fdb` (0.7853982f, the
  quarter-turn tolerance) at callee `mgAngleCmp__Ffff`, `evaluate_first: true`,
  `expected_matches: 3`. Retail materialises the tolerance before the other
  arguments at the three angle tests that snap digital cursor movement to
  camera-relative quarter turns.
- `LoadEditCursor` (0x2DDB30, GLOBAL, symbol size 0x5B4 inside the 0x5C0
  extent) depends on the placement-new row for
  `LoadEditCursor__FP9mgCMemoryi` / `__nw__FUiP1` / `__ct__11CCharacter2Fv`,
  `after_constructor_inline`, `expected_matches: 3`: the three `CCharacter2`
  cursor constructions (paint, removal, shovel). See
  [placement conversion](../satansfiddle/placement-new.md).

Georama mode (town editor cursor): placing, removing ("RemoveMtn", shovel) and painting parts,
putting parts against walls, rivers, undo, help line, walk<->edit checks. No class is owned by
this unit (`class_units.tsv`). All external callers are in `editloop`. No first-game counterpart
file with this name; the first game's `edit*.hpp` cover a different editor.

## Visibility
Local (static, keep in .cpp; not in the header): `CheckControl`, `SetHelpMes`, `GetUserData`
(retail `GetUserData__Fv`; returns `GetSaveData() + 0x1D2A0` as `CUserDataManager*`, or 0),
`ConvColor`, `ConvColorV`, `emSearchColorCode`, both `emGetPenkiItemNo`, `IntiSystemMes`,
`OpenSystemMes`, `SystemMesClose`, `SystemMesStep`, `EditStartPlaceEffect`, `EditEndPlaceEffect`,
`ClearEditStepCnt`, `GetUndoData` (returns `&UndoData`, i.e. `UNDO_DATA*`), `UndoEnable`
(`info_id >= 0`), `UndoPlaceParts`, `StackUndoData`, `CheckPlaceAlt`, `GetGeoMapLimitHeight`
(float), `CheckFocusBalanceParts`, `InitBalanceDraw`, `GetBalanceHeight`, `GetGeoCheckPts`,
`GetGeoCheckCol`, `GetGeoCheckCamCol`. The other 28 functions are global and declared.

Returns of global functions (from the code): `StartEditMode`, `StartEditModeFromMenu`,
`PaintEditParts` always 1; `PlaceRiverStep`, `RemoveMtnStep` always 0; `PlaceEditParts` 0 when
`GetePartsInfoAtID(PartsInfoID)` is NULL, else 1; `RemoveEditParts` 0/1; `DeleteKanketuParts`
returns `CEditMap::RemoveEditParts`'s result; `NowPlaceRiver` = `PlaceRiverCnt > 0`;
`CheckWalkToEdit`/`CheckEditToWalk` 0/1. `EndEditMode`'s `float*` is unused.

## UNDO_DATA (0x30)
Size from `UndoData` symbol (0x30, .bss) and the 0x30 stack local built in `PlaceEditParts`.
- 0x00 s32 info_id (`PartsInfoID`; -1 = nothing to undo, `ClearUndoFlag`, `UndoEnable`)
- 0x04 s32 parts_no (slot from `BuildEditParts`; -1 for a river; passed to `RemoveEditParts`)
- 0x08, 0x0C never written or read (`StackUndoData` copies 0x00, 0x04, 0x10..0x2C word by word)
- 0x10 pos (vector, passed as `float*` to `RemoveEditParts`, copied to `eCurPos`)
- 0x20 rot (0x24 = Y passed to `CEditMap::ConvEditAngle` to set `eCurRot`)

## Globals
Global (extern in header): `WallPutPos` (0x10, vector; X/Y clamped to `WallInfo.box` in
`EditMode`, zeroed by `StartEditPutWall`), `WallInfo` (0x40, `CEditParts::WallInfo`; filled by
`StartEditPutWall`, 8 words + `mgVu0FBOX::operator=` at +0x20).
Everything else is LOCAL in retail (`local_symbols.tsv`) and belongs in the .cpp as `static`:
- `EditModeNo` (EditModeType), `MagnetEnable`, `HighSpeedMoveCnt`, `PutSideMode` (EditPutSideMode),
  `PuuSideRotCameraFlag` (sic), `PlacePartsNo`, `PartsInfoID`, `RemainPartsNum`, `PlacePartsFlag`,
  `PartsHeight`, `MagnetPartsFlag`, `PaintItemNo`, `CursorLockCnt`, `PlaceRiverCnt` (50 at start;
  sound at 40, place at 30), `RemoveMtnCnt` (18 at start; removal at 3), `eDirCurLen` (float),
  `NowSelectWallParts`, `SelectWallGroup`, `PreMenuCount`, `PreMenuMaxCount`, `CtrlLockFlag`
  (lock counter, clamped at 0), `eCameraDist` (float, 600.0f in `InitEditFlag`), `eCurRot`
  (integer 15-degree turn index: the angle conversion APIs and the `%d` debug formatter consume
  it as an integer and storing it into a float slot uses `cvt.s.w`), `eSysTexture` (`mgCTexture*`), `PaintCursor`, `PaintCursor2` (+0xF4 -> material with
  colour floats at +0x70..0x78), `PaintCurChr`, `RemoveCursor`, `ShovelCursor`, `ShovelCurChr`,
  `RemoveCurChr`, `UnitCursor` (models/characters; virtual calls at +0x18, +0xB0, +0xB4),
  `EditHelpMesNo` (EditHelpMes), `EditHelpMesParam`, `EditHelpMesParam2`, `SysMesCnt`,
  `SysMesNo` (.sdata, message number, <0 = closed; `IntiSystemMes` sets -1).
- .bss vectors (0x10 each): `PaintColor`, `eCurPos`, `eCurNowPos`, `ePartsCurPos`,
  `ePartsCurNowPos`, `ePartsCurRot`, `ePartsCurNowRot`, `PlaceRiverPos`, `RemoveMtnPos`,
  `RemoveMtnCurPos`, `eDirCurRot`, `now_balance_h` (typed vectors); `EditCursor` (three frame
  pointers, 0xC plus 4 bytes of piece padding), `Font` (0xB8, a file-local `CFont` for the help
  line; its compiler-generated initializer emits the retail `CFont::Init` call), `UndoData`
  (UNDO_DATA, 0x30), `WallInfo` (`CEditParts::WallInfo`, 0x40).
- .data help strings: `space_str`, `place_str`, ... `repaint_fence_str` are `char *[6]` (0x18,
  indexed by `LanguageCode` 0..5); `onoff_str` is `char *[2][6]` (0x30; index
  `(param == 0) * 6 + lang`, so [0] = OFF, [1] = ON; the help labels name the action offered by the toggle).
- Function-local statics: `DrawEditCursorParts` has `static int cnt = 0` (pulsing preview light);
  `DrawEditCursor` has its own `static int cnt = 0` (saved reference-position toggle) and an
  uninitialised `static sceVu0FVECTOR pos_save` (saved XYZ position and orientation as float).
  MWCC supplies the one-byte guards and their four-byte reserved pieces.
- `DrawEditHelpMes` has two zero-initialised 0x100-byte char buffers (help text and paint-count
  formatting); their zero templates are compiler-generated. Its twelve-entry switch emits the
  48-byte jump table natively, including the common exit for help case 11.
- `SysMesNo` is a four-byte `.sdata` integer initialised to -1.
- Help tables: the six-language pointer arrays hold inline Shift-JIS literals (`\x` escapes),
  in Japanese, English, French, German, Italian, Spanish order. `remove_str` and `sel_wall_str`
  share their French, German, Italian and Spanish literals; `onoff_str`'s Italian entries share
  the English `off`/`on` literals. House painting formats two equal costs; whole-fence painting
  formats the cost and five times the cost.
- Colour templates: `PlaceRiverStep`'s paint-effect colour is a local float aggregate of four
  128.0f; `DeleteKanketuParts`'s removal-effect vector is `{8, 8, 8, 0}`; `DrawEditCursor`'s grid
  highlight is `{128, 64, 64, 48}`; `DrawEditSystem`'s balance palette is `float colors[2][2][4]`
  (normal/highlight RGBA pairs for the two balance states) and the selected pair is a pointer to
  four-float arrays indexed for the normal and highlighted entries (a flat four-row palette
  indexed as `balance * 2 + 1` changes the code).

## Enums (values seen)
- EditModeType (`EditModeNo`, set from `MenuInfo+0x3C` via `StartEditModeFromMenu`): 0 in
  `InitEditFlag`; 2 in `StartEditMode` and placing branch (`SetHelpMes` 0/1/2/0xB); 3 shovel
  branch (`RemoveMtnStart`, help 3); 8 paint (`PaintEditParts` with `PaintColor`, deletes paint
  item); 0x10 restores `CEditPartsInfo::GetDefColor` (help 8/9/10; `StartEditModeFromMenu` sets
  colour to -1/0xFF). `StartEditModeFromMenu` only sets up for 2, 3, 8, 0x10.
- EditPutSideMode (`PutSideMode`): 0 -> 1 when entering wall put; 1 shows help 4 and picks a wall
  part (`IsWallParts`, `GetWallPlane`) then 2; 2 moves `WallPutPos` with the analog stick and
  places on the button, back to 0.
- EditHelpMes: cases 0..0xB of `DrawEditHelpMes`; the strings each case uses gave the names.
  Paint cases by `CEditPartsInfo+0x1C` (1 = one colour, 2 = house) and `CEditParts::IsFence`.
- `PaintEditParts` colour number 99 = whole fence (`CEditMap::PaintFence`); else `SetColor`.

## Parameters
- `LoadEditCursor(mgCMemory*, int block)` / `DrawEditSystem(int block, ...)`: texture block for
  `mgCTextureManager::EnterIMGFile` / `ReloadTexture`; editloop passes 0xA3.
- `DrawEditSystem` 4th arg: 0 walking (shows enter-edit icon via `CheckWalkToEdit`), else editing.
- `StartEditModeFromMenu(scene, mode, int *arg)`: `MenuInfo+0x40`; place/remove: [0] info id,
  [1] count; paint: [0..2] RGB 0..255, [3] paint item number.

## Unresolved
- `DeleteKanketuParts` ("kanketu" = completion): first calls `GetePlaceParts(PartsInfoID)` as a
  null check, then removes `parts_no` at `eCurPos`; chosen in `EditMode` instead of
  `PlaceEditParts` when the selected definition is 0x55 and the probed existing part has
  definition 0x4C. The existing ground height is retained for that completion
  operation; the retail names of those definitions remain unidentified.
- UNDO_DATA 0x08/0x0C meaning (likely padding before the vectors).

## EditMode: source forms the match depends on

- The collision box is one real `mgVu0FBOX box` (`max` at +0, `min` at +0x10),
  accessed as `box.max`/`box.min` with no corner pointer or alias. Passing it
  to `GetGeoCheckCamCol(map, box, polys, EDIT_CURSOR_POLY_MAX)` nested inside
  `CheckHit` gives retail's argument order. Two separate corner arrays cast to
  a box, or any `box_low` pointer, change the register allocation or oversize
  the body (0x1DE4..0x1DEC).
- `poly_count` from the initial movement collision query (dead after
  `MoveCheck`) is reset to zero and reused for the ground query. With separate
  counts the `box.min` address (a `&box + 16` common subexpression used at
  nine sites) is spilled and rematerialised instead of living in `s5`.
- The collision buffer is a typed `CCPoly polys[EDIT_CURSOR_POLY_MAX]` (0x800)
  walked as `next_poly += added` with `poly_rest` capacity tracking; indexing
  `polys[poly_count]` instead gives a different body.
- Scene objects come from `scene->GetMap(scene->active_map)` and
  `scene->GetCamera(scene->active_camera)` with `static_cast` to `CEditMap` /
  `mgCCameraFollow`; wrapper helpers have no retail identity.
- Real declarations hoisted to function scope in the order `pad`, the four
  key flags up/down/left/right, `attr`, `poly_rest`, `map`, `camera`, then the
  remaining function-scope locals, give retail's saved registers (up `s6`,
  down `s5`, left `s4`, right `s1`); every assignment stays at its original
  point.
- The digital-key branch overrides the analog direction by writing the
  existing `stick_x`/`stick_y` locals (`stick_x = stick_y = 0.0f`, then the
  key values) and applies the same rotation
  (`move_x = stick_x * cosf(angle) + stick_y * sinf(angle)`), giving `stick_y`
  `$f24`, `stick_x` `$f23`, cosine `$f22`, sine `$f20`. Separate key locals
  exchange f22/f24.
- The 17 full-vector copies are `*(u_long128 *) dst = *(u_long128 *) src`
  (upstream convention); `memcpy`, `sceVu0CopyVector` and `mgVec4` storage all
  oversize the body (0x1DF4..0x1E64) because the corner copies scalarise.
- Control forms retained because the alternatives change the body: the
  repeated final map-null condition, the single-pass placement `while`, the
  paint block's early exits, bitwise `|` in the movement comparisons, and the
  negated `<=` floating comparisons (NaN behaviour). Whole-fence paint checks
  availability before multiplying its cost by five.
- Named values: `PadCtrlButton` (`PAD_BTN_EDIT_*` in padcontrol.hpp; part and
  wall turn R2/L2, camera angle R1/L1, language-adjusted confirm) and
  `PadCtrlAnalog`, `SYSTEM_SE_MAGNET`, `EDIT_ANGLE_90`, `EDIT_CURSOR_POLY_MAX`,
  `EditModeType`, `EditPutSideMode`, `EditHelpMes`. The motion-name
  comparisons inline the same Shift-JIS strings `PaintEditParts`,
  `PlaceRiverStart` and `RemoveMtnStart` pass; the `"CEditMap"` `Iam()`
  comparison and `"penki item = %d\n"` format are inline.
- `EP_PLACE_INFO::unk_44` identifies restricted-definition overlaps from its
  producing query; the retail names of those definitions are unknown.

MWCC allocation traits observed here: a single-definition pointer to a local
array is kept in a saved register across calls and is not propagated at IR
level; a separate `p = b;` statement is forward-substituted within its basic
block while an embedded `(p = b)` is not; a rematerialisable address CSE
counts about half per reference in the spill choice, so straight-line uses
do not keep it in a register but one use inside a loop does.

`StartEditMode` uses the scene's active camera as `mgCCameraFollow` for the
follow settings; the player already inherits `mgCObject`. `EndEditMode` uses
the typed `CEditMap` returned by the active map slot and calls the player's
base position setter directly. `StartEditModeFromMenu` stores to
`PaintCursor2->attr->color[1]`/`[2]` with the global cursor loaded before each
colour value.

## LoadEditCursor

Loads the Georama system texture (`etc/gsys.pak`, `etc/g_edit.img`,
`haichi_eff`) and the removal (`etc/a_mu.chr`), paint (`etc/hake.chr`,
`info.cfg`, frame `hake_1`), shovel (`etc/sukkopu.chr`), placement
(`etc/cone.mds`) and grid-cell (`cursor.mds`) cursor models, applies their
frame attributes, and configures the debug font. The path/model literals are
inline. The pack size output is a real `int` (matching `GetPackFile`'s
argument); both quadword-rounding branches cast it to `u_int` before shifting
to keep retail's logical right shifts (one signed branch costs one word). The
Z-write sentinel is `MG_ZBUF_NO_WRITE`; font preset/outline values stay
numeric (no owning enum).
