FROM ubuntu:22.04

# install python and cron
RUN apt-get update && \
    apt-get install -y python3 python3-pip cron nano && \
    rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app
COPY . .

# Copy the cron
COPY crontab /etc/cron.d/deezer_cron
RUN chmod 644 /etc/cron.d/deezer_cron

# Install python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
