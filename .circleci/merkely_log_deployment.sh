#!/bin/bash -Eeu

readonly MERKELY_CHANGE=merkely/change:latest
readonly MERKELY_OWNER=cyber-dojo
readonly MERKELY_PIPELINE=creator

export KOSLI_OWNER=cyber-dojo
export KOSLI_PIPELINE=creator
export KOSLI_API_TOKEN=${MERKELY_API_TOKEN}
export KOSLI_ARTIFACT_TYPE=docker

# - - - - - - - - - - - - - - - - - - -
kosli_fingerprint()
{
  echo "docker://${CYBER_DOJO_CREATOR_IMAGE}:${CYBER_DOJO_CREATOR_TAG}"
}

# - - - - - - - - - - - - - - - - - - -
kosli_log_deployment()
{
  local -r environment="${1}"
  local -r hostname="${2}"

	# docker run \
  #   --env MERKELY_COMMAND=log_deployment \
  #   --env MERKELY_OWNER=${MERKELY_OWNER} \
  #   --env MERKELY_PIPELINE=${MERKELY_PIPELINE} \
  #   --env MERKELY_FINGERPRINT=$(kosli_fingerprint) \
  #   --env MERKELY_DESCRIPTION="Deployed to ${environment} in Github Actions pipeline" \
  #   --env MERKELY_ENVIRONMENT="${environment}" \
  #   --env MERKELY_CI_BUILD_URL=${CIRCLE_BUILD_URL} \
  #   --env MERKELY_API_TOKEN=${MERKELY_API_TOKEN} \
  #   --env MERKELY_HOST="${hostname}" \
  #   --rm \
  #   --volume /var/run/docker.sock:/var/run/docker.sock \
  #     ${MERKELY_CHANGE}

  kosli expect deployment ${CYBER_DOJO_CREATOR_IMAGE}:${CYBER_DOJO_CREATOR_TAG} \
    --artifact-type docker \
    --description "Deployed to ${environment} in Github Actions pipeline" \
    --environment ${environment} \
    --host ${hostname}

}

# - - - - - - - - - - - - - - - - - - -
VERSIONER_URL=https://raw.githubusercontent.com/cyber-dojo/versioner/master
export $(curl "${VERSIONER_URL}/app/.env")
export CYBER_DOJO_CREATOR_TAG="${CIRCLE_SHA1:0:7}"
docker pull ${CYBER_DOJO_CREATOR_IMAGE}:${CYBER_DOJO_CREATOR_TAG}

readonly ENVIRONMENT="${1}"
readonly HOSTNAME="${2}"
kosli_log_deployment "${ENVIRONMENT}" "${HOSTNAME}"
