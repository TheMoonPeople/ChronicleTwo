"""Audit pointer narrowing in the compiled, port-owned native runtime.

Uses the native target's compile_commands.json and libclang to find pointer-to-integer
casts, pointer round trips, and explicit address-alias constants. --check also
compares the generated report and rejects linked pointer round trips or counted
narrowing sites without a reviewed owner.
"""

import argparse
import collections
import functools
import glob
import json
import multiprocessing
import os
import re
import shlex
import subprocess
import sys
from pathlib import Path

try:
    from .ownership_audit import owned_file, owned_roots
except ImportError:
    from ownership_audit import owned_file, owned_roots


ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
OWNED_PREFIXES = ()

ci = None

# Functions and fields whose pointers point into the game's mgCMemory buffers (ps2/include/mg_memory.hpp).
ARENA_CALLS = {"Alloc", "stAlloc", "stAlloc64", "stAllocTest", "stGetTop", "StartStackMode", "mgCopyString"}
ARENA_FIELDS = {"heap", "heap_top", "stack", "stack_bytes", "stack_block"}

# The PS2's address aliases: 0x0FFFFFFF keeps the physical address, 0x20000000 selects the uncached alias.
ADDRESS_MASKS = {0x0FFFFFFF, 0x20000000}
ADDRESS_MASK_TEXT = re.compile(r"0x0*(?:FFFFFFF|20000000)\b", re.IGNORECASE)
TRUNCATING_CAST_TEXT = re.compile(r"\(\s*(?:u_int|int|s32|u32|unsigned\s+int|signed\s+int)\s*\)")

# Reviewed exceptions for linked pointer narrowing. These must refer to native paths.
NARROWING_OWNER = {}

BINARY_OPERATOR_NAMES = {
    "=": "Assign", "+": "Add", "-": "Sub", "*": "Mul", "/": "Div", "%": "Rem", "&": "And", "|": "Or", "^": "Xor",
    "<<": "Shl", ">>": "Shr", "<": "LT", ">": "GT", "<=": "LE", ">=": "GE", "==": "EQ", "!=": "NE",
    "&&": "LAnd", "||": "LOr", ",": "Comma",
}
POINTER_WIDE_NAMES = ("uptr", "sptr")
COMPARE_OPS = ("LT", "GT", "LE", "GE", "EQ", "NE")
ARITHMETIC_OPS = ("Add", "Sub", "Mul", "Div", "Rem", "And", "Or", "Xor", "Shl", "Shr")
WORKLIST_HEADER = "file\tline\tcol\tfunction\tstate\tkind\tdestination\tclass\texpression"
EXAMPLE_LIMIT = 20
LOW_BITS_LIMIT = 0xFFFFFFFF


def load_libclang(explicit):
    global ci
    import clang.cindex as cindex

    ci = cindex
    candidates = [explicit, os.environ.get("LIBCLANG")]
    try:
        libdir = subprocess.run(["llvm-config", "--libdir"], capture_output=True, text=True).stdout.strip()
        candidates += glob.glob(os.path.join(libdir, "libclang*.so*")) if libdir else []
    except OSError:
        pass
    candidates += sorted(glob.glob("/usr/lib/llvm-*/lib/libclang-*.so*"), reverse=True)
    candidates += ["/opt/homebrew/opt/llvm/lib/libclang.dylib", "/usr/local/opt/llvm/lib/libclang.dylib"]
    for candidate in candidates:
        if candidate and os.path.exists(candidate):
            try:
                cindex.Config.set_library_file(candidate)
                cindex.Index.create()
                return
            except Exception:
                cindex.Config.loaded = False
    cindex.Index.create()  # the bundled library of `pip install libclang`


def canon(path):
    # realpath stats every component, which on a network or container mount costs milliseconds per call and
    # dominated the run. Paths here are compile-command or repo paths, so lexical normalisation is enough.
    return os.path.normpath(os.path.abspath(path))


def set_mirrors(build):
    # Kept for records.py callers; native source paths are never rewritten to PS2 paths.
    return None


def rel(path):
    path = canon(path)
    # Report paths consistently on Windows and POSIX hosts.
    return os.path.relpath(path, ROOT).replace(os.sep, "/") if path.startswith(ROOT + os.sep) else path


def ours(path):
    return path is not None and owned_file(str(path), Path(ROOT), OWNED_PREFIXES) is not None


def is_cast(cursor):
    K = ci.CursorKind
    return cursor.kind in (K.CSTYLE_CAST_EXPR, K.CXX_STATIC_CAST_EXPR, K.CXX_REINTERPRET_CAST_EXPR,
                           K.CXX_FUNCTIONAL_CAST_EXPR)


def pointerish(type_):
    T = ci.TypeKind
    kind = type_.get_canonical().kind
    return kind in (T.POINTER, T.CONSTANTARRAY, T.INCOMPLETEARRAY, T.VARIABLEARRAY, T.DEPENDENTSIZEDARRAY,
                    T.FUNCTIONPROTO, T.FUNCTIONNOPROTO, T.NULLPTR)


def integral(type_):
    T = ci.TypeKind
    canonical = type_.get_canonical()
    if canonical.kind == T.ENUM:
        return True
    return canonical.kind in (T.CHAR_U, T.UCHAR, T.CHAR16, T.CHAR32, T.USHORT, T.UINT, T.ULONG, T.ULONGLONG,
                              T.CHAR_S, T.SCHAR, T.WCHAR, T.SHORT, T.INT, T.LONG, T.LONGLONG, T.BOOL)


def narrow(type_):
    return integral(type_) and 0 < type_.get_canonical().get_size() < 8


def operand(cast):
    children = [c for c in cast.get_children() if c.kind != ci.CursorKind.TYPE_REF and
                not c.kind.is_reference() and c.kind != ci.CursorKind.NAMESPACE_REF]
    exprs = [c for c in children if c.kind.is_expression()]
    return exprs[-1] if exprs else None


def peel(cursor):
    K = ci.CursorKind
    while cursor is not None and cursor.kind in (K.PAREN_EXPR, K.UNEXPOSED_EXPR):
        children = list(cursor.get_children())
        if len(children) != 1:
            break
        cursor = children[0]
    return cursor


def text(cursor, limit=120):
    tokens = [t.spelling for t in cursor.get_tokens()]
    joined = " ".join(tokens)
    joined = re.sub(r" ?([()\[\],.;]) ?", r"\1", joined).replace("-> ", "->").replace(" ->", "->")
    return joined if len(joined) <= limit else joined[: limit - 3] + "..."


def unary_op(cursor):
    tokens = [t.spelling for t in cursor.get_tokens()]
    return tokens[0] if tokens else ""


def binop(cursor):
    try:
        return cursor.binary_operator.name
    except Exception:
        # Bindings older than libclang 19 lack Cursor.binary_operator; the operator token is the same fact.
        return BINARY_OPERATOR_NAMES.get(operator_token(cursor), "Unknown")


def address_mask(cursor):
    """The address-alias literal an operand is, as text, or None."""
    cursor = peel(cursor)
    if cursor is None or cursor.kind != ci.CursorKind.INTEGER_LITERAL:
        return None
    tokens = [t.spelling for t in cursor.get_tokens()]
    if not tokens:
        return None
    try:
        value = int(tokens[0].rstrip("uUlL"), 0)
    except ValueError:
        return None
    return "0x%08X" % value if value in ADDRESS_MASKS else None


def is_global_var(decl):
    K = ci.CursorKind
    if decl.kind != K.VAR_DECL:
        return False
    if decl.storage_class in (ci.StorageClass.STATIC, ci.StorageClass.EXTERN):
        return True
    parent = decl.semantic_parent
    return parent is not None and parent.kind in (K.TRANSLATION_UNIT, K.NAMESPACE, K.STRUCT_DECL,
                                                   K.CLASS_DECL, K.LINKAGE_SPEC)


def origin(cursor, depth=0):
    """Where the pointer the cursor evaluates to points."""
    K = ci.CursorKind
    cursor = peel(cursor)
    if cursor is None or depth > 4:
        return "unknown"
    kind = cursor.kind
    if kind == K.STRING_LITERAL:
        return "image (literal)"
    if kind == K.CXX_THIS_EXPR:
        return "this"
    if is_cast(cursor):
        inner = operand(cursor)
        return origin(inner, depth + 1) if inner is not None and pointerish(inner.type) else "integer"
    if kind == K.UNARY_OPERATOR and unary_op(cursor) == "&":
        inner = [c for c in cursor.get_children()]
        return address_of(inner[0], depth) if inner else "unknown"
    if kind == K.BINARY_OPERATOR and binop(cursor) in ("Add", "Sub"):
        for child in cursor.get_children():
            if pointerish(child.type):
                return origin(child, depth + 1)
    if kind == K.ARRAY_SUBSCRIPT_EXPR:
        # An element that is itself a pointer was loaded from memory; an array row decays in place.
        if cursor.type.get_canonical().kind == ci.TypeKind.POINTER:
            return "field"
        return origin(next(cursor.get_children()), depth + 1)
    if kind == K.UNARY_OPERATOR and unary_op(cursor) == "*":
        return "field"
    if kind == K.CONDITIONAL_OPERATOR:
        parts = list(cursor.get_children())[1:]
        kinds = {origin(p, depth + 1) for p in parts}
        return kinds.pop() if len(kinds) == 1 else "mixed"
    if kind == K.CALL_EXPR:
        name = cursor.spelling or "?"
        return "arena (%s)" % name if name in ARENA_CALLS else "call (%s)" % name
    if kind == K.DECL_REF_EXPR:
        decl = cursor.referenced
        if decl is None:
            return "unknown"
        if decl.kind == K.FUNCTION_DECL or decl.kind == K.CXX_METHOD:
            return "image (function)"
        if decl.kind == K.PARM_DECL:
            return "parameter"
        if decl.kind == K.VAR_DECL:
            array = decl.type.get_canonical().kind in (ci.TypeKind.CONSTANTARRAY, ci.TypeKind.INCOMPLETEARRAY)
            if decl.spelling in ARENA_FIELDS:
                return "arena (%s)" % decl.spelling
            if is_global_var(decl):
                return "image" if array else "global pointer"
            if array:
                return "stack"
            init = [c for c in decl.get_children() if c.kind.is_expression()]
            if init:
                inner = origin(init[-1], depth + 1)
                return inner if inner != "unknown" else "local pointer"
            return "local pointer"
        return "unknown"
    if kind == K.MEMBER_REF_EXPR:
        decl = cursor.referenced
        if (decl is not None and decl.spelling in ARENA_FIELDS) or cursor.spelling in ARENA_FIELDS:
            return "arena (%s)" % cursor.spelling
        if decl is not None and decl.type.get_canonical().kind in (ci.TypeKind.CONSTANTARRAY,):
            children = list(cursor.get_children())
            return "member array of " + (origin_of_object(children[0], depth) if children else "this")
        return "field"
    return "unknown"


def origin_of_object(cursor, depth):
    """Where an object expression (the left of a member access) lives."""
    cursor = peel(cursor)
    K = ci.CursorKind
    if cursor is None:
        return "unknown"
    if cursor.kind == K.DECL_REF_EXPR and cursor.referenced is not None:
        decl = cursor.referenced
        if decl.kind == K.VAR_DECL:
            if pointerish(decl.type):
                return origin(cursor, depth + 1)
            return "image" if is_global_var(decl) else "stack"
        if decl.kind == K.PARM_DECL:
            return "parameter"
    if cursor.kind == K.CXX_THIS_EXPR:
        return "this"
    return origin(cursor, depth + 1)


def address_of(cursor, depth):
    K = ci.CursorKind
    cursor = peel(cursor)
    if cursor is None:
        return "unknown"
    if cursor.kind == K.DECL_REF_EXPR and cursor.referenced is not None:
        decl = cursor.referenced
        if decl.kind in (K.FUNCTION_DECL, K.CXX_METHOD):
            return "image (function)"
        if decl.kind == K.VAR_DECL:
            if decl.spelling in ARENA_FIELDS:
                return "image (%s)" % decl.spelling
            return "image" if is_global_var(decl) else "stack"
        if decl.kind == K.PARM_DECL:
            return "stack (parameter)"
    if cursor.kind == K.ARRAY_SUBSCRIPT_EXPR:
        return origin(next(cursor.get_children()), depth + 1)
    if cursor.kind == K.MEMBER_REF_EXPR:
        children = list(cursor.get_children())
        if not children:
            return "this"
        base = peel(children[0])
        if base is not None and pointerish(base.type):
            return origin(base, depth + 1)
        return origin_of_object(base, depth)
    if cursor.kind == K.UNARY_OPERATOR and unary_op(cursor) == "*":
        return origin(next(cursor.get_children()), depth + 1)
    return "unknown"


def refs(cursor):
    """USRs of the integer-typed variables, fields and calls an expression reads."""
    K = ci.CursorKind
    found = set()
    stack = [cursor]
    while stack:
        node = stack.pop()
        if node.kind in (K.DECL_REF_EXPR, K.MEMBER_REF_EXPR):
            decl = node.referenced
            if decl is not None and decl.kind in (K.VAR_DECL, K.PARM_DECL, K.FIELD_DECL) and integral(decl.type):
                usr = decl.get_usr()
                if usr:
                    found.add(usr)
        elif node.kind == K.CALL_EXPR:
            decl = node.referenced
            if decl is not None and integral(node.type):
                usr = decl.get_usr()
                if usr:
                    found.add("ret:" + usr)
        stack.extend(node.get_children())
    return found


def target_of(cursor):
    """The USR an assignment's left side names, or None for memory the tool cannot follow."""
    K = ci.CursorKind
    cursor = peel(cursor)
    if cursor is None:
        return None
    if cursor.kind in (K.DECL_REF_EXPR, K.MEMBER_REF_EXPR):
        decl = cursor.referenced
        if decl is not None and decl.kind in (K.VAR_DECL, K.PARM_DECL, K.FIELD_DECL):
            return decl.get_usr() or None
    if cursor.kind == K.ARRAY_SUBSCRIPT_EXPR:
        base = peel(next(cursor.get_children()))
        if base is not None and base.kind in (K.DECL_REF_EXPR, K.MEMBER_REF_EXPR):
            decl = base.referenced
            if decl is not None and decl.type.get_canonical().kind == ci.TypeKind.CONSTANTARRAY:
                return decl.get_usr() or None
    return None


def callee_param(call, argument):
    decl = call.referenced
    if decl is None:
        return None, call.spelling
    args = list(call.get_arguments())
    index = next((i for i, a in enumerate(args) if a == argument), None)
    params = list(decl.get_arguments()) if decl.kind in (ci.CursorKind.FUNCTION_DECL, ci.CursorKind.CXX_METHOD,
                                                         ci.CursorKind.CONSTRUCTOR) else []
    if index is None or index >= len(params):
        return None, decl.spelling
    return params[index].get_usr() or None, decl.spelling


def contains_truncation(cursor):
    stack = [cursor]
    while stack:
        node = stack.pop()
        if is_cast(node) and narrow(node.type):
            inner = operand(node)
            if inner is not None and pointerish(inner.type):
                return True
        stack.extend(node.get_children())
    return False


def narrowed_later(ancestors):
    """A pointer cast to a full-width integer that an implicit conversion then narrows."""
    K = ci.CursorKind
    for parent in reversed(ancestors):
        if parent.kind in (K.PAREN_EXPR, K.UNEXPOSED_EXPR) or is_cast(parent) or (
                parent.kind == K.BINARY_OPERATOR and binop(parent) in ("Add", "Sub", "And", "Or", "Xor", "Shr",
                                                                        "Shl", "Rem", "Mul", "Div")):
            if integral(parent.type) and narrow(parent.type):
                return True
            if not integral(parent.type):
                return False
            continue
        if parent.kind == K.VAR_DECL or (parent.kind == K.BINARY_OPERATOR and binop(parent) == "Assign"):
            return narrow(parent.type)
        return False
    return False


def context(cast, ancestors, function_usr, ops):
    """Where the truncated value goes: (kind, detail, usr or None); ops collects the operators on the way."""
    K = ci.CursorKind
    node = cast
    for parent in reversed(ancestors):
        kind = parent.kind
        if kind in (K.PAREN_EXPR, K.UNEXPOSED_EXPR):
            node = parent
            continue
        if is_cast(parent):
            if pointerish(parent.type):
                return "cast back", text(parent, 60), None
            if integral(parent.type):
                node = parent
                continue
            return "converted", parent.type.spelling, None
        if kind == K.BINARY_OPERATOR:
            op = binop(parent)
            children = list(parent.get_children())
            other = children[1] if children and children[0] == node else (children[0] if children else None)
            if op in ("Add", "Sub") and other is not None and pointerish(other.type):
                return "pointer offset", text(parent, 60), None
            if op == "Sub" and other is not None and contains_truncation(other):
                return "difference", "", None
            if op in ("And", "Or"):
                mask = address_mask(other)
                if mask is not None:
                    ops.append("mask " + mask)
            if op in ("And", "Rem", "Shr", "Shl"):
                ops.append(op)
                node = parent
                continue
            if op in ("Add", "Sub", "Or", "Xor", "Mul", "Div"):
                ops.append(op)
                node = parent
                continue
            if op in ("LT", "GT", "LE", "GE", "EQ", "NE"):
                if other is not None and contains_truncation(other):
                    return "compare truncated", op, None
                return "compare", op, None
            if op in ("LAnd", "LOr"):
                return "test", "", None
            if op == "Assign":
                if children and children[0] == node:
                    return "other", "assigned to", None
                usr = target_of(children[0])
                return ("store", text(children[0], 60), usr) if usr else ("store to memory", text(children[0], 60), None)
            if op == "Comma":
                return "discarded", "", None
            return "other", op, None
        if kind == K.COMPOUND_ASSIGNMENT_OPERATOR:
            children = list(parent.get_children())
            if children and pointerish(children[0].type):
                return "pointer offset", text(parent, 60), None
            usr = target_of(children[0]) if children else None
            return ("store", text(children[0], 60), usr) if usr else ("store to memory", text(parent, 60), None)
        if kind == K.ARRAY_SUBSCRIPT_EXPR:
            return "index", text(parent, 60), None
        if kind == K.VAR_DECL:
            return "store", parent.spelling, parent.get_usr() or None
        if kind == K.CALL_EXPR:
            usr, name = callee_param(parent, node)
            return ("argument", name, usr) if usr else ("argument to unknown", name or "?", None)
        if kind == K.RETURN_STMT:
            return "return", "", "ret:" + function_usr if function_usr else None
        if kind in (K.IF_STMT, K.WHILE_STMT, K.DO_STMT, K.FOR_STMT, K.SWITCH_STMT):
            return "test", "", None
        if kind == K.CONDITIONAL_OPERATOR:
            children = list(parent.get_children())
            if children and children[0] == node:
                return "test", "", None
            node = parent
            continue
        if kind == K.UNARY_OPERATOR:
            op = unary_op(parent)
            if op == "!":
                return "test", "", None
            node = parent
            continue
        if kind in (K.INIT_LIST_EXPR, K.CXX_CONSTRUCT_EXPR):
            return "store to memory", "initialiser", None
        if kind == K.COMPOUND_STMT:
            return "discarded", "", None
        return "other", str(kind).split(".")[-1], None
    return "other", "", None


FUNCTION_KINDS = None


def qualified(cursor):
    parts = []
    while cursor is not None and cursor.kind != ci.CursorKind.TRANSLATION_UNIT:
        if cursor.spelling:
            parts.append(cursor.spelling)
        cursor = cursor.semantic_parent
    return "::".join(reversed(parts))


def signature(function):
    """The function's qualified name and parameter types."""
    if function is None:
        return ""
    params = ",".join(argument.type.spelling for argument in function.get_arguments())
    return re.sub(r"\s+", "", qualified(function) + "(" + params + ")")


def pointwide(type_):
    current = type_
    while True:
        if re.sub(r"\b(?:const|volatile)\s+", "", current.spelling).strip() in POINTER_WIDE_NAMES:
            return True
        declaration = current.get_declaration()
        if declaration.kind != ci.CursorKind.TYPEDEF_DECL:
            return False
        current = declaration.underlying_typedef_type


def operator_token(binary):
    """The operator between a binary operator's two operands."""
    children = list(binary.get_children())
    if len(children) != 2:
        return ""
    low = children[0].extent.end.offset
    high = children[1].extent.start.offset
    for token in binary.get_tokens():
        if low <= token.extent.start.offset < high and token.spelling not in ("(", ")"):
            return token.spelling
    return ""


def variable_destination(decl):
    return ("global " if is_global_var(decl) else "local ") + decl.spelling


def field_destination(field):
    where = rel(field.location.file.name) if field.location.file is not None else "?"
    return "field %s::%s (%s:%d)" % (qualified(field.semantic_parent), field.spelling, where, field.location.line)


def lhs_destination(lhs):
    K = ci.CursorKind
    target = peel(lhs)
    if target is not None and target.kind in (K.MEMBER_REF_EXPR, K.DECL_REF_EXPR):
        decl = target.referenced
        if decl is not None:
            if decl.kind == K.FIELD_DECL:
                return field_destination(decl)
            if decl.kind == K.VAR_DECL:
                return variable_destination(decl)
            if decl.kind == K.PARM_DECL:
                return "local " + decl.spelling
    return "other (memory)"


def argument_destination(call, node):
    K = ci.CursorKind
    callee = call.referenced
    index = next((i for i, a in enumerate(call.get_arguments()) if a == node), None)
    if callee is None or index is None:
        return "other"
    name = qualified(callee)
    params = list(callee.get_arguments()) if callee.kind in (K.FUNCTION_DECL, K.CXX_METHOD, K.CONSTRUCTOR) else []
    if index < len(params):
        return "arg %s#%d (%s)" % (name, index, params[index].type.spelling)
    return "arg %s#%d (...)" % (name, index)


def destination(node, ancestors, function):
    K = ci.CursorKind
    for parent in reversed(ancestors):
        kind = parent.kind
        if kind in (K.PAREN_EXPR, K.UNEXPOSED_EXPR):
            node = parent
            continue
        if is_cast(parent):
            return "cast"
        if kind == K.VAR_DECL:
            return variable_destination(parent)
        if kind == K.FIELD_DECL:
            return field_destination(parent)
        if kind == K.BINARY_OPERATOR:
            children = list(parent.get_children())
            op = binop(parent)
            if op == "Assign" and children and children[0] != node:
                return lhs_destination(children[0])
            if op in COMPARE_OPS:
                return "compare"
            if op in ARITHMETIC_OPS:
                return ("arith " + operator_token(parent)).rstrip()
            return ("other " + operator_token(parent)).rstrip()
        if kind == K.COMPOUND_ASSIGNMENT_OPERATOR:
            children = list(parent.get_children())
            if children and children[0] != node:
                return lhs_destination(children[0])
            return "other"
        if kind == K.RETURN_STMT:
            if function is None:
                return "other"
            return "return %s (%s)" % (qualified(function), function.result_type.spelling)
        if kind == K.CALL_EXPR:
            return argument_destination(parent, node)
        if kind == K.CONDITIONAL_OPERATOR:
            children = list(parent.get_children())
            if not children or children[0] == node:
                return "other"
            node = parent
            continue
        if kind == K.UNARY_OPERATOR:
            op = unary_op(parent)
            return "arith " + op if op in ("-", "+", "~") else "other " + op
        return "other"
    return "other"


def constant_value(cursor):
    """The value of an integer literal or enum constant, or None; anything else is not read as constant."""
    K = ci.CursorKind
    cursor = peel(cursor)
    if cursor is None:
        return None
    if cursor.kind == K.DECL_REF_EXPR and cursor.referenced is not None and \
            cursor.referenced.kind == K.ENUM_CONSTANT_DECL:
        return cursor.referenced.enum_value
    if cursor.kind != K.INTEGER_LITERAL:
        return None
    tokens = [t.spelling for t in cursor.get_tokens()]
    try:
        return int(tokens[0].rstrip("uUlL"), 0) if tokens else None
    except ValueError:
        return None


def pointer_wide_operand(cursor):
    cursor = peel(cursor)
    if cursor is None:
        return False
    if pointerish(cursor.type) or pointwide(cursor.type):
        return True
    if is_cast(cursor):
        inner = operand(cursor)
        return inner is not None and pointerish(inner.type)
    return False


def pointer_difference(cursor):
    cursor = peel(cursor)
    if cursor is None or cursor.kind != ci.CursorKind.BINARY_OPERATOR or binop(cursor) != "Sub":
        return False
    children = list(cursor.get_children())
    return len(children) == 2 and all(pointer_wide_operand(c) for c in children)


def benign_class(expression):
    """The benign class of a narrowed integer expression, or None when it may carry an address."""
    K = ci.CursorKind
    expression = peel(expression)
    if expression is None or expression.kind != K.BINARY_OPERATOR:
        return None
    children = list(expression.get_children())
    if len(children) != 2:
        return None
    lhs, rhs = children
    op = binop(expression)
    if op == "And":
        # A mask wider than 32 bits, or negative (sign-extended over the high bits), keeps address bits.
        masks = [constant_value(c) for c in children]
        return "benign:low-bits" if any(m is not None and 0 <= m <= LOW_BITS_LIMIT for m in masks) else None
    if op == "Rem":
        return "benign:residue" if constant_value(rhs) is not None else None
    if op == "Sub":
        return "benign:difference" if pointer_difference(expression) else None
    if op in ("Div", "Shr") and constant_value(rhs) is not None and pointer_difference(lhs):
        return "benign:difference"
    return None


def narrowing_record(cursor, ancestors, function, found):
    K = ci.CursorKind
    if is_cast(cursor):
        inner = operand(cursor)
        if inner is None or not narrow(cursor.type):
            return
        if pointerish(inner.type):
            kind = "pointer cast"
        elif pointwide(peel(inner).type):
            kind = "uptr narrowed"
        else:
            return
        narrowed = inner
    elif cursor.kind == K.UNEXPOSED_EXPR and narrow(cursor.type):
        source = peel(cursor)
        if source == cursor or not pointwide(source.type):
            return
        kind = "uptr narrowed"
        narrowed = source
    else:
        return
    location = cursor.location
    if location.file is None or not ours(location.file.name):
        return
    found.append({
        "file": rel(location.file.name),
        "line": location.line,
        "column": location.column,
        "function": qualified(function) if function is not None else "(file scope)",
        "signature": signature(function),
        "concrete_type": cursor.type.get_canonical().spelling,
        "kind": kind,
        "destination": destination(cursor, ancestors, function),
        "class": benign_class(narrowed) or "counted",
        "expression": text(cursor),
    })


def owner_of(site):
    key = (site["file"], site["function"])
    if key in NARROWING_OWNER:
        return NARROWING_OWNER[key]
    return NARROWING_OWNER.get((site["file"], None))


def narrowing_groups(narrowing):
    """The narrowing sites as counted and benign groups."""
    benign = [s for s in narrowing if s["class"] != "counted"]
    compiled = [s for s in narrowing if s["class"] == "counted"]
    return compiled, benign


def narrowing_summary(narrowing):
    compiled, benign = narrowing_groups(narrowing)
    owned = sum(owner_of(s) is not None for s in compiled)
    return ("%d counted narrowing sites in compiled native code (%d reviewed, %d unreviewed), %d benign"
            % (len(compiled), owned, len(compiled) - owned, len(benign)))


def write_worklist(narrowing, path):
    def cell(value):
        return str(value).replace("\t", " ").replace("\r", " ").replace("\n", " ")

    with open(path, "w", encoding="utf-8") as f:
        f.write(WORKLIST_HEADER + "\n")
        for s in sorted(narrowing, key=lambda s: (s["file"], s["line"], s["column"])):
            f.write("\t".join(cell(s[key]) for key in ("file", "line", "column", "function", "state", "kind",
                                                       "destination", "class", "expression")) + "\n")


def unit_source(path):
    with open(path, encoding="latin-1") as source:
        return source.read()


def walk(path, args):
    global FUNCTION_KINDS
    K = ci.CursorKind
    FUNCTION_KINDS = (K.FUNCTION_DECL, K.CXX_METHOD, K.CONSTRUCTOR, K.DESTRUCTOR, K.CONVERSION_FUNCTION,
                      K.FUNCTION_TEMPLATE)
    narrowing = []
    game_unit = ours(path)
    index = ci.Index.create()
    try:
        tu = index.parse(path, args=args, options=0)
    except ci.TranslationUnitLoadError as error:
        return {"file": path, "error": str(error)}
    errors = [str(d) for d in tu.diagnostics if d.severity >= ci.Diagnostic.Error]
    casts = []
    back = []
    sinks = set()
    edges = []

    def visit(cursor, ancestors, function):
        kind = cursor.kind
        if kind in FUNCTION_KINDS and cursor.is_definition():
            function = cursor
        if game_unit:
            narrowing_record(cursor, ancestors, function, narrowing)
        if is_cast(cursor):
            inner = operand(cursor)
            if inner is not None:
                if narrow(cursor.type) and pointerish(inner.type):
                    record(cursor, inner, ancestors, function)
                elif integral(cursor.type) and pointerish(inner.type) and narrowed_later(ancestors):
                    record(cursor, inner, ancestors, function)
                elif pointerish(cursor.type) and integral(inner.type):
                    read = refs(inner)
                    sinks.update(read)
                    if read and cursor.location.file is not None:
                        back.append({
                            "file": rel(cursor.location.file.name),
                            "line": cursor.location.line,
                            "column": cursor.location.column,
                            "expression": text(cursor),
                            "refs": sorted(read),
                            "concrete_type": cursor.type.get_canonical().spelling,
                            "function": qualified(function) if function is not None else "(file scope)",
                            "signature": signature(function),
                        })
        elif kind == K.COMPOUND_ASSIGNMENT_OPERATOR or (kind == K.BINARY_OPERATOR and binop(cursor) == "Assign"):
            children = list(cursor.get_children())
            if len(children) == 2 and integral(children[0].type):
                target = target_of(children[0])
                if target:
                    edges.extend((source, target) for source in refs(children[1]))
            if len(children) == 2 and pointerish(children[0].type) and kind == K.COMPOUND_ASSIGNMENT_OPERATOR:
                sinks.update(refs(children[1]))
        elif kind == K.VAR_DECL and integral(cursor.type):
            init = [c for c in cursor.get_children() if c.kind.is_expression()]
            if init and cursor.get_usr():
                edges.extend((source, cursor.get_usr()) for source in refs(init[-1]))
        elif kind == K.CALL_EXPR and cursor.referenced is not None:
            params = list(cursor.referenced.get_arguments()) if cursor.referenced.kind in FUNCTION_KINDS else []
            for argument, param in zip(cursor.get_arguments(), params):
                if integral(param.type) and param.get_usr():
                    edges.extend((source, param.get_usr()) for source in refs(argument))
        elif kind == K.RETURN_STMT and function is not None and integral(function.result_type):
            for child in cursor.get_children():
                edges.extend((source, "ret:" + function.get_usr()) for source in refs(child))
        elif kind == K.BINARY_OPERATOR and binop(cursor) in ("Add", "Sub"):
            children = list(cursor.get_children())
            if len(children) == 2 and any(pointerish(c.type) for c in children):
                for child in children:
                    if integral(child.type) and not contains_truncation(child):
                        sinks.update("offset:" + usr for usr in refs(child))
        ancestors.append(cursor)
        for child in cursor.get_children():
            location = child.location
            if location.file is not None and not ours(location.file.name):
                continue
            visit(child, ancestors, function)
        ancestors.pop()

    def record(cast, inner, ancestors, function):
        location = cast.location
        if location.file is None:
            return
        function_usr = function.get_usr() if function is not None else None
        ops = []
        kind, detail, usr = context(cast, ancestors, function_usr, ops)
        casts.append({
            "file": rel(location.file.name),
            "line": location.line,
            "column": location.column,
            "expression": text(cast),
            "type": cast.type.get_canonical().spelling,
            "concrete_type": cast.type.get_canonical().spelling,
            "origin": origin(inner),
            "context": kind,
            "detail": detail,
            "usr": usr,
            "ops": ops,
            "masks": sorted({op[len("mask "):] for op in ops if op.startswith("mask ")}),
            "function": qualified(function) if function is not None else "(file scope)",
            "signature": signature(function),
            "static": function is not None and function.linkage == ci.LinkageKind.INTERNAL,
        })

    for child in tu.cursor.get_children():
        location = child.location
        if location.file is not None and ours(location.file.name):
            visit(child, [], None)
    return {"file": rel(path), "casts": casts, "back": back, "sinks": sorted(sinks), "edges": edges,
            "errors": errors[:5], "error_count": len(errors), "narrowing": narrowing}


def unit_entries(build):
    """The compile commands of the port-owned runtime translation units."""
    with open(os.path.join(build, "compile_commands.json")) as f:
        entries = json.load(f)
    for entry in entries:
        path = canon(os.path.join(entry["directory"], entry["file"]))
        if "command" in entry:
            entry["arguments"] = shlex.split(entry.pop("command"))
        entry["file"] = canon(path)
    extras = owned_roots(Path(ROOT), OWNED_PREFIXES)[2:]
    source_root = (Path(ROOT) / "port/src").resolve()
    return [e for e in entries if not Path(e["file"]).is_relative_to(source_root / "tests") and
            (Path(e["file"]).is_relative_to(source_root) or
             any(Path(e["file"]).is_relative_to(prefix) for prefix in extras))]


@functools.lru_cache(maxsize=None)
def resource_dir(compiler):
    # One compiler serves every unit; asking it once per unit cost a process spawn each.
    return subprocess.run([compiler, "-print-resource-dir"], capture_output=True, text=True).stdout.strip()


def command_args(entry):
    args = shlex.split(entry["command"]) if "command" in entry else list(entry["arguments"])
    out = []
    skip = False
    for arg in args[1:]:
        if skip:
            skip = False
            continue
        if arg in ("-o", "-c"):
            skip = arg == "-o"
            continue
        if canon(os.path.join(entry["directory"], arg)) == canon(entry["file"]):
            continue
        out.append(arg)
    # libclang needs to find its own resource headers through the same compiler.
    resource = resource_dir(args[0])
    if resource:
        out += ["-resource-dir", resource]
    return out


def init_worker(libclang, build, root=None, owned_prefixes=()):
    global ROOT, OWNED_PREFIXES
    if root is not None:
        ROOT = root
    OWNED_PREFIXES = tuple(Path(prefix) for prefix in owned_prefixes)
    load_libclang(libclang)
    set_mirrors(build)


def work(entry):
    os.chdir(entry["directory"])
    return walk(entry["file"], command_args(entry))


def classify(site, sinks, reach):
    context = site["context"]
    origin = site["origin"]
    # A mask or a remainder keeps only the low bits; shifts can be undone on the way back.
    masked = any(op in ("And", "Rem") for op in site["ops"])
    if context in ("cast back", "compare"):
        return "round-trip"
    if context == "pointer offset":
        absolute = not (origin in ("field", "integer", "unknown") or origin.startswith("member array"))
        return "round-trip" if absolute else "low-bits"
    if context in ("store", "argument", "return"):
        if site["usr"] and site["usr"] in reach and not masked:
            return "round-trip"
        return "low-bits" if masked else "escapes"
    if context in ("store to memory", "argument to unknown", "other", "converted"):
        return "low-bits" if masked else "escapes"
    return "low-bits"


def reaching(sinks, edges):
    """Every USR whose value flows, through integer assignments, into a cast back to a pointer."""
    backward = collections.defaultdict(set)
    for source, target in edges:
        backward[target].add(source)
    reach = set(s for s in sinks if not s.startswith("offset:"))
    reach.update(s[len("offset:"):] for s in sinks if s.startswith("offset:"))
    stack = list(reach)
    while stack:
        usr = stack.pop()
        for source in backward.get(usr, ()):
            if source not in reach:
                reach.add(source)
                stack.append(source)
    return reach


def carriers(sites, edges):
    """The integers that hold a truncated pointer on its way back, named after the first that took it."""
    forward = collections.defaultdict(set)
    for source, target in edges:
        forward[source].add(target)
    carried = {}
    for site in sites:
        if site["class"] != "round-trip" or not site["usr"]:
            continue
        name = site["detail"] or site["function"]
        stack = [site["usr"]]
        while stack:
            usr = stack.pop()
            if usr in carried:
                continue
            carried[usr] = name
            stack.extend(forward.get(usr, ()))
    return carried


def linked_functions(binary):
    """The qualified names of the functions the binary defines."""
    try:
        listing = subprocess.run(["nm", "-C", "--defined-only", binary], capture_output=True, text=True,
                                 check=True).stdout
    except (OSError, subprocess.CalledProcessError) as error:
        sys.exit("truncations.py: cannot list the symbols of %s: %s" % (binary, error))
    names = set()
    for line in listing.splitlines():
        parts = line.split(" ", 2)
        if len(parts) == 3:
            names.add(parts[2].split("(", 1)[0])
    return names


def assign_phases(sites, linked):
    for site in sites:
        if site["class"] != "round-trip":
            site["phase"] = "-"
        elif site["function"] not in linked and site["function"] != "(file scope)":
            site["phase"] = "not linked"
        else:
            # File-scope initialisers run at start-up, so they are always linked.
            site["phase"] = "linked"


def scan_literals(paths):
    """Port-owned lines holding address-alias literals and their narrowing casts."""
    rows = []
    for base in paths:
        for path in sorted(glob.glob(os.path.join(ROOT, base, "**", "*.[ch]pp"), recursive=True)) + sorted(
                glob.glob(os.path.join(ROOT, base, "**", "*.[ch]"), recursive=True)):
            if "/tests/" in path.replace(os.sep, "/"):
                continue
            try:
                with open(path, encoding="latin-1") as f:
                    lines = f.read().splitlines()
            except OSError:
                continue
            for number, line in enumerate(lines, 1):
                if ADDRESS_MASK_TEXT.search(line):
                    rows.append({"file": rel(path), "line": number, "text": line.strip(),
                                 "cast": TRUNCATING_CAST_TEXT.search(line) is not None})
    return rows


def esc(value):
    return value.replace("|", "\\|")


def row_use(site):
    use = site["context"] + (": " + site["detail"] if site["detail"] else "")
    if site.get("masks"):
        use += " (masked " + ", ".join(site["masks"]) + ")"
    return use


def markdown(sites, totals, returns, literals, narrowing, build, out):
    """Write the pointer-width audit for code actually compiled into the native game."""
    lines = ["# Pointer truncations", "",
             "Generated by scripts/port/truncations.py from the native compile database and linked game.",
             "Regenerate after changing native source or compiler flags.", "",
             "The report audits port/src and port/include code in the native target. "
             "A round trip narrows an address and later uses it as a pointer. "
             "An escape stores a narrowed address where the analysis cannot follow its reader. "
             "Low-bit casts use only a mask, residue, or other bounded part of the address.", "",
             "## Counts", "", "| class | compiled sites |", "|---|---:|"]
    for kind in ("round-trip", "escapes", "low-bits"):
        lines.append("| %s | %d |" % (kind, totals[(kind, "open")]))
    lines.extend(["", "## Linked round trips", "",
                  "Every row here must be removed or widened for the native build to pass --check.", "",
                  "| source | line | function | expression |", "|---|---:|---|---|"])
    for site in sites:
        if site["class"] == "round-trip" and site["phase"] != "not linked":
            lines.append("| %s | %d | %s | %s |" %
                         (site["file"], site["line"], esc(site["function"]),
                          esc(site["expression"])))
    lines.extend(["", "## Address-alias literals", "",
                  "PS2 physical and uncached-address masks surviving in port-owned source.", "",
                  "| source | line | narrowing cast | text |", "|---|---:|---|---|"])
    for row in literals:
        lines.append("| %s | %d | %s | %s |" %
                     (row["file"], row["line"], "yes" if row["cast"] else "no", esc(row["text"][:140])))
    lines.extend(["", "## Cast sites", "",
                  "| source | line | function | class | expression | origin | use | linked |",
                  "|---|---:|---|---|---|---|---|---|"])
    for site in sites:
        lines.append("| %s | %d | %s | %s | %s | %s | %s | %s |" %
                     (site["file"], site["line"], esc(site["function"]), site["class"],
                      esc(site["expression"]), esc(site["origin"]), esc(row_use(site)),
                      "no" if site["phase"] == "not linked" else "yes"))
    lines.extend(["", "## Integer-to-pointer readers", "",
                  "| source | line | function | expression | carries |", "|---|---:|---|---|---|"])
    for site in returns:
        lines.append("| %s | %d | %s | %s | %s |" %
                     (site["file"], site["line"], esc(site["function"]),
                      esc(site["expression"]), esc(site["carrier"])))
    compiled, benign = narrowing_groups(narrowing)
    lines.extend(["", "## Counted pointer narrowing", "",
                  "These sites can carry a full native pointer into a narrower integer. "
                  "Each requires a code fix or a reviewed NARROWING_OWNER entry.", ""])
    for site in compiled:
        lines.append("- %s:%d %s: %s; %s" %
                     (site["file"], site["line"], site["function"], site["destination"],
                      owner_of(site) or "unassigned"))
    lines.extend(["", "## Benign narrowing", "",
                  "These expressions retain only bounded low bits or a pointer difference.", ""])
    for site in benign:
        lines.append("- %s:%d %s: %s (%s)" %
                     (site["file"], site["line"], site["function"],
                      site["destination"], site["class"]))
    with open(out, "w", encoding="utf-8") as report_file:
        report_file.write("\n".join(lines).rstrip() + "\n")


def report(label, failures):
    if not failures:
        return 0
    more = " (+%d more)" % (len(failures) - EXAMPLE_LIMIT) if len(failures) > EXAMPLE_LIMIT else ""
    print("truncations.py: %s: %d; e.g. %s%s" % (label, len(failures), "; ".join(failures[:EXAMPLE_LIMIT]), more),
          file=sys.stderr)
    return 1


def check(sites, totals, returns, literals, narrowing, build, out):
    import tempfile
    with tempfile.TemporaryDirectory() as scratch:
        fresh = os.path.join(scratch, "truncations.md")
        markdown(sites, totals, returns, literals, narrowing, build, fresh)
        with open(fresh) as f:
            wanted = f.read()
    try:
        with open(out) as f:
            committed = f.read()
    except OSError:
        committed = None
    status = 0
    if committed != wanted:
        print("truncations.py: %s is stale; run scripts/port/truncations.py and commit it" % rel(out),
              file=sys.stderr)
        status = 1
    open_linked = [s for s in sites if s["class"] == "round-trip" and s["state"] == "open" and
                   s["phase"] != "not linked"]
    status |= report("open round trips in linked code",
                     ["%s:%d %s (%s)" % (s["file"], s["line"], s["function"], s["phase"]) for s in open_linked])
    compiled, _ = narrowing_groups(narrowing)
    status |= report("narrowing sites without a NARROWING_OWNER entry",
                     ["%s:%d %s" % (s["file"], s["line"], s["function"]) for s in compiled if owner_of(s) is None])
    return status


def main():
    global ROOT, OWNED_PREFIXES
    parser = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    parser.add_argument("--build", default=os.path.join(ROOT, "port/build/pc"))
    parser.add_argument("--libclang")
    parser.add_argument("--root", default=ROOT, help="Project root used for owned source locations")
    parser.add_argument("--owned-prefix", type=Path, action="append", default=[], help="Additional explicit owned dependency file or directory")
    parser.add_argument("--out", default=os.path.join(ROOT, "docs/port/truncations.md"))
    parser.add_argument("--json", help="write the rows as {\"sites\": [...], \"narrowing\": [...]}")
    parser.add_argument("--worklist", help="write the narrowing sites as a TSV, sorted by file and line")
    parser.add_argument("--jobs", type=int, default=os.cpu_count() or 1)
    parser.add_argument("--only", help="regular expression over source paths, for a quick run")
    parser.add_argument("--verbose", action="store_true", help="print each unit's parse diagnostics")
    parser.add_argument("--check", action="store_true",
                        help="write nothing; fail if --out differs from what would be written, if an open round "
                             "trip is in linked code, or if an "
                             "open counted narrowing site has no NARROWING_OWNER entry")
    options = parser.parse_args()
    ROOT = canon(options.root)
    OWNED_PREFIXES = tuple(options.owned_prefix)

    try:
        load_libclang(options.libclang)
    except ImportError:
        sys.exit("truncations.py: the clang Python bindings are missing (pip install libclang)")
    set_mirrors(options.build)
    entries = unit_entries(options.build)
    if options.only:
        entries = [e for e in entries if re.search(options.only, rel(e["file"]))]
    if not entries:
        sys.exit("truncations.py: no production compile commands match the owned audit roots")
    with multiprocessing.Pool(options.jobs, initializer=init_worker,
                              initargs=(options.libclang, options.build, ROOT, OWNED_PREFIXES)) as pool:
        results = pool.map(work, entries, chunksize=1)

    sinks = set()
    edges = []
    seen = {}
    backs = {}
    narrowing_seen = {}
    diagnostic_units = 0
    diagnostic_count = 0
    worker_failures = 0
    for result in results:
        if "error" in result:
            print("truncations.py: %s: %s" % (result["file"], result["error"]), file=sys.stderr)
            worker_failures += 1
            continue
        if result["error_count"]:
            diagnostic_units += 1
            diagnostic_count += result["error_count"]
        if options.verbose:
            for error in result["errors"]:
                print("truncations.py: %s: %s" % (result["file"], error), file=sys.stderr)
        sinks.update(result["sinks"])
        edges.extend(result["edges"])
        for site in result["casts"]:
            seen.setdefault((site["file"], site["line"], site["column"], site["concrete_type"]), site)
        for site in result["back"]:
            backs.setdefault((site["file"], site["line"], site["column"], site["concrete_type"]), site)
        for site in result["narrowing"]:
            narrowing_seen.setdefault((site["file"], site["line"], site["column"], site["concrete_type"]), site)
    narrowing = sorted(narrowing_seen.values(), key=lambda s: (s["file"], s["line"], s["column"]))
    for site in narrowing:
        site["state"] = "open"
    reach = reaching(sinks, edges)
    sites = sorted(seen.values(), key=lambda s: (s["file"], s["line"], s["column"]))
    totals = collections.Counter()
    for site in sites:
        site["class"] = classify(site, sinks, reach)
        site["state"] = "open"
        totals[(site["class"], site["state"])] += 1
    carried = carriers(sites, edges)
    returns = []
    for site in sorted(backs.values(), key=lambda s: (s["file"], s["line"], s["column"])):
        names = [usr for usr in site["refs"] if usr in carried]
        if names:
            site["carrier"] = ", ".join(sorted({carried[usr] for usr in names}))
            site["state"] = "open"
            returns.append(site)
    assign_phases(sites, linked_functions(os.path.join(options.build, "darkchronicle")))
    if diagnostic_count and not options.verbose:
        print("truncations.py: %d parse diagnostics in %d units (use --verbose)" % (diagnostic_count, diagnostic_units),
              file=sys.stderr)
    if worker_failures or diagnostic_count:
        print("truncations.py: refusing an incomplete AST result (%d failed units, %d parse errors)" %
              (worker_failures, diagnostic_count), file=sys.stderr)
        return 1
    literals = scan_literals(("port/src",))
    if options.check:
        return check(sites, totals, returns, literals, narrowing, options.build, options.out)
    os.makedirs(os.path.dirname(os.path.abspath(options.out)), exist_ok=True)
    markdown(sites, totals, returns, literals, narrowing, options.build, options.out)
    if options.json:
        with open(options.json, "w") as f:
            json.dump({"sites": sites, "narrowing": narrowing,
                       "coverage": {"parsed_commands": len(results),
                                    "translation_units": [rel(entry["file"]) for entry in entries],
                                    "owned_prefixes": [str(prefix) for prefix in OWNED_PREFIXES]}}, f, indent=1)
    if options.worklist:
        write_worklist(narrowing, options.worklist)
    for cls in ("round-trip", "escapes", "low-bits"):
        print("%-10s compiled %4d" % (cls, totals[(cls, "open")]))
    print("%d rows, %d address-alias literal lines, %s" % (len(sites), len(literals), narrowing_summary(narrowing)))


if __name__ == "__main__":
    sys.exit(main())
