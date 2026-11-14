#!/usr/bin/env python3
"""Check that every shipped localization has the same resource keys."""

import json
import re
import subprocess
import sys
from pathlib import Path


LANGUAGES = ("en", "fr", "zh-Hans")
EXTENSIONS = ("strings", "stringsdict")
FORMAT_SPECIFIER = re.compile(
    r"(?<!%)%(?!#@)(?:(?P<position>\d+)\$)?[-+ #0]*(?:\d+|\*)?(?:\.(?:\d+|\*))?"
    r"(?P<length>hh|h|ll|l|z|t|j)?(?P<conversion>[@diuoxXfFeEgGaAcCsSp])"
)


def format_signatures(value: object) -> set[tuple[str, ...]]:
    """Collect the format placeholders in strings and plural variants."""
    if isinstance(value, str):
        placeholders = []
        next_position = 1
        for match in FORMAT_SPECIFIER.finditer(value):
            position = match.group("position")
            if position is None:
                position = str(next_position)
                next_position += 1
            placeholders.append(
                f"{position}${match.group('length') or ''}{match.group('conversion')}"
            )
        return {tuple(sorted(placeholders))}
    if isinstance(value, dict):
        return set().union(
            *(
                format_signatures(child)
                for key, child in value.items()
                if key not in {
                    "NSStringLocalizedFormatKey",
                    "NSStringFormatSpecTypeKey",
                    "NSStringFormatValueTypeKey",
                }
            ),
            set(),
        )
    if isinstance(value, list):
        return set().union(*(format_signatures(child) for child in value), set())
    return set()


def read_catalogs(root: Path) -> dict[str, dict[str, object]]:
    catalogs = {}
    resources = root / "Sources/Whisk/Resources"
    for language in LANGUAGES:
        entries = {}
        for extension in EXTENSIONS:
            path = resources / f"{language}.lproj/Localizable.{extension}"
            data = subprocess.check_output(
                ["/usr/bin/plutil", "-convert", "json", "-o", "-", str(path)], text=True
            )
            entries.update(json.loads(data))
        catalogs[language] = entries
    return catalogs


def main() -> int:
    root = Path(__file__).resolve().parent.parent
    catalogs = read_catalogs(root)
    reference = set(catalogs["en"])
    mismatch = False
    for language, entries in catalogs.items():
        keys = set(entries)
        missing = sorted(reference - keys)
        extra = sorted(keys - reference)
        if missing or extra:
            mismatch = True
            print(f"{language}: missing {missing}; extra {extra}", file=sys.stderr)
        else:
            print(f"{language}: {len(keys)} keys")
        if language == "en":
            continue
        for key in sorted(reference & keys):
            expected = format_signatures(catalogs["en"][key])
            actual = format_signatures(entries[key])
            if expected != actual:
                mismatch = True
                print(
                    f"{language}: placeholder mismatch for {key!r}: "
                    f"expected {sorted(expected)}, got {sorted(actual)}",
                    file=sys.stderr,
                )
    if mismatch:
        return 1
    print("All localization catalogs have matching keys and format placeholders.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
