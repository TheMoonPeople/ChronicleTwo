#include "options/retail_system_mes.hpp"

#ifdef PORT

#include <algorithm>
#include <cstring>

#include "font.hpp"
#include "options/registry.hpp"
#include "sysmes.hpp"

namespace {
constexpr u16 kMesNewline = 0xFF00;
constexpr u16 kMesEnd = 0xFF01;
constexpr std::size_t kMaxOverrides = 8;
constexpr std::size_t kOverrideWords = 40;
constexpr int         kSystemMesBufferWords = 0x6800;

struct Override {
    int line_id = -1;
    u16 text[kOverrideWords]{};
};

Override g_overrides[kMaxOverrides];

int EncodedLabelWordCount(const u16 *text) {
    if (text == nullptr) {
        return 0;
    }
    int words = 0;
    while (text[words] != kMesEnd && words < static_cast<int>(kOverrideWords)) {
        words++;
    }
    return words + 1;
}

std::size_t EncodeLineGlyphs(u16 *out, std::size_t cap, const char *label) {
    std::size_t i = 0;
    for (; label != nullptr && *label != '\0' && i < cap; ++label) {
        const unsigned char ch = static_cast<unsigned char>(*label);
        if (ch == ' ') {
            const int half = GetHalfFontNo(' ');
            if (half > 0) {
                out[i++] = static_cast<u16>(half);
            }
            continue;
        }
        if ((ch >= 'A' && ch <= 'Z') || (ch >= 'a' && ch <= 'z')) {
            const u16 no = GetAlphabeticalFontNo_uc(ch);
            if (no != 0) {
                out[i++] = no;
                continue;
            }
        }
        const int half = GetHalfFontNo(*label);
        if (half > 0) {
            out[i++] = static_cast<u16>(half);
            continue;
        }
        const u16 no = GetAlphabeticalFontNo_uc(ch);
        if (no != 0) {
            out[i++] = no;
        }
    }
    return i;
}

u16 *MessageEndMarker(u16 *from) {
    u16 *cursor = from;
    while (*cursor != kMesEnd) {
        ++cursor;
    }
    return cursor;
}

bool LineGlyphsMatch(const u16 *line, const u16 *encoded, std::size_t encoded_len) {
    for (std::size_t i = 0; i < encoded_len; ++i) {
        if (line[i] != encoded[i]) {
            return false;
        }
    }
    return true;
}

void EncodeHalfWidthLabel(u16 *out, std::size_t cap, const char *label) {
    std::size_t i = 0;
    for (; label != nullptr && *label != '\0' && i + 2 < cap; ++label) {
        const unsigned char ch = static_cast<unsigned char>(*label);
        if (ch >= 'A' && ch <= 'Z') {
            const u16 no = GetAlphabeticalFontNo_uc(ch);
            if (no != 0) {
                out[i++] = no;
                continue;
            }
        }
        if (ch >= 'a' && ch <= 'z') {
            const u16 no = GetAlphabeticalFontNo_uc(ch);
            if (no != 0) {
                out[i++] = no;
                continue;
            }
        }
        int half = GetHalfFontNo(*label);
        if (half > 0) {
            out[i++] = static_cast<u16>(half);
            continue;
        }
        const u16 no = GetAlphabeticalFontNo_uc(ch);
        if (no != 0) {
            out[i++] = no;
        }
    }
    out[i++] = kMesNewline;
    out[i++] = kMesEnd;
}

u16 *MenuMessageText(short *table, int message_id) {
    if (table == nullptr || message_id <= 0) {
        return nullptr;
    }
    // Matches ClsMes::GetTextLineDataTop: entries[i*2+1] is the id, entries[i*2+2] the offset.
    const int count = table[0];
    for (int i = 0; i < count; i++) {
        const int line_id = table[2 + 2 * i];
        if (line_id == message_id) {
            const int offset = table[3 + 2 * i];
            return reinterpret_cast<u16 *>(table + 1 + count + offset);
        }
    }
    return nullptr;
}

u16 *SystemMessageText(short *table, int line_id) {
    if (table == nullptr || line_id <= 0) {
        return nullptr;
    }
    const int count = table[0];
    short    *entries = table + 1;
    for (int i = 0; i < count; i++) {
        if (line_id == static_cast<int>(static_cast<unsigned short>(entries[i * 2 + 1]))) {
            const int offset = static_cast<unsigned short>(entries[i * 2 + 2]);
            return reinterpret_cast<u16 *>(entries + count + offset);
        }
    }
    return nullptr;
}

bool SystemLineExists(short *table, int line_id) {
    return SystemMessageText(table, line_id) != nullptr;
}

int SystemPoolUsedWords(short *table) {
    const int count = table[0];
    if (count <= 0) {
        return 0;
    }
    short *entries = table + 1;
    int    used = 0;
    for (int i = 0; i < count; i++) {
        const int offset = static_cast<unsigned short>(entries[i * 2 + 2]);
        const u16 *text =
            reinterpret_cast<u16 *>(entries + count + offset);
        used = std::max(used, offset + EncodedLabelWordCount(text));
    }
    return used;
}

bool AppendSystemLine(short *table, int line_id, const u16 *encoded) {
    if (table == nullptr || line_id <= 0 || encoded == nullptr) {
        return false;
    }
    if (SystemLineExists(table, line_id)) {
        return true;
    }

    const int words = EncodedLabelWordCount(encoded);
    if (words <= 0) {
        return false;
    }

    int count = table[0];
    if (count < 0) {
        return false;
    }

    const int pool_start = 1 + 2 * count;
    const int pool_used = SystemPoolUsedWords(table);
    const int new_offset = pool_used;
    const int end_index = pool_start + 2 + pool_used + words;
    if (end_index >= kSystemMesBufferWords) {
        return false;
    }

    std::memmove(&table[pool_start + 2], &table[pool_start],
                 static_cast<std::size_t>(pool_used) * sizeof(short));

    count += 1;
    table[0] = static_cast<short>(count);
    short *entries = table + 1;
    entries[(count - 1) * 2 + 1] = static_cast<short>(line_id);
    entries[(count - 1) * 2 + 2] = static_cast<short>(new_offset);

    u16 *dest = reinterpret_cast<u16 *>(entries + count + new_offset);
    std::memcpy(dest, encoded, static_cast<std::size_t>(words) * sizeof(u16));
    return true;
}

} // namespace

int PortRetailSyntheticSysMesId(int retail_row) { return 0x7F00 + retail_row; }

void PortRetailClearSystemMessageOverrides() {
    for (auto &entry : g_overrides) {
        entry.line_id = -1;
        entry.text[0] = kMesEnd;
    }
}

void PortRetailRegisterSystemMessageOverride(int line_id, const char *label) {
    if (line_id <= 0 || label == nullptr) {
        return;
    }
    for (auto &entry : g_overrides) {
        if (entry.line_id == line_id) {
            EncodeHalfWidthLabel(entry.text, kOverrideWords, label);
            return;
        }
    }
    for (auto &entry : g_overrides) {
        if (entry.line_id < 0) {
            entry.line_id = line_id;
            EncodeHalfWidthLabel(entry.text, kOverrideWords, label);
            return;
        }
    }
}

u16 *PortRetailSystemMessageOverride(int line_id) {
    if (line_id <= 0) {
        return nullptr;
    }
    for (const auto &entry : g_overrides) {
        if (entry.line_id == line_id) {
            return const_cast<u16 *>(entry.text);
        }
    }
    return nullptr;
}

bool PortRetailReplaceMenuMessageLine(short *menu_table, int message_id, int line_index, const char *label) {
    if (menu_table == nullptr || message_id <= 0 || label == nullptr || line_index < 0) {
        return false;
    }
    u16 *text = MenuMessageText(menu_table, message_id);
    if (text == nullptr) {
        return false;
    }

    u16 encoded[32];
    const std::size_t encoded_len = EncodeLineGlyphs(encoded, std::size(encoded), label);
    if (encoded_len == 0) {
        return false;
    }

    u16 *line_start = text;
    int  current_line = 0;

    for (u16 *cursor = text;; ++cursor) {
        const u16 code = *cursor;
        if (code == kMesEnd || code == kMesNewline) {
            if (current_line == line_index) {
                const int old_len = static_cast<int>(cursor - line_start);
                if (LineGlyphsMatch(line_start, encoded, encoded_len)) {
                    return false;
                }
                const int delta = static_cast<int>(encoded_len) - old_len;
                if (delta != 0) {
                    u16 *const tail = cursor;
                    u16 *const end = MessageEndMarker(tail);
                    const std::size_t tail_words =
                        static_cast<std::size_t>(end - tail + 1);
                    std::memmove(tail + delta, tail, tail_words * sizeof(u16));
                }
                std::memcpy(line_start, encoded, encoded_len * sizeof(u16));
                return true;
            }
            if (code == kMesEnd) {
                return false;
            }
            current_line++;
            line_start = cursor + 1;
            continue;
        }
    }
}

void PortRetailInstallHostOptionSystemLines() {
    short *table = GetSystemMesBuffer();
    if (table == nullptr) {
        return;
    }
    for (const auto &entry : port_settings::Descriptors()) {
        if (!port_settings::HasSurface(entry.surfaces, port_settings::Surface::Retail)) {
            continue;
        }
        const int line_id = PortRetailSyntheticSysMesId(entry.retail_row);
        PortRetailRegisterSystemMessageOverride(line_id, entry.label);
        u16 *encoded = PortRetailSystemMessageOverride(line_id);
        if (encoded != nullptr) {
            AppendSystemLine(table, line_id, encoded);
        }
    }
}

#endif
