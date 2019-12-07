#!/bin/bash

set -eu

CURRENT_DIR=$(echo $(cd $(dirname $0) && pwd))
COCKROACH_PORT=26257
# COCKROACH_DATABASE="examples"
# COCKROACH_USERNAME="pyar6329"
# COCKROACH_PASSWORD="passwordexample"

# EXECUTE_QUERY=$(printf " \
#   CREATE DATABASE IF NOT EXISTS ${COCKROACH_DATABASE}; \
#   CREATE USER ${COCKROACH_USERNAME} WITH PASSWORD '${COCKROACH_PASSWORD}'; \
#   GRANT ALL ON DATABASE ${COCKROACH_DATABASE} TO ${COCKROACH_USERNAME}; \
# ")

# INSECURE_EXECUTE_QUERY=$(printf " \
#   CREATE DATABASE IF NOT EXISTS ${COCKROACH_DATABASE}; \
# ")

# if ! [ -e "${CURRENT_DIR}/../var/cockroach/data_master" ]; then
#   # while ! nc -w 1 -z localhost ${COCKROACH_PORT}; do sleep 0.1; done;
#   # docker exec -it sql-examples-cockroach-master ./cockroach sql --certs-dir=/certs --execute="${EXECUTE_QUERY}"
#   docker exec -it sql-examples-cockroach-master ./cockroach sql --insecure --execute="${INSECURE_EXECUTE_QUERY}"
# fi
#

EXECUTE_QUERY_CEEATE_TABLE="$(tr -d '\n' < ${CURRENT_DIR}/../cockroach/create_databases.sql)"

while ! nc -w 1 -z localhost ${COCKROACH_PORT} > /dev/null 2>&1; do
  sleep 0.1
done

docker exec -it sql-examples-cockroach-master ./cockroach sql --insecure --execute="${EXECUTE_QUERY_CEEATE_TABLE}"

