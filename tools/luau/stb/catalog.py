"""Builds the external-command catalog shared by the Luau transpiler and the native binding generator.

Facts come from three places: command numbers and names from the kind's enum and registration table, descriptions
and accessor-derived parameter names and types from the handler sources, and arities, argument directions and
script-side types from every call site in the corpus. Hand curation, keyed by kind and handler, is applied last.
"""

from __future__ import annotations

import collections
import re
from pathlib import Path

from . import sources
from .corpus import Kind
from .scan import ScriptFacts

SCHEMA = 1
TYPES = ["s8", "u8", "s16", "u16", "s32", "u32", "f32", "string", "boolean", "array"]
MAX_CONSTANTS = 8
RESERVED = {"and", "break", "do", "else", "elseif", "end", "false", "for", "function", "if", "in", "local", "nil", "not", "or", "repeat", "return", "then", "true", "until", "while", "continue", "type", "export", "typeof"}


def luau_name(enum_name: str, prefix: str) -> str:
    """PascalCase API name of a command from its enum name."""
    words = enum_name[len(prefix):] if enum_name.startswith(prefix) else enum_name
    return "".join(word.capitalize() if not word.isdigit() else word for word in words.split("_") if word)


def _constant(value):
    return round(value, 6) if isinstance(value, float) else value


def usage(facts: list[ScriptFacts], kind: Kind):
    """Call-site statistics of one kind: (command, argc) -> sites, files and per-position observations."""
    result = collections.defaultdict(lambda: {"sites": 0, "files": set(), "positions": collections.defaultdict(lambda: {"observed": collections.Counter(), "shapes": collections.Counter(), "constants": collections.Counter()})})
    for script in facts:
        if script.kind != kind:
            continue
        for command, args in script.ext_sites:
            entry = result[(command, len(args))]
            entry["sites"] += 1
            entry["files"].add(script.path)
            for i, arg in enumerate(args):
                position = entry["positions"][i]
                position["observed"][f"{arg.direction} {arg.type}"] += 1
                position["shapes"][arg.shape] += 1
                if arg.const is not None:
                    position["constants"][_constant(arg.const)] += 1
    return result


def _majority(counter: collections.Counter, prefix: str) -> str | None:
    known = [(n, key.split(" ", 1)[1]) for key, n in counter.items() if key.startswith(prefix + " ") and not key.endswith(" unknown")]
    return max(known)[1] if known else None


def _signature(argc: int, stats, handler: sources.Handler | None) -> dict:
    source = {}
    if handler and argc in handler.params_by_arity:
        source = {p.position: p for p in handler.params_by_arity[argc]}
    elif handler and handler.linear and len(handler.params) == argc:
        source = {p.position: p for p in handler.params}
    params, names = [], collections.Counter()
    review = []
    for i in range(argc):
        observed = stats["positions"][i]["observed"] if stats else collections.Counter()
        ins = sum(n for key, n in observed.items() if key.startswith("in "))
        outs = sum(n for key, n in observed.items() if key.startswith("out "))
        hint = source.get(i)
        if observed:
            direction = "out" if outs > ins else "in"
        else:
            direction = hint.direction if hint else "in"
        if hint and observed and hint.direction != direction:
            review.append(f"parameter {i + 1}: handler accessor is '{hint.direction}' but call sites pass '{direction}'")
        if ins and outs:
            review.append(f"parameter {i + 1}: call sites pass both values and references")
        if hint and hint.type and hint.direction == direction:
            luau_type = hint.type
        else:
            luau_type = _majority(observed, direction) or "unknown"
        name = hint.name if hint and hint.name and hint.direction == direction else f"{'out' if direction == 'out' else 'arg'}{i + 1}"
        name = name + "_value" if name in RESERVED else name
        names[name] += 1
        if names[name] > 1:
            name = f"{name}_{names[name]}"
        param = {"name": name, "dir": direction, "type": luau_type}
        if hint and hint.name and hint.direction == direction:
            param["name_source"] = "handler"
        if observed:
            param["observed"] = dict(sorted(observed.items()))
        if stats and stats["positions"][i]["constants"]:
            constants = stats["positions"][i]["constants"]
            param["constants"] = [value for value, _ in constants.most_common(MAX_CONSTANTS)]
            param["distinct_constants"] = len(constants)
        if luau_type == "unknown":
            review.append(f"parameter {i + 1}: type unknown")
        params.append(param)
    signature = {"argc": argc, "sites": stats["sites"] if stats else 0, "files": len(stats["files"]) if stats else 0, "params": params}
    if review:
        signature["review"] = review
    return signature


def _accepts(handler: sources.Handler | None, argc: int) -> bool | None:
    """Whether a handler's argument-count checks accept an arity, when that can be told from its checks alone."""
    if handler is None or handler.polymorphic:
        cases = [int(c.split()[1]) for c in handler.arity_checks if c.startswith("case ")] if handler else []
        return (argc in cases) if cases else None
    exact = [int(c.split()[1]) for c in handler.arity_checks if c.startswith("!= ")]
    if len(handler.arity_checks) == 1 and exact:
        return argc == exact[0]
    return None


def _apply(command: dict, curation: dict) -> None:
    for key in ("luau", "description", "notes"):
        if key in curation:
            command[key] = curation[key]
    for argc, overrides in curation.get("signatures", {}).items():
        signature = next((s for s in command["signatures"] if s["argc"] == int(argc)), None)
        if signature is None:
            signature = {"argc": int(argc), "sites": 0, "files": 0, "params": []}
            command["signatures"].append(signature)
        for i, param in enumerate(overrides.get("params", [])):
            while len(signature["params"]) <= i:
                signature["params"].append({"name": f"arg{len(signature['params']) + 1}", "dir": "in", "type": "unknown"})
            signature["params"][i].update(param)
            if "name" in param:
                signature["params"][i]["name_source"] = "curated"
        signature.pop("review", None) if overrides.get("reviewed") else None
    command["curated"] = True


def build(repo: Path, facts: list[ScriptFacts], curation: dict | None = None) -> tuple[dict, dict]:
    """The catalog document and the findings the corpus report lists about it."""
    curation = curation or {}
    catalog = {"schema": SCHEMA, "generated_by": "tools/luau/survey.py", "types": TYPES, "kinds": {}}
    findings = {"unregistered": [], "dynamic": collections.Counter(), "rejected": [], "duplicates": [], "misfit": [], "unknown_types": 0, "review": 0}
    for kind in Kind:
        source, enum, table, handlers = sources.load(repo, kind)
        values = {entry.name: entry for entry in enum}
        registered: dict[int, tuple[str, sources.EnumEntry]] = {}
        for handler, enum_name in table:
            entry = values[enum_name]
            if entry.value in registered:
                findings["duplicates"].append((kind.value, entry.value, registered[entry.value][0], handler))
            registered[entry.value] = (handler, entry)
        stats = usage(facts, kind)
        commands = []
        for no in sorted(registered):
            handler_name, entry = registered[no]
            handler = handlers.get(handler_name)
            used = sorted(argc for command, argc in stats if command == no)
            arities = used or ([len(handler.params)] if handler and handler.linear else sorted(handler.params_by_arity) if handler else [])
            signatures = [_signature(argc, stats.get((no, argc)), handler) for argc in arities]
            command = {
                "no": no,
                "enum": entry.name,
                "handler": handler_name,
                "luau": luau_name(entry.name, source.prefix),
                "description": handler.description if handler and handler.description else entry.comment,
                "source": f"{source.source}:{handler.line}" if handler else source.source,
            }
            if handler and handler.arity_checks:
                command["arity_checks"] = handler.arity_checks
            command["uses"] = {"sites": sum(s["sites"] for s in signatures), "files": len(set().union(*(stats[(no, a)]["files"] for a in used))) if used else 0}
            command["signatures"] = signatures
            for signature in signatures:
                if signature["sites"] and _accepts(handler, signature["argc"]) is False:
                    signature["handler_rejects"] = True
                    findings["rejected"].append((kind.value, handler_name, signature["argc"], signature["sites"]))
            if handler_name in curation.get(kind.value, {}):
                _apply(command, curation[kind.value][handler_name])
            for signature in command["signatures"]:
                findings["review"] += bool(signature.get("review"))
                findings["unknown_types"] += sum(p["type"] == "unknown" for p in signature["params"])
            commands.append(command)
        for script in facts:
            if script.kind != kind or not script.ext_sites:
                continue
            misfits = 0
            for command, args in script.ext_sites:
                handler_name = registered.get(command, (None,))[0]
                misfits += handler_name is None or _accepts(handlers.get(handler_name), len(args)) is False
            if misfits * 10 >= len(script.ext_sites):
                findings["misfit"].append((script.path, kind.value, misfits, len(script.ext_sites)))
        for (command, argc), entry in sorted(stats.items(), key=lambda item: (item[0][0] is None, item[0])):
            if command is None:
                findings["dynamic"][kind.value] += entry["sites"]
            elif command not in registered:
                findings["unregistered"].append((kind.value, command, argc, entry["sites"], sorted(entry["files"])[:3]))
        catalog["kinds"][kind.value] = {
            "namespace": source.namespace,
            "enum": source.enum,
            "header": source.header,
            "registration": f"{source.source}:{source.table}",
            "table_size": source.table_size,
            "commands": commands,
        }
    return catalog, findings


def names_are_identifiers(catalog: dict) -> list[str]:
    """Catalog API and parameter names that are not valid, unique Luau identifiers."""
    problems = []
    identifier = re.compile(r"[A-Za-z_][A-Za-z0-9_]*")
    for kind, document in catalog["kinds"].items():
        seen = collections.Counter(c["luau"] for c in document["commands"])
        problems += [f"{kind}: duplicate API name {name}" for name, n in seen.items() if n > 1]
        for command in document["commands"]:
            if not identifier.fullmatch(command["luau"]):
                problems.append(f"{kind}: {command['luau']} is not an identifier")
            for signature in command["signatures"]:
                for param in signature["params"]:
                    if not identifier.fullmatch(param["name"]) or param["name"] in RESERVED:
                        problems.append(f"{kind}.{command['luau']}: parameter {param['name']} is not a usable identifier")
    return problems
