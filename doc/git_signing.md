# Signing Git commits and tags with GPG or SSH keys

## References

1. https://git-scm.com/book/en/v2/Git-Tools-Signing-Your-Work
2. https://calebhearth.com/sign-git-with-ssh
3. https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent

## 1. Use SSH keys for signing

__1. Generate SSH keys__  

```sh
$ ssh-keygen -t ed25519 -C "chilcano@kipu" -f ~/.ssh/kipu_git_id_ed25519 
```
You can replace `-t ed25519` for `-t rsa -b 4096`.


__2. Upload the ssh public key to GitHub account as signing key__  

* This is need to verify signed commit in Github. 
```sh
$ cat ~/.ssh/kipu_git_id_ed25519.pub
```

__3. Config Git to use ssh as the format for signing__ 

```sh
$ git config --global gpg.format ssh
$ git config --global commit.gpgsign true
```

__4. Add ssh public key to git__

* This is the NEW way:  
  ```sh
  $ git config --global user.signingkey "~/.ssh/kipu_git_id_ed25519.pub"
  $ git config --global user.signingkey ~/.ssh/kipu_git_id_ed25519.pub
  ```
* This is the old way:  
  ```sh
  $ git config --global user.signingkey "$(cat ~/.ssh/<ssh-key-id>.pub)"
  $ git config --global user.signingkey "$(cat ~/.ssh/kipu_git_id_ed25519.pub)"
  ```

__5. Add trusted SSH public keys__   

* Needed if you want to verify ssh-signed commits locally (e.g., `git log --show-signature`) and want to define which SSH keys you trust.
* The key line format in `allowed_signers` should be: `<user@host> <ssh-key-type> <ssh-pub-key>`

```sh
$ touch ~/.ssh/allowed_signers
$ awk '{print $3, $1, $2}' ~/.ssh/kipu_git_id_ed25519.pub >> ~/.ssh/allowed_signers
$ git config --global gpg.ssh.allowedSignersFile ~/.ssh/allowed_signers
```

__6. Check the Git configuration__

```sh
$ git config --global -l

...
user.signingkey=ssh-rsa A...
commit.gpgsign=true
gpg.format=ssh
gpg.ssh.allowedsignersfile=/home/chilcano/.ssh/allowed_signers
```
Or:
```sh
$ cat ~/.gitconfig 
```

__7. Signing__  

You should use `-S` flag in commits.
```sh
$ git commit -S -m "Create a signed commit"
$ git commit --allow-empty -S -m "Testing signing Git commit with SSH keys"
```

To sign tags you have to use `-s` flag instead of `-a`:
```sh
$ git tag -s v1.5 -m 'Signed v1.5 tag'
```

## 2. Verifying signatures

You do need pre-configure GPG and SSH public keys as trusted keys, without that, Git CLI will show something like "Can't check signature" or "Signature not valid".  


__1. Verifying commits__  

You will see the signature verified or not
```sh
$ git log --show-signature -1
```

Just add "%G?" to show if that commit was signed or not
```sh
$ git log --pretty="format:%h %G? %aN  %s"

5c3486c G Roger Carhuatocto  Signed commit
ca82a6d N Roger Carhuatocto  Change the version number
085cb3b N Roger Carhuatocto  Remove unnecessary test code
a11aef0 N Roger Carhuatocto  Initial commit
```

__2. Verifying tags__   

To verify a signed tag, you use `git tag -v <tag-name>`. This command uses GPG to verify the signature.  
You need the signer's public key in your keyring for this to work properly.

```sh
$ git tag -v v1.4.2.1
```

## FAQ

### How to sign old commit ?

__Refs:__   
* https://superuser.com/questions/397149/can-you-gpg-sign-old-commits
* https://stackoverflow.com/questions/37737096/signing-an-existing-commit-with-gpg

In your local feature branch:
```sh
// get latest changes
$ git pull

// set the merge strategy
$ git config pull.rebase false  # merge (the default strategy)
$ git config pull.rebase true   # rebase
$ git config pull.ff only       # fast-forward only

$ git commit --amend -S -m "DOPS-351 added toJson to fix marshalling and signing commit"

$ git push
```

### How to sign or modify older previous commits ?

__Refs:__   
* https://webdevstudios.com/2020/05/26/retroactively-sign-git-commits/

Using `rebase`, you can pick up the commit you want to modify, even if you want execute a new `git commit` command.
In this case we are going to add signature to specific commit: `git commit --amend -S -m "DOPS-351 New signature in commit"`

```sh
// abort previous rebase
$ git rebase --abort

// we are going to modify 2 last commits
$ git rebase -i HEAD~2

// this amend the new commit that contains the last 2 previous commits (HEAD~2)
$ git commit --amend -S -m "DOPS-351 Fixed issue"

// continues rebase
$ git rebase --continue

// push changes
$ git push --force-with-lease
```
