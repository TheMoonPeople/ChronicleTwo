#!/usr/bin/env bash
# Cross compile Windows executables using Linux host tools inside Docker.
set -euo pipefail
cd /work
mode=${1:?expected build or tests}
case "$mode" in build) tests=OFF ;; tests) tests=ON ;; *) exit 2 ;; esac
export CMAKE_BUILD_PARALLEL_LEVEL=${CMAKE_BUILD_PARALLEL_LEVEL:-$(nproc)}
export CARGO_BUILD_JOBS=$CMAKE_BUILD_PARALLEL_LEVEL
export CARGO_NET_OFFLINE=true
export CARGO_TARGET_DIR=/work/.kazarov/cargo-target/windows-cross
export CCACHE_DIR=/work/.kazarov/ccache/windows-cross
export CCACHE_MAXSIZE=${CCACHE_MAXSIZE:-1G}
export CCACHE_BASEDIR=/work
# The MinGW driver is a shell wrapper; identify the compiler it invokes.
export CCACHE_COMPILERCHECK="string:$(sha256sum /opt/llvm/bin/clang | cut -d' ' -f1)"
export CARGO_TARGET_X86_64_PC_WINDOWS_GNULLVM_LINKER=x86_64-w64-mingw32-clang
export CC_x86_64_pc_windows_gnullvm=x86_64-w64-mingw32-clang
export CXX_x86_64_pc_windows_gnullvm=x86_64-w64-mingw32-clang++
export AR_x86_64_pc_windows_gnullvm=llvm-ar
build=port/build/windows-cross-x64-release
runtime=/opt/deps/vulkan-runtime/VulkanRT-X64-1.4.363.0-Components/x64
cmake -S . -B "$build" -G Ninja -C tools/ci/dependencies.cmake \
    -DCMAKE_TOOLCHAIN_FILE="$PWD/tools/ci/windows-toolchain.cmake" \
    -DPLATFORM=PC -DCMAKE_BUILD_TYPE=Release -DCT_SYMBOLS=split \
    -DCT_BUILD_TESTS="$tests" -DCT_TEST_TIMEOUT=60 \
    -DCMAKE_C_COMPILER_LAUNCHER=ccache -DCMAKE_CXX_COMPILER_LAUNCHER=ccache \
    -DSDL3_DIR=/opt/deps/sdl/SDL3-3.4.18/x86_64-w64-mingw32/lib/cmake/SDL3 \
    -DVulkan_INCLUDE_DIR=/opt/deps/vulkan/Vulkan-Headers-vulkan-sdk-1.4.363.0/include \
    -DVulkan_LIBRARY="$runtime/vulkan-1.dll" -DKZ_VULKAN_RUNTIME_DIR="$runtime" \
    -DKZ_UNWIND_DLL=/opt/deps/rust/1.99.0-gnullvm/bin/libunwind.dll \
    -DGLSLANG_VALIDATOR=/usr/bin/glslangValidator -DINSTALLED_CXXBRIDGE=/opt/rust/bin/cxxbridge
cmake --build "$build" --parallel "$CMAKE_BUILD_PARALLEL_LEVEL"
if [ "$tests" = ON ]; then
    export KAZAROV_FFMPEG_INCLUDE=/opt/deps/ffmpeg/include
    export KAZAROV_FFMPEG_LIB=/opt/deps/ffmpeg/lib
    cargo test --locked --no-run --target x86_64-pc-windows-gnullvm \
        --manifest-path tools/kazarov/Cargo.toml --message-format=json > "$build/rust-tests.json"
    python3 - "$build" <<'PY'
import json
import pathlib
import shutil
import sys
build = pathlib.Path(sys.argv[1])
destination = build / 'rust-tests'
destination.mkdir(exist_ok=True)
for line in (build / 'rust-tests.json').read_text().splitlines():
    item = json.loads(line)
    if item.get('reason') == 'compiler-artifact' and item.get('profile', {}).get('test') and item.get('executable'):
        executable = pathlib.Path(item['executable'])
        shutil.copy2(executable, destination / executable.name)
for dll in build.glob('*.dll'):
    shutil.copy2(dll, destination / dll.name)
shutil.copy2(build / 'assets/data.zip', destination / 'data.zip')
shutil.copy2(build / 'ffmpeg.exe', destination / 'ffmpeg.exe')
PY
fi
ccache --show-stats
