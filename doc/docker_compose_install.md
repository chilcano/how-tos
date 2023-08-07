# Docker Compose guide


This process is valid for Ubuntu 22.04 and 23.x

## 1. Install Docker Compose plugin from Docker official apt repo

Only follow the Docker official installation.

1. [Official Docker on Ubuntu using APT repo](https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository)
2. [Personal Docker guide](docker_useful_commands.md)


## 2. Install Docker Compose plugin on existing Docker Engine

- https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-compose-on-ubuntu-22-04


### 1. Installation

> You have to install Docker Engine before.

```sh
$ mkdir -p ~/.docker/cli-plugins/
$ curl -SL https://github.com/docker/compose/releases/download/v2.3.3/docker-compose-linux-x86_64 -o ~/.docker/cli-plugins/docker-compose

$ chmod +x ~/.docker/cli-plugins/docker-compose

$ docker compose version

Docker Compose version v2.3.3
```



## Running a simple application

```sh
$ mkdir app

$ nano app/index.html

$ nano docker-compose.app-simple.yaml

$ docker compose -f docker-compose.app-simple.yaml up -d

$ docker compose ls

NAME                STATUS              CONFIG FILES
app-simple          running(1)          /home/chilcano/repos-aa/vocdoni/vocdoni-infra/docs/ether-node/app-simple/docker-compose.app-simple.yaml

$ docker compose ps

no configuration file provided: not found

$ docker compose -f docker-compose.app-simple.yaml ps

NAME                COMMAND                  SERVICE             STATUS              PORTS
app-simple-web-1    "/docker-entrypoint.…"   web                 running             0.0.0.0:8181->80/tcp, :::8181->80/tcp

```