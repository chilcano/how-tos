# Docker installation guide

## 1. Docker for Ubuntu 20.04 in WSL2

* Ref: https://dev.to/_nicolas_louis_/how-to-run-docker-on-windows-without-docker-desktop-hik

Remove previous Docker installations.
```sh
$ sudo apt -y remove docker docker-engine docker.io containerd runc
```

## 2. Docker on Linux


### 2.2. Docker.io (unofficial) on Ubuntu

**Ubuntu 22, 24 and 26 comes with Docker.io (unofficial) by default in apt repositories**
**If you want to install Containerd, Buildx and Compose, you should configure Official Docker APT repositories**

```sh
sudo apt -y update; sudo apt -y install ca-certificates curl gnupg

# install docker.io (unofficial)
sudo apt -y install docker.io 

# enable docker service
sudo systemctl enable --now docker

# fix docker version to avoid being reinstalled or removed
sudo apt-mark hold docker.io

# check docker.io
docker -v
Docker version 29.1.3, build 29.1.3-0ubuntu3~24.04.1

# check docker compose
# to get this, you should install it from official docker apt repos

# check the installed version (unofficial)
curl -s --unix-socket /var/run/docker.sock http://latest/version | jq -r -M '.Version'
29.1.3
```


### 2.1. Official Docker on Ubuntu


**Official guide:** https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository


**1. Set official docker apt repositories**

```sh
# Add Docker's official GPG key:
sudo apt -y update
sudo apt -y install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

sudo apt -y update
```

**2. Install Docker CE, CLI, Containerd, Buildx and Compose**

```sh
# install latest version docker-ce (official)
sudo apt -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# check
docker -v
Docker version 29.4.2, build 055a478

docker compose version
Docker Compose version v5.1.3

curl -s --unix-socket /var/run/docker.sock http://latest/version | jq -r -M '.Version'
29.4.2
```

### 2.3. Adding user to Docker group

**You will not need to run the Docker commands prefixing `sudo`**

```sh
# Add current user to Docker group.
$ sudo usermod -aG docker ${USER}

# Check if you are in Docker group.
$ su - ${USER}

# list groups
$ groups

chilcano adm cdrom sudo dip plugdev lpadmin lxd sambashare docker

# exit the $USER session
$ exit
```

Re-start your computer. 
```sh
# showing docker status
$ sudo systemctl status docker

# test docker
docker run hello-world
```
