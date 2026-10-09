# DC2 scalar placement allocator census — 2026-10-08

The complete PAL top-level game-unit assembly contains **216 direct scalar
placement allocator calls in 116 callers**. The allocator identity is
`__nw__FUiP1`, `operator new(size_t, u_long128 *)`, whose retail body at
`0x00139F50` returns its buffer argument unchanged. Array allocator
`__nwa__FUiP1`, ordinary runtime `__nw__FUi`, and SDK/runtime units are excluded.

Of those calls, **178 construct nontrivial scalar objects**, **21 explicitly
call `operator new`**, and **17 allocate trivial scalar objects**. The latter
38 are exclusions from implicit constructor-null-check evidence even when
their caller checks the allocation result.

| Nontrivial construction | Retail A, guard tests v0 | Retail B, copied register is tested |
| --- | ---: | ---: |
| Inline constructor | 108 | 0 |
| Out-of-line constructor | 68 | 2 |

**No retail B site has an inlined constructor.** Both B sites occur in matched
`mapFIX_CAMERA_RECT__FP9SPI_STACKi` (`mapload.cpp`) under the same scoped
`#pragma inline_depth(0)` at source line 1449, reset at line 1522:

| Allocated type / header | Allocation / guard / constructor | Exact sequence |
| --- | --- | --- |
| `CColFrame`, `collision.hpp:243` | `0x0016462C` / `0x00164638` / `__ct__9CColFrameFv` | `move s1,v0; beqz s1; nop; jal ctor; move a0,s1; move s1,v0` |
| `CCollision`, `collision.hpp:64` | `0x00164680` / `0x0016468C` / `__ct__10CCollisionFv` | `move s2,v0; beqz s2; addiu a0,s2,0x20; jal ctor; move a0,s2; move s2,v0` |

Their ordinary current C++ new-expressions are at `mapload.cpp:1479` and
`mapload.cpp:1483`. The warm current objdiff report gives their enclosing
function 100%, and the lane baseline full canonical checker reports 149/149.
They do not meet the requested matched-inline-class-6-B test.

The raw opcode scan reports A=196, B=2, N=16, other=2. A here means that the
nearby branch names physical v0; it does not itself distinguish an implicit
construction guard from a caller-written check. The two other cases are
`mgCMDTBuilder::Begin` (trivial `MDT_HEADER`, store/reload then `beqz a0`)
and `CRepairManager::Generate` (explicit `operator new`, member store/reload
then `beqz s0`). `BuildBase` similarly tests v0 after reloading a trivial
`EFF_SPT_BASE` member. All three are excluded rather than counted as inline-B.

The allocation result need not occupy a saved register in every inline A
site. Matched `CreateCollisionMDT` constructs `CCollisionMDT` with the v0
guard and a stack spill in its delay slot (`0x0014868C` / `0x00148690`).
Its header constructor has only expression statements and scalar fields;
that makes it a useful class-6 trace control, not a B counterexample.

The census records the constructor mode from the exact retail guard region:
an allocator-to-guard-to-join direct call to the allocated type constructor
is out of line, while vptr/member construction without that call is inline.
Triviality is checked against the complete existing type and its bases.
Source-order attachment was checked against allocator counts and final
vptr/constructor identities; all 200 available source expressions map one
to one. The remaining 16 sites use retail assembly, existing unit notes,
and fresh m2c output through `decompile.sh`; protected dng_main source/header
are not read for this mapping.

Runtime constructor classifier values come from the parent lane's
signature-checked pn2 `force-new-all` trace, before each policy modification.
They are joined only by translation unit and full constructor identity;
pn2's stale backend caller pointer is deliberately ignored. The 3/6 rule
from `funcpoint/placement-new.md` applies to retained frontend statements.
Unobserved named reads, implicit synthesized constructors and assembly-only
caller classes remain explicitly unmeasured. An outer class-6 constructor
can still request early conversion through an inlined class-3 callee.

## Complete site table

A = guard names v0; B = copied allocation register is tested; N = no
allocation-result branch before the next call; R = store/reload guard.
C = nontrivial constructor new-expression; P = trivial scalar; E = explicit
operator call. Class is a measured runtime classifier when available.

| Unit / caller | Allocator address | Status | Type | Type definition | Kind / ctor mode | Shape | Class |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `character / _OUTLINE__FP9SPI_STACKi` | `0x0017702C` | matched | `COutLineDraw` | `ps2/include/outline.hpp:23` | E / not invoked by allocation | A | n/a (excluded) |
| `character / Copy__11CCharacter2FR11CCharacter2P9mgCMemory` | `0x0017A684` | matched | `COutLineDraw` | `ps2/include/outline.hpp:23` | E / not invoked by allocation | A | n/a (excluded) |
| `character / Copy__11CCharacter2FR11CCharacter2P9mgCMemory` | `0x0017AA7C` | matched | `CSWordAfterEffect` | `ps2/include/swordeffect.hpp:41` | C / inline | A | 6 |
| `collision / LoadCollisionFile__FP10MDS_HEADERP9mgCMemory` | `0x00148578` | matched | `mgCFrame::BoundInfo` | `ps2/include/mg_frame.hpp:357` | P / trivial; no implicit construction guard | N | n/a (excluded) |
| `collision / CreateCollisionMDT__FPUiP9mgCMemory` | `0x00148684` | matched | `CCollisionMDT` | `ps2/include/collision.hpp:164` | C / inline | A | 6 |
| `convviewlp / SVConvViewInit__F13INIT_LOOP_ARG` | `0x00324D50` | matched | `SAVE_CONVERT_WORK` | `ps2/include/convviewlp.hpp:67` | C / inline | A | not observed |
| `dng_event / AutoSetTreasureBox__Fv` | `0x00292408` | matched | `TRESURE_BOX_FLOOR_INFO` | `ps2/include/dng_event.hpp:126` | P / trivial; no implicit construction guard | N | n/a (excluded) |
| `dng_main / InitDungeonMain__F13INIT_LOOP_ARG` | `0x001CD6BC` | matched | `CActionChara` | `ps2/include/actionchara.hpp:250` | C / inline | A | 6 |
| `dng_main / InitDungeonMain__F13INIT_LOOP_ARG` | `0x001CD7E4` | matched | `CCharacter2` | `ps2/include/character.hpp:345` | C / inline | A | 6 |
| `dng_main / InitDungeonMain__F13INIT_LOOP_ARG` | `0x001CDED4` | matched | `ClsMes` | `ps2/include/nd_meswin.hpp:203` | C / out of line | A | n/a (out of line) |
| `dng_main / InitDungeonMain__F13INIT_LOOP_ARG` | `0x001CDF78` | matched | `ClsMes` | `ps2/include/nd_meswin.hpp:203` | C / out of line | A | n/a (out of line) |
| `dng_main / InitDungeonMain__F13INIT_LOOP_ARG` | `0x001CDFFC` | matched | `ClsMes` | `ps2/include/nd_meswin.hpp:203` | C / out of line | A | n/a (out of line) |
| `dng_main / InitDungeonMain__F13INIT_LOOP_ARG` | `0x001CE10C` | matched | `ClsMes` | `ps2/include/nd_meswin.hpp:203` | C / out of line | A | n/a (out of line) |
| `dng_main / InitDungeonMain__F13INIT_LOOP_ARG` | `0x001CE224` | matched | `CRedMarkModel` | `ps2/include/dng_event.hpp:282` | C / inline | A | not observed |
| `dng_main / InitDungeonMain__F13INIT_LOOP_ARG` | `0x001CE564` | matched | `CCharacter2` | `ps2/include/character.hpp:345` | C / inline | A | 6 |
| `dng_main / InitDungeonMain__F13INIT_LOOP_ARG` | `0x001CE604` | matched | `CTreasureBoxManager` | `ps2/include/dng_event.hpp:565` | C / inline | A | not observed |
| `dng_main / InitDungeonMain__F13INIT_LOOP_ARG` | `0x001CE848` | matched | `CEffectScriptMan` | `ps2/include/effscript.hpp:191` | C / inline | A | 6 |
| `dng_main / InitDungeonMain__F13INIT_LOOP_ARG` | `0x001CEDA0` | matched | `CMonsterMan` | `ps2/include/monster.hpp:439` | C / inline | A | not observed |
| `dngmenu / DngTreeMapInit__FP9mgCMemoryPiii` | `0x001F355C` | guarded | `CMenuTreeMap` | `ps2/include/dngmenu.hpp:427` | C / inline | A | 3 |
| `dngmenu / DngTreeMapInit__FP9mgCMemoryPiii` | `0x001F367C` | guarded | `CDngFreeMap` | `ps2/include/dngmenu.hpp:99` | C / inline | A | 3 |
| `dynamicanime / dynCOLLISION__FP9SPI_STACKi` | `0x0017D144` | guarded | `CDAColPipe` | `ps2/include/dynamicanime.hpp:135` | C / inline | A | 6 |
| `editeff / EditSetPlaceAnime__FiP9CMapParts` | `0x00300CF8` | guarded | `CMapParts` | `ps2/include/mapparts.hpp:56` | C / inline | A | 6 |
| `editexception / InitFirePowder__FiP6CSceneiP9mgCMemory` | `0x002FCB30` | guarded | `mgC3DSprite` | `ps2/include/mg_sprite.hpp:193` | C / inline | A | 6 |
| `editexception / InitFirePowder__FiP6CSceneiP9mgCMemory` | `0x002FCBA8` | guarded | `mgCFrame` | `ps2/include/mg_frame.hpp:341` | C / out of line | A | n/a (out of line) |
| `editexception / InitFirePowder__FiP6CSceneiP9mgCMemory` | `0x002FCBD4` | guarded | `mgCFrameAttr` | `ps2/include/mg_frame.hpp:89` | C / out of line | A | n/a (out of line) |
| `editexception / InitGeyserEffect__FiP6CSceneiP9mgCMemory` | `0x002FD99C` | matched | `mgCFrame` | `ps2/include/mg_frame.hpp:341` | C / out of line | A | n/a (out of line) |
| `editexception / InitGeyserEffect__FiP6CSceneiP9mgCMemory` | `0x002FD9C8` | matched | `mgCFrameAttr` | `ps2/include/mg_frame.hpp:89` | C / out of line | A | n/a (out of line) |
| `editloop / EditInit__F13INIT_LOOP_ARG` | `0x001ABA84` | guarded | `CMapTreasureBox` | `ps2/include/mapparts.hpp:516` | C / inline | A | not observed |
| `editloop / EditInit__F13INIT_LOOP_ARG` | `0x001AC194` | guarded | `CEffectScriptMan` | `ps2/include/effscript.hpp:191` | C / inline | A | 6 |
| `editloop / EditInit__F13INIT_LOOP_ARG` | `0x001AC434` | guarded | `CCameraControl` | `ps2/include/cameracontrol.hpp:109` | C / out of line | A | n/a (out of line) |
| `editloop / EditInit__F13INIT_LOOP_ARG` | `0x001AC464` | guarded | `CCameraControl` | `ps2/include/cameracontrol.hpp:109` | C / out of line | A | n/a (out of line) |
| `editloop / EditInit__F13INIT_LOOP_ARG` | `0x001AC494` | guarded | `CCameraControl` | `ps2/include/cameracontrol.hpp:109` | C / out of line | A | n/a (out of line) |
| `editloop / EditInit__F13INIT_LOOP_ARG` | `0x001AC4C4` | guarded | `CCameraControl` | `ps2/include/cameracontrol.hpp:109` | C / out of line | A | n/a (out of line) |
| `editloop / EditInit__F13INIT_LOOP_ARG` | `0x001AC4F4` | guarded | `CCameraControl` | `ps2/include/cameracontrol.hpp:109` | C / out of line | A | n/a (out of line) |
| `editmap / emapRIVER_PARTS_NAME__FP9SPI_STACKi` | `0x001B5884` | guarded | `CMapPiece` | `ps2/include/mdslist.hpp:275` | C / inline | A | 6 |
| `editmap / emapMASK_PARTS_NAME__FP9SPI_STACKi` | `0x001B59F4` | guarded | `CMapPiece` | `ps2/include/mdslist.hpp:275` | C / inline | A | 6 |
| `editmap / emapWATER_PARTS_NAME__FP9SPI_STACKi` | `0x001B5B54` | guarded | `CMapPiece` | `ps2/include/mdslist.hpp:275` | C / inline | A | 6 |
| `editmenu / MenuGeoramaInit__FP9mgCMemoryi` | `0x001F4058` | matched | `CMenuGeorama` | `ps2/include/editmenu.hpp:153` | C / inline | A | 3 |
| `editmenu / MenuGeoramaInit__FP9mgCMemoryi` | `0x001F45EC` | matched | `CDC2Mes` | `ps2/include/menucls1.hpp:68` | C / out of line | A | n/a (out of line) |
| `editmenu / InitDownLoadAnaunce__FP9mgCMemory` | `0x001F6E30` | matched | `CDC2Mes` | `ps2/include/menucls1.hpp:68` | C / out of line | A | n/a (out of line) |
| `editmenu / InitDownLoadAnaunce__FP9mgCMemory` | `0x001F6EC8` | matched | `GeoRequestCheck` | `ps2/src/editmenu.cpp:208` | P / trivial; no implicit construction guard | N | n/a (excluded) |
| `editmenu / MakeDownLoadAnaunce__FiP9mgCMemoryPiPiPi` | `0x001F7808` | matched | `CEditInfoMngr` | `ps2/include/editinfo.hpp:36` | E / not invoked by allocation | A | n/a (excluded) |
| `editmenu / MakeDownLoadAnaunce__FiP9mgCMemoryPiPiPi` | `0x001F7AE4` | matched | `CMenuFont` | `ps2/include/menucls1.hpp:47` | C / out of line | A | n/a (out of line) |
| `editmenu / MakeDownLoadAnaunce__FiP9mgCMemoryPiPiPi` | `0x001F7CE8` | matched | `CMenuFont` | `ps2/include/menucls1.hpp:47` | C / out of line | A | n/a (out of line) |
| `editmenu / MakeDownLoadAnaunce__FiP9mgCMemoryPiPiPi` | `0x001F80FC` | matched | `DownLoadEntry` | `ps2/src/editmenu.cpp:127` | C / inline | A | 6 |
| `editmenu / MakeDownLoadAnaunce__FiP9mgCMemoryPiPiPi` | `0x001F8154` | matched | `DownLoadEntry` | `ps2/src/editmenu.cpp:127` | C / inline | A | 6 |
| `editmenu / MakeDownLoadAnaunce__FiP9mgCMemoryPiPiPi` | `0x001F81FC` | matched | `GeoStoneDmyCnt` | `ps2/src/editmenu.cpp:167` | C / inline | A | 6 |
| `editmenu / MakeDownLoadAnaunce__FiP9mgCMemoryPiPiPi` | `0x001F8274` | matched | `GeoStoneDmyCnt` | `ps2/src/editmenu.cpp:167` | C / inline | A | 6 |
| `editmenu / MenuRemovalInit__FP9mgCMemoryPi` | `0x001FF518` | matched | `CRemovalMenu` | `ps2/include/editmenu.hpp:464` | C / inline | A | 3 |
| `editmode / LoadEditCursor__FP9mgCMemoryi` | `0x002DDC98` | guarded | `CCharacter2` | `ps2/include/character.hpp:345` | C / inline | A | 6 |
| `editmode / LoadEditCursor__FP9mgCMemoryi` | `0x002DDDE4` | guarded | `CCharacter2` | `ps2/include/character.hpp:345` | C / inline | A | 6 |
| `editmode / LoadEditCursor__FP9mgCMemoryi` | `0x002DDEFC` | guarded | `CCharacter2` | `ps2/include/character.hpp:345` | C / inline | A | 6 |
| `editriver / CreateGrid__8CEditMapFPfPfP9mgCMemoryPf` | `0x0029A7C4` | matched | `CEditGrid` | `ps2/include/editriver.hpp:70` | P / trivial; no implicit construction guard | A | n/a (excluded) |
| `effscript / BuildBase__16CEffectScriptManFiP1iP1iP9mgCMemoryi` | `0x002E55D4` | guarded | `EFF_SPT_BASE` | `ps2/include/effscript.hpp:86` | P / trivial; no implicit construction guard | A | n/a (excluded) |
| `effscript / BuildBase__16CEffectScriptManFiP1iP1iP9mgCMemoryi` | `0x002E5670` | guarded | `CCharacter2` | `ps2/include/character.hpp:345` | C / inline | A | 6 |
| `effscript / CreateEffSpt__16CEffectScriptManFiii` | `0x002E5EEC` | guarded | `_EFF_SCRIPT` | `ps2/include/effscript.hpp:152` | C / inline | A | not observed |
| `effscript / CreateEffSpt__16CEffectScriptManFiii` | `0x002E5F50` | guarded | `CCharacter2` | `ps2/include/character.hpp:345` | C / inline | A | 6 |
| `effscript / AssignCharacter__16CEffectScriptManFP11_EFF_SCRIPTi` | `0x002E704C` | guarded | `CCharacter2` | `ps2/include/character.hpp:345` | C / inline | A | 6 |
| `effscript / SetCharacter__16CEffectScriptManFP11CCharacter2ii` | `0x002E7A3C` | guarded | `CCharacter2` | `ps2/include/character.hpp:345` | C / inline | A | 6 |
| `effscript / SetCharacter__16CEffectScriptManFP11CCharacter2ii` | `0x002E7B14` | guarded | `CCharacter2` | `ps2/include/character.hpp:345` | C / inline | A | 6 |
| `event_func / _DATA__FP12RS_STACKDATAi` | `0x00263064` | matched | `ARG_LIST` | `ps2/include/event_func.hpp:683` | P / trivial; no implicit construction guard | A | n/a (excluded) |
| `event_func / _COPY_CHARA__FP12RS_STACKDATAi` | `0x0026AA64` | guarded | `CCharacter2` | `ps2/include/character.hpp:345` | C / inline | A | 6 |
| `event_func / _SPHIDA_SET_UP__FP12RS_STACKDATAi` | `0x002797A0` | matched | `CSphida` | `ps2/include/sphida.hpp:142` | C / out of line | A | n/a (out of line) |
| `event_func / _CREATE_SWORD_EFFECT__FP12RS_STACKDATAi` | `0x0027ACA8` | matched | `CSWordAfterImage` | `ps2/include/dng_effect.hpp:868` | P / trivial; no implicit construction guard | A | n/a (excluded) |
| `event_func / _SWE_INIT__FP12RS_STACKDATAi` | `0x0027B7F8` | matched | `CSWordAfterEffect` | `ps2/include/swordeffect.hpp:41` | E / not invoked by allocation | A | n/a (excluded) |
| `event_func / _ESM_INITIALIZE__FP12RS_STACKDATAi` | `0x0027E0A0` | guarded | `CEffectScriptMan` | `ps2/include/effscript.hpp:191` | C / inline | A | 6 |
| `event_func / _ESM_INIT_FIX__FP12RS_STACKDATAi` | `0x0027E1E0` | matched | `mgCMemory` | `ps2/include/mg_memory.hpp:46` | E / not invoked by allocation | A | n/a (excluded) |
| `event_func / _COPY_MONS2SCNCHR__FP12RS_STACKDATAi` | `0x0027FDDC` | guarded | `CCharacter2` | `ps2/include/character.hpp:345` | C / inline | A | 6 |
| `fishing / sgRestartFishing__FP11SubGameInfo` | `0x00301BEC` | guarded | `CCharacter2` | `ps2/include/character.hpp:345` | C / inline | A | 6 |
| `fishing / StepDataLoading__FPv` | `0x003022F0` | guarded | `CCharacter2` | `ps2/include/character.hpp:345` | C / inline | A | 6 |
| `fishing / StepDataLoading__FPv` | `0x00302390` | guarded | `CCharacter2` | `ps2/include/character.hpp:345` | C / inline | A | 6 |
| `fishing / StepDataLoading__FPv` | `0x00302430` | guarded | `CCharacter2` | `ps2/include/character.hpp:345` | C / inline | A | 6 |
| `fishing / StepDataLoading__FPv` | `0x003024D0` | guarded | `CCharacter2` | `ps2/include/character.hpp:345` | C / inline | A | 6 |
| `fishing / StepDataLoading__FPv` | `0x00302570` | guarded | `CCharacter2` | `ps2/include/character.hpp:345` | C / inline | A | 6 |
| `fishing / StepDataLoading__FPv` | `0x00302610` | guarded | `CCharacter2` | `ps2/include/character.hpp:345` | C / inline | A | 6 |
| `fishing / StepDataLoading__FPv` | `0x003026B0` | guarded | `CCharacter2` | `ps2/include/character.hpp:345` | C / inline | A | 6 |
| `fishing / InitSuccess__FP6CScene` | `0x00306D84` | guarded | `CCharacter2` | `ps2/include/character.hpp:345` | C / inline | A | 6 |
| `funcpoint / Add__14CFuncPointMngrFiP9mgCMemory` | `0x002A11EC` | guarded | `CList<CFuncPoint>` | `ps2/include/mg_tanime.hpp:172` | C / inline | A | 6 |
| `gyorace / sgInitGyoRace__FP11SubGameInfo` | `0x00309B4C` | guarded | `ClsMes` | `ps2/include/nd_meswin.hpp:203` | C / out of line | A | n/a (out of line) |
| `inventmn / LoadCharaCheck__11CMenuInventFv` | `0x00202520` | guarded | `CActionChara` | `ps2/include/actionchara.hpp:250` | C / inline | A | 6 |
| `inventmn / IsCreateObject__11CMenuInventFii` | `0x00204DFC` | guarded | `CActionChara` | `ps2/include/actionchara.hpp:250` | C / inline | A | 6 |
| `inventmn / IsCreateObject__11CMenuInventFii` | `0x00205004` | guarded | `CActionChara` | `ps2/include/actionchara.hpp:250` | C / inline | A | 6 |
| `inventmn / IsAccessAlbum__11CMenuInventFv` | `0x00208600` | guarded | `CDC2AlbumData` | `ps2/include/inventmn.hpp:176` | C / inline | A | 6 |
| `inventmn / IsAccessAlbum__11CMenuInventFv` | `0x00208630` | guarded | `CMemoryCardManager` | `ps2/include/memcard.hpp:236` | C / out of line | A | n/a (out of line) |
| `inventmn / MenuInventInit__FP9mgCMemoryPii` | `0x0020B01C` | guarded | `CMenuInvent` | `ps2/include/inventmn.hpp:320` | C / inline | A | 3 |
| `inventmn / MenuInventInit__FP9mgCMemoryPii` | `0x0020B794` | guarded | `CActionChara` | `ps2/include/actionchara.hpp:250` | C / inline | A | 6 |
| `inventmn / MenuInventInit__FP9mgCMemoryPii` | `0x0020B86C` | guarded | `CActionChara` | `ps2/include/actionchara.hpp:250` | C / inline | A | 6 |
| `inventmn / MenuInventInit__FP9mgCMemoryPii` | `0x0020B934` | guarded | `CActionChara` | `ps2/include/actionchara.hpp:250` | C / inline | A | 6 |
| `inventmn / MenuInventInit__FP9mgCMemoryPii` | `0x0020BA4C` | guarded | `CMenuEffect` | `ps2/include/menudraw.hpp:1476` | E / not invoked by allocation | A | n/a (excluded) |
| `inventmn / MenuInventInit__FP9mgCMemoryPii` | `0x0020BA7C` | guarded | `CMenuEffect` | `ps2/include/menudraw.hpp:1476` | E / not invoked by allocation | A | n/a (excluded) |
| `inventmn / MenuInventInit__FP9mgCMemoryPii` | `0x0020BAAC` | guarded | `CMenuMoveItem` | `ps2/include/menucls1.hpp:422` | C / inline | A | 3 |
| `maintex / SetSwordBlurEffect__FP11CCharacter2P9mgCMemoryi` | `0x001EA2A0` | matched | `CSWordAfterEffect` | `ps2/include/swordeffect.hpp:41` | C / inline | A | 6 |
| `map / AddPartsGroup__4CMapFPcP9CMapPartsP9mgCMemory` | `0x0015DAE4` | guarded | `CList<PartsGroupData>` | `ps2/include/mg_tanime.hpp:172` | C / inline | A | 6 |
| `map / CreateDrawRect__4CMapFP9mgCMemoryP9mgVu0FBOXP9mgVu0FBOXi` | `0x0015E314` | guarded | `CList<CMapParts *>` | `ps2/include/mg_tanime.hpp:172` | C / inline | A | 6 |
| `mapload / mapPARTS__FP9SPI_STACKi` | `0x001630CC` | matched | `CList<CMapParts>` | `ps2/include/mg_tanime.hpp:172` | C / out of line | A | n/a (out of line) |
| `mapload / mapPIECE__FP9SPI_STACKi` | `0x00163680` | matched | `CList<CMapPiece>` | `ps2/include/mg_tanime.hpp:172` | C / out of line | A | n/a (out of line) |
| `mapload / mapFIX_CAMERA_RECT__FP9SPI_STACKi` | `0x0016462C` | matched | `CColFrame` | `ps2/include/collision.hpp:243` | C / out of line | B | n/a (out of line) |
| `mapload / mapFIX_CAMERA_RECT__FP9SPI_STACKi` | `0x00164680` | matched | `CCollision` | `ps2/include/collision.hpp:64` | C / out of line | B | n/a (out of line) |
| `mapload / mapFUNC_EFFECT_NAME__FP9SPI_STACKi` | `0x001654CC` | matched | `mgCFrame::BoundInfo` | `ps2/include/mg_frame.hpp:357` | E / not invoked by allocation | N | n/a (excluded) |
| `mapparts / Copy__9CMapPartsFR9CMapPartsP9mgCMemory` | `0x00169184` | assembly-only | `CList<CMapPiece>` | `ps2/include/mg_tanime.hpp:172` | C / inline | A | not observed |
| `mapparts / AssignFuncAnime__9CMapPartsFP9mgCMemory` | `0x001695AC` | assembly-only | `CList<CObjAnime>` | `ps2/include/mg_tanime.hpp:172` | C / inline | A | not observed |
| `mdslist / Copy__9CMapPieceFR9CMapPieceP9mgCMemory` | `0x00169DE8` | guarded | `CCharacter2` | `ps2/include/character.hpp:345` | C / inline | A | 6 |
| `mdslist / LoadIMGFile__8CIMGListFPcP15mgCEnterIMGInfoP9mgCMemory` | `0x0016A718` | matched | `mgCEnterIMGInfo` | `ps2/include/mg_texture.hpp:206` | E / not invoked by allocation | N | n/a (excluded) |
| `mdslist / CreateChara__FPUiPcP9mgCMemory` | `0x0016AD04` | guarded | `CCharacter2` | `ps2/include/character.hpp:345` | C / inline | A | 6 |
| `memcard / Initialize__18CMemoryCardManagerFP9mgCMemory` | `0x002F6734` | matched | `SAVEDATA_FORMAT` | `ps2/include/memcard.hpp:189` | C / inline | A | not observed |
| `menuaqua / Initialize__8CAquaMesFP9mgCMemory` | `0x00211724` | matched | `ClsMes` | `ps2/include/nd_meswin.hpp:203` | C / out of line | A | n/a (out of line) |
| `menuaqua / Initialize__8CAquaMesFP9mgCMemory` | `0x00211750` | matched | `ClsMes` | `ps2/include/nd_meswin.hpp:203` | C / out of line | A | n/a (out of line) |
| `menuaqua / Initialize__8CAquaMesFP9mgCMemory` | `0x0021177C` | matched | `ClsMes` | `ps2/include/nd_meswin.hpp:203` | C / out of line | A | n/a (out of line) |
| `menuaqua / Initialize__8CAquaMesFP9mgCMemory` | `0x002117A8` | matched | `ClsMes` | `ps2/include/nd_meswin.hpp:203` | C / out of line | A | n/a (out of line) |
| `menuaqua / Initialize__8CAquaMesFP9mgCMemory` | `0x002117D4` | matched | `ClsMes` | `ps2/include/nd_meswin.hpp:203` | C / out of line | A | n/a (out of line) |
| `menuaqua / Initialize__8CAquaMesFP9mgCMemory` | `0x00211800` | matched | `ClsMes` | `ps2/include/nd_meswin.hpp:203` | C / out of line | A | n/a (out of line) |
| `menuaqua / Initialize__8CAquaMesFP9mgCMemory` | `0x0021182C` | matched | `ClsMes` | `ps2/include/nd_meswin.hpp:203` | C / out of line | A | n/a (out of line) |
| `menuaqua / Initialize__9CAquariumFP9mgCMemoryPi` | `0x00214A60` | matched | `CAquaFishEff` | `ps2/include/menuaqua.hpp:482` | P / trivial; no implicit construction guard | N | n/a (excluded) |
| `menuaqua / Initialize__9CAquariumFP9mgCMemoryPi` | `0x00214AC0` | matched | `CBubble` | `ps2/include/menuaqua.hpp:116` | P / trivial; no implicit construction guard | N | n/a (excluded) |
| `menuaqua / LoadFish__9CAquariumFiP13CGameDataUsed` | `0x002150D0` | matched | `CAquaFish` | `ps2/include/menuaqua.hpp:270` | C / out of line | A | n/a (out of line) |
| `menuaqua / SettingAqua__9CAquariumFv` | `0x00215424` | guarded | `CBubble` | `ps2/include/menuaqua.hpp:116` | P / trivial; no implicit construction guard | N | n/a (excluded) |
| `menuaqua / SettingAqua__9CAquariumFv` | `0x00215D48` | guarded | `CCharacter2` | `ps2/include/character.hpp:345` | C / inline | A | 6 |
| `menuaqua / Step__9CAquariumFv` | `0x002187A0` | guarded | `CFishFood` | `ps2/include/menuaqua.hpp:538` | C / out of line | A | n/a (out of line) |
| `menuaqua / MenuAquaInit__FP9mgCMemoryPii` | `0x0021A5E4` | matched | `mgCCameraFollow` | `ps2/include/mg_camera.hpp:306` | C / out of line | A | n/a (out of line) |
| `menuaqua / GyoraceMenuInit__FP9mgCMemoryPii` | `0x0021C3DC` | matched | `CDC2Mes` | `ps2/include/menucls1.hpp:68` | C / out of line | A | n/a (out of line) |
| `menuaqua / GyoraceMenuInit__FP9mgCMemoryPii` | `0x0021C484` | matched | `CDC2Mes` | `ps2/include/menucls1.hpp:68` | C / out of line | A | n/a (out of line) |
| `menuaqua / GyoraceMenuInit__FP9mgCMemoryPii` | `0x0021C4F8` | matched | `CDC2Mes` | `ps2/include/menucls1.hpp:68` | C / out of line | A | n/a (out of line) |
| `menuchr / EnterDataMenu__15CMenuChrCngMenuFPUc` | `0x002B4BD8` | guarded | `mgCTexture` | `ps2/include/mg_texture.hpp:221` | C / out of line | A | n/a (out of line) |
| `menuchr / LoadBGNPCModel__15CMenuChrCngMenuFi` | `0x002B5288` | guarded | `CActionChara` | `ps2/include/actionchara.hpp:250` | C / inline | A | 6 |
| `menuchr / MenuCharaChangeInit__FP9mgCMemoryPii` | `0x002B9220` | guarded | `CMenuChrCngMenu` | `ps2/include/menuchr.hpp:120` | C / inline | A | 6 |
| `menuchr / MenuCharaChangeInit__FP9mgCMemoryPii` | `0x002B93DC` | guarded | `CRepairManager` | `ps2/include/menudraw.hpp:1074` | C / inline | A | not observed |
| `menuchr / MenuMonsterBoxInit__FP9mgCMemoryPii` | `0x002BB2CC` | matched | `CMenuMosSelect` | `ps2/include/menuchr.hpp:334` | C / inline | A | 3 |
| `menuchr / LoadMenuData__15CMenuCostumeSelFP9mgCMemoryPi` | `0x002C0CAC` | guarded | `CActionChara` | `ps2/include/actionchara.hpp:250` | C / inline | A | 6 |
| `menuchr / MenuCostumeInit__FP9mgCMemoryPii` | `0x002C22FC` | guarded | `CMenuCostumeSel` | `ps2/include/menuchr.hpp:452` | C / inline | A | 6 |
| `menuchr / KeyStep__12CMosBookMenuFv` | `0x002C3DC0` | guarded | `CActionChara` | `ps2/include/actionchara.hpp:250` | C / inline | A | 6 |
| `menuchr / MonsterBookInit__FP9mgCMemoryPii` | `0x002C4004` | matched | `CMosBookMenu` | `ps2/include/menuchr.hpp:578` | C / inline | A | 3 |
| `menudraw / MallocPallet__18CMenuPosDataManageFP9mgCMemory` | `0x0022E978` | matched | `mgCTexture` | `ps2/include/mg_texture.hpp:221` | C / out of line | A | n/a (out of line) |
| `menudraw / MallocPallet__18CMenuPosDataManageFP9mgCMemory` | `0x0022E9A8` | matched | `mgCTexture` | `ps2/include/mg_texture.hpp:221` | C / out of line | A | n/a (out of line) |
| `menudraw / MallocPallet__18CMenuPosDataManageFP9mgCMemory` | `0x0022E9D8` | matched | `mgCTexture` | `ps2/include/mg_texture.hpp:221` | C / out of line | A | n/a (out of line) |
| `menudraw / GeneratePoly__14CRepairManagerFPfi` | `0x0022FE88` | guarded | `CActionChara` | `ps2/include/actionchara.hpp:250` | C / inline | A | 6 |
| `menudraw / Generate__14CRepairManagerFii` | `0x00230108` | matched | `CRepairEffect` | `ps2/include/menudraw.hpp:1014` | E / not invoked by allocation | R | n/a (excluded) |
| `menumain / MenuMainInit__FP13MENU_INIT_ARG` | `0x00235114` | guarded | `MENU_DRAW_ENV` | `ps2/include/menumain.hpp:200` | C / inline | A | 6 |
| `menumain / MenuMainInit__FP13MENU_INIT_ARG` | `0x002351C0` | guarded | `CMenuPosDataManage` | `ps2/include/menudraw.hpp:908` | P / trivial; no implicit construction guard | N | n/a (excluded) |
| `menumain / MenuMainInit__FP13MENU_INIT_ARG` | `0x002351E8` | guarded | `CMenuKeyFunc` | `ps2/include/menusys.hpp:635` | C / inline | A | 6 |
| `menumain / MenuMainInit__FP13MENU_INIT_ARG` | `0x002355CC` | guarded | `CDC2Mes` | `ps2/include/menucls1.hpp:68` | C / out of line | A | n/a (out of line) |
| `menumain / MenuInternInit__FP9mgCMemoryii` | `0x00237610` | matched | `CDC2Mes` | `ps2/include/menucls1.hpp:68` | C / out of line | A | n/a (out of line) |
| `menumap / WorldMoveInit__FP9mgCMemoryPii` | `0x002B1FD8` | matched | `CWorldMapMenu` | `ps2/include/menumap.hpp:141` | C / inline | A | 3 |
| `menumap / SphidaMenuInit__FP9mgCMemoryPii` | `0x002B25D0` | matched | `CDC2Mes` | `ps2/include/menucls1.hpp:68` | C / out of line | A | n/a (out of line) |
| `menumap / SphidaMenuInit__FP9mgCMemoryPii` | `0x002B2658` | matched | `CDC2Mes` | `ps2/include/menucls1.hpp:68` | C / out of line | A | n/a (out of line) |
| `menumap / SphidaMenuInit__FP9mgCMemoryPii` | `0x002B26C0` | matched | `CDC2Mes` | `ps2/include/menucls1.hpp:68` | C / out of line | A | n/a (out of line) |
| `menuop / InitMenuReturnMsg__FP9mgCMemory` | `0x002C4284` | matched | `CDC2Mes` | `ps2/include/menucls1.hpp:68` | C / out of line | A | n/a (out of line) |
| `menuop / MenuManualInit__FP9mgCMemoryPii` | `0x002C44F0` | guarded | `CMovie` | `ps2/include/movie.hpp:227` | E / not invoked by allocation | N | n/a (excluded) |
| `menuop / MenuManualInit__FP9mgCMemoryPii` | `0x002C4510` | guarded | `CManualMenu` | `ps2/include/menuop.hpp:168` | C / inline | A | 6 |
| `menuop / MenuOptionInit__FP9mgCMemoryPii` | `0x002C6E8C` | matched | `CMenuOption` | `ps2/include/menuop.hpp:236` | C / inline | A | 3 |
| `menuop / MenuSaveInit__FP9mgCMemoryPii` | `0x002C9B40` | matched | `CSaveMenuClass` | `ps2/include/menuop.hpp:331` | C / inline | A | 3 |
| `menuop / MenuSaveInit__FP9mgCMemoryPii` | `0x002C9BF4` | matched | `CMemoryCardManager` | `ps2/include/memcard.hpp:236` | C / out of line | A | n/a (out of line) |
| `menuop / MenuSaveInit__FP9mgCMemoryPii` | `0x002C9F04` | matched | `CDC2Mes` | `ps2/include/menucls1.hpp:68` | C / out of line | A | n/a (out of line) |
| `menuop / SubGameSaveInit__FP9mgCMemoryPii` | `0x002CA4EC` | matched | `CMemoryCardManager` | `ps2/include/memcard.hpp:236` | C / out of line | A | n/a (out of line) |
| `menuop / SubGameSaveInit__FP9mgCMemoryPii` | `0x002CA550` | matched | `CSubGameData` | `ps2/include/savedata.hpp:699` | C / out of line | A | n/a (out of line) |
| `menushop / MenuShopInit__FP9mgCMemoryPii` | `0x00298620` | matched | `CShopMenu` | `ps2/include/menushop.hpp:244` | C / inline | A | 3 |
| `menushop / MenuShopInit__FP9mgCMemoryPii` | `0x00298700` | matched | `CShop` | `ps2/include/menushop.hpp:129` | E / not invoked by allocation | A | n/a (excluded) |
| `menushop / MenuShopInit__FP9mgCMemoryPii` | `0x00298768` | matched | `CMenuMoveItem` | `ps2/include/menucls1.hpp:422` | C / inline | A | 3 |
| `menushop / InitEnd__14CMenuQuestViewFv` | `0x00298D4C` | matched | `CDC2Mes` | `ps2/include/menucls1.hpp:68` | C / out of line | A | n/a (out of line) |
| `menushop / InitEnd__14CMenuQuestViewFv` | `0x00298DAC` | matched | `CDC2Mes` | `ps2/include/menucls1.hpp:68` | C / out of line | A | n/a (out of line) |
| `menushop / MenuNPCQuestViewInit__FP9mgCMemoryPii` | `0x00299688` | guarded | `CMenuQuestView` | `ps2/include/menushop.hpp:421` | C / inline | A | not observed |
| `menushop / MenuNPCQuestViewInit__FP9mgCMemoryPii` | `0x002996C4` | guarded | `CQuestManager` | `ps2/include/quest.hpp:57` | E / not invoked by allocation | A | n/a (excluded) |
| `menusys / IsAskExtend__13CMenuItemInfoFii` | `0x00244A70` | guarded | `CActionChara` | `ps2/include/actionchara.hpp:250` | C / inline | A | 6 |
| `menusys / MenuModeMalloc__13CMenuItemInfoFP9mgCMemory` | `0x00245F14` | guarded | `CActionChara` | `ps2/include/actionchara.hpp:250` | C / inline | A | 6 |
| `menusys / MenuModeMalloc__13CMenuItemInfoFP9mgCMemory` | `0x00246024` | guarded | `CMenuMoveItem` | `ps2/include/menucls1.hpp:422` | C / inline | A | 3 |
| `menusys / MenuModeMalloc__13CMenuItemInfoFP9mgCMemory` | `0x00246080` | guarded | `CActionChara` | `ps2/include/actionchara.hpp:250` | C / inline | A | 6 |
| `menusys / MenuModeMalloc__13CMenuItemInfoFP9mgCMemory` | `0x00246148` | guarded | `CMenuEffect` | `ps2/include/menudraw.hpp:1476` | E / not invoked by allocation | A | n/a (excluded) |
| `menusys / MenuModeMalloc__13CMenuItemInfoFP9mgCMemory` | `0x00246178` | guarded | `CMenuEffect` | `ps2/include/menudraw.hpp:1476` | E / not invoked by allocation | A | n/a (excluded) |
| `menusys / MenuModeMalloc__13CMenuItemInfoFP9mgCMemory` | `0x002461A8` | guarded | `CRepairManager` | `ps2/include/menudraw.hpp:1074` | C / inline | A | not observed |
| `menusys / MenuItemDebugKey__Fv` | `0x002481CC` | guarded | `mgCCameraFollow` | `ps2/include/mg_camera.hpp:306` | C / out of line | A | n/a (out of line) |
| `menusys / MenuItemDebugKey__Fv` | `0x00248218` | guarded | `CActionChara` | `ps2/include/actionchara.hpp:250` | C / inline | A | 6 |
| `menusys / KeyStep__13CMenuItemInfoFv` | `0x00250BA4` | matched | `CDC2Mes` | `ps2/include/menucls1.hpp:68` | C / out of line | A | n/a (out of line) |
| `menusys / MenuItemSelectInit__FP9mgCMemoryPii` | `0x00252938` | guarded | `CItemSelect` | `ps2/include/menusys.hpp:1458` | C / inline | A | 6 |
| `mg_dataset / CreateFrameVisual__FP8mgCFrameP9mgCMemoryP9mgCMemoryP8mgCFrameP13MDTOBJ_HEADERP10MDT_HEADERiP17mgCTextureManagerPUiiPP8mgCFramePA4_A4_f` | `0x00132E94` | guarded | `mgCFrameAttr` | `ps2/include/mg_frame.hpp:89` | C / out of line | A | n/a (out of line) |
| `mg_dataset / CreateFrameVisual__FP8mgCFrameP9mgCMemoryP9mgCMemoryP8mgCFrameP13MDTOBJ_HEADERP10MDT_HEADERiP17mgCTextureManagerPUiiPP8mgCFramePA4_A4_f` | `0x00133020` | guarded | `mgCVisualMDT` | `ps2/include/mg_visual.hpp:143` | C / inline | A | 6 |
| `mg_dataset / CreateFrameVisual__FP8mgCFrameP9mgCMemoryP9mgCMemoryP8mgCFrameP13MDTOBJ_HEADERP10MDT_HEADERiP17mgCTextureManagerPUiiPP8mgCFramePA4_A4_f` | `0x00133094` | guarded | `mgCVisualFixMDT` | `ps2/include/mg_visual.hpp:382` | C / inline | A | 6 |
| `mg_dataset / CreateFrameVisual__FP8mgCFrameP9mgCMemoryP9mgCMemoryP8mgCFrameP13MDTOBJ_HEADERP10MDT_HEADERiP17mgCTextureManagerPUiiPP8mgCFramePA4_A4_f` | `0x00133128` | guarded | `mgCVisualMotionMDT` | `ps2/include/visualmotion.hpp:65` | C / inline | A | 6 |
| `mg_dataset / CreateFrameVisual__FP8mgCFrameP9mgCMemoryP9mgCMemoryP8mgCFrameP13MDTOBJ_HEADERP10MDT_HEADERiP17mgCTextureManagerPUiiPP8mgCFramePA4_A4_f` | `0x001331DC` | guarded | `mgCShadowMDT` | `ps2/include/mg_shadow.hpp:27` | C / inline | A | not observed |
| `mg_dataset / CreateFrameVisual__FP8mgCFrameP9mgCMemoryP9mgCMemoryP8mgCFrameP13MDTOBJ_HEADERP10MDT_HEADERiP17mgCTextureManagerPUiiPP8mgCFramePA4_A4_f` | `0x0013325C` | guarded | `mgCShadowFixMDT` | `ps2/include/mg_shadow.hpp:93` | C / inline | A | not observed |
| `mg_dataset / CopyFrame__FP8mgCFrameP8mgCFrameP9mgCMemoryiPP8mgCFrame` | `0x00133BAC` | guarded | `mgCFrameAttr` | `ps2/include/mg_frame.hpp:89` | C / out of line | A | n/a (out of line) |
| `mg_dataset / CopyFrame__FP8mgCFrameP8mgCFrameP9mgCMemoryiPP8mgCFrame` | `0x00133CFC` | guarded | `mgCFrame::BoundInfo` | `ps2/include/mg_frame.hpp:357` | E / not invoked by allocation | N | n/a (excluded) |
| `mg_dataset / CopyFrameSub__FP8mgCFrameP9mgCMemoryiPP8mgCFrame` | `0x00133E24` | guarded | `mgCFrame` | `ps2/include/mg_frame.hpp:341` | C / out of line | A | n/a (out of line) |
| `mg_dataset / Begin__13mgCMDTBuilderFP9mgCMemory` | `0x001341A8` | matched | `MDT_HEADER` | `ps2/include/mg_dataset.hpp:69` | P / trivial; no implicit construction guard | R | n/a (excluded) |
| `mg_dataset / End__13mgCMDTBuilderFP8mgCFrameP12mgCVisualMDTP10mgLoadData` | `0x00134364` | guarded | `mgCFrame::BoundInfo` | `ps2/include/mg_frame.hpp:357` | E / not invoked by allocation | N | n/a (excluded) |
| `mg_dataset / End__13mgCMDTBuilderFP8mgCFrameP12mgCVisualMDTP10mgLoadData` | `0x001343C8` | guarded | `mgCFrameAttr` | `ps2/include/mg_frame.hpp:89` | C / out of line | A | n/a (out of line) |
| `mg_shadow / CreateFace__12mgCShadowMDTFP8FACES_IDP9mgCMemoryP9mgCMemoryPP7mgCFace` | `0x0013AA4C` | matched | `mgCFace` | `ps2/include/mg_visual.hpp:67` | P / trivial; no implicit construction guard | N | n/a (excluded) |
| `mg_tanime / NewTexAnimeData__15mgCTextureAnimeFP9mgCMemory` | `0x0013DA64` | guarded | `CList<mgCTexAnimeData>` | `ps2/include/mg_tanime.hpp:172` | C / inline | A | 6 |
| `mg_tanime / texTEX_ANIME_DATA_END__FP9SPI_STACKi` | `0x0013E890` | matched | `mgCTextureAnime` | `ps2/include/mg_tanime.hpp:276` | C / out of line | A | n/a (out of line) |
| `mg_visual / CreateFace__12mgCVisualMDTFP8FACES_IDP9mgCMemoryP9mgCMemoryPP7mgCFace` | `0x0013F7C8` | matched | `mgFACE_GROUP` | `ps2/include/mg_visual.hpp:86` | E / not invoked by allocation | A | n/a (excluded) |
| `mg_visual / CreateFace__12mgCVisualMDTFP8FACES_IDP9mgCMemoryP9mgCMemoryPP7mgCFace` | `0x0013F850` | matched | `mgFACE_GROUP` | `ps2/include/mg_visual.hpp:86` | E / not invoked by allocation | A | n/a (excluded) |
| `mg_visual / Copy__15mgCVisualFixMDTFP9mgCMemory` | `0x0014128C` | assembly-only | `mgCVisualFixMDT` | `ps2/include/mg_visual.hpp:382` | C / inline | A | not observed |
| `monster / LoadReferMonsterFile__11CMonsterManFiP16BASE_MONSTER_TBLP9mgCMemory` | `0x001DCF28` | matched | `CSWordAfterEffect` | `ps2/include/swordeffect.hpp:41` | C / inline | A | 6 |
| `movieviewlp / MovieViewInit__F13INIT_LOOP_ARG` | `0x002CBA68` | matched | `CMovie` | `ps2/include/movie.hpp:227` | P / trivial; no implicit construction guard | N | n/a (excluded) |
| `nameregi / NameRegistInit__FP9mgCMemoryPii` | `0x00310118` | matched | `CNameRegiMenu` | `ps2/include/nameregi.hpp:120` | C / inline | A | 3 |
| `pbuggy / sgInitBuggy__FP11SubGameInfo` | `0x00319228` | assembly-only | `CEffectScriptMan` | `ps2/include/effscript.hpp:191` | C / inline | A | not observed |
| `sceneload / LoadChara__6CSceneFiPUiPcP9mgCMemoryP9mgCMemoryP9mgCMemoryii` | `0x00288F88` | guarded | `CCharacter2` | `ps2/include/character.hpp:345` | C / inline | A | 6 |
| `sceneload / CopyChara__6CSceneFiiP9mgCMemory` | `0x002891EC` | guarded | `CCharacter2` | `ps2/include/character.hpp:345` | C / inline | A | 6 |
| `sceneload / LoadMapFromMemory__6CSceneFiiP17SCN_LOADMAP_INFO2` | `0x00289530` | matched | `CEditMap` | `ps2/include/editmap.hpp:95` | C / inline | A | 3 |
| `sceneload / LoadMapFromMemory__6CSceneFiiP17SCN_LOADMAP_INFO2` | `0x00289764` | matched | `CMapSky` | `ps2/include/mapsky.hpp:48` | E / not invoked by allocation | A | n/a (excluded) |
| `scenevillager / CharaObjectOnOff__6CSceneFiP9mgCMemory` | `0x002CE5A0` | guarded | `mgCFrameAttr` | `ps2/include/mg_frame.hpp:89` | C / out of line | A | n/a (out of line) |
| `scenevillager / CharaObjectOnOff__6CSceneFiP9mgCMemory` | `0x002CE640` | guarded | `mgCFrameAttr` | `ps2/include/mg_frame.hpp:89` | C / out of line | A | n/a (out of line) |
| `scenevillager / RegisterVillager__6CSceneFiiP9mgCMemory` | `0x002CEDF8` | matched | `CVillagerPlaceInfo` | `ps2/include/villagermngr.hpp:74` | E / not invoked by allocation | A | n/a (excluded) |
| `title / TitleInit__F13INIT_LOOP_ARG` | `0x002A3264` | matched | `TITLE_INFO` | `ps2/include/title.hpp:244` | C / inline | A | 3 |
| `title / TitleBootInit__Fv` | `0x002A336C` | guarded | `CMovie` | `ps2/include/movie.hpp:227` | P / trivial; no implicit construction guard | N | n/a (excluded) |
| `title / TitleBootInit__Fv` | `0x002A339C` | guarded | `CMemoryCardManager` | `ps2/include/memcard.hpp:236` | C / out of line | A | n/a (out of line) |
| `title / TitleBootInit__Fv` | `0x002A33DC` | guarded | `mgCCameraFollow` | `ps2/include/mg_camera.hpp:306` | C / out of line | A | n/a (out of line) |
| `title / TitleBootInit__Fv` | `0x002A3428` | guarded | `mgCCamera` | `ps2/include/mg_camera.hpp:27` | C / out of line | A | n/a (out of line) |
| `title / TitleBootInit__Fv` | `0x002A3460` | guarded | `CWaveTable` | `ps2/include/wavetable.hpp:27` | C / out of line | A | n/a (out of line) |
| `title / TitleBootInit__Fv` | `0x002A3B00` | guarded | `CActionChara` | `ps2/include/actionchara.hpp:250` | C / inline | A | 6 |
| `title / TitleHDDInstallInit__Fv` | `0x002A78B0` | matched | `CDC2Mes` | `ps2/include/menucls1.hpp:68` | C / out of line | A | n/a (out of line) |
| `title / TitleHDDInstallInit__Fv` | `0x002A78DC` | matched | `CDC2Mes` | `ps2/include/menucls1.hpp:68` | C / out of line | A | n/a (out of line) |
| `villagermngr / Add__18CVillagerPlaceInfoFP9mgCMemory` | `0x002D1B20` | matched | `CVillagerPlaceInfo::Node` | `ps2/include/villagermngr.hpp:81` | P / trivial; no implicit construction guard | A | n/a (excluded) |
| `visualmotion / Copy__18mgCVisualMotionMDTFP9mgCMemory` | `0x0028E95C` | assembly-only | `mgCVisualMotionMDT` | `ps2/include/visualmotion.hpp:65` | C / inline | A | not observed |
| `water / CreateWaterFrame__FiiPfPfP9mgCMemory` | `0x00187338` | guarded | `CWaterFrame` | `ps2/include/water.hpp:271` | C / inline | A | 6 |
| `water / CreateWaterFrame__FiiPfPfP9mgCMemory` | `0x00187388` | guarded | `mgCFrameAttr` | `ps2/include/mg_frame.hpp:89` | C / out of line | A | n/a (out of line) |
| `water / CreateWaterFrame__FiiPfPfP9mgCMemory` | `0x001873D0` | guarded | `CWater` | `ps2/include/water.hpp:138` | C / out of line | A | n/a (out of line) |
| `water / CreateWaterFrame__FiiPfPfP9mgCMemory` | `0x00187440` | guarded | `mgCFrame::BoundInfo` | `ps2/include/mg_frame.hpp:357` | P / trivial; no implicit construction guard | N | n/a (excluded) |

## Type definition index

These are the defining headers or first-definition source files, not forward
declarations. Constructor spelling, complete fields, source location and
retail guard-region calls are retained in the machine-readable census.

| Type | Sites | Definition |
| --- | ---: | --- |
| `ARG_LIST` | 1 | `ps2/include/event_func.hpp:683` |
| `CActionChara` | 16 | `ps2/include/actionchara.hpp:250` |
| `CAquaFish` | 1 | `ps2/include/menuaqua.hpp:270` |
| `CAquaFishEff` | 1 | `ps2/include/menuaqua.hpp:482` |
| `CBubble` | 2 | `ps2/include/menuaqua.hpp:116` |
| `CCameraControl` | 5 | `ps2/include/cameracontrol.hpp:109` |
| `CCharacter2` | 26 | `ps2/include/character.hpp:345` |
| `CColFrame` | 1 | `ps2/include/collision.hpp:243` |
| `CCollision` | 1 | `ps2/include/collision.hpp:64` |
| `CCollisionMDT` | 1 | `ps2/include/collision.hpp:164` |
| `CDAColPipe` | 1 | `ps2/include/dynamicanime.hpp:135` |
| `CDC2AlbumData` | 1 | `ps2/include/inventmn.hpp:176` |
| `CDC2Mes` | 17 | `ps2/include/menucls1.hpp:68` |
| `CDngFreeMap` | 1 | `ps2/include/dngmenu.hpp:99` |
| `CEditGrid` | 1 | `ps2/include/editriver.hpp:70` |
| `CEditInfoMngr` | 1 | `ps2/include/editinfo.hpp:36` |
| `CEditMap` | 1 | `ps2/include/editmap.hpp:95` |
| `CEffectScriptMan` | 4 | `ps2/include/effscript.hpp:191` |
| `CFishFood` | 1 | `ps2/include/menuaqua.hpp:538` |
| `CItemSelect` | 1 | `ps2/include/menusys.hpp:1458` |
| `CList<CFuncPoint>` | 1 | `ps2/include/mg_tanime.hpp:172` |
| `CList<CMapParts *>` | 1 | `ps2/include/mg_tanime.hpp:172` |
| `CList<CMapParts>` | 1 | `ps2/include/mg_tanime.hpp:172` |
| `CList<CMapPiece>` | 2 | `ps2/include/mg_tanime.hpp:172` |
| `CList<CObjAnime>` | 1 | `ps2/include/mg_tanime.hpp:172` |
| `CList<PartsGroupData>` | 1 | `ps2/include/mg_tanime.hpp:172` |
| `CList<mgCTexAnimeData>` | 1 | `ps2/include/mg_tanime.hpp:172` |
| `CManualMenu` | 1 | `ps2/include/menuop.hpp:168` |
| `CMapParts` | 1 | `ps2/include/mapparts.hpp:56` |
| `CMapPiece` | 3 | `ps2/include/mdslist.hpp:275` |
| `CMapSky` | 1 | `ps2/include/mapsky.hpp:48` |
| `CMapTreasureBox` | 1 | `ps2/include/mapparts.hpp:516` |
| `CMemoryCardManager` | 4 | `ps2/include/memcard.hpp:236` |
| `CMenuChrCngMenu` | 1 | `ps2/include/menuchr.hpp:120` |
| `CMenuCostumeSel` | 1 | `ps2/include/menuchr.hpp:452` |
| `CMenuEffect` | 4 | `ps2/include/menudraw.hpp:1476` |
| `CMenuFont` | 2 | `ps2/include/menucls1.hpp:47` |
| `CMenuGeorama` | 1 | `ps2/include/editmenu.hpp:153` |
| `CMenuInvent` | 1 | `ps2/include/inventmn.hpp:320` |
| `CMenuKeyFunc` | 1 | `ps2/include/menusys.hpp:635` |
| `CMenuMosSelect` | 1 | `ps2/include/menuchr.hpp:334` |
| `CMenuMoveItem` | 3 | `ps2/include/menucls1.hpp:422` |
| `CMenuOption` | 1 | `ps2/include/menuop.hpp:236` |
| `CMenuPosDataManage` | 1 | `ps2/include/menudraw.hpp:908` |
| `CMenuQuestView` | 1 | `ps2/include/menushop.hpp:421` |
| `CMenuTreeMap` | 1 | `ps2/include/dngmenu.hpp:427` |
| `CMonsterMan` | 1 | `ps2/include/monster.hpp:439` |
| `CMosBookMenu` | 1 | `ps2/include/menuchr.hpp:578` |
| `CMovie` | 3 | `ps2/include/movie.hpp:227` |
| `CNameRegiMenu` | 1 | `ps2/include/nameregi.hpp:120` |
| `COutLineDraw` | 2 | `ps2/include/outline.hpp:23` |
| `CQuestManager` | 1 | `ps2/include/quest.hpp:57` |
| `CRedMarkModel` | 1 | `ps2/include/dng_event.hpp:282` |
| `CRemovalMenu` | 1 | `ps2/include/editmenu.hpp:464` |
| `CRepairEffect` | 1 | `ps2/include/menudraw.hpp:1014` |
| `CRepairManager` | 2 | `ps2/include/menudraw.hpp:1074` |
| `CSWordAfterEffect` | 4 | `ps2/include/swordeffect.hpp:41` |
| `CSWordAfterImage` | 1 | `ps2/include/dng_effect.hpp:868` |
| `CSaveMenuClass` | 1 | `ps2/include/menuop.hpp:331` |
| `CShop` | 1 | `ps2/include/menushop.hpp:129` |
| `CShopMenu` | 1 | `ps2/include/menushop.hpp:244` |
| `CSphida` | 1 | `ps2/include/sphida.hpp:142` |
| `CSubGameData` | 1 | `ps2/include/savedata.hpp:699` |
| `CTreasureBoxManager` | 1 | `ps2/include/dng_event.hpp:565` |
| `CVillagerPlaceInfo` | 1 | `ps2/include/villagermngr.hpp:74` |
| `CVillagerPlaceInfo::Node` | 1 | `ps2/include/villagermngr.hpp:81` |
| `CWater` | 1 | `ps2/include/water.hpp:138` |
| `CWaterFrame` | 1 | `ps2/include/water.hpp:271` |
| `CWaveTable` | 1 | `ps2/include/wavetable.hpp:27` |
| `CWorldMapMenu` | 1 | `ps2/include/menumap.hpp:141` |
| `ClsMes` | 12 | `ps2/include/nd_meswin.hpp:203` |
| `DownLoadEntry` | 2 | `ps2/src/editmenu.cpp:127` |
| `EFF_SPT_BASE` | 1 | `ps2/include/effscript.hpp:86` |
| `GeoRequestCheck` | 1 | `ps2/src/editmenu.cpp:208` |
| `GeoStoneDmyCnt` | 2 | `ps2/src/editmenu.cpp:167` |
| `MDT_HEADER` | 1 | `ps2/include/mg_dataset.hpp:69` |
| `MENU_DRAW_ENV` | 1 | `ps2/include/menumain.hpp:200` |
| `SAVEDATA_FORMAT` | 1 | `ps2/include/memcard.hpp:189` |
| `SAVE_CONVERT_WORK` | 1 | `ps2/include/convviewlp.hpp:67` |
| `TITLE_INFO` | 1 | `ps2/include/title.hpp:244` |
| `TRESURE_BOX_FLOOR_INFO` | 1 | `ps2/include/dng_event.hpp:126` |
| `_EFF_SCRIPT` | 1 | `ps2/include/effscript.hpp:152` |
| `mgC3DSprite` | 1 | `ps2/include/mg_sprite.hpp:193` |
| `mgCCamera` | 1 | `ps2/include/mg_camera.hpp:27` |
| `mgCCameraFollow` | 3 | `ps2/include/mg_camera.hpp:306` |
| `mgCEnterIMGInfo` | 1 | `ps2/include/mg_texture.hpp:206` |
| `mgCFace` | 1 | `ps2/include/mg_visual.hpp:67` |
| `mgCFrame` | 3 | `ps2/include/mg_frame.hpp:341` |
| `mgCFrame::BoundInfo` | 5 | `ps2/include/mg_frame.hpp:357` |
| `mgCFrameAttr` | 8 | `ps2/include/mg_frame.hpp:89` |
| `mgCMemory` | 1 | `ps2/include/mg_memory.hpp:46` |
| `mgCShadowFixMDT` | 1 | `ps2/include/mg_shadow.hpp:93` |
| `mgCShadowMDT` | 1 | `ps2/include/mg_shadow.hpp:27` |
| `mgCTexture` | 4 | `ps2/include/mg_texture.hpp:221` |
| `mgCTextureAnime` | 1 | `ps2/include/mg_tanime.hpp:276` |
| `mgCVisualFixMDT` | 2 | `ps2/include/mg_visual.hpp:382` |
| `mgCVisualMDT` | 1 | `ps2/include/mg_visual.hpp:143` |
| `mgCVisualMotionMDT` | 2 | `ps2/include/visualmotion.hpp:65` |
| `mgFACE_GROUP` | 2 | `ps2/include/mg_visual.hpp:86` |

## Retained constructor-class evidence

The completed 149-unit native corpus gives **74 class-6 sites** and **17 class-3 sites** among the 108 retail-inline allocations. **17 sites have no observed named root constructor read**.
Out-of-line constructor sites and exclusions have no inlined constructor
classifier at this allocation, so they are marked n/a rather than assigned
an artificial 3/6 value. Callback repetitions do not multiply site counts.

| Unobserved allocation identity | Current source / retained retail evidence |
| --- | --- |
| `convviewlp / SAVE_CONVERT_WORK` | Implicit wrapper around scalar CSaveData; retail retains the nested CEditData element-construction loop. |
| `dng_main / CRedMarkModel` | Implicit derived constructor; retail retains the CObjectFrame base vptr/initialization chain and the derived vptr store. |
| `dng_main / CTreasureBoxManager` | Implicit constructor of CTreasureBox[TREASURE_BOX_MAX]; retail retains the element-construction loop. |
| `dng_main / CMonsterMan` | Implicit constructor of nontrivial member arrays; retail retains memory, monster-reference and interpreter construction loops. |
| `editloop / CMapTreasureBox` | Constructor body is defined in map.cpp; it is unavailable for inlining in the current editloop TU, while retail retains the inline character/base chain. |
| `effscript / _EFF_SCRIPT` | Implicit constructor of scalar CRunScript member; retail calls the interpreter constructor inside the allocation guard. |
| `mapparts / CList<CMapPiece>` | Current owning caller is assembly-only; retail retains the explicit list template and inline map-piece/base chain. |
| `mapparts / CList<CObjAnime>` | Current owning caller is assembly-only; retail retains the explicit list template, inline animation scalar initialization and virtual list initialization. |
| `memcard / SAVEDATA_FORMAT` | Implicit wrapper around scalar CSaveData; retail retains the nested CEditData element-construction loop. |
| `menuchr / CRepairManager` | Implicit constructor of effect_stack[8] plus scalar model_stack; retail retains the memory-element construction loop. |
| `menushop / CMenuQuestView` | Implicit derived constructor; retail calls CBaseMenuClass constructor and writes the derived vptr inside the allocation guard. |
| `menusys / CRepairManager` | Implicit constructor of effect_stack[8] plus scalar model_stack; retail retains the memory-element construction loop. |
| `mg_dataset / mgCShadowMDT` | Implicit derived constructor; retail retains the visual/MDT vptr and virtual-initialization chain followed by the shadow vptr. |
| `mg_dataset / mgCShadowFixMDT` | Implicit derived constructor; retail retains the visual/MDT vptr and virtual-initialization chain followed by shadow and fixed-shadow vptrs. |
| `mg_visual / mgCVisualFixMDT` | Header constructor calls virtual Initialize; the current allocation caller is assembly-only, so this TU supplies no root inline-info read. |
| `pbuggy / CEffectScriptMan` | Header constructor constructs its sprite and calls Initialize(NULL,-1,-1); this pbuggy allocation caller is assembly-only. |
| `visualmotion / mgCVisualMotionMDT` | Header constructor calls virtual Initialize; the current allocation caller is assembly-only, so this TU supplies no root inline-info read. |

## Reproduction and receipts

`scan.py` enumerates each `jal __nw__FUiP1` once from `ps2/asm/pal/*.s`;
`retail-sites.json` preserves every allocation window, exact byte words,
branch, copy, caller, unit, source line and constructor guard region.
`source_scan.py` attaches exact current C++ expressions, including existing
`NewInventActionChara` and `ScriptArgAddList` inline helper expansion.
`enrich.py` attaches type definitions and the warm objdiff status.
`census-enriched.json` and `type-definitions.json` are the structured results;
`source-functions.json` retains source signatures and scalar/array expression
boundaries. The six `m2c/*.txt` outputs were generated through the required
`chronicletwo_dev:sf-63f7a9e` image and container wrapper. All artifacts live
under `.private/pntc/census/`; no game source/header or tracked document
was edited by this census subagent.

## Current design reference

This dated evidence retains its original measurement scope.
[The consolidated placement-conversion design](placement-new.md) owns the current
capability, activation rows, safety requirements, and accepted source status.
