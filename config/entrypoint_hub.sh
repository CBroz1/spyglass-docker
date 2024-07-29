#!/bin/bash --login

set -e

# conda activate ${PAPER_ID}

pip install ipykernel
python -m ipykernel install --user --name=${PAPER_ID}
python /entrypoint.py
