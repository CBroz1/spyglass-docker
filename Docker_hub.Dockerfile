# syntax=docker/dockerfile:1
FROM quay.io/jupyter/base-notebook

USER root

# copy dj config, ensure user owned
RUN mkdir -p ${HOME}/.jupyter
COPY config/.datajoint_config.json ${HOME}/.datajoint_config.json
COPY config/jupyter_server_config.py ${HOME}/.jupyter/jupyter_server_config.py
RUN chown ${NB_UID} \
  ${HOME}/.datajoint_config.json \
  ${HOME}/.jupyter/jupyter_server_config.py

# Install git for convenience and others for position pipeline
RUN apt-get update \
  && apt-get install -y \
    git \
    ffmpeg \
    libsm6 \
    libxext6 \
    build-essential \
    g++ \
    libgl1 \
    libglib2.0-0 \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

USER ${NB_UID}

# Install conda env if not already present
ARG PAPER_ID
COPY export_files/environment.yml /tmp/environment.yml
RUN --mount=type=cache,target=/opt/conda/pkgs,uid=1000 \
    --mount=type=cache,target=/home/jovyan/.cache/pip,uid=1000 \
    --mount=type=cache,target=/home/jovyan/.cache/conda,uid=1000 \
    conda update conda -y \
  && conda init bash \
  && mamba env create -f /tmp/environment.yml \
  && mamba install -n ${PAPER_ID} -y ipykernel \
  # To drop GPU-only packages pulled in by transitive deps, uncomment:
  # && mamba remove -n ${PAPER_ID} --force -y jax jaxlib
  && echo "conda activate ${PAPER_ID}" >> ~/.bashrc
ENV PATH=/opt/conda/envs/${PAPER_ID}/bin:$PATH

ADD --chown=${NB_UID}:${NB_GID} notebooks ${HOME}/notebooks/

RUN python -m ipykernel install --user --name ${PAPER_ID} --display-name "Python (${PAPER_ID})"
