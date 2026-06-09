
# Branch protection is on for the main (default) branch

# Specifying parent-child pipeline rules

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
    - if: $CI_COMMIT_MESSAGE =~ /See merge request/ && $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH
```

# A pipeline that runs only _after_ a merge request

I can find no canonical way to do this.  
See https://stackoverflow.com/questions/63893431/gitlab-run-a-pipeline-job-when-a-merge-request-is-merged
When you push a branch you will get a failed Pipeline run.  
When a merge-request is merged into main, the Pipeline(s) will run.

# What is my branch?

By default, Gitlab checks out the commit and not the branch. 
This means you are in a "detached HEAD" state, and Kosli does not know the name of the branch.
See https://stackoverflow.com/questions/69267025/detached-head-in-gitlab-ci-pipeline-how-to-push-correctly

To fix this I needed to do two things:
1. The Git strategy settings had to be altered from the default:
(also needed to ensure the [kosli report approval] has commit depth)
From the Settings at the bottom on the lhs, select CI/CD
- Expand General pipelines
- Set the [Git strategy] radio-button to [git clone]
- Set the [Git shallow clone] text field to [0]

2. Add a default: before_script: to all workflows: 
```yml
default:
  before_script:
    - git checkout -b ${CI_COMMIT_BRANCH}
```
