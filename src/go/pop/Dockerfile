FROM golang:1.13.4-alpine3.10 AS soda-build
RUN set -ex && \
  apk add --no-cache --virtual .installer git && \
  go get github.com/gobuffalo/pop/... && \
  mkdir -p /build && \
  cp -rf /go/bin/soda /build/soda

FROM alpine:3.10

WORKDIR /workspace
COPY --from=soda-build /build/soda /usr/local/bin/soda
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

RUN set -ex && \
  apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/main postgresql-client && \
  chmod +x /usr/local/bin/* && \
  rm -rf /var/cache/apk/*

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
