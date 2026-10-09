# Fish tactics control-context calibration

`FishModifyParam__FP12grFISH_PARAMPff` at `0x00323710` builds the six
race-statistic outputs from the entrant's attributes, species, name-seeded
random variation and selected tactics. m2c cannot resolve its tactics jump
table; retail disassembly establishes the actual case labels and call
arguments.

Two binary32 rows in the Satan's Fiddle profile select `GetRandomNumber__Fff`
arguments; both assert `expected_matches: 1`:

| Bits / value | Additional identity | Policy | Retail effect |
| --- | --- | --- | --- |
| `0x3e4ccccd` / 0.2f | `control: {kind: switch, values: [1]}` | `evaluate_first: true` | Orders the tactics-1 range before its mean at `+0x4F4..+0x504` without changing tactics 2 or 4. |
| `0x3e99999a` / 0.3f | Callee only | `evaluate_first: true` | Orders the tactics-5 range before its mean at `+0x68C..+0x6A8`. |

These rows use the real tactics value and floating arguments, without an
occurrence, instruction address, source position or invented call. There
are no overlapping conflicting policies. Only `control` is needed beyond
the callee selector; `argument` and `evaluate_before` are unnecessary.

The RNG state and the name-hash accumulator share their initial value
through `u32 seed = random.seed = 1`; the name hash subsequently reseeds the
RNG before its 1,000-step warm-up. This preserves retail's seed store at
`+0x154` without a dummy object or store. Deleting that initial state store
moves `strlen` and changes the body; aggregate initialization emits
additional constant data; an explicit field read
(`random.seed = 1; u32 seed = random.seed;`) emits a stack reload; hashing
through a seed reference or the generator field exceeds the `0x780` extent.
Separate initializations of the RNG state and accumulator also match.
