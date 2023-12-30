
# TODO: add trap handler in curlers.sh to print curl-log on failure
# TODO: make curl_json_body_200 print the json on success

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
creator_port() { echo -n "${CYBER_DOJO_CREATOR_PORT}"; }
curl_log_filename() { echo -n /tmp/creator.log; }
tab() { printf '\t'; }

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
curl_json_body_200()
{
  local -r type="${1}"   # eg GET|POST
  local -r route="${2}"  # eg creator/ready
  local -r json="${3:-}" # eg '{"display_name":"Java Countdown, Round 1"}'

  touch "$(curl_log_filename)" && rm "$(curl_log_filename)"

  curl  \
    --data "${json}" \
    --fail \
    --header 'Content-type: application/json' \
    --header 'Accept: application/json' \
    --request "${type}" \
    --silent \
    --verbose \
      "http://localhost:$(creator_port)/${route}" \
      > "$(curl_log_filename)" 2>&1

  grep --quiet 200 "$(curl_log_filename)"             # eg HTTP/1.1 200 OK
  local -r result=$(tail -n 1 "$(curl_log_filename)") # eg {"sha":"78c19640aa43ea214da17d0bcb16abed420d7642"}
  echo "$(tab)${type} ${route} => 200 ${result}"
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
curl_200()
{
  local -r route="${1}"   # eg kata_choose
  local -r pattern="${2}" # eg exercise

  touch "$(curl_log_filename)" && rm "$(curl_log_filename)"

  curl  \
    --fail \
    --request GET \
    --silent \
    --verbose \
      "http://localhost:$(creator_port)/${route}" \
      > "$(curl_log_filename)" 2>&1

  grep --quiet 200 "$(curl_log_filename)" # eg HTTP/1.1 200 OK
  local -r result=$(grep "${pattern}" "$(curl_log_filename)" | head -n 1)
  echo "$(tab)GET ${route} => 200 ...|${result}"
}

