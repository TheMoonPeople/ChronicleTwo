#!/usr/bin/env bash
# Builds a configuration through Kazarov and runs it; with no configuration, the host's Release port build.
#
#   ./run.sh                   run the Release port build
#   ./run.sh ps2-pal           boot the PS2 build in PCSX2
root=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
[ -f "$root/tools/kazarov/scripts/kazarov" ] || git -C "$root" submodule update --init tools/kazarov
exec "$root/tools/kazarov/scripts/kazarov" run "$@"
