# MegaLinter - SAST and SCA

* https://megalinter.io/latest/
* https://github.com/oxsecurity/megalinter


* MegaLinter & Grafana as reporter: https://megalinter.io/latest/reporters/ApiReporter/


```sh
npx mega-linter-runner --install




```



```sh

/usr/bin/docker run \
--name oxsecuritymegalinterv830_a05f34 \
--label ed5733 \
--workdir /github/workspace \
--rm \
-e "APPLY_FIXES" \
-e "APPLY_FIXES_EVENT" \
-e "APPLY_FIXES_MODE" \
-e "VALIDATE_ALL_CODEBASE" \
-e "GITHUB_TOKEN" \
-e "REPOSITORY_TRIVY_PRE_COMMANDS" \
-e "REPOSITORY_TRIVY_CLI_LINT_MODE" \
-e "HOME" \
-e "GITHUB_JOB" \
-e "GITHUB_REF" \
-e "GITHUB_SHA" \
-e "GITHUB_REPOSITORY" \
-e "GITHUB_REPOSITORY_OWNER" \
-e "GITHUB_REPOSITORY_OWNER_ID" \
-e "GITHUB_RUN_ID" \
-e "GITHUB_RUN_NUMBER" \
-e "GITHUB_RETENTION_DAYS" \
-e "GITHUB_RUN_ATTEMPT" \
-e "GITHUB_REPOSITORY_ID" \
-e "GITHUB_ACTOR_ID" \
-e "GITHUB_ACTOR" \
-e "GITHUB_TRIGGERING_ACTOR" \
-e "GITHUB_WORKFLOW" -e "GITHUB_HEAD_REF" \
-e "GITHUB_BASE_REF" -e "GITHUB_EVENT_NAME" -e "GITHUB_SERVER_URL" \
-e "GITHUB_API_URL" -e "GITHUB_GRAPHQL_URL" -e "GITHUB_REF_NAME" \
-e "GITHUB_REF_PROTECTED" -e "GITHUB_REF_TYPE" -e "GITHUB_WORKFLOW_REF" \
-e "GITHUB_WORKFLOW_SHA" \
-e "GITHUB_WORKSPACE" \
-e "GITHUB_ACTION" \
-e "GITHUB_EVENT_PATH" \
-e "GITHUB_ACTION_REPOSITORY" \
-e "GITHUB_ACTION_REF" \
-e "GITHUB_PATH" \
-e "GITHUB_ENV" \
-e "GITHUB_STEP_SUMMARY" \
-e "GITHUB_STATE" \
-e "GITHUB_OUTPUT" \
-e "RUNNER_OS" \
-e "RUNNER_ARCH" \
-e "RUNNER_NAME" \
-e "RUNNER_ENVIRONMENT" \
-e "RUNNER_TOOL_CACHE" \
-e "RUNNER_TEMP" \
-e "RUNNER_WORKSPACE" \
-e "ACTIONS_RUNTIME_URL" \
-e "ACTIONS_RUNTIME_TOKEN" \
-e "ACTIONS_CACHE_URL" \
-e "ACTIONS_RESULTS_URL" \
-e GITHUB_ACTIONS=true \
-e CI=true \
-v "/var/run/docker.sock":"/var/run/docker.sock" \
-v "/home/runner/work/_temp/_github_home":"/github/home" \
-v "/home/runner/work/_temp/_github_workflow":"/github/workflow" \
-v "/home/runner/work/_temp/_runner_file_commands":"/github/file_commands" \
-v "/home/runner/work/security-hub/security-hub":"/github/workspace" \
oxsecurity/megalinter:v8.3.0  \
-v "/var/run/docker.sock:/var/run/docker.sock:rw"

```