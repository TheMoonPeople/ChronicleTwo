// clang-format off
#include "platform/native_config.hpp"
// clang-format on

#include "common.h"

#include <cstdio>
#include <cstring>

#include "dataread.hpp"
#include "mg_memory.hpp"
#include "scenevillager.hpp"
#include "villagermngr.hpp"
#include "vlgr_info.hpp"

/**
 *
 * Number of villager places in the loaded table.
 *
 */
int PlaceInfoNum;

/**
 *
 * Loaded villager place records.
 *
 */
CVillagerPlaceInfo *PlaceInfo;

/**
 *
 * Number of loaded villager model records.
 *
 */
int VlgrInfoNum;

/**
 *
 * Loaded villager model and appearance records.
 *
 */
CVillagerInfo *VlgrInfo;

/**
 *
 * Villager placement schedules indexed by villager number.
 *
 */
CVillagerPlace VlgrPlace[VLGR_PLACE_MAX];

/**
 *
 * Number of story progress points.
 *
 */
int ProgressNum;

/**
 *
 * Story progress points loaded from the configuration script.
 *
 */
GAME_PROGRESS_INFO ProgressInfo[GAME_PROGRESS_MAX];

CVillagerPlaceInfo *GetVlgrPlaceInfo(int index) {
    if (index < 0 || index >= PlaceInfoNum) {
        return nullptr;
    }

    return PlaceInfo + index;
}

CVillagerPlace *GetVlgrPlaceTable(int *count) {
    *count = VLGR_PLACE_MAX;
    return VlgrPlace;
}

CVillagerInfo *GetVillagerInfo(int villager_no) {
    CVillagerInfo *table = VlgrInfo;
    int            low = {};
    int            high = {};
    int            middle = {};

    if (table == nullptr || VlgrInfoNum <= 0) {
        return nullptr;
    }

    low = 0;
    high = VlgrInfoNum - 1;

    if (0 < high) {
        do {
            middle = (low + high) / 2;

            if (table[middle].vlgr_id < villager_no) {
                low = middle + 1;
            } else {
                high = middle;
            }
        } while (low < high);
    }

    if (villager_no == table[low].vlgr_id) {
        return &table[low];
    }

    return nullptr;
}

std::optional<std::string> GetVillagerModelName(int villager_no) {
    const auto *info = GetVillagerInfo(villager_no);
    if (info == nullptr || info->model_name == nullptr) {
        return std::nullopt;
    }
    return "chara/" + std::string(info->model_name) + ".gltf";
}

CVillagerInfo::CVillagerInfo() {
    vlgr_id = -1;
    model_name = nullptr;
    house_type = 0;
    hide_frames = nullptr;
    show_frames = nullptr;
    unk_18 = -1;
    unk_14 = -1;
}

CVillagerPlaceInfo::CVillagerPlaceInfo() = default;

/**
 *
 * Maps a villager motion name to its motion number.
 *
 */
int vpiGetMotionID(char *name) {
    if (name == nullptr || *name == '\0') {
        return -1;
    }

    if (strcmp(name, "sit") == 0) {
        return VILLAGER_MOTION_SIT;
    }

    if (strcmp(name, "stand") == 0) {
        return VILLAGER_MOTION_STAND;
    }

    if (strcmp(name, "special") == 0) {
        return VILLAGER_MOTION_SPECIAL;
    }

    if (strcmp(name, "walk") == 0) {
        return VILLAGER_MOTION_WALK;
    }

    return (strcmp(name, "run") == 0) ? VILLAGER_MOTION_RUN : VILLAGER_MOTION_NONE;
}

GAME_PROGRESS_INFO *GetGameProgressInfo(int index) {
    if (index < 0 || index >= ProgressNum) {
        return nullptr;
    }

    return &ProgressInfo[index];
}

int GetGameChapter(int index) {
    GAME_PROGRESS_INFO *info = GetGameProgressInfo(index);

    if (info != nullptr) {
        return info->chapter;
    }

    return 0;
}

int GetGameProgressNum() {
    return ProgressNum;
}

CVillagerPlace::CVillagerPlace() {
    memset(this, 0, sizeof(CVillagerPlace));
}

// nlohmann must precede the game headers, whose macros it would otherwise see.
// clang-format off
// clang-format on

#include "common.h"

#include <array>
#include <climits>
#include <cstdint>
#include <new>
#include <optional>
#include <stdexcept>
#include <string>
#include <string_view>
#include <vector>

#include "mg_memory.hpp"
#include "stubs/vlgr_info.hpp"
#include "villagermngr.hpp"
#include "vlgr_info.hpp"

namespace {

/**
 * CP932 "以後": the condition making a progress entry also apply to later progress.
 */
constexpr std::string_view kAfterCondition = "\x88\xC8\x8C\xE3";

/**
 * Posture making a route wait also end when its motion ends.
 */
constexpr std::string_view kMotionEndPosture = "mtn";

/**
 * The only place motion name the MOTION setting recognizes.
 */
constexpr std::string_view kSitMotion = "sit";

/**
 * Number of alternative places one progress entry holds.
 */
constexpr int kDuplicateMax = 4;

/**
 * Kind of step on a villager's route.
 */
enum class RouteStepType {
    Move, /**< Walk to a point. */
    Wait  /**< Wait for a number of frames. */
};

/**
 * One step of a place's route.
 */
struct RouteStep {
    RouteStepType              type;     /**< Kind of step. */
    std::array<float, 3>       position; /**< Point to walk to, for a move. */
    float                      angle;    /**< Angle faced at the point, for a move. */
    std::optional<std::string> posture;  /**< CP932 wait posture, for a wait. */
    int                        time;     /**< Frames to wait, for a wait. */
    std::optional<std::string> motion;   /**< CP932 motion name played while waiting, for a wait. */
};

/**
 * One place block of a villager_places document, applied to the place its index names.
 */
struct PlaceBlock {
    int                                 index;       /**< Place number. */
    int                                 map;         /**< Number of the map the place is on. */
    std::optional<std::array<float, 3>> position;    /**< Standing position. */
    float                               angle;       /**< Angle faced at the standing position. */
    std::optional<std::array<float, 3>> talk_offset; /**< Area the player can talk from. */
    std::optional<std::string>          motion;      /**< CP932 standing motion name. */
    std::optional<std::string>          move_motion; /**< CP932 walking motion name. */
    std::optional<float>                move_speed;  /**< Distance walked per frame. */
    std::optional<int>                  shadow;      /**< Whether the villager casts a shadow. */
    std::vector<RouteStep>              route;       /**< Route steps appended to the place's route. */
};

/**
 * Typed contents of a villager_places document.
 */
struct VillagerPlaces {
    int                     place_count; /**< Number of places to allocate; none are allocated when not above zero. */
    std::vector<PlaceBlock> places;      /**< Place blocks in script order. */
};

/**
 * One story progress point of a villager_schedule document.
 */
struct ProgressPoint {
    int                        progress; /**< Progress number. */
    int                        chapter;  /**< Chapter the point is in. */
    int                        section;  /**< Section of the chapter. */
    int                        order;    /**< Position of the point in the story. */
    std::optional<std::string> name;     /**< CP932 name of the point. */
};

/**
 * One progress entry of a villager's schedule.
 */
struct ProgressEntry {
    int                        progress;     /**< Progress number the entry applies from. */
    int                        duplicate_id; /**< Alternative the places are stored under. */
    std::optional<std::string> condition;    /**< CP932 condition text. */
    std::optional<int>         noon_place;   /**< Daytime place number. */
    std::optional<int>         night_place;  /**< Night-time place number. */
};

/**
 * One villager's schedule.
 */
struct VillagerSchedule {
    int                        id;       /**< Villager number. */
    std::vector<ProgressEntry> progress; /**< Progress entries in script order. */
};

/**
 * One villager's model and look.
 */
struct VillagerModel {
    int                        id;          /**< Villager number. */
    std::optional<std::string> model;       /**< CP932 model file name. */
    std::optional<int>         house_type;  /**< House style, a VLGR_HOUSE_TYPE. */
    std::optional<std::string> show_frames; /**< CP932 names of the frames drawn. */
    std::optional<std::string> hide_frames; /**< CP932 names of the frames hidden. */
    std::optional<int>         unk_14;      /**< Value stored in CVillagerInfo::unk_14. */
    std::optional<int>         unk_18;      /**< Value stored in CVillagerInfo::unk_18. */
};

/**
 * The villager model table of a villager_schedule document.
 */
struct VillagerModels {
    int                        count;     /**< Number of table entries to allocate. */
    std::vector<VillagerModel> villagers; /**< Entries in script order; those past the count are dropped. */
};

/**
 * Typed contents of a villager_schedule document.
 */
struct VillagerScheduleDocument {
    std::vector<ProgressPoint>    progress_info; /**< Story progress points in script order. */
    std::vector<VillagerSchedule> villagers;     /**< Villager schedules in script order. */
    std::optional<VillagerModels> models;        /**< Villager models, read after the schedules. */
};

/**
 * Reads an optional fixed-length float array member.
 */
std::optional<std::array<float, 3>> OptionalVector(const native_config::Json &object, const char *key) {
    if (!object.contains(key)) {
        return std::nullopt;
    }
    return native_config::Floats<3>(object, key);
}

/**
 * Parses one route step.
 */
RouteStep ParseRouteStep(const native_config::Json &step) {
    using namespace native_config;
    const auto &type = At(step, "type");
    if (type == "move") {
        return {.type = RouteStepType::Move, .position = Floats<3>(step, "position"), .angle = Float(step, "angle"), .posture = std::nullopt, .time = 0, .motion = std::nullopt};
    }
    if (type == "wait") {
        return {.type = RouteStepType::Wait, .position = {}, .angle = 0.0f, .posture = GameText(At(step, "posture")), .time = Int(step, "time"), .motion = OptionalText(step, "motion")};
    }
    throw std::runtime_error("unknown route step type");
}

/**
 * Parses a villager_places document.
 */
VillagerPlaces ParseVillagerPlaces(const native_config::Json &document) {
    using namespace native_config;
    VillagerPlaces places{.place_count = Int(document, "place_count"), .places = {}};
    for (const auto &place : Array(document, "places")) {
        PlaceBlock block{
            .index = Int(place, "index"),
            .map = Int(place, "map"),
            .position = OptionalVector(place, "position"),
            .angle = 0.0f,
            .talk_offset = OptionalVector(place, "talk_offset"),
            .motion = OptionalText(place, "motion"),
            .move_motion = OptionalText(place, "move_motion"),
            .move_speed = OptionalFloat(place, "move_speed"),
            .shadow = OptionalInt(place, "shadow"),
            .route = {},
        };
        if (block.position) {
            block.angle = Float(place, "angle");
        }
        for (const auto &step : Array(place, "route")) {
            block.route.push_back(ParseRouteStep(step));
        }
        places.places.push_back(std::move(block));
    }
    return places;
}

/**
 * Parses a villager_schedule document.
 */
VillagerScheduleDocument ParseVillagerSchedule(const native_config::Json &document) {
    using namespace native_config;
    VillagerScheduleDocument schedule;
    for (const auto &point : Array(document, "progress_info")) {
        schedule.progress_info.push_back({
            .progress = Int(point, "progress"),
            .chapter = Int(point, "chapter"),
            .section = Int(point, "section"),
            .order = Int(point, "order"),
            .name = OptionalText(point, "name"),
        });
    }
    for (const auto &villager : Array(document, "villagers")) {
        VillagerSchedule entry{.id = Int(villager, "id"), .progress = {}};
        for (const auto &progress : Array(villager, "progress")) {
            entry.progress.push_back({
                .progress = Int(progress, "progress"),
                .duplicate_id = Int(progress, "duplicate_id"),
                .condition = OptionalText(progress, "condition"),
                .noon_place = OptionalInt(progress, "noon_place"),
                .night_place = OptionalInt(progress, "night_place"),
            });
        }
        schedule.villagers.push_back(std::move(entry));
    }
    if (document.contains("villager_info")) {
        const auto    &info = At(document, "villager_info");
        VillagerModels models{.count = Int(info, "count"), .villagers = {}};
        if (models.count < 0) {
            throw std::runtime_error("villager_info count is negative");
        }
        for (const auto &villager : Array(info, "villagers")) {
            models.villagers.push_back({
                .id = Int(villager, "id"),
                .model = OptionalText(villager, "model"),
                .house_type = OptionalInt(villager, "house_type"),
                .show_frames = OptionalText(villager, "show_frames"),
                .hide_frames = OptionalText(villager, "hide_frames"),
                .unk_14 = OptionalInt(villager, "unk_14"),
                .unk_18 = OptionalInt(villager, "unk_18"),
            });
        }
        schedule.models = std::move(models);
    }
    return schedule;
}

/**
 * Allocates a table of a byte size as the script callbacks do, or gives null when the arena cannot hold it.
 */
u_long128 *AllocTable(mgCMemory *memory, std::uint64_t size) {
    const std::uint64_t blocks = (size + 15) / 16;
    if (blocks + 2 > static_cast<std::uint64_t>(INT_MAX)) {
        return nullptr;
    }
    return memory->Alloc(static_cast<int>(blocks + 2));
}

/**
 * Copies game text into an arena as mgCopyString does.
 */
char *CopyText(const std::string &text, mgCMemory *memory) {
    std::string copy = text;
    return mgCopyString(copy.data(), memory);
}

/**
 * Maps a motion name to its motion number, treating no name as none.
 */
int MotionId(const std::optional<std::string> &name) {
    std::string copy = name.value_or("");
    return vpiGetMotionID(name ? copy.data() : nullptr);
}

/**
 * Appends one route step to a place as the MOVE_TO and WAIT callbacks do.
 */
void ApplyRouteStep(CVillagerPlaceInfo &place, const RouteStep &step, mgCMemory *memory) {
    CVillagerPlaceInfo::Node *node = place.Add(memory);
    if (node == nullptr) {
        return;
    }
    if (step.type == RouteStepType::Move) {
        node->type = VLGR_ROUTE_MOVE;
        node->pos[0] = step.position[0];
        node->pos[1] = step.position[1];
        node->pos[2] = step.position[2];
        node->pos[3] = step.angle;
        return;
    }
    node->type = VLGR_ROUTE_WAIT;
    node->wait.motion_end = step.posture == kMotionEndPosture ? 1 : 0;
    node->wait.time = step.time;
    node->wait.motion = MotionId(step.motion);
}

/**
 * Applies one place block to its place as the place callbacks do.
 */
void ApplyPlaceBlock(const PlaceBlock &block, mgCMemory *memory) {
    // Retail writes past the table for a place number out of range; the port ignores the block.
    if (PlaceInfo == nullptr || block.index < 0 || block.index >= PlaceInfoNum) {
        return;
    }
    CVillagerPlaceInfo &place = PlaceInfo[block.index];
    place.map_no = block.map;
    place.move_motion = VLGR_MOTION_WALK;
    if (block.position) {
        place.pos[0] = (*block.position)[0];
        place.pos[1] = (*block.position)[1];
        place.pos[2] = (*block.position)[2];
        place.pos[3] = block.angle;
    }
    if (block.talk_offset) {
        place.talk_offset[0] = (*block.talk_offset)[0];
        place.talk_offset[1] = (*block.talk_offset)[1];
        place.talk_offset[2] = (*block.talk_offset)[2];
    }
    if (block.motion == kSitMotion) {
        place.motion = VLGR_MOTION_SIT;
    }
    if (block.move_motion) {
        place.move_motion = MotionId(block.move_motion);
    }
    if (block.move_speed) {
        place.move_speed = *block.move_speed;
    }
    if (block.shadow) {
        place.no_shadow = *block.shadow != 0 ? 0 : 1;
    }
    for (const auto &step : block.route) {
        ApplyRouteStep(place, step, memory);
    }
}

/**
 * Allocates the place table and applies each configured place.
 */
void ApplyVillagerPlaces(const VillagerPlaces &places, mgCMemory *memory) {
    if (places.place_count > 0) {
        const auto          count = static_cast<std::uint64_t>(places.place_count);
        u_long128          *block = AllocTable(memory, count * sizeof(CVillagerPlaceInfo));
        CVillagerPlaceInfo *table = block != nullptr ? new (block) CVillagerPlaceInfo[places.place_count] : nullptr;
        if (table != nullptr) {
            PlaceInfo = table;
            PlaceInfoNum = places.place_count;
        }
    }
    for (const auto &block : places.places) {
        ApplyPlaceBlock(block, memory);
    }
}

/**
 * Stores the story progress points, as the PROG_INFO callback does.
 */
void ApplyProgressInfo(const std::vector<ProgressPoint> &points, mgCMemory *memory) {
    for (const auto &point : points) {
        if (point.progress < 0 || point.progress >= GAME_PROGRESS_MAX) {
            continue;
        }
        GAME_PROGRESS_INFO &info = ProgressInfo[point.progress];
        info.chapter = static_cast<s16>(point.chapter);
        info.section = static_cast<s16>(point.section);
        info.order = point.order;
        if (point.name) {
            info.name = CopyText(*point.name, memory);
        }
    }
}

/**
 * State the schedule callbacks carry from one command to the next.
 */
struct ScheduleState {
    std::array<CVillagerPlace::ProgressInfo, GAME_PROGRESS_MAX> entries{};          /**< Progress entries collected for the current villager. */
    int                                                         count = 0;          /**< Number of collected progress entries. */
    CVillagerPlace::ProgressInfo                               *current = nullptr;  /**< Entry the place settings go to. */
    int                                                         duplicate_id = 0;   /**< Alternative the place settings go to. */
    CVillagerPlace                                             *villager = nullptr; /**< Schedule receiving the collected entries. */
    CVillagerPlaceInfo                                         *places = nullptr;   /**< Place table the place numbers index. */
    int                                                         place_count = 0;    /**< Number of places in the table. */
};

/**
 * Selects or creates the entry of a progress number, as the PROGRESS callback does.
 */
void ApplyProgressStart(ScheduleState &state, const ProgressEntry &entry) {
    state.current = nullptr;
    for (int index = 0; index < state.count; ++index) {
        if (state.entries[index].progress == entry.progress) {
            state.current = &state.entries[index];
            break;
        }
    }
    if (state.current == nullptr) {
        if (state.count >= GAME_PROGRESS_MAX) {
            return;
        }
        state.current = &state.entries[state.count++];
        state.current->Init();
    }
    state.current->progress = entry.progress;
    state.duplicate_id = entry.duplicate_id;
    state.current->after = entry.condition == kAfterCondition ? 1 : 0;
}

/**
 * Stores a place of the current entry, as the NOON_PLACE and NIGHT_PLACE callbacks do.
 */
void ApplyEntryPlace(ScheduleState &state, std::optional<int> place_no, VLGR_TIME time) {
    if (!place_no || *place_no < 0 || *place_no >= state.place_count) {
        return;
    }
    // Retail dereferences a missing entry and indexes past its alternatives; the port ignores those settings.
    if (state.current == nullptr || state.duplicate_id < 0 || state.duplicate_id >= kDuplicateMax) {
        return;
    }
    state.current->place[state.duplicate_id][time] = &state.places[*place_no];
}

/**
 * Copies the collected entries into the current villager's schedule, as the PROGRESS_END callback does.
 */
void ApplyProgressEnd(ScheduleState &state, mgCMemory *memory) {
    if (state.villager == nullptr || state.count <= 0) {
        return;
    }
    const auto                    count = static_cast<std::uint64_t>(state.count);
    u_long128                    *block = AllocTable(memory, count * sizeof(CVillagerPlace::ProgressInfo));
    CVillagerPlace::ProgressInfo *table = block != nullptr ? new (block) CVillagerPlace::ProgressInfo[state.count] : nullptr;
    state.villager->prog_info = table;
    state.villager->prog_num = 0;
    if (table == nullptr) {
        return;
    }
    state.villager->prog_num = state.count;
    for (int index = 0; index < state.count; ++index) {
        table[index] = state.entries[index];
    }
}

/**
 * Applies one villager's schedule, as the NPC through NPC_END callbacks do.
 */
void ApplyVillagerSchedule(ScheduleState &state, const VillagerSchedule &villager, mgCMemory *memory) {
    state.villager = nullptr;
    // An out-of-range villager keeps collecting into the previous villager's entries without storing them.
    if (villager.id >= 0 && villager.id < VLGR_PLACE_MAX) {
        state.villager = &VlgrPlace[villager.id];
        *state.villager = CVillagerPlace();
        state.count = 0;
        state.duplicate_id = 0;
    }
    for (const auto &entry : villager.progress) {
        ApplyProgressStart(state, entry);
        ApplyEntryPlace(state, entry.noon_place, VLGR_TIME_NOON);
        ApplyEntryPlace(state, entry.night_place, VLGR_TIME_NIGHT);
        ApplyProgressEnd(state, memory);
    }
    state.villager = nullptr;
}

/**
 * Allocates the villager model table and fills it, as the NPC_INFO_NUM and NPC_INFO callbacks do.
 */
void ApplyVillagerModels(const VillagerModels &models, mgCMemory *memory) {
    VlgrInfoNum = models.count;
    u_long128 *block = AllocTable(memory, static_cast<std::uint64_t>(models.count) * sizeof(CVillagerInfo));
    VlgrInfo = block != nullptr ? new (block) CVillagerInfo[models.count] : nullptr;
    if (VlgrInfo == nullptr) {
        VlgrInfoNum = 0;
    }
    int index = 0;
    for (const auto &model : models.villagers) {
        if (index >= VlgrInfoNum) {
            return;
        }
        CVillagerInfo &info = VlgrInfo[index++];
        info.vlgr_id = model.id;
        if (model.model) {
            info.model_name = CopyText(*model.model, memory);
        }
        if (model.house_type) {
            info.house_type = *model.house_type;
        }
        if (model.show_frames) {
            info.show_frames = CopyText(*model.show_frames, memory);
        }
        if (model.hide_frames) {
            info.hide_frames = CopyText(*model.hide_frames, memory);
        }
        if (model.unk_14) {
            info.unk_14 = *model.unk_14;
        }
        if (model.unk_18) {
            info.unk_18 = *model.unk_18;
        }
    }
}

/**
 * Applies the configured villager schedules and models.
 */
void ApplyVillagerSchedules(const VillagerScheduleDocument &schedule, mgCMemory *memory) {
    ScheduleState state;
    state.places = PlaceInfo;
    state.place_count = PlaceInfoNum;
    for (const auto &villager : schedule.villagers) {
        ApplyVillagerSchedule(state, villager, memory);
    }
    if (schedule.models) {
        ApplyVillagerModels(*schedule.models, memory);
    }
}

} // namespace

void LoadGameInfo(mgCMemory *memory) {
    const auto places = native_config::ReadGame<VillagerPlaces>("place.cfg.json", "villager_places", ParseVillagerPlaces);
    if (!places) {
        return;
    }
    ApplyVillagerPlaces(*places, memory);

    for (auto &progress : ProgressInfo) {
        progress.section = 0;
        progress.chapter = 0;
        progress.name = nullptr;
        progress.order = 0;
    }

    const auto schedule = native_config::ReadGame<VillagerScheduleDocument>("npc_place4.cfg.json", "villager_schedule", ParseVillagerSchedule);
    if (!schedule) {
        return;
    }
    ProgressNum = GAME_PROGRESS_MAX;
    ApplyProgressInfo(schedule->progress_info, memory);
    ApplyVillagerSchedules(*schedule, memory);
}
