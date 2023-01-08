
# - - - - - - - - - - - - - - - - - - - - - - - - - -
test_in_containers()
{
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
  run_tests \
    "${CYBER_DOJO_CREATOR_CLIENT_USER}" \
    "${CYBER_DOJO_CREATOR_CLIENT_CONTAINER_NAME}" \
    client "${@:-}";
}

# - - - - - - - - - - - - - - - - - - - - - - - - - -
run_server_tests()
{
  run_tests \
    "${CYBER_DOJO_CREATOR_SERVER_USER}" \
    "${CYBER_DOJO_CREATOR_SERVER_CONTAINER_NAME}" \
    server "${@:-}";
}

# - - - - - - - - - - - - - - - - - - - - - - - - - -
run_tests()
{
  local -r USER="${1}"           # eg nobody
  local -r CONTAINER_NAME="${2}" # eg test_creator_server
  local -r TYPE="${3}"           # eg server

  echo '=================================='
  echo "Running ${TYPE} tests"
  echo '=================================='

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Run tests (with branch coverage) inside the container.

  local -r CODE_DIR=code
  local -r TEST_DIR=test
  local -r TEST_LOG=test.log
  local -r CONTAINER_REPORTS_DIR=/tmp/reports

  set +e
  docker exec \
    --env CODE_DIR="${CODE_DIR}" \
    --env TEST_DIR="${TEST_DIR}" \
    --user "${USER}" \
    "${CONTAINER_NAME}" \
      sh -c "/app/test/run.sh ${CONTAINER_REPORTS_DIR} ${TEST_LOG} ${TYPE} ${*:4}"
  set -e

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Extract test-run results and coverage data from the container.
  # You can't [docker cp] from a tmpfs, so tar-piping coverage out

  local -r HOST_TEST_DIR="$(root_dir)/test/${TYPE}"  # where to extract to. untar will create reports/ dir
  local -r HOST_REPORTS_DIR="${HOST_TEST_DIR}/reports" # where files will be

  rm "${HOST_REPORTS_DIR}/${TEST_LOG}"   2> /dev/null || true
  rm "${HOST_REPORTS_DIR}/index.html"    2> /dev/null || true
  rm "${HOST_REPORTS_DIR}/coverage.json" 2> /dev/null || true

  docker exec \
    "${CONTAINER_NAME}" \
    tar Ccf \
      "$(dirname "${CONTAINER_REPORTS_DIR}")" \
      - "$(basename "${CONTAINER_REPORTS_DIR}")" \
        | tar Cxf "${HOST_TEST_DIR}/" -

  # Check we generated expected files.
  exit_non_zero_unless_file_exists "${HOST_REPORTS_DIR}/${TEST_LOG}"
  exit_non_zero_unless_file_exists "${HOST_REPORTS_DIR}/index.html"
  exit_non_zero_unless_file_exists "${HOST_REPORTS_DIR}/coverage.json"

  # Check metrics limits file exists
  exit_non_zero_unless_file_exists "${HOST_TEST_DIR}/max_metrics.json"

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Process test-run results and coverage data.

  local -r CONTAINER_TMP_DIR=/tmp # fs is read-only with tmpfs at /tmp

  set +e
  docker run \
    --rm \
    --env CODE_DIR="${CODE_DIR}" \
    --env TEST_DIR="${TEST_DIR}" \
    --volume ${HOST_REPORTS_DIR}/${TEST_LOG}:${CONTAINER_TMP_DIR}/${TEST_LOG}:ro \
    --volume ${HOST_REPORTS_DIR}/coverage.json:${CONTAINER_TMP_DIR}/coverage.json:ro \
    --volume ${HOST_TEST_DIR}/max_metrics.json:${CONTAINER_TMP_DIR}/max_metrics.json:ro \
    cyberdojo/check-test-metrics:latest \
      "${CONTAINER_TMP_DIR}/${TEST_LOG}" \
      "${CONTAINER_TMP_DIR}/coverage.json" \
      "${CONTAINER_TMP_DIR}/max_metrics.json" \
    | tee -a "${HOST_REPORTS_DIR}/${TEST_LOG}"

  local -r STATUS=${PIPESTATUS[0]}
  set -e

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Tell caller where the results are...

  echo "${TYPE}" test branch-coverage report is at
  echo "${HOST_REPORTS_DIR}/index.html"
  echo "${TYPE} test status == ${STATUS}"
  echo
  if [ "${STATUS}" != 0 ]; then
    echo Docker logs "${CONTAINER_NAME}"
    echo
    docker logs "${CONTAINER_NAME}" 2>&1
  fi
  return ${STATUS}
}

# - - - - - - - - - - - - - - - - - - - - - - - - - -
exit_non_zero_unless_file_exists()
{
  local -r filename="${1}"
  if [ ! -f "${filename}" ]; then
    echo "ERROR: ${filename} does not exist"
    exit 42
  fi
}
