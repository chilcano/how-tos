# Install OWASP ZAP on Linux


## References

* https://itsfoss.com/install-chrome-ubuntu/



## 01. Install pre-requisites

```sh
sudo apt-get install default-jre

wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
google-chrome
```

## 02. Installation of ZAP

### From official tar file

1. Download tar file from https://www.zaproxy.org/download/
2. Extract tar and run it
```sh
cd ~/Downloads
tar -xvf ZAP_2_<version>_Linux.tar.gz   
cd ZAP_2_<version> 
./zap.sh
```

### From supported Opensource repo

1. Download deb file from https://software.opensuse.org/download.html?project=home%3Acabelo&package=zap
2. Install and run it
```sh
cd ~/Downloads/
sudo dpkg -i zap_2.16.1-1_amd64.deb
zapproxy
```

## 03. Add ZAP shortcut to Linux

* https://www.zaproxy.org/faq/how-can-i-add-an-application-icon-for-zap-to-fedora-gnome-3/

```sh
sudo nano /usr/share/applications/owasp-zap.desktop

[Desktop Entry]
Name=OWASP ZAP
Exec=/usr/share/zap/zap.sh
Icon=/usr/share/zap/zap.ico
Categories=Programming;Security;
Type=Application
```