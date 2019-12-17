#!/bin/bash

readonly MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"
readonly TEST_FILES=(${MY_DIR}/../*_test.rb)
readonly TEST_ARGS=(${*})
readonly TEST_LOG=${COVERAGE_ROOT}/test.log
readonly TEST_LOG_TMP=${COVERAGE_ROOT}/test.log.tmp

readonly SCRIPT="([ '${MY_DIR}/coverage.rb' ] + %w(${TEST_FILES[*]})).each{ |file| require file }"

export RUBYOPT='-W2'
mkdir -p ${COVERAGE_ROOT}
ruby -e "${SCRIPT}" -- ${TEST_ARGS[@]} 2>&1 | tee ${TEST_LOG} ${TEST_LOG_TMP}

ruby ${MY_DIR}/check_test_results.rb \
  ${TEST_LOG_TMP} \
  ${COVERAGE_ROOT}/index.html \
    | tee -a ${TEST_LOG}
