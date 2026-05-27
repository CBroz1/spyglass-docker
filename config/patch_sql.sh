#!/usr/bin/env bash
set -euo pipefail

DIR="${1:-./export_files}"
CONDA_ENV="${SPYGLASS_CONDA_ENV:-spyglass}"
conda run -n "$CONDA_ENV" python "$(dirname "$0")/patch_sql.py" "$DIR"
