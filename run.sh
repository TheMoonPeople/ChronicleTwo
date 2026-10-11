#!/usr/bin/env bash
# Builds a configuration through Kazarov, masters the disc image and boots it in PCSX2; with no configuration, ps2-pal.
#
#   ./run.sh                   run ps2-pal
#   ./run.sh ps2-pal           the same, named
root=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
[ -f "$root/tools/kazarov/bin/kazarov" ] || git -C "$root" submodule update --init tools/kazarov
exec "$root/tools/kazarov/bin/kazarov" run "$@"
