
# Branch protection is on for the main (default) branch

# Specifying parent-child pipeline rules:

See https://gitlab.com/gitlab-org/gitlab/-/issues/222370  
The rules for the parent pipeline (.gitlab-ci.yml) are turned off;
```yml
trigger-main:
  rules:
    - if: $CI_COMMIT_TAG == null
    - when: never
```
instead there are rules in the child pipelines (in .gitlab/workflows/) instead;
```yml
workflow:
  rules:
    - if: $CI_COMMIT_MESSAGE =~ /See merge request/
```
I can find no canonical way to run a pipeline _after_ a merge request.  
See https://stackoverflow.com/questions/63893431/gitlab-run-a-pipeline-job-when-a-merge-request-is-merged

# report-to-staging.yml

Two child CI pipelines are triggered from .gitlab-ci.yml
- main.yml reports to https://app.kosli.com  
  The intention is for this to be as canonical as possible.
- report-to-staging.yml reports to https://staging.app.kosli.com  
  This is for development purposes.

Note: report-to-staging.yml is very similar to main.yml, but...
- it does _not_ rebuild the docker image (since the build is not binary reproducible).  
  Instead, it waits for the image to be built (in main.yml) using [sh/wait_for_image.sh](sh/wait_for_image.sh)  
  Having the same artifact fingerprint enables snapshot comparison across Environments.
- it does _not_ deploy the image to aws-beta/aws-prod (since main.yml already does that).  
  Instead, it waits for the image to be deployed (in main.yml) using [sh/wait_for_deployment.sh](sh/wait_for_deployment.sh)

Note: reporting-to-staging.yml _does_ re-run the tests.  
This creates duplication but keeps main.yml canonical.   
This is possible:
- main.yml reports a compliant Artifact and deploy to aws-beta/aws-prod 
- report-to-staging.yml reports the same Artifact as non-compliant 
- the Environment snapshot report for aws-beta on https://staging.app.kosli.com
  sees the Artifact deployment from main.yml and so, the Artifact will be 
  non-compliant in the snapshot.
