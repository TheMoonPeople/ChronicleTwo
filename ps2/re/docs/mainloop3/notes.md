# mainloop3 notes

Unit owns no classes (`class_units.tsv` has no row for it). The header declares 4 global
functions and 3 enums. Every data symbol of the unit is LOCAL in retail
(`local_symbols.tsv`), so the header has no `extern`s; all globals belong in the `.cpp` as
`static`.

## Functions
| Symbol | Signature | Evidence |
|---|---|---|
| `FutureMapSelect__Fv` | `int FutureMapSelect()` | returns 0/1/2; EventSelect (mainloop) tests ==0, ==1, ==2 (2 clears `future_sel`) |
| `InitHDDMenu__FP1` | `void InitHDDMenu(u_long128 *work)` | `P1` is `u_long128*` (same as `__nw__FUiP1`, `InitFileCache__FP1i`); caller passes `base + n*0x10`; stored to `inst_work`, later passed to `CreateInstallThread__FP1i` |
| `HDDMenuLoop__Fv` | `int HDDMenuLoop()` | returns 0, or 1 on Cross (0x40); EventSelect does `if (r) return r > 0;` |
| `EmergencyMessage__Fi` | `int EmergencyMessage(int error)` | registered via `SetIoErrCallBack(int (*)(int))` in MainLoop; returns 0 |
| `__sinit_mainloop3_cpp` | static init | calls `mgCMemory::Init()` on the five 0x30-byte bss `mgCMemory` objects |

Functions called from other units: `HddConectCheck(int*)`, `CheckAppInstall()`,
`CheckInstallSpace()`, `CreateInstallThread(u_long128*, int)` (the call delay slot
loads `0xA0000` as the work-buffer size), `StepInstallThread`, `DeleteInstallThread`, `InstallCancel`, `InstallPause`,
`GetInstallProgress` (float, converted to int), `UninstallApp` (unit `hddinstall`, no header
yet); `GetMainFileDev`, `ChangeDefaultFile`, `ChangeHddFile` (dataread.hpp; compare with
`FILE_DEV_HDD` = 3).

## Enums (header)
- `FutureMapSelectResult`: 0 continue, 1 chosen (NextLoop called), 2 closed (Cross 0x40).
- `HDDMenuResult`: 0 continue, 1 closed (Cross).
- `HDDMenuItem` (`sel_hdd`): 0 "%sUninstall", 1 "%sInstall", 2 "%sHDD Mount"/"%sHDD Unmount"
  (Unmount text when `GetMainFileDev() == FILE_DEV_HDD`). Clamped to 0..2; InitHDDMenu sets 1.
- Pad bits used (`PadButton` in `gamepad.hpp`): L1/R1 change map, Right/Left change map
  when on the map row, Down/Up move the row, Circle toggles a flag or chooses, Triangle
  chooses with arg word 0x48 = 100, Cross closes. `GamePad__2` is mainloop's CGamePad.

## Globals (all static)
- FutureMapSelect function-local statics: `select_795` (int, cursor row: 0 = map line,
  n = analyze entry n-1) with guard `init_796`; `sel_map_798` (int, 0..3 index into the map
  table) with guard `init_799`.
- `at_801__5` (.data, 0x10): local `int[4]` map-id table {0x19, 0x1A, 0x52, 0x66}, copied to
  the stack; passed to `GetMapTitle` and stored as `INIT_LOOP_ARG` word 0.
- `.sdata` `char*[2]` local arrays (indexed by a bool): `at_804` {"  ", ">>"} cursor,
  `at_806` {"  ", "->"}, `at_808` {"  ", "<-"}, `at_811` {"X", "O"} flag; HDDMenuLoop:
  `at_883` {"disconnect", "connect"}, `at_884` {"  ", ">>"}.
- Strings: `at_870` "未来マップ選択\n" (Shift-JIS), "%smap  %s %s %s\n", "%s %s:%s\n", "\n";
  HDD menu: "HDD Debug Menu\n", "HDD       :%s\n", "Install   :", "O\n", "X\n", "Err %d\n",
  "Free      :", "%d%%\n", "\nerr code = %d\n".
- HDD menu state (`.sbss`, int): `HddConnect` (>0 connected), `AppInstall` and `FreeSpace`
  (>0 O, 0 X, <0 "Err %d"), `sel_hdd` (HDDMenuItem), `now_install` (bool, install thread
  running), `error_code` (last result), `inst_work` (`u_long128*`, installer memory).
- EmergencyMessage: `emergency_mes` (`char*[2]`, indexed by `LanguageCode` when 0..1:
  Japanese HDD repair text / "error."), function-local `col_962` (int, counts 0..99, guard
  `init_963`), `txt_965` (`char*`, text drawn).
- `buf0__2`, `buf1__2`, `dbuf0`, `dbuf1`, `Stack__2` (.bss, 0x30 each): static `mgCMemory`
  objects (retail local names `buf0`, `buf1`, `dbuf0`, `dbuf1`, `Stack`). Given 10000,
  10000, 50000, 50000, 500000 bytes from the main stack; packet buffers, data buffers, and
  texture-table stack.

## EmergencyMessage behaviour
Acts only for `error == -5 || error == -0x10005` (I/O error codes; no enum found for them).
Then: `mgWaitFrame`, `sndSeAllStop(-1)`, resets the main stack (`GetMainStack()` fields at
0x1C and 0x24 set to 0), rebuilds VIF1 packet / data buffers, texture table (100, 0x14),
reloads gaiji/font textures, then loops forever drawing `txt_965` at (20, 100) with the
debug font.

## FutureMapSelect `INIT_LOOP_ARG`
`memset(&arg, 0, 0x50)`; word 0 = map id; word at 0x44 = 0; word at 0x48 = 99, or 100 when
pad 0x10 is down. Passed by value to `NextLoop(1, arg)`. Layout belongs to mainloop's header.

## First game
No counterpart found in `/home/adubbz/development/chronicle` (HDD install is new here).

## Draft and promotion status
All four remaining functions have named C++ drafts under `NONMATCHING`. The default
build retains their retail assembly. `FutureMapSelect`, `HDDMenuLoop`, and
`EmergencyMessage` compile but differ from retail by 227/284, 255/284, and
159/176 words respectively in the isolated draft comparison. Each had one
promotion attempt and remained guarded. `HDDMenuLoop` also generated a different
literal at `0x003791C0` during its promotion attempt; its title spelling was
corrected afterward. The initializer draft compiles, but `mwccgap` could not find
the unmangled local `__sinit_mainloop3_cpp` symbol for its isolated promotion.
It remains guarded. The promotion attempts are recorded in
`scripts/re/promotion_attempts.tsv`.
