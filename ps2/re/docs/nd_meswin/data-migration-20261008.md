# Message-window data migration

## Baseline

At `ab376093`, all 98 functions match. Baseline markers are 71 RODATA / 8
BSS, and refreshed objdiff matched data is 20/9,068 bytes. The warm build
reports PAL OK and all 149 objects pass. `DrawMesWin` retains its complete
source body and the existing four control-context scheduling rows.

## Message and caption storage

The public definitions use the established header types: `s32` drawing offset
and caption counters, `short NameRegistTbl[8][11]`, two 20-element frame arrays,
and `char MovieCCStr[20][350]`. `MovieCCFont` remains the existing native
`CFont`. The caption strings own 7,000 declared bytes; their eight-byte zero
alignment tail is supplied by the existing postprocessor. No header or caller
changes are required.

`nd-movie-storage-{build,objects,metrics}.log` under `.private/dataC-r1/`
accepts this step: PAL OK, 149/149 objects, no unowned hash changes. Markers
become 71/0.

## Outline ratios and frame margins

`p` is a native 16-by-2 float table; `waku_data` is a native nine-by-four
`s32` margin table. Their public declarations and every consumer remain
unchanged. The outline's third X coordinate is exactly binary32
`0x3DCCCCCC` (`0.099999994f`), one ULP below `0.1f`; that exact coordinate is
preserved. All other ratios use round-tripping decimal literals.

The independently rerun receipts `nd-outline-isolated` and
`nd-frame-margins-isolated` verify one table at a time. Each records PAL OK,
149/149 passing objects and unowned hashes unchanged. Markers become 69/0.

## Anchor and icon templates

`GetPos_AbsPosSet` initializes the existing 19-point aggregate directly,
replacing its anonymous-table extern and marker. The real 0x98-byte template
retains its eight-byte alignment tail. `data_4206` is a native local
10-element `RECT` table for the advance-button animations. Its dimensions,
repeated second/fourth frame and all ten rows retain the exact retail values.

The existing `RECT` initializers in `DrawEquipment`, `DrawCross`,
`DrawRightDelta` and `DrawDigit` already emit `at_4057`, `at_4100`, `at_4143`
and `at_4185`. Each redundant marker is removed without editing those bodies.

Separate receipts are `nd-anchor-template`, `nd-advance-button-table`, and
`nd-at_<number>-template` for each of those four rectangle templates. Each
passes PAL, all 149 objects, and the unowned hash comparison. Markers become
63/0. No dummy storage, cast, vector helper or code change is required to
emit these aggregate data objects.

## Message strings

The texture selector, Unicode prefix, decimal formats, full-width digits,
message tags and capacity diagnostics are inline at their existing uses.
Shift-JIS strings use fixed-width octal escapes, preserving their exact bytes
without source-file encoding dependence. Shared formats and tags remain pooled;
a marker disappears only after its final external reference is replaced.

Each function has separate full-build, object and unowned-hash receipts:

| Function | Receipt prefix |
| --- | --- |
| `set2DSprite` | `nd-sprite-texture-string` |
| `GetStrWidth(char *)` | `nd-width-unicode-prefix` |
| `MakeMesWinTbl_value(int *, int *)` | `nd-value-strings` |
| `MakeMesWinTbl_value(int, int *, int *)` | `nd-indexed-value-strings` |
| `MakeMesWinTbl_str(char *, int *, int *)` | `nd-text-tags` |
| `MakeMesWinTbl_item` | `nd-item-diagnostic` |
| `SetMesWinTbl` | `nd-table-capacity-string` |
| `NeedMesWinWH(int)` | `nd-system-size-strings` |
| `NeedMesWinWH(char *)` | `nd-text-size-strings` |

Every step passes PAL and all 149 objects, with unowned object hashes unchanged.
Markers become 10/0. No placement expression or `DrawMesWin` body is edited.

## Caption strings

`MyStrCpyLineFeed` uses the literal `"\\n"` directly, and `MovieCCAnalyze`
compares its four `_STA `, `_CLR `, `_STR ` and `_END` tags inline. The
redundant literal cast disappears without changing parser code. Separate
receipts `nd-linefeed-string` and `nd-caption-tag-strings` pass PAL, all
149 objects and unowned hashes. Only the five switch-table markers remain.

## Native switches and complete data migration

Each existing native switch emits its branch table itself:

| Table | Owning function |
| --- | --- |
| `at_1724` | `Preset` |
| `at_1758` | `SetWindowMode` |
| `at_2900` | `MakeMesWinTbl(int)` |
| `at_4276` | `DrawPushButton` |
| `at_4472` | `DrawMesWin` |

Each marker removal passes its own `nd-at_<number>-switch` build, object,
and hash receipt. All 149 objects pass; PAL remains OK and unowned hashes
are unchanged. `nd-drawmeswin-source.log` independently verifies that the
complete `DrawMesWin` source body is unchanged from `ab376093`.

Final markers are **0 RODATA / 0 BSS**, versus **71 / 8**. All 98 functions
remain matched; none is promoted. Refreshed source-only matched data stays
**20/9,068**. That report does not normalize source data identities, ordering
and piece padding as the linked-object stage does; the canonical complete
object verifies every migrated byte and resolved relocation.

## Further source cleanup

The remaining integer write through `&fade` becomes `fade = 0.0f`. The
primitive union retains only its real `mgCDrawPrim` member; its redundant
128-byte backing array is removed. `nd-typed-fade-reset` and
`nd-primitive-storage` receipts pass PAL, all 149 objects, and unowned hashes.

The inherited digit helper is retained after natural cleanup probes
fail to match. Removing `Ident` from `DrawDigit` preserves its 0x150-byte size
but changes integer scheduling: the direct expression differs by 15 masked
words; a meaningful row local with compound assignment differs by 13. The
plain compound expression also fails. Receipts are `nd-digit-expression`,
`nd-digit-compound-expression`, `nd-digit-row-expression`, and
`nd-digit-row-diff.log`. No new helper is introduced; the existing exact body
is restored. Replacing `MyStrCpyLineFeed`'s label/backward branch with `while`
also changes 21 masked words (`nd-linefeed-loop-build.log` and its word-diff
receipt). A natural infinite `for` loop with an explicit newline break instead
preserves the complete 0x80-byte parser. The accepted
`nd-linefeed-break-loop` receipts pass PAL, all 149 objects and unowned hashes;
the parser's `goto` is removed. These probes do not promote any function.
