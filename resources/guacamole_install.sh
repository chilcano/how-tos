#!/bin/bash

echo "##########################################################"
echo "#  Installing Guacamole Server and Client on Ubuntu      #"
echo "##########################################################"

export DEBIAN_FRONTEND=noninteractive

##### ref: https://www.howtoforge.com/how-to-install-and-configure-guacamole-on-ubuntu-2004/
sudo apt update -y
# utils
sudo apt install -y build-essential pkg-config libx11-dev libxkbfile-dev libsecret-1-dev git jq
# guacamole dependencies
sudo apt install -y make gcc g++ libcairo2-dev libjpeg-turbo8-dev libpng-dev libtool-bin libossp-uuid-dev libavcodec-dev libavutil-dev libswscale-dev freerdp2-dev libpango1.0-dev libssh2-1-dev libvncserver-dev libtelnet-dev libssl-dev libvorbis-dev libwebp-dev

printf ">> Installing tomcat9 \n\n"
sudo apt install -y tomcat9 tomcat9-admin tomcat9-common tomcat9-user

printf ">> Starting tomcat9 \n\n"
# systemctl --user restart code-server
sudo systemctl enable tomcat9
sudo systemctl start tomcat9

printf ">> Installing Guacamole Server and Client \n\n"
GUACAMOLE_VERSION="1.2.0"
GUACAMOLE_SERVER="guacamole-server"
GUACAMOLE_CLIENT="guacamole"
GUACAMOLE_BUNDLE_SERVER="$GUACAMOLE_SERVER-$GUACAMOLE_VERSION"
GUACAMOLE_BUNDLE_CLIENT="$GUACAMOLE_CLIENT-$GUACAMOLE_VERSION"
GUACAMOLE_BUNDLE_URL_SERVER="https://downloads.apache.org/guacamole/${GUACAMOLE_VERSION}/source/${GUACAMOLE_BUNDLE_SERVER}.tar.gz"
GUACAMOLE_BUNDLE_URL_CLIENT="https://downloads.apache.org/guacamole/${GUACAMOLE_VERSION}/binary/${GUACAMOLE_BUNDLE_CLIENT}.war"

if [ -f "${GUACAMOLE_BUNDLE_SERVER}.tar.gz" ]; then
  printf ">> The $GUACAMOLE_BUNDLE_SERVER.tar.gz file exists. Nothing to download. \n\n"
else
  printf ">> Downloading the $GUACAMOLE_BUNDLE_SERVER.tar.gz file. \n\n"
  wget -q $GUACAMOLE_BUNDLE_URL_SERVER
fi
## removing previous installation
sudo make uninstall 
sudo rm -rf $GUACAMOLE_BUNDLE_SERVER
## untaring downloaded file
tar -xzf $GUACAMOLE_BUNDLE_SERVER.tar.gz
cd $GUACAMOLE_BUNDLE_SERVER
autoreconf -fi
./configure --with-init-dir=/etc/init.d
sudo make
sudo make install 
sudo ldconfig

printf ">> Starting Guacamole Server \n\n"
sudo systemctl enable guacd
sudo systemctl start guacd

if [ -f "${GUACAMOLE_BUNDLE_CLIENT}.war" ]; then
  printf ">> The $GUACAMOLE_BUNDLE_CLIENT.war file exists. Nothing to download. \n\n"
else
  printf ">> Downloading the $GUACAMOLE_BUNDLE_CLIENT.war file. \n\n"
  wget -q $GUACAMOLE_BUNDLE_URL_CLIENT
fi
sudo rm -rf /etc/guacamole
sudo mkdir /etc/guacamole
sudo  mv $GUACAMOLE_BUNDLE_CLIENT.war /etc/guacamole/guacamole.war
## force the creation of a symbolic link
sudo  ln -sf /etc/guacamole/guacamole.war /var/lib/tomcat9/webapps/
## remove existing guacamole webapp
sudo rm -rf /var/lib/tomcat9/webapps/guacamole/

printf ">> Starting Guacamole \n\n"
sudo systemctl restart tomcat9
sudo systemctl restart guacd

printf ">> Configuring Guacamole \n\n"

cat <<EOF > guacamole.properties
guacd-hostname: localhost
guacd-port:    4822
user-mapping:    /etc/guacamole/user-mapping.xml
EOF
sudo chown -R root:root guacamole.properties
sudo mv -f guacamole.properties /etc/guacamole/guacamole.properties

## Creating Guacamole Client library and extension directories
sudo mkdir /etc/guacamole/{extensions,lib}

## Setting Guacamole home directory
sudo sh -c "echo \"GUACAMOLE_HOME=/etc/guacamole\" >> /etc/default/tomcat9"

printf ">> Creating Guacamole users \n"
#GUACAMOLE_USER_RND=$(openssl rand -base64 32)
GUACAMOLE_USER_RND="demodemo"
GUACAMOLE_USER_MD5=$(echo -n $GUACAMOLE_USER_RND | md5sum | cut -d ' ' -f 1)

## create a new user-mapping.xml
cat <<EOF > user-mapping.xml
<user-mapping>
  <authorize username="admin" password="${GUACAMOLE_USER_MD5}" encoding="md5">
    <connection name="VNC">
      <protocol>vnc</protocol>
      <param name="hostname">192.168.1.53</param>
      <param name="port">5901</param>
      <param name="password">VNCPASS</param>
    </connection>

    <connection name="Windows Server">
      <protocol>rdp</protocol>
      <param name="hostname">192.168.10.53</param>
      <param name="port">3389</param>
    </connection>

    <connection name="Ubuntu20.04-Server">
      <protocol>ssh</protocol>
      <param name="hostname">192.168.1.53</param>
      <param name="port">22</param>
      <param name="username">chilcano</param>
    </connection>
  </authorize>
</user-mapping>
EOF
sudo chown -R root:root user-mapping.xml
sudo mv -f user-mapping.xml /etc/guacamole/user-mapping.xml

printf ">> Starting Guacamole again \n"
sudo systemctl restart tomcat9
sudo systemctl restart guacd

printf ">> Access Guacamole Web UI: \n"
printf "\t User: admin \n"
printf "\t Pwd: ${GUACAMOLE_USER_RND} \n"

printf ">> Guacamole Server and Client were installed successfully. \n"
