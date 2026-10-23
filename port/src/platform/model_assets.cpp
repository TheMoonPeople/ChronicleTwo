#include "common.h"

#include <fastgltf/core.hpp>
#include <fastgltf/tools.hpp>
#include <nlohmann/json.hpp>
#include <stb_image.h>

#include <algorithm>
#include <array>
#include <bit>
#include <cmath>
#include <cstdint>
#include <cstdio>
#include <cstring>
#include <limits>
#include <map>
#include <memory>
#include <mutex>
#include <span>
#include <stdexcept>
#include <string_view>
#include <unordered_map>
#include <unordered_set>
#include <utility>

#include "character.hpp"
#include "character_metadata_bridge.hpp"
#include "character_motion.hpp"
#include "command_replay.hpp"
#include "dynamicanime.hpp"
#include "effect.hpp"
#include "gameutil.hpp"
#include "mg_dataset.hpp"
#include "mg_math.hpp"
#include "mg_shadow.hpp"
#include "mg_texture_port.hpp"
#include "mg_visual_port.hpp"
#include "mglib.hpp"
#include "monster.hpp"
#include "outline.hpp"
#include "platform/datapacks.hpp"
#include "platform/legacy_encoding.hpp"
#include "platform/model_assets.hpp"
#include "profile.hpp"
#include "visualmotion.hpp"

int conv_new_text(char *, char *);

namespace model_assets {
namespace {
using Json = nlohmann::json;
using Matrix = std::array<float, 16>;

/** Native stream size keys, in POSITION, NORMAL, TEXCOORD_0, COLOR_0 order. */
constexpr std::array<const char *, 4> kStreamCounts{"vertex_count", "normal_count", "uv_count", "colour_count"};
/** Per-primitive stream identity keys, in the same order. */
constexpr std::array<const char *, 4> kStreamMappings{"source_vertices", "source_normals", "source_uvs", "source_colours"};
/** Preserved native stream value keys, in the same order. */
constexpr std::array<const char *, 4> kStreamValues{"positions", "normals", "uvs", "colours"};

/**
 * Returns the index words per face corner: a position, then a normal, UV and colour when the face has them.
 */
int IndexStride(int type) {
    return 1 + !(type & MG_FACE_NO_NORMAL) + !(type & MG_FACE_NO_TEXTURE) + !!(type & MG_FACE_COLOUR);
}

/**
 * Runs body and reports whether it succeeded, storing a thrown exception's message in error.
 */
template <class Body>
bool Attempt(std::string &error, Body &&body) {
    try {
        body();
        error.clear();
        return true;
    } catch (const std::exception &exception) {
        error = exception.what();
        return false;
    }
}

/**
 * Names byte contents by two independent 64-bit hashes and their length.
 */
std::string ContentHash(std::span<const std::byte> bytes) {
    constexpr std::uint64_t prime1 = 0x9E3779B185EBCA87ull;
    constexpr std::uint64_t prime2 = 0xC2B2AE3D27D4EB4Full;
    constexpr std::uint64_t fnv = 0x100000001B3ull;
    std::uint64_t           mixed = prime1 ^ bytes.size();
    std::uint64_t           folded = 0xCBF29CE484222325ull;
    const auto              absorb = [&](std::uint64_t word) {
        mixed = std::rotl(mixed + word * prime2, 31) * prime1;
        folded = (folded ^ word) * fnv;
    };
    std::size_t offset = 0;
    for (; offset + 8 <= bytes.size(); offset += 8) {
        std::uint64_t word = 0;
        std::memcpy(&word, bytes.data() + offset, sizeof(word));
        absorb(word);
    }
    if (offset < bytes.size()) {
        std::uint64_t word = 0;
        std::memcpy(&word, bytes.data() + offset, bytes.size() - offset);
        absorb(word ^ (std::uint64_t{0xFF} << 56));
    }
    const auto avalanche = [](std::uint64_t value) {
        value ^= value >> 33;
        value *= 0xFF51AFD7ED558CCDull;
        value ^= value >> 33;
        value *= 0xC4CEB9FE1A85EC53ull;
        return value ^ (value >> 33);
    };
    char text[48];
    std::snprintf(text, sizeof(text), "%016llx%016llx:%llu", static_cast<unsigned long long>(avalanche(mixed)),
                  static_cast<unsigned long long>(avalanche(folded)), static_cast<unsigned long long>(bytes.size()));
    return text;
}

/**
 * A standard glTF document and its adjacent native gameplay semantics.
 */
struct Document : std::enable_shared_from_this<Document> {
    std::shared_ptr<fastgltf::Asset>                                           storage;               /**< Shared standard glTF contents for every scene of a bundle. */
    fastgltf::Asset                                                           &asset;                 /**< Parsed standard model, material, skin, and animation data. */
    std::shared_ptr<Json>                                                      custom;                /**< Adjacent minimal game-specific JSON. */
    std::shared_ptr<Json>                                                      images;                /**< Image replacement paths stored in the gameplay JSON. */
    std::unordered_map<std::size_t, std::shared_ptr<texture_catalog::Source> > texture_sets;          /**< Stable native image and animation sets. */
    Json                                                                       metadata;              /**< Engine-specific decoded model information. */
    std::filesystem::path                                                      relative;              /**< Model path used to resolve external resources. */
    bool                                                                       overlaid = false;      /**< Whether a datapack supplies this model document. */
    std::string                                                                source;                /**< Datapack glTF path, size and write time naming its embedded images. */
    std::size_t                                                                node_offset = 0;       /**< First standard node belonging to the selected native model. */
    std::unordered_map<std::size_t, std::size_t>                               rotation_nodes;        /**< Standard rotation helpers mapped to their original gameplay frame. */
    std::vector<std::size_t>                                                   frame_nodes;           /**< Standard scene nodes mapped to native frames when gameplay identities are absent. */
    std::optional<fastgltf::Node>                                              scene_root;            /**< Identity parent joining multiple roots of a standard scene. */
    bool                                                                       standard_only = false; /**< Whether the standard scene supplies all model identities. */
    mutable std::unordered_map<std::size_t, std::string>                       embedded_keys;         /**< Content identities of embedded images by standard image index. */
    std::shared_ptr<const std::vector<bool> >                                  scaled_nodes;          /**< Standard nodes some animation scales to other than one, once computed. */

    explicit Document(std::shared_ptr<fastgltf::Asset> input) : storage(std::move(input)), asset(*storage) {}
};

/**
 * Returns a character bundle's resources, or the whole gameplay JSON of a single model.
 */
const Json &Resources(const Document &document) {
    return document.custom->contains("resources") ? document.custom->at("resources") : *document.custom;
}

/**
 * Enters the complete native texture set required by a standard model scene.
 */
void EnterTextureSet(const std::shared_ptr<Document> & /*document*/, std::size_t /*index*/, const CharacterLoadOptions & /*options*/, CCharacter2 * /*character*/, int /*slot*/);

/**
 * Enters only texture sets explicitly required by the selected model.
 */
void EnterModelTextures(const std::shared_ptr<Document> &source, std::optional<std::size_t> model, const CharacterLoadOptions &options, CCharacter2 *character) {
    if (source->custom->contains("models")) {
        const auto &selected = source->custom->at("models").at(model.value_or(0));
        for (const auto &set : selected.value("texture_sets", Json::array())) {
            EnterTextureSet(source, set.get<std::size_t>(), options, character, 0);
        }
    } else {
        const auto &sets = source->custom->value("texture_sets", Json::array());
        for (std::size_t index = 0; index < sets.size(); ++index) {
            EnterTextureSet(source, index, options, character, 0);
        }
    }
}

/**
 * Parsed documents shared by the model and its associated motion resources.
 */
std::unordered_map<std::string, std::shared_ptr<Document> > documents;

/**
 * Standard inverse-bind matrices shared by copied visuals through their weight arrays.
 */
/**
 * Standard glTF inverse binds of a skin and the hierarchy they were loaded with.
 */
struct InverseBinds {
    mgCFrame          **frames = nullptr; /**< Frame table the skin's joints index. */
    int                 frame_id = 0;     /**< Frame holding the skinned mesh. */
    std::vector<Matrix> matrices;         /**< Inverse bind of each joint. */
};

std::unordered_map<const mgVertexWeight *, InverseBinds> inverse_binds;

/**
 * An animation sampler retained alongside a native channel for exact glTF interpolation.
 */
struct NativeChannel {
    std::shared_ptr<Document>  document;                /**< Document retaining the channel's accessor buffers. */
    fastgltf::AnimationSampler sampler;                 /**< Standard interpolation and input/output accessors. */
    std::vector<float>         times;                   /**< Exact key times in game frames. */
    std::size_t                morph_targets = 0;       /**< Number of scalar morph weights per key, or zero for TRS. */
    bool                       helper_scale = false;    /**< Whether scale belongs to the rotation helper rather than the gameplay object. */
    bool                       retail_rotation = false; /**< Whether generated base motion uses the game's rotation interpolation thresholds. */
};

/**
 * Tracks standard replacement scaling and a collapsed helper's authored child transform.
 */
struct FrameConvention {
    bool                 standard_scale = false; /**< Whether object scale uses standard rotation-before-scale order. */
    bool                 matrix_scale = false;   /**< Whether a non-unit authored scale lives in the matrix, which rotation keys replace. */
    bool                 helper = false;         /**< Whether an original gameplay frame collapses a standard rotation helper. */
    Matrix               child_base{};           /**< Rotation helper matrix before its separate authored scale. */
    std::array<float, 3> child_scale{1, 1, 1};   /**< Current standard rotation-helper scale. */
};

/**
 * Retains conventions only for initialized native asset frames.
 */
std::unordered_map<const mgCFrame *, FrameConvention> &FrameConventions() {
    static std::unordered_map<const mgCFrame *, FrameConvention> frames;
    return frames;
}

/**
 * Rebuilds the authored matrix from a helper's rotation and scale without changing gameplay position.
 */
void ApplyHelperScale(mgCFrame &frame, const FrameConvention &state) {
    for (int column = 0; column < 3; ++column) {
        for (int row = 0; row < 4; ++row) {
            frame.trans_matrix[column][row] = state.child_base[column * 4 + row] * state.child_scale[column];
        }
    }
    frame.changed = 1;
}

/**
 * Standard samplers indexed by their corresponding arena-allocated motion channel.
 */
std::unordered_map<const Mot_List *, NativeChannel> native_channels;

/**
 * A character model whose bundle holds the actions of motions published from other bundles.
 */
struct MotionOwner {
    std::shared_ptr<Document> document;  /**< Bundle holding the model and its published actions. */
    std::size_t               model = 0; /**< Model index in that bundle. */
};

/**
 * The model bundle each character was built from, which holds the actions external motions add.
 */
std::unordered_map<const CCharacter2 *, MotionOwner> character_models;

/**
 * Base streams and glTF morph deltas indexed by the native mesh's persistent positions.
 */
struct NativeMorph {
    std::vector<std::array<float, 4> >               positions;       /**< Undeformed native positions. */
    std::vector<std::array<float, 4> >               normals;         /**< Undeformed native normals. */
    std::vector<std::vector<std::array<float, 4> > > position_deltas; /**< Position deltas for each morph target. */
    std::vector<std::vector<std::array<float, 4> > > normal_deltas;   /**< Normal deltas for each morph target. */
};

/**
 * Morph bases indexed by persistent native position-stream identity.
 */
std::unordered_map<const void *, NativeMorph> native_morphs;

/**
 * Keeps a directly entered character texture set alive for explicit image deletion.
 */
struct CharacterImages {
    int                                      slot;    /**< Character image slot owning the set. */
    int                                      block;   /**< Destination texture block before per-entry offsets. */
    mgCTextureManager                       *manager; /**< Native manager receiving the textures. */
    std::shared_ptr<texture_catalog::Source> source;  /**< Stable picture and animation definitions. */
    mgCMemory                               *memory;  /**< Arena used by native texture animation records. */
    std::string                              suffix;  /**< Texture identity suffix at registration time. */
};

/**
 * Associates entered native image sets with the character slots that own them.
 */
std::unordered_map<CCharacter2 *, std::vector<CharacterImages> > character_images;

/**
 * Owns parsed monster texture resources until their reserved slots are replaced.
 */
struct ReservedImages {
    std::shared_ptr<texture_catalog::Source>                               source; /**< Parsed picture and animation definitions. */
    std::shared_ptr<std::vector<std::vector<datapacks::DecodedTexture> > > pixels; /**< Reserved RGBA mip chains for every variant. */
};

/**
 * Keeps reserved native resource objects alive without serialized image buffers.
 */
std::unordered_map<CActiveMonster *, std::array<ReservedImages, 2> > reserved_images;

/**
 * Converts readable or escaped model names to the byte strings used by game frame and texture lookups.
 */
std::string GameName(std::string name) {
    if (std::ranges::any_of(name, [](unsigned char value) { return value >= 128; })) {
        name = legacy_encoding::GameText(name);
    }
    auto digit = [](char value) {
        if (value >= '0' && value <= '9') {
            return value - '0';
        }
        if (value >= 'a' && value <= 'f') {
            return value - 'a' + 10;
        }
        if (value >= 'A' && value <= 'F') {
            return value - 'A' + 10;
        }
        return -1;
    };
    std::string decoded;
    for (std::size_t index = 0; index < name.size(); ++index) {
        if (name[index] == '%' && index + 2 < name.size()) {
            const int high = digit(name[index + 1]);
            const int low = digit(name[index + 2]);
            if (high >= 0 && low >= 0) {
                decoded.push_back(static_cast<char>(high * 16 + low));
                index += 2;
                continue;
            }
        }
        decoded.push_back(name[index]);
    }
    if (decoded.contains('\0')) {
        throw std::runtime_error("model name contains a null byte");
    }
    return decoded;
}

/**
 * Rejects asset references that escape the converted-data root.
 */
std::filesystem::path Relative(const std::string &name) {
    const std::filesystem::path path(name);
    if (name.empty() || path.is_absolute() || path.has_root_name() || name.contains(':') ||
        name.contains('\\')) {
        throw std::runtime_error("unsafe asset path: " + name);
    }
    for (const auto &part : path) {
        if (part == ".." || part == ".") {
            throw std::runtime_error("unsafe asset path: " + name);
        }
    }
    return path;
}

/**
 * Resolves a glTF URI reference against its document's directory, allowing ".." components that stay inside the
 * data namespace.
 */
std::string Reference(const std::filesystem::path &relative, std::string_view uri) {
    const std::filesystem::path path(std::u8string(uri.begin(), uri.end()));
    if (uri.empty() || path.is_absolute() || path.has_root_name() || path.has_root_directory() ||
        uri.find_first_of(":\\") != std::string_view::npos) {
        throw std::runtime_error("unsafe asset reference: " + std::string(uri));
    }
    const auto  normal = (relative.parent_path() / path).lexically_normal().generic_u8string();
    std::string name(normal.begin(), normal.end());
    if (!vfs::SafeRelative(name)) {
        throw std::runtime_error("asset reference leaves the data: " + std::string(uri));
    }
    return name;
}

/**
 * Resolves a converted asset through the configured datapack priority.
 */
vfs::Ref Asset(const std::filesystem::path &path) {
    auto asset = datapacks::Asset(path);
    if (!asset) {
        throw std::runtime_error("missing asset: " + path.generic_string());
    }
    return *asset;
}

/**
 * Starts a selection of a document's contents, sharing its glTF, semantics and source.
 */
std::shared_ptr<Document> Derive(const Document &source) {
    auto selected = std::make_shared<Document>(source.storage);
    selected->custom = source.custom;
    selected->images = source.images;
    selected->relative = source.relative;
    selected->overlaid = source.overlaid;
    selected->source = source.source;
    return selected;
}

/**
 * Selects one model scene and its adjacent native semantics.
 */
std::shared_ptr<Document> SelectModel(const std::shared_ptr<Document> &source, std::optional<std::size_t> index) {
    auto selected = Derive(*source);
    if (!index && source->custom->contains("models") && source->custom->at("models").empty()) {
        selected->metadata = {
            {"frames", Json::array()},
            {"meshes", Json::array()}
        };
    } else {
        selected->metadata = source->custom->contains("models") ? source->custom->at("models").at(index.value_or(0)) : *source->custom;
    }
    selected->node_offset = selected->metadata.value("node_offset", std::size_t{0});
    const auto &frames = selected->metadata.at("frames");
    for (std::size_t frame = 0; frame < frames.size(); ++frame) {
        if (frames[frame].contains("rotation_node")) {
            const auto  helper = frames[frame].at("rotation_node").get<std::size_t>();
            const auto &logical = selected->asset.nodes.at(selected->node_offset + frame);
            if (!selected->overlaid || (!logical.meshIndex && helper < selected->asset.nodes.size() && std::ranges::find(logical.children, helper) != logical.children.end())) {
                selected->rotation_nodes.emplace(helper, frame);
            }
        }
    }
    const auto rotation_nodes = selected->metadata.value("rotation_nodes", Json::object());
    for (const auto &[node, frame] : rotation_nodes.items()) {
        selected->rotation_nodes.insert_or_assign(static_cast<std::size_t>(std::stoull(node)), frame.get<std::size_t>());
    }
    return selected;
}

/**
 * Resolves a standard node to its original gameplay frame, including rotation helpers.
 */
std::size_t NativeFrameIndex(const Document &document, std::size_t node) {
    if (const auto found = document.rotation_nodes.find(node); found != document.rotation_nodes.end()) {
        if (!document.metadata.at("frames").empty() && found->second >= document.metadata.at("frames").size()) {
            throw std::runtime_error("rotation helper outside native frame identities");
        }
        return found->second;
    }
    if (!document.frame_nodes.empty()) {
        const auto found = std::ranges::find(document.frame_nodes, node);
        if (found == document.frame_nodes.end()) {
            throw std::runtime_error("standard node outside selected scene");
        }
        return static_cast<std::size_t>(found - document.frame_nodes.begin());
    }
    if (node < document.node_offset || (!document.metadata.at("frames").empty() && node >= document.node_offset + document.metadata.at("frames").size())) {
        throw std::runtime_error("standard node outside native frame identities");
    }
    return node - document.node_offset;
}

/**
 * Selects one authored scene node or its native identity parent.
 */
const fastgltf::Node &LogicalNode(const Document &document, std::size_t frame) {
    if (document.frame_nodes.empty()) {
        return document.asset.nodes.at(document.node_offset + frame);
    }
    const auto node = document.frame_nodes.at(frame);
    return node == std::numeric_limits<std::size_t>::max() ? *document.scene_root : document.asset.nodes.at(node);
}

/**
 * Selects the standard node holding one gameplay frame's geometry and rotation.
 */
const fastgltf::Node &ContentNode(const Document &document, std::size_t frame) {
    if (!document.frame_nodes.empty()) {
        return LogicalNode(document, frame);
    }
    const auto &detail = document.metadata.at("frames").at(frame);
    const auto  helper = detail.value("rotation_node", document.node_offset + frame);
    return document.asset.nodes.at(document.rotation_nodes.contains(helper) ? helper : document.node_offset + frame);
}

/**
 * Parses the highest-priority valid gameplay sidecar and names the exact file contents it came from.
 */
std::shared_ptr<const Json> ParseGameplay(const std::filesystem::path &gltf, std::string &error, std::string &identity) {
    auto sidecar = gltf;
    sidecar.replace_extension(".game.json");
    error = "native gameplay JSON missing: " + sidecar.generic_string();
    identity.clear();
    for (const auto &path : datapacks::Candidates(sidecar)) {
        std::vector<uint8_t> bytes;
        if (!datapacks::ReadFileBytes(path, bytes)) {
            continue;
        }
        try {
            auto game = std::make_shared<Json>(Json::parse(bytes.begin(), bytes.end()));
            if (game->at("schema_version") != 1) {
                throw std::runtime_error("unsupported native gameplay schema");
            }
            std::string gameplay_identity;
            if (game->contains("models")) {
                auto gameplay_path = gltf;
                gameplay_path.replace_extension(".character.json");
                for (const auto &candidate : datapacks::GameplayCandidates(gameplay_path)) {
                    std::vector<uint8_t> gameplay_bytes;
                    if (!datapacks::ReadFileBytes(candidate, gameplay_bytes)) {
                        continue;
                    }
                    const auto gameplay = Json::parse(gameplay_bytes.begin(), gameplay_bytes.end());
                    if (gameplay.at("schema_version") != 1 || gameplay.at("kind") != "character_gameplay" ||
                        !gameplay.at("profiles").is_object()) {
                        throw std::runtime_error("invalid external character gameplay JSON: " + gameplay_path.generic_string());
                    }
                    for (const auto *field : {"profiles", "game_names", "default_profile"}) {
                        if (gameplay.contains(field)) {
                            (*game)[field] = gameplay.at(field);
                        }
                    }
                    if (gameplay.contains("cloth_commands")) {
                        auto &cloths = game->at("resources").at("cloths");
                        for (const auto &entry : gameplay.at("cloth_commands")) {
                            const auto index = entry.at("index").get<std::size_t>();
                            if (index >= cloths.size() || !entry.at("commands").is_array()) {
                                throw std::runtime_error("invalid external character cloth commands");
                            }
                            cloths.at(index)["commands"] = entry.at("commands");
                        }
                    }
                    gameplay_identity = datapacks::ImageDecodeKey("character_gameplay", std::span(&candidate, 1));
                    break;
                }
            }
            auto validate_model = [](const Json &model) {
                if (!model.at("frames").is_array() || !model.at("meshes").is_array()) {
                    throw std::runtime_error("invalid native gameplay model");
                }
                std::size_t index = 0;
                for (const auto &frame : model.at("frames")) {
                    if (frame.contains("id") && (!frame.at("id").is_number_integer() || frame.at("id").get<std::size_t>() != index)) {
                        throw std::runtime_error("invalid native frame ID");
                    }
                    if (!frame.at("mdt").is_null() && (!frame.at("mdt").is_number_integer() || frame.at("mdt").get<std::size_t>() >= model.at("meshes").size())) {
                        throw std::runtime_error("invalid native mesh ID");
                    }
                    ++index;
                }
                for (const auto &mesh : model.at("meshes")) {
                    if (!mesh.at("primitives").is_array() || !mesh.at("materials").is_array()) {
                        throw std::runtime_error("invalid native mesh records");
                    }
                    for (const auto *count : kStreamCounts) {
                        if (!mesh.at(count).is_number_integer() || mesh.at(count).get<std::int64_t>() < 0) {
                            throw std::runtime_error("invalid native stream count");
                        }
                    }
                    for (const auto &primitive : mesh.at("primitives")) {
                        for (std::size_t stream = 0; stream < kStreamMappings.size(); ++stream) {
                            const auto &mapping = primitive.at(kStreamMappings[stream]);
                            if (!mapping.is_array()) {
                                throw std::runtime_error("invalid native stream identities");
                            }
                            for (const auto &identity : mapping) {
                                if (!identity.is_number_integer() || identity.get<std::size_t>() >= mesh.at(kStreamCounts[stream]).get<std::size_t>()) {
                                    throw std::runtime_error("invalid native stream identity");
                                }
                            }
                        }
                    }
                }
            };
            if (game->contains("models")) {
                if (!game->at("models").is_array() || !game->at("profiles").is_object() || !game->at("resources").is_object()) {
                    throw std::runtime_error("invalid native character gameplay JSON");
                }
                for (const auto &model : game->at("models")) {
                    validate_model(model);
                }
            } else {
                validate_model(*game);
            }
            error.clear();
            identity = datapacks::ImageDecodeKey("gameplay", std::span(&path, 1)) + '|' + gameplay_identity;
            return game;
        } catch (const std::exception &exception) {
            error = exception.what();
        }
    }
    return nullptr;
}

/**
 * Parses actual glTF bytes alongside explicit native gameplay semantics.
 */
std::shared_ptr<Document> ReadBytes(std::span<const std::byte> bytes, const Json &custom, const std::filesystem::path &relative = {}, bool overlaid = false) {
    CT_PROFILE_ZONE("Parse model document");
    if (bytes.empty()) {
        throw std::runtime_error("empty native glTF document");
    }
    if (custom.at("schema_version") != 1) {
        throw std::runtime_error("unsupported native gameplay schema");
    }
    auto input = fastgltf::GltfDataBuffer::FromBytes(bytes.data(), bytes.size());
    if (input.error() != fastgltf::Error::None) {
        throw std::runtime_error("cannot read native glTF bytes");
    }
    fastgltf::Parser parser;
    // External buffers and images are resolved through datapack priority below, not by the parser.
    auto parsed = parser.loadGltf(input.get(), {}, fastgltf::Options::None);
    if (parsed.error() != fastgltf::Error::None) {
        throw std::runtime_error("invalid glTF: " + std::string(fastgltf::getErrorMessage(parsed.error())));
    }
    auto document = std::make_shared<Document>(std::make_shared<fastgltf::Asset>(std::move(parsed.get())));
    document->custom = std::make_shared<Json>(custom);
    document->images = std::make_shared<Json>(custom.value("images", Json::array()));
    document->relative = relative;
    document->overlaid = overlaid;
    for (auto &buffer : document->asset.buffers) {
        if (auto *uri = std::get_if<fastgltf::sources::URI>(&buffer.data)) {
            std::vector<uint8_t> data;
            datapacks::ReadFileBytes(Asset(Reference(relative, uri->uri.path())), data);
            if (data.size() < buffer.byteLength) {
                throw std::runtime_error("truncated glTF buffer");
            }
            datapacks::Trace("model.buffer_reads");
            datapacks::Trace("model.buffer_bytes", data.size());
            fastgltf::sources::Vector storage;
            storage.bytes.resize(data.size());
            std::memcpy(storage.bytes.data(), data.data(), data.size());
            buffer.data = std::move(storage);
        }
    }
    if (fastgltf::validate(document->asset) != fastgltf::Error::None) {
        throw std::runtime_error("glTF validation failed");
    }
    return document;
}

/**
 * Loads an explicitly named native glTF asset through datapack priority.
 */
std::shared_ptr<Document> Read(const std::filesystem::path &relative, bool allow_standard = false) {
    CT_PROFILE_ZONE("Read model document");
    std::string error = "native glTF asset missing: " + relative.generic_string();
    for (const auto &path : datapacks::Candidates(relative)) {
        if (!vfs::Size(path)) {
            continue;
        }
        try {
            std::string sidecar_error;
            std::string sidecar_identity;
            auto        game = ParseGameplay(relative, sidecar_error, sidecar_identity);
            const bool  standard_only = !game;
            if (!game) {
                auto sidecar = relative;
                sidecar.replace_extension(".game.json");
                const auto candidates = datapacks::Candidates(sidecar);
                if (!allow_standard || !candidates.empty()) {
                    throw std::runtime_error(sidecar_error);
                }
                game = std::make_shared<Json>(Json{
                    {"schema_version", 1            },
                    {"frames",         Json::array()},
                    {"meshes",         Json::array()}
                });
            }
            const auto stamp = path.Display() + '|' + vfs::Stamp(path);
            const auto key = stamp + '|' + (standard_only ? std::string("standard") : sidecar_identity);
            if (const auto found = documents.find(key); found != documents.end()) {
                return found->second;
            }
            std::vector<uint8_t> data;
            if (!datapacks::ReadFileBytes(path, data)) {
                throw std::runtime_error("cannot read native glTF asset: " + relative.generic_string());
            }
            datapacks::Trace("model.gltf_reads");
            datapacks::Trace("model.gltf_bytes", data.size());
            auto document = ReadBytes(std::as_bytes(std::span(data)), *game, relative, datapacks::IsReplacement(path));
            document->standard_only = standard_only;
            if (document->overlaid) {
                document->source = stamp;
            }
            documents.emplace(key, document);
            return document;
        } catch (const std::exception &exception) {
            error = exception.what();
        }
    }
    throw std::runtime_error(error);
}

/**
 * Allocates value-initialized native objects in the game's persistent model arena.
 */
template <class T>
T *Allocate(mgCMemory &memory, std::size_t count = 1) {
    if (count > (1u << 26) / sizeof(T)) {
        throw std::runtime_error("native model allocation too large");
    }
    auto *storage = memory.Alloc(static_cast<int>((count * sizeof(T) + 15) / 16 + 2));
    if (!storage) {
        throw std::runtime_error("model arena exhausted");
    }
    auto *objects = reinterpret_cast<T *>(storage);
    for (std::size_t index = 0; index < count; ++index) {
        ::new (objects + index) T{};
    }
    return objects;
}

/**
 * Copies one accessor's values into the native stream while restoring retail stream indices.
 */
template <std::size_t N>
void Stream(const fastgltf::Asset &asset, const fastgltf::Primitive &primitive, std::string_view name,
            const Json &mapping, float (*destination)[4], int count, float w) {
    const auto *attribute = primitive.findAttribute(name);
    if (attribute == primitive.attributes.end()) {
        if (!mapping.empty()) {
            throw std::runtime_error("missing glTF attribute: " + std::string(name));
        }
        return;
    }
    const auto &accessor = asset.accessors.at(attribute->accessorIndex);
    if (accessor.count != mapping.size()) {
        throw std::runtime_error("glTF attribute/identity count mismatch");
    }
    fastgltf::iterateAccessorWithIndex<fastgltf::math::vec<float, N> >(asset, accessor, [&](auto value, std::size_t corner) {
        const auto index = mapping.at(corner).get<int>();
        if (index < 0 || index >= count) {
            throw std::runtime_error("glTF stream index out of range");
        }
        for (std::size_t component = 0; component < N; ++component) {
            destination[index][component] = value[component];
        }
        if constexpr (N < 4) {
            destination[index][3] = w;
        }
    });
}

/**
 * Chooses the requested native visual class using the game's frame-name matching rules.
 */
int VisualType(mgCreateVisualType *table, const std::string &name) {
    int type = MG_VISUAL_CREATE_FIX_MDT;
    if (!table) {
        return type;
    }
    for (auto *entry = table; entry->name && entry->type != MG_VISUAL_CREATE_END; ++entry) {
        if (!*entry->name) {
            type = entry->type;
        }
    }
    for (auto *entry = table; entry->name && entry->type != MG_VISUAL_CREATE_END; ++entry) {
        if (*entry->name && mgFrameNameComp(const_cast<char *>(name.c_str()), entry->name)) {
            return entry->type;
        }
    }
    return type;
}

/**
 * Constructs a native visual of the requested drawing class.
 */
mgCVisualMDT *Visual(mgCMemory &memory, int type) {
    switch (type) {
        case MG_VISUAL_CREATE_MDT:
            return Allocate<mgCVisualMDT>(memory);
        case MG_VISUAL_CREATE_FIX_MDT:
            return Allocate<mgCVisualFixMDT>(memory);
        case MG_VISUAL_CREATE_SHADOW_MDT:
            return Allocate<mgCShadowMDT>(memory);
        case MG_VISUAL_CREATE_SHADOW_FIX_MDT:
            return Allocate<mgCShadowFixMDT>(memory);
        case MG_VISUAL_CREATE_MOTION_MDT:
            return Allocate<mgCVisualMotionMDT>(memory);
        default:
            throw std::runtime_error("unknown visual class");
    }
}

/**
 * Reads the preserved stream mapping for a primitive.
 */
const Json &Mapping(const Json &primitive, const char *name) {
    static const Json empty = Json::array();
    return primitive.contains(name) ? primitive.at(name) : empty;
}

/**
 * Adapts changed glTF primitive layouts while retaining original identities where they still fit.
 */
Json MeshIdentity(const Document &document, const fastgltf::Node &node, Json detail) {
    const auto                       &mesh = document.asset.meshes.at(*node.meshIndex);
    const std::array<const char *, 4> attributes{"POSITION", "NORMAL", "TEXCOORD_0", "COLOR_0"};
    if (document.overlaid) {
        for (const auto *count : kStreamCounts) {
            detail[count] = 0;
        }
        detail.erase("streams");
    }
    Json                                 primitives = Json::array();
    int                                  material_count = static_cast<int>(detail.at("materials").size());
    std::unordered_map<std::size_t, int> material_slots;
    std::unordered_map<int, std::size_t> assigned_slots;
    for (std::size_t index = 0; index < mesh.primitives.size(); ++index) {
        const auto &primitive = mesh.primitives[index];
        Json        metadata = index < detail.at("primitives").size() ? detail.at("primitives").at(index) : Json::object();
        int         type = metadata.value("type", 0) & MG_FACE_FLAT;
        switch (primitive.type) {
            case fastgltf::PrimitiveType::Triangles:
                type |= MG_PRIM_TRIANGLE;
                break;
            case fastgltf::PrimitiveType::TriangleStrip:
                type |= MG_PRIM_TRIANGLE_STRIP;
                break;
            case fastgltf::PrimitiveType::TriangleFan:
                type |= MG_PRIM_TRIANGLE_FAN;
                break;
            default:
                throw std::runtime_error("native model requires triangle primitives");
        }
        for (std::size_t stream = 0; stream < attributes.size(); ++stream) {
            const auto *const attribute = primitive.findAttribute(attributes[stream]);
            const auto        count = attribute == primitive.attributes.end() ? 0 : document.asset.accessors.at(attribute->accessorIndex).count;
            if (document.overlaid || Mapping(metadata, kStreamMappings[stream]).size() != count) {
                Json mapping = Json::array();
                int  next = detail.at(kStreamCounts[stream]);
                for (std::size_t element = 0; element < count; ++element) {
                    mapping.push_back(next++);
                }
                metadata[kStreamMappings[stream]] = std::move(mapping);
                detail[kStreamCounts[stream]] = next;
            }
            if (!count && stream == 0) {
                throw std::runtime_error("mesh lacks position attribute");
            }
            if (!count && stream == 1) {
                type |= MG_FACE_NO_NORMAL;
            }
            if (!count && stream == 2) {
                type |= MG_FACE_NO_TEXTURE;
            }
            if (count && stream == 3) {
                type |= MG_FACE_COLOUR;
            }
        }
        metadata["type"] = type;
        const auto global_material = primitive.materialIndex ? *primitive.materialIndex : document.asset.materials.size();
        auto       assigned = material_slots.find(global_material);
        if (assigned == material_slots.end()) {
            int local = metadata.value("material", -1);
            if (local < 0 || assigned_slots.contains(local)) {
                local = material_count++;
            }
            material_count = std::max(material_count, local + 1);
            assigned_slots.emplace(local, global_material);
            assigned = material_slots.emplace(global_material, local).first;
        }
        metadata["material"] = assigned->second;
        metadata["gltf_material"] = global_material;
        primitives.push_back(std::move(metadata));
    }
    detail["primitives"] = std::move(primitives);
    detail["material_count"] = material_count;
    return detail;
}

/**
 * Encoded glTF image bytes viewed in place, or owned when the image names an external file.
 */
struct EmbeddedImage {
    std::span<const std::byte> bytes;     /**< Encoded PNG bytes, empty for an external image. */
    std::string                reference; /**< Data path of an external PNG, empty when embedded. */
};

/**
 * Views a standard image's encoded bytes without copying embedded data, or names its external PNG unread.
 */
EmbeddedImage EmbeddedBytes(const Document &document, std::size_t index) {
    EmbeddedImage result;
    std::visit([&](const auto &source) {
        using T = std::decay_t<decltype(source)>;
        if constexpr (std::is_same_v<T, fastgltf::sources::Array> || std::is_same_v<T, fastgltf::sources::Vector> || std::is_same_v<T, fastgltf::sources::ByteView>) {
            result.bytes = std::span<const std::byte>(source.bytes.data(), source.bytes.size());
        } else if constexpr (std::is_same_v<T, fastgltf::sources::BufferView>) {
            const auto data = fastgltf::DefaultBufferDataAdapter{}(document.asset, source.bufferViewIndex);
            result.bytes = std::span<const std::byte>(data.data(), data.size());
        } else if constexpr (std::is_same_v<T, fastgltf::sources::URI>) {
            result.reference = Reference(document.relative, source.uri.path());
        } else {
            throw std::runtime_error("unsupported embedded image source");
        }
    },
               document.asset.images.at(index).data);
    return result;
}

/**
 * Reads a standard image's dimensions from its encoded header.
 */
void ImageExtent(const Document &document, std::size_t index, int &width, int &height) {
    datapacks::TraceTimer timer("model.extent_us");
    const auto            embedded = EmbeddedBytes(document, index);
    if (!embedded.reference.empty()) {
        // The base game data never changes while running, so each external PNG's header is read once:
        // an area registers the same few thousand images many times over.
        static std::mutex                                            extents_mutex;
        static std::unordered_map<std::string, std::pair<int, int> > extents;
        const auto                                                   key = vfs::FoldKey(embedded.reference);
        {
            std::scoped_lock lock(extents_mutex);
            if (const auto found = extents.find(key); found != extents.end()) {
                width = found->second.first;
                height = found->second.second;
                datapacks::Trace("model.extent_memo_hits");
                return;
            }
        }
        // The logical extent is the original PNG's; a datapack may enlarge the image it supplies.
        auto file = vfs::Find(datapacks::Base(), embedded.reference);
        if (!file) {
            file = Asset(embedded.reference);
        }
        std::array<std::uint8_t, 24> header{};
        constexpr std::array<std::uint8_t, 8> signature{137, 80, 78, 71, 13, 10, 26, 10};
        if (!vfs::ReadPrefix(file, header) || !std::equal(signature.begin(), signature.end(), header.begin()) ||
            !std::equal(header.begin() + 12, header.begin() + 16, "IHDR")) {
            throw std::runtime_error("invalid glTF PNG: " + embedded.reference);
        }
        const auto word = [&](std::size_t offset) {
            return (uint32_t{header[offset]} << 24) | (uint32_t{header[offset + 1]} << 16) | (uint32_t{header[offset + 2]} << 8) | header[offset + 3];
        };
        if (word(16) == 0 || word(20) == 0 || word(16) > 16384 || word(20) > 16384) {
            throw std::runtime_error("invalid glTF PNG dimensions: " + embedded.reference);
        }
        width = static_cast<int>(word(16));
        height = static_cast<int>(word(20));
        datapacks::Trace("model.extent_reads");
        std::scoped_lock lock(extents_mutex);
        extents.emplace(key, std::pair(width, height));
        return;
    }
    int components = 0;
    if (!stbi_info_from_memory(reinterpret_cast<const stbi_uc *>(embedded.bytes.data()), static_cast<int>(embedded.bytes.size()), &width, &height, &components)) {
        throw std::runtime_error("invalid embedded glTF PNG");
    }
    datapacks::Trace("model.extent_reads");
}

/**
 * The pixel sources competing for one standard image: datapack PNG replacements, then the embedded PNG.
 */
struct ImageSource {
    std::shared_ptr<const Document> document;     /**< Document keeping the embedded bytes alive. */
    EmbeddedImage                   embedded;     /**< Encoded embedded PNG. */
    std::vector<vfs::Ref>           overlays;     /**< Replacement PNG files in priority order. */
    std::string                     overlay_key;  /**< Decode identity of the replacement files, empty without any. */
    std::string                     embedded_key; /**< Decode identity of the embedded PNG contents. */
};

/**
 * Resolves the replacement PNGs and content identities of a standard image.
 */
ImageSource ResolveImage(const Document &document, std::size_t index) {
    datapacks::TraceTimer    timer("model.resolve_image_us");
    ImageSource              source{.document = document.shared_from_this(), .embedded = EmbeddedBytes(document, index), .overlays = {}, .overlay_key = {}, .embedded_key = {}};
    std::vector<std::string> paths;
    if (!source.embedded.reference.empty()) {
        // An external PNG is decoded like a replacement: through datapack priority, keyed by its files' stamps, so
        // every document referencing it shares one decode.
        paths.push_back(source.embedded.reference);
    } else if (const auto found = document.embedded_keys.find(index); found != document.embedded_keys.end()) {
        source.embedded_key = found->second;
    } else {
        // Datapack files are named by their stamps rather than hashed.
        source.embedded_key = document.overlaid ? "embedded-pack:" + document.source + ':' + std::to_string(index)
                                                : "embedded:" + ContentHash(source.embedded.bytes);
        document.embedded_keys.emplace(index, source.embedded_key);
    }
    // A datapack glTF owns its embedded images; replacement PNGs apply only to the converted document.
    if (!document.overlaid) {
        for (const auto &metadata : *document.images) {
            if (metadata.at("image").get<std::size_t>() != index || !metadata.contains("png")) {
                continue;
            }
            const auto path = Relative(metadata.at("png").get<std::string>()).generic_string();
            if (std::ranges::none_of(paths, [&](const std::string &known) { return vfs::FoldKey(known) == vfs::FoldKey(path); })) {
                paths.push_back(path);
            }
        }
    }
    std::string names;
    for (const auto &path : paths) {
        names += path + '\n';
        const auto candidates = datapacks::Candidates(std::filesystem::path(std::u8string(path.begin(), path.end())));
        source.overlays.insert(source.overlays.end(), candidates.begin(), candidates.end());
    }
    if (!source.overlays.empty()) {
        source.overlay_key = datapacks::ImageDecodeKey("png:" + names, source.overlays);
    }
    return source;
}

/**
 * Names the exact pixels a resolved image produces, including the embedded fallback of an invalid replacement.
 */
std::string SourceIdentity(const ImageSource &source) {
    return source.overlay_key.empty() ? source.embedded_key : source.overlay_key + '\n' + source.embedded_key;
}

/**
 * Decodes PNG bytes into a single RGBA level; safe on worker threads.
 */
bool DecodePng(std::span<const std::byte> png, datapacks::DecodedTexture &image) {
    std::vector<uint8_t> rgba;
    std::string          error;
    if (!datapacks::DecodePng(std::span(reinterpret_cast<const uint8_t *>(png.data()), png.size()), image.width, image.height, rgba, error)) {
        return false;
    }
    image.levels.clear();
    image.levels.push_back(std::move(rgba));
    return true;
}

/**
 * Decodes the first valid replacement PNG; safe on worker threads.
 */
bool DecodeOverlay(std::span<const vfs::Ref> candidates, datapacks::DecodedTexture &image, std::string &failure) {
    for (const auto &candidate : candidates) {
        std::vector<uint8_t> png;
        if (datapacks::ReadFileBytes(candidate, png) && DecodePng(std::as_bytes(std::span(png)), image)) {
            datapacks::Trace("model.overlay_decodes");
            return true;
        }
    }
    failure = "no valid replacement PNG";
    return false;
}

/**
 * Decodes an embedded PNG; safe on worker threads.
 */
bool DecodeEmbedded(std::span<const std::byte> png, datapacks::DecodedTexture &image, std::string &failure) {
    if (!DecodePng(png, image)) {
        failure = "invalid embedded glTF PNG";
        return false;
    }
    datapacks::Trace("model.embedded_decodes");
    return true;
}

/**
 * Returns a resolved image's shared pixels, preferring a valid replacement PNG over the embedded image.
 */
std::shared_ptr<const datapacks::DecodedTexture> SourcePixels(const ImageSource &source) {
    std::string error;
    if (!source.overlay_key.empty()) {
        if (auto decoded = datapacks::DecodeShared(source.overlay_key, [&source](datapacks::DecodedTexture &image, std::string &failure) { return DecodeOverlay(source.overlays, image, failure); }, error)) {
            return decoded;
        }
    }
    if (auto decoded = datapacks::DecodeShared(source.embedded_key, [&source](datapacks::DecodedTexture &image, std::string &failure) { return DecodeEmbedded(source.embedded.bytes, image, failure); }, error)) {
        return decoded;
    }
    throw std::runtime_error(error);
}

/**
 * Prefetches every image decode a texture registration will request, on worker threads.
 */
void PrefetchImages(std::span<const std::shared_ptr<const ImageSource> > sources) {
    std::vector<datapacks::DecodeJob> jobs;
    std::unordered_set<std::string>   queued;
    for (const auto &source : sources) {
        const bool overlay = !source->overlay_key.empty();
        if (!queued.insert(overlay ? source->overlay_key : source->embedded_key).second) {
            continue;
        }
        jobs.push_back({.identity = overlay ? source->overlay_key : source->embedded_key, .decoder = [source, overlay](datapacks::DecodedTexture &image, std::string &failure) {
                            return overlay ? DecodeOverlay(source->overlays, image, failure) : DecodeEmbedded(source->embedded.bytes, image, failure);
                        }});
    }
    if (!jobs.empty()) {
        datapacks::Prefetch(jobs);
    }
}

/**
 * Appends a decoded image as the next mip level, placed at the top-left of its power-of-two canvas.
 */
void AppendCanvas(const datapacks::DecodedTexture &image, datapacks::DecodedTexture &decoded) {
    const auto  physical_width = std::bit_ceil(image.width);
    const auto  physical_height = std::bit_ceil(image.height);
    const auto &rgba = image.levels.at(0);
    if (physical_width == image.width && physical_height == image.height) {
        decoded.levels.push_back(rgba);
    } else {
        std::vector<uint8_t> pixels(static_cast<std::size_t>(physical_width) * physical_height * 4);
        for (uint32_t row = 0; row < image.height; ++row) {
            std::memcpy(pixels.data() + static_cast<std::size_t>(row) * physical_width * 4, rgba.data() + static_cast<std::size_t>(row) * image.width * 4, static_cast<std::size_t>(image.width) * 4);
        }
        decoded.levels.push_back(std::move(pixels));
    }
    if (decoded.levels.size() == 1) {
        decoded.width = physical_width;
        decoded.height = physical_height;
    }
}

/**
 * Decodes a glTF base-colour image into a texture managed by the native game renderer.
 */
mgCTexture *Image(Document &document, std::size_t texture_index, mgCMemory &memory,
                  mgCTextureManager &textures, const std::string &name) {
    const auto &texture = document.asset.textures.at(texture_index);
    if (!texture.imageIndex) {
        throw std::runtime_error("glTF texture lacks a source image");
    }
    auto retained = document.shared_from_this();
    int  width = 0;
    int  height = 0;
    ImageExtent(document, *texture.imageIndex, width, height);
    auto                   source = std::make_shared<texture_catalog::Source>();
    texture_catalog::Entry entry;
    entry.type = "texture";
    entry.name = name;
    entry.width = width;
    entry.height = height;
    entry.bpp = 32;
    entry.variants.push_back({.selector = "", .levels = {}});
    source->entries.push_back(std::move(entry));
    document.texture_sets[(std::size_t{1} << 30) + texture_index] = source;
    const auto image = *texture.imageIndex;
    MgTextureEnterNativeSet(
        &textures, 0, *source, &memory,
        [retained, image](const texture_catalog::Entry &, std::size_t, datapacks::DecodedTexture &decoded, std::string &error) {
            try {
                decoded = {};
                AppendCanvas(*SourcePixels(ResolveImage(*retained, image)), decoded);
                return true;
            } catch (const std::exception &exception) {
                error = exception.what();
                return false;
            }
        },
        [retained, image](const texture_catalog::Entry &, std::size_t) {
            try {
                return SourceIdentity(ResolveImage(*retained, image));
            } catch (const std::exception &) {
                return std::string{};
            }
        });
    auto *native = textures.GetTexture(const_cast<char *>(name.c_str()), 0);
    if (!native) {
        throw std::runtime_error("native texture table exhausted");
    }
    if (texture.samplerIndex) {
        const auto &sampler = document.asset.samplers.at(*texture.samplerIndex);
        native->clamp.WMS = sampler.wrapS == fastgltf::Wrap::ClampToEdge ? 1 : 0;
        native->clamp.WMT = sampler.wrapT == fastgltf::Wrap::ClampToEdge ? 1 : 0;
        if (sampler.magFilter) {
            native->Bilinear(*sampler.magFilter != fastgltf::Filter::Nearest);
        }
    }
    return native;
}

/**
 * Rewrites a shadow model's faces into the layout mgCShadowMDT::CreateFace builds and its draw reads.
 *
 * Mesh() builds the visual layout, vertex_num corners each holding a position index followed by its normal, uv and
 * colour indices. The shadow layout is vertex_num triangles of three position indices; only triangle lists keep
 * their triangles, as retail's shadow draw takes no other primitive. The indices are compacted in place, and the
 * groups take retail's shadow microprogram, which marks the layout.
 */
void ShadowFaces(mgCVisualMDT &visual) {
    for (auto *group = visual.face_group; group; group = group->next) {
        group->vu_program = MG_VU_PROG_SHADOW;
        for (auto *face = group->face; face; face = face->next) {
            const auto      stride = static_cast<std::size_t>(std::max<short>(face->index_stride, 0));
            const int       triangles = (face->type & MG_FACE_PRIM_MASK) == MG_PRIM_TRIANGLE && stride > 0 ? face->vertex_num / 3 : 0;
            const std::span indices(face->index, static_cast<std::size_t>(face->index_num));
            for (std::size_t corner = 0; corner < static_cast<std::size_t>(triangles) * 3; ++corner) {
                indices[corner] = indices[corner * stride];
            }
            face->vertex_num = static_cast<short>(triangles);
            face->index_stride = 3;
            face->index_num = static_cast<short>(triangles * 3);
        }
    }
}

/**
 * Rebuilds the GPU face meshes of a visual, except a shadow model's, which is drawn from its faces in the shadow pass.
 */
void RefreshFaces(mgCVisualMDT &visual) {
    if (visual.face_group != nullptr && visual.face_group->vu_program == MG_VU_PROG_SHADOW) {
        return;
    }
    for (auto *group = visual.face_group; group; group = group->next) {
        for (auto *face = group->face; face; face = face->next) {
            mgVisualPortRefreshFace(&visual, face);
        }
    }
}

/**
 * Builds native vertices, materials and face groups directly from glTF mesh accessors.
 */
void Mesh(Document &document, const fastgltf::Node &node, const Json &detail, mgCVisualMDT &visual,
          mgCMemory &memory, mgCTextureManager &textures) {
    const auto &mesh = document.asset.meshes.at(*node.meshIndex);
    if (mesh.primitives.size() != detail.at("primitives").size()) {
        throw std::runtime_error("primitive identity count mismatch");
    }
    visual.vertex_num = detail.at("vertex_count");
    visual.normal_num = detail.at("normal_count");
    visual.uv_num = detail.at("uv_count");
    visual.colour_num = detail.at("colour_count");
    visual.vertex = Allocate<sceVu0FVECTOR>(memory, visual.vertex_num);
    visual.normal = Allocate<sceVu0FVECTOR>(memory, visual.normal_num);
    visual.uv = Allocate<sceVu0FVECTOR>(memory, visual.uv_num);
    visual.colour = Allocate<sceVu0FVECTOR>(memory, visual.colour_num);
    float (*streams[4])[4] = {visual.vertex, visual.normal, visual.uv, visual.colour};
    const int counts[4] = {visual.vertex_num, visual.normal_num, visual.uv_num, visual.colour_num};
    if (detail.contains("streams")) {
        for (int stream = 0; stream < 4; ++stream) {
            const auto &values = detail.at("streams").at(kStreamValues[stream]);
            if (values.size() > static_cast<std::size_t>(counts[stream])) {
                throw std::runtime_error("preserved stream exceeds native allocation");
            }
            for (std::size_t index = 0; index < values.size(); ++index) {
                for (int component = 0; component < 4; ++component) {
                    streams[stream][index][component] = values.at(index).at(component);
                }
            }
        }
    }
    visual.material_num = detail.at("material_count");
    visual.material = Allocate<mgMaterial>(memory, visual.material_num);
    for (int index = 0; index < visual.material_num; ++index) {
        const Json *material = std::cmp_less(index, detail.at("materials").size()) ? &detail.at("materials").at(index) : nullptr;
        std::size_t gltf_material = document.asset.materials.size();
        for (std::size_t primitive_index = 0; primitive_index < mesh.primitives.size(); ++primitive_index) {
            const auto &primitive = detail.at("primitives").at(primitive_index);
            if (primitive.at("material").get<int>() == index) {
                gltf_material = primitive.at("gltf_material");
                break;
            }
        }
        for (int component = 0; component < 4; ++component) {
            const float factor = gltf_material < document.asset.materials.size() ? document.asset.materials[gltf_material].pbrData.baseColorFactor[component] : material ? std::clamp(material->at("diffuse").at(component).get<float>(), 0.0f, 1.0f)
                                                                                                                                                                         : 1;
            const float original = material ? material->at("diffuse").at(component).get<float>() : factor;
            visual.material[index].diffuse[component] = !document.overlaid && factor == std::clamp(original, 0.0f, 1.0f) ? original : factor;
            visual.material[index].unk_10[component] = material ? material->at("ambient").at(component).get<float>() : 0;
        }
        const auto name = material ? material->at("texture").get<std::string>() : "gltf_" + std::to_string(index);
        const auto game_name = GameName(name);
        visual.material[index].texture = textures.GetTexture(const_cast<char *>(game_name.c_str()), -1);
        if (gltf_material < document.asset.materials.size()) {
            const auto &pbr = document.asset.materials[gltf_material].pbrData;
            if (pbr.baseColorTexture && (!visual.material[index].texture || document.overlaid)) {
                const auto texture_name = document.overlaid ? "gltf_" + std::to_string(std::hash<std::string>{}(document.relative.generic_string()) & 0xffffffffu) + "_" + std::to_string(index) : game_name;
                visual.material[index].texture = Image(document, pbr.baseColorTexture->textureIndex, memory, textures, texture_name);
            }
        }
    }
    mgFACE_GROUP **group_tail = &visual.face_group;
    for (std::size_t index = 0; index < mesh.primitives.size(); ++index) {
        const auto &primitive = mesh.primitives[index];
        const auto &metadata = detail.at("primitives").at(index);
        Stream<3>(document.asset, primitive, "POSITION", Mapping(metadata, "source_vertices"), visual.vertex, visual.vertex_num, 1);
        Stream<3>(document.asset, primitive, "NORMAL", Mapping(metadata, "source_normals"), visual.normal, visual.normal_num, 0);
        Stream<2>(document.asset, primitive, "TEXCOORD_0", Mapping(metadata, "source_uvs"), visual.uv, visual.uv_num, 0);
        Stream<4>(document.asset, primitive, "COLOR_0", Mapping(metadata, "source_colours"), visual.colour, visual.colour_num, 0);
        auto *face = Allocate<mgCFace>(memory);
        face->type = metadata.at("type");
        face->material = metadata.at("material");
        if (face->material < 0 || face->material >= visual.material_num) {
            throw std::runtime_error("material index out of range");
        }
        const auto count = primitive.indicesAccessor ? document.asset.accessors.at(*primitive.indicesAccessor).count : Mapping(metadata, "source_vertices").size();
        if (count > 32767) {
            throw std::runtime_error("native face exceeds vertex limit");
        }
        face->vertex_num = static_cast<short>(count);
        face->index_stride = IndexStride(face->type);
        if (count * face->index_stride > 32767) {
            throw std::runtime_error("native face exceeds index limit");
        }
        face->index_num = static_cast<short>(count * face->index_stride);
        face->index = Allocate<int>(memory, face->index_num);
        for (std::size_t corner = 0; corner < count; ++corner) {
            const auto source = primitive.indicesAccessor ? fastgltf::getAccessorElement<uint32_t>(document.asset, document.asset.accessors.at(*primitive.indicesAccessor), corner) : corner;
            auto      *write = face->index + corner * face->index_stride;
            *write++ = Mapping(metadata, "source_vertices").at(source);
            if (!(face->type & MG_FACE_NO_NORMAL)) {
                *write++ = Mapping(metadata, "source_normals").at(source);
            }
            if (!(face->type & MG_FACE_NO_TEXTURE)) {
                *write++ = Mapping(metadata, "source_uvs").at(source);
            }
            if (face->type & MG_FACE_COLOUR) {
                *write++ = Mapping(metadata, "source_colours").at(source);
            }
        }
        auto *group = Allocate<mgFACE_GROUP>(memory);
        group->material = face->material;
        group->face = face;
        *group_tail = group;
        group_tail = &group->next;
    }
    if (!document.overlaid && detail.contains("streams")) {
        const auto &preserved = detail.at("streams");
        for (int index = 0; index < visual.normal_num; ++index) {
            for (int component = 0; component < 4; ++component) {
                visual.normal[index][component] = preserved.at("normals").at(index).at(component);
            }
        }
        for (int index = 0; index < visual.colour_num; ++index) {
            for (int component = 0; component < 4; ++component) {
                visual.colour[index][component] = preserved.at("colours").at(index).at(component);
            }
        }
        for (int index = 0; index < visual.vertex_num; ++index) {
            visual.vertex[index][3] = preserved.at("positions").at(index).at(3);
        }
        for (int index = 0; index < visual.uv_num; ++index) {
            for (int component = 2; component < 4; ++component) {
                visual.uv[index][component] = preserved.at("uvs").at(index).at(component);
            }
        }
    }
    if (!document.overlaid && detail.contains("stream_overrides")) {
        for (int stream = 0; stream < 4; ++stream) {
            for (const auto &change : detail.at("stream_overrides").value(kStreamValues[stream], Json::array())) {
                const auto index = change.at(0).get<int>();
                const auto component = change.at(1).get<int>();
                if (index < 0 || index >= counts[stream] || component < 0 || component >= 4) {
                    throw std::runtime_error("invalid native stream override");
                }
                streams[stream][index][component] = change.at(2).get<float>();
            }
        }
    }
    if (!mesh.primitives.empty() && !mesh.primitives.front().targets.empty()) {
        NativeMorph morph;
        morph.positions.resize(visual.vertex_num);
        morph.normals.resize(visual.normal_num);
        std::memcpy(morph.positions.data(), visual.vertex, visual.vertex_num * sizeof(sceVu0FVECTOR));
        std::memcpy(morph.normals.data(), visual.normal, visual.normal_num * sizeof(sceVu0FVECTOR));
        const auto count = mesh.primitives.front().targets.size();
        morph.position_deltas.resize(count, std::vector<std::array<float, 4> >(visual.vertex_num));
        morph.normal_deltas.resize(count, std::vector<std::array<float, 4> >(visual.normal_num));
        for (std::size_t primitive_index = 0; primitive_index < mesh.primitives.size(); ++primitive_index) {
            const auto &primitive = mesh.primitives[primitive_index];
            if (primitive.targets.size() != count) {
                throw std::runtime_error("inconsistent glTF morph target count");
            }
            const auto &metadata = detail.at("primitives").at(primitive_index);
            for (std::size_t target = 0; target < count; ++target) {
                for (const auto &attribute : primitive.targets[target]) {
                    const bool normal = attribute.name == "NORMAL";
                    if (!normal && attribute.name != "POSITION") {
                        continue;
                    }
                    const auto &mapping = Mapping(metadata, normal ? "source_normals" : "source_vertices");
                    auto       &destination = normal ? morph.normal_deltas[target] : morph.position_deltas[target];
                    const auto &accessor = document.asset.accessors.at(attribute.accessorIndex);
                    if (accessor.count != mapping.size()) {
                        throw std::runtime_error("glTF morph identity count mismatch");
                    }
                    fastgltf::iterateAccessorWithIndex<fastgltf::math::fvec3>(document.asset, accessor, [&](auto value, std::size_t corner) {
                        const auto index = mapping.at(corner).get<std::size_t>();
                        for (int axis = 0; axis < 3; ++axis) {
                            destination.at(index)[axis] = value[axis];
                        }
                    });
                }
            }
        }
        native_morphs.insert_or_assign(visual.vertex, std::move(morph));
    }
}

/**
 * Builds native skinning slots and weights from standard glTF joint attributes.
 */
void Skin(Document &document, const fastgltf::Node &node, const Json &detail, mgCVisualMotionMDT &visual,
          mgCMemory &memory) {
    const auto &skin = document.asset.skins.at(*node.skinIndex);
    if (skin.joints.size() > 32) {
        throw std::runtime_error("native visual exceeds 32 bone slots");
    }
    for (int &bone : visual.bone) {
        bone = -1;
    }
    for (std::size_t index = 0; index < skin.joints.size(); ++index) {
        visual.bone[index] = static_cast<int>(NativeFrameIndex(document, skin.joints[index]));
    }
    visual.weight_num = visual.vertex_num;
    visual.weight = Allocate<mgVertexWeight>(memory, visual.weight_num);
    std::vector<Matrix> inverse(skin.joints.size());
    for (std::size_t index = 0; index < skin.joints.size(); ++index) {
        if (skin.inverseBindMatrices) {
            const auto value = fastgltf::getAccessorElement<fastgltf::math::fmat4x4>(document.asset, document.asset.accessors.at(*skin.inverseBindMatrices), index);
            for (int column = 0; column < 4; ++column) {
                for (int row = 0; row < 4; ++row) {
                    inverse[index][column * 4 + row] = value[column][row];
                }
            }
        } else {
            inverse[index][0] = inverse[index][5] = inverse[index][10] = inverse[index][15] = 1;
        }
    }
    inverse_binds.insert_or_assign(visual.weight, InverseBinds{.frames = visual.frame, .frame_id = visual.frame_id, .matrices = std::move(inverse)});
    const auto &mesh = document.asset.meshes.at(*node.meshIndex);
    for (std::size_t primitive_index = 0; primitive_index < mesh.primitives.size(); ++primitive_index) {
        const auto                                       &primitive = mesh.primitives[primitive_index];
        std::vector<std::pair<std::size_t, std::size_t> > attributes;
        for (std::size_t group = 0;; ++group) {
            const auto *const joints = primitive.findAttribute("JOINTS_" + std::to_string(group));
            const auto *const weights = primitive.findAttribute("WEIGHTS_" + std::to_string(group));
            if (joints == primitive.attributes.end() && weights == primitive.attributes.end()) {
                break;
            }
            if (joints == primitive.attributes.end() || weights == primitive.attributes.end()) {
                throw std::runtime_error("skinned primitive lacks matching joint/weight groups");
            }
            attributes.emplace_back(joints->accessorIndex, weights->accessorIndex);
        }
        if (attributes.empty()) {
            throw std::runtime_error("skinned primitive lacks weights");
        }
        const auto &mapping = detail.at("primitives").at(primitive_index).at("source_vertices");
        for (const auto &[joints, weights] : attributes) {
            if (document.asset.accessors.at(joints).count != mapping.size() || document.asset.accessors.at(weights).count != mapping.size()) {
                throw std::runtime_error("skin attribute count mismatch");
            }
        }
        for (std::size_t corner = 0; corner < mapping.size(); ++corner) {
            auto &destination = visual.weight[mapping.at(corner).get<int>()];
            destination = {};
            int influences = 0;
            for (const auto &[joints, weights] : attributes) {
                const auto joint = fastgltf::getAccessorElement<fastgltf::math::uvec4>(document.asset, document.asset.accessors.at(joints), corner);
                const auto weight = fastgltf::getAccessorElement<fastgltf::math::fvec4>(document.asset, document.asset.accessors.at(weights), corner);
                for (int component = 0; component < 4; ++component) {
                    if (joint[component] >= skin.joints.size() || !std::isfinite(weight[component]) || weight[component] < 0) {
                        throw std::runtime_error("invalid native skin influence");
                    }
                    if (weight[component] == 0) {
                        continue;
                    }
                    if (influences < 4) {
                        destination.matrix[influences] = static_cast<int>(joint[component]) * 4;
                        destination.weight[influences] = weight[component];
                    }
                    ++influences;
                }
            }
            const auto total = destination.weight[0] + destination.weight[1] + destination.weight[2] + destination.weight[3];
            if (total > 0 && (total < 1 || influences > 4)) {
                for (auto &value : destination.weight) {
                    value /= total;
                }
            }
            if (total == 0) {
                destination.weight[0] = 1;
            }
        }
    }
    visual.vu1_base = static_cast<int>(skin.joints.size()) * 4 + 60;
    visual.vu1_offset = 180 - static_cast<int>(skin.joints.size()) * 2;
}

/**
 * Constructs a native key channel from decoded auxiliary values.
 */
Mot_List *Channel(const Json &channel, mgCMemory &memory) {
    auto *list = Allocate<Mot_List>(memory);
    native_channels.erase(list);
    list->frame = channel.at("frame");
    list->target = channel.at("target");
    list->type = channel.at("type");
    list->key_count = static_cast<u32>(channel.at("keys").size());
    list->values = Allocate<sceVu0FVECTOR>(memory, list->key_count);
    list->key_frames = Allocate<u32>(memory, list->key_count);
    for (u32 key = 0; key < list->key_count; ++key) {
        const auto &value = channel.at("keys").at(key);
        list->key_frames[key] = value.at("frame");
        for (int component = 0; component < 4; ++component) {
            list->values[key][component] = value.at("value").at(component);
        }
    }
    return list;
}

/**
 * Recounts the character's texture animation groups; for the base image slot, as retail's _IMG_END does, the
 * base image owns the leading named groups and later ones belong to extra motion images.
 */
void RefreshTexAnimeGroups(CCharacter2 &character, mgCTextureManager &manager, int slot) {
    char **names = manager.GetGroupNameList(character.texture_block, &character.tex_anime_group_num);
    if (slot != 0 || names == nullptr) {
        return;
    }
    int group = 0;
    while (group < character.tex_anime_group_num && names[group] != nullptr) {
        ++group;
    }
    character.tex_anime_group_start = group;
}

/**
 * Names the registered texture of a catalog picture entry.
 */
std::string PictureName(const texture_catalog::Entry &entry, const std::string &suffix) {
    auto name = GameName(entry.name);
    if (entry.picture > 0) {
        name += "#picture" + std::to_string(entry.picture);
    }
    return name + suffix;
}

} // namespace

void Clear() {
    character_models.clear();
    character_motion::Clear();
    documents.clear();
    inverse_binds.clear();
    native_channels.clear();
    native_morphs.clear();
    character_images.clear();
    reserved_images.clear();
    FrameConventions().clear();
}

bool UsesStandardScaleOrder(const mgCFrame *frame) {
    const auto found = FrameConventions().find(frame);
    return found != FrameConventions().end() && found->second.standard_scale;
}

void ForgetFrame(const mgCFrame *frame) {
    FrameConventions().erase(frame);
}

std::shared_ptr<const Json> ReadGameplay(const std::filesystem::path &gltf, std::string &error) {
    std::string identity;
    return ParseGameplay(gltf, error, identity);
}

std::vector<std::string> Profiles(const std::filesystem::path &gltf, std::string &error) {
    const auto               game = ReadGameplay(gltf, error);
    std::vector<std::string> profiles;
    if (game && game->contains("profiles")) {
        for (const auto &[name, profile] : game->at("profiles").items()) {
            profiles.push_back(name);
        }
    }
    return profiles;
}

namespace {
/**
 * Reads native command bytes for cloth and effect resources.
 */
std::string ScriptBytes(const Json &resource);

/**
 * Counts aligned native allocations without constructing game objects.
 */
struct ArenaEstimate {
    std::size_t bytes = 0; /**< Conservative total native arena bytes. */

    /**
     * Adds one aligned allocation with the native allocator's spare quadwords.
     */
    void Add(std::size_t count, std::size_t size) {
        if (count > (std::size_t{1} << 30) / std::max<std::size_t>(1, size)) {
            throw std::runtime_error("native character allocation exceeds limit");
        }
        bytes += ((count * size + 15) / 16 + 2) * 16;
    }

    /**
     * Counts one native motion channel and its values and key indices.
     */
    void Channel(std::size_t keys) {
        Add(1, sizeof(Mot_List));
        Add(keys, sizeof(sceVu0FVECTOR));
        Add(keys, sizeof(u32));
    }
};

/**
 * Counts frame, visual, stream, face and weight allocations for one selected model.
 */
void MeasureModel(const std::shared_ptr<Document> &source, std::size_t index, bool shadow, bool shape,
                  const std::vector<std::string> &animated, ArenaEstimate &estimate) {
    const auto  document = SelectModel(source, index);
    const auto &frames = document->metadata.at("frames");
    estimate.Add(frames.size(), sizeof(mgCFrame));
    estimate.Add(frames.size(), sizeof(mgCFrame *));
    estimate.Add(frames.size(), sizeof(sceVu0FMATRIX));
    for (std::size_t frame = 0; frame < frames.size(); ++frame) {
        const auto &node = ContentNode(*document, frame);
        const auto  name = GameName(std::string(document->asset.nodes.at(document->node_offset + frame).name));
        estimate.Add(name.size() + 1, sizeof(char));
        if (!frame || node.meshIndex || name.contains("--") || !node.visible) {
            estimate.Add(1, sizeof(mgCFrameAttr));
        }
        if (!node.meshIndex) {
            continue;
        }
        bool motion = false;
        for (const auto &driven : animated) {
            if (mgFrameNameComp(const_cast<char *>(name.c_str()), const_cast<char *>(driven.c_str()))) {
                motion = true;
            }
        }
        motion = motion && !shape && node.skinIndex.has_value() && !shadow;
        estimate.Add(1, shadow ? sizeof(mgCShadowMDT) : motion ? sizeof(mgCVisualMotionMDT)
                                                    : shape    ? sizeof(mgCVisualMDT)
                                                               : sizeof(mgCVisualFixMDT));
        const auto detail = MeshIdentity(*document, node, document->metadata.at("meshes").at(frames.at(frame).at("mdt").get<std::size_t>()));
        for (const char *count : kStreamCounts) {
            estimate.Add(detail.at(count).get<std::size_t>(), sizeof(sceVu0FVECTOR));
        }
        estimate.Add(detail.at("material_count").get<std::size_t>(), sizeof(mgMaterial));
        estimate.Add(1, sizeof(mgCFrame::BoundInfo));
        if (motion) {
            estimate.Add(detail.at("vertex_count").get<std::size_t>(), sizeof(mgVertexWeight));
        }
        const auto &mesh = document->asset.meshes.at(*node.meshIndex);
        for (std::size_t primitive = 0; primitive < mesh.primitives.size(); ++primitive) {
            const auto &standard = mesh.primitives[primitive];
            const auto &native = detail.at("primitives").at(primitive);
            const auto  type = native.at("type").get<int>();
            const auto  count = standard.indicesAccessor ? document->asset.accessors.at(*standard.indicesAccessor).count : Mapping(native, "source_vertices").size();
            const auto  stride = IndexStride(type);
            estimate.Add(1, sizeof(mgCFace));
            estimate.Add(1, sizeof(mgFACE_GROUP));
            estimate.Add(count * stride, sizeof(int));
        }
    }
}
} // namespace

namespace {
/**
 * Selects the clips of an animation resource that drive one model, or its first model's clips.
 */
const Json *SelectVariant(const Json &resource, std::optional<std::size_t> model);
} // namespace

std::optional<std::size_t> EstimateCharacterMemory(const std::filesystem::path &gltf, std::string_view profile, std::string &error) {
    try {
        const auto    source = Read(gltf);
        const auto   &game = *source->custom;
        const auto   &resources = game.at("resources");
        const auto    selected = profile.empty() ? game.at("default_profile").get<std::string>() : std::string(profile);
        const auto   &commands = game.at("profiles").at(selected).at("commands");
        ArenaEstimate estimate;
        estimate.Add(1, sizeof(CCharacter2));
        std::vector<std::pair<const Json *, std::size_t> > measured_textures;
        auto                                               measure_texture = [&](const std::shared_ptr<Document> &owner, std::size_t index) {
            const auto identity = std::pair<const Json *, std::size_t>{owner->custom.get(), index};
            if (std::ranges::find(measured_textures, identity) != measured_textures.end()) {
                return;
            }
            measured_textures.push_back(identity);
            const auto &entries = owner->custom->at("resources").at("texture_sets").at(index).at("document").at("entries");
            for (const auto &entry : entries) {
                if (entry.contains("script")) {
                    estimate.Add(1, sizeof(mgCTextureAnime));
                    for (const auto &statement : entry.at("script")) {
                        const auto tag = statement.at("command").get<std::string>();
                        if (tag == "TEX_ANIME_DATA_END") {
                            estimate.Add(1, sizeof(CList<mgCTexAnimeData>));
                        }
                        if (tag == "TEX_ANIME" && !statement.at("args").empty() && statement.at("args").at(0).contains("text")) {
                            estimate.Add(statement.at("args").at(0).at("text").get<std::string>().size() + 1, sizeof(char));
                        }
                    }
                }
            }
        };
        std::vector<std::string>   animated;
        bool                       shape = false;
        bool                       shadow_initialized = false;
        std::optional<std::size_t> model;
        std::optional<std::size_t> shadow_model;
        std::size_t                key_count = 0;
        std::size_t                sequence_count = 0;
        auto                       reference = [](const Json &args, std::size_t index) -> std::optional<std::size_t> {
            if (index >= args.size() || args.at(index).value("type", std::string{}) != "resource" || args.at(index).at("index").is_null()) {
                return std::nullopt;
            }
            return args.at(index).at("index").get<std::size_t>();
        };
        auto number = [](const Json &args, std::size_t index = 0) -> std::size_t {
            if (index >= args.size() || !args.at(index).contains("value") || !args.at(index).at("value").is_number()) {
                return 0;
            }
            const auto value = args.at(index).at("value").get<double>();
            if (!std::isfinite(value) || value < 0 || value > 1e8) {
                throw std::runtime_error("invalid native allocation count");
            }
            return static_cast<std::size_t>(value);
        };
        for (const auto &command : commands) {
            const auto  name = command.at("command").get<std::string>();
            const auto &args = command.at("args");
            if (name == "VERTEX_ANIME") {
                for (const auto &arg : args) {
                    if (arg.contains("value") && arg.at("value").is_string()) {
                        animated.push_back(GameName(arg.at("value").get<std::string>()));
                    }
                }
            } else if (name == "SHAPE_ANIME") {
                shape = number(args) != 0;
            } else if (name == "MODEL" || name == "SHADOW_MODEL" || name == "LOD_MODEL") {
                const bool shadow = name == "SHADOW_MODEL";
                const auto scene = reference(args, name == "LOD_MODEL" ? 1 : 0);
                if (!scene) {
                    continue;
                }
                MeasureModel(source, *scene, shadow, shape, animated, estimate);
                for (const auto &set : game.at("models").at(*scene).value("texture_sets", Json::array())) {
                    measure_texture(source, set.get<std::size_t>());
                }
                const auto frames = game.at("models").at(*scene).at("frames").size();
                if (shadow) {
                    shadow_model = scene;
                    estimate.Add(frames, sizeof(s32));
                    estimate.Add(frames, sizeof(s32));
                } else if (name == "MODEL") {
                    model = scene;
                } else {
                    estimate.Add(frames, sizeof(int[2]));
                }
            } else if (name == "MOTION" || name == "SHADOW_MOTION") {
                const bool shadow = name == "SHADOW_MOTION";
                const auto start = shadow ? 0u : 1u;
                const auto animation = shadow ? std::nullopt : reference(args, start);
                const auto bind = reference(args, start + 1);
                const auto weights = reference(args, start + 2);
                if (bind) {
                    estimate.Add(resources.at("bind_poses").at(*bind).at("matrices").size(), sizeof(sceVu0FMATRIX));
                }
                if (animation) {
                    estimate.Add(1, sizeof(Mot_List));
                    const auto &resource = resources.at("animations").at(*animation);
                    const Json *variant = SelectVariant(resource, model);
                    const auto &actions = resource.at("actions");
                    for (std::size_t index = 0; index < actions.size(); ++index) {
                        for (const auto &channel : actions.at(index).value("channels", Json::array())) {
                            estimate.Channel(channel.at("keys").size());
                        }
                        if (!variant || variant->at("animations").at(index).is_null()) {
                            continue;
                        }
                        const auto &clip = source->asset.animations.at(variant->at("animations").at(index).get<std::size_t>());
                        for (std::size_t channel = 0; channel < clip.channels.size(); ++channel) {
                            estimate.Add(1, sizeof(Mot_List));
                        }
                    }
                }
                if (weights) {
                    for (const auto &channel : resources.at("weights").at(*weights).at("channels")) {
                        estimate.Channel(channel.at("keys").size());
                    }
                }
                if (shadow && !shadow_initialized && shadow_model) {
                    shadow_initialized = true;
                    const auto &selected_model = game.at("models").at(*shadow_model);
                    estimate.Add(selected_model.at("frames").size() + 10, sizeof(tagFRAME_INF));
                    if (weights) {
                        std::vector<int> driven;
                        for (const auto &channel : resources.at("weights").at(*weights).at("channels")) {
                            const int frame = channel.at("frame");
                            if (std::ranges::find(driven, frame) != driven.end()) {
                                continue;
                            }
                            driven.push_back(frame);
                            const auto &identity = selected_model.at("frames").at(frame);
                            if (identity.at("mdt").is_null()) {
                                continue;
                            }
                            const auto &mesh = selected_model.at("meshes").at(identity.at("mdt").get<std::size_t>());
                            estimate.Add(mesh.at("vertex_count").get<std::size_t>(), sizeof(sceVu0FVECTOR));
                            estimate.Add(mesh.at("normal_count").get<std::size_t>(), sizeof(sceVu0FVECTOR));
                            estimate.Add(mesh.at("vertex_count").get<std::size_t>(), sizeof(FrameLinkRecord));
                        }
                    }
                }
            } else if (name == "IMG") {
                if (const auto texture = reference(args, 1)) {
                    measure_texture(source, *texture);
                }
            } else if (name == "KEY_START") {
                key_count = 0;
            } else if (name == "KEY") {
                ++key_count;
            } else if (name == "KEY_END") {
                estimate.Add(key_count + 1, sizeof(CHRINFO_KEY_SET));
            } else if (name == "SEQ_START") {
                sequence_count = 0;
                estimate.Add(1, sizeof(CHRINFO_SEQ_HEADER));
            } else if (name == "SEQ") {
                ++sequence_count;
            } else if (name == "SEQ_END") {
                estimate.Add(sequence_count + 1, sizeof(CHRINFO_SEQ));
            } else if (name == "SE_START") {
                estimate.Add(number(args), sizeof(CHRINFO_SE));
            } else if (name == "CLOTH_START") {
                estimate.Add(number(args), sizeof(CDynamicAnime));
            } else if (name == "LOD_MODEL_START") {
                estimate.Add(number(args), sizeof(CCharaLOD));
            } else if (name == "OUTLINE") {
                estimate.Add(1, sizeof(COutLineDraw));
            } else if (name == "CLOTH") {
                for (std::size_t index = 0; index < args.size(); ++index) {
                    if (const auto cloth = reference(args, index)) {
                        std::size_t vertices = 0;
                        for (const auto &statement : resources.at("cloths").at(*cloth).at("commands")) {
                            const auto  tag = statement.at("command").get<std::string>();
                            const auto &arguments = statement.at("args");
                            const auto  count = tag.ends_with("_START") ? number(arguments) : 0;
                            if (tag == "FRAME_START") {
                                estimate.Add(count, sizeof(mgCFrame *));
                                estimate.Add(count, sizeof(DA_FRAME_POSE));
                            } else if (tag == "VERTEX_START") {
                                vertices = count;
                                for (int stream = 0; stream < 5; ++stream) {
                                    estimate.Add(count, sizeof(sceVu0FVECTOR));
                                }
                            } else if (tag == "FIX_VERTEX_START") {
                                estimate.Add(vertices, sizeof(DA_FIX_VERTEX));
                            } else if (tag == "DRAW_FRAME") {
                                estimate.Add(arguments.size(), sizeof(int));
                            } else if (tag == "BIND_VERTEX_START") {
                                estimate.Add(count, sizeof(DA_BIND_VERTEX));
                            } else if (tag == "BOUNDING_BOX_START") {
                                estimate.Add(count, sizeof(DA_BOUNDING_BOX));
                            } else if (tag == "COLLISION_START") {
                                estimate.Add(count, sizeof(CDACollision *));
                            } else if (tag == "COLLISION") {
                                estimate.Add(1, 256);
                            } else if (tag == "FRAME_POSE_L") {
                                estimate.Add(1, sizeof(int));
                            }
                        }
                    }
                }
            } else if (name == "EFFECT") {
                if (const auto script = reference(args, 0)) {
                    const auto &resource = resources.at("scripts").at(*script);
                    for (const auto &set : resource.value("texture_sets", Json::array())) {
                        measure_texture(source, set.get<std::size_t>());
                    }
                    if (resource.contains("character")) {
                        const auto  child = Read(Relative(resource.at("character").get<std::string>()));
                        const auto &sets = child->custom->at("resources").at("texture_sets");
                        for (std::size_t index = 0; index < sets.size(); ++index) {
                            measure_texture(child, index);
                        }
                    }
                    auto           data = ScriptBytes(resource);
                    CEffectManager manager;
                    manager.Initialize();
                    int particles = 0;
                    int emitters = 0;
                    manager.GetBufferNums(data.data(), static_cast<int>(data.size()), &particles, &emitters);
                    if (particles < 0 || emitters < 0) {
                        throw std::runtime_error("invalid native effect counts");
                    }
                    estimate.Add(1, sizeof(CHRINFO_EFFECT));
                    estimate.Add(1, sizeof(CHARA_EFFECT_MANAGER));
                    estimate.Add(particles, sizeof(CEffect));
                    estimate.Add(emitters, sizeof(CEffectCtrl));
                }
            }
        }
        error.clear();
        return (estimate.bytes + 1023) / 1024 * 1024;
    } catch (const std::exception &exception) {
        error = exception.what();
        return std::nullopt;
    }
}

namespace {
/**
 * Marks the standard nodes some animation scales to a value other than one.
 */
const std::vector<bool> &ScaledNodes(Document &document) {
    if (!document.scaled_nodes) {
        auto scaled = std::make_shared<std::vector<bool> >(document.asset.nodes.size(), false);
        for (const auto &animation : document.asset.animations) {
            for (const auto &channel : animation.channels) {
                if (channel.path != fastgltf::AnimationPath::Scale || !channel.nodeIndex || *channel.nodeIndex >= scaled->size() || (*scaled)[*channel.nodeIndex]) {
                    continue;
                }
                const auto &accessor = document.asset.accessors.at(animation.samplers.at(channel.samplerIndex).outputAccessor);
                fastgltf::iterateAccessor<fastgltf::math::fvec3>(document.asset, accessor, [&](fastgltf::math::fvec3 value) {
                    for (std::size_t axis = 0; axis < 3; ++axis) {
                        if (std::abs(value[axis] - 1.0f) > 1e-6f) {
                            (*scaled)[*channel.nodeIndex] = true;
                        }
                    }
                });
            }
        }
        document.scaled_nodes = std::move(scaled);
    }
    return *document.scaled_nodes;
}

/**
 * Tells whether a frame's standard node composes its scale after its rotation, as glTF does.
 *
 * Replacement and third-party models always do. A game model does only where an animation scales the node; elsewhere
 * the authored scale stays in the frame's matrix and a scale gameplay sets composes in the game's order.
 */
bool StandardScaleOrder(Document &document, const fastgltf::Node &node) {
    if (document.standard_only || document.overlaid || !document.asset.assetInfo || !std::string_view(document.asset.assetInfo->generator).starts_with("Kazarov")) {
        return true;
    }
    const auto index = static_cast<std::size_t>(&node - document.asset.nodes.data());
    return index < document.asset.nodes.size() && ScaledNodes(document)[index];
}

mgCFrame *Instantiate(const std::shared_ptr<Document> &document, mgLoadData &load, std::string &error) {
    CT_PROFILE_ZONE("Instantiate model");
    try {
        const auto &frames = document->metadata.at("frames");
        if (frames.empty() || (document->frame_nodes.empty() && document->asset.nodes.size() < document->node_offset + frames.size())) {
            throw std::runtime_error("frame identity count mismatch");
        }
        auto  &memory = *load.memory;
        auto  &textures = load.texture_manager ? *load.texture_manager : mgTexManager;
        auto  *native = Allocate<mgCFrame>(memory, frames.size());
        auto **table = Allocate<mgCFrame *>(memory, frames.size());
        auto  *matrices = Allocate<sceVu0FMATRIX>(memory, frames.size());
        for (std::size_t index = 0; index < frames.size(); ++index) {
            table[index] = native + index;
        }
        for (std::size_t index = 0; index < frames.size(); ++index) {
            const auto &detail = frames.at(index);
            if (detail.value("id", index) != index) {
                throw std::runtime_error("noncontiguous frame identities");
            }
            const auto &logical = LogicalNode(*document, index);
            const auto &node = ContentNode(*document, index);
            const auto  name = GameName(logical.name.empty() ? detail.value("name", std::string{}) : std::string(logical.name));
            char        converted[512]{};
            if (name.size() >= 200) {
                throw std::runtime_error("frame name too long");
            }
            // The name's attribute suffix drives the game's native frame-attribute parser.
            ::conv_new_text(converted, const_cast<char *>(name.c_str()));
            auto *text = Allocate<char>(memory, std::strlen(converted) + 1);
            std::strcpy(text, converted);
            native[index].SetName(text);
            float           matrix[4][4];
            auto            transform = fastgltf::getLocalTransformMatrix(logical);
            FrameConvention convention;
            convention.helper = &logical != &node;
            const auto *node_trs = std::get_if<fastgltf::TRS>(&node.transform);
            convention.standard_scale = !convention.helper && node_trs && StandardScaleOrder(*document, node);
            fastgltf::TRS child_trs;
            if (convention.standard_scale) {
                transform = fastgltf::math::rotate(fastgltf::math::translate(fastgltf::math::fmat4x4(), node_trs->translation), node_trs->rotation);
                native[index].SetScale(const_cast<float *>(node_trs->scale.data()));
            } else if (!convention.helper && node_trs) {
                // The whole authored transform stays in the matrix, as in the game's data.
                convention.matrix_scale = node_trs->scale[0] != 1.0f || node_trs->scale[1] != 1.0f || node_trs->scale[2] != 1.0f;
            } else if (convention.helper) {
                if (const auto *trs = std::get_if<fastgltf::TRS>(&node.transform)) {
                    child_trs = *trs;
                } else {
                    fastgltf::math::decomposeTransformMatrix(fastgltf::getLocalTransformMatrix(node), child_trs.scale, child_trs.rotation, child_trs.translation);
                }
                const auto unscaled = fastgltf::math::rotate(fastgltf::math::translate(fastgltf::math::fmat4x4(), child_trs.translation), child_trs.rotation);
                transform = transform * fastgltf::getLocalTransformMatrix(node);
                for (int column = 0; column < 4; ++column) {
                    for (int row = 0; row < 4; ++row) {
                        convention.child_base[column * 4 + row] = unscaled[column][row];
                    }
                }
                for (int axis = 0; axis < 3; ++axis) {
                    convention.child_scale[axis] = child_trs.scale[axis];
                }
            }
            FrameConventions().insert_or_assign(&native[index], convention);
            for (int column = 0; column < 4; ++column) {
                for (int row = 0; row < 4; ++row) {
                    matrix[column][row] = transform[column][row];
                }
            }
            if (!document->overlaid && detail.contains("local_matrix")) {
                const auto original = detail.at("local_matrix").get<Matrix>();
                std::memcpy(matrix, original.data(), sizeof(matrix));
            }
            native[index].SetTransMatrix(matrix);
            if (index == 0 || node.meshIndex || std::strstr(converted, "--") || !node.visible || !logical.visible) {
                native[index].attr = Allocate<mgCFrameAttr>(memory);
            }
            if (!node.visible || !logical.visible) {
                native[index].attr->draw = MG_FRAME_DRAW_SKIP_CHILDREN;
            }
            if (!node.meshIndex) {
                continue;
            }
            const auto mesh = MeshIdentity(*document, node, document->metadata.at("meshes").at(detail.at("mdt").get<std::size_t>()));
            int        type = VisualType(load.visual_type, name);
            if (type == MG_VISUAL_CREATE_MOTION_MDT && !node.skinIndex) {
                type = MG_VISUAL_CREATE_FIX_MDT;
            }
            auto *visual = Visual(memory, type);
            visual->texture_manager = &textures;
            Mesh(*document, node, mesh, *visual, memory, textures);
            if (type == MG_VISUAL_CREATE_MOTION_MDT) {
                auto *motion = static_cast<mgCVisualMotionMDT *>(visual);
                motion->frame = table;
                motion->frame_id = static_cast<int>(index);
                motion->base_matrix = matrices;
                Skin(*document, node, mesh, *motion, memory);
            }
            native[index].SetVisual(visual);
            float maximum[4];
            float minimum[4];
            float sphere[4];
            mgCreateBBoxSphere(maximum, minimum, sphere, visual->vertex, visual->vertex_num);
            if (type == MG_VISUAL_CREATE_MDT) {
                for (int axis = 0; axis < 3; ++axis) {
                    const auto half = (maximum[axis] - minimum[axis]) * .5f;
                    maximum[axis] += half;
                    minimum[axis] -= half;
                }
                sphere[3] *= 1.5f;
            }
            native[index].bound = Allocate<mgCFrame::BoundInfo>(memory);
            native[index].SetBBox(maximum, minimum);
            native[index].SetBSphere(sphere, sphere[3]);
            if (type == MG_VISUAL_CREATE_MOTION_MDT) {
                static_cast<mgCVisualMotionMDT *>(visual)->SetBaseBox(maximum, minimum);
            }
            if (type == MG_VISUAL_CREATE_SHADOW_MDT || type == MG_VISUAL_CREATE_SHADOW_FIX_MDT) {
                ShadowFaces(*visual);
            }
            RefreshFaces(*visual);
        }
        std::vector<int> parents(frames.size(), -1);
        for (std::size_t index = 0; index < frames.size(); ++index) {
            for (const auto child : ContentNode(*document, index).children) {
                const auto native_child = NativeFrameIndex(*document, child);
                if (native_child >= frames.size() || parents[native_child] >= 0 || native_child == index) {
                    throw std::runtime_error("invalid frame hierarchy");
                }
                parents[native_child] = static_cast<int>(index);
            }
        }
        for (std::size_t index = 0; index < frames.size(); ++index) {
            int steps = 0;
            for (int ancestor = parents[index]; ancestor >= 0; ancestor = parents[ancestor]) {
                if (std::cmp_greater(++steps, frames.size())) {
                    throw std::runtime_error("cyclic frame hierarchy");
                }
            }
            if (parents[index] >= 0) {
                native[index].SetParent(native + parents[index]);
            }
        }
        native->frame_list = table;
        native->frame_num = static_cast<int>(frames.size());
        native->init_matrix = matrices;
        for (std::size_t index = 0; index < frames.size(); ++index) {
            native[index].GetLWMatrix(matrices[index]);
        }
        mgSetFrameAttr(native, 1);
        error.clear();
        return native;
    } catch (const std::exception &exception) {
        error = exception.what();
        return nullptr;
    }
}

/**
 * Derives native identities directly from the selected standard scene when no gameplay mapping is needed.
 */
std::shared_ptr<Document> StandardScene(const std::shared_ptr<Document> &source, std::size_t scene_index) {
    auto selected = Derive(*source);
    selected->standard_only = true;
    selected->metadata = {
        {"frames", Json::array()},
        {"meshes", Json::array()}
    };
    const auto &scene = source->asset.scenes.at(scene_index);
    if (scene.nodeIndices.empty()) {
        throw std::runtime_error("standard scene has no root nodes");
    }
    if (scene.nodeIndices.size() > 1) {
        selected->scene_root.emplace();
        selected->scene_root->name = scene.name;
        for (const auto root : scene.nodeIndices) {
            selected->scene_root->children.push_back(root);
        }
        selected->frame_nodes.push_back(std::numeric_limits<std::size_t>::max());
        selected->metadata["frames"].push_back({
            {"mdt", nullptr}
        });
    }
    std::unordered_set<std::size_t> visited;
    const auto                      visit = [&](auto &&self, std::size_t index) -> void {
        if (!visited.insert(index).second) {
            return;
        }
        const auto &node = source->asset.nodes.at(index);
        selected->frame_nodes.push_back(index);
        selected->metadata["frames"].push_back({
            {"mdt", node.meshIndex ? Json(*node.meshIndex) : Json(nullptr)}
        });
        for (const auto child : node.children) {
            self(self, child);
        }
    };
    for (const auto root : scene.nodeIndices) {
        visit(visit, root);
    }
    for (std::size_t index = 0; index < source->asset.meshes.size(); ++index) {
        selected->metadata["meshes"].push_back({
            {"materials",    Json::array()},
            {"primitives",   Json::array()},
            {"vertex_count", 0            },
            {"normal_count", 0            },
            {"uv_count",     0            },
            {"colour_count", 0            }
        });
    }
    return selected;
}

} // namespace

mgCFrame *LoadModel(const std::filesystem::path &gltf, mgLoadData &load, std::string &error,
                    std::optional<std::size_t> model) {
    try {
        const auto document = Read(gltf, true);
        if (document->standard_only) {
            return Instantiate(StandardScene(document, model.value_or(document->asset.defaultScene.value_or(0))), load, error);
        }
        EnterModelTextures(document, model, {.model_memory = load.memory, .motion_memory = load.memory, .image_memory = load.memory, .textures = load.texture_manager}, nullptr);
        return Instantiate(SelectModel(document, model), load, error);
    } catch (const std::exception &exception) {
        error = exception.what();
        return nullptr;
    }
}

mgCFrame *LoadModel(std::span<const std::byte> gltf, const Json &game, mgLoadData &load, std::string &error,
                    std::optional<std::size_t> model) {
    try {
        const auto document = ReadBytes(gltf, game);
        EnterModelTextures(document, model, {.model_memory = load.memory, .motion_memory = load.memory, .image_memory = load.memory, .textures = load.texture_manager}, nullptr);
        return Instantiate(SelectModel(document, model), load, error);
    } catch (const std::exception &exception) {
        error = exception.what();
        return nullptr;
    }
}

mgCFrame *LoadModelScene(const std::filesystem::path &gltf, std::string_view name, mgLoadData &load, std::string &error) {
    try {
        const auto                 document = Read(gltf, true);
        std::optional<std::size_t> selected_scene;
        for (std::size_t index = 0; index < document->asset.scenes.size(); ++index) {
            if (document->asset.scenes[index].name == name) {
                if (selected_scene) {
                    throw std::runtime_error("ambiguous standard scene: " + std::string(name));
                }
                selected_scene = index;
            }
        }
        if (!selected_scene) {
            throw std::runtime_error("standard scene missing: " + std::string(name));
        }
        if (document->standard_only) {
            return Instantiate(StandardScene(document, *selected_scene), load, error);
        }
        std::optional<std::size_t> selected_model;
        if (document->custom->contains("models")) {
            const auto &models = document->custom->at("models");
            for (std::size_t index = 0; index < models.size(); ++index) {
                if (models[index].at("scene").get<std::size_t>() == *selected_scene) {
                    selected_model = index;
                    break;
                }
            }
            if (!selected_model) {
                throw std::runtime_error("standard scene lacks gameplay frame identities: " + std::string(name));
            }
        } else if (document->custom->value("scene", document->asset.defaultScene.value_or(0)) != *selected_scene) {
            return Instantiate(StandardScene(document, *selected_scene), load, error);
        }
        EnterModelTextures(document, selected_model, {.model_memory = load.memory, .motion_memory = load.memory, .image_memory = load.memory, .textures = load.texture_manager}, nullptr);
        return Instantiate(SelectModel(document, selected_model), load, error);
    } catch (const std::exception &exception) {
        error = exception.what();
        return nullptr;
    }
}

namespace {
Mot_List *BuildChannels(const std::shared_ptr<Document> &document, std::optional<std::size_t> animation_index,
                        const Json &auxiliary, mgCMemory &memory) {
    Mot_List *head = nullptr;
    auto    **tail = &head;
    for (const auto &channel : auxiliary) {
        if (channel.at("type").get<int>() <= MOTION_KEY_TRANSLATION && animation_index) {
            continue;
        }
        if (channel.at("type").get<int>() == MOTION_KEY_VERTEX && animation_index) {
            bool morph = false;
            for (const auto &target : document->asset.animations.at(*animation_index).channels) {
                if (target.path == fastgltf::AnimationPath::Weights && target.nodeIndex && NativeFrameIndex(*document, *target.nodeIndex) == channel.at("frame").get<std::size_t>()) {
                    morph = true;
                }
            }
            if (morph) {
                continue;
            }
        }
        *tail = Channel(channel, memory);
        tail = &(*tail)->next;
    }
    if (animation_index) {
        const auto &animation = document->asset.animations.at(*animation_index);
        for (const auto &channel : animation.channels) {
            if (!channel.nodeIndex || *channel.nodeIndex < document->node_offset) {
                throw std::runtime_error("animation channel lacks frame identity");
            }
            const auto &sampler = animation.samplers.at(channel.samplerIndex);
            auto       *list = Allocate<Mot_List>(memory);
            list->frame = static_cast<int>(NativeFrameIndex(*document, *channel.nodeIndex));
            list->target = 0;
            switch (channel.path) {
                case fastgltf::AnimationPath::Rotation:
                    list->type = MOTION_KEY_ROTATION;
                    break;
                case fastgltf::AnimationPath::Scale:
                    list->type = MOTION_KEY_SCALE;
                    break;
                case fastgltf::AnimationPath::Translation:
                    list->type = MOTION_KEY_TRANSLATION;
                    break;
                case fastgltf::AnimationPath::Weights:
                    list->type = MOTION_KEY_VERTEX;
                    list->target = -1;
                    break;
                default:
                    throw std::runtime_error("unsupported glTF animation path");
            }
            const auto   &input = document->asset.accessors.at(sampler.inputAccessor);
            const auto   &output = document->asset.accessors.at(sampler.outputAccessor);
            const bool    cubic = sampler.interpolation == fastgltf::AnimationInterpolation::CubicSpline;
            NativeChannel retained{.document = document, .sampler = sampler, .times = {}};
            retained.helper_scale = channel.path == fastgltf::AnimationPath::Scale && document->rotation_nodes.contains(*channel.nodeIndex);
            retained.retail_rotation = !document->overlaid && document->asset.assetInfo && document->asset.assetInfo->generator == "Kazarov";
            if (channel.path == fastgltf::AnimationPath::Weights) {
                const auto &node = document->asset.nodes.at(*channel.nodeIndex);
                if (!node.meshIndex) {
                    throw std::runtime_error("morph channel targets a frame without mesh");
                }
                retained.morph_targets = document->asset.meshes.at(*node.meshIndex).primitives.front().targets.size();
            }
            if (!input.count || input.count * (cubic ? 3 : 1) * (retained.morph_targets ? retained.morph_targets : 1) != output.count) {
                throw std::runtime_error("glTF animation key count mismatch");
            }
            // The native evaluator samples the document's own accessors, so the arena holds only the channel record;
            // its key arrays stay empty.
            list->key_count = static_cast<u32>(input.count);
            list->values = nullptr;
            list->key_frames = nullptr;
            for (std::size_t key = 0; key < input.count; ++key) {
                const float time = fastgltf::getAccessorElement<float>(document->asset, input, key) * 30.0f;
                if (!std::isfinite(time) || time < 0 || time > 4294967040.0f || (!retained.times.empty() && time <= retained.times.back())) {
                    throw std::runtime_error("invalid glTF animation timeline");
                }
                retained.times.push_back(time);
            }
            native_channels.insert_or_assign(list, std::move(retained));
            *tail = list;
            tail = &list->next;
        }
    }
    return head;
}

/**
 * Selects the clips of an animation resource that drive one model, or its first model's clips.
 */
const Json *SelectVariant(const Json &resource, std::optional<std::size_t> model) {
    if (!resource.contains("variants")) {
        return nullptr;
    }
    for (const auto &variant : resource.at("variants")) {
        if (!model || variant.at("model").get<std::size_t>() == *model) {
            return &variant;
        }
    }
    return nullptr;
}

/**
 * Builds the native channels of every named action of one animation resource.
 *
 * Channel key frames are local to each action; the caller assigns the actions' game frames.
 */
std::vector<character_motion::Action> BuildActions(const std::shared_ptr<Document> &owner, const Json &resource,
                                                   std::optional<std::size_t> model, mgCMemory &memory) {
    const auto *variant = SelectVariant(resource, model);
    if (variant) {
        model = variant->at("model").get<std::size_t>();
    }
    auto document = SelectModel(owner, model);
    if (variant) {
        document->node_offset = variant->at("node_offset").get<std::size_t>();
    }
    const auto                           &actions = resource.at("actions");
    std::vector<character_motion::Action> built;
    for (std::size_t index = 0; index < actions.size(); ++index) {
        const auto                &action = actions.at(index);
        std::optional<std::size_t> clip;
        if (variant && !variant->at("animations").at(index).is_null()) {
            clip = variant->at("animations").at(index).get<std::size_t>();
        }
        built.push_back({.name = action.at("name").get<std::string>(), .duration = action.at("duration").get<float>(), .base = 0, .head = BuildChannels(document, clip, action.value("channels", Json::array()), memory)});
    }
    return built;
}

/**
 * Finds the actions a model's bundle holds for a motion published from another bundle.
 */
const Json &ExternalResource(const Json &resource, const std::optional<MotionOwner> &owner) {
    const auto key = resource.at("external").get<std::string>();
    if (!owner) {
        throw std::runtime_error("external motion " + key + " needs a character model");
    }
    for (const auto &candidate : Resources(*owner->document).at("animations")) {
        if (candidate.value("external", std::string{}) == key && candidate.contains("variants")) {
            return candidate;
        }
    }
    throw std::runtime_error("character model " + owner->document->relative.generic_string() + " lacks the actions of external motion " + key);
}

/**
 * Builds motion records from direct resource indices in the embedded glTF semantics.
 *
 * Returns the named actions of the selected animation, with game frames from zero.
 */
std::vector<character_motion::Action> BuildMotion(const std::shared_ptr<Document> &source, tagMOTION_TYPE &motion, mgCMemory &memory,
                                                  std::optional<std::size_t> animation, std::optional<std::size_t> bind_pose,
                                                  std::optional<std::size_t> weights, std::optional<std::size_t> model,
                                                  const std::optional<MotionOwner> &owner = std::nullopt) {
    const auto &resources = Resources(*source);
    auto        document = SelectModel(source, model);
    motion = {};
    if (bind_pose) {
        const auto &matrices = resources.at("bind_poses").at(*bind_pose).at("matrices");
        if (matrices.size() < document->metadata.at("frames").size()) {
            throw std::runtime_error("bind pose lacks native frame matrices");
        }
        motion.base_matrices = Allocate<sceVu0FMATRIX>(memory, matrices.size());
        for (std::size_t index = 0; index < matrices.size(); ++index) {
            const auto value = matrices.at(index).get<Matrix>();
            std::memcpy(motion.base_matrices[index], value.data(), sizeof(sceVu0FMATRIX));
        }
    }
    std::vector<character_motion::Action> actions;
    if (animation) {
        if (source->custom->contains("resources")) {
            const auto &resource = resources.at("animations").at(*animation);
            if (resource.contains("external") && !resource.contains("variants")) {
                actions = BuildActions(owner->document, ExternalResource(resource, owner), owner->model, memory);
            } else {
                actions = BuildActions(source, resource, model, memory);
            }
        } else {
            // A standalone model's clip is one action named by its glTF animation.
            const auto &clip = source->asset.animations.at(*animation);
            float       duration = 0;
            for (const auto &sampler : clip.samplers) {
                const auto &input = source->asset.accessors.at(sampler.inputAccessor);
                duration = std::max(duration, fastgltf::getAccessorElement<float>(source->asset, input, input.count - 1) * 30.0f);
            }
            actions.push_back({.name = std::string(clip.name), .duration = duration, .base = 0, .head = BuildChannels(document, animation, source->custom->value("motion_channels", Json::array()), memory)});
        }
        // The anchor identifies the motion set; each action keeps its own channel list.
        auto *anchor = Allocate<Mot_List>(memory);
        native_channels.erase(anchor);
        anchor->frame = -1;
        motion.motion_list = anchor;
    }
    if (weights) {
        motion.skin_list = BuildChannels(document, std::nullopt, resources.at("weights").at(*weights).at("channels"), memory);
    }
    return actions;
}

/**
 * Gives a motion set's actions consecutive game-frame intervals and registers them.
 *
 * Intervals are two frames apart, so a frame rounded up at an action's end stays in that action.
 */
void RegisterActions(const tagMOTION_TYPE &motion, std::vector<character_motion::Action> actions, int base) {
    if (!motion.motion_list) {
        return;
    }
    for (auto &action : actions) {
        action.base = base;
        base += static_cast<int>(std::ceil(action.duration)) + 2;
    }
    character_motion::Register(motion.motion_list, std::move(actions));
}

/**
 * Resolves a typed resource argument without legacy filenames or pack lookup.
 */
std::optional<std::size_t> Reference(const Json &arguments, std::size_t index, std::string_view kind) {
    if (index >= arguments.size()) {
        return std::nullopt;
    }
    const auto &value = arguments.at(index);
    if (value.value("type", std::string{}) != "resource") {
        return std::nullopt;
    }
    if (value.at("kind").get<std::string>() != kind) {
        throw std::runtime_error("character resource kind mismatch");
    }
    if (value.at("index").is_null()) {
        return std::nullopt;
    }
    return value.at("index").get<std::size_t>();
}

/**
 * Decodes ordinary typed profile arguments for the native gameplay callbacks.
 */
std::vector<SPI_STACK> Arguments(const Json &arguments, std::vector<std::string> &strings) {
    return command_replay::Arguments(arguments, strings);
}

/**
 * Constructs one scene using the selected native visual classes.
 */
mgCFrame *Scene(const std::shared_ptr<Document> &source, std::size_t index, const CharacterLoadOptions &options, mgCreateVisualType *types, CCharacter2 *character) {
    EnterModelTextures(source, index, options, character);
    mgLoadData load{};
    load.memory = options.model_memory;
    load.texture_manager = options.textures;
    load.visual_type = types;
    std::string error;
    auto       *frame = Instantiate(SelectModel(source, index), load, error);
    if (!frame) {
        throw std::runtime_error(error);
    }
    character_motion::ForgetPose(frame);
    return frame;
}

/**
 * Rebinds replacement visuals and bind matrices to the target character hierarchy.
 */
void Rebind(mgCFrame &source, mgCFrame &target, const sceVu0FMATRIX *matrices) {
    for (int index = 0; index < source.frame_num; ++index) {
        auto     *frame = source.GetFrame(index);
        const int destination = frame && frame->name ? target.SearchFrameID(frame->name) : -1;
        if (destination < 0) {
            continue;
        }
        if (matrices && target.init_matrix) {
            std::memcpy(target.init_matrix[destination], matrices[index], sizeof(sceVu0FMATRIX));
        }
        if (frame->visual && frame->visual->Iam() == MG_VISUAL_KIND_MOTION_MDT) {
            auto *visual = static_cast<mgCVisualMotionMDT *>(frame->visual);
            for (int &bone : visual->bone) {
                if (bone < 0) {
                    continue;
                }
                auto *joint = source.GetFrame(bone);
                bone = joint && joint->name ? target.SearchFrameID(joint->name) : -1;
                if (bone < 0) {
                    throw std::runtime_error("replacement skin joint absent from character");
                }
            }
            visual->frame = target.frame_list;
            visual->base_matrix = target.init_matrix;
            visual->frame_id = destination;
        }
    }
}

/**
 * Matches shadow frames to character frames by their native frame names.
 */
void MatchShadow(CCharacter2 &character, mgCMemory &memory) {
    auto *root = character.CObjectFrame::frame;
    auto *shadow = character.shadow_frame;
    if (!root || !shadow) {
        return;
    }
    auto &link = character.shadow_link;
    link.num = 0;
    link.src_frame = Allocate<s32>(memory, shadow->frame_num);
    link.dst_frame = Allocate<s32>(memory, shadow->frame_num);
    for (int index = 0; index < shadow->frame_num; ++index) {
        auto      *frame = shadow->GetFrame(index);
        const auto target = frame && frame->name ? root->SearchFrameID(frame->name) : -1;
        if (target >= 0) {
            link.src_frame[link.num] = target;
            link.dst_frame[link.num++] = index;
        }
    }
}
} // namespace

bool LoadAnimation(const std::filesystem::path &gltf, tagMOTION_TYPE &motion, mgCMemory &memory,
                   std::optional<std::size_t> animation, std::optional<std::size_t> bind_pose,
                   std::optional<std::size_t> weights, std::optional<std::size_t> model, std::string &error) {
    return Attempt(error, [&] {
        RegisterActions(motion, BuildMotion(Read(gltf), motion, memory, animation, bind_pose, weights, model), 0);
    });
}

bool LoadAnimation(std::span<const std::byte> gltf, const Json &game, tagMOTION_TYPE &motion, mgCMemory &memory,
                   std::optional<std::size_t> animation, std::optional<std::size_t> bind_pose,
                   std::optional<std::size_t> weights, std::optional<std::size_t> model, std::string &error) {
    return Attempt(error, [&] {
        RegisterActions(motion, BuildMotion(ReadBytes(gltf, game), motion, memory, animation, bind_pose, weights, model), 0);
    });
}

namespace {
/**
 * Reads native JSON commands used by an embedded cloth or effect resource.
 */
std::string ScriptBytes(const Json &resource) {
    if (resource.contains("commands")) {
        return Json{
            {"schema_version", 1                      },
            {"commands",       resource.at("commands")}
        }
            .dump();
    }
    const auto relative = Relative(resource.at("path").get<std::string>());
    for (const auto &path : datapacks::Candidates(relative)) {
        std::vector<uint8_t> bytes;
        if (!datapacks::ReadFileBytes(path, bytes)) {
            continue;
        }
        std::string data(bytes.begin(), bytes.end());
        if (relative.extension() == ".stb") {
            return data;
        }
        const auto json = Json::parse(data, nullptr, false);
        if (!json.is_discarded() && json.value("schema_version", 0) == 1) {
            return data;
        }
    }
    throw std::runtime_error("native character script missing or invalid");
}

/**
 * Resolves the standard image index encoded by an embedded texture mip reference.
 */
std::size_t ImageIndex(std::string_view reference) {
    constexpr std::string_view prefix = "#/images/";
    if (!reference.starts_with(prefix)) {
        throw std::runtime_error("texture set requires glTF image reference");
    }
    std::size_t consumed = 0;
    const auto  value = std::stoull(std::string(reference.substr(prefix.size())), &consumed);
    if (consumed != reference.size() - prefix.size()) {
        throw std::runtime_error("invalid glTF image reference");
    }
    return value;
}

/**
 * Shares resolved image sources between prefetching, identities and decoding for one texture registration.
 */
struct ResolvedImages {
    std::shared_ptr<Document>                                            document;      /**< Document owning the images. */
    std::unordered_map<std::size_t, std::shared_ptr<const ImageSource> > images;        /**< Resolved sources by standard image index. */
    bool                                                                 active = true; /**< Whether resolutions are reused; later decodes resolve afresh. */

    /**
     * Resolves one image, reusing an earlier resolution while the registration is active.
     */
    std::shared_ptr<const ImageSource> Resolve(std::size_t image) {
        if (!active) {
            return std::make_shared<const ImageSource>(ResolveImage(*document, image));
        }
        auto found = images.find(image);
        if (found == images.end()) {
            found = images.emplace(image, std::make_shared<const ImageSource>(ResolveImage(*document, image))).first;
        }
        return found->second;
    }
};

/**
 * Whether every picture of a texture set is already registered under its name, in any block.
 */
bool SetAlreadyEntered(const texture_catalog::Source &source, mgCTextureManager &textures) {
    bool any = false;
    for (const auto &entry : source.entries) {
        if (entry.type != "texture" || entry.name.starts_with('#')) {
            continue;
        }
        auto name = PictureName(entry, textures.name_suffix);
        if (!textures.SearchHash(name.data(), -1)) {
            return false;
        }
        any = true;
    }
    return any;
}

/**
 * Enters embedded pictures, mip chains, variants and texture animation into the native manager.
 */
void EnterTextureSet(const std::shared_ptr<Document> &document, std::size_t index, const CharacterLoadOptions &options, CCharacter2 *character, int slot) {
    datapacks::TraceTimer timer("model.enter_texture_set_us");
    datapacks::Trace("model.enter_texture_sets");
    datapacks::StampScope stamps;
    auto                 &cached = document->texture_sets[index];
    std::string           error;
    if (!cached) {
        datapacks::TraceTimer set_timer("model.decode_set_us");
        auto                  source = std::make_shared<texture_catalog::Source>();
        if (!texture_catalog::DecodeEmbeddedSet(Resources(*document).at("texture_sets").at(index).at("document"), document->relative, [document](std::string_view reference, int &width, int &height, std::string &failure) {
                try {
                    ImageExtent(*document, ImageIndex(reference), width, height);
                    return true;
                } catch (const std::exception &exception) {
                    failure = exception.what();
                    return false;
                } }, *source, error)) {
            throw std::runtime_error(error);
        }
        cached = std::move(source);
    }
    auto *textures = options.textures ? options.textures : &mgTexManager;
    auto *memory = options.image_memory ? options.image_memory : options.model_memory;
    // Retail models look their textures up by name. A plain model's set whose pictures are all registered already,
    // as a map piece's copy of the set its map entered into the map's own blocks, stays with that owner: entering it
    // again from block 0 would put the pictures, and the texture animation that follows them by name, in blocks
    // that outlive the memory the animation is allocated from.
    if (!character && SetAlreadyEntered(*cached, *textures)) {
        return;
    }
    bool owned = false;
    if (character) {
        for (const auto &entered : character_images[character]) {
            if (entered.source == cached && entered.manager == textures && entered.block == options.texture_block &&
                entered.slot == slot && entered.suffix == textures->name_suffix) {
                owned = true;
                break;
            }
        }
    }
    auto resolved = std::make_shared<ResolvedImages>();
    resolved->document = document;
    {
        std::vector<std::shared_ptr<const ImageSource> > sources;
        for (const auto &entry : cached->entries) {
            if (entry.type == "cfg" || entry.no_image) {
                continue;
            }
            for (const auto &variant : entry.variants) {
                for (const auto &level : variant.levels) {
                    // Invalid references are reported when the registration decodes them.
                    try {
                        sources.push_back(resolved->Resolve(ImageIndex(level.path)));
                    } catch (const std::exception &) {
                    }
                }
            }
        }
        datapacks::TraceTimer prefetch_timer("model.prefetch_images_us");
        PrefetchImages(sources);
    }
    datapacks::TraceTimer native_timer("model.enter_native_set_us");
    MgTextureEnterNativeSet(
        textures, options.texture_block, *cached, memory,
        [resolved](const texture_catalog::Entry &entry, std::size_t variant, datapacks::DecodedTexture &decoded, std::string &failure) {
            try {
                decoded = {};
                if (entry.no_image) {
                    decoded.width = entry.width;
                    decoded.height = entry.height;
                    return true;
                }
                for (const auto &level : entry.variants.at(variant).levels) {
                    AppendCanvas(*SourcePixels(*resolved->Resolve(ImageIndex(level.path))), decoded);
                }
                return true;
            } catch (const std::exception &exception) {
                failure = exception.what();
                return false;
            }
        },
        [resolved](const texture_catalog::Entry &entry, std::size_t variant) {
            try {
                if (entry.no_image) {
                    return std::string("no image");
                }
                std::string identity = "levels";
                for (const auto &level : entry.variants.at(variant).levels) {
                    identity += '\n' + SourceIdentity(*resolved->Resolve(ImageIndex(level.path)));
                }
                return identity;
            } catch (const std::exception &) {
                return std::string{};
            }
        });
    resolved->active = false;
    resolved->images.clear();
    if (!character) {
        return;
    }
    if (!owned) {
        character_images[character].push_back({.slot = slot, .block = options.texture_block, .manager = textures, .source = cached, .memory = memory, .suffix = textures->name_suffix});
    }
    character->texture_block = options.texture_block;
    RefreshTexAnimeGroups(*character, *textures, slot);
}

/**
 * Instantiates an effect's native pools and attachment metadata from typed profile values.
 */
void CharacterEffect(CCharacter2 &character, const Json &resource, std::vector<SPI_STACK> &stack, mgCMemory &memory) {
    if (stack.size() < 7) {
        throw std::runtime_error("character effect lacks attachment arguments");
    }
    auto  script = ScriptBytes(resource);
    auto *entry = Allocate<CHRINFO_EFFECT>(memory);
    auto *manager = Allocate<CHARA_EFFECT_MANAGER>(memory);
    manager->Initialize();
    int particles = 0;
    int emitters = 0;
    manager->GetBufferNums(script.data(), static_cast<int>(script.size()), &particles, &emitters);
    if (particles < 0 || emitters < 0) {
        throw std::runtime_error("invalid character effect pool sizes");
    }
    manager->particle_pool = Allocate<CEffect>(memory, particles);
    manager->emitter_pool = Allocate<CEffectCtrl>(memory, emitters);
    for (int index = 0; index < particles; ++index) {
        manager->particle_pool[index].Initialize();
    }
    for (int index = 0; index < emitters; ++index) {
        manager->emitter_pool[index].Initialize();
    }
    manager->EntryEffCtrls(manager->particle_pool, particles, manager->emitter_pool, emitters);
    manager->Load(script.data(), static_cast<int>(script.size()));
    manager->local_draw = spiGetStackInt(&stack[2]);
    for (int axis = 0; axis < 3; ++axis) {
        manager->offset[axis] = spiGetStackFloat(&stack[4 + axis]);
    }
    manager->offset[3] = 1;
    auto copy = [](char *destination, std::size_t capacity, const char *value) {
        if (!value) {
            value = "";
        }
        if (std::strlen(value) >= capacity) {
            throw std::runtime_error("character effect metadata too long");
        }
        std::strcpy(destination, value);
    };
    copy(entry->name, sizeof(entry->name), spiGetStackString(&stack[1]));
    copy(manager->frame_name, sizeof(manager->frame_name), spiGetStackString(&stack[3]));
    copy(manager->motion_name, sizeof(manager->motion_name), stack.size() > 7 ? spiGetStackString(&stack[7]) : nullptr);
    manager->start_ratio = stack.size() > 8 ? spiGetStackFloat(&stack[8]) : 0;
    entry->effect = manager;
    auto **tail = &character.effect_list;
    while (*tail) {
        tail = &(*tail)->next;
    }
    *tail = entry;
}

/**
 * First game frame free for new actions of a motion set, after every other set's KEY intervals.
 */
int NextActionFrame(const CCharacter2 &character, int slot) {
    int next = 2;
    for (int set = 0; set < CHARA_MOTION_SET_MAX; ++set) {
        if (set == slot || !character.key_list[set]) {
            continue;
        }
        for (int key = 0; key < character.key_num[set]; ++key) {
            next = std::max(next, character.key_list[set][key].end_frame + 2);
        }
    }
    return next;
}

/**
 * Replaces a profile's English motion name by the original name the game compares.
 */
Json OriginalMotionName(const Json &custom, const Json &argument) {
    const auto name = argument.at("value").get<std::string>();
    const auto names = custom.find("game_names");
    if (names == custom.end() || !names->contains(name)) {
        throw std::runtime_error("profile names an unknown motion: " + name);
    }
    return names->at(name);
}

/**
 * Applies an ordered gameplay profile to native frames and gameplay records.
 */
void CharacterProfile(CCharacter2 &character, const std::shared_ptr<Document> &document, std::string_view profile,
                      std::string_view skin_name, const CharacterLoadOptions &options, bool skin) {
    if (!options.model_memory) {
        throw std::runtime_error("character model arena required");
    }
    auto       &memory = *options.model_memory;
    auto       &motion_memory = options.motion_memory ? *options.motion_memory : memory;
    const auto &custom = *document->custom;
    const auto &resources = custom.at("resources");
    const auto  selected_profile = profile.empty() ? custom.at("default_profile").get<std::string>() : std::string(profile);
    const auto &commands = custom.at("profiles").at(selected_profile).at("commands");
    auto       *had_motion = character.GetKeyListIndexPtr(0, nullptr);
    const int   initial_used = memory.stack_used;
    std::string name(skin_name);
    PortCharacterMetadataBegin(&character, &memory, &motion_memory, options.image_memory, options.texture_block, options.parent, options.outline, name.c_str());
    std::optional<std::size_t> selected_model;
    std::optional<std::size_t> shadow_model;
    int                        motion_slot = 0;
    // Actions of the current motion set by English name, for the KEY commands that follow.
    std::vector<character_motion::Action> slot_actions;
    for (const auto &command : commands) {
        const auto               tag_name = command.at("command").get<std::string>();
        const auto              &args = command.at("args");
        std::vector<std::string> strings;
        auto                     stack = Arguments(args, strings);
        if (tag_name == "MODEL") {
            selected_model = Reference(args, 0, "model");
            if (!selected_model) {
                continue;
            }
            if (!skin) {
                PortCharacterMetadataModel(Scene(document, *selected_model, options, PortCharacterMetadataVisualTypes(false), &character));
                character_models.insert_or_assign(&character, MotionOwner{.document = document, .model = *selected_model});
            }
        } else if (tag_name == "SHADOW_MODEL") {
            auto index = Reference(args, 0, "model");
            if (!index) {
                continue;
            }
            char               empty[] = "";
            mgCreateVisualType types[] = {
                {.type = MG_VISUAL_CREATE_SHADOW_MDT, .name = empty  },
                {.type = MG_VISUAL_CREATE_END,        .name = nullptr}
            };
            character.shadow_frame = Scene(document, *index, options, types, &character);
            shadow_model = index;
            MatchShadow(character, memory);
        } else if (tag_name == "MOTION" || tag_name == "SHADOW_MOTION") {
            const bool        shadow = tag_name == "SHADOW_MOTION";
            const std::size_t start = shadow ? 0 : 1;
            if (!shadow) {
                motion_slot = spiGetStackInt(stack.data());
                PortCharacterMetadataMotionSlot(motion_slot);
            }
            if (motion_slot < 0 || motion_slot >= CHARA_MOTION_SET_MAX) {
                throw std::runtime_error("character motion slot out of range");
            }
            const auto animation = Reference(args, start, "animation");
            const auto bind = Reference(args, start + 1, "bind_pose");
            const auto weights = Reference(args, start + 2, "weights");
            if (skin) {
                if (!selected_model || !character.CObjectFrame::frame) {
                    continue;
                }
                auto          *replacement = Scene(document, *selected_model, options, PortCharacterMetadataVisualTypes(true), &character);
                tagMOTION_TYPE replacement_motion{};
                BuildMotion(document, replacement_motion, memory, std::nullopt, bind, weights, selected_model);
                auto *root = character.CObjectFrame::frame;
                Rebind(*replacement, *root, replacement_motion.base_matrices);
                for (int index = 0; index < replacement->frame_num; ++index) {
                    auto *frame = replacement->GetFrame(index);
                    if (!frame || !frame->visual || !frame->name) {
                        continue;
                    }
                    auto *target = root->SearchFrame(frame->name);
                    if (!target) {
                        continue;
                    }
                    if (character.shape_anime && !skin_name.empty() && skin_name != frame->name) {
                        continue;
                    }
                    target->SetVisual(frame->visual);
                    float maximum[4];
                    float minimum[4];
                    frame->GetBBox(maximum, minimum);
                    target->SetBBox(maximum, minimum);
                }
                if (character.shape_anime && weights) {
                    auto    **tail = &character.motion[0].skin_list;
                    const int target_id = root->SearchFrameID(name.data());
                    while (*tail) {
                        if ((*tail)->frame == target_id) {
                            *tail = (*tail)->next;
                        } else {
                            tail = &(*tail)->next;
                        }
                    }
                    for (auto *channel = replacement_motion.skin_list; channel; channel = channel->next) {
                        auto *target = replacement->GetFrame(channel->target);
                        channel->target = target && target->name ? root->SearchFrameID(target->name) : -1;
                        channel->frame = target_id;
                    }
                    *tail = replacement_motion.skin_list;
                    AnimeDataInit(root, &character.motion[0], &memory, character.motion[0].frame_info);
                }
                continue;
            }
            auto *root = shadow ? character.shadow_frame : character.CObjectFrame::frame;
            if (!root) {
                continue;
            }
            auto                      &motion = shadow ? character.shadow_motion[motion_slot] : character.motion[motion_slot];
            std::optional<MotionOwner> owner;
            if (const auto found = character_models.find(&character); found != character_models.end()) {
                owner = found->second;
            }
            if (!shadow && motion.motion_list) {
                character_motion::Forget(motion.motion_list);
            }
            auto actions = BuildMotion(document, motion, motion_memory, shadow ? std::nullopt : animation, bind, weights, shadow ? shadow_model : selected_model, owner);
            if (!shadow) {
                RegisterActions(motion, actions, NextActionFrame(character, motion_slot));
                slot_actions = std::vector<character_motion::Action>(character_motion::Actions(motion).begin(), character_motion::Actions(motion).end());
            }
            if (!shadow && motion.base_matrices && root->init_matrix) {
                std::memcpy(root->init_matrix, motion.base_matrices, root->frame_num * sizeof(sceVu0FMATRIX));
            }
            if (shadow) {
                if (!character.shadow_frame_info) {
                    AnimeDataInit(root, &motion, &memory, &character.shadow_frame_info);
                }
                motion.frame_info = character.shadow_frame_info;
            } else if (motion_slot > 0) {
                character.shadow_motion[motion_slot] = character.shadow_motion[0];
                character.shadow_motion[motion_slot].frame_info = nullptr;
            }
        } else if (tag_name == "CLOTH") {
            for (std::size_t index = 0; index < args.size(); ++index) {
                const auto resource = Reference(args, index, "cloth");
                if (!resource) {
                    continue;
                }
                const int slot = PortCharacterMetadataNextCloth();
                if (slot < 0) {
                    throw std::runtime_error("character cloth record capacity exceeded");
                }
                auto data = ScriptBytes(resources.at("cloths").at(*resource));
                character.dynamic_anime[slot].Load(data.data(), static_cast<int>(data.size()), character.CObjectFrame::frame, &memory);
            }
            for (int index = 0; index < character.shadow_link.num; ++index) {
                auto *source = character.CObjectFrame::frame->GetFrame(character.shadow_link.src_frame[index]);
                auto *target = character.shadow_frame->GetFrame(character.shadow_link.dst_frame[index]);
                if (source && target && !source->parent && target->parent) {
                    target->DeleteParent();
                }
            }
        } else if (tag_name == "LOD_MODEL") {
            const int index = spiGetStackInt(stack.data());
            if (index < 0 || index >= character.lod_num) {
                throw std::runtime_error("character LOD index out of range");
            }
            const auto model = Reference(args, 1, "model");
            const auto weights = Reference(args, 2, "weights");
            const auto bind = Reference(args, 3, "bind_pose");
            if (!model) {
                continue;
            }
            auto &level = character.lod[index];
            level.distance = spiGetStackFloat(&stack.at(4));
            level.motion = weights && bind;
            level.standalone = !level.motion;
            level.frame = Scene(document, *model, options, level.motion ? PortCharacterMetadataVisualTypes(true) : nullptr, &character);
            if (level.motion) {
                tagMOTION_TYPE data{};
                BuildMotion(document, data, memory, std::nullopt, bind, weights, model);
                auto *root = character.CObjectFrame::frame;
                Rebind(*level.frame, *root, data.base_matrices);
                level.link = Allocate<int[2]>(memory, level.frame->frame_num);
                level.link_num = 0;
                for (int frame = 0; frame < level.frame->frame_num; ++frame) {
                    const int target = root->SearchFrameID(level.frame->GetFrame(frame)->name);
                    if (target >= 0) {
                        level.link[level.link_num][0] = target;
                        level.link[level.link_num++][1] = frame;
                    }
                }
            }
        } else if (tag_name == "EFFECT") {
            const auto resource = Reference(args, 0, "script");
            if (!resource) {
                continue;
            }
            const auto &script = resources.at("scripts").at(*resource);
            if (character.effect_image_load) {
                for (const auto &set : script.value("texture_sets", Json::array())) {
                    EnterTextureSet(document, set.get<std::size_t>(), options, &character, 0);
                }
                if (script.contains("character") || script.contains("external_texture_bundle")) {
                    const auto  child = Read(Relative(script.at(script.contains("character") ? "character" : "external_texture_bundle").get<std::string>()));
                    const auto &sets = child->custom->at("resources").at("texture_sets");
                    for (std::size_t index = 0; index < sets.size(); ++index) {
                        EnterTextureSet(child, index, options, &character, 0);
                    }
                }
            }
            CharacterEffect(character, script, stack, memory);
        } else if (tag_name == "EFFECT_START" || tag_name == "EFFECT_END") {
            // Effects carry direct script references rather than a selected archive.
        } else if (tag_name == "IMG") {
            const int  slot = skin ? 0 : spiGetStackInt(stack.data());
            const auto set = Reference(args, skin ? 0 : 1, "texture_set");
            if (set) {
                EnterTextureSet(document, *set, options, &character, slot);
            }
        } else if (tag_name == "IMG_END") {
            if (!skin) {
                character.texture_block = options.texture_block;
            }
        } else if (tag_name == "KEY" && !skin) {
            // A KEY names an action; the game sees its original name and game-frame interval.
            const auto name = args.at(0).at("value").get<std::string>();
            const auto action = std::ranges::find(slot_actions, name, &character_motion::Action::name);
            if (action == slot_actions.end()) {
                throw std::runtime_error("KEY names no action of its motion: " + name);
            }
            const Json key = Json::array({
                OriginalMotionName(custom, args.at(0)),
                {{"type", "int"}, {"value", action->base}                                                },
                {{"type", "int"}, {"value", action->base + static_cast<int>(std::ceil(action->duration))}},
                args.at(1)
            });
            auto       retail = Arguments(key, strings);
            PortCharacterMetadataApply(tag_name.c_str(), retail.data(), static_cast<int>(retail.size()), skin);
        } else if ((tag_name == "SE" || tag_name == "SELP" || tag_name == "SEQ" || tag_name == "SEQ_START") && !skin && !args.empty()) {
            auto named = args;
            named.at(0) = OriginalMotionName(custom, args.at(0));
            auto retail = Arguments(named, strings);
            PortCharacterMetadataApply(tag_name.c_str(), retail.data(), static_cast<int>(retail.size()), skin);
        } else {
            PortCharacterMetadataApply(tag_name.c_str(), stack.data(), static_cast<int>(stack.size()), skin);
        }
    }
    if (!skin) {
        character.load_size = memory.stack_used - initial_used;
        if (!had_motion) {
            if (auto *first = character.GetKeyListIndexPtr(0, nullptr)) {
                character.SetMotion(first->name, CHARA_MOTION_RESTART);
            }
            if (character.next_key) {
                character.posed_key = character.next_key;
                character.frame = static_cast<float>(character.next_key->start_frame);
                character.step = character.next_key->step;
            }
        }
    }
}
} // namespace

void DeleteCharacterTextures(CCharacter2 &character, int first_slot, int last_slot) {
    auto found = character_images.find(&character);
    if (found == character_images.end()) {
        return;
    }
    auto &images = found->second;
    for (auto entry = images.begin(); entry != images.end();) {
        if (entry->slot < first_slot || entry->slot > last_slot) {
            ++entry;
            continue;
        }
        for (const auto &texture : entry->source->entries) {
            if (texture.type == "texture" && !texture.name.starts_with('#')) {
                auto              name = PictureName(texture, entry->suffix);
                const std::string previous = entry->manager->name_suffix;
                entry->manager->name_suffix[0] = 0;
                // The record can outlive a DeleteBlock and Initialize, after which another model can enter a
                // picture under the same name; only pictures this set entered last are deleted.
                auto *registered = entry->manager->GetTexture(name.data(), entry->block + texture.block);
                if (registered != nullptr && MgTextureEnteredFrom(registered, *entry->source)) {
                    entry->manager->DeleteTexture(registered);
                }
                std::strcpy(entry->manager->name_suffix, previous.c_str());
            }
        }
        entry = images.erase(entry);
    }
    if (images.empty()) {
        character_images.erase(found);
    }
}

namespace {
/**
 * Validates a texture document and retains its native picture and animation definitions.
 */
std::shared_ptr<texture_catalog::Source> ReadReplacementTextures(const std::filesystem::path                          &path,
                                                                 std::vector<std::vector<datapacks::DecodedTexture> > *pixels = nullptr) {
    const auto *source = texture_catalog::Find(path.generic_string());
    if (!source) {
        throw std::runtime_error("invalid native texture document: " + path.generic_string());
    }
    auto retained = std::make_shared<texture_catalog::Source>(*source);
    if (pixels) {
        pixels->resize(retained->entries.size());
    }
    std::size_t entry_index = 0;
    for (const auto &entry : retained->entries) {
        auto *variants = pixels ? &pixels->at(entry_index++) : nullptr;
        if (entry.type != "texture" || entry.no_image) {
            continue;
        }
        for (std::size_t variant = 0; variant < entry.variants.size(); ++variant) {
            datapacks::DecodedTexture decoded;
            std::string               error;
            if (!datapacks::Decode(entry, variant, decoded, error)) {
                throw std::runtime_error(error);
            }
            if (variants) {
                variants->push_back(std::move(decoded));
            }
        }
    }
    return retained;
}

/**
 * Replaces an owned native texture set while keeping every material bound by its texture identity.
 */
void ReplaceTextures(CCharacter2 &character, const std::shared_ptr<texture_catalog::Source> &source, int slot,
                     int block, mgCMemory *memory,
                     const std::shared_ptr<std::vector<std::vector<datapacks::DecodedTexture> > > &pixels = {}) {
    if (slot < 0 || slot >= CHARA_IMAGE_MAX) {
        throw std::runtime_error("invalid character image slot");
    }

    /**
     * Retains a material's texture identity while native texture headers are replaced.
     */
    struct Binding {
        mgMaterial *material; /**< Material to bind after registration. */
        std::string name;     /**< Fully suffixed game-visible texture name. */
        int         block;    /**< Absolute destination texture block. */
    };

    std::vector<Binding>    bindings;
    std::vector<mgCFrame *> pending{character.GetFrame(), character.shadow_frame};
    for (int index = 0; index < character.lod_num; ++index) {
        pending.push_back(character.lod[index].frame);
    }
    std::unordered_set<mgCFrame *> visited;
    while (!pending.empty()) {
        auto *frame = pending.back();
        pending.pop_back();
        if (!frame || !visited.insert(frame).second) {
            continue;
        }
        pending.push_back(frame->child);
        pending.push_back(frame->brother);
        if (frame->visual) {
            for (int index = 0; index < frame->visual->GetMaterialNum(); ++index) {
                auto *material = frame->visual->GetMaterial(index);
                if (material && material->texture) {
                    bindings.push_back({.material = material, .name = material->texture->name, .block = material->texture->block});
                }
            }
        }
    }
    auto                          *manager = &mgTexManager;
    std::string                    suffix = manager->name_suffix;
    std::optional<CharacterImages> previous;
    if (const auto found = character_images.find(&character); found != character_images.end()) {
        for (const auto &image : found->second) {
            if (image.slot == slot) {
                previous = image;
                break;
            }
        }
    }
    // Copied characters share their base character's native textures and animation arena.
    if (!previous) {
        for (const auto &[owner, images] : character_images) {
            for (const auto &image : images) {
                if (image.slot == slot && image.block == block) {
                    previous = image;
                    break;
                }
            }
            if (previous) {
                break;
            }
        }
    }
    if (previous) {
        manager = previous->manager;
        suffix = previous->suffix;
        if (!memory) {
            memory = previous->memory;
        }
    }
    const std::string saved_suffix = manager->name_suffix;

    /**
     * Restores the caller's texture identity suffix after replacement.
     */
    struct RestoreSuffix {
        mgCTextureManager &manager; /**< Manager whose registration context is restored. */
        const std::string &suffix;  /**< Original caller context. */

        ~RestoreSuffix() { std::strcpy(manager.name_suffix, suffix.c_str()); }
    } restore{.manager = *manager, .suffix = saved_suffix};

    manager->name_suffix[0] = 0;
    // Delete only pictures belonging to this image slot, preserving extension image sets.
    if (previous) {
        for (const auto &entry : previous->source->entries) {
            if (entry.type == "texture" && !entry.name.starts_with('#')) {
                auto name = PictureName(entry, suffix);
                manager->DeleteTexture(name.data(), previous->block + entry.block);
            }
        }
    } else {
        for (const auto &binding : bindings) {
            if (binding.block == block) {
                auto name = binding.name;
                manager->DeleteTexture(name.data(), block);
            }
        }
    }
    auto &owned = character_images[&character];
    std::erase_if(owned, [slot](const auto &image) { return image.slot == slot; });
    std::strcpy(manager->name_suffix, suffix.c_str());
    if (!pixels) {
        std::vector<const texture_catalog::Entry *> entries;
        for (const auto &entry : source->entries) {
            entries.push_back(&entry);
        }
        datapacks::PrefetchEntries(entries);
    }
    MgTextureEnterNativeSet(manager, block, *source, memory,
                            [source, pixels](const texture_catalog::Entry &entry, std::size_t variant,
                                             datapacks::DecodedTexture &decoded, std::string &error) {
                                if (pixels && !entry.no_image) {
                                    const auto index = static_cast<std::size_t>(&entry - source->entries.data());
                                    decoded = pixels->at(index).at(variant);
                                    return true;
                                }
                                return datapacks::Decode(entry, variant, decoded, error);
                            });
    owned.push_back({.slot = slot, .block = block, .manager = manager, .source = source, .memory = memory, .suffix = suffix});
    manager->name_suffix[0] = 0;
    for (auto &binding : bindings) {
        binding.material->texture = manager->GetTexture(binding.name.data(), binding.block);
    }
    if (slot == 0) {
        character.texture_block = block;
    }
    RefreshTexAnimeGroups(character, *manager, slot);
}
} // namespace

bool ReplaceCharacterTextureDocument(CCharacter2 &character, const std::filesystem::path &document, std::string &error) {
    return ReplaceCharacterTextureDocument(character, document, 0, character.texture_block, nullptr, error);
}

bool ReplaceCharacterTextureDocument(CCharacter2 &character, const std::filesystem::path &document, int slot, int block,
                                     mgCMemory *memory, std::string &error) {
    return Attempt(error, [&] {
        ReplaceTextures(character, ReadReplacementTextures(document), slot, block, memory);
    });
}

bool ReserveMonsterTextureDocument(CActiveMonster &monster, int slot, const std::filesystem::path &document, std::string &error) {
    return Attempt(error, [&] {
        if (slot < 0 || slot >= 2) {
            throw std::runtime_error("invalid reserved monster image slot");
        }
        auto pixels = std::make_shared<std::vector<std::vector<datapacks::DecodedTexture> > >();
        auto source = ReadReplacementTextures(document, pixels.get());
        reserved_images[&monster][slot] = {.source = source, .pixels = pixels};
        monster.reserv_img[slot] = source.get();
        monster.reserv_img_size[slot] = 0;
    });
}

bool ApplyReservedMonsterTexture(CActiveMonster &monster, int slot, std::string &error) {
    return Attempt(error, [&] {
        const auto found = reserved_images.find(&monster);
        if (slot < 0 || slot >= 2 || found == reserved_images.end() || !found->second[slot].source ||
            monster.reserv_img[slot] != found->second[slot].source.get()) {
            throw std::runtime_error("reserved monster image slot is empty");
        }
        ReplaceTextures(monster, found->second[slot].source, 0, monster.texture_block, nullptr, found->second[slot].pixels);
    });
}

bool LoadTextureSet(const std::filesystem::path &gltf, std::size_t index, mgCTextureManager &textures, int block, mgCMemory &memory, std::string &error) {
    return LoadTextureSet(gltf, index, textures, block, &memory, error);
}

bool LoadTextureSet(const std::filesystem::path &gltf, std::size_t index, mgCTextureManager &textures, int block, mgCMemory *memory, std::string &error) {
    return Attempt(error, [&] {
        EnterTextureSet(Read(gltf), index, {.model_memory = memory, .motion_memory = memory, .image_memory = memory, .textures = &textures, .parent = nullptr, .texture_block = block, .outline = false}, nullptr, 0);
    });
}

bool LoadCharacter(CCharacter2 &character, const std::filesystem::path &gltf, std::string_view profile, const CharacterLoadOptions &options, std::string &error) {
    return Attempt(error, [&] {
        CharacterProfile(character, Read(gltf), profile, {}, options, false);
    });
}

bool LoadCharacter(CCharacter2 &character, std::span<const std::byte> gltf, const Json &game, std::string_view profile, const CharacterLoadOptions &options, std::string &error) {
    return Attempt(error, [&] {
        CharacterProfile(character, ReadBytes(gltf, game), profile, {}, options, false);
    });
}

bool LoadSkin(CCharacter2 &character, const std::filesystem::path &gltf, std::string_view profile, std::string_view name, const CharacterLoadOptions &options, std::string &error) {
    return Attempt(error, [&] {
        CharacterProfile(character, Read(gltf), profile, name, options, true);
    });
}

bool LoadSkin(CCharacter2 &character, std::span<const std::byte> gltf, const Json &game, std::string_view profile, std::string_view name, const CharacterLoadOptions &options, std::string &error) {
    return Attempt(error, [&] {
        CharacterProfile(character, ReadBytes(gltf, game), profile, name, options, true);
    });
}

bool ApplySkin(mgCVisualMotionMDT &visual, float (*matrix)[4]) {
    const auto found = inverse_binds.find(visual.weight);
    // The binds hold only in the hierarchy the skin was loaded with. A visual attached to another character's frames,
    // such as a costume piece, skins from that character's base matrices instead.
    if (found == inverse_binds.end() || found->second.frames != visual.frame || found->second.frame_id != visual.frame_id) {
        return false;
    }
    float inverse_mesh[4][4];
    mgInversMatrix(inverse_mesh, matrix);
    auto       &palette = mgVisualPortCurrentPalette();
    const auto &matrices = found->second.matrices;
    for (std::size_t slot = 0; slot < matrices.size(); ++slot) {
        float joint[4][4];
        float bind[4][4];
        float skin[4][4];
        visual.frame[visual.bone[slot]]->GetLWMatrix(joint);
        std::memcpy(bind, matrices[slot].data(), sizeof(bind));
        mgMulMatrix(skin, joint, bind);
        mgMulMatrix(skin, inverse_mesh, skin);
        for (int row = 0; row < 3; ++row) {
            for (int column = 0; column < 4; ++column) {
                palette.bones[slot][row][column] = skin[column][row];
            }
        }
    }
    return true;
}

namespace {
/**
 * Interpolates two rotations on the shortest arc of the unit quaternion sphere.
 */
std::array<float, 4> Slerp(std::array<float, 4> first, std::array<float, 4> second, float t) {
    float cosine = 0;
    for (int index = 0; index < 4; ++index) {
        cosine += first[index] * second[index];
    }
    if (cosine < 0) {
        cosine = -cosine;
        for (auto &component : second) {
            component = -component;
        }
    }
    float a = 1 - t;
    float b = t;
    if (cosine < .9995f) {
        const auto angle = std::acos(std::clamp(cosine, -1.0f, 1.0f));
        const auto sine = std::sin(angle);
        a = std::sin((1 - t) * angle) / sine;
        b = std::sin(t * angle) / sine;
    }
    float length = 0;
    for (int index = 0; index < 4; ++index) {
        first[index] = a * first[index] + b * second[index];
        length += first[index] * first[index];
    }
    if (length > 0) {
        for (auto &component : first) {
            component /= std::sqrt(length);
        }
    }
    return first;
}

/**
 * Preserves the game's near-opposite snap and nearly-identical linear rotation interpolation.
 */
std::array<float, 4> RetailSlerp(std::array<float, 4> first, std::array<float, 4> second, float t) {
    float cosine = 0;
    for (int component = 0; component < 4; ++component) {
        cosine += first[component] * second[component];
    }
    if (cosine < 0) {
        cosine = -cosine;
        for (auto &component : second) {
            component = -component;
        }
    }
    if (cosine < .01f) {
        return second;
    }
    float from = 1 - t;
    float to = t;
    if (1 - cosine > .01f) {
        const auto angle = std::acos(std::clamp(cosine, -1.0f, 1.0f));
        const auto inverse = 1 / std::sin(angle);
        from = inverse * std::sin((1 - t) * angle);
        to = inverse * std::sin(t * angle);
    }
    for (int component = 0; component < 4; ++component) {
        first[component] = from * first[component] + to * second[component];
    }
    return first;
}

/**
 * Samples a standard animation accessor at an arbitrary game-frame time.
 */
std::array<float, 4> Sample(const NativeChannel &native, int type, float time) {
    const auto &asset = native.document->asset;
    const auto &output = asset.accessors.at(native.sampler.outputAccessor);
    const bool  cubic = native.sampler.interpolation == fastgltf::AnimationInterpolation::CubicSpline;
    auto        value = [&](std::size_t key, int part = 1) {
        std::array<float, 4> result{};
        const auto           index = cubic ? key * 3 + part : key;
        if (type == MOTION_KEY_ROTATION) {
            const auto vector = fastgltf::getAccessorElement<fastgltf::math::fvec4>(asset, output, index);
            for (int component = 0; component < 4; ++component) {
                result[component] = vector[component];
            }
        } else {
            const auto vector = fastgltf::getAccessorElement<fastgltf::math::fvec3>(asset, output, index);
            for (int component = 0; component < 3; ++component) {
                result[component] = vector[component];
            }
            result[3] = type == MOTION_KEY_TRANSLATION ? 1 : 0;
        }
        return result;
    };
    const auto upper = std::ranges::upper_bound(native.times, time);
    if (upper == native.times.begin()) {
        return value(0);
    }
    const auto first = static_cast<std::size_t>(upper - native.times.begin() - 1);
    if (first + 1 == native.times.size() || native.sampler.interpolation == fastgltf::AnimationInterpolation::Step) {
        return value(first);
    }
    const auto duration = native.times[first + 1] - native.times[first];
    const auto t = (time - native.times[first]) / duration;
    auto       a = value(first);
    auto       b = value(first + 1);
    if (type == MOTION_KEY_ROTATION && !cubic) {
        if (native.retail_rotation) {
            if (t <= .001f) {
                return a;
            }
            if (t >= .999f) {
                return b;
            }
            return RetailSlerp(a, b, t);
        }
        return Slerp(a, b, t);
    }
    const auto outgoing = cubic ? value(first, 2) : a;
    const auto incoming = cubic ? value(first + 1, 0) : b;
    float      length = 0;
    for (int component = 0; component < (type == MOTION_KEY_ROTATION ? 4 : 3); ++component) {
        a[component] = cubic ? (2 * t * t * t - 3 * t * t + 1) * a[component] + (t * t * t - 2 * t * t + t) * (duration / 30) * outgoing[component] + (-2 * t * t * t + 3 * t * t) * b[component] + (t * t * t - t * t) * (duration / 30) * incoming[component] : a[component] * (1 - t) + b[component] * t;
        length += a[component] * a[component];
    }
    if (type == MOTION_KEY_ROTATION && length > 0) {
        for (auto &component : a) {
            component /= std::sqrt(length);
        }
    }
    return a;
}
} // namespace

namespace {
/**
 * Samples every morph weight of a channel at a game-frame time.
 */
std::vector<float> SampleWeights(const NativeChannel &native, float time) {
    const auto        &output = native.document->asset.accessors.at(native.sampler.outputAccessor);
    const bool         cubic = native.sampler.interpolation == fastgltf::AnimationInterpolation::CubicSpline;
    std::vector<float> weights(native.morph_targets);
    for (std::size_t target = 0; target < native.morph_targets; ++target) {
        auto       value = [&](std::size_t key, int part = 1) { return fastgltf::getAccessorElement<float>(native.document->asset, output, ((cubic ? key * 3 + part : key) * native.morph_targets) + target); };
        const auto upper = std::ranges::upper_bound(native.times, time);
        if (upper == native.times.begin()) {
            weights[target] = value(0);
            continue;
        }
        const auto first = static_cast<std::size_t>(upper - native.times.begin() - 1);
        if (first + 1 == native.times.size() || native.sampler.interpolation == fastgltf::AnimationInterpolation::Step) {
            weights[target] = value(first);
            continue;
        }
        const auto duration = native.times[first + 1] - native.times[first];
        const auto t = (time - native.times[first]) / duration;
        weights[target] = !cubic ? value(first) * (1 - t) + value(first + 1) * t
                                 : (2 * t * t * t - 3 * t * t + 1) * value(first) + (t * t * t - 2 * t * t + t) * (duration / 30) * value(first, 2) + (-2 * t * t * t + 3 * t * t) * value(first + 1) + (t * t * t - t * t) * (duration / 30) * value(first + 1, 0);
    }
    return weights;
}

/**
 * Deforms a frame's native mesh by morph target weights.
 */
void ApplyWeights(mgCFrame &frame, std::span<const float> weights) {
    auto *visual = static_cast<mgCVisualMDT *>(frame.visual);
    if (!visual) {
        return;
    }
    const auto morph = native_morphs.find(visual->vertex);
    if (morph == native_morphs.end()) {
        return;
    }
    std::memcpy(visual->vertex, morph->second.positions.data(), visual->vertex_num * sizeof(sceVu0FVECTOR));
    std::memcpy(visual->normal, morph->second.normals.data(), visual->normal_num * sizeof(sceVu0FVECTOR));
    for (std::size_t target = 0; target < weights.size(); ++target) {
        const auto weight = weights[target];
        for (int vertex = 0; vertex < visual->vertex_num; ++vertex) {
            for (int axis = 0; axis < 3; ++axis) {
                visual->vertex[vertex][axis] += weight * morph->second.position_deltas.at(target)[vertex][axis];
            }
        }
        for (int normal = 0; normal < visual->normal_num; ++normal) {
            for (int axis = 0; axis < 3; ++axis) {
                visual->normal[normal][axis] += weight * morph->second.normal_deltas.at(target)[normal][axis];
            }
        }
    }
    RefreshFaces(*visual);
}

/**
 * Blends two transform samples with the channel's rotation interpolation.
 */
std::array<float, 4> BlendValues(const NativeChannel &native, int type, std::array<float, 4> from, const std::array<float, 4> &to, float blend) {
    if (blend == 0) {
        return from;
    }
    if (type == MOTION_KEY_ROTATION) {
        if (native.retail_rotation) {
            return blend <= .0001f ? from : blend >= .9999f ? to
                                                            : RetailSlerp(from, to, blend);
        }
        return Slerp(from, to, blend);
    }
    for (int component = 0; component < 3; ++component) {
        from[component] = from[component] * (1 - blend) + to[component] * blend;
    }
    return from;
}

/**
 * Writes a sampled glTF translation, rotation or scale into a native frame.
 *
 * Rotations are standard glTF (x, y, z, w) quaternions written as the frame's rotation rows.
 */
void ApplyValue(mgCFrame &frame, const NativeChannel &native, int type, const std::array<float, 4> &value) {
    if (type == MOTION_KEY_ROTATION) {
        const auto [x, y, z, w] = value;
        const float rotation[3][3] = {
            {1 - 2 * (y * y + z * z), 2 * (x * y + w * z),     2 * (x * z - w * y)    },
            {2 * (x * y - w * z),     1 - 2 * (x * x + z * z), 2 * (y * z + w * x)    },
            {2 * (x * z + w * y),     2 * (y * z - w * x),     1 - 2 * (x * x + y * y)}
        };
        for (int row = 0; row < 3; ++row) {
            for (int column = 0; column < 3; ++column) {
                frame.trans_matrix[row][column] = rotation[row][column];
            }
            frame.trans_matrix[row][3] = 0;
        }
        frame.changed = 1;
        if (auto state = FrameConventions().find(&frame); state != FrameConventions().end() && state->second.helper) {
            std::memcpy(state->second.child_base.data(), frame.trans_matrix, sizeof(frame.trans_matrix));
            ApplyHelperScale(frame, state->second);
        }
    } else if (type == MOTION_KEY_TRANSLATION) {
        for (int axis = 0; axis < 3; ++axis) {
            frame.trans_matrix[3][axis] = value[axis];
        }
        frame.changed = 1;
    } else if (native.helper_scale) {
        if (auto state = FrameConventions().find(&frame); state != FrameConventions().end() && state->second.helper) {
            for (int axis = 0; axis < 3; ++axis) {
                state->second.child_scale[axis] = value[axis];
            }
            ApplyHelperScale(frame, state->second);
        }
    } else if (auto state = FrameConventions().find(&frame); state != FrameConventions().end() && state->second.matrix_scale) {
        // A scale key here only restates the reset the frame's rotation keys already made to its authored scale;
        // writing it would discard a scale gameplay set.
    } else {
        float scale[3] = {value[0], value[1], value[2]};
        frame.SetScale(scale);
    }
}
} // namespace

bool IsNativeChannel(const Mot_List &channel) {
    return native_channels.contains(&channel);
}

bool ApplyChannel(mgCFrame &root, float from, float to, float blend, Mot_List &channel) {
    const auto found = native_channels.find(&channel);
    if (found == native_channels.end()) {
        return false;
    }
    auto *frame = root.GetFrame(channel.frame);
    if (!frame) {
        return true;
    }
    const auto &native = found->second;
    if (native.morph_targets) {
        auto weights = SampleWeights(native, from);
        if (blend != 0) {
            const auto next = SampleWeights(native, to);
            for (std::size_t target = 0; target < weights.size(); ++target) {
                weights[target] = weights[target] * (1 - blend) + next[target] * blend;
            }
        }
        ApplyWeights(*frame, weights);
        return true;
    }
    const auto value = Sample(native, channel.type, from);
    ApplyValue(*frame, native, channel.type, blend != 0 ? BlendValues(native, channel.type, value, Sample(native, channel.type, to), blend) : value);
    return true;
}

void BlendActions(mgCFrame &root, const Mot_List *from, float from_time, const Mot_List *to, float to_time, float blend) {
    std::map<std::pair<int, int>, const Mot_List *> sources;
    for (const auto *channel = from; channel; channel = channel->next) {
        if (channel->key_count && native_channels.contains(channel)) {
            sources.insert_or_assign({channel->frame, channel->type}, channel);
        }
    }
    for (const auto *channel = to; channel; channel = channel->next) {
        const auto target = native_channels.find(channel);
        if (!channel->key_count || target == native_channels.end()) {
            continue;
        }
        auto *frame = root.GetFrame(channel->frame);
        if (!frame) {
            continue;
        }
        const auto &native = target->second;
        const auto  source = sources.find({channel->frame, channel->type});
        // A frame the previous action leaves unanimated takes the new action's pose at once.
        const auto *previous = source == sources.end() ? nullptr : &native_channels.at(source->second);
        if (native.morph_targets) {
            auto weights = SampleWeights(native, to_time);
            if (previous && previous->morph_targets == native.morph_targets) {
                const auto old = SampleWeights(*previous, from_time);
                for (std::size_t index = 0; index < weights.size(); ++index) {
                    weights[index] = old[index] * (1 - blend) + weights[index] * blend;
                }
            }
            ApplyWeights(*frame, weights);
            continue;
        }
        const auto value = Sample(native, channel->type, to_time);
        ApplyValue(*frame, native, channel->type, previous ? BlendValues(native, channel->type, Sample(*previous, channel->type, from_time), value, blend) : value);
    }
}

void CopyFrameConvention(const mgCFrame &destination, const mgCFrame &source) {
    if (const auto found = FrameConventions().find(&source); found != FrameConventions().end()) {
        FrameConventions().insert_or_assign(&destination, found->second);
    } else {
        FrameConventions().erase(&destination);
    }
}

} // namespace model_assets
