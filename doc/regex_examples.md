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

* `categories:\s(.*)patterns*(.*)`
* `categories: $1Pattern$2`
- `./ghpages-holosecio/ghp-scripts/content/post`
- ``


## References:

1. Regex 101: https://regex101.com/

