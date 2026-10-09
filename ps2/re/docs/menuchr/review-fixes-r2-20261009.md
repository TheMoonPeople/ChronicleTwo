# October 9 round-two review fixes

## Memory and read-record names (finding 12)

`MenuMemoryAdjust` writes the stack label through `mgCMemory::name`.
`MenuItemChrLoad` constructs the read-record label through
`MENU_BGREAD_INFO2::name`. Both buffers begin at offset zero; the typed
member expressions retain the existing loads, stores and string calls.

The `tbl_992` character/phase table stays flat. The reviewed two-dimensional
form produces three complete-object check problems in `ConvertCharaLoadDataPhase`,
including its address calculations and relocated destinations.
`MenuItemChrLoad` retains `(char *) &info->path` at its two path uses:
replacing it with `info->path` changes six instruction bytes at function
offset `+0xAC` and fails one complete-object check. These are the P15/P15b
negative probes, separate from the matching name-member substitutions.

The typed name-member substitutions pass `SCES_511.90: OK` and all 149
complete-object checks. Neither protected method's guarded block changes.

## Plain initializer probes (finding 22)

All fourteen wrapper types pass independent complete-unit checks as plain
local arrays. Repeated declarations are checked together per type, covering
all twenty-two use sites. Pointer lists retain their null or stack-pointer
entries, phase selectors retain their signed-byte values, integer pairs
retain their zeros, and text buffers retain their exact strings.

| Wrapper | Native local array | Sites / purpose |
| --- | --- | --- |
| `MemoryList` | `mgCMemory *[7]` | 1, character memory partition stacks |
| `SceneCharaList` | `CActionChara *[7]` | 5, scene and menu character targets |
| `LoadTargetList` | `CActionChara *[3]` | 1, background character targets |
| `LoadStackList` | `mgCMemory *[3]` | 1, background character stacks |
| `CharaPathKinds` | `s8[MENU_CHARA_LOAD_MAX]` | 1, character resource-directory selectors |
| `LoadWantedList` | `int[9]` | 1, character read-request flags |
| `LoadTargetList8` | `CActionChara *[8]` | 1, scene character-load targets |
| `RoboCharaList` | `CActionChara *[6]` | 1, ridepod part models |
| `RoboStackList` | `mgCMemory *[6]` | 2, ridepod part memory stacks |
| `DebugLine` | `char[0x80]` | 3, debug display lines |
| `DebugText` | `char[0x200]` | 1, party debug labels |
| `DebugNpcText` | `char[0x100]` | 1, townsperson debug labels |
| `SmallPair` | `int[2]` | 2, cursor steps and item volumes |
| `FileNameBuf` | `char[0x40]` | 1, character-change pack filename |

The three `DebugLine` buffers use `{0}`. The earlier empty-string trial
produced an unmatched eight-byte `at_2232` template; that negative form is
not repeated. The zero-array form preserves the complete unit's data and
resolved references. Wrappers used by protected methods remain unchanged.

The combined plain-array candidate passes all `0x11C9F` allocated bytes and
3,790 resolved relocations. Individual and combined results are saved under
`.private/fixes-r2b/menuchr-probes/`. All fourteen types are accepted; neither
protected method's guarded block changes.

The actual-source full build accepts all fourteen plain-array replacements:
`SCES_511.90: OK`, 149/149 complete objects, 6,787 perfect functions and zero
fuzzy. No function guard or compiler-profile row changes.

## Main-scene load state (round-zero finding 21)

`MENU_LOAD_INFO::update_scene` is the signed byte at offset `+7`, controlling
whether background model loading also updates the main scene's characters
and memory stacks. Byte `+6` remains unidentified.

The existing `decompile.sh`/m2c output for
`MenuItemCharaDataLoadEndCheckAfter` tests the byte at `gp - 0x64D1` before
calling `SetupUnitMan` for `MenuMainScene`; loading mode is at `gp - 0x64D8`,
confirming the seven-byte displacement. `CheckLoadBGMonster` tests the same
byte before assigning/using main-scene stack 5, loading character sound and
retrieving the main-scene character. The character and ridepod loaders use
it when collecting and reloading main-scene model/stack lists.

Bytes `+6` and `+7` are separate signed-char fields, `unk_6` and
`update_scene`; every access, including the guarded menuchr and inventmn
drafts, uses the field name. The layout stays eight bytes, and the full build
gives `SCES_511.90: OK` with 149/149 complete objects.

## Source spacing and current documentation (findings 8 and 17)

Repeated empty lines are reduced to one; function definitions have blank
separators, including the outer boundaries after the protected methods.
The empty `.sdata` heading is removed. Both guarded method blocks and all
of `night-20261008.md` remain unchanged. Older score assessments are marked
historical, current native matches are named accurately, and the migration
notes distinguish Italian label rows, weakness markup and badge-table
consumers.

The final spacing source passes `SCES_511.90: OK` and 149/149 complete
objects. The protected-block comparison and the unchanged night-note file
both pass, and no function gap changes.
