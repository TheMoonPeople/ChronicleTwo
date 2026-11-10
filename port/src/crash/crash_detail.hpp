#pragma once

// Pieces of the crash pipeline shared by its units and its tests.

#include <cstddef>
#include <cstdint>
#include <span>
#include <string>
#include <string_view>

#include "crash/crash.hpp"

namespace crash_detail {

inline constexpr std::size_t kSlotSize = 64; /**< Maximum bytes in a game-state value. */

/**
 * Returns the report label for a game-state key.
 */
std::string_view CrashKeyName(CrashKey key);
/**
 * Returns the report label for a failure kind.
 */
std::string_view CrashKindName(CrashKind kind);

/**
 * Copies a game-state value into the supplied fixed buffer.
 */
std::size_t ContextRead(CrashKey key, std::span<char, kSlotSize> buffer);
/**
 * Clears all recorded game-state values for tests.
 */
void ContextReset();

/**
 * Builds crash report text within a fixed buffer.
 */
class Text {
public:
    /**
     * Uses the supplied buffer for report text.
     */
    Text(char *buffer, std::size_t capacity) : data_buffer(buffer), capacity(capacity) {}

    /**
     * Appends text to the report buffer.
     */
    Text &Put(std::string_view text);
    /**
     * Appends one character to the report buffer.
     */
    Text &Put(char c);
    /**
     * Appends a decimal integer to the report buffer.
     */
    Text &Dec(long long value);
    /**
     * Appends a hexadecimal integer to the report buffer.
     */
    Text &Hex(std::uint64_t value, int min_digits = 1);
    /**
     * Appends a full-width hexadecimal pointer value.
     */
    Text &Pointer(std::uint64_t value);

    /**
     * Returns the report text written so far.
     */
    [[nodiscard]] std::string_view View() const { return {data_buffer, length}; }

    /**
     * Clears the report text without replacing the buffer.
     */
    void Clear() { length = 0; }

    /**
     * Reports whether any text exceeded the buffer capacity.
     */
    [[nodiscard]] bool Truncated() const { return truncated; }

private:
    char       *data_buffer;       /**< Storage for report text. */
    std::size_t capacity;          /**< Maximum number of text bytes. */
    std::size_t length = 0;        /**< Number of text bytes written. */
    bool        truncated = false; /**< Indicates discarded text. */
};

/**
 * Stores the identity and state printed in a report header.
 */
struct HeaderInfo {
    std::string_view kind;       /**< Failure kind label. */
    std::string_view session;    /**< Session identifier. */
    std::string_view build_id;   /**< Executable build identifier. */
    std::string_view build_type; /**< Build configuration name. */
    std::string_view platform;   /**< Host platform name. */
    std::string_view time_utc;   /**< UTC timestamp of the failure. */
    long long        frame = -1; /**< Current game frame when known. */
};

/**
 * Writes the identity and state of a crash into a report header.
 */
void FormatHeader(Text &out, const HeaderInfo &info);

/**
 * Stores private paths replaced in copied crash report text.
 */
struct RedactRoots {
    std::string save_root; /**< Game save directory. */
    std::string data_root; /**< Game data directory. */
    std::string home;      /**< User home directory. */
};

/**
 * Replaces private directory paths with report placeholders.
 */
std::string RedactPath(std::string_view text, const RedactRoots &roots);

/**
 * Returns the architecture and operating system name.
 */
std::string_view PlatformName();

/**
 * Returns the executable's build identifier.
 */
std::string_view BuildId();

} // namespace crash_detail
