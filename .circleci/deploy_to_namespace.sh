#!/bin/bash -Eeu

readonly NAMESPACE="${1}" # beta|prod
readonly CYBER_DOJO_CREATOR_TAG="${CIRCLE_SHA1:0:7}"
readonly SCRIPT_URL=https://raw.githubusercontent.com/cyber-dojo/k8s-install/master/sh
source <(curl "${SCRIPT_URL}/gcloud_init.sh")
source <(curl "${SCRIPT_URL}/helm_init.sh")
source <(curl "${SCRIPT_URL}/helm_upgrade_probe_yes_prometheus_yes.sh")
export $(curl https://raw.githubusercontent.com/cyber-dojo/versioner/master/app/.env)

gcloud_init
helm_init
helm_upgrade_probe_yes_prometheus_yes \
   "${NAMESPACE}" \
   "creator" \
   "${CYBER_DOJO_CREATOR_IMAGE}" \
   "${CYBER_DOJO_CREATOR_TAG}" \
   "${CYBER_DOJO_CREATOR_PORT}" \
   ".circleci/k8s-general-values.yml"
