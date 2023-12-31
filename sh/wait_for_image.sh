#!/usr/bin/env bash
set -Eu

GIT_COMMIT="${1}"                         # eg 756c7286adbcca25ec7a1e098e43758b270ebed6
TAG="$(echo "${GIT_COMMIT}" | head -c7)"  # eg 756c728
IMAGE_NAME="cyberdojo/creator:${TAG}"     # eg cyberdojo/creator:756c728

MAX_WAIT_TIME=$((5 * 60))  # 5 minutes
SLEEP_TIME=10              # 10 secs
MAX_ATTEMPTS=$(( MAX_WAIT_TIME / SLEEP_TIME ))
ATTEMPTS=1

until docker pull "${IMAGE_NAME}"
do
  sleep 10
  [[ ${ATTEMPTS} -eq ${MAX_ATTEMPTS} ]] && echo "Failed!" && exit 1
  ((ATTEMPTS++))
  echo "Waiting for ${IMAGE_NAME} to be pushed to its registry"
  echo "Attempt # ${ATTEMPTS} / ${MAX_ATTEMPTS}"
done
echo "Success: Artifact ${IMAGE_NAME} has been pushed to its registry"
exit 0
