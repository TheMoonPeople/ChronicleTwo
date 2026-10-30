#include "common.h"

#include <format>
#include <string>

#include "event_func.hpp"
#include "event_text.hpp"
#include "gamedata.hpp"
#include "nd_meswin.hpp"
#include "stubs/event_func.hpp"
#include "userdata.hpp"

namespace {

/**
 *
 * Retail fishing-tournament external, which the native one delegates every other command to.
 *
 */
dc2::script::RunFunction retail_fishing_tournament = nullptr;

/**
 *
 * Gives a tournament record's rank label: a full-width number from one to ten and a comma.
 *
 */
std::string RankLabel(int shown) {
    if (shown == 9) {
        return "\x82\x50\x82\x4F\x81\x41";
    }
    return std::string("\x81\x40\x82") + static_cast<char>(0x50 + shown) + "\x81\x41";
}

/**
 *
 * Opens the tournament records window, or hands any other tournament command to retail.
 *
 */
int FishingTournament(dc2::script::RunArguments args, int argc) {
    if (argc < 1 || dc2::script::RunInteger(args) != EVENT_GET_FISHING_RECORDS) {
        return retail_fishing_tournament != nullptr ? retail_fishing_tournament(args, argc) : 0;
    }

    CFishingTournament *tournament = GetFishTournament();
    if (tournament == nullptr) {
        return 0;
    }

    // Retail joins up to ten 50-byte rows in a 512-byte buffer; the rows are joined as text here.
    std::string text;
    int         shown = 0;
    for (int i = 0; i < 10; ++i) {
        const FISH_TOURNAMENT_ENTRY *entry = tournament->GetRecord(i);
        const char                  *name = entry != nullptr ? GetItemMessage(entry->item_no) : nullptr;
        if (name == nullptr) {
            continue;
        }

        std::string row = RankLabel(shown++) + name;
        // Names are padded with full-width spaces to line the sizes up.
        for (int pad = (0x16 - static_cast<int>(std::string_view(name).size())) / 2; pad > 0; --pad) {
            row += "\x81\x40";
        }
        row += std::format("{:4.1f}cm\x81\x40{:5}g", static_cast<float>(entry->size) / 10.0f, entry->weight);
        text += row;
        if (i < 9) {
            text += '\n';
        }
    }

    ClsMes *mes = argc >= 2 ? GetMes(dc2::script::RunInteger(args + 1)) : nullptr;
    if (mes == nullptr) {
        return 0;
    }
    if (shown > 0) {
        mes->MakeMesWin(text.data(), 0, 1);
    }
    return 1;
}

} // namespace

void ReplaceEventTextExternals(std::span<dc2::script::RunFunction> table) {
    if (static_cast<std::size_t>(EVENT_EXT_GET_FISHINGTOURNAMENT_ETC) >= table.size()) {
        return;
    }
    auto &slot = table[EVENT_EXT_GET_FISHINGTOURNAMENT_ETC];
    if (slot != FishingTournament) {
        retail_fishing_tournament = slot;
        slot = FishingTournament;
    }
}
