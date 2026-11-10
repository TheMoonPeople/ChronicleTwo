# Converted texture format

`dc2data` publishes textures as entries in `data.zip` without a global texture
catalog or runtime source-alias table. Data version 18 introduced the texture namespace;
the adjacent `data.json` marker records the extraction's version. Standalone texture documents use
`schema_version: 3`; adjacent model asset sidecars use `schema_version: 1`.

## Standalone texture documents

All PNG images and standalone texture documents live below `textures/`.
Ordinary source directories remain, while extension-bearing container directory
components such as `.chr`, `.pak`, `.pac`, `.ipk` and `.img` are removed.
For example, `img/menu.img` becomes `textures/img/menu.json` and
`map/room.pac/one.img` becomes `textures/map/one.json`, with numbered PNGs
beside each document. Each document has exactly `schema_version`,
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

Documents are compact UTF-8 JSON.
They omit source bytes, original archive metadata, picture indices, PS2
register values, palettes, and redundant defaults. Physical texture paths cannot contain extension-bearing directory components.
`#entry:N` becomes `-entry-N.json`, and offset sources use `offset-N` in
their document name. Components are escaped; long paths use a stable SHA-256
suffix. Flattened names are disambiguated deterministically and checked for
collisions. PACK tables retain logical member names and record their physical
texture document paths in `pack.json`. A texture outside any PACK keeps its
retail directory and name below `textures/`; extraction fails rather than
rename or move one, as `foo.img` beside `foo.tm2`, or a file in a directory
whose name has a dot such as `v1.0/`, would need. When the game misses a
relative `.json` name, it reads the same name below `textures/`. A script that changes to `event/e100/e110/` and loads
`e110telop01_1.json` reads `textures/event/e100/e110/e110telop01_1.json`.

## Character and model textures

Texture sources consumed by a converted character are incorporated into its
archived `<character>.game.json` asset sidecar. Each
`resources.texture_sets[*].document` retains the version 3 `groups` and
`entries` structure and picture metadata described above. The texture-set
resource also has a `name`. In the embedded document, picture and variant
`levels` contain `#/images/N` references to the companion glTF's standard
`images` array instead of relative PNG filenames. Each referenced glTF image
resolves to a published external PNG entry below `textures/`. Images associated
with a character use the nearest retail `.chr` basename, with one sequence
across embedded documents, pictures, mips and variants. For example,
`chara/hero.chr/body.img` publishes `textures/chara/hero_0.png`,
`textures/chara/hero_1.png`, and so on. The `.game.json` stays beside its model;
glTF image URIs point relatively to these texture paths. Character conversion plans the final
texture and model artifacts from shared source bytes; no temporary standalone
JSON or PNG files are written. A source's conversion-time alias, such as `model.chr#offset:80`, is
not a runtime lookup path.

The sidecar's top-level `images` array provides replacement paths as
`{"image": N, "png": "root/relative/name.png"}`. `image` indexes the glTF
`images` array, and `png` is relative to `data/` or a datapack root. This
mapping covers model material images and embedded texture-set levels. The base
PNG exists once at its archive path and can be overridden by a datapack. The
reader takes logical dimensions from the base PNG and can use a larger valid
datapack replacement for physical pixels. Published glTF uses standard image
fields and has no custom `extras` metadata for these paths.

The versioned `data.json` marker remains, while published trees contain no
global texture catalog or data/asset manifests. `dc2data check` validates the
published documents and their image references. See
[PC port](PC.md#datapacks-and-replacement-textures) for datapack placement.
