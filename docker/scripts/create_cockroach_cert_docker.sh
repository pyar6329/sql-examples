#!/bin/bash

set -eu

CURRENT_DIR=$(echo $(cd $(dirname $0) && pwd))
COCKROACHDB_VERSION="v19.1.5"
CERT_DIR="${CURRENT_DIR}/../var/cockroach/certs"

if ! [ -e "${CERT_DIR}" ]; then
  mkdir -p "${CERT_DIR}"
fi

docker run -it \
  --rm \
  -v ${CURRENT_DIR}/create_cockroach_cert.sh:/mountfile/create_cockroach_cert.sh \
  -v ${CERT_DIR}:/workdir \
  -w /workdir \
  --entrypoint /mountfile/create_cockroach_cert.sh \
  cockroachdb/cockroach:${COCKROACHDB_VERSION}

echo "cert files are created in: docker/var/cockroach/certs"
