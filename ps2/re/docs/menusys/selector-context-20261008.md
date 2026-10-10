# Debug-panel argument policies

`MenuItemDebugDraw` is native and exact. Seven binary32 rows for
`DrawMenuFillBox__Fffffiiii` describe its panel schedules:

| Value / bits | Source identity | Policy |
| --- | --- | --- |
| 200 / `0x43480000` | Switch `[2]`, argument 1 = 330 (`0x43a50000`) | `evaluate_first: false`, `evaluate_before: 2` |
| 60 / `0x42700000` | Switch `[4]` | Evaluate first |
| 60 / `0x42700000` | Switch `[6]` | Evaluate first |
| 230 / `0x43660000` | Switch `[6]` | Evaluate first |
| 260 / `0x43820000` | Switch `[6]` | Evaluate first |
| 230 / `0x43660000` | Switch `[7]` | Evaluate first |
| 260 / `0x43820000` | Switch `[7]` | Evaluate first |

Each row asserts one consumed argument per invocation. The 330-Y sibling
separates page 2's lower panel from its other calls. Height 200 must precede
width argument 2 in the ordinary walk while leaving 20-X and 330-Y first.
Early evaluation instead moves height ahead of those coordinates and
changes seven setup instructions. Pages 4, 6 and 7 need distinct
combinations despite shared 236-X, 60-Y and 230-width values.

On the earlier source, these rows leave eight words different: the
item-index addition's operands and the three-name loop's counter/stride
allocation. The current `page * 64 + 1 + row * 8 + col` expression and reused
attribute-loop index resolve both; see [unit notes](notes.md). The body is
`0x13A4`, followed by twelve alignment bytes. Its complete object and the
integrated PAL image pass. m2c's jump-table limitation requires the already
analyzed switch labels for this function's page identities.
