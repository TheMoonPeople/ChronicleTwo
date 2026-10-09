# mg_memory notes

Header: `ps2/include/mg_memory.hpp`. One class (`mgCMemory`), one unowned struct
(`mgMEMORY_BLOCK`, neutral name, no retail name known), one enum (`mgSTACK_MODE`, neutral names).

## Mangling
`P1` is `u_long128*` (`unsigned __int128` mangles as `1`, as in the first game:
`StartReadWepMDS__FP1i`). So `SetHeapMem(u_long128*, int)`, `stSetBuffer(u_long128*, int)`,
`Free(u_long128*)`, `operator new(size_t, u_long128*)` / `operator new[]` (placement news that
return the buffer, `a1`). m2c drops the `int` second argument of `SetHeapMem`/`stSetBuffer` ("read
from unset $a2"); the asm stores `$6` to 0x10 / 0x28.

## mgCMemory (size 0x30)
Size: `__construct_array(..., __ct__9mgCMemoryFv, 0, 0x30, n)` in mglib, editloop, menuchr,
dng_main static initialisers. No destructor. Constructor (`__ct__9mgCMemoryFv`, emitted weak in
mglib at 0x1466A0) only calls `Init()`, so it is declared inline.

| Off | Field | Evidence |
|---|---|---|
| 0x00 | `char name[0x10]` | `Init` does `sb $0,0(a0)`; `stAlloc`/`Alloc` pass `this` as `%s` to "stack over %d/%d at %s\n"; `mgSetPacketBuffer` copies 16 bytes bytewise then 0x10..0x2C as words (implicit struct copy). |
| 0x10 | `u_int heap_size` | `SetHeapMem` stores a2; compared `sltiu 0x10` (unsigned; <16 quadwords -> `Init`); end header at `heap + heap_size*16 - 16`. |
| 0x14 | `u_long128 *heap` | `SetHeapMem` stores a1; `ClearHeapMem` re-passes 0x14/0x10 to `SetHeapMem` after `Init`. |
| 0x18 | `mgMEMORY_BLOCK *heap_top` | `SetHeapMem` = buffer, header {data 0, size 1, next=end header}; `Free`/`StartStackMode` walk `->next` from here. |
| 0x1C | `int lock` | Non-zero -> `stAlloc`/`Alloc`/`stAllocTest` return 0 and `stAlign64`/`Align64` do nothing. Set to 1 elsewhere (e.g. `TotalDataBuff`, `ControlCharaBuff`, `MainCharaBuff`), cleared together with `stack_used` in `mgSetDataBuffer`, `mgSetPacketBuffer`, `LanguageChange`, `MainLoop`. |
| 0x20 | `u_long128 *stack` | `stSetBuffer` a1; `StartStackMode` = new block's `data`; alloc returns `stack + used*16`. |
| 0x24 | `int stack_used` | quadwords used; `EndStackMode` adds it to block size. |
| 0x28 | `int stack_size` | `stSetBuffer` a2; `StartStackMode` = gap quadwords - 1; alloc fails when `used+n >= size` (note `>=`). |
| 0x2C | `mgMEMORY_BLOCK *stack_block` | `StartStackMode` sets/clears; `EndStackMode` tests it. |

No vtable, no base class. No first-game equivalent class; the stack part matches the first game's
`CDataAlloc2` (`dataalloc.hpp`: base/used/limit, `Alloc`, `Alloc64`, `Align64`), and the placement
`operator new(size_t, u_long128*)` pair matches that header too.

## mgMEMORY_BLOCK (0x10)
`{u_long128 *data; int size; int unk_8; mgMEMORY_BLOCK *next;}`. `data` = header + 0x10 (set in
`StartStackMode` as `block + 0x10`; `SetHeapMem` writes 0 for the first header); `size` in
quadwords including the header (`StartStackMode` sets 1; `EndStackMode` adds `stack_used`; gap
after a block = `next - (block + size*16)`). Offset 8 never touched in this unit. The terminating
header has `next == NULL`.

## Behaviour summaries for function bodies
- `Free(p)`: walk from `heap_top` while `next != NULL`, match `data == p`, track previous;
  not found -> `printf("Illegal Free Memory %x\n")` then infinite loop (`b` to itself);
  found -> `prev->next = found->next`. `p == NULL` returns immediately.
- `StartStackMode(mode, size)`: clears `stack_block`; NULL `heap_top` -> NULL. For each block with
  a `next`: gap start = `b + b->size*16`, `gap = (next - start) / 16` (signed division, then used
  unsigned). Mode 1: first gap > 1. Mode 2: largest gap (strict `>`). Mode 3: first gap >
  `size + 1` (unsigned). Then link new header at gap start after the chosen block, size 1,
  `data = header + 1`, `stack = data`, `stack_size = gap - 1`; returns `data`. Mode values seen at
  call sites: 2 (`StartStackMode(&this->unkD10, 2, 0)`), 3 (several). Mode 1 only from the code.
  Ghidra's loop is the clearer reading; m2c renders it as a broken switch.
- `stAlign64`/`Align64` (identical): if unlocked, `r = (stack + used*16) & 0x3F`; if r, `used += (64-r)/16`;
  clamp `used` to `stack_size`.
- `stAlloc`/`Alloc` (identical): locked or `n <= 0` -> 0; `used+n >= size` -> printf
  ("stack over %d/%d at %s\n", used+n, size, this) and 0; else returns old position.
- `stAllocTest`: same without the `n <= 0` check and without committing.
- `stAlloc64`: `stAlign64(); return stAlloc(n);`.
- `mgCopyString(s, m)`: NULL either -> 0; `n = strlen(s)+1` rounded up to quadwords (`>>4`, +1
  if `&0xF`); `Alloc(n)`; `strcpy`; returns the copy (`char*`).
- `MG_ADDRESS_CHECK(p, where)`: p NULL -> `printf("stack over at %s\n", where)` (a1 passes
  through), returns NULL; else p.

## Globals
None besides string literals `at_166`, `at_238`, `at_288` (compiler-generated; no externs).

## Unresolved
- Return type of the alloc functions chosen as `u_long128*` (buffer type; `SetHeapMem` takes the
  `stAlloc64` result directly in callers). Callers cast; does not affect mangling.
- `mgMEMORY_BLOCK::unk_8` meaning unknown; check other units if a use turns up.

## Source notes
- All signatures in the header mangle to retail (`P1` = `u_long128*`).
- Every function is native C++ and byte-identical; the unit has no guarded drafts, `INCLUDE_ASM`
  entries or data markers. The three memory-error format strings are inline literals in
  `MG_ADDRESS_CHECK`, `Free` and the stack allocation.
- `mgCMemory::SetHeapMem` carves `mgMEMORY_BLOCK` headers out of the raw `u_long128` buffer
  (memcpy-like allocator code).
- `ClearHeapMem` saves both `heap` and `heap_size` before `Init()` and passes them back.
- `stAlloc`/`Alloc`/`stAllocTest` overflow printf args: `(used + n, stack_size, name)`.
  `Free`'s printf passes the pointer being freed. `stAllocTest` does print on overflow too.
- `StartStackMode`: `stack_size` is set from the gap of the LAST block examined, not of the chosen
  one. In mode 2 (largest) that is the last gap in the heap, so the region size can be wrong;
  modes 1/3 break on the chosen gap so they agree. Reproduced as written in the draft.
- `StartStackMode`'s gap selection is reproduced as written.
