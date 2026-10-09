# dataread data migration (2026-10-08)

The fresh round-2 baseline has 19 rodata markers and 4 BSS markers, with
`matched_data` 552 / `total_data` 339554. All functions already match and
the existing notes document the file/cache/device structures and behavior.

## File paths and diagnostics

All 19 string markers and their extern declarations are removed. File and
device names, current-directory reset strings, and load/cache diagnostics
are literals at their existing uses. The two background-read diagnostics
already occur as native literals and need only their markers removed.
The exact disc filenames keep the leading backslash and `;1` suffix.
The empty string and slash are distinct retail objects, emitted naturally
by the two default-device transitions.

Acceptance: `.private/dataC-r2/dataread-literals-{build,objects}.log` and
`dataread-literals-metrics.json`. The full image and all 149 objects pass,
and every unowned object hash is unchanged. No rodata markers remain;
coverage is 850 / 339554, pending the four local BSS templates.

## Local path and prefix templates

The three 256-byte paths and the 16-byte device prefix now use local
`char` arrays initialized with `""`. The path/prefix quadword unions and
all four extern template declarations are removed. Initializers stay at
the point the original template copy executes: after the background-read
argument checks, after the cache-hit return, after device selection, and
at the start of `WriteFile`, respectively.

MWCC assigns stack arrays in declaration order. Moving the initialized
background path below the existing scratch path swapped their stack slots
(seven differing bytes); declaring the scratch path after the initializer
restores the retail offsets. The same applies to `LoadFile2`'s `sce_stat`
local (14 differing bytes in the first trial). The accepted declarations
keep the full path before these independent scratch buffers.

Acceptance: `.private/dataC-r2/dataread-load-path-ordered-{build,objects}.log`
and `dataread-load-path-ordered-metrics.json`. The complete image and all
149 objects pass and every unowned object hash is unchanged. Three BSS
markers are removed; the unit has 0 rodata / 1 BSS marker, and native data
coverage remains 850 / 339554 while the final BSS piece is retained.

### Terminal BSS extent blocker

`at_845` has a declared retail extent of 0x100 at 0x003EC290. Its split
piece reaches the next unit's BSS start at 0x003EC3C0, adding 0x30 bytes.
The natural `WriteFile` initializer emits exactly 0x100 bytes and preserves
every code byte and resolved reference. Removing the final marker passes
the PAL verifier but fails the object checker with two extent-only
problems: size 0x100 versus piece 0x130, and BSS run end 0x003EC390 versus
0x003EC3C0. The checker currently accepts terminal data padding only when
the gap is fewer than 16 bytes. Receipt:
`.private/dataC-r2/dataread-write-path-{build,objects}.log`.

`INCLUDE_BSS(at_845, 0x130)` therefore remains to preserve the existing
canonical acceptance contract. The source uses the natural array even
with that fallback piece. Enlarging the local path to imitate section
padding would change the retail stack frame and is not a justified source
form. A generic linker-tail proposal belongs to the tooling lane.

## Typed background-read and disc-header accesses

`LoadFileBG` writes the established `BG_READ_INFO::buffer`, `size`, and
`sectors` fields directly instead of indexing an `int*` view of the queue
entry. Its device and read-mode decisions use the existing enums.
`CDRead` keeps the `DATA_HEADER*` returned by `SearchFile` and reads its
`name`, `size`, and `sector` fields instead of indexing a second integer
view. The field offsets and signed integer arithmetic are unchanged.

Acceptance: `.private/dataC-r2/dataread-bg-fields-{build,objects}.log` and
`dataread-cd-header-fields-{build,objects}.log`. Every code byte and resolved
relocation remains exact; both complete images, all 149 objects, and all
unowned hashes pass. Data counts and the single parked marker are unchanged.

## Typed cache allocation and global declarations

`NowCacheAddress` and the pending `LoadFileCacheBG` buffer use
`u_long128*`, matching the existing cache base and request-buffer type.
Downward initialization subtracts four quadwords (64 bytes); subsequent
allocations move by the aligned byte count divided by 16. The pointer
updates preserve the original instruction bytes without integer-address
round trips. Read-size and allocation-direction tests use their existing
enum constants. Every file-scope data definition has a purpose comment.

Acceptance: `.private/dataC-r2/dataread-cache-pointer-final-{build,objects}.log`
and `dataread-cache-pointer-final-metrics.json`. The complete PAL image,
all 149 objects, and every unowned object hash pass. The unit remains
0 rodata / 1 BSS marker and 850 / 339554 native data bytes.

Making `header_buff` file-local, as its retail binding suggests, currently
leaves references unresolved in `intr`, `libgraph`, `libdev`, and
`e_rem_pio2`. The split library assembly identifies unrelocated numeric
words as symbol references; changing game-source binding cannot repair
that interpretation. The declaration therefore keeps its established
external binding. Receipt:
`.private/dataC-r2/dataread-static-header-build.log`; the shared-tool
proposal is `.private/proposals/dataC-r2-library-numeric-words.patch`.

## Terminal-tail tooling proposal validation

The exact proposed checker change is
`.private/proposals/dataC-r2-terminal-data-tail.patch`. It uses the generated
linker's `contents_end` instead of a fixed padding-length limit. Declared
retail size, absence of tail relocations, and zero initialized bytes remain
required. The patch includes large-tail, wrong-size, wrong-end, relocation,
truncation, and nonzero-tail regression cases plus the MWCC documentation
clarification. Shared files remain untouched.

Private copies of the proposed tooling normalize the marker-free source-only
object with unchanged code snapshots. The canonical check accepts 0x1DD2
initialized bytes and 281 resolved relocations; the last path remains a
0x100-byte object with the 0x30-byte alignment tail supplied by the existing
linker script. Linking both this object and the marker-free `editdata` object
with every other normal input produces `SCES_511.90: OK`.
Receipts: `.private/dataC-r2/proposals-{prepare,objects,link,pal}.log`.
This validates the proposed tool behavior; the committed source retains its
single marker until the tooling lane integrates the shared change.

The numeric-library-word proposal was also exercised read-only against
the current library inputs. It restores every inferred `header_buff`
expression in the four failing library units only where the retail ELF has
no relocation, preserving the exact commented word bytes. The complete
scan covers 316 words in 18 files and leaves generated files untouched.
Receipt: `.private/dataC-r2/library-word-proposal-check.log`.

## Round-4 terminal marker removal

The native `WriteFile` path template supplies the final 0x100-byte BSS object.
Its declared end is the generated linker's `contents_end`; the following
0x30-byte alignment tail is linker-owned. The canonical checker now verifies
that exact boundary rather than limiting the gap to fifteen bytes. The
`at_845` marker is removed without changing function bodies.

Validation: `.private/dtool-r4/dataread-{build,objects,tests}.log`; PAL is
byte-identical, all 149 objects pass, and every other game object hash and
the code metric are unchanged. Markers are 0 rodata / 0 BSS.
Native data coverage is recorded in `dataread-metrics.log`.
