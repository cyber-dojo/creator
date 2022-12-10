#!/bin/bash -Eeu

# cyberdojo/service-yaml image lives at
# https://github.com/cyber-dojo-tools/service-yaml

# The initial change-directory command is needed because
# the current working directory is taken as the dir for
# relative pathnames (eg in volume-mounts) when the
# yml is received from stdin (--file -).
#
# runner is needed as a service because when a kata
# is created the runner(s) are told its docker image
# name so they can ensure it is pulled onto the nodes.

augmented_docker_compose()
{
  cd "$(root_dir)" && cat "./docker-compose.yml" \
    | docker run --rm --interactive cyberdojo/service-yaml \
         custom-start-points \
      exercises-start-points \
      languages-start-points \
                      runner \
                       saver \
                    selenium \
    | tee /tmp/augmented-docker-compose.creator.peek.yml \
    | docker-compose \
        --project-name cyber-dojo \
        --file -       \
        "$@"
}
