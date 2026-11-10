#!/usr/bin/env python3
"""Expose the native item command target declaration to its layout regression."""
import pathlib
import sys

root = pathlib.Path(sys.argv[1])
output = pathlib.Path(sys.argv[2])
menus = (root / "port/src/object/menu/menusys.cpp").read_text()
menu = menus.split("int CBaseMenuClass::MenuItemCommandSelectCore(", 1)[1]
target = next((line.strip() for line in menu.splitlines()
               if line.strip().startswith("CItemUseTarget ") and line.strip().endswith("target{};")), None)
if target is None:
    raise SystemExit("The item command target must retain its declared native object type")
output.write_text(chr(10).join([
    '#pragma once', '#include "gamedata.hpp"', 'namespace LocalLayoutProbe {',
    "inline auto TargetSize() { " + target + " return sizeof(target); }", "}", ""]))
