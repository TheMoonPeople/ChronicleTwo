#!/usr/bin/env python3
"""Build the PAL progress message from an objdiff report."""

import argparse
import json
from pathlib import Path


def fuzzy_function_count(units):
    return sum(
        1
        for unit in units
        for function in unit.get("functions", ())
        if "fuzzy_match_percent" in function
        and float(function["fuzzy_match_percent"]) < 100.0
    )


def progress_line(measures, units):
    perfect = float(measures.get("matched_code_percent", 0))
    matched = float(measures.get("fuzzy_match_percent", 0))
    total = int(measures.get("total_functions", 0))
    perfect_count = int(measures.get("matched_functions", 0))
    fuzzy_count = fuzzy_function_count(units)
    parts = (
        ("Perfect", perfect, perfect_count),
        ("Fuzzy", max(0.0, matched - perfect), fuzzy_count),
        ("Other", max(0.0, 100.0 - matched), max(0, total - perfect_count - fuzzy_count)),
    )
    return " · ".join(f"{name} **{share:.2f}%** ({count:,})" for name, share, count in parts)


def field(name, measures, units):
    matched = float(measures.get("fuzzy_match_percent", 0))
    total = int(measures.get("total_functions", 0))
    return {
        "name": f"{name} — {matched:.2f}% ({total:,} functions)",
        "value": progress_line(measures, units),
        "inline": False,
    }


def payload(report):
    return {
        "username": "ChronicleTwo",
        "allowed_mentions": {"parse": []},
        "embeds": [{
            "title": "Dark Chronicle PAL",
            "color": 0x5865F2,
            "fields": [
                field("Overall", report["measures"], report["units"]),
            ],
        }],
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--pal", required=True, type=Path, help="the PAL objdiff report")
    parser.add_argument("output", type=Path, help="Discord webhook payload")
    args = parser.parse_args()
    report = json.loads(args.pal.read_text(encoding="utf-8"))
    args.output.write_text(json.dumps(payload(report), ensure_ascii=False) + "\n", encoding="utf-8")


if __name__ == "__main__":
    main()
