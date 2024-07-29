FROM datajoint/mysql:8.0

COPY config/entrypoint_db.sh /entrypoint_db.sh
ADD export_files /docker-entrypoint-initdb.d

CMD ["/bin/bash", "/entrypoint_db.sh"]
