# Project Discovery - Nuclei

## References:

* https://blog.projectdiscovery.io/how-to-run-nuclei-other-projectdiscovery-tools-in-docker/
* https://docs.projectdiscovery.io/tools/nuclei/running
* https://github.com/projectdiscovery/nuclei-templates
* https://github.com/projectdiscovery/subfinder
* https://github.com/projectdiscovery/katana
* https://github.com/projectdiscovery/httpx
* https://hub.docker.com/r/chilcano/netcat
* https://escape.tech/blog/devsecops-part-iii-scanning-live-web-applications/

## 1. Install

__1. Docker Compose__

```sh
$ cd how-tos/src/hacktools/

$ docker network create hack-net
$ docker compose -f docker-compose-pd.yml up -d
$ docker compose -f docker-compose-pd.yml run nuclei -version
[INF] Nuclei Engine Version: v3.3.4
[INF] Nuclei Config Directory: /root/.config/nuclei
[INF] Nuclei Cache Directory: /root/.cache/nuclei
[INF] PDCP Directory: /root/.pdcp
```

__2. Docker__

```sh
$ cd how-tos/src/hacktools/

$ docker pull projectdiscovery/nuclei:latest
$ docker run projectdiscovery/nuclei:latest --version
[INF] Nuclei Engine Version: v3.3.4
[INF] Nuclei Config Directory: /root/.config/nuclei
[INF] Nuclei Cache Directory: /root/.cache/nuclei
[INF] PDCP Directory: /root/.pdcp

$ docker run --rm --name mynuclei -v ./pd/:/pd/ projectdiscovery/nuclei:latest --version
[INF] Nuclei Engine Version: v3.3.4
[INF] Nuclei Config Directory: /root/.config/nuclei
[INF] Nuclei Cache Directory: /root/.cache/nuclei
[INF] PDCP Directory: /root/.pdcp

$ docker run --rm projectdiscovery/nuclei:latest -u <target_url>
$ docker run --rm --network juiceshop-net projectdiscovery/nuclei:latest -u https://test.juiceshop.local
```

__3. Binary__

```sh
VER_NUCLEI="3.3.4"
wget https://github.com/projectdiscovery/nuclei/releases/download/v${VER_NUCLEI}/nuclei_${VER_NUCLEI}_linux_amd64.zip
wget https://github.com/projectdiscovery/nuclei/releases/download/v3.3.4/nuclei_3.3.4_linux_amd64.zip


## Latest version
$ curl -s https://api.github.com/repos/projectdiscovery/nuclei/releases/latest | jq -r '.tag_name'

## List all available binaries released
$ curl -s https://api.github.com/repos/projectdiscovery/nuclei/releases/latest | jq -r '.assets[].browser_download_url'

## Download binary by pattern 'linux_amd64.zip', install and cleaned 
URL_NUCLEI=$(curl -s https://api.github.com/repos/projectdiscovery/nuclei/releases/latest | jq -r '.assets[].browser_download_url | select(. | contains("linux_amd64.zip"))')

URL_NUCLEI=$(curl -s https://api.github.com/repos/projectdiscovery/nuclei/releases/latest | grep "https.*linux_amd64.zip" | awk '{print $2}' | sed 's|[\"\,]*||g')
curl -sL ${URL_NUCLEI} -o temp.zip && unzip temp.zip -d ./nuclei && rm -rf temp.zip
cp ./nuclei/nuclei ~/.local/bin/ && rm -rf nuclei/ && nuclei --version

[INF] Nuclei Engine Version: v3.3.4
[INF] Nuclei Config Directory: /home/chilcano/.config/nuclei
[INF] Nuclei Cache Directory: /home/chilcano/.cache/nuclei
[INF] PDCP Directory: /home/chilcano/.pdcp
```

## 2. Execute and using default templates

```sh
## 
$ nuclei -u https://test.juiceshop.local 

[swagger-api] [http] [info] https://test.juiceshop.local/api-docs/swagger.yaml [paths="/api-docs/swagger.yaml"]
[missing-sri] [http] [info] https://test.juiceshop.local ["//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js","//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js"]
[ssh-sha1-hmac-algo] [javascript] [info] test.juiceshop.local:22
[ssh-password-auth] [javascript] [info] test.juiceshop.local:22
[ssh-server-enumeration] [javascript] [info] test.juiceshop.local:22 ["SSH-2.0-OpenSSH_9.0p1 Ubuntu-1ubuntu8.7"]
[ssh-auth-methods] [javascript] [info] test.juiceshop.local:22 ["["publickey","password"]"]
[openssh-detect] [tcp] [info] test.juiceshop.local:22 ["SSH-2.0-OpenSSH_9.0p1 Ubuntu-1ubuntu8.7"]
[tls-version] [ssl] [info] test.juiceshop.local:443 ["tls12"]
[tls-version] [ssl] [info] test.juiceshop.local:443 ["tls13"]
[security-txt] [http] [info] https://test.juiceshop.local/.well-known/security.txt ["mailto:donotreply@owasp-juice.shop"]
[x-recruiting-header] [http] [info] https://test.juiceshop.local ["/#/jobs"]
[fingerprinthub-web-fingerprints:qm-system] [http] [info] https://test.juiceshop.local
[fingerprinthub-web-fingerprints:apilayer-caddy] [http] [info] https://test.juiceshop.local
[tech-detect:caddy] [http] [info] https://test.juiceshop.local
[http-missing-security-headers:strict-transport-security] [http] [info] https://test.juiceshop.local
[http-missing-security-headers:x-permitted-cross-domain-policies] [http] [info] https://test.juiceshop.local
[http-missing-security-headers:cross-origin-opener-policy] [http] [info] https://test.juiceshop.local
[http-missing-security-headers:cross-origin-resource-policy] [http] [info] https://test.juiceshop.local
[http-missing-security-headers:content-security-policy] [http] [info] https://test.juiceshop.local
[http-missing-security-headers:permissions-policy] [http] [info] https://test.juiceshop.local
[http-missing-security-headers:referrer-policy] [http] [info] https://test.juiceshop.local
[http-missing-security-headers:clear-site-data] [http] [info] https://test.juiceshop.local
[http-missing-security-headers:cross-origin-embedder-policy] [http] [info] https://test.juiceshop.local
[prometheus-metrics] [http] [medium] https://test.juiceshop.local/metrics
[addeventlistener-detect] [http] [info] https://test.juiceshop.local
[owasp-juice-shop-detect] [http] [info] https://test.juiceshop.local
[robots-txt-endpoint] [http] [info] https://test.juiceshop.local/robots.txt
[ssl-dns-names] [ssl] [info] test.juiceshop.local:443 ["test.juiceshop.local"]
[caa-fingerprint] [dns] [info] test.juiceshop.local

$ nuclei -u http://tawa.local:81

[WRN] Found 2 templates with runtime error (use -validate flag for further examination)
[INF] Current nuclei version: v3.3.4 (latest)
[INF] Current nuclei-templates version: v10.0.1 (latest)
[WRN] Scan results upload to cloud is disabled.
[INF] New templates added in latest release: 86
[INF] Templates loaded for current scan: 8587
[INF] Executing 8584 signed templates from projectdiscovery/nuclei-templates
[WRN] Loading 3 unsigned templates for scan. Use with caution.
[INF] Targets loaded for current scan: 1
[INF] Templates clustered: 1597 (Reduced 1501 Requests)
[INF] Using Interactsh Server: oast.site
[waf-detect:securesphere] [http] [info] http://tawa.local:81
[open-redirect-generic] [http] [medium] http://tawa.local:81//oast.me/ [redirect="/oast.me/"]
[prometheus-metrics] [http] [medium] http://tawa.local:81/metrics
[http-missing-security-headers:permissions-policy] [http] [info] http://tawa.local:81
[http-missing-security-headers:x-frame-options] [http] [info] http://tawa.local:81
[http-missing-security-headers:x-content-type-options] [http] [info] http://tawa.local:81
[http-missing-security-headers:x-permitted-cross-domain-policies] [http] [info] http://tawa.local:81
[http-missing-security-headers:clear-site-data] [http] [info] http://tawa.local:81
[http-missing-security-headers:cross-origin-embedder-policy] [http] [info] http://tawa.local:81
[http-missing-security-headers:cross-origin-resource-policy] [http] [info] http://tawa.local:81
[http-missing-security-headers:strict-transport-security] [http] [info] http://tawa.local:81
[http-missing-security-headers:referrer-policy] [http] [info] http://tawa.local:81
[http-missing-security-headers:cross-origin-opener-policy] [http] [info] http://tawa.local:81
[http-missing-security-headers:content-security-policy] [http] [info] http://tawa.local:81
[kubernetes-metrics] [http] [low] http://tawa.local:81/metrics
[mongodb-exporter-metrics] [http] [medium] http://tawa.local:81/metrics
[mysqld-exporter-metrics] [http] [info] http://tawa.local:81/metrics
[postgres-exporter-metrics] [http] [low] http://tawa.local:81/metrics
[cookies-without-httponly] [http] [info] http://tawa.local:81
[cookies-without-secure] [http] [info] http://tawa.local:81
[tech-detect:google-font-api] [http] [info] http://tawa.local:81
[tech-detect:express] [http] [info] http://tawa.local:81
[tech-detect:owl-carousel] [http] [info] http://tawa.local:81
[tech-detect:font-awesome] [http] [info] http://tawa.local:81
[tech-detect:animate.css] [http] [info] http://tawa.local:81
[tech-detect:bootstrap] [http] [info] http://tawa.local:81
[caa-fingerprint] [dns] [info] tawa.local

$ nuclei -u https://sockshop.local

[WRN] Found 2 templates with runtime error (use -validate flag for further examination)
[INF] Current nuclei version: v3.3.4 (latest)
[INF] Current nuclei-templates version: v10.0.1 (latest)
[WRN] Scan results upload to cloud is disabled.
[INF] New templates added in latest release: 86
[INF] Templates loaded for current scan: 8587
[INF] Executing 8584 signed templates from projectdiscovery/nuclei-templates
[WRN] Loading 3 unsigned templates for scan. Use with caution.
[INF] Targets loaded for current scan: 1
[INF] Templates clustered: 1597 (Reduced 1501 Requests)
[INF] Using Interactsh Server: oast.pro
[waf-detect:akamai] [http] [info] https://sockshop.local
[open-redirect-generic] [http] [medium] https://sockshop.local//oast.me/ [redirect="/oast.me/"]
[openssh-detect] [tcp] [info] sockshop.local:22 ["SSH-2.0-OpenSSH_9.0p1 Ubuntu-1ubuntu8.7"]
[ssh-sha1-hmac-algo] [javascript] [info] sockshop.local:22
[ssh-auth-methods] [javascript] [info] sockshop.local:22 ["["publickey","password"]"]
[ssh-password-auth] [javascript] [info] sockshop.local:22
[ssh-server-enumeration] [javascript] [info] sockshop.local:22 ["SSH-2.0-OpenSSH_9.0p1 Ubuntu-1ubuntu8.7"]
[tls-version] [ssl] [info] sockshop.local:443 ["tls12"]
[tls-version] [ssl] [info] sockshop.local:443 ["tls13"]
[http-missing-security-headers:clear-site-data] [http] [info] https://sockshop.local
[http-missing-security-headers:cross-origin-embedder-policy] [http] [info] https://sockshop.local
[http-missing-security-headers:cross-origin-resource-policy] [http] [info] https://sockshop.local
[http-missing-security-headers:content-security-policy] [http] [info] https://sockshop.local
[http-missing-security-headers:permissions-policy] [http] [info] https://sockshop.local
[http-missing-security-headers:x-frame-options] [http] [info] https://sockshop.local
[http-missing-security-headers:x-permitted-cross-domain-policies] [http] [info] https://sockshop.local
[http-missing-security-headers:referrer-policy] [http] [info] https://sockshop.local
[http-missing-security-headers:strict-transport-security] [http] [info] https://sockshop.local
[http-missing-security-headers:x-content-type-options] [http] [info] https://sockshop.local
[http-missing-security-headers:cross-origin-opener-policy] [http] [info] https://sockshop.local
[fingerprinthub-web-fingerprints:apilayer-caddy] [http] [info] https://sockshop.local
[tech-detect:caddy] [http] [info] https://sockshop.local
[tech-detect:owl-carousel] [http] [info] https://sockshop.local
[tech-detect:font-awesome] [http] [info] https://sockshop.local
[tech-detect:animate.css] [http] [info] https://sockshop.local
[tech-detect:bootstrap] [http] [info] https://sockshop.local
[tech-detect:google-font-api] [http] [info] https://sockshop.local
[tech-detect:express] [http] [info] https://sockshop.local
[ssl-dns-names] [ssl] [info] sockshop.local:443 ["sockshop.local"]
[caa-fingerprint] [dns] [info] sockshop.local

## Using other params
$ nuclei -l targets.txt
$ nuclei -l targets.burp -im burp
$ nuclei -l openapi.yaml -im openapi
```

## 3. Using custom Templates

* https://github.com/projectdiscovery/nuclei-templates
* Steps:
  1. Create your own template to assess the security your scenario.
  2. Load your template into Nuclei
  3. Execute Nuclei and get a report

```sh

```

