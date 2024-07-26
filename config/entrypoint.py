"""Adjust datajoint config and environment variables for the container.

UNUSED
"""

import os

import datajoint as dj

# This is unnecessary if the user is always 'jovyan'
base_dir = os.getenv("SPYGLASS_BASE_DIR", "/home/jovyan/data")
user_dir = os.getenv("USER_DIR", "/home/jovyan")

dj.config.load(f"{user_dir}/.datajoint_config.json")
dj.config["custom"] = {"spyglass_dirs": {"base_dir": base_dir}}
dj.config["stores"] = {
    "analysis": {
        "protocol": "file",
        "location": f"{base_dir}/analysis",
        "stage": f"{base_dir}/analysis",
    },
    "raw": {
        "protocol": "file",
        "location": f"{base_dir}/raw",
        "stage": f"{base_dir}/raw",
    },
}
dj.config.save_global()
