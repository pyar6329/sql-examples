#!/bin/bash

set -eu

COCKROACH_USERNAME="pyar6329"

/cockroach/cockroach cert create-ca \
  --certs-dir=$(pwd) \
  --ca-key=$(pwd)/ca.key

/cockroach/cockroach cert create-node \
  localhost \
  *.sql-examples-cockroach \
  --certs-dir=$(pwd) \
  --ca-key=$(pwd)/ca.key

/cockroach/cockroach cert create-client \
  root \
  --certs-dir=$(pwd) \
  --ca-key=$(pwd)/ca.key

/cockroach/cockroach cert create-client \
  admin \
  --certs-dir=$(pwd) \
  --ca-key=$(pwd)/ca.key

/cockroach/cockroach cert create-client \
  ${COCKROACH_USERNAME} \
  --certs-dir=$(pwd) \
  --ca-key=$(pwd)/ca.key

/cockroach/cockroach cert list \
  --certs-dir=$(pwd)
