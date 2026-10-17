#include <gtest/gtest.h>

#include <cstdint>
#include <cstdlib>
#include <filesystem>
#include <optional>
#include <string>
#include <vector>

#include "dataread.hpp"
#include "dataread_port.hpp"
#include "dungeon_read_buffer.hpp"
#include "mapselect.hpp"
#include "platform/paths.hpp"
#include "platform/vfs.hpp"
#include "port_memory_budget.hpp"

namespace fs = std::filesystem;

#ifndef CT_PROJECT_SOURCE_DIR
#define CT_PROJECT_SOURCE_DIR "."
#endif

namespace {

std::optional<fs::path> CorpusDataRoot() {
    std::error_code error;
    if (const char *selected = std::getenv("DC2_DATA")) {
        const fs::path data(selected);
        if (fs::is_directory(data, error)) {
            return data;
        }
    }
    const fs::path repo_run = fs::path(CT_PROJECT_SOURCE_DIR) / "port" / "run";
    if (fs::is_regular_file(repo_run / "data.json", error)) {
        return repo_run;
    }
    if (fs::is_regular_file("port/run/data.json")) {
        return fs::absolute("port/run");
    }
    const fs::path run = PathsExecutable().parent_path().parent_path().parent_path() / "port" / "run";
    if (fs::is_regular_file(run / "data.json", error)) {
        return run;
    }
    if (fs::is_directory(run / "data", error)) {
        return run / "data";
    }
    return std::nullopt;
}

size_t AlignStagingBytes(size_t bytes) {
    size_t size = bytes;
    const size_t rest = size % 64;
    if (rest != 0) {
        size += 64 - rest;
    }
    return size;
}

bool VfsFileSize(const char *path, size_t &bytes) {
    const auto id = vfs::Find(vfs::Base(), path);
    if (!id) {
        return false;
    }
    std::vector<std::uint8_t> data;
    if (!vfs::Read(id, data)) {
        return false;
    }
    bytes = data.size();
    return true;
}

size_t StagingChainBytes(const char *map_name, bool load_sky) {
    char map_path[0x40];
    GetMapPath(map_path, const_cast<char *>(map_name));
    char dir[0x40];
    char file_name[0x20];
    DivPathName(map_path, dir, file_name);

    char path[0x80];
    size_t total = 0;

    auto add = [&](const char *suffix) {
        sprintf(path, "%s%s%s", dir, file_name, suffix);
        size_t bytes = 0;
        if (!VfsFileSize(path, bytes)) {
            return false;
        }
        total += AlignStagingBytes(bytes);
        return true;
    };

    if (!add(".map") || !add(".cfg") || !add(".mpk")) {
        return SIZE_MAX;
    }
    if (load_sky) {
        sprintf(path, "%s%s.sky", dir, file_name);
        size_t sky_bytes = 0;
        if (!VfsFileSize(path, sky_bytes)) {
            if (!VfsFileSize("map/def.sky", sky_bytes)) {
                return total;
            }
        }
        total += AlignStagingBytes(sky_bytes);
    }
    return total;
}

} // namespace

TEST(DungeonMapStaging, ReadBufferLargerThanRetail) {
    EXPECT_GT(PORT_DNG_BUFF_READ_QUADWORDS, RETAIL_DNG_BUFF_READ_QUADWORDS);
    EXPECT_GE(PORT_DNG_BUFF_READ_QUADWORDS * 16ull,
              static_cast<unsigned long long>(RETAIL_DNG_BUFF_READ_QUADWORDS) * 16ull);
}

TEST(DungeonMapStaging, AssertCursorGuardsBuffer) {
    alignas(16) u_long128 storage[16]{};
    PortSetDungeonReadBuffer(storage, static_cast<int>(sizeof(storage) / 16));
    PortAssertDungeonReadCursor(storage);
    EXPECT_FALSE(PortDungeonReadBufferContains(storage + 16));
}

TEST(DungeonMapStaging, FloorMapsFitStagingBuffer) {
    const auto root = CorpusDataRoot();
    if (!root) {
        GTEST_SKIP() << "Set DC2_DATA or extract data under port/run/data";
    }
    DataReadIndex(*root);

    static const char *kMaps[] = {
        "d01f01", "d02f01", "d03f01", "d04f01", "d04f01s", "d05f01", "d06f01", "d07f01",
    };
    const size_t cap = static_cast<size_t>(PORT_DNG_BUFF_READ_QUADWORDS) * 16;

    for (const char *name : kMaps) {
        if (SearchMapNo(const_cast<char *>(name)) < 0) {
            continue;
        }
        const size_t need = StagingChainBytes(name, true);
        if (need == SIZE_MAX) {
            ADD_FAILURE() << name << ": missing map chain files in data index";
            continue;
        }
        EXPECT_LE(need, cap) << name << " staging " << need << " bytes exceeds " << cap;
    }
}
