
SHORT_SHA := $(shell git rev-parse HEAD | head -c7)
IMAGE_NAME := cyberdojo/creator:${SHORT_SHA}

.PHONY: creator_image creator_test creator_test_server creator_test_client
.PHONY: creator_rubocop_lint creator_snyk_container_scan creator_demo

creator_image:
	bash -c ". ${PWD}/creator/bin/build_tagged_images.sh && build_tagged_images"

creator_test:
	bash -c ". ${PWD}/creator/bin/run_tests_with_coverage.sh && run_tests_with_coverage"

# Run only the server (or client) tests. Optionally filter by test-id prefix(es)
# via the tids var, eg:  make creator_test_server tids=p42   or   make creator_test_server tids="p42 p99"
creator_test_server:
	@${PWD}/creator/bin/run_tests_with_coverage.sh server ${tids}

creator_test_client:
	@${PWD}/creator/bin/run_tests_with_coverage.sh client ${tids}

creator_rubocop_lint:
	@${PWD}/creator/bin/rubocop-lint.sh

creator_snyk_container_scan: creator_image
	snyk container test ${IMAGE_NAME} \
		--file=Dockerfile \
		--policy-path=creator/.snyk \
		--sarif \
		--sarif-file-output=snyk.container.scan.json

creator_demo:
	@${PWD}/creator/bin/demo.sh
