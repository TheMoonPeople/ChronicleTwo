# Shared fog colour representation

`mgFOG_PARAM` is 0x30 bytes with the near/far distances at 0/4 and the colour
bytes at 8..11. Retail's lighting editor merges the RGB cases and accesses the
selected unsigned byte through a base-plus-index displacement of 6, which the
typed `fog->color[edit - 2]` subscript reproduces once `color[4]` overlays the
named `r/g/b/a` fields in a union. The renderer, fog setter, map lighting and
script consumers use the named RGB fields; adding the union changes no
allocated bytes, layout or relocation in any object (the only other object
change is a renumbered anonymous label in sceneload's non-allocated
`.strtab`). The resulting `LightingEdit` is in [notes.md](notes.md).
