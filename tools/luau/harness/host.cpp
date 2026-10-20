// luau-harness runs a Luau driver script for the transpiler's differential tests.
// Usage: luau-harness <scripts_root> <driver.luau>
// The driver runs unsandboxed so its globals are visible to modules loaded through require and loadmodule.
#include "Luau/Compiler.h"
#include "lua.h"
#include "lualib.h"

#include <cmath>
#include <cstdio>
#include <exception>
#include <filesystem>
#include <fstream>
#include <optional>
#include <sstream>
#include <string>

#ifdef _WIN32
#include <fcntl.h>
#include <io.h>
#endif

namespace fs = std::filesystem;

namespace {

constexpr const char *kModuleCacheKey = "luau_harness.modules";
constexpr long long   kInterruptBudget = 200000000;

fs::path  g_scripts_root;
long long g_interrupt_count = 0;

std::optional<std::string> read_file(const fs::path &path) {
    std::ifstream file(path, std::ios::binary);
    if (!file) {
        return std::nullopt;
    }
    std::ostringstream contents;
    contents << file.rdbuf();
    return contents.str();
}

// A module name resolved against scripts_root.
struct ResolvedModule {
    fs::path    path;
    std::string chunk_name;
    std::string cache_key;
};

ResolvedModule resolve_module(lua_State *lua, const char *name) {
    std::string requested(name);
    fs::path    relative;
    if (requested.rfind("@lib/", 0) == 0) {
        relative = fs::path("lib") / (requested.substr(5) + ".luau");
    } else if (!requested.empty() && requested[0] == '@') {
        luaL_error(lua, "unknown require alias '%s'", name);
    } else {
        relative = fs::path(requested + ".luau");
    }

    relative = relative.lexically_normal();
    ResolvedModule module;
    module.path = (g_scripts_root / relative).lexically_normal();
    module.chunk_name = "@" + relative.generic_string();
    module.cache_key = module.path.generic_string();
    if (!fs::is_regular_file(module.path)) {
        luaL_error(lua, "module '%s' not found at %s", name, module.path.generic_string().c_str());
    }
    return module;
}

// Compiles source and pushes the resulting chunk. On failure the error message is left on the stack.
bool load_chunk(lua_State *lua, const std::string &source, const std::string &chunk_name) {
    Luau::CompileOptions options;
    options.optimizationLevel = 1;
    options.debugLevel = 1;
    std::string bytecode = Luau::compile(source, options);
    return luau_load(lua, chunk_name.c_str(), bytecode.data(), bytecode.size(), 0) == LUA_OK;
}

// Runs a module's chunk once and pushes its single result.
void run_module(lua_State *lua, const ResolvedModule &module) {
    std::optional<std::string> source = read_file(module.path);
    if (!source) {
        luaL_error(lua, "cannot read module %s", module.path.generic_string().c_str());
    }
    if (!load_chunk(lua, *source, module.chunk_name)) {
        luaL_error(lua, "%s", lua_tostring(lua, -1));
    }
    lua_call(lua, 0, 1);
}

// require(name): runs each module once and caches its result, keyed by the resolved path.
int lua_require(lua_State *lua) {
    ResolvedModule module = resolve_module(lua, luaL_checkstring(lua, 1));

    lua_getfield(lua, LUA_REGISTRYINDEX, kModuleCacheKey);
    lua_pushstring(lua, module.cache_key.c_str());
    lua_rawget(lua, -2);
    if (!lua_isnil(lua, -1)) {
        return 1;
    }
    lua_pop(lua, 2);

    run_module(lua, module);

    lua_getfield(lua, LUA_REGISTRYINDEX, kModuleCacheKey);
    lua_pushstring(lua, module.cache_key.c_str());
    lua_pushvalue(lua, -3);
    lua_rawset(lua, -3);
    lua_pop(lua, 1);
    return 1;
}

// loadmodule(name): runs the module chunk anew on every call, so each caller gets fresh module-level locals.
int lua_loadmodule(lua_State *lua) {
    run_module(lua, resolve_module(lua, luaL_checkstring(lua, 1)));
    return 1;
}

// Counts VM safepoints and aborts runaway scripts once the budget is spent. The count starts again at the error, so
// the driver that catches it can go on.
void interrupt(lua_State *lua, [[maybe_unused]] int gc) {
    if (++g_interrupt_count > kInterruptBudget) {
        g_interrupt_count = 0;
        luaL_error(lua, "interrupt budget exceeded");
    }
}

// cmath.sinf(x): the C library's single-precision sine, which the game also links.
int lua_sinf(lua_State *lua) {
    lua_pushnumber(lua, static_cast<double>(std::sin(static_cast<float>(luaL_checknumber(lua, 1)))));
    return 1;
}

// cmath.cosf(x): the C library's single-precision cosine, which the game also links.
int lua_cosf(lua_State *lua) {
    lua_pushnumber(lua, static_cast<double>(std::cos(static_cast<float>(luaL_checknumber(lua, 1)))));
    return 1;
}

// resetbudget(): restarts the interrupt budget for the next script run.
int lua_resetbudget([[maybe_unused]] lua_State *lua) {
    g_interrupt_count = 0;
    return 0;
}

// Error handler that replaces the error message with its message and a traceback.
int traceback_handler(lua_State *lua) {
    const char *message = lua_tostring(lua, 1);
    luaL_traceback(lua, lua, message ? message : "(error object is not a string)", 1);
    return 1;
}

// Runs the driver named on the command line; returns the process exit code.
int run(int argc, char **argv) {
    if (argc != 3) {
        std::fprintf(stderr, "usage: %s <scripts_root> <driver.luau>\n", argv[0]);
        return 2;
    }

#ifdef _WIN32
    _setmode(_fileno(stdout), _O_BINARY);
#endif

    g_scripts_root = fs::absolute(argv[1]).lexically_normal();
    std::optional<std::string> driver_source = read_file(fs::absolute(argv[2]));
    if (!driver_source) {
        std::fprintf(stderr, "cannot read driver %s\n", argv[2]);
        return 1;
    }

    lua_State *lua = luaL_newstate();
    luaL_openlibs(lua);
    lua_callbacks(lua)->interrupt = interrupt;

    lua_newtable(lua);
    lua_setfield(lua, LUA_REGISTRYINDEX, kModuleCacheKey);
    lua_pushcfunction(lua, lua_require, "require");
    lua_setglobal(lua, "require");
    lua_pushcfunction(lua, lua_loadmodule, "loadmodule");
    lua_setglobal(lua, "loadmodule");
    lua_pushcfunction(lua, lua_resetbudget, "resetbudget");
    lua_setglobal(lua, "resetbudget");
    lua_createtable(lua, 0, 2);
    lua_pushcfunction(lua, lua_sinf, "sinf");
    lua_setfield(lua, -2, "sinf");
    lua_pushcfunction(lua, lua_cosf, "cosf");
    lua_setfield(lua, -2, "cosf");
    lua_setglobal(lua, "cmath");

    int exit_code = 0;
    lua_pushcfunction(lua, traceback_handler, "traceback");
    if (!load_chunk(lua, *driver_source, "@driver") || lua_pcall(lua, 0, 0, 1) != LUA_OK) {
        std::fprintf(stderr, "%s\n", lua_tostring(lua, -1));
        exit_code = 1;
    }

    std::fflush(stdout);
    lua_close(lua);
    return exit_code;
}

} // namespace

int main(int argc, char **argv) {
    try {
        return run(argc, argv);
    } catch (const std::exception &error) {
        std::fprintf(stderr, "luau-harness: %s\n", error.what());
        return 1;
    }
}
