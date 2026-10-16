# Converted texture format

`dc2data` publishes textures under `port_data/` without a global texture catalog
or runtime source-alias table. The current extraction is data version 8, recorded
in the parent `data.json` marker. Standalone texture documents use
`schema_version: 3`; adjacent model gameplay sidecars use `schema_version: 1`.

## Standalone texture documents

A retail source such as `img/menu.img` becomes `port_data/img/menu.json` with
PNG files beside it. A PACK member `bundle.pac/one.img` becomes
`port_data/bundle.pac/one.json`. Each document has exactly `schema_version`,
`groups`, and `entries`. IMG, IM2, TIM2, and empty sources have `groups: [0]`.
IMG3 sources list their distinct nonnegative block IDs in ascending order,
retaining gaps such as `[0, 2, 4]`; an IMG3 source with only CFG entries has
`groups: []`. An entry's `block` defaults to zero and appears only for another
block. This preserves the game's texture-group numbering.

A texture entry has `name`, optional `block`, and `pictures`. Multiple TIM2
pictures in one retail IMG entry remain in one `pictures` array. Each picture
has `levels`, an array of PNG filenames relative to its document directory,
starting with the base image and followed by mip levels. A picture without
image data has `canvas: {"width": ..., "height": ...}` in place of `levels`;
it creates no placeholder PNG. Normal image dimensions come from the base
PNG's IHDR. The port retains that logical size when a datapack supplies a
larger replacement image.

Optional `variants` on a picture list additional baked colour images as
`{"selector": "logical texture name", "levels": ["menu_2.png"]}`. The
default variant is the picture's own `levels`, selected by its entry name.
The selector is the logical texture identity used by animation scripts, not a
path to a palette. PNG names advance across every picture, mip, and baked
variant in one document: `menu_0.png`, `menu_1.png`, and so on. A CFG-only
document creates no PNGs. Its entries have only `name` and the parsed `script`
commands and arguments.

Optional picture `animation` is `copy` for 4- or 16-bit retail textures and
`copy_variant` for 8-bit retail textures; `draw` for 24- or 32-bit textures is
implicit. Optional `sampler` overrides only nondefault properties. `wrap_u`
and `wrap_v` may be `clamp` when the corresponding retail CLAMP register field
is nonzero; omitted wrap values mean `repeat`. The filter defaults to `linear`
because the runtime uses linear filtering after entering a texture. A
consumer may express a nondefault `nearest` filter, although retail conversion
does not emit it.

Documents are UTF-8 JSON, indented by two spaces with a trailing newline.
They omit source bytes, original archive metadata, picture indices, PS2
register values, palettes, and redundant defaults. Physical paths cannot
contain `.img` directories: an intermediate `.img` component becomes `-img`,
`#entry:N` becomes `-entry-N.json`, and `#offset:N` becomes an
`embedded-offset-N.json` child of the wrapper path. Components are escaped;
long paths use a stable SHA-256 suffix. Conversion rejects path collisions.
Retail names inside PACK tables remain unchanged.

Some zero-entry PACK members keep historical embedded-offset PNG names. For
example, `bundle.pac/frametex.json` can refer to a sibling
`embedded-offset-N_0.png`; a nested document such as `map.json` can refer to
the same image with a relative path. The JSON document path still follows the
PACK member name. These PNG paths remain valid datapack override paths.

## Character and model textures

Texture sources consumed by a converted character are incorporated into its
`<character>.game.json` gameplay sidecar. Each
`resources.texture_sets[*].document` retains the version 3 `groups` and
`entries` structure and picture metadata described above. The texture-set
resource also has a `name`. In the embedded document, picture and variant
`levels` contain `#/images/N` references to the companion glTF's standard
`images` array instead of relative PNG filenames. Each referenced glTF image
contains the base PNG raster in a standard `data:image/png;base64,...` URI.
The consumed character source's temporary standalone JSON and PNG files are
removed after model publication; a PNG shared with an unconsumed document is
retained. A source's conversion-time alias, such as `model.chr#offset:80`, is
not a runtime lookup path.

The sidecar's top-level `images` array provides optional replacement paths as
`{"image": N, "png": "root/relative/name.png"}`. `image` indexes the glTF
`images` array, and `png` is relative to `port_data/` or a datapack root. This
mapping covers model material images and embedded texture-set levels; the PNG
need not exist in the base published tree. A datapack can provide it at that
path. The reader takes logical dimensions from the embedded glTF raster,
then tries a valid datapack PNG for the physical pixels and falls back to the
embedded raster if none decodes. When a datapack replaces the glTF document
itself, its image data is used directly. Published glTF uses standard image
fields and has no custom `extras` metadata for these paths.

The versioned `data.json` marker remains, while published trees contain no
global texture catalog or data/asset manifests. `dc2data check` validates the
published documents and their image references. See
[PC port](PC.md#datapacks-and-replacement-textures) for datapack placement.
