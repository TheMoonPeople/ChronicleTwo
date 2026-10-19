# Debug mode

Retail cites are `ps2/src` file:line. PC cites are `port/src` or `tools/kazarov`.

## Config

`game.debug_mode` in `config.json`, default `false`, also set by **PC SETTINGS** > **Game** > **Debug mode**. The boot unlock reads it once at boot, so a change takes effect on the next start.

- `true`: at boot, `MasterDebugCode` is set to `MASTER_DEBUG_CODE` and `MasterDebugModeOn` is set to 1. Retail `title.cpp:2377` then unlocks pad 2 without a developer save. Retail `title.cpp:2281` would otherwise read the save's debug code. Also enables the pad-1 chord below.
- `false`: nothing changes at boot. Retail behaviour: pad 2 unlocks only if the four shoulders are held on pad 2 at boot and a memory card save carries a debug code. The pad-1 chord is off.

Set `"game": {"debug_mode": true}` in the `config.json` beside the save root to enable native debug controls. Ordinary boots preserve the retail developer-save gate. `--jump` enables debug controls explicitly for that run.

Boot code: `port/src/debug_mode.cpp` (`DebugModeBoot`), called from `port/src/mainloop.cpp` after the retail shoulder check.

## Pad-1 chord

Hold L1, L2, R1 and R2 on pad 1, then press R3. This toggles `DebugFlag`, the same switch as pad 2 Circle. It needs `debug_mode` true and `MasterDebugCode == MASTER_DEBUG_CODE`. It works while pad 2 is locked.

Keyboard (Kazarov `tools/kazarov/src/cpp/platform/input.cpp`, pad 1 bindings): L1 `Z`, L2 `Q`, R1 `F` or `X`, R2 `R`, R3 `B`. `Mouse3` also feeds R3, but it is also bound to `zoom_reset`.

`DebugFlag` starts off on ordinary boots. A `--jump` enables it for that run. Turn it on with the chord or with pad 2 Circle. The pad-1 controls below need it on.

## One controller

With `game.debug_mode` enabled, or with `--jump`, hold L2+Select on pad 1 to send
its buttons to the retail pad-2 debug reads. Real pad 2 still works. Circle toggles
`DebugFlag`, L1 toggles the performance meter, Right/Left scrub town time, and R2
toggles rain. Circle and Cross do not also activate their ordinary pad-1 actions
while the modifier is held. The game's overall pad lock is respected.

Pressing Select with L2 held pauses through a separate native pause action;
Select and L2 remain consumed by ordinary pad-1 and routed pad-2 reads. While paused, the modifier plus Right steps
one frame and the modifier plus Start stores a frame image in the save root.
Release the modifier and press Start to resume, or release and press Select with
L2 held again. To use another modified debug button without pausing first, hold
Select before adding L2.

Start+Select on pad 1 enters the retail developer menu from any active mode when
`game.debug_mode` is enabled or `--jump` is in use, even during a scripted pad
lock. Loading between modes finishes first. The chord acts once per press;
release both buttons before using it again. While frame-paused, modified Start
captures instead. The existing four-shoulder/R3 toggle remains available.

## Start+Select transition

The native main loop checks the host chord in the gameplay loop and the blocking
pause loop. Start may open the pause overlay before Select arrives; checking only
outside that overlay leaves the chord unreachable until the game resumes.
The frame-pause loop also checks the chord, except while modified Start is being
used for frame capture. The latch re-arms only after both buttons are released.

Before switching to the developer menu, the port restores paused audio through
`PauseEnd` and performs the active mode's cleanup. Town uses `PreExitLoop` to save
edits and release event, background-read, sub-game and audio state. Dungeon runs
its exit state through `LoopDungeonMain`; its `FinishDungeonMain` callback alone
does not perform that cleanup. Title runs its Start+Select exit branch so an
active attract movie is terminated. The menu destination is selected after this
cleanup, and the normal `LoopExit` callback still runs.

Regression replays `tools/input/debug-start-first.input` and
`tools/input/debug-select-first.input` press the two buttons six frames apart.
Run either with `--jump town:10 --fast-load --frames 420 --screenshot menu.png`
and a separate save root. Both reach the Ver0.334 developer menu; the Start-first
replay previously remained on the pause overlay. The same Start-first replay
also exercises the dungeon floor list with `--jump dungeon:0:1` and the title
with `--jump title`.

## Retail pad-2 controls

These work with the pad-2 Circle toggle. Pad 2 is locked unless the boot unlock above succeeds.

- Pad 2 Circle (`ps2/src/mainloop.cpp:677-678`): toggles `DebugFlag`. Most of the controls below read `DebugFlag`.
- Pad 2 L1 (`mainloop.cpp:671`): toggles the performance meter.
- Pad 2 Select (`mainloop.cpp:724`): pauses. While paused, pad 1 Start or pad 2 Select resumes (`mainloop.cpp:732`). Pad 2 Start stores a frame image (`mainloop.cpp:737`). Pad 2 Right, or pad 1 Circle or Right, steps one frame (`mainloop.cpp:741`). The pause is not gated by `DebugFlag`.
- Town and georama, pad 2 Right/Left: scrubs the time by 0.1 (`ps2/src/editloop.cpp:1080-1092`). Pad 2 Up/Down set the time and toggle the time step.
- Town, pad 2 R2 (`editloop.cpp:1879`): toggles rain.

## What `DebugFlag` unlocks on pad 1

- Title: Start+Select opens the debug menu (`ps2/src/title.cpp:848`). The menu's sub-views (maps, dungeons, title, chrview, texview, mapview, sound, movie, language, items, save edit, `dbg/game%d.cfg`, save convert) and its event select are available.
- Future map select: `ps2/src/mainloop3.cpp:115` (`FutureMapSelect`).
- Dungeon: R3 opens the dungeon debug menu (`ps2/src/dng_main.cpp:2177`, `dngDebugStart`, reached only under `DebugFlag` at `dng_main.cpp:2157`). R3 again closes it (`ps2/src/dng_debug.cpp:311`). Start+Select exits the floor (`ps2/src/dng_main.cpp:1133`).
- Town and georama: R3 opens the edit debug menu (`ps2/src/editloop.cpp:1719-1730`). With `DebugFlag`, R2 makes the material check pass (`ps2/src/editmenu.cpp:3955`, `5511`; `editmode.cpp:2055`). L3, or Square outside place mode, moves 3x (`ps2/src/editmode.cpp:1454-1456`).
- Menus: R3 toggles `menu_debug_flag` (`ps2/src/menumain.cpp:1432`). The flag gates the extra menu paths in `menuop.cpp:1944`, `3183` and `menumap.cpp:1571`. On a dungeon's floor list it shows a panel with the selected room's ID, next floors, visit count and floor flags (`ps2/src/dngmenu.cpp:1676`, `3032`): Up and Down pick a line, Left and Right change it, and Triangle adds a visit to every floor of the dungeon and sets its flags to the eight the panel lists, clearing its Geostone-read and seal flags. `tools/input/debug-floor-list.input` drives it from `--jump dungeon:0:1 --fast-load`; by frame 600 the floor list shows the panel with every floor open.
- Events: Start skips a movie (`ps2/src/event_func.cpp:4776`).

## PC gaps

- The keyboard feeds pad 1 only (`tools/kazarov/src/cpp/platform/input.cpp`, `Compose`); L2+Select makes its debug button reads available too.
- `developer_menu` (paddle 2) and `debug_menu` (paddle 1) are bound in `input.cpp` but nothing reads them.
- GyoRace hits the `sgLoopGyoRace` stub (`port/src/gyorace.cpp`).

## Jump replays

See [PC test hooks](PC.md#test-hooks) for launch arguments. With `--fast-load`,
`town:10` shows controllable Max outdoors in Palm Brinks by frame 120;
`dungeon:0:1` shows Underground Channel's floor list by frame 250. Its floor
argument selects the floor in the retail list rather than bypassing the list.
`tools/input/jump-dungeon-floor1.input` confirms entry and skips the first
communication scene: by frame 2100 Max is on floor 1 with the dungeon HUD and
minimap; its frame-2200 movement changes his position by frame 2300.

`event:26010` enters the Rainbow Butterfly Wood boss-event arena by frame 250;
the boss encounter itself still depends on its event logic. `opening` shows
Monica's castle corridor by frame 250, `title` shows the title scene by frame
250, and `menu` shows the retail Ver0.334 developer menu by frame 250. These are
rendered checkpoints, not guarantees that each scene is interactive that early.

At the first dungeon's floor list, `tools/input/save-dungeon-start.input` saves
File 1 on card 1 and shows Save complete by frame 1700. From an ordinary boot
with that save, `tools/input/continue-dungeon-start.input` uses Continue and
returns to the floor list by frame 5000. Always replay against a copied save root.
