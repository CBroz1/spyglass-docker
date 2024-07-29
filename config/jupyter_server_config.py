import os

from jupyter_server.auth import passwd

c = get_config()

# Set default kernel to the paper_id
paper_id = os.getenv("PAPER_ID", "password")
c.NotebookApp.default_kernel_name = paper_id

# Set the password for the Jupyter server
hash = passwd(os.getenv("JUPYTER_SERVER_APP_PASSWORD", paper_id))
c.ServerApp.password = hash
