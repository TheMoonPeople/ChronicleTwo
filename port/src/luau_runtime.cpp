#include "lua.h"
#include "luacode.h"
#include "luacodegen.h"
#include "lualib.h"

#include <algorithm>
#include <array>
#include <cmath>
#include <cstddef>
#include <cstdint>
#include <cstdlib>
#include <cstring>
#include <exception>
#include <format>
#include <fstream>
#include <functional>
#include <iterator>
#include <memory>
#include <optional>
#include <string>
#include <string_view>
#include <system_error>
#include <unordered_map>
#include <unordered_set>
#include <utility>
#include <vector>

#include "log/log.hpp"
#include "luau_bindings.hpp"
#include "luau_runtime.hpp"
#include "platform/legacy_encoding.hpp"
#include "platform/paths.hpp"
#include "platform/settings.hpp"
#include "platform/vfs.hpp"
#include "ps2_printf.hpp"

namespace {

constexpr std::string_view kHandleMagic = "LUAU";
constexpr std::size_t kHandleLengthOffset = kHandleMagic.size();
constexpr std::size_t kHandleTextOffset = kHandleLengthOffset + sizeof(std::uint32_t);
constexpr std::size_t kHandleAlignment = 16;
constexpr std::int32_t kUnwritten = 0x7FC0DEAD;
constexpr std::int64_t kDefaultBudget = 10000000;
constexpr std::size_t kMaxArguments = 32;

/**
 *
 * Maps the path prefix of a script module to the native kind whose programs the module runs.
 *
 */
struct ScriptPrefix {
    std::string_view prefix;         /**< Module path prefix, ending in a slash. */
    std::string_view kind;           /**< Name of the kind in the command catalog. */
    bool             nested = false; /**< Whether only modules in a directory below the prefix match, as pack members do. */
};

constexpr std::array<ScriptPrefix, 10> kScriptPrefixes = {
    {
     {.prefix = "mainchr/", .kind = "action"},
     {.prefix = "dungeon/act_script/", .kind = "action"},
     {.prefix = "dungeon/eff_script/", .kind = "effect"},
     {.prefix = "dungeon/articles/", .kind = "effect"},
     {.prefix = "dungeon/sphida/", .kind = "effect"},
     {.prefix = "event/tbox/", .kind = "effect", .nested = true},
     {.prefix = "dungeon/monster/", .kind = "monster"},
     // Event scripts follow the effect pack members under event/tbox/, which the nested rule claims first.
        {.prefix = "map/", .kind = "event"},
     {.prefix = "dungeon/sys_script/", .kind = "event"},
     {.prefix = "event/", .kind = "event"},
     }
};

/**
 *
 * Reports whether a module is an event argument script: a file under event/ whose name holds "_arg", as in e209_arg_1.
 *
 */
bool IsEventArgumentModule(std::string_view module) {
    if (!module.starts_with("event/")) {
        return false;
    }
    return module.substr(module.rfind('/') + 1).contains("_arg");
}

/**
 *
 * Finds the registered kind for a module from the first script prefix it matches; null when none matches or the kind is not registered.
 *
 */
const luau_bindings::Kind *KindForModule(std::string_view module) {
    const std::string_view argument_kind = "event_arg";
    if (IsEventArgumentModule(module)) {
        const auto kinds = luau_bindings::Kinds();
        const auto found = std::ranges::find(kinds, argument_kind, &luau_bindings::Kind::name);
        return found == kinds.end() ? nullptr : &*found;
    }
    const auto *const prefix = std::ranges::find_if(kScriptPrefixes, [module](const ScriptPrefix &script_prefix) {
        return module.starts_with(script_prefix.prefix) && (!script_prefix.nested || module.substr(script_prefix.prefix.size()).contains('/'));
    });
    if (prefix == kScriptPrefixes.end()) {
        return nullptr;
    }
    for (const luau_bindings::Kind &kind : luau_bindings::Kinds()) {
        if (kind.name == prefix->kind) {
            return &kind;
        }
    }
    return nullptr;
}

lua_State                                                *state = nullptr;
bool                                                      codegen = false;
std::optional<std::filesystem::path>                      root_override;
std::unordered_map<std::string, std::filesystem::path>    modules;
bool                                                      modules_indexed = false;
int                                                       module_cache_ref = LUA_NOREF;
int                                                       required_ref = LUA_NOREF;
std::int64_t                                              budget = kDefaultBudget;
std::int64_t                                              remaining = kDefaultBudget;
CRunScript                                               *current = nullptr;
std::unordered_map<std::string, std::unique_ptr<char[]> > interned;
std::unordered_set<std::string>                           ambiguous_commands;
std::unordered_set<std::string>                           missing_programs;
bool                                                      conversion_warned = false;

/**
 *
 * Releases a registry reference while the Luau state is open and clears it.
 *
 */
void ReleaseRef(int &ref) {
    if (state != nullptr && ref != LUA_NOREF && ref != LUA_REFNIL) {
        lua_unref(state, ref);
    }
    ref = LUA_NOREF;
}

/**
 *
 * Reports whether a registry reference names a live value.
 *
 */
bool HasRef(int ref) {
    return ref != LUA_NOREF && ref != LUA_REFNIL;
}

/**
 *
 * Converts a path's generic form to the std::string bytes of its UTF-8 name, for keys and chunk names.
 *
 */
std::string Utf8(const std::filesystem::path &path) {
    const std::u8string generic = path.generic_u8string();
    return std::string(reinterpret_cast<const char *>(generic.data()), generic.size());
}

/**
 *
 * Names a module by the script data path it was compiled from, for diagnostics.
 *
 */
std::string ScriptLabel(std::string_view module) {
    return std::format("{}.stb", module);
}

/**
 *
 * Lua global print with the retail PRINT semantics: strings and numbers are concatenated without separators and written through the game's printf.
 *
 */
int Print(lua_State *lua) {
    std::string text;
    const int   count = lua_gettop(lua);
    for (int arg = 1; arg <= count; ++arg) {
        switch (lua_type(lua, arg)) {
            case LUA_TSTRING: {
                std::size_t length = 0;
                const char *value = lua_tolstring(lua, arg, &length);
                text.append(value, length);
                break;
            }
            case LUA_TNUMBER: {
                const double value = lua_tonumberx(lua, arg, nullptr);
                if (std::trunc(value) == value && value >= -2147483648.0 && value < 2147483648.0) {
                    text += std::format("{}", static_cast<int>(value));
                } else {
                    text += std::format("{:f}", value);
                }
                break;
            }
            default:
                break;
        }
    }
    CtPs2Printf("%s", text.c_str());
    return 0;
}

/**
 *
 * One script instance's Luau state: its sandboxed thread, its programs and the coroutine of the running program.
 *
 */
struct Instance {
    std::string                module;                 /**< Folded key of the module the instance runs. */
    const void                *program = nullptr;      /**< Program data the instance was loaded for. */
    const luau_bindings::Kind *kind = nullptr;         /**< Kind whose program names the instance's handlers use, if any. */
    int                        env_ref = LUA_NOREF;    /**< Registry ref to the sandboxed thread holding the instance's globals. */
    int                        script_ref = LUA_NOREF; /**< Registry ref to the script table the module returned. */
    int                        thread_ref = LUA_NOREF; /**< Registry ref to the coroutine of the running program. */
    int                        running_no = 0;         /**< Program number the coroutine of the running program was started for. */
    bool                       broken = false;         /**< Whether the module failed to load and has no handlers. */

    ~Instance() {
        ReleaseRef(env_ref);
        ReleaseRef(script_ref);
        ReleaseRef(thread_ref);
    }
};

std::unordered_map<const CRunScript *, std::shared_ptr<Instance> > instances;

/**
 *
 * Reports whether Luau runs script kinds, unless DC2_SCRIPT_VM selects the interpreter; read once.
 *
 */
bool ScriptVmEnabled() {
    static const bool enabled = [] {
        const char *value = SettingsEnv("SCRIPT_VM");
        return value == nullptr || std::string_view(value) != "interpreter";
    }();
    return enabled;
}

/**
 *
 * Finds the directory Luau modules load from: the override when set, else a scripts directory beside the data or the executable.
 *
 */
std::optional<std::filesystem::path> ScriptsRoot() {
    if (root_override.has_value() && !root_override->empty()) {
        return root_override;
    }
    std::error_code       ec;
    std::filesystem::path data_candidate = PathsDataRoot().parent_path() / "scripts";
    if (std::filesystem::is_directory(data_candidate, ec)) {
        return data_candidate;
    }
    const std::filesystem::path executable = PathsExecutable();
    if (!executable.empty()) {
        std::filesystem::path executable_candidate = executable.parent_path() / "scripts";
        if (std::filesystem::is_directory(executable_candidate, ec)) {
            return executable_candidate;
        }
    }
    return std::nullopt;
}

/**
 *
 * Rebuilds the index of .luau modules under the scripts directory, keyed by folded path without extension.
 *
 */
void BuildIndex() {
    modules.clear();
    modules_indexed = true;
    const std::optional<std::filesystem::path> root = ScriptsRoot();
    if (!root) {
        return;
    }
    std::error_code                                     ec;
    std::filesystem::recursive_directory_iterator       it(*root, std::filesystem::directory_options::skip_permission_denied, ec);
    const std::filesystem::recursive_directory_iterator end;
    for (; !ec && it != end; it.increment(ec)) {
        const std::filesystem::path file = it->path();
        // Declaration files (.d.luau) describe types for editors and are not modules.
        if (file.extension() != ".luau" || file.stem().extension() == ".d") {
            continue;
        }
        std::error_code file_ec;
        if (!it->is_regular_file(file_ec)) {
            continue;
        }
        std::filesystem::path relative = file.lexically_relative(*root);
        relative.replace_extension();
        modules.emplace(vfs::FoldKey(Utf8(relative)), file);
    }
}

/**
 *
 * Builds the module index when it is first needed after the scripts directory changes.
 *
 */
void EnsureIndex() {
    if (!modules_indexed) {
        BuildIndex();
    }
}

/**
 *
 * Interrupt hook that raises an error when a program runs past its budget without yielding.
 *
 */
void Interrupt(lua_State *lua, int gc) {
    if (gc >= 0) {
        return;
    }
    if (--remaining < 0) {
        remaining = budget;
        const std::string message = std::format("script exceeded its budget of {} interrupts without waiting", budget);
        luaL_error(lua, "%s", message.c_str());
    }
}

/**
 *
 * Converts a pointer to the light userdata Luau stores it as.
 *
 */
template <typename T>
void *Userdata(const T *pointer) {
    return const_cast<void *>(static_cast<const void *>(pointer));
}

/**
 *
 * Makes a script the current one for native calls and restores the previous one when it leaves scope.
 *
 */
struct CurrentGuard {
    CRunScript *previous; /**< Script that was current before this guard. */

    explicit CurrentGuard(CRunScript *script) : previous(current) {
        current = script;
    }

    ~CurrentGuard() {
        current = previous;
    }

    CurrentGuard(const CurrentGuard &) = delete;
    CurrentGuard &operator=(const CurrentGuard &) = delete;
};

/**
 *
 * Converts UTF-8 text to a stable CP932 copy that handlers may keep a pointer to.
 *
 */
char *Intern(std::string_view utf8) {
    const std::string key(utf8);
    if (const auto found = interned.find(key); found != interned.end()) {
        return found->second.get();
    }
    std::string cp932;
    try {
        cp932 = legacy_encoding::GameText(utf8);
    } catch (const std::exception &error) {
        if (!conversion_warned) {
            conversion_warned = true;
            CT_LOG_WARN(Script, "luau: text is not representable in CP932, passing its UTF-8 bytes: {}", error.what());
        }
        cp932 = key;
    }
    auto buffer = std::make_unique<char[]>(cp932.size() + 1);
    std::memcpy(buffer.get(), cp932.data(), cp932.size());
    char *text = buffer.get();
    interned.emplace(key, std::move(buffer));
    return text;
}

/**
 *
 * Reports whether a parameter type is held in an integer slot.
 *
 */
bool IsIntegerType(luau_bindings::Type type) {
    switch (type) {
        case luau_bindings::Type::S8:
        case luau_bindings::Type::U8:
        case luau_bindings::Type::S16:
        case luau_bindings::Type::U16:
        case luau_bindings::Type::S32:
        case luau_bindings::Type::U32:
        case luau_bindings::Type::Unknown:
            return true;
        default:
            return false;
    }
}

/**
 *
 * Reports whether a number is an integer the 32-bit integer slots can hold, signed or unsigned.
 *
 */
bool FitsInteger(double value) {
    return std::trunc(value) == value && value >= -2147483648.0 && value < 4294967296.0;
}

/**
 *
 * Stores a number in an integer slot, wrapping it into 32 bits.
 *
 */
void SetInteger(RS_STACKDATA &slot, double value) {
    slot.type = RS_INT;
    slot.val.i = static_cast<int>(static_cast<std::uint32_t>(static_cast<std::int64_t>(value)));
}

/**
 *
 * Stores a number in a float slot.
 *
 */
void SetFloat(RS_STACKDATA &slot, double value) {
    slot.type = RS_FLOAT;
    slot.val.f = static_cast<float>(value);
}

/**
 *
 * Names a command as its namespace and name, for diagnostics.
 *
 */
std::string CommandLabel(const luau_bindings::Command &command) {
    for (const luau_bindings::Kind &kind : luau_bindings::Kinds()) {
        const auto       *first = kind.commands.data();
        const auto       *last = first + kind.commands.size();
        const std::less<> before;
        if (!before(&command, first) && before(&command, last)) {
            return std::format("{}.{}", kind.space, command.name);
        }
    }
    return std::string(command.name);
}

/**
 *
 * Converts the Luau value at an argument index into a native stack slot of the parameter's type.
 *
 */
void MarshalValue(lua_State *lua, int arg, luau_bindings::Type type, RS_STACKDATA &slot, const luau_bindings::Command *command) {
    switch (lua_type(lua, arg)) {
        case LUA_TNUMBER: {
            const double value = lua_tonumberx(lua, arg, nullptr);
            if (IsIntegerType(type) && FitsInteger(value)) {
                SetInteger(slot, value);
            } else {
                SetFloat(slot, value);
            }
            return;
        }
        case LUA_TSTRING: {
            std::size_t length = 0;
            const char *text = lua_tolstring(lua, arg, &length);
            slot.type = RS_STR;
            slot.val.s = Intern(std::string_view(text, length));
            return;
        }
        case LUA_TBOOLEAN:
            SetInteger(slot, lua_toboolean(lua, arg) != 0 ? 1.0 : 0.0);
            return;
        case LUA_TNIL:
        case LUA_TNONE:
            SetInteger(slot, 0.0);
            return;
        default: {
            const std::string label = command != nullptr ? CommandLabel(*command) : std::string("native command");
            const std::string message = std::format("argument {} of {} must be a number, string or boolean", arg, label);
            luaL_error(lua, "%s", message.c_str());
        }
    }
}

/**
 *
 * Pushes a handler output onto the Luau stack as the value the script expects for its type.
 *
 */
void PushOutput(lua_State *lua, const RS_STACKDATA &output, luau_bindings::Type type) {
    if (output.val.i == kUnwritten) {
        lua_pushnil(lua);
        return;
    }
    switch (type) {
        case luau_bindings::Type::F32:
            lua_pushnumber(lua, static_cast<double>(output.val.f));
            return;
        case luau_bindings::Type::Unknown: {
            // Unknown outputs are told apart by their bits: a plausible float reads as a float, anything else as an integer.
            const float as_float = output.val.f;
            const float magnitude = std::fabs(as_float);
            const bool  plausible = std::isnormal(as_float) && magnitude >= 1e-6F && magnitude <= 1e7F;
            if (plausible || output.val.i == 0) {
                lua_pushnumber(lua, static_cast<double>(as_float));
            } else {
                lua_pushnumber(lua, static_cast<double>(output.val.i));
            }
            return;
        }
        case luau_bindings::Type::U32:
            lua_pushnumber(lua, static_cast<double>(static_cast<std::uint32_t>(output.val.i)));
            return;
        default:
            lua_pushnumber(lua, static_cast<double>(output.val.i));
            return;
    }
}

/**
 *
 * Returns the script running native calls, raising a Luau error when none is running.
 *
 */
CRunScript *ActiveScript(lua_State *lua) {
    if (current == nullptr) {
        luaL_error(lua, "native command called outside a script");
    }
    return current;
}

/**
 *
 * Clamps a Luau number into the int range a script result holds, mapping NaN to zero.
 *
 */
int ClampToInt(double value) {
    if (std::isnan(value)) {
        return 0;
    }
    return static_cast<int>(std::clamp(value, -2147483648.0, 2147483647.0));
}

/**
 *
 * Counts the parameters of a signature that take an input (In) or return an output (Out); an in-out parameter does both.
 *
 */
std::size_t CountParams(const luau_bindings::Signature &signature, luau_bindings::Direction direction) {
    return static_cast<std::size_t>(std::count_if(signature.params.begin(), signature.params.end(), [direction](const luau_bindings::Param &param) {
        return param.direction == direction || param.direction == luau_bindings::Direction::InOut;
    }));
}

/**
 *
 * Integer or float type a command variant gives its tagged parameters, or none for the catalogued types.
 *
 */
enum class Variant : unsigned char {
    Catalogued, /**< Every parameter keeps its catalogued type. */
    Int,        /**< Tagged parameters are integers. */
    Float,      /**< Tagged parameters are floats. */
};

/**
 *
 * Name suffix of a command variant, after the command's name and before any arity suffix.
 *
 */
std::string_view VariantSuffix(Variant variant) {
    switch (variant) {
        case Variant::Int:
            return "Int";
        case Variant::Float:
            return "Float";
        default:
            return "";
    }
}

/**
 *
 * Type a parameter takes in a variant: its catalogued type, or the variant's type for a tagged parameter.
 *
 */
luau_bindings::Type ParamType(const luau_bindings::Param &param, Variant variant) {
    if (!param.tagged || variant == Variant::Catalogued) {
        return param.type;
    }
    return variant == Variant::Float ? luau_bindings::Type::F32 : luau_bindings::Type::S32;
}

/**
 *
 * Reports whether a signature has a parameter whose integer or float type the call chooses.
 *
 */
bool HasTagged(const luau_bindings::Signature &signature) {
    return std::ranges::any_of(signature.params, &luau_bindings::Param::tagged);
}

/**
 *
 * Calls a native command with a signature's parameters, typed for a variant, returning its outputs to the script.
 *
 */
int CallTyped(lua_State *lua, const luau_bindings::Command &command, const luau_bindings::Signature &signature, Variant variant) {
    const std::size_t param_count = signature.params.size();
    if (param_count > kMaxArguments) {
        const std::string message = std::format("{} takes more than {} arguments", CommandLabel(command), kMaxArguments);
        luaL_error(lua, "%s", message.c_str());
    }
    std::array<RS_STACKDATA, kMaxArguments + 1>    slots{};
    std::array<RS_STACKDATA, kMaxArguments>        outputs{};
    std::array<luau_bindings::Type, kMaxArguments> output_types{};
    std::size_t                                    output_count = 0;
    slots[0].type = RS_INT;
    slots[0].val.i = command.no;

    int next_arg = 1;
    for (std::size_t index = 0; index < param_count; ++index) {
        const luau_bindings::Param &param = signature.params[index];
        const luau_bindings::Type   type = ParamType(param, variant);
        RS_STACKDATA               &slot = slots[index + 1];
        if (param.direction == luau_bindings::Direction::In) {
            MarshalValue(lua, next_arg++, type, slot, &command);
            continue;
        }
        // The output's tag is the variable's, which a tagged handler reads to choose what it writes. An in-out output
        // holds the variable's value, which the handler reads through the reference.
        RS_STACKDATA &output = outputs[output_count];
        if (param.direction == luau_bindings::Direction::InOut) {
            MarshalValue(lua, next_arg++, type, output, &command);
        } else {
            output.type = type == luau_bindings::Type::F32 ? RS_FLOAT : RS_INT;
            output.val.i = kUnwritten;
        }
        output_types[output_count] = type;
        ++output_count;
        slot.type = RS_PTR;
        slot.val.p = &output;
    }

    CRunScript *script = ActiveScript(lua);
    if (script->skip_wait != 0) {
        // Skip mode drops the call, so every output stays as the script left it.
        for (std::size_t index = 0; index < output_count; ++index) {
            lua_pushnil(lua);
        }
        return static_cast<int>(output_count);
    }
    script->ext(slots.data(), static_cast<int>(param_count + 1));

    for (std::size_t index = 0; index < output_count; ++index) {
        PushOutput(lua, outputs[index], output_types[index]);
    }
    return static_cast<int>(output_count);
}

/**
 *
 * Calls a native command with every argument from a Luau index on, marshalled by its Luau type.
 *
 */
int CallGeneric(lua_State *lua, int no, int first, const luau_bindings::Command *command) {
    const int count = std::max(0, lua_gettop(lua) - first + 1);
    if (std::cmp_greater(count, kMaxArguments)) {
        const std::string message = std::format("native command called with more than {} arguments", kMaxArguments);
        luaL_error(lua, "%s", message.c_str());
    }
    std::array<RS_STACKDATA, kMaxArguments + 1> slots{};
    slots[0].type = RS_INT;
    slots[0].val.i = no;
    for (int offset = 0; offset < count; ++offset) {
        MarshalValue(lua, first + offset, luau_bindings::Type::Unknown, slots[static_cast<std::size_t>(offset) + 1], command);
    }
    CRunScript *script = ActiveScript(lua);
    if (script->skip_wait == 0) {
        script->ext(slots.data(), count + 1);
    }
    return 0;
}

/**
 *
 * Reads the variant a command closure was registered for from its upvalue.
 *
 */
Variant UpvalueVariant(lua_State *lua, int index) {
    return static_cast<Variant>(lua_tointegerx(lua, lua_upvalueindex(index), nullptr));
}

/**
 *
 * Lua entry point for one signature of a native command, with the command, signature and variant as upvalues.
 *
 */
int CallSignature(lua_State *lua) {
    const auto &command = *static_cast<const luau_bindings::Command *>(lua_tolightuserdata(lua, lua_upvalueindex(1)));
    const auto &signature = *static_cast<const luau_bindings::Signature *>(lua_tolightuserdata(lua, lua_upvalueindex(2)));
    return CallTyped(lua, command, signature, UpvalueVariant(lua, 3));
}

/**
 *
 * Lua entry point for a native command name, choosing the signature that matches the argument count; a variant chooses among the tagged signatures only.
 *
 */
int CallCommand(lua_State *lua) {
    const auto                     &command = *static_cast<const luau_bindings::Command *>(lua_tolightuserdata(lua, lua_upvalueindex(1)));
    const Variant                   variant = UpvalueVariant(lua, 2);
    const auto                      count = static_cast<std::size_t>(lua_gettop(lua));
    const luau_bindings::Signature *chosen = nullptr;
    std::size_t                     matches = 0;
    for (const luau_bindings::Signature &signature : command.signatures) {
        if (CountParams(signature, luau_bindings::Direction::In) != count || (variant != Variant::Catalogued && !HasTagged(signature))) {
            continue;
        }
        ++matches;
        if (chosen == nullptr || CountParams(signature, luau_bindings::Direction::Out) > CountParams(*chosen, luau_bindings::Direction::Out)) {
            chosen = &signature;
        }
    }
    if (chosen == nullptr) {
        return CallGeneric(lua, command.no, 1, &command);
    }
    if (matches > 1) {
        const std::string label = std::format("{}{}", CommandLabel(command), VariantSuffix(variant));
        if (ambiguous_commands.insert(label).second) {
            CT_LOG_WARN(Script, "luau: {}: {} arguments match {} signatures; using the one with the most outputs", label, count, matches);
        }
    }
    return CallTyped(lua, command, *chosen, variant);
}

/**
 *
 * Lua entry point for the generic call, whose first argument is the command number.
 *
 */
int CallExt(lua_State *lua) {
    const int no = static_cast<int>(luaL_checknumber(lua, 1));
    return CallGeneric(lua, no, 2, nullptr);
}

/**
 *
 * Pushes a module's compiled chunk onto lua, reusing the cached function when the file already compiled.
 *
 */
bool PushModuleFunction(lua_State *lua, const std::filesystem::path &file, std::string_view label) {
    const std::string key = Utf8(file);
    lua_getref(lua, module_cache_ref);
    lua_getfield(lua, -1, key.c_str());
    if (lua_type(lua, -1) == LUA_TFUNCTION) {
        lua_remove(lua, -2);
        return true;
    }
    lua_pop(lua, 2);

    std::ifstream input(file, std::ios::binary);
    if (!input) {
        CT_LOG_ERROR(Script, "luau: {}: cannot read {}", label, PathsDisplay(file));
        return false;
    }
    const std::string source((std::istreambuf_iterator<char>(input)), std::istreambuf_iterator<char>());

    lua_CompileOptions options{};
    options.optimizationLevel = 1;
    options.debugLevel = 1;
    std::size_t                                   bytecode_size = 0;
    char                                         *bytecode = luau_compile(source.data(), source.size(), &options, &bytecode_size);
    const std::unique_ptr<char, void (*)(void *)> bytecode_owner(bytecode, std::free);
    if (bytecode == nullptr) {
        CT_LOG_ERROR(Script, "luau: {}: cannot compile {}", label, PathsDisplay(file));
        return false;
    }

    const std::string chunk_name = "@" + PathsDisplay(file);
    if (luau_load(lua, chunk_name.c_str(), bytecode, bytecode_size, 0) != 0) {
        const char       *raw = lua_tostring(lua, -1);
        const std::string message = raw != nullptr ? raw : "unknown error";
        CT_LOG_ERROR(Script, "luau: {}: {}", label, message);
        lua_pop(lua, 1);
        return false;
    }
    if (codegen) {
        luau_codegen_compile(lua, -1);
    }
    CT_LOG_INFO(Script, "luau: compiled {}", PathsDisplay(file));

    lua_getref(lua, module_cache_ref);
    lua_pushvalue(lua, -2);
    lua_setfield(lua, -2, key.c_str());
    lua_pop(lua, 1);
    return true;
}

/**
 *
 * Lua global require, which loads "@lib/" modules once and caches what they return.
 *
 */
int Require(lua_State *lua) {
    const std::string name = luaL_checkstring(lua, 1);
    constexpr std::string_view lib_prefix = "@lib/";
    if (!std::string_view(name).starts_with(lib_prefix)) {
        luaL_error(lua, "unsupported require path");
    }
    const std::optional<std::filesystem::path> root = ScriptsRoot();
    if (!root) {
        luaL_error(lua, "require: no scripts directory");
    }
    const std::filesystem::path file = *root / "lib" / (name.substr(lib_prefix.size()) + ".luau");
    const std::string           key = Utf8(file);

    lua_getref(lua, required_ref);
    lua_getfield(lua, -1, key.c_str());
    if (lua_type(lua, -1) != LUA_TNIL) {
        lua_remove(lua, -2);
        return 1;
    }
    lua_pop(lua, 2);

    if (!PushModuleFunction(lua, file, name)) {
        const std::string message = std::format("require: cannot load {}", name);
        luaL_error(lua, "%s", message.c_str());
    }
    lua_call(lua, 0, 1);
    lua_getref(lua, required_ref);
    lua_pushvalue(lua, -2);
    lua_setfield(lua, -2, key.c_str());
    lua_pop(lua, 1);
    return 1;
}

/**
 *
 * Adds a command's entries for one variant to the namespace table on top of lua: the arity-dispatching name and one name per signature; a variant covers only the tagged signatures.
 *
 */
void RegisterCommand(lua_State *lua, const luau_bindings::Command &command, Variant variant) {
    const std::string name = std::format("{}{}", command.name, VariantSuffix(variant));
    for (const luau_bindings::Signature &signature : command.signatures) {
        if (variant != Variant::Catalogued && !HasTagged(signature)) {
            continue;
        }
        const std::string field = std::format("{}_{}", name, signature.argc);
        lua_pushlightuserdata(lua, Userdata(&command));
        lua_pushlightuserdata(lua, Userdata(&signature));
        lua_pushinteger(lua, static_cast<int>(variant));
        lua_pushcclosure(lua, CallSignature, field.c_str(), 3);
        lua_setfield(lua, -2, field.c_str());
    }
    lua_pushlightuserdata(lua, Userdata(&command));
    lua_pushinteger(lua, static_cast<int>(variant));
    lua_pushcclosure(lua, CallCommand, name.c_str(), 2);
    lua_setfield(lua, -2, name.c_str());
}

/**
 *
 * Creates one read-only global table per native namespace, holding each command, the Int and Float variants of commands with tagged parameters, and the generic Ext entry.
 *
 */
void RegisterNamespaces(lua_State *lua) {
    for (const luau_bindings::Kind &kind : luau_bindings::Kinds()) {
        lua_createtable(lua, 0, 0);
        for (const luau_bindings::Command &command : kind.commands) {
            RegisterCommand(lua, command, Variant::Catalogued);
            if (std::ranges::any_of(command.signatures, HasTagged)) {
                RegisterCommand(lua, command, Variant::Int);
                RegisterCommand(lua, command, Variant::Float);
            }
        }
        lua_pushcclosure(lua, CallExt, "Ext", 0);
        lua_setfield(lua, -2, "Ext");
        lua_setreadonly(lua, -1, 1);
        const std::string space(kind.space);
        lua_setfield(lua, LUA_GLOBALSINDEX, space.c_str());
    }
}

/**
 *
 * cmath.sinf: the C library's single-precision sine, which the interpreter's SIN calls.
 *
 */
int Sinf(lua_State *lua) {
    lua_pushnumber(lua, static_cast<double>(std::sin(static_cast<float>(luaL_checknumber(lua, 1)))));
    return 1;
}

/**
 *
 * cmath.cosf: the C library's single-precision cosine, which the interpreter's COS calls.
 *
 */
int Cosf(lua_State *lua) {
    lua_pushnumber(lua, static_cast<double>(std::cos(static_cast<float>(luaL_checknumber(lua, 1)))));
    return 1;
}

/**
 *
 * vmhost.skipping: whether the running script is in skip mode, running through its waits to the next skip end.
 *
 */
int VmHostSkipping(lua_State *lua) {
    lua_pushboolean(lua, ActiveScript(lua)->skip_wait != 0 ? 1 : 0);
    return 1;
}

/**
 *
 * vmhost.skip_end: counts a skip end; when the script was skipping it leaves skip mode and returns true, telling the module to suspend.
 *
 */
int VmHostSkipEnd(lua_State *lua) {
    CRunScript *script = ActiveScript(lua);
    ++script->skip_end_count;
    const bool was_skipping = script->skip_wait != 0;
    script->skip_wait = 0;
    lua_pushboolean(lua, was_skipping ? 1 : 0);
    return 1;
}

/**
 *
 * Creates the global vmhost table, the machine state the vm library reads and writes for skip mode.
 *
 */
void RegisterVmHost(lua_State *lua) {
    lua_createtable(lua, 0, 2);
    lua_pushcfunction(lua, VmHostSkipping, "skipping");
    lua_setfield(lua, -2, "skipping");
    lua_pushcfunction(lua, VmHostSkipEnd, "skip_end");
    lua_setfield(lua, -2, "skip_end");
    lua_setreadonly(lua, -1, 1);
    lua_setglobal(lua, "vmhost");
}

/**
 *
 * Creates the global cmath table of the C library's float functions the vm library calls.
 *
 */
void RegisterCmath(lua_State *lua) {
    lua_createtable(lua, 0, 2);
    lua_pushcfunction(lua, Sinf, "sinf");
    lua_setfield(lua, -2, "sinf");
    lua_pushcfunction(lua, Cosf, "cosf");
    lua_setfield(lua, -2, "cosf");
    lua_setreadonly(lua, -1, 1);
    lua_setglobal(lua, "cmath");
}

/**
 *
 * Creates the Luau state once: standard libraries, the interrupt hook, require, native namespaces and sandboxing.
 *
 */
lua_State *EnsureState() {
    if (state != nullptr) {
        return state;
    }
    state = luaL_newstate();
    if (state == nullptr) {
        CT_LOG_ERROR(Script, "luau: cannot create a Luau state");
        return nullptr;
    }
    luaL_openlibs(state);
    lua_pushcfunction(state, Print, "print");
    lua_setglobal(state, "print");
    lua_callbacks(state)->interrupt = Interrupt;
    lua_pushcfunction(state, Require, "require");
    lua_setglobal(state, "require");
    RegisterNamespaces(state);
    RegisterCmath(state);
    RegisterVmHost(state);

    lua_createtable(state, 0, 0);
    module_cache_ref = lua_ref(state, -1);
    lua_pop(state, 1);
    lua_createtable(state, 0, 0);
    required_ref = lua_ref(state, -1);
    lua_pop(state, 1);

    luaL_sandbox(state);
    codegen = luau_codegen_supported() != 0;
    if (codegen) {
        luau_codegen_create(state);
    }
    CT_LOG_INFO(Script, "luau: native code generation {}", codegen ? "on" : "off");
    return state;
}

/**
 *
 * Finds the instance a script's current program belongs to, or null when Luau does not own it.
 *
 */
std::shared_ptr<Instance> OwnedInstance(const CRunScript *script) {
    if (script == nullptr || script->prog == nullptr) {
        return nullptr;
    }
    const auto found = instances.find(script);
    if (found == instances.end() || found->second->program != static_cast<const void *>(script->prog)) {
        return nullptr;
    }
    return found->second;
}

/**
 *
 * Names the script field that holds a program's handler: setup for negative numbers, else the kind's name for the number.
 *
 */
std::optional<std::string_view> ProgramName(const Instance &instance, int no) {
    if (no < 0) {
        return "setup";
    }
    if (instance.kind == nullptr) {
        return std::nullopt;
    }
    const auto found = std::ranges::find(instance.kind->programs, no, &luau_bindings::Program::no);
    if (found == instance.kind->programs.end()) {
        return std::nullopt;
    }
    return found->name;
}

/**
 *
 * Labels a program's handler for diagnostics, by its name when it has one.
 *
 */
std::string HandlerLabel(const Instance &instance, int no) {
    const std::optional<std::string_view> name = ProgramName(instance, no);
    if (!name) {
        return std::format("program {}", no);
    }
    return std::format("{} ({})", *name, no);
}

/**
 *
 * Pushes the handler of program no from the instance's script table onto lua; reports whether it is a function.
 *
 */
bool PushProgram(lua_State *lua, const Instance &instance, int no) {
    lua_getref(lua, instance.script_ref);
    if (const std::optional<std::string_view> name = ProgramName(instance, no)) {
        lua_pushlstring(lua, name->data(), name->size());
        lua_rawget(lua, -2);
    } else {
        lua_rawgeti(lua, -1, no);
    }
    lua_remove(lua, -2);
    return lua_type(lua, -1) == LUA_TFUNCTION;
}

/**
 *
 * Resumes a program's coroutine and records whether the script finished, failed or suspended.
 *
 */
void Step(CRunScript *script, Instance &instance, lua_State *co, int nargs) {
    const CurrentGuard guard(script);
    remaining = budget;
    const int status = lua_resume(co, nullptr, nargs);
    if (status == LUA_YIELD) {
        lua_settop(co, 0);
        return;
    }
    script->end = 1;
    if (status == LUA_OK) {
        script->result = lua_type(co, 1) == LUA_TNUMBER ? ClampToInt(lua_tonumberx(co, 1, nullptr)) : 0;
    } else if (script->skip_wait != 0 && lua_type(co, -1) != LUA_TSTRING) {
        // A skip sentinel (a non-string error value raised by a wait in skip mode) that no section caught: retail would run on
        // linearly to the end of the program without calling anything, so the program ends quietly.
        CT_LOG_TRACE(Script, "luau: {}: skip reached the end of {}", ScriptLabel(instance.module), HandlerLabel(instance, instance.running_no));
    } else {
        const char       *raw = lua_tostring(co, -1);
        const std::string message = raw != nullptr ? raw : "unknown error";
        const char       *trace = lua_debugtrace(co);
        CT_LOG_ERROR(Script, "luau: {}: {}: {}\n{}", ScriptLabel(instance.module), HandlerLabel(instance, instance.running_no), message,
                     trace != nullptr ? trace : "");
    }
    ReleaseRef(instance.thread_ref);
}

/**
 *
 * Runs a module's chunk on a sandboxed thread and records the programs table it returns.
 *
 */
void StartInstance(CRunScript *script, Instance &instance, const std::filesystem::path &file) {
    lua_State *thread = lua_newthread(state);
    luaL_sandboxthread(thread);
    instance.env_ref = lua_ref(state, -1);
    lua_pop(state, 1);

    if (!PushModuleFunction(thread, file, ScriptLabel(instance.module))) {
        instance.broken = true;
        return;
    }
    lua_clonefunction(thread, -1);
    lua_pushvalue(thread, LUA_GLOBALSINDEX);
    lua_setfenv(thread, -2);
    {
        const CurrentGuard guard(script);
        remaining = budget;
        if (lua_pcall(thread, 0, 1, 0) != LUA_OK) {
            const char       *raw = lua_tostring(thread, -1);
            const std::string message = raw != nullptr ? raw : "unknown error";
            CT_LOG_ERROR(Script, "luau: {}: {}", ScriptLabel(instance.module), message);
            instance.broken = true;
        } else if (lua_type(thread, -1) != LUA_TTABLE) {
            CT_LOG_ERROR(Script, "luau: {}: module must return its script table", ScriptLabel(instance.module));
            instance.broken = true;
        } else {
            instance.script_ref = lua_ref(thread, -1);
        }
    }
    lua_settop(thread, 0);
}

/**
 *
 * Returns the length of a table that is a dense array of values keyed 1 through n, or nullopt when it has any other key.
 *
 */
std::optional<std::size_t> DenseArrayLength(lua_State *lua, int index) {
    const int         absolute_index = index < 0 ? lua_gettop(lua) + index + 1 : index;
    const std::size_t length = lua_objlen(lua, absolute_index);
    std::size_t       key_count = 0;
    lua_pushnil(lua);
    while (lua_next(lua, absolute_index) != 0) {
        int          is_integer = 0;
        const int    key = lua_tointegerx(lua, -2, &is_integer);
        const double number = lua_tonumberx(lua, -2, nullptr);
        if (lua_type(lua, -2) != LUA_TNUMBER || is_integer == 0 || number != static_cast<double>(key) || key < 1 ||
            std::cmp_greater(key, length)) {
            lua_pop(lua, 2);
            return std::nullopt;
        }
        ++key_count;
        lua_pop(lua, 1);
    }
    if (key_count != length) {
        return std::nullopt;
    }
    return length;
}

/**
 *
 * Reads the number at a stack index as a 32-bit integer, or nullopt when it is not an integral number in range.
 *
 */
std::optional<std::int32_t> IntegerAt(lua_State *lua, int index) {
    int          is_number = 0;
    const double number = lua_tonumberx(lua, index, &is_number);
    if (is_number == 0 || std::trunc(number) != number || number < -2147483648.0 || number > 2147483647.0) {
        return std::nullopt;
    }
    return static_cast<std::int32_t>(number);
}

/**
 *
 * The value types an argument-data entry may declare.
 *
 */
enum class EventArgType {
    Int,
    Float,
    String,
    Unknown,
};

/**
 *
 * Reads the declared type name at a stack index, or Unknown when it is not one of the argument value types.
 *
 */
EventArgType EventArgTypeAt(lua_State *lua, int index) {
    if (lua_type(lua, index) != LUA_TSTRING) {
        return EventArgType::Unknown;
    }
    std::size_t            length = 0;
    const char            *text = lua_tolstring(lua, index, &length);
    const std::string_view name(text, length);
    if (name == "int") {
        return EventArgType::Int;
    }
    if (name == "float") {
        return EventArgType::Float;
    }
    if (name == "string") {
        return EventArgType::String;
    }
    return EventArgType::Unknown;
}

/**
 *
 * Reads the typed values of an entry's args table, which sits at an absolute stack index, or nullopt when one is malformed.
 *
 */
std::optional<std::vector<luau_runtime::EventArgValue> > ParseEventArgValues(lua_State *lua, int table) {
    const std::optional<std::size_t> count = DenseArrayLength(lua, table);
    if (!count) {
        return std::nullopt;
    }
    std::vector<luau_runtime::EventArgValue> values;
    values.reserve(*count);
    for (std::size_t index = 1; index <= *count; ++index) {
        lua_rawgeti(lua, table, static_cast<int>(index));
        if (lua_type(lua, -1) != LUA_TTABLE) {
            return std::nullopt;
        }
        lua_getfield(lua, -1, "type");
        const EventArgType type = EventArgTypeAt(lua, -1);
        lua_pop(lua, 1);
        lua_getfield(lua, -1, "value");
        switch (type) {
            case EventArgType::Int: {
                const std::optional<std::int32_t> value = IntegerAt(lua, -1);
                if (!value) {
                    return std::nullopt;
                }
                values.emplace_back(*value);
                break;
            }
            case EventArgType::Float: {
                int          is_number = 0;
                const double value = lua_tonumberx(lua, -1, &is_number);
                if (is_number == 0) {
                    return std::nullopt;
                }
                values.emplace_back(static_cast<float>(value));
                break;
            }
            case EventArgType::String: {
                if (lua_type(lua, -1) != LUA_TSTRING) {
                    return std::nullopt;
                }
                std::size_t length = 0;
                const char *text = lua_tolstring(lua, -1, &length);
                values.emplace_back(std::string(text, length));
                break;
            }
            case EventArgType::Unknown:
                return std::nullopt;
        }
        lua_pop(lua, 2);
    }
    return values;
}

/**
 *
 * Reads the ordered commands of an argument-data array, which sits at an absolute stack index, or nullopt when one is malformed.
 *
 */
std::optional<std::vector<luau_runtime::EventArgAction> > ParseEventArgActions(lua_State *lua, int table) {
    const std::optional<std::size_t> count = DenseArrayLength(lua, table);
    if (!count) {
        return std::nullopt;
    }
    std::vector<luau_runtime::EventArgAction> actions;
    actions.reserve(*count);
    for (std::size_t index = 1; index <= *count; ++index) {
        lua_rawgeti(lua, table, static_cast<int>(index));
        if (lua_type(lua, -1) != LUA_TTABLE) {
            return std::nullopt;
        }
        lua_getfield(lua, -1, "command");
        const std::optional<std::int32_t> command = IntegerAt(lua, -1);
        lua_pop(lua, 1);
        lua_getfield(lua, -1, "args");
        if (!command || lua_type(lua, -1) != LUA_TTABLE) {
            return std::nullopt;
        }
        std::optional<std::vector<luau_runtime::EventArgValue> > args = ParseEventArgValues(lua, lua_gettop(lua));
        if (!args) {
            return std::nullopt;
        }
        lua_pop(lua, 2);
        actions.push_back(luau_runtime::EventArgAction{*command, std::move(*args)});
    }
    return actions;
}

} // namespace

namespace luau_runtime {

std::string MakeHandle(std::string_view module) {
    const std::size_t unpadded = kHandleTextOffset + module.size() + 1;
    const std::size_t padded = (unpadded + kHandleAlignment - 1) / kHandleAlignment * kHandleAlignment;
    std::string       handle(padded, '\0');
    const auto        length = static_cast<std::uint32_t>(module.size());
    std::memcpy(handle.data(), kHandleMagic.data(), kHandleMagic.size());
    std::memcpy(handle.data() + kHandleLengthOffset, &length, sizeof length);
    std::memcpy(handle.data() + kHandleTextOffset, module.data(), module.size());
    return handle;
}

std::optional<std::string> HandleModule(const void *program) {
    if (program == nullptr) {
        return std::nullopt;
    }
    const auto *bytes = static_cast<const char *>(program);
    if (std::memcmp(bytes, kHandleMagic.data(), kHandleMagic.size()) != 0) {
        return std::nullopt;
    }
    std::uint32_t length = 0;
    std::memcpy(&length, bytes + kHandleLengthOffset, sizeof length);
    return std::string(bytes + kHandleTextOffset, length);
}

std::optional<std::string> ModuleForScript(std::string_view key) {
    if (!ScriptVmEnabled() || !key.ends_with(".stb")) {
        return std::nullopt;
    }
    std::string module(key.substr(0, key.size() - std::string_view(".stb").size()));
    if (KindForModule(module) == nullptr) {
        return std::nullopt;
    }
    // A script on the fallback list runs on the interpreter even when an old copy of its module is still present.
    if (std::ranges::find(luau_bindings::FallbackModules(), std::string_view(module)) != luau_bindings::FallbackModules().end()) {
        return std::nullopt;
    }
    EnsureIndex();
    if (!modules.contains(module)) {
        return std::nullopt;
    }
    return module;
}

std::optional<std::vector<EventArgAction> > ReadEventArgData(std::string_view module) {
    if (EnsureState() == nullptr) {
        return std::nullopt;
    }
    EnsureIndex();
    const auto found = modules.find(std::string(module));
    if (found == modules.end()) {
        CT_LOG_ERROR(Script, "luau: {}: module not found", ScriptLabel(module));
        return std::nullopt;
    }

    // The data module runs on a throwaway sandboxed thread, released when the read ends.
    lua_State *thread = lua_newthread(state);

    struct ThreadReference {
        int ref;

        ~ThreadReference() {
            ReleaseRef(ref);
        }
    } thread_reference{lua_ref(state, -1)};

    luaL_sandboxthread(thread);
    lua_pop(state, 1);

    if (!PushModuleFunction(thread, found->second, ScriptLabel(module))) {
        return std::nullopt;
    }
    lua_clonefunction(thread, -1);
    lua_pushvalue(thread, LUA_GLOBALSINDEX);
    lua_setfenv(thread, -2);
    remaining = budget;
    if (lua_pcall(thread, 0, 1, 0) != LUA_OK) {
        const char       *raw = lua_tostring(thread, -1);
        const std::string message = raw != nullptr ? raw : "unknown error";
        CT_LOG_ERROR(Script, "luau: {}: {}", ScriptLabel(module), message);
        return std::nullopt;
    }
    if (lua_type(thread, -1) != LUA_TTABLE) {
        CT_LOG_ERROR(Script, "luau: {}: argument data must return an array", ScriptLabel(module));
        return std::nullopt;
    }
    std::optional<std::vector<EventArgAction> > actions = ParseEventArgActions(thread, lua_gettop(thread));
    if (!actions) {
        CT_LOG_ERROR(Script, "luau: {}: malformed argument data, expected {{command, args}} entries of typed values", ScriptLabel(module));
    }
    return actions;
}

void Load(CRunScript *script, std::string_view module) {
    instances.erase(script);
    auto instance = std::make_shared<Instance>();
    instance->module = std::string(module);
    instance->program = script->prog;
    instance->kind = KindForModule(instance->module);
    instances[script] = instance;

    if (EnsureState() == nullptr) {
        instance->broken = true;
    } else {
        EnsureIndex();
        const auto found = modules.find(instance->module);
        if (found == modules.end()) {
            CT_LOG_ERROR(Script, "luau: {}: module not found", ScriptLabel(instance->module));
            instance->broken = true;
        } else {
            StartInstance(script, *instance, found->second);
        }
    }
    script->end = 0;
    script->skip_wait = 0;
    script->pc = nullptr;
}

bool Owns(const CRunScript *script) {
    return OwnedInstance(script) != nullptr;
}

void Forget(CRunScript *script) {
    instances.erase(script);
}

int Run(CRunScript *script, int no) {
    const std::shared_ptr<Instance> instance = OwnedInstance(script);
    if (!instance || instance->broken || state == nullptr) {
        CT_LOG_TRACE(Script, "luau: program {} has no loaded module", no);
        return -1;
    }
    const int  top = lua_gettop(state);
    const bool exists = PushProgram(state, *instance, no);
    lua_settop(state, top);
    if (!exists) {
        if (missing_programs.insert(std::format("{}#{}", instance->module, no)).second) {
            CT_LOG_WARN(Script, "luau: {}: no handler {}", ScriptLabel(instance->module), HandlerLabel(*instance, no));
        }
        return -1;
    }

    ReleaseRef(instance->thread_ref);
    lua_State *co = lua_newthread(state);
    instance->thread_ref = lua_ref(state, -1);
    lua_pop(state, 1);
    instance->running_no = no;
    PushProgram(co, *instance, no);

    script->end = 0;
    script->result = 0;
    script->skip_wait = 0;
    script->skip_end_count = 0;
    Step(script, *instance, co, 0);
    return script->end != 0 ? 0 : 1;
}

void Resume(CRunScript *script) {
    const std::shared_ptr<Instance> instance = OwnedInstance(script);
    if (!instance || instance->broken || !HasRef(instance->thread_ref) || state == nullptr) {
        return;
    }
    lua_getref(state, instance->thread_ref);
    lua_State *co = lua_tothread(state, -1);
    lua_pop(state, 1);
    if (co == nullptr || lua_status(co) != LUA_YIELD) {
        return;
    }
    Step(script, *instance, co, 0);
}

void Skip(CRunScript *script) {
    script->skip_wait = 1;
    Resume(script);
}

bool HasProgram(const CRunScript *script, int no) {
    const std::shared_ptr<Instance> instance = OwnedInstance(script);
    if (!instance || instance->broken || no < 0 || state == nullptr) {
        return false;
    }
    const int  top = lua_gettop(state);
    const bool found = PushProgram(state, *instance, no);
    lua_settop(state, top);
    return found;
}

void SetScriptsRoot(const std::filesystem::path &root) {
    if (root.empty()) {
        root_override.reset();
    } else {
        root_override = root;
    }
    modules.clear();
    modules_indexed = false;
}

void SetInterruptBudget(std::int64_t interrupts) {
    budget = std::max<std::int64_t>(interrupts, 1);
}

void Shutdown() {
    instances.clear();
    if (state != nullptr) {
        lua_close(state);
    }
    state = nullptr;
    codegen = false;
    module_cache_ref = LUA_NOREF;
    required_ref = LUA_NOREF;
    modules.clear();
    modules_indexed = false;
}

} // namespace luau_runtime
