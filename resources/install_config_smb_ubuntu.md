## Install and configure Samba (SMB) in Ubuntu

**Ref:**  
- https://ubuntu.com/tutorials/install-and-configure-samba#1-overview

### 1. Install Samba
```sh
sudo apt update
sudo apt install samba
```

### 2. Setting up Samba

#### Create a sharing directory 
```sh
mkdir /home/<username>/sambashare/
```

#### Add previous directory to Samba
```sh
sudo nano /etc/samba/smb.conf
```

At the bottom of the file, add the following lines:
```sh
[sambashare]
    comment = Samba on Ubuntu
    path = /home/username/sambashare
    read only = no
    browsable = yes
```

#### Setup an user account for sharing
```sh
sudo smbpasswd -a username
```

- `username` should be a valid user

#### Restart Samba 
```sh
$ sudo systemctl restart smbd
```

#### Update the firewall rules to allow Samba traffic
```sh
sudo ufw allow samba
```

### 3. Connecting to the shared directory

From Ubuntu / MacOS:
```sh
smb://ip-address/sambashare 
``` 

From Windows:
```sh
\\ip-address\sambashare
```


