# Native models and characters

Kazarov converts MDS, MDT, MOT, WGT and BBP resources into standard glTF 2.0 and an adjacent, pretty-printed `.game.json` document with `schema_version: 1`. A CHR becomes one glTF containing its models as separate scenes and one named animation clip (a Blender action) for every action of its motions. Nested characters become child glTF files under the parent's `.assets` directory. Runtime code opens physical paths directly; no model catalog or alias manifest is published.

The converter follows the documented retail records in mg_dataset.hpp, mg_visual.hpp, gameutil.hpp and visualmotion.hpp. Standard nodes retain frame order, names and parent-child relationships. Static nodes retain matrices; animated nodes use translation, rotation and scale. Animation times use seconds at 30 game frames per second.

The game's conventions already match glTF's, so geometry and static matrices are copied unchanged:

- Axes: both are right-handed with +Y up, in the same units; positions and normals are written as stored. Only the memory-card icon renderer's Y/Z flip is kept for those icons.
- Matrices: the game's row-vector matrices store each basis vector as a row and the translation in elements 12 to 14, which is exactly glTF's column-major layout.
- Winding: MDT points, lines, line strips, triangles, strips and fans become glTF modes 0, 1, 3, 4, 5 and 6 in the stored vertex order, and strips alternate their winding as glTF's do. The renderer treats counter-clockwise faces as front faces (`VK_FRONT_FACE_COUNTER_CLOCKWISE`), as glTF does, and culls back faces only when the game asks, swapping the culled side under a mirroring model matrix.

Retail rotation keys are scalar-first conjugates; they are written as the standard (x, y, z, w) quaternion of the same rotation, and the runtime writes those quaternions straight into frame matrices. The game applies an animated scale after the rotation (translation, scale, rotation), where glTF applies it before (translation, rotation, scale). For each animated frame the exporter picks the simplest standard form that reproduces the game's pose:

- Plain keys, when the game's scale and rotation commute at every frame (uniform scales, or no animated scale).
- Rebaked keys, when they do not commute but the game's pose has no shear: the rotation and scale are recomputed from the game's pose at every game frame of each action. The largest difference from the game's pose between those keys is reported by `dc2data`.
- A child node `<frame>.rotation` holding the rotation, only when the game's pose is sheared by more than a thousandth of its scale, which no single translation/rotation/scale node can express. The parent keeps its original frame node index and the scale; meshes, skins, morph weights and descendants move to the child. Smaller shear is dropped by rebaking and counted in the reported pose difference.

Identical key times and values are stored once per glTF and shared by every clip that uses them.

A rotation key replaces an authored matrix's scale in the game; a clip that rotates a node with authored scale also sets that node's scale to one.

## Actions

Each CFG `KEY` interval is one action and one glTF animation, named in English (see [motion names](MOTION_NAMES.md)); a motion without `KEY` intervals is one action named after its file. Clip times start at zero, and keys the game would interpolate at an action's first and last frame are sampled with the game's own interpolation (including its rotation thresholds) and added there. Where several actions share an interval each still has its own clip. Auxiliary material, visibility, camera and vertex keys are sliced to each action the same way, with step sampling for visibility and linear sampling for the rest. A `KEY` that ends before it starts (one in the retail data: `横飛びL` in `event/e00/e50/e50_monica.chr`) plays as a still pose at its start.

Motions loaded onto an existing character, such as event and extension motions, are published into the models the game loads them onto and never into an animation-only glTF. The extractor reads those loads from the compiled event and map scripts (`_LOAD_MOTION`, and `_LOAD_CHARA` of the pack itself, with constant actors or actors read from globals the script only sets to constants) and from a table of the game code that loads packs itself (fishing, the buggy game and the invent menu). Actor 0 is the player unit, whose model the game picks at run time from the active character and weapon, so those motions go to each player model they fit. Every target must fit the motion's skeleton; [the model format](PORT_MODEL_FORMAT.md#motions-for-other-bundles-models) gives the rules.

Fourteen of the 254 external motions are placed by skeleton match because no load reaches them, and `dc2data` reports each one:

| Motion | Reason | Models |
|---|---|---|
| `event/e00/e50/e50_guiltoni#1`, `event/e300/e352/e352_guiltoni#0`, `event/e500/e536/e536_guiltoni#0` | Scripts load the pack, but its own models do not fit | `event/lm/p00_06vs` |
| `dungeon/chara/c01_fishing#0` | Unloaded; the game loads the copy `chara/c01_fishing` onto the player | Max's player models |
| `menu/chara4/c01_camera#0` | Unloaded; the game loads the copy in `camera.pac` onto the invent menu's Max | `menu/chara4/c01b_think` |
| `event/e200/e209/e208_mints#0` | Unloaded; copy of `event/e200/e208/e208_mints` | That copy's models |
| `event/e700/e712/e207_monica#0` | Unloaded; copy of `event/e200/e207/e207_monica` | That copy's models |
| `sg/sig/sig.pak/mints_bomb#0` | Unloaded; copy of `sg/pb/pb.pak/mints_bomb` | Max's player models |
| `event/e3_event/e3_mints#0`, `event/e700/e712/e712_mints#0` | Unloaded, no copy | Best skeleton fit: `chara/c01_base` |
| `event/lm/monica#0`, `event/lm/mo_vs_gil2/c02_vs2#0` | Unloaded, no copy | Best skeleton fit: `chara/c02_base` |
| `event/lm/mo_vs_gil2/b03a_vs2#0`, `dungeon/monster/b18a#1` | Unloaded, no copy | Best skeleton fit: `event/lm/p00_06vs` | Their clips are named `<bundle>/<action>`.

MDT corner streams become standard position, normal, UV and colour attributes. Sidecar primitive mappings preserve independent source stream identities for CPU deformation. Normalized normals and clamped colours meet glTF requirements. Sparse `stream_overrides` retain only components standard reconstruction cannot reproduce: fourth components, nonunit normals, unclamped colours and unused source elements. Full geometry streams are not duplicated.

WGT data becomes standard joint attributes, weights, skins and inverse bind matrices. Only nonempty lists introduce bones. Inverse binds use inverse(base_bone) * base_mesh, using BBP matrices when available. CPU shadow deformation can exceed the GPU visual's 32-bone limit. MOT TRS lists become standard LINEAR channels of the actions. Vertex motion becomes sparse morph targets and animated weights. Camera, material and visibility operations remain semantic channels where core glTF cannot express them.

Matching stems and explicit profile relationships select candidate animation associations. Referenced frame IDs must fit the model before tracks join its skeleton. A motion that fits no model of its own bundle is published into the models of other bundles it fits. Same-stem standalone resources share one glTF without overwriting geometry.

Each model glTF's binary data is one external `<file>.gltf.bin` buffer (memory-card icons keep theirs embedded) and its images are external PNGs. Default material pictures use standard PBR textures. Character texture sets retain schema 3 semantics in the sidecar, with every mip and variant embedded and level references written as `#/images/N`. Sidecar `images` rows contain an image index and original physical PNG path for direct datapack replacements.

The three retail memory-card icons become pure standard glTF files under title. Each contains 156 vertices, one shape and a constant base-shape animation key, so no animation channel or gameplay sidecar is required. Positions retain the icon renderer's Y/Z flip; normals are unit vectors, UVs and vertex colours are standard attributes, and RGB555 run-length texture data becomes an embedded 128×128 PNG. Native icon rendering reads glTF rather than PS2 model or PACK records.

## Semantic sidecar

Character documents contain `kind: "character"`, models, profiles, default_profile, game_names and resources. Default profile selection follows original CFG member order. Model rows select standard scene and node_offset and preserve native frame-to-mesh identities, draw types, source stream mappings and raw material diffuse/ambient values. Standard geometry, transforms and skin data remain authoritative in glTF. Optional frame.rotation_node identifies an appended shear helper child for native frame collapse.

Profiles hold ordered typed commands. Resource operands use type resource, a kind and integer index into models or the corresponding resource array. Null preserves an absent optional resource. Gameplay values retain their types. Resources include named actions with each model's clips (or, for motions published into other bundles, the published identity and target models), bind matrices, weight lists, cloth commands, texture sets, direct child glTF paths and STB script paths. Standard TRS keys are not duplicated.

STB executable gameplay bytecode remains a separate directly referenced .stb file. Script descriptors identify required texture sets or a child character bundle. CLO data becomes typed commands. Sidecars omit source aliases, opaque source bytes, reserved words, padding and redundant frame matrices. Standalone models and animations use the same native identity concepts without character profiles.

## Publication and validation

Direct proprietary model and CHR files disappear. Ordinary PACKs become physical asset directories with minimal pack.json markers. Only surviving published payloads move into those directories; consumed resources never return from the raw inventory. Embedded scene ranges are scrubbed before directory publication. Duplicate members and embedded offsets receive distinct deterministic physical paths. The distinct standalone a_mu and sukkopu models in etc/gsys.pak use `.model.gltf` names to preserve their sibling character profiles. The identical standalone hake geometry shares its character glTF. Other unresolved character/model collisions fail conversion.

models::verify walks actual glTF/sidecar pairs, validates schemas, embedded PNGs/buffers, accessors and sparse ranges, nodes, materials, skins, inverse binds, animation channels and direct character resources. It rejects retained model and CHR payloads, glTF files with animations but no meshes, skins or model frames, repeated or empty animation names, clips that do not name their action or start before it, `KEY` commands that name no action of their motion, and English names that do not translate their `game_names` original. Tests cover incompatible clips, output collisions, optional standard fields, shadow slots, sparse semantic components, PACK compaction and retained-payload rejection. Ignored tests audit retail PACKs and the extracted disc in isolated outputs.

`tools/kazarov/scripts/audit_blender_gltf.py` imports every published `.gltf` and `.glb` using Blender's actual importer. Run it against `port/run/port_data` with `--blender <executable> --report <report.json> --jobs 6 --batch-size 64`. It resets Blender data between files and recycles each worker after a batch. The pretty JSON summary and adjacent JSONL checkpoint retain per-file outcomes, errors, timings and peak worker memory. A repeated run resumes unchanged files for the same Blender version; `--retry-failed` retries failures and `--no-resume` imports everything again. Timeout or worker termination produces an explicit failed result while unstarted files continue in a fresh worker.

For an audit performed against a private snapshot, rerun the auditor with `--verify-published port/run/port_data --verify-only`. It requires a complete passing report, identical file coverage and unchanged audited fingerprints. Hardlinks are checked by physical file identity; copied files require matching SHA-256 hashes. The result is stored as `published_identity` in the report.
