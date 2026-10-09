# October 8 data migration

Baseline: `7c7edc2f`; MWCC 3.0/Satan's Fiddle through
`chronicletwo_dev:sf-63f7a9e`. Warm PAL OK and 149/149 objects.
Initial markers: 261 RODATA / 51 BSS; matched data: 4 / 18656 bytes.
Migration checkpoint markers: 72 / 5; matched data: 132 / 18656 bytes.
The review cleanup below removes six more RODATA markers and one BSS marker.
The original migration preserves headers, guarded bodies, function
selections and profile rows. Review cleanup below updates native data
and guarded literal references; function selections and profile rows stay
unchanged.

## Native storage and local initializers

Thirty-four named objects have documented native types and retail LOCAL
linkage: menu pointers, photo/recipe parsing state, notebook arrays,
command and drawing state, effects, album slots and work buffers.
The eight-byte recipe manager has no constructor. The existing native
constructor objects and their initialization order remain in place.

Object widths exclude reservation gaps. CMenuInventPt and
InventSubDataReadBGInfo are four bytes each; temp_1728 is 33 characters;
the notebook has 512 names and 512 signed-halfword IDs; the photo-name
buffer has 0x2480 bytes. Native byte/halfword flags keep their widths.

Five existing zero templates, six switch tables and the CMenuInvent
vtable already emit from native C++. Sixteen additional local aggregates
now use ordinary initializers: recipe flags, message types, grade rows
and steps, cursor/gift coordinates, item board positions and names,
blank name, card colour, grid codes and creation/exit arguments.
The cursor seed is four integers `{10, 10, 0, 0}`. The record-message call
uses the typed array member instead of casting the whole aggregate.

`invent-state`, nine `invent-emitted-<step>` and eleven successful
`invent-templates-<step>` receipt pairs each verify PAL OK and 149/149.
Two confirmation-name templates remain: splitting their case scopes
changes 15 text bytes from IsAskExtend's prologue; value initialization
also fails matching. Both probes are reverted, without adding helpers.

## Tables and literals

Twenty-eight named initialized tables are native: prefixes/form names,
cursor/confirmation/navigation tables, four actual two-integer grid
dimension arrays, scoop records, photo commands, colours, allocation
choices, model lighting, sound timings, Japanese name lengths, three
script-handler tables, invention asset/sound/name pointer tables and
localized newcomer labels. The 53 mutable scoop rows retain their unusual
order and ID/index gaps, including scoop 1015 last. Existing enums name
confirmation and command IDs and known next-mode values.

The seven-pointer Tb_2819 table has 28 declared bytes and three real
alignment bytes before the separately referenced D_003532DF byte. Its
natural definition and literal targets match; existing bounded padding
handles the three-byte gap. The separate byte remains intact. NewComer
contains seven pointers, with entries one and six sharing one literal.

119 function string markers now come from native literals at all uses,
including three shared literals whose frozen references remain valid.
Shift-JIS text uses hex escapes. Constructor icon strings remain marked:
inlining them leaves at_5011/5012/5013 undefined for frozen MenuInventInit.
The failed raw object and canonical error receipt are preserved privately.
No artificial string use or compiler selector is added.

## Projected-name collision and retained anchor

The initially rejected pointer tables are now native. Their failure came
from an unrelated temporary compiler name: native PushKey switch `@3509`
projects to `at_3509` before becoming its real retail identity `at_5560`.
That temporary name blocks naming the eight-byte gift BSS template. The
canonical checker then leaves the entire mismatched section run without
addresses, causing hundreds of unresolved targets.

Keeping only `INCLUDE_BSS(at_3509, 0x8)` anchors the gift while preserving
its natural local initializer. Handler types/placement and function code
need no changes. The saved raw ELF has a 48-byte RODATA `@3509`, distinct
from the gift; read-only in-memory removal/renaming confirms the cause.
No build script is edited. This marker can be revisited after the name
collision is resolved in tooling.

## Validation

All accepted steps pass the full PAL verifier and all 149 canonical
objects. Receipts are under `.private/nminv-r2/`: twelve successful
`invent-table-<step>`, seven successful `invent-more-<step>`,
`invent-pointer-anchor`, seven `invent-anchored-<step>`, three successful
`invent-shared-<step>`, and `invent-language-prefixes`, each with
`-build.log` and `-objects.log`. The language-prefix receipt verifies the
complete current source after all reverts. Matched-data credits complete
aggregate sections; retained pieces keep the metric below the native
objects actually migrated.

## Retained markers

Each row names one remaining marker; marker suffix `__DATA` is omitted.

| Symbol | Reason |
|---|---|
| `D_003532DF` | Separately referenced zero padding byte at the table alignment boundary; frozen consumer must remain unchanged. |
| `at_2913` | Frozen `IsCreateObject__11CMenuInventFii`: initializer/literal/switch cannot be emitted by editing its body. |
| `at_2244` | Frozen `LoadCharaCheck__11CMenuInventFv`: initializer/literal/switch cannot be emitted by editing its body. |
| `at_2245` | Frozen `LoadCharaCheck__11CMenuInventFv`: initializer/literal/switch cannot be emitted by editing its body. |
| `at_2247` | Frozen `LoadCharaCheck__11CMenuInventFv`: initializer/literal/switch cannot be emitted by editing its body. |
| `at_2248` | Frozen `LoadCharaCheck__11CMenuInventFv`: initializer/literal/switch cannot be emitted by editing its body. |
| `at_2249` | Frozen `LoadCharaCheck__11CMenuInventFv`, `IsCreateObject__11CMenuInventFii`: initializer/literal/switch cannot be emitted by editing its body. |
| `at_2250` | Frozen `LoadCharaCheck__11CMenuInventFv`: initializer/literal/switch cannot be emitted by editing its body. |
| `at_2251` | Frozen `LoadCharaCheck__11CMenuInventFv`: initializer/literal/switch cannot be emitted by editing its body. |
| `at_2252` | Frozen `LoadCharaCheck__11CMenuInventFv`: initializer/literal/switch cannot be emitted by editing its body. |
| `at_3113` | Frozen `IsCreateObject__11CMenuInventFii`: initializer/literal/switch cannot be emitted by editing its body. |
| `at_3114` | Frozen `IsCreateObject__11CMenuInventFii`: initializer/literal/switch cannot be emitted by editing its body. |
| `at_3115` | Frozen `IsCreateObject__11CMenuInventFii`: initializer/literal/switch cannot be emitted by editing its body. |
| `at_3116` | Frozen `IsCreateObject__11CMenuInventFii`: initializer/literal/switch cannot be emitted by editing its body. |
| `at_3117` | Frozen `IsCreateObject__11CMenuInventFii`: initializer/literal/switch cannot be emitted by editing its body. |
| `at_3118` | Frozen `IsCreateObject__11CMenuInventFii`: initializer/literal/switch cannot be emitted by editing its body. |
| `at_3119` | Frozen `IsCreateObject__11CMenuInventFii`: initializer/literal/switch cannot be emitted by editing its body. |
| `at_3120` | Frozen `IsCreateObject__11CMenuInventFii`: initializer/literal/switch cannot be emitted by editing its body. |
| `at_3121` | Frozen `IsCreateObject__11CMenuInventFii`: initializer/literal/switch cannot be emitted by editing its body. |
| `at_3122` | Frozen `IsCreateObject__11CMenuInventFii`: initializer/literal/switch cannot be emitted by editing its body. |
| `at_3123` | Frozen `IsCreateObject__11CMenuInventFii`: initializer/literal/switch cannot be emitted by editing its body. |
| `at_3124` | Frozen `IsCreateObject__11CMenuInventFii`: initializer/literal/switch cannot be emitted by editing its body. |
| `at_3125` | Frozen `IsCreateObject__11CMenuInventFii`: initializer/literal/switch cannot be emitted by editing its body. |
| `at_3126` | Frozen `IsCreateObject__11CMenuInventFii`: initializer/literal/switch cannot be emitted by editing its body. |
| `at_3127` | Frozen `IsCreateObject__11CMenuInventFii`: initializer/literal/switch cannot be emitted by editing its body. |
| `at_3128` | Frozen `IsCreateObject__11CMenuInventFii`: initializer/literal/switch cannot be emitted by editing its body. |
| `at_3129` | Frozen `IsCreateObject__11CMenuInventFii`: initializer/literal/switch cannot be emitted by editing its body. |
| `at_3130` | Frozen `IsCreateObject__11CMenuInventFii`: initializer/literal/switch cannot be emitted by editing its body. |
| `at_3131` | Frozen `IsCreateObject__11CMenuInventFii`: initializer/literal/switch cannot be emitted by editing its body. |
| `at_3132` | Frozen `IsCreateObject__11CMenuInventFii`: initializer/literal/switch cannot be emitted by editing its body. |
| `at_3133` | Frozen `IsCreateObject__11CMenuInventFii`: initializer/literal/switch cannot be emitted by editing its body. |
| `at_3134` | Frozen `IsCreateObject__11CMenuInventFii`: initializer/literal/switch cannot be emitted by editing its body. |
| `at_3135` | Frozen `IsCreateObject__11CMenuInventFii`: initializer/literal/switch cannot be emitted by editing its body. |
| `at_3138` | Frozen switch table; its switch body cannot be edited. |
| `at_4354` | Frozen `IsAccessAlbum__11CMenuInventFv`: initializer/literal/switch cannot be emitted by editing its body. |
| `at_4355` | Frozen `IsAccessAlbum__11CMenuInventFv`: initializer/literal/switch cannot be emitted by editing its body. |
| `at_4356` | Frozen `IsAccessAlbum__11CMenuInventFv`: initializer/literal/switch cannot be emitted by editing its body. |
| `at_4357` | Frozen `IsAccessAlbum__11CMenuInventFv`: initializer/literal/switch cannot be emitted by editing its body. |
| `at_4358` | Frozen `IsAccessAlbum__11CMenuInventFv`: initializer/literal/switch cannot be emitted by editing its body. |
| `at_4359` | Frozen `IsAccessAlbum__11CMenuInventFv`: initializer/literal/switch cannot be emitted by editing its body. |
| `at_4360` | Frozen `IsAccessAlbum__11CMenuInventFv`: initializer/literal/switch cannot be emitted by editing its body. |
| `at_4361` | Frozen `IsAccessAlbum__11CMenuInventFv`: initializer/literal/switch cannot be emitted by editing its body. |
| `at_4362` | Frozen `IsAccessAlbum__11CMenuInventFv`: initializer/literal/switch cannot be emitted by editing its body. |
| `at_4363` | Frozen `IsAccessAlbum__11CMenuInventFv`: initializer/literal/switch cannot be emitted by editing its body. |
| `at_4364` | Frozen `IsAccessAlbum__11CMenuInventFv`: initializer/literal/switch cannot be emitted by editing its body. |
| `at_4365` | Frozen `IsAccessAlbum__11CMenuInventFv`: initializer/literal/switch cannot be emitted by editing its body. |
| `at_4366` | Frozen `IsAccessAlbum__11CMenuInventFv`: initializer/literal/switch cannot be emitted by editing its body. |
| `at_4367__2` | Frozen `IsAccessAlbum__11CMenuInventFv`: initializer/literal/switch cannot be emitted by editing its body. |
| `at_4368__2` | Frozen `IsAccessAlbum__11CMenuInventFv`: initializer/literal/switch cannot be emitted by editing its body. |
| `at_4369` | Frozen `IsAccessAlbum__11CMenuInventFv`: initializer/literal/switch cannot be emitted by editing its body. |
| `at_4370` | Frozen `IsAccessAlbum__11CMenuInventFv`: initializer/literal/switch cannot be emitted by editing its body. |
| `at_4371` | Frozen `IsAccessAlbum__11CMenuInventFv`: initializer/literal/switch cannot be emitted by editing its body. |
| `at_4372` | Frozen `IsAccessAlbum__11CMenuInventFv`: initializer/literal/switch cannot be emitted by editing its body. |
| `at_4373` | Frozen `IsAccessAlbum__11CMenuInventFv`: initializer/literal/switch cannot be emitted by editing its body. |
| `at_4374` | Frozen `IsAccessAlbum__11CMenuInventFv`: initializer/literal/switch cannot be emitted by editing its body. |
| `at_4375` | Frozen `IsAccessAlbum__11CMenuInventFv`: initializer/literal/switch cannot be emitted by editing its body. |
| `at_4376` | Frozen `IsAccessAlbum__11CMenuInventFv`: initializer/literal/switch cannot be emitted by editing its body. |
| `at_4377` | Frozen `IsAccessAlbum__11CMenuInventFv`: initializer/literal/switch cannot be emitted by editing its body. |
| `at_4379` | Frozen `IsAccessAlbum__11CMenuInventFv`: initializer/literal/switch cannot be emitted by editing its body. |
| `at_4380` | Frozen `IsAccessAlbum__11CMenuInventFv`: initializer/literal/switch cannot be emitted by editing its body. |
| `at_5011` | Inlining produces no native literal definition; frozen MenuInventInit still requires the retail symbol. |
| `at_5012` | Inlining produces no native literal definition; frozen MenuInventInit still requires the retail symbol. |
| `at_5013` | Inlining produces no native literal definition; frozen MenuInventInit still requires the retail symbol. |
| `at_5014` | Frozen `MenuInventInit__FP9mgCMemoryPii`: initializer/literal/switch cannot be emitted by editing its body. |
| `at_5015` | Frozen `MenuInventInit__FP9mgCMemoryPii`: initializer/literal/switch cannot be emitted by editing its body. |
| `at_5016` | Frozen `MenuInventInit__FP9mgCMemoryPii`: initializer/literal/switch cannot be emitted by editing its body. |
| `at_3509` (BSS) | Native gift initializer is preserved; marker anchors its identity against an unrelated compiler switch-name collision. |
| `at_3739` (BSS) | Confirmation buffer template; natural scope/value-initialization probes fail matching. |
| `at_3765` (BSS) | Confirmation buffer template; natural scope/value-initialization probes fail matching. |
| `at_2776` (BSS) | Frozen local zero template. |

## Native MenuInventKey data

MenuInventKey is native and exact after its promotion, so its form names
are ordinary inline literals: `msgbrd`, `msgpos`, `msg`, `msg3q`, and
`msg3p`. Its two list tops use `int tops[2] = {card_top, card_top - 1}`.
MWCC emits the same eight-byte zero template before storing the runtime
values; the separate `at_5642` BSS marker and CardListTops wrapper are
unnecessary. The native switch also emits the complete `at_5747` jump
table. Removing these seven markers preserves the complete PAL executable
and all 149 object comparisons. The remaining marker rows describe only
the retained assembly consumers or documented initializer failures.
