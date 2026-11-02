# syntax=docker/dockerfile:1
# Build from the repository root. The export targets also work with Docker Desktop on Windows.
FROM rust:1.99.0-slim-bookworm@sha256:2c3a22f0a5533ea2dd5a16627bc841228151faa2d4de2644ac9987e4a2f1f2fa AS rust-base
FROM ubuntu:26.04@sha256:6a06111c3b0a8600feadb270aec771dc239bf407b25625f93f44ab00e11f4d3c AS fetch
ENV DEBIAN_FRONTEND=noninteractive
RUN printf 'Acquire::Retries "5";\nAcquire::http::Timeout "30";\n' > /etc/apt/apt.conf.d/80-retries
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates \
    && printf 'APT::Snapshot "20261031T000000Z";\n' > /etc/apt/apt.conf.d/50snapshot \
    && apt-get update && apt-get install -y --no-install-recommends python3 xz-utils unzip \
    && rm -rf /var/lib/apt/lists/*
# All downloads use retries, a checksum and a temporary file. A failed layer never exports a partial bundle.
RUN <<'SH'
cat > /usr/local/bin/fetch <<'PY'
#!/usr/bin/env python3
import hashlib
import pathlib
import shutil
import time
import urllib.request
import sys
url, digest, destination = sys.argv[1:]
path = pathlib.Path(destination)
path.parent.mkdir(parents=True, exist_ok=True)
partial = path.with_name(path.name + '.partial')
for attempt in range(5):
    try:
        with urllib.request.urlopen(url, timeout=120) as response, partial.open('wb') as output:
            shutil.copyfileobj(response, output)
        break
    except (OSError, TimeoutError):
        partial.unlink(missing_ok=True)
        if attempt == 4:
            raise
        time.sleep(2 ** attempt)
actual = hashlib.file_digest(partial.open('rb'), 'sha256').hexdigest()
if actual.lower() != digest.lower():
    sys.exit(f'{url}: SHA-256 mismatch: expected {digest}, got {actual}')
partial.replace(path)
PY
chmod +x /usr/local/bin/fetch
SH

FROM fetch AS declarations
# Read the pins from the build declarations so the image cannot silently supply older dependencies.
COPY port/CMakeLists.txt /declarations/port/CMakeLists.txt
COPY port/cmake/ /declarations/port/cmake/
COPY port/src/tests/CMakeLists.txt /declarations/port/tests/CMakeLists.txt
COPY tools/kazarov/cmake/ /declarations/kazarov/
RUN <<'SCRIPT'
python3 - <<'PY'
import json
import pathlib
import re
jobs = {}
def register(name, source):
    if name in jobs and jobs[name] != source:
        raise ValueError(f'Conflicting dependency declarations for {name}')
    jobs[name] = source
for file in pathlib.Path('/declarations').rglob('*'):
    if not file.is_file():
        continue
    text = file.read_text()
    for name, body in re.findall(r'FetchContent_Declare\((\w+)\s+(.*?)\)', text, re.S | re.I):
        url = re.search(r'\bURL\s+(https://\S+)', body)
        digest = re.search(r'URL_HASH\s+SHA256=([a-fA-F0-9]{64})', body)
        if url and digest and name.lower() != 'kz_vulkan_runtime':
            register(name.lower(), (url[1], digest[1], False))
    for name, url, digest in re.findall(r'_kz_port_vendor\(\w+\s+(\S+)\s+(https://\S+)\s+([a-fA-F0-9]{64})', text):
        register(name, (url, digest, True))
pathlib.Path('/pins.json').write_text(json.dumps(jobs, sort_keys=True))
PY
SCRIPT

FROM fetch AS sources
# Changes to target lists or comments keep this layer cached when the pins are unchanged.
COPY --from=declarations /pins.json /pins.json
RUN <<'SCRIPT'
python3 - <<'PY'
import concurrent.futures
import json
import pathlib
import subprocess
import tarfile
import zipfile
root = pathlib.Path('/opt/deps')
jobs = json.loads(pathlib.Path('/pins.json').read_text())
def acquire(item):
    name, (url, digest, vendor) = item
    archive = pathlib.Path('/tmp') / name
    subprocess.run(['fetch', url, digest, str(archive)], check=True)
    if vendor:
        destination = root / 'vendor' / name
        destination.parent.mkdir(parents=True, exist_ok=True)
        archive.replace(destination)
        return
    destination = root / 'sources' / name
    destination.mkdir(parents=True, exist_ok=True)
    unpack = pathlib.Path('/tmp/unpack') / name
    unpack.mkdir(parents=True)
    if zipfile.is_zipfile(archive):
        with zipfile.ZipFile(archive) as src:
            src.extractall(unpack)
    else:
        with tarfile.open(archive) as src:
            src.extractall(unpack, filter='data')
    [top] = unpack.iterdir()
    for child in top.iterdir():
        child.rename(destination / child.name)
    archive.unlink()
with concurrent.futures.ThreadPoolExecutor(max_workers=8) as pool:
    list(pool.map(acquire, jobs.items()))
PY
SCRIPT
COPY tools/kazarov/tools/ffmpeg/kz-ffmpeg /opt/deps/kz-ffmpeg
RUN <<'SH'
version=$(sed -n "s/^VERSION = '\(.*\)'$/\1/p" /opt/deps/kz-ffmpeg)
sha=$(sed -n "s/^SHA256 = '\(.*\)'$/\1/p" /opt/deps/kz-ffmpeg)
fetch "https://ffmpeg.org/releases/ffmpeg-$version.tar.xz" "$sha" /opt/deps/ffmpeg.tar.xz
SH

# Rust's official image and package managers own compiler and bridge installation.
FROM rust-base AS rust-tools
RUN rustup target add x86_64-pc-windows-gnullvm \
    && cargo install --locked cxxbridge-cmd --version 1.0.205

# Resolve the lockfile once in a cached layer, before game sources change.
FROM rust-tools AS rust-dependencies
COPY tools/kazarov/Cargo.toml tools/kazarov/Cargo.lock /opt/cargo-manifest/
RUN mkdir -p /opt/cargo-manifest/src/rust \
    && touch /opt/cargo-manifest/src/rust/lib.rs \
    && cargo fetch --locked --manifest-path /opt/cargo-manifest/Cargo.toml

FROM fetch AS linux-tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential clang-22 lld-22 llvm-22 libclang1-22 libclang-rt-22-dev python3-clang-22 \
    cmake ninja-build ccache nasm git pkg-config glslang-tools \
    mesa-vulkan-drivers vulkan-validationlayers libsdl3-dev libvulkan-dev \
    libxkbcommon-dev libwayland-dev libx11-dev libxcursor-dev libxi-dev libxrandr-dev libegl1-mesa-dev \
    && rm -rf /var/lib/apt/lists/*
ENV PATH=/opt/rust/bin:/usr/lib/llvm-22/bin:$PATH
COPY --from=rust-dependencies /usr/local/cargo/ /opt/rust/
COPY --from=rust-dependencies /usr/local/rustup/ /opt/rustup/
ENV RUSTUP_HOME=/opt/rustup CARGO_HOME=/opt/rust

FROM fetch AS apple
RUN mkdir -p /opt/deps/bin
RUN fetch https://github.com/libsdl-org/SDL/archive/refs/tags/release-3.4.0.tar.gz     9614b9696abc4597ffce6b888829dc6537ae500423474c342ac4a67222c5654c /opt/deps/sdl.tar.gz
RUN fetch https://github.com/KhronosGroup/MoltenVK/releases/download/v1.4.2/MoltenVK-ios.tar     b5d947b1660e6e9fed40b9cd2387e160aaab9e80b775c0cef7e14059405178c1 /opt/deps/moltenvk.tar
FROM scratch AS apple-deps
COPY --from=apple /opt/deps/ /deps/
COPY --from=sources /opt/deps/sources/ /deps/sources/
COPY --from=sources /opt/deps/vendor/ /deps/vendor/
COPY --from=sources /opt/deps/kz-ffmpeg /deps/kz-ffmpeg
COPY --from=sources /opt/deps/ffmpeg.tar.xz /deps/ffmpeg.tar.xz

FROM fetch AS windows-target-deps
RUN mkdir -p /opt/deps
RUN fetch https://github.com/libsdl-org/SDL/releases/download/release-3.4.18/SDL3-devel-3.4.18-mingw.zip \
    cd98158c8d025a816f430a600b4e9526524e6219ee884ec72bd498b80fd3bf58 /tmp/sdl.zip \
    && unzip -q /tmp/sdl.zip -d /opt/deps/sdl && rm -f /tmp/*.zip
RUN fetch https://github.com/KhronosGroup/Vulkan-Headers/archive/refs/tags/vulkan-sdk-1.4.363.0.zip \
    f4be95220ff0ee0b1c620301ff4fe9ae48592d71f4c30f2d5c571351a153ae81 /tmp/vulkan.zip \
    && unzip -q /tmp/vulkan.zip -d /opt/deps/vulkan && rm -f /tmp/*.zip
FROM linux-tools AS windows-compiler
RUN fetch https://github.com/mstorsjo/llvm-mingw/releases/download/20260922/llvm-mingw-20260922-ucrt-ubuntu-22.04-x86_64.tar.xz \
    bb7bb7654b33d5aa8712acb837c963b2e0c56352560c76105270a3268c665c21 /tmp/llvm.tar.xz \
    && mkdir /opt/llvm && tar xf /tmp/llvm.tar.xz -C /opt/llvm --strip-components=1 && rm /tmp/llvm.tar.xz
ENV PATH=/opt/llvm/bin:$PATH

FROM windows-compiler AS windows-cxxbridge
ENV CARGO_TARGET_X86_64_PC_WINDOWS_GNULLVM_LINKER=x86_64-w64-mingw32-clang
RUN cargo install --locked cxxbridge-cmd --version 1.0.205 \
    --target x86_64-pc-windows-gnullvm --root /opt/bridge

FROM windows-target-deps AS windows-sdk
RUN fetch https://static.rust-lang.org/dist/2026-10-01/rust-1.99.0-x86_64-pc-windows-gnullvm.tar.xz \
    958c1b5b43413c7f7c226234422799a0b13bbc6904659ed3300591762d5a4e55 /tmp/rust.tar.xz \
    && mkdir /tmp/rust && tar xf /tmp/rust.tar.xz -C /tmp/rust rust-1.99.0-x86_64-pc-windows-gnullvm/rustc rust-1.99.0-x86_64-pc-windows-gnullvm/cargo rust-1.99.0-x86_64-pc-windows-gnullvm/rust-std-x86_64-pc-windows-gnullvm \
    && mkdir -p /opt/deps/rust/1.99.0-gnullvm \
    && for component in rustc cargo rust-std-x86_64-pc-windows-gnullvm; do \
       cp -a /tmp/rust/rust-1.99.0-x86_64-pc-windows-gnullvm/$component/. /opt/deps/rust/1.99.0-gnullvm/; done && rm -rf /tmp/rust /tmp/rust.tar.xz

RUN fetch https://github.com/ccache/ccache/releases/download/v4.14.2/ccache-4.14.2-windows-x86_64.zip \
    6993ce645e53192cec592ee23186200b574ac4c59097ecde8d9cfd681b47ae84 /tmp/ccache.zip \
    && unzip -q /tmp/ccache.zip -d /opt/deps/ccache && rm /tmp/ccache.zip
RUN fetch https://github.com/Kitware/CMake/releases/download/v4.4.5/cmake-4.4.5-windows-x86_64.zip \
    326c826486d46a23cf9d5a1c9ee3a567d427bdd02c4a34071937a2a675cff004 /tmp/cmake.zip \
    && unzip -q /tmp/cmake.zip -d /opt/deps/cmake && rm /tmp/cmake.zip
RUN fetch https://www.python.org/ftp/python/3.14.0/python-3.14.0-embed-amd64.zip \
    8d4d3590c10449d78aa4375f534e6d5f3027d67fdc362dd1a882279db6f90fdf /tmp/python.zip \
    && unzip -q /tmp/python.zip -d /opt/deps/python && rm /opt/deps/python/python314._pth /tmp/python.zip
RUN fetch https://github.com/mstorsjo/llvm-mingw/releases/download/20260922/llvm-mingw-20260922-ucrt-x86_64.zip \
    e3ad77d117a4bea19a7a3b333341824d79a5a371004a10e25b8504e7b3047666 /tmp/llvm.zip \
    && mkdir -p /opt/deps/llvm && unzip -q /tmp/llvm.zip -d /opt/deps/llvm && rm -f /tmp/*.zip
RUN fetch https://github.com/ninja-build/ninja/releases/download/v1.13.2/ninja-win.zip \
    07fc8261b42b20e71d1720b39068c2e14ffcee6396b76fb7a795fb460b78dc65 /tmp/ninja.zip \
    && unzip -q /tmp/ninja.zip -d /opt/deps/ninja && rm -f /tmp/*.zip
RUN fetch https://github.com/KhronosGroup/glslang/releases/download/16.6.0/glslang-16.6.0-windows-x86_64-release.zip \
    82bf434e69b9bb4829de7e2b4bc2c5e7a7861e53d66cf75e5cc70f5f694a8d9b /tmp/glslang.zip \
    && unzip -q /tmp/glslang.zip -d /opt/deps/glslang && rm -f /tmp/*.zip
COPY --from=windows-cxxbridge /opt/bridge/bin/cxxbridge.exe /opt/deps/rust/1.99.0-gnullvm/bin/cxxbridge.exe

# Build the official loader sources; LunarG's binary download endpoint rejects some CI clients.
FROM windows-compiler AS windows-vulkan
COPY --from=windows-target-deps /opt/deps/vulkan/ /opt/headers/
RUN cmake -S /opt/headers/Vulkan-Headers-vulkan-sdk-1.4.363.0 -B /tmp/headers-build \
       -DCMAKE_INSTALL_PREFIX=/opt/vulkan-headers -DVULKAN_HEADERS_ENABLE_TESTS=OFF \
    && cmake --install /tmp/headers-build
RUN fetch https://codeload.github.com/KhronosGroup/Vulkan-Loader/tar.gz/refs/tags/vulkan-sdk-1.4.363.0 \
    941eff558fc74f248745fb7df367640cf89a8457f216dae498a74ae14b6ba6f7 /tmp/loader.tar.gz \
    && mkdir /tmp/loader && tar xf /tmp/loader.tar.gz -C /tmp/loader --strip-components=1 \
    && cmake -S /tmp/loader -B /tmp/loader-build -G Ninja \
       -DCMAKE_SYSTEM_NAME=Windows -DCMAKE_BUILD_TYPE=Release \
       -DCMAKE_C_COMPILER=x86_64-w64-mingw32-clang -DCMAKE_CXX_COMPILER=x86_64-w64-mingw32-clang++ \
       -DCMAKE_RC_COMPILER=x86_64-w64-mingw32-windres \
       -DCMAKE_PREFIX_PATH=/opt/vulkan-headers \
       -DBUILD_TESTS=OFF -DBUILD_WERROR=OFF \
    && cmake --build /tmp/loader-build --parallel \
    && mkdir -p /opt/vulkan-runtime/VulkanRT-X64-1.4.363.0-Components/x64 \
    && cp /tmp/loader-build/loader/vulkan-1.dll /opt/vulkan-runtime/VulkanRT-X64-1.4.363.0-Components/x64/

FROM windows-compiler AS windows-ffmpeg
# Build the pinned LGPL source rather than depending on expiring BtbN autobuild assets.
COPY --from=sources /opt/deps/kz-ffmpeg /opt/deps/kz-ffmpeg
COPY --from=sources /opt/deps/ffmpeg.tar.xz /opt/deps/ffmpeg.tar.xz
RUN <<'SCRIPT'
python3 - <<'PY'
import pathlib
import runpy
import subprocess
import tarfile
config = runpy.run_path('/opt/deps/kz-ffmpeg')
with tarfile.open('/opt/deps/ffmpeg.tar.xz') as src:
    src.extractall('/tmp/ffmpeg', filter='data')
source = next(pathlib.Path('/tmp/ffmpeg').iterdir())
flags = [flag for flag in config['CONFIGURE_FLAGS'] if flag not in ('--enable-static', '--disable-shared')]
flags += ['--enable-shared', '--disable-static', '--enable-cross-compile', '--target-os=mingw32',
          '--arch=x86_64', '--cross-prefix=x86_64-w64-mingw32-', '--cc=x86_64-w64-mingw32-clang',
          '--cxx=x86_64-w64-mingw32-clang++', '--prefix=/opt/windows-ffmpeg']
result = subprocess.run(['./configure', *flags], cwd=source, check=True, stdout=subprocess.PIPE, text=True)
print(result.stdout)
assert config['LICENSE_LINE'] in result.stdout.splitlines()
subprocess.run(['make', '-j' + str(__import__('os').cpu_count() or 1)], cwd=source, check=True)
subprocess.run(['make', 'install'], cwd=source, check=True)
subprocess.run(['rm', '-rf', '/tmp/ffmpeg', '/opt/llvm'], check=True)
PY
SCRIPT

FROM scratch AS windows-deps
COPY --from=windows-sdk /opt/deps/ /deps/
COPY --from=windows-vulkan /opt/vulkan-runtime/ /deps/vulkan-runtime/
COPY --from=sources /opt/deps/sources/ /deps/sources/
COPY --from=sources /opt/deps/vendor/ /deps/vendor/
COPY --from=windows-ffmpeg /opt/windows-ffmpeg/ /deps/ffmpeg/

FROM fetch AS windows-rust-runtime
RUN fetch https://static.rust-lang.org/dist/2026-10-01/rust-1.99.0-x86_64-pc-windows-gnullvm.tar.xz \
    958c1b5b43413c7f7c226234422799a0b13bbc6904659ed3300591762d5a4e55 /tmp/rust.tar.xz \
    && mkdir -p /opt/deps/rust/1.99.0-gnullvm/bin \
    && tar -xJOf /tmp/rust.tar.xz rust-1.99.0-x86_64-pc-windows-gnullvm/rustc/bin/libunwind.dll \
       > /opt/deps/rust/1.99.0-gnullvm/bin/libunwind.dll \
    && rm /tmp/rust.tar.xz

FROM scratch AS windows-cross-deps
COPY --from=windows-target-deps /opt/deps/ /deps/
COPY --from=windows-rust-runtime /opt/deps/rust/ /deps/rust/
COPY --from=windows-vulkan /opt/vulkan-runtime/ /deps/vulkan-runtime/
COPY --from=sources /opt/deps/sources/ /deps/sources/
COPY --from=sources /opt/deps/vendor/ /deps/vendor/
COPY --from=windows-ffmpeg /opt/windows-ffmpeg/ /deps/ffmpeg/

# Compress inside BuildKit so native runners transfer one file instead of thousands of SDK files.
FROM fetch AS windows-archive
RUN --mount=from=windows-deps,source=/deps,target=/deps <<'SH'
mkdir /bundle
tar -I 'gzip -1' -cf /bundle/deps.tar.gz -C / deps
sha256sum /bundle/deps.tar.gz | cut -d' ' -f1 > /bundle/deps.sha256
SH
FROM scratch AS windows-bundle
COPY --from=windows-archive /bundle/ /

FROM fetch AS apple-archive
RUN --mount=from=apple-deps,source=/deps,target=/deps <<'SH'
mkdir /bundle
tar -I 'gzip -1' -cf /bundle/deps.tar.gz -C / deps
sha256sum /bundle/deps.tar.gz | cut -d' ' -f1 > /bundle/deps.sha256
SH
FROM scratch AS apple-bundle
COPY --from=apple-archive /bundle/ /

FROM linux-tools AS linux
COPY --from=sources /opt/deps/ /opt/deps/
RUN python3 /opt/deps/kz-ffmpeg --tarball /opt/deps/ffmpeg.tar.xz --out /opt/deps/ffmpeg --jobs "$(nproc)"
ENV KZ_FFMPEG_DIR=/opt/deps/ffmpeg CT_DEPS_ROOT=/opt/deps
WORKDIR /work

# Cross compilation uses host executables and the same LLVM MinGW ABI as native Windows.
FROM linux-tools AS windows
COPY --from=windows-compiler /opt/llvm/ /opt/llvm/
COPY --from=windows-cross-deps /deps/ /opt/deps/
ENV PATH=/opt/llvm/bin:/opt/rust/bin:/usr/lib/llvm-22/bin:$PATH
ENV CT_DEPS_ROOT=/opt/deps KZ_FFMPEG_DIR=/opt/deps/ffmpeg
WORKDIR /work
