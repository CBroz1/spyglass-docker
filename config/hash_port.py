import hashlib
import sys


def hash_port(key: str) -> int:
    h = hashlib.sha256(key.encode()).hexdigest()
    return 10240 + (int(h, 16) % 49761)


if __name__ == "__main__":
    paper_id = sys.argv[1]
    print(hash_port(paper_id), hash_port(f"{paper_id}_db"))
