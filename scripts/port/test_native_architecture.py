"""Regression tests for the native runtime ownership check."""

import json
import tempfile
import unittest
from pathlib import Path

if __package__:
    from . import gpu_test_labels, native_architecture
else:
    import gpu_test_labels
    import native_architecture


class NativeArchitectureTests(unittest.TestCase):
    def setUp(self):
        self.directory = tempfile.TemporaryDirectory()
        self.addCleanup(self.directory.cleanup)
        self.root = Path(self.directory.name)
        (self.root / "port/src").mkdir(parents=True)
        (self.root / "port/include").mkdir(parents=True)
        (self.root / "port/CMakeLists.txt").write_text("add_library(ct_native native.cpp)\n")

    def write(self, name: str, content: str) -> Path:
        path = self.root / name
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(content)
        return path

    def test_gpu_labels_preserve_numeric_separators_across_nested_blocks(self):
        """Keep device ownership visible when timestamp literals contain digit separators."""
        source = self.write("port/src/tests/feedback_test.cpp", """
TEST(Feedback, NumericSeparators) {
    const auto check = [] {
        const auto pause = 1'000'002'000;
        const auto query = 1'000'002'100;
        return 1'000'003'000;
    };
    RendererInit();
    const auto presented = 1'000'002'500;
    const auto after = 1'000'003'001;
}
TEST(Feedback, FollowingCase) { RendererInit(); }
""")
        self.assertEqual(list(gpu_test_labels.device_tests(source)),
                         ["Feedback.NumericSeparators", "Feedback.FollowingCase"])

    def test_gpu_labels_ignore_prefixed_character_braces(self):
        """Exclude character-literal braces without hiding actual renderer creation."""
        for prefix in ("", "u8", "u", "U", "L"):
            with self.subTest(prefix=prefix):
                source = self.write("port/src/tests/character_test.cpp",
                                    "TEST(Character, Brace) { const auto brace = "
                                    + prefix + "'{'; RendererInit(); }\n")
                self.assertEqual(list(gpu_test_labels.device_tests(source)), ["Character.Brace"])

    def test_gpu_labels_preserve_character_tokens_adjacent_to_keywords(self):
        """Keep renderer ownership visible after whitespace-free character returns and cases."""
        source = self.write("port/src/tests/keyword_test.cpp", """
TEST(Character, Return) { auto value = [] { return'}'; }; RendererInit(); }
TEST(Character, Case) { switch (value) { case'{': break; } RendererInit(); }
""")
        self.assertEqual(list(gpu_test_labels.device_tests(source)),
                         ["Character.Return", "Character.Case"])

    def test_clean_runtime_ignores_comments_strings_and_test_fixtures(self):
        self.write(
            "port/src/game.cpp",
            '// PORT_OVERRIDE and ps2/include/old.hpp\n'
            'const char *message = "PORT_FIX ps2/src/old.cpp";\n'
            '/* PORT_RETURN(0) */\n#include "game.hpp"\n',
        )
        self.write("port/include/game.hpp", "#pragma once\n")
        self.write("port/include/port.h", "#pragma once\n")
        self.write("port/src/tests/fixture_port.cpp", "PORT_INIT(0);\n")
        self.assertEqual(native_architecture.audit(self.root), [])

    def test_banned_macro_include_and_suffix_are_reported(self):
        self.write(
            "port/src/action_port.cpp",
            "PORT_OVERRIDE(x)\n#include \"../../../ps2/include/x.hpp\"\n#include \"legacy_port.hpp\"\n",
        )
        self.write("port/include/game.hpp", "#define PORT_RETURN(value) value\n")
        issues = native_architecture.audit(self.root)
        self.assertTrue(any("platform-suffixed" in issue for issue in issues))
        self.assertTrue(any("banned native macro PORT_OVERRIDE" in issue for issue in issues))
        self.assertTrue(any("banned native macro PORT_RETURN" in issue for issue in issues))
        self.assertTrue(any("PS2 runtime include" in issue for issue in issues))
        self.assertTrue(any("platform-suffixed native include" in issue for issue in issues))

    def test_cmake_runtime_dependency_is_reported(self):
        self.write("port/cmake/native.cmake", "# ${CMAKE_SOURCE_DIR}/ps2/src ignored\nset(x ${CMAKE_SOURCE_DIR}/ps2/src)\n")
        self.assertTrue(any("native.cmake:2" in issue for issue in native_architecture.audit(self.root)))

    def test_native_tree_rejects_port_conditionals_including_continued_conditions(self):
        self.write(
            "port/include/game.hpp",
            "#ifdef PORT\n#endif\n#ifndef PORT\n#endif\n"
            "#if defined(PAL) && \\\n    defined(PORT)\n#endif\n"
            "#if defined(PAL)\n#elifdef PORT\n#endif\n",
        )
        issues = native_architecture.audit(self.root)
        self.assertEqual(sum("redundant native PORT conditional" in issue for issue in issues), 4)

    def test_native_port_conditional_check_ignores_comments_literals_and_other_symbols(self):
        self.write(
            "port/include/game.hpp",
            '// #ifdef PORT\n/*\n#ifndef PORT\n*/\n'
            'const char *message = "#if defined(PORT)";\n'
            '#ifdef PORTABLE\n#endif\n#if defined(PAL)\n#endif\n',
        )
        self.assertEqual(native_architecture.audit(self.root), [])

    def test_raw_memory_card_buffer_prototypes_are_rejected(self):
        self.write(
            "port/include/sce/libmc.h",
            "int sceMcRead(int fd, void *buffer, int size);\n"
            "int sceMcWrite(int fd, const void *buffer, int size);\n"
            "int sceMcChdir(int port, int slot, const char *name, char *current);\n"
            "int sceMcGetDir(int port, int slot, const char *name, int mode, int count, sceMcTblGetDir *table);\n",
        )
        issues = native_architecture.audit(self.root)
        self.assertEqual(sum("unbounded native memory-card prototype" in issue for issue in issues), 4)

    def test_bounded_memory_card_api_and_documented_legacy_shapes_are_accepted(self):
        self.write(
            "port/include/sce/libmc.h",
            "int sceMcRead(int fd, std::span<std::byte> buffer, int size);\n"
            "int sceMcWrite(int fd, std::span<const std::byte> buffer, int size);\n"
            "int sceMcChdir(int port, int slot, const char *name, std::span<char> current);\n"
            "int sceMcGetDir(int port, int slot, const char *name, int mode, int count, std::span<sceMcTblGetDir> table);\n"
            "// int sceMcRead(int fd, void *buffer, int size);\n"
            'const char *message = "int sceMcWrite(int fd, void *buffer, int size);";\n',
        )
        self.assertEqual(native_architecture.audit(self.root), [])

    def test_included_source_fragments_are_checked(self):
        for suffix in ("inc", "inl", "ipp", "tpp"):
            self.write(f"port/src/body.{suffix}", "PORT_FIX(value)\n")
        issues = native_architecture.audit(self.root)
        self.assertEqual(sum("banned native macro PORT_FIX" in issue for issue in issues), 4)

    def test_empty_and_dependency_only_databases_fail_closed(self):
        for contents in ([], {}, [{"file": "external.cpp", "directory": str(self.root)}], [{}]):
            with self.subTest(contents=contents):
                database = self.write("build/compile_commands.json", json.dumps(contents))
                self.assertTrue(native_architecture.audit(self.root, database))

    def test_relative_database_inputs_are_normalized_before_checks(self):
        database = self.write("build/compile_commands.json", json.dumps([
            {"directory": str(self.root / "build"), "file": "../port/src/game.cpp",
             "arguments": ["clang++", "-I../port/../ps2/include", "-c", "game.cpp"]},
            {"directory": str(self.root / "build"), "file": "../port/../ps2/src/legacy.cpp",
             "arguments": ["clang++", "-c", "legacy.cpp"]},
        ]))
        issues = native_architecture.audit(self.root, database)
        self.assertTrue(any("PS2 source input" in issue for issue in issues))
        self.assertTrue(any("PS2 include input" in issue for issue in issues))

    def test_compile_database_checks_inputs_and_include_flags(self):
        database = self.write(
            "build/compile_commands.json",
            json.dumps(
                [
                    {
                        "directory": str(self.root),
                        "file": str(self.root / "ps2/src/legacy.cpp"),
                        "arguments": ["clang++", "-c", "legacy.cpp"],
                    },
                    {
                        "directory": str(self.root),
                        "file": str(self.root / "port/src/game.cpp"),
                        "arguments": [
                            "clang++",
                            "-I",
                            str(self.root / "ps2/include"),
                            "-include",
                            str(self.root / "ps2/include/forced.hpp"),
                            "-c",
                            "game.cpp",
                        ],
                    },
                ]
            ),
        )
        issues = native_architecture.audit(self.root, database)
        self.assertTrue(any("PS2 source input" in issue for issue in issues))
        self.assertEqual(sum("PS2 include input" in issue for issue in issues), 2)

    def test_missing_compile_database_is_reported_only_when_requested(self):
        self.assertEqual(native_architecture.audit(self.root), [])
        issues = native_architecture.audit(self.root, self.root / "build/missing.json")
        self.assertTrue(any("compile database does not exist" in issue for issue in issues))

    def test_native_warning_policy_allows_only_old_language_compatibility_exclusions(self):
        database = self.write("build/compile_commands.json", json.dumps([
            {"directory": str(self.root), "file": "port/src/game.cpp",
             "arguments": ["clang++", "-Weverything", "-Wno-c++98-compat", "-Wno-pre-c++26-compat-pedantic", "-c", "port/src/game.cpp"]},
            {"directory": str(self.root), "file": "dependencies/library.cpp",
             "arguments": ["clang++", "-w", "-c", "dependencies/library.cpp"]},
        ]))
        self.assertEqual(native_architecture.audit(self.root, database), [])

    def test_native_warning_policy_rejects_global_and_safety_suppressions(self):
        for flag in ("-w", "-Wno-unsafe-buffer-usage", "-Wno-uninitialized", "-Wno-all"):
            with self.subTest(flag=flag):
                database = self.write("build/compile_commands.json", json.dumps([
                    {"directory": str(self.root), "file": "port/src/game.cpp",
                     "arguments": ["clang++", "-Weverything", flag, "-c", "port/src/game.cpp"]},
                ]))
                issues = native_architecture.audit(self.root, database)
                self.assertTrue(any("warnings are disabled" in issue or "warning exclusion" in issue for issue in issues))

    def test_native_clang_command_requires_all_warnings(self):
        database = self.write("build/compile_commands.json", json.dumps([
            {"directory": str(self.root), "file": "port/src/game.cpp",
             "arguments": ["clang++", "-Wall", "-Wextra", "-c", "port/src/game.cpp"]},
        ]))
        self.assertTrue(any("all Clang warnings" in issue for issue in native_architecture.audit(self.root, database)))

    def test_unsafe_text_apis_are_rejected_in_runtime_fragments(self):
        self.write("port/src/menu.inc", 'std::strcpy(destination, source);\nsprintf(output, "%s", source);\n')
        self.write("port/src/tests/fixture.cpp", 'strcpy(destination, "fixed fixture");\n')
        issues = native_architecture.audit(self.root)
        self.assertEqual(sum("unsafe native text API" in issue for issue in issues), 2)


if __name__ == "__main__":
    unittest.main()
