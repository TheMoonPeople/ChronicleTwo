#include "common.h"

#include <algorithm>
#include <optional>
#include <span>
#include <unordered_map>
#include <utility>

#include "character_motion.hpp"
#include "gameutil.hpp"
#include "platform/model_assets.hpp"

namespace character_motion {
namespace {
/**
 * The action last posed on one frame tree, the source of the next blend.
 */
struct Posed {
    const Mot_List *anchor = nullptr; /**< Motion set of the action. */
    std::size_t     action = 0;       /**< Index of the action in its motion set. */
};

/**
 * Registered actions by the channel anchor of their motion set.
 */
std::unordered_map<const Mot_List *, std::vector<Action> > &Registry() {
    static std::unordered_map<const Mot_List *, std::vector<Action> > registry;
    return registry;
}

/**
 * Last posed action by frame tree root.
 */
std::unordered_map<const mgCFrame *, Posed> &PosedActions() {
    static std::unordered_map<const mgCFrame *, Posed> posed;
    return posed;
}

/**
 * Finds the index of the action whose interval holds a game frame.
 */
std::optional<std::size_t> IndexAt(std::span<const Action> actions, float frame) {
    for (std::size_t index = 0; index < actions.size(); ++index) {
        const auto &action = actions[index];
        if (frame >= static_cast<float>(action.base) && frame <= static_cast<float>(action.base) + action.duration) {
            return index;
        }
    }
    return std::nullopt;
}

/**
 * Finds the action a game frame falls in, or the nearest one before it for a frame between or past
 * the intervals, as the game clamps a motion's keys.
 */
std::optional<std::size_t> NearestAt(std::span<const Action> actions, float frame) {
    if (const auto index = IndexAt(actions, frame)) {
        return index;
    }
    std::optional<std::size_t> nearest;
    for (std::size_t index = 0; index < actions.size(); ++index) {
        if (static_cast<float>(actions[index].base) <= frame && (!nearest || actions[index].base > actions[*nearest].base)) {
            nearest = index;
        }
    }
    if (!nearest && !actions.empty()) {
        nearest = 0;
    }
    return nearest;
}

/**
 * Offsets a game frame into an action, clamped to its interval.
 */
float Local(const Action &action, float frame) {
    return std::clamp(frame - static_cast<float>(action.base), 0.0f, action.duration);
}

/**
 * Applies one auxiliary (material, camera, vertex or visibility) channel at a local game frame.
 *
 * An action's channels are sliced to its KEY interval and end on its last frame, where the retail
 * motion carried on. There the game's MotionProc finds no later key to interpolate toward and divides
 * zero by zero, so material alpha and colour become NaN and a fading effect draws at full brightness.
 * At or past its last key the channel holds that key, the value the game read there from the whole motion.
 */
Mot_List *ApplyAuxiliary(mgCFrame &root, float local, Mot_List *channel, mgCCamera *camera) {
    const u32 last = channel->key_frames[channel->key_count - 1];
    if (local >= static_cast<float>(last)) {
        return MotionProc(&root, last, last, 0.0f, channel, camera);
    }
    return MotionProc(&root, local, channel, camera);
}

/**
 * Applies one action's channels at a local game frame.
 */
void Apply(mgCFrame &root, const Action &action, float local, mgCCamera *camera) {
    for (auto *channel = action.head; channel;) {
        if (!channel->key_count) {
            channel = channel->next;
            continue;
        }
        if (model_assets::ApplyChannel(root, local, local, 0, *channel)) {
            channel = channel->next;
        } else {
            channel = ApplyAuxiliary(root, local, channel, camera);
        }
    }
}
} // namespace

void Register(const Mot_List *anchor, std::vector<Action> actions) {
    // An anchor allocated where a released one lay replaces its actions; poses recorded from those are stale.
    std::erase_if(PosedActions(), [anchor](const auto &entry) { return entry.second.anchor == anchor; });
    Registry().insert_or_assign(anchor, std::move(actions));
}

void Forget(const Mot_List *anchor) {
    if (!anchor) {
        return;
    }
    Registry().erase(anchor);
    std::erase_if(PosedActions(), [anchor](const auto &entry) { return entry.second.anchor == anchor; });
}

void ForgetPose(const mgCFrame *root) {
    PosedActions().erase(root);
}

void Clear() {
    Registry().clear();
    PosedActions().clear();
}

std::span<const Action> Actions(const tagMOTION_TYPE &motion) {
    const auto found = Registry().find(motion.motion_list);
    if (found == Registry().end()) {
        return {};
    }
    return found->second;
}

const Action *Find(const tagMOTION_TYPE &motion, std::string_view name) {
    const auto actions = Actions(motion);
    const auto found = std::ranges::find(actions, name, &Action::name);
    return found == actions.end() ? nullptr : &*found;
}

const Action *At(const tagMOTION_TYPE &motion, float frame) {
    const auto actions = Actions(motion);
    const auto index = IndexAt(actions, frame);
    return index ? &actions[*index] : nullptr;
}

void Pose(mgCFrame &root, tagMOTION_TYPE &motion, float frame, mgCCamera *camera) {
    const auto actions = Actions(motion);
    const auto index = NearestAt(actions, frame);
    if (!index) {
        return;
    }
    const auto &action = actions[*index];
    Apply(root, action, Local(action, frame), camera);
    PosedActions().insert_or_assign(&root, Posed{.anchor = motion.motion_list, .action = *index});
}

void Blend(mgCFrame &root, tagMOTION_TYPE &motion, float from, float to, float blend, mgCCamera *camera) {
    const auto actions = Actions(motion);
    const auto target_index = NearestAt(actions, to);
    if (!target_index) {
        return;
    }
    const auto &target = actions[*target_index];
    const float target_local = Local(target, to);
    // The game blends from the frame it last posed; that action may belong to another motion set.
    const Action *source = nullptr;
    if (const auto posed = PosedActions().find(&root); posed != PosedActions().end()) {
        if (const auto set = Registry().find(posed->second.anchor); set != Registry().end() && posed->second.action < set->second.size()) {
            const auto &candidate = set->second[posed->second.action];
            if (from >= static_cast<float>(candidate.base) && from <= static_cast<float>(candidate.base) + candidate.duration + 1) {
                source = &candidate;
            }
        }
    }
    if (!source) {
        if (const auto index = IndexAt(actions, from)) {
            source = &actions[*index];
        }
    }
    if (!source) {
        Apply(root, target, target_local, camera);
        return;
    }
    const float source_local = std::min(from - static_cast<float>(source->base), source->duration);
    if (source == &target) {
        for (auto *channel = target.head; channel;) {
            if (!channel->key_count) {
                channel = channel->next;
                continue;
            }
            if (model_assets::ApplyChannel(root, source_local, target_local, blend, *channel)) {
                channel = channel->next;
            } else {
                channel = MotionProc(&root, static_cast<unsigned int>(source_local), static_cast<unsigned int>(target_local), blend, channel, camera);
            }
        }
        return;
    }
    model_assets::BlendActions(root, source->head, source_local, target.head, target_local, blend);
    // Auxiliary channels of the two actions differ, so the target's apply unblended.
    for (auto *channel = target.head; channel;) {
        if (!channel->key_count || model_assets::IsNativeChannel(*channel)) {
            channel = channel->next;
        } else {
            channel = ApplyAuxiliary(root, target_local, channel, camera);
        }
    }
}
} // namespace character_motion
