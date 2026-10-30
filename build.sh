#!/usr/bin/env bash
# Builds a configuration through Kazarov; with no configuration, ps2-pal.
#
#   ./build.sh                 build ps2-pal
#   ./build.sh ps2-pal elf     build the ELF only
#   CLEAN=1 ./build.sh         discard build/pal and build it again
root=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
if [ "${1:-}" = switch ]; then
    shift
    exec "$root/port/switch-build.sh" "$@"
fi
[ -f "$root/tools/kazarov/scripts/kazarov" ] || git -C "$root" submodule update --init tools/kazarov
exec "$root/tools/kazarov/scripts/kazarov" build "$@"
