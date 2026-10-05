# effect: reverse-engineering notes

## C++ draft status
All 75 functions have C++ in `ps2/src/effect.cpp`. 16 are exact and compiled by
the matching build. 37 more compile to retail's bytes in isolation but stay
under `NONMATCHING`. 22 differ from retail and keep the `INCLUDE_ASM` fallback.
Each function tried has its one promotion attempt recorded in
`scripts/re/promotion_attempts.tsv`.

Scripted particle effects. An effect file is a script (tags in `effm_tag`, run through
`CScriptInterpreter`) that declares buffer sizes, an image archive, wait frames, and one or more
`EFFECT_START ... EFFECT_END` emitter blocks. `CEffectManager` owns one effect; `CEffectCtrl` is
one emitter; `CEffect` is one particle; `EFFECT_PARAM` is the per-particle description copied into
a `CEffect` on spawn.

No first-game counterpart in layout: the first game's `effect.hpp` (`CEffectParam` 0xE0,
`CEffect` 0x100, `C3DSprite`) is a different, simpler system. Field names here follow this game's
script tag names (`__VELO`, `__MOVE_P1`, `__SCALE_TYPE`, ...), which are retail.

## Sizes
- `EFFECT_PARAM` 0x1B0: `CEffect::SetEffect` does `memcpy(this + 0x50, param, 0x1B0)`.
- `CEffect` 0x200: `__construct_new_array(..., 0x200, n)` in `CEffectList::LoadEFPFile`; stride
  0x200 in `CEffectManager::Draw/Step` and `CreatePacket`. 0x50 header + 0x1B0 param.
- `CEffectCtrl` 0x310: `__nw(0x310)` in `__EFFECT_START`; stride 0x310 everywhere;
  `__construct_new_array(..., ctor 0x1816E0, dtor 0x181710, 0x310, n)`.
- `CEffectManager` 0x184: `__construct_new_array(..., 0x184030, 0, 0x184, n)` in LoadEFPFile.

No class has a vtable (constructors store none; `~CEffectCtrl` is a plain non-virtual dtor).

## EFFECT_PARAM (offset in param / in CEffect = +0x50)
Established from `InitEffectParam` (defaults), `CEffectCtrl::Ctrl` (fills a stack EFFECT_PARAM
`sp70` from the emitter), `CEffect::Step/Draw`, `CEffectManager::CreatePacket`.
- 0x00 life (Step kills when frame > life); 0x04/0x08 width/height (Draw multiplies by scale);
  0x0C dir (from ctrl 0x20, never read in this unit).
- 0x10 pos, 0x20 velo, 0x30 acc, 0x40 velo_mul (def 1.0), 0x50 acc_mul (def 1.0): Step does
  pos+=velo; velo+=acc; velo*=velo_mul; acc*=acc_mul.
- 0x60..0x68 move_type[3]; 0x6C never touched. 0x70 move_p1, 0x80 move_p2.
- 0x90..0x98 scale_type[3] (ctrl 0x170..0x178; tag sets only two); 0x9C untouched.
- 0xA0 scale (def 1.0; only x,y used), 0xB0 svelo, 0xC0 scale_p1, 0xD0 scale_p2.
- 0xE0 alpha_blend, 0xE4 alpha_type, 0xE8 alpha (def 1.0), 0xEC alpha_p1, 0xF0 alpha_p2.
- 0xF4 texture (mgCTexture*; Step kills particle if NULL; Draw/CreatePacket pass it as texture).
- 0xF8 int tex_rect[8][4] (8-iteration 0x10-stride loop in InitEffectParam; x,y,w,h per Draw).
- 0x178 tex_get_type; 0x17C tex_frame (= life / tex_rect_num when tex_get_type != 0).
- 0x180 gravity flag; 0x184..0x18C untouched; 0x190 gravity_pos (ctrl gravity + origin);
  0x1A0 gravity_accel (default 0x411CE80A = 9.80665), 0x1A4 gravity_mass (default 10.0).
  Step: d = gravity_pos - pos; step = d * (accel*mass)/|d|^2, abs per axis, moves each axis
  towards gravity_pos without overshoot. The two float names are a hypothesis from the default
  9.80665 (standard g); only their product is used.
- 0x1A8/0x1AC untouched.

## CEffect header (0x00..0x4F)
- 0x00 active, 0x04 frame (int), 0x08 alpha (float, clamped 0..1, *128 in Draw), 0x0C unknown
  (never accessed in this unit).
- 0x10 pos (copied from param.pos each Step, w=1, then move curves applied); 0x20 scale (copied
  from param.scale, w=1, scale curves applied to x,y).
- 0x30 int tex_rect[4] (TextureCrd/width/height in Draw; CreatePacket converts to float).
- 0x40 tex_count, 0x44 tex_index: when param.tex_get_type != 0, tex_count++ and on
  > tex_frame tex_index++; tex_rect = param.tex_rect[tex_index].
- 0x48/0x4C never accessed.

## CEffect::Step curve switch (EFFECT_CHANGE_TYPE, jump table `at_383`, 7 entries)
Loop over 6 channels: (type, p1, p2, target) = (move_type[0..2], move_p1.xyz, move_p2.xyz,
pos.xyz), (scale_type[0..1], scale_p1.xy, scale_p2.xy, scale.xy), (alpha_type, alpha_p1,
alpha_p2, alpha). L = life (float), f = frame:
- 1: v += p2*(p1/L)*f; 2: v -= same.
- 3: T=L*p2; v += p1/T * min(f, T).
- 4: T=L*p2; if f > T: v -= p1/T * (f-T).
- 5: T=L*p2; rise p1/T*f while f<T; if f > L-T: p1/T*(L-f); else p1/T*T.
- 6: v += p1 * sin(f * 360/(L*p2) deg) (constant 0x3F91DF46AAAAAAAB = pi/180).
Enum names (ADD, SUB, ADD_HEAD, SUB_TAIL, ADD_HEAD_TAIL, SINE) are descriptive, not retail.

## Random types (EFFECT_RAND_TYPE)
Every `*_RAND` tag sets (type, range..., sample count). 0 = value used as-is; 1 =
`UniformityRand(base, range)` = base + U(0,1)*range - range/2; 2 = `RegularityRand(base, range, n)`
= base + range * mean of n (U-U) samples. Sample counts default to 1.

## CEffectCtrl (offset -> tag / evidence)
0x00 origin (SetOrigin, sceVu0CopyVector in operator=; added to pos and gravity_pos on spawn);
0x10 run (Run=1, Stop=0; Ctrl does nothing unless run != 0 and entry != 0; cleared when
repeats run out or REPEAT is off, after the batch);
0x14 entry (EnterEffectCtrl sets 1; manager loops skip slots with 0); 0x18/0x1C SIZE; 0x20 DIR;
0x24 NUM; 0x28/0x2C/0x30 NUM_RAND; 0x34 COUNT (particle life); 0x38/0x3C/0x40 CNT_RAND;
0x44 REPEAT arg0 (==1 enables), 0x48 and 0x4C REPEAT arg1 (base wait / current wait),
0x60 REPEAT arg2 (repeat_num, default -1 = forever); 0x50 timer, 0x64 batch counter (Run resets
both); 0x54/0x58/0x5C REP_RAND; 0x68/0x6C untouched; 0x70 POS; 0x80 POS_RAND type, 0x84..0x8C
untouched, 0x90 POS_RAND ranges, 0xA0 POS_RAND count; 0xA4..0xAC MOVE_TYPE; 0xB0 VELO;
0xC0 ACC; 0xD0 VELO_MUL; 0xE0 ACC_MUL; 0xF0 MOVE_P1; 0x100 MOVE_P2; 0x110..0x11C rand types
(VELO, ACC, MOVE_P1, MOVE_P2 _RAND arg0); 0x120..0x150 ranges; 0x160..0x16C counts;
0x170/0x174 SCALE_TYPE (0x178 initialised/copied, not set by tag); 0x17C untouched;
0x180 SCALE; 0x190 SVELO; 0x1A0 SCALE_P1; 0x1B0 SCALE_P2; 0x1C0..0x1CC rand types;
0x1D0..0x200 ranges; 0x210..0x21C counts; 0x220 ALPHA_BLEND; 0x224 ALPHA_TYPE; 0x228 ALPHA;
0x22C ALPHA_P1; 0x230 ALPHA_P2; 0x234..0x23C rand types, 0x240..0x248 ranges, 0x24C..0x254
counts; 0x258 TEX_GET_RECT count; 0x25C tex_rect[8][4]; 0x2DC TEX_NAME (mgTexManager.GetTexture);
0x2E0 TEX_GET_TYPE; 0x2E4 gravity flag (GRAVITY sets 1); 0x2E8/0x2EC untouched; 0x2F0 GRAVITY
xyz; 0x300/0x304 GRAVITY args 4/5 (defaults 9.80665 / 10.0); 0x308/0x30C untouched.
When tex_get_type == 0, Ctrl picks `rand() % tex_rect_num` and puts that rectangle in
param.tex_rect[0]; otherwise it copies all 8 and sets tex_frame = life / tex_rect_num.

## CEffectManager
0x00 name[32] (byte 0 cleared in ctor; strcpy'd by CEffectList::LoadEFPFile; strcmp'd by
SaerchEffectIndex); 0x20 effects, 0x24 effect_num, 0x28 ctrls, 0x2C ctrl_num (EntryEffCtrls,
SetEffectNums); 0x30 load (Load sets 1); 0x34 ctrl_index (Initialize sets -1; Ctrl: when != -1
only that emitter is started once; no writer other than Initialize found); 0x38 run; 0x3C wait
counter (saturates at 0x7FFFFFFF); 0x40 next_ctrl; 0x44 wait_frame[8] (WAIT_FRAME idx, frames);
0x64 ctrl_name[8][32] (EnterEffectCtrl); 0x164 img_name[32] (IMG_NAME; read by character's
`_EFFECT` to load the texture archive).
CreatePacket's alpha mapping: alpha_blend 1 -> SetAlpha(2 ADD), 2 -> 3 (SUB), else 4 (opaque).
CEffect::Draw has a retail bug: checks `alpha_blend == 1` twice, so SUB (2) draws as mode 4.

## Globals (all LOCAL in retail -> static in effect.cpp, no externs in the header)
- `effm_tag` (0x3390F0, 0x180 = 48 SPI_TAG_PARAM of 8 bytes): tag table for the effect script.
- `g_tmp_effm` (CEffectManager*), `g_tmp_effc` (CEffectCtrl*, the emitter being read),
  `g_eff_entry_flag` (int: 1 in Load, 0 in GetBufferNums; EFFECT_END only enters the emitter
  when set), `g_tmp_eff_name` (char[0x20], EFFECT_START name).
- Local functions (static in .cpp): `UniformityRand`, `RegularityRand`, and all `__XXX` tag
  handlers (`int f(SPI_STACK*, int)`, return 1; `__GRAVITY` returns nothing per Ghidra --
  check its asm for the v0 value). `InitEffectParam` is global (declared in header).

## Cross-unit
- `CEffectManager::CreatePacket(mgC3DSprite*)` lives in effectlist (0x17E850) but is declared
  here.
- character's `_EFFECT` stAllocs a larger block that begins with a CEffectManager and has more
  fields after 0x184 (0x184 ctrl buffer, 0x18C effect buffer, 0x198, 0x19C/0x1BC names,
  0x1DC float start time, 0x1E0 vector). That container type belongs to character, not here.
- `__EFFECT_END` passes the emitter by value to `EnterEffectCtrl` (stack copy then
  `~CEffectCtrl`), consistent with the `F11CEffectCtrlPc` mangling.
