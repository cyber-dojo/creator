#!/usr/bin/env bash
set -Eeu

# Your GitLab details
GITLAB_URL="https://gitlab.com/api/graphql"
PROJECT_PATH="cyber-dojo/creator"  # e.g., "namespace/project"

# GraphQL query to get all branch rules for a project
QUERY=$(cat << EOF
{"query": "{
  project(fullPath: \"${PROJECT_PATH}\") {
    branchRules {
      nodes {
        id name isProtected isDefault branchProtection {
          allowForcePush mergeAccessLevels {
            nodes {
              accessLevel accessLevelDescription group {
                name
              }
              user {
                name username
              }
            }
          }
          pushAccessLevels {
            nodes {
              accessLevel accessLevelDescription group {
                name
              }
              user {
                name username
              }
            }
          }
        }
      }
    }
  }
}"}
EOF
)

# Strip whitespace from query
QUERY="$(echo -n "${QUERY//[[:space:]]/}")"

# Make the API call and save the output to a file
curl --header "Authorization: Bearer $GITLAB_READ_TOKEN" \
     --header "Content-Type: application/json" \
     --request POST \
     --data-raw "$QUERY" \
     "$GITLAB_URL" > gitlab_branch_rules.json

echo "Saved all branch rules to gitlab_branch_rules.json"
cat gitlab_branch_rules.json