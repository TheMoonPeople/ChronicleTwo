#!/usr/bin/env bash
# Build the executable and verify it against retail, leaving the results in
# build/pal. Use run.sh instead to master a disc image as well and boot it in
# PCSX2.
#
# On the host this runs the build in the dev container with the working tree
# mounted; inside a container it drives the same targets against the tree.
#
#   ./build.sh              build what has changed since the last run
#   CLEAN=1 ./build.sh      throw build/pal away first, so everything is rebuilt
#   JOBS=8 ./build.sh       run 8 jobs rather than one per CPU
#
# What was extracted from the disc survives CLEAN: it is checked against the
# disc rather than against a stamp. `scripts/build/extract.py --force` writes
# it out again.
set -euo pipefail

cd "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. scripts/host/container.sh

require_rom

# The build itself, the same inside a container as through the one started
# below. CLEAN discards the build directory -- and nothing else under build/ --
# under the lock every build of the tree takes (see scripts/build/cmake.sh).
# The progress report follows the link.
BUILD='
    set -e
    dir=${BUILD_DIR:-build/pal}
    if [ "${CLEAN:-0}" = 1 ]; then
        echo "CLEAN=1: discarding $dir; everything in it is built again."
        flock .build.lock rm -rf "$dir"
    fi
    scripts/build/cmake.sh build ctx objdiff
    python3 scripts/build/progress_report.py
'

if in_container; then
    exec bash -c "$BUILD"
fi

# The image holds only the toolchain, so it is built once and reused; the tree
# is mounted rather than copied in, which is what keeps the extracted disc
# (rom/), the split (ps2/asm/) and every object (build/) between runs. The image
# is rebuilt automatically when the Dockerfile or its patches change;
# REBUILD_IMAGE=1 forces a rebuild.
require_builder
ensure_image
report_parallelism

# bash 3.2, which is what macOS ships, treats an empty array as unset under
# `set -u`, hence the guarded expansions below.
TTY=()
if [ -t 1 ]; then TTY=(-t); fi

# CLEAN, JOBS and BUILD_DIR are for the build inside the container.
ENV_ARGS=(-e "CLEAN=${CLEAN:-0}")
if [ -n "${JOBS:-}" ]; then ENV_ARGS+=(-e "JOBS=$JOBS"); fi
if [ -n "${BUILD_DIR:-}" ]; then ENV_ARGS+=(-e "BUILD_DIR=$BUILD_DIR"); fi

"$BUILDER" run --rm ${TTY[@]+"${TTY[@]}"} "${ENV_ARGS[@]}" \
    -v "$PWD:$CONTAINER_WORKDIR:Z" \
    -w "$CONTAINER_WORKDIR" \
    -e HOME=/tmp \
    "$IMAGE" bash -c "$BUILD"
