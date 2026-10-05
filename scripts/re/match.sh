#!/usr/bin/env bash
set -euo pipefail

cd "$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
. scripts/host/container.sh

if in_container || command -v wibo >/dev/null 2>&1; then
    exec python3 scripts/re/match.py "$@"
fi

require_builder
ensure_image

exec "$BUILDER" run --rm \
    -v "$PWD:$CONTAINER_WORKDIR:Z" \
    -w "$CONTAINER_WORKDIR" \
    "$IMAGE" python3 scripts/re/match.py "$@"
