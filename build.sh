#!/usr/bin/env bash
set -e
set -x

yarn run web:build:release
docker build -t hmans/crankypants .
docker push hmans/crankypants
