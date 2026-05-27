import subprocess
import sys
from pathlib import Path

from hash_port import hash_port

SCRIPT = Path(__file__).parent.parent / "config" / "hash_port.py"


def test_range():
    assert 10240 <= hash_port("example") <= 60000


def test_deterministic():
    assert hash_port("paper_a") == hash_port("paper_a")


def test_hub_db_distinct():
    assert hash_port("paper") != hash_port("paper_db")


def test_papers_distinct():
    assert hash_port("paper_a") != hash_port("paper_b")


def test_script_outputs_two_ports():
    out = subprocess.check_output([sys.executable, SCRIPT, "example"]).decode()
    hub, db = out.split()
    assert hub == str(hash_port("example"))
    assert db == str(hash_port("example_db"))
