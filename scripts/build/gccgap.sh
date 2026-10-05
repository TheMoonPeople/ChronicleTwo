#!/bin/sh
set -eu

obj=$1
dep=$2
src=$3
shift 3

mkdir -p "$(dirname "$obj")"
EE_GCC_SOURCE="$src" python3 tools/mwccgap/mwccgap.py "$src" "$obj" \
    --mwcc-path scripts/build/ee_gcc.py \
    --as-path "${MIPS_TOOL_PREFIX:-mips-ps2-decompals-}as" \
    --as-march r5900 --as-mabi eabi --asm-dir-prefix . \
    --macro-inc-path ps2/include/macro.inc \
    "$@" --as-flags -EL -G0 -mno-pdr -non_shared -Ips2/include < /dev/null
sh scripts/build/fixup_sections.sh "$obj"
python3 scripts/build/postprocess_object.py "$obj"
printf '%s: %s\n' "$(pwd)/$obj" "$(pwd)/$src" > "$dep"
