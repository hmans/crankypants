#!/usr/bin/env bash
set -x

docker-compose run --rm tests

# If we want to shut down the docker compose environment from
# within this script, this is how we'd do it:
#
# rc=$?
# docker-compose down
# exit $rc
