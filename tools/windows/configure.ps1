param([string]$Root, [string]$BuildDirectory, [switch]$Tests, [string]$BuildType = 'Debug',
      [string]$VulkanLibrary, [int]$TestTimeout = 5, [string]$Symbols = 'embedded', [switch]$AddressSanitizer)
$ErrorActionPreference = 'Stop'
. "$PSScriptRoot/common.ps1"
$root = (Resolve-WindowsRoot $Root).Replace('\', '/')
$build = (Resolve-WindowsBuild $root $BuildDirectory).Replace('\', '/')
$source = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '../..')).Replace('\', '/')
$llvm = "$root/deps/llvm/llvm-mingw-20260922-ucrt-x86_64/bin"
$rust = "$root/deps/rust/1.99.0-gnullvm/bin"
$vulkanRuntime = "$root/deps/vulkan-runtime/VulkanRT-X64-1.4.363.0-Components/x64"
if (!$VulkanLibrary) { $VulkanLibrary = "$vulkanRuntime/vulkan-1.dll" }
$corrosion = "$root/deps/sources/corrosion"
if (!(Test-Path -LiteralPath "$rust/rustc.exe") -or !(Test-Path -LiteralPath "$rust/cxxbridge.exe") -or
    !(Test-Path -LiteralPath "$corrosion/CMakeLists.txt")) {
    throw 'Export windows-deps from tools/ci/Dockerfile to the dependency root before configuring.'
}
$env:CARGO_HOME = "$root/deps/rust/cargo-home"
$env:CT_DEPS_ROOT = "$root/deps"
$env:PATH = "$root/deps/cmake/cmake-4.4.5-windows-x86_64/bin;$root/deps/python;$rust;$llvm;$env:PATH"
$cmake = Find-WindowsTool cmake 'C:/Program Files/CMake/bin/cmake.exe'
$python = "$root/deps/python/python.exe"
$testOption = if ($Tests) { 'ON' } else { 'OFF' }
# AddressSanitizer poisons reset arenas (docs/PC.md); its runtime DLL is in llvm-mingw's bin.
$sanitizer = if ($AddressSanitizer) { @('-DCMAKE_C_FLAGS=-fsanitize=address -fno-omit-frame-pointer', '-DCMAKE_CXX_FLAGS=-fsanitize=address -fno-omit-frame-pointer', '-DCMAKE_EXE_LINKER_FLAGS=-fsanitize=address', '-DCMAKE_SHARED_LINKER_FLAGS=-fsanitize=address') } else { @() }
$ccache = (Get-ChildItem -LiteralPath "$root/deps/ccache" -Filter ccache.exe -Recurse -File | Select-Object -First 1).FullName
& $cmake -S $source -B $build -G Ninja -C "$source/tools/ci/dependencies.cmake" `
    -DPLATFORM=PC "-DCMAKE_BUILD_TYPE=$BuildType" "-DCT_BUILD_TESTS=$testOption" "-DCT_TEST_TIMEOUT=$TestTimeout" "-DCT_SYMBOLS=$Symbols" `
    "-DCMAKE_CXX_COMPILER_LAUNCHER=$ccache" `
    "-DCT_WINDOWS_CARGO_HOME=$root/deps/rust/cargo-home" `
    "-DCMAKE_CXX_COMPILER=$llvm/clang++.exe" "-DCMAKE_RC_COMPILER=$llvm/windres.exe" `
    "-DCMAKE_MAKE_PROGRAM=$root/deps/ninja/ninja.exe" "-DPython3_EXECUTABLE=$python" `
    "-DSDL3_DIR=$root/deps/sdl/SDL3-3.4.18/x86_64-w64-mingw32/lib/cmake/SDL3" `
    "-DKZ_FFMPEG_DIR=$root/deps/ffmpeg" `
    "-DVulkan_INCLUDE_DIR=$root/deps/vulkan/Vulkan-Headers-vulkan-sdk-1.4.363.0/include" `
    "-DVulkan_LIBRARY=$VulkanLibrary" `
    "-DKZ_VULKAN_RUNTIME_DIR=$vulkanRuntime" `
    "-DGLSLANG_VALIDATOR=$root/deps/glslang/bin/glslang.exe" `
    "-DRust_COMPILER=$rust/rustc.exe" "-DRust_CARGO=$rust/cargo.exe" `
    "-DRust_CARGO_TARGET=x86_64-pc-windows-gnullvm" "-DINSTALLED_CXXBRIDGE=$rust/cxxbridge.exe" `
    "-DFETCHCONTENT_SOURCE_DIR_CORROSION=$corrosion" @sanitizer
exit $LASTEXITCODE
