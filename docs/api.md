# API
- - - -
## POST group_create_custom(display_names,options)
Creates a new group from the [custom-start-points](https://github.com/cyber-dojo/custom-start-points) manifest whose key is the first display_name in `display_names` and returns the group's id.
- parameters [(JSON-in)](#json-in)
  * **display_names:[String...]**.
  At present only `display_names[0]` is used.
  An array for a planned future feature.
  * **options:Hash[Symbol=>Boolean]**.
  Currently unused. For a planned future feature.
- returns [(JSON-out)](#json-out)
  * the new group's id.
- example
  ```bash
  $ curl \
    --data '{"display_names":["Java Countdown, Round 1"]}' \
    --header 'Content-type: application/json' \
    --silent \
    -X POST \
      http://${IP_ADDRESS}:${PORT}/group_create_custom
  {"group_create_custom":"P0R0cU"}
  ```

- - - -
## POST kata_create_custom(display_name,options)
Creates a new kata from the [custom-start-points](https://github.com/cyber-dojo/custom-start-points) manifest whose key is `display_name` and returns the kata's id.
- parameters [(JSON-in)](#json-in)
  * **display_name:String**.
  * **options:Hash[Symbol=>Boolean]**
  Currently unused. For a planned feature.
- returns [(JSON-out)](#json-out)
  * the new kata's id.
- example
  ```bash
  $ curl \
    --data '{"display_name":"Java Countdown, Round 2"}' \
    --header 'Content-type: application/json' \
    --silent \
    -X POST \
      http://${IP_ADDRESS}:${PORT}/kata_create_custom
  {"kata_create_custom":"8Ey4xK"}
  ```

- - - -
## GET ready?
Tests if the service is ready to handle requests.
- parameters
  * none
- returns [(JSON-out)](#json-out)
  * **true** if the service is ready
  * **false** if the service is not ready
- notes
  * Used as a [Kubernetes](https://kubernetes.io/) readiness probe.
- example
  ```bash     
  $ curl --silent -X GET http://${IP_ADDRESS}:${PORT}/ready?
  {"ready?":false}
  ```

- - - -
## GET alive?
Tests if the service is alive.  
- parameters
  * none
- returns [(JSON-out)](#json-out)
  * **true**
- notes
  * Used as a [Kubernetes](https://kubernetes.io/) liveness probe.  
- example
  ```bash     
  $ curl --silent -X GET http://${IP_ADDRESS}:${PORT}/alive?
  {"alive?":true}
  ```

- - - -
## GET sha
The git commit sha used to create the Docker image.
- parameters
  * none
- returns [(JSON-out)](#json-out)
  * the 40 character commit sha string.
- example
  ```bash     
  $ curl --silent -X GET http://${IP_ADDRESS}:${PORT}/sha
  {"sha":"41d7e6068ab75716e4c7b9262a3a44323b4d1448"}
  ```

- - - -
## JSON in
- All methods pass any arguments as a json hash in the http request body.
  * If there are no arguments you can use `''` (which is the default
    for `curl --data`) instead of `'{}'`.

- - - -
## JSON out      
- All methods return a json hash in the http response body.
  * If the method completes, a string key equals the method's name. eg
    ```bash
    $ curl --silent -X GET http://${IP_ADDRESS}:${PORT}/ready?
    {"ready?":true}
    ```
  * If the method raises an exception, a string key equals `"exception"`, with
    a json-hash as its value. eg
    ```bash
    $ curl --silent -X POST http://${IP_ADDRESS}:${PORT}/group_create_custom | jq      
    {
      "exception": {
        "path": "/group_create_custom",
        "body": "",
        "class": "CreatorService",
        "message": "manifest is missing",
        "backtrace": [
          ...
          "/usr/bin/rackup:23:in `<main>'"
        ]
      }
    }
    ```
