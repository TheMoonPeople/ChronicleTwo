#pragma once

#include <span>
#include <string_view>

/**
 *
 * Native script commands the Luau runtime exposes, generated from tools/luau/commands.json.
 *
 */
namespace luau_bindings {

/**
 *
 * Whether a command parameter is read by the handler or written through a reference.
 *
 */
enum class Direction : unsigned char {
    In,    /**< Passed to the handler as a value. */
    Out,   /**< Written by the handler through a reference and returned to the script. */
    InOut, /**< Passed through a reference that the handler reads and writes, and returned to the script. */
};

/**
 *
 * Script-side type of a command parameter.
 *
 */
enum class Type : unsigned char {
    S8,      /**< Signed 8-bit integer. */
    U8,      /**< Unsigned 8-bit integer. */
    S16,     /**< Signed 16-bit integer. */
    U16,     /**< Unsigned 16-bit integer. */
    S32,     /**< Signed 32-bit integer. */
    U32,     /**< Unsigned 32-bit integer. */
    F32,     /**< 32-bit float. */
    String,  /**< Text, passed to the handler in CP932. */
    Boolean, /**< Truth value, passed as 0 or 1. */
    Array,   /**< Table passed by reference. */
    Unknown, /**< Type the catalog could not establish. */
};

/**
 *
 * One parameter of a command signature.
 *
 */
struct Param {
    Direction direction;      /**< Whether the handler reads the argument or writes it through a reference. */
    Type      type;           /**< Script-side type of the argument. */
    bool      tagged = false; /**< Whether the handler reads the slot's integer or float tag, so each call chooses the type. */
};

/**
 *
 * One accepted argument count of a command, with its parameters.
 *
 */
struct Signature {
    int                    argc;     /**< Number of arguments the script passes. */
    bool                   rejected; /**< Whether the handler refuses this argument count. */
    std::span<const Param> params;   /**< Parameters in argument order. */
};

/**
 *
 * A native command registered under a kind.
 *
 */
struct Command {
    std::string_view           name;       /**< Name scripts call the command by, within its namespace. */
    int                        no;         /**< Command number within its kind. */
    std::span<const Signature> signatures; /**< Accepted argument counts, sorted by argc. */
};

/**
 *
 * A script program the engine runs by number, with the handler name scripts define it under.
 *
 */
struct Program {
    int              no;   /**< Program number the engine passes to run(). */
    std::string_view name; /**< Field of the script table that holds the handler. */
};

/**
 *
 * A group of commands that share a global table.
 *
 */
struct Kind {
    std::string_view         name;       /**< Kind name used by the catalog. */
    std::string_view         space;      /**< Global table the kind's commands are registered in. */
    int                      table_size; /**< Size of the kind's retail external-function table. */
    std::span<const Command> commands;   /**< Commands in the kind, sorted by number. */
    std::span<const Program> programs;   /**< Named programs, sorted by number. */
};

/**
 *
 * Every kind whose commands the runtime registers, in the order the build lists them.
 *
 */
std::span<const Kind> Kinds();

/**
 *
 * Module keys of the scripts tools/luau/fallback.json keeps on the interpreter, which the runtime never loads as modules.
 *
 */
std::span<const std::string_view> FallbackModules();

} // namespace luau_bindings
