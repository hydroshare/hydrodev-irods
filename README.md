# hydrodev-irods

## Developer's Guide

### VirtualBox

1. Go to [http://distribution.hydroshare.org/public_html/hydrodev-irods/](http://distribution.hydroshare.org/public_html/hydrodev-irods/)
2. Download the most recent **hydrodev-irods-vX.XX-mm-dd-yyyy.ova** file
3. From VirtualBox
    - Select `File > Import Appliance`
    - Select the **hydrodev-irods-vX.XX-mm-dd-yyyy.ova** you just downloaded
    - Check the box **Reinitialize the MAC address of all network cards**
    - Click `Import`
4. From VirtualBox Manager
    - Select the **hydrodev-irods** VM
    - Select `Settings > Network`
    - Set Adapter 1 to be Bridged Adapter
    - Click `OK`
    - NOTE - You could also generate a new **MAC Address** from here under the **Advaced** options
5. Start the VM
    - Click `Start`

  
### Setup VM 

Once the VM boots up and presents the login prompt, log in as user `hydro`

- user: **hydro**
- pass: **hydro**

The VM needs to have it's network connections configured for the network you are on as well as updating the iRODS and iDrop Web2 configuration files.

As user `hydro`

```
cd hydrodev-irods
ifconfig -a
... note the name of the adapter, i.e. eth1
sudo sh set-hydrodev-irods-adapter.sh eth1

ifconfig -a
... note the IP Address, i.e. 192.168.1.140
sudo sh init-hydrodev-irods.sh 192.168.1.140
```

**Example**

Running the `set-hydrodev-irods-adapter.sh` script:

```
$ cd /home/hydro/hydrodev-irods/
$ ifconfig -a
eth1      Link encap:Ethernet  HWaddr 08:00:27:11:53:A0
          BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:0 (0.0 b)  TX bytes:1419363 (0.0 b)

lo        Link encap:Local Loopback
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:929 errors:0 dropped:0 overruns:0 frame:0
          TX packets:929 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:521420 (509.1 KiB)  TX bytes:521420 (509.1 KiB)
          
$ sudo sh set-hydrodev-irods-adapter.sh eth1
[sudo] password for hydro:
*** Remove existing definition for ifcfg-eth1 ***
*** Create definition for ifcfg-eth1 ***
DEVICE=eth1
HWADDR=08:00:27:11:53:A0
TYPE=Ethernet
UUID=e224de4b-1d98-4839-8e52-f75f9004d584
NM_CONTROLLED=yes
ONBOOT=yes
BOOTPROTO=dhcp
*** Restart network service ***
Shutting down interface eth2:                              [  OK  ]
Shutting down loopback interface:                          [  OK  ]
Bringing up loopback interface:                            [  OK  ]
Bringing up interface eth1:
Determining IP information for eth1... done.
                                                           [  OK  ]
*** FINISHED SCRIPT set-hydrodev-irods-adapater.sh ***          
```

Running the `init-hydrodev-irods.sh` script:

```
$ ifconfig -a
eth1      Link encap:Ethernet  HWaddr 08:00:27:11:53:A0
          inet addr:192.168.1.140  Bcast:192.168.1.255  Mask:255.255.255.0
          inet6 addr: fe80::a00:27ff:fe11:53a0/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:7232 errors:0 dropped:0 overruns:0 frame:0
          TX packets:1261 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:1053620 (1.0 MiB)  TX bytes:1429068 (1.3 MiB)

lo        Link encap:Local Loopback
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:1439 errors:0 dropped:0 overruns:0 frame:0
          TX packets:1439 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:814777 (795.6 KiB)  TX bytes:814777 (795.6 KiB)

$ sudo sh init-hydrodev-irods.sh 192.168.1.140
[sudo] password for hydro:
*** Using 192.168.1.140 as the IP Address for hydrodev-irods ***
*** Replacing value of HYDRODEV_IRODS_IPADDR with 192.168.1.140 in /etc/idrop-web/idrop-web-config2.groovy ***
*** Replacing value of HYDRODEV_IRODS_IPADDR with 192.168.1.140 in /var/lib/irods/.irods/.irodsEnv ***
*** Stop tomcat server ***
Stopping Tomcat
Using CATALINA_BASE:   /opt/tomcat8
Using CATALINA_HOME:   /opt/tomcat8
Using CATALINA_TMPDIR: /opt/tomcat8/temp
Using JRE_HOME:        /usr
Using CLASSPATH:       /opt/tomcat8/bin/bootstrap.jar:/opt/tomcat8/bin/tomcat-juli.jar
*** Start tomcat server using IP Address 192.168.1.140 ***
Starting Tomcat
Using CATALINA_BASE:   /opt/tomcat8
Using CATALINA_HOME:   /opt/tomcat8
Using CATALINA_TMPDIR: /opt/tomcat8/temp
Using JRE_HOME:        /usr
Using CLASSPATH:       /opt/tomcat8/bin/bootstrap.jar:/opt/tomcat8/bin/tomcat-juli.jar
Tomcat started.
*** Completed ***

*** Wait a moment for the tomcat server to restart, then: ***

  1. go to http://192.168.1.140:8080/idrop-web2/login/login in your local browser

  2. Login as:
     User Name: hsproxy
     Password: proxywater1

*** FINISHED SCRIPT init-hydrodev-irods.sh ***
```

### Boot mode

1. **Standard** (need to run in this mode for initial setup)
    - Starts the VM and opens a standard terminal interface when the VirtualBox Manager `Start` icon is clicked
2. **Headless** (ensure VM is powered off prior to executing)
    - Starts the VM but does not expose a terminal of any kind
    - Command line option using `VBoxManage`
    - For **OS X** use: 
    
        ```
        $ VBoxManage startvm --type headless hydrodev-irods
        ```
    - For **Windows** use: 
    
        ```
        > "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" startvm --type headless hydrodev-irods
        ```


### Account Information

Pre-installed user accounts for managing various aspects of hydrodev-irods

1. Linux Accounts
    - user: `root`, password: **hydrodev** (root admin account)
    - user: `hydro`, password: **hydro**
    - user: `irods`, password: **aZ2cXKkKQNKYKHrS** (iRODS admin account)
2. iRODS Accounts
    - user: `irods`, password: **aZ2cXKkKQNKYKHrS** (iRODS admin account)
    - user: `hsproxy`, password: **proxywater1**
3. tomcat webserver Account
    - user: `admin`, password: **admin** (admin account)
        - URL: [http://HYDRODEV_IRODS_IPADDR:8080](http://HYDRODEV_IRODS_IPADDR:8080)
4. iDrop Web2 Account
    - user: `hsproxy`, password: **proxywater1** (iRODS account)
        - URL: [http://HYDRODEV_IRODS_IPADDR:8080/idrop-web2/login/login](http://HYDRODEV_IRODS_IPADDR:8080/idrop-web2/login/login) 

## Additional Developer Information

### HydroShare Configuration

In order to use this VM with your local HydroShare instance, you will need to modify a few of your repository files and then redeploy the application.

1. Use the `Dockerfile` named `Dockerfile.irods` to build in the appropriate iRODS related libraries
    - `$ cp Dockerfile.irods Dockerfile`
    
2. Make sure the `django_irods` app is available in `hydroshare/settings.py`
    - Open the `hydroshare/settings.py` file
    - Look in the section labeled `INSTALLED_APPS`
    - Make sure the line with `"django_irods",` is not commented out
    
3. Add the iRODS user information for hs_proxy in `hydroshare/local_settings.py`
    - Open the `hydroshare/local_settings.py` file
    - Look in the section labeled `# iRODS proxy user configuration`
    - Copy the following:
    
        ```
        # iRODS proxy user configuration
        USE_IRODS=True
        IRODS_ROOT='/tmp'
        IRODS_ICOMMANDS_PATH='/usr/bin'
        IRODS_HOST='HYDRODEV_IRODS_IPADDR'
        IRODS_PORT='1247'
        IRODS_DEFAULT_RESOURCE='hydrodevResc'
        IRODS_HOME_COLLECTION='/hydrodevZone/home/hsproxy'
        IRODS_CWD='/hydrodevZone/home/hsproxy'
        IRODS_ZONE='hydrodevZone'
        IRODS_USERNAME='hsproxy'
        IRODS_AUTH='proxywater1'
        IRODS_GLOBAL_SESSION=True
        ```
    - Replace `HYDRODEV_IRODS_IP` with the IP Address returned from running the `set-hydrodev-irods-adapter.sh` script
    
4. Build and deploy HydroShare using the `deploy-hs.sh` script
    - `$ sh deploy-hs.sh`



### Boost Install

Developers may want to install Boost for iRODS related development

The prerequisites have are already installed, so all you need to do is download the Boost files and install.

Install Boost by running the following commands as the `hydro` user:

```
$ cd /home/hydro/
$ wget http://sourceforge.net/projects/boost/files/boost/1.57.0/boost_1_57_0.tar.bz2
$ tar --bzip2 -xvf boost_1_57_0.tar.bz2
$ cd /home/hydro/boost_1_57_0
```
Copy/Paste the following as one command:

```
sed -e '1 i#ifndef Q_MOC_RUN' \
    -e '$ a#endif'            \
    -i boost/type_traits/detail/has_binary_operator.hpp &&
    
./bootstrap.sh --prefix=/usr &&
./b2 stage threading=multi link=shared
```

**NOTE - insufficient space on the VM to run full test suite** 

- To test the result, issue `pushd status; ../b2; popd`. A few tests may fail. They take a long time (more than 120 SBU) and use up to 40 GB of disk space. You can use the `-jN` switch to speed them up.

Now, as the `root` user:

```
./b2 install threading=multi link=shared
```