// clang-format off
#include "platform/native_config.hpp"
// clang-format on

#include "common.h"

#include <cstring>
#include <limits>

#include "mainloop.hpp"
#include "mg_memory.hpp"
#include "quest.hpp"
#include "savedata.hpp"
#include "text/bounded.hpp"

/**
 *
 * Returns the saved quest progress when save data is available.
 *
 */
static CQuestData *GetQuestData() {
    CSaveData *save_data = GetSaveData();
    return save_data != nullptr ? &save_data->quest_data : nullptr;
}

void CQuestManager::Initialize() {
    num = 0;
    info = nullptr;
}

QUEST_INFO *CQuestManager::GetQuestInfo(int id) {
    for (int index = 0; index < num; ++index) {
        if (info[index].id == id) {
            return &info[index];
        }
    }

    return nullptr;
}

void CQuestData::Initialize() {
    memset(this, 0, sizeof(*this));
}

void CQuestData::SetQuestFlag(int index, int value) {
    if (index < 0 || index >= QUEST_PLAY_DATA_MAX) {
        return;
    }

    play[index].accepted = value;
}

void CQuestData::QuestClear(int index) {
    if (index < 0 || index >= QUEST_PLAY_DATA_MAX) {
        return;
    }

    play[index].cleared = 1;
}

QUEST_PLAY_DATA *CQuestData::GetPlayQuestData(int index) {
    if (index < 0 || index >= QUEST_PLAY_DATA_MAX) {
        return nullptr;
    }

    return &play[index];
}

void QuestRequestSetFlag(int id, int flag) {
    CQuestData *quest_data = GetQuestData();

    if (quest_data != nullptr) {
        quest_data->SetQuestFlag(id, flag);
    }
}

void QuestRequestClear(int id, int unused) {
    CQuestData *quest_data = GetQuestData();

    if (quest_data != nullptr) {
        quest_data->QuestClear(id);
    }
}

int GetQuestRequestStatus(int id) {
    CQuestData *quest_data = GetQuestData();

    if (quest_data == nullptr) {
        return QUEST_REQUEST_STATUS_INVALID;
    }

    QUEST_PLAY_DATA *progress = quest_data->GetPlayQuestData(id);

    if (progress == nullptr) {
        return QUEST_REQUEST_STATUS_INVALID;
    }

    if (progress->cleared != 0) {
        return QUEST_REQUEST_STATUS_CLEARED;
    }

    return progress->accepted != 0;
}

int CMonsterBook::CountKill(int monster, int amount) {
    if (monster < 0) {
        return 0;
    }

    if (monster >= MONSTER_BOOK_ENTRY_MAX) {
        return 0;
    }

    entry[monster].kill_count += (u16) amount;

    if (entry[monster].kill_count > 60000) {
        entry[monster].kill_count = 60000;
    }

    return entry[monster].kill_count;
}

// clang-format off
// nlohmann must precede the game headers, whose macros it would otherwise see.
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
    if (static_cast<std::size_t>(list.count) > std::numeric_limits<u32>::max() / sizeof(QUEST_INFO)) {
        throw std::runtime_error("request count exceeds the request record allocation");
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

void CQuestManager::LoadCfg(mgCMemory *memory, char *script, int /*length*/) {
    const auto list = native_config::ReadBuffer<QuestList>(script, "quests", ParseQuests);
    if (!list) {
        return;
    }
    if (list->count == 0) {
        Initialize();
        return;
    }
    const std::size_t size = static_cast<std::size_t>(list->count) * sizeof(QUEST_INFO);
    const std::size_t blocks = (size + 15) / 16;
    if (memory == nullptr || memory->lock != 0 ||
        blocks > static_cast<std::size_t>(std::numeric_limits<int>::max() - 2) ||
        memory->stGetRest() <= 0 || blocks + 2 >= static_cast<std::size_t>(memory->stGetRest())) {
        return;
    }
    auto *entries = dc2::memory::NewArray<QUEST_INFO>(*memory, static_cast<std::size_t>(list->count));
    if (entries == nullptr) {
        return;
    }
    for (int index = 0; index < list->count; ++index) {
        entries[index] = {};
        entries[index].id = -1;
    }
    num = list->count;
    info = entries;
    QUEST_INFO *entry = info;
    for (const auto &quest : list->quests) {
        entry->id = quest.id;
        dc2::text::Copy(entry->name, dc2::text::View(quest.name.c_str()));
        if (quest.comment) {
            dc2::text::Copy(entry->comment, dc2::text::View(quest.comment->c_str()));
        }
        for (std::size_t index = 0; index < quest.reactions.size(); ++index) {
            dc2::text::Copy(entry->reaction[index], dc2::text::View(quest.reactions[index].c_str()));
        }
        ++entry;
    }
}
