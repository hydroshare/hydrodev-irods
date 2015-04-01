# hydrodev-irods

## Developer's Guide

### VirtualBox

1. Go to [http://distribution.hydroshare.org/public_html/hydrodev-irods/](http://distribution.hydroshare.org/public_html/hydrodev-irods/)
2. Download the most recent **hydrodev-irods-v4.03-mm-dd-yyyy.ova** file
3. From VirtualBox
    - Select `File > Import Appliance`
    - Select the **hydrodev-irods-mm-dd-yyyy.ova** you just downloaded
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

Get adapter information

`$ ifconfig -a`

```
TODO - add output
```

## Boost Install

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