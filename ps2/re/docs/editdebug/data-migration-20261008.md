# Native editor debug data

The existing unit notes establish the menu state, editor pages, table layouts,
lighting-local initializers and fish-script callback signatures. All functions
were already matched at checkpoint `96cbdc31`; no functions are promoted here.

All fourteen integer state slots are file-static native definitions. `EventNo`
retains its initial value 100. `SelMax`, `SelData`, `SelText`, `SelHelp`,
`LightSel` and `LightListNum` retain their retail dimensions and row order.
`SelData` addresses the actual `DebugInfo` fields. The help text preserves its
Shift-JIS bytes through hexadecimal escapes.

The cursor, menu, lighting and fish-loading strings are ordinary literals at
use. Existing local pointer arrays, axis vectors, screen anchor, device buffer,
zero pointer template and switch emit their compiler data naturally. No
`LightingEdit` body or fog layout changes. The native fish tag table allows
`tagGyoFish` to use its retail local linkage.

Markers: `INCLUDE_RODATA` **89 → 0**, `INCLUDE_BSS` **15 → 0**.
Objdiff after the required refresh: matched_data **0 → 1949** / total_data **1949 → 1949**.

Every incremental table/literal step passes the PAL verifier and all 149
complete-object comparisons, including resolved relocations. Receipts are
`.private/dataB-r3/editdebug-*-build.log` and `editdebug-*-objects.log`;
`editdebug-progress.log` records the source-only progress refresh.
