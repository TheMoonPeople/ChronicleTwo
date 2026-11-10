#include <gtest/gtest.h>
#include <nlohmann/json.hpp>

#include <cstddef>
#include <cstring>
#include <memory>
#include <random>
#include <string>

#include "editmap.hpp"
#include "editparts.hpp"
#include "save_json.hpp"
#include "userdata.hpp"

namespace {

using Json = nlohmann::json;

std::unique_ptr<SaveDocument> RandomDocument(unsigned seed) {
    auto         document = std::make_unique<SaveDocument>();
    std::mt19937 random(seed);
    auto        *bytes = reinterpret_cast<unsigned char *>(&document->image);
    for (std::size_t i = 0; i < sizeof(document->image); ++i) {
        bytes[i] = static_cast<unsigned char>(random());
    }
    SAVEDATA_FORMAT &image = document->image;
    // What the file does not hold: the version is always Ver4, the check digits and incomplete flag belong to the
    // retail image, the towns' layouts live beside their records, and photo pointers are bound when the album opens.
    std::memset(image.version, 0, sizeof(image.version));
    std::strcpy(image.version, "dc2Ver4");
    image.check_digit = 0;
    image.check_digit_half = 0;
    image.incomplete = 0;
    for (CEditData &data : image.save_data.edit_data) {
        std::memset(data.place_log, 0, sizeof(data.place_log));
        data.InitPlaceData();
    }
    for (USER_PICTURE_INFO &photo : image.save_data.user_data.invent_data.photo) {
        auto *start = reinterpret_cast<unsigned char *>(&photo) + offsetof(USER_PICTURE_INFO, unk_c) + sizeof(photo.unk_c);
        std::memset(start, 0, sizeof(photo) - (offsetof(USER_PICTURE_INFO, unk_c) + sizeof(photo.unk_c)));
    }
    return document;
}

TownLayout LargeTown(int parts) {
    TownLayout town;
    for (int i = 0; i < parts; ++i) {
        TownPart part;
        part.id = 1 + (i % 120);
        part.state = static_cast<s8>(i % 3);
        part.angle = static_cast<s8>(i % EDIT_ANGLE_MAX);
        part.pos = {static_cast<s16>(i % 300), static_cast<s16>(-i % 7), static_cast<s16>(i / 300)};
        part.color[i % EDIT_DATA_COLOR_MAX] = {static_cast<u8>(i), 0x80, 0x40};
        part.house_no = i % 5 == 0 ? (i / 5) + 1 : 0;
        town.parts.push_back(part);
        if (i > 0) {
            town.place_log.push_back({.parts_no = static_cast<s16>(i), .base_no = static_cast<s16>(i - 1)});
        }
    }
    for (int i = 0; i <= parts / 5; ++i) {
        town.houses.push_back({.npc_no = static_cast<s16>(i % 40)});
    }
    TownGrid grid{
        .num_x = 13, .num_z = 7, .pos = {-160, 0, 320},
                .cells = {}
    };
    for (int i = 0; i < grid.num_x * grid.num_z; ++i) {
        grid.cells.push_back(static_cast<u8>(i % 3 == 0));
    }
    town.grids.push_back(grid);
    return town;
}

bool SameTown(const TownLayout &a, const TownLayout &b) {
    if (a.parts.size() != b.parts.size() || a.houses.size() != b.houses.size() || a.place_log.size() != b.place_log.size() ||
        a.grids.size() != b.grids.size()) {
        return false;
    }
    for (std::size_t i = 0; i < a.parts.size(); ++i) {
        const auto &x = a.parts[i];
        const auto &y = b.parts[i];
        if (x.id != y.id || x.state != y.state || x.angle != y.angle || x.pos != y.pos || x.color != y.color || x.house_no != y.house_no) {
            return false;
        }
    }
    for (std::size_t i = 0; i < a.houses.size(); ++i) {
        if (a.houses[i].npc_no != b.houses[i].npc_no) {
            return false;
        }
    }
    for (std::size_t i = 0; i < a.place_log.size(); ++i) {
        if (a.place_log[i].parts_no != b.place_log[i].parts_no || a.place_log[i].base_no != b.place_log[i].base_no) {
            return false;
        }
    }
    for (std::size_t i = 0; i < a.grids.size(); ++i) {
        if (a.grids[i].num_x != b.grids[i].num_x || a.grids[i].num_z != b.grids[i].num_z || a.grids[i].pos != b.grids[i].pos ||
            a.grids[i].cells != b.grids[i].cells) {
            return false;
        }
    }
    return true;
}

// The document's JSON with a change applied, and without the checksum that the change would break.
std::string Edited(const std::string &text, const auto &edit) {
    Json json = Json::parse(text);
    json.erase("checksum");
    edit(json);
    return json.dump(2);
}

} // namespace

TEST(SaveJson, RandomImagesRoundTripByteForByte) {
    for (unsigned seed : {1U, 2U, 3U}) {
        const auto source = RandomDocument(seed);
        const auto text = SaveJsonWrite(*source);
        auto       read = std::make_unique<SaveDocument>();
        ASSERT_EQ(SaveJsonRead(text, *read), SaveJsonError::None) << seed;
        EXPECT_EQ(std::memcmp(&read->image, &source->image, sizeof(source->image)), 0) << seed;
        EXPECT_EQ(SaveJsonWrite(*read), text) << seed;
    }
}

TEST(SaveJson, FileIsPrettyVersionedAndChecksummed) {
    const auto source = RandomDocument(4);
    const auto text = SaveJsonWrite(*source);
    EXPECT_TRUE(text.starts_with("{\n  \"format\": \"chronicletwo-save\",\n  \"schema_version\": 1,\n"));
    const Json json = Json::parse(text);
    EXPECT_TRUE(json.at("checksum").get<std::string>().starts_with("crc32:"));
    EXPECT_EQ(json.at("header").at("version"), "dc2Ver4");
    EXPECT_EQ(json.at("header").at("unique_counter"), source->image.unique_counter);
    EXPECT_EQ(json.at("save").at("play_time"), source->image.save_data.play_time);
    EXPECT_EQ(json.at("towns").size(), SAVE_EDIT_DATA_MAX);
    EXPECT_FALSE(json.at("save").at("edit_data").at(0).contains("parts"));
}

TEST(SaveJson, HeaderOnlyReadMatchesTheFullRead) {
    const auto source = RandomDocument(5);
    source->image.save_data.game_progress = 12;
    source->image.map_no = 3;
    const auto    text = SaveJsonWrite(*source);
    SAVEDATA_INFO info{};
    ASSERT_EQ(SaveJsonReadHeader(text, info), SaveJsonError::None);
    EXPECT_EQ(info.state, 1);
    EXPECT_EQ(info.unique_counter, source->image.unique_counter);
    EXPECT_EQ(info.play_time, static_cast<u64>(source->image.save_data.play_time));
    EXPECT_EQ(info.progress, 12);
    EXPECT_EQ(info.map_no, 3);
    EXPECT_EQ(info.program_loop_no, static_cast<s16>(source->image.program_loop_no));
    EXPECT_EQ(info.costume_bit, source->image.costume_bit);
    EXPECT_EQ(info.omake_flag, source->image.omake_flag);
    EXPECT_EQ(info.fish_num, source->image.fish_num);
}

TEST(SaveJson, TextFieldsAreReadableAndOddBytesSurvive) {
    auto  document = RandomDocument(6);
    auto &user = document->image.save_data.user_data;
    std::memset(user.robo_data.name, 0, sizeof(user.robo_data.name));
    std::strcpy(user.robo_data.name, "Ridepod");
    CGameDataUsed &fish = user.used_data[0];
    fish.used_type = USED_ITEM_TYPE_FISH;
    std::memset(fish.data.fish.name, 0, sizeof(fish.data.fish.name));
    std::strcpy(fish.data.fish.name, "\x83\x6F\x83\x4F"); // Katakana BA GU in CP932.
    CGameDataUsed &weapon = user.used_data[1];
    weapon.used_type = USED_ITEM_TYPE_WEAPON;
    std::memset(weapon.data.weapon.name, 'x', sizeof(weapon.data.weapon.name)); // No terminator.
    CGameDataUsed &boiled = user.used_data[2];
    boiled.used_type = USED_ITEM_TYPE_BOILED;
    std::memset(boiled.data.boiled.name, 0, sizeof(boiled.data.boiled.name));
    boiled.data.boiled.name[0] = 'a';
    boiled.data.boiled.name[5] = 'z'; // Bytes after the terminator.

    const auto  text = SaveJsonWrite(*document);
    const Json  json = Json::parse(text);
    const auto &used = json.at("save").at("user_data").at("used_data");
    EXPECT_EQ(json.at("save").at("user_data").at("robo_data").at("name"), "Ridepod");
    EXPECT_EQ(used.at(0).at("fish").at("name"), "\xE3\x83\x90\xE3\x82\xB0");
    EXPECT_TRUE(used.at(1).at("weapon").at("name").contains("base64"));
    EXPECT_TRUE(used.at(2).at("boiled").at("name").contains("base64"));
    auto read = std::make_unique<SaveDocument>();
    ASSERT_EQ(SaveJsonRead(text, *read), SaveJsonError::None);
    EXPECT_EQ(std::memcmp(&read->image, &document->image, sizeof(document->image)), 0);

    // Text too long for its field is cut without splitting a character.
    const auto longer = Edited(text, [](Json &value) {
        value["save"]["user_data"]["robo_data"]["name"] = "\xE3\x83\x90\xE3\x82\xB0" + std::string(30, 'q');
    });
    ASSERT_EQ(SaveJsonRead(longer, *read), SaveJsonError::None);
    const auto &name = read->image.save_data.user_data.robo_data.name;
    EXPECT_EQ(std::string(name), "\x83\x6F\x83\x4F" + std::string(sizeof(name) - 5, 'q'));
}

TEST(SaveJson, TownsOfThousandsOfPartsRoundTrip) {
    auto document = RandomDocument(7);
    document->towns[2] = LargeTown(5000);
    document->towns[4] = LargeTown(3);
    const auto text = SaveJsonWrite(*document);
    auto       read = std::make_unique<SaveDocument>();
    ASSERT_EQ(SaveJsonRead(text, *read), SaveJsonError::None);
    for (std::size_t i = 0; i < document->towns.size(); ++i) {
        EXPECT_TRUE(SameTown(read->towns[i], document->towns[i])) << i;
    }
}

TEST(SaveJson, ChangedContentsFailTheChecksumUnlessItIsRemoved) {
    const auto document = RandomDocument(8);
    const auto text = SaveJsonWrite(*document);
    Json       json = Json::parse(text);
    json["save"]["day"] = json["save"]["day"].get<int>() + 1;
    auto read = std::make_unique<SaveDocument>();
    EXPECT_EQ(SaveJsonRead(json.dump(2), *read), SaveJsonError::BadChecksum);
    json.erase("checksum");
    EXPECT_EQ(SaveJsonRead(json.dump(2), *read), SaveJsonError::None);
    EXPECT_EQ(read->image.save_data.day, document->image.save_data.day + 1);
}

TEST(SaveJson, VersionsKeysAndValuesAreChecked) {
    const auto document = RandomDocument(9);
    const auto text = SaveJsonWrite(*document);
    auto       read = std::make_unique<SaveDocument>();
    EXPECT_EQ(SaveJsonRead(Edited(text, [](Json &value) { value["schema_version"] = 2; }), *read), SaveJsonError::UnsupportedVersion);
    EXPECT_EQ(SaveJsonRead(Edited(text, [](Json &value) { value["schema_version"] = 0; }), *read), SaveJsonError::WrongSchema);
    EXPECT_EQ(SaveJsonRead(Edited(text, [](Json &value) { value["format"] = "other"; }), *read), SaveJsonError::WrongSchema);
    EXPECT_EQ(SaveJsonRead(Edited(text, [](Json &value) { value["save"].erase("day"); }), *read), SaveJsonError::WrongSchema);
    EXPECT_EQ(SaveJsonRead(Edited(text, [](Json &value) { value["save"]["now_time"] = 1e300; }), *read), SaveJsonError::BadValue);
    EXPECT_EQ(SaveJsonRead(Edited(text, [](Json &value) { value["save"]["map_no"] = 40000; }), *read), SaveJsonError::BadValue);
    EXPECT_EQ(SaveJsonRead(Edited(text, [](Json &value) { value["save"]["unk_1200"] = "abc"; }), *read), SaveJsonError::BadValue);
    EXPECT_EQ(SaveJsonRead("{\"format\": ", *read), SaveJsonError::NotJson);
    EXPECT_EQ(SaveJsonRead(Edited(text, [](Json &value) {
                               value["extra"] = 1;
                               value["save"]["config"]["future_option"] = true;
                               value.erase("towns");
                               value.erase("pc");
                           }),
                           *read),
              SaveJsonError::None);
    EXPECT_EQ(std::memcmp(&read->image, &document->image, sizeof(document->image)), 0);
}

TEST(SaveJson, RetailRecordsDecodeIntoTheirLayout) {
    auto       record = std::make_unique<CEditData>();
    CEditData &data = *record;
    data.parts[0].id = 7;
    data.parts[0].state = EDIT_PARTS_STATE_PLACED;
    data.parts[0].pos[0] = 12;
    data.parts[0].color[1][2] = 0x80;
    data.parts[2].id = 9;
    data.parts[2].house_no = 3;
    data.house[2].npc_no = 14;
    data.place_log[5] = {.parts_no = 2, .base_no = 0};
    // Two grids: 3x3 cells padded to an even length, then 2x2.
    std::size_t offset = 0;
    for (const auto [num_x, num_z] : {
             std::pair{3, 3},
             std::pair{2, 2}
    }) {
        EditDataGrid header{};
        header.num_x = static_cast<u8>(num_x);
        header.num_z = static_cast<u8>(num_z);
        header.pos[1] = 5;
        std::memcpy(&data.grid[offset], &header, sizeof(header));
        offset += sizeof(header);
        data.grid[offset] = 1;
        offset += static_cast<std::size_t>(num_x * num_z);
        offset += offset & 1;
    }
    const TownLayout town = TownLayoutFromRecord(data);
    ASSERT_EQ(town.parts.size(), 3);
    EXPECT_EQ(town.parts[0].id, 7);
    EXPECT_EQ(town.parts[0].pos[0], 12);
    EXPECT_EQ(town.parts[0].color[1][2], 0x80);
    EXPECT_EQ(town.parts[1].id, 0);
    EXPECT_EQ(town.parts[2].house_no, 3);
    ASSERT_EQ(town.houses.size(), EDIT_DATA_HOUSE_MAX);
    EXPECT_EQ(town.houses[2].npc_no, 14);
    ASSERT_EQ(town.place_log.size(), 1);
    EXPECT_EQ(town.place_log[0].parts_no, 2);
    ASSERT_EQ(town.grids.size(), 2);
    EXPECT_EQ(town.grids[0].cells.size(), 9);
    EXPECT_EQ(town.grids[0].cells[0], 1);
    EXPECT_EQ(town.grids[1].num_x, 2);
    EXPECT_EQ(town.grids[1].cells[0], 1);
    EXPECT_EQ(town.grids[1].pos[1], 5);
}

TEST(SaveJson, LiveLayoutsBelongToTheirRecordUntilItIsCleared) {
    auto record = std::make_unique<CEditData>();
    EXPECT_EQ(PortFindTownLayout(*record), nullptr);
    PortTownLayout(*record).parts.resize(400);
    ASSERT_NE(PortFindTownLayout(*record), nullptr);
    EXPECT_EQ(PortFindTownLayout(*record)->parts.size(), 400);
    record->Initialize();
    EXPECT_EQ(PortFindTownLayout(*record), nullptr);
}
