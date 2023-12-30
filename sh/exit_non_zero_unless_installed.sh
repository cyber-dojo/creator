# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
exit_non_zero_unless_installed()
{
  for dependent in "$@"
  do
    printf "Checking %s is installed..." "${dependent}"
    if ! installed "${dependent}" ; then
      stderr "${dependent} is not installed"
      exit 42
    else
      echo It is
    fi
  done
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
installed()
{
  local -r dependent="${1}"
  if hash "${dependent}" 2> /dev/null; then
    true
  else
    false
  fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
stderr()
{
  local -r message="${1}"
  >&2 echo "ERROR: ${message}"
}