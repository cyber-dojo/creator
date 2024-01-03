
# Branch protection is on for the main (default) branch

# Specifying rules: for parent-child pipelines

See https://gitlab.com/gitlab-org/gitlab/-/issues/222370

The rules for the parent pipeline (.gitlab-ci.yml) are turned off;

trigger-main:
  rules:
    - if: $CI_COMMIT_TAG == null
    - when: never

instead there are rules in the child pipelines (in .gitlab/workflows/) instead;

workflow:
  rules:
    - if: $CI_COMMIT_MESSAGE =~ /See merge request/

I can find no canonical way to run a pipeline _after_ a merge request.
See https://stackoverflow.com/questions/63893431/gitlab-run-a-pipeline-job-when-a-merge-request-is-merged

# report-to-staging.yml

The two child CI pipelines are triggered from .gitlab-ci.yml
  - main.yml reports to https://app.kosli.com
    The intention is for this to be as canonical as possible.
  - reporting-to-staging.yml reports to https://staging.app.kosli.com
    This is for development purposes.

Note: reporting-to-staging.yml is basically the same as main.yml, but...
   - it does _not_ rebuild the docker image (since the build is not binary reproducible)
     and we want the same artifact fingerprint in both Kosli URLs.
     Instead, it waits for the image to be built (in main.yml) using the script
     sh/wait_for_image.sh
   - it does _not_ deploy the image to aws-beta/aws-prod (since main.yml already does that)
     Instead, it waits for the image to be deployed (in main.yml) using the script
     sh/wait_for_deployment.sh

Note: reporting-to-staging.yml _does_ re-run the test evidence.
(This creates duplication but is done to keep main.yml canonical.) 
It is possible for:
- main.yml to report a compliant Artifact and do deployments to aws-beta and aws-prod 
- report-to-staging.yml to report the same Artifact as non-compliant 
- the Environment snapshot report for aws-beta on https://staging.app.kosli.com
  will see the Artifact deployment from main.yml and so, the Artifact will be 
  non-compliant in the snapshot.
