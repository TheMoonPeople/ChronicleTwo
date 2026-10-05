#!/usr/bin/env python3
"""Focused checks for the Discord webhook payload generators."""

import importlib.util
import unittest
from pathlib import Path


def load(name):
    spec = importlib.util.spec_from_file_location(name, Path(__file__).with_name(f"{name}.py"))
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


progress = load("discord_progress")
commits = load("discord_commits")


class ProgressPayloadTests(unittest.TestCase):
    def test_pal_has_only_overall_field(self):
        report = {
            "measures": {"matched_code_percent": 20, "fuzzy_match_percent": 30,
                         "matched_functions": 2, "total_functions": 5},
            "categories": [],
            "units": [
                {"metadata": {"progress_categories": ["game"]},
                 "functions": [{"fuzzy_match_percent": 50}]},
                {"metadata": {"progress_categories": []},
                 "functions": [{"fuzzy_match_percent": 40}]},
            ],
        }
        result = progress.payload(report)
        self.assertEqual(result["allowed_mentions"], {"parse": []})
        self.assertEqual(result["embeds"][0]["title"], "Dark Chronicle PAL")
        self.assertEqual(len(result["embeds"][0]["fields"]), 1)
        overall = result["embeds"][0]["fields"][0]
        self.assertIn("Fuzzy **10.00%** (2)", overall["value"])

    def test_emoji_stays_within_discord_limit(self):
        event = {"commits": [{"id": f"{i:040x}", "message": "😀" * 200}
                             for i in range(40)]}
        result = commits.payload(event)
        self.assertLessEqual(commits.discord_length(result["content"]), 2000)


class CommitPayloadTests(unittest.TestCase):
    def test_many_commits_are_bounded_with_masked_hash_links(self):
        event = {
            "repository": {"full_name": "TheMoonPeople/ChronicleTwo"},
            "ref": "refs/heads/master",
            "commits": [
                {"id": f"{i:040x}", "message": "@everyone *change* " + "x" * 300,
                 "author": {"name": "Test Author"},
                 "url": "https://evil.example/ignored"}
                for i in range(40)
            ],
        }
        result = commits.payload(event)
        self.assertLessEqual(len(result["content"]), 2000)
        self.assertIn("… and", result["content"])
        self.assertTrue(result["content"].startswith(
            "• [`0000000`](<https://github.com/TheMoonPeople/ChronicleTwo/commit/" + "0" * 40 + ">) @everyone"))
        self.assertNotIn("commit to master", result["content"])
        self.assertNotRegex(result["content"], r"(?<!<)https?://")
        self.assertNotIn("evil.example", result["content"])
        self.assertIn(r"\*change\*", result["content"])
        self.assertIn(" — Test Author", result["content"])
        self.assertEqual(result["allowed_mentions"], {"parse": []})

    def test_empty_event_and_invalid_sha(self):
        empty = commits.payload({"commits": []})
        self.assertIn("No commits", empty["content"])
        invalid = commits.payload({"repository": {"full_name": "owner/repo"},
                                   "commits": [{"id": "not-a-sha", "message": "Hello"}]})
        self.assertNotIn("https://", invalid["content"])

    def test_commit_subject_links_suppress_previews(self):
        event = {"repository": {"full_name": "TheMoonPeople/ChronicleTwo"},
                 "commits": [{"id": "a" * 40,
                              "message": "See https://example.com/notes, [more](https://example.org/update)."}]}
        content = commits.payload(event)["content"]
        self.assertIn("<https://example.com/notes>", content)
        self.assertIn("<https://example.org/update>\\).", content)
        self.assertTrue(content.startswith(
            "• [`aaaaaaa`](<https://github.com/TheMoonPeople/ChronicleTwo/commit/" + "a" * 40 + ">) See "))
        self.assertNotRegex(content, r"(?<!<)https?://")


if __name__ == "__main__":
    unittest.main()
