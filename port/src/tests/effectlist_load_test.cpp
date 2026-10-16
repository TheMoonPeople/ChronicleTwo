#include "common.h"

#include <gtest/gtest.h>
#include <nlohmann/json.hpp>

#include <array>
#include <chrono>
#include <filesystem>
#include <fstream>

#include "dataread.hpp"
#include "dataread_port.hpp"
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
    fs::create_directories(base / "port_data/effect/map.efp/nested");
    std::ofstream(base / "port_data/effect/map.efp/pack.json") << R"({"schema_version":1,"kind":"asset_directory"})";
    const nlohmann::json texture = {
        {"schema_version", 3                                                                                         },
        {"groups",         {0}                                                                                       },
        {"entries",        {{{"name", "effect_native"}, {"pictures", {{{"canvas", {{"width", 2}, {"height", 2}}}}}}}}}
    };
    std::ofstream(base / "port_data/effect/map.efp/spark.json") << texture.dump(2);
    std::ofstream(base / "port_data/effect/map.efp/unrelated.json") << nlohmann::json({
                                                                                          {"schema_version", 1             },
                                                                                          {"kind",           "sound_bundle"}
    })
                                                                           .dump(2);
    auto nested = texture;
    nested["entries"][0]["name"] = "nested_texture";
    std::ofstream(base / "port_data/effect/map.efp/nested/other.json") << nested.dump(2);
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
    alignas(16) std::array<u_long128, 128> pack{};
    char                                   path[] = "effect/map.efp";
    EXPECT_GT(LoadFile(path, pack.data(), nullptr), 0);
    CEffectList list;
    list.LoadEFPFile(path, reinterpret_cast<u_int *>(pack.data()), 0, &memory);
    EXPECT_EQ(list.effect_num, 0);
    char texture_name[] = "effect_native";
    char nested_name[] = "nested_texture";
    EXPECT_NE(mgTexManager.GetTexture(texture_name, 0), nullptr);
    EXPECT_EQ(mgTexManager.GetTexture(nested_name, 0), nullptr);
    mgTexManager.Initialize(0x1000, -1);
    DataReadIndex(previous);
    std::error_code error;
    fs::remove_all(base, error);
}
