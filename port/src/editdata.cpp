// clang-format off
// nlohmann must precede the game headers, whose macros it would otherwise see.
#include "platform/native_config.hpp"
// clang-format on

#include "common.h"

#include <cstdio>
#include <optional>
#include <print>
#include <string>
#include <vector>

#include "editdata.hpp"
#include "mg_memory.hpp"
#include "stubs/editdata.hpp"

namespace {

/**
 * One named condition of a georama analysis.
 */
struct AnalysisCondition {
    int                        index;     /**< Condition number. */
    std::optional<std::string> name;      /**< Condition name, CP932. */
    std::optional<int>         geo_floor; /**< Floor whose geostone reveals it, when given. */
};

/**
 * One request of a georama analysis.
 */
struct AnalysisEntry {
    int                                        index;             /**< Request number. */
    int                                        unk_10;            /**< Value copied to EditAnalyzeDataSrc::unk_10. */
    std::optional<std::string>                 message;           /**< Request text, CP932. */
    std::optional<int>                         geo_floor;         /**< Floor whose geostone reveals it, when given. */
    std::optional<std::vector<int> >           condition_numbers; /**< Conditions the request needs, when given. */
    std::optional<std::optional<std::string> > on_parts;          /**< Parts shown while met, when given. */
    std::optional<std::optional<std::string> > off_parts;         /**< Parts hidden while met, when given. */
    std::optional<int>                         percent;           /**< Share of the town's future, when given. */
};

/**
 * Analysis of one georama map.
 */
struct AnalysisSource {
    int                            id;         /**< Map number of the analysis. */
    std::vector<AnalysisCondition> conditions; /**< Conditions in script order. */
    std::vector<AnalysisEntry>     entries;    /**< Requests in script order. */
};

/**
 * Parses a georama_analysis document.
 */
std::vector<AnalysisSource> ParseAnalysis(const native_config::Json &document) {
    using namespace native_config;
    std::vector<AnalysisSource> sources;
    for (const auto &source : Array(document, "sources")) {
        AnalysisSource parsed{.id = Int(source, "id"), .conditions = {}, .entries = {}};
        for (const auto &condition : Array(source, "conditions")) {
            parsed.conditions.push_back({.index = Int(condition, "index"), .name = OptionalText(condition, "name"), .geo_floor = OptionalInt(condition, "geo_floor")});
        }
        for (const auto &entry : Array(source, "entries")) {
            AnalysisEntry analysis{.index = Int(entry, "index"), .unk_10 = Int(entry, "unk_10"), .message = OptionalText(entry, "message"), .geo_floor = OptionalInt(entry, "geo_floor"), .condition_numbers = std::nullopt, .on_parts = std::nullopt, .off_parts = std::nullopt, .percent = OptionalInt(entry, "percent")};
            if (entry.contains("condition_numbers")) {
                analysis.condition_numbers = IntList(entry, "condition_numbers");
            }
            if (entry.contains("on_parts")) {
                analysis.on_parts = GameText(At(entry, "on_parts"));
            }
            if (entry.contains("off_parts")) {
                analysis.off_parts = GameText(At(entry, "off_parts"));
            }
            parsed.entries.push_back(std::move(analysis));
        }
        sources.push_back(std::move(parsed));
    }
    return sources;
}

/**
 * Copies optional game text into the analysis string memory.
 */
char *Copy(const std::optional<std::string> &text, mgCMemory *memory) {
    if (!text) {
        return nullptr;
    }
    std::string copy = *text;
    return mgCopyString(copy.data(), memory);
}

/**
 * Fills the analysis sources as the GEO_ANALYZE tags do.
 */
void ApplyAnalysis(const std::vector<AnalysisSource> &sources, mgCMemory *memory) {
    for (const auto &source : sources) {
        if (source.id < 0 || source.id >= EDIT_ANALYZE_MAP_MAX) {
            continue;
        }
        EditAnalyzeSrc *analysis = &AnalyzeSrc[source.id];
        analysis->Init();
        for (const auto &condition : source.conditions) {
            if (condition.index < 0 || condition.index >= EDIT_ANALYZE_CONDITION_MAX) {
                continue;
            }
            analysis->condition[condition.index] = Copy(condition.name, memory);
            if (condition.geo_floor) {
                analysis->geo_floor[condition.index] = static_cast<s16>(*condition.geo_floor);
            }
        }
        for (const auto &entry : source.entries) {
            if (entry.index < 0 || entry.index >= EDIT_ANALYZE_DATA_MAX) {
                continue;
            }
            EditAnalyzeDataSrc *data = &analysis->data[entry.index];
            data->unk_10 = entry.unk_10;
            data->message = Copy(entry.message, memory);
            data->con_no[0] = -1;
            if (entry.geo_floor) {
                data->geo_floor = static_cast<s16>(*entry.geo_floor);
            }
            // CON_NO leaves room for its -1 terminator, so it refuses a full list.
            if (entry.condition_numbers && entry.condition_numbers->size() < EDIT_ANALYZE_CON_NO_MAX) {
                std::size_t slot = 0;
                for (const int number : *entry.condition_numbers) {
                    data->con_no[slot++] = static_cast<s8>(number);
                }
                data->con_no[slot] = -1;
            }
            if (entry.on_parts) {
                data->on_parts = Copy(*entry.on_parts, memory);
            }
            if (entry.off_parts) {
                data->off_parts = Copy(*entry.off_parts, memory);
            }
            if (entry.percent) {
                data->percent = static_cast<s16>(*entry.percent);
            }
        }
    }
}

} // namespace

PORT_OVERRIDE void LoadEditAnalyzeData(int area_no, u_long128 * /*dest*/) {
    // Retail keeps the analysis strings in a function-local buffer of the same size.
    static u_long128 buffer[0x300];
    static mgCMemory memory;
    memory.stSetBuffer(buffer, 0x300);
    const std::string name = "geo" + std::to_string(area_no) + ".cfg.json";
    if (const auto sources = native_config::ReadGame<std::vector<AnalysisSource> >(name.c_str(), "georama_analysis", ParseAnalysis)) {
        ApplyAnalysis(*sources, &memory);
    }
    std::println("GeoData Remain = {}kbyte", ((memory.stack_size - memory.stack_used) * 16) / 1024);
}
