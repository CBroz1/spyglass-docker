import re
import sys
from pathlib import Path


def patch(text: str) -> str:
    # spyglass-neuro==X.Y.Z[pre]+g<sha>[.d<date>] -> git+...@<sha>
    text = re.sub(
        r"spyglass-neuro==[^\s+]+\+g([0-9a-f]+)[^\s]*",
        r"spyglass-neuro @ git+https://github.com/LorenFrankLab/spyglass@\1",
        text,
    )
    # Drop host-specific prefix line
    text = re.sub(r"^prefix:.*\n", "", text, flags=re.MULTILINE)
    return text


if __name__ == "__main__":
    path = Path(sys.argv[1])
    path.write_text(patch(path.read_text()))
    print(f"patch_env.py: patched {path}")
