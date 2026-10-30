#include "common.h"

#include <algorithm>
#include <cmath>
#include <cstdio>
#include <cstring>
#include <initializer_list>
#include <limits>
#include <optional>
#include <string>
#include <string_view>
#include <type_traits>
#include <unordered_map>
#include <unordered_set>
#include <utility>
#include <vector>

#include "actionchara.hpp"
#include "character.hpp"
#include "dng_event.hpp"
#include "dng_main.hpp"
#include "dngfloor.hpp"
#include "effscript.hpp"
#include "event.hpp"
#include "event_func.hpp"
#include "gyoracesim.hpp"
#include "log/log.hpp"
#include "mapsky.hpp"
#include "menuaqua.hpp"
#include "menucommon.hpp"
#include "menudraw.hpp"
#include "menusys.hpp"
#include "monster.hpp"
#include "nd_meswin.hpp"
#include "scenesnd.hpp"
#include "script_guards.hpp"
#include "stubs/dngfloor.hpp"
#include "stubs/mapsky.hpp"
#include "stubs/menuaqua.hpp"
#include "text/bounded.hpp"
#include "userdata.hpp"

// Run-script externals defined in runscript_opcodes.cpp and effscript.cpp, which no header declares.
int _GET_ACTIVE_MONS_LIFEI(dc2::script::RunArguments stack, int argc);
int _GET_ACTIVE_MONS_LIFEF(dc2::script::RunArguments stack, int argc);
int _SET_ACTIVE_MONS_LIFEI(dc2::script::RunArguments stack, int argc);
int _SET_ACTIVE_MONS_LIFEF(dc2::script::RunArguments stack, int argc);
int _GET_ACTIVE_MONS_MAX_LIFE(dc2::script::RunArguments stack, int argc);
int _SET_DAMAGE_SCORE(dc2::script::RunArguments stack, int argc);
int _GET_MONS_GRADE(dc2::script::RunArguments stack, int argc);
int _SET_ESCAPE_RATE(dc2::script::RunArguments stack, int argc);
int _SET_GUARD_RATE(dc2::script::RunArguments stack, int argc);
int _SET_EXT_PARAM_RATE(dc2::script::RunArguments stack, int argc);
int _GET_ENTRY_OBJ_POS(dc2::script::RunArguments stack, int argc);
int _GET_ACTIVE_MONS_POS(dc2::script::RunArguments stack, int argc);
int _GET_ACTIVE_MONS_ROT(dc2::script::RunArguments stack, int argc);
int _GET_ACTIVE_MONS_DIST(dc2::script::RunArguments stack, int argc);
int _GET_ACTIVE_MONS_ANGLE(dc2::script::RunArguments stack, int argc);
int _MONS_SE_PLAY(dc2::script::RunArguments stack, int argument_count);
int _MONS_SE_STOP(dc2::script::RunArguments stack, int argument_count);
int _MONS_SE_LOOP(dc2::script::RunArguments stack, int argument_count);
int _GET_VALUE(dc2::script::RunArguments args);
int _SET_VALUE(dc2::script::RunArguments args);
int _CHR_SET_POS2(dc2::script::RunArguments args);
int _CHR_SET_ROT2(dc2::script::RunArguments args);
int _CHR_SET_SCALE2(dc2::script::RunArguments args);
int _CHR_SET_MOTION2(dc2::script::RunArguments args);
int _CHR_ADD_POS2(dc2::script::RunArguments args);
int _CHR_ADD_ROT2(dc2::script::RunArguments args);
int _CHR_ADD_SCALE2(dc2::script::RunArguments args);
int _CHR_SET_SHOW2(dc2::script::RunArguments args);
int _AUTO_SET_OFFSET(dc2::script::RunArguments args);
int _SPT_SET_TEXNAME(dc2::script::RunArguments args);

namespace script_guards {
namespace {

/**
 *
 * What a guard requires of a handler's arguments.
 *
 */
enum class RuleKind {
    Index,        /**< Argument is an integer in [first, end). */
    IndexOrSelf,  /**< Argument is an integer in [first, end), or -1 for the handler's current object. */
    Text,         /**< Argument is a string whose length is in [first, end). */
    TextIfString, /**< Argument, when present and a string, has a length in [first, end). */
    AllText,      /**< Every string argument is shorter than end. */
    MinArguments, /**< At least first arguments are present. */
    MaxArguments, /**< No more than end arguments, the rest being ignored. */
    Custom,       /**< The rule's check accepts the arguments. */
};

/**
 *
 * Requirement a guard places on a handler's arguments.
 *
 */
struct Rule {
    int      argument = 0;                                            /**< Argument the rule checks. */
    RuleKind kind = RuleKind::Index;                                  /**< What the rule requires. */
    int      first = 0;                                               /**< Smallest value or length accepted. */
    int      end = 0;                                                 /**< One past the largest value or length accepted, or the argument limit. */
    bool (*external_check)(dc2::script::RunArguments, int) = nullptr; /**< Check of a Custom rule on a run-script external. */
};

/**
 *
 * Gives the element count of an array type as an int.
 *
 */
template <typename Array>
constexpr int Extent = static_cast<int>(std::extent_v<Array>);

constexpr int kMonsterSlotEnd = static_cast<int>(DNG_CHARA_SLOT_MONSTER) + static_cast<int>(MONSTER_ACTIVE_MAX);
constexpr int kUnbounded = std::numeric_limits<int>::max();

/**
 *
 * Whether an integer lies in [first, end).
 *
 */
constexpr bool InRange(int value, int first, int end) {
    return value >= first && value < end;
}

/**
 *
 * Whether a text's length lies in [first, end).
 *
 */
bool LengthInRange(std::string_view text, int first, int end) {
    return std::cmp_greater_equal(text.size(), first) && std::cmp_less(text.size(), end);
}

/**
 *
 * Gives a run-script argument's string, or null when it is absent or not a string.
 *
 */
std::optional<std::string_view> ExternalText(dc2::script::RunArguments args, int argc, int index) {
    if (index < 0 || index >= argc || args.At(static_cast<std::size_t>(index)).type != RS_STR) {
        return std::nullopt;
    }
    return dc2::script::RunText(args + static_cast<std::size_t>(index));
}

std::optional<int> ExternalInteger(dc2::script::RunArguments args, int argc, int index) {
    if (index >= argc) {
        return std::nullopt;
    }
    if (args.At(static_cast<std::size_t>(index)).type == RS_INT) {
        return args.At(static_cast<std::size_t>(index)).val.i;
    }
    if (args.At(static_cast<std::size_t>(index)).type == RS_FLOAT) {
        const double value = args.At(static_cast<std::size_t>(index)).val.f;
        if (std::isfinite(value) && value >= std::numeric_limits<int>::min() && value < static_cast<double>(std::numeric_limits<int>::max()) + 1.0) {
            return static_cast<int>(value);
        }
    }
    return std::nullopt;
}

/**
 *
 * Accepts a script name for _LOAD_SCRIPT only when EventLoop can split it: the map name before its first
 * '/' fits map_name[0x20], and the map's directory with the rest of the stored name fits directory[0x40].
 *
 */
bool LoadScriptNameFits(dc2::script::RunArguments args, int argc) {
    const auto raw = ExternalText(args, argc, 0);
    if (!raw) {
        return false;
    }

    // _LOAD_SCRIPT stores the name with its extension replaced by "_1.stb" unless it already has "_1".
    std::string stored(*raw);
    if (!stored.contains("_1")) {
        if (stored.size() < 4) {
            return false;
        }
        stored.resize(stored.size() - 4);
        stored += "_1.stb";
    }
    if (!std::cmp_less(stored.size(), Extent<decltype(ED_EVENT_INFO::script_name)>)) {
        return false;
    }

    const auto slash = stored.find('/');
    if (slash == std::string::npos || !std::cmp_less(slash, Extent<decltype(ED_EVENT_INFO::jump_map_name)>)) {
        return false;
    }

    // GetMapPath's directory: "map/" and the first one, three and six characters of the name.
    const std::string_view map_name(stored.data(), slash);
    std::string            directory = "map/" + std::string(map_name.substr(0, 1)) + "/";
    if (map_name.size() >= 3) {
        directory += std::string(map_name.substr(0, 3)) + "/";
    }
    if (map_name.size() >= 6) {
        directory += std::string(map_name.substr(3, 3)) + "/";
    }
    constexpr int directory_capacity = 0x40;
    return std::cmp_less(directory.size() + map_name.size(), directory_capacity) && std::cmp_less(directory.size() + (stored.size() - slash - 1), directory_capacity);
}

/**
 *
 * Accepts _FUNCTION_MAP_JUMP only when the scene's destination name fits jump_map_name.
 *
 */
bool SceneJumpNameFits(dc2::script::RunArguments /*unused*/, int /*unused*/) {
    if (EventScene == nullptr) {
        return true;
    }
    constexpr std::size_t name_area = sizeof EventScene->event_data.event.target;
    const auto            name = dc2::text::View(EventScene->event_data.event.target, name_area);
    return name.size() < name_area && std::cmp_less(name.size(), Extent<decltype(ED_EVENT_INFO::jump_map_name)>);
}

/**
 *
 * Accepts a caption text only when it fits its caption.
 *
 */
bool CaptionFits(dc2::script::RunArguments args, int argc) {
    const auto command = ExternalInteger(args, argc, 0);
    if (!command) {
        return false;
    }
    if (*command == EVENT_CAPTION_ENABLE) {
        return argc >= 2;
    }
    if (*command != EVENT_CAPTION_SET) {
        return true;
    }
    const auto text = ExternalText(args, argc, 3);
    return argc >= 5 && text && LengthInRange(*text, 0, Extent<std::remove_reference_t<decltype(ED_EVENT_INFO::caption_text[0])>>);
}

/**
 *
 * Accepts a line-alpha message command only for a line the window keeps settings for.
 *
 */
bool MessageLineFits(dc2::script::RunArguments args, int argc) {
    const auto command = ExternalInteger(args, argc, 1);
    if (argc < 2 || !command) {
        return false;
    }
    if (*command == EVENT_SET_MES_AQUARIUM_FISH) {
        return true;
    }
    if (*command == EVENT_SET_MES_DEFAULT_COLOR) {
        return argc >= 6;
    }
    if (*command == EVENT_SET_MES_ABS_WINDOW) {
        return argc == 4 || argc >= 6;
    }
    if (*command == EVENT_SET_MES_TEXT_OFFSET || *command == EVENT_SET_MES_LINE_SHADE) {
        return argc >= 4;
    }
    if (*command != EVENT_SET_MES_LINE_ALPHA) {
        return argc >= 3;
    }
    const auto line = ExternalInteger(args, argc, 2);
    return argc >= 4 && line && InRange(*line, 0, MES_LINE_MAX);
}

/**
 *
 * Accepts a fish-race name or time command only for a message name slot and a race entrant.
 *
 */
bool RaceResultFits(dc2::script::RunArguments args, int argc) {
    const auto command = ExternalInteger(args, argc, 0);
    if (!command) {
        return false;
    }
    if (*command == EVENT_SET_GYORACE_ADD_TOUR) {
        return true;
    }
    if (*command != EVENT_SET_GYORACE_FISH_NAME && *command != EVENT_SET_GYORACE_FISH_TIME) {
        return argc >= 2;
    }
    const auto name = ExternalInteger(args, argc, 2);
    const auto result = ExternalInteger(args, argc, 3);
    return argc >= 4 && name && result && InRange(*name, 1, MES_NAME_MAX + 1) && InRange(*result, 0, GR_FISH_MAX);
}

bool PakuMotionArgumentsFit(dc2::script::RunArguments, int argc) {
    return argc == 3 || argc >= 5;
}

bool MapJumpNameFits(dc2::script::RunArguments args, int argc) {
    if (argc < 2 || (args.At(static_cast<std::size_t>(1)).type != RS_INT && args.At(static_cast<std::size_t>(1)).type != RS_STR)) {
        return false;
    }
    if (args.At(static_cast<std::size_t>(1)).type == RS_INT) {
        return true;
    }
    const auto name = ExternalText(args, argc, 1);
    return name && LengthInRange(*name, 0, Extent<decltype(ED_EVENT_INFO::jump_map_name)>);
}

/**
 *
 * Gives the guard rules of every run-script external, keyed by its function.
 *
 */
std::unordered_map<RunScriptFunction, std::vector<Rule>> &ExternalRules() {
    static std::unordered_map<RunScriptFunction, std::vector<Rule>> rules = [] {
        std::unordered_map<RunScriptFunction, std::vector<Rule>> table;
        // Active-monster externals identify a character slot within the dungeon's monster range.
        for (const auto function : {dc2::script::AdaptRunArguments<_GET_ACTIVE_MONS_LIFEI>, dc2::script::AdaptRunArguments<_GET_ACTIVE_MONS_LIFEF>, dc2::script::AdaptRunArguments<_SET_ACTIVE_MONS_LIFEI>, dc2::script::AdaptRunArguments<_SET_ACTIVE_MONS_LIFEF>, dc2::script::AdaptRunArguments<_GET_ACTIVE_MONS_MAX_LIFE>, dc2::script::AdaptRunArguments<_SET_DAMAGE_SCORE>, dc2::script::AdaptRunArguments<_GET_MONS_GRADE>, dc2::script::AdaptRunArguments<_SET_ESCAPE_RATE>, dc2::script::AdaptRunArguments<_SET_GUARD_RATE>, dc2::script::AdaptRunArguments<_SET_EXT_PARAM_RATE>, dc2::script::AdaptRunArguments<_GET_ENTRY_OBJ_POS>}) {
            table[function] = {
                {.argument = 0, .kind = RuleKind::IndexOrSelf, .first = DNG_CHARA_SLOT_MONSTER, .end = kMonsterSlotEnd}
            };
        }
        for (const auto function : {dc2::script::AdaptRunArguments<_GET_ACTIVE_MONS_POS>, dc2::script::AdaptRunArguments<_GET_ACTIVE_MONS_ROT>, dc2::script::AdaptRunArguments<_GET_ACTIVE_MONS_DIST>, dc2::script::AdaptRunArguments<_GET_ACTIVE_MONS_ANGLE>, dc2::script::AdaptRunArguments<_MONS_SE_PLAY>, dc2::script::AdaptRunArguments<_MONS_SE_STOP>, dc2::script::AdaptRunArguments<_MONS_SE_LOOP>}) {
            table[function] = {
                {.argument = 0, .kind = RuleKind::Index, .first = DNG_CHARA_SLOT_MONSTER, .end = kMonsterSlotEnd}
            };
        }
        for (const auto function : {dc2::script::AdaptRunArguments<_GET_VALUE>,
                                    dc2::script::AdaptRunArguments<_SET_VALUE>}) {
            table[function] = {
                {.argument = 0, .kind = RuleKind::Index, .first = 0, .end = Extent<decltype(_EFF_SCRIPT::value)>}
            };
        }
        for (const auto function : {dc2::script::AdaptRunArguments<_CHR_SET_POS2>,
                                    dc2::script::AdaptRunArguments<_CHR_SET_ROT2>,
                                    dc2::script::AdaptRunArguments<_CHR_SET_SCALE2>,
                                    dc2::script::AdaptRunArguments<_CHR_SET_MOTION2>,
                                    dc2::script::AdaptRunArguments<_CHR_ADD_POS2>,
                                    dc2::script::AdaptRunArguments<_CHR_ADD_ROT2>,
                                    dc2::script::AdaptRunArguments<_CHR_ADD_SCALE2>,
                                    dc2::script::AdaptRunArguments<_CHR_SET_SHOW2>}) {
            table[function] = {
                {.argument = 0, .kind = RuleKind::Index, .first = 0, .end = Extent<decltype(_EFF_SCRIPT::sub_chara)>}
            };
        }
        table[dc2::script::AdaptRunArguments<_AUTO_SET_OFFSET>] = {
            {.kind = RuleKind::MinArguments, .first = 1},
            {.argument = 1, .kind = RuleKind::TextIfString, .first = 0, .end = Extent<decltype(_EFF_SCRIPT::offset_frame)>}
        };
        table[dc2::script::AdaptRunArguments<_SPT_SET_TEXNAME>] = {
            {.argument = 0, .kind = RuleKind::Text, .first = 0, .end = Extent<decltype(_EFF_SCRIPT::tex_name)>}
        };
        return table;
    }();
    return rules;
}

/**
 *
 * Reports a refused call the first time its handler is refused.
 *
 */
void Report(const void *function, const char *kind, const char *name, int index, const Rule &rule) {
    static std::unordered_set<const void *> reported;
    if (!reported.insert(function).second) {
        return;
    }
    const std::string handler = name != nullptr ? std::string(name) : std::to_string(index);
    if (rule.kind == RuleKind::Custom) {
        CT_LOG_WARN(Script, "script guard: {} {} arguments are outside its tables; call skipped", kind, handler);
    } else {
        CT_LOG_WARN(Script, "script guard: {} {} argument {} is outside [{}, {}); call skipped", kind, handler, rule.argument, rule.first, rule.end);
    }
}

/**
 *
 * Whether a run-script external's arguments satisfy a rule.
 *
 */
bool Satisfies(const Rule &rule, dc2::script::RunArguments args, int argc) {
    switch (rule.kind) {
        case RuleKind::Index:
        case RuleKind::IndexOrSelf: {
            if (rule.argument >= argc) {
                return false;
            }
            const auto value = ExternalInteger(args, argc, rule.argument);
            return value && ((rule.kind == RuleKind::IndexOrSelf && *value == -1) || InRange(*value, rule.first, rule.end));
        }
        case RuleKind::Text: {
            const auto text = ExternalText(args, argc, rule.argument);
            return text && LengthInRange(*text, rule.first, rule.end);
        }
        case RuleKind::TextIfString: {
            if (rule.argument < argc && args.At(static_cast<std::size_t>(rule.argument)).type != RS_STR) {
                return false;
            }
            const auto text = ExternalText(args, argc, rule.argument);
            return rule.argument >= argc || (text && LengthInRange(*text, rule.first, rule.end));
        }
        case RuleKind::AllText:
            for (int i = 0; i < argc; ++i) {
                const auto text = ExternalText(args, argc, i);
                if (args.At(static_cast<std::size_t>(i)).type == RS_STR && !text) {
                    return false;
                }
                if (text && !LengthInRange(*text, 0, rule.end)) {
                    return false;
                }
            }
            return true;
        case RuleKind::MaxArguments:
            return true;
        case RuleKind::MinArguments:
            return argc >= rule.first;
        case RuleKind::Custom:
            return rule.external_check == nullptr || rule.external_check(args, argc);
    }
    return true;
}

} // namespace

bool AllowExternal(RunScriptFunction function, dc2::script::RunArguments args, int argc, int index) {
    if (argc < 0 || static_cast<std::size_t>(argc) > args.Remaining()) {
        return false;
    }
    const auto &rules = ExternalRules();
    const auto  found = rules.find(function);
    if (found == rules.end()) {
        return true;
    }
    for (const auto &rule : found->second) {
        if (!Satisfies(rule, args, argc)) {
            Report(reinterpret_cast<const void *>(function), "ext", nullptr, index, rule);
            return false;
        }
    }
    return true;
}

void GuardEventExternals(std::span<RunScriptFunction> table) {
    struct EventRule {
        int  slot{}; /**< EVENT_EXT slot of the external. */
        Rule rule;   /**< Requirement on its arguments. */
    };

    constexpr int   jump_name_end = Extent<decltype(ED_EVENT_INFO::jump_map_name)>;
    const EventRule rules[] = {
        {.slot = EVENT_EXT_GOTO_INTERIOR,        .rule = {.argument = 1, .kind = RuleKind::Text, .end = jump_name_end}                                 },
        {.slot = EVENT_EXT_GOTO_OUTSIDE,         .rule = {.argument = 1, .kind = RuleKind::Text, .end = jump_name_end}                                 },
        {.slot = EVENT_EXT_MOVE_INTERIOR,        .rule = {.argument = 1, .kind = RuleKind::Text, .end = jump_name_end}                                 },
        {.slot = EVENT_EXT_MAP_JUMP,             .rule = {.kind = RuleKind::Custom, .external_check = MapJumpNameFits}                                 },
        {.slot = EVENT_EXT_FUNCTION_MAP_JUMP,    .rule = {.kind = RuleKind::Custom, .external_check = SceneJumpNameFits}                               },
        {.slot = EVENT_EXT_LOAD_SCRIPT,          .rule = {.kind = RuleKind::Custom, .external_check = LoadScriptNameFits}                              },
        {.slot = EVENT_EXT_SET_MES_STR,          .rule = {.argument = 1, .kind = RuleKind::Index, .first = 1, .end = MES_NAME_MAX + 1}                 },
        {.slot = EVENT_EXT_SET_MES_STR,          .rule = {.kind = RuleKind::MinArguments, .first = 3}                                                  },
        {.slot = EVENT_EXT_SET_MES_STR,          .rule = {.argument = 2, .kind = RuleKind::TextIfString, .end = MES_NAME_LEN}                          },
        {.slot = EVENT_EXT_SET_MES_ETC,          .rule = {.kind = RuleKind::Custom, .external_check = MessageLineFits}                                 },
        {.slot = EVENT_EXT_SET_GYORACE_ETC,      .rule = {.kind = RuleKind::Custom, .external_check = RaceResultFits}                                  },
        {.slot = EVENT_EXT_SET_MOVIE_CC,         .rule = {.kind = RuleKind::Custom, .external_check = CaptionFits}                                     },
        {.slot = EVENT_EXT_SET_PAKU_ANIM,        .rule = {.argument = 1, .kind = RuleKind::Text, .end = PAKU_NAME_SIZE}                                },
        {.slot = EVENT_EXT_SET_PAKU_ANIM,        .rule = {.argument = 2, .kind = RuleKind::TextIfString, .end = PAKU_NAME_SIZE}                        },
        {.slot = EVENT_EXT_SET_PAKU_MOTION,      .rule = {.kind = RuleKind::Custom, .external_check = PakuMotionArgumentsFit}                          },
        {.slot = EVENT_EXT_SET_PAKU_MOTION,      .rule = {.argument = 1, .kind = RuleKind::Text, .end = PAKU_NAME_SIZE}                                },
        {.slot = EVENT_EXT_SET_PAKU_MOTION,      .rule = {.argument = 3, .kind = RuleKind::TextIfString, .end = PAKU_NAME_SIZE}                        },
        {.slot = EVENT_EXT_GET_EVENT_INFO_SNDID, .rule = {.argument = 0, .kind = RuleKind::Index, .end = Extent<decltype(ED_EVENT_INFO::snd_id)>}      },
        {.slot = EVENT_EXT_RANDOM_CIRCLE_OFF,    .rule = {.argument = 0, .kind = RuleKind::IndexOrSelf, .end = Extent<decltype(CRandomCircle::active)>}},
        {.slot = EVENT_EXT_HIT_EFFECT,           .rule = {.argument = 0, .kind = RuleKind::Index, .end = Extent<decltype(HitEffect)>}                  },
        {.slot = EVENT_EXT_SWE_INIT,             .rule = {.argument = 1, .kind = RuleKind::Index, .end = Extent<decltype(CCharacter2::sword_effect)>}  },
    };

    auto &external_rules = ExternalRules();
    for (const auto &[slot, rule] : rules) {
        if (slot < 0 || static_cast<std::size_t>(slot) >= table.size() || table[slot] == nullptr) {
            continue;
        }
        auto      &entry = external_rules[table[slot]];
        const bool present = std::ranges::any_of(entry, [&](const Rule &existing) {
            return existing.argument == rule.argument && existing.kind == rule.kind && existing.external_check == rule.external_check;
        });
        if (!present) {
            entry.push_back(rule);
        }
    }
}

} // namespace script_guards
