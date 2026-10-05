#!/usr/bin/env python3
"""Build one bounded Discord message for a GitHub push event."""

import argparse
import json
import re
from pathlib import Path


MAX_CONTENT = 2000
MAX_COMMITS = 12
SAFE_REPOSITORY = re.compile(r"^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$")
SAFE_SHA = re.compile(r"^[0-9a-fA-F]{7,64}$")
URL = re.compile(r"https?://[^\s<>]+")
MARKDOWN = re.compile(r"([\\`*_~|>\[\]()])")


def discord_length(value):
    return len(value.encode("utf-16-le")) // 2


def subject_text(value):
    """Suppress previews for links written in a commit subject."""
    line = " ".join(str(value or "").split())
    parts = []
    previous = 0
    for match in URL.finditer(line):
        parts.append(MARKDOWN.sub(r"\\\1", line[previous:match.start()]))
        url = match.group().rstrip(".,;!?)]")
        parts.append(f"<{url}>")
        parts.append(MARKDOWN.sub(r"\\\1", match.group()[len(url):]))
        previous = match.end()
    parts.append(MARKDOWN.sub(r"\\\1", line[previous:]))
    return "".join(parts)


def clipped(value, limit):
    return value if len(value) <= limit else value[:limit - 1].rstrip() + "…"


def commit_line(commit, repository):
    sha = str(commit.get("id", ""))
    raw_subject = clipped(str(commit.get("message", "")).split("\n", 1)[0], 110)
    subject = subject_text(raw_subject) or "(no message)"
    author_name = str((commit.get("author") or {}).get("name") or "")
    author = subject_text(clipped(author_name, 50))
    prefix = (f"[`{sha[:7]}`](<https://github.com/{repository}/commit/{sha}>) "
              if SAFE_SHA.fullmatch(sha) and SAFE_REPOSITORY.fullmatch(repository)
              else f"`{sha[:7]}` " if SAFE_SHA.fullmatch(sha) else "")
    suffix = f" — {author}" if author else ""
    return f"• {prefix}{subject}{suffix}"


def payload(event):
    repository = str(event.get("repository", {}).get("full_name", ""))
    commits = event.get("commits") or []
    lines = []
    for commit in commits[:MAX_COMMITS]:
        line = commit_line(commit, repository)
        if discord_length("\n".join((*lines, line))) > MAX_CONTENT:
            break
        lines.append(line)

    omitted = len(commits) - len(lines)
    if omitted:
        suffix = f"… and {omitted:,} more commit{'s' if omitted != 1 else ''}."
        while discord_length("\n".join((*lines, suffix))) > MAX_CONTENT and lines:
            lines.pop()
            omitted += 1
            suffix = f"… and {omitted:,} more commit{'s' if omitted != 1 else ''}."
        lines.append(suffix)
    elif not commits:
        lines.append("No commits were included in this push event.")

    return {
        "username": "ChronicleTwo",
        "allowed_mentions": {"parse": []},
        "content": "\n".join(lines),
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--event", required=True, type=Path, help="GitHub push event JSON")
    parser.add_argument("output", type=Path, help="Discord webhook payload")
    args = parser.parse_args()
    event = json.loads(args.event.read_text(encoding="utf-8"))
    args.output.write_text(json.dumps(payload(event), ensure_ascii=False) + "\n", encoding="utf-8")


if __name__ == "__main__":
    main()
