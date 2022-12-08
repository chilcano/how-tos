# IPFS Cluster CTL

> IPFS Cluster allows to allocate, replicate and track Pins across a cluster of IPFS daemons. ipfs-cluster-ctl is the command-line interface to manage a Cluster peer (run by ipfs-cluster-service).

## Steps

### 1. Install `ipfs-cluster-ctl` client

> You can download it from [https://dist.ipfs.tech/#ipfs-cluster-ctl](https://dist.ipfs.tech/#ipfs-cluster-ctl)

```sh
$ cd ~/Download

$ wget https://dist.ipfs.tech/ipfs-cluster-ctl/v1.0.4/ipfs-cluster-ctl_v1.0.4_linux-amd64.tar.gz

$ tar xvfz ipfs-cluster-ctl_v1.0.4_linux-amd64.tar.gz

$ cd ipfs-cluster-ctl

$ sudo cp ipfs-cluster-ctl /usr/local/bin
```

### 2. Test installed `ipfs-cluster-ctl` client

```sh
$ ipfs-cluster-ctl -v

ipfs-cluster-ctl version 1.0.4
```

### 3. Run some commands

First of all, i have to set the user and password:
```sh
$ export IPFS_USRPWD="my-usr:my-pwd"
$ export IPFS_HOST="/dns4/ipfs.eth.aragon.network/"
```

Common commands:
```sh
// List pinned objects
$ ipfs-cluster-ctl --basic-auth $IPFS_USRPWD --host $IPFS_HOST -s pin ls
$ ipfs-cluster-ctl --basic-auth $IPFS_USRPWD --host $IPFS_HOST -s pin ls <cid>

// List peers
$ ipfs-cluster-ctl --basic-auth $IPFS_USRPWD --host $IPFS_HOST -s peers ls

// Pin a cid
$ ipfs-cluster-ctl --basic-auth $IPFS_USRPWD --host $IPFS_HOST -s pin add <cid>

// Filter queued
$ ipfs-cluster-ctl --basic-auth $IPFS_USRPWD --host $IPFS_HOST -s status --filter queued

QmVxXNckKcAtPu6d5D5Q7sZirrZfnPp6y6oTJNNigqVtcR:
    > ipfs-1               : PIN_QUEUED | 2022-12-06T11:00:32.878062949Z | Attempts: 24930 | Priority: false

$ ipfs-cluster-ctl --basic-auth $IPFS_USRPWD --host $IPFS_HOST -s status QmTg2g41cvXgJrUK4ywimnbiai2TE8oM2c69NXitdPBbmp
QmTg2g41cvXgJrUK4ywimnbiai2TE8oM2c69NXitdPBbmp:
    > ipfs-3               : UNPINNED | 2022-12-06T11:11:36.236558461Z | Attempts: 0 | Priority: false
    > ipfs-1               : UNPINNED | 2022-12-06T11:11:36.236558461Z | Attempts: 0 | Priority: false
    > ipfs-2               : UNPINNED | 2022-12-06T11:11:36.236558461Z | Attempts: 0 | Priority: false
    > ipfs-0               : UNPINNED | 2022-12-06T11:11:36.236558461Z | Attempts: 0 | Priority: false

```

Flags:
* `--basic-auth`: specify BasicAuth credentials for server that requires authorization. implies --https, which you can disable with `--force-http [$CLUSTER_CREDENTIALS]`.
* `-s` or `--https`: although `--force-http` can disable `--https`, this is not recommended when using `--basic-auth`.

> For more commands see this [https://ipfscluster.io/documentation/reference/ctl/](https://ipfscluster.io/documentation/reference/ctl/).
