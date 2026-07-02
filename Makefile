
SHORT_SHA := $(shell git rev-parse HEAD | head -c7)
IMAGE_NAME := cyberdojo/creator:${SHORT_SHA}

.PHONY: image test test_server test_client rubocop-lint snyk-container demo

image:
	bash -c ". ${PWD}/bin/build_tagged_images.sh && build_tagged_images"

test:
	bash -c ". ${PWD}/bin/run_tests_with_coverage.sh && run_tests_with_coverage"

# Run only the server (or client) tests. Optionally filter by test-id prefix(es)
# via the tids var, eg:  make test_server tids=p42   or   make test_server tids="p42 p99"
test_server:
	@${PWD}/bin/run_tests_with_coverage.sh server ${tids}

test_client:
	@${PWD}/bin/run_tests_with_coverage.sh client ${tids}

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
