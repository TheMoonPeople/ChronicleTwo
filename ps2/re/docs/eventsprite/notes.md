# eventsprite: reverse-engineering notes

The 17 decompiled functions in this unit compile to exact retail instruction matches. The sprite
setters access the named fields in `eventsprite.hpp`; `CEventSprite::Init` clears each logical block
separately, while `SetMove` first resets its four animation words and then selects the move mode.
`CEventSprite2::NormalDraw` and `FirstDraw` dispatch only for their respective draw pass values.

Header: `ps2/include/eventsprite.hpp`. No first-game counterpart (Dark Cloud has no
`CEventSprite`/`CMarker`). No class here has virtual functions (no `__vt__` symbols). The unit owns
no named global data: its only datum, `at_1069__4` (0x372F98, size 1), is the empty string `""`
that `CEventSprite2::Draw` compares `tex_name` against, written inline at its use (no data marker).
The instances live in `event_func`:
`esMother` (CEventSpriteMother, 0x440), `EventSprite2` (CEventSprite2[0x30], 0x1800),
`EventMarker` (CMarker, 4).

## Free functions
- `ParabolicInitialVectorY(start_y, end_y, gravity, frames)` = `((end_y - start_y) * 2 - frames * gravity * frames) / (frames * 2)`.
- `CalcPosParabolicJump(pos, start, end, gravity, frames, frame)`: `v = ParabolicInitialVectorY(start[1], end[1], gravity, frames + 1)`;
  y starts at `start[1]` and for `(int)frame` steps does `v += gravity; y += v` (the 8-way unroll in
  Ghidra is the compiler's). x and z are `LinerInterpolation(start, end, frame / frames)`, `pos[3] = 1.0`.
  Caller: `scsJump` (sceneseq).

## CMarker (size 4)
- `EventMarker` symbol size 4. +0 `count`: `Set` stores it, `Draw` decrements while > 0, `Init` zeroes.
- `__sinit_event_func_cpp` calls `CMarker::Init` on `EventMarker` -> inline `CMarker() { Init(); }`.
- `DrawEventEdit` calls `Draw` once per frame (return value unused; void).

## CEventSprite (size 0x88)
Size from the 0x88 stride in every `CEventSpriteMother` loop and the `__sinit` loop.
| Off | Field | Evidence |
|---|---|---|
| 0x00 | `draw` | `SetDraw`; `Draw` returns when 0 |
| 0x04 | `tex_block` | `Draw`: `mgTexManager.ReloadTexture(+4, 0)`; `Mother::Set` stores its 2nd arg |
| 0x08 | `name[0x40]` | `SetName` strcpy; `Init` memset 0x40; `GetTexture(name, -1)` |
| 0x48 | `color[4]` int | `SetColor`; `Init` memset 0x10; `Draw` `Color(r,g,b,a)`; `Mother::Set` = 0x80 each; fade drives [3] |
| 0x58 | `get[4]` int | `SetGet`; `Draw` TextureCrd(x,y) and (x+w, y+h) |
| 0x68 | `put[4]` int | `SetPut`; `Draw` Vertex(x,y) and (x+w, y+h); move drives [0],[1] |
| 0x78 | `anime[4]` int | `Init` memset -1 0x10; `SetMove`/`SetFade` reset all four to -1 first |
`anime` layout: [0] type (`EVENT_SPRITE_ANIME`: -1 none, 0 move, 1 fade).
Move: [1] target x, [2] target y, [3] frames left. Fade: [1] target alpha (0x80 if `fade_in` != 0
else 0), [2] frames left, [3] unused (-1). `Step` uses `LinerInterpolationI(cur, target, 1, frames+1)`
and resets `anime` to -1 when the target is reached. Kept as one array because `Init` clears it with
a single 0x10 memset; a struct of four ints would also fit.
- `Draw` primitive: `Begin(6)` (sprite), alpha blend 1, alpha test, no depth test, point sampling.
- Inline ctor `CEventSprite() { Init(); }` inferred from `__sinit_event_func_cpp`, which loops
  `CEventSprite::Init` over `esMother` in 0x88 steps (member-array construction) and then calls
  `CEventSpriteMother::Init` (the Mother's inline ctor).

## CEventSpriteMother (size 0x440)
`esMother` size 0x440 = 8 * 0x88; index checks are `0..7`. Every `SetX(no, ...)` returns 1, or 0
when `no` is out of range. `Set(no, tex_block)`: `Init`, `SetDraw(0)`, `tex_block`, color all 0x80.

## CEventSprite2 (size 0x80)
`__construct_array(EventSprite2, __ct__13CEventSprite2Fv, 0, 0x80, 0x30)` in `__sinit_event_func_cpp`;
`EdEventInit` loops `Initialize` with stride 0x80; `GetEventSprite(i)` indexes 0..0x2F.
| Off | Field | Evidence |
|---|---|---|
| 0x00 | `draw_flag` | `SetDrawFlag`; `NormalDraw` draws when 1, `FirstDraw` when 2; `Draw` zeroes it for an unknown type |
| 0x04 | `sprite_type` | `SetSpriteType`/`GetType`; `Draw`: 1 world billboard (`mgTransWorldPrim3DSprite`), 0 screen; else hidden |
| 0x08 | `tex_block` | `SetTexture` 2nd arg; `ReloadTexture(+8, 0)`; init -1 |
| 0x0C | `tex_name[0x20]` | `SetTexture` strcpy; init memset 0x20; `""` means untextured |
| 0x2C | `alpha_blend` | `SetAlphaBlend`; `AlphaBlend(+0x2C)`; init 1 |
| 0x30 | `pos` (FVECTOR) | `SetPosition` 4 floats; `GetPosition` `sceVu0CopyVector` (lq -> 16-aligned); `Draw` 3D sets [3]=1.0 |
| 0x40 | `color` (FVECTOR) | `SetColor`/`GetColor` (CopyVector); `Color(float*)`; init 128.0 each |
| 0x50 | `rot_z` | `SetRotZ`/`GetRotZ`; `Draw` 2D: 0 -> `Begin(6)` sprite, else rotated quad `Begin(4)` with sin/cos |
| 0x54 | `put_w` | `SetPutSize`; width = put_w * scale_x |
| 0x58 | `put_h` | `SetPutSize`; height = put_h * scale_y |
| 0x5C..0x68 | `uv_x uv_y uv_w uv_h` | `SetUvSize`; TextureCrd(x,y), (x+w,y+h) |
| 0x6C | `scale_x` | `SetScale`/`GetScale`; init 1.0 |
| 0x70 | `scale_y` | `SetScale`/`GetScale`; init 1.0 |
| 0x74..0x7F | padding | alignment of the 16-byte-aligned vectors makes sizeof 0x80 |
`pos`/`color` are `sceVu0FVECTOR` so the class is 16-aligned and pads to 0x80 naturally.
Enums `EVENT_SPRITE2_DRAW` (0 off, 1 normal, 2 first) and `EVENT_SPRITE2_TYPE` (0 screen, 1 world)
come from `NormalDraw`/`FirstDraw`/`Draw`; fields stay `int` because the setters take `int`.
`CEoh::Set(type, CEventSprite2*)` (event_func) stores the sprite for an event object handle of type 2;
`CEohMother::SetRot` maps a z rotation to `SetRotZ`.

## Unresolved
- Whether `CEventSprite`/`CEventSpriteMother`/`CMarker` really have inline ctors (vs. `event_func`
  calling `Init` explicitly) is inferred from the `__sinit` shape; confirm when matching `__sinit_event_func_cpp`.
- Field names are descriptive, not retail (no retail field names available).

`CEventSprite::Draw` constructs a scoped local `mgCDrawPrim` only while the sprite is active (a 0x120-byte stack object); the scoped native object reproduces the retail stack layout and constructor call.
