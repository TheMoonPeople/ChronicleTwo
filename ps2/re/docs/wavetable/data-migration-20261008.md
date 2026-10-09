# wavetable data migration (2026-10-08)

Baseline `860067a4`, image `chronicletwo_dev:sf-63f7a9e`:
**3 INCLUDE_RODATA / 2 INCLUDE_BSS**, **0 / 49 matched_data**.
After migration: **0 / 0 markers**, **49 / 49 matched_data**.
No function is promoted; the guarded `CWaveTable::Effect` is unchanged.

The two `CreateTexture` color vectors already have natural local
`float[4]` aggregate initializers `{0, 0, 0, 96}`. Those initializers supply
`at_251` and `at_256`, each sixteen bytes. The declared virtual destructor
supplies the twelve-byte `__vt__10CWaveTable`; its remaining piece bytes
are linker alignment. `GetEffect`'s existing local `static int cnt = 0`
supplies the four-byte counter and one-byte initialization guard. The guard's
four-byte retail reservation contains three bytes of alignment padding.
The unused external declarations and all five fallbacks are removed.
No explicit vtable, replacement static state, filler object, or helper is added.

The full PAL build passes `SCES_511.90: OK`, and all 149 complete objects
pass with resolved relocations. All unowned object hashes equal the warm
baseline in both linked and source-only sets. The unit retains four native
functions and one guarded function. Receipts are under `.private/nmchr-r3/`:
`warm-build.log`, `baseline-{build,objects,progress,metrics}.log`,
`wave-native-{build,objects,progress,metrics}.log`, and
`{baseline,wave-native}-state.json`.

There are no retained data markers or unowned-file proposals in this unit.
