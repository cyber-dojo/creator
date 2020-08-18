#!/bin/bash -Eeu
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# cyberdojo/service-yaml image lives at
# https://github.com/cyber-dojo-tools/service-yaml

augmented_docker_compose()
{
  cd "${ROOT_DIR}" && cat "./docker-compose.yml" \
    | docker run --rm --interactive cyberdojo/service-yaml \
         custom-start-points \
      exercises-start-points \
      languages-start-points \
                       saver \
                      puller \
                    selenium \
    | tee /tmp/augmented-docker-compose.creator.peek.yml \
    | docker-compose \
      --file -       \
      "$@"
}
