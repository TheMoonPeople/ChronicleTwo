# runscript_opcodes: notes

## C++ draft status
All 183 functions have C++ in `ps2/src/runscript_opcodes.cpp`. 12 are exact and
compiled by the matching build. 95 more compile to retail's bytes in isolation
but stay under `NONMATCHING`. 76 differ from retail and keep the `INCLUDE_ASM`
fallback. Each function tried has its one promotion attempt recorded in
`scripts/re/promotion_attempts.tsv`.

Monster-script external functions (`_XXX(RS_STACKDATA *, int)`), their argument helpers, the
monster external-function table, and `CMonsterMan::RunScript`. First-game counterpart:
`chronicle/ps2/include/runscript_opcodes.hpp` / `src/runscript_opcodes.cpp` (there the setup pair is
`BtSetEventScript` / `BtSetEventExtendTable` and the opcode set is entirely different).

## Owned types
`class_units.tsv` lists no class owned by this unit. Script VM types (`RS_STACKDATA`, `CRunScript`,
`RS_CALLDATA`, `RS_PROG_HEADER`, `RS_STACK_TYPE`) come from `runscript.hpp`, included by the header.

- `RS_EXTFUNC_INFO` (8 bytes): row type of the static `ext_func_info` table. **Name is not retail**
  (no retail name is available; first game's source calls the equivalent row
  `BT_EVENT_EXTERNAL_FUNCTION`, also not retail-proven). `+0 func` (pointer to an
  `int (RS_STACKDATA *, int)` opcode), `+4 no` (index into `ext_func`). Evidence:
  `ext_func_info__DATA.s` pairs of `.word _OPCODE__FP12RS_STACKDATAi, n`; `SetMonsterExtendTable`
  reads +0/+4 with stride 8. Field names follow `CRunScript`'s style; rename freely if desired.

## Globals (retail binding)
| Symbol | Addr | Size | Binding | Type / meaning |
|---|---|---|---|---|
| `nowScene` | 0x37D4E4 | 4 | local | `CScene *`: set from `CMonsterMan+0x0` in `RunScript`; passed to `SearchArea(CScene*, ...)`, compared against null etc. in ~36 opcodes. `static` in the .cpp. |
| `nowMonster` | 0x37D4E8 | 4 | **global** | `CActiveMonster *` (extern in header): `CMonsterMan+0x484[i]` is `CActiveMonster *` (see `CheckDamage__11CMonsterManFv`). `_SET_DMG2` passes it as `CActionChara *` to `CActionChara::EntryDamage2` (base class, implicit upcast). Only this unit uses it. |
| `LastCInfo2` | 0x37D4EC | 4 | local | result of `CActionChara::EntryDamage2` in `_SET_DMG2` (pointer-sized; type = that function's return type). |
| `ext_func` | 0x1EF7430 | 0x400 | local | `int (*ext_func[256])(RS_STACKDATA *, int)`; zeroed then filled by `SetMonsterExtendTable`, handed to `CRunScript::ext_func(ext_func, 0x100)`. |
| `ext_func_info` | 0x3517C0 | 0x570 | local | `RS_EXTFUNC_INFO[174]` (173 entries + terminator `{0, -1}`), .data. |
| `at_1480__2`, `at_1481__2`, `at_1864`, `at_2160` | 0x351780.. | 0x10 each | local | `{0,0,1.0f,0}` float[4] initialisers of function-local vectors (compiler-generated). |
| `at_3078` | 0x36D3E0 | | | printf string for duplicate number ("mscript same ext_fun..."). |
| `at_3079` | 0x36D400 | | | printf string "ext func over!!". |

## Functions
All 180 opcodes and the helpers `GetStackInt`, `GetStackFloat`, `GetStackString`, `SetStack(int)`,
`SetStack(float)`, `GetStackVector`, `SetStackVector` are LOCAL in retail -> `static` in the .cpp,
not in the header. Global: `SetMonsterScript`, `SetMonsterExtendTable` (both called from `monster`),
and `CMonsterMan::RunScript(int)` (member of `CMonsterMan`, declared by the `monster` unit header).

Helper signatures (from code):
- `int GetStackInt(RS_STACKDATA *)`: `type==RS_FLOAT` -> `(int)f`, else `i`.
- `float GetStackFloat(RS_STACKDATA *)`: `type==RS_INT` -> `(float)i`, else `f`.
- `char *GetStackString(RS_STACKDATA *)`: returns `s`.
- `void SetStack(RS_STACKDATA *, int|float)`: stores through `p` only when `type==RS_PTR` (3).
- `void GetStackVector(float *v, RS_STACKDATA **sp)`: reads 3 floats advancing `*sp`, sets `v[3]=1.0f`.
- `void SetStackVector(float *v, RS_STACKDATA **sp)`: writes `v[0..2]` via `SetStack(float)`, advancing `*sp`.

`SetMonsterScript(CRunScript*, char*, mgCMemory*)` returns `int` 1. `mgCMemory::Alloc` counts
quadwords: `Alloc(0x40)` = 0x400 bytes = 0x80 `RS_STACKDATA`, `Alloc(0x180)` = 0x1800 bytes =
0x200 `RS_CALLDATA`; then `load(prog, stack, 0x80, call, 0x200)` and `ext_func(ext_func, 0x100)`.

`SetMonsterExtendTable()`: zero `ext_func` (unrolled x8), then for each row until `func == 0`:
compare `no` with every earlier row's `no` -> `printf(at_3078)` and `for(;;);`; if `no` outside
0..255 -> `printf(at_3079)`, else `ext_func[no] = func`.

`CMonsterMan::RunScript(int i)`: `nowScene = this->[0x0]`; `nowMonster = this->[0x484 + i*4]`;
if non-null: `short n = mon+0x1158`; if `n == -1` -> `mon+0x1040` (`CRunScript`) `.resume()`, and if
its `end` (+0x107C = 0x1040+0x3C) is set, `mon+0x1158 = 200`; else if `check_program(n)` ->
`run(n)`, `mon+0x115A = n`, `mon+0x1158 = -1`. (`SetActiveMonster` sets +0x1158 = 100 after
`SetMonsterScript`.) CActiveMonster layout facts for the monster unit: +0x1040 CRunScript (0x54),
+0x1158 s16 next program number (-1 = running), +0x115A s16 current program number.

## Monster external-function numbers (`ext_func_info` order, number=function)
0 NORMAL_VECTOR, 1 COPY_VECTOR, 2 ADD_VECTOR, 3 SUB_VECTOR, 4 SCALE_VECTOR, 5 DIV_VECTOR,
6 ANGLE_CMP, 7 ANGLE_LIMIT, 8 SQRT, 9 ATAN2F, 10 ND_TEST, 11 GET_DIST_VECTOR, 12 GET_DIST_VECTOR2,
13 CALC_IP_CIRCLE_LINE, 14 GET_ANGLE_INNER, 21 MY_SE_PLAY, 22 MY_SE_STOP, 23 MONS_SE_PLAY,
24 MONS_SE_STOP, 65 MONS_SE_LOOP, 25 SET_CAMERA_NEXT_REF, 26 SET_CAMERA_FOLLOW,
27 SET_CAMERA_NEXT_POS, 28 SET_CAMERA_MODE, 29 SET_CAMERA_SPEED, 30 CAMERA_QUAKE,
31 SET_CAMERA_CTRL_PARAM1, 32 SET_CAMERA_CTRL_PARAM2, 33 RESET_CAMERA_CTRL_PARAM, 35 GET_RND,
36 GET_RNDF, 37 V_PUSH, 38 V_POP, 39 GET_MONSTER_NUM, 40 GET_MONSTER_INDEX, 41 GET_MONSTER_ID,
42 GET_USERID, 43 GET_USER_MONS_ID, 44 RESET_TIMER, 45 GET_TIMER, 46 CREATE_MONSTER,
47 RUN_EVENT_SCRIPT, 48 GET_FRAME_POS, 49 GET_OBJ_POS, 50 GET_MAPOBJ_POS, 51 SET_PAUSE,
52 CHECK_PAUSE, 53 GET_BIT_FLAG, 54 SET_BIT_FLAG, 55 GET_ATT_TYPE, 56 GET_USER_ATTR,
57 TRANS_RESERV_IMG, 58 GET_STS_ATTR, 59 V_PUSH2, 60 V_POP2, 61 SET_LOCKON_MODE, 62 SET_MOTION_BLUR,
64 GET_EVENT_INFO, 66 MONS_VOL_CTRL, 70 GET_DIST, 71 SEARCH_AREA, 108 SEARCH_AREA2,
72 GET_PLACE_POS, 73 SET_PLACE_POS, 74 GET_INDEX_POS, 75 GET_POS, 76 SET_POS, 77 GET_ROT,
78 SET_ROT, 79 SET_NEXT_ROT, 80 SET_NEXT_POS, 81 CHK_MOVE_END, 82 RESET_MOVE, 83 GET_TARGET_POS,
84 GET_TARGET_DIST, 85 GET_TARGET_ANGLE, 86 GET_TARGET_REF_POS, 87 GET_REF_DIR,
88 GET_REFANGLE_POS, 89 GET_TARGET_ROT, 90 GET_REF_ANGLE, 91 GET_HIGH, 92 GET_NEAR_MONS_POS,
93 GET_TARGET_OLD_POS, 94 GET_TARGET_SPEED, 95 CALC_MOVE_NEXT_POS, 96 GET_POSREF_ANGLE,
97 GET_ACTIVE_MONS_POS, 98 GET_ACTIVE_MONS_ROT, 99 GET_ACTIVE_MONS_DIST, 100 GET_ACTIVE_MONS_ANGLE,
101 GET_REF_ROT, 102 GET_REF_ROT2, 103 FLYING_SEARCH_AREA, 104 GET_HIGH2, 105 GET_RANGE_MONS_ID,
106 GET_ENTRY_OBJ_POS, 110 SET_OBJ, 111 SET_BODY, 112 SET_DMG, 113 SET_DMG2,
114 LINK_MAP_TO_OBJECT, 115 LINK_OBJECT_TO_PIECE, 116 LOAD_EFFECT_SCRIPT, 117 SET_SCOOP,
118 LOAD_RESERV_IMG, 119 SET_PRIORITY_LIMMIT, 120 SET_MODEL_LIGHT_SWITCH, 121 SET_MODEL_LIGHT_COLOR,
122 SET_ALPHA, 123 SET_SCALE, 124 SET_INDEX_ALPHA, 125 SET_PALLET_ANIM, 126 RESET_PALLET_ANIM,
127 SET_ATTRIB, 128 SET_STATUS, 129 SET_INT_FLAG, 130 SET_ACT_STATUS, 131 SET_MUTEKI,
132 SET_GRAVITY, 133 SET_COLLISION, 134 GET_GEKIRIN, 135 GET_PRIORITY, 136 SET_CLIP_DIST,
137 SET_PIYORI_MARK, 138 CHECK_PIYORI, 139 GET_SCALE, 140 GET_MONS_WIDTH, 150 BLOW_START,
151 SET_DEAD_START, 152 SET_DEAD_OFF, 153 SET_SHROW_END, 160 GET_BASE_ATTACK, 161 SET_DEF_RATE,
162 SET_MONSTER_LIFE, 163 GET_MONSTER_LIFE, 164 GET_NO_DAMAGE_CNT, 165 GET_ACTIVE_MONS_LIFEI,
166 GET_ACTIVE_MONS_LIFEF, 167 SET_ACTIVE_MONS_LIFEI, 168 SET_ACTIVE_MONS_LIFEF,
169 GET_ACTIVE_MONS_MAX_LIFE, 170 SET_DAMAGE_SCORE, 171 GET_MONS_GRADE, 173 SET_ESCAPE_RATE,
172 SET_GUARD_RATE, 174 SET_EXT_PARAM_RATE, 175 GET_BOSS_FLAG, 176 SET_INDEXOBJ_SIZE,
177 GET_INDEXOBJ_SIZE, 180 RESET_MOTION, 182 SET_MOS, 183 CHECK_MOS_END, 184 NOW_MOS_WAIT,
185 GET_MOS_STATUS, 191 ESM_CREATE, 192 ESM_FINISH, 193 ESM_DELETE, 194 ESM_SET_VECT1,
195 ESM_GET_VECT1, 196 ESM_SET_VECT2, 197 ESM_GET_VECT2, 198 ESM_SET_TARGET_ID,
199 ESM_GET_TARGET_ID, 200 ESM_SET_USER_ID, 201 ESM_GET_USER_ID, 202 ESM_SET_VALUE, 203 SW_EFFECT,
204 ESM_GET_NOTUESD_TEXB, 205 ESM_ADD_TEXB, 206 SHOT_ROCKET_LAUNCHER, 207 ESM_ALL_CLEAR,
63 SET_MAPOBJ_SHOW; terminator `{0, -1}`. The numbers appear only in this data table, so no enum
was declared.

## Unresolved
- Retail name of the `ext_func_info` row type.
- `LastCInfo2`'s exact pointee type (depends on `CActionChara::EntryDamage2`'s return type in
  `actionchara.hpp`).
- `CActiveMonster` / `CMonsterMan` are declared by the `monster` unit (no `monster.hpp` yet); the
  header forward-declares `CActiveMonster`.
