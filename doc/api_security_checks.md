# API security checks

## Tools

1. [MegaLinter - Spectral Linter](https://megalinter.io/latest/descriptors/openapi_spectral)
  * It can be used from CLI, Docker and even as GitHub Actions
2. [Spectral Linter](https://github.com/stoplightio/spectral)
  * It can be used from CLI, Docker and even as GitHub Actions

> We are going to use Spectral CLI as NodeJS application because MegaLinter is too heavy (~3 mins) and when using Spectral GitHub Actions I had issues.

## Steps

### Spectral CLI

1. __Install NodeJS__

```sh
$ curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
$ sudo apt-get install -y nodejs
$ node -v
v16.18.1

$ npm -v
8.19.2

$ sudo npm install npm@latest -g
```

2. __Install Spectral and Rulesets__

```sh
$ npm install @stoplight/spectral-cli
$ npm install @stoplight/spectral-owasp-ruleset
```
I'm going to create multiple config files to test different rulesets.
```sh
# ruleset was already installed when the linter was installed
$ echo 'extends: ["spectral:oas"]' > .spectral_oas.yaml

# ruleset had to be installed before with npm install
$ echo 'extends: ["@stoplight/spectral-owasp-ruleset"]' > .spectral_owasp.yaml

# ruleset is downloaded in runtime
$ echo 'extends: ["https://unpkg.com/@apisyouwonthate/style-guide@1.3.2/dist/ruleset.js"]' > .spectral_style_guide.yaml
```

3. __Run Spectral__

This allows preserving the exit when piping.
```sh
$ set -o pipefail
```

Printing stdout and stderr while piping to log file preserving the exit code at the same time.
```sh
$ mkdir -p _out/
$ npx spectral lint src/api_specs/openapi01.yaml -r .spectral_oas.yaml -v | tee _out/spectral_oas.log

Found 51 rules (40 enabled)
Linting /home/chilcano/repos/how-tos/src/api_specs/openapi01.yaml

/home/chilcano/repos/how-tos/src/api_specs/openapi01.yaml
   2:6    warning  info-contact               Info object must have "contact" object.                                                 info
   44:9   warning  operation-description      Operation "description" must be present and non-empty string.                           paths./chain/transaction/cost.get
   50:9     error  parser                     Mapping key must be a string scalar rather than number                                  paths./chain/transaction/cost.get.responses[200]
  74:10   warning  operation-description      Operation "description" must be present and non-empty string.                           paths./chain/transaction/submit.post
   90:9   warning  operation-description      Operation "description" must be present and non-empty string.                           paths./chain/transaction/reference/{hash}.get
  114:9   warning  operation-description      Operation "description" must be present and non-empty string.                           paths./chain/transaction/{blockHeight}/{txIndex}.get
  167:9   warning  operation-description      Operation "description" must be present and non-empty string.                           paths./chain/organization/count.get
  207:9   warning  operation-description      Operation "description" must be present and non-empty string.                           paths./chain/block/height/{height}.get
  230:9   warning  operation-description      Operation "description" must be present and non-empty string.                           paths./chain/block/hash/{hash}.get
  300:9   warning  operation-description      Operation "description" must be present and non-empty string.                           paths./chain/stats.get
  316:9   warning  operation-description      Operation "description" must be present and non-empty string.                           paths./chain/info.get
  376:9   warning  operation-description      Operation "description" must be present and non-empty string.                           paths./election/list/{organizationID}/{page}.get
  400:9   warning  operation-description      Operation "description" must be present and non-empty string.                           paths./election/count/{organizationID}.get
  424:9   warning  operation-description      Operation "description" must be present and non-empty string.                           paths./election/{electionId}.get
  487:9   warning  operation-description      Operation "description" must be present and non-empty string.                           paths./election/{electionId}/keys.get
  524:9   warning  operation-description      Operation "description" must be present and non-empty string.                           paths./election/{electionId}/votes/count.get
  542:10  warning  operation-description      Operation "description" must be present and non-empty string.                           paths./election.post
  572:9   warning  operation-description      Operation "description" must be present and non-empty string.                           paths./account/{address}.get
  700:22    error  oas3-valid-schema-example  "example" property type must be number                                                  paths./wallet/transfer/{destAddr}/{amount}.post.parameters[1].schema.example
  1013:9  warning  operation-description      Operation "description" must be present and non-empty string.                           paths./census/{censusId}/verify.get
 1094:10  warning  operation-description      Operation "description" must be present and non-empty string.                           paths./vote.post
 1111:10  warning  operation-description      Operation "description" must be present and non-empty string.                           paths./vote/verify/{electionId}/{voteId}.post
 1181:16    error  oas3-valid-schema-example  "example" property type must be object                                                  components.schemas.AccountSubmit.example
 1216:16    error  oas3-valid-schema-example  "example" property must be equal to one of the allowed values: "weighted", "zkindexed"  components.schemas.ElectionStatus.example
 1225:16    error  oas3-valid-schema-example  "example" property type must be object                                                  components.schemas.TransactionSubmit.example
 1298:23  warning  oas3-unused-component      Potentially unused component has been detected.                                         components.responses.UnauthorizedError

✖ 26 problems (5 errors, 21 warnings, 0 infos, 0 hints)
```
This deactivate the `pipefail`.
```sh
$ set +o pipefail
```

This and next commands don't print stdout and stderr while piping to log file but It preservs the exit code.
```sh
$ npx spectral lint src/api_specs/openapi01.yaml -r .spectral_owasp.yaml -v > _out/spectral_owasp.log
$ npx spectral lint src/api_specs/openapi01.yaml -r .spectral_style_guide.yaml -v > _out/spectral_style_guide.log
```

### Spectral CLI in GitHub Actions

1. __Create a GitHub workflow file in your repo__

```yaml
name: spectral-ci

on:
  workflow_dispatch:
    inputs:
      dummyLogLevel:
        description: 'Dummy Log Level'
        required: false
        default: 'warning'
        type: choice
        options: [info, warning, debug] 
  push:
    branches: [main,api]
    paths:
      - 'src/api_specs/**.yaml'
      - '.github/workflows/spectral-ci.yaml'
  pull_request:
    types:
      - opened
    branches: [main,api]
    paths:
      - 'src/api_specs/**.yaml'
      - '.github/workflows/spectral-ci.yaml'

concurrency:
  group: ${{ github.ref }}-${{ github.workflow }}
  cancel-in-progress: true

jobs:
  spectral_cli:
    name: Spectral CLI
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Code
        uses: actions/checkout@v3

      - name: Set up Node.js
        uses: actions/setup-node@v3
        with:
          node-version: 16.x

      - name: Install Spectral and initial rulesets
        run: |
          npm install @stoplight/spectral-cli
          npm install @stoplight/spectral-owasp-ruleset

      - name: Setup Spectral rulesets
        run: |
          echo 'extends: ["spectral:oas"]' > .spectral_oas.yaml   # ruleset was already installed when the linter was installed
          echo 'extends: ["@stoplight/spectral-owasp-ruleset"]' > .spectral_owasp.yaml    # ruleset had to be installed before with npm install
          echo 'extends: ["https://unpkg.com/@apisyouwonthate/style-guide@1.3.2/dist/ruleset.js"]' > .spectral_style_guide.yaml   # ruleset is downloaded in runtime
          mkdir -p _out/

      - name: Run Spectral - ruleset OAS
        run: set -o pipefail; npx spectral lint src/api_specs/openapi01.yaml -r .spectral_oas.yaml -v | tee _out/spectral_oas.log

      - name: Run Spectral - ruleset OWASP
        if: ${{ success() }} || ${{ failure() }}
        run: set -o pipefail; npx spectral lint src/api_specs/openapi01.yaml -r .spectral_owasp.yaml -v | tee _out/spectral_owasp.log

      - name: Run Spectral - ruleset Style-Guide downloaded in runtime
        if: ${{ success() }} || ${{ failure() }}
        run: |
          set -o pipefail
          npx spectral lint src/api_specs/openapi01.yaml -r .spectral_style_guide.yaml -v | tee _out/spectral_style_guide.log
          set +o pipefail

      - name: Archive Spectral reports
        if: ${{ success() }} || ${{ failure() }}
        uses: actions/upload-artifact@v3
        with:
          name: Spectral reports
          path: _out/*.log
```

2. __Run the GitHub workflow__


## Resources
* https://www.jit.io/blog/how-to-automate-owasp-zap
* https://github.com/zaproxy/action-api-scan
* https://github.com/marketplace/actions/owasp-zap-full-scan
* https://dotnetthoughts.net/automate-security-testing-with-zap-and-github-actions/
* https://stackoverflow.com/questions/66171424/how-to-generate-openapi-v3-specification-from-go-source-code
* https://github.com/stoplightio/spectral
  - https://github.com/apisyouwonthate/style-guide
  - https://github.com/stoplightio/spectral-owasp-ruleset
  - https://github.com/stoplightio/spectral-rulesets
  - https://www.youtube.com/watch?v=YNhllmIjjN0
  - https://blog.stoplight.io/spectral-owasp-api-security-ruleset
  - https://blog.stoplight.io/style-guides-rulebook-series-automated-api-design-checks-in-ci
  - https://github.com/stoplightio/spectral-action
* https://github.com/oxsecurity/megalinter
  - https://megalinter.io/latest/reporters/GitHubCommentReporter/
  - https://megalinter.io/latest/configuration/