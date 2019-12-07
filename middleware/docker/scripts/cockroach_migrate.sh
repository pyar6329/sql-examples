#!/bin/bash

set -eu

CURRENT_DIR=$(echo $(cd $(dirname $0) && pwd))
COCKROACH_DATABASE="examples"

EXECUTE_QUERY_CEEATE_TABLE="$(tr -d '\n' < ${CURRENT_DIR}/../cockroach/create_tables.sql)"
# docker exec -it sql-examples-cockroach-master ./cockroach sql --insecure --execute="use ${COCKROACH_DATABASE}; ${EXECUTE_QUERY_CEEATE_TABLE}"
docker exec -it sql-examples-cockroach-master ./cockroach sql --insecure --execute="${EXECUTE_QUERY_CEEATE_TABLE}"

