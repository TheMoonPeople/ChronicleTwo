#!/usr/bin/env bash
# Build and package, or run the Linux validation suite inside the dependency image.
set -euo pipefail
cd /work
git config --global --add safe.directory /work
mode=${1:?expected build or tests}
export CMAKE_BUILD_PARALLEL_LEVEL=${CMAKE_BUILD_PARALLEL_LEVEL:-$(nproc)}
export CARGO_BUILD_JOBS=$CMAKE_BUILD_PARALLEL_LEVEL
export CARGO_TARGET_DIR=/work/.kazarov/cargo-target/linux
export CCACHE_DIR=/work/.kazarov/ccache/linux
export CCACHE_BASEDIR=/work
export CCACHE_COMPILERCHECK=content
tests=OFF
preset=linux-x64-release
if [ "$mode" = tests ]; then
    tests=ON
    preset=linux-x64
    if [ "${EVENT:-}" = pull_request ]; then
        base=${PR_BASE:?}
    elif [ "${EVENT:-}" = push ] && [ -n "${BEFORE:-}" ] && ! [[ "$BEFORE" =~ ^0+$ ]]; then
        base=$BEFORE
    else
        git fetch --no-tags origin "refs/heads/${DEFAULT_BRANCH:?}"
        base=$(git merge-base HEAD FETCH_HEAD)
    fi
    git cat-file -e "$base^{commit}"
    export CT_PAL_TIMING_BASE=$base
fi
args=(-DCT_BUILD_TESTS="$tests" -DCT_SYMBOLS=split
      -DCMAKE_C_COMPILER_LAUNCHER=ccache -DCMAKE_CXX_COMPILER_LAUNCHER=ccache)
if [ "$tests" = ON ]; then
    args+=(-DCT_TEST_TIMEOUT=60 -DCT_GPU_SLOW_TIMEOUT=180 -DCT_PAL_TIMING_BASE="$CT_PAL_TIMING_BASE")
fi
cmake --preset "$preset" -C tools/ci/dependencies.cmake "${args[@]}"
cmake --build --preset "$preset" --parallel "$CMAKE_BUILD_PARALLEL_LEVEL"
build=port/build/pc-release
if [ "$tests" = ON ]; then
    build=port/build/pc
    python3 -c 'from clang.cindex import Index; Index.create()'
    ctest --test-dir "$build" --output-on-failure --no-tests=error -j4 --output-junit tests.xml
    cmake -S tools/luau/harness -B port/build/luau-harness -G Ninja -C tools/ci/dependencies.cmake \
        -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_CXX_COMPILER_LAUNCHER=ccache
    cmake --build port/build/luau-harness --parallel "$CMAKE_BUILD_PARALLEL_LEVEL"
    python3 -m unittest discover -s tools/luau -p 'test_*.py'
    python3 tools/luau/stb2luau/api.py --check
    cargo test --locked --manifest-path tools/kazarov/Cargo.toml
    python3 -m unittest discover -s tools/crash -p 'test_*.py' -v
    python3 scripts/port/native_gate.py --binary "$build/darkchronicle"
    llvm-readobj --file-headers "$build/darkchronicle" | grep 'Type: SharedObject'
    llvm-readelf --notes "$build/darkchronicle" | grep 'Build ID'
    llvm-readelf --sections "$build/darkchronicle" | grep '.gnu_debuglink'
    offset=$(llvm-nm "$build/darkchronicle" | awk '$3 == "main" { print $1 }')
    printf '#0  darkchronicle+0x%s\n' "$offset" > report.txt
    python3 tools/crash/symbolize.py report.txt --binary "$build/darkchronicle.debug" > symbolized.txt
    grep 'main.cpp:' symbolized.txt
else
    mkdir -p artifacts
    cmake --install "$build" --prefix /work/.kazarov/install
    tar -I 'gzip -1' -cf artifacts/chronicletwo-linux-x64.tar.gz -C .kazarov/install .
    tar -I 'gzip -1' -cf artifacts/chronicletwo-linux-x64-symbols.tar.gz -C "$build" darkchronicle darkchronicle.debug
fi
ccache --show-stats
