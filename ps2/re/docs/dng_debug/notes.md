# dng_debug: reverse-engineering notes

Dungeon debug menu ("--== DEBUG MENU ==--"), opened from `DngMainKey` (dng_main) with pad bit
0x400 while `DebugFlag` is set. No first-game equivalent (the first game's debug overlay is in
`dun/gameloop` / `collisiondata.hpp` `DebugInfoCodeId`, a different design).

## Classes
The unit owns no class. `CTreasureBox::Initialize()` (0x1BC6F0) is emitted here as an inline of
`CTreasureBox`, owned by dng_event: it writes byte 0x54 = 0, word 0x50 = 0, word 0x58 = 1.

## Linkage (build/re/local_symbols.tsv)
- Global: `dngGetDebugInfo`, `dngDebugInit`, `dngDebugStart`, `dngDebugDraw`, `dngDebugKey`,
  `DrawDebugWindow`, `dbinfo` -> declared in the header.
- Local (`static` in the .cpp, not in the header): `dngDebugExit()`, `DBGCMD_ReloadEnemy(int,int)`,
  `DrawSystemParamInfo()`, `DrawSystemParamInfo2()`, data `command_str`, `command_int`, `dbFont`.

## dbinfo (0x01ECDCF0, .bss, 0x20) -> `DNG_DEBUG_INFO` (type name NOT retail; neutral)
| Off | Type | Name | Evidence |
|---|---|---|---|
| 0x0 | s16 | active | `sh` in Init(0)/Start(1)/Exit(0); `lh` test in Draw/Key |
| 0x2 | s16 | cursor | `lh`; Key clamps 0..11 (pad 0x4000 down, 0x1000 up); Draw marks line with "->" |
| 0x4 | s16 | command | Start = -1 (0xFFFF); Key sets = cursor (0) on RunEvent; DngMainKey: <0 nothing, ==0 `DBGCMD_RunScript(event_no)` |
| 0x6 | s16 | event_no | Key copies low half of `command_int[0]`; DngMainKey passes it to `DBGCMD_RunScript` |
| 0x8 | s32 | saved_battle_area_unk_8 | Start saves `*(BattleAreaScene+8)` then writes 0xF; Exit restores |
| 0xC | s32 | first_enemy_load | Start = 1; second arg of `DBGCMD_ReloadEnemy`, cleared after; nonzero -> clear effect scripts/heap, re-init CMonsterMan, re-alloc 24 x 4000-byte buffers |
| 0x10 | s32 | sound_flag | Init = 1; <-> command_int entry 8; `BattleAreaBGMCtrl` (dng_event): 0 -> `sndSeStop` |
| 0x14 | s32 | monster_talk | Init 0; <-> entry 9; no reader found |
| 0x18 | s32 | effect_id | Init 0; <-> entry 10; no reader found |
| 0x1C | float | effect_vol | Init 0; Start `fptosi` into entry 11, Exit int->float back |
Field names 0x14..0x1C come from the menu labels of the entries they sync with.

## command_str (0x0033CF70, .data, 0x34 retail size)
`static char *command_str[]`: 12 label pointers (at_871..at_882) + NULL terminator (Draw loops
until NULL). Labels (14 chars, space padded): RunEvent, EnemyLoader, DebugCamera, CharaMove,
EnemyReset, LockOnMode, Information, SkipFloor, Sound Flag, Monster Talk, Effect_id, Effect_Vol
-> enum `DNG_DEBUG_COMMAND` (names not retail).

## command_int (0x0033CFB0, .data, retail size 0x5C)
Pairs {value, minimum} per menu line, indexed `command_int + cursor*8` (+4 = minimum, Key clamps
value up to it). Initial values: [0]=100 (event no), [12]=1 (entry 6 Information), [16]=1
(entry 8 Sound Flag), rest 0. Retail size 0x5C = 23 ints, so entry 11's minimum (offset 0x5C)
is outside the symbol: likely declared as a flat `int command_int[23]` (or `[][2]` cannot give
0x5C). Decide when migrating data. Synced in Start/Exit:
entry 2 <-> `DebugInfo[0]` (mainloop), entry 3 <-> `DebugInfo[1]`, entry 5 <-> s16 at
`BattleAreaScene+0x9E`, entries 8..11 <-> dbinfo 0x10..0x1C.
Entry 6 (Information): `DrawDebugWindow` calls `DrawSystemParamInfo` for 2,
`DrawSystemParamInfo2` for 3.

## dngDebugKey actions (accept = pad 0x20)
- 0 RunEvent: command=0, event_no=value, Exit, return 1.
- 1 EnemyLoader: `DBGCMD_ReloadEnemy(value, first_enemy_load)`; first_enemy_load = 0.
- 4 EnemyReset: virtual slot 0x3C on each of 24 objects (stride 0x70, +0x10) at
  `DngMainScene+0x300C`, `CMonsterMan::Initialize`, `SetBitFlag(0x13D,1)`, Exit, return 1.
- 7 SkipFloor: `GetItem` gate key + key door item for current dungeon/floor, items 0x132, 0x131.
- 8 Sound Flag: value 0 -> `CScene::PauseBGM`, else `RePlayBGM`.
Steps: pad 0x2000/0x8000 +-1, 8/4 +-10 (+-4 on EnemyLoader), 2/1 +-100. Pad 0x400 closes.
Returns 0 when not active, else 1.

## dbFont (0x01ECDC30, .bss, retail size 0xB8; INCLUDE_BSS reserves 0xC0)
`static CFont dbFont`; `__sinit` calls `CFont::Init`; dngDebugInit calls `Init` and
`SetClearance(20,20)`; drawn with `DrawDirect(buf, 16, 72)`. CFont has no constructor call
in `__sinit`, only `Init`.

## Draft and promotion status
All twelve named functions have typed C++ implementations. `command_int` is
treated as a flat integer table with two entries per debug-menu command.
Every function was run through `decompile.sh`; the Ghidra export clarified
the irregular jump table in `dngDebugKey` and the monster target fields in
`DrawSystemParamInfo2`.

`dngGetDebugInfo`, `dngDebugInit`, `dngDebugExit`, and `DrawDebugWindow`
passed linked-image promotion and are active. `CTreasureBox::Initialize`
also compared exactly in the isolated draft, but its single promotion attempt
failed because the header supplied an inline definition. The header now gives
this unit a declaration so the guarded out-of-line draft compiles; a later
matching pass can revisit that promotion. `dngDebugStart` and the other five
large drafts differ from retail and remain behind `NONMATCHING`. The static
initializer draft compiles, but `mwccgap` cannot locate its unmangled local
symbol for promotion. Each symbol had one recorded promotion attempt in
`scripts/re/promotion_attempts.tsv`. The default full build remains byte
identical to retail.

## dngDebugDraw
Reloads texture 0x6C, draws a translucent box (14,70)-(260,332), then prints the list; on
EnemyLoader line prints "[G%d]%s" of the matching `base_monster_define` row (stride 0xB8,
terminated by s16 -1; +2 s16, +4 name) or "[%d]--------", and "BASE > %s" of the row sharing the
s16 at +0x44 when +2 > 0. `base_monster_define`'s row type belongs to the monster unit.
