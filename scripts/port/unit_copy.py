#!/usr/bin/env python3
"""Write one ps2/src unit's native build copy: strip overridden definitions, append
preserved retail bridges, then apply unit fixups and long64 in a single process.

RETAIL_BRIDGES preserves selected overridden retail routines under new definition
names in the generated build copy. Their bodies come from unstripped ps2/src;
existing calls keep the public name and reach the native PORT_OVERRIDE seam.
Use a bridge when a native seam must add behavior around the preserved routine
rather than replace its implementation. Register its unit, signature, original
name and bridge name in RETAIL_BRIDGES, declare the bridge's asm link name in the
unit's stub header and native caller, and delegate from the native override.
The appended body receives the same unit fixups and long64 rewrites, with a #line
marker at its retail definition for diagnostics and debugging. ps2/ is unchanged.

    unit_copy.py --port-override <port_override.py> --overrides <file> [--stubs <hpp>]
                 [--define=NAME ...] [--long-is-64] SRC OUT

The output is written only when its bytes change, so an unchanged copy keeps its timestamp.
"""

import argparse
import importlib.util
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

import header_fixups  # noqa: E402
import long64  # noqa: E402
import native_asset_paths  # noqa: E402


def load_port_override(path: Path):
    spec = importlib.util.spec_from_file_location("port_override", path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


# Preserve these retail routines under native link-name bridges. Only their names
# change; all calls in the original unit still reach the native public seam.
RETAIL_BRIDGES = {
    "editctrl.cpp": [("ResetViewMode(CScene*)", "ResetViewMode", "PortRetailResetViewMode")],
    "editmap.cpp": [("CEditMap::ClearAllParts()", "ClearAllParts", "PortRetailClearAllParts")],
    "editloop.cpp": [
        ("UpdateTrBoxFlag(int)", "UpdateTrBoxFlag", "PortRetailUpdateTrBoxFlag"),
        ("EditDraw()", "EditDraw", "PortRetailEditDraw"),
    ],
    "dng_main.cpp": [
        ("ResetEyeView(CActionChara*)", "ResetEyeView", "PortRetailResetEyeView"),
        ("ChangeSetUnit(int)", "ChangeSetUnit", "PortRetailChangeSetUnit"),
        ("DngMainKey()", "DngMainKey", "PortRetailDngMainKey"),
    ],
    "menumain.cpp": [
        ("MenuMainInit(MENU_INIT_ARG*)", "MenuMainInit", "PortRetailMenuMainInit"),
        ("MenuMainExit()", "MenuMainExit", "PortRetailMenuMainExit"),
        ("MenuWorldTrans()", "MenuWorldTrans", "PortRetailMenuWorldTrans"),
    ],
    "menudraw.cpp": [
        ("DrawMenuFillBox(int,int,int,int)", "DrawMenuFillBox", "PortRetailDrawMenuFillBox"),
        ("MenuMainFrameModeSet(int,int)", "MenuMainFrameModeSet", "PortRetailMenuMainFrameModeSet"),
        ("MenuMainFrameStep()", "MenuMainFrameStep", "PortRetailMenuMainFrameStep"),
        ("MenuMainFrameImgDraw(int&)", "MenuMainFrameImgDraw", "PortRetailMenuMainFrameImgDraw"),
        ("CMenuPosDataManage::StepMainMenuIconMove(int*,int,int)", "StepMainMenuIconMove", "PortRetailStepMainMenuIconMove"),
    ],
    "menucls1.cpp": [("CDC2Mes::DrawMsg()", "DrawMsg", "PortRetailDrawMsg")],
    "actionchara.cpp": [("CActionChara::DrawEffect()", "DrawEffect", "PortRetailDrawEffect")],
    "effscript.cpp": [
        ("CEffectScriptMan::Initialize(mgCMemory*,int,int)", "Initialize", "PortRetailInitialize"),
        ("CEffectScriptMan::DeleteEffSpt(_EFF_SCRIPT*)", "DeleteEffSpt", "PortRetailDeleteEffSpt"),
        ("_SPT_ASSIGN_SPRITE(RS_STACKDATA*,int)", "_SPT_ASSIGN_SPRITE", "PortRetailSptAssignSprite"),
        ("_SPT_INIT_SPRITE(RS_STACKDATA*,int)", "_SPT_INIT_SPRITE", "PortRetailSptInitSprite"),
    ],
    "dng_effect.cpp": [
        ("CSwordLuminous::Draw()", "Draw", "PortRetailDraw"),
        ("CAfterWire::DrawWire(float(*)[4])", "DrawWire", "PortRetailDrawWire"),
    ],
    "charasetup.cpp": [("GetRoboPartsInfo(CUserDataManager*)", "GetRoboPartsInfo", "PortRetailGetRoboPartsInfo")],
    "menusys.cpp": [
        ("CBaseMenuClass::MenuItemCommandSelect(int,int)", "MenuItemCommandSelect", "PortRetailMenuItemCommandSelect"),
        ("MenuItemSelectInit(mgCMemory*,int*,int)", "MenuItemSelectInit", "PortRetailMenuItemSelectInit"),
        ("MenuItemSelectDraw()", "MenuItemSelectDraw", "PortRetailMenuItemSelectDraw"),
        ("MenuItemDraw()", "MenuItemDraw", "PortRetailMenuItemDraw"),
        ("MenuItemInit(mgCMemory*,int*,int)", "MenuItemInit", "PortRetailMenuItemInit"),
    ],
    "dngmenu.cpp": [
        ("CMenuTreeMap::Step()", "Step", "PortRetailStep"),
        ("CMenuTreeMap::Draw()", "Draw", "PortRetailDraw"),
    ],
    "title.cpp": [("TitleCopyRightStep()", "TitleCopyRightStep", "PortRetailTitleCopyRightStep")],
    "menuchr.cpp": [
        ("InitMainCharaBG(int,mgCMemory*,int)", "InitMainCharaBG", "PortRetailInitMainCharaBG"),
        ("KeyMainCharaBG()", "KeyMainCharaBG", "PortRetailKeyMainCharaBG"),
    ],
    "mg_dataset.cpp": [
        ("CopyFrame(mgCFrame*,mgCFrame*,mgCMemory*,int,mgCFrame**)", "CopyFrame", "PortRetailCopyFrame"),
    ],
    "runscript.cpp": [
        ("CRunScript::DeleteProgram()", "DeleteProgram", "PortRetailDeleteProgram"),
        ("CRunScript::load(RS_PROG_HEADER*,RS_STACKDATA*,int,RS_CALLDATA*,int)", "load", "PortRetailLoad"),
        ("CRunScript::resume()", "resume", "PortRetailResume"),
        ("CRunScript::run(int)", "run", "PortRetailRun"),
        ("CRunScript::skip()", "skip", "PortRetailSkip"),
    ],
}


def retail_bridges(port_override, source: Path, long_is_64: bool) -> str:
    entries = RETAIL_BRIDGES.get(source.name, [])
    if not entries:
        return ""
    original = port_override.read(source)
    bodies = []
    for signature, name, bridge in entries:
        matches = list(port_override.definitions(original, {signature}, long_is_64=long_is_64))
        if len(matches) != 1:
            raise port_override.Error(f"{source}: expected one retail bridge body for {signature}")
        start, definition = matches[0]
        body = original[start:start + definition.length]
        line = original.count("\n", 0, start) + 1
        marker = f'#line {line} "{source.resolve().as_posix()}"\n'
        bodies.append(marker + body.replace(name + "(", bridge + "(", 1))
    return "\n".join(bodies)


# Retail loaders that read a configuration script in the middle of other work keep that work; only
# their interpreter run is replaced with the call that applies the native document. Each entry names
# the loader's definition line and the call; the stub header of the unit declares the callee.
CONFIG_SEAMS = {
    "editmap.cpp": [("void CEditMap::LoadEditInfo(char *script, int size, mgCMemory *stack) {",
                     "PortApplyEditMapConfig(this, script, size, stack);")],
    "mapsky.cpp": [("static void LoadSkyPack(MAP_SKY_INFO *info, char *script, int size) {",
                    "PortLoadSkyInfo(info, script, size);")],
    # Character cloth scripts embedded in .game.json resources are typed command lists, not text.
    "dynamicanime.cpp": [("void CDynamicAnime::Load(char *name, int size, mgCFrame *frame, mgCMemory *memory) {",
                          "PortRunDynamicAnimeScript(dynmc_tag, name, size);", "CScriptInterpreter interp;",
                          "interp.Run();")],
}
INTERPRETER_START = "CScriptInterpreter interpreter;"
INTERPRETER_END = "interpreter.Run();"


def config_seams(text: str, unit: str) -> str:
    """Replace each listed loader's interpreter run with its native call, keeping every line number."""
    for definition, call, *markers in CONFIG_SEAMS.get(unit, []):
        first, last = markers if markers else (INTERPRETER_START, INTERPRETER_END)
        anchor = text.index(definition)
        start = text.index(first, anchor)
        end = text.index(last, start) + len(last)
        lines = text.count("\n", start, end)
        text = text[:start] + call + "\n" * lines + text[end:]
    return text


def native_bridge(unit: str):
    """The port/src file appended to a unit's copy: character.cpp's metadata bridge, or
    port/src/<unit>_config_bridge.inc, whose code reaches the unit's file statics and types."""
    source = Path(__file__).resolve().parents[2] / "port/src"
    if unit == "character.cpp":
        return source / "character_metadata_bridge.inc"
    bridge = source / (Path(unit).stem + "_config_bridge.inc")
    return bridge if bridge.is_file() else None


def prepare_menu_character_arena(text: str) -> str:
    """Size reset costume slots before the preserved character construction block."""
    start = text.index("static void MenuItemCharaDataLoadPack(")
    check = "    if ((chara != NULL && part != 1) || part == 1) {\n"
    position = text.index(check, start) + len(check)
    text = text[:position] + "        PortPrepareMenuCharacterArena(*stack, pack, menu_infocfgname, part);\n" + text[position:]
    bridge_header = Path(__file__).resolve().parents[2] / "port/src/menu_character_assets.hpp"
    return f'#include "{bridge_header.as_posix()}"\n' + text


def resolve_main_character_item_read(text: str) -> str:
    """Select the queued item texture by path instead of its variable background slot."""
    original = "GetReadBGFile(1)->buffer"
    if text.count("int ReadMainCharaBG() {") != 1 or text.count(original) != 1:
        raise ValueError("expected one item texture background read in ReadMainCharaBG")
    return text.replace(original, "PortMainCharaItemReadBuffer()")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--port-override", required=True, type=Path)
    parser.add_argument("--overrides", required=True, type=Path)
    parser.add_argument("--stubs", type=Path)
    parser.add_argument("--define", action="append", default=[])
    parser.add_argument("--long-is-64", action="store_true")
    parser.add_argument("source", type=Path)
    parser.add_argument("output", type=Path)
    args = parser.parse_args()

    port_override = load_port_override(args.port_override)
    overrides = port_override.override_entries(port_override.read(args.overrides))
    try:
        text = port_override.strip_unit(args.source, overrides, port_override.renames(args.stubs), args.define,
                                        args.long_is_64, private_functions=args.source.name in {"event_func.cpp", "editdebug.cpp"})
    except port_override.Error as error:
        sys.exit(str(error))

    text += "\n" + retail_bridges(port_override, args.source, args.long_is_64)
    text = config_seams(text, args.source.name)
    if args.source.name == "menuchr.cpp":
        text = prepare_menu_character_arena(text)
        text = resolve_main_character_item_read(text)
    if args.source.name == "dng_main.cpp":
        start = text.index("    char pack_path[64];", text.index("void InitDungeonMain("))
        end = text.index("    ActionScriptEnv.item_chara = ItemBaseData;", start)
        text = text[:start] + """    if (!PortLoadDungeonArticleModels()) {
        std::exit(1);
        return;
    }

""" + text[end:]
        bridge_header = Path(__file__).resolve().parents[2] / "port/src/dungeon_articles.hpp"
        text = f'#include "{bridge_header.as_posix()}"\n' + text
    bridge = native_bridge(args.source.name)
    if bridge is not None:
        text +=f'\n#include "{bridge.as_posix()}"\n'
    fixed = header_fixups.fixup_unit_text(args.output.name, text.encode("utf-8", errors="surrogateescape")
                                          .decode("latin-1"))
    final = native_asset_paths.rewrite(long64.rewrite(fixed), args.source.name).encode("latin-1")
    if args.output.is_file() and args.output.read_bytes() == final:
        return
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_bytes(final)


if __name__ == "__main__":
    main()
