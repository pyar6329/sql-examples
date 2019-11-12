#!/bin/ash

set -e

export DEV_DATABASE_HOST="$(route | awk 'NR==3 {print $2}')"
export STAGING_DATABASE_HOST="$(route | awk 'NR==3 {print $2}')"
export TEST_DATABASE_HOST="$(route | awk 'NR==3 {print $2}')"
export PROD_DATABASE_HOST="$(route | awk 'NR==3 {print $2}')"

case "$1" in
  "sh" | "ash" | "bash" | "/bin/sh" )
    exec "/bin/sh";;
  * )
    exec /usr/local/bin/sql-migrate "$@";;
esac
