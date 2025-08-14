FROM wordpress:latest

# Install unzip, ping utils, and mysql client using apt-get
RUN apt-get update && \
  apt-get install -y unzip iputils-ping default-mysql-client && \
  rm -rf /var/lib/apt/lists/*

# Copy zipped plugins into the container (optional)
COPY plugins/*.zip /tmp/plugins/

# Unzip plugins into wp-content/plugins
RUN if [ -d /tmp/plugins ]; then \
  cd /tmp/plugins && \
  for file in *.zip; do \
  unzip "$file" -d /usr/src/wordpress/wp-content/plugins/; \
  done && \
  rm -rf /tmp/plugins; \
  fi

# Copy the DB init script
COPY init-wordpress-db.sh /usr/local/bin/init-wordpress-db.sh
RUN chmod +x /usr/local/bin/init-wordpress-db.sh

# Override the entrypoint to run our script first
ENTRYPOINT ["/bin/bash", "-c", "/usr/local/bin/init-wordpress-db.sh"]

