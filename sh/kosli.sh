#!/bin/bash -Eeu
set -Eeu

# Note: ROOT_DIR must be set

export KOSLI_API_TOKEN=${MERKELY_API_TOKEN}
export KOSLI_OWNER=cyber-dojo
export KOSLI_PIPELINE=creator

readonly KOSLI_HOST_STAGING=https://staging.app.kosli.com
readonly KOSLI_HOST_PROD=https://app.kosli.com

# - - - - - - - - - - - - - - - - - - -
artifact_name() {
  echo "${CYBER_DOJO_CREATOR_IMAGE}:${CYBER_DOJO_CREATOR_TAG}"
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
kosli_report_artifact_creation()
{
  local -r hostname="${1}"

  kosli pipeline artifact report creation \
    "$(artifact_name)" \
      --artifact-type docker \
      --repo-root ../../.. \
      --host "${hostname}"
}

# - - - - - - - - - - - - - - - - - - -
kosli_report_coverage_evidence()
{
  local -r hostname="${1}"

  kosli pipeline artifact report evidence generic \
    "$(artifact_name)" \
      --artifact-type docker \
      --description "server & client branch-coverage reports" \
      --evidence-type "branch-coverage" \
      --user-data "$(coverage_json_path)" \
      --host "${hostname}"
}

# - - - - - - - - - - - - - - - - - - -
kosli_assert_artifact()
{
  local -r hostname="${1}"

  kosli assert artifact \
    "$(artifact_name)" \
      --artifact-type docker \
      --host "${hostname}"
}

# - - - - - - - - - - - - - - - - - - -
write_coverage_json()
{
  echo '{ "server": ' > "$(coverage_json_path)"
  cat "${ROOT_DIR}/test/server/reports/coverage.json" >> "$(coverage_json_path)"
  echo ', "client": ' >> "$(coverage_json_path)"
  cat "${ROOT_DIR}/test/client/reports/coverage.json" >> "$(coverage_json_path)"
  echo '}' >> "$(coverage_json_path)"
}

# - - - - - - - - - - - - - - - - - - -
coverage_json_path()
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
  kosli_declare_pipeline "${KOSLI_HOST_STAGING}"
  kosli_declare_pipeline "${KOSLI_HOST_PROD}"
}

# - - - - - - - - - - - - - - - - - - -
on_ci_kosli_report_artifact_creation()
{
  if ! on_ci ; then
    return
  fi
  kosli_report_artifact_creation "${KOSLI_HOST_STAGING}"
  kosli_report_artifact_creation "${KOSLI_HOST_PROD}"
}

# - - - - - - - - - - - - - - - - - - -
on_ci_kosli_report_coverage_evidence()
{
  if ! on_ci ; then
    return
  fi
  write_coverage_json
  kosli_report_coverage_evidence "${KOSLI_HOST_STAGING}"
  kosli_report_coverage_evidence "${KOSLI_HOST_PROD}"
}

# - - - - - - - - - - - - - - - - - - -
on_ci_kosli_assert_artifact()
{
  if ! on_ci ; then
    return
  fi
  kosli_assert_artifact "${KOSLI_HOST_STAGING}"
  kosli_assert_artifact "${KOSLI_HOST_PROD}"
}



