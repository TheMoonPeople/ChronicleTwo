# photo: reverse-engineering notes

Camera mode (Max's camera): aim/zoom, shutter capture into a `USER_PICTURE_INFO`, overlay and text.
No class is owned by this unit; the header holds two enums and 14 global prototypes.
No first-game counterpart (Dark Cloud has no camera).

## Linkage
- `InitPhotoTitle__Fv` is LOCAL in retail (`local_symbols.tsv`): `static` in the .cpp, not in the header.
- Every data symbol is LOCAL, so the header declares no `extern`s. Types for the .cpp:
  - `TakePhotoMode` (0x37E8C8, int): `TakePhotoState`.
  - `AddProj` (0x37E8CC, float; retail `AddProj__2`): zoom projection offset. `LoopTakePhoto`:
    `AddProj -= Analog(3) * 10.0f`, clamped to [-200, 200]. Returned by `PhotoAddProjection`.
  - `CameraTexb` (0x37E8D0, int): texture-manager handle passed to `LoadTakePhoto` arg 0, reloaded by
    `DrawTakePhoto` via `ReloadTexture(CameraTexb, NULL)`; reset to -1.
  - `WorkTex` (0x37E8D4, `mgCTexture *`): `EnterTexture(0x7FFF, "fix_work", NULL, 0x40, 0x40, (U*)0x10, 0, 0)`;
    capture target (64x64), drawn as the last-photo preview. `DrawTakePhoto` returns 0 when NULL.
  - `ShutterAnmCnt` (int): set 8 after storing; counts down in mode 4, then mode -> 2.
  - `ShowTakePhotoCnt` (int): set 0x78 after storing; counts down in mode 2; preview drawn while >0 and
    ShutterAnmCnt==0, fading over the last 0x1E frames. `HidePhoto` zeroes it.
  - `OpenMenu` (int): set 1 on mode 6; written only, never read in this unit.
  - `ShowTitleCnt` (int): 0x5A when `SetTookPhotoData` gets a name; title drawn while >0.
  - `ShowLevelUpCnt` (int): 0x3C when `CInventUserData::LevelCheck` reports a rise.
  - `Font` (0x01F5D370, retail `Font__3`, `CFont`, symbol size 0xB8 = sizeof(CFont)). `__sinit_photo_cpp`
    tail-calls `CFont::Init` on it (CFont constructor inlined). `LoadTakePhoto` sets Preset 4, Fuchi 3,
    Clearance(0xF, 0x18).
  - `PhotoTitle` (0x01F5D430, `char[0x80]`): photo title, filled by `strcpy` from `GetPhotoNameCheck`.
  - `mes_txt` (0x362E30, .data, 0x60): `char *mes_txt[6][4]`,
    indexed `[LanguageCode][message]`; `GetMesTxt` checks 0<=message<4 and 0<=LanguageCode<6, else
    `null_txt` (.sdata, 4 bytes, a `char *` to an empty string presumably).
  - `at_936__6` (.data, follows mes_txt): float data incl. 1.0f, used by `DrawTakePhoto` (not analysed).
  - `at_1055`: format `"%d/%d"` (picture count / limit from `CInventUserData::GetPictureNum(int *)`,
    which writes two ints; count >= limit draws in red 0xFF,0x20,0x10).

## TakePhotoState (TakePhotoMode)
- 0 off (Init/End). 2 aim (`StartTakePhoto`; `IsEnablePhotoMenu` == 2). 3: `LoopTakePhoto` in mode 2 when
  `IsPhotoSpace(NULL)` != NULL and `Btn(0x33)`. `DrawTakePhoto` mode 3 copies the frame buffer into
  WorkTex -> 5. Mode 5: `mgStoreImage(WorkTex, buf[0x2400])`, max Z of rect (0xFC,0xCC)-(0x104,0xD4) ->
  `mgConvZBuffToDist` -> `*distance`; if picture != NULL, memcpy 0x2000 bytes to picture+0x14 pointer,
  sets bytes 0 and 1 to 1, plays system SE 0xB; -> 4. Mode 4 counts ShutterAnmCnt -> 2.
  Mode 6 -> OpenMenu=1, mode 2; nothing in the unit stores 6 and the variable is static (dead path).
  Value 1 never seen. `GhostPhotoTiming` is true for 3 and 5 (purpose of the name not established).
- `NowTakePhoto` = mode > 0.

## PhotoMessage (mes_txt column), English strings
0 "(A):Confirm Picture", 1 "(#):Take Picture", 2 "Max's photography level increased!",
3 "(R):zoom (X):Back". `DrawTakePhotoSystem` draws 0 at (0x28, H-0x29), 3 at (0xF0, H-0x29), 1 at
(0x28, H-0x15) when no title is shown; title at (0x14, H-0x24); level-up centred at y 0x140.

## Signatures
- `LoadTakePhoto__FiP9mgCMemoryP1`: `P1` is MWCC's mangling of `u_long128 *` (same as
  `CGyoraceFishData::LoadData`); args 2 and 3 unused.
- Return types (not in the mangling): `GetMesTxt` char*; `PhotoAddProjection` float (returns in $f0,
  callers `mov.s`); `NowTakePhoto`/`IsEnablePhotoMenu`/`GhostPhotoTiming`/`DrawTakePhoto` declared `int`;
  callers only `beqz`/`bnez` the result, no `andi 0xff`, so `bool` is equally possible.
- `SetTookPhotoData` passes its argument straight to `GetPhotoNameCheck(USER_PICTURE_INFO *)` (returns
  `char *` or NULL), then uses `GetSaveData() + 0x251D0` as the `CInventUserData` (AddShutterNum(1),
  LevelCheck(picture)).
- `DrawTakePhoto` (0xE10) only skimmed for globals; its draw body (overlay texture `at_997`, preview
  quad sized from WorkTex's width/height shorts) is not analysed.


## Native data and matching constraints

All data are native. `mes_txt[6][PHOTO_MES_NUM]` holds four messages in each of six
languages, preserving font-code tokens, punctuation and pooled strings. Shift-JIS uses
fixed-width octal escapes. `PhotoTitle` is char[128]; the native CFont supplies the
single static initializer.

`null_txt` is a native four-byte pointer to an inline empty string. Its R_MIPS_32
relocation establishes the otherwise ambiguous one-byte literal's identity after
subtracting compiled addends and target-symbol offsets.
