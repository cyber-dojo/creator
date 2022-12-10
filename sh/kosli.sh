#!/usr/bin/env bash
set -Eeu

export MY_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export KOSLI_API_TOKEN=${KOSLI_API_TOKEN:-${MERKELY_API_TOKEN}}
export KOSLI_OWNER=cyber-dojo
export KOSLI_PIPELINE=creator

readonly KOSLI_HOST_STAGING=https://staging.app.kosli.com
readonly KOSLI_HOST_PROD=https://app.kosli.com

# - - - - - - - - - - - - - - - - - - -
artifact_name() {
  unset CYBER_DOJO_CREATOR_IMAGE
  unset CYBER_DOJO_CREATOR_TAG
  source "$(root_dir)/sh/echo_versioner_env_vars.sh"
  export $(echo_versioner_env_vars)
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
root_dir()
{
  $(cd "${MY_DIR}/.." && pwd)
}

# - - - - - - - - - - - - - - - - - - -
write_coverage_json()
{
  {
    echo '{ "server": '
    cat "$(root_dir)/test/server/reports/coverage.json"
    echo ', "client": '
    cat "$(root_dir)/test/client/reports/coverage.json"
    echo '}'
  } > "$(coverage_json_path)"
}

# - - - - - - - - - - - - - - - - - - -
coverage_json_path()
{
  echo "$(root_dir)/test/evidence.json"
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



