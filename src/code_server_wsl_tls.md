Gist:

ddb41f76e8bb0374ad7fce88



$ sudo apt -y update 
$ sudo apt -y install jq apt-transport-https


### Systemd code-server.service

```
$ cat  /etc/systemd/system/code-server.service

[Unit]
Description=code-server
After=network.target

[Service]
Type=exec
ExecStart=/usr/bin/code-server
Restart=always
User=rogerc

[Install]
WantedBy=default.target
```

### Systemd commands

```
sudo systemctl daemon-reload
sudo systemctl enable --now code-server
```


### Install code-server in WSL

```
mkdir -p ~/.local/lib ~/.local/bin
curl -fL https://github.com/cdr/code-server/releases/download/v3.4.1/code-server-3.4.1-linux-amd64.tar.gz \
  | tar -C ~/.local/lib -xz
mv ~/.local/lib/code-server-3.4.1-linux-amd64 ~/.local/lib/code-server-3.4.1
ln -s ~/.local/lib/code-server-3.4.1/bin/code-server ~/.local/bin/code-server
```

#### Optional ?
```sh
nano ~/.bashrc
PATH="~/.local/bin:$PATH"
```

#### Start code-server without authentication
code-server --auth none

