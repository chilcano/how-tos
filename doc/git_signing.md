# Signing Git commits and tags with GPG or SSH keys

## References

1. https://git-scm.com/book/en/v2/Git-Tools-Signing-Your-Work
2. https://calebhearth.com/sign-git-with-ssh
3. https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent

## 1. Use SSH keys for signing

__1. Generate SSH keys__  

```sh
$ ssh-keygen -t ed25519 -C "youremail@example.com" -f ~/.ssh/aa_id_rsa_4096_enc
$ ssh-keygen -t rsa -b 4096 -C "your_email@example.com" -f ~/.ssh/aa_id_rsa_4096_enc
```

__2. Upload the ssh public key to GitHub account__  

Just follow these steps:  
* https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account

__3. Config Git to use SSH as the format for signing__ 

```sh
$ git config --global commit.gpgsign true
$ git config --global gpg.format ssh
```

__4. Config Git what SSH public key to use for signing__  

```sh
// Get the ssh pub key
$ cat ~/.ssh/<ssh-key-id>.pub
// Set the ssh pub key
$ git config --global user.signingkey "ssh-rsa <your-pub-rsa-key>"
$ git config --global user.signingkey "ssh-ed25519 <your-pub-ed-key>"

// In our case, follow this
$ SSH_PUB_KEY=$(cat ~/.ssh/<ssh-key-id>.pub)
$ git config --global user.signingkey "${SSH_PUB_KEY}"
```

__5. Add trusted SSH public keys__   
```sh
$ git config --global gpg.ssh.allowedSignersFile ~/.ssh/allowed_signers
$ touch ~/.ssh/allowed_signers
$ echo "email1@example.com ssh-rsa <user1-pub-rsa-key>" >> ~/.ssh/allowed_signers
$ echo "email2@example.com ssh-ed25519 <user2-pub-ed-key>" >> ~/.ssh/allowed_signers
```

Add your own ssh pub key:
```sh
$ SSH_PUB_KEY=$(cat ~/.ssh/<ssh-key-id>.pub)
$ ARRAY_SSH_PUB_KEY=(${SSH_PUB_KEY// / })
$ echo "your-email@example.com ${ARRAY_SSH_PUB_KEY[0]} ${ARRAY_SSH_PUB_KEY[1]}" >> ~/.ssh/allowed_signers
```

__6. Add trusted GPG public keys__   
You should use the GPG/PGP framework to specify keys to trust and be able to verify others keys.


__7. Check the Git configuration__

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

__8. Signing__  

You should use `-S` flag in commits.
```sh
$ git commit -S -m "Create a signed commit"
$ git commit --allow-empty -S -m "Testing signing Git commit with SSH keys"
```

To sign tags you have to use `-s` flag instead of `-a`:
```sh
$ git tag -s v1.5 -m 'Signed v1.5 tag'
```

## 2. Use GPG keys for signing

Same steps or follow these steps:  
* https://docs.github.com/en/authentication/managing-commit-signature-verification/about-commit-signature-verification


## 3. Verifying signatures

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
