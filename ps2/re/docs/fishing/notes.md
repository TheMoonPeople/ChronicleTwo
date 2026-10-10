# fishing: reverse-engineering notes

Fishing sub game: casting, float and lure waiting, the fish battle, the miss
and success presentations, and the loading thread that reads the fishing
resources. Header: `ps2/include/fishing.hpp`. No first-game counterpart:
Dark Cloud's `fishing.hpp`/`fish.hpp` (CFish, CCharacter Rod, line points) is
a different design.

## Status

`InitSuccess` is the unit's only guarded function; every other function is
native. `sgRestartFishing` and `StepDataLoading` are native with scoped
`CCharacter2` placement rows in the compiler profile (one and seven sites);
see [placement conversion](../satansfiddle/placement-new.md).

`InitSuccess` prepares the caught-fish character, the fishing rewards and the
success message. Retail keeps the player character in `s2` and constructs the
fish in `s1`; the draft exchanges those saved registers. The exchange and the
allocation-result branch (retail tests the call result in `v0` and copies it
into the saved register in the delay slot; the draft copies first and tests
the copy) remain coupled in the original draft: retail keeps `fish_chara` as its own named web,
distinct from the allocation-result temporary, while the compiled draft lets
copy propagation replace the named local with that temporary. A measured
placement row restores the branch but leaves the saved-register exchange;
see [construction eligibility](placement-new-20261008.md#caught-fish-construction-eligibility) and [saved-register numbering](placement-new-20261008.md#saved-register-numbering). Declaration
order, scope, direct assignment to `FishChara`, `opt_lifetimes`,
`opt_dead_assignments` and `optimization_level 4` do not change the result;
`opt_propagation off`, `global_optimizer off`, `opt_common_subs off` and
`optimization_level 2` make it far worse. The three strings it consumes
(`at_932__4` "info.cfg", `at_2197__3`, `at_2198__3`) are the unit's only
remaining data markers.

`GetUkiWaitTime`'s width call `GetRandamNumber(1.0f, 1.3f, 0.6)` needs the
binary32 `0x3fa66666` evaluate-first row in the compiler profile: retail keeps
the 1.3f bits in `a0` while preparing 0.6f, then transfers all three arguments
to the FPRs.

## Linkage
- Global functions (header): sgInitFishing, sgRestartFishing, sgBreakFishing, sgExitFishing,
  sgLoopFishing, sgLoopFishing2, sgDrawFishing, sgSystemDrawFishing, ResetUkiCamera,
  GetAppearFish, FISH_PLACE_MAP::SetFishPlace, FISH_PLACE_MAP::CheckFishPlace, LoadFishPlaceData.
  All sg* return int (subgame's sgInitSubGame/sgDrawSubGameSystem use the results).
- Every other function is LOCAL in retail (intended C++ linkage: `static`), including SetNextMode,
  GetRandamNumber, GetFishParam, the fp* script tag handlers and `CharaControl` (retail symbol
  `CharaControl__FP6CSceneP11CPadControl__2`; another unit has a global of the same name).
  `FishLoadBG__FP9FISH_DATAP1` and `LoadExMotionBG__FP11SubGameInfoP1` take `u_long128 *`
  (`P1`) as their last parameter. `StepDataLoading` is declared and defined `static`.
- Data: only `stack_size` (int, 0x4, set to 0x40000 in CreateLoadThread) is GLOBAL in retail and
  is declared in the header. Every other named datum in .data/.sbss/.bss is local.

## Types (names other than FISH_DATA, FISH_PLACE, FISH_PLACE_MAP are not retail)
- **FISH_PARAM** (0x54), row of local `FishParam[19]` (symbol size 0x63C = 19 * 0x54; GetFishParam
  bounds 0..0x12, stride 0x54). Row 0 is "影/ボウズ" (no fish), rows 1..18 the fish, file "fNN".
  0x0 name, 0x4 model base name (`sg/fish/%s.chr`, FishLoadBG), 0x8 item no (0x136,
  0x140..0x150; InitSuccess passes it to GetFishInAquarium / GetItemMessageNo), 0xC base size
  (GetUkiWaitTime: length_scale = min(size / base * 1.05, 4)), 0x10 min size, 0x14 max size
  (GetRandamNumber(min*rate, max*rate, min*rate/2)), 0x18 never read, 0x1C weight per size,
  0x20 fishing points per size (fptosi), 0x24 pull strength per 80 size, 0x28 s16[18] by bait
  index (LocalEsaNo, range check 0x11), 0x4C s16[4] by GetTimeBand. Values 0..3 -> enum
  FISH_AFFINITY (0 = rate zeroed, 1 = x0.5, 2 = unchanged, 3 = x1.5; also FavoredEsa in
  GetUkiPokeTime: 3/2/1/0 cases). The table is a native initializer: two strings, an item
  number (`FISH_ITEM_ID`, 310 Haguhagu, 320..336 Boubou through Danshaku Garayan), seven float
  parameters, 18 bait affinities and four time-band affinities per row.
- **FISHING_ROD_DATA** (0x18; symbol RodData size 0x18): sgRestartFishing copies the five ints
  of CUserDataManager::GetRodStatus; [0],[1],[2] scaled by (status[3]/100*0.2+0.8) and rounded;
  0x14 = status[4]/100. Uses: [0] cast range (SelectCastingPoint), [1] vigour drain when
  LineTensionStep's arg < 0, [2] divides pull strength (GetUkiWaitTime, (s-10)/90), 0x14 lowers
  the "wait" rate (GetUkiWaitTime) and InitFalse. Attribute names not established.
- **FISH_DATA** (0x24; symbol FishData size 0x24): written whole at the end of GetUkiWaitTime.
  0 fish_no, 4 size (cm: /100 for records, fptosi for message), 8 weight, 0xC/0x10 scales
  (InitSuccess: SetScale(x=0x10, y=0x10, z=0xC)), 0x14 pull strength,
  0x18 vigour recovery (0.01, 0.005 for the Mardan event), 0x1C vigour (clamped -1..1 in
  LineTensionStep; += 0x18 when RodStatus == 0), 0x20 fishing points (AddFp; doubled when
  GetFishingMode() == 2).
- **FISH_PLACE** (0xC): stride 0xC in SetFishPlace/GetAppearFish; empty = {-1, 0, 0}.
  0 fish_no, 4 rate (normalised by the sum -> pick probability), 8 wait_bias (clamped +-2;
  >= 0 divides the base wait 240 (120 for lure rod 0x12F) by (1+b), < 0 multiplies by (1-b)).
- **FISH_PLACE_MAP** (0x88): fpFISH_MAP memsets 0x88; stride 0x88 in GetAppearFish.
  0 map_no (compared to CScene::GetMainMapNo; -1 = fallback places), 4 exclusive (optional 2nd
  arg of FISH_MAP; when set SetFishPlace replaces the list and GetAppearFish stops searching),
  8 area_type (FISH_PLACE tag arg 0, clamped 0..4 else 0; only 2 = circle checked in
  CheckFishPlace, others always true), 0xC name (mgCopyString of arg 1), 0x10 float[5] (arg 2..6
  in a loop; circle uses [0]=x, [1]=z, [2]=radius, mgDistVectorXZ <= radius), 0x24 fish_num
  (max 8 in fpFISH), 0x28 FISH_PLACE[8]. No ctor (array allocated with placement array new;
  the block is the `u_long128 *` that `Alloc` returns). No virtuals.
- Script tags (local `tag`, SPI_TAG_PARAM[6]): FISH_MAP_NUM, FISH_MAP, FISH_PLACE, FISH,
  FISH_MAP_END -> fpFISH_MAP_NUM, fpFISH_MAP, fpFISH_PLACE, fpFISH, fpFISH_MAP_END; null
  terminator.
- **FISHING_CHARA_MODE** (CharaMode/NextCharaMode, switch in sgLoopFishing): 0 CharaControl,
  1 SelectCastingPoint, 2 CastingLoop, 3 UkiWaitLoop, 4 nothing, 5 BattleLoop, 6 FalseLoop,
  7 SuccessLoop. SetNextMode writes NextCharaMode; -1 = no change (InitDataLoading).

## Local data
- `lure_file` char*[4] (lure model names, index LocalEsaNo - 14), `EsaInfo` int[18] (bait item
  numbers 0x11F..0x124, 0x138..0x13F, 0x179..0x17C; 8 bytes padding to 0x50), `FishParam`
  FISH_PARAM[19], `tag` SPI_TAG_PARAM[6] (retail symbol `tag__8`).
- CameraInfo / UkiCameraInfo: CCameraControl (0x1F0). BgmStatus: CScene::BGM_STATUS (0x1C;
  +4 = bgm no). EsaStack, SndStack, MotionBuff, ReadStack, FishingBuff (retail `FishingBuff__2`),
  FishStack: mgCMemory (0x30). Their definition and constructor order is EsaStack, SndStack,
  CameraInfo, UkiCameraInfo, MotionBuff, ReadStack, FishingBuff, FishStack; the native static
  initializer emits the retail eight calls. CastPoint / CastPointCur: four-float vectors.
  RodData FISHING_ROD_DATA, FishData FISH_DATA. FishPlaceMap FISH_PLACE_MAP*, fpStack
  mgCMemory*, fpNowFishPlaceMap FISH_PLACE_MAP*. `ThreadStack` (retail `ThreadStack__2`) is the
  loading thread stack address as an `int`, aligned up to 64 bytes with `& 0x3F` before being
  handed to the thread as `void *`; `TheadID` (retail `TheadID__2`) is its thread id.
- Function-local statics: `UkiWaitLoop` has `hamon_count` (= 0, with MWCC's `init$` guard),
  `boze_cnt`, `pull_uki_cnt`, `act_count`, `charge_point` and `act_interval`; `BattleLoop` and
  `LineTensionStep` each have `snd_cnt` (= 0, guarded); `FalseLoop` has `font_h` (= 0, guarded),
  which is cleared once and never read or advanced.
- Local vector initializers: the tension gauge endpoint colours `{21, 41, 255, 128}` and
  `{255, 20, 10, 128}` are initialized at their battle-branch copy points; walking initializes
  its cast direction `{0, 0, 160, 1}` after camera control; casting-point selection starts with
  `{0, 0, 0, 1}` then sets its Z distance. The ripple and splash effects use zero-filled
  four-float scale initializers whose templates the compiler emits.
- Unresolved: RodStatus (0/1/2, BattleLoop and LineTensionStep: 1 raises tension and drains
  vigour, 2 lowers tension) and UkiMode (0..4) were not turned into enums; the meaning of
  FISH_PARAM 0x18 and FISH_PLACE_MAP area_param[3..4]; names of the rod attributes.
- SetFishPlace's merge branch reads `place[i]` with the map's fish index (retail quirk: uses the
  outer index's byte offset into `place`), keep it when matching.

## Source forms the matches depend on
- `sgSystemDrawFishing` constructs its `mgCDrawPrim` after the texture loads; the tension arrays
  are declared immediately after the builder so they keep their retail stack slots.
- `CScene::read_buff` is a `u_long128 *`; the fishing BGM and motion buffers begin 0x100000 bytes
  into it, element `read_buff[0x10000]` in `ReplayPrevBGM` and `sgInitFishing`.
- `mgCMemory::stGetTop()` returns the first unused stack quadword; `InitSuccess` passes it
  directly to `FishStack.stSetBuffer`.
- `*(u_long128 *) &CastPoint = *(u_long128 *) cast_dir` and the `CastPointCur` counterpart are
  quadword copies. `(u_char *) memory->Alloc(...)` converts fresh allocations to byte copies.
- Camera locals are `CCameraControl *` assigned once from the scene's camera; `Iam` and `Step`
  are virtual overrides, so the uncast calls dispatch the same.
