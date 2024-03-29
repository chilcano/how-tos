## Install AutoFirma Java App in Ubuntu 19.10

In order to work with it, you need a proper X.509 Certificate provided by Gencat CATCert (IdCAT), FNMT or Spanish e-DNI, and a Browser configured to work with Java App.

1. Download AutoFirma and unzip it:

https://firmaelectronica.gob.es/Home/Descargas.html

2. Try to install it:

```sh
$ sudo dpkg -i AutoFirma_1_6_5.deb
```

3. Fix broken install:
```sh
$ sudo apt --fix-broken install
```

4. Install Java as AutoFirma's dependencies:

- https://linuxconfig.org/how-to-install-java-on-ubuntu-19-10-eoan-ermine-linux

```sh
$ sudo apt install openjdk-14-jre-headless

$ java --version
openjdk 14-ea 2020-03-17
OpenJDK Runtime Environment (build 14-ea+18-Ubuntu-1)
OpenJDK 64-Bit Server VM (build 14-ea+18-Ubuntu-1, mixed mode, sharing)

$ sudo apt install openjdk-8-jdk
$ sudo update-alternatives --config java
There are 2 choices for the alternative java (providing /usr/bin/java).

  Selection    Path                                            Priority   Status
------------------------------------------------------------
* 0            /usr/lib/jvm/java-14-openjdk-amd64/bin/java      1411      auto mode
  1            /usr/lib/jvm/java-14-openjdk-amd64/bin/java      1411      manual mode
  2            /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java   1081      manual mode

Press <enter> to keep the current choice[*], or type selection number: 2
update-alternatives: using /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java to provide /usr/bin/java (java) in manual mode
```

5. Try to intall it again:

```sh
$ sudo dpkg -i AutoFirma_1_6_5.deb 
(Reading database ... 218055 files and directories currently installed.)
Preparing to unpack AutoFirma_1_6_5.deb ...
4819
Updating certificates in /etc/ssl/certs...
0 added, 0 removed; done.
Running hooks in /etc/ca-certificates/update.d...

done.
done.
Se ha borrado el certificado CA en el almacenamiento del sistema
Unpacking autofirma (1.6.5) over (1.6.5) ...
Desinstalación completada con exito
Setting up autofirma (1.6.5) ...
Feb 25, 2020 10:35:28 AM es.gob.afirma.standalone.configurator.AutoFirmaConfigurator <init>
INFO: Se configurara la aplicacion en modo nativo
Feb 25, 2020 10:35:28 AM es.gob.afirma.standalone.configurator.ConsoleManager getConsole
INFO: Se utilizara la consola de tipo I/O
Feb 25, 2020 10:35:28 AM es.gob.afirma.standalone.configurator.ConfiguratorLinux configure
INFO: Identificando directorio de aplicación...
Feb 25, 2020 10:35:28 AM es.gob.afirma.standalone.configurator.ConfiguratorLinux configure
INFO: Directorio de aplicación: /usr/lib/AutoFirma
Feb 25, 2020 10:35:28 AM es.gob.afirma.standalone.configurator.ConfiguratorLinux configure
INFO: Generando certificado para la comunicación con el navegador web...
WARNING: An illegal reflective access operation has occurred
WARNING: Illegal reflective access by org.spongycastle.jcajce.provider.drbg.DRBG (file:/usr/lib/AutoFirma/AutoFirmaConfigurador.jar) to constructor sun.security.provider.Sun()
WARNING: Please consider reporting this to the maintainers of org.spongycastle.jcajce.provider.drbg.DRBG
WARNING: Use --illegal-access=warn to enable warnings of further illegal reflective access operations
WARNING: All illegal access operations will be denied in a future release
Feb 25, 2020 10:35:29 AM es.gob.afirma.standalone.configurator.ConfiguratorLinux configure
INFO: Se guarda el almacén de claves en el directorio de instalación de la aplicación
Feb 25, 2020 10:35:29 AM es.gob.afirma.standalone.configurator.ConfiguratorLinux configure
INFO: Se va a instalar el certificado en el almacen de Mozilla Firefox
Feb 25, 2020 10:35:29 AM es.gob.afirma.standalone.configurator.ConfiguratorFirefoxLinux createScriptsToSystemKeyStore
INFO: Comprobamos que se encuentre certutil en el sistema
Feb 25, 2020 10:35:29 AM es.gob.afirma.standalone.configurator.ConfiguratorLinux configure
INFO: Fin de la configuración
Generacion de certificados
Instalacion del certificado CA en el almacenamiento de Firefox y Chrome
Updating certificates in /etc/ssl/certs...
1 added, 0 removed; done.
Running hooks in /etc/ca-certificates/update.d...

Adding debian:AutoFirma_ROOT.pem
done.
done.
Instalacion del certificado CA en el almacenamiento del sistema
Processing triggers for gnome-menus (3.32.0-1ubuntu1) ...
Processing triggers for desktop-file-utils (0.24-1ubuntu1) ...
Processing triggers for mime-support (3.63ubuntu1) ...
```
