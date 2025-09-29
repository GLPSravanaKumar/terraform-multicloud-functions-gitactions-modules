FROM ubuntu:22.04

# Install Apache
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y apache2 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy built site (ensure your CI builds into ./build)
COPY . /var/www/html/

EXPOSE 81

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]