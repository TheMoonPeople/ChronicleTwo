#!/usr/bin/env bash
# Replays the scenes that reload characters, weapons and menus in the AddressSanitizer build, where an arena reset
# poisons what it frees, so any pointer still held into a reset arena is reported where it is used.
#
#   tools/kazarov/scripts/kazarov shell bash tools/crash/asan-replays.sh [data dir] [replay names...]
#
# The data directory defaults to port/run/data. Each replay's first line names its launch arguments before the first
# ';' or ':'; the run ends 120 frames after its last input. Logs go to port/build/pc-asan/replays.
set -euo pipefail

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
data=${1:-$root/port/run/data}
shift || true
replays=("$@")
if [ ${#replays[@]} -eq 0 ]; then
    replays=(
        dungeon-weapon-swap
        jump-dungeon-menu-item
        jump-dungeon-menu-character
        jump-dungeon-item-gun
        jump-town-menu-item
        jump-town-menu-character
        jump-town-item-weapon
        area-town-character
    )
fi

build=$root/port/build/pc-asan
cmake --preset linux-x64-asan > /dev/null
cmake --build --preset linux-x64-asan --target darkchronicle
out=$build/replays
mkdir -p "$out"

export ASAN_OPTIONS=${ASAN_OPTIONS:-detect_leaks=0:halt_on_error=1}
failed=0
for name in "${replays[@]}"; do
    input=$root/tools/input/$name.input
    header=$(head -1 "$input")
    if [[ "$header" != "# --"* ]]; then
        echo "asan-replays: $name has no launch arguments on its first line" >&2
        failed=1
        continue
    fi
    args=${header#\# }
    args=${args%%[;:]*}
    last=$(grep -Eo '^[0-9]+' "$input" | sort -n | tail -1)
    save=$out/$name-save
    rm -rf "$save"
    mkdir -p "$save"
    log=$out/$name.log
    # shellcheck disable=SC2086 # the header's arguments split as a command line does.
    if "$build/darkchronicle" --data "$data" --save "$save" --offscreen $args --input "$input" --frames $((last + 120)) > "$log" 2>&1 &&
        ! grep -q "AddressSanitizer" "$log"; then
        echo "asan-replays: $name passed"
    else
        echo "asan-replays: $name FAILED; see $log"
        grep -m1 -A12 "ERROR: AddressSanitizer" "$log" || tail -5 "$log"
        failed=1
    fi
done
exit $failed
