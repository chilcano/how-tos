## Issue Certificates with MKCert 

#### Ref: 
- https://github.com/FiloSottile/mkcert

### Requisites

We are going to use Caddy as HTTPS Reverse Proxy and its ability to automatic to get a TLS Certificate.
The Certificates will be issued by Let's Encrypt and Caddy will request them automatically.


### Install Caddy as HTTPS Reverse Proxy

#### 1. Install Caddy

```sh
echo "deb [trusted=yes] https://apt.fury.io/caddy/ /" \
    | sudo tee -a /etc/apt/sources.list.d/caddy-fury.list
sudo apt update
sudo apt install -y caddy
``` 

#### 2. Configure Caddy

Update `/etc/caddy/Caddyfile` with your configuration:

```sh
NOW1=$(date +"%y%m%d.%H%M%S")

cat <<EOF > Caddyfile
:443

reverse_proxy 127.0.0.1:8001
EOF
sudo chown -R root:root Caddyfile
sudo mv /etc/caddy/Caddyfile "/etc/caddy/Caddyfile.${NOW1}" 
sudo mv Caddyfile /etc/caddy/Caddyfile
```

#### 3. Load changes

```sh
sudo systemctl reload caddy
```


