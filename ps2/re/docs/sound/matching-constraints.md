# Sound initialization scheduling

`CSound::Init` is native and exact under the unit's GPR helper-history seed `0x30` and
FPR seed zero. The relevant layout is in [unit notes](notes.md).

## Result

`Init__6CSoundFiiii` is native and matches all 480 words (`0x77C` body plus retail's
padding in the `0x780` extent). The complete sound object passes `0x2DC8` bytes and 700
resolved relocations.

The configuration (`ezmidi_param`) assignments follow the same port order as every other
per-field group in the function: 0, 3, 10, 8, 1, 15, 2, 14, 13, 7, 9, 12, 11. The
previous draft put the shared `0x3039` IDs of ports 2 and 14 before port 10's. That one
difference produced the 12-word residual.

## MWCC list scheduler

The scheduler that orders this block runs before register allocation. Found by watching
the PCode links of the port 11 store (LLDB write watchpoint):

- `0x4AEC20` schedules one block. It builds a dependence node per instruction
  (last to first), computes each node's latest start (`0x4AEA10`: maximum
  height minus node height, node `+0x16`), then issues cycle by cycle. Each
  pick goes through `0x4AEA70`, and the machine model's `can_issue` is
  vtable slot `0x10` of `[0x565AFC]`.
- Node fields: `+0x0C` instruction, `+0x08` successor edges (`+0x04`
  target, `+0x08` latency), `+0x14` earliest cycle, `+0x16` latest start,
  `+0x18` height, `+0x1A` unscheduled predecessors.
- Normal selection among ready, issuable nodes: critical nodes (latest start
  ≤ cycle) first, then the node unblocking more successors (`0x4AEA40`), then
  greater height, then ready-list order (source order).
- Register-pressure mode (`[0x57B6F0]` set and `0x4AE010` true) instead takes
  the smallest register-pressure change (`0x4AE040`): a store that ends a
  value's live range beats a zero store, which beats a new constant. Ties go
  to ready-list order.

In this block, each cycle issues one store and one ALU operation. Constants issue in
source order. In the old draft `li 0x3037` (port 10) followed both shared IDs and issued
at cycle 18. The port 11 zero store was then the best store available at that cycle.
With ports 2 and 14 after port 15, the `0x3037`, `0x3035`, `0x3032` and `0x3031` loads
issue one cycle earlier. Their stores win cycles 18–21 under pressure mode. The port 11
zero store fills cycle 22, the issue cycle of `li 0x3036`, as retail does.

| Configuration statement order | Init words |
|---|---:|
| 0, 3, 2, 14, 10, 8, 1, 15, 13, 7, 9, 12, 11 (previous draft) | 12/480 |
| 2, 14, 10, …, 11, then 0, 3 | 94 |
| 0, 3, 10, …, 11, then 2, 14 | 94 |
| 10, …, 11, then 0, 3, 2, 14 | 93 |
| 0, 3, 10, 2, 14, 8, … | 11 |
| 0, 10, 3, 2, 14, 8, … | 11 |
| 0, 3, 2, 10, 14, 8, … | 12 |
| **0, 3, 10, 8, 1, 15, 2, 14, 13, 7, 9, 12, 11 (port order)** | **0** |

The earlier statement-position sweep of the port 11 zero, chained kind assignments and
per-port grouping are recorded in the notes above. None of them changes when the
configuration constants issue.
