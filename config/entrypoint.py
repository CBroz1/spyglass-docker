"""Adjust datajoint config and environment variables for the container.

Not necessary if the user is always 'jovyan'.
"""

import os
from sys import exit as sys_exit

import datajoint as dj

if os.getenv("NB_USER") == "jovyan":
    sys_exit(0)

# This is unnecessary if the user is always 'jovyan'
user_dir = os.getenv("USER_DIR", "/home/jovyan")
base_dir = os.getenv("SPYGLASS_BASE_DIR", "/home/jovyan/data")

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
