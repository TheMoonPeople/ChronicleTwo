# sceneseq: reverse-engineering notes

Event-scene sequencers. `CSceneCmrSeq` (one global, `CameraSeq` in event_func) and `CSceneObjSeq`
(32 of them, `ObjectSeq` in event_func) hold queues of commands built by the event script
(`_CMRS_*` / `_OBJS_*` in event_func) and run them every frame in `Play`. No first-game
counterpart exists (nothing in `/home/adubbz/development/chronicle` mentions these types).
Both dispatch tables and all other data are native; no RODATA or BSS
reservations remain.

## Linkage
- Local (static, belong in the .cpp): `InitSplineKey`, `InitSceneCmrSeq`, `InitSceneObjSeq`,
  all 75 `scs*` handlers, and the tables `ScsCmrSeqCallTbl` / `ScsObjSeqCallTbl`
  (`build/re/local_symbols.tsv`). The header therefore has no free functions and no externs.
- Empty-string arguments are inline. The `CSceneObjSeq::Play` seven-track
  switch emits its jump table directly.
- No virtual functions in any class; no vtables.

## Command tables
- `ScsCmrSeqCallTbl` (.data, 0x94 = 37 words): index 0 and 36 are `scsDummy`; 1..35 match
  `SceneCmrSeqCmd`. `Play` only calls commands 1..0x23. Followed in the asm by 0xC bytes of zero
  padding (not part of the symbol).
- `ScsObjSeqCallTbl` (.data, 0xA0 = 40 words): index 0 and 39 are `scsDummy`; 1..38 match
  `SceneObjSeqCmd`. `Play` only calls 1..0x26.
- Handler type: `int (*)(_SEN_CMR_SEQ *, CSceneCmrSeq *)` / `int (*)(_SEN_OBJ_SEQ *, CSceneObjSeq *)`.
- Handler return (`SceneSeqResult`): 0 = done, go on to next command same frame; 1 = still
  running, stop the track for this frame; 2 (only `scsPRReturn`/`scsAHDReturn`) = jump back to
  `pr_keep`/`ahd_keep`. `scsDummy` returns 1, `scsFadeInit` 0. Keep handlers store the entry in
  `pr_keep` (0x30) / `ahd_keep` (0x34) and return 0.
- Command codes confirmed from each setter (`*puVar = N`) and from table order; both agree.

## Frame conversion
Every setter taking a frame count converts 60 Hz to 50 Hz when > 0: `n = n*50/60`, clamped to
>= 1. `CSceneObjSeq::Jump` also scales its height by 1.2f when converting.

The short command setters obtain a free entry from the matching track's `SearchNext*Seq` method,
then write its `cmd` and, where needed, the first union field (`frame`, `value`, or `no`).
`StartPas` stores its ground flag in that first union field. `SePlay` stores the sound bank and
sound number in the first and second union fields. `ResetDAPosition` enqueues the same command
on both the sound and motion tracks. The camera Keep handlers save their current entry in
`pr_keep` or `ahd_keep`; Return handlers return `SCENE_SEQ_RETURN` for `Play` to jump back.

`CSceneCmrSeq::CheckEnd` checks the position, angle, fade, and quake heads, leaving the character
track out. `CSceneObjSeq::CheckEnd` checks all seven object track heads. The path accessors read
and write the `frame` field directly, while `CCameraPas::Run` sets the path's `run` flag.

## SPLINE_KEY (0x38)
InitSplineKey zeroes 0,4,8,0x14,0x20,0x2C,0xC,... (14 words). SetUpSpline: +0 start frame
(sum of previous start+length), +4 length (from frames[]), +8/+0x14/+0x20/+0x2C per-axis
coefficients a,b,c,d (stride 4 over 3 axes). Step evaluates `d + t*c + t^3*a + t^2*b`.
Stride 0x38 from Initialize loop (16 keys) and `now_key*0x38` indexing.

## C3DSpline (0x39C)
0x000 key[16]; 0x380 key_num; 0x384 now_key; 0x388 now_frame (float, +1.0 per Step, +0.001 per
StepS iteration); 0x38C now_pos[3]; 0x398 speed (StepS step distance). Size from CCameraPas
embedding two at 0x208 and 0x5A4 (0x5A4-0x208 = 0x39C) and CCharaPas run at 0x108+0x39C=0x4A4.
At end Step/StepS set now_frame = end + 100.0 and return 1.

## CCameraPas (0x950)
0x000 pos[16] vec; 0x100 ref[16] vec; 0x200 pas_num; 0x204 frame; 0x208 pos_spline; 0x5A4
ref_spline; 0x940 run. Ends at 0x944; size 0x950 assumes 16-byte alignment (vectors via
lqc2/sceVu0CopyVector). Consistent with CSceneCmrSeq: 0x1C0 + 0x950 = 0xB10 = `CameraSeq` size.
SetFrame returns int (always 0) while CCharaPas::SetFrame returns void (m2c/ghidra agree).

## CCharaPas (0x4B0)
0x000 pos[16]; 0x100 frame; 0x104 pas_num (note order differs from CCameraPas); 0x108 spline;
0x4A4 run; 0x4A8 end (set when StepS reports end; next Step outputs final point and stops).
Step writes position and atan2 heading (wrapped to (-pi, pi]) into the second pointer, which
callers pass as `&rot[1]` (CSceneObjSeq+0x84). 0x140 + 0x4B0 = 0x5F0 matches CSceneObjSeq.

## _SEN_CMR_SEQ (0x60)
Stride 0x60 from Clear loop, SearchSeq (`+0x18` words), `cmr_seq_tbl` size 0x6000 / 0x100.
0x00 cmd; 0x04..0x0C never touched (vector alignment); 0x10 vec0; 0x20 vec1; 0x30/0x34/0x38
polymorphic (anonymous unions); 0x3C name[0x20]; 0x5C next.
- 0x30: frame (int) for delays/moves/quake/fade/SetPasFrm; float for SetAngle/Height/Dist and
  the slowing rate; object handle for SetSyncObj; character number for CharaAttach.
- 0x34: Move2/MoveAHD2 ease type; slowing frame count; SetSyncObj follow mode; CharaAttach float
  distance.
- 0x38: Move2/MoveAHD2 ease rate (float); CharaAttach frame count (int, <0 = forever).
- vec0: SetPos/MovePos/Move/AddPas/Move2 eye; SetAHD/MoveAHD (x=angle,y=height,z=dist); SetSyncObj
  AHD; Fade rgb; Quake amplitude. vec1: ref; SetSyncObj offset.
- Quake2 zeroes vec0.x and vec0.z (vertical only); divides by frame when frame < 0 (never after
  conversion, which only touches > 0).

## _SEN_OBJ_SEQ (0x50)
Stride 0x50 (Initialize loop, SearchSeq `+0x14` words, `obj_seq_tbl` 0x5000/0x100).
0x00 cmd; 0x04..0x0C untouched; 0x10 vec; 0x20/0x24/0x28 unions; 0x2C name[0x20]; 0x4C next.
- 0x20: frame; float for Jump height, AttachCamera dist, SetStep/SetChengeStep/motion times;
  handle for SetEohFramePos; motion flags for Set/NextMotion; snd_id for SePlay; on/off for
  TexAnime; ground flag for StartPas.
- 0x24: Move ground flag (1 = snap Y to collision via GetColPoly/CheckHit); Move2/Rotation2 ease;
  Jump/SetEohFramePos/AttachCamera frame count; Set/NextMotion float step; SePlay se_no.
- 0x28: Move2/Rotation2 ease rate (float); Set/NextMotion "started" flag (0 then 1). SetMotion
  completes immediately when the next command is 0x19 (SetMotChangeStep) or 0x1D (NormalDrive).

## CSceneCmrSeq (0xB10)
Size: `CameraSeq` symbol size 0xB10; ctor at 0x1C0 constructs CCameraPas.
- 0x00 seq_tbl, 0x04 seq_num (Initialize).
- 0x08..0x2C: head/tail pairs for tracks 0..4 (PR, AHD, Fade, Quake, Chara) from SearchNext*
  and the if-chain in Play. `GetNextSeq(seq, track)` frees the entry for track 2 always, for
  track 1/0 only while ahd_keep/pr_keep is NULL; tracks 3 and 4 never free (as coded).
- 0x30 pr_keep, 0x34 ahd_keep (Keep handlers; Play restarts from them on result 2 for tracks 0/1).
- 0x38..0x48 per-track frame counters (pr, ahd, fade, quake, chara) from the handlers.
- 0x4C unused.
- 0x50 pos / 0x60 ref: read from active camera (GetPos/GetRef) at the start of Play and written
  back at the end. 0x70 angle, 0x74 height (pos.y - ref.y), 0x78 dist (XZ distance), recomputed
  in Play and scsSetPos/SetRef.
- 0x7C sync flag, 0x80 sync_obj handle, 0x84 sync_mode (0 fixed, 1 add object yaw, 2 full frame
  LW matrix; set to 1 by Play when the named frame is not found), 0x88/0x8C unused, 0x90 sync_ofs,
  0xA0/0xA4/0xA8 sync angle/height/dist, 0xAC sync_frame[0x20] (strcpy/strcmp with ""), 0xCC unused.
- 0xD0/0xE0: even-move per-frame deltas (scsMove/MovePos/MoveRef).
- 0xF0 angle_spd, 0xF8 height_spd, 0xFC dist_spd (scsMoveAHD/MoveAHD2); 0xF4 never accessed
  (Clear zeroes 0xF0, 0xF8, 0xFC individually).
- 0x100/0x110 current eased deltas, 0x120/0x130 eased accelerations, 0x140 ease_frame
  (= fptosi(frame * ease_rate)). MoveAHD2 reuses 0x100 and 0x120 x/y/z for angle/height/dist.
- 0x144..0x14C unused.
- 0x150/0x160 last pos/ref delta (set by scsMove and scsStartPas, decayed by scsPRSlowing).
- 0x170 last AHD delta vector (scsMoveAHD sets, scsAHDSlowing decays).
- 0x180 quake flag; 0x184..0x18C unused; 0x190 quake amplitude (decays linearly); 0x1A0/0x1B0
  unshaken pos/ref (Play restores them at the start of each frame while quake is set).
- 0x1C0 CCameraPas pas.
- CheckEnd ignores the character track (0x28).

## CSceneObjSeq (0x5F0)
Size: `__construct_array(ObjectSeq, __ct__12CSceneObjSeqFv, 0, 0x5F0, 0x20)` in
`__sinit_event_func_cpp`; `ObjectSeq` size 0xBE00 = 32 * 0x5F0; `GetObjSeq` indexes by 0x17C words.
- 0x00 seq_tbl, 0x04 seq_num; 0x08..0x3C head/tail pairs for tracks Pos, Rot, Mot, Anm, Col, Scale,
  Se (SearchNext* and the Play switch); 0x40..0x58 per-track counters (same order).
- 0x5C, 0x60 never accessed (Clear does not touch them either).
- 0x64 eoh_no (CEohMother handle; Clear sets -1; Play does nothing while < 0, and clears when
  CEohMother::GetPos does not return 1).
- 0x68/0x6C unused (alignment).
- 0x70 pos, 0x80 rot (read from CEohMother at the start of Play, written back at end; rot.y passed
  through mgAngleLimit).
- 0x90 pos_spd, 0xA0 rot_spd (even move/turn; Reference uses 0xA4 only), 0xB0/0xC0 current eased
  deltas, 0xD0/0xE0 eased accelerations, 0xF0/0xF4 pos/rot ease frames, 0xF8/0xFC unused.
- 0x100/0x110 jump start/end (CalcPosParabolicJump).
- 0x120 colour delta (scsSetColor), 0x130 scale delta (scsSetScale).
- 0x140 CCharaPas pas (scsStartPas steps it into pos and &rot.y).
- Clear does not reset seq_tbl entries; Initialize frees every pool entry after Clear.

## Unresolved
- Retail field names are unknown; all field names are descriptive.
- The 0x04..0x0C words of both command structs and the unused class gaps listed above.
- Meaning of the motion `flags` int passed through to CEohMother::SetMotion (vtable slot 0xB0 of
  the object's character).

## Compiler flag cleanup

The two local `divbyzerocheck on`/`reset` pairs are redundant with the PS2
compiler flag. Removing them leaves every section and symbol in this unit's
object diff unchanged.
