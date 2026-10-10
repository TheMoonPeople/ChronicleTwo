# scenevillager: header notes

The unit owns no class (`class_units.tsv`). All 35 `CScene` members here belong to `CScene`
(owning unit `scenesnd`) and are declared there, not in `scenevillager.hpp`.
Native definitions now supply every data object; no RODATA or BSS reservations
remain. `CharaObjectOnOff` is the sole guarded function. The native
`GameObjInfo` initializer preserves the four negative-zero Y components in
retail's placement records.

## Local (static) functions and data
Every non-member function and every named datum is LOCAL in retail (`local_symbols.tsv`), so
none is declared in the header; they go `static` in the `.cpp`:
- `GetChrFileSize(unsigned int *pack, int size)` -> `int`: sums the sizes of up to 8 `"mds"`
  files in the pack (`GetPackFileExt`), returns `size + sum*2 + sum/3` rounded up to 0x400.
- `GetObjectNameList(char *list, CCharacter2 *chara, mgCFrame **out, int max)` -> `int`:
  splits a `;`-separated frame name list, `mgCFrame::SearchFrame` on `chara+0x70` (frame root),
  stores found frames; returns count.
- `GetMotionName(int id)` -> `char *`: `motion_name[id]` for `id < 9`, else `motion_name[0]`
  (switch -> jump table `at_1464__4`, cases 1..8, case 0/default load `motion_name[0]`).
- `GetMotionID(char *name)` -> `int`: index in `motion_name` (NULL-terminated) by `strcmp`, -1.
- `SetCharaMotion(CCharacter2 *, int id, int flags)`: name = GetMotionName(id); if id == 4 (sit)
  and `GetKeyListPtr(name, 0) == 0`, name = GetMotionName(0); then vtable+0xB0
  `SetMotion(char *, int)`. Note the asm compares `$a1` after the call (MWCC knows the static
  leaf GetMotionName leaves `$a1` intact), i.e. source compares the `id` parameter.
- `motion_name` (.data 0x359A20, 0x28 = `char *[10]`, 9 Shift-JIS names + NULL): 立ち 歩き 走り
  会話 座り カメラ入り カメラ カメラ戻り 特別 -> `VILLAGER_MOTION`. vlgr_info's
  `vpiGetMotionID` maps script motion names to the same ids (0,1,2,4,8).
- `GameObjInfo` (.data 0x359A50, 0xB40 = `GAMEOBJ_INFO[36]`, last row `map_no = -1`).
- `at_868__4` (float[4] {255,255,255,128}, light colour clamp in GetCharaLighting),
  `at_991__4` / `at_992__3` (float[4] {0,-10,0,0} / {0,1,0,0}, drop-shadow vectors) and
  `at_988__3` (.bss 0x10) are compiler-generated function-local statics.

## GAMEOBJ_INFO (0x50) / GAMEOBJ_PLACE (0x10)
Name of the row type is not in retail; named after the table. Stride 0x50 (`piVar += 0x14`) in
LoadGameObject/GetGameObjectEvent/DrawGameObject; 0xB40/0x50 = 36 rows.
- +0x0 map_no: compared with `LoadGameObject` arg / `GetMainMapNo()`; `< 0` ends the loop.
- +0x4 type: 1, 2, 3 (see below). +0x8 place_num: loop bound (1..4; map 10 has 4).
- +0xC: always 0 in the table, never read.
- +0x10 + i*0x10: x,y,z floats (copied to a vector with w=1.0) and rot_y (passed as Y of
  `SetRotation(0, ry, 0)`, vtable+0x20; values within +-pi). DrawGameObject raises y by 60 for
  types 1/2.
  `DrawGameObject` indexes `place[i]` directly for its two vector copies and rotation arguments.
  Avoiding a retained pointer to the placement subobject reproduces the full 604-byte PAL
  function, including relocations: the common base holds the entry plus the array-index
  displacement, and member offsets remain in the loads.

## GAMEOBJ_TYPE (LoadGameObject)
- 1: `effect/tg_maru_red.chr` -> slot 0x78, `effect/tg_sita_red.chr` -> slot 0x79.
- 2: `effect/tg_maru_blue.chr` -> 0x78, `effect/tg_sita_blue.chr` -> 0x79.
- 3: `effect/savepoint.chr` -> 0x7A, `effect/book.chr` -> 0x7B.
Types 1/2 are skipped when `GetGameChapter(*(this+0x3040)+0x1A08) == 8`. Types 1/2 occur only on
maps 0/25, 1/26, 2/82, 3/102 (pairs, 1 then 2). Meaning of "tg" unknown; names kept neutral.
GetGameObjectEvent returns slot 0x78 (types 1/2) or 0x7A (type 3, also stores place index in
`CSceneEventData::gameobj_no` +0xC8) when within 20.0 of a place; writes position at +0x30.

## SCENE_CHARA_STATUS (bits of `GetStatus(1, slot)`)
- 0x08: CheckDrawCharaShadow false; StepVillager sets it when villager place info `+0x30` != 0.
- 0x10: CheckDrawChara and CheckDrawCharaShadow false.
- 0x20: DrawExclamationMark draws the mark (slots 0..0x7F).
- 0x40: DrawChara skips mgGetLight/GetCharaLighting/mgSetLight and the map func-point lights.
- 0x80: DrawChara calls `SetFadeFlag(0)` (vt+0xC4) around DrawDirect, restoring `GetFadeFlag()`
  (vt+0xC8).
- 0x100: DrawChara sets `SetNearDist(-1)` (vt+0x64) / `SetFarDist(-1)` (vt+0x5C) around the draw,
  restoring `GetNearDist` (vt+0x68) / `GetFarDist` (vt+0x60).
- 0x200: CheckDrawChara false (shadow still drawn).
Bits 1/2/4 are SCENE_DATA_STATUS (scene.hpp). If `scenesnd` declares these bits too, merge.

## Slots and stacks (SCENE_VILLAGER_SLOT / SCENE_VILLAGER_STACK)
- Villagers: slots 8..0x17 (DeleteVillager loop 16, stack 2, `this+0x3E60` = time stamp).
- Sub villagers: 0x18..0x1F (DeleteSubVillager loop 8, stack 4, `this+0x3E64`).
- SearchCharaTexb/SearchCopyModel scan 8..0x1F; SearchCharaID/GetTalkEvent/InScreenChara scan
  8..0x3F; SetActiveVillager resets slots < 0x18 when `this+0x2E5C` != 0.

## For the CScene owner (scenesnd)
- `CScene::InScreenCharaInfo` (nested, size 0xC; EditDraw allocates 3 words): +0 s32 chara_no
  (`GetCharaNo(slot)`), +4 float distance minus 10, +8 s32 nonzero when the character is within
  the inner +-10 screen box.
- CScene offsets used here: 0x38 mgCMemory* (scratch for collision polys), 0x3C `unsigned int *`
  load buffer, 0x2E5C int (game objects/villagers suppressed), 0x2F6C float game time
  (`CheckTime(t, 21.0, 6.0)` -> night), 0x2F78 float wind power, 0x2F80 float[4] wind dir,
  0x3038/0x303C ints (skip-load latches for LoadVillager/LoadSubVillager), 0x3040 pointer
  (+0x1A08 chapter/map int, +0x1D2A0 `CUserDataManager`), 0x3050 `CVillagerMngr` by value
  (0x3050 first int read as "busy" in StayNearVillager, 0x3054 data count), 0x3E60/0x3E64,
  0xA498 copied to `CCharacter2+0x57C` in StepChara.
- `PreLoadVillager__6CSceneFiP1`: `int PreLoadVillager(int map, u_long128 *cache)` (P1 =
  `u_long128 *`, as in `InitFileCache__FP1i`).

## Other units' types seen
- `CVillagerPlaceInfo` (villagermngr): 0x40 bytes (`RegisterVillager(int,int,mgCMemory*)`
  memsets 0x40, sets +0x20 = -1, +0x0 position via GetPosition, +0xC = rotation Y).
- `CVillagerMngr` data (GetData): +0 slot, +4 (<0 unused), +0x14 info ptr (+0x24 stay motion,
  +0x28 motion to replace, +0x30 no-shadow, +0x34 snap to ground), +0x20, +0x2C stay count,
  +0x30 pending motion (-1), +0x34 current motion id, +0x38 motion flags, +0x3C, +0x40 hand
  mode (1/2 toggles hand_R/hand_L vs v_R/v_L frames when +4 == 0xE), +0x50 pos, +0x60 rot.
- `GetVillagerInfo(int)` (vlgr_info): +4 model name, +0xC frames to set attr 1, +0x10 frames to
  set attr 2 (`mgCFrameAttr+0x18`).

## CharaObjectOnOff
The scene looks up the named frames in a villager's show and hide lists. It allocates an
`mgCFrameAttr` when a frame lacks one, then sets `draw` to 1 for show or 2 for hide. The guarded C++
draft scored 97.59% against retail; the matching build selects its
`INCLUDE_ASM` gap. In the hide loop, retail branches on the
placement-new result in `v0` while moving it to `a0` in the delay slot; MWCC moves it first,
branches on `a0`, and emits a nop. Assigning the constructed attribute directly to the frame
adds a reload and lowers the score to 93.66%.
- GetTalkEvent memsets a local `CSceneEventData` (0xD0) and writes `+0x8 = slot-8`,
  `chara_no`, `chara_slot` into the caller's.
- No first-game counterpart for these types was identified.

## Compiler calibration checkpoint

`./decompile.sh GetNowVillagerTime__6CSceneFv` confirms that the result is
`CheckTime(time, 21.0f, 6.0f) != 0`. The retail compiler materializes 6
before 21. An LLDB snapshot at the MWCC 3.0 argument reader 0x4A4AE3 found
both propagated locals remain kind-0x33 floating nodes with their original
IEEE payload; 6's evaluation byte was uninitialized and nonzero while
21's was zero. Initializer-only selectors did not control the fresh nodes.
The consumer hook's binary32 evaluate-first selector for 6 (`0x40C00000`)
now reproduces all instruction and relocation bytes. Whole-unit checks
retain only the existing CharaObjectOnOff allocation constructor problems.
`DrawGameObject` remains an exact native 604-byte function after the typed
indexed-place change. No source workaround was introduced for time checking.
