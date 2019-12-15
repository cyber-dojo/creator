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
  * [GET ready?](#get-http-ready)
  * [GET alive?](#get-alive)  
  * [GET sha](#get-sha)

- - - -
# JSON in, JSON out
  * All methods are named in the http request path
  * All methods pass any arguments as a json hash in the http request's body.
    * If there are no arguments you can use ```''``` (which is the default
      for ```curl --data```) instead of ```'{}'```.
  * All methods return a json hash in the http response's body.
    * If the method completes, a string key equals the method's name, with
      a value as documented below. eg
      ```bash
      curl \
        --silent \
        -X GET \
        http://${IP_ADDRESS}:${PORT}/alive? \
          | jq      
      {
        "alive?": true
      }
      ```
    * If the method raises an exception, a string key equals ```exception```, with
      a json-hash as its value. eg
      ```bash
      curl \
        --data '{nope}' \
        --silent \
        -X POST \
        http://${IP_ADDRESS}:${PORT}/create_group \
          | jq      
      {
        "exception": {
          "path": "/create_group",
          "body": "{nope}",
          "class": "CreatorService",
          "message": "body is not JSON",
          "backtrace": [
            "/app/http_json_args.rb:14:in `rescue in initialize'",
            "/app/http_json_args.rb:8:in `initialize'",
            "/app/rack_dispatcher.rb:18:in `new'",          
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
# GET ready?
Used as a [Kubernetes](https://kubernetes.io/) readiness probe.
- example
  ```bash     
  curl --silent -X GET http://${IP_ADDRESS}:${PORT}/ready?
  ```
- parameters: none
- returns
  * **true** if the service is ready
  ```json
  { "ready?": true }
  ```
  * **false** if the service is not ready
  ```json
  { "ready?": false }
  ```

- - - -
# GET alive?
Used as a [Kubernetes](https://kubernetes.io/) liveness probe.
- example
  ```bash     
  curl --silent -X GET http://${IP_ADDRESS}:${PORT}/alive?
  ```
- parameters: none
- returns: true
  ```json
  { "alive?": true }
  ```

- - - -
# GET sha
The git commit sha used to create the Docker image.
- example
  ```bash     
  curl --silent -X GET http://${IP_ADDRESS}:${PORT}/sha
  ```
- parameters: none.
- returns: the 40 character commit sha.
  ```json
  { "sha": "41d7e6068ab75716e4c7b9262a3a44323b4d1448" }
  ```

- - - -
![cyber-dojo.org home page](https://github.com/cyber-dojo/cyber-dojo/blob/master/shared/home_page_snapshot.png)
