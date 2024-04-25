# Trivy - Security Dependencies Checking

## 1. Install


__1. From Debian/Ubuntu repos__

```sh
$ sudo apt-get install wget apt-transport-https gnupg lsb-release
$ wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null
$ echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee -a /etc/apt/sources.list.d/trivy.list
$ sudo apt-get update
$ sudo apt-get install trivy

```

__2. From Github released binary__

```sh
$ curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin v0.49.0
```

```sh
Usage: $this [-b] bindir [-d] [tag]
  -b sets bindir or installation directory, Defaults to ./bin
  -d turns on debug logging
   [tag] is a tag from
   https://github.com/aquasecurity/trivy/releases
   If tag is missing, then the latest will be used.
```

To install latest version only for current user and debugging the installation, run this:
```sh
$ curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b ~/.local/bin -d


aquasecurity/trivy info checking GitHub for latest tag
aquasecurity/trivy info found version: 0.49.0 for v0.49.0/Linux/64bit
aquasecurity/trivy debug downloading files into /tmp/tmp.rKAaOuXTpF
aquasecurity/trivy debug http_download https://github.com/aquasecurity/trivy/releases/download/v0.49.0/trivy_0.49.0_Linux-64bit.tar.gz
aquasecurity/trivy debug http_download https://github.com/aquasecurity/trivy/releases/download/v0.49.0/trivy_0.49.0_checksums.txt
aquasecurity/trivy info installed /home/chilcano/.local/bin/trivy
```

Checking installation:
```sh
$ trivy -v

Version: 0.49.0
```

* Further info: https://aquasecurity.github.io/trivy/v0.49/getting-started/installation/

__3. Integrate it with VSCode__

Trivy CLI must be installed before using it from VSCode. Once done, only install the Trivy extension from VSCode Marketplace.



## 2. Running Trivy


Clone any Github repository, go to a project directory to run Trivy from a Terminal.

### Example 01:

* Scan for vulns, secrets and misconfigs in local folder repo and send results to stdout.

```sh
$ trivy fs --format table --vuln-type os,library --scanners vuln,secret,misconfig --severity UNKNOWN,LOW,MEDIUM,HIGH,CRITICAL .
```

You will see these results in your terminal.
![](img/trivy-security-deps-scanning-table-result.png)


### Example 02:

* Skipping directories. This is convenient when dependencies were installed in local directory and we want to ignore vulnerabilities there. In this case we want to skip the `node_modules` dir.

```sh
$ trivy fs --format table --vuln-type os,library --scanners vuln,secret,misconfig --skip-dirs node_modules --severity UNKNOWN,LOW,MEDIUM,HIGH,CRITICAL .

```

![](img/trivy-security-deps-scanning-table-result-skip-dir.png)


### Example 03:

* Scan for vulns, secrets and misconfigs in local container image and send results to stdout.

Make sure you have a `Dockerfile` and `.dockerignore` files successfully created. With that, only build the image using proper name and tags.
```sh
$ docker build . -t chilcano/dops-srv-trivy:v1

$ docker images                            
REPOSITORY                       TAG          IMAGE ID       CREATED          SIZE
chilcano/dops-srv-trivy          v1           664a04c8e320   12 seconds ago   829MB
```
Once built the image, run Trivy to scan it. Note that this scan doesn't use `misconfig` option (`misconfig` is the new flag and replaces `config`) because I want to scan only for vulns in container image and not in other `Dockerfile` files included as examples in dependencies.
For example, the package `swagger2openapi-7.0.8` includes a Dockerfile that run commands as ROOT and Trivy will detect that as issue.

```sh
$ trivy image --format table --vuln-type os,library --scanners vuln,secret --severity UNKNOWN,LOW,MEDIUM,HIGH,CRITICAL chilcano/dops-srv-trivy:v1
```

You will have this output:
![](trivy-security-deps-scanning-table-result-docker.png)


### Example 04:

* Running Trivy to scan vulns, secrets and misconfigs on local directory and generating HTML.

```sh
$ trivy fs --format template --template @/contrib/html.tpl --vuln-type os,library --scanners vuln,secret,misconfig --severity UNKNOWN,LOW,MEDIUM,HIGH,CRITICAL --output trivy-results-repo-55f3040.html .
```


* Using output template for JUnit.

```sh
$ trivy fs --format template --template @/contrib/junit.tpl --vuln-type os,library --scanners vuln,secret,misconfig --severity UNKNOWN,LOW,MEDIUM,HIGH,CRITICAL --output trivy-results-repo-55f3040.junit .
```

### Example 05:


* Scanning vulns, secrets and misconfig in a remote container image and send report to stdout

```sh
$ trivy image --format table --vuln-type os,library --scanners vuln,secret,misconfig --severity UNKNOWN,LOW,MEDIUM,HIGH,CRITICAL ghcr.io/aragon/devops-server:test-55f3040
```

