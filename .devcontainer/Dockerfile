# Use Ubuntu as the base image
FROM ubuntu:25.04

# Set default user
ARG USERNAME=vscode

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/workspace/symmetrical-ldap/.venv/bin:$PATH"
ENV VIRTUAL_ENV="/workspace/symmetrical-ldap/.venv"
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# Install dependencies
RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    wget \
    git \
    openssh-client \
    python3 \
    python3-pip \
    python3-venv \
    locales && \
    locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8 && \
    rm -rf /var/lib/apt/lists/*


# Install Docker from official Docker repository
RUN install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | tee /etc/apt/keyrings/docker.asc > /dev/null && \
    chmod a+r /etc/apt/keyrings/docker.asc && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo \"$VERSION_CODENAME\") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /workspace/supreme-ansible

# Create virtual environment and install requirements
RUN python3 -m venv /workspace/supreme-ansible/.venv && \
    /workspace/supreme-ansible/.venv/bin/pip install --upgrade pip

# Set default shell
SHELL ["/bin/bash", "-c"]

RUN useradd -m $USERNAME --shell /bin/bash
USER $USERNAME