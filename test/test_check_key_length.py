import textwrap
from pathlib import Path

import pytest

from check_key_length import (
    KEY_LIMIT,
    _parse_over_limit_tables,
    _scan_max_lengths,
    _split_row,
    check,
)

# --- helpers ----------------------------------------------------------------

def write_sql(tmp_path, name, content):
    f = tmp_path / name
    f.write_text(textwrap.dedent(content))
    return f


# A table whose declared key width (255+200)*4 = 1820 B is fine
CLEAN_SQL = """
    CREATE TABLE `clean_table` (
      `nwb_file_name` varchar(64) NOT NULL,
      `interval_list_name` varchar(170) NOT NULL,
      PRIMARY KEY (`nwb_file_name`,`interval_list_name`)
    ) ENGINE=InnoDB;
"""

# A table whose declared key width (400+400)*4 = 3200 B exceeds 3072 B limit
OVER_SQL = """
    CREATE TABLE `over_table` (
      `nwb_file_name` varchar(400) NOT NULL,
      `interval_list_name` varchar(400) NOT NULL,
      `value` int NOT NULL,
      PRIMARY KEY (`nwb_file_name`,`interval_list_name`)
    ) ENGINE=InnoDB;
    INSERT INTO `over_table` VALUES ('file_short.nwb','list_short',1);
    INSERT INTO `over_table` VALUES ('file_short.nwb','a_longer_interval_list_name',2);
"""

# Observed values themselves exceed 768 chars in a single column
HOPELESS_SQL = """
    CREATE TABLE `hopeless_table` (
      `big_col` varchar(900) NOT NULL,
      PRIMARY KEY (`big_col`)
    ) ENGINE=InnoDB;
    INSERT INTO `hopeless_table` VALUES ('%s');
""" % ("x" * 800)


# --- unit tests -------------------------------------------------------------

def test_split_row_simple():
    assert _split_row("'a','b','c'") == ["'a'", "'b'", "'c'"]


def test_split_row_numeric():
    assert _split_row("'a',42,'c'") == ["'a'", "42", "'c'"]


def test_split_row_escaped_quote():
    # SQL '' represents a single quote; function collapses it for length measurement
    assert _split_row("'it''s'") == ["'it's'"]


def test_parse_skips_clean_table():
    tables = _parse_over_limit_tables(CLEAN_SQL)
    assert "clean_table" not in tables


def test_parse_flags_over_table():
    tables = _parse_over_limit_tables(OVER_SQL)
    assert "over_table" in tables
    assert tables["over_table"]["total_bytes"] == (400 + 400) * 4


def test_scan_max_lengths():
    tables = _parse_over_limit_tables(OVER_SQL)
    info = tables["over_table"]
    max_lens = _scan_max_lengths(
        OVER_SQL, "over_table", info["col_order"], set(info["varchar_key"])
    )
    assert max_lens["nwb_file_name"] == len("file_short.nwb")
    assert max_lens["interval_list_name"] == len("a_longer_interval_list_name")


# --- integration tests via check() ------------------------------------------

def test_check_clean_no_output(tmp_path, capsys):
    write_sql(tmp_path, "clean.sql", CLEAN_SQL)
    flagged = check(tmp_path)
    assert flagged == []
    assert capsys.readouterr().out == ""


def test_check_over_flags_table(tmp_path, capsys):
    write_sql(tmp_path, "over.sql", OVER_SQL)
    flagged = check(tmp_path)
    assert "over_table" in flagged


def test_check_over_suggests_key_lengths(tmp_path, capsys):
    write_sql(tmp_path, "over.sql", OVER_SQL)
    check(tmp_path)
    out = capsys.readouterr().out
    assert "KEY_LENGTHS" in out
    assert "nwb_file_name" in out
    assert "interval_list_name" in out


def test_check_over_suggestion_fits_limit(tmp_path, capsys):
    write_sql(tmp_path, "over.sql", OVER_SQL)
    check(tmp_path)
    out = capsys.readouterr().out
    # Verify suggested sizes are reported as fitting within KEY_LIMIT
    assert "manual intervention" not in out


def test_check_hopeless_warns_no_suggestion(tmp_path, capsys):
    write_sql(tmp_path, "hopeless.sql", HOPELESS_SQL)
    check(tmp_path)
    out = capsys.readouterr().out
    assert "manual intervention" in out
    assert "KEY_LENGTHS" not in out
