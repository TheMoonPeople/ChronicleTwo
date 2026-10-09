# editloop: reverse-engineering notes

## Current source status

`EditInit` and `EditLoop` retain typed C++ drafts under `NONMATCHING`; the
matching build selects their `INCLUDE_ASM` gaps. `EditDraw` is native matched
C++; [night-20261008.md](night-20261008.md) records its promotion. Earlier
active versions changed the unit's code and data layout and failed the object
check. `CameraCtrlParam::operator=` at 0x1ACEE0 is currently an
`INCLUDE_ASM` gap. Its compiler-generated copy matches in an isolated caller,
but the active unit lacks a natural emission site while `EditInit` remains
guarded; the historical mid-day explicit-member promotion below is superseded.
The other game functions remain native C++ where the base source already matched.

The town main-loop mode (walking and Georama editing). `LoopInit/LoopMain/LoopExit` in mainloop
hold `EditInit`, `EditLoop`, `EditExit`. No class is owned by this unit (`class_units.tsv`).
`gp = 0x3846F0` (e.g. `LockChara` 0x37D314 is `-0x73DC($gp)`).

## Classes emitted here but owned elsewhere
- `CameraCtrlParam::operator=` (0x1ACEE0): owned by cameracontrol; caller `CCameraControl::CCameraControl`.
- `CActionChara::CActionChara()` (0x1ACF40): owned by actionchara; caller `InitDungeonMain` (dng_main).
  Both retail bodies remain assembly gaps in this unit. `CameraCtrlParam`
  has an optional retail-assignment declaration in `cameracontrol.hpp`;
  the `CActionChara` constructor is defined in `actionchara.hpp`.

## INIT_LOOP_ARG (declared in mainloop.hpp)
- Used by mainloop (`NextLoop(int, INIT_LOOP_ARG)`), title, dng_main, the viewers. The complete
  definition is in `mainloop.hpp`.
- Size 0x50: `EditInit` copies it as 10 doublewords; `EditLoop` `memset`s a 0x50 local before `NextLoop`.
- Offsets used by `EditInit`: `0x00` int map number (passed to `GetMapName`; `< 0` loads sound set 0);
  `0x48` int event number (`< 1` replaced by 100, then `RunEvent`).
- `EditLoop` (menu result 6, leaving to another loop) writes `0x00 = MenuInfo+0x44`,
  `0x44 = MenuInfo+0x48`, `0x48 = 0x3F2`.

## Functions: visibility and returns
Local (static, keep in .cpp): `GetUserData` (retail `GetUserData__Fv`, `__2` suffix in our
symbols; returns `GetSaveData() + 0x1D2A0`, i.e. the `CUserDataManager` inside the save data, or 0),
`InitLockCharaCtrl`, `LockCharaCtrl`, `UnLockCharaCtrl` (counter `LockChara`, clamped at 0),
`InitEditModeChg`, `NowEditModeChg` (int), `EditModeChg(int event)` (sets `EditModeChgEvent`,
`EditModeChgCnt = 30`, locks), `EditModeChgStep(CScene*)` (counts down; then runs event
`EditModeChgEvent` if scene+0x2E88 == 0 and event > 0), `PreExitLoop(CScene*)`, `InitSubMapLoadStep`,
`SubMapLoadStep` (int: 1 while loading), `InitEditEvent`, `ResetEditEvent`, `RestartEditEvent`,
`UpdateTrBoxFlag(int map)`, `editLoadSound(int map)`, `LoadComVillaager` (empty), `LoadMap`.

Global (in header): `IsEditMode` int, `SetDataPacket(int mode)` void (global in retail, no outside callers), `EditInit` void, `EditExit` void, `EditLoop` int (true when
leaving through `NextLoop` or `TimeLimitCheck`), `EditStep` int (0 = event start waiting on camera,
else 1), `EditDraw` int (always 0, asm ends `daddu $2,$0,$0`), `BurnEditParts` int (0 if bit flag
0x208 set, main map != 3 or no map; else 1; `CEditMap::RemoveInfo` local 0x494 bytes),
`EditMapJump(int map_no)` int (maps 11..14 load as map 10 with sub map; 0 on unknown map/load info),
`EditGotoInterior(int map_no, int delete_villager)` int 1, `EditExitInterior(int)` int 1 (argument
never read), `EditDataSave`/`EditDataLoad` void, `KeepEditAnalyze` void, `EditAnalyzeChanged` int.

**SetDataPacket(int)** modes: 0 = initial packet buffers (`init_dbuf`),
1 = normal map (0x11170 qwords per half), 2 = map type 1 (0x1C138 qwords). `DataPktMode` holds the
last mode.

## Enums (header)
- `EditLoopMode` (`LoopMode`, local .sbss 0x37D2F4): 1 walk; 2 Georama edit (`StartEditMode`,
  `CheckWalkToEdit`); 3 menu opened from walk (exit -> 1); 4 edit, waiting up to 0x18 frames
  (`PreEditMenuCnt`) for `EditPreMenuAnime` before opening the menu (-> 5); 5 menu opened from edit
  (exit -> 2 via `StartEditModeFromMenu`); 6 wait for `ReadBGSync() == 0` then 1.
  `IsEditMode` returns 1 for 2 and 4.
- `EditControlMode` (`ControlMode`, 0x37D2F8): 1 player; 2 event running (`RunEvent > 0`,
  `CheckEventSkip`); 3 debug event editor (`ChkEventEditStart`, `EventEdit(&WorkBuffer)`);
  4 debug edit (`EditDebugStart`, `EditDebugLoop`; previous mode kept in `old_cm_1772`).

## Globals
Global (header): `read_buffer_end` u_long128* (= `read_buffer + 200000` qwords, +0x30D400 bytes;
used by `CScene::PreLoadVillager`), `EventMes1` ClsMes (0x2958, constructed in `__sinit`), and
`ScriptBuffer` mgCMemory (0x30; our symbol `ScriptBuffer__2`; also used by event's `EventLoop`;
mapjump has a different, LOCAL `ScriptBuffer` pointer at 0x37E568 -- do not include both names in
one TU).
All other named data is local (static in .cpp): .sbss ints/pointers 0x37D2C0..0x37D38C
(`MainScene` = CScene*, `Camera`/`EventCamera`/`FixCamera`/`EditCamera`, `MapNo`, `WalkChara`,
`LockChara`, `EditModeChg*`, function-local statics `*_14xx`..`init_2409`), `MenuInfo`
(pointer to a MENU_INIT_ARG; fields +0x18 scene, +0x28, +0x2C..+0x38, +0x3C menu result,
+0x40/+0x44/+0x48, +0x58), `DataPktMode`; .bss: `WaveTable` (0x1208), `CharaOldPos` (0x10),
`buf0`/`buf1` and the many 0x30 `mgCMemory` buffers (`WorkBuffer`, `MenuBuffer`, `ChrEffBuffer`,
`TotalDataBuff`, `ControlCharaBuff`, `MainDataBuff`, `MainCharaBuff`, `SubDataBuff`, `SubCharaBuff`,
`FishingBuff`, `SkyBuff`), `data_buf`/`init_dbuf` (2 x mgCMemory), `EventBuff` (4), `CharaBufs` (8),
`EditEvent` (CEditEvent, 0x150; +0x4 state, 1 = running; +0x148 door SE id), `EdDebugInfo`
(EditDebugInfo, 0x3C), `TestVisual` (0x50), `TestFrame` (0x110), `beforeAnalyze` (int[16]).

`CameraCtrlParam::operator=` copies ten float limits and the integer `no_check`
field. `cameracontrol.hpp` leaves assignment implicit for users that do not
select its retail-assignment declaration switch.

## October 8 natural small-member audit

The existing class definitions reproduce both small members naturally:
implicit `CameraCtrlParam::operator=` matches all 24 words when emitted from
an isolated assignment caller, and `CActionChara::CActionChara()` matches all
48 words when emitted as a natural array-constructor callback. Neither
needs a shared-header change. The assignment copies ten floats and the
integer `no_check`; this corrects the earlier description of eleven scalar
limits plus the flag.

Their actual editloop uses are in the guarded `EditInit`. With that caller
excluded from this lane, neither member has an admissible independent
emission site in the active unit. Keep the assembly entries; do not add
artificial globals, callers or member-address objects to force emission.
The all-drafts diagnostic cannot compile the excluded large drafts because
several scene/map member names are stale; those bodies were not changed.

Blocker: natural member emission depends on a guarded caller. Reconsider
when `EditInit`'s owning lane restores its verified native assignment and
character-array construction.


## October 8 mid-day parameter assignment promotion (superseded)

This records a historical explicit-member trial. The current unit retains
the assembly gap and relies on natural compiler emission when the owning
`EditInit` caller can be promoted.

`CameraCtrlParam::operator=` at `0x1ACEE0` is now a native member definition.
It copies the ten float limits and the integer `no_check`, and returns the
destination by reference. The existing `CAMERA_CONTROL_USE_RETAIL_ASSIGNMENT`
header switch declares this real retail member, using the same include pattern
as `cameracontrol.cpp`; no shared header or artificial caller is needed.
The earlier small-member audit established the fields and the 24-word copy.
The explicit member definition reproduces those 24 words and its complete
object passes (0x6D9C allocated bytes, 2,067 relocations).

Baseline and promotion verification both report 147/149 passing game units.
The failures remain `nd_meswin/DrawMesWin` and `actscript/_SHOT`; the PAL
verifier still differs by exactly 0x26 bytes in `.text`, with every other
file-backed section and the memory-end check passing. All 148 other game
object file hashes are unchanged. Coverage increases from 6,686 to 6,687
matched functions; this is one actual assembly-gap removal.

Private receipts: `.private/editloop-midday/assignment-only-full/check.log`,
`assignment-build.log`, `assignment-objects.log`,
`assignment-object-hash-diff.json`, and `assignment-coverage.txt`.

The `CActionChara` constructor still needs the guarded `EditInit` array
construction as its natural emission site. No synthetic construction site
has been introduced.

## October 8 mid-day guarded reconstruction audit

These probes use MWCC 3.0-011126, canonical flags and the checked-in Satan's
Fiddle profile. Each large function is selected independently in a private
source copy; none has been promoted. The native-word comparisons mask
relocated operands and include the declared retail extent's zero padding.
Complete-object checks are still required before any guard can be removed.

### EditInit

The retained draft compiles and differs by 1,261/1,776 words, with a
0x1B28-byte body against the 0x1BC0 extent. The first field-corrected probe
differed by 1,681 words and emitted 0x1B9C bytes. The native array-constructor
callback also emits `CActionChara::CActionChara()` exactly: 48 words at its
0xC0 retail extent. That callback remains unavailable to the active build
while `EditInit` is guarded.

The initialization partitions the main stack into packet, script, town-data,
menu/read and work buffers. Its `data_size` is the free quadword count before
the 210,128-quadword reservation; the reservation is subtracted at the three
consumption sites. The packet/menu allocation results are both stored in
their globals and passed directly to the consuming calls. A texture-manager
pointer survives from table setup through the later image registrations.

The MDT builder creates a billboard test model, then loads the treasure-box
model, cursor, effects, message images and scene data. Material and image-path
initializers belong at their use sites. The load descriptor is 0x40 bytes;
the scene/map dependencies use their current composed layouts:

| Dependency | Established layout or field |
|---|---|
| `CameraCtrlParam` | 0x2C; ten floats followed by `no_check` |
| `CActionChara` | 0x1030; array callback uses the header constructor |
| `CMapTreasureBox` | 0x680; `CCharacter2` base, reset by `Initialize` |
| `CMap` / `CMapInfo` | 0xD10 / 0x100; player placement is `map_info.chara_pos` |
| `CScene` | texture assignment uses `tex_block_base` and `tex_block_count` |
| `BGM_INFO` | active volume uses `master_volf` |
| `NowLoadingInfo` | texture block, `unk_4`, then step count are assigned in that order |
| `mgFrameAttr` | billboard alpha is set before the RGB components |

Retail expands the complete `CMapTreasureBox` constructor chain at its
placement-new call. The current shared header only declares that constructor,
and `map.cpp` defines it out of line. A private inline-definition diagnostic
restores the omitted base initialization; depth four emits 0x1BA8 bytes and
1,182 differing words, while deeper expansion emits 0x1BBC bytes. These are
dependency diagnostics, not eligible source results. The exact proposed
constructor relocation is `.private/proposals/inline-map-treasure-box.patch`;
it has not been applied and needs whole-object checks for every consumer.

The retail epilogue writes the incoming, otherwise unassigned saved `s4`
value to both debug fishing-item fields. m2c identifies it as a saved incoming
register. The uninitialized `fishing_item` local represents an indeterminate source
value and retains its compiler warning; the native register allocation does
not yet reproduce the saved incoming `s4` value. Giving it a fabricated
default would also change the executable. Other unresolved differences involve saved-register
allocation, BGM scene-pointer lifetimes, allocation argument order and water
size rounding. Pointer induction and broad inline-depth changes did not
produce a compliant match.

Receipts: `.private/editloop-midday/EditInit.m2c.cpp`, `init-fields/`,
`init-saved/{compile.log,compare.log,diff.txt}` and
`init-inline-chest-compile/aligned.txt`.

### EditLoop

The stale `time_map->time_cfade` access belongs to
`time_map->map_info.time_cfade`. Correcting it makes the selected draft compile:
1,180/2,228 words differ, with a 0x22C8 body in the 0x22D0 extent. The time
controls step scene time, compare the map's light band, and start a captured
crossfade when that map setting permits it. Submap loading waits at the
observed town transition lines, then the mode/control switches dispatch
walking, Georama, menus, events and debug control.

The original named jump table is not recognized by m2c as a table. A private
input copy gives it a `jtbl_` label and appends the unchanged table entries as
retail `.L` targets; `decompile.sh` then produces the complete reconstruction.
No instruction or tracked assembly was changed.

Early differences swap the light/wait flags and light-band/submap values
between `s1` and `s2`. Later differences include menu dispatch, pause-argument
initialization, floating render arguments and scene-event copying. Boolean
flag types, narrower light-band scope and earlier event-data construction do
not improve the retained draft. Replacing the menu switch with an if chain
gives 1,493 words; aggregate pause initialization also exceeds the retail
extent. Neither variant is retained.

Receipts: `.private/editloop-midday/EditLoop__Fv.tables.m2c.cpp`,
`loop-fields/{compile.log,compare.log,diff.txt,aligned.txt}` and
`loop-lifetimes.log`.

### EditDraw

The unchanged guarded draft differs by 6/860 words, with a 0xD6C body in the
0xD70 extent. Those six words swap the count and induction registers in the
first texture-group loop. All scene drawing, river/water work, depth of field,
photography, system overlays and message-window calls otherwise compare at
their retail offsets.

The draft contains a pre-existing `Ident` wrapper in the later texture loop.
That wrapper is not an admissible new matching technique. Removing it gives
12 words; a source-only loop-variable variation reaches eight words, still
without a match. Count scoping, shared induction variables, do/while loops,
combined for initializers and global optimization do not recover both loop
allocations. No drawing promotion or new helper is included in this lane.

Receipts: `.private/editloop-midday/EditDraw__Fv.m2c.cpp`,
`draw-original/{compile.log,compare.log,diff.txt}`, `draw-clean-counts.log`,
`draw-do-loops.log` and `draw-for-initializers.log`.

### Build preservation

The guarded reconstruction changes leave the active executable at the same
147/149 object passes and 0x26 `.text` byte differences. Relative to the lane
base, only `editloop.cpp.o` changes, through the promoted camera assignment;
all 148 other object hashes are identical. The guarded edits themselves do
not change either owned object's allocated content.

Receipts: `.private/editloop-midday/guarded-drafts-build.log`,
`guarded-drafts-objects.log` and `guarded-drafts-object-hash-diff.json`.

### `CameraCtrlParam::operator=` stays assembly-backed

A hand-written `operator=` reproduces all 24 words of `__as__15CameraCtrlParamFRC15CameraCtrlParam`,
but retail gives that symbol the processor-specific binding 13 of a compiler-generated copy assignment
(`readelf -s` on SCES_511.90), while the hand-written definition is `GLOBAL`. `docs/MWCC.md` ("Natural
C++ definitions") rules out hand-writing generated assignments, so the function stays `INCLUDE_ASM`
until the implicit assignment is emitted naturally from its genuine caller (`EditInit`).

## October 8 mid-day round 1

The round starts at `98f90fd49612bf69d6ac32926438162661cce4bb`, including
upstream `d8bf13c` and a hand-written camera-parameter assignment that was
later returned to assembly (see above). The fresh baseline has 147/149
passing game objects, 6,687 matched functions and the
known 0x26-byte PAL `.text` discrepancy. All experiments use the pinned
`chronicletwo_dev:sf-d8bf13c` image and the canonical profile. No replacement
assembly or compiler-profile row is introduced.

### Texture-group drawing

`EditDraw` now contains no `Ident` definition or call. Its retained natural
C++ body differs by 8/860 words and occupies 0xD6C bytes in the 0xD70 retail
extent. The six-word result described in the previous audit requires the
removed identity helper and is not the accepted source baseline.

`CMdsListSet::GetTextureBlockNo` supplies a signed count and writes at most
128 integer block numbers. The map groups 0..5 traverse that list backwards;
the groups 6..15 traverse it forwards. In the reverse loop, the address of
the current array element survives the reload call so the water-block test
reloads that element, while `mgEndDraw` receives the cached block number.
The first loop reuses the existing count/index locals; the later loop keeps
its own induction variable. The previously measured helper-free eight-word
form is now retained in the guarded source.

Raw-word offsets of the remaining differences are +0x428, +0x42C, +0x6EC,
+0x6F0, +0x6FC, +0x700, +0x724 and +0x72C. At both count acquisitions, retail
checks `v0` before copying it to `s3`; native copies before checking the
saved register. The forward loop additionally exchanges the count and its
array induction between `s3` and `s4`. Every other instruction word compares.

New probes cover count acquisition in the loop initializer or condition,
assignment conditions with do/while bodies, array references and typed
iterators, direct model-list references, reverse-index expression order,
remaining-count induction, shared count/index lifetimes, scoped cached block
values, unsigned or wider induction, a short water-block value, and buffer
capacity expressed through `sizeof` or a named constant. None improves the
retained eight-word form. Pointer induction gives 19 or 37 words; a separate
later count gives 10. Several type/control variants exceed the retail extent.
The exact probe scores, including excess words, are in the private ledger;
these trials should not be repeated without a new source hypothesis.

The complete wrapper/fixup check of the helper-free draft also fails only
`EditDraw`, first at retail 0x1AFC28. The function stayed guarded until the
promotion in [night-20261008.md](night-20261008.md). Receipts:
`.private/editloop-r1/draw-base-full/{check.log,diff.txt}`,
`retained-draw/{compare.log,diff.txt}`, `draw-new-shapes.log`,
`draw-induction.log`, `draw-count-lifetimes.log`,
`draw-result-conditions.log` and `trial-ledger.tsv`.

### Initialization regions

The retained `EditInit` improves from 1,261/1,776 to 1,239/1,776 differing
words, with a 0x1B2C native body against the 0x1BC0 retail extent.

Writing the billboard's RGB components before its alpha reproduces the
whole instruction sequence at +0x6D8..+0x70C. This includes the early 255.0f
materialization, billboard/no-light stores, the 128.0f alpha and the three
RGB stores around `SetAttrParam`. Chained assignments and a named colour
constant retain the original score; moving RGB ahead of all flags leaves
four stores in the wrong order. RGB followed by alpha is the retained form.

The water image is allocated in quadwords rounded up for a partial final
quadword. Retail tests the low four file-size bits, shifts the unsigned
byte size in the branch delay slot and recomputes that shift in the rounding
branch. Separate rounded/unrounded assignments preserve both shifts;
incrementing a precomputed count removes the second one. The equivalent
ternary also gives the 1,250-word isolated result. A size snapshot and a
cached full-quadword count do not improve the original draft. Combining the
explicit branch with the corrected billboard setup gives the retained
1,239-word result.

Retail also retains one `CScene*` across both `GetActiveBgmInfo` calls and
`SetVolfBGM`. A local scene snapshot gives 1,251 words alone and 1,240 with
the billboard change; adding it to both retained changes gives 1,252 words.
That alternate is recorded but not retained in the best word-comparison
body. Its master multiplier is `BGM_INFO::master_volf` at +0xC, and the
current volume is `volf` at +0x14, as the existing sound declarations specify.

The out-of-line `CMapTreasureBox` constructor still prevents retail's inline
constructor chain at +0x774 onwards. The prior shared-file proposal remains
unapplied. The first 0x748 bytes now compare word-for-word; the branch at
+0x748 differs because its destination follows that missing constructor
expansion. Later differences include allocation/call argument scheduling
and scene lifetimes. The uninitialized fishing-item local remains guarded;
its native stores currently use `s2`, whereas retail stores the unassigned
incoming `s4`. Keeping that source local is not yet a machine-register match
and does not justify promoting the function.

Receipts: `.private/editloop-r1/EditInit.m2c.cpp`, `init-regions.log`,
`init-region-combinations.log`, `init-exact-attributes.log`,
`retained-init/{compare.log,diff-with-zeros.txt}` and
`attempt-word-metrics.json`.

### Validation

The final active build remains at 147/149 object passes. Only the existing
`nd_meswin/DrawMesWin` and `actscript/_SHOT` checks fail. PAL `.text` still
has exactly 0x26 differing bytes, every other file-backed section passes and
memory ends at 0x1F64A00. All 149 game object file hashes are identical to
the fresh baseline. Coverage remains 6,687 matched functions; no function
is promoted in this round.

Receipts under `.private/editloop-r1/`: `baseline-build.log`,
`baseline-objects.log`, `final-build.log`, `final-objects.log`,
`final-object-hash-diff.json`, `final-coverage.txt` and
`retained-drafts.log`. The existing shared constructor, rectangle-assignment
and fatigue proposals are not applied.
