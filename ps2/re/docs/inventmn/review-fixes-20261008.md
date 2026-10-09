# October 8 night review fixes

## CalcTex gift coordinates

`CMenuInvent::CalcTex` initializes the gift-box coordinates as a real
`int[2]`, passes that array to `GetPosMenuItemOnItemBrd(int *, int, int)`,
and reads its two elements when placing the gift form. The callee writes
both output elements; a pointer to the first field of a `CursorPos` record
is not an array covering both fields.

The local zero initializer still emits the retail eight-byte template.
`INCLUDE_BSS(at_3509, 0x8)` remains the identity anchor required by the
unrelated PushKey switch-name collision described in
[data-migration-20261008.md](data-migration-20261008.md).
No external declaration of the gift template remains after data migration.

The complete PAL build verifies `SCES_511.90: OK` and all 149 objects pass
with the array form. Receipts:
`.private/fixes-r1b/receipts/gift-array-{build,objects}.log`.

## Retail function sizes

The header's `@size` values describe each function's declared retail symbol
size in `ps2/config/pal/main.symbols.txt`, excluding padding before the next
function. 56 padded tags are corrected. Every tagged symbol in this
header is present in that table, and the complete size audit has no mismatch.

The documentation changes preserve `SCES_511.90: OK` and 149/149 objects.
Receipts: `.private/fixes-r1b/receipts/header-sizes-{build,objects}.log`.

## Start and Select button bits

`MenuCheckPushButton` maps `PAD_START` (`0x0800`) to `0x10` and
`PAD_SELECT` (`0x0100`) to `0x20`. The shared enum names now describe those
values. The inventory debug case remains `0x20` through
`MENU_PUSH_BUTTON_SELECT`; the title's start check remains `0x10` through
`MENU_PUSH_BUTTON_START`.

Both uses and the enum names preserve `SCES_511.90: OK` and 149/149 objects.
Receipts: `.private/fixes-r1b/receipts/start-select-{build,objects}.log`.

## Rotation flag declaration dependency

`itemmenu_chr_rotflag` is defined in `menusys.cpp` and declared in
`menusys.hpp` as `s8`; inventmn reaches it through that header. Its only read
(the menusys weapon preview step) is a retail `lb`, so the signed type removes
the former `(s8)` cast at that read. Changing the header declaration alone
does not compile (MWCC reports a redeclaration from `char` to `unsigned char`),
so the definition, the declaration and the consumer change together; every
object stays byte-identical.


## MenuInventKey enums and message positioning

The shared `CBaseMenuClass::mode` values 0, 1 and 2 mean idle, opening
and closing. Inventory extensions 13 and 14 call PhotoNetaEnter and
IsAccessAlbum, respectively. These values now use `MENU_ASK_MODE_*`;
English and the first continental language threshold use LANG_ENGLISH
and LANG_FRENCH. The existing SetMovePosGyou inline supplies the bounded
name-line position writes and enabled flag with identical code.

The photo navigation table's 1 and 7 lead to the album-access button
beside the idea board and photo-only board. CalcCursorPosition places
both on `album_sw_form`; MenuInventPushKey runs `IS_MCACCESS` from both
and returns to the idea or photo board on left navigation. They are
INVENT_MODE_THINK_ALBUM_BUTTON and INVENT_MODE_PHOTO_ALBUM_BUTTON.
INVENT_MENU_MODE describes key_arg_no, independently of the shared
mode field. The complete executable and all 149 objects remain exact.

## Guarded draft literal references

LoadCharaCheck and MenuInventInit use the same standing-motion and
idea-mode script literals as native callers. IsAccessAlbum uses the
inline `IS_MCACCESS` script name. IsCreateObject's final unnamed-photo
fallback uses the exact Japanese `うーん` bytes from the former at_2820
marker (`82 A4 81 5B 82 F1 00`); the localized Tb_2819 table remains
its earlier fallback. These draft references now compile after the
shared literal migration, without restoring deleted externs or markers.
The guards and retail fallbacks are unchanged. The draft checker compiles
all five guarded functions; the normal PAL image and 149 objects remain
exact.

## Plain-array initializer probes

Each candidate is compiled separately through the pinned canonical MWCC/SF
wrapper and compared against the complete unit, including resolved
relocations. A copied-source control matches first, and all accepted
initializers match together. The results are:

| Initializer | Result |
| --- | --- |
| `found-flags` | Plain array accepted; exact unit. |
| `record-types` | Plain array accepted; exact unit. |
| `grade-rows` | Plain array accepted; exact unit. |
| `gradation-steps` | Plain array accepted; exact unit. |
| `cursor` | Plain array accepted; exact unit. |
| `item-board` | Plain array accepted; exact unit. |
| `make-names` | Plain array accepted; exact unit. |
| `card-color` | Plain array accepted; exact unit. |
| `grid-codes` | Plain array accepted; exact unit. |
| `one-name` | Plain array accepted; exact unit. |
| `five-names` | Plain array accepted; exact unit. |
| `hidden-models` | Plain array accepted; exact unit. |
| `blank-name` | Plain array accepted; exact unit. |

The unused NetaFoundFlags, ScreenPoint and NetaEffectTarget types are
removed, together with initializer wrappers that have no remaining uses.
GradationSet writes 224.0f directly to each part's y coordinate; its two
integer writes were the same float bits (0x43600000). The existing
IsAskExtend confirmation-name copies remain: the recorded scope split
changes 15 prologue text bytes, and value-initialization also fails.
Guarded IsCreateObject's FoundSlots and PathPrefix copies retain their
retail assembly storage. The mode table's former raw 1 and 7 are the
named album-button states established in the earlier enum cleanup.

The normal full build preserves SCES_511.90 and all 149 canonical objects.

## Current status and source spacing

The main notes distinguish current native functions from their historical
guarded measurements and link the accepted promotions. Empty section
headings, repeated blank lines and missing function separators are removed
without reflowing the source. The full PAL verifier and 149 object
comparisons remain exact.
