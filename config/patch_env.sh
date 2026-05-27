#!/usr/bin/env bash
set -euo pipefail

YML="${1:-./export_files/environment.yml}"
if [ ! -f "$YML" ]; then
    echo "patch_env.sh: $YML not found" >&2
    exit 1
fi

CONDA_ENV="${SPYGLASS_CONDA_ENV:-spyglass}"
conda run -n "$CONDA_ENV" python "$(dirname "$0")/patch_env.py" "$YML"
