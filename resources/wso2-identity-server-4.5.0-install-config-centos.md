## INSTALLATION AND CONFIGURATION OF WSO2 IDENTITY SERVER 4.5.0 ON CENTOS 6


__1. Disable IPv6__

- Add a new file /etc/modprobe.d/ipv6-off.conf containing:

```sh
alias net-pf-10 off
alias ipv6 off
```

- Edit /etc/sysconfig/network and add a line:

```sh
NETWORKING_IPV6=no
```

- Disable ip6tables

```sh
# chkconfig ip6tables off
# echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
# /etc/init.d/network restart
```

- Check if IPv6 has been disabled. Use 'ifconfig' to check it ('inet6 addr: fe80::40bc:f4ff:fea7:5fe/64 Scope:Link' message should not appear)

__2. Download WSO2 Identity Server__

```sh
wget -bqc --user-agent="testuser" --referer="http://connect.wso2.com/wso2/getform/reg/new_product_download" http://dist.wso2.org/products/identity-server/4.5.0/wso2is-4.5.0.zip
```

__3. Unzip WSO2IS to '/opt/'__

```sh
# unzip wso2is-4.5.0.zip -d /opt/
```

__4. Install or update Java__

- OpenJDK

```sh
# yum list \*java-1\* | grep open
Failed to set locale, defaulting to C
java-1.6.0-openjdk.x86_64            1:1.6.0.0-1.62.1.11.11.90.el6_4    @updates
java-1.6.0-openjdk.x86_64            1:1.6.0.0-1.65.1.11.14.el6_4       updates 
java-1.6.0-openjdk-demo.x86_64       1:1.6.0.0-1.65.1.11.14.el6_4       updates 
java-1.6.0-openjdk-devel.x86_64      1:1.6.0.0-1.65.1.11.14.el6_4       updates 
java-1.6.0-openjdk-javadoc.x86_64    1:1.6.0.0-1.65.1.11.14.el6_4       updates 
java-1.6.0-openjdk-src.x86_64        1:1.6.0.0-1.65.1.11.14.el6_4       updates 
java-1.7.0-openjdk.x86_64            1:1.7.0.45-2.4.3.2.el6_4           updates 
java-1.7.0-openjdk-demo.x86_64       1:1.7.0.45-2.4.3.2.el6_4           updates 
java-1.7.0-openjdk-devel.x86_64      1:1.7.0.45-2.4.3.2.el6_4           updates 
java-1.7.0-openjdk-javadoc.noarch    1:1.7.0.45-2.4.3.2.el6_4           updates 
java-1.7.0-openjdk-src.x86_64        1:1.7.0.45-2.4.3.2.el6_4           updates 

# yum install java-1.7.0-openjdk.x86_64 java-1.7.0-openjdk-devel.x86_64

# alternatives --config java

There are 2 programs which provide 'java'.

  Selection    Command
-----------------------------------------------
 + 1           /usr/lib/jvm/jre-1.6.0-openjdk.x86_64/bin/java
*  2           /usr/lib/jvm/jre-1.7.0-openjdk.x86_64/bin/java

Enter to keep the current selection[+], or type selection number: 2

# java -version
java version "1.7.0_45"
OpenJDK Runtime Environment (rhel-2.4.3.2.el6_4-x86_64 u45-b15)
OpenJDK 64-Bit Server VM (build 24.45-b08, mixed mode)
```

- Oracle JDK

```sh
# wget --no-check-certificate --no-cookies --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com" http://download.oracle.com/otn-pub/java/jdk/7u45-b18/jdk-7u45-linux-x64.rpm -O jdk-7u45-linux-x64.rpm
# rpm -Uvh jdk-7u45-linux-x64.rpm

# alternatives --install /usr/bin/java java /usr/java/jdk1.7.0_45/jre/bin/java 20000
# alternatives --install /usr/bin/jar jar /usr/java/jdk1.7.0_45/bin/jar 20000
# alternatives --install /usr/bin/javac javac /usr/java/jdk1.7.0_45/bin/javac 20000
# alternatives --install /usr/bin/javaws javaws /usr/java/jdk1.7.0_45/jre/bin/javaws 20000

# alternatives --set java /usr/java/jdk1.7.0_45/jre/bin/java
# alternatives --set javaws /usr/java/jdk1.7.0_45/jre/bin/javaws
# alternatives --set javac /usr/java/jdk1.7.0_45/bin/javac
# alternatives --set jar /usr/java/jdk1.7.0_45/bin/jar
```

check if Java was configured successfully:
```sh
# ls -lA /etc/alternatives/
```

or

```sh
# alternatives --config java
There are 2 programs which provide 'java'.

  Selection    Command
-----------------------------------------------
   1           /usr/lib/jvm/jre-1.6.0-openjdk.x86_64/bin/java
*+ 2           /usr/java/jdk1.7.0_45/jre/bin/java

Enter to keep the current selection[+], or type selection number: 2
```

or

```sh
# java -version
java version "1.7.0_45"
Java(TM) SE Runtime Environment (build 1.7.0_45-b18)
Java HotSpot(TM) 64-Bit Server VM (build 24.45-b08, mixed mode)
[root@chk-appfactory1 tempo-files]# 
```

__5. Update JAVA_HOME__

```sh
# nano /root/.bashrc 

# .bashrc

# User specific aliases and functions

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

#### My user specific aliases and functions
export JAVA_HOME=/usr/lib/jvm/jre-1.7.0-openjdk.x86_64
export PATH=${JAVA_HOME}/bin:${PATH}
```

__6. Run WSO2 Identity Server__

- Follow WSO2's observations:

"We do not recommend starting WSO2 products as a daemon, because there is a known issue that causes automatic restarts in the wrapper mode. Instead, you can configure the heap memory allocations in the wso2server.sh script and run it using the nohup command."

```sh
# nohup ./wso2server.sh &

# netstat -tulap
Active Internet connections (servers and established)
Proto Recv-Q Send-Q Local Address               Foreign Address             State       PID/Program name   
tcp        0      0 *:distinct                  *:*                         LISTEN      1411/java           
tcp        0      0 *:46898                     *:*                         LISTEN      1411/java           
tcp        0      0 *:10389                     *:*                         LISTEN      1411/java           
tcp        0      0 *:ssh                       *:*                         LISTEN      1361/sshd           
tcp        0      0 localhost:smtp              *:*                         LISTEN      1276/master         
tcp        0      0 *:tungsten-https            *:*                         LISTEN      1411/java           
tcp        0      0 *:9763                      *:*                         LISTEN      1411/java           
tcp        0      0 localhost:10500             *:*                         LISTEN      1411/java           
tcp        0      0 *:vce                       *:*                         LISTEN      1411/java           
tcp        0      0 chk-ldap1:57447             chk-ldap1:vce               TIME_WAIT   -                   
tcp        0      0 localhost:59786             localhost:distinct          TIME_WAIT   -                   
tcp        0      0 localhost:39013             localhost:10389             TIME_WAIT   -                   
tcp        0      0 localhost:39014             localhost:10389             TIME_WAIT   -                   
tcp        0      0 localhost:39012             localhost:10389             TIME_WAIT   -                   
tcp        0      0 chk-ldap1:ssh               10.10.10.1:40254            ESTABLISHED 1365/sshd           
tcp        0      0 chk-ldap1:ssh               10.10.10.1:40255            ESTABLISHED 1493/sshd           
tcp        0      0 localhost:39011             localhost:10389             TIME_WAIT   -                   
tcp        0      0 chk-ldap1:52321             hans-moleman.w3.org:http    TIME_WAIT   -                   
udp        0      0 *:55983                     *:*                                     1411/java           
```

- Opened ports:

```sh
* 10389 -> ldap
* 9443  -> HTTPS
* 9763  -> HTTP
* 10500 -> Thrift entitlement service
* 11111 -> JNDI RMI
* 9999  -> JMX RMI
```

- For stop the service, to run this:

```sh
# ./wso2server.sh --stop
```

- Check WSO2 IS logs:

```sh
# tail -f nohup.out 
```

__7. Open ports if you are interested in connect to the services:__

- Add unfiltered port to iptables:

```sh
# nano /etc/sysconfig/iptables

# Firewall configuration written by system-config-firewall
# Manual customization of this file is not recommended.
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
-A INPUT -p icmp -j ACCEPT
-A INPUT -i lo -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 22 -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 10389 -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 9443 -j ACCEPT

-A INPUT -j REJECT --reject-with icmp-host-prohibited
-A FORWARD -j REJECT --reject-with icmp-host-prohibited
COMMIT
```

- restart iptables

```sh
# /etc/init.d/iptables restart
```

__7. Now, open the management console by a browser using this URL: `https://<ServerHost>:9443/carbon`__


__8. Configure WSO2 IS:__


8.1) General aspects
----------------------

- Solve UTF-8 encoding in SSH

```sh
# nano /etc/ssh/sshd_config
```

and disable this line 'AcceptEnv LANG LC_.....'

- Change the default port

```sh
# nano <PRODUCT_HOME>/repository/conf/carbon.xml

  <Ports>
	<Offset>0</Offset>
	...
  </Port>
```

- Change the timeout of management console

```sh
# nano <PRODUCT_HOME>/repository/conf/tomcat/carbon/WEB-INF/web.xml

<session-config>
   <session-timeout>15</session-timeout>
</session-config>
```

8.2) Change WSO2 IS & LDAP creadentials
---------------------------------------

```sh
# nano /opt/wso2is-4.5.0/repository/conf/user-mgt.xml
```

by default the LDAP's admin credentials are "uid=admin,ou=system" with password "admin".
You have update or encrypt these values and other related to WSO2 Carbon. You should follow these PCI-DSS security best practices, also they are valid to enforce our platform:

http://blog.facilelogin.com/2013/11/achieving-pci-dss-compliancy-with-wso2.html

```
[...]
* Use Secure Vault to encrypt all the passwords in the following configuration files - and make sure all default passwords are being changed.
 CARBON_HOME/repository/conf/user-mgt.xml
 CARBON_HOME/repository/conf/carbon.xml
 CARBON_HOME/repository/conf/axis2/axis2.xml
 CARBON_HOME/repository/conf/datasources/master-datasources.xml
 CARBON_HOME/repository/conf/tomcat/catalina-server.xml

* Change the default ports. By default, WSO2 ESB runs on HTTPS port 9443  and HTTPport 9763 . Also, WSO2 ESB exposes services over 8243  and 8280 . To change the ports you can update the value of <Offset>  at CARBON_HOME/repository/conf/carbon.xml

* All connections to the user stores (LDAP / AD) should be over TLS.
[...]
```

8.3) Enable recovery password email-based notifications
--------------------------------------------------------

- Ref: http://docs.wso2.org/display/IS450/Recover+with+Notification

- Edit /opt/wso2is-4.5.0/repository/conf/security/identity-mgt.properties as follow:

```sh
# nano /opt/wso2is-4.5.0/repository/conf/security/identity-mgt.properties

[...]
Identity.Listener.Enable=true
Notification.Sending.Enable=true
Notification.Expire.Time=3                     # expire the recovery after 3 minutes.
Notification.Sending.Internally.Managed=true
UserAccount.Recovery.Enable=true
Captcha.Verification.Internally.Managed=false  # set this to true if you do not have existing captcha validation module
[...]
```

- Edit /opt/wso2is-4.5.0/repository/conf/email/email-admin-config.xml and define a email format with the type “passwordReset”, for example:

```sh
# nano  nano /opt/wso2is-4.5.0/repository/conf/email/email-admin-config.xml

[...]
<configurations>
  <configuration type="passwordReset">
  <targetEpr>https://localhost:8443/InfoRecoverySample/validate</targetEpr>
  <subject>CHAKRAY - Password Reset</subject>
  <body>
Hi {first-name}

We received a request to change the password on the {user-name} account
associated with this e-mail address. If you made this request, please
click the link below to securely change your password:

{password-reset-link}

If clicking the link doesn't seem to work, you can copy and paste the
link into your browser's address window.

If you did not request to have your {user-name} password reset, simply
disregard this email and no changes to your
account will be made.
  </body>
  <footer>
Best Regards,

Chakray	Consulting
Security Team
http://www.chakray.com
  </footer>
  <redirectPath>../admin-mgt/update_verifier_redirector_ajaxprocessor.jsp</redirectPath>
</configuration>
[...]
```

- Edit /opt/wso2is-4.5.0/repository/conf/axis2/axis2.xml and uncomment the following in the file and provide the necessary email settings:

```sh
# nano /opt/wso2is-4.5.0/repository/conf/axis2/axis2.xml

[...]
<transportSender name="mailto" class="org.apache.axis2.transport.mail.MailTransportSender">
    <parameter name="mail.smtp.from">sampleemail@intix.info</parameter>
    <parameter name="mail.smtp.user">sampleemail@intix.info</parameter>
    <parameter name="mail.smtp.password">mypassword</parameter>
    <parameter name="mail.smtp.host">smtp.gmail.com</parameter>
    <parameter name="mail.smtp.port">587</parameter>
    <parameter name="mail.smtp.starttls.enable">true</parameter>
    <parameter name="mail.smtp.auth">true</parameter>
</transportSender>
[...]
```

- Check access to "smtp.gmail.com" port 587

```sh
# telnet smtp.gmail.com 587
Trying 74.125.136.108...
Connected to smtp.gmail.com.
Escape character is '^]'.
220 mx.google.com ESMTP g7sm49842982eet.12 - gsmtp
^C
```

- Make visible Services & WSDL by changing to false:

```sh
# nano /opt/wso2is-4.5.0/repository/conf/carbon.xml 
[...]
<HideAdminServiceWSDLs>false</HideAdminServiceWSDLs>
[...]
```

This configuration will make visible all Webservices of WSO2 IS, as for example:
https://wso2is.chakray.com/services/AuthenticationAdmin?wsdl

- Test credentials recovery. You can try calling SOAP Recovery Service:

https://wso2is.chakray.com/services/UserInformationRecoveryService?wsdl

Hence the sequence of calls which the Calling Application must do is as follows for email-based recovery:

* getCaptcha() -­ Generates a captcha.
* verifyUser() -­ Validates the captcha answer and username and returns a new key.
* sendRecoveryNotification() -­ Send an email notification with a confirmation code to the user. Need to provide the key from previous call.
* getCaptcha() ­- Generates a captcha when the user clicks on the URL.
* verifyConfirmationCode() -­ Validates the captcha answer and confirmation code. This returns a key.
* updatePassword() -­ Updates the password in the system. Need to provide the key from previous call, new password and returns the status of the update, true or false.


8.4) Credential recover with secret questions
----------------------------------------------

* http://docs.wso2.org/display/IS450/Recover+with+Secret+Questions

8.5) User Account Recovery
--------------------------

This helps to recover the username of the account if the user has forgotten it.

* http://docs.wso2.org/display/IS450/User+Account+Recovery

8.6) Self Sign Up and Account Confirmation
-------------------------------------------

You can register a user and get the confirmation by the user through the email which helps to confirm an actual user.

* http://docs.wso2.org/display/IS450/Self+Sign+Up+and+Account+Confirmation


- Edit /opt/wso2is-4.5.0/repository/conf/security/identity-mgt.properties as follow:

```sh
# nano /opt/wso2is-4.5.0/repository/conf/security/identity-mgt.properties

[...]
Identity.Listener.Enable=true               		# was updated in point 8.2
Notification.Sending.Internally.Managed=true		# was updated in point 8.2
Authentication.Policy.Account.Lock.On.Creation=true
Notification.Expire.Time=3                          # was updated in point 8.2 (three minutes)
[...]
```

- Edit /opt/wso2is-4.5.0/repository/conf/email/email-admin-config.xml and configure the email template of type “accountConfirmation”.
- The following service API can be used for the sign up and confirmation: https://localhost:9443/services/UserInformationRecoveryService?wsdl.

For Self Sign Up:

* getUserIdentitySupportedClaims() ­- Set of claims to which the user profile details should be saved in the Identity Server.
* registerUser() -­ This registers a user in the system. You need to pass values like user name, password, claim attributes and values returned from the previous call and the tenant domain. The confirmation code is sent by email to the given email address.

For Confirm Account:

* getCaptcha() -­ Get the captcha for the current request.
* confirmUserSelfRegistration() -­ The confirmation code sent to user account, user name, captcha details and tenant domain needs to be passed to the call. Upon successful verification the account is unlocked. Also the verification status is returned to the caller.

- Test it!.



9. Managing LDAP Partitions in WSO2 IS
--------------------------------------

9.1.- Change default domain "dc=WSO2,dc=ORG", for example to "dc=CHAKRAY,dc=COM".

* http://stackoverflow.com/questions/19990594/how-to-change-primary-ldap-domain-of-wso2-is-4-5-0

- Replace "dc=wso2,dc=org" for "dc=foobar,dc=com" and "defaultRealmName=WSO2.ORG" for "defaultRealmName=FOOBAR.COM" in the following files:

```sh
IS_HOME/repository/conf/user-mgt.xml
IS_HOME/repository/conf/tenant-mgt.xml
IS_HOME/repository/conf/embedded-ldap.xml
```

- Delete the directory named "root" located in the IS_HOME/repository/data/org.wso2.carbon.directory .. so a fresh default partition will be created again at the restart.

- Restart WSO2 IS.
- Now, if you connect to WSO2IS' embedded LDAP (10389 port) using any LDAP client, you will see the new domain FOOBAR.COM instead of WSO2.ORG.

9.2.- Create a secondary LDAP domain with Read/Write mode with external Virtual LDAP (af.chakray.com)

* http://www.ldaptools.com/ldap-proxy.htm
* http://stackoverflow.com/questions/11687511/using-wso2-identity-server-for-two-ldap-servers?rq=1
* http://www.soasecurity.org/2012/11/multiple-user-store-manager-feature.html
* http://malalanayake.wordpress.com/2013/01/11/multiple-user-stores-configuration-in-wso2-identity-server/

```sh
Domain name: 			af.chakray.com
ConnectionName:			uid=admin,ou=system
ConnectionURL:			ldap://localhost:${Ports.EmbeddedLDAP.LDAPServerPort}
ConnectionPassword:		<current-admin-pwd>
UserSearchBase:			ou=people,ou=AppFactory,ou=Partitions,dc=CHAKRAY,dc=COM
Disabled:				No checked
UserNameListFilter:		(objectClass=person)
UserNameAttribute:		uid
UserNameSearchFilter:	(&(objectClass=person)(uid=?))
UserEntryObjectClass:	wso2Person
GroupEntryObjectClass:	groupOfNames
ReadGroups:				Checked
GroupSearchBase:		ou=groups,ou=AppFactory,ou=Partitions,dc=CHAKRAY,dc=COM
GroupNameAttribute:		cn
GroupNameListFilter:	(objectClass=groupOfNames)
MembershipAttribute:	member
GroupNameSearchFilter:	(&(objectClass=groupOfNames)(cn=?))
```

Optional:

```sh
MaxUserNameListLength:		100
MaxRoleNameListLength:		100
UserRolesCacheEnabled:		Checked
SCIMEnabled:				Unchecked
PasswordHashMethod:			SHA
UserDNPattern:				uid={0},ou=people,ou=AppFactory,ou=Partitions,dc=CHAKRAY,dc=COM
PasswordJavaScriptRegEx:	^[\S]{5,30}$
UserNameJavaScriptRegEx:	^[\S]{3,30}$
UserNameJavaRegEx:			[a-zA-Z0-9._-|//]{3,30}$
RoleNameJavaScriptRegEx:	^[\S]{3,30}$
RoleNameJavaRegEx:			[a-zA-Z0-9._-|//]{3,30}$
WriteGroups:				Cheked
EmptyRolesAllowed:			Checked
```

The config file of new user-store management will be created here: 
/opt/wso2is-4.5.0/repository/deployment/server/userstores/af_chakray_com.xml


9.3.- Create other secondary LDAP domain with Read/Write mode with external MySQL (db.intix.info)

* Do not forget copy mysql jdbc library  to '$IS_HOME/repository/components/lib' and run mysql.sql script to create all schema:
mysql -u username -p MY_DB < $IS_HOME/dbscripts/mysql.sql

- Add a new user and role with permissions=login to new secondary domain db.intix.info.

********* domain created does not shown in Apache Directyory Studio !!! Domain wso2.org is the unique domain?
- check my response in Stackoverflow



