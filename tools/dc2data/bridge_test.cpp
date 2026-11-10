#include "kazarov_bridge/rust/lib.h"
#include "rust/cxx.h"

#include <algorithm>
#include <chrono>
#include <cstdint>
#include <filesystem>
#include <fstream>
#include <stdexcept>
#include <string>
#include <vector>

namespace {
namespace fs = std::filesystem;

void Require(bool value, const char *message) {
    if (!value) {
        throw std::runtime_error(message);
    }
}

void Write(const fs::path &path, const std::vector<std::uint8_t> &bytes) {
    std::ofstream file(path, std::ios::binary);
    file.write(reinterpret_cast<const char *>(bytes.data()), static_cast<std::streamsize>(bytes.size()));
    Require(file.good(), "fixture write failed");
}

std::string Utf8(const fs::path &path) {
    const auto bytes = path.u8string();
    return {reinterpret_cast<const char *>(bytes.data()), bytes.size()};
}
} // namespace

int main() {
    const std::string unicode = "Récit 東京";
    Require(std::string(kazarov::bridge_smoke(unicode)) == unicode, "Unicode bridge mismatch");
    bool caught = false;
    try {
        (void) kazarov::bridge_smoke("error");
    } catch (const rust::Error &error) {
        caught = std::string(error.what()) == "bridge smoke error";
    }
    Require(caught, "Rust error did not cross bridge");

    // The bridge must execute the real Rust archive/converter/publisher path on
    // Windows' C++ main thread; string-only calls cannot catch stack overflows.
    const auto     nonce = std::chrono::steady_clock::now().time_since_epoch().count();
    const fs::path root = fs::current_path() / ("dc2data-bridge-" + std::to_string(nonce));
    const fs::path disc = root / "disc";
    fs::create_directories(disc / "MOVIE");
    std::vector<std::uint8_t> hd4(33);
    hd4[0] = 24; // name offset
    hd4[4] = 4;  // one four-byte DATA.DAT payload
    hd4[12] = 32;
    std::copy_n(reinterpret_cast<const std::uint8_t *>("FOO.BIN\0\0"), 9, hd4.data() + 24);
    Write(disc / "DATA.HD4", hd4);
    Write(disc / "DATA.DAT", {'D', 'A', 'T', 'A'});
    std::vector<std::uint8_t> hd3(42);
    hd3[0] = 32;
    hd3[4] = 3;
    hd3[12] = 1;
    std::copy_n(reinterpret_cast<const std::uint8_t *>("BGM_A.STR\0"), 10, hd3.data() + 32);
    Write(disc / "SOUND.HD3", hd3);
    Write(disc / "SOUND.DAT", {'S', 'N', 'D'});

    const fs::path data = root / "run/data";
    const auto     report = kazarov::extract(Utf8(disc), Utf8(data), 2);
    Require(report.files == 1 && report.bytes == 4 && report.pngs == 0, "extract report mismatch");
    Require(fs::is_regular_file(root / "run/data.zip") && fs::is_regular_file(root / "run/data.json"),
            "published archive missing");
    Require(!fs::exists(data) && !fs::exists(root / "run/port_data"), "directory layout published");
    {
        const auto archive = kazarov::open_archive(Utf8(root / "run/data.zip"));
        bool       found = false;
        bool       gameplay_found = false;
        for (std::size_t index = 0; index < kazarov::archive_entry_count(*archive); ++index) {
            const std::string name(kazarov::archive_entry_name(*archive, index));
            Require(name != "catalog.json" && name != "manifest.json", "obsolete asset index published");
            Require(kazarov::archive_entry_data_offset(*archive, index) % 64 == 0, "entry data is not aligned");
            if (name == "foo.bin") {
                Require(kazarov::archive_entry_size(*archive, index) == 4 && !kazarov::archive_entry_stored(*archive, index),
                        "extracted entry metadata mismatch");
                std::vector<std::uint8_t> bytes(4);
                kazarov::archive_read_entry(*archive, index, rust::Slice<std::uint8_t>(bytes.data(), bytes.size()));
                Require(bytes == std::vector<std::uint8_t>{'D', 'A', 'T', 'A'}, "extracted entry contents mismatch");
                found = true;
            }
            if (name == "gameplay/menu/cfg7/wepdat.cfg.json") {
                std::vector<std::uint8_t> bytes(kazarov::archive_entry_size(*archive, index));
                kazarov::archive_read_entry(*archive, index, rust::Slice<std::uint8_t>(bytes.data(), bytes.size()));
                const std::string document(bytes.begin(), bytes.end());
                Require(document.find("\"schema_version\":2") != std::string::npos,
                        "tracked gameplay document missing its semantic schema");
                Require(document.find('\n') == std::string::npos,
                        "archived gameplay document was not compacted");
                gameplay_found = true;
            }
        }
        Require(found, "extracted file missing");
        Require(gameplay_found, "tracked gameplay document missing from extraction");
        Require(std::string(kazarov::archive_path(*archive)) == Utf8(root / "run/data.zip"), "archive path mismatch");
    }
    Require(kazarov::current(Utf8(disc), Utf8(data)), "fresh extraction is not current");
    Require(kazarov::check(Utf8(data)).textures == 0, "full publication check failed");

    // Datapack writer: PNG entries are stored at aligned offsets for direct reads.
    const fs::path pack = root / "pack";
    fs::create_directories(pack / "textures");
    Write(pack / "textures/a.png", {0x89, 'P', 'N', 'G'});
    Write(pack / "pack.json", {'{', '}'});
    kazarov::pack_directory(Utf8(pack), Utf8(root / "pack.zip"));
    {
        const auto archive = kazarov::open_archive(Utf8(root / "pack.zip"));
        Require(kazarov::archive_entry_count(*archive) == 2, "pack entry count mismatch");
        Require(std::string(kazarov::archive_entry_name(*archive, 1)) == "textures/a.png" &&
                    kazarov::archive_entry_stored(*archive, 1),
                "pack PNG entry mismatch");
        std::ifstream file(root / "pack.zip", std::ios::binary);
        file.seekg(static_cast<std::streamoff>(kazarov::archive_entry_data_offset(*archive, 1)));
        char magic[4] = {};
        file.read(magic, 4);
        Require(static_cast<std::uint8_t>(magic[0]) == 0x89 && magic[1] == 'P', "stored entry offset mismatch");
        caught = false;
        try {
            std::vector<std::uint8_t> wrong(3);
            kazarov::archive_read_entry(*archive, 1, rust::Slice<std::uint8_t>(wrong.data(), wrong.size()));
        } catch (const rust::Error &) {
            caught = true;
        }
        Require(caught, "wrong-size read accepted");
    }
    fs::remove_all(root);
}
