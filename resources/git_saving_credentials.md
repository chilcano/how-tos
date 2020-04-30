## Github saving credentials

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