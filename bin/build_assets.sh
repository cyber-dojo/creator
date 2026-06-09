#!/usr/bin/env bash
set -Eeu

readonly my_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly tmp_dir=$(mktemp -d "/tmp/asset_builder.XXX")
remove_tmp_dir() { rm -rf "${tmp_dir}" > /dev/null; }
trap remove_tmp_dir INT EXIT

source "${my_dir}/lib.sh"
source "${my_dir}/echo_env_vars.sh"
exit_non_zero_unless_installed docker curl
export $(echo_env_vars)

docker compose --progress=plain up --detach --no-build --wait --wait-timeout=10 asset_builder

readonly assets_dir="${my_dir}/../app/assets"
readonly url="http://localhost:${CYBER_DOJO_ASSET_BUILDER_PORT}"

# Inside a CI run, you cannot always do a 'curl http://localhost:....'
# so curl from inside the asset_builder container instead.
# See https://stackoverflow.com/questions/78908814/gitlab-ci-fails-with-failed-to-connect-to-localhost

docker exec asset_builder curl "${url}/assets/app.css" \
  > "${assets_dir}/stylesheets/pre-built-app.css"

docker exec asset_builder curl "${url}/assets/app.js"  \
  > "${assets_dir}/javascripts/pre-built-app.js"
