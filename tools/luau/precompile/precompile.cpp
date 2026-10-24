// luau-precompile compiles one of the game's Luau scripts to the .luauc bytecode the game loads in place of the source
// (port/src/luau_bytecode.hpp). It runs on the build machine, so a cross-compiled build such as iOS's ships scripts
// that need no compiling on the device.
// Usage: luau-precompile -O<level> <source.luau> <output.luauc>
#include <cstdio>
#include <cstdlib>
#include <fstream>
#include <iterator>
#include <memory>
#include <string>
#include <string_view>

#include "luau_bytecode.hpp"

int main(int argc, char **argv) {
    if (argc != 4 || std::string_view(argv[1]).substr(0, 2) != "-O") {
        std::fprintf(stderr, "usage: luau-precompile -O<level> <source.luau> <output.luauc>\n");
        return 2;
    }
    const int level = std::atoi(argv[1] + 2);
    if (level < 0 || level > 2) {
        std::fprintf(stderr, "luau-precompile: the level must be 0, 1 or 2, not %s\n", argv[1] + 2);
        return 2;
    }

    std::ifstream input(argv[2], std::ios::binary);
    if (!input) {
        std::fprintf(stderr, "luau-precompile: cannot read %s\n", argv[2]);
        return 1;
    }
    const std::string source((std::istreambuf_iterator<char>(input)), std::istreambuf_iterator<char>());

    lua_CompileOptions options = luau_bytecode::RuntimeOptions();
    options.optimizationLevel = level;
    std::size_t                                   size = 0;
    char                                         *bytecode = luau_compile(source.data(), source.size(), &options, &size);
    const std::unique_ptr<char, void (*)(void *)> owner(bytecode, std::free);
    if (bytecode == nullptr || size == 0) {
        std::fprintf(stderr, "luau-precompile: cannot compile %s\n", argv[2]);
        return 1;
    }
    // A script that does not compile yields bytecode holding a zero byte and the error message.
    if (bytecode[0] == 0) {
        std::fprintf(stderr, "%s%.*s\n", argv[2], static_cast<int>(size - 1), bytecode + 1);
        return 1;
    }

    const std::string temporary = std::string(argv[3]) + ".tmp";
    {
        std::ofstream     output(temporary, std::ios::binary | std::ios::trunc);
        const std::string header = luau_bytecode::Header(source);
        output.write(header.data(), static_cast<std::streamsize>(header.size()));
        output.write(bytecode, static_cast<std::streamsize>(size));
        if (!output) {
            std::fprintf(stderr, "luau-precompile: cannot write %s\n", temporary.c_str());
            return 1;
        }
    }
    if (std::rename(temporary.c_str(), argv[3]) != 0) {
        std::remove(argv[3]);
        if (std::rename(temporary.c_str(), argv[3]) != 0) {
            std::fprintf(stderr, "luau-precompile: cannot write %s\n", argv[3]);
            return 1;
        }
    }
    return 0;
}
