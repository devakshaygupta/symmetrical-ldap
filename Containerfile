FROM ubi9/ubi

# 📦 Install required packages
RUN dnf update -y && \
    dnf install -y \
    authselect \
    openssh-server \
    openldap-clients \
    sssd \
    sssd-ldap \
    oddjob oddjob-mkhomedir \
    passwd \
    dbus-daemon \
    util-linux && \
    dnf clean all && \
    rm -rf /var/cache/dnf

# 🔐 Configure authentication and SSH
RUN authselect select sssd with-mkhomedir --force && \
    mkdir -p /var/run/sshd && mkdir -p /run/dbus && \
    sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/^#\?UsePAM.*/UsePAM yes/' /etc/ssh/sshd_config && \
    sed -i 's/^#\?PubkeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config

# 🔐 Generate ssh key
RUN ssh-keygen -A

# 🔑 Copy configs
COPY sssd.conf /etc/sssd/sssd.conf
COPY ldap.conf /etc/openldap/ldap.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod 600 /etc/sssd/sssd.conf && chown root:root /etc/sssd/sssd.conf && chmod +x /entrypoint.sh

EXPOSE 22

# 🚀 Launch using entrypoint
CMD ["/entrypoint.sh"]

