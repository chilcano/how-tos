## Managing authentication in Github


### GitHub Authentication and Credential Manager

```sh
## Step 01: Set username and email
git config --global user.email "chilcano@intix.info"
git config --global user.name "Roger Carhuatocto"

## Step 02: Activate that credentials are saved in local store permanently
git config --global credential.helper store

## Step 03: Save different credentials for each different URL repos
git config --global credential.https://github.com.useHttpPath true
```

Using other commands:
```sh
## Save the credentials for a session  
git config --global credential.helper cache

## Also set a timeout for the above setting
git config --global credential.helper 'cache --timeout=600'

## Check previous values
git config --global user.email
git config --global user.name
```

__Enabling 2FA__

* Accessing GitHub using two-factor authentication: https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/accessing-github-using-two-factor-authentication

__Personal Access Token__

* Creating a personal access token: https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/creating-a-personal-access-token

* When prompted for the username and password, enter your GitHub username and the previously generated token as the password.

* If you want to add a new token in an already configured Git, then you should reset the previous token in the previous credentials manager, in this case is `git config --global credential.helper store`.

> _From [Git FAQ](https://git-scm.com/docs/gitfaq#http-reset-credentials)_  
> __How do I change the password or token I’ve saved in my credential manager?__  
>
>  Usually, if the password or token is invalid, Git will erase it and prompt for a new one. However, there are times when this doesn’t always happen. To change the password or token, you can erase the existing credentials and then Git will prompt for new ones. To erase credentials, use a syntax like the following (substituting your username and the hostname):
>
> ```$ echo url=https://author@git.example.org | git credential reject```

```sh
$ echo url=https://chilcano@github.com | git credential reject
```
Now, in the next commit, Git will prompt you for username and password, where you will use the personal access token as the password.


__Troubleshooting__   

1. Protocol `https` is not supported.   

   ```sh
   $ git clone https://github.com/chilcano/how-tos
   Cloning into 'how-tos'...
   fatal: protocol 'https' is not supported
   ```
   * Ref: https://stackoverflow.com/questions/53988638/git-fatal-protocol-https-is-not-supported


2. Bad credentials when running GitHub Hub.   

If you are having this error, that means that something happened with your credentials. 
```sh
Error creating repository: Unauthorized (HTTP 401)
Bad credentials
```
You have to check your `OAuth Token` in `$HOME/.config/hub`, if you have updated your `Personal Access Token` in GitHub and in your Git CLI, then you should update it in Hub CLI as well or if you don't want to update it, only remove it and in the next Hub command, Hub will prompt for introducing your credentials.

```sh
## view hub config
$cat $HOME/.config/hub

github.com:
- user: chilcano
  oauth_token: 2a71c...6e2...10a856c
  protocol: https

## update the token

## test the configuration
$ mkdir -p testsite1 && cd testsite1
$ hub create -d "test site 1" chilcano/testsite1
$ hub delete -y chilcano/testsite1
```

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

