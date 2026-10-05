#!/bin/sh
# The one place that runs cmake: build.sh, run.sh and the Dockerfile's CMD all
# come through here, so the configure rules cannot drift.
#
#   scripts/build/cmake.sh [<target>...]       build these targets (default: build)
#   BUILD_DIR=build/other scripts/build/cmake.sh elf
#   JOBS=8 scripts/build/cmake.sh              run 8 jobs rather than one per CPU
#
# It brings the build files up to date, builds `setup` (the disc checked and
# extracted, the executable split), then builds what was asked for.
#
# CMakeCache.txt records the absolute source directory it was generated for,
# and the build tree is shared between contexts that see the tree at different
# paths (the dev container, the devcontainer, a host checkout), so a cache from
# one makes cmake refuse to run under another -- `cmake --build` included,
# since it re-runs configure through build.ninja. That is why nothing else
# calls cmake. `--fresh` fixes it but discards a good cache, so it is used only
# when the recorded source directory differs, or when configure fails.
set -eu

cd "$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)"

# One build of the tree at a time. The split rewrites thousands of files under
# ps2/asm/ over several seconds, and a unit compiled against a half-written
# split is wrong throughout; tools/mwccgap also writes its temporaries into the
# working directory. Everything that builds takes this lock. It lives outside
# build/ so that CLEAN cannot delete it from under a build holding it.
BUILD_LOCK=.build.lock
if [ -z "${CHRONICLETWO_BUILD_LOCKED:-}" ]; then
    export CHRONICLETWO_BUILD_LOCKED=1
    if ! flock -n "$BUILD_LOCK" true; then
        echo "cmake.sh: another build of this tree is running; waiting for it." >&2
    fi
    exec flock "$BUILD_LOCK" "$(pwd)/scripts/build/cmake.sh" "$@"
fi

BUILD_DIR=${BUILD_DIR:-build/pal}
python3 scripts/build/setup_gcc.py
python3 scripts/build/setup_mwccgap.py

# Whether the existing cache was generated for this source directory. A cache
# that is absent or unreadable is not stale -- there is simply nothing to
# reuse, and cmake will write one.
cache_is_stale() {
    cache=$BUILD_DIR/CMakeCache.txt
    [ -f "$cache" ] || return 1

    cache_source=$(sed -n 's/^CMAKE_HOME_DIRECTORY:INTERNAL=//p' "$cache" | head -1)
    [ -n "$cache_source" ] || return 1
    [ "$cache_source" != "$(pwd)" ]
}

configure() {
    if cache_is_stale; then
        echo "cmake.sh: build cache was generated elsewhere; reconfiguring from scratch." >&2
        cmake --fresh -G Ninja -S . -B "$BUILD_DIR"
        return
    fi

    # The retry covers what the path check cannot: a cache left by a different
    # generator or an incompatible cmake, and anything else that only shows up
    # when configure actually runs.
    cmake -G Ninja -S . -B "$BUILD_DIR" && return
    echo "cmake.sh: configure failed; retrying from scratch." >&2
    cmake --fresh -G Ninja -S . -B "$BUILD_DIR"
}

# Ninja already knows when the build files are out of date: build.ninja is a
# target of its own, rebuilt when CMakeLists.txt or anything named in
# CMAKE_CONFIGURE_DEPENDS changes -- scripts/build/globs.sh's listing of the
# sources and headers among them. So ask for that, and configure outright only
# when there is nothing to ask.
regenerate() {
    scripts/build/globs.sh "$BUILD_DIR"
    if [ ! -f "$BUILD_DIR/build.ninja" ] || cache_is_stale; then
        configure
        return
    fi
    # Printed only when there was something to do, so the usual case does not
    # open with ninja reporting that it had nothing to.
    if regen=$(cmake --build "$BUILD_DIR" --target build.ninja 2>&1); then
        case $regen in
            ''|*"no work to do"*) : ;;
            *) printf '%s\n' "$regen" ;;
        esac
        return
    fi
    printf '%s\n' "$regen" >&2
    echo "cmake.sh: regenerating the build files failed; reconfiguring from scratch." >&2
    cmake --fresh -G Ninja -S . -B "$BUILD_DIR"
}

# Every CPU this process may run on, unless JOBS says otherwise. Exported so
# the split spreads over the same count.
if [ -z "${JOBS:-}" ]; then
    JOBS=$(nproc 2>/dev/null || getconf _NPROCESSORS_ONLN 2>/dev/null || echo 1)
fi
export JOBS

build() {
    cmake --build "$BUILD_DIR" --parallel "$JOBS" --target "$@"
}

# Build targets only when a dry run finds something to do, so an up-to-date
# prerequisite does not print ninja's "no work to do" ahead of the real build.
build_if_stale() {
    case $(cmake --build "$BUILD_DIR" --target "$@" -- -n 2>&1) in
        *"no work to do"*) : ;;
        *) build "$@" ;;
    esac
}

regenerate

# Configure may read the split (listings, reference files), so the first time
# it appears the build files are generated again.
had_split=1
[ -f "$BUILD_DIR/stamps/disassembled" ] || had_split=0

build_if_stale setup

if [ "$had_split" = 0 ]; then
    cmake -G Ninja -S . -B "$BUILD_DIR"
fi

[ $# -gt 0 ] || set -- build

build "$@"
