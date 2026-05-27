import re
import sys
from pathlib import Path


COLLATION = [
    (r" DEFAULT CHARSET=\S+", ""),
    (r" DEFAULT COLLATE \S+", ""),
]

# Key length reductions: field -> (old_size, new_size)
# Mirrors spyglass PR #664
KEY_LENGTHS = {
    "nwb_file_name": (255, 64),
    "analysis_file_name": (255, 64),
    "interval_list_name": (200, 170),
    "position_info_param_name": (80, 32),
    "mark_param_name": (80, 32),
    "artifact_removed_interval_list_name": (200, 128),
    "metric_params_name": (200, 64),
    "auto_curation_params_name": (200, 36),
    "sort_interval_name": (200, 64),
    "preproc_params_name": (200, 32),
    "sorter": (200, 32),
    "sorter_params_name": (200, 64),
}


def _build_patterns():
    subs = [(re.compile(p), r) for p, r in COLLATION]
    for field, (old, new) in KEY_LENGTHS.items():
        subs.append(
            (
                re.compile(rf" (`{field}`) varchar\({old}\)"),
                rf" \1 varchar({new})",
            )
        )
    return subs


PATTERNS = _build_patterns()


def patch(text: str) -> str:
    for pattern, repl in PATTERNS:
        text = pattern.sub(repl, text)
    return text


if __name__ == "__main__":
    for path in sorted(Path(sys.argv[1]).glob("*.sql")):
        path.write_text(patch(path.read_text()))
        print(f"patch_sql.py: patched {path}")
