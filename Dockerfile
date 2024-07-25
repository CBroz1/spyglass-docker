FROM quay.io/jupyter/base-notebook

USER root

# Allow sudo - REMOVE LATER
RUN echo "jovyan:jovyanpassword" | chpasswd
RUN echo "jovyan ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/jovyan

# Add mysql credentials - REMOVE creds later, keep encoding
ARG MYSQL_HOST
ARG MYSQL_USER
ARG MYSQL_PASSWORD
RUN echo -e "\
[client]\n\
host=${MYSQL_HOST}\n\
user=${MYSQL_USER}\n\
password=${MYSQL_PASSWORD}\n\n\
[mysqld]\n\
character-set-server = latin1\n\
collation-server = latin1_swedish_ci" > ${HOME}/.my.cnf

# copy dj config, ensure user owned
RUN mkdir -p ${HOME}
COPY config/.datajoint_config.json ${HOME}/.datajoint_config.json
RUN chown ${NB_UID} ${HOME}/.datajoint_config.json

# copy sql files - delay loading while db builds
COPY export_files/*sql /
COPY config/entrypoint_db.sh /entrypoint_db.sh
RUN apt update && apt install mysql-client git vim -y # REMOVE?
RUN rm -rf /var/lib/apt/lists/* # REDUCE IMAGE SIZE

USER ${NB_UID}

ARG PAPER_ID
ARG SPYGLASS_PAPER_DIR
COPY export_files/environment.yml /environment.yml
RUN if ! conda env list | grep -q ${PAPER_ID}; \
  then mamba env create -f /environment.yml; fi \
  && conda init bash \
  && echo "conda activate ${PAPER_ID}" >> ~/.bashrc
# Activate shell for conda to work
SHELL ["/bin/bash", "-c"]

# Install latest spyglass? No, want specific version
# git clone --branch <tag_name> # Where to load from?
RUN if [! -d "${HOME}/spyglass/" ]; then \
  git clone https://github.com/LorenFrankLab/spyglass.git; fi
  # && pip install -e spyglass # REMOVE -e LATER

# Adjust dj config to match env vars
COPY config/entrypoint.py /entrypoint.py
RUN \
  # python -m ipykernel install --user --name=${PAPER_ID} \
  conda run -n ${PAPER_ID} python /entrypoint.py

# load mysql dump files
# RUN /entrypoint_db.sh

# next step: entrypoint.sh
