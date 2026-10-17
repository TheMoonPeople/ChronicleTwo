#include "dungeon_read_buffer.hpp"

#ifdef PORT

#include <cstdio>
#include <cstdlib>

namespace {

u_long128 *g_read_base = nullptr;
int          g_read_quadwords = 0;

} // namespace

void PortSetDungeonReadBuffer(u_long128 *base, int quadwords) {
    g_read_base = base;
    g_read_quadwords = quadwords;
}

bool PortDungeonReadBufferContains(const void *ptr) {
    if (g_read_base == nullptr || g_read_quadwords <= 0) {
        return true;
    }
    const u8 *const begin = reinterpret_cast<const u8 *>(g_read_base);
    const u8 *const end = begin + static_cast<size_t>(g_read_quadwords) * 16;
    const u8 *const p = static_cast<const u8 *>(ptr);
    return p >= begin && p < end;
}

void PortAssertDungeonReadCursor(const void *cursor) {
    if (!PortDungeonReadBufferContains(cursor)) {
        std::fprintf(stderr, "port: dungeon map staging overflow at %p (buffer %p, %d qw)\n", cursor, g_read_base,
                     g_read_quadwords);
        std::abort();
    }
}

#endif
