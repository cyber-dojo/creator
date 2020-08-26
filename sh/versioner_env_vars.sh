#!/bin/bash -Eeu

versioner_env_vars()
{
  local -r sha=$(git_commit_sha)
  local -r tag="${sha:0:7}"
  docker run --rm cyberdojo/versioner:latest
  echo CYBER_DOJO_CREATOR_SHA="${sha}"
  echo CYBER_DOJO_CREATOR_TAG="${tag}"
  echo CYBER_DOJO_CREATOR_CLIENT_IMAGE=cyberdojo/creator-client
  echo CYBER_DOJO_CREATOR_CLIENT_PORT=9999
  echo CYBER_DOJO_CREATOR_CLIENT_USER=nobody
  echo CYBER_DOJO_CREATOR_SERVER_USER=nobody
}
