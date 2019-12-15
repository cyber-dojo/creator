[![CircleCI](https://circleci.com/gh/cyber-dojo/creator.svg?style=svg)](https://circleci.com/gh/cyber-dojo/creator)

# cyberdojo/creator docker image

- The source for the [cyberdojo/creator](https://hub.docker.com/r/cyberdojo/creator/tags) Docker image.
- A docker-containerized stateless micro-service for [https://cyber-dojo.org](http://cyber-dojo.org).
- An http service for creating a new group or a new kata from a start-point manifest.
- Work in progress. Not live yet.

- - - -
# API
  * [POST create_group(manifest)](#post-creategroupmanifest)
  * [POST create_kata(manifest)](#post-createkatamanifest)
  * [GET HTTP ready?](#get-http-ready)
  * [GET HTTP alive?](#get-http-alive)  
  * [GET HTTP sha](#get-http-sha)

- - - -
# JSON in, JSON out
    * If the method raises an exception, a string key equals ```exception```, with
      a json-hash as its value. eg
      ```bash
      curl \
        --silent \
        -X POST \
        http://${IP_ADDRESS}:${PORT}/create_group \
          | jq      
      {
        "exception": {
          "path": "/create_group",
          "body": "{}",
          "class": "CreatorService",
          "message": "manifest is missing",
          "backtrace": [
            "/app/http_json_args.rb:51:in `exists_arg'",
            "/app/http_json_args.rb:44:in `manifest'",
            "/app/http_json_args.rb:24:in `get'",
            "/app/rack_dispatcher.rb:18:in `call'",
            ...
            "/usr/bin/rackup:23:in `<main>'"
          ]
        }
      }
      ```

- - - -
# POST create_group(manifest)

- - - -
# POST create_kata(manifest)

- - - -
# GET HTTP ready?
Used as a [Kubernetes](https://kubernetes.io/) readiness probe.
- example
  ```bash     
  curl --silent -X GET http://${IP_ADDRESS}:${PORT}/ready?
  ```
- parameters
  * none
- returns
  * a json hash with a "ready?" key.
  * **true** if the service is ready
  ```json
  { "ready?": true }
  ```
  * **false** if the service is not ready
  ```json
  { "ready?": false }
  ```

- - - -
# GET HTTP alive?
Used as a [Kubernetes](https://kubernetes.io/) liveness probe.
- example
  ```bash     
  curl --silent -X GET http://${IP_ADDRESS}:${PORT}/alive?
  ```
- parameters
  * none
- returns
  * a json hash with an "alive?" key.
  ```json
  { "alive?": true }
  ```

- - - -
# GET HTTP sha
The git commit sha used to create the Docker image.
- example
  ```bash     
  curl --silent -X GET http://${IP_ADDRESS}:${PORT}/sha
  ```
- parameters
  * none
- returns
  * a json hash with a "sha" key.
  ```json
  { "sha": "41d7e6068ab75716e4c7b9262a3a44323b4d1448" }
  ```

- - - -
![cyber-dojo.org home page](https://github.com/cyber-dojo/cyber-dojo/blob/master/shared/home_page_snapshot.png)
