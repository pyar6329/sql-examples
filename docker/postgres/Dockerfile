# FROM postgres:9.6
FROM postgres:11.2

COPY initdb.d /tmp/initdb.d

RUN set -x && \
    cp -rf /tmp/initdb.d/* /docker-entrypoint-initdb.d && \
    rm -rf /tmp/initdb.d && \
    localedef -i ja_JP -c -f UTF-8 -A /usr/share/locale/locale.alias ja_JP.UTF-8

ENV LANG C
