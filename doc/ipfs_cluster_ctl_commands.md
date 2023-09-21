# IPFS Cluster CTL

> IPFS Cluster allows to allocate, replicate and track Pins across a cluster of IPFS daemons. ipfs-cluster-ctl is the command-line interface to manage a Cluster peer (run by ipfs-cluster-service).

## Steps

### 1. Install `ipfs-cluster-ctl` client

> You can download it from [https://dist.ipfs.tech/#ipfs-cluster-ctl](https://dist.ipfs.tech/#ipfs-cluster-ctl)

```sh
$ cd ~/Download

$ wget https://dist.ipfs.tech/ipfs-cluster-ctl/v1.0.6/ipfs-cluster-ctl_v1.0.6_linux-amd64.tar.gz

$ tar xvfz ipfs-cluster-ctl_v1.0.6_linux-amd64.tar.gz

$ cd ipfs-cluster-ctl

$ sudo cp ipfs-cluster-ctl /usr/local/bin
```

### 2. Test installed `ipfs-cluster-ctl` client

```sh
$ ipfs-cluster-ctl -v

ipfs-cluster-ctl version 1.0.6
```

### 3. Run some commands

First of all, i have to set the user and password:
```sh
$ export IPFS_CRED="my-usr:my-pwd"
$ export IPFS_HOST="/dns4/ipfs.eth.aragon.network/"
```

Common commands:
```sh
// List pinned objects
$ ipfs-cluster-ctl --basic-auth $IPFS_CRED --host $IPFS_HOST -s pin ls
$ ipfs-cluster-ctl --basic-auth $IPFS_CRED --host $IPFS_HOST -s pin ls <cid>

// List peers
$ ipfs-cluster-ctl --basic-auth $IPFS_CRED --host $IPFS_HOST -s peers ls

// Pin a cid
$ ipfs-cluster-ctl --basic-auth $IPFS_CRED --host $IPFS_HOST -s pin add <cid>

// Filter queued
$ ipfs-cluster-ctl --basic-auth $IPFS_CRED --host $IPFS_HOST -s status --filter queued

QmVxXNckKcAtPu6d5D5Q7sZirrZfnPp6y6oTJNNigqVtcR:
    > ipfs-1               : PIN_QUEUED | 2022-12-06T11:00:32.878062949Z | Attempts: 24930 | Priority: false

$ ipfs-cluster-ctl --basic-auth $IPFS_CRED --host $IPFS_HOST -s status QmTg2g41cvXgJrUK4ywimnbiai2TE8oM2c69NXitdPBbmp
QmTg2g41cvXgJrUK4ywimnbiai2TE8oM2c69NXitdPBbmp:
    > ipfs-1               : UNPINNED | 2023-09-20T11:52:28.820022955Z | Attempts: 0 | Priority: false
    > ipfs-2               : UNPINNED | 2023-09-20T11:52:28.820022955Z | Attempts: 0 | Priority: false
    > ipfs-0               : UNPINNED | 2023-09-20T11:52:28.820022955Z | Attempts: 0 | Priority: false
```

Flags:
* `--basic-auth`: specify BasicAuth credentials for server that requires authorization. implies --https, which you can disable with `--force-http [$CLUSTER_CREDENTIALS]`.
* `-s` or `--https`: although `--force-http` can disable `--https`, this is not recommended when using `--basic-auth`.




### 4. Advanced commands

#### 1. Remove a pinned resources

```sh
$ export IPFS_CRED='cluster:5xFZ.....7Up'
$ export IPFS_HOST="/dns4/ipfs.eth.aragon.network/"

$ ipfs-cluster-ctl --basic-auth $IPFS_CRED --host $IPFS_HOST -s pin rm <cid>
```

#### 2. Upload, pin and view content

```sh
// create a local file
$ echo "Hello $USER (`od -vN 6 -An -tx1 /dev/urandom | tr -d ' \n'`)!" > hello.txt
$ cat hello.txt

Hello chilcano (110ba121de47)!

// add file to ipfs
$ ipfs-cluster-ctl --basic-auth $IPFS_CRED --host $IPFS_HOST -s add hello.txt
added QmdMqfVw3Mvmvc3TDDaJo3uABvctdQQEuG4tndGkokidmL hello.txt

// check status
$ ipfs-cluster-ctl --basic-auth $IPFS_CRED --host $IPFS_HOST -s status QmdMqfVw3Mvmvc3TDDaJo3uABvctdQQEuG4tndGkokidmL

QmdMqfVw3Mvmvc3TDDaJo3uABvctdQQEuG4tndGkokidmL:
    > ipfs-1               : PINNED | 2023-09-20T16:12:58Z | Attempts: 0 | Priority: false
    > ipfs-2               : PINNED | 2023-09-20T16:12:58Z | Attempts: 0 | Priority: false
    > ipfs-0               : PINNED | 2023-09-20T16:12:58Z | Attempts: 0 | Priority: false

// list pinned cid
$ ipfs-cluster-ctl --basic-auth $IPFS_CRED --host $IPFS_HOST -s pin ls QmdMqfVw3Mvmvc3TDDaJo3uABvctdQQEuG4tndGkokidmL

QmdMqfVw3Mvmvc3TDDaJo3uABvctdQQEuG4tndGkokidmL |  | PIN | Repl. Factor: -1 | Allocations: [everywhere] | Recursive | Metadata: no | Exp: ∞ | Added: 2023-09-20 16:12:58

// querying added file

$ curl https://ipfs.eth.aragon.network/ipfs/QmdMqfVw3Mvmvc3TDDaJo3uABvctdQQEuG4tndGkokidmL

Hello chilcano (110ba121de47)!
```

#### 2. Upload, pin and view multiple files and directory 

```sh
$ tree dir01/
dir01/
├── hello.html
└── tux_94512.png

// upload and pin recursevely the dir01/
$ ipfs-cluster-ctl --basic-auth $IPFS_CRED --host $IPFS_HOST -s add -r './dir01'

added QmeMC6NyrTit8QZqyHwxgo6bmqqsqDLj695MNSzFKtqLPk dir01/hello.html
added QmXxPFzW22TC5CoffijTa7iHbZJJTEUoJ3pWdcAsx2hwhL dir01/tux_94512.png
added QmUNKYscAzes6MfPPjMESuHLQQB5gtzDSsm59MzN2vmTDH dir01

// check the status but using the cid of parent directory (dir01/), in this case is: added QmUNKYscAzes6MfPPjMESuHLQQB5gtzDSsm59MzN2vmTDH dir01
$ ipfs-cluster-ctl --basic-auth $IPFS_CRED --host $IPFS_HOST -s status QmUNKYscAzes6MfPPjMESuHLQQB5gtzDSsm59MzN2vmTDH

QmUNKYscAzes6MfPPjMESuHLQQB5gtzDSsm59MzN2vmTDH:
    > ipfs-1               : PINNED | 2023-09-20T16:30:23Z | Attempts: 0 | Priority: false
    > ipfs-2               : PINNED | 2023-09-20T16:30:23Z | Attempts: 0 | Priority: false
    > ipfs-0               : PINNED | 2023-09-20T16:30:23Z | Attempts: 0 | Priority: false

// open the browser using this URL: https://ipfs.eth.aragon.network/ipfs/QmUNKYscAzes6MfPPjMESuHLQQB5gtzDSsm59MzN2vmTDH/
// you should view an IPFS web representing the 'dir01/' folder with 2 files inside

// using this URL https://ipfs.eth.aragon.network/ipfs/QmUNKYscAzes6MfPPjMESuHLQQB5gtzDSsm59MzN2vmTDH/hello.html
// you should view the HTML being rendered
```

#### 3. Modify previous content and upload again



To re-sync changes to a folder that has changed, you must add it again. At this point, the hash of the folder will change and the hash of the modified files will have changed. If a file has not changed, its hash will not change.

Here is the procedure to follow:

1. We de-pin the current version
2. Make changes to you current local folder.
3. Delete the files that no longer exist or their old version
4. Upload again (Re-pin) the new version

```sh
// unpin previous folder
$ ipfs-cluster-ctl --basic-auth $IPFS_CRED --host $IPFS_HOST -s pin rm QmUNKYscAzes6MfPPjMESuHLQQB5gtzDSsm59MzN2vmTDH

QmUNKYscAzes6MfPPjMESuHLQQB5gtzDSsm59MzN2vmTDH:
    > ipfs-1               : UNPINNED | 2023-09-20T17:13:31.486478935Z | Attempts: 0 | Priority: false
    > ipfs-2               : UNPINNED | 2023-09-20T17:13:31.486478935Z | Attempts: 0 | Priority: false
    > ipfs-0               : UNPINNED | 2023-09-20T17:13:31.486478935Z | Attempts: 0 | Priority: false

// modify the dir01/ folder and its content

// upload the modified folder and its updated content again

$ ipfs-cluster-ctl --basic-auth $IPFS_CRED --host $IPFS_HOST -s add -r './dir01'

added QmSaRNb5ZKXd7oiPoHfZgZJHY3Q6kniqCVqQVGMZg42u6o dir01/hello.html
added QmPDNhvefPNd16NYG3emo4gAWfZctt1pnV6C9DucCfhQGc dir01/mythx-report.html
added QmXxPFzW22TC5CoffijTa7iHbZJJTEUoJ3pWdcAsx2hwhL dir01/tux_94512.png
added QmcjiiCnCMy7QgoXFYuuweGk9nHf9Ny6ctepM4QKvHsfgG dir01

// check status
$ ipfs-cluster-ctl --basic-auth $IPFS_CRED --host $IPFS_HOST -s status QmcjiiCnCMy7QgoXFYuuweGk9nHf9Ny6ctepM4QKvHsfgG

QmcjiiCnCMy7QgoXFYuuweGk9nHf9Ny6ctepM4QKvHsfgG:
    > ipfs-1               : PINNED | 2023-09-20T17:16:23Z | Attempts: 0 | Priority: false
    > ipfs-2               : PINNED | 2023-09-20T17:16:23Z | Attempts: 0 | Priority: false
    > ipfs-0               : PINNED | 2023-09-20T17:16:23Z | Attempts: 0 | Priority: false

// you will see that cid of parent directory has changed because the content inside has changed as well
// however, the content that has not changed is keeping the same cid for example 'dir01/tux_94512.png'
```

## References

1. For more commands see this [https://ipfscluster.io/documentation/reference/ctl/](https://ipfscluster.io/documentation/reference/ctl/).
2. Using IPFS for data replication [https://cestoliv.com/blog/using-ipfs-for-data-replication/](https://cestoliv.com/blog/using-ipfs-for-data-replication/).
