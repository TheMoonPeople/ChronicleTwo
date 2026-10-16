#include "texture_source.hpp"

#include <unordered_map>

namespace {
/**
 * Identifies the native resource represented by a registered buffer range.
 */
struct SourceRange {
    std::string source;   /**< Actual root-relative filename of the loaded resource. */
    std::size_t size = 0; /**< Byte extent used to resolve embedded resource offsets. */
};

/** Native buffer ranges indexed by their starting address. */
std::unordered_map<const void *, SourceRange> sources;
} // namespace

void TextureSourceRegister(const void *buffer, std::string source, std::size_t size) {
    if (buffer != nullptr) {
        sources.insert_or_assign(buffer, SourceRange{std::move(source), size});
    }
}

void TextureSourceForget(const void *buffer) { sources.erase(buffer); }

void TextureSourceClear() {
    sources.clear();
}

std::optional<std::string> TextureSourceLookup(const void *buffer) {
    const auto found = sources.find(buffer);
    if (found != sources.end()) {
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
