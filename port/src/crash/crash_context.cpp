#include <algorithm>
#include <array>
#include <atomic>
#include <cstring>
#include <limits>

#include "crash/crash.hpp"
#include "crash/crash_detail.hpp"

namespace {

using crash_detail::kSlotSize;

constexpr std::size_t kWords = kSlotSize / sizeof(std::uint64_t); /**< Words in one game-state value. */

/**
 * Stores one game-state value for a crash report.
 */
struct Slot {
    std::atomic<std::uint32_t>                     seq{0};        /**< Detects interrupted text updates. */
    std::atomic<std::uint8_t>                      length{0};     /**< Length of the stored text. */
    std::atomic<bool>                              is_int{false}; /**< Selects an integer value. */
    std::atomic<long long>                         int_value{0};  /**< Stored integer value. */
    std::array<std::atomic<std::uint64_t>, kWords> words{};       /**< Stored text bytes. */
};

std::array<Slot, static_cast<std::size_t>(CrashKey::Count)> g_slots; /**< Values included in crash reports. */

Slot &SlotFor(CrashKey key) {
    return g_slots[static_cast<std::size_t>(key)];
}

// A failed acquisition drops a context update; a crash can interrupt its writer indefinitely.
bool BeginWrite(Slot &slot, std::uint32_t &epoch) {
    for (int attempt = 0; attempt < 8; attempt++) {
        epoch = slot.seq.load(std::memory_order_acquire);
        if ((epoch & 1U) != 0) {
            continue;
        }
        if (slot.seq.compare_exchange_weak(epoch, epoch + 1, std::memory_order_acq_rel, std::memory_order_relaxed)) {
            std::atomic_thread_fence(std::memory_order_release);
            return true;
        }
    }
    return false;
}

void EndWrite(Slot &slot, std::uint32_t epoch) {
    slot.seq.store(epoch + 2, std::memory_order_release);
}

} // namespace

void CrashContextSet(CrashKey key, std::string_view value) {
    Slot         &slot = SlotFor(key);
    std::uint32_t epoch = 0;
    if (!BeginWrite(slot, epoch)) {
        return;
    }
    const std::size_t                 length = std::min(value.size(), kSlotSize);
    std::array<std::uint64_t, kWords> packed{};
    std::memcpy(packed.data(), value.data(), length);
    for (std::size_t i = 0; i < kWords; i++) {
        slot.words[i].store(packed[i], std::memory_order_relaxed);
    }
    slot.length.store(static_cast<std::uint8_t>(length), std::memory_order_relaxed);
    slot.is_int.store(false, std::memory_order_relaxed);
    EndWrite(slot, epoch);
}

// Integer values are formatted only when a report reads them.
void CrashContextSetInt(CrashKey key, long long value) {
    Slot         &slot = SlotFor(key);
    std::uint32_t epoch = 0;
    if (!BeginWrite(slot, epoch)) {
        return;
    }
    slot.int_value.store(value, std::memory_order_relaxed);
    slot.is_int.store(true, std::memory_order_relaxed);
    EndWrite(slot, epoch);
}

namespace crash_detail {

std::size_t ContextRead(CrashKey key, std::span<char, kSlotSize> buffer) {
    Slot                             &slot = SlotFor(key);
    std::array<std::uint64_t, kWords> packed{};
    for (int attempt = 0; attempt < 8; attempt++) {
        const std::uint32_t before = slot.seq.load(std::memory_order_acquire);
        if ((before & 1U) != 0) {
            continue;
        }
        const bool        is_int = slot.is_int.load(std::memory_order_relaxed);
        const long long   int_value = slot.int_value.load(std::memory_order_relaxed);
        const std::size_t length = slot.length.load(std::memory_order_relaxed);
        for (std::size_t i = 0; i < kWords; i++) {
            packed[i] = slot.words[i].load(std::memory_order_relaxed);
        }
        std::atomic_thread_fence(std::memory_order_acquire);
        if (slot.seq.load(std::memory_order_acquire) == before) {
            if (is_int) {
                Text text(buffer.data(), buffer.size());
                text.Dec(int_value);
                return text.View().size();
            }
            std::memcpy(buffer.data(), packed.data(), length);
            return length;
        }
    }
    return 0;
}

void ContextReset() {
    for (Slot &slot : g_slots) {
        slot.seq.store(0, std::memory_order_relaxed);
        slot.is_int.store(false, std::memory_order_relaxed);
        slot.length.store(0, std::memory_order_relaxed);
        slot.int_value.store(0, std::memory_order_relaxed);
    }
}

std::string_view CrashKeyName(CrashKey key) {
    switch (key) {
        case CrashKey::Loop:
            return "loop";
        case CrashKey::Map:
            return "map";
        case CrashKey::Floor:
            return "floor";
        case CrashKey::Event:
            return "event";
        case CrashKey::Frame:
            return "frame";
        case CrashKey::Scene:
            return "scene";
        case CrashKey::LastAsset:
            return "last asset";
        case CrashKey::Fiber:
            return "fiber";
        case CrashKey::Count:
            break;
    }
    return "?";
}

Text &Text::Put(std::string_view text) {
    const std::size_t room = capacity - length;
    const std::size_t count = std::min(room, text.size());
    std::memcpy(data_buffer + length, text.data(), count);
    length += count;
    truncated = truncated || count < text.size();
    return *this;
}

Text &Text::Put(char c) {
    return Put(std::string_view(&c, 1));
}

Text &Text::Dec(long long value) {
    char               buffer[24];
    unsigned long long magnitude = value < 0 ? 0ULL - static_cast<unsigned long long>(value) : static_cast<unsigned long long>(value);
    std::size_t        at = sizeof(buffer);
    do {
        buffer[--at] = static_cast<char>('0' + magnitude % 10);
        magnitude /= 10;
    } while (magnitude != 0);
    if (value < 0) {
        buffer[--at] = '-';
    }
    return Put(std::string_view(buffer + at, sizeof(buffer) - at));
}

Text &Text::Hex(std::uint64_t value, int min_digits) {
    char        buffer[16];
    std::size_t at = sizeof(buffer);
    do {
        buffer[--at] = "0123456789abcdef"[value & 0xf];
        value >>= 4;
    } while (value != 0 || sizeof(buffer) - at < static_cast<std::size_t>(std::clamp(min_digits, 1, 16)));
    return Put(std::string_view(buffer + at, sizeof(buffer) - at));
}

Text &Text::Pointer(std::uint64_t value) {
    return Put("0x").Hex(value, 16);
}

} // namespace crash_detail
