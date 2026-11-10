#include <gtest/gtest.h>
#include <kazarov/types.hpp>

#include <cstddef>
#include <cstdint>
#include <type_traits>

#include "menucommon.hpp"
#include "platform/arena.hpp"
#include "platform/memory.hpp"

namespace {

static_assert(std::is_same_v<uptr, kz::uptr>);
static_assert(std::is_same_v<sptr, kz::sptr>);
static_assert(std::is_same_v<std::size_t, kz::size_t>);
static_assert(sizeof(uptr) == sizeof(void *));
static_assert(sizeof(sptr) == sizeof(void *));
static_assert(sizeof(u8) == 1 && sizeof(u16) == 2 && sizeof(u32) == 4 && sizeof(u64) == 8);
static_assert(sizeof(s8) == 1 && sizeof(s16) == 2 && sizeof(s32) == 4 && sizeof(s64) == 8);
static_assert(std::is_same_v<s8, std::int8_t>);
static_assert(sizeof(u_long128) == 16);

constexpr std::size_t kBytes = 64 * 1024;

unsigned char *HighBlock() {
    static const char owner = 0;
    return ArenaBlock(&owner, kBytes);
}

uptr AddressValue(const void *pointer) {
    return reinterpret_cast<uptr>(pointer);
}

struct Holder {
    uptr address;
};

unsigned char *PointerValue(const Holder &holder) {
    return reinterpret_cast<unsigned char *>(holder.address);
}

} // namespace

TEST(Uptr, IsPointerWide) {
    EXPECT_EQ(sizeof(uptr), sizeof(void *));
    EXPECT_EQ(sizeof(sptr), sizeof(void *));
    EXPECT_TRUE(std::is_unsigned<uptr>::value);
    EXPECT_TRUE(std::is_signed<sptr>::value);
}

TEST(Uptr, AddressAbove4GiBRoundTripsThroughOffset) {
    unsigned char *base = HighBlock();
    if (!IsAbove4GiB(base)) {
        GTEST_SKIP() << "the arena has no block above 4 GiB";
    }

    const uptr offset = 0x1234;
    auto      *moved = reinterpret_cast<unsigned char *>(reinterpret_cast<uptr>(base) + offset);

    EXPECT_EQ(moved, base + offset);
    EXPECT_EQ(reinterpret_cast<uptr>(moved) >> 32, reinterpret_cast<uptr>(base) >> 32);
}

TEST(Uptr, MenuCalcBufAlignmentKeepsHighAddress) {
    unsigned char *base = HighBlock();
    if (!IsAbove4GiB(base)) {
        GTEST_SKIP() << "the arena has no block above 4 GiB";
    }

    for (uptr misalignment : {uptr{0x10}, uptr{0x40}}) {
        SCOPED_TRACE(misalignment);
        auto      *input = reinterpret_cast<u_long128 *>(base + misalignment);
        u_long128 *aligned = MenuCalcBufAlignment(input);

        const uptr in = reinterpret_cast<uptr>(input);
        const uptr out = reinterpret_cast<uptr>(aligned);
        EXPECT_GE(out, in);
        EXPECT_LE(out - in, 64u);
        EXPECT_EQ(out % 64, 0u);
        EXPECT_NE(out >> 32, 0u);
    }
}

TEST(Uptr, FieldAndReturnKeepHighAddress) {
    unsigned char *base = HighBlock();
    if (!IsAbove4GiB(base)) {
        GTEST_SKIP() << "the arena has no block above 4 GiB";
    }

    unsigned char *target = base + 0x80;
    Holder         holder{AddressValue(target)};

    EXPECT_EQ(PointerValue(holder), target);
    EXPECT_EQ(holder.address >> 32, reinterpret_cast<uptr>(base) >> 32);
}
