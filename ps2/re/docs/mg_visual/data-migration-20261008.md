# mg_visual data migration

Checkpoint `830e48ed` has **17 RODATA / 3 BSS** markers and
**0/516 matched data bytes** after the warm
progress refresh.

The mutable GIF tag uses its existing documented four-word `mgVisualGifTag` type. The aligned 48-byte texture-flush chain retains its real byte-array type, matching the established `mg_texture` representation; the command/register bytes use existing DMA/VIF/GIF/GS names where applicable.

The native eight-entry vertex-writer callback table retains `set_data_func__2`, the retail identity already used by the active code. The inactive draft table is unchanged. Two aligned four-word VIF program templates retain their existing retail symbols and array types. Three documented native state definitions (`start_dma`, `buff_id`, `prev_tex`) preserve the existing header interface and assembly-backed DMA routine's storage. `mat_pw` initializes its actual 128-bit scalar to the low-word value three. The compiler emits the exact FixMDT vtable, preserving assembly-backed `Copy`'s reference.

Retained RODATA markers: `set_tex0_dma__DATA`, `set_tex0_giftag__DATA`, `set_texa_dma__DATA`, `set_texa_giftag__DATA`, `mat_vif__DATA`, `mat_vif_dif__DATA`, `mat_vif_d__DATA`, `mat_vif_d_tex__DATA`. These existing 128-bit scalar objects require nonzero upper words. Shift-based 128-bit constant initialization is rejected by the pinned compiler with `illegal data size` (the water probe). A separate plain wide-hex scalar probe leaves `set_tex0_dma`'s high command word incorrect (two data bytes differ at +0xc); a material-unpack value confined to the upper words becomes zero BSS, causing the postprocessor to reject `.bss` for retail `.data`. Both probes are reverted. Retyping the objects while retaining their scalar loads would introduce new type-puns, so their scalar declarations and markers remain.

The two retained vtable markers are `__vt__13mgCVisualPrim__DATA` and `__vt__12mgCVisualMDT__DATA`. Neither table is emitted by active native source; the MDT table is directly referenced by assembly-backed `Copy`. No forced construction, manual vtable write or new assembly is added. All active packet-copy functions and guarded drafts remain unchanged.

Each accepted step passes the complete PAL build (`SCES_511.90: OK`) and
all 149 canonical object comparisons, including resolved relocations.
The final hash inventory changes only migrated owned units; every unowned
object remains equal to the warm baseline. No guarded function, assembly
entry or existing compiler-profile row changes. No function is promoted.

Accepted receipt prefixes under `.private/dataF/`:
- `mg_visual-mutable-gif-tag` (`-build.log`, `-objects.log`).
- `mg_visual-texture-flush-chain` (`-build.log`, `-objects.log`).
- `mg_visual-vertex-writers` (`-build.log`, `-objects.log`).
- `mg_visual-vif-program-templates` (`-build.log`, `-objects.log`).
- `mg_visual-start_dma` (`-build.log`, `-objects.log`).
- `mg_visual-buff_id` (`-build.log`, `-objects.log`).
- `mg_visual-prev_tex` (`-build.log`, `-objects.log`).
- `mg_visual-native-fix-vtable` (`-build.log`, `-objects.log`).
- `mg_visual-material-control-word` (`-build.log`, `-objects.log`).

Final refresh, coverage and hash receipts are
`mg_visual-documented-final-{refresh,coverage,metrics}.log` in that directory.
Final markers are **10 RODATA / 0 BSS**; refreshed
matched data is **12/516**.

Two additional probes preserve the no-type-pun rule by defining aligned four-word command arrays and copying bytes with `memcpy`; the owned header declares the actual array types. Both fail with the pinned compiler. `mgSetPkTEX0(u_int *, u_long, u_long)` becomes 0x74 bytes and emits a `memcpy` relocation at +0x28; its canonical object reports seven problems, including code and resolved relocation differences. `SetMaterialRef` becomes 0x17c bytes and emits a `memcpy` relocation at +0x30; canonical comparison reports nineteen problems. The latter probe covers material-upload code with its existing optimization settings, separately from the texture helper. These forms are reverted together with the header, and full PAL/object checks are rerun. Early read-only single-unit object receipts are `mg_visual-{set_tex0_dma,mat_vif}-typed-copy-early-object.log`; complete rejected/restored build receipts use the same prefixes. No array retyping with retained scalar loads is used.
