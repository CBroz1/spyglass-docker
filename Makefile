.PHONY: stop remove clean port quick-build
build: up
up: check_env copy_files remove only_up
enter: check_env copy_files remove only_up only_enter
run: check_env only_run

# Include .env file (-include: no error if missing; check_env prints a friendly message)
-include .env

export DOCKER_BUILDKIT := 1

# Fallback if SPYGLASS_CONDA_ENV not set in .env
SPYGLASS_CONDA_ENV ?= spyglass

# Normalize path variables. Make treats '#' as a comment when parsing .env, so
#   SPYGLASS_BASE_DIR=/path/ # note
# becomes '/path/ ' (trailing slash + space), corrupting any derived paths.
# SPYGLASS_BASE_DIR: strip trailing slashes and spaces.
override SPYGLASS_BASE_DIR := $(patsubst %/,%,$(strip $(SPYGLASS_BASE_DIR)))
# SPYGLASS_PAPER_DIR: uses recursive '=' in .env so it re-expands SPYGLASS_BASE_DIR
# at use time — the override above already fixes the common derived case.
# The ?= provides a fallback when .env omits it entirely.
SPYGLASS_PAPER_DIR  ?= $(SPYGLASS_BASE_DIR)/export/$(strip $(PAPER_ID))
override SPYGLASS_PAPER_DIR := $(patsubst %/,%,$(strip $(SPYGLASS_PAPER_DIR)))
# SPYGLASS_VOLUME_DIR: same treatment; its own inline comment can leave a trailing space.
SPYGLASS_VOLUME_DIR ?= $(SPYGLASS_PAPER_DIR)/volumes
override SPYGLASS_VOLUME_DIR := $(patsubst %/,%,$(strip $(SPYGLASS_VOLUME_DIR)))
export SPYGLASS_VOLUME_DIR

# Derive per-paper ports from PAPER_ID (SHA-256, range 10240-60000, ~0.006% collision at 3 concurrent users)
# Skip if already set in environment (allows callers to override ports)
# Use = (deferred) so conda run only executes when a target actually needs the ports
ifndef SPYGLASS_HUB_PORT
_PORTS            = $(shell conda run -n $(SPYGLASS_CONDA_ENV) python ./config/hash_port.py "$(PAPER_ID)")
SPYGLASS_HUB_PORT = $(word 1,$(_PORTS))
SPYGLASS_DB_PORT  = $(word 2,$(_PORTS))
endif
export SPYGLASS_HUB_PORT
export SPYGLASS_DB_PORT

# Prefix docker commands with sudo when SUDO_DOCKER=1 in .env
DOCKER      := $(if $(filter 1,$(SUDO_DOCKER)),sudo docker,docker)
DOCKER_COMP := $(DOCKER) compose

DOCKER_EXEC_SH  = $(DOCKER) exec -it ${PAPER_ID}_hub /bin/bash -c
DOCKER_EXEC_SQL = $(DOCKER) exec -it ${PAPER_ID}_hub mysql -e

# Check for .env file and required keys
# Optional keys (have fallbacks): SPYGLASS_CONDA_ENV, SPYGLASS_VOLUME_DIR, JUPYTER_SERVER_APP_PASSWORD
check_env:
	@if [ ! -f .env ]; then \
		echo ".env file not found!"; \
		echo "Please copy example.env to .env and fill in the required values."; \
		exit 1; \
	fi
	@missing=""; \
	for key in PAPER_ID SPYGLASS_BASE_DIR DOCKER_HUB_USER MYSQL_ROOT_PASSWORD; do \
		grep -q "^$$key=." .env || missing="$$missing $$key"; \
	done; \
	if [ -n "$$missing" ]; then \
		echo "Missing required keys in .env:$$missing"; \
		exit 1; \
	fi

# Copy files from the paper directory to the export_files directory
# Edit CHARSET, COLLATE, and VARCHAR length
copy_files:
	@if [ ! -d "$(SPYGLASS_PAPER_DIR)" ]; then \
		echo "Error: export directory not found: $(SPYGLASS_PAPER_DIR)"; \
		echo "Regenerate it from your spyglass database with:"; \
		echo "  from spyglass.common import Export"; \
		echo "  Export().populate_paper(paper_id='$(PAPER_ID)')"; \
		exit 1; \
	fi
	@cp -f ${SPYGLASS_PAPER_DIR}/environment.yml ./export_files/
	@SPYGLASS_CONDA_ENV=$(SPYGLASS_CONDA_ENV) bash ./config/patch_env.sh ./export_files/environment.yml
	@cp -rf ${SPYGLASS_PAPER_DIR}/*sql ./export_files/
	@SPYGLASS_CONDA_ENV=$(SPYGLASS_CONDA_ENV) bash ./config/patch_sql.sh ./export_files/
	@conda run -n $(SPYGLASS_CONDA_ENV) python config/check_key_length.py export_files/ || true

# Stop containers without removing them
stop:
	@$(DOCKER) stop ${PAPER_ID}_hub 2>/dev/null || true
	@$(DOCKER) stop ${PAPER_ID}_db  2>/dev/null || true

# Stop and remove containers (preserves volumes)
remove: stop
	@$(DOCKER) rm ${PAPER_ID}_hub 2>/dev/null || true
	@$(DOCKER) rm ${PAPER_ID}_db  2>/dev/null || true

# Stop and remove containers and all associated volumes (full teardown)
clean: remove
	@$(DOCKER) volume rm ${PAPER_ID}_conda ${PAPER_ID}_notebooks ${PAPER_ID}_db_data 2>/dev/null || true
	@rm -rf $(SPYGLASS_VOLUME_DIR)/conda $(SPYGLASS_VOLUME_DIR)/notebooks $(SPYGLASS_VOLUME_DIR)/db_data 2>/dev/null || true

# Build the container, run sanity check ls
only_up: # needs timeout and error message
	@mkdir -p $(SPYGLASS_VOLUME_DIR)/conda $(SPYGLASS_VOLUME_DIR)/notebooks $(SPYGLASS_VOLUME_DIR)/db_data
	@$(DOCKER_COMP) up --build -d -t 300; \
	exit_status=$$?; \
	if [ $$exit_status -ne 0 ]; then \
		echo "Container failed."; \
		echo "Please check which container is not running (${PAPER_ID}_hub or ${PAPER_ID}_db)"; \
		echo "And run '$(DOCKER) logs <container_name>' to see the error message."; \
		exit 1; \
	fi; \
	echo ""; \
	echo "JupyterLab available at: http://localhost:$(SPYGLASS_HUB_PORT)/lab"; \
	echo "Password: ${PAPER_ID}"


# Enter the container
only_enter:
	@$(DOCKER) exec -it ${PAPER_ID}_hub /bin/bash

# Rebuild hub image only, skipping copy_files and teardown (for debugging)
quick-build: check_env
	@$(DOCKER_COMP) up --build -d -t 300 hub

# Print the JupyterLab URL for this paper
port:
	@echo "http://localhost:$(SPYGLASS_HUB_PORT)/lab"

# Publish to docker hub
publish:
	@$(DOCKER) login
	@$(DOCKER) build -f Docker_hub.Dockerfile . -t ${HUB_IMAGE_NAME}:latest
	@$(DOCKER) build -f Docker_db.Dockerfile . -t ${DB_IMAGE_NAME}:latest
	@$(DOCKER) push ${HUB_IMAGE_NAME}:latest
	@$(DOCKER) push ${DB_IMAGE_NAME}:latest

# Run the published container
only_run:
	@mkdir -p $(SPYGLASS_VOLUME_DIR)/conda $(SPYGLASS_VOLUME_DIR)/notebooks $(SPYGLASS_VOLUME_DIR)/db_data
	@$(DOCKER_COMP) -f docker-compose-collab.yml up -d
