# Character-change resource entry: genuine palette word ownership

Private pntc study, October 9, 2026. The captured production profile has 31
placement callers, SHA-256
`f3632b6c81415c7438efe23defeafc9cd6681f789574165132ae1b88a19f1fa3`.
The source control is
`c8dde1b8097429c466880d877864e8defb0678a84c73d4b445b35d6dab16a076`.
Canonical compilation uses `chronicletwo_dev:sf-63f7a9e-pn15` through the
required container harness, a private temporary directory, real logical
`menuchr.cpp`, the normal MWCC flags, and both draft defines for native
measurement. The final guarded wrapper uses the normal build defines.

## Result and actual extent

`EnterDataMenu__15CMenuChrCngMenuFPUc` remains unmatched at **11/388** differing
words, improved from the fresh **376/392** control. Its native body is exactly
retail's actual **0x608**-byte GLOBAL/FUNC symbol (`st_info=18`) at
`0x002B4AA0`. The manifest's **0x610** layout extent includes eight separately
verified zero bytes after that symbol. The existing header's `@size 0x610`
describes that layout extent. The final relocation offset/type map matches;
all **108** target relocations independently resolve to retail's values.

The eleven residual words at `+0x4F0..+0x540` exchange a1/a2 between the NPC
message index and the synthesized four-byte stride. They contain no
relocations. The prologue, palette walk, party forms, message-state reset,
later cost loops, and epilogue match. This does not establish a promotion.
The source guard and all production rows are retained.

## Existing types and resource APIs

The complete menuchr notes were read first, including both previous natural
placement studies. The type and API evidence comes from the existing
[menuchr notes](notes.md), [texture notes](../mg_texture/notes.md),
[NPC configuration notes](../npccfg/notes.md), and
[packed-file notes](../dataread/notes.md).

`CMenuChrCngMenu` is 0x1F80 bytes and inherits the 0x110-byte menu base.
Its genuine `palette.clut` is `u32[CHR_CNG_CLUT_NUM]`, with 256 entries at
`+0x1A80`; the following 0x100 reserved bytes are outside that array.
The existing 0x500-byte constructor clear and header overlay are preserved.

`mgCTexture` is a 0x70-byte texture descriptor, with its typed `u_long128*`
CLUT field at `+0x60`. Retail requests nine quadwords, calls placement
`__nw__FUiP1` once, and calls the real out-of-line
`__ct__10mgCTextureFv` once under the ordinary allocation null guard.
The constructor initializes the descriptor through its normal API. This
scalar out-of-line construction supplies no eligible placement row; no
class override or helper is introduced. The source expresses the actual
allocation as `sizeof(mgCTexture) / sizeof(u_long128) + 2`. The additional
two quadwords describe the measured allocation amount, without assigning
an unobserved purpose to that extra space.

The existing texture manager enters `chr_bg.img` using the base menu's
texture block at `+0x18`, obtains `menueff0` and `chr0`, and reloads that
block through its documented APIs. `GetPackFile(u_int*, char*, int*)`
returns the packed data pointer and optional byte count. The pack parameter
is converted at the packed-file and repair-data interfaces rather than
kept as another alias. `chrchg.cfg` is analyzed once through
`MenuDataAnalyze`; `chr_com.cfg` becomes the menu script. The documented
`CRepairManager::Initialize/SetRepairData` APIs enter the repair data.
`GetPartyCharaInfo` already returns `PARTY_CHARA_INFO*`; its redundant
same-type value cast is removed.

`NPC_BASE_DATA` remains 0x36 bytes, with signed `ability_num` at `+0x30`
and four unsigned ability costs at `+0x32`. Its documented producer
contract permits up to four abilities. The message-fill and subsequent
zero-fill loops remain separate, followed by the independent cost/show
loops. The zero-ability fallback remains message 10. No new clamp,
message-record overlay, reference pun, or extra index is introduced.

## Defined palette walk

The copied CLUT's byte count is `sizeof(palette.clut)`, exactly 0x400.
`MenuCharaChangeCLUT` points at that real array. The retained source uses
a `u32*` cursor over its 256 words and the existing signed entry count:

```cpp
int palette_index = 0;
u32 *clut_words = MenuCharaChangeCLUT;
for (; palette_index < CHR_CNG_CLUT_NUM; palette_index++, clut_words++) {
    u8 *color = reinterpret_cast<u8 *>(clut_words);
    // Existing channel quantization follows.
}
```

`u8` is unsigned char, so this reads and writes each real word's object
representation. Channel indices 0, 1, and 2 access red, green, and blue;
alpha at index 3 is untouched. Each cursor advance selects the next real
word, with the final one-past pointer unused. There is no invented row
type, header change, byte field arithmetic, or additional counter.

The common brief permits genuine typed array walks. This actual-word
ownership form resolves the earlier note's broad rejection of advancing
the cast `PaletteColor*` row alias. The new control was measured once,
after root's explicit direction to test the real word cursor.

Average RGB brightness is integer-divided by three, then converted to
float. The band search retains `8*(step-1) <= brightness < 8*step` and the
actual `<33` bound. The three scale factors are 7.75, 5.625, and 4.6875.
They are arithmetic and conversion inputs, not direct source floating
call arguments. The compiler's three `fptoui` calls arise from the unsigned
byte casts. No floating selector, source helper, or fake call is proposed.

## Bounded measurements

| Private control | Differing words | Native bytes | Relocation map |
| --- | ---: | ---: | --- |
| Fresh current31 | 376/392 | 0x620 | Different |
| Actual size/API cleanup | 376/392 | 0x620 | Different |
| Direct owned-word view by index | 377/389 | 0x614 | Different |
| Existing count initialized before indexed view | 376/392 | 0x620 | Different |
| Global word view by index | 377/389 | 0x614 | Different |
| Real LOCAL layout-cache pointer | 376/392 | 0x620 | Different |
| Actual four-label local table | 376/392 | 0x620 | Different |
| Direct texture-manager owner | 374/394 | 0x628 | Different |
| Captured word base with indexed access | 376/392 | 0x620 | Different |
| Genuine owned-word cursor | **11/388** | **0x608** | **Equal** |

Each native control preserves all 93 actual nonselected functions after
normalizing compiler literal names. Earlier NPC register controls in the
midday assessments are not repeated. The direct-manager count is smaller
than the initial control but its overrun is larger, so it is not retained.

The scalar LOCAL layout cache is actually a four-byte pointer whose only
consumers clear it and remember the analyzed CFG pointer. A separate
private proposal corrects the integer round trip and defines the real
named storage. Keeping its original marker as well duplicates one `.sbss`
piece: that failed receipt is retained. Replacing that exact marker with
the real definition passes the complete wrapper at 0x11CC0 bytes and 3,761
relocations. This independent storage proposal is outside the frozen patch.

Retail's `tbl$1233` is a LOCAL 0x10-byte table of four pointers to the LOCAL
four-byte strings `sp0`, `sp1`, `sp2`, and `sp3`. A separate private real
function-local `tbl` proposal leaves the selected instructions unchanged.
The retail table and string contents are saved in the data census; the
frozen cursor patch preserves their existing storage and declarations.

## Complete audits and freeze

All **87** nonselected manifest score rows are identical to current31;
the native census independently checks **93** nonselected functions,
including binding, symbol/section size, every masked body word, and every
content-normalized relocation. Seven raw reference lists renumber their
compiler literals; their referents and addends are unchanged.

The strict data audit preserves all **101 named objects** and **20 anonymous
objects**, their contents, bindings, sizes, and normalized initializer
relocations. The two nonselected switch tables preserve all six and seven
destination/addend entries. All undefined bindings, four defined vtables,
six undefined vtable names, 429 original storage markers, and 17 captured
header hashes are unchanged. The ten target literals match their actual
retail LOCAL symbol bindings, sizes, and complete null-terminated bytes.

The final guarded private wrapper passes **0x11CC0 bytes /3,761 resolved
relocations** with zero complete-object problems. Its object is byte-identical
to the genuine current31 wrapper control. This verifies the guarded source
and storage layout; the selected native eleven-word residual remains.
No whole-game build, PAL acceptance, production row, source promotion,
shared-header edit, or generated-file change is made by this study.

Freeze directory: `.private/pntc/menuchr-enter-data-natural/`.

- Source: `sources/frozen-best/menuchr.cpp`, SHA-256
  `d60f5057f4f73ef748fd472f7c4add5d4fb01ec38b42ebcd38e97f300ae4e5c1`.
- Measured native object: `outputs/owned-word-cursor/menuchr.o`, SHA-256
  `9013229cae5270853d507c61278d87831c59fccd62913b6494f881f2ed4d030f`.
- Guarded wrapper/control SHA-256:
  `f87f7e6eef64e33dab2537e5ecbffd3f53e2bb2e7cd6559c0079f8e20d4b405a`.
- `frozen-source.diff` compares the exact specimen with current tracked
  source; `frozen-profile.diff` is empty and `frozen-profile.json` retains
  all 31 production rows.
- `m2c-receipt.json`, `inputs.json`, `retail-data-census.json`,
  `all-nonselected-scores.json`, `residual-metrics.json`, and `freeze.json`
  retain commands, hashes, actual sizes, data contents, and controls.
- `outputs/owned-word-cursor/` holds the exact compiler provenance,
  source/profile diffs, full native census, instruction diff, strict data
  audit, and 108-entry resolved-relocation audit.
- `outputs/owned-word-cursor-guarded-wrapper/wrapped/` holds the normal
  wrapper, postprocess, fixup, complete-object logs, and provenance.

Raw positional comparison of the actual 0x608-byte symbols gives 119/386
words; independent relocation masking gives 11/386. Branch-destination
masking and alignment still leave eleven native and eleven retail words.
The canonical layout-extent score remains 11/388. These diagnostic
normalizations do not reduce or waive the residual. The concrete blocker
is the established message-index/stride allocation, with the genuine
four-slot message array and signed ability count preserved.

The normalized coordinator copy is `.private/proposals/menuchr-enter-data-natural-source.patch`; the selected eleven-word function remains guarded and no production row is proposed.

Root independently verifies all 30 entries in the frozen artifact-hash manifest.

## Current design reference

This dated evidence retains its original measurement scope.
[The consolidated placement-conversion design](../satansfiddle/placement-new.md) owns the current
capability, activation rows, safety requirements, and accepted source status.
