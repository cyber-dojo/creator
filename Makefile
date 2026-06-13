
SHORT_SHA := $(shell git rev-parse HEAD | head -c7)
IMAGE_NAME := cyberdojo/creator:${SHORT_SHA}

.PHONY: assets image rubocop-lint snyk-container

assets:
	${PWD}/bin/build_assets.sh

image:
	bash -c ". ${PWD}/bin/build_tagged_images.sh && build_tagged_images"

test:
	bash -c ". ${PWD}/bin/run_tests_with_coverage.sh && run_tests_with_coverage"

rubocop-lint:
	@docker run --rm --volume "${PWD}:/app" cyberdojo/rubocop --raise-cop-error

snyk-container: image
	snyk container test ${IMAGE_NAME} \
		--file=Dockerfile \
		--policy-path=.snyk \
		--sarif \
		--sarif-file-output=snyk.container.scan.json

demo:
	@${PWD}/bin/demo.sh
