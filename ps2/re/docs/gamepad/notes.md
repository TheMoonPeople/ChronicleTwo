# gamepad: reverse-engineering notes

First-game counterpart: `CGamePad` in `/home/adubbz/development/chronicle/ps2/include/gamepad.hpp`.
The layout up to 0x45C is the same; this game adds `debug_key_lock`, `vibration_elapsed` and
the capture fields, drops `AllOn`, `GetLX2/LY2/RY2`, `GetLXf2/LYf2` and adds `Connect`,
`WaitEnable`, `Close`, `GetRXf2`, `Up`, `GetPadUp`, `CancelAutoRepeat2`, `SetAutoRepeat2`,
`DebugKeyLock`, `Step(int)` (first game: `Step()`), the capture functions and the thread.
The first game's `PAD_DATA` union (input/actuator views) is not needed here: every vibration
access fits `PAD_STATUS` directly, so `PAD_DATA` is a plain struct.

## Binding (retail ELF `readelf -s`)
- LOCAL (static in the .cpp, not in the header): `pad_button_read`, `read_pad`,
  `AxisCalibration`, `GamePadStep`, data `GamePad` (CGamePad*, 0x37CF44), `TheadID`,
  `ThreadStack` (0x400), `pad_dma_buf`, `pad_dma_buf2` (0x400 each, scePadPortOpen DMA
  buffers, need 64-byte alignment), `old_vsync` (file-scope static read and written by
  GamePadStep; retail names it `old_vsync` with no numbered suffix, and the symbol list's
  `old_vsync__2` only tells it apart from dataread's own `old_vsync`), `rpad$256`/`init$257`
  (function-local `static u16 rpad = 0` in pad_button_read), `cnt$374`/`init$375`
  (function-local `static int cnt = 0` in UpDate, toggled 0/1 each frame, never read
  elsewhere).
- GLOBAL: `SwitchGamePadThread`, `CreateGamePadThread`, every `CGamePad` member.
- The global instance `CGamePad GamePad` (0x3FA5A0, size 0x478, symbol `GamePad__2` in the
  config) is defined in **mainloop**, not here. gamepad.cpp has its own `static CGamePad
  *GamePad`, so gamepad.hpp must not declare `extern CGamePad GamePad`, and gamepad.cpp must
  not include a header that does. No other unit touches CGamePad fields directly (all
  access goes through member calls), so fields could be private; left public.

## PAD_STATUS (0x48) - offsets relative to the struct (class offset = +4 / +0x50)
- 0x00 button, 0x04 left_y, 0x08 left_x, 0x0C right_y, 0x10 right_x: pad_button_read stores
  `~(data[2]<<8|data[3]) & 0xFFFF`, data[7], data[6], data[5], data[4] (libpad: 4 rjoy_h,
  5 rjoy_v, 6 ljoy_h, 7 ljoy_v). read_pad resets sticks to 0x80 when not read, and when
  pad_mode == 4 (digital).
- 0x14 phase (PadSetupPhase), 0x18 state (scePadGetState), 0x1C extended_id
  (scePadInfoMode(...,InfoModeCurExID)), 0x20 pad_mode (data[1]>>4, return of
  pad_button_read), 0x24 previous_pad_mode.
- 0x28 vibration[6] (sent by scePadSetActDirect in Step; `[motor]` written by SetVibration),
  0x2E actuator[6] (read_pad phase 70 writes 0,1,FF,FF,FF,FF then scePadSetActAlign),
  0x34 vibration_timer[2] (SetVibration, Step). 0x3C..0x47 never accessed.
- Size: PAD_DATA stride 0x4C in every loop; UpDate copies 0x48 bytes status->previous status.

## read_pad phases (same values as first game)
- 0: if state is Stable(6)/FindCTP1(2) and InfoMode(CurID) != 0: id = InfoMode(CurExID) if >0
  else CurID; 0x300/0x100/6/5/3/2/default -> 99, 7 -> 70, 4 -> 40.
- 40: InfoMode(CurExID)==0 -> 99, else 41 and falls into 41: SetMainMode(1,3)==1 -> 42.
- 42: GetState != ExecCmd(5) -> 0. 70: InfoAct(-1,0)==0 -> 99; SetActAlign ok -> 71.
- 71: GetState != 5 -> 99. 99 (default): reads buttons; returns 1 when pad_mode matches the
  previous mode (or none yet), else resets phase to 0.

## CGamePad (0x478; size from the `GamePad__2` data symbol size 0x478)
- 0x000 pad[2] (PAD_DATA, status at +4 / +0x50). PAD_DATA+0 never accessed (unk_00).
- 0x098 previous_pad[2]: UpDate copies pad[i].status to previous_pad[i].status (0x9C, 0xE8)
  before read_pad. Down/Up/GetPadDown/GetPadUp use `pad.button & ~prev` / `~pad & prev`.
- 0x130 unk_130 (never accessed); 0x134..0x140 four ints zeroed by Init, never read.
- 0x144 repeat[2] (PAD_REPEAT 0x188): enabled +0, active +4, counter +8, initial_delay +0x88,
  repeat_delay +0x108 (relative to repeat base). SetAutoRepeat clamps delays to >= 2.
  SetAutoRepeat2 only configures bits not already enabled. UpDate: held -> counter++, counter
  >= initial_delay sets active; active and counter >= repeat_delay -> clears the button bit for
  the frame and resets counter; release -> counter 0, active cleared.
- 0x454 axis_threshold[2] (MenuModeOn/Off write [0]; UpDate ORs PAD_RIGHT/LEFT/DOWN/UP into
  pad[i].button when GetLX/GetLY exceed it - note GetLX/GetLY always read controller 0).
- UpDate also clears Up+Down and Left+Right when both are set (masks 0xAFFF, 0x5FFF).
- 0x45C key_lock: On/Down/Up/GetPad* return 0; On2/Down2 too.
- 0x460 key_lock2: On2/Down2 return 0; UpDate zeroes pad[1] and previous_pad[1] buttons and
  centres their sticks.
- 0x464 debug_key_lock: only written (DebugKeyLock writes both 0x464 and 0x460).
- 0x468 vibration_enabled: Init sets 1; SetVibration ignored when 0; Step zeroes vibration[0..1]
  when 0.
- 0x46C vibration_elapsed: SetVibration resets to 0; Step adds `elapsed`; above 1000 (`< 0x3E9`
  test) it resets to 0 and StopVibration.
- 0x470 capture_mode (PadCaptureMode: 1 Capture, 2 Play, called on &pad[0].status in UpDate).
- 0x474 capture_frame: compared unsigned (`sltiu`) with 0x2AAAA.
- Init clears in a loop per i: status fields, vibration[0..5], and writes
  `pad[i].status.vibration_timer[i] = 0` six times (index uses the port, not the byte index -
  a quirk of the original loop; reproduce when writing Init).

## Capture buffer
- Fixed address 0x3000000 (EE RAM beyond the 32 MB of retail units; dev kit memory),
  PAD_CAPTURE_FRAME[0x2AAAA] (6 bytes each: u16 button, u8 left_y, left_x, right_y, right_x;
  struct name is not retail). SaveCapture: `WriteFile("host0:key_cap.bin", 0x3000000,
  capture_frame * 6)`. LoadCapture: `SetCurrentDir(at_909 = "")`, `LoadFile2("key_cap.bin",
  0x3000000, NULL, 0)`, `SetCurrentDir(NULL)`.

## Return types / signatures
- GetRX/RY/LX/LY/RX2 are `j AxisCalibration` with the raw axis (0x14/0x10/0x0C/0x08/0x60).
  AxisCalibration: dead zone |v-128| < 50 -> 0, else (v-78)*128/78 or (v-177)*128/78.
- GetXXf = `(float)GetXX() / 128.0f`.
- AutoRepeatOff is `j CancelAutoRepeat` with mask -1.
- On/On2/Down/Down2/Up/Connect/GetPad*: declared int (bool vs int not distinguishable from
  retail; first game uses int). Init/Step/WaitEnable: void (Ghidra's int is a leftover
  printf/scePadSetActDirect return).
- SwitchGamePadThread = `RotateThreadReadyQueue(10)` (tail jump). CreateGamePadThread builds a
  ThreadParam {entry GamePadStep, stack ThreadStack, size 0x400, initPriority 10, gpReg &_gp},
  stores the CGamePad* in the static `GamePad`, StartThread(id, 0).
- GamePadStep loop: `now = mgGetVSyncCount(); d = now - old_vsync; if (d < 0) d = 1;
  if (d > 0 && GamePad) GamePad->Step(d); SwitchGamePadThread(); old_vsync = now;`.

## Unresolved
- Meaning of unk_130..unk_140 and PAD_STATUS unk_3C..unk_44.
- debug_key_lock is never read in this unit.

## Drafting (job gamepad.1)
- Layout correction: UpDate's struct copy is 0x4C bytes (0x04..0x50 -> 0x9C..0xE8 and
  0x50..0x9C -> 0xE8..0x134), so PAD_STATUS is 0x4C (new `unk_48`, copied only) and CGamePad is
  `int unk_000; PAD_STATUS pad[2]; PAD_STATUS previous_pad[2];` (pad at 0x04/0x50, previous at
  0x9C/0xE8). `PAD_DATA` is gone; the former `unk_130` is `previous_pad[1].unk_48`. Written as
  `previous_pad[i] = pad[i]` (MWCC copies it member-wise, the u8 arrays as byte pairs, the
  trailing words through FPRs).
- Step's loop runs once (`i <= 0`): only pad[0]'s timers are counted down. Timers drop by
  `elapsed`, not by 1. SetVibration always zeroes vibration_elapsed first, then ignores the call
  unless enabled, motor 0..1 and duration >= 0 (no upper limit, unlike the first game's 1200).
- read_pad returns `valid`. The repeat pass in UpDate covers both controllers (repeat[i] with
  pad[i]). On2/Down2 also test key_lock2. AxisCalibration's dead zone is -49..49.
- Capture buffer: `PAD_CAPTURE_BUFFER` (0x3000000) and `PAD_CAPTURE_FRAME_MAX` (0x2AAAA =
  0x100000 / 6) in the header; Play reads the frame with lhu/lbu (unsigned).
- SDK additions: `scePadEnd`, `scePadPortClose` (libpad.h); `ThreadParam`, `_gp`,
  `CreateThread`, `StartThread`, `RotateThreadReadyQueue` (eekernel.h).
- A promoted WaitEnable calls the INCLUDE_ASM `read_pad`, so a forward declaration of the
  static `read_pad` stands before the code; `static CGamePad *GamePad` is defined outside
  `UNMATCHING` for the promoted GamePadStep.
- `--promote` once failed in crt0/.bss with an unchanged map while build/pal/obj was being
  rebuilt by someone else; the same source then passed. Re-run before suspecting the unit.
- DIFF drafts (logic checked against Ghidra/m2c, not matched): Init, pad_button_read, read_pad,
  UpDate, CancelAutoRepeat(2), SetAutoRepeat(2), Capture, Play, CreateGamePadThread (only
  relocations differ: `&_gp` / statics).
