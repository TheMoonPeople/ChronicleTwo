#include "common.h"

#include <gtest/gtest.h>
#include <nlohmann/json.hpp>

#include <array>
#include <chrono>
#include <filesystem>
#include <fstream>
#include <limits>
#include <span>

#include "assets/data_registry.hpp"
#include "dataread.hpp"
#include "effectlist.hpp"
#include "mg_memory.hpp"
#include "mglib.hpp"
#include "platform/datapacks.hpp"
#include "platform/paths.hpp"
#include "platform/texture_catalog.hpp"

namespace {
/**
 * Retains the global texture table storage after this fixture has completed.
 */
alignas(16) std::array<u_long128, 1024> texture_storage;
} // namespace

TEST(EffectListLoad, EntersDirectTextureDocumentsWithoutRetailImageMembers) {
    namespace fs = std::filesystem;
    const auto base = fs::temp_directory_path() / ("effectlist_native_" + std::to_string(std::chrono::steady_clock::now().time_since_epoch().count()));
    const auto previous = PathsDataRoot();
    fs::create_directories(base / "data/effect");
    fs::create_directories(base / "data/effect/map.efp/nested");
    std::ofstream(base / "data/effect/map.efp/pack.json")
        << R"({"schema_version":1,"kind":"asset_directory","texture_members":[{"name":"mist.json","path":"textures/effect/mist-variant.json"}]})";
    const nlohmann::json texture = {
        {"schema_version", 3                                                                                         },
        {"groups",         {0}                                                                                       },
        {"entries",        {{{"name", "effect_native"}, {"pictures", {{{"canvas", {{"width", 2}, {"height", 2}}}}}}}}}
    };
    std::ofstream(base / "data/effect/map.efp/spark.json") << texture.dump(2);
    fs::create_directories(base / "data/textures/effect");
    auto relocated = texture;
    relocated["entries"][0]["name"] = "effect_relocated";
    std::ofstream(base / "data/textures/effect/mist-variant.json") << relocated.dump(2);
    std::ofstream(base / "data/effect/map.efp/unrelated.json") << nlohmann::json({
                                                                                     {"schema_version", 1             },
                                                                                     {"kind",           "sound_bundle"}
    })
                                                                      .dump(2);
    auto nested = texture;
    nested["entries"][0]["name"] = "nested_texture";
    std::ofstream(base / "data/effect/map.efp/nested/other.json") << nested.dump(2);
    DataReadIndex(base / "data");
    mgCMemory textures;
    textures.SetHeapMem(texture_storage.data(), texture_storage.size());
    textures.StartStackMode(MG_STACK_MODE_FIT, texture_storage.size());
    mgTexManager.SetTableBuffer(16, 4, &textures);
    mgTexManager.Initialize(0x1000, -1);
    alignas(16) std::array<u_long128, 256> work{};
    mgCMemory                              memory;
    memory.SetHeapMem(work.data(), work.size());
    memory.StartStackMode(MG_STACK_MODE_FIT, work.size());
    char path[] = "effect/map.efp";
    auto directory = dc2::io::ReadResourceFile(path);
    ASSERT_TRUE(directory);
    CEffectList list;
    list.LoadEFPFile(directory, 0, &memory);
    EXPECT_EQ(list.effect_num, 0);
    char texture_name[] = "effect_native";
    char relocated_name[] = "effect_relocated";
    char nested_name[] = "nested_texture";
    EXPECT_NE(mgTexManager.GetTexture(texture_name, 0), nullptr);
    EXPECT_NE(mgTexManager.GetTexture(relocated_name, 0), nullptr);
    EXPECT_EQ(mgTexManager.GetTexture(nested_name, 0), nullptr);
    mgTexManager.Initialize(0x1000, -1);
    DataReadIndex(previous);
    std::error_code error;
    fs::remove_all(base, error);
}

TEST(EffectListLoad, RejectsEmitterScriptsWhoseParticlePoolExceedsTheArena) {
    namespace fs = std::filesystem;
    const auto base = fs::temp_directory_path() / ("effectlist_overflow_" + std::to_string(std::chrono::steady_clock::now().time_since_epoch().count()));
    const auto previous = PathsDataRoot();
    fs::create_directories(base / "data/effect/overflow.efp");
    std::ofstream(base / "data/effect/overflow.efp/pack.json") << R"({"schema_version":1,"kind":"asset_directory"})";
    nlohmann::json arguments = nlohmann::json::array();
    arguments.push_back({
        {"type",  "int"                          },
        {"value", std::numeric_limits<int>::max()}
    });
    arguments.push_back({
        {"type",  "int"},
        {"value", 8    }
    });
    const nlohmann::json script = {
        {"commands", nlohmann::json::array({{{"command", "BUFFER_SIZE"}, {"args", arguments}}})}
    };
    std::ofstream(base / "data/effect/overflow.efp/huge.em") << script.dump();
    DataReadIndex(base / "data");

    alignas(16) std::array<u_long128, 256> storage{};
    mgCMemory                              memory;
    memory.SetHeapMem(storage.data(), static_cast<int>(storage.size()));
    ASSERT_NE(memory.StartStackMode(MG_STACK_MODE_FIT, static_cast<int>(storage.size())), nullptr);
    char path[] = "effect/overflow.efp";
    auto directory = dc2::io::ReadResourceFile(path);
    ASSERT_TRUE(directory);
    const int   before = memory.stack_used;
    CEffectList list;
    list.LoadEFPFile(directory, 0, &memory);
    EXPECT_EQ(list.effect_num, 0);
    EXPECT_EQ(list.managers, nullptr);
    EXPECT_EQ(memory.stack_used, before);

    DataReadIndex(previous);
    std::error_code error;
    fs::remove_all(base, error);
}
