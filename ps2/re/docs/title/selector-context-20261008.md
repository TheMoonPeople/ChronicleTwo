# Title phase selectors

`TitleModeKey` is native and exact with five binary32 rows for
`CalcMenuAdd__FPfff`. The rows use real title phase values:

| Value / bits | Control values | Policy | Expected matches |
| --- | --- | --- | ---: |
| 0 / `0x00000000` | `[0]` | Evaluate first | 3 |
| 0 / `0x00000000` | `[1]` | Evaluate first | 1 |
| 128 / `0x43000000` | `[1]` | Evaluate first | 2 |
| 128 / `0x43000000` | `[10]` | Evaluate first | 1 |
| -8 / `0xc1000000` | `[10]` | Evaluate first | 1 |

Phase 0's 8/128 title-alpha call keeps its default schedule; phase 10's
-8/zero menu-alpha call evaluates -8 first. The selectors are disjoint
semantic identities. No sibling-call selector or ordinary-walk policy is
needed. Both mwccgap passes enforce the stated argument counts.

Scalar memory-card snapshots leave five words different after these rows.
The accepted pointer and inserted-byte arrays resolve that allocation;
[matching constraints](matching-constraints.md) records their types, order
and rejected alternatives. The function body is `0x9BC`, with four bytes of
alignment to the following retail boundary. Complete-object and PAL
verification establish the native match. `TitleBootInit` remains guarded.
