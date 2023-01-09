#!/usr/bin/env bash
set -Eeu

export KOSLI_PIPELINE=creator
# KOSLI_OWNER is set in CI
# KOSLI_API_TOKEN is set in CI
# KOSLI_HOST_STAGING is set in CI
# KOSLI_HOST_PRODUCTION is set in CI
# SNYK_TOKEN is set in CI

# - - - - - - - - - - - - - - - - - - -
kosli_declare_pipeline()
{
  local -r hostname="${1}"

  kosli pipeline declare \
    --description "UX for Group/Kata creation" \
    --visibility public \
    --template artifact,unit-test,branch-coverage,snyk-scan \
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
kosli_report_junit_test_evidence()
{
  local -r hostname="${1}"

  kosli pipeline artifact report evidence junit \
    "$(artifact_name)" \
      --artifact-type docker \
      --host "${hostname}" \
      --name unit-test \
      --results-dir test/server/reports/junit
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
kosli_report_snyk()
{
  local -r hostname="${1}"

  kosli pipeline artifact report evidence snyk \
    "$(artifact_name)" \
      --artifact-type docker \
      --host "${hostname}" \
      --name snyk-scan \
      --scan-results snyk.json
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

  # In .github/workflows/main.yml deployment is its own job
  # and the image must be present to get its sha256 fingerprint.
  docker pull "$(artifact_name)"

  kosli expect deployment \
    "$(artifact_name)" \
    --artifact-type docker \
    --description "Deployed to ${environment} in Github Actions pipeline" \
    --environment "${environment}" \
    --host "${hostname}"
}

# - - - - - - - - - - - - - - - - - - -
artifact_name() {
  source "$(root_dir)/sh/echo_versioner_env_vars.sh"
  export $(echo_versioner_env_vars)
  echo "${CYBER_DOJO_CREATOR_IMAGE}:${CYBER_DOJO_CREATOR_TAG}"
}

# - - - - - - - - - - - - - - - - - - -
root_dir()
{
  # Functions in this file are called after sourcing (not including)
  # this file so root_dir() cannot use the path of this script.
  git rev-parse --show-toplevel
}

# - - - - - - - - - - - - - - - - - - -
write_coverage_json()
{
  {
    echo '{ "server":'
    cat "$(root_dir)/test/server/reports/coverage.json"
    echo ', "client":'
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
  [ "${CI:-}" == true ]
}

# - - - - - - - - - - - - - - - - - - -
on_ci_kosli_declare_pipeline()
{
  if on_ci
  then
    kosli_declare_pipeline "${KOSLI_HOST_STAGING}"
    kosli_declare_pipeline "${KOSLI_HOST_PRODUCTION}"
  fi
}

# - - - - - - - - - - - - - - - - - - -
on_ci_kosli_report_artifact_creation()
{
  if on_ci
  then
    kosli_report_artifact_creation "${KOSLI_HOST_STAGING}"
    kosli_report_artifact_creation "${KOSLI_HOST_PRODUCTION}"
  fi
}

# - - - - - - - - - - - - - - - - - - -
on_ci_kosli_report_junit_test_evidence()
{
  if on_ci
  then
    kosli_report_junit_test_evidence "${KOSLI_HOST_STAGING}"
    kosli_report_junit_test_evidence "${KOSLI_HOST_PRODUCTION}"
  fi
}

# - - - - - - - - - - - - - - - - - - -
on_ci_kosli_report_test_coverage_evidence()
{
  if on_ci
  then
    write_coverage_json
    kosli_report_test_coverage_evidence "${KOSLI_HOST_STAGING}"
    kosli_report_test_coverage_evidence "${KOSLI_HOST_PRODUCTION}"
  fi
}

# - - - - - - - - - - - - - - - - - - -
on_ci_kosli_report_snyk_scan_evidence()
{
  if on_ci
  then
    set +x
    #  --file=../source/server/Dockerfile does not work for some reason. So it is not used here.
    snyk container test "$(artifact_name)" \
      --json-file-output=snyk.json
    set -x

    kosli_report_snyk "${KOSLI_HOST_STAGING}"
    kosli_report_snyk "${KOSLI_HOST_PRODUCTION}"
  fi
}

# - - - - - - - - - - - - - - - - - - -
on_ci_kosli_assert_artifact()
{
  if on_ci
  then
    kosli_assert_artifact "${KOSLI_HOST_STAGING}"
    kosli_assert_artifact "${KOSLI_HOST_PRODUCTION}"
  fi
}
