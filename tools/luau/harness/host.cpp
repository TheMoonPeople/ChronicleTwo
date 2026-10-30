// luau-harness runs a Luau driver script for the transpiler's differential tests.
// Usage: luau-harness <scripts_root> <driver.luau>
// The Luau state may use at most LUAU_HARNESS_MEMORY_MB megabytes (default 512). A driver that needs more stops the
// process with exit code 3 and a "memory limit" message on stderr.
// The driver runs unsandboxed so its globals are visible to modules loaded through require and loadmodule.
#include "Luau/Compiler.h"
#include "lua.h"
#include "lualib.h"

#include <cmath>
#include <cstdio>
#include <cstdlib>
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

/**
 * Registry key holding the cached module results.
 */
constexpr const char *kModuleCacheKey = "luau_harness.modules";
/**
 * Maximum safepoints allowed before a script is interrupted.
 */
constexpr long long kInterruptBudget = 200000000;

/**
 * Exit code of the process when the Luau state reaches its memory limit.
 */
constexpr int kMemoryLimitExit = 3;
/**
 * Default memory limit of the Luau state in megabytes.
 */
constexpr size_t kDefaultMemoryLimitMb = 512;

/**
 * Allocation accounting of the Luau state.
 */
struct MemoryBudget {
    size_t used = 0;  /**< Bytes currently allocated by the state. */
    size_t limit = 0; /**< Bytes the state may hold at most. */
};

/**
 * Root directory from which script modules are read.
 */
fs::path g_scripts_root;
/**
 * Safepoints executed since the interrupt budget was reset.
 */
long long g_interrupt_count = 0;
/**
 * Mirrors the game runtime's native skip mode flag, exposed to drivers through vmhost.
 */
bool g_skipping = false;
/**
 * Number of skip ends counted through vmhost.skip_end since the last reset.
 */
long long g_skip_end_count = 0;

/**
 * Allocator of the Luau state: refuses to grow past the memory limit and then ends the process, so a runaway driver
 * cannot take the machine's memory.
 */
void *limited_alloc(void *user_data, void *block, size_t old_size, size_t new_size) {
    auto *budget = static_cast<MemoryBudget *>(user_data);
    if (new_size == 0) {
        budget->used -= block != nullptr ? old_size : 0;
        std::free(block);
        return nullptr;
    }
    const size_t previous = block != nullptr ? old_size : 0;
    if (new_size > previous && budget->used + (new_size - previous) > budget->limit) {
        std::fflush(stdout);
        std::fprintf(stderr, "luau-harness: memory limit of %zu MB exceeded\n", budget->limit >> 20);
        std::fflush(stderr);
        std::_Exit(kMemoryLimitExit);
    }
    void *grown = std::realloc(block, new_size);
    if (grown != nullptr) {
        budget->used = budget->used - previous + new_size;
    }
    return grown;
}

/**
 * Memory limit in bytes, from LUAU_HARNESS_MEMORY_MB or the default.
 */
size_t memory_limit() {
    size_t megabytes = kDefaultMemoryLimitMb;
    if (const char *text = std::getenv("LUAU_HARNESS_MEMORY_MB")) {
        const long long value = std::atoll(text);
        if (value > 0) {
            megabytes = static_cast<size_t>(value);
        }
    }
    return megabytes << 20;
}

/**
 * Reads a complete module or driver source file.
 */
std::optional<std::string> read_file(const fs::path &path) {
    std::ifstream file(path, std::ios::binary);
    if (!file) {
        return std::nullopt;
    }
    std::ostringstream contents;
    contents << file.rdbuf();
    return contents.str();
}

/**
 * A module name resolved against scripts_root.
 */
struct ResolvedModule {
    fs::path    path;       /**< Absolute source path of the module. */
    std::string chunk_name; /**< Source name used in diagnostics. */
    std::string cache_key;  /**< Unique registry key of the module result. */
};

/**
 * Resolves a module name to its source path and diagnostic and cache identifiers.
 */
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

/**
 * Compiles source and pushes the resulting chunk. On failure the error message is left on the stack.
 */
bool load_chunk(lua_State *lua, const std::string &source, const std::string &chunk_name) {
    Luau::CompileOptions options;
    options.optimizationLevel = 1;
    options.debugLevel = 1;
    std::string bytecode = Luau::compile(source, options);
    return luau_load(lua, chunk_name.c_str(), bytecode.data(), bytecode.size(), 0) == LUA_OK;
}

/**
 * Runs a module's chunk once and pushes its single result.
 */
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

/**
 * require(name): runs each module once and caches its result, keyed by the resolved path.
 */
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

/**
 * loadmodule(name): runs the module chunk anew on every call, so each caller gets fresh module-level locals.
 */
int lua_loadmodule(lua_State *lua) {
    run_module(lua, resolve_module(lua, luaL_checkstring(lua, 1)));
    return 1;
}

/**
 * Counts VM safepoints and aborts runaway scripts once the budget is spent. The count starts again at the error, so
 * the driver that catches it can go on.
 */
void interrupt(lua_State *lua, [[maybe_unused]] int gc) {
    if (++g_interrupt_count > kInterruptBudget) {
        g_interrupt_count = 0;
        luaL_error(lua, "interrupt budget exceeded");
    }
}

/**
 * cmath.sinf(x): the C library's single-precision sine, which the game also links.
 */
int lua_sinf(lua_State *lua) {
    lua_pushnumber(lua, static_cast<double>(std::sin(static_cast<float>(luaL_checknumber(lua, 1)))));
    return 1;
}

/**
 * cmath.cosf(x): the C library's single-precision cosine, which the game also links.
 */
int lua_cosf(lua_State *lua) {
    lua_pushnumber(lua, static_cast<double>(std::cos(static_cast<float>(luaL_checknumber(lua, 1)))));
    return 1;
}

/**
 * resetbudget(): restarts the interrupt budget for the next script run.
 */
int lua_resetbudget([[maybe_unused]] lua_State *lua) {
    g_interrupt_count = 0;
    return 0;
}

/**
 * vmhost.skipping(): reports whether native skip mode is active.
 */
int lua_skipping(lua_State *lua) {
    lua_pushboolean(lua, g_skipping);
    return 1;
}

/**
 * vmhost.skip_end(): counts a skip end, leaves skip mode and reports whether skip mode was active.
 */
int lua_skip_end(lua_State *lua) {
    ++g_skip_end_count;
    const bool was_skipping = g_skipping;
    g_skipping = false;
    lua_pushboolean(lua, was_skipping);
    return 1;
}

/**
 * vmhost.set_skipping(b): sets native skip mode from a boolean argument.
 */
int lua_set_skipping(lua_State *lua) {
    g_skipping = lua_toboolean(lua, 1);
    return 0;
}

/**
 * vmhost.skip_end_count(): reports how many skip ends have been counted since the last reset.
 */
int lua_skip_end_count(lua_State *lua) {
    lua_pushnumber(lua, static_cast<double>(g_skip_end_count));
    return 1;
}

/**
 * vmhost.reset(): clears native skip mode and the skip end count.
 */
int lua_vmhost_reset([[maybe_unused]] lua_State *lua) {
    g_skipping = false;
    g_skip_end_count = 0;
    return 0;
}

/**
 * Error handler that replaces the error message with its message and a traceback.
 */
int traceback_handler(lua_State *lua) {
    const char *message = lua_tostring(lua, 1);
    luaL_traceback(lua, lua, message ? message : "(error object is not a string)", 1);
    return 1;
}

/**
 * Runs the driver named on the command line; returns the process exit code.
 */
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

    MemoryBudget budget;
    budget.limit = memory_limit();
    lua_State *lua = lua_newstate(limited_alloc, &budget);
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
    lua_createtable(lua, 0, 5);
    lua_pushcfunction(lua, lua_skipping, "skipping");
    lua_setfield(lua, -2, "skipping");
    lua_pushcfunction(lua, lua_skip_end, "skip_end");
    lua_setfield(lua, -2, "skip_end");
    lua_pushcfunction(lua, lua_set_skipping, "set_skipping");
    lua_setfield(lua, -2, "set_skipping");
    lua_pushcfunction(lua, lua_skip_end_count, "skip_end_count");
    lua_setfield(lua, -2, "skip_end_count");
    lua_pushcfunction(lua, lua_vmhost_reset, "reset");
    lua_setfield(lua, -2, "reset");
    lua_setglobal(lua, "vmhost");

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

/**
 * Runs the differential harness and reports uncaught host failures.
 */
int main(int argc, char **argv) {
    try {
        return run(argc, argv);
    } catch (const std::exception &error) {
        std::fprintf(stderr, "luau-harness: %s\n", error.what());
        return 1;
    }
}
