# actionchara: reverse-engineering notes

## C++ draft status
All 73 functions have C++ in `ps2/src/actionchara.cpp`. 27 are exact and
compiled by the matching build. 3 more compile to retail's bytes in isolation
but stay under `NONMATCHING`. 43 differ from retail and keep the `INCLUDE_ASM`
fallback. Each function tried has its one promotion attempt recorded in
`scripts/re/promotion_attempts.tsv`.

Header: `ps2/include/actionchara.hpp`. Owns `CActionChara` (derives `CCharacter2`, unit `character`),
plus the parameter/table types `RUN_SCRIPT_ENV`, `ACTION_SW_EFFECT`, `ACTION_DAMAGE`, `ACTION_OBJECT`,
`ACTION_BODY_COL`, `ACTION_SOUND`, `ACTION_ACCELE`, `ACTION_ACCUME`, `ACTION_SHAKE` and six enums.
Only `RUN_SCRIPT_ENV` is a retail name (from `RunScript__12CActionCharaFP6CSceneP14RUN_SCRIPT_ENV`); the
other struct and enum names are ours. No first-game equivalent of `CActionChara` exists.

## Header dependencies (by value)
- `character.hpp` (`CCharacter2` base, size 0x660, 16-aligned).
- `runscript.hpp` (`CRunScript` at 0x6BC, size 0x54).
- `dng_effect.hpp` (`CPalletAnime`, 7 x s16 = 0xE, no constructor).
- `dng_main.hpp` (`MoveCheckInfo`, owner dng_main, 0x110 and 16-aligned).
- `funcpoint.hpp` is included by `map.hpp`. With these dependencies present, `actionchara.cpp`
  compiles and the `CActionChara` size assertion confirms the 0x1030-byte layout.

## Size and layout evidence
- sizeof 0x1030: last member `sound[10]` ends at 0x1028; class is 16-aligned. `CActiveMonster`
  (monster) places its own fields from 0x1030 (m2c), its `CRunScript` at +0x1040; `CMonsterMan`
  array stride 0x14C0 with `CActionChara` at element +0x10.
- Constructor (inline, emitted in editloop 0x1ACF40): base ctors, `CRunScript` ctor at 0x6BC,
  `memset(this+0x910, 0, 0x110)` -> `move_check`. It does not call `Initialize`.
- Implicit `operator=` (monster 0x1DB710, `__as__12CActionCharaFRC12CActionChara`) is compiler
  generated -- not declared in the header. `Copy` (0x173790) = `CCharacter2::operator=` call
  (emitted weak in this unit, 0x173C10) then the CActionChara members, then
  `CCharacter2::Copy(dest, mem)` if mem != NULL. `Copy(dest, mem)` copies *this into dest.
- Copy instruction patterns used to type members (from `Copy` asm):
  - lwc1 x4 (0x660, 0x690, 0x7A0, 0xF40): 16-byte aggregate -> `sceVu0FVECTOR`. 0x68C..0x68F is not
    copied, so 0x690 is 16-aligned -> confirms an aligned vector type.
  - lq lq / sq sq at 0x780: one 0x20-byte 16-aligned aggregate -> `ACTION_ACCELE`.
  - lwc1 x2 at 0x7D0 and 0xBF8: 8-byte structs (`ACTION_ACCUME`, `ACTION_SHAKE`); MWCC copies small
    structs through FPRs even when members are ints/shorts.
  - lq loop x0x11 at 0x910 (MoveCheckInfo); lq pairs x8 at 0xC00 (ACTION_OBJECT, 16-aligned);
    lw-pair loops at 0x7E4 (9x0x20), 0xA20 (11x0x28), 0xD00 (16x0x24), 0xF60 (10x0x14);
    lw x21 at 0x6BC (CRunScript); lh x7 at 0x67C; lh x21 at 0x734 (CPalletAnime[3]).

## Field evidence (offset -> meaning)
- 0x660 old_pos: HumanMoveIF/MonsterMoveIF store GetPosition here first. Initialize 0,0,0,1.
- 0x670 chara_type: SetupMainUnit 0/1/2, SetupMonica 1, SetupMints 0, SetupRobo 2, SetupMonster 3;
  `_CHECK_EQUIP` uses it as the CUserDataManager chara index. StepParam: type 2 faces with part "arm".
- 0x674 parent / 0x678 next: SetRef appends part to chain end and sets part->parent; all chain
  walkers (SetFadeFlag, SetMotion, Draw, SearchChara...) follow 0x678.
- 0x67C: 7 x s16, CPalletAnime layout; only written by dng_main IsEventRun (inlined SetAnim order
  0,2,4,6,0xA,8,0xC). Never Initialized/stepped/drawn -> `CPalletAnime unk_67c` (type inferred).
- 0x68A chara_kind: 2 set by LoadActionFile, 1 by SetRef on the part; many checks for ==2 on scene
  characters (only scripted characters are targets).
- 0x690 front_vec: StepParam = RotY(angle) * (0,0,1) (data at_3289/at_3291); `_GET_FRONT_VEC`.
- 0x6A0 mask_flag (SetMaskFlag, `_SET_INT_FLAG` on nowMonster; monster tests bits 1,2).
- 0x6A4 attack_type (`_GET_ATTK_TYPE`; set from ROBO_INFO_DATA+0x20). 0x6A8 move_type (`_RUN_MAIN_MOVE`:
  0 Human, 3 Monster; `_RUN_ROBO_MOVE`: 1/4 Walk, 2/5 Tank, 3 Bike, 6/7 Air; Tank tests 2 vs 5, Air 6 vs 7).
- 0x6AC max_speed (init 4.0; Robo*MoveIF divide speed by it, clamp to 1).
- 0x6B0 (int), 0x6B4 (s16): only copied -> unk.
- 0x6B8 script_buf: LoadActionFile stAlloc64 + memcpy, then SetActionScript(&script, buf, mem).
- 0x710 prog_no: RunScript runs program prog_no if present then sets -1; -1 -> resume; script end
  (CRunScript+0x3C, i.e. 0x6F8) -> 200. Values: 100 InitScript, 150 ResetAction, 200, 500/600/550/1400
  from damage_req 1/2/7/4, 700 from unk_bec, 550 SetHold, 1500 landing (grounded, old vy <= -3.5).
- 0x712 prog (`_PROG_SET/_PROG_GET`). 0x714 pad_history (|= PadCtrl Btn(0x32); `_GET/_RESET_PAD_HISTORY`).
- 0x718 default_motion (`_SET_DEFAULT_MOS`; init string at_2210).
- 0x71C hold_type: 1 EntryThrowItem, 3 CheckEnemyCatch (monster), 4 CheckEnemyCatch (stone); 0 on
  release. 2 never seen. 0x720 hold_parts (CMapParts*), 0x724 hold_frame (mgCFrame*): Step carries the
  stone to hold_frame while hold_type==4.
- 0x728 release_timing: 1 caught, 2 enemy thrown (`_RELEASE_OBJ`), 3 stone released, 5 stone kicked
  (CheckKeri); cleared each StepParam. Read by CheckReleaseTimming. 0x72A s16 init -1, unused.
- 0x72C catch_frame, 0x730 catch_state, 0x732 no_hit_time: written on the *monster* by `_RELEASE_OBJ`
  (frame ptr passed to GetWorldPosition0; state 0/2; time 5); collision/lock-on skip catch_state==1;
  StepParam: state 2 -> velocity = blow_vec, blow_vec.y -= 0.6.
- 0x734 pallet[3]: Initialize/Step/CreatPallet per element; SetAnim from UsedItemAction, CheckDamage, `_SET_PALLET`.
- 0x75E s16 / 0x760 float: StepParam ramps 0x760 to 1 (or 0) by 1/60 while 0x75E !=0 (==0);
  HumanMoveIF tests 0x75E==0. Meaning unknown.
- 0x764 shot_wait (`_SET_SHOT`, `_SET_SPECIAL_SHOT` set 5; decremented). 0x768 muteki_time (`_SET_MUTEKI`;
  CheckDamage skips hits while >0).
- 0x76C menu_flag (`_SET_MENU_FLAG`, CheckRunEvent, cleared in RunScript). 0x76D stand_flag (MoveIFs:
  1 when stick centred). 0x76E dir_gun (`_SET_DIR_GUN`; Step uses it with lock_on).
- 0x770 target_no (-1 none; RockOn cycles 0x18..0x2F), 0x772 lock_on (RockOn toggles).
- 0x774 murderous_time / 0x778 murderous (`_SET_MURDEROUS(a,b)`: 0x778=a, 0x774=b; 0x774 decremented).
- 0x77C now_status: `_GET_MONSTER_NOWSTS` reads it from the lock-on target.
- 0x780 accele: ResetAccele zeros 0x780/784/788 and 0x790; Initialize 0x790=0, 0x794=3.0;
  0x790 is the RoboBike speed (clamped -3..12); 0x794 `_SET_MOVE_SPEED`. 0x798/0x79C unknown.
- 0x7A0..0x7B8 add_vec/add_speed/add_decel/add_time: StepParam adds add_vec*add_speed to velocity,
  speed -= decel, time-- (same scheme as blow_*). Not written in this unit (names ours).
- 0x7BC stick_angle / 0x7C0 stick_time (HumanMoveIF/MonsterMoveIF). 0x7C4 target_dot (RockOn).
- 0x7C8 int: read by event_func `_COPY_MONS2SCNCHR` only -> unk.
- 0x7CC accume_effect: SetupMainUnit stores `&AccumulateEffect` (global 0x330 bytes, no known type ->
  `void *`); actscript writes +0x310 and [0].
- 0x7D0 accume: `_SET_ACCUME_FX(obj, v)`: frame = object[obj].frame, +4 (s16) = v, +6 = 0;
  `_SET_ACCUME_FLAG(1)` copies frame into AccumulateEffect and sets +6 = 1.
- 0x7D8 acumu_pad (RunScript counts frames PadCtrl Btn(0x38) held; `_GET/_RESET_ACUMU_PAD`).
- 0x7DC effect_man (CEffectScriptMan*), 0x7E0 throw_effect (s8 from CreateEffSpt in EntryThrowItem).
- 0x7E4 sw_effect[9] / 0x904 sw_effect_num: filled by actscript `_SW_EFFECT` via GetSwEffectPtr.
  Entry: +0 s16 index into CCharacter2+0x570 effects, +4 chara (10-arg form), +8 motion, +C/+10
  frame window, +14/+18 frame names, +1C/+1E/+1D -> StartEffect args 3/4/5 (arg4 is a fade step
  count: StartEffect stores 1/arg4), +1F cooldown (set 5).
- 0x910 move_check (MoveCheckInfo): RunScript sets +0 = height*2+4, calls MoveCheck; +8 (0x918)
  is the ground flag, +0x52 (0x962) the floor attribute.
- 0xA20 damage[11] / 0xBD8 damage_num (EntryDamage2 x2, AllDeleteDamage, RunScript makes CColPrim
  when GetNowFrame(chara) in [start,end)).
- 0xBDC damage_req: CheckDamage sets 1/2/7; dng_main IsRunDeadEvent/CheckStatusError set 4;
  `_RELEASE_OBJ` sets 6 on a thrown monster. RunScript maps 4->1400, 7->550, 1->500, 2->600.
- 0xBE0 unused; 0xBE4 decremented in StepParam only; 0xBE8 damage_time (hit cooldown; Draw jitters
  while >6); 0xBEC -> prog 700 in RunScript (no writer found); 0xBF0 guard_flag (`_SET_GUARD_FLAG`).
- 0xBF4 stagger (+= damage data +0x22), 0xBF5 stagger_time (60). 0xBF8 shake {s16 time, float offset}.
- 0xC00 object[8]: EntryObject (by name, slot -1 = first free), CalcCollision fills +0x10 world pos;
  `_SET_SHOT` reads pos. 0xD00 body_col[16]: EntryBodyCol sets type 2/object/radius; ResetScript sets
  +0x20 = -1. Readers of body_col are not in this unit.
- 0xF40..0xF5C blow_*: CheckDamage (vec from hit prim +0xF0, speed 4, rate 1, decel 0, time 5) and
  `_BLOW_START(speed, decel, time)` (speed *= blow_rate).
- 0xF60 sound[10]: `_SET_SND` fills se_no/start/end/chara; ResetScript sets se_no -1.

## Vtable (`__vt__12CActionChara`, 0x37B960, 0x120 = 2 header words + 70 slots)
Slots 0..59 are CCharacter2's (0xF8 vtable); overridden here: Draw, DrawDirect, GetCameraDist,
SetFarDist, SetNearDist, SetMotion(ii), ResetMotion, SetFadeFlag, DrawShadowDirect, Step, ShadowStep,
DrawEffect. New slots 60..69 in order: Show(ii), GetShow(Pc), SetMotion(Pcii), GetNowFrameWait(Pc),
GetNowFrame(Pc), CheckMotionEnd(Pc), GetMotionStatus(Pc), StepEffect(), Initialize(mgCMemory*),
Copy(CActionChara&, mgCMemory*). The header declares the new ones in this order.
Note they hide the base overloads (Show(int), GetShow(), SetMotion(char*,int), GetNowFrame(), ...,
Initialize(), CCharacter2::StepEffect is non-virtual); call those with `CCharacter2::` qualification.
DrawShadowDirect is `int` to match the base virtual, though this override returns nothing useful.

## Return types (from asm/m2c)
GetNowFrame/GetNowFrameWait/GetWaitToFrame/GetTargetDist/GetCameraDist: float ($f0).
Move IFs all return 1. UsedItemAction 0/1/2/3. SetRef/LoadActionFile/CheckKeri/CheckEnemyCatch: int.
EntryObject/EntryBodyCol/EntryDamage2/GetSwEffectPtr return the slot pointer (callers test non-NULL).
CheckRunEvent/CheckReleaseTimming load s8/s16 fields; declared int.

## Globals and statics
- `old_angle` (sbss float, 0x37D00C) is LOCAL in retail -> `static float old_angle;` in the .cpp
  (HumanMoveIF/MonsterMoveIF: previous stick angle). `ang_3371`/`init_3372` are Step's function statics
  (part "L_arm" angle). `at_3107` (bss 0x10) is a local float[4] literal.
- All seven non-members (RockOn_TargetSel, DistCheck_Action2, Check_LockOn, GuardEffectSet,
  HitEffectSet, CheckAmuletAvoid, CheckEquipSetItem) are LOCAL -> static in the .cpp, not in the header.
- Globals used but owned elsewhere: `action_info` (actscript bss 0x10: [0] CActionChara*, [8]
  RUN_SCRIPT_ENV* -- Ghidra shows DAT_01f3d178 = action_info+8, DAT_01f3d174 = camera at +4),
  `nowScene__2`, `ActionScriptEnv` (dng_main, a RUN_SCRIPT_ENV: item models of stride 0x660, 18 of them).
- Strings: at_1325 "rnd_obj01-a", at_1357 "sword", at_1358 "shot", at_2423 "arm", at_3262 "MainCam",
  at_3389 "L_arm"; at_1394/at_1427/at_2210 are Shift-JIS.

## Unresolved
- Names of all non-retail struct/enum types; meanings of unk_67c (if not CPalletAnime), 0x6B0, 0x6B4,
  0x72A, 0x75E/0x760, 0x798/0x79C, 0x7C8, 0xBE0, 0xBE4, 0xBEC, body_col +0xC..+0x20, sound +0xC,
  object +4..+0xC, accume +4.
- ACTION_MOVE_TYPE values 4/5/7 vs 1/2/6 differences not analysed (named *2).
- RoboAirMoveIF first int argument (always 1 from `_RUN_ROBO_MOVE`), Robo*MoveIF `mode` argument.
