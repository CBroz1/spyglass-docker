import os

paper_id = os.getenv("PAPER_ID", "python3")

c = get_config()

c.NotebookApp.default_kernel_name = paper_id
