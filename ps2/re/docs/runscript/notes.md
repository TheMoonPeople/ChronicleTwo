# runscript: reverse-engineering notes

## C++ draft status
All 28 functions have C++ in `ps2/src/runscript.cpp`. 25 are exact and compiled
by the matching build. 3 differ from retail and keep the `INCLUDE_ASM` fallback.
Each function tried has its one promotion attempt recorded in
`scripts/re/promotion_attempts.tsv`.

Script stack VM. Same design as the first game's `runscript` (`/home/adubbz/development/chronicle/ps2/include/runscript.hpp`,
`ps2/src/runscript.cpp`, fully matched there); use it as the model for bodies. Differences are listed below.

## CRunScript (size 0x54)
Size: `EventScript` (event unit) is a `CRunScript` with symbol size 0x54; exe writes up to 0x50.

| Off | Field | Evidence |
|---|---|---|
| 0x00 | `version` | ctor stores 1; `load` stores 2 when `strncmp(prog, "SB2", 3) == 0`. Never read in this unit or (by grep) elsewhere. NEW vs game 1. |
| 0x04 | `ext_func_num` | `ext_func` stores count; `ext` bounds check. |
| 0x08 | `ext_func_table` | `ext_func`; `ext` indexes it by 4. |
| 0x0C | `stack_num` | `load`; reduced by `prog->global_num` for SB2. |
| 0x10 | `stack` | `load`; advanced past globals for SB2. |
| 0x14 | `sp` | push/pop step 8. |
| 0x18 | `stack_end` | `load` = stack + stack_num*8; `check_stack`. |
| 0x1C | `global` | `load` (SB2) = original stack; memset to `global_num*8`. exe addr modes 0x40/0x200 index it. NEW. |
| 0x20 | `call_num` | `load`. |
| 0x24 | `call` | `load`; `run` resets `call_sp`; exe RET compares `call_sp != call`. |
| 0x28 | `call_sp` | `call_func`/`ret_func`, stride 0xC. |
| 0x2C | `call_end` | `load` = call + call_num*0xC. |
| 0x30 | `frame` | `call_func`, `run`. |
| 0x34 | `func` | `call_func`, `run`; `func->name` (+4) in error messages. |
| 0x38 | `pc` | `exe`, `resume`. |
| 0x3C | `end` | set by END/RET; read externally (CActionChara+0x6bc+0x3c = 0x6f8, monster +0x107c, `EventScript+0x3c`). |
| 0x40 | `skip_wait` | `skip` sets 1; JMP/JMP_TRUE/JMP_FALSE/WAIT/EXT check it. |
| 0x44 | `prog` | `load`; `run`/`check_program`. |
| 0x48 | `code` | `load` = (char*)prog + prog->code. |
| 0x4C | `result` | exe RET at outermost call stores popped value's data word. |
| 0x50 | `skip_end_count` | exe op 28 increments; `run` zeroes. Name is descriptive (retail name unknown). NEW. |

Ctor (0x70): sp=stack_end=stack; call_sp=call_end=call; pc=0; ext_func_num=stack_num=call_num=0; skip_wait=0; version=1;
then calls `DeleteProgram()` (zeros end, skip_wait, prog). No vtable.

No `reload` and no inline `IsEnd` in this game's manifest (game 1 had both).

`run` returns -1 (no prog / program not found), else `end == 0` (1 = suspended, 0 = finished). `run` also zeroes end,
skip_wait, skip_end_count before `exe`.

Op 28 (`RS_OP_SKIP_END`): `skip_end_count++`; if skip_wait: clear it, pc = next, return (suspend).

## Structs
- `RS_STACKDATA` 8 bytes {type, union}. Passed by value in a single 64-bit GPR (`sd $4` in chk_int/is_true), not via a pointer.
  `pop` returns it via hidden pointer in $a0, `this` in $a1.
- `vmcode_t` 0xC (exe pc step 0xC). `funcdata` {addr 0, name 4, local 8, arg 0xC}. `RS_CALLDATA` 0xC {ret, frame, func}.
- `RS_PROGDATA` {no, func} stride 8 (run/check_program).
- `RS_PROG_HEADER`: 0x00 magic (strncmp with "SB2", 3 chars; game 1 had `int unk_0`), 0x04 main, 0x08 code, 0x0C prog,
  0x10 prog_num, 0x14 unknown (never touched here), 0x18 global_num (SB2 only). Size not established, so no assert.

## Enums
- `RS_OPCODE`: cases from exe switch: 1-21, 23-30 (no 22) - identical to game 1.
- `RS_ADDR_MODE` (load / load-addr `arg2`): 1,2,4,8,0x10,0x20 as game 1, plus 0x40 (global slot) and 0x200 (global slot,
  sets type RS_FLOAT before push). No 0x80/0x100 cases.
- `RS_CONST_TYPE` (push-const `arg1`): 1 int, 2 float bits, 3 string at code+arg2. Game 1 used bare literals.
- `RS_COMPARE` 40-45 (cmp `arg1`). `RS_STACK_TYPE` 0 int, 1 float, 2 str, 3 ptr. `RS_VERSION` 1/2.

## Free functions
- Local (retail LOCAL, belong `static` in the .cpp, not in the header): `runerror`, `stkoverflow`, `chk_int`, `is_true`,
  `divby0error`, `modby0error`, `print`. Bodies as game 1 (game 1 declared chk_int/is_true in battle_globals.hpp; here they
  are file-local). `is_true` ends `xori 1; andi 0xFF` - game 1's `int is_true` version is the starting point.
- Global: `rsGetStackInt` (float -> fptosi, else data word), `rsSetStack` (if type RS_PTR, `p->i = value`). Callers: editevent.

## Data
Only compiler literals (`at_*`): error strings, "%d"/"%s"/"%f", "SB2", "not found ext %d\n", "illegal function call ext %d\n",
"not found program %d\n", Shift-JIS call-stack overflow message (at_275, as game 1), at_694 (NOT error), at_697..699 (exe
jump tables / float consts). No extern globals for this unit.

## Users
CActionChara (+0x6bc), CActiveMonster (+0x6bc in ctor; monster code uses nowMonster+0x1040), `EventScript` (event),
SetMonsterScript (runscript_opcodes), SetActionScript (actscript), SetEffectScript (effscript), SetEventFunc (event_func).
