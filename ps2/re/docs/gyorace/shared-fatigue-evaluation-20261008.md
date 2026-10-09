# Shared fatigue correction

The shared header declares `BREEDFISH_USED::fatigue` as u16, consistent
with retail's `lhu` at `sgInitGyoRace +0xB84` and its later unsigned stamina
read. The complete consumer audit and layout evidence are recorded in
[userdata's signedness notes](../userdata/fatigue-signedness-20261008.md).

A by-value `mgRect` assignment in the shared template breaks three active
units and is rejected; see
[the shared assignment evaluation](../mg_tanime/shared-assignment-evaluation-20261008.md).
