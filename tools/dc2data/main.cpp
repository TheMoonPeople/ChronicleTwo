#include <algorithm>
#include <cstdio>
#include <cstring>
#include <cwchar>
#include <exception>
#include <filesystem>
#include <string>
#include <thread>

#include "kazarov_bridge/rust/lib.h"

namespace {
namespace fs = std::filesystem;

#ifdef _WIN32
using ArgChar = wchar_t;
bool ArgEquals(const ArgChar *arg, const wchar_t *value) { return std::wcscmp(arg, value) == 0; }
#define ARG_LITERAL(value) L##value
#else
using ArgChar = char;
bool ArgEquals(const ArgChar *arg, const char *value) { return std::strcmp(arg, value) == 0; }
#define ARG_LITERAL(value) value
#endif

std::string Utf8Path(const fs::path &path) {
    const auto bytes = path.u8string();
    return {reinterpret_cast<const char *>(bytes.data()), bytes.size()};
}

int Usage() {
    std::fputs("usage: dc2data extract <iso-or-directory> <game-root>/data [--jobs N]\n"
               "       dc2data list <iso-or-directory>\n"
               "       dc2data sound <iso-or-directory>\n"
               "       dc2data check <game-root>/data\n"
               "       dc2data current <iso-or-directory> <game-root>/data\n"
               "       dc2data pack <directory> <archive.zip>\n"
               "extract publishes <game-root>/data.zip and <game-root>/data.json.\n", stderr);
    return 2;
}
} // namespace

int Run(int argc, ArgChar **argv) {
    try {
        if ((argc == 4 || argc == 6) && ArgEquals(argv[1], ARG_LITERAL("extract"))) {
            unsigned jobs = std::clamp(std::thread::hardware_concurrency(), 1u, 32u);
            if (argc == 6) {
                if (!ArgEquals(argv[4], ARG_LITERAL("--jobs"))) return Usage();
                unsigned parsed_jobs = 0;
                for (const ArgChar *digit = argv[5]; *digit; ++digit) {
                    if (*digit < ARG_LITERAL('0') || *digit > ARG_LITERAL('9') || parsed_jobs > 64) return Usage();
                    parsed_jobs = parsed_jobs * 10 + static_cast<unsigned>(*digit - ARG_LITERAL('0'));
                }
                if (parsed_jobs == 0 || parsed_jobs > 64) return Usage();
                jobs = parsed_jobs;
            }
            const auto report = kazarov::extract(Utf8Path(argv[2]), Utf8Path(argv[3]), jobs);
            std::printf("converted %llu reachable files (%llu source bytes), %llu texture sources, %llu PNGs\n",
                        static_cast<unsigned long long>(report.files),
                        static_cast<unsigned long long>(report.bytes),
                        static_cast<unsigned long long>(report.texture_sources),
                        static_cast<unsigned long long>(report.pngs));
            return 0;
        }
        if (argc == 3 && ArgEquals(argv[1], ARG_LITERAL("list"))) {
            const auto result = kazarov::list(Utf8Path(argv[2]));
            std::fwrite(result.data(), 1, result.size(), stdout);
            return 0;
        }
        if (argc == 3 && ArgEquals(argv[1], ARG_LITERAL("sound"))) {
            const auto result = kazarov::sound(Utf8Path(argv[2]));
            std::fwrite(result.data(), 1, result.size(), stdout);
            return 0;
        }
        if (argc == 3 && ArgEquals(argv[1], ARG_LITERAL("check"))) {
            const auto report = kazarov::check(Utf8Path(argv[2]));
            std::printf("verified %llu PNG textures\n", static_cast<unsigned long long>(report.textures));
            return 0;
        }
        if (argc == 4 && ArgEquals(argv[1], ARG_LITERAL("pack"))) {
            kazarov::pack_directory(Utf8Path(argv[2]), Utf8Path(argv[3]));
            const auto archive = kazarov::open_archive(Utf8Path(argv[3]));
            std::printf("packed %llu files\n", static_cast<unsigned long long>(kazarov::archive_entry_count(*archive)));
            return 0;
        }
        if (argc == 4 && ArgEquals(argv[1], ARG_LITERAL("current"))) {
            return kazarov::current(Utf8Path(argv[2]), Utf8Path(argv[3])) ? 0 : 1;
        }
        return Usage();
    } catch (const std::exception &error) {
        std::fprintf(stderr, "dc2data: %s\n", error.what());
        return 1;
    }
}

#ifdef _WIN32
int wmain(int argc, wchar_t **argv) { return Run(argc, argv); }
#else
int main(int argc, char **argv) { return Run(argc, argv); }
#endif
