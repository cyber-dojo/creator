
SHORT_SHA := $(shell git rev-parse HEAD | head -c7)
IMAGE_NAME := cyberdojo/creator:${SHORT_SHA}

.PHONY: image snyk-container

assets:
	@${PWD}/sh/build_assets.sh

image: assets
	${PWD}/build_test.sh --build-only

run-tests:
	bash -c ". ${PWD}/sh/run_tests_with_coverage.sh && run_tests_with_coverage"

snyk-container: image
	snyk container test ${IMAGE_NAME} \
		--file=Dockerfile \
		--policy-path=.snyk \
		--sarif \
		--sarif-file-output=snyk.container.scan.json
