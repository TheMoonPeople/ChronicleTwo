// clang-format off
// nlohmann must precede the game headers, whose macros it would otherwise see.
#include "platform/native_config.hpp"
// clang-format on

#include "common.h"

#include <cstring>
#include <optional>
#include <string>
#include <vector>

#include "mg_memory.hpp"
#include "quest.hpp"

namespace {

/**
 * One request of a quests document.
 */
struct QuestEntry {
    int                        id;        /**< Request number. */
    std::string                name;      /**< Title, CP932. */
    std::optional<std::string> comment;   /**< Description, CP932. */
    std::vector<std::string>   reactions; /**< Reaction comments in slot order, CP932. */
};

/**
 * Typed contents of a quests document.
 */
struct QuestList {
    int                     count;  /**< Number of request records allocated. */
    std::vector<QuestEntry> quests; /**< Requests in script order. */
};

/**
 * Parses a quests document, refusing texts the request records cannot hold.
 */
QuestList ParseQuests(const native_config::Json &document) {
    using namespace native_config;
    QuestList list{.count = Int(document, "count"), .quests = {}};
    if (list.count < 0) {
        throw std::runtime_error("negative request count");
    }
    for (const auto &quest : Array(document, "quests")) {
        QuestEntry entry{.id = Int(quest, "id"), .name = Text(quest, "name", sizeof(QUEST_INFO::name)), .comment = std::nullopt, .reactions = {}};
        if (quest.contains("comment")) {
            entry.comment = Text(quest, "comment", sizeof(QUEST_INFO::comment));
            for (const auto &reaction : Array(quest, "reactions")) {
                auto text = GameText(reaction);
                if (!text || text->size() >= sizeof(QUEST_INFO::reaction[0])) {
                    throw std::runtime_error("request reaction is missing or too long");
                }
                entry.reactions.push_back(std::move(*text));
            }
            if (entry.reactions.size() > QUEST_INFO_COMMENT_MAX) {
                throw std::runtime_error("request has more reactions than its record holds");
            }
        }
        list.quests.push_back(std::move(entry));
    }
    if (list.quests.size() > static_cast<std::size_t>(list.count)) {
        throw std::runtime_error("more requests than the list allocates");
    }
    return list;
}

} // namespace

PORT_OVERRIDE void CQuestManager::LoadCfg(mgCMemory *memory, char *script, int /*length*/) {
    const auto list = native_config::ReadBuffer<QuestList>(script, "quests", ParseQuests);
    if (!list) {
        return;
    }
    num = list->count;
    const u32 size = num * sizeof(QUEST_INFO);
    const u32 blocks = (size & 0xF) != 0 ? (size >> 4) + 1 : size >> 4;
    info = static_cast<QUEST_INFO *>(operator new[](size, memory->Alloc(static_cast<int>(blocks + 2))));
    if (info == nullptr) {
        return;
    }
    QUEST_INFO *entry = info;
    for (const auto &quest : list->quests) {
        entry->id = quest.id;
        std::strcpy(entry->name, quest.name.c_str());
        if (quest.comment) {
            std::strcpy(entry->comment, quest.comment->c_str());
        }
        for (std::size_t index = 0; index < quest.reactions.size(); ++index) {
            std::strcpy(entry->reaction[index], quest.reactions[index].c_str());
        }
        ++entry;
    }
}
