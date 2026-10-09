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
| `nowScene__2` (retail `nowScene`) | 0x37E44C | 4 | **global** | `CScene *`, extern in header. Set by `CActionChara::RunScript` (`sw $a1, -0x62A4($gp)`); read by actscript (`_CAMERA_QUAKE`: `nowScene+0x2F90` = dng_main's `DNG_BATTLE_AREA`, fields +0x70 float, +0x74 float, +0x78 s16; `_CHECK_PAUSE`, `_GET_MONSTER_NOWSTS`, `_GET_TRG_DISTANCE` -> `GetTargetDist(CScene*)`, ...) and by 12 actionchara members. Another `nowScene` (0x37D4E4) is a runscript_opcodes local. |
| `action_info` | 0x1F3D170 | 0x10 | **global** | `ACTION_INFO`, extern in header (actionchara writes it). |
| `LastCInfo2__2` (retail `LastCInfo2`) | 0x37E450 | 4 | local | `static ACTION_DAMAGE *LastCInfo2;` result of `CActionChara::EntryDamage2` in `_SET_DMG2` (null check -> printf "CACT:DMG_ENTRY_ERR %s\n" at_1202__2; writes +0x14). |
| `ext_func__3` (retail `ext_func`) | 0x1F3D180 | 0x400 | local | `static int (*ext_func[256])(RS_STACKDATA *, int);` |
| `ext_func_info__3` (retail `ext_func_info`) | 0x35A800 | 0x298 | local | `static RS_EXTFUNC_INFO ext_func_info[83]`: 82 entries + `{0, -1}` terminator (the data file has 8 more zero bytes after it: alignment). |
| `sw_1617`/`init_1618`, `canon_slot_1620`/`init_1621`, `cnt_1661`/`init_1662` | .sbss | 4 each | local | function-local statics of `_SHOT`: `static int sw = 1;` (toggles 0/1), `static int canon_slot = 0;` (cycles 0..3, indexes a pair table of 8 pointers on the stack), `static int cnt = 0;` (cycles 0..2). Initialised lazily (guard bytes `init_*`), i.e. non-constant-initialised statics. |
| `at_2004__4` | 0x375EE0 | | | "chr]same ext_func_no!!!\n" (duplicate-number printf). |
| `at_2005__3` | 0x375F00 | | | "ext func over!!" (number outside 0..255). |

Globals used but owned elsewhere: `DngUserData` (dng_main), `GamePad` (`GamePad__2`, mainloop),
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
- Helpers (`__3` suffixed symbols): `int GetStackInt`, `float GetStackFloat`, `char *GetStackString`,
  `void SetStack(RS_STACKDATA*, int)`, `void SetStack(RS_STACKDATA*, float)`; semantics as in
  runscript_opcodes (RS_FLOAT/RS_INT conversion; store only through RS_PTR).
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

## `_SHOT` native residual

The current native `_SHOT` body has one four-instruction register-allocation difference in its final beam-effect `SetValue(4, 160.0f, 0, -1)` call. Retail loads `0x4320` into `v1`, loads `action_info` into `v0`, transfers `v1` to `fa0`, then reads the effect manager through `v0`. MWCC currently uses `v0` for the constant and `v1` for `action_info`; the rest of the 0x900-byte function and its relocations match.

Private whole-object trials of `160.0f` versus `float(160.0)`, a named float local, and a named effect-manager pointer retain that difference. Seeding the unit's helper GPR mask with either `0x10` or `0x30` also leaves it unchanged. An evaluate-first override for binary32 `0x43200000` affects an earlier call with the same function, callee, type, and value, so it creates an additional mismatch rather than isolating the final call. A binary64 override is unconsumed: MWCC has folded the explicit double conversion to binary32 before the hook sees it. No source or profile change from these trials is accepted as a match.

A final-call-only `CEffectScriptMan&` receiver alias was also tested in a private
copy. The whole-unit checker still reports only the `_SHOT` byte mismatch, and
the project-configured function diff retains the same four operand differences
in the constant/action-info register assignment. The alias does not improve
the match and was not promoted.

At MWCC's floating-argument consumer, both `SetValue(4, 160.0f, 0, -1)`
calls have the same parsed shape: a direct binary32 constant node (`0x33`),
the same mangled callee, a receiver load, and three integer constant
arguments. A callee/value policy cannot distinguish the two without an
occurrence selector, which is not an accepted compiler calibration. The
temporary trace used to establish this was removed from Satan's Fiddle.

## `_SHOT` floating argument schedule

Both attack-type 40 and 90 branches finish their effect setup by calling
`CEffectScriptMan::SetValue(int, float, int, int)` with value index 4 and
160.0. m2c and retail assembly confirm the same overload and constant in both
branches. `_SHOT` is 0x900 bytes; the deterministic default policy differs
from retail only at +0x8B0/+0x8B4/+0x8B8/+0x8C4 in the later call. These four
words exchange the v0/v1 registers used for the constant and `action_info`
loads, without changing function size or relocation count.

A binary32 160 (`0x43200000`) evaluate-first row, including one scoped to
`SetValue__16CEffectScriptManFifii`, fixes the later call but creates the same
four-word exchange at the earlier +0x6C0/+0x6C4/+0x6C8/+0x6D4 call. A local
pointer or reference to the earlier effect manager does not resolve this
conflict; verified consumer logging still identifies two binary32 160
arguments to the same callee in each compiler pass.

Natural source/type trials establish these boundaries:

- Replacing the later `float(160.0)` with `float(160)` or `160.0f`, or passing
  a named float or integer value converted to float, preserves the complete
  default-policy object byte-for-byte.
- A named integer value at the earlier call also preserves the conflict
  under the binary32 evaluate-first row.
- Inline `float(160.0)` and a named `const double` value narrowed to float
  do not retain a selectable binary64 160 identity; that selector is rejected
  as unconsumed.
- A non-const double local does retain a binary64 identity, but the compiler
  emits `dptofp`, growing `_SHOT` to 0x908 and the unit's checked size from
  0x47FC to 0x4804, with 1112 rather than 1111 relocations. The extra call
  remains under both the default policy and a binary64 evaluate-first row.

No source form or policy above passes the complete unit. The remaining
reconsideration trigger is retail-supported source evidence for a real
expression distinction that survives optimization without a conversion call,
or a separately validated stable compiler identity that distinguishes those
expressions. Occurrence selectors and invented helper functions do not follow
from this evidence.

## Shot receiver boundaries and proposed semantic context

The complete arguments at both remaining sites are identical:
`action_info.chara->effect_man->SetValue(4, 160.0f, 0, -1)`.
`action_info` is a direct global structure, `effect_man` is a direct member,
and the float `SetValue` overload is out of line. There is no nested argument
call or inline accessor to move into a result local as in the matched movement
functions. The two source branches test attack type 40 and 90 respectively.

Additional private source-boundary trials under the scoped 160-first row
produce these results:

- Binding the earlier action character before reading its effect manager
  repeats the earlier-call conflict, just as the previous manager-local trial.
- Grouping the earlier color channels into separate float locals, with blue
  sharing green as in the neighboring `ShotLaserGun`, also repeats that exact
  object. Both objects have SHA-256
  `cd33a0d7e3739ec3e72cd43f57123976bfc8eb0eb9e8c802d114de00d9c6a2ae`:
  four differing words, `0x47FC` checked bytes, and 1111 relocations.
- A local four-float color array grows the raw `_SHOT` body to `0x908`, grows
  its stack frame from `0x100` to `0x110`, and has 181 differing words. Normal
  postprocessing rejects a shifted local-data binding; no tool change was made.
- Local optimization level 2 grows `_SHOT` to `0xAA8`, with 633 differing
  words and 210 complete-unit findings. It is rejected without further policy
  trials on that changed body.

None is retained. After the independent texture-hash fix, the normal object
still has baseline SHA-256
`d01bd5dead4c6225ddfd46d5b787b9b2a5d87eb7822f7ddafc86318ef237f082`.
Its complete finding remains the single byte mismatch at `0x002D5DB2`, equal
to round 2 and integration i12. Receipts are in
`.private/receipts/regress/round3/actscript-*/` and `after-mg/`.

The minimal proposed selector extension is an optional **semantic predicate
context**, preserving the existing TU, enclosing function, float type/bits,
and callee identity. For this case the meaningful discriminator is the
enclosing equality test on the ranged-weapon attack type: 40 versus 90.
A 160-first row restricted to the attack-type-90 branch would leave the
already-matched attack-type-40 branch at the default policy. These are game
values, not call occurrence numbers. Receiver spelling, argument position,
and inline-origin identity cannot distinguish the recorded trees.

This is a research proposal, not a supported profile row or a claim that the
present hook can recover predicates. Satan's Fiddle would need verified
provenance from the actual enclosing source predicate through optimized and
cloned argument nodes to the consumer; current function/callee/constant logging
does not establish that provenance. Reopen when that semantic identity is
demonstrably stable across both mwccgap passes and temporary filenames, and
the resulting complete unit has zero byte and relocation differences. No
source line, instruction address, compiler-arena address, ordinal, invented
helper, or wrapper change is part of this proposal.

## Historical shot source and conditional forms

`actscript.cpp` and its owned header are unchanged between the old-toolchain
matching `250ac10` source and round-3 head `accc605`. Both 160 arguments,
their receiver expressions, and the independent attack-type-40/90 predicates
already have their current shapes in that matching source. `d08b13d` does not
edit `_SHOT` relative to its parent; `5b4deb3` inherits the current body from
its second parent. Its older integration parent has a guarded draft with a
scalar WHP output and early return. Restoring that output type would conflict
with the actual two-integer `GetNowWhp` output. The current matching source
does not supply an untested expression to restore.

Seven new source/control-flow hypotheses retain the actual two-element WHP
buffer and the real effect-manager API:

- Replacing the positive-WHP scope with an exhausted-WHP early return grows
  `_SHOT` to `0x908`, changes 450 masked words, and yields 177 canonical
  findings, including moved static-data bindings. The prepared 160-first
  companion is not run on this structurally changed body.
- Expressing only the final beam laser-allocation condition as a null-failure
  return, or only its attack-type condition as a mismatch return, produces
  `0x908` bodies with 114 / 136 masked-word differences and 40 / 47 canonical
  findings respectively. Both are rejected without broader policy trials.
- Assigning the beam collision ID in the existing non-null branch and assigning
  `-1` in an explicit null alternative produces the baseline object exactly.
  This meaningful definition boundary does not change the final alpha call.
- Making the final 40/90 dispatch an `else if` preserves `0x900` size but has
  ten differing words. In addition to the four alpha words, the branch target
  and collision-ID saved register change because attack type is no longer live
  across the completed type-40 branch. Retail retains the independent checks.
- Representing the earlier four color channels as a constant byte vector and
  converting its components to the float setter tests the actual color domain
  under scoped 160-first. It adds non-retail `.sdata`, grows `_SHOT` to
  `0x9B0`, and changes 239 words with 63 canonical findings. This differs from
  the earlier float-vector trial and is also rejected.
- Adding a zero-first row for the preceding float color setters to scoped
  160-first reproduces the earlier conflict object
  `cd33a0d7e3739ec3e72cd43f57123976bfc8eb0eb9e8c802d114de00d9c6a2ae`
  exactly. Zero materialization introduces no surviving dependency capable of
  separating the two alpha arguments.

No candidate passes the complete unit. Retained source, headers and profile
are unchanged; the normal object remains
`d01bd5dead4c6225ddfd46d5b787b9b2a5d87eb7822f7ddafc86318ef237f082`.
It has a `0x900` body, the same four differing words, `0x47FC` checked bytes,
1111 relocations, and one finding at `0x002D5DB2`, equal to round 3 and i14.
The predicate-provenance proposal above remains a research requirement, not
a supported selector or proof that all natural source forms are exhausted.

Receipts: `.private/receipts/regress/round4/actscript-*/`,
`analysis/function-history.json`, `analysis/actscript-function-history.diff`,
`analysis/experiment-summary.json`, and `final/`. A read-only detailed review
under `AGENTS.md` identified these conditional probes; it made no edits or
compiles.

## Nested-selector scope after the upstream merge

The `sf-d8bf13c` image supports `nested_call` and `nested_variable`, both
requiring a sibling call inside an outer call's arguments. The current m2c
output and source still show two direct
`SetValue(4, 160.0f, 0, -1)` calls with a loaded effect-manager receiver and
scalar arguments. Neither contains the nested sibling call required by those
selectors. `nested_variable` selects a variable argument of such a nested
call; it does not select an arbitrary receiver, branch, or direct argument.
Thus the new supported identities cannot express the attack-type-40 versus
attack-type-90 distinction. The predicate-provenance proposal above remains
unimplemented; no unsupported or unconsumed profile row is added.

The clean merged object retains `0x47FC` checked bytes and 1,111 relocations,
with the same sole finding at `0x002D5DB2`. `_SHOT` remains `0x900` bytes and
has four differing masked instruction words, at `+0x8B0`, `+0x8B4`, `+0x8B8`,
and `+0x8C4`. The whole-project verifier retains the baseline `0x26` text-byte
difference, and the other object findings are unchanged.

## Predicate selector calibration, October 8 prototype

`satansfiddle-control-context.patch` implements the missing source predicate
identity using MWCC's verified lowered statement list. The checked-in binary32
160 row keeps `SetValue__16CEffectScriptManFifii` as its callee and adds
`control: {"kind": "condition", "values": [90]}`. It evaluates only the
attack-type-90 branch's alpha argument first. The attack-type-40 alpha call
retains the default schedule. The integer is the actual weapon-type comparison
in `_SHOT`; neither call order nor output address selects it.

The original `actscript.cpp` and header are unchanged. The row is consumed once
in each mwccgap pass, including the temporary replacement source, under the
logical `actscript.cpp` identity. `_SHOT__FP12RS_STACKDATAi` remains `0x900`
bytes and has zero differing masked words, resolving the four-word residual
above. The complete focused object passes `0x47FC` checked bytes and 1,111
resolved relocations.

The selector semantics and source-context limits are documented in
`scripts/build/SATANSFIDDLE.md`.
Image: `chronicletwo_dev:sf-d8bf13c-proto`. Receipts:
`.private/receipts/prototype/focused.log` and `shot-word-diff.json`; the trace
shows the same semantic identity in both compiler passes.

## Predicate selector validation, October 8 round 1

The attack-type-90 row adds `expected_matches: 1` before `evaluate_first`,
asserting one distinct selected call argument per compiler invocation. This
cardinality is validation only. `control` retains the equality's integer value
set and omits the compared subject, so another comparison against 90 can share
the projection; it is not a unique source-call identity. Additional matches
fail the assertion, and missing matches still fail consumption checking.

The hardened resolver collects applicable rows before selecting the greatest
specificity, rejects conflicting winning policies independently of row order,
and records only winning consumer applications. Compiler regression tests
check both mode-40 and mode-90 calls in one function, including equal code
preparation for the unselected mode-40 call. The earlier broad-160 conflict
is not reintroduced.

With `chronicletwo_dev:sf-d8bf13c-proto2`, the focused full-wrapper receipt
contains one `expected=1 actual=1` readback in each mwccgap pass. `_SHOT`
remains `0x900` bytes with zero differing masked words; the complete object
passes `0x47FC` bytes and 1,111 resolved relocations. Source and headers
remain unchanged. Receipts: `.private/receipts/proto2/focused.log` and
`shot-word-diff.json`; selector limitations are
documented in `scripts/build/SATANSFIDDLE.md`.
