# October 9 round-two review fixes

## Native local statics (finding 22)

Each of the ten hand-written initialization guards is independently replaced
by a natural local static at the guard's original position. The declared
type, initial value and state accesses remain the same. MWCC supplies the
initialization latch and the current object postprocessor binds that local
state to its retail storage.

| State | Type / initializer | Consumer |
| --- | --- | --- |
| `cmd_counter` | `s8`, `0` | `CBaseMenuClass::MenuItemCommandSelect` |
| `sndflag` | `s8`, `0` | `CBaseMenuClass::IsSpectolFusion` |
| `count_time` | `s8`, `0` | `MenuFormUpdataAttachInfo` |
| `checkmoveFlag` | `s8`, `0` | `CMenuItemInfo::CalcTex` |
| `fusion_blinkcnt` | `s8`, `0` | `CMenuItemInfo::PushKey` |
| `diffent_weapon_dispflag` | `s8`, `0` | `CMenuItemInfo::PushKey` |
| `counter` | `float`, `0.0f` | `MenuPosFormValueSetCharaRobo` |
| `count` | `s8`, `0` | `MenuWeaponStatusInfoFormSet` |
| `old_viewmode` | `int`, `0` | `MenuItemKey` |
| `old_chrid` | `int`, `0` | `MenuItemKey` |

All ten independent complete-unit checks pass. The matching build still
selects the existing assembly gaps for the four constructor-dependent
functions; their draft-only state is outside this ten-site cleanup.

## Key and swap-result arrays (finding 22)

`MenuListKeyCheck` initializes its two-by-two direction-key array directly
with the named key bits. Its separate two-by-two wrap array starts at zero;
the existing count-minus-one assignments remain after initialization.
The `KeyPairTable` wrapper and both manually named templates are unnecessary.
Both plain-array substitutions independently pass the complete-unit check.

`MenuDataSwap` uses a two-byte `s8` result array initialized with
`MENU_SWAP_RESULT_FAILED` and `MENU_SWAP_RESULT_DESTINATION_OCCUPIED`.
The source-result lookup precedes array initialization, then replaces the
first entry before the destination-result lookup. This order reproduces
retail's loads and stores. The constant plain initializer independently
passes, so `MenuSwapResultTable` and its hand-defined template are unnecessary.

The combined ten-static and three-array candidate passes all `0x1B0B0`
allocated bytes and 5,996 resolved relocations. Individual and combined
compiler/checker results are saved under
`.private/fixes-r2b/menusys-probes/`; all thirteen substitutions are accepted.

The actual-source full build verifies `SCES_511.90: OK` and 149/149 complete
objects with the unchanged compiler profile. No function guard changes.

## MenuEffect declaration extent (finding 30)

The definition is an eight-byte, two-pointer `CMenuEffect *[2]` array. The
header's compatible incomplete-array declaration stays `MenuEffect[]`.
Completing that declaration as `[2]` fails the full build: `inventmn` reports
458 complete-object problems, including short extents for `IsMakeObject`,
`CalcTex` and `MenuInventDraw`, an unidentified replacement for `at_3317` in
`.sbss`, and unresolved relocated destinations. The other 148 units pass,
including all three owned menu units. The PAL verifier also fails and reports
a BSS end 0x40 bytes beyond retail.

The bound is the only changed input to the inventmn translation unit; the
owned source changes in that probe are whitespace. No inventmn source or
compiler-profile change is made. The original incomplete declaration is
retained rather than accepting different object bytes. Negative receipts
are `final-source-cleanup-{build,objects}.log` under the lane receipt directory;
the failed inventmn object and header are saved in the private bound probe.

## Source spacing and current documentation (findings 8 and 17)

Repeated empty lines are reduced to one, and function definitions have blank
separators, including boundaries after preprocessor guards. Initializer
layout is preserved. Older matching records are explicitly historical;
current swap-result arrays and native matching status are linked to their
accepted results.

Restoring `MenuEffect[]` with the final spacing edits verifies
`SCES_511.90: OK` and 149/149 complete objects. Coverage remains 6,787
perfect functions and zero fuzzy; the declaration-extent regression is
isolated and the original matching declaration is retained.
