FROM debian:bookworm-slim

# Install required packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    nginx \
    tor \
    openssh-server \
    curl \
    ca-certificates \
    procps \
    && rm -rf /var/lib/apt/lists/*

# Create user for the project
RUN useradd -m -s /bin/bash aareslan && \
    echo "aareslan:cyberpiscine" | chpasswd

# Set up SSH
RUN mkdir -p /run/sshd /var/run/sshd

# Set up web directory
RUN mkdir -p /var/www/html && \
    chown www-data:www-data /var/www/html

# Copy configuration files
COPY nginx.conf /etc/nginx/nginx.conf
COPY sshd_config /etc/ssh/sshd_config
COPY torrc /etc/tor/torrc
COPY index.html /var/www/html/

# Set up Tor directories and logs (consolidated)
RUN mkdir -p /var/lib/tor/hidden_service \
             /var/lib/tor/hidden_ssh \
             /var/run/tor \
             /var/log/tor \
             /var/log/nginx && \
    chown -R debian-tor:debian-tor /var/lib/tor /var/run/tor /var/log/tor && \
    chown www-data:www-data /var/log/nginx && \
    chmod -R 700 /var/lib/tor /var/run/tor

# Create startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Generate SSH host key (only ED25519)
RUN rm -f /etc/ssh/ssh_host_* && \
    ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ''

# Set permissions
RUN chmod 600 /etc/ssh/ssh_host_ed25519_key && \
    chmod 644 /etc/ssh/ssh_host_ed25519_key.pub

# Expose ports
EXPOSE 80 4242

# Start services
CMD ["/start.sh"]
