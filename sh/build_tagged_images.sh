#!/bin/bash -Eeu

source "${SH_DIR}/augmented_docker_compose.sh"

#- - - - - - - - - - - - - - - - - - - - - - - -
build_tagged_images()
{
  local -r dil=$(docker image ls --format "{{.Repository}}:{{.Tag}}")
  remove_all_but_latest "${dil}" "${CYBER_DOJO_CREATOR_CLIENT_IMAGE}"
  remove_all_but_latest "${dil}" "${CYBER_DOJO_CREATOR_IMAGE}"
  build_images
  tag_images
  check_embedded_env_var
}

# - - - - - - - - - - - - - - - - - - - - - -
remove_all_but_latest()
{
  local -r docker_image_ls="${1}"
  local -r name="${2}"
  for image_name in `echo "${docker_image_ls}" | grep "${name}:"`
  do
    if [ "${image_name}" != "${name}:latest" ]; then
      if [ "${image_name}" != "${name}:<none>" ]; then
        docker image rm "${image_name}"
      fi
    fi
  done
}

#- - - - - - - - - - - - - - - - - - - - - - - -
build_images()
{
  augmented_docker_compose \
    build \
    --build-arg COMMIT_SHA=$(git_commit_sha)
}

#- - - - - - - - - - - - - - - - - - - - - - - -
tag_images()
{
  docker tag ${CYBER_DOJO_CREATOR_IMAGE}:$(image_tag)        ${CYBER_DOJO_CREATOR_IMAGE}:latest
  docker tag ${CYBER_DOJO_CREATOR_CLIENT_IMAGE}:$(image_tag) ${CYBER_DOJO_CREATOR_CLIENT_IMAGE}:latest
}

# - - - - - - - - - - - - - - - - - - - - - -
check_embedded_env_var()
{
  if [ "$(git_commit_sha)" != "$(sha_in_image)" ]; then
    echo "ERROR: unexpected env-var inside image $(image_name):$(image_tag)"
    echo "expected: 'SHA=$(git_commit_sha)'"
    echo "  actual: 'SHA=$(sha_in_image)'"
    exit 42
  fi
}