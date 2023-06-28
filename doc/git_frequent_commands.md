# Git and frequent commands

## Working with branches

### 1. List branches

```sh
## local branches
$ git branch
```

```sh
## remote branches
$ git branch -r
```

```sh
## local and remote branches
$ git branch -a
```

### 2. Create branches

```sh
## create a branch on local and switch in this branch
$ git checkout -b <branch>

## create a branch on local but *not* switch in this branch
$ git branch <branch>

# switch branch, it makes sure your current local HEAD branch is still <branch> when executing next cmd (push)
$ git checkout <branch>

# make sure (git checkout <branch>) you have switched to branch, then push changes into remote branch (note -u = set-upstream)
$ git push -u origin <branch>

# now you will see local <branch> being upstramed to remote <branch>
$ git branch -a
* my-new-branch
  remotes/origin/my-new-branch
```

### 3. Switch to branches

```sh
## switch in this branch
$ git checkout <branch>
```

### 4. Update your working branch

```sh
$ git add .
$ git commit -m "Update branch"
$ git push origin <branch>
```

### 5. Delete branch 

```sh
## Local branch and if you have fully merged.
git branch -d <branch>
```

```sh
## Local branch and if you have NOT fully merged or if you want ignore or discard modifications.
git branch -D <branch>
```

```sh
## Delete remote branch.
git push origin --delete <branch>
```
Example:
```sh
$ git branch -r
  origin/code01
  origin/main
  origin/simple02

$ git push -u origin simple02
```

### 6. Renaming branches

#### From `master` branch to `main`

You already can change it from `GitHub > Settings > Branches` automatically, however if you want to do manually, these are the steps:
```sh
# create main in the local repo 
$ git branch -m master main

# create branch in remote repo, make sure your current local HEAD branch is still "main" when executing next cmd
$ git push -u origin main

# remove the old master branch on the remote
$ git push origin --delete master
```
You will have an error because you're going to delete a remote branch whis it's the GitHub default branch for your repository.
Change it from `GitHub > Settings > Branches` and after that, re-run the above command.

#### What your teammates have to do if you have renamed the branch?  

```sh
# Switch to the "master" branch:
$ git checkout master

# Rename it to "main":
$ git branch -m master main

# Get the latest commits (and branches!) from the remote:
$ git fetch

# Remove the existing tracking connection with "origin/master":
$ git branch --unset-upstream

# Create a new tracking connection with the new "origin/main" branch:
$ git branch -u origin/main
```

### 7. Merging branches

There are 3 options when merging:
* `--no-ff`: Creates a merge commit even when a fast-forward would be possible.
* `--squash`: Combines all integrated changes into a single commit, instead of preserving them as individual commits.
* `--abort`: When a conflict occurs, this option can be used to abort the merge and restore the project's state as it was before starting the merge.

By default is fast-forward and recursive.

```sh
# switch to target branch
$ git checkout <target-branch>

# merge <source-branch> into <target-branch>
$ git merge <source-branch>

# now, push the changes (you have to be in <target-branch>)
$ git push
``` 

### 8. Showing git logs

```sh
$ git log --oneline -n 18

0d956e5 (HEAD -> develop, origin/develop, origin/HEAD) fix(ci): adds condition to release job (#238)
fc93c12 (tag: 1.9.2-javascript-client, tag: 1.0.2-javascript-client-common) fix/OS-538-module-path (#236)
8803530 (tag: 1.9.1-javascript-client, tag: 1.5.0-javascript-common, tag: 1.0.1-javascript-client-common) Forces bump 1.9.1 (#235)
2594adb Version bump 1.9.1 (#234)
b06b77e GH workflow updated and forces version bump 1.9.1 (#233)
2f8a1d4 Forces version bump 1.9.1 (#232)
f88f7d8 Version bump (#231)
f5108a2 Feature: updates all github actions, python scripts and legacy syntax (#230)
05e4fc2 Feature: Add generic errors (#227)
...

```

### 9. Working with git tags

```sh
$ git tag -a <tag_name> -m "message"


// Create Git Tag for Commit
$ git tag <tag_name> <commit_sha>
$ git tag -a <tag_name> <commit_sha> -m "message"

$ git push --tags

$ git log --oneline -n 3

9127753 (HEAD -> master) Commit 3
f2fcb99 (feature) Commit 2
cab6e1b (tag: v1.0, origin/master) master : initial commit

$ git tag -n

v1.0
v2.0
v3.0
```


## Using Worktrees

### 1. Create worktree (or switch to existing worktree)

Create a worktree branch and switch to it
```sh
git worktree add -B <path> <branch> origin/<branch>
```

### 2. Switch to an existing worktree

Clone the repo.
```sh
git clone https://github.com/chilcano/aws-cdk-examples
```

List all branches.
```sh
git branch -a
* main
  remotes/origin/HEAD -> origin/main
  remotes/origin/code-server-ec2
  remotes/origin/main
  remotes/origin/simple-frontend-backend-ecs
  remotes/origin/simple-php-ts-ecs

```

List worktree.
```sh
git worktree list
/home/roger/gitrepos/aws-cdk-examples  d593c74 [main]
```

Switch to worktree branch.
```sh
## simple-php-ts-ecs
git worktree add -B simple-php-ts-ecs simple-php-ts-ecs origin/simple-php-ts-ecs

## simple-frontend-backend-ecs
git worktree add -B simple-frontend-backend-ecs simple-frontend-backend-ecs origin/simple-frontend-backend-ecs

## code-server-ec2
git worktree add -B code-server-ec2 code-server-ec2 origin/code-server-ec2
```

List worktree again.
```sh
git worktree list
/home/roger/gitrepos/aws-cdk-examples                    d593c74 [main]
/home/roger/gitrepos/aws-cdk-examples/simple-php-ts-ecs  6c18906 [simple-php-ts-ecs]
```

### 3. Remove worktree
```sh
## Remove worktree and its associated administrative files
git worktree remove <branch>
git worktree prune          // run it in the main or any linked working tree to clean up

# additionally remove local and remote branch
git branch -D <branch>
git push origin --delete <branch>
```

### 4. List worktrees
```sh
## List worktrees
git worktree list
```

### 5. Converting directory to a new worktree branch

#### Step 1. Initialize new branch under root repo

```sh
## we have to be in the project root
CURRENT_DIR=${PWD}
BRANCH_NAME="${1:-code-server-ec2}"
BRANCH_DIR="${BRANCH_NAME}"

echo "${BRANCH_DIR}" >> .gitignore
git checkout --orphan ${BRANCH_NAME}
git reset --hard
git commit --allow-empty -m "Initializing '${BRANCH_NAME}' branch"
git push upstream ${BRANCH_NAME}
git checkout main
``` 

#### Step 2. Move all content to new worktree branch

```sh
# cleaning admin files in root 
git worktree prune
rm -rf .git/worktrees/${BRANCH_DIR}/
# make a copy
mv ${BRANCH_DIR} ../.
# ${BRANCH_DIR} can be empty or it shouldn't exist
git worktree add -B ${BRANCH_NAME} ${BRANCH_DIR} origin/${BRANCH_NAME}
#git worktree add -B path branch origin/branch
cp -R ../${BRANCH_DIR}/* ${BRANCH_DIR}/.
cd ${BRANCH_DIR} && git add --all && git commit -m "All content moved" && cd ..
git push origin ${BRANCH_NAME}
#git push origin code-server-ec2
``` 
I've created a [script](src/git_dir_to_worktree.sh) to automate this process and you can use the scrips without download it:
```sh
source <(curl -s https://raw.githubusercontent.com/chilcano/how-tos/main/src/git_dir_to_worktree.sh) code-server-ec2
```

### 3. Creating an empty worktree branch

```sh
CURRENT_DIR=${PWD}
BRANCH_NAME="${1:-code-server-ec2}"
BRANCH_DIR="${BRANCH_NAME}"

echo "${BRANCH_DIR}" >> .gitignore

git checkout --orphan ${BRANCH_NAME}
git reset --hard
git commit --allow-empty -m "Initializing branch"
git push upstream ${BRANCH_NAME}
git checkout main
``` 





## Github Pull Request Guide

1. Fork from Github.com an existing repo
2. Clone your forked repo
3. Sync changes with upstream (remote repo)
```sh
git remote add <nombre> <URL> 
git remote add upstream https://github.com/gportalanza/poc-aws-env
git remote -v
```
4. Create a branch (where we are going to add our changes)
```sh
git branch v0.1
git checkout v0.1
```
5. Add your changed in the new created branch
```
git add .
```
6. Commit your changes
```sh
git commit -m "changes added to my branch"
```
7. Upload your changes
```sh
git push origin <tu-branch>
git push origin v0.1
```
8. Request to include your changes through `pull request`
- Continue the "Pull Request" through your Github web and your forked repo
- Once the PR has been sent, the Upstream Repo will receive a notification asking to accept-merge or reject the PR
9.  Once accepted the PR, update your forked repo.
```sh
git checkout master
git pull upstream master
git push origin master
```
10. Once update the forked repo with new changes from upstream, next we would remove previous branch v0.1
```sh
git rebase master v0.1
git branch -d v0.1
git checkout master
git branch -d v0.1
```
11. END

## Troubleshooting

### 1. warning: ignoring broken ref refs/remotes/origin/HEAD`

* The master (root) branch was removed or renamed.
* Ref: https://stackoverflow.com/questions/45811971/warning-ignoring-broken-ref-refs-remotes-origin-head

```sh
$ git symbolic-ref refs/remotes/origin/HEAD
refs/remotes/origin/old_dev

// Where "new_dev" is a branch name. Replace it with the name of the branch you want HEAD to point to.
$ git symbolic-ref refs/remotes/origin/HEAD refs/remotes/origin/new_dev
```