# Working with GIT 

## Pull Request

1. Fork from Github.com an existing repo
2. Clone your forked repo
3. Sync changes with upstream (remote repo)
   - git remote add <nombre> <URL> 
   - git remote add upstream https://github.com/gportalanza/poc-aws-env
   - git remote -v
4. Create a branch (where we are going to add our changes)
   - git branch v0.1
   - git checkout v0.1
5. Add your changed in the new created branch
   - git add .
6. Commit your changes
   - git commit -m "changes added to my branch"
7. Upload your changes
   - git push origin <tu-branch>
   - git push origin v0.1
8. Request to include your changes through `pull request`
   - Continue the "Pull Request" through your Github web and your forked repo
   - Once the PR has been sent, the Upstream Repo will receive a notification asking to accept-merge or reject the PR
9.  Once accepted the PR, update your forked repo.
    - git checkout master
    - git pull upstream master
    - git push origin master
10. Once update the forked repo with new changes from upstream, next we would remove previous branch v0.1
    - git rebase master v0.1
    - git branch -d v0.1
    - git checkout master
    - git branch -d v0.1
11. END