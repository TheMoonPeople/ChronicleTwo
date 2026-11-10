#include <gtest/gtest.h>

#include <cstdint>
#include <cstdlib>

#include "mg_frame.hpp"

TEST(MgFramePositionDeathTest, WorldPositionAcceptsEightByteAlignedOutput) {
    EXPECT_EXIT(([] {
                    mgCFrame frame;
                    frame.SetPosition(3, 5, 7);
                    alignas(16) float storage[8] = {-1, -1, -1, -1, -1, -1, -1, -1};
                    float            *out = storage + 2;
                    if (reinterpret_cast<std::uintptr_t>(out) % 16 != 8) {
                        std::exit(2);
                    }
                    frame.GetWorldPosition0(out);
                    if (out[0] != 3 || out[1] != 5 || out[2] != 7 || out[3] != 1 ||
                        storage[0] != -1 || storage[1] != -1 || storage[6] != -1 || storage[7] != -1) {
                        std::exit(3);
                    }
                    std::exit(0);
                }()),
                testing::ExitedWithCode(0), "");
}

#ifdef _WIN32
#define WIN32_LEAN_AND_MEAN
#undef R
#undef B
#undef G
#include <windows.h>
#else
#include <sys/mman.h>
#include <unistd.h>
#endif
TEST(MgFramePositionDeathTest, PositionSetterOnlyReadsThreeCoordinates) {
    EXPECT_EXIT(([] {
#ifdef _WIN32
                    SYSTEM_INFO info;
                    GetSystemInfo(&info);
                    const auto size = info.dwPageSize;
                    auto      *pages = static_cast<char *>(VirtualAlloc(nullptr, size * 2, MEM_COMMIT | MEM_RESERVE, PAGE_READWRITE));
                    if (!pages)
                        std::exit(2);
                    DWORD old;
                    if (!VirtualProtect(pages + size, size, PAGE_NOACCESS, &old))
                        std::exit(3);
#else
                    const auto size = static_cast<size_t>(sysconf(_SC_PAGESIZE));
                    auto      *pages = static_cast<char *>(mmap(nullptr, size * 2, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0));
                    if (pages == MAP_FAILED || mprotect(pages + size, size, PROT_NONE))
                        std::exit(2);
#endif
                    float *xyz = reinterpret_cast<float *>(pages + size) - 3;
                    xyz[0] = 3;
                    xyz[1] = 4;
                    xyz[2] = 12;
                    mgCFrame frame;
                    frame.SetPosition(xyz);
                    float output[4]{};
                    frame.GetPosition(output);
                    if (output[0] != 3 || output[1] != 4 || output[2] != 12 || output[3] != 1)
                        std::exit(4);
                    std::exit(0);
                }()),
                testing::ExitedWithCode(0), "");
}
