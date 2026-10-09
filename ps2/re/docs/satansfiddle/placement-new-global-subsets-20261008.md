# Extended global placement-new control comparison

Captured at 2026-10-08T22:05:45.567833+00:00. All seven corpora are complete: 149 successful compilations each. This audit did not build, change objects, use containers/network, or modify tracked files.

Canonical and every control contain the same 6,773 scored retail identities; missing/extra identities are listed in JSON. Canonical has 6,658 zero-word rows, of which 6,654 also have equal relocation offset/type sets and fit the retail extent. “Score zero” below requires all three. It remains provisional: relocation targets are masked, and data/helper ownership, source admissibility and linked-image acceptance are not tested by this native diagnostic.

## Canonical comparison

| Control | Native object hashes changed / 149 | Score rows changed | Prior score-zero losses | New guarded score-zero gains | Total score-zero |
| --- | ---: | ---: | ---: | ---: | ---: |
| `force-new-all` | 27 | 46 | 1 | 24 | 6677 |
| `request4-all` | 25 | 44 | 0 | 25 | 6679 |
| `templates4-all` | 3 | 4 | 0 | 2 | 6656 |
| `constructors4-all` | 32 | 60 | 13 | 24 | 6665 |
| `headers11-all` | 25 | 43 | 1 | 23 | 6676 |
| `headers-request11-all` | 23 | 41 | 0 | 24 | 6678 |

Whole-object counts compare every byte of the all-drafts native `.o`, including metadata. They are distinct from scored function differences. ELF section analysis treats SHT_NOBITS as having no file-backed payload; relocation/symbol/allocated-section changes are preserved in JSON.

## Changed native objects and source status

**force-new-all:** `dng_main`, `dynamicanime`, `editeff`, `editexception`, `editloop`, `editmap`, `editmenu`, `editmode`, `effscript`, `event_func`, `fishing`, `funcpoint`, `inventmn`, `map`, `mdslist`, `menuaqua`, `menuchr`, `menudraw`, `menumain`, `menuop`, `menusys`, `mg_dataset`, `mg_tanime`, `monster`, `sceneload`, `title`, `water`.

Changed scored rows by current source status: `{'active native': 1, 'guarded': 45}`. Metadata-only changed objects: `editmenu`, `monster`.

**request4-all:** `dynamicanime`, `editeff`, `editexception`, `editloop`, `editmap`, `editmenu`, `editmode`, `effscript`, `event_func`, `fishing`, `funcpoint`, `inventmn`, `map`, `mdslist`, `menuaqua`, `menuchr`, `menudraw`, `menumain`, `menuop`, `menusys`, `mg_dataset`, `monster`, `sceneload`, `title`, `water`.

Changed scored rows by current source status: `{'guarded': 44}`. Metadata-only changed objects: `editmenu`, `monster`.

**templates4-all:** `funcpoint`, `map`, `mg_tanime`.

Changed scored rows by current source status: `{'guarded': 4}`. Metadata-only changed objects: .

**constructors4-all:** `dng_main`, `dngmenu`, `dynamicanime`, `editeff`, `editexception`, `editloop`, `editmap`, `editmenu`, `editmode`, `effscript`, `event_func`, `fishing`, `font`, `funcpoint`, `inventmn`, `map`, `mdslist`, `menuaqua`, `menuchr`, `menudraw`, `menumain`, `menumap`, `menuop`, `menushop`, `menusys`, `mg_dataset`, `mg_tanime`, `monster`, `outline`, `sceneload`, `title`, `water`.

Changed scored rows by current source status: `{'active native': 13, 'guarded': 47}`. Metadata-only changed objects: `dngmenu`, `menushop`, `monster`, `outline`.

**headers11-all:** `dng_main`, `dynamicanime`, `editexception`, `editloop`, `editmap`, `editmode`, `effscript`, `event_func`, `fishing`, `funcpoint`, `inventmn`, `map`, `mdslist`, `menuaqua`, `menuchr`, `menudraw`, `menumain`, `menuop`, `menusys`, `mg_dataset`, `mg_tanime`, `monster`, `sceneload`, `title`, `water`.

Changed scored rows by current source status: `{'active native': 1, 'guarded': 42}`. Metadata-only changed objects: `monster`.

**headers-request11-all:** `dynamicanime`, `editexception`, `editloop`, `editmap`, `editmode`, `effscript`, `event_func`, `fishing`, `funcpoint`, `inventmn`, `map`, `mdslist`, `menuaqua`, `menuchr`, `menudraw`, `menumain`, `menuop`, `menusys`, `mg_dataset`, `monster`, `sceneload`, `title`, `water`.

Changed scored rows by current source status: `{'guarded': 41}`. Metadata-only changed objects: `monster`.

Source units changed from the census snapshot: none. Protected dng_main source/header was not read; its baseline manifest establishes native status.

## Previously zero functions that lose zero

| Control | Unit / exact symbol | Canonical | Experiment | Body / retail extent | Status |
| --- | --- | ---: | ---: | --- | --- |
| `force-new-all` | `dng_main/InitDungeonMain__F13INIT_LOOP_ARG` | 0 | 1827; reloc | 0x20E0 / 0x2110 | active native |
| `request4-all` | none among scored identities | | | | |
| `templates4-all` | none among scored identities | | | | |
| `constructors4-all` | `dng_main/InitDungeonMain__F13INIT_LOOP_ARG` | 0 | 1827; reloc | 0x20E0 / 0x2110 | active native |
| `constructors4-all` | `editmenu/MenuGeoramaDraw__Fv` | 0 | 10; reloc | 0x1A8 / 0x1B0 | active native |
| `constructors4-all` | `editmenu/MenuGeoramaTitleDraw__FRiPfi` | 0 | 13; reloc | 0x140 / 0x140 | active native |
| `constructors4-all` | `editmenu/MenuGeoramaListDraw__FRiPfii` | 0 | 94; reloc | 0xFC8 / 0xFD0 | active native |
| `constructors4-all` | `editmenu/MenuPlacedHouseDraw__FRi` | 0 | 10; reloc | 0x97C / 0x980 | active native |
| `constructors4-all` | `event_func/EventTimeDraw__Fv` | 0 | 36 | 0xB58 / 0xB60 | active native |
| `constructors4-all` | `font/set2DSprite_Fuchi__FP11mgCDrawPrim4RECT4RECTii` | 0 | 169; reloc | 0x700 / 0x700 | active native |
| `constructors4-all` | `font/DrawChar__5CFontFP11mgCDrawPrimiiii10RGBAQ_TYPEUc` | 0 | 14 | 0x20C / 0x210 | active native |
| `constructors4-all` | `menuaqua/Draw__9CAquariumFv` | 0 | 10; reloc | 0xE78 / 0xE80 | active native |
| `constructors4-all` | `menumap/Draw__13CWorldMapMenuFv` | 0 | 26; reloc | 0xF28 / 0xF30 | active native |
| `constructors4-all` | `menuop/MenuManualDraw__Fv` | 0 | 10; reloc | 0x67C / 0x680 | active native |
| `constructors4-all` | `menusys/Draw__11CItemSelectFv` | 0 | 64; reloc | 0xA04 / 0xA10 | active native |
| `constructors4-all` | `title/TitleHDDInstallDraw__Fv` | 0 | 2 | 0x410 / 0x410 | active native |
| `headers11-all` | `dng_main/InitDungeonMain__F13INIT_LOOP_ARG` | 0 | 1827; reloc | 0x20E0 / 0x2110 | active native |
| `headers-request11-all` | none among scored identities | | | | |

## New guarded zero-score candidates

| Unit / exact symbol | Canonical | Force | Request | Templates | Constructors | Headers | Header request |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `dynamicanime/dynCOLLISION__FP9SPI_STACKi` | 2 | 0 | 0 | 2 | 0 | 0 | 0 |
| `editeff/EditSetPlaceAnime__FiP9CMapParts` | 2 | 0 | 0 | 2 | 0 | 2 | 2 |
| `editexception/InitFirePowder__FiP6CSceneiP9mgCMemory` | 150; reloc | 0 | 0 | 150; reloc | 0 | 0 | 0 |
| `editmap/emapMASK_PARTS_NAME__FP9SPI_STACKi` | 2 | 0 | 0 | 2 | 0 | 0 | 0 |
| `editmap/emapRIVER_PARTS_NAME__FP9SPI_STACKi` | 2 | 0 | 0 | 2 | 0 | 0 | 0 |
| `editmap/emapWATER_PARTS_NAME__FP9SPI_STACKi` | 2 | 0 | 0 | 2 | 0 | 0 | 0 |
| `editmode/LoadEditCursor__FP9mgCMemoryi` | 270; reloc | 0 | 0 | 270; reloc | 0 | 0 | 0 |
| `effscript/AssignCharacter__16CEffectScriptManFP11_EFF_SCRIPTi` | 2 | 0 | 0 | 2 | 0 | 0 | 0 |
| `effscript/BuildBase__16CEffectScriptManFiP1iP1iP9mgCMemoryi` | 2 | 0 | 0 | 2 | 0 | 0 | 0 |
| `event_func/_COPY_CHARA__FP12RS_STACKDATAi` | 2 | 0 | 0 | 2 | 0 | 0 | 0 |
| `event_func/_ESM_INITIALIZE__FP12RS_STACKDATAi` | 2 | 0 | 0 | 2 | 0 | 0 | 0 |
| `fishing/StepDataLoading__FPv` | 651; reloc; oversized | 0 | 0 | 651; reloc; oversized | 0 | 0 | 0 |
| `fishing/sgRestartFishing__FP11SubGameInfo` | 2 | 0 | 0 | 2 | 0 | 0 | 0 |
| `funcpoint/Add__14CFuncPointMngrFiP9mgCMemory` | 2 | 0 | 0 | 0 | 0 | 0 | 0 |
| `inventmn/MenuInventInit__FP9mgCMemoryPii` | 606; reloc | 506; reloc | 0 | 606; reloc | 506; reloc | 506; reloc | 0 |
| `mdslist/Copy__9CMapPieceFR9CMapPieceP9mgCMemory` | 57; reloc | 0 | 0 | 57; reloc | 0 | 0 | 0 |
| `mdslist/CreateChara__FPUiPcP9mgCMemory` | 2 | 0 | 0 | 2 | 0 | 0 | 0 |
| `menuchr/KeyStep__12CMosBookMenuFv` | 2 | 0 | 0 | 2 | 0 | 0 | 0 |
| `menuchr/LoadBGNPCModel__15CMenuChrCngMenuFi` | 2 | 0 | 0 | 2 | 0 | 0 | 0 |
| `menuchr/LoadMenuData__15CMenuCostumeSelFP9mgCMemoryPi` | 2 | 0 | 0 | 2 | 0 | 0 | 0 |
| `menudraw/GeneratePoly__14CRepairManagerFPfi` | 117; reloc | 115; reloc | 0 | 117; reloc | 115; reloc | 115; reloc | 0 |
| `menuop/MenuManualInit__FP9mgCMemoryPii` | 285; reloc; oversized | 0 | 0 | 285; reloc; oversized | 0 | 0 | 0 |
| `menusys/MenuModeMalloc__13CMenuItemInfoFP9mgCMemory` | 127; reloc | 0 | 0 | 127; reloc | 0 | 0 | 0 |
| `mg_tanime/NewTexAnimeData__15mgCTextureAnimeFP9mgCMemory` | 6 | 0 | 6 | 0 | 0 | 0 | 6 |
| `sceneload/CopyChara__6CSceneFiiP9mgCMemory` | 2 | 0 | 0 | 2 | 0 | 0 | 0 |
| `sceneload/LoadChara__6CSceneFiPUiPcP9mgCMemoryP9mgCMemoryP9mgCMemoryii` | 2 | 0 | 0 | 2 | 0 | 0 | 0 |

The union has 26 guarded candidates. None is promoted by this analysis. Every candidate still needs source review, resolved-target/whole-object validation after its guard is removed, and linked-image acceptance.

## New controls compared with earlier policies

| Comparison | Full native objects differ | Score rows differ | Before-only score zeros | After-only score zeros |
| --- | ---: | ---: | ---: | ---: |
| `constructors4-all` versus `force-new-all` | 16 | 14 | 12 | 0 |
| `constructors4-all` versus `request4-all` | 17 | 21 | 15 | 1 |
| `constructors4-all` versus `templates4-all` | 31 | 56 | 13 | 22 |
| `headers11-all` versus `force-new-all` | 5 | 4 | 1 | 0 |
| `headers11-all` versus `request4-all` | 11 | 9 | 4 | 1 |
| `headers11-all` versus `templates4-all` | 22 | 39 | 1 | 21 |
| `headers-request11-all` versus `force-new-all` | 12 | 10 | 2 | 3 |
| `headers-request11-all` versus `request4-all` | 4 | 3 | 1 | 0 |
| `headers-request11-all` versus `templates4-all` | 24 | 39 | 1 | 23 |

Pairwise JSON gives full unit lists and every changed score row, including comparisons among the three new controls. Whole-object equality is literal byte equality, not equality of score rows.

## Actual hook scope

`force-new-all` is the earlier broad construction-walk class override; active-walk nested constructor reads can be selected. `request4-all` records the named allocator and direct constructor, then requests enclosing statement conversion after normal inlining. `templates4-all` substitutes class 3 before lowering for direct constructor identities containing `<`.

`constructors4-all` is broader: at each constructor inline-info read it selects original class 6 and a `__ct__` name, regardless of allocator, active-new depth or direct status. It therefore modifies ordinary member/base construction and constructor inlining outside placement-new. It is not a constructors-only placement-new setting.

`headers11-all` selects class 6 at the inline-info read only when the captured construction-context constructor identity equals the current constructor identity, the allocator alias is `__nw__FUiP1` or `__nw`, and the exact identity is in the header list. It substitutes the low EAX class byte with 3 before lowering.

`headers-request11-all` records the original class 6 direct constructor/allocator at construction entry, leaves the classifier result alone, and writes the conversion-request flag after the normal construction-expression walk. It additionally requires exact header-list membership. Class 3 header constructors remain listed but do not meet the class-6 condition.

The experimental “direct” test compares the constructor name to the top captured context; it does not establish full call-node identity. The short allocator alias is not a complete verified allocator signature. These are global diagnostic controls, not the final fail-closed semantic selector.

The header list contains 46 observed exact compiler identities with explicit verified bodies in current headers, including 36 originally class 6. It is a conservative observed subset, not every constructor attached to the 99 census types. Eight census types have explicit header bodies without observed identities, and 28 have implicit/trivial/synthesized construction unresolved; none receives a guessed identity. Ten observed cpp constructor identities, including CMapParts, are excluded. Caller labels in these old probe traces are not used as reliable per-function selectors.

## Trace coverage

| Control | Logs | Inline reads | Selected inline events | Selected outside active new | Selected non-direct | Selected request-end events | Distinct selected identities |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `force-new-all` | 149 | 594 | 76 | 0 | 0 | 0 | 26 |
| `request4-all` | 149 | 355 | 0 | 0 | 0 | 74 | 26 |
| `templates4-all` | 149 | 515 | 4 | 0 | 0 | 0 | 4 |
| `constructors4-all` | 149 | 727 | 676 | 600 | 602 | 0 | 28 |
| `headers11-all` | 149 | 589 | 67 | 0 | 0 | 0 | 21 |
| `headers-request11-all` | 149 | 363 | 0 | 0 | 0 | 67 | 21 |

These are trace-event counts, not unique source allocations or expected_matches. Repeated lowering passes and nested constructor reads can emit multiple events. The older force-new trace lacks the direct flag and named construction-context records, so its zero non-direct count does not prove direct scope.

**constructors4-all:** 33 / 46 allowed header identities observed; missing allowed identities: `__ct__10CCollisionFv`, `__ct__10CFuncPointFv`, `__ct__12CDACollisionFv`, `__ct__12CObjectFrameFv`, `__ct__14CFuncPointMngrFv`, `__ct__14PartsGroupDataFv`, `__ct__15CFuncPointCheckFv`, `__ct__7CObjectFv`, `__ct__9mgCMemoryFv`, `__ct__9mgCObjectFv`, `__ct__9mgCVisualFv`, `__ct__9mgRect<f>Fv`, `__ct__9mgRect<i>Fv`.

Selected identities outside the header list: `__ct__11CItemSelectFv`, `__ct__13DownLoadEntryFv`, `__ct__14GeoStoneDmyCntFv`, `__ct__15CMenuChrCngMenuFv`, `__ct__9CMapPartsFv`.

**headers11-all:** 46 / 46 allowed header identities observed; missing allowed identities: none.

Selected identities outside the header list: none.

**headers-request11-all:** 40 / 46 allowed header identities observed; missing allowed identities: `__ct__10CCollisionFv`, `__ct__10CFuncPointFv`, `__ct__12CDACollisionFv`, `__ct__12CObjectFrameFv`, `__ct__14PartsGroupDataFv`, `__ct__9mgRect<i>Fv`.

Selected identities outside the header list: none.

## Best remaining placement-family scores

| Unit / exact symbol | Canonical | Force | Request | Templates | Constructors | Headers | Header request | Best residual |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `dngmenu/DngTreeMapInit__FP9mgCMemoryPiii` | 55; reloc | 55; reloc | 55; reloc | 55; reloc | 55; reloc | 55; reloc | 55; reloc | 55; reloc |
| `editloop/EditInit__F13INIT_LOOP_ARG` | 1226; reloc | 1223; reloc | 1223; reloc | 1226; reloc | 1223; reloc | 1223; reloc | 1223; reloc | 1223; reloc |
| `effscript/CreateEffSpt__16CEffectScriptManFiii` | 206; reloc | 211; reloc | 211; reloc | 206; reloc | 211; reloc | 211; reloc | 211; reloc | 206; reloc |
| `effscript/SetCharacter__16CEffectScriptManFP11CCharacter2ii` | 24 | 21 | 21 | 24 | 21 | 21 | 21 | 21 |
| `event_func/_COPY_MONS2SCNCHR__FP12RS_STACKDATAi` | 246; reloc | 244; reloc | 244; reloc | 246; reloc | 244; reloc | 244; reloc | 244; reloc | 244; reloc |
| `fishing/InitSuccess__FP6CScene` | 25 | 24 | 24 | 25 | 24 | 24 | 24 | 24 |
| `gyorace/sgInitGyoRace__FP11SubGameInfo` | 431; reloc; oversized | 431; reloc; oversized | 431; reloc; oversized | 431; reloc; oversized | 431; reloc; oversized | 431; reloc; oversized | 431; reloc; oversized | 431; reloc; oversized |
| `inventmn/IsAccessAlbum__11CMenuInventFv` | 1080; reloc | 845; reloc | 845; reloc | 1080; reloc | 845; reloc | 845; reloc | 845; reloc | 845; reloc |
| `inventmn/IsCreateObject__11CMenuInventFii` | 380; reloc | 379; reloc | 4 | 380; reloc | 379; reloc | 379; reloc | 4 | 4 |
| `inventmn/LoadCharaCheck__11CMenuInventFv` | 190; reloc | 190; reloc | 145; reloc | 190; reloc | 190; reloc | 190; reloc | 145; reloc | 145; reloc |
| `map/AddPartsGroup__4CMapFPcP9CMapPartsP9mgCMemory` | 19; reloc; oversized | 17; reloc; oversized | 17; reloc; oversized | 17; reloc; oversized | 17; reloc; oversized | 17; reloc; oversized | 17; reloc; oversized | 17; reloc; oversized |
| `map/CreateDrawRect__4CMapFP9mgCMemoryP9mgVu0FBOXP9mgVu0FBOXi` | 112; reloc; oversized | 111; reloc; oversized | 111; reloc; oversized | 111; reloc; oversized | 111; reloc; oversized | 111; reloc; oversized | 111; reloc; oversized | 111; reloc; oversized |
| `menuaqua/SettingAqua__9CAquariumFv` | 16 | 14 | 14 | 16 | 14 | 14 | 14 | 14 |
| `menuaqua/Step__9CAquariumFv` | 1111; reloc | 1111; reloc | 1111; reloc | 1111; reloc | 1111; reloc | 1111; reloc | 1111; reloc | 1111; reloc |
| `menuchr/EnterDataMenu__15CMenuChrCngMenuFPUc` | 376; reloc; oversized | 376; reloc; oversized | 376; reloc; oversized | 376; reloc; oversized | 376; reloc; oversized | 376; reloc; oversized | 376; reloc; oversized | 376; reloc; oversized |
| `menuchr/MenuCharaChangeInit__FP9mgCMemoryPii` | 236; reloc | 258; reloc | 258; reloc | 236; reloc | 258; reloc | 236; reloc | 236; reloc | 236; reloc |
| `menuchr/MenuCostumeInit__FP9mgCMemoryPii` | 161; reloc | 158; reloc | 158; reloc | 161; reloc | 158; reloc | 158; reloc | 158; reloc | 158; reloc |
| `menumain/MenuMainInit__FP13MENU_INIT_ARG` | 792; reloc | 804; reloc | 804; reloc | 792; reloc | 804; reloc | 804; reloc | 804; reloc | 792; reloc |
| `menushop/MenuNPCQuestViewInit__FP9mgCMemoryPii` | 46; reloc | 46; reloc | 46; reloc | 46; reloc | 46; reloc | 46; reloc | 46; reloc | 46; reloc |
| `menusys/IsAskExtend__13CMenuItemInfoFii` | 528; reloc | 528; reloc | 528; reloc | 528; reloc | 528; reloc | 528; reloc | 528; reloc | 528; reloc |
| `menusys/MenuItemDebugKey__Fv` | 1208; reloc | 14; reloc | 14; reloc | 1208; reloc | 14; reloc | 14; reloc | 14; reloc | 14; reloc |
| `menusys/MenuItemSelectInit__FP9mgCMemoryPii` | 146; reloc | 15; reloc | 15; reloc | 146; reloc | 15; reloc | 146; reloc | 146; reloc | 15; reloc |
| `mg_dataset/CopyFrameSub__FP8mgCFrameP9mgCMemoryiPP8mgCFrame` | 46; reloc | 46; reloc | 46; reloc | 46; reloc | 46; reloc | 46; reloc | 46; reloc | 46; reloc |
| `mg_dataset/CopyFrame__FP8mgCFrameP8mgCFrameP9mgCMemoryiPP8mgCFrame` | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
| `mg_dataset/CreateFrameVisual__FP8mgCFrameP9mgCMemoryP9mgCMemoryP8mgCFrameP13MDTOBJ_HEADERP10MDT_HEADERiP17mgCTextureManagerPUiiPP8mgCFramePA4_A4_f` | 6 | 107 | 3 | 6 | 107 | 3 | 3 | 3 |
| `mg_dataset/End__13mgCMDTBuilderFP8mgCFrameP12mgCVisualMDTP10mgLoadData` | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
| `scenevillager/CharaObjectOnOff__6CSceneFiP9mgCMemory` | 6; reloc | 6; reloc | 6; reloc | 6; reloc | 6; reloc | 6; reloc | 6; reloc | 6; reloc |
| `title/TitleBootInit__Fv` | 56; reloc | 54; reloc | 54; reloc | 56; reloc | 54; reloc | 54; reloc | 54; reloc | 54; reloc |
| `water/CreateWaterFrame__FiiPfPfP9mgCMemory` | 82; reloc | 46; reloc | 46; reloc | 82; reloc | 46; reloc | 46; reloc | 46; reloc | 46; reloc |

The family has 55 guarded census callers, including explicit operator-new and trivial sites; 26 reach score zero under at least one control. Presence in this family does not attribute every residual difference to placement-new. “reloc” means relocation offset/type sets differ; “oversized” means the compiled body exceeds the retail extent.

## Full-build evidence boundaries

The earlier request4 accepted-build snapshot at 2026-10-08T21:30:02.552532+00:00 compared all 149 assembled game objects and all 306 recursive objects to baseline: none differed, and the linked ELF was byte-identical. Those exact hashes and successful SCES_511.90/check_objects receipts remain in `global-comparison.json`.

That was a full build with the original guards selecting retail assembly. No full build or promotion validation is claimed for constructors4, headers11 or headers-request11. This extension compares complete native all-drafts corpora, and preserves the previous assembled proof with its original timestamp instead of sampling an unrelated in-progress parent build.

Private JSON includes full object SHA-256 maps for all seven corpora; section differences; every changed score/lost-zero/new-gain row; trace lines and hashes; header-list hash; probe-source hashes; corpus completion markers; and the prior assembled snapshot reference. The reproducible driver is `compare_global_extended.py`.

## Current design reference

This dated evidence retains its original measurement scope.
[The consolidated placement-conversion design](placement-new.md) owns the current
capability, activation rows, safety requirements, and accepted source status.
