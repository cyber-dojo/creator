#!/bin/bash -Eeu

source "${SH_DIR}/augmented_docker_compose.sh"

#- - - - - - - - - - - - - - - - - - - - - - - -
build_tagged_images()
{
  remove_current_docker_image "${CYBER_DOJO_CREATOR_IMAGE}"
  remove_current_docker_image "${CYBER_DOJO_CREATOR_CLIENT_IMAGE}"
  build_images
  tag_images
  check_embedded_env_var
}

# - - - - - - - - - - - - - - - - - - - - - -
remove_current_docker_image()
{
  local -r name="${1}"
  if image_exists "${name}" 'latest' ; then
    local -r sha="$(docker run --rm -it ${name}:latest sh -c 'echo -n ${SHA}')"
    local -r tag="${sha:0:7}"
    if image_exists "${name}" "${tag}" ; then
      echo "Deleting current image ${name}:${tag}"
      docker image rm "${name}:${tag}"
    fi
  fi
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

# - - - - - - - - - - - - - - - - - - - - - -
# - - - - - - - - - - - - - - - - - - - - - -
image_exists()
{
  local -r name="${1}"
  local -r tag="${2}"
  local -r latest=$(docker image ls --format "{{.Repository}}:{{.Tag}}" | grep "${name}:${tag}")
  [ "${latest}" != '' ]
}
