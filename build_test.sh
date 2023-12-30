#!/usr/bin/env bash
set -Eeu

repo_root() { git rev-parse --show-toplevel; }
source "$(repo_root)/sh/run_tests_with_coverage.sh"
run_tests_with_coverage "$@"
