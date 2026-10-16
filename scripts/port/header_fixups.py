#!/usr/bin/env python3
"""Mirror ps2/include into the build with the header fixups the port compiles against, and fix unit copies.

    header_fixups.py <src_dir> <dst_dir> <stamp_file>
    header_fixups.py --unit <copy_path>

Every fixup's old text must occur exactly once in its file; anything else fails before a byte is written.
Headers are then passed through long64, because the PS2's `long` is 64-bit and Windows' is not.
"""

import argparse
import re
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from long64 import rewrite as rewrite_long64  # noqa: E402

LONG64_SUFFIXES = (".h", ".hpp", ".hh", ".inc", ".inl")

# MWCC accepts a `void` override of a base's `int` virtual and gives it a new vtable slot; clang rejects it.
# The PS2 vtables keep those separate slots, so making them overrides here is an accepted difference until
# rendering replaces these draws.
# COFF has no COMDAT-vs-strong resolution, so one out-of-line definition collides with every inline copy.
# ClsMes::Init is out-of-line only in dngmenu.cpp; making it inline everywhere leaves one definition.
# mgVu0FBOX is not trivially copyable, so memset on it trips -Wnontrivial-memcall.
FIXUPS = [
    # Paint colours close the menu into paint mode on the first visit as well as returned visits.
    ("editmenu.hpp", "        paint_top = 0;", "        paint_top = 0; paint_return = 1;"),
    ("dng_event.hpp", "    virtual void Draw();", "    virtual int Draw();"),
    ("dng_hud.hpp", "    virtual void Draw();", "    virtual int Draw();"),
    # The quick loadout's "Equip Slot" command wraps the item command list; retail's routine stays under this name.
    ("menusys.hpp", "    int MenuItemCommandSelect(int select_key, int push_button);",
     "    int MenuItemCommandSelect(int select_key, int push_button);\n"
     "    int PortRetailMenuItemCommandSelect(int select_key, int push_button);"),
    ("nd_meswin.hpp", "#ifndef MES_WINDOW_OUT_OF_LINE_INIT", "#if 1"),
    ("collision.hpp", "memset(&bbox, 0, sizeof(bbox));", "memset(static_cast<void *>(&bbox), 0, sizeof(bbox));"),
    # kernel32 exports these three names on Windows; the PS2 kernel's versions take their own link names so they never bind to kernel32.
    ("sce/eekernel.h", "int CreateThread(struct ThreadParam *param);", "int CreateThread(struct ThreadParam *param) __asm__(\"Ps2CreateThread\");"),
    ("sce/eekernel.h", "int TerminateThread(int thread_id);", "int TerminateThread(int thread_id) __asm__(\"Ps2TerminateThread\");"),
    ("sce/eekernel.h", "int GetThreadId(void);", "int GetThreadId(void) __asm__(\"Ps2GetThreadId\");"),
    # InventData's mgVu0FBOX makes the union's copy assignment deleted; MWCC generated the memberwise copy
    # GetLight and GetCharaLight assign with, so the mirror spells it out on the declaration's line.
    ("mapload.hpp", "    CFuncPoint() {}", '    CFuncPoint() {} CFuncPoint &operator=(CFuncPoint &other) { name = other.name; type = other.type; unk_8 = other.unk_8; flag_no = other.flag_no; enable = other.enable; start = other.start; end = other.end; __builtin_memcpy(static_cast<void *>(data), other.data, reinterpret_cast<char *>(&frame) - reinterpret_cast<char *>(data)); frame = other.frame; __builtin_memcpy(position, other.position, sizeof(position)); __builtin_memcpy(rotation, other.rotation, sizeof(rotation)); __builtin_memcpy(scale, other.scale, sizeof(scale)); active = other.active; return *this; }'),
]

# The leading newline anchors each match to its line start: a copy already rewritten fails the exactly-once check
# instead of gaining a second `inline`.
# COFF has no inline-vs-strong resolution: map.cpp's out-of-line CMapParts::CMapParts is the single definition,
# so the identical inline copies in editeff.cpp/editmap.cpp are blanked rather than kept.
UNIT_FIXUPS = [
    # The native texture-copy prelude includes host stdlib.h, which declares random().
    ("password.cpp", "static unsigned int random() {", "static unsigned int PortPasswordRandom() {"),
    # Replace party-ring palette copies with independently registered RGBA pixels.
    ("menuchr.cpp", """    MenuCharaChangeCLUT = palette.clut;
    tex_manager->ReloadTexture(block, (sceVif1Packet *) NULL);

    if (MenuCharaChangeCLUT_Tex == NULL) {
        MenuCharaChangeCLUT_Tex = new (MenuChangeMemory.Alloc(9)) mgCTexture;
    }

    memcpy(MenuCharaChangeCLUT_Tex, MenuCharaChangeBase_Tex, sizeof(mgCTexture));
    memcpy(MenuCharaChangeCLUT, MenuCharaChangeBase_Tex->clut, sizeof(palette.clut));
    MenuCharaChangeCLUT_Tex->clut = (u_long128 *) MenuCharaChangeCLUT;

    // Darken the copied palette into brightness bands, keeping each colour's alpha.
    for (palette_index = 0, color = MenuCharaChangeCLUT; palette_index < CHR_CNG_CLUT_NUM; palette_index++, color++) {
        float luminance = (float) ((color->r + color->g + color->b) / 3);
        int   step = 1;

        do {
            if (8.0f * (float) (step - 1) <= luminance && luminance < 8.0f * (float) step) {
                break;
            }

            step++;
        } while (step < CHR_CNG_CLUT_BAND_NUM + 1);

        color->r = (u8) (7.75f * (float) step);
        color->g = (u8) (5.625f * (float) step);
        color->b = (u8) (4.6875f * (float) step);
    }
""", """    MenuCharaChangeCLUT_Tex = MgTextureCreateColorVariant(MenuCharaChangeBase_Tex,
        const_cast<char *>("party_locked"), MgTextureColorMode::PartyLocked);
    MgTextureSetDrawVariant(MenuCharaChangeBase_Tex, nullptr);
    tex_manager->ReloadTexture(block, (sceVif1Packet *) NULL);
"""),
    # Emit the constructor from the native unit without changing its retail inline spelling.
    ("inventmn.cpp", "\ninline CMenuInvent::CMenuInvent() {", "\nCMenuInvent::CMenuInvent() {"),
    ("editeff.cpp", "\ninline CMapParts::CMapParts() { Initialize(); }", "\n"),
    ("editmap.cpp", "\ninline CMapParts::CMapParts() { Initialize(); }", "\n"),
    # Fusion colours can target a float-aligned ambient field rather than a quadword boundary.
    ("menusys.cpp", "*(u_long128 *) color = *(u_long128 *) fusion_ambient;",
     "memcpy(color, fusion_ambient, sizeof(fusion_ambient));"),
    ("dng_debug.cpp", "\nvoid CTreasureBox::Initialize() {", "\ninline void CTreasureBox::Initialize() {"),
    # The dungeon menu carves its memory from these 200000 quadwords and gives the invention menu's
    # model reads (LOAD STACK) whatever is left. Host objects are larger than retail's, so with Max's
    # largest outfit (the Explorer's set) the reads overran it. Give the menu 60000 more quadwords.
    ("dng_main.cpp", "BuffReadData = MainBuffer->stAlloc64(200000);",
     "BuffReadData = MainBuffer->stAlloc64(260000);"),
    ("dng_main.cpp", "\n                stack.stSetBuffer(BuffReadData, 200000);",
     "\n                stack.stSetBuffer(BuffReadData, 260000);"),
    # The town menu's buffer, carved from the end of the main stack after the total data buffer, needs
    # the same 60000 quadwords for the invention menu's model reads.
    ("editloop.cpp", """    TotalDataBuff.stSetBuffer(&main_stack->stack[main_stack->stack_used], data_size - 210128);
    printf("data memory size = %d kbyte", (data_size - 210128) * 16 / 1024);""",
     """    TotalDataBuff.stSetBuffer(&main_stack->stack[main_stack->stack_used], data_size - 270128);
    printf("data memory size = %d kbyte", (data_size - 270128) * 16 / 1024);"""),
    # Geostone announcement updates and draws reserve eight nullable message slots.
    ("editmenu.cpp", "static CDC2Mes *DownLoadMes[6];", "static CDC2Mes *DownLoadMes[8];"),
    ("editloop.cpp", """    main_stack->Alloc(data_size - 210128);
    MenuBuffer__2.stSetBuffer(read_buffer = main_stack->stAlloc64(200000), 200000);
    read_buffer_end = read_buffer + 200000;""",
     """    main_stack->Alloc(data_size - 270128);
    MenuBuffer__2.stSetBuffer(read_buffer = main_stack->stAlloc64(260000), 260000);
    read_buffer_end = read_buffer + 260000;"""),
]

# MWCC-only pragmas. ct_port builds with -Wall and no -Wno-unknown-pragmas, so they are blanked, not silenced.
MWCC_PRAGMA = re.compile(r"[ \t]*#[ \t]*pragma[ \t]+(?:cpp_extensions\b.*|push|pop)[ \t]*")


def neutralise_mwcc_pragmas(text: str) -> str:
    lines = text.split("\n")
    for i, line in enumerate(lines):
        body = line.rstrip("\r")
        if MWCC_PRAGMA.fullmatch(body):
            lines[i] = line[len(body):]
    return "\n".join(lines)


def build_mirror(src: Path) -> dict[str, bytes]:
    files = {}
    for path in sorted(p for p in src.rglob("*") if p.is_file()):
        files[path.relative_to(src).as_posix()] = path.read_bytes()

    for rel, old, new in FIXUPS:
        if rel not in files:
            sys.exit(f"header_fixups: {rel} is not under {src}; its fixup has no target")
        data = files[rel]
        count = data.count(old.encode())
        if count != 1:
            sys.exit(f"header_fixups: {rel} has {count} occurrences of {old!r}, expected exactly 1")
        files[rel] = data.replace(old.encode(), new.encode())

    for rel, data in files.items():
        if rel.endswith(LONG64_SUFFIXES):
            text = neutralise_mwcc_pragmas(data.decode("latin-1"))
            rewritten = rewrite_long64(text).encode("latin-1")
            if rewritten.count(b"\n") != data.count(b"\n"):
                sys.exit(f"header_fixups: {rel} changed its line count")
            files[rel] = rewritten
    return files


def write_mirror(dst: Path, files: dict[str, bytes]) -> None:
    dst.mkdir(parents=True, exist_ok=True)
    for rel, data in files.items():
        out = dst / rel
        if out.is_file() and out.read_bytes() == data:
            continue
        out.parent.mkdir(parents=True, exist_ok=True)
        out.write_bytes(data)

    for path in sorted((p for p in dst.rglob("*") if p.is_file()), reverse=True):
        if path.relative_to(dst).as_posix() not in files:
            path.unlink()
    for path in sorted((p for p in dst.rglob("*") if p.is_dir()), reverse=True):
        if not any(path.iterdir()):
            path.rmdir()


def fixup_unit_text(name: str, text: str) -> str:
    for unit, old, new in UNIT_FIXUPS:
        if unit != name:
            continue
        count = text.count(old)
        if count != 1:
            sys.exit(f"header_fixups: {name} has {count} occurrences of {old!r}, expected exactly 1")
        # Keep diagnostics and debug locations aligned with the retail source.
        replacement = new + "\n" * max(0, old.count("\n") - new.count("\n"))
        text = text.replace(old, replacement)
    if name == "password.cpp":
        text = text.replace("random()", "PortPasswordRandom()")
    return text


def fixup_unit(copy: Path) -> None:
    if not copy.is_file():
        sys.exit(f"header_fixups: {copy} is not a file")

    data = copy.read_bytes()
    fixed = fixup_unit_text(copy.name, data.decode("latin-1")).encode("latin-1")
    if fixed != data:
        copy.write_bytes(fixed)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--unit", type=Path, metavar="COPY")
    parser.add_argument("src_dir", nargs="?", type=Path)
    parser.add_argument("dst_dir", nargs="?", type=Path)
    parser.add_argument("stamp_file", nargs="?", type=Path)
    args = parser.parse_args()

    if args.unit is not None:
        if any(arg is not None for arg in (args.src_dir, args.dst_dir, args.stamp_file)):
            parser.error("--unit takes no other arguments")
        fixup_unit(args.unit)
        return

    if any(arg is None for arg in (args.src_dir, args.dst_dir, args.stamp_file)):
        parser.error("expected <src_dir> <dst_dir> <stamp_file>, or --unit <copy_path>")
    if not args.src_dir.is_dir():
        sys.exit(f"header_fixups: {args.src_dir} is not a directory")

    write_mirror(args.dst_dir, build_mirror(args.src_dir))
    args.stamp_file.parent.mkdir(parents=True, exist_ok=True)
    args.stamp_file.touch()


if __name__ == "__main__":
    main()
