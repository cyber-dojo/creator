#!/usr/bin/env bash
set -Eu

# See https://gitlab.com/cyber-dojo/creator/-/blob/main/.gitlab/workflows/dev-readme.md

readonly IMAGE_NAME="${1}"        # eg cyberdojo/creator:6d650d5
readonly KOSLI_ENVIRONMENT="${2}" # eg aws-prod

# KOSLI_HOST       set by CI eg https://app.kosli.com
# KOSLI_API_TOKEN  set by CI eg 7654y432er7132rwaefdgzfvdc (fake)
# KOSLI_ORG        set by CI eg cyber-dojo

readonly MAX_WAIT_TIME=8          # max time to wait for IMAGE_NAME to be deployed, in minutes
readonly SLEEP_TIME=15            # wait time between deployment checks, in seconds
readonly MAX_ATTEMPTS=$(( MAX_WAIT_TIME * 60 / SLEEP_TIME ))

image_deployed()
{
    local -r snapshot_json_filename=snapshot.json

    # Use Kosli CLI to find what artifacts are currently running
    # (docs/snapshot.json contains an example json file)
    kosli get snapshot "${KOSLI_ENVIRONMENT}" \
      --output=json \
        > "${snapshot_json_filename}"

    # Process one artifact at a time
    local -r artifacts_length=$(jq '.artifacts | length' ${snapshot_json_filename})
    for i in $(seq 0 $(( artifacts_length - 1 )));
    do
        annotation_type=$(jq -r ".artifacts[$i].annotation.type" ${snapshot_json_filename})
        if [ "${annotation_type}" != "exited" ]; then
          fingerprint=$(jq -r ".artifacts[$i].fingerprint" ${snapshot_json_filename})
          if [ "${fingerprint}" == "${FINGERPRINT}" ]; then
            return 0 # true
          fi
       fi
    done
    return 1 # false
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

docker pull "${IMAGE_NAME}"
readonly FINGERPRINT=$(kosli fingerprint "${IMAGE_NAME}" --artifact-type=docker)
ATTEMPTS=1

until image_deployed
do
  sleep ${SLEEP_TIME}
  [[ ${ATTEMPTS} -eq ${MAX_ATTEMPTS} ]] && echo "Failed!" && exit 1
  ((ATTEMPTS++))
  echo "Waiting for deployment of Artifact ${IMAGE_NAME} to Environment ${KOSLI_ENVIRONMENT}"
  echo "Attempt # ${ATTEMPTS} / ${MAX_ATTEMPTS}"
done
echo "Success: Artifact ${IMAGE_NAME} is running in Environment ${KOSLI_ENVIRONMENT}"
exit 0
