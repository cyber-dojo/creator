
repo_root()
{
  git rev-parse --show-toplevel
}

git_commit_sha()
{
  cd "$(repo_root)" && git rev-parse HEAD
}

get_image_tag()
{
  local -r sha="$(git_commit_sha)"
  echo "${sha:0:7}"
}

on_ci()
{
  [ -n "${CI:-}" ]
}

write_test_evidence_json()
{
  {
    echo '{ "server": '
    cat "$(repo_root)/test/server/reports/coverage.json"
    if [ "${1:-}" != 'server' ]; then
      echo ', "client": '
      cat "$(repo_root)/test/client/reports/coverage.json"
    fi
    echo '}'
  } | jq . > "$(test_evidence_json_path)"
}

test_evidence_json_path()
{
  echo "$(repo_root)/test/evidence.json"
}
