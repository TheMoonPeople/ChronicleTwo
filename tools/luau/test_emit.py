import struct
import sys
import unittest
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))

from stb2luau import ir  # noqa: E402
from stb2luau.emit import EmitError, FunctionInput, ModuleInput, emit  # noqa: E402
from stb import opcodes  # noqa: E402

CATALOG = {
    "kinds": {
        "action": {
            "namespace": "action",
            "commands": [
                {
                    "no": 0,
                    "luau": "InitScript",
                    "signatures": [
                        {"argc": 0, "params": []},
                        {"argc": 1, "params": [{"name": "out1", "dir": "out", "type": "s32"}]},
                    ],
                },
                {
                    "no": 2,
                    "luau": "ProgGet",
                    "signatures": [{"argc": 1, "params": [{"name": "prog", "dir": "out", "type": "s32"}]}],
                },
                {
                    "no": 30,
                    "luau": "SetPallet",
                    "signatures": [
                        {
                            "argc": 2,
                            "params": [
                                {"name": "arg1", "dir": "in", "type": "s32"},
                                {"name": "arg2", "dir": "in", "type": "string"},
                            ],
                        },
                        {
                            "argc": 5,
                            "params": [{"name": f"arg{i}", "dir": "in", "type": "s32"} for i in range(1, 6)],
                            "handler_rejects": True,
                        },
                    ],
                },
                {
                    "no": 33,
                    "luau": "CheckPause",
                    "signatures": [
                        {"argc": 1, "params": [{"name": "out1", "dir": "out", "type": "s32"}]},
                        {
                            "argc": 2,
                            "params": [
                                {"name": "arg1", "dir": "in", "type": "s32"},
                                {"name": "out2", "dir": "out", "type": "s32"},
                            ],
                        },
                    ],
                },
                {
                    "no": 53,
                    "luau": "GetPos",
                    "signatures": [
                        {
                            "argc": 3,
                            "params": [
                                {"name": "x", "dir": "out", "type": "f32"},
                                {"name": "y", "dir": "out", "type": "f32"},
                                {"name": "z", "dir": "out", "type": "f32"},
                            ],
                        }
                    ],
                },
                {
                    "no": 60,
                    "luau": "VPush",
                    "signatures": [
                        {
                            "argc": 2,
                            "params": [
                                {"name": "index", "dir": "in", "type": "s32"},
                                {"name": "value", "dir": "in", "type": "s32", "tagged": True},
                            ],
                        }
                    ],
                },
                {
                    "no": 61,
                    "luau": "VPop",
                    "signatures": [
                        {
                            "argc": 2,
                            "params": [
                                {"name": "index", "dir": "in", "type": "s32"},
                                {"name": "value", "dir": "out", "type": "s32", "tagged": True},
                            ],
                        }
                    ],
                },
            ],
        }
    }
}

ANY_BLOCK = 0x10


def var(n, type_=ir.INT):
    return ir.Var(("local", n), type_)


def addr(n, type_=ir.INT):
    return ir.Addr(("local", n), type_)


def const(value, type_=ir.INT):
    return ir.Const(value, type_)


def ints(*numbers):
    return {("local", n): ir.INT for n in numbers}


def function(block, body, *, arg=0, slots=None, temps=(), programs=(), main=False, refs=(), arrays=None):
    return FunctionInput(
        block, arg, 0, dict(slots or {}), list(temps), list(body), list(programs), main, tuple(refs), dict(arrays or {})
    )


def main_function(body, slots=None, temps=()):
    return function(ANY_BLOCK, body, slots=slots, temps=temps, main=True)


def module(*functions, globals_=None, expose=False, probe=False):
    return ModuleInput(
        "test/a.stb", "action", dict(globals_ or {}), {f.block: f for f in functions}, expose, probe_refs=probe
    )


ARRAY = ("array", 1)
FRAME = ("frame", 0)


def bump(returns=ir.Const(0, ir.INT)):
    """Helper 0x30, which adds one to the variable its reference parameter names."""
    body = [ir.Assign(("local", 0), ir.Binary("add", var(0), const(1), ir.INT)), ir.Return(returns)]
    return function(0x30, body, arg=1, slots=ints(0), refs=(0,))


def emit_text(*functions, **kwargs):
    return emit(module(*functions, **kwargs), CATALOG)


class EmitTest(unittest.TestCase):
    def test_module_layout_and_return_table(self):
        result = emit_text(main_function([ir.Print((const(1),))]))
        self.assertEqual(
            result.text,
            "--!strict\n"
            "-- test/a.stb: action script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.\n"
            "\n"
            "local script = {}\n"
            "\n"
            "--- Runs when the script is loaded, before any program.\n"
            "function script.setup()\n"
            "\tprint(1)\n"
            "end\n"
            "\n"
            "return script\n",
        )
        self.assertEqual(result.diagnostics, [])

    def test_require_only_when_vm_is_used(self):
        plain = emit_text(main_function([ir.Print((var(3),))], slots=ints(3))).text
        self.assertNotIn("require", plain)
        with_vm = emit_text(main_function([ir.Wait()])).text
        self.assertIn('local vm = require("@lib/vm")', with_vm)
        self.assertIn("\tvm.wait()", with_vm)

    def test_program_declares_read_locals_only(self):
        body = [
            ir.Assign(("local", 3), const(0)),
            ir.Assign(("local", 4), const(5)),
            ir.Print((var(3),)),
        ]
        result = emit_text(function(0x40, body, slots=ints(3, 4), programs=[100]))
        self.assertIn(
            "--- Sets the character up when its script is initialised.\nfunction script.init()\n", result.text
        )
        self.assertIn("\tlocal var3: s32 = 0\n\tvar3 = 0\n\tprint(var3)\n", result.text)
        self.assertNotIn("var4", result.text)
        self.assertNotIn("program_100", result.text)

    def test_program_that_only_calls_a_helper_is_assigned_to_it(self):
        helper = function(0x78, [ir.Print((const(1),))])
        program = function(0x40, [ir.CallStmt(ir.Call(0x78, (), ir.INT)), ir.Return(const(0))], programs=[500])
        result = emit_text(helper, program).text
        self.assertIn("--- Reacts to a small hit.\nscript.on_small_damage = helper_78\n", result)
        self.assertNotIn("function script.on_small_damage", result)

    def test_shared_and_unnamed_programs_assign_one_local_function(self):
        body = [ir.Print((const(1),))]
        result = emit_text(function(0x40, body, programs=[100, 105])).text
        self.assertIn(
            "--- Sets the character up when its script is initialised.\n--- Program 105.\nlocal function init()\n",
            result,
        )
        self.assertIn("script.init = init\n", result)
        self.assertIn("\nscript[105] = init\n", result)

    def test_called_program_is_a_local_function(self):
        program = function(0x40, [ir.Print((const(1),))], programs=[500])
        main = main_function([ir.CallStmt(ir.Call(0x40, (), ir.INT))])
        result = emit_text(program, main).text
        self.assertIn("local function on_small_damage()\n", result)
        self.assertIn("script.on_small_damage = on_small_damage\n", result)
        self.assertLess(result.index("local function on_small_damage"), result.index("local script = {}"))

    def test_empty_program_is_defined_empty(self):
        program = function(0x40, [ir.Return(const(0))], programs=[700])
        result = emit_text(program).text
        self.assertIn(
            "--- Follows up a melee hit that the character has landed.\n"
            "-- Defined empty, so the engine runs this instead of its default.\n"
            "function script.on_melee_hit()\n"
            "end\n",
            result,
        )

    def test_helper_called_in_expression_returns_value(self):
        helper = function(
            0x78,
            [ir.Return(ir.Binary("add", var(0), const(1), ir.INT))],
            arg=1,
            slots=ints(0),
        )
        main = main_function(
            [ir.Assign(("local", 3), ir.Call(0x78, (const(4),), ir.INT)), ir.Print((var(3),))],
            slots=ints(3),
        )
        result = emit_text(helper, main).text
        self.assertIn("--- Helper function.\nlocal function helper_78(arg0: s32)\n\treturn arg0 + 1\nend\n", result)
        self.assertIn("\tvar3 = helper_78(4)\n", result)
        self.assertLess(result.index("local function helper_78"), result.index("local script = {}"))

    def test_unused_helper_return_is_dropped(self):
        helper = function(0x78, [ir.Return(const(9))], arg=0)
        main = main_function([ir.CallStmt(ir.Call(0x78, (), ir.INT))])
        result = emit_text(helper, main).text
        self.assertIn("local function helper_78()\nend\n", result)
        self.assertIn("\thelper_78()\n", result)

    def test_unread_local_keeps_call_as_discarded_value(self):
        helper = function(0x78, [ir.Return(const(9))], arg=0)
        main = main_function([ir.Assign(("local", 6), ir.Call(0x78, (), ir.INT))], slots=ints(6))
        result = emit_text(helper, main).text
        self.assertIn("\tlocal _ = helper_78()\n", result)
        self.assertNotIn("var6", result)

    def test_if_elseif_else(self):
        body = [
            ir.If(
                ir.Compare(opcodes.Compare.EQ, var(3), const(1)),
                [ir.Print((const(1),))],
                [
                    ir.If(
                        ir.Compare(opcodes.Compare.LT, var(3), const(2)),
                        [ir.Print((const(2),))],
                        [ir.Print((const(3),))],
                    )
                ],
            )
        ]
        result = emit_text(function(0x40, body, slots=ints(3), programs=[1])).text
        self.assertIn(
            "\tif var3 == 1 then\n\t\tprint(1)\n\telseif var3 < 2 then\n\t\tprint(2)\n\telse\n\t\tprint(3)\n\tend\n",
            result,
        )

    def test_while_repeat_and_numeric_for(self):
        body = [
            ir.While(const(1), [ir.Break()]),
            ir.Repeat([ir.Continue()], ir.Compare(opcodes.Compare.GE, var(3), const(10))),
            ir.NumericFor(("local", 4), const(0), var(3), const(2), [ir.Print((var(4),))]),
            ir.NumericFor(("local", 4), const(0), var(3), const(1), [ir.Print((var(4),))]),
        ]
        result = emit_text(function(0x40, body, slots=ints(3, 4), programs=[1])).text
        self.assertIn("\twhile true do\n\t\tbreak\n\tend\n", result)
        self.assertIn("\trepeat\n\t\tcontinue\n\tuntil var3 >= 10\n", result)
        self.assertIn("\tfor var4 = 0, var3, 2 do\n", result)
        self.assertIn("\tfor var4 = 0, var3 do\n", result)

    def test_loop_variable_used_only_in_its_loop_is_not_declared(self):
        body = [ir.NumericFor(("local", 4), const(0), var(3), const(1), [ir.Print((var(4),))])]
        result = emit_text(function(0x40, body, slots=ints(3, 4), programs=[1])).text
        self.assertNotIn("local var4", result)
        self.assertIn("\tlocal var3: s32 = 0\n", result)
        self.assertIn("\tfor var4 = 0, var3 do\n\t\tprint(var4)\n\tend\n", result)

    def test_loop_variable_read_after_loop_is_renamed_inside_it(self):
        body = [
            ir.NumericFor(("local", 4), const(0), var(3), const(1), [ir.Print((var(4),))]),
            ir.Print((var(4),)),
        ]
        result = emit_text(function(0x40, body, slots=ints(3, 4), programs=[1])).text
        self.assertIn("\tlocal var4: s32 = 0\n", result)
        self.assertIn("\tfor var4_i = 0, var3 do\n\t\tprint(var4_i)\n\tend\n\tprint(var4)\n", result)

    def test_loop_variable_written_only_before_loop_is_not_declared(self):
        body = [
            ir.Assign(("local", 4), const(7)),
            ir.NumericFor(("local", 4), const(0), var(3), const(1), [ir.Print((var(4),))]),
        ]
        result = emit_text(function(0x40, body, slots=ints(3, 4), programs=[1])).text
        self.assertNotIn("var4 = 7", result)
        self.assertNotIn("local var4", result)
        self.assertIn("\tfor var4 = 0, var3 do\n\t\tprint(var4)\n\tend\n", result)

    def test_logical_in_condition_and_value_context(self):
        body = [
            ir.If(
                ir.Logical(
                    "and",
                    ir.Compare(opcodes.Compare.EQ, var(3), const(1)),
                    ir.Compare(opcodes.Compare.NE, var(4), const(0)),
                    ir.BOOL,
                ),
                [ir.Print((const(1),))],
                [],
            ),
            ir.If(
                ir.Logical("or", var(4), ir.Compare(opcodes.Compare.EQ, var(3), const(2)), ir.BOOL),
                [ir.Print((const(2),))],
                [],
            ),
            ir.Assign(("local", 3), ir.Logical("and", var(4), const(7), ir.INT)),
            ir.Assign(("local", 5), ir.Logical("or", var(4), const(7), ir.INT)),
            ir.Print((var(3), var(5))),
        ]
        result = emit_text(function(0x40, body, slots=ints(3, 4, 5), programs=[1])).text
        self.assertIn("\tif var3 == 1 and var4 ~= 0 then\n", result)
        self.assertIn("\tif var4 ~= 0 or var3 == 2 then\n", result)
        self.assertIn("\tvar3 = if var4 ~= 0 then 7 else 0\n", result)
        self.assertIn("\tvar5 = if var4 ~= 0 then 1 else 7\n", result)

    def test_comparison_stored_as_integer(self):
        body = [ir.Assign(("local", 3), ir.Compare(opcodes.Compare.EQ, var(4), const(1))), ir.Print((var(3),))]
        result = emit_text(function(0x40, body, slots=ints(3, 4), programs=[1])).text
        self.assertIn("\tvar3 = if var4 == 1 then 1 else 0\n", result)

    def test_integer_division_and_modulo_helpers(self):
        body = [
            ir.Assign(("local", 3), ir.Binary("div", var(4), var(5), ir.INT)),
            ir.Assign(("local", 6), ir.Binary("mod", var(4), var(5), ir.INT)),
            ir.Assign(("local", 7), ir.Binary("mul", var(4), var(5), ir.INT)),
            ir.Assign(("local", 8), ir.Binary("mul", var(4), const(3), ir.INT)),
            ir.Print((var(3), var(6), var(7), var(8))),
        ]
        result = emit_text(function(0x40, body, slots=ints(3, 4, 5, 6, 7, 8), programs=[1]))
        self.assertIn('local vm = require("@lib/vm")', result.text)
        self.assertIn("\tvar3 = vm.idiv(var4, var5)\n", result.text)
        self.assertIn("\tvar6 = vm.imod(var4, var5)\n", result.text)
        self.assertIn("\tvar7 = vm.i32(var4 * var5)\n", result.text)
        self.assertIn("\tvar8 = var4 * 3\n", result.text)

    def test_float_constant_formatting(self):
        body = [ir.Print((const(0.1, ir.FLOAT), const(2.0, ir.FLOAT), const(1e-05, ir.FLOAT)))]
        self.assertIn("\tprint(0.1, 2.0, 1e-05)\n", emit_text(main_function(body)).text)
        self.assertIn("\tprint(20.0)\n", emit_text(main_function([ir.Print((const(20.0, ir.FLOAT),))])).text)

    def test_float_arithmetic_and_constants_are_float32(self):
        tenth = struct.unpack("<f", struct.pack("<f", 0.1))[0]
        slots = {("local", 0): ir.FLOAT, ("local", 1): ir.FLOAT}
        body = [
            ir.Assign(("local", 1), ir.Binary("mul", var(0, ir.FLOAT), const(tenth, ir.FLOAT), ir.FLOAT)),
            ir.Assign(("local", 0), ir.Unary("sin", var(1, ir.FLOAT), ir.FLOAT)),
            ir.ExtCall(60, (const(1), const(tenth, ir.FLOAT))),
        ]
        text = emit_text(main_function(body, slots=slots)).text
        self.assertIn("\tvar1 = vm.f32(var0 * vm.f32(0.1))\n", text)
        self.assertIn("\tvar0 = vm.sin(var1)\n", text)
        # A native call rounds its float arguments itself.
        self.assertIn("\taction.VPushFloat(1, 0.1)\n", text)

    def test_unread_temp_is_discarded_into_underscore(self):
        body = [ir.Assign(ir.Temp(0, ir.INT), const(2))]
        result = emit_text(function(0x40, body, temps=[ir.INT], programs=[1])).text
        self.assertIn("\tlocal _ = 2\n", result)
        self.assertNotIn("t0", result)

    def test_unread_global_is_dropped_unless_exposed(self):
        body = [ir.Assign(("global", 0), const(3)), ir.Assign(("global", 1), ir.Call(0x78, (), ir.INT))]
        helper = function(0x78, [ir.Return(const(1))])
        plain = emit_text(main_function(body), helper, globals_={("global", 0): ir.INT, ("global", 1): ir.INT}).text
        self.assertNotIn("global0", plain)
        self.assertIn("\tlocal _ = helper_78()\n", plain)
        exposed = emit_text(
            main_function(body), helper, globals_={("global", 0): ir.INT, ("global", 1): ir.INT}, expose=True
        ).text
        self.assertIn("local global0: s32 = 0\n", exposed)
        self.assertIn("\tglobal0 = 3\n", exposed)

    def test_bare_return_at_end_of_trailing_branch_is_omitted(self):
        helper = function(
            0x78,
            [ir.If(ir.Compare(opcodes.Compare.EQ, var(0), const(100)), [ir.Print((const(1),)), ir.Return(const(0))], [])],
            arg=1,
            slots=ints(0),
        )
        result = emit_text(helper, main_function([ir.CallStmt(ir.Call(0x78, (const(1),), ir.INT))])).text
        self.assertIn("\tif arg0 == 100 then\n\t\tprint(1)\n\tend\nend\n", result)

    def test_string_constant_is_cp932_text(self):
        body = [ir.Print((const(b"\x82\xa0", ir.STR), const(b'a"\\\n', ir.STR)))]
        self.assertIn('\tprint("あ", "a\\"\\\\\\n")\n', emit_text(main_function(body)).text)

    def test_single_output_is_captured_under_catalogued_name(self):
        body = [ir.ExtCall(2, (addr(3),)), ir.Print((var(3),))]
        result = emit_text(function(0x40, body, slots=ints(3), programs=[1])).text
        self.assertIn("\tlocal prog: s32 = 0\n", result)
        self.assertIn("\tprog = action.ProgGet() or prog\n", result)
        self.assertIn("\tprint(prog)\n", result)

    def test_multiple_outputs_use_do_block(self):
        slots = {("local", 3): ir.FLOAT, ("local", 4): ir.FLOAT, ("local", 5): ir.FLOAT}
        body = [
            ir.ExtCall(53, (addr(3, ir.FLOAT), addr(4, ir.FLOAT), addr(5, ir.FLOAT))),
            ir.Print((var(3, ir.FLOAT), var(4, ir.FLOAT), var(5, ir.FLOAT))),
        ]
        result = emit_text(function(0x40, body, slots=slots, programs=[1])).text
        self.assertIn(
            "\tdo\n\t\tlocal out1, out2, out3 = action.GetPos()\n\t\tx = out1 or x\n"
            "\t\ty = out2 or y\n\t\tz = out3 or z\n\tend\n",
            result,
        )

    def test_unused_outputs_are_discarded(self):
        body = [
            ir.ExtCall(53, (addr(3, ir.FLOAT), addr(4, ir.FLOAT), addr(5, ir.FLOAT))),
            ir.Print((var(4, ir.FLOAT),)),
        ]
        slots = {("local", 3): ir.FLOAT, ("local", 4): ir.FLOAT, ("local", 5): ir.FLOAT}
        result = emit_text(function(0x40, body, slots=slots, programs=[1])).text
        self.assertIn("\t\tlocal _, out2, _ = action.GetPos()\n", result)
        self.assertIn("\t\ty = out2 or y\n", result)
        self.assertNotIn("x = out1", result)

    def test_unregistered_command_calls_ext(self):
        body = [ir.ExtCall(6, (const(1), var(3)))]
        result = emit_text(function(0x40, body, slots=ints(3), programs=[1]))
        self.assertIn("\taction.Ext(6, 1, var3) -- retail: command 6 is not registered\n", result.text)
        self.assertIn("command 6 is not registered by action scripts", result.diagnostics)

    def test_ambiguous_arity_uses_suffixed_name(self):
        body = [ir.ExtCall(0, ()), ir.ExtCall(0, (addr(3),)), ir.Print((var(3),))]
        result = emit_text(function(0x40, body, slots=ints(3), programs=[1])).text
        self.assertIn("\taction.InitScript_0()\n", result)
        self.assertIn("\tvar3 = action.InitScript_1() or var3\n", result)

    def test_handler_rejects_comment(self):
        body = [ir.ExtCall(30, tuple(const(i) for i in range(5)))]
        result = emit_text(function(0x40, body, programs=[1])).text
        self.assertIn("\taction.Ext(30, 0, 1, 2, 3, 4) -- retail: the handler rejects 5 arguments\n", result)

    def test_reference_where_the_handler_reads_a_value_is_refused(self):
        # The PC interpreter would read the low bits of the variable's address, so the script stays on it.
        body = [ir.ExtCall(30, (addr(3), const(b"x", ir.STR)))]
        with self.assertRaisesRegex(EmitError, "reference the handler reads as a value"):
            emit_text(function(0x40, body, slots=ints(3), programs=[1]))

    def test_number_where_handler_reads_string_is_refused(self):
        body = [ir.ExtCall(30, (const(1), const(2)))]
        with self.assertRaisesRegex(EmitError, "argument 2 is a number where the handler reads a string"):
            emit_text(function(0x40, body, programs=[1]))

    def test_string_where_handler_reads_number_is_refused(self):
        body = [ir.ExtCall(30, (const(b"x", ir.STR), const(b"y", ir.STR)))]
        with self.assertRaisesRegex(EmitError, "argument 1 is a string where the handler reads a number"):
            emit_text(function(0x40, body, programs=[1]))

    def test_output_is_reinterpreted_as_the_script_reads_it(self):
        # ProgGet writes an integer; the script reads its variable as a float, which reads the integer's bits.
        slots = {("local", 3): ir.FLOAT}
        call = ir.ExtCall(2, (addr(3, ir.FLOAT),), tags=(("ref", ("int",), ("float",)),))
        result = emit_text(function(0x40, [call, ir.Print((var(3, ir.FLOAT),))], slots=slots, programs=[1])).text
        self.assertIn("\tprog = vm.bits_float(action.ProgGet()) or prog\n", result)

    def test_output_read_both_ways_is_refused(self):
        call = ir.ExtCall(2, (addr(3),), tags=(("ref", ("int",), ("float", "int")),))
        with self.assertRaisesRegex(EmitError, "reads what argument 1 receives as float and int"):
            emit_text(function(0x40, [call, ir.Print((var(3),))], slots=ints(3), programs=[1]))

    def test_tagged_output_follows_the_destination_tag(self):
        # VPop on an integer-tagged variable read as a float: the variant follows the tag, the bits are reinterpreted.
        slots = {("local", 3): ir.FLOAT}
        call = ir.ExtCall(61, (const(1), addr(3, ir.FLOAT)), tags=(("value", ("int",)), ("ref", ("int",), ("float",))))
        result = emit_text(function(0x40, [call, ir.Print((var(3, ir.FLOAT),))], slots=slots, programs=[1])).text
        self.assertIn("\tvalue = vm.bits_float(action.VPop(1)) or value\n", result)
        mixed = ir.ExtCall(61, (const(1), addr(3, ir.FLOAT)), tags=(("value", ("int",)), ("ref", ("float", "int"), ("float",))))
        with self.assertRaisesRegex(EmitError, "may be float or int"):
            emit_text(function(0x40, [mixed, ir.Print((var(3, ir.FLOAT),))], slots=slots, programs=[1]))

    def test_tagged_command_takes_the_variant_of_its_argument_type(self):
        slots = {("local", 3): ir.FLOAT, ("local", 4): ir.INT}
        body = [
            ir.ExtCall(60, (const(1), var(3, ir.FLOAT))),
            ir.ExtCall(60, (const(2), var(4))),
            ir.ExtCall(61, (const(1), addr(3, ir.FLOAT))),
            ir.ExtCall(61, (const(2), addr(4))),
            ir.Print((var(3, ir.FLOAT), var(4))),
        ]
        result = emit_text(function(0x40, body, slots=slots, programs=[1])).text
        self.assertIn("\taction.VPushFloat(1, value)\n", result)
        self.assertIn("\taction.VPush(2, value_2)\n", result)
        self.assertIn("\tvalue = action.VPopFloat(1) or value\n", result)
        self.assertIn("\tvalue_2 = action.VPop(2) or value_2\n", result)

    def test_inout_reference_passes_the_value_and_assigns_the_result(self):
        catalog = {"kinds": {"action": {**CATALOG["kinds"]["action"], "commands": [{
            "no": 7, "luau": "AngleLimit",
            "signatures": [{"argc": 1, "params": [{"name": "angle", "dir": "inout", "type": "f32"}]}],
        }]}}}
        body = [ir.ExtCall(7, (addr(3, ir.FLOAT),)), ir.Print((var(3, ir.FLOAT),))]
        result = emit(module(function(0x40, body, slots={("local", 3): ir.FLOAT}, programs=[1])), catalog).text
        self.assertIn("\tangle = action.AngleLimit(angle) or angle\n", result)
        # An integer variable passes its bits as a float and reads back the bits of the float written into it.
        body = [ir.ExtCall(7, (addr(3),)), ir.Print((var(3),))]
        result = emit(module(function(0x40, body, slots=ints(3), programs=[1])), catalog).text
        self.assertIn("\tangle = vm.float_bits(action.AngleLimit(vm.bits_float(angle) :: number)) or angle\n", result)

    def test_reference_as_tagged_stored_value_does_nothing(self):
        body = [ir.ExtCall(60, (const(1), addr(3)))]
        result = emit_text(function(0x40, body, programs=[1]))
        self.assertIn(
            "\t-- retail: action.VPush(1, var3) does nothing, since its handler stores only an integer or a float\n",
            result.text,
        )
        self.assertNotIn("local var3", result.text)
        self.assertIn("reference passed as the value VPush stores", result.diagnostics)

    def test_temp_is_declared_at_its_assignment(self):
        body = [ir.Assign(ir.Temp(0, ir.INT), const(2)), ir.Print((ir.Temp(0, ir.INT),))]
        result = emit_text(function(0x40, body, temps=[ir.INT], programs=[1])).text
        self.assertIn("\tlocal t0 = 2\n\tprint(t0)\n", result)

    def test_integer_bits_stored_into_float_variable(self):
        body = [ir.Assign(("local", 3), const(0x3F800000)), ir.Print((var(3, ir.FLOAT),))]
        result = emit_text(function(0x40, body, slots={("local", 3): ir.FLOAT}, programs=[1]))
        self.assertIn("\tvar3 = 1.0 -- retail: integer bits read as a float\n", result.text)

    def test_reference_parameter_is_copied_in_and_back(self):
        caller = main_function([ir.CallStmt(ir.Call(0x30, (addr(2),), ir.INT)), ir.Print((var(2),))], slots=ints(2))
        text = emit_text(bump(), caller).text
        self.assertIn("local function helper_30(arg0: s32)\n\targ0 = arg0 + 1\n\treturn arg0\nend\n", text)
        self.assertIn("\tvar2 = helper_30(var2)\n\tprint(var2)\n", text)

    def test_used_result_comes_back_before_the_references(self):
        caller = main_function(
            [ir.Assign(ir.Temp(0, ir.INT), ir.Call(0x30, (addr(2),), ir.INT)), ir.Print((ir.Temp(0, ir.INT), var(2)))],
            slots=ints(2),
            temps=[ir.INT],
        )
        text = emit_text(bump(const(7)), caller).text
        self.assertIn("\treturn 7, arg0\n", text)
        self.assertIn("\tlocal t0: s32\n\tt0, var2 = helper_30(var2)\n\tprint(t0, var2)\n", text)

    def test_probed_call_reports_its_references(self):
        caller = main_function([ir.CallStmt(ir.Call(0x30, (addr(2),), ir.INT, 0x120)), ir.Print((var(2),))], slots=ints(2))
        result = emit(module(bump(), caller, probe=True), CATALOG)
        self.assertIn("\tvar2 = helper_30(var2)\n\t__ref(288, var2)\n", result.text)
        self.assertEqual(result.probes, [0x120])

    def test_reference_call_in_an_expression_is_rejected(self):
        caller = main_function([ir.Print((ir.Call(0x30, (addr(2),), ir.INT),))], slots=ints(2))
        with self.assertRaises(EmitError):
            emit_text(bump(), caller)

    def test_array_is_a_table_from_one(self):
        body = [
            ir.Assign(ir.Elem(ARRAY, var(0), ir.FLOAT), const(2.5, ir.FLOAT)),
            ir.Assign(ir.Elem(ARRAY, ir.Binary("sub", var(0), const(1), ir.INT), ir.FLOAT), const(1.5, ir.FLOAT)),
            ir.Print((ir.Elem(ARRAY, const(2), ir.FLOAT),)),
        ]
        slots = {**ints(0), ARRAY: ir.FLOAT}
        result = emit_text(function(ANY_BLOCK, body, slots=slots, main=True, arrays={ARRAY: 3})).text
        self.assertIn("\tlocal var1: { f32 } = table.create(3, 0)\n", result)
        self.assertIn("\tvar1[var0 + 1] = 2.5\n", result)
        self.assertIn("\tvar1[var0] = 1.5\n", result)
        self.assertIn("\tprint(var1[3])\n", result)
        self.assertNotIn("vm.", result)

    def test_output_into_an_array_element(self):
        body = [ir.ExtCall(2, (ir.Addr(ARRAY, ir.INT, var(0)),)), ir.Print((ir.Elem(ARRAY, const(0), ir.INT),))]
        slots = {**ints(0), ARRAY: ir.INT}
        text = emit_text(function(ANY_BLOCK, body, slots=slots, main=True, arrays={ARRAY: 2})).text
        self.assertIn("\tvar1[var0 + 1] = action.ProgGet() or var1[var0 + 1]\n", text)

    def test_frame_table_checks_computed_indices(self):
        index = ir.Binary("add", ir.Elem(FRAME, const(0), ir.INT), const(1), ir.INT)
        body = [ir.Assign(ir.Elem(FRAME, index, ir.INT), const(7)), ir.Return(ir.Elem(FRAME, const(2), ir.INT))]
        helper = function(0x30, body, arg=1, slots={FRAME: ir.INT, **ints(0)}, arrays={FRAME: 4})
        caller = main_function([ir.Print((ir.Call(0x30, (const(1),), ir.INT),))])
        text = emit_text(helper, caller).text
        self.assertIn("\t-- retail: a computed index here may leave its array", text)
        self.assertIn("\tlocal frame: { s32 } = table.create(4, 0)\n\tframe[1] = arg0\n", text)
        self.assertIn("\tframe[vm.index(frame[1] + 1, 4)] = 7\n\treturn frame[3]\n", text)
        self.assertIn('local vm = require("@lib/vm")', text)

    def test_reference_parameter_in_a_frame_comes_back_from_the_table(self):
        body = [ir.Assign(ir.Elem(FRAME, const(0), ir.INT), const(3)), ir.Return(const(0))]
        helper = function(0x30, body, arg=1, slots={FRAME: ir.INT, **ints(0)}, refs=(0,), arrays={FRAME: 2})
        caller = main_function([ir.CallStmt(ir.Call(0x30, (addr(2),), ir.INT)), ir.Print((var(2),))], slots=ints(2))
        text = emit_text(helper, caller).text
        self.assertIn("\tframe[1] = 3\n\treturn frame[1]\n", text)

    def test_output_past_the_frame_is_lost(self):
        body = [
            ir.ExtCall(53, (addr(4, ir.FLOAT), addr(5, ir.FLOAT), ir.Addr(("stack", 9), ir.FLOAT))),
            ir.Print((var(4, ir.FLOAT), var(5, ir.FLOAT))),
        ]
        result = emit_text(main_function(body, slots={("local", 4): ir.FLOAT, ("local", 5): ir.FLOAT}))
        self.assertIn(
            "\t\tlocal out1, out2, _ = action.GetPos() -- retail: output 3 points past the frame, at the operand stack, "
            "so the value is lost\n",
            result.text,
        )
        self.assertIn("output written past the frame", result.diagnostics)

    def test_dropped_return_value_declares_nothing(self):
        helper = function(0x30, [ir.ExtCall(2, (addr(0),)), ir.Return(var(0))], slots=ints(0))
        caller = main_function([ir.CallStmt(ir.Call(0x30, (), ir.INT))])
        text = emit_text(helper, caller).text
        self.assertIn("local function helper_30()\n\taction.ProgGet()\nend\n", text)

    def test_repeated_condition_stays_a_nested_if(self):
        cond = ir.Compare(opcodes.Compare.EQ, var(0), const(1))
        body = [ir.If(cond, [ir.Print((const(1),))], [ir.If(cond, [ir.Print((const(2),))], [])])]
        text = emit_text(main_function(body, slots=ints(0))).text
        self.assertIn(
            "\telse\n\t\t-- retail: the script tests this condition again, so its branch never runs\n"
            "\t\tif var0 == 1 then\n\t\t\tprint(2)\n\t\tend\n\tend\n",
            text,
        )
        self.assertNotIn("elseif", text)

    def test_float_division_by_a_variable_checks_for_zero(self):
        slots = {("local", n): ir.FLOAT for n in range(3)}
        body = [
            ir.Assign(("local", 1), ir.Binary("div", var(0, ir.FLOAT), var(2, ir.FLOAT), ir.FLOAT)),
            ir.Assign(("local", 2), ir.Binary("div", var(1, ir.FLOAT), const(2.0, ir.FLOAT), ir.FLOAT)),
            ir.Print((var(2, ir.FLOAT),)),
        ]
        text = emit_text(main_function(body, slots=slots)).text
        self.assertIn("\tvar1 = vm.f32(vm.fdiv(var0, var2))\n", text)
        self.assertIn("\tvar2 = vm.f32(var1 / 2.0)\n", text)

    def test_integer_constant_for_a_float_parameter_passes_its_bits(self):
        helper = function(0x30, [ir.Print((var(0, ir.FLOAT),))], arg=1, slots={("local", 0): ir.FLOAT})
        caller = main_function([ir.CallStmt(ir.Call(0x30, (const(0x3F800000),), ir.INT))])
        text = emit_text(helper, caller).text
        self.assertIn(
            "\thelper_30(1.0) -- retail: the integer 1065353216 is passed where the callee reads a float, so it reads "
            "its bits\n",
            text,
        )

    def test_integer_value_stored_into_a_float_variable_is_rejected(self):
        # The script loads the variable as a float, which reads the bits of an integer its helper returned.
        helper = function(0x30, [ir.Return(const(1065353216))])
        body = [ir.Assign(("local", 0), ir.Call(0x30, (), ir.INT)), ir.Print((var(0, ir.FLOAT),))]
        caller = main_function(body, slots={("local", 0): ir.FLOAT})
        with self.assertRaisesRegex(EmitError, "may be an integer is stored into float variable"):
            emit_text(helper, caller)

    def test_float_arithmetic_stored_into_a_float_variable_is_accepted(self):
        value = ir.Binary("mul", var(1, ir.ANY), const(0.5, ir.FLOAT), ir.ANY)
        body = [ir.Assign(("local", 0), value), ir.Print((var(0, ir.FLOAT),))]
        text = emit_text(main_function(body, slots={("local", 0): ir.FLOAT, ("local", 1): ir.ANY})).text
        self.assertIn("\tvar0 = var1 * 0.5\n", text)

    def test_integer_variable_passed_to_a_float_parameter_is_rejected(self):
        helper = function(0x30, [ir.Print((var(0, ir.FLOAT),))], arg=1, slots={("local", 0): ir.FLOAT})
        caller = main_function([ir.CallStmt(ir.Call(0x30, (var(1),), ir.INT))], slots=ints(1))
        with self.assertRaisesRegex(EmitError, "passed to parameter 0 of helper_30, which the callee loads as a float"):
            emit_text(helper, caller)

    def test_float_variable_passed_to_an_integer_reference_is_rejected(self):
        # bump stores an integer through its reference, whose bits the caller's float loads would read.
        caller = main_function([ir.CallStmt(ir.Call(0x30, (addr(0, ir.FLOAT),), ir.INT))], slots={("local", 0): ir.FLOAT})
        with self.assertRaisesRegex(EmitError, "may store an integer there"):
            emit_text(bump(), caller)

    def test_float_condition_is_always_true(self):
        body = [ir.If(var(3, ir.FLOAT), [ir.Print((const(1),))], [])]
        result = emit_text(function(0x40, body, slots={("local", 3): ir.FLOAT}, programs=[1]))
        self.assertIn("\tif true then\n", result.text)
        self.assertIn("condition on a float/string value is always true", result.diagnostics)

    def test_expose_globals(self):
        result = emit_text(
            main_function([ir.Assign(("global", 0), const(3))]),
            globals_={("global", 0): ir.INT},
            expose=True,
        ).text
        self.assertIn("local global0: s32 = 0\n", result)
        self.assertIn("\tglobal0 = 3\n", result)
        self.assertIn("script.__globals = function() return { global0 } end\n", result)

    def test_end_statement_is_rejected(self):
        with self.assertRaisesRegex(EmitError, "end opcode unsupported"):
            emit_text(main_function([ir.End()]))

    def test_integer_operations_that_may_overflow_wrap(self):
        body = [
            ir.Assign(("local", 0), ir.Binary("add", var(0), const(1), ir.INT, wrap=True)),
            ir.Assign(("local", 1), ir.Binary("sub", var(1), var(0), ir.INT, wrap=True)),
            ir.Assign(("local", 2), ir.Binary("mul", var(2), const(3), ir.INT, wrap=True)),
            ir.Assign(("local", 3), ir.Unary("neg", var(3), ir.INT, wrap=True)),
            ir.Assign(("local", 4), ir.Binary("add", var(4), const(1), ir.INT)),
            ir.Print((var(0), var(1), var(2), var(3), var(4))),
        ]
        text = emit_text(main_function(body, slots=ints(0, 1, 2, 3, 4))).text
        self.assertIn("\tvar0 = vm.i32(var0 + 1)\n", text)
        self.assertIn("\tvar1 = vm.i32(var1 - var0)\n", text)
        self.assertIn("\tvar2 = vm.i32(var2 * 3)\n", text)
        self.assertIn("\tvar3 = vm.i32(-var3)\n", text)
        self.assertIn("\tvar4 = var4 + 1\n", text)

    def test_precedence_parenthesises_only_when_needed(self):
        expr = ir.Binary("mul", ir.Binary("add", var(3), const(1), ir.INT), const(2), ir.INT)
        body = [
            ir.Assign(("local", 4), expr),
            ir.Print((var(4), ir.Unary("neg", ir.Binary("sub", var(3), const(1), ir.INT), ir.INT))),
        ]
        result = emit_text(function(0x40, body, slots=ints(3, 4), programs=[1])).text
        self.assertIn("\tvar4 = (var3 + 1) * 2\n", result)
        self.assertIn("\tprint(var4, -(var3 - 1))\n", result)

    def test_complex_module(self):
        helper = function(
            0x78,
            [
                ir.If(
                    ir.Compare(opcodes.Compare.LT, var(0), const(0)),
                    [ir.Return(ir.Unary("neg", var(0), ir.INT))],
                    [],
                ),
                ir.Return(var(0)),
            ],
            arg=1,
            slots=ints(0),
        )
        program = function(
            0x40,
            [
                ir.ExtCall(2, (addr(3),)),
                ir.ExtCall(53, (addr(4, ir.FLOAT), addr(5, ir.FLOAT), addr(6, ir.FLOAT))),
                ir.Assign(("local", 7), ir.Call(0x78, (var(3),), ir.INT)),
                ir.NumericFor(("local", 8), const(0), var(7), const(1), [ir.Print((var(8),))]),
                ir.Wait(),
                ir.Return(const(0)),
            ],
            slots={**ints(3, 7, 8), ("local", 4): ir.FLOAT, ("local", 5): ir.FLOAT, ("local", 6): ir.FLOAT},
            programs=[100],
        )
        result = emit_text(helper, program, globals_={("global", 0): ir.INT}, expose=True)
        self.assertIn('local vm = require("@lib/vm")', result.text)
        self.assertIn("local global0", result.text)
        self.assertIn("\tlocal prog: s32 = 0\n", result.text)
        self.assertIn("\tprog = action.ProgGet() or prog\n", result.text)
        self.assertIn("\tvar7 = helper_78(prog)\n", result.text)
        self.assertIn("\t\treturn -arg0\n", result.text)
        self.assertIn("function script.init()\n", result.text)
        self.assertNotIn("program_100", result.text)


if __name__ == "__main__":
    unittest.main()
