# Town-loop data migration, October 8 night, round 4

Baseline: `9eb8f660`, pinned SF image, canonical flags and unchanged profile.
The scene, camera, menu, character and Georama layouts already documented
in notes.md supply the data types. EditInit, EditLoop and their drafts remain
unchanged. The CameraCtrlParam assignment and CActionChara constructor
assembly fallbacks also remain unchanged.

## Native data

SetDataPacket's two diagnostics already use inline literals. EditStep,
EditDataSave and EditMapJump receive their inline formats, directory names
and map names at the original call sites. The rendering diagnostics already
use native literals. Shift-JIS bytes use hexadecimal escapes; no literal
wrapper or standalone artificial string object is added.

The existing active local arrays supply the draw material, load positions,
zero load rotation and blur-range templates. The blur ranges are pairs of
floats (1000/2000 and 3000/4000), rather than doubles. The draw's persistent
flag and initialization byte already have native storage. Their markers are
checked independently from the literal and array groups.

MenuInfo becomes a typed pointer initialized to the existing MenuArg, and
DataPktMode retains its -1 allocation-mode sentinel. Town frames, cameras,
character pointers, scene/packet pointers, state counters and buffer sizes
become documented typed definitions under their retail names. Private
symbols remain static; read_buffer_end retains its published header type.
MenuDataSize is the loaded menu file's byte count, while FixCharaBuffSize
records allocator quadwords. beforeAnalyze is the existing 16-int snapshot.
The already native class-valued globals and their constructors are preserved.

## Assembly-owned markers

The following anonymous constants remain reachable under their retail
symbols because their only source callers are still guarded. Activating
those callers, adding an emission helper or renaming the constants is outside
this lane. This covers every retained rodata marker:

| Consumer | Retained markers |
|---|---|
| EditInit material and image-path arrays | `at_1045`, `at_1053` |
| EditInit diagnostics, paths and object names | `at_1395__2`, `at_1396`, `at_1397`, `at_1398__2`, `at_1399`, `at_1400`, `at_1401`, `at_1402`, `at_1403`, `at_1404`, `at_1405`, `at_1406`, `at_1407`, `at_1408__2`, `at_1409__2`, `at_1410__2`, `at_1411__2`, `at_1412__2`, `at_1413__2`, `at_1414__2`, `at_1415__2`, `at_1416__2`, `at_1417__2`, `at_1418__2`, `at_1419`, `at_1420`, `at_1421`, `at_1422` |
| EditLoop camera vector | `at_1528` |
| EditLoop diagnostics and object names | `at_2125`, `at_2126`, `at_2127`, `at_2128`, `at_2129`, `at_2130`, `at_2131`, `at_2132`, `at_2133`, `at_2134`, `at_2136` |

The EditInit zero-vector template `at_1077` likewise retains its BSS marker.
It is referenced by the active assembly and is not emitted by an active
native initializer at its call site.

The guarded EditLoop's persistent counters and guards are actual mutable
state rather than anonymous initializer templates. Typed file-local
definitions keep this storage reachable under the existing retail symbols,
without changing the assembly body or the draft's local declarations.
Retail ELF metadata gives each counter four bytes and each initialization
guard one byte; the original four-byte reservations include alignment, not
extra source fields. Each symbol is checked independently. These symbols
are migrated:

| Persistent state | Native storage symbols |
|---|---|
| Town time progression | `time_step_1481`, `init_1482` |
| Displayed time progression | `show_time_step_1484`, `init_1485` |
| Previous control mode | `old_cm_1772` |
| Rain state | `rain_flag_1849`, `init_1850` |
| Battle-start counter | `start_bt_cnt_1865`, `init_1866` |
| Encounter state | `encount_flag_1868`, `init_1869` |
| Encounter display counter | `show_encount_cnt_1871`, `init_1872` |
| Next encounter selection | `next_encount_1874`, `init_1875` |

The static-constructor zero template `at_949` is already emitted by the
native class-valued globals and is removed without changing their
construction. The active EditDataLoad rotation initializer likewise replaces
`at_3041`, and its unused extern declaration is removed. Only `at_1077`
retains a BSS marker; all other BSS markers have typed native storage or an
existing active compiler-generated template.

No header, compiler selector, constructor helper, vtable or data-padding
object is introduced. All per-symbol and per-function literal receipts are
under `.private/dataB-r4/editloop-*`.

## Measurement and validation

Markers (RODATA / BSS): **70 / 56 → 42 / 1**.
Fresh objdiff `matched_data / total_data`: **4 / 18832 → 236 / 18832**.

`editloop-final-build.log` prints `SCES_511.90: OK`; `editloop-final-objects.log`
passes 149/149 objects. These receipts, the incremental checks, baseline
measurements and object-hash audit are under `.private/dataB-r4/`.
All objects outside the seven owned units retain their baseline file hashes.
No function is promoted and no assembly fallback or guarded function body changes.
