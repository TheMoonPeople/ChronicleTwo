# Buggy initialization and effect construction

`sgInitBuggy__FP11SubGameInfo` is native and exact at `0x318B70`, with a `0x994` body in
a `0x9A0` piece containing twelve zero alignment bytes.

## Analysis and actual interfaces

The initializer divides the texture blocks consecutively: buggy, Porcuss, Muccho, bomb,
Starbull, gun, system, and then the five-block effect pool. It requires the scene's
current player, assigns work stack 5, deletes the existing subgame texture blocks, loads
the buggy pack and seven character resources, obtains their real scene objects, and
activates the observed slots. Bomb receives a texture block without the sibling
activation call. Missing player, character, required model frame, pack load or assigned
effect returns zero at the observed checkpoints; optional packed resources preserve
their retail skip behavior.

The scene slots are the actual contiguous 0x40..0x46 records, named by the source-local
`BuggySceneChara` enum. `SubGameInfo::scene`, `texb` and `texb_num` are the existing
+0/+4/+8 members. `CScene` supplies its real `read_buff`, stack,
texture/character/effect, camera and message APIs. The serial pack is viewed as words
only at the documented `GetPackFile` interfaces; the image copy is an actual returned
byte buffer. No object field is reached through byte-address arithmetic or a fake
aggregate view.

`CCharacter2::frame` is its floating animation counter. The root model at +0x70 is
**`CObjectFrame::frame`**, explicitly qualified in the source. The two passengers follow
`polcurse_chair` and `macho_chair`; the muzzle model follows `dcol00`. The actual
`cyl68` and `obj290` frames have their existing `mgCFrameAttr::draw` fields cleared. The
player's packed model call is its actual virtual **LoadPack** slot, not its sibling
LoadPackNoLine. The gun resources pass **no_outline=1**, verified from the real
stack-argument `sd 1,0(sp)` instructions; m2c's guessed final zero argument is
incorrect.

The image byte count is written by `GetPackFile(..., int*)`. Its real block count uses
unsigned shift and the nonzero remainder branch, then copies the reported bytes into the
returned storage and enters the IMG through the texture manager. `WorkBuff` is the
four-byte LOCAL pointer to a genuine 160000-byte array; its source declaration is
corrected from int to `u_char*`. Its allocator request is 10002 quadwords, expressed
from the actual byte capacity plus the observed two-quadword reserve. **EffectBuff
receives 20000 quadwords (320000 bytes)**, not the 20000 bytes stated in the older
pbuggy note.

`CEffectScriptMan` is the existing 0x1190-byte type. Its embedded 0x50-byte
`mgC3DSprite` starts at +0x30, with the sprite vptr at +0x4C. The genuine existing
manager constructor naturally performs the base/derived sprite construction and
`Initialize(NULL,-1,-1)`. Ordinary whole-object placement new supplies that chain; no
source vtable store, explicit ctor call, fake sprite-state layout or hand-written
special member is retained. The manager then uses the real work pool, read buffer and
texture pool, loads the two actual Shift-JIS effects and becomes scene effect 7. Retail
continues to initialize the result even when allocation returns null; no new failure
check changes that behavior.

Sound uses the existing `SND_PORT_ENEMY` identity, then the real BGM APIs. The
buggy/bomb initialization calls and player motion/reset remain in order. The camera is
the observed CCameraControl reached through GetCamera; its real inherited virtual
**Step(-1)** slot is called after SetRotate/RotBack. The message uses
`MES_PRESET_WINDOW` and `MES_WIN_VERSATILE_1`. Its +0x158 write is **fukidashi_pos=8**,
not the spurious `tbl[1].color` field inferred by the m2c context. The existing
sgCPlayVoice fields are reset individually; its file number is not overwritten. All
referenced type/API contracts are already documented by their owning units; matched
callees are not reanalyzed.

## Construction policy

The row names `pbuggy.cpp`, this caller, `__nw__FUiP1` and `__ct__16CEffectScriptManFv`,
with `after_constructor_inline` and `expected_matches: 1`. The sole eligible
construction is the real effect manager. Its base and derived sprite initializers retain
ordinary C++ calls. The 23 inline null-terminated strings have retail LOCAL
counterparts.

The initial decompiler guesses for LoadPackNoLine and the gun outline argument were
incorrect: retail calls LoadPack and passes no_outline=1. A candidate using those
guesses differed by 431 words and is not behavioral evidence.

Construction selector semantics are documented in [the compiler
design](../satansfiddle/placement-new.md).
