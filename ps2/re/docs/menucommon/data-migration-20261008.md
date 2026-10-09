# menucommon data migration (October 8, 2026)

Baseline: `63f7a9e5`, 186 `INCLUDE_RODATA` markers, 22 `INCLUDE_BSS`
markers, 0/3,816 matched initialized data bytes. All 129 functions are native
and exact. This work preserves the existing public header declarations.

## Uninitialized menu state

All 22 reservations are native definitions. The three public globals retain
their header types: `MenuSePlayUsedFlag` is `u8`, `MenuSpiStack` is
`mgCMemory *`, and `MenuCommandAnalyzeInfo` is `MENU_COMMAND_ANALYZE_INFO`
(size 0x68). The other definitions have internal linkage, matching retail.

| State | Type and purpose |
| --- | --- |
| `SndPortVol_Ob`, `SndPortVol_Base`, `SndPortVol_Event`, `SndPortVol_Env` | `float`, saved sound-port/environment volumes |
| `SndPortCheck_EventPort` | `int`, whether to restore event-port volume |
| `MenuTexPosNo`, `MenuTexPosNo_local` | `u16`, first texture slot and block offset |
| `menu_analyze_texblock` | `short`, current texture block |
| `Menu_Target_No`, `Menu_Target_No_local` | `u16`, first miscellaneous-information slot and block offset |
| `menu_formPt` | `CMenuPosDataForm *`, current form |
| `menu_form_part` | `MENUFORMPARTS_TYPE *`, current part |
| `menu_parts_effect_ptr` | `MENU_PARTS_EFFECT_STRUCT1 *`, next effect entry |
| `menu_analyze_formno`, `menu_analyze_formno_offset` | `short`, selected form and form-index offset |
| `menu_form_partsno` | `int`, next part index |
| `menu_spi_form_action_info` | `MENU_FORM_ACTION *`, next action entry |
| `SpiMenuExeCommandFlag` | `u8`, selected command-block execution flag |
| `MenuSpiTextureName` | `char[0x20]`, name copied by `_MENU_TEXNAME` and consumed by `_MENU_TEXDATA` |

`MenuSpiTextureName` is a character buffer, so its `strcpy` and `mgCopyString`
uses need no cast. The scalar/object sizes come from the existing documented
layout and the retail symbols; reservation extents include alignment gaps.
The existing postprocessor supplies those gaps without expanding the C++
types. In particular, the flag has size 1 rather than its four-byte reservation,
and the command object has size 0x68 rather than its 0x70 reservation.

Validation: `.private/dataB/receipts/menucommon-bss-final-build.log` records
`SCES_511.90: OK`; `menucommon-bss-final-objects.log` records 149/149 objects.
`menucommon-bss-changed-objects.json` lists only `menucommon.cpp.o`; the other
148 file hashes equal the warm-built baseline. Refreshed objdiff keeps all
129 functions exact. The marker counts become 186/0; initialized-data coverage
remains 0/3,816 because BSS does not contribute to that measurement.

## Item order, file paths, and layout keywords

`sort_table` is a writable `signed char[0x24]`: the sorting pass rewrites its
ranks, so it is not const. Its initializer preserves the empty category's
last-place rank and the remaining retail rank bytes. `sort_top_type` is a
`short` initialized to 1. `langdirpathTable_1161` is an eight-pointer table,
including the repeated English directory and final null. `LoadFileMenu`
uses the inline `"menu/"` prefix. `mes_cord_conv_1193` is the 16-pair
signed-byte hexadecimal digit/nibble table documented by `ConvertFontCode`.

The existing `MENU_SPI_ANALYZE_STRUCT1` layout supplies the form drawing,
part drawing, frame, item-icon, filled-box, and animation-effect tables.
Their values use `MENUFORM_DTYPE`, `MENUFORMPARTS_DTYPE`, and
`MENU_PARTS_EFFECT_TYPE`. Japanese keyword bytes in `tbl_1994` are preserved
with three-digit octal string escapes. All keywords are inline in the typed
tables; their anonymous string markers are removed. A null-name row is the
logical terminator. Zero words after the declared table size are piece
padding, not extra entries. `tbl_1759` is a six-pointer movement-keyword
array; its position maps to `MENUFORM_MTYPE` by subtracting one.

`_MENU_FILLBOX` already declares its four-byte local effect-count array as
`{1, 2, 2, 4}`. Removing the corresponding `at_2092` marker retains the native
initializer. The keyword lookup now reads `table[i].value` directly instead
of reconstructing the entry address with an integer cast.

Each table was built and checked separately, with receipts named
`menucommon-sort-table`, `menucommon-sort-top`, `menucommon-file-paths`,
`menucommon-font-codes`, `menucommon-form-drawing-table`,
`menucommon-part-drawing-table`, `menucommon-frame-drawing-table`,
`menucommon-icon-drawing-table`, `menucommon-box-drawing-table`,
`menucommon-part-effect-table`, `menucommon-movement-table`,
`menucommon-box-effect-counts`, and `menucommon-keyword-lookup` under
`.private/dataB/receipts/`. Every full object check passes 149/149 and PAL is
OK; only the owned unit's object file changes from baseline.

After the layout checkpoint: 119 `INCLUDE_RODATA`, zero `INCLUDE_BSS`, and
8/3,816 matched data bytes in the refreshed report. That report has partially
populated data sections while the remaining dispatch/message tables still
come from assembly; marker removal and the canonical object check establish
which definitions are native.

## Script dispatch and command keywords

Both dispatch tables are native `SPI_TAG_PARAM` arrays: 60 entries for
`menu_analyze_tag` (59 tags and a null terminator), and 32 for
`menu_execommand_analyze_tag` (31 tags and a null terminator). Every function
pointer names its actual C++ handler. Tag aliases such as `TD`/`TEXDATA`,
`NRL`/`NORMAL`, and the abbreviated part-visibility commands retain the retail
handler identity. The shared `INIT_DRAWLIST` and `RESET_TEXINFO` strings still
serve their distinct layout and command handlers.

`tbl_2369` contains all twenty `CDC2Mes::MsgPreset` script presets and its
terminator. The keyword/value pairs define the new `MenuScriptMessagePreset`
enum in the owning header; the existing function declarations remain unchanged.
The menucls1 notes and native `MsgPreset` implementation already document
these values. `tbl_2422` uses the existing `FontFuchi` enum for `default`,
`none`, and `ol2`; the shared `default` keyword points to the same literal as
the message-preset table. `tbl_2516` uses `MenuScriptSound` for `OK` and
`CANCEL`. The two diagnostic strings are inline at their `printf` calls.
The command message buffers use their typed array members directly, and
message-window member access uses the existing derived-class pointer.

Definitions follow retail table order, with forward declarations for the
handlers needed by the two dispatch arrays. No header declaration changes
linkage or layout. No generated directory or toolchain file is edited.

Final menucommon state: zero `INCLUDE_RODATA`, zero `INCLUDE_BSS`, and no
data `extern` declarations in the source. All 129 functions remain exact.
The normal complete-object check passes 149/149, PAL is OK, and all 148 other
object file hashes equal baseline. Receipts:
`.private/dataB/receipts/menucommon-native-data-order-*` and
`menucommon-command-buffer-access-*`.

The refreshed standard report gives **8/3,816 matched_data** despite all data
being native. `ps2/cmake/Objdiff.cmake` compiles its source-only base directly
through the compiler, without the section/literal naming and piece-padding
postprocessor used for linked objects. Its remaining data-section differences
therefore include symbol identities, order and alignment extents rather than
assembly-backed definitions. To check the stronger claim independently,
the compiler-only `objdiff/base/menucommon.cpp.o` was copied privately, passed
through the existing postprocessor/fixup, and checked against retail. This
source-only object passes the whole unit (0x5558 allocated bytes, 1,021
relocations), with no assembly markers or transplants. Receipt:
`.private/dataB/receipts/menucommon-native-only-object.log`. The quoted metric
is the unmodified standard report; no tooling change is included.
