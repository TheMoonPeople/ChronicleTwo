#!/usr/bin/env bash
# The rebuild objdiff's GUI runs on every save. Kept as short as it can be:
# this is in the edit-save-look loop, not a batch build.
#
# `cmake --build` rather than scripts/build/cmake.sh, which configures first
# and is redundant here, because ninja re-runs cmake by itself when
# CMakeLists.txt or the generator inputs change. The long way round is only
# for a build directory that cannot be used as it stands: never configured, or
# configured somewhere else (see scripts/build/cmake.sh).
set -euo pipefail

cd "$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
. scripts/host/container.sh

# Under the lock scripts/build/cmake.sh takes, so a save that lands while a
# split is rewriting ps2/asm/ waits for the split rather than compiling
# against it.
REBUILD='
    exec flock .build.lock sh -c "
        cache=build/pal/CMakeCache.txt
        home=\$(sed -n \"s/^CMAKE_HOME_DIRECTORY:INTERNAL=//p\" \"\$cache\" 2>/dev/null | head -1)
        if [ -f build/pal/build.ninja ] && [ \"\$home\" = \"\$(pwd)\" ]; then
            scripts/build/globs.sh build/pal
            cmake --build build/pal --target objdiff || exit \$?
            exec python3 scripts/build/objdiff_config.py --build-dir build/pal
        fi
        CHRONICLETWO_BUILD_LOCKED=1 exec scripts/build/cmake.sh objdiff
    "
'

if in_container; then
    exec sh -c "$REBUILD"
fi

require_builder
ensure_image

exec "$BUILDER" run --rm \
    -v "$PWD:$CONTAINER_WORKDIR:Z" \
    -w "$CONTAINER_WORKDIR" \
    -e HOME=/tmp \
    "$IMAGE" sh -c "$REBUILD"
