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

