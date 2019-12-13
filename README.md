[![CircleCI](https://circleci.com/gh/cyber-dojo/creator.svg?style=svg)](https://circleci.com/gh/cyber-dojo/creator)

# cyberdojo/creator docker image

- The source for the [cyberdojo/creator](https://hub.docker.com/r/cyberdojo/creator/tags) Docker image.
- A docker-containerized stateless micro-service for [https://cyber-dojo.org](http://cyber-dojo.org).
- Creates a new group or kata.

- - - -
# API
  * [POST create_group(manifest)](#get-creategroupmanifest)
  * [POST create_kata(manifest)](#get-createkatamanifest)
  * [GET ready?](#get-ready)
  * [GET alive?](#get-alive)  
  * [GET sha](#get-sha)

- - - -
# JSON in, JSON out  
* All methods receive a JSON hash.
  * The hash contains any method arguments as key-value pairs.
* All methods return a JSON hash.
  * If the method completes, a key equals the method's name.
  * If the method raises an exception, a key equals "exception".

- - - -
# POST create_group(manifest)

- - - -
# POST create_kata(manifest)

- - - -
# GET ready?
Useful as a readiness probe.
- returns
  * **true** if the service is ready
  ```json
  { "ready?": true }
  ```
  * **false** if the service is not ready
  ```json
  { "ready?": false }
  ```
- parameters
  * none
  ```json
  {}
  ```

- - - -
# GET alive?
Useful as a liveness probe.
- returns
  * **true**
  ```json
  { "ready?": true }
  ```
- parameters
  * none
  ```json
  {}
  ```

- - - -
# GET sha
The git commit sha used to create the Docker image.
- returns
  * The 40 character sha string.
  * eg
  ```json
  { "sha": "41d7e6068ab75716e4c7b9262a3a44323b4d1448" }
  ```
- parameters
  * none
  ```json
  {}
  ```

- - - -
# build the demo and run it
- Runs inside the creator-client's container.
- Calls the creator-server's methods and displays their json results and how long they took.

```bash
$ ./sh/run_demo.sh
```
![demo screenshot](test_client/src/demo_screenshot.png?raw=true "demo screenshot")

- - - -
![cyber-dojo.org home page](https://github.com/cyber-dojo/cyber-dojo/blob/master/shared/home_page_snapshot.png)
