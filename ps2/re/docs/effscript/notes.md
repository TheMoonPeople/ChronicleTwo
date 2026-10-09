# effscript: reverse-engineering notes

Effect script manager. No counterpart in the first game's decompilation (nothing named
EffectScript / EFF_SCRIPT / ES_SPRITE there).

## Status
183 of the 185 functions in `ps2/src/effscript.cpp` are native C++ definitions and match retail.
Two are guarded drafts (`#ifdef NONMATCHING` C++ with an `INCLUDE_ASM` fallback):
`CEffectScriptMan::CreateEffSpt(int, int, int)` (0x2E5D60, 0x500) and
`CEffectScriptMan::SetCharacter(CCharacter2 *, int, int)` (0x2A0 extent, 0x29C body). Both fail
on MWCC's placement-new allocation-result schedule: retail tests the allocator's `v0` and copies it
into the saved register in the branch delay slot, while MWCC copies first and branches on the
saved register (see [placement conversion](../satansfiddle/placement-new.md)).
`BuildBase(int, ...)` and `AssignCharacter` are native with one scoped `CCharacter2` placement
row each; `CObjectFrame`/`ColPrimMan` come from their owning headers (`dng_main.hpp` for
`ColPrimMan`).

- `CreateEffSpt`: the natural draft constructs the whole `_EFF_SCRIPT` with
  `new (work_memory->Alloc(sizeof(_EFF_SCRIPT) / 16 + 2)) _EFF_SCRIPT` (0x17 quadwords), so the
  compiler constructs the `CRunScript` member at +0x50; the character allocation is
  `sizeof(CCharacter2) / 16 + 2` (0x68). The body is 0x500 like retail and differs by 206/320
  words: retail and native agree through +0x190; at +0x194 retail branches on `v0`, copies to
  `s2` in the delay slot, calls `CRunScript` at +0x19C with `run` computed in the call delay
  slot, while native copies first, branches on `s2`, calls at +0x1A0 with a nop delay slot;
  +0x1A4..+0x4C8 matches at offset +4 except the same branch/copy pair for the character
  allocation at +0x1F8/+0x1FC; retail's final join nop at +0x4CC is absent. Script stays in
  `s2` and the work token in `s3` in both. The not-loaded-base diagnostic (0x3773D0, contains
  `[%d]`) takes `base_no` as its variadic argument. Member placement overloads, split
  allocation, an explicit `script->run.CRunScript()` call (constructs a temporary on the
  stack) and dummy wrappers all score worse and are not solutions.
- `SetCharacter`: 24/168 words. In the slot path the mutable table entry and the new
  character exchange `s1` and `s2` (20 words), plus the two allocation-result branch pairs
  (+0xD4/+0xD8, +0x1AC/+0x1B0). Typed slot access `slot[group][slot]` keeps the address but
  reverses both commutative `addu` operands (+0x9C/+0xA0); `_EFF_SCRIPT **entry =
  &this->slot[group][slot]` adds two words; staging the row first leaves one reversed `addu`.
  The entry's script is reloaded after allocation and the virtual `Copy`, and `now` is reloaded
  in the negative-slot branch; caching either changes behaviour. The manager layout it uses:
  `work_memory` +0x4, `slot[128][8]` +0x184, `now` +0x1184; `_EFF_SCRIPT::chara_work` +0x4,
  `chara` +0x8; `CCharacter2` is 0x660 with virtual `Copy` +0xEC and `GetCopySize` +0xF0.

## Source forms the match depends on
- `_SPT_VAN_SET_POS`, `_SPT_ADD_POS`, `_SPT_SET_VELO_POS`, `_SPT_SET_ACC_POS`:
  `stack = (RS_STACKDATA *) ((u8 *) stack + n * sizeof(*stack))`. `stack += n` lets MWCC fold the
  advance into the next use instead of updating the pointer register where retail does.
- `CEffectScriptMan::LoadBaseEffSpt`: `path_buffer`/`pack_buffer` are `int` addresses; the pack
  buffer is placed after the path file with byte-size padding (`& 0x3F`, `& -0x10`).
- `_INTERSECTION_POINT` indexes polygons through the polygon cursor; indexing from the original
  local array changes register allocation.
- `CEffectScriptMan::DeleteEffSpt` releases the collision primitive through
  `CColPrim::Delete(owner)` and frees the three owned `u_long128*` blocks with `mgCMemory::Free`,
  ending with the work block. `AssignSprite` obtains its array storage with `mgCMemory::Alloc`
  before placement array construction.
- The static stack helpers use `RS_STACKDATA::val.f` / `val.s` and the `RS_INT` / `RS_FLOAT` /
  `RS_PTR` type names; `GetStackString` returns `char *`; the two `SetStack` overloads write
  through reference slots only when `type == RS_PTR`. Retail symbol listings append numeric
  suffixes to these same-named local helpers; their bodies are identical to the unsuffixed
  native functions apart from relocated branch addresses.
- `_CHR_GET_FRAME_POS`, `_CHR_SET_FRAME_SHOW`, `_CHR_SET_LIGHT_COLOR`, `_SCN_GET_CHR_FRM_POS` and
  `_COLPRIM_SET_COORD` reach the inherited `mgCFrame *frame` that `CCharacter2::frame` (`float`)
  hides as `chara->CObjectFrame::frame`.

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
- Local (static in the .cpp, not in the header): `now_script` (_EFF_SCRIPT* executing external
  commands), `ext_func` (symbol file `ext_func__4`; 0x400 = 256 typed `int (RS_STACKDATA *, int)`
  callbacks, passed to `CRunScript::ext_func` with 0x100; its retail symbol must stay reachable
  for the guarded `CreateEffSpt` assembly), `ext_func_info` (symbol file `ext_func_info__4`;
  `RS_EXTFUNC_INFO[129]`, see runscript_opcodes.hpp: 128 typed callbacks followed by
  `{NULL, EFF_EXT_END}`; `EffectExternalCommand` names the retail command numbers; initializer
  order is retail's, including 252/253 and 157/158 before 155/156; declared extent 0x408, retail
  piece 0x410 with an eight-byte zero tail).
- `eff_spt_base_def` is a native array of 219 `EFF_SPT_BASE_DEF` rows (0x558C; the retail piece
  has four more zero padding bytes): rows 0..172 select character resources, 173..217 image
  resources, and the final empty-name row uses `EFF_SPT_BASE_END`. Fixed arrays preserve
  duplicate names and Shift-JIS bytes with hexadecimal escapes; apparent pointer expressions in
  the generated assembly are not relocations within these arrays.
- `_GET_DIR_VECTOR` and `_CHR_GET_DIR_VECTOR` initialize a local direction as
  `{0.0f, 0.0f, 1.0f, 1.0f}` (the 16-byte templates `at_2311`/`at_2498__2`); `DrawEffSptSprite`
  zero-initializes a local `sceVu0FVECTOR` size (`at_2067`). The `_INTERSECTION_POINT` switch
  emits its nine-entry jump table `at_3304__2` (0x24 bytes in a 0x30-byte piece).
- Strings used by native code are inline at their uses: the `%s.chr`/`%s.img`/`%s.stb` pack
  suffixes and `dungeon/eff_script/` paths, the texture-bank exhaustion diagnostic in
  `ClearBaseFromLevel`, and the command diagnostics (sprite-work exhaustion, collision polygon
  limits, unavailable collision primitives, command coordinates, effect creation failures,
  duplicate command numbers, dispatch capacity exhaustion), with Shift-JIS bytes as hex escapes.
- Seven `INCLUDE_RODATA` markers remain: `at_1336__2`..`at_1340__2` (`CreateEffSpt`
  diagnostics), `at_1341__2` (the shared empty string, also used by native code) and `at_2025__3`
  (`SetCharacter` diagnostic). Each is referenced by an active `INCLUDE_ASM` body under its retail
  symbol, so the markers stay while those two functions are guarded; the native `""` users of
  `at_1341__2` keep the extern until then.
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
