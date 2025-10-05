FROM kalilinux/kali-rolling:latest

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
        sudo && \
    rm -rf /var/lib/apt/lists/*

# Configure locale
RUN sed -i 's/# *en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && locale-gen
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8

# Install Docker
# Add Docker's official GPG key
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Add Docker repository
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian bookworm stable" | \
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

# Switch to non-root user
USER n3m3s1s

# Ensure pipx is in PATH
RUN pipx ensurepath