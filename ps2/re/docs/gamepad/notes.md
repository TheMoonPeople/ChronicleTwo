# gamepad: reverse-engineering notes

## Status

Every function in `ps2/src/gamepad.cpp` is native and the unit carries no `INCLUDE_ASM`,
`INCLUDE_RODATA` or `INCLUDE_BSS` markers. `CGamePad::Capture` is written as an
`#ifdef NONMATCHING ... #else ... #endif` pair of two native forms: the `NONMATCHING` branch
is the typed `PAD_CAPTURE_FRAME *frame` version, and the active branch walks the capture
buffer as `u8 *entry` offset by `frame * sizeof(PAD_CAPTURE_FRAME)` and stores the button as
`s16` and the four axes as bytes. Only the active byte-walk form reproduces retail's stores.

First-game counterpart: `CGamePad` in the first game's `gamepad.hpp`.
The layout up to 0x45C is the same; this game adds `debug_key_lock`, `vibration_elapsed` and
the capture fields, drops `AllOn`, `GetLX2/LY2/RY2`, `GetLXf2/LYf2` and adds `Connect`,
`WaitEnable`, `Close`, `GetRXf2`, `Up`, `GetPadUp`, `CancelAutoRepeat2`, `SetAutoRepeat2`,
`DebugKeyLock`, `Step(int)` (first game: `Step()`), the capture functions and the thread.
The first game's `PAD_DATA` union (input/actuator views) is not needed here: every vibration
access fits `PAD_STATUS` directly.

## Binding (retail ELF `readelf -s`)
- LOCAL (static in the .cpp, not in the header): `pad_button_read`, `read_pad`,
  `AxisCalibration`, `GamePadStep`, data `GamePad` (CGamePad*, 0x37CF44), `TheadID`,
  `ThreadStack` (`static u8[0x400]`, 16-byte aligned), `pad_dma_buf`, `pad_dma_buf2`
  (`static u8[0x400]` each, scePadPortOpen DMA buffers, 64-byte aligned), `old_vsync`
  (file-scope static int read and written by GamePadStep; retail names it `old_vsync` with no
  numbered suffix, and the symbol list's `old_vsync__2` only tells it apart from dataread's
  own `old_vsync`), `rpad$256`/`init$257` and `cnt$374`/`init$375`.
- `rpad` and `cnt` are function-local statics written as the natural `static u16 rpad = 0;`
  in `pad_button_read` and `static int cnt = 0;` in `CGamePad::UpDate` (toggled 0/1 each
  frame, never read elsewhere). MWCC emits the retail `init$` guard bytes and the
  `rpad$256`/`cnt$374` pieces itself; no file-scope definitions or hand-written guards exist.
- `read_pad` is forward-declared before the code because `WaitEnable` precedes it.
- GLOBAL: `SwitchGamePadThread`, `CreateGamePadThread`, every `CGamePad` member.
- The global instance `CGamePad GamePad` (0x3FA5A0, size 0x478, symbol `GamePad__2` in the
  config) is defined in **mainloop**, not here. gamepad.cpp has its own `static CGamePad
  *GamePad`, so gamepad.hpp must not declare `extern CGamePad GamePad`, and gamepad.cpp must
  not include a header that does. No other unit touches CGamePad fields directly (all
  access goes through member calls), so fields could be private; left public.
- The port-open diagnostic `"ERROR: scePadPortOpen\n"` is inline in both Init failure
  branches; `"host0:key_cap.bin"`, `"key_cap.bin"` and `""` are inlined in
  SaveCapture/LoadCapture.

## PAD_STATUS (0x4C) - offsets relative to the struct (class offset = +4 / +0x50)
- 0x00 button, 0x04 left_y, 0x08 left_x, 0x0C right_y, 0x10 right_x: pad_button_read stores
  `~(data[2]<<8|data[3]) & 0xFFFF`, data[7], data[6], data[5], data[4] (libpad: 4 rjoy_h,
  5 rjoy_v, 6 ljoy_h, 7 ljoy_v). read_pad resets sticks to 0x80 when not read, and when
  pad_mode == 4 (digital).
- 0x14 phase (PadSetupPhase), 0x18 state (scePadGetState), 0x1C extended_id
  (scePadInfoMode(...,InfoModeCurExID)), 0x20 pad_mode (data[1]>>4, return of
  pad_button_read), 0x24 previous_pad_mode.
- 0x28 vibration[6] (sent by scePadSetActDirect in Step; `[motor]` written by SetVibration),
  0x2E actuator[6] (read_pad phase 70 writes 0,1,FF,FF,FF,FF then scePadSetActAlign),
  0x34 vibration_timer[2] (SetVibration, Step). 0x3C..0x47 never accessed; 0x48 `unk_48` is
  only copied.
- Size 0x4C: UpDate's struct copy is 0x4C bytes (0x04..0x50 -> 0x9C..0xE8 and
  0x50..0x9C -> 0xE8..0x134).

## read_pad phases (same values as first game)
- 0: if state is Stable(6)/FindCTP1(2) and InfoMode(CurID) != 0: id = InfoMode(CurExID) if >0
  else CurID; 0x300/0x100/6/5/3/2/default -> 99, 7 -> 70, 4 -> 40.
- 40: InfoMode(CurExID)==0 -> 99, else 41 and falls into 41: SetMainMode(1,3)==1 -> 42.
- 42: GetState != ExecCmd(5) -> 0. 70: InfoAct(-1,0)==0 -> 99; SetActAlign ok -> 71.
- 71: GetState != 5 -> 99. 99 (default): reads buttons; returns `valid`: 1 when pad_mode
  matches the previous mode (or none yet), else resets phase to 0.

## CGamePad (0x478; size from the `GamePad__2` data symbol size 0x478)
- Layout: `int unk_000; PAD_STATUS pad[2]; PAD_STATUS previous_pad[2];` (pad at 0x04/0x50,
  previous at 0x9C/0xE8). UpDate copies `previous_pad[i] = pad[i]` before read_pad (MWCC
  copies it member-wise, the u8 arrays as byte pairs, the trailing words through FPRs).
  Down/Up/GetPadDown/GetPadUp use `pad.button & ~prev` / `~pad & prev`.
- 0x134..0x140 four ints zeroed by Init, never read.
- 0x144 repeat[2] (PAD_REPEAT 0x188): enabled +0, active +4, counter +8, initial_delay +0x88,
  repeat_delay +0x108 (relative to repeat base). SetAutoRepeat clamps delays to >= 2.
  SetAutoRepeat2 only configures bits not already enabled. UpDate: held -> counter++, counter
  >= initial_delay sets active; active and counter >= repeat_delay -> clears the button bit for
  the frame and resets counter; release -> counter 0, active cleared. The repeat pass covers
  both controllers (repeat[i] with pad[i]).
- 0x454 axis_threshold[2] (MenuModeOn/Off write [0]; UpDate ORs PAD_RIGHT/LEFT/DOWN/UP into
  pad[i].button when GetLX/GetLY exceed it - note GetLX/GetLY always read controller 0).
- UpDate also clears Up+Down and Left+Right when both are set (masks 0xAFFF, 0x5FFF).
- 0x45C key_lock: On/Down/Up/GetPad* return 0; On2/Down2 too.
- 0x460 key_lock2: On2/Down2 return 0; UpDate zeroes pad[1] and previous_pad[1] buttons and
  centres their sticks.
- 0x464 debug_key_lock: only written (DebugKeyLock writes both 0x464 and 0x460).
- 0x468 vibration_enabled: Init sets 1; SetVibration ignored when 0; Step zeroes vibration[0..1]
  when 0.
- 0x46C vibration_elapsed: SetVibration always resets it to 0 first, then ignores the call
  unless enabled, motor 0..1 and duration >= 0 (no upper limit, unlike the first game's 1200).
  Step adds `elapsed`; above 1000 (`< 0x3E9` test) it resets to 0 and StopVibration.
- Step's loop runs once (`i <= 0`): only pad[0]'s timers are counted down, by `elapsed`, not by 1.
- 0x470 capture_mode (PadCaptureMode: 1 Capture, 2 Play, called on &pad[0].status in UpDate).
- 0x474 capture_frame: compared unsigned (`sltiu`) with 0x2AAAA.
- Init clears in a loop per i: status fields, vibration[0..5], and writes
  `pad[i].status.vibration_timer[i] = 0` six times (index uses the port, not the byte index -
  a quirk of the original loop; reproduce when writing Init).

## Capture buffer
- `PAD_CAPTURE_BUFFER` is the fixed address 0x3000000 (EE RAM beyond the 32 MB of retail
  units; dev kit memory), `PAD_CAPTURE_FRAME[PAD_CAPTURE_FRAME_MAX]` with
  `PAD_CAPTURE_FRAME_MAX` = 0x2AAAA = 0x100000 / 6 (6 bytes each: u16 button, u8 left_y,
  left_x, right_y, right_x; struct name is not retail). Play reads the frame with lhu/lbu
  (unsigned). SaveCapture: `WriteFile("host0:key_cap.bin", PAD_CAPTURE_BUFFER,
  capture_frame * sizeof(PAD_CAPTURE_FRAME))`. LoadCapture: `SetCurrentDir("")`,
  `LoadFile2("key_cap.bin", PAD_CAPTURE_BUFFER, NULL, LOAD_FILE_READ)`, `SetCurrentDir(NULL)`.

## Return types / signatures
- GetRX/RY/LX/LY/RX2 are `j AxisCalibration` with the raw axis (0x14/0x10/0x0C/0x08/0x60).
  AxisCalibration: dead zone -49..49 (|v-128| < 50) -> 0, else (v-78)*128/78 or (v-177)*128/78.
- GetXXf = `(float)GetXX() / 128.0f`.
- AutoRepeatOff is `j CancelAutoRepeat` with mask -1.
- On/On2/Down/Down2/Up/Connect/GetPad*: declared int (bool vs int not distinguishable from
  retail; first game uses int). Init/Step/WaitEnable: void.
- SwitchGamePadThread = `RotateThreadReadyQueue(10)` (tail jump). CreateGamePadThread builds a
  ThreadParam {entry GamePadStep, stack ThreadStack, size 0x400, initPriority 10, gpReg &_gp},
  stores the CGamePad* in the static `GamePad`, StartThread(id, 0).
- GamePadStep loop: `now = mgGetVSyncCount(); d = now - old_vsync; if (d < 0) d = 1;
  if (d > 0 && GamePad) GamePad->Step(d); SwitchGamePadThread(); old_vsync = now;`.
- SDK declarations used: `scePadEnd`, `scePadPortClose` (libpad.h); `ThreadParam`, `_gp`,
  `CreateThread`, `StartThread`, `RotateThreadReadyQueue` (eekernel.h).

## Unresolved
- Meaning of unk_134..unk_140 and PAD_STATUS unk_3C..unk_48.
- debug_key_lock is never read in this unit.
