# mg_texture: reverse-engineering notes

Header: `ps2/include/mg_texture.hpp`. The unit is the engine texture manager (`mgTexManager`, the
single instance, lives in mglib at 0x398070, size 0x21C, constructed in `__sinit_mglib_cpp`).

## File-local symbols (static, belong in the .cpp, not the header)
From `build/re/local_symbols.tsv`: `GetZBufVram(int*)`, `CheckCopyToZBufVram(mgCTexture*, int*)`,
`GetIMGVersion(char*)`, `SetTexFlush_TagCnt(u_int*)`, `BlockConv32to8`, `PageConv32to8`,
`Conv32To8`, and the data `texflush_dma` (mg_visual has its own local `texflush_dma`, which is
why the symbol list calls that one `texflush_dma__2`). Hence the header has **no `extern`**.
- `texflush_dma`: `u_long128[3]` (copied with `lq`/`sq` in `SetTexFlush_TagCnt`): DMA cnt tag
  qwc 2 + VIF DIRECT 2, GIF tag (NLOOP 1, EOP, A+D), TEXFLUSH (0x3F) = 0.
- `lut_1246`, `block_table8_1266`, `block_table32_1267`, `conv_work_1306` (0x10000 bss) are
  function-local statics of BlockConv32to8 / PageConv32to8 / Conv32To8. `conv_work_1306` alone
  is still an `extern` over an `INCLUDE_BSS` marker: the generated data assembly
  (`ps2/asm/pal/data/lib/sce/libdev.rodata.s` and the menuop, title, fishing and automap data)
  names it in address-shaped words that retail does not relocate, so a native definition with
  internal linkage leaves those references unresolved at link time. Its migration waits on the
  tooling change described in [data-migration-20261008.md](data-migration-20261008.md).
- Suggested signatures: `static int GetZBufVram(int *size)` (returns `(mgZBUF_1 & 0x1FF) << 5`
  = Z buffer VRAM block address; `*size` = `height*height*4/256` blocks of a local
  mgCTexture filled by `mgGetFrameBuffer(&local)`; it also calls `mgGetTextureZ(0)` and
  discards the result); `static int CheckCopyToZBufVram(
  mgCTexture*, int *size)` (1 when `swizzled == 0 && bpp == 8 && image[0]`, size =
  `vram_size*4`); `static int GetIMGVersion(char*)` returns mgIMG_VERSION;
  `static int SetTexFlush_TagCnt(u_int*)` returns 3 (quadwords); `static int Conv32To8(int w,
  int h, u_char*)` returns 1 on success (w*h <= 0x10000), 0 otherwise.
- `sceGsTex0::operator=` (0x12EE60) copies the 64-bit TEX0 value and returns the
  destination. It has a native 0x14-byte definition because `ReloadTexture`'s
  assignment to a local `sceGsTex0` is still guarded by `NONMATCHING`.

`mgCTexture::Initialize` matches PAL with typed field writes and an indexed
clear of the four image pointers under MWCC optimization level 2. TEX1 and
CLAMP require whole 64-bit zero stores before the two CLAMP wrap bits are set;
the other fields are written directly. This removes the previous byte offsets
and pointer arithmetic while preserving the 0x9C-byte function.

## mgCTexture (size 0x70)
Size: `__construct_new_array(..., 0x70, n)` in SetTableBuffer and in `__sinit_mglib_cpp`
(`__construct_array(0x399700, ctor, 0, 0x70, 2)`).
Layout from `Initialize`, `EnterTexture`, `ReloadTexture`, and the inlined implicit copy in
`mglib/mgGetFrameBuffer` (copies 0x00-0x33, 0x38-0x6B; skips 0x34 and 0x6C -> both padding).
| off | field | evidence |
|---|---|---|
| 0x00 | short block | -1 in Initialize; set to block number in EnterTexture; compared in SearchHash; incremented when an IMG picture spills into the next block |
| 0x02/04/06 | short width/height/bpp | EnterTexture stores param width/height/bpp; bpp compared with 8, `< 9` |
| 0x08 | char name[0x20] | strcpy from a 32-byte local; hash/strcmp key |
| 0x28 | int vram_size | 0x2C rounded up to multiple of 32 (a page); added to tbp0 in ReloadTexture; summed in GetRemainVRAM |
| 0x2C | int image_blocks | sum of mip level sizes in 256-byte GS blocks (`bpp*w*h/256/8`, /4 per level) |
| 0x30 | int clut_size | 4 for PSMT8/PSMT4, else 0. Code elsewhere uses literal 4 for CLUT space; name is a reasonable reading |
| 0x38 | sceGsTex0 tex0 | built with SCE_GS_SET_TEX0 shapes; TBP0/CBP/PSM/TBW bit edits |
| 0x40 | sceGsTex1 tex1 | Bilinear edits MMAG (bit 5) / MMIN (bits 6-8) / reads MXL; EnterTexture writes whole words (0x261, 0x260, 0xFFFFFF8800000368, or L/K from the tex1 arg) |
| 0x48 | u_long clamp | Initialize sets WMS=WMT=1 via bitfield ops; IM3 entry +0x38 copied in. Retail type is `sceGsClamp` (`mgSetPkTextureRepeat__F10sceGsClamp`) but `libgraph.h` does not declare it yet; switch the field to `sceGsClamp` once it exists |
| 0x50 | u_long128 *image[4] | mangled `PP1` arg; loop of 4 |
| 0x60 | u_long128 *clut | mangled `P1` arg; ReloadCLUT uploads it |
| 0x64 | int swizzled | last arg of EnterTexture. When set and bpp 8, ReloadTexture uploads as PSMCT32 at half width/height. TM2 EnterTexture clears it if Conv32To8 succeeds. Same meaning as first game's `CTexture::swizzled` |
| 0x68 | mgCTexture *next | mgCTextureBlock list link |

First game: `CTexture` (texture.hpp) has block/width/height/bpp/name/tex0/tex1/image[4]/clut/
swizzled; this game adds vram_size, image_blocks, clut_size, clamp, next; order differs (tex0 then
tex1 here, both after the size ints).

Bilinear(mode): no mip levels (MXL==0): 0 -> MMAG 0 MMIN 0; 1,2 -> MMAG 1 MMIN 1. With mips:
0 -> MMAG 0 MMIN 2; 1 falls through into 2 (missing `break` in retail, writes MMIN 4 then 5);
2 -> MMAG 1 MMIN 5. Other values: no change. Hence `MG_TEXTURE_FILTER_2` is undistinguished.

## mgCTextureBlock (size 0x10)
Stride 0x10 in GetTextureBlock; `__construct_new_array(..., 0x10, n)`.
- 0x00, 0x04: int; 0 in Initialize, set to manager `vram_top` in Manager::Initialize; never read
  in any unit found -> `unk_0`, `unk_4`.
- 0x08 mgCTexture *texture: list head (Add/Delete/DeleteBlock/GetRemainVRAM/ReloadTexture).
- 0x0C mgCTextureAnime *anime: TexAnimeOn/Off etc.; created in mg_tanime
  `texTEX_ANIME_DATA_END` (new 0x1E4).
First game `CTextureBlock` is unrelated in layout (name, VRAM range, staging buffer).

## mgCTextureManager (size 0x21C, from `mgTexManager` symbol size)
| off | field | evidence |
|---|---|---|
| 0x00 | int vram_top | Initialize arg 1 (`GetVramTopAddress()` in mainloop SetTextureTable); ReloadTexture places a block's textures from here |
| 0x04 | int vram_fix | Initialize arg 2, -1 -> 0x3FE0; decremented by fixed textures (vram_size, plus 4 for CLUT) |
| 0x08 | int last_block | -1 in Initialize; set by ReloadTexture; compared to skip re-placing |
| 0x0C | int block_max | SetTableBuffer arg 2; bound in GetTextureBlock |
| 0x10 | mgCTextureBlock *blocks | new[] of block_max |
| 0x14 | mgCTextureBlock fix_block | GetTextureBlock(0x7FFF) returns `this+0x14`; ctor constructs it |
| 0x24 | mgTEXTURE_HASH *hash_table[101] | `hash()` = `(h*256+c) % 101 & 0xFF`; Initialize clears 0x65 words |
| 0x1B8 | mgCTexture *texture_buf | new[] of texture_max |
| 0x1BC | mgCTexture **texture_stack | pointer stack of pool entries; SearchTexture pops at `texture_num++`, DeleteTexture pushes at `--texture_num` |
| 0x1C0/0x1C4 | int texture_max / texture_num | |
| 0x1C8 | mgTEXTURE_HASH *hash_buf | `new[]` of 8-byte POD (no cookie) |
| 0x1CC | mgTEXTURE_HASH **hash_stack | same pattern as texture_stack |
| 0x1D0/0x1D4 | int hash_max / hash_num | hash_max = texture_max |
| 0x1D8 | char name_suffix[0x14] | strcat onto names in EnterTexture/SearchTextureName; other units strcpy into `0x398248` and clear it (monster, inventmn) |
| 0x1EC | mgCMemory unk_1ec | `mgCMemory::Init` in the ctor; no other use found |

Note SetTableBuffer(texture_max, block_max, memory): mainloop SetTextureTable(a, b, mem) calls
SetTableBuffer(b, a, mem).
First game `CTextureManager` (fixed arrays of 72 blocks / 196 textures, staging buffer) differs
entirely; only the concepts (fixed textures growing down from the top of VRAM) carry over.

Member `LoadCFGFile` is defined in mg_tanime (0x13DF30); declared here.
`GetGroupNameList` returns `mgCTextureAnime::name` (anime + 0x124, `char*[]`) and stores 0x18
(the group max) in `*num`; return typed `char **`.
`EnterIMGFile` returns (highest block used) - (block passed).

## mgTEXTURE_HASH (8 bytes) -- name not retail
`{ mgCTexture *texture; mgTEXTURE_HASH *next; }` from AddHash/DelHash/SearchHash.

## mgCEnterIMGInfo (0x100)
`new(0x100)` + copy in mdslist CIMGList::LoadIMGFile. EnterIMGFile sets `[0..31] = -1`,
`[32..63] = 0`; for IM3, `block[group] = first block`, `block_num[group]` = 1 + spills; for
IMG/IM2, `block[0] = block`, `block_num[0] = spills + 1`.

## IMG archives (types not retail-named: mgIMG_FILE_HEADER, mgIMG1_HEADER, mgIMG_HEADER)
Signatures (rodata): at_866 "IM" (2-byte check), at_884 "IMG" -> 1, at_867 "IM2" -> 2,
at_868 "IM3" -> 3.
- IMG/IM2: count at +4, 0x30-byte entries from +0x10: name[0x20], offset +0x20. IM2 entries are
  entered with swizzled = 1 (EnterIMGFile passes `memcmp(img,"IM2",3)==0`), and mgGetIMGHeader
  sets `swizzled = 1` for IM2.
- IM3: count at +8, 0x40-byte entries from +0x10: name[0x20], unk_20, offset 0x24, swizzled 0x28
  (overwritten with the texture's swizzled after entry), block 0x2C (negative clamped to 0;
  entries are first sorted by it, '#' entries excepted), short no_image 0x30, unk_32, size 0x34
  (script length passed to LoadCFGFile for '#'-named entries), clamp 0x38 (copied to texture).
- `mgGetIMGHeader(char *img, int index)` returns the entry by value (hidden return pointer in
  a0); it is the IM3 layout, filled from IMG/IM2 entries (name, offset, swizzled).

## TM2_head
Retail name from the mangling. The code reads it as file header + first picture header + mip
header at absolute offsets: tag (memcpy of 4 bytes into an unused local), image_size 0x18,
header_size 0x1C, mipmap_textures 0x21, image_type 0x23, width 0x24, height 0x26, tex1 0x30,
mipmap_size[] 0x50 (size of level i; level 0 starts at `0x10 + header_size`, the CLUT follows
all levels at `image0 + image_size` when bpp <= 8). Only 4 levels are ever read (4 image
pointers). Field names follow the first game's tim2.hpp / the TIM2 format; unused fields unk.
image_type -> bpp: 5->8, 4->4, 3->32, 2->24, 1->16; other -> return 0.
Also used by mainloop ReLoadFontTexture and eventedit evLoadDebugFont (they only pass it on).

## EnterTexture (pixels) details
PSM from bpp: 32->PSMCT32(0), 24->PSMCT24(1), 16->PSMCT16(2), 8->PSMT8(0x13), 4->PSMT4(0x14),
other -> return NULL. TW/TH = ceil log2; TBW = ceil(w/64) min 1. TCC=1 always; for PSMT8/T4
CLD=1 (0x2000000000000000) and clut stored. tex1 default 0x261 / 0x260 / mip 0x...368, with L/K
taken from the `tex1` arg when non-zero. Fixed block: places from vram_fix downward (CBP at
vram_fix-4 for indexed). Prints "b = %d,%s vram = %d\n" when mgGetPerformanceMeterFlag().
Strings: at_497 "%s is already used.\n" (SearchTexture), at_869 "texture over %d:%s\n".

## mgLoadImage(u_int *packet, int dbp, int dpsm, int dbw, u_long128 *image, int qwc, int x, int y, int w, int h)
BITBLTBUF upper word: dbp | dbw<<16 | dpsm<<24 (arg 3 shifts by 24 -> psm, arg 4 by 16 ->
width); TRXPOS dsax/dsay = x, y; TRXREG = w, h; then IMAGE transfers of at most 0x4000 qwords.
Returns words written. ReloadTexture passes (tbp0, psm, tbw, ...); ReloadCLUT (cbp, cpsm, 1,
clut, qwc, 0, 0, w, h) with qwc/w/h = 0x40/16/16 for 8-bit and 4/8/2 for 4-bit.

## Native initialized data

The 0x1B0-byte initialized-data run at 0x338080–0x338230 now comes from ordinary
C++ arrays. Its four pieces remain in retail order and retain their extents and
16-byte placement alignment:

| Symbol | Extent | Meaning |
| --- | --- | --- |
| `texflush_dma` | 0x30 | DMA CNT packet with VIF DIRECT, an A+D GIF tag, and a GS TEXFLUSH write. |
| `lut_1246` | 0x80 | Byte destinations for the alternating columns in `BlockConv32to8`. |
| `block_table8_1266` | 0x80 | Row-major 8-bit block coordinates mapped to GS block numbers. |
| `block_table32_1267` | 0x80 | Row-major 32-bit block coordinates mapped to GS block numbers. |

The byte tables preserve the little-endian ordering of the packet and the lookup
values. Retail ELF binding confirms all four tables are file-local. The block tables
are separate mutable `int[32]` arrays even though their
current values agree; each has its own retail symbol and address. The array
initializers preserve all data bytes, all unit instructions, and all 160
relocations against the prior object. After the normal `fixup_sections.sh` stage
removes MWCC dead sections, `check_objects.py mg_texture --obj-dir
/tmp/engine-satansfiddle -v` reports only the three existing hash-function
instruction differences below.

## Hash lookup

`AddHash`, `DelHash`, and `SearchHash` were checked with `decompile.sh` and m2c.
The bucket links are 8-byte `mgTEXTURE_HASH` records with a texture pointer at
0x00 and next link at 0x04. `hash_table` is the manager's array of 101 bucket heads
at 0x24; `hash_stack` is its separate free-node stack. `AddHash` obtains a free
node and appends it to its name's chain. `DelHash` unlinks the matching texture
and returns that node to the free stack. `SearchHash` compares names and applies
an optional texture-block filter.

The native implementations now match retail exactly. `AddHash` obtains one free
link, initializes it, and either installs it as the bucket head or appends it to
the end of the chain. `DelHash` unlinks the matching texture and returns the link
to the free stack. `SearchHash` compares names and applies an optional texture-block
filter. All three use typed `hash_table[index]` reads and writes.

A single `optimization_level 2` scope across these contiguous methods, while the
translation unit retains its existing disabled global optimizer and scheduler,
produces the retail operand order for bucket address formation. The fixed
translation-unit `-O3,p` build without this scope leaves one commutative `addu`
operand mismatch in each function. Applying `-O2` to the whole unit fails many
unrelated function extents and instructions, so the narrow shared scope is
required. The fixed-profile private build passed `check_objects.py` for the whole
unit: 0x3674 bytes and 160 resolved relocations, with all three functions exact.

## Native full-image conversion

The merged `Conv32To8` uses the newer native optimization-level-1 body and
its explicit local declaration order. It preserves the original image size,
uses two 8 KiB stack pages and a 64 KiB output workspace, and copies page rows
with the documented 256-byte and 128-byte pitches. Earlier level-2 trials
matched topology and relocations but permuted saved registers; they do not
establish a remaining failure in this newer body. The merged function needs
canonical validation under the deterministic compiler profile. Its cursor
advancement operates on byte-copy buffers rather than hidden object fields.

## Additional hash-table source trials

At default optimization level, index/base casts, unsigned indices, swapped
subscripts, manager locals, bucket-head references, and one-pointer bucket
records do not resolve address-operand order. Level 2 with the original
bucket-pointer locals makes only `SearchHash` exact. Direct bucket-head
accesses at level 2 make all three exact: native sizes are `0xD8`, `0xE8`,
and `0xB0`.

Nesting `hash()` in the subscript or changing its return to `u_int` retains
the default mismatch. A `u_char` return adds normalization and size/relocation
failures. Level 1 and global-optimizer-on change other instructions. The DC1
`CTextureManager` uses fixed arrays and provides no corresponding bucket
accessor. The active implementation uses upstream's single shared level-2
scope; no profile row or shared-header change is required.
