FROM kalilinux/kali-rolling:latest

USER root

SHELL ["/bin/bash", "-c"]
ENV DEBIAN_FRONTEND=noninteractive

# Install basic packages
RUN apt-get update && \
    apt-get install --yes --no-install-recommends --no-install-suggests \
    curl \
    bash \
    htop \
    jq \
    locales \
    man \
    pipx \
    python3 \
    python3-pip \
    sudo \
    systemd \
    systemd-sysv \
    unzip \
    vim \
    wget \
    ca-certificates \
    rsync \
    git \
    && rm -rf /var/lib/apt/lists/*

# Add the Docker GPG key and repository
RUN curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
RUN chmod a+r /etc/apt/keyrings/docker.asc

RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian bookworm stable" > /etc/apt/sources.list.d/docker.list

# Install Docker
RUN apt-get update && \
    apt-get install --yes --no-install-recommends --no-install-suggests \
    build-essential \
    containerd.io \
    docker-ce \
    docker-ce-cli \
    docker-buildx-plugin \
    docker-compose-plugin \
    && rm -rf /var/lib/apt/lists/*
    
# Enables Docker starting with systemd
RUN systemctl enable docker

# Generate the desired locale (en_US.UTF-8)
RUN sed -i 's/^# *\(en_US.UTF-8 UTF-8\)/\1/' /etc/locale.gen && \
    locale-gen && \
    update-locale LANG=en_US.UTF-8

# Make typing unicode characters in the terminal work.
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# Add a user `n3m3s1s` so that you're not developing as the `root` user
RUN useradd n3m3s1s \
    --create-home \
    --shell=/bin/bash \
    --groups=docker \
    --uid=1000 \
    --user-group && \
    echo "n3m3s1s ALL=(ALL) NOPASSWD:ALL" >>/etc/sudoers.d/nopasswd

USER n3m3s1s
RUN pipx ensurepath