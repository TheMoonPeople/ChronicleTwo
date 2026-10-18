#include <gtest/gtest.h>

#include <array>
#include <chrono>
#include <cstring>
#include <filesystem>
#include <fstream>

#include "dataread.hpp"
#include "dataread_port.hpp"
#include "platform/datapacks.hpp"

namespace {
class NativeAssetsTest : public testing::Test {
protected:
    // Packs resolve to canonical paths, so the root must not keep a short (8.3) name from TEMP.
    std::filesystem::path root = std::filesystem::weakly_canonical(std::filesystem::temp_directory_path()) /
                                 ("ct_native_assets_" + std::to_string(std::chrono::steady_clock::now().time_since_epoch().count()));

    static void Write(const std::filesystem::path &path, const char *text) {
        std::filesystem::create_directories(path.parent_path());
        std::ofstream(path) << text;
    }

    void TearDown() override {
        datapacks::Clear();
        std::error_code error;
        std::filesystem::remove_all(root, error);
    }
};
} // namespace

TEST_F(NativeAssetsTest, DirectAssetCandidatesPreservePriorityAndBaseFallback) {
    Write(root / "datapacks/datapacks.json", R"({"schema_version":1,"load_order":["low","high"]})");
    for (const char *name : {"sound/sample.wav", "chara/character.gltf", "menu/options.json", "movie/opening.mp4"}) {
        Write(root / "data" / name, "base");
        Write(root / "datapacks/low" / name, "low");
        Write(root / "datapacks/high" / name, "high");
    }
    datapacks::Load(root / "data");
    for (const char *name : {"sound/sample.wav", "chara/character.gltf", "menu/options.json", "movie/opening.mp4"}) {
        const auto paths = datapacks::Candidates(name);
        ASSERT_EQ(paths.size(), 3);
        EXPECT_EQ(vfs::HostPath(paths[0]), root / "datapacks/high" / name);
        EXPECT_EQ(vfs::HostPath(paths[1]), root / "datapacks/low" / name);
        EXPECT_EQ(vfs::HostPath(paths[2]), root / "data" / name);
    }
    EXPECT_TRUE(datapacks::Candidates("../outside.wav").empty());
}

TEST_F(NativeAssetsTest, LoadsActualJsonAndPreservesItsByteBoundsAcrossCopies) {
    std::filesystem::create_directories(root / "data");
    constexpr char json[] = R"({"schema_version":1,"commands":[]})";
    Write(root / "data/menu/positions.json", json);
    DataReadIndex(root / "data");
    alignas(16) std::array<unsigned char, 2048> source{};
    alignas(16) std::array<unsigned char, 2048> copy{};
    char                                        path[] = "menu/positions.json";
    int                                         size = 0;
    ASSERT_TRUE(LoadFile(path, source.data(), &size));
    EXPECT_EQ(size, sizeof(json) - 1);
    EXPECT_EQ(std::memcmp(source.data(), json, sizeof(json) - 1), 0);
    EXPECT_EQ(DataReadBufferPath(source.data()), "menu/positions.json");
    EXPECT_EQ(DataReadBufferSize(source.data()), sizeof(json) - 1);
    std::memcpy(copy.data(), source.data(), source.size());
    DataReadCopyBuffer(source.data(), copy.data(), source.size());
    EXPECT_EQ(DataReadBufferSize(copy.data()), sizeof(json) - 1);
    EXPECT_FALSE(DataReadFind("menu/positions.cfg"));
}
