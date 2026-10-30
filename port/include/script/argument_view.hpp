#pragma once

#include <algorithm>
#include <cstddef>
#include <cstdint>
#include <functional>
#include <optional>
#include <span>
#include <stdexcept>
#include <string_view>

namespace dc2::script {

/**
 *
 * Reports a missing or mistyped script argument to the callback boundary.
 *
 */
class ArgumentError : public std::runtime_error {
public:
    using std::runtime_error::runtime_error;
};

/**
 *
 * Carries a script handler's actual argument extent and its current position.
 *
 */
template <typename Value, typename RetainedText = std::nullptr_t>
class ArgumentView {
public:
    using RetainedTextFactory = RetainedText (*)(void *context, std::string_view text);
    using DeferredIntegerWriter = std::function<void(int)>;
    using DeferredIntegerFactory = DeferredIntegerWriter (*)(void *context, Value &value);

    explicit ArgumentView(std::span<Value> values, std::span<char> text_storage = {},
                          std::span<Value>                       writable_storage = {},
                          std::span<const std::span<const char>> other_text = {},
                          DeferredIntegerFactory deferred_factory = nullptr, void *deferred_context = nullptr,
                          RetainedTextFactory text_factory = nullptr, void *text_context = nullptr)
        : values(values), text_storage(text_storage), writable_storage(writable_storage), other_text(other_text),
          deferred_factory(deferred_factory), deferred_context(deferred_context), text_factory(text_factory), text_context(text_context) {}

    /**
     *
     * Returns one present argument or reports a missing slot.
     *
     */
    [[nodiscard]] Value &At(std::size_t offset = 0) const {
        if (offset >= Remaining()) {
            throw ArgumentError("script argument is missing");
        }
        return values[position + offset];
    }

    /**
     *
     * Gives the number of arguments remaining after the current position.
     *
     */
    [[nodiscard]] std::size_t Remaining() const { return values.size() - position; }

    /**
     *
     * Views terminated script text only within its live invocation storage.
     *
     */
    [[nodiscard]] std::string_view Text(const char *candidate) const {
        if (candidate == nullptr) {
            throw ArgumentError("script text is null");
        }
        if (const auto text = TextIn(candidate, text_storage)) {
            return *text;
        }
        for (const auto source : other_text) {
            if (const auto text = TextIn(candidate, source)) {
                return *text;
            }
        }
        throw ArgumentError("script text lies outside its source storage");
    }

    /**
     *
     * Returns a terminated C string after checking its source extent.
     *
     */
    [[nodiscard]] char *CString(const char *candidate) const {
        return const_cast<char *>(Text(candidate).data());
    }

    /**
     *
     * Resolves an output reference only within the invocation's writable slots.
     *
     */
    [[nodiscard]] Value &Writable(Value *candidate) const {
        if (candidate == nullptr || writable_storage.empty()) {
            throw ArgumentError("script output has no writable storage");
        }
        const auto begin = reinterpret_cast<std::uintptr_t>(writable_storage.data());
        const auto address = reinterpret_cast<std::uintptr_t>(candidate);
        const auto bytes = writable_storage.size_bytes();
        if (address < begin || address - begin >= bytes || (address - begin) % sizeof(Value) != 0) {
            throw ArgumentError("script output lies outside its writable slots");
        }
        return writable_storage[(address - begin) / sizeof(Value)];
    }

    /**
     *
     * Captures an output only through a producer that owns its deferred lifetime.
     *
     */
    [[nodiscard]] DeferredIntegerWriter DeferInteger(Value &value) const {
        Value &slot = Writable(&value);
        if (deferred_factory == nullptr) {
            throw ArgumentError("script output has no deferred lifetime");
        }
        auto writer = deferred_factory(deferred_context, slot);
        if (!writer) {
            throw ArgumentError("script output cannot outlive this invocation");
        }
        return writer;
    }

    /**
     *
     * Copies text through the producer that owns this invocation's persistent storage.
     *
     */
    [[nodiscard]] RetainedText RetainText(std::string_view text) const {
        if (text_factory == nullptr) {
            throw ArgumentError("script text has no retained owner");
        }
        return text_factory(text_context, text);
    }

    /**
     *
     * Advances without forming a pointer outside the argument storage.
     *
     */
    ArgumentView operator+(std::size_t count) const {
        if (count > Remaining()) {
            throw ArgumentError("script argument cursor exceeds its extent");
        }
        ArgumentView result(*this);
        result.position += count;
        return result;
    }

    /**
     *
     * Advances to the next argument while returning the current one.
     *
     */
    ArgumentView operator++(int) {
        ArgumentView previous(*this);
        *this = *this + 1;
        return previous;
    }

    /**
     *
     * Advances the cursor to the next argument.
     *
     */
    ArgumentView &operator++() {
        *this = *this + 1;
        return *this;
    }

private:
    /**
     *
     * Finds a terminated string only after its address matches a known allocation.
     *
     */
    [[nodiscard]] static std::optional<std::string_view> TextIn(const char           *candidate,
                                                                std::span<const char> source) {
        if (source.empty()) {
            return std::nullopt;
        }
        const auto begin = reinterpret_cast<std::uintptr_t>(source.data());
        const auto address = reinterpret_cast<std::uintptr_t>(candidate);
        if (address < begin || address - begin >= source.size()) {
            return std::nullopt;
        }
        const auto offset = static_cast<std::size_t>(address - begin);
        const auto text = source.subspan(offset);
        const auto end = std::ranges::find(text, char{});
        if (end == text.end()) {
            throw ArgumentError("script text is not terminated within its source storage");
        }
        return std::string_view(text.begin(), end);
    }

    std::span<Value>                       values;
    std::span<char>                        text_storage;
    std::span<Value>                       writable_storage;
    std::span<const std::span<const char>> other_text;
    DeferredIntegerFactory                 deferred_factory = nullptr;
    void                                  *deferred_context = nullptr;
    RetainedTextFactory                    text_factory = nullptr; /**< Producer that owns copied callback text. */
    void                                  *text_context = nullptr; /**< Live producer used only during this invocation. */
    std::size_t                            position = 0;
};

} // namespace dc2::script
