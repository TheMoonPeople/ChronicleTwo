# Character-menu matching constraints

Only MenuCharaChangeInit and MenuCostumeInit remain assembly-backed. Other functions are
native and exact. The constructor controls are documented in [party-change
construction](placement-new-change-natural.md) and [costume
construction](placement-new-costume-natural.md).

## Palette and command loops

EnterDataMenu's CHR_CNG_CLUT_COLOR entries contain four one-byte channels. Retail uses
lbu/sb for RGB, leaves alpha untouched and advances four bytes per color. Initializing
the palette index before the color pointer gives s2/s3; reversing those declarations
changes twenty-two words. `step < CHR_CNG_CLUT_BAND_NUM + 1` matches; the equivalent <=
bound changes two comparison words. Average RGB is divided by three before conversion,
with band scale factors 7.75, 5.625 and 4.6875.

The NPC command loops share one function-scope index with the party/reset loops.
Separate block indices leave eleven words different; sharing it with the palette loop as
well gives sixteen. The pack layout cache is a pointer to the analyzed configuration.
The exact body at 0x2B4AA0 is 0x608 bytes, followed by eight alignment bytes.

## Star and costume drawing

The line-pulse magnitude uses `wave = wave < 0.0f ? -wave : wave`. Statement-form
absolute value changes the merge and conversion schedule in both costume and star
drawing. Costume Draw has declared size 0x8D4 and one evaluate-first row selecting 36.0f
(binary32 0x42100000) for DrawMenuFillBox, expected_matches 1. It materializes X before
`mgScreenHeight - 40.0f - 8.0f`. Folding the two subtractions into 48.0f changes
rounding/code generation and leaves forty-nine words different.

## Temporary scene construction

MenuItemCharaDataLoadEndCheckAfter uses a one-case switch for the mode-2 return and
inline_depth(8). The switch leaves the message-loop back-branch delay slot empty and
sets CMdsListSet's address in the following call slot. An if gives two different words
even at depth five/eight. At default depth the CSceneGameObj/CSceneCharacter/CSceneData
chain emits an extra weak CSceneData constructor instead of calling Initialize directly;
masked word comparison hides that different target. Complete-object checking rejects the
extra piece. Switch variants at depth four, five and eight pass.

## Character-change action and monster selection

KeyChangeMain's HP test retains action = 5 before the test and in its low-HP arm.
Retail's empty branch requires that redundant register store to survive layout and then
disappear. Replacing it with a spilled cancelled/item store leaves one word; changing
the HP comparison or branch form changes over 1400 words. The command-transition table
is a flat forty-entry array indexed by select*8+direction.

KeyStep uses GetMonsterID beside GetActiveChrNo: the class accessor makes MWCC call the
manager before loading its monster halfword; direct field access schedules the load
first. In the level-change path, assigning showInfo after view_monster ends the
progress-product lifetime before the sound call's a0 definition. Assigning showInfo
first leaves twenty-seven words; placing it after the sound call leaves eleven. The
reward pointer precedes the class-level test and its fill has a separate j loop. The
camera and ten-halfword reward views are described in [unit notes](notes.md).

## Page-width scans

KeyChangeMain scans npcMes->page_chars directly and returns width zero for a nonpositive
page count. Both scan sites use ordinary scoped locals. In the second scan the loop
index is declared before max_chars; reversing them exchanges a0/v1 in eight
instructions. The former inline MaxPageChars helper is unnecessary. The direct scans
pass PAL and the complete menuchr object.

## Memory and read-record names

`MenuMemoryAdjust` writes the stack label through `mgCMemory::name`.
`MenuItemChrLoad` constructs the read-record label through
`MENU_BGREAD_INFO2::name`. Both buffers begin at offset zero; the typed
member expressions retain the existing loads, stores and string calls.

The `tbl_992` character/phase table stays flat. The reviewed two-dimensional
form produces three complete-object check problems in `ConvertCharaLoadDataPhase`,
including its address calculations and relocated destinations.
`MenuItemChrLoad` retains `(char *) &info->path` at its two path uses:
replacing it with `info->path` changes six instruction bytes at function
offset `+0xAC` and fails one complete-object check.

## Plain initializer probes

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
resolved references.


## Main-scene load state

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
drafts, uses the field name. The layout stays eight bytes.

## Rejected controls on earlier source forms

These measurements refer to earlier source candidates, rather than current
native scores. All functions discussed here are exact except the two guarded
initializers identified above. They retain useful negative controls without
implying an unresolved mismatch in a promoted function.

| Function / concern | Rejected natural forms and observed consequence |
| --- | --- |
| EnterDataMenu command indexing | Signed/unsigned one-field command records, indexed references and unsigned flat messages leave eleven words. A named array base reaches nine but adds an address setup and shifts the loop. Separate ability/display indices give 71-72 words; level 2 grows the body to 0x704. The accepted shared command/reset index avoids the extra base. |
| EnterDataMenu palette | An indexed-color trial grows an earlier body to 0x620; element pointer/reference variants also grow it. The accepted source uses the documented typed four-channel palette and independent command/cost loops. Alpha is untouched. |
| Costume pulse | mgAbs at initialization or after the pulse gives 390 words; applying it before multiplication gives 47. Declaring coordinates before the merge, reversing the branch or negating through subtraction leaves eighteen. Per-arrow mgAbs grows the body to 0x8EC; level 2 grows it to 0xA54. The accepted ternary magnitude resolves the merge. |
| Costume coordinates | Compute rightX, then leftX, then arrowY. Earlier alternate assignment/declaration orders leave eleven words after the help-box row; chained X stores give 21 or 30. A const conversion table gives 120 and is rejected. Narrowing row coordinates changes integer-to-float conversions and can exceed the extent. |
| Temporary scene | Moving CMdsListSet construction into an explicit CScene initializer or an out-of-class inline definition leaves the two-word delay-slot difference. A copied temporary or reference changes escaping-address behavior; unsigned slot counting adds a third difference. The accepted one-case switch and sufficient inline depth resolve the actual schedule. |
| Star drawing | Low inline depth restores mgRect<short>::Set calls but grows the body to 0x5D4. Direct sparkle indexing, named alpha and center arrays leave the earlier 300-word result. Early angle/radius lifetimes improve only part of that draft; the accepted drawing sequence supersedes it. |
| MenuMemoryDivide | Manager-field indexing worsens the earlier eighteen-word result to 31. Block-count operand order and buffer scope alone do not recover the incoming-manager/buffer register sharing. The exact source is documented in the memory notes. |

MenuMonsterBoxInit depends on trivial CCharaFrameMatching default construction:
empty user-written constructors cause extra member calls before explicit
initialization. CCharacter2 retains its explicit shadow_link.Initialize call.
The shared header supplies the trivial construction, and the current initializer
matches. This is a type/constructor property, not a function-local codegen helper.

MenuMonsterLoadBG acquires its entry in the retail order and reconstructs
SceneCharacter creation and stack selection. The accepted source omits a
manual CObject vtable store: ordinary C++ construction emits it. Character
change load targets retain their analyzed memory ownership and background
read flags; no unverified member loop is introduced to alter constructor class.
