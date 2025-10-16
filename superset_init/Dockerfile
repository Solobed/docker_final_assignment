
FROM apache/superset:latest-dev

USER root
# 1. Mettre à jour la liste des paquets et installer 'zip' et 'unzip'
RUN apt-get update && \
    apt-get install -y zip unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY . /app/superset_init

COPY superset_init.sh /app/superset_init/superset_init.sh
RUN chmod +x /app/superset_init/superset_init.sh
RUN chmod -R 777 /app/superset_init

USER superset
ENTRYPOINT ["/app/superset_init/superset_init.sh"]
