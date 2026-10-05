# Complete game-function draft plan

## Scope and completion gate

The game-unit inventory is `progress/report.json` (149 translation units, 6,872
functions after excluding internal `.L` branch labels). SDK and runtime units remain assembly as
required by `AGENTS.md`. Run `python3 scripts/re/coverage.py` after a full build
to count exact matches, guarded C++ drafts, and functions with assembly only.

The draft pass is complete when every game function is either an exact C++
match or has a named, typed C++ definition under `NONMATCHING` with
`INCLUDE_ASM` selected by the normal build. The coverage report must show zero
`asm_only` and zero `fuzzy` functions, and the full game build must verify
byte-identical. A matched function may be promoted only after its linked image
matches the retail image.

## Stages for each translation unit

1. Read its existing reverse-engineering notes and exported m2c/Ghidra output.
   Use `decompile.sh` for any analysis that is missing or uncertain. Record
   dependencies and type sizes before writing a function.
2. Complete names, field types, parameters, and documentation in the relevant
   headers. Keep port accommodations out of PS2 source and headers.
3. Draft every remaining function in address order as ordinary C++. Name each
   local for its role, access fields through their owning type, and avoid raw
   offsets and inline assembly. Document findings in the unit's RE notes.
4. Compile the draft set. Reserve one promotion attempt per function in
   `scripts/re/promotion_attempts.tsv`, using `scripts/re/draft.sh`. Keep an
   exact linked-image match in the normal build. Leave every other draft under
   `NONMATCHING` with its `INCLUDE_ASM` fallback.
5. Run the full build and verify the retail image. Record the unit's remaining
   coverage in `scripts/re/coverage.py` output before assigning another unit.

## Coordination

Agents own disjoint source units and their headers/notes. Only one promotion
or full-build check runs at a time because generated build output is shared.
The initial dependency pass covers `intersection`/`mg_math`,
`maintex`/`dng_status`, and `movieviewlp`/`convviewlp`. Subsequent passes use
the coverage report to take complete units, with foundational types before
their larger callers. The largest units (`event_func`, `userdata`, `menudraw`,
`effscript`, `runscript_opcodes`, and `sceneseq`) need dedicated full-unit
passes after their dependencies are documented.
