FROM kalilinux/kali-rolling:latest

USER root

SHELL ["/bin/bash", "-c"]
ENV DEBIAN_FRONTEND=noninteractive

# Install basic packages
RUN apt-get update && \
    apt-get install --yes --no-install-recommends --no-install-suggests \
    curl \
    bash \
    coreutils \
    findutils \
    grep \
    htop \
    iputils-ping \
    jq \
    less \
    locales \
    man \
    nano \
    net-tools \
    pipx \
    procps \
    psmisc \
    python3 \
    python3-pip \
    sed \
    sudo \
    tar \
    tree \
    unzip \
    util-linux \
    vim \
    wget \
    which \
    zip \
    ca-certificates \
    rsync \
    git && \
    rm -rf /var/lib/apt/lists/*

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
    --uid=1000 \
    --user-group && \
    echo "n3m3s1s:n3m3s1s" | chpasswd && \
    echo "n3m3s1s ALL=(ALL) NOPASSWD:ALL" >>/etc/sudoers.d/nopasswd

USER n3m3s1s
RUN pipx ensurepath

ENV PATH="/home/n3m3s1s/.local/bin:$PATH"