# Native sound sequence literals

The established unit notes identify the SMF header and track signatures and the
unknown-message diagnostic. Their existing ordinary literals in `LoadSMF` now
supply the data without assembly markers. The signatures remain `MThd` and
`MTrk`; the diagnostic preserves its punctuation and newline. No function body
changes. Each literal removal independently passes all object and PAL checks.


Markers: ROData **3 → 0**, BSS **0 → 0**.
Objdiff after the required refresh: matched_data **0 → 46** / total_data **46 → 46**.

Validation: `SCES_511.90: OK`, **149/149** complete objects including resolved relocations. No functions promoted. Receipts: `.private/dataB-r3/snd_seseq-final-build.log`, `snd_seseq-final-objects.log`, `snd_seseq-progress.log`.
