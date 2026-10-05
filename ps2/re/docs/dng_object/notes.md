# dng_object: reverse-engineering notes

## C++ draft status
All 33 functions have C++ in `ps2/src/dng_object.cpp`. The matching build compiles
24 of them and verifies the retail image; `draft.sh` reports 24 matches and 9
differences. The build's objdiff report counts 23, because it does not report
`SetItem__9CPullItemFPfPfi` as perfect. The 9 differing drafts keep the
`INCLUDE_ASM` fallback. Each function tried has its one promotion attempt recorded in
`scripts/re/promotion_attempts.tsv`.

Unit holds the dungeon's gun projectiles (rocket, laser, machine gun), the pickups dropped by monsters
(`CPullItem`), and the robot voice commentary (`CRoboVoiceSystem`). None of these classes exist in the
first game's headers (`/home/adubbz/development/chronicle`), so no layout was carried over.
No class has virtual functions, base classes or constructors; all instances are globals in dng_main.

## Instances (dng_main globals, sizes from main.symbols.txt)
| Global | Address | Size | Type |
|---|---|---|---|
| `RocketLauncher` | 0x01EDEBA0 | 0x2580 | `CRocketLauncherMan` (24 x 0x190) |
| `MachineGun` | 0x01EE1120 | 0x390 | `CMachineGun` |
| `LaserGun` | 0x01EE14B0 | 0x1300 | `CLaserGunMan` (16 x 0x130) |
| `LaserGunModel` | 0x01EE27B0 | 0x660 | `CCharacter2` (model the laser frame comes from) |
| `PullItem` | 0x01EE2E10 | 0x2400 | `CPullItem[0x48]` (72 x 0x80) |
| `PullItemMan` | 0x0037D460 | 0x8 | `CPullItemManager`; `CommonStageClassInit` sets list = PullItem, num = 0x48 |
| `VoiceUnit` | 0x01EDDEB0 | 0x18 | `CRoboVoiceSystem` |

## CRocketLauncher (0x190) / CRocketLauncherMan (0x2580)
Man: `Get/Draw/Step/Clear/Initialize` loop 24 times with stride 0x190; `Get` returns first slot with state (0x174) == 0.
- 0x00 int target_chara: `SetPos` callers (`ShotGrenadGun`, `_SHOT`) store `action_info+0x770` (s16), `_SHOT_ROCKET_LAUNCHER` stores 0. Step: if != -1, `DngMainScene->GetCharacter(id)->GetEntryObjectPos(0,0,&target_pos)`. `Initialize` sets -1.
- 0x04-0x0F: never touched (alignment gap before the first sceVu0FVECTOR).
- 0x10 pos, 0x20 start_pos (written only in SetPos), 0x30 target_pos, 0x40 dir (interpolated towards target by `mgVectorInterpolate(dir,dir,to_target,0.05235988,0)`).
- 0x50 trail[16]: SetPos fills all 16 with pos; Step writes `trail[trail_index]` every 3rd frame; Draw passes `this+0x50` to `CreatSmoothPass(out, trail, 16, 6, trail_index, 16)`.
- 0x150 trail_len (+5 per record, -1 per frame in burst; state->0 when < 3; clamped to CreatSmoothPass result in Draw), 0x154 trail_index (0..15), 0x158 trail_timer.
- 0x15C float speed (SetPos 15.0; callers 20.0 or script value).
- 0x160 int col_prim_id: from `CColPrimMan::GetPrim()` (first word of CColPrim), -1 when none; Step uses `GetID2Prim`, checks `prim+0x28 > 0` (hit enemy) and `Delete(-1)`.
- 0x164 u32 draw_flags: SetPos 3; bit0 cleared on burst; Draw: bit1 trail, bit0 model.
- 0x168 homing_delay, 0x16C homing_time (homing while delay<1 && time>0), 0x170 life (SetPos 0xF / 0x3C / 0x96).
- 0x174 state: 0 free, 1 set by SetPos, Step 1->2, 3 on hit/expiry, 0 when trail gone. -> `SHOT_STATE`.
- 0x178 mgCTexture* trail texture, 0x17C mgCFrame* model, 0x180 int texture block (`mgTexManager.ReloadTexture(block, NULL)` in Man::Draw). Set by `Man::Initialize(frame, block, texture)`; dng_main passes `GetBaseChara(...)+0x70` / `+0x2E4` / `GetTexture(...)`.
- 0x184-0x18F: never touched; padding to the 16-byte alignment (size 0x190 from Man stride and global size).
- Model is drawn via mgCFrame vtable slot at +0x10 (index 2 with MWCC's 8-byte vtable header = `SetPosition(float*)`), then `mgLookAtMatrixZ` + `SetTransMatrix` + `mgDrawDirect`.

## CLaserGun (0x130) / CLaserGunMan (0x1300)
Same shape as the rocket with 8 trail slots; Man loops 16 times, stride 0x130; `Get` tests 0x120.
- 0x00 target_chara, 0x10 pos, 0x20 start_pos, 0x30 target_pos, 0x40 dir, 0x50 trail[8].
- 0xD0 trail_len, 0xD4 trail_index (0..7), 0xD8 trail_timer.
- 0xDC float speed, 0xE0 speed_add, 0xE4 speed_max (Step: speed += add, clamped to max).
- 0xE8 col_prim_id, 0xEC draw_flags (SetPos 3), 0xF0 homing_delay, 0xF4 homing_time, 0xF8 life (SetPos 0xF/0x3C/0x78).
- 0xFC float scale, 0x100 scale_add, 0x104 scale_max (same clamp). Draw uses scale*6 for sprite size and
  mgCFrame vtable +0x2C (index 9 = `SetScale(float,float,float)`) with scale.
- 0x108 s16 visual_code (SetVisualCode stores arg). 0x10A, 0x10C: never touched.
- 0x110 sceVu0FVECTOR color: rgb set by SetPos/SetVisualCode, 0x11C = 128.0 in SetPos. Used for Draw colours,
  `mgCFrameAttr` colour (with SetAttrParam(attr,1,0x10000)), and `SetScriptVect2` on the burst effect.
- 0x120 state, 0x124 trail texture, 0x128 model frame, 0x12C texture block.
- SetVisualCode values 0..4 (0/1/2 from `ShotLaserGun` param, 3 and 4 from `_SHOT`). Each sets colour and scale growth;
  1,2,3,4 also change speed (2,3,4 also speed_add/max; 3,4 also homing delay/time/life). Left as plain int; no enum
  names are evident.

## CMachineGun (0x390)
16 bullets in parallel arrays. Size 0x390 from the `MachineGun` symbol.
- 0x000 start_pos[16] (written by Set only), 0x100 velocity[16] (normalized dir * 40.0), 0x200 pos[16].
- 0x300 s16 active[16] (Set writes 1, Step tests ==1 and clears), 0x320 s16 col_prim_id[16] (written by
  `ShotMachineGun` at `[index]` after `Set`), 0x340 int life[16] (Set: 90).
- 0x380 s16 index: Set advances it (wraps at 16) looking for a free slot.
- 0x382-0x38F: never touched (alignment padding).
- `CommonStageClassInit` (dng_main) clears active[] to 0, col_prim_id[] to -1 and index to 0 inline; there is no
  separate CMachineGun init symbol.

## CPullItem (0x80) / CPullItemManager (0x8)
Size 0x80 from the `GetList`/`Clear`/`CommonStageClassInit` strides and `PullItem` = 0x48 * 0x80.
- 0x00 pos, 0x10 velocity, 0x20 draw_pos (Draw copies the bobbed sprite position there; Step uses it for sparkle effects).
- 0x30/32/34/36 s16 tex_u/v/w/h (Draw: `TextureCrd(u + (anim_frame/4)*16, v)` .. `(u+w, v+h)`). Initialize: 0,0,0x20,0x20.
- 0x38/0x3C float width/height of the sprite.
- 0x40 s16 fall_time (SetItem 300; state 1 decrements, ->5 at 0). 0x42 s16 wait_time (state 3 countdown, then
  fade frames in state 5). 0x44 s16 anim_frame (types 0/1 cycle 0..15). 0x46 never touched.
- 0x48 float angle (bob phase; collect-flight progress up to pi). 0x4C float bob_height.
- 0x50 s16 can_get, 0x52 s16 get_delay (IsGet requires can_get && get_delay < 1).
- 0x54 float pull_speed, 0x58 float pull_accel (types 1/2/7). 0x5C float get_range (IsGet: dist < get_range*20).
- 0x60 s8 type (lb), 0x61 s8 glow (AlphaBlend 2 instead of 1 and an extra glow sprite), 0x62-0x63 never touched.
- 0x64 float exp, 0x68 s16 num, 0x6A s16 exp_param, 0x6C s16 item_no -> `AddExpWeaponParam(exp, exp_param, item_no)`
  for type 1 (written by `_SET_DEAD_OFF`, `_SET_PULL_ITEM`); item_no also money amount (types 0/3) or badge/item id.
- 0x6E never touched. 0x70 float alpha (SetItem 128, -4.266667 per frame fading). 0x74 s8 wire_index into the
  `afterWire` array (stride 0x120 = CAfterWire), -1 for none. 0x75-0x7B never touched. 0x7C int state.
- type values (SetItem switch, jump table at_1736) and callers:
  0 money coins (`_SET_DEAD_START`, five coins sharing the money), 1 weapon exp (`_SET_DEAD_OFF`, finds a free
  afterWire), 2 gate key (`CMonsterMan::ThinkHost`, text `dung_progtxt_gkey_get`), 3 large coin (`_SET_DEAD_START`),
  4 item (`_SET_DEAD_START` from monster drop slots 0xA0/0xA2, `DngStep` random items), 5 item (`_SET_DEAD_START`
  from monster slot 0xA4), 6 badge (`_SET_DEAD_START`, `CMonsterBox::EnableChange`, `mons_attr_list` names),
  7 stolen item (`CMonsterMan::CheckDamage`, text `dung_progtxt_steal`). Enum names are descriptive, not retail.
- state values: 0 free, 1 fall, 2 float, 3 land, 4 collect (set by IsGet), 5 fade, 6 got. Not retail names.
- `GetList(start)` returns the first slot >= start with state 0. `Clear` calls `CPullItem::Clear` (wire_index = -1,
  state = 0) on each when list is non-NULL.

## CRoboVoiceSystem (0x18)
Size 0x18 from `VoiceUnit`.
- 0x00 s16 status (0 off .. 5 wait, see `ROBO_VOICE_STATUS`; DngMainKey only starts it when status == 0).
- 0x02 never touched. 0x04 int stream_open (1 after StreamOpenFast, 0 after close). 0x08 never touched.
- 0x0C int voice_no: -1 = choose; voices < 100 open `"85200%d.wav"`, others `"8520%d.wav"`; after voice 200
  plays, 210 is queued with a 45-frame wait.
- 0x10 s16: stores SetStatus's second argument (always 0 from Step); never read. Left `unk_10`.
- 0x12 s16 wait_time, 0x14 s16 play_time (incremented every active frame; > 3599 enables one voice table),
  0x16 s16 pause_time (StopVoice argument; Step does nothing while > 0). DngMainKey/EventScriptSetup pass 10.
- Voice tables (function-local arrays in Step, data at_1800..at_1806): HP > 80%: {30,40,60,160};
  40-80%: {80,90,190}; <= 40%: {100,110,120,170,220}; long play: {70,140,150}; 1-3 monsters within 340:
  {50,180}; 4+ monsters: {130,200}; HP <= 20%: {120,120,220,170}.
- Stream channel used is 1 on the global `CSnd` (CSound, mainloop).

## Data
Every named data symbol of the unit is LOCAL in retail (`build/re/local_symbols.tsv`), so the header declares no
externs; they become `static` definitions in the .cpp:
- `mons_attr_tbl`..`mons_attr_tbl6` (0x30 each = 12 `char*`, monster attribute/badge names per language),
  `mons_attr_list` (8 `char*[]` pointers indexed by `LanguageCode`; entries 6 and 7 repeat tbl6).
- `dung_progtxt_badge_already`, `_badge_get`, `_gkey_get`, `_steal` (0x1C = 7 `char*`, one format string per language).
- `dung_progtxt_getitem`, `_getitem_overnum` (0x38 = 7 x {singular, plural} `char*` pairs; language 0 uses the
  second entry with (name, count) arguments).
- `anim_1410` (float) / `init_1411` (bool): function-local static in `CPullItem::Draw` (glow pulse phase).
- `dung_progtxt_notlift_mons` with the same naming lives in another unit, suggesting these text tables come from a
  shared text header included with `static` definitions.

## Unresolved
- Retail names of all fields and enum constants are unknown; the names are descriptive.
- Meaning of SetStatus's second parameter (`unk_10`).
- PULL_ITEM types 4 and 5 differ only in sprite position and which monster drop slot feeds them.
