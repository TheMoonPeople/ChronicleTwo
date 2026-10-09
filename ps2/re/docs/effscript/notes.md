# effscript: reverse-engineering notes

Effect script manager. No counterpart in the first game's decompilation (nothing named
EffectScript / EFF_SCRIPT / ES_SPRITE there).

## Types not named by retail
Retail names come only from mangled symbols: `CEffectScriptMan`, `_EFF_SCRIPT`, `_ES_SPRITE`.
These are neutral names chosen here: `EFF_SPT_BASE_DEF` (definition table row), `EFF_SPT_BASE`
(loaded base, 0x1C), `EFF_SPT_VALUE` (int/float union), enums `EffSptBaseType`, `EffSptState`.

## CEffectScriptMan (0x1190)
Size: `__nw__FUiP1(0x1190, ...)` in InitDungeonMain (dng_main) and EditInit (editloop). No
out-of-line ctor: the inline ctor runs the mgC3DSprite ctor on +0x30 (vtable stored at +0x4C)
then `Initialize(NULL, -1, -1)`. No vtable of its own.

| off | field | evidence |
|---|---|---|
| 0x00 | memory | Initialize arg1; BuildBase uses it when its memory arg is NULL |
| 0x04 | work_memory | SetWorkBuffer; StartStackMode/Alloc/Free in CreateEffSpt, AssignSprite, DeleteEffSpt |
| 0x08 | load_buffer (u_long128*) | LoadFile2 destination in LoadBaseEffSpt; stSetBuffer in BuildBase; set directly by InitDungeonMain |
| 0x0C | level | copied into base->level and script->level; InitDungeonMain writes it directly |
| 0x10/0x14 | texb_start/texb_num | Initialize args 2/3; DeleteBlock loop; GetNotUsedTexb |
| 0x18 | texb_used | AddTexb, BuildBase (texb<0 path), ClearBaseFromLevel |
| 0x1C | level_texb_used[4] | AddTexb indexes by level; ClearBaseFromLevel only for levels 1..3 |
| 0x2C | unk_2c | never touched in this unit |
| 0x30 | mgC3DSprite sprite (0x50) | Draw: BeginCreatePacket/DrawDirect on this+0x30 |
| 0x80 | EFF_SPT_BASE *base[64] | loops of 0x40 over +0x80 |
| 0x180 | base_num | ++ in BuildBase; CreateEffSpt fails if < 1 |
| 0x184 | _EFF_SCRIPT *slot[128][8] | index `slot*4 + user_id*0x20 + 0x184`; bounds 0x7F / 7 |
| 0x1184 | now | last created; used by every setter when slot < 0 |
| 0x1188/0x118C | head/tail | doubly linked list via _EFF_SCRIPT prev/next (0x140/0x144) |

List is ordered ascending by `_EFF_SCRIPT::texb` (insertion in CreateEffSpt).

## EFF_SPT_BASE (0x1C)
Placement-new 0x1C in BuildBase. 0x00 base_no, 0x04 CCharacter2* (NULL for IMG bases), 0x08 texb,
0x0C texb_owned (1 when taken from pool, decremented on clear), 0x10 script copy (passed to
SetEffectScript as char*), 0x14 level, 0x18 work_size = 0x7D + 0x24 (+ chara GetCopySize, vtable
+0xF0) quadwords, passed to StartStackMode(…, 3, size).

## eff_spt_base_def (.data 0x35B980, 0x558C = 219 * 0x64)
Row 0x64: name[0x20] (SJIS), type @0x20, file[0x20] @0x24, script[0x20] @0x44. Last row (218)
has empty name and type -1; GetEffSptBaseDefPtr returns NULL when `strcmp(name, "") == 0`.
Paths: `dungeon/eff_script/%s.chr` (type 0), `%s.img` (type 1), `%s.stb` (script); pack names
`%s.chr`/`%s.img`/`%s.stb` (at_1127/1128/1129).

## _EFF_SCRIPT (0x150)
Placement-new 0x150 in CreateEffSpt (Alloc 0x17 qw), CRunScript ctor at +0x50 (sizeof 0x54).
Init in CreateEffSpt: 0xA4=200, 0xF0/0x100 = (0,0,0,1), 0x110=-1, memset 0xC4 for 0x20.
- 0x00 work block (StartStackMode result; Free'd last). 0x04 chara_work (SetCharacter). 0x08 chara.
- 0x0C sub_chara_work, 0x10 sub_chara[4] (AssignCharacter; allows num < 5; Step/Draw loop 4).
- 0x20 texb (base->texb; SetTexb; ReloadTexture/GetTexture in Draw). 0x24 level.
- 0x28 sprite / 0x2C sprite_num (_SPT_ASSIGN_SPRITE, GetSpritePtr stride 0x110).
- 0x30 tex_name[0x20] (_SPT_SET_TEXNAME; GetTexture in Draw).
- 0x50 CRunScript (0x8C = run.end checked in Step).
- 0xA4 prog_no: -1 -> resume, else check_program/run, then set -1.
- 0xA8 user_id (CreateEffSpt arg2, slot-table row, ColPrim owner). 0xAC slot (-1 if not in table).
- 0xB0 origin (SetOrigin, _SET/_GET_ORIGIN; added to drawn positions).
- 0xC0 auto_offset, 0xC4 offset_frame[0x20] (_AUTO_SET_OFFSET; Draw uses target_id char/frame pos).
  Draw tests `(id < 0) && (0x7F < id)` (always false; retail bug, keep it).
- 0xE4..0xEF never seen.
- 0xF0 work_vect1, 0x100 work_vect2 (Set/GetScriptVect1/2, _GET_WORK_VECT1/2).
- 0x110 target_id. 0x114 value[8] (int or float; _GET/_SET_VALUE pick by RS type 0/1).
- 0x134 CColPrim*. 0x138 light_flag (_SET_LIGHT_FLAG; DrawEffSptSprite uses mgGetLight*0.3+ambient).
- 0x13C state, 0x140 prev, 0x144 next. 0x148..0x14F never seen.

State (0x13C) values from Step/Draw: Step skips 2 and 3, skips the script only for 1; Draw skips
2 and 4. Callers (dng_main etc.) use PauseFromLevel(level, 0/2/3).

## _ES_SPRITE (0x110)
Stride 0x110 (GetSpritePtr, AssignSprite `__nwa__(num*0x110)`). Fields from _SPT_* functions:
0x00 draw_flag (SET/GET_DRAW_FLAG), 0x04 alpha (SET_ALPHAB; mgCDrawEnv::SetAlpha), 0x10 pos,
0x20 uv (SET_UV_SIZE; uv1 = uv0 + size in DrawEffSptSprite), 0x30 color (clamped 0..255),
0x40 scale[2], 0x48 put_size[2] (drawn size = put_size*scale), 0x50 rotz (mgAngleLimit),
0x60/0x70 velo/acc pos, 0x80/0x90 velo/acc col, 0xA0/0xA4 velo/acc rotz (velo clamped to 2pi),
0xA8/0xB0 velo/acc scl, 0xB8 scale_target[2] + 0xC0 divisor (SCALE_CONV), 0xD0 color_target +
0xE0 divisor (COLOR_CONV): Step does `x += (target - x) / div` while div > 0 (div never changes).
0xF0 blink_amp[4], 0x100 blink_speed, 0x104 blink_phase (SET_BLINKING zeroes phase; Draw adds
amp*sin(phase)). _SPT_INIT_SPRITE gives defaults (alpha 1, color 128, scale 1, divisors -1).
Unseen: 0x08, 0x54, 0xC4, 0xE4, 0x108.

## Globals
- `eff_spt_base_def` global .data (above). `now_scene` (.sbss, CScene*, = GetMainScene() in
  Initialize). `EffScriptMan` (.sbss, CEffectScriptMan*, set in Step) global.
- Local (not in header): `now_script` (_EFF_SCRIPT* being stepped), `ext_func__4` (0x400 = 256
  function pointers, passed to CRunScript::ext_func with 0x100), `ext_func_info__4` (0x408 =
  0x81 RS_EXTFUNC_INFO rows, see runscript_opcodes.hpp).
- All non-member functions (GetEffSptBaseDefPtr, DrawEffSptSprite, GetSpritePtr, GetStack*,
  SetStack*, every `_XXX(RS_STACKDATA*, int)` script function, SetEffectScript,
  SetEffectScriptFunc) are LOCAL in retail: define them `static` in the .cpp.

## Signatures / return types
- `P1` in the mangled names is `u_long128 *` (as in mgCMemory::stSetBuffer), so BuildBase takes
  (int, u_long128*, int, u_long128*, int, mgCMemory*, int); Ghidra/m2c drop the last two (t2/t3).
- Return values used by callers: LoadBaseEffSpt(char*) and BuildPack(char*) -> int,
  GetBaseChara(char*) -> CCharacter2*. BuildBase(char*) and GetNeedFilePath(char*) have no
  caller that reads the result: int assumed (marked @unknownret).
- ClearBaseFromLevel: m2c says void (Ghidra's int is a leftover register).
- CCharacter2 vtable slots used: +0xEC Copy(CCharacter2&, mgCMemory*), +0xF0 GetCopySize,
  +0xD4 (per-step update), +0x10 SetPosition, +0x18 GetPosition, +0x38 draw, +0x54 show.

## Native C++ calls

`CEffectScriptMan::DeleteEffSpt` releases the collision primitive through `CColPrim::Delete(owner)` and frees the three owned `u_long128*` blocks with `mgCMemory::Free`, ending with the work block. `AssignSprite` obtains its array storage with `mgCMemory::Alloc` before placement array construction. Direct typed member calls reproduce the retail code.

The local stack access helpers are ordinary C++ static functions. The two `SetStack` overloads write through reference slots only when `RS_STACKDATA::type == 3`. Retail symbol listings append numeric suffixes where same-named local helpers occur in earlier units; their instruction bodies are identical to the unsuffixed native C++ object functions apart from relocated branch addresses.

`CEffectScriptMan::SetCharacter` reaches `slot[group][slot]` at offset 0x184. Native two-dimensional indexing preserves the address but MWCC reverses both commutative `addu` operands (99.88%); staging the row first leaves one reversed `addu` (99.94%). Typed pointer and flat indexing variants were also tested and did not reproduce retail operand order, so the byte-offset expression remains pending an exact typed form. This function remains a `NONMATCHING` C++ draft with an active `INCLUDE_ASM` fallback. Four sprite-command stack advances likewise changed scheduling when written as `stack += n` or `&stack[n]`; their byte-address forms remain pending.

The `CRunScript` member at offset 0x50 is constructed after raw `_EFF_SCRIPT` placement allocation succeeds. Native member placement new through the project overload adds an `operator new` call (98.11%); an inline void-pointer placement overload adds a second null check (98.13%). Native placement construction of the whole `_EFF_SCRIPT` scored 97.20%. The explicit constructor symbol remains for exact matching.

An inline placement overload taking `CRunScript*` or `CRunScript&` still emits
an extra null branch before the native constructor call (98.125%). Native
placement construction of `_EFF_SCRIPT` shifts the branch and long-lived
register assignments (97.203%). Splitting allocation from construction adds
another guard (94.25%). All of these forms preserve construction semantics
but fail retail object matching, so the original call remains.

MWCC 3.0 accepts `script->run.CRunScript()` as source, but it constructs a
temporary at a stack address instead of the `run` member; the result is both
semantically wrong and only 98.45% matching. The compiler's `-help` exposes
no option to suppress the placement-new null guard. The native member form
adds a branch and delay-slot instruction in the middle of `CreateEffSpt`, so
relocation rebinding alone cannot restore the retail instruction stream.

The script's local `GetStackString` returns the pointer stored in a stack
slot. Typing its return as `char*` removes the integer-to-pointer casts at
its call sites; all affected functions remain exact.

A direct native allocation, `script = new (work_memory->Alloc(0x17)) _EFF_SCRIPT`,
constructs the `CRunScript` member and preserves the 0x500-byte function size,
but scores 97.20%. At the allocation site it puts `beqz v0` before the move
into the saved script register, while retail moves first and branches on that
register. It places the constructor argument in the call delay slot; retail
places it in the branch delay slot and leaves the call delay slot empty. The
new expression also swaps the saved registers used for the script and work
token through the rest of `CreateEffSpt`. The original explicit call restores
100% and remains pending a native C++ source form with the same schedule.
## Pending code matches

`_INTERSECTION_POINT` tests a segment against scene collision polygons and returns the hit
index, position, reflection, area kind, and footstep sound according to its argument count.
Its native C++ function passes the full linked-image comparison. Array indexing through the
polygon cursor preserves retail register allocation; indexing from the original local array
changes it.
## Constructor call cleanup

`BuildBase(int, ...)`, `CreateEffSpt(int, int, int)`, `AssignCharacter`, and
`SetCharacter` retain C++ drafts under `NONMATCHING`; the matching build selects
their retail `INCLUDE_ASM` bodies. Their `CCharacter2` allocations now use
typed placement construction, which supplies the constructor chain without
explicit vtable stores. The `CreateEffSpt` draft also constructs its
`CRunScript` member through typed placement new and uses the named
`RS_STACKDATA::val` union and `CMap::map_info` fields. These draft changes have
not established byte matches.

## Remaining constructor schedules

`AssignCharacter` and `BuildBase(int, ...)` each differ by exactly two
instruction words with the pinned compiler profile. At caller +0xB4/+0xB8
and +0x258/+0x25C respectively, retail tests operator-new's v0 result and
copies it to s2 in the branch delay slot; the compiler copies first and
tests s2. The existing natural character constructors account for the
remaining initialization. Both are parked for the dedicated placement-new
investigation, with no new constructor/header changes.

`SetCharacter` differs by 24/168 words, body 0x29C within retail 0x2A0.
Both allocation paths exhibit the same null-test issue. In the registered
path the compiler also exchanges the saved entry and character registers
through initialization and copy. Storing the new-expression straight into
the character member does not resolve this. Its existing guarded source
remains pending a natural table-index form and allocation-result schedule.
Reconsider when placement lowering is understood and a typed indexing form
preserves the entry lifetime.

`CreateEffSpt` constructs the whole `_EFF_SCRIPT` through its natural
new-expression; the compiler constructs its `CRunScript` member at +0x50.
The native draft is 0x500 bytes, retail's extent, and differs in 206/320
words, closer than the previous 0x510-byte draft's 224/324 side-by-side
words. The prior explicit operator-new plus member placement-new added an
extra allocator call and null branch. The retained whole-object form still
changes allocation-result branch placement and saved script/work-token
registers, and its character allocation also has the known null-test
remainder. It remains guarded. Reconsider with an admissible whole-object
constructor schedule; explicit constructor calls or dummy wrappers are not
solutions.

## Collision primitive manager declaration

The effect script collision command uses ColPrimMan through its owning
header, dng_main.hpp. Including that header removes the duplicate source
extern without changing the manager's type, linkage or any function body.
The complete isolated object preserves 0xEA7C checked bytes and 1,285
resolved relocations; the production PAL build and all 149 objects pass.
The header and its defining source are unchanged.

Probe: .private/fixes-r0/probes/effscript-header/{compile,objects}.log.
Production receipts: .private/fixes-r0/effscript-final-{build,objects}.log.
