#!/usr/bin/env bash
set -Eeu

export ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export SH_DIR="${ROOT_DIR}/sh"

source "${SH_DIR}/augmented_docker_compose.sh"
source "${SH_DIR}/build_tagged_images.sh"
source "${SH_DIR}/containers_down.sh"
source "${SH_DIR}/containers_up_healthy_and_clean.sh"
source "${SH_DIR}/copy_in_saver_test_data.sh"
source "${SH_DIR}/exit_non_zero_unless_installed.sh"
source "${SH_DIR}/exit_zero_if_build_only.sh"
source "${SH_DIR}/exit_zero_if_show_help.sh"
source "${SH_DIR}/kosli.sh"
source "${SH_DIR}/on_ci_publish_tagged_images.sh"
source "${SH_DIR}/remove_old_images.sh"
source "${SH_DIR}/test_in_containers.sh"

source "${SH_DIR}/echo_versioner_env_vars.sh"
export $(echo_versioner_env_vars)

# - - - - - - - - - - - - - - - - - - - - - - - -

# Setup
exit_zero_if_show_help "$@"
exit_non_zero_unless_installed docker
exit_non_zero_unless_installed docker-compose
remove_old_images

# Build, publish and report image creation
build_tagged_images
on_ci_publish_tagged_images
on_ci_kosli_declare_pipeline
on_ci_kosli_report_artifact_creation

exit_zero_if_build_only "$@"

# Test and report
server_up_healthy_and_clean
client_up_healthy_and_clean "$@"
copy_in_saver_test_data
test_in_containers "$@"
on_ci_kosli_report_coverage_evidence
containers_down

# Return non-zero for non-compliant artifact
on_ci_kosli_assert_artifact
