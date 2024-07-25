"""Adapted from github.com/datajoint/djlabhub-docker"""

import os
import pwd

from traitlets.config import Config

c = Config() if "c" not in locals() else c

user = [u for u in pwd.getpwall() if u.pw_uid == os.getuid()][0]


# Use environment variables for database configuration
db_host = os.getenv("DB_HOST", "db")
db_name = os.getenv("MYSQL_DATABASE", "common_session")
db_user = os.getenv("MYSQL_USER", "root")
db_password = os.getenv("MYSQL_ROOT_PASSWORD", "tutorial")

# Database connection string
c.JupyterHub.db_url = (
    f"mysql+mysqlconnector://{db_user}:{db_password}@{db_host}/{db_name}"
)

c.JupyterHub.allow_named_servers = True
