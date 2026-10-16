# Native rendering and menu state

River and pond masks use stencil bit `0x80` for destination alpha. Mask draws clear that bit without writing colour; ground draws select clear or set coverage through GS `DATE` and `DATM`. Disabling destination-alpha testing removes only that owned stencil pattern. Shadow volumes keep their separate stencil operations and invalidate the destination-alpha mask when they begin.

Auxiliary model renders use `mgPortRenderStateScope`. It restores the actual framebuffer target, logical coordinates, GS registers, camera matrices, projection, clipping, lighting and destination-alpha/shadow state on every exit. This also supports rendering from a nested offscreen target rather than assuming the caller draws to the main frame.

Persistent Fix and Motion faces retain their CPU vertices and indices. A GPU mesh unused for more than 1,800 game frames releases its slot; the next draw uploads the retained geometry again. A failed upload keeps the CPU copy available for immediate submission and a later retry. Ordinary transient face records expire after 600 unused frames.

Embedded glTF images share the bounded native image-decode cache with PNG documents. Keys include the actual model and gameplay JSON candidates, external image candidates and applicable PNG overrides, together with file size and modification time. Logical embedded-image decoding and physical PNG overrides have distinct keys. Anonymous in-memory model documents bypass this file cache.

Native menu mirrors initialize Georama paint selection to return into paint mode on the first visit. Repaint, cancellation and explicitly retained colour-selection pages keep their separate transitions. Geostone announcements reserve all eight nullable message slots traversed by their update and draw loops. Fusion colours copy four floats with `memcpy`, allowing float-aligned ambient fields without requiring quadword alignment.

Focused regressions are `NativeRenderState.*`, `PersistentMesh.*`, `MenuNativeCleanup.*`, and the native model texture/overlay cases. Header-mirror regressions live in `scripts/port/test_header_fixups.py`. The PS2 source and headers remain unchanged.
