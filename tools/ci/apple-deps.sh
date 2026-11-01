#!/usr/bin/env bash
# Finish Apple dependencies with the SDK supplied by the macOS runner.
set -euo pipefail
platform=${1:?macos-arm64 or ios-arm64}
root=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
deps=$root/.kazarov/deps
GITHUB_ENV=${GITHUB_ENV:-$root/.kazarov/apple.env}
GITHUB_PATH=${GITHUB_PATH:-$root/.kazarov/apple.path}
case "$platform" in
    macos-arm64|ios-arm64) ;;
    *) echo "Unknown Apple platform: $platform" >&2; exit 2 ;;
esac
export CT_DEPS_ROOT=$deps
export PATH="$deps/bin:$PATH"
export CMAKE_BUILD_PARALLEL_LEVEL=${CMAKE_BUILD_PARALLEL_LEVEL:-$(sysctl -n hw.ncpu)}
export HOMEBREW_NO_AUTO_UPDATE=1 HOMEBREW_NO_INSTALL_CLEANUP=1
export CCACHE_MAXSIZE=${CCACHE_MAXSIZE:-1G}
echo "CCACHE_MAXSIZE=$CCACHE_MAXSIZE" >> "$GITHUB_ENV"
install_formulae() {
    local missing=() formula
    for formula in "$@"; do
        if ! brew list --versions "$formula" >/dev/null 2>&1; then missing+=("$formula"); fi
    done
    if [ "${#missing[@]}" -gt 0 ]; then brew install "${missing[@]}"; fi
}
rustup toolchain install 1.99.0 --profile minimal
rustup default 1.99.0
if [ ! -x "$deps/bin/cxxbridge" ]; then
    cargo install --locked cxxbridge-cmd --version 1.0.205 --root "$deps"
fi
if [ "$platform" = macos-arm64 ]; then
    MACOSX_DEPLOYMENT_TARGET=${MACOSX_DEPLOYMENT_TARGET:-$(python3 -c 'import json, sys; presets = json.load(open(sys.argv[1]))["configurePresets"]; print(next(p["cacheVariables"]["CMAKE_OSX_DEPLOYMENT_TARGET"] for p in presets if p["name"] == "macos"))' "$root/CMakePresets.json")}
    export MACOSX_DEPLOYMENT_TARGET
    echo "MACOSX_DEPLOYMENT_TARGET=$MACOSX_DEPLOYMENT_TARGET" >> "$GITHUB_ENV"
    install_formulae llvm lld cmake ninja python glslang sdl3 vulkan-headers vulkan-loader vulkan-tools molten-vk ccache
    ffmpeg=$root/.kazarov/ffmpeg/darwin-arm64
    python3 "$deps/kz-ffmpeg" --tarball "$deps/ffmpeg.tar.xz" --out "$ffmpeg" --jobs "$CMAKE_BUILD_PARALLEL_LEVEL"
    echo "SDL_VULKAN_LIBRARY=$(brew --prefix vulkan-loader)/lib/libvulkan.1.dylib" >> "$GITHUB_ENV"
    echo "VK_DRIVER_FILES=$(brew --prefix)/etc/vulkan/icd.d/MoltenVK_icd.json" >> "$GITHUB_ENV"
else
    install_formulae cmake ninja glslang ccache
    sdk=iphoneos
    sdk_version=$(xcrun --sdk "$sdk" --show-sdk-version)
    if [ "${sdk_version%%.*}" -lt 27 ]; then
        echo "iOS builds require Xcode with the iOS 27 SDK or newer, found $sdk_version" >&2
        exit 1
    fi
    triple=aarch64-apple-ios
    slice=ios-arm64
    rustup target add --toolchain 1.99.0 "$triple"
    prefix=$root/.kazarov/apple/$platform
    mkdir -p "$prefix"
    if [ ! -f "$prefix/sdl/lib/cmake/SDL3/SDL3Config.cmake" ]; then
        tar xzf "$deps/sdl.tar.gz" -C "$prefix"
        cmake -S "$prefix/SDL-release-3.4.0" -B "$prefix/sdl-build" -G Ninja \
            -DCMAKE_SYSTEM_NAME=iOS -DCMAKE_OSX_ARCHITECTURES=arm64 -DCMAKE_OSX_SYSROOT="$sdk" \
            -DCMAKE_OSX_DEPLOYMENT_TARGET=27.0 -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ \
            -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$prefix/sdl" \
            -DSDL_STATIC=ON -DSDL_SHARED=OFF -DSDL_TESTS=OFF -DSDL_EXAMPLES=OFF
        cmake --build "$prefix/sdl-build" --parallel "$CMAKE_BUILD_PARALLEL_LEVEL"
        cmake --install "$prefix/sdl-build"
    fi
    ffmpeg=$root/.kazarov/ffmpeg/$platform
    python3 "$deps/kz-ffmpeg" --tarball "$deps/ffmpeg.tar.xz" --target ios-arm64 \
        --out "$ffmpeg" --jobs "$CMAKE_BUILD_PARALLEL_LEVEL"
    if [ ! -d "$prefix/MoltenVK" ]; then tar xf "$deps/moltenvk.tar" -C "$prefix"; fi
    lib=$(find "$prefix/MoltenVK" -path "*/static/MoltenVK.xcframework/$slice/libMoltenVK.a" -print -quit)
    header=$(find "$prefix/MoltenVK" -path '*/include/vulkan/vulkan.h' -print -quit)
    test -n "$lib" && test -n "$header"
    echo "SDL3_PREFIX=$prefix/sdl" >> "$GITHUB_ENV"
    echo "MOLTENVK_LIBRARY=$lib" >> "$GITHUB_ENV"
    echo "VULKAN_INCLUDE_DIR=$(dirname "$(dirname "$header")")" >> "$GITHUB_ENV"
    echo "CT_IOS_SYSROOT=$sdk" >> "$GITHUB_ENV"
    echo "CT_IOS_RUST_TARGET=$triple" >> "$GITHUB_ENV"
fi
echo "$deps/bin" >> "$GITHUB_PATH"
echo "CT_DEPS_ROOT=$deps" >> "$GITHUB_ENV"
echo "KZ_FFMPEG_DIR=$ffmpeg" >> "$GITHUB_ENV"
echo "CMAKE_BUILD_PARALLEL_LEVEL=$CMAKE_BUILD_PARALLEL_LEVEL" >> "$GITHUB_ENV"
echo "CARGO_BUILD_JOBS=$CMAKE_BUILD_PARALLEL_LEVEL" >> "$GITHUB_ENV"
