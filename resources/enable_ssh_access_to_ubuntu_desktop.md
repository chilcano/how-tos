# Configure remote SSH access to Ubuntu Desktop

Reference:
- https://linuxize.com/post/how-to-enable-ssh-on-ubuntu-18-04/

```sh
$ sudo apt update
$ sudo apt install openssh-server -y

$ sudo systemctl status ssh
```sh

If the firewall is enabled on your system, make sure to open the SSH port:
```sh
$ sudo systemctl status ufw
$ sudo ufw allow ssh

$ ip a
```

