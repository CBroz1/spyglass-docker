# Dockerizing a Spyglass Export

## About

[Spyglass](lorenfranklab.github.io/spyglass/) is an open-source framework for
managing and analyzing data in neuroscience research. The Export feature allows
users to generate scripts[^1] to recreate both their conda environmen and the
database, as well as upload data to [DANDI Archive](https://dandiarchive.org/).

This repository is intended to be used with the
[Docker](https://www.docker.com/) to create and share a reproducible environment
for replicating a paper's analyses.

## Quick Start

01. Pre-requisites: `make`, `docker`, Docker Compose v2, and `conda`.
    - `make` is available on most Unix systems as part of
      [GNU Make](https://www.gnu.org/software/make/), or available with `choco`
      (Windows) or `brew` (macOS).
    - [Docker](https://docs.docker.com/get-docker/) builds, runs, and manages
      containers. Docker Compose v2 is required (`docker compose`, not
      `docker-compose`). It ships with Docker Desktop and Docker Engine ≥ 20.10.
      Verify with: `docker compose version`. BuildKit is also required; it is
      enabled by default in Docker Desktop and Docker Engine ≥ 23. Verify with:
      `docker buildx version`.
    - `conda` (e.g. [Miniforge](https://github.com/conda-forge/miniforge)) with
      a working environment. The default environment name is `spyglass`; set
      `SPYGLASS_CONDA_ENV` in `.env` to use a different name.
02. Register for [Docker Hub](https://hub.docker.com/signup) and run
    `docker login`.
03. Clone this repository to your local machine.
04. Copy `example.env` to `.env` and edit the values. On systems that require
    `sudo` to run Docker (common on shared Linux servers), set `SUDO_DOCKER=1`.
05. Copy the paper's notebooks to `notebooks/`[^2].
06. If the build fails due to GPU-only packages (e.g. `jax`, `jaxlib`), remove
    them from `${SPYGLASS_PAPER_DIR}/environment.yml`. Edits must be made to the
    source file — `make build` overwrites `export_files/environment.yml` on every
    run, so changes there are lost on rebuild. If GPU packages are pulled in as
    transitive dependencies (e.g. via `non_local_detector`), removing them from
    `environment.yml` won't help; instead, uncomment the `mamba remove` line in
    `Docker_hub.Dockerfile` to strip them after install (see [Speed](#speed)).
07. Run `make build` to build the docker image. This can take 20–40 minutes the
    first time. When complete, the JupyterLab URL will be printed automatically.
    Run `make port` at any time to reprint it.
08. Navigate to the printed URL (e.g. `http://localhost:12345/lab`), using the
    paper ID as the password. Wait ~30 seconds after build for the server to
    start.
09. Test the notebooks.
10. When finished, run `make stop` to pause, `make remove` to stop and remove
    containers, or `make clean` to remove all cached data (see
    [Teardown](#teardown)).
11. Run `make publish` to publish the image.
12. Share the image with collaborators, who can run `make run` to start the
    container and visit the same URL (run `make port` to get it). When finished,
    they should run `make stop`, `make remove`, or `make clean`. They will need
    ...
    1. The `.env` file you used.
    2. The `docker-compose-collab.yml` file for building from the published
       images.
    3. The `Makefile` for the command to run the container from the published
       images.

## Overview

- `Makefile`: Contains commands for building and publishing the docker image.
  - `copy_files`: Copies the export `sql` and `yml` files to the `export_files/`
    directory.
  - `stop`: Stops containers without removing them.
  - `remove`: Runs `stop`, then removes containers (preserves volumes).
  - `clean`: Runs `remove`, then removes all associated Docker volumes (full
    teardown).
  - `up`: Runs `remove`, then starts the docker container.
  - `build`: Alias for `up`.
  - `enter`: Enters the running docker container for debugging.
  - `port`: Prints the JupyterLab URL for this paper.
- `docker-compose.yaml`: Defines the docker containers and volumes.
  - `db`: Service. MySQL database container.
  - `hub`: Service. Jupyter notebook server container.
  - `${PAPER_ID}_conda`: Volume. Cache of the hub's conda environment.
  - `${PAPER_ID}_db_data`: Volume. Cache of the database's data.
- `docker-compose-collab.yml`: Similar to `docker-compose.yaml`, but using the
  `hub` image from Docker Hub. This file is intended for collaborators.
- `Docker_hub.Dockerfile`: Adds additional instructions to the `hub` container.
  - Copies in datajoint and jupyter configuration files.
  - Installs `git` for possible git installs in the conda environment. For a
    faster build time, remove this line if no such installs are needed.
  - Installs the paper's conda environment.
  - Runs `entrypoint.py` to configure the datajoint connection.
- `example.env`: Example environment variables for the `.env` file. Must be
  copied to `.env` and edited. Key optional flags:
  - `SUDO_DOCKER=1` — prefix all Docker commands with `sudo`. Set this on
    shared Linux servers where Docker requires elevated privileges.
  - `DANDI_API_KEY` — required only for embargoed DANDI datasets.
- `config`: Contains additional configuration files.
  - `.datajoint_config.py`: Default configuration for the datajoint connection.
  - `entrypoint.py`: Edits the datajoint config based on environment variables.
  - `entrypoint_db.sh`: Loads exported `sql` files. Run my the `db` service.
  - `jupyter_server_config.py`: Configures the jupyter notebook server. - Sets
    the default kernel to the paper's conda environment. - Sets the server
    password.

## Speed

The first time you run `make build`, the docker image will be built from
scratch. This can take a while, depending on the size of the conda environment.
Subsequent builds will be faster, as docker will cache the layers.

To speed up the process, projects that do not use the position pipeline can
remove the line in `Docker_hub.Dockerfile` that installs `ffmpeg` and other
dependencies.

If your build is still slow, or errors with conflicting packages, try removing
unnecessary packages from your conda `environment.yml` file. Note that running
`make build` will copy the file from its original location.

## Security

This repository is intended for use in a secure environment. It is not intended
for use in a production environment.

By default the jupyter notebook server password is the paper ID variable.

## Teardown

There are three levels of teardown depending on how much you want to free.

| Command       | Stops containers | Removes containers | Removes volumes |
| ------------- | :--------------: | :----------------: | :-------------: |
| `make stop`   |        ✓         |                    |                 |
| `make remove` |        ✓         |         ✓          |                 |
| `make clean`  |        ✓         |         ✓          |        ✓        |

**Stopping containers** (`make stop`) frees CPU and memory but keeps containers
and volumes on disk. Restarting with `make build` or `make run` will resume
quickly, skipping the conda install and database import.

**Removing containers** (`make remove`) additionally removes the stopped
containers. Volumes are preserved, so the next `make build` or `make run` will
still skip the slow conda install and database import.

**Removing volumes** (`make clean`) frees all disk space used by this paper's
environment. The next `make build` or `make run` will rebuild from scratch,
including a full conda install (20–40 minutes).

<details><summary>What is stored in each volume?</summary>

Volume data is stored under `SPYGLASS_VOLUME_DIR` (default:
`${SPYGLASS_PAPER_DIR}/volumes`), keeping it on the same filesystem as your
paper data rather than filling up `/var/lib/docker/volumes/`. Three
subdirectories are created per paper:

- **`${PAPER_ID}_conda`** — the full conda environment (~5–15 GB depending on
  packages). Removing this means the next build re-downloads and re-installs all
  packages. Keep this if you expect to restart the container again soon.
- **`${PAPER_ID}_notebooks`** — any edits made to notebooks inside the running
  container are saved here. **Remove this only if you are sure you no longer
  need those edits**, or have saved them elsewhere.
- **`${PAPER_ID}_db_data`** — the MySQL database populated from the exported
  `.sql` files. Removing this means the next start re-imports the database from
  scratch (typically fast, a few minutes).

To inspect volume sizes before deciding:

```bash
du -sh ${SPYGLASS_VOLUME_DIR}/*/
```

</details>

## Troubleshooting

If you encounter any issues, please check the status of the docker containers
with `docker ps -a`. This will show the status of containers `${PAPER_ID}_db`
and `${PAPER_ID}_hub`. If either is 'restarting', check the logs with
`docker logs <name>`. Use `make enter` to open a shell inside the running hub
container for further debugging.

### Conda Fails

If conda environment creation fails, you may need to remove items from the
`environment.yml` that require GPU support like `jax`.

### Table Declaration, Collation

`make build` automatically patches each `.sql` file in `export_files/` via
`config/patch_sql.sh`, which removes encoding specifications to prevent
`OperationalError` and SQL `ERROR 3780 (HY000)`.

<details><summary>What does this do?</summary>

`patch_sql.sh` removes `DEFAULT CHARSET` and `DEFAULT COLLATE` clauses:

```sql
CREATE TABLE your_table (
    ...
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE swedish_latin=ci COMMENT='X';
```

Becomes:

```sql
CREATE TABLE your_table (
    ...
) ENGINE=InnoDB COMMENT='X';
```

</details>

### Table Declaration, Key Length

Spyglass instances declared before version 0.4.3 permit longer keys than MySQL
defaults allow. This causes `Excessive key length` errors on import.
`make build` automatically shortens these via `config/patch_sql.sh`, mirroring
the adjustments from
[PR #664](https://github.com/LorenFrankLab/spyglass/pull/664).

If you encounter key length errors for a column not listed in `patch_sql.sh`,
add a substitution to the `replacements` list in that file to match. Run
`python config/check_key_length.py export_files/` to scan your SQL dump for
over-limit columns and get the exact substitution to add.

### Analysis NWB Files

Notebooks that access analysis NWB files should use spyglass APIs rather than
calling DataJoint or pynwb directly.

<details><summary>Correct patterns</summary>

**Getting the file path** — `get_abs_path` uses a multi-step fallback that
works even when the export omits external-table rows:

```python
# ✗ fragile: requires the external-table row to exist in the export
path = (AnalysisNwbfile() & {"analysis_file_name": fname}).fetch1("analysis_file_abs_path")

# ✓ correct
path = AnalysisNwbfile().get_abs_path(fname)
```

**Opening a file that may only exist on DANDI** — `get_nwb_file` falls back to
DANDI streaming when the file is not present locally:

```python
# ✗ breaks when the file is not on disk
with pynwb.NWBHDF5IO(path, "r") as io:
    nwbf = io.read()

# ✓ correct: local → kachery → DANDI
from spyglass.utils.nwb_helper_fn import get_nwb_file
nwbf = get_nwb_file(path)
```

For embargoed DANDI datasets, set `DANDI_API_KEY` in `.env`.

</details>

## Elevated Access

The default hub container does not have sudo access. If you need to install
additional package or debug within the container, you may wish do the following:

<details><summary>Admin within the container</summary>

Add sudo for the default user, mysql credentials to `Docker_hub.Dockerfile`, and add
`mysql-client` to allow command line access to the database.

```Dockerfile
USER root

# Allow sudo
RUN echo "jovyan:jovyanpassword" | chpasswd
RUN echo "jovyan ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/jovyan
# Add mysql credentials - Vars must also be added to docker-compose.yml
ARG MYSQL_HOST
ARG MYSQL_USER
ARG MYSQL_ROOT_PASSWORD
# Add default mysql credentials
RUN echo -e "\
[client]\n\
host=${MYSQL_HOST}\n\
user=${MYSQL_USER}\n\
password=${MYSQL_ROOT_PASSWORD}\n\n\
[mysqld]\n\
character-set-server = latin1\n\
collation-server = latin1_swedish_ci" > ${HOME}/.my.cnf
RUN apt update && apt install mysql-client -y

USER ${NB_UID}
```

Each `ARG` item must also be added to the `docker-compose.yml` file under the
`hub` service:

```yaml
    build:
      context: .
      dockerfile: Docker_hub.Dockerfile
      args:
        MYSQL_HOST: db
        MYSQL_USER: root
        MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
```

And add `GRANT_SUDO=yes` to the `.env` file.

</details>

## For Developers

This section covers features intended for those maintaining or debugging this
repository, rather than end users running a published paper environment.

- **BuildKit cache mounts** — persists conda/pip packages across builds so
  re-running `make build` after small `environment.yml` changes doesn't
  re-download everything.
- **`make quick-build`** — rebuilds the hub image without re-copying files from
  the paper directory or tearing down running containers. Use when iterating on
  config or Dockerfile changes and `export_files/` is already up to date.
- **`make enter`** — opens a bash shell inside the running hub container. Useful
  for inspecting the conda environment, testing imports, or checking file paths.
- **Port hashing** — `PAPER_ID` is hashed (SHA-256, range 10240–60000) to assign
  unique host ports, allowing multiple papers to run concurrently on shared
  infrastructure without manual port coordination.
- **Tests** — `config/` utilities (`hash_port.py`, `patch_env.py`,
  `patch_sql.py`) are covered by a pytest suite in `test/`. Run with
  `pytest test/ -v`. A second `lint` job checks shell script syntax
  (`bash -n config/*.sh`) and validates both Docker Compose files against a stub
  `.env` (`docker compose config -q`). Both jobs run on every push and pull
  request via `.github/workflows/test.yml`; no conda environment is required
  since all utilities use the Python standard library.

<details><summary>BuildKit cache mounts</summary>

`Docker_hub.Dockerfile` uses `--mount=type=cache` on the `mamba env create`
step:

```dockerfile
RUN --mount=type=cache,target=/opt/conda/pkgs,uid=1000 \
    --mount=type=cache,target=/home/jovyan/.cache/pip,uid=1000 \
    conda update conda -y \
  && conda init bash \
  && mamba env create -f /tmp/environment.yml \
  && echo "conda activate ${PAPER_ID}" >> ~/.bashrc
```

The two cache mounts:

- `/opt/conda/pkgs` — mamba's downloaded package tarballs. Reused on the next
  build, so only changed or new packages are fetched.
- `/home/jovyan/.cache/pip` — pip's HTTP cache. Same benefit for the pip section
  of `environment.yml`.

The mounts are **host-side caches** that do not become part of the image layer —
the final image is identical to one built without them. They persist across
`make clean` (which only removes named volumes, not BuildKit cache) and are
scoped to the host's Docker cache.

Requires Docker Engine ≥ 23 or Docker Desktop (BuildKit is enabled by default).
If you see `unknown flag: --mount`, add `# syntax=docker/dockerfile:1` as the
first line of the Dockerfile and ensure BuildKit is active:
`DOCKER_BUILDKIT=1 make build`.

</details>

<details><summary>make quick-build</summary>

```
make quick-build
```

Equivalent to running `docker compose up --build -d` directly — skips the
`copy_files` step (which re-copies `environment.yml` and `.sql` files from the
paper directory) and skips `down` (which tears down running containers).

**When to use:** You've already run `make build` at least once, `export_files/`
contains the correct files, and you're iterating on changes to
`Docker_hub.Dockerfile`, `config/`, or `notebooks/` that don't require
re-exporting from the paper directory.

**When not to use:** If `environment.yml` or the `.sql` files in the paper
directory have changed since the last `make build`, run `make build` instead so
`copy_files` re-copies and patches them.

Docker's layer cache means that if `environment.yml` has not changed, the slow
mamba layer is skipped automatically — even with `make quick-build`, a cache hit
on that layer completes in seconds.

</details>

<details><summary>make enter</summary>

```
make enter
```

Note: `make enter` (no arguments) is the full build-then-enter flow. To enter an
**already-running** container without rebuilding, run:

```bash
docker exec -it ${PAPER_ID}_hub /bin/bash
```

Once inside, the paper conda environment is on `PATH`. Useful commands:

```bash
conda list                          # inspect installed packages
python -c "import spyglass"         # test an import
jupyter kernelspec list             # verify the paper kernel is registered
cat /tmp/environment.yml            # inspect the patched environment spec
```

</details>

<details><summary>Port hashing</summary>

Each paper's JupyterLab and MySQL ports are derived deterministically from
`PAPER_ID` using SHA-256:

```python
import hashlib
h = hashlib.sha256(PAPER_ID.encode()).hexdigest()
SPYGLASS_HUB_PORT = 10240 + (int(h, 16) % 49761)   # range: 10240–60000
SPYGLASS_DB_PORT  = 10240 + (int(hashlib.sha256((PAPER_ID + "_db").encode()).hexdigest(), 16) % 49761)
```

This mirrors the logic in
`spyglass/tests/container.py:DockerMySQLManager.string_to_port`. The 49,761-port
range gives a collision probability of ~0.006% at 3 concurrent users —
negligible for the expected usage of this repository.

Ports are computed in the Makefile and exported as
`SPYGLASS_HUB_PORT`/`SPYGLASS_DB_PORT` so that `docker compose` can substitute
them into `docker-compose.yaml`. Run `make port` to print the URL for the
current `PAPER_ID`.

</details>

[^1]: The `.sh` scripts generated by Spyglass must first be run by a database
    administrator to create the database and tables. The resulting `.sql` will
    then be used to populate the Docker database.

[^2]: If your paper depends on a specific version of Spyglass or additional
    custom packages, please link to these in your notebooks, and ensure they
    are included in the `environment.yml` file in the export directory. You
    can find the version of Spyglass at the top of any `.sql` file, and find
    the link in the list of
    [Spyglass tags](https://github.com/LorenFrankLab/spyglass/tags).
