FROM ghcr.io/n3m3s1s-cybersecurity-club/coder-image:base

USER root

SHELL ["/bin/bash", "-c"]
ENV DEBIAN_FRONTEND=noninteractive

# Install Kali Linux XFCE Desktop Environment
RUN apt-get update && \
    apt-get install -y --no-install-recommends --no-install-suggests \
    kali-desktop-xfce \
    lightdm \
    dbus-x11 \
    libdatetime-perl \
    openssl \
    ssl-cert \
    xfce4 \
    xfce4-goodies && \
    rm -rf /var/lib/apt/lists/*

# Configure LightDM as the display manager
RUN echo "/usr/sbin/lightdm" > /etc/X11/default-display-manager

# Set XFCE as the default session manager
RUN update-alternatives --install /usr/bin/x-session-manager x-session-manager /usr/bin/startxfce4 50 && \
    update-alternatives --set x-session-manager /usr/bin/startxfce4

# Configure environment variables for Kali Linux XFCE
ARG USER=n3m3s1s
RUN echo 'LANG=en_US.UTF-8' >> /etc/default/locale && \
    echo 'export XDG_CURRENT_DESKTOP=XFCE' > /home/$USER/.xsessionrc && \
    echo 'export XDG_SESSION_TYPE=x11' >> /home/$USER/.xsessionrc && \
    echo 'export XDG_SESSION_DESKTOP=xfce' >> /home/$USER/.xsessionrc

# Create .dmrc file to set default XFCE session for Kali Linux
RUN echo '[Desktop]' > /home/$USER/.dmrc && \
    echo 'Session=xfce' >> /home/$USER/.dmrc && \
    chown $USER:$USER /home/$USER/.dmrc /home/$USER/.xsessionrc

USER n3m3s1s