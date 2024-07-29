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

# Install conda env if not already present then run entrypoint_hub.sh
ARG PAPER_ID
ARG NB_USER
ARG USER_DIR
ARG SPYGLASS_BASE_DIR
ARG SPYGLASS_PAPER_DIR
COPY config/entrypoint.py /entrypoint.py
COPY config/entrypoint_hub.sh /entrypoint_hub.sh
COPY export_files/environment.yml /environment.yml
RUN conda update conda -y \
  && conda init bash \
  && mamba env create -f /environment.yml \
  && echo "source activate ${PAPER_ID}" >> ~/.bashrc \
  && conda run -n ${PAPER_ID} python /entrypoint.py
ENV PATH=/opt/conda/envs/${PAPER_ID}/bin:$PATH
# RUN conda init bash
# RUN mamba env update -f /environment.yml
# RUN echo "source activate ${PAPER_ID}" >> ~/.bashrc
# RUN conda run -n ${PAPER_ID} python /entrypoint.py
# ENV PATH=/opt/conda/envs/${PAPER_ID}/bin:$PATH
# RUN echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc
# RUN echo "conda activate ${PAPER_ID}" >> ~/.bashrc
# SHELL ["conda", "run", "--no-capture-output", "-n", "${PAPER_ID}", "/bin/bash", "-c"]
# RUN /bin/bash -c "/entrypoint_hub.sh"
# Activate shell for conda to work
# SHELL ["/bin/bash", "-c"]
# ENV PATH=/opt/conda/envs/${PAPER_ID}/bin:$PATH

# Adjust dj config to match env vars
# COPY config/entrypoint.py /entrypoint.py
# COPY config/entrypoint_hub.sh /entrypoint_hub.sh
# RUN /entrypoint_hub.sh
# RUN /bin/bash -c "source ~/.bashrc \
#   && conda init bash \
#   && conda activate ${PAPER_ID} \
#   && python -m ipykernel install --user --name=${PAPER_ID} \
#   && python /entrypoint.py"

# RUN conda init bash \
#   && conda activate ${PAPER_ID} \
# RUN python -m ipykernel install --user --name=${PAPER_ID} \
#   && python /entrypoint.py
# RUN \
#   conda run -n ${PAPER_ID} "python -m ipykernel install --user --name=${PAPER_ID}" \
#   && conda run -n ${PAPER_ID} python /entrypoint.py


