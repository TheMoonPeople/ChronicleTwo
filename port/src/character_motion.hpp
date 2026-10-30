#pragma once

#include <cstddef>
#include <span>
#include <string>
#include <string_view>
#include <vector>

class mgCFrame;
class mgCCamera;
struct Mot_List;
struct tagMOTION_TYPE;

/**
 * Plays a character's motion sets as named glTF actions.
 *
 * Each action of a motion set owns a disjoint interval of game frames, so the game's own frame,
 * ratio and sound arithmetic over its KEY intervals selects the action to pose.
 */
namespace character_motion {
/**
 * One named action of a motion set and the game frames it occupies.
 */
struct Action {
    std::string name;           /**< English action name, the glTF animation name without prefixes. */
    float       duration = 0;   /**< Length in game frames. */
    int         base = 0;       /**< First game frame of the action's interval. */
    Mot_List   *head = nullptr; /**< Native channels of the action, in local game frames. */
};

/**
 * Registers the actions of a motion set under its channel anchor.
 *
 * The storage is the arena memory holding the set's channels and anchor; the set stops resolving once any
 * of it is handed out again. The anchor is also stamped, so a set whose anchor is overwritten without going
 * through an arena stops resolving too.
 */
void Register(Mot_List *anchor, std::vector<Action> actions, std::span<const std::byte> storage);

/**
 * Forgets a motion set whose channel anchor is released or replaced.
 */
void Forget(const Mot_List *anchor);

/**
 * Forgets every motion set whose storage overlaps memory about to be written again.
 *
 * The game releases motion memory by resetting or rewinding an arena, or by freeing a heap block, without
 * telling the registry. The arena reports each range it hands out again or writes a header or an imported
 * buffer over, and the main-thread file loads report their whole sector-padded destination, which they
 * write before the caller reserves it.
 */
void ForgetStorage(const void *begin, const void *end);

/**
 * Forgets the pose recorded on a frame tree whose root is initialized or whose address is reused.
 */
void ForgetPose(const mgCFrame *root);

/**
 * Forgets every registered motion set and recorded pose.
 */
void Clear();

/**
 * Lists the registered actions of a motion set.
 */
std::span<const Action> Actions(const tagMOTION_TYPE &motion);

/**
 * Finds an action of a motion set by its English name.
 */
const Action *Find(const tagMOTION_TYPE &motion, std::string_view name);

/**
 * Finds the action whose interval holds a game frame.
 */
const Action *At(const tagMOTION_TYPE &motion, float frame);

/**
 * Poses a frame tree with the action holding a game frame.
 */
void Pose(mgCFrame &root, tagMOTION_TYPE &motion, float frame, mgCCamera *camera);

/**
 * Blends from the pose at one game frame to the action holding another.
 *
 * The source is the action last posed on the frame tree, which may belong to another motion set.
 */
void Blend(mgCFrame &root, tagMOTION_TYPE &motion, float from, float to, float blend, mgCCamera *camera);
} // namespace character_motion
