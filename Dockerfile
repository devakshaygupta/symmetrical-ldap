FROM ubuntu:25.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install required packages
RUN apt-get update && \
    apt-get install -y openssh-server sssd sssd-ldap ldap-utils libnss-ldapd libpam-ldapd passwd && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create SSH run directory and configure SSH to allow password authentication
RUN mkdir -p /var/run/sshd && \
    sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Generate SSH host keys
RUN ssh-keygen -A

# Copy sssd.conf configuration
COPY sssd.conf /etc/sssd/sssd.conf
RUN chmod 600 /etc/sssd/sssd.conf && chown root:root /etc/sssd/sssd.conf

# Expose SSH port
EXPOSE 22

# Start SSH
CMD /usr/sbin/sshd -D