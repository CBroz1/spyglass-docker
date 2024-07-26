import os

from jupyter_server.auth import passwd

paper_id = os.getenv("PAPER_ID", "python3")

c = get_config()

c.NotebookApp.default_kernel_name = paper_id

hash = passwd(os.getenv("JUPYTER_SERVER_APP_PASSWORD", "password"))
c.ServerApp.password = hash
