# Rectangle assignment proposal

The proposed `mgRect<T>::operator=(mgRect)` explicitly copies four edges
from a by-value argument and returns the destination by reference. The
rectangle remains four typed edges with its existing alignment. The retail
fish-race caller's quadword temporary copy motivated this proposal, but
there is no standalone mgRect assignment symbol in the retail ELF from
which to establish a user-written by-value operator. A caller copy alone
does not establish that special-member declaration. Compiler-generated
assignments must remain compiler-generated.

The independent full build on 93cbbea changes three of 149 objects:
menudraw, menumap and screeneffect. All three introduce new byte/relocation
failures, reducing the complete-object pass count from 147 to 144. PAL text
differs by 0xDC35C bytes; eight file-backed sections fail, and memory ends
at 0x1F64A40 instead of 0x1F64A00. The proposal is rejected.

A sweep of 31 affected guarded units changes only these drafts:

| Function | Baseline words | Proposed words | Proposed body / retail reservation |
|---|---:|---:|---|
| `sgLoopGyoRace` | 490/1676 | 1189/1680 | 0x1A40 / 0x1A30 |
| `CDngFreeMap::DrawRoot` | 754/844 | 790/844 | 0xCCC / 0xD30 |
| `CMenuPosDataForm::MenuFormDrawNormal` | 13/1020 | 778/1034 | 0x1028 / 0xFF0 |

These canonical comparisons include zero padding and excess native words,
with relocation operands masked. No guarded draft improves or reaches zero.
`TexAnime` and `NewTexAnimeData` retain their baseline scores. No explicit
assignment or compiler-profile change is retained.
