# mg_texture data migration (2026-10-08)

Baseline: `d56248a7`; 7 `INCLUDE_RODATA` / 1
`INCLUDE_BSS` markers; matched_data 432/66076.

The duplicate-texture diagnostic is inline at its printf use. Existing
native source supplies the VRAM diagnostic, IM/IMG/IM2/IM3 signatures,
and texture-capacity diagnostic once their markers and unused externs
are removed (`mg-texture-literals`). All seven initialized markers are
removed without changing instructions or resolved relocations.

The 64 KiB conversion workspace marker remains. A natural file-local
`static u_char conv_work_1306[0x10000]` with 16-byte alignment compiles,
but the PAL link fails: generated libdev.s.o requires an external
conv_work_1306 symbol (`mg-texture-conversion-storage`). The generated
library assembly contains three inferred pointer words at 0x36423C,
0x364244 and 0x36439C, with retail values 0x00390501, 0x00390501 and
0x00386459. Actual retail relocation metadata has **no relocation at any
of those three addresses** (`mg-texture-false-library-references.log`).
They are address-shaped numeric data, so exporting the workspace to
satisfy them would retain an incorrect cross-unit dependency and contradict
the documented retail LOCAL binding.

The exact shared-tool proposal is private:
`.private/proposals/dataE-unrelocated-data-words.patch`. It extends the
existing byte-verified unrelocated-word restoration to initialized data
sections, preserving genuine retail relocations. It is not applied or
committed because scripts/build belongs to the tooling lane. The workspace
probe is reverted and verified (`mg-texture-conversion-storage-revert`);
its marker and existing extern remain until tooling removes those inferred
library references. No exported replacement or raw-offset workaround is
introduced.

A follow-up copied object with the native file-static aligned workspace
passes every byte and all 160 resolved relocations
(`mg-texture-workspace-proposal-objects.log`). Its canonical link still
reports only the inferred external library dependency, as expected
(`mg-texture-workspace-proposal-input-build.log`). The exact source
follow-up is `.private/proposals/dataE-mg_texture-after-tooling.patch`; it
is not applied to the accepted source. The workspace is restored afterward
and all 149 objects plus the full PAL pass
(`mg-texture-workspace-proposal-source-restored`).

The corrected graph and named-BSS proposals pass the complete comparator
on copies of all 149 objects, including marker-free mapsky/editmap2 and
the native texture-workspace copy (`combined-mapper-proposals-objects.log`).
Retail, symbol, and piece inputs are shared immutably through the existing
explicit function parameters, retaining separate default-reference and
no-reference piece contexts. The actual canonical scripts and objects are
unchanged; linked PAL acceptance of tooling integration remains with the
tooling lane.

Final: 0 rodata / 1 BSS markers; matched_data
540/66076 after the standard objdiff/progress refresh.
Every accepted step passes the full PAL build (`SCES_511.90: OK`) and
all 149 complete objects, including resolved relocations. The 148 other
object hashes are unchanged at each step. Function coverage stays
6,770 matched / 93 guarded / nine assembly-only / zero fuzzy.

Validation receipts are under `.private/dataE/`, with the step prefixes
listed above and `-build.log`, `-objects.log`, and `-hashes.log` suffixes.
Final refresh: `mg-texture-final-progress.log`, `mg-texture-final-coverage.log`,
and `mg-texture-final-metrics.json`.
