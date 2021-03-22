## Managing authentication in Github


### GitHub Authentication

```sh
$ git config --global user.email "chilcano@intix.info"
$ git config --global user.name "Chilcano"

// Save the credentials permanently
$ git config --global credential.helper store

// Save the credentials for a session  
$ git config --global credential.helper cache

// Also set a timeout for the above setting
$ git config --global credential.helper 'cache --timeout=600'
```

__Enabling 2FA and Personal Access Token__

1. Accessing GitHub using two-factor authentication:  
https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/accessing-github-using-two-factor-authentication
2. Creating a personal access token:  
https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/creating-a-personal-access-token

> Only introduce the Personal Access Token you generated instead to enter your GitHub password when prompting during commiting your changes.

__Troubleshooting__   

1. protocol 'https' is not supported   

   ```sh
   $ git clone https://github.com/chilcano/how-tos
   Cloning into 'how-tos'...
   fatal: protocol 'https' is not supported
   ```
   * Ref: https://stackoverflow.com/questions/53988638/git-fatal-protocol-https-is-not-supported

### Working with HUB

__GitHub OAuth authentication__  

  Hub will prompt for GitHub username & password the first time it needs to access the API and exchange it for an OAuth token, which it saves in `~/.config/hub`.
  To avoid being prompted, use `GITHUB_USER` and `GITHUB_PASSWORD` environment variables.
  Alternatively, you may provide `GITHUB_TOKEN`, an access token with repo permissions. This will not be written to `~/.config/hub`.

__HTTPS instead of git protocol__  

  If you prefer the HTTPS protocol for git operations, you can configure hub to generate all URLs with https: instead of `git:` or `ssh:`:
  ```
  $ git config --global hub.protocol https
  ```
  This will affect clone, fork, remote add and other hub commands that expand shorthand references to GitHub repo URLs.


# Indicate that you prefer HTTPS to SSH git clone URLs

__Avoid error  when creating repo with hub__  

  git@github.com: Permission denied (publickey).
  fatal: Could not read from remote repository.

``` 
$ git config --global hub.protocol https
```

__References:__  

1. GitHub Hub:  
https://hub.github.com
2. Error: Permission denied (publickey):  
https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/error-permission-denied-publickey

