#!/bin/bash

set -eu

CURRENT_DIR=$(echo $(cd $(dirname $0) && pwd))
COCKROACH_USERNAME="pyar6329"
COCKROACH_PASSWORD="6nX6f8iRmtPHz3tW7Cf7"
COCKROACH_DATABASE="examples"

# EXECUTE_QUERY=$(printf " \
#   CREATE DATABASE IF NOT EXISTS ${COCKROACH_DATABASE}; \
#   CREATE USER ${COCKROACH_USERNAME} WITH PASSWORD '${COCKROACH_PASSWORD}'; \
#   GRANT ALL ON DATABASE ${COCKROACH_DATABASE} TO ${COCKROACH_USERNAME}; \
# ")

INSECURE_EXECUTE_QUERY=$(printf " \
  CREATE DATABASE IF NOT EXISTS ${COCKROACH_DATABASE}; \
  CREATE USER IF NOT EXISTS ${COCKROACH_USERNAME}; \
  GRANT ALL ON DATABASE ${COCKROACH_DATABASE} TO ${COCKROACH_USERNAME}; \
")

# docker exec -it sql-examples-cockroach-master ./cockroach sql --certs-dir=/certs --execute="${EXECUTE_QUERY}"
docker exec -it sql-examples-cockroach-master ./cockroach sql --insecure --execute="${INSECURE_EXECUTE_QUERY}"

