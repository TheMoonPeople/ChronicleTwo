# Monster book support declarations

The accepted monster-book caller uses these existing source declarations:

| Declaration | Purpose |
| --- | --- |
| `kMonsterMemoCount = 0x119` | Number of monster memo entries. |
| `kModelDelayFrames = 20` | Frames waited before starting a monster preview load. |
| `kModelFrameCap = 20` | Maximum value of the preview display wait counter. |
| `kBookBrowsing`, `kBookFadingIn`, `kBookFadingOut` enum | Browsing and fading states of the monster book menu. |
| `kCmdClose`, `kCmdTurnPage` enum | Commands to close the monster book or turn its page. |

The constants and enum declarations now have the required purpose comments.
No value, type, function body or policy row changes. The accepted 34-caller
pn15 rebuild passes PAL verification and 149/149 complete object checks;
all 306 assembled and 149 source-only objects retain identical hashes, as
does the whole accepted-34 ELF. The shared
[design note](../satansfiddle/placement-new.md)
indexes the independent review and explicit identity receipts. The
[accepted caller note](placement-new-night-20261009.md) owns the behavior.

## Current design reference

This dated evidence retains its original measurement scope.
[The consolidated placement-conversion design](../satansfiddle/placement-new.md) owns the current
capability, activation rows, safety requirements, and accepted source status.
