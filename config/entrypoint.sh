#!/bin/bash
set -e

# Removing pass below sets a custom url for the jupyterhub
# I don't want users to have to access docker logs for that info
# How do I disable the security token? Maybe single user mode?
# hash generated with 'tutorial' password

start-notebook.py \
  --IdentityProvider.token=''
#   --config /etc/jupyterhub/jupyterhub_config.py \
#   --allow-root \
#   --NotebookApp.password='argon2:$argon2id$v=19$m=10240,t=10,p=8$RJ+UKCjiuik44ak6cHxmuQ$ODf4oQkiHRFmhlqAujAfxR7lGOczgGTFBCZa2PDSsB8'

# start-singleuser.py \
  # --NotebookApp.password='argon2:$argon2id$v=19$m=10240,t=10,p=8$RJ+UKCjiuik44ak6cHxmuQ$ODf4oQkiHRFmhlqAujAfxR7lGOczgGTFBCZa2PDSsB8'

# start-singleuser.py
#   --config /etc/jupyterhub/jupyterhub_config.py


