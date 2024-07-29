FROM quay.io/jupyter/base-notebook

USER root

# copy dj config, ensure user owned
RUN mkdir -p ${HOME}/.jupyter
COPY config/.datajoint_config.json ${HOME}/.datajoint_config.json
COPY config/jupyter_server_config.py ${HOME}/.jupyter/jupyter_server_config.py
RUN chown ${NB_UID} \
  ${HOME}/.datajoint_config.json \
  ${HOME}/.jupyter/jupyter_server_config.py

RUN apt update && apt install git -y
RUN rm -rf /var/lib/apt/lists/* # REDUCE IMAGE SIZE

USER ${NB_UID}

# Install conda env if not already present then run entrypoint.py
ARG PAPER_ID
COPY export_files/environment.yml /environment.yml
RUN conda update conda -y \
  && conda init bash \
  && mamba env create -f /environment.yml \
  && echo "source activate ${PAPER_ID}" >> ~/.bashrc
ENV PATH=/opt/conda/envs/${PAPER_ID}/bin:$PATH

ADD --chown=${NB_UID}:${NB_GID} notebooks ${HOME}/notebooks/

