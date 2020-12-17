## Configure remote SSH access to Ubuntu Desktop

__Reference:__
- https://linuxize.com/post/how-to-enable-ssh-on-ubuntu-18-04/

Install OpenSSH server:
```sh
$ sudo apt update
$ sudo apt install openssh-server -y

$ sudo systemctl status ssh
```

If the firewall is enabled on your system, then make sure to open the SSH port:
```sh
$ sudo systemctl status ufw
$ sudo ufw allow ssh

$ ip a
```

