# Install OWASP ZAP on Linux


## References

* https://itsfoss.com/install-chrome-ubuntu/
* https://www.zaproxy.org/download/
* https://www.zaproxy.org/docs/desktop/addons/browser-view/


## 1. Install pre-requisites


### 1.1. Java and Google Chrome

```sh
## install java
sudo apt-get install default-jre

## download google-chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
## install google-chrome
sudo dpkg -i google-chrome-stable_current_amd64.deb
## check
google-chrome
```

If you have many Java versions installed, you should select one:
```sh
## install java
$ sudo update-alternatives --config java

There are 2 choices for the alternative java (providing /usr/bin/java).

  Selection    Path                                         Priority   Status
------------------------------------------------------------
  0            /usr/lib/jvm/java-21-openjdk-amd64/bin/java   2111      auto mode
* 1            /usr/lib/jvm/java-17-openjdk-amd64/bin/java   1711      manual mode
  2            /usr/lib/jvm/java-21-openjdk-amd64/bin/java   2111      manual mode

Press <enter> to keep the current choice[*], or type selection number: 1
```

### 1.2. Install JavaFX

ZAP GUI and Addons such as Browser-View requires JavaFX libs, don't included in since Java17.
They need to be installed and configured in order to be used from ZAP GUI and Addons.

* https://www.zaproxy.org/docs/desktop/addons/browser-view/

```sh
## install javafx
sudo apt -y install openjfx libopenjfx-java libopenjfx-jni

## check javafx
find /usr/share -name "javafx.web.jar"
find /usr/share -name "javafx.swing.jar"

## javafx module should be under openjfx/
ls /usr/share/openjfx/lib/

javafx.base.jar  javafx.controls.jar  javafx.fxml.jar  javafx.graphics.jar  javafx.media.jar  javafx.properties  javafx.swing.jar  javafx.web.jar  src.zip
```

### 1.3. Install Linux GTK libs

If running ZAP GUI in Linux, then ZAP tries to load GTK module, if ZAP doesn't find, then It'll show a warning or error message. To avoid that, install those libs:

```sh
sudo apt -y install libcanberra-gtk-module libcanberra-gtk3-module
```

## 2. Installation of ZAP

### 2.1. Download official tar file

* From https://www.zaproxy.org/download/

### 2.2. Extract and copy it

* To `/usr/share/zap/`

```sh
cd ~/Downloads
tar -xzf ZAP_2.16.1_Linux.tar.gz
sudo mv ZAP_2.16.1 /usr/share/zap
```

### 2.3. Create a launcher link 

* `/usr/bin/zap/`

```sh
sudo ln -sf /usr/share/zap/zap.sh /usr/bin/zaproxy
```

### 2.4. Update ZAP script to force loading JavaFX modules

**Update the `/usr/share/zap/zap.sh` script to force loading JavaFX modules**

At the end of `zap.sh` add the next lines.

```sh
sudo nano /usr/share/zap/zap.sh

...
...
# Start ZAP; it's likely that -Xdock:icon would be ignored on other platforms, but this is known to work
if [ "$OS" = "Darwin" ]; then
  # It's likely that -Xdock:icon would be ignored on other platforms, but this is known to work
  exec java ${JMEM} ${JAVAGC} ${JAVADEBUG} -Xdock:icon="../Resources/ZAP.icns" -jar "${BASEDIR}/zap-2.16.1.jar" "${ARGS[@]}"
else
  #### Forcing to load JavaFX modules
  PATH_JAVAFX_MOD="--module-path /usr/share/openjfx/lib --add-modules javafx.controls,javafx.fxml,javafx.web,javafx.swing"
  exec java ${JMEM} ${JAVAGC} ${JAVADEBUG} ${PATH_JAVAFX_MOD} -jar "${BASEDIR}/zap-2.16.1.jar" "${ARGS[@]}"
fi
```

### 2.5. Add ZAP Application Icon

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

## 3. From supported Opensource repo (Alternative)

1. Download deb file from https://software.opensuse.org/download.html?project=home%3Acabelo&package=zap
2. Install and run it
```sh
cd ~/Downloads/
sudo dpkg -i zap_2.16.1-1_amd64.deb
zapproxy
```
