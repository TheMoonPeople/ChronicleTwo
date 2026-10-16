#pragma once

#include <nlohmann/json_fwd.hpp>

#include <cstddef>
#include <filesystem>
#include <memory>
#include <optional>
#include <span>
#include <string>
#include <string_view>
#include <vector>

class mgCFrame;
struct mgLoadData;
struct tagMOTION_TYPE;
class mgCMemory;
class mgCVisualMotionMDT;
struct Mot_List;
class CCharacter2;
class mgCTextureManager;
class CActiveMonster;

namespace model_assets {
/**
 * Supplies native allocation and gameplay options for one character profile.
 */
struct CharacterLoadOptions {
    mgCMemory         *model_memory = nullptr;  /**< Arena for frames, visuals and base gameplay records. */
    mgCMemory         *motion_memory = nullptr; /**< Arena for extension animation and gameplay records. */
    mgCMemory         *image_memory = nullptr;  /**< Arena for native texture data. */
    mgCTextureManager *textures = nullptr;      /**< Destination texture manager, or the game manager. */
    CCharacter2       *parent = nullptr;        /**< Parent character sharing outline resources. */
    int                texture_block = 0;       /**< Texture block used by the character. */
    bool               outline = true;          /**< Whether the profile's outline effects are enabled. */
};

/**
 * Constructs native frames and visuals from an actual glTF path and its gameplay JSON.
 */
mgCFrame *LoadModel(const std::filesystem::path &gltf, mgLoadData &load, std::string &error,
                    std::optional<std::size_t> model = std::nullopt);
/**
 * Constructs one explicitly named standard scene from a native glTF model bundle.
 */
mgCFrame *LoadModelScene(const std::filesystem::path &gltf, std::string_view scene, mgLoadData &load, std::string &error);
/**
 * Constructs native frames and visuals from explicit glTF bytes and gameplay JSON.
 */
mgCFrame *LoadModel(std::span<const std::byte> gltf, const nlohmann::json &game, mgLoadData &load, std::string &error,
                    std::optional<std::size_t> model = std::nullopt);
/**
 * Loads an ordered native character profile from an actual glTF path.
 */
bool LoadCharacter(CCharacter2 &character, const std::filesystem::path &gltf, std::string_view profile,
                   const CharacterLoadOptions &options, std::string &error);
/**
 * Loads an ordered native character profile from explicit glTF bytes and gameplay JSON.
 */
bool LoadCharacter(CCharacter2 &character, std::span<const std::byte> gltf, const nlohmann::json &game, std::string_view profile,
                   const CharacterLoadOptions &options, std::string &error);
/**
 * Replaces character skin visuals using an actual glTF path and native profile.
 */
bool LoadSkin(CCharacter2 &character, const std::filesystem::path &gltf, std::string_view profile,
              std::string_view skin_name, const CharacterLoadOptions &options, std::string &error);
/**
 * Replaces character skin visuals using explicit glTF bytes and gameplay JSON.
 */
bool LoadSkin(CCharacter2 &character, std::span<const std::byte> gltf, const nlohmann::json &game, std::string_view profile,
              std::string_view skin_name, const CharacterLoadOptions &options, std::string &error);
/**
 * Releases cached glTF documents and native animation registrations.
 */
void Clear();
/**
 * Reports whether a standard replacement frame applies scale after its authored rotation.
 */
bool UsesStandardScaleOrder(const mgCFrame *frame);
/**
 * Removes native-model state when a frame is initialized or its arena address is reused.
 */
void ForgetFrame(const mgCFrame *frame);
/**
 * Deletes the native texture sets owned by one character image slot.
 */
void DeleteCharacterTextures(CCharacter2 &character, int first_slot, int last_slot);
/**
 * Replaces the first native character image set and rebinds its visual materials.
 */
bool ReplaceCharacterTextureDocument(CCharacter2 &character, const std::filesystem::path &document, std::string &error);
/**
 * Replaces a selected native image slot using an actual texture document.
 */
bool ReplaceCharacterTextureDocument(CCharacter2 &character, const std::filesystem::path &document, int slot, int block,
                                     mgCMemory *memory, std::string &error);
/**
 * Retains a parsed native texture document in a monster's reserved image slot.
 */
bool ReserveMonsterTextureDocument(CActiveMonster &monster, int slot, const std::filesystem::path &document, std::string &error);
/**
 * Applies a retained native texture set to the monster's first image slot.
 */
bool ApplyReservedMonsterTexture(CActiveMonster &monster, int slot, std::string &error);
/**
 * Loads a directly selected animation and its native bind/deformation resources from one glTF asset.
 */
bool LoadAnimation(const std::filesystem::path &gltf, tagMOTION_TYPE &motion, mgCMemory &memory,
                   std::optional<std::size_t> animation, std::optional<std::size_t> bind_pose,
                   std::optional<std::size_t> weights, std::optional<std::size_t> model, std::string &error);
/**
 * Loads selected animation resources from actual native glTF bytes.
 */
bool LoadAnimation(std::span<const std::byte> gltf, const nlohmann::json &game, tagMOTION_TYPE &motion, mgCMemory &memory,
                   std::optional<std::size_t> animation, std::optional<std::size_t> bind_pose,
                   std::optional<std::size_t> weights, std::optional<std::size_t> model, std::string &error);
/**
 * Reads the adjacent minimal gameplay JSON for a directly named glTF asset.
 */
std::shared_ptr<const nlohmann::json> ReadGameplay(const std::filesystem::path &gltf, std::string &error);
/**
 * Lists the semantic character profile names stored beside a glTF asset.
 */
std::vector<std::string> Profiles(const std::filesystem::path &gltf, std::string &error);
/**
 * Estimates native arena bytes for the selected character profile from geometry and gameplay counts.
 */
std::optional<std::size_t> EstimateCharacterMemory(const std::filesystem::path &gltf, std::string_view profile, std::string &error);
/**
 * Enters one explicitly indexed complete texture set from a native glTF asset.
 */
bool LoadTextureSet(const std::filesystem::path &gltf, std::size_t index, mgCTextureManager &textures, int block, mgCMemory &memory, std::string &error);
/**
 * Enters a complete embedded texture set with an optional native allocation arena.
 */
bool LoadTextureSet(const std::filesystem::path &gltf, std::size_t index, mgCTextureManager &textures, int block, mgCMemory *memory, std::string &error);
/**
 * Writes standard glTF skin matrices into the current native draw constants.
 */
bool ApplySkin(mgCVisualMotionMDT &visual, float (*matrix)[4]);
/**
 * Applies a glTF channel at its exact time, including STEP and CUBICSPLINE interpolation.
 */
bool ApplyChannel(mgCFrame &root, float from, float to, float blend, Mot_List &channel);
} // namespace model_assets
