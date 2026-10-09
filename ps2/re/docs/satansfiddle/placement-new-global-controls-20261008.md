# Global placement-new policy comparison

Captured at 2026-10-08T21:30:02.552532+00:00. All comparisons are read-only; this subtask did not build, modify objects, alter tracked files or run any image operation.

## Native corpus results

Each corpus has 149 successful unit compilations and the same 6,773 scored retail-function identities. The canonical corpus has 6,654 score-zero rows; this is a native diagnostic metric, not the official 6,749 matched-function coverage. Four more canonical rows have zero masked words but unequal relocation-kind sets.

| Policy | Whole native objects changed / 149 | Score rows changed | Previous score-zero losses | New guarded score-zero gains |
| --- | ---: | ---: | ---: | ---: |
| `force-new-all` | 27 | 46 | 1 | 24 |
| `request4-all` | 25 | 44 | 0 | 25 |
| `templates4-all` | 3 | 4 | 0 | 2 |

A score-zero row requires zero masked instruction words, matching relocation offset/type sets, and a compiled body no larger than the retail extent. Padding shorter bodies with zero may be permitted by the final linker layout, but these scores do not prove that permission. No score compares resolved relocation destinations, data layout, emitted helper ownership, source admissibility, or whole-unit acceptance. Oversized rows and zero-word/unequal-relocation rows are not accepted as score zero here.

## Changed native objects

**force-new-all:** `dng_main`, `dynamicanime`, `editeff`, `editexception`, `editloop`, `editmap`, `editmenu`, `editmode`, `effscript`, `event_func`, `fishing`, `funcpoint`, `inventmn`, `map`, `mdslist`, `menuaqua`, `menuchr`, `menudraw`, `menumain`, `menuop`, `menusys`, `mg_dataset`, `mg_tanime`, `monster`, `sceneload`, `title`, `water`.

**request4-all:** `dynamicanime`, `editeff`, `editexception`, `editloop`, `editmap`, `editmenu`, `editmode`, `effscript`, `event_func`, `fishing`, `funcpoint`, `inventmn`, `map`, `mdslist`, `menuaqua`, `menuchr`, `menudraw`, `menumain`, `menuop`, `menusys`, `mg_dataset`, `monster`, `sceneload`, `title`, `water`.

**templates4-all:** `funcpoint`, `map`, `mg_tanime`.

Full before/after object SHA-256 values and section differences are in `global-comparison.json`; these counts include metadata changes.

## Previous zero-score regression

`force-new-all` changes `dng_main/InitDungeonMain__F13INIT_LOOP_ARG` from zero to 1,827 differing masked words. Body 0x2110 -> 0x20E0; retail extent 0x2110; relocation-kind set changes from equal to unequal. Baseline manifest identifies it as active native code. This rejects that broad policy as a regression-free setting. The protected source/header was not read or changed.

`request4-all`: none among the scored rows.

`templates4-all`: none among the scored rows.

## Guarded zero-score gains

| Unit / symbol | Canonical words | Force-new | Request4 | Templates4 |
| --- | ---: | ---: | ---: | ---: |
| `dynamicanime/dynCOLLISION__FP9SPI_STACKi` | 2 | 0 | 0 | 2 |
| `editeff/EditSetPlaceAnime__FiP9CMapParts` | 2 | 0 | 0 | 2 |
| `editexception/InitFirePowder__FiP6CSceneiP9mgCMemory` | 150; reloc kinds differ | 0 | 0 | 150; reloc kinds differ |
| `editmap/emapMASK_PARTS_NAME__FP9SPI_STACKi` | 2 | 0 | 0 | 2 |
| `editmap/emapRIVER_PARTS_NAME__FP9SPI_STACKi` | 2 | 0 | 0 | 2 |
| `editmap/emapWATER_PARTS_NAME__FP9SPI_STACKi` | 2 | 0 | 0 | 2 |
| `editmode/LoadEditCursor__FP9mgCMemoryi` | 270; reloc kinds differ | 0 | 0 | 270; reloc kinds differ |
| `effscript/AssignCharacter__16CEffectScriptManFP11_EFF_SCRIPTi` | 2 | 0 | 0 | 2 |
| `effscript/BuildBase__16CEffectScriptManFiP1iP1iP9mgCMemoryi` | 2 | 0 | 0 | 2 |
| `event_func/_COPY_CHARA__FP12RS_STACKDATAi` | 2 | 0 | 0 | 2 |
| `event_func/_ESM_INITIALIZE__FP12RS_STACKDATAi` | 2 | 0 | 0 | 2 |
| `fishing/StepDataLoading__FPv` | 651; reloc kinds differ; oversized | 0 | 0 | 651; reloc kinds differ; oversized |
| `fishing/sgRestartFishing__FP11SubGameInfo` | 2 | 0 | 0 | 2 |
| `funcpoint/Add__14CFuncPointMngrFiP9mgCMemory` | 2 | 0 | 0 | 0 |
| `inventmn/MenuInventInit__FP9mgCMemoryPii` | 606; reloc kinds differ | 506; reloc kinds differ | 0 | 606; reloc kinds differ |
| `mdslist/Copy__9CMapPieceFR9CMapPieceP9mgCMemory` | 57; reloc kinds differ | 0 | 0 | 57; reloc kinds differ |
| `mdslist/CreateChara__FPUiPcP9mgCMemory` | 2 | 0 | 0 | 2 |
| `menuchr/KeyStep__12CMosBookMenuFv` | 2 | 0 | 0 | 2 |
| `menuchr/LoadBGNPCModel__15CMenuChrCngMenuFi` | 2 | 0 | 0 | 2 |
| `menuchr/LoadMenuData__15CMenuCostumeSelFP9mgCMemoryPi` | 2 | 0 | 0 | 2 |
| `menudraw/GeneratePoly__14CRepairManagerFPfi` | 117; reloc kinds differ | 115; reloc kinds differ | 0 | 117; reloc kinds differ |
| `menuop/MenuManualInit__FP9mgCMemoryPii` | 285; reloc kinds differ; oversized | 0 | 0 | 285; reloc kinds differ; oversized |
| `menusys/MenuModeMalloc__13CMenuItemInfoFP9mgCMemory` | 127; reloc kinds differ | 0 | 0 | 127; reloc kinds differ |
| `mg_tanime/NewTexAnimeData__15mgCTextureAnimeFP9mgCMemory` | 6 | 0 | 6 | 0 |
| `sceneload/CopyChara__6CSceneFiiP9mgCMemory` | 2 | 0 | 0 | 2 |
| `sceneload/LoadChara__6CSceneFiPUiPcP9mgCMemoryP9mgCMemoryP9mgCMemoryii` | 2 | 0 | 0 | 2 |

The union contains 26 guarded candidates. A candidate is not a promotion: guards remain active in the accepted full build. Each needs source hygiene, manual guard removal, resolved relocation and whole-object acceptance, then linked-image validation. Current NONMATCHING guard classification matches the census source hashes for all read units; dng_main is excluded from source reads.

## Best remaining placement-family scores

This family is every guarded caller in the complete scalar-placement census, including trivial and explicit-operator-new sites. Presence of a placement allocator does not imply that every residual difference is caused by this blocker. All four score rows, allocated types and construction modes are stored in JSON.

| Unit / symbol | Canonical | Force-new | Request4 | Templates4 | Best residual |
| --- | ---: | ---: | ---: | ---: | ---: |
| `dngmenu/DngTreeMapInit__FP9mgCMemoryPiii` | 55; reloc kinds differ | 55; reloc kinds differ | 55; reloc kinds differ | 55; reloc kinds differ | 55; reloc kinds differ |
| `editloop/EditInit__F13INIT_LOOP_ARG` | 1226; reloc kinds differ | 1223; reloc kinds differ | 1223; reloc kinds differ | 1226; reloc kinds differ | 1223; reloc kinds differ |
| `effscript/CreateEffSpt__16CEffectScriptManFiii` | 206; reloc kinds differ | 211; reloc kinds differ | 211; reloc kinds differ | 206; reloc kinds differ | 206; reloc kinds differ |
| `effscript/SetCharacter__16CEffectScriptManFP11CCharacter2ii` | 24 | 21 | 21 | 24 | 21 |
| `event_func/_COPY_MONS2SCNCHR__FP12RS_STACKDATAi` | 246; reloc kinds differ | 244; reloc kinds differ | 244; reloc kinds differ | 246; reloc kinds differ | 244; reloc kinds differ |
| `fishing/InitSuccess__FP6CScene` | 25 | 24 | 24 | 25 | 24 |
| `gyorace/sgInitGyoRace__FP11SubGameInfo` | 431; reloc kinds differ; oversized | 431; reloc kinds differ; oversized | 431; reloc kinds differ; oversized | 431; reloc kinds differ; oversized | 431; reloc kinds differ; oversized |
| `inventmn/IsAccessAlbum__11CMenuInventFv` | 1080; reloc kinds differ | 845; reloc kinds differ | 845; reloc kinds differ | 1080; reloc kinds differ | 845; reloc kinds differ |
| `inventmn/IsCreateObject__11CMenuInventFii` | 380; reloc kinds differ | 379; reloc kinds differ | 4 | 380; reloc kinds differ | 4 |
| `inventmn/LoadCharaCheck__11CMenuInventFv` | 190; reloc kinds differ | 190; reloc kinds differ | 145; reloc kinds differ | 190; reloc kinds differ | 145; reloc kinds differ |
| `map/AddPartsGroup__4CMapFPcP9CMapPartsP9mgCMemory` | 19; reloc kinds differ; oversized | 17; reloc kinds differ; oversized | 17; reloc kinds differ; oversized | 17; reloc kinds differ; oversized | 17; reloc kinds differ; oversized |
| `map/CreateDrawRect__4CMapFP9mgCMemoryP9mgVu0FBOXP9mgVu0FBOXi` | 112; reloc kinds differ; oversized | 111; reloc kinds differ; oversized | 111; reloc kinds differ; oversized | 111; reloc kinds differ; oversized | 111; reloc kinds differ; oversized |
| `menuaqua/SettingAqua__9CAquariumFv` | 16 | 14 | 14 | 16 | 14 |
| `menuaqua/Step__9CAquariumFv` | 1111; reloc kinds differ | 1111; reloc kinds differ | 1111; reloc kinds differ | 1111; reloc kinds differ | 1111; reloc kinds differ |
| `menuchr/EnterDataMenu__15CMenuChrCngMenuFPUc` | 376; reloc kinds differ; oversized | 376; reloc kinds differ; oversized | 376; reloc kinds differ; oversized | 376; reloc kinds differ; oversized | 376; reloc kinds differ; oversized |
| `menuchr/MenuCharaChangeInit__FP9mgCMemoryPii` | 236; reloc kinds differ | 258; reloc kinds differ | 258; reloc kinds differ | 236; reloc kinds differ | 236; reloc kinds differ |
| `menuchr/MenuCostumeInit__FP9mgCMemoryPii` | 161; reloc kinds differ | 158; reloc kinds differ | 158; reloc kinds differ | 161; reloc kinds differ | 158; reloc kinds differ |
| `menumain/MenuMainInit__FP13MENU_INIT_ARG` | 792; reloc kinds differ | 804; reloc kinds differ | 804; reloc kinds differ | 792; reloc kinds differ | 792; reloc kinds differ |
| `menushop/MenuNPCQuestViewInit__FP9mgCMemoryPii` | 46; reloc kinds differ | 46; reloc kinds differ | 46; reloc kinds differ | 46; reloc kinds differ | 46; reloc kinds differ |
| `menusys/IsAskExtend__13CMenuItemInfoFii` | 528; reloc kinds differ | 528; reloc kinds differ | 528; reloc kinds differ | 528; reloc kinds differ | 528; reloc kinds differ |
| `menusys/MenuItemDebugKey__Fv` | 1208; reloc kinds differ | 14; reloc kinds differ | 14; reloc kinds differ | 1208; reloc kinds differ | 14; reloc kinds differ |
| `menusys/MenuItemSelectInit__FP9mgCMemoryPii` | 146; reloc kinds differ | 15; reloc kinds differ | 15; reloc kinds differ | 146; reloc kinds differ | 15; reloc kinds differ |
| `mg_dataset/CopyFrameSub__FP8mgCFrameP9mgCMemoryiPP8mgCFrame` | 46; reloc kinds differ | 46; reloc kinds differ | 46; reloc kinds differ | 46; reloc kinds differ | 46; reloc kinds differ |
| `mg_dataset/CopyFrame__FP8mgCFrameP8mgCFrameP9mgCMemoryiPP8mgCFrame` | 1 | 1 | 1 | 1 | 1 |
| `mg_dataset/CreateFrameVisual__FP8mgCFrameP9mgCMemoryP9mgCMemoryP8mgCFrameP13MDTOBJ_HEADERP10MDT_HEADERiP17mgCTextureManagerPUiiPP8mgCFramePA4_A4_f` | 6 | 107 | 3 | 6 | 3 |
| `mg_dataset/End__13mgCMDTBuilderFP8mgCFrameP12mgCVisualMDTP10mgLoadData` | 1 | 1 | 1 | 1 | 1 |
| `scenevillager/CharaObjectOnOff__6CSceneFiP9mgCMemory` | 6; reloc kinds differ | 6; reloc kinds differ | 6; reloc kinds differ | 6; reloc kinds differ | 6; reloc kinds differ |
| `title/TitleBootInit__Fv` | 56; reloc kinds differ | 54; reloc kinds differ | 54; reloc kinds differ | 56; reloc kinds differ | 54; reloc kinds differ |
| `water/CreateWaterFrame__FiiPfPfP9mgCMemory` | 82; reloc kinds differ | 46; reloc kinds differ | 46; reloc kinds differ | 82; reloc kinds differ | 46; reloc kinds differ |

The census family has 55 guarded callers; 26 reach score zero under at least one experiment, and 0 have no native score. JSON retains ties between policies rather than claiming a unique best setting.

## Policy differences

`force-new-all` is the earlier pn2 classifier override. During a construction-expression walk, it substitutes class 3 at class-6 constructor inline reads. Its active-construction scope can cover nested construction and does not provide the later direct allocator/constructor filter. Its logged caller identity was already known to be a stale backend pointer; caller text from those traces is not used to select or count function results here.

`request4-all` is the pn4 conversion-request experiment. It records the direct allocator/constructor identity and original inline class, performs normal expression inlining, then requests statement conversion at the end of the relevant construction-expression walk. It leaves the inline classifier result unchanged. The private allocator filter accepts the compiler aliases `__nw__FUiP1` and `__nw`; the short alias by itself is not a validated full allocator signature. This experiment is not yet a production semantic selector.

`templates4-all` uses the pn4 direct-constructor inline-read override restricted to constructor identities containing `<`. It changes the three units instantiating the relevant list templates, zeros funcpoint Add and mg_tanime NewTexAnimeData, and does not solve ordinary character/menu chains.

Request4 uniquely zeros MenuInventInit and CRepairManager::GeneratePoly in these corpora. Force-new and Templates4 zero mg_tanime NewTexAnimeData while Request4 leaves its six-word baseline result. Thus forcing a constructor inline class and requesting enclosing-expression conversion are observably different policies, not interchangeable names for one patch.

The natural-cause controls in SUMMARY.md found no PCH/inliner/build-setting explanation or uninitialized-state defect. The global request result is empirical evidence for a broader compiler-lowering policy; it does not turn that intentional policy into a demonstrated state-initialization repair.

## Current full build: exact artifact preservation

All 149 game-unit assembled objects have exactly their baseline whole-file SHA-256 values. The recursive baseline object tree contains 306 `.o` files, including SDK/runtime/data/CRT objects; 0 differ, and there are 0 extra current objects. Every byte, including metadata, is included in these hash comparisons.

The linked SCES_511.90 is also byte-identical. Baseline/current SHA-256: `e4f91f03847a123a7c749c179f3f7959f149d2d4f6c60b5f73dc138c9bc83a10`.

The 149 source-only objdiff base objects have 147 identical whole-file hashes. `editmenu.cpp.o` and `monster.cpp.o` differ only in `.strtab`, with compiler-generated `@number` local-symbol names shifted; allocated sections, section order/sizes, relocation sections, and symbol metadata by index remain identical. This is a metadata difference and must not be described as 149/149 whole-file equivalence for the source-only objects.

| Source-only base object | Baseline SHA-256 | Current SHA-256 |
| --- | --- | --- |
| `editmenu.cpp.o` | `1beecf45f36f20437eb9ffd6b6bd6c4dda3ff4fb65ea0052de0b51ae6067c7a1` | `b770e2b01930014a4256e9aa970d64ebb8bf8ad832c04b4e5752082e7964f48e` |
| `monster.cpp.o` | `687207f647cf0e9c062e1f8205963962c8fe8171200b8c2e98d1e56157278d28` | `37f261be02114eb1324033f51a5a6b116e036a5d95a0056cffa25baf48e3de15` |

The build receipt shows a CLEAN rebuild, all ten file-backed sections OK, BSS/memory end OK at `0x01f64a00`, and `SCES_511.90: OK`. Its refreshed progress remains 6,749 perfect / 0 fuzzy / 123 assembly. The canonical-object receipt ends `149/149 units pass`. These establish preservation with the original guards still selecting retail assembly. They do not validate any newly native gain until its guard is removed. The logs themselves do not save an explicit process exit code; the report cites their observed completion markers instead.

Receipts: `.private/pntc/receipts/global-request-clean-build.log`, `.private/pntc/receipts/global-request-objects.log`, native corpus `scores.json` and `.o` files, `.private/pntc/baseline/obj`, and `.private/pntc/baseline/base`. Input receipt hashes, all object hashes, exact changed score rows, lost-zero rows and source guard hashes are in `global-comparison.json`.

## Current design reference

This dated evidence retains its original measurement scope.
[The consolidated placement-conversion design](placement-new.md) owns the current
capability, activation rows, safety requirements, and accepted source status.
