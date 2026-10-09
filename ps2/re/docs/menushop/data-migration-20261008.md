# menushop data migration (2026-10-08)

Baseline `e1471bff`: **102 INCLUDE_RODATA / 35 INCLUDE_BSS**, with
**4 / 1885 matched_data** after the normal objdiff/progress refresh.
The unit has 29 native functions and one guarded initializer; none is promoted.

## Named shop and quest state

Twenty-eight reservations are native, documented file-local definitions with
retail names. Their types follow the existing header and matched consumers:
shop/quest objects and message pointers, signed short shop identifiers/counts,
float cursor/scrolling positions, signed-byte memo mode and byte comment flag.
`ScmFlagCtrl` points to the selected `SCOOP_DATA`, rather than the signed-short
pointer asserted by the older notes. `QuestListTopY` and `QuestCommentWinX` are
floats, as their arithmetic and loads establish. `QuestTilePatternXY` owns one
float, used for both screen axes, and is expressed as a scalar. Its four-byte
piece tail is alignment, not a second coordinate. `QuestCommentMes` contains
three pointers, with four bytes of alignment after its twelve-byte extent.

`MenuLocalStack` retains its native construction and now has the documented
file-local binding. The guarded `MenuNPCQuestViewInit` and both vtable markers
are unchanged. Its named state remains reachable by the exact retail symbols.

After this group: **102 / 7 markers**, **64 / 1885 matched_data**.
Full PAL verification is OK and all 149 objects pass; only menushop's object
file hash changes from the warm baseline. Receipts:
`.private/dataD-r1/menushop-state-{build,objects,progress,metrics}.log`.

## Form, resource and message strings

Fifty-nine anonymous strings are inline in their matched callers: shop form and
part names, resource pack members, purchase/sale commands and quantity labels,
texture names, startup form exclusions, and quest/scoop configuration paths.
Shift-JIS strings use hexadecimal escapes for each original byte. Repeated
strings remain compiler pooled. Every function group passes the full build and
149-object comparison independently, with unchanged unowned object hashes.
Receipts are `menushop-{forms,scroll,resources,key,texture,shop-init,quest-init,quest-cursor}`
under `.private/dataD-r1/`; the refreshed checkpoint is `menushop-strings`.

## Native tables and aggregate templates

`dony_shoplist` has eight `DONY_SHOP_ITEM` rows, including the negative-item
terminator with level 1. `menu_shop_tag` has two handler rows and a null
terminator; its handlers now retain retail's local binding. The four-pointer
image list includes a final null pointer. Opening, purchase setup, confirmation
and insufficient-currency tables have one entry per `SHOP_SELL_MODE`, including
the repeated ordinary-money commands in Donny mode. Their strings are inline
in the pointer initializers. The two cursor-part and quest-pack tables likewise
contain their original inline strings.

The stamp table contains sixty signed-byte variant indices. The quest comment
frame uses seven rows of twelve signed-short texture coordinates. Its separate
fourteen-byte local heights initializer is already natural C++; its ten-byte
piece tail is padding. The goods-list and bag cursor offsets use `CursorPoint`,
item color is a four-byte array, and the movement rate is a mutable float.
The initial local cursor position is `{0, 0}`, rather than an external zero
object. Existing null name/value/message arrays and zero view coordinates
supply the four other anonymous BSS templates naturally. Existing switches
supply `at_1667` and `at_1881`, and construction supplies the shop vtable.
All corresponding markers are absent.

Every table and local-initializer step passes PAL and 149/149 objects.
Focused receipts are `menushop-{generated,dony,tags,imglist_1267,extbl_1278,
exe_tbl_1509,extbl_1573,extbl_1589,cursortbl_1838,packname_2171,stamps,frame,
t_offxy_1832,cursor_offsetxy_1836,cursor-local,QuestMoveRate}` under
`.private/dataD-r1/`. The final check also includes the neutral color array.

## Retained markers

| Marker | Reason |
| --- | --- |
| `__vt__14CMenuQuestView__DATA` | Guarded `MenuNPCQuestViewInit` directly references the exact retail vtable symbol; its assembly-backed data remains explicit. |

Table checkpoint: **1 INCLUDE_RODATA / 2 INCLUDE_BSS**, from **102 / 35**;
**1653 / 1885 matched_data**, from **4 / 1885**. All 29 native functions remain
exact and the guarded initializer is unchanged. PAL is OK, 149/149 objects
pass, and the other 148 object file hashes equal the warm baseline. Final
receipts: `.private/dataD-r1/menushop-final-{build,objects,progress,metrics}.log`.

## Persistent primitive state

The prior panel and its one-byte initialization flag use documented file-local
primitive definitions under their retail names, following the accepted
menucapt counter/guard form. Their existing runtime initialization remains
unchanged. Primitive storage does not need the queued constructor-bearing
local-static binder proposal. The flag's seven-byte piece tail remains padding.

Final canonical state: **1 INCLUDE_RODATA / 0 INCLUDE_BSS**, from **102 / 35**;
**1821 / 1885 matched_data**, from **4 / 1885**. PAL and 149/149 objects pass;
all guarded/SF bodies and unowned object hashes remain unchanged. Receipts:
`.private/dataD-r1/menushop-persistent-state-{build,objects,progress,metrics}.log`.

The final data-marker ending has no trailing blank line. The final formatting
check again passes PAL, 149/149 objects, protected bodies and unowned hashes:
`.private/dataD-r1/menushop-final-format-{build,objects}.log`.
The final three-unit refresh is in `dataD-final-{progress,metrics}.log`.
