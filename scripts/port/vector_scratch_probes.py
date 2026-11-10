#!/usr/bin/env python3
"""Extract actual callback scratch extents for native regression tests."""
import pathlib
import re
import sys

root, output = map(pathlib.Path, sys.argv[1:])
groups = {
    'Event': ('port/src/object/event/event_func.cpp', {
        '_EOH_GET_POS': ('pos',), '_EOH_GET_ROT': ('rot',),
        '_POST_TREASURE_BOX': ('position',), '_RANDOM_CIRCLE_GET_POS': ('pos',),
        '_MINIMAP_DOOR_ENABLE': ('pos',)}),
    'Effect': ('port/src/script/effscript.cpp', {
        '_DIST_VECTOR2': ('from', 'to'), '_SCN_GET_CHR_POS': ('pos',),
        '_SCN_GET_CHR_ROT': ('rot',), '_SCN_GET_ENTRY_OBJ_POS': ('pos',),
        '_SCN_GET_CHR_ENTOBJ_POS': ('pos',), '_GET_EOH_POS': ('pos',)}),
    'Thunder': ('port/src/object/world/editexception.cpp', {'S51Thunder': ('ratio',)})}
lines = ['#pragma once', '#include "map.hpp"', 'namespace VectorScratchProbe {']
for group, (path, callbacks) in groups.items():
    source = (root / path).read_text()
    expressions = []
    for callback, arrays in callbacks.items():
        match = re.search(r'\b' + callback + r'\([^;{}]*\)\s*\{', source)
        if match is None:
            raise SystemExit(f'Missing callback {callback}')
        begin, depth, end = match.end(), 1, match.end()
        while depth:
            depth += (source[end] == '{') - (source[end] == '}')
            end += 1
        body = source[begin:end]
        for array in arrays:
            extent = re.search(r'\bfloat\s+' + array + r'\s*\[([^\]]+)\]', body)
            if extent is None:
                raise SystemExit(f'Missing scratch {callback}:{array}')
            minimum = 'MAP_TIME_BAND_NUM' if group == 'Thunder' else '4'
            expressions.append(f'({extent[1]}) >= {minimum}')
    lines.append(f'inline constexpr bool {group} = ' + ' && '.join(expressions) + ';')
lines.append('}')
output.write_text('\n'.join(lines) + '\n')
