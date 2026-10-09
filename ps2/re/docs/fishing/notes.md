# fishing: reverse-engineering notes

`sgRestartFishing` and `StepDataLoading` are accepted native C++ callers with
one and seven scoped `CCharacter2` placement sites respectively. The worker
retains its retail LOCAL binding. See
[placement conversion](../satansfiddle/placement-new.md).
Their resource names and formats are inline literals. The worker's motion
pack path `at_917__6` and the restart lure-path template `at_993__4` are
emitted natively, with `LoadExMotionBG` spelling the same pack path. The
shared `"info.cfg"` (`at_932__4`) stays a marker for guarded `InitSuccess`;
`lure_file` and `EsaInfo` remain assembly data read by the native restart.

`InitSuccess` is the unit's only remaining guarded function. Its caught-fish
allocation uses a natural `CCharacter2` constructor in the C++ draft; the normal
build selects retail assembly for that function.

Header: `ps2/include/fishing.hpp`. No first-game counterpart: Dark Cloud's `fishing.hpp`/`fish.hpp`
(CFish, CCharacter Rod, line points) is a different design; nothing was carried over.

## Linkage
- Global functions (header): sgInitFishing, sgRestartFishing, sgBreakFishing, sgExitFishing,
  sgLoopFishing, sgLoopFishing2, sgDrawFishing, sgSystemDrawFishing, ResetUkiCamera,
  GetAppearFish, FISH_PLACE_MAP::SetFishPlace, FISH_PLACE_MAP::CheckFishPlace, LoadFishPlaceData.
  All sg* return int (subgame's sgInitSubGame/sgDrawSubGameSystem use the results).
- Every other function is LOCAL in retail (intended C++ linkage: `static`), including SetNextMode,
  GetRandamNumber, GetFishParam, the fp* script tag handlers and `CharaControl` (retail symbol
  `CharaControl__FP6CSceneP11CPadControl__2`; another unit has a global of the same name).
  `FishLoadBG__FP9FISH_DATAP1` and `LoadExMotionBG__FP11SubGameInfoP1` are truncated retail
  names (last parameter type unknown from the symbol).
  `StepDataLoading` is declared and defined `static`; the native worker has
  the retail LOCAL/FUNC binding without an assembly-table alias.
- Data: only `stack_size` (int, 0x4, set to 0x40000 in CreateLoadThread) is global. Every named
  datum in .data/.sbss/.bss is local.

## Types (names other than FISH_DATA, FISH_PLACE, FISH_PLACE_MAP are not retail)
- **FISH_PARAM** (0x54), row of local `FishParam[19]` (symbol size 0x63C = 19 * 0x54; GetFishParam
  bounds 0..0x12, stride 0x54). Row 0 is "影/ボウズ" (no fish), rows 1..18 the fish, file "fNN".
  0x0 name, 0x4 model base name (`sg/fish/%s.chr`, at_2461, FishLoadBG), 0x8 item no (0x136,
  0x140..0x150; InitSuccess passes it to GetFishInAquarium / GetItemMessageNo), 0xC base size
  (GetUkiWaitTime: length_scale = min(size / base * 1.05, 4)), 0x10 min size, 0x14 max size
  (GetRandamNumber(min*rate, max*rate, min*rate/2)), 0x18 never read, 0x1C weight per size,
  0x20 fishing points per size (fptosi), 0x24 pull strength per 80 size, 0x28 s16[18] by bait
  index (LocalEsaNo, range check 0x11), 0x4C s16[4] by GetTimeBand. Values 0..3 -> enum
  FISH_AFFINITY (0 = rate zeroed, 1 = x0.5, 2 = unchanged, 3 = x1.5; also FavoredEsa in
  GetUkiPokeTime: 3/2/1/0 cases).
- **FISHING_ROD_DATA** (0x18; symbol RodData size 0x18): sgRestartFishing copies the five ints
  of CUserDataManager::GetRodStatus; [0],[1],[2] scaled by (status[3]/100*0.2+0.8) and rounded;
  0x14 = status[4]/100. Uses: [0] cast range (SelectCastingPoint), [1] vigour drain when
  LineTensionStep's arg < 0, [2] divides pull strength (GetUkiWaitTime, (s-10)/90), 0x14 lowers
  the "wait" rate (GetUkiWaitTime) and InitFalse. Attribute names not established.
- **FISH_DATA** (0x24; symbol FishData size 0x24): written whole at the end of GetUkiWaitTime.
  0 fish_no, 4 size (cm: /100 for records, fptosi for message), 8 weight, 0xC/0x10 scales
  (InitSuccess: FishChara vtable+0x2C = SetScale(x=0x10, y=0x10, z=0xC)), 0x14 pull strength,
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
  (max 8 in fpFISH), 0x28 FISH_PLACE[8]. No ctor (array allocated with plain __nwa, extra two
  quadwords for the array header). No virtuals.
- Script tags (local `tag__8`, SPI_TAG_PARAM[6]): strings at_2670..at_2674 ->
  fpFISH_MAP_NUM, fpFISH_MAP, fpFISH_PLACE, fpFISH, fpFISH_MAP_END.
- **FISHING_CHARA_MODE** (CharaMode/NextCharaMode, switch in sgLoopFishing): 0 CharaControl,
  1 SelectCastingPoint, 2 CastingLoop, 3 UkiWaitLoop, 4 nothing, 5 BattleLoop, 6 FalseLoop,
  7 SuccessLoop. SetNextMode writes NextCharaMode; -1 = no change (InitDataLoading).

## Local data (for the next agent)
- lure_file char*[4] (lure model names, index LocalEsaNo - 14), EsaInfo int[18] (bait item nos
  0x11F..0x124, 0x138..0x13F, 0x179..0x17C; 8 bytes padding to 0x50), FishParam FISH_PARAM[19],
  tag__8 SPI_TAG_PARAM[6].
- CameraInfo / UkiCameraInfo: CCameraControl (0x1F0). BgmStatus: CScene::BGM_STATUS (0x1C;
  +4 = bgm no). EsaStack, SndStack, MotionBuff, ReadStack, FishingBuff__2, FishStack: mgCMemory
  (0x30). CastPoint / CastPointCur: float[4]. RodData FISHING_ROD_DATA, FishData FISH_DATA.
  FishPlaceMap FISH_PLACE_MAP*, fpStack mgCMemory*, fpNowFishPlaceMap FISH_PLACE_MAP*.
- Unresolved: RodStatus (0/1/2, BattleLoop and LineTensionStep: 1 raises tension and drains
  vigour, 2 lowers tension) and UkiMode (0..4) were not turned into enums; the meaning of
  FISH_PARAM 0x18 and FISH_PLACE_MAP area_param[3..4]; names of the rod attributes.
- SetFishPlace's merge branch reads `place[i]` with the map's fish index (retail quirk: uses the
  outer index's byte offset into `place`), keep it when matching.

`sgSystemDrawFishing` constructs its `mgCDrawPrim` after the texture loads. Declaring the tension arrays immediately after the native builder retains their retail stack slots and gives an exact object-code match.

## Native static initialization

Native `mgCMemory` and `CCameraControl` globals emit the eight calls in the retail initializer order. The generated 116-byte initializer matches exactly, including both camera constructors; this removes the handwritten C-linkage constructor alias.

## Typed read-buffer offsets

`CScene::read_buff` is a `u_long128*`. The fishing BGM and motion buffers begin
0x100000 bytes into it, which is element 0x10000. Using `read_buff[0x10000]`
in `ReplayPrevBGM` and `sgInitFishing` removes byte-pointer arithmetic and
the return cast; both functions remain exact in objdiff.

`mgCMemory::stGetTop()` already returns the first unused stack quadword.
`InitSuccess` passes it directly to `FishStack.stSetBuffer`, eliminating the
`u_char*` intermediate and its two pointer casts while retaining exact code.

### GetUkiWaitTime — exact native width argument evaluation

With the artificial PrimeLongDivision helper removed and an explicit translation-unit helper mask GPR 0x30/FPR 0, the unit originally retained one mismatch at retail 0x003080C2. The width call `GetRandamNumber(1.0f, 1.3f, float(0.6))` requires the stable Satan’s Fiddle binary32 selector 0x3fa66666 to evaluate first. Retail retains the 1.3f bits in $a0 while preparing 0.6f, then transfers all three arguments to the FPRs; the default ordering reused $v0 and transferred the width argument too early. No source register tricks or function body changes are required. The isolated unit passes all 0x85C0 allocated bytes and 1,778 resolved relocations.

The primer migration separately preserves all 279 allocated section contents/sizes/alignments and all 1,778 relocation identities relative to its baseline, including the former width-call mismatch.
