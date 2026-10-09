# editmode: reverse-engineering notes

`EditMode` is active native C++ and exact after the October 9 promotion:
0/1912 differing words, GLOBAL symbol size 0x1DDC. The production profile
evaluates its three `mgAngleCmp` quarter-turn tolerances first and asserts
three matches. `LoadEditCursor` is the unit's only remaining guarded function.
EditMode-owned literals and zero-vector templates are native; the only ten
data markers are LoadEditCursor strings. The dated probes below describe
earlier source snapshots; the current result
and its complete-object/PAL validation are in
[night-20261008.md](night-20261008.md).

`LoadEditCursor` allocates three `CCharacter2` objects for the paint, removal,
and shovel cursors. Its C++ draft uses the class constructor; retail assembly
remains active while the surrounding load and construction code is unmatched.

Georama mode (town editor cursor): placing, removing ("RemoveMtn", shovel) and painting parts,
putting parts against walls, rivers, undo, help line, walk<->edit checks. No class is owned by
this unit (`class_units.tsv`). All external callers are in `editloop`. No first-game counterpart
file with this name; the first game's `edit*.hpp` cover a different editor.

## Visibility
Local (static, keep in .cpp; not in the header): `CheckControl`, `SetHelpMes`, `GetUserData`
(`GetUserData__Fv__3`; returns `GetSaveData() + 0x1D2A0` as `CUserDataManager*`, or 0),
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
  (integer 15-degree turn index), `eSysTexture` (`mgCTexture*`), `PaintCursor`, `PaintCursor2` (+0xF4 -> material with
  colour floats at +0x70..0x78), `PaintCurChr`, `RemoveCursor`, `ShovelCursor`, `ShovelCurChr`,
  `RemoveCurChr`, `UnitCursor` (models/characters; virtual calls at +0x18, +0xB0, +0xB4),
  `EditHelpMesNo` (EditHelpMes), `EditHelpMesParam`, `EditHelpMesParam2`, `SysMesCnt`,
  `SysMesNo` (.sdata, message number, <0 = closed; `IntiSystemMes` sets -1).
- .bss vectors (0x10 each): `PaintColor`, `eCurPos`, `eCurNowPos`, `ePartsCurPos`,
  `ePartsCurNowPos`, `ePartsCurRot`, `ePartsCurNowRot`, `PlaceRiverPos`, `RemoveMtnPos`,
  `RemoveMtnCurPos`, `eDirCurRot`, `now_balance_h`; `EditCursor` (0xC), `Font__2` (0xB8, a
  `CFont`: `CFont::SetColor` called on it), `UndoData` (UNDO_DATA).
- .data help strings: `space_str`, `place_str`, ... `repaint_fence_str` are `char *[6]` (0x18,
  indexed by `LanguageCode` 0..5); `onoff_str` is `char *[2][6]` (0x30; index
  `(param == 0) * 6 + lang`, so [0] = OFF, [1] = ON; the help labels name the action offered by the toggle).
- Function-local statics: `cnt_1857/init_1858`, `cnt_1939/init_1940`, `pos_save_1942`;
  `at_2063`/`at_2064` (0x100 each) are copied to 0x100-byte char buffers in `DrawEditHelpMes`.

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

## Native static initialization

Native `CFont Font__2` emits the retail `CFont::Init` call. The generated 12-byte initializer matches exactly.

`StartEditMode` uses the scene's active camera as `mgCCameraFollow` for the
follow settings; the player already inherits `mgCObject`. `EndEditMode` uses
the typed `CEditMap` returned by the active map slot and calls the player's
base position setter directly. Removing those base/derived C-style casts
leaves both functions exact in objdiff.
# `StartEditModeFromMenu` draft

The guarded C++ body has six instruction alignment differences in the two
stores to `PaintCursor2->attr->color[1]` and `[2]`: retail loads the global
cursor before each colour value, while MWCC schedules that load after the
value and delays the attribute load. Named cursor and converted-colour locals
retain the same scheduling. The assembly fallback remains active.

## October 8 merged-base cursor audit

`LoadEditCursor` remains guarded at 270/368 positional differing words
(0x5C0/0x5C0 bytes) under the pinned profile, including editmode's existing
translation-unit row. Its first character construction at +0x170 has the
known allocation-result mismatch: retail branches on `v0` and copies to
`s1` in the delay slot; the draft copies first, branches on `s1` and inserts
a nop. Three character-construction sites shift the later code.

Blocker: placement-new construction scheduling. Reconsider after a natural
inlined character construction with matching null-result flow is validated,
then reassess any float-order remainder. No float selector is proposed:
the constructor blocker prevents the required zero-difference complete-unit
validation. The excluded `EditMode` body and compiler profile are unchanged.

## Mid-day EditMode source-boundary probes (2026-10-08)

The unit retains the LoadEditCursor and EditMode guards. The canonical
source-only baseline is 270/368 and 87/1912 differing words respectively.
The three `mgAngleCmp` calls in EditMode need the binary32 quarter-turn
tolerance (`0x3F490FDB`, 0.7853982f) evaluated first. A private callee-scoped
row reduces EditMode to 74/1912 without changing its `0x1DDC` body, but
does not fix the axis-register allocation or ground-query scheduling.
It is not a complete match and is not added to the production profile.

The documented `mgVu0FBOX` has `max` at +0 and `min` at +0x10. Replacing
the two separate vector locals and their box cast with this complete type,
either preserving or removing the lower-corner alias, emits `0x1DEC`,
exceeding the `0x1DE0` retail extent. The existing draft is retained.
Additional probes under the private angle row give:

| Lower-corner pointer boundary | EditMode result |
|---|---|
| Reuse the pointer for the ground-query copy | `0x1DE4`, oversized |
| Copy directly into the min vector at that site | 77/1912 words |
| Initialize the pointer beside the vectors and reuse it | `0x1DE4`, oversized |
| Initialize it there but retain the later assignment | 84/1912 words |
| Remove unused axis float declarations | 74/1912 words, unchanged |

No source trial improves the retained draft. The relevant angle calls have
direct arguments; the nested CheckHit/GetGeoCheckCamCol expression has no
floating literal argument for the new SF selectors to choose. New nested
selectors therefore do not address this residual. m2c output, snapshots
and word diffs are under `.private/floatsel/editmode/` and the adjacent
unit-prefixed logs. LoadEditCursor construction work is not repeated.

The fresh isolated production probe confirms the 74/1912 private-policy
score and one complete-unit byte problem at `0x002DF805`; no sibling function
changes. Receipt: `.private/floatsel/editmode/mode-best-production/`.
