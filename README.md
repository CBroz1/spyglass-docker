# Dockerizing a Spyglass Export

## Quick Start

1. Install [Docker](https://docs.docker.com/get-docker/) and register for
   Docker Hub.
1. Clone this repository.
1. Copy `env.example` to `.env` and edit the values.
1. Copy paper notebooks to `notebooks/`.
1. Run `make build` to build the docker image.
1. Navigate to `http://localhost:8888/lab`. Passwort is the paper ID.
1. Test the notebooks.
1. TBD: Run `make publish` to publish the image.

## Overview

<!--TODO: REMOVE UNUSED FILES -->
NOTE: Additional files not mentoned in this README are for development not
currently in use.
<!-- TODO: TEMPLATE REPOSITORY -->

- `Makefile`: Contains commands for building and publishing the docker image.
  - `copy_files`: Copies the export `sql` and `yml` files to the
    `export_data/` directory.
  - `down`: Stops and removes existing docker containers.
  - `up`: Runs `down`, then starts the docker container.
  - `enter`: Enters the running docker container for debugging.
- `docker-compose.yml`: Defines the docker containers and volumes.
  - `db`: MySQL database container.
  - `hub`: Jupyter notebook server container.
- `Dockerfile`: Adds additional instructions to the `hub` container.
- `config`: Contains additional configuration files.
  - `.datajoint_config.py`: Configures the datajoint connection.
  - `entrypoint_db.sh`: Loads exported `sql` files.
  - `jupyter_server_config.py`: Configures the jupyter notebook server, setting
      the default kernel to the paper's conda environment, and setting the
      password to the server.

## Security

This repository is intended for use in a secure environment. It is not intended
for use in a production environment.

By default the jupyter notebook server password is the paper ID variable.

## Troubleshooting

### Table Declaration

If you see `OperationalError` when trying to import a table that may not be
in your exported `sql` file, you may need to remove the charset sepecifications.
This can be done with the following command(s) for each `sql` file:

```bash
sed -i 's/ DEFAULT CHARSET=[^ ]\w*//g' _Populate_YourPaper.sql
sed -i 's/ DEFAULT COLLATE [^ ]\w*//g' _Populate_YourPaper.sql
```

<details><summary>What will this do?</summary>

These `sed` commands remove encoding specifications from the `sql` file(s).

```sql
CREATE TABLE your_table (
    ...
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE swedish_latin=ci COMMENT='X';
```

Will become:

```sql
CREATE TABLE your_table (
    ...
) ENGINE=InnoDB COMMENT='X';
```

The line with `ENGINE=InnoDB` should always end in `;`. It may or may not have
a `COMMENT` field.

</details>
