#!/usr/bin/env bash
set -Eeu

repo_root() { git rev-parse --show-toplevel; }

export SH_DIR="$(repo_root)/sh"

source "${SH_DIR}/build_tagged_images.sh"
source "${SH_DIR}/containers_down.sh"
source "${SH_DIR}/containers_up_healthy_and_clean.sh"
source "${SH_DIR}/copy_in_saver_test_data.sh"
source "${SH_DIR}/echo_versioner_env_vars.sh"
source "${SH_DIR}/exit_non_zero_unless_installed.sh"
source "${SH_DIR}/exit_zero_if_build_only.sh"
source "${SH_DIR}/exit_zero_if_show_help.sh"
source "${SH_DIR}/lib.sh"
source "${SH_DIR}/remove_old_images.sh"
source "${SH_DIR}/test_in_containers.sh"
export $(echo_versioner_env_vars)

run_tests_with_coverage()
{
  set +e
  exit_status=0

  exit_zero_if_show_help "$@"
  exit_non_zero_unless_installed docker
  exit_non_zero_unless_installed docker-compose
  remove_old_images

  build_tagged_images
  #exit_zero_if_build_only "$@"
  server_up_healthy_and_clean
  client_up_healthy_and_clean "$@"
  copy_in_saver_test_data
  test_in_containers "$@" || exit_status=$?
  containers_down
  write_test_evidence_json
  set -e
  return ${exit_status}
}

run_tests_with_coverage
