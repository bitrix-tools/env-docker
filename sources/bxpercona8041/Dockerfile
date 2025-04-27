FROM percona/percona-server:8.0.41

USER root

COPY etc_my.cnf /etc/my.cnf
COPY etc_mycnfd_docker.cnf /etc/my.cnf.d/docker.cnf
COPY etc_mycnfd_my.cnf /etc/my.cnf.d/my.cnf

RUN chown -R mysql:root /etc/my.cnf /etc/my.cnf.d && \
    chmod -R ug+rwX /etc/my.cnf /etc/my.cnf.d

USER mysql:mysql
