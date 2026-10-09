# October 8 night review fixes

## Retail function sizes

The header's `@size` values describe each function's declared retail symbol
size in `ps2/config/pal/main.symbols.txt`, excluding padding before the next
function. 81 padded tags are corrected. Every tagged symbol in this
header is present in that table, and the complete size audit has no mismatch.

The documentation changes preserve `SCES_511.90: OK` and 149/149 objects.
Receipts: `.private/fixes-r1b/receipts/header-sizes-{build,objects}.log`.

## Native switch tables and Step statics

Retail `at_5500` maps main-menu cursors 0 through 6 to
`.L0021CAC4`, `.L0021CC30`, `.L0021CB30`, `.L0021CB30`, `.L0021CB74`,
`.L0021CBA0`, and `.L0021CC04`. Those blocks register a fish name, open
the save menu, assign/delete a saved fish, withdraw entrants, display
tactics, and start a race. Commit `d5d1ca77` restores case labels to that
mapping while keeping the body order 0, 2/3, 4, 5, 6, 1. The prior native
labels placed withdrawal, tactics, race start and save at 1, 4, 5, 6;
the retail assembly table had hidden the differing native table.

The native table now resolves to retail's targets, so `at_5500` is
emitted entirely by C++. Step's `at_4299` and `at_4300` are also native
switch tables. Its existing local `sel_sift_fish` and
`sel_sift_fish_select` declarations naturally supply both BSS objects
and the first object's initialization guard; their separate markers
are unnecessary. All six removals preserve SCES_511.90 and 149/149
canonical objects.

## Signed fish and item fields

Retail Step reads CGameDataUsed::rename_flag with `lb` at 0x2188EC
(item offset 0x05), and BREEDFISH_USED::sex with `lb` at 0x218D80
(fish offset 0x15, item offset 0x25). Other readers already explicitly
interpret these fields as signed bytes. Both declarations now use s8,
and Step reads them directly. Their widths and containing layouts stay
the same. A complete rebuild confirms byte and resolved-relocation
identity for every user, PAL OK and 149/149 canonical objects.

## Aquarium state and result enums

AQUARIUM_MODE names every used Step stage: view (0), commands (1),
fish information (2), removal (3) and its restriction notice (4), rename
selection/guide/restriction (6/7/8), transfer selection (10), viewed-tank
selection (11), destination selection/restriction (12/13), food
selection/position/wait (14/15/16), and outer transition wait (17).
Retail at_4299 sends unused 5 and 9, and transition wait 17, to the
common join; 5 and 9 have no source producers and receive no invented
meaning. Clear uses view; reserved SettingAqua retains its raw zero.
The enclosing MenuAquaKey states 0..9 control opening, active input,
closing/clear, tank fades and name-entry fades as AQUA_MENU_MODE.

AQUA_FISH_RESULT describes the combined producers ColCheck and ParamStep.
Bit 1 means consumption of electric food 0x168, bit 2 is HP death, and
bit 4 is battle damage. Bit 8 means a feeding after the fish already has
flag 0x80, suppressing ordinary stat/growth/timer gains; that flag is set
when the feeding-decremented life counter reaches zero. Bits 0x10 and
0x20 change sex to zero and one via food 0x13B. Step clears each
consumed notice bit and uses their combined 0x30 sex-change mask.

AQUA_EVENT_PHASE separates the actual breeding path 5 -> 1/2/3/4
(effect wait, white fade, CombineFish, fade-in wait, result message)
from electric-food phases 10/11/12/13 (white fade, SettingAqua reload
with saved transforms, fade-in wait, result message). Electric-food
bit 1 starts the second path; it does not request breeding. All live
phase assignments and outer menu state users use these names.

GyoraceMenuMode now includes loading, the main menu, full-registration
notice, race-start fade, and name-entry states. Command cursors map
register/save/assign/delete/withdraw/tactics/start to 0..6. The 0x1E
confirmation prompts `参加取消？` and clears entrants through
GyoraceSubGameInitData; its name is WITHDRAW_CONFIRM. The 0x32
confirmation prompts `競技開始？`, sets end_code 0x11 and fades toward
the race, so its name is START_CONFIRM. The unproduced 0x1F handler
only acknowledges a notice and returns to the main menu; its generic
ACKNOWLEDGE name claims no unverified prompt. The decision sound uses
the existing SYSTEM_SE_DECIDE; cancel or rejected selections use
SYSTEM_SE_CANCEL (value 5).

Enum substitutions preserve the complete PAL image and all 149 objects.

## Plain-array initializer probes

Each candidate is compiled separately through the pinned canonical MWCC/SF
wrapper and compared against the complete unit, including resolved
relocations. A copied-source control matches first, and all accepted
initializers match together. The results are:

| Initializer | Result |
| --- | --- |
| `direction` | Plain array accepted; exact unit. |
| `brightness` | Plain array accepted; exact unit. |
| `bubble-origin` | Plain array accepted; exact unit. |
| `water-ambient` | Plain array accepted; exact unit. |
| `surface-ambient` | Plain array accepted; exact unit. |
| `reflection-x` | Plain array accepted; exact unit. |
| `reflection-z` | Plain array accepted; exact unit. |
| `racer-indices` | Plain array accepted; exact unit. |
| `racer-tactics` | Plain array accepted; exact unit. |

The unused aqua_wall_quad and any unused racer wrappers are removed.
The image-model table uses fishing.hpp's existing FISH_ITEM_ID values;
its terminal -1 remains distinct from FISH_ITEM_NONE (zero).
dirtbl_1242 stores two rows of four turn directions and selects the row
with round.dir; its eight values and row order stay identical.
NextThink's at_1346 aggregate/SDK-array probe already changes five text
bytes, and Thinking's four seed probes already change thirteen text
bytes. Those recorded failures are retained without repetition. The
reserved guarded SettingAqua block is unchanged.

The normal full build preserves SCES_511.90 and all 149 canonical objects.

## Current status and source spacing

The main notes distinguish current native functions from their historical
guarded measurements and link the accepted promotions. Empty section
headings, repeated blank lines and missing function separators are removed
without reflowing the source. The full PAL verifier and 149 object
comparisons remain exact.
