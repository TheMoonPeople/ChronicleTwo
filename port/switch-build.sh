#!/usr/bin/env bash
set -euo pipefail
root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
[ -f "$root/tools/kazarov/tools/switch/build.sh" ] || git -C "$root" submodule update --init tools/kazarov
export KZ_SWITCH_ROOT="$root"
exec "$root/tools/kazarov/tools/switch/build.sh" "$@"
