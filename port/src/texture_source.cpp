#include "texture_source.hpp"

#include <cstdint>
#include <cstdlib>
#include <limits>
#include <mutex>
#include <unordered_map>
#include <utility>

namespace {
/**
 * Identifies the native resource represented by a registered buffer range.
 */
struct SourceRange {
    std::string   source;       /**< Actual root-relative filename of the loaded resource. */
    std::uint64_t identity = 0; /**< Registration identity preserved across address reuse. */
    std::size_t   size = 0;     /**< Byte count associated with the registered source. */
};

/**
 *
 * Owns source metadata until both its public registry and registration tokens are released.
 *
 */
struct SourceRegistry {
    std::mutex                                    mutex;
    std::unordered_map<const void *, SourceRange> sources;
    std::uint64_t                                 next_identity = 1;
};

std::shared_ptr<SourceRegistry> Sources() {
    static auto registry = std::make_shared<SourceRegistry>();
    return registry;
}

/**
 *
 * Removes its source entry only if no newer registration replaced the same address.
 *
 */
struct SourceRegistration {
    std::shared_ptr<SourceRegistry> registry;
    const void                     *buffer;
    std::uint64_t                   identity;

    SourceRegistration(std::shared_ptr<SourceRegistry> owner, const void *address, std::uint64_t id)
        : registry(std::move(owner)), buffer(address), identity(id) {}

    SourceRegistration(const SourceRegistration &) = delete;
    SourceRegistration &operator=(const SourceRegistration &) = delete;

    ~SourceRegistration() {
        const std::lock_guard lock(registry->mutex);
        const auto            found = registry->sources.find(buffer);
        if (found != registry->sources.end() && found->second.identity == identity) {
            registry->sources.erase(found);
        }
    }
};

std::uint64_t Register(const std::shared_ptr<SourceRegistry> &registry, const void *buffer,
                       std::string source, std::size_t size) {
    const std::lock_guard lock(registry->mutex);
    if (registry->next_identity == std::numeric_limits<std::uint64_t>::max()) {
        std::abort();
    }
    const auto id = registry->next_identity++;
    registry->sources.insert_or_assign(buffer, SourceRange{.source = std::move(source), .identity = id, .size = size});
    return id;
}
} // namespace

void TextureSourceRegister(const void *buffer, std::string source, std::size_t size) {
    if (buffer != nullptr) {
        static_cast<void>(Register(Sources(), buffer, std::move(source), size));
    }
}

void TextureSourceForget(const void *buffer) {
    const auto            registry = Sources();
    const std::lock_guard lock(registry->mutex);
    registry->sources.erase(buffer);
}

void TextureSourceClear() {
    const auto            registry = Sources();
    const std::lock_guard lock(registry->mutex);
    registry->sources.clear();
}

std::optional<std::string> TextureSourceLookup(const void *buffer) {
    const auto            registry = Sources();
    const std::lock_guard lock(registry->mutex);
    const auto            found = registry->sources.find(buffer);
    if (found != registry->sources.end()) {
        return found->second.source;
    }
    return std::nullopt;
}

void TextureSourceCopy(const void *from, const void *to, std::size_t size) {
    auto source = TextureSourceLookup(from);
    if (source) {
        TextureSourceRegister(to, std::move(*source), size);
    } else {
        TextureSourceForget(to);
    }
}

std::shared_ptr<const void> dc2::assets::RegisterOwnedSource(const void *buffer, std::string source) {
    if (buffer == nullptr) {
        return {};
    }
    const auto registry = Sources();
    auto       registration = std::make_shared<SourceRegistration>(registry, buffer, 0);
    registration->identity = Register(registry, buffer, std::move(source), 0);
    return registration;
}
