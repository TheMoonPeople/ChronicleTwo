#include "record_bridges.hpp"

/**
 * Builds the tournament prize groups and rank records in their owning arena.
 */
void PortApplyFishPrizes(const NativeFishPrizes &prizes, mgCMemory *pool) {
    FishTournamentGoods = nullptr;
    FishTournamentGoodsNum = 0;
    fish_prize_buildstack = pool;
    if (pool == nullptr || prizes.count < 0) {
        return;
    }
    FishTournamentGoods = dc2::memory::NewArray<fish_prize_group>(*pool, static_cast<std::size_t>(prizes.count));
    if (FishTournamentGoods == nullptr) {
        return;
    }
    std::fill_n(FishTournamentGoods, prizes.count, fish_prize_group{});
    for (const auto &group : prizes.groups) {
        if (FishTournamentGoodsNum >= prizes.count || group.prize_count < 0) {
            break;
        }
        auto &destination = FishTournamentGoods[FishTournamentGoodsNum++];
        for (std::size_t index = 0; index < group.rates.size(); ++index) {
            destination.rate[index] = group.rates[index];
        }
        destination.prizes = dc2::memory::NewArray<fish_prize_record>(*pool, static_cast<std::size_t>(group.prize_count));
        if (destination.prizes == nullptr) {
            destination.prize_count = 0;
            continue;
        }
        std::fill_n(destination.prizes, group.prize_count, fish_prize_record{});
        destination.prize_count = group.prize_count;
        std::size_t written = 0;
        for (const auto &prize : group.prizes) {
            if (written >= static_cast<std::size_t>(destination.prize_count)) {
                break;
            }
            auto &record = destination.prizes[written++];
            record.rate = prize.rate;
            for (std::size_t rank = 0; rank < prize.ranks.size(); ++rank) {
                record.rank[rank].item_no = prize.ranks[rank][0];
                record.rank[rank].num = prize.ranks[rank][1];
            }
        }
    }
}
