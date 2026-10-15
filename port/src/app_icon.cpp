#include "app_icon.hpp"

#ifdef _WIN32
#define WIN32_LEAN_AND_MEAN
#define NOMINMAX
#define RECT WindowsRect
#include <objbase.h>
#include <shobjidl.h>
#include <windows.h>
#undef RECT
#endif

#include <algorithm>
#include <array>
#include <cmath>
#include <cstdio>
#include <cstring>
#include <fstream>
#include <iterator>
#include <string>
#include <system_error>

#include "identity.hpp"
#include "platform/paths.hpp"

namespace fs = std::filesystem;

namespace {

constexpr int kTextureSize = 128;
constexpr int kSupersample = 4;

struct Vertex {
    float pos[3];
    float normal[3];
    float uv[2];
};

struct Model {
    std::vector<Vertex>        vertices;
    std::vector<std::uint16_t> texture; // 128x128 RGB555, red in the low bits
};

class Reader {
public:
    Reader(const std::uint8_t *data, std::size_t size) : data_(data), size_(size) {}

    bool Skip(std::size_t bytes) {
        if (bytes > size_ - at_) {
            return false;
        }
        at_ += bytes;
        return true;
    }

    template <typename T>
    bool Read(T &out) {
        if (sizeof(T) > size_ - at_) {
            return false;
        }
        std::memcpy(&out, data_ + at_, sizeof(T));
        at_ += sizeof(T);
        return true;
    }

    std::size_t At() const { return at_; }

private:
    const std::uint8_t *data_;
    std::size_t         size_;
    std::size_t         at_ = 0;
};

// The PS2 icon layout: a header, every vertex with one position per animation shape, its normal, UV and
// colour, the animation frames and then a 128x128 texture, run-length compressed when bit 3 of the
// texture type is set.
bool Decode(const std::uint8_t *data, std::size_t size, Model &model) {
    Reader        in(data, size);
    std::uint32_t magic, shapes, texture_type, vertex_count;
    float         reserved;
    if (!in.Read(magic) || !in.Read(shapes) || !in.Read(texture_type) || !in.Read(reserved) ||
        !in.Read(vertex_count) || magic != 0x10000 || shapes == 0 || shapes > 16 || vertex_count == 0 ||
        vertex_count % 3 != 0 || vertex_count > size / 16) {
        return false;
    }
    model.vertices.resize(vertex_count);
    for (Vertex &vertex : model.vertices) {
        std::int16_t position[4], normal[4], uv[2];
        for (int i = 0; i < 4; ++i) {
            if (!in.Read(position[i])) {
                return false;
            }
        }
        if (!in.Skip(8 * (shapes - 1))) {
            return false;
        }
        for (int i = 0; i < 4; ++i) {
            if (!in.Read(normal[i])) {
                return false;
            }
        }
        if (!in.Read(uv[0]) || !in.Read(uv[1]) || !in.Skip(4)) {
            return false;
        }
        // The icon's y and z point down and away; flip them to a y-up, z-towards-the-viewer frame.
        constexpr float kOne = 4096.0f;
        vertex.pos[0] = position[0] / kOne;
        vertex.pos[1] = -position[1] / kOne;
        vertex.pos[2] = -position[2] / kOne;
        vertex.normal[0] = normal[0] / kOne;
        vertex.normal[1] = -normal[1] / kOne;
        vertex.normal[2] = -normal[2] / kOne;
        vertex.uv[0] = uv[0] / kOne;
        vertex.uv[1] = uv[1] / kOne;
    }
    std::uint32_t tag, frame_length, play_offset, frames;
    float         speed;
    if (!in.Read(tag) || !in.Read(frame_length) || !in.Read(speed) || !in.Read(play_offset) || !in.Read(frames) ||
        frames > 1024) {
        return false;
    }
    for (std::uint32_t i = 0; i < frames; ++i) {
        std::uint32_t shape, keys;
        if (!in.Read(shape) || !in.Read(keys) || keys > 1024 || !in.Skip(8 * std::size_t(keys))) {
            return false;
        }
    }
    constexpr std::size_t kTexels = kTextureSize * kTextureSize;
    model.texture.clear();
    model.texture.reserve(kTexels);
    if (texture_type & 8) {
        std::uint32_t packed;
        if (!in.Read(packed) || packed > size - in.At()) {
            return false;
        }
        const std::size_t end = in.At() + packed;
        while (in.At() < end && model.texture.size() < kTexels) {
            std::uint16_t count, value;
            if (!in.Read(count)) {
                return false;
            }
            if (count & 0x8000) {
                for (int i = 0; i < 0x10000 - count; ++i) {
                    if (!in.Read(value)) {
                        return false;
                    }
                    model.texture.push_back(value);
                }
            } else {
                if (!in.Read(value)) {
                    return false;
                }
                model.texture.insert(model.texture.end(), count, value);
            }
        }
    } else {
        std::uint16_t value;
        while (model.texture.size() < kTexels && in.Read(value)) {
            model.texture.push_back(value);
        }
    }
    if (model.texture.size() < kTexels) {
        return false;
    }
    model.texture.resize(kTexels);
    return true;
}

// Orthographic, two-sided, with one directional light; the pose matches the card icon's resting view.
std::vector<std::uint8_t> Draw(const Model &model, int size) {
    const int   big = size * kSupersample;
    const float pi = 3.14159265358979f;
    const float yaw = 25.0f * pi / 180.0f, roll = -5.0f * pi / 180.0f;
    // Rz(roll) * Ry(yaw)
    const float cy = std::cos(yaw), sy = std::sin(yaw), cr = std::cos(roll), sr = std::sin(roll);
    const float m[3][3] = {
        {cr * cy, -sr,  cr * sy},
        {sr * cy, cr,   sr * sy},
        {-sy,     0.0f, cy     }
    };

    const std::size_t  count = model.vertices.size();
    std::vector<float> px(count), py(count), pz(count), nx(count), ny(count), nz(count);
    float              mean[3] = {};
    for (const Vertex &v : model.vertices) {
        for (int i = 0; i < 3; ++i) {
            mean[i] += v.pos[i] / count;
        }
    }
    float min_x = 1e30f, max_x = -1e30f, min_y = 1e30f, max_y = -1e30f;
    for (std::size_t i = 0; i < count; ++i) {
        const Vertex &v = model.vertices[i];
        const float   p[3] = {v.pos[0] - mean[0], v.pos[1] - mean[1], v.pos[2] - mean[2]};
        float        *out[3] = {&px[i], &py[i], &pz[i]};
        float        *nout[3] = {&nx[i], &ny[i], &nz[i]};
        for (int r = 0; r < 3; ++r) {
            *out[r] = m[r][0] * p[0] + m[r][1] * p[1] + m[r][2] * p[2];
            *nout[r] = m[r][0] * v.normal[0] + m[r][1] * v.normal[1] + m[r][2] * v.normal[2];
        }
        min_x = std::min(min_x, px[i]);
        max_x = std::max(max_x, px[i]);
        min_y = std::min(min_y, py[i]);
        max_y = std::max(max_y, py[i]);
    }
    const float extent = std::max(max_x - min_x, max_y - min_y);
    if (!(extent > 0.0f)) {
        return {};
    }
    const float scale = big * (1.0f - 2.0f * 0.06f) / extent;
    const float center_x = (max_x + min_x) / 2, center_y = (max_y + min_y) / 2;
    for (std::size_t i = 0; i < count; ++i) {
        px[i] = (px[i] - center_x) * scale + big / 2.0f;
        py[i] = big / 2.0f - (py[i] - center_y) * scale;
    }
    float       light[3] = {0.4f, 0.6f, 0.7f};
    const float length = std::sqrt(light[0] * light[0] + light[1] * light[1] + light[2] * light[2]);
    for (float &l : light) {
        l /= length;
    }

    std::vector<float>        depth(std::size_t(big) * big, -1e30f);
    std::vector<std::uint8_t> image(std::size_t(big) * big * 4, 0);
    for (std::size_t t = 0; t + 2 < count; t += 3) {
        const std::size_t a = t, b = t + 1, c = t + 2;
        const float       area = (px[b] - px[a]) * (py[c] - py[a]) - (px[c] - px[a]) * (py[b] - py[a]);
        if (std::fabs(area) < 1e-9f) {
            continue;
        }
        const int x0 = std::max(0, int(std::floor(std::min({px[a], px[b], px[c]}))));
        const int x1 = std::min(big, int(std::ceil(std::max({px[a], px[b], px[c]}))) + 1);
        const int y0 = std::max(0, int(std::floor(std::min({py[a], py[b], py[c]}))));
        const int y1 = std::min(big, int(std::ceil(std::max({py[a], py[b], py[c]}))) + 1);
        for (int y = y0; y < y1; ++y) {
            for (int x = x0; x < x1; ++x) {
                const float gx = x + 0.5f, gy = y + 0.5f;
                const float w0 = ((px[b] - gx) * (py[c] - gy) - (px[c] - gx) * (py[b] - gy)) / area;
                const float w1 = ((px[c] - gx) * (py[a] - gy) - (px[a] - gx) * (py[c] - gy)) / area;
                const float w2 = 1.0f - w0 - w1;
                if (w0 < 0 || w1 < 0 || w2 < 0) {
                    continue;
                }
                const float z = w0 * pz[a] + w1 * pz[b] + w2 * pz[c];
                float      &stored = depth[std::size_t(y) * big + x];
                if (z <= stored) {
                    continue;
                }
                stored = z;
                const Vertex &va = model.vertices[a], &vb = model.vertices[b], &vc = model.vertices[c];
                float         u = w0 * va.uv[0] + w1 * vb.uv[0] + w2 * vc.uv[0];
                float         v = w0 * va.uv[1] + w1 * vb.uv[1] + w2 * vc.uv[1];
                u -= std::floor(u);
                v -= std::floor(v);
                const int   tx = std::clamp(int(u * kTextureSize), 0, kTextureSize - 1);
                const int   ty = std::clamp(int(v * kTextureSize), 0, kTextureSize - 1);
                float       n[3] = {w0 * nx[a] + w1 * nx[b] + w2 * nx[c], w0 * ny[a] + w1 * ny[b] + w2 * ny[c],
                                    w0 * nz[a] + w1 * nz[b] + w2 * nz[c]};
                const float nl = std::sqrt(n[0] * n[0] + n[1] * n[1] + n[2] * n[2]) + 1e-9f;
                const float lit =
                    0.45f + 0.75f * std::fabs((n[0] * light[0] + n[1] * light[1] + n[2] * light[2]) / nl);
                const std::uint16_t texel = model.texture[std::size_t(ty) * kTextureSize + tx];
                const int           rgb[3] = {(texel & 31) << 3, ((texel >> 5) & 31) << 3, ((texel >> 10) & 31) << 3};
                std::uint8_t       *out = &image[(std::size_t(y) * big + x) * 4];
                for (int i = 0; i < 3; ++i) {
                    out[i] = std::uint8_t(std::clamp(rgb[i] * lit, 0.0f, 255.0f));
                }
                out[3] = 255;
            }
        }
    }

    // Box-filter the supersampled image down, weighting colour by coverage so the edges do not darken.
    std::vector<std::uint8_t> result(std::size_t(size) * size * 4, 0);
    for (int y = 0; y < size; ++y) {
        for (int x = 0; x < size; ++x) {
            float sum[4] = {};
            for (int sy2 = 0; sy2 < kSupersample; ++sy2) {
                for (int sx = 0; sx < kSupersample; ++sx) {
                    const std::uint8_t *in =
                        &image[((std::size_t(y) * kSupersample + sy2) * big + std::size_t(x) * kSupersample + sx) * 4];
                    const float alpha = in[3] / 255.0f;
                    for (int i = 0; i < 3; ++i) {
                        sum[i] += in[i] * alpha;
                    }
                    sum[3] += alpha;
                }
            }
            std::uint8_t *out = &result[(std::size_t(y) * size + x) * 4];
            if (sum[3] > 0) {
                for (int i = 0; i < 3; ++i) {
                    out[i] = std::uint8_t(std::lround(sum[i] / sum[3]));
                }
                out[3] = std::uint8_t(std::lround(255.0f * sum[3] / (kSupersample * kSupersample)));
            }
        }
    }
    return result;
}

bool ReadFile(const fs::path &path, std::vector<std::uint8_t> &out) {
    std::ifstream file(path, std::ios::binary);
    if (!file) {
        return false;
    }
    out.assign(std::istreambuf_iterator<char>(file), std::istreambuf_iterator<char>());
    return true;
}

// A PACK is a chain of 0x4C-byte entries (name[64], data offset, size, next entry), each offset relative
// to its own entry; an empty name ends it.
bool PackMember(const std::vector<std::uint8_t> &pack, const char *wanted, std::vector<std::uint8_t> &out) {
    std::size_t at = 0;
    while (at + 0x4C <= pack.size() && pack[at] != 0) {
        char name[65] = {};
        std::memcpy(name, &pack[at], 64);
        std::int32_t offset, size, next;
        std::memcpy(&offset, &pack[at + 64], 4);
        std::memcpy(&size, &pack[at + 68], 4);
        std::memcpy(&next, &pack[at + 72], 4);
        if (std::strcmp(name, wanted) == 0) {
            if (offset < 0 || size <= 0 || at + offset > pack.size() || std::size_t(size) > pack.size() - at - offset) {
                return false;
            }
            out.assign(pack.begin() + at + offset, pack.begin() + at + offset + size);
            return true;
        }
        if (next <= 0) {
            break;
        }
        at += next;
    }
    return false;
}

#ifdef _WIN32
// A Windows icon file of 32-bit DIB images; alpha carries the shape, so the AND masks stay clear.
std::vector<std::uint8_t> IcoFile(const std::vector<std::vector<std::uint8_t> > &images, const std::vector<int> &sizes) {
    std::vector<std::uint8_t> out;
    auto                      put16 = [&](std::uint16_t v) { out.insert(out.end(), {std::uint8_t(v), std::uint8_t(v >> 8)}); };
    auto                      put32 = [&](std::uint32_t v) {
        out.insert(out.end(), {std::uint8_t(v), std::uint8_t(v >> 8), std::uint8_t(v >> 16), std::uint8_t(v >> 24)});
    };
    put16(0);
    put16(1);
    put16(std::uint16_t(sizes.size()));
    std::uint32_t offset = 6 + 16 * std::uint32_t(sizes.size());
    for (int size : sizes) {
        const std::uint32_t mask_row = ((size + 31) / 32) * 4;
        const std::uint32_t bytes = 40 + size * size * 4 + mask_row * size;
        out.push_back(std::uint8_t(size >= 256 ? 0 : size));
        out.push_back(std::uint8_t(size >= 256 ? 0 : size));
        out.push_back(0);
        out.push_back(0);
        put16(1);
        put16(32);
        put32(bytes);
        put32(offset);
        offset += bytes;
    }
    for (std::size_t i = 0; i < sizes.size(); ++i) {
        const int size = sizes[i];
        put32(40);
        put32(size);
        put32(size * 2);
        put16(1);
        put16(32);
        put32(0);
        put32(size * size * 4);
        put32(0);
        put32(0);
        put32(0);
        put32(0);
        for (int y = size - 1; y >= 0; --y) {
            for (int x = 0; x < size; ++x) {
                const std::uint8_t *p = &images[i][(std::size_t(y) * size + x) * 4];
                out.insert(out.end(), {p[2], p[1], p[0], p[3]});
            }
        }
        out.insert(out.end(), std::size_t(((size + 31) / 32) * 4) * size, 0);
    }
    return out;
}

std::wstring Quoted(const fs::path &path) { return L"\"" + path.wstring() + L"\""; }

void CreateShortcut(const fs::path &link, const fs::path &target, const std::wstring &arguments,
                    const fs::path &icon) {
    const HRESULT init = CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED | COINIT_DISABLE_OLE1DDE);
    IShellLinkW  *shell_link = nullptr;
    if (SUCCEEDED(CoCreateInstance(CLSID_ShellLink, nullptr, CLSCTX_INPROC_SERVER, IID_IShellLinkW,
                                   reinterpret_cast<void **>(&shell_link)))) {
        shell_link->SetPath(target.c_str());
        shell_link->SetArguments(arguments.c_str());
        shell_link->SetWorkingDirectory(target.parent_path().c_str());
        shell_link->SetIconLocation(icon.c_str(), 0);
        shell_link->SetDescription(L"Dark Chronicle");
        IPersistFile *file = nullptr;
        if (SUCCEEDED(shell_link->QueryInterface(IID_IPersistFile, reinterpret_cast<void **>(&file)))) {
            if (FAILED(file->Save(link.c_str(), TRUE))) {
                std::fprintf(stderr, "icon: could not write %s\n", PathsDisplay(link).c_str());
            }
            file->Release();
        }
        shell_link->Release();
    }
    if (SUCCEEDED(init)) {
        CoUninitialize();
    }
}

void InstallWindowsIcon(const fs::path &data_root, const Model &model) {
    std::error_code error;
    const fs::path  icon = fs::absolute(data_root.parent_path() / "chronicletwo.ico", error);
    if (error || fs::exists(icon, error)) {
        return;
    }
    const std::vector<int>                  sizes = {16, 24, 32, 48, 64, 128, 256};
    std::vector<std::vector<std::uint8_t> > images;
    for (int size : sizes) {
        images.push_back(Draw(model, size));
        if (images.back().empty()) {
            return;
        }
    }
    const std::vector<std::uint8_t> bytes = IcoFile(images, sizes);
    {
        std::ofstream file(icon, std::ios::binary | std::ios::trunc);
        if (!file.write(reinterpret_cast<const char *>(bytes.data()), std::streamsize(bytes.size()))) {
            return;
        }
    }
    // Explorer shows the executable's own icon, which the build cannot carry; the shortcut can point at
    // the icon drawn here. Made only alongside a new icon so a moved or deleted shortcut stays that way.
    const fs::path exe = PathsExecutable();
    if (exe.empty()) {
        return;
    }
    const fs::path     data = fs::absolute(data_root, error);
    const fs::path     save = fs::absolute(PathsSaveRoot(), error);
    const std::wstring arguments = L"--data " + Quoted(data) + L" --save " + Quoted(save);
    CreateShortcut(exe.parent_path() / L"Dark Chronicle.lnk", exe, arguments, icon);
}
#endif

bool LoadModel(const fs::path &data_root, Model &model) {
    // Every language folder carries the same save.pac icons; English is checked first.
    for (const char *language : {"1", "0", "2", "3", "4", "5"}) {
        std::vector<std::uint8_t> pack, ico;
        if (ReadFile(data_root / "menu" / language / "save.pac", pack) && PackMember(pack, "dc2_ic.ico", ico) &&
            Decode(ico.data(), ico.size(), model)) {
            return true;
        }
    }
    return false;
}

} // namespace

std::vector<std::uint8_t> AppIconRender(const std::uint8_t *ico, std::size_t ico_size, int size) {
    Model model;
    if (ico == nullptr || size <= 0 || !Decode(ico, ico_size, model)) {
        return {};
    }
    return Draw(model, size);
}

std::vector<std::uint8_t> AppIconFromData(const fs::path &data_root, int size) {
    Model model;
    if (size <= 0 || !LoadModel(data_root, model)) {
        return {};
    }
    return Draw(model, size);
}

void AppIconInstall(const fs::path &data_root) {
    constexpr int                    kWindowIconSize = 256;
    static std::vector<std::uint8_t> window_icon;
    Model                            model;
    if (!LoadModel(data_root, model)) {
        return;
    }
    window_icon = Draw(model, kWindowIconSize);
    if (!window_icon.empty()) {
        GameSetIcon(window_icon.data(), kWindowIconSize);
    }
#ifdef _WIN32
    InstallWindowsIcon(data_root, model);
#endif
}
