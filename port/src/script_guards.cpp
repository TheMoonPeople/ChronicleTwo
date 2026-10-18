#include "common.h"

#include <algorithm>
#include <cstdio>
#include <cstring>
#include <initializer_list>
#include <limits>
#include <print>
#include <string>
#include <string_view>
#include <type_traits>
#include <unordered_map>
#include <unordered_set>
#include <utility>
#include <vector>

#include "actionchara.hpp"
#include "bounded_text.hpp"
#include "character.hpp"
#include "dng_event.hpp"
#include "dng_main.hpp"
#include "dngfloor.hpp"
#include "effscript.hpp"
#include "event.hpp"
#include "event_func.hpp"
#include "gyoracesim.hpp"
#include "mapsky.hpp"
#include "menuaqua.hpp"
#include "menucommon.hpp"
#include "menudraw.hpp"
#include "menusys.hpp"
#include "monster.hpp"
#include "nd_meswin.hpp"
#include "scenesnd.hpp"
#include "script_guards.hpp"
#include "stubs/actscript.hpp"
#include "stubs/character.hpp"
#include "stubs/dngfloor.hpp"
#include "stubs/mapsky.hpp"
#include "stubs/menuaqua.hpp"
#include "userdata.hpp"

// Run-script externals defined in runscript_opcodes.cpp and effscript.cpp, which no header declares.
int _GET_ACTIVE_MONS_LIFEI(RS_STACKDATA *stack, int argc);
int _GET_ACTIVE_MONS_LIFEF(RS_STACKDATA *stack, int argc);
int _SET_ACTIVE_MONS_LIFEI(RS_STACKDATA *stack, int argc);
int _SET_ACTIVE_MONS_LIFEF(RS_STACKDATA *stack, int argc);
int _GET_ACTIVE_MONS_MAX_LIFE(RS_STACKDATA *stack, int argc);
int _SET_DAMAGE_SCORE(RS_STACKDATA *stack, int argc);
int _GET_MONS_GRADE(RS_STACKDATA *stack, int argc);
int _SET_ESCAPE_RATE(RS_STACKDATA *stack, int argc);
int _SET_GUARD_RATE(RS_STACKDATA *stack, int argc);
int _SET_EXT_PARAM_RATE(RS_STACKDATA *stack, int argc);
int _GET_ENTRY_OBJ_POS(RS_STACKDATA *stack, int argc);
int _GET_ACTIVE_MONS_POS(RS_STACKDATA *stack, int argc);
int _GET_ACTIVE_MONS_ROT(RS_STACKDATA *stack, int argc);
int _GET_ACTIVE_MONS_DIST(RS_STACKDATA *stack, int argc);
int _GET_ACTIVE_MONS_ANGLE(RS_STACKDATA *stack, int argc);
int _MONS_SE_PLAY(RS_STACKDATA *stack, int argument_count);
int _MONS_SE_STOP(RS_STACKDATA *stack, int argument_count);
int _MONS_SE_LOOP(RS_STACKDATA *stack, int argument_count);
int _GET_VALUE(RS_STACKDATA *stack, int argument_count);
int _SET_VALUE(RS_STACKDATA *stack, int argument_count);
int _CHR_SET_POS2(RS_STACKDATA *stack, int argument_count);
int _CHR_SET_ROT2(RS_STACKDATA *stack, int argument_count);
int _CHR_SET_SCALE2(RS_STACKDATA *stack, int argument_count);
int _CHR_SET_MOTION2(RS_STACKDATA *stack, int argument_count);
int _CHR_ADD_POS2(RS_STACKDATA *stack, int argument_count);
int _CHR_ADD_ROT2(RS_STACKDATA *stack, int argument_count);
int _CHR_ADD_SCALE2(RS_STACKDATA *stack, int argument_count);
int _CHR_SET_SHOW2(RS_STACKDATA *stack, int argument_count);
int _AUTO_SET_OFFSET(RS_STACKDATA *stack, int argument_count);
int _SPT_SET_TEXNAME(RS_STACKDATA *stack, int argument_count);

// Configuration tag handlers defined in menucommon.cpp and character.cpp, which no header declares.
int _MENU_ETCINFO2(SPI_STACK *stack, int arg_count);
int _MENU_TEXNAME(SPI_STACK *stack, int argc);
int _MENU_PART_ETCINFO(SPI_STACK *stack, int argc);
int _MENU_PART_DTYPE(SPI_STACK *stack, int argc);
int _MENU_FILLBOX(SPI_STACK *stack, int argc);
int _MENU_EXE_MSGENV(SPI_STACK *stack, int argc);
int _MENU_EXE_MAKEMSG(SPI_STACK *stack, int argc);
int _MENU_EXE_SETABSPOS(SPI_STACK *stack, int argc);
int _MENU_EXE_MSGSETSYSTEMBUFF(SPI_STACK *stack, int argc);
int _MENU_EXE_MSGSETBUFF(SPI_STACK *stack, int argc);
int _MENU_EXE_MSGSETFUCHI(SPI_STACK *stack, int argc);
int _MENU_EXE_MSGSETCURSOR(SPI_STACK *stack, int argc);
int _MENU_SET_QUESTIONGYOU(SPI_STACK *stack, int argc);
int _MENU_SET_OPENSPEED(SPI_STACK *stack, int argc);

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
    MaxArguments, /**< No more than end arguments, the rest being ignored. */
    Custom,       /**< The rule's check accepts the arguments. */
};

/**
 *
 * Requirement a guard places on a handler's arguments.
 *
 */
struct Rule {
    int      argument = 0;                               /**< Argument the rule checks. */
    RuleKind kind = RuleKind::Index;                     /**< What the rule requires. */
    int      first = 0;                                  /**< Smallest value or length accepted. */
    int      end = 0;                                    /**< One past the largest value or length accepted, or the argument limit. */
    bool (*external_check)(RS_STACKDATA *, int) = nullptr; /**< Check of a Custom rule on a run-script external. */
    int (*tag_check)(SPI_STACK *, int) = nullptr;          /**< Check of a Custom rule on a tag, giving the argument count to call with or -1. */
};

/**
 *
 * Gives the element count of an array type as an int.
 *
 */
template <typename Array>
constexpr int Extent = static_cast<int>(std::extent_v<Array>);

constexpr int kMonsterSlotEnd = DNG_CHARA_SLOT_MONSTER + Extent<decltype(CMonsterMan::active)>;
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
const char *ExternalText(RS_STACKDATA *args, int argc, int index) {
    return index < argc && args[index].type == RS_STR ? args[index].val.s : nullptr;
}

/**
 *
 * Gives a tag argument's string, or null when it is absent or not a string.
 *
 */
const char *TagText(SPI_STACK *args, int argc, int index) {
    return index < argc ? spiGetStackString(args + index) : nullptr;
}

/**
 *
 * Accepts a script name for _LOAD_SCRIPT only when EventLoop can split it: the map name before its first
 * '/' fits map_name[0x20], and the map's directory with the rest of the stored name fits directory[0x40].
 *
 */
bool LoadScriptNameFits(RS_STACKDATA *args, int argc) {
    const char *raw = ExternalText(args, argc, 0);
    if (raw == nullptr) {
        return false;
    }

    // _LOAD_SCRIPT stores the name with its extension replaced by "_1.stb" unless it already has "_1".
    std::string stored = raw;
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
bool SceneJumpNameFits(RS_STACKDATA * /*unused*/, int /*unused*/) {
    if (EventScene == nullptr) {
        return true;
    }
    // The destination name occupies map_jump_name and the 0x77 bytes after it.
    constexpr std::size_t name_area = 0x78;
    return std::cmp_less(bounded_text::View(EventScene->map_jump_name, name_area).size(), Extent<decltype(ED_EVENT_INFO::jump_map_name)>);
}

/**
 *
 * Accepts a caption text only when it fits its caption.
 *
 */
bool CaptionFits(RS_STACKDATA *args, int argc) {
    if (argc < 1 || rsGetStackInt(&args[0]) != EVENT_CAPTION_SET) {
        return true;
    }
    const char *text = ExternalText(args, argc, 3);
    return text != nullptr && LengthInRange(text, 0, Extent<std::remove_reference_t<decltype(ED_EVENT_INFO::caption_text[0])>>);
}

/**
 *
 * Accepts a line-alpha message command only for a line the window keeps settings for.
 *
 */
bool MessageLineFits(RS_STACKDATA *args, int argc) {
    if (argc < 2 || rsGetStackInt(&args[1]) != EVENT_SET_MES_LINE_ALPHA) {
        return true;
    }
    return argc >= 3 && InRange(rsGetStackInt(&args[2]), 0, MES_LINE_MAX);
}

/**
 *
 * Accepts a fish-race name or time command only for a message name slot and a race entrant.
 *
 */
bool RaceResultFits(RS_STACKDATA *args, int argc) {
    if (argc < 1) {
        return true;
    }
    const int command = rsGetStackInt(&args[0]);
    if (command != EVENT_SET_GYORACE_FISH_NAME && command != EVENT_SET_GYORACE_FISH_TIME) {
        return true;
    }
    return argc >= 4 && InRange(rsGetStackInt(&args[2]), 1, MES_NAME_MAX + 1) && InRange(rsGetStackInt(&args[3]), 0, GR_FISH_MAX);
}

/**
 *
 * Accepts a menu message command only for a message window that exists.
 *
 */
int MenuMessageExists(SPI_STACK *args, int argc) {
    if (argc < 1) {
        return -1;
    }
    const int index = spiGetStackInt(args);
    return InRange(index, 0, Extent<decltype(MenuDCMsg)>) && MenuDCMsg[index] != nullptr ? argc : -1;
}

/**
 *
 * Accepts _MENU_PART_ETCINFO only when every index it pairs with a value names one of the part's values.
 *
 */
int PartValueIndicesFit(SPI_STACK *args, int argc) {
    for (int pair = 0; pair < argc / 2; ++pair) {
        if (!InRange(spiGetStackInt(args + pair * 2), 0, Extent<decltype(MENUFORMPARTS_TYPE::etc_info)>)) {
            return -1;
        }
    }
    return argc;
}

/**
 *
 * Holds a palette-reload part to the values it has room for after its type and name.
 *
 */
int PartTypeValuesFit(SPI_STACK *args, int argc) {
    const char *type = TagText(args, argc, 0);
    if (type != nullptr && std::string_view(type) == "clut_reload") {
        return std::min(argc, 2 + Extent<decltype(MENUFORMPARTS_TYPE::etc_info)>);
    }
    return argc;
}

/**
 *
 * Gives the guard rules of every run-script external, keyed by its function.
 *
 */
std::unordered_map<RunScriptFunction, std::vector<Rule> > &ExternalRules() {
    static std::unordered_map<RunScriptFunction, std::vector<Rule> > rules = [] {
        std::unordered_map<RunScriptFunction, std::vector<Rule> > table;
        // Active-monster externals name a dungeon character slot, which maps onto CMonsterMan::active.
        for (const auto function : {_GET_ACTIVE_MONS_LIFEI, _GET_ACTIVE_MONS_LIFEF, _SET_ACTIVE_MONS_LIFEI, _SET_ACTIVE_MONS_LIFEF, _GET_ACTIVE_MONS_MAX_LIFE, _SET_DAMAGE_SCORE, _GET_MONS_GRADE, _SET_ESCAPE_RATE, _SET_GUARD_RATE, _SET_EXT_PARAM_RATE, _GET_ENTRY_OBJ_POS}) {
            table[function] = {
                {.argument = 0, .kind = RuleKind::IndexOrSelf, .first = DNG_CHARA_SLOT_MONSTER, .end = kMonsterSlotEnd}
            };
        }
        for (const auto function : {_GET_ACTIVE_MONS_POS, _GET_ACTIVE_MONS_ROT, _GET_ACTIVE_MONS_DIST, _GET_ACTIVE_MONS_ANGLE, _MONS_SE_PLAY, _MONS_SE_STOP, _MONS_SE_LOOP}) {
            table[function] = {
                {.argument = 0, .kind = RuleKind::Index, .first = DNG_CHARA_SLOT_MONSTER, .end = kMonsterSlotEnd}
            };
        }
        for (const auto function : {_GET_VALUE, _SET_VALUE}) {
            table[function] = {
                {.argument = 0, .kind = RuleKind::Index, .first = 0, .end = Extent<decltype(_EFF_SCRIPT::value)>}
            };
        }
        for (const auto function : {_CHR_SET_POS2, _CHR_SET_ROT2, _CHR_SET_SCALE2, _CHR_SET_MOTION2, _CHR_ADD_POS2, _CHR_ADD_ROT2, _CHR_ADD_SCALE2, _CHR_SET_SHOW2}) {
            table[function] = {
                {.argument = 0, .kind = RuleKind::Index, .first = 0, .end = Extent<decltype(_EFF_SCRIPT::sub_chara)>}
            };
        }
        table[_AUTO_SET_OFFSET] = {
            {.argument = 1, .kind = RuleKind::TextIfString, .first = 0, .end = Extent<decltype(_EFF_SCRIPT::offset_frame)>}
        };
        table[_SPT_SET_TEXNAME] = {
            {.argument = 0, .kind = RuleKind::Text, .first = 0, .end = Extent<decltype(_EFF_SCRIPT::tex_name)>}
        };
        // Action-script externals index the character's equipment, frames and weapon parameters.
        table[_CHECK_EQUIP] = {
            {.argument = 0, .kind = RuleKind::Index, .first = 0, .end = Extent<decltype(CHARA_DATA::equip)>}
        };
        for (const auto function : {_SET_ACCUME_FX, _SET_SHOT}) {
            table[function] = {
                {.argument = 0, .kind = RuleKind::Index, .first = 0, .end = Extent<decltype(CActionChara::object)>}
            };
        }
        table[_GET_ATTK_POINT] = {
            {.argument = 0, .kind = RuleKind::Index, .first = 0, .end = Extent<decltype(CBattleCharaInfo::weapon_param)>}
        };
        return table;
    }();
    return rules;
}

/**
 *
 * Gives the guard rules of every configuration tag handler, keyed by its function.
 *
 */
const std::unordered_map<SPI_TAG_FUNCTION, std::vector<Rule> > &TagRules() {
    constexpr int sky_name_end = Extent<decltype(MAP_SKY_INFO::bg_mds_name)>;
    constexpr int part_name_end = 0x40;
    static const std::unordered_map<SPI_TAG_FUNCTION, std::vector<Rule> > rules{
        {_ROOM_LINK,                 {{.argument = 0, .kind = RuleKind::MaxArguments, .end = Extent<decltype(DNGMAP_ROOM_INFO::link)>}}},
        // The entry name precedes its values, of which the entry holds four.
        {_MENU_ETCINFO2,             {{.argument = 0, .kind = RuleKind::Text, .end = kUnbounded}, {.kind = RuleKind::MaxArguments, .end = 1 + Extent<decltype(MENU_ETCINFO2::value)>}}},
        {_MENU_TEXNAME,              {{.argument = 0, .kind = RuleKind::TextIfString, .end = 0x20}, {.argument = 1, .kind = RuleKind::Index, .end = Extent<decltype(CBaseMenuClass::tex_block)>}}},
        {_MENU_PART_ETCINFO,         {{.kind = RuleKind::Custom, .tag_check = PartValueIndicesFit}}},
        {_MENU_PART_DTYPE,           {{.kind = RuleKind::Custom, .tag_check = PartTypeValuesFit}}},
        // The fill box's effect kind indexes its four effect counts.
        {_MENU_FILLBOX,              {{.argument = 6, .kind = RuleKind::Index, .end = 4}}},
        {_MENU_EXE_MSGENV,           {{.kind = RuleKind::Custom, .tag_check = MenuMessageExists}}},
        {_MENU_EXE_MAKEMSG,          {{.kind = RuleKind::Custom, .tag_check = MenuMessageExists}}},
        {_MENU_EXE_SETABSPOS,        {{.kind = RuleKind::Custom, .tag_check = MenuMessageExists}}},
        {_MENU_EXE_MSGSETSYSTEMBUFF, {{.kind = RuleKind::Custom, .tag_check = MenuMessageExists}, {.argument = 1, .kind = RuleKind::Index, .end = Extent<decltype(MENU_COMMAND_ANALYZE_INFO::system_mes_buff)>}}},
        {_MENU_EXE_MSGSETBUFF,       {{.kind = RuleKind::Custom, .tag_check = MenuMessageExists}, {.argument = 1, .kind = RuleKind::Index, .end = Extent<decltype(MENU_COMMAND_ANALYZE_INFO::mes_buff)>}}},
        {_MENU_EXE_MSGSETFUCHI,      {{.kind = RuleKind::Custom, .tag_check = MenuMessageExists}}},
        {_MENU_EXE_MSGSETCURSOR,     {{.kind = RuleKind::Custom, .tag_check = MenuMessageExists}}},
        {_MENU_SET_QUESTIONGYOU,     {{.kind = RuleKind::Custom, .tag_check = MenuMessageExists}}},
        {_MENU_SET_OPENSPEED,        {{.kind = RuleKind::Custom, .tag_check = MenuMessageExists}}},
        {_SKY_IMG,                   {{.argument = 1, .kind = RuleKind::TextIfString, .end = sky_name_end}}},
        {_SKY_MDS,                   {{.argument = 1, .kind = RuleKind::TextIfString, .end = sky_name_end}}},
        {_SUN_MDS,                   {{.argument = 1, .kind = RuleKind::TextIfString, .end = sky_name_end}}},
        {_SKYB_MDS,                  {{.argument = 1, .kind = RuleKind::TextIfString, .end = sky_name_end}}},
        {_SKY_BG,                    {{.argument = 0, .kind = RuleKind::TextIfString, .end = sky_name_end}}},
        {_SKY_ANIME,                 {{.argument = 1, .kind = RuleKind::TextIfString, .end = sky_name_end}}},
        {_SKYB_ANIME,                {{.argument = 1, .kind = RuleKind::TextIfString, .end = sky_name_end}}},
        // A race class indexes the four classes and its count sizes the class's fish array.
        {_GYORACE_LISTNUM,           {{.argument = 0, .kind = RuleKind::Index, .end = Extent<decltype(CGyoraceFishData::fish_num)>}, {.argument = 1, .kind = RuleKind::Index, .end = std::numeric_limits<s16>::max() + 1}}},
        {_OUTLINE,                   {{.argument = 0, .kind = RuleKind::TextIfString, .end = part_name_end}}},
        {_OBJECT_NAME,               {{.kind = RuleKind::AllText, .end = part_name_end}}},
        {_OBJECT_NAME2,              {{.kind = RuleKind::AllText, .end = part_name_end}}},
        {_VERTEX_ANIME,              {{.kind = RuleKind::AllText, .end = 16}}},
        {_KEY,                       {{.argument = 0, .kind = RuleKind::TextIfString, .end = Extent<decltype(CHRINFO_KEY_SET::name)>}}},
        {_SEQ_START,                 {{.argument = 0, .kind = RuleKind::TextIfString, .end = Extent<decltype(CHRINFO_SEQ_HEADER::name)>}}},
        {_SEQ,                       {{.argument = 0, .kind = RuleKind::TextIfString, .end = Extent<decltype(CHRINFO_SEQ::name)>}}},
        {_SKIN_MODEL,                {{.argument = 0, .kind = RuleKind::TextIfString, .end = 64}}},
        // The weight file's name is the model's up to its '.', followed by ".wgt", in 64 bytes.
        {_MODEL,                     {{.argument = 0, .kind = RuleKind::TextIfString, .end = 64 - 4}}},
        {_EFFECT,                    {{.kind = RuleKind::AllText, .end = Extent<decltype(CHRINFO_EFFECT::name)>}}},
    };
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
        std::println(stderr, "script guard: {} {} arguments are outside its tables; call skipped", kind, handler);
    } else {
        std::println(stderr, "script guard: {} {} argument {} is outside [{}, {}); call skipped", kind, handler, rule.argument, rule.first, rule.end);
    }
}

/**
 *
 * Whether a run-script external's arguments satisfy a rule.
 *
 */
bool Satisfies(const Rule &rule, RS_STACKDATA *args, int argc) {
    switch (rule.kind) {
        case RuleKind::Index:
        case RuleKind::IndexOrSelf: {
            if (rule.argument >= argc) {
                return false;
            }
            const int value = rsGetStackInt(&args[rule.argument]);
            return (rule.kind == RuleKind::IndexOrSelf && value == -1) || InRange(value, rule.first, rule.end);
        }
        case RuleKind::Text: {
            const char *text = ExternalText(args, argc, rule.argument);
            return text != nullptr && LengthInRange(text, rule.first, rule.end);
        }
        case RuleKind::TextIfString: {
            const char *text = ExternalText(args, argc, rule.argument);
            return text == nullptr || LengthInRange(text, rule.first, rule.end);
        }
        case RuleKind::AllText:
            for (int i = 0; i < argc; ++i) {
                const char *text = ExternalText(args, argc, i);
                if (text != nullptr && !LengthInRange(text, 0, rule.end)) {
                    return false;
                }
            }
            return true;
        case RuleKind::MaxArguments:
            return true;
        case RuleKind::Custom:
            return rule.external_check == nullptr || rule.external_check(args, argc);
    }
    return true;
}

/**
 *
 * Gives the argument count a tag's arguments may be passed with under a rule, or -1 when they break it.
 *
 */
int TagCount(const Rule &rule, SPI_STACK *args, int argc) {
    switch (rule.kind) {
        case RuleKind::MaxArguments:
            return std::min(argc, rule.end);
        case RuleKind::Index:
        case RuleKind::IndexOrSelf: {
            if (rule.argument >= argc) {
                return -1;
            }
            const int value = spiGetStackInt(args + rule.argument);
            return (rule.kind == RuleKind::IndexOrSelf && value == -1) || InRange(value, rule.first, rule.end) ? argc : -1;
        }
        case RuleKind::Text: {
            const char *text = TagText(args, argc, rule.argument);
            return text != nullptr && LengthInRange(text, rule.first, rule.end) ? argc : -1;
        }
        case RuleKind::TextIfString: {
            const char *text = TagText(args, argc, rule.argument);
            return text == nullptr || LengthInRange(text, rule.first, rule.end) ? argc : -1;
        }
        case RuleKind::AllText:
            for (int i = 0; i < argc; ++i) {
                const char *text = TagText(args, argc, i);
                if (text != nullptr && !LengthInRange(text, 0, rule.end)) {
                    return -1;
                }
            }
            return argc;
        case RuleKind::Custom:
            return rule.tag_check != nullptr ? rule.tag_check(args, argc) : argc;
    }
    return argc;
}

} // namespace

bool AllowExternal(RunScriptFunction function, RS_STACKDATA *args, int argc, int index) {
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

int TagArguments(SPI_TAG_FUNCTION function, SPI_STACK *args, int argc, const char *name) {
    const auto &rules = TagRules();
    const auto  found = rules.find(function);
    if (found == rules.end()) {
        return argc;
    }
    for (const auto &rule : found->second) {
        argc = TagCount(rule, args, argc);
        if (argc < 0) {
            Report(reinterpret_cast<const void *>(function), "tag", name, 0, rule);
            return -1;
        }
    }
    return argc;
}

void GuardEventExternals(std::span<RunScriptFunction> table) {
    struct EventRule {
        int  slot{}; /**< EVENT_EXT slot of the external. */
        Rule rule; /**< Requirement on its arguments. */
    };

    constexpr int   jump_name_end = Extent<decltype(ED_EVENT_INFO::jump_map_name)>;
    const EventRule rules[] = {
        {.slot = EVENT_EXT_GOTO_INTERIOR,        .rule = {.argument = 1, .kind = RuleKind::Text, .end = jump_name_end}                                 },
        {.slot = EVENT_EXT_GOTO_OUTSIDE,         .rule = {.argument = 1, .kind = RuleKind::Text, .end = jump_name_end}                                 },
        {.slot = EVENT_EXT_MOVE_INTERIOR,        .rule = {.argument = 1, .kind = RuleKind::Text, .end = jump_name_end}                                 },
        {.slot = EVENT_EXT_MAP_JUMP,             .rule = {.argument = 1, .kind = RuleKind::TextIfString, .end = jump_name_end}                         },
        {.slot = EVENT_EXT_FUNCTION_MAP_JUMP,    .rule = {.kind = RuleKind::Custom, .external_check = SceneJumpNameFits}                               },
        {.slot = EVENT_EXT_LOAD_SCRIPT,          .rule = {.kind = RuleKind::Custom, .external_check = LoadScriptNameFits}                              },
        {.slot = EVENT_EXT_SET_MES_STR,          .rule = {.argument = 1, .kind = RuleKind::Index, .first = 1, .end = MES_NAME_MAX + 1}                 },
        {.slot = EVENT_EXT_SET_MES_STR,          .rule = {.argument = 2, .kind = RuleKind::TextIfString, .end = MES_NAME_LEN}                          },
        {.slot = EVENT_EXT_SET_MES_ETC,          .rule = {.kind = RuleKind::Custom, .external_check = MessageLineFits}                                 },
        {.slot = EVENT_EXT_SET_GYORACE_ETC,      .rule = {.kind = RuleKind::Custom, .external_check = RaceResultFits}                                  },
        {.slot = EVENT_EXT_SET_MOVIE_CC,         .rule = {.kind = RuleKind::Custom, .external_check = CaptionFits}                                     },
        {.slot = EVENT_EXT_SET_PAKU_ANIM,        .rule = {.argument = 1, .kind = RuleKind::Text, .end = PAKU_NAME_SIZE}                                },
        {.slot = EVENT_EXT_SET_PAKU_ANIM,        .rule = {.argument = 2, .kind = RuleKind::TextIfString, .end = PAKU_NAME_SIZE}                        },
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
