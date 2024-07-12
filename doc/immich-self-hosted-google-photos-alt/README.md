# Immich, a Self Hosted Google Photos Alternative

## Steps

### 1. DuckDNS

Create a custom DNS. In my case I've created:

* DNS Provider: https://www.duckdns.org/domains
* Domain: `chilcano-hl`
* IPv4: `192.168.1.169`
  - This IP should be the local-private IP address where the Caddy docker container is running.
  - The immich will be available on: `https://immich.chilcano-hl.duckdns.org/`



### 2. Caddy

* Caddy docker image must have pre-installed the DuckDNS Module:
  - https://github.com/caddy-dns/duckdns

```sh
# Create a Docker network if it hasn't been created before
docker network create proxy-net

# Docker Login
export CR_PAT=YOUR_TOKEN
echo $CR_PAT | docker login ghcr.io -u chilcano --password-stdin

# Pull Docker image from GHCR
docker pull ghcr.io/chilcano/caddy:2.8.4

# Docker Logout
docker logout

# Start containers
docker compose up -d

# If docker image has changed, then you need fetch updated image
docker compose pull && docker compose up -d

# If only Caddy config file has changed, a restart is enough
docker compose restart

# If .env file has changed, thenyou need remove current docker instance and create new one
docker compose down
docker compose up -d

# Check the logs
docker logs -f caddy

# Exec commands
docker exec -it caddy sh
```

### 3. Immich

* https://immich.app/docs/install/docker-compose

```sh
# Create a Docker network if it hasn't been created before
docker network create proxy-net

# Start containers
docker compose up -d

# Upgrade
docker compose pull && docker compose up -d

# Check the logs
docker logs -f immich_server
```

### 4. Immich App in your Mobile

* https://immich.app/

### 5. Moving existing Docker volumes to local directories

__1. Identify the volumes to move__

```sh
# Current Docker volumes
docker volume ls                                 
DRIVER    VOLUME NAME
local     immich_media
local     immich_model-cache
local     immich_pgdata

# Get volume details by volume inspect
 docker volume inspect immich_media
[
    {
        "CreatedAt": "2024-07-05T17:30:37+02:00",
        "Driver": "local",
        "Labels": {
            "com.docker.compose.project": "immich",
            "com.docker.compose.version": "2.24.5",
            "com.docker.compose.volume": "media"
        },
        "Mountpoint": "/var/lib/docker/volumes/immich_media/_data",
        "Name": "immich_media",
        "Options": null,
        "Scope": "local"
    }
]

docker volume inspect immich_pgdata  
[
    {
        "CreatedAt": "2024-07-05T16:52:45+02:00",
        "Driver": "local",
        "Labels": {
            "com.docker.compose.project": "immich",
            "com.docker.compose.version": "2.24.5",
            "com.docker.compose.volume": "pgdata"
        },
        "Mountpoint": "/var/lib/docker/volumes/immich_pgdata/_data",
        "Name": "immich_pgdata",
        "Options": null,
        "Scope": "local"
    }
]


# Get volume details by container inspect
docker inspect immich_server | jq -r ".[].Mounts"  
[
  {
    "Type": "bind",
    "Source": "/etc/localtime",
    "Destination": "/etc/localtime",
    "Mode": "ro",
    "RW": false,
    "Propagation": "rprivate"
  },
  {
    "Type": "bind",
    "Source": "/var/lib/docker/volumes/immich_media/_data",
    "Destination": "/usr/src/app/upload",
    "Mode": "rw",
    "RW": true,
    "Propagation": "rprivate"
  }
]

docker inspect immich_postgres | jq -r ".[].Mounts"
[
  {
    "Type": "bind",
    "Source": "/var/lib/docker/volumes/immich_pgdata/_data",
    "Destination": "/var/lib/postgresql/data",
    "Mode": "rw",
    "RW": true,
    "Propagation": "rprivate"
  }
]
```

__2. Stop and remove the Docker instances__

This command will stop and remove the docker instances only and will keep the data or volumes.
```sh
docker compose down
```

__3. Copy the default docker volumes__

```sh
sudo cp -rp /var/lib/docker/volumes/immich_media /home/chilcano/_docker_volumes/
sudo cp -rp /var/lib/docker/volumes/immich_pgdata /home/chilcano/_docker_volumes/
```

__4. Update the volume paths in the .env file corresponding to its docker-compose file__

```sh
...
#UPLOAD_LOCATION=media      ## 'media' docker volume created here: /var/lib/docker/volumes/immich_media/
UPLOAD_LOCATION=/home/chilcano/_docker_volumes/immich_media/_data
...
#DB_DATA_LOCATION=pgdata    ## 'pgdata' docker volume created here: /var/lib/docker/volumes/immich_pgdata/
DB_DATA_LOCATION=/home/chilcano/_docker_volumes/immich_pgdata/_data
...
```

__5. Start new Docker instances__

```sh
docker compose up -d

# Check logs
docker logs -f immich_server
```

__6. Check the updated volume paths__

* You should see the new paths updated.
* The initial docker volumes (`/var/lib/docker/volumes/<vol_name>`) can be removed.
* The initial volumes names still are shown by `docker volume ls` although they are no used anymore. To remove them, execute these steps:
   - Remove them from the top-level `volumes` in the corresponding docker-compose file.
   - Run `docker volume prune`

```sh
# Get the updated volume details by container inspect
docker inspect immich_server | jq -r ".[].Mounts"  
[
  {
    "Type": "bind",
    "Source": "/etc/localtime",
    "Destination": "/etc/localtime",
    "Mode": "ro",
    "RW": false,
    "Propagation": "rprivate"
  },
  {
    "Type": "bind",
    "Source": "/home/chilcano/_docker_volumes/immich_media/_data",
    "Destination": "/usr/src/app/upload",
    "Mode": "rw",
    "RW": true,
    "Propagation": "rprivate"
  }
]

docker inspect immich_postgres | jq -r ".[].Mounts"
[
  {
    "Type": "bind",
    "Source": "/home/chilcano/_docker_volumes/immich_pgdata/_data",
    "Destination": "/var/lib/postgresql/data",
    "Mode": "rw",
    "RW": true,
    "Propagation": "rprivate"
  }
]
```
