# subgame: reverse-engineering notes

Dispatcher for the mini-games (fishing, gyorace, pbuggy) plus a streamed-voice helper class.
No first-game counterpart (Dark Cloud has no `SubGameInfo`/`sgCPlayVoice`).

## Globals (all LOCAL in retail -> `static` in the .cpp, not in the header)
| Symbol | Addr | Type | Meaning |
|---|---|---|---|
| `SubGame` | 0x37E7AC (.sbss, 4) | int | Running `SUBGAME_TYPE`, 0 = none. |
| `MenuOpenFlag` | 0x37E7B0 (.sbss, 4) | int | Menu may open during a sub game (`sgMenuOpenEnable` gives 1 when no sub game). |
| `ItemOver` | 0x37E7B4 (.sbss, 4) | int | Item-did-not-fit flag (get/reset/on accessors). |
| `GameInfo` | 0x1F59380 (.bss, 0x30) | SubGameInfo | Copy of the running game's parameters. Has a ctor -> `__sinit_subgame_cpp`. |
`at_985__3` = `"%d.wav"` (Step's sprintf format). `D_0037B078` = .ctor table entry.

## SUBGAME_TYPE (values from sgInitSubGame / sgLoopSubGame dispatch)
1 fishing (`sg*Fishing`), 2 gyorace (`sg*GyoRace`), 3 buggy (`sg*Buggy`, unit pbuggy), 4 accepted
(range check is 1..4) but has no handlers: Loop returns 1 immediately so it ends on frame one.
Name of 4 unknown -> `SUBGAME_UNK_4`. Debug menu chooses it via editdebug's `sg_type`.
Draw dispatch: Map only gyorace; CharaShadow only buggy; Effect buggy+gyorace; Chara/System all 3.
Exit/Break/Restart/Loop2 only fishing. Exit/Break set SubGame=0 after.

## SubGameInfo (0x30; size = GameInfo symbol size and the 0x30-byte stack objects of callers)
| Off | Field | Evidence |
|---|---|---|
| 0x0 | `CScene *scene` | every sub game derefs `*(CScene**)info`. |
| 0x4 | `int texb` | sgInitSubGame stores scene+0x3E68; fishing/buggy/gyorace use as base texture block. |
| 0x8 | `int texb_num` | sgInitSubGame stores scene+0x3E6C; pbuggy loops DeleteBlock(texb+i) i<texb_num. Dungeon sets scene 0x3E68=0x28, 0x3E6C=0x1F. |
| 0xC | unk_c | copied by sgInitSubGame, never written by callers nor read. |
| 0x10 | `mgCMemory *menu_buff` | EditLoop passes `MenuBuffer__2` (0x30 mgCMemory); sgInitFishing uses `->stack` (+0x20) as read stack buffer when non-NULL. Dungeon passes 0. |
| 0x14 | `int dungeon` | Dungeon passes 1, EditLoop 0. Gates LoadExMotionBG/Step (0 -> load motions lazily) and StepDataLoading (non-zero -> load ex motion with data). sgInitFishing copies it into 0x18 and 0x1C. |
| 0x18 | `int no_map_event` | CharaControl: when 0, runs `CScene::GetMapEvent`/`RunEvent` and exits fishing. |
| 0x1C | `int record_check` | SuccessLoop: non-zero required before `CheckFishingRecord`. |
| 0x20 | `int rod_no` | InitDataLoading `RodNo = info[8]`; ==0x12F special rod in Restart/StepDataLoading; callers compare with running GameInfo to restart vs re-init. |
| 0x24 | `int esa_no` | `EsaNo = info[9]`; matched against `EsaInfo`, `GetItemFilePath`. |
| 0x28 | `int keep_bgm` | InitDataLoading: when 0, saves BGM status and stops BGM. EditLoop sets 1 when a fishing game is already running with a different rod. |
| 0x2C | `mgCMemory *load_buff` | EditLoop passes `FishingBuff`; InitDataLoading/StepDataLoading use it, NULL -> scene stack 5. |
Names 0x14-0x28 are descriptive (no retail names). `EditDebugInfo` (editdebug.hpp) derives from it.

**Inline ctor**: `__sinit_subgame_cpp` zeroes 0x0,0x10,0x14,0x18,0x1C,0x28,0x2C (store order
0x28,0x14,0x0,0x10,0x2C,0x18,0x1C); `_GOTO_SUBGAME` and EditLoop/LoopDungeonMain stack locals get the
same set zeroed (scene's store removed as dead). 0x4/0x8/0xC/0x20/0x24 not initialised. The header
ctor follows that store order and clears the pointers as `load_buff = menu_buff = 0`, which EditInit's
scalar-replaced copy into `EdDebugInfo` needs (register zeros for both pointers).

sgInitSubGame copies fields individually (not struct assign): scene, then 0xC..0x2C, then texb/texb_num
from `GameInfo.scene`+0x3E68/0x3E6C. Returns the sub game's init result; 0 -> SubGame reset to 0.
Range 1..4 else returns 0 (SubGame still set to the bad value before check, as Ghidra shows).

## sgCPlayVoice (0x14; `PolVoice` symbol size in pbuggy, no vtable)
| Off | Field | Evidence |
|---|---|---|
| 0x0 | `int step` | Step state machine, see enum. Close/Open test `> 0`. |
| 0x4 | `int file_no` | Open(param); Step sprintf("%d.wav") -> sndStreamOpenFast. |
| 0x8 | `int play` | Play() sets 1; step 4 waits on it. Open clears. |
| 0xC | `float vol_r` | SetVol 2nd arg; passed as 2nd arg of sndStreamSetVol(left,right). |
| 0x10 | `float vol_l` | SetVol 1st arg; 1st arg of sndStreamSetVol. |
SetVol clamps each to [0,1]; a negative right takes the clamped left (asm: `mov.s f13,f12`). pbuggy calls SetVol(0.6,-1).
Step: 1 sprintf+OpenFast ->2; 2 OpenState()==0 -> StandBy ->3; 3 OpenState()==0 ->4; 4 play -> SetVol(vol_l,vol_r)+Play ->5;
5 GetState()!=0x1000 -> Close, step 0, return 0. Returns 0 when step<1, 1 otherwise (incl. unknown step).
0x1000 stream state has no enum in snd_mngr.hpp yet.
**Inline ctor**: `__sinit_pbuggy_cpp` stores step=0, play=0, +0x10=1.0, +0xC=1.0 (that order); sgInitBuggy
repeats exactly the same four stores before SetVol -- likely `PolVoice = sgCPlayVoice()` or an inline
reset whose name is unknown; not declared.

## InitSubGame(CScene*)
Clears SubGame/MenuOpenFlag/ItemOver; if `scene->GetCharacter(scene+0x2E50)` exists: DeleteBlock
texb..texb+num (scene+0x3E68/0x3E6C), DeleteChara(0x40..0x67), DeleteEffect(7). Called from
EditInit and InitDungeonMain.

## Return types
All sg* dispatchers return int (Ghidra `undefined8` = propagated sub-game result or 0). Loop/Loop2
always return 0. SubGameRunning is `SubGame != 0` as int.
