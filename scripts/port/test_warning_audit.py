"""Check that the warning audit overrides target suppressions for port units."""

import io
import json
import shutil
import tempfile
import unittest
from pathlib import Path
from unittest import mock

from scripts.port import warning_audit


class WarningAuditTests(unittest.TestCase):
    def test_owned_dependency_prefixes_add_real_units_and_reject_missing_or_external_paths(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            build = root / "build"
            build.mkdir()
            sources = [root / "port/src/unit.cpp", root / "tools/allocator.cpp", root / "vendor/library.cpp"]
            entries = []
            for source in sources:
                source.parent.mkdir(parents=True, exist_ok=True)
                source.write_text("void unit() {}\n")
                entries.append({"directory": str(root), "file": str(source), "arguments": ["clang++"]})
            (build / "compile_commands.json").write_text(json.dumps(entries))
            self.assertEqual(warning_audit.commands(build, root), entries[:1])
            self.assertEqual(warning_audit.commands(build, root, (Path("tools/allocator.cpp"),)), entries[:2])
            with self.assertRaisesRegex(ValueError, "does not exist"):
                warning_audit.commands(build, root, (Path("tools/missing.cpp"),))
            with self.assertRaisesRegex(ValueError, "outside the project"):
                warning_audit.commands(build, root, (root.parent,))

    def test_main_rejects_warnings_even_when_the_compiler_succeeds(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            build = root / "build"
            build.mkdir()
            source = root / "port/src/unit.cpp"
            source.parent.mkdir(parents=True)
            source.write_text("void unit() {}\n")
            entry = {"directory": str(root), "file": str(source)}
            cases = [
                (0, "", 0, 0),
                (0, f"{source}:1:1: warning: unsafe access [-Wunsafe-buffer-usage]\n", 1, 1),
                (0, "clang++: warning: unused argument [-Wunused-command-line-argument]\n", 1, 1),
                (1, "", 1, 0),
            ]
            for compiler_status, output, expected_status, count in cases:
                with self.subTest(compiler_status=compiler_status, output=output):
                    arguments = ["warning_audit.py", "--build", str(build), "--root", str(root),
                                 "--out", str(root / "warnings.tsv"), "--jobs", "1"]
                    with mock.patch("sys.argv", arguments), \
                         mock.patch.object(warning_audit, "commands", return_value=[entry]), \
                         mock.patch.object(warning_audit, "run_one", return_value=(entry, compiler_status, output)), \
                         mock.patch("sys.stdout", new_callable=io.StringIO) as report:
                        self.assertEqual(warning_audit.main(), expected_status)
                        self.assertEqual(json.loads(report.getvalue())["diagnostics"], count)

    def test_relative_translation_units_use_the_compile_directory(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            build = root / "build"
            build.mkdir()
            source = root / "port/src/unit.cpp"
            source.parent.mkdir(parents=True)
            source.write_text("int value;\n")
            entry = {"directory": str(build), "file": "../port/src/unit.cpp", "arguments": ["clang++"]}
            (build / "compile_commands.json").write_text(json.dumps([entry]))
            self.assertEqual(warning_audit.commands(build, root), [entry])
            self.assertEqual(warning_audit.source_path(entry), source.resolve())
            report = warning_audit.summary([], [entry], [])
            self.assertEqual(report["translation_units"], [str(source.resolve())])

    def test_relative_headers_and_driver_diagnostics_remain_visible(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory).resolve()
            entry = {"directory": str(root / "build"), "file": "../port/src/unit.cpp"}
            output = "\n".join([
                "../port/include/unit.hpp:12:3: warning: unused field [-Wunused-private-field]",
                "clang++: warning: argument unused during compilation: '-example' [-Wunused-command-line-argument]",
                "clang++: error: no input files",
                "fatal error: unavailable compiler resource",
                "1 warning generated.",
            ])
            rows = warning_audit.diagnostics(entry, output, root)
            self.assertEqual(len(rows), 4)
            self.assertEqual(rows[0][1], str(Path("port/include/unit.hpp")))
            self.assertEqual(rows[0][5], "-Wunused-private-field")
            self.assertEqual(rows[1][4:6], ("warning", "-Wunused-command-line-argument"))
            self.assertEqual(rows[2][4:], ("error", "", "no input files"))
            self.assertEqual(rows[3][4:], ("fatal error", "", "unavailable compiler resource"))
            self.assertEqual(warning_audit.summary(rows, [entry], [])["unique_port_diagnostics"], 1)

    def test_empty_and_duplicate_owned_database_fail_closed(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            build = root / "build"
            build.mkdir()
            database = build / "compile_commands.json"
            database.write_text("[]")
            with self.assertRaises(RuntimeError):
                warning_audit.commands(build, root)
            entry = {"directory": str(build), "file": "../port/src/unit.cpp"}
            database.write_text(json.dumps([entry, entry]))
            with self.assertRaises(RuntimeError):
                warning_audit.commands(build, root)

    def test_project_documentation_commands_are_registered_without_disabling_warnings(self):
        compiler = shutil.which("clang++-23") or shutil.which("clang++")
        self.assertIsNotNone(compiler)
        with tempfile.TemporaryDirectory() as directory:
            source = Path(directory) / "documented.cpp"
            source.write_text(chr(10).join([
                "/**", " * Describes a native declaration.", " * @mangled Documented__Fv",
                " * @address 0x100000", " * @size 0x10", " * @unknownret Unspecified retail result.",
                " */", "void Documented();", ""]))
            entry = {"directory": directory, "file": str(source),
                     "arguments": [compiler, "-std=c++26", "-fcomment-block-commands=mangled,address,size,unknownret",
                                   "-c", str(source), "-o", str(Path(directory) / "documented.o")]}
            _, status, output = warning_audit.run_one(entry)
            self.assertEqual(status, 0)
            self.assertNotIn("[-Wdocumentation", output)

    def test_port_policy_has_no_disabled_diagnostics(self):
        policy = Path(__file__).resolve().parents[2] / "port/CMakeLists.txt"
        text = policy.read_text()
        self.assertIn("-Weverything", text)
        self.assertNotRegex(text, r"target_compile_options\([^)]* -Wno-")

    def test_owned_code_has_no_diagnostic_suppression_pragmas(self):
        root = Path(__file__).resolve().parents[2] / "port"
        for directory in (root / "src", root / "include"):
            for path in directory.rglob("*"):
                if not path.is_file() or path.suffix not in {".cpp", ".hpp", ".h", ".inc", ".inl", ".ipp", ".tpp"}:
                    continue
                with self.subTest(path=path.relative_to(root)):
                    self.assertNotRegex(path.read_text(), r"#\s*pragma\s+(?:clang|GCC)\s+diagnostic\s+ignored")
                    self.assertNotRegex(path.read_text(), r"#\s*pragma\s+warning\s*\(\s*disable")

    def test_summary_deduplicates_owned_headers_without_hiding_external_counts(self):
        diagnostic = ("port/include/example.hpp", "1", "2", "warning", "-Wshadow", "shadowed")
        rows = [("port/src/a.cpp", *diagnostic), ("port/src/b.cpp", *diagnostic),
                ("port/src/a.cpp", "/external/example.hpp", "3", "4", "warning", "-Wshadow", "external")]
        report = warning_audit.summary(rows, [{}, {}], [])
        self.assertEqual(report["diagnostics"], 3)
        self.assertEqual(report["unique_port_diagnostics"], 1)
        self.assertEqual(report["by_option"], [("-Wshadow", 3)])
        self.assertEqual(report["unique_port_by_option"], [("-Wshadow", 1)])

    def test_all_warnings_follow_target_suppressions(self):
        compiler = shutil.which("clang++-23") or shutil.which("clang++")
        self.assertIsNotNone(compiler)
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            source = root / "port/src/unused.cpp"
            source.parent.mkdir(parents=True)
            source.write_text("void f() { int unused = 0; }\n")
            build = root / "build"
            build.mkdir()
            entry = {"directory": str(root), "file": str(source),
                     "arguments": [compiler, "-std=c++26", "-w", "-Wno-unused-variable", "-c", str(source),
                                   "-o", str(build / "unused.o")]}
            (build / "compile_commands.json").write_text(json.dumps([entry]))
            self.assertEqual(len(warning_audit.commands(build, root)), 1)
            self.assertEqual(warning_audit.diagnostic_command(entry)[-3], "-Weverything")
            _, status, output = warning_audit.run_one(entry)
            self.assertEqual(status, 0)
            self.assertIn("[-Wunused-variable]", output)


if __name__ == "__main__":
    unittest.main()
