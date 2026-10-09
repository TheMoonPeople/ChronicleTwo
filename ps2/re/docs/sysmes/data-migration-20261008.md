# sysmes data migration (2026-10-08)

Baseline: `95f8fdd1`; 13 initialized-data
markers and 2 BSS markers. Every function already matches.
The pinned `chronicletwo_dev:sf-63f7a9e` image and full object/PAL checks
validate each accepted step. Public declarations remain compatible.

## Message buffers and language dispatch

`SystemMesBuffer` is `short[0x6800]` (0xD000 bytes), and `SysMesBuffer`
is `short[0x9C40]` (0x13880 bytes). Their existing public header
interfaces remain unchanged. The three native `ClsMes` objects and native
`SystemMesStack` retain their declaration and constructor order.

`LoadSystemMes` already uses inline language-specific paths and a native
language switch. Its twelve string pieces and switch-table piece are emitted
by MWCC without the thirteen redundant markers; its source body is unchanged.
The switch maps Japanese, French, German, Italian, Spanish and the English
default exactly as documented in `notes.md`.

Final markers: **0 RODATA / 0 BSS**, from **13 / 2**. Refreshed
`matched_data` increases from **4/165,476** to **165,476/165,476**.
No function is promoted or changed. Both independently checked steps pass
PAL and all 149 objects; every unowned object hash equals the warm baseline.
Receipts: `.private/dataD/sysmes-buffers-{build,objects,metrics}.log` and
`.private/dataD/sysmes-native-data-{build,objects,metrics}.log`.
