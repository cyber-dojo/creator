#!/bin/bash -Eeu

# ROOT_DIR must be set

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
kosli_declare_pipeline()
{
  local -r hostname="${1}"

  kosli pipeline declare \
    --description "UX for Group/Kata creation" \
    --visibility public \
    --template artifact,branch-coverage \
    --host "${hostname}"
}

# - - - - - - - - - - - - - - - - - - -
kosli_log_artifact()
{
  local -r hostname="${1}"
  
  kosli pipeline artifact report creation ${CYBER_DOJO_CREATOR_IMAGE}:${CYBER_DOJO_CREATOR_TAG} \
    --repo-root ../../.. \
    --host "${hostname}"
}

# - - - - - - - - - - - - - - - - - - -
kosli_log_evidence()
{
  local -r hostname="${1}"

  kosli pipeline artifact report evidence generic ${CYBER_DOJO_CREATOR_IMAGE}:${CYBER_DOJO_CREATOR_TAG} \
    --description "server & client branch-coverage reports" \
    --evidence-type "branch-coverage" \
    --user-data "$(evidence_json_path)" \
    --host "${hostname}"

}

# - - - - - - - - - - - - - - - - - - -
write_evidence_json()
{
  echo '{ "server": ' > "$(evidence_json_path)"
  cat "${ROOT_DIR}/test/server/reports/coverage.json" >> "$(evidence_json_path)"
  echo ', "client": ' >> "$(evidence_json_path)"
  cat "${ROOT_DIR}/test/client/reports/coverage.json" >> "$(evidence_json_path)"
  echo '}' >> "$(evidence_json_path)"
}

# - - - - - - - - - - - - - - - - - - -
evidence_json_path()
{
  echo "${ROOT_DIR}/test/evidence.json"
}

# - - - - - - - - - - - - - - - - - - - - - - - -
on_ci()
{
  [ -n "${CI:-}" ]
}

# - - - - - - - - - - - - - - - - - - -
on_ci_kosli_declare_pipeline()
{
  if ! on_ci ; then
    return
  fi
  kosli_declare_pipeline https://staging.app.kosli.com
  kosli_declare_pipeline https://app.kosli.com
}

# - - - - - - - - - - - - - - - - - - -
on_ci_kosli_log_artifact()
{
  if ! on_ci ; then
    return
  fi
  kosli_log_artifact https://staging.app.kosli.com
  kosli_log_artifact https://app.kosli.com
}

# - - - - - - - - - - - - - - - - - - -
on_ci_kosli_log_evidence()
{
  if ! on_ci ; then
    return
  fi
  write_evidence_json
  kosli_log_evidence https://staging.app.kosli.com
  kosli_log_evidence https://app.kosli.com
}



