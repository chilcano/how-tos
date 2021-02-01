# Git and frequent commands

## Working with branches

1. List local branches
```sh
git branch
```
2. List remote branches
```sh
git branch -r
```
3. List local and remote branches
```sh
git branch -a
```
4. Delete branch if you have fully merged
```sh
git branch -d <branch>
```
5. Delete branch if you have NOT fully merged or if you want ignore or discard modifications
```sh
git branch -D <branch>
```
6. Renaming the `master` branch to `main`   
You already can change it from `GitHub > Settings > Branches` automatically, however if you want to do manually, these are the steps:
```sh
# create main in the local repo 
$ git branch -m master main

# create branch in remote repo
# make sure your current local HEAD branch is still "main" when executing next cmd
$ git push -u origin main

# remove the old master branch on the remote
$ git push origin --delete master
```
You will have an error because you're going to delete a remote branch whis it's the GitHub default branch for your repository.
Change it from `GitHub > Settings > Branches` and after that, re-run the above command.

7. What your teammates have to do if you have renamed the branch?  

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

## Parallel branches with worktree

1. Create <path> and checkout <commit-ish> into it
```sh
git worktree add <path> [<commit-ish>]

// Creates new branch `hotfix` and checks it out at path `../hotfix`.
git worktree add ../hotfix 
```

2. Work on an existing branch in a new working tree.
```sh
git worktree add <path> <existing-branch>
```

3. Create a new branch named <new-branch> starting at <commit-ish>, and check out <new-branch> into the new working tree.
```sh
git worktree add -B <path> <new-branch>
```

4. Remove worktree and its associated administrative files
```sh
git worktree remove <branch>
git worktree prune          // run it in the main or any linked working tree to clean up
```

4. List worktrees
```sh
git worktree list
```


## Change existing directory to a new worktree branch

Step 1. Initialize new branch under root repo
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

Step 2. Move all content to new worktree branch

```sh
# cleaning admin files in root 
git worktree prune
rm -rf .git/worktrees/${BRANCH_DIR}/
# make a copy
mv ${BRANCH_DIR} ../.
# ${BRANCH_DIR} can be empty or it shouldn't exist
git worktree add -B ${BRANCH_NAME} ${BRANCH_DIR} origin/${BRANCH_NAME}
#git worktree add -B code-server-ec2 code-server-ec2 origin/code-server-ec2
cp -R ../${BRANCH_DIR}/* ${BRANCH_DIR}/.
cd ${BRANCH_DIR} && git add --all && git commit -m "All content moved" && cd ..
git push origin ${BRANCH_NAME}
#git push origin code-server-ec2
``` 
I've created a [script](resources/git_dir_to_worktree.sh) to automate this process and you can use the scrips without download it:
```sh
source <(curl -s https://raw.githubusercontent.com/chilcano/how-tos/master/resources/git_dir_to_worktree.sh) code-server-ec2
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