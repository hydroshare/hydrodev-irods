#!/bin/bash

# set-hydrodev-irods-adapater.sh

if [ ! ${1} ]; then
	echo "*** Usage: sudo sh set-hydrodev-irods-adapater.sh ADAPTER ***"
fi

IFCGFILE="ifcfg-${1}"
TYPE=$(ifconfig -a | grep ${1} | tr -s ' ' | cut -d ' ' -f 3 | cut -d ':' -f 2)
HWADDR=$(ifconfig -a | grep ${1} | tr -s ' ' | cut -d ' ' -f 5)
UUID=$(uuidgen ${1})

cd /etc/sysconfig/network-scripts/

if [ -e ${IFCFGFILE} ]; then
	echo "*** Remove existing definition for ${IFCGFILE} ***"
	sudo rm ${IFCGFILE}
fi

sudo echo "*** Create definition for ${IFCGFILE} ***"
sudo echo "DEVICE=${1}" > $IFCGFILE
sudo echo "HWADDR=${HWADDR}" >> $IFCGFILE
sudo echo "TYPE=${TYPE}" >> $IFCGFILE
sudo echo "UUID=${UUID}" >> $IFCGFILE
sudo echo "NM_CONTROLLED=yes" >> $IFCGFILE
sudo echo "ONBOOT=yes" >> $IFCGFILE
sudo echo "BOOTPROTO=dhcp" >> $IFCGFILE

sleep 1
sudo cat ${IFCGFILE}

echo "*** Restart network service ***"
sudo service network restart

echo "*** FINISHED SCRIPT set-hydrodev-irods-adapater.sh ***"
exit;
