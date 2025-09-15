FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV USER=root
ENV HOME=/root

RUN apt-get update && apt-get install -y \
    xfce4 xfce4-goodies dbus-x11 x11-xserver-utils xauth xinit \
    tigervnc-standalone-server tigervnc-common \
    openssh-server sudo vim wget net-tools \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/*

RUN mkdir -p /var/run/sshd \
 && echo 'root:root' | chpasswd \
 && echo "PermitRootLogin yes" >> /etc/ssh/sshd_config \
 && echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 22 5901

ENTRYPOINT ["/entrypoint.sh"]
