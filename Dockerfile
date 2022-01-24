From centos:7

ARG SSH_PORT=62222
ARG PASSWD=AuroraAdminPanel321

RUN yum makecache -y && \
    yum install -y \
    openssh-server \
    iproute \
    && \
    yum clean packages && \
    yum clean headers && \
    yum clean metadata && \
    yum clean all && \
    rm -rf /var/cache/yum && \
    sed -i "s/#Port 22/Port $SSH_PORT/" /etc/ssh/sshd_config && \
    ssh-keygen -A && \
    echo "$PASSWD" | passwd root --stdin

EXPOSE $SSH_PORT
CMD ["/usr/sbin/sshd", "-D", "-o", "ListenAddress=0.0.0.0"]
