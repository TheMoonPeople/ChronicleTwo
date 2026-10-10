# pot: reverse-engineering notes

Carried/thrown pot (`CPot`, global `BTsubo`), its broken form (`CBPot`, global `BTsubo2`) and
the broken pieces (`CFragment`). Both globals are defined in dng_main (`dng_main.hpp` externs).
No counterpart exists in the first game's decompilation.

## Sizes
- `CFragment` 0x60: `__sinit_dng_main_cpp` steps by 0x60 from `BTsubo2+0x40` to `BTsubo2+0xC40`;
  `CBPot` loops use stride 0x60.
- `CBPot` 0xC50: symbol size of `BTsubo2`. Last field at 0xC40 (4 bytes); the rest is 16-byte
  alignment padding from the vector members.
- `CPot` 0x80: symbol size of `BTsubo`. Last field 0x70; rest is alignment padding.
- Gaps 0x08-0x0F (CFragment, CPot), 0x14-0x1F and 0x34-0x3F (CBPot) are alignment padding before
  `sceVu0FVECTOR` / `CFragment` members, not fields.

## Constructors
`__sinit_dng_main_cpp` calls `CPot::Init(0)` on BTsubo, then `CFragment::Init` on each of the 32
pieces, then `CBPot::Init` -> inline ctors `CPot(){Init(0);}`, `CFragment(){Init();}`,
`CBPot(){Init();}` (no dtor, so no `__construct_array`). No vtables.

## CFragment
| off | field | evidence |
|---|---|---|
| 0x00 | `no` int | Init -1; SetObject2 stores running count of frames found |
| 0x04 | `active` int | Set =1; Draw/Step skip when 0 |
| 0x10 | `position` vec | Set copies arg1; Step adds velocity; Draw subtracts origin |
| 0x20 | `velocity` vec | Set copies arg2; Step adds 0x30 each step; reflected *0.5 on hit |
| 0x30 | `gravity` vec | Set = (0,-0.5,0,1) |
| 0x40 | `rotation` vec | Step: x -= dx*0.0625, y = 0, z -= dz*0.0625, each wrapped to [-pi,pi]; Draw passes to frame vt 0x1C (SetRotation) |
| 0x50 | `frame` mgCFrame* | from `mgCFrame::SearchFrame`; `->attr` (0xF4) draw |= 1, obj_alpha (0x44) = alpha; vt 0x10 SetPosition |

## CBPot
| off | field | evidence |
|---|---|---|
| 0x00 | `timer` | Clash = 60; Step decrements while >= 2, steps pieces; ==1 -> parts->Show(0) (vt 0x54); alpha = timer/30 below 30 |
| 0x04 | `type` | SetObject2: kind 0 -> 1 (box), 1..4 and 6 -> 2, 5 -> 3, else return 0. Read as `DAT_01eddf54` in CPot to pick SE 0x39/0x3A/0x3B |
| 0x08 | `parts` CMapParts* | SetObject2 arg; Clash calls vt 0x54 (Show(1)) and vt 0x10 (SetPosition) |
| 0x0C | `piece` CMapPiece* | `SearchPiece("rnd_obj02-m0")` |
| 0x10 | `frame` mgCFrame* | `piece+0x70` (CObjectFrame::frame); SearchFrame("%s%02d") base; Clash sets attr draw |=1 and SetPosition |
| 0x20 | `position` vec | Clash copies arg1; Step builds a +-100 box around it for `CScene::GetColPoly(...,0x200)`; Draw origin |
| 0x30 | `fragment_num` | 12/10/9 per type |
| 0x40 | `fragment[32]` | loop bound 0x20 in Init and SetObject2 |
| 0xC40 | `offset` float(*)[4] | `box_offset` / `iwa0_offset` / `iwa1_offset`, stride 0x10 |

SetObject2 frame names: "%s%02d" with "box" (type 1) or "rock" (types 2, 3), index 1..n. Clash:
piece velocity = offset*0.25 + arg3, piece position = arg1 + offset. The two offset and fragment
indices advance together but remain separate locals for the retail register allocation; typed
array access still matches `Clash` exactly. Clash arg2 is unused (FlyStep
passes the hit poly normal; Bakuhatsu passes its own arg1 through). Step's local `CCPoly[0x200]`
buffer is 0xA000 bytes.

## CPot
| off | field | evidence |
|---|---|---|
| 0x00 | `state` | Hold = 1, Throw = 2; Step dispatches 1 -> HoldStep, 2 -> FlyStep. Read by event_func `_GET_BPOT_STATUS` |
| 0x04 | `parts` CMapParts* | Hold arg; vt 0x18 GetPosition, 0x10 SetPosition |
| 0x10 | `position` | HoldStep GetPosition into it; read by `_GET_BPOT_POS` and DngStep (BTsuboCol coord) |
| 0x20 | `velocity` | Throw: (sin(rotY)*10, 2.5, cos(rotY)*10) from character 0 vt 0x24 (GetRotation); DngStep uses it for the dropped item's direction |
| 0x30 | `gravity` | Throw = (0,-0.5,0,1) |
| 0x40 | `hold_pos` | HoldStep: copy of position; Throw starts from it |
| 0x50 | `prev_hold_pos` | HoldStep copies 0x40 here before updating; not read in pot |
| 0x60 | `break_pos` | Clear and FlyStep's smash copy position here; DngStep drops an item at break_pos + (0,10,0) |
| 0x70 | `fly_time` | FlyStep increments; >= 150 -> Init(0), return 2 |

`Init(1)` (after a smash or Clear) keeps velocity and break_pos; `Init(0)` resets all. Clear moves
the part 1000 units down (hides it). FlyStep hides piece "rnd_obj01-a" (Show(0)), on a hit plays
the type SE, calls `BTsubo2.Clash(position, hit_normal, reflected_velocity*0.5)` and returns 1.
Step returns 0/1/2 (`POT_STEP_RESULT`); DngStep treats 1 and 2 alike.

## Collision splash
CFragment::Step and CPot::FlyStep run `CheckHit(...,1,4)`; on a miss, `CheckHits(...,0x20,...,1,0)`
and for each hit poly whose `area_kind` (CCPoly+0x44) is 7 or 1, `CScene::GetEffect(0)` ->
`CreateEffSpt(at_1196, -1, 0)` + `SetScriptVect1(hit_point,-1,-1)`. `at_1196` is SJIS
"足水パシャ" (water splash). No `area_kind` enum exists yet; 1 and 7 are presumably water kinds.

## Globals
`box_offset` float[12][4], `iwa0_offset` float[10][4], `iwa1_offset` float[9][4] in .data (not
const), sizes 0xC0/0xA0/0x90 from the symbol table. `CalcReflectionVector` is global (not in
local_symbols.tsv).

## Strings (rodata)
`at_1323__2` "box", `at_1324` "rock", `at_1325__2` "rnd_obj02-m0", `at_1326` "%s%02d",
`at_1438__4` "rnd_obj01-a", `at_1196` splash effect name.

## BPOT_TYPE use

`CBPot::SetObject2`, `CBPot::Init` and `CPot::Bakuhatsu` name the broken-object
kinds with `BPOT_TYPE_*` like `CPot::Break`. The offset tables retain their
actual binary32 values, including values close to 3.2 and 3.6.
