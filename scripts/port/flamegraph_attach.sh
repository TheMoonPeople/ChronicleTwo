#!/usr/bin/env bash
# Record CPU samples from a running darkchronicle and write an SVG flamegraph.
# Requires: perf (pacman -S perf), read access to the game process (same user; ptrace allowed).
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
FG="${ROOT}/tools/FlameGraph"
OUT_DIR="${ROOT}/port/run/profile"
DURATION="${DURATION:-25}"
FREQ="${FREQ:-997}"

usage() {
    cat <<EOF
Usage: $(basename "$0") [PID]

Attach to a running PC port binary and write a flamegraph SVG under port/run/profile/.

  DURATION=30 $(basename "$0")     # seconds to sample (default 25)
  FREQ=1997 $(basename "$0") 1234  # sample rate and explicit PID

If PID is omitted, picks the newest darkchronicle under port/build/ (not *_tests).

Install perf once: sudo pacman -S perf
If attach fails:   sudo sysctl -w kernel.yama.ptrace_scope=0
Use a build with debug symbols (linux-x64 or linux-x64-release) for readable stacks.
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
    usage
    exit 0
fi

if ! command -v perf >/dev/null; then
    echo "flamegraph_attach: perf not found. Install with: sudo pacman -S perf" >&2
    exit 1
fi

if [[ ! -d "$FG" ]]; then
    echo "flamegraph_attach: cloning FlameGraph into tools/FlameGraph ..." >&2
    git clone --depth 1 https://github.com/brendangregg/FlameGraph.git "$FG"
fi

PID="${1:-}"
if [[ -z "$PID" ]]; then
    mapfile -t candidates < <(pgrep -af 'port/build/.*/darkchronicle' 2>/dev/null | grep -v darkchronicle_tests || true)
    if ((${#candidates[@]} == 0)); then
        echo "flamegraph_attach: no darkchronicle process found. Start the game, then re-run." >&2
        exit 1
    fi
    if ((${#candidates[@]} > 1)); then
        echo "flamegraph_attach: multiple matches; pass PID explicitly:" >&2
        printf '  %s\n' "${candidates[@]}" >&2
        exit 1
    fi
    PID="$(awk '{print $1}' <<<"${candidates[0]}")"
fi

if ! kill -0 "$PID" 2>/dev/null; then
    echo "flamegraph_attach: PID $PID is not running." >&2
    exit 1
fi

EXE="$(readlink -f "/proc/$PID/exe" 2>/dev/null || true)"
echo "flamegraph_attach: PID=$PID exe=${EXE:-unknown}"
echo "flamegraph_attach: recording ${DURATION}s at ${FREQ} Hz (play the scene you care about now) ..."

mkdir -p "$OUT_DIR"
STAMP="$(date +%Y%m%d-%H%M%S)"
DATA="$OUT_DIR/perf-${STAMP}.data"
SVG="$OUT_DIR/flamegraph-${STAMP}.svg"

perf record -p "$PID" -g --call-graph dwarf -F "$FREQ" -o "$DATA" -- sleep "$DURATION"

perf script -i "$DATA" | "$FG/stackcollapse-perf.pl" | "$FG/flamegraph.pl" >"$SVG"

echo "flamegraph_attach: wrote $SVG"
echo "flamegraph_attach: raw data $DATA (delete when done)"
if command -v xdg-open >/dev/null; then
    xdg-open "$SVG" >/dev/null 2>&1 &
fi
