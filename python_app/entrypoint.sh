#!/bin/bash

# Save the environment variables
printenv | grep DB_ >> /etc/environment

# Creating the dbt config file
mkdir -p /root/.dbt

cat > /root/.dbt/profiles.yml <<EOL
dbt_project:
  target: dev
  outputs:
    dev:
      type: postgres
      host: ${DB_HOST}
      user: ${DB_USER}
      password: ${DB_PASSWORD}
      port: 5432
      threads: 2
      dbname: ${DB_NAME}
      schema: public
EOL

echo "Profiles.yml generated"

# Wait for postgres
sleep 10

# First data initialization
python3 /app/main.py

echo "First data initialization"

# Launching dbt commands
dbt debug --project-dir /app/dbt_project
dbt run --project-dir /app/dbt_project

# Launching cron
cron -f

tail -f /dev/null

