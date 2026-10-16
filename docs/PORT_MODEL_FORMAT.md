# Native model and character assets

The PC runtime reads actual root-relative glTF paths, such as `chara/c01_base.gltf`, through datapack priority. Each glTF has an adjacent pretty-printed `c01_base.game.json` containing the additional semantics required by gameplay. There is no runtime model catalog, source-alias registry, CHR archive, or extension translation in this loader. Assets originally nested in archives use explicit `.assets` directories.

glTF contains standard nodes, meshes, materials, images, embedded buffers, skins, and animations. Character bundles expose their component models as named scenes. Custom game semantics live in the adjacent JSON rather than glTF extras. The JSON uses `schema_version: 1` and `kind: "character"`, `"model"`, or `"animation"`.

## Gameplay JSON

Character JSON contains `models`, a `profiles` object keyed by semantic names such as `info`, and a `resources` object. Each model records its standard scene, first node offset, stable native frame identities, primitive flags and original stream identities needed by CPU deformation. Standalone model JSON contains these model fields directly.

| Resource | Required native meaning |
| --- | --- |
| `animations` | Standard animation index, compatible model variants, and auxiliary material, visibility or camera channels. |
| `bind_poses` | Frame matrices used by native deformation and replacement skins. |
| `weights` | CPU deformation channels, including shadow meshes with more than 32 joints. |
| `cloths` | Typed native cloth commands. |
| `scripts` | Actual script paths and effect texture dependencies. |
| `children` | Actual child glTF paths. |
| `texture_sets` | glTF image references, mip chains, variants and typed texture animation commands. |

Profiles retain ordered commands so model selection, motion slots, keys, sequences, sounds, cloth, outlines, attachment frames, effects and LOD settings preserve their native order. Scalar arguments use the typed configuration representation. Resource arguments contain `type: "resource"`, a resource `kind`, and an integer `index`; a null index represents an optional absent resource. No proprietary resource filename is resolved by the profile dispatcher. Unknown named commands have the same skip behavior as the game interpreter.

Base rigs can contain authored proxy triangles rather than a complete character.
For example, `mainchr/c01_base.gltf` supplies Max's base rig, while
`mainchr/c01fuku1.gltf` contains his textured outfit geometry. The game equips
clothing, footwear and headwear separately. These placeholders are preserved
from the original asset rather than synthesized by the exporter.

Animated native transforms apply translation, scale and rotation in an order
that a single standard glTF TRS node cannot always express. Standard parent and
child nodes preserve that order. Optional `rotation_node` mappings in gameplay
JSON associate the extra nodes with the original game frames; the glTF remains
independently importable without that JSON.
Animation-only variants use a `rotation_nodes` object mapping standard helper
node indices to original frame indices. Skins and morph channels reference the
standard helper nodes, while the runtime preserves the original frame count
and gameplay attachment identities.
Standalone files containing clips with a different hierarchy use
`animation_node_offsets` to identify each shifted clip's first node; their
globally indexed `rotation_nodes` mapping also covers those clips.

Primitive stream maps restore original vertex and normal identities from expanded glTF corners. Sparse `stream_overrides` preserve only components that standard glTF cannot represent faithfully, including raw game colours and unused stream entries. Standard geometry and node transforms remain authoritative. A replaced glTF can change primitive and accessor counts; the loader generates native stream identities for the replacement layout while preserving gameplay frame semantics.

## Images

glTF images are external PNG files, never `data:` URIs. Each image `uri` is a relative URI reference resolved against the glTF file's own directory, as the glTF specification requires. Segments are separated by `/`, `..` segments climb toward the archive root, and every byte outside the unreserved set (`A-Z a-z 0-9 - . _ ~`) is percent-encoded, so `tex/stone 0.png` is written `tex/stone%200.png`. A URI never contains a scheme, query, fragment, leading `/`, or encoded `/` or `..`, and never resolves above the archive root. Several images can name the same PNG; the file exists once in the archive.

The referenced PNG is the standalone converted texture level, such as `map/d01/tex/stone_0.png` referenced from `map/d01/room.gltf` as `tex/stone_0.png` or from `map/d01/floor/room.gltf` as `../tex/stone_0.png`. Texture levels consumed by models remain published when a glTF references them, even after their texture document is folded into the gameplay JSON. Memory-card icons have no texture document; the extractor writes the icon's PNG beside its glTF with the same stem (`icon.gltf` references `icon.png`).

Image rows contain `image`, the standard image index, and `png`, the archive path that image's URI resolves to. Datapack replacements of that PNG path take precedence. The PNG dimensions define the game's logical texture size. Datapack PNG replacements can have larger physical canvases while logical dimensions stay fixed. A replaced glTF supplies its own images. Texture sets use `#/images/N` references and retain picture, mip, animation and variant behavior without separate texture documents.

Buffers remain embedded `data:application/octet-stream;base64,` URIs.

The extractor's model audit rejects embedded images, malformed or escaping URIs, URIs that do not name an existing PNG file with exactly matching case, and image rows whose `png` differs from the resolved URI.

Character image slots own native texture sets rather than IMG byte buffers. Replacing a slot retains texture names, registration suffixes and material bindings while preserving other slots. Monster reserved images retain parsed texture documents and their decoded mip variants; initialization invalidates their slots and dataset reset releases their native ownership.

Different model documents can embed the same shared texture set. Native registration reuses a picture only when its manager, block, suffixed name, logical dimensions, sampler and every decoded mip variant match. Every variant is decoded once during registration and retained for later variant switches. It compares immutable originals so playing texture animations do not cause new registrations. Changed pictures replace the existing header in place; texture deletion and manager initialization discard the previous registration. Identical live texture animation groups are reused as well.

## Native runtime

`model_assets::LoadModel`, `LoadCharacter`, `LoadSkin`, and `LoadAnimation` accept explicit glTF paths. In-memory overloads require both actual glTF bytes and explicit gameplay JSON. They allocate game frames, visuals, materials, face lists, weights and animation records directly in the supplied game arenas. The character metadata bridge calls only native gameplay setters; resource callbacks use the direct glTF loader. The original MDS, MDT, MOT, WGT and CHR parsers are outside these asset paths. Procedural `mgCMDTBuilder` geometry remains available.

`LoadModelScene` selects a standard scene by name within a bundle. Plain standard
models need no gameplay JSON: their selected scene supplies node identities and
hierarchy directly, including noncontiguous node indices and multiple scene
roots. Converted bundles retain their original gameplay frame mappings.

Standard animation supports LINEAR, STEP and CUBICSPLINE interpolation, quaternion interpolation, sparse morph accessors and motion blending. glTF seconds convert to the native 30-frame timeline without rounding evaluation times. Auxiliary channels continue through the native gameplay evaluator. Standard skins retain all numbered `JOINTS_n` and `WEIGHTS_n` groups. GPU motion visuals preserve the retail behavior of retaining and normalizing the first four influences, with 32 joint slots; requested shadow visuals retain every CPU deformation channel and support larger retail shadow skeletons.

Generated base clips retain the game's quaternion interpolation thresholds in
the native evaluator, including its near-opposite snap. Their standard glTF
channels remain independently playable in Blender. Replacement glTF clips use
standard interpolation and standard rotation-before-scale composition, including
nonuniform scales. Converted helper nodes collapse to the game's original frame
identities and scale-before-rotation composition. Constant helper scale-reset
channels reset authored matrix scale without overwriting the gameplay object's
independent scale.

`EstimateCharacterMemory` counts native allocation sizes for the selected profile, geometry, motion keys, effects, cloth and texture animation records. It returns arena bytes rather than estimating from the serialized JSON size.

Costume loading checks each reset slot against this native estimate before character construction. Slots that exceed their retail partition use separately owned aligned storage; existing menu pool boundaries remain intact. Equipped weapon slots also reserve their native sword-trail records. Animation-only character bundles can extend an existing character without containing a placeholder model scene.

Memory-card icon models use pure standard glTF without gameplay JSON. The shared icon renderer reads standard scenes and their external images directly; its optional candidate resolver supports glTF replacements and invalid-overlay fallback.

Generated glTF must also import successfully in Blender. The offline
`tools/kazarov/scripts/audit_blender_gltf.py` imports every file through Blender's
actual glTF importer, using bounded background workers and resumable per-file
results. This complements fastgltf validation of the complete extracted corpus.

Invalid glTF or JSON overlays fall back through lower-priority candidates. Invalid hierarchy cycles, stream references and unsupported GPU limits produce diagnostics. Focused tests cover direct models, explicit in-memory data, ordered character profiles, fractional animation, interpolation, morphs, texture precedence, collision attributes, CPU shadows and effect allocation.
