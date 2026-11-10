#include "kazarov_bridge/rust/lib.h"

#include <algorithm>
#include <cctype>
#include <cstdint>
#include <cstdio>
#include <cstring>
#include <cwchar>
#include <exception>
#include <filesystem>
#include <fstream>
#include <stdexcept>
#include <string>
#include <thread>
#include <vector>

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

/**
 *
 * Tests whether an archive entry name denotes a script file by its extension.
 *
 */
bool IsScriptName(const std::string &lower_name) {
    return lower_name.ends_with(".stb") || lower_name.ends_with(".stb_");
}

/**
 *
 * Returns an ASCII lower-cased copy of a name.
 *
 */
std::string ToLower(std::string text) {
    std::ranges::transform(text, text.begin(), [](const char c) { return static_cast<char>(std::tolower(static_cast<unsigned char>(c))); });
    return text;
}

/**
 *
 * Checks that a relative archive path cannot escape the output directory.
 *
 */
bool IsSafeRelativePath(const std::string &relative) {
    if (relative.empty() || relative.front() == '/' || relative.find_first_of("\\:") != std::string::npos) {
        return false;
    }
    std::size_t start = 0;
    while (true) {
        const auto end = relative.find('/', start);
        const auto part = relative.substr(start, end == std::string::npos ? std::string::npos : end - start);
        if (part.empty() || part == "..") {
            return false;
        }
        if (end == std::string::npos) {
            return true;
        }
        start = end + 1;
    }
}

/**
 *
 * Writes every published script in a data archive to a directory, keyed by its data-relative path.
 *
 */
std::size_t ExportScripts(const fs::path &source, const fs::path &output) {
    const auto archive_file = fs::is_directory(source) ? source / "data.zip" : source;
    const auto archive = kazarov::open_archive(Utf8Path(archive_file));
    fs::create_directories(output);
    const auto entry_count = kazarov::archive_entry_count(*archive);

    std::size_t written = 0;
    for (std::size_t index = 0; index < entry_count; ++index) {
        const auto relative = static_cast<std::string>(kazarov::archive_entry_name(*archive, index));
        if (!IsScriptName(ToLower(relative))) {
            continue;
        }
        if (!IsSafeRelativePath(relative)) {
            throw std::runtime_error("unsafe archive entry name: " + relative);
        }

        std::vector<std::uint8_t> bytes(static_cast<std::size_t>(kazarov::archive_entry_size(*archive, index)));
        kazarov::archive_read_entry(*archive, index, rust::Slice<std::uint8_t>(bytes.data(), bytes.size()));

        const auto target = output / fs::path(relative);
        fs::create_directories(target.parent_path());
        std::ofstream file(target, std::ios::binary);
        file.write(reinterpret_cast<const char *>(bytes.data()), static_cast<std::streamsize>(bytes.size()));
        if (!file) {
            throw std::runtime_error("could not write " + Utf8Path(target));
        }
        ++written;
    }
    return written;
}

int Usage() {
    std::fputs("usage: dc2data extract <iso-or-directory> <game-root>/data [--jobs N] [--retain-scripts]\n"
               "       dc2data list <iso-or-directory>\n"
               "       dc2data sound <iso-or-directory>\n"
               "       dc2data gameplay <iso-or-directory> <repo>/port/gameplay\n"
               "       dc2data gameplay-audit <iso-or-directory> <repo>/port/gameplay\n"
               "       dc2data gameplay-parity <iso-or-directory> <data.zip> <repo>/port/gameplay <fixture-dir> [--texture-oracle <directory>]\n"
               "       dc2data check <game-root>/data\n"
               "       dc2data current <iso-or-directory> <game-root>/data [--retain-scripts]\n"
               "       dc2data pack <directory> <archive.zip>\n"
               "       dc2data export-scripts <data.zip-or-game-root> <directory>\n"
               "extract publishes <game-root>/data.zip and <game-root>/data.json. The game runs the scripts' Luau modules,\n"
               "so the compiled scripts are left out unless --retain-scripts keeps them for export-scripts.\n",
               stderr);
    return 2;
}
} // namespace

int Run(int argc, ArgChar **argv) {
    try {
        // The compiled scripts are published only for developers who translate them again.
        const bool retain = argc > 4 && ArgEquals(argv[argc - 1], ARG_LITERAL("--retain-scripts"));
        const auto policy = retain ? kazarov::ScriptPublicationPolicy::Retain : kazarov::ScriptPublicationPolicy::LuauOnly;
        const int  args = retain ? argc - 1 : argc;
        if ((args == 4 || args == 6) && ArgEquals(argv[1], ARG_LITERAL("extract"))) {
            unsigned jobs = std::max(std::thread::hardware_concurrency(), 1u);
            if (args == 6) {
                if (!ArgEquals(argv[4], ARG_LITERAL("--jobs"))) {
                    return Usage();
                }
                unsigned parsed_jobs = 0;
                for (const ArgChar *digit = argv[5]; *digit; ++digit) {
                    if (*digit < ARG_LITERAL('0') || *digit > ARG_LITERAL('9') || parsed_jobs > 1024) {
                        return Usage();
                    }
                    parsed_jobs = parsed_jobs * 10 + static_cast<unsigned>(*digit - ARG_LITERAL('0'));
                }
                if (parsed_jobs == 0 || parsed_jobs > 1024) {
                    return Usage();
                }
                jobs = parsed_jobs;
            }
            const auto report = kazarov::extract_with_script_policy(Utf8Path(argv[2]), Utf8Path(argv[3]), jobs, policy);
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
        if (argc == 4 && (ArgEquals(argv[1], ARG_LITERAL("gameplay")) || ArgEquals(argv[1], ARG_LITERAL("configs")))) {
            const auto count = kazarov::refresh_configs(Utf8Path(argv[2]), Utf8Path(argv[3]));
            std::printf("refreshed %llu gameplay documents\n", static_cast<unsigned long long>(count));
            return 0;
        }
        if (argc == 4 && (ArgEquals(argv[1], ARG_LITERAL("gameplay-audit")) || ArgEquals(argv[1], ARG_LITERAL("configs-audit")))) {
            const auto result = kazarov::audit_configs(Utf8Path(argv[2]), Utf8Path(argv[3]));
            std::fwrite(result.data(), 1, result.size(), stdout);
            return 0;
        }
        if ((argc == 6 || argc == 8) && (ArgEquals(argv[1], ARG_LITERAL("gameplay-parity")) || ArgEquals(argv[1], ARG_LITERAL("configs-parity")))) {
            if (argc == 8 && !ArgEquals(argv[6], ARG_LITERAL("--texture-oracle"))) {
                return Usage();
            }
            const auto count = kazarov::configs_parity(Utf8Path(argv[2]), Utf8Path(argv[3]),
                                                       Utf8Path(argv[4]), Utf8Path(argv[5]),
                                                       argc == 8 ? Utf8Path(argv[7]) : std::string{});
            std::printf("prepared %llu original CFG parity inputs\n", static_cast<unsigned long long>(count));
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
        if (argc == 4 && ArgEquals(argv[1], ARG_LITERAL("export-scripts"))) {
            const auto count = ExportScripts(fs::path(argv[2]), fs::path(argv[3]));
            std::printf("exported %llu scripts to %s\n", static_cast<unsigned long long>(count), Utf8Path(argv[3]).c_str());
            return 0;
        }
        if (args == 4 && ArgEquals(argv[1], ARG_LITERAL("current"))) {
            return kazarov::current_with_script_policy(Utf8Path(argv[2]), Utf8Path(argv[3]), policy) ? 0 : 1;
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
