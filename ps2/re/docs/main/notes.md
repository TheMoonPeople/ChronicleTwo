# main: reverse-engineering notes

Program entry (called from `crt0` ENTRYPOINT). No classes, structs or enums are owned by this unit
(`class_units.tsv` has none). First game: `chronicle/ps2/src/main.cpp` is a much larger unit (game
mode table etc.); this game's `main` holds only start-up/shut-down, the game modes live in
`mainloop`.

## Binding (`build/re/local_symbols.tsv`)
- GLOBAL, declared in `ps2/include/main.hpp`: `main` (unmangled, C++ `int main()`).
- LOCAL, must be `static` in `main.cpp`: `VSyncCallBack__Fi` (0x15D470; splat name
  `VSyncCallBack__Fi__2`, other locals of the same name at 0x141870 and 0x192150),
  `ClearScreen__Fiii` (0x15D4A0), `init__Fv` (0x15D570).
- Data: `vcount` (splat `vcount__2`), 0x37CF84, 4 bytes, `.sbss`, LOCAL -> `static`, no extern.
  Other units have their own local `vcount` (0x37CEC0). `at_846`..`at_857` are string literals.

## Functions
- `static int VSyncCallBack(int)`: handwritten in retail (contains `ei`, a `sync` +
  `ei` epilogue; needs an asm block or stays INCLUDE_ASM). `vcount++`; reloads `vcount` after the
  store before testing `< 0` -> `vcount` is probably `volatile int`; clamps negative to 0;
  returns 0. Type matches `sceGsSyncVCallback(int (*)(int))`.
- `static void ClearScreen(int r, int g, int b)`: local `sceGsDBuff`;
  `sceGsSetDefDBuff(&db, 0 /*PSMCT32*/, 640, 448, 2 /*ZGEQUAL*/, 0x31 /*PSMZ24*/, 1)`; sets
  `clear0.rgbaq` and `clear1.rgbaq` R,G,B from args, A=0x80; `FlushCache(0); sceGsSyncV(0)` twice;
  `sceGsSwapDBuff(&db,0); sceGsSyncPath(0,0); sceGsSwapDBuff(&db,1); sceGsSyncPath(0,0)`.
  Return type: v0 left from the last call; m2c says void, Ghidra int. Assume void.
- `static void init()`: `sceDmaReset(1); sceGsResetPath(); sceGsResetGraph(0,1,3,0)`
  (= `SCE_GS_INTERLACE, SCE_GS_PAL, SCE_GS_FRAME`-style args: inter=1 interlace, omode=3 PAL, ffmd=0), `sceGsSyncVCallback(VSyncCallBack)`,
  `ClearScreen(0,0,0)`, `mwInit()`, `sceSifInitRpc(0); sceCdInit(0); sceCdMmode(2)`; loops
  `while(!sceSifRebootIop("cdrom0:\\MODULES\\IOPRP243.IMG;1"))`, `while(!sceSifSyncIop())`;
  re-inits RPC/CD; `sceFsReset()`; `printf("######################%d\n", vcount)`; then
  `while (sceSifLoadModule(path,0,0) < 0)` for SIO2MAN, PADMAN, MCMAN, MCSERV, LIBSD, SDRDRV,
  MODMIDI, MODHSYN, EZMIDI, EZBGM (`.IRX;1` under `cdrom0:\\MODULES\\`); `InitCDFile()`
  (dataread); `sceDmaReset(1); sceGsResetPath()`.
- `int main()`: `MainThreadPriority = 10` (global int in `mainloop`, `.sdata`, gp-0x7FA8);
  `ChangeThreadPriority(GetThreadId(), MainThreadPriority)`; `init()`; printf same format with
  `vcount`; `MainLoop()` (mainloop); `sceGsSyncPath(0,0); sceGsSyncVCallback(0); sceGsSyncV(0);
  sceCdInit(5 /*SCECdEXIT*/); sceSifExitCmd(); return 0`. Uses no argc/argv (unmangled, so the
  parameter list does not affect the symbol).
- `MainThreadPriority` and `MainLoop` should come from `mainloop.hpp`; `InitCDFile` from
  `dataread.hpp`; `mwInit` is the MW runtime init (no SDK header declares it yet).

## Current source status

`ClearScreen`, `init`, and `main` are native C++ definitions. `vcount__2` is a
file-local volatile counter so the callback and startup code reload it as
retail does. `VSyncCallBack` retains one assembly gap: retail ends with `sync`
and `ei`, which the plain C++ callback draft did not emit. The current source
has no guarded callback draft. Previous promotion trials and their data-section
binding issue are historical; matching of the current object is checked with
the integrated build.

The source now declares and calls the callback by its native static C++ name.
`postprocess_object.py` binds that local name to this unit's assembled
`VSyncCallBack__Fi__2` body, which keeps the retail callback address and
removes the source-level C-linkage alias. The linked game compiles with this
binding; `init` remains a 100% object match.

The ten IOP module paths and the shared counter format are inline literals.
No assembly data markers remain in this unit.
