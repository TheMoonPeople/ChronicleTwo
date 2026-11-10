#pragma once

#include "common.h"

#include <algorithm>
#include <array>
#include <cmath>
#include <deque>
#include <limits>
#include <span>
#include <string>
#include <vector>

#include "script/argument_view.hpp"

/**
 * @file
 * Declares the interpreter that reads tagged configuration scripts, in text or binary form, and calls a routine for each tag.
 */

/**
 *
 * Identifies the kind of value that a script argument holds.
 *
 */
enum SPI_STACK_TYPE {
    SPI_STACK_TYPE_STRING = 0,     /**< A string argument. */
    SPI_STACK_TYPE_INT = 1,        /**< A signed integer argument. */
    SPI_STACK_TYPE_FLOAT = 2,      /**< A floating-point argument. */
    SPI_STACK_TYPE_INVALID = 0xFF, /**< An argument that could not be read as any kind of value. */
};

/**
 *
 * Sizes of the storage that the interpreter keeps for searching and reading tags.
 *
 */
enum SPI_LIMIT {
    SPI_HASH_BUCKET_COUNT = 101,   /**< Number of hash chains of tag names. */
    SPI_HASH_TAG_MAX = 128,        /**< Number of tags at which the hash chains are no longer built. */
    SPI_STACK_SIZE = 64,           /**< Number of arguments one tag may have. */
    SPI_STRING_BUFF_SIZE = 0x2800, /**< Number of bytes of string argument text one tag may have. */
    SPI_TOKEN_SIZE = 0x100,        /**< Number of bytes in the local buffers that hold one word of a text script or the argument types of a binary tag. */
};

/**
 *
 * Identifies the kind of an argument in the type list of a tag in a binary script.
 *
 */
enum SPI_BINARY_ARG_TYPE {
    SPI_BINARY_ARG_TYPE_INT = 1,    /**< A four-byte integer. */
    SPI_BINARY_ARG_TYPE_FLOAT = 2,  /**< A four-byte floating-point value. */
    SPI_BINARY_ARG_TYPE_STRING = 3, /**< A zero-terminated string padded to four bytes. */
};

/**
 *
 * Reads characters one by one out of a block of script text.
 *
 */
class input_str {
public:
    char *buffer;   /**< Text being read. */
    int   size;     /**< Number of bytes in the text. */
    int   position; /**< Offset of the next byte to read. */

    /**
     *
     * Copies characters into a line buffer until a terminator string is met,
     * and passes over the terminator; gives 1 when the terminator was found
     * and 0 when the text ran out first.
     *
     * @mangled GetLine__9input_strFPciPc
     * @address 0x1466D0
     * @size 0x104
     */
    int GetLine(char *line, int line_size, char *terminator);

    /**
     *
     * Reads the next byte within the source extent and advances, returning
     * zero when the source is exhausted.
     *
     * @mangled get__9input_strFPi
     * @address 0x1467E0
     * @size 0x34
     */
    int get(int *c) {
        if (c == nullptr) {
            return 0;
        }
        if (buffer == nullptr || position < 0 || position >= size) {
            *c = 0;
            if (size >= 0 && size < std::numeric_limits<int>::max()) {
                position = size + 1;
            }
            return 0;
        }
        *c = static_cast<unsigned char>(buffer[position++]);
        return 1;
    }

    /**
     *
     * Constructs a reader with no text.
     *
     * @mangled __ct__9input_strFv
     * @address 0x146E70
     * @size 0x14
     */
    input_str() {
        size = 0;
        position = 0;
        buffer = nullptr;
    }

    /**
     *
     * Steps back over the byte read last, so that it is read again.
     *
     * @mangled back__9input_strFv
     * @address 0x1474A0
     * @size 0x1C
     */
    void back() {
        if (position > 0) {
            position--;
        }
    }
};

STATIC_ASSERT(sizeof(input_str) == 0xC);

/**
 *
 * Holds one argument of a script tag, as passed to the routine of the tag.
 *
 */
struct SPI_STACK {
    int type; /**< Kind of value held, an SPI_STACK_TYPE. */

    union {
        int   integer; /**< Value of an integer argument. */
        float real;    /**< Value of a floating-point argument. */
        char *string;  /**< Text of a string argument. */
    } value;           /**< Value of the argument. */

    /**
     *
     * Copies another argument over this one.
     *
     * @mangled __as__9SPI_STACKFRC9SPI_STACK
     * @address 0x1469B0
     * @size 0x18
     */
    SPI_STACK &operator=(const SPI_STACK &other) {
        type = other.type;
        value.string = other.value.string;
        return *this;
    }
};

STATIC_ASSERT(sizeof(SPI_STACK) == 0x8);

namespace dc2::script {

/**
 *
 * Owns initialized argument slots and their text for one interpreter invocation depth.
 *
 */
struct TagStorage {
    std::array<char, SPI_STRING_BUFF_SIZE>  strings{};      /**< Scratch text parsed for the current tag. */
    std::array<SPI_STACK, SPI_STACK_SIZE>   arguments{};    /**< Initialized arguments retained between tags. */
    std::array<std::string, SPI_STACK_SIZE> owned_text{};   /**< Text retained until its slot is overwritten. */
    std::size_t                             live_count = 0; /**< Initialized prefix available to inherited arguments. */
    std::size_t                             generation = 0; /**< Script generation that initialized these slots. */
};

/**
 *
 * Carries initialized configuration arguments and their invocation provenance.
 *
 */
using TagArguments = ArgumentView<SPI_STACK>;

/**
 *
 * Reads a finite numeric tag argument as an integer.
 *
 */
inline int TagInteger(TagArguments argument) {
    const SPI_STACK &value = argument.At();
    if (value.type == SPI_STACK_TYPE_INT) {
        return value.value.integer;
    }
    if (value.type == SPI_STACK_TYPE_FLOAT) {
        const double number = value.value.real;
        if (std::isfinite(number) && number >= std::numeric_limits<int>::min() &&
            number < static_cast<double>(std::numeric_limits<int>::max()) + 1.0) {
            return static_cast<int>(number);
        }
    }
    throw ArgumentError("tag argument is not a finite integer");
}

/**
 *
 * Reads a finite numeric tag argument as a float.
 *
 */
inline float TagFloat(TagArguments argument) {
    const SPI_STACK &value = argument.At();
    if (value.type == SPI_STACK_TYPE_INT) {
        return static_cast<float>(value.value.integer);
    }
    if (value.type == SPI_STACK_TYPE_FLOAT && std::isfinite(value.value.real)) {
        return value.value.real;
    }
    throw ArgumentError("tag argument is not a finite number");
}

/**
 *
 * Reads tag text within its owning script or parser string buffer.
 *
 */
inline std::string_view TagText(TagArguments argument) {
    const SPI_STACK &value = argument.At();
    if (value.type != SPI_STACK_TYPE_STRING) {
        throw ArgumentError("tag argument is not text");
    }
    return argument.Text(value.value.string);
}

/**
 *
 * Gives an existing C-string consumer a validated tag string.
 *
 */
inline char *TagCString(TagArguments argument) {
    const SPI_STACK &value = argument.At();
    if (value.type != SPI_STACK_TYPE_STRING) {
        throw ArgumentError("tag argument is not text");
    }
    return argument.CString(value.value.string);
}

/**
 *
 * Validates every vector component before updating its three destination coordinates.
 *
 */
inline void TagVector(float *destination, TagArguments arguments) {
    const float x = TagFloat(arguments++);
    const float y = TagFloat(arguments++);
    const float z = TagFloat(arguments);
    destination[0] = x;
    destination[1] = y;
    destination[2] = z;
}

/**
 *
 * Invokes a configuration tag with initialized slots and their exact text allocations.
 *
 */
using TagFunction = int (*)(TagArguments arguments, int count);

/**
 *
 * Rejects malformed tag arguments at the shared callback boundary.
 *
 */
int InvokeTagFunction(TagFunction function, TagArguments arguments, int count);

/**
 *
 * Normalizes a checked tag that reads its available slots from the argument view.
 *
 */
template <int (*Function)(TagArguments)>
int AdaptTagArguments(TagArguments arguments, int) { return Function(arguments); }

/**
 *
 * Normalizes a checked tag that also inspects its explicit argument count.
 *
 */
template <int (*Function)(TagArguments, int)>
int AdaptTagArguments(TagArguments arguments, int count) { return Function(arguments, count); }

} // namespace dc2::script

/**
 *
 * Routine that a script tag calls with its arguments and their count;
 * the interpreter ignores what it gives back.
 *
 */
using SPI_TAG_FUNCTION = dc2::script::TagFunction;

/**
 *
 * Names one script tag and the routine that handles it; a table of these ends with an entry whose name is null or empty.
 *
 */
struct SPI_TAG_PARAM {
    char            *name;     /**< Name of the tag, compared case-sensitively; in a text script it begins with a letter from 'A' to 'Z'. */
    SPI_TAG_FUNCTION function; /**< Routine called with the arguments of the tag, or null to ignore it. */
};

STATIC_ASSERT(sizeof(SPI_TAG_PARAM) == 0x8);

/**
 *
 * Links one tag of the tag table into a chain of the hash table that speeds up searches for tag names.
 *
 */
struct SPI_TAG_HASH {
    SPI_TAG_HASH *next;  /**< Next tag whose name has the same hash, or null. */
    char         *name;  /**< Name of the tag. */
    int           index; /**< Index of the tag in the tag table. */
    int           unk_c;
};

STATIC_ASSERT(sizeof(SPI_TAG_HASH) == 0x10);

/**
 *
 * Reads a configuration script tag by tag, gathers the arguments of each tag onto a stack, and calls the routine that the tag table gives for it.
 *
 */
class CScriptInterpreter : public input_str {
public:
    std::deque<dc2::script::TagStorage>               invocation_storage;    /**< Stable slots owned by each active callback depth. */
    std::size_t                                       invocation_depth = 0;  /**< Number of nested callbacks on this interpreter. */
    std::size_t                                       script_generation = 1; /**< Identity of the currently assigned script. */
    int                                               stack_count;           /**< Number of arguments on the stack. */
    std::size_t                                       live_stack_slots = 0;  /**< Initialized argument slots retained across tags in one script. */
    int                                               stack_size;            /**< Number of arguments the stack can hold. */
    SPI_STACK                                        *stack;                 /**< Arguments of the current tag. */
    int                                               string_buff_size;      /**< Number of bytes in the string buffer. */
    char                                             *string_buff_next{};    /**< Next free byte of the string buffer. */
    char                                             *string_buff;           /**< Storage for the text of string arguments. */
    int                                               binary;                /**< Non-zero when the script is in binary form. */
    int                                               tag_count;             /**< Number of entries in the tag table. */
    SPI_TAG_PARAM                                    *tag;                   /**< Tags the interpreter recognises. */
    SPI_TAG_HASH                                    **hash_table;            /**< Hash chains of the tag names, or null to search the tag table in order. */
    std::array<SPI_TAG_HASH *, SPI_HASH_BUCKET_COUNT> hash_buckets{};        /**< Typed heads of the owned tag chains. */
    std::vector<std::string>                          tag_names;             /**< Names retained independently of the supplied tag table. */
    std::vector<SPI_TAG_PARAM>                        owned_tags;            /**< Callback entries retained by this interpreter. */
    std::vector<SPI_TAG_HASH>                         hash_entries;          /**< Properly aligned links allocated for the actual tag count. */

    /**
     *
     * Pushes one argument onto the stack, unless the stack is full.
     *
     * @mangled PushStack__18CScriptInterpreterF9SPI_STACK
     * @address 0x146940
     * @size 0x68
     */
    void PushStack(SPI_STACK argument);

    /**
     *
     * Reads the next tag and its arguments out of the script and, when asked,
     * calls the routine of the tag; gives the index of the tag, or a negative
     * value at the end of the script.
     *
     * @mangled GetNextTAG__18CScriptInterpreterFi
     * @address 0x1469D0
     * @size 0x160
     */
    int GetNextTAG(int call);

    /**
     *
     * Gives the interpreter the storage for the arguments of a tag, and empties it.
     *
     * @mangled SetStack__18CScriptInterpreterFP9SPI_STACKi
     * @address 0x146B30
     * @size 0x10
     */
    void SetStack(SPI_STACK *stack, int size) {
        this->stack = stack;
        stack_size = size;
        stack_count = 0;
    }

    /**
     *
     * Gives the interpreter the storage for the text of string arguments, and empties it.
     *
     * @mangled SetStringBuff__18CScriptInterpreterFPci
     * @address 0x146B40
     * @size 0x14
     */
    void SetStringBuff(char *buff, int size) {
        string_buff = buff;
        string_buff_size = size;
        string_buff_next = string_buff;
    }

    /**
     *
     * Reads every tag of the script and calls the routine of each.
     *
     * @mangled Run__18CScriptInterpreterFv
     * @address 0x146B60
     * @size 0x40
     */
    void Run();

    /**
     *
     * Gives the hash chain, from 0 to 100, that a tag name belongs to.
     *
     * @mangled hash__18CScriptInterpreterFPc
     * @address 0x146BA0
     * @size 0x44
     */
    int hash(char *name);

    /**
     *
     * Gives the interpreter the table of tags it recognises, and builds the hash
     * chains of their names when the table has fewer than 128 entries.
     *
     * @mangled SetTag__18CScriptInterpreterFP13SPI_TAG_PARAM
     * @address 0x146BF0
     * @size 0x1D0
     */
    void SetTag(std::span<const SPI_TAG_PARAM> tags);

    /**
     *
     * Points the interpreter at the script it is to read, telling a binary script
     * by its "BIN" header and blanking the comments out of a text script.
     *
     * @mangled SetScript__18CScriptInterpreterFPci
     * @address 0x146DC0
     * @size 0x70
     */
    void SetScript(char *script, int script_size);

    /**
     *
     * Constructs an interpreter with no script, stack or tags.
     *
     * @mangled __ct__18CScriptInterpreterFv
     * @address 0x146E30
     * @size 0x40
     */
    CScriptInterpreter();
    CScriptInterpreter(const CScriptInterpreter &) = delete;
    CScriptInterpreter &operator=(const CScriptInterpreter &) = delete;
    CScriptInterpreter(CScriptInterpreter &&) = delete;
    CScriptInterpreter &operator=(CScriptInterpreter &&) = delete;

    /**
     *
     * Reads the arguments of a tag out of a binary script onto the stack, and
     * gives their number.
     *
     * @mangled GetArgBin__18CScriptInterpreterFv
     * @address 0x146E90
     * @size 0x21C
     */
    int GetArgBin();

    /**
     *
     * Reads the comma-separated arguments of a tag, up to its semicolon, out of
     * a text script onto the stack, and gives their number.
     *
     * @mangled GetArg__18CScriptInterpreterFv
     * @address 0x1470B0
     * @size 0x3E4
     */
    int GetArg();

    /**
     *
     * Reads the name of the next tag and finds its index in the tag table, or -1
     * for a name it does not know; gives 0 at the end of the script.
     *
     * @mangled SearchCommand__18CScriptInterpreterFPi
     * @address 0x1474C0
     * @size 0x1F8
     */
    int SearchCommand(int *tag_index);
};

STATIC_ASSERT(sizeof(CScriptInterpreter) == 0xED0);
