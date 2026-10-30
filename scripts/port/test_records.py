import os
import shutil
import sys
import tempfile
import unittest
from pathlib import Path
from unittest import mock

sys.path.insert(0, str(Path(__file__).resolve().parent))

import records  # noqa: E402
import truncations  # noqa: E402

PRELUDE = "typedef __UINTPTR_TYPE__ uptr;\ntypedef __INTPTR_TYPE__ sptr;\n"
PARSE_ARGS = ["-x", "c++", "-std=c++26", "-fms-extensions", "-Weverything"]

TABLE = """# Records

## Summary

- ignored

## Records

| Struct | Size | Declared | Reader | Approach | PC | Offset/address fields |
|---|---|---|---|---|---|---|
| PACK_ENTRY | 0x4C | `ps2/include/a.hpp:2` | dataread.cpp | resolved | assert | offset |
| FONT_TBL_BIN | FONT_TBL_BIN_SIZE | `ps2/include/a.hpp:6` | font.cpp | none | assert | - |
| SAVEDATA | 8 | `ps2/include/a.hpp:10` | memcard.cpp | none | host image | - |
| DATA_HEADER | 0xC | `ps2/include/a.hpp:13` | dataread.cpp | fixup | PS2 only | name_offset |

## Runtime structs

| Struct | Size | Declared | Address-holding integer fields |
|---|---|---|---|
| CRandom | 0x4 | `ps2/include/c.hpp:33` | - |
"""

A_HPP = """struct PACK_ENTRY { int offset; int size; int next; int pad; };
STATIC_ASSERT(sizeof(PACK_ENTRY) == 0x4C);
PORT_RECORD_ASSERT(sizeof(PACK_ENTRY) == 0x4C);

struct FONT_TBL_BIN { int a; };
STATIC_ASSERT(sizeof(FONT_TBL_BIN) == FONT_TBL_BIN_SIZE);
PORT_RECORD_ASSERT(sizeof(FONT_TBL_BIN) == FONT_TBL_BIN_SIZE);

struct SAVEDATA { long long a; };
STATIC_ASSERT(sizeof(SAVEDATA) == 8);

struct DATA_HEADER { int a; int b; int c; };
STATIC_ASSERT(sizeof(DATA_HEADER) == 0xC);
"""

STALE = {"`ps2/include/a.hpp:2`": "`ps2/include/a.hpp:1`", "`ps2/include/a.hpp:6`": "`ps2/include/a.hpp:9`",
         "`ps2/include/a.hpp:10`": "`ps2/include/a.hpp:12`", "`ps2/include/a.hpp:13`": "`ps2/include/a.hpp:20`"}


def write(root, rel, text):
    path = os.path.join(root, *rel.split("/"))
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w", encoding="latin-1", newline="") as f:
        f.write(text)


def make_tree(root, table=TABLE, header=A_HPP):
    write(root, "docs/port/records.md", table)
    write(root, "ps2/include/a.hpp", header)
    write(root, "ps2/src/b.cpp", "void f() {}\n")


def rows_of(table=TABLE):
    return records.parse_table(table.split("\n"))


def stale(table=TABLE):
    for old, new in STALE.items():
        table = table.replace(old, new)
    return table


class TableTests(unittest.TestCase):

    def test_columns_are_looked_up_by_header_name(self):
        table = ("## Records\n\n| PC | Struct | Declared | Size |\n|---|---|---|---|\n"
                 "| assert | Foo | `ps2/include/f.hpp:7` | 0x8 |\n")
        rows = records.parse_table(table.split("\n"))
        self.assertEqual(len(rows), 1)
        self.assertEqual((rows[0].struct, rows[0].size, rows[0].declared, rows[0].line, rows[0].pc),
                         ("Foo", "0x8", "ps2/include/f.hpp", 7, "assert"))

    def test_hex_decimal_and_symbolic_sizes_are_kept_as_text(self):
        self.assertEqual([r.size for r in rows_of()], ["0x4C", "FONT_TBL_BIN_SIZE", "8", "0xC"])

    def test_the_three_pc_values_parse(self):
        self.assertEqual([r.pc for r in rows_of()], ["assert", "assert", "host image", "PS2 only"])

    def test_unknown_pc_value_is_rejected(self):
        with self.assertRaisesRegex(ValueError, "PC 'hosted'"):
            rows_of(TABLE.replace("| host image |", "| hosted |"))

    def test_runtime_table_is_not_read(self):
        self.assertNotIn("CRandom", [r.struct for r in rows_of()])

    def test_emit_lists_assert_rows_only(self):
        self.assertEqual(records.emit(rows_of()), [
            "ps2/include/a.hpp: PORT_RECORD_ASSERT(sizeof(PACK_ENTRY) == 0x4C);",
            "ps2/include/a.hpp: PORT_RECORD_ASSERT(sizeof(FONT_TBL_BIN) == FONT_TBL_BIN_SIZE);",
        ])


class TextCheckTests(unittest.TestCase):

    def check(self, table=TABLE, header=A_HPP, extra=None):
        with tempfile.TemporaryDirectory() as root:
            make_tree(root, table, header)
            for rel, text in (extra or {}).items():
                write(root, rel, text)
            return records.check_text(root, rows_of(table)), records.check_unlisted_asserts(root, rows_of(table))

    def test_good_tree_is_clean(self):
        (failures, warnings), unlisted = self.check()
        self.assertEqual((failures, warnings, unlisted), ([], [], []))

    def test_missing_port_record_assert_fails(self):
        header = A_HPP.replace("PORT_RECORD_ASSERT(sizeof(PACK_ENTRY) == 0x4C);\n", "")
        (failures, _), _ = self.check(header=header)
        self.assertEqual(len(failures), 1)
        self.assertIn("PACK_ENTRY", failures[0])
        self.assertIn("must follow the STATIC_ASSERT", failures[0])

    def test_unlisted_assert_fails(self):
        _, unlisted = self.check(extra={"ps2/src/b.cpp": "PORT_RECORD_ASSERT(sizeof(NOT_LISTED) == 4);\n"})
        self.assertEqual(len(unlisted), 1)
        self.assertIn("NOT_LISTED", unlisted[0])
        self.assertIn("ps2/src/b.cpp:1", unlisted[0])

    def test_assert_on_host_image_row_fails(self):
        _, unlisted = self.check(header=A_HPP + "PORT_RECORD_ASSERT(sizeof(SAVEDATA) == 8);\n")
        self.assertEqual(len(unlisted), 1)
        self.assertIn("on a host image row", unlisted[0])

    def test_assert_on_ps2_only_row_fails(self):
        _, unlisted = self.check(extra={"ps2/src/b.cpp": "PORT_RECORD_ASSERT(sizeof(DATA_HEADER) == 0xC);\n"})
        self.assertIn("on a PS2 only row", unlisted[0])

    def test_stale_declared_line_warns_without_failing(self):
        (failures, warnings), _ = self.check(table=stale())
        self.assertEqual(failures, [])
        self.assertEqual(len(warnings), 4)
        self.assertIn("STATIC_ASSERT is at line 2", warnings[0])

    def test_two_static_asserts_for_one_record_fail(self):
        (failures, _), _ = self.check(header=A_HPP + "STATIC_ASSERT(sizeof(PACK_ENTRY) == 0x4C);\n")
        self.assertIn("2 STATIC_ASSERT", failures[0])


class PS2OnlyTests(unittest.TestCase):

    def test_mentions_outside_the_reader_fail(self):
        with tempfile.TemporaryDirectory() as root:
            write(root, "ps2/src/dataread.cpp", "DATA_HEADER *h; // DATA_HEADER in a comment is fine\n")
            write(root, "port/src/other.cpp", "/* DATA_HEADER */\nDATA_HEADER_SIZE x;\nvoid g(DATA_HEADER *h);\n")
            failures = records.check_ps2_only_mentions(root)
        self.assertEqual(failures, ["port/src/other.cpp:3 mentions DATA_HEADER, which only ps2/src/dataread.cpp reads"])

    def test_ps2_only_reader_functions_must_be_unlinked(self):
        with tempfile.TemporaryDirectory() as root:
            write(root, "build/darkchronicle", "")
            linked = {"InitCDFile", "SearchFile", "CDRead", "LoadFile2.isra.0"}
            with mock.patch.object(truncations, "linked_functions", return_value=linked):
                failures = records.check_ps2_only_functions(os.path.join(root, "build"))
        self.assertEqual(len(failures), 2)
        self.assertIn("SearchFile", failures[0])
        self.assertIn("CDRead", failures[1])

    def test_no_binary_means_no_function_check(self):
        with tempfile.TemporaryDirectory() as root:
            self.assertIsNone(records.check_ps2_only_functions(root))


class UpdateLinesTests(unittest.TestCase):

    def test_rewrites_only_the_declared_line_numbers(self):
        with tempfile.TemporaryDirectory() as root:
            make_tree(root, stale())
            lines = records.read_lines(os.path.join(root, "docs/port/records.md"))
            self.assertEqual(records.update_lines(root, lines, rows_of(stale())), [])
        self.assertEqual("\n".join(lines), TABLE)

    def test_main_keeps_crlf_line_endings(self):
        with tempfile.TemporaryDirectory() as root:
            make_tree(root, stale().replace("\n", "\r\n"))
            self.assertEqual(records.main(["--root", root, "--update-lines"]), 0)
            with open(os.path.join(root, "docs/port/records.md"), encoding="latin-1", newline="") as f:
                text = f.read()
        self.assertEqual(text, TABLE.replace("\n", "\r\n"))

    def test_main_check_passes_on_a_good_tree(self):
        with tempfile.TemporaryDirectory() as root:
            make_tree(root)
            self.assertEqual(records.main(["--root", root]), 0)
        self.assertEqual(truncations.ROOT, records.ROOT)


class LayoutTests(unittest.TestCase):

    @classmethod
    def setUpClass(cls):
        try:
            truncations.load_libclang(None)
        except ImportError as error:
            raise unittest.SkipTest("clang Python bindings are missing: %s" % error)
        except Exception as error:
            raise unittest.SkipTest("libclang cannot be loaded: %s" % error)

    def check(self, body, struct, size):
        with tempfile.TemporaryDirectory() as root:
            write(root, "port/include/t.hpp", PRELUDE + body)
            header = os.path.join(root, "port", "include", "t.hpp").replace(os.sep, "/")
            main = os.path.join(root, "port", "src", "t.cpp")
            row = records.Row(struct=struct, size=size, declared="port/include/t.hpp", line=1, pc="assert",
                              line_index=0, declared_cell=0)
            source = '#include "%s"\n%s' % (header, records.size_constants([row]))
            compiler = shutil.which("clang++-23") or shutil.which("clang++")
            self.assertIsNotNone(compiler)
            args = truncations.command_args({"file": main, "directory": root,
                                            "arguments": [compiler, *PARSE_ARGS, "-c", main]})
            with mock.patch.object(truncations, "ROOT", root):
                tu = records.parse_tu(main, args, source)
                self.assertEqual(records.diagnostics(tu), [])
                return records.check_tu(tu, [row], root)

    def test_compiler_headers_parse_and_missing_header_fails(self):
        compiler = shutil.which("clang++-23") or shutil.which("clang++")
        self.assertIsNotNone(compiler)
        with tempfile.TemporaryDirectory() as root:
            path = os.path.join(root, "records_standard_headers.cpp")
            args = truncations.command_args({"file": path, "directory": root,
                                            "arguments": [compiler, "-std=c++26", "-c", path]})
            source = "#include <cstddef>\n#include <new>\n#include <string>\n"
            self.assertEqual(records.diagnostics(records.parse_tu(path, args, source)), [])
            missing = '#include "missing_record_header.hpp"\n'
            self.assertTrue(records.diagnostics(records.parse_tu(path, args, missing)))

    def test_record_traversal_skips_unowned_library_declarations_and_method_bodies(self):
        from types import SimpleNamespace

        K = truncations.ci.CursorKind
        def cursor(path, kind, children):
            return SimpleNamespace(location=SimpleNamespace(file=SimpleNamespace(name=path)), kind=kind,
                                   get_children=children)

        vendor = cursor("/vendor/unsupported.hpp", K.NAMESPACE,
                        mock.Mock(side_effect=AssertionError("must not traverse library declarations")))
        method = cursor("/owned/record.hpp", K.CXX_METHOD,
                        mock.Mock(side_effect=AssertionError("must not traverse function bodies")))
        record = cursor("/owned/record.hpp", K.STRUCT_DECL, lambda: [method])
        unit = SimpleNamespace(cursor=SimpleNamespace(get_children=lambda: [vendor, record]))
        self.assertEqual(list(records.record_cursors(unit, {"/owned/record.hpp"})), [record, method])
        vendor.get_children.assert_not_called()
        method.get_children.assert_not_called()

    def test_record_with_standard_headers_and_inline_bodies_is_checked(self):
        body = "#include <string>\nstruct T { int a; char b[4]; int f() { std::string value; return value.size(); } };"
        self.assertEqual(self.check(body, "T", "0x8"), [])

    def test_char_pointer_member_fails(self):
        failures = self.check("struct T { char *p; };", "T", "0x8")
        self.assertEqual(len(failures), 1)
        self.assertRegex(failures[0], r"^port/include/t\.hpp:\d+ T\.p: pointer member in a record$")

    def test_plain_members_pass(self):
        self.assertEqual(self.check("struct T { int a; char b[4]; };", "T", "0x8"), [])

    def test_pointer_in_nested_union_fails(self):
        failures = self.check("struct T { union { int a; char *p; } u; };", "T", "0x8")
        self.assertEqual(len(failures), 1)
        self.assertIn("T.u.p: pointer member in a record", failures[0])

    def test_size_mismatch_fails(self):
        failures = self.check("struct T { int a; };", "T", "0x8")
        self.assertEqual(len(failures), 1)
        self.assertIn("sizeof is 4, records.md says 0x8", failures[0])

    def test_uptr_member_fails(self):
        failures = self.check("struct T { uptr u; };", "T", "0x8")
        self.assertIn("T.u: uptr/sptr member in a record", failures[0])

    def test_virtual_method_fails(self):
        failures = self.check("struct T { virtual void f(); int a; };", "T", "0x10")
        self.assertIn("vtable pointer", failures[0])


if __name__ == "__main__":
    unittest.main()
