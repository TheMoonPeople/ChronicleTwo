#include "common.h"

#include <gtest/gtest.h>

#include <algorithm>
#include <array>

#include "dng_main.hpp"
#include "mg_memory.hpp"

// dng_main.hpp declares six stacks; the port's definition holds the seventh, retail's BuffTempData.
extern mgCMemory BaseCharacter[7];

TEST(DngMain, BaseCharacterHoldsTheTempStack) {
    static u_long128 buffer[16];

    EXPECT_EQ(sizeof(BaseCharacter), 7 * sizeof(mgCMemory));
    EXPECT_EQ(BaseCharacter[6].name[0], '\0');

    BaseCharacter[6].stSetBuffer(buffer, 16);
    EXPECT_NE(BaseCharacter[6].Alloc(4), nullptr);
}

TEST(DngMain, ReadStorageCanBeRefilledAfterTheMenuReturnsIt) {
    std::array<u_long128, 256> storage{};
    mgCMemory                  main;
    main.stSetBuffer(storage.data(), static_cast<int>(storage.size()));

    struct Restore {
        mgCMemory *main = MainBuffer__2;
        u_long128 *read = BuffReadData;

        ~Restore() {
            MainBuffer__2 = main;
            BuffReadData = read;
        }
    } restore;

    MainBuffer__2 = &main;
    BuffReadData = main.stAlloc64(128);
    ASSERT_NE(BuffReadData, nullptr);

    // The dungeon lends its read buffer to the main menu, which clears what it used when it closes.
    mgCMemory lent;
    lent.stSetChildBuffer(main, BuffReadData, 128);
    const auto lent_bytes = dc2::memory::RemainingBytes(lent);
    mgCMemory  menu;
    ASSERT_TRUE(menu.stShareBuffer(
        lent, std::span(reinterpret_cast<u_long128 *>(lent_bytes.data()), lent_bytes.size() / sizeof(u_long128))));
    ASSERT_NE(menu.Alloc(32), nullptr);
    menu.stClearUsed();

    // The floor the menu moves to then loads its sound banks into the buffer from the start.
    const auto read = dc2::dungeon::ReadStorage();
    ASSERT_EQ(read.size(), 128 * sizeof(u_long128));
    std::ranges::fill(read, u8{0x5A});
    EXPECT_EQ(read.front(), 0x5A);
}
