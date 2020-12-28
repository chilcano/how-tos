## Github managing authentication

### Persisting GitHub credentials

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

### Enabling 2FA and Personal Access Token

1. Accessing GitHub using two-factor authentication:  
https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/accessing-github-using-two-factor-authentication
2. Creating a personal access token:  
https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/creating-a-personal-access-token

