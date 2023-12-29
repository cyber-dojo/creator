
repo_root()
{
  git rev-parse --show-toplevel
}

git_commit_sha()
{
    echo "$(cd "$(repo_root)" && git rev-parse HEAD)"
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
    echo ', "client": '
    cat "$(repo_root)/test/client/reports/coverage.json"
    echo '}'
  } > "$(test_evidence_json_path)"
}

test_evidence_json_path()
{
  echo "$(repo_root)/test/evidence.json"
}
