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
# Fallback if SPYGLASS_VOLUME_DIR not set in .env
SPYGLASS_VOLUME_DIR ?= $(SPYGLASS_PAPER_DIR)/volumes
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

# Helpers
DOCKER_EXEC_SH = docker exec -it ${PAPER_ID}_hub /bin/bash -c
DOCKER_EXEC_SQL = docker exec -it ${PAPER_ID}_hub mysql -e

# Check for .env file
check_env:
	@if [ ! -f .env ]; then \
			echo ".env file not found!"; \
			echo "Please copy example.env to .env and fill in the required values."; \
			exit 1; \
	fi

# Copy files from the paper directory to the export_files directory
# Edit CHARSET, COLLATE, and VARCHAR length
copy_files:
	@cp -f ${SPYGLASS_PAPER_DIR}/environment.yml ./export_files/
	@SPYGLASS_CONDA_ENV=$(SPYGLASS_CONDA_ENV) bash ./config/patch_env.sh ./export_files/environment.yml
	@cp -rf ${SPYGLASS_PAPER_DIR}/*sql ./export_files/
	@SPYGLASS_CONDA_ENV=$(SPYGLASS_CONDA_ENV) bash ./config/patch_sql.sh ./export_files/

# Stop containers without removing them
stop:
	@docker stop ${PAPER_ID}_hub 2>/dev/null || true
	@docker stop ${PAPER_ID}_db  2>/dev/null || true

# Stop and remove containers (preserves volumes)
remove: stop
	@docker rm ${PAPER_ID}_hub 2>/dev/null || true
	@docker rm ${PAPER_ID}_db  2>/dev/null || true

# Stop and remove containers and all associated volumes (full teardown)
clean: remove
	@docker volume rm ${PAPER_ID}_conda ${PAPER_ID}_notebooks ${PAPER_ID}_db_data 2>/dev/null || true
	@rm -rf $(SPYGLASS_VOLUME_DIR)/conda $(SPYGLASS_VOLUME_DIR)/notebooks $(SPYGLASS_VOLUME_DIR)/db_data 2>/dev/null || true

# Build the container, run sanity check ls
only_up: # needs timeout and error message
	@mkdir -p $(SPYGLASS_VOLUME_DIR)/conda $(SPYGLASS_VOLUME_DIR)/notebooks $(SPYGLASS_VOLUME_DIR)/db_data
	@docker compose up --build -d -t 300; \
	exit_status=$$?; \
	if [ $$exit_status -ne 0 ]; then \
		echo "Container failed."; \
		echo "Please check which container is not running (${PAPER_ID}_hub or ${PAPER_ID}_db)"; \
		echo "And run 'docker logs <container_name>' to see the error message."; \
		exit 1; \
	fi; \
	echo ""; \
	echo "JupyterLab available at: http://localhost:$(SPYGLASS_HUB_PORT)/lab"; \
	echo "Password: ${PAPER_ID}"


# Enter the container
only_enter:
	@docker exec -it ${PAPER_ID}_hub /bin/bash

# Rebuild hub image only, skipping copy_files and teardown (for debugging)
quick-build: check_env
	@docker compose up --build -d -t 300 hub

# Print the JupyterLab URL for this paper
port:
	@echo "http://localhost:$(SPYGLASS_HUB_PORT)/lab"

# Publish to docker hub
publish:
	@docker login
	@docker build -f Docker_hub.Dockerfile . -t ${HUB_IMAGE_NAME}:latest
	@docker build -f Docker_db.Dockerfile . -t ${DB_IMAGE_NAME}:latest
	@docker push ${HUB_IMAGE_NAME}:latest
	@docker push ${DB_IMAGE_NAME}:latest

# Run the published container
only_run:
	@mkdir -p $(SPYGLASS_VOLUME_DIR)/conda $(SPYGLASS_VOLUME_DIR)/notebooks $(SPYGLASS_VOLUME_DIR)/db_data
	@docker compose -f docker-compose-collab.yml up -d
