
repo_root() { git rev-parse --show-toplevel; }

echo_env_vars()
{
  #--------------------
  # Set env-vars for SCSS/JS asset-builder

  local -r asset_builder_port=5135
  local -r asset_env_filename="$(repo_root)/.env.asset_builder"
  echo "# This file is generated in bin/lib.sh echo_env_vars()" > "${asset_env_filename}"
  echo CYBER_DOJO_ASSET_BUILDER_PORT=${asset_builder_port}     >> "${asset_env_filename}"
  echo CYBER_DOJO_ASSET_BUILDER_PORT=${asset_builder_port}
  echo CYBER_DOJO_ASSET_BUILDER_IMAGE=cyberdojo/asset_builder
  echo CYBER_DOJO_ASSET_BUILDER_TAG=2bbe111
  echo CYBER_DOJO_ASSET_BUILDER_CONTAINER_NAME=asset_builder

  #--------------------
  # Set env-vars for this repo

  local -r commit_sha="$(cd "$(repo_root)" && git rev-parse HEAD)"
  local -r image_tag="${commit_sha:0:7}"

  docker run --rm cyberdojo/versioner:latest
  #
  echo CYBER_DOJO_CREATOR_SHA="${commit_sha}"
  echo CYBER_DOJO_CREATOR_TAG="${image_tag}"
  #
  echo CYBER_DOJO_CREATOR_CLIENT_IMAGE=cyberdojo/client
  echo CYBER_DOJO_CREATOR_CLIENT_PORT=9999
  #
  echo CYBER_DOJO_CREATOR_CLIENT_USER=nobody
  echo CYBER_DOJO_CREATOR_SERVER_USER=nobody
  #
  echo CYBER_DOJO_CREATOR_CLIENT_CONTAINER_NAME=test_creator_client
  echo CYBER_DOJO_CREATOR_SERVER_CONTAINER_NAME=test_creator_server
}
