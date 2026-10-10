# sysmes: reverse-engineering notes

`SystemMesStack` and the three `SystemMessage` instances are native globals. Their inline
constructors generate the 68-byte retail `__sinit_sysmes_cpp` in declaration order.

## Types
No class is owned by `sysmes` (`build/re/class_units.tsv`). The unit uses:
- `ClsMes` (owner `nd_meswin`; forward-declared in this header). Retail symbol
  sizes of `SystemMessage*` give `sizeof(ClsMes) == 0x2958`;
  each object occupies 0x2960 in .bss (16-byte alignment padding).
- `mgCMemory` (`mg_memory.hpp`, size 0x30) for `SystemMesStack`. `__sinit_sysmes_cpp` calls
  `mgCMemory::Init()`, i.e. the inline default constructor `mgCMemory() { Init(); }`.

## Globals
| Symbol | Address | Size | Declared type | Evidence |
|---|---|---|---|---|
| `SystemMesStack` | 0x01EA0F00 | 0x30 | `mgCMemory` | sinit calls `mgCMemory::Init` on it |
| `SystemMesBuffer` | 0x01EA0F30 | 0xD000 | `short[0x6800]` | receives system*.mes via `LoadFile`; returned as `short *` and passed to `ClsMes::SetBuff_system(short *)` / `CDC2Mes::SetMessData(short *, short *)` |
| `SysMesBuffer` | 0x01EADF30 | 0x13880 | `short[0x9C40]` | receives sysmes*.mes; passed to `ClsMes::SetBuff(short *)` |
| `SystemMessage` / `2` / `3` | 0x01EC17B0 / 0x01EC4110 / 0x01EC6A70 | 0x2958 | `ClsMes` | sinit constructs each with `ClsMes::ClsMes()` |

`build/re/local_symbols.tsv` lists `SystemMesBuffer`, `SysMesBuffer`, `SystemMessage`,
`SystemMessage2`, `SystemMessage3` as LOCAL objects (not `SystemMesStack`). They are only accessed
from this unit (other units go through the getters), so they are NOT declared in `sysmes.hpp`:
they are `static` definitions in `sysmes.cpp` with the types in the table.
Only `SystemMesStack` (global binding) is `extern` in the header.
`SysMesNo`/`SysMesCnt` (also local, near `IntiSystemMes__Fv` at 0x2DD920) belong to another unit.

## Functions
- `GetSystemMessage()` -> tail of `GetSystemMessage(0)` (inlined), returns `&SystemMessage`.
- `GetSystemMessage(int index)`: 2 -> `SystemMessage3`, 1 -> `SystemMessage2`, else `SystemMessage`.
  Tested in order `== 2`, then `== 1`.
- `LoadSystemMes()`: `switch (LanguageCode)` (global in `mainloop`, .sbss 0x0037D148):
  0 -> `meswin/system.mes` + `meswin/sysmes.mes`; 2..5 -> `system_N.mes` + `sysmes_N.mes`;
  default (incl. 1) -> `system_1.mes` + `sysmes_1.mes`. First `LoadFile` passes a stack `int`
  size out-pointer (unused afterwards), second passes NULL. Case order in the string table:
  0, 2, 3, 4, 5, default(_1). A language enum would belong to `mainloop`; none exists yet.
- `GetSystemMesBuffer()` / `GetSysMesBuffer()`: return the buffers as `short *`.
- `CreateSystemMes()`: `CreateSystemMes(0,0); CreateSystemMes(1,0); CreateSystemMes(2,0);`.
- `CreateSystemMes(int index, int unused)`: second argument never read (no `$a1` use in the asm).
  Gets the window, then performs what is evidently an inlined `ClsMes` reset (stores to
  0xBC..0x28FC, `GetDrawSpeedDef`, `InitMesWinTbl`, memset of 16 x 0x32 bytes at 0x1E59, etc.);
  likely an inline `ClsMes` member (compare `ClsMes::ClsMes()` / an inline init in nd_meswin) --
  check the `nd_meswin` header once written. Then `Preset(5)`, `SetBuff(GetSysMesBuffer())`,
  `SetBuff_system(GetSystemMesBuffer())`, each re-fetching the window via `GetSystemMessage(index)`.

## First game
The first game's `sysmes.hpp` has a single
`ClsMes SystemMessage` plus display-state globals and message helpers; this game's unit is a
different, smaller design (three windows, two buffers, getters) and shares nothing beyond the
`SystemMessage` name.

## Current source status

All functions and the compiler-generated initializer are native C++ and the
complete object matches retail. `LoadSystemMes` selects the language-specific
message files and preserves the first load's size output. `CreateSystemMes`
initializes the requested message window, then presets it and attaches the
system and ordinary buffers. The two buffer getters and both message getters
use the native storage described above. No assembly data markers remain.
