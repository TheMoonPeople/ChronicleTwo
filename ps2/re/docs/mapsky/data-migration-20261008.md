# mapsky data migration (2026-10-08)

Baseline: `d56248a7`; 11 `INCLUDE_RODATA` / 3
`INCLUDE_BSS` markers; matched_data 0/195.

The script state is native file-local storage: MAP_SKY_INFO *skyInfo and the
two integer animation counts (`mapsky-parser-storage`). LoadSkyPack uses a
native SPI_TAG_PARAM[8] command table with seven inline keywords in retail
order and a null row. Every callback retains its existing internal linkage
(`mapsky-command-table-retained-empty`).

The existing LoadPack aggregate supplies the 16-byte native
mgCreateVisualType[2] initializer and its pointer relocation; info.cfg is
already an inline literal. Their two markers are removed. One empty-string
marker remains: at_386. Inlining its empty string while removing the visual
initializer marker causes the native anonymous initializer and its string
target to lose piece identity (`mapsky-background-visual-template`,
`mapsky-command-table`; canonical detail in
`mapsky-background-visual-failed-objects.log`). The native initializer's
R_MIPS_32 points at a new compiler anonymous string; the current mapper
cannot establish both identities together. Restoring the empty-string
extern/marker gives a complete-unit match and permits the native aggregate,
configuration literal, command table and all other keyword strings to stay.
No arbitrary string or table-name padding is introduced.

The exact private shared-tool proposal is
`.private/proposals/dataE-anonymous-initializer-graph.patch`. It validates
anonymous initializer graphs rooted in consistent opcode-checked code
references, including the actual R_MIPS_32 fields and each child's declared
size, fixed bytes, and zero alignment tail. It binds the native 16-byte
visual initializer and its one-byte empty string together; cycles and
conflicts remain unresolved. A copied marker-free object passes all bytes
and 137 resolved relocations
(`anonymous-initializer-graph-proposal-objects.log`). Negative tests reject
missing root references, changed fixed bytes, changed child content, missing
retail pointer relocation metadata, and wrong child size
(`anonymous-initializer-graph-proposal-check.log`). The shared scripts and
canonical source retain their accepted forms pending tooling integration.

Read-only review identified two generic graph hazards before tooling
integration: first-root publication could retain a conflicting shared-child
claim, and separate native objects could claim one retail piece. The private
proposal now collects all successful root graphs before publication and
rejects every graph involving a conflicting node destination or retail-piece
owner, including live `D_<address>` definitions. Positive shared-child
agreement checks require exactly one child identity and section owner.
Additional rejection fixtures cover both root iteration orders, cycles,
conflicting code references, duplicate/non-pointer relocation fields, wrong
known targets, and nonzero or oversized alignment tails
(`anonymous-initializer-graph-proposal-edges.log`). Native relocations are
grouped by section and retail relocation ranges use sorted positions plus
bisect, avoiding a complete retail-relocation scan per graph node.

The corrected graph and named-BSS proposals pass the complete comparator
on copies of all 149 objects, including marker-free mapsky/editmap2 and
the native texture-workspace copy (`combined-mapper-proposals-objects.log`).
Retail, symbol, and piece inputs are shared immutably through the existing
explicit function parameters, retaining separate default-reference and
no-reference piece contexts. The actual canonical scripts and objects are
unchanged; linked PAL acceptance of tooling integration remains with the
tooling lane.

Final: 1 rodata / 0 BSS markers; matched_data
92/195 after the standard objdiff/progress refresh.
Every accepted step passes the full PAL build (`SCES_511.90: OK`) and
all 149 complete objects, including resolved relocations. The 148 other
object hashes are unchanged at each step. Function coverage stays
6,770 matched / 93 guarded / nine assembly-only / zero fuzzy.

Validation receipts are under `.private/dataE/`, with the step prefixes
listed above and `-build.log`, `-objects.log`, and `-hashes.log` suffixes.
Final refresh: `mapsky-final-progress.log`, `mapsky-final-coverage.log`,
and `mapsky-final-metrics.json`.
