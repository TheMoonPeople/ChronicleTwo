#!/usr/bin/env bash
# Builds a configuration through Kazarov, masters the disc image and boots it in PCSX2; with no configuration, ps2-pal.
#
#   ./run.sh                   run ps2-pal
#   ./run.sh ps2-pal           the same, named
root=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
"$root/scripts/ensure_kazarov_submodule.sh"
exec "$root/tools/kazarov/scripts/kazarov" run "$@"
