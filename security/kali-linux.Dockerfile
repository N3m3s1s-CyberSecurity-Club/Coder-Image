FROM ghcr.io/n3m3s1s-cybersecurity-club/coder-image:desktop-kali-linux

# Configure build environment
USER root
SHELL ["/bin/bash", "-c"]
ENV DEBIAN_FRONTEND=noninteractive

# Install security and reverse engineering tools
RUN apt-get update && \
    apt-get install --yes --no-install-recommends --no-install-suggests \
        gdb \
        gdb-multiarch \
        gdbserver \
        ghidra \
        radare2 \
        nmap \
        sqlmap \
        dirsearch \
        gobuster \
        wireshark && \
    rm /run/reboot-required* || true && \
    rm -rf /var/lib/apt/lists/*

USER n3m3s1s