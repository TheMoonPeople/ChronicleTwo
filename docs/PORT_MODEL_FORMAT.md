# Native model and character assets

The PC runtime reads root-relative glTF paths, such as `chara/c01_base.gltf`, through datapack priority. Each glTF has an archived, compact `c01_base.game.json` asset companion; character settings are tracked in pretty-printed `port/gameplay/<stem>.character.json` and published compact at the same path in `data.zip`. There is no runtime model catalog, source-alias registry, CHR archive, or extension translation in this loader. Assets originally nested in archives use explicit `.assets` directories.

glTF contains standard nodes, meshes, materials, images, binary buffers, skins, and animations. External buffers use adjacent `.gltf.bin` files. Character bundles expose their component models as named scenes. Asset semantics live in the adjacent `.game.json` rather than glTF extras. It uses `schema_version: 1` and `kind: "character"`, `"model"`, or `"animation"`.

## Asset and gameplay JSON

Archived character `.game.json` contains `models`, a `resources` object and image references. Each model records its standard scene, first node offset, stable native frame identities, primitive flags and original stream identities needed by CPU deformation. Standalone model JSON contains these model fields directly. Archived `.character.json` contains `profiles` keyed by semantic names such as `info`, `game_names`, `default_profile`, and indexed `cloth_commands` rows. The runtime combines these gameplay fields with the asset metadata.

| Resource | Required native meaning |
| --- | --- |
| `animations` | Named actions with their lengths and auxiliary material, visibility, camera or vertex keys, and the glTF clip of each action for every model it drives. |
| `bind_poses` | Frame matrices used by native deformation and replacement skins. |
| `weights` | CPU deformation channels, including shadow meshes with more than 32 joints. |
| `cloths` | Asset cloth entries; their typed commands are indexed in gameplay JSON. |
| `scripts` | Actual script paths and effect texture dependencies. |
| `children` | Actual child glTF paths. |
| `texture_sets` | glTF image references, mip chains, variants and typed texture animation commands. |

Character profiles retain ordered commands so model selection, motion slots, keys, sequences, sounds, cloth, outlines, attachment frames, effects and LOD settings preserve their native order. Scalar arguments use the typed configuration representation. Resource arguments contain `type: "resource"`, a resource `kind`, and an integer `index`; a null index represents an optional absent resource. No proprietary resource filename is resolved by the profile dispatcher. Unknown named commands have the same skip behavior as the game interpreter.

Base rigs can contain authored proxy triangles rather than a complete character.
For example, `mainchr/c01_base.gltf` supplies Max's base rig, while
`mainchr/c01fuku1.gltf` contains his textured outfit geometry. The game equips
clothing, footwear and headwear separately. These placeholders are preserved
from the original asset rather than synthesized by the exporter.

Transforms use glTF's own conventions: column-major matrices, translation, then
rotation as an (x, y, z, w) quaternion, then scale. The game composes an animated
scale after the rotation instead; where the two orders give different poses the
exporter rebakes the frame's rotation and scale keys at every game frame. A frame
whose game pose is sheared by more than a thousandth of its scale, which no translation/rotation/scale node can express,
keeps a child node holding its rotation, named `<frame>.rotation`; the model's
`frames[n].rotation_node` names that child. Skins and morph channels reference the
child, while the runtime keeps the original frame count and gameplay attachment
identities.

## Named actions

Every action the game plays is its own glTF animation (a Blender action). An action
is one CFG `KEY` interval of a motion, named in English from the original name (see
[motion names](MOTION_NAMES.md)); a motion without `KEY` intervals is one action
named after its file. Clip times start at zero; keys the game would interpolate at
an action's first and last frame are added there, so each clip starts and ends on
the game's exact pose. A motion shared by several models of a bundle has one clip
per model; the second and later are named `<action>@<scene>`.

An animation resource lists its actions in `KEY` order and, per model, the clip of
each action:

```json
{
  "actions": [
    {"name": "idle", "duration": 2, "channels": []},
    {"name": "walk", "duration": 20, "channels": [/* auxiliary keys in action frames */]}
  ],
  "variants": [{"model": 0, "node_offset": 0, "animations": [0, 1]}]
}
```

`duration` is the action's length in game frames. An action without transform or
morph keys has a null clip.

Profiles name actions, never frame ranges. `KEY` takes the English action name and
the step; `SE`, `SELP`, `SEQ_START` and `SEQ` name actions and sequences in English,
and sound frames are ratios of their action. The bundle's `game_names` object maps
every English name its profiles use to the original typed string argument. The
runtime hands the game those originals, so game code and scripts that compare the
retail names keep working; keeping the originals beside the English names avoids
any translation table at run time.

### Motions for other bundles' models

Event and extension motions have no skeleton of their own: the game loads them onto
a character that already exists, such as Max or Monica in a cutscene. Their actions
are published into the models the game plays them on, never into a glTF of their
own; a glTF holding animations without geometry or skins is invalid. The motion's
resource in its own bundle names the published entry and the models holding it:

```json
{"external": "event/e100/e100/e100_mints.gltf#0",
 "actions": [{"name": "walk_looking_around", "duration": 40}],
 "targets": ["mainchr/c01_base.gltf", "mainchr/c01_base0.gltf"]}
```

Each target bundle carries the same `external` identity in its own animation
resources, with the action keys and that model's clips, named
`<bundle>/<action>` (`e100_mints/walk_looking_around`). At run time the action
clips come from the bundle of the model the character was built from.

The models come from the game's own loads:

- Event and map scripts load a motion pack into an event-scene actor with
  `_LOAD_MOTION` (or a pack's own profile with `_LOAD_CHARA`). The actor is a
  constant, or a global slot the script only ever sets to constants, in which case
  every such value counts. Actor 0 is the scene's player unit. Any other actor holds
  the pack the same script function last loaded into it with `_LOAD_CHARA`, or, when
  the function loads none, any pack the script loads into it; when none of those
  fit, every pack the script loads into that actor is considered. A pack loaded with
  `_LOAD_CHARA` also offers its own models.
- Game code loads a few packs itself: `chara/c01_fishing.chr` (fishing) and
  `sg/pb/pb.pak/mints_bomb.chr` (the buggy game) into the scene's player character,
  and `menu/chara4/camera.pac/c01_camera.chr` and `menu/chara4/c01_success.chr`,
  `c01_regret.chr` and `c01_failure.chr` into the invent menu's character,
  `menu/chara4/c01b_think.chr`.
- The player unit is whichever model `SetupMainUnit` loaded, chosen at run time by
  the active character and melee weapon: `mainchr/c01_base2` to `c01_base5` for
  Max, `mainchr/c02_base0` to `c02_base3` for Monica, or `chara/c01_base` and
  `chara/c02_base` in edit mode. A motion loaded onto it is published into each of
  those models that exists and whose skeleton it animates.

A model receives a motion only when its skeleton fits: it has every frame the
motion keys, and its skeleton family (models with identical frame names) matches
at least half of the motion's first translation keys, within 0.2 of the best
candidate. A motion no load reaches but some script names, through arguments that
cannot be followed statically, is published into every model it fits this way. A
motion nothing loads or names is kept too: it goes into the models of a loaded copy
of the same pack (a pack with the same file name, such as `chara/c01_fishing.chr`
for `dungeon/chara/c01_fishing.chr`) when they fit, and otherwise into the single
model its skeleton fits best, preferring a player model. `dc2data` reports every
such placement.

Primitive stream maps restore original vertex and normal identities from expanded glTF corners. Sparse `stream_overrides` preserve only components that standard glTF cannot represent faithfully, including raw game colours and unused stream entries. Standard geometry and node transforms remain authoritative. A replaced glTF can change primitive and accessor counts; the loader generates native stream identities for the replacement layout while preserving gameplay frame semantics.

## Images

glTF images are external PNG files, never `data:` URIs. Each image `uri` is a relative URI reference resolved against the glTF file's own directory, as the glTF specification requires. Segments are separated by `/`, `..` segments climb toward the archive root, and every byte outside the unreserved set (`A-Z a-z 0-9 - . _ ~`) is percent-encoded, so `tex/stone 0.png` is written `tex/stone%200.png`. A URI never contains a scheme, query, fragment, leading `/`, or encoded `/` or `..`, and never resolves above the archive root. Several images can name the same PNG; the file exists once in the archive.

The referenced PNG is the standalone converted texture level, such as `map/d01/tex/stone_0.png` referenced from `map/d01/room.gltf` as `tex/stone_0.png` or from `map/d01/floor/room.gltf` as `../tex/stone_0.png`. Texture levels consumed by models remain published when a glTF references them, even after their texture document is folded into archived asset JSON. Memory-card icons have no texture document; the extractor publishes the icon's PNG beside its glTF with the same stem (`icon.gltf` references `icon.png`).

Image rows contain `image`, the standard image index, and `png`, the archive path that image's URI resolves to. Datapack replacements of that PNG path take precedence. The PNG dimensions define the game's logical texture size. Datapack PNG replacements can have larger physical canvases while logical dimensions stay fixed. A replaced glTF supplies its own images. Texture sets use `#/images/N` references and retain picture, mip, animation and variant behavior without separate texture documents.

A model glTF's binary data is one buffer stored beside it as `<file>.gltf.bin`
(`chara/c01_base.gltf` uses `c01_base.gltf.bin`), referenced by the same kind of
relative URI as images. Datapack replacements of either file take precedence; a
replacement glTF can also embed its buffers as `data:` URIs, and memory-card icon
glTFs, which the desktop-icon renderer reads on its own, keep theirs embedded. The extractor's model
audit rejects a buffer file without its glTF, a buffer URI other than the glTF's own
`.gltf.bin`, and a buffer shorter than its declared length.

The extractor's model audit rejects embedded images, malformed or escaping URIs, URIs that do not name an existing PNG file with exactly matching case, and image rows whose `png` differs from the resolved URI.

Character image slots own native texture sets rather than IMG byte buffers. Replacing a slot retains texture names, registration suffixes and material bindings while preserving other slots. Deleting a slot removes only the pictures last entered from its sets. Monster reserved images retain parsed texture documents and their decoded mip variants; initialization invalidates their slots and dataset reset releases their native ownership.

Different model documents can embed the same shared texture set. A plain model whose embedded set is already registered under its pictures' names, as a map piece's copy of the set its map entered into the map's blocks, uses those registrations and does not enter the set again. Native registration reuses a picture only when its manager, block, suffixed name, logical dimensions, sampler and every decoded mip variant match. Every variant is decoded once during registration and retained for later variant switches. It compares immutable originals so playing texture animations do not cause new registrations. Two documents can carry their own copies of one PNG, so a picture whose source files differ is still reused when its first variant decodes to the registered pixels and its other variants have the same names. Changed pictures replace the existing header in place; texture deletion and manager initialization discard the previous registration. Identical live texture animation groups are reused as well.

## Native runtime

`model_assets::LoadModel`, `LoadCharacter`, `LoadSkin`, and `LoadAnimation` accept explicit glTF paths. In-memory overloads require both actual glTF bytes and explicit gameplay JSON. They allocate game frames, visuals, materials, face lists, weights and animation records directly in the supplied game arenas. The character metadata bridge calls only native gameplay setters; resource callbacks use the direct glTF loader. The original MDS, MDT, MOT, WGT and CHR parsers are outside these asset paths. Procedural `mgCMDTBuilder` geometry remains available.

`LoadModelScene` selects a standard scene by name within a bundle. Plain standard
models need no gameplay JSON: their selected scene supplies node identities and
hierarchy directly, including noncontiguous node indices and multiple scene
roots. Converted bundles retain their original gameplay frame mappings.

Standard animation supports LINEAR, STEP and CUBICSPLINE interpolation, quaternion interpolation, sparse morph accessors and motion blending. glTF seconds convert to the native 30-frame timeline without rounding evaluation times. Auxiliary channels continue through the native gameplay evaluator. Standard skins retain all numbered `JOINTS_n` and `WEIGHTS_n` groups. GPU motion visuals preserve the retail behavior of retaining and normalizing the first four influences, with 32 joint slots; requested shadow visuals retain every CPU deformation channel and support larger retail shadow skeletons.

Generated clips retain the game's quaternion interpolation thresholds in
the native evaluator, including its near-opposite snap. Their standard glTF
channels remain independently playable in Blender. Replacement glTF clips use
standard interpolation. Rotation keys are written straight into the frame's
rotation rows from the (x, y, z, w) quaternion and translation keys into its
translation row. A game model's frame keeps its whole authored transform in its
matrix with unit scale, so a scale gameplay sets applies in the game's order
(after the rotation, in the parent's axes), unless an animation scales that node
to a value other than one: such a frame composes rotation before scale, as glTF
does, with the node's scale in the frame's scale. A replacement or other non-game
glTF composes rotation before scale on every translation/rotation/scale node. A
scale key of one on a frame whose authored scale is in its matrix is not written:
it only restates the reset the frame's rotation keys already made, and writing it
would discard a scale gameplay set. Shear helper nodes
collapse to the game's original frame identities and scale-before-rotation
composition. Copied frames keep the convention of the frame they copy.

The game plays motion sets through `KEY` intervals of game frames. The loader gives
every action of a character its own interval: the first starts at frame 2, and each
next one starts two frames after the previous one ends, continuing after every
interval the character's other motion sets use. The game's `KEY` records hold
those intervals under the original names, so its frame stepping, ratios, sound cues
and name and ordinal lookups run unchanged. Posing a frame selects the action whose
interval holds it and samples that action's clip at the frame's offset into it.
A blend samples the action last posed on the character, even when that action
belongs to another motion set, and the newly selected action.

`EstimateCharacterMemory` counts native allocation sizes for the selected profile, geometry, motion keys, effects, cloth and texture animation records. It returns arena bytes rather than estimating from the serialized JSON size.

Costume loading checks each reset slot against this native estimate before character construction. Slots that exceed their retail partition use separately owned aligned storage; existing menu pool boundaries remain intact. Equipped weapon slots also reserve their native sword-trail records. Event and extension bundles without models extend an existing character with actions published into that character's own model bundle.

Memory-card icon models use pure standard glTF without gameplay JSON. The shared icon renderer reads standard scenes and their external images directly; its optional candidate resolver supports glTF replacements and invalid-overlay fallback.

Generated glTF must also import successfully in Blender. The offline
`tools/kazarov/scripts/audit_blender_gltf.py` imports every file through Blender's
actual glTF importer, using bounded background workers and resumable per-file
results. This complements fastgltf validation of the complete extracted corpus.

Invalid glTF or JSON overlays fall back through lower-priority candidates. Invalid hierarchy cycles, stream references and unsupported GPU limits produce diagnostics. Focused tests cover direct models, explicit in-memory data, ordered character profiles, fractional animation, interpolation, morphs, texture precedence, collision attributes, CPU shadows and effect allocation.
