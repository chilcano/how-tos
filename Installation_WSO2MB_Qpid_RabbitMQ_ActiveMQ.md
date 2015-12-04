# Installation of WSO2 MB, Apache Qpid, RabbitMQ and Apache ActiveMQ on CentOS

This document explains the installation of the most used foss Message Brokers (WSO2 MB, Qpid, RabbitMQ, ActiveMQ) on CentosOS

## Updating CentOS and Java

```
# yum -y update
``

The current version of Java is:
```
[root@chk-bigdata1 ~]# java -version
java version "1.6.0_34"
OpenJDK Runtime Environment (IcedTea6 1.13.6) (rhel-1.13.6.1.el6_6-x86_64)
OpenJDK 64-Bit Server VM (build 23.25-b01, mixed mode)
```

Updating to Java 7:
```
# yum install java-1.7.0-openjdk.x86_64 java-1.7.0-openjdk-devel.x86_64
```

```
# alternatives --config java

There are 2 programs which provide 'java'.

  Selection    Command
-----------------------------------------------
   1           /usr/lib/jvm/jre-1.6.0-openjdk.x86_64/bin/java
*+ 2           /usr/lib/jvm/jre-1.7.0-openjdk.x86_64/bin/java

Enter to keep the current selection[+], or type selection number: 2
```

Remove older Java version:
```
# yum remove java-1.6.0-openjdk.x86_64
```

Check Java:
```
# java -version
java version "1.7.0_75"
OpenJDK Runtime Environment (rhel-2.5.4.0.el6_6-x86_64 u75-b13)
OpenJDK 64-Bit Server VM (build 24.75-b04, mixed mode)
```

<h2>Install WSO2 MB 2.2.0</h2>

1. Download WSO2 MB

<pre>
# wget --user-agent="testuser" --referer="http://connect.wso2.com/wso2/getform/reg/new_product_download" http://dist.wso2.org/products/message-broker/2.2.0/wso2mb-2.2.0.zip
</pre>

2. Change offset (+3)

<pre>
# nano /opt/wso2mb-2.2.0/repository/conf/carbon.xml
</pre>

3. Check JAVA_HOME in /root/.bash_profile

<pre>
export JAVA_HOME=/usr/lib/jvm/java-1.7.0-openjdk.x86_64
</pre>

After of updating, execute the shell script:
<pre>
# bash /root/.bash_profile
or
# cd /root
# . .bash_profile
</pre>

4. Start WSO2 MB

# nohup /opt/wso2mb-2.2.0/bin/wso2server.sh > /opt/wso2mb-220.log &
# tail -f /opt/wso2mb-220.log

5. Check WSO2 MB with this URL https://localhost:9446, by default the user/pwd is admin/admin


https://wso2mb.bizlife.org

6. Change the default password.

If you change the default admin password, then you should also change it in /opt/wso2mb-2.2.0/repository/conf/advanced/andes-virtualhosts.xml


<class>org.wso2.andes.server.store.CassandraMessageStore</class>
<username>admin</username>
<password>admin</password>


7. Restart WSO2MB.


Install RabbitMQ 3.4.4-1
==========================

Refs:
http://www.rabbitmq.com/install-rpm.html
https://www.digitalocean.com/community/tutorials/how-to-install-and-manage-rabbitmq


1. For CentOS 6 only, it is my case, install the EPEL-6 yum repo which contains Erlang R14B:

# rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
Retrieving http://dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
warning: /var/tmp/rpm-tmp.UGFkeO: Header V3 RSA/SHA256 Signature, key ID 0608b895: NOKEY
Preparing...                ########################################### [100%]
   1:epel-release           ########################################### [100%]

2. We are also enabling third party remi package repositories:

# rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
Retrieving http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
warning: remi-release-6.rpm: Header V3 DSA/SHA1 Signature, key ID 00f97f56: NOKEY
Preparing...                ########################################### [100%]
   1:remi-release           ########################################### [100%]


3. Download and install Erlang:

# yum install -y erlang

4. Download and install the latest RPM version of RabbitMQ available here http://www.rabbitmq.com/install-rpm.html

# cd /root/tempo-files
# wget http://www.rabbitmq.com/releases/rabbitmq-server/v3.4.4/rabbitmq-server-3.4.4-1.noarch.rpm
# rpm --import http://www.rabbitmq.com/rabbitmq-signing-key-public.asc
# yum install rabbitmq-server-3.4.4-1.noarch.rpm 

5. Enabling the RabbitMQ plugin Management Console.

# rabbitmq-plugins enable rabbitmq_management
The following plugins have been enabled:
  mochiweb
  webmachine
  rabbitmq_web_dispatch
  amqp_client
  rabbitmq_management_agent
  rabbitmq_management

Applying plugin configuration to rabbit@chk-bigdata1... failed.
 * Could not contact node rabbit@chk-bigdata1.
   Changes will take effect at broker restart.
 * Options: --online  - fail if broker cannot be contacted.
            --offline - do not try to contact broker.

6. Set RabbitMQ to start on boot, after this, restart the server.


# chkconfig rabbitmq-server on
# reboot

7. Check if RabbitMQ is running.

# service rabbitmq-server status
Status of node 'rabbit@chk-bigdata1' ...
Error: unable to connect to node 'rabbit@chk-bigdata1': nodedown

DIAGNOSTICS
-----------

attempted to contact: ['rabbit@chk-bigdata1']

rabbit@chk-bigdata1:
  * connected to epmd (port 4369) on chk-bigdata1
  * epmd reports: node 'rabbit' not running at all
                  no other nodes on chk-bigdata1
  * suggestion: start the node

current node details:
- node name: 'rabbitmqctl-1258@chk-bigdata1'
- home dir: /var/lib/rabbitmq
- cookie hash: 8u9IMKuHJe/4xUaw3FiTAw==


8. Start RabbitMQ and check the open ports.

# service rabbitmq-server start

# netstat -tulp
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address               Foreign Address             State       PID/Program name   
tcp        0      0 *:epmd                      *:*                         LISTEN      1270/epmd           
tcp        0      0 *:ssh                       *:*                         LISTEN      1099/sshd           
tcp        0      0 *:15672                     *:*                         LISTEN      1389/beam.smp       
tcp        0      0 localhost:smtp              *:*                         LISTEN      1176/master         
tcp        0      0 *:25672                     *:*                         LISTEN      1389/beam.smp       
tcp        0      0 *:ssh                       *:*                         LISTEN      1099/sshd           
tcp        0      0 localhost:smtp              *:*                         LISTEN      1176/master         
tcp        0      0 *:amqp                      *:*                         LISTEN      1389/beam.smp     

Where the open ports are:
- epmd
- 15672 : Management Console
- 25672
- amqp

9. Add a new Administrator user to get access remotely.

# rabbitmqctl add_user admin admin
Creating user "admin" ...
# rabbitmqctl set_user_tags admin administrator
Setting tags for user "admin" to [administrator] ...
# rabbitmqctl set_permissions -p / admin ".*" ".*" ".*"
Setting permissions for user "admin" in vhost "/" ...

10. Do not forget to open the port to get remotely access to RabbitMQ Management Console (port 15672)

# nano /etc/sysconfig/iptables
---.---
-A INPUT -m state --state NEW -m tcp -p tcp --dport 15672 -j ACCEPT
---.---

# /etc/init.d/iptables restart
iptables: Setting chains to policy ACCEPT: filter          [  OK  ]
iptables: Flushing firewall rules:                         [  OK  ]
iptables: Unloading modules:                               [  OK  ]
iptables: Applying firewall rules:                         [  OK  ]


11. Now open the RabbitMQ Management Console using this URL http://localhost:15672, where the administrator user and password are admin/admin.

12. Check again the RabbitMQ status


----.----
# service rabbitmq-server status
Status of node 'rabbit@chk-bigdata1' ...
[{pid,1281},
 {running_applications,
     [{rabbitmq_management,"RabbitMQ Management Console","3.4.4"},
      {rabbitmq_management_agent,"RabbitMQ Management Agent","3.4.4"},
      {rabbit,"RabbitMQ","3.4.4"},
      {os_mon,"CPO  CXC 138 46","2.2.7"},
      {rabbitmq_web_dispatch,"RabbitMQ Web Dispatcher","3.4.4"},
      {webmachine,"webmachine","1.10.3-rmq3.4.4-gite9359c7"},
      {mochiweb,"MochiMedia Web Server","2.7.0-rmq3.4.4-git680dba8"},
      {amqp_client,"RabbitMQ AMQP Client","3.4.4"},
      {xmerl,"XML parser","1.2.10"},
      {inets,"INETS  CXC 138 49","5.7.1"},
      {mnesia,"MNESIA  CXC 138 12","4.5"},
      {sasl,"SASL  CXC 138 11","2.1.10"},
      {stdlib,"ERTS  CXC 138 10","1.17.5"},
      {kernel,"ERTS  CXC 138 10","2.14.5"}]},
 {os,{unix,linux}},
 {erlang_version,
     "Erlang R14B04 (erts-5.8.5) [source] [64-bit] [smp:4:4] [rq:4] [async-threads:30] [kernel-poll:true]\n"},
 {memory,
     [{total,32924656},
      {connection_readers,0},
      {connection_writers,0},
      {connection_channels,0},
      {connection_other,5408},
      {queue_procs,91496},
      {queue_slave_procs,0},
      {plugins,650296},
      {other_proc,9372040},
      {mnesia,86712},
      {mgmt_db,270408},
      {msg_index,47296},
      {other_ets,1135016},
      {binary,77568},
      {code,17672100},
      {atom,1569041},
      {other_system,1947275}]},
 {alarms,[]},
 {listeners,[{clustering,25672,"::"},{amqp,5672,"::"}]},
 {vm_memory_high_watermark,0.4},
 {vm_memory_limit,1606639616},
 {disk_free_limit,50000000},
 {disk_free,23124770816},
 {file_descriptors,
     [{total_limit,924},{total_used,3},{sockets_limit,829},{sockets_used,1}]},
 {processes,[{limit,1048576},{used,196}]},
 {run_queue,0},
 {uptime,72172}]
----.----

13. If you are running RabbitMQ behind of Apache HTTP Proxy, I recommend to use this configuration:


----.----
<VirtualHost *:80>
        ServerName      rabbitmq.yourserver.org
        ServerAdmin     bigdata1-rabbitmq-adm@yourserver.org

        ErrorLog  "| /usr/sbin/rotatelogs /var/log/httpd/chk_bigdata1_rabbitmq.error.log.%Y-%m-%d 86400"
        CustomLog "| /usr/sbin/rotatelogs /var/log/httpd/chk_bigdata1_rabbitmq.access.log.%Y-%m-%d 86400" combined
       
        ProxyPreserveHost On
        ProxyRequests Off
        <Proxy *>
            Order deny,allow
            Allow from all
            Satisfy Any
        </Proxy>

        ######### To RabbitMQ Management Console
        # https://www.rabbitmq.com/management.html
        AllowEncodedSlashes On
        ProxyPass        /api    http://chk-bigdata1:15672/api  nocanon
        ProxyPass        /       http://chk-bigdata1:15672/  
        ProxyPassReverse /       http://chk-bigdata1:15672/
</VirtualHost>
----.----


Install Apache Qpid
====================

1) Qpid C++ 
===========
(ref: http://lanswer.blogspot.co.uk/2012/09/install-qpid-in-centos-6.html)

# yum install qpid-cpp-server
# nano /etc/qpidd.conf 

----.-----
# "qpidd --help" or "man qpidd" for more details.
cluster-mechanism=DIGEST-MD5 ANONYMOUS
auth=yes

port=5673
----.-----

# yum install qpid-tools
# yum install ruby-qpid
# chkconfig qpidd on
# service qpidd start

Check ports
# netstat -tulpn

Uninstall:
# yum erase qpid-cpp-server qpid-tools ruby-qpid


2) Qpid Java Broker 0.30 
=========================
(ref: http://qpid.apache.org/releases/qpid-0.30/java-broker/book/Java-Broker-Installation-InstallationUnix.html)


1. Download Qpid Java Broker 0.30 and unzip it under /opt/qpid-broker-0.30/

# wget http://apache.mirror.anlx.net/qpid/0.30/binaries/qpid-broker-0.30-bin.tar.gz
# tar -zxvf qpid-broker-0.30-bin.tar.gz

2. Set the working directory

# nano /root/.bash_profile 
-.-
# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/bin

export PATH

### Qpid
export JAVA_HOME=/usr/lib/jvm/java-1.7.0-openjdk.x86_64
export QPID_WORK=/opt/qpid-work
-.-

3. Define an initial configuration for Qpid by editing  ${qpid.work_dir}/config.json

All ports will be changed using an offset of +1

# nano /opt/qpid-work/config.json

----.----

{
  "name" : "${broker.name}",
  "modelVersion" : "2.0",
  "defaultVirtualHost" : "default",
  "authenticationproviders" : [ {
    "name" : "passwordFile",
    "type" : "PlainPasswordFile",
    "path" : "${qpid.work_dir}${file.separator}etc${file.separator}passwd",
    "preferencesproviders" : [ {
      "id" : "650a8339-2a4e-4fda-85bd-e0fe390e3d57",
      "name" : "fileSystemPreferences",
      "type" : "FileSystemPreferences",
      "path" : "${qpid.work_dir}${file.separator}user.preferences.json"
    } ]
  } ],
  "plugins" : [ {
    "type" : "MANAGEMENT-HTTP",
    "name" : "httpManagement"
  }, {
    "type" : "MANAGEMENT-JMX",
    "name" : "jmxManagement"
  } ],
  "ports" : [ {
    "name" : "AMQP",
    "port" : "5673",
    "authenticationProvider" : "passwordFile"
  }, {
    "name" : "HTTP",
    "port" : "8081",
    "authenticationProvider" : "passwordFile",
    "protocols" : [ "HTTP" ]
  }, {
    "name" : "JMX_CONNECTOR",
    "port" : "9100",
    "authenticationProvider" : "passwordFile",
    "protocols" : [ "JMX_RMI" ]
  }, {
    "name" : "RMI_REGISTRY",
    "port" : "9000",
    "protocols" : [ "RMI" ]
  } ],
  "virtualhostnodes" : [ {
    "name" : "default",
    "type" : "JSON",
    "virtualHostInitialConfiguration" : "{}",
    "lastUpdatedBy" : null,
    "lastUpdatedTime" : 1424822502962,
    "createdBy" : null,
    "createdTime" : 0
  } ]
}

----.----


4. Create a a plain password file as authentication provider for Qpid

# nano /opt/qpid-work/etc/passwd


5. Start and stop Qpid

# nohup /opt/qpid-broker-0.30/bin/qpid-server &
# /opt/qpid-broker-0.30/bin/qpid.stop


6. Check the logs:

# tail -1000f /opt/qpid-work/log/qpid.log 
2015-02-25 03:06:27,430 WARN  [main] (model.ConfiguredObjectTypeRegistry) - A class definition could not be found while processing the model for 'org.apache.qpid.server.virtualhostnode.berkeleydb.BDBHAVirtualHostNodeImpl': com/sleepycat/je/rep/StateChangeListener
2015-02-25 03:06:27,457 WARN  [main] (model.ConfiguredObjectTypeRegistry) - A class definition could not be found while processing the model for 'org.apache.qpid.server.virtualhost.berkeleydb.BDBHAVirtualHostImpl': com/sleepycat/je/rep/StateChangeListener
2015-02-25 03:06:27,838 INFO  [main] (broker.startup) - [Broker] BRK-1001 : Startup : Version: 0.30 Build: Unversioned directory
2015-02-25 03:06:27,838 INFO  [main] (broker.platform) - [Broker] BRK-1010 : Platform : JVM : Oracle Corporation version: 1.7.0_75-mockbuild_2015_01_20_23_39-b00 OS : Linux version: 2.6.32-504.8.1.el6.x86_64 arch: amd64
2015-02-25 03:06:27,839 INFO  [main] (broker.max_memory) - [Broker] BRK-1011 : Maximum Memory : 2,112,618,496 bytes
2015-02-25 03:06:27,943 INFO  [main] (configstore.created) - [Broker] [vh(/default)/ms(JsonFileConfigStore)] CFG-1001 : Created
2015-02-25 03:06:27,943 INFO  [main] (configstore.store_location) - [Broker] [vh(/default)/ms(JsonFileConfigStore)] CFG-1002 : Store location : /opt/qpid-work/default/config
2015-02-25 03:06:27,943 INFO  [main] (configstore.recovery_start) - [Broker] [vh(/default)/ms(JsonFileConfigStore)] CFG-1004 : Recovery Start
2015-02-25 03:06:27,949 INFO  [Broker-Configuration-Thread] (virtualhost.created) - [Broker] VHT-1001 : Created : default
2015-02-25 03:06:27,956 INFO  [main] (configstore.recovery_complete) - [Broker] [vh(/default)/ms(JsonFileConfigStore)] CFG-1005 : Recovery Complete
2015-02-25 03:06:27,973 INFO  [main] (exchange.created) - [Broker] EXH-1001 : Create : Durable Type: topic Name: amq.topic
2015-02-25 03:06:27,973 INFO  [main] (exchange.created) - [Broker] EXH-1001 : Create : Durable Type: fanout Name: amq.fanout
2015-02-25 03:06:27,973 INFO  [main] (exchange.created) - [Broker] EXH-1001 : Create : Durable Type: direct Name: amq.direct
2015-02-25 03:06:27,973 INFO  [main] (exchange.created) - [Broker] EXH-1001 : Create : Durable Type: headers Name: amq.match
2015-02-25 03:06:28,641 INFO  [main] (messagestore.created) - [Broker] [vh(/default)/ms(DerbyMessageStore)] MST-1001 : Created
2015-02-25 03:06:28,641 INFO  [main] (messagestore.store_location) - [Broker] [vh(/default)/ms(DerbyMessageStore)] MST-1002 : Store location : /opt/qpid-work/default/messages
2015-02-25 03:06:28,648 INFO  [main] (messagestore.recovery_start) - [Broker] [vh(/default)/ms(DerbyMessageStore)] MST-1004 : Recovery Start
2015-02-25 03:06:28,656 INFO  [main] (transactionlog.recovery_start) - [Broker] [vh(/default)/ms(DerbyMessageStore)] TXN-1004 : Recovery Start
2015-02-25 03:06:28,668 INFO  [main] (transactionlog.recovery_complete) - [Broker] [vh(/default)/ms(DerbyMessageStore)] TXN-1006 : Recovery Complete
2015-02-25 03:06:28,669 INFO  [main] (messagestore.recovered) - [Broker] [vh(/default)/ms(DerbyMessageStore)] MST-1005 : Recovered 0 messages
2015-02-25 03:06:28,669 INFO  [main] (messagestore.recovery_complete) - [Broker] [vh(/default)/ms(DerbyMessageStore)] MST-1006 : Recovery Complete
2015-02-25 03:06:28,682 INFO  [main] (broker.listening) - [Broker] BRK-1002 : Starting : Listening on TCP port 5673
2015-02-25 03:06:28,717 INFO  [main] (managementconsole.startup) - [Broker] MNG-1001 : JMX Management Startup
2015-02-25 03:06:28,725 INFO  [main] (managementconsole.listening) - [Broker] MNG-1002 : Starting : RMI Registry : Listening on port 9000
2015-02-25 03:06:28,742 INFO  [main] (managementconsole.listening) - [Broker] MNG-1002 : Starting : JMX RMIConnectorServer : Listening on port 9100
2015-02-25 03:06:28,742 INFO  [main] (managementconsole.ready) - [Broker] MNG-1004 : JMX Management Ready
2015-02-25 03:06:28,742 INFO  [main] (managementconsole.startup) - [Broker] MNG-1001 : Web Management Startup
2015-02-25 03:06:28,849 INFO  [main] (server.Server) - jetty-8.1.14.v20131031
2015-02-25 03:06:28,888 INFO  [main] (server.AbstractConnector) - Started SelectChannelConnector@0.0.0.0:8081
2015-02-25 03:06:28,889 INFO  [main] (managementconsole.listening) - [Broker] MNG-1002 : Starting : HTTP : Listening on port 8081
2015-02-25 03:06:28,890 INFO  [main] (managementconsole.ready) - [Broker] MNG-1004 : Web Management Ready
2015-02-25 03:06:28,890 INFO  [main] (broker.ready) - [Broker] BRK-1004 : Qpid Broker Ready

7. Now you can get access to Qpid Web Console using this URL http://localhost:8081

8. If you want to get access via Apache HTTP Proxy, then you Apache HTTP Proxy should has this virtualhost configuration:

---.---
### qpid.bizlife.org
<VirtualHost *:80>
        ServerName  qpid.bizlife.org
        ServerAdmin     bigdata1-qpid-adm@chakray.com

        ErrorLog  "| /usr/sbin/rotatelogs /var/log/httpd/chk_bigdata1_qpid.error.log.%Y-%m-%d 86400"
        CustomLog "| /usr/sbin/rotatelogs /var/log/httpd/chk_bigdata1_qpid.access.log.%Y-%m-%d 86400" combined

        RewriteEngine On
#        RewriteOptions Inherit

        RewriteCond %{REQUEST_URI} ^/$
        RewriteRule (.*) / [PT,L]
        ### Qpid requiere ProxyPreserveHost a "Off"
        ProxyPreserveHost Off
        ProxyRequests Off
        <Proxy *>
            Order deny,allow
            Allow from all
            Satisfy Any
        </Proxy>

        ######### To Qpid Web Console
        ProxyPass        / http://chk-bigdata1:8081/  nocanon
        ProxyPassReverse / http://chk-bigdata1:8081/
</VirtualHost>
---.---




Install Apache ActiveMQ 5.11.1
===============================

http://activemq.apache.org/activemq-5111-release.html

http://tecadmin.net/install-apache-activemq-on-centos-redhat-and-fedora/

1. Download and install it

# cd /opt
# wget http://mirror.catn.com/pub/apache/activemq/5.11.1/apache-activemq-5.11.1-bin.tar.gz 
# tar -zxvf apache-activemq-5.11.1-bin.tar.gz 

or

# mkdir -p /opt/activemq
# tar -zxvf apache-activemq-5.11.1-bin.tar.gz  -C /opt/activemq

2. Change ports to avoid conflicts with Qpid or RabbitMQ (just for AMQP port)

# nano /opt/apache-activemq-5.11.1/conf/activemq.xml 

and change the default port for the amqp transportConnector (5672)

[...]
        <!--
            The transport connectors expose ActiveMQ over a given protocol to
            clients and other brokers. For more information, see:

            http://activemq.apache.org/configuring-transports.html
        -->
        <transportConnectors>
            <!-- DOS protection, limit concurrent connections to 1000 and frame size to 100MB -->
            <transportConnector name="openwire" uri="tcp://0.0.0.0:61616?maximumConnections=1000&amp;wireFormat.maxFrameSize=104857600"/>
            <!-- transportConnector name="amqp" uri="amqp://0.0.0.0:5672?maximumConnections=1000&amp;wireFormat.maxFrameSize=104857600"/-->
            <transportConnector name="amqp" uri="amqp://0.0.0.0:5674?maximumConnections=1000&amp;wireFormat.maxFrameSize=104857600"/>
            <transportConnector name="stomp" uri="stomp://0.0.0.0:61613?maximumConnections=1000&amp;wireFormat.maxFrameSize=104857600"/>
            <transportConnector name="mqtt" uri="mqtt://0.0.0.0:1883?maximumConnections=1000&amp;wireFormat.maxFrameSize=104857600"/>
            <transportConnector name="ws" uri="ws://0.0.0.0:61614?maximumConnections=1000&amp;wireFormat.maxFrameSize=104857600"/>
        </transportConnectors>
[...]


3. Start ActiveMQ

# cd /opt/apache-activemq-5.11.1/bin
# ./activemq start

4. Verify if ActiveMQ is running


# netstat -tulpn 
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address               Foreign Address             State       PID/Program name   
tcp        0      0 0.0.0.0:4369                0.0.0.0:*                   LISTEN      1211/epmd           
tcp        0      0 0.0.0.0:22                  0.0.0.0:*                   LISTEN      1103/sshd           
tcp        0      0 0.0.0.0:15672               0.0.0.0:*                   LISTEN      16726/beam.smp      
tcp        0      0 127.0.0.1:25                0.0.0.0:*                   LISTEN      1180/master         
tcp        0      0 0.0.0.0:25672               0.0.0.0:*                   LISTEN      16726/beam.smp      
tcp        0      0 :::8081                     :::*                        LISTEN      2173/java           
tcp        0      0 :::10002                    :::*                        LISTEN      29822/java          
tcp        0      0 ::ffff:127.0.0.1:9045       :::*                        LISTEN      29822/java          
tcp        0      0 :::22                       :::*                        LISTEN      1103/sshd           
tcp        0      0 ::1:25                      :::*                        LISTEN      1180/master         
tcp        0      0 :::1883                     :::*                        LISTEN      9107/java           
tcp        0      0 ::ffff:127.0.0.1:7003       :::*                        LISTEN      29822/java          
tcp        0      0 :::8161                     :::*                        LISTEN      9107/java           
tcp        0      0 :::54083                    :::*                        LISTEN      9107/java           
tcp        0      0 :::8675                     :::*                        LISTEN      29822/java          
tcp        0      0 :::9446                     :::*                        LISTEN      29822/java          
tcp        0      0 :::9766                     :::*                        LISTEN      29822/java          
tcp        0      0 :::5672                     :::*                        LISTEN      16726/beam.smp      
tcp        0      0 :::9000                     :::*                        LISTEN      2173/java           
tcp        0      0 :::5673                     :::*                        LISTEN      2173/java           
tcp        0      0 :::5674                     :::*                        LISTEN      9107/java           
tcp        0      0 :::11114                    :::*                        LISTEN      29822/java          
tcp        0      0 :::5675                     :::*                        LISTEN      29822/java          
tcp        0      0 ::ffff:127.0.0.1:9163       :::*                        LISTEN      29822/java          
tcp        0      0 :::9100                     :::*                        LISTEN      2173/java           
tcp        0      0 :::61613                    :::*                        LISTEN      9107/java           
tcp        0      0 :::55341                    :::*                        LISTEN      29822/java          
tcp        0      0 :::61614                    :::*                        LISTEN      9107/java           
tcp        0      0 :::61616                    :::*                        LISTEN      9107/java           
udp        0      0 :::37246                    :::*                                    29822/java 


Where the ports are:
- 5674 is the new amqp port
- 61613 is the port for stomp service
- 61614 is the port for webservices
- 61616 is the port for ActiveMQ Broker
- 8161 is the ActiveMQ Web Admin Panel (http://localhost:8161/admin, with admin/admin as usr/pwd by default)


5. Open the port to get remotely access to ActiveMQ Web Admin Panel (port 8161)

# nano /etc/sysconfig/iptables

######### activemq
-A INPUT -m state --state NEW -m tcp -p tcp --dport 8161 -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 61616 -j ACCEPT

# /etc/init.d/iptables restart

6. If you have in the front of ActiveMQ Web Admin Panel a Web Proxy such as Apache HTTP, then you should have a configuration similar to following:


------.------
### activemq.bizlife.org
<VirtualHost *:80>
        ServerName      activemq.bizlife.org
        ServerAdmin     bigdata1-activemq-adm@chakray.com

        ErrorLog  "| /usr/sbin/rotatelogs /var/log/httpd/chk_bigdata1_activemq.error.log.%Y-%m-%d 86400"
        CustomLog "| /usr/sbin/rotatelogs /var/log/httpd/chk_bigdata1_activemq.access.log.%Y-%m-%d 86400" combined
       
        RewriteEngine On
        RewriteOptions Inherit

        ProxyPreserveHost On
        ProxyRequests Off
        <Proxy *>
            Order deny,allow
            Allow from all
            Satisfy Any
        </Proxy>

        ######### To ActiveMQ Web Admin Panel
        ProxyPass        / http://chk-bigdata1:8161/  retry=0 
        ProxyPassReverse / http://chk-bigdata1:8161/
</VirtualHost>
------.------


7. Access remotely to ActiveMQ Web Admin Console, you should see the following:


----- imagen ----


8. If ypu want change the default user/password, just update the jetty-realm.properties file:

# nano /opt/apache-activemq-5.11.1/conf/jetty-realm.properties 

-----.-----
# Defines users that can access the web (console, demo, etc.)
# username: password [,rolename ...]
admin: YOUR-NEW-PASSWORD, admin
user: user, user
-----.-----

9. Check the log file if you want check the activity on ActiveMQ:

# tail -1000f /opt/apache-activemq-5.11.1/data/activemq.log 

-== FIN ==-



