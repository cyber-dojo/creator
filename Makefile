
SHORT_SHA := $(shell git rev-parse HEAD | head -c7)
IMAGE_NAME := cyberdojo/creator:${SHORT_SHA}

.PHONY: image snyk-container

assets:
	@${PWD}/sh/build_assets.sh

image: assets
	${PWD}/build_test.sh --build-only

snyk-container: image
	snyk container test ${IMAGE_NAME} \
		--file=Dockerfile \
		--policy-path=.snyk \
		--sarif \
		--sarif-file-output=snyk.container.scan.json
