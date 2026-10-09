# funcpoint: reverse-engineering notes

`CFuncPointMngr::Add(int, mgCMemory*)` is accepted native C++ with one scoped
placement row for `CList<CFuncPoint>`. No `NONMATCHING` guards or assembly
fallbacks remain in this unit. See
[placement conversion](../satansfiddle/placement-new.md).

The active native functions in this unit compile to exact retail instruction matches. `GetEventNum`
tests `CFuncPoint::EventData::flag` at offset 0x20, and `UpdateFlag` stores each point's `Check`
result in `CFuncPoint::active` at offset 0x1B0 before counting successful checks. The two walk
functions use `CFuncPointMngr::GetEnd` to clear `now` after traversal.

Header: `ps2/include/funcpoint.hpp`. No first-game counterpart: `CFuncPointMngr`, `CObjAnime`,
`CFuncPointCheck` and `CObjAnimeEnv` do not exist in `/home/adubbz/development/chronicle`.

## Ownership
- `CFuncPoint` (0x1C0) and `FUNC_POINT_TYPE` (0..9, `FUNC_POINT_TYPE_NUM` = 10) are owned by
  `mapload` and declared in `mapload.hpp`; this header includes it. `CFuncPoint::Initialize` and
  `CFuncPoint::Check` live in this unit's `.text` but are declared there.
- `CList<CFuncPoint>` uses the template in `mg_tanime.hpp` (inline ctor + virtual inline
  `Initialize`); both emitted copies (0x2A1260, 0x2A13E0) come from that template.
- `CheckOver__FPfPfPf` (0x2A0530) is LOCAL in retail: `static` in the `.cpp`, not in the header.
  It is called only by `CObjAnime::Step` and tells whether a value moving by a speed has passed a limit.

## CFuncPointMngr (0x34)
| Offset | Field | Evidence |
|---|---|---|
| 0x00 | `u32 flag` | `UpdateStatus` ORs `FUNC_POINT_MNGR_FLAG` bits into it |
| 0x04 | `CList<CFuncPoint> *list[10]` | `Initialize` zeroes 0x04..0x2B; `GetStart/Add/EnableFuncNum` index `this+4+type*4`, bound 10 |
| 0x2C | `CList<CFuncPoint> *now` | `GetStart` sets, `Get` advances via `node->next`, `GetEnd` clears |
| 0x30 | vptr | `CMap`/`CMapParts`/`CEditParts` ctors store `__vt__14CFuncPointMngr` at mngr+0x30 then call `Initialize` (the inline ctor) |

Size 0x34: in `CMapParts` the manager is at 0x2B0 and a `CFuncPointCheck` follows at 0x2FC
(`CopyFuncPointCheck`), in `CMap` at 0xCB0 with vptr at 0xCE0. Vtable: `{0, 0, Copy, 0}`, only `Copy`
is virtual.

- `list[0]` (`FUNC_POINT_NONE`) is the reserve list: `Reserve` adds every new node with type 0,
  `GetReserve` pops from it, `Search` and `UpdateStatus` start at type 1.
- `Get` returns `&node->data` (node+0x10); `CList<CFuncPoint>` node is 0x1E0 (`operator new(0x1E0)`
  in `Add(int, mgCMemory*)`, stride 0x1E0 in `Reserve`'s `__construct_new_array`), vptr at node+0x1D0.
- `Add(int, CList*)` sets `data.type` (node+0x14 = CFuncPoint+0x4) to the kind.
- `UpdateFlag` stores `Check()`'s result at CFuncPoint+0x1B0; `EnableFuncNum` counts it (node+0x1C0).
- `GetEventNum` walks type 6 and tests CFuncPoint+0x20 against the mask (`FUNC_EVENT_FLAG`).
- `Step` is a bare tail jump to `UpdateFlag`; whether it returns the count cannot be told from the
  code (both forms compile to `j`). No caller (`CMap::PreDraw`, `CMapParts::StepFuncPoint`) uses a
  result, so it is declared `void`.
- `Copy` returns 1 always; copies field by field (uses `mgVu0FBOX::operator=` at +0x30 and
  `mgCFrame::operator=` at +0x70 of CFuncPoint).

### FUNC_POINT_MNGR_FLAG (from UpdateStatus)
0x1 any point; EFFECT(1) -> 0x10; FIRE(2) -> 0x86 (+0x40 if CFuncPoint+0x38 != 0); FLARE(3) -> 0xA
(+0x40 if +0x38 != 0); PLIGHT(4) -> 0x20 (+0x40 if +0x38 == 2); SOUND(8) -> 0x80; EVENT(6) -> 0x100.

## CObjAnime (0x30)
| Offset | Field | Evidence |
|---|---|---|
| 0x00 | `CFuncPoint *func_point` | ctor 0x1616B0; `AssignFuncAnime` requires `type == FUNC_POINT_ANIME` (5) |
| 0x04 | `mgCFrame *frame` | `AssignFuncAnime`: `SearchFrame` on the piece's frame (piece+0x70) |
| 0x08 | `CMapPiece *piece` | `CMapParts::SearchPiece` result |
| 0x0C | `CMapParts *parts` | argument |
| 0x10 | `s32 stop` | `Step` returns at once if set; set in mode 5 when finished |
| 0x14 | `s32 back` | ping-pong direction; negates speed in `Step` |
| 0x18, 0x1C | unk | never touched; padding before the aligned vector |
| 0x20 | `sceVu0FVECTOR param` | `GetParam` fills it, `SetParam` writes it |

Size: stride 0x30 in `CMap::AnimeStep` (array at CMap+0xC90, count at +0xC8C). The ctor (in map)
is inline in the header. `SetParam` calls the frame/piece/parts through a vtable (they share a
`CObject`-style base); the target is `frame`, else `piece`, else `parts`.

Animation data inside CFuncPoint (offsets from CFuncPoint): +0x2C param kind (`OBJ_ANIME_PARAM`),
+0x30 mode (`OBJ_ANIME_MODE`), +0x34 s16 "uniform" flag (copy x to y,z), +0x36 s16 flag for
applying position in piece space, +0x40 start vector, +0x50 speed vector (also time start/end/fade
at +0x50/+0x54/+0x58 for mode 10), +0x60 end vector. Mode 6 additionally needs param kind 2.
These belong to `CFuncPoint`'s layout (mapload).

### OBJ_ANIME_MODE (switch in Step)
1 loop add; 2 add then clamp to end; 3 add then wrap to start; 4/5 ping-pong (5 sets `stop` on
return); 6 look at `env->chara_pos` (atan2, clamped between start and end); 7 random in [start,end];
8 `y = 360 * -time`; 9 `y = 360 * -time/12`; 10 lerp by `CheckTime`/`SubTime` fade.

### OBJ_ANIME_PARAM (switch in SetParam/GetParam)
1 position (vtable +0x10), 2 rotation (degrees, wrapped at +-360000, converted to radians),
3 scale, 4 colour, 5 alpha.

## CFuncPointCheck (0x8)
+0 float time (`CMap::GetNowTime`), +4 s32 anime frame (CMap+0xCE8). Built on an 8-byte stack slot
in `CMap::AnimeStep` with +0 zeroed first, which is the inline ctor.

## CObjAnimeEnv
+0x00 player position (quad load), +0x10 float time of day. Only these two offsets are read
(`Step`); built by callers reached virtually, so its full size is not established and it has no
STATIC_ASSERT (alignment alone makes it at least 0x20).

## Globals
None. `sp_3d_1174`, `frame_1203`, `Bound_1206`, `attr_1207` and the `init_*` guards are
function-local statics (DrawFireEffect / GetLight area); `at_475`, `at_1118` are literals.

## Unresolved
- `Step` return type (see above).
- `GetLight`'s `mode` and `DrawFireEffect`'s `rate` parameter meanings are inferred from use only loosely.

## Division-check pragma

The unit-level `divbyzerocheck` pragma was redundant with the global MWCC flag; removing it left the full compiled object identical in objdiff.

## Light-animation native candidate

`GetLightAnimeWeight` reads the point-light flicker depth and period before checking
its point type; even fire and flare points therefore perform the period conversion.
Point-light mode zero returns one; random mode scales a random fraction between
`1-depth` and one. The sine mode uses the signed frame remainder and a full-turn
angle, while the saw mode falls linearly with that remainder. A nonpositive period
returns one without performing a remainder operation. Fire and flare return a random
weight between 0.7 and one; other point types return one.

The original guarded candidate produced 0x228 bytes versus retail's 0x220.
The native source now gives the signed remainder a named `phase` local before
converting it to float in the sine and saw modes. The sine angle multiplies that
phase by the full-turn constant before dividing by the period. The current
native source is accepted by complete-object and PAL verification; the earlier
size-equality observation alone did not establish that match.

## Earlier `CFuncPointMngr::Add(int, mgCMemory*)` trials

Before scoped compiler conversion, the typed draft differed only in the null
branch: retail tested `v0` and copied into `s0` in the delay slot, while MWCC
copied first and tested `s0`. Node construction and calls agreed, but the
linked image differed by seven bytes, so that baseline retained assembly.
Combining allocation with the null test, changing the later branch layout,
removing the redundant allocator cast, separating the buffer, and changing
the pointer declaration or constructor parentheses all retained the pair.
Scheduling and optimizer pragmas left the pair or changed many additional
instructions. The current accepted caller retains natural construction.

A private trial used the typed allocation pointer without the redundant cast,
scoped `optimization_level 2` to this function, and restored level 3 immediately
after it. The rest of the translation unit remained byte-identical, but the
function grew from retail's 0xA0 to 0xC4 bytes and scored 56.35%. The allocation
branch then tests the saved register and adds extra copies and nops, so this
optimization-level change is not a useful match.

The [earlier placement-new report](placement-new.md) preserves the constructor
evidence and allocation-result issue measured before scoped conversion. Retail's point constructor
and array-node constructor do not initialize the point's other fields. Adding
that initialization to the shared constructor changes five complete units and
fails PAL verification (144/149 object checks pass). Compiler-generated,
empty, specialized, and source-defined inline constructor variants do not
reproduce the target's two differing instructions. A matching invented inline
consumer is retained only as private evidence; it is not admissible source.
Those trials retained the guarded draft pending genuine constructor and
allocation-result evidence. The current native caller resolves the schedule
through the documented compiler conversion without an invented helper.
