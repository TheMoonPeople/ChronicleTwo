# Monster book support declarations

The accepted monster-book caller uses these existing source declarations:

| Declaration | Purpose |
| --- | --- |
| `kMonsterMemoCount = 0x119` | Number of monster memo entries. |
| `kModelDelayFrames = 20` | Frames waited before starting a monster preview load. |
| `kModelFrameCap = 20` | Maximum value of the preview display wait counter. |
| `kBookBrowsing`, `kBookFadingIn`, `kBookFadingOut` enum | Browsing and fading states of the monster book menu. |
| `kCmdClose`, `kCmdTurnPage` enum | Commands to close the monster book or turn its page. |

Current construction policies and activation rows are documented in [the
placement-conversion design](../satansfiddle/placement-new.md).
