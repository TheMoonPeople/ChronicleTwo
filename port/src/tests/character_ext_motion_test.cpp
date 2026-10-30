#include <gtest/gtest.h>

#include <cstddef>
#include <cstdint>
#include <cstring>
#include <vector>

#include "character.hpp"
#include "mg_texture.hpp"

namespace {

constexpr std::size_t   kImagesOffset = 0x2C4;
constexpr unsigned char kPoison = 0xA5;

} // namespace

TEST(CharacterExt, DeleteExtMotionClearsImageSlotsAndIgnoresStrideArithmetic) {
    auto *character = new CCharacter2();

    mgIMG_FILE_HEADER archives[CHARA_IMAGE_MAX] = {};
    for (auto &archive : archives) {
        std::memcpy(archive.tag, "IM3", 3);
        archive.num3 = 0;
    }

    for (auto &image : character->images) {
        image = nullptr;
    }
    for (int j = 1; j < CHARA_IMAGE_MAX; j++) {
        character->images[j] = &archives[j];
    }

    auto      *object = reinterpret_cast<unsigned char *>(character);
    const auto images_begin = reinterpret_cast<std::uintptr_t>(&character->images[0]);
    const auto images_end = reinterpret_cast<std::uintptr_t>(&character->images[CHARA_IMAGE_MAX]);

    std::vector<unsigned char *> decoys;
    for (int j = 1; j < CHARA_IMAGE_MAX; j++) {
        unsigned char *slot = object + kImagesOffset + 4 * j;
        for (std::size_t b = 0; b < sizeof(void *); b++) {
            unsigned char *byte = slot + b;
            const auto     address = reinterpret_cast<std::uintptr_t>(byte);
            EXPECT_TRUE(address < images_begin || address >= images_end);
            *byte = kPoison;
            decoys.push_back(byte);
        }
    }

    character->DeleteExtMotion();

    for (int j = 0; j < CHARA_IMAGE_MAX; j++) {
        EXPECT_EQ(character->images[j], nullptr) << "images[" << j << "] was not cleared";
    }
    for (unsigned char *byte : decoys) {
        EXPECT_EQ(*byte, kPoison);
    }

    delete character;
}

TEST(CharacterExt, DeleteExtMotionRetainsBaseArchiveAndClearsExtensionMetadata) {
    auto             *character = new CCharacter2();
    mgIMG_FILE_HEADER base{};
    character->images[0] = &base;
    for (int slot = 1; slot < CHARA_MOTION_SET_MAX; ++slot) {
        character->key_num[slot] = 7;
        character->se_num[slot] = 9;
    }
    character->DeleteExtMotion();
    EXPECT_EQ(character->images[0], &base);
    for (int slot = 1; slot < CHARA_MOTION_SET_MAX; ++slot) {
        EXPECT_EQ(character->motion[slot].frame_info, nullptr);
        EXPECT_EQ(character->shadow_motion[slot].frame_info, nullptr);
        EXPECT_EQ(character->key_list[slot], nullptr);
        EXPECT_EQ(character->seq_list[slot], nullptr);
        EXPECT_EQ(character->se_list[slot], nullptr);
        EXPECT_EQ(character->key_num[slot], 0);
        EXPECT_EQ(character->se_num[slot], 0);
    }
    character->images[0] = nullptr;
    delete character;
}
