# mg_sprite data migration (2026-10-08)

Baseline: `d56248a7`; 7 `INCLUDE_RODATA` / 1
`INCLUDE_BSS` markers; matched_data 0/212.

The existing class definitions supply both compiler-generated vtables
(`mg-sprite-native-vtables`), with exact method relocations and linker tails.
CreateRenderInfoPacket emits its existing zero-vector BSS template once its
marker is removed (`mg-sprite-render-zero-template`).

The named MSCAL/MSCNT arrays are native file-local, aligned u_int[4] tables,
using the existing mgPACKET_CODE enum (`mg-sprite-vif-program-tables`).
A packed u_long128 initializer with a 96-bit shift is rejected by MWCC
as `illegal data size` (`mg-sprite-vif-program-quadwords`); the four-word
representation matches the documented retail format.

The mutable GIF template is a native SpriteGifTagBuf with its four actual
words named loop_flags, prim_flags, registers_lo and registers_hi. Its
initializer uses the existing GIF flags and SDK A+D register descriptor
(`mg-sprite-giftag`). This replaces the inaccurate unknown_04 array with
fields identifying the register-count and descriptor words.

EndCPSprite initializes its existing VifQuad aggregate with MG_VIF_FLUSHA
(`mg-sprite-flush-initializer`), removing the anonymous external initializer.
Reading the aggregate's q member directly in the packet transfer changes
seven linked text bytes (`mg-sprite-flush-quadword`), so the existing packet
transfer is retained. No new packet-copy casts or transport helpers are added.
CreatePacket uses a native `{0, 0, 0, 1}` position array, then writes depth to
its Z component (`mg-sprite-view-position`); its external template and copy
scaffolding disappear. All accepted function instructions remain exact.

Final: 0 rodata / 0 BSS markers; matched_data
212/212 after the standard objdiff/progress refresh.
Every accepted step passes the full PAL build (`SCES_511.90: OK`) and
all 149 complete objects, including resolved relocations. The 148 other
object hashes are unchanged at each step. Function coverage stays
6,770 matched / 93 guarded / nine assembly-only / zero fuzzy.

Validation receipts are under `.private/dataE/`, with the step prefixes
listed above and `-build.log`, `-objects.log`, and `-hashes.log` suffixes.
Final refresh: `mg-sprite-final-progress.log`, `mg-sprite-final-coverage.log`,
and `mg-sprite-final-metrics.json`.

## Function statics (2026-10-09)

`prog_vif` and `progf_vif` are function statics of `mgC3DSprite::EndCPSprite`
(retail `prog_vif$291`, `progf_vif$292`) instead of the file-scope
`prog_vif_291`/`progf_vif_292`. The object stays exact
(`.private/fixes-r3c/b1-*.log`).
