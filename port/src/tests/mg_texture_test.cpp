#include <gtest/gtest.h>
#include <nlohmann/json.hpp>

#include <algorithm>
#include <array>
#include <chrono>
#include <cstddef>
#include <cstdint>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <iterator>
#include <random>
#include <string>
#include <vector>

#include "gfx/displaylist.hpp"
#include "gfx/gfx.hpp"
#include "gfx/tim2.hpp"
#include "gfx_fixture.hpp"
#include "menu_mouse.hpp"
#include "mg_drawprim.hpp"
#include "mg_memory.hpp"
#include "mg_tanime.hpp"
#include "mg_texture.hpp"
#include "mg_texture_port.hpp"
#include "mglib.hpp"
#include "mglib_port.hpp"
#include "platform/clock.hpp"
#include "platform/datapacks.hpp"
#include "platform/input.hpp"
#include "platform/texture_catalog.hpp"
#include "texture_color.hpp"
#include "texture_source.hpp"

namespace {

using Quads = std::vector<u_long128>;
using Texel4 = std::array<uint8_t, 4>;
using Levels = std::array<u_long128 *, MG_TEXTURE_LEVEL_MAX>;

constexpr int    kTextureCount = 64;
constexpr int    kBlockCount = 8;
constexpr size_t kStorageQuads = 4096;

// The retail converter the game runs on 8-bit pixels stored in 32-bit page order, copied from
// ps2/src/mg_texture.cpp as the reference Unswizzle8 is checked against.
/**
 *
 * Maps texels in alternating 32-bit columns to their 8-bit block positions.
 *
 */
u_char lut_1246[128] __attribute__((aligned(16))) = {
    0x00,
    0x24,
    0x08,
    0x2C,
    0x01,
    0x25,
    0x09,
    0x2D,
    0x02,
    0x26,
    0x0A,
    0x2E,
    0x03,
    0x27,
    0x0B,
    0x2F,
    0x04,
    0x20,
    0x0C,
    0x28,
    0x05,
    0x21,
    0x0D,
    0x29,
    0x06,
    0x22,
    0x0E,
    0x2A,
    0x07,
    0x23,
    0x0F,
    0x2B,
    0x10,
    0x34,
    0x18,
    0x3C,
    0x11,
    0x35,
    0x19,
    0x3D,
    0x12,
    0x36,
    0x1A,
    0x3E,
    0x13,
    0x37,
    0x1B,
    0x3F,
    0x14,
    0x30,
    0x1C,
    0x38,
    0x15,
    0x31,
    0x1D,
    0x39,
    0x16,
    0x32,
    0x1E,
    0x3A,
    0x17,
    0x33,
    0x1F,
    0x3B,
    0x04,
    0x20,
    0x0C,
    0x28,
    0x05,
    0x21,
    0x0D,
    0x29,
    0x06,
    0x22,
    0x0E,
    0x2A,
    0x07,
    0x23,
    0x0F,
    0x2B,
    0x00,
    0x24,
    0x08,
    0x2C,
    0x01,
    0x25,
    0x09,
    0x2D,
    0x02,
    0x26,
    0x0A,
    0x2E,
    0x03,
    0x27,
    0x0B,
    0x2F,
    0x14,
    0x30,
    0x1C,
    0x38,
    0x15,
    0x31,
    0x1D,
    0x39,
    0x16,
    0x32,
    0x1E,
    0x3A,
    0x17,
    0x33,
    0x1F,
    0x3B,
    0x10,
    0x34,
    0x18,
    0x3C,
    0x11,
    0x35,
    0x19,
    0x3D,
    0x12,
    0x36,
    0x1A,
    0x3E,
    0x13,
    0x37,
    0x1B,
    0x3F,
};

/**
 *
 * Maps row-major 8-bit blocks to their GS page block numbers.
 *
 */
int block_table8_1266[32] __attribute__((aligned(16))) = {
    0,
    1,
    4,
    5,
    16,
    17,
    20,
    21,
    2,
    3,
    6,
    7,
    18,
    19,
    22,
    23,
    8,
    9,
    12,
    13,
    24,
    25,
    28,
    29,
    10,
    11,
    14,
    15,
    26,
    27,
    30,
    31,
};

/**
 *
 * Maps row-major 32-bit blocks to their GS page block numbers.
 *
 */
int block_table32_1267[32] __attribute__((aligned(16))) = {
    0,
    1,
    4,
    5,
    16,
    17,
    20,
    21,
    2,
    3,
    6,
    7,
    18,
    19,
    22,
    23,
    8,
    9,
    12,
    13,
    24,
    25,
    28,
    29,
    10,
    11,
    14,
    15,
    26,
    27,
    30,
    31,
};

/**
 *
 * Reorders one block of 8-bit pixels stored in 32-bit page order back
 * into linear order.
 *
 */
// Each block is four columns of 64 bytes; odd columns use the second half of the table.
int BlockConv32to8(u_char *src, u_char *dst) {
    u_int column = 0;
    u_int texel = 0;
    u_int row = 0;
    int   lut_index = 0;
    int   src_index = 0;
    src_index = 0;

    for (row = 0; row < 4; row++) {
        lut_index = (row & 1) << 6;

        for (column = 0; column < 16; column++) {
            for (texel = 0; texel < 4; texel++) {
                u_char dst_index = lut_1246[lut_index];
                lut_index++;
                dst[dst_index] = src[src_index];
                src_index++;
            }
        }

        dst += 0x40;
    }

    return 0;
}

/**
 *
 * Reorders one page of 8-bit pixels stored in 32-bit page order back
 * into linear order, block by block.
 *
 */
int PageConv32to8(int width, int height, u_char *src, u_char *dst) {
    int     block_column[32];
    int     block_row[32];
    u_char  block_out[0x100];
    u_char  block_in[0x100];
    int     index = 0;
    int     row = 0;
    int     column = 0;
    int     line = 0;
    int     blocks_wide = 0;
    u_char *block_ptr = nullptr;
    u_char *page_ptr = nullptr;
    int     blocks_high = 0;
    int     block = 0;

    index = 0;

    for (row = 0; row < 4; row++) {
        for (column = 0; column < 8; column++) {
            int entry = block_table32_1267[index];
            block_column[entry] = column;
            block_row[entry] = row;
            index++;
        }
    }

    blocks_wide = width / 16;
    blocks_high = height / 16;
    memset(block_out, 0, sizeof(block_out));
    memset(block_in, 0, sizeof(block_in));

    for (row = 0; row < blocks_high; row++) {
        for (column = 0; column < blocks_wide; column++) {
            block = block_table8_1266[column + row * blocks_wide];
            block_ptr = block_in;
            page_ptr = src + (block_row[block] << 11) + (block_column[block] << 5);

            for (line = 0; line < 8; line++) {
                memcpy(block_ptr, page_ptr, 0x20);
                block_ptr += 0x20;
                page_ptr += 0x100;
            }

            BlockConv32to8(block_in, block_out);
            block_ptr = block_out;
            page_ptr = dst + (row << 11) + column * 0x10;

            for (line = 0; line < 0x10; line++) {
                memcpy(page_ptr, block_ptr, 0x10);
                block_ptr += 0x10;
                page_ptr += 0x80;
            }
        }
    }

    return 0;
}

/**
 *
 * Converts 8-bit pixels stored in 32-bit page order back into linear
 * order in place; gives 0 when the image is too large to convert.
 *
 */
int Conv32To8(int width, int height, u_char *image) {
    static u_char conv_work[0x10000];
    u_char        work8[0x2000];
    u_char        work32[0x2000];
    int           k = 0;
    int           pages_x = 0;
    int           row_count = 0;
    int           row_bytes = 0;
    int           j = 0;
    int           i = 0;
    int           pages_y = 0;
    u_char       *source_cursor = nullptr;
    int           size = 0;
    u_char       *work_cursor = nullptr;
    int           page_width = 0;
    u_char       *destination_cursor = nullptr;

    size = width * height;

    if (size > 0x10000) {
        return 0;
    }

    memset(work8, 0, sizeof(work8));
    memset(work32, 0, sizeof(work32));
    pages_x = (width - 1) / 128 + 1;
    pages_y = (height - 1) / 64 + 1;

    page_width = 128;
    row_bytes = 256;

    if (pages_x == 1) {
        row_bytes = width * 2;
    } else {
        width = page_width;
    }

    if (pages_y == 1) {
        row_count = height / 2;
    } else {
        height = 64;
        row_count = 32;
    }

    for (i = 0; i < pages_y; i++) {
        for (j = 0; j < pages_x; j++) {
            source_cursor = image + i * (pages_x * (row_bytes * row_count)) + row_bytes * j;
            work_cursor = work32;

            for (k = 0; k < row_count; k++) {
                memcpy(work_cursor, source_cursor, row_bytes);
                source_cursor += row_bytes * pages_x;
                work_cursor += 256;
            }

            PageConv32to8(128, 64, work32, work8);
            destination_cursor = conv_work + i * (pages_x * (width * 64)) + width * j;
            work_cursor = work8;

            for (k = 0; k < height; k++) {
                memcpy(destination_cursor, work_cursor, width);
                destination_cursor += width * pages_x;
                work_cursor += 128;
            }
        }
    }

    memcpy(image, conv_work, size);
    return 1;
}

template <class T>
uint32_t U(T value) {
    return static_cast<uint32_t>(value);
}

Quads Pack(const std::vector<uint8_t> &bytes) {
    Quads quads((bytes.size() + 15) / 16 + 1, 0);
    std::memcpy(quads.data(), bytes.data(), bytes.size());
    return quads;
}

void PutLe(std::vector<uint8_t> &buf, size_t offset, uint64_t value, size_t bytes) {
    for (size_t i = 0; i < bytes; i++) {
        buf[offset + i] = static_cast<uint8_t>(value >> (8 * i));
    }
}

std::vector<uint8_t> Ct32Pixels(uint32_t width, uint32_t height) {
    std::vector<uint8_t> out(static_cast<size_t>(width) * height * 4);
    for (uint32_t y = 0; y < height; y++) {
        for (uint32_t x = 0; x < width; x++) {
            uint8_t *p = &out[(static_cast<size_t>(y) * width + x) * 4];
            p[0] = static_cast<uint8_t>(x * 40);
            p[1] = static_cast<uint8_t>(y * 40);
            p[2] = 0x10;
            p[3] = 0x80;
        }
    }
    return out;
}

struct TimPicture {
    uint8_t                            image_type = TIM2_RGB32;
    uint16_t                           width = 0;
    uint16_t                           height = 0;
    std::vector<std::vector<uint8_t> > levels;
    std::vector<uint8_t>               clut;
    uint64_t                           tex1 = 0;
};

std::vector<uint8_t> BuildPicture(const TimPicture &picture) {
    const bool   mipmapped = picture.levels.size() > 1;
    const size_t header = mipmapped ? 0x60 : 0x30;
    size_t       image_bytes = 0;
    for (const std::vector<uint8_t> &level : picture.levels) {
        image_bytes += level.size();
    }

    std::vector<uint8_t> out(header + image_bytes + picture.clut.size(), 0);
    PutLe(out, 0x00, out.size(), 4);
    PutLe(out, 0x04, picture.clut.size(), 4);
    PutLe(out, 0x08, image_bytes, 4);
    PutLe(out, 0x0C, header, 2);
    out[0x11] = static_cast<uint8_t>(picture.levels.size());
    out[0x12] = 3;
    out[0x13] = picture.image_type;
    PutLe(out, 0x14, picture.width, 2);
    PutLe(out, 0x16, picture.height, 2);
    PutLe(out, 0x20, picture.tex1, 8);

    size_t at = header;
    for (size_t i = 0; i < picture.levels.size(); i++) {
        if (mipmapped) {
            PutLe(out, 0x40 + 4 * i, picture.levels[i].size(), 4);
        }
        std::copy(picture.levels[i].begin(), picture.levels[i].end(), out.begin() + static_cast<std::ptrdiff_t>(at));
        at += picture.levels[i].size();
    }
    std::ranges::copy(picture.clut, out.begin() + static_cast<std::ptrdiff_t>(at));
    return out;
}

std::vector<uint8_t> Tim2File(const TimPicture &picture) {
    const std::vector<uint8_t> body = BuildPicture(picture);
    std::vector<uint8_t>       file(0x10, 0);
    std::memcpy(file.data(), "TIM2", 4);
    file[4] = 4;
    PutLe(file, 6, 1, 2);
    file.insert(file.end(), body.begin(), body.end());
    return file;
}

struct NamedFile {
    std::string          name;
    std::vector<uint8_t> tim2;
};

std::vector<uint8_t> Im2Archive(const std::vector<NamedFile> &files) {
    std::vector<uint8_t> out(0x10 + 0x30 * files.size(), 0);
    std::memcpy(out.data(), "IM2", 4);
    PutLe(out, 4, files.size(), 4);
    for (size_t i = 0; i < files.size(); i++) {
        const size_t entry = 0x10 + 0x30 * i;
        std::memcpy(&out[entry], files[i].name.data(), files[i].name.size());
        while (out.size() % 16 != 0) {
            out.push_back(0);
        }
        PutLe(out, entry + 0x20, out.size(), 4);
        out.insert(out.end(), files[i].tim2.begin(), files[i].tim2.end());
    }
    return out;
}

// The manager over a quadword buffer; Initialize releases its textures while the renderer is still up.
class Harness {
public:
    Harness() {
        memory.stSetBuffer(storage.data(), static_cast<int>(kStorageQuads));
        manager.SetTableBuffer(kTextureCount, kBlockCount, &memory);
        manager.Initialize(0x1000, -1);
    }

    ~Harness() {
        manager.Initialize(0x1000, -1);
    }

    Harness(const Harness &) = delete;
    Harness &operator=(const Harness &) = delete;

    Quads             storage = Quads(kStorageQuads, 0);
    mgCMemory         memory;
    mgCTextureManager manager;
};

void WriteRgbaPng(const std::filesystem::path &path, uint32_t width, uint32_t height,
                  const std::vector<uint8_t> &rgba) {
    auto big = [](std::vector<uint8_t> &out, uint32_t value) {
        out.push_back(static_cast<uint8_t>(value >> 24));
        out.push_back(static_cast<uint8_t>(value >> 16));
        out.push_back(static_cast<uint8_t>(value >> 8));
        out.push_back(static_cast<uint8_t>(value));
    };
    auto chunk = [&big](std::vector<uint8_t> &out, const char *name, const std::vector<uint8_t> &payload) {
        big(out, static_cast<uint32_t>(payload.size()));
        const size_t first = out.size();
        out.insert(out.end(), name, name + 4);
        out.insert(out.end(), payload.begin(), payload.end());
        uint32_t crc = ~uint32_t{0};
        for (size_t i = first; i < out.size(); ++i) {
            crc ^= out[i];
            for (int bit = 0; bit < 8; ++bit) {
                crc = (crc >> 1) ^ (crc & 1 ? 0xEDB88320u : 0);
            }
        }
        big(out, ~crc);
    };
    std::vector<uint8_t> raw;
    for (uint32_t y = 0; y < height; ++y) {
        raw.push_back(0);
        raw.insert(raw.end(), rgba.begin() + static_cast<size_t>(y) * width * 4,
                   rgba.begin() + static_cast<size_t>(y + 1) * width * 4);
    }
    std::vector<uint8_t> compressed{0x78, 0x01};
    for (size_t pos = 0; pos < raw.size();) {
        const size_t count = std::min<size_t>(raw.size() - pos, 65535);
        compressed.push_back(pos + count == raw.size() ? 1 : 0);
        compressed.push_back(static_cast<uint8_t>(count));
        compressed.push_back(static_cast<uint8_t>(count >> 8));
        compressed.push_back(static_cast<uint8_t>(~count));
        compressed.push_back(static_cast<uint8_t>(~count >> 8));
        compressed.insert(compressed.end(), raw.begin() + pos, raw.begin() + pos + count);
        pos += count;
    }
    uint32_t a = 1;
    uint32_t b = 0;
    for (uint8_t value : raw) {
        a = (a + value) % 65521;
        b = (b + a) % 65521;
    }
    big(compressed, (b << 16) | a);
    std::vector<uint8_t> png{137, 80, 78, 71, 13, 10, 26, 10};
    std::vector<uint8_t> header;
    big(header, width);
    big(header, height);
    header.insert(header.end(), {8, 6, 0, 0, 0});
    chunk(png, "IHDR", header);
    chunk(png, "IDAT", compressed);
    chunk(png, "IEND", {});
    std::ofstream file(path, std::ios::binary);
    file.write(reinterpret_cast<const char *>(png.data()), static_cast<std::streamsize>(png.size()));
    ASSERT_TRUE(file.good());
}

class CatalogFixture {
public:
    CatalogFixture() {
        static int next = 0;
        directory = std::filesystem::temp_directory_path() / ("ct_texture_catalog_" + std::to_string(std::chrono::steady_clock::now().time_since_epoch().count()) + "_" + std::to_string(++next)) / "data";
        std::filesystem::create_directories(directory);
    }

    ~CatalogFixture() {
        datapacks::Clear();
        texture_catalog::Clear();
        TextureSourceClear();
        std::error_code error;
        std::filesystem::remove_all(directory.parent_path(), error);
    }

    void Rgba(const std::string &name, uint32_t width, uint32_t height, const std::vector<uint8_t> &pixels) const {
        ASSERT_EQ(pixels.size(), static_cast<size_t>(width) * height * 4);
        WriteRgbaPng(directory / name, width, height, pixels);
    }

    void Load(const std::string &entries) const {
        const std::string groups = entries.contains("\"block\":1") ? "[0,1]" : "[0]";
        std::ofstream(directory / "fixture.json")
            << R"({"schema_version":3,"groups":)" << groups << ",\"entries\":[" << entries << "]}";
        std::string error;
        ASSERT_TRUE(texture_catalog::Load(directory, error)) << error;
        texture_catalog::SetCandidateResolver(datapacks::Candidates);
    }

    static int Enter(mgCTextureManager &manager, int block = 0, mgCMemory *stack = nullptr) {
        return MgTextureEnterDocument(&manager, "fixture.json", block, stack, nullptr);
    }

    std::filesystem::path directory;
};

std::string JsonTexture(const std::string &name, int animation_depth, int width, int height, const std::string &levels,
                        int block = 0, bool no_image = false, int /*picture*/ = 0, const std::string &extra_variants = "") {
    const std::string image = no_image ? R"("canvas":{"width":)" + std::to_string(width) +
                                             ",\"height\":" + std::to_string(height) + "}"
                                       : "\"levels\":" + levels;
    const std::string animation = animation_depth == 8 ? R"(,"animation":"copy_variant")" : animation_depth < 24 ? R"(,"animation":"copy")"
                                                                                                                 : "";
    return R"({"name":")" + name + R"(","block":)" + std::to_string(block) +
           ",\"pictures\":[{" + image + animation +
           (extra_variants.empty() ? "" : ",\"variants\":[" + extra_variants.substr(1) + "]") + "}]}";
}

mgCTexture *Enter(Harness &h, int block, const std::string &name, int width, int height, int bpp,
                  Levels levels = {}, u_long128 *clut = nullptr, u_long tex1 = 0, int swizzled = 0) {
    std::string owned = name;
    return h.manager.EnterTexture(block, owned.data(), levels.data(), width, height, bpp, clut, tex1, swizzled);
}

uint32_t Tbp0(const mgCTexture *texture) {
    return U(texture->tex0.TBP0);
}

uint32_t Cbp(const mgCTexture *texture) {
    return U(texture->tex0.CBP);
}

struct Readback {
    std::vector<uint8_t> pixels;
    uint32_t             width = 0;
    uint32_t             height = 0;
};

Readback Read(gfx::TextureHandle texture) {
    Readback result;
    EXPECT_TRUE(gfx::ReadbackTexture(texture, result.pixels, result.width, result.height));
    return result;
}

Texel4 TexelOf(const Readback &readback, uint32_t x, uint32_t y) {
    const uint8_t *p = &readback.pixels[(static_cast<size_t>(y) * readback.width + x) * 4];
    return {p[0], p[1], p[2], p[3]};
}

void ExpectUnswizzleMatchesConverter(uint32_t width, uint32_t height) {
    std::mt19937                       rng(0x5EED);
    std::uniform_int_distribution<int> byte(0, 0xFF);
    std::vector<uint8_t>               src(static_cast<size_t>(width) * height);
    for (uint8_t &value : src) {
        value = static_cast<uint8_t>(byte(rng));
    }

    std::vector<uint8_t> expected = src;
    ASSERT_EQ(Conv32To8(static_cast<int>(width), static_cast<int>(height), expected.data()), 1);
    std::vector<uint8_t> actual(src.size());
    gfx::tim2::Unswizzle8(src.data(), actual.data(), width, height);

    size_t first = 0;
    while (first < src.size() && actual[first] == expected[first]) {
        first++;
    }
    EXPECT_EQ(first, src.size()) << width << "x" << height << ": first difference at index " << first;
}

// Mirrors the retail name hash: signed chars and a u_char accumulator, so high-bit names wrap as they do in retail.
int RetailBucket(const std::string &name) {
    uint8_t value = 0;
    for (char c : name) {
        value = static_cast<uint8_t>(((value << 8) + static_cast<signed char>(c)) % 101);
    }
    return value;
}

} // namespace

TEST(MgTexture, NativeSetsReuseExactPixelsAcrossDocumentReferencesAndKeepAnimationState) {
    Harness                h;
    texture_catalog::Entry picture;
    picture.type = "texture";
    picture.name = "shared";
    picture.width = picture.height = 2;
    picture.bpp = 32;
    picture.variants = {
        {.selector = "shared",    .levels = {{.path = "#/images/0"}}},
        {.selector = "alternate", .levels = {{.path = "#/images/1"}}}
    };
    auto decode = [](const texture_catalog::Entry &, std::size_t variant, datapacks::DecodedTexture &decoded, std::string &) {
        decoded = {};
        decoded.width = decoded.height = 2;
        decoded.levels.emplace_back(16, variant == 0 ? 11 : 22);
        return true;
    };
    std::vector<texture_catalog::Source> documents;
    documents.reserve(200);
    mgCTexture *original = nullptr;
    for (int index = 0; index < 200; ++index) {
        documents.push_back({.source = "models/document" + std::to_string(index) + ".gltf", .groups = {0}, .entries = {picture}});
        auto &document = documents.back();
        document.entries[0].variants[0].levels[0] = {.path = "#/images/" + std::to_string(index * 2)};
        MgTextureEnterNativeSet(&h.manager, 0, document, &h.memory, decode);
        char  name[] = "shared";
        auto *texture = h.manager.GetTexture(name, 0);
        ASSERT_NE(texture, nullptr);
        if (!original) {
            original = texture;
            ASSERT_TRUE(MgTextureSelectVariant(texture, "alternate"));
        }
        EXPECT_EQ(texture, original);
        EXPECT_EQ(h.manager.texture_num, 1);
        EXPECT_EQ(MgTextureVariantSelector(texture), "alternate");
        EXPECT_EQ(reinterpret_cast<const unsigned char *>(texture->image[0])[0], 22);
    }
}

TEST(MgTexture, NativeSetsReplaceChangedPixelsVariantsAndSamplersWithoutAllocatingNewHeaders) {
    Harness                h;
    texture_catalog::Entry picture;
    picture.type = "texture";
    picture.name = "tile";
    picture.width = picture.height = 2;
    picture.bpp = 32;
    picture.variants = {
        {.selector = "tile",      .levels = {{.path = "#/images/0"}}},
        {.selector = "alternate", .levels = {{.path = "#/images/1"}}}
    };
    texture_catalog::Source      document{.source = "models/fixture.gltf", .groups = {0}, .entries = {picture}};
    std::array<unsigned char, 2> colors{10, 20};
    auto                         decode = [&colors](const texture_catalog::Entry &, std::size_t variant, datapacks::DecodedTexture &decoded, std::string &) {
        decoded = {};
        decoded.width = decoded.height = 2;
        decoded.levels.emplace_back(16, colors.at(variant));
        return true;
    };
    auto enter = [&] {
        MgTextureEnterNativeSet(&h.manager, 0, document, &h.memory, decode);
        char name[] = "tile";
        return h.manager.GetTexture(name, 0);
    };
    auto *original = enter();
    ASSERT_NE(original, nullptr);
    for (int change = 0; change < 80; ++change) {
        colors[0] = static_cast<unsigned char>(30 + change);
        EXPECT_EQ(enter(), original);
        EXPECT_EQ(h.manager.texture_num, 1);
        EXPECT_EQ(reinterpret_cast<const unsigned char *>(original->image[0])[0], colors[0]);
    }
    colors[1] = 123;
    EXPECT_EQ(enter(), original);
    ASSERT_TRUE(MgTextureSelectVariant(original, "alternate"));
    EXPECT_EQ(reinterpret_cast<const unsigned char *>(original->image[0])[0], 123);
    document.entries[0].nearest = true;
    document.entries[0].clamp = 7;
    EXPECT_EQ(enter(), original);
    EXPECT_EQ(MgTextureVariantSelector(original), "tile");
    EXPECT_EQ(original->clamp_bits, 7u);
    EXPECT_EQ(original->tex1_bits & (uint64_t{1} << 5), 0u);
    h.manager.DeleteBlock(0);
    EXPECT_EQ(h.manager.texture_num, 0);
    colors[0] = 201;
    ASSERT_NE(enter(), nullptr);
    EXPECT_EQ(reinterpret_cast<const unsigned char *>(original->image[0])[0], 201);
    h.manager.Initialize(0x1000, -1);
    colors[0] = 202;
    ASSERT_NE(enter(), nullptr);
    EXPECT_EQ(h.manager.texture_num, 1);
    EXPECT_EQ(reinterpret_cast<const unsigned char *>(original->image[0])[0], 202);
}

TEST(MgTexture, NativeSetsReuseLiveAnimationGroupsAndRecreateDeletedOrChangedScripts) {
    Harness                h;
    texture_catalog::Entry source;
    source.type = "texture";
    source.name = "source";
    source.width = source.height = 2;
    source.bpp = 32;
    source.variants = {
        {.selector = "source", .levels = {{.path = "#/images/0"}}}
    };
    auto destination = source;
    destination.name = "destination";
    destination.variants[0].selector = "destination";
    auto                   text = [](std::string value) { return texture_catalog::Entry::Argument{.text = std::move(value), .number = 0}; };
    auto                   number = [](double value) { return texture_catalog::Entry::Argument{.text = std::nullopt, .number = value}; };
    texture_catalog::Entry script;
    script.type = "cfg";
    script.name = "#animation";
    script.script = {
        {.name = "TEX_ANIME",          .args = {text("cycle"), number(1)}                                       },
        {.name = "TEX_ANIME_DATA",     .args = {number(0)}                                                      },
        {.name = "SRC_TEX",            .args = {text("source"), number(0), number(0), number(1), number(1)}     },
        {.name = "DEST_TEX",           .args = {text("destination"), number(0), number(0), number(1), number(1)}},
        {.name = "TEX_ANIME_DATA_END", .args = {}                                                               },
        {.name = "TEX_ANIME_END",      .args = {}                                                               }
    };
    texture_catalog::Source document{
        .source = "model.gltf", .groups = {0},
             .entries = {source, destination, script}
    };
    auto decode = [](const texture_catalog::Entry &, std::size_t, datapacks::DecodedTexture &decoded, std::string &) {
        decoded = {};
        decoded.width = decoded.height = 2;
        decoded.levels.emplace_back(16, 33);
        return true;
    };
    MgTextureEnterNativeSet(&h.manager, 0, document, &h.memory, decode);
    auto *animation = h.manager.GetTexAnime(0);
    ASSERT_NE(animation, nullptr);
    ASSERT_NE(animation->list[0], nullptr);
    auto      *first = animation->list[0];
    const auto used = h.memory.stack_used;
    for (int index = 0; index < 100; ++index) {
        MgTextureEnterNativeSet(&h.manager, 0, document, &h.memory, decode);
        EXPECT_EQ(animation->list[0], first);
        EXPECT_EQ(animation->list[1], nullptr);
        EXPECT_EQ(h.memory.stack_used, used);
        EXPECT_EQ(h.manager.texture_num, 2);
    }
    h.manager.DeleteTexAnimeGroup(0, 0);
    EXPECT_EQ(animation->list[0], nullptr);
    MgTextureEnterNativeSet(&h.manager, 0, document, &h.memory, decode);
    ASSERT_NE(animation->list[0], nullptr);
    EXPECT_NE(animation->list[0], first);
    document.entries[2].script.insert(document.entries[2].script.begin() + 4, {
                                                                                  .name = "WAIT", .args = {number(7), number(0)}
    });
    MgTextureEnterNativeSet(&h.manager, 0, document, &h.memory, decode);
    ASSERT_NE(animation->list[0], nullptr);
    EXPECT_EQ(animation->list[0]->data.wait, 7);
    EXPECT_EQ(animation->list[1], nullptr);
    h.manager.DeleteBlock(0);
    MgTextureEnterNativeSet(&h.manager, 0, document, &h.memory, decode);
    ASSERT_NE(h.manager.GetTexAnime(0), nullptr);
    EXPECT_EQ(h.manager.GetTexAnime(0)->list[0]->data.wait, 7);
    EXPECT_EQ(h.manager.texture_num, 2);
}

TEST(MgTexture, NativeSetsReuseIdenticallyNamedPicturesWithoutDecoding) {
    Harness                h;
    texture_catalog::Entry entry;
    entry.type = "texture";
    entry.name = "shared";
    entry.width = entry.height = 2;
    entry.bpp = 32;
    entry.variants = {
        {.selector = "base", .levels = {{.path = "#/images/0"}}},
        {.selector = "alt",  .levels = {{.path = "#/images/1"}}}
    };
    texture_catalog::Source document{.source = "model.gltf", .groups = {0}, .entries = {entry}};
    int                     decodes = 0;
    unsigned char           value = 40;
    auto                    decode = [&](const texture_catalog::Entry &, std::size_t variant, datapacks::DecodedTexture &decoded, std::string &) {
        ++decodes;
        decoded = {};
        decoded.width = decoded.height = 2;
        decoded.levels.emplace_back(16, static_cast<unsigned char>(value + variant));
        return true;
    };
    std::string identity = "first";
    auto        name = [&](const texture_catalog::Entry &, std::size_t variant) { return identity + std::to_string(variant); };
    // A named picture decodes only its first variant; the others decode when selected.
    MgTextureEnterNativeSet(&h.manager, 0, document, &h.memory, decode, name);
    EXPECT_EQ(decodes, 1);
    auto *original = h.manager.GetTexture(const_cast<char *>("shared"), 0);
    ASSERT_NE(original, nullptr);

    // Identical identities reuse the registered picture without decoding.
    MgTextureEnterNativeSet(&h.manager, 0, document, &h.memory, decode, name);
    EXPECT_EQ(decodes, 1);
    EXPECT_EQ(h.manager.GetTexture(const_cast<char *>("shared"), 0), original);
    EXPECT_EQ(h.manager.texture_num, 1);

    // A different identity decodes and replaces the picture in place, keeping its header.
    identity = "second";
    MgTextureEnterNativeSet(&h.manager, 0, document, &h.memory, decode, name);
    EXPECT_EQ(decodes, 2);
    EXPECT_EQ(h.manager.GetTexture(const_cast<char *>("shared"), 0), original);

    // Without identities the decoded pixels decide, and changed pixels replace the picture.
    value = 90;
    MgTextureEnterNativeSet(&h.manager, 0, document, &h.memory, decode);
    EXPECT_EQ(decodes, 4);
    auto *replaced = h.manager.GetTexture(const_cast<char *>("shared"), 0);
    ASSERT_NE(replaced, nullptr);
    EXPECT_EQ(reinterpret_cast<const unsigned char *>(replaced->image[0])[0], 90);

    // An unnamed variant disables identity reuse for the picture.
    auto partial = [&](const texture_catalog::Entry &, std::size_t variant) { return variant == 0 ? std::string("third0") : std::string{}; };
    MgTextureEnterNativeSet(&h.manager, 0, document, &h.memory, decode, partial);
    MgTextureEnterNativeSet(&h.manager, 0, document, &h.memory, decode, partial);
    EXPECT_EQ(decodes, 8);

    // Changed semantics with the same identities are entered again.
    MgTextureEnterNativeSet(&h.manager, 0, document, &h.memory, decode, name);
    EXPECT_EQ(decodes, 9);
    document.entries[0].clamp = 1;
    MgTextureEnterNativeSet(&h.manager, 0, document, &h.memory, decode, name);
    EXPECT_EQ(decodes, 10);

    // Selecting the other variant of a named picture decodes it then.
    auto *named = h.manager.GetTexture(const_cast<char *>("shared"), 0);
    ASSERT_NE(named, nullptr);
    ASSERT_TRUE(MgTextureSelectVariant(named, "alt"));
    EXPECT_EQ(decodes, 11);
    EXPECT_EQ(reinterpret_cast<const unsigned char *>(named->image[0])[0], 91);
}

TEST(MgTexture, NativeSetsKeepANamedPictureAnotherSetEnteredWithTheSamePixels) {
    Harness                h;
    texture_catalog::Entry entry;
    entry.type = "texture";
    entry.name = "s2001";
    entry.width = entry.height = 2;
    entry.bpp = 32;
    entry.variants = {
        {.selector = "base", .levels = {{.path = "#/images/0"}}}
    };
    const texture_catalog::Source map{.source = "map.gltf", .groups = {0}, .entries = {entry}};
    const texture_catalog::Source event{.source = "event.gltf", .groups = {0}, .entries = {entry}};
    unsigned char                 value = 40;
    auto                          decode = [&](const texture_catalog::Entry &, std::size_t, datapacks::DecodedTexture &decoded, std::string &) {
        decoded = {};
        decoded.width = decoded.height = 2;
        decoded.levels.emplace_back(16, value);
        return true;
    };
    // Each set names its own copy of the PNG.
    auto map_name = [](const texture_catalog::Entry &, std::size_t) { return std::string("map/s2001.png"); };
    auto event_name = [](const texture_catalog::Entry &, std::size_t) { return std::string("event/s2001.png"); };
    MgTextureEnterNativeSet(&h.manager, 0, map, &h.memory, decode, map_name);
    auto *texture = h.manager.GetTexture(const_cast<char *>("s2001"), 0);
    ASSERT_NE(texture, nullptr);
    const auto *pixels = texture->image[0];

    // The same pixels under another set's name, entered into any block, keep the registration and its pixels.
    MgTextureEnterNativeSet(&h.manager, -1, event, &h.memory, decode, event_name);
    EXPECT_EQ(h.manager.GetTexture(const_cast<char *>("s2001"), 0), texture);
    EXPECT_EQ(texture->image[0], pixels);
    EXPECT_EQ(h.manager.texture_num, 1);

    // Different pixels under another name replace the picture.
    value = 90;
    auto pack_name = [](const texture_catalog::Entry &, std::size_t) { return std::string("pack/s2001.png"); };
    MgTextureEnterNativeSet(&h.manager, 0, map, &h.memory, decode, pack_name);
    auto *replaced = h.manager.GetTexture(const_cast<char *>("s2001"), 0);
    ASSERT_NE(replaced, nullptr);
    EXPECT_EQ(reinterpret_cast<const unsigned char *>(replaced->image[0])[0], 90);
}

TEST(MgTexture, KeysLiveInTex0) {
    Harness     h;
    Quads       first_px = Pack(Ct32Pixels(24, 10));
    Quads       second_px = Pack(Ct32Pixels(24, 10));
    mgCTexture *first = Enter(h, 0, "first", 24, 10, 32, {first_px.data()});
    mgCTexture *second = Enter(h, 0, "second", 24, 10, 32, {second_px.data()});
    ASSERT_NE(first, nullptr);
    ASSERT_NE(second, nullptr);

    EXPECT_EQ(Tbp0(first), Cbp(first));
    EXPECT_EQ(Tbp0(second), Cbp(second));
    EXPECT_NE(Tbp0(first), Tbp0(second));
    EXPECT_EQ(Tbp0(first), kMgTextureKeyFirst);
    for (const mgCTexture *texture : {first, second}) {
        EXPECT_GE(Tbp0(texture), kMgTextureKeyLast);
        EXPECT_LE(Tbp0(texture), kMgTextureKeyFirst);
    }

    EXPECT_EQ(U(first->tex0.PSM), U(SCE_GS_PSMCT32));
    EXPECT_EQ(U(first->tex0.TW), 5u);
    EXPECT_EQ(U(first->tex0.TH), 4u);
    EXPECT_EQ(U(first->tex0.TBW), 1u);
    EXPECT_EQ(U(first->tex0.TCC), 1u);
    EXPECT_EQ(U(first->tex0.CLD), 0u);
    EXPECT_EQ(first->tex1_bits, static_cast<u_long>(SCE_GS_SET_TEX1(0, 0, 1, 1, 1, 0, 0)));

    mgCTexture *wide = Enter(h, 0, "wide", 130, 2, 32);
    ASSERT_NE(wide, nullptr);
    EXPECT_EQ(U(wide->tex0.TBW), 3u);
    EXPECT_EQ(U(wide->tex0.TW), 8u);
    EXPECT_EQ(U(wide->tex0.TH), 1u);

    const uint32_t freed = Tbp0(first);
    h.manager.DeleteTexture(first);
    mgCTexture *reused = Enter(h, 0, "reused", 24, 10, 32);
    ASSERT_NE(reused, nullptr);
    EXPECT_EQ(Tbp0(reused), freed);
}

TEST(MgTexture, FourMipLevelsKept) {
    Harness      h;
    Quads        l0 = Pack(Ct32Pixels(32, 32));
    Quads        l1 = Pack(Ct32Pixels(16, 16));
    Quads        l2 = Pack(Ct32Pixels(8, 8));
    Quads        l3 = Pack(Ct32Pixels(4, 4));
    const Levels levels = {l0.data(), l1.data(), l2.data(), l3.data()};

    mgCTexture *plain = Enter(h, 0, "plain", 32, 32, 32, levels);
    ASSERT_NE(plain, nullptr);
    for (size_t i = 0; i < levels.size(); i++) {
        EXPECT_EQ(plain->image[i], levels[i]) << "level " << i;
    }
    EXPECT_EQ(U(plain->tex1.MXL), 2u);

    mgCTexture *biased = Enter(h, 0, "biased", 32, 32, 32, levels, nullptr, SCE_GS_SET_TEX1(0, 0, 1, 1, 1, 2, 5));
    ASSERT_NE(biased, nullptr);
    for (size_t i = 0; i < levels.size(); i++) {
        EXPECT_EQ(biased->image[i], levels[i]) << "level " << i;
    }
    EXPECT_EQ(U(biased->tex1.MXL), 3u);
    EXPECT_EQ(U(biased->tex1.L), 2u);
    EXPECT_EQ(U(biased->tex1.K), 5u);
}

TEST(MgTexture, LookupBeforeRendererIsNull) {
    Harness     h;
    Quads       px = Pack(Ct32Pixels(8, 8));
    mgCTexture *texture = Enter(h, 0, "no_renderer", 8, 8, 32, {px.data()});
    ASSERT_NE(texture, nullptr);

    const MgTextureHandles direct = MgTextureLookup(texture);
    EXPECT_EQ(direct.texture, gfx::kNullTexture);
    EXPECT_EQ(direct.palette, gfx::kNullTexture);

    const MgTextureHandles by_tex0 = MgTextureLookupTex0(static_cast<uint64_t>(texture->tex0_bits));
    EXPECT_EQ(by_tex0.texture, gfx::kNullTexture);
    EXPECT_EQ(by_tex0.palette, gfx::kNullTexture);

    EXPECT_EQ(MgTextureLookup(nullptr).texture, gfx::kNullTexture);
}

TEST(MgTexture, StandaloneTextureDocumentUsesActualJsonBytes) {
    CatalogFixture             fixture;
    const std::vector<uint8_t> pixels(2 * 2 * 4, 255);
    fixture.Rgba("picture.png", 2, 2, pixels);
    fixture.Load(JsonTexture("picture", 32, 2, 2, "[\"picture.png\"]"));

    Harness       h;
    std::ifstream input(fixture.directory / "fixture.json", std::ios::binary);
    ASSERT_TRUE(input.good());
    std::string document(std::istreambuf_iterator<char>{input}, {});
    TextureSourceRegister(document.data(), "fixture.json", document.size());
    char        name[] = "picture";
    mgCTexture *texture = h.manager.EnterTexture(0, name, reinterpret_cast<TM2_head *>(document.data()), 0, 0);
    ASSERT_NE(texture, nullptr);
    EXPECT_EQ(texture->width, 2);
    EXPECT_EQ(texture->height, 2);
    EXPECT_NE(texture->image[0], nullptr);
}

TEST(MgTexture, CatalogDecodesRgbPngAsOpaqueRgba) {
    constexpr uint32_t   width = 3;
    constexpr uint32_t   height = 2;
    CatalogFixture       fixture;
    std::vector<uint8_t> pixels(static_cast<size_t>(width) * height * 4);
    for (size_t i = 0; i < pixels.size(); ++i) {
        pixels[i] = static_cast<uint8_t>(i * 37 + 11);
    }
    // gfx::WritePng keeps red, green and blue only, so this is a colour type 2 PNG whose alpha must come back opaque.
    ASSERT_TRUE(gfx::WritePng(fixture.directory / "rgb.png", pixels.data(), width, height));
    std::ifstream              png(fixture.directory / "rgb.png", std::ios::binary);
    const std::vector<uint8_t> header((std::istreambuf_iterator<char>(png)), std::istreambuf_iterator<char>());
    ASSERT_GT(header.size(), 25u);
    ASSERT_EQ(header[25], 2);
    fixture.Load(JsonTexture("rgb", 32, width, height, "[\"rgb.png\"]"));
    const auto *source = texture_catalog::Find("fixture.json");
    ASSERT_NE(source, nullptr);
    ASSERT_EQ(source->entries.size(), 1u);
    EXPECT_EQ(source->entries[0].width, 3);
    EXPECT_EQ(source->entries[0].height, 2);
    std::string error;
    const auto  decoded = texture_catalog::Decode(source->entries[0], "rgb", error);
    ASSERT_TRUE(decoded.has_value()) << error;
    ASSERT_FALSE(decoded->levels.empty());
    const std::vector<uint8_t> &rgba = decoded->levels[0];
    ASSERT_EQ(rgba.size(), static_cast<size_t>(width) * height * 4);
    for (size_t pixel = 0; pixel < static_cast<size_t>(width) * height; ++pixel) {
        for (size_t channel = 0; channel < 3; ++channel) {
            EXPECT_EQ(rgba[pixel * 4 + channel], pixels[pixel * 4 + channel]) << "pixel " << pixel << " channel " << channel;
        }
        EXPECT_EQ(rgba[pixel * 4 + 3], 255) << "pixel " << pixel;
    }
}

TEST(MgTexture, CatalogRejectsLegacyPaletteMetadata) {
    CatalogFixture fixture;
    fixture.Rgba("picture.png", 2, 2, std::vector<uint8_t>(2 * 2 * 4, 255));
    std::string legacy = JsonTexture("picture", 8, 2, 2, "[\"picture.png\"]");
    const auto  levels = legacy.find("\"levels\"");
    ASSERT_NE(levels, std::string::npos);
    legacy.insert(levels, "\"source_bpp\":8,");
    fixture.Load(legacy);
    EXPECT_EQ(texture_catalog::Find("fixture.json"), nullptr);
}

TEST(MgTexture, MinimalCatalogDerivesPictureSizeAndSampler) {
    CatalogFixture fixture;
    fixture.Rgba("base.png", 3, 2, std::vector<uint8_t>(3 * 2 * 4, 255));
    fixture.Load(R"({"name":"atlas","pictures":[{"levels":["base.png"],"sampler":{"wrap_u":"clamp","wrap_v":"clamp","filter":"nearest"},"animation":"copy_variant"},{"canvas":{"width":4,"height":8},"animation":"copy"}]})");
    const auto *source = texture_catalog::Find("fixture.json");
    ASSERT_NE(source, nullptr);
    ASSERT_EQ(source->entries.size(), 2u);
    EXPECT_EQ(source->entries[0].width, 3);
    EXPECT_EQ(source->entries[0].height, 2);
    EXPECT_EQ(source->entries[0].clamp, 5u);
    EXPECT_EQ(source->entries[0].animation_mode, texture_catalog::AnimationMode::CopyVariant);
    EXPECT_EQ(source->entries[1].picture, 1);
    EXPECT_TRUE(source->entries[1].no_image);
    EXPECT_EQ(source->entries[1].width, 4);
    EXPECT_EQ(source->entries[1].height, 8);
    EXPECT_EQ(source->entries[1].animation_mode, texture_catalog::AnimationMode::Copy);

    Harness h;
    CatalogFixture::Enter(h.manager);
    char        name[] = "atlas";
    const auto *texture = h.manager.GetTexture(name, 0);
    ASSERT_NE(texture, nullptr);
    EXPECT_EQ(texture->clamp_bits, 5);
    EXPECT_EQ(texture->tex1_bits & (uint64_t{1} << 5), 0u);
}

TEST(MgTexture, DirectDocumentRejectsLegacyNamesAndUnsafePaths) {
    CatalogFixture fixture;
    fixture.Load(R"({"name":"blank","pictures":[{"canvas":{"width":2,"height":3}}]})");
    const auto *source = texture_catalog::Find("fixture.json");
    ASSERT_NE(source, nullptr);
    EXPECT_EQ(source, texture_catalog::Find("fixture.json"));
    EXPECT_EQ(source->source, "fixture.json");
    EXPECT_TRUE(texture_catalog::Contains("fixture.json"));
    EXPECT_FALSE(texture_catalog::Contains("fixture.img"));
    EXPECT_FALSE(texture_catalog::Contains("fixture.tm2"));
    EXPECT_FALSE(texture_catalog::Contains("../fixture.json"));
    EXPECT_FALSE(texture_catalog::Contains("/fixture.json"));
    EXPECT_FALSE(texture_catalog::Contains("missing.json"));
}

TEST(MgTexture, DirectDocumentFallsBackFromMalformedDatapackJson) {
    CatalogFixture fixture;
    fixture.Load(R"({"name":"blank","pictures":[{"canvas":{"width":2,"height":3}}]})");
    const auto pack = fixture.directory.parent_path() / "datapacks";
    std::filesystem::create_directories(pack / "detail");
    std::ofstream(pack / "detail" / "fixture.json") << R"({"schema_version":2,"groups":[0],"entries":[]})";
    std::ofstream(pack / "datapacks.json") << R"({"schema_version":1,"load_order":["detail"]})";
    datapacks::Load(fixture.directory);
    const auto *source = texture_catalog::Find("fixture.json");
    ASSERT_NE(source, nullptr);
    ASSERT_EQ(source->entries.size(), 1u);
    EXPECT_EQ(source->entries[0].width, 2);

    std::ofstream(pack / "detail" / "fixture.json")
        << R"({"schema_version":3,"groups":[0],"entries":[{"name":"blank","pictures":[{"canvas":{"width":4,"height":5}}]}]})";
    std::string error;
    ASSERT_TRUE(texture_catalog::Load(fixture.directory, error)) << error;
    texture_catalog::SetCandidateResolver(datapacks::Candidates);
    source = texture_catalog::Find("fixture.json");
    ASSERT_NE(source, nullptr);
    ASSERT_EQ(source->entries.size(), 1u);
    EXPECT_EQ(source->entries[0].width, 4);
    EXPECT_EQ(source->entries[0].height, 5);
}

TEST(MgTexture, DatapackDocumentCanReferencePackOnlyTexturePng) {
    CatalogFixture fixture;
    const auto     pack = fixture.directory.parent_path() / "datapacks";
    const auto     base_document = fixture.directory / "textures/menu/0/save.json";
    const auto     pack_document = pack / "detail/textures/menu/0/save.json";
    std::filesystem::create_directories(base_document.parent_path());
    std::filesystem::create_directories(pack_document.parent_path());
    std::ofstream(base_document)
        << R"({"schema_version":3,"groups":[0],"entries":[{"name":"blank","pictures":[{"canvas":{"width":2,"height":2}}]}]})";
    std::ofstream(pack_document)
        << R"({"schema_version":3,"groups":[0],"entries":[{"name":"added","pictures":[{"levels":["save_0.png"]}]}]})";
    WriteRgbaPng(pack_document.parent_path() / "save_0.png", 2, 2,
                 std::vector<uint8_t>(std::size_t{2} * 2 * 4, 80));
    const auto invalid = pack / "invalid/textures/menu/0/save_0.png";
    std::filesystem::create_directories(invalid.parent_path());
    std::ofstream(invalid) << "corrupt";
    std::ofstream(pack / "datapacks.json") << R"({"schema_version":1,"load_order":["detail","invalid"]})";
    std::string error;
    ASSERT_TRUE(texture_catalog::Load(fixture.directory, error)) << error;
    datapacks::Load(fixture.directory);
    texture_catalog::SetCandidateResolver(datapacks::Candidates);

    const auto *source = texture_catalog::Find("textures/menu/0/save.json");
    ASSERT_NE(source, nullptr);
    ASSERT_EQ(source->entries.size(), 1u);
    EXPECT_EQ(source->entries[0].name, "added");
    ASSERT_EQ(source->entries[0].variants[0].levels.size(), 1u);
    EXPECT_EQ(source->entries[0].variants[0].levels[0].path, "textures/menu/0/save_0.png");
    EXPECT_TRUE(source->entries[0].variants[0].levels[0].file.Display().ends_with("detail/textures/menu/0/save_0.png"));
    datapacks::DecodedTexture decoded;
    ASSERT_TRUE(datapacks::Decode(source->entries[0], 0, decoded, error)) << error;
    ASSERT_EQ(decoded.levels.size(), 1u);
    EXPECT_EQ(decoded.levels[0][0], 80);
}

TEST(MgTexture, EmbeddedSetUsesImageReferencesAndRetainsVariantDecoder) {
    const auto document = nlohmann::json::parse(
        R"({"schema_version":3,"groups":[0],"entries":[{"name":"embedded","pictures":[{"levels":["#/images/0"],"variants":[{"selector":"alternate","levels":["#/images/1"]}]}]}]})");
    texture_catalog::Source source;
    std::string             error;
    const auto              extent = [](std::string_view reference, int &width, int &height, std::string &reason) {
        if (reference != "#/images/0") {
            reason = "unexpected image";
            return false;
        }
        width = height = 2;
        return true;
    };
    ASSERT_TRUE(texture_catalog::DecodeEmbeddedSet(document, "models/character.gltf", extent, source, error))
        << error;
    ASSERT_EQ(source.entries.size(), 1u);
    ASSERT_EQ(source.entries[0].variants.size(), 2u);
    EXPECT_EQ(source.entries[0].variants[0].levels[0].path, "#/images/0");
    EXPECT_EQ(source.entries[0].variants[1].levels[0].path, "#/images/1");

    Harness                     harness;
    int                         decode_count = 0;
    const MgTextureImageDecoder decoder = [&](const texture_catalog::Entry &, std::size_t variant,
                                              datapacks::DecodedTexture &decoded, std::string &) {
        ++decode_count;
        decoded.width = decoded.height = 8;
        decoded.levels = {std::vector<uint8_t>(8 * 8 * 4, variant == 0 ? 0x44 : 0x88)};
        return true;
    };
    MgTextureEnterNativeSet(&harness.manager, 0, source, nullptr, decoder);
    char  name[] = "embedded";
    auto *texture = harness.manager.GetTexture(name, 0);
    ASSERT_NE(texture, nullptr);
    // Every variant participates in exact native registration identity and is decoded once.
    EXPECT_EQ(decode_count, 2);
    EXPECT_EQ(texture->width, 2);
    EXPECT_EQ(texture->height, 2);
    EXPECT_EQ(MgTexturePhysicalExtent(texture).width, 8u);
    EXPECT_EQ(MgTexturePhysicalExtent(texture).height, 8u);
    EXPECT_EQ(reinterpret_cast<const unsigned char *>(texture->image[0])[0], 0x44);
    ASSERT_TRUE(MgTextureSelectVariant(texture, "alternate"));
    EXPECT_EQ(decode_count, 2);
    EXPECT_EQ(MgTextureVariantSelector(texture), "alternate");
    EXPECT_EQ(texture->width, 2);
    EXPECT_EQ(texture->height, 2);
    EXPECT_EQ(MgTexturePhysicalExtent(texture).width, 8u);
    EXPECT_EQ(MgTexturePhysicalExtent(texture).height, 8u);
    EXPECT_EQ(reinterpret_cast<const unsigned char *>(texture->image[0])[0], 0x88);
    ASSERT_TRUE(MgTextureSelectVariant(texture, "embedded"));
    EXPECT_EQ(decode_count, 2);
    EXPECT_EQ(reinterpret_cast<const unsigned char *>(texture->image[0])[0], 0x44);

    auto invalid = document;
    invalid["entries"][0]["pictures"][0]["levels"] = {"embedded.png"};
    EXPECT_FALSE(texture_catalog::DecodeEmbeddedSet(invalid, "models/character.gltf", extent, source, error));
}

TEST(MgTexture, EmbeddedSetTreatsNullOptionalFieldsAsAbsent) {
    const auto document = nlohmann::json::parse(
        R"({"schema_version":3,"groups":[0],"entries":[{"name":"image","pictures":[{"levels":["#/images/0"],"variants":null}]},{"name":"canvas","pictures":[{"canvas":{"width":4,"height":8},"levels":null,"variants":null}]}]})");
    texture_catalog::Source source;
    std::string             error;
    int                     extent_calls = 0;
    const auto              extent = [&](std::string_view reference, int &width, int &height, std::string &reason) {
        ++extent_calls;
        if (reference != "#/images/0") {
            reason = "unexpected image";
            return false;
        }
        width = 2;
        height = 3;
        return true;
    };
    ASSERT_TRUE(texture_catalog::DecodeEmbeddedSet(document, "models/character.gltf", extent, source, error))
        << error;
    ASSERT_EQ(source.entries.size(), 2u);
    EXPECT_EQ(extent_calls, 1);
    EXPECT_EQ(source.entries[0].width, 2);
    EXPECT_EQ(source.entries[0].height, 3);
    ASSERT_EQ(source.entries[0].variants.size(), 1u);
    EXPECT_EQ(source.entries[0].variants[0].selector, "image");
    ASSERT_EQ(source.entries[0].variants[0].levels.size(), 1u);
    EXPECT_EQ(source.entries[0].variants[0].levels[0].path, "#/images/0");
    EXPECT_TRUE(source.entries[1].no_image);
    EXPECT_EQ(source.entries[1].width, 4);
    EXPECT_EQ(source.entries[1].height, 8);
    ASSERT_EQ(source.entries[1].variants.size(), 1u);
    EXPECT_TRUE(source.entries[1].variants[0].levels.empty());

    const auto unresolved = [](std::string_view, int &, int &, std::string &reason) {
        reason = "image missing";
        return false;
    };
    EXPECT_FALSE(texture_catalog::DecodeEmbeddedSet(document, "models/character.gltf", unresolved, source, error));
    EXPECT_NE(error.find("image missing"), std::string::npos);
    const auto invalid_extent = [](std::string_view, int &width, int &height, std::string &) {
        width = 0;
        height = 3;
        return true;
    };
    EXPECT_FALSE(texture_catalog::DecodeEmbeddedSet(document, "models/character.gltf", invalid_extent, source, error));
    EXPECT_NE(error.find("invalid texture extent"), std::string::npos);
}

TEST(MgTexture, EmbeddedNullCompatibilityStillValidatesVariantsAndLevels) {
    const auto base = nlohmann::json::parse(
        R"({"schema_version":3,"groups":[0],"entries":[{"name":"image","pictures":[{"levels":["#/images/0"],"variants":null}]}]})");
    texture_catalog::Source source;
    std::string             error;
    const auto              extent = [](std::string_view reference, int &width, int &height, std::string &reason) {
        if (reference != "#/images/0") {
            reason = "unexpected image";
            return false;
        }
        width = height = 2;
        return true;
    };
    const auto reject = [&](const nlohmann::json &picture) {
        auto document = base;
        document["entries"][0]["pictures"][0] = picture;
        EXPECT_FALSE(texture_catalog::DecodeEmbeddedSet(document, "models/character.gltf", extent, source, error))
            << picture.dump();
        EXPECT_FALSE(error.empty());
    };
    reject(nlohmann::json::parse(R"({"levels":["#/images/0"],"variants":{}})"));
    reject(nlohmann::json::parse(R"({"levels":["#/images/0"],"variants":[{"selector":"image","levels":["#/images/1"]}]})"));
    reject(nlohmann::json::parse(R"({"levels":["#/images/0"],"variants":[{"selector":"","levels":["#/images/1"]}]})"));
    reject(nlohmann::json::parse(R"({"levels":["#/images/0"],"variants":[{"selector":"alternate","levels":["image.png"]}]})"));
    reject(nlohmann::json::parse(R"({"levels":null,"variants":null})"));
    reject(nlohmann::json::parse(R"({"canvas":{"width":4,"height":8},"levels":[],"variants":null})"));
    reject(nlohmann::json::parse(R"({"canvas":null,"levels":["#/images/0"]})"));
}

TEST(MgTexture, DirectDocumentRejectsNullOptionalFields) {
    CatalogFixture fixture;
    fixture.Load(R"({"name":"image","pictures":[{"canvas":{"width":2,"height":3},"levels":null}]})");
    EXPECT_EQ(texture_catalog::Find("fixture.json"), nullptr);

    std::ofstream(fixture.directory / "fixture.json")
        << R"({"schema_version":3,"groups":[0],"entries":[{"name":"image","pictures":[{"canvas":{"width":2,"height":3},"variants":null}]}]})";
    std::string error;
    ASSERT_TRUE(texture_catalog::Load(fixture.directory, error)) << error;
    EXPECT_EQ(texture_catalog::Find("fixture.json"), nullptr);
}

TEST(MgTexture, Unswizzle8MatchesRetailConv32To8) {
    const std::array<std::array<uint32_t, 2>, 6> sizes = {
        {{128, 64}, {128, 128}, {256, 128}, {256, 256}, {64, 64}, {32, 32}}
    };
    for (const std::array<uint32_t, 2> &size : sizes) {
        ExpectUnswizzleMatchesConverter(size[0], size[1]);
    }
}

TEST(MgTexture, LargeTexturesMatchIndependentRetailPageConversion) {
    // Conv32To8's scratch buffer is limited to 64 KiB. Convert each 128x64 page
    // separately so the reference also covers the 512x512 and larger atlases.
    for (const auto &size : {
             std::array{512u,  512u},
             std::array{1024u, 256u}
    }) {
        const auto [width, height] = size;
        std::mt19937         rng(0x5EED);
        std::vector<uint8_t> source(static_cast<size_t>(width) * height);
        for (auto &value : source) {
            value = static_cast<uint8_t>(rng());
        }
        std::vector<uint8_t> expected(source.size());
        for (uint32_t y = 0; y < height; y += 64) {
            for (uint32_t x = 0; x < width; x += 128) {
                std::array<uint8_t, 128 * 64> page{};
                for (uint32_t row = 0; row < 32; ++row) {
                    std::copy_n(source.data() + static_cast<size_t>(y) * width + row * width * 2 + x * 2,
                                256, page.data() + row * 256);
                }
                ASSERT_EQ(Conv32To8(128, 64, page.data()), 1);
                for (uint32_t row = 0; row < 64; ++row) {
                    std::copy_n(page.data() + row * 128, 128,
                                expected.data() + static_cast<size_t>(y + row) * width + x);
                }
            }
        }
        std::vector<uint8_t> actual(source.size());
        gfx::tim2::Unswizzle8(source.data(), actual.data(), width, height);
        EXPECT_EQ(actual, expected) << width << "x" << height;
    }
}

namespace {

class MgTextureGpu : public testing::Test {
protected:
    dc::test::GfxFixture gfx_;
    Harness              h_;
};

} // namespace

TEST_F(MgTextureGpu, CatalogPngUploadsAndSelectsBakedRgbaVariant) {
    CatalogFixture             fixture;
    const std::vector<uint8_t> color = {
        12,
        34,
        56,
        255,
        78,
        90,
        123,
        255,
        45,
        67,
        89,
        255,
        210,
        180,
        160,
        255,
    };
    fixture.Rgba("color.png", 2, 2, color);
    std::vector<uint8_t> alternate(2 * 2 * 4, 0xAB);
    for (size_t i = 3; i < alternate.size(); i += 4) {
        alternate[i] = 255;
    }
    fixture.Rgba("alternate.png", 2, 2, alternate);
    fixture.Load(JsonTexture("color", 32, 2, 2, "[\"color.png\"]") + "," +
                 JsonTexture("indexed", 8, 2, 2, "[\"color.png\"]", 0, false, 0,
                             R"(,{"selector":"alternate","levels":["alternate.png"]})"));
    CatalogFixture::Enter(h_.manager);

    char        color_name[] = "color";
    char        index_name[] = "indexed";
    mgCTexture *true_color = h_.manager.GetTexture(color_name, 0);
    mgCTexture *indexed = h_.manager.GetTexture(index_name, 0);
    ASSERT_NE(true_color, nullptr);
    ASSERT_NE(indexed, nullptr);
    const auto color_handles = MgTextureLookup(true_color);
    ASSERT_NE(color_handles.texture, gfx::kNullTexture);
    EXPECT_EQ(color_handles.palette, gfx::kNullTexture);
    const Readback color_pixels = Read(color_handles.texture);
    EXPECT_EQ(color_pixels.width, 2u);
    EXPECT_EQ(color_pixels.height, 2u);
    EXPECT_EQ(TexelOf(color_pixels, 1, 0), (Texel4{78, 90, 123, 255}));

    const auto index_handles = MgTextureLookup(indexed);
    ASSERT_NE(index_handles.texture, gfx::kNullTexture);
    EXPECT_EQ(index_handles.palette, gfx::kNullTexture);
    EXPECT_EQ(MgTextureAnimationMode(indexed), texture_catalog::AnimationMode::CopyVariant);
    EXPECT_EQ(MgTextureVariantSelector(indexed), "indexed");
    EXPECT_EQ(Read(index_handles.texture).pixels, color);
    ASSERT_TRUE(MgTextureSelectVariant(indexed, "alternate"));
    EXPECT_EQ(MgTextureVariantSelector(indexed), "alternate");
    EXPECT_EQ(Read(MgTextureLookup(indexed).texture).pixels, alternate);
    reinterpret_cast<uint8_t *>(indexed->image[0])[0] = 8;
    MgTexturePixelsChanged(indexed);
    EXPECT_EQ(Read(MgTextureLookup(indexed).texture).pixels[0], 8);
}

TEST_F(MgTextureGpu, CatalogCfgClutCopyUsesBakedRgbaCrossVariant) {
    CatalogFixture       fixture;
    std::vector<uint8_t> source(2 * 2 * 4, 0x11);
    std::vector<uint8_t> destination(2 * 2 * 4, 0x22);
    std::vector<uint8_t> baked(2 * 2 * 4, 0x77);
    for (auto *pixels : {&source, &destination, &baked}) {
        for (size_t i = 3; i < pixels->size(); i += 4) {
            (*pixels)[i] = 255;
        }
    }
    fixture.Rgba("source.png", 2, 2, source);
    fixture.Rgba("destination.png", 2, 2, destination);
    fixture.Rgba("baked.png", 2, 2, baked);
    const std::string cfg =
        R"({"name":"#texanime","script":[)"
        R"({"command":"TEX_ANIME","args":[{"text":"cycle"},{"number":1}]},)"
        R"({"command":"TEX_ANIME_DATA","args":[{"number":0}]},)"
        R"({"command":"SRC_TEX","args":[{"text":"source"},{"number":0},{"number":0},{"number":1},{"number":1}]},)"
        R"({"command":"DEST_TEX","args":[{"text":"destination"},{"number":0},{"number":0},{"number":1},{"number":1}]},)"
        R"({"command":"CLUT_COPY","args":[{"number":1}]},)"
        R"({"command":"TEX_ANIME_DATA_END","args":[]},)"
        R"({"command":"TEX_ANIME_END","args":[]} ]})";
    fixture.Load(JsonTexture("source", 8, 2, 2, "[\"source.png\"]") + "," +
                 JsonTexture("destination", 8, 2, 2, "[\"destination.png\"]", 0, false, 0,
                             R"(,{"selector":"source","levels":["baked.png"]})") +
                 "," + cfg);
    CatalogFixture::Enter(h_.manager, 0, &h_.memory);
    auto *anime = h_.manager.blocks[0].anime;
    ASSERT_NE(anime, nullptr);
    char        destination_name[] = "destination";
    mgCTexture *target = h_.manager.GetTexture(destination_name, 0);
    ASSERT_NE(target, nullptr);
    EXPECT_EQ(MgTextureVariantSelector(target), "destination");
    gfx_.Frame({0x10, 0x20, 0x30, 0x80}, [anime] { anime->TexAnime(0, nullptr); });
    EXPECT_EQ(MgTextureVariantSelector(target), "source");
    const auto handles = MgTextureLookup(target);
    EXPECT_EQ(handles.palette, gfx::kNullTexture);
    EXPECT_EQ(TexelOf(Read(handles.texture), 1, 1), (Texel4{0x77, 0x77, 0x77, 255}));
}

TEST_F(MgTextureGpu, CatalogNoImageDestinationAndResourceLifetime) {
    CatalogFixture fixture;
    fixture.Load(JsonTexture("destination", 8, 2, 2, "[]", 0, true) + "," +
                 JsonTexture("kept", 32, 2, 2, "[]", 1, true));
    CatalogFixture::Enter(h_.manager);
    char        destination_name[] = "destination";
    char        kept_name[] = "kept";
    mgCTexture *destination = h_.manager.GetTexture(destination_name, 0);
    mgCTexture *kept = h_.manager.GetTexture(kept_name, 1);
    ASSERT_NE(destination, nullptr);
    ASSERT_NE(kept, nullptr);
    EXPECT_EQ(destination->image[0], nullptr);
    const auto handles = MgTextureLookup(destination);
    ASSERT_NE(handles.texture, gfx::kNullTexture);
    EXPECT_EQ(handles.palette, gfx::kNullTexture);
    EXPECT_EQ(Read(handles.texture).pixels, (std::vector<uint8_t>(2 * 2 * 4, 0)));
    EXPECT_NE(MgTextureLookup(kept).texture, gfx::kNullTexture);

    h_.manager.DeleteBlock(0);
    EXPECT_EQ(MgTextureLookup(destination).texture, gfx::kNullTexture);
    EXPECT_NE(MgTextureLookup(kept).texture, gfx::kNullTexture);
    h_.manager.Initialize(0x1000, -1);
    EXPECT_EQ(MgTextureLookup(kept).texture, gfx::kNullTexture);
}

TEST_F(MgTextureGpu, CatalogMipsAndExtraPicturesGetDistinctNames) {
    CatalogFixture       fixture;
    std::vector<uint8_t> base(2 * 2 * 4, 11);
    std::vector<uint8_t> mip(4, 22);
    for (size_t i = 3; i < base.size(); i += 4) {
        base[i] = 255;
    }
    mip[3] = 255;
    fixture.Rgba("base.png", 2, 2, base);
    fixture.Rgba("mip.png", 1, 1, mip);
    fixture.Load(R"({"name":"atlas","pictures":[{"levels":["base.png","mip.png"],"animation":"copy_variant"},{"levels":["base.png"],"animation":"copy_variant"}]})");
    CatalogFixture::Enter(h_.manager);
    char        primary_name[] = "atlas";
    char        extra_name[] = "atlas#picture1";
    mgCTexture *primary = h_.manager.GetTexture(primary_name, 0);
    mgCTexture *extra = h_.manager.GetTexture(extra_name, 0);
    ASSERT_NE(primary, nullptr);
    ASSERT_NE(extra, nullptr);
    EXPECT_NE(primary, extra);
    EXPECT_NE(primary->image[1], nullptr);
    const auto info = gfx::GetTextureInfo(MgTextureLookup(primary).texture);
    ASSERT_TRUE(info.has_value());
    EXPECT_EQ(info->mip_levels, 2u);
    EXPECT_EQ(Read(MgTextureLookup(primary).texture).pixels, base);
}

TEST_F(MgTextureGpu, NoImageTextureIsZeroedCanvas) {
    mgCTexture *texture = Enter(h_, 0, "blank", 64, 32, 32);
    ASSERT_NE(texture, nullptr);
    const MgTextureHandles handles = MgTextureLookup(texture);
    ASSERT_NE(handles.texture, gfx::kNullTexture);
    const std::optional<gfx::TextureInfo> info = gfx::GetTextureInfo(handles.texture);
    ASSERT_TRUE(info.has_value());
    EXPECT_EQ(info->width, 64u);
    EXPECT_EQ(info->height, 32u);
    const Readback readback = Read(handles.texture);
    ASSERT_EQ(readback.pixels.size(), 64u * 32 * 4);
    EXPECT_TRUE(std::ranges::all_of(readback.pixels, [](uint8_t v) { return v == 0; }));
}

TEST(MgTexture, TablesAboveFourGiB) {
    Harness    h;
    const auto arena_lo = reinterpret_cast<uintptr_t>(h.memory.stack);
    if (arena_lo <= 0xFFFFFFFFu) {
        GTEST_SKIP() << "arena at 0x" << std::hex << arena_lo << " is below 4 GiB";
    }

    ASSERT_GT(reinterpret_cast<uintptr_t>(h.manager.blocks), 0xFFFFFFFFu);

    const uintptr_t arena_used = arena_lo + static_cast<uintptr_t>(h.memory.stack_used) * sizeof(u_long128);

    const struct {
        const char *what;
        uintptr_t   begin;
        uintptr_t   end;
    } regions[] = {
        {.what = "blocks",        .begin = reinterpret_cast<uintptr_t>(h.manager.blocks),        .end = reinterpret_cast<uintptr_t>(&h.manager.blocks[kBlockCount - 1] + 1) },
        {.what = "texture_buf",   .begin = reinterpret_cast<uintptr_t>(h.manager.texture_buf),   .end = reinterpret_cast<uintptr_t>(h.manager.texture_buf + kTextureCount)  },
        {.what = "texture_stack", .begin = reinterpret_cast<uintptr_t>(h.manager.texture_stack), .end = reinterpret_cast<uintptr_t>(h.manager.texture_stack + kTextureCount)},
        {.what = "hash_buf",      .begin = reinterpret_cast<uintptr_t>(h.manager.hash_buf),      .end = reinterpret_cast<uintptr_t>(h.manager.hash_buf + kTextureCount)     },
        {.what = "hash_stack",    .begin = reinterpret_cast<uintptr_t>(h.manager.hash_stack),    .end = reinterpret_cast<uintptr_t>(h.manager.hash_stack + kTextureCount)   },
    };

    for (const auto &region : regions) {
        EXPECT_GE(region.begin, arena_lo) << region.what;
        EXPECT_LE(region.end, arena_used) << region.what;
    }

    std::vector<std::string> odd;
    std::vector<std::string> even;
    for (int i = 0; (odd.size() < 16 || even.size() < 16) && i < 1000; i++) {
        std::string               name = "tex_" + std::to_string(i);
        std::vector<std::string> &list = (RetailBucket(name) & 1) != 0 ? odd : even;
        if (list.size() < 16) {
            list.push_back(name);
        }
    }
    ASSERT_EQ(odd.size(), 16u);
    ASSERT_EQ(even.size(), 16u);

    std::vector<std::string> names;
    for (size_t i = 0; i < 16; i++) {
        names.push_back(odd[i]);
        names.push_back(even[i]);
    }

    std::vector<int> buckets;
    for (const std::string &name : names) {
        std::string owned = name;
        EXPECT_EQ(h.manager.hash(owned.data()), RetailBucket(name)) << name;
        buckets.push_back(RetailBucket(name));
    }
    std::ranges::sort(buckets);
    ASSERT_LT(static_cast<size_t>(std::ranges::unique(buckets).begin() - buckets.begin()), names.size())
        << "no two names share a bucket, so chains are not exercised";

    auto block_of = [](size_t k) { return static_cast<int>(k % kBlockCount); };
    for (size_t k = 0; k < names.size(); k++) {
        ASSERT_NE(Enter(h, block_of(k), names[k], 4, 4, 32), nullptr) << names[k];
    }

    for (size_t k = 0; k < names.size(); k++) {
        const int   block = block_of(k);
        std::string name = names[k];
        mgCTexture *found = h.manager.GetTexture(name.data(), block);
        ASSERT_NE(found, nullptr) << name << " in block " << block;
        EXPECT_STREQ(found->name, name.c_str());
        EXPECT_EQ(found->block, block);
        EXPECT_EQ(h.manager.GetTexture(name.data(), (block + 1) % kBlockCount), nullptr) << name;
        EXPECT_NE(h.manager.GetTexture(name.data(), -1), nullptr) << name;
    }

    h.manager.DeleteBlock(2);
    for (size_t k = 0; k < names.size(); k++) {
        std::string name = names[k];
        const int   block = block_of(k);
        if (block == 2) {
            EXPECT_EQ(h.manager.GetTexture(name.data(), block), nullptr) << name;
        } else {
            EXPECT_NE(h.manager.GetTexture(name.data(), block), nullptr) << name;
        }
    }

    for (size_t k = 0; k < names.size(); k++) {
        if (block_of(k) != 2) {
            continue;
        }
        ASSERT_NE(Enter(h, 2, names[k], 4, 4, 32), nullptr) << names[k];
        std::string name = names[k];
        EXPECT_NE(h.manager.GetTexture(name.data(), 2), nullptr) << names[k];
    }
}

namespace {
void HighResolutionOverlay(CatalogFixture &fixture, const std::string &name, uint32_t width, uint32_t height,
                           const std::vector<uint8_t> &pixels) {
    const auto packs = fixture.directory.parent_path() / "datapacks";
    std::filesystem::create_directories(packs / "detail");
    WriteRgbaPng(packs / "detail" / name, width, height, pixels);
    std::ofstream(packs / "datapacks.json") << R"({"schema_version":1,"load_order":["detail"]})";
    datapacks::Load(fixture.directory);
}

std::vector<uint8_t> DetailPixels(int width, int height) {
    std::vector<uint8_t> pixels(static_cast<size_t>(width) * height * 4);
    for (int y = 0; y < height; ++y) {
        for (int x = 0; x < width; ++x) {
            auto *color = pixels.data() + (static_cast<size_t>(y) * width + x) * 4;
            color[0] = static_cast<uint8_t>(20 + x * 20);
            color[1] = static_cast<uint8_t>(30 + y * 20);
            color[2] = 60;
            color[3] = 255;
        }
    }
    return pixels;
}
} // namespace

TEST(MgTexture, DirectCatalogEntryKeepsLogicalSizeWithFourfoldOverlay) {
    CatalogFixture fixture;
    fixture.Rgba("tile.png", 2, 2, std::vector<uint8_t>(2 * 2 * 4, 255));
    fixture.Load(JsonTexture("tile", 32, 2, 2, "[\"tile.png\"]"));
    HighResolutionOverlay(fixture, "tile.png", 8, 8, std::vector<uint8_t>(8 * 8 * 4, 255));
    const auto *catalog = texture_catalog::Find("fixture.json");
    ASSERT_NE(catalog, nullptr);
    ASSERT_EQ(catalog->entries.size(), 1u);
    Harness harness;
    EXPECT_EQ(MgTextureEnterCatalog(nullptr, 0, catalog->entries[0]), nullptr);
    const auto *texture = MgTextureEnterCatalog(&harness.manager, 0, catalog->entries[0]);
    ASSERT_NE(texture, nullptr);
    EXPECT_EQ(texture->width, 2);
    EXPECT_EQ(texture->height, 2);
    EXPECT_EQ(MgTexturePhysicalExtent(texture).width, 8u);
    EXPECT_EQ(MgTexturePhysicalExtent(texture).height, 8u);
}

TEST_F(MgTextureGpu, HighResolutionKeepsLogicalCpuStrideAndSpriteBounds) {
    CatalogFixture fixture;
    fixture.Rgba("detail.png", 3, 2, DetailPixels(3, 2));
    fixture.Load(JsonTexture("detail", 32, 3, 2, "[\"detail.png\"]"));
    const auto detail = DetailPixels(6, 4);
    HighResolutionOverlay(fixture, "detail.png", 6, 4, detail);
    const auto *catalog = texture_catalog::Find("fixture.json");
    ASSERT_NE(catalog, nullptr);
    ASSERT_EQ(catalog->entries.size(), 1u);
    auto *texture = MgTextureEnterCatalog(&h_.manager, 0, catalog->entries[0]);
    ASSERT_NE(texture, nullptr);
    EXPECT_EQ(texture->width, 3);
    EXPECT_EQ(texture->height, 2);
    EXPECT_EQ(texture->tex0.TW, 2u);
    EXPECT_EQ(texture->tex0.TH, 1u);
    const auto physical = Read(MgTextureLookup(texture).texture);
    ASSERT_EQ(physical.width, 8u);
    ASSERT_EQ(physical.height, 4u);
    EXPECT_EQ(TexelOf(physical, 5, 3), (Texel4{120, 90, 60, 255}));
    EXPECT_EQ(TexelOf(physical, 6, 3), (Texel4{}));
    const auto *logical = reinterpret_cast<uint8_t *>(texture->image[0]);
    EXPECT_EQ(logical[3 * 4], 40); // Second logical row, sampled from physical row 3.
    EXPECT_EQ(logical[3 * 4 + 1], 90);

    ClockSetUnbounded(true);
    mgInit(MG_SCREEN_MODE_512X480, 3);
    mgBeginFrame(nullptr);
    gfx::Vertex2D quad[4]{};
    const float   positions[4][4] = {
        {20, 20, 0, 0},
        {80, 20, 3, 0},
        {80, 60, 3, 2},
        {20, 60, 0, 2}
    };
    for (int i = 0; i < 4; ++i) {
        quad[i].x = positions[i][0];
        quad[i].y = positions[i][1];
        quad[i].u = positions[i][2];
        quad[i].v = positions[i][3];
        std::fill_n(quad[i].color, 4, 0x80);
    }
    auto binding = mgPortBinding(texture);
    binding.filter = gfx::Filter::Nearest;
    mgPortDraw2D(gfx::Primitive::Quads, quad, binding, gfx::DrawState{});
    mgEndFrame(nullptr);
    const auto frame = Read(gfx::kPreviousFrame);
    EXPECT_EQ(TexelOf(frame, 25, 25)[0], 20);
    EXPECT_EQ(TexelOf(frame, 35, 25)[0], 40);
    EXPECT_EQ(TexelOf(frame, 75, 55)[0], 120);
    EXPECT_NE(TexelOf(frame, 85, 25)[0], 120);
    Quads stored(2);
    EXPECT_GT(mgStoreImage(texture, stored.data()), 0);
    const auto *stored_rgba = reinterpret_cast<const uint8_t *>(stored.data());
    EXPECT_EQ(stored_rgba[0], 40);
    EXPECT_EQ(stored_rgba[(3 * 2 - 1) * 4], 120);
    EXPECT_EQ(stored_rgba[(3 * 2 - 1) * 4 + 3], 0x80);
}

TEST_F(MgTextureGpu, HighResolutionColorVariantsAndCopiesRetainDetail) {
    CatalogFixture fixture;
    fixture.Rgba("detail.png", 2, 2, DetailPixels(2, 2));
    fixture.Load(JsonTexture("detail", 8, 2, 2, "[\"detail.png\"]", 0, false, 0,
                             R"(,{"selector":"alternate","levels":["alternate.png"]})"));
    fixture.Rgba("alternate.png", 2, 2, DetailPixels(2, 2));
    HighResolutionOverlay(fixture, "detail.png", 4, 4, DetailPixels(4, 4));
    CatalogFixture::Enter(h_.manager);
    char  name[] = "detail";
    char  grey_name[] = "grey";
    char  highlight_name[] = "highlight";
    auto *source = h_.manager.GetTexture(name, 0);
    ASSERT_NE(source, nullptr);
    auto *grey = MgTextureCreateColorVariant(source, grey_name, MgTextureColorMode::Grey);
    auto *highlight = MgTextureCreateColorVariant(source, highlight_name, MgTextureColorMode::IconHighlight);
    ASSERT_NE(grey, nullptr);
    ASSERT_NE(highlight, nullptr);
    const auto greys = Read(MgTextureLookup(grey).texture);
    const auto highlights = Read(MgTextureLookup(highlight).texture);
    ASSERT_EQ(greys.width, 4u);
    EXPECT_EQ(TexelOf(greys, 0, 0), (Texel4{32, 32, 32, 255}));
    EXPECT_EQ(TexelOf(greys, 3, 0), (Texel4{48, 48, 48, 255}));
    EXPECT_EQ(TexelOf(highlights, 0, 0), (Texel4{20, 30, 255, 255}));
    EXPECT_EQ(TexelOf(highlights, 3, 0), (Texel4{80, 30, 255, 255}));

    Quads initial = Pack(std::vector<uint8_t>(4 * 2 * 4, 0x55));
    auto *destination = Enter(h_, 1, "active", 4, 2, 32, {initial.data()});
    ASSERT_TRUE(MgTextureCopyRegion(source, 0, 0, destination, 0, 0, 2, 2));
    const auto handle = MgTextureLookup(destination).texture;
    auto       copied = Read(handle);
    ASSERT_EQ(copied.width, 8u);
    EXPECT_EQ(TexelOf(copied, 0, 0), (Texel4{20, 30, 60, 255}));
    EXPECT_EQ(TexelOf(copied, 1, 0), (Texel4{40, 30, 60, 255}));
    EXPECT_EQ(TexelOf(copied, 6, 0), (Texel4{0x55, 0x55, 0x55, 0x55}));
    ASSERT_TRUE(MgTextureCopyRegion(nullptr, 0, 0, destination, 0, 0, 1, 1));
    EXPECT_EQ(MgTextureLookup(destination).texture, handle);
    copied = Read(handle);
    EXPECT_EQ(TexelOf(copied, 1, 1), (Texel4{}));
    EXPECT_EQ(TexelOf(copied, 3, 1), (Texel4{80, 50, 60, 255}));
    EXPECT_EQ(TexelOf(copied, 6, 0), (Texel4{0x55, 0x55, 0x55, 0x55}));
    ASSERT_TRUE(MgTextureSelectVariant(source, "alternate"));
    EXPECT_EQ(Read(MgTextureLookup(source).texture).width, 2u);
    EXPECT_EQ(source->width, 2);
    h_.manager.DeleteBlock(1);
    auto *reused = Enter(h_, 1, "reused", 4, 2, 32, {initial.data()});
    ASSERT_NE(reused, nullptr);
    EXPECT_EQ(Read(MgTextureLookup(reused).texture).width, 4u);
}

TEST_F(MgTextureGpu, HighResolutionAnimationCopiesOffsetsRestoresAndReleasesTarget) {
    CatalogFixture fixture;
    fixture.Rgba("source.png", 4, 4, DetailPixels(4, 4));
    fixture.Rgba("destination.png", 8, 8, DetailPixels(8, 8));
    fixture.Load(JsonTexture("source", 32, 4, 4, "[\"source.png\"]") + "," +
                 JsonTexture("destination", 32, 8, 8, "[\"destination.png\"]") + "," +
                 JsonTexture("blank", 32, 4, 4, "[]", 0, true));
    HighResolutionOverlay(fixture, "source.png", 8, 8, DetailPixels(8, 8));
    HighResolutionOverlay(fixture, "destination.png", 32, 32, DetailPixels(32, 32));
    CatalogFixture::Enter(h_.manager);
    char  source_name[] = "source";
    char  destination_name[] = "destination";
    auto *source = h_.manager.GetTexture(source_name, 0);
    auto *destination = h_.manager.GetTexture(destination_name, 0);
    ASSERT_NE(source, nullptr);
    ASSERT_NE(destination, nullptr);
    CList<mgCTexAnimeData> node;
    node.data.Initialize();
    node.data.type = MG_TEX_ANIME_TYPE_COPY;
    node.data.src_tex = source;
    node.data.dest_tex = destination;
    node.data.src_x = node.data.src_y = 16;
    node.data.src_w = node.data.src_h = 32;
    node.data.dest_x = 48;
    node.data.dest_y = 32;
    node.data.dest_w = node.data.dest_h = 32;
    node.data.r = node.data.g = node.data.b = node.data.a = 0x80;
    node.data.wait = -1;
    node.data.bilinear = 0;
    node.data.alpha_blend = MG_TEX_ANIME_ALPHA_BLEND_OFF;
    node.data.alpha_test = MG_TEX_ANIME_ALPHA_TEST_OFF;
    mgCTextureAnime anime;
    anime.list[0] = anime.now[0] = &node;
    anime.enable[0] = 1;
    h_.manager.blocks[0].anime = &anime;
    ClockSetUnbounded(true);
    mgInit(MG_SCREEN_MODE_512X480, 3);
    mgBeginFrame(nullptr);
    anime.TexAnime(0, nullptr);
    mgEndFrame(nullptr);
    const auto target = mgPortFindTexture(destination).texture;
    ASSERT_NE(target, MgTextureLookup(destination).texture);
    const auto animated = Read(target);
    ASSERT_EQ(animated.width, 32u);
    EXPECT_EQ(TexelOf(animated, 12, 8)[0], 60); // Source physical (2,2), destination logical (3,2).
    EXPECT_EQ(TexelOf(animated, 14, 8)[0], 80);
    EXPECT_EQ(TexelOf(animated, 11, 8)[0], 240); // Adjacent destination content survives.
    EXPECT_EQ(TexelOf(animated, 12, 7)[1], 170);

    node.data.bilinear = 1;
    mgBeginFrame(nullptr);
    anime.TexAnime(0, nullptr);
    mgEndFrame(nullptr);
    const auto filtered = Read(target);
    // GS linear sampling starts on a texel edge; physical neighbours contribute equally.
    EXPECT_EQ(TexelOf(filtered, 12, 8)[0], 50);
    EXPECT_EQ(TexelOf(filtered, 14, 8)[0], 70);

    // The indexed transfer seam must apply both independent physical scales too.
    mgBeginFrame(nullptr);
    mgSetPkMoveImage(&source->tex0, mgRect<int>(16, 16, 32, 32), &destination->tex0, 16, 80, 0);
    mgEndFrame(nullptr);
    const auto transferred = Read(target);
    EXPECT_EQ(TexelOf(transferred, 4, 20)[0], 60);
    EXPECT_EQ(TexelOf(transferred, 6, 20)[0], 80);
    EXPECT_EQ(TexelOf(transferred, 3, 20)[0], 80);

    anime.enable[0] = 0;
    h_.manager.last_block = -1;
    mgBeginFrame(nullptr);
    h_.manager.ReloadTexture(0, static_cast<sceVif1Packet *>(nullptr));
    mgEndFrame(nullptr);
    EXPECT_EQ(mgPortFindTexture(destination).texture, target);
    const auto restored = Read(target);
    EXPECT_EQ(TexelOf(restored, 12, 8)[0], 4); // DetailPixels wraps byte 20 + 12*20.
    EXPECT_EQ(TexelOf(restored, 4, 20)[0], 100);
    char  blank_name[] = "blank";
    auto *blank = h_.manager.GetTexture(blank_name, 0);
    ASSERT_NE(blank, nullptr);
    EXPECT_EQ(blank->image[0], nullptr);
    node.data.dest_tex = blank;
    node.data.dest_x = node.data.dest_y = 16;
    node.data.bilinear = 0;
    anime.enable[0] = 1;
    mgBeginFrame(nullptr);
    anime.TexAnime(0, nullptr);
    mgEndFrame(nullptr);
    const auto blank_target = mgPortFindTexture(blank).texture;
    const auto filled_blank = Read(blank_target);
    ASSERT_EQ(filled_blank.width, 8u);
    EXPECT_EQ(blank->width, 4);
    EXPECT_EQ(blank->tex0.TW, 2u);
    EXPECT_EQ(TexelOf(filled_blank, 2, 2)[0], 60);
    EXPECT_EQ(TexelOf(filled_blank, 3, 2)[0], 80);
    EXPECT_EQ(TexelOf(filled_blank, 1, 2)[0], 0);
    h_.manager.blocks[0].anime = nullptr;
    h_.manager.DeleteBlock(0);
    EXPECT_FALSE(gfx::GetTextureInfo(target).has_value());
    EXPECT_FALSE(gfx::GetTextureInfo(blank_target).has_value());
    Quads pixels = Pack(DetailPixels(8, 8));
    auto *reused = Enter(h_, 0, "animation_reused", 8, 8, 32, {pixels.data()});
    ASSERT_NE(reused, nullptr);
    EXPECT_EQ(mgPortFindTexture(reused).texture, MgTextureLookup(reused).texture);
    EXPECT_EQ(Read(MgTextureLookup(reused).texture).width, 8u);
}

TEST_F(MgTextureGpu, MenuPointerUsesPhysicalTexelsFromDoubleResolutionPack) {
    CatalogFixture fixture;
    fixture.Rgba("gaiji.png", 2, 2, DetailPixels(2, 2));
    fixture.Load(JsonTexture("gaiji", 32, 2, 2, "[\"gaiji.png\"]"));
    HighResolutionOverlay(fixture, "gaiji.png", 4, 4, DetailPixels(4, 4));
    CatalogFixture::Enter(h_.manager);
    char        name[] = "gaiji";
    const auto *texture = h_.manager.GetTexture(name, 0);
    ASSERT_NE(texture, nullptr);
    const auto binding = MgTextureLookup(texture);
    ASSERT_EQ(MgTexturePhysicalExtent(texture).width, 4u);
    ASSERT_FLOAT_EQ(mgPortTextureScale(binding.texture), 2.0f);

    const auto settings = InputGetMouseSettings();
    InputResetBindings();
    InputSetMouseSettings({.capture = false});
    MenuMouseEnable(true);
    SDL_Event event{};
    event.type = SDL_EVENT_MOUSE_MOTION;
    event.motion.xrel = 8;
    InputHandleEvent(event);
    const auto point = MenuMouseDisplaySample();
    ASSERT_TRUE(point.pointing);
    MenuMouseNoteHand({.texture = binding.texture}, {.x = 1, .y = 0, .w = 1, .h = 2});
    // Host overlays record outside mgBeginFrame/mgEndFrame and still need scaled texels.
    gfx::BeginRecording();
    MenuMouseDraw();
    const auto list = gfx::EndRecording();
    ASSERT_EQ(list->entries.size(), 1u);
    const auto *draw = std::get_if<gfx::detail::Draw2DEntry>(&list->entries.front());
    ASSERT_NE(draw, nullptr);
    ASSERT_EQ(draw->vertices.size(), 4u);
    for (int i = 0; i < 4; ++i) {
        EXPECT_FLOAT_EQ(draw->vertices[i].u, (i & 1) ? 4.0f : 2.0f);
        EXPECT_FLOAT_EQ(draw->vertices[i].v, (i & 2) ? 4.0f : 0.0f);
    }
    EXPECT_FLOAT_EQ((draw->vertices[1].x + draw->vertices[3].x) / 2, point.x);
    EXPECT_FLOAT_EQ((draw->vertices[1].y + draw->vertices[3].y) / 2, point.y);
    MenuMouseEnable(false);
    InputSetMenuMouse(false);
    InputSetMouseSettings(settings);
    InputResetBindings();
}
