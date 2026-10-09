# Mglib matching pass at 0c33a7e

The pinned image is `chronicletwo_dev:sf-d8bf13c`; every diagnostic uses the
repository Satan's Fiddle wrapper and canonical MWCC 3.0-011126 `-O3,p`
flags. Existing pragmas are preserved. The prior unit notes, compiler notes,
parked list and earlier private experiment ledger were read before trials.
The three large targets were inspected through `decompile.sh`/m2c. Existing
native functions and their documented types were re-used without re-analysis.

## Results

These are positional word differences with relocation operands masked and
retail alignment padding included. Only complete-object comparisons establish
resolved byte/relocation equality. All four functions remain guarded.

| Symbol | Base draft | Retained draft | Native / retail extent |
| --- | ---: | ---: | --- |
| `VSyncCallBack__Fi` | 20/32 | 20/32 | 0x70 / 0x80 |
| `mgInit__Fii` | 584/652 | 168/652 | 0xA30 / 0xA30 |
| `mgSetPkFrameBuffer__Fiiii` | 355/424 | 252/424 | 0x680 / 0x6A0 |
| `mgEndFrame__FP14mgCDrawManager` | 232/672 | 232/672 | 0xA34 / 0xA80 |

The whole native diagnostic retains 97 exact functions. `GetScreenSize` was
already native; restoring its linkage is not a new function promotion.
`mgEndFrame`'s unsuccessful variants are not retained.

## GetScreenSize and framebuffer setup

The existing binding analysis is confirmed by the retail ELF:
`GetScreenSize__FiPiPiPiPiPiPi` is LOCAL at 0x141990, size 0xC0. Its source
was still global. `static` restores the documented scope without changing
the function's instructions, and lets MWCC keep the framebuffer pointer in
retail's `t3` across that call. Existing `mgSCREEN_MODE` members replace the
numeric case labels. Unknown input normalizes to 512x448; other modes select
512x416, 512x480 or 640x448, with bounds centered around zero.

`mgSetPkFrameBuffer`, at 0x144490, reads missing FBP/PSM arguments from the
current draw frame, fills missing dimensions from `GetScreenSize`, centers
the screen bounds, rounds frame width to 64 pixels, constructs FRAME,
XYOFFSET and SCISSOR register values, writes six GS address/data pairs and
builds the framebuffer texture metadata.

The selected `sceGsFrame` is an eight-byte register union, already exposing
`value` and named bitfields. Initializing a local directly from `*default_frame`
uses its compiler-generated copy constructor; no hand-written special member
is introduced. Declaring XYOFFSET and SCISSOR after that local preserves the
retail stack slots: FRAME +0x60, XYOFFSET +0x68, SCISSOR +0x70, dimensions
+0x78/+0x7C. The masked comparison is exact through +0x26C.

The improvements are 355 -> 348 words for local linkage, 348 -> 271 for
copy construction, and 271 -> 252 for the register declaration scopes.
The next window emits the DMA/VIF header, GIF tag, and TEXFLUSH, FRAME_1,
XYOFFSET_1, SCISSOR_1, SCANMSK, TEXFLUSH pairs. Retail derives a signed word
count from the packet endpoint; the current draft reserves a constant 32
words and folds away that computation. Address subtraction and raw cursor induction are excluded by the source rules. Texture width/height/
bpp remain the documented signed-short members of the 0x70-byte `mgCTexture`;
VRAM and image block counts are integers, and TEX0/1 have real packed views.
Later metadata and logarithm/power loops still differ in allocation.

## Initialization structure and dither types

`mgInit`, at 0x141A50, resets DMA/GS state, chooses screen dimensions, clears
VRAM, prepares the double buffer and two draw contexts, uploads VU1 programs,
installs the vertical-sync callback, and initializes the dither matrix.
The existing 0x14-byte `sceDmaEnv` has `notify` at +6. Its retail stack slot
is +0x60; the 8192-quadword clear buffer begins at +0x80, and the load-image
descriptor begins at +0x20080. No SDK/type layout is changed.

The two ZBUF context snapshots reproduce the actual eight-byte temporary
copies at stack +0x50 and +0x58. Each snapshot is used to initialize one
`mgRenderInfo.draw_env` entry, whose existing 0x40-byte type has ZBUF at
+0x20. Both double-buffer depth bases use the same `frame_buf1 * 2` value.
Applying the integer back-colour conversions to both clear contexts allows
the compiler to retain the four converted channels as retail does, rather
than loading bytes from the first context. Screen bounds precede depth
assignment, restoring the early store scheduling. The frame size and masked
instructions agree with retail from entry through +0x31C.

Retail `dimx$281` at 0x338440 is 16 bytes, and local `mgDIMX` at 0x37CEB8 is
eight bytes. The conversion loop has an outer one-preset iteration with a
16-byte source stride and an inner 16-cell loop unrolled eight cells at a
time. A separate packing loop has the same 16-byte source stride and an
eight-byte destination stride. This supports `signed char dimx[1][16]` and
`sceGsDimx mgDIMX[1]`; these are evidenced dither presets, not a fabricated
constructor array. Each coefficient is divided by two and reduced by four.
Packing uses 32-bit `sllv` terms before ORing into the eight-byte register;
the later sixteen named three-bit field assignments supply the complete
matrix. Hoisting a cast to `u_long` before the shift produces a different
64-bit shift sequence.

Scoping `preset`, `cell` and the packed accumulator to their actual phases
restores the retail loop registers. The second packing loop and the final
field-writing window, +0x714 onward, agree in the retained masked comparison.
Remaining differences begin at +0x320: background/frame-register store order,
ZBUF context-copy ordering, and the first conversion-loop entry. Its inner
unrolled conversion instructions already agree.

## Frame-end and interrupt boundaries

`mgEndFrame`, at 0x142C20, draws optional performance bars, submits the frame,
reads four requested depth samples, waits for the frame interval, optionally
captures the image/draws a console, updates display registers and rotates
the draw buffer. A depth request reads an 8x8 neighborhood and records its
minimum 24-bit depth. The SDK transfer and CPU sample views cover the same
4096-byte aligned storage. A typed word buffer or a union of quadword/pixel
arrays produces 239/672 words, versus the retained 232/672; its more direct
symbol loads alter the initial depth-mask allocation. The first actual
remaining offsets are +0x550, +0x554 and +0x560. Unrelated instructions agree
through +0x6CC; the display window begins differing at +0x6D0.

Casting FRAME fields before wide shifts, using their named `bits` view,
changing the commutative AND order, or scoping a display pointer does not
solve the display packing/addressing. Regenerating display bases at each
hardware write enlarges the function without improving its score. The
baseline body is retained. The previous +0x540/+0x6C0 locations were artifacts
of a disassembler listing that suppressed a run of zero instructions; the
current diagnostic disassembles with `-z`.

Retail's mglib `VSyncCallBack` is LOCAL at 0x141870, size 0x7C plus alignment
padding. The available SDK exposes an out-of-line `EIntr`, but no installed
SDK/compiler header supplies the required inline `sync; ei` sequence.
It stays guarded. Restoring the documented local scope privately for
`WaitVSync`, `StoreImage`, and the callback, separately and together, leaves
all four residual scores unchanged; only `GetScreenSize`'s useful change is
retained. Existing static `prim_clip_check` and `CheckVuProgID` are unchanged.

## Negative experiments and promotion limits

| Hypothesis | Result and disposition |
| --- | --- |
| FRAME named bits / value assignment / memcpy | Named bits and value assignment leave the old score unchanged; memcpy reaches 345/424, weaker than direct copy construction. |
| Move FRAME copy before GetScreenSize | 401/424; not retained. |
| Integer bpp and separate 16-bit cases; scoped or while dimension loops | Best remains 252/424; no improvement over the simpler retained body. |
| Initialize both dimension counters together | 253/424; not retained. |
| Count down power-loop iterations | 254/424 and shortened non-retail loops; not retained. |
| Dither preset array with scalar destination | 527/652; array destination gives 439/654 before the other fixes. |
| Clear-colour conversion sharing | 417/652 before context snapshots and nested counter scopes. |
| Context snapshots; common depth base; scoped dither loops; screen ordering | 426/654 -> 245/652 -> 174/652 -> retained 168/652. |
| Sequential context snapshots or copying the already-written ZBP field | 247/652 or 420+/654 depending on the earlier fixes; not retained. |
| Background-colour loop, assignment chaining or alpha-before-blue | No useful improvement. |
| Packed TEST/ALPHA value views instead of inherited type-puns | 420/652; not retained as a matching change. |
| memset GIF-tag reset | 596/654; not retained. |
| Depth word/union views and explicit display re-packing | 239/672 or worse; no frame-end improvement. |

The exhaustive score index is private `experiment-index.md`. Earlier helper
mask trials were not repeated. No floating scheduling difference supports a
new Satan's Fiddle row. Promotion additionally requires scrubbing each entire
body's inherited register type-puns, including GIF-tag/register stores,
XYOFFSET/SCISSOR views and the display word; those guards are preserved.
No shared header, profile row, toolchain file or replacement assembly is changed.
