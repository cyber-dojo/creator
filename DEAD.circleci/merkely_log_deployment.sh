#!/bin/bash -Eeu

export KOSLI_OWNER=cyber-dojo
export KOSLI_PIPELINE=creator
export KOSLI_API_TOKEN=${MERKELY_API_TOKEN}

VERSIONER_URL=https://raw.githubusercontent.com/cyber-dojo/versioner/master
export $(curl "${VERSIONER_URL}/app/.env")
export CYBER_DOJO_CREATOR_TAG="${CIRCLE_SHA1:0:7}"

# - - - - - - - - - - - - - - - - - - -
artifact_name()
{
  echo "${CYBER_DOJO_CREATOR_IMAGE}:${CYBER_DOJO_CREATOR_TAG}"
}

# - - - - - - - - - - - - - - - - - - -
kosli_expect_deployment()
{
  local -r environment="${1}"
  local -r hostname="${2}"

  kosli expect deployment \
    "$(artifact_name)" \
    --artifact-type docker \
    --description "Deployed to ${environment} in Github Actions pipeline" \
    --environment "${environment}" \
    --host "${hostname}"

}

# - - - - - - - - - - - - - - - - - - -
docker pull "$(artifact_name)"

readonly ENVIRONMENT="${1}"
readonly HOSTNAME="${2}"
kosli_expect_deployment "${ENVIRONMENT}" "${HOSTNAME}"
