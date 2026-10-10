# Scene character loading and copying

`CScene::LoadChara` constructs and assigns a character, loads its model and optional
configuration, and initializes the scene slot's transform/status. `CopyChara(index,
source_index, memory)` constructs the destination character and copies the source's
data, transform and texture block. Both functions are native and exact.

Each exact row uses `sceneload.cpp`, `__nw__FUiP1`, `__ct__11CCharacter2Fv`,
`after_constructor_inline` and one eligible class-6 construction. The full caller
identities are `LoadChara__6CSceneFiPUiPcP9mgCMemoryP9mgCMemoryP9mgCMemoryii` and
`CopyChara__6CSceneFiiP9mgCMemory`. Both canonical two-word allocator-result branch/copy
differences become zero.

The recovered `chara` and `cfg` names are inline literals; their unused aliases/data
fragments are removed. Complete review retains the authentic allocation/failure
ordering, typed one-element file arrays and named scene entry fields. The scene status
bit remains numeric because no owning status enum is established in the available scene
documentation. No new helper, raw byte object arithmetic or synthetic lifetime variable
is introduced.

Retail LoadChara at 0x00288F30 is GLOBAL/FUNC, size 0x244 in extent 0x250. CopyChara at
0x002891B0 is GLOBAL/FUNC, size 0x284 in extent 0x290. The owning scenesnd.hpp
declarations record both symbol sizes.

Construction selector semantics are documented in [the compiler
design](../satansfiddle/placement-new.md).
