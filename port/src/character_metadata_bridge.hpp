#pragma once

#include <memory>
#include <optional>
#include <string_view>

#include "character.hpp"
#include "mg_dataset.hpp"
#include "scriptinterpreter.hpp"

namespace dc2::character {
/**
 *
 * Owns one metadata parse context and restores its enclosing parse on every exit.
 *
 */
class MetadataScope {
public:
    /**
     *
     * Starts a parse with isolated builders and an owned skin selector.
     *
     */
    MetadataScope(CCharacter2 *character, mgCMemory *model, int block, CCharacter2 *parent, bool outline,
                  std::string_view skin_name = {}, std::shared_ptr<const CloneAuxState> inherited_clone_inputs = {});
    /**
     *
     * Restores the enclosing parser before releasing this scope's owned state.
     *
     */
    ~MetadataScope();
    /**
     *
     * Borrows the active parser's owned skin name, or no name outside a skin context.
     *
     */
    static std::optional<std::string_view> ActiveSkinName();
    /**
     * Registers a newly allocated sound channel in the active lexical producer context.
     */
    static bool RegisterSounds(mgCMemory &producer, int slot, std::span<CHRINFO_SE> allocation);
    /**
     * Completes graph bindings and sounds once the profile has finished construction.
     */
    bool FinishCloneInputs(ResourceState &resources, mgCMemory &model);
    MetadataScope(const MetadataScope &) = delete;
    MetadataScope &operator=(const MetadataScope &) = delete;
    MetadataScope(MetadataScope &&) = delete;
    MetadataScope &operator=(MetadataScope &&) = delete;

private:
    struct State;
    static State          *active; /**< Current lexical metadata scope; restored before a scope is destroyed. */
    std::unique_ptr<State> state;  /**< Owned names and the enclosing parser's complete scratch state. */
};
} // namespace dc2::character

/**
 * Applies one non-resource gameplay setting using the game's original typed callback.
 */
bool PortCharacterMetadataApply(const char *command, dc2::script::TagArguments arguments, int count, bool skin);
/**
 * Selects the native motion slot used by following key, sequence, and sound metadata.
 */
void PortCharacterMetadataMotionSlot(int slot);
/**
 * Returns the visual selection table established by vertex-animation metadata.
 */
mgCreateVisualType *PortCharacterMetadataVisualTypes(bool skin);
/**
 * Records the directly loaded body and its deformable frame references.
 */
void PortCharacterMetadataModel(mgCFrame *model);
/**
 * Returns and advances the next native cloth record selected by metadata.
 */
int PortCharacterMetadataNextCloth();
