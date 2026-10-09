# sceneseq data migration (2026-10-08)

Baseline: `d56248a7`; 4 `INCLUDE_RODATA` / 0
`INCLUDE_BSS` markers; matched_data 0/364.

## Native dispatch and anonymous data

`ScsCmrSeqCallTbl` is a file-static array of 37 camera-handler pointers,
indexed by `SceneCmrSeqCmd`; `ScsObjSeqCallTbl` is a file-static array of 40
object-handler pointers, indexed by `SceneObjSeqCmd`. Both contain the
retail dummy-handler rows at index zero and at the enum's one-past-valid
index. The tables use their actual overloaded `scs*` functions, with the
corresponding handler definitions made file-static to preserve retail
LOCAL binding. All handler code bytes and relocations remain identical.

The camera table's declared extent is 0x94 bytes, with a twelve-byte
alignment tail belonging to its 0xA0-byte piece. The object table's extent
and piece are both 0xA0. Existing preparation supplies the camera tail;
no padding member or extra callback row is needed.

All eight uses of the empty string are inline. The existing seven-track
`CSceneObjSeq::Play` switch supplies its jump table directly. Their
external declarations and data markers are removed. The existing single
SF selector row is unchanged.

Accepted steps: `sceneseq-empty-string-and-switch`,
`sceneseq-camera-command-table`, `sceneseq-object-command-table`.

Final: 0 rodata / 0 BSS markers; matched_data
364/364 after the standard objdiff/progress refresh.
Every accepted step passes the full PAL build (`SCES_511.90: OK`) and
all 149 complete objects, including resolved relocations. The 148 other
object hashes are unchanged at each step. Function coverage stays
6,770 matched / 93 guarded / nine assembly-only / zero fuzzy.

Validation receipts are under `.private/dataE/`, with the step prefixes
listed above and `-build.log`, `-objects.log`, and `-hashes.log` suffixes.
Final refresh: `sceneseq-final-progress.log`, `sceneseq-final-coverage.log`,
and `sceneseq-final-metrics.json`.
