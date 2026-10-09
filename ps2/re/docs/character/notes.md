# character: reverse-engineering notes

Header: `ps2/include/character.hpp`. Declares `CCharacter2`, `CCharaLOD`, the info-file record
types (`CHRINFO_*`), the character slot structs (`CHARA_*`) and the enums for motion flags,
motion status, sequence state, sequence step type and sound kind.

## Hierarchy and size
- `CCharacter2 : CObjectFrame : CObject : mgCObject`. Evidence: `__ct__11CCharacter2Fv`
  (dng_effect, 0x1C6C80) stores `__vt__9mgCObject`, `__vt__7CObject`, `__vt__12CObjectFrame`,
  `__vt__11CCharacter2` in turn, calling `Initialize` (slot 0x3C) after each.
- The ctor then zeroes 0x35C, 0x364, 0x360 (in that order) and calls `Initialize` again.
- `sizeof(CCharacter2) == 0x660`: `__sinit_dng_main_cpp` does
  `__construct_array(&ItemBaseData, __ct__11CCharacter2Fv, 0, 0x660, 0x13)`. Last field ends at
  0x654; the rest is 16-byte alignment padding (the class holds `sceVu0FVECTOR`s).
- `CObject` (0x00..0x70) is in `map.hpp`, `CObjectFrame` (adds `frame` at 0x70, size 0x80) in
  `object.hpp`. `CObject::fade` at 0x54 is what `Set/GetFadeFlag` access.
- The implicit `CCharacter2::operator=` is emitted in actionchara (0x173C10). It is a memberwise
  copy and is the best map of the field layout (word/halfword/byte copies, array loops). It is
  not declared: declaring it would make it user-provided. `CObject::operator=` is emitted in
  character (0x17AB20, called by `Copy`), also implicit.
- `CDynamicAnime::CDynamicAnime()` (0x178300) is emitted here as an inline; it is declared in
  dynamicanime.hpp.

## Vtable (`__vt__11CCharacter2`, 0x37BA80, size 0xF8)
Slots after the 8-byte header (byte offset in the vtable as used by `lw $25, N($25)`):
0x08 ChangeParam, 0x0C UseParam (mgCObject); 0x10 SetPosition(float*) [override];
0x14 SetPosition(f,f,f) [override]; 0x18 GetPosition; 0x1C/0x20 SetRotation; 0x24 GetRotation;
0x28/0x2C SetScale; 0x30 GetScale; 0x34 Draw [ovr]; 0x38 DrawDirect [ovr]; 0x3C Initialize [ovr];
0x40 PreDraw (CObjectFrame); 0x44 GetCameraDist [ovr]; 0x48 FarClip; 0x4C DrawStep [ovr];
0x50 GetAlpha; 0x54 Show; 0x58 GetShow; 0x5C SetFarDist; 0x60 GetFarDist; 0x64 SetNearDist;
0x68 GetNearDist; 0x6C CheckDraw; 0x70 Copy(CObject&); 0x74 UpDatePosition; 0x78 Copy(CObjectFrame&).
New in CCharacter2: 0x7C LoadPack, 0x80 LoadPackNoLine, 0x84 LoadChrFile, 0x88 GetMotionStatus,
0x8C GetNowMotionName, 0x90 CheckMotionEnd, 0x94 GetNowFrameWait, 0x98 GetChgStepWait,
0x9C SetNowFrame, 0xA0 SetNowFrameWeight, 0xA4 GetNowFrame, 0xA8 GetWaitToFrame,
0xAC SetMotion(int,int), 0xB0 SetMotion(char*,int), 0xB4 ResetMotion, 0xB8 SetStep,
0xBC GetStep, 0xC0 GetDefaultStep, 0xC4 SetFadeFlag, 0xC8 GetFadeFlag, 0xCC DrawShadowDirect,
0xD0 NormalDrive, 0xD4 Step, 0xD8 ShadowStep, 0xDC SetWind, 0xE0 ResetWind, 0xE4 SetFloor,
0xE8 ResetFloor, 0xEC Copy(CCharacter2&), 0xF0 GetCopySize, 0xF4 DrawEffect.
The header declares the virtuals in this order. The first non-inline virtual declared is
`SetPosition(float*)` (defined in character), so the vtable is emitted in character.
The inline virtuals (GetMotionStatus, GetNowMotionName, GetNowFrameWait, SetNowFrame,
GetNowFrame, GetStep, Set/GetFadeFlag, GetCopySize, SetPosition(f,f,f)) are emitted in mapparts
(0x169820..0x169930). `SetPosition(f,f,f)` loads a {0,0,0,1.0} template from mapparts' data with
lq and then stores x/y/z: written as `sceVu0FVECTOR position = {x, y, z, 1.0f}`.

## Field evidence (offset -> evidence)
- 0x80 `velocity`: CActionChara *MoveIF/StepParam copy, add to, normalise it.
- 0x90 `base_scale`: `_SCALE` writes x,y,z, w=1.0, then calls SetScale(float*) on it and on the shadow.
- 0xA0 `unk_A0`: only zeroed (Initialize) and copied. 0xA4..0xAF never touched (alignment).
- 0xB0 `entry_matrix`: Initialize makes it unit (mgUnitMatrix). Step stores the matrix of entry
  frame 0 there each step after comparing it with the previous one (distance > 20, or Y angle
  differs by more than pi/4 -> ResetDAPosition).
- 0xF0 `name[16]`: byte-copied 16 bytes; CActionChara::SearchChara etc. strcmp it.
- 0x100 `alpha`: Draw/DrawDirect multiply it with the FarClip alpha.
- 0x104/0x108 `poly_num[2]`: `_POLY_NUM` (1 or 2 int args).
- 0x10C/0x110/0x114 `body_width/height/depth`: `_BODY_SIZE` args (height, width, depth) as ints
  converted to float; 0x110 used as height by GetCameraDist, MenuAdjustPolygonScale,
  MonsterScaleCheck. Width/depth naming follows the first game's CCharacter.
- 0x118 `load_size`: ScanInfoFile stores the drop in the model mgCMemory's free space.
  0x11C `copy_size`: read only by GetCopySize.
- 0x120 u16 flags: SetDAnimeEnable(0) sets bit 0; StepDA skips while set. 0x122 is padding.
- 0x124 `outline`: COutLineDraw list (next at +0). 0x128: `_OUTLINE` stores the screen texture
  number used in the "%d" texture name; Copy rebuilds outlines when > 0.
- 0x12C/0x130 dynamic anime count/array (stride 0x90), allocated by `_CLOTH_START`.
- 0x134 `shape_anime`: `_SHAPE_ANIME`; `_MODEL`/`_SKIN_MOTION` choose visual type 0 vs 4 by it.
- 0x138/0x13C `entry_frame[2]`: `_OBJECT_NAME`/`_OBJECT_NAME2`. Note GetEntryObjectPos(int,..)
  accepts index 0..2; index 2 reads 0x140 (= entry_object[0].frame).
- 0x140 `entry_object[24]` (0x10 each, Initialize sets {0,0,-1,0}). +4 is a float from
  `_OBJECT_NAME2` (meaning unknown), +8 group, +0xC in-use flag.
- 0x2C0 `shadow_frame`: `_SHADOW_MODEL`.
- 0x2C4 `images[6]`: IM3 archive copies (`_IMG_END` copies `img_ptr[6]`); Delete* walk
  +8 (num3) entries of 0x40 from +0x10, skipping names starting '#'.
- 0x2DC/0x2E0/0x2E4: tex anime group count / first group of own archive / texture block.
- 0x2E8 `deform_frame[24]` + 0x348 count: `_MODEL` from `alloc_vertex` names.
- 0x34C/0x350/0x354: LOD count / CCharaLOD array (`_LOD_MODEL_START`, stride 0x18) / current LOD
  (-1 after `_LOD_MODEL_END`). 0x358: copied from CCharaLOD::motion; Step/ShadowStep do nothing
  while 0 (Initialize sets 1).
- 0x35C/0x360/0x364: shadow link count and two int arrays (`_SHADOW_MODEL`): model frame id /
  shadow frame id pairs, used by ShadowStep and `_CLOTH`.
- 0x368..0x370 requested key/flags/set (SetMotion*), 0x374 current key, 0x378 sequence mode
  (1 = sequence), 0x37C current flags, 0x380 current set, 0x384 status, 0x388 frame,
  0x38C frame ratio, 0x390 step, 0x394 posed key, 0x398..0x3A0 previous flags/set/frame
  (NormalDrive).
- 0x3A4..0x3BC sequence state (Step). 0x3BC is only zeroed in character and read as the
  "move on" request; nothing found writing it nonzero yet.
- 0x3C0/0x460 `tagMOTION_TYPE[8]` (memset 0xA0 each; DrawShadowDirect indexes 0x460 by now_set).
- 0x500: only zeroed and copied -> `unk_500`. 0x504 shadow frame info (`_SHADOW_MOTION`).
- 0x508 blend weight, 0x50C blend speed (0.2 default, CHRINFO_SEQ::blend_speed).
- 0x510/0x530/0x550: per-set key list / key count / seq header list (`_KEY_*`, `_SEQ_*`).
- 0x570 `sword_effect[3]` (SetSwordBlurEffect in maintex fills [0]).
- 0x57C..0x5A0 sound: foot bank (EditStep copies a scene value), foot sound id (-1), foot enable
  (1), bank, bank 2, positional flag (1 -> sndGetVolPan from entry pos 0), volume, pan,
  foot effect timer (CheckFootEffect), CLoopSeMngr*. Names of the banks are neutral.
- 0x5A4/0x5C4: per-set CHRINFO_SE list / count (`_SE_START`, `_SE`, `_SELP`).
- 0x5E4..0x650 effects: image-load flag (1), CHRINFO_EFFECT list, 8 x CHARA_ENTRY_EFFECT,
  CHRINFO_EFFECT_IMAGE list, enable (1). See InitEffect, `_EFFECT`, ExecEntryEffect.

## Info-file record types (names other than CHRINFO_KEY_SET are not retail)
- `CHRINFO_KEY_SET` (retail name, from ExecEntryEffect's mangled name): 0x30, `_KEY`.
- `CHRINFO_SEQ_HEADER` 0x30, `CHRINFO_SEQ` 0x2C (`_SEQ_START`, `_SEQ`, `_SEQ_END`).
  The 0x23 byte of CHRINFO_SEQ is never written.
- `CHRINFO_SE` 0x10: `_SE` (name, kind, no, frame), `_SELP` (+ end frame, loop slot).
  Frames <= 1.0 are converted with GetWaitToFrame (vt 0xA8).
- `CHRINFO_EFFECT` / `CHRINFO_EFFECT_IMAGE` 0x28 (`_EFFECT`).
- Struct return types of GetKeyListPtr etc. are chosen from the record they return; Ghidra
  shows `char *` (the name is at +0, so either fits; return types do not mangle).

## Enum values and where seen
- CharaMotionFlag 1/2/4: NormalDrive (`& 1` no advance, `& 2` hold at end, `& 4` restart).
- CharaMotionStatus 0..4: NormalDrive, GetChgStepWait (3), Step (4 = end).
- CharaSeqState 0..4, ChrInfoSeqType 0/1/2/3/7: Step.
- ChrInfoSeKind 0..4: SePlay (`< 2` footsteps: id = kind + foot_sound_id*2; 2 and 4 use se_bank,
  4 also starts the foot effect timer; 3 uses se_bank_2).

## Globals / functions
- Every data symbol of the unit (`tag`, `skin_tag`, `nowChr`, `alloc_vertex`, `img_ptr`
  [6 pointers, 0x18], etc.) is LOCAL in retail, so none is declared in the header; all belong
  in character.cpp as `static`. Every non-member function (ScanInfoFile, ScanInfoSkinFile,
  CreateChangeFrame and the `_TAG(SPI_STACK*, int)` handlers) is local too.
- `tag` (0x140 = 40 SPI_TAG_PARAM) and `skin_tag` (0x28 = 5) are the tag tables, defined as
  native `SPI_TAG_PARAM[40]` / `SPI_TAG_PARAM[5]` with inline name strings and file-local
  callbacks. Retail pads the skin table with eight zero bytes before the next piece.
- Parser storage is native: `alloc_vertex` is `char[25][16]`, `img_ptr` is the six-entry
  `mgIMG_FILE_HEADER *` array (0x18 bytes; retail pads eight more), `skin_mds_name` is `char[64]`.
- `_SHADOW_MODEL` initializes a two-entry `mgCreateVisualType` array (shadow MDT for the empty
  object name, then the end sentinel). `_OUTLINE` uses a function-local
  `static int outline_num = 1` with MWCC's generated guard. `CCharacter2` emits its own vtable.
  Diagnostic formats, the outline texture format, the weight-file suffix and empty names are
  inline literals.
- Both `_MODEL` walks index `alloc_vertex[index]`; a typed pointer walk in the second loop
  differs in four words/relocation sites.
- `_OBJECT_NAME` and `_OBJECT_NAME2` bound their free-slot searches by `CHARA_ENTRY_FRAME_MAX`
  (2) and `CHARA_ENTRY_OBJECT_MAX` (0x18).

## Oddities
- GetWaitToFrame looks the motion up on `nowChr`, not `this`.
- GetEntryObjectPos(int, float(*)[4]) clamps out-of-range indices to 0.

## First game
- The first game's `CCharacter` (chronicle character.hpp, CObject-based, 0x11B0) shares only
  the idea (body size, motion sets, foot sounds); layout and API differ entirely. CCharaLOD,
  sequences, outlines and effects have no counterpart there.

## Source status
Every function in `character.cpp` is native; the unit has no `NONMATCHING` guards,
`INCLUDE_ASM` gaps, or data markers. `NormalDrive` changes the active key when a new request
arrives, records the previous motion for blending, and applies pause, hold and restart flags
while advancing frames; it sends the current frame to SetMotionTime or blends with
ChangeMotion until the new key is posed.

## Shadow frame types
`_SHADOW_MODEL` compares the root model's `frame_list` with the shadow model's
`frame_list`, both arrays of `mgCFrame*`. The shadow model's `frame_num` is the
loop bound, and each candidate's `name` is passed to `SearchFrameID`. Using
these members directly removes the byte offsets and retains a 100% object
match.

## Entry-object position lookup

`GetEntryObjectPos(int id, int nth, float*)` walks the 24 `entry_object` records. It counts records with a non-null `frame` and matching `group`, then asks the selected frame for its world position. Named record access matches the retail function at 100%; the slot pointer is returned.

`DeleteExtMotion` accesses `images[1..5]` through a byte offset
(`(mgIMG_FILE_HEADER **) ((u8 *) this + offset + 0x2C4)` with `offset += 4`). A direct
`this->images[j]` or `&this->images[j]` keeps the 0x1E4-byte body but swaps `s4`/`s5` between
the image pointer and the offset induction value; retail keeps separate `j` and byte-offset
counters. Indexing with `offset / 4` changes more instructions, and keeping the offset live
through the loop bound or the clear store also misses. The similarly named local `images`
holds the current archive, so `&images[j]` is a different (wrong) expression.

## Typed access forms
- `Initialize` writes `velocity` (0x80-0x8C, w 1.0), `move_accel` (0xA0), `entry_matrix` (0xB0,
  passed to `mgUnitMatrix`), `main_frame_info` (0x500, `tagFRAME_INF *`, cleared with `NULL`) and
  `seq_step` (0x3AC) through their members; `alpha = 1.0f`; float zeros store as `$zero` either
  way; the motion table clears use `sizeof`.
- Sequence end test: `playing[1].name[0]`. `name` members at offset 0 of `CHRINFO_SEQ` /
  `CHRINFO_KEY_SET` replace `(char *)` casts of the records.
- Effect entry: the local is a `CHARA_EFFECT_MANAGER *` and `motion_name` (+0x1BC) /
  `start_ratio` (+0x1DC) are its members.
- `_OBJECT_NAME`: the two walks over `entry_frame` / `entry_object` are indexed `for` loops;
  the second needs its own counter `j` (reusing `i` swaps counter and offset in that loop,
  reusing `n` changes the later argument loop). `_OBJECT_NAME2` has no offset counter.
- `_MOTION` / `_SHADOW_MOTION`: `&nowChr->motion[id]`, `&nowChr->shadow_motion[id]`,
  `motion->frame_info`. The shadow entry of the new slot takes the first entry's
  `base_matrices`, `motion_list`, `skin_list` and `unk_0C` through `tagMOTION_TYPE *` locals.
- `CreateChangeFrame`: the `mgCreateVisualType` walk is `&list[i]` ending at
  `MG_VISUAL_CREATE_END`; a pointer walk `entry++` is 12 bytes shorter.
- `DeleteExtMotion`, `DeleteImage`: `(u8) image->name[0] != '#'` loads with `lbu`; plain
  `image->name[0]` loads with `lb`.
- `GetSoundInfoCopy`, `_CLOTH_START`, `_LOD_MODEL_START`: the stack block is the `u_long128 *`
  that `Alloc` returns, passed to placement `new` directly. `GetSoundInfoCopy` and `_SE_START`
  use placement `new (block) CHRINFO_SE[n]`.
- `CopyOutLine` holds the shared screen texture as `mgCTexture *texture`.
- `Draw` LOD outline: the stack copy is a local `OutlineCopy` POD viewed as `COutLineDraw`; a
  `COutLineDraw` local would run its constructor (`next = NULL; Initialize()`), which retail
  does not call.
- `SetMotionPara`: `switch ((int) sequence)` with `case 0`; `if (sequence != NULL)` changes
  the branch layout.
- `_SHADOW_MODEL`: `(s32 *) operator new[](bytes, ...)` for the frame link tables; `new (...)
  s32[count]` recomputes `count * 4` into a new register instead of reusing `bytes`.
- `_OUTLINE` and `Copy`: `(COutLineDraw *) operator new(...)` followed by the constructor's
  `next = NULL; Initialize();`. `new (...) COutLineDraw` in `Copy` tests the copied register
  after the `move` and swaps `s4`/`s5`; in `_OUTLINE` it also renumbers the static locals.
- Loaded data at API boundaries: `_SKIN_MOTION` hands pack entries to `mgLoadData` as
  `MDS_HEADER *`, `unsigned int *` and `float (*)[4][4]` and the image copy to
  `mgGetIMGHeaderNum`/`mgGetIMGHeader` as `char *`; `DeleteExtMotion` steps from an
  `mgIMG_FILE_HEADER` to the `mgIMG_HEADER` records after it; `_KEY_START` starts the key
  list at the free top of `now_stack`. `(mgCVisualMotionMDT *)` downcasts follow `Iam()` checks.
