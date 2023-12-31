
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Note 0:
Suppose you have a structure like this:

    job-1:
      script:
        - do-something
        - report-it-to-kosli

    job-2:
      needs: [ job-1 ]
      script:
        - blah-blah

and you're worried about kosli-report command failure altering 
the exit status of the job and needlessly affecting the pipeline.
You might split off kosli-reporting into its own job, like this:

    job-1:
      script:
        - do-something

    report-job-1:
      needs; [ job-1 ]
      script:
        - report-it-to-kosli

    job-2:
      needs: [ job-1 ]
      script:
        - blah-blah

Note that job-2 needs:[job-1], not needs:[report-job-1]
A problem with this approach is that job-2 could have a `kosli assert`
as part of an sdlc-control-gate and it might run before the report has
happened. 
Another potential issue with this split is report-job-1 may only run
when job-1 was successful - so kosli will never see a failure report
only a missing report.

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Note 1:
In reports-to-staging.yml, you cannot set the api-token like this:

    job-name:
      stage: stage-name
      variables:
        KOSLI_API_TOKEN: ${KOSLI_STAGING_API_TOKEN}
      script:
        - kosli create flow ${KOSLI_FLOW}
            --description="UX for git+image version-reporter"
            --template=artifact,branch-coverage,security-scan,pull-request

This does not work, presumably because there is an _existing_ CI variable
called KOSLI_API_TOKEN (for reporting to https://app.kosli.com) which, it appears, 
you cannot override. So it is being explicitly set in each kosli command:

    job-name:
      stage: stage-name
      variables:
        KOSLI_STAGING_API_TOKEN: ${KOSLI_STAGING_API_TOKEN}
      script:
        - kosli create flow ${KOSLI_FLOW}
            --description="UX for git+image version-reporter"
            --template=artifact,branch-coverage,security-scan,pull-request
            --api-token=${KOSLI_STAGING_API_TOKEN}

This means that you do not need to specify the KOSLI_API_TOKEN in
the main.yml CI workflow, which is the main one that might be looked
at in demos.

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Note 2: 
I've only run kosli commands on main/master like this:

    job-name:
      stage: stage-name
      script:
        - if [ "${CI_COMMIT_BRANCH}" == "${CI_DEFAULT_BRANCH}" ] ; then
            kosli ... ;
          fi

You can't do it like this:

      job-name:
        stage: stage-name
        rules:
          - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH

      sdlc-control-gate:
        stage: sdlc-control-gate-stage
        needs: [ job-name ]

because the job with the rule: disappears when the if: is false
and so the sdlc-control-gate: needs: becomes invalid!
FYI - the if: syntax is very picky. 
You cant use ${} syntax:
          - if: ${CI_COMMIT_BRANCH} == $CI_DEFAULT_BRANCH
You cant quote:
          - if: $"CI_COMMIT_BRANCH" == $CI_DEFAULT_BRANCH


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Note 3:
When you run a snyk scan
$ snyk container test cyberdojo/web:2d3cd13
the exit code when there is a vulnerability is 1 (non zero).
This causes the job to exit, and any subsequent kosli
commands are not run. This means you only see a green or missing
(never a red). To see reds too you can do this:

      security-scan:
        script:
          - set +e
          - snyk container test cyberdojo/web:2d3cd13
          - STATUS=$?
          - kosli attest snyk ...
          - set -e
          - ...
          - exit $STATUS

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Note 4:
There is a tension in the CI workflows created by the fact that cyber-dojo Flows 
are unusual in that they need to repeat every Kosli step twice; 
once to report to https://app.kosli.com and once again to report to https://staging.app.kosli.com
A normal customer CI workflow yml file would only report to the former.
To resolve this, a git push triggers two workflows:

1) main.yml which reports to https://app.kosli.com

2) report-to-staging.yml which reports to https://staging.app.kosli.com
   This is basically the same as 1)main.yml but it does NOT...
   - build the docker image (since the build is not binary reproducible)
   - deploy the image to aws-beta/aws-prod (since main.yml already does that)
   (It _does_ however re-run the test evidence.)
   It is possible for the
   run from 1)main.yml to report a compliant Artifact and do deployments to aws-beta but the
   run from 2)report-to-staging.yml has not "caught-up" yet and so the Environment snapshot 
   that reports to https://staging.app.kosli.com sees the Artifact as incompliant.
   Note that situation also occurs if the unit-tests are flaky and pass for 1) but fail for 2)
