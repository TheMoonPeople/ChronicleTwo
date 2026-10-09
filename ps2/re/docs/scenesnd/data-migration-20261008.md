# scenesnd data migration (2026-10-08)

Baseline: `95f8fdd1`; 13 initialized-data
markers and 0 BSS markers. Every function already matches.
The pinned `chronicletwo_dev:sf-63f7a9e` image and full object/PAL checks
validate each accepted step. Public declarations remain compatible.

## Bank paths and parser literals

All twelve ordinary strings are inline at their existing uses. `GetNumber3`
retains the `"00"` and `"0"` prefixes and decimal format. The five bank-path
methods retain the BGM, object, environment, battle and base directories;
`GetSeEventFile` retains both bank and effect-number placeholders. `LoadSound`
retains both diagnostic formats and their original argument lists.

`LoadSndFileInfo` compares the exact Shift-JIS time-change prefix, including
its trailing `*`, with hexadecimal byte escapes. `GetLine` initializes its
existing two-byte `LineBreakPair` directly with `{'\r', '\n'}`; MWCC emits
the two-byte template and the verified six-byte piece padding. No string
terminator is added to that pair. The parser and sound behavior are unchanged,
including the existing `SePlayFoot` scheduling profile.

Each string-owning function/group has its own full PAL/object/hash receipt:
`.private/dataD/scenesnd-{number,bgm,source,environment,battle,base,event,diagnostics,time-prefix}-{build,objects,metrics}.log`.
The pair has `.private/dataD/scenesnd-line-break-{build,objects,metrics}.log`.
All steps pass PAL and all 149 objects, with no unowned object hash changes.

Final markers: **0 RODATA / 0 BSS**, from **13 / 0**. Refreshed
`matched_data` increases from **0/260** to **260/260**. All 71 functions
remain matched; none is promoted.
