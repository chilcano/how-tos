# Docker useful commands

## For Mac OS X El Capitan ( v 10.11.1 )

### Docker Machine

__1) Create Docker Machine__
```
$ docker-machine create --driver virtualbox machine-dev
```

__2) List current docker machines__
```
$ docker-machine ls
NAME           ACTIVE   DRIVER       STATE     URL                         SWARM   ERRORS
machine-dev    *        virtualbox   Running   tcp://192.168.99.100:2376
machine-test   -        virtualbox   Running   tcp://192.168.99.101:2376
```

__3) Print current environment variables for docker machine__
```
$ docker-machine env machine-dev
export DOCKER_TLS_VERIFY="1"
export DOCKER_HOST="tcp://192.168.99.100:2376"
export DOCKER_CERT_PATH="/Users/Chilcano/.docker/machine/machines/machine-dev"
export DOCKER_MACHINE_NAME="machine-dev"
# Run this command to configure your shell:
# eval "$(docker-machine env machine-dev)"
```

__4) Select a docker machine__
```
$ eval "$(docker-machine env machine-dev)"
```

__5) Remove completly docker machine__
```
$ docker-machine rm machine-test
```

__6) Get SSH access to docker machine and print tmpfs partition__

```
$ docker-machine ssh machine-dev 

docker@machine-dev:~$ df -h /
Filesystem                Size      Used Available Use% Mounted on
tmpfs                   896.6M    735.4M    161.2M  82% /
```

### Docker

__1) Create Docker Image from an existing Dockerfile__

```
$ docker build --rm -t chilcano/wso2-esb 1github-repo/docker-wso2-esb-jgpelaez/4.8.1/
```

Where:
* `--rm`: remove intermediate containers after a successful build (true by default)
* `-t chilcano/wso2-esb`: tag for the repository of the new local docker image
* `1github-repo/docker-wso2-esb-jgpelaez/4.8.1/`: path to the Dockerfile

__2) Check new created image__

```
$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
chilcano/wso2-esb   latest              47f39b8e2d61        16 minutes ago      867.6 MB
java                openjdk-7           a93511e8921b        8 days ago          589.7 MB
```

Where:
* `chilcano/wso2-esb`: new create image
* `java`: imagen used to create `chilcano/wso2-esb`


__3) Run a container__

```
$ docker run --rm --name wso2-esb -p 19443:9443 chilcano/wso2-esb
```

Where:
* `--rm`: automatically remove the container when it exits
* `--name wso2-esb`: container name
* `chilcano/wso2-esb`: docker image name
* `-p 19443:9443`: exposes container's port 9443 to host's port 19943 

__4) Run a specific tagged container__ 

* Check current images
```
$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
chilcano/wso2-esb   latest              47f39b8e2d61        2 days ago          867.6 MB
chilcano/wso2-esb   4.8.1               47f39b8e2d61        2 days ago          867.6 MB
java                openjdk-7           a93511e8921b        11 days ago         589.7 MB
```

* Run a tagged container
```
$ docker run --rm --name wso2-esb-481 -p 19443:9443 chilcano/wso2-esb:4.8.1
JAVA_HOME environment variable is set to /usr
CARBON_HOME environment variable is set to /opt/wso2esb-4.8.1
...
[2015-12-07 11:57:00,153]  INFO - StartupFinalizerServiceComponent WSO2 Carbon started in 27 sec
[2015-12-07 11:57:00,980]  INFO - CarbonUIServiceComponent Mgt Console URL  : https://172.17.0.2:9443/carbon/
```

Where:
- `chilcano/wso2-esb:4.8.1`: is the `chilcano/wso2-esb` image with tag `4.8.1`
- `--name wso2-esb-481`: name of current container running

* Check the process running
```
$ docker ps
CONTAINER ID        IMAGE                     COMMAND                  CREATED             STATUS              PORTS                                         NAMES
5cfd5efb4ae4        chilcano/wso2-esb:4.8.1   "/opt/wso2esb-4.8.1/b"   2 minutes ago       Up 2 minutes        8243/tcp, 8280/tcp, 0.0.0.0:19443->9443/tcp   wso2-esb-481
```

__5) Check if new container is running__

```
$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                                         NAMES
2faa1e4d9933        chilcano/wso2-esb   "/opt/wso2esb-4.8.1/b"   22 minutes ago      Up 22 minutes       8243/tcp, 8280/tcp, 0.0.0.0:19443->9443/tcp   wso2-esb

$ docker ps -a -q
2faa1e4d9933
```

__6) Get web access and SSH to container (WSO2 ESB)__

* Get IP address by listing the running docker-machines or getting information

```
$ docker-machine ls
NAME           ACTIVE   DRIVER       STATE     URL                         SWARM   ERRORS
default        *        virtualbox   Running   tcp://192.168.99.102:2376
machine-dev    -        virtualbox   Running   tcp://192.168.99.100:2376
machine-test   -        virtualbox   Running   tcp://192.168.99.101:2376

$ docker-machine env default
export DOCKER_TLS_VERIFY="1"
export DOCKER_HOST="tcp://192.168.99.102:2376"
export DOCKER_CERT_PATH="/Users/Chilcano/.docker/machine/machines/default"
export DOCKER_MACHINE_NAME="default"
# Run this command to configure your shell:
# eval "$(docker-machine env default)"
```

The docker-machine name is `default` and the IP address and port where WSO2 is running are `192.168.99.102:19443`.

* Getting Web access

```
$ curl https://192.168.99.102:19443
```

* Getting SSH access
```
$ docker-machine ssh default
                        ##         .
                  ## ## ##        ==
               ## ## ## ## ##    ===
           /"""""""""""""""""\___/ ===
      ~~~ {~~ ~~~~ ~~~ ~~~~ ~~~ ~ /  ===- ~~~
           \______ o           __/
             \    \         __/
              \____\_______/
 _                 _   ____     _            _
| |__   ___   ___ | |_|___ \ __| | ___   ___| | _____ _ __
| '_ \ / _ \ / _ \| __| __) / _` |/ _ \ / __| |/ / _ \ '__|
| |_) | (_) | (_) | |_ / __/ (_| | (_) | (__|   <  __/ |
|_.__/ \___/ \___/ \__|_____\__,_|\___/ \___|_|\_\___|_|
Boot2Docker version 1.9.1, build master : cef800b - Fri Nov 20 19:33:59 UTC 2015
Docker version 1.9.1, build a34a1d5
docker@default:~$ ps -aux |grep wso2esb-4.8.1/bin
root      6612  0.0  0.0   4328  1540 ?        Ss   11:56   0:00 /bin/sh /opt/wso2esb-4.8.1/bin/wso2server.sh
root      6633  1.7 20.0 2206676 410264 ?      Sl   11:56   0:42 /usr/bin/java -Xbootclasspath/a: -Xms256m -Xmx1024m -XX:MaxPermSize=256m -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/opt/wso2esb-4.8.1/repository/logs/heap-dump.hprof -Dcom.sun.management.jmxremote -classpath :/opt/wso2esb-4.8.1/bin/org.wso2.carbon.bootstrap-4.2.0.jar:/opt/wso2esb-4.8.1/bin/tcpmon-1.0.jar:/opt/wso2esb-4.8.1/bin/tomcat-juli-7.0.34.jar:/opt/wso2esb-4.8.1/lib/commons-lang-2.6.0.wso2v1.jar -Djava.endorsed.dirs=/opt/wso2esb-4.8.1/lib/endorsed:/usr/jre/lib/endorsed:/usr/lib/endorsed -Djava.io.tmpdir=/opt/wso2esb-4.8.1/tmp -Dcatalina.base=/opt/wso2esb-4.8.1/lib/tomcat -Dwso2.server.standalone=true -Dcarbon.registry.root=/ -Djava.command=/usr/bin/java -Dcarbon.home=/opt/wso2esb-4.8.1 -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager -Dcarbon.config.dir.path=/opt/wso2esb-4.8.1/repository/conf -Djava.util.logging.config.file=/opt/wso2esb-4.8.1/repository/conf/etc/logging-bridge.properties -Dcomponents.repo=/opt/wso2esb-4.8.1/repository/components/plugins -Dconf.location=/opt/wso2esb-4.8.1/repository/conf -Dcom.atomikos.icatch.file=/opt/wso2esb-4.8.1/lib/transactions.properties -Dcom.atomikos.icatch.hide_init_file_path=true -Dorg.apache.jasper.runtime.BodyContentImpl.LIMIT_BUFFER=true -Dcom.sun.jndi.ldap.connect.pool.authentication=simple -Dcom.sun.jndi.ldap.connect.pool.timeout=3000 -Dorg.terracotta.quartz.skipUpdateCheck=true -Djava.security.egd=file:/dev/./urandom -Dfile.encoding=UTF8 org.wso2.carbon.bootstrap.Bootstrap
docker    7369  0.0  0.0   9768   968 pts/0    S+   12:37   0:00 grep wso2esb-4.8.1/bin
```

__7) Stopping a container___

```
$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                                         NAMES
2faa1e4d9933        chilcano/wso2-esb   "/opt/wso2esb-4.8.1/b"   About an hour ago   Up About an hour    8243/tcp, 8280/tcp, 0.0.0.0:19443->9443/tcp   wso2-esb

$ docker stop wso2-esb
wso2-esb
```

__8) Creating a new imagen with new tag from an existing one__

```
$ docker build --rm -t chilcano/wso2-esb:4.8.1 1github-repo/docker-wso2-esb-jgpelaez/4.8.1
Sending build context to Docker daemon  2.56 kB
Step 1 : FROM java:openjdk-7
 ---> a93511e8921b
Step 2 : MAINTAINER juancarlosgpelaez@gmail.com
 ---> Using cache
 ---> 77a5a5e58708
Step 3 : ENV WSO2_URL https://s3-us-west-2.amazonaws.com/wso2-stratos
 ---> Using cache
 ---> 1fb088ebc6a3
Step 4 : ENV WSO2_SOFT_VER 4.8.1
 ---> Using cache
 ---> 9fed1a11c564
Step 5 : RUN mkdir -p /opt && 	wget -P /opt $WSO2_URL/wso2esb-$WSO2_SOFT_VER.zip &&     unzip /opt/wso2esb-$WSO2_SOFT_VER.zip -d /opt &&     rm /opt/wso2esb-$WSO2_SOFT_VER.zip
 ---> Using cache
 ---> 56d9461ba3e0
Step 6 : EXPOSE 9443
 ---> Using cache
 ---> 36dd441496e8
Step 7 : EXPOSE 8280
 ---> Using cache
 ---> 1144ca6dd85a
Step 8 : EXPOSE 8243
 ---> Using cache
 ---> f413f10e4b4b
Step 9 : ENV JAVA_HOME /usr
 ---> Using cache
 ---> ff436f49cf81
Step 10 : CMD /opt/wso2esb-4.8.1/bin/wso2server.sh
 ---> Using cache
 ---> 47f39b8e2d61
Successfully built 47f39b8e2d61
```

Where:
* `-t chilcano/wso2-esb:4.8.1`: the imagen `chilcano/wso2-esb` will be tagged with `4.8.1`

Now, check if new imagen with new tag was created

```
$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
chilcano/wso2-esb   latest              47f39b8e2d61        About an hour ago   867.6 MB
chilcano/wso2-esb   4.8.1               47f39b8e2d61        About an hour ago   867.6 MB
java                openjdk-7           a93511e8921b        9 days ago          589.7 MB
```










## Troubleshooting

### 1) I can not create a new image

```
$ docker build --rm -t chilcano/wso2-esb 1github-repo/docker-wso2-esb-jgpelaez/4.8.1/
Sending build context to Docker daemon  2.56 kB
Step 1 : FROM java:openjdk-7
openjdk-7: Pulling from library/java
1565e86129b8: Pull complete
a604b236bcde: Pull complete
5822f840e16b: Pull complete
276ac25b516c: Pull complete
5d32526c1c0e: Pull complete
a399946808ff: Pull complete
9b79bdb9192c: Pull complete
0862d75437da: Pull complete
a93511e8921b: Extracting [===========================================>       ] 120.9 MB/140.1 MB
Pulling repository docker.io/library/java
8eb91274849e: Error pulling image (openjdk-7) from docker.io/library/java, Untar re-exec error: exit status 1: output: write /usr/lib/x86_64-linux-gnu/libcups.so.2: no space left on device x-gnu/libcups.so.2: no space left on device
ea6bab360f56: Download complete
0f062bc85662: Download complete
1fc461f8452c: Download complete
52b102079bbf: Download complete
6ac22fe9ed4c: Download complete
38dbe578d1b6: Download complete
3e959ffac3a0: Download complete
Error pulling image (openjdk-7) from docker.io/library/java, Untar re-exec error: exit status 1: output: write /usr/lib/x86_64-linux-gnu/libcups.so.2: no space left on device
```
__Answer__

Create and setup properly the new Docker Machine with enought free memory space in virtual hard drive.

- Swith to machine-dev

```
$ eval "$(docker-machine env machine-dev)"
```

- Check the memory in VM

```
$ docker-machine ssh machine-dev
                        ##         .
                  ## ## ##        ==
               ## ## ## ## ##    ===
           /"""""""""""""""""\___/ ===
      ~~~ {~~ ~~~~ ~~~ ~~~~ ~~~ ~ /  ===- ~~~
           \______ o           __/
             \    \         __/
              \____\_______/
 _                 _   ____     _            _
| |__   ___   ___ | |_|___ \ __| | ___   ___| | _____ _ __
| '_ \ / _ \ / _ \| __| __) / _` |/ _ \ / __| |/ / _ \ '__|
| |_) | (_) | (_) | |_ / __/ (_| | (_) | (__|   <  __/ |
|_.__/ \___/ \___/ \__|_____\__,_|\___/ \___|_|\_\___|_|
Boot2Docker version 1.9.1, build master : cef800b - Fri Nov 20 19:33:59 UTC 2015
Docker version 1.9.1, build a34a1d5
docker@machine-dev:~$ df -h /
Filesystem                Size      Used Available Use% Mounted on
tmpfs                   896.6M    735.4M    161.2M  82% /
docker@machine-dev:~$

- Remove and create again this VM

$ docker-machine create --driver virtualbox --virtualbox-memory 8096 machine-dev

Where `--virtualbox-memory 8096` increases the memory to 7 GB (1024 x 8096).


__References__
- http://stackoverflow.com/questions/31909979/docker-machine-no-space-left-on-device


### 2) Can not get access to