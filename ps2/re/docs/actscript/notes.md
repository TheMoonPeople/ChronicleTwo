# actscript: notes

Action-script (player, ridepod, monster `CActionChara`) external functions `_XXX(RS_STACKDATA *, int)`,
their argument helpers, gun/magic shot helpers, and the action external-function table. Same shape
as `runscript_opcodes` (monster scripts) and `event_func`; see `ps2/re/docs/runscript_opcodes/notes.md`
for the shared helper semantics. No first-game counterpart unit (the first game has no
`CActionChara`).

## Owned types
`class_units.tsv` lists no class owned by actscript. VM types come from `runscript.hpp`; the table
row type `RS_EXTFUNC_INFO` is already declared in `runscript_opcodes.hpp` (include it in the .cpp).

- `ACTION_INFO` (0x10, **name not retail**): type of global `action_info` (0x1F3D170, .bss, size
  0x10 from main.symbols.txt). Evidence (all absolute `%lo(action_info + n)` accesses in the
  binary; the struct is never addressed as a whole):
  - +0x0 `CActionChara *chara`: written by `CActionChara::InitScript`, `ResetAction`, `RunScript`
    (`sw this`); read by ~70 actscript opcodes and passed as `this` to CActionChara members.
  - +0x4 `mgCCameraFollow *camera`: written in `RunScript` from
    `CScene::GetCamera(scene, GetCameraID(scene, "MainCam"))`; read by `_CHECK_FRONT_KEY`,
    `_CHECK_BACK_KEY` and actionchara's *MoveIF functions, always as `this` for
    `mgCCameraFollow::GetAngle()`.
  - +0x8 `RUN_SCRIPT_ENV *env`: written in `RunScript` (its 2nd argument), zeroed in
    `ResetAction`; read in `CActionChara::EntryThrowItem` (`env->item_chara`, `env->texb` at +4).
    Not read in actscript itself.
  - +0xC: never accessed anywhere -> `unk_c[4]`. The 0x10 size could be bss padding before the
    following `ext_func` (0x1F3D180); kept at 0x10 to match the symbol extent.

## Globals
| Symbol (config) | Addr | Size | Binding | Type / meaning |
|---|---|---|---|---|
| `nowScene` | 0x37E44C | 4 | **global** | `CScene *`, extern in header. Set by `CActionChara::RunScript` (`sw $a1, -0x62A4($gp)`); read by actscript (`_CAMERA_QUAKE`: `nowScene+0x2F90` = dng_main's `DNG_BATTLE_AREA`, fields +0x70 float, +0x74 float, +0x78 s16; `_CHECK_PAUSE`, `_GET_MONSTER_NOWSTS`, `_GET_TRG_DISTANCE` -> `GetTargetDist(CScene*)`, ...) and by 12 actionchara members. Another `nowScene` (0x37D4E4) is a runscript_opcodes local. |
| `action_info` | 0x1F3D170 | 0x10 | **global** | `ACTION_INFO`, extern in header (actionchara writes it). |
| `LastCInfo2` | 0x37E450 | 4 | local | `static ACTION_DAMAGE *LastCInfo2;` result of `CActionChara::EntryDamage2` in `_SET_DMG2` (null check -> printf "CACT:DMG_ENTRY_ERR %s\n"; writes +0x14). |
| `ext_func` | 0x1F3D180 | 0x400 | local | `static int (*ext_func[256])(RS_STACKDATA *, int);` |
| `ext_func_info` | 0x35A800 | 0x298 | local | `static RS_EXTFUNC_INFO ext_func_info[83]`: 82 entries in retail order + `{NULL, ACTION_EXT_END}` terminator (retail has 8 zero alignment bytes after it, supplied by the linker). Static prototypes give the handlers their retail local linkage before the table takes their addresses. |
| `sw`, `canon_slot`, `cnt` (+ compiler guards) | .sbss | 4 each | local | function-local statics of `_SHOT`: `static int sw = 1;` (toggles 0/1), `static int canon_slot = 0;` (cycles 0..3, indexes a pair table of 8 pointers on the stack), `static int cnt = 0;` (cycles 0..2). MWCC initialises them lazily through generated guard words. |
| (string) | 0x375EE0 | | | "chr]same ext_func_no!!!\n" (duplicate-number printf). |
| (string) | 0x375F00 | | | "ext func over!!" (number outside 0..255). |

Globals used but owned elsewhere: `DngUserData` (dng_main), `GamePad` (mainloop),
`PadCtrl` (mainloop), `ColPrimMan`, `MachineGun`, `RocketLauncher`, `LaserGun` (dng_main).

## Functions
Global (in header): `SetActionScript`, `SetActionExtendTable`, both called only from
`CActionChara::LoadActionFile`. Every other function in the unit (all 82 opcodes, the helpers,
`ParabolicInitialVector`, the five `Shot*`) is LOCAL in retail -> `static` in the .cpp.

- `int SetActionScript(CRunScript*, char*, mgCMemory*)`: `Alloc(0x40)` stack (0x80 RS_STACKDATA),
  `Alloc(0x180)` call stack (0x200 RS_CALLDATA), `load(prog, stack, 0x80, call, 0x200)`,
  `ext_func(ext_func, 0x100)`, returns 1. Identical to `SetMonsterScript`.
- `void SetActionExtendTable()`: identical to `SetMonsterExtendTable` (zero table unrolled x8;
  per row until `func == 0`: duplicate-number check -> printf + `for(;;);`; range check
  0..255 -> printf, else `ext_func[no] = func`).
- Helpers (local): `int GetStackInt`, `float GetStackFloat`, `char *GetStackString`,
  `void SetStack(RS_STACKDATA*, int)`, `void SetStack(RS_STACKDATA*, float)`; semantics as in
  runscript_opcodes (RS_FLOAT/RS_INT conversion; store only through RS_PTR). They read and write
  the `RS_STACKDATA::val` union members and test the `RS_INT`/`RS_FLOAT`/`RS_PTR` enumerators.
- `void ParabolicInitialVector(float *out, float *from, float *to, float gravity, float time)`:
  `out = {(to.x-from.x)/t, -((to.y-from.y)*2 - t*g*t)/(t*2), (to.z-from.z)/t, 1.0}`; used by `_RELEASE_OBJ`.
- `void ShotMonicaMagic(float*, float*, float)`, `ShotNormalGun(float*, float*)`,
  `ShotMachineGun(float*, float*, char*, float)`, `ShotGrenadGun(float*, float*)`,
  `ShotLaserGun(float*, float*, int)`: all return void; use `ColPrimMan` and the gun managers.
- Opcodes return `int`: most are `return argc == N` (Ghidra shows `bool`) after acting only when
  the argument count matches; others return 1 (or 0 on a null scene, e.g. `_CAMERA_QUAKE`).
- CActionChara offsets touched (named in actionchara.hpp): 0x588, 0x5A0, 0x690 (front vector),
  0x6A4 (attack type), 0x6A8, 0x712 (s16 prog number, `_PROG_SET/_GET`), 0x714, 0x764, 0x76C
  (`_SET_MENU_FLAG`, byte), 0x770, 0x772, 0x7A0 (blow vector), 0x7CC, 0x7D6, 0x7D8, 0x7DC (effect
  script manager), 0xC10 (+n*0x20, shot slots), 0xF54..0xF70 (sound slots, `_SET_SND`).

## External-function numbers (`ext_func_info` order, number=function)
0 INIT_SCRIPT, 1 PROG_SET, 2 PROG_GET, 3 GET_ATTK_TYPE, 4 GET_MOVE_TYPE, 5 SET_MOVE_SPEED,
30 SET_PALLET, 31 CHECK_EQUIP, 32 CAMERA_QUAKE, 33 CHECK_PAUSE, 34 GET_STATUS_ATTR, 35 SE_PLAY,
36 SE_LOOP_PLAY, 37 GET_SHOT_TYPE, 38 GET_MONS_ID, 39 GET_FRONT_VEC, 40 GET_PADON, 41 GET_PADDOWN,
42 GET_PADUP, 43 GET_BTN, 45 GET_PAD_HISTORY, 46 RESET_PAD_HISTORY, 47 GET_ACUMU_PAD,
48 RESET_ACUMU_PAD, 49 RUN_MAIN_MOVE, 50 RUN_SHROW_MOVE, 51 RUN_TAME_MOVE, 52 RUN_HOLD_MOVE,
59 SET_MENU_FLAG, 53 GET_POS, 61 GET_ROT, 54 CHECK_FRONT_KEY, 55 CHECK_BACK_KEY, 56 SET_BLOW_ANGLE,
57 SET_BLOW_MOVE, 58 BLOW_START, 60 RUN_ROBO_MOVE, 71 SET_DMG2, 72 SET_OBJ, 73 SET_BODY,
75 SW_EFFECT, 76 SET_SND, 77 SET_ACCUME_FX, 78 SET_ACCUME_FLAG, 90 GET_MONSTER_NOWSTS,
91 SET_MURDEROUS, 92 GET_TRG_DISTANCE, 93 SET_TRG_ANGLE, 94 SET_GUARD_FLAG, 95 SET_MUTEKI,
96 CHECK_HAND_OBJ, 97 SET_ITEM_USED, 98 THROW_HAND_OBJECT, 99 CHECK_CATCH, 100 RELEASE_OBJ,
101 SET_SHOT, 105 SET_SPECIAL_SHOT, 102 SHOT, 103 GET_OBJECT_POS, 104 SET_DIR_GUN,
106 GET_NOW_HP_RATE, 107 SET_BOMB, 108 GET_ACTION_CODE, 109 GET_ATTK_POINT, 110 GET_RING_COLOR,
130 SET_MOS, 131 CHECK_MOS_END, 132 NOW_MOS_WAIT, 133 GET_MOS_STATUS, 134 SET_XCHG_STEP,
135 SET_MOS_STEP, 136 TRG_ON_MOS, 137 RESET_MOS, 138 SET_DEFAULT_MOS, 140 SET_NEBA2,
139 NOW_MOS_CHGWAIT, 150 ESM_CREATE, 151 ESM_SET_VECT1, 152 ESM_SET_VECT2, 153 ESM_FINISH,
154 ESM_DELETE, 155 ESM_SET_VALUE; then `{0, -1}`.

## Unresolved
- Retail name of the `action_info` struct type (`ACTION_INFO` is ours); meaning of +0xC.
- Per-opcode argument meanings were not analysed (header task); offsets above are from m2c.

## Division-check pragma

The unit-level `divbyzerocheck` pragma was redundant with the global MWCC flag; removing it left the full compiled object identical in objdiff.

## Source status and data

Every function in `actscript.cpp` is native; the unit has no `NONMATCHING`
guards, `INCLUDE_ASM` gaps, or data markers. `nowScene` and `action_info`
use their header types. Strings are inlined with their exact retail bytes
(Shift-JIS included); where a hexadecimal escape would otherwise consume a
following ASCII hex digit, adjacent literals are split. The Ridepod movement
switch emits its own jump table.

- `_SET_BLOW_MOVE` initializes its forward vector at the copy site and declares
  the matrix after that vector. `_RELEASE_OBJ` initializes the throw offset only
  in the throwing branch. `_SET_SPECIAL_SHOT` initializes four typed effect-name
  pointers at their use. `_GET_RING_COLOR` initializes its four RGB rows directly.
- `_SHOT` initializes the `CanonObjectNames` aggregate (eight frame names and
  their pointer table) inside its cannon branch; the later target buffers,
  weapon-health array and beam offset keep their declaration order after that
  branch, which fixes the retail frame layout.
- `SetActionScript` keeps the script stack and call data as typed
  `RS_STACKDATA *`/`RS_CALLDATA *` locals cast once from `Alloc`.
- `_CHECK_CATCH` passes the `int` result of `CheckKeri` through a `char *name`
  local (`SetStack(stack, (int) name)`); passing the call result directly sets
  up `a0` before `a1`, whereas retail sets up the cast argument first.
- `(CActiveMonster *)` / `(CCharacter2 *)` casts of held objects are real
  downcasts. The charging effect is accessed through a unit-local `AccumeSlot`
  struct that duplicates the `ACCUME_EFFECT` layout from dng_main.hpp because
  `CActionChara::accume_effect` is `void *`; typing the field as
  `ACCUME_EFFECT *` would remove those casts.

## `_SHOT` floating-argument schedule

Both the attack-type 40 and attack-type 90 branches finish their effect setup
with `action_info.chara->effect_man->SetValue(4, 160.0f, 0, -1)`. Retail
materializes the 160.0f argument before the `action_info` load only in the
attack-type-90 call; the default MWCC schedule exchanges the `v0`/`v1`
registers for the constant and `action_info` loads at `_SHOT+0x8B0..+0x8C4`.
Both calls have the same parsed shape (direct binary32 constant, same callee,
receiver load, three integer constants), so a function/callee/value policy
alone fixes the later call and breaks the earlier one. The Satan's Fiddle row
for `_SHOT__FP12RS_STACKDATAi` therefore scopes binary32 `0x43200000`
evaluate-first to callee `SetValue__16CEffectScriptManFifii` with
`control: {"kind": "condition", "values": [90]}` and `expected_matches: 1`,
selecting the argument by the enclosing attack-type comparison. With that row
`_SHOT` is its retail 0x900 bytes and the unit matches.

No source form separates the two calls: `160.0f`, `float(160.0)`, a named float
or integer converted to float, a named effect-manager pointer or reference,
separate color-channel locals, and null-alternative assignment of the beam
collision ID all produce the same object; a non-const double local adds a
`dptofp` call (0x908 bytes); a local four-float color array, an early WHP
return, or an `else if` dispatch change the body structure. `GetNowWhp`
writes a two-element WHP buffer, so a scalar output form is not available.
