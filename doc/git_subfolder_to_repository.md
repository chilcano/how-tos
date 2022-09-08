# Create new Git repo from sub-folder of existing repo preserving history

## Scenario

The current source repo is `repo_source` and contains:

```sh
repo_source
├── .gitignore
├── file_1
├── file_2
├── subfolder_1
│   ├── file_3
│   ├── file_4
│   └── subfolder_1a
│       ├── file_p
│       ├── file_q
│       └── file_r
└── subfolder_2
    ├── file_5
    └── file_6
```

We do want to move all `subfolder_1`'s content in a new repository called `repo_target` preserving and updating the Git history according changes done in paths.  
The new target repository `repo_target` will contain the next files and directories:

```sh
repo_target
├── file_3
├── file_4
└── subfolder_1a
    ├── file_p
    ├── file_q
    └── file_r
```

## Steps

### Step 1: Fresh clone

```sh
# Bitbucket
git clone ${BITBUCKET_SERVER_URL}/scm/${projectKeySource}/${repoNameSource}.git ${repoNameSource}
# GitHub
git clone https://github.com/${orgSource}/${repoNameSource}.git ${repoNameSource}

git checkout ${branchSource}
```

### Step 2: Make a copy

```sh
cp -a ${repoNameSource}/. ${repoNameSource}-${repoNameTarget}
```

### Step 3: Create a new target repo



In Bitbucket, only we need to make a call to API REST using an user with proper permissions.
```sh
cat << EOF > repo_create.json 
{
    "name": "${repoNameTarget}",
    "scmId": "git",
    "forkable": true,
    "defaultBranch": "${branchTarget}"
}
EOF
curl -s -u ${usrPwd} -H "Content-Type: application/json" -d @repo_create.json -X POST ${BITBUCKET_SERVER_URL}/rest/api/1.0/projects/${projectKeyTarget}/repos/
```

However, if you are using GitHub, you could use [GitHub's Hub wrapper](https://hub.github.com/) (Install and configure it using this [script](/src/git_and_hub_setting_in_linux.sh)) to create a GitHub repo from your Terminal or through GitHub's Web GUI.  
In this case, the target repo is `repo_target`.


#### 3.1. Clone recently created empty target repo (master is default branch)

```sh
# Bitbucket
git clone ${BITBUCKET_SERVER_URL}/scm/${projectKeyTarget}/${repoNameTarget}.git ${repoNameTarget}
# GitHub
git clone https://github.com/${orgTarget}/${repoNameTarget}.git ${repoNameTarget}
```

### Step 4: Run git filter-branch in copied fresh source repo (it will take ~10mins/repo)

* `${subFolderName}` is the subfolder that is going to be preserved and going to be used as new repository.
* `${subFolderName}` and `${repoNameTarget}` can be used interchangeably if you are going to use the subfolder name as the target repo name.

```sh
cd ${repoNameSource}-${repoNameTarget}
```

In this example:
* `subFolderName` = `subfolder_1`
* `repoNameTarget` = `repo_target`


#### 4.1. Get the git log and use it to confirm that git history has been modified accordingly

```sh
git log --name-only --pretty=format:"%H | %ai | %ae" -- ${subFolderName} > ../${repoNameTarget}.ini.log
```

* Run the filter `--subdirectory-filter ${subFolderName}`.
* This will remove all content except `${subFolderName}` and will move it to parent folder, also all git commit hashes will be regenerated and file paths updated accordingly.

```sh
git filter-branch --prune-empty --subdirectory-filter ${subFolderName} ${branchSource} > ../${repoNameTarget}.filter-branch.log
```

### Step 5: Pull content and history from local copied source repo to local target repo

```sh
cd ${repoNameTarget}/
git pull ../${repoNameSource}-${repoNameTarget} ${branchSource} 
```

#### 5.1. Set/add remote git url to local target repo (not needed if you are cloning from expected target repo)

```sh
git remote set-url origin ${BITBUCKET_SERVER_URL}/scm/${projectKeyTarget}/${repoNameTarget}.git
```

### Step 6: Push changes to remote target repo

```sh
git push -u origin HEAD:${branchTarget}
```

#### 6.1. Remove temp files

```sh
rm -rf ${repoNameSource}-*
```

#### 6.2. Check content and git history

```sh
git log --name-only --pretty=format:"%H | %ai | %ae" > ../${repoNameTarget}.filtered.log
```

* Both files `${repoNameTarget}.filter-branch.log` and `${repoNameTarget}.filtered.log` should have the same git commit hash total, files committed, dates and authors, etc. 
* The differences are file paths and git commit hashes

## References

* [Move directory between repos while preserving git history](https://johno.com/move-directory-between-repos-with-git-history)
* [Splitting sub-folder(s) out into a new Git repository](https://making.close.com/posts/splitting-sub-folders-out-into-new-git-repository#third-approach-final)
* [Move files from one repository to another, preserving git history](https://medium.com/@ayushya/move-directory-from-one-repository-to-another-preserving-git-history-d210fa049d4b)
* [How to move a folder from one repo to another and keep its commit history ](https://gist.github.com/trongthanh/2779392)
* [Rewriting git history simply with git-filter-repo](https://andrewlock.net/rewriting-git-history-simply-with-git-filter-repo/)

