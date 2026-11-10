# Native asset migration

## Published representation

Kazarov's Rust extractor owns proprietary asset decoding. Data version 9
publishes native assets and the retained retail files together in one archive,
`data.zip` ([format](PORT_ARCHIVE_FORMAT.md)), and leaves out their substituted
originals. The PS2 source and include trees remain unchanged.

The current data version is in `tools/kazarov/data_version.json`. To upgrade an
existing extraction, see [Game data and first run](PC.md#game-data-and-first-run).

| Retail asset | Published representation |
| --- | --- |
| Sound banks and sequences | Versioned semantic JSON and PCM WAV samples |
| Voice streams | PCM WAV |
| Movies | Self-contained MP4 with copied MPEG-2 video and embedded ALAC audio |
| Models, characters and compatible animation | glTF 2.0 with embedded buffers and textures |
| Additional model gameplay semantics | Adjacent, minimal `.game.json` |
| Configuration and textual map scripts | Native semantic `.cfg.json` and `.map.json` documents (schema 2, one `kind` per family) |
| Standalone textures | Versioned texture JSON and PNG images |
| Ordinary PACK archives | Folders containing a versioned `pack.json` |

All published JSON is pretty printed. Model metadata contains only semantics
needed by retail code that standard glTF cannot represent. No custom glTF
`extras` are used. Textures embedded in glTF need no redundant standalone PNG or
texture JSON unless another resource consumes them.

Each ordinary PACK folder retains its archive filename, including its extension.
Nested archives become nested folders. Its `pack.json` contains only
`schema_version: 1` and `kind: "asset_directory"`; it never lists contents.
Characters and sound bundles have their specialized native representations.
See [native asset directories](NATIVE_PACKS.md).

## Runtime integration

The native build rewrites asset references in generated source copies. Game code
and converted script operands reference actual WAV, MP4, JSON, glTF and folder
paths directly. Published catalogs, alias maps and file manifests are absent.
The parent `data.json` records the extraction version, source identity and a
whole-output integrity digest without listing asset paths.

The runtime constructs frames, geometry, materials, skins and animations from
glTF through fastgltf. Typed JSON commands invoke native gameplay callbacks
directly. Directory APIs enumerate actual members. They do not reconstruct
proprietary files or decode binary PACK structures.

Datapacks replace assets by their entry names in `data.zip`.
WAV-only and glTF-only replacements are supported. External references in
replacement glTF files follow the same datapack priority. Loaders validate
candidates and fall back to lower-priority assets when supported replacements
are malformed.

The format contracts are documented in [audio](PORT_AUDIO_FORMAT.md),
[models](PORT_MODEL_FORMAT.md), [configuration](PORT_CONFIG_FORMAT.md),
[textures](PORT_TEXTURE_FORMAT.md), and [script references](PORT_SCRIPT_RESOURCES.md).

## Extraction and validation

Conversion follows raw extraction, then texture, audio, model, configuration,
script-reference and directory conversion. Structural validation checks native
references and rejects retained proprietary containers. Publication stages both
output trees and restores the previous installation on failure. A completed
stage can be reused only after source, version, structure and digest checks.
Source coverage also verifies every gameplay script, including character-bundle
scripts, against its deterministically migrated output before publication or
reuse of a completed stage.

Configuration loaders parse each native semantic document into typed
structures and fill the game's tables directly, with the effects of the retail
tag callbacks; no configuration command list is replayed. They read documents by
path through datapack priority rather than from the original fixed script
buffers, so pretty printing and larger datapack documents cannot overflow those
buffers. The extractor proves each document gives back every value the original
script's callbacks read ([native configurations](NATIVE_CONFIGS.md)).

Validation covers deterministic extraction, sample and movie-frame parity,
configuration callback parity, glTF geometry and animation validity, native
memory allocation, direct directory reads, datapack overrides and gameplay
checkpoints. Production model loading is tested with actual converted character
files as well as synthetic fixtures. Formatting and static analysis accompany
the native and Rust test suites.
