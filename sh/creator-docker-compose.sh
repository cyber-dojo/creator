#!/bin/bash -Eeu

creator_docker_compose()
{
  cd "${ROOT_DIR}" && cat "./docker-compose.yml" \
    | docker run --rm --interactive cyberdojo/service-yaml \
         custom-start-points \
      exercises-start-points \
      languages-start-points \
    | \
      docker-compose --file - "$@"
}
