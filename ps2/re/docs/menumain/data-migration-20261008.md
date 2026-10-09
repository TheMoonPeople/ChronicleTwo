# menumain data migration (2026-10-08)

Baseline `e1471bff`: **82 INCLUDE_RODATA / 54 INCLUDE_BSS**, with
**4 / 3490 matched_data** after the standard objdiff/progress refresh.
The unit retains 52 native functions and one guarded `MenuMainInit`.

## Named menu state

Forty-nine reservations are native definitions using the existing documented
header and consumer types. Public globals keep external linkage; retail-local
state keeps internal linkage. The saved camera vectors retain four float
components. `MENU_INIT_ARG`, `CMenuItemUse` and `CMenuInter` own 0x98, 0x1C and
0x18 bytes; their zero tails to 0xA0, 0x20 and 0x20 are alignment supplied by
the existing data postprocessor, rather than extra members. One-byte flags and
two-byte map/topic values likewise retain their actual declared sizes.
The player-data refresh counter and initialization flag are signed bytes,
with the existing 25-frame refresh behavior unchanged.

The exact `MenuArg`, `MenuItemUse` and saved-vector symbols referenced by the
guarded initializer remain defined and reachable. All guarded source and both
SF-calibrated function bodies compare equal to the baseline text. Full PAL and
149-object checks pass; the only changed object hashes are the two owned units
worked so far. Receipts: `.private/dataD-r1/menumain-state-{build,objects,progress,metrics}.log`.

## Inline caller strings

Thirty-five anonymous strings are inline at their matched uses: menu texture
names, configuration paths and diagnostics, pack members, area/time board
labels, top-menu forms and messages, active-item icon atlases and debug title.
Original Shift-JIS bytes use hexadecimal escapes. Both SF-selected bodies
already have their inline literals and remain textually unchanged.
Each function group passes PAL and 149/149 objects. Receipts are
`menumain-{image,next,config,message,img,poscfg,board,intern,base,inter-message,
inter-key,item,icon,debug}` under `.private/dataD-r1/`; the refreshed checkpoint
is `menumain-strings`.

## Dispatch, resource and display tables

The key and draw tables contain `MENU_MODE_NUM` (thirty) actual callback
pointers, including the unused null slot. Their eight-byte piece tails are
alignment. The owning `inventmn.hpp` declarations replace the local void-return
prototypes for `GetPhotoNameStr` and `MenuInventInit`; both actually return int.
Their callers discard those results, so every caller remains byte-identical.
The destination rows use existing `MenuModeID` values and a negative terminator.

Topic foreground/shadow arrays are mutable four-by-four float tables; the
shadow alpha is rewritten by the unchanged SF-selected drawing function.
The seven-by-three topic messages retain all language bytes, including the
literal French `[UNI00ea]` sequence. The seventeen-pointer message-resource
table shares its empty literal with the topic table. `monster_table` contains
eleven name/message pairs, including its final zero pair. Configuration packs,
board actions and icon-sheet names are inline pointer initializers; equipment
copy counts remain two integers. The primitive pointer names its existing
builder, menu result/texture-block defaults are -1, and topic opacity starts
at 128. Existing constructor-bearing objects retain their initializer order
and now have documented local binding.

Focused table/scalar receipts are `menumain-{keytable-fixed,drawtable,modes,
menu_maintopic_colortbl,menu_maintopic_colortbl_shadow,topic_tbl_1777,
filetbl_2141,monster_table,menu_main_cfgname_1620,acttbl_1682,fname_1858,
loopnumtbl_2360,MenuPrim,MenuPrevEndCode,MenuBGTextureBlock,
MenuItemIconTextureBlock,MenuTopicAlpha}` under `.private/dataD-r1/`.
The rejected first key-table compile only exposed missing forward declarations
and the two conflicting return-type declarations; the corrected table passes.

## Local aggregates

The page destinations are a local `MenuKeyPageTable` aggregate at the original
copy point. The area-board name pair, position and nine language widths are
initialized in their original branch and declaration order; initializing them
at function entry would move their copies before the null-board check.
The three opening points are `{50, 40}`, `{-260, 0}` and `{20, 40}`; the
selection cursor starts at `{0, 0}`. Existing native `InitEnd` position and
equipment-item arrays supply `at_1976` and `at_2351`. All five BSS templates
and all associated initialized templates are absent as markers.
Every aggregate group passes the full PAL and object checks. Receipts:
`menumain-{generated-bss,pages-local,board-local,opening-local,cursor-local}`.

## Camera-copy blocker and retained markers

Native SDK vector definitions plus two natural `memcpy` calls preserve the
camera values but outline the copies. `MenuCamInit` grows from retail 0x44 to
0x6C and the complete object rejects it (eleven reported problems, including
both new call relocations). That experiment is reverted; no helper, type-pun
or toolchain change is introduced. Receipts: `menumain-camera-{build,objects}`
and the successful `menumain-camera-restored` validation.

| Marker | Reason |
| --- | --- |
| `light_1062__DATA` | Lighting directions referenced by guarded `MenuMainInit` through the exact retail symbol. |
| `lightcolor_1063__DATA` | Lighting colors referenced by that guarded initializer through the exact retail symbol. |
| `at_1440__2__DATA` | Switch table for the guarded initializer; its body remains assembly. |
| `menu_basedgRef__DATA` | Four-float camera target; natural copying currently outlines and fails the exact native camera function. |
| `menu_basedgCamPos__DATA` | Four-float camera position; same measured copy blocker. |

Final canonical state: **5 INCLUDE_RODATA / 0 INCLUDE_BSS**, from **82 / 54**;
**1392 / 3490 matched_data**, from **4 / 3490**. The unmodified progress metric
is quoted; retained section pieces prevent credit for some other native data.
All 52 native functions remain exact, no function is promoted, and guarded/SF
source is unchanged. PAL is OK and 149/149 objects pass. Final receipts:
`.private/dataD-r1/menumain-final-{build,objects,progress,metrics}.log`.

## Storage definition order

The six constructor-bearing objects precede their first use, eliminating
external declarations before file-local definitions. Their definition and
constructor order remains MenuMainStack, MenuMainStack_Next, MenuPrimFix,
MenuMainTextureReadBuf, MenuSoundBuffer and TopicFont. The primitive pointer
is initialized after its builder's declaration. The generated initializer and
every caller remain exact, with unchanged guarded/SF source. Receipt:
`.private/dataD-r1/menumain-storage-order-{build,objects}.log`.
