"""Tests for tools/crash/symbolize.py."""

import os
import shutil
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

import symbolize  # noqa: E402

PROBE_SOURCE = """\
int ct_symbolize_probe(int x) { return x * 3; }

int main(void) { return ct_symbolize_probe(2) == 6 ? 0 : 1; }
"""


def _sibling(tool: str | None, name: str) -> str | None:
    """Return the path of a tool that sits next to another tool, if it exists."""
    if tool is None:
        return None
    path = Path(tool).with_name(name + Path(tool).suffix)
    return str(path) if path.is_file() else None


def _find_clang() -> str | None:
    """Return a C compiler from PATH or the bundled llvm-mingw toolchain."""
    if found := shutil.which("clang"):
        return found
    exe = "clang.exe" if os.name == "nt" else "clang"
    for directory in symbolize.mingw_llvm_bin_dirs():
        if (directory / exe).is_file():
            return str(directory / exe)
    return None


SYMBOLIZER = symbolize.locate_tool("llvm-symbolizer", None, "LLVM_SYMBOLIZER")
READOBJ = _sibling(SYMBOLIZER, "llvm-readobj")
NM = _sibling(SYMBOLIZER, "llvm-nm")
CLANG = _find_clang()
TOOLS_AVAILABLE = all((SYMBOLIZER, READOBJ, NM, CLANG))


class ParseReportTest(unittest.TestCase):
    """Frame and build id extraction from report text."""

    def test_finds_frames_and_ignores_register_lines(self) -> None:
        text = (
            "#00 darkchronicle.exe+0x1a2b\n"
            "  7  C:\\Games\\dc2\\darkchronicle.exe+0x10 (raw)\n"
            "#1 libc.so.6+0x29d90\n"
            "register rip=0x1234\n"
        )
        _, frames = symbolize.parse_report(text)
        self.assertEqual(
            frames,
            [
                symbolize.Frame(0, "darkchronicle.exe", 0x1A2B),
                symbolize.Frame(1, "C:\\Games\\dc2\\darkchronicle.exe", 0x10),
                symbolize.Frame(2, "libc.so.6", 0x29D90),
            ],
        )

    def test_finds_build_id_in_either_spelling(self) -> None:
        self.assertEqual(symbolize.parse_report("Build ID: 5f3e9a\n")[0], "5f3e9a")
        self.assertEqual(symbolize.parse_report("build-id = abcd\n")[0], "abcd")
        self.assertIsNone(symbolize.parse_report("no identifier here\n")[0])


class ParseOutputTest(unittest.TestCase):
    """Grouping of llvm-symbolizer output per address."""

    def test_handles_inlined_and_unresolved_addresses(self) -> None:
        text = (
            "inlined_helper\n/src/probe.c:2:5\n"
            "main\n/src/probe.c:9:1\n"
            "\n"
            "??\n??:0:0\n"
            "\n"
        )
        self.assertEqual(
            symbolize.parse_symbolizer_output(text),
            [
                [("inlined_helper", "/src/probe.c:2:5"), ("main", "/src/probe.c:9:1")],
                [("??", "??:0:0")],
            ],
        )


class ImageBaseParserTest(unittest.TestCase):
    """Load base parsing from llvm-readobj output."""

    def test_coff_image_base(self) -> None:
        text = "File: darkchronicle.exe\nFormat: COFF-x86-64\nImageBase: 0x140000000\n"
        self.assertEqual(symbolize.parse_coff_image_base(text), 0x140000000)

    def test_macho_text_vmaddr_skips_pagezero(self) -> None:
        text = (
            "Segment {\n  Name: __PAGEZERO\n  vmaddr: 0x0\n}\n"
            "Segment {\n  Name: __TEXT\n  vmaddr: 0x100000000\n}\n"
        )
        self.assertEqual(symbolize.parse_macho_text_vmaddr(text), 0x100000000)

    def test_elf_pie_has_zero_base(self) -> None:
        file_headers = "Format: elf64-x86-64\nType: SharedObject (0x3)\n"
        self.assertEqual(symbolize.parse_elf_load_base(file_headers, ""), 0)

    def test_elf_exec_uses_lowest_load_address(self) -> None:
        file_headers = "Format: elf64-x86-64\nType: Executable (0x2)\n"
        program_headers = (
            "ProgramHeader {\n  Type: PT_LOAD (0x1)\n  VirtualAddress: 0x400000\n}\n"
            "ProgramHeader {\n  Type: PT_LOAD (0x1)\n  VirtualAddress: 0x600000\n}\n"
        )
        self.assertEqual(symbolize.parse_elf_load_base(file_headers, program_headers), 0x400000)


class RenderReportTest(unittest.TestCase):
    """Insertion of resolved frame lines into the report."""

    def test_inserts_resolved_and_unresolved_lines(self) -> None:
        text = "Build ID: ab\n#00 probe.exe+0x10\n#01 other.dll+0x20\nend\n"
        _, frames = symbolize.parse_report(text)
        results = {0: [("ct_symbolize_probe", "probe.c:2:5")]}
        rendered, resolved = symbolize.render_report(text, frames, results)
        self.assertTrue(resolved)
        self.assertEqual(
            rendered,
            "Build ID: ab\n#00 probe.exe+0x10\n    -> ct_symbolize_probe at probe.c:2:5\n"
            "#01 other.dll+0x20\n    -> ??\nend\n",
        )


class MachOSourcesTest(unittest.TestCase):
    """dSYM bundles and Xcode's atos output."""

    def test_dsym_bundle_resolves_to_its_dwarf_file(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            bundle = Path(directory) / "darkchronicle.dSYM"
            dwarf = bundle / "Contents" / "Resources" / "DWARF" / "darkchronicle"
            dwarf.parent.mkdir(parents=True)
            dwarf.write_bytes(b"")
            self.assertEqual(symbolize.dsym_dwarf_file(bundle), dwarf)
            self.assertEqual(symbolize.dsym_dwarf_file(dwarf), dwarf)

    def test_parses_atos_lines(self) -> None:
        text = "CrashTestSegv() (in darkchronicle) (crash_test_modes.cpp:42)\n0x100003f00 (in darkchronicle)\n"
        self.assertEqual(
            symbolize.parse_atos_output(text),
            [[("CrashTestSegv()", "crash_test_modes.cpp:42")], [("??", "??:0:0")]],
        )


@unittest.skipUnless(TOOLS_AVAILABLE, "llvm-symbolizer, llvm-readobj, llvm-nm or clang not available")
class EndToEndTest(unittest.TestCase):
    """Symbolise a probe binary compiled with debug information."""

    def test_resolves_probe_function(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            tmp_path = Path(tmp)
            source = tmp_path / "probe.c"
            source.write_text(PROBE_SOURCE, encoding="utf-8")
            exe = tmp_path / ("probe.exe" if os.name == "nt" else "probe")
            compiled = subprocess.run(
                [CLANG, "-g", "-O0", "-o", str(exe), str(source)],
                capture_output=True,
                text=True,
                check=False,
            )
            self.assertEqual(compiled.returncode, 0, compiled.stderr)

            symbol_va = self._symbol_address(exe, "ct_symbolize_probe")
            offset = symbol_va - symbolize.image_base(str(exe), READOBJ)

            report = tmp_path / "report.txt"
            report.write_text(f"Build ID: 0123abcd\n#00 {exe.name}+0x{offset:x}\n", encoding="utf-8")
            output = tmp_path / "out.txt"
            status = symbolize.main([str(report), "--binary", str(exe), "-o", str(output)])

            self.assertEqual(status, 0)
            rendered = output.read_text(encoding="utf-8")
            self.assertIn("ct_symbolize_probe", rendered)
            self.assertIn("probe.c", rendered)

    def _symbol_address(self, exe: Path, name: str) -> int:
        """Return the address llvm-nm reports for a symbol in an executable."""
        listing = subprocess.run([NM, str(exe)], capture_output=True, text=True, check=False).stdout
        for line in listing.splitlines():
            parts = line.split()
            if len(parts) >= 3 and parts[-1] == name:
                return int(parts[0], 16)
        self.fail(f"symbol {name} not found in {exe}")


if __name__ == "__main__":
    unittest.main()
