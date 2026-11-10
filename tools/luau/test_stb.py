import collections
import json
import struct
import sys
import tempfile
import unittest
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))

from stb import catalog, cfg, sources  # noqa: E402
from stb.analysis import Analysis, Value, fold  # noqa: E402
from stb.assembler import assemble  # noqa: E402
from stb.corpus import Kind, classify, scripts  # noqa: E402
from stb.opcodes import AddrMode, Op  # noqa: E402
from stb.program import DecodeError, body_hashes, decode  # noqa: E402
from stb.scan import Argument, ScriptFacts, facts  # noqa: E402

REPO = HERE.parents[1]
LOCAL, LOCAL_FLOAT = AddrMode.LOCAL, AddrMode.LOCAL_FLOAT


def program(functions, main="main", programs=None, **kwargs):
    return decode(assemble(functions, main, programs, **kwargs))


class DecodeTest(unittest.TestCase):
    def test_programs_calls_and_uncalled_helpers(self):
        p = program({
            "main": (1, 0, [("push", 7), ("CALL", "helper"), ("RET",)]),
            "helper": (2, 1, [("LOAD", 0, LOCAL), ("RET",)]),
            "unused": (0, 0, [("pushs", b"\x82\xa0"), ("POP",), ("push", 0), ("RET",)]),
            "event": (0, 0, [("WAIT",), ("END",)]),
        }, programs={100: "event"})
        self.assertEqual(p.programs, [(100, p.functions[max(p.functions)].block)])
        referenced = {f.block: f.referenced for f in p.functions.values()}
        self.assertEqual(sorted(referenced.values()), [False, True, True, True])
        unused = next(f for f in p.functions.values() if not f.referenced)
        self.assertEqual(p.string(unused.instructions[0]), b"\x82\xa0")

    def test_invalid_jump_is_rejected(self):
        data = bytearray(assemble({"main": (0, 0, [("push", 0), ("RET",)])}, "main"))
        struct.pack_into("<iii", data, 28 + 56, Op.JMP, -4, 0)
        with self.assertRaisesRegex(DecodeError, "jump"):
            decode(data)

    def test_function_continues_past_return_reached_by_jump(self):
        p = program({"main": (0, 0, [("push", 1), ("JMP_FALSE", "late", 0), ("push", 0), ("RET",), ("label", "late"), ("push", 2), ("RET",)])})
        self.assertEqual(len(p.functions[p.main].instructions), 6)

    def test_identical_bodies_hash_alike(self):
        body = [("push", 1), ("pushs", b"same"), ("POP",), ("RET",)]
        p = program({"main": (0, 0, body), "copy": (0, 0, list(body))})
        self.assertEqual(len(set(body_hashes(p).values())), 1)


class GraphTest(unittest.TestCase):
    def test_loop_is_natural(self):
        p = program({"main": (1, 0, [("label", "top"), ("WAIT",), ("LOAD", 0, LOCAL), ("JMP_TRUE", "top", 0), ("push", 0), ("RET",)])})
        graph = cfg.build(p, p.functions[p.main])
        self.assertTrue(graph.reducible)
        self.assertEqual(len(graph.back_edges), 1)

    def test_two_entry_cycle_is_irreducible(self):
        p = program({"main": (0, 0, [
            ("push", 1), ("JMP_FALSE", "b", 0),
            ("label", "a"), ("WAIT",), ("JMP", "b"),
            ("label", "b"), ("push", 1), ("JMP_TRUE", "a", 0),
            ("push", 0), ("RET",),
        ])})
        self.assertFalse(cfg.build(p, p.functions[p.main]).reducible)


class AnalysisTest(unittest.TestCase):
    def sites(self, p):
        return [site for fact in Analysis(p).facts.values() for site in fact.ext_sites.values()]

    def test_folded_command_and_argument_shapes(self):
        p = program({"main": (2, 0, [
            ("push", 60), ("push", 15), ("ADD",),
            ("push", 3), ("pushf", 1.5), ("pushs", b"name"),
            ("LOAD_ADDR", 0, LOCAL_FLOAT), ("LOAD_ADDR", 1, LOCAL),
            ("EXT", 6), ("push", 0), ("RET",),
        ])})
        site, = self.sites(p)
        self.assertEqual(site.command, 75)
        from stb.scan import argument
        shapes = [argument(v) for v in site.args]
        self.assertEqual(shapes, [
            Argument("in", "s32", "const", 3), Argument("in", "f32", "const", 1.5), Argument("in", "string", "const"),
            Argument("out", "f32", "variable"), Argument("out", "s32", "variable"),
        ])

    def test_short_circuit_merges_without_stack_errors(self):
        p = program({"main": (2, 0, [
            ("LOAD", 0, LOCAL), ("JMP_FALSE", "done", 1), ("LOAD", 1, LOCAL), ("label", "done"),
            ("JMP_FALSE", "skip", 0), ("push", 1), ("EXT", 1), ("label", "skip"), ("push", 0), ("RET",),
        ])})
        analysis = Analysis(p)
        fact = analysis.facts[p.main]
        self.assertEqual(fact.stack_errors, [])
        self.assertEqual(fact.counters["short_circuit"], 1)
        self.assertEqual([s.command for s in fact.ext_sites.values()], [1])

    def test_parameter_types_flow_from_callers(self):
        p = program({
            "main": (0, 0, [("pushf", 2.0), ("CALL", "helper"), ("POP",), ("push", 0), ("RET",)]),
            "helper": (1, 1, [("push", 5), ("LOAD", 0, LOCAL), ("EXT", 2), ("push", 0), ("RET",)]),
        })
        site, = self.sites(p)
        self.assertEqual(site.args[0].type, "float")

    def test_stored_strings_type_their_variable(self):
        p = program({"main": (1, 0, [
            ("LOAD_ADDR", 0, LOCAL), ("pushs", b"x"), ("STORE",), ("POP",),
            ("push", 9), ("LOAD", 0, LOCAL), ("EXT", 2), ("push", 0), ("RET",),
        ])})
        site, = self.sites(p)
        self.assertEqual(site.args[0].type, "str")

    def test_integer_folding_matches_the_virtual_machine(self):
        def const(n):
            return Value("const", "int", const=n)
        self.assertEqual(fold(Op.DIV, const(-7), const(2)).const, -3)
        self.assertEqual(fold(Op.MOD, const(-7), const(2)).const, -1)
        self.assertEqual(fold(Op.MUL, const(0x40000000), const(4)).const, 0)
        self.assertEqual(fold(Op.ADD, const(0x7FFFFFFF), const(1)).const, -0x80000000)
        self.assertIsNone(fold(Op.DIV, const(1), const(0)))


class SourcesTest(unittest.TestCase):
    HANDLERS = """
/**
 *
 * Moves a thing.
 *
 */
static int _MOVE(RS_STACKDATA *stack, int argc) {
    if (argc != 5) {
        return false;
    }

    int   id = GetStackInt(stack++);
    float pos[4];
    GetStackVector(pos, stack);
    stack += 3;
    SetStack(stack, result);
    return true;
}

static int _MANY(RS_STACKDATA *stack, int argc) {
    int   id;
    float speed;

    switch (argc) {
        case 1:
            id = GetStackInt(stack);
            break;
        case 2:
        case 3:
            id = GetStackInt(stack++);
            speed = GetStackFloat(stack++);
            SetStack(stack, speed);
            break;
        default:
            return false;
    }
    return true;
}

static int _QUIET(RS_STACKDATA *, int) {
    return true;
}
"""

    def test_accessor_order_names_parameters(self):
        handlers = sources.parse_handlers(self.HANDLERS)
        move = handlers["_MOVE"]
        self.assertEqual(move.description, "Moves a thing.")
        self.assertEqual(move.arity_checks, ["!= 5"])
        self.assertTrue(move.linear)
        self.assertEqual([(p.direction, p.type, p.name) for p in move.params], [
            ("in", "s32", "id"), ("in", "f32", "pos_x"), ("in", "f32", "pos_y"), ("in", "f32", "pos_z"), ("out", None, "result"),
        ])
        many = handlers["_MANY"]
        self.assertTrue(many.polymorphic)
        self.assertEqual(many.arity_checks, ["case 1", "case 2", "case 3"])
        by_arity = {argc: [(p.direction, p.type, p.name) for p in params] for argc, params in many.params_by_arity.items()}
        self.assertEqual(by_arity, {1: [("in", "s32", "id")], 3: [("in", "s32", "id"), ("in", "f32", "speed"), ("out", "f32", "speed")]})
        self.assertIn("_QUIET", handlers)

    def test_enum_and_table(self):
        enum = sources.parse_enum("enum E {\n    E_A = 0, /**< First. */\n    E_B = 0x10,\n};\n", "E")
        self.assertEqual([(e.name, e.value, e.comment) for e in enum], [("E_A", 0, "First."), ("E_B", 16, "")])
        table = sources.parse_table("static RS_EXTFUNC_INFO t[] = {\n    {_A, E_A},\n    {NULL, E_A},\n    {_B, E_B},\n};\n", "t")
        self.assertEqual(table, [("_A", "E_A")])

    def test_every_registered_handler_is_found(self):
        for kind in Kind:
            _, enum, table, handlers = sources.load(REPO, kind)
            names = {e.name for e in enum}
            self.assertEqual([h for h, _ in table if h not in handlers], [], kind)
            self.assertEqual([n for _, n in table if n not in names], [], kind)


class CatalogTest(unittest.TestCase):
    def site_facts(self, *sites):
        script = ScriptFacts("dungeon/act_script/test.stb", Kind.ACTION, 0)
        script.ext_sites = list(sites)
        return [script]

    def test_signatures_merge_handler_names_and_call_sites(self):
        play = (35, (Argument("in", "s32", "const", -1), Argument("in", "s32", "const", 4)))
        wrong = (35, (Argument("in", "s32", "const", -1), Argument("in", "s32", "const", 4), Argument("in", "s32", "const", 0)))
        document, findings = catalog.build(REPO, self.site_facts(play, play, wrong))
        command = next(c for c in document["kinds"]["action"]["commands"] if c["handler"] == "_SE_PLAY")
        self.assertEqual(command["luau"], "SePlay")
        two, three = command["signatures"]
        self.assertEqual([(p["name"], p["type"]) for p in two["params"]], [("requested_bank", "s32"), ("sound", "s32")])
        self.assertEqual(two["sites"], 2)
        self.assertTrue(three.get("handler_rejects"))
        self.assertIn(("action", "_SE_PLAY", 3, 1), findings["rejected"])
        self.assertEqual(catalog.names_are_identifiers(document), [])

    def test_curation_overrides_generated_fields(self):
        curation = {"action": {"_SE_PLAY": {"luau": "PlaySound", "signatures": {"2": {"params": [{"name": "bank"}, {"type": "u16"}]}}}}}
        document, _ = catalog.build(REPO, self.site_facts((35, (Argument("in", "s32", "value"), Argument("in", "s32", "value")))), curation)
        command = next(c for c in document["kinds"]["action"]["commands"] if c["handler"] == "_SE_PLAY")
        self.assertEqual(command["luau"], "PlaySound")
        self.assertEqual([(p["name"], p["type"]) for p in command["signatures"][0]["params"]], [("bank", "s32"), ("sound", "u16")])

    def test_unregistered_commands_are_reported(self):
        _, findings = catalog.build(REPO, self.site_facts((6, (Argument("in", "s32", "value"),))))
        self.assertEqual(findings["unregistered"][0][:4], ("action", 6, 1, 1))


class CorpusTest(unittest.TestCase):
    def test_classification(self):
        self.assertEqual(classify("dungeon/act_script/c01.stb"), Kind.ACTION)
        self.assertEqual(classify("mainchr/c02.stb_"), Kind.ACTION)
        self.assertEqual(classify("dungeon/monster/b02a.stb"), Kind.MONSTER)
        self.assertEqual(classify("dungeon/eff_script/menu_ice.pac/c02cold.stb"), Kind.EFFECT)
        self.assertEqual(classify("event/tbox/bomb.pack/tbox_exp.stb"), Kind.EFFECT)
        self.assertEqual(classify("event/tbox/ntbox_arg_1.stb"), Kind.EVENT_ARG)
        self.assertEqual(classify("map/s/s01/s01_1.stb"), Kind.EVENT)

    def test_directory_source_and_facts(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "dungeon" / "act_script").mkdir(parents=True)
            (root / "dungeon" / "act_script" / "a.stb").write_bytes(assemble({"main": (0, 0, [("push", 35), ("push", -1), ("push", 2), ("EXT", 3), ("push", 0), ("RET",)])}, "main"))
            (root / "readme.txt").write_bytes(b"not a script")
            found = list(scripts(root))
        self.assertEqual([path for path, _ in found], ["dungeon/act_script/a.stb"])
        script = facts(*found[0])
        self.assertIsNone(script.error)
        self.assertEqual(script.ext_sites, [(35, (Argument("in", "s32", "const", -1), Argument("in", "s32", "const", 2)))])


class CheckedInCatalogTest(unittest.TestCase):
    def test_catalog_matches_the_sources(self):
        path = HERE / "commands.json"
        if not path.is_file():
            self.skipTest("no catalog")
        document = json.loads(path.read_text(encoding="utf-8"))
        self.assertEqual(catalog.names_are_identifiers(document), [])
        for kind in Kind:
            _, enum, table, _ = sources.load(REPO, kind)
            values = {e.name: e.value for e in enum}
            expected = collections.OrderedDict(sorted((values[n], h) for h, n in table))
            actual = collections.OrderedDict((c["no"], c["handler"]) for c in document["kinds"][kind.value]["commands"])
            self.assertEqual(actual, expected, kind)
            for command in document["kinds"][kind.value]["commands"]:
                for signature in command["signatures"]:
                    self.assertEqual(len(signature["params"]), signature["argc"])
                    for param in signature["params"]:
                        self.assertIn(param["type"], catalog.TYPES + ["unknown"])


if __name__ == "__main__":
    unittest.main()
