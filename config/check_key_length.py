"""Scan exported SQL files for varchar key columns that exceed InnoDB's
3072-byte composite key limit and suggest additions to patch_sql.py's
KEY_LENGTHS dict based on the actual data in INSERT statements.

Run after patch_sql.py so only columns not already patched are reported.
"""

import re
import sys
from pathlib import Path

BYTES_PER_CHAR = 4  # worst-case utf8mb4
KEY_LIMIT = 3072
MIN_SIZE_FLOOR = 32  # never suggest a varchar smaller than this
OBSERVED_BUFFER = 8  # add 8 chars of headroom above the observed max


def _parse_over_limit_tables(text):
    """Return {table_name: {varchar_key, total_bytes, col_order}} for tables
    whose declared key byte width exceeds KEY_LIMIT."""
    tables = {}

    create_re = re.compile(
        r"CREATE TABLE `(\w+)` \((.*?)\)\s*ENGINE",
        re.DOTALL | re.IGNORECASE,
    )

    for m in create_re.finditer(text):
        table_name = m.group(1)
        body = m.group(2)

        col_order = re.findall(r"^\s+`(\w+)` ", body, re.MULTILINE)

        varchars = {
            col: int(size)
            for col, size in re.findall(
                r"`(\w+)` varchar\((\d+)\)", body, re.IGNORECASE
            )
        }

        key_cols = set()
        for km in re.finditer(
            r"(?:PRIMARY KEY|UNIQUE KEY `\w+`|KEY `\w+`)\s*\(([^)]+)\)",
            body,
            re.IGNORECASE,
        ):
            key_cols.update(re.findall(r"`(\w+)`", km.group(1)))

        varchar_key = {c: varchars[c] for c in key_cols if c in varchars}
        if not varchar_key:
            continue

        total_bytes = sum(v * BYTES_PER_CHAR for v in varchar_key.values())
        if total_bytes > KEY_LIMIT:
            tables[table_name] = {
                "varchar_key": varchar_key,
                "total_bytes": total_bytes,
                "col_order": col_order,
            }

    return tables


def _split_row(row_text):
    """Split a SQL row value list 'v1','v2',3 into individual value strings."""
    parts = []
    current = []
    in_quote = False
    i = 0
    while i < len(row_text):
        ch = row_text[i]
        if ch == "'" and not in_quote:
            in_quote = True
            current.append(ch)
        elif ch == "'" and in_quote:
            # Handle escaped quote ''
            if i + 1 < len(row_text) and row_text[i + 1] == "'":
                current.append("'")
                i += 1
            else:
                in_quote = False
                current.append(ch)
        elif ch == "," and not in_quote:
            parts.append("".join(current))
            current = []
        else:
            current.append(ch)
        i += 1
    if current:
        parts.append("".join(current))
    return parts


def _scan_max_lengths(text, table_name, col_order, key_col_names):
    """Return {col_name: max_observed_length} by scanning INSERT statements."""
    max_lens = {c: 0 for c in key_col_names}
    key_positions = {i: c for i, c in enumerate(col_order) if c in key_col_names}
    if not key_positions:
        return max_lens

    insert_re = re.compile(
        rf"INSERT INTO `{re.escape(table_name)}` VALUES\s*(.*?);",
        re.DOTALL | re.IGNORECASE,
    )

    for im in insert_re.finditer(text):
        for row_m in re.finditer(r"\(([^)]*)\)", im.group(1)):
            values = _split_row(row_m.group(1))
            for pos, col in key_positions.items():
                if pos < len(values):
                    v = values[pos].strip()
                    if v.startswith("'") and v.endswith("'"):
                        max_lens[col] = max(max_lens[col], len(v) - 2)

    return max_lens


def check(sql_dir: Path) -> list:
    """Check all .sql files in sql_dir; return list of table names with issues."""
    flagged = []

    for sql_file in sorted(sql_dir.glob("*.sql")):
        text = sql_file.read_text(errors="replace")
        tables = _parse_over_limit_tables(text)

        for table_name, info in sorted(tables.items()):
            varchar_key = info["varchar_key"]
            col_order = info["col_order"]

            max_lens = _scan_max_lengths(
                text, table_name, col_order, set(varchar_key)
            )

            col_summary = ", ".join(
                f"{c}={max_lens.get(c, 0)} (declared {n})"
                for c, n in varchar_key.items()
            )
            print(
                f"\nWARNING  {sql_file.name}: table `{table_name}` key "
                f"{info['total_bytes']} B > {KEY_LIMIT} B limit."
            )
            print(f"  Observed max lengths: {col_summary}")

            new_sizes = {
                c: max(max_lens.get(c, 0) + OBSERVED_BUFFER, MIN_SIZE_FLOOR)
                for c in varchar_key
            }
            new_total = sum(v * BYTES_PER_CHAR for v in new_sizes.values())

            if new_total > KEY_LIMIT:
                print(
                    f"  Observed data itself exceeds the safe limit "
                    f"({new_total} B); manual intervention required."
                )
            else:
                print(
                    f"  Suggested addition to config/patch_sql.py KEY_LENGTHS "
                    f"(reduces key to {new_total} B):"
                )
                for c, new_n in new_sizes.items():
                    old_n = varchar_key[c]
                    print(f'    "{c}": ({old_n}, {new_n}),')

            flagged.append(table_name)

    return flagged


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print(f"Usage: {sys.argv[0]} <sql_dir>", file=sys.stderr)
        sys.exit(1)
    check(Path(sys.argv[1]))
