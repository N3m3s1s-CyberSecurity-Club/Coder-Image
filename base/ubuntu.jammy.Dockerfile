FROM ubuntu:jammy

# Set up environment
USER root
SHELL ["/bin/bash", "-c"]
ENV DEBIAN_FRONTEND=noninteractive

# Install base packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        bash \
        apt-transport-https \
        ca-certificates \
        lsb-release \
        curl \
        gnupg \
        git \
        gcc \
        wget \
        htop \
        jq \
        locales \
        pipx \
        python3 \
        python3-pip \
        iputils-ping \
        dnsutils \
        iproute2 \
        net-tools \
        openssh-client \
        sudo && \
    rm -rf /var/lib/apt/lists/*

# Configure locale
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8

# Install Docker
# Add Docker's official GPG key
RUN install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc

# Add Docker repository
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        containerd.io \
        docker-buildx-plugin \
        docker-ce \
        docker-ce-cli \
        docker-compose-plugin && \
    rm -rf /var/lib/apt/lists/*

# Create user n3m3s1s
RUN useradd n3m3s1s \
        --create-home \
        --shell=/bin/bash \
        --groups=docker \
        --uid=1000 \
        --user-group && \
    echo "n3m3s1s:n3m3s1s" | chpasswd && \
    echo "n3m3s1s ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/nopasswd

# Install Rust
ENV CARGO_HOME=/usr/local/cargo \
    RUSTUP_HOME=/usr/local/rustup \
    PATH=/usr/local/cargo/bin:$PATH

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path && \
    chmod -R a+rwx /usr/local/cargo /usr/local/rustup

# Install Go
ENV GO_VERSION=1.25.2
RUN wget -P /tmp "https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz" && \
    tar -C /usr/local -xzf /tmp/go${GO_VERSION}.linux-amd64.tar.gz && \
    rm /tmp/go${GO_VERSION}.linux-amd64.tar.gz

ENV GO_HOME=/usr/local/go \
    PATH=/usr/local/go/bin:$PATH

# Clean up apt cache and temporary files
RUN apt-get clean && \
    apt-get autoclean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/* /var/tmp/*

# Switch to non-root user
USER n3m3s1s

# Ensure pipx is in PATH
RUN pipx ensurepath