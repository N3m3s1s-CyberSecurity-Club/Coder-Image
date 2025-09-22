FROM ghcr.io/n3m3s1s-cybersecurity-club/coder-image:base-ubuntu-noble

# Configure build environment
USER root
SHELL ["/bin/bash", "-c"]
ENV DEBIAN_FRONTEND=noninteractive

# Install desktop environment and essential GUI components
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        dbus-x11 \
        libdatetime-perl \
        openssl \
        ssl-cert \
        xfce4 \
        xfce4-goodies && \
    rm /run/reboot-required* || true && \
    rm -rf /var/lib/apt/lists/*

# Configure desktop environment for user
ARG USER=n3m3s1s

# Set up locale and desktop session configuration
RUN echo 'LANG=en_US.UTF-8' >> /etc/default/locale && \
    echo 'export GNOME_SHELL_SESSION_MODE=ubuntu' > /home/$USER/.xsessionrc && \
    echo 'export XDG_CURRENT_DESKTOP=xfce' >> /home/$USER/.xsessionrc && \
    echo 'export XDG_SESSION_TYPE=x11' >> /home/$USER/.xsessionrc

# Switch to non-root user
USER n3m3s1s