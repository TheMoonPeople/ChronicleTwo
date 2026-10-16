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
    Require(fs::is_regular_file(data / "foo.bin"), "extracted file missing");
    Require(fs::is_directory(root / "run/port_data"), "native asset directory missing");
    Require(!fs::exists(root / "run/port_data/catalog.json") && !fs::exists(data / "manifest.json"), "obsolete asset index published");
    Require(kazarov::current(Utf8(disc), Utf8(data)), "fresh extraction is not current");
    Require(kazarov::check(Utf8(data)).textures == 0, "full publication check failed");
    fs::remove_all(root);
}
