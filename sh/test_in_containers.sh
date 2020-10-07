#!/bin/bash -Eeu

# - - - - - - - - - - - - - - - - - - - - - - - - - -
test_in_containers()
{
  if on_ci ; then
    docker pull cyberdojo/check-test-results:latest
  fi
  if [ "${1:-}" == 'client' ]; then
    shift
    run_client_tests "${@:-}"
  elif [ "${1:-}" == 'server' ]; then
    shift
    run_server_tests "${@:-}"
  else
    run_server_tests "${@:-}"
    run_client_tests "${@:-}"
  fi
  echo All passed
}

# - - - - - - - - - - - - - - - - - - - - - - - - - -
run_client_tests()
{
  run_tests "${CYBER_DOJO_CREATOR_CLIENT_USER}" client test-client "${@:-}"
}
run_server_tests()
{
  run_tests "${CYBER_DOJO_CREATOR_SERVER_USER}" server test-creator "${@:-}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - -
run_tests()
{
  local -r user="${1}" # eg nobody
  local -r type="${2}" # eg client|server
  local -r container_name="${3}"
  local -r reports_dir_name=reports
  local -r tmp_dir=/tmp
  local -r coverage_root=/${tmp_dir}/${reports_dir_name}
  local -r test_dir="${ROOT_DIR}/test/${type}"
  local -r reports_dir=${test_dir}/${reports_dir_name}
  local -r test_log=test.log
  local -r coverage_code_tab_name=tested
  local -r coverage_test_tab_name=tester

  echo
  echo '=================================='
  echo "Running ${type} tests"
  echo '=================================='

  set +e
  docker exec \
    --env COVERAGE_CODE_TAB_NAME=${coverage_code_tab_name} \
    --env COVERAGE_TEST_TAB_NAME=${coverage_test_tab_name} \
    --user "${user}" \
    "${container_name}" \
      sh -c "/test/run.sh ${coverage_root} ${test_log} ${type} ${*:4}"
  set -e

  # You can't [docker cp] from a tmpfs, so tar-piping coverage out
  docker exec \
    "${container_name}" \
    tar Ccf \
      "$(dirname "${coverage_root}")" \
      - "$(basename "${coverage_root}")" \
        | tar Cxf "${test_dir}/" -

  set +e
  docker run \
    --env COVERAGE_CODE_TAB_NAME=${coverage_code_tab_name} \
    --env COVERAGE_TEST_TAB_NAME=${coverage_test_tab_name} \
    --rm \
    --volume ${reports_dir}/${test_log}:${tmp_dir}/${test_log}:ro \
    --volume ${reports_dir}/index.html:${tmp_dir}/index.html:ro \
    --volume ${test_dir}/metrics.rb:/app/metrics.rb:ro \
    cyberdojo/check-test-results:latest \
    sh -c "ruby /app/check_test_results.rb ${tmp_dir}/${test_log} ${tmp_dir}/index.html" \
      | tee -a ${reports_dir}/${test_log}
  local -r status=${PIPESTATUS[0]}
  set -e

  local -r coverage_path="${reports_dir}/index.html"
  echo "${type} coverage at ${coverage_path}"
  echo "${type} status == ${status}"
  if [ "${status}" != '0' ]; then
    local -r log=$(docker logs "${container_name}" 2> /dev/null)
    echo "${log}" | head -n 10
    echo ...
    echo "${log}" | tail -n 10
  fi
  return ${status}
}
