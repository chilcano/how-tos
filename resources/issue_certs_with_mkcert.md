## Issue Certificates with MKCert 

#### Ref: 
- https://github.com/FiloSottile/mkcert

### Requisites

We are going to use Caddy as HTTPS Reverse Proxy and its ability to automatic to get a TLS Certificate.
The Certificates will be issued by Let's Encrypt and Caddy will request them automatically.


### Install Caddy as HTTPS Reverse Proxy

```sh
echo "deb [trusted=yes] https://apt.fury.io/caddy/ /" \
    | sudo tee -a /etc/apt/sources.list.d/caddy-fury.list
sudo apt update
sudo apt install caddy
``` 

