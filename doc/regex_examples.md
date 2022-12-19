# Regex Examples

## Replace in Files using VSCode

### 1. Tags in Front matter


Ctrl + Shift + H

* Search: `tags:\s(.*)microservice*(.*)`
* Replace: `tags: $1Microservice$2`
- Files to include: `./ghpages-holosecio/ghp-scripts/content/post`
- Files to exclude: 

click over `Replace All` icon.

### 2. Categories in Front matter

* Search: `categories:\s(.*)patterns*(.*)`
* Replace: `categories: $1Pattern$2`
* Files to include: `./ghpages-holosecio/ghp-scripts/content/post`
* Files to exclude: ``

### 3. Patterns in Helm charts (yaml)

> Replace `$(variable01)` for `{{ .Values.configValues.variable01 }}`


* Search: `\$\((.*)\)`
* Replace: `{{ .Values.cfgValues.$1 }}`
* Files to include: `./repos-aa/gitops/nethermind-and-consensus/templates`
* Files to exclude: ``


## References:

1. Regex 101: https://regex101.com/

