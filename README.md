[![CircleCI](https://circleci.com/gh/cyber-dojo/creator.svg?style=svg)](https://circleci.com/gh/cyber-dojo/creator)

# cyberdojo/creator

- The source for the [cyberdojo/creator](https://hub.docker.com/r/cyberdojo/creator/tags) Docker image.
- A docker-containerized stateless micro-service for [https://cyber-dojo.org](http://cyber-dojo.org).
- An http service, on port 4523, for creating a new group-exercise or a new individual-exercise.

- - - -
* [POST group_create_custom(display_names,options)](docs/api.md#post-group_create_customdisplay_namesoptions)
* [POST kata_create_custom(display_name,options)](docs/api.md#post-kata_create_customdisplay_nameoptions)
* [POST group_create(exercise_name,languages_names,options)](docs/api.md#post-group_createexercise_namelanguages_namesoptions)
* [POST kata_create(exercise_name,language_name,options)](docs/api.md#post-kata_createexercise_namelanguage_nameoptions)
* [GET ready?](docs/api.md#get-ready)
* [GET alive?](docs/api.md#get-alive)  
* [GET sha](docs/api.md#get-sha)

- - - -
![cyber-dojo.org home page](https://github.com/cyber-dojo/cyber-dojo/blob/master/shared/home_page_snapshot.png)
