#!/bin/bash

DB_USER=${POSTGRES_USER}
DB_PASS=${POSTGRES_PASSWORD}
DB_HOST=${POSTGRES_HOST}
DB_NAME=${POSTGRES_DB}

# Creating the Admin user and initializing the metadata DB
superset fab create-admin \
    --username admin \
    --firstname Superset \
    --lastname Admin \
    --email admin@superset.com \
    --password admin

superset db upgrade
superset init

# Connection to the database
superset set-database-uri \
    --database-name $DB_NAME \
    --uri "postgresql+psycopg2://$DB_USER:$DB_PASS@$DB_HOST:5432/$DB_NAME"

# Configuration for dashboard import
cat > /app/superset_init/dashboard_export_20251014T004701/databases/$DB_NAME.yaml <<EOL
database_name: $DB_NAME
sqlalchemy_uri: "postgresql+psycopg2://$DB_USER:$DB_PASS@$DB_HOST:5432/$DB_NAME"
cache_timeout: null
expose_in_sqllab: true
allow_run_async: false
allow_ctas: false
allow_cvas: false
allow_dml: false
allow_file_upload: false
extra:
  metadata_params: {}
  engine_params: {}
  metadata_cache_timeout: {}
  schemas_allowed_for_file_upload: []
impersonate_user: false
uuid: 827a0890-ed76-4d44-9fc7-73c44c849a16
version: 1.0.0
EOL

cd /app/superset_init/
zip -r dashboard_export.zip dashboard_export_20251014T004701/

# Importing the dashboard
superset import-dashboards -p /app/superset_init/dashboard_export.zip -u admin

# Start Superset
superset run -h 0.0.0.0 -p 8088
